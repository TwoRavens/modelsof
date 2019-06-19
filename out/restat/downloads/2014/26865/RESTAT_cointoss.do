**merge file

use "C:\Users\fujitsu\Dropbox\Public\coin toss\thai_data.dta", clear
 
gen nation = 0
renpfix predict decision
renpfix decisionion prediction
keep uni id nation decision* perfect_* pmatc* prop_prob sex endow* econ wrong* outcome* head* tail* prediction*
gen missing_prob=0


gen streak_outcome2 = 0
replace streak_outcome2 = 1 if (outcome1=="H" & outcome2=="H") 
replace streak_outcome2 = 2 if (outcome1=="T" & outcome2=="T")

**gen betting after streakc

gen reverse_buying3 = 0
replace reverse_buying3 = 1 if  (outcome1=="H" & outcome2=="H") & tail3>0  
replace reverse_buying3 = 1 if   (outcome1=="T" & outcome2=="T") & head3>0  
  

gen streak_outcome3 = 0
replace streak_outcome3 = 1 if (outcome1=="H" & outcome2=="H" & outcome3=="H") 
replace streak_outcome3 = 2 if (outcome1=="T" & outcome2=="T" & outcome3=="T")

gen reverse_buying4 = 0
replace reverse_buying4 = 1 if   (outcome1=="H" & outcome2=="H" & outcome3=="H") & tail4>0  
replace reverse_buying4 = 1 if  (outcome1=="T" & outcome2=="T" & outcome3=="T") & head4>0  
  

gen streak_outcome4 = 0
replace streak_outcome4 = 1 if (outcome1=="H" & outcome2=="H" & outcome3=="H" & outcome4=="H") 
replace streak_outcome4 = 2 if (outcome1=="T" & outcome2=="T" & outcome3=="T" & outcome4=="T")

gen reverse_buying5 = 0
replace reverse_buying5 = 1 if  (outcome1=="H" & outcome2=="H" & outcome3=="H" & outcome4=="H") & tail5>0  
replace reverse_buying5 = 1 if  (outcome1=="T" & outcome2=="T" & outcome3=="T" & outcome4=="T") & head5>0  
  
  
  
save "C:\Users\fujitsu\Dropbox\Public\coin toss\merge_con_thai.dta", replace

use "C:\Users\fujitsu\Dropbox\Public\coin toss\singapore_data.dta", clear
 
gen nation = 1
ren gender sex
gen econ=0
keep id nation decision* perfect_* pmatc* prop_prob sex endow* missing_prob econ wrong* coin* bet* predict*

 gen streak_outcome2 = 0
replace streak_outcome2 = 1 if (coin1==1 & coin2==1) 
replace streak_outcome2 = 2 if (coin1==0 & coin2==0) 

gen reverse_buying3 = 0
replace reverse_buying3 = 1 if  (coin1==1 & coin2==1) & bet3==0  
replace reverse_buying3 = 1 if  (coin1==0 & coin2==0) & bet3==1 
  

gen streak_outcome3 = 0
replace streak_outcome3 = 1 if (coin1==1 & coin2==1 & coin3==1) 
replace streak_outcome3 = 2 if (coin1==0 & coin2==0 & coin3==0)

gen reverse_buying4 = 0
replace reverse_buying4 = 1 if  (coin1==1 & coin2==1 & coin3==1) & bet4==0  
replace reverse_buying4 = 1 if  (coin1==0 & coin2==0 & coin3==0) & bet4==1  
  

gen streak_outcome4 = 0
replace streak_outcome4 = 1 if (coin1==1 & coin2==1 & coin3==1 & coin4==1) 
replace streak_outcome4 = 2 if (coin1==0 & coin2==0 & coin3==0 & coin4==0)

gen reverse_buying5 = 0
replace reverse_buying5 = 1 if  (coin1==1 & coin2==1 & coin3==1 & coin4==1) & bet5==0  
replace reverse_buying5 = 1 if  (coin1==0 & coin2==0 & coin3==0 & coin4==0) & bet5==1  
  


save "C:\Users\fujitsu\Dropbox\Public\coin toss\merge_con_sg.dta", replace

append using "C:\Users\fujitsu\Dropbox\Public\coin toss\merge_con_thai.dta"


gen gender = 0 if sex=="Female" | sex=="female"
replace gender = 1 if sex=="Male" | sex=="male"

**How much did the individual bet in the previous round


replace endowment0 = 100 if nation==0
gen betamount_1 = (endowment1-endowment0)/2 if endowment1>endowment0   
replace betamount_1 = (endowment0-endowment1) if endowment0>endowment1 

