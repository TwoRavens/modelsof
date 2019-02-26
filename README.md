# modelsof

## stats.json counts

The first item is a count of regression commands in all files. Given two commands:

    svy: reg ...
    reg ...

the count will be:

    svy:reg = 1
    reg = 1

The remaining items (counts per file) count prefix and "command" (regression or otherwise) separately.

## notes

    python3 stata.py * unzip

is destructive (it destroys zip files as it unzips) and may need to be run several times to get deeply nested zips.

unzip also requires 7z for 7z and rar files. This is `p7zip-full` and `p7zip-rar` on Ubuntu.
