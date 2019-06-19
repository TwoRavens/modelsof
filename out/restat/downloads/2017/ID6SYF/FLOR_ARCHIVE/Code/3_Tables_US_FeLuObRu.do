/*********************************************************************
*Code written for: In Search of the Armington Elasticity by Feenstra, Luck, Obstefeld and Russ
*Contact: Philip Luck <philip.luck@ucdenver.edu>
*Date: January 2017
******************************************************************
3. This code produces reads in point and bootstrap estimates of micro and macro 
    elasticities and produces main results form the paper.
*********************************************************************/
clear all
clear matrix 
set seed 101010
set more off 
set matsize 11000


*Assign directory where files are stored:
global directory ="/"


*Set Directory 
cd "$directory/FLOR_ARCHIVE/"

*Make sure product function is installed
cap net inst "http://www.stata.com/stb/stb51/dm71.pkg"
cap net install  "http://www.stata-journal.com/software/sj5-4/st0030_2.pkg"

***********************************************************
* Prepare nonbootstrap results
***********************************************************
*Nonbootstrap results  ** UNWEIGHTED OMEGA
use Results/Final_sig_omeg_Unweighted_Unstacked7_2sls.dta, clear
rename sigmasv osigmasv
rename sigmasvse osigmasvse
rename omegasv2 oomegasv
rename omegasvse2 oomegasvse
sort groupcom
merge 1:1 groupcom using finalresult_original_sec_def_sector.dta
keep if _merge ==3 
drop _merge
save finalresult_original_sec_def_sector.dta, replace

*Nonbootstrap results ** WEIGHTED OMEGA
use  Results/Final_sig_omeg_Weighted_Unstacked7_2sls.dta, clear
rename sigmasvw osigmasvw
rename sigmasvwse osigmasvwse
rename omegasv2w oomegasvw
rename omegasvse2w oomegasvwse
sort groupcom
merge 1:1 groupcom using finalresult_original_sec_def_sector.dta
keep if _merge ==3 
drop _merge
save finalresult_original_sec_def_sector.dta, replace

*Nonbootstrap results  ** WEIGHTED STACKED OMEGA
*Looping over final results for all three def of sectors
use Results/Final_sig_omeg_Unweighted_Stacked7_2sls.dta, clear
rename omegasv3 oomegasvS
rename omegasvse3 oomegasvSse
sort groupcom
merge 1:1 groupcom using finalresult_original_sec_def_sector.dta
keep if _merge ==3 
drop _merge
save finalresult_original_sec_def_sector.dta, replace


use Results/Final_sig_omeg_Weighted_Stacked7_2sls.dta, clear
rename omegasv3w oomegasvwS
rename omegasvse3w oomegasvwSse
sort groupcom
merge 1:1 groupcom using finalresult_original_sec_def_sector.dta
keep if _merge ==3 
drop _merge
keep  groupcom sectornew7 osigmasv osigmasvse  osigmasvw osigmasvwse    ///
	oomegasvS oomegasvSse	oomegasvwS oomegasvwSse oomegasvw oomegasvwse oomegasv oomegasvse
		
order groupcom sectornew7 osigmasv osigmasvse  osigmasvw osigmasvwse  ///
		 oomegasvS oomegasvSse oomegasvwS oomegasvwSse oomegasvw oomegasvwse oomegasv oomegasvse
sort groupcom

bysort sectornew7: gen goodnumber=_N
*number of goods with sigma>omega
bysort sectornew7: egen sigma_gt_omegasv=sum(osigmasv > oomegasv)
*number of goods with sigma>omega
bysort sectornew7: egen sigmaw_gt_omegasvw=sum(osigmasvw > oomegasvw)
*number of goods with sigma>omega
bysort sectornew7: egen sigma_gt_omegasvS=sum(osigmasv > oomegasvS)
*number of goods with sigma>omega
bysort sectornew7: egen sigmaw_gt_omegasvwS=sum(osigmasvw > oomegasvwS)
sort groupcom
save finalresult_original_sec_def_sector.dta, replace


