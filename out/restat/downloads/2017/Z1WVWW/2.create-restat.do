* This code builds the analysis files for "The Local Influence of Pioneer Investigators on Technology Adoption: Evidence from New Cancer Drugs"
* Written by Leila Agha and David Molitor
* Date: 2/3/17

*  SCRIPT OVERVIEW
*	Step 1. Process the claims data (requires executing data steps from extract-restat.sas)
*	Step 2. Create the baseline analysis files

* Project Home Directory
local home PATH_TO_PROJECT_HOME_DIRECTORY

* Sections of code to run
{
scalar step1 				= 1
scalar 		step1_car 	= 1
scalar 		step1_op	= 1
scalar 		step1_dzs	= 1
scalar 		step1_bene	= 1
scalar 		step1_prov	= 1
scalar 		step1_spel	= 1
scalar 		step1_group	= 1
scalar 		step1_cites	= 1
scalar step2 				= 1
scalar 		step2_var	= 1
scalar 		step2_prox 	= 1
}

* ----------------------------------------------------------------------------------------------------------------------------------------------------------
* Step 0. Medicare Data Extraction (execute data steps from extract-restat.sas)
* ----------------------------------------------------------------------------------------------------------------------------------------------------------

* ----------------------------------------------------------------------------------------------------------------------------------------------------------
* Step 1. Process Claims Data
* ----------------------------------------------------------------------------------------------------------------------------------------------------------
if step1 {
* 	Step 1.Car. Carrier.   Create standardized annual carrier cancer drug claim files (chem_car05 corresponds to 20% carrier files)
*	Input:
* 		1. `home'/data/extracts/car/chem_car05_year.dta
*	Output:
* 		1. `home'/data/extracts/step1/car/chem_car05_year_std.dta
* ----------------------------------------------------------------------------------------------------------------------------------------------------------
if step1_car {

* List the carrier files to be pooled together
*	NOTE: chem_car05 corresponds to 20% carrier files
local ftyp chem_car05
local flist `ftyp'_1998 `ftyp'bcd_1998 `ftyp'_1999 `ftyp'bcd_1999 `ftyp'_2000 `ftyp'_2001 `ftyp'_2002 `ftyp'_2003 `ftyp'_2004 `ftyp'_2005 `ftyp'_2006 `ftyp'_2007 `ftyp'_2008

* Prepare each part of the pool for consistency across years, e.g. selecting and renaming variables
qui foreach clmsfile of local flist {
	* First, specify the class of variables to be pulled from this claims file. (The set of available variables and their names change over time.)
	if 		("`clmsfile'"=="`ftyp'_1998")    | ("`clmsfile'"=="`ftyp'_1999") 																	local fclass = 1
	else if	("`clmsfile'"=="`ftyp'bcd_1998") | ("`clmsfile'"=="`ftyp'bcd_1999") | ("`clmsfile'"=="`ftyp'_2000") 								local fclass = 2
	else if	("`clmsfile'"=="`ftyp'_2001") 																										local fclass = 3
	else if	("`clmsfile'"=="`ftyp'_2002")    | ("`clmsfile'"=="`ftyp'_2003")    | ("`clmsfile'"=="`ftyp'_2004") | ("`clmsfile'"=="`ftyp'_2005") local fclass = 4
	else if	("`clmsfile'"=="`ftyp'_2006")    | ("`clmsfile'"=="`ftyp'_2007")    | ("`clmsfile'"=="`ftyp'_2008")								 	local fclass = 5
	
	* Define the variable names to extract for each year
	if 1 {
		* Patient IDs
		local ehic ehic
		local bene_id BENE_ID
		
		* Claim index (for 2002-2008 carrier claims, when clms and linits files are split).  Note: for fclass==2, there is an "obsi" variable, and for fclass==3 there is a "claim" variable.  But I'm not sure these are the equivalent of claimindex.
		* if      `fclass'<=3 local claimindex
		* else if `fclass'==4 local claimindex claimindex
		* else if `fclass'==5 local claimindex CLM_ID
		
		* Claim Carrier Number (joint with patient ID and Carrier Control Number, uniquely identifies the claim)
		if      `fclass'==1 local carrier bcarrier
		else if `fclass'==2 local carrier carr_num
		else if `fclass'<=5 local carrier CARR_NUM
		
		* Claim Carrier Control Number (joint with patient ID and Carrier Number, uniquely identifies the claim).  
		*	Note: in 2006-2008, resdac documentation shows the presenceof a carrier control number; could CLM_ID be the encrypted version (str15 type matches both)?  Either way, it should work.
		if      `fclass'==1 local carrcntl bccn
		else if `fclass'<=4 local carrcntl carrcntl
		else if `fclass'==5 local carrcntl CLM_ID
		
		* Performing doctor UPIN
		if      `fclass'==1 local prf_upin blnppun
		else if `fclass'==2 local prf_upin prf_upin
		else if `fclass'>=3 local prf_upin PRF_UPIN
	
		* Performing doctor NPI
		if      `fclass'==1 local prf_npi PRF_NPI
		else if `fclass'<=4 local prf_npi prfnpi
		else if `fclass'>=5 local prf_npi PRF_NPI
		
		* Referring doctor UPIN
		if      `fclass'==1 local rfr_upin brfrupin 
		else if `fclass'==2 local rfr_upin rfr_upin
		else if `fclass'>=3 local rfr_upin RFR_UPIN
	
		* Referring doctor NPI
		if      `fclass'==1 local rfr_npi RFR_NPI
		else if `fclass'==2 local rfr_npi rfr_npi
		else if `fclass'>=3 local rfr_npi RFR_NPI
		
		* Line Diagnosis
		if      `fclass'==1 local linedgns blndx
		else if `fclass'>=2 local linedgns linedgns
		
		* Claim Diagnoses
		if      `fclass'==1 local clmsdgns bdx
		else if `fclass'==2 local clmsdgns dgns_cd
		else if `fclass'==3 local clmsdgns DGNS_CD
		else if `fclass'==4 local clmsdgns dgns_cd
		else if `fclass'==5 local clmsdgns DGNS_CD
		if `fclass'<=4 {
			forvalues i = 1/4 {
				local clmsdgns`i' `clmsdgns'`i'
			}		
		}
		else if `fclass'==5 {
			forvalues i = 1/8 {
				local clmsdgns`i' `clmsdgns'`i'
			}
		}
		
		* HCPCS code
		if      `fclass'==1 local hcpcs bhcpcs
		else if `fclass'==2 local hcpcs hcpcs_cd
		else if `fclass'>=3 local hcpcs HCPCS_CD
		
		* HCPCS code modifiers
		forvalues i = 1/2 {
		if      `fclass'==1 local hcpcs`i' bhmod`i'
		else if `fclass'==2 local hcpcs`i' mdfr_cd`i'
		else if `fclass'>=3 local hcpcs`i' MDFR_CD`i'
		}
		
		* HCPCS year
		if      `fclass'==1 local hcpcsyr HCPCS_YR
		else if `fclass'==2 local hcpcsyr hcpcs_yr
		else if `fclass'>=3 local hcpcsyr HCPCS_YR
		
		* Start date, line item
		if      `fclass'==1 local linefromdt bexpdt1
		else if `fclass'==2 local linefromdt expnsdt1
		else if `fclass'==3 local linefromdt EXPNSDT1
		else if `fclass'==4 local linefromdt sexpndt1
		else if `fclass'==5 local linefromdt EXPNSDT1
		
		* End date, line item
		if      `fclass'==1 local linethrudt bexpdt2
		else if `fclass'==2 local linethrudt expnsdt2
		else if `fclass'==3 local linethrudt EXPNSDT2
		else if `fclass'==4 local linethrudt sexpndt2
		else if `fclass'==5 local linethrudt EXPNSDT2
		
		* Start date, claim
		if      `fclass'==1 local claimfromdt bfromdt
		else if `fclass'==2 local claimfromdt from_dt
		else if `fclass'==3 local claimfromdt FROM_DT
		else if `fclass'==4 local claimfromdt sfromdt
		else if `fclass'>=5 local claimfromdt FROM_DT
		
		* End date, claim
		if      `fclass'==1 local claimthrudt bthrudt
		else if `fclass'==2 local claimthrudt thru_dt
		else if `fclass'==3 local claimthrudt THRU_DT
		else if `fclass'==4 local claimthrudt sthrudt
		else if `fclass'>=5 local claimthrudt THRU_DT
		
		* Place of service 
		if      `fclass'==1 local plcsvc bplacsv
		else if `fclass'>=2 local plcsvc plcsrvc
		
		* Line allowed charges
		if      `fclass'==1 local allowchg ballow
		else if `fclass'>=2 local allowchg lalowchg
		
		* Provider zip
		if      `fclass'==1 local provzip bppzip
		else if `fclass'>=2 local provzip provzip
		
		* Beneficiary mailing contact zip
		if      `fclass'==1 local bzip bzip
		else if `fclass'==2 local bzip bene_zip
		else if `fclass'==3 local bzip BENE_ZIP
		else if `fclass'==4 local bzip zipcode
		else if `fclass'>=5 local bzip ZIP_CD
		
		* Beneficiary mailing contact zip
		if      `fclass'==1 local bstate bstate
		else if `fclass'==2 local bstate state_cd
		else if `fclass'==3 local bstate STATE_CD
		else if `fclass'==4 local bstate state
		else if `fclass'>=5 local bstate STATE_CD
		
		* Beneficiary sex
		if      `fclass'==1 local bsex bsex
		else if `fclass'<=4 local bsex sex
		else if `fclass'==5 local bsex GNDR_CD
		
		* Beneficiary race
		if      `fclass'==1 local brace brace
		else if `fclass'<=4 local brace race
		else if `fclass'==5 local brace RACE_CD
		
		* Beneficiary date of birth
		if      `fclass'==1 local bdob bbdate
		else if `fclass'==2 local bdob bene_dob
		else if `fclass'==3 local bdob BENE_DOB
		else if `fclass'==4 local bdob sdob
		else if `fclass'>=5 local bdob DOB_DT
	}
	
	* Which variables to extract each year, and which variables are missing?
	if      `fclass'<=4 local dgnsvars linedgns clmsdgns1 clmsdgns2 clmsdgns3 clmsdgns4
	else if `fclass'==5 local dgnsvars linedgns clmsdgns1 clmsdgns2 clmsdgns3 clmsdgns4 clmsdgns5 clmsdgns6 clmsdgns7 clmsdgns8
	local carvars carrier carrcntl prf_upin prf_npi rfr_upin rfr_npi `dgnsvars' linedgns_orig clmsdgns?_orig hcpcs hcpcs1 hcpcs2 hcpcsyr linefromdt linethrudt claimfromdt claimthrudt plcsvc allowchg provzip* bzip bstate bsex brace bdob carrier
	local allvars ehic bene_id `carvars' chem* ftype fyear
	if 1 {
		if      `fclass'<=4 local keepvars ehic         carrier carrcntl prf_upin prf_npi rfr_upin rfr_npi `dgnsvars' hcpcs hcpcs1 hcpcs2 hcpcsyr linefromdt linethrudt claimfromdt claimthrudt plcsvc allowchg provzip bzip bstate bsex brace bdob carrier
		else if `fclass'==5 local keepvars      bene_id carrier carrcntl prf_upin prf_npi rfr_upin rfr_npi `dgnsvars' hcpcs hcpcs1 hcpcs2 hcpcsyr linefromdt linethrudt claimfromdt claimthrudt plcsvc allowchg provzip bzip bstate bsex brace bdob carrier
		if      `fclass'<=4 local missvars      bene_id
		else if `fclass'==5 local missvars ehic
	}
	
	* Load current file piece, and keep select variables only
	local keepers
	foreach keepvar of local keepvars {
		local keepers `keepers' ``keepvar''
	}
	use `keepers' chem* using `home'/data/extracts/car/`clmsfile', clear
	
	* Generate claimindex to be missing in years where variable not already defined
	if "`claimindex'"=="" {
		gen double claimindex = .
	}
	
	* Generate other missing variables
	foreach missvar of local missvars {
		gen `missvar'= ""
	}
	
	* Rename variables for consistency across years.  Note: CLM_ID takes on both carrcntl and claimindex in years 2006-2008.
	foreach revar of local keepvars {
		if      "`revar'"=="ehic" assert 1==1
		else    capture rename ``revar'' `revar'
	}
	
	* Generate new variables "cms file type" and "cms file year"
	gen ftype = "car05"
	gen fyear = substr("`clmsfile'",-4,4)
	destring fyear, replace
	
	* Convert birth dates from strings to dates when appropriate
	qui cap di substr(bdob,1,1)
	if !(_rc) {
		rename bdob bdob_str
		gen bdob = date(bdob_str,"YMD")
		format bdob %d
		drop bdob_str
	}
	
	* Convert HCPCS_yr code into integer
	qui cap di substr(hcpcsyr,1,1)
	if !(_rc) {
		destring hcpcsyr, replace
	}
	
	* Define the 5-digit provider zip
	rename provzip provzip_orig
	gen provzip = substr(provzip_orig,1,5)
	
	* Clean the diagnosis codes, keeping a copy of the original with the "orig" extension
	foreach dgnsvar of local dgnsvars {
		* Flag invalid codes
		icd9 check `dgnsvar', generate(`dgnsvar'_invalid)
		tab `dgnsvar'_invalid
		
		* Keep a copy of the original
		gen `dgnsvar'_orig = `dgnsvar'
		
		* Create a cleaned version, and verify cleanness
		replace `dgnsvar' = "" if `dgnsvar'_invalid
		icd9 clean `dgnsvar'
		
		* Drop the "invalid" code flag
		drop `dgnsvar'_invalid
	}
	
	* Generate a claim ID variable (the missing option accommodates missing ehic or bene_id)
	egen claimid = group(ehic bene_id carrier carrcntl), missing
		
	* Order for consistency, then save a copy
	order `allvars'
	noisily di "saving `clmsfile'_std.dta"
	shell mkdir -p `home'/data/extracts/step1/car
	saveold `home'/data/extracts/step1/car/`clmsfile'_std, replace
}

* Lump the bcd files into the main year file, in 1998 and 1999
foreach yr in 1998 1999 {
	* Load original file, then append bcd file
	use `home'/data/extracts/step1/car/`ftyp'_`yr'_std, clear
	append using `home'/data/extracts/step1/car/`ftyp'bcd_`yr'_std
	rm `home'/data/extracts/step1/car/`ftyp'bcd_`yr'_std.dta
	
	* Re-generate claimid, because it no longer uniquely identifies claims after the merge
	*	The following claimid is the same as "group(ehic bene_id carrier carrcntl bcd)", where bcd flags obs from the bcd file
	drop claimid
	egen claimid = group(ehic bene_id carrier carrcntl), missing
	
	* Save
	saveold `home'/data/extracts/step1/car/`ftyp'_`yr'_std, replace
}

* end: Step 1car
}


