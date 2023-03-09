---
layout: docs
title: Scripting Guide
toc: true
---

This document provides the information necessary to write test procedures using the COSMOS scripting API. Scripting in COSMOS is designed to be simple and intuitive. The code completion ability for command and telemetry mnemonics makes Script Runner the ideal place to write your procedures, however any text editor will do. If there is functionality that you don't see here or perhaps an easier syntax for doing something, please submit a ticket.

## Concepts

### Ruby Programming Language

COSMOS scripting is implemented using the Ruby Programming language. This should be largely transparent to the user, but if advanced processing needs to be done such as writing files, then knowledge of Ruby is necessary. Please see the Ruby Guide for more information about Ruby.

A basic summary of Ruby:

1. There is no 80 character limit on line length. Lines can be as long as you like, but be careful to not make them too long as it makes printed reviews of scripts more difficult.
1. Variables do not have to be declared ahead of time and can be reassigned later, i.e. Ruby is dynamically typed.
1. Variable values can be placed into strings using the "#{variable}" syntax. This is called variable interpolation.
1. A variable declared inside of a block or loop will not exist outside of that block unless it was already declared (see Ruby's variable scoping for more information).

The Ruby programming language provides a script writer a lot of power. But with great power comes great responsibility. Remember when writing your scripts that you or someone else will come along later and need to understand them. Therefore use the following style guidelines:

- Use two spaces for indentation and do NOT use tabs
- Constants should be all caps with underscores
  - `SPEED_OF_LIGHT = 299792458 # meters per s`
- Variable names and method names should be in lowercase with underscores
  - `last_name = "Smith"`
  - `perform_setup_operation()`
- Class names (when used) should be camel case and the files which contain them should match but be lowercase with underscores
  - `class DataUploader # in 'data_uploader.rb'`
  - `class CcsdsUtility # in 'ccsds_utility.rb'`
- Don't add useless comments but instead describe intent

<div style="clear:both;"></div>

The following is an example of good style:

```ruby
load 'TARGET/lib/upload_utility.rb' # library we do NOT want to show executing
load_utility 'TARGET/lib/helper_utility.rb' # library we do want to show executing

# Declare constants
OUR_TARGETS = ['INST','INST2']

# Clear the collect counter of the passed in target name
def clear_collects(target)
  cmd("#{target} CLEAR")
  wait_check("#{target} HEALTH_STATUS COLLECTS == 0", 5)
end

######################################
# START
######################################
helper = HelperUtility.new
helper.setup

# Perform collects on all the targets
OUR_TARGETS.each do |target|
  collects = tlm("#{target} HEALTH_STATUS COLLECTS")
  cmd("#{target} COLLECT with TYPE SPECIAL")
  wait_check("#{target} HEALTH_STATUS COLLECTS == #{collects + 1}", 5)
end

clear_collects('INST')
clear_collects('INST2')
```

This example shows several features of COSMOS scripting in action. Notice the difference between 'load' and 'load_utility'. The first is to load additional scripts which will NOT be shown in Script Runner when executing. This is a good place to put code which takes a long time to run such as image analysis or other looping code where you just want the output. 'load_utility' will visually execute the code line by line to show the user what is happening.

Next we declare our constants and create an array of strings which we store in OUR_TARGETS. Notice the constant is all uppercase with underscores.

Then we declare our local methods of which we have one called clear_collects. Please provide a comment at the beginning of each method describing what it does and the parameters that it takes.

The 'helper_utility' is then created by HelperUtility.new. Note the similarity in the class name and the file name we loaded.

The collect example shows how you can iterate over the array of strings we previously created and use variables when commanding and checking telemetry. The pound bracket #{} notation puts whatever the variable holds inside the #{} into the string. You can even execute additional code inside the #{} like we do when checking for the collect count to increment.

Finally we call our clear_collects method on each target by passing the target name. You'll notice there we used single quotes instead of double quotes. The only difference is that double quotes allow for the #{} syntax and support escape characters like newlines (\n) while single quotes do not. Otherwise it's just a personal style preference.

### Telemetry Types

There are four different ways that telemetry values can be retrieved in COSMOS. The following chart explains their differences.

| Telemetry Type       | Description                                                                                                                                                                                                                                                                                                                  |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Raw                  | Raw telemetry is exactly as it is in the telemetry packet before any conversions. All telemetry items will have a raw value except for Derived telemetry points which have no real location in a packet. Requesting raw telemetry on a derived item will return nil.                                                         |
| Converted            | Converted telemetry is raw telemetry that has gone through a conversion factor such as a state conversion or a polynomial conversion. If a telemetry item does not have a conversion defined, then converted telemetry will be the same as raw telemetry. This is the most common type of telemety used in scripts.          |
| Formatted            | Formatted telemetry is converted telemetry that has gone through a printf style conversion into a string. Formatted telemetry will always have a string representation. If no format string is defined for a telemetry point, then formatted telemetry will be the same as converted telemetry except represented as string. |
| Formatted with Units | Formatted with Units telemetry is the same as Formatted telemetry except that a space and the units of the telemetry item are appended to the end of the string. If no units are defined for a telemetry item then this type is the same as Formatted telemetry.                                                             |

## Writing Test Procedures

### Using Subroutines

Subroutines in COSMOS scripting are first class citizens. They can allow you to perform repetitive tasks without copying the same code multiple times and in multiple different test procedures. This reduces errors and makes your test procedures more maintainable. For example, if multiple test procedures need to turn on a power supply and check telemetry, they can both use a common subroutine. If a change needs to be made to how the power supply is turned on, then it only has to be done in one location and all test procedures reap the benefits. No need to worry about forgetting to update one. Additionally using subroutines allows your high level procedure to read very cleanly and makes it easier for others to review. See the Subroutine Example example.

## Example Test Procedures

### Subroutines

```ruby
# My Utility Procedure: program_utilities.rb
# Author: Bob

#################################################################
# Define helpful subroutines useful by multiple test procedures
#################################################################

# This subroutine will put the instrument into safe mode
def goto_safe_mode
  cmd("INST SAFE")
  wait_check("INST SOH MODE == 'SAFE'", 30)
  check("INST SOH VOLTS1 < 1.0")
  check("INST SOH TEMP1 > 20.0")
  puts("The instrument is in SAFE mode")
end

# This subroutine will put the instrument into run mode
def goto_run_mode
  cmd("INST RUN")
  wait_check("INST SOH MODE == 'RUN'", 30)
  check("INST SOH VOLTS1 > 27.0")
  check("INST SOH TEMP1 > 20.0")
  puts("The instrument is in RUN mode")
end

# This subroutine will turn on the power supply
def turn_on_power
  cmd("GSE POWERON")
  wait_check("GSE SOH VOLTAGE > 27.0")
  check("GSE SOH CURRENT < 2.0")
  puts("WARNING: Power supply is ON!")
end

# This subroutine will turn off the power supply
def turn_off_power
  cmd("GSE POWEROFF")
  wait_check("GSE SOH VOLTAGE < 1.0")
  check("GSE SOH CURRENT < 0.1")
  puts("Power supply is OFF")
end
```

```ruby
# My Test Procedure: run_instrument.rb
# Author: Larry

load_utility("TARGET/lib/program_utilities.rb")

turn_on_power()
goto_run_mode()

# Perform unique tests here

goto_safe_mode()
turn_off_power()
```

### Ruby Control Structures

```ruby
#if, elsif, else structure

x = 3

if tlm("INST HEALTH_STATUS COLLECTS") > 5
  puts "More than 5 collects!"
elsif (x == 4)
  puts "variable equals 4!"
else
  puts "Nothing interesting going on"
end

# Endless loop and single-line if

loop do
  break if tlm("INST HEALTH_STATUS TEMP1") > 25.0
  wait(1)
end

# Do something a given number of times

5.times do
  cmd("INST COLLECT")
end
```

### Iterating over similarly named telemetry points

```ruby
# This block of code goes through the range of numbers 1 through 4 (1..4)
# and checks telemetry items TEMP1, TEMP2, TEMP3, and TEMP4

(1..4).each do |num|
  check("INST HEALTH_STATUS TEMP#{num} > 25.0")
end

# You could also do
num = 1
4.times do
  check("INST HEALTH_STATUS TEMP#{num} > 25.0")
  num = num + 1
end
```

### Prompting for User Input

```ruby
numloops = ask("Please enter the number of times to loop")

numloops.times do
  puts "Looping"
end
```

### Skipping a test case in TestRunner

```ruby
def test_feature_x
  continue = ask("Test feature x?")

  if continue == 'y'
    # Test goes here
  else
    raise SkipTestCase, "Skipping feature x test"
  end
end
```

## Running Test Procedures

## Execution Environment

### Using Script Runner

Script Runner is a graphical application that provides the ideal environment for running and implementing your test procedures. The Script Runner tool is broken into 4 main sections. At the top of the tool is a menu bar that allows you to do such things as open and save files, perform a syntax check, and execute your script.

Next is a tool bar that displays the currently executing script and three buttons, "Start/Go", "Pause/Retry", and "Stop". The Start/Go button is used to start the script and continue past errors or waits. The Pause/Retry button will pause the executing script. If an error is encountered the Pause button changes to Retry to re-execute the errored line. Finally, the Stop button will stop the executing script at any time.

Third is the display of the actual script. While the script is not running, you may edit and compose scripts in this area. A handy code completion feature is provided that will list out the available commands or telemetry points as you are writing your script. Simply begin writing a cmd( or tlm( line to bring up code completion. This feature greatly reduces typos in command and telemetry mnemonics.

Finally, displayed is the log messages. All commands that are sent, errors that occur, and user puts statements appear in this area.

## Test Procedure API

The following methods are designed to be used in test procedures. However, they can also be used in custom built COSMOS tools. Please see the COSMOS Tool API section for methods that are more efficient to use in custom tools.

### Migration from COSMOS v4

The following API methods are either deprecated (will not be ported to COSMOS 5) or currently unimplemented (eventually will be ported to COSMOS 5):

| Method                                | Tool                         | Status                                                |
| ------------------------------------- | ---------------------------- | ----------------------------------------------------- |
| check_raw                             | Script Runner                | Deprecated, use check(..., type: :RAW)                |
| check_formatted                       | Script Runner                | Deprecated, use check(..., type: :FORMATTED)          |
| check_with_units                      | Script Runner                | Deprecated, use check(..., type: :WITH_UNITS)         |
| check_tolerance_raw                   | Script Runner                | Deprecated, use check_tolerance(..., type: :RAW)      |
| clear                                 | Telemetry Viewer             | Unimplemented                                         |
| clear_all                             | Telemetry Viewer             | Unimplemented                                         |
| clear_disconnected_targets            | Script Runner                | Unimplemented                                         |
| close_local_screens                   | Telemetry Viewer             | Unimplemented                                         |
| cmd_tlm_clear_counters                | Command and Telemetry Server | Unimplemented                                         |
| cmd_tlm_reload                        | Command and Telemetry Server | Unimplemented                                         |
| display                               | Telemetry Viewer             | Unimplemented                                         |
| get_all_packet_logger_info            | Command and Telemetry Server | Deprecated                                            |
| get_all_target_info                   | Command and Telemetry Server | Deprecated, use get_target_interfaces                 |
| get_background_tasks                  | Command and Telemetry Server | Deprecated                                            |
| get_cmd_list                          | Command and Telemetry Server | Deprecated, use get_all_commands                      |
| get_cmd_log_filename                  | Command and Telemetry Server | Deprecated                                            |
| get_cmd_param_list                    | Command and Telemetry Server | Deprecated, use get_command                           |
| get_cmd_tlm_disconnect                | Script Runner                | Deprecated, use $disconnect                           |
| get_disconnected_targets              | Script Runner                | Unimplemented                                         |
| get_interface_info                    | Command and Telemetry Server | Deprecated, use get_interface                         |
| get_interface_targets                 | Command and Telemetry Server | Deprecated                                            |
| get_output_logs_filenames             | Command and Telemetry Server | Deprecated                                            |
| get_packet                            | Command and Telemetry Server | Deprecated, use get_packets                           |
| get_packet_data                       | Command and Telemetry Server | Deprecated, use get_packets                           |
| get_packet_logger_info                | Command and Telemetry Server | Deprecated                                            |
| get_packet_loggers                    | Command and Telemetry Server | Deprecated                                            |
| get_replay_mode                       | Replay                       | Deprecated                                            |
| get_router_info                       | Command and Telemetry Server | Deprecated, use get_router                            |
| get_screen_definition                 | Telemetry Viewer             | Unimplemented                                         |
| get_screen_list                       | Telemetry Viewer             | Unimplemented                                         |
| get_scriptrunner_message_log_filename | Command and Telemetry Server | Deprecated                                            |
| get_server_message                    | Command and Telemetry Server | Deprecated                                            |
| get_server_message_log_filename       | Command and Telemetry Server | Deprecated                                            |
| get_server_status                     | Command and Telemetry Server | Unimplemented                                         |
| get_target_ignored_items              | Command and Telemetry Server | Deprecated, use get_target                            |
| get_target_ignored_parameters         | Command and Telemetry Server | Deprecated, use get_target                            |
| get_target_info                       | Command and Telemetry Server | Deprecated, use get_target                            |
| get_tlm_details                       | Command and Telemetry Server | Deprecated                                            |
| get_tlm_item_list                     | Command and Telemetry Server | Deprecated                                            |
| get_tlm_list                          | Command and Telemetry Server | Deprecated                                            |
| get_tlm_log_filename                  | Command and Telemetry Server | Deprecated                                            |
| interface_state                       | Command and Telemetry Server | Deprecated, use get_interface                         |
| local_screen                          | Script Runner                | Unimplemented                                         |
| override_tlm_raw                      | Command and Telemetry Server | Deprecated, use override_tlm                          |
| open_directory_dialog                 | Script Runner                | Deprecated                                            |
| replay_move_end                       | Replay                       | Deprecated                                            |
| replay_move_index                     | Replay                       | Deprecated                                            |
| replay_move_start                     | Replay                       | Deprecated                                            |
| replay_play                           | Replay                       | Deprecated                                            |
| replay_reverse_play                   | Replay                       | Deprecated                                            |
| replay_select_file                    | Replay                       | Deprecated                                            |
| replay_set_playback_delay             | Replay                       | Deprecated                                            |
| replay_status                         | Replay                       | Deprecated                                            |
| replay_step_back                      | Replay                       | Deprecated                                            |
| replay_step_forward                   | Replay                       | Deprecated                                            |
| replay_stop                           | Replay                       | Deprecated                                            |
| router_state                          | Command and Telemetry Server | Deprecated, use get_router                            |
| run_mode                              | Script Runner                | Unimplemented                                         |
| save_file_dialog                      | Script Runner                | Deprecated                                            |
| set_cmd_tlm_disconnect                | Script Runner                | Deprecated, use disconnect_script                     |
| set_disconnected_targets              | Script Runner                | Unimplemented                                         |
| set_replay_mode                       | Replay                       | Deprecated                                            |
| set_stdout_max_lines                  | Script Runner                | Unimplemented                                         |
| set_tlm_raw                           | Script Runner                | Deprecated, use set_tlm                               |
| show_backtrace                        | Script Runner                | Deprecated, backtrace always shown                    |
| shutdown_cmd_tlm                      | Command and Telemetry Server | Deprecated                                            |
| start_cmd_log                         | Command and Telemetry Server | Deprecated                                            |
| start_logging                         | Command and Telemetry Server | Deprecated                                            |
| start_new_scriptrunner_message_log    | Command and Telemetry Server | Deprecated                                            |
| start_new_server_message_log          | Command and Telemetry Server | Deprecated                                            |
| start_tlm_log                         | Command and Telemetry Server | Deprecated                                            |
| step_mode                             | Script Runner                | Unimplemented                                         |
| stop_background_task                  | Command and Telemetry Server | Deprecated                                            |
| stop_cmd_log                          | Command and Telemetry Server | Deprecated                                            |
| stop_logging                          | Command and Telemetry Server | Deprecated                                            |
| stop_tlm_log                          | Command and Telemetry Server | Deprecated                                            |
| subscribe_limits_events               | Command and Telemetry Server | Unimplemented                                         |
| subscribe_packet_data                 | Command and Telemetry Server | Deprecated, use subscribe_packets                     |
| subscribe_server_messages             | Command and Telemetry Server | Unimplemented                                         |
| tlm_raw                               | Script Runner                | Deprecated, use tlm(..., type: :RAW)                  |
| tlm_formatted                         | Script Runner                | Deprecated, use tlm(..., type: :FORMATTED)            |
| tlm_with_units                        | Script Runner                | Deprecated, use tlm(..., type: :WITH_UNITS)           |
| tlm_variable                          | Script Runner                | Deprecated, use tlm() and pass type:)                 |
| unsubscribe_limits_events             | Command and Telemetry Server | Deprecated                                            |
| unsubscribe_packet_data               | Command and Telemetry Server | Deprecated                                            |
| unsubscribe_server_messages           | Command and Telemetry Server | Deprecated                                            |
| wait_raw                              | Script Runner                | Deprecated, use wait(..., type: :RAW)                 |
| wait_check_raw                        | Script Runner                | Deprecated, use wait_check(..., type: :RAW)           |
| wait_tolerance_raw                    | Script Runner                | Deprecated, use wait_tolerance(..., type: :RAW)       |
| wait_check_tolerance_raw              | Script Runner                | Deprecated, use wait_check_tolerance(..., type: :RAW) |

The following API methods are new in COSMOS 5:

| Method             | Tool                         |
| ------------------ | ---------------------------- |
| get_all_commands   | Command and Telemetry Server |
| get_all_telemetry  | Command and Telemetry Server |
| get_command        | Command and Telemetry Server |
| get_interface      | Command and Telemetry Server |
| get_item           | Command and Telemetry Server |
| get_packets        | Command and Telemetry Server |
| get_router         | Command and Telemetry Server |
| get_setting        | Command and Telemetry Server |
| get_settings       | Command and Telemetry Server |
| get_target         | Command and Telemetry Server |
| get_target_file    | Script Runner                |
| put_target_file    | Script Runner                |
| delete_target_file | Script Runner                |
| get_telemetry      | Command and Telemetry Server |
| metadata_all       | Script Runner                |
| metadata_get       | Script Runner                |
| metadata_set       | Script Runner                |
| metadata_update    | Script Runner                |
| metadata_input     | Script Runner                |
| list_configs       | Various                      |
| list_settings      | Command and Telemetry Server |
| load_config        | Various                      |
| save_setting       | Command and Telemetry Server |
| subscribe_packets  | Command and Telemetry Server |

## Retrieving User Input

These methods allow the user to enter values that are needed by the script.

### ask

Prompts the user for input with a question. User input is automatically converted from a string to the appropriate data type. For example if the user enters "1", the number 1 as an integer will be returned.

Syntax:

```ruby
ask("<question>")
```

| Parameter        | Description                                                                                                                             |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| question         | Question to prompt the user with.                                                                                                       |
| blank_or_default | Whether or not to allow empty responses (optional - defaults to false). If a non-boolean value is passed it is used as a default value. |
| password         | Whether to treat the entry as a password which is displayed with dots and not logged.                                                   |

Example:

```ruby
value = ask("Enter an integer")
value = ask("Enter a value or nothing", true)
value = ask("Enter a value", 10)
password = ask("Enter your password", false, true)
```

### ask_string

Prompts the user for input with a question. User input is always returned as a string. For exampe if the user enters "1", the string "1" will be returned.

Syntax:

```ruby
ask_string("<question>")
```

| Parameter        | Description                                                                                                                             |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| question         | Question to prompt the user with.                                                                                                       |
| blank_or_default | Whether or not to allow empty responses (optional - defaults to false). If a non-boolean value is passed it is used as a default value. |
| password         | Whether to treat the entry as a password which is displayed with dots and not logged.                                                   |

Example:

```ruby
string = ask_string("Enter a String")
string = ask_string("Enter a value or nothing", true)
string = ask_string("Enter a value", "test")
password = ask_string("Enter your password", false, true)
```

### message_box

### vertical_message_box

### combo_box

The message_box, vertical_message_box, and combo_box methods create a message box with arbitrary buttons or selections that the user can click. The text of the button clicked is returned.

Syntax:

```ruby
message_box("<message>", "<button text 1>", ...)
vertical_message_box("<message>", "<button text 1>", ...)
combo_box("<message>", "<selection text 1>", ...)
```

| Parameter             | Description                      |
| --------------------- | -------------------------------- |
| message               | Message to prompt the user with. |
| button/selection text | Text for a button or selection   |

Example:

```ruby
value = message_box("Select the sensor number", 'One', 'Two')
value = vertical_message_box("Select the sensor number", 'One', 'Two')
value = combo_box("Select the sensor number", 'One', 'Two')
case value
when 'One'
  puts 'Sensor One'
when 'Two'
  puts 'Sensor Two'
end
```

### get_target_file

Return a file handle to a file in the target directory

Syntax:

```ruby
get_target_file("<File Path>", original: false)
```

| Parameter | Description                                                                                                           |
| --------- | --------------------------------------------------------------------------------------------------------------------- |
| path      | The path to the file in the target directory. Should assume to start with a TARGET name, e.g. INST/procedures/proc.rb |
| original  | Whether to get the original file from the plug-in, or any modifications to the file                                   |

Example:

```ruby
file = get_target_file("INST/data/attitude.bin")
puts file.read().formatted # format a binary file
file.unlink # delete file
file = get_target_file("INST/procedures/checks.rb", original: true)
puts file.read()
file.unlink # delete file
```

### put_target_file

Writes a file to the target directory

Syntax:

```ruby
put_target_file("<File Path>", "IO or String")
```

| Parameter | Description                                                                                                                                                                                                                                                                      |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| path      | The path to the file in the target directory. Should assume to start with a TARGET name, e.g. INST/procedures/proc.rb. The file can previously exist or not. Note: The original file from the plug-in will not be modified, however existing modified files will be overwritten. |
| data      | The data can be an IO object or String                                                                                                                                                                                                                                           |

Example:

```ruby
put_target_file("INST/test1.txt", "this is a string test")
file = Tempfile.new('test')
file.write("this is a Io test")
file.rewind
put_target_file("INST/test2.txt", file)
put_target_file("INST/test3.bin", "\x00\x01\x02\x03\xFF\xEE\xDD\xCC") # binary
```

### delete_target_file

Delete a file in the target directory

Syntax:

```ruby
delete_target_file("<File Path>")
```

| Parameter | Description                                                                                                                                                                                                                                   |
| --------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| path      | The path to the file in the target directory. Should assume to start with a TARGET name, e.g. INST/procedures/proc.rb. Note: Only files created with put_target_file can be deleted. Original files from the plugin installation will remain. |

Example:

```ruby
put_target_file("INST/delete_me.txt", "to be deleted")
delete_target_file("INST/delete_me.txt")
```

### open_file_dialog

### open_files_dialog

The open_file_dialog and open_files_dialog methods create a file dialog box so the user can select a single or multiple files. The selected file(s) is returned.

Note: COSMOS 5 has deprecated the save_file_dialog and open_directory_dialog methods. save_file_dialog can be replaced by put_target_file if you want to write a file back to the target. open_directory_dialog doesn't make sense in new architecture so you must request individual files.

Syntax:

```ruby
open_file_dialog("<title>", "<message>", filter: "<filter>")
open_files_dialog("<title>", "<message>", filter: "<filter>")
```

| Parameter | Description                                                                                                                                                                                                                        |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Title     | The title to put on the dialog. Required.                                                                                                                                                                                          |
| Message   | The message to display in the dialog box. Optional parameter.                                                                                                                                                                      |
| Filter    | Named parameter to filter allowed file types. Optional parameter, specified as comma delimited file types, e.g. ".txt,.doc". See https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/file#accept for more information. |

Example:

```ruby
file = open_file_dialog("Open a single file", "Choose something interesting", filter: ".txt")
puts file # Ruby File object
puts file.read
file.delete

files = open_files_dialog("Open multiple files") # message is optional
puts files # Array of File objects (even if you select only one)
files.each do |file|
  puts file
  puts file.read
  file.delete
end
```

## Providing information to the user

These methods notify the user that something has occurred.

### prompt

Displays a message to the user and waits for them to press an ok button.

Syntax:

```ruby
prompt("<message>")
```

| Parameter | Description                      |
| --------- | -------------------------------- |
| message   | Message to prompt the user with. |

Example:

```ruby
prompt("Press OK to continue")
```

## Commands

These methods provide capability to send commands to a target and receive information about commands in the system.

### cmd

Sends a specified command.

Syntax:

```ruby
cmd("<Target Name> <Command Name> with <Param #1 Name> <Param #1 Value>, <Param #2 Name> <Param #2 Value>, ...")
cmd("<Target Name>", "<Command Name>", "Param #1 Name" => <Param #1 Value>, "Param #2 Name" => <Param #2 Value>, ...)
```

| Parameter      | Description                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| Target Name    | Name of the target this command is associated with.                                                  |
| Command Name   | Name of this command. Also referred to as its mnemonic.                                              |
| Param #x Name  | Name of a command parameter. If there are no parameters then the 'with' keyword should not be given. |
| Param #x Value | Value of the command parameter. Values are automatically converted to the appropriate type.          |

Example:

```ruby
cmd("INST COLLECT with DURATION 10, TYPE NORMAL")
cmd("INST", "COLLECT", "DURATION" => 10, "TYPE" => "NORMAL")
```

### cmd_no_range_check

Sends a specified command without performing range checking on its parameters. This should only be used when it is necessary to intentionally send a bad command parameter to test a target.

Syntax:

```ruby
cmd_no_range_check("<Target Name> <Command Name> with <Param #1 Name> <Param #1 Value>, <Param #2 Name> <Param #2 Value>, ...")
cmd_no_range_check("<Target Name>", "<Command Name>", "Param #1 Name" => <Param #1 Value>, "Param #2 Name" => <Param #2 Value>, ...)
```

| Parameter      | Description                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| Target Name    | Name of the target this command is associated with.                                                  |
| Command Name   | Name of this command. Also referred to as its mnemonic.                                              |
| Param #x Name  | Name of a command parameter. If there are no parameters then the 'with' keyword should not be given. |
| Param #x Value | Value of the command parameter. Values are automatically converted to the appropriate type.          |

Example:

```ruby
cmd_no_range_check("INST COLLECT with DURATION 11, TYPE NORMAL")
cmd_no_range_check("INST", "COLLECT", "DURATION" => 11, "TYPE" => "NORMAL")
```

### cmd_no_hazardous_check

Sends a specified command without performing the notification if it is a hazardous command. This should only be used when it is necessary to fully automate testing involving hazardous commands.

Syntax:

```ruby
cmd_no_hazardous_check("<Target Name> <Command Name> with <Param #1 Name> <Param #1 Value>, <Param #2 Name> <Param #2 Value>, ...")
cmd_no_hazardous_check("<Target Name>", "<Command Name>", "Param #1 Name" => <Param #1 Value>, "Param #2 Name" => <Param #2 Value>, ...)
```

| Parameter      | Description                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| Target Name    | Name of the target this command is associated with.                                                  |
| Command Name   | Name of this command. Also referred to as its mnemonic.                                              |
| Param #x Name  | Name of a command parameter. If there are no parameters then the 'with' keyword should not be given. |
| Param #x Value | Value of the command parameter. Values are automatically converted to the appropriate type.          |

Example:

```ruby
cmd_no_hazardous_check("INST CLEAR")
cmd_no_hazardous_check("INST", "CLEAR")
```

### cmd_no_checks

Sends a specified command without performing the parameter range checks or notification if it is a hazardous command. This should only be used when it is necessary to fully automate testing involving hazardous commands that intentially have invalid parameters.

Syntax:

```ruby
cmd_no_checks("<Target Name> <Command Name> with <Param #1 Name> <Param #1 Value>, <Param #2 Name> <Param #2 Value>, ...")
cmd_no_checks("<Target Name>", "<Command Name>", "Param #1 Name" => <Param #1 Value>, "Param #2 Name" => <Param #2 Value>, ...)
```

| Parameter      | Description                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| Target Name    | Name of the target this command is associated with.                                                  |
| Command Name   | Name of this command. Also referred to as its mnemonic.                                              |
| Param #x Name  | Name of a command parameter. If there are no parameters then the 'with' keyword should not be given. |
| Param #x Value | Value of the command parameter. Values are automatically converted to the appropriate type.          |

Example:

```ruby
cmd_no_checks("INST COLLECT with DURATION 11, TYPE SPECIAL")
cmd_no_checks("INST", "COLLECT", "DURATION" => 11, "TYPE" => "SPECIAL")
```

### cmd_raw

Sends a specified command without running conversions.

Syntax:

```ruby
cmd_raw("<Target Name> <Command Name> with <Param #1 Name> <Param #1 Value>, <Param #2 Name> <Param #2 Value>, ...")
cmd_raw("<Target Name>", "<Command Name>", "<Param #1 Name>" => <Param #1 Value>, "<Param #2 Name>" => <Param #2 Value>, ...)
```

| Parameter      | Description                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| Target Name    | Name of the target this command is associated with.                                                  |
| Command Name   | Name of this command. Also referred to as its mnemonic.                                              |
| Param #x Name  | Name of a command parameter. If there are no parameters then the 'with' keyword should not be given. |
| Param #x Value | Value of the command parameter. Values are automatically converted to the appropriate type.          |

Example:

```ruby
cmd_raw("INST COLLECT with DURATION 10, TYPE 0")
cmd_raw("INST", "COLLECT", "DURATION" => 10, TYPE => 0)
```

### cmd_raw_no_range_check

Sends a specified command without running conversions or performing range checking on its parameters. This should only be used when it is necessary to intentionally send a bad command parameter to test a target.

Syntax:

```ruby
cmd_raw_no_range_check("<Target Name> <Command Name> with <Param #1 Name> <Param #1 Value>, <Param #2 Name> <Param #2 Value>, ...")
cmd_raw_no_range_check("<Target Name>", "<Command Name>", "<Param #1 Name>" => <Param #1 Value>, "<Param #2 Name>" => <Param #2 Value>, ...)
```

| Parameter      | Description                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| Target Name    | Name of the target this command is associated with.                                                  |
| Command Name   | Name of this command. Also referred to as its mnemonic.                                              |
| Param #x Name  | Name of a command parameter. If there are no parameters then the 'with' keyword should not be given. |
| Param #x Value | Value of the command parameter. Values are automatically converted to the appropriate type.          |

Example:

```ruby
cmd_raw_no_range_check("INST COLLECT with DURATION 11, TYPE 0")
cmd_raw_no_range_check("INST", "COLLECT", "DURATION" => 11, "TYPE" => 0)
```

### cmd_raw_no_hazardous_check

Sends a specified command without running conversions or performing the notification if it is a hazardous command. This should only be used when it is necessary to fully automate testing involving hazardous commands.

Syntax:

```ruby
cmd_raw_no_hazardous_check("<Target Name> <Command Name> with <Param #1 Name> <Param #1 Value>, <Param #2 Name> <Param #2 Value>, ...")
cmd_raw_no_hazardous_check("<Target Name>", "<Command Name>", "<Param #1 Name>" => <Param #1 Value>, "<Param #2 Name>" => <Param #2 Value>, ...)
```

| Parameter      | Description                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| Target Name    | Name of the target this command is associated with.                                                  |
| Command Name   | Name of this command. Also referred to as its mnemonic.                                              |
| Param #x Name  | Name of a command parameter. If there are no parameters then the 'with' keyword should not be given. |
| Param #x Value | Value of the command parameter. Values are automatically converted to the appropriate type.          |

Example:

```ruby
cmd_raw_no_hazardous_check("INST CLEAR")
cmd_raw_no_hazardous_check("INST", "CLEAR")
```

### cmd_raw_no_checks

Sends a specified command without running conversions or performing the parameter range checks or notification if it is a hazardous command. This should only be used when it is necessary to fully automate testing involving hazardous commands that intentially have invalid parameters.

Syntax:

```ruby
cmd_raw_no_checks("<Target Name> <Command Name> with <Param #1 Name> <Param #1 Value>, <Param #2 Name> <Param #2 Value>, ...")
cmd_raw_no_checks("<Target Name>", "<Command Name>", "<Param #1 Name>" => <Param #1 Value>, "<Param #2 Name>" => <Param #2 Value>, ...)
```

| Parameter      | Description                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| Target Name    | Name of the target this command is associated with.                                                  |
| Command Name   | Name of this command. Also referred to as its mnemonic.                                              |
| Param #x Name  | Name of a command parameter. If there are no parameters then the 'with' keyword should not be given. |
| Param #x Value | Value of the command parameter. Values are automatically converted to the appropriate type.          |

Example:

```ruby
cmd_raw_no_checks("INST COLLECT with DURATION 11, TYPE 1")
cmd_raw_no_checks("INST", "COLLECT", "DURATION" => 11, "TYPE" => 1)
```

### send_raw

Sends raw data on an interface.

Syntax:

```ruby
send_raw(<Interface Name>, <data>)
```

| Parameter      | Description                                    |
| -------------- | ---------------------------------------------- |
| Interface Name | Name of the interface to send the raw data on. |
| Data           | Raw ruby string of data to send.               |

Example:

```ruby
send_raw("INST_INT", data)
```

### get_all_commands (since 5.0.0)

Returns an array of the commands that are available for a particular target. The returned array is an array of hashes which fully describe the command packet.

Syntax:

```ruby
get_all_commands("<Target Name>")
```

| Parameter   | Description         |
| ----------- | ------------------- |
| Target Name | Name of the target. |

Example:

```ruby
cmd_list = get_all_commands("INST")
pp cmd_list
#[{"target_name"=>"INST",
#  "packet_name"=>"ABORT",
#  "endianness"=>"BIG_ENDIAN",
#  "description"=>"Aborts a collect on the instrument",
#  "stale"=>true,
#  "items"=>
#   [{"name"=>"CCSDSVER",
#     "bit_offset"=>0,
#     "bit_size"=>3,
#     ...
```

### get_command (since 5.0.0)

Returns a command hash which fully describes the command packet.

Syntax:

```ruby
get_command("<Target Name>", "<Packet Name>")
```

| Parameter   | Description         |
| ----------- | ------------------- |
| Target Name | Name of the target. |
| Packet Name | Name of the packet. |

Example:

```ruby
cmd = get_command("INST", "ABORT")
pp cmd
#[{"target_name"=>"INST",
#  "packet_name"=>"ABORT",
#  "endianness"=>"BIG_ENDIAN",
#  "description"=>"Aborts a collect on the instrument",
#  "stale"=>true,
#  "items"=>
#   [{"name"=>"CCSDSVER",
#     "bit_offset"=>0,
#     "bit_size"=>3,
#     ...
```

### get_parameter (since 5.0.0)

Returns a hash of the given command parameter

Syntax:

```ruby
get_parameter("<Target Name>", "<Command Name>", "<Parameter Name>")
```

| Parameter      | Description            |
| -------------- | ---------------------- |
| Target Name    | Name of the target.    |
| Command Name   | Name of the command.   |
| Parameter Name | Name of the parameter. |

Example:

```ruby
param = get_parameter("INST", "COLLECT", "TYPE")
pp param
# {"name"=>"TYPE",
# "bit_offset"=>64,
# "bit_size"=>16,
# "data_type"=>"UINT",
# "description"=>"Collect type",
# "default"=>0,
# "minimum"=>0,
# "maximum"=>65535,
# "endianness"=>"BIG_ENDIAN",
# "required"=>true,
# "overflow"=>"ERROR",
# "states"=>{"NORMAL"=>{"value"=>0}, "SPECIAL"=>{"value"=>1, "hazardous"=>""}}}
```

### get_cmd_buffer

Returns a packet hash (similar to get_command) along with the raw packet buffer as a Ruby string.

Syntax:

```ruby
buffer = get_cmd_buffer("<Target Name>", "<Packet Name>")['buffer']
```

| Parameter   | Description         |
| ----------- | ------------------- |
| Target Name | Name of the target. |
| Packet Name | Name of the packet. |

Example:

```ruby
packet = get_cmd_buffer("INST", "COLLECT")
packet['buffer'].unpack('C*') # See the Ruby documentation for class String method unpack
```

### get_cmd_hazardous

Returns true/false indicating whether a particular command is flagged as hazardous.

Syntax:

```ruby
get_cmd_hazardous("<Target Name>", "<Command Name>", <Command Params - optional>)
```

| Parameter      | Description                                                                                                                   |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Target Name    | Name of the target.                                                                                                           |
| Command Name   | Name of the command.                                                                                                          |
| Command Params | Hash of the parameters given to the command (optional). Note that some commands are only hazardous based on parameter states. |

Example:

```ruby
hazardous = get_cmd_hazardous("INST", "COLLECT", {'TYPE' => 'SPECIAL'})
```

### get_cmd_value

Returns reads a value from the most recently sent command packet. The pseudo-parameters 'PACKET_TIMESECONDS', 'PACKET_TIMEFORMATTED', 'RECEIVED_COUNT', 'RECEIVED_TIMEFORMATTED', and 'RECEIVED_TIMESECONDS' are also supported.

Syntax:

```ruby
get_cmd_value("<Target Name>", "<Command Name>", "<Parameter Name>", <Value Type - optional>)
```

| Parameter      | Description                                                      |
| -------------- | ---------------------------------------------------------------- |
| Target Name    | Name of the target.                                              |
| Command Name   | Name of the command.                                             |
| Parameter Name | Name of the command parameter.                                   |
| Value Type     | Value Type to read. :RAW, :CONVERTED, :FORMATTED, or :WITH_UNITS |

Example:

```ruby
value = get_cmd_value("INST", "COLLECT", "TEMP")
```

### get_cmd_time

Returns the time of the most recent command sent.

Syntax:

```ruby
get_cmd_time("<Target Name - optional>", "<Command Name - optional>")
```

| Parameter    | Description                                                                                               |
| ------------ | --------------------------------------------------------------------------------------------------------- |
| Target Name  | Name of the target. If not given, then the most recent command time to any target will be returned        |
| Command Name | Name of the command. If not given, then the most recent command time to the given target will be returned |

Example:

```ruby
target_name, command_name, time = get_cmd_time() # Name of the most recent command sent to any target and time
target_name, command_name, time = get_cmd_time("INST") # Name of the most recent command sent to the INST target and time
target_name, command_name, time = get_cmd_time("INST", "COLLECT") # Name of the most recent INST COLLECT command and time
```

### get_cmd_cnt

Returns the number of times a specified command has been sent.

Syntax:

```ruby
get_cmd_cnt("<Target Name>", "<Command Name>")
```

| Parameter    | Description          |
| ------------ | -------------------- |
| Target Name  | Name of the target.  |
| Command Name | Name of the command. |

Example:

```ruby
cmd_cnt = get_cmd_cnt("INST", "COLLECT") # Number of times the INST COLLECT command has been sent
```

### get_all_cmd_info

Returns the number of times each command has been sent. The return value is an array of arrays where each subarray contains the target name, command name, and packet count for a command.

Syntax / Example:

```ruby
cmd_info = get_all_cmd_info()
cmd_info.each do |target_name, cmd_name, pkt_count|
  puts "Target: #{target_name}, Command: #{cmd_name}, Packet count: #{pkt_count}"
end
```

## Handling Telemetry

These methods allow the user to interact with telemetry items.

### check

Performs a verification of a telemetry item using its converted telemetry type. If the verification fails then the script will be paused with an error. If no comparision is given to check then the telemetry item is simply printed to the script output. Note: In most cases using wait_check is a better choice than using check.

Syntax:

```ruby
check("<Target Name> <Packet Name> <Item Name> <Comparison - optional>")
```

| Parameter   | Description                                                                                                                                        |
| ----------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| Target Name | Name of the target of the telemetry item.                                                                                                          |
| Packet Name | Name of the telemetry packet of the telemetry item.                                                                                                |
| Item Name   | Name of the telemetry item.                                                                                                                        |
| Comparison  | A comparison to perform against the telemetry item. If a comparison is not given then the telemetry item will just be printed into the script log. |

Example:

```ruby
check("INST HEALTH_STATUS COLLECTS > 1")
```

### check_raw

Deprecated: Use check with type: :RAW

Example:

```ruby
check("INST HEALTH_STATUS COLLECTS > 1", type: :RAW)
```

### check_formatted

Deprecated: Use check with type: :FORMATTED

Example:

```ruby
check("INST HEALTH_STATUS COLLECTS == '1'", type: :FORMATTED)
```

### check_with_units

Deprecated: Use check with type: :WITH_UNITS

Example:

```ruby
check("INST HEALTH_STATUS COLLECTS == '1'", type: :WITH_UNITS)
```

### check_tolerance

Checks a converted telemetry item against an expected value with a tolerance. If the verification fails then the script will be paused with an error. Note: In most cases using wait_check_tolerance is a better choice than using check_tolerance.

Syntax:

```ruby
check_tolerance("<Target Name> <Packet Name> <Item Name>", <Expected Value>, <Tolerance>)
```

| Parameter      | Description                                         |
| -------------- | --------------------------------------------------- |
| Target Name    | Name of the target of the telemetry item.           |
| Packet Name    | Name of the telemetry packet of the telemetry item. |
| Item Name      | Name of the telemetry item.                         |
| Expected Value | Expected value of the telemetry item.               |
| Tolerance      | ± Tolerance on the expected value.                  |
| type:          | :CONVERTED (default) or :RAW                        |

Example:

```ruby
check_tolerance("INST HEALTH_STATUS COLLECTS", 10.0, 5.0)
check_tolerance("INST HEALTH_STATUS TEMP1", 50000, 20000, type: :RAW)
```

### check_tolerance_raw

Deprecated: Use check_tolerance with type: :RAW

Example:

```ruby
check_tolerance("INST HEALTH_STATUS COLLECTS", 10.0, 5.0, type: :RAW)
```

### check_expression

Evaluates an expression. If the expression evaluates to false the script will be paused with an error. This method can be used to perform more complicated comparisons than using check as shown in the example. Note: In most cases using [wait_check_expression](#waitcheckexpression) is a better choice than using check_expression.

Remember that everything inside the check_expression string will be evaluated directly by the Ruby interpreter and thus must be valid syntax. A common mistake is to check a variable like so:

`check_expression("#{answer} == 'yes'") # where answer contains 'yes'`

This evaluates to `yes == 'yes'` which is not valid syntax because the variable yes is not defined (usually). The correct way to write this expression is as follows:

`check_expression("'#{answer}' == 'yes'") # where answer contains 'yes'`

Now this evaluates to `'yes' == 'yes'` which is true so the check passes.

Syntax:

```ruby
check_expression("<Expression>")
```

| Parameter  | Description                    |
| ---------- | ------------------------------ |
| Expression | A ruby expression to evaluate. |

Example:

```ruby
check_expression("tlm('INST HEALTH_STATUS COLLECTS') > 5 and tlm('INST HEALTH_STATUS TEMP1') > 25.0")
```

### check_exception

Executes a method and expects an exception to be raised. If the method does not raise an exception, a CheckError is raised.

Syntax:

```ruby
check_exception("<Method Name>", "<Method Params - optional>")
```

| Parameter     | Description                                              |
| ------------- | -------------------------------------------------------- |
| Method Name   | The COSMOS scripting method to execute, e.g. 'cmd', etc. |
| Method Params | Parameters for the method                                |

Example:

```ruby
check_exception("cmd", "INST", "COLLECT", "TYPE" => "NORMAL")
```

### tlm

Reads the converted form of a specified telemetry item.

Syntax:

```ruby
tlm("<Target Name> <Packet Name> <Item Name>")
```

| Parameter   | Description                                                                               |
| ----------- | ----------------------------------------------------------------------------------------- |
| Target Name | Name of the target of the telemetry item.                                                 |
| Packet Name | Name of the telemetry packet of the telemetry item.                                       |
| Item Name   | Name of the telemetry item.                                                               |
| type:       | Named parameter specifying the type. :RAW, :CONVERTED (default), :FORMATTED, :WITH_UNITS. |

Example:

```ruby
value = tlm("INST HEALTH_STATUS COLLECTS")
raw_value = tlm("INST HEALTH_STATUS COLLECTS", type: :RAW)
```

### tlm_raw

Deprecated: Use tlm with type: :FORMATTED

Example:

```ruby
value = tlm("INST HEALTH_STATUS COLLECTS", type: :RAW)
```

### tlm_formatted

Deprecated: Use tlm with type: :FORMATTED

Example:

```ruby
value = tlm("INST HEALTH_STATUS COLLECTS", type: :FORMATTED)
```

### tlm_with_units

Deprecated: Use tlm with type: :WITH_UNITS

Example:

```ruby
value = tlm("INST HEALTH_STATUS COLLECTS", type: WITH_UNITS)
```

### tlm_variable

Deprecated: Use tlm with type: :RAW, type: :CONVERTED (default), type: :FORMATTED, or type: :WITH_UNITS

Example:

```ruby
value = tlm("INST HEALTH_STATUS COLLECTS", type: :RAW)
value = tlm("INST HEALTH_STATUS COLLECTS", type: :CONVERTED)
value = tlm("INST HEALTH_STATUS COLLECTS", type: :FORMATTED)
value = tlm("INST HEALTH_STATUS COLLECTS", type: :WITH_UNITS)
```

### get_tlm_buffer

Returns a packet hash (similar to get_telemetry) along with the raw packet buffer as a Ruby string.

Syntax:

```ruby
buffer = get_tlm_buffer("<Target Name>", "<Packet Name>")['buffer']
```

| Parameter   | Description         |
| ----------- | ------------------- |
| Target Name | Name of the target. |
| Packet Name | Name of the packet. |

Example:

```ruby
packet = get_tlm_buffer("INST", "HEALTH_STATUS")
packet['buffer'].unpack('C*') # See the Ruby documentation for class String method unpack
```

### get_tlm_packet

Returns the names, values, and limits states of all telemetry items in a specified packet. The value is returned as an array of arrays with each entry containing [item_name, item_value, limits_state].

Syntax:

```ruby
get_tlm_packet("<Target Name>", "<Packet Name>", type: :CONVERTED)
```

| Parameter   | Description                                                                                  |
| ----------- | -------------------------------------------------------------------------------------------- |
| Target Name | Name of the target.                                                                          |
| Packet Name | Name of the packet.                                                                          |
| type:       | Named parameter specifying the type. :RAW, :CONVERTED (default), :FORMATTED, or :WITH_UNITS. |

Example:

```ruby
names_values_and_limits_states = get_tlm_packet("INST", "HEALTH_STATUS", type: :FORMATTED)
```

### get_tlm_values (modified in 5.0.0)

Returns the values and current limits state for a specified set of telemetry items. Items can be in any telemetry packet in the system. They can all be retrieved using the same value type or a specific value type can be specified for each item.

Syntax:

```ruby
values, limits_states, limits_settings, limits_set = get_tlm_values(<items>)
```

| Parameter | Description                                                 |
| --------- | ----------------------------------------------------------- |
| items     | Array of strings of the form ['TGT__PKT__ITEM__TYPE', ... ] |

```ruby
values = get_tlm_values(["INST__HEALTH_STATUS__TEMP1__CONVERTED", "INST__HEALTH_STATUS__TEMP2__RAW"])
pp values # [[-100.0, :RED_LOW], [0, :RED_LOW]]
```

### get_all_telemetry (since 5.0.0)

Returns an array of all target packet hashes.

Syntax:

```ruby
get_all_telemetry("<Target Name>")
```

| Parameter   | Description         |
| ----------- | ------------------- |
| Target Name | Name of the target. |

Example:

```ruby
packets = get_all_telemetry("INST")
pp packets
#[{"target_name"=>"INST",
#  "packet_name"=>"ADCS",
#  "endianness"=>"BIG_ENDIAN",
#  "description"=>"Position and attitude data",
#  "stale"=>true,
#  "items"=>
#   [{"name"=>"CCSDSVER",
#     "bit_offset"=>0,
#     "bit_size"=>3,
#     ...
```

### get_telemetry (since 5.0.0)

Returns a packet hash.

Syntax:

```ruby
get_telemetry("<Target Name>", "<Packet Name>")
```

| Parameter   | Description         |
| ----------- | ------------------- |
| Target Name | Name of the target. |
| Packet Name | Name of the packet. |

Example:

```ruby
packet = get_telemetry("INST", "HEALTH_STATUS")
pp packet
#{"target_name"=>"INST",
# "packet_name"=>"HEALTH_STATUS",
# "endianness"=>"BIG_ENDIAN",
# "description"=>"Health and status from the instrument",
# "stale"=>true,
# "processors"=>
#  [{"name"=>"TEMP1STAT",
#    "class"=>"OpenC3::StatisticsProcessor",
#    "params"=>["TEMP1", 100, "CONVERTED"]},
#   {"name"=>"TEMP1WATER",
#    "class"=>"OpenC3::WatermarkProcessor",
#    "params"=>["TEMP1", "CONVERTED"]}],
# "items"=>
#  [{"name"=>"CCSDSVER",
#    "bit_offset"=>0,
#    "bit_size"=>3,
#    ...
```

### get_item (since 5.0.0)

Returns an item hash.

Syntax:

```ruby
get_item("<Target Name>", "<Packet Name>", "<Item Name>")
```

| Parameter   | Description         |
| ----------- | ------------------- |
| Target Name | Name of the target. |
| Packet Name | Name of the packet. |
| Item Name   | Name of the item.   |

Example:

```ruby
item = get_item("INST", "HEALTH_STATUS", "CCSDSVER")
pp item
#{"name"=>"CCSDSVER",
# "bit_offset"=>0,
# "bit_size"=>3,
# "data_type"=>"UINT",
# "description"=>"CCSDS packet version number (See CCSDS 133.0-B-1)",
# "endianness"=>"BIG_ENDIAN",
# "required"=>false,
# "overflow"=>"ERROR"}
```

### get_tlm_cnt

Returns the number of times a specified telemetry packet has been received.

Syntax:

```ruby
get_tlm_cnt("<Target Name>", "<Packet Name>")
```

| Parameter   | Description                   |
| ----------- | ----------------------------- |
| Target Name | Name of the target.           |
| Packet Name | Name of the telemetry packet. |

Example:

```ruby
tlm_cnt = get_tlm_cnt("INST", "HEALTH_STATUS") # Number of times the INST HEALTH_STATUS telemetry packet has been received.
```

### get_all_tlm_info

Returns the number of times each telemetry packet has been received. The return value is an array of arrays where each subarray contains the target name, telemetry packet name, and packet count for a telemetry packet.

Syntax / Example:

```ruby
tlm_info = get_all_tlm_info()
tlm_info.each do |target_name, pkt_name, pkt_count|
  puts "Target: #{target_name}, Packet: #{pkt_name}, Packet count: #{pkt_count}"
end
```

### set_tlm

Sets a telemetry item value in the Command and Telemetry Server. This value will be overwritten if a new packet is received from an interface. For that reason this method is most useful if interfaces are disconnected or for testing via the Script Runner disconnect mode. Manually setting telemetry values allows for the execution of many logical paths in scripts.

Syntax:

```ruby
set_tlm("<Target> <Packet> <Item> = <Value>")
```

| Parameter | Description                                                    |
| --------- | -------------------------------------------------------------- |
| Target    | Target name                                                    |
| Packet    | Packet name                                                    |
| Item      | Item name                                                      |
| Value     | Value to set                                                   |
| type:     | Value type :RAW, :CONVERTED (default), :FORMATTED, :WITH_UNITS |

Example:

```ruby
set_tlm("INST HEALTH_STATUS COLLECTS = 5") # type is :CONVERTED by default
check("INST HEALTH_STATUS COLLECTS == 5")
set_tlm("INST HEALTH_STATUS COLLECTS = 10", type: :RAW)
check("INST HEALTH_STATUS COLLECTS == 10", type: :RAW)
```

### inject_tlm

Injects a packet into the system as if it was received from an interface.

Syntax:

```ruby
inject_tlm("<target_name>", "<packet_name>", <item_hash>, type: :CONVERTED)
```

| Parameter | Description                                                                                                                                                      |
| --------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Target    | Target name                                                                                                                                                      |
| Packet    | Packet name                                                                                                                                                      |
| Item Hash | Hash of item name/value for each item. If an item is not specified in the hash, the current value table value will be used. Optional parameter, defaults to nil. |
| type:     | Type of values in the item hash, :RAW, :CONVERTED (default), :FORMATTED, :WITH_UNITS                                                                             |

Example:

```ruby
inject_tlm("INST", "PARAMS", {'VALUE1' => 5.0, 'VALUE2' => 7.0})
```

### override_tlm

Sets the converted value for a telmetry point in the Command and Telemetry Server. This value will be maintained even if a new packet is received on the interface unless the override is canceled with the normalize_tlm method.

Syntax:

```ruby
override_tlm("<Target> <Packet> <Item> = <Value>")
```

| Parameter | Description                                                                 |
| --------- | --------------------------------------------------------------------------- |
| Target    | Target name                                                                 |
| Packet    | Packet name                                                                 |
| Item      | Item name                                                                   |
| Value     | Value to set                                                                |
| type:     | Type to override, :ALL (default), :RAW, :CONVERTED, :FORMATTED, :WITH_UNITS |

Example:

```ruby
override_tlm("INST HEALTH_STATUS TEMP1 = 5") # All requests for TEMP1 return 5
override_tlm("INST HEALTH_STATUS TEMP2 = 0", type: :RAW) # Only RAW tlm set to 0
```

### normalize_tlm

Clears the override of a telmetry point in the Command and Telemetry Server.

Syntax:

```ruby
normalize_tlm("<Target> <Packet> <Item>")
```

| Parameter | Description                                                                  |
| --------- | ---------------------------------------------------------------------------- |
| Target    | Target name                                                                  |
| Packet    | Packet name                                                                  |
| Item      | Item name                                                                    |
| type:     | Type to normalize, :ALL (default), :RAW, :CONVERTED, :FORMATTED, :WITH_UNITS |

Example:

```ruby
normalize_tlm("INST HEALTH_STATUS TEMP1") # clear all overrides
normalize_tlm("INST HEALTH_STATUS TEMP1", type: :RAW) # clear only the :RAW override
```

## Packet Data Subscriptions

Methods for subscribing to specific packets of data. This provides an interface to ensure that each telemetry packet is received and handled rather than relying on polling where some data may be missed.

### subscribe_packets (since 5.0.3)

Allows the user to listen for one or more telemetry packets of data to arrive. A unique id is returned which is used to retrieve the data.

Syntax:

```ruby
subscribe_packets(packets)
```

| Parameter | Description                                                                         |
| --------- | ----------------------------------------------------------------------------------- |
| packets   | Nested array of target name/packet name pairs that the user wishes to subscribe to. |

Example:

```ruby
id = subscribe_packets([['INST', 'HEALTH_STATUS'], ['INST', 'ADCS']])
```

### get_packets (since 5.0.3)

Streams packet data from a previous subscription.

Syntax:

```ruby
get_packets(id, block: nil, count: 1000)
```

| Parameter | Description                                                                                           |
| --------- | ----------------------------------------------------------------------------------------------------- |
| id        | Unique id returned by subscribe_packets                                                               |
| block     | Number of milliseconds to block while waiting for packets form ANY stream, default nil (do not block) |
| count     | Maximum number of packets to return from EACH packet stream                                           |

Example:

```ruby
id = subscribe_packets([['INST', 'HEALTH_STATUS'], ['INST', 'ADCS']])
wait 0.1
id, packets = get_packets(id)
packets.each do |packet|
  puts "#{packet['PACKET_TIMESECONDS']}: #{packet['target_name']} #{packet['packet_name']}"
end
# Reuse ID from last call, allow for 1s wait, only get 1 packet
id, packets = get_packets(id, block: 1000, count: 1)
packets.each do |packet|
  puts "#{packet['PACKET_TIMESECONDS']}: #{packet['target_name']} #{packet['packet_name']}"
end
```

## Delays

These methods allow the user to pause the script to wait for telemetry to change or for an amount of time to pass.

### wait

Pauses the script for a configurable amount of time (minimum 10ms) or until a converted telemetry item meets given criteria. It supports three different syntaxes as shown. If no parameters are given then an infinite wait occurs until the user presses Go. Note that on a timeout, wait does not stop the script, usually wait_check is a better choice.

Syntax:

```ruby
wait()
wait(<Time>)
```

| Parameter | Description                   |
| --------- | ----------------------------- |
| Time      | Time in Seconds to delay for. |

```ruby
wait("<Target Name> <Packet Name> <Item Name> <Comparison>", <Timeout>, <Polling Rate (optional)>)
```

| Parameter    | Description                                                                                                    |
| ------------ | -------------------------------------------------------------------------------------------------------------- |
| Target Name  | Name of the target of the telemetry item.                                                                      |
| Packet Name  | Name of the telemetry packet of the telemetry item.                                                            |
| Item Name    | Name of the telemetry item.                                                                                    |
| Comparison   | A comparison to perform against the telemetry item.                                                            |
| Timeout      | Timeout in seconds. Script will proceed if the wait statement times out waiting for the comparison to be true. |
| Polling Rate | How often the comparison is evaluated in seconds. Defaults to 0.25 if not specified.                           |

Examples:

```ruby
wait()
wait(5)
wait("INST HEALTH_STATUS COLLECTS == 3", 10)
```

### wait_raw

Deprecated: Use wait with type: :RAW

Examples:

```ruby
wait("INST HEALTH_STATUS COLLECTS == 3", 10, type: :RAW)
```

### wait_tolerance

Pauses the script for a configurable amount of time or until a converted telemetry item meets equals an expected value within a tolerance. Note that on a timeout, wait_tolerance does not stop the script, usually wait_check_tolerance is a better choice.

Syntax:

```ruby
wait_tolerance("<Target Name> <Packet Name> <Item Name>", <Expected Value>, <Tolerance>, <Timeout>, <Polling Rate (optional)>)
```

| Parameter      | Description                                                                                                    |
| -------------- | -------------------------------------------------------------------------------------------------------------- |
| Target Name    | Name of the target of the telemetry item.                                                                      |
| Packet Name    | Name of the telemetry packet of the telemetry item.                                                            |
| Item Name      | Name of the telemetry item.                                                                                    |
| Expected Value | Expected value of the telemetry item.                                                                          |
| Tolerance      | ± Tolerance on the expected value.                                                                             |
| Timeout        | Timeout in seconds. Script will proceed if the wait statement times out waiting for the comparison to be true. |
| Polling Rate   | How often the comparison is evaluated in seconds. Defaults to 0.25 if not specified.                           |

Examples:

```ruby
wait_tolerance("INST HEALTH_STATUS COLLECTS", 10.0, 5.0, 10)
```

### wait_tolerance_raw

Deprecated: Use wait_tolerance with type: :RAW

Examples:

```ruby
wait_tolerance("INST HEALTH_STATUS COLLECTS", 10.0, 5.0, 10, type: :RAW)
```

### wait_expression

Pauses the script until an expression is evaluated to be true or a timeout occurs. If a timeout occurs the script will continue. This method can be used to perform more complicated comparisons than using wait as shown in the example. Note that on a timeout, wait_expression does not stop the script, usually [wait_check_expression](#waitcheckexpression) is a better choice.

Syntax:

```ruby
wait_expression("<Expression>", <Timeout>, <Polling Rate (optional)>)
```

| Parameter    | Description                                                                                                    |
| ------------ | -------------------------------------------------------------------------------------------------------------- |
| Expression   | A ruby expression to evaluate.                                                                                 |
| Timeout      | Timeout in seconds. Script will proceed if the wait statement times out waiting for the comparison to be true. |
| Polling Rate | How often the comparison is evaluated in seconds. Defaults to 0.25 if not specified.                           |

Example:

```ruby
wait_expression("tlm('INST HEALTH_STATUS COLLECTS') > 5 and tlm('INST HEALTH_STATUS TEMP1') > 25.0", 10)
```

### wait_packet

Pauses the script until a certain number of packets have been received. If a timeout occurs the script will continue. Note that on a timeout, wait_packet does not stop the script, usually wait_check_packet is a better choice.

Syntax:

```ruby
wait_packet("<Target>", "<Packet>", <Num Packets>, <Timeout>, <Polling Rate (optional)>)
```

| Parameter    | Description                                                                          |
| ------------ | ------------------------------------------------------------------------------------ |
| Target       | The target name                                                                      |
| Packet       | The packet name                                                                      |
| Num Packets  | The number of packets to receive                                                     |
| Timeout      | Timeout in seconds.                                                                  |
| Polling Rate | How often the comparison is evaluated in seconds. Defaults to 0.25 if not specified. |

Example:

```ruby
wait_packet('INST', 'HEALTH_STATUS', 5, 10) # Wait for 5 INST HEALTH_STATUS packets over 10s
```

### wait_check

Combines the wait and check keywords into one. This pauses the script until the converted value of a telemetry item meets given criteria or times out. On a timeout the script stops.

Syntax:

```ruby
wait_check("<Target Name> <Packet Name> <Item Name> <Comparison>", <Timeout>, <Polling Rate (optional)>)
```

| Parameter    | Description                                                                                                 |
| ------------ | ----------------------------------------------------------------------------------------------------------- |
| Target Name  | Name of the target of the telemetry item.                                                                   |
| Packet Name  | Name of the telemetry packet of the telemetry item.                                                         |
| Item Name    | Name of the telemetry item.                                                                                 |
| Comparison   | A comparison to perform against the telemetry item.                                                         |
| Timeout      | Timeout in seconds. Script will stop if the wait statement times out waiting for the comparison to be true. |
| Polling Rate | How often the comparison is evaluated in seconds. Defaults to 0.25 if not specified.                        |

Example:

```ruby
wait_check("INST HEALTH_STATUS COLLECTS > 5", 10)
```

### wait_check_raw

Deprecated: Use wait_check with type: :RAW

Example:

```ruby
wait_check("INST HEALTH_STATUS COLLECTS > 5", 10, type: :RAW)
```

### wait_check_tolerance

Pauses the script for a configurable amount of time or until a converted telemetry item equals an expected value within a tolerance. On a timeout the script stops.

Syntax:

```ruby
wait_check_tolerance("<Target Name> <Packet Name> <Item Name>", <Expected Value>, <Tolerance>, <Timeout>, <Polling Rate (optional)>)
```

| Parameter      | Description                                                                                                 |
| -------------- | ----------------------------------------------------------------------------------------------------------- |
| Target Name    | Name of the target of the telemetry item.                                                                   |
| Packet Name    | Name of the telemetry packet of the telemetry item.                                                         |
| Item Name      | Name of the telemetry item.                                                                                 |
| Expected Value | Expected value of the telemetry item.                                                                       |
| Tolerance      | ± Tolerance on the expected value.                                                                          |
| Timeout        | Timeout in seconds. Script will stop if the wait statement times out waiting for the comparison to be true. |
| Polling Rate   | How often the comparison is evaluated in seconds. Defaults to 0.25 if not specified.                        |

Examples:

```ruby
wait_check_tolerance("INST HEALTH_STATUS COLLECTS", 10.0, 5.0, 10)
```

### wait_check_tolerance_raw

Deprecated: Use wait_check_tolerance with type: :RAW

Examples:

```ruby
wait_check_tolerance("INST HEALTH_STATUS COLLECTS", 10.0, 5.0, 10, type: :RAW)
```

### wait_check_expression

Pauses the script until an expression is evaluated to be true or a timeout occurs. If a timeout occurs the script will stop. This method can be used to perform more complicated comparisons than using wait as shown in the example. Also see the syntax notes for [check_expression](#checkexpression).

Syntax:

```ruby
wait_check_expression("<Expression>", <Timeout>, <Polling Rate (optional)>)
```

| Parameter    | Description                                                                                                 |
| ------------ | ----------------------------------------------------------------------------------------------------------- |
| Expression   | A ruby expression to evaluate.                                                                              |
| Timeout      | Timeout in seconds. Script will stop if the wait statement times out waiting for the comparison to be true. |
| Polling Rate | How often the comparison is evaluated in seconds. Defaults to 0.25 if not specified.                        |

Example:

```ruby
wait_check_expression("tlm('INST HEALTH_STATUS COLLECTS') > 5 and tlm('INST HEALTH_STATUS TEMP1') > 25.0", 10)
```

### wait_check_packet

Pauses the script until a certain number of packets have been received. If a timeout occurs the script will stop.

Syntax:

```ruby
wait_check_packet("<Target>", "<Packet>", <Num Packets>, <Timeout>, <Polling Rate (optional)>)
```

| Parameter    | Description                                                                                               |
| ------------ | --------------------------------------------------------------------------------------------------------- |
| Target       | The target name                                                                                           |
| Packet       | The packet name                                                                                           |
| Num Packets  | The number of packets to receive                                                                          |
| Timeout      | Timeout in seconds. Script will stop if the wait statement times out waiting specified number of packets. |
| Polling Rate | How often the comparison is evaluated in seconds. Defaults to 0.25 if not specified.                      |

Example:

```ruby
wait_check_packet('INST', 'HEALTH_STATUS', 5, 10) # Wait for 5 INST HEALTH_STATUS packets over 10s
```

## Limits

<div class="note unreleased">
  <p>Limits API not fully implemented in COSMOS 5</p>
</div>

These methods deal with handling telemetry limits.

### limits_enabled?

The limits_enabled? method returns true/false depending on whether limits are enabled for a telemetry item.

Syntax:

```ruby
limits_enabled?("<Target Name> <Packet Name> <Item Name>")
```

| Parameter   | Description                                         |
| ----------- | --------------------------------------------------- |
| Target Name | Name of the target of the telemetry item.           |
| Packet Name | Name of the telemetry packet of the telemetry item. |
| Item Name   | Name of the telemetry item.                         |

Example:

```ruby
enabled = limits_enabled?("INST HEALTH_STATUS TEMP1")
```

### enable_limits

Enables limits monitoring for the specified telemetry item.

Syntax:

```ruby
enable_limits("<Target Name> <Packet Name> <Item Name>")
```

| Parameter   | Description                                         |
| ----------- | --------------------------------------------------- |
| Target Name | Name of the target of the telemetry item.           |
| Packet Name | Name of the telemetry packet of the telemetry item. |
| Item Name   | Name of the telemetry item.                         |

Example:

```ruby
enable_limits("INST HEALTH_STATUS TEMP1")
```

### disable_limits

Disables limits monitoring for the specified telemetry item.

Syntax:

```ruby
disable_limits("<Target Name> <Packet Name> <Item Name>")
```

| Parameter   | Description                                         |
| ----------- | --------------------------------------------------- |
| Target Name | Name of the target of the telemetry item.           |
| Packet Name | Name of the telemetry packet of the telemetry item. |
| Item Name   | Name of the telemetry item.                         |

Example:

```ruby
disable_limits("INST HEALTH_STATUS TEMP1")
```

### enable_limits_group

Enables limits monitoring on a set of telemetry items specified in a limits group.

Syntax:

```ruby
enable_limits_group("<Limits Group Name>")
```

| Parameter         | Description               |
| ----------------- | ------------------------- |
| Limits Group Name | Name of the limits group. |

Example:

```ruby
enable_limits_group("SAFE_MODE")
```

### disable_limits_group

Disables limits monitoring on a set of telemetry items specified in a limits group.

Syntax:

```ruby
disable_limits_group("<Limits Group Name>")
```

| Parameter         | Description               |
| ----------------- | ------------------------- |
| Limits Group Name | Name of the limits group. |

Example:

```ruby
disable_limits_group("SAFE_MODE")
```

### get_limits_groups

Returns the list of limits groups in the system.

Syntax / Example:

```ruby
limits_groups = get_limits_groups()
```

### set_limits_set

Sets the current limits set. The default limits set is :DEFAULT.

Syntax:

```ruby
set_limits_set("<Limits Set Name>")
```

| Parameter       | Description             |
| --------------- | ----------------------- |
| Limits Set Name | Name of the limits set. |

Example:

```ruby
set_limits_set("DEFAULT")
```

### get_limits_set

Returns the name of the current limits set. The default limits set is :DEFAULT.

Syntax / Example:

```ruby
limits_set = get_limits_set()
```

### get_limits_sets

Returns the list of limits sets in the system.

Syntax / Example:

```ruby
limits_sets = get_limits_sets()
```

### get_limits

Returns limits settings for a telemetry point.

Syntax:

```ruby
get_limits(<Target Name>, <Packet Name>, <Item Name>, <Limits Set (optional)>)
```

| Parameter   | Description                                                                                                                   |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Target Name | Name of the target of the telemetry item.                                                                                     |
| Packet Name | Name of the telemetry packet of the telemetry item.                                                                           |
| Item Name   | Name of the telemetry item.                                                                                                   |
| Limits Set  | Get the limits for a specific limits set. If not given then it defaults to returning the settings for the current limits set. |

Example:

```ruby
limits_set, persistence_setting, enabled, red_low, yellow_low, yellow_high, red_high, green_low, green_high = get_limits('INST', 'HEALTH_STATUS', 'TEMP1')
```

### set_limits

The set_limits_method sets limits settings for a telemetry point. Note: In most cases it would be better to update your config files or use different limits sets rather than changing limits settings in realtime.

Syntax:

```ruby
set_limits(<Target Name>, <Packet Name>, <Item Name>, <Red Low>, <Yellow Low>, <Yellow High>, <Red High>, <Green Low (optional)>, <Green High (optional)>, <Limits Set (optional)>, <Persistence (optional)>, <Enabled (optional)>)
```

| Parameter   | Description                                                                                                                                                                         |
| ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Target Name | Name of the target of the telemetry item.                                                                                                                                           |
| Packet Name | Name of the telemetry packet of the telemetry item.                                                                                                                                 |
| Item Name   | Name of the telemetry item.                                                                                                                                                         |
| Red Low     | Red Low setting for this limits set. Any value below this value will be make the item red.                                                                                          |
| Yellow Low  | Yellow Low setting for this limits set. Any value below this value but greater than Red Low will be make the item yellow.                                                           |
| Yellow High | Yellow High setting for this limits set. Any value above this value but less than Red High will be make the item yellow.                                                            |
| Red High    | Red High setting for this limits set. Any value above this value will be make the item red.                                                                                         |
| Green Low   | Optional. If given, any value greater than Green Low and less than Green_High will make the item blue indicating a good operational value.                                          |
| Green High  | Optional. If given, any value greater than Green Low and less than Green_High will make the item blue indicating a good operational value.                                          |
| Limits Set  | Optional. Set the limits for a specific limits set. If not given then it defaults to setting limts for the :CUSTOM limits set.                                                      |
| Persistence | Optional. Set the number of samples this item must be out of limits before changing limits state. Defaults to no change. Note: This affects all limits settings across limits sets. |
| Enabled     | Optional. Whether or not limits are enabled for this item. Defaults to true. Note: This affects all limits settings across limits sets.                                             |

Example:

```ruby
set_limits('INST', 'HEALTH_STATUS', 'TEMP1', -10.0, 0.0, 50.0, 60.0, 30.0, 40.0, :TVAC, 1, true)
```

### get_out_of_limits

Returns an array with the target_name, packet_name, item_name, and limits_state of all items that are out of their limits ranges.

Syntax / Example:

```ruby
out_of_limits_items = get_out_of_limits()
```

### get_overall_limits_state

Returns the overall limits state for the COSMOS system. Returns :GREEN, :YELLOW, :RED, or :STALE.

Syntax:

```ruby
get_overall_limits_state(<ignored_items> (optional))
```

| Parameter     | Description                                                                                                                        |
| ------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| Ignored Items | Array of arrays with items to ignore when determining the overall limits state. [['TARGET_NAME', 'PACKET_NAME', 'ITEM_NAME'], ...] |

Example:

```ruby
overall_limits_state = get_overall_limits_state()
overall_limits_state = get_overall_limits_state([['INST', 'HEALTH_STATUS', 'TEMP1']])
```

### get_stale

Returns a list of stale packets. The return value is an array of arrays where each subarray contains the target name and packet name for a stale packet.

Syntax:

```ruby
get_stale(with_limits_only: false, target_name: nil, staleness_sec: 30)
```

| Parameter         | Description                                                                                                                        |
| ----------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| with_limits_only: | If true, return only the packets that have limits items and thus affect the overall limits state of the system. Defaults to false. |
| target_name:      | If specified, return only the packets associated with the given target. Defaults to nil.                                           |
| staleness_sec:    | Return packets that haven't been received since X seconds ago. Defaults to 30.                                                     |

Example:

```ruby
stale_packets = get_stale()
stale_packets.each do |target, packet|
  puts "Stale packet: #{target} #{packet}"
end
inst_stale_packets = get_stale(target_name: "INST")
```

### get_limits_events

Returns limits events based on an offset returned from the last time it was called.

Syntax:

```ruby
get_limits_event(offset, count: 100)
```

| Parameter | Description                                                                                   |
| --------- | --------------------------------------------------------------------------------------------- |
| offset    | Offset returned by the previous call to get_limits_event. Default is nil for the initial call |
| count:    | Maximum number of limits events to return. Default is 100                                     |

Example:

```ruby
events = get_limits_event()
pp events
#[["1613077715557-0",
#  {"type"=>"LIMITS_CHANGE",
#   "target_name"=>"TGT",
#   "packet_name"=>"PKT",
#   "item_name"=>"ITEM",
#   "old_limits_state"=>"YELLOW_LOW",
#   "new_limits_state"=>"RED_LOW",
#   "time_nsec"=>"1",
#   "message"=>"message"}],
# ["1613077715557-1",
#  {"type"=>"LIMITS_CHANGE",
#   "target_name"=>"TGT",
#   "packet_name"=>"PKT",
#   "item_name"=>"ITEM",
#   "old_limits_state"=>"RED_LOW",
#   "new_limits_state"=>"YELLOW_LOW",
#   "time_nsec"=>"2",
#   "message"=>"message"}]]
# The last offset is the first item ([0]) in the last event ([-1])
events = get_limits_event(events[-1][0])
pp events
#[["1613077715657-0",
#  {"type"=>"LIMITS_CHANGE",
#   ...
```

## Targets

Methods for getting knowledge about targets.

### get_target_list

Returns a list of the targets in the system in an array.

Syntax / Example:

```ruby
targets = get_target_list()
```

### get_target

Returns a target hash containing all the information about the target.

Syntax:
`get_target("<Target Name>")`

| Parameter   | Description         |
| ----------- | ------------------- |
| Target Name | Name of the target. |

Example:

```ruby
target = get_target("INST")
pp target
#{"name"=>"INST",
# "folder_name"=>"INST",
# "requires"=>[],
# "ignored_parameters"=>
#  ["CCSDSVER",
#   "CCSDSTYPE",
#   "CCSDSSHF",
#   "CCSDSAPID",
#   "CCSDSSEQFLAGS",
#   "CCSDSSEQCNT",
#   "CCSDSLENGTH",
#   "PKTID"],
# "ignored_items"=>
#  ["CCSDSVER",
#   "CCSDSTYPE",
#   "CCSDSSHF",
#   "CCSDSAPID",
#   "CCSDSSEQFLAGS",
#   "CCSDSSEQCNT",
#   "CCSDSLENGTH",
#   "RECEIVED_COUNT",
#   "RECEIVED_TIMESECONDS",
#   "RECEIVED_TIMEFORMATTED"],
# "limits_groups"=>[],
# "cmd_tlm_files"=>
#  [".../targets/INST/cmd_tlm/inst_cmds.txt",
#   ".../targets/INST/cmd_tlm/inst_tlm.txt"],
# "cmd_unique_id_mode"=>false,
# "tlm_unique_id_mode"=>false,
# "id"=>nil,
# "updated_at"=>1613077058266815900,
# "plugin"=>nil}
```

### get_target_interfaces

Returns the interfaces for all targets. The return value is an array of arrays where each subarray contains the target name, and a String of all the interface names.

Syntax / Example:

```ruby
target_ints = get_target_interfaces()
target_ints.each do |target_name, interfaces|
  puts "Target: #{target_name}, Interfaces: #{interfaces}"
end
```

## Interfaces

These methods allow the user to manipulate COSMOS interfaces.

### get_interface (since 5.0.0)

Returns an interface status including the as built interface and its current status (cmd/tlm counters, etc).

Syntax:
`get_interface("<Interface Name>")`

| Parameter      | Description            |
| -------------- | ---------------------- |
| Interface Name | Name of the interface. |

Example:

```ruby
interface = get_interface("INST_INT")
pp interface
#{"name"=>"INST_INT",
# "config_params"=>["interface.rb"],
# "target_names"=>["INST"],
# "connect_on_startup"=>true,
# "auto_reconnect"=>true,
# "reconnect_delay"=>5.0,
# "disable_disconnect"=>false,
# "options"=>[],
# "protocols"=>[],
# "log"=>true,
# "log_raw"=>false,
# "plugin"=>nil,
# "updated_at"=>1613076213535979900,
# "state"=>"CONNECTED",
# "clients"=>0,
# "txsize"=>0,
# "rxsize"=>0,
# "txbytes"=>0,
# "rxbytes"=>0,
# "txcnt"=>0,
# "rxcnt"=>0}
```

### get_interface_names

Returns a list of the interfaces in the system in an array.

Syntax / Example:

```ruby
interface_names = get_interface_names()
```

### connect_interface

Connects to targets associated with a COSMOS interface.

Syntax:

```ruby
connect_interface("<Interface Name>", <Interface Parameters (optional)>)
```

| Parameter            | Description                                                                                                                                                 |
| -------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Interface Name       | Name of the interface.                                                                                                                                      |
| Interface Parameters | Parameters used to initialize the interface. If none are given then the interface will use the parameters that were given in the server configuration file. |

Example:

```ruby
connect_interface("INT1")
connect_interface("INT1", hostname, port)
```

### disconnect_interface

Disconnects from targets associated with a COSMOS interface.

Syntax:

```ruby
disconnect_interface("<Interface Name>")
```

| Parameter      | Description            |
| -------------- | ---------------------- |
| Interface Name | Name of the interface. |

Example:

```ruby
disconnect_interface("INT1")
```

### start_raw_logging_interface

Starts logging of raw data on one or all interfaces. This is for debugging purposes only.

Syntax:

```ruby
start_raw_logging_interface("<Interface Name (optional)>")
```

| Parameter      | Description                                                                                                                                                        |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Interface Name | Name of the Interface to command to start raw data logging. Defaults to 'ALL' which causes all interfaces that support raw data logging to start logging raw data. |

Example:

```ruby
start_raw_logging_interface("int1")
```

### stop_raw_logging_interface

Stops logging of raw data on one or all interfaces. This is for debugging purposes only.

Syntax:

```ruby
stop_raw_logging_interface("<Interface Name (optional)>")
```

| Parameter      | Description                                                                                                                                                      |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Interface Name | Name of the Interface to command to stop raw data logging. Defaults to 'ALL' which causes all interfaces that support raw data logging to stop logging raw data. |

Example:

```ruby
stop_raw_logging_interface("int1")
```

### get_all_interface_info

Returns information about all interfaces. The return value is an array of arrays where each subarray contains the interface name, connection state, number of connected clients, transmit queue size, receive queue size, bytes transmitted, bytes received, command count, and telemetry count.

Syntax / Example:

```ruby
interface_info = get_all_interface_info()
interface_info.each do |interface_name, connection_state, num_clients, tx_q_size, rx_q_size, tx_bytes, rx_bytes, cmd_count, tlm_count|
  puts "Interface: #{interface_name}, Connection state: #{connection_state}, Num connected clients: #{num_clients}"
  puts "Transmit queue size: #{tx_q_size}, Receive queue size: #{rx_q_size}, Bytes transmitted: #{tx_bytes}, Bytes received: #{rx_bytes}"
  puts "Cmd count: #{cmd_count}, Tlm count: #{tlm_count}"
end
```

### map_target_to_interface

Map a target to an interface allowing target commands and telemetry to be processed by that interface.

Syntax:

```ruby
map_target_to_interface("<Target Name>", "<Interface Name>")
```

| Parameter      | Description                                                            |
| -------------- | ---------------------------------------------------------------------- |
| Target Name    | Name of the target                                                     |
| Interface Name | Name of the interface                                                  |
| cmd_only:      | Whether to map target commands only to the interface (default: false)  |
| tlm_only:      | Whether to map target telemetry only to the interface (default: false) |
| unmap_old:     | Whether remove the target from all existing interfaces (default: true) |

Example:

```ruby
map_target_to_interface("INST", "INST_INT", unmap_old: false)
```

### interface_cmd

Send a command directly to an interface. This has no effect in the standard COSMOS interfaces but can be implemented by a custom interface to change behavior.

Syntax:

```ruby
interface_cmd("<Interface Name>", "<Command Name>", "<Command Parameters>")
```

| Parameter          | Description                             |
| ------------------ | --------------------------------------- |
| Interface Name     | Name of the interface                   |
| Command Name       | Name of the command to send             |
| Command Parameters | Any parameters to send with the command |

Example:

```ruby
interface_cmd("INST", "DISABLE_CRC")
```

### interface_protocol_cmd

Send a command directly to an interface protocol. This has no effect in the standard COSMOS protocols but can be implemented by a custom protocol to change behavior.

Syntax:

```ruby
interface_protocol_cmd("<Interface Name>", "<Command Name>", "<Command Parameters>")
```

| Parameter          | Description                                                                                                                |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------- |
| Interface Name     | Name of the interface                                                                                                      |
| Command Name       | Name of the command to send                                                                                                |
| Command Parameters | Any parameters to send with the command                                                                                    |
| read_write:        | Whether command gets send to read or write protocols. Must be one of :READ, :WRITE, or :READ_WRITE. (default: :READ_WRITE) |

Example:

```ruby
interface_protocol_cmd("INST", "DISABLE_CRC")
```

## Routers

These methods allow the user to manipulate COSMOS routers.

### connect_router

Connects a COSMOS router.

Syntax:

```ruby
connect_router("<Router Name>", <Router Parameters (optional)>)
```

| Parameter         | Description                                                                                                                                           |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| Router Name       | Name of the router.                                                                                                                                   |
| Router Parameters | Parameters used to initialize the router. If none are given then the router will use the parameters that were given in the server configuration file. |

Example:

```ruby
connect_ROUTER("INST_ROUTER")
connect_router("INST_ROUTER", 7779, 7779, nil, 10.0, 'PREIDENTIFIED')
```

### disconnect_router

Disconnects a COSMOS router.

Syntax:

```ruby
disconnect_router("<Router Name>")
```

| Parameter   | Description         |
| ----------- | ------------------- |
| Router Name | Name of the router. |

Example:

```ruby
disconnect_router("INT1_ROUTER")
```

### get_router_names

Returns a list of the routers in the system in an array.

Syntax / Example:

```ruby
router_names = get_router_names()
```

### get_router (since 5.0.0)

Returns a router status including the as built router and its current status (cmd/tlm counters, etc).

Syntax:
`get_router("<Router Name>")`

| Parameter   | Description         |
| ----------- | ------------------- |
| Router Name | Name of the router. |

Example:

```ruby
router = get_router("ROUTER_INT")
pp router
#{"name"=>"ROUTER_INT",
# "config_params"=>["router.rb"],
# "target_names"=>["INST"],
# "connect_on_startup"=>true,
# "auto_reconnect"=>true,
# "reconnect_delay"=>5.0,
# "disable_disconnect"=>false,
# "options"=>[],
# "protocols"=>[],
# "log"=>true,
# "log_raw"=>false,
# "plugin"=>nil,
# "updated_at"=>1613076213535979900,
# "state"=>"CONNECTED",
# "clients"=>0,
# "txsize"=>0,
# "rxsize"=>0,
# "txbytes"=>0,
# "rxbytes"=>0,
# "txcnt"=>0,
# "rxcnt"=>0}
```

### get_all_router_info

Returns information about all routers. The return value is an array of arrays where each subarray contains the router name, connection state, number of connected clients, transmit queue size, receive queue size, bytes transmitted, bytes received, packets received, and packets sent.

Syntax / Example:

```ruby
router_info = get_all_router_info()
router_info.each do |router_name, connection_state, num_clients, tx_q_size, rx_q_size, tx_bytes, rx_bytes, pkts_rcvd, pkts_sent|
  puts "Router: #{router_name}, Connection state: #{connection_state}, Num connected clients: #{num_clients}"
  puts "Transmit queue size: #{tx_q_size}, Receive queue size: #{rx_q_size}, Bytes transmitted: #{tx_bytes}, Bytes received: #{rx_bytes}"
  puts "Packets received: #{pkts_rcvd}, Packets sent: #{pkts_sent}"
end
```

### start_raw_logging_router

Starts logging of raw data on one or all routers. This is for debugging purposes only.

Syntax:

```ruby
start_raw_logging_router("<Router Name (optional)>")
```

| Parameter   | Description                                                                                                                                                  |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Router Name | Name of the Router to command to start raw data logging. Defaults to 'ALL' which causes all routers that support raw data logging to start logging raw data. |

Example:

```ruby
start_raw_logging_router("router1")
```

### stop_raw_logging_router

Stops logging of raw data on one or all routers. This is for debugging purposes only.

Syntax:

```ruby
stop_raw_logging_router("<Router Name (optional)>")
```

| Parameter   | Description                                                                                                                                                |
| ----------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Router Name | Name of the Router to command to stop raw data logging. Defaults to 'ALL' which causes all routers that support raw data logging to stop logging raw data. |

Example:

```ruby
stop_raw_logging_router("router1")
```

## Executing Other Procedures

These methods allow the user to bring in files of subroutines and execute other test procedures.

### start

Starts execution of another high level test procedure. No parameters can be given to high level test procedures. If parameters are necessary, then consider using a subroutine.

Syntax:

```ruby
start("<Procedure Filename>")
```

| Parameter          | Description                                                                                                                                                                 |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Procedure Filename | Name of the test procedure file. These files are normally in the procedures folder but may be anywhere in the Ruby search path. Additionally, absolute paths are supported. |

Example:

```ruby
start("test1.rb")
```

### load_utility

Reads in a script file that contains useful subroutines for use in your test procedure. When these subroutines run in ScriptRunner or TestRunner, their lines will be highlighted. If you want to import subroutines but do not want their lines to be highlighted in ScriptRunner or TestRunner, use the standard Ruby 'load' or 'require' statement.

Syntax:

```ruby
load_utility("TARGET/lib/<Utility Filename>")
```

| Parameter        | Description                                                                                                                                                 |
| ---------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Utility Filename | Name of the script file containing subroutines including the .rb extension. You need to include the full target name and path such as TARGET/lib/utility.rb |

Example:

```ruby
load_utility("TARGET/lib/mode_changes.rb")
```

## Opening, Closing & Creating Telemetry Screens

<div class="note unreleased">
  <p>Screen APIs not yet implemented in COSMOS 5</p>
</div>

These methods allow the user to open, close or create unique telemetry screens from within a test procedure.

### display

Opens a telemetry screen at the specified position.

Syntax:

```ruby
display("<Display Name>", <X Position (optional)>, <Y Position (optional)>)
```

| Parameter    | Description                                                                                      |
| ------------ | ------------------------------------------------------------------------------------------------ |
| Display Name | Name of the telemetry screen to display. Screens are normally named by "TARGET_NAME SCREEN_NAME" |
| X Position   | The X coordinate on screen where the top left corner of the telemetry screen will be placed.     |
| Y Position   | The Y coordinate on screen where the top left corner of the telemetry screen will be placed.     |

Example:

```ruby
display("INST ADCS", 100, 200)
```

### clear

Closes an open telemetry screen.

Syntax:

```ruby
clear("<Display Name>")
```

| Parameter    | Description                                                                                    |
| ------------ | ---------------------------------------------------------------------------------------------- |
| Display Name | Name of the telemetry screen to close. Screens are normally named by "TARGET_NAME SCREEN_NAME" |

Example:

```ruby
clear("INST ADCS")
```

### clear_all

Closes all open screens or all screens of a particular target.

Syntax:

```ruby
clear_all("<Target Name>")
```

| Parameter   | Description                                                                                   |
| ----------- | --------------------------------------------------------------------------------------------- |
| Target Name | Close all screens associated with the target. If no target is passed, all screens are closed. |

Example:

```ruby
clear_all("INST") # Clear all INST screens
clear_all() # Clear all screens
```

### get_screen_list

The get_screen_list returns a list of available telemetry screens.

Syntax:

```ruby
get_screen_list("<config_filename>", <force_refresh>)
```

| Parameter       | Description                                                                                                                 |
| --------------- | --------------------------------------------------------------------------------------------------------------------------- |
| Config filename | A telemetry viewer config file to parse. If nil, the default config file will be used. Optional parameter, defaults to nil. |
| Force refresh   | If true the config file will be re-parsed. Optional parameter, defaults to false.                                           |

Example:

```ruby
screen_list = get_screen_list()
```

### get_screen_definition

The get_screen_definition returns the text file contents of a telemetry screen definition.

Syntax:

```ruby
get_screen_definition("<screen_full_name>", "<config_filename>", <force_refresh>)
```

| Parameter        | Description                                                                                                                 |
| ---------------- | --------------------------------------------------------------------------------------------------------------------------- |
| Screen full name | Telemetry screen name.                                                                                                      |
| Config filename  | A telemetry viewer config file to parse. If nil, the default config file will be used. Optional parameter, defaults to nil. |
| Force refresh    | If true the config file will be re-parsed. Optional parameter, defaults to false.                                           |

Example:

```ruby
screen_definition = get_screen_definition("INST HS")
```

### local_screen

The local_screen allows you to create a temporary screen directly from a script. This also has the ability to use local variables from within your script in your screen.

Syntax:

```ruby
local_screen("<title>", "<screen definition>", <x position>, <y position>)
```

| Parameter         | Description                                                                                                                       |
| ----------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Title             | Screen title                                                                                                                      |
| Screen Definition | You can pass the entire screen definition as a Ruby String or define it inline in a block. Optional parameter, defaults to nil.   |
| X Position        | X Position in pixels to display the screen. Note the top left corner of the display is 0, 0. Optional parameter, defaults to nil. |
| Y Position        | Y Position in pixels to display the screen. Note the top left corner of the display is 0, 0. Optional parameter, defaults to nil. |

Example:

```ruby
temp = 0 # This variable is accessed in the screen
screen_def = '
  SCREEN AUTO AUTO 0.1 FIXED
  VERTICAL
    TITLE "Local Variable"
    VERTICALBOX
      LABELVALUE LOCAL LOCAL temp # Note LOCAL LOCAL
    END
  END
'
# Here we pass in the screen definition as a string
screen = local_screen("My Screen", screen_def, 100, 100)
disable_instrumentation do
  5000000.times do
    temp += 1 # Increment temp to update the screen
  end
end
screen.close # Close this local screen

temp = 0
# The screen definition is nil so we define the screen in the block
local_screen("My Screen", nil, 500, 500) do
  ' # Note the quote
  SCREEN AUTO AUTO 0.1 FIXED
  VERTICAL
    TITLE "Local Variable"
    VERTICALBOX
      LABELVALUE LOCAL LOCAL temp # LOCAL LOCAL
    END
  END
  ' # Close quote
end
disable_instrumentation do
  5000000.times do
    temp += 1 # Increment temp to update the screen
  end
end
close_local_screens() # Close all open local screens
```

### close_local_screens

The close_local_screens closes all temporary screens which were opened using local_screen.

Syntax / Example:

```ruby
close_local_screens()
```

## Script Runner Specific Functionality

These methods allow the user to interact with ScriptRunner functions.

### set_line_delay

This method sets the line delay in script runner.

Syntax:

```ruby
set_line_delay(<delay>)
```

| Parameter | Description                                                                                                   |
| --------- | ------------------------------------------------------------------------------------------------------------- |
| delay     | The amount of time script runner will wait between lines when executing a script, in seconds. Should be ≥ 0.0 |

Example:

```ruby
set_line_delay(0.0)
```

### get_line_delay

The method gets the line delay that script runner is currently using.

Syntax / Example:

```ruby
curr_line_delay = get_line_delay()
```

### get_scriptrunner_message_log_filename

Returns the filename of the ScriptRunner message log.

Syntax / Example:

```ruby
filename = get_scriptrunner_message_log_filename()
```

### start_new_scriptrunner_message_log

Starts a new ScriptRunner message log. Note: ScriptRunner will automatically start a new log whenever a script is started. This method is only needed for starting a new log mid-script execution.

Syntax / Example:

```ruby
filename = start_new_scriptrunner_message_log()
```

### disable_instrumentation

Disables instrumentation for a block of code (line highlighting and exception catching). This is especially useful for speeding up loops that are very slow if lines are instrumented.
Consider breaking code like this into a seperate file and using either require/load to read the file for the same effect while still allowing errors to be caught by your script.

**_ WARNING: Use with caution. Disabling instrumentation will cause any error that occurs while disabled to cause your script to completely stop. _**

Syntax / Example:

```ruby
disable_instrumentation do
  1000.times do
    # Don't want this to have to highlight 1000 times
  end
end
```

### set_stdout_max_lines

This method sets the maximum amount of lines of output that a single line in Scriptrunner can generate without being truncated.

Syntax:

```ruby
set_stdout_max_lines(max_lines)
```

| Parameter | Description                                                                      |
| --------- | -------------------------------------------------------------------------------- |
| max_lines | The maximum number of lines that will be written to the ScriptRunner log at once |

Example:

```ruby
set_stdout_max_lines(2000)
```

## Debugging

These methods allow the user to debug scripts with ScriptRunner.

### step_mode

Places ScriptRunner into step mode where Go must be hit to proceed to the next line.

Syntax / Example:

```ruby
step_mode()
```

### run_mode

Places ScriptRunner into run mode where the next line is run automatically.

Syntax / Example:

```ruby
run_mode()
```

### disconnect_script

Puts scripting into disconnect mode. In disconnect mode, commands are not sent to targets, checks are all successful, and waits expire instantly. Requests for telemetry (tlm()) typically return 0. Disconnect mode is useful for dry-running scripts without having connected targets.

Syntax / Example:

```ruby
disconnect_script()
```
