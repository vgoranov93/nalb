#!/bin/bash
#
# NALB Image Resizer - Start
# Double-click this file or run: ./start.sh
#

CONTAINER_NAME="nalb-resizer"
IMAGE_NAME="nalb-resizer"
OUTPUT_DIR="$HOME/Documents/resized-images"
PORT=5000

# Create output folder if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker first."
    read -p "Press Enter to close..."
    exit 1
fi

# Stop and remove any existing container
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Stopping existing container..."
    docker stop "$CONTAINER_NAME" > /dev/null 2>&1
    docker rm "$CONTAINER_NAME" > /dev/null 2>&1
fi

# Build the image if it doesn't exist
if ! docker images --format '{{.Repository}}' | grep -q "^${IMAGE_NAME}$"; then
    echo "Building image for the first time (this may take a minute)..."
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    docker build -t "$IMAGE_NAME" "$SCRIPT_DIR"
fi

# Start the container
echo "Starting NALB Image Resizer..."
docker run -d \
    --name "$CONTAINER_NAME" \
    -p ${PORT}:5000 \
    -v "${OUTPUT_DIR}:/images/destination" \
    "$IMAGE_NAME" > /dev/null

echo ""
echo "==================================="
echo "  NALB Image Resizer is running!"
echo "==================================="
echo ""
echo "  Open in browser: http://localhost:${PORT}"
echo "  Resized images:  ${OUTPUT_DIR}"
echo ""
echo "  To stop: run ./stop.sh or use the Stop button in the UI"
echo ""

# Try to open browser automatically
if command -v xdg-open > /dev/null; then
    xdg-open "http://localhost:${PORT}" 2>/dev/null
elif command -v open > /dev/null; then
    open "http://localhost:${PORT}"
fi
