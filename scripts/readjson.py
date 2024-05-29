import json


with open('config.json') as json_data:
    d = json.load(json_data)
    print('Container created for company:', d.get('Company Name'))
