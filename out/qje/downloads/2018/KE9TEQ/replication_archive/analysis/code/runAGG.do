/*
** last changes: August 2017  by: J. Spenkuch (j-spenkuch@kellogg.northwestern.edu)
*/
if c(os) == "Unix" {
	global PATH "/projects/p30061"
	global PATHdata "/projects/p30061/data"
	global PATHcode "/projects/p30061/code"
	global PATHlogs "/projects/p30061/logs"
	
	cd $PATH
}
else if c(os) == "Windows" {
	global PATH "R:/Dropbox/research/advertising_paper/analysis"
	global PATHdata "R:/Dropbox/research/advertising_paper/analysis/input"
	global PATHcode "R:/Dropbox/research/advertising_paper/analysis/code"
	global PATHlogs "R:/Dropbox/research/advertising_paper/output"
	
	cd $PATH
}
else {
    display "unable to recognize OS -> abort!"
    exit
}


/**********************************************************
***
***		"COUNTY-LEVEL ANALYSIS"
***
**********************************************************/


* create tables
do $PATHcode/table1.do
do $PATHcode/table2.do
do $PATHcode/table3_A8.do
do $PATHcode/table4_A10.do
do $PATHcode/table5.do
do $PATHcode/table6.do
do $PATHcode/table7.do

do $PATHcode/tableA1.do
do $PATHcode/tableA2.do
do $PATHcode/tableA3.do
do $PATHcode/tableA4.do
do $PATHcode/tableA5.do
do $PATHcode/tableA6.do
do $PATHcode/tableA7.do
do $PATHcode/tableA9.do
do $PATHcode/tableA11.do
do $PATHcode/tableA12.do

* create figures
do $PATHcode/figureA4.do
do $PATHcode/figureA5.do
do $PATHcode/figureA6.do
do $PATHcode/figureA7.do
do $PATHcode/figureA8.do
do $PATHcode/figureA9.do
do $PATHcode/figureA10.do

* persuasion rates
do $PATHcode/persuasion_rates.do



exit
