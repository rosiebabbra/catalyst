import os, requests
import openai
import firebase_admin

from bs4 import BeautifulSoup
from dotenv import load_dotenv
from firebase_admin import credentials, firestore
import random


load_dotenv()


WIKI_URL = "https://en.wikipedia.org/w/api.php"


def generate_id(length=8):
  
  return int(''.join(random.choice('0123456789') for _ in range(length)))


def retrieve_hobby_data():

    params = {
        "action": "parse",
        "format": "json",
        "page": "List_of_hobbies",
        "prop": "text|links"
    }

    response = requests.get(WIKI_URL, params=params).json()

    if "parse" in response:
        html_content = response["parse"]["text"]["*"]

    soup = BeautifulSoup(html_content, "html.parser")

    data = {}

    content = soup.select('.div-col a:not(sup a)')

    for record in content:
        url = record.attrs['href'].replace('/wiki/', '')
        title = record.get_text()
        data[title] = url

    return data 


def retrieve_desc_from_wiki(page):
    """Retrieves hobby descriptions from Wiki by the page title (values in 
    results of `retrieve_hobby_data`). Switched to GPT method for more reliability
    since Wiki's page format is not consistent."""

    params = {
        "action": "parse",
        "format": "json",
        "page": page,
        "prop": "text|links"
    }

    response = requests.get(WIKI_URL, params=params).text
    soup = BeautifulSoup(response, "html.parser")

    first_paragraph = soup.select_one('p')
    if first_paragraph:
        first_paragraph_text = first_paragraph.get_text()
    
    return first_paragraph_text.replace("\\n", "").replace("\\", "")
    

def retrieve_desc_from_gpt(hobby):

    openai.api_key = os.getenv('OPENAI_SECRET_KEY')
    resp = openai.Completion.create(
        model="text-davinci-003",
        prompt=f"Provide a one sentence of {hobby} (the hobby).",
        max_tokens=150
    )

    return resp['choices'][0].text.replace("\n", "")


def write_hobby_and_desc_to_db():
    """Retrieve list of hobbies from Wikipedia, loop each one through the ChatGPT 
    query to get a descriptions and write to the db"""

    cred = credentials.Certificate('../../database/serviceAccountKey.json')
    firebase_admin.initialize_app(cred)  # change the name arg every time it’s run
    db = firestore.client()
    
    hobby_list = retrieve_hobby_data().keys()

    data = []
    
    for i in list(hobby_list):
        
        # Check if the document with the custom ID already exists
        while True:
            interest_id = generate_id()  # You can customize the format of the ID
            existing_docs = db.collection('interests').where('interest_id', '==', interest_id).get()

            if len(existing_docs) == 0:
                data.append({
                    'interest_desc': retrieve_desc_from_gpt(i), 
                    'interest': i,
                    'interest_id': interest_id
                })
                print(f"Document added with custom ID: {interest_id}")
                break  # Exit the while loop as we found a unique ID
            else:
                print(f"Document with custom ID '{interest_id}' already exists. Generating a new ID...")

    for entry in data:
        db.collection('interests').add(entry)

    print('Documents created successfully.')