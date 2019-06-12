* This file produces the different datasets used for the 
* three different types of analysys in the paper.
* The input file is the the final panel with simulated tax rates merged to affiliation data



**************************************
*** INDIVIDUAL DATA LONG FOR TOP 5 ***
**************************************


use "data_complete.dta", clear
set more off

drop if percentile<96

replace code_ccaa = code_ccaa_residence

egen id2=group(id year)
label var id2 "case identifier"


* convert to long (id/year/j)

reshape long atr_state mtr_state, i(id2) j(j)

label var j "id alternative region" 

drop if j==99

* generate indep variables data preparation

gen ln_mtr=ln(mtr_state/100)
label var ln_mtr "log MTR in j"
gen ln_atr=ln(atr_state/100)
label var ln_atr "log ATR in j"

gen ln_net_mtr=ln(1-(mtr_state/100))
label var ln_net_mtr "log net-of-MTR in j"
gen ln_net_atr=ln(1-(atr_state/100))
label var ln_net_atr "log net-of-ATR in j"

rename mtr_state mtr
label var mtr "MTR"

rename atr_state atr
label var mtr "ATR"


* generate variables for the placebo

xtset id2 j

egen TEMP_net_mtr_mean=mean(ln_net_mtr) if year>2010, by (id j)
egen ln_net_mtr_mean1411=max(TEMP_net_mtr_mean), by(id j)
label var ln_net_mtr_mean1411 "avergage net-of-MTR after 2010"

egen TEMP_net_atr_mean=mean(ln_net_atr) if year>2010, by (id j)
egen ln_net_atr_mean1411=max(TEMP_net_atr_mean), by(id j)
label var ln_net_atr_mean1411 "avergage net-of-ATR after 2010"

drop TEMP*


* generate the dependent variable

gen d=0
replace d=1 if code_ccaa==j
drop if code_ccaa==.
label var d "=1 if j is choosen residence"

* generate group varibales (FE and cluster)

egen cluster_regionXyear=group(code_ccaa year)
egen jXyear=group(j year)


* define birth region from province


gen TEMPprovince_code=province_birth
drop _merge
merge m:1 TEMPprovince_code using "auxiliary\input_prov_ccaa2.dta", update replace
rename TEMPcode_ccaa birth_ccaa
label var birth_ccaa "code of birth region"

gen birth=0
replace birth=1 if j==birth_ccaa
label var birth "=1 if j is the birth region"

drop _merge TEMPprovince_code

* define first workplace


gen TEMPprovince_code=province_naf
merge m:1 TEMPprovince_code using "auxiliary\input_prov_ccaa2.dta", update replace
rename TEMPcode_ccaa firstwork_ccaa
label var firstwork_ccaa "code of region of first job"

gen firstwork=0
replace firstwork=1 if j==firstwork_ccaa
label var firstwork "=1 if j is the region of first job"
drop _merge TEMPprovince_code

* other geo varibales

replace move_from=code_ccaa_residence if move_from==0

merge m:1 move_from j using "auxiliary\input_distance.dta"
replace NEAR_DIST=1 if NEAR_DIST==.

gen ln_dist1=ln(NEAR_DIST)
label var ln_dist1 "log distance to region (from region)"
drop NEAR_DIST NEAR_RANK NEAR_RANK_INSIDE
drop if _merge==2
drop _merge

gen origin=0
replace origin=1 if j==move_from
label var origin "=1 for j of origin"


* merge firm data

merge m:1 firm_main_prov using "auxiliary\input_firm_prov_ccaa.dta", update replace
gen workplace=1 if code_ccaa_firm==j
replace workplace=0 if workplace==.

* generate fixed effects

