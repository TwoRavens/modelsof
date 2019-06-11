

*Acquiring stratas & treatment measure
*file provided by Jessica Goldberg with stratification variables
use final_1may2013, clear
*Correcting data inconsistencies to place clubs in Strata following agreed recoding from correspondence with authors
gen OFFER_WEEK = offer_week
egen m = sd(OFFER_WEEK), by(bfirm_club_id)
tab bfirm_club_id OFFER_WEEK if m > 0
replace OFFER_WEEK = 38 if bfirm_club_id == 20
replace OFFER_WEEK = 34 if bfirm_club_id == 27
replace OFFER_WEEK = 35 if bfirm_club_id == 47
replace OFFER_WEEK = 35 if bfirm_club_id == 51
replace OFFER_WEEK = 35 if bfirm_club_id == 80
replace OFFER_WEEK = 36 if bfirm_club_id == 114
replace OFFER_WEEK = 39 if bfirm_club_id == 128
replace OFFER_WEEK = 39 if bfirm_club_id == 147
replace OFFER_WEEK = 39 if bfirm_club_id == 270
replace OFFER_WEEK = 35 if bfirm_club_id == 85
drop m
egen m = sd(OFFER_WEEK), by(bfirm_club_id)
tab bfirm_club_id OFFER_WEEK if m > 0
drop m 
egen zz2 = group(z2), label
egen m = sd(zz2), by(bfirm_club_id)
tab bfirm_club_id z2 if m > 0, nolabel
replace z2 = "mayani" if bfirm_club_id == 74
drop m
egen Strata = group(z2 OFFER_WEEK), label
egen m = sd(Strata), by(bfirm_club_id)
tab bfirm_club_id Strata if m > 0, nolabel
replace Strata = 1 if bfirm_club_id == 151
*Authors uncertain about this club (Strata 1 or 22).  If do not place in 1, all observations in 1 receive treatment, seems unlikely
egen mm = sd(Strata), by(bfirm_club_id)
sum mm
*Authors indicate that remainder aren't part of experiment (although have fingerprint, etc).
drop if Strata == .
collapse (mean) Strata fingerprint, by(bfirm_club_id) fast
tab Strata fingerprint
*Peculiar, but these are the strata provided by the authors
sort Strata bfirm_club_id 
mkmat Strata fingerprint bfirm_club_id, matrix(Y)
global N = 249



********************


use final.dta, clear

*Their prep code
global districts "Dowa Dedza Kasungu Lilongwe Mchinji"
global repayment "balance frac_paid fully_paid frac_paid_sept30 fully_paid_sept30 total_owed"
global covars "male agedum2 agedum3 agedum4 agedum5 agedum6 agedum7 agedum8 agedum9 agedum10 agedum11 agedum12 agedum13 agedum14 agedum15 agedum16 married educdum2 educdum3 educdum4 educdum5 educdum6 educdum7 educdum8 educdum9 educdum10"
global covars_balance "male married age educ_years"
global total_inputs "seeds_kg_total seeds_mk_total land_total_acre fert23_total fertcom_total ferture_total fertcan_total fert_kg_total fert_mk_total liqchem_ml_tot liqchem_mk_tot powchem_gr_tot powchem_mk_tot chem_mk_tot menxdays_tot menxdays_spend_tot"
global pap_inputs "seeds_kg_pap seeds_mk_pap fert23_pap fertcom_pap ferture_pap fertcan_pap fert_kg_pap fert_mk_pap liqchem_ml_pap powchem_gr_pap chem_mk_pap menxdays_pap menxdays_spend_pap"
global takeup "nodeposit screenedout otherfail"
global riskfactors "risky hungry late incomesd paprikaexp default nopreviousloan"
global samples "source_oct_baseline source_april source_oct_repay source_august2008_survey"
global inputs_april "seeds_kg_total seeds_mk_total fert_kg_total fert_mk_total menxdays_tot menxdays_spend_tot seeds_kg_pap seeds_mk_pap fert_kg_pap fert_mk_pap menxdays_pap menxdays_spend_pap"
global inputs_aug "seeds_kg_total_aug seeds_mk_total_aug fert_kg_total_aug fert_mk_total_aug menxdays_tot_aug menxdays_spend_tot_aug seeds_kg_pap_aug seeds_mk_pap_aug fert_kg_pap_aug fert_mk_pap_aug menxdays_pap_aug menxdays_spend_pap_aug"
global inputs_union "seeds_kg_total_union seeds_mk_total_union fert_kg_total_union fert_mk_total_union menxdays_tot_union menxdays_spend_tot_union seeds_kg_pap_union seeds_mk_pap_union fert_kg_pap_union fert_mk_pap_union menxdays_pap_union menxdays_spend_pap_union"
global outputs "harv_kg_total harv_kg_pap profit_total_aug profit_pap_aug"
global kidoutcomes "frac_inschool_15to17 frac_working_15to17 frac_inschool_18to20 frac_working_18to20"
global cropdums "grow_1 grow_2 grow_3 grow_4 grow_5 grow_6 grow_7 grow_8"
global altkidoutcomes "frac_inschool_15 frac_working_15 frac_inschool_16 frac_working_16 frac_inschool_17 frac_working_17 frac_inschool_18 frac_working_18 frac_inschool_19 frac_working_19 frac_inschool_20 frac_working_20"
global harvest "harv_kg_1 harv_kg_2 harv_kg_3 harv_kg_4 harv_kg_5"
global land "frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8"
global effort "manure_kg_total manure_kg_pap weed_total weed_pap"
	