* 	Step 1.Op. Outpatient.   Create standardized annual outpatient(op) chemo claim files (100%).
*	Input:
* 		1. `home'/data/extracts/op/chem_op100_year.dta
*	Output:
* 		1. `home'/data/extracts/step1/op/chem_op100_year_std.dta
* ----------------------------------------------------------------------------------------------------------------------------------------------------------
if step1_op {

* List the carrier files to be pooled together
local ftyp chem_op100

* Prepare each part of the pool for consistency across years, e.g. selecting and renaming variables
* 	This loop takes roughly 45 minutes to complete (cleaning the diagnostic codes is what takes the most time)
qui forvalues yr=1998/2008 {
	* First, specify the class of variables to be pulled from this claims file. (The set of available variables and their names change over time.)
	if 		(`yr'==1998)   				local fclass = 1
	else if	(1999<=`yr' & `yr'<=2000) 	local fclass = 2
	else if	(2001<=`yr' & `yr'<=2005) 	local fclass = 3
	else if	(2006<=`yr' & `yr'<=2008) 	local fclass = 4
	
	* Define the variable names to extract for each year
	if 1 {
		* Patient IDs
		local ehic ehic
		local bene_id bene_id
		
		* Claim Provider Number 
		if      `fclass'<=4 local provider provider
		
		* Claim Organizational NPI Number (not sure if this is useful to us)
		if      `fclass'<=4 local orgnpi orgnpinm
		
		* Claim Index
		if      `fclass'==1 local claimindex 
		else if `fclass'==2 local claimindex LINK_NUM
		else if `fclass'==3 local claimindex claimindex
		else if `fclass'==4 local claimindex CLM_ID
		
		* Attending doctor
		if      `fclass'<=4 local at_upin AT_UPIN
		if      `fclass'<=4 local at_npi  AT_NPI
		
		* Operating doctor
		if      `fclass'<=4 local op_upin OP_UPIN
		if      `fclass'<=4 local op_npi  OP_NPI
		
		* Other doctor
		if      `fclass'<=4 local ot_upin OT_UPIN
		if      `fclass'<=4 local ot_npi  OT_NPI
		
		* Claim Diagnoses
		if      `fclass'<=2 local clmsdgns DGNSCD
		else if `fclass'==3 local clmsdgns dgns_cd
		else if `fclass'==4 local clmsdgns DGNSCD
		forvalues i = 1/10 {
			local clmsdgns`i' `clmsdgns'`i'
		}
		
		* HCPCS code
		*	Note: the number of codes varies by year
		* if      `fclass'==1 local hcpcs bhcpcs
		
		* HCPCS code modifiers
		* forvalues i = 1/2 {
		* if      `fclass'==1 local hcpcs`i' mdfcd`i'
		* }
		
		* APC code
		*	Note: the number of codes varies by year
		
		* Revenue center date
		* if      `fclass'==1 local linefromdt bexpdt1
		
		* Start date, claim
		if      `fclass'<=2 local claimfromdt FROM_DT
		else if `fclass'==3 local claimfromdt sfromdt
		else if `fclass'==4 local claimfromdt FROM_DT
		
		* End date, claim
		if      `fclass'<=2 local claimthrudt THRU_DT
		else if `fclass'==3 local claimthrudt sthrudt
		else if `fclass'==4 local claimthrudt THRU_DT
		
		* Claim Total Charge Amount
		if      `fclass'<=1 local totchg TOT_CHRG
		
		* Provider state
		if      `fclass'<=4 local provstate prstate
		
		* Factility type
		if      `fclass'<=4 local factype FAC_TYPE
		
		* Claim type of service
		if      `fclass'<=4 local clmstos TYPESRVC
		
		* Beneficiary mailing contact zip
		if      `fclass'<=2 local bzip BENE_ZIP
		else if `fclass'==3 local bzip zipcode
		else if `fclass'==4 local bzip ZIP_CD
		
		* Beneficiary mailing contact state
		if      `fclass'<=2 local bstate STATE_CD
		else if `fclass'==3 local bstate state
		else if `fclass'==4 local bstate STATE_CD
		
		* Beneficiary sex
		if      `fclass'<=3 local bsex sex
		else if `fclass'==4 local bsex 
		
		* Beneficiary race
		if      `fclass'<=3 local brace race
		else if `fclass'==4 local brace RACE_CD
		
		* Beneficiary date of birth
		if      `fclass'<=2 local bdob BENE_DOB
		else if `fclass'==3 local bdob sdob
		else if `fclass'==4 local bdob DOB_DT
	}
	
	* Which variables to extract each year, and which variables are missing?
	local dgnsvars clmsdgns1 clmsdgns2 clmsdgns3 clmsdgns4 clmsdgns5 clmsdgns6 clmsdgns7 clmsdgns8 clmsdgns9 clmsdgns10
	local docvars at_upin at_npi op_upin op_npi ot_upin ot_npi
	local opvars provider orgnpi claimindex `docvars' `dgnsvars' claimfromdt claimthrudt totchg provstate factype bzip bstate bsex brace bdob
	local allvars claimid ehic bene_id `opvars' chem* ftype fyear
	if 1 {
		if      `fclass'<=3 local keepvars ehic         `opvars'
		else if `fclass'==4 local keepvars      bene_id `opvars'
		if      `fclass'<=3 local missvars      bene_id
		else if `fclass'==4 local missvars ehic         bsex
	}
	
	* Load current file piece, and keep select variables only
	local keepers
	foreach keepvar of local keepvars {
		local keepers `keepers' ``keepvar''
	}
	* desc `keepers' using `home'/data/extracts/op/`ftyp'_`yr'
	use `keepers' chem* using `home'/data/extracts/op/`ftyp'_`yr', clear
	
	* Generate claimindex to be missing in years where variable not already defined
	if "`claimindex'"==""  gen double claimindex = .
	
	* Generate other missing variables
	foreach missvar of local missvars {
		gen `missvar'= ""
	}
	
	* Rename variables for consistency across years.  Note: CLM_ID takes on both carrcntl and claimindex in years 2006-2008.
	foreach revar of local keepvars {
		capture rename ``revar'' `revar'
	}
	
	* Generate new variables "cms file type" and "cms file year"
	gen ftype = "op100"
	gen fyear = `yr'
	
	* Convert birth dates from strings to dates when appropriate
	qui cap confirm string bdob
	if !(_rc) {
		rename bdob bdob_str
		gen bdob = date(bdob_str,"YMD")
		format bdob %d
		drop bdob_str
	}
	
	* Clean the diagnosis codes, keeping a copy of the original with the "orig" extension
	foreach dgnsvar of local dgnsvars {
		noisily di "cleaning `dgnsvar'"
		
		* Flag invalid codes
		icd9 check `dgnsvar', generate(`dgnsvar'_invalid)
		tab `dgnsvar'_invalid
		
		* Keep a copy of the original
		gen `dgnsvar'_orig = `dgnsvar'
		
		* Create a cleaned version, and verify cleanness
		replace `dgnsvar' = "" if `dgnsvar'_invalid
		icd9 clean `dgnsvar'
		
		* Drop the "invalid" code flag
		drop `dgnsvar'_invalid
	}
	
	* Generate a claim ID variable.  For outpatient years <=2000 (fclass<=2), an observation is a claim.
	if `yr'<=2005 gen id = ehic
	if 2006<=`yr' gen id = bene_id
	if      `fclass'<=2 gen claimid = _n
	else if `fclass'<=4 egen claimid = group(id claimindex), missing
	drop id
	
	* Order for consistency, then save a copy
	order `allvars'
	sort claimid
	noisily di "saving `ftyp'_`yr'_std.dta"
	shell mkdir -p `home'/data/extracts/step1/op
	saveold `home'/data/extracts/step1/op/`ftyp'_`yr'_std, replace
}

* end: Step 1op
}


* 	Step 1.Dis. Create line and clms level Carrier and Outpatient claims, adding disease categories based on diagnosis codes.
*	Input:
* 		1. `home'/data/extracts/step1/car/chem_car05_year_std.dta
* 		2. `home'/data/extracts/step1/op/chem_op100_year_std.dta
*	Output:
* 		1. `home'/data/extracts/step1/car/chem_car05_year_linedz.dta
* 		2. `home'/data/extracts/step1/op/chem_op100_year_linedz.dta
* 		3. `home'/data/extracts/step1/car/chem_car05_year_clmsdz.dta
* 		4. `home'/data/extracts/step1/op/chem_op100_year_clmsdz.dta
* ----------------------------------------------------------------------------------------------------------------------------------------------------------
if step1_dzs {
/*

DISEASE CATEGORIES AND DIAGNOSIS TABLE
--------------------------------------------------------------------------------------------------------------------------------------------------
id	desease											"definitely" ICD-9 codes			"maybe" ICD-9 codes
--------------------------------------------------------------------------------------------------------------------------------------------------
1	breast cancer									174.X								233.0, 217, 198.81, 239.3, 238.3, V10.3
2	cutaneous T-cell lymphoma						202.2X, 202.1X						696.2, 696.X, 202.7X, V10.79
3	bladder cancer									188.X								233.7, 223.3, 198.1, 239.4, 236.7, V10.51
4	brain cancer									191.X								225.0, 198.3, 239.6, 237.5, V10.85
5	acute myeloid leukemia (AML)					205.0X								205.X, 206.X, 207.X, 208.X, 202.4X, 202.9X, V10.62
6	prostate cancer									185									233.4, 222.2, 602.3, 187.8, 233.6, 222.8, 239.5, 236.5, 198.82, V10.46
7	acute promyelocytic leukemia (APL)				205.0X								205.X, 206.X, 207.X, 208.X, 202.4X, 202.9X, V10.62
8	B-cell chronic lymphocytic leukemia (B-CLL)		204.1X								205.X, 206.X, 207.X, 208.X, 202.4X, 202.9X, V10.61
9	hypercalcemia of malignancy						275.42
10	B-cell non-Hodgkin's lymphoma					200.XX, 202.XX						V10.71, V10.79
11	colon cancer, colorectal carcinoma				153.X, 154.0-154.1					211.3, 230.3, 239.0, 235.2, 197.5, V10.05
12	lung cancer										162.X								231.2, 212.3, 235.7, 239.1, 197.0, V10.11
13	multiple myeloma								203.0X								V10.79
14	acute lymphoblastic leukemia (ALL)				204.0X								V10.61
15	T-cell ALL and T-cell lymphoblastic lymphoma	204.0X, 204.2X, 204.8X, 204.9X		204.1X, V10.61
16	myelodysplastic syndromes						238.7X
17	kidney cancer									189.0-189.1							223.0, 223.1, 233.9, 236.91, 239.5, 198.0, V10.52
--------------------------------------------------------------------------------------------------------------------------------------------------
*/
* Specify code ranges
if 1 {
	* "Definite" ICD-9 code ranges
	local icd9range_def_1  174.*
	local icd9range_def_2  202.2* 202.1*
	local icd9range_def_3  188.*
	local icd9range_def_4  191.*
	local icd9range_def_5  205.0*
	local icd9range_def_6  185
	local icd9range_def_7  205.0*
	local icd9range_def_8  204.1*
	local icd9range_def_9  275.42
	local icd9range_def_10 200.* 202.*
	local icd9range_def_11 153.* 154.0/154.1
	local icd9range_def_12 162.*
	local icd9range_def_13 203.0*
	local icd9range_def_14 204.0*
	local icd9range_def_15 204.0* 204.2* 204.8* 204.9*
	local icd9range_def_16 238.7*
	local icd9range_def_17 189.0/189.1

	* "Maybe" ICD-9 code ranges
	local icd9range_may_1  233.0 217 198.81 239.3 238.3 V10.3
	local icd9range_may_2  696.2 696.* 202.7* V10.79
	local icd9range_may_3  233.7 223.3 198.1 239.4 236.7 V10.51
	local icd9range_may_4  225.0 198.3 239.6 237.5 V10.85
	local icd9range_may_5  205.* 206.* 207.* 208.* 202.4* 202.9* V10.62
	local icd9range_may_6  233.4 222.2 602.3 187.8 233.6 222.8 239.5 236.5 198.82 V10.46
	local icd9range_may_7  205.* 206.* 207.* 208.* 202.4* 202.9* V10.62
	local icd9range_may_8  205.* 206.* 207.* 208.* 202.4* 202.9* V10.61
	local icd9range_may_9  
	local icd9range_may_10 V10.71 V10.79
	local icd9range_may_11 211.3 230.3 239.0 235.2 197.5 V10.05
	local icd9range_may_12 231.2 212.3 235.7 239.1 197.0 V10.11
	local icd9range_may_13 V10.79
	local icd9range_may_14 V10.61
	local icd9range_may_15 204.1* V10.61
	local icd9range_may_16 
	local icd9range_may_17 223.0 223.1 233.9 236.91 239.5 198.0 V10.52
}

* Mark line items from standardized files for particular diseases categories
*	Note: For years 1998-2000, outpatient files already aggregated to the claim level
foreach ftyp in chem_car05 chem_op100 {
qui forvalues yr=1998/2008 {
	noisily di "Working on year `yr' and filetype `ftyp'"
	
	* Load standardized claims file
	if "`ftyp'"=="chem_car05" use `home'/data/extracts/step1/car/`ftyp'_`yr'_std, clear
	if "`ftyp'"=="chem_op100" use `home'/data/extracts/step1/op/`ftyp'_`yr'_std, clear

	* Flag whether each disease category shows up in a diagnosis
	forvalues id=1/17 {
		nois di "disease `id'.."
		
		* Generate auxiliary disease flags: I.e. do any of the diagnosis variables indicate this disease category?
		if "`ftyp'"=="chem_car05" local dgnsvars linedgns clmsdgns?
		if "`ftyp'"=="chem_op100" local dgnsvars clmsdgns? clmsdgns10
		foreach dgnsvar of varlist `dgnsvars' {
			icd9 generate `dgnsvar'_def`id'=`dgnsvar', range(`icd9range_def_`id'')
			if "`icd9range_may_`id''"!="" icd9 generate `dgnsvar'_may`id'=`dgnsvar', range(`icd9range_may_`id'')
			else                               generate `dgnsvar'_may`id' = 0
		}
		
		* Prepare to make flag for whether disease category indicated by any diagnosis
		if "`ftyp'"=="chem_car05" {
			local dgns_def linedgns_def`id'
			local dgns_may linedgns_may`id'
		}
		if "`ftyp'"=="chem_op100" {
			local dgns_def clmsdgns10_def`id'
			local dgns_may clmsdgns10_may`id'
		}
		foreach dgnsvar of varlist clmsdgns? {
			local dgns_def `dgns_def',`dgnsvar'_def`id'
			local dgns_may `dgns_may',`dgnsvar'_may`id'
		}
		di "`dgns_def'"
		di "`dgns_may'"
		
		* Calculate whether any of the diagnoses flag the disease category
		gen dgns_dz`id'_def = max(`dgns_def')
		gen dgns_dz`id'_may = max(`dgns_may')
		
		* Drop aux disease variables
		if "`ftyp'"=="chem_car05" drop linedgns_???`id' clmsdgns?_???`id'
		if "`ftyp'"=="chem_op100" drop clmsdgns?_???`id' clmsdgns10_???`id'
	}
	
	* Compress the dgns_dz variables to byte
	compress dgns_dz*
	
	* Save line-item disease-marked files
	if "`ftyp'"=="chem_car05" saveold `home'/data/extracts/step1/car/`ftyp'_`yr'_linedz, replace
	if "`ftyp'"=="chem_op100" saveold `home'/data/extracts/step1/op/`ftyp'_`yr'_linedz, replace
}
}


* Collapse line-item disease-marked files down to clms-level
foreach ftyp in chem_car05 chem_op100 {
qui forvalues yr=1998/2008 {
	* Load disease category files
	if "`ftyp'"=="chem_car05" use `home'/data/extracts/step1/car/`ftyp'_`yr'_linedz, clear
	if "`ftyp'"=="chem_op100" use `home'/data/extracts/step1/op/`ftyp'_`yr'_linedz, clear
	
	* Collapse down to the claim level
	if "`ftyp'"=="chem_car05" {
		local maxvars   (max) linethrudt chem_* dgns_*
		local minvars   (min) linefromdt
		local firstvars (first) ehic bene_id carrier carrcntl claimindex clmsdgns? claimfromdt claimthrudt ftype fyear
	}
	if "`ftyp'"=="chem_op100" {
		local maxvars   (max) chem_* dgns_*
		local minvars   
		local firstvars (first) ehic bene_id at_* op_* ot_* provider provstate orgnpi factype claimindex claimfromdt claimthrudt clmsdgns? clmsdgns10 totchg ftype fyear 
		local dropvars  bzip bstate bsex brace bdob clmsdgns?_orig clmsdgns10_orig 
	}
	collapse `maxvars' `minvars' `firstvars', by(claimid) fast
	
	* Save clms-item disease-marked files
	if "`ftyp'"=="chem_car05" saveold `home'/data/extracts/step1/car/`ftyp'_`yr'_clmsdz, replace
	if "`ftyp'"=="chem_op100" saveold `home'/data/extracts/step1/op/`ftyp'_`yr'_clmsdz, replace
}
}
* end: step1_dis
}


* 	Step 1.Bene. Create a "masterfile" of chemo beneficiary info, and other aux beneficiary files (e.g. ehic->bene_id crosswalk for chemo ehics)
*	Input: 
*		1. `home'/data/extracts/step1/car/chem_car05_year_std.dta
*		2. `home'/data/extracts/step1/op/chem_op100_year_std.dta
*		3. `home'/data/extracts/denom/den100_year_select.dta
*		4. `home'/data/extracts/denom/ehicbenex_one.dta
*	Output:
* 		1. `home'/data/extracts/step1/aux/chem_beneids.dta 					(pool of bene_ids that ever show up in op/car chemo extracts)
* 		2. `home'/data/extracts/step1/aux/chem_ehicbenex_one.dta 			(ehic-to-bene_id crosswalk, limited to ehics ever showing up in op/car chemo extracts and matching to a bene_id)
* 		3. `home'/data/extracts/denom/den100_`yr'_select_beneid 			(denominator files with bene_ids every year, sorted by bene_id)
* 		4. `home'/data/extracts/step1/denom/den100_year_chem 				(denominator extracts for each year)
* 		5. `home'/data/extracts/step1/denom/den100_1998_2008_chem 		(denominator extracts pooled across 1998-2008, plus dob/race/sex/dod variables cleaned)
* 		6. `home'/data/extracts/step1/aux/chem_beneinfo.dta 					(pooled denominator extracts + Dartmouth Atlas data + lat/lon data)
* ----------------------------------------------------------------------------------------------------------------------------------------------------------
if step1_bene {
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
* 1-2. Create a pool of all bene_ids who ever show up in op/car claims, plus a crosswalk matching analagous ehics to bene_ids
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
if 1 {
* Extract ehics/bene_ids from car/op chemo claims
foreach ftyp in chem_car05 chem_op100 {
	* Extract ehics
	forvalues yr = 1998/2005 {
		* Load standardized claims file, keeping only ehic
		if "`ftyp'"=="chem_car05" use ehic using `home'/data/extracts/step1/car/`ftyp'_`yr'_std, clear
		if "`ftyp'"=="chem_op100" use ehic using `home'/data/extracts/step1/op/`ftyp'_`yr'_std, clear
		bys ehic: keep if _n==1
		keep if !missing(ehic)
		saveold `home'/data/extracts/step1/`ftyp'_`yr'_ehics, replace
	}
	
	* Extract bene_ids
	forvalues yr = 2006/2008 {
		* Load standardized claims file, keeping only bene_id
		if "`ftyp'"=="chem_car05" use bene_id using `home'/data/extracts/step1/car/`ftyp'_`yr'_std, clear
		if "`ftyp'"=="chem_op100" use bene_id using `home'/data/extracts/step1/op/`ftyp'_`yr'_std, clear
		bys bene_id: keep if _n==1
		keep if !missing(bene_id)
		saveold `home'/data/extracts/step1/`ftyp'_`yr'_beneids, replace
	}
}

* Pool ehics together, from years 1998-2005
clear
foreach ftyp in chem_car05 chem_op100 {
forvalues yr = 1998/2005 {
	append using `home'/data/extracts/step1/`ftyp'_`yr'_ehics
	bys ehic: keep if _n==1
	rm `home'/data/extracts/step1/`ftyp'_`yr'_ehics.dta
}
}
saveold `home'/data/extracts/step1/chem_ehics, replace

* Pool bene_ids together, from years 2006-2008
clear
foreach ftyp in chem_car05 chem_op100 {
forvalues yr = 2006/2008 {
	append using `home'/data/extracts/step1/`ftyp'_`yr'_beneids
	bys bene_id: keep if _n==1
	rm `home'/data/extracts/step1/`ftyp'_`yr'_beneids.dta
}
}
saveold `home'/data/extracts/step1/chem_beneids, replace

* Convert ehics to bene_id using bene_id crosswalk (should be a copy in the denom claims extract folder), and make the following cuts:
*	Drop ehics that don't match a bene_id: drops ~100/1,400,000 ehics
*	Save this ehic-to-bene_id crosswalk file
* 	Drop duplicate bene_ids: drops ~1,000/1,400,000 observations
use `home'/data/extracts/step1/chem_ehics, clear
merge m:1 ehic using PATH_TO_MEDICARE_DATA/xw/ehicbenex_one.dta, keep(match) nogenerate noreport keepusing(bene_id)
bys ehic: assert _N==1
saveold `home'/data/extracts/step1/aux/chem_ehicbenex_one, replace
keep bene_id
bys bene_id: keep if _n==1

