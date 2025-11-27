FROM ubuntu:latest

# Install ImageMagick, Python, and pip
RUN apt-get update && apt-get install -y \
    imagemagick \
    python3 \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /images/source /images/destination /app

# Copy the nalb logo from the add-logo project
COPY nalb_logo.png /app/nalb_logo.png

# Set up Python virtual environment and install Flask
RUN python3 -m venv /app/venv
COPY requirements.txt /app/requirements.txt
RUN /app/venv/bin/pip install -r /app/requirements.txt

# Copy application files
COPY app.py /app/app.py
COPY templates /app/templates

# Change ownership
RUN chown -R ubuntu:ubuntu /images /app

WORKDIR /app

USER ubuntu

EXPOSE 5000

ENTRYPOINT ["/app/venv/bin/python", "app.py"]
