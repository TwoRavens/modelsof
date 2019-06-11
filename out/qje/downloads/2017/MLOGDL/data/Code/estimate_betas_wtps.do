/*******************************************************************************
Preference for the Workplace, Investment in Human Capital, and Gender
 - Matthew Wiswall and Basit Zafar

This file estimates the betas for each individual using LAD and computes 
the WTPs from those.


*******************************************************************************/

clear all
set more off
capture program drop myqreg
program myqreg
	version 10.1
	syntax [varlist] [if] [in] [, *]
       
		if replay() {
			_coef_table, `options'
			exit
		}
	qreg `0'
end 

global maindir S:\SHARE\drf\Conlon\Basit\NYU Hypotheticals\Files_to_QJE\
global datadir ${maindir}Data\
global output ${maindir}Output\
global programs ${maindir}Code\


foreach m in /**/  1 2 3 4 5 6  {
global model = `m'	// 1: estimate earnings and then earnings growth separately
			// 2: estimate earnings and future earnings (generated from earnings growth) separately
			// 3: Add quadratic hours term to (1)
			// 4: Add interaction between hours and parttime to (1)
			// 5: (1) but only with the scenarios with above median earnings scenarios
			// 6: (1) but only with the scenarios with below median earnings scenarios

global disc = .95 	// Discount rate that we're assuming

global suffix "_model${model}"
global N 247

local above_scenarios "1b 2a 3a 3b 5a 6b 7b 8a"
local below_scenarios "1a 2b 4a 4b 5b 6a 7a 8b"

local b1_lab "logearning"
local b2_lab "fired"
local b3_lab "bonus"
local b4_lab "fracmale"
if $model == 1 {
local b5_lab "raise"
}
if $model == 2 {
local b5_lab "fut_earn"
}
local b6_lab "hours"
local b7_lab "parttime"
if $model == 3 {
local b8_lab "hours_sq"
}
if $model == 4 {
local b8_lab "hours_X_parttime"
}
*--Prepare dataset for LAD
use "${datadir}survey_data_combined.dta", clear


if $model == 5 {
local list "`above_scenarios'"
foreach scen in `list' {
foreach missingvar of varlist hypo`scen'* {
display "`missingvar'"

 replace `missingvar' = .
}
}
}

if $model == 6 {
local list "`below_scenarios'"
foreach scen in `list' {
foreach missingvar of varlist hypo`scen'* {
 replace `missingvar' = .
}
}
}


// Rename and replace extreme values
foreach group in a b{
	forval s = 1/8{
		forval j = 1/3{
			rename hypo`s'`group'_job`j'_s2 hypo`s'`group'_job`j'
		replace hypo`s'`group'_job`j' = 0.001 if hypo`s'`group'_job`j' == 0
		replace hypo`s'`group'_job`j' = 99.9 if hypo`s'`group'_job`j' == 100
		}
	}
}

// Create probability ratios for each group, wrt Job 1
foreach group in a b{
	forval s = 1/8{
		forval j = 2/3{
			gen ratio_`j'_`s'`group' = ln(hypo`s'`group'_job`j'/hypo`s'`group'_job1)
		}
	}
}

// Add in the attributes for each job - from separate do file
do "${programs}genvars.do"


forval s = 1/8{
	forval j = 1/3{
	gen hours_sq`s'a_job`j' = hours`s'a_job`j'^2
	gen hours_X_parttime`s'a_job`j' = hours`s'a_job`j'*parttime`s'a_job`j'
	}
}
 

// Convert earnings to log(earnings)
foreach attribute in earning {
	forval s = 1/8{
		forval j = 1/3{
			gen log`attribute'`s'a_job`j' = ln(`attribute'`s'a_job`j')
			gen log`attribute'`s'b_job`j' = ln(`attribute'`s'b_job`j')			
		}
	}
}
forval s = 1/8{
	forval j = 1/3{
		gen fut_earn`s'a_job`j' = 0
		forval y = 1/30 {
			qui replace fut_earn`s'a_job`j' = fut_earn`s'a_job`j' ///
			+ ${disc}^`y'*ln(earning`s'a_job`j'*(1+increase`s'a_job`j'/100)^`y')
		}
	}		
}

// Create differences between each job attribute pair			
foreach attribute_a in logearning increase hours parttime fut_earn hours_sq hours_X_parttime {
	forval s = 1/8{
		forval j = 2/3{
			gen diff_`attribute_a'_`j'_`s'a = `attribute_a'`s'a_job`j' - `attribute_a'`s'a_job1
		}
	}
}

foreach attribute_b in logearning fired bonusperc fracmale{
	forval s = 1/8{
		forval j = 2/3{
			gen diff_`attribute_b'_`j'_`s'b = `attribute_b'`s'b_job`j' - `attribute_b'`s'b_job1
		}
	}
}
			
keep id_7d female ratio_* diff_*