use bootdata/boot_sigma_estimation_robust.dta, clear
sort groupcom
merge m:1 groupcom using sector.dta
keep if _merge ==3
drop _merge
sort groupcom bootrep bootnest 
sort sectornew7 bootrep bootnest groupcom
merge m:1 sectornew7 bootrep bootnest using  bootdata/boot_omega_Unweighted_Stacked_sector.dta
drop _merge
sort sectornew7 bootrep bootnest groupcom
rename omegasv3 omegasvS
merge m:1 sectornew7 bootrep bootnest using  bootdata/boot_omega_Weighted_Stacked_sector.dta 
drop _merge
rename omegasv3w omegasvwS
sort groupcom

*Count number of bootnest reps within bootstrap
bysort groupcom bootrep: gen bootnest_N= _N - 1

*For both 2SLS and GMM Construct Beta
gen beta=  sigmasv - omegasvS  
gen betaw= sigmasvw - omegasvwS

*For both 2SLS and GMM Construct Beta for test of 2sigma=omega
gen beta2=  sigmasv - 2*omegasvS  
gen beta2w= sigmasvw - 2*omegasvwS  

***********************************************************************************
*Construct Standard errors both 2SLS and GMM Construct SE of original and bootstraps
***********************************************************************************
*Sigma and Beta, both varying by good:
preserve
	foreach var in   sigmasvw sigmasv  beta betaw  beta2 beta2w  {            
		bysort groupcom bootrep: egen `var'_m = mean(`var') if bootnestrep !=0 & `var' !=.
		bysort groupcom bootrep: egen  `var'_se = sum ((`var'-`var'_m)^2) if bootnestrep !=0  & `var' !=.
		bysort groupcom bootrep: egen  `var'_se_b = max(`var'_se)  
		replace `var'_se_b= (`var'_se_b/(bootnest_N ))^(.5)
		drop  `var'_m `var'_se 
	}

	keep  if bootnestrep ==0
	bysort groupcom : gen boot_N= _N -1
	foreach var in  sigmasvw sigmasv  beta betaw  {                
		*Construct standard error for final estimates from boostrapped estimates:
		bysort groupcom : egen `var'_m = mean(`var') if bootnestrep ==0  & `var' !=.
		bysort groupcom : egen  `var'_se = sum ((`var'-`var'_m)^2) if bootnestrep ==0  & `var' !=.
		*Scale errors by sample size
		replace `var'_se= (`var'_se/(boot_N))^(.5)
	}
	keep  groupcom   sectornew7 bootrep bootnestrep ///
		  sigmasv sigmasvw beta betaw   beta2 beta2w  ///
		  sigmasv_se sigmasvw_se beta_se betaw_se  beta2_se beta2w_se ///
		  sigmasvw_se_b sigmasv_se_b beta_se_b betaw_se_b  beta2_se_b beta2w_se_b 
		
	order bootrep groupcom   sectornew7  ///
		   sigmasv sigmasvw beta betaw   beta2 beta2w  ///
		  sigmasv_se sigmasvw_se beta_se betaw_se  beta2_se beta2w_se ///
		  sigmasvw_se_b sigmasv_se_b beta_se_b betaw_se_b  beta2_se_b beta2w_se_b 
		  
	sort sectornew7 bootrep
	save bootdata/sigma_omega_beta_t_stats.dta   , replace  
restore

keep  sectornew7 bootrep bootnestrep omegasvS omegasvwS
duplicates drop
bysort sectornew7 bootrep : gen bootrep_N= _N - 1
*Estimate Standard Errors for Omega:
	foreach var in   omegasvS omegasvwS    {            
	bysort sectornew7 bootrep: egen `var'_m = mean(`var') if bootnestrep !=0
	bysort sectornew7 bootrep: egen  `var'_se = sum ((`var'-`var'_m)^2) if bootnestrep !=0
	bysort sectornew7 bootrep: egen  `var'_se_b = max(`var'_se)
	replace `var'_se_b= (`var'_se_b/(bootrep_N ))^(.5)
	drop  `var'_m `var'_se 
}

