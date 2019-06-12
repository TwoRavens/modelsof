
********Replication files Leiby, Østby & Nordås (2018): "The Legacy of Wartime Violence on Intimate Partner Abuse"

set more off
capture use "C:\Users\gudrun\Dropbox\SVAC_gral\SVAC_PERU\Revision ISQ\Gudrun\Replication_data_Leiby_etal_ISQ_2018.dta", replace



**********************************************************************************************************************************************************************************
***MULTIVARIATE RES (Table 1)
*********************************************************************************************************************************************************************************

capture est drop *
logit frstyrDV allwarPOLVIOL_acc age_corr yearsmar i.fbm_m edyrs edyrs_p i.alc_use i.wealth urb mobility_dummy i.wb_dummy_m i.year if year>1979, cl(ID_1)
est store multivar1
logit frstyrDV allwarSV_acc age_corr yearsmar  i.fbm_m edyrs edyrs_p i.alc_use i.wealth urb mobility_dummy i.wb_dummy_m i.year if year>1979, cl(ID_1)
est store multivar2
logit frstyrDV POLVIOL_noSV_acc age_corr yearsmar  i.fbm_m edyrs edyrs_p i.alc_use i.wealth urb mobility_dummy i.wb_dummy_m i.year if year>1979, cl(ID_1)
est store multivar3



**********************************************************************************************************************************************************************************
***DESCRIPTIVES (Table A1)
*********************************************************************************************************************************************************************************

logit frstyrDV allwarPOLVIOL_acc age_corr yearsmar i.fbm_m edyrs edyrs_p i.alc_use i.wealth urb mobility_dummy i.wb_dummy_m i.year if year>1979, cl(ID_1)
sum frstyrDV allwarPOLVIOL_acc allwarSV_acc  POLVIOL_noSV_acc ///
age_corr yearsmar  fbm_m edyrs edyrs_p alc_use wealth urb yrsres mobility_dummy wb_dummy_m year if e(sample), sep(0)



**********************************************************************************************************************************************************************************
***CORRELATION MATRIX (Table A2)
*********************************************************************************************************************************************************************************

logit frstyrDV allwarPOLVIOL_acc age_corr yearsmar  i.fbm_m edyrs edyrs_p i.alc_use i.wealth urb mobility_dummy i.wb_dummy_m i.year if year>1979, cl(ID_1)
vce, corr 




**********************************************************************************************************************************************************************************
***SUBST. EFFECTS: CLARIFY
*********************************************************************************************************************************************************************************

estsimp logit frstyrDV allwarPOLVIOL_acc age_corr yearsmar  fbm edyrs edyrs_p alc wealth urb mobility_dummy wb_dummy year if year>1979, cl(ID_1)
setx mean
simqi, fd(pr) changex(allwarPOLVIOL_acc p5 p95)




**********************************************************************************************************************************************************************************
***EFFECT PLOTS (Figures 4 & A1)
*********************************************************************************************************************************************************************************

*********allwarPOLVIOL_acc (Fig. 4)

logit frstyrDV allwarPOLVIOL_acc age_corr yearsmar  i.fbm_m edyrs edyrs_p i.alc_use i.wealth urb mobility_dummy i.wb_dummy_m i.year if year>1979, cl(ID_1)

capture drop _*

xi, pre(_f_) i.fbm_m
xi, pre(_a_) i.alc_use
xi, pre(_w_) i.wealth
xi, pre(_b_) i.wb_dummy_m
xi, pre(_y_) i.year
drop  _y_year_1970  _y_year_1971  _y_year_1972 _y_year_1973 _y_year_1974 _y_year_1975 _y_year_1976 _y_year_1977 _y_year_1978 _y_year_1979 _y_year_2009

gen _copydepvar = frstyrDV 
replace _copydepvar = . if year<1980


