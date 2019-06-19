********************************************************************************
* To accompany Knittel and Metaxoglou
********************************************************************************
clear all
set memo 5000m
set type double
set more off
capture log close

********************************************************************************
* Define globals for paths and files
********************************************************************************
global root     = "C:/DB/Dropbox/RCOptim/ReStat/RESTAT Codes"
global root1    = "$root/2014.06.04 NEVO"
global root2    = "$root/2014.06.04 NEVO tight inner"
global paper    = "$root/2014.06.04 NEVO paper"
global figures  = "$paper/Figures"
global tables   = "$paper/Figures"
global logs     = "$paper/Logs"
global temp     = "$paper/Temp"

********************************************************************************
global path1     = "$root1/Summary"
global path2     = "$root2/Summary"

global path_opt1 = "$root1/Optimization results"
global path_opt2 = "$root2/Optimization results"

global path_mkt1 = "$root1/Market power results"
global path_mkt2 = "$root2/Merger results"

global graph_options = "graphregion(fcolor(white) color(white) icolor(white)) plotregion()"

set scheme sj, permanently

graph set window fontface "Times New Roman"
graph set eps    fontface "Times New Roman"

qui log using "$figures/nevo_fval_estim.log", replace

********************************************************************************
* Load optimization results
********************************************************************************
use           "$path_opt1/Optimization results.dta", clear
append using  "$path_opt2/Optimization results.dta"

********************************************************************************
* Identify tight tolerance results
********************************************************************************
gen     tol_tight = 0
replace tol_tight = 1 if tolnfp=="DFS"

********************************************************************************
* Exclude some of the KNITRO results
********************************************************************************
drop if strpos(optmethod_str,"DER7")
drop if strpos(optmethod_str,"DER8")
drop if strpos(optmethod_str,"DER9")

replace optmethod_str = "DER5-KNI" if optmethod_str=="DER5-KN1"
replace optmethod_str = "DER5-KNI" if optmethod_str=="DER6-KN2"

egen optmethod = group(optmethod_str)

********************************************************************************
* Optimization info to merger on mkt power and merger analysis
********************************************************************************
keep  tol_tight optmethod_str stvalue 
order tol_tight optmethod_str stvalue 
sort  tol_tight optmethod_str stvalue

save "$temp/optim info.dta", replace

********************************************************************************
* Load data for merger analysis
********************************************************************************
use "$root1/Merger Results/nevo_merger_results_all.dta", clear

gen     tol_tight=0
replace tol_tight=1 if strpos(optmethod_str,"KN2")
replace tol_tight=1 if strpos(optmethod_str,"KN4")
replace tol_tight=1 if strpos(optmethod_str,"KN5")

append using "$root2/Merger Results/nevo_merger_results_all.dta"

replace tol_tight=1 if mi(tol_tight)

replace optmethod_str = "DER5-KNI" if optmethod_str=="DER5-KN1"
replace optmethod_str = "DER5-KNI" if optmethod_str=="DER6-KN2"

********************************************************************************
* Merge optimization info
********************************************************************************
keep  tol_tight optmethod_str stvalue share_pre
sort  tol_tight optmethod_str stvalue
merge tol_tight optmethod_str stvalue using "$temp/optim info.dta"

keep  if _merge==3
drop   _merge

gen  share_pre_miss      = mi(share_pre)
egen share_pre_miss_max  = max(share_pre_miss) ,  by(tol_tight optmethod_str stvalue)

gen  share_pre_1         = share_pre>1
egen share_pre_1_max     = max(share_pre_1)    ,  by(tol_tight optmethod_str stvalue)

********************************************************************************
* Exclude combinations that produced abnormal shares
********************************************************************************
drop if     share_pre_1_max>0
drop if share_pre_miss_max==1

keep  optmethod_str stvalue tol_tight
duplicates drop 
sort optmethod_str stvalue tol_tight

compress

save "$temp/optim info shares.dta", replace

tab  optmethod_str tol_tight, mi

********************************************************************************
* Load optimization results
********************************************************************************
use           "$path_opt1/Optimization results.dta", clear
append using  "$path_opt2/Optimization results.dta"

