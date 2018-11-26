import collections
import csv
import json
import os, os.path
import re
import sys
import zipfile

from bs4 import BeautifulSoup
import requests

from grammar import parser

isfile, join, splitext = [getattr(os.path, a) for a in 'isfile join splitext'.split()]

base_url = 'https://dataverse.harvard.edu'

regression_cmds = []
with open('regression.txt') as f:
    for line in f.readlines():
        regression_cmds.append(line.split()[0])

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
    file = f'{dataverse}.csv'
    if isfile(file):
        return print(f'{file} already exists')

    url = join(base_url, 'dataverse', dataverse)
    datasets = []
    while True:
        r = attempt(url)
        soup = BeautifulSoup(r.text, 'html.parser')
        for ds in soup.find_all(class_='datasetResult'):
            datasets.append(dict(title=ds.a.span.text, href=ds.a['href']))

        next_page = soup.find('a', text='Next >')['href']
        if next_page.split('=')[-1] == url.split('=')[-1]:
            break
        url = base_url + next_page

    with open(file, 'w') as f:
        w = csv.DictWriter(f, ['title', 'href'])
        w.writeheader()
        w.writerows(datasets)

def get_files(dataverse):
    get_datasets(dataverse)
    fname = f'{dataverse}_files.csv'
    if isfile(fname):
        return print(f'{fname} already exists')

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
    with open(f'{datataverse}_files.csv') as f:
        r = csv.DictReader(f)
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
            with open(fname, 'wb') as f:
                for chunk in r.iter_content(chunk_size=128):
                    f.write(chunk)

def unzip(path):
    try:
        with zipfile.ZipFile(path, allowZip64=False) as zip:
            path = path.rstrip('.zip')
            namelist = zip.namelist()
            zip.extractall(path)
            zip.close()
            for file in namelist:
                if file.lower().endswith('.zip'):
                    unzip(join(path, file))
    except Exception as e:
        print(path)
        print(e)

def stat(command_cnts, cnt, path):
    _, ext = splitext(path)
    ext = ext.lower()
    if ext == '.zip':
        return

    if not isfile(path):
        for file in os.listdir(path):
            if file != '__MACOSX':
                stat(command_cnts, cnt, join(path, file))
        return

    cnt[ext] += 1
    if ext == '.do':
        delimit = 'cr'
        comments, commands = [], []
        n_reg_cmds = 0
        with open(path, encoding='latin-1') as f:
            command = ''
            for line in f:
                line = line.strip()
                if line.startswith('*'):
                    comments.append(line)
                    continue

                ind = line.find('/*')
                if ind > -1:
                    comment = ''
                    if ind:
                        commands.append(command + line[:ind])
                        command = ''
                        comment += line[ind + 1:]
                        while True:
                            line = f.readline()
                            comment += line
                            if line.find('*/') > -1:
                                comments.append(comment)
                                break 
                elif line and line != '}':
                    command += line
                    if not line.endswith('///'):
                        commands.append(command)
                        command = ''

        command_cnts.append((path, len(comments), collections.Counter(x.split()[0] for x in commands)))

def get_stats(path):
    datasets = os.listdir(path)
    cnts = {}
    totals = collections.Counter()
    command_cnts = []
    for ds in datasets:
        dspath = join(path, ds)
        for file in os.listdir(dspath):
            filepath = join(dspath, file)
            _, ext = splitext(file)
            if ext.lower() == '.zip':
                unzip(filepath)

        cnt = collections.Counter()
        for file in os.listdir(dspath):
            stat(command_cnts, cnt, join(dspath, file))

        cnts[ds] = cnt
        totals.update(cnt)

    journal = path.split('/')[-1]
    do_cnts = collections.Counter(['=1', '>1'])
    with open(f'{journal}_counts.csv', 'w') as f:
        w = csv.writer(f)
        header = sorted(totals)
        w.writerow(['dataset'] + header)
        for ds in sorted(cnts):
            do_cnt = cnts[ds].get('.do', 0)
            if do_cnt == 1:
                do_cnts['=1'] += 1
            elif do_cnt > 1:
                do_cnts['>1'] += 1

            w.writerow([ds] + [cnts[ds].get(h, '') for h in header])

    with open(f'{journal}_stats.csv', 'w') as f:
        w = csv.writer(f)
        w.writerow([journal, f'{len(datasets)} datasets'])
        w.writerow(['=1', do_cnts['=1']])
        w.writerow(['>1', do_cnts['>1']])
        for ext in sorted(totals):
            w.writerow([ext, totals[ext]])

    with open(f'{journal}_commands.json', 'w') as f:
        for path, comments, commands in command_cnts:
            regression, other = [], []
            for k in sorted(commands):
                v = commands[k]
                if k in regression_cmds:
                    regression.append((k, v))
                else:
                    other.append((k, v))
            json.dump(dict(path=path, comments=comments, regression=regression, other=other), f, indent=2)

cmd = {'get_datasets': get_datasets,
       'get_files': get_files,
       'get_downloads': get_downloads,
       'get_stats': get_stats}[sys.argv[1]]
cmd(sys.argv[2])
