******************************************************************************************************
/*REPLICATION FILE FOR WEB APPENDIX OF PAVING STREETS FOR THE POOR: EXPERIMENTAL ANALYSIS OF INFRASTRUCTURE EFFECTS
THE FILE CONSISTS OF CODE AND COMMENTS THAT ALLOW FOR REPLICATION OF ALL RESULTS IN THE APPENDIX OF THE PAPER*/

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


*********
*TABLE A2
*********

*Use individual level dataset:	
use "2009_2006_c_reshaped_db1.dta",clear


****************************
***Demographic indicators***
****************************

*** Household members (number of household members: hhd level achieved by taking just the "jefe de hogar", i.e., jefeh==1)
    *1-ITT
	reg totper06 [pweight=POND0609] if intent_to_treat==1 & jefeh==1 & vivin==2 & totalp!=., cluster(proyecto2)
	*2-Control Group
	reg totper06 [pweight=POND0609]  if intent_to_treat==0  & jefeh==1 & vivin==2 & totalp!=., cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg totper06 intent_to_treat [pweight=POND0609] if jefeh==1 & vivin==2 & totalp!=., cluster(proyecto2)
	
*** Female
    *1-ITT
	reg female [pweight=POND0609] if intent_to_treat==1 & vivin==2, cluster(proyecto2)
	*2-Control Group
	reg female [pweight=POND0609] if intent_to_treat==0 & vivin==2, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg female  intent_to_treat [pweight=POND0609] if vivin==2, cluster(proyecto2)

