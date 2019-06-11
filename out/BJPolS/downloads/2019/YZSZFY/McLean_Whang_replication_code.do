** Replication file for BJPS 
** McLean and Whang
** 2018/11/04
** "Economic Sanctions and Government Spending Adjustments: The Case of Disaster Preparedness"

tsset ccode year

*********************
** Main results **
*********************

* Table 1: Effect of Ongoing Sanctions on Target’s Trade Revenue *

xtmixed trade sanctepisode || ccode: 

* Table 2: Effect of Sanctions on Military and Disaster Preparedness Spending *

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth TargetCap
global sanc sanctepisode

xtmixed lnmil_spend $sanc $controls || ccode: 
xtmixed lnsoc_prot_spend $sanc $controls || ccode: 

* Table 3: Effect of Sanctions on Disaster-Related Losses * 

global sanc1 l.sanction_onset
global sanc2 sanctepisode
 
xtmixed ltotal_dam_dis $sanc1 $controls || ccode:  
xtmixed lno_affected_dis $sanc1 $controls || ccode: 
xtmixed ltotal_dam_dis $sanc2 $controls || ccode:
xtmixed lno_affected_dis $sanc2 $controls || ccode: 

* Table 4: Substantive Effects of Ongoing Sanctions on Economic Damage and Affected People from Natural Disaster
** Economic Damage/High susceptibility/No sanction vs. Sanctions ** 
qui xtmixed ltotal_dam_dis $sanc2 $controls || ccode:  
margins, at(sanctepisode=0 targ_gdppc_log=10.67217 targ_pop_log=14.05538 TargetCap=.363988)
display exp(15.21)
margins, at(sanctepisode=1 targ_gdppc_log=10.67217 targ_pop_log=14.05538 TargetCap=.363988)
display exp(16.09)

** Economic Damage/Average susceptibility/No sanction vs. Sanctions ** 
margins, at(sanctepisode=0)
display exp(3.4)
margins, at(sanctepisode=1)
display exp(4.27)

** Economic Damage/Low susceptibility/No sanction vs. Sanctions ** 
margins, at(sanctepisode=0 targ_gdppc_log=3.871201 targ_pop_log=4.805495 TargetCap=9.00e-06)
display exp(-1.4)
margins, at(sanctepisode=1 targ_gdppc_log=3.871201 targ_pop_log=4.805495 TargetCap=9.00e-06)
display exp(-.52)

** Affected people/High susceptibility/No sanction vs. Sanctions ** 
global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth TargetCap targ_civ_war
qui xtmixed lno_affected_dis $sanc2 $controls || ccode:
margins, at(sanctepisode=0 targ_gdppc_log=10.67217 targ_pop_log=14.05538 targ_civ_war=1 TargetCap=9.00e-06 )
display exp(10.14)
margins, at(sanctepisode=1 targ_gdppc_log=10.67217 targ_pop_log=14.05538 targ_civ_war=1 TargetCap=9.00e-06 )
display exp(11.08)

** Affected people/Average susceptibility/No sanction vs. Sanctions ** 
margins, at(sanctepisode=0)
display exp(5.4)
margins, at(sanctepisode=1)
display exp(6.4)

** Affected people/Low susceptibility/No sanction vs. Sanctions ** 
margins, at(sanctepisode=0 targ_gdppc_log=3.871201 targ_pop_log=4.805495 targ_civ_war=0 TargetCap=.363988)
display exp(-10.27)
margins, at(sanctepisode=1 targ_gdppc_log=3.871201 targ_pop_log=4.805495 targ_civ_war=0 TargetCap=.363988)
display exp(-9.32)


**************
** Appendix ** 
**************

* Table A1: Summary Statistics*

sum sanctepisode  sanction_onset sanctiontypedum1_ongoing- sanctiontypedum9_ongoing *no_affected_dis *total_dam_dis targetdem TargetTradeOpen targ_mid  targ_gdppc_log targ_pop_log TargetCap targ_gdpgrowth targ_civ_war

* Table A2: Effect of Sanction Onset on Economic Damage from Natural Disasters*
	
global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc l.sanction_onset

xtmixed ltotal_dam_dis $sanc $controls || ccode:
xtmixed lDtotal_dam_dis $sanc $controls || ccode:
xtmixed lFtotal_dam_dis $sanc $controls || ccode:
xtmixed lEtotal_dam_dis $sanc $controls || ccode:
xtmixed lLtotal_dam_dis $sanc $controls || ccode:
xtmixed lStotal_dam_dis $sanc $controls || ccode:
xtmixed lVtotal_dam_dis $sanc $controls || ccode:

