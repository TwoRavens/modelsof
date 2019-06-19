clear
set matsize 11000
set maxvar 32000
set more off
cd "C:\_Research\John\Replication data" // change the directory before proceeding

**** Table 4 & 5 ****
use main_regress.dta, clear
gen lhs_yr = lhs * yr
gen hs_yr = hs * yr
gen scol_yr = scol * yr
gen col_yr = col * yr
gen lhs_locvul = lhs * locvul
gen hs_locvul = hs * locvul
gen scol_locvul = scol * locvul
gen lhs_locvul_yr = lhs * locvul * yr
gen hs_locvul_yr = hs * locvul * yr
gen scol_locvul_yr = scol * locvul * yr
gen col_locvul_yr = col * locvul * yr

gen lhs_locdt = lhs * locdt
gen hs_locdt = hs * locdt
gen scol_locdt = scol * locdt
gen lhs_locdt_yr = lhs * locdt * yr
gen hs_locdt_yr = hs * locdt * yr
gen scol_locdt_yr = scol * locdt * yr
gen col_locdt_yr = col * locdt * yr
compress

gen lhs_t90 = lhs * mex_t90
gen hs_t90 = hs * mex_t90
gen scol_t90 = scol * mex_t90
gen lhs_t90_yr = lhs * mex_t90 * yr
gen hs_t90_yr = hs * mex_t90 * yr
gen scol_t90_yr = scol * mex_t90 * yr
gen col_t90_yr = col * mex_t90 * yr

gen lhs_dt = lhs * mex_dt
gen hs_dt = hs * mex_dt
gen scol_dt = scol * mex_dt
gen lhs_dt_yr = lhs * mex_dt * yr
gen hs_dt_yr = hs * mex_dt * yr
gen scol_dt_yr = scol * mex_dt * yr
gen col_dt_yr = col * mex_dt * yr

gen border_yr = border * yr
compress

global indepvar "age age2 male married white speakeng lhs hs scol lhs_yr hs_yr scol_yr col_yr lhs_locvul_yr hs_locvul_yr scol_locvul_yr col_locvul_yr lhs_locdt_yr hs_locdt_yr scol_locdt_yr col_locdt_yr border_yr lhs_t90_yr hs_t90_yr scol_t90_yr col_t90_yr lhs_dt_yr hs_dt_yr scol_dt_yr col_dt_yr lhs_locvul hs_locvul scol_locvul lhs_locdt hs_locdt scol_locdt lhs_t90 hs_t90 scol_t90 lhs_dt hs_dt scol_dt"

xi: cgmreg logwage $indepvar i.ind i.conspuma, cluster(conspuma ind yr)
outreg2 using "results_tab4-5", excel stats(coef se) e(all) keep($indepvar) ctitle(basic_agric)

use main_regress.dta, clear
gen lhs_yr = lhs * yr
gen hs_yr = hs * yr
gen scol_yr = scol * yr
gen col_yr = col * yr
gen lhs_locvul = lhs * locvul_noag
gen hs_locvul = hs * locvul_noag
gen scol_locvul = scol * locvul_noag
gen lhs_locvul_yr = lhs * locvul_noag * yr
gen hs_locvul_yr = hs * locvul_noag * yr
gen scol_locvul_yr = scol * locvul_noag * yr
gen col_locvul_yr = col * locvul_noag * yr

gen lhs_locdt = lhs * locdt_noag
gen hs_locdt = hs * locdt_noag
gen scol_locdt = scol * locdt_noag
gen lhs_locdt_yr = lhs * locdt_noag * yr
gen hs_locdt_yr = hs * locdt_noag * yr
gen scol_locdt_yr = scol * locdt_noag * yr
gen col_locdt_yr = col * locdt_noag * yr
compress

