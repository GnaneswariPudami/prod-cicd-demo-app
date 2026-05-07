from flask import Flask
import os
import socket
import time

app = Flask(__name__)

VERSION = os.getenv("APP_VERSION", "unknown")
ENVIRONMENT = os.getenv("ENVIRONMENT", "dev")
HOSTNAME = socket.gethostname()
START_TIME = time.time()

@app.route("/")
def home():
    return {
        "application": "prod-cicd-demo",
        "version": VERSION,
        "environment": ENVIRONMENT,
        "hostname": HOSTNAME
    }

@app.route("/health")
def health():
    return {
        "status": "healthy",
        "uptime": round(time.time() - START_TIME, 2)
    }

@app.route("/ready")
def ready():
    return {
        "status": "ready"
    }

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)