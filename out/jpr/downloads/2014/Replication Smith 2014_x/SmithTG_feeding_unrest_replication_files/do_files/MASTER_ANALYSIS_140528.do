********** FEEDING UNREST IN AFRICA **********
********** WRITTEN BY TODD G. SMITH ***********
********** UPDATED 28 MAY 2014 **************


clear all
set more off
set matsize 1200
set linesize 149

local date	"`c(current_date)'"
local user  "`c(username)'"

cd "/Users/`user'/Documents/Active_Projects/Feeding_Unrest_Africa/analysis"

capture log close
log using "logs/Feeding Unrest in Africa analysis `date'.txt", text replace

***** RECODE AND MERGE DATA TOGETHER ...
*quietly do "do_files/DATASET_COMPILATION_140528.do"

capture program drop classadd
program classadd
	estat classification
	estadd scalar pos = r(P_1p)
	estadd scalar neg = r(P_0n)
	estadd scalar spec = r(P_n0)
	estadd scalar sens = r(P_p1)
	estadd scalar corr = r(P_corr)
end

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
loc x2 "l_unrest elections democ autoc ucdp pop  pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
loc z "grinst l_dry_mscp9 l_wet_mscp6"
gen f_grinst = f.grinst
gen f_dry_mscp9 = f.dry_mscp9
lab var f_grinst "Trade bal adj grain price instrument (t+1)"
lab var f_dry_mscp9 "9 month dry MSCP (t+1)"

eststo ols: quietly reg std_food_chg `z' `x1', cl(iso_num)
capture drop sample
gen sample = e(sample)
eststo fe0: quietly xtreg std_food_chg grinst l_dry_mscp9 i.month i.year, fe cl(iso_num)
eststo fe1: quietly xtreg std_food_chg `z' `x1' i.month i.year, fe cl(iso_num)
eststo fe2: quietly xtreg std_food_chg `z' `x2' i.month i.year, fe cl(iso_num)
eststo fe3: quietly xtreg std_food_chg `z' `x2' f_grinst f_dry_mscp9 i.month i.year, fe cl(iso_num)
eststo prais: quietly prais std_food_chg `z' `x2' i.iso_num i.month i.year, cl(iso_num)

