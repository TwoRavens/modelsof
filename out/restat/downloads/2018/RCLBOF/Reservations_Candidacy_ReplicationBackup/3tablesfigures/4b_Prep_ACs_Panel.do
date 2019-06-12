************************************************************************
***************SETUP CODE HEADER FOR ALL PROGRAMS***********************
***************									 ***********************
************************************************************************
clear
clear matrix
clear mata
cap log close
set more off, perm

global root ~/dropbox/Reservations_Candidacy_ReplicationBackup
include "$root/2progs/00_Set_paths.do"
************************************************************************
************************************************************************
import excel using "$do/merge/clean_mapdistricts_for_districthead_merge.xlsx", sheet("Sheet1") firstrow clear
keep if _merge =="master only (1)"
drop if district_replace=="missing"
drop _m
tempfile temp
save `temp'

***bring in nightlights and griddedpop data
insheet using "$root/9maps/population_join_files/converted/Nightlights_ACsDistrict_Xsect_AllStats.csv", comma names clear
//note that object_1 is the original object#
drop objectid
rename objectid_1  objectid
keep objectid mean sum
renvars mean sum \ nightlights_mean nightlights_sum
bys objectid: assert _N==1
sum objectid, d
tempfile nightlights
save `nightlights'


***bring in nightlights and griddedpop data
import delimited using "$root/9maps/population_join_files/converted/GPW_ACsDistrXsect_Join.txt", delimiters(";")  case(lower)  clear
//note that object_1 is the original object#
drop objectid  objectid_12 
rename objectid_1  objectid
replace objectid="." if objectid=="NULL"
destring objectid, replace
keep objectid vals
renvars vals \ GPW_pop_vals
count if objectid==.
drop if objectid==.
collapse (sum) GPW_pop_vals, by(objectid)
sum objectid, d
tempfile gpw
save `gpw'

***bring in crossed overlay file
insheet using "$root/9maps/AC_predelim_District_intersect.txt", comma names clear
sum objectid, d
merge 1:1 objectid using `nightlights', nogen assert(1 3)
//note that 1s here are tiny tiny areas too small to accord a raster mean -- treat as zero and dummy out later if necessary; area weighting should take care of these anyway


merge 1:1 objectid using `gpw', nogen assert(1 3)
//note that 1s here are tiny tiny areas too small to accord a value from the GPW -- treat as zero and dummy out later if necessary? area weighting should take care of these anyway
pwcorr shape_area GPW_pop_vals nightlights_mean nightlights_sum

replace state="Jammu and Kashmir" if state=="Jammu & Kashmir"
replace state="Puducherry" if state=="Pondicherry"

***clean out state mismatches due to slight deviations in the map overlays
g flag= state!=name_1
la var shape_area "Polygon area"
sutex shape_area, labels minmax par digits(5)
bys flag: sutex shape_area, labels minmax par digits(5)
la var shape_area "Polygon area, same state"
sutex shape_area if flag==0, labels minmax par digits(5)
la var shape_area "Polygon area, different state"
sutex shape_area if flag==1, labels minmax par digits(5)
sum shape_area, d
tabstat shape_area, by(flag) stat(sum)
bys flag: sum shape_area, d
drop if flag //still get rid of different-state overlaps
replace state = upper(trim(state))

***take largest district piece for AC constituency -- since they are unique to districts, everything else is erroneous overlap
gsort state ac_name -shape_area
sum shape_area, d
*bys  state ac_name: keep if _n==1 //i no longer do this in order to get the range of effect sizes based on trimming rules
sum shape_area, d //see how these are really all the small pieces
sutex shape_area, labels minmax par digits(5)

assert state==upper(trim(name_1))


***merge in district name cleaning info
replace state = upper(trim(state))
g district = upper(trim(name_2))
merge m:1 state district using `temp', assert(1 3) nogen
replace district = trim(district_replace) if !mi(district_replace)
drop district_replace

