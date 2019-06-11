**Replication Do File for "Signaling Resolve: Leaders, Reputation Development, and the Importance of Early Interactions" 
**This Do file provides instructions for how to recreate the tables and figures in this paper. 
**Please note there are two forms of replication data: the standard form data file, which is used to run the ANOVA and pairwise 
**correlational tests, and the long form data file , which is used to run the regression analyses and produce the accompanying figures. 
**Please be sure to use the appropriate replication file as indicated.**

**To replicate Table 2, use the standard form data file**
oneway summitResolve SummitResolute if SummitStatements==1&SummitStateBasedInfo==0, t
oneway negoResolve NegoResolute if LeaderNegoStatements==1&NegoStateBasedInfo==0&SummitStateBasedInfo==0, t
oneway negoResolve NegoResolute if LeaderNegoPast==1&NegoStateBasedInfo==0&SummitStateBasedInfo==0, t
oneway crisisResolve CrisisResolute if LeaderCrisisStatements==1&CrisisStateBasedInfo==0&SummitStateBasedInfo==0&NegoStateBasedInfo==0, t
oneway crisisResolve CrisisResolute if LeaderCrisisPast==1&CrisisStateBasedInfo==0&SummitStateBasedInfo==0&NegoStateBasedInfo==0, t

**To replicate the raw data used to calculate the percentage differences in**
**Table 3, as well as the raw data reported in Tables 5, 6, and 7 in the appendix**
**Use the standard form data files**
**State History Only (Table 5)**
oneway summitResolve  StateRepResolute if SummitStateRep==1& SummitLeaderBasedInfo==0, t
oneway negoResolve StateRepResolute if NegoStateRep==1&NegoLeaderBasedInfo==0, t
oneway crisisResolve StateRepResolute if CrisisStateRep==1&CrisisLeaderBasedInfo==0, t
**State Interest Only (Table 6)**
oneway summitResolve  StateInterestHigh if SummitInterest==1& SummitLeaderBasedInfo==0, t
oneway negoResolve  StateInterestHigh if NegoInterest==1&NegoLeaderBasedInfo==0, t
oneway crisisResolve  StateInterestHigh if CrisisInterest==1&CrisisLeaderBasedInfo==0, t
**Mil Strength Only (Table 7)**
oneway summitResolve  MilitaryStrength if SummitMilStrength==1& SummitLeaderBasedInfo==0, t
oneway negoResolve  MilitaryStrength if NegoMilStrength==1&NegoLeaderBasedInfo==0, t
oneway crisisResolve  MilitaryStrength if CrisisMilStrength==1&CrisisLeaderBasedInfo==0, t
**Percentage differences, as reported in Table 3, were then calculated by hand**

**To replicate Figure 2, use the long form data file**
reg resolve ImpactStateRep ImpactMilStrength ImpactInterst ImpactStatement if time==1, robust
estimates store A
reg resolve ImpactStateRep ImpactMilStrength ImpactInterst ImpactStatement ImpactLeaderPast if time==2, robust
estimates store B
reg resolve ImpactStateRep ImpactMilStrength ImpactInterst ImpactStatement ImpactLeaderPast if time==3, robust
estimates store C
coefplot A B C,  drop(_cons) xline(0)

**To replicate Figure 3, use the long form data file**
reg futureresolve3 i.ConfirmResolve, robust
coefplot, drop(_cons) xline(0)

**To replicate the pairwise correlations under the heading "The Effect of Initial Perceptions**
**Use the standard data file**
pwcorr negoResolve summitResolve, sig
pwcorr crisisResolve summitResolve, sig
pwcorr crisisResolve negoResolve, sig
pwcorr crisisResolve negoResolve if group=="RRU"|group=="URU"|group=="RUR"|group=="UUR", sig
pwcorr negoResolve summitResolve if group=="URR"|group=="URU"|group=="RUR"|group=="RUU", sig
pwcorr crisisResolve summitResolve if group=="RRU"|group=="URR"|group=="RUU"|group=="UUR", sig
pwcorr crisisResolve summitResolve if group=="RUR"|group=="URU", sig

**To replicate Figure 4, use the long form data**
xtreg resolve ViewsonLeaders ViewsOnForce polaffil gender polinterest  polevents lagResolve1 i.ConfirmResolve, robust
coefplot, drop(_cons) xline(0)
**To replicate additional data following discussion in Figure 4**
reg resolve ViewsonLeaders ViewsOnForce polaffil gender polinterest  polevents lagResolve1 if time==2, robust 
reg resolve ViewsonLeaders ViewsOnForce polaffil gender polinterest  polevents lagResolve1 if time==3, robust
reg resolve ViewsonLeaders ViewsOnForce polaffil gender polinterest  polevents lagResolve2 if time==3, robust












