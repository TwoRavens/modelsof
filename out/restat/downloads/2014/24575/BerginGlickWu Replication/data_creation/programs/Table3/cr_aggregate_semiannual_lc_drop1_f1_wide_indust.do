** Traded goods in LC, Semiannual observations

** First filter: data has been filtered out if doesn't have an observation for all years
	

clear
capture log close
set more off
set mem 720m
set maxvar 30000
set varabbrev off
capture program drop _all

global programpath "P:\BerginGlickWu Replication\data_creation\programs"
global outpath1 "P:\BerginGlickWu Replication\data_creation\datasets"
global datapath1 "P:\BerginGlickWu Replication\data_creation\original"

cd "$programpath"

***************************************************************************************
** Creating the wide version of the nominal exchange rate
***************************************************************************************
use "$datapath1\agg_semiannual_nom_xr_f1.dta", clear

** drop countries with currency reforms whose data wasn't smoothed **
/*
	Argentina
	Brazil
	Ecuador
	Mexico
	Peru
	Poland
	Russia
	Uruguay
*/

drop if country1 == 1 | country2 == 1
drop if country1 == 6 | country2 == 6
drop if country1 == 16 | country2 == 16
drop if country1 == 37 | country2 == 37
drop if country1 == 47 | country2 == 47
drop if country1 == 49  | country2 == 49
drop if country1 == 51 | country2 == 51
drop if country1 == 68 | country2 == 68

** exclude same country pairs

drop if country1 == country2
************ New drops***********************************
** Dropping Istanbul by dropping Turkey (country code is 64)
drop if country1==64 | country2==64
********************************************************
***********************************************************************
** Using .ado file to constrain sample to industrial countries only, with US in pair
dataconstr_indust
***********************************************************************

forvalues i = 1990/2007 {
	rename q`i'_1 q1`i'
}

forvalues i = 1990/2006 {
	rename q`i'_2 q2`i'
}

egen pairid = group(city1 city2)
keep pairid q* 
quietly summ pairid
local pairmax = r(max)

**Reshaping the data to wide format using the following .ado file
cd "$programpath"
gen ERprod_PWonecity = 1		//.ado file requires ERprod_PWonecity be defined (also used for non-agg).
gen series_title = 1			//.ado file requires series_title be defined (also used for non-agg). series_title dropped after reshape
gen CS = 1					//.ado file requires CS be defined (also used for non-agg). CS dropped after reshape
res_wide_semiannual_lc_all
drop series_title	CS* ERprod_PWonecity*		// only needed to prevent error in reshaping
*** renaming q* s* (xr)
forvalues m=1/`pairmax' {
	quietly rename q`m' s`m'
}

sort date

tempfile nomxr
save "`nomxr'", replace
***************************************************************************************

***************************************************************************************
** Load the dataset with all the aggregate q's, years 1990-2006. sorted by city1, city2, 
***************************************************************************************
use "$datapath1\semiannual_aggregate_lc_f1.dta", clear

** drop countries with currency reforms whose data wasn't smoothed **
/*
	Argentina
	Brazil
	Ecuador
	Mexico
	Peru
	Poland
	Russia
	Uruguay
*/

drop if country1 == 1 | country2 == 1
drop if country1 == 6 | country2 == 6
drop if country1 == 16 | country2 == 16
drop if country1 == 37 | country2 == 37
drop if country1 == 47 | country2 == 47
drop if country1 == 49  | country2 == 49
drop if country1 == 51 | country2 == 51
drop if country1 == 68 | country2 == 68

** exclude same country pairs

drop if country1 == country2
************ New drops***********************************
** Dropping Istanbul by dropping Turkey (country code is 64)
drop if country1==64 | country2==64
********************************************************

***********************************************************************
** Using .ado file to constrain sample to industrial countries only, with US in pair
dataconstr_indust
***********************************************************************

forvalues i = 1990/2007 {
	rename q`i'_1 q1`i'
}

forvalues i = 1990/2006 {
	rename q`i'_2 q2`i'
}

egen pairid = group(city1 city2)
keep pairid q* ERprod_PWonecity*

**Reshaping the data to wide format using the following .ado file
cd "$programpath"		
gen series_title = 1			//.ado file requires series_title be defined (also used for non-agg). series_title dropped after reshape
gen CS = 1					//.ado file requires CS be defined (also used for non-agg). CS dropped after reshape
res_wide_semiannual_lc_all
drop series_title	CS* 		// only needed to prevent error in reshaping


sort date
merge date using "`nomxr'"
drop _merge

save "$outpath1\aggregate_semiannual_lc_drop1_f1_wide_indust.dta", replace

exit