gen source_oct_repay=source_oct_baseline*source_repayment
pca $riskfactors
predict riskindex
foreach var in $riskfactors riskindex $covars_balance {
	gen `var'_fp=`var'*fingerprint
	}
gen total_borrowed=total_owed
replace total_borrowed=0 if total_borrowed==.
gen frac_not_maize=frac_land_2+frac_land_3+frac_land_4+frac_land_5+frac_land_6+frac_land_7+frac_land_8
tab focode, gen(fodum)
ren menxdays_spend_tot_aug ganyu_tot
ren menxdays_spend_pap_aug ganyu_pap
ren sales_total_aug sales_self
ren sales_from_prices sales_imp
ren profits_from_prices profits_imp
ren profits_from_selfreport profits_self
ren rev_from_prices output_imp
ren chem_mk_total_aug chem_tot_mk
ren inputs_mk_total_aug inputs_tot_mk
ren chem_mk_pap_aug chem_pap_mk
ren inputs_mk_pap_aug inputs_pap_mk
ren home_prod_from_prices home_prod

global table_1 "approved any_loan total_owed"
global table_2 "frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize"
global table_3 "seeds_mk_total_aug fert_mk_total_aug chem_tot_mk ganyu_tot inputs_tot_mk manure_kg_total weed_total seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap"
global table_4 "harv_kg_1 harv_kg_2 harv_kg_3 harv_kg_4 harv_kg_5 harv_kg_6 harv_kg_7 harv_kg_8"
global table_5 "sales_self sales_imp profits_self profits_imp home_prod output_imp profit_total_aug "
global table_6 "default_no_new_loan mrfc_use_fp other_use_fp"
global table_7 "balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid"
global table_check "harv_kg sell_kg value_sales unsold_mk"

gen samp1=1
foreach var in approved any_loan $covars $riskfactors focode offer_week {
	replace samp1=0 if `var'==.
	}	
replace samp1=0 if source_oct_baseline!=1
gen samp2=1
foreach var in $table_2 {
	replace samp2=0 if `var'==.
	}
replace samp2=0 if samp1==0
replace samp2=0 if source_aug2008_survey!=1
gen samp3=1
foreach var in $table_3 {
	replace samp3=0 if `var'==.
	}
replace samp3=0 if samp1==0
replace samp3=0 if source_aug2008_survey!=1
gen samp4=1
foreach var in $table_4 {
	replace samp4=0 if `var'==.
	}
replace samp4=0 if samp1==0
replace samp4=0 if source_aug2008_survey!=1
gen samp5=1
foreach var in $table_5 {
	replace samp5=0 if `var'==.
	}
replace samp5=0 if samp1==0
replace samp5=0 if source_aug2008_survey!=1
gen samp6=1
foreach var in $table_6 {
	replace samp6=0 if `var'==.
	}
