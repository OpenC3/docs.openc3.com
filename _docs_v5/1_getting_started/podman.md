---
layout: docs
title: Podman
---

### OpenC3 COSMOS Using Rootless Podman and Docker-Compose

<div class="note info">
  <h5>Optional Installation Option</h5>
  <p style="margin-bottom:20px;">These directions are for installing and running COSMOS using Podman instead of Docker. If you have Docker available, that is a simpler method.</p>
</div>

Podman is an alternative container technology to Docker that is actively promoted by RedHat. The key benefit is that Podman can run without a root-level daemon service, making it significantly more secure by design, over standard Docker. However, it is a little more complicated to use. These directions will get you up and running with Podman. The following directions were written against RHEL 8.6, but should be similar on other operating systems.

<div class="note warning">
  <h5>RHEL 9 Not Yet Recommended</h5>
  <p style="margin-bottom:20px;">At least on AWS EC2, Podman does not seem to work with the RHEL 9 image as of March 15, 2023. All containers attempted to run with podman immediately die with exit code 127.  The following directions have only been confirmed to work with RHEL 8.6</p>
</div>

1. Install Prerequisite Packages

   Note: This downloads and installs docker-compose from the latest 2.x release on Github. If your operating system has a docker-compose package, it will be easier to install using that instead. RHEL8 does not have a docker-compose package.

   ```bash
   sudo yum update
   sudo yum groupinstall "Development Tools"
   sudo yum install podman-docker netavark
   curl -SL https://github.com/docker/compose/releases/download/v2.16.0/docker-compose-linux-x86_64 -o docker-compose
   sudo mv docker-compose /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
   ```

1. Configure Host OS for Redis

   ```bash
   sudo su
   echo never > /sys/kernel/mm/transparent_hugepage/enabled
   echo never > /sys/kernel/mm/transparent_hugepage/defrag
   sysctl -w vm.max_map_count=262144
   exit
   ```

1. Configure Podman to use Netavark for DNS

   ```bash
   sudo cp /usr/share/containers/containers.conf /etc/containers/.
   sudo vi /etc/containers/containers.conf
   ```

   Then edit the network_backend line to be "netavark" instead of "cni"

1. Start rootless podman socket service

   ```bash
   systemctl enable --now --user podman.socket
   ```

1. Put the following into your .bashrc file (or .bash_profile or whatever)

   ```bash
   export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
   ```

1. Source the profile file for your current terminal

   ```bash
   source .bashrc
   ```

1. Get COSMOS - A release or the current main branch (main branch shown)

   ```bash
   git clone https://github.com/OpenC3/cosmos.git
   ```

1. Optional - Set Default Container Registry

   If you don't want podman to keep querying you for which registry to use, you can create a $HOME/.config/containers/registries.conf and modify to just have the main docker registry (or modify the /etc/containers/registries.conf file directly)

   ```bash
   mkdir -p $HOME/.config/containers
   cp /etc/containers/registries.conf $HOME/.config/containers/.
   vi $HOME/.config/containers/registries.conf
   ```

   Then edit the unqualified-search-registries = line to just have the registry you care about (probably docker.io)

1. Edit compose.yaml

Edit compose.yaml and uncomment the user: 0:0 lines and comment the user: "${OPENC3_USER_ID}:${OPENC3_GROUP_ID}" lines.

1. Run COSMOS

   ```bash
   cd cosmos
   ./openc3.sh start
   or to use our released containers
   ./openc3.sh run
   ```

1. Wait until everything is built and running and then goto http://localhost:2900 in your browser