gen lhs_t90 = lhs * mex_t90_noag
gen hs_t90 = hs * mex_t90_noag
gen scol_t90 = scol * mex_t90_noag
gen lhs_t90_yr = lhs * mex_t90_noag * yr
gen hs_t90_yr = hs * mex_t90_noag * yr
gen scol_t90_yr = scol * mex_t90_noag * yr
gen col_t90_yr = col * mex_t90_noag * yr

gen lhs_dt = lhs * mex_dt_noag
gen hs_dt = hs * mex_dt_noag
gen scol_dt = scol * mex_dt_noag
gen lhs_dt_yr = lhs * mex_dt_noag * yr
gen hs_dt_yr = hs * mex_dt_noag * yr
gen scol_dt_yr = scol * mex_dt_noag * yr
gen col_dt_yr = col * mex_dt_noag * yr

gen border_yr = border * yr
compress

xi: cgmreg logwage $indepvar i.ind i.conspuma, cluster(conspuma ind yr)
test lhs_locvul_yr - lhs_locdt_yr = 0
global F1 = r(chi2)
global p1 = r(p)
test hs_locvul_yr - hs_locdt_yr = 0
global F2 = r(chi2)
global p2 = r(p)
test scol_locvul_yr - scol_locdt_yr = 0
global F3 = r(chi2)
global p3 = r(p)
test col_locvul_yr - col_locdt_yr = 0
global F4 = r(chi2)
global p4 = r(p)
test lhs_t90_yr - lhs_dt_yr = 0
global F5 = r(chi2)
global p5 = r(p)
test hs_t90_yr - hs_dt_yr = 0
global F6 = r(chi2)
global p6 = r(p)
test scol_t90_yr - scol_dt_yr = 0
global F7 = r(chi2)
global p7 = r(p)
test col_t90_yr - col_dt_yr = 0
global F8 = r(chi2)
global p8 = r(p)
outreg2 using "results_tab4-5", excel stats(coef se) keep($indepvar) ctitle(basic_noagric) addstat("F-Test 1", $F1, "p1", $p1, "F-Test 2", $F2, "p2", $p2, ///
	"F-Test 3", $F3, "p3", $p3, "F-Test 4", $F4, "p4", $p4, "F-Test 5", $F5, "p5", $p5, "F-Test 6", $F6, "p6", $p6, "F-Test 7", $F7, "p7", $p7, "F-Test 8", $F8, "p8", $p8) 


**** Table 9 ****
gen lhs_locdchnm = lhs * locdchnmshare
gen hs_locdchnm = hs * locdchnmshare
gen scol_locdchnm = scol * locdchnmshare
gen lhs_locdchnm_yr = lhs * locdchnmshare * yr
gen hs_locdchnm_yr = hs * locdchnmshare * yr
gen scol_locdchnm_yr = scol * locdchnmshare * yr
gen col_locdchnm_yr = col * locdchnmshare * yr

gen lhs_dchnm = lhs * dchnmshare
gen hs_dchnm = hs * dchnmshare
gen scol_dchnm = scol * dchnmshare
gen lhs_dchnm_yr = lhs * dchnmshare * yr
gen hs_dchnm_yr = hs * dchnmshare * yr
gen scol_dchnm_yr = scol * dchnmshare * yr
gen col_dchnm_yr = col * dchnmshare * yr

global chinavar "lhs_locdchnm_yr hs_locdchnm_yr scol_locdchnm_yr col_locdchnm_yr lhs_dchnm_yr hs_dchnm_yr scol_dchnm_yr col_dchnm_yr lhs_locdchnm hs_locdchnm scol_locdchnm lhs_dchnm hs_dchnm scol_dchnm"

