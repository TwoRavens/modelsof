import collections
import csv
import glob
import os
from os.path import dirname, isfile, join, split, splitext
import shutil
import subprocess
import sys

from bs4 import BeautifulSoup
import requests

base_url = 'https://dataverse.harvard.edu'
exts = '.do .7z .7zip .gz .rar .tar .zip'.split()

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

def get_ext(file):
    return splitext(file)[1].lower()

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
        w = csv.DictWriter(f, 'title href date filename file_href'.split())
        w.writeheader()
        w.writerows(files)

def get_ext_counts(dataverse, year):
    with open(f'out/{dataverse}/files.csv') as f:
        r = csv.DictReader(f)
        cnt = collections.Counter(get_ext(row['filename']) for row in r if row['date'].endswith(year))
    print(cnt)

def get_downloads(dataverse, year=None):
    get_files(dataverse)
    os.makedirs(f'out/{dataverse}/downloads', exist_ok=True)
    with open(f'out/{dataverse}/files.csv') as f, open(f'out/{dataverse}/downloads/errors.csv', 'a') as f1:
        r, w = csv.DictReader(f), csv.DictWriter(f1, 'title href date filename file_href error'.split())
        for row in r:
            row_year = row['date'].strip()[-4:]
            if year and not year == row_year:
                continue
            if not splitext(row['filename'])[1].lower() in exts:
                continue
            id = row['file_href'].split('&')[0]
            try:
                id = id.split('?')[-1]
                url = f'/api/access/datafile/:persistentId?{id}'
                id = id.split('/')[2]
            except:
                url = join('/api/access/datafile', id.split('fileId=')[-1])
                id = row['href'].split('&')[0].split('/')[-1]

            dir = join('out', dataverse, 'downloads', row_year, id)
            os.makedirs(dir, exist_ok=True)
            file = join(dir, row['filename'])
            if isfile(file):
                continue

            r = attempt(base_url + url)
            if r.status_code != 200:
                row['error'] = r.status_code
                w.writerow(row)
                continue
            with open(file, 'wb') as f:
                for chunk in r.iter_content(chunk_size=128):
                    f.write(chunk)
        
def unzip(dataverse):
    unzipped = []
    while True:
        files = glob.glob(f'out/{dataverse}/downloads/**/*', recursive=True)
        files = [f for f in files if not get_ext(f) in ('.do', '')][1:]
        if not files:
            break
        for file in files:
            ext = get_ext(file)
            dir = split(file)[0]
            try:
                if ext in '.gz .tar .zip'.split(): 
                    shutil.unpack_archive(file, dir)
                    os.remove(file)
                if ext in '.7z .7zip .rar'.split():
                    subprocess.run(['7z', 'x', file, f'-o{dir}', '-r'], check=True) and os.remove(file)
            except Exception as e:
                print('error:', file, e)
            files = glob.glob(f'{dir}/*', recursive=True)
            for file in files:
                if not get_ext(file) == '.do':
                    try:
                        os.remove(file)
                    except:
                        pass
            unzipped += files

    with open(f'out/{dataverse}/unzipped_files.csv', 'w') as f:
        w = csv.writer(f)
        w.writerow(['filename'])
        w.writerows(unzipped)

cmd = {
    'get_datasets': get_datasets, 
    'get_files': get_files, 
    'get_ext_counts': get_ext_counts, 
    'get_downloads': get_downloads,
    'unzip': unzip,
}[sys.argv[1]]
cmd(*sys.argv[2:])
