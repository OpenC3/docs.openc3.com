---
layout: docs
title: Calendar
toc: true
---

## Introduction

Calendar visualizes metadata, narrative, and timeline information in one easy to understand place. Timelines allow for the simple execution of commands and scripts based on future dates and times.

![Calendar]({{site.baseurl}}/img/v5/calendar/calendar.png)

## Types of Events

- Metadata

- Narrative

- Activity

### Metadata

Metadata allows you to record arbitrary data into the OpenC3 system. For example, you could ask the user for inputs which fall outside the available target telemetry including user defined IDs, environmental factors, procedural steps, etc. This allows for searching metadata based on these fields and correlating the related telemetry data.

### Narrative

A simple way to record events on the calendar, for example a test window or anything else...

### Activity

Scheduled on a timeline these can run single commands or run a script.

### Adding Timelines

Adding a Timeline to OpenC3.

 - Each timeline consists of several threads so be careful of your compute resources you have as you can overwhelm OpenC3 with lots of these.
 - Note you can not have overlapping activities on a single calendar.

### Timeline lifecycle

When a user creates a timeline, the OpenC3 operator see a new microservice has been created. This signals the operator to start a new microservice, the timeline microservice. The timeline microservice is the main thread of execution for the timeline. This starts a scheduler manager thread. The scheduler manger thread contains a thread pool that hosts more then one thread to run the activity. The scheduler manger will evaluate the schedule and based on the start time of the activity it will add the activity to the queue.

The main thread will block on the web socket to listen to request changes to the timeline, these could be adding, removing, or updating activities. The main thread will make the changes to the in memory schedule if these changes are within the hour of the current time. When the web socket gets an update it has an action lookup table. These actions are "created", "updated", "deleted", ect... Some actions require updating the schedule from the database to ensure the schedule and the database are always in synk.

The schedule thread checks every second to make sure if a task can be run. If the start time is equal or less then the last 15 seconds it will then check the previously queued jobs list in the schedule. If the activity has not been queued and is not fulfilled the activity will be queued, this adds an event to the activity but is not saved to the database. (TODO) This could be improved upon as a way to wake the thread when a change to the schedule happens or when a job needs to run.

The workers are plain and simple, they block on the queue until an activity is placed on the queue. Once a job is pulled from the queue they check the type and run the activity. The thread will mark the activity fulfillment true and update the database record with the complete. If the worker gets an error while trying to run the task the activity will NOT be fulfilled and record the error in the database.

![Timeline Lifecycle]({{site.baseurl}}/img/v5/calendar/timeline_lifecycle.png)