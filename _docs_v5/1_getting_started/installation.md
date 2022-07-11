---
layout: docs
title: Installation
---

## Installing OpenC3

The following sections describe how to get OpenC3 installed on various operating systems. This document should help you setup you host machine to allow you to have a running version of OpenC3 in no time.

## Installing OpenC3 on Host Machines

### INSTALL

Install [Docker](https://docs.docker.com/get-docker/) and install [Docker Compose](https://docs.docker.com/compose/install/).

- Minimum Resources allocated to Docker: 8GB RAM, 1 CPU, 80GB Disk
- Recommended Resources allocated to Docker: 16GB RAM, 2+ CPUs, 100GB Disk
- Docker on Windows with WSL2:

  - WSL2 consumes 50% of total memory on Windows or 8GB, whichever is less. However, on Windows builds before 20175 (use `winver` to check) it consumes 80% of your total memory. This can have a negative effect on Windows performance!
  - On Windows builds < 20175 or for more fine grained control, create C:\\Users\\\<username\>\\[.wslconfig](https://docs.microsoft.com/en-us/windows/wsl/wsl-config). Suggested contents on a 32GB machine:

        [wsl2]
        memory=16GB
        swap=0

- Modifying Docker connection timeouts (very rarely needed):
  - Docker will close idle (no data) connections after a period of 5 minutes. If you want to support a OpenC3 configuration consisting of completely idle targets (no cmd/tlm) for greater than 5 minutes you can modify this setting. Find the file at C:\\Users\\\<username\>\\AppData\\Roaming\\Docker\\settings.json. Modify the value `vpnKitMaxPortIdleTime` to change the timeout. **Note:** 0 means no timeout (idle connections not dropped)

**Note:** As of December 2021 the OpenC3 Docker containers are based on the Alpine Docker image.

### DOWNLOAD

Download the latest OpenC3 5 from the Github [releases](https://github.com/OpenC3/openc3/releases).
You can also clone the master branch to get the latest updates.

### EXTRACT

Extract the archive somewhere on your host computer.

### ENVIRONMENT

The OpenC3 5 containers are designed to work and be built in the presence of an SSL Decryption device. To support this a cacert.pem file can be placed at the base of the OpenC3 5 project that includes any certificates needed by your organization. **Note**: If you set the path to the ssl file in the `SSL_CERT_FILE` environment variables the openc3 setup script will copy it and place it for the docker container to load.

<div class="note warning">
  <h5>SSL Issues</h5>
  <p style="margin-bottom:20px;">Increasingly organizations are using some sort of SSL decryptor device which can cause curl and other command line tools like git to have SSL certificate problems. If installation fails with messages that involve "certificate", "SSL", "self-signed", or "secure" this is the problem. IT typically sets up browsers to work correctly but not command line applications. Note that the file extension might not be .pem, it could be .pem, crt, .ca-bundle, .cer, .p7b, .p7s, or  potentially something else.</p>
  <p style="margin-bottom:20px;">The workaround is to get a proper local certificate file from your IT department that can be used by tools like curl (for example mine is at C:\Shared\Ball.pem). Doesn't matter just somewhere with no spaces.</p>
  <p style="margin-bottom:20px;">Then set the following environment variables to that path (ie. C:\Shared\Ball.pem)</p>

<p style="margin-left:20px;margin-bottom:20px;">
SSL_CERT_FILE<br/>
CURL_CA_BUNDLE<br/>
REQUESTS_CA_BUNDLE<br/>
</p>

<p style="margin-bottom:20px;">
Here are some directions on environment variables in Windows:
  <a href="https://www.computerhope.com/issues/ch000549.htm">
    Windows Environment Variables
  </a>
<br/>
You will need to create new ones with the names above and set their value to the full path to the certificate file.
</p>

<p style="margin-bottom:20px;">
  At Ball please contact
  <a href="mailto:support@openc3.com">
    support@openc3.com
  </a> for assistance.
</p>
</div>

<div class="note info">
  <h5>Offline Installation</h5>
  <p style="margin-bottom:20px;">If you're building in a offline environment or want to use a private Rubygems, NPM or APK server (e.g. Nexus), you can update the following environment variables: RUBYGEMS_URL, NPM_URL, APK_URL, and more in the <a href="https://github.com/OpenC3/openc3/blob/master/.env">.env</a> file. Example values:</p>

  <p style="margin-left:20px;margin-bottom:20px;">
    ALPINE_VERSION=3.15<br/>
    ALPINE_BUILD=0<br/>
    RUBYGEMS_URL=https://rubygems.org<br/>
    NPM_URL=https://registry.npmjs.org<br/>
    APK_URL=http://dl-cdn.alpinelinux.org<br/>
  </p>

  <p style="margin-bottom:20px;">Create a zip file which can be transferred by running <code>openc3.bat util zip</code></p>
  <p style="margin-bottom:20px;">If you're on Unix, once you unzip the file run the following: <code>find . -name "*.sh" | xargs chmod +x</code></p>
</div>

### RUN

Run `openc3.bat` start (Windows), or `openc3.sh` start (linux/Mac).

If you see an error indicating docker daemon is not running ensure Docker and Docker compose is installed and running. If it errors please try to run `docker --version` or `docker-compose --version` and try to run the start command again. If the error continues please include the version in your issue if you choose to create one.

`openc3.*` can help solve some of the short falls of docker-compose when building the containers.

`openc3.*` takes multiple arguments. Run with no arguments for help. An example run of openc3.bat with no arguments will show a usage guide.

```
.\openc3.bat
Usage: "openc3.bat" [start, stop, cleanup, build, run, deploy, util]
*  build: build the containers for openc3
*  start: run the docker containers for openc3
*  stop: stop the running docker containers for openc3
*  restart: stop and run the minimal docker containers for openc3
*  cleanup: cleanup network and volumes for openc3
...
```

### WAIT

OpenC3 5 will be built and when ready should be running (~15 mins for first run, ~2 for subsequent). Running `docker ps` can help show the running containers.

### CONNECT

Connect a web browser to http://localhost:2900.

### NEXT STEPS

Continue to [Getting Started]({{site.baseurl}}/docs/v5/gettingstarted).

---

### Feedback

<div class="note">
  <h5>Find a problem in the documentation?</h5>
  <p>
    Please <a
    href="{{ site.repository }}/issues/new/choose">create an issue</a> on
    GitHub describing what we can do to make it better.
  </p>
  <h5>Let us know what could be better!</h5>
  <p>
    Both using and hacking on OpenC3 should be fun, simple, and easy, so if for
    some reason you find it's a pain, please <a
    href="{{ site.openc3 }}/issues/new/choose">create an issue</a> on
    GitHub describing your experience so we can make it better.
  </p>
</div>
