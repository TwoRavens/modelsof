***************************************************
* Title: Pov_Viol Paper Data Analysis                          
* Date: November 7, 2015                              
***************************************************

/// Replication Note:

// Please install clttest.ado before running this .do file


clear
cd "~/Dropbox/PK2 share/Replication/Data"
use "FLMS_2015_prepped.dta", clear


*****************************************************
****************** PAPER ANALYSES *******************
*****************************************************

set more off

// RELATIVE POVERTY MANIPULATION

	tab income poverty, col
	tab income_bottom poverty, col
	reg income_bottom poverty, cluster (psu_new)

	bys poverty: summ d140, detail
	reg d140 poverty, cluster(psu_new)

// OVERALL ENDORSEMENT EFFECTS (FIGURE 1A)

	matrix results = J(5,2,0)

	local group  "b c d militancy e"
	local a = 1
	foreach x of local group {
		reg policy_pref_`x' treat_`x', cluster(psu_new)
		mat results[`a',1] = _b[treat_`x']
		mat results[`a',2] = _se[treat_`x']
		local ++a
	}

	matrix list results 


// KNOWLEDGE DIAGNOSTIC CHECK (FIGURE 1A) 

	matrix results = J(8,2,0)

	local a = 1
	local b = 5
	local group  "b c d militancy"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' knowledgehigh know_treat_`x', cluster(psu_new) 
		mat results[`a',1] = _b[treat_`x']
		mat results[`a',2] = _se[treat_`x']
		lincom treat_`x' + know_treat_`x'
		mat results[`b',1] = r(estimate)
		mat results[`b',2] = r(se)
		local ++a
		local ++b
	}

	matrix list results	


// EDHI DIAGNOSTIC CHECK (FIGURE 1B)

	matrix results = J(2,2,0)
	
	reg policy_pref_e treat_e if q1001<3, cluster(psu_new)
	mat results[1,1] = _b[treat_e]
	mat results[1,2] = _se[treat_e]

	reg policy_pref_e treat_e if q1001>2 & q1001!=., cluster(psu_new)
	mat results[2,1] = _b[treat_e]
	mat results[2,2] = _se[treat_e]

	matrix list results


// OBSERVATIONAL POVERTY RESULTS (FIGURE 2)

	matrix results = J(4,2,0)

	local group  "militancy"
	foreach x of local group {
		reg policy_pref_`x' lowexp20_urprov highexp20_urprov treat_`x' lowexp20_urprov_`x' highexp20_urprov_`x', cluster(psu_new)
		mat results[1,1] = _b[treat_`x']
		mat results[1,2] = _se[treat_`x']
		lincom treat_`x' + lowexp20_urprov_`x'
		mat results[2,1] = r(estimate)
		mat results[2,2] = r(se)
		lincom treat_`x' + highexp20_urprov_`x'
		mat results[3,1] = r(estimate)
		mat results[3,2] = r(se)
		lincom lowexp20_urprov_`x' - highexp20_urprov_`x'
		mat results[4,1] = r(estimate)
		mat results[4,2] = r(se)
	}
	
	matrix list results	


// RESULTS OF THE RELATIVE POVERTY EXPERIMENT (FIGURE 2)

	matrix results = J(3,2,0)
	
	local group  "militancy"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' poverty poverty_treat_`x', cluster(psu_new) 
		mat results[1,1] = _b[poverty_treat_`x']
		mat results[1,2] = _se[poverty_treat_`x']
		mat results[2,1] = _b[treat_`x']
		mat results[2,2] = _se[treat_`x']
		lincom treat_`x' + poverty_treat_`x'
		mat results[3,1] = r(estimate)
		mat results[3,2] = r(se)
	}

	matrix list results	


// RESULTS OF THE PERCEIVED VIOLENCE EXPERIMENT (FIGURE 3)

	matrix results = J(3,2,0)

	local group  "militancy"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' natviol natviol_treat_`x', cluster(psu_new) 
		mat results[1,1] = _b[natviol_treat_`x']
		mat results[1,2] = _se[natviol_treat_`x']
		mat results[2,1] = _b[treat_`x']
		mat results[2,2] = _se[treat_`x']
		lincom treat_`x' + natviol_treat_`x'
		mat results[3,1] = r(estimate)
		mat results[3,2] = r(se)
	}

	matrix list results	


// INTERACTION BETWEEN THE RELATIVE POVERTY AND PERCEIVED VIOLENCE EXPERIMENTS (FIGURE 4)

	matrix results = J(7,2,0)

	local group  "militancy"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' n01 n10 n11 n01_treat_`x' n10_treat_`x' n11_treat_`x', cluster(psu_new) 
		mat results[1,1] = _b[treat_`x']
		mat results[1,2] = _se[treat_`x']
		lincom treat_`x' + n01_treat_`x'
		mat results[2,1] = r(estimate)
		mat results[2,2] = r(se)
		lincom treat_`x' + n10_treat_`x'
		mat results[3,1] = r(estimate)
		mat results[3,2] = r(se)
		lincom treat_`x' + n11_treat_`x'
		mat results[4,1] = r(estimate)
		mat results[4,2] = r(se)
		lincom n11_treat_`x'
		mat results[5,1] = r(estimate)
		mat results[5,2] = r(se)
		lincom n11_treat_`x' - n10_treat_`x' 
		mat results[6,1] = r(estimate)
		mat results[6,2] = r(se)
		lincom n11_treat_`x' - n01_treat_`x'
		mat results[7,1] = r(estimate)
		mat results[7,2] = r(se)	
	}

	matrix list results	


// TREATMENT EFFECT OF RELATIVE POVERTY AND PERCEIVED VIOLENCE BY OBSERVED POVERTY (FIGURE 5):

	matrix results = J(3,2,0)

	local group "militancy"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' poverty poverty_treat_`x' if lowexp20_urprov==1, cluster(psu_new) 
		mat results[1,1] = _b[poverty_treat_`x']
		mat results[1,2] = _se[poverty_treat_`x']
		mat results[2,1] = _b[treat_`x']
		mat results[2,2] = _se[treat_`x']
		lincom treat_`x' + poverty_treat_`x'
		mat results[3,1] = r(estimate)
		mat results[3,2] = r(se)
	}
	
	matrix list results

	matrix results = J(3,2,0)

	local group "militancy"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' poverty poverty_treat_`x' if lowexp20_urprov!=1, cluster(psu_new) 
		mat results[1,1] = _b[poverty_treat_`x']
		mat results[1,2] = _se[poverty_treat_`x']
		mat results[2,1] = _b[treat_`x']
		mat results[2,2] = _se[treat_`x']
		lincom treat_`x' + poverty_treat_`x'
		mat results[3,1] = r(estimate)
		mat results[3,2] = r(se)
	}

	matrix list results

	matrix results = J(3,2,0)

	local group "militancy"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' natviol natviol_treat_`x' if lowexp20_urprov==1, cluster(psu_new) 
		mat results[1,1] = _b[natviol_treat_`x']
		mat results[1,2] = _se[natviol_treat_`x']
		mat results[2,1] = _b[treat_`x']
		mat results[2,2] = _se[treat_`x']
		lincom treat_`x' + natviol_treat_`x'
		mat results[3,1] = r(estimate)
		mat results[3,2] = r(se)
	}

	matrix list results

	matrix results = J(3,2,0)

	local group "militancy"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' natviol natviol_treat_`x' if lowexp20_urprov!=1, cluster(psu_new) 
		mat results[1,1] = _b[natviol_treat_`x']
		mat results[1,2] = _se[natviol_treat_`x']
		mat results[2,1] = _b[treat_`x']
		mat results[2,2] = _se[treat_`x']
		lincom treat_`x' + natviol_treat_`x'
		mat results[3,1] = r(estimate)
		mat results[3,2] = r(se)
	}

	matrix list results


// EFFECTS OF THE VIOLENCE EXPERIMENT ON POLICY RELEVANT SUB-SAMPLES

	reg policy_pref_militancy treat_militancy natviol natviol_treat_militancy if fata==1, cluster(psu_new) 
	reg policy_pref_militancy treat_militancy natviol natviol_treat_militancy if d230==4, cluster(psu_new) 


************************************************
****************** FOOTNOTES *******************
************************************************

// Footnote 16: FATA Policy Question

	tab q810a fata, col
	tab fata_support fata, col
	reg fata_support fata, cluster(psu_new)

	bys fata: summ q810a
	reg q810a fata, cluster(psu_new)


// Footnote 22: Knowledge Diagnostic Check

	// General Knowledge Quiz as a Dummy for High / Low and as Continuous Variable
	
	local group  "militancy"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' knowledgehigh know_treat_`x', cluster(psu_new) 
		reg policy_pref_`x' treat_`x' knowledge knowledge_treat_`x', cluster(psu_new) 
	}

	matrix list results

	// Robustness Check with PCA Knowledge Index

	local group  "militancy"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' knowfull_high knowfullhigh_treat_`x', cluster(psu_new) 
		reg policy_pref_`x' treat_`x' knowfullpca knowfull_treat_`x', cluster(psu_new)
	}

// Footnote 25: Correlation between Household Expenditures and Education

	corr d140 educ_z

// Footnote 26: Effect of the Poverty Experiment on Support for Edhi

	reg policy_pref_e treat_e poverty poverty_treat_e, cluster(psu_new) 

// Footnote 27: Effect of the Violence Experiment on Support for Edhi

	reg policy_pref_e treat_e natviol natviol_treat_e, cluster(psu_new) 

// Footnote 29: Effect of the Poverty Experiment on Support for Edhi among Middle and Upper Class Respondents

	reg policy_pref_e treat_e poverty poverty_treat_e if lowexp20_urprov!=1, cluster(psu_new) 


******************************************************
****************** APPENDIX TABLES *******************
******************************************************

use "FLMS_2015_prepped.dta", clear

*** Overview of Tables ***

* Appendix Table 1: Descriptive Statistics for Policy Support by Experimental Condition 
* Appendix Table 2: Support for Militant Groups as Measured by the Endorsement Experiment
* Appendix Table 3: Effects of Observed Poverty on Support for Militant Groups  
* Appendix Table 4: Effects of Experimental Treatments on Support for Militant Groups  
* Appendix Table 5: Effects of Experimental Treatments by Observed Poverty on Support for Militant Groups  
* Appendix Table 6: Effects of Poverty Experiment on Support for Militant Groups when Controlling for Potential Confounding Interactions 

/// APPENDIX TABLE 1: Descriptive Statistics for Policy Support by Experimental Condition

	summ q800mil_resc if treat_group == 2 | treat_group == 3 | treat_group == 4
	tab q800mil_resc if treat_group == 2 | treat_group == 3 | treat_group == 4, mi
	summ q800e_resc if treat_group == 5
	tab q800e_resc if treat_group == 5, mi
	summ q800a_resc if treat_group == 1
	tab q800a_resc if treat_group == 1, mi
	
	summ q810mil_resc if treat_group == 2 | treat_group == 3 | treat_group == 4
	tab q810mil_resc if treat_group == 2 | treat_group == 3 | treat_group == 4, mi
	summ q810e_resc if treat_group == 5
	tab q810e_resc if treat_group == 5, mi
	summ q810a_resc if treat_group == 1
	tab q810a_resc if treat_group == 1, mi

	summ q820mil_resc if treat_group == 2 | treat_group == 3 | treat_group == 4
	tab q820mil_resc if treat_group == 2 | treat_group == 3 | treat_group == 4, mi
	summ q820e_resc if treat_group == 5
	tab q820e_resc if treat_group == 5, mi
	summ q820a_resc if treat_a == 1
	tab q820a_resc if treat_a == 1, mi

	summ q830mil_resc if treat_group == 2 | treat_group == 3 | treat_group == 4
	tab q830mil_resc if treat_group == 2 | treat_group == 3 | treat_group == 4, mi
	summ q830e_resc if treat_group == 5
	tab q830e_resc if treat_group == 5, mi
	summ q830a_resc if treat_group == 1
	tab q830a_resc if treat_group == 1, mi


/// APPENDIX TABLE 2: Descriptive Statistics for Policy Support by Experimental Condition

// First Panel - Endorsement effects

	local group "militancy b c d e"
	foreach x of local group {
		reg policy_pref_`x' treat_`x', cluster(psu_new)
		reg policy_pref_`x' treat_`x' *_z *_miss, cluster(psu_new)
	}

// Second Panel - Endorsement condition interacted with knowledge index
	
	local group "militancy b c d e"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' knowledge knowledge_treat_`x', cluster(psu_new)
		reg policy_pref_`x' treat_`x' knowledge knowledge_treat_`x' *_z *_miss, cluster(psu_new)	
	}

// Third Panel - Endorsement condition interacted with policy-specific knowledge
	
	local group "militancy b c d e"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' k_scale k_treat_`x', cluster(psu_new)
		reg policy_pref_`x' treat_`x' k_scale k_treat_`x' *_z *_miss, cluster(psu_new)	
	}

// Fourth panel - Endorsement condition interacted with level of education

	local group "militancy b c d e"
	foreach x of local group {
		reg policy_pref_`x' treat_`x' educ_z educ_treat_`x' educ_miss, cluster(psu_new)
		reg policy_pref_`x' treat_`x' educ_z educ_treat_`x' *_z *_miss, cluster(psu_new)	
	}

	
/// APPENDIX TABLE 3: Effects of Observed Poverty on Support for Militant Groups  

// Note: One-tailed test conducted for the prediction that relative poverty will decrease support for militancy.

	foreach x in "militancy" {
		reg policy_pref_`x' lowexp20_urprov highexp20_urprov treat_`x' lowexp20_urprov_`x' highexp20_urprov_`x', cluster(psu_new)
		reg policy_pref_`x' lowexp20_urprov highexp20_urprov treat_`x' lowexp20_urprov_`x' highexp20_urprov_`x' gender_z headh_z age_z read_z math_z educ_z assetindex_z headh_miss age_miss read_miss math_miss educ_miss, cluster(psu_new)
		areg policy_pref_`x' lowexp20_urprov highexp20_urprov treat_`x' lowexp20_urprov_`x' highexp20_urprov_`x', cluster(a7) a(treatprov)
	}


/// APPENDIX TABLE 4: Effects of Experimental Treatments on Support for Militant Groups  

// Note: One-tailed tests conducted for the following predictions: 
// 1. relative poverty will decrease support for militancy// 2. higher perceived levels of violence will decrease support for militancy

// Columns 1-3  

	foreach x in "militancy" {
		reg policy_pref_`x' treat_`x' poverty poverty_treat_`x', level(90) cluster(psu_new)
		reg policy_pref_`x' treat_`x' poverty poverty_treat_`x' *_z *_miss, level(90) cluster(psu_new)
		areg policy_pref_`x' treat_`x' poverty poverty_treat_`x', level(90) cluster(a7) a(treatprov)
	}

// Columns 4-6  

	foreach x in "militancy" {
		reg policy_pref_`x' treat_`x' natviol natviol_treat_`x', level(90) cluster(psu_new)
		reg policy_pref_`x' treat_`x' natviol natviol_treat_`x' *_z *_miss, level(90) cluster(psu_new) 	
		areg policy_pref_`x' treat_`x' natviol natviol_treat_`x', level(90) cluster(a7) a(treatprov)	
	}

// Columns 7-9 

	foreach x in "militancy" {
		reg policy_pref_`x' treat_`x' n01 n10 n11 n01_treat_`x' n10_treat_`x' n11_treat_`x', cluster(psu_new)
		reg policy_pref_`x' treat_`x' n01 n10 n11 n01_treat_`x' n10_treat_`x' n11_treat_`x' *_z *_miss, cluster(psu_new)
		areg policy_pref_`x' treat_`x' n01 n10 n11 n01_treat_`x' n10_treat_`x' n11_treat_`x', cluster(a7) a(treatprov)	
	}


// APPENDIX TABLE 5: Effects of Experimental Treatments by Observed Poverty on Support for Militant Groups

// Note: One-tailed tests conducted for the following predictions: 
// 1. relative poverty will decrease support for militancy// 2. higher perceived levels of violence will decrease support for militancy

	foreach x in "militancy" {
		reg policy_pref_`x' treat_`x' poverty lowexp20_urprov poverty_treat_`x' lowexp20_urprov_`x' lowexp20_urprov_pov lowexp20_urprov_pov_`x', cluster(psu_new)
		reg policy_pref_`x' treat_`x' poverty lowexp20_urprov poverty_treat_`x' lowexp20_urprov_`x' lowexp20_urprov_pov lowexp20_urprov_pov_`x' gender_z headh_z age_z read_z math_z educ_z assetindex_z headh_miss age_miss read_miss math_miss educ_miss, cluster(psu_new)
	}

	foreach x in "militancy" {
		reg policy_pref_`x' treat_`x' natviol lowexp20_urprov natviol_treat_`x' lowexp20_urprov_`x' lowexp20_urprov_viol lowexp20_urprov_viol_`x', cluster(psu_new)
		reg policy_pref_`x' treat_`x' natviol lowexp20_urprov natviol_treat_`x' lowexp20_urprov_`x' lowexp20_urprov_viol lowexp20_urprov_viol_`x' gender_z headh_z age_z read_z math_z educ_z assetindex_z headh_miss age_miss read_miss math_miss educ_miss, cluster(psu_new)
	}


// APPENDIX TABLE 6: Effects of Poverty Experiment on Support for Militant Groups when Controlling for Potential Confounding Interactions

	foreach x in "militancy" {
		reg policy_pref_`x' treat_`x' poverty poverty_treat_`x' educ_z educ_treat_`x' educ_miss, cluster(psu_new) 
		reg policy_pref_`x' treat_`x' poverty poverty_treat_`x' educ_z educ_treat_`x' educ_miss *_z *_miss, cluster(psu_new)
	}

	foreach x in "militancy" {
		reg policy_pref_`x' treat_`x' poverty poverty_treat_`x' read_z read_treat_`x' read_miss, cluster(psu_new) 
		reg policy_pref_`x' treat_`x' poverty poverty_treat_`x' read_z read_treat_`x' read_miss *_z *_miss, cluster(psu_new)
	}
	
	foreach x in "militancy" {
		reg policy_pref_`x' treat_`x' poverty poverty_treat_`x' tv tv_treat_`x', cluster(psu_new) 
		reg policy_pref_`x' treat_`x' poverty poverty_treat_`x' tv tv_treat_`x' *_z *_miss, cluster(psu_new)
	}


*******************************************************
****************** APPENDIX FIGURES *******************
*******************************************************

// Appendix Figure 1: Balance on the Endorsement Experiment

destring psu_new, replace

	foreach var of varlist gender_z headh_z age_z read_z math_z educ_z houseexpend_z assetindex_z { //all variables balanced except education
		clttest `var', by(control_assign) cluster(psu_new)
	}

// Appendix Figure 2: Balance on the Poverty Experiment

	foreach var of varlist gender_z headh_z age_z read_z math_z educ_z houseexpend_z assetindex_z { //all variables balanced
		clttest `var', by(poverty) cluster(psu_new)
	}

// Appendix Figure 3: Balance on the Violence Experiment

	foreach var of varlist gender_z headh_z age_z read_z math_z educ_z houseexpend_z assetindex_z { //all variables balanced
		clttest `var', by(natviol) cluster(psu_new)
	}
	
// Appendix Figure 5: Balance on the Violence Experiment

	tab k_scale
