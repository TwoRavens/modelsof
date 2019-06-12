
// Figure 2: plot CDFs of equity across 5 MSAs

set more off
clear

foreach i in 200701 200811 {

use temp/updated_LTVs_`i'_zip.dta, clear // from 6_compute_cltvs.do
rename CLTV CLTV_`i'

keep if inlist(msa, 16974, 33124, 37964, 29820,42644)

/************* Four Panels *************/

g equity = 100 - CLTV_`i'

g round = round(equity,1) 			 
replace round = 61 if round>=61

collapse (sum) loan_amt (count) num_loans=loan_id, by(round msa)
bysort msa (round): gen cdf = sum(num_loans)
bysort msa: egen total_loans = sum(num_loans)
bysort msa (round): gen cdf_bw = sum(loan_amt)
bysort msa: egen total_bal = sum(loan_amt)
replace cdf = cdf / total_loans
replace cdf_bw = cdf_bw / total_bal

ds msa round, not
renvars `r(varlist)', postfix(_0`i')

keep if round>=-40 & round<=60

twoway (line cdf_bw_0`i' round if msa == 37964)  (line cdf_bw_0`i' round if msa == 42644, lpattern(dash) lw(thick)) (line cdf_bw_0`i' round if msa == 16974, lpattern(dash_dot) lw(thick)) ///
 (line cdf_bw_0`i' round if msa == 33124, lpattern(longdash) lw(thick))  (line cdf_bw_0`i' round if msa == 29820, lpattern(shortdash_dot) lw(thick)),  name(fig2eq_`i', replace) ///
 legend(order(1 "Philadelphia" 2 "Seattle" 3 "Chicago" 4 "Miami" 5 "Las Vegas") r(2) symx(7) rowg(0.7))  ///
xtitle("Equity, in percent of estimated home value") ytitle("Share of loans with Equity < X%") xlabel(-40(20)60, nogrid) 

list if inrange(cdf_bw,0.45,0.55)

 }
