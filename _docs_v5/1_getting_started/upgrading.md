---
layout: docs
title: Upgrading
---

### OpenC3 5 Upgrades

OpenC3 is released as a zip or tar file containing all the source code to build the OpenC3 Docker containers and run them. Since we're using Docker containers and volumes we can simply stop the existing OpenC3 application, then build and start the new release. Keep your existing OpenC3 5 installation and [install]({{site.baseurl}}/docs/v5/installation) OpenC3 according to the installation instructions to a new directory.

This example assumes an existing OpenC3 5 installation at C:\OpenC3_5.0.0 and a new OpenC3 5 installation at C:\OpenC3_5.1.0. Linux users can adjust paths and change from .bat to .sh to follow along.

1. Stop the current OpenC3 application

    ```batch
    C:\OpenC3_5.0.0> openc3.bat stop
    ```

1. Start the new OpenC3 application (note this will also build the new containers)

    ```batch
    C:\OpenC3.1.0> openc3.bat start
    ```


### Migrating From COSMOS 4 to OpenC3 5

OpenC3 5 is a new architecture and treats targets as independent [plugins]({{site.baseurl}}/docs/v5/plugins). Thus the primary effort in porting from COSMOS 4 to OpenC3 5 is converting targets to plugins. We recommend creating plugins for each independent target (with its own interface) but targets which share an interface will need to be part of the same plugin. The reason for independent plugins is it allows the plugin to be versioned separately and more easily shared outside your specific project. If you have very project specific targets (e.g. custom hardware) those can potentially be combined for ease of deployment.

OpenC3 5 includes a migration tool for converting an existing COSMOS 4 configuration into a OpenC3 5 plugin. This example assumes an existing COSMOS 4 configuration at C:\COSMOS4_config and a new OpenC3 5 installation at C:\OpenC3_5. Linux users can adjust paths and change from .bat to .sh to follow along.

1. Change to the existing COSMOS 4 configuration directory. You should see the config, lib, procedures, outputs directory. You can then run the migration tool by specifying the absolute path to the OpenC3 5 installation.

    ```batch
    C:\COSMOS4_config> C:\OpenC3_5\openc3.bat openc3cli migrate -a demo
    ```

    This creates a new OpenC3 5 plugin called openc3-demo with a target named DEMO containing the existing lib and procedures files as well as all the existing targets.

    ```batch
    C:\COSMOS4_config> C:\OpenC3_5\openc3.bat openc3cli migrate demo-part INST SYSTEM
    ```

    This would create a new OpenC3 5 plugin called openc3-demo-part with a target named DEMO_PART containing the existing lib and procedures files as well as the INST and SYSTEM targets (but no others).

1. Open the new OpenC3 5 plugin and ensure the [plugin.txt]({{site.baseurl}}/docs/v5/plugins#plugintxt-configuration-file) file is correctly configured. The migration tool doesn't create VARIABLEs or MICROSERVICEs or handle target substitution so those features will have to added manually.

1. Follow the [building your plugin]({{site.baseurl}}/docs/v5/gettingstarted#building-your-plugin) part of the Getting Started tutorial to build your new plugin and upload it to OpenC3 5.
