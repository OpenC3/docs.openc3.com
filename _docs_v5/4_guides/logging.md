---
layout: docs
title: Logging
toc: true
---

The COSMOS [Bucket Explorer]({{site.baseurl}}/docs/v5/bucket-explorer) tool provides a way to browse the COSMOS bucket storage backend whether you are running locally or in a cloud environment. Browse to http://localhost:2900/tools/bucketexplorer and you should see the list of buckets at the top:

![Bucket Explorer]({{site.baseurl}}/img/v5/bucket_explorer/bucket_explorer.png)

Note the config and logs buckets are organized by scopes of which there initially is just one: DEFAULT. Clicking the DEFAULT folder in the logs bucket shows the decom_logs, raw_logs, reduced_xxx_logs, text_logs and tool_logs.

### decom_logs & raw_logs

The decom_logs and raw_logs folders contain the decommutated and raw command and telemetry data. Both are further broken down by target, packet, then date. For example, browsing into the DEFAULT/raw_logs/tlm/INST2/ directory:

![raw_tlm_logs]({{site.baseurl}}/img/v5/guides/logging/raw_tlm_logs.png)

Note the presence of both gzipped .bin files and .idx files. The .bin files contain the raw binary data while the idx files are index files designed to allow quick binary searches on the corresponding packet logs. For more information about the structure of these files see the [Log Structure]({{site.baseurl}}/docs/v5/log-structure) developer documentation.

The default settings for the Logging microservice is to start a new log file every 10 minutes or 50MB, which ever comes first. In the case of the low data rate demo, the 10 minute mark is hit first.

To change the logging settings add the various CYCLE_TIME [Target Modifiers]({{site.baseurl}}/docs/v5/plugins#target-modifiers) under the declared [TARGET]({{site.baseurl}}/docs/v5/plugins#target-1) name in your plugin.txt.

### text_logs

The text_logs folder contains openc3_log_messages and openc3_notifications.

#### openc3_log_messages

The cosmos_log_messages folder contains text files which are again sorted by date and timestamped. These log messages come from the various microservices including the server and the target microservices. Thus these logs contain all the commands sent (in plain text) and telemetry checked.

#### openc3_notifications

The openc3_notifications folder contains all the notifications which are accessible from the Bell icon in the status bar.

![notifications]({{site.baseurl}}/img/v5/guides/logging/notifications.png)

### tool_logs

The tool_logs directory contains logs from the various COSMOS tools. Note that if you have not yet run any tools you may not see this directory as it is created on demand. Tool sub-directories are also created on demand. For example, after running a script in Script Runner a new 'sr' subdirectory appears which contains the script runner log resulting from running the script. In some cases logs in this directory may also be directly available from the tool itself. In the Script Runner case, the Log Messages pane below the script holds the output messages from the last script. Clicking the Download link allows you to download these messages as a file.

![log_messages]({{site.baseurl}}/img/v5/guides/logging/log_messages.png)
