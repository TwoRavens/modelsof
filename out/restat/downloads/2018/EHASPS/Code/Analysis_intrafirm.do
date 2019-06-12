* Analysis_intrafirm.do
* Tests for intrafirm spatial leakage

capture log close
set more off
timer clear 1
timer on 1
clear all
local work "PATH"
log using "`work'/Logs/Analysis_intrafirm.log", replace
set matsize 11000
set maxvar 32767

* Flow control locals
local primary=0
local placebo=0
local firmsize=1
local leakagedist=0

eststo drop *

* Reading data
use "`work'/Data/Masters/PM_intrafirm.dta", clear

sort facility_id year
fvset base 2008 year

* For spec with NAICS-yr or state-yr FE
replace NAICS_consistent=999999 if missing(NAICS_consistent)
replace fips_state=99 if missing(fips_state)
encode NAICS_cons3, generate(NAICS3)
replace NAICS3=999 if missing(NAICS3)
encode NAICS_cons4, generate(NAICS4)
replace NAICS4=9999 if missing(NAICS4)
encode NAICS_cons5, generate(NAICS5)
replace NAICS5=99999 if missing(NAICS5)

* Labels
label variable ln_onsite_air "Onsite air"

if `primary'==1 {
****************************
* Models by firm
****************************
display "*************** PM - logs ***************"
* Continuous
xtreg ln_onsite_air i.year c.otherplants_treated if nonattainPWPM==0, fe vce(cluster FIPS)
eststo PMcont

* Binned dummies (preferred spec)
xtreg ln_onsite_air i.year i.d_otherplants if nonattainPWPM==0, fe vce(cluster FIPS)
eststo PM

* Robustness: state linear trends
xtreg ln_onsite_air i.year i.fips_state#c.year i.d_otherplants if nonattainPWPM==0, fe vce(cluster FIPS)
eststo PMrob

* Outputting table by firms
esttab PM PMrob PMcont using "`work'/Tables/Intrafirm.tex", ///
	keep(*d_otherplants *otherplants_treated) drop(*0*) ///
	coeflabels(1.d_otherplants "1 other treated plant" 2.d_otherplants "2+ other treated plants" c.otherplants_treated "Count other treated") ///
	indicate("State linear trends=*.fips_state#c.year" "Year FE=*.year" "Plant FE=_cons") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	label se tex replace

