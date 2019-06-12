clear
/* Note: the directory is set in the "Environmental Engel Curves.do" file, which calls on this
	program, and does not need to be set here unless the program is running independently.
	To run this program separetly, be sure to set the directory here." */


/* Import CEX fmly files BLS.do
---------------------------------
This program is part of the Enviromental Engel Curves project.

The point of this file is to import and clean the CEX microdata fmly files from ICPSR.  The files are organized
based on quarterly data (the quarter that the survey was administered).

I am focusing on the Surveys for now.  According to the quick-start guide, the diary datasets cover
	different consumer units, so you can't match across diary and survey

Households are tracked for 5 consecutive quarters and each file contains households (CUs) in all stages of those
5 quarters.

Surveys Q2-Q5 have expenditure information.  The relevant income information comes from the Q5 survey.  In these data,
	Q2 is the first survey available, which is good.

	
NOTE: This file adjusts dollar values of income and total expenditure for inflation, to annual 2002 dollars. 
	
*/


/* PART ONE: Import each each individual quarter of data and combine into an 
	"annual" file that contains households that started the survey in a given
	quarter
---------------------------------------------------------------------------*/
foreach yyyy of numlist 1996/2012 {
*local yyyy = 1996
di `yyyy'
local zzzz = `yyyy'+1
local yy = substr(string(`yyyy'),3,4)
local zz = substr(string(`zzzz'),3,4)

/* Append all files together */
/* Note: in this case quarter and year refer to the survey file, not necessarily the exact date of the survey */
use "Raw Files from BLS\fmli`yy'1x.dta", clear
gen year = `yyyy' 
gen quarter = 1
append using "Raw Files from BLS\fmli`yy'2.dta"
replace year = `yyyy' if year==.
replace quarter = 2 if quarter==.
append using "Raw Files from BLS\fmli`yy'3.dta"
replace year = `yyyy' if year==.
replace quarter = 3 if quarter==.
append using "Raw Files from BLS\fmli`yy'4.dta"
replace year = `yyyy' if year==.
replace quarter =4 if quarter==.
append using "Raw Files from BLS\fmli`zz'1.dta"
replace year = `zzzz' if year==.
replace quarter =1 if quarter==.
append using "Raw Files from BLS\fmli`zz'2.dta"
replace year = `zzzz' if year==.
replace quarter =2 if quarter==.
append using "Raw Files from BLS\fmli`zz'3.dta"
replace year = `zzzz' if year==.
replace quarter =3 if quarter==.


/* Early files are missing the cuid and interi variables.  Interi is the last digit of newid.  The preceding digits are the cuid.  There
	are supposed to be 7, but there could be 1 (or more) leading zeros */
capture drop cuid interi /* in case the file DOES have cuid, drop it */
tostring newid, replace
gen length = length(newid)
gen cuid = substr(newid,1,(length-1))
gen interi = substr(newid, length, length)
destring interi, replace


/* In some files, fincatax is actually called fincatxm. Likewise for fincbtax */
capture gen fincatax=.
capture replace fincatax = fincatxm if fincatax==.
capture gen fincbtax=.
capture replace fincbtax = fincbtxm if fincbtax==.
capture gen tottxpdx=.
capture replace tottxpdx = tottxpdm if tottxpdx==.


/* Create an indicator for fullyr (i.e. all four interviews completed) */
bysort cuid: gen num_inter = _N
gen fullyr = num_inter==4

/* Clean demographic variables in preparation for collapse */
gen urban = (bls_urbn=="1")
destring respstat cutenure state region educ_ref educa2 marital1 ref_race sex_ref /*high_edu*/ , replace

/* Adjust for inflation (quarterly) */
/* Note: the annual cpi-u in 1997 was 179.867 */
merge m:1 year quarter using "Compiled Data Files\quarterly cpi.dta", keep(1 3)
/* Note: this file was created in the "Import CEX fmly files ICPSR.do" program */
drop _merge

replace fincbtax = fincbtax*179.867/cpi_all
replace fincatax = fincatax*179.867/cpi_all
replace tottxpdx = tottxpdx*179.867/cpi_all
replace totexppq = totexppq*179.867/cpi_all
replace totexpcq = totexpcq*179.867/cpi_all
gen totexp = totexppq+totexpcq



/* Create the file of households that started the survey in Q1 */
	preserve
	/* Only keep CU's that started interi==2 in the first quarter of loop */
	keep if (interi==2&quarter==1&year==`yyyy')|(interi==3&quarter==2&year==`yyyy')|(interi==4&quarter==3&year==`yyyy')|(interi==5&quarter==4&year==`yyyy')

	/* Collapse, keeping the important demographic variables */
	sort cuid interi
	local collapse_vars (mean) age_ref age2 fam_size num_auto perslt18 persot64 bathrmq bedroomq num_inter (max) fullyr interi urban respstat /*
		*/ (lastnm) cutenure state region educ_ref educa2 marital1 ref_race sex_ref /*high_edu*/  /*
		*/ (last) fincbtax fincatax (sum) finlwt21 totexp, by(cuid)

	collapse `collapse_vars'
	gen year = `yyyy'
	gen quarter = 1
	save "Compiled Data Files\compiledfmly_`yy'1.dta", replace
	restore

/* Create the file of households that started the survey in Q2 */
	preserve
	/* Only keep CU's that started interi==2 in the second quarter of loop */
	keep if (interi==2&quarter==2&year==`yyyy')|(interi==3&quarter==3&year==`yyyy')|(interi==4&quarter==4&year==`yyyy')|(interi==5&quarter==1&year==`zzzz')

	/* Collapse, keeping the important demographic variables */
	sort cuid interi
	collapse `collapse_vars'
	gen year = `yyyy'
	gen quarter = 2
	save "Compiled Data Files\compiledfmly_`yy'2.dta", replace
	restore

/* Create the file of households that started the survey in Q3 */
	preserve
	/* Only keep CU's that started interi==2 in the third quarter of loop */
	keep if (interi==2&quarter==3&year==`yyyy')|(interi==3&quarter==4&year==`yyyy')|(interi==4&quarter==1&year==`zzzz')|(interi==5&quarter==2&year==`zzzz')

	/* Collapse, keeping the important demographic variables */
	sort cuid interi
	collapse `collapse_vars'
	gen year = `yyyy'
	gen quarter = 3
	save "Compiled Data Files\compiledfmly_`yy'3.dta", replace
	restore
	
/* Create the file of households that started the survey in Q4 */
	preserve
	/* Only keep CU's that started interi==2 in the fourth quarter of loop */
	keep if (interi==2&quarter==4&year==`yyyy')|(interi==3&quarter==1&year==`zzzz')|(interi==4&quarter==2&year==`zzzz')|(interi==5&quarter==3&year==`zzzz')

	/* Collapse, keeping the important demographic variables */
	sort cuid interi
	collapse `collapse_vars'
	gen year = `yyyy'
	gen quarter = 4
	save "Compiled Data Files\compiledfmly_`yy'4.dta", replace
	restore

	
}



/* PART TWO: stack them all together into a single file
------------------------------------------------------------*/
foreach yyyy of numlist 1996/2012 {
*local yyyy = 1996
di `yyyy'
local yy = substr(string(`yyyy'),3,4)
	
	foreach q of numlist 1/4 { /*loop over quarters within each year */
		*local q = 2
		if `yyyy'==1996 & `q'==1 {
		use "Compiled Data Files\compiledfmly_`yy'`q'.dta", clear
		*di "`yy' `q' test if" 
		}
		else {		
		*di "`yy' `q' test else"
		append using "Compiled Data Files\compiledfmly_`yy'`q'.dta"
		}
	}
	
}


/* note cuid is *NOT* a unique identifier.  Observations are identified
based on CUID, YEAR, and QUARTER combined. */
save "Compiled Data Files\BLS_compiledfmly_all.dta", replace	

	
