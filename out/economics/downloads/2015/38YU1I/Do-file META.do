* Sets working dirictory


set more off

*************************************
* databearbeting och variabelgenerering
*************************************

* 1. rensa bort trams

 sum *
 drop y0
 
 destring feestimation , replace force
 sum feestimation

 
 
* 2 gen absolute value of t-values

 gen tvalabs = abs(tval)
 label var tvalabs         "abs(tval)"



* DGF
label var dgf "degrees of freedom"
 gen sqrt_dgf = sqrt(dgf)
 gen ln_sqrt_dgf = ln(sqrt_dgf)


 
 
 * LHS TFP/OUTPUT GROWTH vs. TFP/OUTPUT LEVEL
 
 gen      growth = 0
 replace  growth = 1 if y_growth == 1  | tfp_growth == 1
 sum growth
 



* Fix som gör att obs när stdv = 0 behålls

 replace stdv = 0.0000001 if stdv == 0

*France fel kod pŒ vissa, 9 ist fšr 3.
replace country_number=3 if country=="France" 

*************************************
 ** Fixa några EU-dummies
*************************************
* 9 st EU15-lŠnder med i data set
gen eu15=0
replace eu15=1 if country_number== 2| country_number== 3| country_number== 4| country_number==5| country_number==6| country_number==7| country_number==9| country_number==10| country_number==19
* 11 st EU15-lŠnder med i data set
gen eu27=0
replace eu27=1 if country_number== 2| country_number== 3| country_number== 4| country_number==5| country_number==6| country_number==7| country_number==9| country_number==10| country_number==19| country_number==20| country_number==22

gen eu_highFoU=0
replace eu_highFoU=1 if country_number==2 |country_number==3 |country_number==7 |country_number==9 |country_number==10 |country_number==19 |country_number==22

gen eu_lowFoU=0
replace eu_lowFoU=1 if country_number== 4 |country_number== 5 |country_number== 6 |country_number== 20

 
 
 *************************************
 ** VÄGNING AV VARS
*************************************



 gen i_study_nr  	= study_nr/stdv 
 gen i_obs_per_study  	= obs_per_study/stdv
 gen i_aggregated_data  = aggregated_data/stdv
 gen i_ind_data  	= ind_data/stdv             
 gen i_firm_data  	= firm_data/stdv     
 gen i_country_number 	= country_number/stdv
 gen i_ind_country 	= ind_country/stdv   
 gen i_dev_country  	= dev_country/stdv  
 gen i_transition_country = transition_country/stdv              
 gen i_non_rd_inno 	= non_rd_inno/stdv    
 gen i_capital  	= capital/stdv        
 gen i_human_cap  	= human_cap/stdv    
 gen i_openess  	= openess /stdv     
 gen i_pop_growth  	= pop_growth/stdv   
 gen i_feestimation 	= feestimation/stdv  
 gen i_dgf   		= dgf/stdv         
 gen i_no_years    	= no_years/stdv    
 gen i_per60s  		= per60s/stdv       
 gen i_per70s  		= per70s/stdv        
 gen i_per80s  		= per80s/stdv       
 gen i_per90s   	= per90s/stdv       
 gen i_per00s   	= per00s/stdv       
 gen i_bcoef   		= bcoef/stdv        
 
 gen i_ln_sqrt_dgf   	= ln_sqrt_dgf /stdv 
 gen i_growth    	= growth /stdv      

gen i_stdv   		= 1/stdv   

gen i_eu15  =    eu15/stdv
gen i_eu27 = eu27/stdv
gen i_eu_highFoU = eu_highFoU/stdv
gen i_eu_lowFoU =eu_lowFoU/stdv




*************************************
* Analys EU15
*************************************

*** DESC *********

* D1
 sort eu15
 by eu15: sum tval , det

* t-val by growth dum and eu15 - non-eu15 
sum tval 	if 				   				  eu15 == 1 & growth == 1
count    	if 				   				  eu15 == 1 & growth == 1
count 		if 	tval < -1.65 			    & eu15 == 1 & growth == 1
count 		if	tval >  1.65 			    & eu15 == 1 & growth == 1
count 		if  tval <  1.65 & tval > -1.65 & eu15== 1 & growth == 1

 sum tval   if eu15 == 0 & growth == 1
