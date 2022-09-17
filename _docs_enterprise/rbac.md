---
layout: docs
title: Role Based Access Control
---

Role Based Access Control allows you to assign roles to individual users in OpenC3. By default, Enterprise Edition ships with 3 built-in roles: viewer, operator, and admin. These roles are mapped to the following OpenC3 permissions.

| Permission  | Description       | Viewer | Operator | Admin |
| ----------- | :---------------- | :----: | :------: | :---: |
| cmd         | Send commands     |        | <input type="checkbox" disabled checked />        |       |
| cmd_raw     | Send raw commands |        | <input type="checkbox" disabled checked />        |       |
| cmd_info    | View command info | <input type="checkbox" disabled checked />      | <input type="checkbox" disabled checked />        | <input type="checkbox" disabled checked />     |
| tlm         | View telemetry    | <input type="checkbox" disabled checked />      | <input type="checkbox" disabled checked />        | <input type="checkbox" disabled checked />     |
| tlm_set     | Set telemetry     |        | <input type="checkbox" disabled checked />        |       |
| script_view | View scripts      | <input type="checkbox" disabled checked />      | <input type="checkbox" disabled checked />        | <input type="checkbox" disabled checked />     |
| script_edit | Edit scripts      |        | <input type="checkbox" disabled checked />        | <input type="checkbox" disabled checked />     |
| script_run  | Run scripts       |        | <input type="checkbox" disabled checked />        |       |
| system      | Get cmd/tlm counts, interface/router info, targets, screens, tables. Everything that doesn't explicitly belong to another permission. | <input type="checkbox" disabled checked /> | <input type="checkbox" disabled checked /> | <input type="checkbox" disabled checked /> |
| system_set  | Connect and disconnect interfaces and routers | <input type="checkbox" disabled checked /> | <input type="checkbox" disabled checked /> | <input type="checkbox" disabled checked /> |
| admin       | Upload, install and delete plugins and gems. Execute arbitrary Redis commands. Change Admin settings. | | |  <input type="checkbox" disabled checked /> |

Note that these roles and permissions are all scoped to the current [Scope]({{site.baseurl}}/docs/enterprise/scopes). There is also a special admin role scoped to `ALLSCOPES` which means it can delete scopes, plugins, and gems across all scopes.
