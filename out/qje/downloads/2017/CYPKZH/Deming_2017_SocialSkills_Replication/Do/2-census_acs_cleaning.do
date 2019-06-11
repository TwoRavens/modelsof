/*
	Project: The growing importance of social skills in the labor market (2017)
	Author: David Deming
	Date Created: April 2017
	
	Description: Cleans and prepares the Census and ACS data for analysis, using 
		code adapted from replication package for Autor and Price (2013)
	
	Notes:
	- Start with IPUMS decennial Census extracts (1980, 1990, and 2000) 
		and pooled 3-year ACS extracts (2005-2007, 2008-2010, 2011-2013).
		Select the following variables (not all of them present in all 
		of these extracts): 
		year multyear perwt sex age uhrswork wkswork1 wkswork2 incwage
		educ educd classwkrd empstatd gqtyped occ occ1990 ind ind1990.
	- For the ACS 3-year extracts, set "year" equal to "multyear" and drop "multyear".
*/


version 14
clear all
set more off


**** Define macros ****

global topdir "YOURFILEPATH/Deming_2017_SocialSkills_Replication"
local dodir "${topdir}/Do"

local rawdir "${topdir}/Data/census-acs/raw"
local cleandir "${topdir}/Data/census-acs/clean"
local collapdir "${topdir}/Data/census-acs/collapsed" 
local occdir "${topdir}/Data/census-acs/xwalk_occ"
local inddir "${topdir}/Data/census-acs/xwalk_ind"

local onetdir "${topdir}/Data/onet"
local txtdir "${topdir}/Data/onet/text_files"
local dotdir "${topdir}/Data/dot"

local nlsydir "${topdir}/Data/nlsy"
local import79dir "${topdir}/Data/nlsy/import/nlsy79"
local import97dir "${topdir}/Data/nlsy/import/nlsy97"
local name79 "socskills_nlsy79_final"			/* Name of NLSY79 extract */
local name97 "socskills_nlsy97_final"			/* Name of NLSY97 extract */
local afqtadj "${topdir}/Data/nlsy/altonjietal2012"

local figdir "${topdir}/Results/figures"
local tabdir "${topdir}/Results/tables"


*****************************
****Clean Census-ACS Data****
*****************************

** Use Treiman file to aggregate DOT 1977 by Census Occupation 1990dd codes

* Load Treiman file, which is a sample of 1980 Census respondents double-coded
*	with 1970 and 1980 occupation codes
use "`dotdir'/treiman.dta", clear

* Create labor supply weights
gen lswt = hours * weeks

* Restrict to employed persons with observed occupation codes
keep if lswt > 0
drop if occ70 == . | occ80 == .

* Merge in DOT 1977 measures with 1970 occupation codes
merge m:1 occ70 using "`dotdir'/dot77-70.dta", keep(match) nogen

* Collapse the DOT measures at the 1980 occupation level
collapse ehf finger dcp sts math [aweight=lswt], by(occ80)

* Merge in 1980 to 1990dd crosswalk
rename occ80 occ
merge 1:1 occ using "`occdir'/occ1980_occ1990dd_update.dta", nogen

* Collapse by occ1990dd
collapse ehf finger dcp sts math, by(occ1990dd)

* Take note of unmatched occ1990dd codes, then drop
tab occ1990dd if math==.
drop if math==.

* Save data
save "`dotdir'/dot77-occ1990dd-Tr.dta", replace

** Loop to clean data for all Census-ACS years

