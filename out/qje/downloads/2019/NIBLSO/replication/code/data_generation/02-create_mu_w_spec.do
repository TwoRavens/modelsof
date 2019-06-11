/*****************************************************************************************
AUTHORS: David Chan and Michael Dickstein, QJE (2019), "Industry Input in Policymaking: 
Evidence from Medicare"

PURPOSE: Process Medicare data to have consistent specialty designations

INPUTS:
- mu.dta

OUTPUTS:
- mu_w_spec.dta
*****************************************************************************************/

if "${dir}"!="" cd "${dir}"
	// Can set global macro for root directory of replication package ending with
	// "/replication". Otherwise, ensure that Stata is in the root directory.
assert regexm("`c(pwd)'","replication$")
clear all
program drop _all
adopath + ado

*** Preprocess Medicare data *************************************************************
use "data/intermediate/mu", clear
keep freq year spec spec_desc cptcode
rename cptcode cpt_code
destring spec, gen(specnum) force
replace spec=string(specnum) if spec!="C0"
replace spec="15A" if spec_desc=="OBSTETRICS (OSTEOPATHS ONLY)"
replace spec="15B" if spec_desc=="SPEECH LANGUAGE PATHOLOGIST"
replace spec="17A" if ///
	spec_desc=="OPHTHALMOLOGY, OTOLOGY, LARYNGOLOGY,RHINOLOGY (OSTEOPATHS ONLY)"
replace spec="17B" if spec_desc=="HOSPICE"
replace spec="27A" if spec_desc=="PSYCHIATRY, NEUROLOGY"
replace spec="27B" if spec_desc=="GERIATRIC PSYCHIATRY"
replace spec="19" if spec_desc=="ORAL SURGERY"
replace spec="22" if spec_desc== ///
	"PATHOLOGIC ANATOMY, CLINICAL PATHOLOGY (OSTEOPATHS ONLY) (DISCONTINUED 4/92 USE CODE 22)"
replace spec="62" if regexm(spec_desc,"PSYCHOLOG")
drop if spec_desc=="RESERVED"
replace spec="76" if spec_desc== ///
	"PERIPHERAL VASCULAR DISEASE, MEDICAL OR SURGICAL (OSTEOPATHS ONLY) (DISCONTINUED 4/92 USE CODE 76)"
replace spec="30" if spec_desc=="ROENTGENOLOGY, RADIOLOGY, (OSTEOPATHS ONLY)"
replace spec="C1" if spec_desc=="PHARMACY"

keep spec cpt_code year freq
drop if spec==""
by cpt_code spec year, sort: egen totfreq=total(freq)
drop freq
rename totfreq freq
duplicates drop
save "data/intermediate/mu_w_spec", replace
