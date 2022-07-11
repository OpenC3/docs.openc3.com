---
layout: docs
title: Developing OpenC3
toc: true
---

# Getting Started

So you want to help develop OpenC3? All of our open source OpenC3 code is on [Github](https://github.com/) so the first thing to do is get an [account](https://github.com/join). Next [clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) the [OpenC3](https://github.com/OpenC3/openc3) repository. We accept contributions from others as [Pull Requests](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests).

## Development Tools

The core OpenC3 team develops with the [Visual Studio Code](https://code.visualstudio.com/) editor and we highly recommend it. We also utilize a number of extensions including docker, kubernetes, gitlens, prettier, eslint, python, vetur, and ruby. We commit our `openc3.code-workspace` configuration for VSCode to help configure these plugins. You also need [Docker Desktop](https://www.docker.com/products/docker-desktop) which you should already have as it is a requirement to run OpenC3. You'll also need [NodeJS](https://nodejs.org/en/download/) and [yarn](https://yarnpkg.com/getting-started/install) installed.

# Building OpenC3

Note: We primarily develop OpenC3 in Windows so the commands here will reference batch files but the same files exist in Linux as shell scripts.

Build OpenC3 using the `openc3.bat` script:

    > openc3.bat build

This will pull all the OpenC3 container dependencies and build our local containers. Note: This can take a long time especially for your first build!

Once the build completes you can see the built images with the following command:

    > docker image ls | findstr "openc3"
    ballaerospace/openc3-operator            latest   4c71eea95327   41 minutes ago   130MB
    ballaerospace/openc3-init                latest   1c32f1969f48   41 minutes ago   142MB
    ballaerospace/openc3-cmd-tlm-api         latest   8a722d0403e9   51 minutes ago   150MB
    ballaerospace/openc3-script-runner-api   latest   a6d22f485c2a   52 minutes ago   146MB
    ballaerospace/openc3-redis               latest   6531a6973dc9   53 minutes ago   105MB
    ballaerospace/openc3-base                latest   04fd53ad0402   53 minutes ago   130MB
    ballaerospace/openc3-traefik             latest   3ffd53ad0402   53 minutes ago   130MB

# Running OpenC3

Running OpenC3 in development mode enables localhost access to internal API ports as well as sets `RAILS_ENV=development` in the cmd-tlm-api and script-runner-api Rails servers. To run in development mode:

    > openc3.bat dev

You can now see the running containers (I removed CONTAINER ID, CREATED and STATUS to save space):

    > docker ps
    IMAGE                                             COMMAND                  PORTS                      NAMES
    openc3/openc3-cmd-tlm-api:latest         "/sbin/tini -- rails…"   127.0.0.1:2901->2901/tcp   openc3_openc3-cmd-tlm-api_1
    openc3/openc3-script-runner-api:latest   "/sbin/tini -- rails…"   127.0.0.1:2902->2902/tcp   openc3_openc3-script-runner-api_1
    openc3/openc3-traefik:latest             "/entrypoint.sh trae…"   0.0.0.0:2900->80/tcp       openc3_openc3-traefik_1
    openc3/openc3-operator:latest            "/sbin/tini -- ruby …"                              openc3_openc3-operator_1
    openc3/openc3-minio:latest               "/usr/bin/docker-ent…"   127.0.0.1:9000->9000/tcp   openc3_openc3-minio_1
    openc3/openc3-redis:latest               "docker-entrypoint.s…"   127.0.0.1:6379->6379/tcp   openc3_openc3-redis_1

If you go to localhost:2900 you should see OpenC3 up and running!

## Running a Frontend Application

So now that you have OpenC3 up and running how do you develop an individual OpenC3 application?

1. Bootstrap the frontend with yarn

        openc3-init> yarn

1. Serve a local OpenC3 application (CmdTlmServer, ScriptRunner, etc)

        openc3-init> cd plugins/packages/openc3-tool-scriptrunner
        openc3-tool-scriptrunner> yarn serve

        DONE  Compiled successfully in 128722ms
        App running at:
        - Local:   http://localhost:2914/tools/scriptrunner/
        - Network: http://localhost:2914/tools/scriptrunner/

        Note that the development build is not optimized.
        To create a production build, run npm run build.


1. Set the [single SPA](https://single-spa.js.org/) override for the application

    Visit localhost:2900 and Right-click 'Inspect'<br>
    In the console paste:

        localStorage.setItem('devtools', true)

    Refresh and you should see `{...}` in the bottom right<br>
    Click the Default button next to the application (@openc3/tool-scriptrunner)<br>
    Paste in the development path which is dependent on the port returned by the local yarn serve and the tool name (scriptrunner)

        http://localhost:2914/tools/scriptrunner/js/app.js

1. Refresh the page and you should see your local copy of the application (Script Runner in this example). If you dynamically add code (like `console.log`) the yarn window should re-compile and the browser should refresh displaying your new code. It is highly recommended to get familiar with your browser's [development tools](https://developer.chrome.com/docs/devtools/overview/) if you plan to do frontend development.

## Running a Backend Server

If the code you want to develop is the cmd-tlm-api or script-runner-api backend servers there are several steps to enable access to a development copy.

1.  Run a development version of traefik. OpenC3 uses traefik to direct API requests to the correct locations.

        > cd openc3-traefik
        traefik> docker ps
        # Look for the container with name including traefik
        traefik> docker stop openc3_openc3-traefik_1
        traefik> docker build -f Dockerfile-dev -t openc3-traefik-dev .
        traefik> docker run --network=openc3_default -p 2900:80 -it --rm openc3-traefik-dev

1.  Run a local copy of the cmd-tlm-api or script-runner-api

        > cd openc3-cmd-tlm-api
        openc3-cmd-tlm-api> docker ps
        # Look for the container with name including cmd-tlm-api
        openc3-cmd-tlm-api> docker stop openc3_openc3-cmd-tlm-api_1
        # Set all the environment variables in the .env file
        openc3-cmd-tlm-api> bundle install
        openc3-cmd-tlm-api> bundle exec rails s

1. Once the `rails s` command returns you should see API requests coming from interations in the frontend code. If you add code (like Ruby debugging statements) to the cmd-tlm-api code you need to stop the server (CTRL-C) and restart it to see the effect.
