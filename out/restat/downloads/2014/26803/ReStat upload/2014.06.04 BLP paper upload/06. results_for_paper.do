clear all
set more off
set memo 5000m
capture log close

global path       = "C:/DB/Dropbox/RCoptim/ReStat/RESTAT Codes"

global loose_blp       = "$path/2014.06.04 BLP"
global loose_nevo      = "$path/2014.06.04 Nevo"
global tight_blp       = "$path/2014.06.04 BLP tight inner"
global tight_nevo      = "$path/2014.06.04 Nevo tight inner"
global paper_blp       = "$path/2014.06.04 BLP paper/figures"
global paper_nevo      = "$path/2014.06.04 Nevo paper/figures"
global paper_blp_temp  = "$path/2014.06.04 BLP paper/temp"
global paper_nevo_temp = "$path/2014.06.04 Nevo paper/temp"

qui log using "$path/2014.06.04 BLP paper/logs/results_for_draft.log", replace

********************************************************************************
*The relevant BLP  KNITRO runs are optmethod 11 (loose) and optmethod 13 (tight) corresponding to DER5-KN1 and DER6-KNI2
*The relevant NEVO KNITRO runs are optmethod 12 (loose) and optmethod 13 (tight) corresponding to DER5-KN1 and DER6-KNI2
********************************************************************************
use "$loose_blp/Optimization results/Optimization results.dta", clear

tab optmethod
 
use "$tight_blp/Optimization results/Optimization results.dta", clear

tab optmethod

use "$loose_nevo/Optimization results/Optimization results.dta", clear

tab optmethod
 
use "$tight_nevo/Optimization results/Optimization results.dta", clear

tab optmethod

********************************************************************************
* Comments on BLP convergence
********************************************************************************
use "$paper_blp/blp_optim.dta", clear

tab converged tol_tight
tab optmethod_str converged 

tab exitinfo tol_tight if converged==0 &  optmethod_str=="DIR1-SIM"
tab exitinfo tol_tight if converged==0 &  optmethod_str=="STO1-SIA"

tab exitinfo if optmethod_str=="DER5-KNI"

********************************************************************************
* Comments on Nevo convergence
********************************************************************************
use "$paper_nevo/nevo_optim.dta", clear

tab converged tol_tight
tab optmethod_str converged 

tab exitinfo tol_tight if converged==0 &  optmethod_str=="STO1-SIA"
tab exitinfo tol_tight if converged==0 &  optmethod_str=="DIR1-SIM"
tab exitinfo tol_tight if converged==0 &  optmethod_str=="DIR2-MAD"

********************************************************************************
* Comments on BLP convergence for fval
********************************************************************************
use "$paper_blp/blp_optim.dta", clear

keep if converged==1

format fval %10.2fc

sum fval, detail format

sum fval if tol_tight==1, detail format

********************************************************************************
* Comments on Nevo convergence for fval
********************************************************************************
use "$paper_nevo/nevo_optim.dta", clear

keep if converged==1

format fval %10.2fc

sum fval, detail format

sum fval if tol_tight==1, detail format

********************************************************************************
* Comments on the BLP hbox
********************************************************************************
use "$paper_blp/blp_optim.dta", clear

format fval %10.2fc

keep if converged==1

gen     tol_tight_str="YES"
replace tol_tight_str="NO" if tol_tight==0

global fval_upper=340

tab  optmethod_str tol_tight_str              if fval<=$fval_upper

list optmethod_str tol_tight_str fval stvalue if fval<=$fval_upper & flag_best==1 & fval<=157.79

list optmethod_str tol_tight_str fval stvalue if fval<=$fval_upper & flag_best==1 & fval>157.79 & fval<=159

sum fval if optmethod_str =="DER5-KNI"  

sum fval if strpos(optmethod_str,"DER")    & fval<$fval_upper, format
sum fval if strpos(optmethod_str,"DER1")>0 & fval<$fval_upper, format
sum fval if strpos(optmethod_str,"DER3")>0 & fval<$fval_upper, format
sum fval if strpos(optmethod_str,"DER2")>0 & fval<$fval_upper, format
sum fval if strpos(optmethod_str,"DER4")>0 & fval<$fval_upper, format

