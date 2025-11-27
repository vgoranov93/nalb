#!/bin/bash
#
# NALB Image Resizer - Stop
# Double-click this file or run: ./stop.sh
#

CONTAINER_NAME="nalb-resizer"

if docker ps --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
    echo "Stopping NALB Image Resizer..."
    docker stop "$CONTAINER_NAME" > /dev/null 2>&1
    docker rm "$CONTAINER_NAME" > /dev/null 2>&1
    echo "Stopped."
else
    echo "NALB Image Resizer is not running."
fi