foreach state of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {

gen eduXj`state'=edu_uni if `state'==j
replace eduXj`state'=0 if `state'~=j
label var eduXj`state' "alternative region J x education"
}



gen occu_cont=occu_cat
replace occu_cont=0 if occu_cont>100

foreach state of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {

gen occuXj`state'=occu_cont if `state'==j
replace occuXj`state'=0 if `state'~=j
label var occuXj`state' "alternative region J x occupation"
}


foreach state of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {

gen ageXj`state'=age if `state'==j
replace ageXj`state'=0 if `state'~=j
label var ageXj`state' "alternative region J x age"

gen age2Xj`state'=age*age if `state'==j
replace age2Xj`state'=0 if `state'~=j
label var age2Xj`state' "alternative region J x age^2"

}


foreach state of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {

gen sexXj`state'=sex if `state'==j &sex==1
replace sexXj`state'=0 if sexXj`state'==.
label var sexXj`state' "alternative region J x gender"
}

save "data_ind.dta", replace





********************************
*** AGGREGATED ANALYSIS DATA ***
********************************

use "data_complete.dta", replace


* generate representative ATRs

drop atr_state1- gender
drop income1-province_fiscaldata1 income_type1- income_type99999
drop pers_year_birth sex nationality province_birth province_naf province_residence ym_death country_birth education
drop pers_year_birth_2 dif_year old65 old75 kid1 kid2 kid3 kid4 pers_handicap_1 pers_handicap_2 pers_handicap_3 pers_year_birth_2 dif_year

foreach inc of numlist  300  {

foreach n of numlist 1(1)10 {

gen n=_n
sum n
local obs = r(max)+1
set obs `obs'
replace id = 9999999000+`inc' in  `obs'
replace year = 2004+`n' in  `obs'
drop n
}

replace income =`inc'*1000 if income ==.
}


drop  if  id<9999999175

replace pers_famstatus =2 
replace pers_kids = 1 
replace pers_kids_total = 1
replace ym_birth= 196106 

foreach var of varlist pers_kids_0to3 pers_kids_handicap_33to65 pers_kids_handicap_33to65_2 pers_kids_handicap_65 pers_elderly_65to75 pers_elderly_75 pers_elderly_total pers_elderly_handicap_33to65 pers_elderly_handicap_33to65_2 pers_elderly_handicap_65 {

replace `var'= 0  
}
run ..\..\taxcalc\mtr_v6.do

save "data_agg_atr.dta", replace

*  percentile-region-year panel

use "data_complete.dta", replace

replace code_ccaa=code_ccaa_residence

drop if code_ccaa==.
drop if code_ccaa==15
drop if code_ccaa==16
drop if code_ccaa==18
drop if code_ccaa==19
drop if code_ccaa==99
drop if percentile<70

keep id year income code_ccaa  percentile  move_from atr* mtr* move_out* dead age occupation move edu_uni obs_ccaa sector sector_cnae93
save "data_TEMP", replace

set more off
mkdir agg_pc

foreach perc of numlist 70(1)100 {


use "data_TEMP.dta", replace

keep if percentile==`perc'
egen obs_ccaa_inpc=count(code_ccaa), by(year code_ccaa)


foreach s of numlist 1(1)19 {

gen moved_from_`s'=0
replace moved_from_`s'=1 if move_from==`s'

}



gen mtr_own=.


foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {

gen num= income*atr_state`s' 
egen total_num=total( num ) , by(year code_ccaa)
egen total_income=total(income) , by(year code_ccaa)

drop num total_num total_incom



replace mtr_own=mtr_state`s' if `s'==code_ccaa

}

collapse  (max) percentile  mtr_state1-mtr_state99 mtr_own  (mean)  age  obs_ccaa obs_ccaa_inpc income  (sum) moved_from_1 - moved_from_19, by(year code_ccaa)

drop if code_ccaa==.


local top = 101-`perc'
shell erase "agg_pc\cs_pc`top'_v4.dta"
save "agg_pc\cs_pc`top'_v4.dta"

}

use "agg_pc\cs_pc1_v4.dta", replace

foreach perc of numlist 2(1)31 {

append using "agg_pc\cs_pc`perc'_v4.dta"

}


foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {

label var mtr_state`s' "top MTR within percentile in region `s' in t"
}


label var year "year"

label var obs_ccaa "total # observations per region/year"
label var obs_ccaa_inpc "total # observations per region/year in percentile"

label var code_ccaa "code region (CCAA)"
label var percentile "percentile"
label var mtr_own "domestic MTR"
label var age "mean age in province t cell"
order _all, alphabetic
order code* year, first

drop mtr_state99

shell rmdir "agg_pc" /s
shell erase "data_TEMP.dta"

save "data_agg.dta", replace

* percentile movers within ccaa ***

use "data_complete.dta", replace

keep id year code_ccaa percentile

xtset id year

foreach perc of numlist 1(1)100 {

gen from_perc_`perc'=1 if l.percentile==`perc'

}

collapse (sum) from_perc_1- from_perc_100, by(code_ccaa percentile year)

save "data_agg_pc.dta", replace

shell erase data_TEMP.dta

