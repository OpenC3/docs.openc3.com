---
layout: news_item
title: "OpenC3 COSMOS 5.6.0 Released"
date: 2023-04-16 6:00:00 -0700
author: ryanmelt
version: 5.6.0
categories: [release]
---

# OpenC3 COSMOS 5.6.0 - Modern, Production Ready, Command and Control

Welcome to OpenC3 COSMOS 5.6.0!

This release brings some great new features, and also includes some important bug fixes.  Everyone is encouraged to upgrade.

# Important Migration Note

TlmViewer widgets had to be updated to support opening screens from ScriptRunner which caused a breaking change for any plugins containing a custom widget.   Plugins with a custom widget will need to update their package.json file to use @openc3/tool-common version 5.6.0 (or later), and be rebuilt/reinstalled.

# Open Telemetry Screens in Script Runner

You can now open telemetry screens in ScriptRunner! Either existing screens or using the local_screen feature you can define a unique screen right from your script.

```
display_screen("INST", "ADCS")
wait(3)
clear_screen("INST", "ADCS")
wait(3)
display_screen("INST", "IMAGE")
wait(3)
clear_all_screens()
wait(3)
definition = '
SCREEN AUTO AUTO 1.0

VERTICALBOX "Test Screen"
  LABELVALUE INST HEALTH_STATUS TEMP1
  LABELVALUE INST HEALTH_STATUS RECEIVED_TIMEFORMATTED WITH_UNITS 30
END
'
local_screen("TEST", definition)
```

# Widget Generator
Our plugin generators now support custom widgets.   Run with: ```openc3.sh cli generate widget MyWidget``` 

# Diff plugin.txt on Plugin Upgrades
Now if you upgrade a plugin and the plugin.txt file was changed, you will be presented with a diff interface that shows the changes and allows you to pick which lines you want to keep.

# Install Plugins and Gems from the command line
The openc3cli command has been updated to support loading plugins and gems from your host machine.   You can use like follows:

```
gem install openc3
openc3cli load /path/to/myplugin.gem
openc3cli unload myplugin.gem__12345667
openc3cli geminstall my.gem
openc3cli gemuninstall my.gem
```

# log_message parameter added to cmd() apis
cmd() can now take an optional keyword argument called log_message that allows you to optionally not have a command be printed into the log messages.   This is useful if you are frequently sending a command or at a high rate, and don't want to spam the log messages.  Note: All commands are always logged to our packet logs.

# TlmGrapher Show Limits Updated
TlmGrapher Show Limits has been updated to color in the background for each section of limits.  This makes the limits ranges much easier to see.

# CRC8 Code
We now ship code to perform CRC8 calculations, on top of our existing CRC16, CRC32, and CRC64 functionality.

# Important Bug Fixes
1. get_cmd_value and get_cmd_time now work correctly
2. The details dialog now works correctly with DERIVED items
3. Script instrumentation now handles more complicated cases with lots of newlines
4. Fixed run_script and the other script apis from Ruby
5. TableManager now properly formats binary fields
6. connect_interface now works correctly when given parameters
7. inject_tlm now handles packets with a PACKET_TIME
8. Fix target_index in packet log files

