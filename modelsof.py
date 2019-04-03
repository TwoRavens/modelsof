import collections
import csv
import glob
import json
import os
from os.path import dirname, isfile, join, split, splitext
import shutil
import subprocess
import sys

from bs4 import BeautifulSoup
import requests

base_url = 'https://dataverse.harvard.edu'
exts = '.7z .7zip .gz .rar .tar .zip'.split()

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

def get_downloads_dir(dataverse):
    return f'out/{dataverse}/downloads'

def split_row(row, downloads_dir):            
    year = row['date'].strip()[-4:]
    id = row['file_href'].split('&')[0]
    try:
        id = id.split('?')[-1]
        url = f'/api/access/datafile/:persistentId?{id}'
        id = id.split('/')[2]
    except:
        url = join('/api/access/datafile', id.split('fileId=')[-1])
        id = row['href'].split('&')[0].split('/')[-1]

    dir = join(downloads_dir, year, id)
    file = join(dir, row['filename'])
    return year, id, url, dir, file

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
    downloads_dir = get_downloads_dir(dataverse)
    os.makedirs(get_downloads_dir(dataverse), exist_ok=True)
    with open(f'out/{dataverse}/files.csv') as f, open(f'{downloads_dir}/errors.csv', 'a') as f1:
        r, w = csv.DictReader(f), csv.DictWriter(f1, 'title href date filename file_href error'.split())
        for row in r:
            row_year, id, url, dir, file = split_row(row, downloads_dir)
            if year and not year == row_year:
                continue
            if not splitext(row['filename'])[1].lower() in exts + ['.do']:
                continue
            os.makedirs(dir, exist_ok=True)
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
    error = []
    while True:
        files = glob.glob(f'{get_downloads_dir(dataverse)}/**/*', recursive=True)
        files = [f for f in files if get_ext(f) in exts and not f in error]
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
                error.append(file)

def get_all_files(dataverse):
    downloads_dir = get_downloads_dir(dataverse)
    files = set([f for f in glob.glob(f'{downloads_dir}/**/*', recursive=True) if splitext(f)[1]][1:])
    with open(f'out/{dataverse}/files.csv') as f:
        r = csv.DictReader(f)
        files.update(set(split_row(row, downloads_dir)[-1] for row in r))
    with open(f'out/{dataverse}/all_files.csv', 'w') as f:
        w = csv.writer(f)
        w.writerow(['file'])
        for file in files:
            w.writerow([file])

def plot(which, dist, kinds):
    with open(f'out/{which}_dist.csv', 'w') as f:
        w = csv.writer(f)
        keys = dist.keys()
        w.writerow([''] + list(keys))
        for kind in kinds.split():
            w.writerow([kind] + [dist[k][kind] for k in keys])
    subprocess.run(['Rscript', 'plots.R', which], check=True)

def plot_files():
    dist, dist1 = collections.OrderedDict(), collections.OrderedDict()
    for file in glob.glob(f'out/**/all_files.csv'):
        with open(file) as f:
            counts = collections.Counter()
            datasets, datasets_stata, datasets_r = set(), set(), set()
            for row in csv.DictReader(f):
                year, dataset = row['file'].split('/')[3:5]
                if year != '2018':
                    continue
                datasets.add(dataset)
                ext = get_ext(row['file'])
                if ext in '.do'.split():
                    counts['stata'] += 1 
                    datasets_stata.add(dataset)
                elif ext in '.r'.split():
                    counts['r'] += 1 
                    datasets_r.add(dataset)
                elif ext:
                    counts['other'] += 1 
            journal = file.split('/')[1]
            total = sum(counts.values())
            dist[journal] = {k: v / total for k, v in counts.items()}
            total = len(datasets) 
            dist1[journal] = {
                'stata': len(datasets_stata - datasets_r) / total, 
                'r': len(datasets_r - datasets_stata) / total, 
                'both': len(datasets_stata & datasets_r) / total, 
                'neither': len(datasets - (datasets_stata | datasets_r)) / total
            }
    plot('files', dist, 'stata r other')
    plot('files_by_datasets', dist1, 'stata r both neither')

def plot_commands():
    dist = collections.OrderedDict() 
    for file in glob.glob(f'out/**/stats.json'):
        with open(file) as f:
            counts = collections.Counter()
            for row in json.load(f)[1:]:
                counts.update(dict(
                    linear=row.get('len_regression/linear', 0), 
                    nonlinear=row.get('len_regression/nonlinear', 0), 
                    total=row.get('len', 0)
                ))
            linear, nonlinear, total = counts['linear'], counts['nonlinear'], counts['total'] 
            dist[file.split('/')[1]] = dict(
                linear_regression=linear / total, 
                nonlinear_regression=nonlinear / total, 
                other=(total - linear - nonlinear) / total
            ) 
    plot('commands', dist, 'linear_regression nonlinear_regression other')

cmd = {
    'get_datasets': get_datasets, 
    'get_files': get_files, 
    'get_ext_counts': get_ext_counts, 
    'get_downloads': get_downloads,
    'unzip': unzip,
    'get_all_files': get_all_files,
    'plot_files': plot_files,
    'plot_commands': plot_commands,
}[sys.argv[1]]
cmd(*sys.argv[2:])