keep  if bootnestrep ==0
bysort  sectornew7 : gen boot_N= _N - 1
foreach var in   omegasvS omegasvwS  {                
	*Construct standard error for final estimates from boostrapped estimates:
	bysort  sectornew7 : egen `var'_m = mean(`var') if bootnestrep ==0
	bysort sectornew7 : egen  `var'_se = sum ((`var'-`var'_m)^2) if bootnestrep ==0
	*Scale errors by sample size
	replace `var'_se= (`var'_se/(boot_N))^(.5)
}
sort  sectornew7 bootrep
merge 1:m sectornew7 bootrep using bootdata/sigma_omega_beta_t_stats.dta
keep if _merge ==3

keep groupcom sectornew7 bootrep bootnestrep ///
		omegasvS omegasvwS  sigmasv sigmasvw beta betaw ///
		sigmasvw_se_b sigmasv_se_b beta_se_b betaw_se_b ///
		sigmasv_se sigmasvw_se beta_se betaw_se ///
		omegasvS_se_b omegasvwS_se_b omegasvS_se omegasvwS_se ///
		beta2 beta2w  beta2_se beta2w_se betaw_se_b  beta2_se_b beta2w_se_b ///	
save bootdata/sigma_omega_beta_t_stats.dta, replace
 
 
*Combine Bootstrap beta estimates and standard erros with final results:
use bootdata/sigma_omega_beta_t_stats.dta, replace
sort groupcom bootrep 
merge m:1 groupcom using finalresult_original_sec_def_sector.dta
keep if _merge ==3
drop _merge

*Create t-stats for Final results and bootstrapped data:
gen obeta=osigmasv - oomegasvS
gen obetaw=osigmasvw - oomegasvwS
gen obeta2=osigmasv - 2*oomegasvS
gen obeta2w=osigmasvw - 2*oomegasvwS

*Generate Final result t-stats with main estimates and standard error estimates for boostrap
foreach var in sigmasvw sigmasv  omegasvS  omegasvwS beta betaw beta2 beta2w {
	gen t_`var' = o`var'/`var'_se
}


*Check for Systemic Bias by comparing Median acros bootstraps to true estimates for each estimate:
foreach var in sigmasvw sigmasv  beta betaw   beta2 beta2w{
	bysort groupcom: egen m_`var' = mean(`var')
	gen bias_`var' = m_`var'-o`var'
}

foreach var in  omegasvS omegasvwS {
	bysort sectornew7: egen m_`var' = mean(`var')
	gen bias_`var' = m_`var'-o`var'
}

*t-stats for each bootstrap
foreach var in sigmasvw sigmasv   beta betaw  beta2 beta2w omegasvS omegasvwS {
	gen t_`var'_b = (`var' -  m_`var') / `var'_se_b
}

*Following MacKinnon One-sided test of Sigma<Omega
*Create P-value For Onesided test sigma>omega
cap drop boot_N
bysort  groupcom : gen boot_N= _N 
gen pval = 0 
gen pvalw = 0 
replace pval =1 if t_beta_b>t_beta
replace pvalw =1 if t_betaw_b>t_betaw
bysort groupcom : egen  pval_t = sum (pval)
bysort groupcom : egen  pvalw_t = sum (pvalw)
replace pval =pval_t/boot_N 
replace pvalw =pvalw_t/boot_N
drop pvalw_t pval_t
*Following MacKinnon Do not assume symmetric around zero: Rule of Two 
* This is a two-sided test
gen pval1 = 0 
gen pval1w = 0 
gen pval2 = 0 
gen pval2w = 0 
replace pval1 =1 if t_beta2_b>t_beta2
replace pval1w =1 if t_beta2w_b>t_beta2w
replace pval2 =1 if t_beta2_b<t_beta2
replace pval2w =1 if t_beta2w_b<t_beta2w

bysort groupcom : egen  pval1_t = sum (pval1)
bysort groupcom : egen  pval1w_t = sum (pval1w)
bysort groupcom : egen  pval2_t = sum (pval2)
bysort groupcom : egen  pval2w_t = sum (pval2w)

replace pval1 =pval1_t/boot_N 
replace pval1w =pval1w_t/boot_N
replace pval2 =pval2_t/boot_N 
replace pval2w =pval2w_t/boot_N

gen pval_rot =  pval1 
replace pval_rot = pval2 if pval2<pval1
replace pval_rot = 2*pval
gen pvalw_rot =  pval1w 
replace pvalw_rot = pval2w if pval2w<pval1w
replace pvalw_rot = 2*pvalw
sum pval_rot pvalw_rot  , d

drop pval1 pval1w pval2 pval2w pval1_t pval1w_t pval2_t pval2w_t

sort sectornew7
save Results/pvalues_temp.dta, replace

*Create t-value confidence intervals for sigma
use Results/pvalues_temp.dta, clear
sort groupcom
*pick out the bootstrap estimates of sigma and its confidence intervals
local sigmalist "groupcom sectornew7 t_sigmasv_b t_sigmasv_b_CIlow t_sigmasv_b_CIup  t_sigmasvw_b t_sigmasvw_b_CIlow t_sigmasvw_b_CIup"
postfile boot_sigma_t `sigmalist' using boot_sigma_t_estimation, replace
egen loopind=group(groupcom)
sum loopind
local indnum = r(max)