replace samp6=0 if samp1==0
replace samp6=0 if source_aug2008_survey!=1
gen samp7=1
foreach var in $table_7 {
	replace samp7=0 if `var'==.
	}
replace samp7=0 if samp1==0
replace samp7=0 if source_oct_repay!=1

**remove non-paprika inputs from variable list for table_3
global table_3	"seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap"

*****  Log profits;
gen ln_profits_self=ln(profits_self)
qui sum profits_self if samp5==1, d
replace ln_profits_self=ln(r(p1)) if profits_self<=0 & profits_self~=.
qui sum profits_self if samp5==1, d
replace ln_profits_self=ln(r(p5)) if profits_self<=0 & profits_self~=. & r(p1)<=0 

global table_2 "frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize"
global table_3 "seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap"
global table_5 "sales_self home_prod profits_self ln_profits_self "


*FIRST STAGE

reg frac_paid_sept30 $covars_balance $riskfactors if fingerprint==0 & source_oct_repay==1, cluster(bfirm_club_id)
xi: reg frac_paid_sept30 $covars_balance $riskfactors i.focode*i.offer_week if fingerprint==0 & source_oct_repay==1, cluster(bfirm_club_id)

*AY NOTE: THIS COMMAND AND SUBSEQUENT PREDICT IS ACTUALLY SENSITIVE TO ORDER OF BFIRMS IN THE DATA, big problem with original code
*MOST SUBSTANTIAL EFFECT IN PART III (to see: gen u = uniform(), sort u, then run this part of code again)
xi: reg frac_paid_sept30 $covars $riskfactors i.focode*i.offer_week if fingerprint==0 & source_oct_repay==1, cluster(bfirm_club_id)
predict pred_repayment if source_oct_baseline==1, xb
gen pred_treat=pred_repayment*fingerprint
tab fingerprint, sum(pred_repayment)
sum pred_repayment, d

egen catd=cut(pred_repayment) if any_loan==1, group(5)
****Slot non-recipients into these categories
forval n=0/4 {
	egen top`n'=max(pred_repayment) if catd==`n'
	egen bot`n'=min(pred_repayment) if catd==`n'
	}
egen top=max(top0)
egen bot=max(bot0)
replace catd=0 if pred_repayment<=top & pred_repayment>=bot & any_loan==0
forval n=1/4 {
	drop top bot
	egen bot=max(bot`n')
	egen top=max(top`n')
	replace catd=`n' if pred_repayment<=top & pred_repayment>=bot & any_loan==0
	}
tab catd, gen(pred_repay_ddum)

foreach num in 1 2 3 4 5 {
	gen fp_pred_repayd`num'=pred_repay_ddum`num'*fingerprint
	}
save DatGGY1, replace

*REGRESSIONS - Modified version of their code that makes it easier to see what is being run

*Table 3 - Obs reported is for bottom panel only - S.E. recording error for column 1, panel C
foreach outcome in approved any_loan {
		xi: reg `outcome' fingerprint i.focode*i.offer_week if samp1 == 1, cluster(bfirm_club_id)
		xi: reg `outcome' fingerprint pred_treat pred_repayment i.focode*i.offer_week if samp1 == 1, cluster(bfirm_club_id)
		xi: reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* i.focode*i.offer_week if samp1 == 1, cluster(bfirm_club_id)
		}
foreach outcome in total_owed {
		xi: reg `outcome' fingerprint i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
		xi: reg `outcome' fingerprint pred_treat pred_repayment i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
		xi: reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
		}

*Table 4 - All okay
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	xi: reg `outcome' fingerprint i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
	xi: reg `outcome' fingerprint pred_treat pred_repayment i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
	xi: reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
	}

*Table 5 - s.e. mistake top of column (4)
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize {
	xi: reg `outcome' fingerprint i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
	xi: reg `outcome' fingerprint pred_treat pred_repayment i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
	xi: reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
	}

*Table 6 - Rounding error in one s.e.
foreach outcome in seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap {
	xi: reg `outcome' fingerprint i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
	xi: reg `outcome' fingerprint pred_treat pred_repayment i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
	xi: reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
	}

