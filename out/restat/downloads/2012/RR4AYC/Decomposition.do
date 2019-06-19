// Input data: data\fitted.dta, table\crop_name.dta
// Output table\table6_decomposition.dta

set more off
clear
set memory 1000m

use data\fitted.dta

global croplist
foreach tempvar of varlist crop* {
	local var2 = substr("`tempvar'",6,.)	
	global croplist $croplist `var2'
}

renpfix crop y

sort county section_id q

by county: egen nobs_county = count(1)

// d county measue
foreach crop in $croplist {
	by county section_id q: egen d_both_sd_`crop' = sd(yhat_`crop') // both natural advantage and density economies
	by county: egen d_both_`crop' = mean((d_both_sd_`crop'^2)*3/4) // "3/4" is to correct the denominator; the denominator used in sd function is (n-1).

	by county section_id q: egen d_natural_sd_`crop' = sd(xhat_`crop') // natural advantage only
	by county: egen d_natural_`crop' = mean((d_natural_sd_`crop'^2)*3/4)

	by county: egen d_dartboard_sd_`crop' = sd(xhat_`crop') // neither
	by county: egen d_dartboard_`crop' = mean((d_dartboard_sd_`crop'^2)*(nobs-1)/nobs*(3/4))
}

keep county d_*
drop *_sd_*
duplicates drop

foreach crop in $croplist {
	gen w_`crop' = (d_dartboard_`crop' - d_both_`crop')/d_dartboard_`crop'
	gen w_natural_`crop' = (d_dartboard_`crop' - d_natural_`crop')/d_dartboard_`crop'
	gen NAS_`crop' = w_natural_`crop'/w_`crop'
	gen DES_`crop' = (w_`crop' - w_natural_`crop')/w_`crop'
	}

keep w_* NAS_* DES_*
drop w_natural*
collapse (mean) *

gen tempi =1
preserve
keep tempi NAS*
reshape long NAS_, i(tempi) j(crop)
drop tempi
sort crop
tempfile NAS
save `NAS'
restore

preserve
keep tempi DES*
reshape long DES_, i(tempi) j(crop)
drop tempi
tempfile DES
save `DES'
restore

keep tempi w*
reshape long w_, i(tempi) j(crop)
tempfile w
drop tempi

merge crop using `NAS', sort
drop if _merge != 3
drop _merge

merge crop using `DES', sort
drop if _merge !=3
drop _merge

rename w_ w
rename NAS_ NAS
rename DES_ DES

merge crop using table\crop_name.dta, sort
drop _merge
gsort - share

order crop_name w NAS DES

save table\table6_decomposition.dta, replace

