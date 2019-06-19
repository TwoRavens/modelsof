/*********************************************************************
*Code written for: In Search of the Armington Elasticity by Feenstra, Luck, Obstefeld and Russ
*Contact: Philip Luck <philip.luck@ucdenver.edu>
*Date: January 2017
******************************************************************
2. This code provides bootstrap estimates for parameters to be estimated. In order to conduct a pivotal test comparing s
	the micro and macro elasticities we conduct a nested bootstrap. First resampling the main dataset B=500 times then resampling 
	each bootstrap dataset b an additional M=100 times. This allows us to estimate B bootstrapped estimates of the standard error of 
	both sigma and omega to be used in out tests. As with our point estimates, the code proceeds as follows:
	2.1 Implements Feenstra (1994)'s method to estimate the elasticity of substitution among imports
		The estimate of sigma using both 2sls and 2-step GMM
	2.2. Second, using nonlinear estimation to estimate the elasticity of substitution between foreign goods and home goods
	2.3. Third, using "stacked" nonlinear estimation to estimate the elasticity of substitution between foreign goods 
		 and home goods with aggregate moment condition.
		
*********************************************************************/
clear all
clear matrix 
set more off 
*set tr on
clear matrix
cap log close

*Assign directory where files are stored:
global directory ="/"

*Set Directory 
cd "$directory/FLOR_ARCHIVE/"

*Make sure product function is installed
cap net inst "http://www.stata.com/stb/stb51/dm71.pkg"
cap net install  "http://www.stata-journal.com/software/sj5-4/st0030_2.pkg"


******************************************************************
*          2. Bootstrap to get the standard errors of sigma and omega (combining both part 1 and part 2)
******************************************************************
*I am writing a loop to do the bootstrap B times. (a combination of postfile and forvalues command)
*tier is the number of bootstrap resamples