* Table A3: Effect of Sanction Onset on Affected People from Natural Disasters*
	
global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc l.sanction_onset

xtmixed lno_affected_dis $sanc $controls || ccode:
xtmixed lDno_affected_dis $sanc $controls || ccode:
xtmixed lFno_affected_dis $sanc $controls || ccode:
xtmixed lEno_affected_dis $sanc $controls || ccode:
xtmixed lLno_affected_dis $sanc $controls || ccode:
xtmixed lSno_affected_dis $sanc $controls || ccode:
xtmixed lVno_affected_dis $sanc $controls || ccode:

* Table A4: Effect of Ongoing Sanctions on Economic Damage from Natural Disasters*
	
global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc sanctepisode

xtmixed ltotal_dam_dis $sanc $controls || ccode:
xtmixed lDtotal_dam_dis $sanc $controls || ccode:
xtmixed lFtotal_dam_dis $sanc $controls || ccode:
xtmixed lEtotal_dam_dis $sanc $controls || ccode:
xtmixed lLtotal_dam_dis $sanc $controls || ccode:
xtmixed lStotal_dam_dis $sanc $controls || ccode:
xtmixed lVtotal_dam_dis $sanc $controls || ccode:

* Table A5: Effect of Ongoing Sanctions on Affected People from Natural Disasters*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc sanctepisode

xtmixed lno_affected_dis $sanc $controls || ccode: 
xtmixed lDno_affected_dis $sanc $controls || ccode: 
xtmixed lFno_affected_dis $sanc $controls || ccode: 
xtmixed lEno_affected_dis $sanc $controls || ccode: 
xtmixed lLno_affected_dis $sanc $controls || ccode: 
xtmixed lSno_affected_dis $sanc $controls || ccode: 
xtmixed lVno_affected_dis $sanc $controls || ccode: 

* Table A6: Effect of Sanctions on Disaster Costs for Democracies and Non-Democracies* 

global controls  lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc2 sanctepisode
 
xtmixed ltotal_dam_dis $sanc2 $controls || ccode: if targetdem == 1
xtmixed ltotal_dam_dis $sanc2 $controls || ccode:  if targetdem == 0
xtmixed lno_affected_dis $sanc2 $controls || ccode:  if targetdem == 1  
xtmixed lno_affected_dis $sanc2 $controls || ccode:  if targetdem == 0

* Table A7: Effect of Sanctions on Disaster Costs (Controlling for G7 Countries)*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc2 sanctepisode
 
xtmixed ltotal_dam_dis $sanc2 $controls || ccode: if G7 == 0
xtmixed lno_affected_dis $sanc2 $controls || ccode:  if G7 == 0  
xtmixed ltotal_dam_dis $sanc2 $controls G7 || ccode:
xtmixed lno_affected_dis $sanc2 $controls G7 || ccode:

* Table A8: Effect of Sanctions on Disaster Costs (with Time Controls)* 

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc2 sanctepisode

xtmixed ltotal_dam_dis $sanc $controls dyear dyear2 dyear3 || ccode:
xtmixed lno_affected_dis $sanc $controls dyear dyear2 dyear3 || ccode:

* Table A9: Effect of Sanctions on Disaster-Related Losses (Controlling for Disaster Frequency)* 

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc1 l.sanction_onset
global sanc2 sanctepisode

xtmixed ltotal_dam_dis l.no_disasters $sanc1 $controls || ccode:
xtmixed lno_affected_dis l.no_disasters $sanc1 $controls || ccode:
xtmixed ltotal_dam_dis l.no_disasters $sanc2 $controls || ccode:
xtmixed lno_affected_dis l.no_disasters $sanc2 $controls || ccode:

* Table A10: Effect of Sanctions on Disaster-Related Losses (Controlling for Disaster Risks)*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc1 l.sanction_onset
global sanc2 sanctepisode

xtmixed ltotal_dam_dis l.HazMean $sanc1 $controls || ccode:
xtmixed lno_affected_dis l.HazMean $sanc1 $controls || ccode:
xtmixed ltotal_dam_dis l.HazMean $sanc2 $controls || ccode:
xtmixed lno_affected_dis l.HazMean $sanc2 $controls || ccode:

* Table A11: Effect of Sanctions on Disaster-Related Losses (Controlling for Slow-Onset Disasters)*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc1 l.sanction_onset
global sanc2 sanctepisode

xtmixed ltotal_dam_dis drought_dum $sanc1 $controls || ccode:
xtmixed lno_affected_dis drought_dum $sanc1 $controls || ccode:
xtmixed ltotal_dam_dis drought_dum $sanc2 $controls || ccode:
xtmixed lno_affected_dis drought_dum $sanc2 $controls || ccode:

