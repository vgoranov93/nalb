nalb-image-resizer
Overview

nalb-image-resizer is a Docker-based tool for processing images and monitoring directories.
This project includes:

resize_photos.sh – script for resizing photos

monitor.sh – script for monitoring a folder for changes

Dockerfile – defines the environment for running the scripts inside Docker

This README explains how to build the Docker image, run the container, and mount host folders so your scripts can access real files on your machine.

1. Build the Docker Image

Make sure your terminal is inside the directory containing the Dockerfile, then run:

docker build -t nalb-image-resizer .


This will create an image named nalb-image-resizer.

2. Running the Container (basic)

You can run the container with:

docker run --name nalb-image-resizer-container nalb-image-resizer


But this won’t give your scripts access to files on your computer.
To do real work, you must mount folders.

3. Mounting Host Folders

To mount a folder from your machine into the container, use:

-v /path/on/host:/path/in/container

Example

If you want to work with:

Host folder: /home/user/photos

Container folder: /app/photos

Run:

docker run \
  --name nalb-image-resizer-container \
  -v /home/user/photos:/app/photos \
  nalb-image-resizer


Now the container can read and write files inside /app/photos, which maps directly to your local folder.

4. Running Scripts Inside the Container
Option A – Script runs automatically

If your Dockerfile uses CMD or ENTRYPOINT, the script will run automatically when the container starts.

Option B – Run scripts manually

Launch an interactive session:

docker run -it \
  --name nalb-image-resizer-container \
  -v /home/user/photos:/app/photos \
  nalb-image-resizer /bin/bash


Then inside the container:

./resize_photos.sh
./monitor.sh

5. Mounting Multiple Folders

You can mount more than one folder:

docker run \
  --name nalb-image-resizer-container \
  -v /host/photos:/app/photos \
  -v /host/output:/app/output \
  -v /host/config:/app/config \
  nalb-image-resizer


Each -v mounts one folder.

6. Managing the Container
Stop the container:
docker stop nalb-image-resizer-container

Stop all containers:

docker rm -f $(docker ps -aq)

Remove the container:
docker rm nalb-image-resizer-container

Rebuild the image after changing files:
docker build -t nalb-image-resizer:v1.0 .

Run again with mounted folders:
docker run \
  -v /host/path:/container/path \
  nalb-image-resizer

7. Tips & Best Practices

Always use absolute paths on the host (/home/user/...).

Rebuild the Docker image when you modify scripts or dependencies.

View logs with:

docker logs nalb-image-resizer-container


Use docker exec -it nalb-image-resizer-container bash to enter a running container.

8. Optional: Suggested Folder Structure
project/
│
├── Dockerfile
├── resize_photos.sh
├── monitor.sh
└── README.md