---
layout: news_item
title: "OpenC3 COSMOS 5.1.1 Released"
date: 2022-11-19 6:00:00 -0700
author: ryanmelt
version: 5.1.1
categories: [release]
---

OpenC3 COSMOS 5.1.1 - Modern, Production Ready, Command and Control

Welcome to OpenC3 COSMOS 5.1.1!

This release is quick patch release to address the following:

## Highlighted Improvements In This Release

- ScriptRunner scripts can now handle unicode characters
- Updated TextLogMicroservice to ensure a clean shutdown

## Key Bug Fixes

- Updated openc3.bat and openc3_util.bat to fix some issues on Windows with cli, cliroot, and util scripts

## All Pull Requests in this Release

- Windows cli use .env file by @ryanmelt in [#272](https://github.com/OpenC3/cosmos/pull/272)
- Clean shutdown for TextLogMicroservice. Don't enforce time ordering for text logs by @ryanmelt in [#274](https://github.com/OpenC3/cosmos/pull/274)
- Handle UTF8 strings better when JSON encoding by @ryanmelt in [#276](https://github.com/OpenC3/cosmos/pull/276)

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

**Full Changelog**: [Changelog](https://github.com/OpenC3/openc3/compare/v5.1.0...v5.1.1)
