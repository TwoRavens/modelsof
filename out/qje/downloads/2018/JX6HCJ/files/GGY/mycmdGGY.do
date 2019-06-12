global cluster = "bfirm_club_id"


*Part I: Regressions in Panels A of all tables

use DatGGY1, clear

global i = 1
global j = 1
*Table 3
foreach outcome in approved any_loan {
	mycmd (fingerprint) reg `outcome' fingerprint D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
foreach outcome in total_owed {
	mycmd (fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Table 4 
foreach outcome in balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fingerprint) reg `outcome' fingerprint DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	mycmd (fingerprint) reg `outcome' fingerprint DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}


****************************************
****************************************


*Part II:  Panels B of all tables

use DatGGY2, clear

global covars "male agedum2 agedum3 agedum4 agedum5 agedum6 agedum7 agedum8 agedum9 agedum10 agedum11 agedum12 agedum13 agedum14 agedum15 agedum16 married educdum2 educdum3 educdum4 educdum5 educdum6 educdum7 educdum8 educdum9 educdum10"
global riskfactors "risky hungry late incomesd paprikaexp default nopreviousloan"

*Table 3
foreach outcome in approved any_loan {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
*Tables 3 & 4 
foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	mycmd (fingerprint pred_treat) reg `outcome' fingerprint pred_treat pred_repayment DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}


******************************************
******************************************

*Part III: Panels C of all tables 

use DatGGY3, clear

global covars "male agedum2 agedum3 agedum4 agedum5 agedum6 agedum7 agedum8 agedum9 agedum10 agedum11 agedum12 agedum13 agedum14 agedum15 agedum16 married educdum2 educdum3 educdum4 educdum5 educdum6 educdum7 educdum8 educdum9 educdum10"
global riskfactors "risky hungry late incomesd paprikaexp default nopreviousloan"

*Table 3
foreach outcome in approved any_loan {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 D2-D32 if samp1 == 1, cluster(bfirm_club_id)
	}
*Tables 3 & 4 
foreach outcome in total_owed balance_sept30 frac_paid_sept30 fully_paid_sept30 balance frac_paid fully_paid {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DD2-DD21 if samp7 == 1, cluster(bfirm_club_id)
	}
*Tables 5, 6 & 7
foreach outcome in frac_land_1 frac_land_2 frac_land_3 frac_land_4 frac_land_5 frac_land_6 frac_land_7 frac_land_8 frac_not_maize seeds_mk_pap_aug fert_mk_pap_aug chem_pap_mk ganyu_pap inputs_pap_mk manure_kg_pap weed_pap sales_self home_prod profits_self ln_profits_self {
	mycmd (fp_pred_repayd*) reg `outcome' fp_pred_repayd* pred_repay_ddum1-pred_repay_ddum4 DDD2-DDD17 if samp7 == 1, cluster(bfirm_club_id)
	}

