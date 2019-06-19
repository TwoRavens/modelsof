from collections import Counter, OrderedDict
import csv
import glob
import json
import os
from os.path import dirname, isfile, join, split, splitext
import subprocess
import sys

from bs4 import BeautifulSoup
import requests

base_url = 'https://dataverse.harvard.edu'
#base_url = 'https://dataverse.unc.edu'

exts = dict(
    zip = '.7z .7zip .bz2 .gz .gzip .rar .tar .xz .zip'.split(),
    data = '.csv .dat .dbf .tab .tsv .txt .xls .xlsx .xml'.split(),
    gis_data = '.cpg .inp .lgs .prj .qpj .sbn .sbx .shp .shx .trk'.split(),
    jags = '.jags'.split(),
    matlab = '.m'.split(),
    matlab_data = '.mat'.split(),
    r = '.r'.split(),
    r_data = '.rd .rda .rdata .rds'.split(),
    r_other = '.history .rmd .rout'.split(),
    sas = '.sas'.split(),
    spss = '.sps'.split(),
    spss_data = '.sav .spv'.split(),
    stata = '.ado .do'.split(),
    stata_data = '.dta .gph'.split(),
    stata_other = '.grec .hlp .smcl .sthlp'.split(),
)

def attempt(url, stream=False):
    attempts = 0
    while True:
        try:
            print(url)
            r = requests.get(url, stream, timeout=10)
            if r.status_code in (403, 404):
                return r

            r.raise_for_status()
            return r
        except:
            if attempts > 4:
                break  

            attempts += 1

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

def get_datasets(*args):
    for dataverse in args:
        file = f'out/{dataverse}/datasets.csv'
        if isfile(file):
            return print(f'{file} already exists')

        url = '/'.join([base_url, 'dataverse', dataverse])
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
        with open(file, 'wt', encoding='utf8') as f:
            w = csv.DictWriter(f, 'title href date'.split())
            w.writeheader()
            w.writerows(datasets)

def get_files(*args):
    for dataverse in args:
        get_datasets(dataverse)
        file = f'out/{dataverse}/files.csv'
        if isfile(file):
            return print(f'{file} already exists')

        files = []
        with open(f'out/{dataverse}/datasets.csv', encoding='utf8') as f:
            r = csv.DictReader(f)
            for row in r:
                r = attempt(base_url + row['href'])
                soup = BeautifulSoup(r.text, 'html.parser')
                for md in soup.find_all('td', class_='col-file-metadata'):
                    files.append(dict(row, filename=md.a.text.strip(), file_href=md.a['href']))

        with open(file, 'wt', encoding='utf8') as f:
            w = csv.DictWriter(f, 'title href date filename file_href'.split())
            w.writeheader()
            w.writerows(files)

def get_ext_counts():
    cnt = Counter()
    for file in glob.glob(f'out/**/all_files.csv'):
        with open(file) as f:
            for row in csv.DictReader(f):
                year = row['file'].split('/')[3]
                if year == '2018':
                    cnt[get_ext(row['file'])] += 1
    print(sorted(cnt.keys()))

def get_downloads(dataverse, year=None):
    get_files(dataverse)
    downloads_dir = get_downloads_dir(dataverse)
    os.makedirs(get_downloads_dir(dataverse), exist_ok=True)
    with open(f'out/{dataverse}/files.csv', encoding='utf8') as f, open(f'{downloads_dir}/errors.csv', 'a') as f1:
        r, w = csv.DictReader(f), csv.DictWriter(f1, 'title href date filename file_href error'.split())
        for row in r:
            row_year, id, url, dir, file = split_row(row, downloads_dir)
            if year and not year == row_year:
                continue
            if not splitext(row['filename'])[1].lower() in exts['zip'] + ['.do']:
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
    errors = []
    while True:
        files = glob.glob(f'{get_downloads_dir(dataverse)}/**/*', recursive=True)
        files = [f for f in files if get_ext(f) in exts['zip'] and not f in errors]
        if not files:
            break

        for file in files:
            try:
                subprocess.run(['7z', 'x', f'-o{split(file)[0]}', '-r', file], check=True)
                os.remove(file)
            except:
                errors.append(file)

    all_files = f'out/{dataverse}/all_files.csv'
    if isfile(all_files):
        return print(f'{all_files} already exists')

    downloads_dir = get_downloads_dir(dataverse)
    files = set([f for f in glob.glob(f'{downloads_dir}/**/*', recursive=True) if splitext(f)[1]][1:])
    with open(f'out/{dataverse}/files.csv', encoding='utf8') as f:
        r = csv.DictReader(f)
        for row in r:
            file = split_row(row, downloads_dir)[-1]
            ext = get_ext(file)
            if not ext in exts['zip'] or isfile(file):
                files.add(file)
            if isfile(file) and not ext == '.do':
                os.remove(file)

    with open(all_files, 'w') as f:
        w = csv.writer(f) 
        w.writerows([['file']] + [[file.replace('\\', '/')] for file in files])

