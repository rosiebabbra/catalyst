import os, requests
import openai

from bs4 import BeautifulSoup
from dotenv import load_dotenv


load_dotenv()


WIKI_URL = "https://en.wikipedia.org/w/api.php"


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