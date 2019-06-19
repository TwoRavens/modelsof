** Traded goods in LOCAL currency, Semi-Annual observations
** Same country pairs excluded

** First filter: data will be filtered out if doesn't have 2 obs/year for all years

** This program creates the dataset for a first-run at the CCEMG estimator
**	and its t ratio provided by Pesaran (2006, Econometrica).
	
** The resulting dataset will be used for the input into pesa2006.ado (phase 2).
	
** It is also used as an input for an_reg1_f1 (phase 1 regressions)
*** This modification of the cr_dataset_semiannual_nsc_drop1_f1_wide.do file restricts the dataset
*** to pairs used in the Mark, Sul (2008) paper: i.e. all pairs have US as one country,
*** and one of 10 European countries as the other

clear
capture log close
set more off
set mem 700m
set maxvar 30000
set varabbrev off
capture program drop _all


global programpath "P:\BerginGlickWu Replication\data_creation\programs"
global outpath1 "P:\BerginGlickWu Replication\data_creation\datasets"
global datapath1 "P:\BerginGlickWu Replication\data_creation\original"

cd "$programpath"

** Load the dataset with all the q's, years 1990-2006. sorted by city1, city2, 
**   series_title

use "$datapath1\price_dispersion_lc_semiannual_f1.dta", clear

encode series_title, generate(series_title1)
drop series_title
rename series_title1 series_title

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


** Convert to LC price dispersion to USD **

forvalues i = 1990/2007 {
	by city1 city2: gen q_usd1`i' = q`i'_1 - q`i'_1[_N]
}

forvalues i = 1990/2006 {
	by city1 city2: gen q_usd2`i' = q`i'_2 - q`i'_2[_N]	
}

forvalues i = 1990/2007 {
	drop q`i'_1
}

forvalues i = 1990/2006 {
	drop q`i'_2
}

compress _all

** Creating pairid's

egen pairid = group(city1 city2)
keep pairid series_title q_usd* CS ERprod_PWonecity
compress _all

tempfile q_test
save `q_test'


**Reshaping the data to wide format using the following .ado file

res_wide_semiannual_nsc_all


save "$outpath1\semiannual_nsc_drop1_f1_wide_indust.dta", replace


exit


