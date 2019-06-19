*****************************
* DOES PLANNING REGULATION PROTECT INDEPENDENT RETAILERS?
* Do file to merge retail panel with all other local authority data (elections demographics etc.)
* Created by Raffaella Sadun (rsadun@hbs.edu)
*****************************
cd "T:\LSE\Raffaella_Sadun\_Papers Replication\Retail\data"

* Prepare merge for main results
clear
clear matrix
set mem 500m
u ret_home_pop, replace
keep if type==1
global control_A "i.year"
xi:  keep  $alt_iv maj_gra_cum sha_seat_CON_cum la_name delta_emp sup sup_sha $demand_B $control_B la_co year sha_pop $control_A la_code $demand gor_n pop_y maj_gra_lag* sha_seat_CON_lag2 entry_j_type exit_j_type exp_j_type contr_j_type gro_type
rename delta_emp delta_emp_indep
so la_co year
duplicates drop 
so la_code year
foreach var in entry_j_type exit_j_type exp_j_type contr_j_type gro_type {
rename `var' `var'_indep
} 
save ret_home_pop_basic_entry, replace

u ret_home_pop_basic_entry, replace
merge 1:m la_code year using datachains_sept12_v1
keep if _m==3 
drop _m
cap drop ln_pop
ge ln_pop=ln(pop_y)
ta year, ge(yy)
replace delta_emp_cc1=delta_emp_indep
drop if m_very==1
drop if delta_emp_tt3==.
sa ret_home_pop_chains_pro_v2, replace

* Prepare file for fixed effect spec (include 1998)
u ret_home_pop_chains_pro_v2, replace
keep la_code year
duplicates drop 
so la_code year
save new_la_list, replace

u ret_home_pre1, clear
keep if type==1
so la_code year
merge m:1 la_code year using new_la_list
keep if _m==3 | year==1998
bys la_code: egen m=max(_m)
keep if m==3
drop m _m
gen m_very=1
xi: keep la_co maj_gra_cum sha_seat_CON_cum la_name delta_emp  $demand_fe $control_A la_code year sha_pop pop_y emp
rename emp emp_indep
so la_code year
save ret_home_pop_basic_entry_fe, replace

u ret_home_pop_basic_entry_fe, replace
merge 1:m la_code year using datachains_sept12_v1
keep if _m==3 
drop _m
cap drop ln_pop
ta year, ge(yy)
replace agg_emp_cc1=emp_indep
sa ret_home_pop_chains_pro_v2_fe, replace

* Prepare file for reallocation table
u ret_home_pop_basic_entry, replace
merge 1:m la_code year using creation_ally_la_type_long
keep if _m==3 
drop _m
so la_code year
merge m:1 la_code year using datachains_sept12_v1
drop if m_very==1
drop if delta_emp_tt3==.
foreach var in entry_j_type exit_j_type exp_j_type contr_j_type {
replace `var'=`var'_indep if type==5
} 
ta year, ge(yy)
sa ret_home_pop_chains_gro_long, replace
