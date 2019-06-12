* Analysis for SPPQ paper "Understanding Public Perceptions of Growing Economic Inequality".
* All analyses conducted using Stata 14.2.

* Note: the package -xtmg- is required to run the following analyses.
* The -xtmg- package can be located using the command below (internet connection required).
* net sj 12-1 st0246


clear all

* Change the file path below to directory where datasets are located.
local filepath "/your/file/path/"

* Read data.
use `filepath'data_ineqp.dta, clear


* Basic variable rescaling.
gen gini100 = Gini * 100
gen medinc1k = median_inc / 1000


* Create lagged and differenced versions of each variable.
xtset
foreach v of varlist ineqp_a-medinc1k {
	qui gen L1_`v' = L1.`v'
	qui gen D1_`v' = D1.`v'
}


* Unit root tests.
* Non-stationary series.
xtunitroot fisher ineqp_a, dfuller lags(3)
xtunitroot fisher Top10_adj, dfuller lags(3)
xtunitroot fisher Top1_adj, dfuller lags(3)
xtunitroot fisher Gini, dfuller lags(3)
xtunitroot fisher unemp, dfuller lags(3)
xtunitroot fisher income_pc1k, dfuller lags(3)
xtunitroot fisher medinc1k, dfuller lags(3)
xtunitroot fisher pct_wht, dfuller lags(3)
xtunitroot fisher policy_liberalism_cw, dfuller lags(3)


* Stationary series.
xtunitroot fisher poverty_rate, dfuller lags(3)
xtunitroot fisher mood, dfuller lags(3)


* Which states have stationary series?
gen poverty_rate_adf = .
gen mood_adf = .
levelsof fips, local(fipsvals)
foreach i of local fipsvals {
	* Poverty.
	qui dfuller poverty_rate if fips==`i', lags(3)
	qui replace poverty_rate_adf = `r(p)' if fips==`i'
	* Mood.
	qui dfuller mood if fips==`i', lags(3)
	qui replace mood_adf = `r(p)' if fips==`i'
}
tab state if poverty_rate_adf <= 0.05
tab state if mood_adf <= 0.05



**************************
*** Main Text Analyses ***
**************************



* Table 1, Model 1.
* Top 1%, without poverty.
xtmg D1_ineqp_a L1_ineqp_a L1_Top1_adj L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht D1_Top1_adj D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht, trend


* Table 1, Model 2.
* Top 1%, poverty included.
xtmg D1_ineqp_a L1_ineqp_a L1_Top1_adj L1_unemp L1_poverty_rate L1_policy_liberalism_cw L1_medinc1k L1_pct_wht D1_Top1_adj D1_unemp D1_poverty_rate D1_policy_liberalism_cw D1_medinc1k D1_pct_wht if poverty_rate_adf > 0.05, trend


* Table 2, Model 1.
* Top 10%, without poverty.
xtmg D1_ineqp_a L1_ineqp_a L1_Top10_adj L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht D1_Top10_adj D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht, trend


* Table 2, Model 2.
* Top 10%, poverty included.
xtmg D1_ineqp_a L1_ineqp_a L1_Top10_adj L1_unemp L1_poverty_rate L1_policy_liberalism_cw L1_medinc1k L1_pct_wht D1_Top10_adj D1_unemp D1_poverty_rate D1_policy_liberalism_cw D1_medinc1k D1_pct_wht if poverty_rate_adf > 0.05, trend


* Table 3, Model 1.
* Gini, without poverty.
xtmg D1_ineqp_a L1_ineqp_a L1_gini100 L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht D1_gini100 D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht, trend


* Table 3, Model 2.
* Gini, poverty included.
xtmg D1_ineqp_a L1_ineqp_a L1_gini100 L1_unemp L1_poverty_rate L1_policy_liberalism_cw L1_medinc1k L1_pct_wht D1_gini100 D1_unemp D1_poverty_rate D1_policy_liberalism_cw D1_medinc1k D1_pct_wht if poverty_rate_adf > 0.05, trend



***************************
*** Appendix A Analyses ***
***************************


