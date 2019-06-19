/*********************************************************************
*Code written for: In Search of the Armington Elasticity by Feenstra, Luck, Obstefeld and Russ
*Contact: Philip Luck <philip.luck@ucdenver.edu>
*Date: January 2017
******************************************************************
2A This code provides bootstrap estimates for the micro elasticity sigma using LIML
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

*Set bootstraps
local bootstart = 1
local bootend = 500

*loop over bootstrapped datasets:
forvalues k =`bootstart'/`bootend' {
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
	save boot_data/bootready_`k'_nest_0.dta, replace
		
	*loop over bootstrapped datasets of each k boostrapped dataset: For constructing t-stats
  cap  forvalues l = 0/100 {
	  cap  cap forvalues j = 1/1 {
			drop _all
			matrix drop _all
			scalar drop _all 
			if `l' != 0 {
				set seed 10`k'`l'
				*Generate a bootstrap resample
				drop _all
				matrix drop _all
				scalar drop _all 
				use boot_data/bootready_`k'_nest_0.dta, clear
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
				save boot_data/bootready_`k'_nest_`l'.dta, replace		
			}
		
			*Begin estimation
			noisily di "Bootstrap Number  " `k' " Nest Rep " `l'
			cap postclose boot_sigma_`k'_nest_`l'_liml_CUE
			local sigmalist "groupcom ref num  bootrep bootnestrep  sigmasv_l  "
			postfile boot_sigma_`k'_nest_`l'_liml `sigmalist' using "BOOT_Results/boot_sigma_estimation_robust_`k'_nest_`l'_liml", replace

			use boot_data/bootready_`k'_nest_`l'.dta ,clear


			replace ysv_ij = ysv_ij_SIG  
			replace  x1sv_ij = x1sv_ij_SIG 
			replace x2sv_ij = x2sv_ij_SIG 
			drop if ysv_ij == . | x1sv_ij == . | x2sv_ij == . 

			*merge with weights from orginal estimation
			merge m:1 industrycountry using  bootstrap_weights
			keep if _merge == 3
			drop _merge

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
			save boot_data/bootready_sigma.dta, replace
			*2SLS IV
			 forvalues i=1/`indnum' {
				forvalues n = 1/1 {
				use boot_data/bootready_sigma.dta if loopindustry==`i', clear
			
				*for Sato-Vartia price indicator
				qui tab ccode, gen(c_I_) 
				foreach var of varlist x1sv_ij x2sv_ij {
					gen `var'hat = `var'
					}
					
				*Run 2sls regression for sigma
				cap ivregress liml ysv_ij (x1sv_ijhat x2sv_ijhat = c_I_*) , robust small

				gen conssv=_b[_cons] 
				gen thetasv1=_b[x1sv_ijhat]
				gen thetasv2=_b[x2sv_ijhat]
				estat vce			/* VAR-COV TO BE USED TO CALCULATE CI'S FOR SIGMA */
				gen rho1sv = .5 + sqrt(.25 - 1/(4+thetasv2^2/thetasv1)) if thetasv2>0
				replace rho1sv = .5 - sqrt(.25 - 1/(4+thetasv2^2/thetasv1)) if thetasv2<0
				gen sigmasv_l = 1 + (2*rho1sv-1)/((1-rho1sv)*thetasv2)
				drop thetasv1 thetasv2

		
			
				cap gen bootrep = `k' 
				cap gen bootnestrep = `l' 
				mkmat  groupcom ref num bootrep bootnestrep  sigmasv_l    in 1/1, matrix(bootSVw)
				matrix bootbSVw=nullmat(bootbSVw)\bootSVw
				}
			}

			drop _all
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
				post boot_sigma_`k'_nest_`l'_liml (groupcom) (ref) (num)   (bootrep) (bootnestrep)  (sigmasv_l)
				restore
				}
			**** CLOSE UP LOOP ****
			postclose boot_sigma_`k'_nest_`l'_liml
		}
	}
	
	forvalues l = 0/50 {
		cap erase boot_data/bootready_`k'_nest_`l'_liml.dta

		}
}

}





forvalues tier1 = 1/500 {
forvalues tier2 = 0/50 {
	 cap append using "/mnt/HA/groups/luckGrp/FLOR/BOOT_Results/boot_sigma_estimation_robust_`tier1'_nest_`tier2'_liml.dta"
		cap replace bootrep = `tier1' if bootrep ==.
		cap replace bootnestrep = `tier2' if bootnestrep ==.
}
}
save "/BOOT_Results/boot_sigma_estimation_robust_liml.dta", replace






