clear
/* Note: the directory is set in the "Environmental Engel Curves.do" file, which calls on this
	program, and does not need to be set here unless the program is running independently.
	To run this program separetly, be sure to set the directory here." */

	
/* Import CEX mtbi files ICPSR.do
------------------------------------
This program is part of the Environmental Engel Curves project.

The point of this file is to import and clean the CEX microdata mtbi files from ICPSR.  The files are organized
based on quarterly data (the quarter that the survey was administered).

I am focusing on the Quarterly surveys for now.  According to the quick-start guide, the diary datasets cover
	different consumer units, so you can't match across diary and survey

Households are tracked for 5 consecutive quarters and each file contains households (CUs) in all stages of those
5 quarters.

	
NOTE: This file adjusts all figures for inflation (core, energy, gasoline, food, fuel oil).  It adjusts
	quarterly expenditure to annual 2002 dollars.
*/

/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
Specific Oddities about individual files to consider:
-- the 1993 and 1994 rounds do not include Q5.  That means that
	there is no 19941 or 19951 files, only 19941x and 19951x
		-- Run 1994 and 1995 separately and manually change to add "x"
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

/* PART ONE: Import each each individual quarter of data and combine into an 
	"annual" file that contains households that started the survey in a given
	quarter
---------------------------------------------------------------------------*/
/* Compile all of the files*/
foreach yyyy of numlist 1984/1995  {
*local yyyy=1995
di `yyyy'
local zzzz = `yyyy'+1
local yy = substr(string(`yyyy'),3,4)
local zz = substr(string(`zzzz'),3,4)


use "Raw Files from ICPSR\mtbi`yy'1x.dta", clear
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
merge m:1 ucc using "Compiled Data Files\ucc-io concordance.dta", keep(1 3)
drop _merge


/* adjust cost figures for inflation */
merge m:1 quarter year using "Compiled Data Files\quarterly cpi.dta", keep(1 3)
drop _merge
replace cost = cost*190.44/cpi_core if type=="c"
replace cost = cost*176.75/cpi_foodbev if type=="f"
replace cost = cost*115.53/cpi_fuel if type=="o"
replace cost = cost*136.28/cpi_electricity if type=="e"
replace cost = cost*115.97/cpi_gasoline if type=="g"


/* Early files are missing the cuid and interi variables.  Interi is the last digit of newid.  The preceding digits are the cuid.  There
	are supposed to be 7, but there could be 1 (or more) leading zeros */
capture drop cuid interi /* in case the file DOES have cuid, drop it */
tostring newid, replace
gen length = length(newid)
gen cuid = substr(newid,1,(length-1))
gen interi = substr(newid, length, length)
destring interi, replace


/* find the pollution associated with each itemized consumption by multiplying "cost" and the coefficients */
/* Note: coefficient scale is tons per million, so I am dividing by million to get tons per item. */
foreach var of varlist total* {
	replace `var' = `var'*cost/1000000
	}
	

/* Collapse by cuid, quarter, year, interi; to find a file that has unique cuids by quarter/year/interi */
collapse (sum) total*, by(cuid quarter year interi)


/* Create the file of households that started the survey in Q1 */
	preserve
	/* Only keep CU's that started interi==2 in the first quarter */
	keep if (interi==2&quarter==1&year==`yyyy')|(interi==3&quarter==2&year==`yyyy')|(interi==4&quarter==3&year==`yyyy')|(interi==5&quarter==4&year==`yyyy')

	/* Collapse, taking the sum of pollution */
	collapse (sum) total*, by(cuid)
	gen quarter=1
	gen year= `yyyy'
	save "Compiled Data Files\compiledmtbi_`yy'1.dta", replace
	restore

/* Create the file of households that started the survey in Q2 */
	preserve
	/* Only keep CU's that started interi==2 in the second quarter of loop */
	keep if (interi==2&quarter==2&year==`yyyy')|(interi==3&quarter==3&year==`yyyy')|(interi==4&quarter==4&year==`yyyy')|(interi==5&quarter==1&year==`zzzz')

	/* Collapse, taking the sum of pollution */
	collapse (sum) total*, by(cuid)
	gen quarter=2
	gen year= `yyyy'
	save "Compiled Data Files\compiledmtbi_`yy'2.dta", replace
	restore
	
/* Create the file of households that started the survey in Q3 */
	preserve
	/* Only keep CU's that started interi==2 in the third quarter of loop */
	keep if (interi==2&quarter==3&year==`yyyy')|(interi==3&quarter==4&year==`yyyy')|(interi==4&quarter==1&year==`zzzz')|(interi==5&quarter==2&year==`zzzz')
	
	/* Collapse, taking the sum of pollution */
	collapse (sum) total*, by(cuid)
	gen quarter=3
	gen year= `yyyy'
	save "Compiled Data Files\compiledmtbi_`yy'3.dta", replace
	restore
	
/* Create the file of households that started the survey in Q4 */
	preserve
	/* Only keep CU's that started interi==2 in the fourth quarter of loop */
	keep if (interi==2&quarter==4&year==`yyyy')|(interi==3&quarter==1&year==`zzzz')|(interi==4&quarter==2&year==`zzzz')|(interi==5&quarter==3&year==`zzzz')
	
	/* Collapse, taking the sum of pollution */
	collapse (sum) total*, by(cuid)
	gen quarter=4
	gen year= `yyyy'
	save "Compiled Data Files\compiledmtbi_`yy'4.dta", replace
	restore
	
}


/* PART TWO: stack them all together into a single file
------------------------------------------------------------*/
/* Now stack them all together into a single file */
foreach yyyy of numlist 1984/1995 {
*local yyyy = 1996
di `yyyy'
local yy = substr(string(`yyyy'),3,4)
	
	foreach q of numlist 1/4 { /*loop over quarters within each year */
		*local q = 2
		if `yyyy'==1984 & `q'==1 {
		use "Compiled Data Files\compiledmtbi_`yy'`q'.dta", clear
		*di "`yy' `q' test if" 
		}
		else {		
		*di "`yy' `q' test else"
		append using "Compiled Data Files\compiledmtbi_`yy'`q'.dta"
		}
	}
	
}
/* note cuid is *NOT* a unique identifier */
save "Compiled Data Files\ICPSR_compiledmtbi_all.dta", replace	





