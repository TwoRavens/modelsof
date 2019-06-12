* Analysis_xmedia.do
* Models of cross-media substitution 

capture log close
set more off
timer clear 1
timer on 1
clear
set matsize 10000
local work "PATH"
log using "`work'/Logs/Analysis_xmedia.log", replace


* Flow control locals
local aggregate = 0
local toxweighted = 0
local heterogeneity6 = 0
local waterdist = 0
local spillovers = 0
local lpm = 0
local prevlit = 1


* Locals for variable sets
local controls "i.year"
local treatment "1.treated"
local treatment_lag "L(0/3).1.treated"

if `aggregate'==1 {
*****************************
* All industries by channel
*****************************
eststo drop *

* Reading data
use "`work'/Data/Masters/PM_treatment.dta", clear

* For specs with NAICS-yr or state-yr FE
replace NAICS_consistent=999999 if missing(NAICS_consistent)
replace fips_state=99 if missing(fips_state)

* Opening loop over channels
foreach channel in onsite_water onsite_land onsite_other offsite_water offsite_land offsite_other recy_recov_trtd {
	
	fvset base 2008 year	
	sort facility_id year
	display "************** PM -- `channel' **************"

	* Ratio models
	xtreg ln_rat_`channel' `controls' `treatment', fe vce(cluster FIPS)
	eststo `channel'rtwoway

	* County*year FE - ratios
	reghdfe ln_rat_`channel' `treatment', absorb(i.facility_id i.FIPS#i.year) vce(cluster FIPS)
	eststo `channel'rtctyXyrFE
	
	* County*year FE and NAICS*yr FE - ratios
	reghdfe ln_rat_`channel' `treatment', absorb(i.facility_id i.FIPS#i.year i.NAICS3#i.year) vce(cluster FIPS)
	eststo `channel'CtyNcsYrFEr

	* Level models with air on RHS
	xtreg ln_`channel' `controls' ln_onsite_air `treatment', fe vce(cluster FIPS)
	eststo `channel'lev
	
	* Level models without air
	xtreg ln_`channel' `controls' `treatment', fe vce(cluster FIPS)
	eststo `channel'lev2

	* County*year FE - levels
	reghdfe ln_`channel' `treatment', absorb(i.facility_id i.FIPS#i.year) vce(cluster FIPS) old
	eststo `channel'countyXyrFE
	
	* County*year FE and NAICS*yr FE - levels
	reghdfe ln_`channel' `treatment', absorb(i.facility_id i.FIPS#i.year i.NAICS3#i.year) vce(cluster FIPS) old
	eststo `channel'CtyYrNcsYrFE
	
	
* End loop over channels	
}

* Main ratio table
esttab *rtwoway using "`work'/Tables/Xmedia_PM.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	topfile("`work'/Tables/Xmedia_top.tex") ///
	postfoot("\hline\hline") ///
	noobs ///
	longtable fragment compress label tex replace
esttab *rtctyXyrFE using "`work'/Tables/Xmedia_PM.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	prehead("\multicolumn{1}{l}{Panel B: County*year FE} \\") ///
	nomtitles nonumbers noobs ///
	postfoot("\hline\hline") ///
	longtable fragment compress label tex append
esttab *CtyNcsYrFEr using "`work'/Tables/Xmedia_PM.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	prehead("\multicolumn{1}{l}{Panel C: County*year \& industry*year FE} \\") ///
	nomtitles nonumbers ///
	bottomfile("`work'/Tables/Xmedia_bottom.tex") ///
	longtable fragment compress label tex append
* Levels (not ratio), air on RHS 
esttab *lev using "`work'/Tables/Xmedia_PM_levs_airRHS.tex", keep(1.treated ln_onsite_air) order(1.treated ln_onsite_air) se ///
	coeflabels(1.treated "Treated" ln_onsite_air "Log air emissions") ///
	indicate("Year FE=*.year*" "Plant FE=_cons") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	label tex longtable compress nogaps replace

* Main table - log levels
esttab *lev2 using "`work'/Tables/Xmedia_PM_levs.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	topfile("`work'/Tables/Xmedia_top.tex") ///
	postfoot("\hline\hline") ///
	noobs ///
	longtable fragment compress label tex replace
esttab *countyXyrFE using "`work'/Tables/Xmedia_PM_levs.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	prehead("\multicolumn{1}{l}{Panel B: County*year FE} \\") ///
	nomtitles nonumbers noobs ///
	postfoot("\hline\hline") ///
	longtable fragment compress label tex append
esttab *CtyYrNcsYrFE using "`work'/Tables/Xmedia_PM_levs.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	prehead("\multicolumn{1}{l}{Panel C: County*year \& industry*year FE} \\") ///
	nomtitles nonumbers ///
	bottomfile("`work'/Tables/Xmedia_bottom.tex") ///
	longtable fragment compress label tex append
}
	

if `toxweighted'==1 {
************************************************
* All industries by channel - toxicity weighted
************************************************
eststo drop *

* Reading data
use "`work'/Data/Masters/PM_treatment.dta", clear

* Opening loop over channels
foreach channel in TWonsite_air TWonsite_water TWonsite_land TWonsite_other TWoffsite_water TWoffsite_land TWoffsite_other TWrecy_recov_trtd {
	
	fvset base 2008 year	
	sort facility_id year
	display "************** PM -- `channel' **************"
	
	* Level models without air
	xtreg ln_`channel' `controls' `treatment', fe vce(cluster FIPS)
	eststo TW`channel'lev2
	
	* Level models w/county-yr FE
	reghdfe ln_`channel' `treatment', absorb(i.facility_id i.FIPS#i.year) vce(cluster FIPS) old
	eststo TW`channel'ctyyr
	
	* Level models w/county-yr and NAICS-yr FE
	reghdfe ln_`channel' `treatment', absorb(i.facility_id i.FIPS#i.year i.NAICS3#i.year) vce(cluster FIPS) old
	eststo TW`channel'ncsyr
	
* End loop over channels	
}

* Tox weighted levels
esttab *lev2  using "`work'/Tables/Xmedia_PM_levs_TW.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) noobs ///
	topfile("`work'/Tables/Xmedia_top_TW.tex") ///
	postfoot("\hline\hline") ///
	longtable fragment compress label tex replace
esttab *ctyyr  using "`work'/Tables/Xmedia_PM_levs_TW.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) noobs nonumbers nomtitles ///
	prehead("\multicolumn{1}{l}{Panel B: County*year FE} \\") ///
	postfoot("\hline\hline") ///
	longtable fragment compress label tex append	
esttab *ncsyr using "`work'/Tables/Xmedia_PM_levs_TW.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) nonumbers nomtitles ///
	prehead("\multicolumn{1}{l}{Panel C: County*year \& industry*year FE} \\") ///
	bottomfile("`work'/Tables/Xmedia_bottom_TW.tex") ///
	longtable fragment compress label tex append
}


if `heterogeneity6'==1 {
*******************************
* By industry and channel - PM
*******************************	
* Reading data
use "`work'/Data/Masters/PM_treatment.dta", clear
	
* Clearing stored results
eststo drop *

* Industry codes
foreach code in 331111 331528 324110 221112 332812 332813 325188 327310 331221 332312 325510 331491 325199 332111 327992 325211 ///
	331513 332116 324122 325110 325132 212234 332112 325131 424710 {
	
	eststo drop *
	* Model prep
	fvset base 2008 year	
	sort facility_id year

	* Air model
	capture xtreg ln_onsite_air  `controls' `treatment' if NAICS_consistent==`code', fe vce(cluster FIPS)
	capture eststo onsite_airlev
	
	* Opening loop over channels
	foreach channel in onsite_water onsite_land onsite_other offsite_water offsite_land offsite_other recy_recov_trtd {
		
		fvset base 2008 year	
		sort facility_id year
		display "************** PM -- `code' -- `channel' **************"
		* Distance models - levels
		capture xtreg ln_`channel' `controls' `treatment' if NAICS_consistent==`code', fe vce(cluster FIPS)
		capture eststo `channel'lev
		* Distance models - ratios
		capture xtreg ln_rat_`channel' `controls' `treatment' if NAICS_consistent==`code', fe vce(cluster FIPS)
		capture eststo `channel'rat
	} /* End channel loop*/
	
	* Table - all channels within an industry-class
	esttab *lev using "`work'/Tables/NAICS`code'_xmedia.tex", keep(1.treated) drop(1o.treated) se ///
		coeflabels(1.treated "Treated") ///
		indicate("Year dummies=*.year" "Plant FEs=_cons") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		compress label tex replace
		
	* Big table - levels
	if "`code'"=="331111" {
	esttab *lev using "`work'/Tables/Xmedia_NAICS6_levs.tex", keep(1.treated) drop(1o.treated) se ///
		coeflabels(1.treated "Iron and steel") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		topfile("`work'/Tables/Xmedia_top_NAICS6.tex") ///
		postfoot("\hline") ///
		label tex fragment longtable compress nogaps replace
	esttab *rat using "`work'/Tables/Xmedia_NAICS6_ratios.tex", keep(1.treated) drop(1o.treated) se ///
		coeflabels(1.treated "Iron and steel") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		topfile("`work'/Tables/Xmedia_top_NAICS6.tex") ///
		postfoot("\hline") ///
		label tex fragment longtable compress nogaps replace
	}
	if "`code'"=="331528" {
	esttab *lev using "`work'/Tables/Xmedia_NAICS6_levs.tex", keep(1.treated) drop(1o.treated) se ///
		coeflabels(1.treated "Nonferrous foundries") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		postfoot("\hline") ///
		nomtitles nonumbers label tex fragment longtable compress nogaps append
	esttab *rat using "`work'/Tables/Xmedia_NAICS6_ratios.tex", keep(1.treated) drop(1o.treated) se ///
		coeflabels(1.treated "Nonferrous foundries") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		postfoot("\hline") ///
		nomtitles nonumbers label tex fragment longtable compress nogaps append
	}
	if "`code'"=="324110" {
	esttab *lev using "`work'/Tables/Xmedia_NAICS6_levs.tex", keep(1.treated) drop(1o.treated) se ///
		coeflabels(1.treated "Petroleum refining") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		postfoot("\hline") ///
		nomtitles nonumbers label tex fragment longtable compress nogaps append
	esttab *rat using "`work'/Tables/Xmedia_NAICS6_ratios.tex", keep(1.treated) drop(1o.treated) se ///
		coeflabels(1.treated "Petroleum refining") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		postfoot("\hline") ///
		nomtitles nonumbers label tex fragment longtable compress nogaps append
	}
	if "`code'"=="221112" {
	esttab *lev using "`work'/Tables/Xmedia_NAICS6_levs.tex", keep(1.treated) drop(1o.treated) se ///
		coeflabels(1.treated "Fossil electric power") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		postfoot("\hline") ///
		nomtitles nonumbers label tex fragment longtable compress nogaps append
	esttab *rat using "`work'/Tables/Xmedia_NAICS6_ratios.tex", keep(1.treated) drop(1o.treated) se ///
		coeflabels(1.treated "Fossil electric power") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		bottomfile("`work'/Tables/Xmedia_bottom_byind.tex") ///
		nomtitles nonumbers label tex fragment longtable compress nogaps append	
	}
	if "`code'"=="332812" {
	esttab *lev using "`work'/Tables/Xmedia_NAICS6_levs.tex", keep(1.treated) drop(1o.treated) se ///
		coeflabels(1.treated "Metal engraving and coating") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		bottomfile("`work'/Tables/Xmedia_bottom_byind.tex") ///
		nomtitles nonumbers label tex fragment longtable compress nogaps append
	}
	
} /* End code (industry) loop */
} /* End `heterogeneity6' code */


if `waterdist'==1 {
*****************************
* Water effects
* Varying threshold distance
*****************************
eststo drop *

* Reading data
use "`work'/Data/Masters/PM_treatment.dta", clear

* Models
xtreg ln_onsite_water `controls' 1.treated, fe vce(cluster FIPS)
eststo onwater
gen waterdflag = e(sample)
reghdfe ln_onsite_water 1.treated if waterdflag==1, absorb(i.facility_id i.year#i.fips_state) vce(cluster FIPS) old
eststo onwateralt
rename treated treated_primary
forval i = 1/10 {
	rename treated`i' treated
	xtreg ln_onsite_water `controls' 1.treated if waterdflag==1, fe vce(cluster FIPS)
	eststo onwater`i'
}
rename treated_primary treated /* restores correct treatment variable */
* Table
esttab onwater1 onwater2 onwater onwater3 onwater4 using "`work'/Tables/Xmedia_PM_onwater_bydist.tex", keep(1.treated) order(1.treated) se ///
	mtitles("<.97km" "<1.02km" "<1.07km" "<1.12km" "<1.17km") ///
	coeflabels(1.treated "Treated") ///
	indicate("Year FE=*.year" "Plant FE=_cons") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	label tex longtable compress nogaps replace	
}


if `spillovers'==1 {
****************************
* Ratio models
* Tests whether spillovers impact Xmedia results
****************************
use "`work'/Data/Masters/PM_intrafirm.dta", clear

eststo drop *
* Opening loop over channels
foreach channel in onsite_water onsite_land onsite_other offsite_water offsite_land offsite_other recy_recov_trtd {
	
	* Single dummy
	xtreg ln_`channel' i.year 1.other_treated_dummy6 if nonattainPWPM==0, fe vce(cluster FIPS)
	eststo PM`channel'

}
* Outputting table by firms
esttab using "`work'/Tables/Xmedia_spillover_test.tex", keep(*treated*) se ///
			coeflabels(1.other_treated_dummy6 "1+ other treated plants") ///
			indicate("Year FE=*.year" "Plant FE=_cons") ///
			star(* 0.10 ** 0.05 *** 0.01) ///
			compress label tex replace
}


if `lpm'==1 {
*****************************
* Linear probability models
*****************************
eststo drop *

* Reading data
use "`work'/Data/Masters/PM_treatment.dta", clear

* Opening loop over channels
foreach channel in onsite_water onsite_land onsite_other offsite_water offsite_land offsite_other recy_recov_trtd {
	
	fvset base 2008 year	
	sort facility_id year
	display "************** PM -- `channel' **************"
	
	* Panel LPM
	gen pos_`channel' = (`channel'>0 & !missing(`channel'))
	display "*** Panel LPM ***"
	eststo: xtreg pos_`channel' `controls' `treatment', fe vce(cluster FIPS)
	esttab using "`work'/Tables/Xmedia_LPM.tex", keep(1.treated) order(1.treated) se ///
		mtitles("Onsite water" "Onsite land" "Onsite other" "Offsite water" "Offsite land" "Offsite other" "Recycled or treated") ///
		coeflabels(1.treated "Treated") ///
		indicate("Year FE=*.year*" "Plant FE=_cons") ///
		star(* 0.10 ** 0.05 *** 0.01) ///
		label tex longtable compress nogaps replace

* End loop over channels	
}
} /* End LPM */