* Merge in remaining bene_ids, from years 2006-2008
append using `home'/data/extracts/step1/chem_beneids
bys bene_id: keep if _n==1

* Save bene_id pool, and clean up intermediate chem_ehics and chem_beneids
saveold `home'/data/extracts/step1/aux/chem_beneids, replace
rm `home'/data/extracts/step1/chem_ehics.dta
rm `home'/data/extracts/step1/chem_beneids.dta
}

* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
* 3-5. Next, create denominator extracts/pool limited to bene_ids in the chemo-beneids pool
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
if 1 {
* If not already done, save a copy of the bene_id crosswalk to the denomout folder (which should be on a fast, local drive)
qui forvalues yr = 1998/2008 {
	noisily di "Processing den100_`yr'_select..."
	use `home'/data/extracts/denom/den100_`yr'_select, clear
	
	* Check whether bene_id (in lower case) exists as a variable. If not (i.e. _rc!=0), move into the inner loop.
	cap confirm variable bene_id
	if _rc!=0 {
		cap confirm variable BENE_ID
		if _rc==0 rename BENE_ID bene_id
	}
	
	* Merge in bene_id info, for years where ehic is the beneficiary ID.  A very few ehics do not match to a bene_id (<0.01% of ehics in 1998 denom file).
	cap confirm variable ehic
	if _rc==0 {
		sort ehic
		merge m:1 ehic using PATH_TO_MEDICARE_DATA/xw/ehicbenex_one.dta, keep(master match) nogenerate noreport keepusing(bene_id)
	}
	
	* Sort by bene_id (then by ehic, if available)
	cap confirm variable ehic
	if _rc==0 sort bene_id ehic 
	else      sort bene_id
	order bene_id
	
	* Save
	saveold `home'/data/extracts/denom/den100_`yr'_select_beneid, replace
	noisily di "Finished with year `yr'"
}

* Create denominator extracts for each year 1998-2008
forvalues yr = 1998/2008 {
	* Load the denominator file (the one with bene_ids)
	use `home'/data/extracts/denom/den100_`yr'_select_beneid, clear
	sort bene_id
	
	* Keep only observations matching the chemo bene_id pool
	merge m:1 bene_id using `home'/data/extracts/step1/aux/chem_beneids, keep(match) nogenerate noreport
	
	* Save
	shell mkdir -p `home'/data/extracts/step1/denom
	saveold `home'/data/extracts/step1/denom/den100_`yr'_chem, replace
}

* Pool denominator extracts into single year, and drop the ehic variable (already, the very few ehics that don't match any bene_id have been dropped, so I won't be matching on ehic anyway)
clear
local denomfiles
forvalues yr = 1998/2008 {
	local denomfiles `denomfiles' `home'/data/extracts/step1/denom/den100_`yr'_chem
}
append using `denomfiles', generate(dyear)
replace dyear = dyear+1997
drop ehic

* Flag the following bene_ids:
*	1. flag_dup: Folks with multiple observations in a single year (473/2,068,532)
*	2. flag_ars: Inconsistent age/race/sex (41,098/2,068,532)
if 1 {
	sort bene_id dyear
	by bene_id dyear: gen flag = (_N>1)
	by bene_id: egen flag_dup = max(flag)
	by bene_id: replace flag = (bdob!=bdob[1] | brace!=brace[1] | bsex!=bsex[1])
	by bene_id: egen flag_ars = max(flag)
	drop flag
}

* Generate modal age, race, sex variables
foreach var of varlist bdob brace bsex {
	di "Calculate mode for `var'"
	by bene_id: egen `var'_minmode  = mode(`var'),  minmode
	replace `var' = `var'_minmode
	drop `var'_minmode
}

* Generate consistent date of death. 
*	For 1,661 bene_ids, min(dod)<max(dod). 75% of these discrepancies are less than 31 days. The max is 3658 days (10 years)
*	1. bdod: What dead date to use? max(verified death date), if it exists; otherwise, max(any death date)
* 	2. flag_dod: flag individuals for whom a verified death date differs from bdod_use (1,430/2,066,575)
if 1 {
	* 	generate max(verified dod) and max(any dod) variables
	gen bdod_v = bdod if bvdod=="V"
	by bene_id: egen bdod_vmax = max(bdod_v)
	by bene_id: egen bdod_max  = max(bdod)
	
	* 	new bdod variable, save original version
	generat bdod_use = bdod_max
	replace bdod_use = bdod_vmax if !missing(bdod_vmax)
	rename bdod bdod_orig
	rename bdod_use bdod
	format bdod %d
	
	*	flag verified dod discrepancies
	gen flag = (bvdod=="V" & bdod_orig!=bdod)
	by bene_id: egen flag_dod = max(flag)
	drop bdod_v bdod_vmax bdod_max flag
}

* Keep only one observation per bene_id-year, and save
* 	Note: Missing numeric values (for bdod) are interpreted as being larger than any other number, so they are placed last
sort bene_id dyear bdod
by bene_id dyear: keep if _n==1
order bene_id dyear bdob brace bsex bzip bstate bdod bdod_orig bvdod flag*
saveold `home'/data/extracts/step1/denom/den100_1998_2008_chem, replace

* end: if 1
}

* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
* 6. Create a beneficiary summary file, including year-specific HSA, HRR, and lat/lon for each patient's zip
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
if 1 {
* Load the chemo denominator pool
use `home'/data/extracts/step1/denom/den100_1998_2008_chem, clear

* Merge in HSA and HRR info from the Dartmouth Atlas files. Not all zipcodes match (e.g. zips outside US)
destring bzip, gen(zipcode)
gen zyear = dyear
sort zipcode zyear
merge m:1 zipcode zyear using `home'/data/crosswalks/ziphsahrr_95_10_filled, keep(master match) nogenerate noreport keepusing(hsanum hsacity hsastate hrrnum hrrcity hrrstate)
foreach var of varlist hsanum hsacity hsastate hrrnum hrrcity hrrstate {
	rename `var' b`var'
}
drop zyear

* Merge in zipcode lat, lon, and state code
merge m:1 zipcode using `home'/data/crosswalks/zip_lat_lon, keep(master match) nogenerate noreport keepusing(Lat Long State)
rename Lat bzlat
rename Long bzlon
rename State bzstate
drop zipcode

* Sort and save
sort bene_id dyear
saveold `home'/data/extracts/step1/aux/chem_beneinfo.dta, replace

* end: if 1
}

* end: step1_bene
}


* 	Step 1.Prov. Create a "masterfile" of chemo provider info
*	Input: 
*		1. `home'/data/extracts/step1/op/chem_op100_`yr'_clmsdz.dta
*		2. `home'/data/pos/pos_1998_2008.dta
*		3. `home'/data/crosswalks/ziphsahrr_95_10_filled.dta
*		4. `home'/data/crosswalks/zip_lat_lon.dta
*	Output:
* 		1. `home'/data/extracts/step1/aux/chem_posfilled.dta
* 		2. `home'/data/extracts/step1/aux/chem_op_providerinfo.dta
* 		3. `home'/data/extracts/step1/aux/chem_car_provzipinfo.dta
* ----------------------------------------------------------------------------------------------------------------------------------------------------------
if step1_prov {
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
* 1-2. OUTPATIENT: (provider,year)->(zip,HRR,HSA,lat,lon) crosswalk
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
if 1 {
* Create pool of provider numbers that ever show up on outpatient chemo claims. For outpatient files, provider coded at the claim level.
clear
forvalues yr = 1998/2008 {
	append using `home'/data/extracts/step1/op/chem_op100_`yr'_clmsdz, keep(provider)
	bys provider: keep if _n==1
}
saveold `home'/data/extracts/step1/aux/chem_op_providers, replace

* 0. * Extract provider information from the POS files
if 1 {
	* Load the data
	forvalues year = 1998/2008 {
		local posfile pos`year'
		use prov1680 prov0300 prov0075 prov0475 prov2905 prov2700 prov3225 prov2720 fipstate fipcnty ssamsacd using PATH_TO_MEDICARE_POS_DATA/`year'/`posfile', clear
	
		* Rename and selected variables for each provider
		rename prov1680 provider
		rename prov0300 prov_crossref
		rename prov0075 prov_category
		rename prov0475 prov_name
		rename prov2905 prov_zip
		rename prov2700 prov_st
		rename prov3225 prov_city
		rename prov2720 prov_street
		rename fipstate prov_fipstate
		rename fipcnty  prov_fipcnty
		rename ssamsacd prov_msa
		
		* Generate a hospital number, based on unique triples of (ProviderName, ProviderState, ProviderCity)
		* 	1. A similary alternative would be to base hospital on unique duples of (ProviderName,ProviderZip), but even a
		* 		slight change in mailing address could result in a different zip code, especially in urban areas.
		* egen hospital = group(prov_name prov_st prov_city)
	
		* Label selected variables
		label variable provider "(pos) 6 position numeric or alphanumeric number assigned to a certified provider"
		label variable prov_crossref "(pos) number previously assigned to a particular provider"
		label variable prov_category "(pos) category most indicative of the provider"
			destring prov_category, replace
			label define prov_category_lbl 01 "Hospitals" 02 "SNF/NF (Dually Certified)" 03 "SNF/NF (Distinct Part)" 04 "Skilled Nursing Facilities" /*
				*/ 05 "Home Health Agencies" 07 "Portable X-ray Suppliers" 08 "Outpatient Physican Therapy/Speech Pathology" 09 "End Stage Renal Disease Facilities" /*
				*/ 10 "Nursing Facilities" 11 "Intermediate Care Facility-Mentally Retarded" 12 "Rural Health Clinics" 13 "Physical Therapists in Independent Practice" /*
				*/ 14 "Comprehensive Outpatient Rehab Facilities" 15 "Ambulatory Surgical Centers" 16 "Hospices" 17 "Organ Procurement Organizations" /*
				*/ 19 "Community Mental Health Centers" 21 "Federally Qualified Health Centers" 22 "CLIA88 Laboratories"
			label values prov_category prov_category_lbl
		label variable prov_name "(pos) name of provider certified to participate in the medicare and/or medicaid"
		label variable prov_zip "(pos) the five digit postal code for the provider"
		label variable prov_st "(pos) two digit (SSA) code indicating state where facility is located"
			destring prov_st, replace
			label define prov_st_lbl 01 "ALABAMA" 02 "ALASKA" 03 "ARIZONA" 04 "ARKANSAS" 05 "CALIFORNIA" 06 "COLORADO" 07 "CONNECTICUT" 08 "DELAWARE" 09 "DISTRICT OF COLUMBIA" /*
				*/ 10 "FLORIDA" 11 "GEORGIA" 12 "HAWAII" 13 "IDAHO" 14 "ILLINOIS" 15 "INDIANA" 16 "IOWA" 17 "KANSAS" 18 "KENTUCKY" 19 "LOUISIANA" 20 "MAINE" 21 "MARYLAND" /*
				*/ 22 "MASSACHUSETTS" 23 "MICHIGAN" 24 "MINNESOTA" 25 "MISSISSIPPI" 26 "MISSOURI" 27 "MONTANA" 28 "NEBRASKA" 29 "NEVADA" 30 "NEW HAMPSHIRE" 31 "NEW JERSEY" /*
				*/ 32 "NEW MEXICO" 33 "NEW YORK" 34 "NORTH CAROLINA" 35 "NORTH DAKOTA" 36 "OHIO" 37 "OKLAHOMA" 38 "OREGON" 39 "PENNSYLVANIA" 40 "PUERTO RICO" /*
				*/ 41 "RHODE ISLAND" 42 "SOUTH CAROLINA" 43 "SOUTH DAKOTA" 44 "TENNESSEE" 45 "TEXAS" 46 "UTAH" 47 "VERMONT" 48 "VIRGIN ISLANDS" 49 "VIRGINIA" /*
				*/ 50 "WASHINGTON" 51 "WEST VIRGINIA" 52 "WISCONSIN" 53 "WYOMING" 56 "CANADA" 59 "MEXICO" 64 "AMERICAN SAMOA" 65 "GUAM" 66 "SAIPAN" 
			label values prov_st prov_st_lbl
		label variable prov_city "(pos) provider city"
		label variable prov_street "(pos) provider street address"
		label variable prov_fipstate "(pos) provider fips state code"
		label variable prov_fipcnty "(pos) provider fips county code"
		label variable prov_msa "(pos) provider SSA MSA code"
		
		* Check that provider observations are unique, and none missing
		assert !missing(provider)
		bys provider: assert _N==1
	
		* Order, sort, and save
		order provider prov_crossref prov_category prov_name prov_zip prov_st prov_city prov_street prov_fipstate prov_fipcnty prov_msa
		sort provider
		saveold `home'/data/pos/`posfile'_select, replace
	}
	
	* Append the files together, cleaning up along the way
	use `home'/data/pos/pos1998_select, clear
	rm `home'/data/pos/pos1998_select.dta
	gen pos_year=1998
	forvalues year = 1999/2008 {
		append using `home'/data/pos/pos`year'_select
		replace pos_year=`year' if missing(pos_year)
		rm `home'/data/pos/pos`year'_select.dta
	}
	sort provider pos_year
	order provider pos_year
	saveold `home'/data/pos/pos_1998_2008, replace
}

* 1. Create a "cleaned" and "filled" version of the POS pool file
if 1 {
	* There are 9,238 unique providers in the op chemo provider pool `home'/data/extracts/step2/chem_op100_providers. But not all match into the POS files.  Here's the situation, and how I deal with it:
	* 		1. 94 of these provider IDs never show up in the pos 1998-2008 pool. 
	*		2. Only 3 of these have more than 11 "any chemo" claims N={332,612,4162}. These 3 provider IDs start with 80 (Maryland); 21 is the typical Maryland code.
	*		***Hypothesis: the codes 800001, 800022, and 800037 are equivalent to 210001, 210022, and 210037, respectively.
	*		
	*		3. I have tested this hypothesis by checking whether there is a lot of UPIN overlap between the 80 and 20 versions, and there is (but not between non-matching 80 and 21 codes).
	*		***Thus, I will proceed as though the hypothesized equivalence is correct.***
	* 		
	*		4. I ignore the other 91 non-matching claims, but this should be negligible:
	*			9 of 93 have between [3,11] "any chemo" claims, the rest have fewer.
	*			2 of 93 have 2 chem_select claims, 7 of 93 have 1 chem_select claim, and the rest have zero.
	
	* Load the pooled POS file (contains only select POS variables)
	use `home'/data/pos/pos_1998_2008, clear
	
	* Duplicate any entries for codes 210001, 210022, and 210037, and rename the duplicate entries 800001, 800022, and 800037, respectively	
	expand 2 if provider=="210001" | provider=="210022" | provider=="210037", generate(flag_expand)
	replace provider = "80" + substr(provider,3,4) if flag_expand
	drop flag_expand
	sort provider pos_year
	
	* Merge in pool of chemo providers, and limit to these folks (also keep non-matching provider IDs from the master pool file)
	merge m:1 provider using `home'/data/extracts/step1/aux/chem_op_providers, keep(using match) nogenerate
	
	* Replace year=2008 for providers that never matched in (WLOG; these providers will ultimately have entries for each year, but always missing info)
	replace pos_year = 2008 if missing(pos_year)
	
	* Expand so that each provider ID has an entry each year in [1998,2008].  
	saveold tmp, replace
	keep provider
	bys provider: keep if _n==1
	expand 11
	bys provider: gen pos_year = 1997+_n
	sort provider pos_year
	merge 1:1 provider pos_year using tmp, assert(match master) nogenerate noreport
	rm tmp.dta
	
	* Before filling in missing values (below), mark which observations will be imputed (includes all obs for the 93 providers who did not match into the POS files)
	gen imputed = missing(prov_category)
	
	* Copy non-missing values forward: see FAQ at http://www.stata.com/support/faqs/data/missing.html 
	sort provider pos_year
	local fillvars prov_crossref prov_category prov_name prov_zip prov_st prov_city prov_street prov_fipstate prov_fipcnty prov_msa
	foreach var of local fillvars {
		by provider: replace `var' = `var'[_n-1] if missing(`var')
	}
	
	* Copy non-missing values backward (for zips that start out with missing data)
	gsort provider -pos_year
	foreach var of local fillvars {
		by provider: replace `var' = `var'[_n-1] if missing(`var')
	}
	sort provider pos_year
	
	* Save "cleaned", "filled" pos file
	saveold `home'/data/extracts/step1/aux/chem_op_pos_filled, replace
}

* 2. Create a provider summary file, including year-specific HSA, HRR, and lat/lon for each providers's zip
if 1 {
	* Load the "cleaned", "filled" pos file
	use `home'/data/extracts/step1/aux/chem_op_pos_filled, clear
	
	* Load in Dartmouth Atlas geography variables
	destring prov_zip, gen(zipcode)
	gen zyear = pos_year
	sort zipcode zyear
	merge m:1 zipcode zyear using `home'/data/crosswalks/ziphsahrr_95_10_filled, keep(master match) nogenerate noreport keepusing(hsanum hsacity hsastate hrrnum hrrcity hrrstate)
	foreach var of varlist hsanum hsacity hsastate hrrnum hrrcity hrrstate {
		rename `var' p`var'
	}
	drop zyear

	* Merge in zipcode lat, lon, and state code
	merge m:1 zipcode using `home'/data/crosswalks/zip_lat_lon, keep(master match) nogenerate noreport keepusing(Lat Long State)
	rename Lat pzlat
	rename Long pzlon
	rename State pzstate
	drop zipcode

	* Sort and save
	sort provider pos_year
	saveold `home'/data/extracts/step1/aux/chem_op_providerinfo.dta, replace
}

* end: 1
}

* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
* 3. CARRIER: provzip->(HRR,HSA,lat,lon) crosswalk
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
if 1 {
* Create pool of provzips that ever show up on carrier chemo claims. For carrier files, provider coded at the line-items level.
clear
forvalues yr = 1998/2008 {
	append using `home'/data/extracts/step1/car/chem_car05_`yr'_linedz, keep(provzip)
	bys provzip: keep if _n==1
}
drop if missing(provzip)
destring provzip, gen(zipcode)
saveold `home'/data/extracts/step1/aux/chem_car_provzips, replace

* Take the Dartmouth Atlas (zip,year) file and limit to charrier chemo provzips and years in [1998,2008].  214 zips do not match into the Atlas file (which does not, e.g., contain zips outside U.S.).
use if 1998<=zyear & zyear<=2008 using `home'/data/crosswalks/ziphsahrr_95_10_filled.dta, clear
merge m:1 zipcode using `home'/data/extracts/step1/aux/chem_car_provzips, keep(match using) nogenerate noreport
foreach var of varlist hsanum hsacity hsastate hrrnum hrrcity hrrstate {
	rename `var' p`var'
}

* Replace year=2008 for provzips that never matched into the Dartmouth pooled file (WLOG; these provzips will ultimately have entries for each year, but always missing info)
replace zyear = 2008 if missing(zyear)

* Expand so that each provider ID has an entry each year in [1998,2008].  Here, this only expands the entries for the 214 zips that do not match into the Atlas crosswalk.
saveold tmp, replace
keep provzip
bys provzip: keep if _n==1
expand 11
bys provzip: gen zyear = 1997+_n
sort provzip zyear
merge 1:1 provzip zyear using tmp, assert(match master) nogenerate noreport
rm tmp.dta

* Confirm values only missing for the 214 zips that have all missing values
foreach var of varlist phsanum phsacity phsastate phrrnum phrrcity phrrstate {
	by provzip: egen flagx = max(missing(`var'))
	by provzip: assert !missing(`var') if !flagx
	drop flagx
}

* Merge in zipcode lat, lon, and state code.  193 out of 9715 zips (2%) do not match.
merge m:1 zipcode using `home'/data/crosswalks/zip_lat_lon, keep(master match) nogenerate noreport keepusing(Lat Long State)
rename Lat pzlat
rename Long pzlon
rename State pzstate
drop zipcode

* Sort and save
sort provzip zyear
saveold `home'/data/extracts/step1/aux/chem_car_provzipinfo.dta, replace

}

* end: step1_prov
}


* 	Step 1.Spel. Calculate cancer treatment spells for individual patients
*	Input: 
*		1. `home'/data/extracts/step1/car/chem_car05_year_clms.dta
*		2. `home'/data/extracts/step1/op/chem_op100_year_clms.dta
*		3. `home'/data/extracts/step1/aux/chem_ehicbenex_one.dta 			(ehic-to-bene_id crosswalk, limited to ehics ever showing up in op/car chemo extracts and matching to a bene_id)
*	Output:
* 		1. `home'/data/extracts/step1/aux/chem_beneid_spells.dta 			(chemo spells for bene_ids that ever show up in op/car chemo extracts)
* 		
* ----------------------------------------------------------------------------------------------------------------------------------------------------------
if step1_spel {

	* Load inpatient and outpatient claims for a given year, keeping only patient IDs and treatment dates.  
	* NOTE: at some point may want to think about patient-by-disease episodes
	local baselen 90
	if 1 {
	forvalues yr = 1998/2008 {
	use ehic bene_id claim*dt using `home'/data/extracts/step1/car/chem_car05_`yr'_clmsdz.dta, clear
	append using `home'/data/extracts/step1/op/chem_op100_`yr'_clmsdz.dta, keep(ehic bene_id claim*dt) gen(opclaim)
	format claim*dt %d
	
	* Merge in bene_id for years 2005 and earlier.  Note: a nearly zero-mass of ehics do not match to a bene_id.
	if `yr'<=2005 {
		drop bene_id
		merge m:1 ehic using `home'/data/extracts/step1/aux/chem_ehicbenex_one.dta, keep(match) nogenerate noreport
	}
	drop ehic
	
	* Sort by bene_id, generate the number of days since previous chemo claim
	* NOTE: NEED TO THINK ABOUT THE FEW CASES WHERE FROMDT!=THRUDT, COMPLICATES FOLLOWING CALCULATION
	sort bene_id claimfromdt claimthrudt
	by bene_id: gen gap_clms = claimfromdt-claimfromdt[_n-1]
	
	* Mark new "episodes" defined as gap of more than 90 days
	gen newepisode`baselen' = gap_clms>`baselen'
	by bene_id: gen episode`baselen' = sum(newepisode`baselen')
	bys bene_id episode`baselen': egen ep`baselen'fromdt = min(claimfromdt)
	bys bene_id episode`baselen': egen ep`baselen'thrudt = max(claimfromdt)
	
	* Mark whether an episode contains any outpatient/carrier claims
	bys bene_id episode`baselen': egen epop  = max(opclaim)
	bys bene_id episode`baselen': egen epcar = max(1-opclaim)
	
	* Keep only one observation per beneficiary-episode, and select variables
	bys bene_id episode`baselen': keep if _n==1
	keep bene_id ep`baselen'*dt epop epcar
	
	* Save the episodes from this calendar year in a temporary file
	format *dt %d
	save `home'/data/extracts/step1/tmp_spel`baselen'_`yr', replace
	}
	
	* Append all tmp spell files together, create master `baselen'-day spell file
	clear
	forvalues yr = 1998/2008 {
	append using `home'/data/extracts/step1/tmp_spel`baselen'_`yr'
	rm `home'/data/extracts/step1/tmp_spel`baselen'_`yr'.dta
	}
	
	* Convert annual spell data to aggregate spell data, allowing spells to cross calendar years
	sort bene_id ep`baselen'fromdt ep`baselen'thrudt
	by bene_id: gen gap_clms = ep`baselen'fromdt-ep`baselen'thrudt[_n-1]
	count if gap_clms<=0
	gen newepisode`baselen' = gap_clms>`baselen'
	by bene_id: gen episode`baselen' = sum(newepisode`baselen')
	rename ep`baselen'fromdt ep`baselen'fromdt_tmp
	rename ep`baselen'thrudt ep`baselen'thrudt_tmp
	bys bene_id episode`baselen': egen ep`baselen'fromdt = min(ep`baselen'fromdt_tmp)
	bys bene_id episode`baselen': egen ep`baselen'thrudt = max(ep`baselen'thrudt_tmp)
	format *dt %d
	rename epop epop_tmp
	rename epcar epcar_tmp
	bys bene_id episode`baselen': egen epop = max(epop_tmp)
	bys bene_id episode`baselen': egen epcar = max(epcar_tmp)
	drop if missing(bene_id)
	keep bene_id epop epcar ep`baselen'*dt
	bys bene_id ep`baselen'fromdt ep`baselen'thrudt: keep if _n==1
	save `home'/data/extracts/step1/aux/spells/chem_spell_`baselen'days, replace
	}
	
	* Turn 90-day spell data into 365-day spells (or alternative length)
	qui foreach altlen of numlist 120(30)330 365 390(30)720 {
		noisily di "Processing `altlen'-day spell data"
		use `home'/data/extracts/step1/aux/spells/chem_spell_`baselen'days, clear
		sort bene_id ep`baselen'fromdt ep`baselen'thrudt
		by bene_id: gen gap_clms = ep`baselen'fromdt-ep`baselen'thrudt[_n-1]
		count if gap_clms<=0
		gen newepisode`altlen' = gap_clms>`altlen'
		by bene_id: gen episode`altlen' = sum(newepisode`altlen')
		bys bene_id episode`altlen': egen ep`altlen'fromdt = min(ep`baselen'fromdt)
		bys bene_id episode`altlen': egen ep`altlen'thrudt = max(ep`baselen'thrudt)
		format *dt %d
		rename epop epop_tmp
		rename epcar epcar_tmp
		bys bene_id episode`altlen': egen epop = max(epop_tmp)
		bys bene_id episode`altlen': egen epcar = max(epcar_tmp)
		drop if missing(bene_id)
		keep bene_id epop epcar ep`altlen'*dt
		bys bene_id ep`altlen'fromdt ep`altlen'thrudt: keep if _n==1
		save `home'/data/extracts/step1/aux/spells/chem_spell_`altlen'days, replace
	}
}


