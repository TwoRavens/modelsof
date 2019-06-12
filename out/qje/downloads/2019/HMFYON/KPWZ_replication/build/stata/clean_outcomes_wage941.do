
*******************************************************************************
*******************************************************************************
* BUILD WAGE OUTCOMES
*******************************************************************************
*******************************************************************************
set more off
clear 
set maxvar 8000
set seed 12345
*******************************************************************************
*0.1 Append all years of data (that have been matched to the spine already)
*******************************************************************************
clear
forv y = 2001/2018{
append using $dumpdir/patent_eins_941_`y'.dta 
}

*******************************************************************************
*1.1 LOAD WAGE DATA
*******************************************************************************

duplicates drop
keep unmasked_tin year quarter totcomp employes

rename employes emp

replace quarter=1 if quarter==3
replace quarter=2 if quarter==6
replace quarter=3 if quarter==9
replace quarter=4 if quarter==12

drop if unmasked_tin==.

*******************************************************************************
* 2. WINZORIZE output vars
*******************************************************************************

*******************************************************************************
* 3. Adjust for Inflation
*******************************************************************************
usd2014, var(totcomp) yr(year) 


*******************************************************************************
* 4.1 clean up 
*******************************************************************************
g wage = totcomp/emp

replace totcomp = . if emp ==.
rename totcomp wb


gsort unmasked_tin year quarter -wb
egen tag= tag(unmasked_tin year quarter)

*tab tag if !mi(wage)
keep if tag==1
drop tag

reshape wide wb emp wage, i(unmasked_tin year) j(quarter)

rename wb1 wb_1st
rename wb2 wb_2nd
rename wb3 wb_3rd
rename wb4 wb_4th

rename wage1 wage_1st
rename wage2 wage_2nd
rename wage3 wage_3rd
rename wage4 wage_4th

rename emp1 emp_1st
rename  emp2 emp_2nd
rename  emp3 emp_3rd
rename  emp4 emp_4th
*******************************************************************************
* 4.2 SAVE Data
*******************************************************************************
*do xp_f941.do
keep if year>=2002

*drop emp*
*drop wb*
g form="941"
sort unmasked_tin year
save $dtadir/outcomes_patent_wage941.dta, replace
