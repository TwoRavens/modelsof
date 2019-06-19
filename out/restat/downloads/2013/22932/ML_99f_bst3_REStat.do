/* II THE BOOTSTRAP */
/* NOTES: 
i. recall to set the # repetitions in MLnot_bs.do or MLt_bs.do
ii. same below in the loop
iii. same below in the matrix conversions (change the i in m1bi and m2bi)
(iv. set the # loops in the tstat loop below to be the correct one )
*/

/* bootstrapping the selection equations */
/* CHECK that you are using the ML*_bs.do file you want ('not' or 't') */
clear all
drop _all
label drop _all
/*matrix drop _all*/
scalar drop _all
constraint drop _all
discard
set more off
set memory 64m
set matsize 800
capture log close

cd "C:\Vanha D\OttoE\Tekes\Bruegel_project\Finland\TTT1_code\REStat"

local mydate: di %tdDNCY date(c(current_date),"DMY")  /* Get today's date for dataname */ 

log using "TTT_REStat_boostrap_`mydate'.log", replace

* choose seeds / # rounds
set seed 2134596 /*1-100 */
/* set seed 2345346 *//*101-200*/
/*set seed 98273456 *//*201-300*/
/*set seed 987325 *//*301-400 */
/*set seed 873625 */ /* in MLt_bs3 rounds #151-300, MLt_99f_4(b) */
/*set seed 1239874 *//* in MLt_bs3 & MLt_99f_4(c) rounds #301-400 */
/*set seed 7863425 */ /* in MLt_bs3 rounds #401-500 */
/* set seed 3459867 */ /* in MLt_bs3 rounds #501-650 */
/*set seed 872365 *//* MLt_bs rounds #651=750 */

do "MLt_bs43_TTT1_REStat.do"

/*creating a matrix of the  bootstrapped coefficients */

local p = 1

matrix m`p'_2 = mb11 \ mb12
matrix prob`p'_2 = probb1 \ probb2
matrix cov`p'_2 = cov1 \ cov2

local j = 2
local k = 3
while `k' < 101 { /* NOTE: k needs to be i+2, where i is from MLt_bs43.do */
matrix m`p'_`k' = m`p'_`j' \ mb1`k'
matrix prob`p'_`k' = prob`p'_`j' \ probb`k'
matrix cov`p'_`k' = cov`p'_`j' \ cov`k'
local j = `j'+1
local k = `k'+1
}

/* calling do-files to 1) estimate the actual coeff vector 2) create bs-se's and t-ratios */

do "MLt_99f_est3_TTT1_REStat.do"

do "ML_99f_ses3_TTT1_REStat.do"

