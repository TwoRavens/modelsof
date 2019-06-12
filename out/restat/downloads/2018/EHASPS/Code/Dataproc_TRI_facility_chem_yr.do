* Dataproc_TRI_facility_chem_yr.do
* Creates alternate TRI data set at facility-year-chemical level for robustness check

capture log close
set more off
timer clear 1
timer on 1
clear
local work "PATH"
log using "`work'/Logs/Dataproc_TRI_facility_chem_yr.log", replace
set matsize 11000


* Reading data (created in TRI_county_merge.do)
use "`work'/Data/Masters/PM_facility_chemical_year.dta", clear

* Plant-chemical ID
encode chemical, generate(chemID)
egen PlantChemID = group(chemID facility_id)

* Small share of obs (1.5%) are duplicates within PlantChemID and year
* No duplicates; collapse over these
collapse (sum) Fugitive_Air Stack_Air Underground* *Landfills Land_Treatment *Surface_Impoundment ///
	POTW* M* totalreleases Releases On_site* Off_site* Energy_Recovery* Recycling* Treatment* productionwaste81thru87 One_time_Release ///
	onsite* offsite* recy_recov_trtd total_adj_releases other_media  TW* ///
	(mean) Production_Ratio ///
	, by(PlantChemID chemID poll_class year facility_id facilityname streetaddress city county population st zip latitude longitude SIC* NAICS* fips_state fips_cnty FIPS parentcompanyname parentcompanydbnumber)

* Panel in Plant-chemical and year
xtset PlantChemID year, yearly

*****************************************
* Code adapted from TRI_county_merge.do
* Occurs after collapse
*****************************************
* Fix FIPS inconsistencies; use most recent data
gsort facility_id -year
bysort facility_id: replace FIPS = FIPS[_n-1] if !missing(FIPS[_n-1])
display "Missing FIPS"
count if missing(FIPS)
display "From total"
count

* Merging county data, including own-county nonattainment status and coordinates of non-attainment monitors
destring fips_state, replace
destring fips_cnty, replace
compress
merge m:1 fips_state fips_cnty year using "`work'/Data/Masters/Counties.dta", generate(grnbkmerge)
keep if grnbkmerge==1 | grnbkmerge==3

* Filling in county nonattainment status (always-attainment counties not in above merge, so end up with missing values)
replace nonattainPWPM = 0 if missing(nonattainPWPM) & year>=1992
replace nonattainPWPM = . if year<1992 /* May have some NA monitors pre-92, but EPA NAYRO spreadsheet only goes back to 1992 */
* Merging monitors based on plant's state-county FIPS
* This will only add information for pre-1992 years
merge m:1 fips_state fips_cnty year using "`work'/Data/AQS/Annual/NA_mon_coordinates_9091.dta", update assert(1 2 4) keep(1 3 4 5) nogenerate

* Calculating distances to nonattainment monitors
* PM
display "************** PM10 distances **************"
forval i=1/12599 {
	display "Attempting to compute distance `i'"
	capture geodist latitude longitude latitude`i' longitude`i', gen(PMdist`i')
	capture replace PMdist`i' = . if (PMdist`i' > 257 & !missing(PMdist`i'))
	capture drop latitude`i' longitude`i'
}
egen PMmindist = rowmin(PMdist1-PMdist12581)
forval i=1/12599 {
	capture drop PMdist`i'
}


* Log variables and compute ratios
foreach z in onsite_air onsite_water onsite_land onsite_other offsite_water offsite_land offsite_other recy_recov_trtd other_media {
	gen ln_`z' = log(`z')
	gen ln_rat_`z' = ln_`z' - ln_onsite_air
}
foreach z in TWonsite_air TWonsite_water TWonsite_land TWonsite_other TWoffsite_water TWoffsite_land TWoffsite_other TWrecy_recov_trtd TWother_media {
	gen ln_`z' = log(`z')
	gen ln_rat_`z' = ln_`z' - ln_TWonsite_air
}

* Variable labels
label variable ln_onsite_air "Onsite air"
label variable ln_TWonsite_air "Onsite air"
label variable ln_onsite_water "Onsite water"
label variable ln_TWonsite_water "Onsite water"
label variable ln_rat_onsite_water "Onsite water"
label variable ln_rat_TWonsite_water "Onsite water"
label variable ln_onsite_land "Onsite land"
label variable ln_TWonsite_land "Onsite land"
label variable ln_rat_onsite_land "Onsite land"
label variable ln_rat_TWonsite_land "Onsite land"
label variable ln_onsite_other "Onsite other"
label variable ln_TWonsite_other "Onsite other"
label variable ln_rat_onsite_other "Onsite other"
label variable ln_rat_TWonsite_other "Onsite other" 
label variable ln_offsite_water "Offsite water"
label variable ln_TWoffsite_water "Offsite water"
label variable ln_rat_offsite_water "Offsite water"
label variable ln_rat_TWoffsite_water "Offsite water"  
label variable ln_offsite_land "Offsite land"
label variable ln_TWoffsite_land "Offsite land"
label variable ln_rat_offsite_land "Offsite land" 
label variable ln_rat_TWoffsite_land "Offsite land"
label variable ln_offsite_other "Offsite other"
label variable ln_TWoffsite_other "Offsite other"
label variable ln_rat_offsite_other "Offsite other"
label variable ln_rat_TWoffsite_other "Offsite other"
label variable ln_other_media "Other media"
label variable ln_TWother_media "Other media"
label variable ln_rat_other_media "Other media"
label variable ln_rat_TWother_media "Other media"
label variable ln_recy_recov_trtd "Recycled or treated"
label variable ln_TWrecy_recov_trtd "Recycled or treated"
label variable ln_rat_recy_recov_trtd "Recycled or treated"
label variable ln_rat_TWrecy_recov_trtd "Recycled or treated"

* Save analysis data set
compress
save "`work'/Data/Masters/PM_chemical_panel.dta", replace


timer off 1
timer list 1
capture log close