def inc(ext, keys, counts):
    for key in keys.split():
        if ext in exts[key]:
            counts[key] += 1
            return True

def update_dist(dist, file, counts):
    journal = file.replace('\\', '/').split('/')[1]
    total = sum(counts.values())
    dist[journal] = {k: v / total for k, v in counts.items()}
    return journal

def plot(path, dist, kinds, horiz=''):
    with open(f'out/{path}.csv', 'w') as f:
        w = csv.writer(f)
        keys = sorted(dist.keys())
        w.writerow([''] + list(keys))
        for kind in kinds:
            row = [dist[k].get(kind, 0) for k in keys]
            if sum(row):
                w.writerow([kind] + row)
    subprocess.run(['Rscript', 'plots.R', path, horiz], check=True)

def plot_files():
    cnt = {} 
    for file in glob.glob(f'out/**/all_files.csv'):
        journal = file.split('/')[1]
        with open(file) as f:
            for row in csv.DictReader(f):
                year, dataset = row['file'].replace('\\', '/').split('/')[3:5]
                k = (journal, year) 
                if not cnt.get(k):
                    cnt[k] = dict(all=set(), r=set(), stata=set())
                cnt[k]['all'].add(dataset)
                ext = get_ext(row['file'])
                for x in ('r', 'stata'):
                    if ext in exts[x]:
                        cnt[k][x].add(dataset)

    with open('out/files.csv', 'w') as f:
        w = csv.writer(f)
        w.writerow('journal year stata r both neither'.split())
        for k, v in cnt.items(): 
            all, r, stata = [v[k] for k in 'all r stata'.split()]
            w.writerow([k[0], k[1], len(stata - r), len(r - stata), len(stata & r), len(all - (stata | r))])

def plot_files_by_year():
    all_sets = dict()
    for file in glob.glob(f'out/**/all_files.csv'):
        journal = file.split('/')[1]
        sets = dict()
        with open(file) as f:
            for row in csv.DictReader(f):
                year, dataset = row['file'].split('/')[3:5]
                if not sets.get(year):
                    sets[year] = dict(all=set(), stata=set(), r=set())
                sets[year]['all'].add(dataset)
                ext = get_ext(row['file'])
                if ext in exts['stata']:
                    sets[year]['stata'].add(dataset)
                elif ext in exts['r']:
                    sets[year]['r'].add(dataset)

        for year in sets:
            if not all_sets.get(year):
                all_sets[year] = dict(all=set(), stata=set(), r=set())
            for k in ('all', 'stata', 'r'):
                all_sets[year][k].update(sets[year][k])

        dist = dict()
        for year in sets:
            all, stata, r = sets[year]['all'], sets[year]['stata'], sets[year]['r']
            total = len(all)
            dist[year] = {
                'stata': len(stata - r) / total,
                'r': len(r - stata) / total,
                'both': len(stata & r) / total,
                'neither': len(all - (stata | r)) / total
            }
        plot(journal + '/files_by_year', dist, 'stata r both neither'.split())

    dist = dict()
    sets = all_sets
    for year in sets:
        all, stata, r = sets[year]['all'], sets[year]['stata'], sets[year]['r']
        total = len(all)
        dist[year] = {
            'stata': len(stata - r) / total,
            'r': len(r - stata) / total,
            'both': len(stata & r) / total,
            'neither': len(all - (stata | r)) / total
        }
    plot('files_by_year', dist, 'stata r both neither'.split())

def plot_commands():
    with open('out/regressions.csv', 'w') as f:
        w = csv.writer(f)
        w.writerow('journal year command count'.split()) 
        for file in glob.glob(f'out/*/regressions.csv'):
            journal = file.split('/')[1]
            with open(file) as f1:
                r = csv.reader(f1)
                next(r)
                for row in r:
                    w.writerow([journal] + row)

cmd = {
    'get_datasets': get_datasets,
    'get_files': get_files,
    'get_ext_counts': get_ext_counts,
    'get_downloads': get_downloads,
    'unzip': unzip,
    'plot_files': plot_files,
    'plot_files_by_year': plot_files_by_year,
    'plot_commands': plot_commands,
}[sys.argv[1]]
cmd(*sys.argv[2:])
