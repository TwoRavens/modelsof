
**
** do prepare_aha_cbp esr|state
**


clear
clear mata
set mem 1000m
set more off




clear
infix using ./dta/fips.dct
rename fips fipsStateCode
sort stname
save ./dta/fips.dta, replace





clear
insheet using ./dta/state_GSP.txt, names
reshape long gsp, i(stname) j(year)
sort stname
merge stname using ./dta/fips, uniqusing
list if _merge != 3
keep if _merge == 3
drop _merge
sort fipsStateCode year
save ./dta/state_GSP.dta, replace






** http://www.census.gov/epcd/naics/NSIC6.HTM#S58
** http://www.bea.gov/regional/pdf/gsp/GDPState.pdf#page=25
** http://www.restaurant.org/pdfs/research/state/alaska.pdf
** http://www.bea.gov/regional/gsp/default.cfm?series=SIC
** http://www.bea.gov/regional/gsp/readmeSIC.cfm#DataAvailability

**
** 26 - food and kindred products
** 58 - hotels and other lodging places
** 59 - personal services
** 63 - motion pictures
** 64 - amusement and recreation services
** 65 - health services
** 66 - legal services
** 67 - educational services
** 68 - social services
** 70 - other services
** 71 - private households
**
clear
**insheet using gdpbystate_63_97.csv, comma names
insheet using ./dta/compensation_bystate_63_97.csv, comma names
desc, full
rename fips fipsStateCode
keep if industry_code == 26
reshape long gdp, i(fipsStateCode) j(year)
rename gdp gdp_food
keep fipsStateCode year gdp_food
sort fipsStateCode year
save ./dta/state_GDP.dta, replace