sum fval if strpos(optmethod_str,"DIR1")>0 & fval<$fval_upper, format
sum fval if strpos(optmethod_str,"DIR2")>0 & fval<$fval_upper, format
sum fval if strpos(optmethod_str,"DIR3")>0 & fval<$fval_upper, format

sum fval if strpos(optmethod_str,"STO2")>0 & fval<$fval_upper, format
sum fval if strpos(optmethod_str,"STO1")>0 & fval<$fval_upper, format
sum fval if strpos(optmethod_str,"STO3")>0 & fval<$fval_upper, format

********************************************************************************
* Comments on the Nevo hbox
********************************************************************************
use "$paper_nevo/nevo_optim.dta", clear

format fval %10.2fc

keep if converged==1

gen     tol_tight_str="YES"
replace tol_tight_str="NO" if tol_tight==0

global fval_upper=110

tab  optmethod_str tol_tight_str      if fval<=$fval_upper

list optmethod_str tol_tight_str fval if fval<=$fval_upper & flag_best==1 & fval<=4.57

count    if optmethod_str =="DER4-SOL" & fval<=4.57
sum fval if optmethod_str =="DER1-QN1" & fval<$fval_upper, format 
sum fval if optmethod_str =="DER3-CGR" & fval<$fval_upper, format

sum fval                if strpos(optmethod_str,"DIR")>0 & fval<$fval_upper, format

sum fval if optmethod_str =="DIR1-SIM" & fval<$fval_upper, format
sum fval if optmethod_str =="DIR3-GPS" & fval<$fval_upper, format

sum fval                if strpos(optmethod_str,"STO")>0 & fval<$fval_upper, format

sum fval if optmethod_str =="STO2-GAL" & fval<$fval_upper, format
sum fval if optmethod_str =="STO3-SIG" & fval<$fval_upper, format

********************************************************************************
* Comparisons with DFS
********************************************************************************
tab exitinfo tol_tight if optmethod_str =="DER5-KNI", mi

tab exitinfo tol_tight if optmethod_str =="DIR1-SIM", mi

gsort fval 
list fval exitinfo if optmethod_str =="DIR1-SIM" & tol_tight==1

********************************************************************************
* Gradients and Hessians BLP
********************************************************************************
use "$paper_blp/BLP_fval_best.dta", clear 

format hessian_eig_max hessian_eig_min  hess_cond_num %10.2e

keep if converged==1 & tol_tight==1

sort grad_norm
list optmethod_str stvalue fval grad_norm hess_posdef gprime_invH_g

list optmethod_str stvalue fval hessian_eig_max hessian_eig_min hess_cond_num

import excel using "$tight_blp/Optimization results/hessian_diags.xlsx", clear sheet("diags") firstrow case(lower)

format extrem_val %10.4f

gsort eigvalue_norm	
list  var extrem_elem extrem_val 

********************************************************************************
* Gradients and Hessians Nevo
********************************************************************************
use "$paper_nevo/Nevo_fval_best.dta", clear 

format hessian_eig_max hessian_eig_min  hess_cond_num %10.2e

keep if converged==1 & tol_tight==1

sort grad_norm
list optmethod_str grad_norm hess_posdef  gprime_invH_g

sort fval

list optmethod_str stvalue hessian_eig_max hessian_eig_min  hess_cond_num

import excel using "$tight_nevo/Optimization results/hessian_diags.xlsx", clear sheet("hessian_eigsystem") firstrow case(lower)

format extrem_val %10.4f

gsort eigvalue_norm	
list  var extrem_elem extrem_val 

********************************************************************************
* Local optima BLP
********************************************************************************
use "$paper_blp/BLP_fval_local.dta", clear 

keep if converged==1 & tol_tight==1  

sum grad_norm hess_cond_num gprime_invH_g 

