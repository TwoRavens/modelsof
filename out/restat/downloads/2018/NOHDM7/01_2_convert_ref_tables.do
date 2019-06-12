clear
set more off, perm
cd /Users/zachbrown/Projects/PriceTransparency/Data/

// REF_ADM_SRC.txt
clear
insheet using Raw/ref_tables/REF_ADM_SRC.txt, delim("|") names
rename adm_src adm_src_code
encode adm_src_desc, generate(adm_src)
encode adm_src_newborn_desc, generate(adm_src_newborn)
drop adm_src_desc adm_src_newborn_desc
label var adm_src "Admission source"
label var adm_src_newborn "Admission source (newborn)"
compress
desc
save Raw/ref_tables/REF_ADM_SRC.dta, replace


// REF_ADM_TYPE.txt
clear
insheet using Raw/ref_tables/REF_ADM_TYPE.txt, delim("|") names
tab adm_type
rename adm_type adm_type_code
gen adm_type = adm_type_code
labmask adm_type, values(adm_type_desc)
drop adm_type_desc
label var adm_type "Admission type"
compress
desc
save Raw/ref_tables/REF_ADM_TYPE.dta, replace


// REF_CCHG.txt
clear
insheet using Raw/ref_tables/REF_CCHG.txt, delim("|") names
tab cchg_cat
rename cchg_cat cchg_cat_code
gen cchg = cchg_cat_code
labmask cchg, values(cchg_desc)
drop cchg_desc
label var cchg "Chronic Condition Hierarchical Groups"
compress
desc
save Raw/ref_tables/REF_CCHG.dta, replace


// REF_CLAIM_INSURANCE_TYPE.txt
clear
insheet using Raw/ref_tables/REF_CLAIM_INSURANCE_TYPE.txt, delim("|") names
tab insurance_type
replace insurance_type = "PR" if insurance_type=="12"
replace insurance_type = "PS" if insurance_type=="13"
replace insurance_type = "EP" if insurance_type=="14"
replace insurance_type = "IN" if insurance_type=="15"
replace insurance_type = "HN" if insurance_type=="16"
desc
rename insurance_type insurance_type_code
encode insurance_type_desc, generate(insurance_type)

gen std_product_type = 1 if product_type =="PPO"
replace std_product_type = 2 if product_type =="POS"
replace std_product_type = 3 if product_type =="HMO"
replace std_product_type = 4 if product_type =="SN1"
replace std_product_type = 5 if product_type =="SN2"
replace std_product_type = 6 if product_type =="SN3"
replace std_product_type = 7 if product_type =="CHP"
replace std_product_type = 8 if product_type =="EPO"
replace std_product_type = 9 if product_type =="SF"
replace std_product_type = 10 if product_type =="SL"
replace std_product_type = 11 if product_type =="IND"
label define std_product_type ///
	1 "1: Commercial PPO" ///
	2 "2: Commercial POS" ///
	3 "3: Commercial HMO" ///
	4 "4: Special Needs Plan - Chronic Condition" ///
	5 "5: Special Needs Plan - Institutionalized" ///
	6 "6: Special Needs Plan - Dual Eligible" ///
	7 "7: Child Health Insurance Program" ///
	8 "8: Exclusive Provider Organization" ///
	9 "9: Self-Funded" ///
	10 "10: Stop Loss" ///
	11 "11: Indemnity"
label values std_product_type std_product_type
drop insurance_type_desc medicare medicaid product_type
label var insurance_type "Insurance type"
label var std_product_type "Std insurance product type"
compress
desc
save Raw/ref_tables/REF_CLAIM_INSURANCE_TYPE.dta, replace


// REF_CLAIM_STATUS.txt
clear
insheet using Raw/ref_tables/REF_CLAIM_STATUS.txt, delim("|") names
desc
tab code
tab value
gen n=1
collapse n, by(code value)
gen claim_status_orig_code=code
rename code claim_status_orig
labmask claim_status_orig, values(value)
drop value n
label var claim_status_orig "Claim status (original)"
compress
desc
order claim_status_orig_code
save Raw/ref_tables/REF_CLAIM_STATUS.dta, replace


