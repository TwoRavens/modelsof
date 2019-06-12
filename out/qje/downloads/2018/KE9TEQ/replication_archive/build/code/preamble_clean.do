clear
clear matrix
clear mata
pause off
version 14.2
set logtype text
set more off
set matsize 11000
set maxvar 32767
set seed 30111984
adopath + code/
cap matrix drop _all
cap file close handle
cap log close
set max_memory 120g