gen betamount_2 = (endowment2-endowment1)/2 if endowment2>endowment1   
replace betamount_2 = (endowment1-endowment2) if endowment1>endowment2 

gen betamount_3 = (endowment3-endowment2)/2 if endowment3>endowment2   
replace betamount_3 = (endowment2-endowment3) if endowment2>endowment3 

gen betamount_4 = (endowment4-endowment3)/2 if endowment4>endowment3   
replace betamount_4 = (endowment3-endowment4) if endowment3>endowment4 

gen betamount_5 = (endowment5-endowment4)/2 if endowment5>endowment4   
replace betamount_5 = (endowment4-endowment5) if endowment4>endowment5 


**Generate more categories of perfect match in each session**

gen cat_match_2 = perfect_match2
replace cat_match_2 = 2 if (pmatch1==0 & pmatch2==0)

gen cat_match_3 = perfect_match3
replace cat_match_3 = 2 if (pmatch1==0 & pmatch2==0 & pmatch3==0)

gen cat_match_4 = perfect_match4
replace cat_match_4 = 2 if (pmatch1==0 & pmatch2==0 & pmatch3==0 & pmatch4==0)

gen cat_match_5 = perfect_match5
replace cat_match_5 = 2 if (pmatch1==0 & pmatch2==0 & pmatch3==0 & pmatch4==0 & pmatch5==0)


**gen bettingcoin**

gen bettingcoin3 = bet3
replace bettingcoin3 = 0 if tail3>0 & bettingcoin3==.
replace bettingcoin3 = 1 if head3>0 & bettingcoin3==.


gen bettingcoin4 = bet4
replace bettingcoin4 = 0 if tail4>0 & bettingcoin4==.
replace bettingcoin4 = 1 if head4>0 & bettingcoin4==.

gen bettingcoin5 = bet5
replace bettingcoin5 = 0 if tail5>0 & bettingcoin5==.
replace bettingcoin5 = 1 if head5>0 & bettingcoin5==.

**generate one betting strategy

replace bet1 = 0 if tail1>0 & tail1~=.
replace bet1 = 1 if head1>0 & head1~=.

replace bet2 = 0 if tail2>0 & tail2~=.
replace bet2 = 1 if head2>0 & head2~=.

replace bet3 = 0 if tail3>0 & tail3~=.
replace bet3 = 1 if head3>0 & head3~=.

replace bet4 = 0 if tail4>0 & tail4~=.
replace bet4 = 1 if head4>0 & head4~=.

replace bet5 = 0 if tail5>0 & tail5~=.
replace bet5 = 1 if head5>0 & head5~=.

gen avg_betcoin = (bet1+bet2+bet3+bet4+bet5)/5
gen fx_bet_strategy = 0
replace fx_bet_strategy = 1 if avg_betcoin == 0
replace fx_bet_strategy = 1 if avg_betcoin == 1


**replace predict variables

replace predict1 = 0 if prediction1=="T" & predict1==.
replace predict1 = 1 if prediction1=="H"

replace predict2 = 0 if prediction2=="T"
replace predict2 = 1 if prediction2=="H"

replace predict3 = 0 if prediction3=="T"
replace predict3 = 1 if prediction3=="H"

replace predict4 = 0 if prediction4=="T"
replace predict4 = 1 if prediction4=="H"

replace predict5 = 0 if prediction5=="T"
replace predict5 = 1 if prediction5=="H"


**generate streaks of predictions

gen streak_predict2 = 0
replace streak_predict2 = 1 if (predict1==1 & predict2==1) 
replace streak_predict2 = 2 if (predict1==0 & predict2==0)

lab define streak_predict 1 "all Heads" 2 "all Tails"
lab value streak_predict2 streak_predict

gen streak_predict3 = 0
replace streak_predict3 = 1 if (predict1==1 & predict2==1 & predict3==1) 
replace streak_predict3 = 2 if (predict1==0 & predict2==0 & predict3==0)


gen streak_predict4 = 0
replace streak_predict4 = 1 if (predict1==1 & predict2==1 & predict3==1 & predict4==1) 
replace streak_predict4 = 2 if (predict1==0 & predict2==0 & predict3==0 & predict4==0)

**Did people bet the same as the envelope?

gen same_as_env1 = 0 if bet1!=predict1
replace same_as_env1 = 1 if bet1==predict1

gen same_as_env2 = 0 if bet2!=predict2
replace same_as_env2 = 1 if bet2==predict2

gen same_as_env3 = 0 if bet3!=predict3
replace same_as_env3 = 1 if bet3==predict3