// REF_COVERAGETYPE.txt
clear
insheet using Raw/ref_tables/REF_COVERAGETYPE.txt, delim("|") names
desc
tab cov_type, miss
rename cov_type cov_type_code
encode cov_type_desc, generate(cov_type)
drop cov_type_desc
label var cov_type "Coverage type"
compress
desc
save Raw/ref_tables/REF_COVERAGETYPE.dta, replace


// REF_CPT_MOD.txt
clear
insheet using Raw/ref_tables/REF_CPT_MOD.txt, delim("|") names
desc
tab cpt_mod
rename cpt_mod cpt_mod_code
encode cpt_mod_desc, generate(cpt_mod)
drop cpt_mod_desc
label var cpt_mod "Procedure modifier"
compress
desc
save Raw/ref_tables/REF_CPT_MOD.dta, replace


// REF_CPT.txt
clear
insheet using Raw/ref_tables/REF_CPT.txt, delim("|") names
desc
*tab proc_code
*rename proc_code proc_code_code

// Label emergency visits
gen proc_emerg = strpos(cpt_desc,"EMER")>0
replace proc_emerg=0 if strpos(cpt_desc,"NONEMER")>0
replace proc_emerg=0 if strpos(cpt_desc,"NON-EMER")>0
tab cpt_desc if proc_emerg
label var proc_emerg "Emergency procedure"
list if proc_code=="99281"
list if proc_code=="99283"


encode cpt_desc, generate(cpt)
drop cpt_desc
label var cpt "Procedure"
compress
desc
save Raw/ref_tables/REF_CPT.dta, replace

// Collapse by proc_code
duplicates report proc_code
collapse (first) cpt (max) proc_emerg, by(proc_code)
label value cpt cpt
save Raw/ref_tables/REF_CPT2.dta, replace


// REF_DIS_STAT.txt
clear
insheet using Raw/ref_tables/REF_DIS_STAT.txt, delim("|") names
desc
tab dis_stat
gen dis_stat_code=dis_stat
labmask dis_stat, values(dis_stat_desc)
drop dis_stat_desc
label var dis_stat "Dischage status"
compress
desc
order dis_stat_code
save Raw/ref_tables/REF_DIS_STAT.dta, replace


// REF_DRG.txt
clear
insheet using Raw/ref_tables/REF_DRG.txt, delim("|") names
desc
encode drg_type, generate(drg_group)
encode drg_desc, generate(drg)
encode mdc_desc, generate(mdc)
drop drg_desc drg_type mdc_desc
label var drg_group "DRG grouper"
label var drg "DRG"
label var mdc "Medical Diagnotic Category Code associate with DRG"
compress
desc
save Raw/ref_tables/REF_DRG.dta, replace


// REF_ELIGILIBITY_INSURANCE_TYPE.txt
clear
insheet using Raw/ref_tables/REF_ELIGILIBITY_INSURANCE_TYPE.txt, delim("|") names
desc
rename insurance_type insurance_type_code
encode insurance_type_desc, generate(insurance_type)
encode product_type, generate(product)
drop insurance_type_desc product_type medicare medicaid
label var insurance_type "Insurance type"
label var product "Insurance product type"
compress
desc
save Raw/ref_tables/REF_ELIGILIBITY_INSURANCE_TYPE.dta, replace


// REF_FORM_TYPE.txt
clear
insheet using Raw/ref_tables/REF_FORM_TYPE.txt, delim("|") names
desc


// REF_GEOGRAPHY.txt
clear
insheet using Raw/ref_tables/REF_GEOGRAPHY.txt, delim("|") names
desc

// Merge on lat and long here

compress
save Raw/ref_tables/REF_GEOGRAPHY.dta, replace


// REF_GROUP.txt
clear
insheet using Raw/ref_tables/REF_GROUP.txt, delim("|") names
desc


// REF_HCG.txt
clear
insheet using Raw/ref_tables/REF_HCG.txt, delim("|") names
desc


// REF_ICD_DIAG.txt
clear
insheet using Raw/ref_tables/REF_ICD_DIAG.txt, delim("|") names
desc
rename icd_diag icd_diag_code
*encode icd_diag_desc, generate(icd_diag) // TOO MANY VALUES
* drop icd_diag_desc
label var icd_diag_desc "ICD Diagnosis"
compress
desc
save Raw/ref_tables/REF_ICD_DIAG.dta, replace

drop icd_diag_desc