****************************
* By firm & NAICS
****************************
foreach j in 2 3 4 5 6 {

	* Binned dummies (preferred spec)
	xtreg ln_onsite_air i.year i.d_otherplants`j' if nonattainPWPM==0, fe vce(cluster FIPS)
	eststo PM`j'
	
	* Binned dummies - state*yr FE
	reghdfe ln_onsite_air i.d_otherplants`j' if nonattainPWPM==0, absorb(i.facility_id i.fips_state#i.year) vce(cluster FIPS) old
	eststo PMstyrFE`j'
	
	* Binned dummies - county*yr FE
	reghdfe ln_onsite_air i.d_otherplants`j' if nonattainPWPM==0, absorb(i.facility_id i.FIPS#i.year) vce(cluster FIPS) old
	eststo PMctyyrFE`j'
	
	* Binned dummies - NAICS*yr FE
	reghdfe ln_onsite_air i.d_otherplants`j' if nonattainPWPM==0, absorb(i.facility_id i.NAICS3#i.year) vce(cluster FIPS) old
	eststo PMncsyrFE`j'
	
	* Binned dummies - NAICS*yr FE and county*yr FE
	reghdfe ln_onsite_air i.d_otherplants`j' if nonattainPWPM==0, absorb(i.facility_id i.FIPS#i.year i.NAICS3#i.year) vce(cluster FIPS) old
	eststo PMNcsYrCtyYrFE`j'
	
	* Single dummy
	xtreg ln_onsite_air i.year 1.other_treated_dummy`j' if nonattainPWPM==0, fe vce(cluster FIPS)
	eststo PM1dumm`j'
	
	* Single dummy - state*yr FE
	reghdfe ln_onsite_air 1.other_treated_dummy`j' if nonattainPWPM==0, absorb(i.facility_id i.fips_state#i.year) vce(cluster FIPS) old
	eststo PM1dummstyrFE`j'
	
	* Single dummy - county*yr FE
	reghdfe ln_onsite_air 1.other_treated_dummy`j' if nonattainPWPM==0, absorb(i.facility_id i.FIPS#i.year) vce(cluster FIPS) old
	eststo PM1dummctyyrFE`j'
	
	* Single dummy - NAICS*yr FE
	reghdfe ln_onsite_air 1.other_treated_dummy`j' if nonattainPWPM==0, absorb(i.facility_id i.NAICS3#i.year) vce(cluster FIPS) old
	eststo PM1dummncsyrFE`j'
	
	* Single dummy - NAICS*yr FE and county*yr FE
	reghdfe ln_onsite_air 1.other_treated_dummy`j' if nonattainPWPM==0, absorb(i.facility_id i.FIPS#i.year i.NAICS3#i.year) vce(cluster FIPS) old
	eststo PM1dNcsYrCtyYrFE`j'
	
	* Table output
	esttab PM1dumm`j' PM1dummctyyrFE`j' PM1dNcsYrCtyYrFE`j' PM`j' PMctyyrFE`j' PMNcsYrCtyYrFE`j' using "`work'/Tables/Intrafirm`j'.tex", ///
		keep(*other_treated_dummy`j' 1.d_otherplants`j' 2.d_otherplants`j') ///
		coeflabels(1.other_treated_dummy`j' "1+ other treated plants" 1.d_otherplants`j' "1 other treated plant" 2.d_otherplants`j' "2+ other treated plants") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		label se tex replace
	esttab PM1dummctyyrFE`j' PMctyyrFE`j' using "`work'/Tables/Intrafirm`j'_ctyyrFE.tex", ///
		keep(*other_treated_dummy`j' 1.d_otherplants`j' 2.d_otherplants`j') ///
		coeflabels(1.other_treated_dummy`j' "1+ other treated plants" 1.d_otherplants`j' "1 other treated plant" 2.d_otherplants`j' "2+ other treated plants") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		label se tex replace
	esttab PM1dummncsyrFE`j' PMncsyrFE`j' using "`work'/Tables/Intrafirm`j'_NAICSyrFE.tex", ///
		keep(*other_treated_dummy`j' 1.d_otherplants`j' 2.d_otherplants`j') ///
		coeflabels(1.other_treated_dummy`j' "1+ other treated plants" 1.d_otherplants`j' "1 other treated plant" 2.d_otherplants`j' "2+ other treated plants") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		label se tex replace	
			
}
}


if `placebo'==1 {
****************************
* Placebo
****************************
local j = 6

* Single dummy
xtreg ln_onsite_air i.year 1.placebo_dummy`j' if nonattainPWPM==0, fe vce(cluster FIPS)
eststo plac1dumm`j'

* Single dummy - county*yr FE
reghdfe ln_onsite_air 1.placebo_dummy`j' if nonattainPWPM==0, absorb(i.facility_id i.FIPS#i.year) vce(cluster FIPS) old
eststo p1dctyyrFE`j'

* Single dummy - countyy*yr FE and NAICS*yr FE
reghdfe ln_onsite_air 1.placebo_dummy`j' if nonattainPWPM==0, absorb(i.facility_id i.FIPS#i.year i.NAICS3#i.year) vce(cluster FIPS) old
eststo p1dNAICSyrFE`j'

* Binned dummies (preferred spec)
xtreg ln_onsite_air i.year i.d_placebo`j' if nonattainPWPM==0, fe vce(cluster FIPS)
eststo plac2dumm`j'

* Binned dummies - county*yr FE
reghdfe ln_onsite_air i.d_placebo`j' if nonattainPWPM==0, absorb(i.facility_id i.FIPS#i.year) vce(cluster FIPS) old
eststo p2dctyyrFE`j'

* Binned dummies - county*yr FE and NAICS*yr FE
reghdfe ln_onsite_air i.d_placebo`j' if nonattainPWPM==0, absorb(i.facility_id i.FIPS#i.year i.NAICS3#i.year) vce(cluster FIPS) old
eststo p2dNAICSyrFE`j'

* Table by firm and `j'-digit NAICS
esttab plac1dumm`j' p1dctyyrFE`j' p1dNAICSyrFE`j' plac2dumm`j' p2dctyyrFE`j' p2dNAICSyrFE`j' using "`work'/Tables/Intrafirm_placebo.tex", ///
	keep(*placebo_dummy`j' 1.d_placebo`j' 2.d_placebo`j') ///
	coeflabels(1.placebo_dummy`j' "1+ other placebo plants" 1.d_placebo`j' "1 other placebo plant" 2.d_placebo`j' "2+ other placebo plants") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	label se tex replace
}


