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
* Patameter Estimates - BLP
********************************************************************************
use "$paper_blp/BLP_fval_best.dta", clear 
 
list optmethod_str tol_tight exitinfo if converged==0
 
keep if converged==1

foreach v of varlist *_sigma {
	replace `v'=abs(`v')
}

foreach v of varlist *_sigma {
	egen `v'_max=max(`v')
	egen `v'_min=min(`v')
	 gen `v'_ratio=`v'_max/`v'_min
}

gen  price_mean_low = price_mean-1.96* price_mean_se
gen  price_mean_upp = price_mean+1.96* price_mean_se

gen  price_sigma_low = price_sigma-1.96* price_sigma_se
gen  price_sigma_upp = price_sigma+1.96* price_sigma_se

********************************************************************************
* Patameter Estimates - BLP loose
********************************************************************************
sort fval
format fval %10.2f
list optmethod_str fval if tol_tight==0

sort price_mean
format *_mean *_mean_* %10.2f
list optmethod_str price_mean price_mean_se price_mean_low price_mean_upp if tol_tight==0

sum const_mean hpwt_mean air_mean mpg_mean space_mean if tol_tight==0, format

sort price_sigma
format *_sigma *_sigma_* %10.2f
list optmethod_str price_sigma price_sigma_se price_sigma_low price_sigma_upp if tol_tight==0

sum const_sigma hpwt_sigma air_sigma mpg_sigma if tol_tight==0, format

********************************************************************************
* Patameter Estimates - BLP tight
********************************************************************************
sort fval
list optmethod_str fval if tol_tight==1

sort price_mean
list optmethod_str price_mean price_mean_se price_mean_low price_mean_upp if tol_tight==1

sum const_mean hpwt_mean air_mean mpg_mean space_mean if tol_tight==0, format
sum const_mean hpwt_mean air_mean mpg_mean space_mean if tol_tight==1, format

sum price_sigma const_sigma hpwt_sigma air_sigma mpg_sigma if tol_tight==0, format
sum price_sigma const_sigma hpwt_sigma air_sigma mpg_sigma if tol_tight==1, format

********************************************************************************
* Patameter Estimates - Nevo
********************************************************************************
use "$paper_nevo/nevo_fval_best.dta", clear 
 
list optmethod_str tol_tight exitinfo if converged==0
 
keep if converged==1

foreach v of varlist price_sigma const_sigma mushy_sigma sugar_sigma {
	replace `v'=abs(`v')
}

foreach v of varlist *_sigma {
	egen `v'_max=max(`v')
	egen `v'_min=min(`v')
	 gen `v'_ratio=`v'_max/`v'_min
}

gen  price_mean_low = price_mean-1.96* price_mean_se
gen  price_mean_upp = price_mean+1.96* price_mean_se

gen  price_sigma_low = price_sigma-1.96* price_sigma_se
gen  price_sigma_upp = price_sigma+1.96* price_sigma_se

********************************************************************************
* Patameter Estimates - Nevo loose
********************************************************************************
  sort fval
list optmethod_str fval if tol_tight==0

sort price_mean
list optmethod_str price_mean price_mean_se price_mean_low price_mean_upp if tol_tight==0

sort price_sigma
list optmethod_str price_sigma price_sigma_se price_sigma_low price_sigma_upp if tol_tight==0

sort sugar_sigma
list optmethod_str sugar_sigma sugar_sigma_ratio if tol_tight==0

sort price_inc_sigma
list optmethod_str price_inc_sigma price_inc_sigma_ratio if tol_tight==1

********************************************************************************
* Patameter Estimates - Nevo tight
********************************************************************************
sort fval
list optmethod_str fval if tol_tight==1

sort price_mean
list optmethod_str price_mean price_mean_se price_mean_low price_mean_upp if tol_tight==1

sort price_sigma
list optmethod_str price_sigma price_sigma_se price_sigma_low price_sigma_upp if tol_tight==1