*Table 7 - All okay
foreach outcome in sales_self home_prod profits_self ln_profits_self {
	xi: reg `outcome' fingerprint i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
	xi: reg `outcome' fingerprint pred_treat pred_repayment i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
	xi: reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* i.focode*i.offer_week if samp7 == 1, cluster(bfirm_club_id)
	}

*All standard error comparisons for panels B and C done on basis of do files for standard errors (simplified code in randomization below)
*Can't reproduce the p-values reported for joint test of significance in panels B at the bottom of the table - no code for this in do-file and reported results inconsistent with estimated covariance matrices

***********************************************

*Part I: Regressions in Panels A of all tables

use DatGGY1, clear
egen D = group(focode offer_week) if samp1 == 1
tab D if samp1 == 1, gen(D)
egen DD = group(focode offer_week) if samp7 == 1
tab DD if samp7 == 1, gen(DD)
egen DDD = group(focode offer_week) if samp7 == 1 & frac_land_1 ~= .
tab DDD if samp7 == 1 & frac_land_1 ~= ., gen(DDD)

*Table 3
reg approved fingerprint D2-D32 if samp1 == 1, cluster(bfirm_club_id)
reg any_loan fingerprint D2-D32 if samp1 == 1, cluster(bfirm_club_id)
reg total_owed fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
*Table 4 
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	reg `outcome' fingerprint DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

svmat Y
save DatGGY1, replace

****************************************
****************************************

*Part II:  Panels B of all tables

local table_1 = `"approved any_loan total_owed"'
local table_2 = `"frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize"'
local table_3 = `"seeds_mk_total_aug fert_mk_total_aug chem_tot_mk ganyu_tot inputs_tot_mk manure_kg_total weed_total seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap"'
local table_4 = `"harv_kg_1 harv_kg_2 harv_kg_3 harv_kg_4 harv_kg_5 harv_kg_6 harv_kg_7 harv_kg_8"'
local table_5 = `"sales_self home_prod profits_self ln_profits_self"'
local table_6 = `"default_no_new_loan mrfc_use_fp other_use_fp"'
local table_7 = `"balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid"'
local covars=`"male agedum2 agedum3 agedum4 agedum5 agedum6 agedum7 agedum8 agedum9 agedum10 agedum11 agedum12 agedum13 agedum14 agedum15 agedum16 married educdum2 educdum3 educdum4 educdum5 educdum6 educdum7 educdum8 educdum9 educdum10"'
local riskfactors=`"risky hungry late incomesd paprikaexp default nopreviousloan"'
global covars "male agedum2 agedum3 agedum4 agedum5 agedum6 agedum7 agedum8 agedum9 agedum10 agedum11 agedum12 agedum13 agedum14 agedum15 agedum16 married educdum2 educdum3 educdum4 educdum5 educdum6 educdum7 educdum8 educdum9 educdum10"
global riskfactors "risky hungry late incomesd paprikaexp default nopreviousloan"

use "final_after_tables_quints_of_borrowers.dta", clear 
keep `table_1' `table_2' `table_3' `table_4' `table_5' `table_6' `table_7' `covars' age educ_years `riskfactors' source* samp* fingerprint focode offer_week any_loan bfirm_club_id
egen D = group(focode offer_week) if samp1 == 1
tab D if samp1 == 1, gen(D)
egen DD = group(focode offer_week) if samp7 == 1
tab DD if samp7 == 1, gen(DD)
egen DDD = group(focode offer_week) if samp7 == 1 & frac_land_1 ~= .
tab DDD if samp7 == 1 & frac_land_1 ~= ., gen(DDD)
save temp2data, replace

*AY NOTE: AGAIN, I NOTE THAT THIS COMMAND AND SUBSEQUENT PREDICT IS SENSITIVE TO ORDER OF BFIRMS, error in original code
quietly xi: reg frac_paid_sept30 $covars $riskfactors i.focode*i.offer_week if fingerprint==0 & source_oct_repay==1, cluster(bfirm_club_id)
quietly predict pred_repayment if source_oct_baseline==1, xb
quietly gen pred_treat=pred_repayment*fingerprint
quietly tab fingerprint, sum(pred_repayment)
quietly egen catd=cut(pred_repayment) if any_loan==1, group(5)
forval n=0/4 {
	quietly egen top`n'=max(pred_repayment) if catd==`n'
	quietly egen bot`n'=min(pred_repayment) if catd==`n'
	}
