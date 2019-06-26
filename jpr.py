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

base_url = 'https://www.prio.org'

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

def get_datasets():
    file = f'out/jpr/datasets.csv'
    if isfile(file):
        return print(f'{file} already exists')

    datasets = []
    r = attempt(base_url + '/JPR/Datasets')
    soup = BeautifulSoup(r.text, 'html.parser')
    for h2 in soup.find_all(class_='highlight'):
        year = h2.text.strip()
        obj = h2.parent
        while 1:
            obj = obj.next_sibling
            if not obj or obj.name == 'div':
                break
            elif obj.name == 'ul':
                for a in obj.find_all('a'):
                    datasets.append(dict(title=a.text.strip(), href=a['href'], date=year))

    os.makedirs('out/jpr', exist_ok=True)
    with open(file, 'wt', encoding='utf8') as f:
        w = csv.DictWriter(f, 'title href date'.split())
        w.writeheader()
        w.writerows(datasets)

def get_downloads():
    downloads_dir = get_downloads_dir('jpr')
    os.makedirs(downloads_dir, exist_ok=True)
    with open(f'out/jpr/datasets.csv', encoding='utf8') as f, open(f'{downloads_dir}/errors.csv', 'a') as f1:
        r, w = csv.DictReader(f), csv.DictWriter(f1, 'title href date error'.split())
        for row in r:
            href = row['href']
            if href.startswith('http://file.prio.no') or href.endswith('.zip'):
                url = href
            elif href.startswith('/'):
                url = base_url + href
            else:
                row['error'] = 'bad href' 
                w.writerow(row)
                continue

            dir = f'{downloads_dir}/{row["date"]}/'
            file = dir + href.split('/')[-1]
            if isfile(file):
                continue

            r = attempt(url)
            if not r or r.status_code != 200:
                row['error'] = r.status_code if r else 'exception'
                w.writerow(row)
                continue

            os.makedirs(dir, exist_ok=True)
            with open(file, 'wb') as f:
                for chunk in r.iter_content(chunk_size=128):
                    f.write(chunk)

def unzip():
    downloads_dir = get_downloads_dir('jpr')
    errors = []
    while True:
        break
        files = glob.glob(f'{downloads_dir}/**/*', recursive=True)
        files = [f for f in files if not f in errors and isfile(f)]
        if not files:
            break

        for file in files:
            try:
                if 'xSub_Replication.zip' in file:
                    errors.append(file)
                    continue

                dir = file.rstrip('.zip') + '_x'
                subprocess.run(['7z', 'x', f'-o{dir}', '-r', file], check=True)
                os.remove(file)
            except:
                errors.append(file)

    all_files = f'out/jpr/all_files.csv'
    if isfile(all_files):
        return print(f'{all_files} already exists')

    files = set([f for f in glob.glob(f'{downloads_dir}/**/*', recursive=True) if splitext(f)[1]][1:])
    with open(all_files, 'w') as f:
        w = csv.writer(f) 
        w.writerows([['file']] + [[file.replace('\\', '/')] for file in files])

cmd = {
    'get_datasets': get_datasets,
    'get_downloads': get_downloads,
    'unzip': unzip,
}[sys.argv[1]]
cmd(*sys.argv[2:])
