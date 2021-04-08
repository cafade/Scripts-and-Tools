#!/usr/bin/env python3

"""
Hacky script made to print the height, width and center coords of the selected X window, avoiding the need to 
write a much more elegant but full of regex bash script with awk, grep, etc.
Parameters
----------
window_id : string
    Piped string of a hexadecimal representing the window id for the selected Xorg window, like so:
echo $(xwininfo | grep "Window id:" | cut -d' ' -f4) | <this_script.py>
"""

import sys
import Xlib.display


def get_window(display, arg):
    print(arg)
    wid = int(arg, 16)
    return display.create_resource_object('window', wid)


def get_numeric_value(original_string, keyword):
    count = 0
    value = ""
    original_string = original_string.partition(keyword)[2]
    for ele in original_string:
        if ele == ' ':
            count = count + 1
            if count == 2:
                break
            value = ""
        else:
            value = value + ele
    return value.strip(',')


if __name__ == '__main__':
    Display = Xlib.display.Display()
    window = get_window(Display, sys.stdin.read())  # Read hex from standard output, for example, using this pipe:
    # echo $(xwininfo | grep "Window id:" | cut -d' ' -f4) | <this_script.py>
    geometry_to_string = str(window.get_geometry())
    width = get_numeric_value(geometry_to_string, "width")
    height = get_numeric_value(geometry_to_string, "height")
    print(f"width: {width}\n"
          f"height: {height}\n"
          f"x axis center: {int(width)/2}\n"
          f"y axis center: {int(height)/2}")
