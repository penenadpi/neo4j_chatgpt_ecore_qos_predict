API_KEY = "YOUR_KEY"
API_ENDPOINT = "https://api.openai.com/v1/chat/completions"

def prompt_gpt(context, question, model="gpt-4", temperature=0.1):
    headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {API_KEY}",
    }

`	messages = [
    	    {"role": "system", "content": f"{context}"},
         {"role": "user", "content": f"{question}"}
     ]

    prompt = {
        "model": model,
        "messages": messages,
        "temperature": temperature,
    }

    response = requests.post(API_ENDPOINT, headers=headers, data=json.dumps(prompt))
 
    return response.json()["choices"][0]["message"]["content"]