gen same_as_env4 = 0 if bet4!=predict4
replace same_as_env4 = 1 if bet4==predict4

gen same_as_env5 = 0 if bet5!=predict5
replace same_as_env5 = 1 if bet5==predict5

**Tabulate

tab same_as_env1 if decision1==1
tab same_as_env2 if decision2==1
tab same_as_env3 if decision3==1
tab same_as_env4 if decision4==1
tab same_as_env5 if decision5==1

**excluding round 1 buyers
tab same_as_env2 if decision2==1 & decision1==0
tab same_as_env3 if decision3==1 & decision1==0
tab same_as_env4 if decision4==1 & decision1==0
tab same_as_env5 if decision5==1 & decision1==0


save "C:\Users\fujitsu\Dropbox\Public\coin toss\merge_con_both.dta", replace
 
  
 
log using "C:\Users\fujitsu\Dropbox\Public\coin toss\new_tables_no1st.log", replace
  
 
**Table 1: Do people exhibit gambler's fallacy?

xi:dprobit bettingcoin3 i.streak_outcome2   i.gender nation  if decision1==0 , robust 

outreg2 using "d:\cointoss_restat\gambler_fallacy_no1st_9.10.13.xls", se  bracket  nolabel    10pct  replace

xi:dprobit bettingcoin3 i.streak_outcome2*decision3  i.decision3 i.gender nation  if predict3==1 &  decision1==0 , robust

outreg2 using "d:\cointoss_restat\gambler_fallacy_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append

lincom decision3 +  _IstrXdecis_1
lincom decision3 +  _IstrXdecis_2

xi:dprobit bettingcoin3 i.streak_outcome2*decision3   i.gender nation if predict3==0 &  decision1==0 , robust  
   
outreg2 using "d:\cointoss_restat\gambler_fallacy_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append

lincom decision3 +  _IstrXdecis_1
lincom decision3 +  _IstrXdecis_2

   
xi:dprobit bettingcoin4 i.streak_outcome3  , robust 

outreg2 using "d:\cointoss_restat\gambler_fallacy_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append

xi:dprobit bettingcoin4 i.streak_outcome3*decision4   i.gender nation  if predict4==1 &  decision1==0 , robust

outreg2 using "d:\cointoss_restat\gambler_fallacy_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append

lincom decision4 +  _IstrXdecis_1
lincom decision4 +  _IstrXdecis_2


xi:dprobit bettingcoin4 i.streak_outcome3*decision4   i.gender nation  if predict4==0 &  decision1==0 , robust  
   
outreg2 using "d:\cointoss_restat\gambler_fallacy_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append
 

lincom decision4 +  _IstrXdecis_1
lincom decision4 +  _IstrXdecis_2 
 



**Buying decision

tab perfect_match1  , su(decision2)  
tab cat_match_2  , su(decision3)
tab cat_match_3  , su(decision4)
tab cat_match_4  , su(decision5)

tab perfect_match1 if decision1==0, su(decision2)  
tab cat_match_2 if decision1==0, su(decision3)
tab cat_match_3 if decision1==0, su(decision4)
tab cat_match_4 if decision1==0, su(decision5)


tab perfect_match1 if nation==0 , su(decision2)  
tab cat_match_2 if nation==0 , su(decision3)
tab cat_match_3 if nation==0 , su(decision4)
tab cat_match_4 if nation==0 , su(decision5)

tab perfect_match1 if nation==1 , su(decision2)  
tab cat_match_2 if nation==1 , su(decision3)
tab cat_match_3 if nation==1 , su(decision4)
tab cat_match_4 if nation==1 , su(decision5)

**Table 2: People’s buying decision - without controls

xi:dprobit decision2 i.perfect_match1 if decision1==0 , robust  

outreg2 using "d:\cointoss_restat\buying_table_no1st_9.10.13.xls", se  bracket  nolabel    10pct  replace

xi:dprobit decision3 i.cat_match_2 decision2 if  decision1==0 , robust  

outreg2 using "d:\cointoss_restat\buying_table_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append

xi:dprobit decision4 i.cat_match_3 decision3 if  decision1==0 , robust  

outreg2 using "d:\cointoss_restat\buying_table_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append

xi:dprobit decision5 i.cat_match_4 decision4 if  decision1==0 , robust  

outreg2 using "d:\cointoss_restat\buying_table_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append


**Table 2: with controls

xi:dprobit decision2 i.perfect_match1  prop_prob missing_prob i.gender endowment2 /*
*/ fx_bet_strategy i.same_as_env1*decision1 nation i.wrong_bet1*decision1 if  decision1==0  , robust

