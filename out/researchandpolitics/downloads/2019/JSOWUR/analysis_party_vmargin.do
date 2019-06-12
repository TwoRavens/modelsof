set more off
set linesize 255

local user "bksong"

cd "/Users/`user'/Dropbox/incumbency_rdd/analysis"

tempfile tmp tmp_all

foreach j in 1 4 {

local multiplier = `j' / 2

use data_party, clear

matrix M = J(8,3,.)
matrix itt = J(8,4,.)
matrix f = J(8,4,.)
matrix r = J(8,4,.)

gen vmargin2 = vmargin / 2
replace vmargin2 = vs / 2 if office_num == 5

forvalues i = 1/7 {

	quietly rdrobust vmargin2 l_vmargin if office_num == `i', kernel(uniform)
	local bw = e(h_bw) * `multiplier'
	
	rdrobust vmargin2 l_vmargin if office_num == `i', h(`bw') kernel(uniform)
	matrix M[`i',1] = `i'
	matrix M[`i',2] = e(h_bw)
	matrix M[`i',3] = e(N)
		
	matrix itt[`i',1] = e(tau_cl)
	matrix itt[`i',2] = e(se_cl)
	matrix itt[`i',3] = e(tau_cl) - 1.96 * e(se_cl)
	matrix itt[`i',4] = e(tau_cl) + 1.96 * e(se_cl)

	rdrobust vmargin2 l_vmargin if office_num == `i', h(`bw') fuzzy(inc) kernel(uniform)
	
	matrix f[`i',1] = e(tau_F_cl)
	matrix f[`i',2] = e(se_F_cl)
	matrix f[`i',3] = e(tau_F_cl) - 1.96 * e(se_F_cl)
	matrix f[`i',4] = e(tau_F_cl) + 1.96 * e(se_F_cl)

	rdrobust inc l_vmargin if office_num == `i', h(`bw') kernel(uniform)
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
rename M2 bw`j'
rename M3 obs`j'

foreach x in itt f r {
	rename `x'1 b`j'_`x'
	rename `x'2 se`j'_`x'
	rename `x'3 l`j'_`x'
	rename `x'4 r`j'_`x'
}



dropmiss, obs force


compress
saveold tmp_vmargin_`j', replace

}




use tmp_vmargin_1, clear
merge 1:1 office_num using tmp_vmargin_4
drop _merge



decode office_num, gen(office) 


* table

sort office_num


quietly {

	capture log close
  
	log using "/Users/`user'/Dropbox/incumbency_rdd/draft/table_party_vmargin_rb.tex", text replace

	noisily display "\begin{table}[htbp]"
	noisily display "\centering"
	noisily display "\begin{threeparttable}"
	noisily display "\caption{RD Estimates of the Incumbency Effect (Party-Level Analysis)}"
	noisily display "\label{table_party_vm_rb}"
	noisily display "\begin{tabular}{lcccccccc}"
	noisily display "\midrule\midrule"
	noisily display "&\multicolumn{4}{c}{Optimal BW / 2}&\multicolumn{4}{c}{Optimal BW $\times$ 2}\\"
	noisily display "\cmidrule(r){2-5}\cmidrule(r){6-9}"  
	noisily display "&\multicolumn{1}{c}{Bandwidth}&\multicolumn{1}{c}{ITT Est.}&\multicolumn{1}{c}{Fuzzy RD}&\multicolumn{1}{c}{First Stage}"
	noisily display "&\multicolumn{1}{c}{Bandwidth}&\multicolumn{1}{c}{ITT Est.}&\multicolumn{1}{c}{Fuzzy RD}&\multicolumn{1}{c}{First Stage}\\"
	*noisily display "\cmidrule(r){3-5}"  
	noisily display "\midrule"
	noisily display "\addlinespace"

	forvalues i=1/7 {
		noisily display office[`i'] "&"    %5.3f  bw1[`i']    "&" %5.3f b1_itt[`i']   "&"  %5.3f b1_f[`i']   "&"  %5.3f b1_r[`i']
		noisily display             "&"    %5.3f  bw4[`i']    "&" %5.3f b4_itt[`i']   "&"  %5.3f b4_f[`i']   "&"  %5.3f b4_r[`i']  "\\"
		noisily display             "&[N=" %5.0fc obs1[`i'] "]&(" %5.3f se1_itt[`i'] ")&(" %5.3f se1_f[`i'] ")&(" %5.3f se1_r[`i'] ")"
		noisily display             "&[N=" %5.0fc obs4[`i'] "]&(" %5.3f se4_itt[`i'] ")&(" %5.3f se4_f[`i'] ")&(" %5.3f se4_r[`i'] ")\\"
		noisily display "\addlinespace"
	}
  

	noisily display "\midrule\midrule"
	noisily display "\end{tabular}"
	noisily display "\begin{tablenotes}"
	noisily display "\footnotesize"
	noisily display "\item Standard errors in parentheses."
	noisily display "This table repeats the analyses reported in Table \ref{table_party_vm}"
	noisily display "using half and twice the size of the \cite{Calonico2014b} optimal bandwidth."
	noisily display "\end{tablenotes}"
	noisily display "\end{threeparttable}"
	noisily display "\end{table}"
  
	log off
  
	log close
}

erase tmp_vmargin_1.dta
erase tmp_vmargin_4.dta