* 	Step 1.Group. Calculate physician groups based on tax IDs in the carrier claims
*	Input: 
*		1. PATH_TO_MEDICARE_DATA/20pct/car/year/20%carrierfile.dta
*		2. `home'/data/physgroups/CancerDrugs_PhysicianIDs.xls
*	Output:
* 		1. `home'/data/physgroups/docid_taxid_car_year.dta 		(an observation for each UPIN-NPI-TaxID triple that show up in the 20% carrier claims that year)
* 		1a. `home'/data/physgroups/upin_taxid_car.dta 				(cleaned versions of #1, uniquely identified by UPIN and no yearly data or clms counts)
* 		1b. `home'/data/physgroups/npi_taxid_car.dta 				(cleaned versions of #1, uniquely identified by NPI and no yearly data or clms counts)
* 		2. `home'/data/physgroups/docid_drugassoc_individ.dta 		(an observation for each UPIN-NPI for authors for at least one drug in our sample, with a mutually exclusive indicator for first/last/other author relationship to each drug)
* 		3. `home'/data/physgroups/taxid_drugassoc.dta 				(an observation for each taxid associated with at least one author for at least one drug in our sample, with an indicator--not necessarily mutually exclusive--for first/last/other author relationship to each drug)
* 		4. `home'/data/physgroups/docid_drugassoc_group.dta 		(an observation for each physician ID with at least one taxid associated a drug in our sample, with an indicator--not necessarily mutually exclusive--for first/last/other author relationship to each drug)
* 		5. `home'/data/physgroups/bene_year_drugassoc_group.dta 	(an observation for each beneid-year treated by a physician associated with an author's physician group; based on prf_upin/npi for carrier claims, and at_upin/npi for outpatient claims)
* 		
* ----------------------------------------------------------------------------------------------------------------------------------------------------------
if step1_group {

* First, mark which physicians ever practice in the same group (i.e. under the same taxid) as trial study authors for any of the drugs in our study
if 1 {
	* Extract the Performing Physician UPIN (or NPI) and associated Tax ID from 20% carrier claim files for each year 1998-2008
	local h1998 = 12
	local i1998 = 71
	local h1999 = 12
	local i1999 = 70
	local i2000 = 97
	local i2001 = 99
	local i2002 = 21
	local i2003 = 16
	local i2004 = 24
	local i2005 = 24
	local i2006 = 99
	local i2007 = 99
	local i2008 = 99
	forvalues yr = 1998/2008 {
	if      1998<=`yr' & `yr'<=1999 {
		forvalues h = 1/`h`yr'' {
			di "iter `h'/`h`yr'', yr=`yr'"
			use blnppun bprovid using PATH_TO_MEDICARE_DATA/20pct/car/`yr'/car20h_`yr'_`h'.dta, clear
			rename blnppun prf_upin
			rename bprovid tax_num
			bys prf_upin tax_num: gen N = _N
			bys prf_upin tax_num: keep if _n==1
			tempfile car20h_`yr'_`h'
			saveold `car20h_`yr'_`h'', replace
		}
		forvalues i = 1/`i`yr'' {
			di "iter `i'/`i`yr'', yr=`yr'"
			use prf_upin tax_num using PATH_TO_MEDICARE_DATA/20pct/car/`yr'/car20i_`yr'_`i'.dta, clear
			bys prf_upin tax_num: gen N = _N
			bys prf_upin tax_num: keep if _n==1
			tempfile car20i_`yr'_`i'
			saveold `car20i_`yr'_`i'', replace
		}
		clear
		forvalues h = 1/`h`yr'' {
			append using `car20h_`yr'_`h''
		}
		forvalues i = 1/`i`yr'' {
			append using `car20i_`yr'_`i''
		}
		bys prf_upin tax_num: egen numclms = total(N)
		drop N
		bys prf_upin tax_num: keep if _n==1
		gen year = `yr'
		saveold `home'/data/physgroups/docid_taxid_car_`yr', replace
	}
	else if 2000<=`yr' & `yr'<=2001 {
	forvalues i = 1/`i`yr'' {
		di "iter `i'/`i`yr'', yr=`yr'"
		use prf_upin tax_num using PATH_TO_MEDICARE_DATA/20pct/car/`yr'/car20i_`yr'_`i'.dta, clear
		bys prf_upin tax_num: gen N = _N
		bys prf_upin tax_num: keep if _n==1
		tempfile car20i_`yr'_`i'
		saveold `car20i_`yr'_`i'', replace
	}
	clear
	forvalues i = 1/`i`yr'' {
		append using `car20i_`yr'_`i''
	}
	bys prf_upin tax_num: egen numclms = total(N)
	drop N
	bys prf_upin tax_num: keep if _n==1
	gen year = `yr'
	saveold `home'/data/physgroups/docid_taxid_car_`yr', replace
	}
	else if 2002<=`yr' & `yr'<=2005 {
	forvalues i = 1/`i`yr'' {
		di "iter `i'/`i`yr'', yr=`yr'"
		capture use PRF_UPIN TAX_NUM using PATH_TO_MEDICARE_DATA/20pct/car/`yr'/car20i_`yr'_lnits`i'.dta, clear
			if !_rc {
				rename PRF_UPIN prf_upin
				rename TAX_NUM tax_num
			}
			else use prf_upin tax_num using PATH_TO_MEDICARE_DATA/20pct/car/`yr'/car20i_`yr'_lnits`i'.dta, clear
		bys prf_upin tax_num: gen N = _N
		bys prf_upin tax_num: keep if _n==1
		tempfile car20i_`yr'_`i'
		saveold `car20i_`yr'_`i'', replace
	}
	clear
	forvalues i = 1/`i`yr'' {
		append using `car20i_`yr'_`i''
	}
	bys prf_upin tax_num: egen numclms = total(N)
	drop N
	bys prf_upin tax_num: keep if _n==1
	gen year = `yr'
	saveold `home'/data/physgroups/docid_taxid_car_`yr', replace
	}
	else if 2006<=`yr' & `yr'<=2008 {
	forvalues i = 1/`i`yr'' {
		di "iter `i'/`i`yr'', yr=`yr'"
		use prf_upin prf_npi tax_num using PATH_TO_MEDICARE_DATA/20pct/car/`yr'/car20_`yr'_lnits`i'.dta, clear
		bys prf_upin prf_npi tax_num: gen N = _N
		bys prf_upin prf_npi tax_num: keep if _n==1
		tempfile car20_`yr'_`i'
		saveold `car20_`yr'_`i'', replace
	}
	clear
	forvalues i = 1/`i`yr'' {
		append using `car20_`yr'_`i''
	}
	bys prf_upin prf_npi tax_num: egen numclms = total(N)
	drop N
	bys prf_upin prf_npi tax_num: keep if _n==1
	gen year = `yr'
	saveold `home'/data/physgroups/docid_taxid_car_`yr', replace
	}
	}

	* Pool into single file
	clear
	forvalues yr = 1998/2008 {
		append using `home'/data/physgroups/docid_taxid_car_`yr'
	}
	sort prf_upin prf_npi tax_num year

	* UPIN is a letter followed by 5 digits; NPI is 10 digits, and should start with the number 1-2
	replace prf_upin = lower(prf_upin)
	gen upin = regexs(0) if (regexm(prf_upin,"[a-zA-Z][0-9][0-9][0-9][0-9][0-9]"))
	gen npi  = regexs(0) if (regexm(prf_npi, "[1-2][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]"))

	* Further validate NPIs using the "checksum" method, https://www.cms.gov/Regulations-and-Guidance/HIPAA-Administrative-Simplification/NationalProvIdentStand/downloads/NPIcheckdigit.pdf
	gen x1 = substr(npi,1,1)
	gen x2 = substr(npi,2,1)
	gen x3 = substr(npi,3,1)
	gen x4 = substr(npi,4,1)
	gen x5 = substr(npi,5,1)
	gen x6 = substr(npi,6,1)
	gen x7 = substr(npi,7,1)
	gen x8 = substr(npi,8,1)
	gen x9 = substr(npi,9,1)
	gen x10 = substr(npi,10,1)
	destring x? x??, replace
	gen x = 24 + (floor(2*x1/10)+mod(2*x1,10)+floor(2*x3/10)+mod(2*x3,10)+floor(2*x5/10)+mod(2*x5,10)+floor(2*x7/10)+mod(2*x7,10)+floor(2*x9/10)+mod(2*x9,10)) + (x2 + x4 + x6 + x8)
	gen y = mod(floor(x/10)*10+10 - x,10)
	gen check = y==x10
	tab check if !missing(npi)
	replace npi = "" if !check
	drop x x? x?? y check
	drop prf_upin prf_npi
	rename upin prf_upin
	rename npi prf_npi

	* Keep only valid data, and save
	keep if !missing(prf_upin) | !missing(prf_npi)
	* 99.99% of tax_nums are either 9 or 10 digits, and NPIs are 10 characters
	drop if missing(tax_num) | !(9<=strlen(tax_num) & strlen(tax_num)<=10) 
	saveold `home'/data/physgroups/docid_taxid_car, replace

	* Save two alternate versions, each uniquely identified by either upin-taxid or npi-taxid, and no missing/invalid values of any of the IDs
	use `home'/data/physgroups/docid_taxid_car, clear
	keep prf_npi tax_num
	bys prf_npi tax_num: keep if _n==1
	drop if missing(prf_npi) | missing(tax_num)
	saveold `home'/data/physgroups/npi_taxid_car, replace

	use `home'/data/physgroups/docid_taxid_car, clear
	keep prf_upin tax_num
	bys prf_upin tax_num: keep if _n==1
	drop if missing(prf_upin) | missing(tax_num)
	saveold `home'/data/physgroups/upin_taxid_car, replace
	

	* Create Physician ID data for 18 drugs in our main sample, for docs with either a valid UPIN or NPI
	local PhysicianIDs PhysicianID
	import excel "`home'/data/physgroups/`PhysicianIDs'.xlsx", sheet("PhysicianID") firstrow clear
	tostring npi, replace
	assert strlen(npi)==10 | npi=="."
	assert strlen(upin)==6 | missing(upin)
	replace npi = "" if npi=="."
	replace upin=lower(upin)
	keep if !missing(upin) | !missing(npi)

	* Confirm only 1 upin/npi per doc
	bys upin: assert npi ==npi[1]  if !missing(upin)
	bys npi:  assert upin==upin[1] if !missing(npi)

	* Only 1 author "order" per drug, doctor
	bys upin npi drug: assert order==order[1] & md==md[1] & drugco==drugco[1]

	* Keep only one observation per drug, doctor
	bys upin npi drug: keep if _n==1

	* Some drugco guys have a upin or npi:
	tab drugco order

	* For each doctor (upin-npi combo), mark which drugs a first author on
	bys upin npi: egen byte f_capecitabine = max((drug=="capecitabine") & (order=="f") )
	bys upin npi: egen byte f_trastuzumab  = max((drug=="trastuzumab" ) & (order=="f") )
	bys upin npi: egen byte f_valrubicin   = max((drug=="valrubicin"  ) & (order=="f") )
	bys upin npi: egen byte f_denileukin   = max((drug=="denileukin"  ) & (order=="f") )
	bys upin npi: egen byte f_temozolomide = max((drug=="temozolomide") & (order=="f") )
	bys upin npi: egen byte f_bcg          = max((drug=="bcg"         ) & (order=="f") )
	bys upin npi: egen byte f_gemtuzumab   = max((drug=="gemtuzumab"  ) & (order=="f") )
	bys upin npi: egen byte f_arsenic      = max((drug=="arsenic"     ) & (order=="f") )
	bys upin npi: egen byte f_alemtuzumab  = max((drug=="alemtuzumab" ) & (order=="f") )
	bys upin npi: egen byte f_ibritumomab  = max((drug=="ibritumomab" ) & (order=="f") )
	bys upin npi: egen byte f_fulvestrant  = max((drug=="fulvestrant" ) & (order=="f") )
	bys upin npi: egen byte f_rasburicase  = max((drug=="rasburicase" ) & (order=="f") )
	bys upin npi: egen byte f_oxaliplatin  = max((drug=="oxaliplatin" ) & (order=="f") )
	bys upin npi: egen byte f_gefitinib    = max((drug=="gefitinib"   ) & (order=="f") )
	bys upin npi: egen byte f_bortezomib   = max((drug=="bortezomib"  ) & (order=="f") )
	bys upin npi: egen byte f_tositumomab  = max((drug=="tositumomab" ) & (order=="f") )
	bys upin npi: egen byte f_pemetrexed   = max((drug=="pemetrexed"  ) & (order=="f") )
	bys upin npi: egen byte f_bevacizumab  = max((drug=="bevacizumab" ) & (order=="f") )
	bys upin npi: egen byte f_clofarabine  = max((drug=="clofarabine" ) & (order=="f") )
	bys upin npi: egen byte f_nelarabine   = max((drug=="nelarabine"  ) & (order=="f") )
	bys upin npi: egen byte f_decitabine   = max((drug=="decitabine"  ) & (order=="f") )
	bys upin npi: egen byte f_temsirolimus = max((drug=="temsirolimus") & (order=="f") )

	* For each doctor (upin-npi combo), mark which drugs a last author on
	bys upin npi: egen byte l_capecitabine = max((drug=="capecitabine") & (order=="l") )
	bys upin npi: egen byte l_trastuzumab  = max((drug=="trastuzumab" ) & (order=="l") )
	bys upin npi: egen byte l_valrubicin   = max((drug=="valrubicin"  ) & (order=="l") )
	bys upin npi: egen byte l_denileukin   = max((drug=="denileukin"  ) & (order=="l") )
	bys upin npi: egen byte l_temozolomide = max((drug=="temozolomide") & (order=="l") )
	bys upin npi: egen byte l_bcg          = max((drug=="bcg"         ) & (order=="l") )
	bys upin npi: egen byte l_gemtuzumab   = max((drug=="gemtuzumab"  ) & (order=="l") )
	bys upin npi: egen byte l_arsenic      = max((drug=="arsenic"     ) & (order=="l") )
	bys upin npi: egen byte l_alemtuzumab  = max((drug=="alemtuzumab" ) & (order=="l") )
	bys upin npi: egen byte l_ibritumomab  = max((drug=="ibritumomab" ) & (order=="l") )
	bys upin npi: egen byte l_fulvestrant  = max((drug=="fulvestrant" ) & (order=="l") )
	bys upin npi: egen byte l_rasburicase  = max((drug=="rasburicase" ) & (order=="l") )
	bys upin npi: egen byte l_oxaliplatin  = max((drug=="oxaliplatin" ) & (order=="l") )
	bys upin npi: egen byte l_gefitinib    = max((drug=="gefitinib"   ) & (order=="l") )
	bys upin npi: egen byte l_bortezomib   = max((drug=="bortezomib"  ) & (order=="l") )
	bys upin npi: egen byte l_tositumomab  = max((drug=="tositumomab" ) & (order=="l") )
	bys upin npi: egen byte l_pemetrexed   = max((drug=="pemetrexed"  ) & (order=="l") )
	bys upin npi: egen byte l_bevacizumab  = max((drug=="bevacizumab" ) & (order=="l") )
	bys upin npi: egen byte l_clofarabine  = max((drug=="clofarabine" ) & (order=="l") )
	bys upin npi: egen byte l_nelarabine   = max((drug=="nelarabine"  ) & (order=="l") )
	bys upin npi: egen byte l_decitabine   = max((drug=="decitabine"  ) & (order=="l") )
	bys upin npi: egen byte l_temsirolimus = max((drug=="temsirolimus") & (order=="l") )

	* For each doctor (upin-npi combo), mark which drugs a middle author on
	bys upin npi: egen byte o_capecitabine = max((drug=="capecitabine") & (order=="o") )
	bys upin npi: egen byte o_trastuzumab  = max((drug=="trastuzumab" ) & (order=="o") )
	bys upin npi: egen byte o_valrubicin   = max((drug=="valrubicin"  ) & (order=="o") )
	bys upin npi: egen byte o_denileukin   = max((drug=="denileukin"  ) & (order=="o") )
	bys upin npi: egen byte o_temozolomide = max((drug=="temozolomide") & (order=="o") )
	bys upin npi: egen byte o_bcg          = max((drug=="bcg"         ) & (order=="o") )
	bys upin npi: egen byte o_gemtuzumab   = max((drug=="gemtuzumab"  ) & (order=="o") )
	bys upin npi: egen byte o_arsenic      = max((drug=="arsenic"     ) & (order=="o") )
	bys upin npi: egen byte o_alemtuzumab  = max((drug=="alemtuzumab" ) & (order=="o") )
	bys upin npi: egen byte o_ibritumomab  = max((drug=="ibritumomab" ) & (order=="o") )
	bys upin npi: egen byte o_fulvestrant  = max((drug=="fulvestrant" ) & (order=="o") )
	bys upin npi: egen byte o_rasburicase  = max((drug=="rasburicase" ) & (order=="o") )
	bys upin npi: egen byte o_oxaliplatin  = max((drug=="oxaliplatin" ) & (order=="o") )
	bys upin npi: egen byte o_gefitinib    = max((drug=="gefitinib"   ) & (order=="o") )
	bys upin npi: egen byte o_bortezomib   = max((drug=="bortezomib"  ) & (order=="o") )
	bys upin npi: egen byte o_tositumomab  = max((drug=="tositumomab" ) & (order=="o") )
	bys upin npi: egen byte o_pemetrexed   = max((drug=="pemetrexed"  ) & (order=="o") )
	bys upin npi: egen byte o_bevacizumab  = max((drug=="bevacizumab" ) & (order=="o") )
	bys upin npi: egen byte o_clofarabine  = max((drug=="clofarabine" ) & (order=="o") )
	bys upin npi: egen byte o_nelarabine   = max((drug=="nelarabine"  ) & (order=="o") )
	bys upin npi: egen byte o_decitabine   = max((drug=="decitabine"  ) & (order=="o") )
	bys upin npi: egen byte o_temsirolimus = max((drug=="temsirolimus") & (order=="o") )

	* Keep specific variables, and only one obs per doctor
	keep upin npi author ?_*
	bys upin npi: keep if _n==1

	* Confirm that each doctor-drug observation is associated with each drug in at most one author position
	foreach drug in capecitabine trastuzumab valrubicin  denileukin  temozolomide bcg gemtuzumab  arsenic alemtuzumab ibritumomab fulvestrant rasburicase oxaliplatin gefitinib bortezomib tositumomab pemetrexed bevacizumab clofarabine nelarabine decitabine temsirolimus {
		assert (f_`drug' + l_`drug' + o_`drug'==0) | (f_`drug' + l_`drug' + o_`drug'==1)
	}

	* Save this information, which associates each drug with all author doctors (for whom a upin or npi is ever reported in the carrier files) 
	saveold `home'/data/physgroups/docid_drugassoc_individ, replace


	* Merge in tax ID info
	use `home'/data/physgroups/docid_drugassoc_individ, clear
	keep if !missing(upin)
	bys upin: assert _n==1
	rename upin prf_upin
	merge 1:m prf_upin using `home'/data/physgroups/upin_taxid_car, keep(match master)
	* Check that all first and last authors show up with at least one taxid
	assert _merge==3 if (f_capecitabine==1 | f_trastuzumab ==1 | f_valrubicin  ==1 | f_denileukin  ==1 | f_temozolomide==1 | f_bcg==1 | f_gemtuzumab  ==1 | f_arsenic     ==1 | f_alemtuzumab ==1 | f_ibritumomab ==1 | f_fulvestrant ==1 | f_rasburicase ==1 | f_oxaliplatin ==1 | f_gefitinib   ==1 | f_bortezomib  ==1 | f_tositumomab ==1 | f_pemetrexed  ==1 | f_bevacizumab ==1 | f_clofarabine ==1 | f_nelarabine  ==1 | f_decitabine  ==1 | f_temsirolimus==1)
	* Note: the following test fails only for rasburicase, which is not even in our final sample of drugs
	* assert _merge==3 if (l_capecitabine==1 | l_trastuzumab ==1 | l_valrubicin  ==1 | l_denileukin  ==1 | l_temozolomide==1 | l_bcg==1 | l_gemtuzumab  ==1 | l_arsenic     ==1 | l_alemtuzumab ==1 | l_ibritumomab ==1 | l_fulvestrant ==1 | l_rasburicase ==1 | l_oxaliplatin ==1 | l_gefitinib   ==1 | l_bortezomib  ==1 | l_tositumomab ==1 | l_pemetrexed  ==1 | l_bevacizumab ==1 | l_clofarabine ==1 | l_nelarabine  ==1 | l_decitabine  ==1 | l_temsirolimus==1)
	drop _merge
	rename prf_upin upin
	saveold tmp_upin, replace

	use `home'/data/physgroups/docid_drugassoc_individ, clear
	keep if !missing(npi)
	bys npi: assert _n==1
	rename npi prf_npi
	merge 1:m prf_npi using `home'/data/physgroups/npi_taxid_car, keep(match master)
	* Check that all first and last authors show up with at least one taxid
	* assert _merge==3 if (f_capecitabine==1 | f_trastuzumab ==1 | f_valrubicin  ==1 | f_denileukin  ==1 | f_temozolomide==1 | f_bcg==1 | f_gemtuzumab  ==1 | f_arsenic     ==1 | f_alemtuzumab ==1 | f_ibritumomab ==1 | f_fulvestrant ==1 | f_rasburicase ==1 | f_oxaliplatin ==1 | f_gefitinib   ==1 | f_bortezomib  ==1 | f_tositumomab ==1 | f_pemetrexed  ==1 | f_bevacizumab ==1 | f_clofarabine ==1 | f_nelarabine  ==1 | f_decitabine  ==1 | f_temsirolimus==1)
	* Note: the following test fails only for rasburicase, which is not even in our final sample of drugs
	* assert _merge==3 if (l_capecitabine==1 | l_trastuzumab ==1 | l_valrubicin  ==1 | l_denileukin  ==1 | l_temozolomide==1 | l_bcg==1 | l_gemtuzumab  ==1 | l_arsenic     ==1 | l_alemtuzumab ==1 | l_ibritumomab ==1 | l_fulvestrant ==1 | l_rasburicase ==1 | l_oxaliplatin ==1 | l_gefitinib   ==1 | l_bortezomib  ==1 | l_tositumomab ==1 | l_pemetrexed  ==1 | l_bevacizumab ==1 | l_clofarabine ==1 | l_nelarabine  ==1 | l_decitabine  ==1 | l_temsirolimus==1)
	drop _merge
	rename prf_npi npi
	saveold tmp_npi, replace


	* Append both files
	clear
	append using tmp_upin
	append using tmp_npi
	rm tmp_upin.dta
	rm tmp_npi.dta

	* For each tax_num, mark whether it is ever associated with first, last, or other for a given drug
	sort tax_num
	foreach var of varlist f_* l_* o_* {
		rename `var' tmp_var
		by tax_num: egen `var' = max(tmp_var)
		drop tmp_var
	}

	* Keep only one observation per tax_num, and drop author-specific variables
	bys tax_num: keep if _n==1
	drop author upin npi
	compress
	saveold `home'/data/physgroups/taxid_drugassoc, replace


	* Now, take all docid-taxid info, and record association
	* UPIN
	use `home'/data/physgroups/upin_taxid_car, clear
	merge m:1 tax_num using `home'/data/physgroups/taxid_drugassoc, keep(match master) nogen noreport
	sort prf_upin
	foreach var of varlist f_* l_* o_* {
		rename `var' tmp_var
		by prf_upin: egen `var' = max(tmp_var)
		replace `var' = 0 if missing(`var')
		drop tmp_var
	}
	bys prf_upin: keep if _n==1
	drop tax_num
	compress
	saveold `home'/data/physgroups/upin_drugassoc_group, replace

	* NPI
	use `home'/data/physgroups/npi_taxid_car, clear
	merge m:1 tax_num using `home'/data/physgroups/taxid_drugassoc, keep(match master) nogen noreport
	sort prf_npi
	foreach var of varlist f_* l_* o_* {
		rename `var' tmp_var
		by prf_npi: egen `var' = max(tmp_var)
		replace `var' = 0 if missing(`var')
		drop tmp_var
	}
	bys prf_npi: keep if _n==1
	drop tax_num
	compress
	saveold `home'/data/physgroups/npi_drugassoc_group, replace
}

* Second, mark which patients were treated by any physician in one of these physician groups
if 1 {

* Specify which physician ID (NPI/UPIN) to use for association
qui foreach id in upin npi {
	* Use carrier+outpatient claims to mark which patients are treated by a pivotal physician group
	* keep only 1 observation per bene-upin/npi-year
	clear
	forvalues yr = 1998/2005 {
		append using `home'/data/extracts/step1/car/chem_car05_`yr'_std.dta, keep(ehic prf_`id' fyear)
		append using `home'/data/extracts/step1/op/chem_op100_`yr'_std.dta, keep(ehic at_`id' fyear)
		drop if missing(prf_`id') & missing(at_`id')
		replace prf_`id' = at_`id' if missing(prf_`id')
		bys ehic prf_`id' fyear: keep if _n==1
	}

	* Merge in bene_id; nearly all ehics match to a bene_id, but there are a handfull of exceptions which will get dropped
	merge m:1 ehic using `home'/data/extracts/step1/aux/chem_ehicbenex_one.dta, keep(match) nogen noreport
	drop ehic

	forvalues yr = 2006/2008 {
		append using `home'/data/extracts/step1/car/chem_car05_`yr'_std.dta, keep(bene_id prf_`id' fyear)
		append using `home'/data/extracts/step1/op/chem_op100_`yr'_std.dta, keep(bene_id at_`id' fyear)
		drop if missing(prf_`id') & missing(at_`id')
		replace prf_`id' = at_`id' if missing(prf_`id')
		bys bene_id prf_`id' fyear: keep if _n==1
	}


	* Merge in whether that physician UPIN was ever associated with a pivotal tax ID
	drop at_`id'
	replace prf_`id' = lower(prf_`id')
	merge m:1 prf_`id' using `home'/data/physgroups/`id'_drugassoc_group.dta, keep(match master) nogen noreport
	drop if missing(prf_`id')
	drop prf_`id'

	tab fyear

	* Replace author physician group variables to zero for UPINs that did not match (in spot checks, these are all invalid UPINs)
	foreach var of varlist f_* l_* o_* {
		replace `var' = 0 if missing(`var')
	}

	* Collapse down to bene_id level: record whether patient associated with any pivotal physician groups in a given year
	noisily di "Collapsing down to bene_id level, for `id' data"
	sort bene_id fyear
	foreach var of varlist f_* l_* o_* {
		rename `var' tmp_var
		by bene_id fyear: generat `var' = sum(tmp_var)
		by bene_id fyear: replace `var' = (`var'[_N]>=1)
		drop tmp_var
	}
	bys bene_id fyear: keep if _n==1

	* Save
	saveold `home'/data/physgroups/bene_year_drugassoc_group_`id', replace
}

