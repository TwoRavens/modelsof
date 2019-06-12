clear
clear matrix
clear mata
set more off, perm
set matsize 11000
set maxvar 30000
cd /Users/zachbrown/Projects/PriceTransparency/Data/
global output /Users/zachbrown/Projects/PriceTransparency/Output


// open visit dataset
use clean/radiology_visit_3.dta, clear

keep if year==2006
keep proc_id_radio amt_allowed payer_id std_product_type prov_in_nh proc_class


gen amt_allowed_nh = amt_allowed if prov_in_nh~=0


bys proc_id_radio payer_id std_product_type: egen p25_amt_allowed = pctile(amt_allowed), p(25)
bys proc_id_radio payer_id std_product_type: egen p50_amt_allowed = pctile(amt_allowed), p(50)

replace p25_amt_allowed = amt_allowed if amt_allowed<p25_amt_allowed
replace p50_amt_allowed = amt_allowed if amt_allowed<p50_amt_allowed

drop if p25_amt_allowed==.
drop if p50_amt_allowed==.

collapse (mean) amt_allowed p25_amt_allowed p50_amt_allowed, by(proc_class)

gen p25_saving = (amt_allowed-p25_amt_allowed) / amt_allowed
gen p50_saving = (amt_allowed-p50_amt_allowed) / amt_allowed

order proc_class amt_allowed p25_amt_allowed p25_saving p50_amt_allowed p50_saving

// Format
gen proc_class_str = "Computed Tomography (CT)" if proc_class_max==2
replace proc_class_str = "Mammogram" if proc_class_max==3
replace proc_class_str = "Magnetic Resonance Imaging (MRI)" if proc_class_max==4
replace proc_class_str = "Nuclear Imaging" if proc_class_max==5
replace proc_class_str = "Positron Emission Tomography (PET)" if proc_class_max==6
replace proc_class_str = "Ultrasound" if proc_class_max==7
replace proc_class_str = "X-Ray" if proc_class_max==8

gen amt_allowed_str = string(amt_allowed,"%6.0fc")
gen p25_amt_allowed_str = string(p25_amt_allowed,"%6.0fc")
gen p50_amt_allowed_str = string(p50_amt_allowed,"%6.0fc")

gen p25_saving_str = string(p25_saving*100,"%6.1fc") + "%"
gen p50_saving_str = string(p50_saving*100,"%6.1fc") + "%"

keep proc_class_str amt_allowed_str p25_amt_allowed_str p25_saving_str p50_amt_allowed_str p50_saving_str
order proc_class_str amt_allowed_str p25_amt_allowed_str p25_saving_str p50_amt_allowed_str p50_saving_str

texsave2 using $output/potential_savings_a.tex, frag nonames replace

