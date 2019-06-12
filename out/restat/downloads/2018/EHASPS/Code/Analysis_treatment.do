* Analysis_treatment.do
* Semi-parametric analysis of effect on air emissions by distance

capture log close
set more off
timer clear 1
timer on 1
clear
clear matrix
clear mata
set matsize 11000
set emptycells drop
set maxvar 32767
set scheme s1mono
local work "PATH"
cd "`work'"
log using "`work'/Logs/Analysis_treatment.log", replace



* Flow control locals
local primary = 1
local GE = 0
local differences = 0
local selection = 0
local spillover = 0


* Reading data
use "`work'/Data/Masters/PM.dta", clear

* Dropping facilities with no air emissions - should not be affected by CAA
bysort facility_id: egen max_air = max(onsite_air)
drop if max_air==0 | missing(max_air)

* Setting base year (avoids estout errors)
fvset base 2005 year

* Control variable locals
local timecontrols "i.year"

*************************************
* Accounting for time dimension
* when finding closest NA monitor
*************************************
* Additional NAICS variables
encode NAICS_cons3, generate(NAICS3)
replace NAICS3=999 if missing(NAICS3)
encode NAICS_cons4, generate(NAICS4)
replace NAICS4=9999 if missing(NAICS4)
encode NAICS_cons5, generate(NAICS5)
replace NAICS5=99999 if missing(NAICS5)

* Rolling minimum distance to nonattaiment monitor
gen mindist_rolling = PMmindist
sort facility_id year
bysort facility_id: replace mindist_rolling = L.mindist_rolling if missing(mindist_rolling) | (!missing(mindist_rolling) & (L.mindist_rolling<mindist_rolling))
bysort facility_id: replace mindist_rolling = mindist_rolling[_n-1] if missing(mindist_rolling) | (!missing(mindist_rolling) & (mindist_rolling[_n-1]<mindist_rolling)) /* extra command to handle plants with gaps in time series*/
assert mindist_rolling <= L.mindist_rolling if !missing(mindist_rolling) & !missing(L.mindist_rolling)
assert !missing(mindist_rolling) if !missing(PMmindist)

* Generating lags of distance to nonattainment monitor
sort facility_id year
forval i=1/3 {
	gen L`i'PMmindist = L`i'.PMmindist
	gen L`i'mindist_rolling = L`i'.mindist_rolling
}

* Rolling maximum of NA status
bysort facility_id: egen maxNA = max(nonattainPWPM)
gen NArolling = nonattainPWPM
bysort facility_id: replace NArolling = L.NArolling if missing(NArolling) | (!missing(NArolling) & !missing(L.NArolling) & (L.NArolling>NArolling))
bysort facility_id: replace NArolling = NArolling[_n-1] if missing(NArolling) | (!missing(NArolling) & !missing(NArolling[_n-1]) & (NArolling[_n-1]>NArolling)) /* extra command to handle plants with gaps in time series*/
assert NArolling >= L.NArolling if !missing(NArolling) & !missing(L.NArolling)
assert !missing(NArolling) if !missing(nonattainPWPM)

* Limit years because EPA NA spreadsheet only goes back to 1992
* Also TRI has huge reporting change in 1991
* Note this step must occur _after_ calculation of rolling distance
keep if inrange(year, 1992, 2015)


