
*Setup

cd "\\ead02\ead_uquam\Localization\NAICS6_panel"

*Data preparation

use "cdf_piphi.dta", clear

drop weight pi phi _type_ _freq_ /*repeated or unneeded variables*/

*Checked that pi and phi and pi800 and phi800 are the same, confirming summation.

save "cdf_piphitrim.dta", replace

use "cdf_rhs_rev1.dta", clear

	merge m:1 year naics using cdf_piphitrim
	drop _merge /*0 not matched*/

save "cdf_rhs_rev2.dta", replace

