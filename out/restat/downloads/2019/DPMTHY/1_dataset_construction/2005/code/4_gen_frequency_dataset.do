* Generates a dataset of (frequency, number_of_workers, X) where X indexes a subpopulation. For example, a (state, nic section, 2-digit nic code) triple.


cd "$dir/1_dataset_construction/2005/output"
pwd


use ec_05_all_india_cleaned.dta, clear


***---	Generate other needed variables:	---***

gen manufacturing=nic>=1500 & nic<=3800

* generate variable for whether registered under any laws: 27% registered; 73% unreg (no missing)
gen reg = 1
replace reg = 0 if reg_code1 == 0 & reg_code2 == 0
replace reg = . if reg_code1 == . & reg_code2 == .

* generate variable for whether registered under Factories Act
gen factories_act = reg_code1 == 1 | reg_code2 == 1

gen has_address_bin = has_address == 1

gen st_dist = state*100 + district
gen SEZ = st_dist == 2401 | st_dist ==  2722 | st_dist == 910 | st_dist == 3302 | st_dist == 3208 | st_dist == 1918 | st_dist == 2813 | st_dist == 2422 | st_dist == 812 | st_dist == 2326 | st_dist == 815 | st_dist == 904 | st_dist == 1917

* Generate simplified social group variable:*
gen social_group_simp = social_group
recode social_group_simp (1 5 = 1) (2 6 = 2) (3 7 = 3) (4 8 = 4) (9 = .)
label define social_group_simpl 1 "ST" 2 "SC" 3 "OBC" 4 "Other" 
label values social_group_simp social_group_simpl 

gen female = social_group
recode female (1 2 3 4 = 1) (5 6 7 8 = 2) (9 = .)
label define femalel 1 "female" 2 "male"
label values female femalel   

replace sector=. if sector==5

	

* needed for Table 1 (and Tables 2, 7, 8 and 9): *

*------- Collapse by state, industry (nic_sec), and ownership group  -------*
preserve
collapse (count) freq=schedule_num (sum) freq_address_slip=has_address_bin, by(total_workers state nic nic_sec ownership)
save ../output/unlabeled_total_workers_frequency_state_ownership_and_4_digit_nic_code, replace
restore


* needed for Table 3: *

*------- Collapse by worker, state, gender and 4 digit NIC code  -------*
preserve
collapse (count) freq=schedule_num (sum) freq_address_slip=has_address_bin, by(total_workers state nic female social_group_simp)
save ../output/unlabeled_total_workers_frequency_state_gender_caste_and_4_digit_nic_code, replace
restore


* needed for Statement re. IDA in text: 

*------- Collapse by HIRED worker, state and 4 digit NIC code  -------*
preserve
collapse (count) freq=schedule_num (sum) freq_address_slip=has_address_bin, by(hired_total state nic)
save ../output/unlabeled_hired_workers_frequency_state_and_4_digit_nic_code, replace
restore