foreach ind of numlist 58 59 63 64 65 66 67 68 70 71 {
 if (`ind' == 58) {
  local ind_str = "hotels"
 }
 if (`ind' == 59) {
  local ind_str = "pers_servs"
 }
 if (`ind' == 63) {
  local ind_str = "motion_picts"
 }
 if (`ind' == 64) {
  local ind_str = "amuse_servs"
 }
 if (`ind' == 65) {
  local ind_str = "health_servs"
 }
 if (`ind' == 66) {
  local ind_str = "legal_servs"
 }
 if (`ind' == 67) {
  local ind_str = "educ_servs"
 }
 if (`ind' == 68) {
  local ind_str = "social_servs"
 }
 if (`ind' == 70) {
  local ind_str = "other_servs"
 }
 if (`ind' == 71) {
  local ind_str = "priv_hhlds"
 }

 clear
 **insheet using gdpbystate_63_97.csv, comma names
 insheet using ./dta/compensation_bystate_63_97.csv, comma names 
 desc, full
 rename fips fipsStateCode
 keep if industry_code == `ind'
 reshape long gdp, i(fipsStateCode) j(year)
 rename gdp gdp_`ind_str'
 keep fipsStateCode year gdp_`ind_str'
 sort fipsStateCode year
 capture drop _merge
 merge fipsStateCode year using ./dta/state_GDP, uniqusing uniqmaster
 assert _merge == 3
 drop _merge
 sort fipsStateCode year
 save ./dta/state_GDP.dta, replace
}




clear
use ./dta/fips.dta
sort state
save ./dta/fips.dta, replace

clear
use ./dta/state_insurance
keep if year == 1974
drop year
summ pct_priv_ins
replace state = "NE" if state == "NB"
sort state
merge state using ./dta/fips, uniqusing uniqmaster
tab _merge
keep if _merge == 3
drop _merge
drop stname state
sort fipsStateCode
save ./tmp/state_insurance.dta, replace





/**
 * from PDFs
 **/
clear
use ./dta/state_population
sort fipsStateCode year
rename population_cps population
save ./tmp/state_population, replace

clear
use ./dta/AHA_esr_fromJames_weighted_pop_v5
desc
sort econSubRegion year
save ./tmp/population, replace

clear
use ./dta/AHA_trueESR_fromJames_weighted_pop_v5
desc
sort trueESR year
save ./tmp/trueESR_population, replace

clear
use ./dta/AHA_st_fromJames_weighted_pop_v5
desc
sort fipsStateCode year
save ./tmp/state_population, replace

clear
use ./dta/AHA_sea_fromJames_weighted_pop_v5
desc
sort stateEconArea year
save ./tmp/sea_population, replace

clear
use ./dta/AHA_county_fromJames_weighted_pop_v5
desc
sort fipsStateCountyCode year
save ./tmp/county_population, replace




clear
use ./dta/fips
sort stname
save ./dta/fips, replace
clear
insheet using ./dta/regions.txt
sort stname
merge stname using ./dta/fips, uniqusing uniqmaster
tab _merge
list if _merge != 3
keep if _merge == 3
drop _merge
keep fipsStateCode region
sort fipsStateCode
save ./dta/fipsToRegion.dta, replace





***********
* merge in LPN/RN data for 70's
***********
clear
use ./dta/aha_personnel
sort exptot
replace exptot = round(exptot, 1000)
replace paytot = round(paytot, 1000)
desc exptot paytot admtot
list exptot paytot admtot if stcd == 13 & year == 1972
desc
rename id id_dct
capture drop fte
rename mcounty fipsCountyCode
rename los short_term
replace short_term = 0 if short_term > 1 & short_term < .
capture drop serv cntrl
bys exptot admtot paytot ipdtot bdtot ft* pt* stcd year short_term fipsCountyCode: keep if _n == 1
bys exptot stcd year short_term fipsCountyCode: gen myN = _N
bys exptot stcd year short_term fipsCountyCode: gen myn = _n
keep if myn == 1
tab myN, missing
drop admtot paytot ipdtot bdtot
sort stcd year exptot short_term fipsCountyCode
save ./tmp/aha_personnel.dta, replace





**************
* NOTE: This file is created from aha.do and requires access to AHA data
**************
use ./AHA/myaha.dta





**
* create dummy fo private: non-gov't for profit + non-gov't not-for-profit
**
gen private = 0
replace private = 1 if cntrl == 1  & year <= 1977 
replace private = 1 if cntrl == 2  & year <= 1977
replace private = 1 if cntrl >= 20 & cntrl < 40 & year > 1977

**
** Tabulate missing county codes
**
tab year if fipsCountyCode == .
drop if fipsCountyCode == .

sort stcd id year
summ exptot
local N = r(N)
local max = r(max)
local mean = r(mean)

foreach pers of varlist fttot pttot {
  replace `pers' = . if year == 1970 | year == 1972 | year == 1974 | year == 1976 | year == 1978
}

summ exptot
assert `N' == r(N)
assert `max' == r(max)
assert abs(`mean' - r(mean)) < 0.000001

** AL, AR, DC, DE, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN, TX, VA, WV
gen south = 0
foreach s of numlist 1 5 10 11 12 13 21 22 24 28 37 40 45 47 48 51 54 {
 replace south = 1 if fipsStateCode == `s'
}


*************
** Merge in FT/PT LPN/RN
*************
di "Starting..."
bys year: summ exptot
gen exptot_backup = exptot
replace exptot = round(exptot, 1000) if year == 1978
sort stcd year exptot short_term fipsCountyCode
merge  stcd year exptot short_term fipsCountyCode using ./tmp/aha_personnel, uniqusing update 
tab year _merge
tab year _merge if south == 1
sort stcd year exptot short_term fipsCountyCode
** list stcd year exptot short_term fipsCountyCode exptot paytot _merge if _merge != 3 & year == 1978
drop if _merge == 2
di "AFTER..."
bys year: summ exptot
replace  ftelpn = 0.5*ptlpn + ftlpn if year <= 1978
replace  ftern  = 0.5*ptrn + ftrn   if year <= 1978
replace exptot = exptot_backup if year == 1978
drop _merge
di "DONE!"
***********
***********




