import csv
import os, os.path
import sys

from bs4 import BeautifulSoup
import requests

base_url = 'https://dataverse.harvard.edu'

def attempt(url):
    attempts = 0
    while True:
        try:
            r = requests.get(url, timeout=10)
            r.raise_for_status()
            print(r.url)
            return r
        except:
            if attempts < 3:
                attempts += 1
                continue
            raise

def get_datasets(dataverse):
    fname = dataverse + '.csv'
    if os.path.isfile(fname):
        return print(fname + ' already exists')

    url = '/'.join([base_url, 'dataverse', dataverse])
    datasets = []
    while True:
        r = attempt(url)
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
            r = attempt(base_url + row['href'])
            soup = BeautifulSoup(r.text, 'html.parser')
            for md in soup.find_all('td', class_='col-file-metadata'):
                files.append(dict(row, filename=md.a.text.strip(), file_href=md.a['href']))

    with open(fname, 'w') as f:
        w = csv.DictWriter(f, ['title', 'href', 'filename', 'file_href'])
        w.writeheader()
        w.writerows(files)

def get_downloads(dataverse):
    get_files(dataverse)
    with open(dataverse + '_files.csv') as f:
        r = csv.DictReader(f)
        for row in r:
            id = row['file_href'].split('&')[0]            
            try:
                id = id.split('?')[-1]
                url = '/api/access/datafile/:persistentId?' + id
                id = id.split('/')[2]
            except:
                url = '/api/access/datafile/' + id.split('fileId=')[-1]
                id = row['href'].split('&')[0].split('/')[-1]            

            dir = dataverse + '/' + id            
            os.makedirs(dir, exist_ok=True)
            fname = dir + '/' + row['filename']
            if os.path.isfile(fname):
                continue

            r = attempt(base_url + url)
            with open(fname, 'wb') as f:
                for chunk in r.iter_content(chunk_size=128):
                    f.write(chunk)

cmd = {'get_datasets': get_datasets, 
       'get_files': get_files,
       'get_downloads': get_downloads}[sys.argv[1]]
cmd(sys.argv[2])
