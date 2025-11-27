FROM ubuntu:latest

RUN apt-get update && apt-get install -y imagemagick bash inotify-tools

RUN mkdir -p /app/images /app/output && chown -R ubuntu:ubuntu /app

WORKDIR /app

COPY add_logo.sh /app/add_logo.sh
COPY nalb_logo.png /app/nalb_logo.png

RUN chmod +x /app/add_logo.sh

USER ubuntu

CMD ["./add_logo.sh"]
