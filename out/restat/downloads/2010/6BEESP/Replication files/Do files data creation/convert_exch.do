clear all
capture log close
set more off

insheet using ~/borja2/DATA/sources/wdi_exch.txt, names

rename country isocode
rename country_name country

/* destring variables. */
forval i = 1976(1)2000 {
gen d`i' = real(data`i')
}
drop data*

/* reshape data. */
reshape long d, i(cid sid) j(year)
drop ind1_desc ind1
reshape wide d, i(cid year) j(sid)

/* rename series. */
rename d1 gdp_constant_us
rename d2 gdp_current_lcu
rename d3 gdp_current_us
rename d4 gdp_constant_intl


/* drop identifiers and order series. */
drop cid
order country isocode year gdp_current_lcu gdp_current_us gdp_constant_us gdp_constant_intl

save ~/borja2/DATA/wdi_exch_temp.dta, replace

clear

use ~/borja2/DATA/pn_penntable_nov2005.dta

contract isocode
drop _freq

joinby isocode using ~/borja2/DATA/wdi_exch_temp.dta, unmatched(master) 
drop _merge
drop if isocode=="TWN"

save ~/borja2/DATA/sources/wdi_exch.dta, replace

clear all
set more off

insheet using ~/borja2/DATA/sources/ifs_exch.txt, names

/* Reshape. */
reshape long xr, j(isocode) i(year) string
sort isocode year
replace isocode = upper(isocode)

/* Save data. */

save ~/borja2/DATA/sources/ifs_exch.dta, replace

