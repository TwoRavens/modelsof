/*********************************************************************
*Code written for: In Search of the Armington Elasticity by Feenstra, Luck, Obstefeld and Russ
*Contact: Philip Luck <philip.luck@ucdenver.edu>
*Date: January 2017 
******************************************************************
1. This code provides point estimates for all parameters to be estimated as follows:
	1.1 Implements Feenstra (1994)'s method to estimate the elasticity of substitution among imports
		The estimate of sigma using both 2sls and 2-step GMM
	1.2. Second, using nonlinear estimation to estimate the elasticity of substitution between foreign goods and home goods
	1.3. Third, using "stacked" nonlinear estimation to estimate the elasticity of substitution between foreign goods 
		 and home goods with aggregate moment condition.
*********************************************************************/


******************************************************************
*	1. First, implements Feenstra (1994)'s method to estimate the elasticity of substitution among imports
******************************************************************
*There are two steps in the first stage.
*First 2SLS IV and generate error terms
*Second, using the error terms, generate weights and re-run the OLS
clear all
clear matrix 
set more off 
set matsize 11000
clear matrix

*Assign directory where files are stored:
global directory ="/"

*Set Directory 
cd "$directory/FLOR_ARCHIVE/"

*Make sure product function is installed
cap net inst "http://www.stata.com/stb/stb51/dm71.pkg"
cap net install  "http://www.stata-journal.com/software/sj5-4/st0030_2.pkg"

******************************************************************
*             1.1 The estimate of sigma using 2sls and 2-step GMM
******************************************************************
*Load Data:
use Data/ready.dta, clear
*Generate variables
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif )^2
gen x1sv_ij = (ls_ij_dif   - ls_fj_dif )^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif )*(ls_ij_dif -ls_fj_dif )

drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . 
*Define loopindustry to loop over industries(in the results, report groupcom number instead of the industry number)
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

*2SLS IV
forvalues i=1/`indnum' {
	preserve
	keep if loopindustry==`i'
	*for Sato-Vartia price indicator
	qui tab ccode, gen(c_I_) 
	foreach var of varlist x1sv_ij x2sv_ij {
		gen `var'hat = `var'
		sum `var'hat if loopind == `i'
		*replace `var'hat = `var'hat - r(mean) if loopind == `i'
		}
	*Run 2sls regression for sigma
	ivregress 2sls  ysv_ij (x1sv_ijhat x2sv_ijhat = c_I_*) ,  small 

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
	mkmat  groupcom industrycountry thetasv1 thetasv2 rho1sv sigmasv sigmasvse , matrix(SV`i')
	matrix bSV`i'=nullmat(bSV`i')\SV`i'

	* Generate optimal weights
	gen uhatsv = ysv_ij - conssv - thetasv1 * x1sv_ij - thetasv2 * x2sv_ij
	
	* Generate squared error term: we subtract the mean of error by country and good. 
	egen uhatsvmean = mean(uhatsv)
	replace uhatsv = uhatsv-uhatsvmean
		
	gen uhatsv2=uhatsv^2
	drop if uhatsv2==.
	qui regress uhatsv2 c_I_*, noc
	predict uhatsv2hat
	gen ssvhat=sqrt(uhatsv2hat)

	* Weight data and reestimate 
	gen ones=1
	foreach var of varlist ysv_ij  x1sv_ijhat x2sv_ijhat ones {
		gen `var'svstar = `var'/ssvhat
		}
		
	ivregress 2sls ysv_ijsvstar onessvstar (x1sv_ijhatsvstar x2sv_ijhatsvstar = c_I_*) , small noc
	gen thetasv1w=_b[x1sv_ijhatsvstar ]
	gen thetasv2w=_b[x2sv_ijhatsvstar ]
	estat vce			
	gen rho1svw = .5 + sqrt(.25 - 1/(4+thetasv2w^2/thetasv1w)) if thetasv2w>0
	replace rho1svw = .5 - sqrt(.25 - 1/(4+thetasv2w^2/thetasv1w)) if thetasv2w<0
	gen sigmasvw = 1 + (2*rho1svw-1)/((1-rho1svw)*thetasv2w)
	sum groupcom num thetasv1w thetasv2w rho1svw sigmasvw

	*standard error of sigma using delta method (not used in published version of the paper)
	cap gen sigmasvwse=0
	cap if  thetasv2w >0 {
		testnl 1 + (2* (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) -1)/((1- (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) )* _b[x2sv_ijhatsvstar ] )=0
		replace sigmasvwse=sigmasvw/sqrt(r(F))
	}
	cap if   thetasv2w<0 {
		testnl 1 + (2* (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) -1)/((1- (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) )* _b[x2sv_ijhatsvstar ] )=0
		replace sigmasvwse=sigmasvw/sqrt(r(F))
	}
	
	mkmat thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse ssvhat , matrix(SVw`i')
	matrix bSVw`i'=nullmat(bSVw`i')\SVw`i'
	restore
	
}

forvalues i=1/`indnum' {
	drop _all
	svmat bSV`i', names(col)
	svmat bSVw`i', names(col)
	sort groupcom
	save sigma_est_2sls_`i'.dta, replace
	}

use sigma_est_2sls_1.dta
forvalues i=1/`indnum' {
	append using sigma_est_2sls_`i'.dta, 
	}
	
preserve
	keep industrycountry  ssvhat
	rename ssvhat ssvhat_sig
	duplicates drop
	save sigma_est_2sls_forBS.dta, replace
restore

forvalues i=1/`indnum' {
	erase sigma_est_2sls_`i'.dta
	}

drop industrycountry ssvhat

duplicates drop 
sort groupcom
save Data/Results/sigma_est_2sls.dta, replace

*************************************************************************
*  1.2  Using nonlinear estimation to estimate the elasticity of substitution 
* 		between foreign goods and home goods. There two steps for this stage of estimation:
*			1.2.1  Run nonlinear regressions and generate error terms
*			1.2.2  Using the error terms to generate weights and re-run the weighted nonlinear regressions
***************************************************************************

* 1.2.1  Run nonlinear regressions and generate error terms
clear matrix 
*Using results 
use Data/ready.dta, clear
sort groupcom
merge m:1 groupcom using sigma_est_2sls.dta
keep if _merge==3
drop _merge
gen one=1
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif)^2
gen x1sv_ij = (ls_ij_dif - ls_jj_dif)^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
gen x3sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
gen x4sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
gen x5sv_j =  (lpsv_fj_dif - lpsv_jj_dif )^2

drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 
drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
gen sigma_data = 1

save tempdata/ready_resultstemp, replace

*****************************************
*     RUN SECOND STAGE BY SECTORS       *
*****************************************
preserve 
use sector.dta, clear
sort groupcom
save sector.dta, replace
restore

use tempdata/ready_resultstemp, clear
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
cap forvalues j=1/`indnum' {
tab ccode if tempind==`j' , gen(c_I)
	*Demean X variable set
	foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
		regress `var' c_I* if tempind==`j' & sigma_data ==1 , noc
		predict `var'hat1 if tempind==`j' & sigma_data ==1
		replace `var'hat  = `var'hat1 if tempind==`j'
		drop `var'hat1
	}
drop c_I*
}	

egen tempsec = group(sector)
*egen  countrygood =group(groupcom ccode)
save tempdata/ready_sig_results_sector, replace


sum tempsec
local secnum = r(max)
*Now Regression for sectors separately, 
*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
forvalues i=1/`secnum' {
	use ready_sig_results_sector if tempsec == `i', replace 
	noi display "SECOND STAGE NL ESTIMATION UNSTACKED UNWEIGHTED: SECTOR `i'"
	*SV
	 cap nl (ysv_ij  =  thetasv1 * x1sv_ijhat + thetasv2 * x2sv_ijhat + ///
		 (1-{omegasv})* (1+(rho1sv/{rhoFsv})-2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat  +   ///
		 (1-{omegasv})*((rho1sv/{rhoFsv})-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat +     ///
		 (rho1sv-(rho1sv/{rhoFsv}))*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat  +     ///
				 {constant}* one ///
	   ), iterate(500)  initial ( rhoFsv 1) 
	  
	cap gen converge2 = e(converge)
	gen omegasv2=_b[/omegasv]
	scalar omegasvsescalar=_se[/omegasv]
	gen omegasvse2=omegasvsescalar
	cap gen rhoFsv2=_b[/rhoFsv]
	cap gen rho2sv2=rho1sv/rhoFsv2
	gen constantsv2=_b[/constant]
	mkmat sector constantsv2 rho2sv2 rhoFsv2   omegasv2 omegasvse2 in 1/1, matrix(nlSVsector)
	matrix nlsvssector=nullmat(nlsvssector)\nlSVsector
	   
	 cap nl (ysv_ij  =  thetasv1w * x1sv_ijhat + thetasv2w * x2sv_ijhat + ///
		 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat  +   ///
		 (1-{omegasv})*(rho1sv/{rhoFsv}-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat +     ///
		 (rho1svw-rho1sv/{rhoFsv})*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat  +     ///
				 {constant}* one ///
	   ), iterate(500) initial ( rhoFsv 1)  
	   
	cap gen converge2 = e(converge)
	gen omegasv2w=_b[/omegasv]
	scalar omegasvsescalarw=_se[/omegasv]
	gen omegasvse2w=omegasvsescalar
	cap gen rhoFsv2w=_b[/rhoFsv]
	cap gen rho2sv2w=rho1svw/rhoFsv2w
	gen constantsv2w=_b[/constant]
	mkmat one constantsv2w rho2sv2w rhoFsv2w omegasv2w omegasvse2w in 1/1, matrix(nlSVwsector)
	matrix nlsvswsector=nullmat(nlsvswsector)\nlSVwsector	   		      
} 

drop _all
svmat nlsvssector, names(col)
svmat nlsvswsector, names(col)
sort sector
duplicates drop 
save Data/Results/Final_Unweighted_Unstackedsector.dta, replace

*Combine Unweighted Omega Estimates with Sigma Estimates
clear
clear matrix 
use sector.dta
sort sector
merge m:1 sector using Final_Unweighted_Unstackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge groupcom using sigma_est_2sls.dta
keep if _merge ==3
drop _merge
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==.  
sort  groupcom
save twostagecombined_secdefsector.dta, replace

*Reconstruct dataset combined with sigma and omega estimates to weight and reestimate
use ready.dta, clear
sort groupcom
merge groupcom using twostagecombined_secdefsector.dta
tab _merge
drop if _merge==1
drop _merge

*Generate variables
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif)^2
gen x1sv_ij = (ls_ij_dif - ls_jj_dif)^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
gen x3sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
gen x4sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
gen x5sv_j =  (lpsv_fj_dif - lpsv_jj_dif )^2
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 

*Construct theta set  
gen thetasv3  =(1-omegasv2)* (1+rho1sv/rhoFsv2-2*rho1sv)/((sigmasv-1)*(1-rho1sv))
gen thetasv4  =(1-omegasv2)*(rho1sv/rhoFsv2-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))
gen thetasv5  =(1-omegasv2)^2*(rho1sv-rho1sv/rhoFsv2)/((sigmasv-1)^2*(1-rho1sv))
gen thetasv3w =(1-omegasv2w)*(1+rho1svw/rhoFsv2w-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))
gen thetasv4w =(1-omegasv2w)*(rho1svw/rhoFsv2w-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))
gen thetasv5w =(1-omegasv2w)^2*(rho1svw-rho1svw/rhoFsv2w)/((sigmasvw-1)^2*(1-rho1svw))

*Generates weights
gen uhatsv= ysv_ij - thetasv1 * x1sv_ij - thetasv2* x2sv_ij - ///
			thetasv3 * x3sv_ij - thetasv4 * x4sv_ij - thetasv5 * x5sv_j - constantsv2
gen uhatsvw= ysv_ij - thetasv1w * x1sv_ij - thetasv2w* x2sv_ij - ///
			thetasv3w * x3sv_ij - thetasv4w * x4sv_ij - thetasv5w * x5sv_j - constantsv2w
gen uhatsv2 =.
gen uhatsvw2=.

*Generate squared error term: note, we have the option to subtract the mean of error by country and good.
foreach var of varlist uhatsv uhatsvw {
		bysort groupcom ccode: egen `var'mean = mean(`var')
		replace `var' = `var'-`var'mean
		replace `var'2=`var'^2 
		drop if `var'2==. 
}

keep  ysv_ij x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j  uhatsv2 uhatsvw2 ///
	  groupcom ccode thetasv1 thetasv2 rho1sv sigmasv sigmasvse   /// 
	  thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse  omegasv2  ///
	  omegasv2w rho2sv2 rho2sv2w rhoFsv2 rhoFsv2w year  industrycountry
	  
save ready_theta_secdefsector.dta, replace	
*Weighted Regressions for sectors separately
use  ready_theta_secdefsector.dta, clear
sort groupcom
merge groupcom using sector.dta
tab _merge
drop if _merge==2
drop _merge
tab sector
*generate a temp sector for each sec def as before

keep  groupcom  sector ccode thetasv1 thetasv2 rho1sv sigmasv sigmasvse  ///
		thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse uhatsv2 uhatsvw2  ///
	     ysv_ij x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j   industrycountry  ///
		  omegasv2 omegasv2w rho2sv2 rho2sv2w rhoFsv2 rhoFsv2w  year  	 

* Regress X vector on country indicators 
sort industrycountry
foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
	gen `var'hat=.
	}
	
gen ssvhat= .	
gen ssvwhat= .	
egen tempind = group(groupcom)
sum tempind
local indnum = r(max)	
cap forvalues j=1/`indnum' {
	tab ccode if tempind==`j' , gen(c_I)
	*Demean X variable set
	foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
		regress `var' c_I* if tempind==`j' , noc
		predict `var'hat1 if tempind==`j' 
		sum `var' if tempind==`j' 
		*replace `var'hat = `var'hat1-r(mean) if tempind==`j'
		replace `var'hat  = `var'hat1 if tempind==`j'
		drop `var'hat1
	}
	qui regress uhatsv2 c_I* if tempind==`j', noc
	predict uhatsv2hat if tempind==`j'
	qui regress uhatsvw2 c_I* if tempind==`j', noc
	predict uhatsvw2hat if tempind==`j'
	replace ssvhat=sqrt(uhatsv2hat) if tempind==`j'
	replace ssvwhat=sqrt(uhatsvw2hat) if tempind==`j'
	drop c_I* uhatsv2hat uhatsvw2hat
}	

gen ones =1
*Record weights for use in bootstrap
preserve
	keep  industrycountry groupcom ssvhat ssvwhat 
	rename ssvhat ssvhat_omeg
	rename ssvwhat ssvwhat_omeg
	duplicates drop
	save omegaweighted_est_2sls_forBS.dta, replace
restore

********** WEIGHT DATA BY VARIANCE*********;
********************************************
	foreach var of varlist  ysv_ij x1sv_ijhat x2sv_ijhat x3sv_ijhat x4sv_ijhat x5sv_jhat ones {
	gen `var'_weighted=`var'/ssvhat
	gen `var'_weightedw=`var'/ssvwhat
	}
egen tempsec = group(sector)
sum tempsec
local secnum = r(max)
qui sum omegasv2,d
local omega_median = r(p50)
qui sum omegasv2w,d
local omegaw_median = r(p50)