tab year serv, missing
tab year cntrl,missing


****
** drop Alaska, Virginia for now
** NOTE: Could consider dropping DC, HI, as well
****
drop if fipsStateCode == 2
drop if fipsStateCode == 51
*drop if fipsStateCode == 11
*drop if fipsStateCode == 15

**
* NOTE: DC has only one county.  make it always "1" (*not* 999)
**
replace fipsCountyCode = 1 if fipsCountyCode == 999 & fipsStateCode == 11







********
** merge in mining data
********
sort fipsCountyCode fipsStateCode 
merge fipsCountyCode fipsStateCode using ./dta/cbp_mining.dta, uniqusing
tab _merge
tab year if _merge == 1, missing

tab fipsStateCode if _merge == 1, missing
tab fipsCountyCode _merge if fipsStateCode == 11 

assert fipsCountyCode < 1000 | missing(fipsCountyCode)
gen fipsStateCountyCode = 1000*fipsStateCode + fipsCountyCode
tab fipsStateCountyCode if _merge == 1 & fipsCountyCode != 999

tab year, missing
tab fipsStateCode if miningShare1970_state == .
keep if _merge == 3



local var = "stateEconArea"
if ("`1'" == "state") {
 replace stateEconArea = fipsStateCode
}
if ("`1'" == "esr") {
 replace stateEconArea = econSubRegion
}
if ("`1'" == "trueESR") {
 replace stateEconArea = trueESR
}
if ("`1'" == "sea") {
 replace stateEconArea = stateEconArea
}
if ("`1'" == "county") {
 replace stateEconArea = fipsStateCountyCode
}





****************
** Drop outlier counties (based on AHA expenditure data)
****************

**
** These counties drive sharp jumps in 1976 in respective ESRs
**
** Lawrence county, KY (ESR = 21031)
drop if fipsStateCode == 21 & fipsCountyCode == 127

** Vernon, LA (ESR = 22079)
drop if fipsStateCode == 22 & fipsCountyCode == 115



**
** Baltimore, MD (ESR = 24019); oscillates b/w 5/35/5/35 hospitals b/w 1977 and 1980
**
drop if fipsStateCode == 24 & fipsCountyCode == 5

**
** Pulaski, KY (ESR = 21044); Missing data for 1976 and 1977
**
drop if fipsStateCode == 21 & fipsCountyCode == 199




gen grp3 = floor( (year - 1966) / 3 ) 
gen grp2 = floor( (year - 1966) / 2 ) 
tab year grp2
tab year grp3



 bys stateEconArea year: gen num_hosp = _N

 replace short_term = 1 if missing(short_term)
 tab cntrl, missing

 bys stateEconArea year: egen num_hosp_nonfed = sum( cntrl < 40 & serv == 10 & short_term == 1 )
 bys stateEconArea year: egen num_hosp_onlynf = sum( cntrl < 40 )
 bys stateEconArea year: egen num_hosp_private = sum(private)

 foreach var in exptot paytot admtot ipdtot bdtot npaydpr npayint fte ftern ftelpn {
   rename `var' `var'_micro
   bys stateEconArea year: egen `var' = sum(`var'_micro) 
   bys stateEconArea grp2: egen `var'2 = mean(`var')
   bys stateEconArea grp3: egen `var'3 = mean(`var')

   bys stateEconArea year: egen `var'_nonfed = sum(`var'_micro * (short_term == 1) * (cntrl < 40) * (serv == 10) )
   bys stateEconArea year: egen `var'_private = sum(`var'_micro * (private == 1))
   bys stateEconArea year: egen `var'_onlynf = sum(`var'_micro * (cntrl < 40)  )
 } 



sort stateEconArea year fipsCountyCode miningShare1970* 
by stateEconArea year: keep if _n == 1



if ("`1'" == "state" | "`1'" == "esr") {

**
* merge in technology counts(!)
**
** NOTE: check the _merge != 3 observations
**
sort econSubRegion year
capture drop _merge 
merge econSubRegion year using ./dta/aggregate_tech_by_esr.dta, uniqusing uniqmaster
tab _merge
tab year _merge
keep if _merge == 1 | _merge == 3


rename esr_tech_max tech_max
rename esr_tech_sum tech_sum
gen  exp_tech_max = tech_max
gen  exp_tech_sum = tech_sum
**gen double exp_tech_max = exp(tech_max)
**gen double exp_tech_sum = exp(tech_sum)

foreach type in st gen onlynf st_gen st_nf gen_nf nonfed {
 sort econSubRegion year
 capture drop _merge 
 merge econSubRegion year using ./dta/aggregate_tech_by_esr_`type'.dta, uniqusing uniqmaster
 tab _merge
 tab year _merge
 keep if _merge == 1 | _merge == 3
}

rename esr_tech_max_nonfed tech_max_nonfed
rename esr_tech_sum_nonfed tech_sum_nonfed
gen exp_tech_max_nonfed = tech_max_nonfed
gen exp_tech_sum_nonfed = tech_sum_nonfed
*gen exp_tech_max_nonfed = exp(tech_max_nonfed)
*gen exp_tech_sum_nonfed = exp(tech_sum_nonfed)

foreach var in tech_sum tech_max exp_tech_sum exp_tech_max {
  bys stateEconArea grp2: egen `var'2 = mean(`var')
  bys stateEconArea grp3: egen `var'3 = mean(`var')
} 

}

sort stateEconArea grp2 year
by stateEconArea grp2: gen use2 = (_n == 1)
sort stateEconArea grp3 year
by stateEconArea grp3: gen use3 = (_n == 1)



********
** merge in (CBP) payroll data
********
capture drop _merge
sort fipsCountyCode fipsStateCode year 
merge fipsCountyCode fipsStateCode year using ./dta/cbp_payroll, uniqusing
tab _merge
tab year if _merge == 1, missing
drop if _merge == 2




**
* drop all non-matching counties for years we don't have payroll data
*
list fipsStateCode fipsCountyCode year if _merge == 1
drop if _merge == 1
summ *tot
capture drop _merge



**
* merge in OIL prices
**
capture drop _merge
sort year
merge year using ./dta/oilprice
tab _merge 
tab year _merge
keep if _merge == 3
drop _merge

rename miningShare1970_`1' miningShare1970
rename manufShare1970_`1' manufShare1970
rename personsEmployed1970_`1' personsEmployed1970
rename tot_size_`1' tot_size

rename payroll_`1' payroll
foreach var of varlist payroll_*_`1' {
 local new_var = subinstr("`var'", "_`1'", "", .)
 di "renaming `var' to `new_var' ..."
 rename `var' `new_var'
}

bys stateEconArea grp2: egen payroll2 = mean(payroll)
bys stateEconArea grp3: egen payroll3 = mean(payroll)
summ payroll, det
summ payroll, meanonly
local mean = r(mean)
replace payroll = `mean' if payroll == 0
replace payroll2 = `mean' if payroll2 == 0
replace payroll3 = `mean' if payroll3 == 0

if ("`1'" == "esr") {
 sort econSubRegion year
 merge econSubRegion year using ./tmp/population
}
if ("`1'" == "trueESR") {
 sort trueESR year
 merge trueESR year using ./tmp/trueESR_population
}
if ("`1'" == "state") {
 sort fipsStateCode year
 merge fipsStateCode year using ./tmp/state_population
}
if ("`1'" == "sea") {
 sort stateEconArea year
 merge stateEconArea year using ./tmp/sea_population
}
if ("`1'" == "county") {
 sort fipsStateCountyCode year
 merge fipsStateCountyCode year using ./tmp/county_population
}

tab year _merge, missing
keep if _merge != 2
drop _merge
rename weighted_pop  population
rename pop pop_unweighted

rename age_group1 p_65plus
rename age_group2 p_55plus
rename age_group3 p_45plus
rename age_group4 p_45to54
rename age_group5 p_55to64
rename age_group6 p_45to64
rename age_group7 p_u65
rename age_group8 p_u55
rename age_group9 p_u45

foreach var of varlist p_* {
 gen log_`var'  = log(`var')
}

gen log_population = log(population)
gen log_pop_unweighted = log(pop_unweighted)
rename num_employees_`1' num_employees
gen log_num_employees = log(num_employees)
gen log_num_hosp = log(num_hosp)
gen log_num_hosp_nonfed = log(num_hosp_nonfed)

foreach var of varlist p_*plus p_*4 p_*5 population pop_unweighted num_employees num_hosp {
 bys stateEconArea grp2: egen `var'2 = mean(`var')
 bys stateEconArea grp3: egen `var'3 = mean(`var')
 gen log_`var'3 = log(`var'3)
 gen log_`var'_raw = log(`var')
 gen log_`var'_percap = log(`var')
}
foreach var of varlist p_*plus p_*4 p_*5 population pop_unweighted num_employees {
 gen log_`var'_nonfed = log(`var')
}

gen log_payroll = log(payroll / population)
gen log_payroll2 = log(payroll2 / population2)
gen log_payroll3 = log(payroll3 / population3)


 **
 ** We don't want to keep these variables around
 **
 capture drop payroll*county
 capture drop payroll*sea
 capture drop payroll*esr
 capture drop payroll*trueESR
 capture drop payroll*state

 foreach var of varlist payroll_* {
  gen log_`var' = log(`var' / pop_unweighted)
 }
 desc log_*, full

 gen log_payroll_raw = log(payroll)
 gen log_payroll_percap = log(payroll / pop_unweighted)
 foreach var of varlist exptot paytot admtot ipdtot bdtot npaydpr npayint fte ftelpn ftern {
   gen log_`var'_raw = log(`var')
   gen log_`var' = log(`var' / population)
   gen log_`var'2 = log(`var'2 / population2)
   gen log_`var'3 = log(`var'3 / population3)
   gen log_`var'_percap = log(`var' / pop_unweighted)
   gen log_`var'_nonfed = log(`var'_nonfed / population)
 }


if ("`1'" == "state" | "`1'" == "esr") {
 foreach var in tech_sum tech_max {
  gen log_`var'  = log(`var')
  gen log_`var'3 = log(`var'3)
  gen log_`var'_percap = log(`var')
  gen log_`var'_nonfed = log(`var'_nonfed)
 }
}

 gen exp_num_hosp = num_hosp
 gen exp_num_hosp3 = num_hosp3
 gen exp_num_hosp_nonfed = num_hosp_nonfed
 foreach var in exp_num_hosp {
  gen log_`var' = `var'
  gen log_`var'3 = `var'3
  gen log_`var'_percap = `var'
  gen log_`var'_nonfed = `var'_nonfed

  gen log_`var'_raw  = `var'
  gen log_`var'_raw3 = `var'3
  gen log_`var'_raw_percap = `var'
  gen log_`var'_raw_nonfed = `var'_nonfed
 }

if ("`1'" == "state" | "`1'" == "esr") {
 foreach var in exp_tech_sum exp_tech_max  {
  gen log_`var'  = `var'
  gen log_`var'3 = `var'3
  gen log_`var'_percap = `var' / (pop_unweighted / 1e6)
  gen log_`var'_nonfed = `var'_nonfed
 }
}



  

gen oilprice_level = oilprice
replace oilprice = log(oilprice)

summ oilprice, meanonly
replace oilprice = oilprice - r(mean)
gen miningShare1970_orig = miningShare1970
summ miningShare1970, meanonly
replace miningShare1970 = miningShare1970 - r(mean)  