// Examine duplicate
duplicates examples icd_diag_code
duplicates tag icd_diag_code, gen(dup)
tab dup

// If icd-9 and icd-10 codes are the same, just keep icd-10
drop if dup==1 & icd_10_or_higher==0
duplicates report icd_diag_code
drop dup

save Raw/ref_tables/REF_ICD_DIAG_no_desc.dta, replace


// REF_ICD_PROC.txt
clear
insheet using Raw/ref_tables/REF_ICD_PROC.txt, delim("|") names
desc
rename icd_proc icd_proc_code
*encode icd_proc_desc, generate(icd_proc)  // TOO MANY VALUES
*drop icd_proc_desc
label var icd_proc_desc "Procedure code (ICD-CM)"
compress
desc
save Raw/ref_tables/REF_ICD_PROC.dta, replace


// REF_MARKETCAT.txt
clear
insheet using Raw/ref_tables/REF_MARKETCAT.txt, delim("|") names
desc
tab market_cat
tab market_cat_desc
rename market_cat market_cat_code
encode market_cat_desc, generate(market_cat)
drop market_cat_desc
label var market_cat "Market Category"
compress
desc
save Raw/ref_tables/REF_MARKETCAT.dta, replace


// REF_PAYER_PROCESS_RULES.txt
clear
insheet using Raw/ref_tables/REF_PAYER_PROCESS_RULES.txt, delim("|") names
desc

// REF_PAYER.txt
clear
insheet using Raw/ref_tables/REF_PAYER.txt, delim("|") names
desc
*rename payercode payercode_code
encode payercode_description, generate(payercode_desc)
encode company, generate(payer_company)
drop payercode_description company
label var payercode_desc "Payer Description"
label var payer_company "Payer Company"

rename medical medical_str
rename pharmacy pharmacy_str
rename dental dental_str
gen medical = 1 if medical_str=="Y"
replace medical = 0 if medical_str=="N"
gen pharmacy = 1 if pharmacy_str=="Y"
replace pharmacy = 0 if pharmacy_str=="N"
gen dental = 1 if dental_str=="Y"
replace dental = 0 if dental_str=="N"
drop medical_str pharmacy_str dental_str

compress
desc

duplicates drop
save Raw/ref_tables/REF_PAYER.dta, replace





replace payer_company =54 if payercode_desc==51 // To standardize names
contract payercode parent_payer_code payer_company payercode_desc medical pharmacy dental
drop _freq

decode payer_company, gen(payer_company_str)
gen payer_name_short = upper(substr(payer_company_str,1,strpos(payer_company_str," ") - 1))

preserve
contract payer_company_str payer_name_short, freq(n)
list
restore

gen payer_name_abbr_str = "AETNA" if payer_name_short=="AETNA"
replace payer_name_abbr_str = "CIGNA" if payer_name_short=="CIGNA"
replace payer_name_abbr_str = "CIGNA" if payer_name_short=="CONNECTICUT" // Note Connecticut General Life is part of Cigna
replace payer_name_abbr_str = "ANTHEM" if payer_name_short=="ANTHEM"
replace payer_name_abbr_str = "ANTHEM" if payer_name_short=="MATTHEW" // Note Matthew Thorton is an Anthem plan
replace payer_name_abbr_str = "HARVARD PILGRIM" if payer_name_short=="HARVARD"
replace payer_name_abbr_str = "HUMANA" if payer_name_short=="HUMANA"
replace payer_name_abbr_str = "UNITED HEALTHCARE" if payer_name_short=="UNITED"
replace payer_name_abbr_str = "UNITED HEALTHCARE" if payer_name_short=="UNITEDHEALTHCARE"

replace payer_name_abbr_str = "OTHER" if payer_name_abbr_str==""
drop payer_company_str payer_name_short
encode payer_name_abbr_str, generate(payer_name_abbr)
drop payer_name_abbr_str

duplicates report payercode
save Raw/ref_tables/REF_PAYER2.dta, replace



// REF_POS.txt
clear
insheet using Raw/ref_tables/REF_POS.txt, delim("|") names
desc
tab pos
tab pos_desc
gen pos_code= pos
labmask pos, values(pos_desc)
drop pos_desc
label var pos "Place of service"
compress
desc
order pos_code
save Raw/ref_tables/REF_POS.dta, replace


