***Appendix Tables X1 to X3.
   
   
*****TABLE X1. Descriptive statistics of the sample
  *tab1 Groups Female Hispanic Black Age Educ6 Interest Libcon PartyID7 
  *sum Age Educ6 Interest Libcon PartyID7

tab Female Groups, chi2
tab Hispanic Groups, chi2
tab Black Groups, chi2
tab Republican Groups, chi2
tab Democrat Groups, chi2

oneway Age Groups, tab
oneway Educ6 Groups, tab
oneway Interest Groups, tab
oneway PartyID7 Groups, tab
oneway Libcon Groups, tab

*multinomial logit to assess group composition balance

mlogit Groups Female Hispanic Black Age Educ6 Interest Republican Democrat Libcon, baseoutcome(1)





*****TABLE X2. Difference in Proportion tests of In-Party evalutions, by Information Group

*In-Party Cand FT
*News Articles:
ranksum IPCandFT if Groups==1, by(FemCand)

*Minimal Dynamic Board
ranksum IPCandFT if Groups==2, by(FemCand)

*Static Board:
ranksum IPCandFT if Groups==3, by(FemCand)

*Maximum Dynamic Board
ranksum IPCandFT if Groups==4, by(FemCand)

*IPCandLibCon for Republicans
*News Articles:
ranksum IPCandLibCon if Groups==1 & Republican==1, by(FemCand)

*Minimal Dynamic Board
ranksum IPCandLibCon if Groups==2 & Republican==1, by(FemCand)

*Static Board:
ranksum IPCandLibCon if Groups==3 & Republican==1, by(FemCand)

*Maximum Dynamic Board
ranksum IPCandLibCon if Groups==4 & Republican==1, by(FemCand)

*IPCandLibCon for Democrats
*News Articles:
ranksum IPCandLibCon if Groups==1 & Democrat==1, by(FemCand)

*Minimal Dynamic Board
ranksum IPCandLibCon if Groups==2 & Democrat==1, by(FemCand)

*Static Board:
ranksum IPCandLibCon if Groups==3 & Democrat==1, by(FemCand)

*Maximum Dynamic Board
ranksum IPCandLibCon if Groups==4 & Democrat==1, by(FemCand)

*IPCandCmpsn
*News Articles:
ranksum IPCandCmpsn if Groups==1, by(FemCand)

*Minimal Dynamic Board
ranksum IPCandCmpsn if Groups==2, by(FemCand)

*Static Board:
ranksum IPCandCmpsn if Groups==3, by(FemCand)

*Maximum Dynamic Board
ranksum IPCandCmpsn if Groups==4, by(FemCand)

*IPCandComp
*News Articles:
ranksum IPCandComp if Groups==1, by(FemCand)

*Minimal Dynamic Board
ranksum IPCandComp if Groups==2, by(FemCand)

*Static Board:
ranksum IPCandComp if Groups==3, by(FemCand)

*Maximum Dynamic Board
ranksum IPCandComp if Groups==4, by(FemCand)

*IPCandLead
*News Articles:
ranksum IPCandLead if Groups==1, by(FemCand)

*Minimal Dynamic Board
ranksum IPCandLead if Groups==2, by(FemCand)

*Static Board:
ranksum IPCandLead if Groups==3, by(FemCand)

*Maximum Dynamic Board
ranksum IPCandLead if Groups==4, by(FemCand)

*IPCandTrust
*News Articles:
ranksum IPCandTrust if Groups==1, by(FemCand)

*Minimal Dynamic Board
ranksum IPCandTrust if Groups==2, by(FemCand)

*Static Board:
ranksum IPCandTrust if Groups==3, by(FemCand)

*Maximum Dynamic Board
ranksum IPCandTrust if Groups==4, by(FemCand)

*IPCandEcon
*News Articles:
ranksum IPCandEcon if Groups==1, by(FemCand)

*Minimal Dynamic Board
ranksum IPCandEcon if Groups==2, by(FemCand)

*Static Board:
ranksum IPCandEcon if Groups==3, by(FemCand)

