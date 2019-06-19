	* do "Run2_KS_test_5gr.do"

	**********************
	* INITIALIZE
	**********************

set seed 1234567

clear all
mata: mata clear
program drop _all
set matsize 2000

local name="Run2_KS_test_5gr"

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

	********************
	* START LOOP
	********************

foreach zz in "endog" "exog" {

if "`zz'"=="exog" {
	local routine_name="selection_exog_5gr"
	local add_options=" sleep(500)"
}
if "`zz'"=="endog" {
	local routine_name="selection_endog_5gr"
	local add_options `"iv(`iv') wageseen(wageseen) sleep(500)"'
}
	
foreach gg in 1 { 

di "---------------------------------------------------------------"
di "gg=`gg'. [$S_DATE, $S_TIME]"
di "`zz'"
di "---------------------------------------------------------------"

`routine_name' `cova1' `cova2' `personal' ///
	if sample_selALL==1 & round==2, ///
	refvar(ineq_r7525grad_gg`gg') home(1) xmin(`xmin_r2') xmax(`xmax_r2') title("round 2.") ///
	dep(lgincomeP_r) ///
	gen(uhat_aux)  filename("run2_cdf_r2_ALL_gg`gg'_xxALL_`zz'")  grid(`grid_main') cdfoff(0) ///
	subpredd(1) subpredvar(sample_selALL) bootstrap(0) stubnew("base") smoothoff(0) ///
	`add_options' 

qui putmata base_group base_sel base_gen if base_sel==1, replace

drop base_*

foreach qq in "home_unequal" "equal_home" "equal_unequal" "equal_Sequal" "Sequal_home" "home_Sunequal" "Sunequal_unequal" {

	local `qq'_DiDmax=_coef[`qq'_DiDmax]
	local `qq'_DiDmaxrev=_coef[`qq'_DiDmaxrev]
	local `qq'_KS1s=_coef[`qq'_KS1s]
	local `qq'_KS1srev=_coef[`qq'_KS1srev]
	local `qq'_pval1s=_coef[`qq'_pval1s]
	local `qq'_pval1srev=_coef[`qq'_pval1srev]

}

qui log on key_results

di ""
di "******************************************************************************************************"
di "RESULTS `zz'"
di "gg=`gg'. [$S_DATE, $S_TIME]"
di "******************************************************************************************************"
di ""

bootstrap, strata(ineq_r7525grad_gg`gg') ///
  	reps(`reps') saving("${output}/run2_data_ALL_gg`gg'_xxALL_`zz'.dta", replace):  ///
	`routine_name' `cova1' `cova2' `personal' ///
	if sample_selALL==1 & round==2, ///
	refvar(ineq_r7525grad_gg`gg') home(1) xmin(`xmin_r2') xmax(`xmax_r2') title("round 2.") ///
	dep(lgincomeP_r) ///
	gen(uhat_aux)  filename("run2_bs_cdf_ALL_gg`gg'_xxALL_`zz'")  grid(2) cdfoff(1) ///
	subpredd(1) subpredvar(sample_selALL) bootstrap(1) stubnew("base") smoothoff(1) ///
	`add_options' 

qui log off key_results

preserve

	use "${output}/run2_data_ALL_gg`gg'_xxALL_`zz'.dta", clear

		***********************
		* COMPUTE P-VALUES
		***********************
	
	foreach qq in "home_unequal" "equal_home" "equal_unequal" "equal_Sequal" "Sequal_home" "home_Sunequal" "Sunequal_unequal" {

		qui sum _b_`qq'_DiDmax, d
		qui gen temp=(``qq'_DiDmax'<_b_`qq'_DiDmax) if _b_`qq'_DiDmax!=. & ``qq'_DiDmax'!=.
		qui sum temp
		local p_`qq'_DiDmax=r(mean)
		drop temp

		qui sum _b_`qq'_DiDmaxrev, d
		qui gen temp=(``qq'_DiDmaxrev'>_b_`qq'_DiDmaxrev) if _b_`qq'_DiDmaxrev!=. & ``qq'_DiDmaxrev'!=.
		qui sum temp
		local p_`qq'_DiDmaxrev=r(mean)
		drop temp

	}

		***********************
		* OUTPUT
		***********************

	qui log on key_results

	di ""
	di "******************************************************************************************************"
	di "RESULTS `zz'"
	di "gg=`gg'. [$S_DATE, $S_TIME]"
	di "******************************************************************************************************"
	di ""


	di "-------------------------------------------------------------------------------------------------"
	foreach qq in  "equal_home" "home_unequal" "equal_unequal" "equal_Sequal" "Sequal_home" "home_Sunequal" "Sunequal_unequal" {

		di %20s "`qq'" ":    KS (1-s)=" %8.5f ``qq'_KS1s' ", p=" %7.5f ``qq'_pval1s' ", p=" %7.5f `p_`qq'_DiDmax' " || KSrev (1-s)=" %8.5f ``qq'_KS1srev' ", p=" %7.5f ``qq'_pval1srev' ", p=" %7.5f `p_`qq'_DiDmaxrev'	
		
		if "`qq'"=="equal_unequal" {
			di "-------------------------------------------------------------------------------------------------"
		}

	}
	di "-------------------------------------------------------------------------------------------------"


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
