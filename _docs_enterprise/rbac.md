---
layout: docs
title: Role Based Access Control
---

Role Based Access Control allows you to assign roles to individual users in OpenC3. By default, Enterprise Edition ships with 3 built-in roles: viewer, operator, and admin. These roles are mapped to the following OpenC3 permissions.

| Permission  | Description       | Viewer | Operator | Admin |
| ----------- | :---------------- | :----: | :------: | :---: |
| cmd         | Send commands     |        | x        |       |
| cmd_raw     | Send raw commands |        | x        |       |
| cmd_info    | View command info | x      | x        | x     |
| tlm         | View telemetry    | x      | x        | x     |
| tlm_set     | Set telemetry     |        | x        |       |
| script_view | View scripts      | x      | x        | x     |
| script_edit | Edit scripts      |        | x        | x     |
| script_run  | Run scripts       |        | x        |       |
| system      | Get cmd/tlm counts, interface/router info, targets, screens, tables. Everything that doesn't explicitly belong to another permission. | x | x | x |
| system_set  | Connect and disconnect interfaces and routers | x | x | x |
| admin       | Upload, install and delete plugins and gems. Execute arbitrary Redis commands. Change Admin settings. | | |  x |

Note that these roles and permissions are all scoped to the current [Scope]({{site.baseurl}}/docs/enterprise/scopes). There is also a special admin role scoped to `ALLSCOPES` which means it can delete scopes, plugins, and gems across all scopes.
