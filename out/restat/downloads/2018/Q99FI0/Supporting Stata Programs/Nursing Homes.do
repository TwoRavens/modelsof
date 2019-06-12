clear

/* Note: the directory is set in the "Environmental Engel Curves.do" file, which calls on this
	program, and does not need to be set here unless the program is running independently.
	To run this program separetly, be sure to set the directory here." */

	
/* Nursing Homes.do
This program creates a list of households in the CEX that have any expenditure
on nursing homes. NOTE: This file adjusts all figures for inflation from
quarterly level to annual 2002 dollars.
*/



/* Compiling the CEX MTBI data from BLS: 1996-2012 */
/* Compile all of the files*/
foreach yyyy of numlist 1996(1)2012 {
*local yyyy=1996
di `yyyy'
local zzzz = `yyyy'+1
local yy = substr(string(`yyyy'),3,4)
local zz = substr(string(`zzzz'),3,4)


use "Raw Files from BLS/mtbi`yy'1x.dta", clear
gen bls_year = `yyyy'
gen quarter = 1
append using "Raw Files from BLS/mtbi`yy'2.dta"
replace bls_year = `yyyy' if bls_year==.
replace quarter = 2 if quarter==.
append using "Raw Files from BLS/mtbi`yy'3.dta"
replace bls_year = `yyyy' if bls_year==.
replace quarter = 3 if quarter==.
append using "Raw Files from BLS/mtbi`yy'4.dta"
replace bls_year = `yyyy' if bls_year==.
replace quarter = 4 if quarter==.
append using "Raw Files from BLS/mtbi`zz'1.dta"
replace bls_year = `zzzz' if bls_year==.
replace quarter = 1 if quarter==.
append using "Raw Files from BLS/mtbi`zz'2.dta"
replace bls_year = `zzzz' if bls_year==.
replace quarter = 2 if quarter==.
append using "Raw Files from BLS/mtbi`zz'3.dta"
replace bls_year = `zzzz' if bls_year==.
replace quarter = 3 if quarter==.

rename bls_year year
collapse (sum) cost, by(quarter year newid ucc)


/* merge in the IO-level pollution coefficients*/
merge m:1 ucc using "Compiled Data Files/ucc-io concordance.dta", keep(1 3)
drop _merge

/* Only keep nursing home expenditure */
keep if iocode=="623000"


/* adjust cost figures for inflation */
merge m:1 quarter year using "Compiled Data Files/quarterly cpi.dta", keep(1 3)
drop _merge
replace cost = cost*169.5083/cpi_core


/* Early files are missing the cuid nad interi variables.  Interi is the last digit of newid.  The preceding digits are the cuid.  There
	are supposed to be 7, but there could be 1 (or more) leading zeros */
capture drop cuid interi /* in case the file DOES have cuid, drop it */
tostring newid, replace
gen length = length(newid)
gen cuid = substr(newid,1,(length-1))
gen interi = substr(newid, length, length)
destring interi, replace


/* Create the file of households that started the survey in Q1 */
	preserve
	/* Only keep CU's that started interi==2 in the first quarter */
	keep if (interi==2&quarter==1&year==`yyyy')|(interi==3&quarter==2&year==`yyyy')|(interi==4&quarter==3&year==`yyyy')|(interi==5&quarter==4&year==`yyyy')

	/* Collapse, taking the sum of pollution */
	collapse (sum) cost, by(cuid)
	gen quarter=1
	gen year= `yyyy'
	save "Compiled Data Files/nursing_`yy'1.dta", replace
	restore


/* Create the file of households that started the survey in Q2 */
	preserve
	/* Only keep CU's that started interi==2 in the second quarter of loop */
	keep if (interi==2&quarter==2&year==`yyyy')|(interi==3&quarter==3&year==`yyyy')|(interi==4&quarter==4&year==`yyyy')|(interi==5&quarter==1&year==`zzzz')

	/* Collapse, taking the sum of pollution */
	collapse (sum) cost, by(cuid)
	gen quarter=2
	gen year= `yyyy'
	save "Compiled Data Files/nursing_`yy'2.dta", replace
	restore
	
/* Create the file of households that started the survey in Q3 */
	preserve
	/* Only keep CU's that started interi==2 in the third quarter of loop */
	keep if (interi==2&quarter==3&year==`yyyy')|(interi==3&quarter==4&year==`yyyy')|(interi==4&quarter==1&year==`zzzz')|(interi==5&quarter==2&year==`zzzz')
	
	/* Collapse, taking the sum of pollution */
	collapse (sum) cost, by(cuid)
	gen quarter=3
	gen year= `yyyy'
	save "Compiled Data Files/nursing_`yy'3.dta", replace
	restore
	
/* Create the file of households that started the survey in Q4 */
	preserve
	/* Only keep CU's that started interi==2 in the fourth quarter of loop */
	keep if (interi==2&quarter==4&year==`yyyy')|(interi==3&quarter==1&year==`zzzz')|(interi==4&quarter==2&year==`zzzz')|(interi==5&quarter==3&year==`zzzz')
	
	/* Collapse, taking the sum of pollution */
	collapse (sum) cost, by(cuid)
	gen quarter=4
	gen year= `yyyy'
	save "Compiled Data Files/nursing_`yy'4.dta", replace
	restore
	
}


/* stack all the individual year/quarter files together
------------------------------------------------------------*/
/* Now stack them all together into a single file */
foreach yyyy of numlist 1996/2012 {
*local yyyy = 1996
di `yyyy'
local yy = substr(string(`yyyy'),3,4)
	
	foreach q of numlist 1/4 { /*loop over quarters within each year */
		*local q = 2
		if `yyyy'==1996 & `q'==1 {
		use "Compiled Data Files\nursing_`yy'`q'.dta", clear
		*di "`yy' `q' test if" 
		}
		else {		
		*di "`yy' `q' test else"
		append using "Compiled Data Files\nursing_`yy'`q'.dta"
		}
	}
	
}

/* note cuid is *NOT* a unique identifier */
rename cost nursingcost
save "Compiled Data Files\BLS_nursing_all.dta", replace


/* Compiling the CEX MTBI data from ICPSR: 1984-1995

Specific Oddities about individual files to consider:
-- the 1993 and 1994 rounds do not include Q5.  That means that
	there is no 19941 or 19951 files, only 19941x and 19951x
*/


/* Compile all of the files*/
foreach yyyy of numlist 1984/1995  {
*local yyyy=1984
di `yyyy'
local zzzz = `yyyy'+1
local yy = substr(string(`yyyy'),3,4)
local zz = substr(string(`zzzz'),3,4)


use "Raw Files from ICPSR/mtbi`yy'1x.dta", clear
gen bls_year = `yyyy'
gen quarter = 1
append using "Raw Files from ICPSR/mtbi`yy'2.dta"
replace bls_year = `yyyy' if bls_year==.
replace quarter = 2 if quarter==.
append using "Raw Files from ICPSR/mtbi`yy'3.dta"
replace bls_year = `yyyy' if bls_year==.
replace quarter = 3 if quarter==.
append using "Raw Files from ICPSR/mtbi`yy'4.dta"
replace bls_year = `yyyy' if bls_year==.
replace quarter = 4 if quarter==.
 if `yyyy'==1993|`yyyy'==1994 {
	append using "Raw Files from ICPSR/mtbi`zz'1x.dta"
	}
 else {
	append using "Raw Files from ICPSR/mtbi`zz'1.dta"
	}
replace bls_year = `zzzz' if bls_year==.
replace quarter = 1 if quarter==.
append using "Raw Files from ICPSR/mtbi`zz'2.dta"
replace bls_year = `zzzz' if bls_year==.
replace quarter = 2 if quarter==.
append using "Raw Files from ICPSR/mtbi`zz'3.dta"
replace bls_year = `zzzz' if bls_year==.
replace quarter = 3 if quarter==.

rename bls_year year
collapse (sum) cost, by(quarter year newid ucc)


/* merge in the IO-level pollution coefficients*/
merge m:1 ucc using "Compiled Data Files/ucc-io concordance.dta", keep(1 3)
drop _merge

/* Only keep nursing home expenditure */
keep if iocode=="623000"


/* adjust cost figures for inflation */
merge m:1 quarter year using "Compiled Data Files/quarterly cpi.dta", keep(1 3)
drop _merge
replace cost = cost*169.5083/cpi_core


/* Early files are missing the cuid nad interi variables.  Interi is the last digit of newid.  The preceding digits are the cuid.  There
	are supposed to be 7, but there could be 1 (or more) leading zeros */
capture drop cuid interi /* in case the file DOES have cuid, drop it */
tostring newid, replace
gen length = length(newid)
gen cuid = substr(newid,1,(length-1))
gen interi = substr(newid, length, length)
destring interi, replace


/* Create the file of households that started the survey in Q1 */
	preserve
	/* Only keep CU's that started interi==2 in the first quarter */
	keep if (interi==2&quarter==1&year==`yyyy')|(interi==3&quarter==2&year==`yyyy')|(interi==4&quarter==3&year==`yyyy')|(interi==5&quarter==4&year==`yyyy')

	/* Collapse, taking the sum of pollution */
	collapse (sum) cost, by(cuid)
	gen quarter=1
	gen year= `yyyy'
	save "Compiled Data Files/nursing_`yy'1.dta", replace
	restore

/* Create the file of households that started the survey in Q2 */
	preserve
	/* Only keep CU's that started interi==2 in the second quarter of loop */
	keep if (interi==2&quarter==2&year==`yyyy')|(interi==3&quarter==3&year==`yyyy')|(interi==4&quarter==4&year==`yyyy')|(interi==5&quarter==1&year==`zzzz')

	/* Collapse, taking the sum of pollution */
	collapse (sum) cost, by(cuid)
	gen quarter=2
	gen year= `yyyy'
	save "Compiled Data Files/nursing_`yy'2.dta", replace
	restore
	
/* Create the file of households that started the survey in Q3 */
	preserve
	/* Only keep CU's that started interi==2 in the third quarter of loop */
	keep if (interi==2&quarter==3&year==`yyyy')|(interi==3&quarter==4&year==`yyyy')|(interi==4&quarter==1&year==`zzzz')|(interi==5&quarter==2&year==`zzzz')
	
	/* Collapse, taking the sum of pollution */
	collapse (sum) cost, by(cuid)
	gen quarter=3
	gen year= `yyyy'
	save "Compiled Data Files/nursing_`yy'3.dta", replace
	restore
	
/* Create the file of households that started the survey in Q4 */
	preserve
	/* Only keep CU's that started interi==2 in the fourth quarter of loop */
	keep if (interi==2&quarter==4&year==`yyyy')|(interi==3&quarter==1&year==`zzzz')|(interi==4&quarter==2&year==`zzzz')|(interi==5&quarter==3&year==`zzzz')
	
	/* Collapse, taking the sum of pollution */
	collapse (sum) cost, by(cuid)
	gen quarter=4
	gen year= `yyyy'
	save "Compiled Data Files/nursing_`yy'4.dta", replace
	restore
	
}


/* stack all the individual quarter/year files together
------------------------------------------------------------*/
/* Now stack them all together into a single file */
foreach yyyy of numlist 1984/1995 {
*local yyyy=1984
di `yyyy'
local yy = substr(string(`yyyy'),3,4)
	
	foreach q of numlist 1/4 { /*loop over quarters within each year */
		*local q = 2
		if `yyyy'==1984 & `q'==1 {
		use "Compiled Data Files\nursing_`yy'`q'.dta", clear
		*di "`yy' `q' test if" 
		}
		else {		
		*di "`yy' `q' test else"
		append using "Compiled Data Files\nursing_`yy'`q'.dta"
		}
	}
	
}

/* note cuid is *NOT* a unique identifier */
rename cost nursingcost
save "Compiled Data Files\ICPSR_nursing_all.dta", replace	

/* combine the ICPSR and the BLS data */
append using "Compiled Data Files\BLS_nursing_all.dta"
save "Compiled Data Files\combined_nursing_all.dta", replace