estsimp logit _copydepvar allwarPOLVIOL_acc age_corr yearsmar  _f_* edyrs edyrs_p _a_* _w_* urb mobility_dummy _b_* _y_* if year>1979, genname(_b)
qui setx mean
simqi, fd(prval(1) genpr(_pr_polviol)) changex(allwarPOLVIOL_acc p5 p95)
simqi, fd(prval(1) genpr(_pr_age_corr)) changex(age_corr p5 p95) 
simqi, fd(prval(1) genpr(_pr_yearsmar)) changex(yearsmar 0 5)
simqi, fd(prval(1) genpr(_pr_edyrs)) changex(edyrs p5 p95)
simqi, fd(prval(1) genpr(_pr_edyrs_p)) changex(edyrs_p p5 p95)
simqi, fd(prval(1) genpr(_pr_urb)) changex(urb 0 1)
simqi, fd(prval(1) genpr(_pr_mobility_dummy)) changex(mobility_dummy 0 1)

qui setx _f_fbm_m_2 0 
simqi, fd(prval(1) genpr(_pr_fbm)) changex(_f_fbm_m_1 0 1)
qui setx mean

qui setx _a_alc_use_2 0 
simqi, fd(prval(1) genpr(_pr_alc_sometimes)) changex(_a_alc_use_1 0 1)
qui setx _a_alc_use_1 0 
simqi, fd(prval(1) genpr(_pr_alc_often)) changex(_a_alc_use_2 0 1)
qui setx mean

qui setx _b_wb_dummy_2 0 
simqi, fd(prval(1) genpr(_pr_wb)) changex(_b_wb_dummy_1 0 1)
qui setx mean

qui setx _w_wealth_2 0 
qui setx _w_wealth_3 0 
qui setx _w_wealth_4 0 
simqi, fd(prval(1) genpr(_pr_wealth)) changex(_w_wealth_5 0 1)
qui setx mean



capture drop _fig_*
gen _fig_avg = .
gen _fig_max = .
gen _fig_min = .
gen _fig_i = _n
local i = 1

