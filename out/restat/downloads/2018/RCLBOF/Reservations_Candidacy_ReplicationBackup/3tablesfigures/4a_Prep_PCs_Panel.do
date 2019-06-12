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


import excel using "$do/merge/clean_mapconstituencies_for_electionsdata_merge.xlsx", sheet("Sheet1") firstrow clear
keep if _merge =="master only (1)"
drop _m
tempfile temp2
save `temp2'


***bring in nightlights and griddedpop data
insheet using "$root/9maps/population_join_files/converted/Nightlights_LS15District_Xsect_AllStats.csv", comma names clear
//note that this has been exported and saved differently so objectid is the right one to go with here
keep objectid mean sum
renvars mean sum \ nightlights_mean nightlights_sum
bys objectid: assert _N==1
sum objectid, d
tempfile nightlights
save `nightlights'


***bring in nightlights and griddedpop data
import delimited using "$root/9maps/population_join_files/converted/GPW_LS15DistrXsect_Join.txt", delimiters(";")  case(lower)  clear
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
insheet using "$root/9maps/LS15_PCs_intersect_Districts.txt", comma names clear
sum objectid, d

//merge in weighting variants
merge 1:1 objectid using `nightlights', nogen assert(1 3)
merge 1:1 objectid using `gpw', nogen assert(1 3)


//continue
replace state="Andaman and Nicobar" if state=="Andaman & Nicobar Island"
replace state="Chhattisgarh" if state=="Cahhttisgarh"
replace state="Dadra and Nagar Haveli" if state=="Dadra & Nagar Haveli"
replace state="Daman and Diu" if state=="Daman & Diu"
replace state="Jammu and Kashmir" if state=="Jammu & Kashmir"
replace state="Puducherry" if state=="Pondicherry"
replace state="Uttaranchal" if state=="Uttrakhand"

g flag= state!=name_1
sum shape_area, d

la var shape_area "Polygon area, full sample"
sutex shape_area, labels minmax par digits(5)
la var shape_area "Polygon area, same state"
sutex shape_area if flag==0, labels minmax par digits(5)
la var shape_area "Polygon area, different state"
sutex shape_area if flag==1, labels minmax par digits(5)


tabstat shape_area, by(flag) stat(sum)
bys flag: sum shape_area, d


**drop really small areas
g flag2 = shape_area<.04 
la var shape_area "Polygon area, small polygons"
sutex shape_area if flag2, labels minmax par digits(5)
tabstat shape_area, by(flag2) stat(sum)
histogram shape_area
drop if flag
drop flag flag2
sum shape_area, d
assert state==name_1
la var shape_area "Polygon area, final sample"
sutex shape_area, labels minmax par digits(5)

histogram shape_area


***constituencies are the focal unit: construct area shares that add to 1 within a constituency
bys state const_name: egen total_const_area = sum(shape_area)
g constituency_weight = ceil(shape_area/total_const_area*100)

bys state const_name: egen constituency_pop = sum(GPW_pop_vals)
g constituency_pop_weight=ceil(GPW_pop_vals/constituency_pop*100)
replace  constituency_pop_weight = 0.00001 if mi(GPW_pop_vals) //correct for missing small areas but do not set as zero as they will drop out
sum constituency_pop_weight, d


***merge in district chairperson reservation info
replace state = upper(trim(state))
g district = upper(trim(name_2))
merge m:1 state district using `temp', assert(1 3) nogen
replace district = trim(district_replace) if !mi(district_replace)
drop district_replace
merge m:1 state district using "$work/districthead_orig", assert(1 3) keep(3) nogen

***merge in constituency info
g constituency = upper(trim(const_name))
merge m:1 state constituency using `temp2', assert(1 3)
replace constituency = trim(constituency_replace) if !mi(constituency_replace)
drop constituency_replace
cap drop _m
merge m:1 state constituency using "$work/candidacy_info_by_constituency" //, assert(2 3)
keep if _m==3 // drops 6 small places
drop _m

merge m:1 state constituency using "$work/candidacy_info_by_constituency_1991", assert(1 2 3)
keep if _m==3 | _m==1
drop _m

***get 1991 characteristics for merging by district
preserve
collapse (mean) female_share_candidates_1991 [w=constituency_pop_weight], by(state district)
rename state FinalState
rename district districtname
save "$work/1991_PC_election_summary_district_frommapfile", replace
restore


**merge in indicators
preserve
use "$work/popcensus1991indicators.dta", clear
replace STATE = upper(trim(STATE))
replace Final_1 =upper(trim( Final_1 ))
tempfile distr
save `distr'
restore
g STATE = upper(trim(state))
g Final_1 =upper(trim(district))
merge m:1 STATE Final_1 using `distr', keep(1 3) nogen
drop STATE Final_1
foreach i in rural_women_literacy rural_SCST rural_women_midsch_rate rural_sexratio female_share_candidates_1991 {
g m_`i' = mi(`i')
replace `i' = 0 if mi(`i')
}


save PC_analysis_dataset, replace
//end


