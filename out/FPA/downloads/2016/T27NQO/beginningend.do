*Women variables
ologit wdl treat mech support occ  lelev ldis lcinc nwstate coldwar interactWomenDem RightToVoteBG, cluster(ccode)
ologit wdl treat mech support occ  lelev ldis lcinc nwstate coldwar interactWDemend RightToVoteEnd, cluster(ccode)


*Minority variables
ologit wdl treat mech support occ  lelev ldis lcinc nwstate numlang less3excl less3Dem if yearbg>1945, cluster(ccode)
ologit wdl treat mech support occ  lelev ldis lcinc nwstate numlang less30end less3DemEnd if yearbg>1945, cluster(ccode)