xi: cgmreg logwage $indepvar $chinavar i.ind i.conspuma, cluster(conspuma ind yr)
test lhs_locvul_yr - lhs_locdt_yr = 0
global F1 = r(chi2)
global p1 = r(p)
test hs_locvul_yr - hs_locdt_yr = 0
global F2 = r(chi2)
global p2 = r(p)
test scol_locvul_yr - scol_locdt_yr = 0
global F3 = r(chi2)
global p3 = r(p)
test col_locvul_yr - col_locdt_yr = 0
global F4 = r(chi2)
global p4 = r(p)
test lhs_t90_yr - lhs_dt_yr = 0
global F5 = r(chi2)
global p5 = r(p)
test hs_t90_yr - hs_dt_yr = 0
global F6 = r(chi2)
global p6 = r(p)
test scol_t90_yr - scol_dt_yr = 0
global F7 = r(chi2)
global p7 = r(p)
test col_t90_yr - col_dt_yr = 0
global F8 = r(chi2)
global p8 = r(p)
outreg2 using results_tab9, excel stats(coef se) keep($indepvar $chinavar) ctitle(china_noagric) addstat("F-Test 1", $F1, "p1", $p1, "F-Test 2", $F2, "p2", $p2, ///
	"F-Test 3", $F3, "p3", $p3, "F-Test 4", $F4, "p4", $p4, "F-Test 5", $F5, "p5", $p5, "F-Test 6", $F6, "p6", $p6, "F-Test 7", $F7, "p7", $p7, "F-Test 8", $F8, "p8", $p8) 

**** Table 6 ****
use main_regress.dta, clear
keep if (ind > 89 & ind < 224) | ind == 12
gen lhs_yr = lhs * yr
gen hs_yr = hs * yr
gen scol_yr = scol * yr
gen col_yr = col * yr

gen lhs_locvul = lhs * locvul_noag
gen hs_locvul = hs * locvul_noag
gen scol_locvul = scol * locvul_noag
gen lhs_locvul_yr = lhs * locvul_noag * yr
gen hs_locvul_yr = hs * locvul_noag * yr
gen scol_locvul_yr = scol * locvul_noag * yr
gen col_locvul_yr = col * locvul_noag * yr

gen lhs_locdt = lhs * locdt_noag
gen hs_locdt = hs * locdt_noag
gen scol_locdt = scol * locdt_noag
gen lhs_locdt_yr = lhs * locdt_noag * yr
gen hs_locdt_yr = hs * locdt_noag * yr
gen scol_locdt_yr = scol * locdt_noag * yr
gen col_locdt_yr = col * locdt_noag * yr

gen border_yr = border * yr
compress

global indepvar "age age2 male married white speakeng lhs hs scol lhs_yr hs_yr scol_yr col_yr lhs_locvul_yr hs_locvul_yr scol_locvul_yr col_locvul_yr lhs_locdt_yr hs_locdt_yr scol_locdt_yr col_locdt_yr border_yr lhs_locvul hs_locvul scol_locvul lhs_locdt hs_locdt scol_locdt"

xi: cgmreg logwage $indepvar i.ind i.conspuma, cluster(conspuma ind yr)
test lhs_locvul_yr - lhs_locdt_yr = 0
global F1 = r(chi2)
global p1 = r(p)
test hs_locvul_yr - hs_locdt_yr = 0
global F2 = r(chi2)
global p2 = r(p)
test scol_locvul_yr - scol_locdt_yr = 0
global F3 = r(chi2)
global p3 = r(p)
test col_locvul_yr - col_locdt_yr = 0
global F4 = r(chi2)
global p4 = r(p)
outreg2 using results_tab6, excel stats(coef se) keep($indepvar) ctitle(serv_noagric) addstat("F-Test 1", $F1, "p1", $p1, "F-Test 2", $F2, "p2", $p2, ///
	"F-Test 3", $F3, "p3", $p3, "F-Test 4", $F4, "p4", $p4) 

**** Table 7 **** 
use main1980.dta, clear
drop if incwage == 0
gen logwage = log(incwage)
drop incwage 
compress
drop if ind1990 == 0