outreg2 using "d:\cointoss_restat\buying_table_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append


xi:dprobit decision3 i.cat_match_2  i.streak_outcome2  prop_prob missing_prob i.gender fx_bet_strategy endowment3 /*
*/  nation i.same_as_env2*decision2 i.wrong_bet2*decision2 if  decision1==0  , robust


outreg2 using "d:\cointoss_restat\buying_table_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append

xi:dprobit decision4 i.cat_match_3  i.streak_outcome3   prop_prob missing_prob i.gender fx_bet_strategy /*
*/ i.same_as_env3*decision3 endowment4  nation i.wrong_bet3*decision3 if  decision1==0  , robust


outreg2 using "d:\cointoss_restat\buying_table_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append


xi:dprobit decision5 i.cat_match_4  i.streak_outcome4  prop_prob missing_prob i.gender fx_bet_strategy /*
*/ i.same_as_env4*decision4 endowment5  nation i.wrong_bet4*decision4 if  decision1==0  , robust

outreg2 using "d:\cointoss_restat\buying_table_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append
 


**Table 3: Did people buy and follow the prediction?
  
xi:dprobit same_as_env2 i.perfect_match1*decision2 prop_prob missing_prob i.gender endowment2  fx_bet_strategy /*
*/ i.same_as_env1*decision1 nation i.wrong_bet1*decision1 if  decision1==0  , robust

outreg2 using "d:\cointoss_restat\followed_prediction_9.10.13.xls", se  bracket  nolabel    10pct  replace

lincom decision2 +   _IperXdecis_1

xi:dprobit same_as_env3 i.cat_match_2*decision3 i.streak_outcome2  prop_prob missing_prob i.gender endowment3 /*
*/ i.same_as_env2*decision2 fx_bet_strategy nation i.wrong_bet2*decision2 if  decision1==0  , robust

outreg2 using "d:\cointoss_restat\followed_prediction_9.10.13.xls", se  bracket  nolabel    10pct  append

lincom decision3 +    _IcatXdecis_1
lincom decision3 +    _IcatXdecis_2

xi:dprobit same_as_env4 i.cat_match_3*decision4 i.streak_outcome3   prop_prob missing_prob i.gender endowment4 /*
*/ i.same_as_env3*decision3 fx_bet_strategy nation i.wrong_bet3*decision3 if  decision1==0  , robust

outreg2 using "d:\cointoss_restat\followed_prediction_9.10.13.xls", se  bracket  nolabel    10pct  append

lincom decision4 +    _IcatXdecis_1
lincom decision4 +    _IcatXdecis_2

xi:dprobit same_as_env5 i.cat_match_4*decision5 i.streak_outcome4  prop_prob missing_prob i.gender endowment5 /*
*/ i.same_as_env4*decision4 fx_bet_strategy nation i.wrong_bet4*decision4 if  decision1==0  , robust

outreg2 using "d:\cointoss_restat\followed_prediction_9.10.13.xls", se  bracket  nolabel    10pct  append

lincom decision5 +   _IcatXdecis_1
lincom decision5 +   _IcatXdecis_2



**Table 4: Gamblers fallacy

xi:dprobit bettingcoin3 i.streak_outcome2 i.gender nation  if decision1==1 , robust 

outreg2 using "d:\cointoss_restat\gambler_fallacy_gb_inc1st_9.10.13.xls", se  bracket  nolabel    10pct  replace

xi:dprobit bettingcoin3 i.streak_outcome2*decision3 i.gender nation   if predict3==1 &  decision1==1 , robust

outreg2 using "d:\cointoss_restat\gambler_fallacy_gb_inc1st_9.10.13.xls", se  bracket  nolabel    10pct  append

xi:dprobit bettingcoin3 i.streak_outcome2*decision3 i.gender nation  if predict3==0 &  decision1==1 , robust  
   
outreg2 using "d:\cointoss_restat\gambler_fallacy_gb_inc1st_9.10.13.xls", se  bracket  nolabel    10pct  append



**Table 5: First time buyers

xi:dprobit decision2 i.perfect_match1    if  decision1==1 , robust  

outreg2 using "d:\cointoss_restat\buying_table_inc1st_9.10.13.xls", se  bracket  nolabel    10pct  replace

xi:dprobit decision3 i.cat_match_2 decision2   if  decision1==1 , robust  

outreg2 using "d:\cointoss_restat\buying_table_inc1st_9.10.13.xls", se  bracket  nolabel    10pct  append


**Table 6: Do people spend more if they buy the bet? - conditioning on initial alpha = 0**

