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

exts = dict(
    zip = '.7z .7zip .gz .rar .tar .zip'.split(),
    data = '.dat .dbf .xml'.split(),
    excel = '.xls .xlsx'.split(),
    gis_data = '.cpg .inp .lgs .prj .qpj .sbn .sbx .shp .shx .trk'.split(),
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
    text = '.csv .tab .tsv .txt'.split(),
)

def attempt(url):
    attempts = 0
    while True:
        try:
            print(url)
            r = requests.get(url, stream=True, timeout=30)
            if r.status_code == 403:
                return r
            r.raise_for_status()
            return r
        except:
            if attempts < 6:
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
            ds = dict(title=ds.a.span.text, href=ds.a['href'], date=ds.find(class_='text-muted').text)
            r1 = attempt(base_url + ds['href'])
            soup1 = BeautifulSoup(r1.text, 'html.parser')
            ds['description'] = soup1.find('div', class_='form-group').div.div.text.strip()
            kws = soup1.find('div', id='keywords')
            ds['keywords'] = kws.text.strip().split('\n')[-1] if kws else ''
            datasets.append(ds)

        next_page = soup.find('a', text='Next >')['href']
        if next_page.split('=')[-1] == url.split('=')[-1]:
            break
        url = base_url + next_page

    os.makedirs('out/' + dataverse, exist_ok=True)
    with open(file, 'w') as f:
        w = csv.DictWriter(f, 'title href date description keywords'.split())
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
        w = csv.DictWriter(f, 'title href date filename file_href'.split(), extrasaction='ignore')
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
    with open(f'out/{dataverse}/files.csv') as f, open(f'{downloads_dir}/errors.csv', 'a') as f1:
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

            try:
                r = attempt(base_url + url)
                if r.status_code != 200:
                    row['error'] = r.status_code
                    w.writerow(row)
                    continue
                with open(file, 'wb') as f:
                    for chunk in r.iter_content(chunk_size=128):
                        f.write(chunk)
            except:
                os.remove(file)
                raise

def unzip(dataverse):
    error = []
    while True:
        files = glob.glob(f'{get_downloads_dir(dataverse)}/**/*', recursive=True)
        files = [f for f in files if get_ext(f) in exts['zip'] and not f in error]
        if not files:
            break
        for file in files:
            ext = get_ext(file)
            dir = split(file)[0]
            try:
                if ext in exts['zip']:
                    subprocess.run(['7z', 'x', file, f'-o{dir}', '-r', '-y'], check=True) and os.remove(file)
            except Exception as e:
                print('error:', file, e)
                error.append(file)

def get_all_files(dataverse):
    downloads_dir = get_downloads_dir(dataverse)
    files = set([f for f in glob.glob(f'{downloads_dir}/**/*', recursive=True) if splitext(f)[1]][1:])
    with open(f'out/{dataverse}/files.csv') as f:
        r = csv.DictReader(f)
        for row in r:
            file = split_row(row, downloads_dir)[-1]
            if not get_ext(file) in exts['zip'] or isfile(file):
                files.add(file)
    with open(f'out/{dataverse}/all_files.csv', 'w') as f:
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

def plot(which, dist, kinds, horiz=''):
    with open(f'out/{which}_dist.csv', 'w') as f:
        w = csv.writer(f)
        keys = dist.keys()
        w.writerow([''] + list(keys))
        for kind in kinds:
            row = [dist[k].get(kind, 0) for k in keys]
            if sum(row):
                w.writerow([kind] + row)
    subprocess.run(['Rscript', 'plots.R', which, horiz], check=True)

def plot_files():
    data_exts = 'excel text gis_data matlab_data spss_data stata_data r_data'
    dist, dist1, dist2, data_dist = OrderedDict(), OrderedDict(), OrderedDict(), OrderedDict()
    for file in glob.glob(f'out/**/all_files.csv'):
        counts, data_counts = Counter(), Counter()
        datasets, datasets_stata, datasets_r = set(), set(), set()
        with open(file) as f:
            for row in csv.DictReader(f):
                year, dataset = row['file'].split('/')[3:5]
                if year != '2018':
                    continue

                datasets.add(dataset)
                ext = get_ext(row['file'])
                if inc(ext, 'stata stata_data stata_other', counts):
                    datasets_stata.add(dataset)
                elif inc(ext, 'r r_data r_other', counts):
                    datasets_r.add(dataset)
                elif ext:
                    inc(ext, 'matlab sas spss', counts)
                    counts['other'] += 1

                if ext in exts['data']:
                    data_counts[ext] += 1
                elif inc(ext, data_exts, data_counts):
                    continue
                else:
                    data_counts['other'] += 1

        journal = update_dist(dist, file, counts)
        dist1[journal] = dist[journal].copy()
        dist1[journal]['other'] += sum(dist[journal].get(k, 0) for k in 'stata_data stata_other r_data r_other'.split())
        total = len(datasets)
        dist2[journal] = {
            'stata': len(datasets_stata - datasets_r) / total,
            'r': len(datasets_r - datasets_stata) / total,
            'both': len(datasets_stata & datasets_r) / total,
            'neither': len(datasets - (datasets_stata | datasets_r)) / total
        }
        update_dist(data_dist, file, data_counts)

    plot('files', dist, 'stata stata_data stata_other r r_data r_other other'.split())
    plot('analysis_files', dist1, 'stata r matlab sas spss other'.split())
    plot('files_by_datasets', dist2, 'stata r both neither'.split())
    plot('data_files', data_dist, exts['data'] + data_exts.split() + ['other'])

def plot_commands():
    cmds, regs = [], []
    for file in glob.glob(f'out/**/stats.json'):
        journal = file.replace('\\', '/').split('/')[1]
        with open(file) as f:
            cnts = json.load(f)[:2]
        cmds += [[journal] + list(cnt) for cnt in Counter(cnts[0]).most_common()]
        regs += [[journal] + list(cnt) for cnt in Counter(cnts[1]).most_common()]
    for k, v in dict(commands=cmds, reg_commands=regs).items():
        with open(f'out/{k}.csv', 'w') as f:
            w = csv.writer(f)
            w.writerows(['journal command n'.split()] + v)

    #plot('commands', dist, sorted(cmds[0]) + ['other'], 'y')
    #plot('reg_commands', reg_dist, sorted(cmds[1]) + ['other'], 'y')

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
