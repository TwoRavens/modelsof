/////////////////////////////////////
/// CAMS/HRS DATASET CONSTRUCTION ///
/////////////////////////////////////

clear
clear matrix
clear mata
set mem 500m
set maxvar 15000
set matsize 800
set more off

//////////////////////////////////////////////////////////////////////////////////////////////////
//                                         Working Directory                                    //

cd "/nfs/sch-data1/projects/dua-data-projects/HRS/angrisan/Paper_CAMS/Data"

//////////////////////////////////////////////////////////////////////////////////////////////////

use "cams_long.dta", clear

drop if hhidpn == 500416010 // this respondent is not matched to HRS and only answers CAMS w3 
replace hhidpn = 501315010 if hhidpn==501315020 // this respondent is not matched to HRS but the partner is

// Merging CAMS and HRS //

sort hhidpn camswave
merge 1:1 hhidpn camswave using "myrandhrs.dta"
drop if _merge==2
drop _merge

// Merging DC Account Data //

merge 1:1 hhidpn hrswave using "dc_account_all.dta"
drop if _merge==2
drop _merge

////////////////////////////////////////////////////////
// Dealing with 7 cases where two members of the same //
// household answer CAMS (marital status not updated, //
// see email by Craig 2/27/2013).                     // 
gen usvar = 1
bys hxhhid camswave: egen usvar2 = sum(usvar)
drop if usvar2==2 & rfinr==0
drop if hhidpn==16407010 & camswave==6
drop usvar*
////////////////////////////////////////////////////////

// Match year/month with corresponding National Indexes //
sort iw_year iw_month
merge iw_year iw_month using "./Indexes/indexes.dta"
drop if _merge==2
drop _merge

// Match year/month with corresponding House Prices by Census division //
sort iw_year iw_month
merge iw_year iw_month using "./Indexes/hpi_bycendiv.dta"
drop if _merge==2
drop _merge
** Associate house price index to census division **
gen hpi_bydiv = .
forval i = 1/9 {
replace hpi_bydiv = hpi_`i' if rcendiv==`i'
}

// Match year/month with corresponding Unemployment Rate by Census division //
sort iw_year iw_month
merge iw_year iw_month using "./Indexes/ur_bycendiv.dta"
drop if _merge==2
drop _merge
** Associate unemployment rate to census division **
gen ur_bydiv = .
forval i = 1/9 {
replace ur_bydiv = ur_`i' if rcendiv==`i'
}

// Match year/quarter with corresponding House Prices by State //
sort iw_year iw_quarter
merge iw_year iw_quarter using "./Indexes/hpi_bystate.dta"
drop if _merge==2
drop _merge
** Associate house price index to state **
gen hpi_bystate = .
forval i = 1/51 {
replace hpi_bystate = hpi_state`i' if state==`i'
}
** Associate house price index CV to state **
gen hpi_cvstate = .
forval i = 1/51 {
replace hpi_cvstate = cv_`i' if state==`i'
}
** Associate house price index Drop to state **
gen hpi_dropstate = .
forval i = 1/51 {
replace hpi_dropstate = drop_hpi_state`i' if state==`i'
}

// Match year/quarter with corresponding Unemployment Rate by State //
sort iw_year iw_quarter
merge iw_year iw_quarter using "./Indexes/ur_bystate.dta"
drop if _merge==2
drop _merge
** Associate unemployment rate to state **
gen ur_bystate = .
forval i = 1/51 {
replace ur_bystate = ur_state`i' if state==`i'
}
** Associate unemployment increase to state **
gen ur_incstate = .
forval i = 1/51 {
replace ur_incstate = increase_ur_state`i' if state==`i'
}

// Match year/quarter with corresponding Mortgage Rate by State //
sort iw_year iw_quarter
merge iw_year iw_quarter using "./Indexes/mort_bystate.dta"
drop if _merge==2
drop _merge
** Associate mortgage rate to state **
gen mort_bystate = .
forval i = 1/51 {
replace mort_bystate = mort_state`i' if state==`i'
}

// Match year/quarter with corresponding CredAbility by State //
sort iw_year iw_quarter
merge iw_year iw_quarter using "./Indexes/credability_bystate.dta"
drop if _merge==2
drop _merge
** Associate mortgage rate to state **
gen cra_bystate = .
forval i = 1/51 {
replace cra_bystate = cra_state`i' if state==`i'
}

// Match year with corresponding Home Ownership Rate by State //
sort iw_year
merge iw_year using "./Indexes/hown_bystate.dta"
drop if _merge==2
drop _merge
** Associate home ownership to state **
gen hown_bystate = .
forval i = 1/51 {
replace hown_bystate = hown_state`i' if state==`i'
}

// Match year with corresponding House Vacancy by State //
sort iw_year
merge iw_year using "./Indexes/hvac_bystate.dta"
drop if _merge==2
drop _merge
** Associate house vacancy to state **
gen hvac_bystate = .
forval i = 1/51 {
replace hvac_bystate = hvac_state`i' if state==`i'
}

sort hhidpn camswave

save "cams_working.dta", replace
