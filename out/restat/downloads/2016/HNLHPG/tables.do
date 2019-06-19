***	This file computes the regression tables

********************************************************************************
********************************************************************************

use Data_toUse.dta, clear 

global size_employees "ln_pemployees ln_pemployees2 ln_nhemployees ln_nhemployees2"

set seed 123456

tab jhr, gen(Djhr)

//	Tax rate in decimals
replace aveemp_nhtax = aveemp_nhtax/100

label variable aveemp_nhtax "Ave. foreign n.h. tax rate"
label variable ln_pemployees "Parent size"
label variable ln_pemployees2 "Parent size, squared"
label variable ln_nhemployees "Foreign non-haven size"
label variable ln_nhemployees2 "Foreign n.h. size, squared"

********************************************************************************

***	Table 3 (including Table C.3) **********************************************

foreach group in manu serv {
	qui ivregress 2sls have_haven (aveemp_nhtax = instr_2001) $size_employees Djhr* if d_`group' == 1, vce(cluster num)
	capture drop touse
	gen touse = e(sample)
	eststo OLS_`group': reg have_haven aveemp_nhtax $size_employees Djhr* if touse & d_`group' == 1, vce(cluster num)
	eststo IV_`group': ivregress 2sls have_haven (aveemp_nhtax = instr_2001) $size_employees Djhr* if touse & d_`group' == 1, first vce(cluster num)
	eststo FE_`group': xtreg have_haven aveemp_nhtax $size_employees Djhr* if touse & d_`group' == 1, fe vce(cluster num)
	xtivreg have_haven (aveemp_nhtax = instr_2001) $size_employees Djhr* if touse & d_`group' == 1, fe i(num) first
	xtset, clear
	eststo FEIV_`group': bootstrap, reps(200) cluster(num) idcluster(newnum): ///
		xtivreg have_haven (aveemp_nhtax = instr_2001) $size_employees Djhr* if touse & d_`group' == 1, fe i(newnum) first
	xtset num jhr
}
esttab OLS_manu IV_manu FE_manu FEIV_manu OLS_serv IV_serv FE_serv FEIV_serv, ///
	b(3) se(3) drop(Djhr* o.*) star(* 0.10 ** 0.05 *** 0.01) r2 obslast label replace

********************************************************************************

***	Table 4 (including Table C.4) **********************************************

preserve
rename rdintensity_zew rd_intensity
keep if d_manu == 1 | d_serv == 1

*** Standard errors are clustered in br1 (as approximation to R&D cluster), 
*	so nums need to be nested in br1. This is not the case if nums change sector 
*	classification between years. Those firms are dropped.
sort num jhr
capture drop mean_br1
by num: egen mean_br1 = mean(br1) if d_manu == 1 
drop if mean_br1 - br1 != 0 & d_manu == 1
capture drop mean_br1
by num: egen mean_br1 = mean(br1) if d_serv == 1 
drop if mean_br1 - br1 != 0 & d_serv == 1

capture drop tax_rd*
gen tax_rd = aveemp_nhtax * rd_intensity
label variable tax_rd "Interaction average foreign non-haven tax rate R&D intensity"
gen tax_rd2001 = instr_2001 * rd_intensity
label variable tax_rd2001 "Interaction instrument year 2001 R&D intensity"

label variable rd_intensity "R\&D intensity"
label variable tax_rd "Interaction tax R\&D intensity"

foreach group in manu serv {
	qui ivregress 2sls have_haven (aveemp_nhtax = instr_2001) $size_employees rd_intensity Djhr* if d_`group' == 1, first vce(cluster num)
	capture drop touse
	gen touse = e(sample)
	eststo OLS_`group': reg have_haven aveemp_nhtax $size_employees rd_intensity Djhr* if touse & d_`group' == 1, vce(cluster num)
	eststo OLSint_`group': reg have_haven aveemp_nhtax $size_employees rd_intensity tax_rd Djhr* if touse & d_`group' == 1, vce(cluster num)
	eststo IV_`group': ivregress 2sls have_haven (aveemp_nhtax = instr_2001) $size_employees rd_intensity Djhr* if touse & d_`group' == 1, first vce(cluster num)
	eststo IVint_`group': ivregress 2sls have_haven (aveemp_nhtax tax_rd = instr_2001 tax_rd2001) $size_employees rd_intensity Djhr* if touse & d_`group' == 1, first vce(cluster num)
}
esttab OLS_manu OLSint_manu IV_manu IVint_manu OLS_serv OLSint_serv IV_serv IVint_serv, ///
	b(3) se(3) drop(Djhr* o.*) star(* 0.10 ** 0.05 *** 0.01) r2 obslast label replace
