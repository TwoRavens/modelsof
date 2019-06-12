clear *
set more off, permanently
 cd "/Users/marritteirlinck/Dropbox/betterplace"

use "empirics/data/defaults_donations.dta"

drop if q99_8==1

keep donated_amount default_donation

export delimited "optimal_defaults/MLE_matlab/_data/data_section4", replace
