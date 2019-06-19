** Non-Traded goods in USD, Semiannual observations

** Intracountry pairs dropped

** First filter: data has been filtered out if doesn't have an observation for all years
	
** Used as input to the analysis datasets:
**	an_reg1_aggregate_semiannual_nsc_drop1_f1.do, 
**	an_ccemg_aggregate_semiannual_f1.do
**	an_ccep_aggregate_semiannual_nsc_drop1_f1.do
** Modified by Andy Cohn, Oct 2008

clear
capture log close
set more off
set mem 720m
set maxvar 30000
capture program drop _all


global programpath "P:\BerginGlickWu Replication\data_creation\programs"
global outpath1 "P:\BerginGlickWu Replication\data_creation\datasets"
global datapath1 "P:\BerginGlickWu Replication\data_creation\original"

cd "$programpath"

** Load the dataset with all the aggregate q's, years 1990-2006. sorted by city1, city2, 


use "$datapath1\semiannual_aggregate_nt_f1.dta", clear

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
	rename q`i'_1 q_usd1`i'
}

forvalues i = 1990/2006 {
	rename q`i'_2 q_usd2`i'
}


egen pairid = group(city1 city2)
keep pairid q* ERprod_PWonecity

**Reshaping the data to wide format using the following .ado file
cd "$programPath"
**res_wide_agg_semiannual_drop1_f1
gen series_title = 1			//.ado file requires series_title be defined (also used for non-agg). series_title dropped after reshape
gen CS = 1					//.ado file requires CS be defined (also used for non-agg). CS dropped after reshape
res_wide_semiannual_nsc_all
drop series_title	CS*			// only needed to prevent error in reshaping

save "$outpath1\aggregate_semiannual_nt_nsc_drop1_f1_wide_indust.dta", replace

exit