esttab ols fe1 fe2 fe3 prais, keep(`z' f_grinst f_dry_mscp9 `x2') sca(N N_clust r2 r2_a r2_w r2_b r2_o rho dw dw_0) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti
	
esttab fe0 fe1 fe2 fe3 using "results/fs_results.tex", keep(`z' `x2' f_grinst f_dry_mscp9) alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N r2_a, fmt(0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Adjusted \(R^{2}\)"')) addn("$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "Models (2), (3), and (4) include country, year, and calendar month fixed effects.") nonote wrap lab lz nogap nomti bookt replace	

*********************** SUMMARY STATISTICS ****************
use "data/feeding_unrest_africa.dta", clear
eststo clear
loc varlist "unrest std_food_chg grinst dry_mscp9 wet_mscp6 pwheamt_chg pricenpq_chg pmaizmt_chg elections democ autoc ucdp pop  pop_growth pct_urb pct_youth gdppc life_exp inf_mort"

quietly regress `varlist' l_unrest
gen samp = e(sample)

estpost tabstat `varlist' if samp == 1, statistics(count mean sd min max) col(s)

esttab, cells("mean(fmt(%5.3f)) sd(fmt(%5.3f)) min(fmt(%5.3g)) max(fmt(%5.3g))")  nogap nomtitle nonumber nogaps lab

esttab using "results/sumstats.tex", cells("mean(fmt(%5.3f)) sd(fmt(%5.3f)) min(fmt(%5.3g)) max(fmt(%5.3g))") wrap lab lz nogap nomtitle nonumber bookt replace

*********************** FIXED EFFECTS MODELS ****************
eststo clear

loc x "l_unrest l_wet_mscp6 elections democ autoc ucdp pop  pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
loc iv ""
loc z "grinst l_dry_mscp9"

*********************** XTREG **********************
eststo A1: quietly xtreg unrest std_food_chg i.month i.year, fe cl(iso_num)
estadd local ctrls "yes"
eststo A2: quietly xtreg unrest std_food_chg `z' `x' i.month i.year, fe cl(iso_num)
estadd local ctrls "yes"

*********************** IV - grinst *******************
loc iv "grinst"
loc z "l_dry_mscp9 l_wet_mscp6"
eststo A3: quietly xtivreg28 unrest m2-m12 y2-y22 (std_food_chg = `iv'), fe cl(iso_num) fwl(m2-m12 y2-y22)
estadd local ctrls "no"
eststo A4: quietly xtivreg28 unrest `z' `x' m2-m12 y2-y22 (std_food_chg = `iv'), fe cl(iso_num) fwl(m2-m12 y2-y22)
estadd local ctrls "yes"

*********************** IV - MSCP *****************
loc iv "l_dry_mscp9"
loc z "grinst l_wet_mscp6"
eststo A5: quietly xtivreg28 unrest m2-m12 y2-y22 (std_food_chg = `iv'), fe cl(iso_num) fwl(m2-m12 y2-y22)
estadd local ctrls "no"
eststo A6: quietly xtivreg28 unrest `z' `x' m2-m12 y2-y22 (std_food_chg = `iv'), fe cl(iso_num) fwl(m2-m12 y2-y22)
estadd local ctrls "yes"

*********************** IV - BOTH *****************
loc iv "grinst l_dry_mscp9"
loc z "l_wet_mscp6"
eststo A7: quietly xtivreg28 unrest m2-m12 y2-y22 (std_food_chg = `iv'), fe cl(iso_num) fwl(m2-m12 y2-y22)
estadd local ctrls "no"
eststo A8: quietly xtivreg28 unrest `z' `x' m2-m12 y2-y22 (std_food_chg = `iv'), fe cl(iso_num) fwl(m2-m12 y2-y22)
estadd local ctrls "yes"
	
*********************** RESULTS *****************
display "************ Fixed Effects Model Results - DV = unrest ************"
esttab A1 A2 A3 A4 A5 A6 A7 A8, keep(std_food_chg `iv' `z' `x' ) sca(N N_clust r2_a ll idstat idp cdf j jp) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti
	
esttab A2 A4 A6 A8 using "results/xt_unrest_results.tex", keep(std_food_chg `iv' `z') alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(ctrls N r2_a ll idstat idp j jp cdf, fmt(0 0 3 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Unreported covariates"' `"Observations"' `"Adjusted \(R^{2}\)"' `"Log psuedolikelihood"' `"Anderson cannon corr LR"' `"Anderson LR \(X^{2}\) p-value"' `"Hansen J"' `"Hansen J \(X^{2}\) p-value"' `"Cragg-Donald F"')) addn("$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "All models include year, and calendar month fixed effects"  "Unreported covariates: national elections; Polity IV democracy and autocracy; UCDP occurrence of"  "armed conflict; total population; population growth; youth population; urban population; GDP per"  "capita; life expectancy; and infant mortality.") nonote varwidth(48) wrap lab lz nogap nomti bookt replace

foreach dv in "violence" "demo" "riot" "spon" "org" "strike" "etype2" "etype4" "etype8" {
	loc x "l_`dv' l_wet_mscp6 elections democ autoc ucdp pop  pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
	loc iv ""
	loc z "grinst l_dry_mscp9"

	*********************** IV - BOTH *****************
	loc iv "grinst l_dry_mscp9"
	loc z ""
	eststo `dv'_1: quietly xtivreg28 `dv' `z' m2-m12 y2-y22 (std_food_chg = `iv'), fe robust
	eststo `dv'_2: quietly xtivreg28 `dv' `z' `x' m2-m12 y2-y22 (std_food_chg = `iv'), fe robust
	}

*********************** PROBIT MODELS ***********************
eststo clear

loc x "l_unrest l_wet_mscp6 elections democ autoc ucdp pop  pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
loc iv ""
loc z "grinst l_dry_mscp9"
capture drop sample
quietly probit unrest std_food_chg `z' `x' i.iso_num i.month i.year, cl(iso_num) nolog
gen sample = e(sample)

*********************** PROBIT **********************
eststo B0: quietly probit unrest std_food_chg if sample == 1, cl(iso_num) nolog
parmest, sa(B0, replace)
classadd
estadd local fe "no"

eststo B0b: quietly probit unrest std_food_chg i.iso_num i.month i.year if sample == 1, cl(iso_num) nolog
parmest, sa(B0b, replace)
classadd
estadd local fe "yes"

eststo B1: quietly probit unrest std_food_chg `z' l_unrest l_wet_mscp6 if sample == 1, cl(iso_num) nolog
parmest, sa(B1, replace)
classadd
estadd local fe "no"

eststo B1b: quietly probit unrest std_food_chg `z' l_unrest l_wet_mscp6 i.iso_num i.month i.year if sample == 1, cl(iso_num) nolog
parmest, sa(B1b, replace)
classadd
estadd local fe "yes"

eststo B2: quietly probit unrest std_food_chg `z' `x' if sample == 1, cl(iso_num) nolog
parmest, sa(B2, replace)
classadd
estadd local fe "no"

eststo B2b: quietly probit unrest std_food_chg `z' `x' i.iso_num i.month i.year if sample == 1, cl(iso_num) nolog
parmest, sa(B2, replace)
classadd
estadd local fe "yes"

*********************** IV - GRINST ********************
loc iv "grinst"
loc z "l_dry_mscp9"
eststo B3: quietly ivprobit unrest i.iso_num i.month i.year (std_food_chg = `iv') if sample == 1, cl(iso_num) nolog
parmest, sa(B3, replace)
classadd
estadd local fe "yes"

eststo B3b: quietly ivprobit unrest `z' l_unrest l_wet_mscp6 i.iso_num i.month i.year (std_food_chg = `iv') if sample == 1, cl(iso_num) nolog
parmest, sa(B3b, replace)
classadd
estadd local fe "yes"

eststo B4: quietly ivprobit unrest `z' `x' i.iso_num i.month i.year (std_food_chg = `iv') if sample == 1, cl(iso_num) nolog
parmest, sa(B4, replace)
classadd
estadd local fe "yes"

*********************** IV - MSCP *****************
loc iv "l_dry_mscp9"
loc z "grinst"
eststo B5: quietly ivprobit unrest i.iso_num i.month i.year (std_food_chg = `iv') if sample == 1, cl(iso_num) nolog
parmest, sa(B5, replace)
classadd
estadd local fe "yes"

eststo B5b: quietly ivprobit unrest `z' l_unrest l_wet_mscp6 i.iso_num i.month i.year (std_food_chg = `iv') if sample == 1, cl(iso_num) nolog
parmest, sa(B5b, replace)
classadd
estadd local fe "yes"

eststo B6: quietly ivprobit unrest `z' `x' i.iso_num i.month i.year (std_food_chg = `iv') if sample == 1, cl(iso_num) nolog
parmest, sa(B6, replace)
classadd
estadd local fe "yes"

*********************** IV - BOTH *****************
loc iv "grinst l_dry_mscp9"
loc z ""
eststo B7: quietly ivprobit unrest i.iso_num i.month i.year (std_food_chg = `iv') if sample == 1, cl(iso_num) nolog
parmest, sa(B7, replace)
classadd
estadd local fe "yes"

eststo B7b: quietly ivprobit unrest `z' l_unrest l_wet_mscp6 i.iso_num i.month i.year (std_food_chg = `iv') if sample == 1, cl(iso_num) nolog
parmest, sa(B7b, replace)
classadd
estadd local fe "yes"

eststo B8: quietly ivprobit unrest `x' i.iso_num i.month i.year (std_food_chg = `iv') if sample == 1, cl(iso_num) nolog
parmest, sa(B8, replace)
classadd
estadd local fe "yes"

*********************** PROBIT RESULTS *****************
display "**************** Probit Model Results - DV = unrest ****************"
esttab B0 B0b B1 B1b B2 B2b, eform keep(unrest:std_food_chg unrest:grinst unrest:l_dry_mscp9 unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort) sca(fe N N_clust ll pos neg corr aic bic chi2 p) noobs sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti

esttab B3 B3b B4 B5 B5b B6 B7 B7b B8, eform keep(unrest:std_food_chg unrest:grinst unrest:l_dry_mscp9 unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort) order(unrest:std_food_chg unrest:grinst unrest:l_dry_mscp9 unrest:l_unrest) sca(fe N N_clust ll pos neg corr aic bic chi2 p chi2_exog p_exog) noobs sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti

*********************** OUTPUT RESULTS TO LATEX *****************
esttab B2 B4 B6 B8 using "results/probit_unrest_results.tex", keep(unrest:std_food_chg unrest:grinst unrest:l_dry_mscp9 unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop  unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort) order(unrest:std_food_chg unrest:grinst unrest:l_dry_mscp9 unrest:l_unrest) eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(fe N ll pos neg corr chi2 p chi2_exog p_exog, fmt(0 0 0 2 2 2 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Country, year, \& calendar month fixed effects"' `"Observations"' `"Log psuedolikelihood"' `"Positive predictive value"' `"Negative predictive value"' `"Correctly classified"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"' `"Wald \(X^{2}\) test of exogeneity"' `"Exogeneity \(X^{2}\) p-value"')) addn("Odds ratios reported"  "$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses.") noobs nonote varwidth(48) wrap lab lz nogap nomti nodep bookt replace	

esttab B0 B0b B1 B1b B2 B2b using "results/probit_results_app.tex", keep(std_food_chg grinst l_dry_mscp9 l_unrest l_wet_mscp6 elections democ autoc ucdp pop pop_growth pct_urb pct_youth gdppc life_exp inf_mort) order(unrest:std_food_chg unrest:grinst unrest:l_dry_mscp9 unrest:l_unrest) eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(fe N ll pos neg corr chi2 p, fmt(0 0 0 2 2 2 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Country, year, \& cal month FE"' `"Observations"' `"Log psuedolikelihood"' `"Positive predictive value"' `"Negative predictive value"' `"Correctly classified"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"')) addn("Odds ratios reported"  "$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses.") nonote varwidth(27) wrap lab lz nogap nomti nodep bookt replace
	
*esttab B3 B3b B4 B5 B5b B6 B7 B7b B8 using "results/pr_unrest_res2_app.tex", keep(unrest:std_food_chg unrest:grinst unrest:l_dry_mscp9 unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop  unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort) order(unrest:std_food_chg unrest:grinst unrest:l_dry_mscp9 unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop  unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort) eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N ll pos neg corr chi2 p chi2_exog p_exog, fmt(0 0 2 2 2 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Log psuedolikelihood"' `"Positive predictive value"' `"Negative predictive value"' `"Correctly classified"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"' `"Wald \(X^{2}\) test of exogeneity"' `"Exogeneity \(X^{2}\) p-value"')) addn("Odds ratios reported"  "$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "All models include country, year, and calendar month fixed effects.") nonote varwidth(30) wrap lab lz nogap nomti nodep bookt replace

esttab B3 B3b B4 using "results/ivprob_results_app1.tex", keep(unrest:std_food_chg unrest:l_dry_mscp9 unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop  unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort) order(unrest:std_food_chg unrest:grinst unrest:l_dry_mscp9 unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop  unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort) eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N ll pos neg corr chi2 p chi2_exog p_exog, fmt(0 0 2 2 2 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Log psuedolikelihood"' `"Positive predictive value"' `"Negative predictive value"' `"Correctly classified"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"' `"Wald \(X^{2}\) test of exogeneity"' `"Exogeneity \(X^{2}\) p-value"')) addn("Odds ratios reported"  "$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "All models include country, year, and calendar month fixed effects.") nonote varwidth(48) wrap lab lz nogap nomti nodep bookt replace

esttab B5 B5b B6 using "results/ivprob_results_app2.tex", keep(unrest:std_food_chg unrest:grinst unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop  unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort) order(unrest:std_food_chg unrest:grinst unrest:l_dry_mscp9 unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop  unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort) eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N ll pos neg corr chi2 p chi2_exog p_exog, fmt(0 0 2 2 2 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Log psuedolikelihood"' `"Positive predictive value"' `"Negative predictive value"' `"Correctly classified"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"' `"Wald \(X^{2}\) test of exogeneity"' `"Exogeneity \(X^{2}\) p-value"')) addn("Odds ratios reported"  "$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "All models include country, year, and calendar month fixed effects.") nonote varwidth(48) wrap lab lz nogap nomti nodep bookt replace

esttab B7 B7b B8 using "results/ivprob_results_app3.tex", keep(unrest:std_food_chg unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop  unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort) order(unrest:std_food_chg unrest:grinst unrest:l_dry_mscp9 unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop  unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort) eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N ll pos neg corr chi2 p chi2_exog p_exog, fmt(0 0 2 2 2 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Log psuedolikelihood"' `"Positive predictive value"' `"Negative predictive value"' `"Correctly classified"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"' `"Wald \(X^{2}\) test of exogeneity"' `"Exogeneity \(X^{2}\) p-value"')) addn("Odds ratios reported"  "$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "All models include country, year, and calendar month fixed effects.") nonote varwidth(48) wrap lab lz nogap nomti nodep bookt replace

use B0.dta, clear
gen B0 = 1
foreach m in B0b B1 B1b B2 B3 B3b B4 B5 B5b B6 B7 B7b B8 {
	append using `m'.dta, gen(`m')
	}
save results/unrest_probit_results.dta, replace
foreach m in B0 B0b B1 B1b B2 B3 B3b B4 B5 B5b B6 B7 B7b B8 {
	erase `m'.dta
	}

use "data/feeding_unrest_africa.dta", clear
foreach dv in "violence" "demo" "riot" "spon" "org" "strike" "etype2" "etype4" "etype8" {
	loc iv "grinst l_dry_mscp9"
	loc z "l_wet_mscp6"
	loc x1 "l_unrest"
	loc x2 "l_unrest elections democ autoc ucdp pop  pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
	eststo `dv'_1: quietly ivprobit `dv' `z' `x1' i.iso_num i.month i.year (std_food_chg = `iv'), cl(iso_num)  nolog
	parmest, sa(`dv'_1, replace)
	eststo `dv'_2: quietly ivprobit `dv' `z' `x2' i.iso_num i.month i.year (std_food_chg = `iv'), cl(iso_num)  nolog
	parmest, sa(`dv'_2, replace)
	}

display "**************** Probit Model Results by unrest type ****************"
esttab violence_1 demo_1 riot_1 spon_1 org_1 strike_1 etype2_1 etype4_1 etype8_1, eform keep(std_food_chg grinst l_dry_mscp9 l_wet_mscp6 l_unrest) sca(N N_clust r2_a ll chi2 p chi2_exog p_exog) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) ml(, depvar)

esttab violence_2 riot_2 spon_2 etype4_2 demo_2 etype2_2 org_2 strike_2 using "results/probit_subtypes1_results.tex", keep(main:std_food_chg main:l_wet_mscp6 main:l_unrest main:elections main:democ main:autoc) eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(N ll chi2 p chi2_exog p_exog, fmt(0 0 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Observations"' `"Log psuedolikelihood"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"' `"Wald \(X^{2}\) test of exogeneity"' `"Exogeneity \(X^{2}\) p-value"')) addn("$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "All models include country, year, \& calendar month fixed effects and unreported covariates."  "(1) Violent unrest"  "(2) Riots (spontaneous and organized)"  "(3) Spontaneous events (demonstrations and riots)"  "(4) Spontaneous violent riots"  "(5) Demonstrations (spontaneous and organized)"  "(6) Spontaneous demonstrations"  "(7) Organized events (demonstrations and riots)"  "(8) Strikes"  "Rwanda excluded in Model (4) because it perfectly predicts failure, i.e. no spontaneous violent riots") nonote lab lz nogap nomti bookt replace	

use violence_1.dta, clear
gen violence_1 = 1
append using violence_2, gen(violence_2)
foreach dv in "demo" "riot" "spon" "org" "strike" "etype2" "etype4" "etype8" {
	append using `dv'_1.dta, gen(`dv'_1)
	append using `dv'_2.dta, gen(`dv'_2)
	}
save results/probit_results_by_type.dta, replace

use "data/feeding_unrest_africa.dta", clear
reg unrest std_food_chg grinst l_dry_mscp9 l_wet_mscp6 l_unrest elections democ autoc ucdp pop  pop_growth pct_urb pct_youth gdppc life_exp inf_mort
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

use results/probit_results_by_type.dta, clear
drop if parm != "std_food_chg"
foreach var of varlist violence_1 demo_1 riot_1 spon_1 org_1 strike_1 etype2_1 etype4_1 etype8_1 etype8_2 {
	drop if `var' == 1
	}
gen outcome = 1
replace outcome = 2 if riot_2 == 1
replace outcome = 3 if spon_2 == 1
replace outcome = 4 if etype4_2 == 1
replace outcome = 5 if demo_2 == 1
replace outcome = 6 if etype2_2 == 1
replace outcome = 7 if org_2 == 1
replace outcome = 8 if strike_2 == 1
lab def outcome ///
	1 "Violent unrest" ///
	2 "Riots (spontaneous and organized)" ///
	3 "Spontaneous events (demonstrations and riots)" ///
	4 "Spontaneous violent riots" ///
	5 "Demonstrations (spontaneous and organized)" ///
	6 "Spontaneous demonstrations" ///
	7 "Organized events (demonstrations and riots)" ///
	8 "Strikes"
lab val outcome outcome
drop eq parm min95 max95 violence_1 - etype8_2
gen star = ""
replace star = "\sym{+}" if p < .1
replace star = "\sym{*}" if p < .05
replace star = "\sym{**}" if p < .01
gen or = exp(estimate)
*replace stderr = exp(stderr)
replace or = round(or,.001)
format or stderr %4.3f
tostring or, replace force u
replace or = or + star
merge 1:1 outcome using results/outcome_table.dta
drop estimate stderr z p star _merge
sort outcome
lab var outcome "Type of unrest"
lab var success "Country-months with unrest type"
lab var or "Effect of a one sd spike in food prices (odds ratio)"
decode outcome, gen(type)
order type success or
drop outcome
gen end = "\\"
export delimited using "results/outcome_table.tex", delimiter("&") novarnames replace

foreach dv in "violence" "demo" "riot" "spon" "org" "strike" "etype2" "etype4" "etype8" {
	erase `dv'_1.dta
	erase `dv'_2.dta
	}

*************** ROBUSTNESS CHECKS ***************
eststo clear
use "data/feeding_unrest_africa.dta", clear
loc x "l_unrest l_wet_mscp6 elections democ autoc ucdp pop  pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
loc iv "grinst l_dry_mscp9"

***** NO FIXED EFFECTS NO CONTROLS *****
eststo base: quietly ivprobit unrest (std_food_chg = `iv'), cl(iso_num) nolog
parmest, sa(base, replace)
classadd
estadd local fe "no"

***** NO FIXED EFFECTS *****
eststo nofe: quietly ivprobit unrest `x' (std_food_chg = `iv'), cl(iso_num) nolog
parmest, sa(nofe, replace)
classadd
estadd local fe "no"

***** EXCLUDE EGYPT, SOUTH AFRICA AND NIGERIA *****
eststo zaegng: quietly ivprobit unrest `x' i.iso_num i.month y1-y7 y9-y22 (std_food_chg = `iv') if iso_num != 818 & iso_num != 710 & iso_num != 566, cl(iso_num) nolog
parmest, sa(zaegng, replace)
classadd
estadd local fe "yes"

*********************** POST 1997 ***********************
eststo post97: quietly ivprobit unrest `x' i.iso_num i.month y9-y22 (std_food_chg = `iv') if year > 1997, cl(iso_num) nolog first
parmest, sa(post97, replace)
classadd
estadd local fe "yes"

*********************** PRE 2007 ***********************
eststo pre2007: quietly ivprobit unrest `x' i.iso_num i.month y1-y7 y9-y22 (std_food_chg = `iv') if year < 2007, cl(iso_num) nolog first
parmest, sa(pre2007, replace)
classadd
estadd local fe "yes"

*********************** USING GPCP ***********************
loc iv1 "grinst"
loc iv2 "l_GPCP_dry9"
loc x "l_unrest l_GPCP_wet6 elections democ autoc ucdp pop  pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
eststo gpcp: quietly ivprobit unrest `x' i.iso_num i.month y1-y7 y9-y22 (std_food_chg = `iv1' `iv2'), cl(iso_num) nolog first
parmest, sa(gpcp, replace)
classadd
estadd local fe "yes"

*********************** USING DRY MSCP 6 MONTH ***********************
loc iv1 "grinst"
loc iv2 "l_dry_mscp6"
loc x "l_unrest l_wet_mscp6 elections democ autoc ucdp pop  pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
eststo mscp6:  quietly ivprobit unrest `x' i.iso_num i.month y1-y7 y9-y22 (std_food_chg = `iv1' `iv2'), cl(iso_num) nolog first
parmest, sa(mscp6, replace)
classadd
estadd local fe "yes"

*********************** USING DRY MSCP 12 MONTH ***********************
loc iv2 "l_dry_mscp12"
loc x "l_unrest l_wet_mscp6 elections democ autoc ucdp pop  pop_growth pct_urb pct_youth gdppc life_exp inf_mort"
eststo mscp12: quietly ivprobit unrest `x' i.iso_num i.month y1-y7 y9-y22 (std_food_chg = `iv1' `iv2'), cl(iso_num) nolog first
parmest, sa(mscp12, replace)
classadd
estadd local fe "yes"

