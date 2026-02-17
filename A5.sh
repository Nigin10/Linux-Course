#!/bin/bash



ERROR_LOG="errors.log"

# Clear previous errors
> "$ERROR_LOG"


# Help Menu (Here Document)

show_help() {
cat << EOF
Usage: $0 [OPTIONS]

Options:
  -d <directory>   Directory to search recursively
  -k <keyword>     Keyword to search
  -f <file>        File to search directly
  --help           Display this help menu

Examples:
  $0 -d /home/user/docs -k linux
  $0 -f sample.txt -k error

Special Parameters Used:
  Script Name: $0
  Total Arguments: $#
EOF
exit 0
}

# ------------------------------
# Error Handling Function
# ------------------------------
log_error() {
    echo "Error: $1" | tee -a "$ERROR_LOG" >&2
}

# ------------------------------
# Recursive Search Function
# ------------------------------
recursive_search() {
    local dir="$1"
    local keyword="$2"

    for item in "$dir"/*; do
        if [[ -f "$item" ]]; then
            if grep -q "$keyword" "$item" 2>>"$ERROR_LOG"; then
                echo "Match found in file: $item"
            fi
        elif [[ -d "$item" ]]; then
            recursive_search "$item" "$keyword"
        fi
    done
}

# ------------------------------
# Input Validation 
# ------------------------------
validate_keyword() {
    if [[ ! "$1" =~ ^[a-zA-Z0-9_]+$ ]]; then
        log_error "Invalid keyword. Only alphanumeric and underscore allowed."
        exit 1
    fi
}

validate_directory() {
    if [[ ! -d "$1" ]]; then
        log_error "Directory does not exist: $1"
        exit 1
    fi
}

validate_file() {
    if [[ ! -f "$1" ]]; then
        log_error "File does not exist: $1"
        exit 1
    fi
}

# ------------------------------
# Manual check for --help
# ------------------------------
for arg in "$@"; do
    if [[ "$arg" == "--help" ]]; then
        show_help
    fi
done

# ------------------------------
# getopts Handling
# ------------------------------
while getopts ":d:k:f:" opt; do
    case $opt in
        d) DIRECTORY="$OPTARG" ;;
        k) KEYWORD="$OPTARG" ;;
        f) FILE="$OPTARG" ;;
        \?) log_error "Invalid option: -$OPTARG"
            exit 1 ;;
        :) log_error "Option -$OPTARG requires an argument."
           exit 1 ;;
    esac
done

# ------------------------------
# Argument Count Check ($#)
# ------------------------------
if [[ $# -eq 0 ]]; then
    log_error "No arguments provided. Use --help for usage."
    exit 1
fi

# ------------------------------
# Validate Keyword
# ------------------------------
if [[ -z "$KEYWORD" ]]; then
    log_error "Keyword cannot be empty."
    exit 1
fi

validate_keyword "$KEYWORD"

# ------------------------------
# File Search Using Here String
# ------------------------------
if [[ -n "$FILE" ]]; then
    validate_file "$FILE"
    
    echo "Searching in file: $FILE"
    
    while read line; do
        if grep -q "$KEYWORD" <<< "$line"; then
            echo "Match: $line"
        fi
    done < "$FILE"

    echo "Exit status of last command: $?"
fi

# ------------------------------
# Recursive Directory Search
# ------------------------------
if [[ -n "$DIRECTORY" ]]; then
    validate_directory "$DIRECTORY"
    echo "Searching recursively in directory: $DIRECTORY"
    recursive_search "$DIRECTORY" "$KEYWORD"
    echo "Exit status of recursive search: $?"
fi

echo "Script execution completed successfully."

