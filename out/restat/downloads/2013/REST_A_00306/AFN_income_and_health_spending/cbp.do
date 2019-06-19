
clear
set mem 1000m
set more off




clear
insheet using ./dta/fipsCountiesEmploymentManufacturing.txt
rename fipscountycode fipsCountyCode
rename fipsstatecode  fipsStateCode
rename employment manuf_denom
rename employmentmanufacturing manuf_numer
sort fipsCountyCode fipsStateCode
save ./dta/manufacturing_data.dta, replace




**********
* Create full CBP data (merged from different sources)
**********
*use ../cbp/cbp
*keep fipsStateCode fipsCountyCode year payroll num_employees num_establishments
*append using ../cbp9805/cbp9805
*sort fipsStateCode fipsCountyCode year
*append using ../countydatabooks/cbp_pre77_final.dta
*keep fipsStateCode fipsCountyCode year payroll num_employees num_establishments
*sort fipsStateCode fipsCountyCode year
*save ./dta/cbp7305, replace





**********
* Create OIL FIELDS data
**********
clear
use ./texasoil/oilfields.dta

bys field field_code: keep if _n == 1

gen tot_size = cumprod + reserves
egen all_size = sum(tot_size)
summ all_size

preserve
keep if county == "OFFSHORE-STATE"
drop all_size
egen all_size = sum(tot_size)
summ all_size
restore

preserve

gen fipsStateCode = .
replace fipsStateCode = 1  if state == "Alabama"
replace fipsStateCode = 2  if state == "Alaska"
replace fipsStateCode = 5  if state == "Arkansas"
replace fipsStateCode = 6  if state == "California"
replace fipsStateCode = 8  if state == "Colorado"
replace fipsStateCode = 12 if state == "Florida"
replace fipsStateCode = 17 if state == "Illinois"
replace fipsStateCode = 20 if state == "Kansas"
replace fipsStateCode = 22 if state == "Louisiana"
replace fipsStateCode = 28 if state == "Mississippi"
replace fipsStateCode = 30 if state == "Montana"
replace fipsStateCode = 35 if state == "New Mexico"
replace fipsStateCode = 38 if state == "North Dakota"
replace fipsStateCode = 40 if state == "Oklahoma"
replace fipsStateCode = 48 if state == "Texas"
replace fipsStateCode = 49 if state == "Utah"
replace fipsStateCode = 56 if state == "Wyoming"

