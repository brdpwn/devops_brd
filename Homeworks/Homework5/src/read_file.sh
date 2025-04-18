#!/bin/bash

read -p "Enter the filename to read: " filename

if [ -f "$filename" ]; then
  echo "----- File Contents -----"
  cat "$filename"
  echo "-------------------------"
else
  echo "Error: File '$filename' not found or is not a regular file."
fi
