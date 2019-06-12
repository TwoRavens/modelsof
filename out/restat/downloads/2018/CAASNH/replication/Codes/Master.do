******
*Master file to build data and run relevant charts
******

clear all
set more off
global datadir	"/Users/jcravino/Documents/replication"

*Run do-files that prepare the data
do "$datadir/Codes/WDI.do"
do "$datadir/Codes/PWT.do"
do "$datadir/Codes/ICIO.do"
do "$datadir/Codes/ICP.do"
do "$datadir/Codes/Data_Merge.do"
do "$datadir/Codes/Figures.do"
do "$datadir/Codes/Table1.do"
do "$datadir/Codes/Fig_3.do"
