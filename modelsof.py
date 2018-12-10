import collections
import csv
import json
import os, os.path
import re
import sys
import zipfile

from bs4 import BeautifulSoup
import requests

dirname, isfile, join, splitext = [getattr(os.path, a) for a in 'dirname isfile join splitext'.split()]

base_url = 'https://dataverse.harvard.edu'

with open('categories.json') as f:
    categories = json.load(f)

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
    with open(f'{dataverse}_files.csv') as f, open('download_errors.csv', 'a') as f1:
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

    both, comments, commands = [], [], []
    def append(lst, item):
        lst.append(item)
        both.append(item)

    cnt[ext] += 1
    if ext == '.do':
        delimit = 'cr'
        with open(path, encoding='utf-8') as f:
            command = ''
            for line in f:
                line = line.strip()
                if line.startswith('*') or line.startswith('///'):
                    append(comments, line)
                    continue

                ind = line.find('/*')
                if ind > -1:
                    comment = ''
                    if ind:
                        append(commands, command + line[:ind])
                        command = ''
                    while True:
                        comment += line[ind:]
                        if line.find('*/') > -1:
                            append(comments, comment.strip())
                            break 
                        line = f.readline()
                elif line and line != '}':
                    command += line
                    if not line.endswith('///'):
                        append(commands, command)
                        command = ''

        os.makedirs('out/' + dirname(path), exist_ok=True)
        with open(f'out/{path}.json', 'w') as f:
            json.dump(both, f, indent=2)

        command_cnts.append((path, both, comments))

def get_index(item, parens=False):
    quote, compound_quote, bracket, paren, ind = 0, 0, 0, 0, 0
    for n, char in enumerate(item):
        if char == '"' and not compound_quote:
            quote += -1 if quote else 1
        elif char == '`' and not quote:
            compound_quote += 1
        elif char == "'" and not quote:
            compound_quote -= 1
        elif char == '[' and not (quote or compound_quote):
            bracket += 1
        elif char == ']' and not (quote or compound_quote):
            bracket -= 1
        elif char == '(' and not (quote or compound_quote):
            if not paren:
                ind = n
            paren += 1
        elif char == ')' and not (quote or compound_quote):
            paren -= 1
            if not paren and parens:
                return ind, n
        elif char == ',' and not (parens or quote or compound_quote or bracket or paren):
            return n + 1

def get_stats(path):
    datasets = os.listdir(path)
    cnts = {}
    totals = collections.Counter()
    command_cnts = []
    for ds in datasets:
        if sys.argv[3] and sys.argv[3] != ds:
            continue

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
        for path, both, comments in command_cnts:
            obj = dict(path=path, len=len(both), len_comments=len(comments), len_other=0)
            for cat in categories:
                obj[f'len_{cat}'] = 0

            obj['comments'] = []
            obj['other'] = {}
            for cat in categories:
                obj[cat] = {}

            for n, item in enumerate(both): 
                if item in comments:
                    obj['comments'].append(n)
                    continue

                cmd = item.split()[0]
                opt_ind = get_index(item)
                opts = ''
                if not cmd in ('by:', 'sort') and opt_ind:
                    opts = item[opt_ind:].strip()
                    parens = get_index(opts, True)
                    while parens:
                        opts = opts[:parens[0]] + opts[parens[1] + 1:]
                        parens = get_index(opts, True)

                opts = opts.replace('///', '').split()
                other = True
                for cat, cmds in categories.items():
                    if not obj[cat].get('opts'):
                        obj[cat]['opts'] = {}
                    if cmd in cmds:
                        obj[f'len_{cat}'] += 1
                        if not obj[cat].get(cmd):
                            obj[cat][cmd] = []

                        obj[cat][cmd].append(n)
                        for opt in opts:
                            if not obj[cat]['opts'].get(opt):
                                obj[cat]['opts'][opt] = []
                            obj[cat]['opts'][opt].append(n)

                        other = False

                if other:
                    obj['len_other'] += 1
                    if not obj['other'].get(cmd):
                        obj['other'][cmd] = [] 
                    obj['other'][cmd].append(n)

            json.dump({k: v for k, v in obj.items() if v}, f, indent=2)

cmd = {'get_datasets': get_datasets,
       'get_files': get_files,
       'get_downloads': get_downloads,
       'get_stats': get_stats}[sys.argv[1]]
cmd(sys.argv[2])