***merge in constituency info including the election year (reordering because reservations matters for election year here
g AC = upper(trim(ac_name))
count
merge m:1 state AC using  "$work/candidacy_info_by_ACconstituency", assert(1 2 3) // fix this merging later -- COME BACK TO FIX!!
keep if _m==3
drop _m

***bring in also early years information
merge m:1 state AC using  "$work/candidacy_info_by_ACconstituency_early", assert(1 2 3) // fix this merging later -- COME BACK TO FIX!!
keep if _m==3 | _m==1 //dont cut the dataset on this merge in any way
drop _m

***prep info to go out for balancing merge
preserve
collapse (mean) AC_female_share_cand_prepolicy=female_share_cand_prepolicy, by(state district)
renvars state district \ FinalState districtname
save "$work/prepolicy_AC_election_summary_district_frommapfile", replace
restore

***merge in district chairperson reservation info
***prep the yearly IMMT data
***first get the election years being used
preserve
keep state Year
duplicates drop
rename Year election_year_used
tempfile electionyear
save `electionyear'
restore

preserve
use "$data/20110220_IMMT_ReplicationData/table10a.dta", clear
gsort state dist1988 +year
bys state dist1988: g cum_distres=sum(wdistres)
**added 29 sept -- this now is in spirit with other relative exposure distance measures --- accounting for different state election years
merge m:1 state using `electionyear', keep(1 3) assert(3) nogen 
drop if year > election_year_used
g relative = election_year_used-year
sum relative, d
drop if year<1995
sum relative, d
g late = wdistres if relative<=4
g mid = wdistres if relative >4  &  relative <9
g early = wdistres if relative >=9
bys state dist1988: egen early_exposure = sum(early)
bys state dist1988: egen mid_exposure = sum(mid)
bys state dist1988: egen recent_exposure = sum(late)
assert  !mi(early_exposure)
assert  !mi(recent_exposure)
tab early_exposure recent_exposure, mi

g currently_reserved=wdistres
keep state dist1988 year cum_distres *_exposure currently_reserved
renvars dist1988 year / district Year
tempfile disthead_byyear
save `disthead_byyear'
restore
merge m:1 state district Year using `disthead_byyear', keep(3) nogen // using-only 2s are ok here because of full year dimension in using dataset


**merge in indicators
preserve
use "$dbroot/ReservationsEducation/4work/popcensus1991indicators.dta", clear
replace STATE = upper(trim(STATE))
replace Final_1 =upper(trim( Final_1 ))
tempfile distr
save `distr'
restore
g STATE = upper(trim(state))
g Final_1 =upper(trim(district))
merge m:1 STATE Final_1 using `distr', keep(1 3) nogen
drop STATE Final_1
foreach i in rural_women_literacy rural_SCST rural_women_midsch_rate rural_sexratio female_share_cand_prepolicy {
g m_`i' = mi(`i')
replace `i' = 0 if mi(`i')
}


global covariates "rural_women_literacy rural_women_midsch_rate rural_SCST rural_sexratio female_share_cand_prepolicy m_rural_women_literacy m_rural_women_midsch_rate m_rural_sexratio m_rural_SCST m_female_share_cand_prepolicy"



bys state ac_name: egen constituency_area = sum(shape_area)
g constituency_weight=ceil(shape_area/constituency_area*100)
sum constituency_weight, d

bys state ac_name: egen constituency_pop = sum(GPW_pop_vals)
bys Year: sum constituency_pop, d
bys Year: sum GPW_pop_vals, d
g constituency_pop_weight=ceil(GPW_pop_vals/constituency_pop*100)
replace  constituency_pop_weight = 0.00001 if mi(GPW_pop_vals) //correct for missing small areas but do not set as zero as they will drop out
sum constituency_pop_weight, d

//dataset ready
***predict outcome
g male_cand= count - female_candidate
replace female_votes = female_votes/100
egen districtcluster=group(state district)
g recent=Year>=2004

foreach i in female_candidate female_share_candidates male_cand female_winner female_votes /*finish_pctile*/ {
xi: reg `i'  $covariates  [w=constituency_pop_weight], cluster(districtcluster)
predict `i'_pred if e(sample), xb
}
keep if recent




save AC_analysis_dataset, replace
//end
