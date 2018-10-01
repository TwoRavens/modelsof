import csv
import os.path
import sys

from bs4 import BeautifulSoup
import requests

base_url = 'https://dataverse.harvard.edu'

def get_datasets(dataverse):
    fname = dataverse + '.csv'
    if os.path.isfile(fname):
        return print(fname + ' already exists')

    url = '/'.join([base_url, 'dataverse', dataverse])
    datasets = []
    while True:
        r = requests.get(url, timeout=10)
        print(r.url)
        soup = BeautifulSoup(r.text, 'html.parser')
        for ds in soup.find_all(class_='datasetResult'):
            datasets.append(dict(title=ds.a.span.text, href=ds.a['href']))

        next_page = soup.find('a', text='Next >')
        if next_page['href'].split('=')[-1] == url.split('=')[-1]:
            break

        url = base_url + next_page['href']

    with open(fname, 'w') as f:
        w = csv.DictWriter(f, ['title', 'href'])
        w.writeheader()
        w.writerows(datasets)

def get_files(dataverse):
    get_datasets(dataverse)
    fname = dataverse + '_files.csv'
    if os.path.isfile(fname):
        return print(fname + ' already exists')

    files = []
    with open(dataverse + '.csv') as f:
        r = csv.DictReader(f)
        for row in r:
            attempts = 0
            while True:
                try:
                    r = requests.get(base_url + row['href'], timeout=10)
                    print(r.url)
                    break
                except:
                    if attempts < 4:
                        attempts += 1
                        continue
                    raise

            soup = BeautifulSoup(r.text, 'html.parser')
            for md in soup.find_all('td', class_='col-file-metadata'):
                files.append(dict(row, filename=md.a.text.strip(), file_href=md.a['href']))

    with open(fname, 'w') as f:
        w = csv.DictWriter(f, ['title', 'href', 'filename', 'file_href'])
        w.writeheader()
        w.writerows(files)

#url = base_url + '/api/access/datafile/:persistentId?'
cmd = {'get_datasets': get_datasets, 'get_files': get_files}[sys.argv[1]]
cmd(sys.argv[2])
