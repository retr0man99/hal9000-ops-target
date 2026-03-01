from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def index():
    return jsonify({"status": "ok", "service": "hal9000-ops-target", "version": "1.0.0"})


@app.route("/health")
def health():
    return jsonify({"healthy": True}), 200


@app.route("/ping")
def ping():
    return jsonify({"pong": True}), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
