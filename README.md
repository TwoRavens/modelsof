# modelsof

1. `python3 modelsof.py jop get_datasets`

Scrapes Dataverse for all articles. Produces `out/jop/datasets.csv` with `title, href, date`.

2. `python3 modelsof.py jop get_files`

Scrapes Dataverse for all files associated with each article in `datasets.csv`. Produces `out/jop/files.csv` with `title, href, date, filename, file_href`.

3. `python3 modelsof.py jop get_downloads [2018]`

Downloads all files with ext of `.do .7z .7zip .gz .rar .tar .zip` in `files.csv` optionally limited by year. Produces `out/jop/downloads/{year}/{journal}/{file}`. Errors logged to `out/jop/downloads/errors.csv` with `title, href, date, filename, file_href, error`.

4. `python3 modelsof.py jop unzip` 

Recursively unzips all files with ext of `.7z .7zip .gz .rar .tar .zip` in `downloads`. Is destructive (it destroys zip files as it unzips) and requires 7z for 7z and rar files. This is `p7zip-full` and `p7zip-rar` on Ubuntu.

5. `python3 modelsof.py jop get_all_files`

Intersection of `files.csv` and files in `downloads`. Produces `out/jop/all_files.csv` with `file`.

# stats.json counts

Some prefix commands are run in isolation (not as a prefix). they are counted as `len_prefix`. Those prefix commands that are used as a prefix to another command are counted as `len_prefix_as_prefix`. The latter do not show up in overall counts (`len`).

The first item is a count of regression commands in all files. Given two commands:

    svy: reg ...
    reg ...

the count will be:

    svy:reg = 1
    reg = 1

The remaining items (counts per file) count prefix and "command" (regression or otherwise) separately except for the 'regressions' key, which works the same as the previous section.

### errors

Some files have syntax errors. In the case of missing closing delimiters, they are closed. In the case of missing closing `*/`, the comment is assumed to extend  to the end of the file.
