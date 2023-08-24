---
layout: docs
title: Performance
---

The COSMOS architecture was created with scalability in mind. Our goal is to support an unlimited number of connections and use cloud technologies to scale. Only [COSMOS Enterprise Edition](https://openc3.com/enterprise) supports Kubernetes and the various cloud platforms which allow this level of scalability. While true scalability is only achieved in COSMOS Enterprise, both Open Source and Enterprise have various levels of obserability and configuration settings which can affect performance.

# COSMOS Hardware Requirements

## Memory

COSMOS can run on a Raspberry Pi up to a Kubernetes cluster in the cloud. On all platforms the key performance factor is the number and complexity of the targets and their defined packets. Targets can vary from simple targets taking 100 MB of RAM to complex targets taking 400 MB. The base COSMOS containers require about 800MB of RAM. A good rule of thumb is to average about 300MB of RAM for targets. As an example data point, the COSMOS Demo has 4 targets, two complex (INST & INST2) and two relatively simple (EXAMPLE & TEMPLATED), and requires 800 MB of RAM.

- RAM MB Calculator = 800 + (num targets) \* 300

## CPU

Another consideration is the processor availability. In the Open Source Edition, by default COSMOS spawns off 2 microservices per target. One combines packet logging and decommutation of the data and the other performs data reduction. In COSMOS Enterprise Edition on Kubernetes, each process becomes an independent microservice that is deployed on the cluster allowing horizontal scaling.

The COSMOS command and telemetry API and script running API servers should have a dedicated core while targets can generally share cores. It's hard to provide a general rule of thumb with the wide variety to architectures, clock speeds, and core counts. The best practice is to install COSMOS with the expected load and do some monitoring with htop to visualize the load on the various cores. Any time a single core gets overloaded (100%) this is a concern and system slowdown can occur.

## Performance Comparison

Performance characterization was performed in Azure on a Standard D4s v5 (4 vcpus, 16 GiB memory) chosen to allow virtualization per [Docker](https://docs.docker.com/desktop/vm-vdi/#turn-on-nested-virtualization-on-microsoft-hyper-v). COSMOS [5.9.1](https://github.com/OpenC3/cosmos-enterprise/releases/tag/v5.9.1) Enterprise Edition was installed on both Windows 11 Pro and Ubuntu 22. Note: Enterprise Edition was not utilizing Kubernetes, just Docker. Testing involved using the COSMOS Demo, connecting all targets (EXAMPLE, INST, INST2, TEMPLATED), opening the following TlmViewer screens (ADCS, ARRAY, BLOCK, COMMANDING, HS, LATEST, LIMITS, OTHER, PARAMS, SIMPLE, TABS) and creating two TlmGrapher graphs consisting of INST HEALTH_STATUS TEMP[1-4] and INST ADCS POS[X,Y,Z] and INST ADCS VEL[X,Y,Z]. This was allowed to run for 1hr and results were collected using htop:

| Platform           | Core CPU %      | RAM          |
| :----------------- | :-------------- | :----------- |
| Windows 11 Pro     | 12% 12% 10% 10% | 3.9G / 7.7G  |
| Headless Ubuntu 22 | 7% 7% 8% 6%     | 3.2G / 15.6G |

A few things to note:

- Windows was only allocated 8 GB of RAM due to the [.wslconfig](https://learn.microsoft.com/en-us/windows/wsl/wsl-config#configuration-setting-for-wslconfig) settings.
- Since Ubuntu was running headless, the screens and graphs were brought up on another machine.

At this point the COSMOS [LoadSim](https://github.com/OpenC3/openc3-cosmos-load-sim) was installed with default settings which creates 10 packets with 1000 items each at 10Hz (110kB/s). htop now indicated:

| Platform           | Core CPU %      | RAM           |
| :----------------- | :-------------- | :------------ |
| Windows 11 Pro     | 40% 35% 39% 42% | 4.64G / 7.7G  |
| Headless Ubuntu 22 | 17% 20% 16% 18% | 3.74G / 15.6G |

As you can see, the larger packets and data rate of the LoadSim target caused both platforms to dramatically increase CPU utilization but the Linux machine stays quite performant.

Consider using a headless Linux machine for maximum performance.

Full specs of the Windows Platform:

```
Windows 11 Pro
Docker Desktop 4.22.0
WSL version: 1.2.5.0
Kernel version: 5.15.90.1
WSLg version: 1.0.51
MSRDC version: 1.2.3770
Direct3D version: 1.608.2-61064218
DXCore version: 10.0.25131.1002-220531-1700.rs-onecore-base2-hyp
Windows version: 10.0.22621.2134
```
