#!/bin/bash

#Exercise 5: File Operations
#Write a script that copies a file from one location to another. Both locations should be passed as arguments


if [ "$#" -ne 2 ]; then
  echo "Usage: $0 source_file destination_path"
  exit 1
fi

source_file="$1"
destination_path="$2"

if [ ! -f "$source_file" ]; then
  echo "Error: Source file '$source_file' does not exist."
  exit 1
fi

cp "$source_file" "$destination_path"

if [ $? -eq 0 ]; then
  echo "File copied from '$source_file' to '$destination_path'."
else
  echo "Error: Failed to copy the file."
fi

