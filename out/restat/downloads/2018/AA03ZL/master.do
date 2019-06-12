*"When it Rains it Pours" Replication
*Set working directory, where all replication do-files and included datasets are currently located
global path " "
cd "$path"

*Fill in the name of the downloaded IPUMS census file
global censusfile " "

set matsize 5000

do "census_collapsed.do"
do "gen_file.do"
do "tables.do"
do "graphs.do"
