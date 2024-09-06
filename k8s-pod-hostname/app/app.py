import os
from flask import Flask, jsonify

app = Flask(__name__)

# Get the hostname of the container
hostname = os.getenv('HOSTNAME')

# Get the pod name
pod_name = os.getenv('POD_NAME')

# Get the pod namespace
pod_namespace = os.getenv('POD_NAMESPACE')

@app.route('/')
def index():
    return jsonify({
        "hostname": hostname,
        "pod_name": pod_name,
        "pod_namespace": pod_namespace
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80)