********************************************************************************
* Identify tight tolerance results
********************************************************************************
gen     tol_tight = 0
replace tol_tight = 1 if tolnfp=="DFS"

********************************************************************************
* Exclude some of the KNITRO results
********************************************************************************
drop if strpos(optmethod_str,"DER7")
drop if strpos(optmethod_str,"DER8")
drop if strpos(optmethod_str,"DER9")

replace optmethod_str = "DER5-KNI" if optmethod_str=="DER5-KN1"
replace optmethod_str = "DER5-KNI" if optmethod_str=="DER6-KN2"

egen optmethod = group(optmethod_str)

********************************************************************************
* Identify local minima and best fvals
* fval      : function value at parameter estimates, following estimation
* fval_est  : function value tracked during estimation
* fval_hess : function value when calculating hessians
* All these fvals should be almost identical with tight tolerance
********************************************************************************
gen     flag_local=0
replace flag_local=1 if  gprime_invH_g<0.1 & grad_norm_inf<0.1	

bysort  tol_tight optmethod optmethod_str (fval): gen fval_n=_n
gen     flag_best=0
replace flag_best=1 if fval_n==1
drop    fval_n

********************************************************************************
* Track exit info
********************************************************************************
gen     converged = 1
replace converged = 0 if exitinfo ==  0   & optmethod_str == "DER1-QN1"
replace converged = 0 if exitinfo == -1   & optmethod_str == "DER1-QN1"
replace converged = 0 if exitinfo ==  3   & optmethod_str == "DER2-QN2"
replace converged = 0 if exitinfo <   0   & optmethod_str == "DER2-QN2"
replace converged = 0 if exitinfo ==  3   & optmethod_str == "DER3-CGR"
replace converged = 0 if exitinfo <   0   & optmethod_str == "DER4-SOL"

replace converged = 0 if exitinfo <-199   & optmethod_str == "DER5-KNI"	

replace converged = 0 if exitinfo ~=  1   & optmethod_str == "DIR1-SIM"		
replace converged = 0 if exitinfo <   1   & optmethod_str == "DIR2-MAD"
replace converged = 0 if exitinfo <   1   & optmethod_str == "DIR3-GPS"
replace converged = 0 if exitinfo <   1   & optmethod_str == "DIR2-MAD"
replace converged = 0 if                    optmethod_str == "STO1-SIA"
replace converged = 0 if exitinfo <   1   & optmethod_str == "STO2-GAL"
replace converged = 0 if exitinfo <   1   & optmethod_str == "STO3-SIG"

********************************************************************************
* Exclude combinations that gave rise to abnormal shares
********************************************************************************
sort optmethod_str stvalue tol_tight

merge using "$temp/optim info shares.dta"

list optmethod_str stvalue tol_tight if _merge~=3
keep if _merge==3
drop _merge

table optmethod_str if tol_tight==0                , c(min fval min fval_est min fval_hess) format(%12.3fc) row col
table optmethod_str if tol_tight==1                , c(min fval min fval_est min fval_hess) format(%12.3fc) row col
table optmethod_str if tol_tight==0 &  flag_best==1, c(min fval min fval_est min fval_hess) format(%12.3fc) row col
table optmethod_str if tol_tight==1 &  flag_best==1, c(min fval min fval_est min fval_hess) format(%12.3fc) row col

tab   optmethod_str tol_tight
tab   optmethod_str converged if tol_tight==0
tab   optmethod_str converged if tol_tight==1

save "$figures/nevo_fval_estim.dta", replace

********************************************************************************
* Optimization info to merger on mkt power and merger analysis
********************************************************************************
preserve

	keep  tol_tight optmethod_str stvalue flag_local flag_best fval fval_est fval_hess converged exitinfo hess_posdef hessian_eig_max hessian_eig_min hess_cond_num	
	order tol_tight optmethod_str stvalue flag_local flag_best fval fval_est fval_hess converged exitinfo hess_posdef hessian_eig_max hessian_eig_min hess_cond_num	

	sort  tol_tight optmethod_str stvalue

	save "$temp/optim info merger.dta", replace
