*GENERAL INSTRUCTIONS*
*--------------------*
*Set the directory of your preference in the "global" command below
*Copy the database inside the directory chosen
*Ready to do the entire current file with no break
*All the log files with the impact results will be store at the folder "results" in your directory
*--------------------------------------------------------------------------*

clear
set mem 600m
global a "C:\directory_of_choice"
use "$a\BDS_database_individual_REStat.dta"
mkdir "$a\results"
set more off

*--------------------------------------*
*DATA ANALYSIS FOR NON ATTRITED CLIENTS*
*--------------------------------------*

* We consider for this analysis the following constraints:
  * keep non attrited clients
  * for each estimation, we keep clients with non missing outcome data at both baseline and follow up
* Then, we proceed to estimate the individual impacts (table 1-3) and the aggregate results (table 5).

*INDEX*
*-----*
* IMPACT RESULTS (TABLE 1-3)
    *DD estimates
    *FD estimates
* AGGREGATE RESULTS (TABLE 5)
    * Creating aggregate indicators (by families of outcomes: business results, practices and Household outcomes)  
    * Creating missing constraints for dd estimates *
    * Impact on aggregate indexes - TABLE 5 
*--------------------------------------------------------------------------*

preserve
keep if attrition==2
bys idclient: gen n2=_n
gen aventas = lventasc~=. & lvgood~=. & lvnormal~=. & lvbad~=. & lgap~=. 
bys idclient: egen all_ventas=min(aventas)

* Creating missing constraints for dd estimates *

foreach X of varlist lventasc lvgood lvnormal lvbad lgap work wk_out ruc fixed rec_sales rec_take2 local sources credit /*
*/ bb_save_share hh_save_share bb_loan_share hh_loan_share children_share take_product_share hh_bills_share {
gen uno = (n2==1 | n2==2) & `X'~=. & idclient~=.
bys idclient: egen miss_`X'=min(uno)
drop uno
}

* Creating local for estimation with covariates *

local covariates "numloance_*_wm ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_loance"

*IMPACT RESULTS (TABLE 1-3)*
****************************

*1) TABLE 1: business results (see notes to table)

*1.1) DD estimates

foreach var of varlist lventasc lvgood lvnormal lvbad lgap {
log using "$a\results\table1_`var'.log", replace
codebook idclient if `var'~=. & all_ventas==1 & dd~=. & sucurs~=. & miss_`var'==1 & cofficer_lb~=. 	
reg `var' post treatment dd sucurs if miss_`var'==1 & all_ventas==1 & cofficer_lb~=.
 predictnl pt10 = _b[treatment]*1 + _b[post]*0 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc00 = _b[treatment]*0 + _b[post]*0 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pt11 = _b[treatment]*1 + _b[post]*1 + _b[dd]*1 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc01 = _b[treatment]*0 + _b[post]*1 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 lincom treatment+dd
 sum pt10 pc00 pt11 pc01	
 drop pt* pc*
*OLS Without Covariates (clustering)
areg `var' post treatment dd sucurs if miss_`var'==1 & all_ventas==1, absorb(cofficer_lb) cl(idbank) 
*OLS With Covariates (clustering)
areg `var' post treatment dd sucurs `covariates' if miss_`var'==1 & all_ventas==1, absorb(cofficer_lb) cl(idbank)  
log close
}

foreach var of varlist work wk_out {
log using "$a\results\table1_`var'.log", replace
codebook idclient if `var'~=. & dd~=. & sucurs~=. & miss_`var'==1 & cofficer_lb~=.
reg `var' post treatment dd sucurs if miss_`var'==1 & cofficer_lb~=.
 predictnl pt10 = _b[treatment]*1 + _b[post]*0 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc00 = _b[treatment]*0 + _b[post]*0 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pt11 = _b[treatment]*1 + _b[post]*1 + _b[dd]*1 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc01 = _b[treatment]*0 + _b[post]*1 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 lincom treatment+dd
 sum pt10 pc00 pt11 pc01	
 drop pt* pc*
*OLS Without Covariates (clustering)
areg `var' post treatment dd sucurs if miss_`var'==1, absorb(cofficer_lb) cl(idbank) 
*OLS With Covariates (clustering)
areg `var' post treatment dd sucurs `covariates' if miss_`var'==1, absorb(cofficer_lb) cl(idbank)  
log close
}

*1.2) FD estimates

log using "$a\results\table1_profit.log", replace
codebook idclient if treatment~=. & sucurs~=. & post==1 & more_profit>=0 & more_profit~=. & cofficer_lb~=. & idclient~=.
reg more_profit treatment sucurs if post==1 & more_profit>=0 & more_profit~=. & cofficer_lb~=. & idclient~=.
 predictnl pt = _b[treatment]*1 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc = _b[treatment]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 sum pt pc
 drop pt pc
*OLS Without Covariates (clustering)
areg more_profit treatment sucurs if post==1 & more_profit>=0 & more_profit~=. & idclient~=., absorb(cofficer_lb) cl(idbank)  
*OLS With Covariates (clustering)
areg more_profit treatment sucurs `covariates' if post==1 & more_profit>=0 & more_profit~=. & idclient~=., absorb(cofficer_lb) cl(idbank)  
log close

*2) TABLE 2: Business practices (see notes to table)

*2.1) DD estimates

foreach var of varlist ruc fixed rec_sales local credit {
log using "$a\results\table2_`var'.log", replace
codebook idclient if `var'~=. & sucurs~=. & dd~=. & cofficer_lb~=. & miss_`var'==1
reg `var' post treatment dd sucurs if miss_`var'==1 & cofficer_lb~=.
 predictnl pt10 = _b[treatment]*1 + _b[post]*0 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc00 = _b[treatment]*0 + _b[post]*0 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pt11 = _b[treatment]*1 + _b[post]*1 + _b[dd]*1 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc01 = _b[treatment]*0 + _b[post]*1 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 lincom treatment+dd
 sum pt10 pc00 pt11 pc01	
 drop pt* pc*		
*OLS Without Covariates (clustering)
areg `var' post treatment dd sucurs if miss_`var'==1, absorb(cofficer_lb) cl(idbank)	
*OLS With Covariates (clustering)
areg `var' post treatment dd sucurs `covariates' if miss_`var'==1, absorb(cofficer_lb) cl(idbank)	
log close
}

* only lima 
log using "$a\results\table2_rec_take2.log", replace
codebook idclient if rec_take2~=. & cod_sucurs==1 & dd~=. & cofficer_lb~=. & miss_rec_take2==1
reg rec_take2 post treatment dd if cod_sucurs==1 & miss_rec_take2==1 & cofficer_lb~=.
 predictnl pt10 = _b[treatment]*1 + _b[post]*0 + _b[dd]*0 + _b[_cons]*1 if e(sample)
 predictnl pc00 = _b[treatment]*0 + _b[post]*0 + _b[dd]*0 + _b[_cons]*1 if e(sample)
 predictnl pt11 = _b[treatment]*1 + _b[post]*1 + _b[dd]*1 + _b[_cons]*1 if e(sample)
 predictnl pc01 = _b[treatment]*0 + _b[post]*1 + _b[dd]*0 + _b[_cons]*1 if e(sample)
 lincom treatment+dd
 sum pt10 pc00 pt11 pc01	
 drop pt* pc*		
*OLS Without Covariates (clustering)
areg rec_take2 post treatment dd if cod_sucurs==1 & miss_rec_take2==1, absorb(cofficer_lb) cl(idbank)
*OLS With Covariates (clustering)
areg rec_take2 post treatment dd `covariates' if cod_sucurs==1 & miss_rec_take2==1, absorb(cofficer_lb) cl(idbank)
log close 

* only ayacucho 
log using "$a\results\table2_sources.log", replace
codebook idclient if sources~=. & cod_sucurs==5 & dd~=. & cofficer_lb~=. & miss_sources==1
reg sources post treatment dd if cod_sucurs==5 & miss_sources==1 & cofficer_lb~=.
 predictnl pt10 = _b[treatment]*1 + _b[post]*0 + _b[dd]*0 + _b[_cons]*1 if e(sample)
 predictnl pc00 = _b[treatment]*0 + _b[post]*0 + _b[dd]*0 + _b[_cons]*1 if e(sample)
 predictnl pt11 = _b[treatment]*1 + _b[post]*1 + _b[dd]*1 + _b[_cons]*1 if e(sample)
 predictnl pc01 = _b[treatment]*0 + _b[post]*1 + _b[dd]*0 + _b[_cons]*1 if e(sample)
 lincom treatment+dd
 sum pt10 pc00 pt11 pc01	
 drop pt* pc*		
*OLS Without Covariates (clustering)
areg sources post treatment dd if cod_sucurs==5 & miss_sources==1, absorb(cofficer_lb) cl(idbank)
*OLS With Covariates (clustering)
areg sources post treatment dd `covariates' if cod_sucurs==5 & miss_sources==1, absorb(cofficer_lb) cl(idbank)
log close

*2.2) FD estimates

foreach var of varlist record_pay2 sum_know start_newb profit think do  {
log using "$a\results\table2_`var'.log", replace
codebook idclient if `var'~=. & post==1 & treatment~=. & sucurs~=. & cofficer_lb~=. & idclient~=.
reg `var' treatment sucurs if post==1 & cofficer_lb~=. & idclient~=.
 predictnl pt = _b[treatment]*1 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc = _b[treatment]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 sum pt pc	
 drop pt pc		
*OLS Without Covariates (clustering)
areg `var' treatment sucurs if post==1 & idclient~=., absorb(cofficer_lb) cl(idbank)
*OLS With Covariates (clustering)
areg `var' treatment sucurs `covariates' if post==1 & idclient~=., absorb(cofficer_lb) cl(idbank)
log close
}

* only lima
log using "$a\results\table2_prob.log", replace
codebook idclient if prob~=. & post==1 & cod_sucurs==1 & treatment~=. & cofficer_lb~=. & idclient~=.
reg prob treatment if post==1 & cod_sucurs==1 & cofficer_lb~=. & idclient~=.
 predictnl pt = _b[treatment]*1 + _b[_cons]*1 if e(sample)
 predictnl pc = _b[treatment]*0 + _b[_cons]*1 if e(sample)
 sum pt pc	
 drop pt pc		
*OLS Without Covariates (clustering)
areg prob treatment if post==1 & cod_sucurs==1 & idclient~=., absorb(cofficer_lb) cl(idbank)
*OLS With Covariates (clustering)
areg prob treatment `covariates' if post==1 & cod_sucurs==1 & idclient~=., absorb(cofficer_lb) cl(idbank)
log close


*3) TABLE 3: Household outcomes (see notes to table)

*3.1) DD estimates

foreach var of varlist bb_save_share hh_save_share bb_loan_share hh_loan_share children_share take_product_share hh_bills_share  {
log using "$a\results\table3_`var'.log", replace
codebook idclient if `var'~=. & sucurs~=. & dd~=. & cofficer_lb~=. & miss_`var'==1
reg `var' post treatment dd sucurs if miss_`var'==1 & cofficer_lb~=.
 predictnl pt10 = _b[treatment]*1 + _b[post]*0 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc00 = _b[treatment]*0 + _b[post]*0 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pt11 = _b[treatment]*1 + _b[post]*1 + _b[dd]*1 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc01 = _b[treatment]*0 + _b[post]*1 + _b[dd]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 lincom treatment+dd
 sum pt10 pc00 pt11 pc01	
 drop pt* pc*		
*OLS Without Covariates (clustering)
areg `var' post treatment dd sucurs if miss_`var'==1, absorb(cofficer_lb) cl(idbank)	
*OLS With Covariates (clustering)
areg `var' post treatment dd sucurs `covariates' if miss_`var'==1, absorb(cofficer_lb) cl(idbank)	
log close
}

*3.2) FD estimates

log using "$a\results\table3_habits.log", replace
codebook idclient if habits4~=. & treatment~=. & sucurs~=. & post==1 & cofficer_lb~=. & idclient~=.
reg habits4 treatment sucurs if post==1 & cofficer_lb~=. & idclient~=.
 predictnl pt = _b[treatment]*1 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 predictnl pc = _b[treatment]*0 + _b[sucurs]*sucurs + _b[_cons]*1 if e(sample)
 sum pt pc
 drop pt pc
