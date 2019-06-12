*****************************************************************************
************************ Replication package for ****************************
*** Twitter and Facebook are not representative of the General Population ***
************************** Unweighted Analysis ******************************
*****************************************************************************

***Set working directory***
cd "C:\Dropbox\BES backup\Social media paper\replication package\data"
use bes_f2f_using.dta, clear 


*Table 1*
eststo att1: regress polAttention Age i.gender i.edlevel fbUse
eststo att2: regress polAttention Age i.gender i.edlevel twitterUse
esttab att1 att2, se star(† 0.1 * 0.05 ** 0.01) label nobaselevels mtitles("Facebook" "Twitter")


***Political values***
mean zLR , over(fbUse)
test Yes = No
mean zLR, over(twitterUse)
test Yes = No

mean zAL, over(fbUse)
test Yes = No
mean zAL, over(twitterUse)
test Yes = No

*Table 2*
eststo lr1:  regress zLR Age i.gender i.edlevel fbUse
eststo lr2:  regress zLR Age i.gender i.edlevel twitterUse
eststo al1:  regress zAL Age i.gender i.edlevel fbUse
eststo al2:  regress zAL Age i.gender i.edlevel twitterUse
esttab lr1 lr2 al1 al2, se star(† 0.1 * 0.05 ** 0.01) label nobaselevels mtitles("Facebook" "Twitter" "Facebook" "Twitter")


***Political behaviour***
*Table 3*

tab genElecTurnoutRetro fbUse, col chi
tab genElecTurnoutRetro twitterUse, col chi

*Table 4*
tab validatedTurnout fbUse if genElecTurnoutRetro==1, col chi
tab validatedTurnout twitterUse if genElecTurnoutRetro==1, col chi

*Table 5*
eststo turn1: logit genElecTurnoutRetro Age i.gender i.edlevel fbUse
eststo turn2: logit genElecTurnoutRetro Age i.gender i.edlevel twitterUse
eststo turn3: logit validatedTurnout Age i.gender i.edlevel fbUse
eststo turn4: logit validatedTurnout Age i.gender i.edlevel twitterUse
esttab turn1 turn2 turn3 turn4, se star(† 0.1 * 0.05 ** 0.01) label nobaselevels mtitles("Facebook" "Twitter" "Facebook" "Twitter")

*Table 6*
tab generalElectionVote fbUse, col chi
tab generalElectionVote twitterUse, col chi

*Table 7*
eststo vote1:  mlogit vote2015 Age i.gender i.edlevel fbUse scotland wales, base(1)
eststo vote2:  mlogit vote2015 Age i.gender i.edlevel twitterUse  scotland wales, base(1)
esttab vote1 vote2, se star(† 0.1 * 0.05 ** 0.01) label nobaselevels mtitles("Facebook" "Twitter")

