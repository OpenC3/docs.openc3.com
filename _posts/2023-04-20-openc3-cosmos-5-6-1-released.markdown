---
layout: news_item
title: "OpenC3 COSMOS 5.6.1 Released"
date: 2023-04-20 6:00:00 -0700
author: ryanmelt
version: 5.6.1
categories: [release]
---

# OpenC3 COSMOS 5.6.1 - Modern, Production Ready, Command and Control

Welcome to OpenC3 COSMOS 5.6.1!

This is a quick bug fix release to handle an issue users had upgrading from 5.5.x to 5.6.0.  Please skip 5.6.0 and upgrade directly to this release.  See the 5.6.0 release notes for the major new features in 5.6.x.

# Important Migration Note from 5.5.x

TlmViewer widgets had to be updated to support opening screens from ScriptRunner which caused a breaking change for any plugins containing a custom widget.   Plugins with a custom widget will need to update their package.json file to use @openc3/tool-common version 5.6.0 (or later), and be rebuilt/reinstalled.

# Important Bug Fixes
1. The migration script from 5.5.x to 5.6.0 was failing
2. The block widget now works correctly

## All Pull Requests in this Release
* Fix BlockWidget and update screen by @jmthomas in [#618](https://github.com/OpenC3/cosmos/pull/618)
* Combine log migrations by @jmthomas in [#626](https://github.com/OpenC3/cosmos/pull/626)

Prerequisites:
Docker - Running OpenC3 requires a working Docker or Podman installation. Typically Docker Desktop on Windows / Mac. Plain Docker or Podman also works on linux. We actively develop and run with Docker Desktop on Mac/Windows, and Linux on Raspberry Pi, so if you have any issues on another platform, please let us know by submitting a ticket!

Minimum Resources allocated to Docker: 4GB RAM, 1 CPU, 80GB Disk
Recommended Resources allocated to Docker: 16GB RAM, 2+ CPUs, 100GB Disk
Also requires docker compose version 1.27+

To Run:
* git clone https://github.com/openc3/cosmos-project.git cosmos-myproject
* cd cosmos-myproject
* Run Linux/Mac: ./openc3.sh run
* Run Windows: openc3.bat run
* Connect a web browser to [http://localhost:2900/](http://localhost:2900/)
* Have fun running OpenC3 COSMOS!

Please see our documentation at https://openc3.com

Try it out and let us know what you think! Please submit any issues as Github tickets, or any generic feedback to [support@openc3.com](mailto:support@openc3.com).

Thanks!

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.6.0...v5.6.1)

