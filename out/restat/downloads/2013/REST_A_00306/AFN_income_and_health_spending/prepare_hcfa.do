

clear
use ./dta/fips
sort stname
save ./dta/fips.dta, replace


clear
insheet using ./dta/HCFA.CSV, names
keep if group == "State"

desc, full
rename statename stname

sort stname
merge stname using ./dta/fips, uniqusing
tab _merge, missing
assert _merge != 1
list stname if _merge == 2
keep if _merge == 3

keep fipsStateCode item y19*
reshape long y, i(fipsStateCode item) j(year) string
rename y hcfa_

replace item = trim(substr(item, 1, 14))
replace item = trim(subinstr(item, " ", "", .))
replace item = trim(subinstr(item, "&", "", .))
drop if strpos(item, "Population") != 0

reshape wide hcfa_, i(fipsStateCode year) j(item) string
drop hcfa_GrossState*
rename hcfa_PersonalHealt hcfa_Total

rename year year_str
gen year = real(year_str)
drop year_str

sort fipsStateCode year
save ./dta/hcfa_1980_to_1998.dta, replace



clear
set more off
set mem 200m

foreach year of numlist 1972 1976(1)1979 {
 clear 
 insheet using ./dta/hcfa`year'.txt
 gen year = `year'
 sort place
 save ./tmp/hcfa`year'.dta, replace
}

clear
use  ./tmp/hcfa1972.dta
append using ./tmp/hcfa1976.dta
append using ./tmp/hcfa1977.dta
append using ./tmp/hcfa1978.dta
append using ./tmp/hcfa1979.dta

desc, full
bys year: summ

rename place stname
sort stname
merge stname using ./dta/fips, uniqusing
tab _merge
list stname year _merge if _merge != 3
drop if _merge != 3
drop _merge


desc, full

rename total hcfa_Total     
rename hospitalcare hcfa_HospitalCare
rename dentistsservices hcfa_DentalService
rename nursinghomecare hcfa_NursingHomeC
rename eyeglassesandapplicances hcfa_VisionProduct
rename physiciansservices hcfa_PhysicianOt

rename drugsandmedicalsundries hcfa_DrugsandOthe
rename otherprofessionalservices hcfa_HomeHealthCa
rename otherpersonalhealthcare hcfa_OtherPersonal

append using ./dta/hcfa_1980_to_1998

egen hcfa_Other = rowtotal(hcfa_OtherPersonal hcfa_HomeHealthCa)
drop hcfa_OtherPersonal hcfa_HomeHealthCa

** this is a SUBSET of drugs ...
gen hcfa_PrescriptionDrugs = hcfa_PrescriptionD
drop hcfa_PrescriptionD

sort fipsStateCode year
save ./dta/hcfa_all.dta, replace



