---
layout: news_item
title: "OpenC3 COSMOS 5.4.0 Released"
date: 2023-02-01 6:00:00 -0700
author: ryanmelt
version: 5.4.0
categories: [release]
---

# OpenC3 COSMOS 5.4.0 - Modern, Production Ready, Command and Control

# Welcome to OpenC3 COSMOS 5.4.0!

## Bucket Explorer

COSMOS now comes with a new tool called Bucket Explorer that allows browsing files in whatever bucket technology is being used. This provides a cross-cloud solution with a Minio Console-like interface.

## Metrics

The CmdTlmServer Status tab now includes a curated list of metrics that can be useful to monitor the health of COSMOS. Includes various counters and latency measurements.

## Navigation Categories

The Navigation bar can now be organized into Categories that can be collapsed and expanded.

## Permissions Updates to Better Support Local Mode on Linux

Updates to openc3.sh and compose.yaml to better support permissions when running using local mode on linux. This supports running from user ids other than 1000, and makes sure that files written to the host filesystem have the same user id as the user who is running COSMOS.

## Better Plugin Installation Errors

Plugin installation errors now include line numbers, and attempts to capture all installation errors, rather than just the first.

## Trivy, ClamAV, and CodeQL Scans

Our CI/CD process now includes Trivy scans for finding CVE vulnerabilities and ClamAV scans to check for Malware.

## Other Highlighted Improvements In This Release

- DataExtractor updated to handle very large lists of items
- CmdSender nows lists parameter ranges
- Several tools now remember pagination settings
- Always force an install of plugins if using the GUI
- Enabled/Disable limits from Details dialog

## Key Bug Fixes

- Removed UNKNOWN from CmdSender target list

## All Pull Requests in this Release

- Remove UNKNOWN from target chooser by @jmthomas in [#373](https://github.com/OpenC3/cosmos/pull/373)
- CmdSender display range, set default state value by @jmthomas in [#377](https://github.com/OpenC3/cosmos/pull/377)
- Save graph start/stop times in config by @jmthomas in [#378](https://github.com/OpenC3/cosmos/pull/378)
- Hide ignored, derived last, and \* derived by @jmthomas in [#374](https://github.com/OpenC3/cosmos/pull/374)
- Fix unknown in demo by @jmthomas in [#380](https://github.com/OpenC3/cosmos/pull/380)
- Fix github release if checks by @ryanmelt in [#381](https://github.com/OpenC3/cosmos/pull/381)
- Default PV rows to 20, max 1000, store choice to localStorage by @jmthomas in [#379](https://github.com/OpenC3/cosmos/pull/379)
- Support categories in AppNav by @jmthomas in [#384](https://github.com/OpenC3/cosmos/pull/384)
- Data Extractor DataTable instead of list by @jmthomas in [#387](https://github.com/OpenC3/cosmos/pull/387)
- Initial metrics framework by @ryanmelt in [#389](https://github.com/OpenC3/cosmos/pull/389)
- Bucket Explorer by @jmthomas in [#388](https://github.com/OpenC3/cosmos/pull/388)
- Various fixes found during tool documentation updates by @jmthomas in [#397](https://github.com/OpenC3/cosmos/pull/397)
- Check for bad value_type on packet read_item by @jmthomas in [#395](https://github.com/OpenC3/cosmos/pull/395)
- Minor bucket updates by @jmthomas in [#407](https://github.com/OpenC3/cosmos/pull/407)
- Updates for podman permissions by @ryanmelt in [#408](https://github.com/OpenC3/cosmos/pull/408)
- Remove initialize from Suite and Group by @jmthomas in [#399](https://github.com/OpenC3/cosmos/pull/399)
- Add line no & usage info to plugin error by @jmthomas in [#401](https://github.com/OpenC3/cosmos/pull/401)
- Describe changed plugin.txt on install by @jmthomas in [#423](https://github.com/OpenC3/cosmos/pull/423)
- Add first last page options by @jmthomas in [#418](https://github.com/OpenC3/cosmos/pull/418)
- Test trivy scan by @jmthomas in [#410](https://github.com/OpenC3/cosmos/pull/410)
- Always save when starting script, clear breakpoints by @jmthomas in [#416](https://github.com/OpenC3/cosmos/pull/416)
- Only enable Step while running, add step_mode, run_mode, show_backtrace by @jmthomas in [#421](https://github.com/OpenC3/cosmos/pull/421)
- Clamav Scans by @ryanmelt in [#427](https://github.com/OpenC3/cosmos/pull/427)
- Trivy scan local container builds by @jmthomas in [#429](https://github.com/OpenC3/cosmos/pull/429)
- Force install from Plugins tab, add MIT license to plugin template by @jmthomas in [#426](https://github.com/OpenC3/cosmos/pull/426)
- Prompt for cleanup by @jmthomas in [#422](https://github.com/OpenC3/cosmos/pull/422)
- Add :z and OPENC3_REGISTRY to cli by @jmthomas in [#417](https://github.com/OpenC3/cosmos/pull/417)
- Bump json5 from 1.0.1 to 1.0.2 in /openc3-cosmos-init/plugins by @dependabot in [#433](https://github.com/OpenC3/cosmos/pull/433)
- Bump decode-uri-component from 0.2.0 to 0.2.2 in /openc3-cosmos-init/plugins by @dependabot in [#432](https://github.com/OpenC3/cosmos/pull/432)
- Bump json5 from 1.0.1 to 1.0.2 in /openc3-cosmos-init/plugins/openc3-tool-base by @dependabot in [#431](https://github.com/OpenC3/cosmos/pull/431)
- Update dependencies by @jmthomas in [#434](https://github.com/OpenC3/cosmos/pull/434)
- Enable limits from DetailsDialog by @jmthomas in [#430](https://github.com/OpenC3/cosmos/pull/430)
- Support non-1000 user ids on linux with local mode by @ryanmelt in [#437](https://github.com/OpenC3/cosmos/pull/437)
- Add inject_tlm to javascript api by @ryanmelt in [#438](https://github.com/OpenC3/cosmos/pull/438)
- break out reducer microservice by default by @ryanmelt in [#439](https://github.com/OpenC3/cosmos/pull/439)
- Easier to click nav by @ryanmelt in [#441](https://github.com/OpenC3/cosmos/pull/441)
- Update demo microservices to inherit Microservice by @jmthomas in [#440](https://github.com/OpenC3/cosmos/pull/440)
- Simplify DEMO further with PORT by @jmthomas in [#442](https://github.com/OpenC3/cosmos/pull/442)
- Make sure other tools have offline access by @ryanmelt in [#443](https://github.com/OpenC3/cosmos/pull/443)

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

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.3.0...v5.4.0)
