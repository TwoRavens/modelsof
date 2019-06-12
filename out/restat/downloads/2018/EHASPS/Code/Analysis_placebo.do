* Analysis_placebo.do
* Cross-media placebo tests, beginning with "effect" on plants without air emissions 

capture log close
set more off
timer clear 1
timer on 1
clear
set matsize 10000
local work "PATH"
log using "`work'/Logs/Analysis_placebo.log", replace


* Locals for variable sets
local controls "i.year"
local treatment "1.treated#i.noair"


*****************************
* Xmedia placebo
*****************************
foreach class in PM {
	eststo drop *

	* Reading data
	use "`work'/Data/Masters/`class'.dta", clear
	
	* Code to generate treatment variable - from "Analysis_treatment.do"
	gen mindist_rolling = PMmindist
	sort facility_id year
	bysort facility_id: replace mindist_rolling = L.mindist_rolling if missing(mindist_rolling) | (!missing(mindist_rolling) & (L.mindist_rolling<mindist_rolling))
	bysort facility_id: replace mindist_rolling = mindist_rolling[_n-1] if missing(mindist_rolling) | (!missing(mindist_rolling) & (mindist_rolling[_n-1]<mindist_rolling))
	assert mindist_rolling <= L.mindist_rolling if !missing(mindist_rolling) & !missing(L.mindist_rolling)
	assert !missing(mindist_rolling) if !missing(PMmindist)
	sort facility_id year
	forval i=1/3 {
		gen L`i'PMmindist = L`i'.PMmindist
		gen L`i'mindist_rolling = L`i'.mindist_rolling
	}
	bysort facility_id: egen maxNA = max(nonattainPWPM)
	keep if inrange(year, 1992, 2015)
	gen close = (L1mindist_rolling < 1.07) if !missing(L1mindist_rolling)
	gen treated = 1.L1.nonattainPWPM*1.close if !missing(L1.nonattainPWPM)
	replace treated = 1 if (L.treated==1 | L2.treated==1 | L3.treated==1 | L4.treated==1 | L5.treated==1 | L6.treated==1 | L7.treated==1 | L8.treated==1 | L9.treated==1 | L10.treated==1) 
	replace treated = 0 if nonattainPWPM==0 & missing(treated)
	label variable treated "Treated"
	
	* Additional variables
	gen noair=(onsite_air==0)
	gen treatedXnoair = 1.treated*1.noair
	
	* Opening loop over channels
	foreach channel in onsite_water onsite_land onsite_other offsite_water offsite_land offsite_other recy_recov_trtd {
		
		fvset base 2008 year	
		sort facility_id year
		display "FOO"
		display "************** `class' -- `channel' ***************

		* Level models
		xtreg ln_`channel' `controls' `treatment', fe vce(cluster FIPS)
		eststo `channel'lev

	* End loop over channels	
	}
	
	* Table output
	esttab *lev using "`work'/Tables/Xmedia_`class'_levs_placebo.tex", keep(*treated*) order(1.treated#1.noair 1.treated#0b.noair) se ///
		coeflabels(1.treated#1.noair "Treated*no air emissions" 1.treated#0b.noair "Treated*air emissions") ///
		indicate("Year FE=*.year" "Plant FE=_cons") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		compress label tex replace

* End loop over classes		
}






timer off 1
timer list 1
capture log close