restore

********************************************************************************
* Summary Statistics
********************************************************************************
global vars_to_collapse tol_tight optmethod optmethod_str
preserve
	egen fval_sk  = skew(fval), by($vars_to_collapse)
	egen fval_ku  = kurt(fval), by($vars_to_collapse)
	egen fval_iqr = iqr(fval),  by($vars_to_collapse)
	
	egen converged_tag = tag(tol_tight optmethod optmethod_str converged)
	
	gen nobs=1

	collapse (min) fval_min=fval (mean) fval_mean=fval (median) fval_median=fval (sd) fval_sd=fval (mean) fval_sk fval_ku fval_iqr (p1) fval_01=fval (p5) fval_05=fval (p10) fval_10=fval (p25) fval_25=fval (p75) fval_75=fval (p90) fval_90=fval (p95) fval_95=fval (p99) fval_99=fval (max) fval_max=fval (sum) converged_sum=converged (sum) nobs, by($vars_to_collapse)

	aorder

	order tol_tight optmethod optmethod_str fval_min fval_mean fval_median fval_max fval_sd  fval_sk fval_ku fval_iqr fval_01 fval_05 fval_10 fval_25 fval_75 fval_90 fval_95 fval_99 converged_sum

	format fval_* %15.6fc

	export excel using "$tables/nevo_fval.xlsx"  , sheetreplace firstrow(variables) sheet("Stats")
	save               "$tables/nevo_fval_stats.dta", replace
restore 

********************************************************************************
* Best Estimates
********************************************************************************
drop brand*

global nevo_estimates price_mean  price_sigma  const_sigma mushy_sigma sugar_sigma price_child_sigma  price_inc_sigma  price_inc2_sigma const_age_sigma  const_inc_sigma   mushy_age_sigma  mushy_inc_sigma  sugar_age_sigma  sugar_inc_sigma  price_mean_se price_sigma_se  const_sigma_se mushy_sigma_se sugar_sigma_se  price_child_sigma_se  price_inc_sigma_se  price_inc2_sigma_se  const_age_sigma_se  const_inc_sigma_se   mushy_age_sigma_se mushy_inc_sigma_se  sugar_age_sigma_se  sugar_inc_sigma_se 

preserve
	keep if flag_best==1
	gen obs=1
	
	collapse (mean) $nevo_estimates grad_norm_inf hess_posdef gprime_invH_g stvalue fval fval_est fval_hess (min) exitinfo converged (sum) obs (mean) hessian_eig_max hessian_eig_min hess_cond_num, by($vars_to_collapse)
	export excel using "$tables/nevo_fval.xlsx"  , sheetreplace firstrow(variables) sheet("Best")
	save           "$tables/nevo_fval_best.dta", replace
restore 

********************************************************************************
* Local Estimates
********************************************************************************
preserve
	keep if flag_local==1
	gen obs=1
	
	duplicates drop $vars_to_collapse fval, force
	
	order *_mean *_sigma *_se

	collapse (mean) $nevo_estimates grad_norm_inf hess_posdef gprime_invH_g fval fval_est fval_hess (min) exitinfo converged (sum) obs flag_best (mean) hessian_eig_max hessian_eig_min hess_cond_num, by($vars_to_collapse stvalue)		
	export excel using "$tables/nevo_fval.xlsx"  , sheetreplace firstrow(variables) sheet("Local")
	save           "$tables/nevo_fval_local.dta", replace
restore 

save "$tables/nevo_optim.dta", replace

********************************************************************************
* Histogram
********************************************************************************
use "$tables/nevo_optim.dta", clear