sum const_sigma mushy_sigma sugar_sigma if tol_tight==0
sum const_sigma mushy_sigma sugar_sigma if tol_tight==1

sum price_child_sigma price_inc_sigma price_inc2_sigma const_age_sigma const_inc_sigma mushy_age_sigma mushy_inc_sigma sugar_age_sigma sugar_inc_sigma if tol_tight==0
sum price_child_sigma price_inc_sigma price_inc2_sigma const_age_sigma const_inc_sigma mushy_age_sigma mushy_inc_sigma sugar_age_sigma sugar_inc_sigma if tol_tight==1

********************************************************************************
* price mean and sigma
********************************************************************************
use "$paper_blp/fig_blp_kdens_price_mean.dta", clear

preserve
	keep if draw==0
	sort     x price_mean 
	keep  price_mean flag_best flag_local x	fx0	fval_round
	order price_mean flag_best flag_local x	fx0	fval_round
	export excel using "$paper_blp/blp_kdens sum.xlsx", sheet("price_mean") sheetreplace firstrow(variables)
restore

gen var=price_mean

format var %8.3f

egen   p0025=pctile(var) if draw==0, p(2.5)
egen   p0975=pctile(var) if draw==0, p(97.5)
format p0025 p0975 %8.3f
disp "price_mean"
tabstat var if draw==1, stats(mean median sd) f(%8.3f) by(draw) noto
tabstat var if draw==0, stats(mean median sd) f(%8.3f) by(draw) noto
sum    p0025 p0975 if draw==0, format


use "$paper_blp/fig_blp_kdens_price_sigma.dta", clear

preserve
	keep if draw==0
	sort     x price_sigma 
	keep  price_sigma flag_best flag_local x	fx0	fval_round
	order price_sigma flag_best flag_local x	fx0	fval_round	
	export excel using "$paper_blp/blp_kdens sum.xlsx", sheet("price_sigma") sheetreplace firstrow(variables)
restore

gen var=price_sigma

format var %8.3f

egen   p0025=pctile(var) if draw==0, p(2.5)
egen   p0975=pctile(var) if draw==0, p(97.5)
format p0025 p0975 %8.3f

disp "price_sigma"
tabstat var if draw==1, stats(mean median sd) f(%8.3f) by(draw) noto
tabstat var if draw==0, stats(mean median sd) f(%8.3f) by(draw) noto
sum    p0025 p0975 if draw==0, format

********************************************************************************
* mpg mean and sigma
********************************************************************************
use "$paper_blp/fig_blp_kdens_mpg_mean.dta", clear

preserve
	keep if draw==0
	sort     x mpg_mean 
	keep   mpg_mean	flag_best flag_local x	fx0	fval_round
	order  mpg_mean	flag_best flag_local x	fx0	fval_round
	export excel using "$paper_blp/blp_kdens sum.xlsx", sheet("mpg_mean") sheetreplace firstrow(variables)
restore

gen var=mpg_mean

format var %8.3f

egen   p0025=pctile(var) if draw==0, p(2.5)
egen   p0975=pctile(var) if draw==0, p(97.5)
format p0025 p0975 %8.3f
disp "mpg_mean"
tabstat var if draw==1, stats(mean median sd) f(%8.3f) by(draw) noto
tabstat var if draw==0, stats(mean median sd) f(%8.3f) by(draw) noto
sum    p0025 p0975 if draw==0, format

use "$paper_blp/fig_blp_kdens_mpg_sigma.dta", clear

preserve
	keep if draw==0
	sort   x mpg_sigma 
	keep   mpg_sigma	flag_best flag_local x	fx0	fval_round 
	order  mpg_sigma	flag_best flag_local x	fx0	fval_round 
	export excel using "$paper_blp/blp_kdens sum.xlsx", sheet("mpg_sigma") sheetreplace firstrow(variables)
restore

gen var=mpg_sigma

