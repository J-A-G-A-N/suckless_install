#!/bin/bash

# Continuously monitor volume changes
while true; do
    # Get the current volume percentage
    volume=$(pactl list sinks | grep 'Volume:' | awk '{print $5}' | sed 's/%//')

    # Check if the volume has changed
    if [ "$volume" != "$prev_volume" ]; then
        # Reload slstatus
        pkill -USR1 slstatus
        prev_volume="$volume"
    fi

    # Sleep for a short interval (e.g., 1 second)
    sleep 1
done

