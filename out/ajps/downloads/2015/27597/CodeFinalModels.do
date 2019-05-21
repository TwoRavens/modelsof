***************************
*MASTER MODELS - Table 2
***************************

*use "/Users/.../FoxNews_Master.dta"

set more off

gen daysfox=daystoelection*FoxNews
gen days2fox=daystoelection2*FoxNews
gen days3fox=daystoelection3*FoxNews

*Democratslogit PartyVote daystoelection daystoelection2 daystoelection3 FoxNews daysfox days2fox days3fox Retirement seniorit voteshare_lag qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==1 & Republican==0, cluster(dist2)

*Republicanslogit PartyVote daystoelection daystoelection2 daystoelection3 FoxNews daysfox days2fox days3fox Retirement seniorit voteshare_lag qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==1 & Republican==1, cluster(dist2)

*Code for the simulated predictions for these and other models is available from the authors upon request.


*****************************************
*DEMOCRATIC VOTE SHARE MODELS - Table 3
*****************************************

clear

*use "/Users/.../FoxNews_Master.dta"

gen dvprop=dv/100

gen daysdv=daystoelection*dvprop
gen days2dv=daystoelection2*dvprop
gen days3dv=daystoelection3*dvprop*Democrats With Foxlogit PartyVote daystoelection daystoelection2 daystoelection3 dvprop daysdv days2dv days3dv Retirement seniorit qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==1 & Republican==0 & FoxNews==1, cluster(dist2)

*Democrats Without Foxlogit PartyVote daystoelection daystoelection2 daystoelection3 dvprop daysdv days2dv days3dv Retirement seniorit qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==1 & Republican==0 & FoxNews==0, cluster(dist2)

*Republicans With Foxlogit PartyVote daystoelection daystoelection2 daystoelection3 dvprop daysdv days2dv days3dv Retirement seniorit qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==1 & Republican==1 & FoxNews==1, cluster(dist2)

*Republicans Without Foxlogit PartyVote daystoelection daystoelection2 daystoelection3 dvprop daysdv days2dv days3dv Retirement seniorit qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==1 & Republican==1 & FoxNews==0, cluster(dist2)


********************************************
*INTERRUPTED TIME SERIES MODELS - Table 4
********************************************

clear

*use "/Users/.../FoxNews_InterruptedTimeSeries.dta"

*Democrats logit PartyVote daystoelection daystoelection2 daystoelection3 FoxNews daysfox days2fox days3fox seniorit voteshare_lag qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==1 & Republican==0, cluster(dist2)
*Republicans logit PartyVote daystoelection daystoelection2 daystoelection3 FoxNews daysfox days2fox days3fox seniorit voteshare_lag qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==1 & Republican==1, cluster(dist2)
********************************************
*CONTINUOUS MEASURE MODELS - Table 5
********************************************

clear

*use "/Users/.../FoxNews_Master.dta"

gen dayscontexp=daystoelection*ContinuousExposure
gen days2contexp=daystoelection2*ContinuousExposure
gen days3contexp=daystoelection3*ContinuousExposure

*Democratslogit PartyVote daystoelection daystoelection2 daystoelection3 ContinuousExposure dayscontexp days2contexp days3contexp Retirement seniorit voteshare_lag qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==1 & Republican==0, cluster(dist2)
*Republicanslogit PartyVote daystoelection daystoelection2 daystoelection3 ContinuousExposure dayscontexp days2contexp days3contexp Retirement seniorit voteshare_lag qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==1 & Republican==1, cluster(dist2)

*******************************
*ROBUSTNESS CHECKS - Table 6
*******************************

*PLACEBO TEST

clear

*use "/Users/.../FoxNews_Placebo.dta"

*Democratslogit PartyVote daystoelection daystoelection2 daystoelection3 FoxNews daysfox days2fox days3fox Retirement seniorit voteshare_lag qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==1 & Republican==0, cluster(dist2)

*Republicans logit PartyVote daystoelection daystoelection2 daystoelection3 FoxNews daysfox days2fox days3fox Retirement seniorit voteshare_lag qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==1 & Republican==1, cluster(dist2)


*NON-PARTY VOTES

clear

*use "/Users/.../FoxNews_Master.dta"

gen daysfox=daystoelection*FoxNews
gen days2fox=daystoelection2*FoxNews
gen days3fox=daystoelection3*FoxNews

*Democratslogit PartyVote daystoelection daystoelection2 daystoelection3 FoxNews daysfox days2fox days3fox Retirement seniorit voteshare_lag qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==0 & Republican==0, cluster(dist2)

*Republicanslogit PartyVote daystoelection daystoelection2 daystoelection3 FoxNews daysfox days2fox days3fox Retirement seniorit voteshare_lag qualchal_lag qualchal spendgap_lag spendgap distpart_lag RegPass Susp OtherPass Amend ProPart if PresencePartyUnity==0 & Republican==1, cluster(dist2)



