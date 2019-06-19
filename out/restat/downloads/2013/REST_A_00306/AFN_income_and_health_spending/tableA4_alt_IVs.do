
clear
set more off
set mem 200m

est clear






clear
insheet using ./dta/fipsCountiesEmploymentMining.txt
rename fipsstatecode fipsStateCode
rename fipscountycode fipsCountyCode
rename totalemployment totalEmployment
rename miningemployment miningEmployment
keep fipsStateCode fipsCountyCode totalEmployment miningEmployment
sort fipsStateCode fipsCountyCode
merge fipsStateCode fipsCountyCode using ./dta/state_esr_sea_county_xwalk, uniqusing uniqmaster
keep if _merge == 3
drop _merge
drop stateEconArea
rename econSubRegion stateEconArea
collapse (sum) totalEmployment miningEmployment, by(fipsStateCode stateEconArea)
gen miningShare = miningEmployment / totalEmployment
sort fipsStateCode stateEconArea
save ./tmp/mining_share.dta, replace






use aha_final_esr.dta

keep if south == 1 
keep if year >= 1970 & year <= 1990


sort fipsStateCode stateEconArea
capture drop _merge
merge fipsStateCode stateEconArea using ./tmp/mining_share, uniqusing 
tab year _merge, missing
drop if year == .
assert(_merge != 2)
replace miningShare = 0 if missing(miningShare)



xi i.year i.stateEconArea

**
* set-up
** 
local clusterVariable = "fipsStateCode"
local absorbVariable  = "stateEconArea"

local aha_var = "exptot"
local instrument = "sizeXlogoil"

global fs_stats = "effect_1sd_size effect_2sd_size"




**
* baseline
**
preserve 
keep if log_payroll < . & log_exptot < . & south == 1 & year >= 1970 & year <= 1990
areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
 test `instrument'
 do add_fs_params `instrument'
 est store `aha_var'_fs_z1s
ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable')
 est store iv_z1s
restore

summ miningShare
replace miningShare = miningShare - r(mean)

capture drop minXlogoil
gen minXdummyXlogoil = miningShare * (tot_size > 0 & tot_size < .) * log(oilprice_prev1)
gen minXdummy = miningShare * (tot_size > 0 & tot_size < .)
gen dummyXlogoil = (tot_size > 0 & tot_size < .) * log(oilprice_prev1)
gen minXlogoil = miningShare * log(oilprice_prev1)

sort stateEconArea year
list stateEconArea year minXdummyXlogoil*



gen sizeXoil_t = tot_size * log(oilprice_level)
capture drop oil_dummy
gen oil_dummy =  (tot_size > 0 & tot_size < .)
gen oil_dummyXlogoil = (tot_size > 0 & tot_size < .) * log(oilprice_prev1)


local z = 2
foreach instrument of varlist sizeXoil sizeXoil_t size95Xlogoil oil_dummyXlogoil minXdummyXlogoil {

 preserve 
 keep if year >= 1970 & year <= 1990 & log_payroll < . & log_`aha_var' < . & south == 1
 areg log_payroll `instrument' _Iy* [aw=wgt], absorb(`absorbVariable') cluster(`clusterVariable')
  test `instrument'
  do add_fs_params `instrument'
  est store `aha_var'_fs_z`z'_r
 ivreg log_`aha_var' (log_payroll = `instrument') _I* [aw=wgt], cluster(`clusterVariable')
  est store iv_z`z'_r
 local z = `z' + 1
 restore

}



estout *fs_* ///
 using tableA4_alt_IVs_fs.txt, ///
    stats(r2 N fstat, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")

estout *iv_* ///
 using tableA4_alt_IVs_iv.txt, ///
    stats(r2 N, fmt(%9.3f %9.0f %9.5f)) modelwidth(10) ///
    cells(b( fmt(%9.3f)) se(par fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) )  ///
    style(tab) replace notype mlabels(, numbers ) drop(_* *_I*) title("`title_str'")
