set more off
cap program drop rdbound
set scheme burd

local user "bksong"

cd "/Users/`user'/Dropbox/incumbency_rdd/anaysis_dataverse"

local dir "/Users/`user'/Dropbox/incumbency_rdd"
adopath + "`dir'/ado"

tempfile tmp tmp_all tmp2

/****************************************
* Estimation (Candidate-Level Analysis) *
*****************************************/

use data_cand, clear

matrix M   = J(6,5,.)
matrix w   = J(6,4,.)
matrix r   = J(6,5,.)
matrix lb  = J(6,4,.)
matrix lb2 = J(6,4,.)
matrix ub  = J(6,4,.)


forvalues i = 1/6 {

	rdbound f_run f_win win vmargin if office_num == `i', kernel(uniform)
	matrix M[`i',1] = `i'
	matrix M[`i',2] = e(bw_win)
	matrix M[`i',3] = e(N_win)
	matrix M[`i',4] = e(bw_run)
	matrix M[`i',5] = e(N_run)		
	
	matrix w[`i',1] = e(b_win)
	matrix w[`i',2] = e(se_win)
	matrix w[`i',3] = e(b_win) - 1.96 * e(se_win)
	matrix w[`i',4] = e(b_win) + 1.96 * e(se_win)
	
	matrix r[`i',1] = e(b_run)
	matrix r[`i',2] = e(se_run)
	matrix r[`i',3] = e(b_run) - 1.96 * e(se_run)
	matrix r[`i',4] = e(b_run) + 1.96 * e(se_run)	
	matrix r[`i',5] = e(r1)
	
	matrix lb[`i',1] = e(b_lb)
	matrix lb[`i',2] = e(se_lb)
	matrix lb[`i',3] = e(b_lb) - 1.96 * e(se_lb)
	matrix lb[`i',4] = e(b_lb) + 1.96 * e(se_lb)

	matrix lb2[`i',1] = e(b_lb2)
	matrix lb2[`i',2] = e(se_lb2)
	matrix lb2[`i',3] = e(b_lb2) - 1.96 * e(se_lb2)
	matrix lb2[`i',4] = e(b_lb2) + 1.96 * e(se_lb2)	
	
	matrix ub[`i',1] = e(b_ub)
	matrix ub[`i',2] = e(se_ub)
	matrix ub[`i',3] = e(b_ub) - 1.96 * e(se_ub)
	matrix ub[`i',4] = e(b_ub) + 1.96 * e(se_ub)

}

foreach x in M w r lb lb2 ub {
	svmat `x'
}

desc office_num
label values M1 office_num
drop win
keep M* w* r* lb* ub*
drop rd_s

foreach x in w r lb lb2 ub {
	local i = 0
	foreach y in b se left right {
		local i = `i' + 1
		rename `x'`i' `x'_`y'
	}
}
local i = 0	
foreach x in office_num w_bw w_obs r_bw r_obs {
	local i = `i' + 1
	rename M`i' `x'
}
rename r5 r1

dropmiss, obs force
compress
saveold est_cand, replace


clear all

use est_cand, clear

foreach x in w r lb lb2 ub {
	foreach y in b se left right {
		replace `x'_`y' = `x'_`y' / 100
	}
}
replace w_bw = w_bw / 100
replace r_bw = r_bw / 100


compress
saveold `tmp_all', replace



decode office_num, gen(office) 

gsort -w_b


/**********
* Results *
**********/

* Table A.3.

quietly {

	capture log close
  
	log using table_cand.tex, text replace

	noisily display "\begin{table}[htbp]"
	noisily display "\centering"
	noisily display "\begin{threeparttable}"
	noisily display "\caption{RD Estimates of the Incumbency Effect (Candidate-Level Analysis)}"
	noisily display "\label{table_cand}"
	noisily display "\begin{tabular}{lcccccc}"
	noisily display "\midrule\midrule"
	noisily display "&\multicolumn{2}{c}{Run at \$t+1$}&\multicolumn{4}{c}{Win at \$t+1$}\\"
	noisily display "\cmidrule(r){2-3}\cmidrule(r){4-7}"
	noisily display "&\multicolumn{2}{c}{}&\multicolumn{2}{c}{Unconditional}&\multicolumn{2}{c}{Conditional}\\"
	noisily display "\cmidrule(r){4-5}\cmidrule(r){6-7}"
	noisily display "&\multicolumn{1}{c}{Bandwidth}&\multicolumn{1}{c}{Estimate}&\multicolumn{1}{c}{Bandwidth}&\multicolumn{1}{c}{Estimate}&"
	noisily display "\multicolumn{1}{c}{Lower Bound}&\multicolumn{1}{c}{Upper Bound}\\"
	noisily display "\midrule"
	noisily display "&\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(4)}&\multicolumn{1}{c}{(5)}"
	noisily display "&\multicolumn{1}{c}{(5)}&\multicolumn{1}{c}{(6)}\\"
	noisily display "\midrule"
	noisily display "\addlinespace"
	
	
		forvalues i=1/6 {
		noisily display office[`i'] "&"    %5.3f r_bw[`i']    "&"  %5.3f  r_b[`i']   "&"    %5.3f w_bw[`i']    "&"  %5.3f w_b[`i']   "&" %5.3f lb_b[`i']    "&" %5.3f ub_b[`i']   "\\"
		noisily display             "&[N=" %6.0fc r_obs[`i'] "]&(" %5.3fc r_se[`i'] ")&[N=" %6.0fc w_obs[`i'] "]&(" %5.3f w_se[`i'] ")&(" %5.3f lb_se[`i'] ")&(" %5.3f ub_se[`i'] ")\\"
		noisily display "\addlinespace"
	}

	noisily display "\midrule\midrule"
	noisily display "\end{tabular}"
	noisily display "\begin{tablenotes}"
	noisily display "\footnotesize"
	noisily display "\item Standard errors in parentheses."
	noisily display "Estimates are obtained from local linear regressions"
	noisily display "with uniform kernel using the Calonico, Cattaneo and Titiunik (2014) optimal bandwidth."
	noisily display "\end{tablenotes}"
	noisily display "\end{threeparttable}"
	noisily display "\end{table}  "
  
	log off
  
	log close
}


* Figures *

keep office_num lb_* lb2_*
gen est = 2
compress
saveold `tmp', replace

use `tmp_all', clear
keep office_num ub_*
gen est = 3
saveold `tmp2', replace

use `tmp_all', clear
gen est = 1
drop lb_* ub_* lb2_*
append using `tmp'
append using `tmp2'

bysort office_num: egen x = total(w_b)
sort x est
drop x
gen id = _n

decode office_num, gen(x)
labmask id, values(x)
replace id = id-0.7 if est==2
replace id = id-1.4 if est==3
drop x


* Figure 3, Panel A.
twoway (scatter id r_b, msymbol(Oh) msize(medium) mcolor(blue))    ///
	   (rcap r_left r_right id, horizontal lcolor(blue)),                ///	 
	   scheme(burd)          ///
	   ylabel(1 (3) 15, valuelabel) ytitle("")	ymtick(none) ///
	   legend(off) xtitle("Effect on Running")
graph export figure_cand_run.eps, replace

* Figure 3, Panel B.
twoway (scatter id w_b, msymbol(Oh) msize(medium) mcolor(blue))    ///
	   (scatter id ub_b, msymbol(S) msize(medium) mcolor(red))    ///
	   (scatter id lb_b, msymbol(S) msize(medium) mcolor(red))    ///
	   (rcap w_left w_right id, horizontal lcolor(blue) msize(small))          ///
	   (rcap ub_left ub_right id, horizontal lcolor(red) msize(small)) ///
	   (rcap lb_left lb_right id, horizontal lcolor(red) msize(small)), ///
	   scheme(burd) xline(0, lpattern(dash) lcolor(black))          ///
	   ylabel(1 (3) 15, valuelabel) ytitle("")	ymtick(none) ///
	   xscale(range(-0.2 0.4)) xlabel(-0.2 (0.2) 0.4) ///
	   legend(order(1 "Unconditional" 2 "Bounds") position(5) ring(0) region(style(outline)) size(vsmall)) ///
	   xtitle("Effect on Winning")

graph export figure_cand_win.eps, replace

* Figure 4.
twoway (scatter id w_b,   msymbol(Oh) msize(medium) mcolor(blue))    ///
	   (scatter id lb2_b, msymbol(S) msize(medium) mcolor(red))    ///
	   (rcap w_left w_right id, horizontal lcolor(blue))                ///	 
	   (rcap lb2_left lb2_right id, horizontal lcolor(red) msize(small)), ///
	   scheme(burd) xline(0, lpattern(dash) lcolor(black))          ///
	   ylabel(1 (3) 15, valuelabel) ytitle("")	ymtick(none) ///
	   legend(order(1 "Unconditional" 2 "Conditional") position(5) ring(0) region(style(outline)) size(vsmall)) ///
	   xtitle("Effect on Winning")
graph export figure_cand_win2.eps, replace



