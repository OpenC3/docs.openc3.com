---
layout: news_item
title: "OpenC3 COSMOS 5.5.1 Released"
date: 2023-02-26 6:00:00 -0700
author: ryanmelt
version: 5.5.1
categories: [release]
---

# OpenC3 COSMOS 5.5.1 - Modern, Production Ready, Command and Control

Welcome to OpenC3 COSMOS 5.5.1!

## Download Plugins from the Admin Tool

Now you can download installed plugins!

## Traefik changed from Redis to HTTP Endpoint

Traefik Redis support doesn't work with Redis Cluster, so we added an HTTP endpoint to our API to give Traefik dynamic configuration.

## Create Suites from Script Runner

New option to create a suite from the Script Runner menu.

## Updates to the Secrets Framework to Support a secret_store Key

Some secrets systems have a "container" for a grouping of secrets. Added a new secret_store key to the Secrets framework to support this.

## Important Bug Fixes

1. Multiple TlmViewer Widgets improved and bugs fixed

## All Pull Requests in this Release

- Download plugin by @jmthomas in [#513](https://github.com/OpenC3/cosmos/pull/513)
- Switch Traefik to HTTP endpoint for dynamic config by @ryanmelt in [#515](https://github.com/OpenC3/cosmos/pull/515)
- Add new test suite option by @jmthomas in [#514](https://github.com/OpenC3/cosmos/pull/514)
- Document all widgets, fix layout and setting issues by @jmthomas in [#512](https://github.com/OpenC3/cosmos/pull/512)
- Secrets update by @ryanmelt in [#516](https://github.com/OpenC3/cosmos/pull/516)

Prerequisites:
Docker - Running OpenC3 requires a working Docker or Podman installation. Typically Docker Desktop on Windows / Mac. Plain Docker or Podman also works on linux. We actively develop and run with Docker Desktop on Mac/Windows, and Linux on Raspberry Pi, so if you have any issues on another platform, please let us know by submitting a ticket!

Minimum Resources allocated to Docker: 4GB RAM, 1 CPU, 80GB Disk
Recommended Resources allocated to Docker: 16GB RAM, 2+ CPUs, 100GB Disk
Also requires docker compose version 1.27+

To Run:

- git clone https://github.com/openc3/cosmos-project.git cosmos-myproject
- cd cosmos-myproject
- Run Linux/Mac: ./openc3.sh run
- Run Windows: openc3.bat run
- Connect a web browser to [http://localhost:2900/](http://localhost:2900/)
- Have fun running OpenC3 COSMOS!

Please see our documentation at https://openc3.com

Try it out and let us know what you think! Please submit any issues as Github tickets, or any generic feedback to [support@openc3.com](mailto:support@openc3.com).

Thanks!

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.5.0...v5.5.1)