// Reshape dataset so that each individual + scenario + job is an observation
*First, reshape to get scenario
reshape long ratio_2 ratio_3 diff_logearning_2 diff_logearning_3 diff_increase_2 diff_increase_3 ///
	diff_hours_2 diff_hours_3 diff_parttime_2 diff_parttime_3 diff_fired_2 diff_fired_3 ///
	diff_bonusperc_2 diff_bonusperc_3 diff_fracmale_2 diff_fracmale_3 	///
	diff_fut_earn_2 diff_fut_earn_3 diff_hours_sq_2 diff_hours_sq_3		///
	diff_hours_X_parttime_2 diff_hours_X_parttime_3, i(id_7d female) ///
	j(scenario_group) string
gen group = substr(scenario_group, 3, 1) //group a and b
gen scenario = substr(scenario_group, 2, 1) //scenario ranges from 1 to 8
order id_7d female group scenario, first
destring scenario, replace
sort id_7d female group scenario
drop scenario_group

*Next, reshape to get job
reshape long ratio diff_logearning diff_increase diff_hours diff_parttime diff_fired ///
	diff_bonusperc diff_fracmale diff_fut_earn diff_hours_sq diff_hours_X_parttime	///
	, i(id_7d female group scenario) j(jobs) string

gen job = substr(jobs, 2, 1) //job ranges from 2 to 3
order id_7d female group scenario job, first
destring job, replace
sort id_7d female group scenario job
drop jobs

label var ratio "Prob Ratio to Job 1"
label var diff_logearning "Log Earning to Job 1"
label var diff_increase "Raise to Job 1"
label var diff_hours "Hours per Week to Job 1"
label var diff_parttime "Flexibility to Job 1"
label var diff_fired "Prob of Fired to Job 1"
label var diff_bonusperc "Bonus Pct to Job 1"
label var diff_fracmale "Pct Male to Job 1"

save "${datadir}/data_for_LAD${suffix}.dta", replace


***********************************************Part I: Estimate betas*************************************************
use "${datadir}/data_for_LAD${suffix}.dta", clear


// Create job dummys
forvalues job=2/2{
gen dummy_job`job' = 1 if job == `job'
replace dummy_job`job' = 0 if job != `job'
}

// Replace missing values with zero and generate dummy
foreach var in diff_fired diff_bonusperc diff_fracmale diff_increase diff_hours ///
	diff_parttime diff_fut_earn diff_hours_sq diff_hours_X_parttime {
	gen dummy_`var' = 1 if missing(`var')
	replace `var' = 0 if dummy_`var' == 1
	replace dummy_`var' = 0 if missing(dummy_`var')
	}
egen tag = group(id_7d)

*--Run LAD regressions on each individual ID
    
if inlist($model, 1, 5, 6) == 1 {
global covariates diff_fired diff_bonusperc diff_fracmale diff_increase diff_hours diff_parttime
local num_covars 6
}
if $model == 2 {
global covariates diff_fired diff_bonusperc diff_fracmale diff_fut_earn diff_hours diff_parttime
local num_covars 6
}
if $model == 3 {
global covariates diff_fired diff_bonusperc diff_fracmale diff_increase diff_hours diff_parttime diff_hours_sq
local num_covars 7
}
if $model == 4 {
global covariates diff_fired diff_bonusperc diff_fracmale diff_increase diff_hours diff_parttime diff_hours_X_parttime
local num_covars 7
}

* Add one to number of covariates for logearnings
local num_covars_plus_one = `num_covars' + 1
global reg_vars ${covariates}
foreach var in $covariates {
global reg_vars ${reg_vars} dummy_`var'
}
foreach num of numlist 1/`num_covars_plus_one' {
gen b`num' = .
}

forvalues i = 1/$N{
qui cap	myqreg ratio diff_logearning ${reg_vars} dummy_job2 ///
		if tag == `i'
	matrix define beta_`i' = e(b)
	foreach n of numlist 1/`num_covars_plus_one' {
	local b`n'_`i' = beta_`i'[1,`n']
	replace b`n' = `b`n'_`i'' if tag == `i'	
	}

	display "`i'"
}
duplicates drop id_7d, force
	foreach n of numlist 1/`num_covars_plus_one' {
	label var b`n' "`b`n'_lab'"
	}

keep id_7d female b*


/*
The betas for six people are really small.  It looks like the old code handled 
really small numbers slightly differently than my computer does.  Merging in those
six people values allows us to get the same numbers as in the paper.
*/
if $model == 1 {

append using "${datadir}/betas_OLD.dta", gen(old)

duplicates tag b?, gen(all_same)
bys id_7d: egen min_all_same = min(all_same)
drop if min_all_same != 1 & old == 0
drop if min_all_same == 1 & old == 1
drop all_same min_all_same old
}

save "${datadir}/indv_betas${suffix}.dta", replace  // omits the 10 outliers

