#!/bin/bash

# Directory containing the images
IMAGE_DIR="/app/images"

# Logo file
LOGO_FILE="/app/nalb_logo.png"

# Output directory
OUTPUT_DIR="/app/output"

# Function to process an image
process_image() {
  local image=$1
  local base_name=$(basename "$image")
  local output_file="$OUTPUT_DIR/$base_name"
  
  # Resize the logo to a smaller size (e.g., 100x100 pixels)
  convert "$LOGO_FILE" -resize 20x20\> resized_logo.png
  
  # Add watermark to the image
  convert "$image" resized_logo.png -gravity southeast -geometry +10+10 -composite "$output_file"
  
  # Remove the resized logo to clean up
  rm resized_logo.png
}

# Initial processing of existing images in the directory
for image in "$IMAGE_DIR"/*; do
  if [ -f "$image" ]; then
    process_image "$image"
  fi
done

# Monitor the directory for new images and process them automatically
inotifywait -m -e close_write --format '%w%f' "$IMAGE_DIR" | while read -r new_image; do
  process_image "$new_image"
done