gen fval_round=round(fval,0.01)
tab fval_round

preserve
	tab fval_round if fval_round>=204 & fval_round<=205
	keep           if fval_round>=204 & fval_round<=205

	* identify algorithms
	tab optmethod_str 

	* parameter estimates are largely identical?
	sum *_mean  
	sum *_sigma 

	sum grad_norm     

	sum gprime_invH_g 

	count if  hess_posdef==1 

	gen hessian_eig_min_norm = hessian_eig_min/hessian_eig_max
	
	format hessian_eig_min_norm hess_cond_num %10.2e

	sum hessian_eig_min_norm, format 
	sum hess_cond_num, format
restore	

preserve
	keep if flag_best==0
	keep if fval_round<204 | fval_round>205

	* identify algorithms
	gsort fval
	list optmethod_str fval_round

	sum grad_norm     

	sum gprime_invH_g 

	count if  hess_posdef==1 

	gen hessian_eig_min_norm = hessian_eig_min/hessian_eig_max
	
	format hessian_eig_min_norm hess_cond_num %10.2e

	sum hessian_eig_min_norm, format 
	sum hess_cond_num, format
restore	

********************************************************************************
* Local optima Nevo
********************************************************************************
use "$paper_nevo/Nevo_fval_local.dta", clear 

keep if optmethod_str=="DER5-KNI" & tol_tight==0 & fval>5

sort fval
sum  fval

format *_mean *_sigma %10.4f
sum    *_mean *_sigma, format

format  grad_norm_inf  gprime_invH_g %10.4f
sum     grad_norm_inf  gprime_invH_g, format

gen     hessian_eig_min_norm =  hessian_eig_min / hessian_eig_max
format  hessian_eig_min_norm %10.3e
gsort   hessian_eig_min_norm
list    hessian_eig_min_norm

format hess_cond_num %10.2e
gsort  hess_cond_num
list   hess_cond_num

********************************************************************************
* largest and median products BLP
********************************************************************************
use "$paper_blp/BLP_merger_stats_product_focus.dta", clear

keep if flag_largest==1 | flag_median==1

preserve
	keep if flag_largest==1
	gsort fval
	count
	list newmodv market share_obs fval elast_own in 1
restore
preserve
	keep if flag_median==1
	gsort fval
	count
	list newmodv market share_obs fval elast_own in 1
restore

********************************************************************************
* largest and median products nevo
********************************************************************************
use "$paper_nevo/nevo_merger_stats_product_focus.dta", clear

keep if flag_largest==1 | flag_median==1

preserve
	keep if flag_largest==1
	gsort fval
	count
	list brand market share_obs fval elast_own in 1
restore
preserve
	keep if flag_median==1
	gsort fval
	count
	list brand market share_obs fval elast_own in 1
restore

********************************************************************************
* BLP obs for economic vars of interest
********************************************************************************
use "$paper_blp_temp/blp_merger_stats_product.dta", clear

* Clean 1. Keep tight NFP and converged
keep if tol_tight==1 & converged==1

gen  share_post_miss     = mi(share_post)
egen share_post_miss_max = max(share_post_miss), by(tol_tight optmethod_str stvalue)

gen  share_post_1        = share_post>1
egen share_post_1_max    = max(share_post_1)   , by(tol_tight optmethod_str stvalue)

gen  share_pre_miss      = mi(share_pre)
egen share_pre_miss_max  = max(share_pre_miss) ,  by(tol_tight optmethod_str stvalue)

gen  share_pre_1         = share_pre>1
egen share_pre_1_max     = max(share_pre_1)    ,  by(tol_tight optmethod_str stvalue)

* Clean 2. Exclude based on market shares
drop if share_post_miss_max>0
drop if  share_pre_miss_max>0
drop if     share_pre_1_max>0
drop if    share_post_1_max>0

keep fval
duplicates drop
sum fval, detail
qui return  list
global fval_upper = r(p95)
count if fval<=$fval_upper