* Create matrix to store results.
matrix A = (1,1,.,. \ 1,2,.,. \ 1,3,.,.)
matrix B = (2,1,.,. \ 2,2,.,. \ 2,3,.,.)
matrix C = (3,1,.,. \ 3,2,.,. \ 3,3,.,.)
matrix res1 = A \ B \ C
mat coln res1 = mod var lib con
bysort fips: egen policy_liberalism_cw_bw = mean(policy_liberalism_cw)


* Conditional models.
* State ideology.

* Table A.1.
* Top 1%, Liberal States model.
xtmg D1_ineqp_a L1_ineqp_a L1_Top1_adj L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht L1_poverty_rate D1_Top1_adj D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht D1_poverty_rate if (policy_liberalism_cw_bw >= 0) & (poverty_rate_adf > 0.05), trend
  * LRMs.
  mat res1[4, colnumb(res1,"lib")] = _b[L1_Top1_adj] / (-1 * _b[L1_ineqp_a])
  mat res1[5, colnumb(res1,"lib")] = _b[L1_unemp] / (-1 * _b[L1_ineqp_a])
  mat res1[6, colnumb(res1,"lib")] = _b[L1_poverty_rate] / (-1 * _b[L1_ineqp_a])


* Table A.1.
* Top 1%, Conservative States model.
xtmg D1_ineqp_a L1_ineqp_a L1_Top1_adj L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht L1_poverty_rate D1_Top1_adj D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht D1_poverty_rate if (policy_liberalism_cw_bw < 0) & (poverty_rate_adf > 0.05), trend
  * LRMs.
  mat res1[4, colnumb(res1,"con")] = _b[L1_Top1_adj] / (-1 * _b[L1_ineqp_a])
  mat res1[5, colnumb(res1,"con")] = _b[L1_unemp] / (-1 * _b[L1_ineqp_a])
  mat res1[6, colnumb(res1,"con")] = _b[L1_poverty_rate] / (-1 * _b[L1_ineqp_a])


* Table A.2.
* Top 10%, Liberal States model.
xtmg D1_ineqp_a L1_ineqp_a L1_Top10_adj L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht L1_poverty_rate D1_Top10_adj D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht D1_poverty_rate if (policy_liberalism_cw_bw >= 0) & (poverty_rate_adf > 0.05), trend
  * LRMs.
  mat res1[1, colnumb(res1,"lib")] = _b[L1_Top10_adj] / (-1 * _b[L1_ineqp_a])
  mat res1[2, colnumb(res1,"lib")] = _b[L1_unemp] / (-1 * _b[L1_ineqp_a])
  mat res1[3, colnumb(res1,"lib")] = _b[L1_poverty_rate] / (-1 * _b[L1_ineqp_a])


* Table A.2.
* Top 10%, Conservative States model.
xtmg D1_ineqp_a L1_ineqp_a L1_Top10_adj L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht L1_poverty_rate D1_Top10_adj D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht D1_poverty_rate if (policy_liberalism_cw_bw < 0) & (poverty_rate_adf > 0.05), trend
  * LRMs.
  mat res1[1, colnumb(res1,"con")] = _b[L1_Top10_adj] / (-1 * _b[L1_ineqp_a])
  mat res1[2, colnumb(res1,"con")] = _b[L1_unemp] / (-1 * _b[L1_ineqp_a])
  mat res1[3, colnumb(res1,"con")] = _b[L1_poverty_rate] / (-1 * _b[L1_ineqp_a])


* Table A.3.
* Gini, Liberal States model.
xtmg D1_ineqp_a L1_ineqp_a L1_gini100 L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht L1_poverty_rate D1_gini100 D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht D1_poverty_rate if (policy_liberalism_cw_bw >= 0) & (poverty_rate_adf > 0.05), trend
  * LRMs.
  mat res1[7, colnumb(res1,"lib")] = _b[L1_gini100] / (-1 * _b[L1_ineqp_a])
  mat res1[8, colnumb(res1,"lib")] = _b[L1_unemp] / (-1 * _b[L1_ineqp_a])
  mat res1[9, colnumb(res1,"lib")] = _b[L1_poverty_rate] / (-1 * _b[L1_ineqp_a])


