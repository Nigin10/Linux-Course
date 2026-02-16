#!/bin/bash

if [ $# -ne 1 ]; then
  echo "error"
  exit 1
  fi
output="output1.txt"
>"$output"
input="$1"
if [ ! -f "$input" ]; then
   echo "no input"
   exit 1
   fi


grep -E '"frame.time"|"wlan.fc.type"|"wlan.fc.subtype"' "$input">"$output"
   
