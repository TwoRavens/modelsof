

*****************************************************************
*	Description: Regress Tau against various state level 		*
* 	measures 													*
*****************************************************************


*************************
*		Set up 			*
*************************

clear all
set more off

*****************
*	Load Data	*
*****************

use "$dir/raw/non_ec_data/data_for_state_regressions_final.dta"


*********************************************************************************
*																				*
*						Create tables for the paper:							*
*																				*
*********************************************************************************



************* 	Tau Against Other Measures of Regulations	*************

*** TABLE 4 Regress Tau against BB_97 and Dougherty (All States):
local depvars tau_npr_n 
local indvars Dougherty_all_n Dougherty_insp_n BB_97_n 
eststo clear
foreach x in `indvars'	{
	foreach y in `depvars'	{
		eststo: quietly reg `y' `x'   [aweight=1/(stderr_npr_cl_nic)^2] ,  robust
		eststo: quietly reg `y' `x' lnNSDPpc05  sh_estab_private   [aweight=1/(stderr_npr_cl_nic)^2] ,   robust 
	}
}

esttab using "$dir/2_main_text_figures_tables/tables_4_and_5/output/Table_4_Regressing_Tau_Against_Other_Measures_of_Regulations_robust_allstates.tex", se replace label ///
	star( * 0.10 ** 0.05 *** 0.01) /*nostar*/ nonote ///
	order(Dougherty_all_n Dougherty_insp_n BB_97_n) wrap coeflabels(BB_97_n "Besley-Burgess measure (regs)" Dougherty_all_n "Dougherty measure (all reforms)" Dougherty_insp_n "Dougherty measure (inspector reforms)") 
eststo clear


*** TABLE 12 Robustness Test - Regress Tau against BB_97 and Dougherty (Major States):
local depvars tau_npr_n 
local indvars Dougherty_all_n Dougherty_insp_n BB_97_n 
eststo clear
foreach x in `indvars'	{
	foreach y in `depvars'	{
		eststo: quietly reg `y' `x' if maj_ind ==1  [aweight=1/(stderr_npr_cl_nic)^2] ,  robust
		eststo: quietly reg `y' `x' lnNSDPpc05  sh_estab_private   if maj_ind ==1  [aweight=1/(stderr_npr_cl_nic)^2] ,   robust 
	}
}

esttab using "$dir/4_appendix_figures_tables/output/Table_12_Regressing_Tau_Against_Other_Measures_of_Regulations_robust_maj_states.tex", se replace label ///
	star( * 0.10 ** 0.05 *** 0.01) /*nostar*/ nonote ///
	order(Dougherty_all_n Dougherty_insp_n BB_97_n) wrap coeflabels(BB_97_n "Besley-Burgess measure (regs)" Dougherty_all_n "Dougherty measure (all reforms)" Dougherty_insp_n "Dougherty measure (inspector reforms)")
eststo clear


************* 	Tau Against Measures of Corruption	*************

*** TABLE 5 Regress Tau against Both Measures of Corruption (All States):

eststo clear

	eststo: quietly reg tau_npr_n corruption_score_n   [aweight=1/(stderr_npr_cl_nic)^2] ,  robust 
	estadd local sample "TI" 
	eststo: quietly reg tau_npr_n corruption_score_n lnNSDPpc05  sh_estab_private     [aweight=1/(stderr_npr_cl_nic)^2] ,  robust
	estadd local sample "TI" 
	eststo: quietly reg tau_npr_n corruption_score_n lnNSDPpc05  sh_estab_private Dougherty_insp_n    [aweight=1/(stderr_npr_cl_nic)^2] ,  robust
	estadd local sample "TI" 
	
	eststo: quietly reg tau_npr_n td_losses_05_n   [aweight=1/(stderr_npr_cl_nic)^2] ,  robust 
	estadd local sample "TDLs" 
	eststo: quietly reg tau_npr_n td_losses_05_n lnNSDPpc05  sh_estab_private elec_avail_05_06_n   [aweight=1/(stderr_npr_cl_nic)^2] ,  robust
	estadd local sample "TDLs" 
	eststo: quietly reg tau_npr_n td_losses_05_n lnNSDPpc05  sh_estab_private Dougherty_insp_n    [aweight=1/(stderr_npr_cl_nic)^2] ,  robust
	estadd local sample "TDLs" 

esttab using "$dir/2_main_text_figures_tables/tables_4_and_5/output/Table_5_Regressing_Tau_Against_Corruption_Both_Measures_robust_allstates.tex", se replace label ////
	/*nodepvars*/ star( * 0.10 ** 0.05 *** 0.01) /*nostar*/  nonote ///
	/*addnotes(/*"* p $<$ 0.10, ** p $<$ 0.05, *** p $<$ 0.01"*/ "Robust standard errors in parentheses" "Including All States and Union Territories for which data are available" "Observations weighted by inverse variance of tau")*/   ////
	wrap  scalars("sample Measure of Corruption") /// 
	order(corruption_score_n td_losses_05_n)
	
eststo clear


*** TABLE 13 Robustness Test - Regress Tau against Both Measures of Corruption (Major States):

