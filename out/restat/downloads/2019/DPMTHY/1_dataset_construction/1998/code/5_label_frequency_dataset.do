* labels variables in frequency dataset
clear all

cd "$dir/1_dataset_construction/1998/code"

u ../output/unlabeled_total_workers_frequency_additional_variables.dta
label var state "State"
label var char_nic "4-digit 1987 NIC code"
label var ownership "1998 Economic Census ownership status code"
label var power_used "1998 Economic Census power use code"
label var total_workers "Number of persons usually working in the establishment"
label var nic_sec "1-digit 1987 NIC section (code)"
label var nic2 "2-digit 1987 NIC code"
label var factories_act "Registered under Factories Act, 1948-1"
label var freq "Number of establishments in the 1998 Economic Census with these characteristics"
quietly {
    log using ../output/total_workers_frequency_additional_variables_codebook.txt, text replace
    noisily codebook
    log close
}
save ../output/total_workers_frequency_additional_variables.dta, replace
