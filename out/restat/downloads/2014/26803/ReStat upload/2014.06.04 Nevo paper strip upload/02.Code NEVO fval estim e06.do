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
global root1    = "$root/2014.06.04 NEVO tight inner e06"
global paper    = "$root/2014.06.04 NEVO paper"
global figures  = "$paper/Figures"
global tables   = "$paper/Figures"
global logs     = "$paper/Logs"
global temp     = "$paper/Temp"
	
********************************************************************************
global path1     = "$root1/Summary"
global path_opt1 = "$root1/Optimization results"
global path_mkt1 = "$root1/Market power results"

global graph_options = "graphregion(fcolor(white) color(white) icolor(white)) plotregion()"

set scheme sj, permanently

graph set window fontface "Times New Roman"
graph set eps    fontface "Times New Roman"

********************************************************************************
* Load optimization results
********************************************************************************
use           "$path_opt1/Optimization results.dta", clear

********************************************************************************
* Identify tight tolerance results
********************************************************************************
gen     tol_tight = 0
replace tol_tight = 1 if tolnfp=="DFS"

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

gen     tol_tight=1

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

********************************************************************************
* Identify tight tolerance results
********************************************************************************
gen     tol_tight = 0
replace tol_tight = 1 if tolnfp=="DFS"

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

replace converged = 0 if exitinfo <-199   & optmethod_str == "DER8-KNI"	
replace converged = 0 if exitinfo <-199   & optmethod_str == "DER9-KNI"	

********************************************************************************
* Exclude combinations that gave rise to abnormal shares
********************************************************************************
sort optmethod_str stvalue tol_tight

merge using "$temp/optim info shares.dta"
keep if _merge==3
drop _merge

save "$figures/nevo_fval_estim_e06.dta", replace

use "$figures/nevo_fval_estim_e06.dta", clear

preserve
	keep if converged==1

	global xmin=0
	global xmax=120
	global xinc=20

	global ymin=0
	global ymax=1.0
	global yinc=0.1

	global fval_upper = 110
	global fval_min   = 4.56

	hist fval if fval<=$fval_upper, $graph_options fraction xtitle(Objective Function Value,margin(medium)) xlabel($xmin($xinc)$xmax,format(%5.0fc) nogrid) xline($fval_min) ytitle(Fraction,margin(medium)) ylabel($ymin($yinc)$ymax, angle(h) format(%5.2fc) nogrid) scale(0.7) 

	graph export "$figures/fig_hist_nevo_e06.emf", replace
	graph export "$figures/fig_hist_nevo_e06.eps", replace
	

	hist fval if fval<=$fval_upper, $graph_options fraction xtitle(Objective Function Value,margin(medium)) xlabel($xmin($xinc)$xmax,format(%5.0fc) nogrid) xline($fval_min) ytitle(Fraction,margin(medium)) ylabel($ymin($yinc)$ymax, angle(h) format(%5.2fc) nogrid) scale(1.0) 

	graph export "$figures/fig_hist_nevo_e06_beam.emf", replace
	graph export "$figures/fig_hist_nevo_e06_beam.eps", replace
	
restore	

*EOF
