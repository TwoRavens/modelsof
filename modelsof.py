import csv
import os
from os.path import dirname, isfile, join, splitext
import sys

from bs4 import BeautifulSoup
import requests

base_url = 'https://dataverse.harvard.edu'

def attempt(url):
    attempts = 0
    while True:
        try:
            r = requests.get(url, timeout=10)
            print(r.url)
            if r.status_code == 403:
                return r
            r.raise_for_status()
            return r
        except:
            if attempts < 3:
                attempts += 1
                continue
            raise

def get_datasets(dataverse):
    file = f'out/{dataverse}/datasets.csv'
    if isfile(file):
        return print(f'{file} already exists')

    url = join(base_url, 'dataverse', dataverse)
    datasets = []
    while True:
        r = attempt(url)
        soup = BeautifulSoup(r.text, 'html.parser')
        for ds in soup.find_all(class_='datasetResult'):
            datasets.append(dict(title=ds.a.span.text, href=ds.a['href'], date=ds.find(class_='text-muted').text))

        next_page = soup.find('a', text='Next >')['href']
        if next_page.split('=')[-1] == url.split('=')[-1]:
            break
        url = base_url + next_page

    os.makedirs('out/' + dataverse, exist_ok=True)
    with open(file, 'w') as f:
        w = csv.DictWriter(f, 'title href date'.split())
        w.writeheader()
        w.writerows(datasets)

def get_files(dataverse):
    get_datasets(dataverse)
    file = f'out/{dataverse}/files.csv'
    if isfile(file):
        return print(f'{file} already exists')

    files = []
    with open(f'out/{dataverse}/datasets.csv') as f:
        r = csv.DictReader(f)
        for row in r:
            r = attempt(base_url + row['href'])
            soup = BeautifulSoup(r.text, 'html.parser')
            for md in soup.find_all('td', class_='col-file-metadata'):
                files.append(dict(row, filename=md.a.text.strip(), file_href=md.a['href']))

    with open(file, 'w') as f:
        w = csv.DictWriter(f, 'title href filename file_href'.split())
        w.writeheader()
        w.writerows(files)

def get_downloads(dataverse):
    get_files(dataverse)
    with open(f'out/{dataverse}/files.csv') as f, open(f'out/{dataverse}/download_errors.csv', 'a') as f1:
        r, w = csv.DictReader(f), csv.DictWriter(f1, ['title', 'href', 'filename', 'file_href', 'error'])
        for row in r:
            id = row['file_href'].split('&')[0]
            try:
                id = id.split('?')[-1]
                url = f'/api/access/datafile/:persistentId?{id}'
                id = id.split('/')[2]
            except:
                url = join('/api/access/datafile', id.split('fileId=')[-1])
                id = row['href'].split('&')[0].split('/')[-1]

            dir = join(dataverse, id)
            os.makedirs(dir, exist_ok=True)
            fname = join(dir, row['filename'])
            if isfile(fname):
                continue

            r = attempt(base_url + url)
            if r.status_code != 200:
                row['error'] = r.status_code
                w.writerow(row)
                continue
            with open(fname, 'wb') as f:
                for chunk in r.iter_content(chunk_size=128):
                    f.write(chunk)

cmds = {'get_datasets': get_datasets, 'get_files': get_files, 'get_downloads': get_downloads}
cmds[sys.argv[1]](sys.argv[2])
