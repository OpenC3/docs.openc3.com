---
layout: docs
title: Local Mode
---

Local Mode is a new feature in the [5.0.9]({{site.baseurl}}/news/2022/09/02/openc3-5-0-9-released/) OpenC3 release. It is intended to capture the configuration of an edited plugin so it can be configuration managed. It allows you to edit portions of a plugin (scripts and screens) locally in the editor of your choice and instantly have those changes appear in the OpenC3 plugin. This avoids the plugin build / install cycle which is required when editing command and telemetry or interface definitions.

## Using Local Mode

In this tutorial we will use the OpenC3 Demo as configured by the [Installation Guide]({{site.baseurl}}/docs/v5/installation). You should have cloned a [openc3-project](https://github.com/OpenC3/openc3-project) and started it using `openc3.sh run`.

If you check the project directory you should see a `plugins/DEFAULT/openc3-demo` directory. This will contain both the gem that was installed and a `plugin_instance.json` file. The `plugin_instance.json` file captures the plugin.txt values when the plugin was installed. Note, all files in the plugins directory are meant to be configuration managed with the project. This ensures if you make local edits and check them in, another user can clone the project and get the exact same configuration. We will demonstrate this later.

### Editing scripts

<div class="note info">
  <h5>Visual Studio Code</h5>
  <p>This tutorial will use <a href="https://code.visualstudio.com">VS Code</a> which is the editor used by the OpenC3 developers.</p>
</div>

The most common use case for Local Mode is script development. Launch Script Runner and open the `INST/procedures/checks.rb` file. If you run this script you'll notice that it has a few errors (by design) which prevent it from running to completion. Let's fix it! Comment out the second and fourth lines and save the script. You should now notice that Local Mode has saved a copy of the script to `plugins/targets_modified/INST/procedures/checks.rb`.

![Project Layout]({{site.baseurl}}/img/v5/guides/local_mode/project.png)

At this point Local Mode keeps these scripts in sync so we can edit in either place. Let's edit the local script by adding a simple comment at the top: `# This is a script`. Now if we go back to Script Runner the changes have not _automatically_ appeared. However, there is a Reload button next to the filename that will refresh the file from the backend.

![Project Layout]({{site.baseurl}}/img/v5/guides/local_mode/reload_file.png)

Clicking this reloads the file which has been synced into OpenC3 and now we see our comment.

![Project Layout]({{site.baseurl}}/img/v5/guides/local_mode/reloaded.png)

It's important not to delete this local file while in Local Mode or OpenC3 will display a server error 500. If this happens you can open the Minio Console at http://localhost:2900/minio/ and browse to the file in question to download and restore it.

![Project Layout]({{site.baseurl}}/img/v5/guides/local_mode/minio.png)

### Disabling Local Mode

If you want to disable Local Mode you can edit the .env file and delete the setting `OPENC3_LOCAL_MODE=1`.

## Configuration Management

It is recommended to configuration manage the entire project including the plugins directory. This will allow any user who starts OpenC3 to launch an identical configuration. Plugins are created and updated with any modifications found in the targets_modified directory.

At some point you will probably want to release your local changes back to the plugin they originated from. Simply copy the entire targets_modified/TARGET directory back to the original plugin. At that point you can rebuild the plugin using the CLI.

```
openc3-demo % ./openc3.sh cli rake build VERSION=1.0.1
  Successfully built RubyGem
  Name: openc3-demo
  Version: 1.0.1
  File: openc3-demo-1.0.1.gem
```

Upgrade the plugin using the Admin Plugins tab and the Upgrade link. When you select your newly built plugin, OpenC3 detects the existing changes and asks if you want to delete them. There is a stern warning attached because this will permanently remove these changes! Since we just moved over the changes and rebuilt the plugin we will check the box and INSTALL.

![Project Layout]({{site.baseurl}}/img/v5/guides/local_mode/delete_modified.png)

When the new plugin is installed, the project's `plugins` directory gets updated with the new plugin and everything under the targets_modified directory is removed because there are no modifications on a new install.

![Project Layout]({{site.baseurl}}/img/v5/guides/local_mode/project_update.png)

Local Mode is a powerful way to develop scripts and screens on the local file system and automatically have them sync to OpenC3.