********************************************************************************
* Nevo obs for economic vars of interest
********************************************************************************
use "$paper_nevo_temp/nevo_merger_stats_product.dta", clear

* Clean 1. Keep tight NFP and converged
keep if tol_tight==1 & converged==1

gen  share_post_miss     = mi(share_post)
egen share_post_miss_max = max(share_post_miss), by(tol_tight optmethod_str stvalue)

gen  share_post_1        = share_post>1
egen share_post_1_max    = max(share_post_1)   , by(tol_tight optmethod_str stvalue)

gen  share_pre_miss      = mi(share_pre)
egen share_pre_miss_max  = max(share_pre_miss) ,  by(tol_tight optmethod_str stvalue)

gen  share_pre_1         = share_pre>1
egen share_pre_1_max     = max(share_pre_1)    ,  by(tol_tight optmethod_str stvalue)

* Clean 2. Exclude based on market shares
drop if share_post_miss_max>0
drop if  share_pre_miss_max>0
drop if     share_pre_1_max>0
drop if    share_post_1_max>0

keep fval
duplicates drop
sum fval, detail
qui return list
global fval_upper = r(p75)
count if fval<=$fval_upper

********************************************************************************
* BLP largest and median products
********************************************************************************
use "$paper_blp/blp_merger_stats_product_focus.dta", clear

preserve
	keep market id
	duplicates drop
	tab market
restore

keep if flag_largest==1 | flag_median==1

table newmodv market if flag_largest==1, c(count share_obs mean share_obs) format(%5.3f)
table newmodv market if  flag_median==1, c(count share_obs mean share_obs) format(%5.3f)

sum fval if flag_largest==1

********************************************************************************
* Nevo largest and median products
********************************************************************************
use "$paper_nevo/nevo_merger_stats_product_focus.dta", clear

keep if flag_largest==1 | flag_median==1

table brand market if flag_largest==1, c(count share_obs mean share_obs) format(%5.2f)
table brand market if  flag_median==1, c(count share_obs mean share_obs) format(%5.2f)

sum fval if flag_largest==1

********************************************************************************
* BLP elast own
********************************************************************************
use "$paper_blp/blp_merger_stats_product_focus.dta", clear

keep if flag_largest==1 | flag_median==1

sum fval
qui return list

gen     flag_fval_min = 0
replace flag_fval_min = 1 if fval==r(min)

tabstat elast_own if flag_largest==1                    , stats(count min max mean median sd p5 p95) format(%8.2f)
tabstat elast_own if flag_largest==1 & elast_own<0      , stats(count min max mean median sd p5 p95) format(%8.2f)

* spike in the histogram
count if                                   flag_largest==1 & elast_own<0
count if elast_own>-3.3 & elast_own<-3.2 & flag_largest==1 & elast_own<0

gen fval_round=round(fval*100)/100

* own elasticities limited to local optima
count              if flag_largest==1 & flag_local==1
table   fval_round if flag_largest==1 & flag_local==1, c(min elast_own) format(%5.2f)

format  elast_own %8.2f
sum     elast_own  if flag_largest==1 & elast_own<0, detail format

*-------------------------------------------------------------------------------
tabstat elast_own if flag_median==1, stats(count min max mean median sd p5 p95) format(%8.2f)

