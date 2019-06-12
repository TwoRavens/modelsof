*file: "datasetFINAL"
 
*Model 1 Baseline
logit  Dissent  FBPressure  PartyPrimary MinorityFaction Seniority
*Model 2 Baseline + Controls
logit  Dissent  FBPressure  PartyPrimary MinorityFaction Seniority House Senate  FBFriends Age Female Education regdummy1-regdummy21
*Model 3 Interaction
logit  Dissent  c.FBPressure##i.PartyPrimary MinorityFaction Seniority House Senate  FBFriends Age Female Education regdummy1-regdummy21
*Model 4 Explicit Dissent
logit  ExplicitDissent  FBPressure  PartyPrimary MinorityFaction Seniority House Senate  FBFriends Age Female Education regdummy1-regdummy21 
*Model 5 Anti-Marini
logit  Dissent AntiMariniFBPressure  PartyPrimary MinorityFaction Seniority House Senate  FBFriends Age Female Education regdummy1-regdummy21
*Model 6 Weighted
logit  Dissent WeightedFBPressure PartyPrimary MinorityFaction Seniority House Senate  FBFriends Age Female Education regdummy1-regdummy21
*Model 7 Pre-Assembly
logit  DissentPreAssembly PreAssemblyFBPressure PartyPrimary MinorityFaction Seniority House Senate  FBFriends Age Female Education regdummy1-regdummy21


*file: "FIGURE1"

*figure1
graph twoway (scatter variablename  estimate, mlabel(variablename) mlabpos(12) mlabc(black) mcolor(black) legend(off))  (rcap    lb95ci ub95ci variablename , hor lcolor(black) legend(off))
