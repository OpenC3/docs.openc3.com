---
layout: docs
title: Target Configuration
toc: true
---

Targets are the external embedded systems that COSMOS connects to. Targets are defined by the top level [TARGET]({{site.baseurl}}/docs/v5/plugins#target-1) keyword in the plugin.txt file. Each target is self contained in a target directory named after the target. In the root of the target directory there is a configuration file named target.txt which configures the individual target.

# target.txt Keywords

{% cosmos_meta target_config.yaml %}
