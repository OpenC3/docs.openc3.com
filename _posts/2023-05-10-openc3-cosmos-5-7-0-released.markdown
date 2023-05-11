---
layout: news_item
title: "OpenC3 COSMOS 5.7.0 Released"
date: 2023-05-10 6:00:00 -0700
author: ryanmelt
version: 5.7.0
categories: [release]
---

# OpenC3 COSMOS 5.7.0 - Modern, Production Ready, Command and Control

Welcome to OpenC3 COSMOS 5.7.0!

## DataViewer Components
DataViewer is now customizable with custom components.  Add your own DataViewer widgets to display textual data for your targets!  See the demo plugin for examples.

## SLIP and COBS Protocols
New packet delineation protocols that have historically been used with serial interfaces.

## New download_file script method
Allows for easily downloading files from the browser in ScriptRunner.

## Metadata Improvements
Viewing, Editing, and Creating Metadata is now greatly improved

## Interface Modifiers
Interfaces (and Routers) can now take most of the same configuration options as microservices to allow for customizations such as setting specific environment variables for an interface.

## Other Interesting Changes
1. Graphs now pause when you zoom in
2. TableManager can now handle files with names different than the definition names
3. ValueWidgets in Telemetry Screens are now better justified

# Important Bug Fixes
1. ScriptRunner could write over original script with a subscript due to an autosave bug while running
2. TlmViewer width subsettings fixed

## All Pull Requests in this Release
* Slip protocol by @ryanmelt in [#634](https://github.com/OpenC3/cosmos/pull/634)
* Do not set width if subsetting given by @jmthomas in [#629](https://github.com/OpenC3/cosmos/pull/629)
* Show completed scripts when running script not found by @jmthomas in [#630](https://github.com/OpenC3/cosmos/pull/630)
* COBS Protocol by @ryanmelt in [#636](https://github.com/OpenC3/cosmos/pull/636)
* Improve COSMOS 4 migration by @jmthomas in [#632](https://github.com/OpenC3/cosmos/pull/632)
* Pause graph when clicking by @jmthomas in [#631](https://github.com/OpenC3/cosmos/pull/631)
* Table lookup matching definitions and then ask user by @jmthomas in [#633](https://github.com/OpenC3/cosmos/pull/633)
* Justify telemetry viewer widgets by @jmthomas in [#635](https://github.com/OpenC3/cosmos/pull/635)
* Limits monitor layout issues by @jmthomas in [#640](https://github.com/OpenC3/cosmos/pull/640)
* Add operator shutdown hook by @ryanmelt in [#643](https://github.com/OpenC3/cosmos/pull/643)
* Disable saving while running and fix filename dropdown by @jmthomas in [#651](https://github.com/OpenC3/cosmos/pull/651)
* Add download_file API by @jmthomas in [#648](https://github.com/OpenC3/cosmos/pull/648)
* Dataviewer components by @jmthomas in [#642](https://github.com/OpenC3/cosmos/pull/642)
* Metadata by @jmthomas in [#655](https://github.com/OpenC3/cosmos/pull/655)
* Interface modifiers and other fixes by @ryanmelt in [#656](https://github.com/OpenC3/cosmos/pull/656)
* Update javascript dependencies by @jmthomas in [#658](https://github.com/OpenC3/cosmos/pull/658)

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

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.6.1...v5.7.0)

