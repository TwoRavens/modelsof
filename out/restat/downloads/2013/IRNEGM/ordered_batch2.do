local root_dir "F:\NETSData2007\Generated_files\SB05"

set mem 1g
set more off

foreach version in 4b 4c {
do `root_dir'\sb05_usa_copy`version'.do
}

