clear
set more off, perm
cd /Users/zachbrown/Projects/PriceTransparency/Data/

insheet using Raw/ref_tables/PROVIDER_DETAIL.txt, delim("|") names
compress

// Drop missing var
count if prov_lname~=.
count if prov_fname~=.
count if prov_mname~=.
count if cw_prov_fname~=.
count if cw_prov_mname~=.
drop prov_lname prov_fname prov_mname cw_prov_fname cw_prov_mname
drop prov_suffix 
drop cw_prov_lname_facilityname 
drop  prov_id prov_id_orig

// Some of the medinsight crosswalk variables are redundant
drop cw_prov_spec cw_prov_spec_desc prov_cw_id 

replace npi = cw_npi if cw_npi~="" 
drop cw_npi
label var npi "National provider id"

// Taxonomy 
replace cw_taxonomy = "" if cw_taxonomy=="SKIPPED"
replace taxonomy = "" if taxonomy=="SKIPPED"
count if taxonomy==""
replace taxonomy = cw_taxonomy if taxonomy=="" & cw_taxonomy~=""
label var taxonomy "Taxonomy (CMS specialty coding system)"
drop cw_taxonomy

// Provider Type
rename prov_type prov_type_str
encode prov_type_str, generate(prov_type)
drop prov_type_str prov_type_orig
label var prov_type "Provider type"

// Provider specialty
replace prov_spec_desc = upper(prov_spec_desc)
encode prov_spec_desc, gen(prov_spec_des)
drop prov_spec_desc
label var prov_spec_des "Provider Specialty Description"
label var prov_spec "Provider Specialty"

// Provider zip
gen notnumeric = real(prov_clinic_zip)==.
tab prov_clinic_zip if notnumeric
drop notnumeric
destring prov_clinic_zip, replace force
label var prov_clinic_zip "Provider zip"

// Service Provider Tax ID
label var prvtaxid "Provider tax id"

// Drug enforcement administration number
label var prov_dea "Drug enforcement administration number"


// Additional variable labels
label var prov_key "Service provider key"
label var payercode "Payer code"
label var individual "Individual service provider"
label var facility_name "Facility name"
label var prov_clinic_name "Provider clinic name"
label var prov_clinic_city "Provider clinic city"
label var prov_clinic_state "Provider clinic state"
label var nh_county_code "NH county code"
label var country "Country"

compress
save Raw/ref_tables/provider_detail.dta, replace
