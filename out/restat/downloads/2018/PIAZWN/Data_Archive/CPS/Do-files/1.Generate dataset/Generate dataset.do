**************************************************************************
**Using the raw data extracted from the CPS, this program cleans the data*
** and generates the data used in the simulations.
**************************************************************************




set more off
clear


cd "XXXX define path to folders XXXX/CPS"

foreach x in 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 {

import delimited "Raw data/morg`x'.csv", clear // Dataset already restricted to females between 25 and 50 years old.

keep if minsamp==4

cap gen employed=lfsr94==1
cap gen employed=lfsr89==1
cap gen employed=esr==1


cap gen high_school=gradeat>=12 & gradeat!=.
cap gen high_school =grade92>=39 & grade92!=.


replace  earnwke=0 if earnwke==.

keep employed state weight year earnwke age high_school

drop if state==.

save "temp/`x'.dta", replace

}

*In 2014 the variable "state" is incomplete, then we will merge 2014 data set with 2013 just to recode "state" variable

import delimited "Raw data/morg13.csv", clear


keep if minsamp==4
keep if sex==2
keep if age>=25 & age<=50

cap gen employed=lfsr94==1
cap gen employed=lfsr89==1
cap gen employed=esr==1


cap gen high_school=gradeat>=12 & gradeat!=.
cap gen high_school =grade92>=39 & grade92!=.


replace  earnwke=0 if earnwke==.

keep employed state weight year earnwke age high_school stfips

drop if state==.

save "temp/13.dta", replace

keep state stfips
duplicates drop

save "temp/state_codes_key.dta", replace



import delimited "Raw data/morg14.csv", clear

keep if minsamp==4
keep if sex==2
keep if age>=25 & age<=50

cap gen employed=lfsr94==1
cap gen employed=lfsr89==1
cap gen employed=esr==1

cap gen high_school=gradeat>=12 & gradeat!=.
cap gen high_school =grade92>=39 & grade92!=.

replace  earnwke=0 if earnwke==.

keep employed state weight year earnwke age high_school stfips

drop state 

merge m:1 stfips using "temp/state_codes_key.dta", nogenerate

drop if state==.

save "temp/14.dta", replace



import delimited "Raw data/morg15.csv", clear

keep if minsamp==4
keep if sex==2
keep if age>=25 & age<=50

cap gen employed=lfsr94==1
cap gen employed=lfsr89==1
cap gen employed=esr==1

cap gen high_school=gradeat>=12 & gradeat!=.
cap gen high_school =grade92>=39 & grade92!=.

replace  earnwke=0 if earnwke==.

keep employed weight year earnwke age high_school stfips

merge m:1 stfips using "temp/state_codes_key.dta", nogenerate

drop if state==.

save "temp/15.dta", replace




clear

foreach x in 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15  {


	append using "temp/`x'.dta"
}

drop stfips 

gen temp1=1
egen N_year=sum(temp1), by(state year)

gen l_wages = ln(earnwke)

gen temp2=1 if l_wages!=.
egen N_year_wages=sum(temp2), by(state year)


save "Final Dataset/CPS.dta", replace


use "Final Dataset/CPS.dta", clear

gen M=1

collapse (sum) M , by(state year)


gen M_bin2_OLS=.

forvalues x=1979(1)2015 {

	xtile M_bin2_`x' = M  if year==`x' , n(2) 
	
	replace M_bin2_OLS=M_bin2_`x'   if year==`x'
	

}

keep state year M_bin*OLS
sort state year

save "Final Dataset/M_bin.dta", replace

