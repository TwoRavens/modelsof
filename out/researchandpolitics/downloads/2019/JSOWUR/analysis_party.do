set more off
set linesize 255

local user "bksong"

cd "/Users/`user'/Dropbox/incumbency_rdd/anaysis_dataverse"

tempfile tmp tmp_all

/************************************
* Estimation (Party-Level Analysis) *
*************************************/
* Dependent var = win


use data_party, clear

matrix M = J(8,3,.)
matrix itt = J(8,4,.)
matrix f = J(8,4,.)
matrix r = J(8,4,.)


forvalues i = 1/7 {

	rdrobust_old win l_vmargin if office_num == `i', kernel(uniform)
	local bw = e(h_bw)
	
	matrix M[`i',1] = `i'
	matrix M[`i',2] = e(h_bw)
	matrix M[`i',3] = e(N)
		
	matrix itt[`i',1] = e(tau_cl)
	matrix itt[`i',2] = e(se_cl)
	matrix itt[`i',3] = e(tau_cl) - 1.96 * e(se_cl)
	matrix itt[`i',4] = e(tau_cl) + 1.96 * e(se_cl)

	rdrobust_old win l_vmargin if office_num == `i', fuzzy(inc) kernel(uniform)
	
	matrix f[`i',1] = e(tau_F_cl)
	matrix f[`i',2] = e(se_F_cl)
	matrix f[`i',3] = e(tau_F_cl) - 1.96 * e(se_F_cl)
	matrix f[`i',4] = e(tau_F_cl) + 1.96 * e(se_F_cl)

	rdrobust_old inc l_vmargin if office_num == `i', h(`bw') kernel(uniform)
	matrix r[`i',1] = e(tau_cl)
	matrix r[`i',2] = e(se_cl)
	matrix r[`i',3] = e(tau_cl) - 1.96 * e(se_cl)
	matrix r[`i',4] = e(tau_cl) + 1.96 * e(se_cl)
	
}

foreach x in M itt f r {
	svmat `x'
}
keep M* itt* f* r*
drop rd_s 

rename M1 office_num
label values office_num office_num_name
rename M2 bw
rename M3 obs

foreach x in itt f r {
	rename `x'1 b_`x'
	rename `x'2 se_`x'
	rename `x'3 l_`x'
	rename `x'4 r_`x'
}

dropmiss, obs force

compress
saveold est_party, replace


/**********
* Results *
**********/

clear all

use est_party, clear

decode office_num, gen(office) 

gsort -b_itt


* Table A.1.

quietly {

	capture log close
  
	log using table_party.tex, text replace

	noisily display "\begin{table}[htbp]"
	noisily display "\centering"
	noisily display "\begin{threeparttable}"
	noisily display "\caption{RD Estimates of the Incumbency Effect (Party-Level Analysis)}"
	noisily display "\label{table_party}"
	noisily display "\begin{tabular}{lcccc}"
	noisily display "\midrule\midrule"
	noisily display "&&\multicolumn{1}{c}{ITT Estimate}&\multicolumn{1}{c}{Fuzzy RD}&\multicolumn{1}{c}{First Stage}\\
	noisily display "\cmidrule(r){3-5}"  
	noisily display "&\multicolumn{1}{c}{Bandwidth}&\multicolumn{1}{c}{(1)}&\multicolumn{1}{c}{(2)}&\multicolumn{1}{c}{(3)}\\"
	noisily display "\midrule"
	noisily display "\addlinespace"

	forvalues i=1/7 {
		noisily display office[`i'] "&"    %5.3f  bw[`i']    "&" %5.3f b_itt[`i']   "&"  %5.3f b_f[`i']   "&"  %5.3f b_r[`i']  "\\"
		noisily display             "&[N=" %5.0fc obs[`i'] "]&(" %5.3f se_itt[`i'] ")&(" %5.3f se_f[`i'] ")&(" %5.3f se_r[`i'] ")\\"
		noisily display "\addlinespace"
	}
  

	noisily display "\midrule\midrule"
	noisily display "\end{tabular}"
	noisily display "\begin{tablenotes}"
	noisily display "\footnotesize"
	noisily display "\item Standard errors in parentheses are calculated according to"
	noisily display "\cite{Calonico2014b}. Estimates are obtained from local linear regressions"
	noisily display "with uniform kernel using the Calonico, Cattaneo and Titiunik (2014) optimal bandwidth."
	noisily display "\end{tablenotes}"
	noisily display "\end{threeparttable}"
	noisily display "\end{table}"
  
	log off
  
	log close
}



** Figures

saveold `tmp_all', replace

keep office_num office b_f-r_r
gen est = 2
compress
saveold `tmp', replace

use `tmp_all', clear
drop b_f-r_r
gen est = 1
append using `tmp'

gsort -office_num est

gen id = _n

decode office_num, gen(x)
labmask id, values(x)
replace id = id-0.7 if est==2
drop x

* Figure 1.
twoway (scatter id b_r, msymbol(Oh) msize(medium) mcolor(blue))    ///
	   (rcap l_r r_r id, horizontal lcolor(blue)),                ///	 
	   scheme(burd)          ///
	   ylabel(1 (2) 14, valuelabel) ytitle("")	ymtick(none) ///
	   xscale(range(0 2)) xlabel(0 (0.5) 2) ///
	   legend(off) name(left) xline(1, lpattern(dash)) xtitle("Effect on Running")
graph export figure_party_run.eps, replace


* Figure 2, Panel A.
twoway (scatter id b_itt, msymbol(Oh) msize(medium) mcolor(blue))    ///
	   (scatter id b_f, msymbol(S) msize(medium) mcolor(red))  ///
	   (rcap l_itt r_itt id, horizontal lcolor(blue))                ///	 
	   (rcap l_f r_f id, horizontal lcolor(red)),                ///	 
	   scheme(burd) xline(0, lpattern(dash))          ///
	   ylabel(1 (2) 14, valuelabel) ytitle("")	ymtick(none)		   ///
	   xscale(range(-0.55 0.4)) xlabel(-0.6 (0.2) 0.4) ///
	   legend(order(1 "ITT" 2 "Fuzzy") size(vsmall) position(5) ring(0) region(style(outline)) ) ///
	   xtitle("Effect on Winning")
graph export figure_party_win.eps, replace