## All Pull Requests in this Release
* float screens by @ryanmelt in [#550](https://github.com/OpenC3/cosmos/pull/550)
* Fix get_cmd_value and get_cmd_time by @ryanmelt in [#551](https://github.com/OpenC3/cosmos/pull/551)
* local screens and screen values by @ryanmelt in [#552](https://github.com/OpenC3/cosmos/pull/552)
* LOG_STREAM instead of LOG_RAW by @jmthomas in [#540](https://github.com/OpenC3/cosmos/pull/540)
* crc8 by @ryanmelt in [#563](https://github.com/OpenC3/cosmos/pull/563)
* Add docker network to scripts by @ryanmelt in [#562](https://github.com/OpenC3/cosmos/pull/562)
* Generate widgets by @jmthomas in [#557](https://github.com/OpenC3/cosmos/pull/557)
* Derived details by @jmthomas in [#575](https://github.com/OpenC3/cosmos/pull/575)
* Improve instrumentation by @ryanmelt in [#568](https://github.com/OpenC3/cosmos/pull/568)
* Validate built gem by @jmthomas in [#577](https://github.com/OpenC3/cosmos/pull/577)
* CmdSender history monospace, Script Report, doc updates by @jmthomas in [#574](https://github.com/OpenC3/cosmos/pull/574)
* Fix run_script by @jmthomas in [#591](https://github.com/OpenC3/cosmos/pull/591)
* Add target folder to load path by @ryanmelt in [#610](https://github.com/OpenC3/cosmos/pull/610)
* Color the limits zones in TlmGrapher by @jmthomas in [#599](https://github.com/OpenC3/cosmos/pull/599)
* Use VWidget to format TableItem by @jmthomas in [#601](https://github.com/OpenC3/cosmos/pull/601)
* Fix connect_interface with params by @jmthomas in [#604](https://github.com/OpenC3/cosmos/pull/604)
* Move limits set to LimitsMonitor and fix limitsbar by @jmthomas in [#606](https://github.com/OpenC3/cosmos/pull/606)
* Remove DONT_LOG and log from interface_model by @jmthomas in [#605](https://github.com/OpenC3/cosmos/pull/605)
* Cleanup logger as debug rather than info by @jmthomas in [#611](https://github.com/OpenC3/cosmos/pull/611)
* Force write_timeout to value and update docs by @jmthomas in [#603](https://github.com/OpenC3/cosmos/pull/603)
* Don't compress txt files by @jmthomas in [#602](https://github.com/OpenC3/cosmos/pull/602)
* Add log_message parameter to cmd() by @jmthomas in [#612](https://github.com/OpenC3/cosmos/pull/612)
* Diff plugin.txt on upgrade by @jmthomas in [#607](https://github.com/OpenC3/cosmos/pull/607)
* Ace edit json dialog and redis by @jmthomas in [#608](https://github.com/OpenC3/cosmos/pull/608)
* Dependencies by @jmthomas in [#613](https://github.com/OpenC3/cosmos/pull/613)
* inject_tlm performed by microservices by @ryanmelt in [#614](https://github.com/OpenC3/cosmos/pull/614)
* Command line plugin and gem install/uninstall outside cluster by @ryanmelt in [#615](https://github.com/OpenC3/cosmos/pull/615)
* fix target_index in packet log writer by @ryanmelt in [#617](https://github.com/OpenC3/cosmos/pull/617)

Prerequisites:
Docker - Running OpenC3 requires a working Docker or Podman installation. Typically Docker Desktop on Windows / Mac. Plain Docker or Podman also works on linux. We actively develop and run with Docker Desktop on Mac/Windows, and Linux on Raspberry Pi, so if you have any issues on another platform, please let us know by submitting a ticket!

Minimum Resources allocated to Docker: 4GB RAM, 1 CPU, 80GB Disk
Recommended Resources allocated to Docker: 16GB RAM, 2+ CPUs, 100GB Disk
Also requires docker compose version 1.27+

To Run:
* git clone https://github.com/openc3/cosmos-project.git cosmos-myproject
* cd cosmos-myproject
* Run Linux/Mac: ./openc3.sh run
* Run Windows: openc3.bat run
* Connect a web browser to [http://localhost:2900/](http://localhost:2900/)
* Have fun running OpenC3 COSMOS!

Please see our documentation at https://openc3.com

Try it out and let us know what you think! Please submit any issues as Github tickets, or any generic feedback to [support@openc3.com](mailto:support@openc3.com).

Thanks!

**Full Changelog**: [Changelog](https://github.com/OpenC3/cosmos/compare/v5.5.2...v5.6.0)