*************************************
* Semi-parametric figures
* for distance analysis
*************************************
* Air model in logs
* Not conducting inference, so not estimating proper SEs
xtreg ln_onsite_air `timecontrols', fe
predict resid_air if e(sample), e

* Graphs
foreach dist in L1mindist_rolling {
	foreach poll in air {
		* 25th percentile distance (3.8km)
		lpoly resid_`poll' `dist' if L1.nonattainPWPM==1 & `dist'<=3.8, ///
			degree(1) noscatter ci addplot(function y=0, range(0 3.8) lpattern(shortdash)) ///
			generate(x_`dist'`poll'4 y_`dist'`poll'4) se(se_`dist'`poll'4) ///
			title("") subtitle("Post-nonattainment plant-years") xtitle("Non-attainment monitor distance (km)") ytitle("Residual log `poll' emissions") ///
			name(`dist'_4, replace) ///
			legend(off)
		local bw = r(bwidth)
		local pw = r(pwidth)
		graph export "`work'/Graphs/`dist'_`poll'_4km.eps", as(eps) replace
		
		* Graph of same residuals, attainment county-years
		* Need to use different distance variable to capture all pre-NA years
		bysort facility_id: egen mindist_allyrs = min(L1mindist_rolling) 
		lpoly resid_`poll' mindist_allyrs if NArolling==0 & maxNA==1 & mindist_allyrs<=3.8, ///
			degree(1) noscatter ci addplot(function y=0, range(0 3.8) lpattern(shortdash)) ///
			title("") subtitle("Pre-nonattainment plant-years") xtitle("Non-attainment monitor distance (km)") ytitle("Residual log `poll' emissions") ///
			name(attainment_rev, replace) ///
			legend(off) bwidth(`bw') pwidth(`pw')
		graph export "`work'/Graphs/`dist'_`poll'_4km_attainment_revised.eps", as(eps) replace

		* Median distance
		lpoly resid_`poll' `dist' if L1.nonattainPWPM==1 & `dist'<=8.5, ///
			degree(1) noscatter ci addplot(function y=0, range(0 8.5) lpattern(shortdash)) ///
			generate(x_`dist'`poll'9 y_`dist'`poll'9) se(se_`dist'`poll'9) ///
			title("") xtitle("Non-attainment  monitor distance (km)") ytitle("Residual log `poll' emissions") ///
			name(`dist'_9, replace) ///
			legend(off) bwidth(`bw') pwidth(`pw')
		graph export "`work'/Graphs/`dist'_`poll'_9km.eps", as(eps) replace
		
		* 90th percentile distance
		lpoly resid_`poll' `dist' if L1.nonattainPWPM==1 & `dist'<=53.18, ///
			degree(1) noscatter ci addplot(function y=0, range(0 53.18) lpattern(shortdash)) ///
			generate(x_`dist'`poll'53 y_`dist'`poll'53) se(se_`dist'`poll'53) ///
			title("") xtitle("Non-attainment  monitor distance (km)") ytitle("") /*ytitle("Residual log `poll' emissions")*/ ///
			name(`dist'_53, replace) ///
			legend(off) bwidth(`bw') pwidth(`pw')
		graph export "`work'/Graphs/`dist'_`poll'_53km.eps", as(eps) replace
		
		* Closing graph windows
		window manage close graph _all
	}
}

* Combined lpoly graph showing greater distances
graph combine L1mindist_rolling_9 L1mindist_rolling_53, cols(2) ycommon iscale(*.9)
graph export "`work'/Graphs/L1mindist_rolling_air_higherdist.eps", as(eps) replace

* Combined lpoly graph comparing attainment and nonattainment counties
graph combine attainment_rev L1mindist_rolling_4, cols(1) ycommon iscale(*.9)
graph export "`work'/Graphs/L1mindist_rolling_air_NAvsA.eps", as(eps) replace

* Closing graph windows
window manage close graph _all

* Computing treatment distance based on lpoly
gen upper95ci = y_L1mindist_rollingair4 + (1.96*se_L1mindist_rollingair4)
summarize x_L1mindist_rollingair4 if upper95ci>0, detail
local cutoff = round(r(min), .01)
display "Distance cutoff: `cutoff' km"
local cutoff1 = round(r(min)-.1, .01)
local cutoff2 = round(r(min)-.05, .01)
local cutoff3 = round(r(min)+.05, .01)
local cutoff4 = round(r(min)+.1, .01)
local cutoff5 = round(r(min)+.15, .01)
local cutoff6 = round(r(min)+.2, .01)
local cutoff7 = round(r(min)+.25, .01)
local cutoff8 = round(r(min)-.15, .01)
local cutoff9 = round(r(min)-.2, .01)
local cutoff10 = round(r(min)-.25, .01)
local cutoff99 = 3

