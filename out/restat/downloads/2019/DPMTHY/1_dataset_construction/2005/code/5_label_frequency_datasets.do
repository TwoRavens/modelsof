* labels variables in frequency datasets
clear all


cd "$dir/1_dataset_construction/2005/code"


* needed for Table 1 (and Tables 2, 7, 8 and 9): *

*------- Collapsed by state, industry (nic_sec), and ownership group  -------*
u ../output/unlabeled_total_workers_frequency_state_ownership_and_4_digit_nic_code, clear
label var state "State"
label var nic "4-digit 2004 NIC code"
label var nic_sec "2004 NIC section (alphabetical)"
label var ownership "2005 Economic Census ownership status code"
label var total_workers "Number of persons usually working in the establishment"
label var freq "Number of establishments in the 2005 Economic Census with these characteristics"
label var freq_address_slip "Num establishments with these characteristics where an address slip was taken"
quietly {
    log using ../output/total_workers_frequency_state_ownership_and_4_digit_nic_code_codebook.txt, text replace
    noisily codebook
    log close
}
save ../output/total_workers_frequency_state_ownership_and_4_digit_nic_code, replace


* needed for Table 3: *

*------- Collapsed by worker, state, gender and 4 digit NIC code  -------*
u ../output/unlabeled_total_workers_frequency_state_gender_caste_and_4_digit_nic_code, clear
label var state "State"
label var nic "4-digit 2004 NIC code"
label var total_workers "Number of persons usually working in the establishment"
label var social_group_simp "Caste status of the establishment owner"
label drop social_group_simpl
label define social_group_simpl 1 "Scheduled Tribe (ST)" 2 "Scheduled Caste (SC)" 3 "Other Backward Caste (OBC)" 4 "Other" 
label values social_group_simp social_group_simpl
label var female "Is the establishment owner female?"
label var freq "Number of establishments in the 2005 Economic Census with these characteristics"
label var freq_address_slip "Num establishments with these characteristics where an address slip was taken"
quietly {
    log using ../output/total_workers_frequency_state_gender_caste_and_4_digit_nic_code_codebook.txt, text replace
    noisily codebook
    log close
}
save ../output/total_workers_frequency_state_gender_caste_and_4_digit_nic_code, replace



* needed for Statement re. IDA in text: 

*------- Collapsed by HIRED worker, state and 4 digit NIC code  -------*
u ../output/unlabeled_hired_workers_frequency_state_and_4_digit_nic_code.dta, clear
label var state "State"
label var nic "4-digit 2004 NIC code"
label var hired_total "Number of hired (paid) persons usually working in the establishment"
label var freq "Number of establishments in the 2005 Economic Census with these characteristics"
label var freq_address_slip "Num establishments with these characteristics where an address slip was taken"
quietly {
    log using ../output/hired_workers_frequency_state_and_4_digit_nic_code_codebook.txt, text replace
    noisily codebook
    log close
}
save ../output/hired_workers_frequency_state_and_4_digit_nic_code, replace