save weightedready_secdefsector.dta, replace
**********      RE-ESTIMATE       *********;
********************************************
*Now Regression for sectors separately, 
*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
  forvalues i=1/`secnum' {
	use weightedready_secdefsector.dta if tempsec == `i', replace 
	if omegasv2 > 0 {
		local omega = omegasv2 
		}
	if omegasv2w > 0 {
		local omegaw =omegasv2w		
		}
	if omegasv2 < 0 {
		local omega = `omega_median' 
		}
	if omegasv2w < 0 {
		local omegaw = `omega_median' 
		}
	local rhoF = rhoFsv2
	local rhoFw = rhoFsv2w
	
	noi display "SECOND STAGE NL ESTIMATION UNSTACKED WEIGHTED: SECTOR `i'"
	*SV
	nl (ysv_ij_weighted  =  thetasv1 * x1sv_ijhat_weighted + thetasv2 * x2sv_ijhat_weighted + ///
		 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat_weighted  +   ///
		 (1-{omegasv})*((rho1sv/{rhoFsv})-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat_weighted +     ///
		 (rho1sv-(rho1sv/{rhoFsv}))*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat_weighted  +     ///
				 {constant}* ones_weighted ///
	   ), iterate(500) initial (omegasv `omega' rhoFsv `rhoF')  
	   
	cap gen converge2 = e(converge)
	replace omegasv2=_b[/omegasv]
	scalar omegasvsescalar=_se[/omegasv]
	gen omegasvse2=omegasvsescalar
	cap gen rhoFsv2=_b[/rhoFsv]
	cap gen rhoFsvse2=_se[/rhoFsv]
	cap gen rho2sv2=rho1sv/rhoFsv2
	gen constantsv2=_b[/constant]
	mkmat  industrycountry groupcom ssvhat ssvwhat sector converge2 constantsv2 rho2sv2 rhoFsv2 rhoFsvse2 omegasv2 omegasvse2 in 1/1, matrix(nlSVsector)
	matrix nlsvs_weightedsector=nullmat(nlsvs_weightedsector)\nlSVsector
	   
	nl (ysv_ij_weightedw  =  thetasv1w * x1sv_ijhat_weightedw  + thetasv2w * x2sv_ijhat_weightedw  + ///
		 (1-{omegasv})* (1+rho1svw/{rhoFsv}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat_weightedw   +   ///
		 (1-{omegasv})*((rho1svw/{rhoFsv})-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat_weightedw  +     ///
		 (rho1svw-(rho1svw/{rhoFsv}))*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat_weightedw   +     ///
				 {constant}*ones_weightedw ///
	   ), iterate(500) initial (omegasv `omegaw' rhoFsv `rhoFw') 
   
	cap gen convergew2 = e(converge)
	replace omegasv2w=_b[/omegasv]
	scalar omegasvsescalarw=_se[/omegasv]
	gen omegasvse2w=omegasvsescalar
	cap gen rhoFsv2w=_b[/rhoFsv]
	cap gen rhoFsvse2w=_se[/rhoFsv]
	cap gen rho2sv2w=rho1svw/rhoFsv2w
	gen constantsv2w=_b[/constant]
	mkmat convergew2 constantsv2w rho2sv2w  rhoFsv2w  rhoFsvse2w omegasv2w omegasvse2w  in 1/1, matrix(wnlSVwsector)
	matrix nlsvsw_weightedsector=nullmat(nlsvsw_weightedsector)\wnlSVwsector		   		      
	}
	
drop _all
svmat nlsvs_weightedsector, names(col)
svmat nlsvsw_weightedsector, names(col)
sort sector
duplicates drop
save Final_Weighted_Unstackedsector.dta, replace
***************************************************************************
*           1.3 using nonlinear estimation to estimate the elasticity of substitution with Stacked System
***************************************************************************
clear all
clear matrix 
********************************************
*				STACK DATA
*******************************************
*Construct disaggragate data
use sector.dta, clear
sort sector
merge m:1 sector using Final_Unweighted_Unstackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge groupcom using sigma_est_2sls.dta
keep if _merge ==3
drop _merge
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==. 
sort  groupcom
save unw_unstkd_estsector.dta, replace

*Reconstruct dataset combined with sigma and omega estimates to weight and reestimate
use /*********************************************************************
*Code written for: In Search of the Armington Elasticity by Feenstra, Luck, Obstefeld and Russ
*Contact: Philip Luck <philip.luck@ucdenver.edu>
*Date: January 2017 
******************************************************************
1. This code provides point estimates for all parameters to be estimated as follows:
	1.1 Implements Feenstra (1994)'s method to estimate the elasticity of substitution among imports
		The estimate of sigma using both 2sls and 2-step GMM
	1.2. Second, using nonlinear estimation to estimate the elasticity of substitution between foreign goods and home goods
	1.3. Third, using "stacked" nonlinear estimation to estimate the elasticity of substitution between foreign goods 
		 and home goods with aggregate moment condition.
*********************************************************************/


******************************************************************
*	1. First, implements Feenstra (1994)'s method to estimate the elasticity of substitution among imports
******************************************************************
*There are two steps in the first stage.
*First 2SLS IV and generate error terms
*Second, using the error terms, generate weights and re-run the OLS
clear all
clear matrix 
set more off 
set matsize 11000
clear matrix

*Create folders to store results
global directory ="/"

*Set Directory 
cd "$directory/FLOR_ARCHIVE/"

*Make sure product function is installed
cap net inst "http://www.stata.com/stb/stb51/dm71.pkg"
cap net install  "http://www.stata-journal.com/software/sj5-4/st0030_2.pkg"

******************************************************************
*             1.1 The estimate of sigma using 2sls and 2-step GMM
******************************************************************
*Load Data:
use Data/ready.dta, clear
*Generate variables
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif )^2
gen x1sv_ij = (ls_ij_dif   - ls_fj_dif )^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif )*(ls_ij_dif -ls_fj_dif )

drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . 
*Define loopindustry to loop over industries(in the results, report groupcom number instead of the industry number)
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

*2SLS IV
forvalues i=1/`indnum' {
	preserve
	keep if loopindustry==`i'
	*for Sato-Vartia price indicator
	qui tab ccode, gen(c_I_) 
	foreach var of varlist x1sv_ij x2sv_ij {
		gen `var'hat = `var'
		sum `var'hat if loopind == `i'
		*replace `var'hat = `var'hat - r(mean) if loopind == `i'
		}
	*Run 2sls regression for sigma
	ivregress 2sls  ysv_ij (x1sv_ijhat x2sv_ijhat = c_I_*) ,  small 

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
	mkmat  groupcom industrycountry thetasv1 thetasv2 rho1sv sigmasv sigmasvse , matrix(SV`i')
	matrix bSV`i'=nullmat(bSV`i')\SV`i'

	* Generate optimal weights
	gen uhatsv = ysv_ij - conssv - thetasv1 * x1sv_ij - thetasv2 * x2sv_ij
	
	* Generate squared error term: we subtract the mean of error by country and good. 
	egen uhatsvmean = mean(uhatsv)
	replace uhatsv = uhatsv-uhatsvmean
		
	gen uhatsv2=uhatsv^2
	drop if uhatsv2==.
	qui regress uhatsv2 c_I_*, noc
	predict uhatsv2hat
	gen ssvhat=sqrt(uhatsv2hat)

	* Weight data and reestimate 
	gen ones=1
	foreach var of varlist ysv_ij  x1sv_ijhat x2sv_ijhat ones {
		gen `var'svstar = `var'/ssvhat
		}
		
	ivregress 2sls ysv_ijsvstar onessvstar (x1sv_ijhatsvstar x2sv_ijhatsvstar = c_I_*) , small noc
	gen thetasv1w=_b[x1sv_ijhatsvstar ]
	gen thetasv2w=_b[x2sv_ijhatsvstar ]
	estat vce			
	gen rho1svw = .5 + sqrt(.25 - 1/(4+thetasv2w^2/thetasv1w)) if thetasv2w>0
	replace rho1svw = .5 - sqrt(.25 - 1/(4+thetasv2w^2/thetasv1w)) if thetasv2w<0
	gen sigmasvw = 1 + (2*rho1svw-1)/((1-rho1svw)*thetasv2w)
	sum groupcom num thetasv1w thetasv2w rho1svw sigmasvw

	*standard error of sigma using delta method (not used in published version of the paper)
	cap gen sigmasvwse=0
	cap if  thetasv2w >0 {
		testnl 1 + (2* (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) -1)/((1- (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) )* _b[x2sv_ijhatsvstar ] )=0
		replace sigmasvwse=sigmasvw/sqrt(r(F))
	}
	cap if   thetasv2w<0 {
		testnl 1 + (2* (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) -1)/((1- (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) )* _b[x2sv_ijhatsvstar ] )=0
		replace sigmasvwse=sigmasvw/sqrt(r(F))
	}
	
	mkmat thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse ssvhat , matrix(SVw`i')
	matrix bSVw`i'=nullmat(bSVw`i')\SVw`i'
	restore
	
}

forvalues i=1/`indnum' {
	drop _all
	svmat bSV`i', names(col)
	svmat bSVw`i', names(col)
	sort groupcom
	save sigma_est_2sls_`i'.dta, replace
	}

use sigma_est_2sls_1.dta
forvalues i=1/`indnum' {
	append using sigma_est_2sls_`i'.dta, 
	}
	
preserve
	keep industrycountry  ssvhat
	rename ssvhat ssvhat_sig
	duplicates drop
	save sigma_est_2sls_forBS.dta, replace
restore

forvalues i=1/`indnum' {
	erase sigma_est_2sls_`i'.dta
	}

drop industrycountry ssvhat

duplicates drop 
sort groupcom
save Data/Results/sigma_est_2sls.dta, replace

*************************************************************************
*  1.2  Using nonlinear estimation to estimate the elasticity of substitution 
* 		between foreign goods and home goods. There two steps for this stage of estimation:
*			1.2.1  Run nonlinear regressions and generate error terms
*			1.2.2  Using the error terms to generate weights and re-run the weighted nonlinear regressions
***************************************************************************

* 1.2.1  Run nonlinear regressions and generate error terms
clear matrix 
*Using results 
use Data/ready.dta, clear
sort groupcom
merge m:1 groupcom using sigma_est_2sls.dta
keep if _merge==3
drop _merge
gen one=1
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif)^2
gen x1sv_ij = (ls_ij_dif - ls_jj_dif)^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
gen x3sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
gen x4sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
gen x5sv_j =  (lpsv_fj_dif - lpsv_jj_dif )^2

drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 
drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
gen sigma_data = 1

save tempdata/ready_resultstemp, replace

*****************************************
*     RUN SECOND STAGE BY SECTORS       *
*****************************************
preserve 
use sector.dta, clear
sort groupcom
save sector.dta, replace
restore

use tempdata/ready_resultstemp, clear
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
cap forvalues j=1/`indnum' {
tab ccode if tempind==`j' , gen(c_I)
	*Demean X variable set
	foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
		regress `var' c_I* if tempind==`j' & sigma_data ==1 , noc
		predict `var'hat1 if tempind==`j' & sigma_data ==1
		replace `var'hat  = `var'hat1 if tempind==`j'
		drop `var'hat1
	}
drop c_I*
}	

egen tempsec = group(sector)
*egen  countrygood =group(groupcom ccode)
save tempdata/ready_sig_results_sector, replace


sum tempsec
local secnum = r(max)
*Now Regression for sectors separately, 
*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
forvalues i=1/`secnum' {
	use ready_sig_results_sector if tempsec == `i', replace 
	noi display "SECOND STAGE NL ESTIMATION UNSTACKED UNWEIGHTED: SECTOR `i'"
	*SV
	 cap nl (ysv_ij  =  thetasv1 * x1sv_ijhat + thetasv2 * x2sv_ijhat + ///
		 (1-{omegasv})* (1+(rho1sv/{rhoFsv})-2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat  +   ///
		 (1-{omegasv})*((rho1sv/{rhoFsv})-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat +     ///
		 (rho1sv-(rho1sv/{rhoFsv}))*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat  +     ///
				 {constant}* one ///
	   ), iterate(500)  initial ( rhoFsv 1) 
	  
	cap gen converge2 = e(converge)
	gen omegasv2=_b[/omegasv]
	scalar omegasvsescalar=_se[/omegasv]
	gen omegasvse2=omegasvsescalar
	cap gen rhoFsv2=_b[/rhoFsv]
	cap gen rho2sv2=rho1sv/rhoFsv2
	gen constantsv2=_b[/constant]
	mkmat sector constantsv2 rho2sv2 rhoFsv2   omegasv2 omegasvse2 in 1/1, matrix(nlSVsector)
	matrix nlsvssector=nullmat(nlsvssector)\nlSVsector
	   
	 cap nl (ysv_ij  =  thetasv1w * x1sv_ijhat + thetasv2w * x2sv_ijhat + ///
		 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat  +   ///
		 (1-{omegasv})*(rho1sv/{rhoFsv}-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat +     ///
		 (rho1svw-rho1sv/{rhoFsv})*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat  +     ///
				 {constant}* one ///
	   ), iterate(500) initial ( rhoFsv 1)  
	   
	cap gen converge2 = e(converge)
	gen omegasv2w=_b[/omegasv]
	scalar omegasvsescalarw=_se[/omegasv]
	gen omegasvse2w=omegasvsescalar
	cap gen rhoFsv2w=_b[/rhoFsv]
	cap gen rho2sv2w=rho1svw/rhoFsv2w
	gen constantsv2w=_b[/constant]
	mkmat one constantsv2w rho2sv2w rhoFsv2w omegasv2w omegasvse2w in 1/1, matrix(nlSVwsector)
	matrix nlsvswsector=nullmat(nlsvswsector)\nlSVwsector	   		      
} 

drop _all
svmat nlsvssector, names(col)
svmat nlsvswsector, names(col)
sort sector
duplicates drop 
save Data/Results/Final_Unweighted_Unstackedsector.dta, replace

*Combine Unweighted Omega Estimates with Sigma Estimates
clear
clear matrix 
use sector.dta
sort sector
merge m:1 sector using Final_Unweighted_Unstackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge groupcom using sigma_est_2sls.dta
keep if _merge ==3
drop _merge
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==.  
sort  groupcom
save twostagecombined_secdefsector.dta, replace

*Reconstruct dataset combined with sigma and omega estimates to weight and reestimate
use ready.dta, clear
sort groupcom
merge groupcom using twostagecombined_secdefsector.dta
tab _merge
drop if _merge==1
drop _merge

*Generate variables
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif)^2
gen x1sv_ij = (ls_ij_dif - ls_jj_dif)^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
gen x3sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
gen x4sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
gen x5sv_j =  (lpsv_fj_dif - lpsv_jj_dif )^2
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 

*Construct theta set  
gen thetasv3  =(1-omegasv2)* (1+rho1sv/rhoFsv2-2*rho1sv)/((sigmasv-1)*(1-rho1sv))
gen thetasv4  =(1-omegasv2)*(rho1sv/rhoFsv2-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))
gen thetasv5  =(1-omegasv2)^2*(rho1sv-rho1sv/rhoFsv2)/((sigmasv-1)^2*(1-rho1sv))
gen thetasv3w =(1-omegasv2w)*(1+rho1svw/rhoFsv2w-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))
gen thetasv4w =(1-omegasv2w)*(rho1svw/rhoFsv2w-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))
gen thetasv5w =(1-omegasv2w)^2*(rho1svw-rho1svw/rhoFsv2w)/((sigmasvw-1)^2*(1-rho1svw))

*Generates weights
gen uhatsv= ysv_ij - thetasv1 * x1sv_ij - thetasv2* x2sv_ij - ///
			thetasv3 * x3sv_ij - thetasv4 * x4sv_ij - thetasv5 * x5sv_j - constantsv2
gen uhatsvw= ysv_ij - thetasv1w * x1sv_ij - thetasv2w* x2sv_ij - ///
			thetasv3w * x3sv_ij - thetasv4w * x4sv_ij - thetasv5w * x5sv_j - constantsv2w
gen uhatsv2 =.
gen uhatsvw2=.

*Generate squared error term: note, we have the option to subtract the mean of error by country and good.
foreach var of varlist uhatsv uhatsvw {
		bysort groupcom ccode: egen `var'mean = mean(`var')
		replace `var' = `var'-`var'mean
		replace `var'2=`var'^2 
		drop if `var'2==. 
}

keep  ysv_ij x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j  uhatsv2 uhatsvw2 ///
	  groupcom ccode thetasv1 thetasv2 rho1sv sigmasv sigmasvse   /// 
	  thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse  omegasv2  ///
	  omegasv2w rho2sv2 rho2sv2w rhoFsv2 rhoFsv2w year  industrycountry
	  
save ready_theta_secdefsector.dta, replace	
*Weighted Regressions for sectors separately
use  ready_theta_secdefsector.dta, clear
sort groupcom
merge groupcom using sector.dta
tab _merge
drop if _merge==2
drop _merge
tab sector
*generate a temp sector for each sec def as before

keep  groupcom  sector ccode thetasv1 thetasv2 rho1sv sigmasv sigmasvse  ///
		thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse uhatsv2 uhatsvw2  ///
	     ysv_ij x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j   industrycountry  ///
		  omegasv2 omegasv2w rho2sv2 rho2sv2w rhoFsv2 rhoFsv2w  year  	 

* Regress X vector on country indicators 
sort industrycountry
foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
	gen `var'hat=.
	}
	
gen ssvhat= .	
gen ssvwhat= .	
egen tempind = group(groupcom)
sum tempind
local indnum = r(max)	
cap forvalues j=1/`indnum' {
	tab ccode if tempind==`j' , gen(c_I)
	*Demean X variable set
	foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
		regress `var' c_I* if tempind==`j' , noc
		predict `var'hat1 if tempind==`j' 
		sum `var' if tempind==`j' 
		*replace `var'hat = `var'hat1-r(mean) if tempind==`j'
		replace `var'hat  = `var'hat1 if tempind==`j'
		drop `var'hat1
	}
	qui regress uhatsv2 c_I* if tempind==`j', noc
	predict uhatsv2hat if tempind==`j'
	qui regress uhatsvw2 c_I* if tempind==`j', noc
	predict uhatsvw2hat if tempind==`j'
	replace ssvhat=sqrt(uhatsv2hat) if tempind==`j'
	replace ssvwhat=sqrt(uhatsvw2hat) if tempind==`j'
	drop c_I* uhatsv2hat uhatsvw2hat
}	

gen ones =1
*Record weights for use in bootstrap
preserve
	keep  industrycountry groupcom ssvhat ssvwhat 
	rename ssvhat ssvhat_omeg
	rename ssvwhat ssvwhat_omeg
	duplicates drop
	save omegaweighted_est_2sls_forBS.dta, replace
restore

********** WEIGHT DATA BY VARIANCE*********;
********************************************
	foreach var of varlist  ysv_ij x1sv_ijhat x2sv_ijhat x3sv_ijhat x4sv_ijhat x5sv_jhat ones {
	gen `var'_weighted=`var'/ssvhat
	gen `var'_weightedw=`var'/ssvwhat
	}
egen tempsec = group(sector)
sum tempsec
local secnum = r(max)
qui sum omegasv2,d
local omega_median = r(p50)
qui sum omegasv2w,d
local omegaw_median = r(p50)