****************************
*** REVENUE IMPLICATIONS ***
****************************

set more off

local level = 90180 

use "data_complete.dta", replace

drop if income<`level'
drop if code_ccaa==.
drop if code_ccaa==15
drop if code_ccaa==16
drop if code_ccaa==18
drop if code_ccaa==19
drop if code_ccaa==99
drop _*

local name = round(`level'/1000)

merge 1:1 id year using data_tau`name'.dta

* migration related variables


foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {



paretofit income if year==2014&code_ccaa_residence==`s', stats robust
local alpha=`e(alpha)'
gen alpha`s'=`alpha'
local alpha_sd=`e(se_alpha)'
gen alpha`s'_sd=`alpha_sd'

egen move_from_`s'_TEMP=count(move_from) if move_from==`s', by(year)
egen move_from_`s'=max(move_from_`s'_TEMP), by(year)
replace move_from_`s'=0 if move_from_`s'==.
}
drop move_from_*

egen n_obs_ccaa_perc_year=count(id) , by( code_ccaa_residence year)

* income and tax variables

egen av_inc_ccaa_perc_year=mean(income), by( code_ccaa_residence year)

gen mtr_own=.
gen atr_own=.

foreach s of numlist 1 2 3 4 5 6 7 8 9 10 11 12 13 14 17 {

replace atr_own=atr_state`s' if `s'==code_ccaa_residence
}

gen tau_regional=atr_own-(atr_state99/2)

gen tau_central=atr_state99/2

gen tau_bar_regional=(tau_regional*income-tau100_regional*`level')/(income-`level')
gen tau_bar_total=(atr_own*income-tau100_total*`level')/(income-`level')

gen tau_bar_central=(tau_central*income-tau100_central*`level')/(income-`level')

collapse tau* alpha* n_obs_ccaa_perc_year av_inc_ccaa_perc_year  atr_own, by( code_ccaa_residence year)
rename code_ccaa_residence code_ccaa

rename atr_own tau_regional_total

label var tau100_regional "regional component of average tax rate at y_bar"
label var tau_regional "regional component average tax rate at y"
label var tau_bar_regional "regional component of marginal tax rate"

gen y_bar=`level'

save data_agg_rev, replace



*******************
*** ETI DATASET ***
*******************


use "data_complete.dta", clear

keep code_ccaa year income

by code_ccaa year, sort: egen obs_ccaa_total=count(code_ccaa)
gen obs_top1=obs_ccaa_total/100
gen obs_top99=obs_ccaa_total-obs_top1
gen obs_top90=obs_ccaa_total-10*obs_top1
sort code_ccaa year income
by code_ccaa year: gen nval=_n
by code_ccaa year: egen double income_top=total(income) if nval>=obs_top99
by code_ccaa year: egen double income_total=total(income) 
by code_ccaa year: egen double income_top10=total(income) if nval>=obs_top90


by code_ccaa year: gen nval2 =_N
keep if nval2==nval


merge 1:1 code_ccaa year using "auxiliary\input_topmtr.dta"
drop _merge

rename code_ccaa destination_ccaa

merge 1:1 destination_ccaa year using "auxiliary\input_cov_dest.dta", update replace
drop _merge


merge 1:1 destination_ccaa year using "auxiliary\input_govspend_dest.dta", update replace
drop _merge


local name dA1_Servicios_Publicos_ dA2_Actuaciones_de_ dA3_Produccion_de_Bienes_ dA4_Actuaciones_de_Caracter_ dA9_Actuaciones_de_Caracter_ dest_transport dest_highschool dest_senior dest_male dest_medianage dest_tertiaryedu dest_population dest_fertility dest_mortality dest_unempl dest_ltunemployment dest_gdpperc dest_RDspend dest_materialdep dest_instate dest_interstate dest_socialcont dest_tourism dest_HDD dest_CDD 
foreach var of local name { 
replace `var' = log(`var') 
}


gen ln_net_topmtr=ln(1-( mtr_top/100))
gen ln_share=ln( income_top/ income_total)
gen ln_share_90=ln( income_top/ income_top10)
gen ln_share_top10= ln(income_top10/ income_total)
gen ln_top_income=ln( income_top)
gen trend=2015-year

gen population = exp(dest_population)
gen TEMP_pop=population if year==2010
egen pop=max(TEMP_pop ), by(code_ccaa)


save "data_eti.dta", replace