* Table A.3.
* Gini, Conservative States model.
xtmg D1_ineqp_a L1_ineqp_a L1_gini100 L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht L1_poverty_rate D1_gini100 D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht D1_poverty_rate if (policy_liberalism_cw_bw < 0) & (poverty_rate_adf > 0.05), trend
  * LRMs.
  mat res1[7, colnumb(res1,"con")] = _b[L1_gini100] / (-1 * _b[L1_ineqp_a])
  mat res1[8, colnumb(res1,"con")] = _b[L1_unemp] / (-1 * _b[L1_ineqp_a])
  mat res1[9, colnumb(res1,"con")] = _b[L1_poverty_rate] / (-1 * _b[L1_ineqp_a])


* The estimates stored in this matrix are used to create Figure 6 in the main text.
mat list res1


* Models including per capita income.

* Table A.4, Top 1% model.
xtmg D1_ineqp_a L1_ineqp_a L1_Top1_adj L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_income_pc1k L1_pct_wht D1_Top1_adj D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_income_pc1k D1_pct_wht, trend


* Table A.4, Top 10% model.
xtmg D1_ineqp_a L1_ineqp_a L1_Top10_adj L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_income_pc1k L1_pct_wht D1_Top10_adj D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_income_pc1k D1_pct_wht, trend


* Table A.4, Gini model.
xtmg D1_ineqp_a L1_ineqp_a L1_gini100 L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_income_pc1k L1_pct_wht D1_gini100 D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_income_pc1k D1_pct_wht, trend


* Models using alternative ideology measure -- policy mood.

* Table A.5, Top 1% model.
xtmg D1_ineqp_a L1_ineqp_a L1_Top1_adj L1_unemp L1_mood L1_medinc1k L1_pct_wht D1_Top1_adj D1_unemp D1_mood D1_medinc1k D1_pct_wht, trend


* Table A.5, Top 10% model.
xtmg D1_ineqp_a L1_ineqp_a L1_Top10_adj L1_unemp L1_mood L1_medinc1k L1_pct_wht D1_Top10_adj D1_unemp D1_mood D1_medinc1k D1_pct_wht, trend


* Table A.5, Gini model.
xtmg D1_ineqp_a L1_ineqp_a L1_gini100 L1_unemp L1_mood L1_medinc1k L1_pct_wht D1_gini100 D1_unemp D1_mood D1_medinc1k D1_pct_wht, trend



***************************
*** Appendix B Analyses ***
***************************



* Models using perceived inequality estimates from disaggregated state averages.
* Only include 16 largest states. Minimum average of 70 respondents per state-year.

* Table B.2, Top 1% model.
xtmg D1_ineqp_disagg_a L1_ineqp_disagg_a L1_Top1_adj L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht D1_Top1_adj D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht, trend


* Table B.2, Top 10% model.
xtmg D1_ineqp_disagg_a L1_ineqp_disagg_a L1_Top10_adj L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht D1_Top10_adj D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht, trend


* Table B.2, Gini model.
xtmg D1_ineqp_disagg_a L1_ineqp_disagg_a L1_gini100 L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht D1_gini100 D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht, trend



***************************
*** Appendix C Analyses ***
***************************



* Fixed effects models as alternative to pooled mean group estimation.

* Create trend variable.
gen time = year - 1987


* Table C.1, Top 1% model.
xtreg D1_ineqp_a L1_ineqp_a L1_Top1_adj L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht D1_Top1_adj D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht time L1_poverty_rate D1_poverty_rate if poverty_rate_adf > 0.05, fe


* Table C.1, Top 10% model.
xtreg D1_ineqp_a L1_ineqp_a L1_Top10_adj L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht D1_Top10_adj D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht time L1_poverty_rate D1_poverty_rate if poverty_rate_adf > 0.05, fe


* Table C.1, Gini model.
xtreg D1_ineqp_a L1_ineqp_a L1_gini100 L1_unemp L1_policy_liberalism_cw L1_medinc1k L1_pct_wht D1_gini100 D1_unemp D1_policy_liberalism_cw D1_medinc1k D1_pct_wht time L1_poverty_rate D1_poverty_rate if poverty_rate_adf > 0.05, fe