count    	if 				   				  eu15 == 0 & growth == 1
count 		if 	tval < -1.65 			    & eu15 == 0 & growth == 1
count 		if	tval >  1.65 			    & eu15 == 0 & growth == 1
count 		if  tval <  1.65 & tval > -1.65 & eu15 == 0 & growth == 1

  sum tval if eu15 == 1 & growth == 0
count    	if 				   				  eu15 == 1 & growth == 0
count 		if 	tval < -1.65 			    & eu15 == 1 & growth == 0
count 		if	tval >  1.65 			    & eu15 == 1 & growth == 0
count 		if  tval <  1.65 & tval > -1.65 & eu15 == 1 & growth == 0
 
 sum tval if eu15 == 0 & growth == 0
count    	if 				   				  eu15 == 0 & growth == 0
count 		if 	tval < -1.65 			    & eu15 == 0 & growth == 0
count 		if	tval >  1.65 			    & eu15 == 0 & growth == 0
count 		if  tval <  1.65 & tval > -1.65 & eu15 == 0 & growth == 0


* New

sum tval
count if tval < -1.65 
count if tval >  1.65 
count if tval <  1.65 & tval > -1.65 


sum tval if eu15 == 0

count if tval < -1.65 & eu15 == 0
count if tval >  1.65 & eu15 == 0
count if tval <  1.65 & tval > -1.65 & eu15 == 0

sum tval if eu15 == 1
count if eu15 == 1
count if tval < -1.65 & eu15 == 1
count if tval >  1.65 & eu15 == 1
count if tval <  1.65 & tval > -1.65 & eu15 == 1



*************************************
* Analysis EU27
*************************************

*** DESC *********

* D1
 sort eu27
 by eu27: sum tval , det

* t-val by growth dum and eu27 - non-eu27 
sum tval 	if 				   				  eu27 == 1 & growth == 1
count    	if 				   				  eu27 == 1 & growth == 1
count 		if 	tval < -1.65 			    & eu27 == 1 & growth == 1
count 		if	tval >  1.65 			    & eu27 == 1 & growth == 1
count 		if  tval <  1.65 & tval > -1.65 & eu27== 1 & growth == 1

 sum tval   if eu27 == 0 & growth == 1
count    	if 				   				  eu27== 0 & growth == 1
count 		if 	tval < -1.65 			    & eu27 == 0 & growth == 1
count 		if	tval >  1.65 			    & eu27 == 0 & growth == 1
count 		if  tval <  1.65 & tval > -1.65 & eu27== 0 & growth == 1

  sum tval if eu27== 1 & growth == 0
count    	if 				   				  eu27 == 1 & growth == 0
count 		if 	tval < -1.65 			    & eu27 == 1 & growth == 0
count 		if	tval >  1.65 			    & eu27 == 1 & growth == 0
count 		if  tval <  1.65 & tval > -1.65 & eu27 == 1 & growth == 0
 
 sum tval if eu27 == 0 & growth == 0
count    	if 				   				  eu27== 0 & growth == 0
count 		if 	tval < -1.65 			    & eu27 == 0 & growth == 0
count 		if	tval >  1.65 			    & eu27== 0 & growth == 0
count 		if  tval <  1.65 & tval > -1.65 & eu27 == 0 & growth == 0


* New

sum tval
count if tval < -1.65 
count if tval >  1.65 
count if tval <  1.65 & tval > -1.65 


sum tval if eu27 == 0

count if tval < -1.65 & eu27 == 0
count if tval >  1.65 & eu27 == 0
count if tval <  1.65 & tval > -1.65 & eu27 == 0

sum tval if eu27== 1
count if eu27 == 1
count if tval < -1.65 & eu27== 1
count if tval >  1.65 & eu27 == 1
count if tval <  1.65 & tval > -1.65 & eu27 == 1


*************************************
* Analysis EU High R&D intensity
*************************************

*** DESC *********

* D1
 sort eu_highFoU
 by eu_highFoU: sum tval , det

* t-val by growth dum and eu_highFoU - non-eu_highFoU 
sum tval 	if 				   				  eu_highFoU== 1 & growth == 1
count    	if 				   				  eu_highFoU == 1 & growth == 1
count 		if 	tval < -1.65 			    & eu_highFoU == 1 & growth == 1
count 		if	tval >  1.65 			    & eu_highFoU == 1 & growth == 1
count 		if  tval <  1.65 & tval > -1.65 & eu_highFoU== 1 & growth == 1

 sum tval   if eu_highFoU == 0 & growth == 1
