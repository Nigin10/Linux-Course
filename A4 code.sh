#!/bin/bash

INPUT_FILE="$1"
OUTPUT_FILE="output.txt"

# Check input file
if [ ! -f "$INPUT_FILE" ]; then
    echo "Input file not found"
    exit 1
fi

# Clear output file
> "$OUTPUT_FILE"

# Variables to store values
frame_time=""
fc_type=""
fc_subtype=""

# Read file line by line
while IFS= read -r line; do

    # Extract frame.time
    if [[ "$line" == *"frame.time"* ]]; then
        frame_time="${line#*: }"
    fi

    # Extract wlan.fc.type
    if [[ "$line" == *"wlan.fc.type"* ]]; then
        fc_type="${line#*: }"
    fi

    # Extract wlan.fc.subtype
    if [[ "$line" == *"wlan.fc.subtype"* ]]; then
        fc_subtype="${line#*: }"
    fi

    # When all three values are captured, write to output
    if [[ -n "$frame_time" && -n "$fc_type" && -n "$fc_subtype" ]]; then
        {
            echo "\"frame.time\": \"$frame_time\","
            echo "\"wlan.fc.type\": \"$fc_type\","
            echo "\"wlan.fc.subtype\": \"$fc_subtype\""
        } >> "$OUTPUT_FILE"

        # Reset variables for next block
        frame_time=""
        fc_type=""
        fc_subtype=""
    fi

done < "$INPUT_FILE"

