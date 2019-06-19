/* =================================================
This program creates Figures 1 & 2  and Tables 1,2,3
==================================================== */

/* General settings */

clear
clear matrix
set more off
set mem 200m

/* Get the data */

use disaster_macro_V2_by_event.dta		/* Original dataset, coverage: 196 countries between 1970-2008 */
sort wbcode year id


* Intensity and frequency of natural disasters at event-level dataset


/* Intensity of the event (All the dataset, does not aggregate by country year) */

sort wbcode id year
bysort wbcode id (year): gen damage_GDP   = (damage[_n]*1000000) / gdpcuus[_n-1]*100 	if disaster == 1
bysort wbcode id (year): gen killed_pop   =           killed[_n] / pop[_n-1]*1000000    if disaster == 1

keep if disaster == 1
sort wbcode year id

/* Create a dummy variable for large events (above the mean) */

qui su killed_pop if killed_pop != .
local mkilled = r(mean)
gen large = killed_pop >= `mkilled' if killed_pop != .

/*** =======================================================
* Figure 1: Increasing prevalence of disasters (1970 - 2008)
======================================================= ****/

gen event = 1 if disaster == 1		/* Variable to count (for the bar graph) */

preserve 

collapse (sum) event large, by(year)
twoway 	(connected event year, mcolor(black) msymbol(lgx) lcolor(black) lwidth(medthick)) 			///
		(connected large year, yaxis(2) mcolor(gs4) lcolor(gs4) lwidth(medthick)) if year < 2008, 	///
		ytitle(Number of events) ytitle(Number of events, orientation(rvertical) axis(2)) 			///
		ylabel(0(10)40, angle(rvertical) axis(2)) xtitle(" ") xlabel(1970(5)2007) 					///
		legend(region(lcolor(none)) order(1 "Total events" 2 "Large events (right scale)" ))		///
		note("Note: Large events refers to events whose intensity is above the mean of the"			///
		"normalized killed distribution" "Source: Authors' calculations based on EM-DAT. ") 		///
		scheme(s1color) name(fig1, replace)

restore

/* ==============================================			
TABLES 1 & 2 (Disaster level) 
============================================== */

tab type					/* All events 				*/
tab type if large == 1		/* Events above the mean 	*/

/* Merge land area info */

sort wbcode year
merge m:1 wbcode year using data_area_WDI.dta
drop if _merge == 2
drop _merge

/* Merge additional geography variables */

sort wbcode 
merge m:1 wbcode using geography2.dta
drop if _merge == 2
drop _merge

sort wbcode year

gen ldamage_GDP     = log(damage_GDP)
gen lkilled_pop2    = log(killed_pop)

gen lrichter   = log(richter)
gen lwindspeed = log(windspeed)
gen larea 	   = log(landarea)

gen abslat     = abs(lat)
gen ldur       = log(duration)

local controls larea island abslat

qui eststo reg1: xi: reg ldamage_GDP lrichter	`controls', robust
qui eststo reg2: xi: reg ldamage_GDP lwindspeed	`controls', robust

qui eststo reg3: xi: reg lkilled_pop lrichter	`controls', robust	
qui eststo reg4: xi: reg lkilled_pop lwindspeed	`controls', robust

/*-------------------
 Table 3 Regressions
 -------------------*/

esttab using Table3.tab,									    ///
                stat(r2 N) brackets label se					///
                star(* 0.10 ** 0.05 *** 0.01)					///
                title(Exogeneity of Disasters Magnitude Variables) replace


/* ====================================================================
Distribution of disaster type (country year level
==================================================================== */

use disaster_macro_V2_by_event.dta, clear
sort wbcode year id

* Add disasters within coutry-year

egen total_killed    =  sum(killed)   , by(wbcode year)
gen missing_total_killed    =  (killed  ==. & disaster==1)
egen yc_missing_total_killed    =  sum(missing_total_killed  ) , by(wbcode year)
replace total_killed    =  . if yc_missing_total_killed   >= 1
egen n_disasters  =  sum(disaster) , by(wbcode year)

* Disaster classification (Earthquake, flood, storm, combined)
* ------------------------------------------------------------ 

egen 	yc_type   =  mean(type), by(wbcode year)	
replace yc_type   = 5 if yc_type != 1 & yc_type != 2 & yc_type != 3 & yc_type != . 
label values yc_type type2

egen    n_earth   = sum(disaster*(type == 1)), by(wbcode year)
egen    n_storm   = sum(disaster*(type == 2)), by(wbcode year)
egen    n_flood   = sum(disaster*(type == 3)), by(wbcode year)

* Collapse data at the country-year level 
* ---------------------------------------
sort wbcode year id
by wbcode year : gen counter = _n

keep if counter==1
replace disaster=1 if n_disasters>=1
replace disaster=0 if n_disasters==0

gen pop_th = pop >= 1000000


* generate normalized damage measure
* ==================================

sort wbcode year
           gen killed_pop  = total_killed     / pop
by wbcode: gen killed_pop2 = total_killed[_n] / pop[_n-1]


gen lastyear = year<2000		/* Compute threshold prior to 1999 */

qui su killed_pop2 if killed_pop2 != . & disaster==1 & lastyear & pop_th, det 
scalar mean_killed_pop2W = r(mean)


gen krate = killed_pop2*1000000

/* ==============================================
Figure 2: Distribution of disasters magnitudes 
============================================== */

kdensity 	krate if krate != . & disaster==1, recast(line) lcolor(black) lwidth(medthick) 				///
			xtitle(Deaths per Million Inhabitants) title(People Killed in Natural Disasters) 			///
			note("Source: Authors' calculations based on EM-DAT and WDI databases.") 					///
			subtitle((density estimate)) scheme(s1color) name(fig2, replace)

/* ==============================================			
TABLES 1 & 2 (Coutry-Year level) 
============================================== */

gen large   = (killed_pop2 > mean_killed_pop2W)*(killed_pop2!=. & disaster==1)

tab yc_type										/* All events 						*/
tab yc_type if large == 1						/* Large disasters (over the mean)	*/
