# Use an official Ubuntu base image
FROM ubuntu:latest

# Install ImageMagick, inotify-tools and bash
RUN apt-get update && apt-get install -y imagemagick bash inotify-tools

# Create directories for source and destination
RUN mkdir -p /images/source /images/destination

# Change ownership of the directories to the non-root user
RUN chown -R ubuntu:ubuntu /images

# Copy the resize script into the container
COPY resize_photos.sh /usr/local/bin/resize_photos.sh

# Make the script executable
RUN chmod +x /usr/local/bin/resize_photos.sh

# Copy the monitor script into the container
COPY monitor.sh /usr/local/bin/monitor.sh

# Make the monitor script executable
RUN chmod +x /usr/local/bin/monitor.sh

# Set the working directory
WORKDIR /images

USER ubuntu

# Set the entrypoint to bash for interactive debugging
#ENTRYPOINT ["/bin/bash"]
ENTRYPOINT ["/usr/local/bin/monitor.sh"]