*OLS Without Covariates (clustering)
areg habits4 treatment sucurs if post==1 & idclient~=., absorb(cofficer_lb) cl(idbank)  
*OLS With Covariates (clustering)
areg habits4 treatment sucurs `covariates' if post==1 & idclient~=., absorb(cofficer_lb) cl(idbank)  
log close

*AGGREGATE RESULTS (TABLE 5)*
*****************************

* Creating aggregate indicators (by families of outcomes) *

*1) Business results

for var lventasc lvgood lvnormal lvbad rlgap work wk_out : gen p_X=X if treatment==0 & post==0 
foreach var of varlist p_lventasc p_lvgood p_lvnormal p_lvbad p_rlgap p_work p_wk_out  {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_lventasc p_lvgood p_lvnormal p_lvbad p_rlgap p_work p_wk_out
for X in any lventasc lvgood lvnormal lvbad rlgap work wk_out : gen kl_X=(X-p_X_mean)/p_X_sd
egen restr_kling1=rownonmiss(kl_lventasc kl_lvgood kl_lvnormal kl_lvbad kl_rlgap kl_work kl_wk_out )
gen kling1=(kl_lventasc+kl_lvgood+kl_lvnormal+kl_lvbad+kl_rlgap+kl_work+kl_wk_out)/7 if restr_kling1==7

*2) Business practices

for var ruc rfixed rec_sales local credit record_pay2 sum_know start_newb profit think do rrec_take rprob rsources: gen p_X=X if treatment==0 & post==1 
foreach var of varlist p_ruc p_rfixed p_rec_sales p_local p_credit p_record_pay2 p_sum_know p_start_newb p_profit p_think p_do p_rrec_take p_rprob p_rsources {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_ruc p_rfixed p_rec_sales p_local p_credit p_record_pay2 p_sum_know p_start_newb p_profit p_think p_do p_rrec_take p_rprob p_rsources
for X in any ruc rfixed rec_sales local credit record_pay2 sum_know start_newb profit think do rrec_take rprob rsources: gen kl_X=(X-p_X_mean)/p_X_sd
egen restr_kling2=rownonmiss(kl_ruc kl_rfixed kl_rec_sales kl_local kl_credit kl_record_pay2 kl_sum_know kl_start_newb kl_profit kl_think kl_do kl_rrec_take kl_rprob kl_rsources)
gen kling2=(kl_ruc+kl_rfixed+kl_rec_sales+kl_local+kl_credit+kl_record_pay2+kl_sum_know+kl_start_newb+kl_profit+kl_think+kl_do+kl_rrec_take+kl_rprob+kl_rsources)/14 if restr_kling2==14

*3) Household outcomes: Empowerment

*3.1) All decisions
for var hh_save_share hh_loan_share bb_save_share bb_loan_share take_product_share hh_bills_share children_share: gen p_X=X if treatment==0 & post==0 
foreach var of varlist p_hh_save_share p_hh_loan_share p_bb_save_share p_bb_loan_share p_take_product_share p_hh_bills_share p_children_share {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_hh_save_share p_hh_loan_share p_bb_save_share p_bb_loan_share p_take_product_share p_hh_bills_share p_children_share
for X in any hh_save_share hh_loan_share bb_save_share bb_loan_share take_product_share hh_bills_share children_share: gen kl_X=(X-p_X_mean)/p_X_sd
egen restr_kling3=rownonmiss(kl_hh_save_share kl_hh_loan_share kl_bb_save_share kl_bb_loan_share kl_take_product_share kl_hh_bills_share kl_children_share)
gen kling3=(kl_hh_save_share+kl_hh_loan_share+kl_bb_save_share+kl_bb_loan_share+kl_take_product_share+kl_hh_bills_share+kl_children_share)/7 if restr_kling3==7

*3.2) Household decisions
egen restr_kling4=rownonmiss(kl_hh_save_share kl_hh_loan_share kl_hh_bills_share kl_children_share)
gen kling4=(kl_hh_save_share+kl_hh_loan_share+kl_hh_bills_share+kl_children_share)/4 if restr_kling4==4

*3.3) Business decisions
egen restr_kling5=rownonmiss(kl_bb_save_share kl_bb_loan_share kl_take_product_share)
gen kling5=(kl_bb_save_share+kl_bb_loan_share+kl_take_product_share)/3 if restr_kling5==3

* Creating missing constraints for dd estimates *

foreach X of varlist kling1 kling3 kling4 kling5 {
gen uno = (n2==1 | n2==2) & `X'~=. & idclient~=.
bys idclient: egen miss_`X'=min(uno)
drop uno
}

* Impact on aggregate indexes - TABLE 5*

*1) Business results 

log using "$a\results\table5_bbss_results.log", replace
areg kling1 post treatment dd sucurs if miss_kling1==1, absorb(cofficer_lb) cl(idbank)  
areg kling1 post treatment dd sucurs `covariates' if miss_kling1==1, absorb(cofficer_lb) cl(idbank)  
areg kling1 post postint1 treatment treatint1 high_interest1 ddint1 dd sucurs missing2_new if miss_kling1==1, absorb(cofficer_lb) cl(idbank)  
lincom dd+ddint1
areg kling1 post posteduc treatment treduc ed_mas dd ddeduc sucurs missing3_new if miss_kling1==1, absorb(cofficer_lb) cl(idbank)  
lincom dd+ddeduc
areg kling1 post postsize2 treatment trsize2 size2 dd ddsize2 sucurs missing5_new if miss_kling1==1, absorb(cofficer_lb) cl(idbank)  
lincom dd+ddsize2
codebook idclient if kling1~=. & post~=. & dd~=. & sucurs~=. & miss_kling1==1 & cofficer_lb~=.	
codebook idclient if kling1~=. & post~=. & dd~=. & sucurs~=. & miss_kling1==1 & cofficer_lb~=. & high_interest1==0   	
codebook idclient if kling1~=. & post~=. & dd~=. & sucurs~=. & miss_kling1==1 & cofficer_lb~=. & high_interest1==1   	
codebook idclient if kling1~=. & post~=. & dd~=. & sucurs~=. & miss_kling1==1 & cofficer_lb~=. & ed_mas==0   	
codebook idclient if kling1~=. & post~=. & dd~=. & sucurs~=. & miss_kling1==1 & cofficer_lb~=. & ed_mas==1   	
codebook idclient if kling1~=. & post~=. & dd~=. & sucurs~=. & miss_kling1==1 & cofficer_lb~=. & size2==0   	
codebook idclient if kling1~=. & post~=. & dd~=. & sucurs~=. & miss_kling1==1 & cofficer_lb~=. & size2==1   	
log close

*2) Business practices

log using "$a\results\table5_bbss_practices.log", replace
areg kling2 treatment sucurs lima1 lima2 aya1 if post==1 & idclient~=., absorb(cofficer_lb) cl(idbank)
areg kling2 treatment sucurs `covariates' lima1 lima2 aya1 if post==1 & idclient~=., absorb(cofficer_lb) cl(idbank)
areg kling2 treatment treatint1 high_interest1 sucurs missing2_new lima1 lima2 aya1 if post==1 & idclient~=., absorb(cofficer_lb) cl(idbank)
lincom treatment+treatint1
areg kling2 treatment treduc ed_mas sucurs missing3_new lima1 lima2 aya1 if post==1 & idclient~=., absorb(cofficer_lb) cl(idbank)
lincom treatment+treduc
areg kling2 treatment trsize2 size2 sucurs missing5_new lima1 lima2 aya1 if post==1 & idclient~=., absorb(cofficer_lb) cl(idbank)
lincom treatment+trsize2
codebook idclient if kling2~=. & post==1 & treatment~=. & sucurs~=. & cofficer_lb~=.
codebook idclient if kling2~=. & post==1 & treatment~=. & sucurs~=. & cofficer_lb~=. & high_interest1==0 
codebook idclient if kling2~=. & post==1 & treatment~=. & sucurs~=. & cofficer_lb~=. & high_interest1==1   	
codebook idclient if kling2~=. & post==1 & treatment~=. & sucurs~=. & cofficer_lb~=. & ed_mas==0 
codebook idclient if kling2~=. & post==1 & treatment~=. & sucurs~=. & cofficer_lb~=. & ed_mas==1  	
codebook idclient if kling2~=. & post==1 & treatment~=. & sucurs~=. & cofficer_lb~=. & size2==0 
codebook idclient if kling2~=. & post==1 & treatment~=. & sucurs~=. & cofficer_lb~=. & size2==1 
log close

*3) Household outcomes

foreach var of varlist kling3 kling4 kling5 {
log using "$a\results\table5_empower_`var'.log", replace
areg `var' post treatment dd sucurs if miss_`var'==1, absorb(cofficer_lb) cl(idbank)
areg `var' post treatment dd sucurs `covariates' if miss_`var'==1, absorb(cofficer_lb) cl(idbank) 
areg `var' post postint1 treatment treatint1 high_interest1 ddint1 dd sucurs missing2_new if miss_`var'==1, absorb(cofficer_lb) cl(idbank)
lincom dd+ddint1
areg `var' post posteduc treatment treduc ed_mas dd ddeduc sucurs missing3_new if miss_`var'==1, absorb(cofficer_lb) cl(idbank)
lincom dd+ddeduc
areg `var' post postsize2 treatment trsize2 size2 dd ddsize2 sucurs missing5_new if miss_`var'==1, absorb(cofficer_lb) cl(idbank)
lincom dd+ddsize2
codebook idclient if `var'~=. & post~=. & dd~=. & sucurs~=. & miss_`var'==1 & cofficer_lb~=.	
codebook idclient if `var'~=. & post~=. & dd~=. & sucurs~=. & miss_`var'==1 & cofficer_lb~=. & high_interest1==0   	
codebook idclient if `var'~=. & post~=. & dd~=. & sucurs~=. & miss_`var'==1 & cofficer_lb~=. & high_interest1==1   	
codebook idclient if `var'~=. & post~=. & dd~=. & sucurs~=. & miss_`var'==1 & cofficer_lb~=. & ed_mas==0   	
codebook idclient if `var'~=. & post~=. & dd~=. & sucurs~=. & miss_`var'==1 & cofficer_lb~=. & ed_mas==1   	
codebook idclient if `var'~=. & post~=. & dd~=. & sucurs~=. & miss_`var'==1 & cofficer_lb~=. & size2==0   	
codebook idclient if `var'~=. & post~=. & dd~=. & sucurs~=. & miss_`var'==1 & cofficer_lb~=. & size2==1   	
log close
}

****************************************************************************************************************************
****************************************************************************************************************************

*---------------------------------------*
*ANALYSIS OF ATTRITION EFFECTS (TABLE 7)*
*---------------------------------------*

* Restore the data in order to work with all clients (attrited and non attrited)
* Then, we generate aggregate index with bounds under three different bounds specification (min/max - non reversal - with sd assumptions)
* The final impacts with bounds are estimated for each family of outcomes (business results, practices and empowerment) 

*INDEX*
*-----*
*I) BOUNDS FOR BUSINESS RESULTS (FIRST ROW)
*II) BOUNDS FOR BUSINESS PRACTICES (SECOND ROW)
*III) BOUNDS FOR EMPOWERMENT (THIRD TO FIFTH ROW)

*Each of the three sections above contains the following subdivisions:
 *1) MIN-MAX BOUNDS - Column (1)&(9)
 *2) NON REVERSAL BOUNDS - Column (2)&(8)
 *3) BOUNDS WITH 0.25/0.10/0.05 SD - Column (3)(4)(6)(7)
 
*Each of the three sub-sections above contains the following subtitles:
   * Generating variables with bounds 
   * Generating aggregate index with bounds (Lower Bound/Upper Bound)
   * Creating missing constraints 
   * Impact Results with Attrition
*--------------------------------------------------------------------------*

restore

* See notes to table. 

*I) BOUNDS FOR BUSINESS RESULTS (FIRST ROW)*
*------------------------------------------*

*I.1) MIN-MAX BOUNDS - Column (1)&(9)*
*------------------------------------*

* Generating variables with bounds *

* Discrete variables: work / wk_out 

xtile work_10 = work if post==1 & treatment==0, nq(4)
sum work if work_10==4
scalar work_10 = r(mean)
sum work if work_10==1
scalar work_10_min = r(mean)

xtile work_11 = work if post==1 & treatment==1, nq(4)
sum work if work_11==4
scalar work_11 = r(mean)
sum work if work_11==1
scalar work_11_min = r(mean)

xtile work_00 = work if post==0 & treatment==0, nq(5)
sum work if work_00==5
scalar work_00 = r(mean)
sum work if work_00==1
scalar work_00_min = r(mean)

xtile work_01 = work if post==0 & treatment==1, nq(5)
sum work if work_01==5
scalar work_01 = r(mean)
sum work if work_01==1
scalar work_01_min = r(mean)

drop work_10* work_11* work_00* work_01*

xtile wk_out_10 = wk_out if post==1 & treatment==0, nq(10)
sum wk_out if wk_out_10==10
scalar wk_out_10 = r(mean)
sum wk_out if wk_out_10==1
scalar wk_out_10_min = r(mean)

xtile wk_out_11 = wk_out if post==1 & treatment==1, nq(10)
sum wk_out if wk_out_11==10
scalar wk_out_11 = r(mean)
sum wk_out if wk_out_11==1
scalar wk_out_11_min = r(mean)

xtile wk_out_00 = wk_out if post==0 & treatment==0, nq(10)
sum wk_out if wk_out_00==10
scalar wk_out_00 = r(mean)
sum wk_out if wk_out_00==1
scalar wk_out_00_min = r(mean)

xtile wk_out_01 =wk_out if post==0 & treatment==1, nq(10)
sum wk_out if wk_out_01==10
scalar wk_out_01 = r(mean)
sum wk_out if wk_out_01==1
scalar wk_out_01_min = r(mean)

drop wk_out_10* wk_out_11* wk_out_00* wk_out_01*

foreach var of varlist work wk_out {
gen lb_`var'1=`var'
gen ub_`var'1=`var'

replace lb_`var'1=`var'_10 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'1=`var'_11_min if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'1=`var'_10_min if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'1=`var'_11 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1

replace lb_`var'1=`var'_00_min if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'1=`var'_01 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'1=`var'_00 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'1=`var'_01_min if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
}

* Continuous variables: sales (good, normal, bad)

foreach var of varlist lventasc lvgood lvnormal lvbad rlgap {
xtile `var'_10 = `var' if post==1 & treatment==0, nq(10)
sum `var' if `var'_10==10
scalar `var'_10 = r(mean)
sum `var' if `var'_10==1
scalar `var'_10_min = r(mean)

xtile `var'_11 = `var' if post==1 & treatment==1, nq(10)
sum `var' if `var'_11==10
scalar `var'_11 = r(mean)
sum `var' if `var'_11==1
scalar `var'_11_min = r(mean)

xtile `var'_00 = `var' if post==0 & treatment==0, nq(10)
sum `var' if `var'_00==10
scalar `var'_00 = r(mean)
sum `var' if `var'_00==1
scalar `var'_00_min = r(mean)

xtile `var'_01 =`var' if post==0 & treatment==1, nq(10)
sum `var' if `var'_01==10
scalar `var'_01 = r(mean)
sum `var' if `var'_01==1
scalar `var'_01_min = r(mean)

drop `var'_10* `var'_11* `var'_00* `var'_01*

gen lb_`var'1=`var'
gen ub_`var'1=`var'

replace lb_`var'1=`var'_10 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'1=`var'_11_min if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'1=`var'_10_min if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'1=`var'_11 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1

replace lb_`var'1=`var'_00_min if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'1=`var'_01 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'1=`var'_00 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'1=`var'_01_min if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
}

* Generating aggregate index with bounds *

