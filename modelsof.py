import csv
import sys

from bs4 import BeautifulSoup
import requests

dataverse = sys.argv[1]
base_url = 'https://dataverse.harvard.edu'
url = '/'.join([base_url, 'dataverse', dataverse])

datasets = []
while True:
    r = requests.get(url)
    print(r.url)

    soup = BeautifulSoup(r.text, 'html.parser')
    for ds in soup.find_all(class_='datasetResult'):
        datasets.append(dict(title=ds.a.span.text, href=ds.a['href']))

    next_page = soup.find('a', text='Next >')
    if next_page['href'].split('=')[-1] == url.split('=')[-1]:
        break

    url = base_url + next_page['href']

with open(dataverse + '.csv', 'w') as csv_f:
    w = csv.DictWriter(csv_f, fieldnames=['title', 'href'])
    w.writeheader()
    w.writerows(datasets)