save weightedready_secdefsector.dta, replace
**********      RE-ESTIMATE       *********;
********************************************
*Now Regression for sectors separately, 
*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
  forvalues i=1/`secnum' {
	use weightedready_secdefsector.dta if tempsec == `i', replace 
	if omegasv2 > 0 {
		local omega = omegasv2 
		}
	if omegasv2w > 0 {
		local omegaw =omegasv2w		
		}
	if omegasv2 < 0 {
		local omega = `omega_median' 
		}
	if omegasv2w < 0 {
		local omegaw = `omega_median' 
		}
	local rhoF = rhoFsv2
	local rhoFw = rhoFsv2w
	
	noi display "SECOND STAGE NL ESTIMATION UNSTACKED WEIGHTED: SECTOR `i'"
	*SV
	nl (ysv_ij_weighted  =  thetasv1 * x1sv_ijhat_weighted + thetasv2 * x2sv_ijhat_weighted + ///
		 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat_weighted  +   ///
		 (1-{omegasv})*((rho1sv/{rhoFsv})-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat_weighted +     ///
		 (rho1sv-(rho1sv/{rhoFsv}))*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat_weighted  +     ///
				 {constant}* ones_weighted ///
	   ), iterate(500) initial (omegasv `omega' rhoFsv `rhoF')  
	   
	cap gen converge2 = e(converge)
	replace omegasv2=_b[/omegasv]
	scalar omegasvsescalar=_se[/omegasv]
	gen omegasvse2=omegasvsescalar
	cap gen rhoFsv2=_b[/rhoFsv]
	cap gen rhoFsvse2=_se[/rhoFsv]
	cap gen rho2sv2=rho1sv/rhoFsv2
	gen constantsv2=_b[/constant]
	mkmat  industrycountry groupcom ssvhat ssvwhat sector converge2 constantsv2 rho2sv2 rhoFsv2 rhoFsvse2 omegasv2 omegasvse2 in 1/1, matrix(nlSVsector)
	matrix nlsvs_weightedsector=nullmat(nlsvs_weightedsector)\nlSVsector
	   
	nl (ysv_ij_weightedw  =  thetasv1w * x1sv_ijhat_weightedw  + thetasv2w * x2sv_ijhat_weightedw  + ///
		 (1-{omegasv})* (1+rho1svw/{rhoFsv}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat_weightedw   +   ///
		 (1-{omegasv})*((rho1svw/{rhoFsv})-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat_weightedw  +     ///
		 (rho1svw-(rho1svw/{rhoFsv}))*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat_weightedw   +     ///
				 {constant}*ones_weightedw ///
	   ), iterate(500) initial (omegasv `omegaw' rhoFsv `rhoFw') 
   
	cap gen convergew2 = e(converge)
	replace omegasv2w=_b[/omegasv]
	scalar omegasvsescalarw=_se[/omegasv]
	gen omegasvse2w=omegasvsescalar
	cap gen rhoFsv2w=_b[/rhoFsv]
	cap gen rhoFsvse2w=_se[/rhoFsv]
	cap gen rho2sv2w=rho1svw/rhoFsv2w
	gen constantsv2w=_b[/constant]
	mkmat convergew2 constantsv2w rho2sv2w  rhoFsv2w  rhoFsvse2w omegasv2w omegasvse2w  in 1/1, matrix(wnlSVwsector)
	matrix nlsvsw_weightedsector=nullmat(nlsvsw_weightedsector)\wnlSVwsector		   		      
	}
	
drop _all
svmat nlsvs_weightedsector, names(col)
svmat nlsvsw_weightedsector, names(col)
sort sector
duplicates drop
save Final_Weighted_Unstackedsector.dta, replace
***************************************************************************
*           1.3 using nonlinear estimation to estimate the elasticity of substitution with Stacked System
***************************************************************************
clear all
clear matrix 
********************************************
*				STACK DATA
*******************************************
*Construct disaggragate data
use sector.dta, clear
sort sector
merge m:1 sector using Final_Unweighted_Unstackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge groupcom using sigma_est_2sls.dta
keep if _merge ==3
drop _merge
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==. 
sort  groupcom
save unw_unstkd_estsector.dta, replace

*Reconstruct dataset combined with sigma and omega estimates to weight and reestimate
use ready_revised.dta, clear
sort groupcom
merge groupcom using unw_unstkd_estsector.dta
tab _merge
drop if _merge==1
drop _merge

*Generate variables
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif)^2
gen x1sv_ij = (ls_ij_dif - ls_jj_dif)^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
gen x3sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
gen x4sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
gen x5sv_j =  (lpsv_fj_dif - lpsv_jj_dif )^2
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 

*Regress X vector on country indicators 
	sort industrycountry
	foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
		gen `var'hat=.
		}
		
	egen tempind = group(groupcom)
	sum tempind
	local indnum = r(max)	
	cap forvalues j=1/`indnum' {
	tab ccode if tempind==`j' , gen(c_I)
		*Demean X variable set
		foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
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
keep  ccode industrycountry groupcom  rho2sv2 rhoFsv2 omegasv2  rho2sv2w  rhoFsv2w omegasv2w  ///
	rho1sv sigmasv rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij x3sv_ij x4sv_ij x5sv_j ///
	 sigma_data sector t ysv_ij  x1sv_ijhat  x2sv_ijhat x3sv_ijhat x4sv_ijhat x5sv_jhat	  year
 
save ready_sig_omeg_data.dta, replace
*******************************
*Construct Aggregate Data	
*******************************						
use ready_revised.dta, clear
sort groupcom
merge groupcom using unw_unstkd_estsector.dta,
tab _merge
drop if _merge==1
drop _merge
gen ysv_ij  = (lpsv_fj_dif -lpsv_jj_dif )^2
gen x1sv_ij = (ls_fj_dif -ls_jj_dif )^2
gen x2sv_ij = (lpsv_fj_dif -lpsv_jj_dif )*(ls_fj_dif -ls_jj_dif )
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . 
gen sigma_data = 0

foreach var of varlist ysv_ij x1sv_ij x2sv_ij {
		gen `var'hat= `var'
		}
			
*OPTION 4	
bysort groupcom t: gen ctycount = _N

keep  ccode industrycountry groupcom  rho2sv2 rhoFsv2 omegasv2  rho2sv2w rhoFsv2w omegasv2w  ///
		rho1sv sigmasv rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij   ///
		sigma_data  sector t ctycount  year

*remove duplicates (data repeats by source country)
collapse (mean)  rho2sv2  rhoFsv2 omegasv2 rho2sv2w rhoFsv2w omegasv2w sigma_data             ///
				rho1sv sigmasv  rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij  ///
				sector year (max) ctycount , by(groupcom t)

* Regress X vector on good indicators 
foreach var of varlist  x1sv_ij x2sv_ij {
	gen `var'hat=.
	}
tab groupcom , gen(g_I)

*Average X variable set by Good
foreach var of varlist x1sv_ij x2sv_ij  {
	regress `var' g_I* , noc
	predict `var'hat1 
	replace `var'hat = `var'hat1
	drop `var'hat1 
}
	
drop g_I*
gen sqr_ctycount = sqrt(ctycount)
foreach var of varlist ysv_ij x1sv_ijhat  x2sv_ijhat {
		replace `var' = `var'*sqr_ctycount
		}
 
append using ready_sig_omeg_data.dta

foreach var of varlist x3sv_ij x4sv_ij x5sv_j x3sv_ijhat x4sv_ijhat x5sv_jhat {
	replace `var'=0 if `var' ==.
}

save stacked_sig_omeg_ready.dta, replace
*************************************************
*     RUN SECOND STAGE STACKED BY SECTORS       *
*************************************************
use stacked_sig_omeg_ready.dta, clear
egen good_strata = group(groupcom sigma_data)
egen tempsec = group(sector)
sum tempsec
local secnum = r(max)
save stacked_sig_omeg_ready_sector.dta, replace

qui sum omegasv2,d
local omega_median = r(p50)
qui sum omegasv2w,d
local omegaw_median = r(p50)
*Now Regression for sectors separately, 
*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
 forvalues i=1/`secnum' {
	use stacked_sig_omeg_ready_sector if tempsec == `i', replace 
	
	if omegasv2 > 0 {
		local omega = omegasv2 
		}
	if omegasv2 < 0 {
		local omega = `omega_median'
		}
	local rhoF = rhoFsv2
	
	gen ones =1
	noi display "SECOND STAGE NL ESTIMATION STACKED UNWEIGHTED: SECTOR `i'"
	*SV Stacked
	nl (ysv_ij = (rho1sv/((sigmasv-1)^2*(1-rho1sv)))*x1sv_ijhat*(sigma_data)  +  ///
		((2*rho1sv-1)/((sigmasv-1)*(1-rho1sv)))*x2sv_ijhat*(sigma_data)  +  ///
		 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat*(sigma_data ) +   ///
		 (1-{omegasv})*(rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat*(sigma_data ) +   ///
		 (rho1sv-rho1sv/{rhoFsv})*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat*(sigma_data ) +   ///
		 ({rhoFsv})/(({omegasv}-1)^2*(1-{rhoFsv}))*x1sv_ijhat*(1-sigma_data)   +  ///
		 (2*{rhoFsv}-1)/(({omegasv}-1)*(1-{rhoFsv}))*x2sv_ijhat*(1-sigma_data )  + ///
		 {constantsv4}*ones  + {constantsv3}*sigma_data   ///
	   ), iterate(500) initial( omegasv `omega' rhoFsv `rhoF') 
   
	gen converge3 = e(converge)
	gen omegasv3=_b[/omegasv]
	scalar omegasvsescalar=_se[/omegasv]
	gen omegasvse3=omegasvsescalar
	cap gen rhoFsv3=_b[/rhoFsv]
	gen rho2sv3 =rho1sv/rhoFsv3
	gen constantsv3=_b[/constantsv3]
	gen constantsv4=_b[/constantsv4]
	mkmat sector converge3  constantsv3 constantsv4 rho2sv3  rhoFsv3 omegasv3 omegasvse3 in 1/1, matrix(nlSVsector)
	matrix nlsvssector=nullmat(nlsvssector)\nlSVsector
	
	if omegasv2w > 0 {
		local omegaw =omegasv2w		
		}
	if omegasv2w < 0 {
		local omegaw = `omega_median' 
		}
	local rhoFw = rhoFsv2w
	*SVw Stacked
	nl (ysv_ij  = (rho1svw/((sigmasvw-1)^2*(1-rho1svw)))*x1sv_ijhat*(sigma_data)  +  ///
		((2*rho1svw-1)/((sigmasvw-1)*(1-rho1svw)))*x2sv_ijhat*(sigma_data)  +  ///
		 (1-{omegasv})* (1+rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat*(sigma_data ) +   ///
		 (1-{omegasv})*(rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat*(sigma_data ) +   ///
		 (rho1svw-rho1svw/{rhoFsvw})*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat*(sigma_data ) +   ///
		 ({rhoFsvw})/(({omegasv}-1)^2*(1-{rhoFsvw}))*x1sv_ijhat*(1-sigma_data)   +  ///
		 (2*{rhoFsvw}-1)/(({omegasv}-1)*(1-{rhoFsvw}))*x2sv_ijhat*(1-sigma_data )  + ///
		 {constantsv4}*ones  + {constantsv3}*sigma_data   ///
	   ), iterate(500) initial( omegasv `omegaw' rhoFsvw `rhoFw' )  
   	
	gen converge3w = e(converge)
	gen omegasv3w=_b[/omegasv]
	scalar omegasvsescalarw=_se[/omegasv]
	gen omegasvse3w=omegasvsescalar
	cap gen rhoFsv3w=_b[/rhoFsvw]
	cap gen rho2sv3w =rho1svw/rhoFsv3w
	gen constantsv3w=_b[/constantsv3]
	gen constantsv4w=_b[/constantsv4]
	
	mkmat converge3w  constantsv3w constantsv4w rho2sv3w rhoFsv3w omegasv3w omegasvse3w in 1/1, matrix(nlSVwsector)
	matrix nlsvwssector=nullmat(nlsvwssector)\nlSVwsector
} 	

drop _all
svmat nlsvssector, names(col)
svmat nlsvwssector, names(col)
sort sector
duplicates drop 
save Final_Unweighted_Stackedsector.dta, replace

					**********************************************
					*     WEIGHT DATA BY MEASURE OF VARIANCE     *
					**********************************************
****************                DISAGGREGATED DATA                      *******************
*Combine Unweighted Omega Estimates with Sigma Estimates to construct error based weights

clear
use sector.dta
sort sector
merge m:1 sector using Final_Unweighted_Stackedsector.dta
tab _merge
drop _merge
sort  groupcom
duplicates report groupcom
merge m:1 groupcom using sigma_est_2sls.dta
tab _merge
drop _merge
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==.
sort  groupcom
save unw_stkd_estsector.dta, replace

*Reconstruct dataset combined with sigma and omega estimates to weight and reestimate
use ready_revised.dta, clear
sort groupcom
merge m:1 groupcom using unw_stkd_estsector.dta
tab _merge
drop if _merge==1
drop _merge

*Generate variables
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif)^2
gen x1sv_ij = (ls_ij_dif - ls_jj_dif)^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
gen x3sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
gen x4sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
gen x5sv_j  = (lpsv_fj_dif - lpsv_jj_dif )^2
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 

*Construct theta set
gen thetasv3  =(1-omegasv3)* (1+rho1sv/rhoFsv3-2*rho1sv)/((sigmasv-1)*(1-rho1sv))
gen thetasv4  =(1-omegasv3)*(rho1sv/rhoFsv3-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))
gen thetasv5  =(1-omegasv3)^2*(rho1sv-rho1sv/rhoFsv3)/((sigmasv-1)^2*(1-rho1sv))
gen thetasv3w =(1-omegasv3w)* (1+rho1svw/rhoFsv3w-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))
gen thetasv4w =(1-omegasv3w)*(rho1svw/rhoFsv3w-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))
gen thetasv5w =(1-omegasv3w)^2*(rho1svw-rho1svw/rhoFsv3w)/((sigmasvw-1)^2*(1-rho1svw))

*Generates weights
gen uhatsv= ysv_ij - thetasv1 * x1sv_ij - thetasv2* x2sv_ij - thetasv3 * x3sv_ij ///
			- thetasv4 * x4sv_ij - thetasv5 * x5sv_j -  constantsv3 -  constantsv4
gen uhatsvw= ysv_ij - thetasv1w * x1sv_ij - thetasv2w* x2sv_ij - thetasv3w * x3sv_ij ///
			- thetasv4w * x4sv_ij -  thetasv5w * x5sv_j -  constantsv3w -  constantsv4w
gen uhatsv2 =.
gen uhatsvw2=.

*Generate squared error term: note, we have the option to subtract the mean of error by country and good.
foreach var of varlist uhatsv uhatsvw {
			bysort groupcom ccode: egen `var'mean = mean(`var')
			replace `var' = `var'-`var'mean
		replace `var'2=`var'^2 
		drop if `var'2==. 
}
		
* Regress X vector on country indicators 
foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j {
	gen `var'hat=.
	}
gen ssvhat =.
gen ssvwhat =.

egen tempind = group(groupcom)
sum tempind
local indnum = r(max)	
cap forvalues j=1/`indnum' {
tab ccode if tempind==`j' , gen(c_I)
	*Demean X variable set and average by source country and good
	foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
		regress `var' c_I* if tempind==`j' , noc
		predict `var'hat1 if tempind==`j' 
		sum `var' if tempind==`j'
		*replace `var'hat = `var'hat1-r(mean)  if tempind==`j'
		replace `var'hat = `var'hat1 if tempind==`j'
		drop `var'hat1
	}
	qui regress uhatsv2 c_I* if tempind==`j', noc
	predict uhatsv2hat if tempind==`j'
	qui regress uhatsvw2 c_I* if tempind==`j', noc
	predict uhatsvw2hat if tempind==`j'
	replace ssvhat=sqrt(uhatsv2hat) if tempind==`j'
	replace ssvwhat=sqrt(uhatsvw2hat) if tempind==`j'
	drop c_I* uhatsv2hat uhatsvw2hat
}			
 gen ones = 1
 gen sigma_data = 1

foreach var of varlist ysv_ij x1sv_ijhat x2sv_ijhat x3sv_ijhat x4sv_ijhat x5sv_jhat ones sigma_data {
	gen `var'_weighted=`var'/ssvhat
	gen `var'_weightedw=`var'/ssvwhat
	}	  

*Record weights for use in bootstrap
preserve
	keep  industrycountry groupcom ssvhat ssvwhat 
	rename ssvhat ssvhat_omegS
	rename ssvwhat ssvwhat_omeS
	duplicates drop
	save omega_weights_stacked_sector_2sls_forBS.dta, replace
restore
	

keep  groupcom  sector ysv_ij_weighted x1sv_ijhat_weighted x2sv_ijhat_weighted  ///
				x3sv_ijhat_weighted x4sv_ijhat_weighted x5sv_jhat_weighted  ones_weighted ///
				ysv_ij_weightedw x1sv_ijhat_weightedw x2sv_ijhat_weightedw  ///
				x3sv_ijhat_weightedw x4sv_ijhat_weightedw x5sv_jhat_weightedw  ones_weightedw ///
				 rho1sv sigmasv uhatsv2 uhatsvw2  /// 
				 rho1svw sigmasvw  omegasv3 omegasv3w rho2sv3  ssvhat ssvwhat ///
				rho2sv3w  rhoFsv3 rhoFsv3w  sigma_data_weighted sigma_data_weightedw  year
				
				
save weightedready_sigdata_secdefsector.dta, replace
****************                AGGREGATED DATA                      *******************

use ready_revised.dta, clear
sort groupcom
merge groupcom using unw_stkd_estsector.dta
tab _merge
drop if _merge==1
drop _merge
*Generate Aggragate variables
gen ysv_ij  = (lpsv_fj_dif -lpsv_jj_dif )^2
gen x1sv_ij = (ls_fj_dif -ls_jj_dif )^2
gen x2sv_ij = (lpsv_fj_dif -lpsv_jj_dif )*(ls_fj_dif -ls_jj_dif )
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . 
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==. 

sort  groupcom
drop thetasv1 thetasv1w thetasv2 thetasv2w
*Construct theta set
gen thetasv1  = (rhoFsv3)/((omegasv3-1)^2*(1-rhoFsv3))
gen thetasv2  = (2*(rhoFsv3)-1)/((omegasv3-1)*(1-rhoFsv3))
gen thetasv1w  = (rhoFsv3w)/((omegasv3w-1)^2*(1-rhoFsv3w))
gen thetasv2w  = (2*(rhoFsv3w)-1)/((omegasv3w-1)*(1-rhoFsv3w))
	
*OPTION 4	
bysort groupcom t: gen ctycount = _N

keep  ccode groupcom  rho2sv3 omegasv3  rho2sv3w omegasv3w  ///
rho1sv sigmasv rho1svw sigmasvw  rhoFsv3 rhoFsv3w ysv_ij  x1sv_ij  x2sv_ij  sector t  year ctycount

*remove duplicates (data repeats by source country)
collapse (mean)  rho2sv3 omegasv3  rho2sv3w omegasv3w   rhoFsv3 rhoFsv3w  ///
rho1sv sigmasv  rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij sector  year (max) ctycount , by(groupcom t)


tab groupcom , gen(g_I)
*Average X variable set by good 
foreach var of varlist x1sv_ij x2sv_ij  {
	regress `var' g_I* , noc
	predict `var'hat 
}	
 
drop g_I*
gen sqr_ctycount = sqrt(ctycount)
foreach var of varlist ysv_ij x1sv_ijhat  x2sv_ijhat {
		replace `var' = `var'*sqr_ctycount
		}
		
gen sigma_data = 0
gen ones = 1 

foreach var of varlist  ysv_ij x1sv_ijhat x2sv_ijhat ones {
	gen `var'_weighted=`var'
	gen `var'_weightedw=`var'
	}		
	

save weightedready_aggomeg_secdefsector.dta, replace
*generate a temp sector for each sec def as before
egen tempsec = group(sector)
sum tempsec
local secnum = r(max)

*Generage indicator for disaggragate data which has a value of zero in this dataset		 
gen sigma_data_weighted = 0
gen sigma_data_weightedw =0
save weightedready_aggomeg_secdefsector.dta, replace
append using weightedready_sigdata_secdefsector.dta

foreach var of varlist x3sv_ijhat_weighted x4sv_ijhat_weighted x5sv_jhat_weighted x3sv_ijhat_weightedw x4sv_ijhat_weightedw x5sv_jhat_weightedw {
	replace `var'=0 if `var' ==.
}

replace sigma_data = 1 if sigma_data ==.
************************************
**********REPLACE WEIGHTS***********
************************************
sum ssvhat if sigma_data ==1
replace ssvhat = r(mean) if sigma_data==0
sum ssvwhat if sigma_data ==1
replace ssvwhat = r(mean) if sigma_data==0

*Record weights for use in bootstrap
preserve
	keep if sigma_data==0
	keep  groupcom ssvhat ssvwhat 
	rename ssvhat ssvhat_omegSAG
	rename ssvwhat ssvwhat_omeSAG
	duplicates drop
	save ag_omega_weights_stacked_sector_2sls_forBS.dta, replace
restore
 

*Replace with averaged weight
foreach var of varlist  ysv_ij x1sv_ijhat x2sv_ijhat ones {
	replace `var'_weighted=`var'/ssvhat if sigma_data==0
	replace `var'_weightedw=`var'/ssvwhat if sigma_data==0
	}
************************************
**********REPLACE WEIGHTS***********
************************************

keep  groupcom  sector ysv_ij_weighted x1sv_ijhat_weighted x2sv_ijhat_weighted  ///
				x3sv_ijhat_weighted x4sv_ijhat_weighted x5sv_jhat_weighted ///
				ysv_ij_weightedw x1sv_ijhat_weightedw x2sv_ijhat_weightedw  ///
				x3sv_ijhat_weightedw x4sv_ijhat_weightedw x5sv_jhat_weightedw ///
				 ones_weighted rho1sv sigmasv uhatsv2 uhatsvw2  /// 
				rho1svw sigmasvw  omegasv3 omegasv3w rho2sv3 ///
				rho2sv3w sigma_data_weighted sigma_data_weightedw   rhoFsv3 rhoFsv3w  ssvhat ssvwhat  year sigma_data
				
	
replace sigma_data = 1 if sigma_data ==.
save stacked_sig_omeg_ready_weighted.dta, replace

			*RE-ESTIMATE WEIGHTED DATA
*************************************************
*     RUN SECOND STAGE STACKED BY SECTORS       *
*************************************************

