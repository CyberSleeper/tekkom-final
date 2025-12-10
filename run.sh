#!/bin/bash

# take a filename as argument
FILEPATH=$1
FILEPATH_DIR=$(dirname "$FILEPATH")
FILENAME_WITHOUT_DIR=$(basename "$FILEPATH")
FILENAME_WITHOUT_EXT="${FILENAME_WITHOUT_DIR%.*}"

# check if the file exists
if [ -f "$FILEPATH" ]; then
    java parser < "$FILEPATH" > "$FILEPATH_DIR/$FILENAME_WITHOUT_EXT.obj"
    java Machine "$FILEPATH_DIR/$FILENAME_WITHOUT_EXT.obj"
else
    echo "File '$FILEPATH' does not exist."
fi