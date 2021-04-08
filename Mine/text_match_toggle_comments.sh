
#!/usr/bin/env bash

# grep and sed script to toggle specific comments in a file by matching the
# first string of the line

COMMENTS_SYMBOL=#
TARGET_FILE_PATH=sample-file-path
TARGET_STRING=sample-string
TARGET_STRING_COMMENTED="$COMMENTS_SYMBOL$TARGET_STRING"

# Search for the commented string in the target file
grep $TARGET_STRING_COMMENTED -q $TARGET_FILE_PATH &&
    # If it's found commented, uncomment it
    sed -e "/$TARGET_STRING/ s/$COMMENTS_SYMBOL*//" -i $TARGET_FILE_PATH ||
        # Else, comment it
    sed -e "/$TARGET_STRING/ s/^$COMMENTS_SYMBOL*/$COMMENTS_SYMBOL/" -i $TARGET_FILE_PATH