use stacked_sig_omeg_ready_weighted.dta, clear
egen good_strata = group(groupcom sigma_data)
egen tempsec = group(sector)
sum tempsec
local secnum = r(max)
*record median omega estimates incase sector specific measures or negative
qui sum omegasv3,d
local omega_median = r(p50)
qui sum omegasv3w,d
local omegaw_median = r(p50)
save stacked_sig_omeg_ready_weighted_sector.dta, replace
*Now Regression for sectors separately, 
*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
 forvalues i=1/`secnum' {
	use stacked_sig_omeg_ready_weighted_sector.dta if tempsec == `i', replace 

	if omegasv3 > 0 {
		local omega = omegasv3 
		}
	if omegasv3 < 0 {
		local omega = `omega_median' 
		}
	local rhoF = rhoFsv3
	noi display "SECOND STAGE NL ESTIMATION STACKED WEIGHTED: SECTOR `i'"
	*SV Stacked
	 nl (ysv_ij_weighted  = (rho1sv/((sigmasv-1)^2*(1-rho1sv)))*x1sv_ijhat_weighted*(sigma_data)  +  ///
		((2*rho1sv-1)/((sigmasv-1)*(1-rho1sv)))*x2sv_ijhat_weighted*(sigma_data) +  ///
		 (1-{omegasv})* (1+rho1sv/{rhoFsv} -2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat_weighted*(sigma_data ) +   ///
		 (1-{omegasv})*(rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat_weighted*(sigma_data ) +   ///
		 (rho1sv-rho1sv/{rhoFsv})*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat_weighted*(sigma_data ) +   ///
		 ({rhoFsv})/(({omegasv}-1)^2*(1-{rhoFsv}))*x1sv_ijhat_weighted*(1-sigma_data)   +  ///
		 (2*{rhoFsv}-1)/(({omegasv}-1)*(1-{rhoFsv}))*x2sv_ijhat_weighted*(1-sigma_data )  + ///
		 {constantsv4}*ones_weighted  + {constantsv3}*sigma_data_weighted   ///
	   ), iterate(500) initial( omegasv `omega' rhoFsv `rhoF') 
 
	gen converge3 = e(converge)
	replace omegasv3=_b[/omegasv]
	scalar omegasvsescalar=_se[/omegasv]
	gen omegasvse3=omegasvsescalar
	replace rhoFsv3=_b[/rhoFsv]
	cap gen rho2sv3w =rho1svw/rhoFsv3w
	gen constantsv3=_b[/constantsv3]
	gen constantsv4=_b[/constantsv4]
	mkmat   sector converge3  constantsv3 constantsv4 rho2sv3 rhoFsv3 omegasv3 omegasvse3 in 1/1, matrix(wnlSVsector)
	matrix nlsvs_weightedsector=nullmat(nlsvs_weightedsector)\wnlSVsector
		
	if omegasv3w > 0 {
		local omegaw =omegasv3w		
		}
	if omegasv3w < 0 {
		local omegaw = `omega_median' 
		}
	local rhoFw = rhoFsv3w
	*SVw Stacked
     nl (ysv_ij_weightedw  = (rho1svw/((sigmasvw-1)^2*(1-rho1svw)))*x1sv_ijhat_weightedw*(sigma_data)  +  ///
		((2*rho1svw-1)/((sigmasvw-1)*(1-rho1svw)))*x2sv_ijhat_weightedw*(sigma_data)  +  ///
		 (1-{omegasv})* (1+rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat_weightedw*(sigma_data) +   ///
		 (1-{omegasv})*(rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat_weightedw*(sigma_data) +   ///
		 (rho1svw-rho1svw/{rhoFsvw})*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat_weightedw*(sigma_data) +   ///
		 ({rhoFsvw})/(({omegasv}-1)^2*(1-{rhoFsvw}))*x1sv_ijhat_weightedw*(1-sigma_data)   +  ///
		 (2*{rhoFsvw}-1)/(({omegasv}-1)*(1-{rhoFsvw}))*x2sv_ijhat_weightedw*(1-sigma_data)  + ///
		 {constantsv4}*ones_weighted  + {constantsv3}*sigma_data_weightedw    ///
	   ), iterate(500) initial( omegasv `omegaw' rhoFsvw  `rhoFw' )  
	  
   
	gen converge3w = e(converge)
	replace omegasv3w=_b[/omegasv]
	scalar omegasvsescalarw=_se[/omegasv]
	gen omegasvse3w=omegasvsescalar
	cap replace rhoFsv3w=_b[/rhoFsvw]
	cap replace  rho2sv3w =rho1svw/rhoFsv3w
	gen constantsv3w=_b[/constantsv3]
	gen constantsv4w=_b[/constantsv4]
	mkmat converge3w  constantsv3w constantsv4w rho2sv3w rhoFsv3w omegasv3w omegasvse3w  in 1/1 , matrix(wnlSVwsector)
	matrix nlsvws_weightedsector=nullmat(nlsvws_weightedsector)\wnlSVwsector
	} 	
	
drop _all
svmat nlsvs_weightedsector, names(col)
svmat nlsvws_weightedsector, names(col)
sort sector
duplicates drop 		
save Final_Weighted_Stackedsector.dta, replace


preserve
	use sigma_est_2sls_forBS.dta, clear
	merge 1:1 industrycountry using omegaweighted_est_2sls_forBS.dta
	drop _merge 
	merge 1:1  industrycountry using omega_weights_stacked_sector_2sls_forBS.dta
	drop _merge 
	merge m:1 groupcom using ag_omega_weights_stacked_sector_2sls_forBS.dta
	drop _merge 
	sort industrycountry groupcom
	save bootstrap_weights, replace
restore

*Save in date specific folder, for now:
*************************************
*CONSTRUCT BASIC TABLES
*Designate estimation method
*Stacked Unweighted results
use sector.dta, clear
sort sector
merge m:1 sector using Final_Unweighted_Unstackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge 1:1 groupcom using sigma_est_2sls.dta
keep if _merge == 3
drop _merge
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==. 
sort  groupcom
keep  sector groupcom  rho2sv2 ///
		omegasv2 omegasvse2 omegasv2w omegasvse2w constantsv2  ///
		rho1sv sigmasv sigmasvse  sigmasvw sigmasvwse  rho2sv2 rho2sv2w rhoFsv2 rhoFsv2w constantsv2  constantsv2w  
duplicates drop 

save Data/Results/Final_sig_omeg_Unweighted_Unstackedsector_2sls.dta, replace
use Data/Results/Final_sig_omeg_Unweighted_Unstackedsector_2sls.dta, clear
*Collapse data back to groupcom:
collapse  (mean) sector rho2sv2 omegasv2w omegasvse2w ///
		omegasv2 omegasvse2 constantsv2 ///
		rho1sv sigmasv sigmasvse, by (groupcom)

*number of goods of each sector (it is not sorted by sector since we combine sector 3 and 4 together)
bysort omegasv2: gen goodnumber=_N
*number of goods with sigma>omega
bysort omegasv2: egen sigma1_gt_omega2_sv=sum(sigmasv > omegasv2)
*number of goods with sigma>omega
bysort omegasv2w: egen sigma1_gt_omega2_svw=sum(sigmasv > omegasv2w)
collapse (mean) omegasv2 omegasvse2 omegasv2w omegasvse2w goodnumber ///
 sigma1_gt_omega2_sv sigma1_gt_omega2_svw, by(sector)
 order  sector goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv omegasv2w omegasvse2w sigma1_gt_omega2_svw 
 save Data/Results/Omega_v2Unweighted_Unstacked_sec_defsector_2sls.dta, replace

*Unstacked Weighted results
clear
use sector.dta
sort sector
merge m:1 sector using Final_Weighted_Unstackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge 1:1 groupcom using sigma_est_2sls.dta
keep if _merge == 3
drop _merge
drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
sort  groupcom
keep  sector groupcom omegasv2w omegasvse2w   ///
		 rho2sv2 omegasv2 omegasvse2  sigmasvw sigmasvwse  ///
		rho1sv sigmasv sigmasvse  sigmasvw sigmasvwse rho2sv2 rho2sv2w rhoFsv2 rhoFsv2w  constantsv2  constantsv2w ssvhat ssvwhat 
duplicates drop 

save Data/Results/Final_sig_omeg_Weighted_Unstackedsector_2sls.dta, replace
use Data/Results/Final_sig_omeg_Weighted_Unstackedsector_2sls.dta, clear
*Collapse data back to groupcom:
collapse  (mean) sector rho2sv2 omegasv2w omegasvse2w ///
		omegasv2 omegasvse2  sigmasvw sigmasvwse ///
		rho1sv sigmasv sigmasvse, by (groupcom)
*number of goods of each sector (it is not sorted by sector since we combine sector 3 and 4 together)
bysort omegasv2: gen goodnumber=_N
*number of goods with sigma>omega
bysort omegasv2: egen sigma1_gt_omega2_sv=sum(sigmasv > omegasv2)
*number of goods with sigma>omega
bysort omegasv2w: egen sigma1_gt_omega2_svw=sum(sigmasvw > omegasv2w)
collapse (mean) omegasv2 omegasvse2 omegasv2w omegasvse2w goodnumber ///
 sigma1_gt_omega2_sv sigma1_gt_omega2_svw, by(sector)
 order  sector  goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv omegasv2w omegasvse2w sigma1_gt_omega2_svw
save Data/Results/Omega_v2Weighted_Unstacked_sec_defsector_2sls.dta, replace


clear
use sector.dta
sort sector
merge m:1 sector using Final_Unweighted_Stackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge 1:1 groupcom using sigma_est_2sls.dta
keep if _merge == 3
drop _merge
drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
sort  groupcom
keep  sector groupcom  constantsv3 constantsv4 constantsv3w constantsv4w  ///
		 omegasv3 omegasvse3 omegasv3w omegasvse3w   ///
		 rho1sv  rho2sv3   rho2sv3w  rhoFsv3 rhoFsv3w   ///
		sigmasv sigmasvse  sigmasvw sigmasvwse  ///
		
duplicates drop 

save Data/Results/Final_sig_omeg_Unweighted_Stackedsector_2sls.dta, replace
use Data/Results/Final_sig_omeg_Unweighted_Stackedsector_2sls.dta, clear
*Collapse data back to groupcom:
collapse  (mean) sector rho2sv3 omegasv3w omegasvse3w ///
		omegasv3 omegasvse3  sigmasvw sigmasvwse ///
		rho1sv sigmasv sigmasvse, by (groupcom)
		
*Number of goods of each sector
bysort omegasv3: gen goodnumber=_N
*number of goods with sigma>omega
bysort omegasv3: egen sigma1_gt_omega3_sv=sum(sigmasv > omegasv3)
*number of goods with sigma>omega
bysort omegasv3w: egen sigma1_gt_omega3_svw=sum(sigmasvw > omegasv3w)
collapse (mean) omegasv3 omegasvse3 omegasv3w omegasvse3w goodnumber ///
 sigma1_gt_omega3_sv sigma1_gt_omega3_svw, by(sector)
 order  sector  goodnumber omegasv3 omegasvse3 sigma1_gt_omega3_sv omegasv3w omegasvse3w sigma1_gt_omega3_svw
save Data/Results/Omega_v2Unweighted_Stacked_sec_defsector_2sls.dta, replace


*Stacked Weighted results
clear
use sector.dta
sort sector
merge m:1 sector using Final_Weighted_Stackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge 1:1 groupcom using sigma_est_2sls.dta
keep if _merge == 3
drop _merge
drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
sort  groupcom
keep  sector groupcom  constantsv3 constantsv4 constantsv3w constantsv4w  ///
		 omegasv3 omegasvse3 omegasv3w omegasvse3w   ///
		 rho1sv  rho2sv3   rho2sv3w  rhoFsv3 rhoFsv3w  ///
		sigmasv sigmasvse  sigmasvw sigmasvwse  	
duplicates drop 
save Data/Results/Final_sig_omeg_Weighted_Stackedsector_2sls.dta, replace

use Data/Results/Final_sig_omeg_Weighted_Stackedsector_2sls.dta, clear
*Collapse data back to groupcom:
collapse  (mean) sector rho2sv3 omegasv3w omegasvse3w ///
		omegasv3 omegasvse3  ///
		rho1sv sigmasv sigmasvse  sigmasvw sigmasvwse, by (groupcom)
*Number of goods of each sector
bysort omegasv3: gen goodnumber=_N
*number of goods with sigma>omega
bysort omegasv3: egen sigma1_gt_omega3_sv=sum(sigmasv > omegasv3)
*number of goods with sigma>omega
bysort omegasv3w: egen sigma1_gt_omega3_svw=sum(sigmasvw > omegasv3w)
collapse (mean) omegasv3 omegasvse3 omegasv3w omegasvse3w goodnumber ///
 sigma1_gt_omega3_sv sigma1_gt_omega3_svw, by(sector)
 order  sector  goodnumber omegasv3 omegasvse3 sigma1_gt_omega3_sv omegasv3w omegasvse3w sigma1_gt_omega3_svw
save Data/Results/Omega_v2Weighted_Stacked_sec_defsector_2sls.dta, replace





*Compile estimates:
	use Data/Results/Omega_v2Unweighted_Unstacked_sec_defsector_2sls.dta,  clear
	keep  sector goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv 
	sort sector 
	save temp_data, replace
	
	use Data/Results/Omega_v2Weighted_Unstacked_sec_defsector_2sls.dta, clear
	keep sector omegasv2w omegasvse2w sigma1_gt_omega2_svw
	merge 1:1  sector using temp_data
	drop _merge
	order sector  goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv /// 
			omegasv2w omegasvse2w sigma1_gt_omega2_svw	
	sort sector 
	save temp_data, replace
	
	use Data/Results/Omega_v2Unweighted_Stacked_sec_defsector_2sls.dta,  clear
	keep sector omegasv3 omegasvse3 sigma1_gt_omega3_sv 
	merge 1:1 sector using temp_data
	drop _merge
	order sector  goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv ///
			omegasv2w omegasvse2w sigma1_gt_omega2_svw ///
			omegasv3 omegasvse3 sigma1_gt_omega3_sv 	
	sort sector 
	save temp_data, replace
	
	use  Data/Results/Omega_v2Weighted_Stacked_sec_defsector_2sls.dta, clear
	keep sector omegasv3w omegasvse3w sigma1_gt_omega3_svw
	merge 1:1 sector using temp_data
	drop _merge
	order sector  goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv ///
			omegasv2w omegasvse2w sigma1_gt_omega2_svw ///
			omegasv3 omegasvse3 sigma1_gt_omega3_sv ///
			omegasv3w omegasvse3w sigma1_gt_omega3_svw	
save Data/Results/Omega_v2_Full_results_2sls_sector.dta, replace		
		
	



/*********************************************************************
*Code written for: In Search of the Armington Elasticity by Feenstra, Luck, Obstefeld and Russ
*Contact: Philip Luck <philip.luck@ucdenver.edu>
*Date: January 2017 
******************************************************************
1. This code provides point estimates for all parameters to be estimated as follows:
	1.1 Implements Feenstra (1994)'s method to estimate the elasticity of substitution among imports
		The estimate of sigma using both 2sls and 2-step GMM
	1.2. Second, using nonlinear estimation to estimate the elasticity of substitution between foreign goods and home goods
	1.3. Third, using "stacked" nonlinear estimation to estimate the elasticity of substitution between foreign goods 
		 and home goods with aggregate moment condition.
*********************************************************************/


******************************************************************
*	1. First, implements Feenstra (1994)'s method to estimate the elasticity of substitution among imports
******************************************************************
*There are two steps in the first stage.
*First 2SLS IV and generate error terms
*Second, using the error terms, generate weights and re-run the OLS
clear all
clear matrix 
set more off 
set matsize 11000
clear matrix

*Create folders to store results
global directory ="/"

*Set Directory 
cd "$directory/FLOR_ARCHIVE/"

*Make sure product function is installed
cap net inst "http://www.stata.com/stb/stb51/dm71.pkg"
cap net install  "http://www.stata-journal.com/software/sj5-4/st0030_2.pkg"

******************************************************************
*             1.1 The estimate of sigma using 2sls and 2-step GMM
******************************************************************
*Load Data:
use Data/ready.dta, clear
*Generate variables
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif )^2
gen x1sv_ij = (ls_ij_dif   - ls_fj_dif )^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif )*(ls_ij_dif -ls_fj_dif )

drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . 
*Define loopindustry to loop over industries(in the results, report groupcom number instead of the industry number)
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

*2SLS IV
forvalues i=1/`indnum' {
	preserve
	keep if loopindustry==`i'
	*for Sato-Vartia price indicator
	qui tab ccode, gen(c_I_) 
	foreach var of varlist x1sv_ij x2sv_ij {
		gen `var'hat = `var'
		sum `var'hat if loopind == `i'
		*replace `var'hat = `var'hat - r(mean) if loopind == `i'
		}
	*Run 2sls regression for sigma
	ivregress 2sls  ysv_ij (x1sv_ijhat x2sv_ijhat = c_I_*) ,  small 

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
	mkmat  groupcom industrycountry thetasv1 thetasv2 rho1sv sigmasv sigmasvse , matrix(SV`i')
	matrix bSV`i'=nullmat(bSV`i')\SV`i'

	* Generate optimal weights
	gen uhatsv = ysv_ij - conssv - thetasv1 * x1sv_ij - thetasv2 * x2sv_ij
	
	* Generate squared error term: we subtract the mean of error by country and good. 
	egen uhatsvmean = mean(uhatsv)
	replace uhatsv = uhatsv-uhatsvmean
		
	gen uhatsv2=uhatsv^2
	drop if uhatsv2==.
	qui regress uhatsv2 c_I_*, noc
	predict uhatsv2hat
	gen ssvhat=sqrt(uhatsv2hat)

	* Weight data and reestimate 
	gen ones=1
	foreach var of varlist ysv_ij  x1sv_ijhat x2sv_ijhat ones {
		gen `var'svstar = `var'/ssvhat
		}
		
	ivregress 2sls ysv_ijsvstar onessvstar (x1sv_ijhatsvstar x2sv_ijhatsvstar = c_I_*) , small noc
	gen thetasv1w=_b[x1sv_ijhatsvstar ]
	gen thetasv2w=_b[x2sv_ijhatsvstar ]
	estat vce			
	gen rho1svw = .5 + sqrt(.25 - 1/(4+thetasv2w^2/thetasv1w)) if thetasv2w>0
	replace rho1svw = .5 - sqrt(.25 - 1/(4+thetasv2w^2/thetasv1w)) if thetasv2w<0
	gen sigmasvw = 1 + (2*rho1svw-1)/((1-rho1svw)*thetasv2w)
	sum groupcom num thetasv1w thetasv2w rho1svw sigmasvw

	*standard error of sigma using delta method (not used in published version of the paper)
	cap gen sigmasvwse=0
	cap if  thetasv2w >0 {
		testnl 1 + (2* (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) -1)/((1- (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) )* _b[x2sv_ijhatsvstar ] )=0
		replace sigmasvwse=sigmasvw/sqrt(r(F))
	}
	cap if   thetasv2w<0 {
		testnl 1 + (2* (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) -1)/((1- (.5 + sqrt(.25 - 1/(4+_b[x2sv_ijhatsvstar ]^2/_b[x1sv_ijhatsvstar ]))) )* _b[x2sv_ijhatsvstar ] )=0
		replace sigmasvwse=sigmasvw/sqrt(r(F))
	}
	
	mkmat thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse ssvhat , matrix(SVw`i')
	matrix bSVw`i'=nullmat(bSVw`i')\SVw`i'
	restore
	
}

forvalues i=1/`indnum' {
	drop _all
	svmat bSV`i', names(col)
	svmat bSVw`i', names(col)
	sort groupcom
	save sigma_est_2sls_`i'.dta, replace
	}

use sigma_est_2sls_1.dta
forvalues i=1/`indnum' {
	append using sigma_est_2sls_`i'.dta, 
	}
	
preserve
	keep industrycountry  ssvhat
	rename ssvhat ssvhat_sig
	duplicates drop
	save sigma_est_2sls_forBS.dta, replace
restore

forvalues i=1/`indnum' {
	erase sigma_est_2sls_`i'.dta
	}

drop industrycountry ssvhat

duplicates drop 
sort groupcom
save Data/Results/sigma_est_2sls.dta, replace

*************************************************************************
*  1.2  Using nonlinear estimation to estimate the elasticity of substitution 
* 		between foreign goods and home goods. There two steps for this stage of estimation:
*			1.2.1  Run nonlinear regressions and generate error terms
*			1.2.2  Using the error terms to generate weights and re-run the weighted nonlinear regressions
***************************************************************************

* 1.2.1  Run nonlinear regressions and generate error terms
clear matrix 
*Using results 
use Data/ready.dta, clear
sort groupcom
merge m:1 groupcom using sigma_est_2sls.dta
keep if _merge==3
drop _merge
gen one=1
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif)^2
gen x1sv_ij = (ls_ij_dif - ls_jj_dif)^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
gen x3sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
gen x4sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
gen x5sv_j =  (lpsv_fj_dif - lpsv_jj_dif )^2

drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 
drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
gen sigma_data = 1

save tempdata/ready_resultstemp, replace

*****************************************
*     RUN SECOND STAGE BY SECTORS       *
*****************************************
preserve 
use sector.dta, clear
sort groupcom
save sector.dta, replace
restore

use tempdata/ready_resultstemp, clear
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
cap forvalues j=1/`indnum' {
tab ccode if tempind==`j' , gen(c_I)
	*Demean X variable set
	foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
		regress `var' c_I* if tempind==`j' & sigma_data ==1 , noc
		predict `var'hat1 if tempind==`j' & sigma_data ==1
		replace `var'hat  = `var'hat1 if tempind==`j'
		drop `var'hat1
	}
drop c_I*
}	

egen tempsec = group(sector)
*egen  countrygood =group(groupcom ccode)
save tempdata/ready_sig_results_sector, replace


sum tempsec
local secnum = r(max)
*Now Regression for sectors separately, 
*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
forvalues i=1/`secnum' {
	use ready_sig_results_sector if tempsec == `i', replace 
	noi display "SECOND STAGE NL ESTIMATION UNSTACKED UNWEIGHTED: SECTOR `i'"
	*SV
	 cap nl (ysv_ij  =  thetasv1 * x1sv_ijhat + thetasv2 * x2sv_ijhat + ///
		 (1-{omegasv})* (1+(rho1sv/{rhoFsv})-2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat  +   ///
		 (1-{omegasv})*((rho1sv/{rhoFsv})-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat +     ///
		 (rho1sv-(rho1sv/{rhoFsv}))*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat  +     ///
				 {constant}* one ///
	   ), iterate(500)  initial ( rhoFsv 1) 
	  
	cap gen converge2 = e(converge)
	gen omegasv2=_b[/omegasv]
	scalar omegasvsescalar=_se[/omegasv]
	gen omegasvse2=omegasvsescalar
	cap gen rhoFsv2=_b[/rhoFsv]
	cap gen rho2sv2=rho1sv/rhoFsv2
	gen constantsv2=_b[/constant]
	mkmat sector constantsv2 rho2sv2 rhoFsv2   omegasv2 omegasvse2 in 1/1, matrix(nlSVsector)
	matrix nlsvssector=nullmat(nlsvssector)\nlSVsector
	   
	 cap nl (ysv_ij  =  thetasv1w * x1sv_ijhat + thetasv2w * x2sv_ijhat + ///
		 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat  +   ///
		 (1-{omegasv})*(rho1sv/{rhoFsv}-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat +     ///
		 (rho1svw-rho1sv/{rhoFsv})*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat  +     ///
				 {constant}* one ///
	   ), iterate(500) initial ( rhoFsv 1)  
	   
	cap gen converge2 = e(converge)
	gen omegasv2w=_b[/omegasv]
	scalar omegasvsescalarw=_se[/omegasv]
	gen omegasvse2w=omegasvsescalar
	cap gen rhoFsv2w=_b[/rhoFsv]
	cap gen rho2sv2w=rho1svw/rhoFsv2w
	gen constantsv2w=_b[/constant]
	mkmat one constantsv2w rho2sv2w rhoFsv2w omegasv2w omegasvse2w in 1/1, matrix(nlSVwsector)
	matrix nlsvswsector=nullmat(nlsvswsector)\nlSVwsector	   		      
} 

drop _all
svmat nlsvssector, names(col)
svmat nlsvswsector, names(col)
sort sector
duplicates drop 
save Data/Results/Final_Unweighted_Unstackedsector.dta, replace

*Combine Unweighted Omega Estimates with Sigma Estimates
clear
clear matrix 
use sector.dta
sort sector
merge m:1 sector using Final_Unweighted_Unstackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge groupcom using sigma_est_2sls.dta
keep if _merge ==3
drop _merge
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==.  
sort  groupcom
save twostagecombined_secdefsector.dta, replace

*Reconstruct dataset combined with sigma and omega estimates to weight and reestimate
use ready.dta, clear
sort groupcom
merge groupcom using twostagecombined_secdefsector.dta
tab _merge
drop if _merge==1
drop _merge

*Generate variables
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif)^2
gen x1sv_ij = (ls_ij_dif - ls_jj_dif)^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
gen x3sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
gen x4sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
gen x5sv_j =  (lpsv_fj_dif - lpsv_jj_dif )^2
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 

*Construct theta set  
gen thetasv3  =(1-omegasv2)* (1+rho1sv/rhoFsv2-2*rho1sv)/((sigmasv-1)*(1-rho1sv))
gen thetasv4  =(1-omegasv2)*(rho1sv/rhoFsv2-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))
gen thetasv5  =(1-omegasv2)^2*(rho1sv-rho1sv/rhoFsv2)/((sigmasv-1)^2*(1-rho1sv))
gen thetasv3w =(1-omegasv2w)*(1+rho1svw/rhoFsv2w-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))
gen thetasv4w =(1-omegasv2w)*(rho1svw/rhoFsv2w-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))
gen thetasv5w =(1-omegasv2w)^2*(rho1svw-rho1svw/rhoFsv2w)/((sigmasvw-1)^2*(1-rho1svw))