* Table A12: Effect of Sanctions on Disaster-Related Losses (Controlling for Lagged Dependent Variable)*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc1 l.sanction_onset
global sanc2 sanctepisode

xtmixed ltotal_dam_dis l.ltotal_dam_dis $sanc1 $controls || ccode:
xtmixed lno_affected_dis l.lno_affected_dis $sanc1 $controls || ccode:
xtmixed ltotal_dam_dis l.ltotal_dam_dis $sanc2 $controls || ccode:
xtmixed lno_affected_dis l.lno_affected_dis $sanc2 $controls || ccode:

* Table A13: Effect of Disasters on Sanction Imposition*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap

melogit sanction_onset l.disaster_dummy $controls || ccode:
melogit mult_sanction_onset l.disaster_dummy $controls  || ccode: 
melogit institution_sanction_onset  l.disaster_dummy $controls || ccode: 

* Table A14: Effect of Sanctions on Disaster-Related Losses (Controlling for Relative Political Reach)*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc1 l.sanction_onset
global sanc2 sanctepisode

xtmixed ltotal_dam_dis l.rpr_eap $sanc1 $controls || ccode:
xtmixed lno_affected_dis l.rpr_eap $sanc1 $controls || ccode: 
xtmixed ltotal_dam_dis l.rpr_eap $sanc2 $controls || ccode:
xtmixed lno_affected_dis l.rpr_eap $sanc2 $controls || ccode:

* Table A15: Effect of Sanctions on the Number of Homeless and Killed People from Natural Disasters*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc1 l.sanction_onset
global sanc2 sanctepisode

xtmixed lno_homeless_dis $sanc1 $controls || ccode:
xtmixed lno_homeless_dis $sanc2 $controls || ccode: 
xtmixed lno_killed_dis $sanc1 $controls || ccode:
xtmixed lno_killed_dis $sanc2 $controls || ccode:

* Table A16: Sanctions Effect on Military Spending and Education Spending as Share of GDP (Word Development Indicators Data)*

global sanc sanctepisode

xtmixed  lnmil_exp_gdp $sanc $controls || ccode: 
xtmixed lned_gdp $sanc $controls || ccode:

* Table A17: Effect of Sanctions of Different Types on Costs from Natural Disasters*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap

xtmixed ltotal_dam_dis sanctiontypedum_onset1l1- sanctiontypedum_onset9l1 $controls || ccode:
xtmixed lno_affected_dis sanctiontypedum_onset1l1- sanctiontypedum_onset9l1 $controls || ccode:
xtmixed ltotal_dam_dis sanctiontypedum1_ongoing- sanctiontypedum9_ongoing $controls || ccode:
xtmixed lno_affected_dis sanctiontypedum1_ongoing- sanctiontypedum9_ongoing $controls || ccode:

* Table A18: Sanctions Effect on Military Spending (Target Regime Type and Ideology)*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc sanctepisode
global controls_notargetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap

xtmixed lnmil_spend  $sanc $controls target_rightwing  || ccode:  
xtmixed lnmil_spend  $sanc $controls_notargetdem target_right_dic || ccode:
xtmixed lnmil_spend  $sanc $controls execnat if  execnat != -999 || ccode:  

* Table A19: Sanctions Effect on Disaster Preparedness Spending (Target Regime Type and Ideology)*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth TargetCap
global sanc sanctepisode
global controls_notargetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth TargetCap

xtmixed lnsoc_prot_spend  $sanc $controls target_rightwing || ccode:   
xtmixed lnsoc_prot_spend  $sanc $controls_notargetdem target_right_dic || ccode: 
xtmixed lnsoc_prot_spend  $sanc $controls execnat if execnat != -999 || ccode:  

* Table A20: Effect of Sanctions and Sanction Duration on Military Spending*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc sanctepisode

xtmixed  lnmil_exp_gdp $sanc   $controls || ccode:  
xtmixed  lnmil_exp_gdp sanction_duration   $controls || ccode:  

* Table A21: Effect of Sanctions on Disaster-Related Losses (Excluding Affluent Targets)*

global controls  targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc1 l.sanction_onset
global sanc2 sanctepisode

xtmixed ltotal_dam_dis $sanc1 $controls || ccode: if targ_gdppc_log < 7.389388 + 1.324181
xtmixed lno_affected_dis $sanc1 $controls  || ccode:  if targ_gdppc_log < 7.389388 + 1.324181
xtmixed ltotal_dam_dis $sanc2 $controls  || ccode: if targ_gdppc_log < 7.389388 + 1.324181
xtmixed lno_affected_dis $sanc2 $controls  || ccode: if targ_gdppc_log < 7.389388 + 1.324181