gen south = 0
** AL, AR, DC, DE, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN, TX, VA, WV
foreach s of numlist 1 5 10 11 12 13 21 22 24 28 37 40 45 47 48 51 54 {
 replace south = 1 if fipsStateCode == `s'
}
keep if south == 1
drop all_size
egen all_size = sum(tot_size)
summ all_size
restore





clear
use ./texasoil/oilfields.dta

count 
count  if field_disc_yr != yeardiscovered
count  if field_disc_yr != yeardiscovered & (yeardiscovered >= 1970 | field_disc_yr > =1970)
list county st field field_disc_yr yeardiscovered if field_disc_yr != yeardiscovered & (yeardiscovered >= 1970 | field_disc_yr >= 1970)

**drop if yeardiscovered > 1970

gen fipsStateCode = .
replace fipsStateCode = 1  if state == "Alabama"
replace fipsStateCode = 2  if state == "Alaska"
replace fipsStateCode = 5  if state == "Arkansas"
replace fipsStateCode = 6  if state == "California"
replace fipsStateCode = 8  if state == "Colorado"
replace fipsStateCode = 12 if state == "Florida"
replace fipsStateCode = 17 if state == "Illinois"
replace fipsStateCode = 20 if state == "Kansas"
replace fipsStateCode = 22 if state == "Louisiana"
replace fipsStateCode = 28 if state == "Mississippi"
replace fipsStateCode = 30 if state == "Montana"
replace fipsStateCode = 35 if state == "New Mexico"
replace fipsStateCode = 38 if state == "North Dakota"
replace fipsStateCode = 40 if state == "Oklahoma"
replace fipsStateCode = 48 if state == "Texas"
replace fipsStateCode = 49 if state == "Utah"
replace fipsStateCode = 56 if state == "Wyoming"

replace cumprod = 198416 if field == "Richfield"

assert fipsStateCode != .
rename county_code fipsCountyCode
sort fipsStateCode fipsCountyCode

gen tot_size_temp = cumprod + reserves
assert(tot_size_temp > 90000)

bys field_code field: gen num_counties = _N
gen well = 1 / num_counties
replace tot_size_temp = tot_size_temp / num_counties
tab well

bys fipsStateCode fipsCountyCode: egen num_wells = sum(well)
bys fipsStateCode fipsCountyCode: egen tot_size = sum(tot_size_temp)
bys fipsStateCode fipsCountyCode: keep if _n == 1
sort fipsStateCode fipsCountyCode
drop tot_size_temp

save ./tmp/oilfields, replace






***************
** prepare ALASKA mining share data
**  (from Stephanie)
***************

clear
insheet using ./dta/miningshare.txt
rename fipsstatecode fipsStateCode
rename fipscountycode fipsCountyCode
sort fipsStateCode fipsCountyCode
save ./dta/miningshareAlaska.dta, replace

***************






***************
** prepare 1970 extract (Adams ICPSR)
***************

clear
set mem 3000m

use ./dta/1970extract

capture drop _merge
sort fipsStateCode fipsCountyCode 
merge fipsStateCode fipsCountyCode using ./dta/County_employment_in_mining
tab _merge
drop _merge

capture drop _merge
sort fipsStateCode fipsCountyCode 
merge fipsStateCode fipsCountyCode using ./dta/miningshareAlaska, update replace
tab _merge
drop _merge





***************
** MANUALLY DEAL WITH ALASKA
**
** see Appendix K in 1980 county book doc
** basically this merges 1970 counties into
** 1980 counties for comparability
***************

rename fipsCountyCode fipsCountyCode_old
gen fipsCountyCode = fipsCountyCode_old

replace fipsCountyCode = 122 if fipsCountyCode == 120 & fipsStateCode == 2
replace fipsCountyCode = 122 if fipsCountyCode == 210 & fipsStateCode == 2
gsort fipsStateCode fipsCountyCode fipsCountyCode_old
list if fipsStateCode == 2 & (fipsCountyCode == 122)
replace meanHouseholdWageInc1970 = (totalPersons1970/(totalPersons1970 + totalPersons1970[_n+1]))* meanHouseholdWageInc1970 + (totalPersons1970[_n+1]/(totalPersons1970 + totalPersons1970[_n+1]))* meanHouseholdWageInc1970[_n+1] if fipsCountyCode_old == 120 & fipsStateCode == 2
replace pctFamInc25kPlus1970 = (totalPersons1970/(totalPersons1970 + totalPersons1970[_n+1]))* pctFamInc25kPlus1970 + (totalPersons1970[_n+1]/(totalPersons1970 + totalPersons1970[_n+1]))* pctFamInc25kPlus1970[_n+1] if fipsCountyCode_old == 120 & fipsStateCode == 2
replace min_emp1970 = min_emp1970 + min_emp1970[_n + 1] if fipsCountyCode_old == 120
replace totalPersons1970 = totalPersons1970 + totalPersons1970[_n + 1] if fipsCountyCode_old == 120
drop if fipsCountyCode_old == 210
gsort fipsStateCode fipsCountyCode fipsCountyCode_old
list if fipsStateCode == 2 & (fipsCountyCode == 122)

replace fipsCountyCode = 185 if fipsCountyCode == 040

replace fipsCountyCode = 201 if fipsCountyCode == 200 & fipsStateCode == 2
replace fipsCountyCode = 201 if fipsCountyCode == 190 & fipsStateCode == 2
gsort fipsStateCode fipsCountyCode fipsCountyCode_old
list if fipsStateCode == 2 & (fipsCountyCode == 201)
replace meanHouseholdWageInc1970 = (totalPersons1970/(totalPersons1970 + totalPersons1970[_n+1]))* meanHouseholdWageInc1970 + (totalPersons1970[_n+1]/(totalPersons1970 + totalPersons1970[_n+1]))* meanHouseholdWageInc1970[_n+1] if fipsCountyCode_old == 190 & fipsStateCode == 2
replace pctFamInc25kPlus1970 = (totalPersons1970/(totalPersons1970 + totalPersons1970[_n+1]))* pctFamInc25kPlus1970 + (totalPersons1970[_n+1]/(totalPersons1970 + totalPersons1970[_n+1]))* pctFamInc25kPlus1970[_n+1] if fipsCountyCode_old == 190 & fipsStateCode == 2
replace min_emp1970 = min_emp1970 + min_emp1970[_n + 1] if fipsCountyCode_old == 190
replace totalPersons1970 = totalPersons1970 + totalPersons1970[_n + 1] if fipsCountyCode_old == 190
drop if fipsCountyCode_old == 200
gsort fipsStateCode fipsCountyCode fipsCountyCode_old
list if fipsStateCode == 2 & (fipsCountyCode == 201)

replace fipsCountyCode = 231 if fipsCountyCode == 030 & fipsStateCode == 2
replace fipsCountyCode = 231 if fipsCountyCode == 230 & fipsStateCode == 2
gsort fipsStateCode fipsCountyCode fipsCountyCode_old
list if fipsStateCode == 2 & (fipsCountyCode == 231)
replace meanHouseholdWageInc1970 = (totalPersons1970/(totalPersons1970 + totalPersons1970[_n+1]))* meanHouseholdWageInc1970 + (totalPersons1970[_n+1]/(totalPersons1970 + totalPersons1970[_n+1]))* meanHouseholdWageInc1970[_n+1] if fipsCountyCode_old == 030 & fipsStateCode == 2
replace pctFamInc25kPlus1970 = (totalPersons1970/(totalPersons1970 + totalPersons1970[_n+1]))* pctFamInc25kPlus1970 + (totalPersons1970[_n+1]/(totalPersons1970 + totalPersons1970[_n+1]))* pctFamInc25kPlus1970[_n+1] if fipsCountyCode_old == 030 & fipsStateCode == 2
replace min_emp1970 = min_emp1970 + min_emp1970[_n + 1] if fipsCountyCode_old == 030
replace totalPersons1970 = totalPersons1970 + totalPersons1970[_n + 1] if fipsCountyCode_old == 030
drop if fipsCountyCode_old == 230
gsort fipsStateCode fipsCountyCode fipsCountyCode_old
list if fipsStateCode == 2 & (fipsCountyCode == 231)

replace fipsCountyCode = 261 if fipsCountyCode == 080 & fipsStateCode == 2
replace fipsCountyCode = 261 if fipsCountyCode == 260 & fipsStateCode == 2
gsort fipsStateCode fipsCountyCode fipsCountyCode_old
list if fipsStateCode == 2 & (fipsCountyCode == 261)
replace meanHouseholdWageInc1970 = (totalPersons1970/(totalPersons1970 + totalPersons1970[_n+1]))* meanHouseholdWageInc1970 + (totalPersons1970[_n+1]/(totalPersons1970 + totalPersons1970[_n+1]))* meanHouseholdWageInc1970[_n+1] if fipsCountyCode_old == 080 & fipsStateCode == 2
replace pctFamInc25kPlus1970 = (totalPersons1970/(totalPersons1970 + totalPersons1970[_n+1]))* pctFamInc25kPlus1970 + (totalPersons1970[_n+1]/(totalPersons1970 + totalPersons1970[_n+1]))* pctFamInc25kPlus1970[_n+1] if fipsCountyCode_old == 080 & fipsStateCode == 2
replace min_emp1970 = min_emp1970 + min_emp1970[_n + 1] if fipsCountyCode_old == 080
replace totalPersons1970 = totalPersons1970 + totalPersons1970[_n + 1] if fipsCountyCode_old == 080
drop if fipsCountyCode_old == 260
gsort fipsStateCode fipsCountyCode fipsCountyCode_old
list if fipsStateCode == 2 & (fipsCountyCode == 261)

replace fipsCountyCode = 290 if fipsCountyCode == 250 & fipsStateCode == 2
replace fipsCountyCode = 290 if fipsCountyCode == 290 & fipsStateCode == 2
gsort fipsStateCode fipsCountyCode fipsCountyCode_old
list if fipsStateCode == 2 & (fipsCountyCode == 290)
replace meanHouseholdWageInc1970 = (totalPersons1970/(totalPersons1970 + totalPersons1970[_n+1]))* meanHouseholdWageInc1970 + (totalPersons1970[_n+1]/(totalPersons1970 + totalPersons1970[_n+1]))* meanHouseholdWageInc1970[_n+1] if fipsCountyCode_old == 250 & fipsStateCode == 2
replace pctFamInc25kPlus1970 = (totalPersons1970/(totalPersons1970 + totalPersons1970[_n+1]))* pctFamInc25kPlus1970 + (totalPersons1970[_n+1]/(totalPersons1970 + totalPersons1970[_n+1]))* pctFamInc25kPlus1970[_n+1] if fipsCountyCode_old == 250 & fipsStateCode == 2
replace min_emp1970 = min_emp1970 + min_emp1970[_n + 1] if fipsCountyCode_old == 250
replace totalPersons1970 = totalPersons1970 + totalPersons1970[_n + 1] if fipsCountyCode_old == 250
drop if fipsCountyCode_old == 290
gsort fipsStateCode fipsCountyCode fipsCountyCode_old
list if fipsStateCode == 2 & (fipsCountyCode == 290)


** MERGE 1980 data
sort fipsStateCode fipsCountyCode 
merge fipsStateCode fipsCountyCode using ./dta/1980extract
tab _merge
list fipsStateCode fipsCountyCode if _merge != 3
keep if _merge == 3
drop _merge

sort fipsStateCode fipsCountyCode 
list fipsStateCode fipsCountyCode min_emp1970 if fipsStateCode == 2


** MERGE 1990 data
sort fipsStateCode fipsCountyCode 
merge fipsStateCode fipsCountyCode using ./dta/1990extract
tab _merge
list fipsStateCode fipsCountyCode _merge if _merge != 3
keep if _merge == 3 | _merge == 1
drop _merge





capture drop _merge
sort fipsStateCode fipsCountyCode
merge fipsStateCode fipsCountyCode using ./dta/cbp7305
drop if fipsCountyCode == 999
gen stateAndCounty = string(fipsStateCode) + "_" + string(fipsCountyCode)
tab _merge
keep if _merge == 3



bys stateAndCounty year: gen duplicated = _n
tab year duplicated
drop if duplicated > 1
tab fipsStateCode year if year > 1995



capture drop _merge
sort fipsStateCode fipsCountyCode 
merge fipsStateCode fipsCountyCode using ./tmp/oilfields
tab _merge
list if _merge == 2

** where are these areas in Alaska?
tab fipsCountyCode _merge if fipsStateCode == 2

keep if _merge != 2
replace tot_size = 0 if tot_size == .
replace num_wells = 0 if num_wells == .
summ min_emp1970, detail
summ totalPersons1970, detail
drop if payroll == 0

capture drop flag duplicated _merge siccode total* pct*

gen south = 1 if (min_emp1970 != . & fipsStateCode != 2)
replace min_emp1970 = 0 if min_emp1970 == .







***************
** AGGREGATE data
***************

**
** "true" ESR can cross state line, we break it up for ESR
**

** ESRs 1-121

gen trueESR = econSubRegion
replace econSubRegion = 1000 * fipsStateCode + econSubRegion
replace stateEconArea = 100 * fipsStateCode + stateEconArea


capture drop _merge
sort fipsStateCode
capture drop state
merge fipsStateCode using ./dta/fipsByCode, uniqusing
gen stateName = state
gen areaName = state
tab _merge
keep if _merge == 3

drop if missing(payroll)

preserve
bys fipsStateCode fipsCountyCode: keep if _n == 1
keep fipsCountyCode stateEconArea econSubRegion fipsStateCode personsEmployed1970
sort fipsStateCode fipsCountyCode
save ./dta/state_esr_sea_county_xwalk.dta, replace
restore

rename min_emp1970 min_emp1970_county
rename personsEmployed1970 personsEmployed1970_county
rename tot_size tot_size_county
rename payroll payroll_county
rename num_employees num_employees_county





**
* Fix payroll outliers that were mistakenly hand-entered
**

** fix hand-entered error
list payroll_county if econSubRegion == 1043 & fipsCountyCode == 73 & year == 1970
count if econSubRegion == 1043 & fipsStateCode == 1 & fipsCountyCode == 73 & year == 1970
assert(r(N) == 1)
replace payroll_county = 330610 * 4 if econSubRegion == 1043 & fipsCountyCode == 73 & year == 1970

** fix obvious errors in electronic data
count if econSubRegion == 22079 & fipsStateCode == 22 & fipsCountyCode == 85 & year == 1986
assert(r(N) == 1)
sort fipsStateCode fipsCountyCode year
replace payroll_county = (payroll_county[_n - 1] + payroll_county[_n + 1])/2.0  ///
 if (econSubRegion == 22079 & fipsCountyCode == 85 & year == 1986) & ///
    (year[_n - 1] == 1985 & year[_n + 1] == 1987)






*************
* Merge in service sector wages
*************
sort fipsStateCode fipsCountyCode year
capture drop _merge
merge fipsStateCode fipsCountyCode year using ./dta/cbp_service_wages_wide.dta, uniqusing uniqmaster
tab _merge, missing
drop if _merge == 2 & fipsCountyCode == 999 & fipsStateCode != 11
list fipsStateCode fipsCountyCode year if _merge == 2
tab year _merge, missing
tab fipsStateCode if _merge == 2
drop if _merge == 2
drop _merge
drop num_ests_* num_emps_*




foreach var of varlist payroll_* {
 if ("`var'" != "payroll_county") {
  di "renaming `var' to `var'_county ..."
  rename `var' `var'_county
 }
}

