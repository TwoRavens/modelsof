				****** MASTER BRV ******
		
* Prelim: need to create an "Output" folder in the data folder
		
clear all
set more off 
set maxvar  8000 
set matsize 8000

ssc install reghdfe

* Define path here 
global base ""

global Source 		"orig"
global results 		"results"
global Output  		"output"
global Do_files     "final dofiles"
global statdes      "results\statdes"

cd "$base"


** Run Do-Files **

do "$Do_files\1-constructfin.do"
do "$Do_files\2-Figure1.do"
do "$Do_files\3-Table1.do"
do "$Do_files\4-Table2.do"
do "$Do_files\5-Table3.do"
do "$Do_files\6-Table4.do"
do "$Do_files\7-Table5.do"
do "$Do_files\8-Figure2.do"
do "$Do_files\9-Figure3.do"
do "$Do_files\10-results_web_appendix.do"
do "$Do_files\11-TableA18_reconstr.do"
do "$Do_files\12-TableA20_ijtFE.do"





