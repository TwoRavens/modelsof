set more off
cap program drop rdbound
set scheme burd

local user "bksong"

cd "/Users/`user'/Dropbox/incumbency_rdd/anaysis_dataverse"

tempfile tmp tmp_all tmp1 tmp4

/**********************************************
* Robustness Check (Candidate-Level Analysis) *
**********************************************/


foreach j in 1 4 {

use data_cand, clear

matrix M = J(6,5,.)
matrix w = J(6,4,.)
matrix r = J(6,5,.)
matrix lb = J(6,4,.)
matrix ub = J(6,4,.)

local multiplier = `j' / 2

forvalues i = 1/6 {
	
	quietly rdbound f_run f_win win vmargin if office_num == `i', kernel(uniform)
	local bw_run = e(bw_run) * `multiplier'
	local bw_win = e(bw_win) * `multiplier'
	
	rdbound f_run f_win win vmargin if office_num == `i', h_run(`bw_run') h_win(`bw_win') kernel(uniform)
	matrix M[`i',1] = `i'
	matrix M[`i',2] = `bw_win'
	matrix M[`i',3] = e(N_win)
	matrix M[`i',4] = `bw_run'
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
	
	matrix ub[`i',1] = e(b_ub)
	matrix ub[`i',2] = e(se_ub)
	matrix ub[`i',3] = e(b_ub) - 1.96 * e(se_ub)
	matrix ub[`i',4] = e(b_ub) + 1.96 * e(se_ub)

}

foreach x in M w r lb ub {
	svmat `x'
}

desc office_num
label values M1 office_num
drop win
keep M* w* r* lb* ub*
drop rd_s

foreach x in w r lb ub {
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
saveold est_cand_rb`j', replace
}


clear all

use est_cand, clear
keep office_num w_b
compress
saveold `tmp', replace

foreach i in 1 4 {
	use est_cand_rb`i', clear

	foreach x in w r lb ub {
		foreach y in b se left right {
			replace `x'_`y' = `x'_`y' / 100
		}
	}
	replace w_bw = w_bw / 100
	replace r_bw = r_bw / 100

	merge 1:1 office_num using `tmp'
	drop _merge
	
	decode office_num, gen(office) 
	
	gsort -w_b
	drop w_b
	
	compress
	saveold `tmp`i'', replace
}

/**********
* Results *
**********/

* Table F.3 and Table F.4.

foreach j in 1 4 {

use `tmp`j'', clear

quietly {

	capture log close
  
	log using table_cand_rb`j'.tex, text replace

	noisily display "\begin{table}[htbp]"
	noisily display "\centering"
	noisily display "\begin{threeparttable}"
	noisily display "\caption{RD Estimates of the Incumbency Effect (Candidate-Level Analysis)}"
	noisily display "\label{table_cand_rb`j'}"
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
	noisily display "This table repeats the analyses reported in Table \ref{table_cand} using"
	
	log off
	
	log close
	
}

}

quietly {

	capture log close
  
	log using table_cand_rb1.tex, text append
	
	noisily display "half the size of the Calonico, Cattaneo and Titiunik (2014) optimal bandwidth."
	noisily display "\end{tablenotes}"
	noisily display "\end{threeparttable}"
	noisily display "\end{table}  "
  
	log off
  
	log close
}


quietly {

	capture log close
  
	log using table_cand_rb4.tex, text append
	
	noisily display "twice the size of the Calonico, Cattaneo and Titiunik (2014) optimal bandwidth."
	noisily display "\end{tablenotes}"
	noisily display "\end{threeparttable}"
	noisily display "\end{table}  "
  
	log off
  
	log close
}


