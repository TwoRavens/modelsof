*Use Country_Ind.dta

set more off

*****************************************************************************************************
**** Variables **************************************************************************************
*****************************************************************************************************

***Dependent Variables
*Did Not Place Self on Left-Right Scale: noplaced_self_LR
*Did Not Place At Least Two Parties on Left-Right Scale:   noplaced_min2
*Did Not Place Self or At Least Two Parties on Left-Right Scale: noSat_Crit_1_2    

***Identifiers
*Level 1 (Individual level): B1005
*Level 2 (Country level): B1003

sum noplaced_self_LR noplaced_min2 noSat_Crit_1_2 B1003

***********************************************************************************************************************************************************
***Table A10: Unconditional Models **************************************************************
***********************************************************************************************************************************************************

xtmelogit noplaced_self_LR  || B1003:

xtmelogit noplaced_min2     || B1003:

xtmelogit noSat_Crit_1_2    || B1003:

