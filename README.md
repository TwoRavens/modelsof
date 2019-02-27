# modelsof

## stats.json counts

The first item is a count of regression commands in all files. Given two commands:

    svy: reg ...
    reg ...

the count will be:

    svy:reg = 1
    reg = 1

The remaining items (counts per file) count prefix and "command" (regression or otherwise) separately except for the 'regressions' key, which works the same as the previous section.

## notes

### unzip

    python3 stata.py * unzip

is destructive (it destroys zip files as it unzips) and may need to be run several times to get deeply nested zips.

unzip also requires 7z for 7z and rar files. This is `p7zip-full` and `p7zip-rar` on Ubuntu.

### errors

Some files have syntax errors. In the case of missing closing delimiters, they are closed. In the case of missing closing `*/`, the comment is assumed to extend  to the end of the file.
