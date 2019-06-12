/* This do-file replicates the robustness check in footnote 29 of Costinot, Donaldson, Kyle and Williams (QJE, 2019)

*/

***Preamble***

capture log close
*Set log
log using "${log_dir}2004_robustness_FN29.log", replace

*Reset output variables
scalar drop _all

*Load Data
use "${intersavedir}clean_sales_raw_sq_w_2004.dta", clear

***************** Estimation for 2004 (FN29) versus 2012 (Table 3, col 3) ******************************

	drop if sales_ctry == dest_ctry

	cap matrix drop table
	
	foreach year in 2012 2004 {
	* on predicted DALY in destination and predicted DALY in origin
	reghdfe lnsales lndaly_p_dest lndaly_p_sales if year==`year', absorb(sales_country#dest_country gbd) vce(cl sales_country dest_country)

	* show p-value of one-sided test for absence of weak home-market effect
	matrix B = r(table)
	matlist B
	di B[4,2]/2
	local weak_effect = B[4,2]/2
	
	* put coefficients and SEs in locals
	local bm = B[1,1]
	local bmSE = B[2,1]
	local bx = B[1,2]
	local bxSE = B[2,2]

	* test equality of coefficients
	test lndaly_p_dest = lndaly_p_sales
	local sign_diff = sign(_b[lndaly_p_sales]-_b[lndaly_p_dest])
	local strong_effect = ttail(r(df_r),`sign_diff'*sqrt(r(F)))
	* show p-value of one-sided test for absence of strong home-market effect
	display "H_0: sales coef <= dest coef. p-value = " ttail(r(df_r),`sign_diff'*sqrt(r(F)))
	
	}
	
log close	
