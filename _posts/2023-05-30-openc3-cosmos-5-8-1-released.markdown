---
layout: news_item
title: "OpenC3 COSMOS 5.8.1 Released"
date: 2023-05-30 6:00:00 -0700
author: jmthomas
version: 5.8.1
categories: [release]
---

# OpenC3 COSMOS 5.8.1 - Modern, Production Ready, Command and Control

## Alpine 3.18.0 with Ruby 3.2 and Python 3.11.3

This releases updates the Alpine linux version to 3.18.0. With this comes an upgrade from Ruby 3.1 to Ruby 3.2. Not much changes with Ruby 3.2, but one important detail is that the deprecated Dir.exists? and File.exists? methods has been removed (use Dir.exist? and File.exist? instead). Note also this is our first release that bundles the Python interpreter... more to come soon! Also, ruby's httpclient library was replaced with Faraday, because httpclient is not being maintained.

## Greatly improved script instrumentation performance (100x)

Starting scripts including using require_utility and load_utility are now 100x faster than in COSMOS 5.6.0 where we improved the number of cases handled by instrumentation, but introduced a performance regression.

## Added the ability to browse volumes in BucketExplorer

Just add an environment variables like OPENC3**name**VOLUME set to the path of the volume. They can then be browsed and modified from BucketExplorer just like buckets!

## New new bucket_load library

Allow for custom microservices to require target libraries just like ScriptRunner scripts. This modifies the Ruby require code to look in buckets for files if they aren't found locally.

```
require 'openc3/utilities/bucket_require'
$openc3_scope = 'DEFAULT' # Required until 5.8.2 release
require 'INST/procedures/utilities/collect.rb'
```

## Other Improvements

1. The raw dialog is now placed higher to allow for seeing more beneath it
2. Handbook creator now displays ID values
3. Screen Errors during plugin installs are now warnings and not fatal
4. get_limits API now supports LATEST packet name
5. BufferedPacketLogWriter updated to dump allow contents to files when a new file is created.
6. New build_command API (only available from Javascript so far).

## Bug Fixes

1. Fix TlmViewer MATRIXBYCOLUMNS layout
2. Fix Plugin install diffs for changes at beginning and end of file
3. Changed microservices were formerly killed but not restarted properly

## All Pull Requests in this Release

- Alpine 3.18.0 and test ruby 3.2 by [#659](@jmthomas in https://github.com/OpenC3/cosmos/pull/659)
- Warn on screen ERB error by @jmthomas in [#677](https://github.com/OpenC3/cosmos/pull/677)
- Force raw dialog to top of window by @jmthomas in [#675](https://github.com/OpenC3/cosmos/pull/675)
- Add ID Value to handbook output by @jmthomas in [#674](https://github.com/OpenC3/cosmos/pull/674)
- Fix matrix layout, default 0px margin by @jmthomas in [#673](https://github.com/OpenC3/cosmos/pull/673)
- Ace diff by @jmthomas in [#672](https://github.com/OpenC3/cosmos/pull/672)
- Update BufferedPacketLogWriter to empty buffer when closing file by @ryanmelt in [#670](https://github.com/OpenC3/cosmos/pull/670)
- Bucket load by @ryanmelt in [#680](https://github.com/OpenC3/cosmos/pull/680)
- Implement build_command by @jmthomas in [#676](https://github.com/OpenC3/cosmos/pull/676)
- Browse volumes by @jmthomas in [#678](https://github.com/OpenC3/cosmos/pull/678)
- Instrumentation performance by @ryanmelt in [#684](https://github.com/OpenC3/cosmos/pull/684)
- Bump dependencies by @jmthomas in [#685](https://github.com/OpenC3/cosmos/pull/685)
- faraday has no reset_all, use close by @ryanmelt in [#686](https://github.com/OpenC3/cosmos/pull/686)
- Allow LATEST in get_limits by @jmthomas in [#683](https://github.com/OpenC3/cosmos/pull/683)
- Properly restart changed microservices by @ryanmelt in [#687](https://github.com/OpenC3/cosmos/pull/687)

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

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.7.2...v5.8.1)
