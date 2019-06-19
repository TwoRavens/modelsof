	* do "Run3_KS_test_europe.do"
	
	**********************
	* INITIALIZE
	**********************

set seed 1234567

clear all
mata: mata clear
program drop _all
set matsize 2000

local name="Run3_KS_test_europe"

capture log close
log using "${log_files}/Log_`name'.log", replace

capture log close key_results
log using ${log_files}/key_results_`name'.log, name(key_results) replace
qui log off key_results

	**********************
	* LOAD DATA
	**********************

use "${dta}/data_sample.dta"

	********************
	* DEFINE PARAMETERS
	********************

local grid_main=500

local cova1="$cova1"
local cova2="$cova2"
local personal="$personal"
local iv="$iv"

local xmin_r2=9.8
local xmax_r2=11.2

local reps=$reps

	**********************
	* RUN LOOPS
	**********************

foreach zz in  "endog" "exog"  {

if "`zz'"=="exog" {
	local routine_name="selection_exog"
	local add_options=" sleep(500)"
}
if "`zz'"=="endog" {
	local routine_name="selection_endog"
	local add_options `"iv(`iv') wageseen(wageseen) sleep(500)"'
}
	
foreach gg in 0 { 

di "---------------------------------------------------------------"
di "gg=`gg'. [$S_DATE, $S_TIME]"
di "`zz'"
di "---------------------------------------------------------------"

`routine_name' `cova1' `cova2' `personal' ///
	if round==2, ///
	refvar(ineq_group`gg') home(1) xmin(`xmin_r2') xmax(`xmax_r2') title("round 2.") ///
	dep(lgincomeP_r) ///
	gen(uhat_aux)  filename("run3_cdf_r2_ALL_gg`gg'_xxEUROPE_`zz'")  grid(`grid_main') cdfoff(0) ///
	subpredd(1) subpredvar(sample_selEUROPE) bootstrap(0) stubnew("base") smoothoff(0) ///
	`add_options' 

qui putmata base_group base_sel base_gen if base_sel==1, replace

drop base_*

local home_unequal_KS_DiDmax=_coef[home_unequal_KS_DiDmax]
local equal_unequal_KS_DiDmax=_coef[equal_unequal_KS_DiDmax]
local equal_home_KS_DiDmax=_coef[equal_home_KS_DiDmax]

local home_unequal_KS_DiDmaxrev=_coef[home_unequal_KS_DiDmaxrev]
local equal_unequal_KS_DiDmaxrev=_coef[equal_unequal_KS_DiDmaxrev]
local equal_home_KS_DiDmaxrev=_coef[equal_home_KS_DiDmaxrev]

local home_unequal_KS_DiDabs=_coef[home_unequal_KS_DiDabs]
local equal_unequal_KS_DiDabs=_coef[equal_unequal_KS_DiDabs]
local equal_home_KS_DiDabs=_coef[equal_home_KS_DiDabs]

local home_unequal_KS=_coef[home_unequal_KS]
local equal_unequal_KS=_coef[equal_unequal_KS]
local equal_home_KS=_coef[equal_home_KS]

local home_unequal_KS_pval=_coef[home_unequal_KS_pval]
local equal_unequal_KS_pval=_coef[equal_unequal_KS_pval]
local equal_home_KS_pval=_coef[equal_home_KS_pval]

local home_unequal_KS1s=_coef[home_unequal_KS1s]
local equal_unequal_KS1s=_coef[equal_unequal_KS1s]
local equal_home_KS1s=_coef[equal_home_KS1s]

local home_unequal_KS1srev=_coef[home_unequal_KS1srev]
local equal_unequal_KS1srev=_coef[equal_unequal_KS1srev]
local equal_home_KS1srev=_coef[equal_home_KS1srev]

local home_unequal_KS_pval1s=_coef[home_unequal_KS_pval1s]
local equal_unequal_KS_pval1s=_coef[equal_unequal_KS_pval1s]
local equal_home_KS_pval1s=_coef[equal_home_KS_pval1s]

local home_unequal_KS_pval1srev=_coef[home_unequal_KS_pval1srev]
local equal_unequal_KS_pval1srev=_coef[equal_unequal_KS_pval1srev]
local equal_home_KS_pval1srev=_coef[equal_home_KS_pval1srev]

qui log on key_results

di ""
di "******************************************************************************************************"
di "RESULTS `zz'"
di "gg=`gg'. [$S_DATE, $S_TIME]"
di "restrict prediction to xx=EUROPE"
di "******************************************************************************************************"
di ""

bootstrap, strata(ineq_group`gg') ///
  	reps(`reps') saving("${output}/run3_data_ALL_gg`gg'_xxEUROPE_`zz'.dta", replace):  ///
	`routine_name' `cova1' `cova2' `personal' ///
	if round==2, ///
	refvar(ineq_group`gg') home(1) xmin(`xmin_r2') xmax(`xmax_r2') title("round 2.") ///
	dep(lgincomeP_r) ///
	gen(uhat_aux)  filename("run3_bs_cdf_ALL_gg`gg'_xxEUROPE_`zz'")  grid(2) cdfoff(1) ///
	subpredd(1) subpredvar(sample_selEUROPE) bootstrap(1) stubnew("base") smoothoff(1) ///
	`add_options' 

qui log off key_results

preserve

	use "${output}/run3_data_ALL_gg`gg'_xxEUROPE_`zz'", clear
	
	qui sum _b_home_unequal_KS_DiDmax, d
	qui gen temp=(`home_unequal_KS_DiDmax'<_b_home_unequal_KS_DiDmax) if _b_home_unequal_KS_DiDmax!=.
	qui sum temp
	local p_home_unequal_KS_DiDmax=r(mean)
	drop temp
	qui sum _b_equal_home_KS_DiDmax, d
	qui gen temp=(`equal_home_KS_DiDmax'<_b_equal_home_KS_DiDmax) if _b_equal_home_KS_DiDmax!=.
	qui sum temp
	local p_equal_home_KS_DiDmax=r(mean)
	drop temp
	qui sum _b_equal_unequal_KS_DiDmax, d
	qui gen temp=(`equal_unequal_KS_DiDmax'<_b_equal_unequal_KS_DiDmax) if _b_equal_unequal_KS_DiDmax!=.
	qui sum temp
	local p_equal_unequal_KS_DiDmax=r(mean)
	drop temp

	qui sum _b_home_unequal_KS_DiDmaxrev, d
	qui gen temp=(`home_unequal_KS_DiDmaxrev'>_b_home_unequal_KS_DiDmaxrev) if _b_home_unequal_KS_DiDmaxrev!=. & `home_unequal_KS_DiDmaxrev'!=.
	qui sum temp
	local p_home_unequal_KS_DiDmaxrev=r(mean)
	drop temp
	qui sum _b_equal_home_KS_DiDmaxrev, d
	qui gen temp=(`equal_home_KS_DiDmaxrev'>_b_equal_home_KS_DiDmaxrev) if _b_equal_home_KS_DiDmaxrev!=. & `equal_home_KS_DiDmaxrev'!=.
	qui sum temp
	local p_equal_home_KS_DiDmaxrev=r(mean)
	drop temp
	qui sum _b_equal_unequal_KS_DiDmaxrev, d
	qui gen temp=(`equal_unequal_KS_DiDmaxrev'>_b_equal_unequal_KS_DiDmaxrev) if _b_equal_unequal_KS_DiDmaxrev!=. & `equal_unequal_KS_DiDmaxrev'!=.
	qui sum temp
	local p_equal_unequal_KS_DiDmaxrev=r(mean)
	drop temp

	qui sum _b_equal_unequal_KS_DiDabs, d
	qui gen temp=(`equal_unequal_KS_DiDabs'<_b_equal_unequal_KS_DiDabs) if _b_equal_unequal_KS_DiDabs!=.
	qui sum temp
	local p_equal_unequal_KS_DiDabs=r(mean)
	drop temp
	qui sum _b_home_unequal_KS_DiDabs, d
	qui gen temp=(`home_unequal_KS_DiDabs'<_b_home_unequal_KS_DiDabs) if _b_home_unequal_KS_DiDabs!=.
	qui sum temp
	local p_home_unequal_KS_DiDabs=r(mean)
	drop temp
	qui sum _b_equal_home_KS_DiDabs, d
	qui gen temp=(`equal_home_KS_DiDabs'<_b_equal_home_KS_DiDabs) if _b_equal_home_KS_DiDabs!=.
	qui sum temp
	local p_equal_home_KS_DiDabs=r(mean)
	drop temp

		* OUTPUT

qui log on key_results

	di ""
	di "******************************************************************************************************"
	di "RESULTS `zz'"
	di "gg=`gg'. [$S_DATE, $S_TIME]"
	di "restrict prediction to xx=EUROPE"
	di "******************************************************************************************************"
	di ""

	di ""
	di "------------------------------------------------------------------------------------------------"
	di "Equal-home:    KS (1-s)=" %8.5f `equal_home_KS1s' ", p=" %7.5f `equal_home_KS_pval1s' ", p=" %7.5f `p_equal_home_KS_DiDmax' " || KS (2-s)=" %7.5f `equal_home_KS' ", p=" %7.5f `equal_home_KS_pval' ", p=" %7.5f `p_equal_home_KS_DiDabs'
	di "Home -unequal: KS (1-s)=" %8.5f `home_unequal_KS1s' ", p=" %7.5f `home_unequal_KS_pval1s' ", p=" %7.5f `p_home_unequal_KS_DiDmax' " || KS (2-s)=" %7.5f `home_unequal_KS' ", p=" %7.5f `home_unequal_KS_pval'  ", p=" %7.5f `p_home_unequal_KS_DiDabs'
	di "Equal-unequal: KS (1-s)=" %8.5f `equal_unequal_KS1s' ", p=" %7.5f `equal_unequal_KS_pval1s'  ", p=" %7.5f `p_equal_unequal_KS_DiDmax' " || KS (2-s)=" %7.5f `equal_unequal_KS' ", p=" %7.5f `equal_unequal_KS_pval' ", p=" %7.5f `p_equal_unequal_KS_DiDabs' 
	di "------------------------------------------------------------------------------------------------"
	di "Home   -equal: KS (1-s)=" %8.5f `equal_home_KS1srev' ", p=" %7.5f `equal_home_KS_pval1srev' ", p=" %7.5f `p_equal_home_KS_DiDmaxrev' " || KS (2-s)=" %7.5f `equal_home_KS' ", p=" %7.5f `equal_home_KS_pval' ", p=" %7.5f `p_equal_home_KS_DiDabs'
	di "Unequal-home:  KS (1-s)=" %8.5f `home_unequal_KS1srev' ", p=" %7.5f `home_unequal_KS_pval1srev' ", p=" %7.5f `p_home_unequal_KS_DiDmaxrev' " || KS (2-s)=" %7.5f `home_unequal_KS' ", p=" %7.5f `home_unequal_KS_pval'  ", p=" %7.5f `p_home_unequal_KS_DiDabs'
	di "Unequal-equal: KS (1-s)=" %8.5f `equal_unequal_KS1srev' ", p=" %7.5f `equal_unequal_KS_pval1srev'  ", p=" %7.5f `p_equal_unequal_KS_DiDmaxrev' " || KS (2-s)=" %7.5f `equal_unequal_KS' ", p=" %7.5f `equal_unequal_KS_pval' ", p=" %7.5f `p_equal_unequal_KS_DiDabs' 
	di "------------------------------------------------------------------------------------------------"
	di ""

di "******************************************************************************************************"

qui log off key_results

restore

di "[$S_DATE, $S_TIME]"

} /* gg */
} /* zz */

	**********************
	* END
	**********************

qui log on key_results
log close key_results
log close
set more on

	*
