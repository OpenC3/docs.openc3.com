---
layout: news_item
title: "OpenC3 COSMOS 5.1.0 Released"
date: 2022-11-17 6:00:00 -0700
author: ryanmelt
version: 5.1.0
categories: [release]
---

OpenC3 COSMOS 5.1.0 - Modern, Production Ready, Command and Control

Welcome to OpenC3 COSMOS 5.1.0!

The COSMOS name is back! We have completed an agreement to formally take over development of COSMOS and are now offering commercial licensing to customers who want the additional scaling and security functionality in our COSMOS Enterprise Edition, or for our COSMOS Base Edition if the AGPLv3 license doesn't work well for them.

5.1.0 is a major release with key new features and performance enhancements. It also marks the end of the developmental 5.0.x series, and indicates that OpenC3 COSMOS 5 is now fully production ready! Going forward all releases will follow a versioning convention where the second digit 5.X will change when breaking changes are introduced, and the third digit 5.X.Y will change for minor or non-breaking changes that should be backwards compatible.

This release is highlighted by the following major Improvements to logging, data reduction, and the streaming API:

- 4x less disk utilization.
  - With up to 5x less disk space required to store decommutated data, and an almost 2x reduction in the storage of raw data.
- Added a new Bucket class to allow direct bucket integrations with cloud providers without requiring Minio.
  - AWS will be supported in our Base Edition, and other clouds in our Enterprise Edition.
- Data reduction updated to log samples for all non-numeric items
  - This allows quick queries of every telemetry item in the COSMOS database
- Logging changed from "file per packet" to "file per target"
  - Greatly reduces the number of files generated and the number of files required to be accessed to playback all data
- Log files are now written in a buffered fashion that stores packets in guaranteed time order
- Log file format changes are not backwards compatible.
  - Older log files will need to be migrated to the new format to be accessed by the Streaming API. Please contact support@openc3.com if you would like help migrating existing log files

## Other Highlighted Improvements In This Release

- Telemetry value displays now turn purple to indicate stale values
- Added pause button to log messages in CmdTlmServer
- Removed the gems bucket in favor of the /gems shared folder
- Added support for OpenTelemetry and Jaeger to help debug mission specific performance issues
- Added the ability to create screens automatically for any packet with the New Screen button
- The API methods connect_interface and connect_router now support reinitializing with new parameters. This can allow changing IP addresses at runtime.
- Added the ability to open and close TlmViewer screens, from screens
- Packet received counts now survive restarts and continue where they left off
- User selectable colors for TlmGrapher items
- Added a QUIET command to the demo INST targets to allow running the demo without constant limits violations
- Numerous dependency updates

## Key Bug Fixes

- The Limits API is now fully functional. Previously enable/disable limits and set_limits were not taking effect.
- Setting TlmViewer widget widths now work correctly
- Removed an issue where ScriptRunner scripts could output too much to STDOUT causing crashes
- Fixed XTCE converter
- Removed partially implemented Admin plugin download button
- Fixed issues editing TlmViewer screens
- Fixed certain cases of decom of array items
- Moved blocking in get_packets to client side code to prevent long API calls

## All Pull Requests in this Release

