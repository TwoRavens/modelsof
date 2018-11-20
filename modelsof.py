import collections
import csv
import os, os.path
import re
import sys
import zipfile

from bs4 import BeautifulSoup
import requests

from parse import parse

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

def unzip(path):
    try:
        with zipfile.ZipFile(path, allowZip64=False) as zip:
            path = path.rstrip('.zip')
            namelist = zip.namelist()
            zip.extractall(path)
            zip.close()
            for file in namelist:
                if file.lower().endswith('.zip'):
                    unzip(path + '/' + file)
    except Exception as e:
        print(path, e)

def stat(command_cnts, cnt, path):
    _, ext = os.path.splitext(path)
    ext = ext.lower()
    if ext == '.zip':
        return

    if not os.path.isfile(path):
        for file in os.listdir(path):
            if file != '__MACOSX':
                stat(command_cnts, cnt, path + '/' + file)
        return

    cnt[ext] += 1
    if ext == '.do':
        delimit = 'cr'
        commands = []
        n_reg_cmds = 0
        with open(path, encoding='latin-1') as f:
            try:
                data = f.read()
            except:
                print('error', path)

            delims = [(match[0], match[1], match.end()) for match in re.finditer(r'#delimit\s*(cr|;)?', data)]
            delims = delims if delims else [('delim cr', 'cr', 0)]
            for (cmd, delim, end) in delims:
                commands.append(cmd)
                data = data[end:]
                try:
                    parse(data)
                except Exception as e:
                    print(path, e)

        for cmd in commands:
            for reg in regression_cmds:
                if reg in cmd.split():
                    n_reg_cmds += 1

        command_cnts.append([path, len(commands), n_reg_cmds])
        for cmd in commands:
            pass#print('CMD:', cmd)

def get_stats(path):
    datasets = os.listdir(path)
    cnts = {}
    totals = collections.Counter()
    command_cnts = []
    for ds in datasets:
        dspath = path + '/' + ds
        for file in os.listdir(dspath):
            filepath = dspath + '/' + file
            _, ext = os.path.splitext(file)
            if ext.lower() == '.zip':
                unzip(filepath)

        cnt = collections.Counter()
        for file in os.listdir(dspath):
            stat(command_cnts, cnt, dspath + '/' + file)
            break
        break

        cnts[ds] = cnt
        totals.update(cnt)

    journal = path.split('/')[-1]
    do_cnts = collections.Counter(['=1', '>1'])
    with open('%s_counts.csv' % journal, 'w') as f:
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

    with open('%s_stats.csv' % journal, 'w') as f:
        w = csv.writer(f)
        w.writerow([journal, '%s datasets' % len(datasets)])
        w.writerow(['=1', do_cnts['=1']])
        w.writerow(['>1', do_cnts['>1']])
        for ext in sorted(totals):
            w.writerow([ext, totals[ext]])

    with open('%s_commands.csv' % journal, 'w') as f:
        w = csv.writer(f)
        w.writerow(['file', '#', '# reg'])
        for cnt in command_cnts:
            w.writerow(cnt)

cmd = {'get_datasets': get_datasets,
       'get_files': get_files,
       'get_downloads': get_downloads,
       'get_stats': get_stats}[sys.argv[1]]
cmd(sys.argv[2])