foreach var of varlist payroll_*county {
  local new_var = subinstr("`var'", "_county", "", .)
  bys stateEconArea year: egen `new_var'_sea   = sum(`var')
  bys econSubRegion year: egen `new_var'_esr   = sum(`var')
  bys trueESR year: egen `new_var'_trueESR   = sum(`var')
  bys fipsStateCode year: egen `new_var'_state = sum(`var')
}



********
** merge in manufacturing data
********
sort fipsCountyCode fipsStateCode
capture drop _merge
merge fipsCountyCode fipsStateCode using ./dta/manufacturing_data, uniqusing
tab _merge, missing
list fipsCountyCode fipsStateCode south if _merge == 1
drop if _merge == 2
rename manuf_denom manuf_denom_county
rename manuf_numer manuf_numer_county



local variables = " min_emp1970 personsEmployed1970 tot_size num_employees manuf_denom manuf_numer"
foreach var of local variables {
  bys stateEconArea year: egen `var'_sea = sum(`var'_county)
  bys econSubRegion year: egen `var'_esr = sum(`var'_county)
  bys econSubRegion year: egen `var'_trueESR = sum(`var'_county)
  bys fipsStateCode year: egen `var'_state = sum(`var'_county)
}


local geos = "county sea esr trueESR state"
foreach geo of local geos {
 gen miningShare1970_`geo' = min_emp1970_`geo' / personsEmployed1970_`geo'
 gen manufShare1970_`geo' = manuf_numer_`geo' / manuf_denom_`geo'
}

