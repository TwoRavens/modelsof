#delim cr
set more off
*version 10
pause on
graph set ps logo off

capture log close
set linesize 80
set logtype text
log using clean-census-2000-data.log , replace

/* --------------------------------------

AUTHOR: Tal Gross

PURPOSE:

DATE CREATED:  January 11, 2011

NOTES:

--------------------------------------- */

clear all
estimates clear
set mem 2000m
describe, short


************************************************************
**   Program used below                                   **
************************************************************

** This is a program to destring strings when they're strings
capture program drop destring_ifstring
program define destring_ifstring
	local type: type `1'
	if substr("`type'",1,3) == "str" { 
		rename `1' `1'_orig
		gen `1' = real(`1'_orig)
		drop `1'_orig
		disp "`1' destringed"
	}
	if substr("`type'",1,3) == "str" {
		disp "`1' not a string"
	}
end


************************************************************
**   Bring in Data                                        **
************************************************************

insheet using dc_dec_2000_sf3_u_data1.txt , names delim(|)

list geo_id geo_id2 sumlevel geo_name p001001 in 1/3
drop if _n == 1

label var geo_id   "Geography Identifier"
label var geo_id2  "Geography Identifier"
label var sumlevel "Geographic Summary Level"
label var geo_name "Geography"
label var p001001 "Total population: Total"
label var p037001 "Population 25 years and over: Total"
label var p037002 "Population 25 years and over: Male"
label var p037003 "Population 25 years and over: Male; No schooling completed"
label var p037004 "Population 25 years and over: Male; Educational attainment; Nursery to 4th grade"
label var p037005 "Population 25 years and over: Male; Educational attainment; 5th and 6th grade"
label var p037006 "Population 25 years and over: Male; Educational attainment; 7th and 8th grade"
label var p037007 "Population 25 years and over: Male; Educational attainment; 9th grade"
label var p037008 "Population 25 years and over: Male; Educational attainment; 10th grade"
label var p037009 "Population 25 years and over: Male; Educational attainment; 11th grade"
label var p037010 "Population 25 years and over: Male; Educational attainment; 12th grade; no diploma"
label var p037011 "Population 25 years and over: Male; High school graduate (includes equivalency)"
label var p037012 "Population 25 years and over: Male; Some college; less than 1 year"
label var p037013 "Population 25 years and over: Male; Some college; 1 or more years; no degree"
label var p037014 "Population 25 years and over: Male; Associate degree"
label var p037015 "Population 25 years and over: Male; Bachelor's degree"
label var p037016 "Population 25 years and over: Male; Master's degree"
label var p037017 "Population 25 years and over: Male; Professional school degree"
label var p037018 "Population 25 years and over: Male; Doctorate degree"
label var p037019 "Population 25 years and over: Female"
label var p037020 "Population 25 years and over: Female; Educational attainment; No schooling completed"
label var p037021 "Population 25 years and over: Female; Educational attainment; Nursery to 4th grade"
label var p037022 "Population 25 years and over: Female; Educational attainment; 5th and 6th grade"
label var p037023 "Population 25 years and over: Female; Educational attainment; 7th and 8th grade"
label var p037024 "Population 25 years and over: Female; Educational attainment; 9th grade"
label var p037025 "Population 25 years and over: Female; Educational attainment; 10th grade"
label var p037026 "Population 25 years and over: Female; Educational attainment; 11th grade"
label var p037027 "Population 25 years and over: Female; Educational attainment; 12th grade; no diploma"
label var p037028 "Population 25 years and over: Female; High school graduate (includes equivalency)"
label var p037029 "Population 25 years and over: Female; Some college; less than 1 year"
label var p037030 "Population 25 years and over: Female; Some college; 1 or more years; no degree"
label var p037031 "Population 25 years and over: Female; Associate degree"
label var p037032 "Population 25 years and over: Female; Bachelor's degree"
label var p037033 "Population 25 years and over: Female; Master's degree"
label var p037034 "Population 25 years and over: Female; Professional school degree"
label var p037035 "Population 25 years and over: Female; Doctorate degree"
label var p053001 "Households: Median household income in 1999"
label var p082001 "Total population: Per capita income in 1999"
label var p089001 "Population for whom poverty status is determined: Total"
label var p089002 "Population for whom poverty status is determined: Income in 1999 below poverty level"
label var p089003 "Population for whom poverty status is determined: Income in 1999 below poverty level; Under 65 years"
label var p089004 "Population for whom poverty status is determined: Income in 1999 below poverty level; Under 65 years; In married-couple families"
label var p089005 "Population for whom poverty status is determined: Income in 1999 below poverty level; Under 65 years; Not in married-couple families"
label var p089006 "Population for whom poverty status is determined: Income in 1999 below poverty level; Under 65 years; Male householder; no wife present"
label var p089007 "Population for whom poverty status is determined: Income in 1999 below poverty level; Under 65 years; Female householder; no husband present"
label var p089008 "Population for whom poverty status is determined: Income in 1999 below poverty level; Under 65 years; Unrelated individuals"
label var p089009 "Population for whom poverty status is determined: Income in 1999 below poverty level; 65 to 74 years"
label var p089010 "Population for whom poverty status is determined: Income in 1999 below poverty level; 65 to 74 years; In married-couple families"
label var p089011 "Population for whom poverty status is determined: Income in 1999 below poverty level; 65 to 74 years; Not in married-couple families"
label var p089012 "Population for whom poverty status is determined: Income in 1999 below poverty level; 65 to 74 years; Male householder; no wife present"
label var p089013 "Population for whom poverty status is determined: Income in 1999 below poverty level; 65 to 74 years; Female householder; no husband present"
label var p089014 "Population for whom poverty status is determined: Income in 1999 below poverty level; 65 to 74 years; Unrelated individuals"
label var p089015 "Population for whom poverty status is determined: Income in 1999 below poverty level; 75 years and over"
label var p089016 "Population for whom poverty status is determined: Income in 1999 below poverty level; 75 years and over; In married-couple families"
label var p089017 "Population for whom poverty status is determined: Income in 1999 below poverty level; 75 years and over; Not in married-couple families"
label var p089018 "Population for whom poverty status is determined: Income in 1999 below poverty level; 75 years and over; Male householder; no wife present"
label var p089019 "Population for whom poverty status is determined: Income in 1999 below poverty level; 75 years and over; Female householder; no husband present"
label var p089020 "Population for whom poverty status is determined: Income in 1999 below poverty level; 75 years and over; Unrelated individuals"
label var p089021 "Population for whom poverty status is determined: Income in 1999 at or above poverty level"
label var p089022 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; Under 65 years"
label var p089023 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; Under 65 years; In married-couple families"
label var p089024 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; Under 65 years; Not in married-couple families"
label var p089025 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; Under 65 years; Male householder; no wife present"
label var p089026 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; Under 65 years; Female householder; no husband present"
label var p089027 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; Under 65 years; Unrelated individuals"
label var p089028 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; 65 to 74 years"
label var p089029 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; 65 to 74 years; In married-couple families"
label var p089030 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; 65 to 74 years; Not in married-couple families"
label var p089031 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; 65 to 74 years; Male householder; no wife present"
label var p089032 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; 65 to 74 years; Female householder; no husband present"
label var p089033 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; 65 to 74 years; Unrelated individuals"
label var p089034 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; 75 years and over"
label var p089035 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; 75 years and over; In married-couple families"
label var p089036 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; 75 years and over; Not in married-couple families"
label var p089037 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; 75 years and over; Male householder; no wife present"
label var p089038 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; 75 years and over; Female householder; no husband present"
label var p089039 "Population for whom poverty status is determined: Income in 1999 at or above poverty level; 75 years and over; Unrelated individuals"

