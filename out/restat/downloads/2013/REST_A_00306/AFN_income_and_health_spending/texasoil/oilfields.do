clear
set more off
capture log close

**log using oilfields.log, replace

insheet using OilFields.csv, clear
sum
replace state = proper(state)
replace field = proper(field)

rename est1998prod1000bbl prod1998
rename cumprod11991000bbl       cumprod
rename estremreserves1000bbl    reserves
rename estnoprodwells   wells

sort state field
tempfile oilfields
save "`oilfields'", replace

insheet using fcml.csv, clear
compress
desc

rename field_name field
rename cnty_name county
rename stsub    st
rename cnty_code county_code
rename fld_discyr field_disc_yr
rename statename state

replace state = proper(state)
replace field = proper(field)

duplicates tag state field, gen(extra)

sort state field
merge state field using "`oilfields'", uniqusing

tab _merge, mi
tab extra _merge, mi

preserve
keep if _merge==3
drop _merge
tempfile merges
save "`merges'", replace
restore

bys _merge: egen tots = sum(cumprod + reserves)
bys _merge: summ tots

kaboom
keep if _merge!=3
sort state field
list cumprod state field county_code field_disc_yr yeardiscovered _merge if _merge!=3 & ~missing(state) & (_merge==2 | _merge[_n-1]==2 | _merge[_n+1]==2 | _merge[_n-2]==2 | _merge[_n+2]==2)
list cumprod state field county_code field_disc_yr yeardiscovered _merge if _merge==2

use "`merges'", clear
desc
drop extra

label variable field "Field name"
label variable county "County name"
label variable st "State abbreviation"
label variable county_code "County code"
label variable field_code "Field code"
label variable field_disc_yr "Year field discovered (from fcml.csv)"
label variable yeardiscovered "Year field discovered (from oilfields.csv)"

desc
compress
save oilfields.dta, replace

**log close
