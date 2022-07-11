---
layout: docs
title: Philosophy
---

OpenC3 is a C3 (Command, Control and Communication) system with the following primary goals:

1.	Interface with Anything

OpenC3 should be able to communicate with anything that provides a computer-to-computer interface, regardless of what the interface is.   This means that OpenC3 adapts to what other systems are doing and evolves over time.   It does not publish an API that hardware must adhere to if it wants to communicate with OpenC3.

2.	Log Everything

All data that flows into and out of OpenC3 is logged. This provides history as well as attribution for what happened when and why.  Keeping accurate logs is an essential and critical aspect of OpenC3.

3.	Open Architecture and Source

Nothing about how OpenC3 is implemented is meant to be secret or hidden, even in Enterprise Edition.  In all editions, the source code for everything in OpenC3 is provided and available for users to inspect or modify as needed.  Never worry about an unsolvable problem or having to accept some detail that you don't like.   This also opens the world to integrate anything they need into OpenC3 without restriction or limitation.

4.	Be Modular

There are infinite number of things for OpenC3 to connect to, but it is impossible to ship OpenC3 with all the code it would need to talk to everything.  For this reason, OpenC3 is designed to be modular in all the places that matter.

5.	Use Configuration when Possible, and Code When Logic Is Needed

Configuration is great for making OpenC3 as usable as possible by non-software engineers.  It also shows where common patterns exist.  However, configuration is horrible when logic or custom math are needed.

6.	Empower Developers

OpenC3 is meant to be easy enough to be used by everyone, not just C2 software experts.
