********************************************************************************
*
*DoFile to generate complete dataset for the analysis of:
*
*"Anticipating mediated talks  
*Predicting the timing of mediation with  
*disaggregated conflict dynamics"
*
*Constantin Ruhe, University of Konstanz
*
********************************************************************************



clear
set more off
set seed 8112278


****
**Please make sure to specify the correct working directory
cd "Z:\PhD\Paper 1\__JPR_submission\SubmissionFinal\ReplicationMaterial\GenerateData"
local w_dir =c(pwd)


*prepare ucdp GED data
do 1_merge_prepare_ucdpGED.do

*prepare ucdp GED data on OSV events
do 2_merge_prepare_ucdpGED_osv.do

*prepare ucdp MILC data
do 3_merge_prepare_MILC

*prepare country and year data taken from Quality of Government
do 4_merge_prepare_QoG

*prepare Non-State Actor data for merging
do 5_merge_prepare_NSA

*prepare data to indentify MILC sample
do 6_sample_selection


*merge GED and MILC data
local sysdate = c(current_date)
use "ucdpGED_dyadmonth_state_`sysdate'.dta", clear
sort month
sort dyad_unique, stable
drop if year<1993 | year>2004
joinby dyad_unique month using "MILC_dyadmonth_`sysdate'.dta", unmatched(both)
rename _merge _m_MILC


*fill in gaps in time series
xtset dyad_unique month
tsfill
xtset dyad_unique month
gen year_new=dofm(month)
replace year_new=yofd(year_new)
order dyad_u month year_new
drop year
rename year_n year


*fill in gaps caused by tsfill
foreach var of varlist conflict_id dyad_id side_a_id /*
*/ side_b_id cow_id gw_id reg_id dyadid {
replace `var'=L.`var' if `var'==.
}
order dyad_u month year conflict_id dyad_id dyadid side_a_id /*
*/ side_b_id cow_id gw_id reg_id 
foreach var of varlist deaths_a-crossborder incomp_gov-tp_totalpko {
replace `var'=0 if `var'==.
}


*merge osv data with GED_MILC
sort month
sort side_a_id, stable
joinby side_a_id month using "ucdpGED_dyadmonth_osv_`sysdate'_a.dta", unmatched(both)
rename _merge _m_osv_a
sort month
sort side_b_id, stable
joinby side_b_id month using "ucdpGED_dyadmonth_osv_`sysdate'_b.dta", unmatched(both)
rename _merge _m_osv_b
foreach var in c_distance_min /*
*/ c_distance_mean c_civilian_deaths c_unknown c_best_est /*
*/ c_high_est c_low_est c_fatal_events c_civilian_deaths_split /*
*/ c_unknown_split c_best_est_split c_high_est_split c_low_est_split {
replace `var'a=0 if `var'a==.
replace `var'b=0 if `var'b==.
gen `var' = `var'a + `var'b
}
order dyad_unique-crossborder c_distance_min-c_low_est_split


*save merged dataset 
save "GED_MILC_1989_2010_`sysdate'.dta", replace


*identify MILC sample and drop all other dyad years
joinby dyad_unique year using sampleselection.dta, unmatched(both)
order sampleid dyad_uni month year location sideb incomp
keep if _merge==3
rename _merge _m_sample




*merge with Non-State Actor data
local sysdate = c(current_date)
sort month
sort dyad_u, stable
joinby dyad_unique month using "NSA_`sysdate'.dta", unmatched(both)
rename _merg _m_NSA
*drop cases which are not part of the sample
drop if _m_NSA==2
list dyad_u month location sideb if _m_NSA==1 & _m_MILC==.
tab dyad_u _m_NSA, miss
twoway scatter dyad_u month if _m_NSA==3, msize(tiny) || /*
*/		scatter dyad_u month if _m_NSA==1, msize(tiny)



*generate compatible cow country code
gen name=location
replace name="Cote d'Ivoire" if name=="Cote D’Ivoire"
replace name="Democratic Republic of Congo" if name=="Democratic Republic of Congo (Zaire)"
kountry name, from(other) stuck
rename _ISO iso
kountry iso, from(iso3n) to(cown)
rename _COW ccodecow
replace ccodecow=530 if ccodecow==529
drop name iso
tab ccodecow side_a_id, miss


*merge with country characteristics data
sort year
sort ccodecow, stable
local sysdate = c(current_date)
joinby ccodecow year using "country_char_`sysdate'.dta", unmatched(both)
rename _merg _m_country
tab _m_country, miss
drop if _m_country==2


*merge with year characterististics data
sort year
local sysdate = c(current_date)
merge m:1 year using "year_char_`sysdate'.dta"
rename _merg _m_year
tab _m_year




*sort and declare panel data
sort month
sort dyad_unique, stable
xtset dyad_unique month


*save final dataset
save "GED_MILC_final_`sysdate'.dta", replace


*erase interim datasets
erase "year_char_`sysdate'.dta"
erase "country_char_`sysdate'.dta"
erase "NSA_`sysdate'.dta"
erase "GED_MILC_1989_2010_`sysdate'.dta"
erase "MILC_dyadmonth_`sysdate'.dta"
erase "ucdpGED_dyadmonth_osv_`sysdate'_a.dta"
erase "ucdpGED_dyadmonth_osv_`sysdate'_b.dta"
erase "ucdpGED_dyadmonth_complete_`sysdate'.dta"
erase "ucdpGED_dyadmonth_nonstate_`sysdate'.dta"
erase "ucdpGED_dyadmonth_osv_`sysdate'.dta"
erase "ucdpGED_dyadmonth_state_`sysdate'.dta"
erase "sampleselection.dta"



