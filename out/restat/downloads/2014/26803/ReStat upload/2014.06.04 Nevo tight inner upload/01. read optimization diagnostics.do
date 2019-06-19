********************************************************************************
* To accompany Knittel and Metaxoglou
********************************************************************************
clear 
set memo 2000m
set type double
set more off
capture log close

********************************************************************************
* Define globals for paths and files
********************************************************************************
global root     = "C:/DB/Dropbox/RCOptim/ReStat/RESTAT Codes"
global path     = "$root/2014.06.04 Nevo tight inner/Optimization results"
global scripts  = "$root/2014.06.04 Nevo tight inner"
global xls_file = "$path/Optimization results diags.xlsx"
global out_file = "$path/Optimization results.dta"

*******************************************************************************
* Import fvals
*******************************************************************************
import excel using "$xls_file", clear sheet("fvals") case(lower) firstrow

capture rename fcn_evals fcnevals
capture rename exit_info exitinfo
capture rename convcrit2 gprime_invH_g

sort optmethod stvalue

save "$path/temp1.dta", replace

*******************************************************************************
* Import thetas
*******************************************************************************
import excel using "$xls_file", clear sheet("thetas") case(lower) firstrow

rename price   price_mean   
rename brand1  brand1_mean    
rename brand2  brand2_mean    
rename brand3  brand3_mean    
rename brand4  brand4_mean    
rename brand5  brand5_mean    
rename brand6  brand6_mean    
rename brand7  brand7_mean    
rename brand8  brand8_mean    
rename brand9  brand9_mean    
rename brand10 brand10_mean   
rename brand11 brand11_mean   
rename brand12 brand12_mean   
rename brand13 brand13_mean   
rename brand14 brand14_mean   
rename brand15 brand15_mean   
rename brand16 brand16_mean   
rename brand17 brand17_mean   
rename brand18 brand18_mean   
rename brand19 brand19_mean   
rename brand20 brand20_mean   
rename brand21 brand21_mean   
rename brand22 brand22_mean   
rename brand23 brand23_mean   
rename brand24 brand24_mean   

rename const_inc   const_inc_sigma                
rename price_inc   price_inc_sigma                
rename sugar_inc   sugar_inc_sigma                
rename mushy_inc   mushy_inc_sigma                
rename price_inc2  price_inc2_sigma

rename const_age   const_age_sigma
rename sugar_age   sugar_age_sigma
rename mushy_age   mushy_age_sigma                
rename price_child price_child_sigma

sort optmethod stvalue

save "$path/temp2.dta", replace

*******************************************************************************
* Import gradients
*******************************************************************************
import excel using "$xls_file", clear sheet("gradients") case(lower) firstrow

rename const_sigma  gradients1_const_sigma                
rename price_sigma  gradients1_price_sigma                
rename sugar_sigma  gradients1_sugar_sigma                
rename mushy_sigma  gradients1_mushy_sigma                

rename const_inc    gradients1_const_inc                
rename price_inc    gradients1_price_inc                
rename sugar_inc    gradients1_sugar_inc                
rename mushy_inc    gradients1_mushy_inc                
rename price_inc2   gradients1_price_inc2                

rename const_age    gradients1_const_age               
rename sugar_age    gradients1_sugar_age
rename mushy_age    gradients1_mushy_age
rename price_child  gradients1_price_child

sort optmethod stvalue

save "$path/temp3.dta", replace

*******************************************************************************
* Import hessian eigenvalues
*******************************************************************************
import excel using "$xls_file", clear sheet("hessians2") case(lower) firstrow

rename eig1  hessians2_eig1  
rename eig2  hessians2_eig2  
rename eig3  hessians2_eig3  
rename eig4  hessians2_eig4  
rename eig5  hessians2_eig5  
rename eig6  hessians2_eig6  
rename eig7  hessians2_eig7  
rename eig8  hessians2_eig8  
rename eig9  hessians2_eig9  
rename eig10 hessians2_eig10 
rename eig11 hessians2_eig11 
rename eig12 hessians2_eig12 
rename eig13 hessians2_eig13 

sort optmethod stvalue

compress

save "$path/temp4.dta", replace

*******************************************************************************
* Import std. errors
*******************************************************************************
import excel using "$xls_file", clear sheet("stderrors") case(lower) firstrow

rename brand1_se  brand1_mean_se    
rename brand2_se  brand2_mean_se    
rename brand3_se  brand3_mean_se    
rename brand4_se  brand4_mean_se    
rename brand5_se  brand5_mean_se    
rename brand6_se  brand6_mean_se    
rename brand7_se  brand7_mean_se    
rename brand8_se  brand8_mean_se    
rename brand9_se  brand9_mean_se    
rename brand10_se brand10_mean_se   
rename brand11_se brand11_mean_se   
rename brand12_se brand12_mean_se   
rename brand13_se brand13_mean_se   
rename brand14_se brand14_mean_se   
rename brand15_se brand15_mean_se   
rename brand16_se brand16_mean_se   
rename brand17_se brand17_mean_se   
rename brand18_se brand18_mean_se   
rename brand19_se brand19_mean_se   
rename brand20_se brand20_mean_se   
rename brand21_se brand21_mean_se   
rename brand22_se brand22_mean_se   
rename brand23_se brand23_mean_se   
rename brand24_se brand24_mean_se   

rename price_se       price_mean_se

rename const_inc_se   const_inc_sigma_se                
rename price_inc_se   price_inc_sigma_se                
rename sugar_inc_se   sugar_inc_sigma_se                
rename mushy_inc_se   mushy_inc_sigma_se                
rename price_inc2_se  price_inc2_sigma_se

rename const_age_se   const_age_sigma_se
rename sugar_age_se   sugar_age_sigma_se
rename mushy_age_se   mushy_age_sigma_se                
rename price_child_se price_child_sigma_se

sort optmethod stvalue

compress

save "$path/temp5.dta", replace

*******************************************************************************
* Merge intermediate files
*******************************************************************************
use "$path/temp1.dta", clear
forvalues i=2(1)5 {
	sort  optmethod stvalue
	merge optmethod stvalue using "$path/temp`i'.dta"
	assert _merge==3
	drop _merge
	erase "$path/temp`i'.dta"
}	

erase "$path/temp1.dta"

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
gen     tolfun = "1e-3"
gen     tolx   = "1e-3"
gen   tolnfp   = "DFS"

replace tolfun = "1e-3" if optmethod==12
replace tolfun = "1e-3" if optmethod==13
replace tolfun = "1e-6" if optmethod==15
replace tolfun = "1e-6" if optmethod==14

replace tolnfp = "NEVO" if optmethod==12
replace tolnfp = "DFS"  if optmethod==13
replace tolnfp = "NEVO" if optmethod==15
replace tolnfp = "DFS"  if optmethod==14

replace tolfun = "1e-6" if optmethod==16
replace tolnfp = "DFS"  if optmethod==16

*******************************************************************************
* Create fields for sorting results
* KNITRO in optmethod 16 is unbounded
*******************************************************************************
do "$scripts/00. standardize optmethods.do"

*******************************************************************************
drop  gradients*
global vars_to_keep tolfun tolx tolnfp fcnevals exitinfo toc fval fval_est fval_hess  grad_norm_inf share_norm_inf gprime_invH_g hessian_eig_min hessian_eig_max hess_posdef hess_cond_num *_mean *_sigma *_se	

keep  optmethod_str stvalue  $vars_to_keep
order optmethod_str stvalue  $vars_to_keep
sort  optmethod_str stvalue

foreach v of varlist $vars_to_keep {
	capture format `v' %12.4fc
}

compress

save "$out_file", replace
