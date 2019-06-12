set more off

use "20180121_RP_Anon_MainData.dta"

log using "20180121_RP_Anon_Logfile.log", replace

************************************************************************
************************************************************************
************************************************************************
***********POTENTIAL SET OF MODELS TO USE IN MAIN ANALYSES**************
***************************November 15, 2017****************************
************************************************************************
************************************************************************
************************************************************************

**********************
** Multinomial models w/ UCDP termination data
**********************

*************************************
***RESULTS PRESENTED IN TABLE 2******
*************************************
*****
*3 outcomes: 1=gov vic, 2=other, 3=reb vic
*****

mlogit outcome_num2 female_combat_binary forced_recruit forced_female duration epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar, cl(ccode) b(2) nolog

**********************************************
***SUBSTANTIVE EFFECTS PRESENTED IN TABLE 3***
**********************************************

predict p_MEAN1 if e(sample), outcome(1)
predict p_NN1 if e(sample) & female_combat_binary==0 & forced_recruit==0 & forced_female==0, outcome(1)
predict p_FN1 if e(sample) & female_combat_binary==0 & forced_recruit==1 & forced_female==0, outcome(1)
predict p_NW1 if e(sample) & female_combat_binary==1 & forced_recruit==0 & forced_female==0, outcome(1)
predict p_FW1 if e(sample) & female_combat_binary==1 & forced_recruit==1 & forced_female==1, outcome(1)
summarize p_MEAN1 p_NN1 p_FN1 p_NW1 p_FW1

predict p_MEAN2 if e(sample), outcome(3)
predict p_NN2 if e(sample) & female_combat_binary==0 & forced_recruit==0 & forced_female==0, outcome(3)
predict p_FN2 if e(sample) & female_combat_binary==0 & forced_recruit==1 & forced_female==0, outcome(3)
predict p_NW2 if e(sample) & female_combat_binary==1 & forced_recruit==0 & forced_female==0, outcome(3)
predict p_FW2 if e(sample) & female_combat_binary==1 & forced_recruit==1 & forced_female==1, outcome(3)
summarize p_MEAN2 p_NN2 p_FN2 p_NW2 p_FW2

************************************************
***SUMMARY STATISTICS PRESENTED IN TABLE 1******
************************************************

summ outcome_num2 female_combat_binary forced_recruit forced_female duration epolity2 elogged_gdp elogged_pop numdyads fighting mobilization eColdWar if e(sample)

drop p_MEAN1 p_NN1 p_FN1 p_NW1 p_FW1 p_MEAN2 p_NN2 p_FN2 p_NW2 p_FW2


log close


