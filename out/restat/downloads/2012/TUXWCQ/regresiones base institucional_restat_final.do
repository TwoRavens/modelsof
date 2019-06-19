*GENERAL INSTRUCTIONS*
*--------------------*
*Set the directory of your preference in the "global" command below
*Copy the database inside the directory chosen
*Ready to do the entire current file with no break
*All the log files with the impact results will be store at the folder "institutional_results" in your directory
*--------------------------------------------------------------------------*

clear
set mem 600m
global a "C:\Documents and Settings\rvidarte\Mis documentos\resultados bbs\Institucional\modificacion rosa"
use "$a\BDS_database_institutional_REStat.dta"
mkdir "$a\institutional_results"
set more off

*-------------*
*DATA ANALYSIS*
*-------------*

* We consider for this analysis the following constraints:
  * for each estimation, we keep clients with non missing outcome data at both baseline and follow up
  * we exclude savings and loans of clients who dropped out permanently from the respective bank 
* Then, we proceed to estimate the institutional impacts (TABLE 4) and the institutional aggregate results (TABLE 5)

*--------------------------------------------------------------------------*

* Creating missing constraints for dd estimates *
bys idclient: gen n2=_n
foreach X of varlist loan savings {
gen uno = (n2==1 | n2==2) & `X'~=. & idclient~=.
bys idclient: egen miss_`X'=min(uno)
drop uno
}

* Constraints for loan and savings 
for var loan savings: gen X_restr=X 
for var loan savings: replace X_restr=0 if drop_permanent==1 & post==1

* Creating local for estimation with covariates *
local covariates "numloance_*_wm highed_wm age3049_wm age5084_wm food_wm serv_wm prod_wm other_wm notinbsln sizewup_wm missing"


*IMPACT RESULTS (TABLE 4)*
**************************

* TABLE 4: Institutional results (see notes to table)

*1) DD estimates

foreach x of any loan savings {
log using "$a\institutional_results\table4_`x'.log", replace

display "Nº of clients"
codebook idclient if `x'_restr~=. & dd~=. & sucurs~=. & sale==0 & miss_`x'==1 & promotora~=""

display "SUMMARY STATISTICS" 	
reg `x'_restr post treatment dd sucurs if sale==0 & miss_`x'==1 & promotora~=""
 predictnl pt10 = _b[treatment]*1 + _b[post]*0 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc00 = _b[treatment]*0 + _b[post]*0 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pt11 = _b[treatment]*1 + _b[post]*1 + _b[dd]*1 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc01 = _b[treatment]*0 + _b[post]*1 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 lincom treatment+dd
 sum pt10 pc00 pt11 pc01	
 drop pt* pc*

display "DIFFERENCE IN DIFFERENCE"
*OLS Without Covariates (clustering)
areg `x'_restr post treatment dd sucurs if sale==0 & miss_`x'==1, absorb(promotora) cl(idbank)
*OLS With Covariates (clustering)
areg `x'_restr post treatment dd sucurs `covariates' if sale==0 & miss_`x'==1, absorb(promotora) cl(idbank) 


display "*T-C DIFFERENCE AT FOLLOW UP"
*OLS Without Covariates (clustering)
areg `x'_restr treatment sucurs if sale==0 & post==1 & idclient~=., absorb(promotora) cl(idbank)
*OLS With Covariates (clustering)
areg `x'_restr treatment sucurs `covariates' if sale==0 & post==1 & idclient~=., absorb(promotora) cl(idbank) 
log close
}

*2) FD estimates

foreach var of varlist repayment_new dropout drop_permanent {
log using "$a\institutional_results\table4_`var'.log", replace

display "*Nº of clients"
codebook idclient if `var'~=. & treatment~=. & sucurs~=. & post==1 & sale==0 & promotora~=""

display "SUMMARY STATISTICS" 
reg `var' treatment sucurs if post==1 & sale==0 & promotora~=""
 predictnl pt = _b[treatment]*1 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc = _b[treatment]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 sum pt pc 
 drop pt pc

display "*T-C DIFFERENCE AT FOLLOW UP"
*OLS Without Covariates (clustering)
areg `var' treatment sucurs if post==1 & sale==0, absorb(promotora) cl(idbank)
*OLS With Covariates (clustering)
areg `var' treatment sucurs `covariates'  if post==1 & sale==0, absorb(promotora) cl(idbank)
log close
}

*AGGREGATE RESULTS (TABLE 5 - Institutional Index)*
***************************************************

* Creating aggregate indicator *

for var dropout drop_permanent: gen rX=X
for var rdropout rdrop_permanent: recode X (0=1) (1=0)

for var loan_restr savings_restr repayment_new rdropout rdrop_permanent: gen p_X=X if treatment==0 & post==1 & sale==0
foreach var of varlist p_loan_restr p_savings_restr p_repayment_new p_rdropout p_rdrop_permanent {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_loan_restr p_savings_restr p_repayment_new p_rdropout p_rdrop_permanent 
for X in any loan_restr savings_restr repayment_new rdropout rdrop_permanent: gen kl_X=(X-p_X_mean)/p_X_sd
egen miss_kling=rownonmiss(kl_loan_restr kl_savings_restr kl_repayment_new kl_rdropout kl_rdrop_permanent)
gen kling=(kl_loan_restr+kl_savings_restr+kl_repayment_new+kl_rdropout+kl_rdrop_permanent)/5 if miss_kling==5


* Creating local for estimation with covariates *
local covariates "numloance_*_wm highed_wm age3049_wm age5084_wm food_wm serv_wm prod_wm other_wm notinbsln sizewup_wm missing"

* Impact on Institutional Index - TABLE 5*
log using "$a\institutional_results\table5_institutional.log", replace
***T-C DIFFERENCE AT FOLLOW UP
*Base model without covariates
areg kling treatment sucurs if post==1 & sale==0, absorb(promotora) cl(idbank)
*Base model with covariates
areg kling treatment sucurs `covariates' if post==1 & sale==0, absorb(promotora) cl(idbank)
*Attitude towards training
areg kling treatment treatint1 high_interest1_wm sucurs missing2 if post==1 & sale==0, absorb(promotora) cl(idbank)
*Education
areg kling treatment tred highed sucurs missing3 if post==1 & sale==0, absorb(promotora) cl(idbank)
*Business size
areg kling treatment trsizewup sizewup_wm sucurs missing5 if post==1 & sale==0, absorb(promotora) cl(idbank)

*** Nº of clients

*Base model
codebook idclient if kling~=. & post==1 & treatment~=. & sucurs~=. & sale==0 & promotora~=""	
*low interest
codebook idclient if kling~=. & post==1 & treatment~=. & sucurs~=. & sale==0 & promotora~="" & high_interest1_wm==0   	
*high interest
codebook idclient if kling~=. & post==1 & treatment~=. & sucurs~=. & sale==0 & promotora~="" & high_interest1_wm==1   	
*low education
codebook idclient if kling~=. & post==1 & treatment~=. & sucurs~=. & sale==0 & promotora~="" & highed==0   	
*high education
codebook idclient if kling~=. & post==1 & treatment~=. & sucurs~=. & sale==0 & promotora~="" & highed==1   	
*below median
codebook idclient if kling~=. & post==1 & treatment~=. & sucurs~=. & sale==0 & promotora~="" & sizewup_wm==0   	
*above median
codebook idclient if kling~=. & post==1 & treatment~=. & sucurs~=. & sale==0 & promotora~="" & sizewup_wm==1 
log close

