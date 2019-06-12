* Dataproc_intrafirm.do

capture log close
set more off
timer clear 1
timer on 1
clear
local work "PATH"
log using "`work'/Logs/Dataproc_intrafirm.log", replace


	
* Reading data
use "`work'/Data/Masters/PM_treatment.dta", clear

* Saving file for manual cleaning
* This step largely reliant on parent company name
* Fixes cases in which facilities gave location-specific DUNS numbers rather than parent firm numbers
replace parentcompanydbnumber = trim(parentcompanydbnumber)
replace parentcompanyname = trim(parentcompanyname)
replace parentcompanydbnumber="" if (parentcompanydbnumber=="NA" | parentcompanydbnumber=="N/A")
replace parentcompanyname="" if (parentcompanyname=="NA")
preserve
keep parentcompanyname parentcompanydbnumber
duplicates drop
sort parentcompanyname parentcompanydbnumber
generate DUNS_cleaned=""
save "`work'/Data/TRI/Processed/FirmNamesDUNS.dta", replace
restore

* Merge in cleaned DUNS numbers
* Cleaning in 2 passes: 1) sort by firm name; 2) sort by DUNS number
merge m:1 parentcompanyname parentcompanydbnumber using "`work'/Data/TRI/Processed/FirmNamesDUNS_cleaned.dta", assert(3) nogenerate

* Encoding cleaned firm identifier
encode DUNS_cleaned, generate(firmid)

* Minor cleaning to FIPS & NAICS6
replace NAICS_cons6 = "213113" if SIC_consistent==1241 & missing(NAICS_cons6)
replace NAICS_cons6 = "493110" if SIC_consistent==4225 & missing(NAICS_cons6)
replace NAICS_cons6 = "324122" if SIC_consistent==2952 & missing(NAICS_cons6)
bysort facility_id: egen filledFIPS=mode(FIPS), minmode
replace FIPS=filledFIPS if missing(FIPS)
drop filledFIPS
bysort facility_id: egen filledFIPSst=mode(fips_state), minmode
replace fips_state=filledFIPSst if missing(fips_state)
drop filledFIPSst


***************************************
* Other treated w/in same firm
***************************************
* Count of plants in nonattainment counties
bysort firmid year: gen totplants = _N
gen multiplant = (totplants > 1)
bysort firmid year: egen totplants_treated = total(treated)
gen otherplants_treated = totplants_treated - treated
tab otherplants_treated
summarize otherplants_treated, detail
local upper = r(max)

* Binned count of other treated plants
recode otherplants_treated (2/`upper'=2), generate(d_otherplants)

* Dummy for other plant in nonattainment county
recode d_otherplants (2/`upper'=1), generate(other_treated_dummy)
tab other_treated_dummy
summarize other_treated_dummy, detail

***************************************
* Alternative "other treated"
* by firm and NAICS
***************************************
forval j=2/6 {
	* Count of treated plants
	bysort firmid NAICS_cons`j' year: gen totplants`j' = _N
	gen multiplant`j' = (totplants`j' > 1)
	bysort firmid NAICS_cons`j' year: egen totplants_treated`j' = total(treated)
	gen otherplants_treated`j' = totplants_treated`j' - treated
	tab otherplants_treated`j'
	summarize otherplants_treated`j', detail
	local upper`j'=r(max)
	
	* Binned count of other treated plants
	recode otherplants_treated`j' (2/`upper`j''=2), generate(d_otherplants`j')
	
	* Dummy for other treated plant
	recode d_otherplants`j' (2/`upper`j''=1), generate(other_treated_dummy`j')
	tab other_treated_dummy`j'
	summarize other_treated_dummy`j', detail
}
* For 6-digit NAICS, varying threshold distance
forval j=6/6 {
	forval i = 1/4 {
		* Count of plants in nonattainment counties
		bysort firmid NAICS_cons`j' year: egen totplants_treated`j'_`i' = total(treated`i')
		gen otherplants_treated`j'_`i' = totplants_treated`j'_`i' - treated`i'
		tab otherplants_treated`j'_`i'
		summarize otherplants_treated`j'_`i', detail
		local upper`j'=r(max)
		
		* Binned count of other treated plants
		recode otherplants_treated`j'_`i' (2/`upper`j''=2), generate(d_otherplants`j'_`i')
		
		* Dummy for other plant in nonattainment county
		recode d_otherplants`j'_`i' (2/`upper`j''=1), generate(other_treated_dummy`j'_`i')
		tab other_treated_dummy`j'_`i'
		summarize other_treated_dummy`j'_`i', detail
	}
}

***************************************
* Placebo "other treated"
* by firm and NAICS
***************************************
sort facility_id year
gen far = (L2mindist_rolling > 7.73 & !missing(L2mindist_rolling))
gen placebo = L2.1.nonattainPWPM*1.far	
replace placebo = 0 if nonattainPWPM==0
forval j=2/6 {
	* Count of plants in nonattainment counties
	bysort firmid NAICS_cons`j' year: egen totplants_placebo`j' = total(placebo)
	gen otherplants_placebo`j' = totplants_placebo`j' - placebo
	tab otherplants_placebo`j'
	summarize otherplants_placebo`j', detail
	local upper`j'=r(max)
	
	* Binned count of other treated plants
	recode otherplants_placebo`j' (2/`upper`j''=2), generate(d_placebo`j')
	
	* Dummy for other plant in nonattainment county
	recode d_placebo`j' (2/`upper`j''=1), generate(placebo_dummy`j')
	tab placebo_dummy`j'
	summarize placebo_dummy`j', detail
}

* Saving
save "`work'/Data/Masters/PM_intrafirm.dta", replace



timer off 1
timer list 1
capture log close






