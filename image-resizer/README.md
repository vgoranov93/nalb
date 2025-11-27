# NALB Image Resizer

A Docker-based image resizing tool with a web UI. Upload images through your browser, resize them, optionally add the NALB watermark, and download the results.

## Features

- Web UI with drag-and-drop upload
- Resize multiple images at once
- Configurable width and height
- Optional NALB logo watermark
- Download resized images individually or as a ZIP
- Stop server from the UI
- Works on Linux, macOS, and Windows

## Quick Start

### 1. Install Prerequisites

You need **Docker** and **Git** installed on your machine.

**Linux / macOS:**

Install Docker from [docker.com](https://www.docker.com/products/docker-desktop) and Git from [git-scm.com](https://git-scm.com/).

**Windows 10/11:**

Run the provided PowerShell installer as Administrator:

```powershell
# Right-click install.ps1 -> Run with PowerShell (as Admin)
# Or open PowerShell as Administrator and run:
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install.ps1
```

This will install Docker Desktop, Git, and enable WSL/Virtual Machine Platform automatically.

### 2. Start the Application

**Linux / macOS:**

```bash
./start.sh
```

**Windows:**

Double-click `start.bat`

The script will:
- Build the Docker image (first time only)
- Start the container
- Open your browser to `http://localhost:5000`

Resized images are saved to:
- Linux/macOS: `~/Documents/resized-images`
- Windows: `Documents\resized-images`

### 3. Use the Web UI

1. Open `http://localhost:5000` in your browser
2. Drag and drop images (or click to select files)
3. Set the desired **Width** and **Height** (default: 200x300)
4. Check **Add NALB watermark** if you want the logo on your images
5. Click **Resize Images**
6. Download files individually or click **Download All (ZIP)**

### 4. Stop the Application

Three ways to stop:

- Click the **Stop Server** button in the web UI
- Run `./stop.sh` (Linux/macOS) or double-click `stop.bat` (Windows)
- Run `docker stop nalb-resizer`

## Manual Docker Commands

If you prefer to run Docker commands directly instead of using the scripts:

**Build the image:**

```bash
docker build -t nalb-resizer .
```

**Run the container:**

```bash
docker run -d --name nalb-resizer -p 5000:5000 -v /path/to/output:/images/destination nalb-resizer
```

**Example with a specific output folder:**

```bash
# Linux
docker run -d --name nalb-resizer -p 5000:5000 -v ~/Documents/test:/images/destination nalb-resizer

# Windows (PowerShell)
docker run -d --name nalb-resizer -p 5000:5000 -v ${env:USERPROFILE}\Documents\test:/images/destination nalb-resizer
```

**Stop and remove:**

```bash
docker stop nalb-resizer
docker rm nalb-resizer
```

**View logs:**

```bash
docker logs nalb-resizer
```

**Rebuild after changes:**

```bash
docker stop nalb-resizer && docker rm nalb-resizer
docker build -t nalb-resizer .
```

## Project Structure

```
image-resizer/
├── app.py              # Flask web server
├── templates/
│   └── index.html      # Web UI
├── nalb_logo.png       # NALB logo (header + watermark)
├── requirements.txt    # Python dependencies (Flask)
├── Dockerfile          # Single container definition
├── install.ps1         # Windows prerequisite installer
├── start.sh            # Linux/macOS start script
├── start.bat           # Windows start script
├── stop.sh             # Linux/macOS stop script
├── stop.bat            # Windows stop script
├── resize_photos.sh    # Legacy CLI resize script
├── monitor.sh          # Legacy CLI file monitor
└── README.md
```

## How It Works

The Docker container runs a Flask web server on port 5000. When you upload images through the UI:

1. Images are saved to `/images/source` inside the container
2. ImageMagick resizes them to your specified dimensions
3. Optionally, the NALB logo is composited as a watermark
4. Resized images are saved to `/images/destination`
5. The destination folder is mounted to your host machine, so files appear directly on your computer

## Troubleshooting

| Problem | Solution |
|---|---|
| "Docker is not running" | Start Docker Desktop and wait for it to fully load |
| Port 5000 already in use | Change the port: `-p 8080:5000` then open `http://localhost:8080` |
| Permission denied on start.sh | Run `chmod +x start.sh stop.sh` |
| Images not appearing in output folder | Make sure the volume mount path exists on your host |
| Windows: PowerShell script won't run | Run `Set-ExecutionPolicy Bypass -Scope Process -Force` first |