replace tot_size = tot_size / 1e9
gen tot_size_orig = tot_size
gen miningShareXoilprice   = miningShare1970 * (tot_size > 0) * log(oilprice_level)


capture drop temp
bys stateEconArea: gen temp = _n
summ tot_size if tot_size > 0 & temp == 1, det
local p75 = r(p75)
local p90 = r(p90)
local p95 = r(p95)
local p99 = r(p99)

**
** Create several instruments now
**
gen sizeXlogoil =  (tot_size ) * log(oilprice_level) 
gen sizeXoil = (tot_size) * oilprice_level
gen size90 =  cond(tot_size > `p90', `p90', tot_size)
gen size95 =  cond(tot_size > `p95', `p95', tot_size)
gen size99 =  cond(tot_size > `p99', `p99', tot_size)
gen size90Xlogoil = ///
 size90 * log(oilprice_level)
gen size95Xlogoil = ///
 size95 * log(oilprice_level)
gen size99Xlogoil = ///
 size99 * log(oilprice_level)
gen minXsizeXlogoil = miningShare1970 * (tot_size) * log(oilprice_level) 
gen sizeXmaxoil = (tot_size) * log(oilprice_max)

foreach instrument of varlist sizeXlogoil sizeXoil size95Xlogoil {
 bys stateEconArea grp2: egen `instrument'2 = mean(`instrument')
 bys stateEconArea grp3: egen `instrument'3 = mean(`instrument')
}


sort year
char year[omit] 1
char stateEconArea[omit] 1


******
* merge in region codes
******
sort fipsStateCode
merge fipsStateCode using ./dta/fipsToRegion, uniqusing
list if _merge != 3
keep if _merge == 3
drop _merge

gen decade = floor(year / 10)
gen halfdec = floor(year / 5)
replace halfdec = 400 if halfdec == 401
gen post77 = (year >= 1977)
gen t = year - 1970

tab year decade
tab year halfdec

gen minXpost77 = miningShareXoilprice * (year >= 1977)

gen reg4 = . 
replace reg4 = 1 if region == 1 | region == 2 
replace reg4 = 2 if region == 3 | region == 4 
replace reg4 = 3 if region == 5 | region == 6 | region == 7 
replace reg4 = 4 if region == 8 | region == 9

**
* look at mining share for region / reg4
**
bys region: summ miningShare1970
bys reg4: summ miningShare1970


***
** Create data file for James
***
preserve
rename oilprice log_oilprice
**capture drop econSubRegion
**rename stateEconArea econSubRegion
keep fipsStateCode econSubRegion year oilprice_level log_oilprice tot_size *size*oil exptot fte ipdtot log_payroll num_employees log_num_employees south
sort econSubRegion year
save ./dta/AHA_esr_forJames.dta, replace
restore

if ("`1'" == "esr") {
preserve
keep if year == 1970
keep econSubRegion bdtot ipdtot exptot admtot population pop_unweighted num_employees
sort econSubRegion
save ./dta/AHA_1970vars_by_esr.dta, replace
restore
}



sort stateEconArea year
bys stateEconArea: gen sizeXlogoil_lead_3 = sizeXlogoil[_n + 3]
bys stateEconArea: gen sizeXlogoil_lead_5 = sizeXlogoil[_n + 5]
bys stateEconArea: gen sizeXlogoil_lead_7 = sizeXlogoil[_n + 7]


if ( "`1'" == "state" ) {
 sort fipsStateCode year
 capture drop _merge
 merge fipsStateCode year using ./dta/state_GDP, uniqusing uniqmaster
 tab fipsStateCode _merge

 ** don't want to drop 1998-2005 "regular" payroll
 keep if _merge == 3 | _merge == 1

 foreach var of varlist gdp* {
   gen log_`var' = log(`var' / population)
   gen `var'_percap = `var' / pop_unweighted
   gen log_`var'_percap = log(`var' / pop_unweighted)
 }
}

save aha_cbp_final_`1'.dta, replace