restore

********************************************************************************

***	Table 5 ********************************************************************

set seed 123456

***	Sales weights
replace avesal_nhtax = avesal_nhtax/100
label variable avesal_nhtax "Ave. foreign n.h. tax rate, sales weighted"

xtset, clear
xtset num jhr

foreach group in manu serv {
	capture drop touse
	gen touse = (ln_pemployees != . & nonh_employees != 0 & nonh_sales != 0 & nonh_assets != 0 & nonh_cassets != 0 & nonh_profits != 0 & instr_2001 != .)
	eststo OLS_`group'_sal_ae: reg have_haven avesal_nhtax $size_employees Djhr* if touse & d_`group' == 1, vce(cluster num)
	eststo IV_`group'_sal_ae: ivregress 2sls have_haven (avesal_nhtax = instr_2001) $size_employees Djhr* if touse & d_`group' == 1, first vce(cluster num)
	eststo FE_`group'_sal_ae: xtreg have_haven avesal_nhtax $size_employees Djhr* if touse & d_`group' == 1, fe vce(cluster num)
	xtset, clear
	eststo FEIV_`group'_sal_ae: bootstrap, reps(200) cluster(num) idcluster(newnum): ///
		xtivreg have_haven (avesal_nhtax = instr_2001) $size_employees Djhr* if touse & d_`group' == 1, fe i(newnum)
	xtset num jhr
}

***	Assets weights
replace aveass_nhtax = aveass_nhtax/100
label variable aveass_nhtax "Ave. foreign n.h. tax rate, total assets weighted"

*	Fixed effects with consistent sample: all equal
foreach group in manu serv {
	capture drop touse
	gen touse = (ln_pemployees != . & nonh_employees != 0 & nonh_sales != 0 & nonh_assets != 0 & nonh_cassets != 0 & nonh_profits != 0 & instr_2001 != .)
	eststo OLS_`group'_ass_ae: reg have_haven aveass_nhtax $size_employees Djhr* if touse & d_`group' == 1, vce(cluster num)
	eststo IV_`group'_ass_ae: ivregress 2sls have_haven (aveass_nhtax = instr_2001) $size_employees Djhr* if touse & d_`group' == 1, first vce(cluster num)
	eststo FE_`group'_ass_ae: xtreg have_haven aveass_nhtax $size_employees Djhr* if touse & d_`group' == 1, fe vce(cluster num)
	xtset, clear
	eststo FEIV_`group'_ass_ae: bootstrap, reps(200) cluster(num) idcluster(newnum): ///
		xtivreg have_haven (aveass_nhtax = instr_2001) $size_employees Djhr* if touse & d_`group' == 1, fe i(newnum)
	xtset num jhr
}

***	Profits weights
replace avepro_nhtax = avepro_nhtax/100
label variable avepro_nhtax "Ave. foreign n.h. tax rate, est. profits weighted"

*	Fixed effects with consistent sample: all equal
foreach group in manu serv {
	capture drop touse
	gen touse = (ln_pemployees != . & nonh_employees != 0 & nonh_sales != 0 & nonh_assets != 0 & nonh_cassets != 0 & nonh_profits != 0 & instr_2001 != .)
	eststo OLS_`group'_pro_ae: reg have_haven avepro_nhtax $size_employees Djhr* if touse & d_`group' == 1, vce(cluster num)
	eststo IV_`group'_pro_ae: ivregress 2sls have_haven (avepro_nhtax = instr_2001) $size_employees Djhr* if touse & d_`group' == 1, first vce(cluster num)
	eststo FE_`group'_pro_ae: xtreg have_haven avepro_nhtax $size_employees Djhr* if touse & d_`group' == 1, fe vce(cluster num)
	xtset, clear
	eststo FEIV_`group'_pro_ae: bootstrap, reps(200) cluster(num) idcluster(newnum): ///
		xtivreg have_haven (avepro_nhtax = instr_2001) $size_employees Djhr* if touse & d_`group' == 1, fe i(newnum)
	xtset num jhr
}

