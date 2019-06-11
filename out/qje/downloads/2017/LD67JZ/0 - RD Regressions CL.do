************************************************************************
* This File Loops over all Experiments, and runs an RD for each
************************************************************************

set more off
clear all
set maxvar 11000
set matsize 11000

*************************
* Where data lies
*************************

cap cd ""
adopath ++ "Do"

*********************
* PREPARE DATASET
*********************

use "Data`c(dirsep)'Experiment_dataset_CL_AttrRec.dta", clear

tab  fico_index_1
sum  disc_group

* Display all variables in dataset.
ds, varwidth(32)

* EXPERIMENT GROUP
cap  drop disc_group
egen disc_group = group(bank lc_1st producttype fico_disc zero_initial_apr orig_yrmon_1st)
sum  disc_group

tab fico_disc

****************************************************************************************
* Scale the DPD and MOP variables so that the optimal bandwidth calculation can work
****************************************************************************************

ds *dpd*
foreach f of varlist `r(varlist)' {
	cap replace `f' = 100* `f'
}

ds mop*
foreach f of varlist `r(varlist)' {
	cap replace `f' = 100* `f'
}

************************************************************************************************************************************************************
************************************************************************************************************************************************************
* Construct new control variables that allow us to control also for other experiments within the same orig-group
************************************************************************************************************************************************************
************************************************************************************************************************************************************

levelsof fico_disc, local(fico_disc_group)

