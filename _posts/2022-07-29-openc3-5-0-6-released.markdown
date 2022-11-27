---
layout: news_item
title: "OpenC3 5.0.6 Released"
date: 2022-07-29 6:00:00 -0700
author: ryanmelt
version: 5.0.6
categories: [release]
---

I'm happy to announce the first release of OpenC3 and the birth of our new company fully devoted to this technology!

After 16 years of developing Ball Aerospace COSMOS, its creators, Ryan Melton and Jason Thomas, have created a new company called OpenC3 so that we can fully serve this technology and its users.

This release continues where we left off with COSMOS 5.0.5 and is appropriately versioned OpenC3 5.0.6.

This release rebrands the product to OpenC3, has important bug fixes, improves overall performance, and has some great new features including the ability to create telemetry screens directly from the GUI without uploading a new plugin.

## Key Enhancements

- In TlmViewer you can now create screens directly from the user interface
- Cursors are now more visible
- All API methods now support different scopes
- The command line interface now supports running as root for environments where that is needed
- Better error messages for many errors
- Conversions now serialize their output data types and sizes

## Key Bug Fixes

- Sending binary blobs in commands now works
- The Script API now properly enforces authentication
- Limits Monitor now handles plugins being deleted from under it

## All Pull Requests

- Properly handle JSON for binary data by @ryanmelt in [#4](https://github.com/OpenC3/cosmos/pull/4)
- Script Authentication Enforced. Added Script Runner Ruby Client. by @ryanmelt in [#17](https://github.com/OpenC3/cosmos/pull/17)
- Better cleanup and handle limits by @jmthomas in [#14](https://github.com/OpenC3/cosmos/pull/14)
- Add COSMOS compatibility code by @ryanmelt in [#19](https://github.com/OpenC3/cosmos/pull/19)
- Identify test reports vs script reports by @jmthomas in [#21](https://github.com/OpenC3/cosmos/pull/21)
- Optimize Simulated Target for INST by @ryanmelt in [#24](https://github.com/OpenC3/cosmos/pull/24)
- Switch from openc3 to openc3inc docker namespace by @ryanmelt in [#32](https://github.com/OpenC3/cosmos/pull/32)
- New screen by @jmthomas in [#30](https://github.com/OpenC3/cosmos/pull/30)
- script support scope for all methods by @ryanmelt in [#33](https://github.com/OpenC3/cosmos/pull/33)
- Make cursor white and fix script debug up arrow by @jmthomas in [#35](https://github.com/OpenC3/cosmos/pull/35)
- Allow --user=root to openc3cli by @jmthomas in [#34](https://github.com/OpenC3/cosmos/pull/34)
- Better check message and help with NameError by @jmthomas in [#36](https://github.com/OpenC3/cosmos/pull/36)
- Add converted\_ state to as_json by @ryanmelt in [#38](https://github.com/OpenC3/cosmos/pull/38)

Prerequisites:

Docker - Running OpenC3 requires a working Docker or Podman installation. Typically Docker Desktop on Windows / Mac. Plain Docker or Podman also works on linux. We actively develop and run with Docker Desktop on Mac/Windows, and Linux on Raspberry Pi, so if you have any issues on another platform, please let us know by submitting a ticket!

Minimum Resources allocated to Docker: 4GB RAM, 1 CPU, 80GB Disk

Recommended Resources allocated to Docker: 16GB RAM, 2+ CPUs, 100GB Disk

To Run:

- Download one of the archives (.zip or .tar.gz from the Github release page) [Download Release Here](https://github.com/OpenC3/cosmos/releases/tag/v5.0.6)
- Extract the archive somewhere on your host computer
- Run Linux/Mac: ./openc3.sh run
- Run Windows: openc3.bat run
- Connect a web browser to [http://localhost:2900/](http://localhost:2900/)
- Have fun running OpenC3!

Please see our documentation at [https://openc3.com](https://openc3.com)

Try it out and let us know what you think! Please submit any issues as Github tickets, or any generic feedback to [support@openc3.com](mailto:support@openc3.com).

Thanks!

**Full Changelog**: [https://github.com/OpenC3/cosmos/compare/v5.0.5...v5.0.6](https://github.com/OpenC3/cosmos/compare/v5.0.5...v5.0.6)
