******************************************************************************************************
/*REPLICATION FILE FOR PAVING STREETS FOR THE POOR: EXPERIMENTAL ANALYSIS OF INFRASTRUCTURE EFFECTS
THE FILE CONSISTS OF CODE AND COMMENTS THAT ALLOW FOR REPLICATION OF ALL RESULTS IN MAIN TEXT */

*CONTACT MARCO GONZALEZ-NAVARRO (marco.gonzalez.navarro@utoronto.ca) OR
*CLIMENT QUINTANA-DOMEQUE (climent.quintana-domeque@economics.ox.ac.uk) WITH QUESTIONS

*NOTES:
* adj_ in prefix of variable name means inflation adjusted
* ln in variable name means natural logarithm
* _b at the end of variable names denotes follow_up (2009) variable
* jefeh==1 (househodl head==1) makes regressions refer to the household, as opposed to individuals
* clustering variable is proyecto2 - each candidate road pavement project is a cluster
* weighting variable for linked survey rounds is POND0609

******************************************************************************************************
clear all
set more off, permanently
*NOTE: change the line below to directory where all the data are:
cd "/Users/replication_files/"


********
*TABLE 1
********

*Use individual level dataset:	
use "2009_2006_c_reshaped_db1.dta",clear
set more off	

*****************
***Consumption***
*****************	