foreach disc_new of local fico_disc_group {

	cap drop is_disc
	cap drop has_disc

	gen    is_disc = (fico_disc == `disc_new')
	bysort orig_group: egen has_disc = max(is_disc)
	
	gen     x_`disc_new' = 0
	replace x_`disc_new' = 1 if fico_bucket >= `disc_new' & has_disc == 1 & is_disc == 0
}

* Now produce a list of other covariates
ds    x_*
local covarlist `r(varlist)'

****************************************************************************************
****************************************************************************************
* Now loop over variables
****************************************************************************************
****************************************************************************************
	 
local lhs_variables totpurchvol_pstorig1_mean  totpurchvol_pstorig2_mean  totpurchvol_pstorig3_mean  totpurchvol_pstorig6_mean totpurchvol_pstorig9_mean totpurchvol_pstorig12_mean totpurchvol_pstorig18_mean totpurchvol_pstorig24_mean totpurchvol_pstorig36_mean  totpurchvol_pstorig48_mean totpurchvol_pstorig60_mean totpurchvol_pstorig72_mean ///
					totchgoffamt_pstorig6_mean totchgoffamt_pstorig9_mean totchgoffamt_pstorig12_mean totchgoffamt_pstorig18_mean totchgoffamt_pstorig24_mean totchgoffamt_pstorig36_mean  totchgoffamt_pstorig48_mean totchgoffamt_pstorig60_mean totchgoffamt_pstorig72_mean ///
					totavgdbal_postorig1_mean  totavgdbal_postorig2_mean  totavgdbal_postorig3_mean  totavgdbal_postorig6_mean totavgdbal_postorig9_mean totavgdbal_postorig12_mean totavgdbal_postorig18_mean totavgdbal_postorig24_mean totavgdbal_postorig36_mean  totavgdbal_postorig48_mean totavgdbal_postorig60_mean totavgdbal_postorig72_mean ///					
					totfinchg_postorig1_mean   totfinchg_postorig2_mean  totfinchg_postorig3_mean  totfinchg_postorig6_mean totfinchg_postorig9_mean totfinchg_postorig12_mean totfinchg_postorig18_mean totfinchg_postorig24_mean totfinchg_postorig36_mean  totfinchg_postorig48_mean totfinchg_postorig60_mean totfinchg_postorig72_mean ///
					totfees_postorig1_mean     totfees_postorig2_mean totfees_postorig3_mean totfees_postorig6_mean totfees_postorig9_mean totfees_postorig12_mean totfees_postorig18_mean totfees_postorig24_mean totfees_postorig36_mean  totfees_postorig48_mean totfees_postorig60_mean totfees_postorig72_mean ///
					totfloat_postorig1_mean    totfloat_postorig2_mean totfloat_postorig3_mean totfloat_postorig6_mean totfloat_postorig9_mean totfloat_postorig12_mean totfloat_postorig18_mean totfloat_postorig24_mean totfloat_postorig36_mean totfloat_postorig48_mean totfloat_postorig60_mean totfloat_postorig72_mean ///
					income_postorig12          income_postorig24    income_postorig36    income_postorig48    income_postorig60    income_postorig72 ///
					cost_postorig12            cost_postorig24      cost_postorig36      cost_postorig48      cost_postorig60      cost_postorig72 ///
					cost_postorig12_f          cost_postorig24_f    cost_postorig36_f    cost_postorig48_f    cost_postorig60_f    cost_postorig72_f ///
					netincome_postorig12 netincome_postorig24 netincome_postorig36 netincome_postorig48 netincome_postorig60 netincome_postorig72 ///
					netincome_postorig12_f netincome_postorig24_f netincome_postorig36_f netincome_postorig48_f netincome_postorig60_f netincome_postorig72_f ///
				    currcredlimit_f1_mean  currcredlimit_f2_mean  currcredlimit_f3_mean  currcredlimit_f6_mean  currcredlimit_f9_mean  currcredlimit_f12_mean  currcredlimit_f18_mean  currcredlimit_f24_mean  currcredlimit_f36_mean   currcredlimit_f48_mean  currcredlimit_f60_mean  currcredlimit_f72_mean ///
				    avgdailybal_f1_mean    avgdailybal_f2_mean    avgdailybal_f3_mean    avgdailybal_f6_mean    avgdailybal_f9_mean    avgdailybal_f12_mean    avgdailybal_f18_mean    avgdailybal_f24_mean    avgdailybal_f36_mean 	avgdailybal_f48_mean    avgdailybal_f60_mean    avgdailybal_f72_mean ///
					bc01_f1_mean bc01_f2_mean bc01_f3_mean bc01_f4_mean bc01_f5_mean bc01_f6_mean bc01_f8_mean bc01_f12_mean bc01_f16_mean bc01_f20_mean bc01_f24_mean ///
					bcbal_f1_mean bcbal_f2_mean bcbal_f3_mean bcbal_f4_mean bcbal_f5_mean bcbal_f6_mean bcbal_f8_mean bcbal_f12_mean bcbal_f16_mean bcbal_f20_mean bcbal_f24_mean ///
					bccl_f1_mean bccl_f2_mean bccl_f3_mean bccl_f4_mean bccl_f5_mean bccl_f6_mean bccl_f8_mean bccl_f12_mean  bccl_f16_mean bccl_f20_mean bccl_f24_mean credit_limit ///
				    everdpd30p_postorig1_mean everdpd30p_postorig2_mean everdpd30p_postorig3_mean everdpd30p_postorig6_mean everdpd30p_postorig9_mean everdpd30p_postorig12_mean everdpd30p_postorig18_mean everdpd30p_postorig24_mean everdpd30p_postorig36_mean everdpd30p_postorig48_mean everdpd30p_postorig60_mean everdpd30p_postorig72_mean ///					
				    everdpd60p_postorig1_mean everdpd60p_postorig2_mean everdpd60p_postorig3_mean everdpd60p_postorig6_mean everdpd60p_postorig9_mean everdpd60p_postorig12_mean everdpd60p_postorig18_mean everdpd60p_postorig24_mean everdpd60p_postorig36_mean everdpd60p_postorig48_mean everdpd60p_postorig60_mean everdpd60p_postorig72_mean ///
					everdpd90p_postorig1_mean everdpd90p_postorig2_mean everdpd90p_postorig3_mean everdpd90p_postorig6_mean everdpd90p_postorig9_mean everdpd90p_postorig12_mean everdpd90p_postorig18_mean everdpd90p_postorig24_mean everdpd90p_postorig36_mean everdpd90p_postorig48_mean everdpd90p_postorig60_mean everdpd90p_postorig72_mean ///					
					rate_var months_to_rate_change ///
					ageoldst_mean ageyngst_mean at01_mean at05_mean at07_mean bc01_mean bc05_mean bc34_mean bcbal_mean bccl_mean bcnew_mean bcnewbal_mean bcnewcl_mean behavioralscore_mean borrowerincome_rcd_mean ///
					g001_mean g002_mean g003_mean g004_mean g041_mean g042_mean g043_mean g044_mean mop02_mean mop03_mean mop04_mean mop05_mean mop07_mean mop08_mean mop09_mean mop3_5_mean mop4_5_mean ///
					fico_f1_mean fico_f2_mean fico_f3_mean fico_f6_mean fico_f9_mean fico_f12_mean fico_f18_mean fico_f24_mean fico_f36_mean fico_f48_mean fico_f60_mean fico_f72_mean ///
					_freq_ 
					
cap rm "Data`c(dirsep)'RD_Estimates_CL_Loop.dta"

* Generate Dataset of all Variables currently in there, to drop later
ds
local varlist_drop = "`r(varlist)'"

**********************************
* Loop through all experiments 
**********************************

levelsof disc_group, local(disc_group_list)

foreach disc of local disc_group_list {

	display "EXPERIMENT LOOP = `disc'"
	
	preserve
			
	cap keep if disc_group == `disc'

	cap gen exp_n = `disc'
				
	cap sum fico_index
	cap mat gen r_N      = `r(N)'
	cap mat gen fico_min = `r(min)'
	cap mat gen fico_max = `r(max)'

	* Average of CL (varying width around cutoff)		
	cap sum credit_limit if fico_index == 0 | fico_index == -1
	cap gen cl = `r(mean)'
			
	cap sum credit_limit if fico_index == 0 | fico_index == -1 | fico_index == 1 | fico_index == -2
	cap gen cl2 = `r(mean)'
			
	cap sum credit_limit
	cap gen cl3 = `r(mean)'
			
	* Characteristics of the experiment
	cap sum orig_yrmon_1st 
	cap gen date = `r(mean)'

	cap sum bank
	cap gen bank1 = `r(mean)'
			
	cap sum lc_1st
	cap gen lc = `r(mean)'
			
	cap sum producttype
	cap gen prod = `r(mean)'
			
	cap sum zero_initial_apr
	cap gen zero_intro = `r(mean)'

	cap sum fico_bucket if fico_index == 0
	cap gen fico1 = `r(mean)'

	cap sum _freq_
	cap gen freq1 = `r(mean)'

	****************************
	** Show Credit limit effect 
	****************************
			
	* With Covariates
	cap rdob credit_limit fico_index_1 `covarlist'

	cap local beta = rd_result[1,1]        
	cap local se   = rd_se[1,1]  		

	cap gen b_cl_cv  = `beta'
	cap gen se_cl_cv = `se'
			
	* Without Covariates
	cap rdob credit_limit fico_index_1 

	cap local beta = rd_result[1,1]        
	cap local se   = rd_se[1,1]  		

	cap gen b_cl  = `beta'
	cap gen se_cl = `se'

	foreach lhs of varlist `lhs_variables' {
			
		* Average of LHS variable (varying width around cutoff)
		cap sum `lhs' if fico_index == 0 | fico_index == -1
		cap gen avg1_`lhs' = `r(mean)'
				
		cap sum `lhs' if fico_index == 0 | fico_index == -1 | fico_index == 1 | fico_index == -2
		cap gen avg2_`lhs' = `r(mean)'
				
		cap sum `lhs' 
		cap gen avg3_`lhs' = `r(mean)'
			
		**************************************
		* RD Regressions - Define Matrices
		**************************************

		cap sum `lhs'
		
		if `r(N)' != 0 {
							
			* WITH COVARIATES
			cap rdob `lhs' fico_index_1 `covarlist', fuzzy(credit_limit) c(0)

			cap local beta2 = rd_result[1,1]        
			cap local se2   = rd_se[1,1]  		
				
			cap gen b_cv_`lhs'  = `beta2'
			cap gen se_cv_`lhs' = `se2'
						
				
			* WITHOUT COVARIATES
			cap rdob `lhs' fico_index_1, fuzzy(credit_limit) c(0)

			cap local beta2 = rd_result[1,1]        
			cap local se2   = rd_se[1,1]  		
			
			cap gen b_`lhs'  = `beta2'
			cap gen se_`lhs' = `se2'
			
		}
		
	}

	drop `varlist_drop'
	duplicates drop
	
	cap append using "Data`c(dirsep)'RD_Estimates_CL_Loop"
	cap save "Data`c(dirsep)'RD_Estimates_CL_Loop", replace

	restore
}
