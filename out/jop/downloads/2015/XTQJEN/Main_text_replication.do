
/* 	This do-file replicates the results in the main text. 
	
	Please see README.txt for details on the data files. 
	
	Set the line "cd" below to the directory where the 
	data files have been extracted. 
	
	This do file requires an ado file -rdrobust- to run. 
	Type findit rdrobust to install. 
	
	IMPORTANT: The results were obtained with rdrobust version 6.0, 
		14Oct2014; a different version may give somewhat different 
		results. 
	
	All computations were done in Stata 12. 
	
	Please direct any questions, comments, or spotted errors to: 
	marko.klasnja@gmail.com
	
	*/
	
clear *
set more off
cd "C:/Users/`c(username)'/Dropbox/Romania/do files/disadv_JOP_replication/final"
set matsize 8000
set seed 7

* store results in a matrix
program define stores
	args y z /* y = matrix column z = matrix name */
	matrix `z'[1,`y'] = e(tau_cl)
	matrix `z'[2,`y'] = e(se_cl)
	matrix `z'[3,`y'] = e(pv_cl)
	matrix `z'[4,`y'] = e(h_bw)
	matrix `z'[5,`y'] = e(N)
	matrix `z'[6,`y'] = e(N_l)
	matrix `z'[7,`y'] = e(N_r)
	matrix rownames `z' = "Estimate" "SE" "p-value" "Bandwidth" "N" "N-below" "N-above"
end


/*---------------------------------------------------------------------------*/
/* FIGURE 1: INCUMBENCY DISADVANTAGE SUMMARY GRAPH */
/*---------------------------------------------------------------------------*/

use electoral_data, clear

rdbinselect win vote_margin, scale(4) lowerend(-.5) upperend(.5) ///
	graph_options(scheme(s1mono) title("") xtitle("Party's Vote Margin at t") ///
	ytitle("Probability of Victory in Next Election") aspect(1) legend(off) ///
	xlabel(-.4(.2).4) xline(0, lcolor(red)))


/*---------------------------------------------------------------------------*/
/* TABLE 1: OVERALL INCUMBENCY RDD RESULTS */
/*---------------------------------------------------------------------------*/

matrix res = J(7,2,0)

* column 1: victory t+1
qui rdrobust win vote_margin
stores 1 res

* column 2: vote margin t+1
qui rdrobust vote vote_margin
stores 2 res

* show results
matrix list res

	
/*---------------------------------------------------------------------------*/
/* TABLE 2: MAYORS' WEALTH ACCUMULATION */
/*---------------------------------------------------------------------------*/

use wealth_data, clear

matrix res_wealth = J(7,2,.)

* column 1: winners vs. losers
qui rdrobust wealth vote_margin
stores 1 res_wealth

* column 2: winners across salary threshold
qui rdrobust wealth pop_margin if winner == 1
stores 2 res_wealth

* show results
matrix list res_wealth


/*---------------------------------------------------------------------------*/
/* TABLE 3: CORRUPTION MEASURES ACROSS SALARY THRESHOLD */
/*---------------------------------------------------------------------------*/

use corruption_data, clear

matrix res_corrupt = J(7,4,.)

* column 1: opaque procurement procedure 
qui rdrobust opaque pop_margin
stores 1 res_corrupt

* column 2: price per quantity 
* (use same bandwidth as others for reasonable sample size)
qui rdrobust ppq pop_margin, h(.2)
stores 2 res_corrupt

* column 3: single-bidder contract
qui rdrobust single_bid pop_margin
stores 3 res_corrupt

* column 4: missing infrastructure
qui rdrobust infrastr pop_margin
stores 4 res_corrupt 

* show results
matrix list res_corrupt


/*---------------------------------------------------------------------------*/
/* FIGURE 2: THE INCUMBENCY DISADVANTAGE ACROSS SALARY THRESHOLD */
/*---------------------------------------------------------------------------*/

use electoral_data, clear

* balanced population window is .186 
* (see "Supplementary_Appendix_replication.do" for more details)

global salary_bw = .186
gen cond = .
replace cond = 0 if pop_margin < 0 & pop_margin > -$salary_bw
replace cond = 1 if pop_margin > 0 & pop_margin < $salary_bw

* left panel: around salary threshold
rdbinselect win vote_margin if cond ~= ., scale(3) lowerend(-.5) ///
	upperend(.5) p(3) graph_options(scheme(s1mono) title("Around Salary Threshold") ///
	xtitle("Party's Vote Margin at t") ///
	ytitle("Probability of Victory in Next Election") name(around, replace) aspect(1) ///
	legend(off) xlabel(-.4(.2).4) xline(0, lcolor(red)) ylabel(0(.2)1))
	
* middle panel: below the salary threshold
rdbinselect win vote_margin if cond == 0, scale(3) lowerend(-.5) ///
	upperend(.5) p(3) graph_options(scheme(s1mono) title("Below Salary Threshold") ///
	xtitle("Party's Vote Margin at t") ///
	ytitle("Probability of Victory in Next Election") name(below, replace) aspect(1) ///
	legend(off) xlabel(-.4(.2).4) xline(0, lcolor(red)) ylabel(0(.2)1))

* right panel: above the salary threshold
rdbinselect win vote_margin if cond == 1, scale(3) lowerend(-.5) ///
	upperend(.5) p(3) graph_options(scheme(s1mono) title("Above Salary Threshold") ///
	xtitle("Party's Vote Margin at t") ///
	ytitle("Probability of Victory in Next Election") name(above, replace) aspect(1) ///
	legend(off) xlabel(-.4(.2).4) xline(0, lcolor(red)) ylabel(0(.2)1))
	
gr combine around below above, scheme(s1mono) rows(1) ysize(2.4) ycommon


/*---------------------------------------------------------------------------*/
/* TABLE 4: THE INCUMBENCY DISADVANTAGE ACROSS SALARY THRESHOLD */
/*---------------------------------------------------------------------------*/

matrix res_asalary = J(7,4,.)

* column 1: within the balanced population window
* (on both sides of the 7,000 population/salary threshold)
qui rdrobust win vote_margin if cond ~= .
stores 1 res_asalary 

* column 2: below the salary threshold
qui rdrobust win vote_margin if cond == 0
stores 2 res_asalary 
global h0 = e(h_bw)
global b0 = e(b_bw)

* column 3: above the salary threshold
qui rdrobust win vote_margin if cond == 1
stores 3 res_asalary 
global h1 = e(h_bw)
global b1 = e(b_bw)

* column 4: the bootstrapped difference
set seed 7
matrix est_diff = J(1000,1,.)
matrix est0 = J(1000,1,.)
matrix est1 = J(1000,1,.)

forval i = 1/1000 {
	di "Boostrapped sample: `i'"
	quietly {
		preserve
		bsample, strata(cond)
		rdrobust win vote_margin if cond == 0, h($h0) b($b0)
		matrix est0[`i',1] = e(tau_cl)
		local est0 = e(tau_cl)
		rdrobust win vote_margin if cond == 1, h($h1) b($b1)
		matrix est1[`i',1] = e(tau_cl)
		local est1 = e(tau_cl)
		matrix est_diff[`i',1] = `est1' - `est0'
		restore
		}
	}
	
clear
svmat est0
svmat est1
svmat est_diff
sum est_diff1, d
local est_diff_mean = r(mean)
local est_diff_sd = r(sd)
matrix res_asalary[1,4] = `est_diff_mean'
matrix res_asalary[2,4] = `est_diff_sd'
matrix res_asalary[3,4] = (1-normal(`est_diff_mean'/`est_diff_sd'))*2

* show results
matrix list res_asalary


/*---------------------------------------------------------------------------*/
/* TABLE 5: MULTIPLE-TERM VS. FIRST-TERM WEALTH ACCUMULATION */
/*---------------------------------------------------------------------------*/

use wealth_data, clear

matrix res_wealth_prev_inc = J(7,3,.)

* column 1: first-term mayors
qui rdrobust wealth vote_margin if winner_2004 == 0
stores 1 res_wealth_prev_inc
global h0 = e(h_bw)
global b0 = e(b_bw)

* column 2: multiple-term mayors
qui rdrobust wealth vote_margin if winner_2004 == 1
stores 2 res_wealth_prev_inc
global h1 = e(h_bw)
global b1 = e(b_bw)

* column 3: bootstrapped difference
set seed 7
matrix est_diff = J(1000,1,.)
matrix est0 = J(1000,1,.)
matrix est1 = J(1000,1,.)

forval i = 1/1000 {
	di "Boostrapped sample: `i'"
	quietly {
		preserve
		bsample, strata(winner_2004)
		rdrobust wealth vote_margin if winner_2004 == 0, h($h0) b($b0)
		matrix est0[`i',1] = e(tau_cl)
		local est0 = e(tau_cl)
		rdrobust wealth vote_margin if winner_2004 == 1, h($h1) b($b1)
		matrix est1[`i',1] = e(tau_cl)
		local est1 = e(tau_cl)
		matrix est_diff[`i',1] = `est1' - `est0'
		restore
		}
	}
	
svmat est0
svmat est1
svmat est_diff
sum est_diff1, d
local est_diff_mean = r(mean)
local est_diff_sd = r(sd)
matrix res_wealth_prev_inc[1,3] = `est_diff_mean'
matrix res_wealth_prev_inc[2,3] = `est_diff_sd'
matrix res_wealth_prev_inc[3,3] = (1-normal(`est_diff_mean'/`est_diff_sd'))*2

* show results
matrix list res_wealth_prev_inc


/*---------------------------------------------------------------------------*/
/* TABLE 6: VOTERS' CORRUPTION PERCEPTIONS OF MULTIPLE-TERM AND 
	FIRST-TERM MAYORS */
/*---------------------------------------------------------------------------*/

use survey_data, clear

matrix res_percept = J(7,2,.)

* column 1: entire sample
qui reg percept inc_prev female-oct07, cluster(city_code_unq)
matrix res_percept[1,1] = _b[inc_prev]
matrix res_percept[2,1] = _se[inc_prev]
matrix res_percept[3,1] = (1-normal(_b[inc_prev]/_se[inc_prev]))*2
matrix res_percept[4,1] = 1
matrix res_percept[5,1] = e(N)

* column 2: above vs. below salary threshold
* (within balanced population window)
qui reg percept inc_prev female-oct07 if above == 0 & balanced == 1, ///
	cluster(city_code_unq)
local Nbelow = e(N)
matrix res_percept[6,2] = e(N)
qui reg percept inc_prev female-oct07 if above == 1 & balanced == 1, ///
	cluster(city_code_unq)
local Nabove = e(N)
matrix res_percept[7,2] = e(N)
matrix res_percept[5,2] = `Nbelow' + `Nabove'

keep if balanced == 1
set seed 7
matrix est_diff = J(1000,1,.)
matrix est0 = J(1000,1,.)
matrix est1 = J(1000,1,.)

forval i = 1/1000 {
	di `i'
	quietly {
		preserve
		bsample, strata(above)
		reg percept inc_prev female-oct07 if above == 0, cluster(city_code_unq)
		matrix est0[`i',1] = _b[inc_prev]
		local est0 = _b[inc_prev]
		reg percept inc_prev female-oct07 if above == 1, cluster(city_code_unq)
		matrix est1[`i',1] = _b[inc_prev]
		local est1 = _b[inc_prev]
		matrix est_diff[`i',1] = `est1' - `est0'
		restore
		}
	}
	
svmat est_diff
sum est_diff1, d
matrix res_percept[1,2] = r(p50)
matrix res_percept[2,2] = r(sd)
matrix res_percept[3,2] = (normal(r(p50)/r(sd)))*2
matrix res_percept[4,2] = .186

* show results
matrix list res_percept


/*---------------------------------------------------------------------------*/
/* TABLE 7: INCUMBENCY DISADVANTAGE WITH MULTIPLE-TERM AND FIRST-TERM 
	INCUMBENTS */
/*---------------------------------------------------------------------------*/

use electoral_data, clear

matrix multiterm = J(7,2,.)

* column 1: difference btw. incumbency disadvantage for
* multiple-term and first-term incumbents
qui rdrobust win vote_margin if inc_prev == 0
global h0 = e(h_bw)
global b0 = e(b_bw)
local nb1 = e(N_l)
local na1 = e(N_r)
qui rdrobust win vote_margin if inc_prev == 1
global h1 = e(h_bw)
global b1 = e(b_bw)
local nb2 = e(N_l)
local na2 = e(N_r)
matrix multiterm[4,1] = ($h0 + $h1)/2
matrix multiterm[5,1] = `nb1'+`nb2'+`na1'+`na2'
matrix multiterm[6,1] = `nb1'+`nb2'
matrix multiterm[7,1] = `na1'+`na2'

set seed 7
matrix est_diff = J(1000,1,.)
matrix est0 = J(1000,1,.)
matrix est1 = J(1000,1,.)

forval i = 1/1000 {
	di "Bootstrapped sample: `i'"
	quietly {
		preserve
		bsample, strata(inc_prev)
		rdrobust win vote_margin if inc_prev == 0, h($h0) b($b0)
		matrix est0[`i',1] = e(tau_cl)
		local est0 = e(tau_cl)
		rdrobust win vote_margin if inc_prev == 1, h($h1) b($b1)
		matrix est1[`i',1] = e(tau_cl)
		local est1 = e(tau_cl)
		matrix est_diff[`i',1] = `est1' - `est0'
		restore
		}
	}
	
svmat est0
svmat est1
svmat est_diff
sum est_diff1, d
local est_diff_mean = r(p50)
local est_diff_sd = r(sd)
matrix multiterm[1,1] = `est_diff_mean'
matrix multiterm[2,1] = `est_diff_sd'
matrix multiterm[3,1] = (normal(`est_diff_mean'/`est_diff_sd'))*2

* column 2: multiple-term vs. first-term mayor renomination
qui rdrobust inc_prev pop_margin
stores 2 multiterm

* show results
matrix list multiterm

graph drop _all