joinby conspuma using locvul_mexrca_fixed.dta, unmatched(master)
drop _m
joinby ind1990 using trade_ind1990_fixed.dta, unmatched(master)
drop _m mex_t00
replace mex_t90 = 0 if mex_t90 == .
replace mex_dt = 0 if mex_dt == .
replace mex_t90_noag = 0 if mex_t90_noag == .
replace mex_dt_noag = 0 if mex_dt_noag == .
compress
joinby ind1990 using mex_rca.dta, unmatched(master)
drop _m
replace mex_rca = 0 if mex_rca == .
replace mex_t90 = mex_rca * mex_t90
replace mex_t90_noag = mex_rca * mex_t90_noag
replace mex_dt = mex_rca * mex_dt
replace mex_dt_noag = mex_rca * mex_dt_noag

gen border = 1 if conspuma == 7 | conspuma == 8 | conspuma == 11 | conspuma == 25 | conspuma == 43 | conspuma == 312 | conspuma == 457 | conspuma == 458 | conspuma == 462 | conspuma == 469 | conspuma == 470 | conspuma == 471
replace border = 0 if border ==.

label drop _all
egen ind = group(ind1990)
compress

gen lhs_yr = lhs * yr
gen hs_yr = hs * yr
gen scol_yr = scol * yr
gen col_yr = col * yr

gen lhs_locvul = lhs * locvul_noag
gen hs_locvul = hs * locvul_noag
gen scol_locvul = scol * locvul_noag
gen lhs_locvul_yr = lhs * locvul_noag * yr
gen hs_locvul_yr = hs * locvul_noag * yr
gen scol_locvul_yr = scol * locvul_noag * yr
gen col_locvul_yr = col * locvul_noag * yr

gen lhs_locdt = lhs * locdt_noag
gen hs_locdt = hs * locdt_noag
gen scol_locdt = scol * locdt_noag
gen lhs_locdt_yr = lhs * locdt_noag * yr
gen hs_locdt_yr = hs * locdt_noag * yr
gen scol_locdt_yr = scol * locdt_noag * yr
gen col_locdt_yr = col * locdt_noag * yr
compress

gen lhs_t90 = lhs * mex_t90_noag
gen hs_t90 = hs * mex_t90_noag
gen scol_t90 = scol * mex_t90_noag
gen lhs_t90_yr = lhs * mex_t90_noag * yr
gen hs_t90_yr = hs * mex_t90_noag * yr
gen scol_t90_yr = scol * mex_t90_noag * yr
gen col_t90_yr = col * mex_t90_noag * yr

gen lhs_dt = lhs * mex_dt_noag
gen hs_dt = hs * mex_dt_noag
gen scol_dt = scol * mex_dt_noag
gen lhs_dt_yr = lhs * mex_dt_noag * yr
gen hs_dt_yr = hs * mex_dt_noag * yr
gen scol_dt_yr = scol * mex_dt_noag * yr
gen col_dt_yr = col * mex_dt_noag * yr

gen border_yr = border * yr
compress

global indepvar "age age2 male married white speakeng lhs hs scol lhs_yr hs_yr scol_yr col_yr lhs_locvul_yr hs_locvul_yr scol_locvul_yr col_locvul_yr lhs_locdt_yr hs_locdt_yr scol_locdt_yr col_locdt_yr border_yr lhs_t90_yr hs_t90_yr scol_t90_yr col_t90_yr lhs_dt_yr hs_dt_yr scol_dt_yr col_dt_yr lhs_locvul hs_locvul scol_locvul lhs_locdt hs_locdt scol_locdt lhs_t90 hs_t90 scol_t90 lhs_dt hs_dt scol_dt"

