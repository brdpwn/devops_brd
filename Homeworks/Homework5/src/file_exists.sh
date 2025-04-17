#!/bin/bash

read -p "Enter the name of the file to check: " filename

if [ -f "$filename" ]; then
	echo "The file '$filename' exists in the current directory."
else
	echo "The file '$filename' does not exist in the current directory."
fi