preserve
	keep if converged==1 & tol_tight==1
	keep if strpos(optmethod_str,"DER")

	global xmin=0
	global xmax=120
	global xinc=20

	global ymin=0
	global ymax=1.0
	global yinc=0.1

	global fval_upper = 110
	global fval_min   = 4.56

	hist fval if fval<=$fval_upper, $graph_options fraction xtitle(Objective Function Value,margin(medium)) xlabel($xmin($xinc)$xmax,format(%5.0fc) nogrid) xline($fval_min) ytitle(Fraction,margin(medium)) ylabel($ymin($yinc)$ymax, angle(h) format(%5.2fc) nogrid) scale(0.7) 

	graph export "$figures/fig_hist_nevo.emf", replace
	graph export "$figures/fig_hist_nevo.eps", replace
	

	hist fval if fval<=$fval_upper, $graph_options fraction xtitle(Objective Function Value,margin(medium)) xlabel($xmin($xinc)$xmax,format(%5.0fc) nogrid) xline($fval_min) ytitle(Fraction,margin(medium)) ylabel($ymin($yinc)$ymax, angle(h) format(%5.2fc) nogrid) scale(1.0) 

	graph export "$figures/fig_hist_nevo_beam.emf", replace
	graph export "$figures/fig_hist_nevo_beam.eps", replace
	
restore	

********************************************************************************
* Box plot
********************************************************************************
use "$tables/nevo_optim.dta", clear

preserve
	keep if converged==1
	gen     tol_tight_str="Loose"
	replace tol_tight_str="Tight" if tol_tight==1

	global xmin=0
	global xmax=120
	global xinc=20

	qui sum fval if tol_tight==1, detail
	qui return  list

	global fval_upper = 110
	global fval_min   = r(min)

	graph hbox fval if fval<=$fval_upper, $graph_options over(tol_tight_str) over(optmethod_str, label(angle(h)))  ytitle(Objective Function Value,margin(medium)) ylabel(20($xinc)$xmax,format(%5.0fc) nogrid) yline($fval_min) scale(0.7)

	graph export  "$figures/fig_hbox_nevo.eps", replace
	graph export  "$figures/fig_hbox_nevo.emf", replace
	
	
	graph hbox fval if fval<=$fval_upper, $graph_options over(tol_tight_str) over(optmethod_str, label(angle(h)))  ytitle(Objective Function Value,margin(medium)) ylabel(20($xinc)$xmax,format(%5.0fc) nogrid) yline($fval_min) scale(1.0)

	graph export  "$figures/fig_hbox_nevo_beam.eps", replace
	graph export  "$figures/fig_hbox_nevo_beam.emf", replace
	
	qui window manage close graph 	
restore

********************************************************************************
* Prepare data for merger analysis
********************************************************************************
use          "$root1/Merger Results/nevo_merger_results_all.dta", clear

gen     tol_tight=0
replace tol_tight=1 if strpos(optmethod_str,"KN2")
replace tol_tight=1 if strpos(optmethod_str,"KN4")
replace tol_tight=1 if strpos(optmethod_str,"KN5")

append using "$root2/Merger Results/nevo_merger_results_all.dta"

replace  tol_tight=1 if mi(tol_tight)

replace optmethod_str = "DER5-KNI" if optmethod_str=="DER5-KN1"
replace optmethod_str = "DER5-KNI" if optmethod_str=="DER6-KN2"

********************************************************************************
* Merge optimization info
********************************************************************************
sort  tol_tight optmethod_str stvalue
merge tol_tight optmethod_str stvalue using "$temp/optim info merger.dta"
keep  if _merge==3
drop   _merge

global vars_to_collapse tol_tight optmethod optmethod_str stvalue flag_best flag_local converged exitinfo hess_posdef hessian_eig_max hessian_eig_min hess_cond_num

********************************************************************************
* Construct variables of interest at the market level
* profit_* was calculated as (price_*-mc)*s_*
********************************************************************************
gen    quantity_pre      = share_pre*mkt_size
gen    quantity_post     = share_post*mkt_size
gen    quantity_agg      = share_agg*mkt_size

replace profit_pre       = profit_pre*mkt_size
replace profit_post      = profit_post*mkt_size
replace profit_agg       = profit_agg*mkt_size

gen    margin_pre_pct    = (price_pre-mc)/price_pre
gen    margin_post_pct   = (price_post-mc)/price_post

replace mean_CV          = mean_CV*mkt_size
replace elast_agg        = elast_agg

save "$temp/nevo_merger_stats_product.dta", replace

qui log close
*EOF
