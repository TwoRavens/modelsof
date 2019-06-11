capture log close

* installs/updates all required ado-files
foreach ado in texdoc fre estout ///
	rrreg rrlogit estwrite erepost ///
	coefplot addplot moremata {
	ssc install `ado', replace
}
net install sjlatex, from(http://www.stata-journal.com/production)

* change to the working directory
qui cd "[directory with do-files and data]"

version 13.1
discard
clear all
set linesize 100
set type double
set more off

capt mkdir log

texdoc do ORGDONpa-1-main-analysis.do, init(ORGDONpa-1-main-analysis) prefix(log/main) replace

clear all
texdoc do ORGDONpa-2-extended-analysis.do, init(ORGDONpa-2-extended-analysis) prefix(log/extended) replace

clear all
texdoc do ORGDONpa-3-graphs-and-tables.do, init(ORGDONpa-3-graphs-and-tables) prefix(log/graphs-and-tables) replace

graph close _all
exit