**********************************
* Defining treatment variable
* and event study dummies
**********************************
* Primary treatment variable
gen close = (L1mindist_rolling < `cutoff') if !missing(L1mindist_rolling)
gen treated = 1.L1.nonattainPWPM*1.close if !missing(L1.nonattainPWPM)
* Maintenance plans mean low emissions should continue even when a county gets back into attainment. Lags allow for gaps in plant-level time series.
replace treated = 1 if (L.treated==1 | L2.treated==1 | L3.treated==1 | L4.treated==1 | L5.treated==1 | L6.treated==1 | L7.treated==1 | L8.treated==1 | L9.treated==1 | L10.treated==1) 
replace treated = 0 if nonattainPWPM==0 & missing(treated) /* Attainment-county plants are untreated as long as they haven't been treated in the past */
label variable treated "Treated"

* Nonattainment variable for same sample as primary treatment variable
gen lag_nonattain = L1.nonattainPWPM
replace lag_nonattain = 0 if nonattainPWPM==0 & missing(lag_nonattain)
replace lag_nonattain = 1 if treated==1 & missing(lag_nonattain)
label variable lag_nonattain "County non-attainment (t-1)"

* Treatment variables - alternative distance cutoffs
forval i = 1/10 {
	gen close`i' = (L1mindist_rolling < `cutoff`i'') if !missing(L1mindist_rolling)
	gen treated`i' = 1.L1.nonattainPWPM*1.close`i' if !missing(L1.nonattainPWPM)
	replace treated`i' = 1 if (L.treated`i'==1 | L2.treated`i'==1 | L3.treated`i'==1 | L4.treated`i'==1 | L5.treated`i'==1 | L6.treated`i'==1 | L7.treated`i'==1 | L8.treated`i'==1 | L9.treated`i'==1 | L10.treated`i'==1) 
	replace treated`i' = 0 if nonattainPWPM==0 & missing(treated`i')
}
* Treatment variable - 3km distance cutoff
local i = 99
gen close`i' = (L1mindist_rolling < `cutoff`i'') if !missing(L1mindist_rolling)
gen treated`i' = 1.L1.nonattainPWPM*1.close`i' if !missing(L1.nonattainPWPM)
replace treated`i' = 1 if (L.treated`i'==1 | L2.treated`i'==1 | L3.treated`i'==1 | L4.treated`i'==1 | L5.treated`i'==1 | L6.treated`i'==1 | L7.treated`i'==1 | L8.treated`i'==1 | L9.treated`i'==1 | L10.treated`i'==1) 
replace treated`i' = 0 if nonattainPWPM==0 & missing(treated`i')