- Add newlines to script runner logs by @jmthomas in [#190](https://github.com/OpenC3/cosmos/pull/190)
- Add params to connect_interface by @jmthomas in [#192](https://github.com/OpenC3/cosmos/pull/192)
- Set screen min height and width by @jmthomas in [#193](https://github.com/OpenC3/cosmos/pull/193)
- Stale indicator by @jmthomas in [#195](https://github.com/OpenC3/cosmos/pull/195)
- Reduce process output by @jmthomas in [#199](https://github.com/OpenC3/cosmos/pull/199)
- Implement OpenTelemetry tracing by @ryanmelt in [#194](https://github.com/OpenC3/cosmos/pull/194)
- Set received count in interface_microservice and inject_tlm by @jmthomas in [#197](https://github.com/OpenC3/cosmos/pull/197)
- Create new screen based on existing packet by @jmthomas in [#204](https://github.com/OpenC3/cosmos/pull/204)
- Allow user editing graph colors by @jmthomas in [#202](https://github.com/OpenC3/cosmos/pull/202)
- Improve package_audit and bump deps by @jmthomas in [#208](https://github.com/OpenC3/cosmos/pull/208)
- Use redis 5 gem by @jmthomas in [#211](https://github.com/OpenC3/cosmos/pull/211)
- Add QUIET command to demo by @jmthomas in [#210](https://github.com/OpenC3/cosmos/pull/210)
- Extract S3 code to Bucket by @jmthomas in [#217](https://github.com/OpenC3/cosmos/pull/217)
- Fix xtce_converter by @jmthomas in [#219](https://github.com/OpenC3/cosmos/pull/219)
- Fix bucket ENV, io_multiplexer, deploy script by @jmthomas in [#223](https://github.com/OpenC3/cosmos/pull/223)
- Bump deps by @jmthomas in [#232](https://github.com/OpenC3/cosmos/pull/232)
- Only publish 8000 chars to ScriptRunner log by @jmthomas in [#236](https://github.com/OpenC3/cosmos/pull/236)
- Remove admin Download button by @jmthomas in [#237](https://github.com/OpenC3/cosmos/pull/237)
- Indicate max notifications reached by @jmthomas in [#238](https://github.com/OpenC3/cosmos/pull/238)
- Remove procedures from gemspec by @jmthomas in [#239](https://github.com/OpenC3/cosmos/pull/239)
- Fix for packets not received by @jmthomas in [#240](https://github.com/OpenC3/cosmos/pull/240)
- Update scripts by @jmthomas in [#233](https://github.com/OpenC3/cosmos/pull/233)
- Target logging, Streaming API cleanup, Improved Log Message Component by @ryanmelt in [#227](https://github.com/OpenC3/cosmos/pull/227)
- Remove GEMS bucket. GemModel directly uses /gems volume instead by @ryanmelt in [#241](https://github.com/OpenC3/cosmos/pull/241)
- Fix reduction and logging extra nulls by @ryanmelt in [#242](https://github.com/OpenC3/cosmos/pull/242)
- Support for https and cloud storage by @jmthomas in [#243](https://github.com/OpenC3/cosmos/pull/243)
- Rebranding and license by @ryanmelt in [#244](https://github.com/OpenC3/cosmos/pull/244)
- Fix edit screen and 0 values by @jmthomas in [#250](https://github.com/OpenC3/cosmos/pull/250)
- Add open and close methods for screen by @jmthomas in [#251](https://github.com/OpenC3/cosmos/pull/251)
- Fix packet decom of array data by @jmthomas in [#247](https://github.com/OpenC3/cosmos/pull/247)
- Fix width height issues in widgets by @jmthomas in [#255](https://github.com/OpenC3/cosmos/pull/255)
- Fully functioning limits api distributed to decom microservice by @ryanmelt in [#254](https://github.com/OpenC3/cosmos/pull/254)
- Ensure graph color on initial items by @jmthomas in [#256](https://github.com/OpenC3/cosmos/pull/256)
- Bump loader-utils from 1.4.0 to 1.4.2 in /openc3-cosmos-init/plugins/openc3-tool-base by @dependabot in [#258](https://github.com/OpenC3/cosmos/pull/258)
- Bump terser from 5.12.1 to 5.15.1 in /openc3-cosmos-init/plugins/openc3-tool-base by @dependabot in [#261](https://github.com/OpenC3/cosmos/pull/261)
- Move get_packets blocking to client by @ryanmelt in [#257](https://github.com/OpenC3/cosmos/pull/257)
- Add OPENC3_DEPENDENCY_REGISTRY for non openc3 containers by @jmthomas in [#262](https://github.com/OpenC3/cosmos/pull/262)
- Fix screens, add closeAll, fix scroll widget by @jmthomas in [#264](https://github.com/OpenC3/cosmos/pull/264)
- Fix router/interface build with new params by @jmthomas in [#265](https://github.com/OpenC3/cosmos/pull/265)
- Use buffered packet log writer for log microservice by @ryanmelt in [#263](https://github.com/OpenC3/cosmos/pull/263)

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

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.0.11...v5.1.0)