* Lower Bound
for var lb_lventasc1 lb_lvgood1 lb_lvnormal1 lb_lvbad1 lb_rlgap1 lb_work1 lb_wk_out1: gen p_X=X if treatment==0 & post==0 
foreach var of varlist p_lb_lventasc1 p_lb_lvgood1 p_lb_lvnormal1 p_lb_lvbad1 p_lb_rlgap1 p_lb_work1 p_lb_wk_out1  {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_lb_lventasc1 p_lb_lvgood1 p_lb_lvnormal1 p_lb_lvbad1 p_lb_rlgap1 p_lb_work1 p_lb_wk_out1
for X in any lb_lventasc1 lb_lvgood1 lb_lvnormal1 lb_lvbad1 lb_rlgap1 lb_work1 lb_wk_out1: gen kl_X=(X-p_X_mean)/p_X_sd
egen lbmiss_kling1=rownonmiss(kl_lb_lventasc1 kl_lb_lvgood1 kl_lb_lvnormal1 kl_lb_lvbad1 kl_lb_rlgap1 kl_lb_work1 kl_lb_wk_out1)
gen lbkling1=(kl_lb_lventasc1+kl_lb_lvgood1+kl_lb_lvnormal1+kl_lb_lvbad1+kl_lb_rlgap1+kl_lb_work1+kl_lb_wk_out1)/7 if lbmiss_kling1==7

* Upper Bound
for var ub_lventasc1 ub_lvgood1 ub_lvnormal1 ub_lvbad1 ub_rlgap1 ub_work1 ub_wk_out1: gen p_X=X if treatment==0 & post==0 
foreach var of varlist p_ub_lventasc1 p_ub_lvgood1 p_ub_lvnormal1 p_ub_lvbad1 p_ub_rlgap1 p_ub_work1 p_ub_wk_out1  {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_ub_lventasc1 p_ub_lvgood1 p_ub_lvnormal1 p_ub_lvbad1 p_ub_rlgap1 p_ub_work1 p_ub_wk_out1
for X in any ub_lventasc1 ub_lvgood1 ub_lvnormal1 ub_lvbad1 ub_rlgap1 ub_work1 ub_wk_out1: gen kl_X=(X-p_X_mean)/p_X_sd
egen ubmiss_kling1=rownonmiss(kl_ub_lventasc1 kl_ub_lvgood1 kl_ub_lvnormal1 kl_ub_lvbad1 kl_ub_rlgap1 kl_ub_work1 kl_ub_wk_out1)
gen ubkling1=(kl_ub_lventasc1+kl_ub_lvgood1+kl_ub_lvnormal1+kl_ub_lvbad1+kl_ub_rlgap1+kl_ub_work1+kl_ub_wk_out1)/7 if ubmiss_kling1==7

* Creating missing constraints *

bys idclient: gen n2=_n
foreach X of varlist lbkling1 ubkling1 {
gen uno = (n2==1 | n2==2) & `X'~=. & idclient~=.
bys idclient: egen miss_`X'=min(uno)
drop uno
}

* Impact Results with Attrition - Column (1)&(9) *

log using "$a\results\table7_bussresults.log", replace
*Column (1)&(9)
areg lbkling1 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbkling1==1, absorb(cofficer_lb) cl(idbank)
areg ubkling1 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubkling1==1, absorb(cofficer_lb) cl(idbank)
log close


*I.2) NON REVERSAL BOUNDS - Column (2)&(8)*
*-----------------------------------------*

* Generating variables with bounds *

* Discrete variables: work / wk_out

sort idclient post, stable
by idclient (post): gen resta_work=1+((work-work[_n-1])/work[_n-1])

xtile work0=resta_work if post==1 & treatment==0, nq(7)
egen work0_temp_min=median(resta_work) if work0==1
sum  work0_temp_min
scalar resta_work0_min = r(mean)
egen work0_temp=median(resta_work) if work0==7
sum  work0_temp
scalar resta_work0 = r(mean)

xtile work1=resta_work if post==1 & treatment==1, nq(7)
egen work1_temp_min=median(resta_work) if work1==1
sum  work1_temp_min
scalar resta_work1_min = r(mean)
egen work1_temp=median(resta_work) if work1==7
sum  work1_temp
scalar resta_work1 = r(mean)

sort idclient post, stable
by idclient (post): gen tempo_work=work[_n-1] 
drop work0 work1 work0_temp* work1_temp*

sort idclient post, stable
by idclient (post): gen bstempo_work=work[_n+1] 

gen lb_work2=work
gen ub_work2=work

replace lb_work2=tempo_work*resta_work0 if (attrition==1 | (attrition==2 & work==.)) & post==1 & treatment==0
replace lb_work2=16 if lb_work2>16 & post==1 & treatment==0 & tempo_work~=.
replace lb_work2=tempo_work*resta_work1_min if (attrition==1 | (attrition==2 & work==.)) & post==1 & treatment==1
replace lb_work2=1 if lb_work2<1 & post==1 & treatment==1 & tempo_work~=.
replace lb_work2=work_10 if lb_work2==. & post==1 & treatment==0
replace lb_work2=work_11_min if lb_work2==. & post==1 & treatment==1

replace ub_work2=tempo_work*resta_work0_min if (attrition==1 | (attrition==2 & work==.)) & post==1 & treatment==0
replace ub_work2=1 if ub_work2<1 & post==1 & treatment==0 & tempo_work~=.
replace ub_work2=tempo_work*resta_work1 if (attrition==1 | (attrition==2 & work==.)) & post==1 & treatment==1
replace ub_work2=19 if ub_work2>19 & post==1 & treatment==1 & tempo_work~=.
replace ub_work2=work_10_min if ub_work2==. & post==1 & treatment==0
replace ub_work2=work_11 if ub_work2==. & post==1 & treatment==1

replace lb_work2=bstempo_work/resta_work0 if ((attrition==1 & work==.) | (attrition==2 & work==.)) & post==0 & treatment==0
replace lb_work2=1 if lb_work2<1 & post==0 & treatment==0 & bstempo_work~=.
replace lb_work2=bstempo_work/resta_work1_min if ((attrition==1 & work==.) | (attrition==2 & work==.)) & post==0 & treatment==1
replace lb_work2=work_00_min if lb_work2==. & post==0 & treatment==0
replace lb_work2=work_01 if lb_work2==.  & post==0 & treatment==1

replace ub_work2=bstempo_work/resta_work0_min if ((attrition==1 & work==.) | (attrition==2 & work==.)) & post==0 & treatment==0
replace ub_work2=bstempo_work/resta_work1 if ((attrition==1 & work==.) | (attrition==2 & work==.)) & post==0 & treatment==1
replace ub_work2=1 if ub_work2<1 & post==0 & treatment==1 & bstempo_work~=.
replace ub_work2=work_00 if ub_work2==. & post==0 & treatment==0
replace ub_work2=work_01_min if ub_work2==. & post==0 & treatment==1

gen rwk_out=wk_out
replace rwk_out=wk_out+0.000001 if wk_out==0

sort idclient post, stable
by idclient (post): gen resta_wk=1+((rwk_out-rwk_out[_n-1])/rwk_out[_n-1])

xtile wk0=resta_wk if post==1 & treatment==0 & resta_wk<15 & resta_wk>0.14, nq(80)

egen wk0_temp_min=median(resta_wk) if wk0==1
sum  wk0_temp_min
scalar resta_wk0_min = r(mean)
egen wk0_temp=median(resta_wk) if wk0==80
sum  wk0_temp
scalar resta_wk0 = r(mean)

xtile wk1=resta_wk if post==1 & treatment==1 & resta_wk<15 & resta_wk>0.14, nq(80)
egen wk1_temp_min=median(resta_wk) if wk1==1
sum  wk1_temp_min
scalar resta_wk1_min = r(mean)
egen wk1_temp=median(resta_wk) if wk1==80
sum  wk1_temp
scalar resta_wk1 = r(mean)

sort idclient post, stable
by idclient (post): gen tempo_wk=wk_out[_n-1] 
drop wk0 wk1 wk0_temp* wk1_temp*

sort idclient post, stable
by idclient (post): gen bstempo_wk=wk_out[_n+1] 

gen lb_wk_out2=wk_out
gen ub_wk_out2=wk_out

replace lb_wk_out2=tempo_wk*resta_wk0 if (attrition==1 | (attrition==2 & wk_out==.)) & post==1 & treatment==0 & tempo_wk~=0
replace lb_wk_out2=wk_out_10 if (attrition==1 | (attrition==2 & wk_out==.)) & post==1 & treatment==0 & tempo_wk==0
replace lb_wk_out2=14 if lb_wk_out2>14 & post==1 & treatment==0 & tempo_wk~=.
replace lb_wk_out2=tempo_wk*resta_wk1_min if (attrition==1 | (attrition==2 & wk_out==.)) & post==1 & treatment==1
replace lb_wk_out2=wk_out_10 if lb_wk_out2==. & post==1 & treatment==0
replace lb_wk_out2=wk_out_11_min if lb_wk_out2==. & post==1 & treatment==1

replace ub_wk_out2=tempo_wk*resta_wk0_min if (attrition==1 | (attrition==2 & wk_out==.)) & post==1 & treatment==0
replace ub_wk_out2=14 if ub_wk_out2>14 & post==1 & treatment==0 & tempo_wk~=.
replace ub_wk_out2=tempo_wk*resta_wk1 if (attrition==1 | (attrition==2 & wk_out==.)) & post==1 & treatment==1 & tempo_wk~=0
replace ub_wk_out2=wk_out_11 if (attrition==1 | (attrition==2 & wk_out==.)) & post==1 & treatment==1 & tempo_wk==0
replace ub_wk_out2=22 if ub_wk_out2>22 & post==1 & treatment==1 & tempo_wk~=.
replace ub_wk_out2=wk_out_10_min if ub_wk_out2==. & post==1 & treatment==0
replace ub_wk_out2=wk_out_11 if ub_wk_out2==. & post==1 & treatment==1

replace lb_wk_out2=bstempo_wk/resta_wk0 if ((attrition==1 & wk_out==.) | (attrition==2 & wk_out==.)) & post==0 & treatment==0
replace lb_wk_out2=bstempo_wk/resta_wk1_min if ((attrition==1 & wk_out==.) | (attrition==2 & wk_out==.)) & post==0 & treatment==1
replace lb_wk_out2=wk_out_00_min if lb_wk_out2==. & post==0 & treatment==0
replace lb_wk_out2=wk_out_01 if lb_wk_out2==. & post==0 & treatment==1

replace ub_wk_out2=bstempo_wk/resta_wk0_min if ((attrition==1 & wk_out==.) | (attrition==2 & wk_out==.)) & post==0 & treatment==0
replace ub_wk_out2=bstempo_wk/resta_wk1 if ((attrition==1 & wk_out==.) | (attrition==2 & wk_out==.)) & post==0 & treatment==1
replace ub_wk_out2=wk_out_00 if ub_wk_out2==. & post==0 & treatment==0
replace ub_wk_out2=wk_out_01_min if ub_wk_out2==. & post==0 & treatment==1

* Continuous variables: sales (good, normal, bad)

foreach var of varlist lventasc lvgood lvnormal lvbad rlgap  {

sort idclient post, stable
by idclient (post): gen factor_`var'=1+((`var'-`var'[_n-1])/`var'[_n-1])

xtile `var'0=factor_`var' if post==1 & treatment==0, nq(5)
egen `var'0_temp_min=median(factor_`var') if `var'0==1
sum  `var'0_temp_min
scalar factor_`var'0_min = r(mean)
egen `var'0_temp=median(factor_`var') if `var'0==5
sum  `var'0_temp
scalar factor_`var'0 = r(mean)

xtile `var'1=factor_`var' if post==1 & treatment==1, nq(5)
egen `var'1_temp_min=median(factor_`var') if `var'1==1
sum  `var'1_temp_min
scalar factor_`var'1_min = r(mean)
egen `var'1_temp=median(factor_`var') if `var'1==5
sum  `var'1_temp
scalar factor_`var'1 = r(mean)

sort idclient post, stable
by idclient (post): gen tempo_`var'=`var'[_n-1] 
drop `var'0 `var'1 `var'0_temp* `var'1_temp*

sort idclient post, stable
by idclient (post): gen bstempo_`var'=`var'[_n+1] 

gen lb_`var'2=`var'
gen ub_`var'2=`var'

replace lb_`var'2=tempo_`var'*factor_`var'0 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'2=tempo_`var'*factor_`var'1_min if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace lb_`var'2=`var'_10 if lb_`var'2==. & post==1 & treatment==0
replace lb_`var'2=`var'_11_min if lb_`var'2==. & post==1 & treatment==1

replace ub_`var'2=tempo_`var'*factor_`var'0_min if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'2=tempo_`var'*factor_`var'1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'2=`var'_10_min if ub_`var'2==. & post==1 & treatment==0
replace ub_`var'2=`var'_11 if ub_`var'2==. & post==1 & treatment==1

replace lb_`var'2=bstempo_`var'/factor_`var'0 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'2=bstempo_`var'/factor_`var'1_min if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace lb_`var'2=`var'_00_min if lb_`var'2==. & post==0 & treatment==0
replace lb_`var'2=`var'_01 if lb_`var'2==. & post==0 & treatment==1

replace ub_`var'2=bstempo_`var'/factor_`var'0_min if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'2=bstempo_`var'/factor_`var'1 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'2=`var'_00 if ub_`var'2==. & post==0 & treatment==0
replace ub_`var'2=`var'_01_min if ub_`var'2==. & post==0 & treatment==1
}

* Generating aggregate index with bounds *

