---
layout: docs
title: Host Install
toc: true
---

## Installing OpenC3 Directly onto a Host (No Containers)

Note: THIS IS NOT A RECOMMENDED CONFIGURATION.

OpenC3 5 is released as containers and intended to be run as containers. However, for various reasons someone might want to run OpenC3 directly on a host. These instructions will walk through getting OpenC3 5 installed and running directly on RHEL 7 or Centos 7. This configuration will create a working install, but falls short of the ideal in that it does not setup the OpenC3 processes as proper services on the host OS (that restart themselves on boot, and maintain themselves running in case of errors). Contributions that add that functionality are welcome.

Let's get started.

1. The starting assumption is that you have a fresh install of either RHEL 7 or Centos 7. You are running as a normal user that has sudo permissions, and has git installed.

2. Start by downloading the latest working version of OpenC3 from Github

   ```
   cd ~
   git clone https://github.com/OpenC3/openc3.git
   ```

3. Run the OpenC3 installation script

   If you are feeling brave, you can run the one large installer script that installs everything in one step:

   ```
   cd OpenC3/examples/hostinstall/centos7
   ./openc3_install.sh
   ```

   Or, you may want to break it down to the same steps that are in that script, and make sure each individual step is successful:

   ```
   cd OpenC3/examples/hostinstall/centos7
   ./openc3_install_packages.sh
   ./openc3_install_ruby.sh
   ./openc3_install_redis.sh
   ./openc3_install_minio.sh
   ./openc3_install_traefik.sh
   ./openc3_install_openc3.sh
   ./openc3_start_services.sh
   ./openc3_first_init.sh
   ```

4. If all was successful, you should be able to open Firefox, and goto: http://localhost:2900. Congrats you have OpenC3 running directly on a host.

5. As stated at the beginning, this is not currently a supported configuration. Contributions that help to improve it are welcome.
