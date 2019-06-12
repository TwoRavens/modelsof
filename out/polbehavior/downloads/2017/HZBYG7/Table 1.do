*Use Country_Ind.dta

set more off

*****************************************************************************************************
**** Variables **************************************************************************************
*****************************************************************************************************

***Dependent Variables
*Did Not Place Self on Left-Right Scale: noplaced_self_LR
*Did Not Place At Least Two Parties on Left-Right Scale:   noplaced_min2
*Did Not Place Self or At Least Two Parties on Left-Right Scale: noSat_Crit_1_2    

***Independent Variables (Individual Variables)
*Income: Income
*Education: Education 
*Political Information: PolInfo_Index 
*Age: Age 
*Female: Female 
*Urbanness: Urbanness
*Contact Politician: ContactPol 
*Protest: PartProtest 

***Independent Variables (Country Variables)
*Plurality: Plurality 
*Presidential: Presidential 
*Federalism: Federalism 
*ENP (Effective Number of Parties): Eff_Num_Parties 
*Age Electoral System: AgeEleSyst

***Identifiers
*Level 1 (Individual level): B1005
*Level 2 (Country level): B1003

sum noplaced_self_LR noplaced_min2 noSat_Crit_1_2 Income Education PolInfo_Index Age Female Urbanness ContactPol PartProtest Plurality Presidential Federalism Eff_Num_Parties AgeEleSyst B1003

***********************************************************************************************************************************************************
*Table 1: Modeling Incognizance **************************************************************
***********************************************************************************************************************************************************

xtmelogit noplaced_self_LR Income Education PolInfo_Index Age Female Urbanness ContactPol PartProtest Plurality Presidential Federalism Eff_Num_Parties AgeEleSyst || B1003:
estimates store Mod1

xtmelogit noplaced_min2    Income Education PolInfo_Index Age Female Urbanness ContactPol PartProtest Plurality Presidential Federalism Eff_Num_Parties AgeEleSyst || B1003:
estimates store Mod2

xtmelogit noSat_Crit_1_2   Income Education PolInfo_Index Age Female Urbanness ContactPol PartProtest Plurality Presidential Federalism Eff_Num_Parties AgeEleSyst || B1003:
estimates store Mod3

esttab Mod1 Mod2 Mod3, b(%7.3f) starlevels(* .10 ** .05 *** .01) stats (N, label("N") fmt(%9.0g %9.2f))


