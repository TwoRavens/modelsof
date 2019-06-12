*****JoP MAIN TEXT REPLICATION FILE FOR FIGURES AND TABLES USING GMMs, OLS REGRESSIONS AND LOGISTIC REGRESSIONS.
***APPENDIX REPLICATION FILE IS BELOW.

***Table 2. GMM for Day 1 In-party candidate preference scores
*regress d1_IPCandPref Democrat StrongPID d0_IPCandPrefFrce  IPFemFrce OPFemFrce
gmm (d1_IPCandPref - {b1}*Democrat - {b2}*StrongPID - {b3}*d0_IPCandPrefFrce  - {b4}*IPFemFrce  - {b5}*OPFemFrce - {b0}), instruments (Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce)

***Table 3a and 3b, Figure 7
** GMM results (also with OLS regressions that are not used, but provided for comparison)
*(controlling for the INITIAL day's preference score)

**Day 1
*regress d1_IPCandPref Democrat StrongPID d0_IPCandPrefFrce  IPFemFrce OPFemFrce
gmm (d1_IPCandPref - {b1}*Democrat - {b2}*StrongPID - {b3}*d0_IPCandPrefFrce  - {b4}*IPFemFrce  - {b5}*OPFemFrce - {b0}), instruments (Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce)

**Day 2
*regress d2_IPCandPref Democrat StrongPID d0_IPCandPrefFrce  IPFemFrce OPFemFrce
gmm (d2_IPCandPref - {b1}*Democrat - {b2}*StrongPID - {b3}*d0_IPCandPrefFrce  - {b4}*IPFemFrce  - {b5}*OPFemFrce - {b0}), instruments (Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce)

**Day 3
*regress d3_IPCandPref Democrat StrongPID d0_IPCandPrefFrce  IPFemFrce OPFemFrce
gmm (d3_IPCandPref - {b1}*Democrat - {b2}*StrongPID - {b3}*d0_IPCandPrefFrce  - {b4}*IPFemFrce  - {b5}*OPFemFrce - {b0}), instruments (Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce)

**Day 4
*regress d4_IPCandPref Democrat StrongPID d0_IPCandPrefFrce  IPFemFrce OPFemFrce
gmm (d4_IPCandPref - {b1}*Democrat - {b2}*StrongPID - {b3}*d0_IPCandPrefFrce  - {b4}*IPFemFrce  - {b5}*OPFemFrce - {b0}), instruments (Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce)

**Day 5
*regress d5_IPCandPref Democrat StrongPID d0_IPCandPrefFrce  IPFemFrce OPFemFrce
gmm (d5_IPCandPref - {b1}*Democrat - {b2}*StrongPID - {b3}*d0_IPCandPrefFrce  - {b4}*IPFemFrce  - {b5}*OPFemFrce - {b0}), instruments (Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce)

**Day 6
*regress d6_IPCandPref Democrat StrongPID d0_IPCandPrefFrce  IPFemFrce OPFemFrce
gmm (d6_IPCandPref - {b1}*Democrat - {b2}*StrongPID - {b3}*d0_IPCandPrefFrce  - {b4}*IPFemFrce  - {b5}*OPFemFrce - {b0}), instruments (Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce)

**Day 7
*regress d7_IPCandPref Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce
gmm (d7_IPCandPref - {b1}*Democrat - {b2}*StrongPID - {b3}*d0_IPCandPrefFrce  - {b4}*IPFemFrce  - {b5}*OPFemFrce - {b0}), instruments (Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce)

**Day 8
*regress d8_IPCandPref Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce
gmm (d8_IPCandPref - {b1}*Democrat - {b2}*StrongPID - {b3}*d0_IPCandPrefFrce  - {b4}*IPFemFrce  - {b5}*OPFemFrce - {b0}), instruments (Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce)

**Day 9
*regress d9_IPCandPref Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce
gmm (d9_IPCandPref - {b1}*Democrat - {b2}*StrongPID - {b3}*d0_IPCandPrefFrce  - {b4}*IPFemFrce  - {b5}*OPFemFrce - {b0}), instruments (Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce)

**Day 10
*regress d10_IPCandPref Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce
gmm (d10_IPCandPref - {b1}*Democrat - {b2}*StrongPID - {b3}*d0_IPCandPrefFrce  - {b4}*IPFemFrce  - {b5}*OPFemFrce - {b0}), instruments (Democrat StrongPID d0_IPCandPrefFrce IPFemFrce OPFemFrce)


***Table 4. Logistic Regression on In-Party Vote
***Logistic Regression
sum IPVoteFrce Democrat StrongPID d0_IPCandPref IPFemFrce OPFemFrce
centile (StrongPID d0_IPCandPref), centile (25 50 75)

logit IPVoteFrce Democrat StrongPID d0_IPCandPref IPFemFrce OPFemFrce

***Figure 8. Predicted Probabilities of voting for the in-party candidate, by Candidate Gender

*****In-party Voting
sum IPVoteFrce Democrat StrongPID d0_IPCandPref IPFemFrce OPFemFrce
centile (d0_IPCandPref) if PartyID==4, centile (25 50 75)

mean d0_IPCandPref if PartyID==1
mean d0_IPCandPref if PartyID==2
mean d0_IPCandPref if PartyID==3
centile (d0_IPCandPref) if PartyID==4, centile (25 50 75)
mean d0_IPCandPref if PartyID==5
mean d0_IPCandPref if PartyID==6
mean d0_IPCandPref if PartyID==7

logit IPVoteFrce Democrat StrongPID d0_IPCandPref IPFemFrce OPFemFrce

**Pred Prob of Strong Democrat
logit IPVoteFrce Democrat StrongPID d0_IPCandPref  IPFemFrce i.OPFemFrce
margins OPFemFrce, at(StrongPID=3 Democrat=1  d0_IPCandPref=54)  vsquish post

**Pred Prob of Middling Democrat
logit IPVoteFrce Democrat StrongPID d0_IPCandPref  IPFemFrce i.OPFemFrce
margins OPFemFrce, at(StrongPID=2 Democrat=1  d0_IPCandPref=31)  vsquish post

**Pred Prob of Weak Democrat
logit IPVoteFrce Democrat StrongPID d0_IPCandPref  IPFemFrce i.OPFemFrce
margins OPFemFrce, at(StrongPID=1 Democrat=1  d0_IPCandPref=22)  vsquish post

**Pred Prob of Independent with strong preferences
logit IPVoteFrce Democrat StrongPID d0_IPCandPref  IPFemFrce i.OPFemFrce
margins OPFemFrce, at(StrongPID=0 Democrat=0  d0_IPCandPref=11)  vsquish post

**Pred Prob of Independent with average preferences
logit IPVoteFrce Democrat StrongPID d0_IPCandPref  IPFemFrce i.OPFemFrce
margins OPFemFrce, at(StrongPID=0 Democrat=0  d0_IPCandPref=5)  vsquish post

**Pred Prob of Independent with weak preferences
logit IPVoteFrce Democrat StrongPID d0_IPCandPref  IPFemFrce i.OPFemFrce
margins OPFemFrce, at(StrongPID=0 Democrat=0  d0_IPCandPref=0)  vsquish post

**Pred Prob of Weak Republican
logit IPVoteFrce Democrat StrongPID d0_IPCandPref  IPFemFrce i.OPFemFrce
margins OPFemFrce, at(StrongPID=1 Democrat=0  d0_IPCandPref=20)  vsquish post

**Pred Prob of Middling Republican
logit IPVoteFrce Democrat StrongPID d0_IPCandPref  IPFemFrce i.OPFemFrce
margins OPFemFrce, at(StrongPID=2 Democrat=0  d0_IPCandPref=23)  vsquish post

**Pred Prob of Strong Republicans
logit IPVoteFrce Democrat StrongPID d0_IPCandPref  IPFemFrce i.OPFemFrce
margins OPFemFrce, at(StrongPID=3 Democrat=0  d0_IPCandPref=45)  vsquish post


*****SYNTAX FOR REPLICATION OF FIGURES AND TABLES IN THE APPENDIX.

***Fig A1. Participation rate by day
sum Day1 Day2 Day3 Day4 Day5 Day6 Day7 Day8 Day9 Day10


***Table A1. Daily demographics of the sample, t-tests
***T-tests for day by day demographic differences in sample, compared to Day1
*Day 2, Female
ttesti 383 .436 .497 272 .430 .496

*Day 2, Black
ttesti 383 .0496 .4965 272 .0367 .1885

*Day 2, Age
ttesti 383  33.605 9.535 272 34.434 9.807

*Day 2, PartyID
ttesti 383 3.120 1.813 272 3.151 1.784

*Day 2, Init PartyPref
ttesti 383 33.308 25.477 272 33.184 25.531

*Day 3, Female
ttesti 383 .436 .497 274 .4416 .4974

*Day 3, Black
ttesti 383 .0496 .4965 274 .0438 .2050

*Day 3, Age
ttesti 383  33.605 9.535 274 34.015 9.653

*Day 3, PartyID
ttesti 383  3.120 1.813 274 3.084 1.835

*Day 3, Init PartyPref
ttesti 383 33.308 25.477 274 34.653 25.905

*Day 4, Female
ttesti 383 .436 .497 265 .4226 .4949

*Day 4, Black
ttesti 383 .0496 .4965 265 .0415 .1998

*Day 4, Age
ttesti 383  33.605 9.535 265 34.0868 9.546

*Day 4, PartyID
ttesti 383  3.120 1.813 265 3.0868 1.812

*Day 4, Init PartyPref
ttesti 383 33.308 25.477 265 34.5396 25.2655

*Day 5, Female
ttesti 383 .436 .497 243 .4486 .4984

*Day 5, Black
ttesti 383 .0496 .4965 243 .0453 .2083

*Day 5, Age
ttesti 383  33.605 9.535 243 34.1688 9.8228

*Day 5, PartyID
ttesti 383  3.120 1.813 243 3.082 1.843

*Day 5, Init PartyPref
ttesti 383 33.308 25.477 243 35.3786 26.376

*Day 6, Female
ttesti 383 .436 .497 249 .4096 .4984

*Day 6, Black
ttesti 383 .0496 .4965 249 .0442 .2059

*Day 6, Age
ttesti 383  33.605 9.535 249 34.2771 9.7244

*Day 6, PartyID
ttesti 383  3.120 1.813 249 3.133 1.823

*Day 6, Init PartyPref
ttesti 383 33.308 25.477 249 33.5502 25.0655

*Day 7, Female
ttesti 383 .436 .497 248 .4395 .497

*Day 7, Black
ttesti 383 .0496 .4965 248 .0483 .497

*Day 7, Age
ttesti 383  33.605 9.535 248 33.8387 9.639

*Day 7, PartyID
ttesti 383  3.120 1.813 248 3.145 1.805

*Day 7, Init PartyPref
ttesti 383 33.308 25.477 248 33.794 25.744

*Day 8, Female
ttesti 383 .436 .497 256 .422 .495

*Day 8, Black
ttesti 383 .0496 .4965 256 .0507 .21998

*Day 8, Age
ttesti 383  33.605 9.535 256 34.082 9.847

*Day 8, PartyID
ttesti 383  3.120 1.813 256 3.094 1.795

*Day 8, Init PartyPref
ttesti 383 33.308 25.477 256 33.8398 26.164

*Day 9, Female
ttesti 383 .436 .497 256 .4336 .4965

*Day 9, Black
ttesti 383 .0496 .4965 256 .0391 .194

*Day 9, Age
ttesti 383  33.605 9.535 256 34.348 9.674

*Day 9, PartyID
ttesti 383  3.120 1.813 256 3.117 1.794

*Day 9, Init PartyPref
ttesti 383 33.308 25.477 256 33.953 26.143

*Day 10, Female
ttesti 383 .436 .497 278 .4424 .4975

*Day 10, Black
ttesti 383 .0496 .4965 278 .0396 .1953

*Day 10, Age
ttesti 383 33.605 9.535 278 34.374 9.849

*Day 10, PartyID
ttesti 383  3.120 1.813 278 3.122 1.790

*Day 10, Init PartyPref
ttesti 383 33.308 25.477 278 34.029 25.548

***Table A2. Balance tests for Day 1 randomizations
oneway Female DemFem, tab
oneway Black DemFem, tab
oneway Age DemFem, tab
oneway Democrat DemFem, tab
oneway Republican DemFem, tab

oneway Female RepFem, tab
oneway Black RepFem, tab
oneway Age RepFem, tab
oneway Democrat RepFem, tab
oneway Republican RepFem, tab

***Table A3. Balance tests for Day 2 
oneway Female DemFem if Day2==1, tab
oneway Black DemFem if Day2==1, tab
oneway Age DemFem if Day2==1, tab
oneway Democrat DemFem if Day2==1, tab
oneway Republican DemFem if Day2==1, tab

oneway Female RepFem if Day2==1, tab
oneway Black RepFem if Day2==1, tab
oneway Age RepFem if Day2==1, tab
oneway Democrat RepFem if Day2==1, tab
oneway Republican RepFem if Day2==1, tab

***Table A4. Balance tests for Day 5 (lowest attendance) 
oneway Female DemFem if Day5==1, tab
oneway Black DemFem if Day5==1, tab
oneway Age DemFem if Day5==1, tab
oneway Democrat DemFem if Day5==1, tab
oneway Republican DemFem if Day5==1, tab

oneway Female RepFem if Day5==1, tab
oneway Black RepFem if Day5==1, tab
oneway Age RepFem if Day5==1, tab
oneway Democrat RepFem if Day5==1, tab
oneway Republican RepFem if Day5==1, tab

***Table A5. Balance tests for Day 10
oneway Female DemFem if Day10==1, tab
oneway Black DemFem if Day10==1, tab
oneway Age DemFem if Day10==1, tab
oneway Democrat DemFem if Day10==1, tab
oneway Republican DemFem if Day10==1, tab

oneway Female RepFem if Day10==1, tab
oneway Black RepFem if Day10==1, tab
oneway Age RepFem if Day10==1, tab
oneway Democrat RepFem if Day10==1, tab
oneway Republican RepFem if Day10==1, tab

***Fig A2. The numbers of days subjects participated in the study
tab Days

***Tables A6, A7, and A8 and Figure A5, please see the SPSS file for Figures 1,2,3 and 4 in the main text.  

***Table A9, A10a, and A10b. Chi-Square differences in issue information search, by candidate sex
tab IPFemFrce d1_IPEduc, row chi2 taub
tab IPFemFrce d1_IPEduc , row chi2 taub
tab IPFemFrce d1_IPFam , row chi2 taub
tab IPFemFrce d1_IPPolExp , row chi2 taub
tab IPFemFrce d1_IPRelig , row chi2 taub
tab IPFemFrce d1_IPSocPhil , row chi2 taub
tab IPFemFrce d2_IPAbort , row chi2 taub
tab IPFemFrce d2_IPGuns , row chi2 taub
tab IPFemFrce d3_IPEconPhil , row chi2 taub
tab IPFemFrce d3_IPTaxes , row chi2 taub
tab IPFemFrce d4_IPEdit , row chi2 taub
tab IPFemFrce d4_IPJobs , row chi2 taub
tab IPFemFrce d5_IPEnergy , row chi2 taub
tab IPFemFrce d5_IPTerr , row chi2 taub
tab IPFemFrce d6_IPEducPol , row chi2 taub
tab IPFemFrce d6_IPGlbWarm , row chi2 taub
tab IPFemFrce d7_IPHlthPol , row chi2 taub
tab IPFemFrce d7_IPImmig , row chi2 taub
tab IPFemFrce d8_IPAttack , row chi2 taub
tab IPFemFrce d8_IPDefBudg , row chi2 taub
tab IPFemFrce d8_IPIran , row chi2 taub
tab IPFemFrce d9_IPCrime , row chi2 taub
tab IPFemFrce d1_OPEduc , row chi2 taub
tab IPFemFrce d1_OPFam , row chi2 taub
tab IPFemFrce d1_OPPolExp , row chi2 taub
tab IPFemFrce d1_OPRelig , row chi2 taub
tab IPFemFrce d1_OPSocPhil , row chi2 taub
tab IPFemFrce d2_OPAbort , row chi2 taub
tab IPFemFrce d2_OPGuns , row chi2 taub
tab IPFemFrce d3_OPEconPhil , row chi2 taub
tab IPFemFrce d3_OPTaxes , row chi2 taub
tab IPFemFrce d4_OPEdit , row chi2 taub
tab IPFemFrce d4_OPJobs , row chi2 taub
tab IPFemFrce d5_OPEnergy , row chi2 taub
tab IPFemFrce d5_OPTerr , row chi2 taub
tab IPFemFrce d6_OPEducPol , row chi2 taub
tab IPFemFrce d6_OPGlbWarm , row chi2 taub
tab IPFemFrce d7_OPHlthPol , row chi2 taub
tab IPFemFrce d7_OPImmig , row chi2 taub
tab IPFemFrce d8_OPAttack , row chi2 taub
tab IPFemFrce d8_OPDefBudg , row chi2 taub
tab IPFemFrce d8_OPIran , row chi2 taub
tab IPFemFrce d9_OPCrime, row chi2 taub

tab OPFemFrce d1_IPEduc, row chi2 taub
tab OPFemFrce d1_IPEduc , row chi2 taub
tab OFemFrce d1_IPFam , row chi2 taub
tab OPFemFrce d1_IPPolExp , row chi2 taub
tab OPFemFrce d1_IPRelig , row chi2 taub
tab OPFemFrce d1_IPSocPhil , row chi2 taub
tab OPFemFrce d2_IPAbort , row chi2 taub
tab OPFemFrce d2_IPGuns , row chi2 taub
tab OPFemFrce d3_IPEconPhil , row chi2 taub
tab OPFemFrce d3_IPTaxes , row chi2 taub
tab OPFemFrce d4_IPEdit , row chi2 taub
tab OPFemFrce d4_IPJobs , row chi2 taub
tab OPFemFrce d5_IPEnergy , row chi2 taub
tab OPFemFrce d5_IPTerr , row chi2 taub
tab OPFemFrce d6_IPEducPol , row chi2 taub
tab OPFemFrce d6_IPGlbWarm , row chi2 taub
tab OPFemFrce d7_IPHlthPol , row chi2 taub
tab OPFemFrce d7_IPImmig , row chi2 taub
tab OPFemFrce d8_IPAttack , row chi2 taub
tab OPFemFrce d8_IPDefBudg , row chi2 taub
tab OPFemFrce d8_IPIran , row chi2 taub
tab OPFemFrce d9_IPCrime , row chi2 taub
tab OPFemFrce d1_OPEduc , row chi2 taub
tab OPFemFrce d1_OPFam , row chi2 taub
tab OPFemFrce d1_OPPolExp , row chi2 taub
tab OPFemFrce d1_OPRelig , row chi2 taub
tab OPFemFrce d1_OPSocPhil , row chi2 taub
tab OPFemFrce d2_OPAbort , row chi2 taub
tab OPFemFrce d2_OPGuns , row chi2 taub
tab OPFemFrce d3_OPEconPhil , row chi2 taub
tab OPFemFrce d3_OPTaxes , row chi2 taub
tab OPFemFrce d4_OPEdit , row chi2 taub
tab OPFemFrce d4_OPJobs , row chi2 taub
tab OPFemFrce d5_OPEnergy , row chi2 taub
tab OPFemFrce d5_OPTerr , row chi2 taub
tab OPFemFrce d6_OPEducPol , row chi2 taub
tab OPFemFrce d6_OPGlbWarm , row chi2 taub
tab OPFemFrce d7_OPHlthPol , row chi2 taub
tab OPFemFrce d7_OPImmig , row chi2 taub
tab OPFemFrce d8_OPAttack , row chi2 taub
tab OPFemFrce d8_OPDefBudg , row chi2 taub
tab OPFemFrce d8_OPIran , row chi2 taub
tab OPFemFrce d9_OPCrime, row chi2 taub

***Table A12: Crosstabulation of In-Party voting by Candidates' Genders
tab IPVoteFrce IPCandGendFrce, column chi2 taub

***Table A13: Predicted probabilties of In-Party vote by Candidates' Genders
*see Main Text replication file for Figure 8
