* Analysis_NEI.do
* Compares NEI and TRI


capture log close
set more off
clear
local work "PATH"
log using "`work'/Logs/Analysis_NEI.log", replace
set matsize 11000


* Reading data
use "`work'/Data/NEI/TRI_NEI_merged.dta", clear
label variable ln_TRI "TRI air"
label variable ln_NEI "NEI air"

* Regressions, plant-chemical-year level
eststo clear
eststo: regress ln_NEI ln_TRI, vce(cluster eis_facility_site_id)
eststo: regress ln_NEI i.year ln_TRI, vce(cluster eis_facility_site_id)
eststo: regress ln_NEI i.year i.eis_facility_site_id ln_TRI, vce(cluster eis_facility_site_id)

* Collapse to facility-year
collapse (sum) onsite_air ann_value, by(eis_facility_site_id year)
generate ln_TRI = log(onsite_air)
generate ln_NEI = log(ann_value)
label variable ln_TRI "TRI air"
label variable ln_NEI "NEI air"

* Regressions, plant-year level
eststo: regress ln_NEI ln_TRI, vce(cluster eis_facility_site_id)
eststo: regress ln_NEI i.year ln_TRI, vce(cluster eis_facility_site_id)
eststo: regress ln_NEI i.year i.eis_facility_site_id ln_TRI, vce(cluster eis_facility_site_id)

* Table
esttab using "`work'/Tables/NEI_TRI.tex", ///
	keep(ln_TRI) ///
	indicate("Year FE=*.year" "Plant FE=*.eis_facility_site_id") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	label se tex replace



capture log close



