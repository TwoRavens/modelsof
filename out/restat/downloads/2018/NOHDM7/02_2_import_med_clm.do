clear
set more off, perm
cd /Users/zachbrown/Projects/PriceTransparency/Data/


forval yr = 2005(1)2014 {

	disp "year: `yr'"


	guse Raw/med_clm/MED_CLM_`yr'.dta, clear 
	
	// Member ID
	rename member_key_mc903 member_key
	label var member_key "Member key"

	// Year
	gen year = `yr'
	label var year "Year"

	// Drop blank variables
	count if prov_lname_mc078~=.
	count if prov_fname_mc028~=.
	count if prov_mname_mc029~=.
	count if prov_lname_mc030~=.
	drop prov_lname_mc078 prov_fname_mc028 prov_mname_mc029 prov_lname_mc030 
	drop prov_suffix_mc031 

	// Drop ambulatory payment classification code since they are mainly used for medicare
	drop apc_orig_mc073 claim_apc_version_mc074 


	// Record ID
	rename record_id_mc902 record_id
	label var record_id "Record ID"

	// Billing provider ID number
	rename bill_prov_key_mc076 bill_prov_key
	label var bill_prov_key "Billing provider ID number"

	// Sex
	gen sex = 1 if sex_mc012=="M"
	replace sex = 2 if sex_mc012=="F"
	replace sex = -1 if sex_mc012=="U"
	label define sex ///
		1 "1: Male" ///
		2 "2: Female" ///
		-1 "-1: Unknown" 
	label values sex sex
	*tab sex sex_mc012, miss
	label var sex "Member sex"
	drop sex_mc012

	// Member age
	rename age_eom_mc901 age_eom
	label var age_eom "Member age"

	// Member Zip
	rename member_zip_mc016 member_zip
	label var member_zip "Member zipcode"


	// Admission Date
	replace adm_date_mc018 = . if adm_date_mc018==0
	replace adm_date_mc018 = . if adm_date_mc018==-1
	tostring adm_date_mc018, generate(adm_date_str)
	replace adm_date_str="" if adm_date_str=="."
	gen adm_month = substr(adm_date_str,5,2)
	replace adm_month = substr(adm_month, 2, .) if substr(adm_month,1,1) == "0" 
	destring adm_month, replace
	gen adm_day = substr(adm_date_str,7,2)
	replace adm_day = substr(adm_day, 2, .) if substr(adm_day,1,1) == "0" 
	destring adm_day, replace
	gen adm_year = substr(adm_date_str,1,4)
	destring adm_year, replace

	generate adm_date=mdy(adm_month,adm_day,adm_year)
	format adm_date %d
	label var adm_date "Admission date"
	drop adm_month adm_day adm_year adm_date_str adm_date_mc018

	// First date of service
	replace from_date_mc059 = . if from_date_mc059==0
	replace from_date_mc059 = . if from_date_mc059==-1
	tostring from_date_mc059, generate(from_date_str)
	replace from_date_str="" if from_date_str=="."
	gen from_month = substr(from_date_str,5,2)
	replace from_month = substr(from_month, 2, .) if substr(from_month,1,1) == "0" 
	destring from_month, replace
	*tab from_month, miss
	gen from_day = substr(from_date_str,7,2)
	replace from_day = substr(from_day, 2, .) if substr(from_day,1,1) == "0" 
	destring from_day, replace
	*tab from_day, miss
	gen from_year = substr(from_date_str,1,4)
	destring from_year, replace
	*tab from_year, miss

	generate from_date=mdy(from_month,from_day,from_year)
	format from_date %d
	label var from_date "First date of service"
	drop from_month from_day from_year from_date_str from_date_mc059



	// Last date of service
	replace to_date_mc060 = . if to_date_mc060==0
	replace to_date_mc060 = . if to_date_mc060==-1
	tostring to_date_mc060, generate(to_date_str)
	replace to_date_str="" if to_date_str=="."
	gen to_month = substr(to_date_str,5,2)
	replace to_month = substr(to_month, 2, .) if substr(to_month,1,1) == "0" 
	destring to_month, replace
	gen to_day = substr(to_date_str,7,2)
	replace to_day = substr(to_day, 2, .) if substr(to_day,1,1) == "0" 
	destring to_day, replace
	gen to_year = substr(to_date_str,1,4)
	destring to_year, replace

	generate to_date=mdy(to_month,to_day,to_year)
	format to_date %d
	label var to_date "Last date of service"
	drop to_month to_day to_year to_date_str to_date_mc060


	// Type of service
	desc icd_proc_01_pri_mc058 rev_code_mc054 proc_code_mc055

	rename icd_proc_01_pri_mc058 icd_proc_01_pri
	local typ: type icd_proc_01_pri
	disp "icd_proc_01_pri variable type: `typ'"
	if substr("`typ'",1,3) == "str" {
		gen notnumeric = real(icd_proc_01_pri)==.
		tab icd_proc_01_pri if notnumeric
		drop notnumeric
		destring icd_proc_01_pri, replace force
		}
	label var icd_proc_01_pri "Procedure code (ICD-CM)"

	rename rev_code_mc054 rev_code
	local typ: type rev_code
	disp "rev_code variable type: `typ'"
	if substr("`typ'",1,3) == "str" {
		gen notnumeric = real(rev_code)==.
		tab rev_code if notnumeric
		drop notnumeric
		destring rev_code, replace force
		}
	merge m:1 rev_code using ref_tables/REF_REV_CODE.dta
	drop if _merge==2
	drop _merge rev_code

	rename proc_code_mc055 proc_code
	label var proc_code "Procedure code (HCPCS or CPT/CDT)"

	rename cpt_mod1_mc056 cpt_mod1
	label var cpt_mod1 "Procedure modifier 1"

	rename cpt_mod2_mc057  cpt_mod2
	label var cpt_mod2 "Procedure modifier 2"

	// Quantity
	rename qty_mc061 qty
	label var qty "Quantity"

	// DRG
	desc drg_orig_mc071 drg_version_orig_mc072

	rename drg_orig_mc071 drg_orig

	tostring drg_orig, replace // In some years the variable is numeric, in others string
	replace drg_orig="" if drg_orig=="."
	gen notnumeric = (real(drg_orig)==. & drg_orig~="")
	tab drg_orig if notnumeric
	egen notnumber_sum = sum(notnumeric)
	drop notnumeric notnumber_sum
	destring drg_orig, replace force
	label var drg_orig "DRG submitted by payer"

	rename drg_version_orig_mc072 drg_version_orig
	tostring drg_version_orig, replace
	replace drg_version_orig = "" if drg_version_orig=="."
	destring drg_version_orig, replace force
	label var drg_version_orig "Version of DRG used"

	// Admission Source Code
	rename adm_src_mc021 adm_src_code
	merge m:1 adm_src_code using ref_tables/REF_ADM_SRC.dta
	drop if _merge==2
	tab adm_src if _merge==1, miss
	drop _merge adm_src_code



	// Admission Type
	local typ: type adm_type_mc020
	disp "adm_type_mc020 variable type: `typ'"
	if substr("`typ'",1,3) == "str" {
		gen notnumeric = real(adm_type_mc020)==.
		tab adm_type_mc020 if notnumeric
		drop notnumeric
		destring adm_type_mc020, replace force
		}
		
	rename adm_type_mc020 adm_type_code
	merge m:1 adm_type_code using ref_tables/REF_ADM_TYPE.dta
	drop if _merge==2
	tab adm_type_code if _merge==1, miss
	drop _merge adm_type_code
	



	// Length of Stay
	rename client_los_mc018_mc22calc los
	label var los "Length of stay"



	// Discharge Status
	rename dis_stat_mc023 dis_stat_code 
	merge m:1 dis_stat_code using ref_tables/REF_DIS_STAT.dta
	drop if _merge==2
	tab dis_stat_code if _merge==1, miss
	drop _merge dis_stat_code
	tab dis_stat, miss
	

	// Service Provider ID Number
	rename serv_prov_key_mc024 serv_prov_key
	label var serv_prov_key "Service provider ID number"



	// Service Provider crosswalk key
	rename serv_prov_cw_key serv_prov_cw_key
	tostring serv_prov_cw_key, replace
	replace serv_prov_cw_key="" if serv_prov_cw_key=="."
	gen notnumeric = (real(serv_prov_cw_key)==. & serv_prov_cw_key~="")
	tab serv_prov_cw_key if notnumeric
	destring serv_prov_cw_key, replace force
	label var serv_prov_cw_key "Service provider crosswalk key"
	drop notnumeric

	// National Provider ID Number
	rename npi_mc026 npi_service
	tostring npi_service, replace
	replace npi_service="" if npi_service=="."
	gen notnumeric = (real(npi_service)==. & npi_service~="")
	tab npi_service if notnumeric
	destring npi_service, replace force
	label var npi_service "National provider ID of service provider"
	drop notnumeric


	// National provider ID of billing provider
	rename npi_mc077 npi_billing
	tostring npi_billing, replace
	replace npi_billing="" if npi_billing=="."
	gen notnumeric = (real(npi_billing)==. & npi_billing~="")
	tab npi_billing if notnumeric
	destring npi_billing, replace force
	label var npi_billing "National provider ID of billing provider"
	drop notnumeric

	// National Drug Code
	rename ndc_mc075 ndc
	tostring ndc, replace format(%15.0f)
	replace ndc="" if ndc=="."
	gen notnumeric = (real(ndc)==. & ndc~="")
	tab ndc if notnumeric
	drop notnumeric
	label var ndc "National drug code"


	// Original Service Provider Entity Type Qualifier
	gen prov_type_orig = 1 if prov_type_orig_mc027==1
	replace prov_type_orig = 2 if prov_type_orig_mc027==2
	replace prov_type_orig = -1 if prov_type_orig_mc027==-1
	replace prov_type_orig = -1 if prov_type_orig_mc027==-2

	label define prov_type_orig ///
		1 "1: Person" ///
		2 "2: Non-person" ///
		-1 "-1: Unknown"
		
	label values prov_type_orig prov_type_orig
	tab prov_type_orig prov_type_orig_mc027, miss
	egen nmis=rmiss(prov_type_orig)
	if nmis>0 error 1
	label var prov_type_orig "Original service provider entity type"
	drop prov_type_orig_mc027 nmis


	// Line of Business
	gen lob = 1 if lob_mc905=="COMMERCIAL"
	replace lob = 2 if lob_mc905=="MEDICAID"
	replace lob = 3 if lob_mc905=="MEDICARE"
	label define lob 1 "Commercial" 2 "Medicaid" 3 "Medicare"
	label values lob lob 
	label var lob "Line of business"
	drop lob_mc905


	// Type of Bill (Institutional)
	rename  ub_bill_type_mc036  ub_bill_type
	label var  ub_bill_type "Type of Bill (Institutional)"

	gen ub_facility = floor(ub_bill_type/100)
	label define ub_facility ///
		1 "1: Hospital" ///
		2 "2: Skilled Nursing" ///
		3 "3: Home Health" ///
		4 "4: Christian Science Hospital" ///
		5 "5: Christian Science Extended Care" ///
		6 "6: Intermediate Care" ///
		7 "7: Clinic" ///
		8 "8: Special Facility"
	label values ub_facility ub_facility
	label var ub_facility "Type of facility (detailed)"

	tostring ub_bill_type, gen(ub_bill_type_str)
	gen ub_bill_class_tmp = substr(ub_bill_type_str,2,1)
	destring ub_bill_class_tmp, replace

	gen ub_bill_class = 1 if ub_bill_class_tmp==1 & inrange(ub_facility,1,6)
	replace ub_bill_class = 2 if ub_bill_class_tmp==2 & inrange(ub_facility,1,6)
	replace ub_bill_class = 3 if ub_bill_class_tmp==3 & inrange(ub_facility,1,6)
	replace ub_bill_class = 4 if ub_bill_class_tmp==4 & inrange(ub_facility,1,6)
	replace ub_bill_class = 5 if ub_bill_class_tmp==5 & inrange(ub_facility,1,6)
	replace ub_bill_class = 6 if ub_bill_class_tmp==6 & inrange(ub_facility,1,6)
	replace ub_bill_class = 7 if ub_bill_class_tmp==7 & inrange(ub_facility,1,6)
	replace ub_bill_class = 8 if ub_bill_class_tmp==8 & inrange(ub_facility,1,6)

	replace ub_bill_class = 9 if ub_bill_class_tmp==1 & ub_facility==7
	replace ub_bill_class = 10 if ub_bill_class_tmp==2 & ub_facility==7
	replace ub_bill_class = 11 if ub_bill_class_tmp==3 & ub_facility==7
	replace ub_bill_class = 12 if ub_bill_class_tmp==5 & ub_facility==7
	replace ub_bill_class = 13 if ub_bill_class_tmp==6 & ub_facility==7
	replace ub_bill_class = 14 if ub_bill_class_tmp==9 & ub_facility==7

	replace ub_bill_class = 15 if ub_bill_class_tmp==1 & ub_facility==8
	replace ub_bill_class = 16 if ub_bill_class_tmp==2 & ub_facility==8
	replace ub_bill_class = 17 if ub_bill_class_tmp==3 & ub_facility==8
	replace ub_bill_class = 18 if ub_bill_class_tmp==4 & ub_facility==8
	replace ub_bill_class = 19 if ub_bill_class_tmp==9 & ub_facility==8

	label define ub_bill_class ///
		1 "1: Inpatient (including Medicare Part A)" ///
		2 "2: Inpatient (including Medicare Part B only)" ///
		3 "3: Outpatient" ///
		4 "4: Other (Non Clinic/SF)" ///
		5 "5: Nursing Facility Level I" ///
		6 "6: Nursing Facility Level II" ///
		7 "7: Intermediate Care - Level III Nursing Facility" ///
		8 "8: Swing Beds" ///
		9 "9: Rural Health" ///
		10 "10: Hospital Based or Independent Renal Dialysis Center" ///
		11 "11: Free Standing Outpatient Rehabilitation Facility (ORF)" ///
		12 "12: Comprehensive Outpatient Rehabilitation Facility (CORF)" ///
		13 "13: Community Mental Health Center " ///
		14 "14: Other (Clinic)" ///
		15 "15: Hospice, Non-hospital based" ///
		16 "16: Hospice, Hospital based" ///
		17 "17: Ambulatory Surgery Center" ///
		18 "18: Free Standing Birthing Center" ///
		19 "19: Other (Special Facility)"
		
	label values ub_bill_class ub_bill_class
	label var ub_bill_class "Bill classification"
	*tab ub_bill_type ub_bill_class, miss
	drop ub_bill_type_str ub_bill_class_tmp


	// Place of service
	rename pos_mc037 pos_code
	*tab pos_code, miss
	local typ: type pos_code
	disp "pos_code variable type: `typ'"
	if substr("`typ'",1,3) == "str" {
		gen notnumeric = real(pos_code)==.
		tab pos_code if notnumeric
		drop notnumeric
		destring pos_code, replace force
		}
		
	merge m:1 pos_code using ref_tables/REF_POS.dta
	drop if _merge==2
	tab pos_code if _merge==1, miss
	*tab pos, miss
	drop _merge pos_code
	

	// Claim Status
	rename claim_status_orig_mc038 claim_status_orig_code
	merge m:1 claim_status_orig_code using ref_tables/REF_CLAIM_STATUS.dta
	tab claim_status_orig_code if _merge==2, miss
	tab claim_status_orig_code if _merge==1, miss
	*tab claim_status_orig, miss
	drop if _merge==2
	drop _merge claim_status_orig_code


	// ICD codes
	label var ecode_orig_mc040 "Diagnosis E code"

	rename icd_diag_admit_mc039 icd_diag_admit
	rename icd_diag_01_primary_mc041 icd_diag_01_prim
	rename icd_diag_02_mc042 icd_diag_02
	rename icd_diag_03_mc043 icd_diag_03
	rename icd_diag_04_mc044 icd_diag_04
	rename icd_diag_05_mc045 icd_diag_05
	rename icd_diag_06_mc046 icd_diag_06
	rename icd_diag_07_mc047 icd_diag_07
	rename icd_diag_08_mc048 icd_diag_08
	rename icd_diag_09_mc049 icd_diag_09
	rename icd_diag_10_mc050 icd_diag_10
	rename icd_diag_11_mc051 icd_diag_11
	rename icd_diag_12_mc052 icd_diag_12
	rename icd_diag_13_mc053 icd_diag_13

	label var icd_diag_admit "Admitting diagnosis"
	label var icd_diag_01_prim "Primary diagnosis"
	label var icd_diag_02 "Diagnosis 2"
	label var icd_diag_03 "Diagnosis 3"
	label var icd_diag_04 "Diagnosis 4"
	label var icd_diag_05 "Diagnosis 5"
	label var icd_diag_06 "Diagnosis 6"
	label var icd_diag_07 "Diagnosis 7"
	label var icd_diag_08 "Diagnosis 8"
	label var icd_diag_09 "Diagnosis 9"
	label var icd_diag_10 "Diagnosis 10"
	label var icd_diag_11 "Diagnosis 11"
	label var icd_diag_12 "Diagnosis 12"
	label var icd_diag_13 "Diagnosis 13"


	foreach var of varlist icd_diag_* {
		disp " "
		disp "var: `var'"
		tostring `var', replace
		replace `var'="" if `var'=="."
	}

	// Amount
	rename amt_billed_mc062 amt_billed
	label var amt_billed "Total billed amount"

	rename amt_paid_mc063 amt_paid
	label var amt_paid "Health plan payments (inc withhold amounts, excl member payments)"

	rename amt_prepaid_mc064 amt_prepaid
	label var amt_prepaid "Fee for service equivalent that would have been paid w/o capitation"

	rename amt_copay_mc065 amt_copay
	label var amt_copay "Copay amount by member"

	rename amt_coins_mc066 amt_coins
	label var amt_coins "Coinsurance Amount by member"

	rename amt_deduct_mc067 amt_deduct
	label var amt_deduct "Deductible Amount by member"

	gen amt_member_oop = amt_copay + amt_coins + amt_deduct
	label var amt_member_oop "Member total out-of-pocket"


	// Merge on encoded specialty
	// Note that this file is created by making a list of all unique specialty names and then encoding
	merge m:1 service_provider_specialty_mc032 using ref_tables/specialty_list.dta
	drop if _merge==2
	drop _merge service_provider_specialty_mc032 n


	// Output provider info so that it can be cleaned seperately
	preserve
		keep serv_prov_cw_key serv_prov_key npi_service npi_billing service_provider_specialty
		order serv_prov_cw_key serv_prov_key
		gsave providers/med_clm_providers_`yr'.dta, replace
	restore
	drop npi_service npi_billing service_provider_specialty

	// Reorder variables
	order record_id member_key bill_prov_key ///
		serv_prov_cw_key serv_prov_key prov_type_orig ///
		lob adm_src adm_type pos claim_status_orig ///
		icd_proc_01_pri rev_maj proc_code cpt_mod1 cpt_mod2 qty drg_orig drg_version_orig ///
		year adm_date from_date to_date dis_stat los ///
		ub_bill_type ub_facility ub_bill_class ///
		amt* ///
		sex age_eom member_zip ///
		icd_diag_admit* ecode_orig_mc040 ///
		icd_diag_01_prim* icd_diag_02* icd_diag_03* icd_diag_04* ///
		icd_diag_05* icd_diag_06* icd_diag_07* icd_diag_08* icd_diag_09* icd_diag_10* ///
		icd_diag_11* icd_diag_12* icd_diag_13* 
		

	compress
	
	// Drop variables that don't seem that important to save space
	drop cpt_mod1 cpt_mod2
	
	gsave Raw/med_clm/med_clm_`yr'_clean.dta, replace
}