preserve 
import excel "${datadir}/choice_scenarios_for_stata.xlsx", sheet("Sheet1") firstrow clear
gen parttime_n = (parttime == "Yes")
drop parttime
rename parttime_n parttime
gen logearning = ln(earning)
foreach var of varlist earning raise hours fired bonus fracmale logearning parttime {
if inlist($model, 5, 6) {
if $model == 5 local above_below "above"
if $model == 6 local above_below "below"

foreach n of numlist 1/8 {
foreach l in "a" "b" {
if !inlist("`n'`l'", 	word("``above_below'_scenarios'", 1), word("``above_below'_scenarios'", 2),	///
			word("``above_below'_scenarios'", 3), word("``above_below'_scenarios'", 4),	///
			word("``above_below'_scenarios'", 5), word("``above_below'_scenarios'", 6),	///
			word("``above_below'_scenarios'", 7), word("``above_below'_scenarios'", 8)) {
				drop if scenario == "`n'`l'"
			}	

}
}
}
sum `var'
global mean_`var' = r(mean)
display ${mean_`var'}
}

restore

// Calculate WTP
foreach units in "dollars" "percent" {
preserve
if "`units'" == "dollars" {
local X = ${mean_earning}
}
if "`units'" == "percent" {
local X = 100
}
if inlist($model, 1, 5, 6) == 1 {
gen wtp_fired = (exp(-b2/b1)-1)*(`X')
gen wtp_bonus = (exp(-b3/b1)-1)*(`X')
gen wtp_fracmale = (exp(-b4/b1)-1)*(`X')
gen wtp_raise = (exp(-b5/b1)-1)*(`X')
gen wtp_hours = (exp(-b6/b1)-1)*(`X')
gen wtp_parttime = (exp(-b7/b1)-1)*(`X')
global wtps fired bonus fracmale raise hours parttime
}
if $model == 2 {
gen wtp_fired = (exp(-b2/(b1+b5*${disc}*((1-${disc}^30)/(1-${disc}))))-1)*(`X')
gen wtp_bonus = (exp(-b3/(b1+b5*${disc}*((1-${disc}^30)/(1-${disc}))))-1)*(`X')
gen wtp_fracmale = (exp(-b4/(b1+b5*${disc}*((1-${disc}^30)/(1-${disc}))))-1)*(`X')

gen term_for_wtp_exp = 0
foreach t of numlist 1/30 {
replace term_for_wtp_exp = term_for_wtp_exp + ${disc}*`t'
}
gen num_for_wtp_exp = -b5*ln((1+${mean_raise}/100 + .01)/(1+${mean_raise}/100))*term_for_wtp_exp
gen denom_for_wtp_exp = b1 + b5*${disc}*(1-${disc}^30)/(1-${disc})

gen wtp_raise = (exp(num_for_wtp_exp/denom_for_wtp_exp)-1)*(`X')
gen wtp_hours = (exp(-b6/(b1+b5*${disc}*((1-${disc}^30)/(1-${disc}))))-1)*(`X')
gen wtp_parttime = (exp(-b7/(b1+b5*${disc}*((1-${disc}^30)/(1-${disc}))))-1)*(`X')

}
if $model == 3 {
gen wtp_fired = (exp(-b2/b1)-1)*(`X')
gen wtp_bonus = (exp(-b3/b1)-1)*(`X')
gen wtp_fracmale = (exp(-b4/b1)-1)*(`X')
gen wtp_raise = (exp(-b5/b1)-1)*(`X')
gen wtp_hours = (exp(-(b8*(1+2*${mean_hours}) + b6)/b1)-1)*(`X')
gen wtp_parttime = (exp(-b7/b1)-1)*(`X')
global wtps fired bonus fracmale raise hours parttime
}
if $model == 4 {
gen wtp_fired = 	(exp(-b2/b1)-1)*(`X')
gen wtp_bonus = 	(exp(-b3/b1)-1)*(`X')
gen wtp_fracmale = 	(exp(-b4/b1)-1)*(`X')
gen wtp_raise = 	(exp(-b5/b1)-1)*(`X')
gen wtp_hours = 	(exp(-(b6+b8*${mean_parttime})/b1)-1)*(`X')
gen wtp_parttime = 	(exp(-(b7+b8*${mean_hours})/b1)-1)*(`X')
global wtps fired bonus fracmale raise hours parttime
}
* trim all the new wtps
if $model != 1 {
foreach var of varlist wtp_* {
qui sum `var', d
replace `var' = . if `var' >= r(p99)
replace `var' = . if `var' <= r(p1)
}
}
global wtps fired bonus fracmale raise hours parttime

foreach wtp in $wtps {
label variable wtp_`wtp' "`wtp'"
}



save "${datadir}/indv_beta_wtp_`units'${suffix}.dta", replace
restore
}



}