*** Adult Schooling (age>=18 & age<=65)
    *1-ITT
	reg schooling [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & age>=18 & age<=65 & schooling_b!=., cluster(proyecto2)
	*2-Control Group
	reg schooling [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & age>=18 & age<=65 & schooling_b!=., cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg schooling intent_to_treat [pweight=POND0609] if vivin==2 & age>=18 & age<=65 & schooling_b!=., cluster(proyecto2)

*** Adult Age (age>=18 & age<=65)
    *1-ITT
	reg age [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & age>=18 & age<=65 & age_b!=., cluster(proyecto2)
	*2-Control Group
	reg age [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & age>=18 & age<=65 & age_b!=., cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg age  intent_to_treat [pweight=POND0609] if vivin==2 & age>=18 & age<=65 & age_b!=., cluster(proyecto2)

	

**********************************************************************************************************
***Home characteristics*** (as before hhd level achieved by taking just the jefe de hogar, i.e., jefeh==1)
**********************************************************************************************************	


*** Homeowner (=1 vs renter =0)
    *1-ITT
	reg owner [pweight=POND0609] if intent_to_treat==1 & vivin==2 & owner_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg owner [pweight=POND0609] if intent_to_treat==0 & vivin==2 & owner_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg owner  intent_to_treat [pweight=POND0609] if vivin==2 & owner_b!=. & jefeh==1, cluster(proyecto2)

*** Number of Rooms
    *1-ITT
	reg rooms [pweight=POND0609]   if intent_to_treat==1 & vivin==2 & rooms_b!=.   & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg rooms [pweight=POND0609]   if intent_to_treat==0 & vivin==2 & rooms_b!=.   & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg rooms  intent_to_treat [pweight=POND0609]  if vivin==2 & rooms_b!=.   & jefeh==1, cluster(proyecto2)

*** Cement roof + cement walls + hard floor (0-3)
    *1-ITT
	reg cement_roof_floor_wall [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & cement_roof_floor_wall_b!=.   & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg cement_roof_floor_wall [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & cement_roof_floor_wall_b!=.   & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg cement_roof_floor_wall  intent_to_treat [pweight=POND0609] if vivin==2 & cement_roof_floor_wall_b!=.   & jefeh==1, cluster(proyecto2)

*** Bathroom inside house
    *1-ITT
	reg bathroom [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & bathroom_b!=.   & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg bathroom [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & bathroom_b!=.   & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg bathroom  intent_to_treat [pweight=POND0609] if vivin==2 & bathroom_b!=.   & jefeh==1, cluster(proyecto2)

*** Water connection inside the house
    *1-ITT
	reg water_inside_house [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & water_inside_house_b!=.   & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg water_inside_house [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & water_inside_house_b!=.   & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg water_inside_house  intent_to_treat [pweight=POND0609] if vivin==2 & water_inside_house_b!=.   & jefeh==1, cluster(proyecto2)
	
*** Tap water connection in lot
    *1-ITT
	reg water_in_lot [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & water_in_lot_b!=.   & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg water_in_lot [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & water_in_lot_b!=.   & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg water_in_lot  intent_to_treat [pweight=POND0609] if vivin==2 & water_in_lot_b!=.   & jefeh==1, cluster(proyecto2)

*** Sewerage
    *Randomization
    *1-ITT
	reg sewage [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & sewage_b!=.   & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg sewage [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & sewage_b!=.   & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg sewage  intent_to_treat [pweight=POND0609] if vivin==2 & sewage_b!=.   & jefeh==1, cluster(proyecto2)

*** Electricity
    *Randomization
    *1-ITT
	reg electricity [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & electricity_b!=.  & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg electricity [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & electricity_b!=.  & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg electricity  intent_to_treat [pweight=POND0609] if vivin==2 & electricity_b!=.  & jefeh==1, cluster(proyecto2)

*** Garbage collection
    *Randomization
    *1-ITT
	reg garbage_collection [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & garbage_collection_b!=.  & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg garbage_collection [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & garbage_collection_b!=.  & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg garbage_collection  intent_to_treat [pweight=POND0609] if vivin==2 & garbage_collection_b!=.  & jefeh==1, cluster(proyecto2)

*** Cleanliness of street
    *Randomization
    *1-ITT
	reg clean_street [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & clean_street_b!=.   & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg clean_street [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & clean_street_b!=.   & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg clean_street  intent_to_treat [pweight=POND0609] if vivin==2 & clean_street_b!=.   & jefeh==1, cluster(proyecto2)
		
	
*** Gas truck delivery service
    *Randomization
    *1-ITT
	reg gas_truck [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & gas_truck_b!=.  & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg gas_truck [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & gas_truck_b!=.  & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg gas_truck  intent_to_treat [pweight=POND0609] if vivin==2 & gas_truck_b!=.  & jefeh==1, cluster(proyecto2)
	
***********
***Labor***
***********	

*** Works (worked last week, age>=18)
    *1-ITT
	reg work [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & work_b!=. &  age>=18 & work_b!=., cluster(proyecto2)
	*2-Control Group
	reg work [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & work_b!=. &  age>=18 & work_b!=., cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg work  intent_to_treat [pweight=POND0609] if vivin==2 & work_b!=. &  age>=18 & work_b!=., cluster(proyecto2)


*** Unemployed
    *1-ITT
	reg unemployed [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & age>=18 & unemployed_b!=., cluster(proyecto2)
	*2-Control Group
	reg unemployed [pweight=POND0609]   if intent_to_treat==0 & vivin==2 & age>=18 & unemployed_b!=., cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg unemployed   intent_to_treat [pweight=POND0609] if vivin==2 & age>=18 & unemployed_b!=., cluster(proyecto2)

*** Government welfare program participant (LICONSA, Progresa-Oportunidades, DIF, etc.)
    *1-ITT
	reg prog_gob [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & prog_gob_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg prog_gob [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & prog_gob_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg prog_gob  intent_to_treat [pweight=POND0609] if vivin==2 & prog_gob_b!=. & jefeh==1, cluster(proyecto2)
	
************
***Health***
************

*** Sick previous month
    *1-ITT
	reg sick_last_month [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & sick_last_month_b!=., cluster(proyecto2)
	*2-Control Group
	reg sick_last_month [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & sick_last_month_b!=., cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg sick_last_month  intent_to_treat [pweight=POND0609] if vivin==2 & sick_last_month_b!=., cluster(proyecto2)


*** Fungus, parsites, skin infections (last year)
    *1-ITT
	reg sick_last_year [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & sick_last_year_b!=., cluster(proyecto2)
	*2-Control Group
	reg sick_last_year [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & sick_last_year_b!=., cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg sick_last_year  intent_to_treat [pweight=POND0609] if vivin==2 & sick_last_year_b!=., cluster(proyecto2)
	
***************
***Schooling***
*************** 	
	
*** School enrollment (age 5-17)
    *1-ITT
	reg enrolled_school [pweight=POND0609]  if intent_to_treat==1 & vivin==2  & age>=5 & age<18 & enrolled_school_b!=., cluster(proyecto2)
	*2-Control Group
	reg enrolled_school [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & age>=5 & age<18 & enrolled_school_b!=., cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg enrolled_school  intent_to_treat [pweight=POND0609] if vivin==2 & age>=5 & age<18 & enrolled_school_b!=., cluster(proyecto2)

*** Absenteeism previous month (age 5-17)
    *1-ITT
	reg Iabsenteeism [pweight=POND0609]  if intent_to_treat==1 & vivin==2  & age>=5 & age<18 & Iabsenteeism_b!=., cluster(proyecto2)
	*2-Control Group
	reg Iabsenteeism [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & age>=5 & age<18 & Iabsenteeism_b!=., cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg Iabsenteeism  intent_to_treat [pweight=POND0609] if vivin==2 & age>=5 & age<18 & Iabsenteeism_b!=., cluster(proyecto2)	
	
*******************
***Public Safety***
******************* 		
		
*** Burglary (in your house) past 12 months
    *1-ITT
	reg burglary [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & burglary_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg burglary [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & burglary_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg burglary  intent_to_treat [pweight=POND0609] if vivin==2 & burglary_b!=. & jefeh==1, cluster(proyecto2)

*** Vehicle stolen or vandalized (past 12 months)
    *1-ITT
	reg vehicle_theft [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & vehicle_theft_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg vehicle_theft [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & vehicle_theft_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg vehicle_theft  intent_to_treat [pweight=POND0609] if vivin==2 & vehicle_theft_b!=. & jefeh==1, cluster(proyecto2)

*** Feels safe walking in street at night
    *1-ITT
	reg feel_safe [pweight=POND0609]  if intent_to_treat==1 & vivin==2 & feel_safe_b!=. & jefeh==1, cluster(proyecto2)
	*2-Control Group
	reg feel_safe [pweight=POND0609]  if intent_to_treat==0 & vivin==2 & feel_safe_b!=. & jefeh==1, cluster(proyecto2)
    *3-ITT-C (z=1 vs z=0)
	reg feel_safe  intent_to_treat [pweight=POND0609] if vivin==2 & feel_safe_b!=. & jefeh==1, cluster(proyecto2)


********************	
***Business Units***
********************

    use BASE_NEGOCIOS_2006.dta,clear

*** Number of employees (including owner)
    *1-ITT
	reg employees if intent_to_treat==1 & proyecto<=56 & resulfinal==1 , cluster(proyecto)
	*2-Control Group
	reg employees if intent_to_treat==0 & proyecto<=56 & resulfinal==1 , cluster(proyecto)
    *3-ITT-C (z=1 vs z=0)
	reg employees intent_to_treat if proyecto<=56 & resulfinal==1 , cluster(proyecto)

*** Log Sales
    *1-ITT
	reg ln_adj_sales if intent_to_treat==1 & proyecto<=56 & resulfinal==1 , cluster(proyecto)
	*2-Control Group
	reg ln_adj_sales if intent_to_treat==0 & proyecto<=56 & resulfinal==1 , cluster(proyecto)
    *3-ITT-C (z=1 vs z=0)
	reg ln_adj_sales intent_to_treat if proyecto<=56 & resulfinal==1 , cluster(proyecto)

*** Log Expenditures
    *1-ITT
	reg ln_adj_expenditures if intent_to_treat==1 & proyecto<=56 & resulfinal==1 , cluster(proyecto)
	*2-Control Group:
	reg ln_adj_expenditures if intent_to_treat==0 & proyecto<=56 & resulfinal==1 , cluster(proyecto)
    *3-ITT-C (z=1 vs z=0)
	reg ln_adj_expenditures intent_to_treat if proyecto<=56 & resulfinal==1 , cluster(proyecto)

*** Log Profits
   *1-ITT
	reg ln_adj_profits if intent_to_treat==1 & proyecto<=56 & resulfinal==1 , cluster(proyecto)
	*2-Control Group
	reg ln_adj_profits if intent_to_treat==0 & proyecto<=56 & resulfinal==1 , cluster(proyecto)
    *3-ITT-C (z=1 vs z=0)
	reg ln_adj_profits intent_to_treat if proyecto<=56 & resulfinal==1 , cluster(proyecto)



*********
*TABLE A3
*********
	
*Use individual level dataset:	
use "2009_2006_c_reshaped_db1.dta",clear

*****************
***Consumption***
*****************

***Inflation adjusted log per capita expenditures
    gen nr=(adj_ln_pce_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & adj_ln_pce!=.  & jefeh==1, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & adj_ln_pce!=.  & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & adj_ln_pce!=.  & jefeh==1, cluster(proyecto2)
    drop nr

***Inflation adjusted log per capita expenditures SUM
    gen nr=(adj_ln_pc_sumexp_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & adj_ln_pc_sumexp!=.  & jefeh==1, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & adj_ln_pc_sumexp!=.  & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & adj_ln_pc_sumexp!=.  & jefeh==1, cluster(proyecto2)
    drop nr

*** Durables  (0-6 = video player, computer, microwave, fridge, washing machine, AC)
    gen nr=(durable_goods_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & durable_goods!=. & jefeh==1, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & durable_goods!=. & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & durable_goods!=.  & jefeh==1, cluster(proyecto2)
    drop nr

*** Vehicle (0-3 = motorcycle, truck, car )
    gen nr=(index_vehicle_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & index_vehicle!=.  & jefeh==1, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & index_vehicle!=.  & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & index_vehicle!=.  & jefeh==1, cluster(proyecto2)
    drop nr

*** Number of home improvements in the past 6 months
    gen nr=(home_improvements_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & home_improvements!=.  & jefeh==1, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & home_improvements!=.  & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & home_improvements!=.  & jefeh==1, cluster(proyecto2)
    drop nr

*** Bought materials for home improvement in the past 6 months
    gen nr=(material_home_imp_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & material_home_imp!=.  & jefeh==1, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & material_home_imp!=.  & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & material_home_imp!=.  & jefeh==1, cluster(proyecto2)
    drop nr
	
************
***Credit***
************

*** collateral_based_credit
    gen nr=(collateral_based_credit_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & collateral_based_credit!=. & age>=18, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & collateral_based_credit!=. & age>=18, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & collateral_based_credit!=. & age>=18, cluster(proyecto2)
    drop nr

*** Inflation adjusted collateral based credit amount (=0 for individuals who did not use collateral based credit in past year)
    gen nr=(adj_cbc_amount_p_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & adj_cbc_amount_p!=. & age>=18, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & adj_cbc_amount_p!=. & age>=18, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & adj_cbc_amount_p!=. & age>=18, cluster(proyecto2)
    drop nr
	
*** Non collateral_based_credit
    gen nr=(non_collateral_based_credit_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & non_collateral_based_credit!=. & age>=18, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & non_collateral_based_credit!=. & age>=18, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & non_collateral_based_credit!=. & age>=18, cluster(proyecto2)
    drop nr

*** Inflation adjusted non collateral based credit amount (=0 for individuals who did not use collateral based credit in past year)
    gen nr=(adj_non_cbc_amount_p_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & adj_non_cbc_amount_p!=. & age>=18, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & adj_non_cbc_amount_p!=. & age>=18, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & adj_non_cbc_amount_p!=. & age>=18, cluster(proyecto2)
    drop nr	

	
*** Family and friends credit    B10.4
    gen nr=(family_friends_credit_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & family_friends_credit!=. & age>=18, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & family_friends_credit!=. & age>=18, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & family_friends_credit!=. & age>=18, cluster(proyecto2)
    drop nr

*** Informal private credit    B10.3
    gen nr=(informal_private_credit_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & informal_private_credit!=. & age>=18, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & informal_private_credit!=. & age>=18, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & informal_private_credit!=. & age>=18, cluster(proyecto2)
    drop nr
	
	
*** Credit Card    B10
    gen nr=(creditcard_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & creditcard!=.  & jefeh==1, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & creditcard!=.  & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & creditcard!=.  & jefeh==1, cluster(proyecto2)
    drop nr

*** Bank Account    B9
    gen nr=(bankaccount_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & bankaccount!=.  & jefeh==1, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & bankaccount!=.  & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & bankaccount!=.  & jefeh==1, cluster(proyecto2)
    drop nr    	

****************************
***Labor & Transportation***
****************************

	*** Weekly hours worked last week
    gen nr=(weekly_hours_worked_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & weekly_hours_worked!=. & age>=18, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & weekly_hours_worked!=. & age>=18, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & weekly_hours_worked!=. & age>=18, cluster(proyecto2)
    drop nr

***Log Inflation adjusted monthly labor income
    gen nr=(ln_adj_monthly_labor_income_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & ln_adj_monthly_labor_income!=. & age>=18, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & ln_adj_monthly_labor_income!=. & age>=18, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & ln_adj_monthly_labor_income!=. & age>=18, cluster(proyecto2)
    drop nr

*** Someone in household plans to migrate for work reasons
    gen nr=(plan_mig_for_work_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & plan_mig_for_work!=.  & jefeh==1, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & plan_mig_for_work!=.  & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & plan_mig_for_work!=.  & jefeh==1, cluster(proyecto2)
    drop nr 	
	
*** Cost of taxi to city center?
    gen nr=(cost_taxi_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & cost_taxi!=.  & jefeh==1, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & cost_taxi!=.  & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & cost_taxi!=.  & jefeh==1, cluster(proyecto2)
    drop nr

*** Center transport time?
    gen nr=(center_transport_time_b==.)
	reg nr [pweight=POND0609] if intent_to_treat==1 & vivin==2 & center_transport_time!=.  & jefeh==1, cluster(proyecto2)
	reg nr [pweight=POND0609] if intent_to_treat==0 & vivin==2 & center_transport_time!=.  & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & center_transport_time!=.  & jefeh==1, cluster(proyecto2)
    drop nr

*************
***Housing***
*************

    *Use housing level dataset:	
    use "2009_2006_c_reshaped_db2.dta",clear
	
*** Inflation adjusted log value of home (homeowners)
    gen nr=(adj_log_value_home_occ_b==.)
	reg nr[pweight=POND0609]  if intent_to_treat==1 & vivin==2 & adj_log_value_home_occ!=.   & jefeh==1, cluster(proyecto2)
	reg nr[pweight=POND0609]  if intent_to_treat==0 & vivin==2 & adj_log_value_home_occ!=.   & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat[pweight=POND0609]  if vivin==2 & adj_log_value_home_occ!=.  & jefeh==1, cluster(proyecto2)
    drop nr

*** Log Professional Appraisal of House Value
    gen nr=(adj_log_appraised_value_b==.)
	reg nr[pweight=ponder] if intent_to_treat==1 & adj_log_appraised_value!=. & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2)
	reg nr[pweight=ponder] if intent_to_treat==0 & adj_log_appraised_value!=. & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2)
	reg nr intent_to_treat[pweight=ponder] if  adj_log_appraised_value!=. & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2)
    drop nr
	
*** Adjusted Log Professional Appraisal of Land Value
    gen nr=(adj_log_land_value_b==.)
	reg nr [pweight=ponder] if intent_to_treat==1 & adj_log_land_value!=. & jefeh==1 & (VIVIND==1 | VIVIND==98), cluster(proyecto2)
	reg nr [pweight=ponder] if intent_to_treat==0 & adj_log_land_value!=. & jefeh==1 & (VIVIND==1 | VIVIND==98), cluster(proyecto2)
	reg nr intent_to_treat [pweight=ponder] if  adj_log_land_value!=. & jefeh==1 & (VIVIND==1 | VIVIND==98), cluster(proyecto2)
    drop nr

*** Distance to paved road
    gen nr=(cuadras_b==.)
	reg nr  [pweight=POND0609] if intent_to_treat==1 & vivin==2 & cuadras!=.   & jefeh==1, cluster(proyecto2)
	reg nr  [pweight=POND0609] if intent_to_treat==0 & vivin==2 & cuadras!=.   & jefeh==1, cluster(proyecto2)
	reg nr intent_to_treat [pweight=POND0609] if vivin==2 & cuadras!=.   & jefeh==1, cluster(proyecto2)
    drop nr


*********
*TABLE A4
*********	

    *Use housing level dataset:	
    use "2009_2006_c_reshaped_db2.dta",clear

    gen d_cuadras=cuadras_b-cuadras
    rename adj_log_appraised_value_b y1
    rename weekly_hours_worked_b y2
    rename ln_adj_monthly_labor_income_b y3
    rename cost_taxi_b y4
    rename center_transport_time_b y5

    *Col 1:
    reg y1 d_cuadras adj_log_appraised_value [pweight=ponder] if intent_to_treat2==0  & jefeh==1  & (VIVIND==1 | VIVIND==98), robust cluster(proyecto2)
    cgmwildboot y1 d_cuadras adj_log_appraised_value [pweight=ponder] if intent_to_treat2==0  & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2) bootcluster(proyecto2) null(0 .) reps(500) seed(18724)

    *Col 2:
    reg y4 d_cuadras cost_taxi [pweight=ponder] if intent_to_treat2==0  & jefeh==1    , robust cluster(proyecto2)
    cgmwildboot y4 d_cuadras cost_taxi [pweight=ponder] if intent_to_treat2==0  & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2) bootcluster(proyecto2) null(0 .) reps(500) seed(18724)

    *Col 3:
    reg y5 d_cuadras center_transport_time [pweight=ponder] if intent_to_treat2==0  & jefeh==1  , robust cluster(proyecto2)
    cgmwildboot y5 d_cuadras center_transport_time  [pweight=ponder] if intent_to_treat2==0  & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2) bootcluster(proyecto2) null(0 .) reps(500) seed(18724)

    *Col 4:
    reg y2 d_cuadras weekly_hours_worked [pweight=ponder] if intent_to_treat2==0  & jefeh==1     , robust cluster(proyecto2)
    cgmwildboot y2 d_cuadras weekly_hours_worked [pweight=ponder] if intent_to_treat2==0  & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2) bootcluster(proyecto2) null(0 .) reps(500) seed(18724)

    *Col 5:
    reg y3 d_cuadras ln_adj_monthly_labor_income [pweight=ponder] if intent_to_treat2==0  & jefeh==1   , robust cluster(proyecto2)
    cgmwildboot y3 d_cuadras ln_adj_monthly_labor_income [pweight=ponder] if intent_to_treat2==0  & jefeh==1  & (VIVIND==1 | VIVIND==98), cluster(proyecto2) bootcluster(proyecto2) null(0 .) reps(500) seed(18724)
	
	
*********
*TABLE A5
*********


*Use individual level dataset:	
use "2009_2006_c_reshaped_db1.dta",clear

		
**************************	
***Home Characteristics***
**************************	

*** Homeowner vs renter
    *1-ITT
	reg owner_b intent_to_treat2 owner [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls owner_b (paved2=intent_to_treat2) owner  [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg owner_b  [pweight= POND0609] if vivin==2 & owner!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Rooms
    *1-ITT
	reg rooms_b intent_to_treat2 rooms [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls rooms_b (paved2=intent_to_treat2) rooms  [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg rooms_b  [pweight= POND0609] if vivin==2 & rooms!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Sum of cement roof, floor and walls indicators
    *1-ITT
	reg cement_roof_floor_wall_b intent_to_treat2 cement_roof_floor_wall [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls cement_roof_floor_wall_b (paved2=intent_to_treat2) cement_roof_floor_wall  [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg cement_roof_floor_wall_b  [pweight= POND0609] if vivin==2 & cement_roof_floor_wall!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Indoor Toilet
    *1-ITT
	reg bathroom_b intent_to_treat2 bathroom [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls bathroom_b (paved2=intent_to_treat2) bathroom  [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg bathroom_b  [pweight= POND0609] if vivin==2 & bathroom!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Water connection inside the house
    *1-ITT
	reg water_inside_house_b intent_to_treat2 water_inside_house [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls water_inside_house_b (paved2=intent_to_treat2) water_inside_house  [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg water_inside_house_b  [pweight= POND0609] if vivin==2 & water_inside_house!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Water connection
    *1-ITT
	reg water_in_lot_b intent_to_treat2 water_in_lot [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls water_in_lot_b (paved2=intent_to_treat2) water_in_lot  [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg water_in_lot_b  [pweight= POND0609] if vivin==2 & water_in_lot!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Sewerage
    *1-ITT
	reg sewage_b intent_to_treat2 sewage [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls sewage_b (paved2=intent_to_treat2) sewage  [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg sewage_b  [pweight= POND0609] if vivin==2 & sewage!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Electricity
    *1-ITT
	reg electricity_b intent_to_treat2 electricity [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls electricity_b (paved2=intent_to_treat2) electricity  [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg electricity_b  [pweight= POND0609] if vivin==2 & electricity!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Municipality garbage collection service
    *1-ITT
	reg garbage_collection_b intent_to_treat2 garbage_collection [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls garbage_collection_b (paved2=intent_to_treat2) garbage_collection  [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg garbage_collection_b  [pweight= POND0609] if vivin==2 & garbage_collection!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Gas delivery service
    *1-ITT
	reg gas_truck_b intent_to_treat2 gas_truck [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls gas_truck_b (paved2=intent_to_treat2) gas_truck  [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg gas_truck_b  [pweight= POND0609] if vivin==2 & gas_truck!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Clean_street
    *1-ITT
	reg clean_street_b intent_to_treat2 clean_street [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls clean_street_b (paved2=intent_to_treat2) clean_street  [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg clean_street_b  [pweight= POND0609] if vivin==2 & clean_street!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)
	
	
***********	
***Labor***	
***********

    *** Work last week (age>=18)
	*1-ITT
	reg work_b intent_to_treat2 work [pweight=POND0609] if vivin==2 & age>=18, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls work_b (paved2=intent_to_treat2) work  [pweight= POND0609] if vivin==2 & age>=18, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg work_b  [pweight= POND0609] if vivin==2 & work!=. &  intent_to_treat2==0 &  age>=18, cluster(proyecto2)
	
    *** Unemployed
    *1-ITT
	reg unemployed_b intent_to_treat2 unemployed [pweight=POND0609] if vivin==2 & age>=18, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls unemployed_b (paved2=intent_to_treat2) unemployed  [pweight= POND0609] if vivin==2 & age>=18, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg unemployed_b  [pweight= POND0609] if vivin==2 & unemployed!=. &  intent_to_treat2==0 &  age>=18, cluster(proyecto2)
	
	*** Programa de gobierno (Despensas del DIF, apoyo de Liconsa, u otro programa de gobierno (apoyo en especie, descuentos))
    *1-ITT
	reg prog_gob_b intent_to_treat2 prog_gob [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls prog_gob_b (paved2=intent_to_treat2) prog_gob [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg prog_gob_b  [pweight= POND0609] if vivin==2 & prog_gob!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)
	
************	
***Health***	
************	
	
*Individual was sick last month?
    *1-ITT
	reg sick_last_month_b intent_to_treat2 sick_last_month [pweight=POND0609] if vivin==2, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls sick_last_month_b (paved2=intent_to_treat2) sick_last_month  [pweight= POND0609] if vivin==2, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg sick_last_month_b  [pweight= POND0609] if vivin==2 & sick_last_month!=. &  intent_to_treat2==0, cluster(proyecto2)

*Individual was sick last year (Fungus, parasites, skin infection)
    *1-ITT
	reg sick_last_year_b intent_to_treat2 sick_last_year [pweight=POND0609] if vivin==2, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls sick_last_year_b (paved2=intent_to_treat2) sick_last_year  [pweight= POND0609] if vivin==2, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg sick_last_year_b  [pweight= POND0609] if vivin==2 & sick_last_year!=. &  intent_to_treat2==0, cluster(proyecto2)
		
***************	
***Schooling***	
***************		
	
*** School enrollment 5-17
    *1-ITT
	reg enrolled_school_b intent_to_treat2 enrolled_school [pweight=POND0609] if vivin==2 & age>=5 & age<18, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls enrolled_school_b (paved2=intent_to_treat2) enrolled_school  [pweight= POND0609] if vivin==2 & age>=5 & age<18, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg enrolled_school_b  [pweight= POND0609] if vivin==2 & enrolled_school!=. &  intent_to_treat2==0 &  age>=5 &  age<18, cluster(proyecto2)

*** Lost school days last month 5-17
    *1-ITT
	reg Iabsenteeism_b intent_to_treat2 Iabsenteeism [pweight=POND0609] if vivin==2 & age>=5 & age<18, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls Iabsenteeism_b (paved2=intent_to_treat2) Iabsenteeism  [pweight= POND0609] if vivin==2 & age>=5 & age<18, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg Iabsenteeism_b  [pweight= POND0609] if vivin==2 & Iabsenteeism!=. &  intent_to_treat2==0 &  age>=5 &  age<18, cluster(proyecto2)	
		
*******************
***Public Safety***	
*******************		
		
*** Have you suffered a burglary in your house (past 12 months)
    *1-ITT
	reg burglary_b intent_to_treat2 burglary [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls burglary_b (paved2=intent_to_treat2) burglary [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg burglary_b  [pweight= POND0609] if vivin==2 & burglary!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Vehicle stolen vandalized (past 12 months)
    *1-ITT
	reg vehicle_theft_b intent_to_treat2 vehicle_theft [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls vehicle_theft_b (paved2=intent_to_treat2) vehicle_theft [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg vehicle_theft_b  [pweight= POND0609] if vivin==2 & vehicle_theft!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)

*** Do you feel safe walking in your street at night?
    *1-ITT
	reg feel_safe_b intent_to_treat2 feel_safe [pweight=POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
	*2-2SLS
	ivregress 2sls feel_safe_b (paved2=intent_to_treat2) feel_safe [pweight= POND0609] if vivin==2 & jefeh==1, robust cluster(proyecto2)
    *3- Mean for control group in 2009 (intent_to_treat2==0)
    reg feel_safe_b  [pweight= POND0609] if vivin==2 & feel_safe!=. &  intent_to_treat2==0 & jefeh==1, cluster(proyecto2)	
		
********************
***Business Units***	
********************		

    use "BASE_NEGOCIOS_2009.dta",clear

***Employees
    *ITT
    reg employees intent_to_treat if proyecto<=56 & resulfinal==1 , cluster(proyecto)
    *2SLS
    ivregress 2sls employees (paved=intent_to_treat) if proyecto<=56 & resulfinal==1 , cluster(proyecto)
    *mean
    reg employees if intent_to_treat==0 & proyecto<=56 & resulfinal==1 , cluster(proyecto)

***Log Sales
    *ITT
    reg ln_sales intent_to_treat if proyecto<=56 & resulfinal==1 , cluster(proyecto)
    *2SLS
    ivregress 2sls ln_sales (paved=intent_to_treat) if proyecto<=56 & resulfinal==1 , cluster(proyecto)
    *mean
    reg ln_sales if intent_to_treat==0 & proyecto<=56 & resulfinal==1 , cluster(proyecto)

***Log Expenditures
    *ITT
    reg ln_expenditures intent_to_treat if proyecto<=56 & resulfinal==1 , cluster(proyecto)
    *2SLS
    ivregress 2sls ln_expenditures (paved=intent_to_treat) if proyecto<=56 & resulfinal==1 , cluster(proyecto)
    *mean
    reg ln_expenditures if intent_to_treat==0 & proyecto<=56 & resulfinal==1 , cluster(proyecto)

***Log Profits
    *ITT
    reg ln_profits intent_to_treat if proyecto<=56 & resulfinal==1 , cluster(proyecto)
    *2SLS
    ivregress 2sls ln_profits (paved=intent_to_treat) if proyecto<=56 & resulfinal==1 , cluster(proyecto)
    *mean
    reg ln_profits if intent_to_treat==0 & proyecto<=56 & resulfinal==1 , cluster(proyecto)
	
********************************************************************************
********************************************************************************
********************************************************************************
