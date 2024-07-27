#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/keysym.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

unsigned int old_volume;

unsigned int get_volume() {
    // Funtion to retrive the colume level
    // reutrns the volume level

    // Command to retrieve volume level
    const char *command = "pactl list sinks | grep '^[[:space:]]Volume:' | head -n 1 | awk '{print $5}'";

    // Open a pipe to the command
    FILE *fp = popen(command, "r");
    if (fp == NULL) {
        perror("popen");
        return 1;
}

    // Read the output
    unsigned int volume;
    if (fscanf(fp, "%d", &volume) != 1) {
        fprintf(stderr, "Failed to read volume level\n");
        pclose(fp);
        return 1;
    }

    // Close the pipe
    pclose(fp);

    return volume;
}


void update_slstatus(){
    system("pkill -USR1 slstatus");
}

// Function to handle key events
void handle_key_event(Display *display, XKeyEvent *event) {
    if (event->type == KeyPress) {
        KeySym key = XLookupKeysym(event, 0);
        if (key == XK_F3 && get_volume() != 100) {
                // Increases the volume
            int status = system("pactl set-sink-volume @DEFAULT_SINK@ +5%");
            if (status == 0 ) {
                update_slstatus();
            }else{
                perror("system");                
            }
            XFlush(display);
        }

        else if (key == XK_F2 && get_volume() != 0) {
            // Decreases the volume
            int status = system("pactl set-sink-volume @DEFAULT_SINK@ -5%");
            if (status == 0 ) {
                update_slstatus();
            }else{
                perror("system");                
            }
            XFlush(display);
        
        }else if (key == XK_F1 && get_volume() !=0) {
            // Mutes 
            old_volume = get_volume() ;
            int status = system("pactl set-sink-volume @DEFAULT_SINK@ 0%");
             if (status == 0 ) {
                update_slstatus();
            }else{
                perror("system");                
            }
            XFlush(display);




        }else if (key == XK_F1 && get_volume() == 0) {
            // Unmutes
             char command[100];
             snprintf(command, sizeof(command),"pactl set-sink-volume @DEFAULT_SINK@ %d%%",old_volume);
             int status = system(command) ; 
             if (status == 0 ) {
                update_slstatus();
            }else{
                perror("system");                
            }
            XFlush(display);
            }
    }
}


int main() {
    Display *display;
    Window root;
    XEvent event;
    unsigned int keycode3, keycode2, keycode1;
    display = XOpenDisplay(NULL);
    if (display == NULL) {
        fprintf(stderr, "Unable to open X display\n");
        exit(1);
    }

    root = DefaultRootWindow(display);

    // Get the keycode for F1,F2 and F3
    keycode2 = XKeysymToKeycode(display, XK_F2);
    keycode3 = XKeysymToKeycode(display, XK_F3);
    keycode1 = XKeysymToKeycode(display, XK_F1);

    // Grab the F1,F2 and F3 key so that no other applications can capture it
    XGrabKey(display, keycode1, AnyModifier, root, True, GrabModeAsync, GrabModeAsync);
    XGrabKey(display, keycode2, AnyModifier, root, True, GrabModeAsync, GrabModeAsync);    
    XGrabKey(display, keycode3, AnyModifier, root, True, GrabModeAsync, GrabModeAsync);

    // Select the kind of events 
    XSelectInput(display, root, KeyPressMask);

    while (1) {
        XNextEvent(display, &event);

        if (event.type == KeyPress) {
            handle_key_event(display, &event.xkey);
        }
    }

    XCloseDisplay(display);
    return 0;
}
