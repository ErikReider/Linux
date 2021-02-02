import json
import requests
import argparse

parser = argparse.ArgumentParser(description='Process some integers.')

parser = argparse.ArgumentParser(description='Search for synonyms')
parser.add_argument('strings', metavar='N', type=str, help='The word to search for')

url = "https://tuna.thesaurus.com/relatedWords/{0}?limit=1".format(parser.parse_args().strings)
req = requests.get(url)
data = json.loads(req.text)["data"][0]["synonyms"]

data = list(map(lambda x: x["term"], data))

[print(x) for x in data]
