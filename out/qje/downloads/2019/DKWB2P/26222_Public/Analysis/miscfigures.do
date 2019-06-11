/* This do-file creates Figures 4 and 5 (and Appendix Figure B.1) for Costinot, Donaldson, Kyle and Williams (QJE, 2019) */ 

***Preamble***

capture log close
*Set log
log using "${log_dir}miscfigures.log", replace

*Supress graph window
set graphics off

use "${ctry_xwalk}ctry_xwalk.dta", clear
drop if who_label == "."
tempfile temp1
save `temp1'

*Get standardized country names
use "${intersavedir}us_census_popXwho_gbd.dta", clear
rename country who_label
merge m:1 who_label using `temp1', nogen keep(3)

*Only keep our dataset countries
rename tic_label sales_ctry
merge m:1 sales_ctry using "${intersavedir}destination_countries.dta", nogen keep(3)

*drop non_matched gbd_codes
drop if mi(gbd_2012)

*clear data a little
keep gbd_2012 gbd_desc gender agegrp deaths pop_who daly sales_ctry
replace gbd_2012 = subinstr(gbd_2012, "W", "U",.)

*preserve as this is the base we want to create multiple figures on
preserve



******* MAKE FIGURE 4 AND APPENDIX FIGURE B.1 *************
*get share of young per country
bysort sales_ctry gbd_2012: egen pop_young = total(pop_who) if agegrp < 3
bysort sales_ctry gbd_2012: egen pop_total = total(pop_who)
gen share_of_young = pop_young/pop_total

collapse (mean) share_of_young, by(sales_ctry)

*get gdp per capita data
*merge in gdp data
merge 1:1 sales_ctry using "${intersavedir}world_bank_gdppc_sales.dta", nogen keep(3)

*create indicator for above median GDP per capita
summarize gdppc_sales, detail
gen rich = 1 if gdppc_sales > r(p50)
replace rich = 0 if mi(rich)

*save rich identifier for DALY figures below
tempfile temp1
save `temp1'
keep sales_ctry rich
save "${intersavedir}rich_countries.dta", replace
use `temp1'

*Prepare data for figure
*this part ensures proper sorting in the graph
sort share_of_young
gen sales_country = _n
labmask sales_country, values(sales_ctry)

gen share_of_young_rich = share_of_young if rich == 1
sort share_of_young_rich
gen sales_country_rich = _n if !mi(share_of_young_rich)
labmask sales_country_rich, values(sales_ctry)

gen share_of_young_poor = share_of_young if rich == 0
sort share_of_young_poor
gen sales_country_poor = _n if !mi(share_of_young_poor)
labmask sales_country_poor, values(sales_ctry)

*set labels
label variable sales_country "Countries"
label variable sales_country_poor "Countries"
label variable sales_country_rich "Countries"
label variable share_of_young "Share of country population with age below 60"
label variable gdppc_sales "GDP per capita"

*Prepare points to label
gen label_ctry = "United Arab Emirates" if sales_ctry == "UNITED ARAB EMIRATES"
replace label_ctry = "Japan" if sales_ctry == "JAPAN"
replace label_ctry = "Bulgaria" if sales_ctry == "BULGARIA"
replace label_ctry = "Pakistan" if sales_ctry == "PAKISTAN"


*Create label positon variable
gen pos = 5
replace pos = 9 if label_ctry == "United Arab Emirates"
replace pos = 11 if label_ctry == "Pakistan"

*make Figure 4:
sort sales_country
twoway scatter share_of_young sales_country, yscale(range(0.65 1)) msymbol(D) mlabel(label_ctry) msize(vsmall) mlabv(pos) xlabel(none) graphregion(color(white)) connect(l) scheme(s1mono) || ///
scatter share_of_young sales_country if !mi(label_ctry), msymbol(D) msize(vsmall) xlabel(none) legend(off)
graph export "${output_dir}share_of_young_by_country.pdf", replace

* make Appendix Figure B.1:
sort sales_country_rich
twoway scatter share_of_young sales_country_rich, yscale(range(0.65 1)) msymbol(D) mlabel(label_ctry) msize(vsmall) mlabv(pos) xlabel(none) graphregion(color(white)) connect(l) scheme(s1mono) || ///
scatter share_of_young sales_country_rich if !mi(label_ctry), msymbol(D) msize(vsmall) xlabel(none) legend(off)
graph export "${output_dir}share_of_young_by_country_rich.pdf", replace

sort sales_country_poor
twoway scatter share_of_young sales_country_poor, yscale(range(0.65 1)) msymbol(D) mlabel(label_ctry) msize(vsmall) mlabv(pos) xlabel(none) graphregion(color(white)) connect(l) scheme(s1mono)|| ///
scatter share_of_young sales_country_poor if !mi(label_ctry), msymbol(D) msize(vsmall) xlabel(none) legend(off)
graph export "${output_dir}share_of_young_by_country_poor.pdf", replace


******* MAKE FIGURE 5 *************
restore

tempfile tempmain
save `tempmain'

use "${atc_gbd}atc_gbd_xwalk.dta", clear
collapse (first) gbd_desc, by(gbd_code)
rename gbd_code gbd_2012
tempfile temp1
save `temp1'

*only keep relevant gbd codes
use `tempmain'
merge m:1 gbd_2012 using `temp1', nogen keep(3)

*merge in rich country identifier
merge m:1 sales_ctry using "${intersavedir}rich_countries.dta"
*check if all countries are matched
assert _m == 3
drop _m

preserve

*get share of young daly per disease category
bysort gbd_2012: egen daly_young = total(daly) if agegrp < 3
bysort gbd_2012: egen daly_total = total(daly)
gen share_of_young_daly = daly_young/daly_total
 
collapse (mean) share_of_young_daly, by(gbd_2012 gbd_desc)
replace gbd_2012 = subinstr(gbd_2012, "W", "U",.)

*Prepare data for figure
*this part ensures proper sorting in the graph
sort share_of_young_daly
gen gbd_code = _n
labmask gbd_code, values(gbd_2012)


*set labels
label variable share_of_young_daly "Share of global disease burden among population below age 60"


*Prepare points to label
gen label_gbd = "U087" if gbd_2012 == "U087"
replace label_gbd = "U012" if gbd_2012 == "U012"
replace label_gbd = "U078" if gbd_2012 == "U078"
replace label_gbd = "U089" if gbd_2012 == "U089"
replace label_gbd = "U086" if gbd_2012 == "U086"

*Create label positon variable
gen pos = 5
replace pos = 7 if label_gbd == "U012"

*make Figure 5:
local y_sublabel_1 = "U012 Whooping cough; U078 Other neoplasms; U086 Alcohol use disorders"
local y_sublabel_2 = "U087 Alzheimer's disease and other dementia; U089 Multiple sclerosis"
sort gbd_code
twoway scatter share_of_young_daly gbd_code, yscale(range(0 1)) msymbol(D) mlabel(label_gbd) msize(vsmall) mlabv(pos) xlabel(none) xtitle("GBD codes") ytitle("Share of global disease burden" "borne by population below age 60") graphregion(color(white)) connect(l) scheme(s1mono) || ///
scatter share_of_young_daly gbd_code if !mi(label_gbd), msymbol(D) msize(vsmall) xlabel(none) legend(off)
graph export "${output_dir}share_of_young_daly_by_disease.pdf", replace

log close


