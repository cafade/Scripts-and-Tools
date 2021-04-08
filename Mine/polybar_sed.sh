#!/usr/bin/env bash

# Script which comments and uncomments the monitor settings from a hacky grep flag

NVIDIA_ENABLED=NULL

grep "nvidia true" -q /home/learnin/.config/polybar/config  && NVIDIA_ENABLED=true || NVIDIA_ENABLED=false

if [ "$NVIDIA_ENABLED" == true ]; then
    sed -i "68s/^.//" /home/learnin/.config/polybar/config 
    sed -i "67s/.*/;&/" /home/learnin/.config/polybar/config 
    sed -i -e "/nvidia/s/.*/;nvidia false/" /home/learnin/.config/polybar/config
    NVIDIA_ENABLED=false
else
    sed -i '67s/^.//' /home/learnin/.config/polybar/config 
    sed -i "68s/.*/;&/" /home/learnin/.config/polybar/config 
    sed -i -e "/nvidia/s/.*/;nvidia true/" /home/learnin/.config/polybar/config
    NVIDIA_ENABLED=true
fi