display "******************* Robustness Checks - DV = unrest *******************"
esttab base nofe zaegng post97 pre2007 mscp6 mscp12 gpcp, eform keep(std_food_chg `iv' `iv2' l_GPCP_dry9 l_GPCP_wet6 l_dry_mscp6 l_dry_mscp12 `x') sca(N N_clust ll chi2_exog p_exog) sfmt(%11.3g) nogaps b(%7.3f) se(%7.3f) star(+ .1 * .05 ** .01) mti

esttab base nofe zaegng post97 using "results/unrest_rc_res1_app.tex", keep(unrest:std_food_chg unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort) order(unrest:std_food_chg unrest:l_unrest unrest:l_wet_mscp6) eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(fe N ll pos neg corr chi2 p chi2_exog p_exog, fmt(0 0 0 2 2 2 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Country, year, \& calendar month fixed effects"' `"Observations"' `"Log psuedolikelihood"' `"Positive predictive value"' `"Negative predictive value"' `"Correctly classified"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"' `"Wald \(X^{2}\) test of exogeneity"' `"Exogeneity \(X^{2}\) p-value"')) addn("Odds ratios reported"  "$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "(1) No fixed effects; no control variables"  "(2) No control variables"  "(3) Excluding Egypt, Nigeria, and South Africa"  "(4) Limited to post-1997 observations") nonote varwidth(48) wrap lab lz nogap nomti nodep bookt replace	

esttab pre2007 mscp6 mscp12 gpcp using "results/unrest_rc_res2_app.tex", keep(unrest:std_food_chg unrest:l_unrest unrest:l_wet_mscp6 unrest:elections unrest:democ unrest:autoc unrest:ucdp unrest:pop unrest:pop_growth unrest:pct_urb unrest:pct_youth unrest:gdppc unrest:life_exp unrest:inf_mort unrest:l_GPCP_wet6) order(unrest:std_food_chg unrest:l_unrest unrest:l_wet_mscp6 unrest:l_GPCP_wet6) eform alignment(S) nogaps b(3) p(3) star(+ .1 * .05 ** .01) stats(fe N ll pos neg corr chi2 p chi2_exog p_exog, fmt(0 0 0 2 2 2 0 3) layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}") labels(`"Country, year, \& calendar month fixed effects"' `"Observations"' `"Log psuedolikelihood"' `"Positive predictive value"' `"Negative predictive value"' `"Correctly classified"' `"Wald \(X^{2}\)"' `"\(X^{2}\) p-value"' `"Wald \(X^{2}\) test of exogeneity"' `"Exogeneity \(X^{2}\) p-value"')) addn("Odds ratios reported"  "$^+$ p $<$ 0.1, * p $<$ 0.05, ** p $<$ 0.01. Cluster robust standard errors in parentheses."  "(1) Limited to pre-2007 observations"  "(2) Using 6 month dry MSCP"  "(3) Using 12 month dry MSCP"  "(4) Using GPCP rainfall data") nonote varwidth(48) wrap lab lz nogap nomti nodep bookt replace	

use base.dta, clear
gen base = 1
foreach m in nofe zaegng post97 pre2007 gpcp mscp6 mscp12 {
	append using `m'.dta, gen(`m')
	}
save "results/unrest_rc_estimates.dta", replace
foreach m in base nofe zaegng post97 pre2007 gpcp mscp6 mscp12 {
	erase `m'.dta
	} 

log close
exit
