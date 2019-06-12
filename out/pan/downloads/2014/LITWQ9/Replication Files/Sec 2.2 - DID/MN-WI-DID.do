

use "mnwi72-80.dta", replace

*DiD Estimates
regress turnout Trt1_year treat dyear ed_cat female black income_cat age age_sq, ro cluster(state)


use "mnwi72-76.dta", replace

*DiD Estimates
regress turnout Trt1_year treat dyear ed_cat female black income_cat age age_sq, ro cluster(state)

