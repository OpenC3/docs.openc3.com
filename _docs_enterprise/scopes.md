---
layout: docs
title: Scopes
---

Scopes can be thought of as a fully contained OpenC3 installation. Any gems or plugins (and thus targets, interfaces, etc) installed to a scope are local to that scope. That means you can create multiple scopes for different test setups, programs, etc without complexifying or corrupting an existing OpenC3 setup.

### Creating and Using Scopes

To create a new scope you must have the super admin role. Go to the Admin page and select the Scopes tab. Click Add and create a new name for the Scope. A useful naming conventions could be "<Program Name>_<Usage>", e.g. Gladiator_SWTB, Gladiator_TVAC, Gladiator_EMI, etc.

Once scopes are created the show up in the Scope drop down list. Selecting a different scope unloads all the plugins (target, interfaces, etc) from OpenC3 and loads the new one. This is a significant operation in that we shut down all existing connections and microservices and start new ones. Plan on this taking a few minutes depending on the complexity of your scope (number of plugin targets and interfaces).
