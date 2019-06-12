* Dataproc_DMR.do
* Processes merged TRI-DMR data from EPA reporting tool
* https://cfpub.epa.gov/dmr/tri_search.cfm

capture log close
set more off
timer clear 1
timer on 1
clear
local work "PATH"
log using "`work'/Logs/Dataproc_DMR.log", replace
set matsize 11000


* Crosswalk from DMR names to Greenstone names
* Based on DMR names that did not initially merge
import excel using "`work'/Data/DMR/Greenstone_crosswalk.xlsx", sheet("Crosswalk") cellrange(A1:B61) firstrow
rename greenstonechemname chemical
rename dmrchemname chemicalgroup
save "`work'/Data/DMR/Greenstone_crosswalk.dta", replace

* Processing DMR data
* Reading and saving
forval i = 0/8 {
	import delimited using "`work'/Data/DMR/Raw/compareDMRTRI_08212017 (`i').csv", varnames(6) rowrange(6:) clear
	generate year = 2007 + `i'
	save "`work'/Data/DMR/Processed/compareDMRTRI_08212017 (`i').dta", replace
}

* Appending
clear
forval i = 0/8 {
	append using "`work'/Data/DMR/Processed/compareDMRTRI_08212017 (`i').dta"
}

* Cleaning
* TRI vars show up as strings because of scientific notation in a small number of obs (e.g. 10E-7)
destring tripoundslbsyr tritwpelbseqyr, force replace

* Subset to chemicals reported in both data sets
keep if !missing(tripoundslbsyr) & !missing(dmrpoundslbsyr)

* Merging Greenstone crosswalk
merge m:1 chemicalgroup using "`work'/Data/DMR/Greenstone_crosswalk.dta", nogenerate assert(1 3)
replace chemical = chemicalgroup if missing(chemical)

* Merge in Greenstone data so can focus on PM
* chemicalgroup is var in DMR data
merge m:1 chemical using "`work'/Data/Greenstone/Greenstone.dta", keep(1 3)

* Subset to TSPs
keep if TSP==1

* Logs
gen lndmr = log(dmrpoundslbsyr)
gen lntri = log(tripoundslbsyr)

* Saving
encode uin, generate(facilityID)
encode chemical, generate(chemID)
compress
label variable tripoundslbsyr "TRI water"
label variable dmrpoundslbsyr "DMR water"
label variable tripoundslbsyr "TRI water"
label variable dmrpoundslbsyr "DMR water"
save "`work'/Data/DMR/DMR.dta", replace

* Collapse to facility level
collapse (sum) dmrpoundslbsyr loadoverlimitlbsyr tripoundslbsyr dmrtwpelbseqyr loadoverlimitlbseqyr tritwpelbseqyr, by(year facilityID uin)

* Logs
gen lndmr = log(dmrpoundslbsyr)
gen lntri = log(tripoundslbsyr)

* Declaring panel
xtset facilityID year
 
* Saving
label variable tripoundslbsyr "TRI water"
label variable dmrpoundslbsyr "DMR water"
label variable lntri "TRI water"
label variable lndmr "DMR water"
compress
save "`work'/Data/DMR/DMR_byfacility.dta", replace






timer off 1
timer list 1
capture log close


