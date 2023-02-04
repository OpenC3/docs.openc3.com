---
layout: news_item
title: "OpenC3 COSMOS 5.4.2 Released"
date: 2023-02-04 6:00:00 -0700
author: ryanmelt
version: 5.4.2
categories: [release]
---

# OpenC3 COSMOS 5.4.2 - Modern, Production Ready, Command and Control

# Welcome to OpenC3 COSMOS 5.4.2!

## Patch Release 2

Scripts Now Can List Set Overrides and Warn if Running with Telemetry Overrides
Fixed Regression in Minio Console
Command Only Targets Are Now Supported
Added a force option to openc3.sh cleanup to bypass the are you sure prompt

## All Pull Requests in this Release

- Script overrides by @jmthomas in [#450](https://github.com/OpenC3/cosmos/pull/450)
- Minio console working by @jmthomas in [#453](https://github.com/OpenC3/cosmos/pull/453)
- Handle command only target by @ryanmelt in [#455](https://github.com/OpenC3/cosmos/pull/455)

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

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.4.1...v5.4.2)
