clear
set mem 900m


global n_states "01 02 04 05 06 08 09 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56"
*global n_states "01"


cd "C:\Users\HW462587\Documents\Leah\STF 3A\1990"

foreach i in $n_states   {
infile using "C:\Users\HW462587\Documents\Leah\STF 3A\1990\dictionary.dct", using("C:\Users\HW462587\Documents\Leah\STF 3A\1990\10223923\10223923\ICPSR_09782\DS00`i'\09782-00`i'-Data.txt")

* Replace 'X' with the name of the dictionary file. 
*
* The contents of the dictionary are given at the end of this file.
* Put the dictionary into a separate file (by editing this file).
* Then specify here the name of the dictionary file.
*******************************************************************
* The md, min and max specifications were translated 
* into the following "REPLACE...IF" statements:

keep if SUMLEV=="160"
compress
save median_income1990_`i', replace
drop _all

}


use median_income1990_01
global n_states1 "02 04 05 06 08 09 10 11 12 13 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56"

foreach i in $n_states1    {
append using median_income1990_`i'
keep state census median_income median_housev

}

gen year=1989
destring, replace
keep median_income median_housev year state census
compress
sort state census
save median_income, replace