count    	if 				   				  eu_highFoU== 0 & growth == 1
count 		if 	tval < -1.65 			    & eu_highFoU == 0 & growth == 1
count 		if	tval >  1.65 			    & eu_highFoU == 0 & growth == 1
count 		if  tval <  1.65 & tval > -1.65 & eu_highFoU== 0 & growth == 1

  sum tval if eu_highFoU== 1 & growth == 0
count    	if 				   				  eu_highFoU == 1 & growth == 0
count 		if 	tval < -1.65 			    & eu_highFoU == 1 & growth == 0
count 		if	tval >  1.65 			    & eu_highFoU == 1 & growth == 0
count 		if  tval <  1.65 & tval > -1.65 & eu_highFoU == 1 & growth == 0
 
 sum tval if eu_highFoU == 0 & growth == 0
count    	if 				   				  eu_highFoU== 0 & growth == 0
count 		if 	tval < -1.65 			    & eu_highFoU== 0 & growth == 0
count 		if	tval >  1.65 			    & eu_highFoU== 0 & growth == 0
count 		if  tval <  1.65 & tval > -1.65 & eu_highFoU== 0 & growth == 0


* New

sum tval
count if tval < -1.65 
count if tval >  1.65 
count if tval <  1.65 & tval > -1.65 


sum tval if eu_highFoU == 0

count if tval < -1.65 & eu_highFoU == 0
count if tval >  1.65 & eu_highFoU == 0
count if tval <  1.65 & tval > -1.65 & eu_highFoU == 0

sum tval if eu_highFoU== 1
count if eu_highFoU == 1
count if tval < -1.65 & eu_highFoU== 1
count if tval >  1.65 & eu_highFoU == 1
count if tval <  1.65 & tval > -1.65 & eu_highFoU == 1


*************************************
* Analysis EU Low R&D intensity
*************************************

*** DESC *********

* D1
 sort eu_lowFoU
 by eu_lowFoU: sum tval , det

* t-val by growth dum and eu_lowFoU - non-eu_lowFoU 
sum tval 	if 				   				  eu_lowFoU== 1 & growth == 1
count    	if 				   				  eu_lowFoU== 1 & growth == 1
count 		if 	tval < -1.65 			    & eu_lowFoU == 1 & growth == 1
count 		if	tval >  1.65 			    & eu_lowFoU == 1 & growth == 1
count 		if  tval <  1.65 & tval > -1.65 & eu_lowFoU== 1 & growth == 1

 sum tval   if eu_lowFoU == 0 & growth == 1
count    	if 				   				  eu_lowFoU== 0 & growth == 1
count 		if 	tval < -1.65 			    & eu_lowFoU == 0 & growth == 1
count 		if	tval >  1.65 			    & eu_lowFoU == 0 & growth == 1
count 		if  tval <  1.65 & tval > -1.65 & eu_lowFoU== 0 & growth == 1

  sum tval if eu_lowFoU== 1 & growth == 0
count    	if 				   				  eu_lowFoU == 1 & growth == 0
count 		if 	tval < -1.65 			    & eu_lowFoU == 1 & growth == 0
count 		if	tval >  1.65 			    & eu_lowFoU == 1 & growth == 0
count 		if  tval <  1.65 & tval > -1.65 & eu_lowFoU == 1 & growth == 0
 
 sum tval if eu_lowFoU == 0 & growth == 0
count    	if 				   				  eu_lowFoU== 0 & growth == 0
count 		if 	tval < -1.65 			    & eu_lowFoU== 0 & growth == 0
count 		if	tval >  1.65 			    & eu_lowFoU== 0 & growth == 0
count 		if  tval <  1.65 & tval > -1.65 & eu_lowFoU== 0 & growth == 0


* New

sum tval
count if tval < -1.65 
count if tval >  1.65 
count if tval <  1.65 & tval > -1.65 


sum tval if eu_lowFoU == 0

count if tval < -1.65 & eu_lowFoU== 0
count if tval >  1.65 & eu_lowFoU == 0
count if tval <  1.65 & tval > -1.65 & eu_lowFoU == 0

sum tval if eu_lowFoU== 1
count if eu_lowFoU == 1
count if tval < -1.65 & eu_lowFoU== 1
count if tval >  1.65 & eu_lowFoU == 1
count if tval <  1.65 & tval > -1.65 & eu_lowFoU == 1

