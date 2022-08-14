---
layout: news_item
title: "OpenC3 5.0.8 Released"
date: 2022-08-13 6:00:00 -0700
author: ryanmelt
version: 5.0.8
categories: [release]
---

I'm happy to announce the third release of OpenC3!

## Key Enhancements
* New SPARKLINE telemetry screen widget
* Telemetry Screen Value Aging
* Updated Ruby / NPM dependency versions
* Added POSITION keyword for TOOLs to enforce position in Nav Bar
* Improved operator log messages

## Key Bug Fixes
* Fixed an issue with the UNKNOWN packet not showing
* Fixed an issue where the system didn't wait for a file to be fully available in S3
* Fixed Cmd/Tlm Packet counts in CmdTlmServer
* Fixed an issue where the Current Value Table would sometimes say packets don't exist

## Pull Request Links
* Create UNKNOWN target in scope_model by @jmthomas in [#54](https://github.com/OpenC3/openc3/pull/54)
* Fix linegraph widget and add sparkline by @jmthomas in [#52](https://github.com/OpenC3/openc3/pull/52)
* Fix permission names by @ryanmelt in [#53](https://github.com/OpenC3/openc3/pull/53)
* ValueWidget telemetry aging by @jmthomas in [#58](https://github.com/OpenC3/openc3/pull/58)
* Add put_object_and_check for S3 by @jmthomas in [#61](https://github.com/OpenC3/openc3/pull/61)
* Display correct CMD/TLM counts when sorting by @jmthomas in [#62](https://github.com/OpenC3/openc3/pull/62)
* Bump pysch, rdoc, dead_end by @jmthomas in [#64](https://github.com/OpenC3/openc3/pull/64)
* Add POSITION keyword for tools by @jmthomas in [#65](https://github.com/OpenC3/openc3/pull/65)
* Scope updates by @ryanmelt in [#63](https://github.com/OpenC3/openc3/pull/63)
* Print operator cmd in log by @jmthomas in [#66](https://github.com/OpenC3/openc3/pull/66)
* Update NPM dependencies by @jmthomas in [#67](https://github.com/OpenC3/openc3/pull/67)
* Move CvtModel back to Persistent Redis Store by @ryanmelt in [#68](https://github.com/OpenC3/openc3/pull/68)

## Upgrade Notes
This release requires reinstalling any plugins that include targets, because the Current Value Table moved between containers.

Prerequisites:
Docker - Running OpenC3 requires a working Docker or Podman installation. Typically Docker Desktop on Windows / Mac. Plain Docker or Podman also works on linux. We actively develop and run with Docker Desktop on Mac/Windows, and Linux on Raspberry Pi, so if you have any issues on another platform, please let us know by submitting a ticket!

Minimum Resources allocated to Docker: 4GB RAM, 1 CPU, 80GB Disk
Recommended Resources allocated to Docker: 16GB RAM, 2+ CPUs, 100GB Disk

To Run:
Download one of the archives (.zip or .tar.gz from the Github release page) [Download Release Here](https://github.com/OpenC3/openc3/releases/tag/v5.0.8)
Extract the archive somewhere on your host computer
Edit the .env file and change OPENC3_TAG to 5.0.8
Run Linux/Mac: ./openc3.sh run
Run Windows: openc3.bat run
Connect a web browser to [http://localhost:2900/](http://localhost:2900/)
Have fun running OpenC3!

Please see our documentation at https://openc3.com

Try it out and let us know what you think! Please submit any issues as Github tickets, or any generic feedback to [support@openc3.com](mailto:support@openc3.com).

Thanks!

**Full Changelog**: [Changelog](https://github.com/OpenC3/openc3/compare/v5.0.7...v5.0.8)
