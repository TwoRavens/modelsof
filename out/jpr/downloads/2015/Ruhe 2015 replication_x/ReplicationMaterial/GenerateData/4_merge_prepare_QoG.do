* prepare Quality of Government data for merging

cd "`w_dir'"

use "QoG_version 30 August 2013.dta", clear


*keep only relevant years
keep if year>1992
keep if year<2005


*keep only relevant variables
keep ccode-version p_durable-p_sf wdi_gdpc-wdi_gdpgr


*drop redundant cases with missing ccode
drop if ccodecow==.


*save as country characteristics
xtset ccodecow year
local sysdate = c(current_date)
save "country_char_`sysdate'.dta", replace


*calculate average polity and number of democracies world wide
gen nr_dems=(p_polity2>5)
gen avg_polity=p_polity2
sort year
collapse (sum) nr_dems (mean) avg_polity, by(year)


*save as country characteristics
save "year_char_`sysdate'.dta", replace