***	Employees weights (same sample as others)
foreach group in manu serv {
	capture drop touse
	gen touse = (ln_pemployees != . & nonh_employees != 0 & nonh_sales != 0 & nonh_assets != 0 & nonh_cassets != 0 & nonh_profits != 0 & instr_2001 != .)
	eststo OLS_`group'_emp_ae: reg have_haven aveemp_nhtax $size_employees Djhr* if touse & d_`group' == 1, vce(cluster num)
	eststo IV_`group'_emp_ae: ivregress 2sls have_haven (aveemp_nhtax = instr_2001) $size_employees Djhr* if touse & d_`group' == 1, first vce(cluster num)
	eststo FE_`group'_emp_ae: xtreg have_haven aveemp_nhtax $size_employees Djhr* if touse & d_`group' == 1, fe vce(cluster num)
	xtset, clear
	eststo FEIV_`group'_emp_ae: bootstrap, reps(200) cluster(num) idcluster(newnum): ///
		xtivreg have_haven (aveemp_nhtax = instr_2001) $size_employees Djhr* if touse & d_`group' == 1, fe i(newnum)
	xtset num jhr
}

esttab OLS_manu_emp_ae IV_manu_emp_ae FE_manu_emp_ae FEIV_manu_emp_ae OLS_serv_emp_ae IV_serv_emp_ae FE_serv_emp_ae FEIV_serv_emp_ae, ///
	b(3) se(3) keep(aveemp_nhtax) star(* 0.10 ** 0.05 *** 0.01) r2 obslast label replace type
esttab OLS_manu_sal_ae IV_manu_sal_ae FE_manu_sal_ae FEIV_manu_sal_ae OLS_serv_sal_ae IV_serv_sal_ae FE_serv_sal_ae FEIV_serv_sal_ae, ///
	b(3) se(3) keep(avesal_nhtax) star(* 0.10 ** 0.05 *** 0.01) r2 obslast label append type
esttab OLS_manu_ass_ae IV_manu_ass_ae FE_manu_ass_ae FEIV_manu_ass_ae OLS_serv_ass_ae IV_serv_ass_ae FE_serv_ass_ae FEIV_serv_ass_ae, ///
	b(3) se(3) keep(aveass_nhtax) star(* 0.10 ** 0.05 *** 0.01) r2 obslast label append type
esttab OLS_manu_pro_ae IV_manu_pro_ae FE_manu_pro_ae FEIV_manu_pro_ae OLS_serv_pro_ae IV_serv_pro_ae FE_serv_pro_ae FEIV_serv_pro_ae, ///
	b(3) se(3) keep(avepro_nhtax) star(* 0.10 ** 0.05 *** 0.01) r2 obslast label append type

********************************************************************************

***	Appendix Tables ************************************************************

set seed 123456

*	Table C.1: see descriptives.do

*	Table C.2
xtset, clear
xtset num jhr

qui ivregress 2sls have_haven (aveemp_nhtax = instr_2001) $size_employees Djhr*, first vce(cluster num)
capture drop touse
gen touse = e(sample)
eststo OLS: reg have_haven aveemp_nhtax $size_employees Djhr* if touse, vce(cluster num)
eststo IV: ivregress 2sls have_haven (aveemp_nhtax = instr_2001) $size_employees Djhr* if touse, first vce(cluster num)
eststo FE: xtreg have_haven aveemp_nhtax $size_employees Djhr* if touse, fe vce(cluster num)
xtset, clear
eststo FEIV: bootstrap, reps(200) cluster(num) idcluster(newnum): ///
		xtivreg have_haven (aveemp_nhtax = instr_2001) $size_employees Djhr* if touse, fe i(newnum) first
xtset num jhr
esttab OLS IV FE FEIV, b(3) se(3) drop(Djhr* o.*) star(* 0.10 ** 0.05 *** 0.01) r2 obslast label replace

*	Table C.3, 4: see above

*	Table C.5
xtset, clear
xtset num jhr