foreach var in geo_id2 p001001 p037001 p037002 p037003 p037004 p037005 p037006 p037007 p037008 p037009 p037010 p037011 p037012 p037013 p037014 p037015 p037016 p037017 p037018 p037019 p037020 p037021 p037022 p037023 p037024 p037025 p037026 p037027 p037028 p037029 p037030 p037031 p037032 p037033 p037034 p037035 p053001 p082001 p089001 p089002 p089003 p089004 p089005 p089006 p089007 p089008 p089009 p089010 p089011 p089012 p089013 p089014 p089015 p089016 p089017 p089018 p089019 p089020 p089021 p089022 p089023 p089024 p089025 p089026 p089027 p089028 p089029 p089030 p089031 p089032 p089033 p089034 p089035 p089036 p089037 p089038 p089039 {
	disp "Now cleaning `var'"
	destring_ifstring `var'
}

************************************************************
**   Create Key Variables                                 **
************************************************************

rename geo_id2 zip

egen college_guys = rowtotal(p037029 p037030 p037031 p037032 p037033 p037034 p037035 p037012 p037013 p037014 p037015 p037016 p037017 p037018)

gen share_college =  college_guys / p037001 
sum share_college

sum share_college if zip == 60022
sum share_college if zip == 02139
sum share_college if zip == 10025


************************************************************
**   Clean & Close                                        **
************************************************************

keep share_college zip
compress
save census-2000-share-college.dta , replace



log close
exit