* Lower Bound
for var lb_lventasc2 lb_lvgood2 lb_lvnormal2 lb_lvbad2 lb_rlgap2 lb_work2 lb_wk_out2: gen p_X=X if treatment==0 & post==0 
foreach var of varlist p_lb_lventasc2 p_lb_lvgood2 p_lb_lvnormal2 p_lb_lvbad2 p_lb_rlgap2 p_lb_work2 p_lb_wk_out2  {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_lb_lventasc2 p_lb_lvgood2 p_lb_lvnormal2 p_lb_lvbad2 p_lb_rlgap2 p_lb_work2 p_lb_wk_out2
for X in any lb_lventasc2 lb_lvgood2 lb_lvnormal2 lb_lvbad2 lb_rlgap2 lb_work2 lb_wk_out2: gen kl_X=(X-p_X_mean)/p_X_sd
egen lbmiss_kling2=rownonmiss(kl_lb_lventasc2 kl_lb_lvgood2 kl_lb_lvnormal2 kl_lb_lvbad2 kl_lb_rlgap2 kl_lb_work2 kl_lb_wk_out2)
gen lbkling2=(kl_lb_lventasc2+kl_lb_lvgood2+kl_lb_lvnormal2+kl_lb_lvbad2+kl_lb_rlgap2+kl_lb_work2+kl_lb_wk_out2)/7 if lbmiss_kling2==7

* Upper Bound
for var ub_lventasc2 ub_lvgood2 ub_lvnormal2 ub_lvbad2 ub_rlgap2 ub_work2 ub_wk_out2: gen p_X=X if treatment==0 & post==0 
foreach var of varlist p_ub_lventasc2 p_ub_lvgood2 p_ub_lvnormal2 p_ub_lvbad2 p_ub_rlgap2 p_ub_work2 p_ub_wk_out2  {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_ub_lventasc2 p_ub_lvgood2 p_ub_lvnormal2 p_ub_lvbad2 p_ub_rlgap2 p_ub_work2 p_ub_wk_out2
for X in any ub_lventasc2 ub_lvgood2 ub_lvnormal2 ub_lvbad2 ub_rlgap2 ub_work2 ub_wk_out2: gen kl_X=(X-p_X_mean)/p_X_sd
egen ubmiss_kling2=rownonmiss(kl_ub_lventasc2 kl_ub_lvgood2 kl_ub_lvnormal2 kl_ub_lvbad2 kl_ub_rlgap2 kl_ub_work2 kl_ub_wk_out2)
gen ubkling2=(kl_ub_lventasc2+kl_ub_lvgood2+kl_ub_lvnormal2+kl_ub_lvbad2+kl_ub_rlgap2+kl_ub_work2+kl_ub_wk_out2)/7 if ubmiss_kling2==7

* Creating missing constraints *

foreach X of varlist lbkling2 ubkling2 {
gen uno = (n2==1 | n2==2) & `X'~=. & idclient~=.
bys idclient: egen miss_`X'=min(uno)
drop uno
}

* Impact Results with Attrition - Column (2)&(8)*

log using "$a\results\table7_bussresults.log", append
*Column (2)&(8)
areg lbkling2 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbkling2==1, absorb(cofficer_lb) cl(idbank)
areg ubkling2 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubkling2==1, absorb(cofficer_lb) cl(idbank)
log close


*I.3) BOUNDS WITH 0.25/0.10/0.05 SD - Column (3)(4)(6)(7)*
*--------------------------------------------------------*

* Generating variables with bounds *

* Discrete variables: work / wk_out

sum work if post==1 & treatment==0
scalar work_10_mean = r(mean)
scalar work_10_sd = r(sd)

sum work if post==1 & treatment==1
scalar work_11_mean = r(mean)
scalar work_11_sd = r(sd)

sum work if post==0 & treatment==0
scalar work_00_mean = r(mean)
scalar work_00_sd = r(sd)

sum work if post==0 & treatment==1
scalar work_01_mean = r(mean)
scalar work_01_sd= r(sd)

sum wk_out if post==1 & treatment==0
scalar wk_out_10_mean = r(mean)
scalar wk_out_10_sd = r(sd)

sum wk_out if post==1 & treatment==1
scalar wk_out_11_mean = r(mean)
scalar wk_out_11_sd = r(sd)

sum wk_out if post==0 & treatment==0
scalar wk_out_00_mean = r(mean)
scalar wk_out_00_sd = r(sd)

sum wk_out if post==0 & treatment==1
scalar wk_out_01_mean = r(mean)
scalar wk_out_01_sd = r(sd)

foreach var of varlist work wk_out {
gen lb_`var'3a=`var'
gen ub_`var'3a=`var'
replace lb_`var'3a=`var'_10_mean+0.25*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'3a=`var'_11_mean-0.25*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'3a=`var'_10_mean-0.25*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'3a=`var'_11_mean+0.25*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace lb_`var'3a=`var'_00_mean-0.25*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'3a=`var'_01_mean+0.25*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'3a=`var'_00_mean+0.25*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'3a=`var'_01_mean-0.25*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1

gen lb_`var'3b=`var'
gen ub_`var'3b=`var'
replace lb_`var'3b=`var'_10_mean+0.10*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'3b=`var'_11_mean-0.10*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'3b=`var'_10_mean-0.10*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'3b=`var'_11_mean+0.10*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace lb_`var'3b=`var'_00_mean-0.10*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'3b=`var'_01_mean+0.10*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'3b=`var'_00_mean+0.10*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'3b=`var'_01_mean-0.10*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1

gen lb_`var'3c=`var'
gen ub_`var'3c=`var'
replace lb_`var'3c=`var'_10_mean+0.05*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'3c=`var'_11_mean-0.05*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'3c=`var'_10_mean-0.05*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'3c=`var'_11_mean+0.05*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace lb_`var'3c=`var'_00_mean-0.05*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'3c=`var'_01_mean+0.05*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'3c=`var'_00_mean+0.05*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'3c=`var'_01_mean-0.05*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
}

* Continuous variables: sales (good, normal, bad)

foreach var of varlist lventasc lvgood lvnormal lvbad rlgap  {
sum `var' if post==1 & treatment==0
scalar `var'_10_mean = r(mean)
scalar `var'_10_sd = r(sd)

sum `var' if post==1 & treatment==1
scalar `var'_11_mean = r(mean)
scalar `var'_11_sd = r(sd)

sum `var' if post==0 & treatment==0
scalar `var'_00_mean = r(mean)
scalar `var'_00_sd = r(sd)

sum `var' if post==0 & treatment==1
scalar `var'_01_mean = r(mean)
scalar `var'_01_sd = r(sd)

gen lb_`var'3a=`var'
gen ub_`var'3a=`var'
replace lb_`var'3a=`var'_10_mean+0.25*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'3a=`var'_11_mean-0.25*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'3a=`var'_10_mean-0.25*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'3a=`var'_11_mean+0.25*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace lb_`var'3a=`var'_00_mean-0.25*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'3a=`var'_01_mean+0.25*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'3a=`var'_00_mean+0.25*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'3a=`var'_01_mean-0.25*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1

gen lb_`var'3b=`var'
gen ub_`var'3b=`var'
replace lb_`var'3b=`var'_10_mean+0.10*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'3b=`var'_11_mean-0.10*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'3b=`var'_10_mean-0.10*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'3b=`var'_11_mean+0.10*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace lb_`var'3b=`var'_00_mean-0.10*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'3b=`var'_01_mean+0.10*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'3b=`var'_00_mean+0.10*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'3b=`var'_01_mean-0.10*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1

gen lb_`var'3c=`var'
gen ub_`var'3c=`var'
replace lb_`var'3c=`var'_10_mean+0.05*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'3c=`var'_11_mean-0.05*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'3c=`var'_10_mean-0.05*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'3c=`var'_11_mean+0.05*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace lb_`var'3c=`var'_00_mean-0.05*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'3c=`var'_01_mean+0.05*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'3c=`var'_00_mean+0.05*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'3c=`var'_01_mean-0.05*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
}

* Generating aggregate index with bounds *

foreach x of any a b c {
       
* Lower Bound
for var lb_lventasc3`x' lb_lvgood3`x' lb_lvnormal3`x' lb_lvbad3`x' lb_rlgap3`x' lb_work3`x' lb_wk_out3`x': gen p_X=X if treatment==0 & post==0 
foreach var of varlist p_lb_lventasc3`x' p_lb_lvgood3`x' p_lb_lvnormal3`x' p_lb_lvbad3`x' p_lb_rlgap3`x' p_lb_work3`x' p_lb_wk_out3`x'  {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_lb_lventasc3`x' p_lb_lvgood3`x' p_lb_lvnormal3`x' p_lb_lvbad3`x' p_lb_rlgap3`x' p_lb_work3`x' p_lb_wk_out3`x'
for X in any lb_lventasc3`x' lb_lvgood3`x' lb_lvnormal3`x' lb_lvbad3`x' lb_rlgap3`x' lb_work3`x' lb_wk_out3`x': gen kl_X=(X-p_X_mean)/p_X_sd
egen lbmiss_kling3`x'=rownonmiss(kl_lb_lventasc3`x' kl_lb_lvgood3`x' kl_lb_lvnormal3`x' kl_lb_lvbad3`x' kl_lb_rlgap3`x' kl_lb_work3`x' kl_lb_wk_out3`x')
gen lbkling3`x'=(kl_lb_lventasc3`x'+kl_lb_lvgood3`x'+kl_lb_lvnormal3`x'+kl_lb_lvbad3`x'+kl_lb_rlgap3`x'+kl_lb_work3`x'+kl_lb_wk_out3`x')/7 if lbmiss_kling3`x'==7

* Upper Bound
for var ub_lventasc3`x' ub_lvgood3`x' ub_lvnormal3`x' ub_lvbad3`x' ub_rlgap3`x' ub_work3`x' ub_wk_out3`x': gen p_X=X if treatment==0 & post==0 
foreach var of varlist p_ub_lventasc3`x' p_ub_lvgood3`x' p_ub_lvnormal3`x' p_ub_lvbad3`x' p_ub_rlgap3`x' p_ub_work3`x' p_ub_wk_out3`x'  {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_ub_lventasc3`x' p_ub_lvgood3`x' p_ub_lvnormal3`x' p_ub_lvbad3`x' p_ub_rlgap3`x' p_ub_work3`x' p_ub_wk_out3`x'
for X in any ub_lventasc3`x' ub_lvgood3`x' ub_lvnormal3`x' ub_lvbad3`x' ub_rlgap3`x' ub_work3`x' ub_wk_out3`x': gen kl_X=(X-p_X_mean)/p_X_sd
egen ubmiss_kling3`x'=rownonmiss(kl_ub_lventasc3`x' kl_ub_lvgood3`x' kl_ub_lvnormal3`x' kl_ub_lvbad3`x' kl_ub_rlgap3`x' kl_ub_work3`x' kl_ub_wk_out3`x')
gen ubkling3`x'=(kl_ub_lventasc3`x'+kl_ub_lvgood3`x'+kl_ub_lvnormal3`x'+kl_ub_lvbad3`x'+kl_ub_rlgap3`x'+kl_ub_work3`x'+kl_ub_wk_out3`x')/7 if ubmiss_kling3`x'==7

* Creating missing constraints *

foreach X of varlist lbkling3`x' ubkling3`x' {
gen uno = (n2==1 | n2==2) & `X'~=. & idclient~=.
bys idclient: egen miss_`X'=min(uno)
drop uno
}

}

* Impact Results with Attrition - Columns (3)(4)(6)(7)*

log using "$a\results\table7_bussresults.log", append
*Column (3)&(7): 0.25 SD
areg lbkling3a post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbkling3a==1, absorb(cofficer_lb) cl(idbank)
areg ubkling3a post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubkling3a==1, absorb(cofficer_lb) cl(idbank)
*Column (4)&(6): 0.10 SD
areg lbkling3b post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbkling3b==1, absorb(cofficer_lb) cl(idbank)
areg ubkling3b post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubkling3b==1, absorb(cofficer_lb) cl(idbank)
*Column (4)&(6): 0.05 SD
areg lbkling3c post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbkling3c==1, absorb(cofficer_lb) cl(idbank)
areg ubkling3c post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubkling3c==1, absorb(cofficer_lb) cl(idbank)
log close

drop lbkling* ubkling* lbmiss_kling* ubmiss_kling* miss_ubkling* miss_lbkling*

*II) BOUNDS FOR BUSINESS PRACTICES (SECOND ROW)*
*----------------------------------------------*

*II.1) MIN-MAX BOUNDS - Column (1)&(9)*
*------------------------------------*

* Generating variables with bounds *

* Discrete variable: rsources (FU in ayacucho only)

gen lb_rsources1=rsources
gen ub_rsources1=rsources

replace lb_rsources1=5 if attrition==1 & post==1 & treatment==0 & cod_sucurs==5
replace lb_rsources1=0 if attrition==1 & post==1 & treatment==1 & cod_sucurs==5

replace ub_rsources1=0 if attrition==1 & post==1 & treatment==0 & cod_sucurs==5
replace ub_rsources1=5 if attrition==1 & post==1 & treatment==1 & cod_sucurs==5

* Discrete variable: local

gen lb_local1=local
gen ub_local1=local

replace lb_local1=3 if attrition==1 & post==1 & treatment==0
replace lb_local1=0 if attrition==1 & post==1 & treatment==1

replace ub_local1=0 if attrition==1 & post==1 & treatment==0
replace ub_local1=4 if attrition==1 & post==1 & treatment==1

* Discrete variable: sum_know 

gen lb_sum_know1=sum_know
gen ub_sum_know1=sum_know

replace lb_sum_know1=8 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==0
replace lb_sum_know1=0 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==1
replace ub_sum_know1=0 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==0
replace ub_sum_know1=13 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==1

* Dichotomic variables:  

foreach var of varlist ruc rfixed rec_sales credit record_pay2 start_newb profit think do  {
gen lb_`var'1=`var'
gen ub_`var'1=`var'

replace lb_`var'1=1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'1=0 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1

replace ub_`var'1=0 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'1=1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
}

foreach var of varlist rrec_take rprob {
gen lb_`var'1=`var'
gen ub_`var'1=`var'

replace lb_`var'1=1 if (attrition==1 | attrition==2) & post==1 & treatment==0 & cod_sucurs==1 & `var'==.
replace lb_`var'1=0 if (attrition==1 | attrition==2) & post==1 & treatment==1 & cod_sucurs==1 & `var'==.
replace ub_`var'1=0 if (attrition==1 | attrition==2) & post==1 & treatment==0 & cod_sucurs==1 & `var'==.
replace ub_`var'1=1 if (attrition==1 | attrition==2) & post==1 & treatment==1 & cod_sucurs==1 & `var'==.
} 