quietly egen top=max(top0)
quietly egen bot=max(bot0)
quietly replace catd=0 if pred_repayment<=top & pred_repayment>=bot & any_loan==0
forval n=1/4 {
	quietly drop top bot
	quietly egen bot=max(bot`n')
	quietly egen top=max(top`n')
	quietly replace catd=`n' if pred_repayment<=top & pred_repayment>=bot & any_loan==0
	}
quietly tab catd, gen(pred_repay_ddum)
foreach num in 1 2 3 4 5 {
	quietly gen fp_pred_repayd`num'=pred_repay_ddum`num'*fingerprint
	}

*Table 3
reg approved fingerprint pred_treat pred_repayment D2-D32 if samp1 == 1, 
reg any_loan fingerprint pred_treat pred_repayment D2-D32 if samp1 == 1, 
*Tables 3 & 4 
foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, 
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, 
	}
svmat Y 
save DatGGY2, replace

*This reproduces (shortens) their code for standard errors and extracts the full covariance matrix - identical results to their code
mata BS = J(200,58,.)
set seed 111111111
forvalues c = 1/200 {
	use temp2data, clear
	display "`c'"
	quietly bsample, cluster(bfirm_club_id)
	quietly xi: reg frac_paid_sept30 $covars $riskfactors i.focode*i.offer_week if fingerprint==0 & source_oct_repay==1, cluster(bfirm_club_id)
	quietly predict pred_repayment if source_oct_baseline==1, xb
	quietly gen pred_treat=pred_repayment*fingerprint
	quietly tab fingerprint, sum(pred_repayment)
	quietly egen catd=cut(pred_repayment) if any_loan==1, group(5)
	forval n=0/4 {
		quietly egen top`n'=max(pred_repayment) if catd==`n'
		quietly egen bot`n'=min(pred_repayment) if catd==`n'
		}
	quietly egen top=max(top0)
	quietly egen bot=max(bot0)
	quietly replace catd=0 if pred_repayment<=top & pred_repayment>=bot & any_loan==0
	forval n=1/4 {
		quietly drop top bot
		quietly egen bot=max(bot`n')
		quietly egen top=max(top`n')
		quietly replace catd=`n' if pred_repayment<=top & pred_repayment>=bot & any_loan==0
		}
	quietly tab catd, gen(pred_repay_ddum)
	foreach num in 1 2 3 4 5 {
		quietly gen fp_pred_repayd`num'=pred_repay_ddum`num'*fingerprint
		}
	  
	matrix BS = J(1,58,.)	
	local j = 1
	*Table 3	
	foreach outcome in approved any_loan {
		quietly reg `outcome' fingerprint pred_treat pred_repayment D2-D32 if samp1 == 1, 
			matrix BS[1,`j'] = _b[fingerprint] , _b[pred_treat] 
		local j = `j' + 2
		}
	*Tables 3 & 4 
	foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
		quietly reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, 
			matrix BS[1,`j'] = _b[fingerprint] , _b[pred_treat] 
		local j = `j' + 2
		}
	*Tables 5, 6 & 7
	foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
		quietly reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, 
			matrix BS[1,`j'] = _b[fingerprint] , _b[pred_treat] 
		local j = `j' + 2
		}
	mata BS[`c',1..58] = st_matrix("BS")
	}	

drop _all
set obs 200
forvalues i = 1/58 {
	quietly generate double BS`i' = .
	}
mata st_store(.,.,BS)
collapse (sd) BS*, fast
list

******************************************
******************************************

*Part III: Panels C of all tables 

use temp2data, replace

quietly xi: reg frac_paid_sept30 $covars $riskfactors i.focode*i.offer_week if fingerprint==0 & source_oct_repay==1, cluster(bfirm_club_id)
quietly predict pred_repayment if source_oct_baseline==1, xb
quietly gen pred_treat=pred_repayment*fingerprint
quietly tab fingerprint, sum(pred_repayment)
quietly egen catd=cut(pred_repayment) if any_loan==1, group(5)
forval n=0/4 {
	quietly egen top`n'=max(pred_repayment) if catd==`n'
	quietly egen bot`n'=min(pred_repayment) if catd==`n'
	}
quietly egen top=max(top0)
quietly egen bot=max(bot0)
quietly replace catd=0 if pred_repayment<=top & pred_repayment>=bot & any_loan==0
forval n=1/4 {
	quietly drop top bot
	quietly egen bot=max(bot`n')
	quietly egen top=max(top`n')
	quietly replace catd=`n' if pred_repayment<=top & pred_repayment>=bot & any_loan==0
	}
quietly tab catd, gen(pred_repay_ddum)
foreach num in 1 2 3 4 5 {
	quietly gen fp_pred_repayd`num'=pred_repay_ddum`num'*fingerprint
	}
svmat Y
save DatGGY3, replace

*Table 3
foreach outcome in approved any_loan {
	reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* D2-D32 if samp1 == 1, 
	}
*Tables 3 & 4 
foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* DD2-DD21 if samp7 == 1, 
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* DDD2-DDD17 if samp7 == 1, 
	}

*This reproduces (shortens) their code for standard errors and extracts the full covariance matrix
mata BS = J(200,145,.)
set seed 111111111
forvalues c = 1/200 {
	use temp2data, clear
	display "`c'"
	quietly bsample, cluster(bfirm_club_id)
	quietly xi: reg frac_paid_sept30 $covars $riskfactors i.focode*i.offer_week if fingerprint==0 & source_oct_repay==1, cluster(bfirm_club_id)
	quietly predict pred_repayment if source_oct_baseline==1, xb
	quietly gen pred_treat=pred_repayment*fingerprint
	quietly tab fingerprint, sum(pred_repayment)
	quietly egen catd=cut(pred_repayment) if any_loan==1, group(5)
	forval n=0/4 {
		quietly egen top`n'=max(pred_repayment) if catd==`n'
		quietly egen bot`n'=min(pred_repayment) if catd==`n'
		}
	quietly egen top=max(top0)
	quietly egen bot=max(bot0)
	quietly replace catd=0 if pred_repayment<=top & pred_repayment>=bot & any_loan==0
	forval n=1/4 {
		quietly drop top bot
		quietly egen bot=max(bot`n')
		quietly egen top=max(top`n')
		quietly replace catd=`n' if pred_repayment<=top & pred_repayment>=bot & any_loan==0
		}
	quietly tab catd, gen(pred_repay_ddum)
	foreach num in 1 2 3 4 5 {
		quietly gen fp_pred_repayd`num'=pred_repay_ddum`num'*fingerprint
		}
	  
	matrix BS = J(1,145,.)	
	local j = 1
	*Table 3	
	foreach outcome in approved any_loan {
		quietly reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* D2-D32 if samp1 == 1, 
			matrix BS[1,`j'] = (_b[fp_pred_repayd1], _b[fp_pred_repayd2], _b[fp_pred_repayd3], _b[fp_pred_repayd4], _b[fp_pred_repayd5]) 
		local j = `j' + 5
		}
	*Tables 3 &  4 
	foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
		quietly reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* DD2-DD21 if samp7 == 1, 
			matrix BS[1,`j'] = (_b[fp_pred_repayd1], _b[fp_pred_repayd2], _b[fp_pred_repayd3], _b[fp_pred_repayd4], _b[fp_pred_repayd5]) 
		local j = `j' + 5
		}
	*Tables 5, 6 & 7
	foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
		quietly reg `outcome' pred_repay_ddum1-pred_repay_ddum4 fp_pred_repayd* DDD2-DDD17 if samp7 == 1, 
			matrix BS[1,`j'] = (_b[fp_pred_repayd1], _b[fp_pred_repayd2], _b[fp_pred_repayd3], _b[fp_pred_repayd4], _b[fp_pred_repayd5]) 
		local j = `j' + 5
		}
	mata BS[`c',1..145] = st_matrix("BS")
	}	

drop _all
set obs 200
forvalues i = 1/145 {
	quietly generate double BS`i' = .
	}
mata st_store(.,.,BS)
collapse (sd) BS*, fast
list

drop _all




