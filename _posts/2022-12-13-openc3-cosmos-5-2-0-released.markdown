---
layout: news_item
title: "OpenC3 COSMOS 5.2.0 Released"
date: 2022-12-13 6:00:00 -0700
author: ryanmelt
version: 5.2.0
categories: [release]
---

# OpenC3 COSMOS 5.2.0 - Modern, Production Ready, Command and Control

# Welcome to OpenC3 COSMOS 5.2.0!

## RAM Utilization Reduced 2-3x

This release reduces total RAM utilization by 2-3x by combining the different microservices that support each target and each scope into a new single "multi" microservice. Each individual ruby interpreter uses 50-60Mb of RAM so this can save up to 300Mb of RAM per target, and up to 200Mb of RAM per scope over previous versions! Microservices can still be broken out with new keywords in plugin.txt if more performance is needed. Running COSMOS with our demo application now only uses about 1.3Gb of RAM.

## Targets Can be Mapped to Multiple Interfaces

Another key feature of this release is that Targets can now be mapped to multiple interfaces. Typically this can be used to have a different interface for commands vs telemetry. Or it can be used to have multiple interfaces that can receive telemetry for a target. Sending commands to multiple interfaces is also supported, but generally not desirable.

## New Stash API

Scripts now have support for a new Stash API that allows saving state that can be retrieved by later runs of the same script (or other scripts). Data is stored and retrieved as key/value pairs.

## Other Highlighted Improvements In This Release

- Support variable command timeouts for long duration commands
- Improved Redis Debug Tab in Admin
- Added support for global subsettings
- Support DISABLE_MESSAGES for command states
- Support multiline strings in config files
- Made log buffer depths configurable
- Added support for offline_access_token api to support Enterprise edition
- Added a new migration system to support upgrades between versions
- Improved cleanup microservice efficiency
- Allow running scripts outside of lib and procedure folders
- Added new plugin.txt keywords to breakout individual target microservices to support high load packets
- Updated dependency versions

## Key Bug Fixes

- Received time was being lost in the current value table for packets with a defined packet_time
- Fixed several potential errors that could occur in reducer
- Enforce that TlmViewer screen names must be lowercase
- Fixed a bug where out of time order packets could cause the creation of a huge number of log files

## All Pull Requests in this Release

- Disallow target_name & microservice_name as VARIABLE names by @jmthomas in [#278](https://github.com/OpenC3/cosmos/pull/278)
- Support newlines in script dialogs by @jmthomas in [#279](https://github.com/OpenC3/cosmos/pull/279)
- Only display targets with screens by @jmthomas in [#283](https://github.com/OpenC3/cosmos/pull/283)
- Tlm viewer env to scripts by @jmthomas in [#284](https://github.com/OpenC3/cosmos/pull/284)
- Add script filename to script runner log message filename by @jmthomas in [#289](https://github.com/OpenC3/cosmos/pull/289)
- Support variable cmd timeouts by @jmthomas in [#291](https://github.com/OpenC3/cosmos/pull/291)
- Change hazardous error code by @jmthomas in [#292](https://github.com/OpenC3/cosmos/pull/292)
- Switch from cli using base to operator by @jmthomas in [#298](https://github.com/OpenC3/cosmos/pull/298)
- Stash api by @jmthomas in [#300](https://github.com/OpenC3/cosmos/pull/300)
- Redis tab improvements by @jmthomas in [#306](https://github.com/OpenC3/cosmos/pull/306)
- Map targets to multiple interfaces and Migrations by @ryanmelt in [#308](https://github.com/OpenC3/cosmos/pull/308)
- Improve cache flags. Proper id on auth errors by @ryanmelt in [#309](https://github.com/OpenC3/cosmos/pull/309)
- Multi microservice by @ryanmelt in [#311](https://github.com/OpenC3/cosmos/pull/311)
- Add dialog validate by @jmthomas in [#312](https://github.com/OpenC3/cosmos/pull/312)
- Validate screen names and gem install local by @jmthomas in [#313](https://github.com/OpenC3/cosmos/pull/313)
- Update SETTING documentation by @jmthomas in [#316](https://github.com/OpenC3/cosmos/pull/316)
- Apply global subsettings along with global settings by @jmthomas in [#318](https://github.com/OpenC3/cosmos/pull/318)
- Disable message log for command states by @jmthomas in [#319](https://github.com/OpenC3/cosmos/pull/319)
- Support string concat in config files by @jmthomas in [#315](https://github.com/OpenC3/cosmos/pull/315)
- Set OPENC3_CLOUD default as local by @jmthomas in [#320](https://github.com/OpenC3/cosmos/pull/320)
- Fix packet time vs received time and remove dead code by @jmthomas in [#321](https://github.com/OpenC3/cosmos/pull/321)
- Bump dependencies by @jmthomas in [#322](https://github.com/OpenC3/cosmos/pull/322)
- offline access token, logger per microservice, no-store by @ryanmelt in [#324](https://github.com/OpenC3/cosmos/pull/324)
- Fix removed TIMEFORMATTED and ace build by @jmthomas in [#325](https://github.com/OpenC3/cosmos/pull/325)
- Configurable buffer depth. Out of order error instead of new file by @ryanmelt in [#327](https://github.com/OpenC3/cosmos/pull/327)
- Reducer nil checks by @ryanmelt in [#329](https://github.com/OpenC3/cosmos/pull/329)
- Limit total in list_files_before_time by @jmthomas in [#326](https://github.com/OpenC3/cosmos/pull/326)
- No to_json in as_json by @ryanmelt in [#331](https://github.com/OpenC3/cosmos/pull/331)
- Change default command buffer depth to 5 by @ryanmelt in [#332](https://github.com/OpenC3/cosmos/pull/332)
- Don't filter scripts to lib and procedures by @jmthomas in [#335](https://github.com/OpenC3/cosmos/pull/335)
- Better Checking for good offline_access token and clearing if bad by @ryanmelt in [#336](https://github.com/OpenC3/cosmos/pull/336)
- Add Reducer check for file retrieve by @ryanmelt in [#337](https://github.com/OpenC3/cosmos/pull/337)
- Fix reducer unit test by @jmthomas in [#338](https://github.com/OpenC3/cosmos/pull/338)
- Add variable File Suffix to files_between_time by @ryanmelt in [#339](https://github.com/OpenC3/cosmos/pull/339)

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

**Full Changelog**: [Changelog](https://github.com/OpenC3/openc3/compare/v5.1.1...v5.2.0)