*Generates weights
gen uhatsv= ysv_ij - thetasv1 * x1sv_ij - thetasv2* x2sv_ij - ///
			thetasv3 * x3sv_ij - thetasv4 * x4sv_ij - thetasv5 * x5sv_j - constantsv2
gen uhatsvw= ysv_ij - thetasv1w * x1sv_ij - thetasv2w* x2sv_ij - ///
			thetasv3w * x3sv_ij - thetasv4w * x4sv_ij - thetasv5w * x5sv_j - constantsv2w
gen uhatsv2 =.
gen uhatsvw2=.

*Generate squared error term: note, we have the option to subtract the mean of error by country and good.
foreach var of varlist uhatsv uhatsvw {
		bysort groupcom ccode: egen `var'mean = mean(`var')
		replace `var' = `var'-`var'mean
		replace `var'2=`var'^2 
		drop if `var'2==. 
}

keep  ysv_ij x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j  uhatsv2 uhatsvw2 ///
	  groupcom ccode thetasv1 thetasv2 rho1sv sigmasv sigmasvse   /// 
	  thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse  omegasv2  ///
	  omegasv2w rho2sv2 rho2sv2w rhoFsv2 rhoFsv2w year  industrycountry
	  
save ready_theta_secdefsector.dta, replace	
*Weighted Regressions for sectors separately
use  ready_theta_secdefsector.dta, clear
sort groupcom
merge groupcom using sector.dta
tab _merge
drop if _merge==2
drop _merge
tab sector
*generate a temp sector for each sec def as before

keep  groupcom  sector ccode thetasv1 thetasv2 rho1sv sigmasv sigmasvse  ///
		thetasv1w thetasv2w rho1svw sigmasvw sigmasvwse uhatsv2 uhatsvw2  ///
	     ysv_ij x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j   industrycountry  ///
		  omegasv2 omegasv2w rho2sv2 rho2sv2w rhoFsv2 rhoFsv2w  year  	 

* Regress X vector on country indicators 
sort industrycountry
foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
	gen `var'hat=.
	}
	
gen ssvhat= .	
gen ssvwhat= .	
egen tempind = group(groupcom)
sum tempind
local indnum = r(max)	
cap forvalues j=1/`indnum' {
	tab ccode if tempind==`j' , gen(c_I)
	*Demean X variable set
	foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
		regress `var' c_I* if tempind==`j' , noc
		predict `var'hat1 if tempind==`j' 
		sum `var' if tempind==`j' 
		*replace `var'hat = `var'hat1-r(mean) if tempind==`j'
		replace `var'hat  = `var'hat1 if tempind==`j'
		drop `var'hat1
	}
	qui regress uhatsv2 c_I* if tempind==`j', noc
	predict uhatsv2hat if tempind==`j'
	qui regress uhatsvw2 c_I* if tempind==`j', noc
	predict uhatsvw2hat if tempind==`j'
	replace ssvhat=sqrt(uhatsv2hat) if tempind==`j'
	replace ssvwhat=sqrt(uhatsvw2hat) if tempind==`j'
	drop c_I* uhatsv2hat uhatsvw2hat
}	

gen ones =1
*Record weights for use in bootstrap
preserve
	keep  industrycountry groupcom ssvhat ssvwhat 
	rename ssvhat ssvhat_omeg
	rename ssvwhat ssvwhat_omeg
	duplicates drop
	save omegaweighted_est_2sls_forBS.dta, replace
restore

********** WEIGHT DATA BY VARIANCE*********;
********************************************
	foreach var of varlist  ysv_ij x1sv_ijhat x2sv_ijhat x3sv_ijhat x4sv_ijhat x5sv_jhat ones {
	gen `var'_weighted=`var'/ssvhat
	gen `var'_weightedw=`var'/ssvwhat
	}
egen tempsec = group(sector)
sum tempsec
local secnum = r(max)
qui sum omegasv2,d
local omega_median = r(p50)
qui sum omegasv2w,d
local omegaw_median = r(p50)

save weightedready_secdefsector.dta, replace
**********      RE-ESTIMATE       *********;
********************************************
*Now Regression for sectors separately, 
*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
  forvalues i=1/`secnum' {
	use weightedready_secdefsector.dta if tempsec == `i', replace 
	if omegasv2 > 0 {
		local omega = omegasv2 
		}
	if omegasv2w > 0 {
		local omegaw =omegasv2w		
		}
	if omegasv2 < 0 {
		local omega = `omega_median' 
		}
	if omegasv2w < 0 {
		local omegaw = `omega_median' 
		}
	local rhoF = rhoFsv2
	local rhoFw = rhoFsv2w
	
	noi display "SECOND STAGE NL ESTIMATION UNSTACKED WEIGHTED: SECTOR `i'"
	*SV
	nl (ysv_ij_weighted  =  thetasv1 * x1sv_ijhat_weighted + thetasv2 * x2sv_ijhat_weighted + ///
		 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat_weighted  +   ///
		 (1-{omegasv})*((rho1sv/{rhoFsv})-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat_weighted +     ///
		 (rho1sv-(rho1sv/{rhoFsv}))*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat_weighted  +     ///
				 {constant}* ones_weighted ///
	   ), iterate(500) initial (omegasv `omega' rhoFsv `rhoF')  
	   
	cap gen converge2 = e(converge)
	replace omegasv2=_b[/omegasv]
	scalar omegasvsescalar=_se[/omegasv]
	gen omegasvse2=omegasvsescalar
	cap gen rhoFsv2=_b[/rhoFsv]
	cap gen rhoFsvse2=_se[/rhoFsv]
	cap gen rho2sv2=rho1sv/rhoFsv2
	gen constantsv2=_b[/constant]
	mkmat  industrycountry groupcom ssvhat ssvwhat sector converge2 constantsv2 rho2sv2 rhoFsv2 rhoFsvse2 omegasv2 omegasvse2 in 1/1, matrix(nlSVsector)
	matrix nlsvs_weightedsector=nullmat(nlsvs_weightedsector)\nlSVsector
	   
	nl (ysv_ij_weightedw  =  thetasv1w * x1sv_ijhat_weightedw  + thetasv2w * x2sv_ijhat_weightedw  + ///
		 (1-{omegasv})* (1+rho1svw/{rhoFsv}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat_weightedw   +   ///
		 (1-{omegasv})*((rho1svw/{rhoFsv})-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat_weightedw  +     ///
		 (rho1svw-(rho1svw/{rhoFsv}))*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat_weightedw   +     ///
				 {constant}*ones_weightedw ///
	   ), iterate(500) initial (omegasv `omegaw' rhoFsv `rhoFw') 
   
	cap gen convergew2 = e(converge)
	replace omegasv2w=_b[/omegasv]
	scalar omegasvsescalarw=_se[/omegasv]
	gen omegasvse2w=omegasvsescalar
	cap gen rhoFsv2w=_b[/rhoFsv]
	cap gen rhoFsvse2w=_se[/rhoFsv]
	cap gen rho2sv2w=rho1svw/rhoFsv2w
	gen constantsv2w=_b[/constant]
	mkmat convergew2 constantsv2w rho2sv2w  rhoFsv2w  rhoFsvse2w omegasv2w omegasvse2w  in 1/1, matrix(wnlSVwsector)
	matrix nlsvsw_weightedsector=nullmat(nlsvsw_weightedsector)\wnlSVwsector		   		      
	}
	
drop _all
svmat nlsvs_weightedsector, names(col)
svmat nlsvsw_weightedsector, names(col)
sort sector
duplicates drop
save Final_Weighted_Unstackedsector.dta, replace
***************************************************************************
*           1.3 using nonlinear estimation to estimate the elasticity of substitution with Stacked System
***************************************************************************
clear all
clear matrix 
********************************************
*				STACK DATA
*******************************************
*Construct disaggragate data
use sector.dta, clear
sort sector
merge m:1 sector using Final_Unweighted_Unstackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge groupcom using sigma_est_2sls.dta
keep if _merge ==3
drop _merge
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==. 
sort  groupcom
save unw_unstkd_estsector.dta, replace

*Reconstruct dataset combined with sigma and omega estimates to weight and reestimate
use ready_revised.dta, clear
sort groupcom
merge groupcom using unw_unstkd_estsector.dta
tab _merge
drop if _merge==1
drop _merge

*Generate variables
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif)^2
gen x1sv_ij = (ls_ij_dif - ls_jj_dif)^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
gen x3sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
gen x4sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
gen x5sv_j =  (lpsv_fj_dif - lpsv_jj_dif )^2
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 

*Regress X vector on country indicators 
	sort industrycountry
	foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
		gen `var'hat=.
		}
		
	egen tempind = group(groupcom)
	sum tempind
	local indnum = r(max)	
	cap forvalues j=1/`indnum' {
	tab ccode if tempind==`j' , gen(c_I)
		*Demean X variable set
		foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
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
keep  ccode industrycountry groupcom  rho2sv2 rhoFsv2 omegasv2  rho2sv2w  rhoFsv2w omegasv2w  ///
	rho1sv sigmasv rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij x3sv_ij x4sv_ij x5sv_j ///
	 sigma_data sector t ysv_ij  x1sv_ijhat  x2sv_ijhat x3sv_ijhat x4sv_ijhat x5sv_jhat	  year
 
save ready_sig_omeg_data.dta, replace
*******************************
*Construct Aggregate Data	
*******************************						
use ready_revised.dta, clear
sort groupcom
merge groupcom using unw_unstkd_estsector.dta,
tab _merge
drop if _merge==1
drop _merge
gen ysv_ij  = (lpsv_fj_dif -lpsv_jj_dif )^2
gen x1sv_ij = (ls_fj_dif -ls_jj_dif )^2
gen x2sv_ij = (lpsv_fj_dif -lpsv_jj_dif )*(ls_fj_dif -ls_jj_dif )
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . 
gen sigma_data = 0

foreach var of varlist ysv_ij x1sv_ij x2sv_ij {
		gen `var'hat= `var'
		}
			
*OPTION 4	
bysort groupcom t: gen ctycount = _N

keep  ccode industrycountry groupcom  rho2sv2 rhoFsv2 omegasv2  rho2sv2w rhoFsv2w omegasv2w  ///
		rho1sv sigmasv rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij   ///
		sigma_data  sector t ctycount  year

*remove duplicates (data repeats by source country)
collapse (mean)  rho2sv2  rhoFsv2 omegasv2 rho2sv2w rhoFsv2w omegasv2w sigma_data             ///
				rho1sv sigmasv  rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij  ///
				sector year (max) ctycount , by(groupcom t)

* Regress X vector on good indicators 
foreach var of varlist  x1sv_ij x2sv_ij {
	gen `var'hat=.
	}
tab groupcom , gen(g_I)

*Average X variable set by Good
foreach var of varlist x1sv_ij x2sv_ij  {
	regress `var' g_I* , noc
	predict `var'hat1 
	replace `var'hat = `var'hat1
	drop `var'hat1 
}
	
drop g_I*
gen sqr_ctycount = sqrt(ctycount)
foreach var of varlist ysv_ij x1sv_ijhat  x2sv_ijhat {
		replace `var' = `var'*sqr_ctycount
		}
 
append using ready_sig_omeg_data.dta

foreach var of varlist x3sv_ij x4sv_ij x5sv_j x3sv_ijhat x4sv_ijhat x5sv_jhat {
	replace `var'=0 if `var' ==.
}

save stacked_sig_omeg_ready.dta, replace
*************************************************
*     RUN SECOND STAGE STACKED BY SECTORS       *
*************************************************
use stacked_sig_omeg_ready.dta, clear
egen good_strata = group(groupcom sigma_data)
egen tempsec = group(sector)
sum tempsec
local secnum = r(max)
save stacked_sig_omeg_ready_sector.dta, replace

qui sum omegasv2,d
local omega_median = r(p50)
qui sum omegasv2w,d
local omegaw_median = r(p50)
*Now Regression for sectors separately, 
*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
 forvalues i=1/`secnum' {
	use stacked_sig_omeg_ready_sector if tempsec == `i', replace 
	
	if omegasv2 > 0 {
		local omega = omegasv2 
		}
	if omegasv2 < 0 {
		local omega = `omega_median'
		}
	local rhoF = rhoFsv2
	
	gen ones =1
	noi display "SECOND STAGE NL ESTIMATION STACKED UNWEIGHTED: SECTOR `i'"
	*SV Stacked
	nl (ysv_ij = (rho1sv/((sigmasv-1)^2*(1-rho1sv)))*x1sv_ijhat*(sigma_data)  +  ///
		((2*rho1sv-1)/((sigmasv-1)*(1-rho1sv)))*x2sv_ijhat*(sigma_data)  +  ///
		 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat*(sigma_data ) +   ///
		 (1-{omegasv})*(rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat*(sigma_data ) +   ///
		 (rho1sv-rho1sv/{rhoFsv})*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat*(sigma_data ) +   ///
		 ({rhoFsv})/(({omegasv}-1)^2*(1-{rhoFsv}))*x1sv_ijhat*(1-sigma_data)   +  ///
		 (2*{rhoFsv}-1)/(({omegasv}-1)*(1-{rhoFsv}))*x2sv_ijhat*(1-sigma_data )  + ///
		 {constantsv4}*ones  + {constantsv3}*sigma_data   ///
	   ), iterate(500) initial( omegasv `omega' rhoFsv `rhoF') 
   
	gen converge3 = e(converge)
	gen omegasv3=_b[/omegasv]
	scalar omegasvsescalar=_se[/omegasv]
	gen omegasvse3=omegasvsescalar
	cap gen rhoFsv3=_b[/rhoFsv]
	gen rho2sv3 =rho1sv/rhoFsv3
	gen constantsv3=_b[/constantsv3]
	gen constantsv4=_b[/constantsv4]
	mkmat sector converge3  constantsv3 constantsv4 rho2sv3  rhoFsv3 omegasv3 omegasvse3 in 1/1, matrix(nlSVsector)
	matrix nlsvssector=nullmat(nlsvssector)\nlSVsector
	
	if omegasv2w > 0 {
		local omegaw =omegasv2w		
		}
	if omegasv2w < 0 {
		local omegaw = `omega_median' 
		}
	local rhoFw = rhoFsv2w
	*SVw Stacked
	nl (ysv_ij  = (rho1svw/((sigmasvw-1)^2*(1-rho1svw)))*x1sv_ijhat*(sigma_data)  +  ///
		((2*rho1svw-1)/((sigmasvw-1)*(1-rho1svw)))*x2sv_ijhat*(sigma_data)  +  ///
		 (1-{omegasv})* (1+rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat*(sigma_data ) +   ///
		 (1-{omegasv})*(rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat*(sigma_data ) +   ///
		 (rho1svw-rho1svw/{rhoFsvw})*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat*(sigma_data ) +   ///
		 ({rhoFsvw})/(({omegasv}-1)^2*(1-{rhoFsvw}))*x1sv_ijhat*(1-sigma_data)   +  ///
		 (2*{rhoFsvw}-1)/(({omegasv}-1)*(1-{rhoFsvw}))*x2sv_ijhat*(1-sigma_data )  + ///
		 {constantsv4}*ones  + {constantsv3}*sigma_data   ///
	   ), iterate(500) initial( omegasv `omegaw' rhoFsvw `rhoFw' )  
   	
	gen converge3w = e(converge)
	gen omegasv3w=_b[/omegasv]
	scalar omegasvsescalarw=_se[/omegasv]
	gen omegasvse3w=omegasvsescalar
	cap gen rhoFsv3w=_b[/rhoFsvw]
	cap gen rho2sv3w =rho1svw/rhoFsv3w
	gen constantsv3w=_b[/constantsv3]
	gen constantsv4w=_b[/constantsv4]
	
	mkmat converge3w  constantsv3w constantsv4w rho2sv3w rhoFsv3w omegasv3w omegasvse3w in 1/1, matrix(nlSVwsector)
	matrix nlsvwssector=nullmat(nlsvwssector)\nlSVwsector
} 	

drop _all
svmat nlsvssector, names(col)
svmat nlsvwssector, names(col)
sort sector
duplicates drop 
save Final_Unweighted_Stackedsector.dta, replace

					**********************************************
					*     WEIGHT DATA BY MEASURE OF VARIANCE     *
					**********************************************
****************                DISAGGREGATED DATA                      *******************
*Combine Unweighted Omega Estimates with Sigma Estimates to construct error based weights

clear
use sector.dta
sort sector
merge m:1 sector using Final_Unweighted_Stackedsector.dta
tab _merge
drop _merge
sort  groupcom
duplicates report groupcom
merge m:1 groupcom using sigma_est_2sls.dta
tab _merge
drop _merge
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==.
sort  groupcom
save unw_stkd_estsector.dta, replace

*Reconstruct dataset combined with sigma and omega estimates to weight and reestimate
use ready_revised.dta, clear
sort groupcom
merge m:1 groupcom using unw_stkd_estsector.dta
tab _merge
drop if _merge==1
drop _merge

*Generate variables
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif)^2
gen x1sv_ij = (ls_ij_dif - ls_jj_dif)^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
gen x3sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
gen x4sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
gen x5sv_j  = (lpsv_fj_dif - lpsv_jj_dif )^2
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 

*Construct theta set
gen thetasv3  =(1-omegasv3)* (1+rho1sv/rhoFsv3-2*rho1sv)/((sigmasv-1)*(1-rho1sv))
gen thetasv4  =(1-omegasv3)*(rho1sv/rhoFsv3-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))
gen thetasv5  =(1-omegasv3)^2*(rho1sv-rho1sv/rhoFsv3)/((sigmasv-1)^2*(1-rho1sv))
gen thetasv3w =(1-omegasv3w)* (1+rho1svw/rhoFsv3w-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))
gen thetasv4w =(1-omegasv3w)*(rho1svw/rhoFsv3w-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))
gen thetasv5w =(1-omegasv3w)^2*(rho1svw-rho1svw/rhoFsv3w)/((sigmasvw-1)^2*(1-rho1svw))

