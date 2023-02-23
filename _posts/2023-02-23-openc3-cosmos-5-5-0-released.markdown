---
layout: news_item
title: "OpenC3 COSMOS 5.5.0 Released"
date: 2023-02-23 6:00:00 -0700
author: ryanmelt
version: 5.5.0
categories: [release]
---

# OpenC3 COSMOS 5.5.0 - Modern, Production Ready, Command and Control

Welcome to OpenC3 COSMOS 5.5.0!

## Full Support for Bridges with Examples

Bridges are an easy method to give COSMOS access to hardware that doesn't natively speak Ethernet. This release adds full support for bridges and new bridge gems that make them even easier to use. See the docs here: [Bridges Documentation](https://openc3.com/docs/v5/bridges)

## Dynamic Route Support In Traefik

Want to create a plugin that adds a new API to COSMOS and exposes it at a route in Traefik? Now you can. This implemented using the new ROUTE_PREFIX modifier to MICROSERVICE in plugin.txt. See: [ROUTE_PREFIX](https://openc3.com/docs/v5/plugins#route_prefix)

## Bucket Explorer Upload and Delete Files and Support for Custom Buckets

Bucket Explorer can now upload new files, and delete files from buckets. Also you can add additional buckets to manage by defining environment variables like OPENC3_NAME_BUCKET.

## Ruby Websocket Client API

Add a Ruby based client code to access all of our Websocket interfaces. Most importantly the Streaming API can now be accessed directly from Ruby. See: [web_socket_api.rb](https://github.com/OpenC3/cosmos/blob/main/openc3/lib/openc3/script/web_socket_api.rb)

## Command Line Generators for More COSMOS Features

We've expanded our generator code to create scaffolds for more COSMOS features. We now have generators for plugins, targets, microservices, conversions, and limits_responses. See `openc3cli generate`

## Improved TlmGrapher Performance and Support for Reduced Data

TlmGrapher is now much more performant with high rate data. You can also now easily graph reduced minute, hour, and day data!

## New NEEDS_DEPENDENCIES keyword for plugin.txt

If your plugin needs access to custom installed gems, but you don't explicitly add them as dependencies in .gemspec (which you probably should...), you can now force access to the /gems volume mount by adding NEEDS_DEPENDENCIES to plugin.txt.

## New WriteRejectError Support for Interfaces and Protocols

Want to add a custom protocol the rejects commands but doesn't cause the whole interface to disconnect and then reconnect? Now you can by raising a WriteRejectError exception from your custom Protocol or Interface.

## Cleaned Up Environment Variable Support for Scripts

Script Environment variables were a little confusing before, but now we've clarified and improved how they work. You can set global environment variables that are available to all scripts, and you can set individual environment variables for individual script runs.

## Environment Variable Support For Not Installing Default Tools

We also added some new environment variables to prevent the installation of some of standard tools. You can use these if you have customized one of the tools or simply don't need one of our default tools.

## Important Bug Fixes

1. Fixed a bug causing poor performance as soon as you had more than 1000 files in Minio
2. Fixed an issue where the first script run wouldn't show up in Completed Scripts
3. Telemetry items are now case-insensitive in TlmViewer Screens
4. Several bug fixes in DataExtractor for large queries
5. Starting using Ruby resolv-replace to remove DNS errors in Alpine

## All Pull Requests in this Release

- Add additional buckets to .env file by @jmthomas in [#459](https://github.com/OpenC3/cosmos/pull/459)
- Fix various regex issues by @jmthomas in [#462](https://github.com/OpenC3/cosmos/pull/462)
- add resolv-replace to help with alpine dns by @ryanmelt in [#463](https://github.com/OpenC3/cosmos/pull/463)
- Implement upload and delete file by @jmthomas in [#466](https://github.com/OpenC3/cosmos/pull/466)
- Improve Script running/completed scripts by @jmthomas in [#469](https://github.com/OpenC3/cosmos/pull/469)
- Add IRB to cli options by @jmthomas in [#470](https://github.com/OpenC3/cosmos/pull/470)
- Upgrade public js/css automatically by @jmthomas in [#472](https://github.com/OpenC3/cosmos/pull/472)
- Add env vars to toggle default tool installation by @wiatrp in [#473](https://github.com/OpenC3/cosmos/pull/473)
- Support dynamic routes in Traefik for microservices by @ryanmelt in [#471](https://github.com/OpenC3/cosmos/pull/471)
- Data extractor updates by @ryanmelt in [#476](https://github.com/OpenC3/cosmos/pull/476)
- Graph reduced by @jmthomas in [#480](https://github.com/OpenC3/cosmos/pull/480)
- Apply global and then script env vars by @jmthomas in [#482](https://github.com/OpenC3/cosmos/pull/482)
- Calendar creation of timelines and events by @jmthomas in [#483](https://github.com/OpenC3/cosmos/pull/483)
- Default various SETTINGS to px by @jmthomas in [#484](https://github.com/OpenC3/cosmos/pull/484)
- Plugin install check existing name by @jmthomas in [#487](https://github.com/OpenC3/cosmos/pull/487)
- Fix data extractor column logic by @ryanmelt in [#488](https://github.com/OpenC3/cosmos/pull/488)
- Websocket interface by @ryanmelt in [#486](https://github.com/OpenC3/cosmos/pull/486)
- Support rejecting commands from interface / protocols without disconnecting interface by @ryanmelt in [#490](https://github.com/OpenC3/cosmos/pull/490)
- Bump alpine, traefik and break up package_audit by @jmthomas in [#492](https://github.com/OpenC3/cosmos/pull/492)
- Fix TlmGrapher route url parsing by @jmthomas in [#498](https://github.com/OpenC3/cosmos/pull/498)
- Fix warnings and code scan by @jmthomas in [#499](https://github.com/OpenC3/cosmos/pull/499)
- Add optional flag to return object metadata by @wiatrp in [#505](https://github.com/OpenC3/cosmos/pull/505)
- Bridge updates for bridgegem system by @ryanmelt in [#504](https://github.com/OpenC3/cosmos/pull/504)
- Enforce upper case in cmd/tlm api by @jmthomas in [#503](https://github.com/OpenC3/cosmos/pull/503)
- Add NEEDS_DEPENDENCIES keyword for plugins by @jmthomas in [#495](https://github.com/OpenC3/cosmos/pull/495)
- TlmGrapher improvements by @ryanmelt in [#508](https://github.com/OpenC3/cosmos/pull/508)
- Implement generators by @jmthomas in [#502](https://github.com/OpenC3/cosmos/pull/502)
- Target file improvements by @jmthomas in [#509](https://github.com/OpenC3/cosmos/pull/509)
- Init all defined buckets on startup by @wiatrp in [#511](https://github.com/OpenC3/cosmos/pull/511)

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

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.4.2...v5.5.0)
