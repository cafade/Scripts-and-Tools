#!/usr/bin/env bash

read -p "focus follows mouse? [yes/no]: " USERINPUT
sed -i -e "/focus_follows_mouse / s/ .*/ $USERINPUT/" ~/.config/i3/config
