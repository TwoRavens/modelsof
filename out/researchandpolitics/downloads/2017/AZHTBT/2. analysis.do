*****************************************************************************
************************ Replication package for ****************************
*** Twitter and Facebook are not representative of the General Population ***
***************************** Analysis **************************************
*****************************************************************************

***Set working directory***
cd "C:\Dropbox\BES backup\Social media paper\replication package\data"
use bes_f2f_using.dta, clear 

***Set weights***
svyset [pw=wt_combined_main]

***Social media usage***
svy: tab fbUse 
svy: tab twitterUse

***Age***
svy: mean Age
svy: mean Age if fbUse==1
svy: mean Age if twitterUse==1

svy: tab fbUse if Age<31
svy: tab fbUse if Age>40
svy: tab twitterUse if Age<31
svy: tab twitterUse if Age>40

***Gender***
svy: tab gender fbUse, col
svy: tab gender twitterUse, col

***Education***
svy: tab edlevel fbUse, col
svy: tab edlevel twitterUse, col 

***Political attention***
svy: mean polAttention, over(fbUse)
svy: mean polAttention, over(twitterUse)

*Table 1*
eststo att1: svy: regress polAttention Age i.gender i.edlevel fbUse
eststo att2: svy: regress polAttention Age i.gender i.edlevel twitterUse
esttab att1 att2, se star(† 0.1 * 0.05 ** 0.01) label nobaselevels mtitles("Facebook" "Twitter")


***Political values***
svy: mean zLR , over(fbUse)
test Yes = No
svy: mean zLR, over(twitterUse)
test Yes = No

svy: mean zAL, over(fbUse)
test Yes = No
svy: mean zAL, over(twitterUse)
test Yes = No

*Table 2*
eststo lr1: svy: regress zLR Age i.gender i.edlevel fbUse
eststo lr2: svy: regress zLR Age i.gender i.edlevel twitterUse
eststo al1: svy: regress zAL Age i.gender i.edlevel fbUse
eststo al2: svy: regress zAL Age i.gender i.edlevel twitterUse
esttab lr1 lr2 al1 al2, se star(† 0.1 * 0.05 ** 0.01) label nobaselevels mtitles("Facebook" "Twitter" "Facebook" "Twitter")


***Political behaviour***
*Table 3*
svy: prop genElecTurnoutRetro
svy: prop genElecTurnoutRetro, over(fbUse)
svy: tab genElecTurnoutRetro fbUse, col
svy: prop genElecTurnoutRetro, over(twitterUse)
svy: tab genElecTurnoutRetro twitterUse, col

*Table 4*
svy: prop validatedTurnout if genElecTurnoutRetro==1
svy: prop validatedTurnout if genElecTurnoutRetro==1, over(fbUse)
svy: tab validatedTurnout fbUse if genElecTurnoutRetro==1, col
svy: prop validatedTurnout if genElecTurnoutRetro==1, over(twitterUse)
svy: tab validatedTurnout twitterUse if genElecTurnoutRetro==1, col

*Table 5*
eststo turn1: svy: logit genElecTurnoutRetro Age i.gender i.edlevel fbUse
eststo turn2: svy: logit genElecTurnoutRetro Age i.gender i.edlevel twitterUse
eststo turn3: svy: logit validatedTurnout Age i.gender i.edlevel fbUse
eststo turn4: svy: logit validatedTurnout Age i.gender i.edlevel twitterUse
esttab turn1 turn2 turn3 turn4, se star(† 0.1 * 0.05 ** 0.01) label nobaselevels mtitles("Facebook" "Twitter" "Facebook" "Twitter")

*Table 6*
svy: tab generalElectionVote
svy: prop generalElectionVote
svy: prop generalElectionVote if fbUse==0
svy: prop generalElectionVote if fbUse==1
svy: tab generalElectionVote fbUse, col
svy: prop generalElectionVote if twitterUse==0
svy: prop generalElectionVote if twitterUse==1

svy: tab generalElectionVote twitterUse, col

*Table 7*
eststo vote1: svy: mlogit vote2015 Age i.gender i.edlevel fbUse scotland wales, base(1)
eststo vote2: svy: mlogit vote2015 Age i.gender i.edlevel twitterUse  scotland wales, base(1)
esttab vote1 vote2, se star(† 0.1 * 0.05 ** 0.01) label nobaselevels mtitles("Facebook" "Twitter")