*Generates weights
gen uhatsv= ysv_ij - thetasv1 * x1sv_ij - thetasv2* x2sv_ij - thetasv3 * x3sv_ij ///
			- thetasv4 * x4sv_ij - thetasv5 * x5sv_j -  constantsv3 -  constantsv4
gen uhatsvw= ysv_ij - thetasv1w * x1sv_ij - thetasv2w* x2sv_ij - thetasv3w * x3sv_ij ///
			- thetasv4w * x4sv_ij -  thetasv5w * x5sv_j -  constantsv3w -  constantsv4w
gen uhatsv2 =.
gen uhatsvw2=.

*Generate squared error term: note, we have the option to subtract the mean of error by country and good.
foreach var of varlist uhatsv uhatsvw {
			bysort groupcom ccode: egen `var'mean = mean(`var')
			replace `var' = `var'-`var'mean
		replace `var'2=`var'^2 
		drop if `var'2==. 
}
		
* Regress X vector on country indicators 
foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j {
	gen `var'hat=.
	}
gen ssvhat =.
gen ssvwhat =.

egen tempind = group(groupcom)
sum tempind
local indnum = r(max)	
cap forvalues j=1/`indnum' {
tab ccode if tempind==`j' , gen(c_I)
	*Demean X variable set and average by source country and good
	foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
		regress `var' c_I* if tempind==`j' , noc
		predict `var'hat1 if tempind==`j' 
		sum `var' if tempind==`j'
		*replace `var'hat = `var'hat1-r(mean)  if tempind==`j'
		replace `var'hat = `var'hat1 if tempind==`j'
		drop `var'hat1
	}
	qui regress uhatsv2 c_I* if tempind==`j', noc
	predict uhatsv2hat if tempind==`j'
	qui regress uhatsvw2 c_I* if tempind==`j', noc
	predict uhatsvw2hat if tempind==`j'
	replace ssvhat=sqrt(uhatsv2hat) if tempind==`j'
	replace ssvwhat=sqrt(uhatsvw2hat) if tempind==`j'
	drop c_I* uhatsv2hat uhatsvw2hat
}			
 gen ones = 1
 gen sigma_data = 1

foreach var of varlist ysv_ij x1sv_ijhat x2sv_ijhat x3sv_ijhat x4sv_ijhat x5sv_jhat ones sigma_data {
	gen `var'_weighted=`var'/ssvhat
	gen `var'_weightedw=`var'/ssvwhat
	}	  

*Record weights for use in bootstrap
preserve
	keep  industrycountry groupcom ssvhat ssvwhat 
	rename ssvhat ssvhat_omegS
	rename ssvwhat ssvwhat_omeS
	duplicates drop
	save omega_weights_stacked_sector_2sls_forBS.dta, replace
restore
	

keep  groupcom  sector ysv_ij_weighted x1sv_ijhat_weighted x2sv_ijhat_weighted  ///
				x3sv_ijhat_weighted x4sv_ijhat_weighted x5sv_jhat_weighted  ones_weighted ///
				ysv_ij_weightedw x1sv_ijhat_weightedw x2sv_ijhat_weightedw  ///
				x3sv_ijhat_weightedw x4sv_ijhat_weightedw x5sv_jhat_weightedw  ones_weightedw ///
				 rho1sv sigmasv uhatsv2 uhatsvw2  /// 
				 rho1svw sigmasvw  omegasv3 omegasv3w rho2sv3  ssvhat ssvwhat ///
				rho2sv3w  rhoFsv3 rhoFsv3w  sigma_data_weighted sigma_data_weightedw  year
				
				
save weightedready_sigdata_secdefsector.dta, replace
****************                AGGREGATED DATA                      *******************

use ready_revised.dta, clear
sort groupcom
merge groupcom using unw_stkd_estsector.dta
tab _merge
drop if _merge==1
drop _merge
*Generate Aggragate variables
gen ysv_ij  = (lpsv_fj_dif -lpsv_jj_dif )^2
gen x1sv_ij = (ls_fj_dif -ls_jj_dif )^2
gen x2sv_ij = (lpsv_fj_dif -lpsv_jj_dif )*(ls_fj_dif -ls_jj_dif )
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . 
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==. 

sort  groupcom
drop thetasv1 thetasv1w thetasv2 thetasv2w
*Construct theta set
gen thetasv1  = (rhoFsv3)/((omegasv3-1)^2*(1-rhoFsv3))
gen thetasv2  = (2*(rhoFsv3)-1)/((omegasv3-1)*(1-rhoFsv3))
gen thetasv1w  = (rhoFsv3w)/((omegasv3w-1)^2*(1-rhoFsv3w))
gen thetasv2w  = (2*(rhoFsv3w)-1)/((omegasv3w-1)*(1-rhoFsv3w))
	
*OPTION 4	
bysort groupcom t: gen ctycount = _N

keep  ccode groupcom  rho2sv3 omegasv3  rho2sv3w omegasv3w  ///
rho1sv sigmasv rho1svw sigmasvw  rhoFsv3 rhoFsv3w ysv_ij  x1sv_ij  x2sv_ij  sector t  year ctycount

*remove duplicates (data repeats by source country)
collapse (mean)  rho2sv3 omegasv3  rho2sv3w omegasv3w   rhoFsv3 rhoFsv3w  ///
rho1sv sigmasv  rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij sector  year (max) ctycount , by(groupcom t)


tab groupcom , gen(g_I)
*Average X variable set by good 
foreach var of varlist x1sv_ij x2sv_ij  {
	regress `var' g_I* , noc
	predict `var'hat 
}	
 
drop g_I*
gen sqr_ctycount = sqrt(ctycount)
foreach var of varlist ysv_ij x1sv_ijhat  x2sv_ijhat {
		replace `var' = `var'*sqr_ctycount
		}
		
gen sigma_data = 0
gen ones = 1 

foreach var of varlist  ysv_ij x1sv_ijhat x2sv_ijhat ones {
	gen `var'_weighted=`var'
	gen `var'_weightedw=`var'
	}		
	

save weightedready_aggomeg_secdefsector.dta, replace
*generate a temp sector for each sec def as before
egen tempsec = group(sector)
sum tempsec
local secnum = r(max)

*Generage indicator for disaggragate data which has a value of zero in this dataset		 
gen sigma_data_weighted = 0
gen sigma_data_weightedw =0
save weightedready_aggomeg_secdefsector.dta, replace
append using weightedready_sigdata_secdefsector.dta

foreach var of varlist x3sv_ijhat_weighted x4sv_ijhat_weighted x5sv_jhat_weighted x3sv_ijhat_weightedw x4sv_ijhat_weightedw x5sv_jhat_weightedw {
	replace `var'=0 if `var' ==.
}

replace sigma_data = 1 if sigma_data ==.
************************************
**********REPLACE WEIGHTS***********
************************************
sum ssvhat if sigma_data ==1
replace ssvhat = r(mean) if sigma_data==0
sum ssvwhat if sigma_data ==1
replace ssvwhat = r(mean) if sigma_data==0

*Record weights for use in bootstrap
preserve
	keep if sigma_data==0
	keep  groupcom ssvhat ssvwhat 
	rename ssvhat ssvhat_omegSAG
	rename ssvwhat ssvwhat_omeSAG
	duplicates drop
	save ag_omega_weights_stacked_sector_2sls_forBS.dta, replace
restore
 

*Replace with averaged weight
foreach var of varlist  ysv_ij x1sv_ijhat x2sv_ijhat ones {
	replace `var'_weighted=`var'/ssvhat if sigma_data==0
	replace `var'_weightedw=`var'/ssvwhat if sigma_data==0
	}
************************************
**********REPLACE WEIGHTS***********
************************************

keep  groupcom  sector ysv_ij_weighted x1sv_ijhat_weighted x2sv_ijhat_weighted  ///
				x3sv_ijhat_weighted x4sv_ijhat_weighted x5sv_jhat_weighted ///
				ysv_ij_weightedw x1sv_ijhat_weightedw x2sv_ijhat_weightedw  ///
				x3sv_ijhat_weightedw x4sv_ijhat_weightedw x5sv_jhat_weightedw ///
				 ones_weighted rho1sv sigmasv uhatsv2 uhatsvw2  /// 
				rho1svw sigmasvw  omegasv3 omegasv3w rho2sv3 ///
				rho2sv3w sigma_data_weighted sigma_data_weightedw   rhoFsv3 rhoFsv3w  ssvhat ssvwhat  year sigma_data
				
	
replace sigma_data = 1 if sigma_data ==.
save stacked_sig_omeg_ready_weighted.dta, replace

			*RE-ESTIMATE WEIGHTED DATA
*************************************************
*     RUN SECOND STAGE STACKED BY SECTORS       *
*************************************************

