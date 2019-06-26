********** FEEDING UNREST IN AFRICA **********
********** WRITTEN BY TODD G. SMITH ***********
********** UPDATED 3 FEBRUARY 2014 **************


clear all
set more off
set matsize 1200
set linesize 149

local date	"`c(current_date)'"
local user  "`c(username)'"

cd "/Users/`user'/Documents/active_projects/feeding_unrest_africa/analysis"

capture log close
log using "logs/Feeding Unrest in Africa analysis `date'.txt", text replace
/*
***** RECODE AND MERGE DATA TOGETHER ...
*quietly do "do_files/DATASET_COMPILATION_140131.do"

* ... OR CALL IN PREVIOUSLY CREATED DATA FILE.
use "data/feeding_unrest_africa.dta", clear

********************************************************************************
*** ANALYSIS ****** ANALYSIS ****** ANALYSIS ****** ANALYSIS ****** ANALYSIS ***
********************************************************************************

*********************** CHOOSING THE RIGHT MSCP ***********************
loc x "l_unrest"
loc z "grinst l_dry_mscp l_wet_mscp"

gen sample = 1
foreach n of numlist 18(3)3 {
	quietly capture drop l_dry_mscp
	quietly gen l_dry_mscp = l.dry_mscp`n'
	quietly capture drop l_wet_mscp
	quietly gen l_wet_mscp = l.wet_mscp`n'
	eststo fe`n': quietly xtreg std_food_chg `z' l_unrest i.month i.year if sample == 1, cl(iso_num) fe
	quietly capture drop sample
	quietly gen sample = e(sample)
	regsave `z' l_unrest using "results/mscp_months/fe`n'.dta", replace
	}
display "***** FIXED EFFECTS MODELS OF PERCENTAGE CHANGES IN FOOD PRICE INDEX USING WET AND DRY MSCP AT 3 TO 18 MONTHS *****"
esttab fe3 fe6 fe9 fe12 fe15 fe18, keep(`z' l_unrest) sca(N N_clust r2_a r2_w r2_b r2_o) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti

esttab fe3 fe6 fe9 fe12 fe15 fe18 using "results/fs_results_time.csv", keep(`z' `x') sca(N N_clust r2_a r2_w r2_b r2_o) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti ti(Table 3: Robustness of food price model (first stage) to different specifications of monthly rainfall accumulations) nonote addn(Cluster robust standard errors reported in parentheses; + p < .1; * p < .05; ** p < .01) replace

******************** FIRST-STAGE MODEL *******************
use "data/feeding_unrest_africa.dta", clear
eststo clear
loc x1 "l_unrest"
loc x2 "l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
loc z "grinst l_dry_mscp9 l_wet_mscp6"
gen f_grinst = f.grinst
gen f_dry_mscp9 = f.dry_mscp9
lab var f_grinst "Trade bal adj grain price instrument (t+1)"
lab var f_dry_mscp9 "9 month dry MSCP (t+1)"

eststo ols: quietly reg std_food_chg `z' `x1', cl(iso_num)
capture drop sample
gen sample = e(sample)
eststo fe1: quietly xtreg std_food_chg `z' `x1' i.month i.year, fe cl(iso_num)
eststo fe2: quietly xtreg std_food_chg `z' `x2' i.month i.year, fe cl(iso_num)
eststo fe3: quietly xtreg std_food_chg `z' `x2' f_grinst f_dry_mscp9 i.month i.year, fe cl(iso_num)
eststo prais: quietly prais std_food_chg `z' `x2' i.iso_num i.month i.year, cl(iso_num)

esttab ols fe1 fe2 fe3 prais, keep(`z' f_grinst f_dry_mscp9 `x2') sca(N N_clust r2 r2_a r2_w r2_b r2_o rho dw dw_0) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti
	
esttab ols fe1 fe2 fe3 using "results/fs_results.tex", keep(`z' `x2' f_grinst f_dry_mscp9) alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N r2_a, fmt(0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Adjusted \(R^{2}\)"')) addn("$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "Models (2), (3), and (4) include country, year, and calendar month fixed effects.") nonote wrap lab lz nogap nomti bookt replace	

*Models (2), (3), and (4) include country, year, and calendar month fixed effects; Models (3) and (4) include additional control variables (National elections; Polity IV democracy; Polity IV autocracy; Occurrence of armed conflict (UCDP); Occurrence of armed conflict (UCDP); Population; Population Growth; Urban Population; Youth Population; GDP per capita; Life expectancy; Infant mortality rate)

*********************** SUMMARY STATISTICS ****************
use "data/feeding_unrest_africa.dta", clear
eststo clear
loc varlist "unrest std_food_chg grinst l_dry_mscp9 l_wet_mscp6 pwheamt_chg pricenpq_chg pmaizmt_chg elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort"

quietly regress `varlist' l_unrest
gen samp = e(sample)

estpost tabstat `varlist' if samp == 1, statistics(count mean sd min max) col(s)

esttab, cells("mean(fmt(%5.3f)) sd(fmt(%5.3f)) min(fmt(%5.3g)) max(fmt(%5.3g))")  nogap nomtitle nonumber nogaps lab

esttab using "results/sumstats.tex", cells("mean(fmt(%5.3f)) sd(fmt(%5.3f)) min(fmt(%5.3g)) max(fmt(%5.3g))") wrap lab lz nogap nomtitle nonumber bookt replace

*********************** FIXED EFFECTS MODELS ****************
eststo clear
foreach dv in "unrest" {
	loc x1 "l_`dv'"
	loc x2 "l_`dv' elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
	loc iv ""
	loc z "grinst l_dry_mscp9 l_wet_mscp6"

	*********************** XTREG **********************
	eststo A1: quietly xtreg `dv' std_food_chg `z' `x1' i.month i.year, fe cl(iso_num)
	eststo A2: quietly xtreg `dv' std_food_chg `z' `x2' i.month i.year, fe cl(iso_num)
		
	*********************** IV - grinst *******************
	loc iv "grinst"
	loc z "l_dry_mscp9 l_wet_mscp6"
	eststo A3: quietly xtivreg28 `dv' `z' `x1' m2-m12 y2-y22 (std_food_chg = `iv'), fe cl(iso_num) fwl(m2-m12 y2-y22)
	eststo A4: quietly xtivreg28 `dv' `z' `x2' m2-m12 y2-y22 (std_food_chg = `iv'), fe cl(iso_num) fwl(m2-m12 y2-y22)
	
	*********************** IV - MSCP *****************
	loc iv "l_dry_mscp9"
	loc z "grinst l_wet_mscp6"
	eststo A5: quietly xtivreg28 `dv' `z' `x1' m2-m12 y2-y22 (std_food_chg = `iv'), fe cl(iso_num) fwl(m2-m12 y2-y22)
	eststo A6: quietly xtivreg28 `dv' `z' `x2' m2-m12 y2-y22 (std_food_chg = `iv'), fe cl(iso_num) fwl(m2-m12 y2-y22)
	
	*********************** IV - BOTH *****************
	loc iv "grinst l_dry_mscp9"
	loc z "l_wet_mscp6"
	eststo A7: quietly xtivreg28 `dv' `z' `x1' m2-m12 y2-y22 (std_food_chg = `iv'), fe cl(iso_num) fwl(m2-m12 y2-y22)
	eststo A8: quietly xtivreg28 `dv' `z' `x2' m2-m12 y2-y22 (std_food_chg = `iv'), fe cl(iso_num) fwl(m2-m12 y2-y22)
		
	*********************** RESULTS *****************
	display "************ Fixed Effects Model Results - DV = `dv' ************"
	esttab A1 A2 A3 A4 A5 A6 A7 A8, keep(std_food_chg `iv' `z' `x2' ) sca(N N_clust r2_a ll idstat idp cdf j jp) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti
	
	*esttab A1 A2 A3 A4 A5 A6 A7 A8 using "results/xt_`dv'_results.tex", keep(std_food_chg `iv' `z' `x2') alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N r2_a ll idstat idp j jp cdf, fmt(0 3 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Adjusted \(R^{2}\)"' `"Log psuedolikelihood"' `"Anderson cannon. corr. LR"' `"Anderson LR \(X^{2}\) p-value"' `"Hansen\'s J"' `"Hansen\'s J \(X^{2}\) p-value"' `"Cragg-Donald F"')) addn("$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "All models include country, year, and calendar month fixed effects.") nonote lab lz nogap nomti bookt replace
	
	esttab A2 A4 A6 A8 using "results/xt_`dv'_results.tex", keep(std_food_chg `iv' `z' `x1') alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N r2_a ll idstat idp j jp cdf, fmt(0 3 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Adjusted \(R^{2}\)"' `"Log psuedolikelihood"' `"Anderson cannon corr LR"' `"Anderson LR \(X^{2}\) p-value"' `"Hansen J"' `"Hansen J \(X^{2}\) p-value"' `"Cragg-Donald F"')) addn("$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "All models include country, year, and calendar month fixed effects as well as all"  "control variables: national elections; Polity IV democracy and autocracy; UCDP"  "occurrence of armed conflict; total population; population growth; youth popula-"  "tion; urban population; GDP per capita; life expectancy; and infant mortality.") nonote wrap lab lz nogap nomti bookt replace

*(National elections; Polity IV democracy; Polity IV autocracy; Occurrence of armed conflict (UCDP); Occurrence of armed conflict (UCDP); Population; Population Growth; Urban Population; Youth Population; GDP per capita; Life expectancy; Infant mortality rate)) 	

*	esttab A1 A2 A3 A4 A5 A6 A7 A8 using "results/xt_`dv'_results.csv", replace keep(std_food_chg `iv' `z' `x2' ) sca(N N_clust r2_a ll idstat idp cdf j jp) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti lab ti(Table x: Fixed Effects Model Results - DV = `dv') nonote addn(Cluster robust standard errors reported in parentheses; + p < .1; * p < .05; ** p < .01) 
	}

foreach dv in "violence" "demo" "riot" "spon" "org" "strike" "etype2" "etype4" "etype8" {
	loc x1 "l_unrest"
	loc x2 "l_`dv' elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
	loc iv ""
	loc z "grinst l_dry_mscp9 l_wet_mscp6"

	*********************** IV - BOTH *****************
	loc iv "grinst l_dry_mscp9"
	loc z "l_wet_mscp6"
	eststo `dv'_1: quietly xtivreg28 `dv' `z' `x1' m2-m12 y2-y22 (std_food_chg = `iv'), fe robust
	eststo `dv'_2: quietly xtivreg28 `dv' `z' `x2' m2-m12 y2-y22 (std_food_chg = `iv'), fe robust
	}

*********************** PROBIT MODELS ***********************
eststo clear
foreach dv in "unrest" {
	loc x1 "l_`dv'"
	loc x2 "l_`dv' elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
	loc iv ""
	loc z "grinst l_dry_mscp9 l_wet_mscp6"

	*********************** PROBIT **********************
	eststo B1: quietly probit `dv' std_food_chg `z' l_`dv' i.iso_num i.year i.month, cl(iso_num) nolog
	parmest, sa(B1, replace)
	eststo B2: quietly probit `dv' std_food_chg `z' `x2' i.iso_num i.month i.year, cl(iso_num) nolog
	parmest, sa(B2, replace)
	
	*********************** IV - `grain' ********************
	loc iv "grinst"
	loc z "l_dry_mscp9 l_wet_mscp6"
	eststo B3: quietly ivprobit `dv' `z' l_`dv' i.iso_num i.month i.year (std_food_chg = `iv'), cl(iso_num) nolog
	parmest, sa(B3, replace)
	eststo B4: quietly ivprobit `dv' `z' `x2' i.iso_num i.month i.year (std_food_chg = `iv'), cl(iso_num) nolog
	parmest, sa(B4, replace)
	
	*********************** IV - MSCP *****************
	loc iv "l_dry_mscp9"
	loc z "grinst l_wet_mscp6"
	eststo B5: quietly ivprobit `dv' `z' l_`dv' i.iso_num i.month i.year (std_food_chg = `iv'), cl(iso_num) nolog
	parmest, sa(B5, replace)
	eststo B6: quietly ivprobit `dv' `z' `x2' i.iso_num i.month i.year (std_food_chg = `iv'), cl(iso_num) nolog
	parmest, sa(B6, replace)
	
	*********************** IV - BOTH *****************
	loc iv "grinst l_dry_mscp9"
	loc z "l_wet_mscp6"
	eststo B7: quietly ivprobit `dv' `z' l_`dv' i.iso_num i.month i.year (std_food_chg = `iv'), cl(iso_num) nolog
	parmest, sa(B7, replace)
	eststo B8: quietly ivprobit `dv' `z' `x2' i.iso_num i.month i.year (std_food_chg = `iv'), cl(iso_num) nolog
	parmest, sa(B8, replace)
	
	*********************** PROBIT RESULTS *****************
	display "**************** Probit Model Results - DV = `dv' ****************"
	esttab B1 B2 B3 B4 B5 B6 B7 B8, eform keep(std_food_chg `iv' `z' `x2' ) sca(N N_clust r2_a ll chi2 p chi2_exog p_exog) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti
	
	*esttab B1 B2 B3 B4 B5 B6 B7 B8 using "results/probit_`dv'_results.tex", keep(std_food_chg `iv' `z' `x2') eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N ll chi2 p chi2_exog p_exog, fmt(0 0 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Log psuedolikelihood"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"' `"Wald \(X^{2}\) test of exogeneity"' `"Exogeneity \(X^{2}\) p-value"')) addn("Odds ratios reported"  "$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "All models include country, year, and calendar month fixed effects.") nonote lab lz nogap nomti bookt replace	

	esttab B2 B4 B6 B8 using "results/probit_`dv'_results.tex", keep(std_food_chg `iv' `z' `x2') eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N ll chi2 p chi2_exog p_exog, fmt(0 0 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Log psuedolikelihood"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"' `"Wald \(X^{2}\) test of exogeneity"' `"Exogeneity \(X^{2}\) p-value"')) addn("Odds ratios reported"  "$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "All models include country, year, and calendar month fixed effects.") nonote wrap lab lz nogap nomti bookt replace	

	*esttab B1 B2 B3 B4 B5 B6 B7 B8 using "results/probit_`dv'_results.csv", eform keep(std_food_chg `iv' `z' `x2' ) sca(N N_clust r2_a ll chi2 p chi2_exog p_exog) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti lab ti(Table x: Probit Model Results - DV = `dv') nonote addn(Odds ratios reported; cluster robust standard errors reported in parentheses; + p < .1; * p < .05; ** p < .01) replace
	
	*esttab B1 B2 B3 B4 B5 B6 B7 B8 using "results/probit_`dv'_results.csv", keep(std_food_chg `iv' `z' `x2' ) sca(N N_clust r2_a ll chi2 p chi2_exog p_exog) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti lab ti(Table x: Probit Model Results - DV = `dv') nonote addn(Odds ratios reported; cluster robust standard errors reported in parentheses; + p < .1; * p < .05; ** p < .01) append
	
	use B1.dta, clear
	gen B1 = 1
	foreach m in B2 B3 B4 B5 B6 B7 B8 {
		append using `m'.dta, gen(`m')
		}
	save results/`dv'_probit_results.dta, replace
	foreach m in B1 B2 B3 B4 B5 B6 B7 B8 {
		erase `m'.dta
		}
	}

use "data/feeding_unrest_africa.dta", clear
foreach dv in "violence" "demo" "riot" "spon" "org" "strike" "etype2" "etype4" "etype8" {
	loc iv "grinst l_dry_mscp9"
	loc z "l_wet_mscp6"
	loc x1 "l_unrest"
	loc x2 "l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
	eststo `dv'_1: quietly ivprobit `dv' `z' `x1' i.iso_num i.month i.year (std_food_chg = `iv'), cl(iso_num)  nolog
	parmest, sa(`dv'_1, replace)
	eststo `dv'_2: quietly ivprobit `dv' `z' `x2' i.iso_num i.month i.year (std_food_chg = `iv'), cl(iso_num)  nolog
	parmest, sa(`dv'_2, replace)
	}

display "**************** Probit Model Results by unrest type ****************"
esttab violence_1 demo_1 riot_1 spon_1 org_1 strike_1 etype2_1 etype4_1 etype8_1, eform keep(std_food_chg `iv' `z' `x1' ) sca(N N_clust r2_a ll chi2 p chi2_exog p_exog) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti

*esttab violence_1 demo_1 riot_1 spon_1 org_1 strike_1 etype2_1 etype4_1 etype8_1 using "results/probit_subtypes1_results.csv", eform keep(std_food_chg `iv' `z' `x1') sca(N N_clust r2_a ll chi2 p chi2_exog p_exog) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti lab ti(Table x: Probit Model Results - DV = `dv') nonote addn(Odds ratios reported; cluster robust standard errors reported in parentheses; + p < .1; * p < .05; ** p < .01) replace
	
*esttab violence_2 demo_2 riot_2 spon_2 org_2 strike_2 etype2_2 etype4_2 etype8_2, eform keep(std_food_chg `iv' `z' `x2' ) sca(N N_clust r2_a ll chi2 p chi2_exog p_exog) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti

esttab violence_2 riot_2 spon_2 etype4_2 etype2_2 demo_2 org_2 strike_2 using "results/probit_subtypes1_results.tex", keep(std_food_chg `iv' `z' l_unrest elections democ autoc) eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N ll chi2 p chi2_exog p_exog, fmt(0 0 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Log psuedolikelihood"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"' `"Wald \(X^{2}\) test of exogeneity"' `"Exogeneity \(X^{2}\) p-value"')) addn("$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "All models include country, year, and calendar month fixed effects and unreported covariates.") nonote lab lz nogap nomti bookt replace	

*esttab violence_2 demo_2 riot_2 spon_2 org_2 strike_2 etype2_2 etype4_2 etype8_2 using "results/probit_subtypes2_results.csv", eform keep(std_food_chg `iv' `z' `x2') sca(N N_clust r2_a ll chi2 p chi2_exog p_exog) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti lab ti(Table x: Probit Model Results - DV = `dv') nonote addn(Odds ratios reported; cluster robust standard errors reported in parentheses; + p < .1; * p < .05; ** p < .01) replace

use violence_1.dta, clear
gen violence_1 = 1
append using violence_2, gen(violence_2)
foreach dv in "demo" "riot" "spon" "org" "strike" "etype2" "etype4" "etype8" {
	append using `dv'_1.dta, gen(`dv'_1)
	append using `dv'_2.dta, gen(`dv'_2)
	}
save results/probit_results_by_type.dta, replace

use "data/feeding_unrest_africa.dta", clear
reg unrest std_food_chg grinst l_dry_mscp9 l_wet_mscp6 l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort
gen sample = e(sample)
drop if sample != 1
collapse (sum) violence demo riot spon org strike etype2 etype4
rename violence success1
rename demo success6
rename riot success2
rename spon success3
rename org success7
rename strike success8
rename etype2 success5
rename etype4 success4
gen ob = 1
reshape long success, i(ob) j(outcome)
drop ob
save results/outcome_table.dta, replace
*/
use results/probit_results_by_type.dta, clear
drop if parm != "std_food_chg"
foreach var of varlist violence_1 demo_1 riot_1 spon_1 org_1 strike_1 etype2_1 etype4_1 etype8_1 etype8_2 {
	drop if `var' == 1
	}
gen outcome = 1
replace outcome = 6 if demo_2 == 1
replace outcome = 2 if riot_2 == 1
replace outcome = 3 if spon_2 == 1
replace outcome = 7 if org_2 == 1
replace outcome = 8 if strike_2 == 1
replace outcome = 5 if etype2_2 == 1
replace outcome = 4 if etype4_2 == 1
lab def outcome ///
	1 "Violent Unrest (1101)" ///
	2 "Riots (657)" ///
	3 "Spontaneous Events (1415)" ///
	4 "Spontaneous Violent Riots (590)" ///
	6 "Spontaneous Demonstrations (938)" ///
	5 "Demonstrations (1411)" ///
	7 "Organized Events (647)" ///
	8 "Strikes (939)"
lab val outcome outcome
*drop eq parm min95 max95 violence_1 - etype8_2
gen star = ""
replace star = "\sym{+}" if p < .1
replace star = "\sym{*}" if p < .05
replace star = "\sym{**}" if p < .01
gen or = exp(estimate)
*replace stderr = exp(stderr)
*replace or = round(or,.001)
format or stderr %4.3f
*tostring or, replace force u
*replace or = or + star
merge 1:1 outcome using results/outcome_table.dta
*drop estimate stderr z p star _merge
drop _merge
sort outcome
lab var outcome "Type of unrest"
lab var success "Country-months with unrest type"
lab var or "Effect of a one sd spike in food prices (odds ratio)"
drop violence_1- etype8_2
replace or = (or - 1) * 100
gen or_min = (exp(min95) - 1) * 100
gen or_max = (exp(max95) - 1) * 100
format or_min or_max %4.3f

gen sig_01 = or
replace sig_01 = . if (abs(estimate) - (2.576 * stderr)) < 0
lab var sig_01 "significant at alpha = 0.01"
gen sig_05 = estimate
replace sig_05 = . if (abs(estimate) - (1.96 * stderr)) < 0
lab var sig_05 "significant at alpha = 0.05"
replace sig_05 = . if sig_01 != .
replace or = . if sig_01 != . | sig_05 != .

twoway (rcap or_min or_max outcome, lcolor(dkgreen) horizontal) ///
	(scatter outcome or, msymbol(small_circle) mlcolor(dkgreen) mfcolor(white) msize(medium))  ///
	(scatter outcome sig_05, msymbol(circle) mcolor(dkgreen) msize(medium))  ///
	(scatter outcome sig_01, msymbol(circle) mcolor(dkorange) msize(medium)), ///
	ytitle(, size(zero)) ///
	yscale(reverse) ///
	ylabel(1(1)8, valuelabel angle(horizontal) labsize(medsmall) noticks) ///
	xtitle("Marginal percentage change in the odds of unrest", size(vsmall)) ///
	xtitle(, size(medsmall) margin(small)) ///
	xlabel(, format(%9.0f) grid labsize(small)) xmtick(##5) ///
	legend(cols(4) size(small) region(lcolor(none)) order(1 "95% confidence interval" 3 "significant at alpha = 0.05" 4 "significant at alpha = 0.01") span) ///
	title("Effect of Changes in Food Prices by Unrest Type", size(medium) margin(medsmall) span) ///
	xsize(5) ysize(3) scheme(s1color) name(`dv'_food_chg_color, replace)
*graph export "graphs/marg_eff_outcome_color.pdf", replace

exit

decode outcome, gen(type)
order type success or
drop outcome
gen end = "\\"
export delimited using "results/outcome_table.tex", delimiter("&") novarnames replace
exit
foreach dv in "violence" "demo" "riot" "spon" "org" "strike" "etype2" "etype4" "etype8" {
	erase `dv'_1.dta
	erase `dv'_2.dta
	}

*************** ROBUSTNESS CHECKS ***************
eststo clear
use "data/feeding_unrest_africa.dta", clear
loc dv "unrest"
loc x1 "l_unrest"
loc x2 "l_`dv' elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
loc iv "grinst l_dry_mscp9"
loc z "l_wet_mscp6"

***** NO FIXED EFFECTS NO CONTROLS *****
eststo base: quietly ivprobit `dv' `z' `x1' (std_food_chg = `iv'), cl(iso_num) nolog
parmest, sa(base, replace)

***** NO FIXED EFFECTS *****
eststo nofe: quietly ivprobit `dv' `z' `x2' (std_food_chg = `iv'), cl(iso_num) nolog
parmest, sa(nofe, replace)

***** EXCLUDE EGYPT, SOUTH AFRICA AND NIGERIA *****
eststo zaegng: quietly ivprobit `dv' `z' `x2' i.iso_num i.month y1-y7 y9-y22 (std_food_chg = `iv') if iso_num != 818 & iso_num != 710 & iso_num != 566, cl(iso_num) nolog
parmest, sa(zaegng, replace)

*********************** POST 1997 ***********************
eststo post97: quietly ivprobit `dv' `z' `x2' i.iso_num i.month y9-y22 (std_food_chg = `iv') if year > 1997, cl(iso_num) nolog first
parmest, sa(post97, replace)

*********************** PRE 2007 ***********************
eststo pre2007: quietly ivprobit `dv' `z' `x2' i.iso_num i.month y1-y7 y9-y22 (std_food_chg = `iv') if year < 2007, cl(iso_num) nolog first
parmest, sa(pre2007, replace)

*********************** USING GPCP ***********************
loc iv1 "grinst"
loc iv2 "l_GPCP_dry9"
loc z "l_GPCP_wet6"
eststo gpcp: quietly ivprobit `dv' `z' `x2' i.iso_num i.month y1-y7 y9-y22 (std_food_chg = `iv1' `iv2'), cl(iso_num) nolog first
parmest, sa(gpcp, replace)

*********************** USING DRY MSCP 6 MONTH ***********************
loc iv1 "grinst"
loc iv2 "l_dry_mscp6"
loc z "l_wet_mscp6"
eststo mscp6:  quietly ivprobit `dv' `z' `x2' i.iso_num i.month y1-y7 y9-y22 (std_food_chg = `iv1' `iv2'), cl(iso_num) nolog first
parmest, sa(mscp6, replace)

*********************** USING DRY MSCP 12 MONTH ***********************
loc iv2 "l_dry_mscp12"
loc z "l_wet_mscp6"
eststo mscp12: quietly ivprobit `dv' `z' `x2' i.iso_num i.month y1-y7 y9-y22 (std_food_chg = `iv1' `iv2'), cl(iso_num) nolog first
parmest, sa(mscp12, replace)

display "******************* Robustness Checks - DV = `dv' *******************"
esttab base nofe zaegng post97 pre2007 mscp6 mscp12 gpcp, eform keep(std_food_chg `iv' `iv2' `z' l_GPCP_dry9 l_GPCP_wet6 l_dry_mscp6 l_dry_mscp12 `x2') sca(N N_clust ll chi2_exog p_exog) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti

esttab base nofe zaegng post97 pre2007 mscp6 mscp12 gpcp using "results/`dv'_rc_results.tex", keep(std_food_chg `iv' `z' l_GPCP_dry9 l_GPCP_wet6 l_dry_mscp6 l_dry_mscp12 `x2') eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N ll chi2 p chi2_exog p_exog, fmt(0 0 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Log psuedolikelihood"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"' `"Wald \(X^{2}\) test of exogeneity"' `"Exogeneity \(X^{2}\) p-value"')) addn("$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses.") nonote wrap lab lz nogap nomti bookt replace	

*esttab base nofe zaegng post97 pre2007 mscp6 mscp12 gpcp using "results/`dv'_rc_results.csv", eform keep(std_food_chg `iv' `z' l_GPCP_dry9 l_GPCP_wet6 l_dry_mscp6 l_dry_mscp12 `x2') sca(N N_clust ll chi2_exog p_exog) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti lab ti(Table x: Robustness Checks of IV Probit Results (DV = Unrest; Instruments = trade balance adjusted commodity price instrument & dry MSCP over 9 months (lagged))) nonote addn(Odds ratios reported; cluster robust standard errors reported in parentheses; + p < .1; * p < .05; ** p < .01) replace

*esttab base nofe zaegng post97 pre2007 mscp6 mscp12 gpcp using "results/`dv'_rc_results_first_stage.csv", keep(std_food_chg `iv' `z' l_GPCP_dry9 l_GPCP_wet6 l_dry_mscp6 l_dry_mscp12 `x2') sca(N N_clust ll chi2_exog p_exog) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti lab ti(Table x: Robustness Checks of IV Probit Results (DV = Unrest; Instruments = trade balance adjusted commodity price instrument & dry MSCP over 9 months (lagged))) nonote addn(Odds ratios reported; cluster robust standard errors reported in parentheses; + p < .1; * p < .05; ** p < .01) replace

use base.dta, clear
gen base = 1
foreach m in nofe zaegng post97 pre2007 gpcp mscp12 {
	append using `m'.dta, gen(`m')
	}
save "results/`dv'_rc_estimates.dta", replace
foreach m in base nofe zaegng post97 pre2007 gpcp mscp12 {
	erase `m'.dta
	}


log close
exit

*** ALTERNATIVE COMMANDS OF IV REGRESSSION PROVIDING ANDERSON-RUBIN TESTS ***
condivreg unrest grinst l_wet_mscp6 l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort m2-m12 y2-y22 i1-i9 i11-i29 i31-i41 (std_food_chg = l_dry_mscp9), ar

condivreg unrest l_dry_mscp9 l_wet_mscp6 l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort m2-m12 y2-y22 i1-i9 i11-i29 i31-i41 (std_food_chg = grinst), ar

condivreg unrest l_wet_mscp6 l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort m2-m12 y2-y22 i1-i9 i11-i29 i31-i41 (std_food_chg = grinst l_dry_mscp9), ar

xtivreg2 unrest grinst l_wet_mscp6 l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort m2-m12 y2-y22 (std_food_chg = l_dry_mscp9), fe cl(iso_num) fwl(m2-m12 y2-y22) first

xtivreg2 unrest l_dry_mscp9 l_wet_mscp6 l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort m2-m12 y2-y22 (std_food_chg = grinst), fe cl(iso_num) fwl(m2-m12 y2-y22) first

xtivreg2 unrest l_wet_mscp6 l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort m2-m12 y2-y22 (std_food_chg = grinst l_dry_mscp9), fe cl(iso_num) fwl(m2-m12 y2-y22) first

far unrest grinst l_wet_mscp6 l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort m2-m12 y2-y22 i1-i9 i11-i29 i31-i41 (std_food_chg = l_dry_mscp9)

far unrest l_dry_mscp9 l_wet_mscp6 l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort m2-m12 y2-y22 i1-i9 i11-i29 i31-i41 (std_food_chg = grinst)

far unrest l_wet_mscp6 l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort m2-m12 y2-y22 i1-i9 i11-i29 i31-i41 (std_food_chg = grinst l_dry_mscp9), reps(100000) ci

*** BASE SPECIFICATION ***
ivprobit unrest l_wet_mscp6 l_unrest (std_food_chg = grinst l_dry_mscp9), cl(iso_num) first nolog

*** WITH COUNTRY, YEAR, AND MONTH FIXED EFFECTS ***
ivprobit unrest l_wet_mscp6 l_unrest i.iso_num i.month i.year (std_food_chg = grinst l_dry_mscp9), cl(iso_num) first nolog
estat classification

*** WITH CONTROL VARIABLES ***
ivprobit unrest l_wet_mscp6 l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort (std_food_chg = grinst l_dry_mscp9), cl(iso_num) first nolog

*** WITH FIXED EFFECTS AND CONTROL VARIABLES ***
ivprobit unrest l_wet_mscp6 l_unrest elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort i.iso_num i.month i.year (std_food_chg = grinst l_dry_mscp9), cl(iso_num) first nolog
estat classification

*** ivpoisson ***
ivpoisson gmm events l_wet_mscp6 l_events i.iso_num i.month y2-y22 (std_food_chg = grinst l_dry_mscp9)
