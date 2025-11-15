#!/bin/sh

# Extract CPU usage percentage from top
cpuUsage=$(top -bn1 | awk '/Cpu/ {print 100 - $8}')  # subtract idle
cpuUsage=$(printf "%.0f" "$cpuUsage")  # round to integer

icon="󰍛"

printf "%s %s%%\n" "$icon" "$cpuUsage"

