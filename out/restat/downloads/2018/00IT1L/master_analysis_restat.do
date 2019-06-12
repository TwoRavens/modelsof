clear*
capture log close

set more off
set matsize 11000
set emptycells drop
set maxvar 32767

***Set your main project file
global mypath "//rschfs1x/userRS\A-E\dbr88_RS\Documents/Selection/\`dataset'" 
***Suffix to be added to output files for specific iterations  
global refnote "" 

***Legacy options, not used in final paper (leave off) 
global coefficient_testing off
global uncontrolled off



local log_replace replace
local time "`c(current_date)'  `c(current_time)'"
local logdate = string( d(`c(current_date)'), "%dCY-N-D" )
local logtime=  subinstr("`c(current_time)'",":","_",.)


***Defining subprograms for use in main loop (counts number of respondents in each difficulty category):
capture program drop difficulty_count
program difficulty_count, rclass
	local difficulty_test \`difficulty'
	forvalues x=1/4 {

		qui count if `difficulty_test'==`x' & e(sample)==1
		return local count_`x'=r(N)
	}
end


***Outermost loop, loops over each dataset. 
foreach dataset in   brfss cex cps   {


***Define controls for each regression
	***CEX
	***Sets the regression commands to be used for the dataset: 
		global cex_reg_types	regress
			***Options: regress
	***Sets the regression specifications to be used for the data set (see below for differences in controls to be used). 
		global cex_reg_specs  \${cex_uncontrolled_controls}  `"\${cex_primary_controls}"' 
			***Options: \${cex_uncontrolled_controls} `"\${cex_primary_controls}"' `"\${cex_primary_controls_age2}"' `"\${cex_primary_controls_int}"'
	***Sets the subsample types to be used: 		
		global cex_robustness normal 
			***Options: normal second_only all personal telephone
	***Sets the dependent varaibles be used: 		
		global cex_dependent `" "ln_total" "'
			***Options: `" "ln_total" "ln_food" "ln_health" "'
	***Specifies the primary controls, reported, for each regression specification: 
		global cex_primary_controls 		`"b2.education i.female i.race b3.income	b2.size i.children b3.age"' 
		global cex_primary_controls_age2	`"b2.education i.female i.race b3.income	b2.size i.children b3.age2 b3.age2#female b3.age2#b2.education i.female#b2.education"' 
		global cex_primary_controls_int 	`"b2.education i.female i.race b3.income	b2.size i.children b3.age i.interview_length_group i.hour_group_all"' 
		global cex_primary_controls_no_income 	`"b2.education i.female i.race 				b2.size i.children b3.age"'
	***Specifices extra controls, unreported, to be used in all regression specifications. 
		global cex_extra_controls    " i.marriage  i.urban_rural i.interview_month i.interview_year "
	***Sets categories to be used in teh summary statistics tables:
		global cex_uncontrolled_controls b2.education i.female i.race b3.income	b2.size i.children b3.age " "
		global cex_summary_mean_cat  `" "education"  "race" "income" "size" "children" "age" "' 
		global cex_summary_mean_nocat `" "total" "food" "health" "ln_total" "ln_food" "ln_health" "female" "'  
		global cex_summary_median	"attempts_cleaned" 
	***Sets regression options to be included in all regressions for this dataset. 
		global cex_reg_options  

	***BRFSS
	global brfss_reg_types	 regress
		***Options: regress probit logit
	global brfss_reg_specs   \${brfss_uncontrolled_controls}  `"\${brfss_primary_controls}"' 
		***Options:  \${brfss_uncontrolled_controls} `"\${brfss_primary_controls}"' `"\${brfss_primary_controls_age2}"' `"\${brfss_primary_controls_lforce}"' `"\${brfss_primary_controls_fiid}"'
	global brfss_robustness normal
		***Options: normal weighted fesample
	global brfss_dependent `" "sr_obese" "'	
		***Options: `" "sr_obese" "sr_height" "sr_weight" "'	
	global brfss_primary_controls 		`" b2.education b3.income i.female b3.age 	i.children i.race"'
	global brfss_primary_controls_age2 		`" b2.education b3.income i.female i.children i.race b3.age2 b3.age2#female b3.age2#b2.education i.female#b2.education "'
	global brfss_primary_controls_lforce 		`" b2.education b3.income i.female b3.age 	i.children i.race i.lforce "'
	global brfss_primary_controls_fiid 		`" b2.education b3.income i.female b3.age 	i.children i.race"'
	global brfss_uncontrolled_controls     b3.income i.female b3.age 	i.children i.race " "	 
	global brfss_extra_controls  " i.marriage  i.statenum i.urban_rural i.interview_month "
	****Use this version for FI id subsample run: global brfss_extra_controls  " i.marriage  i.statenum i.urban_rural i.interview_month i.fi_id  "
	global brfss_summary_mean_cat  `" "education" "race" "income" "children" "age" "female" "' 
	global brfss_summary_mean_nocat `" "sr_obese" "sr_height" "sr_weight" "'
	global brfss_summary_median	"attempts_cleaned " 
	global brfss_reg_options  

	***CPS
	global cps_reg_types	regress 
		***Options: regress probit logit
	global cps_reg_specs \${cps_uncontrolled_controls} `"\${cps_primary_controls}"'   
		***Options: \${cps_uncontrolled_controls}  `"\${cps_primary_controls}"'  `"\${cps_primary_controls_age2}"' 
	global cps_robustness normal  
		***Options: normal self nonself personal telephone 
	global cps_dependent `"  "unemployment_rate" "laborforce" "'
		***Options: `"  "unemployment_rate" "laborforce" "'
	global cps_primary_controls 	`"b2.education i.female i.race i.children b3.age"'
	global cps_primary_controls_age2 	`"b2.education i.female i.race i.children b3.age2 b3.age2#female b3.age2#b2.education i.female#b2.education"'
	global cps_extra_controls " i.marriage i.statenum i.urban_rural i.interview_month i.interview_year i.size "
	global cps_uncontrolled_controls    b2.education i.female i.race i.children b3.age " "
	global cps_summary_mean_cat  `" "education" "income" "race" "children" "age"  "employment" "' 
	global cps_summary_mean_nocat `" "female" "unemployment_rate" "laborforce" "'
	global cps_summary_median	"attempts_cleaned " 
	global cps_reg_options  `", vce(cluster hrhhid)"'
		
****Analysis begins here:
 use "${mypath}/data/`dataset'_analysis.dta", clear
 capture log close
 log using `"${mypath}/logs/`dataset'_log_`logdate'_`logtime'.txt"', text replace 
***Loops over each subsample to be used in the given data set. 
foreach spec in ${`dataset'_robustness}{
	if "`spec'"=="normal" {
		***Sets suffix for this subsample
			local robust ""
		***Sets difficulty variable to be used for this subsample
			local difficulty "difficulty"
		***Sets if statement that specifices the subsample being used
			local robust_if "\`dependent'!=."
		***Sets weight command for the subsample 
			local robust_weight ""
	}
	else if "`spec'"=="fesample" {
		local robust "_fesample"
		local difficulty "difficulty"
		local robust_if "fesample==1   "
		local robust_weight ""                                          
	}                                                                   
	else if "`spec'"=="self" {                                         
		local robust "_self"
		local difficulty "difficulty"
		local robust_if "self==1"
		local robust_weight ""
	}
		else if "`spec'"=="nonself" {
		local robust "_nonself"
		local difficulty "difficulty"
		local robust_if "nonself==1"
		local robust_weight ""
	}
		else if "`spec'"=="weighted" {
		local robust "_weighted"
		local difficulty "difficulty"
		local robust_if "\`dependent'!=."
		local robust_weight "[pw=_llcpwt]"
	}
		else if "`spec'"=="personal" & {
		local robust "_personal"
		local difficulty "difficulty"
		local robust_if "mode==1"
		local robust_weight ""
	}
		else if "`spec'"=="telephone" {
		local robust "_telephone"
			local difficulty "difficulty"
		local robust_if "mode==2"
		local robust_weight ""
	}
		else if "`spec'"=="second_only" {
		local robust "_second"
		local difficulty "difficulty_all"
		local robust_if "difficulty!=."
		local robust_weight ""
	}
		else if "`spec'"=="all" {
		local robust "_all"
		local difficulty "difficulty_all" 
		local robust_if "\`dependent'!=."
		local robust_weight ""
	}
	
	***Loops over dependent variables to be analyzed in this dataset
	foreach dependent in ${`dataset'_dependent} {
		***Sets decimal places and number of difficulty categories to be used for each analysis 
		if ("`dependent'"=="total" | "`dependent'"=="health" |"`dependent'"=="food") & "`spec'"!="decimals" local decimals 0
		else local decimals 3
		if ("`dependent'"=="total" | "`dependent'"=="health" |"`dependent'"=="food" | "`dependent'"=="ln_total" | "`dependent'"=="ln_health" |"`dependent'"=="ln_food") & "`spec'"!="decimals" local adjmean_decimals 0
		else local adjmean_decimals 3
		if ("`dataset'"=="cps" & "`spec'"=="personal") local attempt_cats 3
		else local attempt_cats 4
		foreach command in ${`dataset'_reg_types} {
				local replace replace

				***Loops over sets of controls to be used in the analysis 
				foreach primary_controls in ${`dataset'_reg_specs} {
					if "`primary_controls'"=="${`dataset'_primary_controls}" {
						***Sets unreported control variables to be used
							local extra_controls `"${`dataset'_extra_controls}"'
						***Sets suffixes 
							local control_level controlled
							local suffix _primary
						local replace replace
					}
					else if "`primary_controls'"=="${`dataset'_primary_controls_age2}" {
						local extra_controls `"${`dataset'_extra_controls}"'
						local control_level controlled
						local suffix _age2
						local replace replace
					}	
					else if "`primary_controls'"=="${`dataset'_primary_controls_int}" {
						local extra_controls `"${`dataset'_extra_controls}"'
						local control_level controlled
						local suffix _intcontrols
						local replace replace
					}	
					else if "`primary_controls'"=="${`dataset'_primary_controls_lforce}" {
						local extra_controls `"${`dataset'_extra_controls}"'
						local control_level controlled
						local suffix _lforce
						local replace replace
					}							
					else if "`primary_controls'"=="${`dataset'_primary_controls_fiid}" {
						local extra_controls `"${`dataset'_extra_controls}"'
						local control_level controlled
						local suffix _fiid
						local replace replace
					}											
					else if "`primary_controls'"=="${`dataset'_primary_controls_no_income}" {
						local extra_controls `"${`dataset'_extra_controls}"'
						local control_level controlled
						local suffix _no_income
						local replace replace
					}
					else if "`primary_controls'"!="${`dataset'_primary_controls}" {
						local extra_controls " "
						local control_level "uncontrolled"
						local suffix 
					}
					
					if "`dependent'"=="ln_total"  | "`dependent'"=="ln_health" | "`dependent'"=="ln_food" {
						***Configues options output for exponentiation for log dependent variables
						local dependent_option ""
						local dependent_option_outreg "stats(coef se) stnum(replace coef=exp(coef)-1, replace se=coef*se)"
						local dependent_option_margins "expression(exp(predict())-1)"

					}
					else {
						local dependent_option ""
						local dependent_option_outreg ""
						local dependent_option_margins ""						
					}
					
					if "`dataset'"=="cex" & "`spec'"!="all" {
						***Uses only second interview data in CEX analysis, except for one robustness check
						local dataset_if " & interview==2"
					}
					else {
						local dataset_if ""
					}
					
					if "$uncontrolled"=="off" & "`control_level'"=="uncontrolled" {
						**For when we do not want to create uncontrolled regressions for each covariate (legacy option)
					}
					else {
						if "`command'"=="probit" & ("`dependent'"=="sr_height"  | "`dependent'"=="sr_weight") {
						**These are command/dependent variables we want to skip
						}
						else {
								local addnote addnote("regression" "" "`dataset'_`dependent'_`command'_`control_level'`suffix'`robust'${refnote}" "" "Time" ""	"`time'")
								
								use "${mypath}/data/`dataset'_analysis.dta", clear
								
								***For probits margins will not estimate with categories dropped in the primary regression, so fixing some state/difficulty/robustness check combinations for outcomes where this is a problem with the probit estimation. NOTE: This is only for a small number of robustness checks using probit/logit specification (This code is only included to allow the overall loop to run without creating errors, since this output is not of analytical interest).  
								if "`command'"=="probit" & "`dependent'"=="unemployment_rate" & "`spec'"=="nonself" {
									**Dropping Kansas since KS & diff==4 perfectly predicts unemployment status
									drop if state==20 
								}
								if "`command'"=="probit" & "`dependent'"=="unemployment_rate" & "`spec'"=="telephone" {
										**Combining all problem states into one code so they do not error out
									recode state (47 2 22 28 31 33 40 46 49 54=99)
									*dropping households missing urban/rural indicator
									drop if urban_rural==3
								}
								estimates clear
								
								***Primary regression:							*
								`command' `dependent' `difficulty'##(`primary_controls' `extra_controls') `robust_weight' if  `robust_if'  `dataset_if' ${`dataset'_reg_options} `dependent_option'
								di "`command' `dependent' `difficulty'##(`primary_controls' `extra_controls') `robust_weight' if  `robust_if' `dataset_if' ${`dataset'_reg_options}  "
								estimates store s1
								fvexpand `difficulty'##(`primary_controls')
								local keep ="`r(varlist)'"					
								di "`keep'"
								
								forvalues x=1/4 {
									qui count if `difficulty'==`x' & e(sample)==1
									local count_`x'=r(N)
								}
								outreg2 using "${mypath}/outreg/`dependent'_`command'_`control_level'`suffix'`robust'${refnote}", dec(`decimals') rdec(3) excel   nolabel keep(`keep') `addnote' `replace'  addstat(diff_1_count, `count_1', diff_2_count, `count_2', diff_3_count, `count_3', diff_4_count, `count_4')
								
						
								local replace ""
								if "`control_level'"!="uncontrolled" {
									margins i.`difficulty', post 
									outreg2 using "${mypath}/outreg/`dependent'_`command'_`control_level'`suffix'`robust'${refnote}", dec(`adjmean_decimals') excel nolabel `dependent_option_outreg'
									pause
									if "`dependent'"=="ln_total"  | "`dependent'"=="ln_health" | "`dependent'"=="ln_food" {
										outreg2 using "${mypath}/outreg/`dependent'_`command'_`control_level'`suffix'`robust'${refnote}", dec(`decimals') excel nolabel  
									}
																										
								}
								
								
						}
					}

						
						
							
							
						
						
					
					
				}
			
			
			}
		}
	}
*/


/***Creates summary statistics
	set matsize 11000
	use "${mypath}/data/`dataset'_analysis.dta", clear
	if "`dataset'"=="cex" {
		keep if interview==2
		keep if difficulty!=.
	}
	
	g n=1
	local max_cats=1
		foreach variable in $`dataset'_summary_mean_cat	{
			ta `variable', g(`variable'_d)
			local rows=r(r)
			if `rows'>`max_cats' {
			local max_cats=`rows'
			}
			forvalues x= 1/`rows' {
				g `variable'_d`x'_se=`variable'_d`x'
			}
		}	
		
		local mean_nocats ""
		local se_nocats ""
		foreach variable in $`dataset'_summary_mean_nocat	{
			g `variable'_se=`variable'
			local se_nocats= "`se_nocats'" +" "+"`variable'_se"
			local mean_nocats= "`mean_nocats'" +" "+"`variable'"
		}
	
	local mean_d_cats ""
	local se_d_cats ""
	
	forvalues x=1/`max_cats' {
		local mean_d_cats= "`mean_d_cats'" +" "+"*_d`x'"
		local se_d_cats= "`se_d_cats'" +" "+"*_d`x'_se"

	}
	
	di "`mean_d_cats'"
	di "`se_d_cats'"
	preserve
	tempfile `dataset'_summary_bydiff `datset'_summary_overall
	collapse (mean) `mean_d_cats' `mean_nocats' (semean) `se_nocats' `se_d_cats'  (median) $`dataset'_summary_median (sum) n, by(difficulty)
		save ``dataset'_summary_bydiff'
	restore
	collapse (mean) `mean_d_cats' `mean_nocats' (semean)  `se_nocats'  `se_d_cats' (median) $`dataset'_summary_median (sum) n
		append using ``dataset'_summary_bydiff'
	replace difficulty=5 if difficulty==.	
	foreach variable of varlist _all {
		if "`dataset'"!="cex" & "`variable'"!="attempts_cleaned" & "`variable'"!="n" {
			replace `variable'=round(`variable',0.001)
			replace `variable'=`variable'*100

		}
	}
	gsort difficulty
	xpose, varname clear
	gsort _varname
	order _varname v*
	export excel using ${mypath}/outreg/`dataset'_summarystats.xlsx, replace
	
	
	
	
	
	
	

*/




}
capture log close
clear
