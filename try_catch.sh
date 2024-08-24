#!/bin/sh

SCRIPT_DIR=$(pwd)



# ===================================================
# START - COPY FROM THIS PART
# ===================================================


# Append error labels \n
header=''
border="============================================================"
line_separator="\n\n\n${border}\n\n\n"

currDate=$(date)
id=''

error_labels=''
error_summary=''

tc_unique_id() {
    timestamp=$(date '+%Y%m%d%H%M%S')
    # unique=$RANDOM
    unique=$(shuf -i 0-32767 -n 1)
    id="${timestamp}_${unique}"
}

# Function to log latest errors to a file
tc_log_error() {
    error_labels="${error_labels}\n- [$1]: $2"
}

# Function to append latest error log to error collection log
tc_log_error_summary() {
    error_summary="${error_summary}[$1]\n$2\n\n[LOG]:\n$3${line_separator}"
}

tc_header() {
    header="${border}\n$1\n${border}"
}

tc_log_entry() {
    tc_header "SUMMARY OF ERRORS"
    echo "${header}\n${currDate}\n\n${error_labels}" >> "$SCRIPT_DIR/error.log"

    tc_header "DETAILS"
    echo "\n\n\n${header}\n\n\n${error_summary}" >> "$SCRIPT_DIR/error.log"
}

tc_log_collection_entry() {
    echo "$border\nSUMMARY OF ERRORS\n$border[DATE]: ${currDate}\n$error_labels" >> "$SCRIPT_DIR/error.log"
}


try_catch() {
    local command="$1"
    local label="${2:-'NO_LABEL'}" # SET label as optional (param#2)
    local result
    
    # RUN command
    result=$(eval "$command" 2>&1)
    
    # Check if the command failed
    
    if [ $? -ne 0 ]; then
        echo "IN"
        tc_unique_id # generate uniqueId $id
        tc_log_error "$id" "$label"
        # log_error_summary "$id" "$label" "$result"
        tc_log_error_summary "$id" "$label" "$result"
    fi

}

# ===================================================
# END - UNTIL THIS PART
# ===================================================



# USING variables
label="Error: Division by zero" # Optional
command="echo '100 / 0' | bc"

try_catch "$command" "$label"
# try_catch "$command"



# OR DIRECTLY INLINE
try_catch "non_existent_command" "COMMAND NOT FOUND!!!"
# try_catch "non_existent_command"



# CLEAR OLD LOG (single)
if [ -f "$SCRIPT_DIR/error.log" ]; then
    rm "$SCRIPT_DIR/error.log"
fi


# Compose Log file entry
tc_log_entry

# APPEND THIS LOG TO MASTER LOG 
cat "$SCRIPT_DIR/error.log" >> "$SCRIPT_DIR/error_collection.log"