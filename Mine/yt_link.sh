#!/usr/bin/env bash

# Script which pairs with yt.sh, both scripts should be in your path.
# input the name of the video and search for the best match with the
# youtube-dl search function, pass the url to yt.sh

INPUT_TEXT="$*"
YTLINK="https://www.youtube.com/watch?v="
YTLINK="$YTLINK$(youtube-dl "ytsearch:$INPUT_TEXT" --get-id)"
DIR="$(cd "$(dirname "$0")" && pwd)"
$DIR/yt $YTLINK