format var %8.3f

egen   p0025=pctile(var) if draw==0, p(2.5)
egen   p0975=pctile(var) if draw==0, p(97.5)
format p0025 p0975 %8.3f

disp "mpg_sigma"
tabstat var if draw==1, stats(mean median sd) f(%8.3f) by(draw) noto
tabstat var if draw==0, stats(mean median sd) f(%8.3f) by(draw) noto
sum    p0025 p0975 if draw==0, format

********************************************************************************
* algorithms reaching the smallest function value blp
********************************************************************************
use "$paper_blp/blp_fval_estim_e06.dta",clear

* DER8-KN4 corresponds to optmethod 14, bound from below
* DER9-KN5 corresponds to optmethod 15, unbound

tab optmethod_str if converged==0
tab optmethod_str if fcnevals == 4000

* histogram is based on value that converged
keep if converged==1

count        if optmethod_str=="DER9-KN5" & fval<=430
tab exitinfo if optmethod_str=="DER9-KN5" & fval<=430

format fval %10.2f
sum fval     if optmethod_str=="DER9-KN5" & fval<=430, format

count        if optmethod_str=="DER1-QN1" & fval<=157.79
count        if optmethod_str=="DER2-QN2" & fval<=157.79
count        if optmethod_str=="DER3-CGR" & fval<=157.79
count        if optmethod_str=="DER4-SOL" & fval<=157.79

format fval %10.2f
sum fval  if optmethod_str=="DER8-KN4" & fval<=430, format
count     if optmethod_str=="DER8-KN4" & fval>=254.8 & fval<=255
tab exit  if optmethod_str=="DER8-KN4" & fval>=254.8 & fval<=255

tab fval  if optmethod_str=="DER8-KN4" & fval>=255

*-------------------------------------------------------------------------------
sum fval          if fval>=204.56 & fval<=205
tab optmethod_str if fval>=204.56 & fval<=205

sum fval          if fval>=218 & fval<=219
tab optmethod_str if fval>=218 & fval<=219

sum fval          if fval>=254.8 & fval<=255
tab optmethod_str if fval>=254.8 & fval<=255

*-------------------------------------------------------------------------------
use "$paper_blp/blp_fval_estim_e06.dta",clear

keep if converged & fval<=430

sum fval          if fval>=204.56 & fval<=205
sum fval          if fval>=218 & fval<=219
sum fval          if fval>=254.8 & fval<=255
sum fval          if fval<=219

use "$paper_blp/blp_fval_estim.dta",clear

keep if converged & fval<=430 & tolnfp=="DFS" & regexm(optmethod_str,"DER")

tab optmethod_str

sum fval          if fval>=204.56 & fval<=205
sum fval          if fval>=218 & fval<=219
sum fval          if fval>=254.8 & fval<=255
sum fval          if fval<=219

********************************************************************************
* algorithms reaching the smallest function value nevo
********************************************************************************
use "$paper_nevo/Nevo_fval_estim_e06.dta",clear

tab optmethod_str if converged==0

count if optmethod_str=="DER4-SOL" & fval<=4.57

count if optmethod_str=="DER8-KN4" & fval<=4.57
count if optmethod_str=="DER9-KN5" & fval<=4.57

format exitinfo %5.0f

tab exitinfo if strpos(optmethod_str,"KN") & fval<=4.57

count if optmethod_str=="DER1-QN1" & fval<=4.57

count if optmethod_str=="DER2-QN2" & fval<=4.57

count if optmethod_str=="DER3-CGR" & fval>=15.4 & fval<=15.8 & converged==0
count if optmethod_str=="DER3-CGR" & fval>=15.4 & fval<=15.8 & converged==1

********************************************************************************
* algorithms reaching 4000 function evaluations nevo
********************************************************************************
use "$paper_nevo/Nevo_fval_estim_e06.dta",clear

tab optmethod_str if fcnevals == 4000

qui log close

*EOF
