#!/bin/bash

# Depends on socat
# I know that the mpv protocol is not supposed to be used "raw", but I couldn't
# find the documentation to learn how to do otherwhise.
# Based on the script found here:
#    https://old.reddit.com/r/commandline/comments/920p5d/bash_script_for_queueing_youtube_links_in_mpv/
# And this gist:
#    https://gist.github.com/dwgill/a66769e0edef69c04d3b

if [[ ! -p $HOME/.mpvinput ]]; then
    mkfifo $HOME/.mpvinput
fi

help() {
    cat << EOF
Example usage: yt <argument>
List of arguments:
play: Resume de player
pause: Pause the player
toggle: Toggle playback.
next: Play the next item in the playlist
prev: Play the previous item in the playlist
vol: Set the player volume to the desired level - Ex: vol 100
seek+: Seek in the current track forward (predetermined amount) # TODO
seek-: Seek in the current track backward (predetermined amount) # TODO
add: Add the space separated list of links to the queue
quit: Exit current mpv socket
help: Print this help menu
EOF
}

if [ $# -eq 0 ]
  then
      help
fi

while [[ ${1} ]]; do
    case "${1}" in
        -h | help)
            help
            exit 0
            ;;
        pause)
            echo '{ "command": ["set_property", "pause", true] }' | socat - /tmp/mpvsocket >/dev/null 2>&1
            exit 0
            ;;
        play)
            echo '{ "command": ["set_property", "pause", false] }' | socat - /tmp/mpvsocket >/dev/null 2>&1
            exit 0
            ;;
        toggle)
            echo '{"command": ["cycle", "pause"]}' | socat - /tmp/mpvsocket >/dev/null 2>&1
            exit 0
            ;;
        next)
            echo '{"command": ["playlist_next"]}' | socat - /tmp/mpvsocket >/dev/null 2>&1
            exit 0
            ;;
        prev)
            echo '{"command": ["playlist_prev"]}' | socat - /tmp/mpvsocket >/dev/null 2>&1
            exit 0
            ;;
        vol)
            shift &&
                printf '%s\n' "{ \"command\": [\"set_property\", \"volume\", $1 ] }" | \
                socat - /tmp/mpvsocket
            exit 0
            ;;
        add)
            shift &&
            for video in "$@"; do
                echo $video
                printf "%s\n" "loadfile \"$video\" append-play" > $HOME/.mpvinput
            done;
            exit 0
            ;;
        quit)
            echo '{"command": ["quit"]}' | socat - /tmp/mpvsocket >/dev/null 2>&1
            exit 0
            ;;
        *)
            if pgrep -f MPV-Q > /dev/null
            then
                printf "%s\n" "loadfile \"$1\" append-play" > $HOME/.mpvinput
            else
                mpv --no-terminal --no-video --x11-name=MPV-Q --input-ipc-server=/tmp/mpvsocket --input-file=$HOME/.mpvinput "$1" &
            fi
            exit 0
    esac
done
