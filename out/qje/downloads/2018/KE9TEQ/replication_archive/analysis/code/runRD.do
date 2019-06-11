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
***		"RD ANALYSIS"
***
**********************************************************/


* create figures
do $PATHcode/figure2.do
do $PATHcode/figure3.do
do $PATHcode/figure5.do
do $PATHcode/figure6.do

do $PATHcode/figureA11.do
do $PATHcode/figureA12.do

* create tables
do $PATHcode/table8.do
do $PATHcode/table9.do
do $PATHcode/table10.do

do $PATHcode/tableA22.do 
do $PATHcode/tableA23.do
do $PATHcode/tableA24.do
do $PATHcode/tableA13.do
do $PATHcode/tableA14.do
do $PATHcode/tableA15.do
do $PATHcode/tableA16.do
do $PATHcode/tableA18.do
do $PATHcode/tableA19.do
do $PATHcode/tableA20.do 
do $PATHcode/tableA21.do
do $PATHcode/tableA17.do
do $PATHcode/tableA25.do 
do $PATHcode/tableA26.do
do $PATHcode/tableA27.do
do $PATHcode/tableA28.do
do $PATHcode/tableA29.do

* run do-files for CV on some server and uncomment next line
*do $PATHcode/fillCV.do







exit
