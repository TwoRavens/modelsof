capture log close

do ezOP_06.do

//	Drop the surplus replications (149-184), as they conoicide

use intg_distwy0609faminc_rep.dta, clear
tempfile fileuse2
duplicates drop quantile repl, force
save `fileuse2', replace

//	Stores the pdf estimates and quantiles for the groups at every bootstrap iteration

tempfile fileusing_pdf
use eop_bootfile_dec_rep, clear
gen id = repl*1000 + p
keep  steps repl p group id intgpdf*
foreach i of numlist 1(1)10 {
	replace intgpdf`i' = . if group!=`i'
	gen steps`i' = steps if group==`i'
}
drop steps 
rename intgpdf intgpdf_tot
reshape wide steps* intgpdf*, i(id) j(group)
foreach i of numlist 1(1)9 {
	local x = `i'*10 + `i'
	rename intgpdf`x' Sintg`i'_p1t1wy0609_pdf
	rename steps`x' Sintg`i'_p1t1wy0609
}
rename intgpdf1010 Sintg10_p1t1wy0609_pdf
rename steps1010 Sintg10_p1t1wy0609
drop intgpdf* steps*
rename p quantile
save `fileusing_pdf', replace


//	Obtain quantiles (q=19) for the QTE as averages of bootstrapped QTE.
//	Obtain COVARIANCES between quantiles (q=19) for the QTE estimated by the covariance between bspped QTE

use eop_bootfile_intg_rep, clear
sort repl quantile
qui sum repl
local repmax = r(max)
qui sum quantile if repl==1
local qmax = r(max)
foreach P of numlist 1(1)4 {
	mat FI_`P' = J(`qmax',1,0)
	foreach rep of numlist 1(1)`repmax' {
		mkmat   intg1_p1t1faminc`P' if repl==0, mat(FI_`P'_`rep') nomis
		mat FI_`P' = FI_`P',FI_`P'_`rep'
	}
	mat FI_`P' = FI_`P'[.,2..`repmax'+1]
}

rename intg1_p1t1wy0609 intgAVG_p1t1wy0609
rename intg1_p1t1wy0609_pdf pdf_tot
keep quantile repl intg1_p1t1faminc* intgAVG_p1t1wy0609 pdf_tot

tempfile fileuse3
save `fileuse3', replace

//	Uses the main data source

use eop_bootfile_dec_rep, clear
sort repl group p
gen id = repl*1000 + p
rename p quantile
keep  intg4_pt* intg4_pt_faminc1* intg4_pt_faminc2* intg4_pt_faminc3* intg4_pt_faminc4* repl quantile group  id
reshape wide intg4_pt intg4_pt_faminc1 intg4_pt_faminc2 intg4_pt_faminc3 intg4_pt_faminc4, i(id) j(group)

foreach var of varlist intg4_pt* intg4_pt_faminc1* intg4_pt_faminc2* intg4_pt_faminc3* intg4_pt_faminc4* {
	replace `var' = 0 if `var'==.
}

*	Rename variables to set variables after a merge

local vars " "
foreach x of numlist 1(1)10 {
	local var "intg`x'_p1t1wy0609 intg`x'_p1t1wy0609_pdf" 
	local vars  "`vars' `var'"
}

local vars2 " "
foreach x of numlist 1(1)10 {
	local var2 "Sintg`x'_p1t1wy0609 Sintg`x'_p1t1wy0609_pdf" 
	local vars2  "`vars2' `var2'"
}

merge 1:1 repl quantile using `fileuse2', nogen keepusing( `vars' )
merge 1:1 repl quantile using `fileusing_pdf', nogen keepusing( `vars2' )
merge 1:1 repl quantile using `fileuse3', nogen
drop if id==.

foreach g of numlist 1(1)10 {
	rename intg`g'_p1t1wy0609 ez_i`g'_p1t1
	rename intg`g'_p1t1wy0609_pdf ez_i`g'_p1t1_pdf	
	rename Sintg`g'_p1t1wy0609_pdf Sez_i`g'_p1t1_pdf	
	foreach x of numlist 1(1)4 {
		rename intg4_pt_faminc`x'`g' intg41pt_faminc`x'`g'
	}
	rename intg4_pt`g' intg41pt`g'
}


*	MEAN/MEDIAN of the QTE

foreach x of numlist 1(1)10 {
	if `x'==10 {
		local int`x' "91(1)99"
	}
	else {
		local x2 = `x'*10 - 9
		local x3 = `x'*10 
		local int`x' "`x2'(1)`x3'"
	}
	foreach q of numlist `int`x'' {
		gen double rif_ez_i`x'_`q' = .
		foreach rep of numlist 1(1)`repmax' {
			foreach P of numlist 1(1)4 {
				local fi`rep'_`x'_`P' = FI_`P'[`q',`rep']
			}
			foreach g of numlist 1(1)10 {
*				local fgroup_`g' = fgroup_`g'[`q',`rep']
				if `q'/10>`g'-1 & `q'/10<=`g' {
					replace rif_ez_i`x'_`q' =  (1/Sez_i`g'_p1t1_pdf)*(intg41pt`g' + intg41pt_faminc1`g'*`fi`rep'_`x'_1' + intg41pt_faminc2`g'*`fi`rep'_`x'_2' + intg41pt_faminc3`g'*`fi`rep'_`x'_3' + intg41pt_faminc4`g'*`fi`rep'_`x'_4') if repl == `rep'
				}
			}			
		}
	}
	egen rif_ez_MEANi`x' = rowmean(rif_ez_i`x'_*)
	egen rif_ez_MEDIANi`x' = rowmedian(rif_ez_i`x'_*)	
	drop rif_ez_i`x'_*
}


*	QTE at MEDIAN
local repmax=20

foreach x of numlist 1(1)10 {
	local x2 = `x'*10 - 5
	gen rif_ez_ATMEDIANi`x' = .
	foreach rep of numlist 1(1)`repmax' {
		foreach P of numlist 1(1)4 {
			local fi`rep'_`x'_`P' = FI_`P'[`x',`rep']
		}
		replace rif_ez_ATMEDIANi`x' =  (1/Sez_i`x'_p1t1_pdf)*(intg41pt`x' + intg41pt_faminc1`x'*`fi`rep'_`x'_1' + intg41pt_faminc2`x'*`fi`rep'_`x'_2' + intg41pt_faminc3`x'*`fi`rep'_`x'_3' + intg41pt_faminc4`x'*`fi`rep'_`x'_4') if repl == `rep'
	}
}

drop if repl==0
save data_merged.dta, replace