* Table A22: Effect of Sanctions on Disaster-Related Losses (Controlling for Six Individual Disaster Risks)*

global sanc2 sanctepisode
global sanc1 l.sanction_onset
global controls targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap

xtmixed ltotal_dam_dis $sanc1 $controls  CTY_avg_C-CTY_avg_V || ccode:
xtmixed lno_affected_dis $sanc1 $controls  CTY_avg_C-CTY_avg_V || ccode:
xtmixed ltotal_dam_dis $sanc2 $controls  CTY_avg_C-CTY_avg_V || ccode:
xtmixed lno_affected_dis $sanc2 $controls  CTY_avg_C-CTY_avg_V || ccode:

* Table A23: Sanctions Effect on Police and Public Order Spending as Share of GDP (Using Spending Shares as DVs)*

global controls targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc sanctepisode

xtmixed police_exp $sanc $controls || ccode:  
xtmixed order_exp $sanc $controls || ccode:  

* Table A24: Two-Stage Model of Sanctions, Disaster Preparedness Spending, and Disaster-Related Losses *

global controls targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap

xtmixed lnsoc_prot_spend sanctepisode $controls || ccode:
*predict yhat_socspend, fitted 
sort ccode year
*by ccode: gen yhat_socspend_l1= yhat_socspend[_n-1]

set seed 123123

bootstrap, reps(100): xtmixed ltotal_dam_dis  yhat_socspend_l1  $controls  ||  ccode:    
bootstrap, reps(100): xtmixed lno_affected_dis  yhat_socspend_l1  $controls  ||  ccode:   

* Table A25: Sanctions Effect on Disaster Preparedness Spending as Share of GDP (Robustness Checks)*

global controls targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth TargetCap
global sanc sanctepisode

xtmixed lnsoc_prot_spend $sanc $controls G7 || ccode:  
xtmixed lnsoc_prot_spend $sanc $controls  rpr_eap || ccode:  
xtmixed lnsoc_prot_spend $sanc $controls   no_disasters || ccode: 
xtmixed lnsoc_prot_spend $sanc $controls    HazMean || ccode:    
xtmixed lnsoc_prot_spend $sanc $controls    dyear dyear2 dyear3  || ccode: 

* Table A26: Sanctions Effect on Military Spending and Disaster Preparedness Spending as Share of GDP (Sanction Dummy Replaced with Sanction Cost)*

global controls targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap

xtmixed lnmil_spend   target_costs_ongoing $controls || ccode:  
xtmixed lnsoc_prot_spend   target_costs_ongoing $controls || ccode:  

* Table A27: Effect of Sanctions on Disaster-Related Losses (Sanction Dummy Replaced with Sanction Cost)*

global controls targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap

xtmixed ltotal_dam_dis  l.target_costs_onset $controls || ccode:
xtmixed lno_affected_dis l.target_costs_onset $controls || ccode:
xtmixed ltotal_dam_dis target_costs_ongoing $controls || ccode:
xtmixed lno_affected_dis target_costs_ongoing $controls || ccode: 

* Table A28: Sanctions Effect on Military Spending and Disaster Preparedness Spending as Share of GDP (Fixed Effects Models)*

global controls targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth TargetCap
global sanc sanctepisode

xtreg lnmil_spend $sanc $controls, fe
xtreg lnsoc_prot_spend $sanc $controls , fe

* Table A29: Effect of Sanctions on Disaster-Related Losses (Fixed Effects Models)*

global controls targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc1 l.sanction_onset
global sanc2 sanctepisode

xtreg ltotal_dam_dis $sanc1 $controls, fe
xtreg lno_affected_dis $sanc1 $controls, fe
xtreg ltotal_dam_dis $sanc2 $controls, fe
xtreg lno_affected_dis $sanc2 $controls, fe

* Table A30: Sanctions Effect on Disaster Preparedness Spending as Share of GDP (with Dynamic Effects)*

global controls targetdem lntrade_open targ_mid  targ_gdppc_log targ_pop_log targ_gdpgrowth targ_civ_war TargetCap
global sanc sanctepisode

xtmixed lnsoc_prot_spend sanction_duration $controls || ccode: 
xtmixed lnsoc_prot_spend $sanc $controls dyear dyear2 dyear3 no_disaster_count  || ccode:
xtmixed lnsoc_prot_spend $sanc $controls  i.year || ccode:

