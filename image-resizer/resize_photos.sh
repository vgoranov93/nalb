#!/bin/bash

# Define the source and destination directories
SOURCE_DIR="/images/source"
DEST_DIR="/images/destination"
LOG_FILE="/images/resize_log.txt"

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Log the start of the script
echo "Starting the resize script..." >> "$LOG_FILE"

# Loop through all files in the source directory
for file in "$SOURCE_DIR"/*; do
  if [[ -f $file ]]; then
    # Get the filename without the path
    filename=$(basename "$file")
    
    # Log the file being processed
    echo "Processing file: $filename" >> "$LOG_FILE"
    
    # Resize the image and save it to the destination directory
    convert "$file" -resize 200x300 "$DEST_DIR/$filename"
    
    # Set the desired permissions for the resized file
    chmod 644 "$DEST_DIR/$filename"
    
    # Log the completion of the file processing
    echo "Resized and saved: $filename" >> "$LOG_FILE"
  else
    # Log if the file is not found or is not a regular file
    echo "Skipping non-regular file: $file" >> "$LOG_FILE"
  fi
done

# Log the completion of the script
echo "All photos have been resized and saved to $DEST_DIR" >> "$LOG_FILE"
