
*******************************************************************************
* 1. Load SYZZ owner data
*******************************************************************************
local firstyr = 2000
local lastyr  = 2014 

forv yr = `firstyr'/`lastyr'{

	disp "Year"
	disp `yr'

foreach form in "s" "p" {
use $dtadir_yzz/`form'_firmowner_`yr'.dta, clear

keep ein tin wagesfromfirm ownerpay
g num_own    = !mi(tin)
g num_ownw2 =(wagesfromfirm>0) &!mi(wagesfromfirm) & !mi(tin)

collapse (sum) num_own num_ownw2 wagesfromfirm ownerpay, by(ein)
g year=`yr'
rename ein unmasked_tin
sort unmasked_tin year
save $dumpdir/ownerpay_`form'_`yr'.dta, replace
}
}

*******************************************************************************
* 2. append years together to create a firm-panel for scorps and pships
*******************************************************************************
foreach form in "s" "p" {

clear
forv yr = `firstyr'/`lastyr'{
append using $dumpdir/ownerpay_`form'_`yr'.dta
}

sort unmasked_tin year
save $dumpdir/ownerpay_`form'.dta, replace
}

*******************************************************************************
*3. KEEP EINS WITH OUTCOMES OF EINS IN SPINE 
*******************************************************************************

*start with s corps
use $dtadir/einXyear_spine.dta, clear
sort unmasked_tin year
merge 1:1 unmasked_tin year using $dumpdir/ownerpay_s.dta
keep if _merge==3
drop _merge
g form="s"
save $dumpdir/spine_ownerpay_s.dta, replace

*pship
use $dtadir/einXyear_spine.dta, clear
sort unmasked_tin year
merge 1:1 unmasked_tin year using $dumpdir/ownerpay_p.dta
keep if _merge==3
drop _merge
g form="p"
save $dumpdir/spine_ownerpay_p.dta, replace

append using $dumpdir/spine_ownerpay_s.dta

*clean up any switchers to keep s corp
g rank=1
replace rank=0 if form=="p"
gsort unmasked_tin year -rank
egen tag=tag(unmasked_tin year)
keep if tag==1

*******************************************************************************
* 4. Adjust for Inflation
*******************************************************************************
usd2014, var(wagesfromfirm) yr(year) 
usd2014, var(ownerpay) yr(year) 

*******************************************************************************
* 5. SAVE Data
*******************************************************************************

rename wagesfromfirm wb_own
drop rank tag
sort unmasked_tin year
save $dtadir/outcomes_patent_owners.dta, replace

**************
*clean up
***************
foreach form in "s" "p" {
forv yr = `firstyr'/`lastyr'{
rm $dumpdir/ownerpay_`form'_`yr'.dta
}
}

