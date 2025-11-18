#!/bin/sh
# minute-listener.sh - minimal CPU, high-accuracy minute updates
# Run in background: ./minute-listener.sh &
# Make SIGNAL match your block's signal in CONFIG_H.
SIGNAL=1

while true; do
    # date +%s.%N -> "SECONDS.NANOSECONDS" (N is zero-padded 9 digits)
    now=$(date +%s.%N)

    sec_int=${now%.*}    # integer seconds
    sec_frac=${now#*.}   # nanoseconds string (0..999999999)

    seconds_mod=$((sec_int % 60))

    if [ "$sec_frac" -eq 0 ]; then
        # exact second: sleep a whole number of seconds until the start of the next minute
        int_sleep=$((60 - seconds_mod))
        frac_sleep=0
    else
        # sleep = (59 - seconds_mod) + (1e9 - sec_frac)/1e9
        int_sleep=$((59 - seconds_mod))
        frac_sleep=$((1000000000 - sec_frac))   # nanoseconds remaining in the current second
    fi

    # Format as "INT.FRAC" with 9 fractional digits (sleep accepts fractional seconds)
    sleep_time=$(printf "%d.%09d" "$int_sleep" "$frac_sleep")

    sleep "$sleep_time"
# signal dwmblocks (pkill is fine; matches how your audio listener works)
    pkill -RTMIN+"$SIGNAL" dwmblocks
done

