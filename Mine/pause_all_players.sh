#!/usr/bin/env bash

# Pause spotify, mpv, etc. for 3 minutes, then resume playing

notify-send 'Paused all players for 3 minutes'
playerctl --all-players pause
mpc pause
sleep 3m

playerctl --all-players play
mpc play

