*Table_4

do Define_Globals

*****************************************************************
* Table 4 - Treatment Effect on the Amount Requested
*****************************************************************
use listing_final, clear

* Baseline amounts
tab prime_categ treat if (after_change == 0 & control == 0  & inrange(month_id,11,15)), sum(amountrequested) means 

local ll = log(1000)
local ul = log(25000)	
tobit log_amount_req $DIFF3 $DIFF2 $DIFF1 $COVARIATES $WEEK_DUM, vce(cluster st_week) log ///
	ll(`ll') ul(`ul')

*Calculate marginal effect
mfx compute, predict(e(`ll',`ul')) /// 
	varlist(after_Treat_*_super_prime after_Treat_*_prime after_Treat_*_sub_prime) force
