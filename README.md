# try_catch 

`try_catch` is a *proof-of-concept* script for applying an error-catching procedure that summarizes and consolidates error message. The main idea is to catch the errors and display it into a more readable format. It also generates a log entry for each run. 


## Table of Contents

- [Files](#files)
- [Logging](#logging)
- [How-To](#how-to)



### Files

- `try_catch.sh` 

Contains code for applying an error catching procedure to enable "*fancy*" logging.

- `sample-error_collectio.log` and `sample-error.log` contains sample error output/logs.


### Logging

Files 
    - `error.log`
        - Contains the logs for the recently executed script -- only if there were errors.
        - Old log is replaced after each execution.
        - If there were errors, the `error.log` is deleted / would not be created.
    - `error_collection.log`
        - Contains a collection of logs from different executions / runs.
        - Contents of `error.log` is appended at the bottom of this file after each executions / run.

Both files are auto-generated at the end of the script execution -- if there were errors. 


### Format 

- Contains a summary of errors (like a table of contents)
    - Contains a unique identifier (timestamp + uniqueID)
    - Custom error label (*optional*)

- Contains a Details section containing actual error logs
    - Each log is preceeded by its unique ientifier and the custom error label
    - Displays the whole log of errors for the particular command


```bash
============================================================
SUMMARY OF ERRORS
============================================================
Sat Aug 24 13:03:55 CST 2024


- [20240824130355_5257]: Error: Division by zero
- [20240824130355_551]: 'NO_LABEL'



============================================================
DETAILS
============================================================


[20240824130355_5257]
Error: Division by zero

[LOG]:
test.sh: 1: eval: bc: not found


============================================================


[20240824130355_551]
'NO_LABEL'

[LOG]:
test.sh: 1: eval: non_existent_command: not found


============================================================

```



### How-To-Use

- Copy over the lines in between `START` AND `END` from `try_catch.sh` into your script.
- Add try_catch before each command in your script


```bash

# =======================
# Use variables
# =======================

label="Error: Division by zero"
command="echo '100 / 0' | bc"

# With custom error label
try_catch "$command" "$label"
# Without
try_catch "$command" 



# =======================
# OR DO IT INLINE
# =======================

# With custom error label
try_catch "echo '100 / 0' | bc" "Error: Division by zero"
# without 
try_catch "echo '100 / 0' | bc" 


```