* Generating aggregate index with bounds *

* Lower Bound
for var lb_ruc1 lb_rfixed1 lb_rec_sales1 lb_local1 lb_credit1 lb_record_pay21 lb_sum_know1 lb_start_newb1 lb_profit1 lb_think1 lb_do1 lb_rsources1 lb_rrec_take1 lb_rprob1: gen p_X=X if treatment==0 & post==1 
foreach var of varlist p_lb_ruc1 p_lb_rfixed1 p_lb_rec_sales1 p_lb_local1 p_lb_credit1 p_lb_record_pay21 p_lb_sum_know1 p_lb_start_newb1 p_lb_profit1 p_lb_think1 p_lb_do1 p_lb_rsources1 p_lb_rrec_take1 p_lb_rprob1 {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_lb_ruc1 p_lb_rfixed1 p_lb_rec_sales1 p_lb_local1 p_lb_credit1 p_lb_record_pay21 p_lb_sum_know1 p_lb_start_newb1 p_lb_profit1 p_lb_think1 p_lb_do1 p_lb_rsources1 p_lb_rrec_take1 p_lb_rprob1
for X in any lb_ruc1 lb_rfixed1 lb_rec_sales1 lb_local1 lb_credit1 lb_record_pay21 lb_sum_know1 lb_start_newb1 lb_profit1 lb_think1 lb_do1 lb_rsources1 lb_rrec_take1 lb_rprob1: gen kl_X=(X-p_X_mean)/p_X_sd
egen lbmiss_kling1=rownonmiss(kl_lb_ruc1 kl_lb_rfixed1 kl_lb_rec_sales1 kl_lb_local1 kl_lb_credit1 kl_lb_record_pay21 kl_lb_sum_know1 kl_lb_start_newb1 kl_lb_profit1 kl_lb_think1 kl_lb_do1 kl_lb_rsources1 kl_lb_rrec_take1 kl_lb_rprob1)
gen lbkling1=(kl_lb_ruc1+kl_lb_rfixed1+kl_lb_rec_sales1+kl_lb_local1+kl_lb_credit1+kl_lb_record_pay21+kl_lb_sum_know1+kl_lb_start_newb1+kl_lb_profit1+kl_lb_think1+kl_lb_do1+kl_lb_rsources1+kl_lb_rrec_take1+kl_lb_rprob1)/14 if lbmiss_kling1==14

* Upper Bound

for var ub_ruc1 ub_rfixed1 ub_rec_sales1 ub_local1 ub_credit1 ub_record_pay21 ub_sum_know1 ub_start_newb1 ub_profit1 ub_think1 ub_do1 ub_rsources1 ub_rrec_take1 ub_rprob1: gen p_X=X if treatment==0 & post==1 
foreach var of varlist p_ub_ruc1 p_ub_rfixed1 p_ub_rec_sales1 p_ub_local1 p_ub_credit1 p_ub_record_pay21 p_ub_sum_know1 p_ub_start_newb1 p_ub_profit1 p_ub_think1 p_ub_do1 p_ub_rsources1 p_ub_rrec_take1 p_ub_rprob1 {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_ub_ruc1 p_ub_rfixed1 p_ub_rec_sales1 p_ub_local1 p_ub_credit1 p_ub_record_pay21 p_ub_sum_know1 p_ub_start_newb1 p_ub_profit1 p_ub_think1 p_ub_do1 p_ub_rsources1 p_ub_rrec_take1 p_ub_rprob1
for X in any ub_ruc1 ub_rfixed1 ub_rec_sales1 ub_local1 ub_credit1 ub_record_pay21 ub_sum_know1 ub_start_newb1 ub_profit1 ub_think1 ub_do1 ub_rsources1 ub_rrec_take1 ub_rprob1: gen kl_X=(X-p_X_mean)/p_X_sd
egen ubmiss_kling1=rownonmiss(kl_ub_ruc1 kl_ub_rfixed1 kl_ub_rec_sales1 kl_ub_local1 kl_ub_credit1 kl_ub_record_pay21 kl_ub_sum_know1 kl_ub_start_newb1 kl_ub_profit1 kl_ub_think1 kl_ub_do1 kl_ub_rsources1 kl_ub_rrec_take1 kl_ub_rprob1)
gen ubkling1=(kl_ub_ruc1+kl_ub_rfixed1+kl_ub_rec_sales1+kl_ub_local1+kl_ub_credit1+kl_ub_record_pay21+kl_ub_sum_know1+kl_ub_start_newb1+kl_ub_profit1+kl_ub_think1+kl_ub_do1+kl_ub_rsources1+kl_ub_rrec_take1+kl_ub_rprob1)/14 if ubmiss_kling1==14

* Impact Results with Attrition - Column (1)&(9) *

log using "$a\results\table7_busspractices.log", replace
*Column (1)&(9)
areg lbkling1 treatment sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g lima1 lima2 aya1 if post==1, absorb(cofficer_lb) cl(idbank)
areg ubkling1 treatment sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g lima1 lima2 aya1 if post==1, absorb(cofficer_lb) cl(idbank)
log close


*II.2) NON REVERSAL BOUNDS - Column (2)&(8)*
*------------------------------------------*

* Generating variables with bounds *

* Discrete variable: sources (reversal only for ayacucho)

sort idclient post, stable
by idclient (post): gen factor_source=1+((rsources-rsources[_n-1])/rsources[_n-1])

xtile source0=factor_source if post==1 & treatment==0 & cod_sucurs==5, nq(10)
egen source0_temp_min=median(factor_source) if source0==1
sum  source0_temp_min
scalar factor_source0_min = r(mean)
egen source0_temp=median(factor_source) if source0==10
sum source0_temp
scalar factor_source0 = r(mean)

xtile source1=factor_source if post==1 & treatment==1 & cod_sucurs==5, nq(10)
egen source1_temp_min=median(factor_source) if source1==1
sum  source1_temp_min
scalar factor_source1_min = r(mean)
egen source1_temp=median(factor_source) if source1==10
sum  source1_temp
scalar factor_source1 = r(mean)

sort idclient post, stable
by idclient (post): gen tempo_source=rsources[_n-1] 

drop source0 source1 source0_temp* source1_temp*

gen lb_rsources2=rsources
gen ub_rsources2=rsources

replace lb_rsources2=tempo_source*factor_source0 if attrition==1 & post==1 & treatment==0 & cod_sucurs==5
replace lb_rsources2=tempo_source*factor_source1_min if attrition==1 & post==1 & treatment==1 & cod_sucurs==5
replace ub_rsources2=tempo_source*factor_source0_min if attrition==1 & post==1 & treatment==0 & cod_sucurs==5
replace ub_rsources2=tempo_source*factor_source1 if attrition==1 & post==1 & treatment==1 & cod_sucurs==5

* Discrete variable: local

sort idclient post, stable
by idclient (post): gen factor_local=1+((local-local[_n-1])/local[_n-1])

xtile local0=factor_local if post==1 & treatment==0, nq(20)
egen local0_temp_min=median(factor_local) if local0==1
sum  local0_temp_min
scalar factor_local0_min = r(mean)
egen local0_temp=median(factor_local) if local0==20
sum  local0_temp
scalar factor_local0 = r(mean)

xtile local1=factor_local if post==1 & treatment==1, nq(20)
egen local1_temp_min=median(factor_local) if local1==1
sum  local1_temp_min
scalar factor_local1_min = r(mean)
egen local1_temp=median(factor_local) if local1==20
sum  local1_temp
scalar factor_local1 = r(mean)

sort idclient post, stable
by idclient (post): gen tempo_local=local[_n-1] 

drop local0 local1 local0_temp* local1_temp*

gen lb_local2=local
gen ub_local2=local

replace lb_local2=tempo_local*factor_local0 if attrition==1 & post==1 & treatment==0
replace lb_local2=3 if lb_local2>3 & tempo_local~=. & post==1 & treatment==0
replace lb_local2=tempo_local*factor_local1_min if attrition==1 & post==1 & treatment==1
replace ub_local2=tempo_local*factor_local0_min if attrition==1 & post==1 & treatment==0
replace ub_local2=tempo_local*factor_local1 if attrition==1 & post==1 & treatment==1
replace ub_local2=4 if ub_local2>4 & tempo_local~=. & post==1 & treatment==1

* Dichotomic variables: ruc rfixed rec_sales record_pay2 

foreach var of varlist ruc rfixed rec_sales {
gen lb_`var'2=`var'
gen ub_`var'2=`var'
sort idclient post, stable
by idclient (post): gen tempo_`var'=`var'[_n-1] 

replace lb_`var'2=1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'2=tempo_`var' if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace lb_`var'2=0 if lb_`var'2==. & post==1 & treatment==1

replace ub_`var'2=tempo_`var' if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'2=0 if ub_`var'2==. & post==1 & treatment==0
replace ub_`var'2=1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
}

* Dichotomic variables: rrec_take

foreach var of varlist rrec_take {
gen lb_`var'2=`var'
gen ub_`var'2=`var'
sort idclient post, stable
by idclient (post): gen tempo_`var'=`var'[_n-1] 

replace lb_`var'2=1 if (attrition==1 | attrition==2) & post==1 & treatment==0 & cod_sucurs==1 & `var'==.
replace lb_`var'2=tempo_`var' if (attrition==1 | attrition==2) & post==1 & treatment==1 & cod_sucurs==1 & `var'==.
replace lb_`var'2=0 if lb_`var'2==. & post==1 & treatment==1 & cod_sucurs==1 & `var'==.

replace ub_`var'2=tempo_`var' if (attrition==1 | attrition==2) & post==1 & treatment==0 & cod_sucurs==1 & `var'==.
replace ub_`var'2=0 if ub_`var'2==. & post==1 & treatment==0 & cod_sucurs==1 & `var'==.
replace ub_`var'2=1 if (attrition==1 | attrition==2) & post==1 & treatment==1 & cod_sucurs==1 & `var'==.
}

gen record_pay2_nr=record_pay2 if cod_sucurs==5
gen lb_record_pay2_nr=record_pay2_nr
gen ub_record_pay2_nr=record_pay2_nr
sort idclient post, stable
by idclient (post): gen tempo_record_pay2_nr=record_pay2_nr[_n-1] if cod_sucurs==5
replace lb_record_pay2_nr=1 if (attrition==1 | (attrition==2 & record_pay2_nr==.)) & post==1 & treatment==0 & cod_sucurs==5
replace lb_record_pay2_nr=tempo_record_pay2_nr if (attrition==1 | (attrition==2 & record_pay2_nr==.)) & post==1 & treatment==1 & cod_sucurs==5
replace lb_record_pay2_nr=0 if lb_record_pay2_nr==. & post==1 & treatment==1 & cod_sucurs==5

replace ub_record_pay2_nr=tempo_record_pay2_nr if (attrition==1 | (attrition==2 & record_pay2_nr==.)) & post==1 & treatment==0 & cod_sucurs==5
replace ub_record_pay2_nr=0 if ub_record_pay2_nr==. & post==1 & treatment==0 & cod_sucurs==5
replace ub_record_pay2_nr=1 if (attrition==1 | (attrition==2 & record_pay2_nr==.)) & post==1 & treatment==1 & cod_sucurs==5

replace lb_record_pay2_nr=lb_record_pay21 if cod_sucurs==1
replace ub_record_pay2_nr=ub_record_pay21 if cod_sucurs==1


* Generating aggregate index with bounds *

* Lower Bound

for var lb_ruc2 lb_rfixed2 lb_rec_sales2 lb_local2 lb_record_pay2_nr lb_rrec_take2 lb_rsources2: gen p_X=X if treatment==0 & post==1 
foreach var of varlist p_lb_ruc2 p_lb_rfixed2 p_lb_rec_sales2 p_lb_local2 p_lb_record_pay2_nr p_lb_rrec_take2 p_lb_rsources2 {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_lb_ruc2 p_lb_rfixed2 p_lb_rec_sales2 p_lb_local2 p_lb_record_pay2_nr p_lb_rrec_take2 p_lb_rsources2  
for X in any lb_ruc2 lb_rfixed2 lb_rec_sales2 lb_local2 lb_record_pay2_nr lb_rrec_take2 lb_rsources2: gen kl_X=(X-p_X_mean)/p_X_sd

egen lbmiss_kling2=rownonmiss(kl_lb_ruc2 kl_lb_rfixed2 kl_lb_rec_sales2 kl_lb_rrec_take2 kl_lb_local2 kl_lb_rsources2 kl_lb_credit1 kl_lb_record_pay2_nr kl_lb_sum_know1 kl_lb_start_newb1 kl_lb_profit1 kl_lb_rprob1 kl_lb_think1 kl_lb_do1)
gen lbkling2=(kl_lb_ruc2+kl_lb_rfixed2+kl_lb_rec_sales2+kl_lb_rrec_take2+kl_lb_local2+kl_lb_rsources2+kl_lb_credit1+kl_lb_record_pay2_nr+kl_lb_sum_know1+kl_lb_start_newb1+kl_lb_profit1+kl_lb_rprob1+kl_lb_think1+kl_lb_do1)/14 if lbmiss_kling2==14

* Upper Bound

for var ub_ruc2 ub_rfixed2 ub_rec_sales2 ub_local2 ub_record_pay2_nr ub_rrec_take2 ub_rsources2: gen p_X=X if treatment==0 & post==1 
foreach var of varlist p_ub_ruc2 p_ub_rfixed2 p_ub_rec_sales2 p_ub_local2 p_ub_record_pay2_nr p_ub_rrec_take2 p_ub_rsources2 {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_ub_ruc2 p_ub_rfixed2 p_ub_rec_sales2 p_ub_local2 p_ub_record_pay2_nr p_ub_rrec_take2 p_ub_rsources2  
for X in any ub_ruc2 ub_rfixed2 ub_rec_sales2 ub_local2 ub_record_pay2_nr ub_rrec_take2 ub_rsources2: gen kl_X=(X-p_X_mean)/p_X_sd

egen ubmiss_kling2=rownonmiss(kl_ub_ruc2 kl_ub_rfixed2 kl_ub_rec_sales2 kl_ub_rrec_take2 kl_ub_local2 kl_ub_rsources2 kl_ub_credit1 kl_ub_record_pay2_nr kl_ub_sum_know1 kl_ub_start_newb1 kl_ub_profit1 kl_ub_rprob1 kl_ub_think1 kl_ub_do1)
gen ubkling2=(kl_ub_ruc2+kl_ub_rfixed2+kl_ub_rec_sales2+kl_ub_rrec_take2+kl_ub_local2+kl_ub_rsources2+kl_ub_credit1+kl_ub_record_pay2_nr+kl_ub_sum_know1+kl_ub_start_newb1+kl_ub_profit1+kl_ub_rprob1+kl_ub_think1+kl_ub_do1)/14 if ubmiss_kling2==14

* Impact Results with Attrition - Column (2)&(8)*

log using "$a\results\table7_busspractices.log", append
*Column (2)&(8)
areg lbkling2 treatment sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g lima1 lima2 aya1 if post==1, absorb(cofficer_lb) cl(idbank)
areg ubkling2 treatment sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g lima1 lima2 aya1 if post==1, absorb(cofficer_lb) cl(idbank)
log close

*II.3) BOUNDS WITH 0.25/0.10/0.05 SD - Column (3)(4)(6)(7)*
*--------------------------------------------------------*

* Generating variables with bounds *

* Discrete variable: rsources

sum rsources if attrition==2 & post==1 & treatment==0 & cod_sucurs==5
scalar rsources_mean0=r(mean) 
scalar rsources_sd0=r(sd) 
sum rsources if attrition==2 & post==1 & treatment==1 & cod_sucurs==5
scalar rsources_mean1=r(mean) 
scalar rsources_sd1=r(sd) 

for X in any a b c: gen lb_rsources3X=rsources
for X in any a b c: gen ub_rsources3X=rsources

replace lb_rsources3a=rsources_mean0+0.25*rsources_sd0 if attrition==1 & post==1 & treatment==0 & cod_sucurs==5
replace lb_rsources3a=rsources_mean1-0.25*rsources_sd1 if attrition==1 & post==1 & treatment==1 & cod_sucurs==5
replace ub_rsources3a=rsources_mean0-0.25*rsources_sd0 if attrition==1 & post==1 & treatment==0 & cod_sucurs==5
replace ub_rsources3a=rsources_mean1+0.25*rsources_sd1 if attrition==1 & post==1 & treatment==1 & cod_sucurs==5

replace lb_rsources3b=rsources_mean0+0.10*rsources_sd0 if attrition==1 & post==1 & treatment==0 & cod_sucurs==5
replace lb_rsources3b=rsources_mean1-0.10*rsources_sd1 if attrition==1 & post==1 & treatment==1 & cod_sucurs==5
replace ub_rsources3b=rsources_mean0-0.10*rsources_sd0 if attrition==1 & post==1 & treatment==0 & cod_sucurs==5
replace ub_rsources3b=rsources_mean1+0.10*rsources_sd1 if attrition==1 & post==1 & treatment==1 & cod_sucurs==5

replace lb_rsources3c=rsources_mean0+0.05*rsources_sd0 if attrition==1 & post==1 & treatment==0 & cod_sucurs==5
replace lb_rsources3c=rsources_mean1-0.05*rsources_sd1 if attrition==1 & post==1 & treatment==1 & cod_sucurs==5
replace ub_rsources3c=rsources_mean0-0.05*rsources_sd0 if attrition==1 & post==1 & treatment==0 & cod_sucurs==5
replace ub_rsources3c=rsources_mean1+0.05*rsources_sd1 if attrition==1 & post==1 & treatment==1 & cod_sucurs==5

* Discrete variable: local

sum local if attrition==2 & post==1 & treatment==0
scalar local_mean0=r(mean) 
scalar local_sd0=r(sd) 
sum local if attrition==2 & post==1 & treatment==1
scalar local_mean1=r(mean) 
scalar local_sd1=r(sd) 

for X in any a b c: gen lb_local3X=local
for X in any a b c: gen ub_local3X=local

replace lb_local3a=local_mean0+0.25*local_sd0 if attrition==1 & post==1 & treatment==0
replace lb_local3a=local_mean1-0.25*local_sd1 if attrition==1 & post==1 & treatment==1
replace ub_local3a=local_mean0-0.25*local_sd0 if attrition==1 & post==1 & treatment==0
replace ub_local3a=local_mean1+0.25*local_sd1 if attrition==1 & post==1 & treatment==1

replace lb_local3b=local_mean0+0.10*local_sd0 if attrition==1 & post==1 & treatment==0
replace lb_local3b=local_mean1-0.10*local_sd1 if attrition==1 & post==1 & treatment==1
replace ub_local3b=local_mean0-0.10*local_sd0 if attrition==1 & post==1 & treatment==0
replace ub_local3b=local_mean1+0.10*local_sd1 if attrition==1 & post==1 & treatment==1

replace lb_local3c=local_mean0+0.05*local_sd0 if attrition==1 & post==1 & treatment==0
replace lb_local3c=local_mean1-0.05*local_sd1 if attrition==1 & post==1 & treatment==1
replace ub_local3c=local_mean0-0.05*local_sd0 if attrition==1 & post==1 & treatment==0
replace ub_local3c=local_mean1+0.05*local_sd1 if attrition==1 & post==1 & treatment==1

* Discrete variable: sum_know 

sum sum_know if attrition==2 & post==1 & treatment==0
scalar sum_know_mean0=r(mean) 
scalar sum_know_sd0=r(sd) 
sum sum_know if attrition==2 & post==1 & treatment==1
scalar sum_know_mean1=r(mean) 
scalar sum_know_sd1=r(sd) 

for X in any a b c: gen lb_sum_know3X=sum_know
for X in any a b c: gen ub_sum_know3X=sum_know

replace lb_sum_know3a=sum_know_mean0+0.25*sum_know_sd0 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==0
replace lb_sum_know3a=sum_know_mean1-0.25*sum_know_sd1 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==1
replace ub_sum_know3a=sum_know_mean0-0.25*sum_know_sd0 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==0
replace ub_sum_know3a=sum_know_mean1+0.25*sum_know_sd1 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==1

replace lb_sum_know3b=sum_know_mean0+0.10*sum_know_sd0 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==0
replace lb_sum_know3b=sum_know_mean1-0.10*sum_know_sd1 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==1
replace ub_sum_know3b=sum_know_mean0-0.10*sum_know_sd0 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==0
replace ub_sum_know3b=sum_know_mean1+0.10*sum_know_sd1 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==1

replace lb_sum_know3c=sum_know_mean0+0.05*sum_know_sd0 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==0
replace lb_sum_know3c=sum_know_mean1-0.05*sum_know_sd1 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==1
replace ub_sum_know3c=sum_know_mean0-0.05*sum_know_sd0 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==0
replace ub_sum_know3c=sum_know_mean1+0.05*sum_know_sd1 if (attrition==1 | (attrition==2 & sum_know==.)) & post==1 & treatment==1

* Dichotomic variables: 

foreach var of varlist ruc rfixed rec_sales credit record_pay2 start_newb profit think do {
for X in any a b c: gen lb_`var'3X=`var'
for X in any a b c: gen ub_`var'3X=`var'

sum `var' if attrition==2 & post==1 & treatment==0
scalar `var'_mean0=r(mean) 
scalar `var'_sd0=r(sd) 
sum `var' if attrition==2 & post==1 & treatment==1
scalar `var'_mean1=r(mean) 
scalar `var'_sd1=r(sd) 

replace lb_`var'3a=`var'_mean0+0.25*`var'_sd0 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'3a=`var'_mean1-0.25*`var'_sd1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'3a=`var'_mean0-0.25*`var'_sd0 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'3a=`var'_mean1+0.25*`var'_sd1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1

replace lb_`var'3b=`var'_mean0+0.10*`var'_sd0 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'3b=`var'_mean1-0.10*`var'_sd1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'3b=`var'_mean0-0.10*`var'_sd0 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'3b=`var'_mean1+0.10*`var'_sd1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1

replace lb_`var'3c=`var'_mean0+0.05*`var'_sd0 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'3c=`var'_mean1-0.05*`var'_sd1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'3c=`var'_mean0-0.05*`var'_sd0 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'3c=`var'_mean1+0.05*`var'_sd1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
}

foreach var of varlist rrec_take rprob {
for X in any a b c: gen lb_`var'3X=`var'
for X in any a b c: gen ub_`var'3X=`var'

sum `var' if attrition==2 & post==1 & treatment==0 & cod_sucurs==1
scalar `var'_mean0=r(mean) 
scalar `var'_sd0=r(sd) 
sum `var' if attrition==2 & post==1 & treatment==1 & cod_sucurs==1
scalar `var'_mean1=r(mean) 
scalar `var'_sd1=r(sd) 

replace lb_`var'3a=`var'_mean0+0.25*`var'_sd0 if (attrition==1 | attrition==2) & post==1 & treatment==0 & cod_sucurs==1 & `var'==.
replace lb_`var'3a=`var'_mean1-0.25*`var'_sd1 if (attrition==1 | attrition==2) & post==1 & treatment==1 & cod_sucurs==1 & `var'==.
replace ub_`var'3a=`var'_mean0-0.25*`var'_sd0 if (attrition==1 | attrition==2) & post==1 & treatment==0 & cod_sucurs==1 & `var'==.
replace ub_`var'3a=`var'_mean1+0.25*`var'_sd1 if (attrition==1 | attrition==2) & post==1 & treatment==1 & cod_sucurs==1 & `var'==.

replace lb_`var'3b=`var'_mean0+0.10*`var'_sd0 if (attrition==1 | attrition==2) & post==1 & treatment==0 & cod_sucurs==1 & `var'==.
replace lb_`var'3b=`var'_mean1-0.10*`var'_sd1 if (attrition==1 | attrition==2) & post==1 & treatment==1 & cod_sucurs==1 & `var'==.
replace ub_`var'3b=`var'_mean0-0.10*`var'_sd0 if (attrition==1 | attrition==2) & post==1 & treatment==0 & cod_sucurs==1 & `var'==.
replace ub_`var'3b=`var'_mean1+0.10*`var'_sd1 if (attrition==1 | attrition==2) & post==1 & treatment==1 & cod_sucurs==1 & `var'==.

replace lb_`var'3c=`var'_mean0+0.05*`var'_sd0 if (attrition==1 | attrition==2) & post==1 & treatment==0 & cod_sucurs==1 & `var'==.
replace lb_`var'3c=`var'_mean1-0.05*`var'_sd1 if (attrition==1 | attrition==2) & post==1 & treatment==1 & cod_sucurs==1 & `var'==.
replace ub_`var'3c=`var'_mean0-0.05*`var'_sd0 if (attrition==1 | attrition==2) & post==1 & treatment==0 & cod_sucurs==1 & `var'==.
replace ub_`var'3c=`var'_mean1+0.05*`var'_sd1 if (attrition==1 | attrition==2) & post==1 & treatment==1 & cod_sucurs==1 & `var'==.
}

* Generating aggregate index with bounds *

foreach x of any a b c {
       
* Lower Bound
for var lb_ruc3`x' lb_rfixed3`x' lb_rec_sales3`x' lb_local3`x' lb_credit3`x' lb_record_pay23`x' lb_sum_know3`x' lb_start_newb3`x' lb_profit3`x' lb_think3`x' lb_do3`x' lb_rrec_take3`x' lb_rprob3`x' lb_rsources3`x': gen p_X=X if treatment==0 & post==1 
foreach Z in p_lb_ruc p_lb_rfixed p_lb_rec_sales p_lb_local p_lb_credit p_lb_record_pay2 p_lb_sum_know p_lb_start_newb p_lb_profit p_lb_think p_lb_do p_lb_rrec_take p_lb_rprob p_lb_rsources {
sum `Z'3`x'
scalar `Z'3`x'_mean=r(mean) 
scalar `Z'3`x'_sd=r(sd) 
}
drop p_lb_ruc3`x' p_lb_rfixed3`x' p_lb_rec_sales3`x' p_lb_local3`x' p_lb_credit3`x' p_lb_record_pay23`x' p_lb_sum_know3`x' p_lb_start_newb3`x' p_lb_profit3`x' p_lb_think3`x' p_lb_do3`x' p_lb_rrec_take3`x' p_lb_rprob3`x' p_lb_rsources3`x'
for X in any lb_ruc lb_rfixed lb_rec_sales lb_local lb_credit lb_record_pay2 lb_sum_know lb_start_newb lb_profit lb_think lb_do lb_rrec_take lb_rprob lb_rsources: gen kl_X3`x'=(X3`x'-p_X3`x'_mean)/p_X3`x'_sd
egen lbmiss_kling3`x'=rownonmiss(kl_lb_ruc3`x' kl_lb_rfixed3`x' kl_lb_rec_sales3`x' kl_lb_local3`x' kl_lb_credit3`x' kl_lb_record_pay23`x' kl_lb_sum_know3`x' kl_lb_start_newb3`x' kl_lb_profit3`x' kl_lb_think3`x' kl_lb_do3`x' kl_lb_rrec_take3`x' kl_lb_rprob3`x' kl_lb_rsources3`x')
gen lbkling3`x'=(kl_lb_ruc3`x'+kl_lb_rfixed3`x'+kl_lb_rec_sales3`x'+kl_lb_local3`x'+kl_lb_credit3`x'+kl_lb_record_pay23`x'+kl_lb_sum_know3`x'+kl_lb_start_newb3`x'+kl_lb_profit3`x'+kl_lb_think3`x'+kl_lb_do3`x'+kl_lb_rrec_take3`x'+kl_lb_rprob3`x'+kl_lb_rsources3`x')/14 if lbmiss_kling3`x'==14

* Upper Bound
for var ub_ruc3`x' ub_rfixed3`x' ub_rec_sales3`x' ub_local3`x' ub_credit3`x' ub_record_pay23`x' ub_sum_know3`x' ub_start_newb3`x' ub_profit3`x' ub_think3`x' ub_do3`x' ub_rrec_take3`x' ub_rprob3`x' ub_rsources3`x': gen p_X=X if treatment==0 & post==1 
foreach Z in p_ub_ruc p_ub_rfixed p_ub_rec_sales p_ub_local p_ub_credit p_ub_record_pay2 p_ub_sum_know p_ub_start_newb p_ub_profit p_ub_think p_ub_do p_ub_rrec_take p_ub_rprob p_ub_rsources {
sum `Z'3`x'
scalar `Z'3`x'_mean=r(mean) 
scalar `Z'3`x'_sd=r(sd) 
}
drop p_ub_ruc3`x' p_ub_rfixed3`x' p_ub_rec_sales3`x' p_ub_local3`x' p_ub_credit3`x' p_ub_record_pay23`x' p_ub_sum_know3`x' p_ub_start_newb3`x' p_ub_profit3`x' p_ub_think3`x' p_ub_do3`x' p_ub_rrec_take3`x' p_ub_rprob3`x' p_ub_rsources3`x'
for X in any ub_ruc ub_rfixed ub_rec_sales ub_local ub_credit ub_record_pay2 ub_sum_know ub_start_newb ub_profit ub_think ub_do ub_rrec_take ub_rprob ub_rsources : gen kl_X3`x'=(X3`x'-p_X3`x'_mean)/p_X3`x'_sd
egen ubmiss_kling3`x'=rownonmiss(kl_ub_ruc3`x' kl_ub_rfixed3`x' kl_ub_rec_sales3`x' kl_ub_local3`x' kl_ub_credit3`x' kl_ub_record_pay23`x' kl_ub_sum_know3`x' kl_ub_start_newb3`x' kl_ub_profit3`x' kl_ub_think3`x' kl_ub_do3`x' kl_ub_rrec_take3`x' kl_ub_rprob3`x' kl_ub_rsources3`x')
gen ubkling3`x'=(kl_ub_ruc3`x'+kl_ub_rfixed3`x'+kl_ub_rec_sales3`x'+kl_ub_local3`x'+kl_ub_credit3`x'+kl_ub_record_pay23`x'+kl_ub_sum_know3`x'+kl_ub_start_newb3`x'+kl_ub_profit3`x'+kl_ub_think3`x'+kl_ub_do3`x'+kl_ub_rrec_take3`x'+kl_ub_rprob3`x'+kl_ub_rsources3`x')/14 if ubmiss_kling3`x'==14

}

