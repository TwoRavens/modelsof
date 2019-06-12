* Dataproc_TRI_cnty_merge.do
* Merges coordinates of NA monitors onto TRI data by county, computes minimum distances

capture log close
set more off
timer clear 1
timer on 1
clear
clear matrix
clear mata
set matsize 11000
set maxvar 32767
set emptycells drop


* Path locals
local work "PATH"
cd "`work'"
log using "`work'/Logs/Dataproc_cnty_merge.log", replace


* Reading TRI data
use "`work'/Data/TRI/Processed/TRI.dta", clear

* Subset to pollutant category
keep if PM==1
gen poll_class = "PM"
encode trifacilityid, gen(facility_id)

* Fix inconsistencies in SIC & NAICS within yr (firms sometimes put different industry codes for different chemicals)
bysort facility_id: egen SIC_consistent = mode(primarysic), minmode
bysort facility_id: egen NAICS_consistent = mode(primarynaics), minmode
tostring SIC_consistent, gen(tempvar)
gen SIC_cons2 = substr(tempvar, 1, 2)
gen SIC_cons3 = substr(tempvar, 1, 3)
destring SIC_cons2 SIC_cons3, replace
drop tempvar
tostring NAICS_consistent, gen(tempvar)
forval i=2/6 {
	gen NAICS_cons`i' = substr(tempvar, 1, `i')
	replace NAICS_cons`i' = "" if NAICS_cons`i'=="."
}
drop tempvar

replace chemical=trim(chemical)
* Excluding ozone depleting chemicals subject to mandatory phaseouts under CAA (per Gamper-Rabindran)
drop if chemical=="CARBON TETRACHLORIDE"
drop if chemical=="1,1,1-TRICHLOROETHANE"
* Excluding chems for which reporting requirements cause paper emissions reductions (per Gamper-Rabindran)
drop if chemical=="AMMONIUM SULFATE (SOLUTION)"

* Additional variables for regression models
* aggregations based on data documentation
* onsite
gen onsite_air = Fugitive_Air + Stack_Air
rename Water onsite_water
replace Other_Surface_Impoundment = 0 if abs(Other_Surface_Impoundment-Surface_Impoundment)<1 /* Many facilities list the same amount in both fields, so zeroing out the "Other" to avoid double-counting */
replace Other_Surface_Impoundment = 0 if abs(RCRA_C_Surface_Impoundment-Other_Surface_Impoundment)<1 /* as above, fixes double counting */
replace RCRA_C_Surface_Impoundment = 0 if abs(RCRA_C_Surface_Impoundment-Surface_Impoundment)<1 /* as above, fixes double counting */
gen onsite_land = Underground_Class_I+Underground_Class_II_V+RCRA_C_Landfills+Other_Landfills+Land_Treatment+Surface_Impoundment+RCRA_C_Surface_Impoundment+Other_Surface_Impoundment
rename Other_Disposal onsite_other
* offsite
gen offsite_water = POTW___Total_Transfers + M62
gen offsite_land = M71 + M81 + M82 + M72 + M63 + M66 + M67 + M64 + M65 + M73 + M79
gen offsite_other = M90 + M94 + M99 + M40 + M61 + M10 + M41
* n.b. TRI subtotals for below categories proved unreliable, so computing from components
gen offsite_recycled = M20 + M24 + M26 + M28 + M93
gen offsite_recovered = M56 + M92
gen offsite_treated = (M40 + M50 + M54 + M61 + M69 + M95) - (M40 + M61) /* need to subtract off since counting these under offsite_other above */
* total
gen total_adj_releases = totalreleases + POTW___Non_Metals + M81 + M82 + M66 + M67 + offsite_recycled + offsite_recovered + offsite_treated
replace total_adj_releases = total_adj_releases + M40 + M61 if (metalcategory==0) | (metalcategory==2)

* Additional aggregation to simplify tables
gen recy_recov_trtd = offsite_recycled + offsite_recovered + offsite_treated
gen other_media = (onsite_water + onsite_land + onsite_other) + (offsite_water + offsite_land + offsite_other + recy_recov_trtd)

* Generating toxicity-weighted variables
* Following Gamper-Rabindran, using oral weights for non-air releases
gen TWonsite_air = inhaltoxscore * onsite_air
foreach x in onsite_water onsite_land onsite_other offsite_water offsite_land offsite_other recy_recov_trtd other_media {
	gen TW`x' = oraltoxscore * `x'
}

* Save analysis data set at facility-chemical-year level
save "`work'/Data/Masters/PM_facility_chemical_year.dta", replace

* Collapse over pollutants to facility-pollutant type level
collapse (sum) Fugitive_Air Stack_Air Underground* *Landfills Land_Treatment *Surface_Impoundment ///
	POTW* M* totalreleases Releases On_site* Off_site* Energy_Recovery* Recycling* Treatment* productionwaste81thru87 One_time_Release ///
	onsite* offsite* recy_recov_trtd total_adj_releases other_media  TW* ///
	(mean) Production_Ratio ///
	, by(poll_class year facility_id facilityname streetaddress city county population st zip latitude longitude SIC* NAICS* fips_state fips_cnty FIPS parentcompanyname parentcompanydbnumber)

* Fix FIPS inconsistencies; use most recent data, as they are more accurate
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
merge m:1 fips_state fips_cnty year using "`work'/Data/Masters/Counties.dta", /*keep(1 3)*/ generate(grnbkmerge)
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

* Panel setup
xtset facility_id year, yearly

* Save analysis data set
save "`work'/Data/Masters/PM.dta", replace



timer off 1
timer list 1
capture log close