* this is the number of obs used in the histogram and matches the number of obs
* used in the kernel density plot for optimization vs. sample variation
sum elast_own      if flag_median==1 ,detail format
sum elast_own      if flag_median==1 & elast_own>=`r(p5)', detail format

* own elasticities limited to local optima
count              if flag_median==1 & flag_local==1
table   fval_round if flag_median==1 & flag_local==1, c(min elast_own) format(%5.2f)

********************************************************************************
* Nevo elast_own
********************************************************************************
use "$paper_nevo/nevo_merger_stats_product_focus.dta", clear

keep if flag_largest==1 | flag_median==1

sum fval
qui return list

gen     flag_fval_min = 0
replace flag_fval_min = 1 if fval==r(min)

tabstat elast_own if flag_largest==1                    , stats(count min max mean median sd p5 p95) format(%8.2f)
tabstat elast_own if flag_largest==1 & flag_fval_min==1 , stats(count min max mean median sd p5 p95) format(%8.2f)
tabstat elast_own if flag_largest==1 & flag_best==1     , stats(count min max mean median sd p5 p95) format(%8.2f)
tabstat elast_own if flag_largest==1 & flag_local==1    , stats(count min max mean median sd p5 p95) format(%8.2f)

*-------------------------------------------------------------------------------
tabstat elast_own if flag_median==1                     , stats(count min max mean median sd p5 p95 p75) format(%8.2f)
tabstat elast_own if flag_median==1 & flag_fval_min==1  , stats(count min max mean median sd p5 p95) format(%8.2f)
tabstat elast_own if flag_median==1 & flag_best==1      , stats(count min max mean median sd p5 p95) format(%8.2f)
tabstat elast_own if flag_median==1 & flag_local==1     , stats(count min max mean median sd p5 p95) format(%8.2f)

********************************************************************************
* BLP CoV all
********************************************************************************
use "$paper_blp/blp_merger_stats_product_focus.dta", clear

egen elast_own_mean = mean(elast_own), by(id)
egen elast_own_sd   = sd(elast_own)  , by(id)
gen elast_own_cv    = elast_own_sd/abs(elast_own_mean)
gen obs=1

collapse (mean) elast_own_cv (sum) obs, by(id)

* number of obs used to construct CV
tab obs

format elast_own %8.2f
sum elast_own_cv, detail format
global  p5=r(p5)
global p95=r(p95)

sum  elast_own_cv if elast_own_cv<=$p95, detail format

********************************************************************************
* Nevo CoV all
********************************************************************************
use "$paper_nevo/nevo_merger_stats_product_focus.dta", clear

egen elast_own_mean = mean(elast_own), by(id)
egen elast_own_sd   = sd(elast_own)  , by(id)
gen elast_own_cv    = elast_own_sd/abs(elast_own_mean)

collapse (mean) elast_own_cv, by(id)

sum elast_own_cv, detail
global p95=r(p95)

tabstat  elast_own_cv if elast_own_cv<$p95, stats(count mean median) format(%8.2f)

********************************************************************************
* elasticity bootstrap - blp largest
********************************************************************************
use "$paper_blp/fig_blp_kdens_elast_boot_largest.dta", clear

tab draw

preserve
	keep if draw==0
	sort     x elast_own 
	keep  elast_own	flag_best flag_local x	fx0	fval_round
	order elast_own	flag_best flag_local x	fx0	fval_round
	export excel using "$paper_blp/blp_kdens sum.xlsx", sheet("elast_own_largest") sheetreplace firstrow(variables)
restore

gen var=elast_own

format var %8.2f

egen   p0025=pctile(var) if draw==0, p(2.5)
egen   p0975=pctile(var) if draw==0, p(97.5)
format p0025 p0975 %8.2f

egen   p0025_d=pctile(var) if draw==1, p(2.5)
egen   p0975_d=pctile(var) if draw==1, p(97.5)

format p0025_d p0975_d %8.2f

disp "elast_own_largest"

* sample variation
tabstat var if draw==1, stats(count mean sd) f(%8.2f) 
sum    p0025_d p0975_d if draw==1, format

* optimization variation
tabstat var if draw==0, stats(count mean sd) f(%8.2f) 
sum    p0025 p0975 if draw==0, format

* open the excel file saved above to comment on the share of the kernel density
* look for the value of x for which fx0 exhibits the humps and then look
* at the fval that gives rise to an elasticity that is close to x

********************************************************************************
* elasticity bootstrap - blp median
********************************************************************************
use "$paper_blp/fig_blp_kdens_elast_boot_median.dta", clear

tab draw

preserve
	keep if draw==0
	sort     x elast_own 
	keep  elast_own	flag_best flag_local x	fx0	fval_round
	order elast_own	flag_best flag_local x	fx0	fval_round	
	export excel using "$paper_blp/blp_kdens sum.xlsx", sheet("elast_own_median") sheetreplace firstrow(variables)
restore

gen var=elast_own

format var %8.2f

egen   p0025=pctile(var) if draw==0, p(2.5)
egen   p0975=pctile(var) if draw==0, p(97.5)
format p0025 p0975 %8.2f

egen   p0025_d=pctile(var) if draw==1, p(2.5)
egen   p0975_d=pctile(var) if draw==1, p(97.5)

format p0025_d p0975_d %8.2f

disp "elast_own_largest"

* sample variation
tabstat var if draw==1, stats(count mean sd) f(%8.2f) 
sum    p0025_d p0975_d if draw==1, format

* optimization variation
tabstat var if draw==0, stats(count mean sd) f(%8.2f) 
sum    p0025 p0975 if draw==0, format

* open the excel file saved above to comment on the share of the kernel density
* look for the value of x for which fx0 exhibits the humps and then look
* at the fval that gives rise to an elasticity that is close to x

********************************************************************************
* BLP market level
********************************************************************************
use "$paper_blp/BLP_merger.dta", clear

sum fval
qui return list

gen     flag_fval_min = 0
replace flag_fval_min = 1 if fval==r(min)

gen fval_round=round(fval*100)/100

*-------------------------------------------------------------------------------
tabstat elast_agg                       , stats(count min max mean median sd p5 p95) format(%8.2f)
count if elast_agg>-1

* just making sure there are no wide ranges
table fval_round if flag_local==1, c(min elast_agg mean elast_agg max elast_agg) f(%10.2f)

tabstat elast_agg if flag_fval_min==1   , stats(count min max mean median sd p5 p95)      format(%8.2f)

*-------------------------------------------------------------------------------
tabstat profit_chng                     , stats(count min max mean median sd p5 p10 p95) format(%10.2f)
sum profit_chng, detail
qui return list
global p10=r(p10)
global p95=r(p95)

sum     profit_chng if profit_chng>=$p10 & profit_chng<=$p95, detail format
tabstat profit_chng if profit_chng>=$p10 & profit_chng<=$p95, stats(count min max mean median sd p5 p10 p95) format(%10.2f)

* just making sure there are no wide ranges
table fval_round if flag_local==1, c(min profit_chng mean profit_chng max profit_chng) f(%10.2fc) cellwidth(15)

*-------------------------------------------------------------------------------
tabstat mean_CV                , stats(count min max mean median sd p5 p95) format(%8.2f)
sum mean_CV, detail
qui return list
global  p5=r(p5)

tabstat mean_CV if mean_CV>=$p5 & mean_CV<=0, stats(count min max mean median sd p5 p10 p95) format(%10.2f)

* just making sure there are no wide ranges
table fval_round if flag_local==1, c(min mean_CV mean mean_CV max mean_CV) f(%10.2fc) cellwidth(15)

********************************************************************************
* Nevo market level
********************************************************************************
use "$paper_nevo/nevo_merger.dta", clear

sum fval
qui return list

gen     flag_fval_min = 0
replace flag_fval_min = 1 if fval==r(min)

*-------------------------------------------------------------------------------
tabstat elast_agg                       , stats(count min max mean median sd p5 p95) format(%8.2f)
tabstat elast_agg if flag_fval_min==1   , stats(count min max mean median sd p5 p95) format(%8.2f)
*-------------------------------------------------------------------------------
tabstat profit_chng                     , stats(count min max mean median sd p5 p95) format(%8.2f)
tabstat profit_chng if flag_fval_min==1 , stats(count min max mean median sd p5 p95) format(%8.2f)
*-------------------------------------------------------------------------------
tabstat mean_CV                         , stats(count min max mean median sd p5 p95) format(%8.2f)
tabstat mean_CV if flag_fval_min==1     , stats(count min max mean median sd p5 p95) format(%8.2f)

qui log close

*EOF
