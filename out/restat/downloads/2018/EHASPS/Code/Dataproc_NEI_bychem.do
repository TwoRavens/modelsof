* Dataproc_NEI_bychem.do
* Reads in EPA National Emissions Inventory at facility-chemical level for 2008, 2014. Flat file by chemical not available 2011.


capture log close
set more off
clear
local work "PATH"
log using "`work'/Logs/Dataproc_NEI_bychem.log", replace
set matsize 11000


* Flow control locals
local import = 0
local processing = 0
local TRImerge = 1



****************
* Importing
****************
if `import'==1 {

* NEI-TRI xwalk
import delimited using "`work'/Data/NEI/TRI_EIS_2008_xwlk.csv", delimiters(",") varnames(1) clear
keep eis_id tri_id
rename eis_id eis_facility_site_id
duplicates drop
* There is one TRI ID that occurs twice: 77651TXCCHHWY36. Huntsman Petrochemical facility in TX. But one of the associated EIS IDs doesn't occur in EIN data. Dropping.
drop if tri_id=="77651TXCCHHWY36" & eis_facility_site_id==9111311
save "`work'/Data/NEI/TRI_EIS_2008_xwlk.dta", replace

* 2008 data
* Facility-level file
import delimited using "`work'/Data/NEI/2008NEIv3_POINT_20130206.csv", delimiters(",") varnames(107) rowrange(108:) clear

* Cross-sectional resolution is below the facility level (process-level), so must collapse
* Numbers in the "poll" field are CAS compound IDs
collapse (sum) ann_value, by(facility_id calc_year poll)

* Variable handling
rename calc_year year

* Output
compress
save "`work'/Data/NEI/NEI_PM_2008_bychem.dta", replace

* 2014 data
* Facility-level file
import delimited using "`work'/Data/NEI/SmokeFlatFile_POINT_20160928.csv", delimiters(",") varnames(106) rowrange(107:) clear

* Collapsing to facility-year
collapse (sum) ann_value, by(facility_id calc_year poll)

* Variable handling
rename calc_year year

* Output
compress
save "`work'/Data/NEI/NEI_PM_2014_bychem.dta", replace
}


****************
* Processing
****************
if `processing'==1 {

* Appending
use "`work'/Data/NEI/NEI_PM_2008_bychem.dta", clear
append using "`work'/Data/NEI/NEI_PM_2014_bychem.dta"

* Variable handling
destring poll, generate(cas) force
rename facility_id eis_facility_site_id

* Declaring panel
drop if missing(cas)
egen ID = group(eis_facility_site_id cas)
xtset ID year

* Descriptive stats
summarize ann_value, detail

* Output
save "`work'/Data/NEI/NEI_bychem.dta", replace
}


****************
* Merging
****************
if `TRImerge'==1 {

* Reading TRI data
use "`work'/Data/Masters/PM_facility_chemical_year.dta", clear

* Subset to years where NEI exists (2008 NEI not available at chemical level)
keep if year==2008 | year==2014

* Merge prep: xwalk
generate tri_id = trim(trifacilityid)

* Merging NEI-TRI xwalk
merge m:1 tri_id using "`work'/Data/NEI/TRI_EIS_2008_xwlk.dta", keep(3) nogenerate

* Merge prep: NEI
drop if missing(eis_facility_site_id) /* Crosswalk indicates no mapping even through TRI id is found in xwalk file */
drop if missing(cas) /* Some values of "poll" in NEI data are not compound IDs */
collapse (sum) onsite_air, by(eis_facility_site_id cas year)
egen ID = group(eis_facility_site_id cas)
xtset ID year

* Merging NEI emissions
* On TRI side, compoundid is string and cas is numeric
merge 1:1 eis_facility_site_id cas year using "`work'/Data/NEI/NEI_bychem.dta", keep(1 3) keepusing(ann_value) generate(NEImerge)

* Variable handling
generate ln_TRI = log(onsite_air)
generate ln_NEI = log(ann_value)

* Output
save "`work'/Data/NEI/TRI_NEI_merged.dta", replace

}










capture log close