if `primary'==1 {
**********************************
* Regression models
* Air emissions
**********************************
eststo clear
* Treatment effects
xtreg ln_onsite_air i.year 1.treated, fe vce(cluster FIPS)
eststo trtPM
gen main_spec_sample = e(sample)

* Tau time variable for event study
* Note will always have less power here than in pooled treatment regressions because some plants are treated when I first observe them
gen tau = .
sort facility_id year
bysort facility_id: egen ever_treated = max(treated)
replace tau = 0 if (treated==1 & L.treated==0)
bysort facility_id: replace tau = tau[_n-1] + (year - year[_n-1]) if missing(tau) & (treated==1) & ever_treated==1
gsort facility_id -year
bysort facility_id: replace tau = tau[_n-1] - (year[_n-1] - year) if missing(tau) & (treated==0) & ever_treated==1
forvalues i = 1/8 {
	gen F`i'tau = (tau==`i') if !missing(tau)
}
forvalues i = 0/14 {
	gen L`i'tau = (tau==-`i') if !missing(tau)
}
foreach x in L14tau L13tau L12tau L11tau L10tau L9tau L8tau L7tau L6tau L5tau L4tau L3tau L2tau L1tau L0tau F1tau F2tau F3tau F4tau F5tau F6tau F7tau F8tau {
	capture replace `x' = 0 if nonattainPWPM==0 & treated!=1
}
sort facility_id year

* Event study
local left = 5
local right = 5
xtreg ln_onsite_air i.year L0tau L2tau-L`left'tau F1tau-F`right'tau if main_spec_sample==1, fe vce(cluster FIPS)
eststo trtPMES

* Saving air coefficients for graph
matrix coeffs = J(11,3,.)
matrix colnames coeffs = param SE tau
forval i=-5/5 {
	local j = `i' + 6
	matrix coeffs[`j', 3] = `i'
}
matrix coeffs[1, 1] = _b[L5tau]
matrix coeffs[1, 2] = _se[L5tau]
matrix coeffs[2, 1] = _b[L4tau]
matrix coeffs[2, 2] = _se[L4tau]
matrix coeffs[3, 1] = _b[L3tau]
matrix coeffs[3, 2] = _se[L3tau]
matrix coeffs[4, 1] = _b[L2tau]
matrix coeffs[4, 2] = _se[L2tau]
matrix coeffs[5, 1] = 0
matrix coeffs[5, 2] = 0
matrix coeffs[6, 1] = _b[L0tau]
matrix coeffs[6, 2] = _se[L0tau]
matrix coeffs[7, 1] = _b[F1tau]
matrix coeffs[7, 2] = _se[F1tau]
matrix coeffs[8, 1] = _b[F2tau]
matrix coeffs[8, 2] = _se[F2tau]
matrix coeffs[9, 1] = _b[F3tau]
matrix coeffs[9, 2] = _se[F3tau]
matrix coeffs[10, 1] = _b[F4tau]
matrix coeffs[10, 2] = _se[F4tau]
matrix coeffs[11, 1] = _b[F5tau]
matrix coeffs[11, 2] = _se[F5tau]
matrix list coeffs

* Alternative air event study for appendix - state*yr controls
reghdfe ln_onsite_air L0tau L2tau-L`left'tau F1tau-F`right'tau if main_spec_sample==1, absorb(i.facility_id i.FIPS#i.year i.NAICS3#i.year) vce(cluster FIPS)
eststo trtPMESalt
* Saving alternative air coefficients for graph
matrix coeffsalt = J(11,3,.)
matrix colnames coeffsalt = param SE tau
forval i=-5/5 {
	local j = `i' + 6
	matrix coeffsalt[`j', 3] = `i'
}
matrix coeffsalt[1, 1] = _b[L5tau]
matrix coeffsalt[1, 2] = _se[L5tau]
matrix coeffsalt[2, 1] = _b[L4tau]
matrix coeffsalt[2, 2] = _se[L4tau]
matrix coeffsalt[3, 1] = _b[L3tau]
matrix coeffsalt[3, 2] = _se[L3tau]
matrix coeffsalt[4, 1] = _b[L2tau]
matrix coeffsalt[4, 2] = _se[L2tau]
matrix coeffsalt[5, 1] = 0
matrix coeffsalt[5, 2] = 0
matrix coeffsalt[6, 1] = _b[L0tau]
matrix coeffsalt[6, 2] = _se[L0tau]
matrix coeffsalt[7, 1] = _b[F1tau]
matrix coeffsalt[7, 2] = _se[F1tau]
matrix coeffsalt[8, 1] = _b[F2tau]
matrix coeffsalt[8, 2] = _se[F2tau]
matrix coeffsalt[9, 1] = _b[F3tau]
matrix coeffsalt[9, 2] = _se[F3tau]
matrix coeffsalt[10, 1] = _b[F4tau]
matrix coeffsalt[10, 2] = _se[F4tau]
matrix coeffsalt[11, 1] = _b[F5tau]
matrix coeffsalt[11, 2] = _se[F5tau]
matrix list coeffsalt

* County*year FE
reghdfe ln_onsite_air 1.treated, absorb(i.facility_id i.FIPS#i.year) vce(cluster FIPS) old
eststo PMctyXyrFE
gen primaryflag=e(sample)

* County-yr and NAICS-yr FE
reghdfe ln_onsite_air 1.treated, absorb(i.facility_id i.FIPS#i.year i.NAICS3#i.year) vce(cluster FIPS) old
eststo PMCtyYrNCSyrFE

* Saving data with treatment variable
save "`work'/Data/Masters/PM_treatment.dta", replace

* Table output
esttab trtPM PMctyXyrFE PMCtyYrNCSyrFE ///
	using "`work'/Tables/Treatment.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	compress label tex replace nogaps

* Air treatments, alternative distance cutoffs
rename treated treated_primary
forval i = 1/10 {
	rename treated`i' treated
	xtreg ln_onsite_air i.year 1.treated if primaryflag==1, fe vce(cluster FIPS)
	eststo dist`i'
	rename treated treated`i'
}
rename treated_primary treated /* restores correct treatment variable */
esttab dist1 dist2 trtPM dist3 dist4 ///
	using "`work'/Tables/Treatment_diff_cutoffs.tex", keep(1.treated) se ///
	mtitles("<`cutoff9'km" "<`cutoff8'km" "<`cutoff1'km" "<`cutoff2'km" "<`cutoff'km" "<`cutoff3'km" "<`cutoff4'km" "<`cutoff5'km" "<`cutoff6'km") ///
	indicate("Year FE=*.year" "Plant FE=_cons") ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	compress label tex replace nogaps
	
preserve
************************
* Graphs
************************
* Graph - air event study
matrix list coeffs
drop tau /* have to drop existing tau variable or it won't allow me to save coefficient matrix */
svmat coeffs, names(col)
keep param SE tau
keep if !missing(param)
gen lower = param - (1.96*SE)
gen upper = param + (1.96*SE)
save "`work'/Data/Estimates/event_study_SP16.dta", replace
twoway connected param tau || line lower upper tau, lpattern(shortdash shortdash) lcolor(gs8 gs8) sort xlabel(-5(1)5) xtitle("{&tau}") ytitle("Coefficient estimate") legend(off) scheme(s2mono) name(air, replace)
graph export "`work'/Graphs/Event_study.eps", as(eps) replace

* Graph - alternative air event study
matrix list coeffsalt
drop param SE tau upper lower /* have to drop existing variables or it won't allow me to save coefficient matrix */
svmat coeffsalt, names(col)
keep if !missing(param)
gen lower = param - (1.96*SE)
gen upper = param + (1.96*SE)
save "`work'/Data/Estimates/event_study_SP16_alt.dta", replace
twoway connected param tau || line lower upper tau, lpattern(shortdash shortdash) lcolor(gs8 gs8) sort xlabel(-5(1)5) xtitle("{&tau}") ytitle("Coefficient estimate") legend(off) scheme(s2mono) name(water, replace)
graph export "`work'/Graphs/Event_study_alt.eps", as(eps) replace

* Closing graph windows
window manage close graph _all
restore
	
} /* End primary */
	

if `GE'==1 {	
**********************
* Test for GE leakage
**********************
replace fips_state = 99 if missing(fips_state)
replace NAICS_consistent=999999 if missing(NAICS_consistent)
bysort facility_id: egen FIPSmode = mode(FIPS)
replace FIPS = FIPSmode if missing(FIPS)
drop FIPSmode
bysort year fips_state: egen total_treated = total(treated)
bysort year fips_state NAICS_consistent: egen total_treated6 = total(treated)
eststo clear
eststo: xtreg ln_onsite_air i.year total_treated if nonattainPWPM==0, fe vce(cluster FIPS)
eststo: xtreg ln_onsite_air i.year total_treated6 if nonattainPWPM==0, fe vce(cluster FIPS)
esttab using "`work'/Tables/Treatment_GEleak.tex", keep(total_treated*) se ///
	indicate("Year FE=*.year" "Plant FE=_cons") ///
	coeflabels(total_treated "Num. treated plants (state)" total_treated6 "Num. treated plants (state \& industry)") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	compress label tex replace
} /* End GE*/
	

if `differences'==1 {
****************************
* Difference specification
* Matches Greenstone and Gamper-Rabindran
****************************
eststo clear
sort facility_id year
* County-year FE
reghdfe ln_onsite_air 1.treated, absorb(i.facility_id i.FIPS#i.year) old
gen basesampleflag = e(sample)
* Treatment differences
eststo: reghdfe D.ln_onsite_air 1.treated, absorb(i.year) vce(cluster FIPS) old
generate diffsampleflag = e(sample)
* NA status
eststo: reghdfe ln_onsite_air 1.lag_nonattain if basesampleflag==1, absorb(i.facility_id i.year) vce(cluster FIPS) old
* NA Differences
eststo: reghdfe D.ln_onsite_air 1.lag_nonattain if diffsampleflag==1, absorb(i.year) vce(cluster FIPS) old
esttab using "`work'/Tables/Treatment_diffs.tex", keep(1.treated 1.lag_nonattain) se ///
	coeflabels(1.treated "Treated" 1.lag_nonattain "Non-attainment (t-1)") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	compress label tex replace	
} /* End differences */


if `selection'==1 {
**************************
* Test for selection bias
* NOTE data dropped here; 
* do not add models between this code block and graphs
**************************
bysort facility_id: gen counter=_N
summarize counter, detail
keep if counter==r(max)
* Models of treatment effects
eststo clear
eststo: xtreg ln_onsite_air i.year 1.treated, fe vce(cluster FIPS)
eststo: reghdfe ln_onsite_air 1.treated, absorb(i.facility_id i.FIPS#i.year) vce(cluster FIPS) old
eststo: reghdfe ln_onsite_air 1.treated, absorb(i.facility_id i.FIPS#i.year i.NAICS3#i.year) vce(cluster FIPS) old
esttab using "`work'/Tables/Treatment_selectionbias.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	compress label tex replace	
} /* End selection*/


