#!/bin/bash

if [ $# -eq 0 ]; 
then
  echo "Usage: $0 <filename>"
  exit 1
fi

filename="$1"

if [ ! -f "$filename" ]; 
then
  echo "Error: File '$filename' not found."
  exit 1
fi

line_count=$(wc -l < "$filename")
echo "The file '$filename' has $line_count lines."