**Monthly log per capita expenditure
    *1-ITT
	reg adj_ln_pce [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & adj_ln_pce_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg adj_ln_pce [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & adj_ln_pce_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg adj_ln_pce  intent_to_treat [pweight=POND0609] if vivin==2 & adj_ln_pce_b!=. & jefeh==1, cluster(proyecto2)

***Monthly log sum of itemized expenditures per capita
    *1-ITT
	reg adj_ln_pc_sumexp [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & adj_ln_pc_sumexp_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg adj_ln_pc_sumexp [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & adj_ln_pc_sumexp_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg adj_ln_pc_sumexp  intent_to_treat [pweight=POND0609] if vivin==2 & adj_ln_pc_sumexp_b!=. & jefeh==1, cluster(proyecto2)

*** Household appliances  (0-6 = video player, computer, microwave, fridge, washing machine, AC)
    *1-ITT
	reg durable_goods [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & durable_goods_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg durable_goods [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & durable_goods_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg durable_goods  intent_to_treat [pweight=POND0609] if vivin==2 & durable_goods_b!=. & jefeh==1, cluster(proyecto2)

*** Vehicles (0-3 = motorcycle, truck, car)
    *1-ITT
	reg index_vehicle [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & index_vehicle_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg index_vehicle [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & index_vehicle_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg index_vehicle  intent_to_treat [pweight=POND0609] if vivin==2 & index_vehicle_b!=. & jefeh==1, cluster(proyecto2)

*** Number of home improvements (0-11) in the past 6 months
    *1-ITT
	reg home_improvements [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & home_improvements_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg home_improvements [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & home_improvements_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg home_improvements  intent_to_treat [pweight=POND0609] if vivin==2 & home_improvements_b!=. & jefeh==1, cluster(proyecto2)

*** Bought materials for home improvement in the past 6 months
    *1-ITT
	reg material_home_imp [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & material_home_imp_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg material_home_imp [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & material_home_imp_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg material_home_imp  intent_to_treat [pweight=POND0609] if vivin==2 & material_home_imp_b!=. & jefeh==1, cluster(proyecto2)

	
************
***Credit***
************	

*** Collateral-based credit
    *1-ITT
	reg collateral_based_credit [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & collateral_based_credit_b!=. & age>=18, cluster(proyecto2)
	*2-Control Group
	reg collateral_based_credit [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & collateral_based_credit_b!=. & age>=18, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg collateral_based_credit  intent_to_treat [pweight=POND0609] if vivin==2 & collateral_based_credit_b!=. & age>=18, cluster(proyecto2)

*** Collateral-based credit amount (=0 for individuals who did not use collateral-based credit in past year)
    *1-ITT
	reg adj_cbc_amount_p [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & adj_cbc_amount_p_b!=. & age>=18, cluster(proyecto2)
	*2-Control Group
	reg adj_cbc_amount_p [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & adj_cbc_amount_p_b!=. & age>=18, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg adj_cbc_amount_p  intent_to_treat [pweight=POND0609] if vivin==2 & adj_cbc_amount_p_b!=. & age>=18, cluster(proyecto2)

 *** Non-collateral based credit
    *1-ITT
	reg non_collateral_based_credit [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & non_collateral_based_credit_b!=. & age>=18, cluster(proyecto2)
	*2-Control Group
	reg non_collateral_based_credit [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & non_collateral_based_credit_b!=. & age>=18, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg non_collateral_based_credit  intent_to_treat [pweight=POND0609] if vivin==2 & non_collateral_based_credit_b!=. & age>=18, cluster(proyecto2)

*** Non-collateral based credit amount (=0 for individuals who did not use collateral based credit in past year)
    *1-ITT
	reg adj_non_cbc_amount_p [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & adj_non_cbc_amount_p_b!=. & age>=18, cluster(proyecto2)
	*2-Control Group
	reg adj_non_cbc_amount_p [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & adj_non_cbc_amount_p_b!=. & age>=18, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg adj_non_cbc_amount_p  intent_to_treat [pweight=POND0609] if vivin==2 & adj_non_cbc_amount_p_b!=. & age>=18, cluster(proyecto2)
	
*** Credit from family and friends
    *1-ITT
	reg family_friends_credit [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & family_friends_credit_b!=. & age>=18, cluster(proyecto2)
	*2-Control Group
	reg family_friends_credit [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & family_friends_credit_b!=. & age>=18, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg family_friends_credit  intent_to_treat [pweight=POND0609] if vivin==2 & family_friends_credit_b!=. & age>=18, cluster(proyecto2)

*** Informal private credit
    *1-ITT
	reg informal_private_credit [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & informal_private_credit_b!=. & age>=18, cluster(proyecto2)
	*2-Control Group
	reg informal_private_credit [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & informal_private_credit_b!=. & age>=18, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg informal_private_credit  intent_to_treat [pweight=POND0609] if vivin==2 & informal_private_credit_b!=. & age>=18, cluster(proyecto2)

*** Credit card
    *1-ITT
	reg creditcard [pweight=POND0609]   if intent_to_treat==1 & vivin==2 & creditcard_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg creditcard [pweight=POND0609]   if intent_to_treat==0 & vivin==2 & creditcard_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg creditcard  intent_to_treat [pweight=POND0609]  if vivin==2 & creditcard_b!=. & jefeh==1, cluster(proyecto2)

*** Bank account
    *1-ITT
	reg bankaccount [pweight=POND0609]   if intent_to_treat==1 & vivin==2 & bankaccount_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg bankaccount [pweight=POND0609]   if intent_to_treat==0 & vivin==2 & bankaccount_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg bankaccount  intent_to_treat [pweight=POND0609]  if vivin==2 & bankaccount_b!=. & jefeh==1, cluster(proyecto2)
	
	
******************************	
***Labor and Transportation***
******************************	

*** Weekly hours worked last week
    *1-ITT
	reg weekly_hours_worked [pweight=POND0609]   if intent_to_treat==1 & vivin==2 & age>=18 & weekly_hours_worked_b!=., cluster(proyecto2)
	*2-Control Group
	reg weekly_hours_worked [pweight=POND0609]   if intent_to_treat==0 & vivin==2 & age>=18 & weekly_hours_worked_b!=., cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg weekly_hours_worked  intent_to_treat [pweight=POND0609]  if vivin==2 & age>=18 & weekly_hours_worked_b!=., cluster(proyecto2)

*** Monthly log labor income
    *1-ITT
	reg ln_adj_monthly_labor_income [pweight=POND0609]   if intent_to_treat==1 & vivin==2 & ln_adj_monthly_labor_income_b!=.  & age>=18, cluster(proyecto2)
	*2-Control Group
	reg ln_adj_monthly_labor_income [pweight=POND0609]   if intent_to_treat==0 & vivin==2 & ln_adj_monthly_labor_income_b!=.  & age>=18, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg ln_adj_monthly_labor_income  intent_to_treat [pweight=POND0609]  if vivin==2 & ln_adj_monthly_labor_income_b!=.  & age>=18, cluster(proyecto2)

*** Plans to migrate in search of work (someone in household plans to migrate for work reasons)
    *1-ITT
	reg plan_mig_for_work [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & plan_mig_for_work_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg plan_mig_for_work [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & plan_mig_for_work_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg plan_mig_for_work  intent_to_treat [pweight=POND0609] if vivin==2 & plan_mig_for_work_b!=. & jefeh==1, cluster(proyecto2)
 	
*** Cost of taxi to city center
    *1-ITT
	reg cost_taxi [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & cost_taxi_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg cost_taxi [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & cost_taxi_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg cost_taxi  intent_to_treat [pweight=POND0609] if vivin==2 & cost_taxi_b!=. & jefeh==1, cluster(proyecto2)

*** Time to city center (minutes)
    *1-ITT
	reg center_transport_time [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & center_transport_time_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg center_transport_time [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & center_transport_time_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg center_transport_time  intent_to_treat [pweight=POND0609] if vivin==2 & center_transport_time_b!=. & jefeh==1, cluster(proyecto2)


************* 	
***Housing***
************* 	

*Use housing structure level dataset:	
use "2009_2006_c_reshaped_db2.dta",clear

***  Log owner estimate of house value
    *1-ITT
	reg adj_log_value_home_occ [pweight=POND0609] if intent_to_treat==1 & adj_log_value_home_occ_b!=. & owner==1 & owner_b==1 & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg adj_log_value_home_occ [pweight=POND0609]  if intent_to_treat==0 & adj_log_value_home_occ_b!=. & owner==1 & owner_b==1 & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg adj_log_value_home_occ  intent_to_treat  [pweight=POND0609] if adj_log_value_home_occ_b!=.   &  owner==1 & owner_b==1 & jefeh==1, cluster(proyecto2)
	
*** Log professional appraisal property
    *1-ITT
	reg adj_log_appraised_value [pweight=ponder]  if intent_to_treat==1 & adj_log_appraised_value_b!=.  &  (VIVIND==1 | VIVIND==98) & jefeh==1 , cluster(proyecto2)
	*2-Control Group
	reg adj_log_appraised_value [pweight=ponder] if intent_to_treat==0 & adj_log_appraised_value_b!=.   & (VIVIND==1 | VIVIND==98) & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg adj_log_appraised_value  intent_to_treat [pweight=ponder] if adj_log_appraised_value_b!=.    & (VIVIND==1 | VIVIND==98) & jefeh==1, cluster(proyecto2)

*** Log professional appraisal land
    *1-ITT
	reg adj_log_land_value [pweight=ponder] if intent_to_treat==1 & adj_log_land_value_b!=.  & (VIVIND==1 | VIVIND==98) & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg adj_log_land_value [pweight=ponder] if intent_to_treat==0 & adj_log_land_value_b!=.   & (VIVIND==1 | VIVIND==98) & jefeh==1 , cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg adj_log_land_value intent_to_treat [pweight=ponder] if adj_log_land_value_b!=.  & (VIVIND==1 | VIVIND==98) & jefeh==1 , cluster(proyecto2)

*** Log rent		

*Note: This step requires matching same housing structure to two different families (one at baseline and one at follow-up)
use "2009_2006_c_reshaped_db2.dta",clear
gen double id_hhd2=proyecto2*1000000000000+manzana2*10000000000+ageb1b*10000000+ageb2b_num*100000+viviend2*1000
format id_hhd2  %15.0g
duplicates drop id_hhd2, force
*Do the housing structure level matching:
set seed 339487731
gen unique=rnormal()
sort unique
keep if adj_exp_rent==. & adj_exp_rent_b>0 & adj_exp_rent_b!=. // sample of new renters in 09
keep if VIVIN==5 & adj_exp_rent_b>0 & adj_exp_rent_b!=. // sample of new renters in 09
keep intent_to_treat2 paved2 adj_exp_rent_b adj_log_exp_rent_b id_hhd2 proyecto2
rename id_hhd2 id_hhd
save "temp.dta", replace
clear all
use "2009_2006_c_reshaped_db2.dta"
gen double id_hhd=proyecto*1000000000000+manzana*10000000000+ageb1*10000000+ageb2_num*100000+vivienda*1000
format id_hhd  %15.0g
*Put respondent on first row of hhd
gen x=-dummy
sort id_hhd x
drop x
gen x=-adj_exp_rent
sort id_hhd x
drop x
duplicates drop id_hhd, force
keep adj_exp_rent adj_log_exp_rent id_hhd
merge 1:1 id_hhd using "temp.dta"
tab _merge
erase "temp.dta"
keep if _merge==3
drop _merge

        *1-ITT
        reg adj_log_exp_rent if intent_to_treat2==1 & adj_log_exp_rent_b>0 & adj_log_exp_rent>0 & adj_log_exp_rent_b!=0 & adj_log_exp_rent!=0, cluster(proyecto2)
        *2-Control Group
        reg adj_log_exp_rent if intent_to_treat2==0 & adj_log_exp_rent_b>0 & adj_log_exp_rent>0 & adj_log_exp_rent_b!=0 & adj_log_exp_rent!=0, cluster(proyecto2)
        *3-ITT-C (z=1 vs z=0)
        reg adj_log_exp_rent intent_to_treat2 if adj_log_exp_rent_b>0 & adj_log_exp_rent>0 & adj_log_exp_rent_b!=0 & adj_log_exp_rent!=0, cluster(proyecto2)

	
*** Nearest paved streets (blocks)
		

use "2009_2006_c_reshaped_db2",clear
    		
    *1-ITT
	reg cuadras [pweight=POND0609]   if intent_to_treat==1 & vivin==2 & cuadras_b!=.  & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg cuadras [pweight=POND0609]   if intent_to_treat==0 & vivin==2 & cuadras_b!=.  & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg cuadras   intent_to_treat [pweight=POND0609] if vivin==2 & cuadras_b!=.  & jefeh==1, cluster(proyecto2)


	
********
*TABLE 2
********

    *Wild bootstrap estimation requires the installtion of cgmreg.ado
    *Download it here: http://gelbach.law.upenn.edu/~gelbach/ado/cgmreg.ado
    *The ado file is in the replication folder
    *Estimation also requires the use of unique.pkg

    use "2009_2006_c_reshaped_db2.dta",clear

    *Define relevant variable for Table 2:

        *Assigned to treatment some progress:
        gen itt_st=0
        replace itt_st=1 if proyecto2==2 | proyecto2==44
        *Assigned to treatment but no progress:
        gen itt_nt=0
        replace itt_nt=1 if proyecto2==2 | proyecto2==8 | proyecto2==13 | proyecto2==17 | proyecto2==31 | proyecto2==32
        replace itt_nt=1 if proyecto2==35 | proyecto2==36 | proyecto2==37 | proyecto2==44 | proyecto2==46

    *Row 1 (Log professional appraisal of property value)
        reg adj_log_appraised_value_b itt_nt adj_log_appraised_value [pweight=ponder] if adj_log_appraised_value!=. & (intent_to_treat2==0 | itt_nt==1) & jefeh==1 & (VIVIND==1 | VIVIND==98), cluster(proyecto2)
        cgmwildboot adj_log_appraised_value_b itt_nt adj_log_appraised_value [pweight=ponder] if adj_log_appraised_value!=. & (intent_to_treat2==0 | itt_nt==1) & jefeh==1 & (VIVIND==1 | VIVIND==98), cluster(proyecto2) bootcluster(proyecto2) null(0 .) reps(500) seed(18724)

    *Row 2 (Log owner estimate of property value)
        reg adj_log_value_home_occ_b itt_nt adj_log_value_home_occ [pweight=POND0609] if adj_log_value_home_occ!=. & (intent_to_treat2==0 | itt_nt==1)  & owner==1 & owner_b==1 & jefeh==1, cluster(proyecto2)
        cgmwildboot adj_log_value_home_occ_b itt_nt adj_log_value_home_occ [pweight=POND0609] if adj_log_value_home_occ!=. & (intent_to_treat2==0 | itt_nt==1)  & owner==1 & owner_b==1 & jefeh==1, cluster(proyecto2) bootcluster(proyecto2) null(0 .) reps(500) seed(18724)
		
    *Row 3 (Log transaction price recent purchase)
        *Create the housing structure level database:
    	gen double id_hhd2=proyecto2*100000000000+manzana2*1000000000+ageb1b*1000000+ageb2b_num*10000+viviend2*100+HOGAR1*10+vivin
	    format id_hhd2  %15.0g
        *Puts respondent on first row of hhd:
        gen x=-dummy
        sort id_hhd2 x
        drop x
        duplicates drop  id_hhd2, force

        reg log_price_paid_b itt_nt if owner_b==1 & (VIVIND==5 | VIVIND==6) [pweight=POND2009], cluster(proyecto2)
	    cgmwildboot log_price_paid_b itt_nt if owner_b==1 & (VIVIND==5 | VIVIND==6) [pweight=POND2009], cluster(proyecto2) bootcluster(proyecto2) null(0) reps(500) seed(18724)



	
********
*TABLE 3
********


    *Note: Correct weights are 2006 weights not the linked 06-09 weigths.

    use "2009_2006_c_reshaped_db2",clear
    *Turn dataset into household level:
	gen double id_hhd=proyecto*100000000000+manzana*1000000000+ageb1*1000000+ageb2_num*10000+vivienda*100+hogar
	format id_hhd  %15.0g
	duplicates drop  id_hhd, force
	
*TOP PANEL - Out-migration rate (household out-migrated):
    *1-ITT
	reg migrate intent_to_treat [pweight=ponder], robust cluster(proyecto)
	*2-2SLS
	ivregress 2sls migrate (paved=intent_to_treat) [pweight= ponder], robust cluster(proyecto)
    *3- Mean for control group in 2006 (intent_to_treat==0)
    reg migrate  [pweight= ponder] if intent_to_treat==0, cluster(proyecto)

*BOTTOM PANEL - Out-migrant characteristics:
    *Note: totper06 not defined for outmigrants use totper***
    drop ln_pce pce
    gen pce=exp/totper
    gen ln_pce=ln(pce)

*** log(PCE) ***
    *1-ITT
	reg ln_pce intent_to_treat [pweight=ponder] if migrate==1, robust cluster(proyecto)
	*2-2SLS
	ivregress 2sls ln_pce (paved=intent_to_treat) [pweight=ponder] if migrate==1, robust cluster(proyecto)
    *3- Mean for control group in 2006 (intent_to_treat==0)
    reg ln_pce  [pweight=ponder] if intent_to_treat==0 & migrate==1, cluster(proyecto)

*** Household appliances ***
    *1-ITT
	reg durable_goods intent_to_treat [pweight=ponder] if migrate==1, robust cluster(proyecto)
	*2-2SLS
	ivregress 2sls durable_goods  (paved=intent_to_treat) [pweight=ponder] if migrate==1, robust cluster(proyecto)
    *3-Mean for control group in 2006 (intent_to_treat==0)
    reg durable_goods  [pweight=ponder] if intent_to_treat==0  & migrate==1, cluster(proyecto2)

*** Vehicle ownership ***
    *1-ITT
	reg index_vehicle intent_to_treat [pweight=ponder] if migrate==1, robust cluster(proyecto)
	*2-2SLS
	ivregress 2sls index_vehicle (paved=intent_to_treat) [pweight=ponder] if migrate==1, robust cluster(proyecto)
    *3-Mean for control group in 2006 (intent_to_treat==0)
    reg index_vehicle  [pweight=ponder] if intent_to_treat==0  & migrate==1, cluster(proyecto)
	

	


********
*TABLE 4
********

    *Note: Correct weights are 2009 weights not the linked 06-09 weigths.

    use "2009_2006_c_reshaped_db2",clear
    *Delete households lost after the 2006 round:
    drop if VIVIND==98
    *Turn dataset into household level:
	gen double id_hhd2=proyecto2*100000000000+manzana2*1000000000+ageb1b*1000000+ageb2b_num*10000+viviend2*100+HOGAR1*10+vivin
	format id_hhd2  %15.0g
    *Puts respondent on first row of hhd
    gen x=-dummy
    sort id_hhd2 x
    drop x
 	duplicates drop  id_hhd2, force
    tab VIVIND

*TOP PANEL - Immigration rate (household immigrated):
    *1-ITT
	reg immigrate intent_to_treat2 [pweight=POND2009], robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls immigrate (paved2=intent_to_treat2) [pweight= POND2009], robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg immigrate  [pweight= POND2009] if intent_to_treat2==0, cluster(proyecto2)

*BOTTOM PANEL - Immigrant characteristics:	

*** log(PCE) ***
    *1-ITT
	reg ln_pce_b intent_to_treat2 [pweight=POND2009] if immigrate==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls ln_pce_b (paved2=intent_to_treat2) [pweight= POND2009] if immigrate==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg ln_pce_b  [pweight= POND2009] if intent_to_treat2==0 & immigrate==1, cluster(proyecto2)

*** Household appliances ***
    *1-ITT
	reg durable_goods_b intent_to_treat2 [pweight=POND2009] if immigrate==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls durable_goods_b (paved2=intent_to_treat2) [pweight= POND2009] if immigrate==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg durable_goods_b  [pweight= POND2009] if intent_to_treat2==0  & immigrate==1, cluster(proyecto2)
	
*** Vehicle ownership ***
    *1-ITT
	reg index_vehicle_b intent_to_treat2 [pweight=POND2009] if immigrate==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls index_vehicle_b (paved2=intent_to_treat2) [pweight= POND2009] if immigrate==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg index_vehicle_b  [pweight= POND2009] if intent_to_treat2==0  & immigrate==1, cluster(proyecto2)


******** 	
*TABLE 5
********

    use "2009_2006_c_reshaped_db2",clear

*** Log professional appraisal of property value
       *1-ITT
       reg adj_log_appraised_value_b intent_to_treat2 adj_log_appraised_value [pweight=ponder]  if adj_log_appraised_value!=. & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2)
	   *2-2SLS
       ivregress 2sls  adj_log_appraised_value_b (paved2=intent_to_treat2) adj_log_appraised_value [pweight=ponder] if adj_log_appraised_value!=. & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2)
       *3- Mean for control group in 2009 (intent_to_treat2==0)
       reg adj_log_appraised_value_b [pweight=ponder] if adj_log_appraised_value!=. & intent_to_treat2==0 & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2)

*** Log professional appraisal of land value
       *1-ITT
        reg adj_log_land_value_b intent_to_treat2 adj_log_land_value [pweight=ponder]  if adj_log_land_value!=. & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2)
	   *2-2SLS
        ivregress 2sls  adj_log_land_value_b (paved2=intent_to_treat2) adj_log_land_value [pweight=ponder] if adj_log_land_value!=. & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2)
        *** Mean for control group in 2009 (intent_to_treat2==0)
        reg adj_log_land_value_b [pweight=ponder] if adj_log_land_value!=. & intent_to_treat2==0 & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2)

*** Log owner estimate of property value
        *1-ITT
        reg adj_log_value_home_occ_b intent_to_treat2 adj_log_value_home_occ [pweight=POND0609] if adj_log_value_home_occ!=. & owner==1 & owner_b==1  & jefeh==1, cluster(proyecto2)
	   *2-2SLS
        ivregress 2sls  adj_log_value_home_occ_b (paved2=intent_to_treat2) adj_log_value_home_occ [pweight=POND0609] if adj_log_value_home_occ!=. & owner==1 & owner_b==1  & jefeh==1, cluster(proyecto2)
        *** Mean for control group in 2009 (intent_to_treat2==0)
        reg adj_log_value_home_occ_b [pweight=POND0609] if adj_log_value_home_occ!=. & intent_to_treat2==0 & owner==1 & owner_b==1  & jefeh==1, cluster(proyecto2)

***************************************************************************
*** Footnote comment: Impacts for short-tenured homeowners (tenure_b<=5)***
        *1-ITT
        reg adj_log_value_home_occ_b intent_to_treat2 adj_log_value_home_occ [pweight=POND0609] if adj_log_value_home_occ!=. & tenure_b<=5 & owner==1 & owner_b==1  & jefeh==1, cluster(proyecto2)
	    *2-2SLS
        ivregress 2sls  adj_log_value_home_occ_b (paved2=intent_to_treat2) adj_log_value_home_occ [pweight=POND0609] if adj_log_value_home_occ!=. & tenure_b<=5 & owner==1 & owner_b==1 & jefeh==1, cluster(proyecto2)
***************************************************************************

*** Log rent
    *Note: This step requires matching same housing structure to two different families (one at baseline and one at follow-up)
    	gen double id_hhd2=proyecto2*1000000000000+manzana2*10000000000+ageb1b*10000000+ageb2b_num*100000+viviend2*1000
	    format id_hhd2  %15.0g
        duplicates drop id_hhd2, force
        *Do the housing structure level matching:
        set seed 339487731
        gen unique=rnormal()
        sort unique
        keep if adj_exp_rent==. & adj_exp_rent_b>0 & adj_exp_rent_b!=. // sample of new renters in 09
        keep if VIVIN==5 & adj_exp_rent_b>0 & adj_exp_rent_b!=. // sample of new renters in 09
        keep intent_to_treat2 paved2 adj_exp_rent_b adj_log_exp_rent_b id_hhd2 proyecto2
        rename id_hhd2 id_hhd
        save "temp.dta", replace
        clear all
        use "2009_2006_c_reshaped_db2.dta"
    	gen double id_hhd=proyecto*1000000000000+manzana*10000000000+ageb1*10000000+ageb2_num*100000+vivienda*1000
	    format id_hhd  %15.0g
        *Put respondent on first row of hhd
        gen x=-dummy
        sort id_hhd x
        drop x
        gen x=-adj_exp_rent
        sort id_hhd x
        drop x
        duplicates drop id_hhd, force
        keep adj_exp_rent adj_log_exp_rent id_hhd
        merge 1:1 id_hhd using "temp.dta"
        tab _merge
        erase "temp.dta"
        keep if _merge==3
        drop _merge

        *1-ITT
        reg adj_log_exp_rent_b intent_to_treat2 adj_log_exp_rent if adj_log_exp_rent_b>0 & adj_log_exp_rent>0 & adj_log_exp_rent_b!=0 & adj_log_exp_rent!=0, cluster(proyecto2)
	    *2-2SLS
        ivregress 2sls adj_log_exp_rent_b (paved2=intent_to_treat2) adj_log_exp_rent if adj_log_exp_rent_b>0 & adj_log_exp_rent>0 & adj_log_exp_rent_b!=0 & adj_log_exp_rent!=0, cluster(proyecto2)
        *3- Mean for control group in 2009 (intent_to_treat2==0)
        reg adj_log_exp_rent_b if e(sample)==1 & intent_to_treat2==0

*** Log transaction price recent purchases
        use "2009_2006_c_reshaped_db2",clear
    	gen double id_hhd2=proyecto2*100000000000+manzana2*1000000000+ageb1b*1000000+ageb2b_num*10000+viviend2*100+HOGAR1*10+vivin
	    format id_hhd2  %15.0g
        *Puts respondent on first row of hhd
        gen x=-dummy
        sort id_hhd2 x
        drop x
 	    duplicates drop  id_hhd2, force

        *1-ITT
        reg log_price_paid_b intent_to_treat2 if owner_b==1 & (VIVIND==5 | VIVIND==6) [pweight=POND2009], cluster(proyecto2)
        *2SLS
        ivregress 2sls log_price_paid_b (paved2=intent_to_treat2) if owner_b==1 & (VIVIND==5 | VIVIND==6) [pweight=POND2009], cluster(proyecto2)
        *3-Mean for control group in 2009 (intent_to_treat2==0)
        reg log_price_paid_b if e(sample) & intent_to_treat2==0

******** 	
*TABLE 6
********

    use "2009_2006_c_reshaped_db1",clear

*** Household appliances  (0-6 = video player, computer, microwave, fridge, washing machine, AC)
    *1-ITT
	reg durable_goods_b intent_to_treat2 durable_goods [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls durable_goods_b (paved2=intent_to_treat2) durable_goods [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg durable_goods_b  [pweight= POND0609] if vivin==2 & durable_goods!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Vehicles (0-3 = motorcycle, truck, car)
    *1-ITT
	reg index_vehicle_b intent_to_treat2 index_vehicle [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls index_vehicle_b (paved2=intent_to_treat2) index_vehicle [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg index_vehicle_b  [pweight= POND0609] if vivin==2 & index_vehicle!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Number of home improvements (0-11) in the past 6 months
    *1-ITT
	reg home_improvements_b intent_to_treat2 home_improvements [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls home_improvements_b (paved2=intent_to_treat2) home_improvements [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg home_improvements_b  [pweight= POND0609] if vivin==2 & home_improvements!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Bought materials for home improvement in the past 6 months
    *1-ITT
	reg material_home_imp_b intent_to_treat2 material_home_imp [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls material_home_imp_b (paved2=intent_to_treat2) material_home_imp [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg material_home_imp_b  [pweight= POND0609] if vivin==2 & material_home_imp!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)
	
*** Monthly log per capita expenditure
    *1-ITT
	reg adj_ln_pce_b intent_to_treat2 adj_ln_pce [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls adj_ln_pce_b (paved2=intent_to_treat2) adj_ln_pce [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg adj_ln_pce_b  [pweight= POND0609] if vivin==2 & adj_ln_pce!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Monthly log sum of itemized expenditures per capita
    *1-ITT
	reg adj_ln_pc_sumexp_b intent_to_treat2 adj_ln_pc_sumexp [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls adj_ln_pc_sumexp_b (paved2=intent_to_treat2) adj_ln_pc_sumexp [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg adj_ln_pc_sumexp_b  [pweight= POND0609] if vivin==2 & adj_ln_pc_sumexp!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)


********
*TABLE 7
********

    use "2009_2006_c_reshaped_db1",clear

*** Collateral-based credit
    *1-ITT
	reg collateral_based_credit_b intent_to_treat2 collateral_based_credit [pweight=POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls collateral_based_credit_b (paved2=intent_to_treat2) collateral_based_credit  [pweight= POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg collateral_based_credit_b  [pweight= POND0609] if vivin==2 & collateral_based_credit!=. &  intent_to_treat2==0 &  age>=18 , cluster(proyecto2)

*** Collateral-based credit amount (=0 for individuals who did not use collateral based credit in past year)
	*1-ITT
	reg adj_cbc_amount_p_b intent_to_treat2 adj_cbc_amount_p [pweight=POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls adj_cbc_amount_p_b (paved2=intent_to_treat2) adj_cbc_amount_p  [pweight= POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg adj_cbc_amount_p_b  [pweight= POND0609] if vivin==2 & adj_cbc_amount_p!=. &  intent_to_treat2==0 &  age>=18 , cluster(proyecto2)

*** Non-collateral based credit
	*1-ITT
	reg non_collateral_based_credit_b intent_to_treat2 non_collateral_based_credit [pweight=POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls non_collateral_based_credit_b (paved2=intent_to_treat2) non_collateral_based_credit  [pweight= POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg non_collateral_based_credit_b  [pweight= POND0609] if vivin==2 & non_collateral_based_credit!=. &  intent_to_treat2==0 &  age>=18 , cluster(proyecto2)

*** Non-collateral based credit amount (=0 for individuals who did not use collateral based credit in past year)
	*1-ITT
	reg adj_non_cbc_amount_p_b intent_to_treat2 adj_non_cbc_amount_p [pweight=POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls adj_non_cbc_amount_p_b (paved2=intent_to_treat2) adj_non_cbc_amount_p  [pweight= POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg adj_non_cbc_amount_p_b  [pweight= POND0609] if vivin==2 & adj_non_cbc_amount_p!=. &  intent_to_treat2==0 &  age>=18 , cluster(proyecto2)
	
*** Credit from family and friends
    *1-ITT
	reg family_friends_credit_b intent_to_treat2 family_friends_credit [pweight=POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls family_friends_credit_b (paved2=intent_to_treat2) family_friends_credit [pweight= POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg family_friends_credit_b  [pweight= POND0609] if vivin==2 & family_friends_credit!=. &  intent_to_treat2==0 &  age>=18 , cluster(proyecto2)

*** Informal private credit
    *1-ITT
	reg informal_private_credit_b intent_to_treat2 informal_private_credit [pweight=POND0609] if vivin==2 & age>=18, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls informal_private_credit_b (paved2=intent_to_treat2) informal_private_credit  [pweight= POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg informal_private_credit_b  [pweight= POND0609] if vivin==2 & informal_private_credit!=. &  intent_to_treat2==0 &  age>=18 , cluster(proyecto2)

*** Credit card
    *1-ITT
	reg creditcard_b intent_to_treat2 creditcard [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls creditcard_b (paved2=intent_to_treat2) creditcard [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg creditcard_b  [pweight= POND0609] if vivin==2 & creditcard!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Bank account
    *1-ITT
	reg bankaccount_b intent_to_treat2 bankaccount [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls bankaccount_b (paved2=intent_to_treat2) bankaccount [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg bankaccount_b  [pweight= POND0609] if vivin==2 & bankaccount!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)



******** 		
*TABLE 8
******** 	

    use "2009_2006_c_reshaped_db1",clear

*** Cost of taxi to city center (pesos)
    *1-ITT
	reg cost_taxi_b intent_to_treat2 cost_taxi [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls cost_taxi_b (paved2=intent_to_treat2) cost_taxi [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *** Mean for control group in 2009 (intent_to_treat2==0)
    reg cost_taxi_b  [pweight= POND0609] if vivin==2 & cost_taxi!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Time to city center (minutes)
    *1-ITT
	reg center_transport_time_b intent_to_treat2 center_transport_time [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls center_transport_time_b (paved2=intent_to_treat2) center_transport_time [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg center_transport_time_b  [pweight= POND0609] if vivin==2 & center_transport_time!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Distance to nearest paved street (street blocks)
    *1-ITT
	reg cuadras_b intent_to_treat2 cuadras [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls cuadras_b (paved2=intent_to_treat2) cuadras  [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg cuadras_b  [pweight= POND0609] if vivin==2 & cuadras!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)
		
*** Weekly hours worked last week
    *1-ITT
	reg weekly_hours_worked_b intent_to_treat2 weekly_hours_worked [pweight=POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls weekly_hours_worked_b (paved2=intent_to_treat2) weekly_hours_worked  [pweight= POND0609] if vivin==2 & age>=18 , robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg weekly_hours_worked_b  [pweight= POND0609] if vivin==2 & weekly_hours_worked!=. &  intent_to_treat2==0 &  age>=18 , cluster(proyecto2)

*** Monthly log labor income
    *1-ITT
	reg ln_adj_monthly_labor_income_b intent_to_treat2 ln_adj_monthly_labor_income [pweight=POND0609] if vivin==2 & age>=18  , robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls ln_adj_monthly_labor_income_b (paved2=intent_to_treat2) ln_adj_monthly_labor_income  [pweight= POND0609] if vivin==2 & age>=18  , robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg ln_adj_monthly_labor_income_b  [pweight= POND0609] if vivin==2 & ln_adj_monthly_labor_income!=. &  intent_to_treat2==0 &  age>=18 , cluster(proyecto2)

*** Plans to migrate in search of workd (someone in household plans to migrate for work reasons)
    *1-ITT
	reg plan_mig_for_work_b intent_to_treat2 plan_mig_for_work [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls plan_mig_for_work_b (paved2=intent_to_treat2) plan_mig_for_work [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg plan_mig_for_work_b  [pweight= POND0609] if vivin==2 & plan_mig_for_work!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)
	


********  	
*TABLE 9
********


    use "2009_2006_c_reshaped_db1",clear

    rename durable_goods_b yvar
    rename index_vehicle_b yvar2
    rename home_improvements_b yvar3

    ***Rescale in thousands of Pesos
    gen double x_1=adj_cbc_amount_p_b/1000
    gen double x_2=land_value_b/1000

    gen double x_1_lagged=adj_cbc_amount_p/1000
    gen double x_1_int=x_1*x_1_lagged
    gen double x_2_lagged=land_value/1000
    gen double x_2_int=x_2*x_2_lagged

**** Household appliances index
    *Col 1:
    reg yvar x_1 x_1_lagged x_1_int [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *Col 2:
    reg yvar x_1 x_1_lagged x_1_int durable_goods [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)

**** Home improvements index
    *Col 3:
    reg yvar3 x_1 x_1_lagged x_1_int [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *Col 4:
    reg yvar3 x_1 x_1_lagged x_1_int home_improvements [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)

**** Motorized vehicles index
    *Col 5:
    reg yvar2 x_1 x_1_lagged x_1_int [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *Col 6:
    reg yvar2 x_1 x_1_lagged x_1_int index_vehicle [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)

********** 		
* TABLE 10
********** 		

   use "2009_2006_c_reshaped_db2",clear

*Number of plots:
    local N=814

*Coefficient on land value effect
    ivregress 2sls  adj_log_land_value_b (paved2=intent_to_treat2) adj_log_land_value if adj_log_land_value!=. & jefeh==1 & (VIVIND==1 | VIVIND==98) [pweight=ponder], cluster(proyecto2)
    local beta=_b[paved2]
    local se_beta=_se[paved2]

*Average plot value in itt=0 group:
    reg adj_land_value  if intent_to_treat==0 & jefeh==1 & (VIVIND==98 | VIVIND==1) [pweight=ponder], cluster(proyecto)
    local y_itt0=_b[_cons]
    local se_y_itt0=_se[_cons]

*Gains per plot:
    display "E[XY]=E[X]E[Y], hence:"
    display "Gains per Plot= " `beta'*`y_itt0'
    display "V[XY]=(E[Y])^2*V[X] + E[X])^2*V[Y]  + V[X]V[Y], hence:"
    display "se= " sqrt(   ((`beta')^2*(`se_y_itt0')^2)   +  ((`se_beta')^2*(`y_itt0')^2)   +   ((`se_beta')^2*(`se_y_itt0')^2)     )
    local benefit=`beta'*`y_itt0'

*Total benefit estimate:
    display "E[XY]=E[X]E[Y], hence:"
    display "Total Benefit= " `N'*`beta'*`y_itt0'
    display "V[XY]=(E[Y])^2*V[X] + (E[X])^2*V[Y]  + V[X]V[Y], hence:"
    display "se= " `N'* sqrt(   ((`beta')^2*(`se_y_itt0')^2)   +  ((`se_beta')^2*(`y_itt0')^2)   +   ((`se_beta')^2*(`se_y_itt0')^2)     )
    local se_benefit=`N'* sqrt(   ((`beta')^2*(`se_y_itt0')^2)   +  ((`se_beta')^2*(`y_itt0')^2)   +   ((`se_beta')^2*(`se_y_itt0')^2)     )
    local benefit=`N'*`beta'*`y_itt0'
*Costs:
    local cost=11304642

*Benefit/cost ratio:
    display `benefit'/`cost'
    display `se_benefit'/`cost'

*95 % CI (lower and upper bounds):
    display `benefit'/`cost' - 1.96*(`se_benefit'/`cost')
    display `benefit'/`cost' + 1.96*(`se_benefit'/`cost')

********************************************************************************
********************************************************************************
********************************************************************************