xi: cgmreg logwage $indepvar i.ind i.conspuma, cluster(conspuma ind yr)
test lhs_locvul_yr - lhs_locdt_yr = 0
global F1 = r(chi2)
global p1 = r(p)
test hs_locvul_yr - hs_locdt_yr = 0
global F2 = r(chi2)
global p2 = r(p)
test scol_locvul_yr - scol_locdt_yr = 0
global F3 = r(chi2)
global p3 = r(p)
test col_locvul_yr - col_locdt_yr = 0
global F4 = r(chi2)
global p4 = r(p)
test lhs_t90_yr - lhs_dt_yr = 0
global F5 = r(chi2)
global p5 = r(p)
test hs_t90_yr - hs_dt_yr = 0
global F6 = r(chi2)
global p6 = r(p)
test scol_t90_yr - scol_dt_yr = 0
global F7 = r(chi2)
global p7 = r(p)
test col_t90_yr - col_dt_yr = 0
global F8 = r(chi2)
global p8 = r(p)
outreg2 using results_tab7, excel stats(coef se) keep($indepvar) ctitle(basic_noagric) addstat("F-Test 1", $F1, "p1", $p1, "F-Test 2", $F2, "p2", $p2, ///
	"F-Test 3", $F3, "p3", $p3, "F-Test 4", $F4, "p4", $p4, "F-Test 5", $F5, "p5", $p5, "F-Test 6", $F6, "p6", $p6, "F-Test 7", $F7, "p7", $p7, "F-Test 8", $F8, "p8", $p8) 

**** Table 8 ****
use main.dta, clear
drop if incwage == 0
gen logwage = log(incwage)
drop incwage 
compress
drop if ind1990 == 0

joinby conspuma using locdmshare.dta, unmatched(master)
drop _m
joinby ind1990 using dmshare.dta, unmatched(master)
drop _m 
replace dmshare = 0 if dmshare == .
gen dmshare_noag = dmshare
replace dmshare_noag = 0 if ind1990 == 10 | ind1990 == 11

gen border = 1 if conspuma == 7 | conspuma == 8 | conspuma == 11 | conspuma == 25 | conspuma == 43 | conspuma == 312 | conspuma == 457 | conspuma == 458 | conspuma == 462 | conspuma == 469 | conspuma == 470 | conspuma == 471
replace border = 0 if border ==.

label drop _all
egen ind = group(ind1990)
compress

save "regress_dmshare.dta", replace

use regress_dmshare.dta, clear
joinby ind1990 using chnmshare.dta, unmatched(master)
drop _m
replace dchnmshare = 0 if dchnmshare == .
compress

joinby conspuma using locvul_mexrca_fixed.dta, unmatched(master)
drop _m

gen lhs_yr = lhs * yr
gen hs_yr = hs * yr
gen scol_yr = scol * yr
gen col_yr = col * yr

gen lhs_locdmshare = lhs * locdmshare_noag
gen hs_locdmshare = hs * locdmshare_noag
gen scol_locdmshare = scol * locdmshare_noag
gen lhs_locdmshare_yr = lhs * locdmshare_noag * yr
gen hs_locdmshare_yr = hs * locdmshare_noag * yr
gen scol_locdmshare_yr = scol * locdmshare_noag * yr
gen col_locdmshare_yr = col * locdmshare_noag * yr

gen lhs_dmshare = lhs * dmshare_noag
gen hs_dmshare = hs * dmshare_noag
gen scol_dmshare = scol * dmshare_noag
gen lhs_dmshare_yr = lhs * dmshare_noag * yr
gen hs_dmshare_yr = hs * dmshare_noag * yr
gen scol_dmshare_yr = scol * dmshare_noag * yr
gen col_dmshare_yr = col * dmshare_noag * yr

gen lhs_locdchnm = lhs * locdchnmshare
gen hs_locdchnm = hs * locdchnmshare
gen scol_locdchnm = scol * locdchnmshare
gen lhs_locdchnm_yr = lhs * locdchnmshare * yr
gen hs_locdchnm_yr = hs * locdchnmshare * yr
gen scol_locdchnm_yr = scol * locdchnmshare * yr
gen col_locdchnm_yr = col * locdchnmshare * yr

