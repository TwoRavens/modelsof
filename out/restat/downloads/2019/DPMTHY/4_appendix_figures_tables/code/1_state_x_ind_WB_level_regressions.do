

*****************************************************************
*	Description: Regress Tau against state x industry level 	*
* 	measures of corruption and regulatory dependence.			*
*****************************************************************


*************************
*		Set up 			*
*************************

cd "$dir/4_appendix_figures_tables/output"

clear all
set more off


*****************
*	Load Data	*
*****************

use "$dir/raw/non_ec_data/data_for_state_x_ind_regressions_final.dta"


*****************************************************************
* 	Table 14: Reg of tau vs interaction between state-level 	*
*	corruption vars with industry level measures of regulatory 	*
*	dependence:													*
*****************************************************************


eststo clear
eststo: quietly reg tau_npr corruption_score prob_ind_spec_reg lnNSDPpc05 if maj_ind ==1 [aweight=1/(stderr_npr)^2], 
eststo: quietly reg tau_npr c.corruption_score##c.prob_ind_spec_reg lnNSDPpc05 if maj_ind ==1 [aweight=1/(stderr_npr)^2], 
eststo: quietly reg tau_npr td_losses_05 prob_ind_spec_reg lnNSDPpc05 if maj_ind ==1 [aweight=1/(stderr_npr)^2], 
eststo: quietly reg tau_npr c.td_losses_05##c.prob_ind_spec_reg lnNSDPpc05 if maj_ind ==1 [aweight=1/(stderr_npr)^2], 

esttab using "Table_14_Regressing_Tau_Against_corruption_vars_X_WB_Ind_problem_vars.tex", se replace interaction(" X ") label  ///
	star( * 0.10 ** 0.05 *** 0.01) nonote ///
	compress order(lnNSDPpc05 corruption_score td_losses_05) wrap 
eststo clear
