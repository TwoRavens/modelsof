*******************************************************************************
* To accompany Knittel and Metaxoglou
*******************************************************************************
clear 
set memo 2000m
set type double
set more off
capture log close

*******************************************************************************
* Define globals for paths and files
*******************************************************************************
global root     = "C:/DB/Dropbox/RCOptim/ReStat/BLP"
global path     = "$root/2013.08.16 BLP tight inner e06/optimization results"
global scripts  = "$root/2013.08.16 BLP tight inner e06"
global xls_file = "$path/Optimization results diags.xlsx"
global out_file = "$path/Optimization results.dta"

*******************************************************************************
* Import fvals
*******************************************************************************
import excel using "$xls_file", sheet("fvals") clear firstrow case(lower)

capture rename fcn_evals fcnevals
capture rename exit_info exitinfo
capture rename convcrit2 gprime_invH_g

sort    optmethod stvalue
save    "$path/temp1.dta", replace

*******************************************************************************
* Import thetas
*******************************************************************************
import excel using "$xls_file", sheet("thetas") clear firstrow case(lower)
sort    optmethod stvalue
save    "$path/temp2.dta", replace

*******************************************************************************
* Import std. errors
*******************************************************************************
import excel using "$xls_file", sheet("stderrs") clear firstrow case(lower)
sort    optmethod stvalue
save    "$path/temp3.dta", replace

*******************************************************************************
* Import gradeints
*******************************************************************************
import excel using "$xls_file", sheet("gradients") clear firstrow case(lower)

rename  price_sigma gradients1_price_sigma
rename  const_sigma gradients1_const_sigma
rename  hpwt_sigma  gradients1_hpwt_sigma
rename  air_sigma   gradients1_air_sigma
rename  mpg_sigma   gradients1_mpg_sigma

sort    optmethod stvalue

save    "$path/temp4.dta", replace

*******************************************************************************
* Import hessian eigenvalues
*******************************************************************************
import excel using "$xls_file", sheet("hessians2") clear firstrow case(lower)

rename eig1 hessians2_eig1  
rename eig2 hessians2_eig2  
rename eig3 hessians2_eig3  
rename eig4 hessians2_eig4  
rename eig5 hessians2_eig5  

sort  optmethod stvalue

save   "$path/temp5.dta", replace

*******************************************************************************
* Merge intermediate files
*******************************************************************************
use "$path/temp1.dta", clear

forvalues i=2(1)5 {
	merge optmethod stvalue using "$path/temp`i'.dta"
	assert _merge==3
	drop  _merge
	sort optmethod stvalue
	capture erase "$path/temp`i'.dta"
}

capture erase "$path/temp1.dta"

*******************************************************************************
* Identify positive definite hessians
*******************************************************************************
egen    hessian_eig_min  = rowmin(hessians2_eig*)
egen    hessian_eig_max  = rowmax(hessians2_eig*)
gen     hess_posdef      = 0 
gen     hess_cond_num    = hessian_eig_max/hessian_eig_min
replace hess_posdef=1 if hessian_eig_min  >0

*******************************************************************************
* Track tolerances
*******************************************************************************
gen     tolfun = "1e-6"
gen     tolx   = "1e-6"
gen   tolnfp   = "DFS"

*******************************************************************************
* Create fields for sorting results
*******************************************************************************
do "$scripts/00. standardize optmethods.do"

*******************************************************************************
drop gradients1*

#delimit ;
global vars_to_keep tolfun tolx tolnfp fcnevals exitinfo toc fval fval_est fval_hess  grad_norm_inf share_norm_inf gprime_invH_g 
hessian_eig_min hessian_eig_max hess_posdef hess_cond_num *_mean *_sigma *_se;
#delimit cr

keep  optmethod_str stvalue  $vars_to_keep
order optmethod_str stvalue  $vars_to_keep
sort  optmethod_str stvalue

foreach v of varlist $vars_to_keep {
	capture format `v' %12.4fc
}

compress

save "$out_file", replace

*EOF
