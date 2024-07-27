#include <stdint.h>
#include <stdio.h>
#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/keysym.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#define MAX_MONITORS 10 

uint32_t brightness ; 
    
void get_brightness() {
    FILE *fp;
    char path[1035];
    float BRIGHTNESS[MAX_MONITORS]; // Array to store brightness values for each monitor
    int monitor_count = 0;

    // Open the command for reading
    fp = popen("xrandr --verbose --current | grep -i brightness", "r");
    if (fp == NULL) {
        printf("Failed to run command\n");
        exit(1);
    }

    // Read the output a line at a time
    while (fgets(path, sizeof(path) - 1, fp) != NULL) {
        // Find the brightness value in the line
        char *brightness_str = strstr(path, "Brightness:");
        if (brightness_str != NULL) {
            // Extract and store the brightness value
            sscanf(brightness_str, "Brightness: %f", &BRIGHTNESS[monitor_count]);
            monitor_count++;

            // Break loop if maximum number of monitors reached
            if (monitor_count >= MAX_MONITORS)
                break;
        }
    }

    // Close file pointer
    pclose(fp);

    // Print brightness values for each monitor
    brightness = BRIGHTNESS[0] *100 ; 
}

/* Sets the brightness of the display_brightness according to the value of brightness*/
void set_brightness(){
     float Brightness ; 
     Brightness = brightness / 100.0f ; 
     char command[100];
    snprintf(command, sizeof(command), "xrandr --output eDP-1 --brightness %f", Brightness);
    int status = system(command);
    if(status == -1){
        perror("system");
    }
}

/* Increments the vlaue of the display_brightness by 5 */
void increase_brightness(){
    uint32_t increament = 5 ;
    if ( brightness <100 ){
        brightness += increament ;
        set_brightness();
    }
}

/* Increments the vlaue of the display_brightness by 5 */
void decrease_brightness(){
    uint32_t decreament = 5 ; 
    if( brightness > 20 ){
        brightness -= decreament ; 
        set_brightness();
    }
}
        
void handle_key_event(Display* display, XKeyEvent*event){
    if(event->type == KeyPress){
        KeySym key = XLookupKeysym(event,0);
        if(key == XK_F5){
            decrease_brightness();
        }
        else if(key == XK_F6){
            increase_brightness();
        }
        XFlush(display);
    }
}

int main(){
    get_brightness();
    Display* display;
    Window root;
    XEvent event;
    
    display = XOpenDisplay(NULL);
    if(display == NULL){
        fprintf(stderr, "Unable to open display\n");
        exit(1);
    }
    root = DefaultRootWindow(display);
    unsigned int keycode5, keycode6 ;

    keycode5 = XKeysymToKeycode(display, XK_F5);
    keycode6 = XKeysymToKeycode(display, XK_F6);
    

    XGrabKey(display, keycode5, AnyModifier, root, True, GrabModeAsync, GrabModeAsync);
    XGrabKey(display, keycode6, AnyModifier, root, True, GrabModeAsync, GrabModeAsync);

    XSelectInput(display, root, KeyPressMask);

    while(1){
        XNextEvent(display, &event);

        if(event.type == KeyPress){
            handle_key_event(display, &event.xkey);
        }
    }

    XCloseDisplay(display);
    return 0 ;
}