foreach x of varlist _pr_* {
	_pctile `x', p(5 50 95)
	return list
	di `i'
	di "`x'"
	replace _fig_min = `r(r1)' if _fig_i == `i'
	replace _fig_avg = `r(r2)' if _fig_i == `i'
	replace _fig_max = `r(r3)' if _fig_i == `i'
	local i = `i' + 1
}
replace _fig_i = . if _fig_min == .

capture label drop _fig_i
label define _fig_i 1 "Pol. violence (p5-p95)"
label define _fig_i 2 "Age (p5-p95)", add
label define _fig_i 3 "Year of marriage (0-5)", add
label define _fig_i 4 "Education (p5-p95)", add
label define _fig_i 5 "Partner's ed. (p5-p95)", add
label define _fig_i 6 "Urban", add
label define _fig_i 7 "Moved", add
label define _fig_i 8 "Father beat mother", add
label define _fig_i 9 "Partner sometimes drunk", add
label define _fig_i 10 "Partner often drunk", add
label define _fig_i 11 "Wife-beating justified", add
label define _fig_i 12 "Wealth", add

label values _fig_i _fig_i
gen _fig_null = 0
replace _fig_min= _fig_min*100
replace _fig_max = _fig_max*100
replace _fig_avg = _fig_avg*100
twoway (rcap _fig_min _fig_max _fig_i, hor ylabel(1(1)12,val angle(hor)) ) (scatter _fig_i _fig_avg) (line _fig_i _fig_null), legend(off) xtitle("Change in risk of experiencing domestic violence") xlab(-6 -5 -4 -3 -2 -1 0 1 2 3 4 5) ytitle("")




graph export "C:\Users\gudrun\Dropbox\SVAC_gral\SVAC_PERU\tabfig\DomViol_allwarPOLVIOL_acc.emf", replace





************allwarSV_acc (Fig. A1)


logit frstyrDV allwarSV_acc age_corr yearsmar  i.fbm_m edyrs edyrs_p i.alc_use i.wealth urb mobility_dummy i.wb_dummy_m i.year if year>1979, cl(ID_1)

capture drop _*

xi, pre(_f_) i.fbm_m
xi, pre(_a_) i.alc_use
xi, pre(_w_) i.wealth
xi, pre(_b_) i.wb_dummy_m
xi, pre(_y_) i.year
drop  _y_year_1970  _y_year_1971  _y_year_1972 _y_year_1973 _y_year_1974 _y_year_1975 _y_year_1976 _y_year_1977 _y_year_1978 _y_year_1979 _y_year_2009

gen _copydepvar = frstyrDV 
replace _copydepvar = . if year<1980


estsimp logit _copydepvar allwarSV_acc age_corr yearsmar  _f_* edyrs edyrs_p _a_* _w_* urb mobility_dummy _b_* _y_* if year>1979, genname(_b)
qui setx mean
simqi, fd(prval(1) genpr(_pr_polviol)) changex(allwarSV_acc p5 p95)
simqi, fd(prval(1) genpr(_pr_age_corr)) changex(age_corr p5 p95) 
simqi, fd(prval(1) genpr(_pr_yearsmar)) changex(yearsmar 0 5)
simqi, fd(prval(1) genpr(_pr_edyrs)) changex(edyrs p5 p95)
simqi, fd(prval(1) genpr(_pr_edyrs_p)) changex(edyrs_p p5 p95)
simqi, fd(prval(1) genpr(_pr_urb)) changex(urb 0 1)
simqi, fd(prval(1) genpr(_pr_mobility_dummy)) changex(mobility_dummy 0 1)

qui setx _f_fbm_m_2 0 
simqi, fd(prval(1) genpr(_pr_fbm)) changex(_f_fbm_m_1 0 1)
qui setx mean

qui setx _a_alc_use_2 0 
simqi, fd(prval(1) genpr(_pr_alc_sometimes)) changex(_a_alc_use_1 0 1)
qui setx _a_alc_use_1 0 
simqi, fd(prval(1) genpr(_pr_alc_often)) changex(_a_alc_use_2 0 1)
qui setx mean

qui setx _b_wb_dummy_2 0 
simqi, fd(prval(1) genpr(_pr_wb)) changex(_b_wb_dummy_1 0 1)
qui setx mean

qui setx _w_wealth_2 0 
qui setx _w_wealth_3 0 
qui setx _w_wealth_4 0 
simqi, fd(prval(1) genpr(_pr_wealth)) changex(_w_wealth_5 0 1)
qui setx mean



capture drop _fig_*
gen _fig_avg = .
gen _fig_max = .
gen _fig_min = .
gen _fig_i = _n
local i = 1

foreach x of varlist _pr_* {
	_pctile `x', p(5 50 95)
	return list
	di `i'
	di "`x'"
	replace _fig_min = `r(r1)' if _fig_i == `i'
	replace _fig_avg = `r(r2)' if _fig_i == `i'
	replace _fig_max = `r(r3)' if _fig_i == `i'
	local i = `i' + 1
}
replace _fig_i = . if _fig_min == .

capture label drop _fig_i
label define _fig_i 1 "Sexual violence (p5-p95)"
label define _fig_i 2 "Age (p5-p95)", add
label define _fig_i 3 "Year of marriage (0-5)", add
label define _fig_i 4 "Education (p5-p95)", add
label define _fig_i 5 "Partner's ed. (p5-p95)", add
label define _fig_i 6 "Urban", add
label define _fig_i 7 "Moved", add
label define _fig_i 8 "Father beat mother", add
label define _fig_i 9 "Partner sometimes drunk", add
label define _fig_i 10 "Partner often drunk", add
label define _fig_i 11 "Wife-beating justified", add
label define _fig_i 12 "Wealth", add

label values _fig_i _fig_i
gen _fig_null = 0
replace _fig_min= _fig_min*100
replace _fig_max = _fig_max*100
replace _fig_avg = _fig_avg*100
twoway (rcap _fig_min _fig_max _fig_i, hor ylabel(1(1)12,val angle(hor)) ) (scatter _fig_i _fig_avg) (line _fig_i _fig_null), legend(off) xtitle("Change in risk of experiencing domestic violence") xlab(-6 -5 -4 -3 -2 -1 0 1 2 3 4 5) ytitle("")




graph export "C:\Users\gudrun\Dropbox\SVAC_gral\SVAC_PERU\tabfig\DomViol_allwarSV_acc.emf", replace





************POLVIOL_noSV_acc

logit frstyrDV POLVIOL_noSV_acc age_corr yearsmar  i.fbm_m edyrs edyrs_p i.alc_use i.wealth urb mobility_dummy i.wb_dummy_m i.year if year>1979, cl(ID_1)

capture drop _*

xi, pre(_f_) i.fbm_m
xi, pre(_a_) i.alc_use
xi, pre(_w_) i.wealth
xi, pre(_b_) i.wb_dummy_m
xi, pre(_y_) i.year
drop  _y_year_1970  _y_year_1971  _y_year_1972 _y_year_1973 _y_year_1974 _y_year_1975 _y_year_1976 _y_year_1977 _y_year_1978 _y_year_1979 _y_year_2009

gen _copydepvar = frstyrDV 
replace _copydepvar = . if year<1980


estsimp logit _copydepvar POLVIOL_noSV_acc age_corr yearsmar  _f_* edyrs edyrs_p _a_* _w_* urb mobility_dummy _b_* _y_* if year>1979, genname(_b)
qui setx mean
simqi, fd(prval(1) genpr(_pr_polviol)) changex(POLVIOL_noSV_acc p5 p95)
simqi, fd(prval(1) genpr(_pr_age_corr)) changex(age_corr p5 p95) 
simqi, fd(prval(1) genpr(_pr_yearsmar)) changex(yearsmar 0 5)
simqi, fd(prval(1) genpr(_pr_edyrs)) changex(edyrs p5 p95)
simqi, fd(prval(1) genpr(_pr_edyrs_p)) changex(edyrs_p p5 p95)
simqi, fd(prval(1) genpr(_pr_urb)) changex(urb 0 1)
simqi, fd(prval(1) genpr(_pr_mobility_dummy)) changex(mobility_dummy 0 1)

qui setx _f_fbm_m_2 0 
simqi, fd(prval(1) genpr(_pr_fbm)) changex(_f_fbm_m_1 0 1)
qui setx mean

qui setx _a_alc_use_2 0 
simqi, fd(prval(1) genpr(_pr_alc_sometimes)) changex(_a_alc_use_1 0 1)
qui setx _a_alc_use_1 0 
simqi, fd(prval(1) genpr(_pr_alc_often)) changex(_a_alc_use_2 0 1)
qui setx mean

qui setx _b_wb_dummy_2 0 
simqi, fd(prval(1) genpr(_pr_wb)) changex(_b_wb_dummy_1 0 1)
qui setx mean

qui setx _w_wealth_2 0 
qui setx _w_wealth_3 0 
qui setx _w_wealth_4 0 
simqi, fd(prval(1) genpr(_pr_wealth)) changex(_w_wealth_5 0 1)
qui setx mean



capture drop _fig_*
gen _fig_avg = .
gen _fig_max = .
gen _fig_min = .
gen _fig_i = _n
local i = 1

foreach x of varlist _pr_* {
	_pctile `x', p(5 50 95)
	return list
	di `i'
	di "`x'"
	replace _fig_min = `r(r1)' if _fig_i == `i'
	replace _fig_avg = `r(r2)' if _fig_i == `i'
	replace _fig_max = `r(r3)' if _fig_i == `i'
	local i = `i' + 1
}
replace _fig_i = . if _fig_min == .

capture label drop _fig_i
label define _fig_i 1 "Pol. viol. (except SV)"
label define _fig_i 2 "Age (p5-p95)", add
label define _fig_i 3 "Year of marriage (0-5)", add
label define _fig_i 4 "Education (p5-p95)", add
label define _fig_i 5 "Partner's ed. (p5-p95)", add
label define _fig_i 6 "Urban", add
label define _fig_i 7 "Moved", add
label define _fig_i 8 "Father beat mother", add
label define _fig_i 9 "Partner sometimes drunk", add
label define _fig_i 10 "Partner often drunk", add
label define _fig_i 11 "Wife-beating justified", add
label define _fig_i 12 "Wealth", add

label values _fig_i _fig_i
gen _fig_null = 0
replace _fig_min= _fig_min*100
replace _fig_max = _fig_max*100
replace _fig_avg = _fig_avg*100
twoway (rcap _fig_min _fig_max _fig_i, hor ylabel(1(1)12,val angle(hor)) ) (scatter _fig_i _fig_avg) (line _fig_i _fig_null), legend(off) xtitle("Change in risk of experiencing domestic violence") xlab(-6 -5 -4 -3 -2 -1 0 1 2 3 4 5) ytitle("")


graph export "C:\Users\gudrun\Dropbox\SVAC_gral\SVAC_PERU\tabfig\DomViol_POLVIOL_noSV_acc.emf", replace