assert payroll_sea != . & payroll_sea > 0
assert payroll_esr != . & payroll_esr > 0
assert payroll_trueESR != . & payroll_trueESR > 0

replace payroll_sea   = 1000*payroll_sea
replace payroll_esr   = 1000*payroll_esr
replace payroll_trueESR   = 1000*payroll_trueESR
replace payroll_state = 1000*payroll_state


preserve
bys fipsCountyCode fipsStateCode year: keep if _n == 1
sort fipsCountyCode fipsStateCode year
keep fipsStateCode econSubRegion stateEconArea fipsCountyCode payroll* num_employees* year 
list in 1/20
save ./dta/cbp_payroll.dta, replace
restore

bys year: summ payroll*

sort fipsCountyCode fipsStateCode year
by fipsCountyCode fipsStateCode: keep if _n == 1

sort fipsStateCode year
by fipsStateCode: replace miningShare1970_state = miningShare1970_state[1]
sort econSubRegion year
by econSubRegion: replace miningShare1970_esr   = miningShare1970_esr[1]
sort trueESR year
by trueESR: replace miningShare1970_trueESR   = miningShare1970_trueESR[1]
sort stateEconArea year
by stateEconArea: replace miningShare1970_sea = miningShare1970_sea[1]



sort fipsStateCode year
by fipsStateCode: gen diff = miningShare1970_state - miningShare1970_state[_n - 1]
count if diff != 0
count
assert diff == 0 | missing(diff)

sort fipsCountyCode fipsStateCode 
keep fipsStateCode trueESR econSubRegion stateEconArea fipsCountyCode miningShare1970* tot_size* personsE* manufShare1970*

save ./dta/cbp_mining.dta, replace

tab fipsStateCode if miningShare1970_state == .
tab fipsStateCode if miningShare1970_esr   == .
tab fipsStateCode if miningShare1970_trueESR   == .

exit


