forvalues i=1/`indnum' {
	preserve 
		keep if loopind==`i'
		_pctile t_sigmasv_b, percentiles(2.5 97.5)
		scalar  t_sigmasv_b_CIlow = r(r1)
		scalar  t_sigmasv_b_CIup = r(r2)

		_pctile t_sigmasvw_b, percentiles(2.5 97.5)
		scalar  t_sigmasvw_b_CIlow = r(r1)
		scalar  t_sigmasvw_b_CIup = r(r2)
		
	post boot_sigma_t   (groupcom) (sectornew7) (t_sigmasv_b) (t_sigmasv_b_CIlow) (t_sigmasv_b_CIup)  ///
									  (t_sigmasvw_b) (t_sigmasvw_b_CIlow) (t_sigmasvw_b_CIup) 
	restore
}

postclose boot_sigma_t
	use boot_sigma_t_estimation.dta, clear
	sort groupcom
	save, replace
	
*Create t-value confidence intervals for omega
use Results/pvalues_temp.dta, clear
keep t_omegasvS_b t_omegasvwS_b  sectornew7 bootrep 
duplicates drop
local omegalist "sectornew7 t_omegasv_b t_omegasv_b_CIlow t_omegasv_b_CIup  t_omegasvwS_b t_omegasvwS_b_CIlow t_omegasvwS_b_CIup"
postfile boot_omega_t `omegalist' using boot_omega_t_estimation, replace
egen loopind=group(sectornew7)
sum loopind
local indnum = r(max)

forvalues i=1/`indnum' {
	preserve 

		keep if loopind==`i'
		_pctile t_omegasvS_b, percentiles(2.5 97.5)
		scalar t_omegasvS_b_CIlow = r(r1)
		scalar t_omegasvS_b_CIup = r(r2)

		_pctile t_omegasvwS_b, percentiles(2.5 97.5)
		scalar t_omegasvwS_b_CIlow = r(r1)
		scalar t_omegasvwS_b_CIup = r(r2)

		post boot_omega_t    (sectornew7) (t_omegasvS_b) (t_omegasvS_b_CIlow) (t_omegasvS_b_CIup)  ///
									  (t_omegasvwS_b) (t_omegasvwS_b_CIlow) (t_omegasvwS_b_CIup)  
	restore
}

postclose boot_omega_t
	use boot_omega_t_estimation.dta, clear
	sort sectornew7
	save, replace

*Combine Results:
use Results/pvalues_temp.dta, clear
sort groupcom
merge m:1 groupcom using boot_sigma_t_estimation.dta
drop _merge
sort sectornew7 groupcom
merge m:1  sectornew7 using  boot_omega_t_estimation.dta
drop _merge
keep if  sigmasv_se !=.
keep if  sigmasvw_se !=.

		
duplicates drop

foreach var in sigmasv sigmasvw   omegasvS omegasvwS {
*Construct standard error for final estimates from boostrapped estimates:
gen `var'_up  = o`var' + t_`var'_b_CIup*`var'_se
gen `var'_low = o`var' + t_`var'_b_CIlow*`var'_se

}
keep    sigmasv_low osigmasv  sigmasv_up    sigmasvw_low  osigmasvw  sigmasvw_up ///
		pval  pvalw pval_rot pvalw_rot ///
		sigma_gt_omegasv sigmaw_gt_omegasvw sigma_gt_omegasvS sigmaw_gt_omegasvwS goodnumber ///
		oomegasvwS oomegasvS   omegasvS_se omegasvwS_se ///
		omegasvS_up omegasvS_low omegasvwS_up omegasvwS_low    sectornew7  groupcom
		
duplicates drop

**************************
* Sigma Estimates and CI:
**************************
preserve 
	keep sigmasv_low osigmasv  sigmasv_up    sigmasvw_low  osigmasvw  sigmasvw_up ///
	order  sigmasv_low osigmasv  sigmasv_up    sigmasvw_low  osigmasvw  sigmasvw_up ///
	duplicates drop
	save Results/table_2_sigma_estimates, replace
restore

*Sigma Graphs 
twoway  (kdensity osigmasvw, clpattern(solid) range(-10 40) bwidth(1.1) ) ///
		(kdensity sigmasvw_low, clpattern(dash) range(-10 40) bwidth(1.1)) ///
		(kdensity sigmasvw_up, clpattern(dot) range(-10 40) bwidth(1.1)), ///
		 ytitle(Density) xtitle(Sigma) xlabel(-10(2)40) xscale(range(-10 40)) ///
		 legend(label(1 "Sigma") label(2 "C.I. Lower 95%") label(3 "C.I. Upper 95%")) legend(cols(1) ring(0) position(2))
graph export Results/sigma_est_wCI_boot.eps, replace
graph export Results/sigma_est_wCI_boot.png, replace

*Sigma Graphs 
twoway  (kdensity osigmasv, clpattern(solid) range(-10 40) bwidth(1.1) ) ///
		(kdensity sigmasv_low, clpattern(dash) range(-10 40) bwidth(1.1)) ///
		(kdensity sigmasv_up, clpattern(dot) range(-10 40) bwidth(1.1)), ///
		 ytitle(Density) xtitle(Sigma) xlabel(-10(2)40) xscale(range(-10 40)) ///
		 legend(label(1 "Sigma") label(2 "C.I. Lower 95%") label(3 "C.I. Upper 95%")) legend(cols(1) ring(0) position(2))
graph export Results/sigma_est_CI_boot.eps, replace
graph export Results/sigma_est_CI_boot.png, replace
		 
*Graph pvalues: Sigma < Omega
spikeplot pval  /// 
, round(.01)  xline(.055 ) title (TSLS) ytitle(Good Count) xtitle(P value)  legend(label(1 "TSLS") )  ylabel(0(5)30) yscale(range(0 12)) legend(cols(1) ring(0) position(2))
graph export Results/beta_pvalue_boot_spikeplot.eps, replace
graph export Results/beta_pvalue_boot_spikeplot.png, replace

twoway (hist pval , bin(20) xline(.05) )  /// 
, title (TSLS) ytitle(Density) xtitle(P value)  legend(label(1 "TSLS") ) yscale(range(0 12)) ylabel(0(2)12) legend(cols(1) ring(0) position(2))
graph export Results/beta_pvalue_boot_hist.eps, replace
graph export Results/beta_pvalue_boot_hist.png, replace

spikeplot pvalw  /// 
, round(.01)  xline(.055 ) title (GMM) ytitle(Good Count) xtitle(P value)  legend(label(1 "GMM") ) yscale(range(0 12)) legend(cols(1) ring(0) position(2))
graph export Results/beta_pvaluew_boot_spikeplot.eps, replace
graph export Results/beta_pvaluew_boot_spikeplot.png, replace

twoway (hist pvalw , bin(20) xline(.05) ) /// 
, title (GMM) ytitle(Density) xtitle(P value)  legend(label(1 "GMM") ) yscale(range(0 12)) ylabel(0(2)12) legend(cols(1) ring(0) position(2))
graph export Results/beta_pvaluew_boot_hist.eps, replace
graph export Results/beta_pvaluew_boot_hist.png, replace

*Graph pvalues: Rule of Two
spikeplot pval_rot  /// 
, round(.01)  xline(.055 ) title (TSLS) ytitle(Good Count) xtitle(P value)  legend(label(1 "TSLS") )  ylabel(0(5)30) yscale(range(0 12)) legend(cols(1) ring(0) position(2))
graph export Results/beta_pvalue_rot_boot_spikeplot.eps, replace
graph export Results/beta_pvalue_rot_boot_spikeplot.png, replace

twoway (hist pval_rot , bin(20) xline(.05) )  /// 
, title (TSLS) ytitle(Density) xtitle(P value)  legend(label(1 "TSLS") ) yscale(range(0 12)) ylabel(0(2)12) legend(cols(1) ring(0) position(2))
graph export Results/beta_pvalue_rot_boot_hist.eps, replace
graph export Results/beta_pvalue_rot_boot_hist.png, replace

spikeplot pvalw_rot  /// 
, round(.01)  xline(.055 ) title (GMM) ytitle(Good Count) xtitle(P value)  legend(label(1 "GMM") ) yscale(range(0 12)) legend(cols(1) ring(0) position(2))
graph export Results/beta_pvaluew_rot_boot_spikeplot.eps, replace
graph export Results/beta_pvaluew_rot_boot_spikeplot.png, replace

twoway (hist pvalw_rot , bin(20) xline(.05) ) /// 
, title (GMM) ytitle(Density) xtitle(P value)  legend(label(1 "GMM") ) yscale(range(0 12)) ylabel(0(2)12) legend(cols(1) ring(0) position(2))
graph export Results/beta_pvaluew_rot_boot_hist.eps, replace
graph export Results/beta_pvaluew_rot_boot_hist.png, replace

*Test of Sigma<Omega
gen tsls_count =0
replace tsls_count = 1 if .05>=pval
gen gmm_count =0
replace gmm_count = 1 if .05>=pvalw

*Rule of Two   pval_rot pvalw_rot
gen tsls_count_rot =0
replace tsls_count_rot = 1 if .05>=pval_rot
gen gmm_count_rot =0
replace gmm_count_rot = 1 if .05>=pvalw_rot

gen test =0
replace test =1 if osigmasv > oomegasvS
gen testw =0
replace testw =1 if osigmasvw > oomegasvwS

collapse (mean) sigma_gt_omegasv sigmaw_gt_omegasvw sigma_gt_omegasvS sigmaw_gt_omegasvwS goodnumber ///
				oomegasvwS oomegasvS   omegasvS_se omegasvwS_se ///
				omegasvS_up omegasvS_low omegasvwS_up omegasvwS_low   (median) osigmasv osigmasvw  ///
				(sum) tsls_count gmm_count test testw tsls_count_rot gmm_count_rot, by( sectornew7 )

*Table4: Tests of Sigma and Omega:
keep sectornew7   sectornew7   goodnumber osigmasv  oomegasvS omegasvS_low   omegasvS_up  sigma_gt_omegasvS  tsls_count tsls_count_rot osigmasvw   oomegasvwS   omegasvwS_low    omegasvwS_up sigmaw_gt_omegasvwS  gmm_count gmm_count_rot 
order sectornew7   sectornew7   goodnumber osigmasv  oomegasvS omegasvS_low   omegasvS_up  sigma_gt_omegasvS  tsls_count tsls_count_rot osigmasvw   oomegasvwS   omegasvwS_low    omegasvwS_up sigmaw_gt_omegasvwS  gmm_count gmm_count_rot 
save Results/table_4_pvalues.dta, replace

*Table3: Confidence Intervals for Sigma Omega:
use Results/table_4_pvalues.dta, clear
keep  sectornew7    goodnumber oomegasvS  omegasvS_low  omegasvS_up oomegasvwS  omegasvwS_low omegasvwS_up 
order sectornew7   goodnumber oomegasvS  omegasvS_low  omegasvS_up oomegasvwS  omegasvwS_low omegasvwS_up
save Results/table_3_omega_estimates.dta, replace


*Table 5: Welfare calculation:
***************************************************************************
* Gains from Trade 
***************************************************************************
local n =1
forvalues zeta = 1.1(.5)2.1 {
*Load data with merged shares
use finalresult_original_sec_def_sector, clear
merge 1:1 groupcom using expenditure_shares_weights.dta
	gen oepsilon = (`zeta'*(osigmasvw-1)*(oomegasvwS-1))/((osigmasvw-1+(`zeta'-1)*(osigmasvw-oomegasvwS)))
	gen ogamma = `zeta'*(osigmasvw-1)
	sort groupcom
	sum oepsilon,d
	keep if oepsilon > 0
	*compute gains from trade using (1) True trade elasticity epsilon 
	gen otr= (s_jj)^ (exp*(-1/oepsilon))
	gen onv= (s_jj)^ (exp*(-1/ogamma))
	foreach var in  otr onv  {
		egen gains_`var' = sum(ln(`var'))
		replace gains_`var' = exp(gains_`var')
	}
	cap drop _merge
	sum gains_otr gains_onv
	save finalresult_original_sec_def_sector_Shippments_epsilon, replace

	******************************
	*Merg with BS estimates:
	*****************************************

	*Generate bootstrapped gains estimates
	use bootdata/boot_sigma_estimation_robust.dta, clear
	sort groupcom
	merge m:1 groupcom using sector.dta
	keep if _merge ==3
	drop _merge
	sort sectornew7 bootrep bootnest groupcom
	merge m:1 sectornew7 bootrep bootnest using  bootdata/boot_omega_Unweighted_Stacked_sector.dta
	drop _merge
	sort sectornew7 bootrep bootnest groupcom
	rename omegasv3 omegasvS
	merge m:1 sectornew7 bootrep bootnest using  bootdata/boot_omega_Weighted_Stacked_sector.dta 
	drop _merge
	rename omegasv3w omegasvwS
	sort groupcom
	*merge bootstrap result with the original sample results
	sort groupcom
	merge m:1 groupcom using finalresult_original_sec_def_sector_Shippments_epsilon.dta
	drop if _merge==1

	******************************
	*generate bootstrapped epsilon and gamma estimates
	gen epsilon = (`zeta'*(sigmasvw-1)*(omegasvwS-1))/((sigmasvw-1+(`zeta'-1)*(sigmasvw-omegasvwS)))
	gen gamma = `zeta'*(sigmasvw-1)
	keep if epsilon >0

	gen tr= (s_jj)^ (exp*(-1/epsilon))
	gen nv= (s_jj)^ (exp*(-1/gamma))
	foreach var in  tr nv  {
		bysort bootrep bootnestrep: egen gains_`var' = sum(ln(`var'))
		bysort bootrep bootnestrep: replace gains_`var' = exp(gains_`var')
	}
	
	bysort gains_onv bootrep bootnestrep : gen num_goods = _N
	sum num_goods
	replace num_goods=r(max)	
	
	keep  gains_tr gains_nv gains_otr gains_onv bootrep bootnestrep num_goods
	duplicates drop
	sum gains_otr gains_onv gains_tr gains_nv, d

	
	*Count number of bootnest reps within bootstrap
	bysort bootrep: gen bootnest_N= _N - 1
	*For both 2SLS and GMM Construct SE of original and bootstraps
	foreach var in gains_tr gains_nv  {
	bysort bootrep: egen `var'_m = mean(`var') if bootnestrep !=0
	bysort bootrep: egen  `var'_se = sum ((`var'-`var'_m)^2) if bootnestrep !=0
	bysort bootrep: egen  `var'_se_b = max(`var'_se)
	replace `var'_se_b= (`var'_se_b/(bootnest_N ))^(.5)
	drop  `var'_m `var'_se 
	}

	keep  if bootnestrep ==0
	gen boot_N= _N -1
	foreach var in gains_tr gains_nv  {
	*Construct standard error for final estimates from boostrapped estimates:
	egen `var'_m = mean(`var') if bootnestrep ==0
	egen  `var'_se = sum ((`var'-`var'_m)^2) if bootnestrep ==0
	*Scale errors by sample size
	replace `var'_se= (`var'_se/(boot_N))^(.5)
	egen `var'_md = median(`var') 
	}
	
	*Generate t-stats for main estimates
	gen t_gains_otr = gains_otr/gains_tr_se
	gen t_gains_onv = gains_onv/gains_nv_se

	*Generate t-stats for each bootstrap
	gen t_gains_tr_b = (gains_tr - gains_otr) / gains_tr_se_b
	gen t_gains_nv_b = (gains_nv - gains_onv) / gains_tr_se_b
	
	_pctile t_gains_tr_b, percentiles(2.5  50  97.5)
	gen t_gains_tr_b_low = r(r1)
	gen t_gains_tr_b_med = r(r2)
	gen t_gains_tr_b_up  = r(r3)

	_pctile t_gains_nv_b, percentiles(2.5  50  97.5)
	gen t_gains_nv_b_low = r(r1)
	gen t_gains_nv_b_med = r(r2)
	gen t_gains_nv_b_up  = r(r3)
	