eststo clear

	eststo: quietly reg tau_npr_n corruption_score_n if maj_ind ==1  [aweight=1/(stderr_npr_cl_nic)^2] ,  robust 
	estadd local sample "TI" 
	eststo: quietly reg tau_npr_n corruption_score_n lnNSDPpc05  sh_estab_private   if maj_ind ==1  [aweight=1/(stderr_npr_cl_nic)^2] ,  robust
	estadd local sample "TI" 
	eststo: quietly reg tau_npr_n corruption_score_n lnNSDPpc05  sh_estab_private Dougherty_insp_n  if maj_ind ==1  [aweight=1/(stderr_npr_cl_nic)^2] ,  robust
	estadd local sample "TI" 
	
	eststo: quietly reg tau_npr_n td_losses_05_n if maj_ind ==1  [aweight=1/(stderr_npr_cl_nic)^2] ,  robust 
	estadd local sample "TDLs" 
	eststo: quietly reg tau_npr_n td_losses_05_n lnNSDPpc05  sh_estab_private elec_avail_05_06_n if maj_ind ==1  [aweight=1/(stderr_npr_cl_nic)^2] ,  robust
	estadd local sample "TDLs" 
	eststo: quietly reg tau_npr_n td_losses_05_n lnNSDPpc05  sh_estab_private Dougherty_insp_n  if maj_ind ==1  [aweight=1/(stderr_npr_cl_nic)^2] ,  robust
	estadd local sample "TDLs" 

esttab using "$dir/4_appendix_figures_tables/output/Table_13_Regressing_Tau_Against_Corruption_Both_Measures.tex", se replace label ////
	/*nodepvars*/ star( * 0.10 ** 0.05 *** 0.01) /*nostar*/  nonote ///
	/*addnotes(/*"* p $<$ 0.10, ** p $<$ 0.05, *** p $<$ 0.01"*/ "Robust standard errors in parentheses" "Only including Major Indian States" "Observations weighted by inverse variance of tau")*/   ////
	wrap  scalars("sample Measure of Corruption") /// 
	order(corruption_score_n td_losses_05_n)
eststo clear


* Save Twoway Partial Residual Plots corresponding to weighted regressions above:

* Figure 3:
eststo clear
reg tau_npr_n corruption_score_n  sh_estab_private  lnNSDPpc05 Dougherty_insp_n if maj_ind ==1 [aweight=1/(stderr_npr_cl_nic)^2] 
avplot corruption_score_n, mlabel(state_name) ytitle(Partial Residuals of Tau) xtitle(Partial Residuals of Corruption Score) 
graph export "$dir/4_appendix_figures_tables/output/Figure_3_avplot_tau_corruption_score_weighted.pdf", replace

* Figure 4:
eststo clear
reg tau_npr_n td_losses_05_n  sh_estab_private  lnNSDPpc05 Dougherty_insp_n if maj_ind ==1 [aweight=1/(stderr_npr_cl_nic)^2] 
avplot td_losses_05_n, mlabel(state_name) ytitle(Partial Residuals of Tau) xtitle(Partial Residuals of Transmission and Distribution Losses) 
graph export "$dir/4_appendix_figures_tables/output/Figure_4_avplot_tau_TDL_weighted.pdf", replace
eststo clear




************* 	Tau Against Measures of Regulatory Enforcement/Environment	*************

*** 	Table 11: Regress Tau against Strikes and Lockouts:
local depvars tau_npr_n 
local indvars strikes_pc_n mandays_lost_strikes_pc_n lockouts_pc_n mandays_lost_lockouts_pc_n perc_fac_insp_n
eststo clear
foreach x in `indvars'	{
	foreach y in `depvars'	{
		eststo: quietly reg `y' `x' lnNSDPpc05 if maj_ind ==1  [aweight=1/(stderr_npr_cl_nic)^2] ,  robust
	}
}
esttab using "$dir/4_appendix_figures_tables/output/Table_11_Regressing_Tau_Against_Strikes_Lockouts.tex", se replace label star( * 0.10 ** 0.05 *** 0.01) nonote order(strikes_pc_n mandays_lost_strikes_pc_n lockouts_pc_n mandays_lost_lockouts_pc_n perc_fac_insp_n)  wrap coeflabels(strikes_pc_n "strikes per capita" mandays_lost_strikes_pc_n "mandays lost due to strikes per capita" lockouts_pc_n "lockouts per capita" mandays_lost_lockouts_pc_n "mandays lost due to lockouts per capita" perc_fac_insp_n "percent of factories inspected")
eststo clear




************* 		Employment Growth Against Tau 		*************

****	Table 15: Employment Growth vs Tau, Besley Burgess AND Dougherty Indices	***

local depvars  reg_mf_e unreg_mf_e 
local indvars tau_npr_n tau_mnf_npr_n BB_97_n Dougherty_all_n
eststo clear
foreach x in `indvars'	{
	foreach y in `depvars'	{
		eststo: quietly reg `y' `x' lnNSDPpc05  sh_manuf_emp if maj_ind ==1,
	}
}
esttab using "$dir/4_appendix_figures_tables/output/Table_15_Regressing_Tau_etc_Against_Growth_In_Reg_vs_Unreg_Manufacturing_Employment_Growth.tex", /// 
	se replace label /*nodepvars*/ star( * 0.10 ** 0.05 *** 0.01) nonote  ///
	order(tau_npr_n tau_mnf_npr_n BB_97_n Dougherty_all_n) ///
	wrap coeflabels(tau_npr_n "tau" tau_mnf_npr_n "tau (manuf)") //compress //keep(ln_gpdpc _cons) 
eststo clear
