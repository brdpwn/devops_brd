#!/bin/bash
#
# Exercise 4: Looping
# Create a script that uses a loop to print numbers from 1 to 10.
#
number=1
while [ $number -le 10 ]
do
	echo "$number"
	((number++))
done