gen lhs_dchnm = lhs * dchnmshare
gen hs_dchnm = hs * dchnmshare
gen scol_dchnm = scol * dchnmshare
gen lhs_dchnm_yr = lhs * dchnmshare * yr
gen hs_dchnm_yr = hs * dchnmshare * yr
gen scol_dchnm_yr = scol * dchnmshare * yr
gen col_dchnm_yr = col * dchnmshare * yr

gen border_yr = border * yr
compress

global indepvar "age age2 male married white speakeng lhs hs scol lhs_yr hs_yr scol_yr col_yr lhs_locdmshare_yr hs_locdmshare_yr scol_locdmshare_yr col_locdmshare_yr lhs_dmshare_yr hs_dmshare_yr scol_dmshare_yr col_dmshare_yr lhs_locdmshare hs_locdmshare scol_locdmshare lhs_dmshare hs_dmshare scol_dmshare border_yr"
global chinavar "lhs_locdchnm_yr hs_locdchnm_yr scol_locdchnm_yr col_locdchnm_yr lhs_dchnm_yr hs_dchnm_yr scol_dchnm_yr col_dchnm_yr lhs_locdchnm hs_locdchnm scol_locdchnm lhs_dchnm hs_dchnm scol_dchnm"

xi: cgmreg logwage $indepvar i.ind i.conspuma, cluster(conspuma ind yr)
outreg2 using "results_tab8_1", excel stats(coef se) keep($indepvar) 

xi: cgmreg logwage $indepvar $chinavar i.ind i.conspuma, cluster(conspuma ind yr)
outreg2 using "results_tab8_2", excel stats(coef se) keep($indepvar $chinavar) 

** instrumenting change in Mexican import share with change in tariffs - table 8 col 3
use "locdmshare.dta", clear
joinby conspuma using "locvul_mexrca_fixed.dta", unmatched(both)
reg locdmshare locdt, robust
predict locdmshare_xb, xb
reg locdmshare_noag locdt_noag, robust
predict locdmshare_noag_xb, xb
drop _m
save locdmshare, replace

use "dmshare.dta", clear
joinby ind1990 using "trade_ind1990_fixed.dta", unmatched(both)
drop _m
joinby ind1990 using "mex_rca.dta", unmatched(both)
replace mex_dt = mex_rca * mex_dt
replace mex_dt_noag = mex_rca * mex_dt_noag
reg dmshare mex_dt, robust
predict dmshare_xb, xb
gen dmshare_noag = dmshare
replace dmshare_noag = 0 if ind1990 == 10 | ind1990 == 11
reg dmshare_noag mex_dt_noag, robust
predict dmshare_noag_xb, xb
drop _m
save dmshare, replace

use "regress_dmshare.dta", clear
drop locdmshare locdmshare_noag dmshare dmshare_noag
joinby conspuma using locdmshare.dta, unmatched(master)
drop _m
joinby ind1990 using dmshare.dta, unmatched(master)
drop _m 
replace dmshare_xb = 0 if dmshare_xb == .
replace dmshare_noag_xb = 0 if dmshare_noag_xb == .

use regress_dmshare.dta, clear
drop locdmshare locdmshare_noag dmshare dmshare_noag
joinby conspuma using locdmshare.dta, unmatched(master)
drop _m
joinby ind1990 using dmshare.dta, unmatched(master)
drop _m 
replace dmshare_xb = 0 if dmshare_xb == .
replace dmshare_noag_xb = 0 if dmshare_noag_xb == .

gen lhs_yr = lhs * yr
gen hs_yr = hs * yr
gen scol_yr = scol * yr
gen col_yr = col * yr

gen lhs_locdmshare = lhs * locdmshare_noag_xb
gen hs_locdmshare = hs * locdmshare_noag_xb
gen scol_locdmshare = scol * locdmshare_noag_xb
gen lhs_locdmshare_yr = lhs * locdmshare_noag_xb * yr
gen hs_locdmshare_yr = hs * locdmshare_noag_xb * yr
gen scol_locdmshare_yr = scol * locdmshare_noag_xb * yr
gen col_locdmshare_yr = col * locdmshare_noag_xb * yr

