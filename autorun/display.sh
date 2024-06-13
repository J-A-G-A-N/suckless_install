#!/bin/bash

# # Get the list of connected monitors
# connected_monitors=$(xrandr --query | grep ' connected' | awk '{ print $1 }')
#
# # Initialize the position variables
# xpos=0
# ypos=0
#
# # Loop through each connected monitor
# for monitor in $connected_monitors; do
#     # Get the best resolution and refresh rate for the monitor
#     best_mode=$(xrandr --query | grep -A1 "^$monitor connected" | tail -1 | awk '{ print $1 }')
#
#     # Set the monitor to the best mode and arrange them horizontally
#     xrandr --output $monitor --mode $best_mode --pos ${xpos}x${ypos}
#
#     # Update the xpos for the next monitor
#     screen_width=$(echo $best_mode | cut -d'x' -f1)
#     xpos=$((xpos + screen_width))
# done
#
# echo "Monitors have been configured to their best resolutions and arranged horizontally."
#
#
#
#




# #!/bin/bash
#
# # Define a temporary file to store the monitor setup
# MONITOR_SETUP_FILE="/tmp/monitor_setup.txt"
#
# # Get the current monitor setup and save it to the temporary file
# xrandr --query | grep ' connected' > "$MONITOR_SETUP_FILE"
#
# # Get the list of connected monitors
# connected_monitors=$(xrandr --query | grep ' connected' | awk '{ print $1 }')
#
# # Initialize the position variables
# xpos=0
# ypos=0
#
# # Variable to track if a change has occurred
# change_detected=0
#
# # Loop through each connected monitor
# for monitor in $connected_monitors; do
#     # Get the best resolution and refresh rate for the monitor
#     best_mode=$(xrandr --query | grep -A1 "^$monitor connected" | tail -1 | awk '{ print $1 }')
#
#     # Set the monitor to the best mode and arrange them horizontally
#     xrandr --output $monitor --mode $best_mode --pos ${xpos}x${ypos}
#
#     # Update the xpos for the next monitor
#     screen_width=$(echo $best_mode | cut -d'x' -f1)
#     xpos=$((xpos + screen_width))
# done
#
# # Get the new monitor setup
# new_monitor_setup=$(xrandr --query | grep ' connected')
#
# # Compare the new monitor setup with the initial setup
# if ! cmp -s <(echo "$new_monitor_setup") "$MONITOR_SETUP_FILE"; then
#     # If there is a difference, set the change_detected flag
#     change_detected=1
# fi
#
# # Remove the temporary file
# rm "$MONITOR_SETUP_FILE"
#
# # If a change was detected, run feh to set the wallpaper
# if [ $change_detected -eq 1 ]; then
#     feh --bg-scale ~/Pictures/wallpaper/1.png
#     echo "Wallpaper has been set for all monitors."
# else
#     echo "No monitor change detected. Wallpaper not updated."
# fi
#
#
#

#!/bin/bash

# Function to configure monitors and set wallpaper
configure_monitors() {
    # Get the list of connected monitors
    connected_monitors=$(xrandr --query | grep ' connected' | awk '{ print $1 }')

    # Initialize the position variables
    xpos=0
    ypos=0

    # Loop through each connected monitor
    for monitor in $connected_monitors; do
        # Get the best resolution and refresh rate for the monitor
        best_mode=$(xrandr --query | grep -A1 "^$monitor connected" | tail -1 | awk '{ print $1 }')

        # Set the monitor to the best mode and arrange them horizontally
        xrandr --output $monitor --mode $best_mode --pos ${xpos}x${ypos}

        # Update the xpos for the next monitor
        screen_width=$(echo $best_mode | cut -d'x' -f1)
        xpos=$((xpos + screen_width))
    done

    # Set the same wallpaper for all monitors
    feh --bg-scale ~/Pictures/wallpaper/1.png
}

# Initial configuration of monitors
configure_monitors

# Monitor for changes every 5 seconds
while true; do
    sleep 5
    # Check for any changes in the connected monitors
    new_connected_monitors=$(xrandr --query | grep ' connected' | awk '{ print $1 }')
    if [ "$new_connected_monitors" != "$connected_monitors" ]; then
        # Reconfigure monitors if a change is detected
        configure_monitors
    fi
done

