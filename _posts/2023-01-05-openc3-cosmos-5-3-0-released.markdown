---
layout: news_item
title: "OpenC3 COSMOS 5.3.0 Released"
date: 2023-01-05 6:00:00 -0700
author: ryanmelt
version: 5.3.0
categories: [release]
---

# OpenC3 COSMOS 5.3.0 - Modern, Production Ready, Command and Control

# Welcome to OpenC3 COSMOS 5.3.0!

## New Secrets Framework

COSMOS now contains a modular framework for interfacing with different Secrets management frameworks. This first release stores secrets into Redis, and they can be retrieved as needed by Interfaces and other Microservices. Kubernetes secrets support coming soon in COSMOS Enterprise Edition.

## MQTT Interface

Added a new interface to support the MQTT message bus. Packets can be associated with MQTT topics by adding META TOPIC topicname to packet definitions. This allows for easy integration with MQTT.

## Interface and Protocol Commands

The Interface and Protocol base classes now support an interface_cmd and protocol_cmd method respectively. This provides a framework for defining interface and protocol level APIs without having to define TARGETS that are handled by the Interface internally. Usage examples coming soon. Possible use cases include things like reseting interfaces without a connect/disconnect cycle, commands to support key management, and changing internal protocol settings during runtime.

## Other Highlighted Improvements In This Release

- Overriding telemetry now works without needing the OverrideProtocol
- BLOCK data can now be properly displayed in PacketViewer
- Dependency updates

## Key Bug Fixes

- Fixed an issue when trying to identify and define packets when streaming raw packet through the StreamingApi

## All Pull Requests in this Release

- override_tlm sets all by default, works across processes by @jmthomas in [#343](https://github.com/OpenC3/cosmos/pull/343)
- Fix CVT override with full coverage by @jmthomas in [#345](https://github.com/OpenC3/cosmos/pull/345)
- Display binary encoded strings and BLOCK data by @jmthomas in [#346](https://github.com/OpenC3/cosmos/pull/346)
- Secrets, MQTT interface, interface & protocol cmds by @ryanmelt in [#347](https://github.com/OpenC3/cosmos/pull/347)
- Bump ace and fix VWidget by @jmthomas in [#348](https://github.com/OpenC3/cosmos/pull/348)
- Dont identify_and_define for StreamingApi by @ryanmelt in [#349](https://github.com/OpenC3/cosmos/pull/349)
- Enforce require only once by @ryanmelt in [#350](https://github.com/OpenC3/cosmos/pull/350)
- Add get_target_interfaces by @jmthomas in [#352](https://github.com/OpenC3/cosmos/pull/352)

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

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.2.0...v5.3.0)