gen lhs_dmshare = lhs * dmshare_noag_xb
gen hs_dmshare = hs * dmshare_noag_xb
gen scol_dmshare = scol * dmshare_noag_xb
gen lhs_dmshare_yr = lhs * dmshare_noag_xb * yr
gen hs_dmshare_yr = hs * dmshare_noag_xb * yr
gen scol_dmshare_yr = scol * dmshare_noag_xb * yr
gen col_dmshare_yr = col * dmshare_noag_xb * yr

gen border_yr = border * yr
compress

global indepvar "age age2 male married white speakeng lhs hs scol lhs_yr hs_yr scol_yr col_yr lhs_locdmshare_yr hs_locdmshare_yr scol_locdmshare_yr col_locdmshare_yr lhs_dmshare_yr hs_dmshare_yr scol_dmshare_yr col_dmshare_yr lhs_locdmshare hs_locdmshare scol_locdmshare lhs_dmshare hs_dmshare scol_dmshare border_yr"

xi: cgmreg logwage $indepvar i.ind i.conspuma, cluster(conspuma ind yr)
outreg2 using "results_tab8_3", excel stats(coef se) e(all) keep($indepvar) ctitle(iv_dt_noagric)


insheet using "worldex19902000.csv", clear
drop tradeflowcode 
replace mexin1000usd = 0 if mexin1000usd == .
replace usain1000usd = 0 if usain1000usd == .
gen rowex = wldin1000usd - usain1000usd 
drop mexin1000usd usain1000usd wldin1000usd
reshape wide rowex, i( productcode year) j( reporteriso3) str
replace rowexMEX = 0 if rowexMEX ==.
rename productcode hts6
rename rowexMEX mexex
rename rowexAll worldex
drop if hts6 == "9999AA"
destring hts6, replace
save temp, replace

use concord_hts8_ind1990.dta, clear
gen hts6 = floor(hts8/100)
drop hts8 dup
duplicates drop
duplicates tag hts6, gen(dup)

joinby hts6 using temp, unmatched(using)

replace mexex = mexex/2 if dup == 1
replace mexex = mexex/3 if dup == 2
replace mexex = mexex/4 if dup == 3
replace mexex = mexex/5 if dup == 4

replace worldex = worldex/2 if dup == 1
replace worldex = worldex/3 if dup == 2
replace worldex = worldex/4 if dup == 3
replace worldex = worldex/5 if dup == 4

collapse (sum) mexex worldex, by(ind1990 year)
drop if ind1990 == .
gen mexexrow = mexex/worldex
drop mexex worldex
reshape wide mexexrow, i(ind) j(year)
gen dmrowshare = mexexrow2000 - mexexrow1990
keep ind1990 dmrowshare
save dmrowshare.dta, replace

use main.dta, clear
keep if yr == 0
keep if empstat == 1
collapse (sum) emp = perwt, by(ind1990 conspuma)
sort ind1990 conspuma
joinby ind1990 using dmrowshare.dta, unmatched(both)
replace dmrowshare = 0 if dmrowshare == .
gen dmrowshare_noag = dmrowshare
replace dmrowshare_noag = 0 if ind1990 == 10 | ind1990 == 11
gen emp_v1 = emp * dmrowshare
gen emp_v2 = emp * dmrowshare_noag
collapse (sum) emp emp_v*, by(conspuma)
gen locdmrowshare = emp_v1/emp
gen locdmrowshare_noag = emp_v2/emp
keep conspuma locdmrowshare*
save locdmrowshare.dta, replace

use locdmshare.dta, clear
drop locdmshare_xb locdmshare_noag_xb
joinby conspuma using locdmrowshare.dta, unmatched(both)
reg locdmshare locdmrowshare, robust
predict locdmshare_xb, xb
reg locdmshare_noag locdmrowshare_noag, robust
predict locdmshare_noag_xb, xb
drop _m
save locdmrowshare.dta, replace

