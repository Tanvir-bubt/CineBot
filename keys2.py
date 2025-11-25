import json
import requests

API_URL='https://openrouter.ai/api/v1/chat/completions'
API_KEY='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'
MODEL='nvidia/nemotron-nano-12b-v2-vl:free'


def test_key():
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {API_KEY}",
    }
    
    systemContext = """
    Your name CineBot that replies in warm and short message.

    Do NOT suggest any movies unless the user specifically requests movie suggestions.

    When the user DOES ask for movie suggestions:
    Respond using ONLY this exact format for each movie:

    - <movieTitle> Movie name here </movieTitle>
    """
    
    userMessage = input("Enter your message: ").strip()
    
    data = {
        "model": MODEL,
        "max_tokens": 200,
        "temperature": 0,
        "top_p": 0.9,
        "frequency_penalty": 0.2,
        "presence_penalty": 0.0,
        "messages": [
            {"role": "system", "content": systemContext},
            {"role": "user", "content": userMessage}
        ],
    }

    print("🔍 Checking your OpenRouter API key...\n")

    response = requests.post(API_URL, headers=headers, data=json.dumps(data))
    print(f"Status Code: {response.status_code}\n")

    try:
        response_json = response.json()  # Parse response as JSON
        print("💬 Full Response:")
        print(json.dumps(response_json, indent=4))  # Pretty-print JSON
    except json.JSONDecodeError:
        print("⚠️ Response is not valid JSON:")
        print(response.text)


if __name__ == "__main__":
    test_key()
