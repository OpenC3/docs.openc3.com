---
layout: news_item
title: "OpenC3 5.0.7 Released"
date: 2022-08-04 6:00:00 -0700
author: ryanmelt
version: 5.0.7
categories: [release]
---

I'm happy to announce the second release of OpenC3!

## Key Enhancements

- The Admin Plugins Tab now gives feedback on plugin changes and allows downloading any changes made to plugins since they have been installed

## Key Bug Fixes

- Fixed an issue running the ./openc3.sh cli command
- Docker compose files updated to fix running in rootless Podman (and any SELinux environment)

## Pull Request Links

- fix typoes and references by @ryanmelt in [#40](https://github.com/OpenC3/cosmos/pull/40)
- Show modified targets and D/L modifications by @jmthomas in [#39](https://github.com/OpenC3/cosmos/pull/39)
- Support Selinux by @ryanmelt in [#41](https://github.com/OpenC3/cosmos/pull/41)
- Check for plugin mods on upgrade and delete by @jmthomas in [#42](https://github.com/OpenC3/cosmos/pull/42)
- Fixes and openc3cli changes to support enterprise by @ryanmelt in [#45](https://github.com/OpenC3/cosmos/pull/45)
- Fix deleting plugins with mods by @jmthomas in [#46](https://github.com/OpenC3/cosmos/pull/46)

Prerequisites:
Docker - Running OpenC3 requires a working Docker or Podman installation. Typically Docker Desktop on Windows / Mac. Plain Docker or Podman also works on linux. We actively develop and run with Docker Desktop on Mac/Windows, and Linux on Raspberry Pi, so if you have any issues on another platform, please let us know by submitting a ticket!

Minimum Resources allocated to Docker: 4GB RAM, 1 CPU, 80GB Disk
Recommended Resources allocated to Docker: 16GB RAM, 2+ CPUs, 100GB Disk

To Run:
Download one of the archives (.zip or .tar.gz from the Github release page) [Download Release Here](https://github.com/OpenC3/cosmos/releases/tag/v5.0.7)
Extract the archive somewhere on your host computer
Run Linux/Mac: ./openc3.sh run
Run Windows: openc3.bat run
Connect a web browser to [http://localhost:2900/](http://localhost:2900/)
Have fun running OpenC3!

Please see our documentation at https://openc3.com

Try it out and let us know what you think! Please submit any issues as Github tickets, or any generic feedback to [support@openc3.com](mailto:support@openc3.com).

Thanks!

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.0.6...v5.0.7)