* Combine the UPIN and NPI files to get a single file linking bene_ids to drug author physician groups
clear
append using `home'/data/physgroups/bene_year_drugassoc_group_upin
append using `home'/data/physgroups/bene_year_drugassoc_group_npi
sort bene_id fyear
foreach var of varlist f_* l_* o_* {
	rename `var' tmp_var
	by bene_id fyear: generat `var' = sum(tmp_var)
	by bene_id fyear: replace `var' = (`var'[_N]>=1)
	drop tmp_var
}
bys bene_id fyear: keep if _n==1
compress
saveold `home'/data/physgroups/bene_year_drugassoc_group, replace

}
}


*	Step 1.Cites. Calculate citation and publication ranks of authors
*	Input: 
*		1. `home'/data/physgroups/CancerDrugs_PhysicianIDs.xls
*	Output:
* 		1. `home'/data/citations/drug_hrr_cites.dta 		(an observation for each drug-HRR which has at least one pivotal author with at least one pub/cite)
* ----------------------------------------------------------------------------------------------------------------------------------------------------------
if step1_cites {
	* Import citation data
	local PhysicianIDs CancerDrugs_PhysicianIDs_141211
	import excel "`home'/data/physgroups/`PhysicianIDs'.xls", sheet("Physician IDs") firstrow clear
	tostring npi, replace
	assert strlen(npi)==10 | npi=="."
	assert strlen(upin)==6 | missing(upin)
	replace npi = "" if npi=="."
	replace upin=lower(upin)
	keep if !missing(upin) | !missing(npi)

	* Keep only select variables
	keep drug author order zip year onc_pubs onc_cites insample
	destring onc_pubs onc_cites, force replace

	* Keep only select observations
	* 	Keep only drugs in our final sample
	* 	Drop foreign authors (with missing zips)
	* 	Drop authors with no citations or publications
	keep if insample
	destring zip, force replace
	drop if missing(zip)
	assert missing(onc_pubs)==missing(onc_cites)
	drop if missing(onc_pubs) | missing(onc_cites)

	* Merge in HRR info for each zip
	rename zip zipcode
	rename year zyear
	merge m:1 zipcode zyear using `home'/data/crosswalks/ziphsahrr_95_10_filled.dta, assert(using match) keep(match) nogen noreport keepusing(hrrnum hrrcity hrrstate)
	count
	
	* Mark 5th, 10th, 25th, and 50th percentiles of citation and publication distribution
	assert onc_pubs>0 & onc_cites>0

	sum onc_pubs, d
	gen byte pubs_top5  = (onc_pubs>=`r(p95)' ) & !missing(onc_pubs)
	gen byte pubs_top10 = (onc_pubs>=`r(p90)') & !missing(onc_pubs)
	gen byte pubs_top25 = (onc_pubs>=`r(p75)') & !missing(onc_pubs)
	gen byte pubs_top50 = (onc_pubs>=`r(p50)') & !missing(onc_pubs)
	gen byte pubs_top75 = (onc_pubs>=`r(p25)') & !missing(onc_pubs)
	gen byte pubs_top90 = (onc_pubs>=`r(p10)') & !missing(onc_pubs)
	sum pubs_top*

	sum onc_cites, d
	gen byte cites_top5  = (onc_cites>=`r(p95)' ) & !missing(onc_cites)
	gen byte cites_top10 = (onc_cites>=`r(p90)') & !missing(onc_cites)
	gen byte cites_top25 = (onc_cites>=`r(p75)') & !missing(onc_cites)
	gen byte cites_top50 = (onc_cites>=`r(p50)') & !missing(onc_cites)
	gen byte cites_top75 = (onc_cites>=`r(p25)') & !missing(onc_cites)
	gen byte cites_top90 = (onc_cites>=`r(p10)') & !missing(onc_cites)
	sum cites_top*
	
	* Generate the percentile ranking of each author
	egen cites_pctl = rank(onc_cites), field
	replace cites_pctl = cites_pctl/_N
	egen pubs_pctl = rank(onc_pubs), field
	replace pubs_pctl =  pubs_pctl/_N
	
	* Compare, for each drug, first author pubs/cites relative to max of other author cites
	bys drug: egen maxcites = max(onc_cites)
	bys drug: egen maxpubs = max(onc_pubs)
	bys drug: egen fcites = max(onc_cites*(order=="f"))
	bys drug: egen fpubs = max(onc_pubs*(order=="f"))
	tabstat maxcites fcites maxpubs fpubs, by(drug)
	
	* Mark top authors from each drug
	bys drug: egen cites_rank = rank(onc_cites), field
	bys drug: egen pubs_rank = rank(onc_pubs), field
	label variable cites_rank "1 = top-cited author of each drug, etc."
	label variable pubs_rank "1 = top-published author of each drug, etc."
	
	* For each drug and HRR containing at least 1 author, generate "top citation/publication" status based on most prominent author in region
	foreach var of varlist pubs_top* cites_top* {
		rename `var' tmp
		bys drug hrrnum: egen `var' = max(tmp)
		drop tmp
	}
	foreach var of varlist cites_rank pubs_rank pubs_pctl cites_pctl {
		rename `var' tmp
		bys drug hrrnum: egen `var' = min(tmp)
		drop tmp
	}
	
	* Keep only 1 obs per drug-HRR, and keep only select variables
	bys drug hrrnum: keep if _n==1
	keep drug hrr* pubs_* cites_*

	* Save
	saveold `home'/data/citations/drug_hrr_cites.dta, replace
}

* end: Step 1
}


* ----------------------------------------------------------------------------------------------------------------------------------------------------------
* Step 2. Create Analysis Files
* ----------------------------------------------------------------------------------------------------------------------------------------------------------
if step2 {
* 	Step 2.Var. Collapse the outpatient claims to the patient-{zip,HSA,HRR} level
*	Output:
* 		1. `home'/data/extracts/step2/var/collapsed_zip_yr.dta
* 		2. `home'/data/extracts/step2/var/collapsed_hsa_yr.dta
* 		3. `home'/data/extracts/step2/var/collapsed_hrr_yr.dta
* ----------------------------------------------------------------------------------------------------------------------------------------------------------
if step2_var {
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
* 1. Chemo agents, FDA approval dates, and disease categories
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if 1 {
	local alldrugs capecitabine trastuzumab valrubicin denileukin temozolomide epirubicin bcg gemtuzumab triptorelin arsenic alemtuzumab zoledronic ibritumomab fulvestrant rasburicase oxaliplatin gefitinib bortezomib tositumomab pemetrexed cetuximab bevacizumab clofarabine nelarabine decitabine panitumumab temsirolimus
	local druglist capecitabine trastuzumab valrubicin denileukin temozolomide epirubicin bcg gemtuzumab triptorelin arsenic alemtuzumab zoledronic ibritumomab fulvestrant             oxaliplatin gefitinib bortezomib tositumomab pemetrexed cetuximab bevacizumab clofarabine nelarabine decitabine panitumumab temsirolimus
	local maindruglist          trastuzumab                                                                                  alemtuzumab zoledronic ibritumomab fulvestrant             oxaliplatin           bortezomib             pemetrexed cetuximab bevacizumab                        decitabine panitumumab
	
	local stmo_capecitabine 4/30/1998
	local stmo_trastuzumab  9/25/1998
	local stmo_valrubicin   9/25/1998
	local stmo_denileukin   2/5/1999
	local stmo_temozolomide 8/11/1999
	local stmo_epirubicin   9/15/1999
	local stmo_bcg          8/28/1998
	local stmo_gemtuzumab   5/17/2000
	local stmo_triptorelin  6/15/2000
	local stmo_arsenic      9/25/2000
	local stmo_alemtuzumab  5/7/2001
	local stmo_zoledronic   8/20/2001
	local stmo_ibritumomab  2/19/2002
	local stmo_fulvestrant  4/25/2002
	local stmo_rasburicase  7/12/2002
	local stmo_oxaliplatin  8/9/2002
	local stmo_gefitinib    5/5/2003
	local stmo_bortezomib   5/13/2003
	local stmo_tositumomab  6/27/2003
	local stmo_pemetrexed   2/4/2004
	local stmo_cetuximab    2/12/2004
	local stmo_bevacizumab  2/26/2004
	local stmo_clofarabine  12/28/2004
	local stmo_nelarabine   10/28/2005
	local stmo_decitabine   5/2/2006
	local stmo_panitumumab  9/27/2006
	local stmo_temsirolimus 5/30/2007
	
	local dz_capecitabine 1
	local dz_trastuzumab  1
	local dz_valrubicin   3
	local dz_denileukin   2
	local dz_temozolomide 4
	local dz_epirubicin   1
	local dz_bcg          3
	local dz_gemtuzumab   5
	local dz_triptorelin  6
	local dz_arsenic      7
	local dz_alemtuzumab  8
	local dz_zoledronic   9
	local dz_ibritumomab  10
	local dz_fulvestrant  1
	local dz_rasburicase  
	local dz_oxaliplatin  11
	local dz_gefitinib    12
	local dz_bortezomib   13
	local dz_tositumomab  10
	local dz_pemetrexed   12
	local dz_cetuximab    11
	local dz_bevacizumab  11
	local dz_clofarabine  14
	local dz_nelarabine   15
	local dz_decitabine   16
	local dz_panitumumab  11
	local dz_temsirolimus 17
}

* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
* 2. For each year:
* 	a. Load the A) the clms-level outpatient claims, and B) the linits-level carrier claims
* 	b. For each claim type (outpatient, then carrier), collapse to the patient-HRR level
* 	c. Append the collapsed outpatient and carrier claims, and collapse again to the patient-HRR level
* 3. Append each year of collapsed claims into single pool
*	Output: `home'/data/extracts/step2/var/collapsed_zip_yr.dta
*	             `home'/data/extracts/step2/var/collapsed_hsa_yr.dta
*	             `home'/data/extracts/step2/var/collapsed_hrr_yr.dta
* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if 1 {
* Collapse the outpatient claims to the patient-{zip,HSA,HRR} level
qui forvalues yr=1998/2008 {
	noisily di "Processing tmp_op_`yr'.dta ..."
	
	* Load the clms-level outpatient claims
	use ehic bene_id at_upin at_npi provider claimfromdt ftype fyear chem_* dgns_dz* using `home'/data/extracts/step1/op/chem_op100_`yr'_clmsdz.dta, clear
	rename at_upin upin
	rename at_npi npi
	cap destring(npi), replace force
	
	* Merge in provider location info (e.g. HRR)
	gen pos_year = fyear
	sort provider pos_year
	merge m:1 provider pos_year using `home'/data/extracts/step1/aux/chem_op_providerinfo.dta, assert (match using) keep(match) nogenerate noreport keepusing(phrr* phsa* prov_zip pzl??)
	drop pos_year
	rename prov_zip provzip
	
	* Flag whether the drug-specific first author treated the patient, then whether any first author treated the patient
	*	NOTE: UPINs/NPIs are only identified when line items indicate chemo.  So a given doc may treat a patient on a claim where the clms-level diagnosis indicates some kind of chemo, but that doc's UPIN 
	*			may not show up in the chemo extract as currently defined.  Alternatively, could go back and pull all carrier claims for any chemo patients, and see which docs ever treat the patient for anything.
	preserve
	use generic upinf npif upinfb npifb using `home'/data/temp/firstauthorid.dta, clear
	expand 2 if generic=="bortezomib"
	bys generic: replace upinf = upinfb if _n==2
	bys generic: replace npif  = npifb  if _n==2
	assert missing(upinf) == missing(npif)
	drop if missing(upinf)
	rename npif npif_hold
	gen double npif = npif_hold
	drop *fb npif_hold
	saveold drugcw, replace
	restore
	gen      upinf = upin
	gen double npif = npi
	merge m:1 upinf using drugcw, keep(master match) keepusing(generic) noreport gen(docf_upin)
	replace docf_upin = (docf_upin==3)
	merge m:1 npif using drugcw, assert(master using match match_update) keep(master match match_update) keepusing(generic) update noreport gen(docf_npi)
	replace docf_npi = (docf_npi>=3)
	* Drug-specific first-author UPIN/NPI
	foreach drug in `alldrugs' {
		gen byte docf_`drug' = (docf_upin | docf_npi) & (generic=="`drug'")
	}
	* Any first-author UPIN/NPI
	gen byte docf_any = (docf_upin | docf_npi)
	drop upinf npif docf_npi docf_upin
	rm drugcw.dta
	
	* Create beneficiary id, using either ehic or bene_id
	gen id = ehic
	replace id = bene_id if missing(id)
	
	* Collapse to beneficiary-provzip-time(calendaryear) level
	sort id provzip fyear claimfromdt
	foreach var of varlist phrr* phsa* pzl?? {
		by id provzip: assert `var'[1]==`var'
	}
	collapse (max) chem_* dgns_dz* docf_* claimfromdt_max=claimfromdt (firstnm) ehic bene_id ftype phrr* phsa* pzl??        (min) claimfromdt_min=claimfromdt, by(id provzip fyear)
	saveold `home'/data/extracts/step2/var/op/tmp_op_zip_`yr', replace
	
	* Collapse to beneficiary-HSA-time(calendaryear) level
	sort id phsanum fyear claimfromdt_min
	foreach var of varlist phrr* phsa* {
		by id phsanum: assert `var'[1]==`var'
	}
	collapse (max) chem_* dgns_dz* docf_* claimfromdt_max             (firstnm) ehic bene_id ftype phrr* phsacity phsastate (min) claimfromdt_min, by(id phsanum fyear)
	saveold `home'/data/extracts/step2/var/op/tmp_op_hsa_`yr', replace
	
	* Collapse to beneficiary-HRR-time(calendaryear) level
	sort id phrrnum fyear claimfromdt_min
	collapse (max) chem_* dgns_dz* docf_* claimfromdt_max             (firstnm) ehic bene_id ftype phrrcity phrrstate       (min) claimfromdt_min, by(id phrrnum fyear)
	saveold `home'/data/extracts/step2/var/op/tmp_op_hrr_`yr', replace
}

* Collapse the carrier claims to the patient-{zip,HSA,HRR} level
qui forvalues yr=1998/2008 {
	noisily di "Processing tmp_car_`yr'.dta ..."
	
	use ehic bene_id prf_upin prf_npi provzip claimfromdt ftype fyear chem_* dgns_dz* using `home'/data/extracts/step1/car/chem_car05_`yr'_linedz.dta, clear
	rename prf_upin upin
	rename prf_npi npi
	cap destring(npi), replace force
	
	* Merge in provider location info (e.g. HRR)
	gen zyear = fyear
	sort provzip zyear
	drop if missing(provzip)
	merge m:1 provzip zyear using `home'/data/extracts/step1/aux/chem_car_provzipinfo.dta, assert (match using) keep(match) nogenerate noreport keepusing(phrr* phsa* pzl??)
	drop zyear
	
	* Flag whether the drug-specific first author treated the patient, then whether any first author treated the patient
	*	NOTE: UPINs/NPIs are only identified when line items indicate chemo.  So a given doc may treat a patient on a claim where the clms-level diagnosis indicates some kind of chemo, but that doc's UPIN 
	*			may not show up in the chemo extract as currently defined.  Alternatively, could go back and pull all carrier claims for any chemo patients, and see which docs ever treat the patient for anything.
	preserve
	use generic upinf npif upinfb npifb using `home'/data/temp/firstauthorid.dta, clear
	expand 2 if generic=="bortezomib"
	bys generic: replace upinf = upinfb if _n==2
	bys generic: replace npif  = npifb  if _n==2
	assert missing(upinf) == missing(npif)
	drop if missing(upinf)
	rename npif npif_hold
	gen double npif = npif_hold
	drop *fb npif_hold
	saveold drugcw, replace
	restore
	gen      upinf = upin
	gen double npif = npi
	merge m:1 upinf using drugcw, keep(master match) keepusing(generic) noreport gen(docf_upin)
	replace docf_upin = (docf_upin==3)
	merge m:1 npif using drugcw, assert(master using match match_update) keep(master match match_update) keepusing(generic) update noreport gen(docf_npi)
	replace docf_npi = (docf_npi>=3)
	* Drug-specific first-author UPIN/NPI
	foreach drug in `alldrugs' {
		gen byte docf_`drug' = (docf_upin | docf_npi) & (generic=="`drug'")
	}
	* Any first-author UPIN/NPI
	gen byte docf_any = (docf_upin | docf_npi)
	drop upinf npif docf_npi docf_upin
	rm drugcw.dta
	
	* Create beneficiary id, using either ehic or bene_id
	gen id = ehic
	replace id = bene_id if missing(id)
	
	* Collapse to beneficiary-provzip-time(calendaryear) level
	sort id provzip fyear claimfromdt
	foreach var of varlist phrr* phsa* pzl?? {
		by id provzip: assert `var'[1]==`var'
	}
	collapse (max) chem_* dgns_dz* docf_* claimfromdt_max=claimfromdt (firstnm) ehic bene_id ftype phrr* phsa* pzl??        (min) claimfromdt_min=claimfromdt, by(id provzip fyear)
	saveold `home'/data/extracts/step2/var/car/tmp_car_zip_`yr', replace
	
	* Collapse to beneficiary-HSA-time(calendaryear) level
	sort id phsanum fyear claimfromdt_min
	foreach var of varlist phrr* phsa* {
		by id phsanum: assert `var'[1]==`var'
	}
	collapse (max) chem_* dgns_dz* docf_* claimfromdt_max             (firstnm) ehic bene_id ftype phrr* phsacity phsastate (min) claimfromdt_min, by(id phsanum fyear)
	saveold `home'/data/extracts/step2/var/car/tmp_car_hsa_`yr', replace
	
	* Collapse to beneficiary-HRR-time(calendaryear) level
	sort id phrrnum fyear claimfromdt_min
	collapse (max) chem_* dgns_dz* docf_* claimfromdt_max             (firstnm) ehic bene_id ftype phrrcity phrrstate       (min) claimfromdt_min, by(id phrrnum fyear)
	saveold `home'/data/extracts/step2/var/car/tmp_car_hrr_`yr', replace
}

* Append collapsed op+car claims for each year
qui forvalues yr=1998/2008 {
	noisily di "Processing tmp_xxx_`yr'.dta ..."
	
	* beneficiary-provzip-time(calendaryear) level: 
	*	1. Load collapsed outpatient claims
	*	2. Append collapsed carrier claims
	*	3. Collapse to beneficiary-provzip-time(calendaryear), then save
	use `home'/data/extracts/step2/var/op/tmp_op_zip_`yr', clear
	append using `home'/data/extracts/step2/var/car/tmp_car_zip_`yr'
	gen in_car = ftype=="car05"
	gen in_op  = ftype=="op100"
	collapse (max) chem_* dgns_dz* docf_* claimfromdt_max in_car in_op (firstnm) ehic bene_id phrr* phsa* pzl??        (min) claimfromdt_min, by(id provzip fyear)
	saveold `home'/data/extracts/step2/var/combined/tmp_zip_`yr', replace
	
	* beneficiary-HSA-time(calendaryear) level: 
	*	1. Load collapsed outpatient claims
	*	2. Append collapsed carrier claims
	*	3. Collapse to beneficiary-HSA-time(calendaryear), then save
	use `home'/data/extracts/step2/var/op/tmp_op_hsa_`yr', clear
	append using `home'/data/extracts/step2/var/car/tmp_car_hsa_`yr'
	gen in_car = ftype=="car05"
	gen in_op  = ftype=="op100"
	collapse (max) chem_* dgns_dz* docf_* claimfromdt_max in_car in_op (firstnm) ehic bene_id phrr* phsacity phsastate (min) claimfromdt_min, by(id phsanum fyear)
	saveold `home'/data/extracts/step2/var/combined/tmp_hsa_`yr', replace
	
	* beneficiary-HRR-time(calendaryear) level: 
	*	1. Load collapsed outpatient claims
	*	2. Append collapsed carrier claims
	*	3. Collapse to beneficiary-HRR-time(calendaryear), then save
	use `home'/data/extracts/step2/var/op/tmp_op_hrr_`yr', clear
	append using `home'/data/extracts/step2/var/car/tmp_car_hrr_`yr'
	gen in_car = ftype=="car05"
	gen in_op  = ftype=="op100"
	collapse (max) chem_* dgns_dz* docf_* claimfromdt_max in_car in_op (firstnm) ehic bene_id phrrcity phrrstate       (min) claimfromdt_min, by(id phrrnum fyear)
	saveold `home'/data/extracts/step2/var/combined/tmp_hrr_`yr', replace
}

* Append collapsed op+car annual file pieces together, for each {zip,HSA,HRR} location class
qui foreach loctyp in zip hsa hrr {
	noisily di "Creating `loctyp'-level claim pool"
	
	clear
	forvalues yr=1998/2008 {
		* beneficiary-provzip-time(calendaryear) level: 
		append using `home'/data/extracts/step2/var/combined/tmp_`loctyp'_`yr'
	}
	
	* Replace missing chemo flags with zeros
	foreach drug of local druglist {
		replace chem_`drug'=0 if missing(chem_`drug')
	}
	
	* Sort and save
	if "`loctyp'"=="zip" sort id provzip fyear
	if "`loctyp'"=="hsa" sort id phsanum fyear
	if "`loctyp'"=="hrr" sort id phrrnum fyear
	saveold `home'/data/extracts/step2/var/collapsed_`loctyp'_yr, replace
}

}

* end: step2_var
}


* 	Step 2.Prox. Regression data for Proximity Analysis
*	Output:
*		1. `home'/regdata_hrr_new.dta
* ----------------------------------------------------------------------------------------------------------------------------------------------------------
if step2_prox {
* Define local variables: Drug names, FDA approval dates, and disease categories
* All drugs, and then drugs with at least 10, 100, and 1000 patient-HRR-year episodes within eventyrs 1-2 (bcg dropped because not a new agent)
local alldrugs     capecitabine trastuzumab valrubicin denileukin temozolomide epirubicin bcg gemtuzumab triptorelin arsenic alemtuzumab zoledronic ibritumomab fulvestrant rasburicase oxaliplatin gefitinib bortezomib tositumomab pemetrexed cetuximab bevacizumab clofarabine nelarabine decitabine panitumumab temsirolimus
local druglist10   capecitabine trastuzumab valrubicin denileukin temozolomide epirubicin     gemtuzumab             arsenic alemtuzumab zoledronic ibritumomab fulvestrant             oxaliplatin           bortezomib tositumomab pemetrexed cetuximab bevacizumab                        decitabine panitumumab temsirolimus
local druglist100  capecitabine trastuzumab                                    epirubicin     gemtuzumab                     alemtuzumab zoledronic ibritumomab fulvestrant             oxaliplatin           bortezomib tositumomab pemetrexed cetuximab bevacizumab                        decitabine panitumumab temsirolimus
local druglist1000              trastuzumab                                                                                              zoledronic             fulvestrant             oxaliplatin           bortezomib             pemetrexed cetuximab bevacizumab                        decitabine panitumumab             

local stmo_capecitabine 4/30/1998
local stmo_trastuzumab  9/25/1998
local stmo_valrubicin   9/25/1998
local stmo_denileukin   2/5/1999
local stmo_temozolomide 8/11/1999
local stmo_epirubicin   9/15/1999
local stmo_bcg          8/28/1998
local stmo_gemtuzumab   5/17/2000
local stmo_triptorelin  6/15/2000
local stmo_arsenic      9/25/2000
local stmo_alemtuzumab  5/7/2001
local stmo_zoledronic   8/20/2001
local stmo_ibritumomab  2/19/2002
local stmo_fulvestrant  4/25/2002
local stmo_rasburicase  7/12/2002
local stmo_oxaliplatin  8/9/2002
local stmo_gefitinib    5/5/2003
local stmo_bortezomib   5/13/2003
local stmo_tositumomab  6/27/2003
local stmo_pemetrexed   2/4/2004
local stmo_cetuximab    2/12/2004
local stmo_bevacizumab  2/26/2004
local stmo_clofarabine  12/28/2004
local stmo_nelarabine   10/28/2005
local stmo_decitabine   5/2/2006
local stmo_panitumumab  9/27/2006
local stmo_temsirolimus 5/30/2007

local dz_capecitabine 1
local dz_trastuzumab  1
local dz_valrubicin   3
local dz_denileukin   2
local dz_temozolomide 4
local dz_epirubicin   1
local dz_bcg          3
local dz_gemtuzumab   5
local dz_triptorelin  6
local dz_arsenic      7
local dz_alemtuzumab  8
local dz_zoledronic   9
local dz_ibritumomab  10
local dz_fulvestrant  1
local dz_rasburicase  
local dz_oxaliplatin  11
local dz_gefitinib    12
local dz_bortezomib   13
local dz_tositumomab  10
local dz_pemetrexed   12
local dz_cetuximab    11
local dz_bevacizumab  11
local dz_clofarabine  14
local dz_nelarabine   15
local dz_decitabine   16
local dz_panitumumab  11
local dz_temsirolimus 17

* Create zip, hsa, and hrr (stacked) analysis files
if 1 {
	* 1. Create a stacked set of bene-year-location-drug observations
	* 2. Merge in beneficiary location info
	foreach loctyp in zip hsa hrr {
		foreach drug of local druglist {
			* Determine the start and end years used in the FE regressions
			local fdayr = year(date("`stmo_`drug''","MDY"))
			local fdayrm4 = max(`fdayr'-4,1998)
			local fdayrp5 = min(`fdayr'+5,2008)
			
			* Load data.  MUCH faster to limit to primary drug disease category.  Also, only keep obs with non-missing provider HRR.
			use if `fdayrm4'<=fyear & fyear<=`fdayrp5' & !missing(phrrnum) using `home'/data/extracts/step2/var/collapsed_`loctyp'_yr, clear
			
			* Bene Location: merge in bene_id, then merge in bene zip, HSA, HRR info
			merge m:1 ehic using `home'/data/extracts/step1/aux/chem_ehicbenex_one.dta, keep(master match match_update) update nogenerate noreport
			keep if !missing(bene_id)
			gen dyear = fyear
			sort bene_id dyear
			*	Note: a very few bene_ids are dropped because of no match.  Since all chemo bene_ids are in this pool, it must be from a failure to match on year.  Note that chem_beneinfo.dta could be filled forward/backward to resolve.
			merge m:1 bene_id dyear using `home'/data/extracts/step1/aux/chem_beneinfo.dta, keep(match) keepusing(bzip bzlat bzlon bhsanum bhrrnum) nogenerate noreport
			drop dyear
			label variable bzip "bene_id's 5-digit mailing zip in fyear"
			label variable bzlat "Lat of bene_id's zip"
			label variable bzlon "Lon of bene_id's zip"
			label variable bhsanum "HSA of bene_id's zip"
			label variable bhrrnum "HRR of bene_id's zip"
			
			* What is the provider geographic unit variable?
			if "`loctyp'"=="hrr" local provunit phrrnum
			if "`loctyp'"=="hsa" local provunit phsanum
			if "`loctyp'"=="zip" local provunit provzip
			
			* What is the beneficiary geographic unit variable?
			if "`loctyp'"=="hrr" local bunit bhrrnum
			if "`loctyp'"=="hsa" local bunit bhsanum
			if "`loctyp'"=="zip" local bunit bzip
			
			* Generate important variables for analysis
			gen eventyr = fyear-`fdayr'
			bys `provunit' eventyr: gen N_p`loctyp'_eventyr = _N
			bys `bunit'    eventyr: gen N_b`loctyp'_eventyr = _N
			gen dgns_dz_def = (dgns_dz`dz_`drug''_def==1)
			gen dgns_dz_may = (dgns_dz`dz_`drug''_may==1)
			gen chem_drug = chem_`drug'
			gen drug = "`drug'"
			
			* Save extract, limited to the primary disease category (either definitely or maybe)
			* comment out the following line to create stacked files containing all episodes for each drug
			keep if dgns_dz_def | dgns_dz_may
			saveold `home'/data/extracts/step2/`drug', replace
		}
		clear
		foreach drug of local druglist {
			append using `home'/data/extracts/step2/`drug'
			rm `home'/data/extracts/step2/`drug'.dta
		}
		saveold `home'/data/extracts/step2/tmp_`loctyp', replace
	}

	* Create a modified clinical trial crosswalk with author location information
	*	`home'/data/extracts/step2/tmp_drugzipxw_aug.dta
	if 1 {
		* use `home'/data/crosswalks/ziphrrlatlong.dta, clear
		use `home'/data/crosswalks/drugzipxw.dta, clear
		replace generic = lower(generic)
		
		* In which year was each drugs corresponding clinical trial run?
		gen zyear = .
		foreach drug in `alldrugs' {
			replace zyear = year(date("`stmo_`drug''","MDY")) if generic=="`drug'"
		}	
		
		* Merge in HSA info
		foreach author in f fb l 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 {
		di "author: `author'"
			gen zipcode = zip`author'
			merge m:1 zipcode zyear using `home'/data/crosswalks/ziphsahrr_95_10_filled.dta, keep(master match) keepusing(hsanum hrrnum) nogenerate noreport
			rename hsanum hsanum`author'
			assert hrrnum==hrrnum`author'
			drop zipcode hrrnum
		}
		drop zyear
		
		* Save temporarily
		saveold `home'/data/extracts/step2/tmp_drugzipxw_aug, replace
	}

	* 1. Merge in location of clinical trial authors
	*	zip-level: trial HRR, HSA, and zipcode all merged in
	*	hsa-level: trial HRR and HSA merged in
	*	hrr-level: trial HRR merged in
	* 2. Merge in provider HRR location info
	foreach loctyp in zip hsa hrr {
		* Load the input claims, then delete that file
		use `home'/data/extracts/step2/tmp_`loctyp', clear
		rm  `home'/data/extracts/step2/tmp_`loctyp'.dta

		* Summary stats of drug-relevant claims/usage by eventyr
		tab drug eventyr
		tab drug eventyr if chem_drug
		
		* Generate generic name for merges
		gen generic = drug
		
		* Flag drug-HRRs corresponding to first, last, and other authors
		sort generic phrrnum
		foreach author in f l 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 {
			gen hrrnum`author' = phrrnum
			merge m:1 generic hrrnum`author' using `home'/data/extracts/step2/tmp_drugzipxw_aug, keep(master match) keepusing(generic hrrnum`author') gen(prox`author')
			replace prox`author' = (prox`author'==3)
			drop hrrnum`author'
		}
		rename proxf proxf_hrr
		rename proxl proxl_hrr
		genera proxo_hrr = prox2 | prox3 | prox4 | prox5 | prox6 | prox7 | prox8 | prox9 | prox10 | prox11 | prox12 | prox13 | prox14 | prox15 | prox16 | prox17 | prox18 | prox19 | prox20 | prox21 | prox22
		drop prox2 prox3 prox4 prox5 prox6 prox7 prox8 prox9 prox10 prox11 prox12 prox13 prox14 prox15 prox16 prox17 prox18 prox19 prox20 prox21 prox22
		label variable proxf_hrr "Indicates whether phrrnum is the first author HRR"
		label variable proxl_hrr "Indicates whether phrrnum is the last author HRR"
		label variable proxo_hrr "Indicates whether phrrnum is any other author HRR"
		label values proxf_hrr
		label values proxl_hrr
		
		* Merge in lat/lon of first author hrr
		merge m:1 generic using `home'/data/extracts/step2/tmp_drugzipxw_aug, keep(master match) keepusing(generic Latf Longf) nogenerate noreport
		rename Latf  latf_hrr
		rename Longf lonf_hrr
		label variable latf_hrr "Lat of first author hrr (mean over all zips in HRR)"
		label variable lonf_hrr "Lon of first author hrr (mean over all zips in HRR)"
		
		* Merge in lat/lon of first author zip
		merge m:1 generic using `home'/data/extracts/step2/tmp_drugzipxw_aug, keep(master match) keepusing(generic zipf) nogenerate noreport
		rename zipf zipcode
		merge m:1 zipcode using `home'/data/crosswalks/zip_lat_lon.dta, keep(master match) keepusing(Lat Long) noreport
		assert _merge==3 | missing(zipcode)
		drop _merge zipcode
		rename Lat  latf_zip
		rename Long lonf_zip
		label variable latf_zip "Lat of first author zip"
		label variable lonf_zip "Lon of first author zip"
		
		* Flag drug-HSAs corresponding to first, last and other authors
		*	For HSA and zip level collapsed claims only
		if "`loctyp'"=="hsa" | "`loctyp'"=="zip" {
		sort generic phsanum
		foreach author in f l 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 {

			gen hsanum`author' = phsanum
			merge m:1 generic hsanum`author' using `home'/data/extracts/step2/tmp_drugzipxw_aug, keep(master match) keepusing(generic hsanum`author') gen(prox`author')
			replace prox`author' = (prox`author'==3)
			drop hsanum`author'
		}
		rename proxf proxf_hsa
		rename proxl proxl_hsa
		genera proxo_hsa = prox2 | prox3 | prox4 | prox5 | prox6 | prox7 | prox8 | prox9 | prox10 | prox11 | prox12 | prox13 | prox14 | prox15 | prox16 | prox17 | prox18 | prox19 | prox20 | prox21 | prox22
		drop prox2 prox3 prox4 prox5 prox6 prox7 prox8 prox9 prox10 prox11 prox12 prox13 prox14 prox15 prox16 prox17 prox18 prox19 prox20 prox21 prox22
		assert proxf_hrr if proxf_hsa
		assert proxl_hrr if proxl_hsa
		assert proxo_hrr if proxo_hsa
		label variable proxf_hsa "Indicates whether phsanum is the first author HSA"
		label variable proxl_hsa "Indicates whether phsanum is the last author HSA"
		label variable proxo_hsa "Indicates whether phsanum is any other author HSA"
		label values proxf_hsa
		label values proxl_hsa
		}
		
		* Flag drug-ZIPs corresponding to first, last and other authors
		*	For zip level collapsed claims only
		if "`loctyp'"=="zip" {
		sort generic provzip
		foreach author in f l 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 {
			destring provzip, gen(zip`author')
			merge m:1 generic zip`author' using `home'/data/extracts/step2/tmp_drugzipxw_aug, keep(master match) keepusing(generic zip`author') gen(prox`author')
			replace prox`author' = (prox`author'==3)
			drop zip`author'
		}
		rename proxf proxf_zip
		rename proxl proxl_zip
		genera proxo_zip = prox2 | prox3 | prox4 | prox5 | prox6 | prox7 | prox8 | prox9 | prox10 | prox11 | prox12 | prox13 | prox14 | prox15 | prox16 | prox17 | prox18 | prox19 | prox20 | prox21 | prox22
		drop prox2 prox3 prox4 prox5 prox6 prox7 prox8 prox9 prox10 prox11 prox12 prox13 prox14 prox15 prox16 prox17 prox18 prox19 prox20 prox21 prox22
		assert proxf_hsa if proxf_zip
		assert proxl_hsa if proxl_zip
		assert proxo_hsa if proxo_zip
		label variable proxf_zip "Indicates whether provzip is the first author zip"
		label variable proxl_zip "Indicates whether provzip is the last author zip"
		label variable proxo_zip "Indicates whether provzip is any other author zip"
		label values proxf_zip
		label values proxl_zip
		}
		
		* Provider HRR Location: "central" zip of the provider HRR
		preserve
		use hrrnum Lat Lon using `home'/data/crosswalks/ziphrrlatlong.dta, clear
		bys hrrnum: assert Lat==Lat[1] & Lon==Lon[1]
		bys hrrnum: keep if _n==1
		rename hrrnum phrrnum 
		rename Lat phrrlat
		rename Lon phrrlon
		sort phrrnum
		saveold hrrzipcw_tmp, replace
		restore
		merge m:1 phrrnum using hrrzipcw_tmp, assert(match) nogenerate noreport
		rm hrrzipcw_tmp.dta
		label variable phrrlat "Lat of phrrnum (mean over all zips in HRR)"
		label variable phrrlon "Lon of phrrnum (mean over all zips in HRR)"

		* Save
		saveold `home'/data/extracts/step2/prox/stacked_`loctyp', replace
	}
}

* Regression file prep
foreach loctyp in zip hsa hrr {
	* Load HSA-level stacked claims
	use `home'/data/extracts/step2/prox/stacked_`prov', clear
	
	* Keep only select drugs, meeting at least 10 claims within 2 calendar years following FDA approval (eventyrs 1-2). Also drops BCG, which was not a new agent (just new to chemo).
	gen keeper = 0
	foreach drug in `druglist10' {
		replace keeper = 1 if drug=="`drug'"
	}
	tab keeper
	keep if keeper
	drop keeper
	
	* Keep only relevant observations for the regressions (speeds things up somewhat)
	*		either regdata_hrr (event years 1-4) or regdata_hrr_neg (event years -3-4)
	local type regdata_hrr_neg
	local maxeventyr 4
	if "`type'"=="regdata_hrr_neg" {
		keep if -4<eventyr & eventyr<=`maxeventyr'
	}
	else if "`type'"=="regdata_hrr" {
		keep if 0<eventyr & eventyr<=`maxeventyr'
	}
	
	* Keep only "definitely" targeted patients
	keep if dgns_dz_def==1 
	
	* Create spell data, one observation per bene-year in which bene_id has a spell
	* Note: the following file is stored on agescratch6, so need to run code on age6 server to access
	if 0 {
	preserve
	local slen 365
	use bene_id ep`slen'*dt using `home'/data/extracts/step1/aux/spells/chem_spell_`slen'days, clear
	gen length = year(ep`slen'thrudt)-year(ep`slen'fromdt)+1
	expand length
	bys bene_id ep`slen'thrudt: gen syear = year(ep`slen'fromdt)+_n-1
	bys bene_id syear: assert _N==1
	keep bene_id syear
	save spells, replace
	restore
	}
	
	* Mark "newspells", defined as a patient's 1-yr treatment spells in which the patient had no cancer treatment in previous calendar year
	gen syear = fyear-1
	sort bene_id syear
	merge m:1 bene_id syear using spells, keep(match master) gen(newspell) 
	replace newspell = !(newspell==3)
	label drop _merge
	drop syear
	tab newspell

	* Generate numeric drug category for the regressions
	egen ndrug = group(drug)
	tab drug eventyr if chem_drug
	
	* Flag drugs that do not have at least 10 obs in eventyr1.  These are plausibly drugs for whom the billing code was introduced late.
	gen latecode = (drug=="arsenic" | drug=="capecitabine" | drug=="trastuzumab" | drug=="valrubicin")
	
	* First Author: Provider/Beneficiary HRR/HSA neighbor status
	merge m:1 generic using `home'/data/extracts/step2/tmp_drugzipxw_aug.dta, keep(master match) keepusing(generic `prov'numf `prov'numfb) nogenerate noreport
	foreach x in p b {
	foreach suff in f fb {
		di "`suff'"
		gen `prov'num = `prov'num`suff'
		gen neighbor = `x'`prov'num
		merge m:1 `prov'num neighbor using `home'/data/crosswalks/`prov'_neighbors_long, keep(master match) nogenerate noreport
		assert missing(neighbor_level) if (`x'`prov'num==`prov'num`suff')
		replace neighbor_level = 0     if (`x'`prov'num==`prov'num`suff') & !missing(`x'`prov'num)
		replace neighbor_level = 3     if missing(neighbor_level) & !missing(`x'`prov'num)
		assert missing(neighbor_level) if missing(`x'`prov'num)
		rename neighbor_level `x'neighbor`suff'
		drop `prov'num neighbor
	}
	assert `x'neighborfb==3 if !(drug=="bortezomib") & !missing(`x'`prov'num)
	assert missing(`x'`prov'num) if !(drug=="bortezomib") & !(`x'neighborfb==3)
	assert drug=="bortezomib" if `x'neighborfb==0
	
	generat `x'neighborf_`prov' = min(`x'neighborf,`x'neighborfb)
	cap gen `x'roxf_`prov' = (`x'`prov'num==`prov'numf | `x'`prov'num==`prov'numfb) if !missing(`x'`prov'num)
	replace `x'roxf_`prov' = (`x'`prov'num==`prov'numf | `x'`prov'num==`prov'numfb) if !missing(`x'`prov'num)
	replace `x'roxf_`prov' = .                                                      if  missing(`x'`prov'num)
	assert (`x'neighborf_`prov'==0)==(`x'roxf_`prov'==1) if !missing(`x'`prov'num)
	assert missing(`x'neighborf_`prov') & missing(`x'roxf_`prov') if missing(`x'`prov'num)
	
	tab  `x'neighborf_`prov' 
	drop `x'neighborf `x'neighborfb
	}
	desc ?neighbor*
	
	* Any Author: Provider/Beneficiary HRR/HSA neighbor status
	merge m:1 generic using `home'/data/extracts/step2/tmp_drugzipxw_aug.dta, keep(master match) keepusing(generic `prov'num*) nogenerate noreport
	foreach x in p b {
	foreach suff in f fb l 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 {
		di "`suff'"
		gen `prov'num = `prov'num`suff'
		gen neighbor = `x'`prov'num
		merge m:1 `prov'num neighbor using `home'/data/crosswalks/`prov'_neighbors_long, keep(master match) nogenerate noreport
		assert missing(neighbor_level) if (`x'`prov'num==`prov'num`suff')
		replace neighbor_level = 0     if (`x'`prov'num==`prov'num`suff') & !missing(`x'`prov'num)
		replace neighbor_level = 3     if missing(neighbor_level)         & !missing(`x'`prov'num)
		assert missing(neighbor_level) if                                    missing(`x'`prov'num)
		rename neighbor_level `x'neighbor`suff'
		drop `prov'num neighbor
	}
	assert `x'neighborfb==3      if !(drug=="bortezomib") & !missing(`x'`prov'num)
	assert missing(`x'`prov'num) if !(drug=="bortezomib") & !(`x'neighborfb==3)
	assert drug=="bortezomib"    if (`x'neighborfb==0)
	
	local neighborlist 
	local proxlist 0
	foreach suff in f fb l 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 {
		local neighborlist `neighborlist',`x'neighbor`suff'
		local proxlist `proxlist' | `x'`prov'num==`prov'num`suff'
	}
	
	* Generate each region's neighbor status, defined as closest neighbor level to an "any other" HRR
	* Create flags (e.g. proxa_hrr) for phrrnum==in any author's HRR.
	generat `x'neighbora_`prov' = min(`neighborlist')
	cap gen `x'roxa_`prov' = (`proxlist') if !missing(`x'`prov'num)
	replace `x'roxa_`prov' = (`proxlist') if !missing(`x'`prov'num)
	replace `x'roxa_`prov' = .            if  missing(`x'`prov'num)
	
	* Assert that the anyneighbor flag is zero for regions that in fact contain any author
	assert (`x'neighbora_`prov'==0)==(`x'roxa_`prov'==1) if !missing(`x'`prov'num)
	assert missing(`x'neighbora_`prov') & missing(`x'roxa_`prov') if missing(`x'`prov'num)
	
	* Assert that the anyneighbor level is no greater than the firstneighbor level
	assert `x'neighbora_`prov' <= `x'neighborf_`prov'
	assert (`x'neighbora_`prov'==0)==(`x'roxa_`prov'==1)
	
	tab `x'neighborf_`prov' `x'neighbora_`prov'
	foreach suff in f fb l 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 {
		drop `x'neighbor`suff'
	}
	}
	desc ?neighbor*
	
	* If coded correctly, broxf_prov should equal proxf_prov whenever a patient is being treated in residence region
	assert (broxf_`prov'==proxf_`prov') if b`prov'num==p`prov'num
	
	* Generate disease code
	gen disease_cd = 0
	foreach drug in `druglist10' {
		replace disease_cd = `dz_`drug'' if drug=="`drug'"
	}
	
	* Cancer Types: 7-categories
	* 1=breast
	* 2=urologic
	* 3=colon
	* 4=lung
	* 5=hematologic
	gen cancertype7 = .
	replace cancertype7 = 1 if (disease_cd==1)
	replace cancertype7 = 2 if (disease_cd==3 | disease_cd==6 | disease_cd==17)
	replace cancertype7 = 3 if (disease_cd==11)
	replace cancertype7 = 4 if (disease_cd==12)
	replace cancertype7 = 5 if (disease_cd==2 | disease_cd==5 | disease_cd==7 | disease_cd==8 | disease_cd==10 | disease_cd==13 | disease_cd==14 | disease_cd==15 | disease_cd==16)
	replace cancertype7 = 6 if (disease_cd==4)
	replace cancertype7 = 7 if (disease_cd==9)
	label define cancertypes7 1 breast 2 urologic 3 colon 4 lung 5 hematologic 6 brain 7 hcm 
	label values cancertype7 cancertypes7
	tab disease_cd cancertype7, miss
	tab drug cancertype7, miss
	
	* Cancer Types: 3-categories
	* 1=other carcinomas
	* 2=urologic cancers
	* 3=hematologic cancers
	generat cancertype3 = 1
	replace cancertype3 = 2 if cancertype7==2
	replace cancertype3 = 3 if cancertype7==5
	label define cancertypes3 1 other 2 urologic 3 hematologic
	label values cancertype3 cancertypes3
	tab cancertype7 cancertype3, miss
	tab drug cancertype3, miss
	
	* Cancer Types: 1-category (just for naming consistency)
	generat cancertype1 = 1
	label define cancertypes1 1 carcinoma
	label values cancertype1 cancertypes1
	
	* Which drugs make a balanced panel, for different eventyrs?  Tab the number of primary (def or maybe) diagnoses for each drug-by-eventyr
	tab drug eventyr
	tab drug eventyr if chem_drug==1
	local bal_1 1
	local bal_2 !(drug=="temsirolimus")
	local bal_3 `bal_2' & !(drug=="decitabine" | drug=="panitumumab")
	local bal_4 `bal_3' & !(drug=="nelarabine")
	local bal_5 `bal_4' & !(drug=="bevacizumab" | drug=="cetuximab" | drug=="clofarabine" | drug=="pemetrexed")
	gen bal_1 = `bal_1'
	gen bal_2 = `bal_2'
	gen bal_3 = `bal_3'
	gen bal_4 = `bal_4'
	gen bal_5 = `bal_5'
	
	* Create cluster level group
	* Ultimately we want 2-way clusters in drug-HRR, and bene_id
	egen phrrdrug = group(phrrnum drug)
	egen bhrrdrug = group(bhrrnum drug)
	
	* Flag regions in which a first/any author ever occurs
	foreach x in p b {
	foreach a in f a {		
	bys `x'`prov'num: egen ever`x'rox`a' = max(`x'rox`a'_`prov')
	tab ever`x'rox`a'
	}
	}
	
	* Flag patients residing in the provider HRR
	gen resident_`prov' = (b`prov'num==p`prov'num)
	tab resident_`prov'
	
	* Generate provider region-by-cancer type groups. The first is just another name for p/b`prov'num, since cancertype1==1 everywhere)
	foreach i in 1 3 7 {
	foreach x in p b {
	egen `x'`prov'cancer`i' = group(`x'`prov'num cancertype`i')
	}
	}
	
	* List drugs by cancer type categories
	tab generic cancertype1 if 1<=eventyr & eventyr<=2, miss
	tab generic cancertype3 if 1<=eventyr & eventyr<=2, miss
	tab generic cancertype7 if 1<=eventyr & eventyr<=2, miss
	
	* Save
	if "`type'"=="regdata_hrr_neg" {
		saveold `home'/regdata_`prov'_neg, replace
	}
	else if "`type'"=="regdata_hrr" {
		saveold `home'/regdata_`prov', replace
	}

* end: Data setup
}

* Regression file, final generation
if 1 {
	* Set oldfile to be either regdata_hrr (event years 1-4) or regdata_hrr_neg (event years -3-4)
	local oldfile regdata_hrr
	use `home'/`oldfile', clear
	
	* (Re)Define first, last, other, and any author HRRs
	*	Previously defined, but a few inconsistencies that we have now corrected
	if 1 {
		* Remove old HRR author definitions
		drop prox?_hrr everprox? hrrnum? hrrnum?? *brox* N_?hrr_eventyr latf_hrr lonf_hrr ?neighbor*
		desc *hrr*
		
		* Merge in author HRR info
		preserve
		local PhysicianIDs CancerDrugs_PhysicianIDs_141211
		import excel "`physgroups'/`PhysicianIDs'.xls", sheet("Physician IDs") firstrow clear
		keep if (insample==1) & (4<=strlen(zip) & strlen(zip)<=5 & lower(zip)!="paris")
		keep drug order zip year
		destring zip, replace
	
		* Merge in HRR numbers for each zip
		rename zip zipcode
		rename year zyear
		merge m:1 zip zyear using `crosswalks'/ziphsahrr_95_10_filled.dta, keepusing(hrrnum hrrcity) assert(match using) keep(match) nogen noreport
		rename zipcode zip
		rename zyear year
		
		* Mark each HRR-drug combination based on author status
		bys drug hrrnum: egen byte proxf_hrr = max(order=="f")
		bys drug hrrnum: egen byte proxl_hrr = max(order=="l")
		bys drug hrrnum: egen byte proxo_hrr = max(order=="o")
		bys drug hrrnum: gen byte proxa_hrr = (proxf_hrr | proxl_hrr | proxo_hrr)
		assert proxa_hrr==1
		
		* Save only one obs per drug-HRR
		keep drug hrrnum prox?_hrr
		bys drug hrrnum: keep if _n==1
		tempfile proxdata
		save "`proxdata'"
		restore
		
		* Merge in Author proximity data to regression data
		gen hrrnum = phrrnum
		merge m:1 drug hrrnum using "`proxdata'", assert(match master) nogen noreport
		drop hrrnum
		
		* Replace author proximity variables to 0 for non-matches
		foreach var of varlist prox?_hrr {
			replace `var' = 0 if missing(`var')
		}
	}
	
	* merge in physician group association variables
	merge m:1 bene_id fyear using `physgroups'/bene_year_drugassoc_group, keep(match) nogen noreport
	
	* generate marker for whether individual treated by a doctor in first author's physician group
	qui {
	gen f_group = 0
	foreach drug in alemtuzumab arsenic bevacizumab bortezomib capecitabine cetuximab decitabine denileukin epirubicin fulvestrant gemtuzumab ibritumomab oxaliplatin panitumumab pemetrexed temozolomide temsirolimus tositumomab trastuzumab valrubicin zoledronic {
		capture confirm variable f_`drug'
		if _rc {
			di "f_`drug' does not exist"
		}
		else {
			sum f_`drug'
			replace f_group = 1 if (f_`drug'==1 & drug=="`drug'")
		}
	}
	replace f_group = 0 if !proxf_hrr
	
	gen l_group = 0
	foreach drug in alemtuzumab arsenic bevacizumab bortezomib capecitabine cetuximab decitabine denileukin epirubicin fulvestrant gemtuzumab ibritumomab oxaliplatin panitumumab pemetrexed temozolomide temsirolimus tositumomab trastuzumab valrubicin zoledronic {
		capture confirm variable l_`drug'
		if _rc {
			di "l_`drug' does not exist"
		}
		else {
			sum l_`drug'
			replace l_group = 1 if (l_`drug'==1 & drug=="`drug'")
		}
	}
	replace l_group = 0 if !proxl_hrr
	
	gen o_group = 0
	foreach drug in alemtuzumab arsenic bevacizumab bortezomib capecitabine cetuximab decitabine denileukin epirubicin fulvestrant gemtuzumab ibritumomab oxaliplatin panitumumab pemetrexed temozolomide temsirolimus tositumomab trastuzumab valrubicin zoledronic {
		capture confirm variable o_`drug'
		if _rc {
			di "o_`drug' does not exist"
		}
		else {
			sum o_`drug'
			replace o_group = 1 if (o_`drug'==1 & drug=="`drug'")
		}
	}
	replace o_group = 0 if !proxo_hrr
	
	gen a_group = 0
	foreach drug in alemtuzumab arsenic bevacizumab bortezomib capecitabine cetuximab decitabine denileukin epirubicin fulvestrant gemtuzumab ibritumomab oxaliplatin panitumumab pemetrexed temozolomide temsirolimus tositumomab trastuzumab valrubicin zoledronic {
		capture confirm variable f_`drug'
		if _rc {
			di "f_`drug' does not exist"
		}
		else {
			replace a_group = 1 if ((f_`drug'==1 | o_`drug'==1 | l_`drug'==1) & drug=="`drug'")
		}
	}
	replace a_group = 0 if !proxa_hrr
	assert a_group>=f_group
	
	}
	
	* Merge in citation/publication rank of top author in each region
	gen hrrnum = phrrnum
	merge m:1 drug hrrnum using `citations'/drug_hrr_cites.dta, assert(match master) keep(match master) nogen noreport keepusing(pubs_* cites_*)
	drop hrrnum
	foreach var of varlist pubs_* cites_* {
		replace `var' = 0 if missing(`var')
	}
	assert proxa_hrr if pubs_top50
	
	* Summary Stats
	tabstat f_group if proxf_hrr, by(drug)
	tabstat l_group if proxl_hrr, by(drug)
	tabstat o_group if proxo_hrr, by(drug)
	tabstat a_group if proxa_hrr, by(drug)
	
	* Measure Doc Group Penetration in HRR
	bys drug proxf_hrr: egen penetration_f = mean(f_group)
	bys drug proxl_hrr: egen penetration_l = mean(l_group)
	bys drug proxo_hrr: egen penetration_o = mean(o_group)
	bys drug proxa_hrr: egen penetration_a = mean(a_group)
	gen proxf_hrr2 = proxf_hrr*(penetration_f>0)
	gen f_group2 = f_group*(penetration_f>0)
	gen proxl_hrr2 = proxl_hrr*(penetration_l>0)
	gen l_group2 = l_group*(penetration_l>0)
	gen proxo_hrr2 = proxo_hrr*(penetration_o>0)
	gen o_group2 = o_group*(penetration_o>0)
	gen proxa_hrr2 = proxa_hrr*(penetration_a>0)
	gen a_group2 = a_group*(penetration_a>0)
	
	* Measure Neighbors
	* Specify the definition of author region for which neighbor status is to be determined
	foreach level in f_hrr2 l_hrr2 o_hrr2 {
		* Define "neighbor" HRRs, using proxf_hrr2, proxl_hrr2, proxo_hrr2, and proxa_hrr2
		preserve
		
		* Keep one obs per drug-order-HRR
		keep if prox`level'
		keep generic phrrnum
		bys generic phrrnum: keep if _n==1
	
		* Pair up primary HRR numbers with all neighbors
		gen hrrnum = phrrnum
		joinby hrrnum using `crosswalks'/hrr_neighbors_long, unmatched(none)
	
		* In a few cases, the same "neighbor" may show up twice for the same drug; keep the lowest neighbor status
		rename neighbor_level tmp
		bys generic neighbor: egen neighbor_level = min(tmp)
	
		* Keep only one obs per drug-neighbor HRR
		drop phrrnum hrrnum
		bys generic neighbor: keep if _n==1
	
		* Rename and Save
		rename neighbor_level pneighbor`level'
		saveold tmp_neighbor`level', replace
	
		* Merge back into main data
		restore
		gen neighbor = phrrnum
		merge m:1 generic neighbor using tmp_neighbor`level', keep(match master) keepusing(pneighbor`level') nogen noreport
		rm tmp_neighbor`level'.dta
		drop neighbor
	
		* Re-assign neighbor level to correspond to author region (level=0) and non-neighbor (level=3)
		replace pneighbor`level'=0 if prox`level'
		replace pneighbor`level'=3 if missing(pneighbor`level')
	}
	* Generate "any author" neighbor status, as the minimum of first-, last-, and other-author status
	egen pneighbora_hrr2 = rowmin(pneighborf_hrr2 pneighborl_hrr2 pneighboro_hrr2)
	
	* SAVE THE **FINAL** REGRESSION-READY DATA
	saveold `home'/`oldfile'_new, replace
}


* end step2_prox
}

}