* Impact Results with Attrition - Columns (3)(4)(6)(7)*

log using "$a\results\table7_busspractices.log", append
*Column (3)&(7): 0.25 SD
areg lbkling3a treatment sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g lima1 lima2 aya1 if post==1, absorb(cofficer_lb) cl(idbank)
areg ubkling3a treatment sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g lima1 lima2 aya1 if post==1, absorb(cofficer_lb) cl(idbank)
*Column (4)&(6): 0.10 SD
areg lbkling3b treatment sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g lima1 lima2 aya1 if post==1, absorb(cofficer_lb) cl(idbank)
areg ubkling3b treatment sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g lima1 lima2 aya1 if post==1, absorb(cofficer_lb) cl(idbank)
*Column (4)&(6): 0.05 SD
areg lbkling3c treatment sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g lima1 lima2 aya1 if post==1, absorb(cofficer_lb) cl(idbank)
areg ubkling3c treatment sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g lima1 lima2 aya1 if post==1, absorb(cofficer_lb) cl(idbank)
log close

drop lbkling* ubkling* lbmiss_kling* ubmiss_kling*

*III) BOUNDS FOR EMPOWERMENT (THIRD TO FIFTH ROW)*
*------------------------------------------------*

*III.1) MIN-MAX BOUNDS - Column (1)&(9)*
*------------------------------------*

