* Analysis_DMR.do
* Analyzes merged DMR-TRI data on TSPs

capture log close
set more off
timer clear 1
timer on 1
clear
local work "PATH"
log using "`work'/Logs/Analysis_DMR.log", replace
set matsize 11000


************************
* Chemical-level models
************************
use "`work'/Data/DMR/DMR.dta", clear

* Merging inspection flag
merge m:1 uin year using "`work'/Data/ECHO/Processed/ECHO_NPDES_inspections.dta", generate(ECHOmerge) keep(1 3)

* Setting up panel
egen ID = group(facilityID chemID) /* 17 records are multiples within ID and year */
collapse (sum) dmrpoundslbsyr tripoundslbsyr, by(ID facilityID year ECHOmerge)
generate lndmr = log(dmrpoundslbsyr)
generate lntri = log(tripoundslbsyr)
xtset ID year

* Log regressions - all DMR-TRI records
eststo clear
regress lndmr lntri, vce(cluster facilityID)
eststo mod1
regress lndmr i.year lntri, vce(cluster facilityID)
eststo mod2
regress lndmr i.facilityID i.year lntri, vce(cluster facilityID)
eststo mod3

* Log regressions - records with sampling inspections
regress lndmr lntri if ECHOmerge==3, vce(cluster facilityID)
eststo mod1a
regress lndmr i.year lntri if ECHOmerge==3, vce(cluster facilityID)
eststo mod2a
regress lndmr i.facilityID i.year lntri if ECHOmerge==3, vce(cluster facilityID)
eststo mod3a

* DMR time series models
regress lndmr 3.ECHOmerge L.lndmr c.L.lndmr#3.ECHOmerge, vce(cluster facilityID)
eststo ts1
regress lndmr i.year 3.ECHOmerge L.lndmr c.L.lndmr#3.ECHOmerge, vce(cluster facilityID)
eststo ts2
regress lndmr i.year i.facilityID 3.ECHOmerge L.lndmr c.L.lndmr#3.ECHOmerge, vce(cluster facilityID)
eststo ts3


************************
* Facility-level models
************************
use "`work'/Data/DMR/DMR_byfacility.dta", clear

* Merging inspection flag
merge 1:1 uin year using "`work'/Data/ECHO/Processed/ECHO_NPDES_inspections.dta", generate(ECHOmerge) keep(1 3)

* Log regressions
regress lndmr lntri, vce(cluster facilityID)
eststo mod4
regress lndmr i.year lntri, vce(cluster facilityID)
eststo mod5
regress lndmr i.facilityID i.year lntri, vce(cluster facilityID)
eststo mod6

* Log regressions - records with sampling inspections
regress lndmr lntri if ECHOmerge==3, vce(cluster facilityID)
eststo mod4a
regress lndmr i.year lntri if ECHOmerge==3, vce(cluster facilityID)
eststo mod5a
regress lndmr i.facilityID i.year lntri if ECHOmerge==3, vce(cluster facilityID)
eststo mod6a

* DMR time series models
sort facilityID year
regress lndmr 3.ECHOmerge L.lndmr c.L.lndmr#3.ECHOmerge, vce(cluster facilityID)
eststo ts4
regress lndmr i.year 3.ECHOmerge L.lndmr c.L.lndmr#3.ECHOmerge, vce(cluster facilityID)
eststo ts5
regress lndmr i.year i.facilityID 3.ECHOmerge L.lndmr c.L.lndmr#3.ECHOmerge, vce(cluster facilityID)
eststo ts6


************************
* Tables
************************
esttab mod1 mod2 mod3 mod4 mod5 mod6 using "`work'/Tables/DMR_TRI.tex", ///
	keep(lntri) ///
	indicate("Year FE=*.year" "Plant FE=*.facilityID") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	label se tex replace

* Table for inspected records	
esttab mod1a mod2a mod3a mod4a mod5a mod6a using "`work'/Tables/DMR_TRI_inspected.tex", ///
	keep(lntri) ///
	indicate("Year FE=*.year" "Plant FE=*.facilityID") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	label se tex replace	

* Table for DMR time series
esttab ts1 ts2 ts3 ts4 ts5 ts6 using "`work'/Tables/DMR_timeseries.tex", ///
	keep(L.lndmr 3.ECHOmerge#cL.lndmr) ///
	coeflabels(3.ECHOmerge#cL.lndmr "Inspection*L.DMR water") ///
	indicate("Year FE=*.year" "Plant FE=*.facilityID") ///
	star(* 0.10 ** 0.05 *** 0.01) ///
	label se tex replace



timer off 1
timer list 1
capture log close