***********************************
*Generate new variables
***********************************

*USA dummy for last two models (model 6 & 7)
 
gen usa=0
replace usa=1 if country_abbr =="US"
gen i_usa= usa/stdv
 
 *Residual_ind dummy
 gen residual_ind=0
 replace residual_ind=1 if country_abbr=="KR"
 gen i_residual_ind=residual_ind/stdv
 
 *Winsorized tval
 gen tval_win=tval
 replace tval_win=12 if tval>12
 
 
* Description
 sum tval if eu15==1
 sum tval if eu27==1
 sum tval if ind_country ==1
 sum tval if usa ==1
 
******************TABLE 1******************************************

*EU15 models

* 1
reg      tval i_eu15, robust

*2
reg      tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s , robust   /* FIRM-level-data = referens */

*3
reg      tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country i_dev_country  , robust   /* Ind countries & FIRM-level-data = referens */

*4
xtmixed  tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country i_dev_country || country_abbr: || study_nr:  , iterate(20) 

*5
xtmixed  tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country  i_dev_country  || _all: R.country_abbr || _all: R.study_nr   , iterate(20) 

* USA and residual_ind dummy
*6
xtmixed  tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country i_dev_country  i_usa i_residual_ind || country_abbr: || study_nr:  , iterate(20) 

*7
xtmixed  tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country i_dev_country  i_usa i_residual_ind || _all: R.country_abbr || _all: R.study_nr   , iterate(20) 

*Test EU and USA
test i_eu15=i_usa

*****************TABLE 2****************************************

* EU high and low R&D (FoU) 

*1
reg      tval i_eu_highFoU i_eu_lowFoU i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s , robust   /* FIRM-level-data = referens */

*2 reg with country dummy
reg      tval i_eu_highFoU i_eu_lowFoU i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country i_dev_country  , robust   /* Ind countries & FIRM-level-data = referens */

*3 Non-nested
xtmixed  tval i_eu_highFoU i_eu_lowFoU i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s  || _all: R.country_abbr || _all: R.study_nr   , iterate(20) 

*4 Non-nested with country dummy
xtmixed  tval i_eu_highFoU i_eu_lowFoU i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country  i_dev_country  || _all: R.country_abbr || _all: R.study_nr   , iterate(20) 


*******************TABLE 3****************************************

*Sensitivity tests, rreg, qreg, tval_win

*Model 2
*1 robust regression
rreg     tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s   /* Ind countries & FIRM-level-data = referens */

*2 quantile regression
qreg     tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s /* Ind countries & FIRM-level-data = referens */

*3 regression tval_win
reg tval_win  i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s , robust   /* Ind countries & FIRM-level-data = referens */

*4 cluster country
reg      tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s , cluster(country_abbr)   /* Ind countries & FIRM-level-data = referens */

*5 cluster study
reg      tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s  , cluster(study_nr)   /* Ind countries & FIRM-level-data = referens */


*Model 3
*1 robust regression
rreg     tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country i_dev_country   /* Ind countries & FIRM-level-data = referens */

*2 quantile regression
qreg     tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country i_dev_country   /* Ind countries & FIRM-level-data = referens */

*3 regression tval_win
reg tval_win  i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country i_dev_country  , robust   /* Ind countries & FIRM-level-data = referens */

*4 cluster country
reg      tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country i_dev_country  , cluster(country_abbr)   /* Ind countries & FIRM-level-data = referens */

*5 cluster study
reg      tval i_eu15 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country i_dev_country  , cluster(study_nr)   /* Ind countries & FIRM-level-data = referens */

*****************NO TABLE, just write in text*********************************

*EU27 

* 1
reg      tval i_eu27, robust

*2
reg      tval i_eu27 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s , robust   /* FIRM-level-data = referens */

*3
reg      tval i_eu27 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country i_dev_country  , robust   /* Ind countries & FIRM-level-data = referens */

*4
xtmixed  tval i_eu27 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country i_dev_country || country_abbr: || study_nr:  , iterate(20) 

*5
xtmixed  tval i_eu27 i_ln_sqrt_dgf i_aggregated_data  i_ind_data  i_capital i_human_cap i_pop_growth i_growth  i_per60s i_per70s i_per80s i_per90s i_per00s i_transition_country  i_dev_country  || _all: R.country_abbr || _all: R.study_nr   , iterate(20) 


*********END***********************