***************************
* Compare to prev. lit.
***************************
if `prevlit'==1 {
* Reading data
use "`work'/Data/Masters/PM_treatment.dta", clear

* Regressions
eststo clear
foreach channel in onsite_water onsite_land onsite_other offsite_water offsite_land offsite_other recy_recov_trtd {
	* Treated, diff
	reghdfe D.ln_`channel' 1.treated, absorb(i.year) vce(cluster FIPS) old
	eststo `channel'td
	* NA, level
	reghdfe ln_`channel' 1.lag_nonattain, absorb(year) vce(cluster FIPS) old
	eststo `channel'NA
	* NA, diff
	reghdfe D.ln_`channel' 1.lag_nonattain, absorb(year) vce(cluster FIPS) old
	eststo `channel'NAd
} /* End channel loop */

* Table
esttab *td using "`work'/Tables/Xmedia_prevlit.tex", keep(1.treated) se ///
	mtitles("Onsite water" "Onsite land" "Onsite other" "Offsite water" "Offsite land" "Offsite other" "Recycled or treated") ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	topfile("`work'/Tables/Xmedia_top_prevlit.tex") ///
	postfoot("\hline\hline") ///
	noobs ///
	longtable fragment compress label tex replace
esttab *NA using "`work'/Tables/Xmedia_prevlit.tex", keep(1.lag_nonattain) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	prehead("\multicolumn{1}{l}{Panel B: Level, nonattainment} \\") ///
	nomtitles nonumbers noobs ///
	postfoot("\hline\hline") ///
	longtable fragment compress label tex append
esttab *NAd using "`work'/Tables/Xmedia_prevlit.tex", keep(1.lag_nonattain) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	prehead("\multicolumn{1}{l}{Panel C: Difference, nonattainment} \\") ///
	nomtitles nonumbers ///
	bottomfile("`work'/Tables/Xmedia_bottom.tex") ///
	longtable fragment compress label tex append


} /* End prevlit */






timer off 1
timer list 1
capture log close