use stacked_sig_omeg_ready_weighted.dta, clear
egen good_strata = group(groupcom sigma_data)
egen tempsec = group(sector)
sum tempsec
local secnum = r(max)
*record median omega estimates incase sector specific measures or negative
qui sum omegasv3,d
local omega_median = r(p50)
qui sum omegasv3w,d
local omegaw_median = r(p50)
save stacked_sig_omeg_ready_weighted_sector.dta, replace
*Now Regression for sectors separately, 
*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
 forvalues i=1/`secnum' {
	use stacked_sig_omeg_ready_weighted_sector.dta if tempsec == `i', replace 

	if omegasv3 > 0 {
		local omega = omegasv3 
		}
	if omegasv3 < 0 {
		local omega = `omega_median' 
		}
	local rhoF = rhoFsv3
	noi display "SECOND STAGE NL ESTIMATION STACKED WEIGHTED: SECTOR `i'"
	*SV Stacked
	 nl (ysv_ij_weighted  = (rho1sv/((sigmasv-1)^2*(1-rho1sv)))*x1sv_ijhat_weighted*(sigma_data)  +  ///
		((2*rho1sv-1)/((sigmasv-1)*(1-rho1sv)))*x2sv_ijhat_weighted*(sigma_data) +  ///
		 (1-{omegasv})* (1+rho1sv/{rhoFsv} -2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat_weighted*(sigma_data ) +   ///
		 (1-{omegasv})*(rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat_weighted*(sigma_data ) +   ///
		 (rho1sv-rho1sv/{rhoFsv})*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat_weighted*(sigma_data ) +   ///
		 ({rhoFsv})/(({omegasv}-1)^2*(1-{rhoFsv}))*x1sv_ijhat_weighted*(1-sigma_data)   +  ///
		 (2*{rhoFsv}-1)/(({omegasv}-1)*(1-{rhoFsv}))*x2sv_ijhat_weighted*(1-sigma_data )  + ///
		 {constantsv4}*ones_weighted  + {constantsv3}*sigma_data_weighted   ///
	   ), iterate(500) initial( omegasv `omega' rhoFsv `rhoF') 
 
	gen converge3 = e(converge)
	replace omegasv3=_b[/omegasv]
	scalar omegasvsescalar=_se[/omegasv]
	gen omegasvse3=omegasvsescalar
	replace rhoFsv3=_b[/rhoFsv]
	cap gen rho2sv3w =rho1svw/rhoFsv3w
	gen constantsv3=_b[/constantsv3]
	gen constantsv4=_b[/constantsv4]
	mkmat   sector converge3  constantsv3 constantsv4 rho2sv3 rhoFsv3 omegasv3 omegasvse3 in 1/1, matrix(wnlSVsector)
	matrix nlsvs_weightedsector=nullmat(nlsvs_weightedsector)\wnlSVsector
		
	if omegasv3w > 0 {
		local omegaw =omegasv3w		
		}
	if omegasv3w < 0 {
		local omegaw = `omega_median' 
		}
	local rhoFw = rhoFsv3w
	*SVw Stacked
     nl (ysv_ij_weightedw  = (rho1svw/((sigmasvw-1)^2*(1-rho1svw)))*x1sv_ijhat_weightedw*(sigma_data)  +  ///
		((2*rho1svw-1)/((sigmasvw-1)*(1-rho1svw)))*x2sv_ijhat_weightedw*(sigma_data)  +  ///
		 (1-{omegasv})* (1+rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat_weightedw*(sigma_data) +   ///
		 (1-{omegasv})*(rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat_weightedw*(sigma_data) +   ///
		 (rho1svw-rho1svw/{rhoFsvw})*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat_weightedw*(sigma_data) +   ///
		 ({rhoFsvw})/(({omegasv}-1)^2*(1-{rhoFsvw}))*x1sv_ijhat_weightedw*(1-sigma_data)   +  ///
		 (2*{rhoFsvw}-1)/(({omegasv}-1)*(1-{rhoFsvw}))*x2sv_ijhat_weightedw*(1-sigma_data)  + ///
		 {constantsv4}*ones_weighted  + {constantsv3}*sigma_data_weightedw    ///
	   ), iterate(500) initial( omegasv `omegaw' rhoFsvw  `rhoFw' )  
	  
   
	gen converge3w = e(converge)
	replace omegasv3w=_b[/omegasv]
	scalar omegasvsescalarw=_se[/omegasv]
	gen omegasvse3w=omegasvsescalar
	cap replace rhoFsv3w=_b[/rhoFsvw]
	cap replace  rho2sv3w =rho1svw/rhoFsv3w
	gen constantsv3w=_b[/constantsv3]
	gen constantsv4w=_b[/constantsv4]
	mkmat converge3w  constantsv3w constantsv4w rho2sv3w rhoFsv3w omegasv3w omegasvse3w  in 1/1 , matrix(wnlSVwsector)
	matrix nlsvws_weightedsector=nullmat(nlsvws_weightedsector)\wnlSVwsector
	} 	
	
drop _all
svmat nlsvs_weightedsector, names(col)
svmat nlsvws_weightedsector, names(col)
sort sector
duplicates drop 		
save Final_Weighted_Stackedsector.dta, replace


preserve
	use sigma_est_2sls_forBS.dta, clear
	merge 1:1 industrycountry using omegaweighted_est_2sls_forBS.dta
	drop _merge 
	merge 1:1  industrycountry using omega_weights_stacked_sector_2sls_forBS.dta
	drop _merge 
	merge m:1 groupcom using ag_omega_weights_stacked_sector_2sls_forBS.dta
	drop _merge 
	sort industrycountry groupcom
	save bootstrap_weights, replace
restore

*Save in date specific folder, for now:
*************************************
*CONSTRUCT BASIC TABLES
*Designate estimation method
*Stacked Unweighted results
use sector.dta, clear
sort sector
merge m:1 sector using Final_Unweighted_Unstackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge 1:1 groupcom using sigma_est_2sls.dta
keep if _merge == 3
drop _merge
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==. 
sort  groupcom
keep  sector groupcom  rho2sv2 ///
		omegasv2 omegasvse2 omegasv2w omegasvse2w constantsv2  ///
		rho1sv sigmasv sigmasvse  sigmasvw sigmasvwse  rho2sv2 rho2sv2w rhoFsv2 rhoFsv2w constantsv2  constantsv2w  
duplicates drop 

save Data/Results/Final_sig_omeg_Unweighted_Unstackedsector_2sls.dta, replace
use Data/Results/Final_sig_omeg_Unweighted_Unstackedsector_2sls.dta, clear
*Collapse data back to groupcom:
collapse  (mean) sector rho2sv2 omegasv2w omegasvse2w ///
		omegasv2 omegasvse2 constantsv2 ///
		rho1sv sigmasv sigmasvse, by (groupcom)

*number of goods of each sector (it is not sorted by sector since we combine sector 3 and 4 together)
bysort omegasv2: gen goodnumber=_N
*number of goods with sigma>omega
bysort omegasv2: egen sigma1_gt_omega2_sv=sum(sigmasv > omegasv2)
*number of goods with sigma>omega
bysort omegasv2w: egen sigma1_gt_omega2_svw=sum(sigmasv > omegasv2w)
collapse (mean) omegasv2 omegasvse2 omegasv2w omegasvse2w goodnumber ///
 sigma1_gt_omega2_sv sigma1_gt_omega2_svw, by(sector)
 order  sector goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv omegasv2w omegasvse2w sigma1_gt_omega2_svw 
 save Data/Results/Omega_v2Unweighted_Unstacked_sec_defsector_2sls.dta, replace

*Unstacked Weighted results
clear
use sector.dta
sort sector
merge m:1 sector using Final_Weighted_Unstackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge 1:1 groupcom using sigma_est_2sls.dta
keep if _merge == 3
drop _merge
drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
sort  groupcom
keep  sector groupcom omegasv2w omegasvse2w   ///
		 rho2sv2 omegasv2 omegasvse2  sigmasvw sigmasvwse  ///
		rho1sv sigmasv sigmasvse  sigmasvw sigmasvwse rho2sv2 rho2sv2w rhoFsv2 rhoFsv2w  constantsv2  constantsv2w ssvhat ssvwhat 
duplicates drop 

save Data/Results/Final_sig_omeg_Weighted_Unstackedsector_2sls.dta, replace
use Data/Results/Final_sig_omeg_Weighted_Unstackedsector_2sls.dta, clear
*Collapse data back to groupcom:
collapse  (mean) sector rho2sv2 omegasv2w omegasvse2w ///
		omegasv2 omegasvse2  sigmasvw sigmasvwse ///
		rho1sv sigmasv sigmasvse, by (groupcom)
*number of goods of each sector (it is not sorted by sector since we combine sector 3 and 4 together)
bysort omegasv2: gen goodnumber=_N
*number of goods with sigma>omega
bysort omegasv2: egen sigma1_gt_omega2_sv=sum(sigmasv > omegasv2)
*number of goods with sigma>omega
bysort omegasv2w: egen sigma1_gt_omega2_svw=sum(sigmasvw > omegasv2w)
collapse (mean) omegasv2 omegasvse2 omegasv2w omegasvse2w goodnumber ///
 sigma1_gt_omega2_sv sigma1_gt_omega2_svw, by(sector)
 order  sector  goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv omegasv2w omegasvse2w sigma1_gt_omega2_svw
save Data/Results/Omega_v2Weighted_Unstacked_sec_defsector_2sls.dta, replace


clear
use sector.dta
sort sector
merge m:1 sector using Final_Unweighted_Stackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge 1:1 groupcom using sigma_est_2sls.dta
keep if _merge == 3
drop _merge
drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
sort  groupcom
keep  sector groupcom  constantsv3 constantsv4 constantsv3w constantsv4w  ///
		 omegasv3 omegasvse3 omegasv3w omegasvse3w   ///
		 rho1sv  rho2sv3   rho2sv3w  rhoFsv3 rhoFsv3w   ///
		sigmasv sigmasvse  sigmasvw sigmasvwse  ///
		
duplicates drop 

save Data/Results/Final_sig_omeg_Unweighted_Stackedsector_2sls.dta, replace
use Data/Results/Final_sig_omeg_Unweighted_Stackedsector_2sls.dta, clear
*Collapse data back to groupcom:
collapse  (mean) sector rho2sv3 omegasv3w omegasvse3w ///
		omegasv3 omegasvse3  sigmasvw sigmasvwse ///
		rho1sv sigmasv sigmasvse, by (groupcom)
		
*Number of goods of each sector
bysort omegasv3: gen goodnumber=_N
*number of goods with sigma>omega
bysort omegasv3: egen sigma1_gt_omega3_sv=sum(sigmasv > omegasv3)
*number of goods with sigma>omega
bysort omegasv3w: egen sigma1_gt_omega3_svw=sum(sigmasvw > omegasv3w)
collapse (mean) omegasv3 omegasvse3 omegasv3w omegasvse3w goodnumber ///
 sigma1_gt_omega3_sv sigma1_gt_omega3_svw, by(sector)
 order  sector  goodnumber omegasv3 omegasvse3 sigma1_gt_omega3_sv omegasv3w omegasvse3w sigma1_gt_omega3_svw
save Data/Results/Omega_v2Unweighted_Stacked_sec_defsector_2sls.dta, replace


*Stacked Weighted results
clear
use sector.dta
sort sector
merge m:1 sector using Final_Weighted_Stackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge 1:1 groupcom using sigma_est_2sls.dta
keep if _merge == 3
drop _merge
drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
sort  groupcom
keep  sector groupcom  constantsv3 constantsv4 constantsv3w constantsv4w  ///
		 omegasv3 omegasvse3 omegasv3w omegasvse3w   ///
		 rho1sv  rho2sv3   rho2sv3w  rhoFsv3 rhoFsv3w  ///
		sigmasv sigmasvse  sigmasvw sigmasvwse  	
duplicates drop 
save Data/Results/Final_sig_omeg_Weighted_Stackedsector_2sls.dta, replace

use Data/Results/Final_sig_omeg_Weighted_Stackedsector_2sls.dta, clear
*Collapse data back to groupcom:
collapse  (mean) sector rho2sv3 omegasv3w omegasvse3w ///
		omegasv3 omegasvse3  ///
		rho1sv sigmasv sigmasvse  sigmasvw sigmasvwse, by (groupcom)
*Number of goods of each sector
bysort omegasv3: gen goodnumber=_N
*number of goods with sigma>omega
bysort omegasv3: egen sigma1_gt_omega3_sv=sum(sigmasv > omegasv3)
*number of goods with sigma>omega
bysort omegasv3w: egen sigma1_gt_omega3_svw=sum(sigmasvw > omegasv3w)
collapse (mean) omegasv3 omegasvse3 omegasv3w omegasvse3w goodnumber ///
 sigma1_gt_omega3_sv sigma1_gt_omega3_svw, by(sector)
 order  sector  goodnumber omegasv3 omegasvse3 sigma1_gt_omega3_sv omegasv3w omegasvse3w sigma1_gt_omega3_svw
save Data/Results/Omega_v2Weighted_Stacked_sec_defsector_2sls.dta, replace





*Compile estimates:
	use Data/Results/Omega_v2Unweighted_Unstacked_sec_defsector_2sls.dta,  clear
	keep  sector goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv 
	sort sector 
	save temp_data, replace
	
	use Data/Results/Omega_v2Weighted_Unstacked_sec_defsector_2sls.dta, clear
	keep sector omegasv2w omegasvse2w sigma1_gt_omega2_svw
	merge 1:1  sector using temp_data
	drop _merge
	order sector  goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv /// 
			omegasv2w omegasvse2w sigma1_gt_omega2_svw	
	sort sector 
	save temp_data, replace
	
	use Data/Results/Omega_v2Unweighted_Stacked_sec_defsector_2sls.dta,  clear
	keep sector omegasv3 omegasvse3 sigma1_gt_omega3_sv 
	merge 1:1 sector using temp_data
	drop _merge
	order sector  goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv ///
			omegasv2w omegasvse2w sigma1_gt_omega2_svw ///
			omegasv3 omegasvse3 sigma1_gt_omega3_sv 	
	sort sector 
	save temp_data, replace
	
	use  Data/Results/Omega_v2Weighted_Stacked_sec_defsector_2sls.dta, clear
	keep sector omegasv3w omegasvse3w sigma1_gt_omega3_svw
	merge 1:1 sector using temp_data
	drop _merge
	order sector  goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv ///
			omegasv2w omegasvse2w sigma1_gt_omega2_svw ///
			omegasv3 omegasvse3 sigma1_gt_omega3_sv ///
			omegasv3w omegasvse3w sigma1_gt_omega3_svw	
save Data/Results/Omega_v2_Full_results_2sls_sector.dta, replace		
		
	



ready.dta, clear
sort groupcom
merge groupcom using unw_unstkd_estsector.dta
tab _merge
drop if _merge==1
drop _merge

*Generate variables
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif)^2
gen x1sv_ij = (ls_ij_dif - ls_jj_dif)^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
gen x3sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
gen x4sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
gen x5sv_j =  (lpsv_fj_dif - lpsv_jj_dif )^2
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 

*Regress X vector on country indicators 
	sort industrycountry
	foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
		gen `var'hat=.
		}
		
	egen tempind = group(groupcom)
	sum tempind
	local indnum = r(max)	
	cap forvalues j=1/`indnum' {
	tab ccode if tempind==`j' , gen(c_I)
		*Demean X variable set
		foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
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
keep  ccode industrycountry groupcom  rho2sv2 rhoFsv2 omegasv2  rho2sv2w  rhoFsv2w omegasv2w  ///
	rho1sv sigmasv rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij x3sv_ij x4sv_ij x5sv_j ///
	 sigma_data sector t ysv_ij  x1sv_ijhat  x2sv_ijhat x3sv_ijhat x4sv_ijhat x5sv_jhat	  year
 
save ready_sig_omeg_data.dta, replace
*******************************
*Construct Aggregate Data	
*******************************						
use ready_revised.dta, clear
sort groupcom
merge groupcom using unw_unstkd_estsector.dta,
tab _merge
drop if _merge==1
drop _merge
gen ysv_ij  = (lpsv_fj_dif -lpsv_jj_dif )^2
gen x1sv_ij = (ls_fj_dif -ls_jj_dif )^2
gen x2sv_ij = (lpsv_fj_dif -lpsv_jj_dif )*(ls_fj_dif -ls_jj_dif )
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . 
gen sigma_data = 0

foreach var of varlist ysv_ij x1sv_ij x2sv_ij {
		gen `var'hat= `var'
		}
			
*OPTION 4	
bysort groupcom t: gen ctycount = _N

keep  ccode industrycountry groupcom  rho2sv2 rhoFsv2 omegasv2  rho2sv2w rhoFsv2w omegasv2w  ///
		rho1sv sigmasv rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij   ///
		sigma_data  sector t ctycount  year

*remove duplicates (data repeats by source country)
collapse (mean)  rho2sv2  rhoFsv2 omegasv2 rho2sv2w rhoFsv2w omegasv2w sigma_data             ///
				rho1sv sigmasv  rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij  ///
				sector year (max) ctycount , by(groupcom t)

* Regress X vector on good indicators 
foreach var of varlist  x1sv_ij x2sv_ij {
	gen `var'hat=.
	}
tab groupcom , gen(g_I)

*Average X variable set by Good
foreach var of varlist x1sv_ij x2sv_ij  {
	regress `var' g_I* , noc
	predict `var'hat1 
	replace `var'hat = `var'hat1
	drop `var'hat1 
}
	
drop g_I*
gen sqr_ctycount = sqrt(ctycount)
foreach var of varlist ysv_ij x1sv_ijhat  x2sv_ijhat {
		replace `var' = `var'*sqr_ctycount
		}
 
append using ready_sig_omeg_data.dta

foreach var of varlist x3sv_ij x4sv_ij x5sv_j x3sv_ijhat x4sv_ijhat x5sv_jhat {
	replace `var'=0 if `var' ==.
}

save stacked_sig_omeg_ready.dta, replace
*************************************************
*     RUN SECOND STAGE STACKED BY SECTORS       *
*************************************************
use stacked_sig_omeg_ready.dta, clear
egen good_strata = group(groupcom sigma_data)
egen tempsec = group(sector)
sum tempsec
local secnum = r(max)
save stacked_sig_omeg_ready_sector.dta, replace

qui sum omegasv2,d
local omega_median = r(p50)
qui sum omegasv2w,d
local omegaw_median = r(p50)
*Now Regression for sectors separately, 
*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
 forvalues i=1/`secnum' {
	use stacked_sig_omeg_ready_sector if tempsec == `i', replace 
	
	if omegasv2 > 0 {
		local omega = omegasv2 
		}
	if omegasv2 < 0 {
		local omega = `omega_median'
		}
	local rhoF = rhoFsv2
	
	gen ones =1
	noi display "SECOND STAGE NL ESTIMATION STACKED UNWEIGHTED: SECTOR `i'"
	*SV Stacked
	nl (ysv_ij = (rho1sv/((sigmasv-1)^2*(1-rho1sv)))*x1sv_ijhat*(sigma_data)  +  ///
		((2*rho1sv-1)/((sigmasv-1)*(1-rho1sv)))*x2sv_ijhat*(sigma_data)  +  ///
		 (1-{omegasv})* (1+rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat*(sigma_data ) +   ///
		 (1-{omegasv})*(rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat*(sigma_data ) +   ///
		 (rho1sv-rho1sv/{rhoFsv})*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat*(sigma_data ) +   ///
		 ({rhoFsv})/(({omegasv}-1)^2*(1-{rhoFsv}))*x1sv_ijhat*(1-sigma_data)   +  ///
		 (2*{rhoFsv}-1)/(({omegasv}-1)*(1-{rhoFsv}))*x2sv_ijhat*(1-sigma_data )  + ///
		 {constantsv4}*ones  + {constantsv3}*sigma_data   ///
	   ), iterate(500) initial( omegasv `omega' rhoFsv `rhoF') 
   
	gen converge3 = e(converge)
	gen omegasv3=_b[/omegasv]
	scalar omegasvsescalar=_se[/omegasv]
	gen omegasvse3=omegasvsescalar
	cap gen rhoFsv3=_b[/rhoFsv]
	gen rho2sv3 =rho1sv/rhoFsv3
	gen constantsv3=_b[/constantsv3]
	gen constantsv4=_b[/constantsv4]
	mkmat sector converge3  constantsv3 constantsv4 rho2sv3  rhoFsv3 omegasv3 omegasvse3 in 1/1, matrix(nlSVsector)
	matrix nlsvssector=nullmat(nlsvssector)\nlSVsector
	
	if omegasv2w > 0 {
		local omegaw =omegasv2w		
		}
	if omegasv2w < 0 {
		local omegaw = `omega_median' 
		}
	local rhoFw = rhoFsv2w
	*SVw Stacked
	nl (ysv_ij  = (rho1svw/((sigmasvw-1)^2*(1-rho1svw)))*x1sv_ijhat*(sigma_data)  +  ///
		((2*rho1svw-1)/((sigmasvw-1)*(1-rho1svw)))*x2sv_ijhat*(sigma_data)  +  ///
		 (1-{omegasv})* (1+rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat*(sigma_data ) +   ///
		 (1-{omegasv})*(rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat*(sigma_data ) +   ///
		 (rho1svw-rho1svw/{rhoFsvw})*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat*(sigma_data ) +   ///
		 ({rhoFsvw})/(({omegasv}-1)^2*(1-{rhoFsvw}))*x1sv_ijhat*(1-sigma_data)   +  ///
		 (2*{rhoFsvw}-1)/(({omegasv}-1)*(1-{rhoFsvw}))*x2sv_ijhat*(1-sigma_data )  + ///
		 {constantsv4}*ones  + {constantsv3}*sigma_data   ///
	   ), iterate(500) initial( omegasv `omegaw' rhoFsvw `rhoFw' )  
   	
	gen converge3w = e(converge)
	gen omegasv3w=_b[/omegasv]
	scalar omegasvsescalarw=_se[/omegasv]
	gen omegasvse3w=omegasvsescalar
	cap gen rhoFsv3w=_b[/rhoFsvw]
	cap gen rho2sv3w =rho1svw/rhoFsv3w
	gen constantsv3w=_b[/constantsv3]
	gen constantsv4w=_b[/constantsv4]
	
	mkmat converge3w  constantsv3w constantsv4w rho2sv3w rhoFsv3w omegasv3w omegasvse3w in 1/1, matrix(nlSVwsector)
	matrix nlsvwssector=nullmat(nlsvwssector)\nlSVwsector
} 	

drop _all
svmat nlsvssector, names(col)
svmat nlsvwssector, names(col)
sort sector
duplicates drop 
save Final_Unweighted_Stackedsector.dta, replace

					**********************************************
					*     WEIGHT DATA BY MEASURE OF VARIANCE     *
					**********************************************
****************                DISAGGREGATED DATA                      *******************
*Combine Unweighted Omega Estimates with Sigma Estimates to construct error based weights

clear
use sector.dta
sort sector
merge m:1 sector using Final_Unweighted_Stackedsector.dta
tab _merge
drop _merge
sort  groupcom
duplicates report groupcom
merge m:1 groupcom using sigma_est_2sls.dta
tab _merge
drop _merge
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==.
sort  groupcom
save unw_stkd_estsector.dta, replace

*Reconstruct dataset combined with sigma and omega estimates to weight and reestimate
use ready_revised.dta, clear
sort groupcom
merge m:1 groupcom using unw_stkd_estsector.dta
tab _merge
drop if _merge==1
drop _merge

*Generate variables
gen ysv_ij  = (lpsv_ij_dif - lpsv_fj_dif)^2
gen x1sv_ij = (ls_ij_dif - ls_jj_dif)^2
gen x2sv_ij = (lpsv_ij_dif - lpsv_fj_dif)*(ls_ij_dif - ls_jj_dif )
gen x3sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(lpsv_ij_dif - lpsv_fj_dif )
gen x4sv_ij = (lpsv_fj_dif - lpsv_jj_dif )*(ls_ij_dif - ls_jj_dif )
gen x5sv_j  = (lpsv_fj_dif - lpsv_jj_dif )^2
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . | x3sv_ij == .| x4sv_ij == . | x5sv_j == . 

*Construct theta set
gen thetasv3  =(1-omegasv3)* (1+rho1sv/rhoFsv3-2*rho1sv)/((sigmasv-1)*(1-rho1sv))
gen thetasv4  =(1-omegasv3)*(rho1sv/rhoFsv3-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))
gen thetasv5  =(1-omegasv3)^2*(rho1sv-rho1sv/rhoFsv3)/((sigmasv-1)^2*(1-rho1sv))
gen thetasv3w =(1-omegasv3w)* (1+rho1svw/rhoFsv3w-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))
gen thetasv4w =(1-omegasv3w)*(rho1svw/rhoFsv3w-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))
gen thetasv5w =(1-omegasv3w)^2*(rho1svw-rho1svw/rhoFsv3w)/((sigmasvw-1)^2*(1-rho1svw))

*Generates weights
gen uhatsv= ysv_ij - thetasv1 * x1sv_ij - thetasv2* x2sv_ij - thetasv3 * x3sv_ij ///
			- thetasv4 * x4sv_ij - thetasv5 * x5sv_j -  constantsv3 -  constantsv4
gen uhatsvw= ysv_ij - thetasv1w * x1sv_ij - thetasv2w* x2sv_ij - thetasv3w * x3sv_ij ///
			- thetasv4w * x4sv_ij -  thetasv5w * x5sv_j -  constantsv3w -  constantsv4w
gen uhatsv2 =.
gen uhatsvw2=.

*Generate squared error term: note, we have the option to subtract the mean of error by country and good.
foreach var of varlist uhatsv uhatsvw {
			bysort groupcom ccode: egen `var'mean = mean(`var')
			replace `var' = `var'-`var'mean
		replace `var'2=`var'^2 
		drop if `var'2==. 
}
		
* Regress X vector on country indicators 
foreach var of varlist  x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j {
	gen `var'hat=.
	}
gen ssvhat =.
gen ssvwhat =.

egen tempind = group(groupcom)
sum tempind
local indnum = r(max)	
cap forvalues j=1/`indnum' {
tab ccode if tempind==`j' , gen(c_I)
	*Demean X variable set and average by source country and good
	foreach var of varlist x1sv_ij x2sv_ij x3sv_ij x4sv_ij x5sv_j{
		regress `var' c_I* if tempind==`j' , noc
		predict `var'hat1 if tempind==`j' 
		sum `var' if tempind==`j'
		*replace `var'hat = `var'hat1-r(mean)  if tempind==`j'
		replace `var'hat = `var'hat1 if tempind==`j'
		drop `var'hat1
	}
	qui regress uhatsv2 c_I* if tempind==`j', noc
	predict uhatsv2hat if tempind==`j'
	qui regress uhatsvw2 c_I* if tempind==`j', noc
	predict uhatsvw2hat if tempind==`j'
	replace ssvhat=sqrt(uhatsv2hat) if tempind==`j'
	replace ssvwhat=sqrt(uhatsvw2hat) if tempind==`j'
	drop c_I* uhatsv2hat uhatsvw2hat
}			
 gen ones = 1
 gen sigma_data = 1

foreach var of varlist ysv_ij x1sv_ijhat x2sv_ijhat x3sv_ijhat x4sv_ijhat x5sv_jhat ones sigma_data {
	gen `var'_weighted=`var'/ssvhat
	gen `var'_weightedw=`var'/ssvwhat
	}	  

*Record weights for use in bootstrap
preserve
	keep  industrycountry groupcom ssvhat ssvwhat 
	rename ssvhat ssvhat_omegS
	rename ssvwhat ssvwhat_omeS
	duplicates drop
	save omega_weights_stacked_sector_2sls_forBS.dta, replace
restore
	

keep  groupcom  sector ysv_ij_weighted x1sv_ijhat_weighted x2sv_ijhat_weighted  ///
				x3sv_ijhat_weighted x4sv_ijhat_weighted x5sv_jhat_weighted  ones_weighted ///
				ysv_ij_weightedw x1sv_ijhat_weightedw x2sv_ijhat_weightedw  ///
				x3sv_ijhat_weightedw x4sv_ijhat_weightedw x5sv_jhat_weightedw  ones_weightedw ///
				 rho1sv sigmasv uhatsv2 uhatsvw2  /// 
				 rho1svw sigmasvw  omegasv3 omegasv3w rho2sv3  ssvhat ssvwhat ///
				rho2sv3w  rhoFsv3 rhoFsv3w  sigma_data_weighted sigma_data_weightedw  year
				
				
save weightedready_sigdata_secdefsector.dta, replace
****************                AGGREGATED DATA                      *******************

use ready_revised.dta, clear
sort groupcom
merge groupcom using unw_stkd_estsector.dta
tab _merge
drop if _merge==1
drop _merge
*Generate Aggragate variables
gen ysv_ij  = (lpsv_fj_dif -lpsv_jj_dif )^2
gen x1sv_ij = (ls_fj_dif -ls_jj_dif )^2
gen x2sv_ij = (lpsv_fj_dif -lpsv_jj_dif )*(ls_fj_dif -ls_jj_dif )
drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . 
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==. 

sort  groupcom
drop thetasv1 thetasv1w thetasv2 thetasv2w
*Construct theta set
gen thetasv1  = (rhoFsv3)/((omegasv3-1)^2*(1-rhoFsv3))
gen thetasv2  = (2*(rhoFsv3)-1)/((omegasv3-1)*(1-rhoFsv3))
gen thetasv1w  = (rhoFsv3w)/((omegasv3w-1)^2*(1-rhoFsv3w))
gen thetasv2w  = (2*(rhoFsv3w)-1)/((omegasv3w-1)*(1-rhoFsv3w))
	
*OPTION 4	
bysort groupcom t: gen ctycount = _N

keep  ccode groupcom  rho2sv3 omegasv3  rho2sv3w omegasv3w  ///
rho1sv sigmasv rho1svw sigmasvw  rhoFsv3 rhoFsv3w ysv_ij  x1sv_ij  x2sv_ij  sector t  year ctycount

*remove duplicates (data repeats by source country)
collapse (mean)  rho2sv3 omegasv3  rho2sv3w omegasv3w   rhoFsv3 rhoFsv3w  ///
rho1sv sigmasv  rho1svw sigmasvw ysv_ij  x1sv_ij  x2sv_ij sector  year (max) ctycount , by(groupcom t)


tab groupcom , gen(g_I)
*Average X variable set by good 
foreach var of varlist x1sv_ij x2sv_ij  {
	regress `var' g_I* , noc
	predict `var'hat 
}	
 
drop g_I*
gen sqr_ctycount = sqrt(ctycount)
foreach var of varlist ysv_ij x1sv_ijhat  x2sv_ijhat {
		replace `var' = `var'*sqr_ctycount
		}
		
gen sigma_data = 0
gen ones = 1 

foreach var of varlist  ysv_ij x1sv_ijhat x2sv_ijhat ones {
	gen `var'_weighted=`var'
	gen `var'_weightedw=`var'
	}		
	

save weightedready_aggomeg_secdefsector.dta, replace
*generate a temp sector for each sec def as before
egen tempsec = group(sector)
sum tempsec
local secnum = r(max)

*Generage indicator for disaggragate data which has a value of zero in this dataset		 
gen sigma_data_weighted = 0
gen sigma_data_weightedw =0
save weightedready_aggomeg_secdefsector.dta, replace
append using weightedready_sigdata_secdefsector.dta

foreach var of varlist x3sv_ijhat_weighted x4sv_ijhat_weighted x5sv_jhat_weighted x3sv_ijhat_weightedw x4sv_ijhat_weightedw x5sv_jhat_weightedw {
	replace `var'=0 if `var' ==.
}

replace sigma_data = 1 if sigma_data ==.
************************************
**********REPLACE WEIGHTS***********
************************************
sum ssvhat if sigma_data ==1
replace ssvhat = r(mean) if sigma_data==0
sum ssvwhat if sigma_data ==1
replace ssvwhat = r(mean) if sigma_data==0

*Record weights for use in bootstrap
preserve
	keep if sigma_data==0
	keep  groupcom ssvhat ssvwhat 
	rename ssvhat ssvhat_omegSAG
	rename ssvwhat ssvwhat_omeSAG
	duplicates drop
	save ag_omega_weights_stacked_sector_2sls_forBS.dta, replace
restore
 

*Replace with averaged weight
foreach var of varlist  ysv_ij x1sv_ijhat x2sv_ijhat ones {
	replace `var'_weighted=`var'/ssvhat if sigma_data==0
	replace `var'_weightedw=`var'/ssvwhat if sigma_data==0
	}
************************************
**********REPLACE WEIGHTS***********
************************************

keep  groupcom  sector ysv_ij_weighted x1sv_ijhat_weighted x2sv_ijhat_weighted  ///
				x3sv_ijhat_weighted x4sv_ijhat_weighted x5sv_jhat_weighted ///
				ysv_ij_weightedw x1sv_ijhat_weightedw x2sv_ijhat_weightedw  ///
				x3sv_ijhat_weightedw x4sv_ijhat_weightedw x5sv_jhat_weightedw ///
				 ones_weighted rho1sv sigmasv uhatsv2 uhatsvw2  /// 
				rho1svw sigmasvw  omegasv3 omegasv3w rho2sv3 ///
				rho2sv3w sigma_data_weighted sigma_data_weightedw   rhoFsv3 rhoFsv3w  ssvhat ssvwhat  year sigma_data
				
	
replace sigma_data = 1 if sigma_data ==.
save stacked_sig_omeg_ready_weighted.dta, replace

			*RE-ESTIMATE WEIGHTED DATA
*************************************************
*     RUN SECOND STAGE STACKED BY SECTORS       *
*************************************************

use stacked_sig_omeg_ready_weighted.dta, clear
egen good_strata = group(groupcom sigma_data)
egen tempsec = group(sector)
sum tempsec
local secnum = r(max)
*record median omega estimates incase sector specific measures or negative
qui sum omegasv3,d
local omega_median = r(p50)
qui sum omegasv3w,d
local omegaw_median = r(p50)
save stacked_sig_omeg_ready_weighted_sector.dta, replace
*Now Regression for sectors separately, 
*Regressing RHS variables on country indicator  BY GOOD creates country good averages.
 forvalues i=1/`secnum' {
	use stacked_sig_omeg_ready_weighted_sector.dta if tempsec == `i', replace 

	if omegasv3 > 0 {
		local omega = omegasv3 
		}
	if omegasv3 < 0 {
		local omega = `omega_median' 
		}
	local rhoF = rhoFsv3
	noi display "SECOND STAGE NL ESTIMATION STACKED WEIGHTED: SECTOR `i'"
	*SV Stacked
	 nl (ysv_ij_weighted  = (rho1sv/((sigmasv-1)^2*(1-rho1sv)))*x1sv_ijhat_weighted*(sigma_data)  +  ///
		((2*rho1sv-1)/((sigmasv-1)*(1-rho1sv)))*x2sv_ijhat_weighted*(sigma_data) +  ///
		 (1-{omegasv})* (1+rho1sv/{rhoFsv} -2*rho1sv)/((sigmasv-1)*(1-rho1sv))* x3sv_ijhat_weighted*(sigma_data ) +   ///
		 (1-{omegasv})*(rho1sv/{rhoFsv}-2*rho1sv)/((sigmasv-1)^2*(1-rho1sv))* x4sv_ijhat_weighted*(sigma_data ) +   ///
		 (rho1sv-rho1sv/{rhoFsv})*(1-{omegasv})^2/((sigmasv-1)^2*(1-rho1sv))* x5sv_jhat_weighted*(sigma_data ) +   ///
		 ({rhoFsv})/(({omegasv}-1)^2*(1-{rhoFsv}))*x1sv_ijhat_weighted*(1-sigma_data)   +  ///
		 (2*{rhoFsv}-1)/(({omegasv}-1)*(1-{rhoFsv}))*x2sv_ijhat_weighted*(1-sigma_data )  + ///
		 {constantsv4}*ones_weighted  + {constantsv3}*sigma_data_weighted   ///
	   ), iterate(500) initial( omegasv `omega' rhoFsv `rhoF') 
 
	gen converge3 = e(converge)
	replace omegasv3=_b[/omegasv]
	scalar omegasvsescalar=_se[/omegasv]
	gen omegasvse3=omegasvsescalar
	replace rhoFsv3=_b[/rhoFsv]
	cap gen rho2sv3w =rho1svw/rhoFsv3w
	gen constantsv3=_b[/constantsv3]
	gen constantsv4=_b[/constantsv4]
	mkmat   sector converge3  constantsv3 constantsv4 rho2sv3 rhoFsv3 omegasv3 omegasvse3 in 1/1, matrix(wnlSVsector)
	matrix nlsvs_weightedsector=nullmat(nlsvs_weightedsector)\wnlSVsector
		
	if omegasv3w > 0 {
		local omegaw =omegasv3w		
		}
	if omegasv3w < 0 {
		local omegaw = `omega_median' 
		}
	local rhoFw = rhoFsv3w
	*SVw Stacked
     nl (ysv_ij_weightedw  = (rho1svw/((sigmasvw-1)^2*(1-rho1svw)))*x1sv_ijhat_weightedw*(sigma_data)  +  ///
		((2*rho1svw-1)/((sigmasvw-1)*(1-rho1svw)))*x2sv_ijhat_weightedw*(sigma_data)  +  ///
		 (1-{omegasv})* (1+rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)*(1-rho1svw))* x3sv_ijhat_weightedw*(sigma_data) +   ///
		 (1-{omegasv})*(rho1svw/{rhoFsvw}-2*rho1svw)/((sigmasvw-1)^2*(1-rho1svw))* x4sv_ijhat_weightedw*(sigma_data) +   ///
		 (rho1svw-rho1svw/{rhoFsvw})*(1-{omegasv})^2/((sigmasvw-1)^2*(1-rho1svw))* x5sv_jhat_weightedw*(sigma_data) +   ///
		 ({rhoFsvw})/(({omegasv}-1)^2*(1-{rhoFsvw}))*x1sv_ijhat_weightedw*(1-sigma_data)   +  ///
		 (2*{rhoFsvw}-1)/(({omegasv}-1)*(1-{rhoFsvw}))*x2sv_ijhat_weightedw*(1-sigma_data)  + ///
		 {constantsv4}*ones_weighted  + {constantsv3}*sigma_data_weightedw    ///
	   ), iterate(500) initial( omegasv `omegaw' rhoFsvw  `rhoFw' )  
	  
   
	gen converge3w = e(converge)
	replace omegasv3w=_b[/omegasv]
	scalar omegasvsescalarw=_se[/omegasv]
	gen omegasvse3w=omegasvsescalar
	cap replace rhoFsv3w=_b[/rhoFsvw]
	cap replace  rho2sv3w =rho1svw/rhoFsv3w
	gen constantsv3w=_b[/constantsv3]
	gen constantsv4w=_b[/constantsv4]
	mkmat converge3w  constantsv3w constantsv4w rho2sv3w rhoFsv3w omegasv3w omegasvse3w  in 1/1 , matrix(wnlSVwsector)
	matrix nlsvws_weightedsector=nullmat(nlsvws_weightedsector)\wnlSVwsector
	} 	
	
drop _all
svmat nlsvs_weightedsector, names(col)
svmat nlsvws_weightedsector, names(col)
sort sector
duplicates drop 		
save Final_Weighted_Stackedsector.dta, replace


preserve
	use sigma_est_2sls_forBS.dta, clear
	merge 1:1 industrycountry using omegaweighted_est_2sls_forBS.dta
	drop _merge 
	merge 1:1  industrycountry using omega_weights_stacked_sector_2sls_forBS.dta
	drop _merge 
	merge m:1 groupcom using ag_omega_weights_stacked_sector_2sls_forBS.dta
	drop _merge 
	sort industrycountry groupcom
	save bootstrap_weights, replace
restore

*Save in date specific folder, for now:
*************************************
*CONSTRUCT BASIC TABLES
*Designate estimation method
*Stacked Unweighted results
use sector.dta, clear
sort sector
merge m:1 sector using Final_Unweighted_Unstackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge 1:1 groupcom using sigma_est_2sls.dta
keep if _merge == 3
drop _merge
drop if rho1sv==. | sigmasv==.  | rho1svw==. | sigmasvw==. 
sort  groupcom
keep  sector groupcom  rho2sv2 ///
		omegasv2 omegasvse2 omegasv2w omegasvse2w constantsv2  ///
		rho1sv sigmasv sigmasvse  sigmasvw sigmasvwse  rho2sv2 rho2sv2w rhoFsv2 rhoFsv2w constantsv2  constantsv2w  
duplicates drop 

save Data/Results/Final_sig_omeg_Unweighted_Unstackedsector_2sls.dta, replace
use Data/Results/Final_sig_omeg_Unweighted_Unstackedsector_2sls.dta, clear
*Collapse data back to groupcom:
collapse  (mean) sector rho2sv2 omegasv2w omegasvse2w ///
		omegasv2 omegasvse2 constantsv2 ///
		rho1sv sigmasv sigmasvse, by (groupcom)

*number of goods of each sector (it is not sorted by sector since we combine sector 3 and 4 together)
bysort omegasv2: gen goodnumber=_N
*number of goods with sigma>omega
bysort omegasv2: egen sigma1_gt_omega2_sv=sum(sigmasv > omegasv2)
*number of goods with sigma>omega
bysort omegasv2w: egen sigma1_gt_omega2_svw=sum(sigmasv > omegasv2w)
collapse (mean) omegasv2 omegasvse2 omegasv2w omegasvse2w goodnumber ///
 sigma1_gt_omega2_sv sigma1_gt_omega2_svw, by(sector)
 order  sector goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv omegasv2w omegasvse2w sigma1_gt_omega2_svw 
 save Data/Results/Omega_v2Unweighted_Unstacked_sec_defsector_2sls.dta, replace

*Unstacked Weighted results
clear
use sector.dta
sort sector
merge m:1 sector using Final_Weighted_Unstackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge 1:1 groupcom using sigma_est_2sls.dta
keep if _merge == 3
drop _merge
drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
sort  groupcom
keep  sector groupcom omegasv2w omegasvse2w   ///
		 rho2sv2 omegasv2 omegasvse2  sigmasvw sigmasvwse  ///
		rho1sv sigmasv sigmasvse  sigmasvw sigmasvwse rho2sv2 rho2sv2w rhoFsv2 rhoFsv2w  constantsv2  constantsv2w ssvhat ssvwhat 
duplicates drop 

save Data/Results/Final_sig_omeg_Weighted_Unstackedsector_2sls.dta, replace
use Data/Results/Final_sig_omeg_Weighted_Unstackedsector_2sls.dta, clear
*Collapse data back to groupcom:
collapse  (mean) sector rho2sv2 omegasv2w omegasvse2w ///
		omegasv2 omegasvse2  sigmasvw sigmasvwse ///
		rho1sv sigmasv sigmasvse, by (groupcom)
*number of goods of each sector (it is not sorted by sector since we combine sector 3 and 4 together)
bysort omegasv2: gen goodnumber=_N
*number of goods with sigma>omega
bysort omegasv2: egen sigma1_gt_omega2_sv=sum(sigmasv > omegasv2)
*number of goods with sigma>omega
bysort omegasv2w: egen sigma1_gt_omega2_svw=sum(sigmasvw > omegasv2w)
collapse (mean) omegasv2 omegasvse2 omegasv2w omegasvse2w goodnumber ///
 sigma1_gt_omega2_sv sigma1_gt_omega2_svw, by(sector)
 order  sector  goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv omegasv2w omegasvse2w sigma1_gt_omega2_svw
save Data/Results/Omega_v2Weighted_Unstacked_sec_defsector_2sls.dta, replace


clear
use sector.dta
sort sector
merge m:1 sector using Final_Unweighted_Stackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge 1:1 groupcom using sigma_est_2sls.dta
keep if _merge == 3
drop _merge
drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
sort  groupcom
keep  sector groupcom  constantsv3 constantsv4 constantsv3w constantsv4w  ///
		 omegasv3 omegasvse3 omegasv3w omegasvse3w   ///
		 rho1sv  rho2sv3   rho2sv3w  rhoFsv3 rhoFsv3w   ///
		sigmasv sigmasvse  sigmasvw sigmasvwse  ///
		
duplicates drop 

save Data/Results/Final_sig_omeg_Unweighted_Stackedsector_2sls.dta, replace
use Data/Results/Final_sig_omeg_Unweighted_Stackedsector_2sls.dta, clear
*Collapse data back to groupcom:
collapse  (mean) sector rho2sv3 omegasv3w omegasvse3w ///
		omegasv3 omegasvse3  sigmasvw sigmasvwse ///
		rho1sv sigmasv sigmasvse, by (groupcom)
		
*Number of goods of each sector
bysort omegasv3: gen goodnumber=_N
*number of goods with sigma>omega
bysort omegasv3: egen sigma1_gt_omega3_sv=sum(sigmasv > omegasv3)
*number of goods with sigma>omega
bysort omegasv3w: egen sigma1_gt_omega3_svw=sum(sigmasvw > omegasv3w)
collapse (mean) omegasv3 omegasvse3 omegasv3w omegasvse3w goodnumber ///
 sigma1_gt_omega3_sv sigma1_gt_omega3_svw, by(sector)
 order  sector  goodnumber omegasv3 omegasvse3 sigma1_gt_omega3_sv omegasv3w omegasvse3w sigma1_gt_omega3_svw
save Data/Results/Omega_v2Unweighted_Stacked_sec_defsector_2sls.dta, replace


*Stacked Weighted results
clear
use sector.dta
sort sector
merge m:1 sector using Final_Weighted_Stackedsector.dta
drop _merge
sort  groupcom
duplicates report groupcom
merge 1:1 groupcom using sigma_est_2sls.dta
keep if _merge == 3
drop _merge
drop if rho1sv==. | sigmasv==. | rho1svw==. | sigmasvw==. 
sort  groupcom
keep  sector groupcom  constantsv3 constantsv4 constantsv3w constantsv4w  ///
		 omegasv3 omegasvse3 omegasv3w omegasvse3w   ///
		 rho1sv  rho2sv3   rho2sv3w  rhoFsv3 rhoFsv3w  ///
		sigmasv sigmasvse  sigmasvw sigmasvwse  	
duplicates drop 
save Data/Results/Final_sig_omeg_Weighted_Stackedsector_2sls.dta, replace

use Data/Results/Final_sig_omeg_Weighted_Stackedsector_2sls.dta, clear
*Collapse data back to groupcom:
collapse  (mean) sector rho2sv3 omegasv3w omegasvse3w ///
		omegasv3 omegasvse3  ///
		rho1sv sigmasv sigmasvse  sigmasvw sigmasvwse, by (groupcom)
*Number of goods of each sector
bysort omegasv3: gen goodnumber=_N
*number of goods with sigma>omega
bysort omegasv3: egen sigma1_gt_omega3_sv=sum(sigmasv > omegasv3)
*number of goods with sigma>omega
bysort omegasv3w: egen sigma1_gt_omega3_svw=sum(sigmasvw > omegasv3w)
collapse (mean) omegasv3 omegasvse3 omegasv3w omegasvse3w goodnumber ///
 sigma1_gt_omega3_sv sigma1_gt_omega3_svw, by(sector)
 order  sector  goodnumber omegasv3 omegasvse3 sigma1_gt_omega3_sv omegasv3w omegasvse3w sigma1_gt_omega3_svw
save Data/Results/Omega_v2Weighted_Stacked_sec_defsector_2sls.dta, replace





*Compile estimates:
	use Data/Results/Omega_v2Unweighted_Unstacked_sec_defsector_2sls.dta,  clear
	keep  sector goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv 
	sort sector 
	save temp_data, replace
	
	use Data/Results/Omega_v2Weighted_Unstacked_sec_defsector_2sls.dta, clear
	keep sector omegasv2w omegasvse2w sigma1_gt_omega2_svw
	merge 1:1  sector using temp_data
	drop _merge
	order sector  goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv /// 
			omegasv2w omegasvse2w sigma1_gt_omega2_svw	
	sort sector 
	save temp_data, replace
	
	use Data/Results/Omega_v2Unweighted_Stacked_sec_defsector_2sls.dta,  clear
	keep sector omegasv3 omegasvse3 sigma1_gt_omega3_sv 
	merge 1:1 sector using temp_data
	drop _merge
	order sector  goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv ///
			omegasv2w omegasvse2w sigma1_gt_omega2_svw ///
			omegasv3 omegasvse3 sigma1_gt_omega3_sv 	
	sort sector 
	save temp_data, replace
	
	use  Data/Results/Omega_v2Weighted_Stacked_sec_defsector_2sls.dta, clear
	keep sector omegasv3w omegasvse3w sigma1_gt_omega3_svw
	merge 1:1 sector using temp_data
	drop _merge
	order sector  goodnumber omegasv2 omegasvse2 sigma1_gt_omega2_sv ///
			omegasv2w omegasvse2w sigma1_gt_omega2_svw ///
			omegasv3 omegasvse3 sigma1_gt_omega3_sv ///
			omegasv3w omegasvse3w sigma1_gt_omega3_svw	
save Data/Results/Omega_v2_Full_results_2sls_sector.dta, replace		
		
	



