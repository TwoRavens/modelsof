*! makeValidityData.do
*! Constructs dataset with validity indicators:
*! 
*!    validity_dataset_full.dta 
clear *

// Generate list of ads with RA coding
use dataSets/hitlevel_work1
keep if inlist(codingType,5,6)
by adName, sort: keep if _n==1
keep adName
save dataSets/raAdList, replace

// Now create validity data
clear *
use dataSets/hitlevel_work1

sort adName
merge m:1 adName using dataSets/raAdList
gen adHasRAcoding = _merge==3
la de adHasRAcoding 0 "No RA coded ad" 1 "RA coded ad"
la val adHasRAcoding adHasRAcoding 
drop _merge

gen     obsType = 1 if coderType==1 
replace obsType = 4 if coderType==3
la de obsType 1 "mTurk coder" 2 "mTurk meta-coder" 4 "RA"
la val obsType obsType

tempfile singledata
save "`singledata'"

*****************
* Get Metacoders
*****************
use dataSets/hitlevel_metacoders_unrounded.dta
keep if inrange(codingType,101,104) // just mTurk metacoders

sort adName
merge m:1 adName using dataSets/raAdList
gen adHasRAcoding = _merge==3
drop _merge

gen obsType = 2
tempfile metadata
save "`metadata'"

use "`singledata'"
append using "`metadata'"

*******************
* add WMP coding
*******************
// recreate creative for merge because metacoder dataset does not have it
drop creative
gen creative = subinstr(adName,".mp4","",.)
replace creative=subinstr(creative,"HOUSE_","HOUSE/",.)
replace creative=subinstr(creative,"USSEN_","USSEN/",.)
replace creative=subinstr(creative,"_"," ",.)
merge m:1 creative using dataSets/cmag_adcoding2010_withideology.dta, keep(match master)
assert _merge==3
drop _merge

//party 
gen party = 1 if wmp_party=="Democrat"
replace party = 2 if wmp_party=="Republican"
replace party = 3 if !mi(wmp_party) & mi(party)
la de party 1 "Democrat" 2 "Republican" 3 "Other"
la val party party

la var bonica_dwnominate "Favored candidate @bs@textsc@ob@dw-nominate@cb@"

// and save!
compress
save dataSets/validity_dataset_full, replace


exit


