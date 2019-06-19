/*********************************************************************
*Code written for: In Search of the Armington Elasticity by Feenstra, Luck, Obstefeld and Russ
*Contact: Philip Luck <philip.luck@ucdenver.edu>
*Date: January 2017
******************************************************************
1.A  This code provides point estimates for the micro elasticity sigma using both LIML and CUE.
	both procedures produce estimates which tend to be below our 2SLS and 2-Step GMM estimates.
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

*Load Data:
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
	forvalues j=1/1 {
		preserve
		keep if loopindustry==`i'
		*for Sato-Vartia price indicator
		qui tab ccode, gen(c_I_) 
		foreach var of varlist x1sv_ij x2sv_ij {
			gen `var'hat = `var'
			}
	
		*Estimate sigma using LIML
		cap ivregress liml ysv_ij (x1sv_ijhat x2sv_ijhat = c_I_*), robust 
		gen thetasv1=_b[x1sv_ijhat]
		gen thetasv2=_b[x2sv_ijhat]
		gen rho1sv = .5 + sqrt(.25 - 1/(4+thetasv2^2/thetasv1)) if thetasv2>0
		replace rho1sv = .5 - sqrt(.25 - 1/(4+thetasv2^2/thetasv1)) if thetasv2<0
		gen sigmasv_l = 1 + (2*rho1sv-1)/((1-rho1sv)*thetasv2)
		drop thetasv1 thetasv2 rho1sv
		
		*Estimate sigma using CUE (Choice of iterations will effect estimate to small degree)
		ivreg2  ysv_ij (x1sv_ijhat x2sv_ijhat = c_I_*), cue cueopt(technique(dfp) iterate(50) )   robust
		gen converge = e(converge)
		gen thetasv1=_b[x1sv_ijhat]
		gen thetasv2=_b[x2sv_ijhat]
		gen rho1sv = .5 + sqrt(.25 - 1/(4+thetasv2^2/thetasv1)) if thetasv2>0
		replace rho1sv = .5 - sqrt(.25 - 1/(4+thetasv2^2/thetasv1)) if thetasv2<0
		gen sigmasv_c = 1 + (2*rho1sv-1)/((1-rho1sv)*thetasv2)
		nois sum sigmasv_c
		nois display "GOOD NUMBER `i': sigma = r(mean)"
		}
		
		keep  groupcom  sigmasv_l sigmasv_c converge
		save  Data/Results/sigma_est_CUE_liml_`i'.dta, replace
		restore
	}




use  Data/Results/sigma_est_CUE_liml_1.dta, clear
forvalues i=1/`indnum' {
	append using  Data/Results/sigma_est_CUE_liml_`i'.dta, 
	}


forvalues i=1/`indnum' {
	erase  Data/Results/sigma_est_CUE_liml_`i'.dta
	}


duplicates drop 
sort groupcom
save Data/Results/sigma_est_CUE_liml.dta, replace


