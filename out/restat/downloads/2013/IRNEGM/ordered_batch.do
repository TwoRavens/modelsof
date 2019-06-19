local root_dir "F:\NETSData2007\Generated_files\SB05"

set mem 1g
set more off

foreach version in 1a 1b 1c 1d 2d {
do `root_dir'\sb05_usa_copy`version'.do
}

