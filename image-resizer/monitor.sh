#!/bin/bash

# Define the source directory
SOURCE_DIR="/images/source"

# Monitor the source directory for new files and run the resize script
inotifywait -m "$SOURCE_DIR" -e create -e moved_to |
while read -r directory events filename; do
  /usr/local/bin/resize_photos.sh
done