* Generating variables with bounds *

foreach var of varlist hh_save_share hh_loan_share bb_save_share bb_loan_share take_product_share hh_bills_share children_share {
gen lb_`var'1=`var'
gen ub_`var'1=`var'

replace lb_`var'1=1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'1=0 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'1=0 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'1=1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1

replace lb_`var'1=0 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'1=1 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'1=1 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'1=0 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
}

* Generating aggregate index with bounds *

*All Decisions - (THIRD ROW)*
*---------------------------*

* Lower Bound 
for var lb_hh_save_share lb_hh_loan_share lb_bb_save_share lb_bb_loan_share lb_take_product_share lb_hh_bills_share lb_children_share: gen p_X=X if treatment==0 & post==0 
foreach var of varlist p_lb_hh_save_share p_lb_hh_loan_share p_lb_bb_save_share p_lb_bb_loan_share p_lb_take_product_share p_lb_hh_bills_share p_lb_children_share {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_lb_hh_save_share1 p_lb_hh_loan_share1 p_lb_bb_save_share1 p_lb_bb_loan_share1 p_lb_take_product_share1 p_lb_hh_bills_share1 p_lb_children_share1
for X in any lb_hh_save_share lb_hh_loan_share lb_bb_save_share lb_bb_loan_share lb_take_product_share lb_hh_bills_share lb_children_share: gen kl_X1=(X1-p_X1_mean)/p_X1_sd
egen lbmiss_kling1=rownonmiss(kl_lb_hh_save_share1 kl_lb_hh_loan_share1 kl_lb_bb_save_share1 kl_lb_bb_loan_share1 kl_lb_take_product_share1 kl_lb_hh_bills_share1 kl_lb_children_share1)
gen lbkling1=(kl_lb_hh_save_share1+kl_lb_hh_loan_share1+kl_lb_bb_save_share1+kl_lb_bb_loan_share1+kl_lb_take_product_share1+kl_lb_hh_bills_share1+kl_lb_children_share1)/7 if lbmiss_kling1==7

* Upper Bound 
for var ub_hh_save_share ub_hh_loan_share ub_bb_save_share ub_bb_loan_share ub_take_product_share ub_hh_bills_share ub_children_share: gen p_X=X if treatment==0 & post==0 
foreach var of varlist p_ub_hh_save_share p_ub_hh_loan_share p_ub_bb_save_share p_ub_bb_loan_share p_ub_take_product_share p_ub_hh_bills_share p_ub_children_share {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_ub_hh_save_share1 p_ub_hh_loan_share1 p_ub_bb_save_share1 p_ub_bb_loan_share1 p_ub_take_product_share1 p_ub_hh_bills_share1 p_ub_children_share1
for X in any ub_hh_save_share ub_hh_loan_share ub_bb_save_share ub_bb_loan_share ub_take_product_share ub_hh_bills_share ub_children_share: gen kl_X1=(X1-p_X1_mean)/p_X1_sd
egen ubmiss_kling1=rownonmiss(kl_ub_hh_save_share1 kl_ub_hh_loan_share1 kl_ub_bb_save_share1 kl_ub_bb_loan_share1 kl_ub_take_product_share1 kl_ub_hh_bills_share1 kl_ub_children_share1)
gen ubkling1=(kl_ub_hh_save_share1+kl_ub_hh_loan_share1+kl_ub_bb_save_share1+kl_ub_bb_loan_share1+kl_ub_take_product_share1+kl_ub_hh_bills_share1+kl_ub_children_share1)/7 if ubmiss_kling1==7

*Household Decisions - (FOURTH ROW)*
*----------------------------------*

* Lower Bound 
egen lbmiss_klingh1=rownonmiss(kl_lb_hh_save_share1 kl_lb_hh_loan_share1 kl_lb_hh_bills_share1 kl_lb_children_share1)
gen lbklingh1=(kl_lb_hh_save_share1+kl_lb_hh_loan_share1+kl_lb_hh_bills_share1+kl_lb_children_share1)/4 if lbmiss_klingh1==4

* Upper Bound 
egen ubmiss_klingh1=rownonmiss(kl_ub_hh_save_share1 kl_ub_hh_loan_share1 kl_ub_hh_bills_share1 kl_ub_children_share1)
gen ubklingh1=(kl_ub_hh_save_share1+kl_ub_hh_loan_share1+kl_ub_hh_bills_share1+kl_ub_children_share1)/4 if ubmiss_klingh1==4

*Business Decisions - (FIFTH ROW)*
*--------------------------------*

* Lower Bound 
egen lbmiss_klingb1=rownonmiss(kl_lb_bb_save_share1 kl_lb_bb_loan_share1 kl_lb_take_product_share1)
gen lbklingb1=(kl_lb_bb_save_share1+kl_lb_bb_loan_share1+kl_lb_take_product_share1)/3 if lbmiss_klingb1==3

* Upper Bound 
egen ubmiss_klingb1=rownonmiss(kl_ub_bb_save_share1 kl_ub_bb_loan_share1 kl_ub_take_product_share1)
gen ubklingb1=(kl_ub_bb_save_share1+kl_ub_bb_loan_share1+kl_ub_take_product_share1)/3 if ubmiss_klingb1==3

* Creating missing constraints *

foreach X of varlist lbkling1 ubkling1 lbklingh1 ubklingh1 lbklingb1 ubklingb1 {
gen uno = (n2==1 | n2==2) & `X'~=. & idclient~=.
bys idclient: egen miss_`X'=min(uno)
drop uno
}

* Impact Results with Attrition - Column (1)&(9) *

log using "$a\results\table7_empowerment.log", replace
*All Decisions - Column (1)&(9)
areg lbkling1 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbkling1==1, absorb(cofficer_lb) cl(idbank)
areg ubkling1 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubkling1==1, absorb(cofficer_lb) cl(idbank)
*Household Decisions - Column (1)&(9)
areg lbklingh1 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbklingh1==1, absorb(cofficer_lb) cl(idbank)
areg ubklingh1 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubklingh1==1, absorb(cofficer_lb) cl(idbank)
*Business Decisions - Column (1)&(9)
areg lbklingb1 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbklingb1==1, absorb(cofficer_lb) cl(idbank)
areg ubklingb1 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubklingb1==1, absorb(cofficer_lb) cl(idbank)
log close


*III.2) NON REVERSAL BOUNDS - Column (2)&(8)*
*-----------------------------------------*

* Generating variables with bounds *

foreach var of varlist hh_save_share hh_loan_share bb_save_share bb_loan_share hh_bills_share take_product_share children_share {
gen lb_`var'2=`var'
gen ub_`var'2=`var'

sort idclient post, stable
by idclient (post): gen tempo_`var'=`var'[_n-1] 
sort idclient post, stable
by idclient (post): gen bstempo_`var'=`var'[_n+1] 

replace lb_`var'2=1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'2=tempo_`var' if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace lb_`var'2=0 if lb_`var'2==. & post==1 & treatment==1

replace ub_`var'2=tempo_`var' if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'2=0 if ub_`var'2==. & post==1 & treatment==0
replace ub_`var'2=1 if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1

replace lb_`var'2=0 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'2=1 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'2=1 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'2=0 if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
}

* Generating aggregate index with bounds *

*All Decisions - (THIRD ROW)*
*---------------------------*

* Lower Bound 

for X in any lb_hh_save_share lb_hh_loan_share lb_bb_save_share lb_bb_loan_share lb_take_product_share lb_hh_bills_share lb_children_share: gen p_X2=X2 if treatment==0 & post==0 
foreach var of varlist p_lb_hh_save_share p_lb_hh_loan_share p_lb_bb_save_share p_lb_bb_loan_share p_lb_take_product_share p_lb_hh_bills_share p_lb_children_share {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_lb_hh_save_share2 p_lb_hh_loan_share2 p_lb_bb_save_share2 p_lb_bb_loan_share2 p_lb_take_product_share2 p_lb_hh_bills_share2 p_lb_children_share2
for X in any lb_hh_save_share lb_hh_loan_share lb_bb_save_share lb_bb_loan_share lb_take_product_share lb_hh_bills_share lb_children_share: gen kl_X2=(X2-p_X2_mean)/p_X2_sd
egen lbmiss_kling2=rownonmiss(kl_lb_hh_save_share2 kl_lb_hh_loan_share2 kl_lb_bb_save_share2 kl_lb_bb_loan_share2 kl_lb_take_product_share2 kl_lb_hh_bills_share2 kl_lb_children_share2)
gen lbkling2=(kl_lb_hh_save_share2+kl_lb_hh_loan_share2+kl_lb_bb_save_share2+kl_lb_bb_loan_share2+kl_lb_take_product_share2+kl_lb_hh_bills_share2+kl_lb_children_share2)/7 if lbmiss_kling2==7

* Upper Bound 

for X in any ub_hh_save_share ub_hh_loan_share ub_bb_save_share ub_bb_loan_share ub_take_product_share ub_hh_bills_share ub_children_share: gen p_X2=X2 if treatment==0 & post==0 
foreach var of varlist p_ub_hh_save_share p_ub_hh_loan_share p_ub_bb_save_share p_ub_bb_loan_share p_ub_take_product_share p_ub_hh_bills_share p_ub_children_share {
sum `var'
scalar `var'_mean=r(mean) 
scalar `var'_sd=r(sd) 
}
drop p_ub_hh_save_share2 p_ub_hh_loan_share2 p_ub_bb_save_share2 p_ub_bb_loan_share2 p_ub_take_product_share2 p_ub_hh_bills_share2 p_ub_children_share2
for X in any ub_hh_save_share ub_hh_loan_share ub_bb_save_share ub_bb_loan_share ub_take_product_share ub_hh_bills_share ub_children_share: gen kl_X2=(X2-p_X2_mean)/p_X2_sd
egen ubmiss_kling2=rownonmiss(kl_ub_hh_save_share2 kl_ub_hh_loan_share2 kl_ub_bb_save_share2 kl_ub_bb_loan_share2 kl_ub_take_product_share2 kl_ub_hh_bills_share2 kl_ub_children_share2)
gen ubkling2=(kl_ub_hh_save_share2+kl_ub_hh_loan_share2+kl_ub_bb_save_share2+kl_ub_bb_loan_share2+kl_ub_take_product_share2+kl_ub_hh_bills_share2+kl_ub_children_share2)/7 if ubmiss_kling2==7

*Household Decisions - (FOURTH ROW)*
*----------------------------------*

* Lower Bound 
egen lbmiss_klingh2=rownonmiss(kl_lb_hh_save_share2 kl_lb_hh_loan_share2 kl_lb_hh_bills_share2 kl_lb_children_share2)
gen lbklingh2=(kl_lb_hh_save_share2+kl_lb_hh_loan_share2+kl_lb_hh_bills_share2+kl_lb_children_share2)/4 if lbmiss_klingh2==4

* Upper Bound  
egen ubmiss_klingh2=rownonmiss(kl_ub_hh_save_share2 kl_ub_hh_loan_share2 kl_ub_hh_bills_share2 kl_ub_children_share2)
gen ubklingh2=(kl_ub_hh_save_share2+kl_ub_hh_loan_share2+kl_ub_hh_bills_share2+kl_ub_children_share2)/4 if ubmiss_klingh2==4

*Business Decisions - (FIFTH ROW)*
*--------------------------------*

* Lower Bound 
egen lbmiss_klingb2=rownonmiss(kl_lb_bb_save_share2 kl_lb_bb_loan_share2 kl_lb_take_product_share2)
gen lbklingb2=(kl_lb_bb_save_share2+kl_lb_bb_loan_share2+kl_lb_take_product_share2)/3 if lbmiss_klingb2==3

* Upper Bound 
egen ubmiss_klingb2=rownonmiss(kl_ub_bb_save_share2 kl_ub_bb_loan_share2 kl_ub_take_product_share2)
gen ubklingb2=(kl_ub_bb_save_share2+kl_ub_bb_loan_share2+kl_ub_take_product_share2)/3 if ubmiss_klingb2==3

* Creating missing constraints *

foreach X of varlist lbkling2 ubkling2 lbklingh2 ubklingh2 lbklingb2 ubklingb2 {
gen uno = (n2==1 | n2==2) & `X'~=. & idclient~=.
bys idclient: egen miss_`X'=min(uno)
drop uno
}

* Impact Results with Attrition - Column (2)&(8) *

log using "$a\results\table7_empowerment.log", append
*All Decisions - Column (2)&(8)
areg lbkling2 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbkling2==1, absorb(cofficer_lb) cl(idbank)
areg ubkling2 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubkling2==1, absorb(cofficer_lb) cl(idbank)
*Household Decisions - Column (2)&(8)
areg lbklingh2 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbklingh2==1, absorb(cofficer_lb) cl(idbank)
areg ubklingh2 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubklingh2==1, absorb(cofficer_lb) cl(idbank)
*Business Decisions - Column (2)&(8)
areg lbklingb2 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbklingb2==1, absorb(cofficer_lb) cl(idbank)
areg ubklingb2 post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubklingb2==1, absorb(cofficer_lb) cl(idbank)
log close

*III.3) BOUNDS WITH 0.25/0.10/0.05 SD - Column (3)(4)(6)(7)*
*--------------------------------------------------------*

* Generating variables with bounds *

foreach var of varlist hh_save_share hh_loan_share bb_save_share bb_loan_share take_product_share hh_bills_share children_share {
sum `var' if post==1 & treatment==0
scalar `var'_10_mean = r(mean)
scalar `var'_10_sd = r(sd)

sum `var' if post==1 & treatment==1
scalar `var'_11_mean = r(mean)
scalar `var'_11_sd = r(sd)

sum `var' if post==0 & treatment==0
scalar `var'_00_mean = r(mean)
scalar `var'_00_sd = r(sd)

sum `var' if post==0 & treatment==1
scalar `var'_01_mean = r(mean)
scalar `var'_01_sd = r(sd)

gen lb_`var'3a=`var'
gen ub_`var'3a=`var'
gen lb_`var'3b=`var'
gen ub_`var'3b=`var'
gen lb_`var'3c=`var'
gen ub_`var'3c=`var'

replace lb_`var'3a=`var'_10_mean+0.25*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'3a=`var'_11_mean-0.25*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'3a=`var'_10_mean-0.25*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'3a=`var'_11_mean+0.25*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace lb_`var'3a=`var'_00_mean-0.25*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'3a=`var'_01_mean+0.25*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'3a=`var'_00_mean+0.25*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'3a=`var'_01_mean-0.25*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1

replace lb_`var'3b=`var'_10_mean+0.10*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'3b=`var'_11_mean-0.10*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'3b=`var'_10_mean-0.10*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'3b=`var'_11_mean+0.10*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace lb_`var'3b=`var'_00_mean-0.10*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'3b=`var'_01_mean+0.10*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'3b=`var'_00_mean+0.10*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'3b=`var'_01_mean-0.10*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1

replace lb_`var'3c=`var'_10_mean+0.05*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace lb_`var'3c=`var'_11_mean-0.05*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace ub_`var'3c=`var'_10_mean-0.05*`var'_10_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==0
replace ub_`var'3c=`var'_11_mean+0.05*`var'_11_sd if (attrition==1 | (attrition==2 & `var'==.)) & post==1 & treatment==1
replace lb_`var'3c=`var'_00_mean-0.05*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace lb_`var'3c=`var'_01_mean+0.05*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
replace ub_`var'3c=`var'_00_mean+0.05*`var'_00_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==0
replace ub_`var'3c=`var'_01_mean-0.05*`var'_01_sd if ((attrition==1 & `var'==.) | (attrition==2 & `var'==.)) & post==0 & treatment==1
}

