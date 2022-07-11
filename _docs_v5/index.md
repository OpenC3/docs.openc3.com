---
layout: docs
title: Welcome
---

This site aims to be a comprehensive guide to OpenC3. We'll cover topics such
as getting your configuration up and running, developing test and operations scripts,
building custom telemetry screens, and give you some advice on participating in the future
development of OpenC3 itself.

## So what is OpenC3, exactly?

OpenC3 is a suite of applications that can be used to control a set of embedded systems. These systems can be
anything from test equipment (power supplies, oscilloscopes, switched power strips, UPS devices, etc), to
development boards (Arduinos, Raspberry Pi, Beaglebone, etc), to satellites.

### OpenC3 Architecture

![OpenC3 Architecture]({{site.baseurl}}/img/v5/architecture.png)

OpenC3 5 is a cloud native, containerized, microservice oriented command and control system. All the OpenC3 microservices are docker containers which is why Docker is shown containing the entire OpenC3 system. The green boxes on the left represent external embedded systems (Targets) which OpenC3 connects to. The Redis data store contains the configuration for all the microservices, the current value table, as well as data streams containing decommutated data. The Minio data store contains plugins, targets, configuration data, text logs as well as binary logs of all the raw, decommutated, and reduced data. Users interact with OpenC3 from a web browser which routes through the internal Traefik load balancer.

Keep reading for an in-depth discussion of each of the OpenC3 Tools.

## Helpful Hints

Throughout this guide there are a number of small-but-handy pieces of
information that can make using OpenC3 easier, more interesting, and less
hazardous. Here's what to look out for.

<div class="note">
  <h5>ProTips™ help you get more from OpenC3</h5>
  <p>These are tips and tricks that will help you be a OpenC3 wizard!</p>
</div>

<div class="note info">
  <h5>Notes are handy pieces of information</h5>
  <p>These are for the extra tidbits sometimes necessary to understand
     OpenC3.</p>
</div>

<div class="note warning">
  <h5>Warnings help you not blow things up</h5>
  <p>Be aware of these messages if you wish to avoid certain death.</p>
</div>

<div class="note unreleased">
  <h5>You'll see this by a feature that hasn't been released</h5>
  <p>Some pieces of this website are for future versions of OpenC3 that
    are not yet released.</p>
</div>

<div class="note">
  <h5>Find a problem in the documentation?</h5>
  <p>
    Please <a
    href="{{ site.repository }}/issues/new/choose">create an issue</a> on
    GitHub describing what we can do to make it better.
  </p>
  <h5>Let us know what could be better!</h5>
  <p>
    Both using and hacking on OpenC3 should be fun, simple, and easy, so if for
    some reason you find it's a pain, please <a
    href="{{ site.openc3 }}/issues/new/choose">create an issue</a> on
    GitHub describing your experience so we can make it better.
  </p>
</div>