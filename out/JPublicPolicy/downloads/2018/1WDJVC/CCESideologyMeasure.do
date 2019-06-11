*Code to measure public ideology by state in 2014.*

*set working directory
cd /Volumes/MONOGAN/immigration/demDef/cces/FullModule/

*allow continuous scroll
set more off

*UNWEIGHTED MEASURE*
use CCES14_Common_OUTPUT_subset.dta, clear
keep weight inputstate CC334A
recode CC334A 8=.
recode CC334A 1/3=1 4=0 5/7=-1
sort inputstate 
collapse CC334A, by(inputstate) 
replace CC334A=CC334A*100
list

*WEIGHTED MEASURE*
use CCES14_Common_OUTPUT_subset.dta, clear
keep weight inputstate CC334A
recode CC334A 8=.
recode CC334A 1/3=1 4=0 5/7=-1
sort inputstate 
collapse CC334A [pweight=weight], by(inputstate) 
replace CC334A=CC334A*100
list