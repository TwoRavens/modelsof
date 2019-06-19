clear
set mem 500m

use update
sort sic year
merge sic year using sic5805
rename emp labor
keep if _merge==1|_merge==3
capture drop _merge
rename sic sic87
sort sic87 year
merge sic87 year using ../nber/techprices
tab _merge
keep if _merge==3
drop _merge
sort sic87 year
save trade_update_new, replace
