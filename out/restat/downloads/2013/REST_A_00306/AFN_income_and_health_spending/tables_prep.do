
**
* do tables_prep esr|state
**


clear
est clear

set more off
set mem 2000m
set matsize 5000
set linesize 220




global fs_stats = "effect_1sd_size effect_2sd_size"
local clusterVariable = "`4'"
local absorbVariable  = "stateEconArea"
local title_str = "`1' FE, yearFE"




capture program drop add_fstat
program add_fstat, eclass
  ereturn scalar fstat = `1'
end


capture program drop add_parm
program add_parm, eclass
  ereturn scalar `1' = `2'
end





clear
use ./dta/fips
sort fipsStateCode
save ./dta/fips.dta, replace



/**
 ** ONLY RUN ONCE
 **
clear 
use ./dta/state_totals_in_nhis_doc_wgt
rename hospital_days hospital_days_d
rename hospital_episodes hospital_episodes_d
rename doctor_visits doctor_visits_d
sort state year
save ./dta/state_totals_in_nhis_doc_wgt, replace

clear 
use ./dta/state_totals_in_nhis_hosp_wgt
rename hospital_days hospital_days_h
rename hospital_episodes hospital_episodes_h
rename doctor_visits doctor_visits_h
sort state year
save ./dta/state_totals_in_nhis_hosp_wgt, replace
 **
 **/



clear
use aha_cbp_final_`1'.dta

xi i.year

gen oilprice_prev1 = oilprice_prev
forvalues lag = 1(1)5 {
 sort stateEconArea year
 by stateEconArea: gen sizeXlogoil_prev`lag' = tot_size * log(oilprice_prev`lag')

 sort stateEconArea year
 by stateEconArea: gen log_payroll_prev`lag' = log_payroll[_n - `lag']
}

gen wgt = 1
sort stateEconArea year
by stateEconArea: gen bd_wgt = bdtot[1]

capture tsset, clear

gen log_frac_ern        = ftern / (ftern + ftelpn)
gen log_frac_ern3       = ftern3 / (ftern3 + ftelpn3)
gen log_frac_ern_raw    = ftern / (ftern + ftelpn)
gen log_frac_ern_percap = ftern / (ftern + ftelpn)
gen log_frac_ern_nonfed = ftern_nonfed / (ftern_nonfed + ftelpn_nonfed)


*****
* south - census south
* oil   - oil states
capture drop south
** AL, AR, DC, DE, FL, GA, KY, LA, MD, MS, NC, OK, SC, TN, TX, VA, WV
gen south = 0
foreach s of numlist 1 5 10 11 12 13 21 22 24 28 37 40 45 47 48 51 54 {
 replace south = 1 if fipsStateCode == `s'
}

if ("`1'" == "state") {
  gen tot_size_state = tot_size
}



capture drop oil_state
gen oil_state = 0
replace oil_state = 1 if tot_size_state > 0 & tot_size_state < .

capture drop oilXsouth
gen oilXsouth = oil_state * south


capture drop *_fd
sort stateEconArea year
by stateEconArea: gen log_payroll_fd = log_payroll[_n] - log_payroll[_n-1] if year == year[_n-1]+1
sort stateEconArea year
by stateEconArea: gen sizeXlogoil_fd = sizeXlogoil[_n] - sizeXlogoil[_n-1] if year == year[_n-1]+1

gen sizeXlogoil_prev = sizeXlogoil_prev1

replace sizeXlogoil = tot_size * log(oilprice_prev1)
replace sizeXoil    = tot_size * oilprice_prev1
replace size90Xlogoil   = size90 * log(oilprice_prev1)
replace size95Xlogoil   = size95 * log(oilprice_prev1)
replace size99Xlogoil   = size99 * log(oilprice_prev1)
replace minXsizeXlogoil = miningShare1970 * tot_size * log(oilprice_prev1)

sort stateEconArea year
by stateEconArea: gen sizeXlogoil_post3 = sizeXlogoil[_n + 3]
sort stateEconArea year
by stateEconArea: gen sizeXlogoil_post5 = sizeXlogoil[_n + 5]


if ("`1'" == "esr") {
 local aha_vars = "exptot tech_max_nonfed paytot frac_ern exp_tech_max_nonfed tech_max "
}
else {
 local aha_vars = "exptot"
}

local aha_vars2 = "population pop_unweighted num_employees num_hosp admtot ipdtot bdtot fte p_55plus p_u55 p_65plus p_u65 p_45plus p_u45"


foreach aha_var in `aha_vars' `aha_vars2' {
 di "make FD for `aha_var' ..."
 sort stateEconArea year
 capture drop log_`aha_var'_fd
 by stateEconArea: gen log_`aha_var'_fd = log_`aha_var'[_n] - log_`aha_var'[_n-1] if year == year[_n-1]+1
}

foreach aha_var of varlist exptot num_employees payroll paytot {
  drop if missing(`aha_var')
}




***************
** NOTE: We will drop zero expenditure areas and interpolate outliers in 1979 for three ESRs
***************
sort stateEconArea year
list stateEconArea year exptot if stateEconArea == 13032 | stateEconArea == 40022	
drop if stateEconArea == 13032 | stateEconArea == 40022	
sort stateEconArea year
replace exptot = (exptot[_n - 1] + exptot[_n + 1])/2 if econSubRegion == 21030 & year == 1979
replace log_exptot = log(exptot / population) if econSubRegion == 21030 & year == 1979
replace exptot_private = (exptot_private[_n - 1] + exptot_private[_n + 1])/2 if econSubRegion == 21030 & year == 1979




gen one = 1
gen evenYear = (year == 2*floor(year / 2))
global if_opts = "if one == 1"

replace npaydpr = . if year < 1978 |  year > 1988
replace npayint = . if year < 1978 |  year > 1988

if ("`1'" == "state") {
 sort  fipsStateCode
 capture drop _merge
 merge fipsStateCode using ./dta/fips, uniqusing
 tab _merge, missing
 assert(_merge != 1)
 keep if _merge == 3

 sort state year
 capture drop _merge
 merge state year using ./dta/state_totals_in_nhis.dta, uniqusing
 tab _merge, missing
 ** no data for DC in 1970's and no data for VA
 list state year if _merge == 2
 drop if _merge == 2

/**
 **
 sort state year
 capture drop _merge
 merge state year using ./dta/state_totals_in_nhis_doc_wgt.dta, uniqusing
 tab _merge, missing
 ** no data for DC in 1970's and no data for VA
 list state year if _merge == 2
 drop if _merge == 2

 sort state year
 capture drop _merge
 merge state year using ./dta/state_totals_in_nhis_hosp_wgt.dta, uniqusing
 tab _merge, missing
 ** no data for DC in 1970's and no data for VA
 list state year if _merge == 2
 drop if _merge == 2
 **
 **/

 bys year: summ private_insurance

}


capture drop *name
capture drop *_micro
capture drop id cntrl short_term serv
capture drop *dpr*
capture drop *payint*
capture drop myn myN
capture drop temp

save aha_final_`1'.dta, replace

exit




