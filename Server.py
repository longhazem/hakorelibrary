from flask import Flask, request, jsonify
from flask_cors import CORS
import json, os

app = Flask(__name__)
CORS(app)  # Cho phép gọi từ website

TOKEN_FILE = "user_tokens.json"

if os.path.exists(TOKEN_FILE):
    with open(TOKEN_FILE, "r") as f:
        user_tokens = json.load(f)
else:
    user_tokens = {}

@app.route('/verify', methods=['POST'])
def verify_token():
    data = request.get_json()
    token = data.get("token", "")
    for user_id, saved_token in user_tokens.items():
        if token == saved_token:
            return jsonify({"status": "ok", "user_id": user_id})
    return jsonify({"status": "invalid"}), 400

@app.route('/add', methods=['POST'])
def add_token():
    data = request.get_json()
    user_id = str(data.get("user_id"))
    token = str(data.get("token"))
    user_tokens[user_id] = token
    with open(TOKEN_FILE, "w") as f:
        json.dump(user_tokens, f, indent=4)
    return jsonify({"status": "saved"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
