---
layout: docs
title: Logging
toc: true
---

OpenC3 5 includes the open source [minio](https://min.io/) software which is a high-performance S3 compatible object storage. Browse to http://localhost:2900/minio and enter the username and password which are stored in the root .env file as OPENC3_MINIO_USERNAME and OPENC3_MINIO_PASSWORD.

You should see the MinIO Browser and the list of buckets:

![MinIO Browser]({{site.baseurl}}/img/v5/logging/browser.png)

Note the logs bucket is organized by scopes of which there initially is just one: DEFAULT. Clicking that shows the decom_logs, raw_logs, text_logs and tool_logs.

### decom_logs & raw_logs

The decom_logs and raw_logs folders contain the decommutated and raw command and telemetry data. Both are further broken down by target, packet, then date. For example, browsing into the raw_logs/tlm/INST/HEALTH_STATUS:

![raw_tlm_logs]({{site.baseurl}}/img/v5/logging/raw_tlm_logs.png)

Note the presence of both .bin files and .idx files. The .bin files contain the raw binary data  while the idx files are index files designed to allow quick binary searches on the corresponding packet logs. For more information about the structure of these files see the [Log Structure]({{site.baseurl}}/docs/v5/log-structure) developer documentation.

The default settings for the Logging microservice is to start a new log file every 10 minutes or 50MB, which ever comes first. In the case of the low data rate demo, the 10 minute mark is hit first.

<div class="note unreleased">
  <p>Decribe how to change the logging parameters</p>
</div>

### text_logs

The text_logs folder contains openc3_log_messages and openc3_notifications.

#### openc3_log_messages

The cosmos_log_messages folder contains text files which are again sorted by date and timestamped. These log messages come from the various microservices including the server and the target microservices. Thus these logs contain all the commands sent (in plain text) and telemetry checked.

#### openc3_notifications

The openc3_notifications folder contains all the notifications which are accessible from the Bell icon in the status bar.

![notifications]({{site.baseurl}}/img/v5/logging/notifications.png)

### tool_logs

The tool_logs directory contains logs from the various OpenC3 tools. Note that if you have not yet run any tools you may not see this directory as it is created on demand. Tool sub-directories are also created on demand. For example, after running a script in Script Runner a new 'sr' subdirectory appears which contains the script runner log resulting from running the script. In some cases logs in this directory may also be directly available from the tool itself. In the Script Runner case, the Log Messages pane below the script holds the output messages from the last script. Clicking the Download link allows you to download these messages as a file.

![log_messages]({{site.baseurl}}/img/v5/logging/log_messages.png)
