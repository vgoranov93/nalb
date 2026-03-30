import os
import io
import signal
import zipfile
from flask import Flask, render_template, request, send_from_directory, send_file, jsonify
import subprocess

app = Flask(__name__)

SOURCE_DIR = "/images/source"
DEST_DIR = "/images/destination"
LOGO_PATH = "/app/nalb_logo.png"

os.makedirs(SOURCE_DIR, exist_ok=True)
os.makedirs(DEST_DIR, exist_ok=True)


@app.route("/")
def index():
    resized = sorted(os.listdir(DEST_DIR)) if os.path.isdir(DEST_DIR) else []
    return render_template("index.html", resized_files=resized)


@app.route("/upload", methods=["POST"])
def upload():
    width = request.form.get("width", "200")
    height = request.form.get("height", "300")
    add_logo = request.form.get("add_logo") == "on"
    files = request.files.getlist("images")

    if not files or all(f.filename == "" for f in files):
        return jsonify({"error": "No files selected"}), 400

    processed = []
    for f in files:
        if f.filename == "":
            continue
        filename = f.filename
        src_path = os.path.join(SOURCE_DIR, filename)
        dest_path = os.path.join(DEST_DIR, filename)
        f.save(src_path)

        # Resize with ImageMagick
        cmd = ["convert", src_path, "-resize", f"{width}x{height}", dest_path]
        subprocess.run(cmd, check=True)

        # Optionally add logo watermark
        if add_logo and os.path.isfile(LOGO_PATH):
            subprocess.run([
                "convert", LOGO_PATH, "-resize", "20x20>", "/tmp/resized_logo.png"
            ], check=True)
            subprocess.run([
                "convert", dest_path, "/tmp/resized_logo.png",
                "-gravity", "southeast", "-geometry", "+10+10",
                "-composite", dest_path
            ], check=True)

        processed.append(filename)

    return jsonify({"processed": processed})


@app.route("/resized/<filename>")
def serve_resized(filename):
    return send_from_directory(DEST_DIR, filename)


@app.route("/download-all")
def download_all():
    if not os.path.isdir(DEST_DIR) or not os.listdir(DEST_DIR):
        return "No files to download", 404

    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_DEFLATED) as zf:
        for name in os.listdir(DEST_DIR):
            zf.write(os.path.join(DEST_DIR, name), name)
    buf.seek(0)
    return send_file(buf, download_name="resized_images.zip", as_attachment=True)


@app.route("/clear", methods=["POST"])
def clear():
    for d in [SOURCE_DIR, DEST_DIR]:
        for name in os.listdir(d):
            path = os.path.join(d, name)
            if os.path.isfile(path):
                os.remove(path)
    return jsonify({"status": "cleared"})


@app.route("/logo")
def logo():
    if os.path.isfile(LOGO_PATH):
        return send_file(LOGO_PATH)
    return "", 404


@app.route("/shutdown", methods=["POST"])
def shutdown():
    def stop():
        os._exit(0)
    import threading
    threading.Timer(1, stop).start()
    return jsonify({"status": "shutting down"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
