*******************************************************************************
*This program cleans the ACS data and generates the variables used at the 
*simulations at the PUMa level.
********************************************************************************

clear *
set more off 
set matsize 5000
set mem 2000m

cd "XXXX define path to folders XXXX//ACS"

import delimited "Raw data/ACS2015.csv" // This dataset was downloaded from IPUMS. This dataset already restricts to females between 25 and 50 years old.

drop if year<2005 // We don't have information on PUMA before 2005

gen employed= empstat==1
gen l_wage = ln(incwage)


forvalues x=1(1)10 {

	preserve
	keep if inlist(year,2004+`x',2005+`x')

	* Keep only PUMAs with information on both years, to have a balanced panel
	egen year_max=max(year), by(puma)
	egen year_min=min(year), by(puma)

	tab year_max year_min
	keep if year_max==2005+`x' & year_min==2004+`x'

	gen Group=`x'

	gen temp=1
	egen N=sum(temp), by(puma)
	egen N_year=sum(temp), by(puma year)

	keep year perwt employed N  N_* puma Group l_wage 

	save temp`x', replace
	
	restore

}


clear

forvalues x=1(1)10 {

	append using temp`x'

}


egen S = group(Group puma)

forvalues x=1(1)10 {
erase temp`x'.dta
}

rename puma id


* Generate dataset for PUMA level simulations with employed as outcome veriable
preserve

keep if employed!=.
egen P_jt=sum(perwt), by(S year)  // Sum of sampling weights per State x time cell. Important to recover the individual-level estimates

gen omega2=perwt^2

gen M=1

collapse (mean) id P_jt  employed Group (rawsum) M omega2 [pw= perwt], by(S year)

save Final_datasets/PUMA_employed, replace

restore


* Generate dataset for PUMA level simulations with l_wage as outcome veriable
preserve

keep if l_wage!=.
egen P_jt=sum(perwt), by(S year)  // Sum of sampling weights per State x time cell. Important to recover the individual-level estimates

gen omega2=perwt^2

gen M=1

collapse (mean) id P_jt  l_wage Group   (rawsum) M omega2 [pw= perwt], by(S year)


save Final_datasets/PUMA_l_wage, replace

restore


* Generate dataset for individual-level simulations (for rejection rates using cluster-robust s.e.)
preserve

gen M=1

collapse  (rawsum) M, by(S year)

forvalues year=2005(1)2015 {

xtile M_bin2_`year'=M if year==`year', n(10) 

}

egen M_bin2=rowmax(M_bin2_*)

sort S year

save Final_datasets/M_bin_PUMA, replace

restore


merge m:1 S year using Final_datasets/M_bin_PUMA


drop M_bin2_* 

drop _merge 

save Final_datasets/PUMA_individual, replace

