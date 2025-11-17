#!/bin/sh
SIGNAL=1

while true; do
    now=$(date +%s.%N)
    sec_int=${now%.*}
    sec_frac=${now#*.}
    sec_frac="0.$sec_frac"

    # Seconds until the next minute
    sec_until_next=$(awk "BEGIN{print 60 - ($sec_int % 60) - $sec_frac}")

    sleep "$sec_until_next"
    pkill -RTMIN+"$SIGNAL" dwmblocks
done