foreach group in manu serv {
	preserve
	keep if d_`group' == 1
	eststo OLS_`group': reg have_haven l.have_haven aveemp_nhtax $size_employees Djhr* if d_`group' == 1 & e(sample), vce(cluster num)
	eststo ABins_`group': xtabond2 have_haven l.have_haven aveemp_nhtax $size_employees Djhr* if d_`group' == 1, twostep robust gmmstyle(aveemp_nhtax l.have_haven, lag(2 .)) ivstyle($size_employees instr_2001) noleveleq
	restore
}
esttab OLS_manu ABins_manu OLS_serv ABins_serv, ///
	b(3) se(3) r2 obslast label star(* 0.10 ** 0.05 *** 0.01) drop(Djhr* o.*)

*	Table C.6
xtset, clear
xtset num jhr

foreach group in manu serv {
	qui ivregress 2sls have_haven (aveemp_nhtax = instr_first) $size_employees Djhr* if d_`group' == 1, first vce(cluster num)
	capture drop touse
	gen touse = e(sample)
	eststo OLS_`group': reg have_haven aveemp_nhtax $size_employees Djhr* if touse & d_`group' == 1, vce(cluster num)
	eststo IV_`group': ivregress 2sls have_haven (aveemp_nhtax = instr_first) $size_employees Djhr* if touse & d_`group' == 1, first vce(cluster num)
	eststo FE_`group': xtreg have_haven aveemp_nhtax $size_employees Djhr* if touse & d_`group' == 1, fe vce(cluster num)
	xtset, clear
	eststo FEIV_`group': bootstrap, reps(200) cluster(num) idcluster(newnum): ///
		xtivreg have_haven (aveemp_nhtax = instr_first) $size_employees Djhr* if touse & d_`group' == 1, fe i(newnum) first
	xtset num jhr
	esttab OLS_`group' IV_`group' FE_`group' FEIV_`group', b(3) se(3) r2 obslast label star(* 0.10 ** 0.05 *** 0.01)
}
esttab OLS_manu IV_manu FE_manu FEIV_manu OLS_serv IV_serv FE_serv FEIV_serv, ///
	b(3) se(3) drop(Djhr* o.*) star(* 0.10 ** 0.05 *** 0.01) r2 obslast label replace

*	Table C.7+8
xtset, clear
xtset num jhr

foreach group in manu serv {
	qui ivregress 2sls have_haven (aveemp_nhtax = instr_2001) $size_employees Djhr* if d_`group' == 1, first vce(cluster num)
	capture drop touse
	gen touse = e(sample)
	eststo Probit_`group': probit have_haven aveemp_nhtax $size_employees Djhr* if touse & d_`group' == 1, vce(cluster num)
	eststo ProbitME_`group': margins, dydx(aveemp_nhtax $size_employees) predict(p) post
	eststo IVprobit_`group': ivprobit have_haven (aveemp_nhtax = instr_2001) $size_employees Djhr* if touse & d_`group' == 1, vce(cluster num)
	eststo IVprobitME_`group': margins, dydx(aveemp_nhtax $size_employees) predict(p) post
	eststo Logit_`group': logit have_haven aveemp_nhtax $size_employees Djhr* if touse & d_`group' == 1, vce(cluster num)
	eststo LogitME_`group': margins, dydx(aveemp_nhtax $size_employees) predict(p) post
	eststo FElogit_`group': xtlogit have_haven aveemp_nhtax $size_employees Djhr* if touse & d_`group' == 1, fe vce(boot, reps(200))
	eststo FElogitME_`group': margins, dydx(aveemp_nhtax $size_employees) predict(pu0) post
}
esttab Probit_manu IVprobit_manu Logit_manu FElogit_manu Probit_serv IVprobit_serv Logit_serv FElogit_serv, ///
	b(3) se(3) drop(Djhr* o.*) star(* 0.10 ** 0.05 *** 0.01) r2 obslast label replace
esttab ProbitME_manu IVprobitME_manu LogitME_manu FElogitME_manu ProbitME_serv IVprobitME_serv LogitME_serv FElogitME_serv, ///
	b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) r2 obslast label replace
	
********************************************************************************
********************************************************************************