use dmshare.dta, clear
drop dmshare_xb dmshare_noag_xb dmshare_noag dmshare_noag1_xb
joinby ind1990 using dmrowshare, unmatched(both)
drop _m
reg dmshare dmrowshare, robust
predict dmshare_xb, xb
gen dmshare_noag = dmshare
replace dmshare_noag = 0 if ind1990 == 10 | ind1990 == 11
gen dmrowshare_noag = dmrowshare
replace dmrowshare_noag = 0 if ind1990 == 10 | ind1990 == 11
reg dmshare_noag dmrowshare_noag, robust
predict dmshare_noag_xb, xb
reg dmshare dmrowshare if ind1990 != 10 & ind1990 != 11, robust
predict dmshare_noag1_xb if ind1990 != 10 & ind1990 != 11, xb
save dmrowshare, replace

use regress_dmshare.dta, clear
drop locdmshare locdmshare_noag dmshare dmshare_noag
joinby conspuma using locdmrowshare.dta, unmatched(master)
drop _m
joinby ind1990 using dmrowshare.dta, unmatched(master)
drop _m 
replace dmshare_xb = 0 if dmshare_xb == .
replace dmshare_noag_xb = 0 if dmshare_noag_xb == .
replace dmshare_noag1_xb = 0 if dmshare_noag1_xb == .
replace dmshare_noag_xb = 0 if ind1990 == 10 | ind1990 == 11

gen lhs_yr = lhs * yr
gen hs_yr = hs * yr
gen scol_yr = scol * yr
gen col_yr = col * yr

gen lhs_locdmshare = lhs * locdmshare_noag_xb
gen hs_locdmshare = hs * locdmshare_noag_xb
gen scol_locdmshare = scol * locdmshare_noag_xb
gen lhs_locdmshare_yr = lhs * locdmshare_noag_xb * yr
gen hs_locdmshare_yr = hs * locdmshare_noag_xb * yr
gen scol_locdmshare_yr = scol * locdmshare_noag_xb * yr
gen col_locdmshare_yr = col * locdmshare_noag_xb * yr

gen lhs_dmshare = lhs * dmshare_noag_xb
gen hs_dmshare = hs * dmshare_noag_xb
gen scol_dmshare = scol * dmshare_noag_xb
gen lhs_dmshare_yr = lhs * dmshare_noag_xb * yr
gen hs_dmshare_yr = hs * dmshare_noag_xb * yr
gen scol_dmshare_yr = scol * dmshare_noag_xb * yr
gen col_dmshare_yr = col * dmshare_noag_xb * yr

xi: cgmreg logwage $indepvar i.ind i.conspuma, cluster(conspuma ind yr)
outreg2 using "results_tab8_4", excel stats(coef se) e(all) keep($indepvar) ctitle(iv_row exports)


**** Table 10 ****
use "main.dta", clear
drop if empstat == 3
replace lhs = lhs*perwt
replace hs = hs*perwt
replace scol = scol*perwt
replace col = col*perwt
collapse (sum) lhs hs scol col, by(conspuma yr)
reshape wide lhs hs scol col, i(conspuma) j(yr)
gen dlhs = ln(lhs1/lhs0)
gen dhs = ln(hs1/hs0)
gen dscol = ln(scol1/scol0)
gen dcol = ln(col1/col0)

joinby conspuma using "locvul_mexrca_fixed.dta", unmatched(master)
drop _m

reg dlhs locvul_noag locdt_noag, robust
estimates store dlhs1

reg dhs locvul_noag locdt_noag, robust
estimates store dhs1

reg dscol locvul_noag locdt_noag, robust
estimates store dscol1

reg dcol locvul_noag locdt_noag, robust
estimates store dcol1
outreg2 [dlhs1 dhs1 dscol1 dcol1] using "results_tab10", excel stats(coef se)
