#
# ~/.bash_profile
#

if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx xinitrc-dwm -- :0 vt1
fi




