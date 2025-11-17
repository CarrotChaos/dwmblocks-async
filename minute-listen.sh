#!/bin/sh
# minute-listener.sh - Background listener to signal dwmblocks on minute changes
# Run this as: minute-listener.sh &

SIGNAL=1  # Match this to your block's update signal in config.h

while true; do
    # Current time in seconds with nanoseconds
    now=$(date +%s.%N)
    
    # Compute seconds until next full minute
    # % 60 gives the seconds part, subtract from 60 to get remaining
    sec_until_next=$(
        echo "60 - ($now % 60)" | bc -l
    )

    # Sleep that exact amount
    sleep "$sec_until_next"

    # Signal dwmblocks
    pkill -RTMIN+"$SIGNAL" dwmblocks
done
