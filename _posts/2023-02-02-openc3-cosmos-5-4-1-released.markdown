---
layout: news_item
title: "OpenC3 COSMOS 5.4.1 Released"
date: 2023-02-02 6:00:00 -0700
author: ryanmelt
version: 5.4.1
categories: [release]
---

# OpenC3 COSMOS 5.4.1 - Modern, Production Ready, Command and Control

# Welcome to OpenC3 COSMOS 5.4.1!

## Patch Release

Add proper permission on linux to the openc3.sh cli command.
Fix for Suite Runner, internal suite detection

## All Pull Requests in this Release

- set user for cli by @ryanmelt in https://github.com/OpenC3/cosmos/pull/447
- Fix build_suites and add spec by @jmthomas in https://github.com/OpenC3/cosmos/pull/446

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

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.4.0...v5.4.1)