*Following MacKinnon Do not assume symmetric around zero: 
* This is a two-sided test: grains_tr>gains_nv	
gen pval1 = 0  
gen pval1n = 0 
gen pval2 = 0 
gen pval2n = 0 
replace pval1 =1    if t_gains_tr_b>t_gains_otr
replace pval1n =1  if t_gains_nv_b>t_gains_onv
replace pval2 =1    if t_gains_tr_b<t_gains_otr
replace pval2n =1  if t_gains_nv_b<t_gains_onv

egen  pval1_t = sum (pval1)
egen  pval1nv_t = sum (pval1n)
egen  pval2_t = sum (pval2)
egen  pval2nv_t = sum (pval2n)

replace pval1 =pval1_t/boot_N 
replace pval1nv =pval1nv_t/boot_N
replace pval2 =pval2_t/boot_N 
replace pval2nv =pval2nv_t/boot_N

gen pval_tr =  pval1 
replace pval_tr = pval2 if pval2<pval1
replace pval_tr = 2*pval_tr
gen pval_nv =  pval1nv 
replace pval_nv = pval2nv if pval2nv<pval1nv
replace pval_nv = 2*pval_nv
sum  pval_tr pval_nv , d	
	
*Construct standard error for final estimates from boostrapped estimates:
gen gains_tr_up = gains_otr + t_gains_tr_b_up*gains_tr_se
gen gains_tr_low = gains_otr + t_gains_tr_b_low*gains_tr_se

gen gains_nv_up = gains_onv + t_gains_nv_b_up*gains_nv_se
gen gains_nv_low = gains_onv + t_gains_nv_b_low*gains_nv_se
	
keep  gains_nv_low  gains_onv   gains_nv_up   gains_tr_low  gains_otr  gains_tr_up  pval_tr pval_nv   num_goods 
duplicates drop
gen zeta = `zeta'
order zeta  num_goods  gains_nv_low  gains_onv   gains_nv_up   pval_nv  gains_tr_low  gains_otr  gains_tr_up pval_tr 
save temp_gains_`n'.dta, replace
local n = `n'+1
}	


use temp_gains_1.dta, clear
forvalues n = 2/3 {
	 append using temp_gains_`n'.dta
	 }
	 
save "Results/Gains.dta", replace



	
	
	
