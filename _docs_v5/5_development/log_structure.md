---
layout: docs
title: Log Structure
toc: true
---

## Packet Log File Format

Packet logs in COSMOS 5 are used to store raw binary packets as received from various targets, as
well as decommutated packets stored as JSON structures.

### File Header

COSMOS 5 Packet log files start with the 8-character sequence "OpenC3_5". This can be used to identify the type of file independent of filename and differentiate them from newer and older versions.

### Entry Types

Packet log files have 4 different entry types with room for future expansion. All entry headers are big endian binary data.

#### Common Entry Format

This common format is used for all packet log entries as well as the corresponding index file entries.

| Field         | Data Type               | Description                                                                                                                       |
| ------------- | ----------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Length        | 32-bit Unsigned Integer | Total length of the entry in bytes not including the length field. Max entry size is therefore 4GiB.                              |
| Entry Type    | 4-bit Unsigned Integer  | Entry Type:<br/>1 = Target Declaration<br/>2 = Packet Declaraction<br/>3 = Raw Packet<br/>4 = JSON Packet                         |
| Cmd/Tlm Flag  | 1-bit Unsigned Integer  | 1 = Command<br/>0 = Telemetry                                                                                                     |
| Stored Flag   | 1-bit Unsigned Integer  | 1 = Stored Data<br/>0 = Realtime Data                                                                                             |
| Id Flag       | 1-bit Unsigned Integer  | 1 = ID present<br/>0 = ID not present                                                                                             |
| Reserved      | 9-bit Unsigned Integer  | Reserved for Future expansion. Should be set to 0 if unused.                                                                      |
| Entry Data    | Variable                | Unique data based on entry type. See Entry Types Below                                                                            |
| Id (Optional) | 32-byte Binary Hash     | If the ID field is set, this is a binary 256-bit SHA-256 hash uniquely identifying a target configuration or packet configuration |

#### Target Declaration Entry

| Field       | Data Type                    | Description |
| ----------- | ---------------------------- | ----------- |
| Target Name | Variable-Length ASCII String | Target Name |

#### Packet Declaration Entry

| Field        | Data Type                    | Description                                                                                                                                                                                                        |
| ------------ | ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Target Index | 16-bit Unsigned Integer      | Index into a dynamically built table of target names, generated from the order of the target declarations in the file. The first target declaration gets index 0, the second target declaration gets index 1, etc. |
| Packet Name  | Variable-Length ASCII String | Packet Name                                                                                                                                                                                                        |

#### Raw Packet and JSON Packet Entries

| Field        | Data Type                  | Description                                                                                                                                                                                                                                                                                                                  |
| ------------ | -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Packet Index | 16-bit Unsigned Integer    | Index into a dynamically built table of cmd_or_tlm/target name/packet name tuples, generated from the order of the packet declarations in the file. The first packet declaration gets index 0, the second packet declaration gets index 1, etc. This limits the max number of unique packet types in a single file to 65536. |
| Timestamp    | 64-bit Unsigned Integer    | Packet timestamp in nanoseconds from the unix epoch (Jan 1st, 1970, midnight). The packet received time for raw packet entries, and the “packet time” for JSON packet entries (which are used to store decommutated date). For JSON packet entries, the packet received time can be extracted from the JSON data if needed.  |
| Packet Data  | Variable-Length Block Data | The Raw binary packet data for Raw Packet entries, and ASCII JSON data for JSON packet entries. Note the Common Id field is not supported with either type of packet entry.                                                                                                                                                  |

## Index Files

Alongside each Packet Log File, COSMOS 5 also created a separate index file with the same name but a file extension of ".idx". This file is designed to allow quick binary searches on the corresponding packet log by timestamp.

### File Header

COSMOS 5 Packet log files start with the 8-character sequence "OC3IDX_5". This can be used to identify the type of file independent of filename and differentiate them from newer and older versions.

#### Index File Entries

Index file entries are the same as the corresponding packet entries, except the packet data field is replaced by 64-bit unsigned integer with the offset into the corresponding packet log file, where the full packet entry exists.

| Field        | Data Type               | Description                                                                                                                                                                                                                                                                                                                  |
| ------------ | ----------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Packet Index | 16-bit Unsigned Integer | Index into a dynamically built table of cmd_or_tlm/target name/packet name tuples, generated from the order of the packet declarations in the file. The first packet declaration gets index 0, the second packet declaration gets index 1, etc. This limits the max number of unique packet types in a single file to 65536. |
| Timestamp    | 64-bit Unsigned Integer | Packet timestamp in nanoseconds from the unix epoch (Jan 1st, 1970, midnight). The packet received time for raw packet entries, and the “packet time” for JSON packet entries (which are used to store decommutated date). For JSON packet entries, the packet received time can be extracted from the JSON data if needed.  |
| Offset       | 64-bit Unsigned Integer | File offset in bytes to the beginning of the corresponding entry in the packet log file.                                                                                                                                                                                                                                     |

### Index File Footer

All of the target declaration entries and packet declaration entries from the corresponding packet log file are written out together at the very end of index files. This makes the entire index file up to this point a set of fixed size entries that can be very quickly searched (as opposed to the standard packet log file where every entry is variably sized).

| Field                               | Data Type               | Description                                                   |
| ----------------------------------- | ----------------------- | ------------------------------------------------------------- |
| Count of Target Declaration Entries | 16-bit Unsigned Integer | The number of target declaration entries that follow.         |
| Target Declaration Entries          | Variable Sized          | Array of target declaration entries                           |
| Count of Packet Declaration Entries | 16-bit Unsigned Integer | The number of packet declaration entries that follow.         |
| Packet Declaration Entries          | Variable Sized          | Array of packet declaration entries                           |
| Index File Footer Length            | 32-bit Unsigned Integer | The entire length of the footer (including this length field) |
