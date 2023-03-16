---
layout: news_item
title: "OpenC3 COSMOS 5.5.2 Released"
date: 2023-05-16 6:00:00 -0700
author: ryanmelt
version: 5.5.2
categories: [release]
---

# OpenC3 COSMOS 5.5.2 - Modern, Production Ready, Command and Control

Welcome to OpenC3 COSMOS 5.5.2!

# Enhanced Local Mode

Local mode now captures tools configurations and global settings. These values are loaded into the system during init.
Note that these files are written to the local volume as they are changed, but are only synced back to the server on a run of the init container.

# Docker Compose V2

We've updated our scripts to use "docker compose" instead of "docker-compose" by default. On linux it will fall back to "docker-compose" if "docker compose" is not available.

# TlmGrapher Show Limits

TlmGrapher can now include horizontal lines indicating the values of limits for a specific item on graphs.

# Multiselect Combobox for Scripts

The combo_box() script method can now support multiselect returning an array of selections.

```
answer = combo_box("This is a multi-select combo box", 'one', 'two', 'three', multiple: true)
```

# Improved Screen Editing Autocomplete

Fixed some issues with autocomplete in the built-in screen editor.

## All Pull Requests in this Release

- Render errors on plugin install by @jmthomas in [#527](https://github.com/OpenC3/cosmos/pull/527)
- Allow multiselect by @jmthomas in [#526](https://github.com/OpenC3/cosmos/pull/526)
- Change include_head to metadata by @jmthomas in [#535](https://github.com/OpenC3/cosmos/pull/535)
- Save and load local tool config by @jmthomas in [#530](https://github.com/OpenC3/cosmos/pull/530)
- Bump @sideway/formula from 3.0.0 to 3.0.1 in /openc3-cosmos-init/plugins by @dependabot in [#541](https://github.com/OpenC3/cosmos/pull/541)
- Changes to support external keycloak for enterprise by @ryanmelt in [#543](https://github.com/OpenC3/cosmos/pull/543)
- Bump webpack from 5.75.0 to 5.76.0 in /openc3-cosmos-init/plugins by @dependabot in [#544](https://github.com/OpenC3/cosmos/pull/544)
- Bump webpack from 5.75.0 to 5.76.0 in /openc3-cosmos-init/plugins/openc3-tool-base by @dependabot in [#548](https://github.com/OpenC3/cosmos/pull/548)
- Change docker-compose to docker compose by @jmthomas in [#537](https://github.com/OpenC3/cosmos/pull/537)
- Fix screen keywords, add choice selections, add SETTING by @jmthomas in [#545](https://github.com/OpenC3/cosmos/pull/545)
- Fix HTTPClient SSL and realm reference by @ryanmelt in [#549](https://github.com/OpenC3/cosmos/pull/549)
- Allow user to graph limits by @jmthomas in [#542](https://github.com/OpenC3/cosmos/pull/542)

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

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.5.1...v5.5.2)
