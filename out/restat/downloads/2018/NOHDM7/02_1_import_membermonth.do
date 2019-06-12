clear
set more off, perm
cd /Users/zachbrown/Projects/PriceTransparency/Data/

forval yr = 2005(1)2014 {
	disp "year: `yr'"

	guse Raw/members/MEMBERMONTH_`yr'.dta, clear

	// Payer Code
	rename payercode_me001 payercode
	label var payercode "Payer code"

	// National plan ID
	drop nplan_me002 

	// Insurance Type
	rename insurance_type insurance_type_code
	merge m:1 insurance_type_code using ref_tables/REF_CLAIM_INSURANCE_TYPE.dta
	drop if _merge==2
	drop _merge insurance_type_code

	// Enrollment Date
	rename enroll_year_me004 year
	label var year "Enrollment year"

	rename enroll_yearmo_me005 yearmo
	label var yearmo "Enrollment year-month"

	// Coverage Level Code (Tier)
	rename tier tier_code
	merge m:1 tier_code using ref_tables/REF_TIER.dta
	drop if _merge==2
	drop _merge tier_code
	*tab tier, miss

	// Sex
	gen sex = 1 if sex_me013=="M"
	replace sex = 2 if sex_me013=="F"
	replace sex = -1 if sex_me013=="U"
	label define sex ///
		1 "1: Male" ///
		2 "2: Female" ///
		-1 "-1: Unknown" 
	label values sex sex
	*tab sex sex_me013, miss
	label var sex "Member sex"
	drop sex_me013

	// Age
	rename age_eom_me014calc age
	label var age "Member age"

	// Zipcode
	rename member_zip_me017 zip
	rename zip member_zip
	label var member_zip "Member zip"


	// Coverage
	gen coverage_medical=1 if coverage_medical_me018=="Y"
	replace coverage_medical=0 if coverage_medical_me018=="N"
	label var coverage_medical "Member has medical coverage"

	gen coverage_pharm=1 if coverage_pharmacy_me019=="Y"
	replace coverage_pharm=0 if coverage_pharmacy_me019=="N"
	label var coverage_pharm "Member has pharmacy coverage"

	gen coverage_dental=1 if coverage_dental_me020=="Y"
	replace coverage_dental=0 if coverage_dental_me020=="N"
	label var coverage_dental "Member has dental coverage"

	drop coverage_medical_me018 coverage_pharmacy_me019 coverage_dental_me020


	// Race
	gen race = 1 if race_me021=="R1"
	replace race = 2 if race_me021=="R2"
	replace race = 3 if race_me021=="R3"
	replace race = 4 if race_me021=="R4"
	replace race = 5 if race_me021=="R5"
	replace race = 6 if race_me021=="R6"
	replace race = 7 if race_me021=="R7"
	replace race = -1 if race_me021=="R9"
	replace race = -1 if race_me021=="R0"
	replace race = -1 if race_me021=="RO"
	replace race = -1 if race_me021=="R-1"
	replace race = -1 if race_me021=="R-2"
	replace race = -1 if race_me021==""
	label define race ///
		1 "1: White" ///
		2 "2: Black or AA" ///
		3 "3: American Indian and Alaska Native" ///
		4 "4: Asian" ///
		5 "5: Native Hawaiian and Other PI" ///
		6 "6: Some Other Race" ///
		7 "7: Two or More Races" ///
		-1 "-1: Unknown"
		
	label values race race
	*tab race race_me021, miss
	egen nmis=rmiss(race)
	if nmis>0 error 1
	label var race "Member race"
	drop race_me021 nmis


	// Race2
	gen race2 = 1 if race2_me022=="R1"
	replace race2 = 2 if race2_me022=="R2"
	replace race2 = 3 if race2_me022=="R3"
	replace race2 = 4 if race2_me022=="R4"
	replace race2 = 5 if race2_me022=="R5"
	replace race2 = 9 if race2_me022=="R9"
	replace race2 = -1 if race2_me022=="UNKNOW"
	replace race2 = -1 if race2_me022=="UNKNO"
	replace race2 = -1 if race2_me022=="-1"
	replace race2 = -1 if race2_me022==""
	label define race2 ///
		1 "1: American Indian and Alaska Native" ///
		2 "2: Asian" ///
		3 "3: Black or AA" ///
		4 "4: Native Hawaiian and Other PI" ///
		5 "5: White" ///
		9 "9: Some Other Race" ///
		-1 "-1: Unknown"
	label values race2 race2
	*tab race2 race2_me022, miss
	egen nmis=rmiss(race2)
	if nmis>0 error 1
	label var race2 "Member second race"
	drop race2_me022 nmis


	// Hispanic
	gen hisp = 1 if hispanic_me024=="y" | hispanic_me024=="Y"
	replace hisp = 0 if hispanic_me024=="N"
	replace hisp = -1 if hispanic_me024=="U"
	label define hisp ///
		0 "0: Not Hispanic" ///
		1 "1: Hispanic" ///
		-1 "-1: Unknown"
	label values hisp hisp
	*tab hisp hispanic_me024, miss
	egen nmis=rmiss(hisp)
	if nmis>0 error 1
	label var hisp "Member hispanic"
	drop hispanic_me024 nmis


	// Ethnicity
	gen ethnicity1 = 1 if ethnicity1_me025 =="2182-4"
	replace ethnicity1 = 2 if ethnicity1_me025 =="2184-0"
	replace ethnicity1 = 3 if ethnicity1_me025 =="2148-5"
	replace ethnicity1 = 4 if ethnicity1_me025 =="2180-8"
	replace ethnicity1 = 5 if ethnicity1_me025 =="2161-8"
	replace ethnicity1 = 6 if ethnicity1_me025 =="2155-0"
	replace ethnicity1 = 7 if ethnicity1_me025 =="2165-9"
	replace ethnicity1 = 8 if ethnicity1_me025 =="2060-2"
	replace ethnicity1 = 9 if ethnicity1_me025 =="2058-6"
	replace ethnicity1 = 10 if ethnicity1_me025 =="AMERCN"
	replace ethnicity1 = 11 if ethnicity1_me025 =="2028-9"
	replace ethnicity1 = 12 if ethnicity1_me025 =="2029-7"
	replace ethnicity1 = 13 if ethnicity1_me025 =="BRAZIL"
	replace ethnicity1 = 14 if ethnicity1_me025 =="2033-9"
	replace ethnicity1 = 15 if ethnicity1_me025 =="CVERDN"
	replace ethnicity1 = 16 if ethnicity1_me025 =="CARIBI"
	replace ethnicity1 = 17 if ethnicity1_me025 =="2034-7"
	replace ethnicity1 = 18 if ethnicity1_me025 =="2169-1"
	replace ethnicity1 = 19 if ethnicity1_me025 =="2108-9"
	replace ethnicity1 = 20 if ethnicity1_me025 =="2036-2"
	replace ethnicity1 = 21 if ethnicity1_me025 =="2157-6"
	replace ethnicity1 = 22 if ethnicity1_me025 =="2071-9"
	replace ethnicity1 = 23 if ethnicity1_me025 =="2158-4"
	replace ethnicity1 = 24 if ethnicity1_me025 =="2039-6"
	replace ethnicity1 = 25 if ethnicity1_me025 =="2040-4"
	replace ethnicity1 = 26 if ethnicity1_me025 =="2041-2"
	replace ethnicity1 = 27 if ethnicity1_me025 =="2118-8"
	replace ethnicity1 = 28 if ethnicity1_me025 =="PORTUG"
	replace ethnicity1 = 29 if ethnicity1_me025 =="EASTEU"
	replace ethnicity1 = 30 if ethnicity1_me025 =="2047-9"
	replace ethnicity1 = 31 if ethnicity1_me025 =="OTHER"
	replace ethnicity1 = -1 if ethnicity1_me025 =="UNKNOW"
	replace ethnicity1 = -1 if ethnicity1_me025 =="-1"
	replace ethnicity1 = -1 if ethnicity1_me025 =="-2"
	replace ethnicity1 = -1 if ethnicity1_me025 ==""

	label define ethnicity ///
		1 "1: Cuban" ///
		2 "2: Dominican" ///
		3 "3: Mexican, Mexican American, Chicano" ///
		4 "4: Puerto Rican" ///
		5 "5: Salvadoran" ///
		6 "6: Central American (not otherwise specified)" ///
		7 "7: South American (not otherwise specified)" ///
		8 "8: African" ///
		9 "9: African American" ///
		10 "10: American" ///
		11 "11: Asian" ///
		12 "12: Asian Indian" ///
		13 "13: Brazilian" ///
		14 "14: Cambodian" ///
		15 "15: Cape Verdean " ///
		16 "16: Caribbean Island " ///
		17 "17: Chinese" ///
		18 "18: Columbian" ///
		19 "19: European" ///
		20 "20: Filipino" ///
		21 "21: Guatemalan" ///
		22 "22: Haitian" ///
		23 "23: Honduran" ///
		24 "24: Japanese" ///
		25 "25: Korean" ///
		26 "26: Laotian" ///
		27 "27: Middle Eastern " ///
		28 "28: Portuguese" ///
		29 "29: Eastern European" ///
		30 "30: Vietnamese" ///
		31 "31: Other" ///
		-1 "-1: Unknown"
	label values ethnicity1 ethnicity
	*tab ethnicity1 ethnicity1_me025, miss
	egen nmis=rmiss(ethnicity1)
	if nmis>0 error 1
	label var ethnicity1 "Ethnicity 1"
	drop ethnicity1_me025 nmis




	gen ethnicity2 = 1 if ethnicity2_me026 =="2182-4"
	replace ethnicity2 = 2 if ethnicity2_me026 =="2184-0"
	replace ethnicity2 = 3 if ethnicity2_me026 =="2148-5"
	replace ethnicity2 = 4 if ethnicity2_me026 =="2180-8"
	replace ethnicity2 = 5 if ethnicity2_me026 =="2161-8"
	replace ethnicity2 = 6 if ethnicity2_me026 =="2155-0"
	replace ethnicity2 = 7 if ethnicity2_me026 =="2165-9"
	replace ethnicity2 = 8 if ethnicity2_me026 =="2060-2"
	replace ethnicity2 = 9 if ethnicity2_me026 =="2058-6"
	replace ethnicity2 = 10 if ethnicity2_me026 =="AMERCN"
	replace ethnicity2 = 11 if ethnicity2_me026 =="2028-9"
	replace ethnicity2 = 12 if ethnicity2_me026 =="2029-7"
	replace ethnicity2 = 13 if ethnicity2_me026 =="BRAZIL"
	replace ethnicity2 = 14 if ethnicity2_me026 =="2033-9"
	replace ethnicity2 = 15 if ethnicity2_me026 =="CVERDN"
	replace ethnicity2 = 16 if ethnicity2_me026 =="CARIBI"
	replace ethnicity2 = 17 if ethnicity2_me026 =="2034-7"
	replace ethnicity2 = 18 if ethnicity2_me026 =="2169-1"
	replace ethnicity2 = 19 if ethnicity2_me026 =="2108-9"
	replace ethnicity2 = 20 if ethnicity2_me026 =="2036-2"
	replace ethnicity2 = 21 if ethnicity2_me026 =="2157-6"
	replace ethnicity2 = 22 if ethnicity2_me026 =="2071-9"
	replace ethnicity2 = 23 if ethnicity2_me026 =="2158-4"
	replace ethnicity2 = 24 if ethnicity2_me026 =="2039-6"
	replace ethnicity2 = 25 if ethnicity2_me026 =="2040-4"
	replace ethnicity2 = 26 if ethnicity2_me026 =="2041-2"
	replace ethnicity2 = 27 if ethnicity2_me026 =="2118-8"
	replace ethnicity2 = 28 if ethnicity2_me026 =="PORTUG"
	replace ethnicity2 = 29 if ethnicity2_me026 =="EASTEU"
	replace ethnicity2 = 30 if ethnicity2_me026 =="2047-9"
	replace ethnicity2 = 31 if ethnicity2_me026 =="OTHER"
	replace ethnicity2 = -1 if ethnicity2_me026 =="UNKNOW"
	replace ethnicity2 = -1 if ethnicity2_me026 =="-1"
	replace ethnicity2 = -1 if ethnicity2_me026 =="-2"
	replace ethnicity2 = -1 if ethnicity2_me026 ==""
	label values ethnicity2 ethnicity
	*tab ethnicity2 ethnicity2_me026, miss
	egen nmis=rmiss(ethnicity1)
	if nmis>0 error 1
	label var ethnicity2 "Ethnicity 2"
	drop ethnicity2_me026 nmis


	// Primary Insurance Indicator
	gen primary_ins = (primary_ins_me028=="y" | primary_ins_me028=="Y")
	label var primary_ins "Primary insurance indicator"
	drop primary_ins_me028


	// Record ID
	rename record_id_me902 record_id
	label var record_id "Record ID"

	// Member ID
	rename member_key_me904 member_key
	label var member_key "Member key"


	// Standardized Insurance Product Type
	drop std_product_type_me 

	// Line of Business
	gen lob = 1 if lob_me905=="COMMERCIAL"
	replace lob = 2 if lob_me905=="MEDICAID"
	replace lob = 3 if lob_me905=="MEDICARE"
	label define lob 1 "Commercial" 2 "Medicaid" 3 "Medicare"
	label values lob lob 
	drop lob_me905
	
	// Save stata dataset
	order record_id member_key year yearmo payercode std_product_type insurance_type tier primary_ins coverage_medical coverage_pharm coverage_dental lob
	compress
	gsave "Raw/members/member_month_`yr'_clean.dta", replace

}