* Generating aggregate index with bounds *

foreach x of any a b c {

*All Decisions - (THIRD ROW)*
*---------------------------*
   
* Lower Bound 

for X in any lb_hh_save_share lb_hh_loan_share lb_bb_save_share lb_bb_loan_share lb_take_product_share lb_hh_bills_share lb_children_share: gen p_X3`x'=X3`x' if treatment==0 & post==0 
foreach v of any p_lb_hh_save_share p_lb_hh_loan_share p_lb_bb_save_share p_lb_bb_loan_share p_lb_take_product_share p_lb_hh_bills_share p_lb_children_share {
sum `v'3`x'
scalar `v'3`x'_mean=r(mean) 
scalar `v'3`x'_sd=r(sd) 
}
drop p_lb_hh_save_share3`x' p_lb_hh_loan_share3`x' p_lb_bb_save_share3`x' p_lb_bb_loan_share3`x' p_lb_take_product_share3`x' p_lb_hh_bills_share3`x' p_lb_children_share3`x'
for X in any lb_hh_save_share lb_hh_loan_share lb_bb_save_share lb_bb_loan_share lb_take_product_share lb_hh_bills_share lb_children_share: gen kl_X3`x'=(X3`x'-p_X3`x'_mean)/p_X3`x'_sd
egen lbmiss_kling3`x'=rownonmiss(kl_lb_hh_save_share3`x' kl_lb_hh_loan_share3`x' kl_lb_bb_save_share3`x' kl_lb_bb_loan_share3`x' kl_lb_take_product_share3`x' kl_lb_hh_bills_share3`x' kl_lb_children_share3`x')
gen lbkling3`x'=(kl_lb_hh_save_share3`x'+kl_lb_hh_loan_share3`x'+kl_lb_bb_save_share3`x'+kl_lb_bb_loan_share3`x'+kl_lb_take_product_share3`x'+kl_lb_hh_bills_share3`x'+kl_lb_children_share3`x')/7 if lbmiss_kling3`x'==7

* Upper Bound 

for X in any ub_hh_save_share ub_hh_loan_share ub_bb_save_share ub_bb_loan_share ub_take_product_share ub_hh_bills_share ub_children_share: gen p_X3`x'=X3`x' if treatment==0 & post==0 
foreach v of any p_ub_hh_save_share p_ub_hh_loan_share p_ub_bb_save_share p_ub_bb_loan_share p_ub_take_product_share p_ub_hh_bills_share p_ub_children_share {
sum `v'3`x'
scalar `v'3`x'_mean=r(mean) 
scalar `v'3`x'_sd=r(sd) 
}
drop p_ub_hh_save_share3`x' p_ub_hh_loan_share3`x' p_ub_bb_save_share3`x' p_ub_bb_loan_share3`x' p_ub_take_product_share3`x' p_ub_hh_bills_share3`x' p_ub_children_share3`x'
for X in any ub_hh_save_share ub_hh_loan_share ub_bb_save_share ub_bb_loan_share ub_take_product_share ub_hh_bills_share ub_children_share: gen kl_X3`x'=(X3`x'-p_X3`x'_mean)/p_X3`x'_sd
egen ubmiss_kling3`x'=rownonmiss(kl_ub_hh_save_share3`x' kl_ub_hh_loan_share3`x' kl_ub_bb_save_share3`x' kl_ub_bb_loan_share3`x' kl_ub_take_product_share3`x' kl_ub_hh_bills_share3`x' kl_ub_children_share3`x')
gen ubkling3`x'=(kl_ub_hh_save_share3`x'+kl_ub_hh_loan_share3`x'+kl_ub_bb_save_share3`x'+kl_ub_bb_loan_share3`x'+kl_ub_take_product_share3`x'+kl_ub_hh_bills_share3`x'+kl_ub_children_share3`x')/7 if ubmiss_kling3`x'==7


*Household Decisions - (FOURTH ROW)*
*----------------------------------*

* Lower Bound 
egen lbmiss_klingh3`x'=rownonmiss(kl_lb_hh_save_share3`x' kl_lb_hh_loan_share3`x' kl_lb_hh_bills_share3`x' kl_lb_children_share3`x')
gen lbklingh3`x'=(kl_lb_hh_save_share3`x'+kl_lb_hh_loan_share3`x'+kl_lb_hh_bills_share3`x'+kl_lb_children_share3`x')/4 if lbmiss_klingh3`x'==4

* Upper Bound  
egen ubmiss_klingh3`x'=rownonmiss(kl_ub_hh_save_share3`x' kl_ub_hh_loan_share3`x' kl_ub_hh_bills_share3`x' kl_ub_children_share3`x')
gen ubklingh3`x'=(kl_ub_hh_save_share3`x'+kl_ub_hh_loan_share3`x'+kl_ub_hh_bills_share3`x'+kl_ub_children_share3`x')/4 if ubmiss_klingh3`x'==4


*Business Decisions - (FIFTH ROW)*
*--------------------------------*

* Lower Bound 
egen lbmiss_klingb3`x'=rownonmiss(kl_lb_bb_save_share3`x' kl_lb_bb_loan_share3`x' kl_lb_take_product_share3`x')
gen lbklingb3`x'=(kl_lb_bb_save_share3`x'+kl_lb_bb_loan_share3`x'+kl_lb_take_product_share3`x')/3 if lbmiss_klingb3`x'==3

* Upper Bound 
egen ubmiss_klingb3`x'=rownonmiss(kl_ub_bb_save_share3`x' kl_ub_bb_loan_share3`x' kl_ub_take_product_share3`x')
gen ubklingb3`x'=(kl_ub_bb_save_share3`x'+kl_ub_bb_loan_share3`x'+kl_ub_take_product_share3`x')/3 if ubmiss_klingb3`x'==3

* Creating missing constraints *

foreach X of varlist lbkling3`x' ubkling3`x' lbklingh3`x' ubklingh3`x' lbklingb3`x' ubklingb3`x' {
gen uno = (n2==1 | n2==2) & `X'~=. & idclient~=.
bys idclient: egen miss_`X'=min(uno)
drop uno
}

}

* Log results - Column (3)(4)(6)(7)*

log using "$a\results\table7_empowerment.log", append

***All Decisions (3rd row)***

*Column (3)&(7): 0.25 SD
areg lbkling3a post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbkling3a==1, absorb(cofficer_lb) cl(idbank)
areg ubkling3a post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubkling3a==1, absorb(cofficer_lb) cl(idbank)
*Column (4)&(6): 0.10 SD
areg lbkling3b post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbkling3b==1, absorb(cofficer_lb) cl(idbank)
areg ubkling3b post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubkling3b==1, absorb(cofficer_lb) cl(idbank)
*Column (4)&(6): 0.05 SD
areg lbkling3c post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbkling3c==1, absorb(cofficer_lb) cl(idbank)
areg ubkling3c post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubkling3c==1, absorb(cofficer_lb) cl(idbank)

***Household Decisions (4th row)***

*Column (3)&(7): 0.25 SD
areg lbklingh3a post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbklingh3a==1, absorb(cofficer_lb) cl(idbank)
areg ubklingh3a post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubklingh3a==1, absorb(cofficer_lb) cl(idbank)
*Column (4)&(6): 0.10 SD
areg lbklingh3b post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbklingh3b==1, absorb(cofficer_lb) cl(idbank)
areg ubklingh3b post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubklingh3b==1, absorb(cofficer_lb) cl(idbank)
*Column (4)&(6): 0.05 SD
areg lbklingh3c post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbklingh3c==1, absorb(cofficer_lb) cl(idbank)
areg ubklingh3c post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubklingh3c==1, absorb(cofficer_lb) cl(idbank)

***Business Decisions (5th row)***

*Column (3)&(7): 0.25 SD
areg lbklingb3a post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbklingb3a==1, absorb(cofficer_lb) cl(idbank)
areg ubklingb3a post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubklingb3a==1, absorb(cofficer_lb) cl(idbank)
*Column (4)&(6): 0.10 SD
areg lbklingb3b post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbklingb3b==1, absorb(cofficer_lb) cl(idbank)
areg ubklingb3b post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubklingb3b==1, absorb(cofficer_lb) cl(idbank)
*Column (4)&(6): 0.05 SD
areg lbklingb3c post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_lbklingb3c==1, absorb(cofficer_lb) cl(idbank)
areg ubklingb3c post treatment dd sucurs ed_mas ed2 ed3 act2 act3 act4 act5 size2 missing_g if miss_ubklingb3c==1, absorb(cofficer_lb) cl(idbank)

log close