if `spillover'==1 {
******************
* Spillover check
******************
* n.b. requires different data set, so must go at end of script
use "`work'/Data/Masters/PM_intrafirm.dta", clear
merge 1:1 facility_id year using "`work'/Data/Masters/PM_treatment.dta", keepusing(primaryflag) assert(3)
gen candidates = totplants6 - totplants_treated6
encode NAICS_cons3, generate(NAICS3)
replace NAICS3=999 if missing(NAICS3)

eststo clear
* Models of treatment effects
xtreg ln_onsite_air i.year 1.treated 1.treated#c.candidates if primaryflag==1, fe vce(cluster FIPS)
eststo trtPM

* County-yr FE
reghdfe ln_onsite_air 1.treated 1.treated#c.candidates if primaryflag==1, absorb(i.facility_id i.FIPS#i.year) vce(cluster FIPS) old
eststo ctyyrFE

* NAICS-yr FE
reghdfe ln_onsite_air 1.treated 1.treated#c.candidates if primaryflag==1, absorb(i.facility_id i.FIPS#i.year i.NAICS3#i.year) vce(cluster FIPS) old
eststo NAICSyrFE

* Table output
esttab trtPM ctyyrFE NAICSyrFE ///
	using "`work'/Tables/Treatment_spill_check.tex", keep(1.treated 1.treated#c.candidates) se ///
	coeflabels(1.treated "Treated" 1.treated#c.candidates "Treated*Num. leakage candidates") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	compress label tex replace
} /* End spillover */



timer off 1
timer list 1
capture log close