****************************************************************
*	2.1 First, implements Feenstra (1994)'s method to estimate the elasticity of substitution among imports
******************************************************************
*Perform the commands in section 1
*loop over bootstrapped datasets:
forvalues k =1/500 {
	cap forvalues m= 1/1 {
	use ready.dta, clear
	*Recreate weights which need to be bootstrapped along with prices and shares
	sort product t
	tsset product t
	bysort product: gen wijgt_num=(s_ij-l.s_ij)/(ln(s_ij)-ln(l.s_ij))
	bysort product: gen wjjgt_num=(s_jj-l.s_jj)/(ln(s_jj)-ln(l.s_jj))
	sort good t
	bysort good t: egen wijgt_denom=sum(wijgt_num)
	sort good t
	bysort good t: egen wjjgt_denom=sum(wjjgt_num)
	gen wijgt=wijgt_num/wijgt_denom
	gen wjjgt=wjjgt_num/wjjgt_denom
	sort good t
	drop wjjgt_denom wijgt_denom wjjgt_num wijgt_num
	save ready_forbootstrap.dta, replace
	sort groupcom
	
	*Set Seed within Bootstrap
	set seed 10`k'

	use ready_forbootstrap, clear
	*Generate aggregate variables:
	rename ls_fj lsfjt
	rename ls_jj lsjjt
	rename lpsv_fj_dif lpsv_fj_dift
	rename ls_fj_dif ls_fj_dift
	*drop lpsv_fj_dif  ls_fj_dif s_fj
	bysort year good: egen sfj = sum(s_ij)
	replace sfj = sfj/(sfj + s_jj)
	bysort year good: egen wfjgt = sum(wijgt)
	replace wijgt = wijgt/wfjgt
	gen ls_fj =ln(sfj)
	gen ls_jj =1-sfj
	replace ls_jj =ln(ls_jj)
	
	*IF you receive an error messages here you must load prod which is an ado file
	*to install type findit prod into the command window then select correct file.
	egen psvfj=prod(psv_ij^(wijgt)), by(good t)
	*generate a variable t to indicate years
	gen lpsvfj = ln(psvfj)
	sort product t
	by product: gen ls_fj_dif = ls_fj[_n]-ls_fj[_n-1] if t[_n]-t[_n-1] == 1
	by product: gen lpsv_fj_dif = lpsv_fj[_n]-lpsv_fj[_n-1] if t[_n]-t[_n-1]==1

	*Generate variables
	gen ysv_ij     = (lpsv_ij_dif - lpsv_fj_dif)^2
	gen x1sv_ij    = (ls_ij_dif - ls_jj_dif)^2
	gen x2sv_ij    = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
	gen x3sv_ij    = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
	gen x4sv_ij    = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
	gen x5sv_j 	   =  (lpsv_fj_dif - lpsv_jj_dif )^2
	gen ysv_ij_SIG  = (lpsv_ij_dif - lpsv_fj_dif)^2
	gen x1sv_ij_SIG = (ls_ij_dif   - ls_fj_dif )^2
	gen x2sv_ij_SIG = (lpsv_ij_dif - lpsv_fj_dif )*(ls_ij_dif -ls_fj_dif )
	gen ysv_ij_AG  = (lpsv_fj_dif -lpsv_jj_dif )^2
	gen x1sv_ij_AG = (ls_fj_dif -ls_jj_dif )^2
	gen x2sv_ij_AG = (lpsv_fj_dif -lpsv_jj_dif )*(ls_fj_dif -ls_jj_dif )	
	
	egen loopindustry=group (groupcom)
	egen indyear=group (groupcom year)
	*Drop industries with too few observations
	bysort loopindustry: gen num=_N
	bysort indyear: gen num2=_N
	drop if num<50
	drop loopindustry indyear  num num2
	******************************************************************
	* Bootstrap data
	******************************************************************
	* the probability of a country being sampled is weighted by the number of years the country
	* appears in the data for a given good.
	*Generate indum bootstrap samples clustered on country codes then merge into 
	bsample , cluster(ccode) strata(groupcom)
	******************************************************************
	* Recreate Sato Vartia Price indexes and log shares
	**************************************************************
	save bootdata/bootready_`k'_nest_0.dta, replace
		
	*loop over bootstrapped datasets of each k boostrapped dataset: For constructing t-stats
	forvalues l = 1/100 {
		cap forvalues j = 1/1 {
			if `l' != 0 {
				set seed 10`k'`l'
				*Generate a bootstrap resample
				drop _all
				matrix drop _all
				scalar drop _all 
				use bootdata/bootready_`k'_nest_0.dta, clear
				*Drop data constructed in orignal dataset:
				drop sfj wfjgt ls_fj ls_jj psvfj lpsvfj ls_fj_dif ///
				lpsv_fj_dif ysv_ij x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j ///
				ysv_ij_SIG x1sv_ij_SIG x2sv_ij_SIG ysv_ij_AG x1sv_ij_AG x2sv_ij_AG
				*Generate aggregate variables:
				bysort year good: egen sfj = sum(s_ij)
				replace sfj = sfj/(sfj + s_jj)
				bysort year good: egen wfjgt = sum(wijgt)
				replace wijgt = wijgt/wfjgt
				gen ls_fj =ln(sfj)
				gen ls_jj =1-sfj
				replace ls_jj =ln(ls_jj)
				
				*IF you receive an error messages here you must load prod which is an ado file
				*to install type findit prod into the command window then select correct file.
				egen psvfj=prod(psv_ij^(wijgt)), by(good t)
				*generate a variable t to indicate years
				gen lpsvfj = ln(psvfj)
				sort product t
				by product: gen ls_fj_dif = ls_fj[_n]-ls_fj[_n-1] if t[_n]-t[_n-1] == 1
				by product: gen lpsv_fj_dif = lpsv_fj[_n]-lpsv_fj[_n-1] if t[_n]-t[_n-1]==1

				*Generate variables
				gen ysv_ij     = (lpsv_ij_dif - lpsv_fj_dif)^2
				gen x1sv_ij    = (ls_ij_dif - ls_jj_dif)^2
				gen x2sv_ij    = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
				gen x3sv_ij    = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
				gen x4sv_ij    = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
				gen x5sv_j 	   =  (lpsv_fj_dif - lpsv_jj_dif )^2
				gen ysv_ij_SIG  = (lpsv_ij_dif - lpsv_fj_dif)^2
				gen x1sv_ij_SIG = (ls_ij_dif   - ls_fj_dif )^2
				gen x2sv_ij_SIG = (lpsv_ij_dif - lpsv_fj_dif )*(ls_ij_dif -ls_fj_dif )
				gen ysv_ij_AG  = (lpsv_fj_dif -lpsv_jj_dif )^2
				gen x1sv_ij_AG = (ls_fj_dif -ls_jj_dif )^2
				gen x2sv_ij_AG = (lpsv_fj_dif -lpsv_jj_dif )*(ls_fj_dif -ls_jj_dif )	
				
				egen loopindustry=group (groupcom)
				egen indyear=group (groupcom year)
				*Drop industries with too few observations
				bysort loopindustry: gen num=_N
				bysort indyear: gen num2=_N
				drop if num<50
				drop loopindustry indyear num num2
				
				******************************************************************
				* 2.3 Bootstrap Nest data with a weighted bootstrap  
				******************************************************************
				* the probability of a country being sampled is weighted by the number of years the country
				* appears in the data for a given good.
				*Generate indum bootstrap samples clustered on country codes then merge into 
				bsample , cluster(ccode) strata(groupcom)
				******************************************************************
				* 2.4 Recreate Sato Vartia Price indexes and log shares
				**************************************************************
				save bootdata/bootready_`k'_nest_`l'.dta, replace		
			}
		
			*Begin estimation
			noisily di "Bootstrap Number  " `k' " Nest Rep " `l'
			cap postclose boot_sigma_`k'_nest_`l'
			local sigmalist "groupcom ref num thetasv1 thetasv2 rho1sv sigmasv sigmasvse thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse "
			postfile boot_sigma_`k'_nest_`l' `sigmalist' using "BOOT_Results/boot_sigma_estimation_robust_`k'_nest_`l'", replace

			use bootdata/bootready_`k'_nest_`l'.dta ,clear


			replace ysv_ij = ysv_ij_SIG  
			replace  x1sv_ij = x1sv_ij_SIG 
			replace x2sv_ij = x2sv_ij_SIG 
			drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . 

			*merge with weights from orginal estimation
			merge m:1 industrycountry using  bootstrap_weights
			keep if _merge == 3
			drop _merge

			*Define loopindustry to loop over industries (in the results, report groupcom number instead of the industry number)
			egen loopindustry=group (groupcom)
			sum loopindustry product
			*Drop industries with too few observations
			tab loopindustry
			bysort loopindustry: gen num=_N
			sort num loopindustry
			drop if num<50
			drop loopindustry
			egen loopindustry=group (groupcom)
			sum loopindustry
			local indnum = r(max)
			save bootdata/bootready_sigma.dta, replace
			*2SLS IV
			cap forvalues i=1/`indnum' {
				cap forvalues n = 1/1 {
				use bootdata/bootready_sigma.dta if loopindustry==`i', clear
			
				*for Sato-Vartia price indicator
				qui tab ccode, gen(c_I_) 
				foreach var of varlist x1sv_ij x2sv_ij {
					gen `var'hat = `var'
					sum `var'hat if loopind == `i'
					*replace `var'hat = `var'hat - r(mean) if loopind == `i'
					}
				*Run 2sls regression for sigma
				ivregress 2sls ysv_ij (x1sv_ijhat x2sv_ijhat = c_I_*) , small 

				gen conssv=_b[_cons] 
				gen thetasv1=_b[x1sv_ijhat]
				gen thetasv2=_b[x2sv_ijhat]
				estat vce			/* VAR-COV TO BE USED TO CALCULATE CI'S FOR SIGMA */
				gen rho1sv = .5 + sqrt(.25 - 1/(4+thetasv2^2/thetasv1)) if thetasv2>0
				replace rho1sv = .5 - sqrt(.25 - 1/(4+thetasv2^2/thetasv1)) if thetasv2<0
				gen sigmasv = 1 + (2*rho1sv-1)/((1-rho1sv)*thetasv2)

				******************************************************
				*             Get standard error of Sigma
				*  using Taylor series expansion aka Delta method
				* 			 (not used in published paper)
				******************************************************
				gen sigmasvse=0
				cap if   thetasv2>0 {
					testnl 1 + (2* (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhat]^2/_b[x1sv_ijhat]))) -1)/((1- (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhat]^2/_b[x1sv_ijhat]))) )* _b[x2sv_ijhat] )=0
					replace sigmasvse=sigmasv/sqrt(r(F))
				}
				cap if  thetasv2<0 {
					testnl 1 + (2* (.5 - sqrt(.25 - 1/(4+_b[x2sv_ijhat]^2/_b[x1sv_ijhat]))) -1)/((1- (.5 - sqrt(.25 - 1/(4+_b[x2sv_ijhat]^2/_b[x1sv_ijhat]))) )* _b[x2sv_ijhat] )=0
					replace sigmasvse=sigmasv/sqrt(r(F))
				}

				mkmat groupcom ref num thetasv1 thetasv2 rho1sv sigmasv sigmasvse in 1/1, matrix(bootSV)
				matrix bootbSV=nullmat(bootbSV)\bootSV
				* OPTIMAL WEIGHTS from original dataset
				* WEIGHT DATA AND REESTIMATE 
				gen ones=1
				foreach var of varlist ysv_ij  x1sv_ijhat x2sv_ijhat ones {
					gen `var'svstar = `var'/ssvhat_sig
					}

				ivregress 2sls ysv_ijsvstar onessvstar (x1sv_ijhatsvstar x2sv_ijhatsvstar = c_I_*) , small noc

				gen thetasv1w=_b[x1sv_ijhatsvstar ]
				gen thetasv2w=_b[x2sv_ijhatsvstar ]
				estat vce			
				gen rho1svw = .5 + sqrt(.25 - 1/(4+thetasv2w^2/thetasv1w)) if thetasv2w>0
				replace rho1svw = .5 - sqrt(.25 - 1/(4+thetasv2w^2/thetasv1w)) if thetasv2w<0
				gen sigmasvw = 1 + (2*rho1svw-1)/((1-rho1svw)*thetasv2w)
				sum groupcom num thetasv1w thetasv2w rho1svw sigmasvw

				cap gen sigmasvwse=0
				cap if  thetasv2w >0 {
					testnl 1 + (2* (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) -1)/((1- (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) )* _b[x2sv_ijhatsvstar ] )=0
					replace sigmasvwse=sigmasvw/sqrt(r(F))
				}
				cap if   thetasv2w<0 {
					testnl 1 + (2* (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) -1)/((1- (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) )* _b[x2sv_ijhatsvstar ] )=0
					replace sigmasvwse=sigmasvw/sqrt(r(F))
				}
				mkmat thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse in 1/1, matrix(bootSVw)
				matrix bootbSVw=nullmat(bootbSVw)\bootSVw
				}
			}

			drop _all
			svmat bootbSV, names(col)
			svmat bootbSVw, names(col)
			sort groupcom
			save bootresultstemp.dta, replace	

			*Put this results to a external file
			*read in each observation and then post it to the external file
			use bootresultstemp.dta, clear
			cap sum groupcom
			local indnum = r(N)
			 forvalues i=1/`indnum' {
				preserve 
				keep if _n==`i'
				post boot_sigma_`k'_nest_`l' (groupcom) (ref) (num) (thetasv1) (thetasv2) (rho1sv) (sigmasv) (sigmasvse) (thetasv1w) (thetasv2w) (rho1svw) (sigmasvw)  (sigmasvwse)  
				restore
				}
			**** CLOSE UP LOOP ****
			postclose boot_sigma_`k'_nest_`l'
		}
	}
	
	forvalues l = 0/100 {
		cap erase bootdata/bootready_`k'_nest_`l'.dta

		}
	}
}