foreach y in "1980" "1990" "2000" "2006" "2009" "2012" {
		
	** Prepare to impute weeks worked for 2008-2010 & 2011-2013 ACS
	if "`y'" == "2009" | "`y'" == "2012" {
		
		* Impute using the sample closest in time
		use "`rawdir'/2006.dta", clear
		
		* Defining the sample to be used for imputation
		drop if perwt == 0
		replace age = age - 1
		drop if age < 18 | age > 64
		assert wkswork1 < .
		keep if wkswork1 > 0
		drop if gqtyped >= 100 & gqtyped <= 499
		drop if classwkrd == 29
		keep if empstatd >= 10 & empstatd <= 12

		* Computing mean weeks worked within each interval in the reference extract
		foreach inv in "01_13" "14_26" "27_39" "40_47" "48_49" "50_52" {
			local lb = substr("`inv'", 1, 2)
			local ub = substr("`inv'", 4, .)
			quietly sum wkswork1 if wkswork1 >= `lb' & wkswork1 <= `ub' [aweight = perwt]
			local wks_`inv' = r(mean)
		}
	}

	** Load raw data downloaded from IPUMS
	use "`rawdir'/`y'.dta", clear

	** Impute weeks and hours worked
	if "`y'" == "2009" |  "`y'" == "2012" {
		gen wkswork1 = 0
		replace wkswork1 = `wks_01_13' if wkswork2 == 1
		replace wkswork1 = `wks_14_26' if wkswork2 == 2
		replace wkswork1 = `wks_27_39' if wkswork2 == 3
		replace wkswork1 = `wks_40_47' if wkswork2 == 4
		replace wkswork1 = `wks_48_49' if wkswork2 == 5
		replace wkswork1 = `wks_50_52' if wkswork2 == 6
	}

	** Impose sample restrictions
	
	* Drop anyone who is assigned a sampling weight of zero (some do for unknown reason)
	drop if perwt == 0
	
	* Keep if age 18-64 last year
	replace age = age - 1
	drop if age < 18 | age > 64
	
	* Keep anyone who worked 1+ weeks last year. Equivalent to using the "workedyr" variable.
	assert wkswork1 < .
	keep if wkswork1 > 0

	* Keep anyone with income > 0 last year.
	assert incwage < .
	keep if incwage > 0
	
	* Drop institutional group quarters (note that for 1980 Census this does not exclude military,
	*	dorm rooms, and other categories).
	drop if gqtyped >= 100 & gqtyped <= 499

	* Drop unpaid family workers
	drop if classwkrd == 29

	* Keep all employed
	keep if empstatd >= 10 & empstatd <= 12

	** Exclude workers with inapplicable or military occupations

	if "`y'" == "1980" {
		* Exclude if occupation is not applicable, former member of the armed forces, 
		*	unemployed or not reported
		drop if occ == 0 | occ == 905 | occ == 909
	}
	else if "`y'" == "1990" {
		* Exclude if occupation is not applicable, military, or unemployed
		drop if occ == 0 | (occ >= 903 & occ <= 905) | occ == 909
	}
	else {
		* Exclude if occupation is unknown, military, or unemployed
		drop if occ1990 == 905 | occ1990 == 991 | occ1990 == 999
	}
	
	**	Create education dummies

	* Making sure we have educational data for everyone still in the sample
	assert educd >= 2 & educd <= 116

	* Defining education using the educd variable		
	gen edu_lths = (educd >= 002 & educd <= 050)
	gen edu_hsch = (educd >= 060 & educd <= 064)
	gen edu_scol = (educd >= 065 & educd <= 090)
	gen edu_coll = (educd >= 100 & educd <= 116)
	gen edu_bach = (educd >= 100 & educd <= 101)
	gen edu_mast = (educd >= 110 & educd <= 116)
	
	assert edu_lths + edu_hsch + edu_scol + edu_coll == 1
	assert edu_bach + edu_mast == edu_coll
	drop educ educd

	** Compute each worker's labor supply weight
	gen lswt = perwt * (uhrswork/35) * (wkswork1/50)
	assert lswt > 0 & lswt < .
	
	** Compute log hourly wage
	gen hrwage=incwage/(uhrswork*wkswork1)
	
	* Inflate wages to 2012 dollars 
	* 	Note: For annual average, go to https://data.bls.gov/cgi-bin/cpicalc.pl,
	*	select "About this calculator" then "This data"
	if `y'==1980 {
		replace hrwage=hrwage*round(229.594/82.4,.01)
	}
	if `y'==1990 {
		replace hrwage=hrwage*round(229.594/130.7,.01)
	}
	if `y'==2000 {
		replace hrwage=hrwage*round(229.594/172.2,.01)
	}
	if `y'==2006 {
		replace hrwage=hrwage*round(229.594/201.6,.01)
	}
	if `y'==2009 {
		replace hrwage=hrwage*round(229.594/214.537,.01)	
	}

	* Log hourly wage
	gen ln_hrwage=ln(hrwage)
	
	** Data reduction
	
	* Note: Proceeding further with microdata is computationally challenging.
	*		So I now collapse the data into cells defined on the basis of 
	*		sex, education, industry, and occupation.
	
	* Restating education as a single variable
	gen edu_bin = 1 if edu_lths == 1
	replace edu_bin = 2 if edu_hsch == 1
	replace edu_bin = 3 if edu_scol == 1
	replace edu_bin = 4 if edu_bach == 1
	replace edu_bin = 5 if edu_mast == 1
	assert edu_bin != .
	
	label define edulab 1 "Less than high school" 2 "High school graduate" 3 "Some college" ///
		4 "College graduate" 5 "Some postgrad"
	label values edu_bin edulab
	
	* Collapse into narrowly defined cells
	collapse (rawsum) lswt (mean) hrwage ln_hrwage [aw=lswt], by(year sex edu_bin occ occ1990 ind ind1990)

	** Implement the Autor-Dorn occ1990dd occupation crosswalk.
	
	* Bring in occ1990dd codes
	if "`y'" == "1980" | "`y'" == "1990" | "`y'" == "2000"   {
		merge m:1 occ using "`occdir'/occ`y'_occ1990dd_update.dta", keep(master match) nogen
	}
	else if "`y'" == "2006" {
		
		* Remove extra zero for 2005-2009 occupation codes
		rename occ occ4d
		gen occ = substr(string(occ4d), 1, length(string(occ4d))-1)
		destring occ, replace
	
		merge m:1 occ using "`occdir'/occ2005_occ1990dd_update.dta", keep(master match) nogen
		drop occ
		rename occ4d occ
	}
	else if "`y'" == "2009" {
		rename occ occ_all
		
		* Occ 2005-2009 codes for 2008 & 2009
		gen occ4d=occ_all if year==2008 | year==2009
		gen occ = substr(string(occ4d), 1, length(string(occ4d))-1)
		destring occ, replace
		merge m:1 occ using "`occdir'/occ2005_occ1990dd_update.dta", keep(master match) nogen
		drop occ occ4d
		
		* Occ 2010 codes for 2010
		gen occ2010=occ_all if year==2010
		merge m:1 occ2010 using "`occdir'/occ2010_occ1990dd_update.dta", keep(1 3 4 5) update nogen
		drop occ2010
		
		rename occ_all occ
	}
	else if "`y'" == "2012" {
		rename occ occ2010
		merge m:1 occ2010 using "`occdir'/occ2010_occ1990dd_update.dta", keep(master match) nogen
		rename occ2010 occ
	}
	
	* Make sure that occ1990dd is populated for all workers
	assert occ1990dd != .

	* Drop anyone in the military (again)
	drop if occ1990dd == 905

	** Merge ONET 1998 measures and DOT 1977 task measures at the occ1990dd level
	
	* Merge in ONET 1998
	merge m:1 occ1990dd using "`onetdir'/onet98_occ1990dd.dta", keep(1 3) gen(onetmerge)
	
	* Merge in DOT 1977
	merge m:1 occ1990dd using "`dotdir'/dot77-occ1990dd-Tr.dta", keep(1 3) gen(dotmerge)
	
	* Create overall task merge variable
	gen taskmerge=(onetmerge==3 & dotmerge==3)
	
	* Rename DOT tasks
	foreach task in "ehf" "finger" "dcp" "sts" "math" {
		rename `task' `task'_dot77
	}
	
	* Create DOT 1977 composite routine variable
	gen routine_dot77 = (finger_dot77 + sts_dot77)/2

	** Implement an industry crosswalk from AKK. 
	
	* Note: This crosswalk is intended to cover industry codes from 1960 through 1990.
	*		For post-1990 extracts, I use the IPUMS ind1990 crosswalk variable to first map industry codes 
	*		into 1990 industry codes, then I apply the AKK crosswalk using these 1990 industry codes.

	* First, dropping military industries as well as those whose industry is listed as unemployed.
	* With these industries dropped, every remaining industry should merge successfully with the AKK crosswalk.
	drop if (ind1990 >= 940 & ind1990 <= 960) | ind1990 == 991 | ind1990 == 992 | ind1990 == 999
	
	if "`y'" == "1980" {
		* Recode two industries that aren't appropriately handled by the AKK crosswalk.
		* ALM excluded these industries, but I prefer to include them, especially since industries are 
		*	not our main focus.
		replace ind = 391 if ind == 382
		replace ind = 532 if ind == 522
		
		rename ind ind80
	    merge m:1 ind80 using "`inddir'/ind80.dta", assert(2 3) keep(3) nogenerate keepusing(ind6090)
	    rename ind80 ind
	}
	else if "`y'" == "1990" | "`y'" == "2000" | "`y'" == "2006" | "`y'" == "2009" | "`y'" == "2012" {
		rename ind1990 ind90
        merge m:1 ind90 using "`inddir'/ind90.dta", assert(2 3) keep(3) nogenerate keepusing(ind6090)
    	rename ind90 ind1990
	}
	
	* Combine certain industries to ensure complete industry representation throughout the sample period
	replace ind6090 = 142 if ind6090 == 150
	replace ind6090 = 222 if ind6090 == 220
	replace ind6090 = 231 if ind6090 == 241
	replace ind6090 = 206 if ind6090 == 380 | ind6090 == 381
	replace ind6090 = 432 if ind6090 == 422
	replace ind6090 = 691 if ind6090 == 592 | ind6090 == 602
	replace ind6090 = 766 if ind6090 == 782
	replace ind6090 = 630 if ind6090 == 790
	replace ind6090 = 121 if ind6090 == 122
	replace ind6090 = 166 if ind6090 == 301
	
	** Save cleaned-up extract
	save "`cleandir'/`y'.dta", replace

}

