#!/bin/bash

## my own rsync-based snapshot-style backup procedure
## (cc) marcio rps AT gmail.com

# config vars

SRC="learnin@desktop:/home/learnin/Documents/EAN/" #dont forget trailing slash!
SNAP="/home/learnin/Backups"
OPTS="-rltgoi -e ssh --delay-updates --delete --chmod=a-w"
MINCHANGES=20

# run this process with real low priority

ionice -c 3 -p $$
renice +12  -p $$

# sync

rsync $OPTS $SRC $SNAP/latestEan >> $SNAP/rsync.log

# check if enough has changed and if so
# make a hardlinked copy named as the date

COUNT=$( wc -l $SNAP/rsync.log|cut -d" " -f1 )
if [ $COUNT -gt $MINCHANGES ] ; then
        DATETAG=$(date +%Y-%m-%d)
        if [ ! -e $SNAP/$DATETAG ] ; then
                cp -al $SNAP/latestEan $SNAP/$DATETAG
                chmod u+w $SNAP/$DATETAG
                mv $SNAP/rsync.log $SNAP/$DATETAG
               chmod u-w $SNAP/$DATETAG
        fi
fi