foreach sec in `sector_list'  {

*Prepare unbootstraped results for use as starting values
preserve 
use  "Data/Results/Final_sig_omeg_Unweighted_Unstackedsector_2sls.dta", clear
keep groupcom  omegasv2 omegasv2w  rhoFsv2 rhoFsv2w 
rename rhoFsv2 rho_start
rename rhoFsv2w rhow_start
rename omegasv2 omeg_start
rename omegasv2w omegw_start
save  "Data/Results/Final_sig_omeg_Unweighted_Unstackedsector_2sls_STARTER.dta", replace
restore

preserve 
use  "Data/Results/Final_sig_omeg_Weighted_Unstackedsector_2sls.dta", clear
keep groupcom  omegasv2 omegasv2w rhoFsv2 rhoFsv2w  
rename rhoFsv2 rho_start
rename rhoFsv2w rhow_start
rename omegasv2 omeg_start
rename omegasv2w omegw_start 
save  "Data/Results/Final_sig_omeg_Weighted_Unstackedsector_2sls_STARTER.dta", replace
restore

preserve 
use  "Data/Results/Final_sig_omeg_Unweighted_Stackedsector_2sls.dta", clear
keep groupcom   rhoFsv3 omegasv3  ///
				rhoFsv3w omegasv3w  
rename rhoFsv3 rho_start
rename rhoFsv3w rhow_start
rename omegasv3 omeg_start
rename omegasv3w omegw_start
save  "Data/Results/Final_sig_omeg_Unweighted_Stackedsector_2sls_STARTER.dta", replace
restore

preserve 
use  "Data/Results/Final_sig_omeg_Weighted_Stackedsector_2sls.dta", clear
keep groupcom   rhoFsv3 omegasv3  ///
				rhoFsv3w omegasv3w  
rename rhoFsv3 rho_start
rename rhoFsv3w rhow_start
rename omegasv3 omeg_start
rename omegasv3w omegw_start
save  "Data/Results/Final_sig_omeg_Weighted_Stackedsector_2sls_STARTER.dta", replace
restore

***************************************************************************
*            2.2 Second, using nonlinear estimation to estimate the elasticity 
*                 of substitution between foreign goods and home goods
***************************************************************************
*For each bootstraped sample bootready_k.dta. Perform the commands in 1.2
*There are also two steps for the second stage
*First, run nonlinear regressions and generate error terms
*Second, using the error terms to generate weights and re-run the weighted nonlinear regressions

******************************************************************
*         Bootstrap to get the standard errors of omega
******************************************************************
*I am writing a loop to do the bootstrap B times. (a combination of postfile and forvalues command)
*looping over both bootstrap samples and methods

forvalues k =1/500 {
	*Inner loop for when an individual rep does not produce estimates the code does not crash
	cap forvalues m= 1/1 {
	*Clear matrices and scalars
	matrix drop _all
	scalar drop _all 
	noisily di "NONLINEAR TIER `k'  "	
	use ready.dta, clear
	*Recreate weights which need to be bootstrapped along with prices and shares
	sort product t
	tsset product t
	bysort product: gen wijgt_num=(s_ij-l.s_ij)/(ln(s_ij)-ln(l.s_ij))
	bysort product: gen wjjgt_num=(s_jj-l.s_jj)/(ln(s_jj)-ln(l.s_jj))
	sort good t
	bysort good t: egen wijgt_denom=sum(wijgt_num)
	sort good t
	bysort good t: egen wjjgt_denom=sum(wjjgt_num)
	gen wijgt=wijgt_num/wijgt_denom
	gen wjjgt=wjjgt_num/wjjgt_denom
	sort good t
	drop wjjgt_denom wijgt_denom wjjgt_num wijgt_num
	save ready_forbootstrap.dta, replace
	sort groupcom
	*Set Seed within Bootstrap
	set seed 10`k'
	use ready_forbootstrap, clear
	*Generate aggregate variables:
	rename ls_fj lsfjt
	rename ls_jj lsjjt
	rename lpsv_fj_dif lpsv_fj_dift
	rename ls_fj_dif ls_fj_dift
	*drop lpsv_fj_dif  ls_fj_dif s_fj
	bysort year good: egen sfj = sum(s_ij)
	replace sfj = sfj/(sfj + s_jj)
	bysort year good: egen wfjgt = sum(wijgt)
	replace wijgt = wijgt/wfjgt
	gen ls_fj =ln(sfj)
	gen ls_jj =1-sfj
	replace ls_jj =ln(ls_jj)
	
	*IF you receive an error messages here you must load prod which is an ado file
	*to install type findit prod into the command window then select correct file.
	egen psvfj=prod(psv_ij^(wijgt)), by(good t)
	*generate a variable t to indicate years
	gen lpsvfj = ln(psvfj)
	sort product t
	by product: gen ls_fj_dif = ls_fj[_n]-ls_fj[_n-1] if t[_n]-t[_n-1] == 1
	by product: gen lpsv_fj_dif = lpsv_fj[_n]-lpsv_fj[_n-1] if t[_n]-t[_n-1]==1

	*Generate variables
	gen ysv_ij     = (lpsv_ij_dif - lpsv_fj_dif)^2
	gen x1sv_ij    = (ls_ij_dif - ls_jj_dif)^2
	gen x2sv_ij    = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
	gen x3sv_ij    = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
	gen x4sv_ij    = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
	gen x5sv_j 	   =  (lpsv_fj_dif - lpsv_jj_dif )^2
	gen ysv_ij_SIG  = (lpsv_ij_dif - lpsv_fj_dif)^2
	gen x1sv_ij_SIG = (ls_ij_dif   - ls_fj_dif )^2
	gen x2sv_ij_SIG = (lpsv_ij_dif - lpsv_fj_dif )*(ls_ij_dif -ls_fj_dif )
	gen ysv_ij_AG  = (lpsv_fj_dif -lpsv_jj_dif )^2
	gen x1sv_ij_AG = (ls_fj_dif -ls_jj_dif )^2
	gen x2sv_ij_AG = (lpsv_fj_dif -lpsv_jj_dif )*(ls_fj_dif -ls_jj_dif )	
	
	egen loopindustry=group (groupcom)
	egen indyear=group (groupcom year)
	*Drop industries with too few observations
	bysort loopindustry: gen num=_N
	bysort indyear: gen num2=_N
	drop if num<50
	drop loopindustry indyear  num num2
	******************************************************************
	* 2.1 Bootstrap data with a weighted bootstrap  
	******************************************************************
	* the probability of a country being sampled is weighted by the number of years the country
	* appears in the data for a given good.
	*Generate indum bootstrap samples clustered on country codes then merge into 
	bsample , cluster(ccode) strata(groupcom)
	******************************************************************
	* 2.2 Recreate Sato Vartia Price indexes and log shares
	**************************************************************
	save bootdata/bootready_`k'_nest_0.dta, replace
		
	*loop over bootstrapped datasets of each k boostrapped dataset: For constructing t-stats
	forvalues l = 0/50 {
	noisily di "NONLINEAR TIER `k' NEST `l' "	

	cap forvalues n= 1/1 {
		if `l' != 0 {
			set seed 10`k'`l'
			*Generate a bootstrap resample
			drop _all
			matrix drop _all
			scalar drop _all 
			use bootdata/bootready_`k'_nest_0.dta, clear
			*Drop data constructed in orignal dataset:
			drop sfj wfjgt ls_fj ls_jj psvfj lpsvfj ls_fj_dif  ///
			lpsv_fj_dif ysv_ij x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j  ///
			ysv_ij_SIG x1sv_ij_SIG x2sv_ij_SIG ysv_ij_AG x1sv_ij_AG x2sv_ij_AG
			*Generate aggregate variables:
			bysort year good: egen sfj = sum(s_ij)
			replace sfj = sfj/(sfj + s_jj)
			bysort year good: egen wfjgt = sum(wijgt)
			replace wijgt = wijgt/wfjgt
			gen ls_fj =ln(sfj)
			gen ls_jj =1-sfj
			replace ls_jj =ln(ls_jj)
			
			*IF you receive an error messages here you must load prod which is an ado file
			*to install type findit prod into the command window then select correct file.
			egen psvfj=prod(psv_ij^(wijgt)), by(good t)
			*generate a variable t to indicate years
			gen lpsvfj = ln(psvfj)
			sort product t
			by product: gen ls_fj_dif = ls_fj[_n]-ls_fj[_n-1] if t[_n]-t[_n-1] == 1
			by product: gen lpsv_fj_dif = lpsv_fj[_n]-lpsv_fj[_n-1] if t[_n]-t[_n-1]==1

			*Generate variables
			gen ysv_ij     = (lpsv_ij_dif - lpsv_fj_dif)^2
			gen x1sv_ij    = (ls_ij_dif - ls_jj_dif)^2
			gen x2sv_ij    = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
			gen x3sv_ij    = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
			gen x4sv_ij    = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
			gen x5sv_j 	   =  (lpsv_fj_dif - lpsv_jj_dif )^2
			gen ysv_ij_SIG  = (lpsv_ij_dif - lpsv_fj_dif)^2
			gen x1sv_ij_SIG = (ls_ij_dif   - ls_fj_dif )^2
			gen x2sv_ij_SIG = (lpsv_ij_dif - lpsv_fj_dif )*(ls_ij_dif -ls_fj_dif )
			gen ysv_ij_AG  = (lpsv_fj_dif -lpsv_jj_dif )^2
			gen x1sv_ij_AG = (ls_fj_dif -ls_jj_dif )^2
			gen x2sv_ij_AG = (lpsv_fj_dif -lpsv_jj_dif )*(ls_fj_dif -ls_jj_dif )	
			
			egen loopindustry=group (groupcom)
			egen indyear=group (groupcom year)
			*Drop industries with too few observations
			bysort loopindustry: gen num=_N
			bysort indyear: gen num2=_N
			drop if num<50
			drop loopindustry indyear num num2
			******************************************************************
			* 2.3 Bootstrap Nest data with a weighted bootstrap  
			******************************************************************
			* the probability of a country being sampled is weighted by the number of years the country
			* appears in the data for a given good.
			*Generate indum bootstrap samples clustered on country codes then merge into 
			bsample , cluster(ccode) strata(groupcom)
			******************************************************************
			* 2.4 Recreate Sato Vartia Price indexes and log shares
			**************************************************************
			save bootdata/bootready_`k'_nest_`l'.dta, replace		
			}
			
			use "bootdata/boot_sigma_estimation_robust_`k'_nest_`l'.dta", clear
			sort groupcom 
			cap gen bootrep = `k'
			cap gen bootnestrep =`l'
			save , replace
			********************
			clear matrix 
			*First step of second stage
			use bootdata/bootready_`k'_nest_`l'.dta ,clear
			sort groupcom
			merge m:1 groupcom using "bootdata/boot_sigma_estimation_robust_`k'_nest_`l'.dta"
			drop if _merge==1
			drop _merge
			duplicates report groupcom
			merge m:1 groupcom using  "Data/Results/Final_sig_omeg_Unweighted_Unstackedsector_2sls_STARTER.dta"
			drop if _merge==1
			drop _merge
			duplicates report groupcom 
			gen one=1

			drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 
			drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
			gen sigma_data = 1
			*****************************************
			*     RUN SECOND STAGE BY SECTORS       *
			*****************************************
			preserve 
			use sector.dta, clear
			sort groupcom
			save sector.dta, replace
			restore

			sort groupcom
			merge groupcom using sector.dta
			tab _merge
			drop if _merge==2
			drop _merge

			* Generate blank X vector to be filled  
			sort industrycountry
			foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
			gen `var'hat=.
			}

			egen tempind = group(groupcom)
			sum tempind
			local indnum = r(max)	
			forvalues j=1/`indnum' {
			qui tab ccode if tempind==`j' , gen(c_I)
			*Demean X variable set
			cap foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
				regress `var' c_I* if tempind==`j' & sigma_data ==1 , noc
				predict `var'hat1 if tempind==`j' & sigma_data ==1
				*sum `var' if tempind==`j' & sigma_data ==1
				*replace `var'hat = `var'hat1-r(mean) if tempind==`j'
				replace `var'hat = `var'hat1 if tempind==`j'
				drop `var'hat1
			}
			drop c_I*
			}	

			egen tempsec = group(sector)
			sum tempsec
			local secnum = r(max)
			save ready_sig_bootsector, replace

			sum omeg_start,d
			local omega_median = r(p50)
			sum omegw_start,d
			local omegaw_median = r(p50)

			*Now Regression for sectors separately, 
			*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
			forvalues i=1/`secnum' {
			use ready_sig_bootsector if tempsec == `i', replace 

			local rho = rho_start
			local rhow = rhow_start

			if omegw_start > 0 {
				local omegaw =omeg_start
				}
				
			if omeg_start > 0 {
				local omega = omegw_start 
				}
			if omegw_start > 0 {
				local omegaw =omeg_start
				}
			if omeg_start < 0 {
				local omega = `omega_median' 
				}
			if omegw_start < 0 {
				local omegaw = `omega_median' 
				}
			noi display "SECOND STAGE NL ESTIMATION UNSTACKED UNWEIGHTED: SECTOR `i' SEC DEF sector"
			*SV
			cap  nl (ysv_ij  =  thetasv1 * x1sv_ijhat + thetasv2 * x2sv_ijhat + ///
				 (1-{omegasv})* (1+(rho1sv/{rhoFsv})-2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat  +   ///
				 (1-{omegasv})*((rho1sv/{rhoFsv})-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat +     ///
				 (rho1sv-(rho1sv/{rhoFsv}))*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat  +     ///
						 {constant}* one ///
			   ), iterate(500) initial (omegasv `omega' rhoFsv `rho')

			cap gen converge2 = e(converge)
			gen omegasv2=_b[/omegasv]
			scalar omegasvsescalar=_se[/omegasv]
			gen omegasvse2=omegasvsescalar
			cap gen rhoFsv2=_b[/rhoFsv]
			cap gen rhoFsvse2=_se[/rhoFsv]
			gen constantsv2=_b[/constant]
			mkmat sector converge2 constantsv2 rhoFsv2 rhoFsvse2 omegasv2 omegasvse2 in 1/1, matrix(nlSVsector)
			matrix nlsvssector=nullmat(nlsvssector)\nlSVsector

			cap  nl (ysv_ij  =  thetasv1w * x1sv_ijhat + thetasv2w * x2sv_ijhat + ///
			 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat  +   ///
			 (1-{omegasv})*(rho1sv/{rhoFsv}-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat +     ///
			 (rho1svw-rho1sv/{rhoFsv})*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat  +     ///
					 {constant}* one ///
			   ), iterate(500) initial (omegasv `omega' rhoFsv `rho')


			cap gen convergew2 = e(converge)
			gen omegasv2w=_b[/omegasv]
			scalar omegasvsescalarw=_se[/omegasv]
			gen omegasvse2w=omegasvsescalar
			cap gen rhoFsv2w=_b[/rhoFsv]
			cap gen rhoFsvse2w=_se[/rhoFsv]
			gen constantsv2w=_b[/constant]
			mkmat constantsv2w convergew2 rhoFsv2w rhoFsvse2w omegasv2w omegasvse2w  in 1/1, matrix(nlSVwsector)
			matrix nlsvswsector=nullmat(nlsvswsector)\nlSVwsector		   		      	
			} 

			drop _all
			svmat nlsvssector, names(col)
			svmat nlsvswsector, names(col)
			sort sector
			duplicates drop 
			gen bootrep = `k'
			gen bootnetsrep= `l'
			save "bootdata/boot_Final_Unweighted_Unstackedsector_`k'_nest_`l'.dta", replace
			noisily di "*********** END NONLINEAR STAGE1 **********"
			*Combine Unweighted Omega Estimates with Sigma Estimates
				clear
				use sector.dta
				sort sector
				merge m:1 sector using "bootdata/boot_Final_Unweighted_Unstackedsector_`k'_nest_`l'.dta"
				drop _merge
				sort  groupcom
				duplicates report groupcom
				merge 1:1 groupcom using "bootdata/boot_sigma_estimation_robust_`k'_nest_`l'.dta"
				keep if _merge ==3
				drop _merge
				merge m:1 groupcom using  "Data/Results/Final_sig_omeg_Weighted_Unstackedsector_2sls_STARTER.dta"
				drop if _merge==1
				drop _merge
				duplicates report groupcom 
				
			drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==.  
			sort  groupcom
			save boottwostagecombined_secdefsector.dta, replace
			*Reconstruct dataset combined with sigma and omega estimates to weight and reestimate
			use bootdata/bootready_`k'_nest_`l'.dta ,clear
			sort groupcom
			merge groupcom using boottwostagecombined_secdefsector.dta
			tab _merge
			drop if _merge==1
			drop _merge
			*merge with weights from orginal estimation
			merge m:1 industrycountry using  bootstrap_weights
			keep if _merge ==3
			drop _merge

			drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 


			keep  ysv_ij x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j   ///
			  groupcom ccode thetasv1 thetasv2 rho1sv sigmasv sigmasvse   /// 
			  thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse  omegasv2  ///
			  omegasv2w rhoFsv2 rhoFsv2w  rho_start rhow_start  omeg_start omegw_start ///
			  ssvhat_omeg ssvwhat_omeg
			  
			save boot_ready_theta_secdefsector.dta, replace	
			*Weighted Regressions for sectors separately
			use  boot_ready_theta_secdefsector.dta, clear
			egen industrycountry = group(ccode groupcom)
			sort groupcom
			merge groupcom using sector.dta
			tab _merge
			drop if _merge==2
			drop _merge
			qui tab sector
			*Generate a temp sector for each sec def as before
			keep  groupcom  sector ccode thetasv1 thetasv2 rho1sv sigmasv sigmasvse ///
				thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse ///
				 ysv_ij x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j ///
				  industrycountry omegasv2 omegasv2w rhoFsv2 rhoFsv2w 	///
				  rho_start rhow_start  omeg_start omegw_start ///
				  ssvhat_omeg ssvwhat_omeg
				  
			*Regress X vector on country indicators 
			sort industrycountry
			foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
			gen `var'hat=.
			}

			gen ssvhat= .	
			gen ssvwhat= .	
			egen tempind = group(groupcom)
			sum tempind
			local indnum = r(max)	
			forvalues j=1/`indnum' {
			cap tab ccode if tempind==`j' , gen(c_I)
			*Demean X variable set
			cap  foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
				regress `var' c_I* if tempind==`j' , noc
				predict `var'hat1 if tempind==`j' 
				sum `var' if tempind==`j' 
				*replace `var'hat = `var'hat1-r(mean) if tempind==`j'
				replace `var'hat  = `var'hat1 if tempind==`j'
				drop `var'hat1
			}
			drop c_I*
			}	
			gen ones =1
			********** WEIGHT DATA BY VARIANCE*********;
			********************************************
			foreach var of varlist  ysv_ij x1sv_ijhat x2sv_ijhat x3sv_ijhat x4sv_ijhat x5sv_jhat ones {
				gen `var'_weighted=`var'/ ssvhat_omeg
				gen `var'_weightedw=`var'/ssvwhat_omeg
			}
			egen tempsec = group(sector)
			sum tempsec
			local secnum = r(max)

			sum omeg_start,d
			local omega_median = r(p50)
			sum omegw_start,d
			local omegaw_median = r(p50)

			save boot_weightedready_secdefsector.dta, replace
			**********      RE-ESTIMATE       *********;
			********************************************
			*Now Regression for sectors separately, 
			*Regressing RHS variables on country indicator BY GOOD creates country good averages.
			forvalues i=1/`secnum' {
			use boot_weightedready_secdefsector.dta if tempsec == `i', replace 

			local rho = rho_start
			local rhow = rhow_start

			if omeg_start > 0 {
				local omega = omeg_start 
				}
			if omegw_start > 0 {
				local omegaw =omegw_start
				}
			if omeg_start < 0 {
				local omega = `omega_median' 
				}
			if omegw_start < 0 {
				local omegaw = `omega_median' 
				}
				
			noi display "SECOND STAGE NL ESTIMATION UNSTACKED WEIGHTED: SECTOR `i' SEC DEF sector"
			*SV
			  cap  nl (ysv_ij_weighted  =  thetasv1 * x1sv_ijhat_weighted + thetasv2 * x2sv_ijhat_weighted + ///
				 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat_weighted  +   ///
				 (1-{omegasv})*((rho1sv/{rhoFsv})-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat_weighted +     ///
				 (rho1sv-(rho1sv/{rhoFsv}))*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat_weighted  +     ///
						 {constant}* ones_weighted ///
			   ), iterate(500) initial (omegasv `omega' rhoFsv `rho')
			   
			cap gen converge2 = e(converge)
			replace omegasv2=_b[/omegasv]
			scalar omegasvsescalar=_se[/omegasv]
			gen omegasvse2=omegasvsescalar
			cap gen rhoFsv2=_b[/rhoFsv]
			cap gen rhoFsvse2=_se[/rhoFsv]
			gen constantsv2=_b[/constant]
			mkmat sector converge2 constantsv2 rhoFsv2 rhoFsvse2 omegasv2 omegasvse2 in 1/1, matrix(nlSVsector)
			matrix nlsvs_weightedsector=nullmat(nlsvs_weightedsector)\nlSVsector

			 cap  nl (ysv_ij_weightedw  =  thetasv1w * x1sv_ijhat_weightedw  + thetasv2w * x2sv_ijhat_weightedw  + ///
				 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat_weightedw   +   ///
				 (1-{omegasv})*((rho1svw/{rhoFsv})-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat_weightedw  +     ///
				 (rho1svw-(rho1svw/{rhoFsv}))*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat_weightedw   +     ///
						 {constant}*ones_weightedw ///
			   ), iterate(500) initial (omegasv `omegaw' rhoFsv `rhow')
			   
			cap gen convergew2 = e(converge)
			replace omegasv2w=_b[/omegasv]
			scalar omegasvsescalarw=_se[/omegasv]
			gen omegasvse2w=omegasvsescalar
			cap gen rhoFsv2w=_b[/rhoFsv]
			cap gen rhoFsvse2w=_se[/rhoFsv]
			gen constantsv2w=_b[/constant]
			mkmat convergew2  constantsv2w rhoFsv2w rhoFsvse2w omegasv2w omegasvse2w  in 1/1, matrix(wnlSVwsector)
			matrix nlsvsw_weightedsector=nullmat(nlsvsw_weightedsector)\wnlSVwsector		   		      
			} 

			drop _all
			svmat nlsvs_weightedsector, names(col)
			svmat nlsvsw_weightedsector, names(col)
			sort sector
			duplicates drop 
			gen bootrep = `k'
			gen bootnestrep= `l'
			save "bootdata/boot_Final_Weighted_Unstackedsector_`k'_nest_nest_`l'.dta", replace

			***************************************************************************
			*           2.3 using nonlinear estimation to estimate the elasticity of substitution with Stacked System
			***************************************************************************
			clear all
			clear matrix 
			********************************************
			*				STACK DATA
			*******************************************
			*Construct disaggragate data
			use sector.dta, clear
			sort sector
			merge m:1 sector using "bootdata/boot_Final_Unweighted_Unstackedsector_`k'_nest_`l'.dta"
			drop _merge
			sort  groupcom
			duplicates report groupcom
			merge groupcom using "bootdata/boot_sigma_estimation_robust_`k'_nest_`l'.dta"
			keep if _merge ==3
			drop _merge
			*merge in Starting values
			merge m:1 groupcom using  "Data/Results/Final_sig_omeg_Unweighted_Stackedsector_2sls_STARTER.dta"
			drop if _merge==1
			drop _merge
			duplicates report groupcom 

			drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==. 
			sort  groupcom
			save boot_unw_unstkd_estsector.dta, replace
			*Reconstruct dataset combined with sigma and omega estimates to weight and reestimate
			use bootdata/bootready_`k'_nest_`l'.dta ,clear
			sort groupcom
			merge groupcom using boot_unw_unstkd_estsector.dta
			tab _merge
			drop if _merge==1
			drop _merge
			*merge with weights from orginal estimation
			merge m:1 industrycountry using  bootstrap_weights
			keep if _merge == 3
			drop _merge

			*Generate variables
			drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 

			*Regress X vector on country indicators 
			sort industrycountry
			foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
				gen `var'hat=.
				}
				
			egen tempind = group(groupcom)
			sum tempind
			local indnum = r(max)	
			forvalues j=1/`indnum' {
			cap tab ccode if tempind==`j' , gen(c_I)
				*Demean X variable set
				cap foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
					regress `var' c_I* if tempind==`j'  , noc
					predict `var'hat1 if tempind==`j' 
					sum `var' if tempind==`j' 
					*replace `var'hat  = `var'hat1-r(mean) if tempind==`j'
					replace `var'hat   = `var'hat1 if tempind==`j'
					drop `var'hat1
				}
			drop c_I*
			}	

			gen sigma_data = 1
			keep  ccode industrycountry groupcom  rhoFsv2 omegasv2  rhoFsv2w omegasv2w  ///
				rho1sv sigmasv rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij x3sv_ij x4sv_ij x5sv_j ///
				 sigma_data sector t ysv_ij  x1sv_ijhat  x2sv_ijhat x3sv_ijhat x4sv_ijhat x5sv_jhat	///
				 rho_start rhow_start  omeg_start omegw_start  ssvhat_omegSAG ssvwhat_omeSAG

			save boot_ready_sig_omeg_data.dta, replace
			*******************************
			*Construct Aggragate Data	
			*******************************						
			use bootdata/bootready_`k'_nest_`l'.dta ,clear
			sort groupcom
			merge groupcom using boot_unw_unstkd_estsector.dta,
			tab _merge
			drop if _merge==1
			drop _merge
			*merge with weights from orginal estimation
			merge m:1 industrycountry using  bootstrap_weights
			keep if _merge == 3
			drop _merge

			replace ysv_ij  = ysv_ij_AG
			replace x1sv_ij = x1sv_ij_AG
			replace x2sv_ij = x2sv_ij_AG
			drop if ysv_ij_AG  == . | x1sv_ij_AG == . | x2sv_ij_AG == . 
			gen sigma_data = 0

			foreach var of varlist ysv_ij x1sv_ij x2sv_ij {
				gen `var'hat= `var'
				}
			bysort groupcom t: gen ctycount = _N

			keep  ccode industrycountry groupcom  rhoFsv2 omegasv2  rhoFsv2w omegasv2w  ///
				rho1sv sigmasv rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij   sigma_data  sector t ///
				rho_start rhow_start  omeg_start omegw_start ctycount   ssvhat_omegSAG ssvwhat_omeSAG

			*remove duplicates (data repeats by source country)
			collapse (mean)  rhoFsv2 omegasv2 rhoFsv2w omegasv2w sigma_data  ///
				rho1sv sigmasv  rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij sector ///
				rho_start rhow_start  omeg_start omegw_start  ssvhat_omegSAG ssvwhat_omeSAG (max) ctycount , by(groupcom t)

			* Regress X vector on good indicators 
			foreach var of varlist  x1sv_ij x2sv_ij {
			gen `var'hat=.
			}

			cap tab groupcom , gen(g_I)
			*Average X variable set by Good
			foreach var of varlist x1sv_ij x2sv_ij  {
			regress `var' g_I* , noc
			predict `var'hat1 
			replace `var'hat = `var'hat1
			drop `var'hat1 
			}	
			drop g_I*
			*weight Agg data by sqrt of source country count
			gen sqr_ctycount = sqrt(ctycount)
			foreach var of varlist ysv_ij x1sv_ijhat  x2sv_ijhat {
				replace `var' = `var'*sqr_ctycount
				}
			append using boot_ready_sig_omeg_data.dta
			foreach var of varlist x3sv_ij x4sv_ij x5sv_j x3sv_ijhat x4sv_ijhat x5sv_jhat {
			replace `var'=0 if `var' ==.
			}

			save boot_stacked_sig_omeg_ready.dta, replace
			*************************************************
			*     RUN SECOND STAGE STACKED BY SECTORS       *
			*************************************************
			use boot_stacked_sig_omeg_ready.dta, clear
			egen tempsec = group(sector)
			sum tempsec
			local secnum = r(max)
			save boot_stacked_sig_omeg_ready_sector.dta, replace
			sum omeg_start,d
			local omega_median = r(p50)
			sum omegw_start,d
			local omegaw_median = r(p50)
			*Now Regression for sectors separately, 
			*Regressing RHS variables on country indicator BY GOOD creates country good averages.
			forvalues i=1/`secnum' {
			use boot_stacked_sig_omeg_ready_sector if tempsec == `i', replace 
			if omeg_start > 0 {
				local omega = omeg_start 
				}
			if omegw_start > 0 {
				local omegaw =omegw_start
				}
			if omeg_start < 0 {
				local omega = `omega_median' 
				}
			if omegw_start < 0 {
				local omegaw = `omega_median' 
				}

			local rho = rho_start
			local rhow = rhow_start

			gen ones =1
			noi display "SECOND STAGE NL ESTIMATION STACKED UNWEIGHTED: SECTOR `i' SEC DEF sector"
			*SV Stacked
			 cap nl (ysv_ij = (rho1sv/((sigmasv-1)^2*(1-rho1sv)))*x1sv_ijhat*(sigma_data)  +  ///
				((2*rho1sv-1)/((sigmasv-1)*(1-rho1sv)))*x2sv_ijhat*(sigma_data)  +  ///
				 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat*(sigma_data ) +   ///
				 (1-{omegasv})*(rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat*(sigma_data ) +   ///
				 (rho1sv-rho1sv/{rhoFsv})*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat*(sigma_data ) +   ///
				 ({rhoFsv})/(({omegasv}-1)^2*(1-{rhoFsv}))*x1sv_ijhat*(1-sigma_data)   +  ///
				 (2*{rhoFsv}-1)/(({omegasv}-1)*(1-{rhoFsv}))*x2sv_ijhat*(1-sigma_data )  + ///
				 {constantsv4}*ones  + {constantsv3}*sigma_data   ///
			   ), iterate(500) initial( omegasv `omega' rhoFsv `rho')
			   
			gen converge3 = e(converge)
			gen omegasv3=_b[/omegasv]
			scalar omegasvsescalar=_se[/omegasv]
			gen omegasvse3=omegasvsescalar
			cap gen rhoFsv3=_b[/rhoFsv]
			cap gen rhoFsvse3=_se[/rhoFsv]
			gen constantsv3=_b[/constantsv3]
			gen constantsv4=_b[/constantsv4]
			mkmat sector converge3  constantsv3 constantsv4 rhoFsv3 rhoFsvse3 omegasv3 omegasvse3 in 1/1, matrix(nlSVsector)
			matrix nlsvssector=nullmat(nlsvssector)\nlSVsector

			*SVw Stacked
			cap 	nl (ysv_ij  = (rho1svw/((sigmasvw-1)^2*(1-rho1svw)))*x1sv_ijhat*(sigma_data)  +  ///
				((2*rho1svw-1)/((sigmasvw-1)*(1-rho1svw)))*x2sv_ijhat*(sigma_data)  +  ///
				 (1-{omegasv})* (1+rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat*(sigma_data ) +   ///
				 (1-{omegasv})*(rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat*(sigma_data ) +   ///
				 (rho1svw-rho1svw/{rhoFsvw})*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat*(sigma_data ) +   ///
				 ({rhoFsvw})/(({omegasv}-1)^2*(1-{rhoFsvw}))*x1sv_ijhat*(1-sigma_data)   +  ///
				 (2*{rhoFsvw}-1)/(({omegasv}-1)*(1-{rhoFsvw}))*x2sv_ijhat*(1-sigma_data )  + ///
				 {constantsv4}*ones  + {constantsv3}*sigma_data   ///
			   ), iterate(500) initial( omegasv `omegaw' rhoFsvw `rhow')
			gen converge3w = e(converge)
			gen omegasv3w=_b[/omegasv]
			scalar omegasvsescalarw=_se[/omegasv]
			gen omegasvse3w=omegasvsescalar
			gen rhoFsv3w=_b[/rhoFsvw]
			gen rhoFsvse3w=_se[/rhoFsvw]
			gen constantsv3w=_b[/constantsv3]
			gen constantsv4w=_b[/constantsv4]
			mkmat converge3w  constantsv3w constantsv4w rhoFsv3w rhoFsvse3w omegasv3w omegasvse3w in 1/1, matrix(nlSVwsector)
			matrix nlsvwssector=nullmat(nlsvwssector)\nlSVwsector
			} 	
			drop _all
			svmat nlsvssector, names(col)
			svmat nlsvwssector, names(col)
			sort sector
			duplicates drop 
			gen bootrep = `k'
			gen bootnestrep =`l'
			save "bootdata/boot_Final_Unweighted_Stackedsector_`k'_nest_`l'.dta", replace
							**********************************************
							*     WEIGHT DATA BY MEASURE OF VARIANCE     *
							**********************************************
			****************                DISAGGREGATED DATA                      *******************
			*Combine Unweighted Omega Estimates with Sigma Estimates to construct error based weights
			clear
			use sector.dta
			sort sector
			merge m:1 sector using "bootdata/boot_Final_Unweighted_Stackedsector_`k'_nest_`l'.dta"
			tab _merge
			drop _merge
			sort  groupcom
			duplicates report groupcom
			merge m:1 groupcom using "bootdata/boot_sigma_estimation_robust_`k'_nest_`l'.dta"
			tab _merge
			drop _merge
			*merge in Starting values
			merge m:1 groupcom using  "Data/Results/Final_sig_omeg_Weighted_Stackedsector_2sls_STARTER.dta"
			drop if _merge==1
			drop _merge
			duplicates report groupcom 

			drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==.
			sort  groupcom
			save boot_unw_stkd_estsector.dta, replace

			*Reconstruct dataset combined with sigma and omega estimates to weight and reestimate
			use bootdata/bootready_`k'_nest_`l'.dta ,clear
			sort groupcom
			merge m:1 groupcom using boot_unw_stkd_estsector.dta
			tab _merge
			drop if _merge==1
			drop _merge
			*merge with weights from orginal estimation
			merge m:1 industrycountry using  bootstrap_weights
			keep if _merge == 3
			drop _merge

			drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 

			* Regress X vector on country indicators 
			foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j {
			gen `var'hat=.
			}

			egen tempind = group(groupcom)
			sum tempind
			local indnum = r(max)	
			forvalues j=1/`indnum' {
			cap tab ccode if tempind==`j' , gen(c_I)
			*Demean X variable set and average by source country and good
			 foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
				regress `var' c_I* if tempind==`j' , noc
				predict `var'hat1 if tempind==`j' 
				sum `var' if tempind==`j' 
				*replace `var'hat = `var'hat1-r(mean)  if tempind==`j'
				replace `var'hat = `var'hat1 if tempind==`j'
				drop `var'hat1
			}
			drop c_I*

			}	
				
			gen ones = 1
			gen sigma_data = 1

			foreach var of varlist ysv_ij x1sv_ijhat x2sv_ijhat x3sv_ijhat x4sv_ijhat x5sv_jhat ones sigma_data {
			gen `var'_weighted=`var'/ssvhat_omegS
			gen `var'_weightedw=`var'/ssvwhat_omeS
			}	




			keep  groupcom  sector ysv_ij_weighted x1sv_ijhat_weighted x2sv_ijhat_weighted  ///
						x3sv_ijhat_weighted x4sv_ijhat_weighted x5sv_jhat_weighted  ones_weighted ///
						ysv_ij_weightedw x1sv_ijhat_weightedw x2sv_ijhat_weightedw  ///
						x3sv_ijhat_weightedw x4sv_ijhat_weightedw x5sv_jhat_weightedw ones_weightedw ///
						rho1sv sigmasv  rho1svw sigmasvw  omegasv3 omegasv3w rhoFsv3 ///
						rhoFsv3w  rhoFsvse3 rhoFsvse3w sigma_data_weighted sigma_data_weightedw  rho_start rhow_start  ///
						omeg_start omegw_start  sigma_data 
						
			save boot_weightedready_sigdata_secdefsector.dta, replace

			****************                AGGREGATED DATA                      *******************
			use bootdata/bootready_`k'_nest_`l'.dta ,clear
			sort groupcom
			merge groupcom using boot_unw_stkd_estsector.dta
			tab _merge
			drop if _merge==1
			drop _merge

			*merge with weights from orginal estimation
			merge m:1 industrycountry using  bootstrap_weights
			keep if _merge == 3
			drop _merge
			*Generate Aggragate variables
			replace ysv_ij  = ysv_ij_AG
			replace x1sv_ij = x1sv_ij_AG
			replace x2sv_ij = x2sv_ij_AG
			drop if ysv_ij_AG  == . | x1sv_ij_AG == . | x2sv_ij_AG == . 
			drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==. 
			sort  groupcom
			drop thetasv1 thetasv1w thetasv2 thetasv2w

			bysort groupcom t: gen ctycount = _N
			keep  ccode groupcom  rhoFsv3 omegasv3  rhoFsv3w omegasv3w  ///
				rho1sv sigmasv rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij  sector t ///
				rho_start rhow_start  omeg_start omegw_start   ssvhat_omegSAG ssvwhat_omeSAG ctycount
				
			*remove duplicates (data repeats by source country)
			collapse (mean)  rhoFsv3 omegasv3  rhoFsv3w omegasv3w   ///
						rho1sv sigmasv  rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij sector ///
						rho_start rhow_start  omeg_start omegw_start  ssvhat_omegSAG ssvwhat_omeSAG  ///
				(max) ctycount , by(groupcom t)
				
			qui tab groupcom , gen(g_I)
			*Average X variable set by good 
			foreach var of varlist x1sv_ij x2sv_ij  {
			regress `var' g_I* , noc
			predict `var'hat 
			}	

			gen sigma_data = 0
			gen ones = 1 


			gen sqr_ctycount = sqrt(ctycount)
			foreach var of varlist ysv_ij x1sv_ijhat  x2sv_ijhat {
			replace `var' = `var'*sqr_ctycount
			}

			foreach var of varlist  ysv_ij x1sv_ijhat x2sv_ijhat ones {
			gen `var'_weighted=`var'/ ssvhat_omegSAG 
			gen `var'_weightedw=`var'/ssvwhat_omeSAG
			}				
			  
			save boot_weightedready_aggomeg_secdefsector.dta, replace
			*generate a temp sector for each sec def as before
			egen tempsec = group(sector)
			sum tempsec
			local secnum = r(max)

			*Generage indicator for disaggragate data which has a value of zero in this dataset		 
			gen sigma_data_weighted = 0
			gen	sigma_data_weightedw = 0

			save boot_weightedready_aggomeg_secdefsector.dta, replace
			append using boot_weightedready_sigdata_secdefsector.dta

			foreach var of varlist x3sv_ijhat_weighted x4sv_ijhat_weighted x5sv_jhat_weighted x3sv_ijhat_weightedw x4sv_ijhat_weightedw x5sv_jhat_weightedw {
			replace `var'=0 if `var' ==.
			}

			keep  groupcom  sector ysv_ij_weighted x1sv_ijhat_weighted x2sv_ijhat_weighted  ///
						x3sv_ijhat_weighted x4sv_ijhat_weighted x5sv_jhat_weighted  ///
						ysv_ij_weightedw x1sv_ijhat_weightedw x2sv_ijhat_weightedw  ///
						x3sv_ijhat_weightedw x4sv_ijhat_weightedw x5sv_jhat_weightedw  ///
						ones_weighted  ones_weightedw rho1sv sigmasv  /// 
						rho1svw sigmasvw  omegasv3 omegasv3w rhoFsv3 ///
						rhoFsv3w sigma_data_weighted  sigma_data_weightedw  ///
						rho_start rhow_start  omeg_start omegw_start sigma_data

			save boot_stacked_sig_omeg_ready_weighted.dta, replace

										*RE-ESTIMATE WEIGHTED DATA
							*************************************************
							*     RUN SECOND STAGE STACKED BY SECTORS       *
							*************************************************

			use boot_stacked_sig_omeg_ready_weighted.dta, clear
			egen tempsec = group(sector)
			sum tempsec
			local secnum = r(max)
			*record median omega estimates incase sector specific measures or negative
			sum omeg_start,d
			local omega_median = r(p50)
			sum omegw_start,d
			local omegaw_median = r(p50)

			save boot_stacked_sig_omeg_ready_weighted_sector.dta, replace
			*Now Regression for sectors separately, 
			*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
			forvalues i=1/`secnum' {
			use boot_stacked_sig_omeg_ready_weighted_sector.dta if tempsec == `i', replace 

			if omeg_start > 0 {
				local omega = omeg_start 
				}
			if omegw_start > 0 {
				local omegaw =omegw_start
				}
			if omeg_start < 0 {
				local omega = `omega_median' 
				}
			if omegw_start < 0 {
				local omegaw = `omega_median' 
				}

			local rho = rho_start
			local rhow = rhow_start

			noi display "SECOND STAGE NL ESTIMATION STACKED WEIGHTED: SECTOR `i' SEC DEF sector"
			*SV Stacked
			 cap nl (ysv_ij_weighted  = (rho1sv/((sigmasv-1)^2*(1-rho1sv)))*x1sv_ijhat_weighted*(sigma_data)  +  ///
				((2*rho1sv-1)/((sigmasv-1)*(1-rho1sv)))*x2sv_ijhat_weighted*(sigma_data) +  ///
				 (1-{omegasv})* (1+rho1sv/{rhoFsv} -2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat_weighted*(sigma_data) +   ///
				 (1-{omegasv})*(rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat_weighted*(sigma_data) +   ///
				 (rho1sv-rho1sv/{rhoFsv})*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat_weighted*(sigma_data) +   ///
				 ({rhoFsv})/(({omegasv}-1)^2*(1-{rhoFsv}))*x1sv_ijhat_weighted*(1-sigma_data)   +  ///
				 (2*{rhoFsv}-1)/(({omegasv}-1)*(1-{rhoFsv}))*x2sv_ijhat_weighted*(1-sigma_data )  + ///
				 {constantsv4}*ones_weighted  + {constantsv3}*sigma_data_weighted   ///
			   ), iterate(500) initial( omegasv `omega' rhoFsv `rho')
			   
			gen converge3 = e(converge)
			replace omegasv3=_b[/omegasv]
			scalar omegasvsescalar=_se[/omegasv]
			gen omegasvse3=omegasvsescalar
			replace rhoFsv3=_b[/rhoFsv]
			gen constantsv3=_b[/constantsv3]
			gen constantsv4=_b[/constantsv4]
			mkmat sector converge3  constantsv3 constantsv4 rhoFsv3 omegasv3 omegasvse3 in 1/1, matrix(wnlSVsector)
			matrix nlsvs_weightedsector=nullmat(nlsvs_weightedsector)\wnlSVsector

			*SVw Stacked
			 cap  nl (ysv_ij_weightedw  = (rho1svw/((sigmasvw-1)^2*(1-rho1svw)))*x1sv_ijhat_weightedw*(sigma_data)  +  ///
				((2*rho1svw-1)/((sigmasvw-1)*(1-rho1svw)))*x2sv_ijhat_weightedw*(sigma_data)  +  ///
				 (1-{omegasv})* (1+rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat_weightedw*(sigma_data) +   ///
				 (1-{omegasv})*(rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat_weightedw*(sigma_data) +   ///
				 (rho1svw-rho1svw/{rhoFsvw})*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat_weightedw*(sigma_data) +   ///
				 ({rhoFsvw})/(({omegasv}-1)^2*(1-{rhoFsvw}))*x1sv_ijhat_weightedw*(1-sigma_data)   +  ///
				 (2*{rhoFsvw}-1)/(({omegasv}-1)*(1-{rhoFsvw}))*x2sv_ijhat_weightedw*(1-sigma_data)  + ///
				 {constantsv4}*ones_weightedw  + {constantsv3}*sigma_data_weightedw    ///
			   ), iterate(500) initial( omegasv `omegaw' rhoFsvw `rhow')
			   
			gen converge3w = e(converge)
			replace omegasv3w=_b[/omegasv]
			scalar omegasvsescalarw=_se[/omegasv]
			gen omegasvse3w=omegasvsescalar
			replace rhoFsv3w=_b[/rhoFsvw]
			gen constantsv3w=_b[/constantsv3]
			gen constantsv4w=_b[/constantsv4]
			mkmat converge3w  constantsv3w constantsv4w rhoFsv3w omegasv3w omegasvse3w in 1/1, matrix(wnlSVwsector)
			matrix nlsvws_weightedsector=nullmat(nlsvws_weightedsector)\wnlSVwsector

			} 	

			drop _all
			svmat nlsvs_weightedsector, names(col)
			svmat nlsvws_weightedsector, names(col)
			sort sector
			duplicates drop 
			gen bootrep = `k'
			gen bootnestrep= `l'
			save "bootdata/boot_Final_Weighted_Stackedsector_`k'_nest_`l'.dta", replace

			noisily di "*********** END NONLINEAR STAGE2 **********"
		}
	}
}	
}
********** BOOTSTRAP END ***********

}


use "bootdata/boot_sigma_estimation_robust_1_nest_0", replace
cap forvalues tier1 = 2/100 {
cap forvalues tier2 = 1/50
	cap append using "bootdata/boot_sigma_estimation_robust_`tier1'_nest_`tier2'"
		cap replace bootrep = `tier1' if bootrep ==.
		cap replace bootnestrep = `tier2' if bootnestrep ==.

}
save "bootdata/boot_sigma_estimation_robust.dta", replace



 foreach sec in  `sector_list' {
use "bootdata/boot_Final_Unweighted_Unstackedsector_1_nest_0.dta", replace
cap forvalues tiers = 2/100 {
	cap append using "bootdata/boot_Final_Unweighted_Unstackedsector_`tier1'_nest_`tier2'.dta"
		cap replace bootrep = `tier1' if bootrep ==.
				cap replace bootnestrep = `tier2' if bootnestrep ==.


	}
save "bootdata/boot_omega_Unweighted_Unstacked_sector.dta", replace

}

 foreach sec in  `sector_list' {
use "bootdata/boot_Final_Weighted_Unstackedsector_1_nest_0.dta", replace
cap forvalues tiers = 2/100 {
	cap append using "bootdata/boot_Final_Unweighted_Unstackedsector_`tier1'_nest_`tier2'.dta"
		cap replace bootrep = `tier1' if bootrep ==.
				cap replace bootnestrep = `tier2' if bootnestrep ==.


	}
save "bootdata/boot_omega_Weighted_Unstacked_sector.dta", replace

}

 foreach sec in  `sector_list' {
use "bootdata/boot_Final_Unweighted_Stackedsector_1_nest_0.dta", replace
cap forvalues tiers = 2/100 {
	cap append using "bootdata/boot_Final_Unweighted_Stackedsector_`tier1'_nest_`tier2'.dta"
		cap replace bootrep = `tier1' if bootrep ==.
				cap replace bootnestrep = `tier2' if bootnestrep ==.


	}
save "bootdata/boot_omega_Unweighted_Stacked_sector.dta", replace

}

foreach sec in  `sector_list' {
use "bootdata/boot_Final_Weighted_Stackedsector_1_nest_0.dta", replace
cap forvalues tiers = 2/100 {
	cap append using "bootdata/boot_Final_Weighted_Stackedsector_`tier1'_nest_`tier2'.dta"
		cap replace bootrep = `tier1' if bootrep ==.
				cap replace bootnestrep = `tier2' if bootnestrep ==.


	}
save "bootdata/boot_omega_Weighted_Stacked_`sec'.dta", replace

}



