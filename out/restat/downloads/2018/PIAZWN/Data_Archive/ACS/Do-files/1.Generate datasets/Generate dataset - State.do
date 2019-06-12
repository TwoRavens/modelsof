*************************************************************************
*This program cleans the ACS data and generates the variables used at the 
*simulations at the PUMa level.
**************************************************************************
clear *
set more off 
set matsize 5000
set mem 2000m

cd "XXXX define path to folders XXXX/ACS"

import delimited "Raw data/ACS2015.csv" // This dataset was downloaded from IPUMS. This dataset already restricts to females between 25 and 50 years old.


gen employed= empstat==1
gen l_wage = ln(incwage)


forvalues x=1(1)15 {

	preserve
	keep if inlist(year,1999+`x',2000+`x')

	gen Group=`x'

	keep year perwt employed  stateic Group l_wage 

	save temp`x', replace
	
	restore

}


clear

forvalues x=1(1)15 {

	append using temp`x'

}


egen S = group(Group stateic)

forvalues x=1(1)15 {
erase temp`x'.dta
}

rename stateic id

* Generate dataset for state-level simulations, using employed as outcome variable
preserve

keep if employed!=.
egen P_jt=sum(perwt), by(S year)  // Sum of sampling weights per State x time cell. Important to recover the individual-level estimates

gen omega2=perwt^2

gen M=1

collapse (mean) id P_jt  employed Group  (rawsum) M omega2 [pw= perwt], by(S year)

save Final_datasets/State_employed, replace

restore


* Generate dataset for state-level simulations, using log wages as outcome variable
preserve

keep if l_wage!=.
egen P_jt=sum(perwt), by(S year)  // Sum of sampling weights per State x time cell. Important to recover the individual-level estimates

gen omega2=perwt^2

gen M=1

collapse (mean) id P_jt  l_wage Group (rawsum) M omega2 [pw= perwt], by(S year)


save Final_datasets/State_l_wage, replace

restore


* Generate dataset for individual-level simulations (for rejection rates using cluster-robust s.e.)
preserve

gen M=1

collapse  (rawsum) M, by(S year)

forvalues year=2000(1)2015 {

xtile M_bin2_`year'=M if year==`year', n(2) 

}

egen M_bin2=rowmax(M_bin2_*)

sort S year

save Final_datasets/M_bin_State, replace

restore


merge m:1 S year using Final_datasets/M_bin_State


drop M_bin2_* 

drop _merge 

save Final_datasets/State_individual, replace