*Maximum Dynamic Board
ranksum IPCandEcon if Groups==4, by(FemCand)

*IPCandMil
*News Articles:
ranksum IPCandMil if Groups==1, by(FemCand)

*Minimal Dynamic Board
ranksum IPCandMil if Groups==2, by(FemCand)

*Static Board:
ranksum IPCandMil if Groups==3, by(FemCand)

*Maximum Dynamic Board
ranksum IPCandMil if Groups==4, by(FemCand)

*IPCandPoor
*News Articles:
ranksum IPCandPoor if Groups==1, by(FemCand)

*Minimal Dynamic Board
ranksum IPCandPoor if Groups==2, by(FemCand)

*Static Board:
ranksum IPCandPoor if Groups==3, by(FemCand)

*Maximum Dynamic Board
ranksum IPCandPoor if Groups==4, by(FemCand)

*IPCandWages
*News Articles:
ranksum IPCandWages if Groups==1, by(FemCand)

*Minimal Dynamic Board
ranksum IPCandWages if Groups==2, by(FemCand)

*Static Board:
ranksum IPCandWages if Groups==3, by(FemCand)

*Maximum Dynamic Board
ranksum IPCandWages if Groups==4, by(FemCand)


*****TABLE X3. Difference in Proportion tests of In-Party Evaluations, by Information Level

*In-Party Cand FT
*LowInfo:
ranksum IPCandFT if MaxInfo==0, by(FemCand)

*HighInfo
ranksum IPCandFT if MaxInfo==1, by(FemCand)

*IPCandLibCon for Republicans
*LowInfo:
ranksum IPCandLibCon if MaxInfo==0 & Republican==1, by(FemCand)

*HighInfo
ranksum IPCandLibCon if MaxInfo==1 & Republican==1, by(FemCand)


*IPCandLibCon for Democrats
*LowInfo:
ranksum IPCandLibCon if MaxInfo==0 & Democrat==1, by(FemCand)

*HighInfo
ranksum IPCandLibCon if MaxInfo==1 & Democrat==1, by(FemCand)


*IPCandCmpsn
*LowInfo:
ranksum IPCandCmpsn if MaxInfo==0, by(FemCand)
return list

*HighInfo
ranksum IPCandCmpsn if MaxInfo==1, by(FemCand)

*IPCandComp
*LowInfo:
ranksum IPCandComp if MaxInfo==0, by(FemCand)

*HighInfo
ranksum IPCandComp if MaxInfo==1, by(FemCand)


*IPCandLead
*LowInfo:
ranksum IPCandLead if MaxInfo==0, by(FemCand)

*HighInfo
ranksum IPCandLead if MaxInfo==1, by(FemCand)


*IPCandTrust
*LowInfo:
ranksum IPCandTrust if MaxInfo==0, by(FemCand)

*HighInfo
ranksum IPCandTrust if MaxInfo==1, by(FemCand)


*IPCandEcon
*LowInfo:
ranksum IPCandEcon if MaxInfo==0, by(FemCand)

*HighInfo
ranksum IPCandEcon if MaxInfo==1, by(FemCand)


*IPCandMil
*LowInfo:
ranksum IPCandMil if MaxInfo==0, by(FemCand)

*HighInfo
ranksum IPCandMil if MaxInfo==1, by(FemCand)


*IPCandPoor
*LowInfo:
ranksum IPCandPoor if MaxInfo==0, by(FemCand)

*HighInfo
ranksum IPCandPoor if MaxInfo==1, by(FemCand)


*IPCandWages
*LowInfo:
ranksum IPCandWages if MaxInfo==0, by(FemCand)

*HighInfo
ranksum IPCandWages if MaxInfo==1, by(FemCand)


*****TABLES X4 thru X7 recreate Tables 1 (X4), 2 (X5), X2 (X6) and X3 (X7), but use a Holms-Bonferroni adjustment to account for multiple hypothesis testing when determining statistical significance. Those corrections can be found in the Holms-Bonferroni Excel calculator.
