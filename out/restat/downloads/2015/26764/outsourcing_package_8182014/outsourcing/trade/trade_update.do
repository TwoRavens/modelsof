clear
set mem 500m

use update
rename sic sic87
sort sic87 year
merge sic87 year using ../nber/techprices
tab _merge
keep if _merge==3
drop _merge
sort sic87 year
save trade_update, replace
