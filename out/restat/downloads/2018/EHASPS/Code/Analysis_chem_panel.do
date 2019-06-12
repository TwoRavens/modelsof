* Analysis_chem_panel.do
* Analyzes xmedia substitution at plant-chem-year level to rule out composition effects

capture log close
set more off
timer clear 1
timer on 1
clear
local work "PATH"
log using "`work'/Logs/Analysis_chem_panel.log", replace
set matsize 11000

* Reading data
use "`work'/Data/Masters/PM_chemical_panel.dta", clear


*****************************************
* Code copied from Analysis_treatment.do
*****************************************
* Dropping facilities with no air emissions - should not be affected by CAA
bysort facility_id: egen max_air = max(onsite_air)
drop if max_air==0 | missing(max_air)
* Setting base year (avoids estout errors)
fvset base 2005 year

*****************************************
* Merging treatment variable
* (created in Analysis_treatment.do)
*****************************************
merge m:1 facility_id year using "`work'/Data/Masters/PM_treatment.dta", keepusing(treated) keep(3)


***********************
* Xmedia analysis
***********************
* For specs with NAICS-yr or state-yr FE
replace NAICS_consistent=999999 if missing(NAICS_consistent)
replace fips_state=99 if missing(fips_state)
encode NAICS_cons3, generate(NAICS3)
replace NAICS3=999 if missing(NAICS3)

* Opening loop over channels
eststo clear
foreach channel in onsite_water onsite_land onsite_other offsite_water offsite_land offsite_other recy_recov_trtd {
	
	fvset base 2008 year	
	sort facility_id year
	display "************** PM -- `channel' **************"

	* Ratio models
	xtreg ln_rat_`channel' i.year 1.treated, fe vce(cluster FIPS)
	eststo `channel'nolag

	* County*year FE - ratios
	reghdfe ln_rat_`channel' 1.treated, absorb(i.PlantChemID i.FIPS#i.year) vce(cluster FIPS)
	eststo `channel'rtctyXyrFE
	
	* State*year FE and NAICS*yr FE - ratios
	reghdfe ln_rat_`channel' 1.treated, absorb(i.PlantChemID i.FIPS#i.year i.NAICS3#i.year) vce(cluster FIPS)
	eststo `channel'CtyNcsYrFEr
* End loop over channels	
}
* Ratio table
esttab *nolag using "`work'/Tables/Xmedia_PM_chempanel.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	topfile("`work'/Tables/SP16/Xmedia_top_chempanel.tex") ///
	postfoot("\hline\hline") ///
	noobs ///
	longtable fragment compress label tex replace
esttab *rtctyXyrFE using "`work'/Tables/Xmedia_PM_chempanel.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	prehead("\multicolumn{1}{l}{Panel B: County*year FE} \\") ///
	nomtitles nonumbers noobs ///
	postfoot("\hline\hline") ///
	longtable fragment compress label tex append
esttab *CtyNcsYrFEr using "`work'/Tables/Xmedia_PM_chempanel.tex", keep(1.treated) se ///
	coeflabels(1.treated "Treated") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	prehead("\multicolumn{1}{l}{Panel C: County*year \& industry*year FE} \\") ///
	nomtitles nonumbers ///
	bottomfile("`work'/Tables/SP16/Xmedia_bottom.tex") ///
	longtable fragment compress label tex append

timer off 1
timer list 1
capture log close