gen lgbetamount1 = log(betamount_1)
gen lgbetamount2 = log(betamount_2)
gen lgbetamount3 = log(betamount_3)
gen lgbetamount4 = log(betamount_4)
gen lgbetamount5 = log(betamount_5)

xi:reg lgbetamount2  i.decision2 lgbetamount1  prop_prob missing_prob i.gender endowment2  fx_bet_strategy /*
*/ i.same_as_env1*decision1 nation i.wrong_bet1*decision1 if decision1==0  , robust

outreg2 using "d:\cointoss_restat\coin_toss_merge_betamount_no1st_9.10.13.xls", se  bracket  nolabel    10pct  replace
 

xi:reg lgbetamount3  i.decision3   lgbetamount2  i.streak_outcome2  prop_prob missing_prob i.gender endowment3 /*
*/ i.same_as_env2*decision2 fx_bet_strategy nation i.wrong_bet2*decision2   /*
*/  if decision1==0, robust

outreg2 using "d:\cointoss_restat\coin_toss_merge_betamount_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append
 

xi:reg lgbetamount4 i.decision4  lgbetamount3  i.streak_outcome3   prop_prob missing_prob i.gender endowment4 /*
*/ i.same_as_env3*decision3 fx_bet_strategy nation i.wrong_bet3*decision3  /*
*/ if decision1==0 , robust

outreg2 using "d:\cointoss_restat\coin_toss_merge_betamount_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append
 

xi:reg lgbetamount5 i.decision5 lgbetamount4  i.streak_outcome4  prop_prob missing_prob i.gender endowment5 /*
*/ i.same_as_env4*decision4 fx_bet_strategy nation i.wrong_bet4*decision4 /*
*/   /*
*/if decision1==0, robust

outreg2 using "d:\cointoss_restat\coin_toss_merge_betamount_no1st_9.10.13.xls", se  bracket  nolabel    10pct  append
 


**Online appendix 
**Sub-sample regression by country 
**Thailand

xi:dprobit decision2 i.perfect_match1  prop_prob missing_prob i.gender endowment2 /*
*/  nation  if  decision1==0 & nation==0 , robust

outreg2 using "d:\cointoss_restat\buying_table_no1st_Thailand_9.10.13.xls", se  bracket  nolabel    10pct  append


xi:dprobit decision3 i.cat_match_2     prop_prob missing_prob i.gender  endowment3 /*
*/  nation  decision2  if  decision1==0 & nation==0 , robust


outreg2 using "d:\cointoss_restat\buying_table_no1st_Thailand_9.10.13.xls", se  bracket  nolabel    10pct  append

xi:dprobit decision4 i.cat_match_3     prop_prob missing_prob i.gender   /*
*/  decision3 endowment4  nation if  decision1==0 & nation==0 , robust


outreg2 using "d:\cointoss_restat\buying_table_no1st_Thailand_9.10.13.xls", se  bracket  nolabel    10pct  append


xi:dprobit decision5 i.cat_match_4     prop_prob missing_prob i.gender   /*
*/  decision4 endowment5  if  decision1==0 & nation==0 , robust

outreg2 using "d:\cointoss_restat\buying_table_no1st_Thailand_9.10.13.xls", se  bracket  nolabel    10pct  append


**Singapore
xi:dprobit decision2 i.perfect_match1  prop_prob missing_prob i.gender endowment2 /*
*/  nation   if  decision1==0 & nation==1 , robust

outreg2 using "d:\cointoss_restat\buying_table_no1st_SG_9.10.13.xls", se  bracket  nolabel    10pct  append


xi:dprobit decision3 i.cat_match_2     prop_prob missing_prob i.gender  endowment3 /*
*/  nation  decision2  if  decision1==0 & nation==1 , robust


outreg2 using "d:\cointoss_restat\buying_table_no1st_SG_9.10.13.xls", se  bracket  nolabel    10pct  append

xi:dprobit decision4 i.cat_match_3     prop_prob missing_prob i.gender   /*
*/  decision3 endowment4  nation   if  decision1==0 & nation==1 , robust


outreg2 using "d:\cointoss_restat\buying_table_no1st_SG_9.10.13.xls", se  bracket  nolabel    10pct  append


xi:dprobit decision5 i.cat_match_4     prop_prob missing_prob i.gender   /*
*/  decision4 endowment5    if  decision1==0 & nation==1 , robust

outreg2 using "d:\cointoss_restat\buying_table_no1st_SG_9.10.13.xls
", se  bracket  nolabel    10pct  append




log close 