if `firmsize'==1 {
****************************
* Additional robustness
****************************
eststo clear
foreach j in 6 {
	* Continuous - total plants in firm
	xtreg ln_onsite_air i.year totplants c.otherplants_treated`j' c.otherplants_treated`j'#c.totplants if nonattainPWPM==0, fe vce(cluster FIPS)
	eststo FS1
	
	* Single dummy - total plants in firm
	xtreg ln_onsite_air i.year totplants 1.other_treated_dummy`j' 1.other_treated_dummy`j'#c.totplants if nonattainPWPM==0, fe vce(cluster FIPS)
	eststo FS2
	
	* Two dummies  - total plants in firm
	xtreg ln_onsite_air i.year totplants i.d_otherplants`j' i.d_otherplants`j'#c.totplants if nonattainPWPM==0, fe vce(cluster FIPS)
	eststo FS3
	
	* Continuous - total plants in firm & 6-digit NAICS
	xtreg ln_onsite_air i.year totplants6 c.otherplants_treated`j' c.otherplants_treated`j'#c.totplants6 if nonattainPWPM==0, fe vce(cluster FIPS)
	eststo FS1A
	
	* Single dummy - total plants in firm & 6-digit NAICS
	xtreg ln_onsite_air i.year totplants6 1.other_treated_dummy`j' 1.other_treated_dummy`j'#c.totplants6 if nonattainPWPM==0, fe vce(cluster FIPS)
	eststo FS2A
	
	* Two dummies
	xtreg ln_onsite_air i.year totplants6 i.d_otherplants`j' i.d_otherplants`j'#c.totplants6 if nonattainPWPM==0, fe vce(cluster FIPS)
	eststo FS3A
	
	* Table by firm and `j'-digit NAICS
	esttab FS2 FS3 FS2A FS3A using "`work'/Tables/Intrafirm_FSrob.tex", ///
		keep(1.other_treated_dummy`j' 1.other_treated_dummy`j'#c.totplants 1.other_treated_dummy`j'#c.totplants6 1.d_otherplants`j' 2.d_otherplants`j' 1.d_otherplants`j'#c.totplants 2.d_otherplants`j'#c.totplants 1.d_otherplants`j'#c.totplants6 2.d_otherplants`j'#c.totplants6) ///
		coeflabels(1.other_treated_dummy`j' "1+ treated plants" 1.other_treated_dummy`j'#c.totplants "1+ treated*total plants" 1.other_treated_dummy`j'#c.totplants6 "1+ treated*plants in NAICS6"  1.d_otherplants`j' "1 treated plant" 2.d_otherplants`j' "2+ treated plants" 1.d_otherplants`j'#c.totplants "1 treated*total plants" 2.d_otherplants`j'#c.totplants "2+ treated*total plants" 1.d_otherplants`j'#c.totplants6 "1 treated*plants in NAICS6" 2.d_otherplants`j'#c.totplants6 "2+ treated* plants in NAICS6") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		label se tex replace
}
}


if `leakagedist'==1 {
*****************************
* Leakage
* Varying threshold distance
* 2digit NAICS
*****************************
eststo drop *

* Models
xtreg ln_onsite_air i.year 1.other_treated_dummy6 if nonattainPWPM==0, fe vce(cluster FIPS)
eststo distorig
generate other_treated_dummy6_original = other_treated_dummy6
forval i = 1/4 {
	drop other_treated_dummy6
	rename other_treated_dummy6_`i' other_treated_dummy6
	xtreg ln_onsite_air i.year 1.other_treated_dummy6 if nonattainPWPM==0, fe vce(cluster FIPS)
	eststo dist`i'
}
* Table
esttab dist1 dist2 distorig dist3 dist4  using "`work'/Tables/Intrafirm_bydist.tex", keep(1.other_treated_dummy6) se ///
	mtitles("<.97km" "<1.02km" "<1.07km" "<1.12km" "<1.17km") ///
	coeflabels(1.other_treated_dummy6 "1+ other treated plants") ///
	indicate("Year FE=*.year" "Plant FE=_cons") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	label tex longtable compress nogaps replace
drop other_treated_dummy6
rename other_treated_dummy6_original other_treated_dummy6	
}



timer off 1
timer list 1
capture log close