// REF_PROCESSING_RULES.txt
clear
insheet using Raw/ref_tables/REF_PROCESSING_RULES.txt, delim("|") names
desc


// REF_PROD_TYPE.txt
clear
insheet using Raw/ref_tables/REF_PROD_TYPE.txt, delim("|") names
desc
tab prod_type_key
tab prod_type


// REF_PROV_SPEC.txt
clear
insheet using Raw/ref_tables/REF_PROV_SPEC.txt, delim("|") names
desc
replace prov_spec_desc = upper(prov_spec_desc)
rename prov_spec prov_spec_code
encode prov_spec_desc, generate(prov_spec)
drop prov_spec_desc prov_spec_source
label var prov_spec "Provider Specialty"
compress
desc
save Raw/ref_tables/REF_PROV_SPEC.dta, replace


// REF_PROV_TAXONOMY.txt
clear
insheet using Raw/ref_tables/REF_PROV_TAXONOMY.txt, delim("|") names
desc
rename classification classification_str
rename specialization specialization_str
rename milliman_specialty milliman_specialty_code
rename provider_type provider_type_str
encode classification_str, generate(classification)
encode specialization_str, generate(specialization)
encode milliman_specialty_desc, generate(milliman_specialty)
encode provider_type_str, generate(provider_type)
drop classification_str specialization_str milliman_specialty_desc provider_type_str
label var classification "Provider classification"
label var specialization "Provider specialization"
label var milliman_specialty "Provider specialization (Milliman)"
label var provider_type "Provider type"
compress
desc
save Raw/ref_tables/REF_PROV_TAXONOMY.dta, replace


// REF_RELATION.txt
clear
insheet using Raw/ref_tables/REF_RELATION.txt, delim("|") names
desc



// REF_REV_CODE.txt
clear
insheet using Raw/ref_tables/REF_REV_CODE.txt, delim("|") names
desc
tab rev_code
tab rev_desc_maj
gen rev_maj = rev_code
labmask rev_maj, values(rev_desc_maj)
drop rev_desc_maj
label var rev_maj "Revenue Code Description"
compress
desc
save Raw/ref_tables/REF_REV_CODE.dta, replace


// REF_RX_DAW.txt
clear
insheet using Raw/ref_tables/REF_RX_DAW.txt, delim("|") names
desc
tab rx_daw
tab rx_daw_desc
gen rx_daw_code = rx_daw
replace rx_daw="" if rx_daw=="U"
destring rx_daw, replace
labmask rx_daw, values(rx_daw_desc)
drop rx_daw_desc
label var rx_daw "Dispense as written"
compress
desc
order rx_daw_code
save Raw/ref_tables/REF_RX_DAW.dta, replace


// REF_SV_STAT.txt
clear
insheet using Raw/ref_tables/REF_SV_STAT.txt, delim("|") names
desc
tab sv_stat
tab sv_stat_desc
rename sv_stat sv_stat_code
encode sv_stat_desc, generate(sv_stat)
drop sv_stat_desc
label var sv_stat "SV status"
compress
desc
save Raw/ref_tables/REF_SV_STAT.dta, replace


// REF_TIER.txt
clear
insheet using Raw/ref_tables/REF_TIER.txt, delim("|") names
desc
replace tier_desc = "Spouse and Children" if tier=="SPC"
replace tier_desc = "Spouse Only" if tier=="SPO"
tab tier
tab tier_desc
rename tier tier_code
encode tier_desc, generate(tier)
drop tier_desc
label var tier "Level of coverage (tier)"
compress
desc
save Raw/ref_tables/REF_TIER.dta, replace


// REF_UB_BILL_TYPE.txt
clear
insheet using Raw/ref_tables/REF_UB_BILL_TYPE.txt, delim("|") names
desc
tab ub_bill_type
tab ub_bill_billclass_desc
tab ub_bill_factype_desc
gen ub_bill_type_code = ub_bill_type
gen ub_billclass = ub_bill_type
labmask ub_billclass, values(ub_bill_billclass_desc)
encode ub_bill_factype_desc, generate(ub_factype)
drop ub_bill_billclass_desc ub_bill_factype_desc ub_bill_type
label var ub_billclass "Type of bill class description"
label var ub_factype "Type of bill facility type"
compress
desc
save Raw/ref_tables/REF_UB_BILL_TYPE.dta, replace


