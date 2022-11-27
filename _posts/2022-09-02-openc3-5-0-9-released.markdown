---
layout: news_item
title: "OpenC3 5.0.9 Released"
date: 2022-09-02 6:00:00 -0700
author: ryanmelt
version: 5.0.9
categories: [release]
---

OpenC3 5.0.9 is here and with it a great new feature called Local Mode!

Local mode defines a standard structure for your project's OpenC3 configuration, primarily plugins, and keeps it in sync with what you do through the web interface. It also encourages running from our official released containers, and not checking out the whole openc3 repo and building from source.

Local mode is best implemented using the project template now available at [https://github.com/OpenC3/cosmos-project](https://github.com/OpenC3/cosmos-project).

See getting started directions below.

## Key Enhancements

- Local Mode
- Open source dependency versions updated
- TlmViewer screen editor now has line numbers, syntax highlighting, and completion
- Improved COSMOS compatibility
- Browser tabs now show the tool name in the title
- Improved javascript API support for tlm methods
- map_target_to_interface implemented

## Key Bug Fixes

- Numerous fixes to CmdSender - Code now coverage at 94%
- Fix TlmViewer screen upload
- Fixed an issue with the Streaming api stopping too early

## Pull Request Links

- Add util pull and push to ghcr on release by @jmthomas in [#69](https://github.com/OpenC3/cosmos/pull/69)
- Add api highlighting by @jmthomas in [#70](https://github.com/OpenC3/cosmos/pull/70)
- Implement additional xtce keywords by @jmthomas in [#51](https://github.com/OpenC3/cosmos/pull/51)
- Bump alpine to 3.16.2 by @jmthomas in [#81](https://github.com/OpenC3/cosmos/pull/81)
- Add playwright as submodule by @jmthomas in [#82](https://github.com/OpenC3/cosmos/pull/82)
- Remove playwright submodule by @jmthomas in [#83](https://github.com/OpenC3/cosmos/pull/83)
- Upgrade to latest minio by @jmthomas in [#85](https://github.com/OpenC3/cosmos/pull/85)
- Add symlink to cosmos folder to increase compatibility by @ryanmelt in [#92](https://github.com/OpenC3/cosmos/pull/92)
- Set tab title to tool name by @jmthomas in [#94](https://github.com/OpenC3/cosmos/pull/94)
- Full tlm api support by @jmthomas in [#90](https://github.com/OpenC3/cosmos/pull/90)
- Implement map_target_to_interface by @ryanmelt in [#96](https://github.com/OpenC3/cosmos/pull/96)
- Suite detection by @jmthomas in [#98](https://github.com/OpenC3/cosmos/pull/98)
- Screen autocomplete by @jmthomas in [#97](https://github.com/OpenC3/cosmos/pull/97)
- Add summary to autocomplete and update summaries by @jmthomas in [#100](https://github.com/OpenC3/cosmos/pull/100)
- CmdSender state in history and hazardous indicator by @jmthomas in [#102](https://github.com/OpenC3/cosmos/pull/102)
- Command Sender fix quotes by @jmthomas in [#104](https://github.com/OpenC3/cosmos/pull/104)
- Fix tlm viewer screen upload by @jmthomas in [#114](https://github.com/OpenC3/cosmos/pull/114)
- Change scope localstorage by @ryanmelt in [#115](https://github.com/OpenC3/cosmos/pull/115)
- Implement header based interceptor control by @jmthomas in [#123](https://github.com/OpenC3/cosmos/pull/123)
- Add coverage upload by @jmthomas in [#119](https://github.com/OpenC3/cosmos/pull/119)
- Update dependencies by @jmthomas in [#126](https://github.com/OpenC3/cosmos/pull/126)
- Upgrade to rails 7 by @jmthomas in [#127](https://github.com/OpenC3/cosmos/pull/127)
- Local mode by @ryanmelt in [#103](https://github.com/OpenC3/cosmos/pull/103)
- Fix streaming api early stop by @ryanmelt in [#128](https://github.com/OpenC3/cosmos/pull/128)

Prerequisites:
Docker - Running OpenC3 requires a working Docker or Podman installation. Typically Docker Desktop on Windows / Mac. Plain Docker or Podman also works on linux. We actively develop and run with Docker Desktop on Mac/Windows, and Linux on Raspberry Pi, so if you have any issues on another platform, please let us know by submitting a ticket!

Minimum Resources allocated to Docker: 4GB RAM, 1 CPU, 80GB Disk
Recommended Resources allocated to Docker: 16GB RAM, 2+ CPUs, 100GB Disk

To Run:

- git clone https://github.com/OpenC3/cosmos-project.git myproject
- cd myproject
- Edit the .env file and change OPENC3_TAG to 5.0.9
- Run Linux/Mac: ./openc3.sh run
- Run Windows: openc3.bat run
- Connect a web browser to [http://localhost:2900/](http://localhost:2900/)
- Have fun running OpenC3!

Please see our documentation at https://openc3.com

Try it out and let us know what you think! Please submit any issues as Github tickets, or any generic feedback to [support@openc3.com](mailto:support@openc3.com).

Thanks!

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.0.8...v5.0.9)
