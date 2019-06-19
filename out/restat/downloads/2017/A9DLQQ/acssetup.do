/**********************************************************************************
		acssetup.do
		Download 3yr sample 2011 ACS from https://usa.ipums.org/usa/
**********************************************************************************/

/**********************************************************************************
		GLOBALS
**********************************************************************************/

global folder myfolder		// replace 'myfolder' with datafolder

/**********************************************************************************
		LOAD DATA
**********************************************************************************/

cd "${folder}"
set more off

use ipums20113yrs.dta, clear // replace with name of data extract

/**********************************************************************************
		CONSTRUCT SAMPLE
**********************************************************************************/

* Keep only Bachelor and more
keep if educd >= 101
* Born in Germany or the US
keep if bpl <= 56 | bpl == 453
gen german = (bpl == 453) 
* Age at immigration > 25
replace yrimmig = . if yrimmig == 0
gen ageatmig = yrimmig-birthyr
	la var ageatmig "Age at immigration"
* Not in school
keep if school == 1
* Employed
keep if empstatd == 10
* Full Time
keep if WKSWORK2 == 6 // 50-52 weeks
keep if uhrswork >= 35 // more than 35 hours per week

* Drop if born abroad of American parents
drop if citizen == 1

* Age
keep if age >= 30 & age <= 45
gen age_2 = age^2

* Female
replace sex = 0 if sex == 1 // males
replace sex = 1 if sex == 2 // females
rename sex female
la var female "Female"
la drop SEX

* Define Variables
gen ln_incwage = ln(incwage)
sum ln_incwage,d
keep if ln_incwage >= r(p1)
drop if incwage == 0

* Cohort dummies
gen cohort = 1993 if age >= 42 & age <= 45
replace cohort = 1997 if age >= 38 & age <= 41
replace cohort = 2001 if age >= 34 & age <= 37
replace cohort = 2005 if age >= 30 & age <= 33
tab cohort, gen(cohort)

* German cohort dummy
gen include = 1 if yrimmig == . | (yrimmig >= 1996 & yrimmig <= 2010 & ageatmig >= 25)

* Dummy variables
tab educd, gen(educd)	
tab degfield, gen(degfield)
tab nchild, gen(nchild)
	gen child = (nchild >0)
tab marst, gen(marst)
	gen married = (marst == 1 | marst == 2)

* Demean age
sum age, d
gen age_s = age - r(mean)
gen age_s_2 = age_s^2

/**********************************************************************************
		SAVE
**********************************************************************************/
	
save ipums20113yrs_select.dta, replace
