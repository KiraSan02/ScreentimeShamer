from flask import Flask, request, jsonify
from flask_cors import CORS
import openai
import os
from dotenv import load_dotenv

app = Flask(__name__)
CORS(app)

# Load environment variables from .env file
load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")

@app.route('/generate_message', methods=['POST'])
def generate_message():
    try:
        response = openai.Completion.create(
            engine="text-davinci-003",
            prompt="Generate a sassy and shaming message for someone who has exceeded their screen time limit.",
            max_tokens=60
        )
        message = response.choices[0].text.strip()
        return jsonify({'message': message})
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(debug=True)
