* Analysis_exogeneity.do
* Tests exogeneity of monitor distance

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
log using "`work'/Logs/Analysis_exogeneity.log", replace


******************
* Data prep
******************
* Reading data
use "`work'/Data/Masters/PM_treatment.dta", clear

* Other variable handling
encode NAICS_cons6, generate(NAICS6)
fvset base 1 NAICS6
fvset base 2005 year

* Need to analyze log distance (distance is right-skewed)
gen ln_mindist_rolling = log(mindist_rolling)
label variable ln_mindist_rolling "ln(Dist.)"
summarize mindist_rolling, detail

* Saving tempfile
tempfile workingdata
save "`workingdata'", replace


******************
* Models & Graphs
******************
* Regress monitor distance on NAICS dummies
summarize ln_mindist_rolling mindist_rolling, detail

* Regression with constant; tests for differences from avg. monitor distance
regress ln_mindist_rolling i.NAICS6, vce(cluster FIPS)

* Regression without constant so can graph avg dist by NAICS6
regress ln_mindist_rolling i.NAICS6, nocons vce(cluster FIPS)
matrix naics = J(499,1,.)
matrix colnames naics = param
forval i = 1/500 {
	capture matrix naics[`i', 1] = _b[`i'.NAICS6] /* capture needed to handle dropped dummies */
}
svmat naics, names(col)
keep param
keep if !missing(param)
kdensity param, title("") xtitle("Coefficient")
graph export "`work'/Graphs/Dist_NAICS.eps", as(eps) replace

* Regress on emissions from untreated years (air, water, etc), multiplant dummy
use "`workingdata'", clear
eststo clear
foreach chan in ln_onsite_air ln_onsite_water ln_onsite_land ln_onsite_other ln_offsite_water ln_offsite_land ln_offsite_other ln_recy_recov_trtd {
	eststo: regress ln_mindist_rolling i.year `chan' if treated==0, vce(cluster FIPS)
}
esttab using "`work'/Tables/Dist_emissions.tex", keep(*ln_*) se ///
	indicate("Year dummies=*.year") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	label tex longtable compress nogaps replace

* Now do same in changes
use "`workingdata'", clear
eststo clear
foreach chan in D.ln_onsite_air D.ln_onsite_water D.ln_onsite_land D.ln_onsite_other D.ln_offsite_water D.ln_offsite_land D.ln_offsite_other D.ln_recy_recov_trtd {
	eststo: regress ln_mindist_rolling i.year `chan' if treated==0 & PMmindist!=0, vce(cluster FIPS)
}
esttab using "`work'/Tables/Dist_Demissions.tex", keep(*ln_*) se ///
	indicate("Year dummies=*.year") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	label tex longtable compress nogaps replace




timer off 1
timer list 1
capture log close



