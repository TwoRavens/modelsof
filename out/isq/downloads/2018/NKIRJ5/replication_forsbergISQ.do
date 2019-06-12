* This file replicates the results in:
* Forsberg, Erika. "Do Ethnic Dominoes Fall: Evaluating Domino Effects of 
* Granting Territorial Concessions to Separatist Groups”
* International Studies Quarterly
* copy as do-file and use with the dataset "replication_forsbergISQ.dta"
*****************************************************************************


*TABLE 1

*model 1
logit onset ldecaypact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
prvalue, x(decaykin3=0) rest(mean)
prvalue, x(decaykin3=1) rest(mean)
*model 2
logit onset ldecaypactpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
*models 3 & 5
mlogit onsettype ldecaypact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 
*models 4 & 6
mlogit onsettype ldecaypactpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 


*TABLE 2
*model 1
logit onset ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
*model 2
logit onset ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay  , cluster(eprid) 
*models 3 & 5
mlogit onsettype ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 
*models 4 & 6
mlogit onsettype ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 


*ONLINE APPENDIX

*decriptives
sum onset onsettype ldecaypact3 ldecaypactpart3 ldecayinpact3 ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar antalepr lnepr disc powerless  propex regauton  lbpol lsqbpolity if onset!=. & onsettype!=. & ldecaypact3!=. & ldecaypactpart3!=. & ldecayinpact3!=. & ldecayinpart3!=. & decaystateconf3!=. & decaykin3!=. & lnbs_cwar!=. & antalepr!=. & lnepr!=. & disc!=. & powerless!=. &  propex!=. & regauton!=. &  lbpol!=. & lsqbpolity!=. 
tab onset if ldecaypact3!=. & ldecaypactpart3!=. & ldecayinpact3!=. & ldecayinpart3!=. & decaystateconf3!=. & decaykin3!=. & lnbs_cwar!=. & antalepr!=. & lnepr!=. & disc!=. & powerless!=. &  propex!=. & regauton!=. &  lbpol!=. & lsqbpolity!=. 
tab disc if ldecaypact3!=. & ldecaypactpart3!=. & ldecayinpact3!=. & ldecayinpart3!=. & decaystateconf3!=. & decaykin3!=. & lnbs_cwar!=. & antalepr!=. & lnepr!=. & disc!=. & powerless!=. &  propex!=. & regauton!=. &  lbpol!=. & lsqbpolity!=. 
tab powerless if ldecaypact3!=. & ldecaypactpart3!=. & ldecayinpact3!=. & ldecayinpart3!=. & decaystateconf3!=. & decaykin3!=. & lnbs_cwar!=. & antalepr!=. & lnepr!=. & disc!=. & powerless!=. &  propex!=. & regauton!=. &  lbpol!=. & lsqbpolity!=. 
tab regauton if ldecaypact3!=. & ldecaypactpart3!=. & ldecayinpact3!=. & ldecayinpart3!=. & decaystateconf3!=. & decaykin3!=. & lnbs_cwar!=. & antalepr!=. & lnepr!=. & disc!=. & powerless!=. &  propex!=. & regauton!=. &  lbpol!=. & lsqbpolity!=. 

*The following robustness tests typically use the same eight regression model that are reported in Table 1 and 2 as the point of departure

*1. alternative specifications of territorial concessions
*(a)decay of concession with a half-life of 5 yrs
logit onset ldecaypact5 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
logit onset ldecaypactpart5 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecaypact5 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecaypactpart5 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 

logit onset ldecayinpact5 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
logit onset ldecayinpart5 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay  , cluster(eprid) 
mlogit onsettype ldecayinpact5 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecayinpart5 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 

*(b) decay of concession with a half-life of 1 yrs
logit onset ldecaypact1 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
logit onset ldecaypactpart1 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecaypact1 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecaypactpart1 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 

logit onset ldecayinpact1 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
logit onset ldecayinpart1 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay  , cluster(eprid) 
mlogit onsettype ldecayinpact1 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecayinpart1 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 

* (c) decay of territorial conflict using Carter and Signorinos recommendation 
logit onset decayt decayt2 decayt3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless regauton lbpol lsqbpolity decay , cluster(eprid) 
logit onset partdecayt partdecayt2 partdecayt3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless  regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype decayt decayt2 decayt3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype partdecayt partdecayt2 partdecayt3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless  regauton lbpol lsqbpolity decay , cluster(eprid) 
logit onset indecayt indecayt2 indecayt3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless regauton lbpol lsqbpolity decay , cluster(eprid) 
logit onset partindecayt partindecayt2 partindecayt3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless  regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype indecayt indecayt2 indecayt3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless regauton lbpol lsqbpolity decay , cluster(eprid) 
* cannot be estimated: mlogit onsettype partindecayt partindecayt2 partindecayt3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless  regauton lbpol lsqbpolity decay , cluster(eprid) 

* (d) pact is fully implemented
logit onset ldecayfullpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecayfullpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 
logit onset ldecayinfull3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecayinfull3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 


*(e) only cases which have concessions at some point
sort eprid year
bysort eprid: egen ind = max(aterrpact)

logit onset ldecaypact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay if ind==1, cluster(eprid) 
logit onset ldecaypactpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay if ind==1, cluster(eprid) 
mlogit onsettype ldecaypact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay if ind==1, cluster(eprid) 
mlogit onsettype ldecaypactpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay if ind==1, cluster(eprid) 

*only cases that ever have concessions (within same state)
sort eprid year
bysort eprid: egen indin = max(inaterrpact)

logit onset ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless regauton lbpol lsqbpolity decay if indin==1, cluster(eprid) 
logit onset ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless  regauton lbpol lsqbpolity decay if indin==1, cluster(eprid) 
mlogit onsettype ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless regauton lbpol lsqbpolity decay if indin==1, cluster(eprid) 
mlogit onsettype ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless  regauton lbpol lsqbpolity decay if indin==1, cluster(eprid) 

* (f) fixed effets models
xtlogit onset ldecaypact3  decaystateconf3 decaykin3 lnbs_cwar lnepr disc powerless propex regauton lbpol lsqbpolity decay, fe i(eprid)
xtlogit onset ldecaypactpart3  decaystateconf3 decaykin3 lnbs_cwar lnepr disc powerless propex regauton lbpol lsqbpolity decay, fe i(eprid)

xtlogit onset ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless regauton lbpol lsqbpolity decay , fe i(eprid)
xtlogit onset ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless  regauton lbpol lsqbpolity decay , fe i(eprid)

*2. alternative specification of dependent variable: onset of territorial conflict
logit terrconf  ldecaypact3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless regauton lbpol lsqbpolity terrdecay , cluster(eprid) 
logit terrconf  ldecaypactpart3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless  regauton lbpol lsqbpolity terrdecay , cluster(eprid) 

logit terrconf ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity terrdecay , cluster(eprid) 
logit terrconf ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity terrdecay  , cluster(eprid) 


*3. additional control variables

*(a) controlling for group concentration (sample covers only MAR groups)
logit onset ldecaypact3 concgroup decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
logit onset ldecaypactpart3 concgroup decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecaypact3 concgroup decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecaypactpart3 concgroup decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay , cluster(eprid) 

logit onset ldecayinpact3  concgroup decaystateconf3 decaykin3 lnbs_cwar lnepr disc powerless propex regauton lbpol lsqbpolity decay , cluster(eprid) 
logit onset  ldecayinpart3 concgroup decaystateconf3 decaykin3 lnbs_cwar lnepr disc powerless propex regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecayinpact3  concgroup decaystateconf3 decaykin3 lnbs_cwar lnepr disc powerless propex regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype  ldecayinpart3 concgroup decaystateconf3 decaykin3 lnbs_cwar lnepr disc powerless propex regauton lbpol lsqbpolity decay , cluster(eprid) 
*models if concgroup==1
logit onset ldecaypact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay if concgroup==1, cluster(eprid) 
logit onset ldecaypactpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay if concgroup==1, cluster(eprid) 
mlogit onsettype ldecaypact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay if concgroup==1, cluster(eprid) 
mlogit onsettype ldecaypactpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay if concgroup==1, cluster(eprid) 

logit onset  ldecayinpact3   decaystateconf3 decaykin3  lnbs_cwar lnepr disc powerless propex regauton lbpol lsqbpolity decay if concgroup==1, cluster(eprid) 
logit onset  ldecayinpart3  decaystateconf3 decaykin3  lnbs_cwar lnepr disc powerless propex regauton lbpol lsqbpolity decay if concgroup==1, cluster(eprid) 
mlogit onsettype  ldecayinpact3   decaystateconf3 decaykin3  lnbs_cwar lnepr disc powerless propex regauton lbpol lsqbpolity decay if concgroup==1, cluster(eprid) 
mlogit onsettype  ldecayinpart3  decaystateconf3 decaykin3  lnbs_cwar lnepr disc powerless propex regauton lbpol lsqbpolity decay if concgroup==1, cluster(eprid) 

* (b) controlling for years with strong demonstration effects (set of year dummies) 
logit onset ldecaypact3 decaystateconf3 decaykin3 lnbs_cwar sep91 sep92 sep93 sep99 lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay, cluster(eprid) 
logit onset ldecaypactpart3 decaystateconf3 decaykin3 lnbs_cwar sep91 sep92 sep93 sep99 lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay, cluster(eprid) 
mlogit onsettype ldecaypact3 decaystateconf3 decaykin3 lnbs_cwar sep91 sep92 sep93 sep99 lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay, cluster(eprid) 
mlogit onsettype ldecaypactpart3 decaystateconf3 decaykin3 lnbs_cwar sep91 sep92 sep93 sep99 lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay, cluster(eprid) 

logit onset ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar sep91 sep92 sep93 sep99 propex lnepr disc powerless regauton lbpol lsqbpolity decay , cluster(eprid) 
logit onset ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar sep91 sep92 sep93 sep99 propex lnepr disc powerless  regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar sep91 sep92 sep93 sep99 propex lnepr disc powerless regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar sep91 sep92 sep93 sep99 propex lnepr disc powerless  regauton lbpol lsqbpolity decay , cluster(eprid) 

*dummy for all year dummies above
logit onset ldecaypact3 decaystateconf3 decaykin3 sepall lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay, cluster(eprid) 
logit onset ldecaypactpart3 decaystateconf3 decaykin3 sepall lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay, cluster(eprid) 
mlogit onsettype ldecaypact3 decaystateconf3 decaykin3 sepall lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay, cluster(eprid) 
mlogit onsettype ldecaypactpart3 decaystateconf3 decaykin3 sepall lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay, cluster(eprid) 

logit onset ldecayinpact3 decaystateconf3 decaykin3 sepall lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay, cluster(eprid) 
logit onset ldecayinpart3 decaystateconf3 decaykin3 sepall lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay, cluster(eprid) 
mlogit onsettype ldecayinpact3 decaystateconf3 decaykin3 sepall lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay, cluster(eprid) 
mlogit onsettype ldecayinpart3 decaystateconf3 decaykin3 sepall lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay, cluster(eprid) 

*4. alternative estimator: rare events logit (multinomial models thus not estimated)
relogit onset ldecaypact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
relogit onset ldecaypactpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 

relogit onset ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 
relogit onset ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay , cluster(eprid) 

*5. alternative approaches for dealing with spatial and temporal autocorrelation

* (a) decay of peace, half-life 3 years
logit onset ldecaypact3 decaystateconf3 decaykin3  lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay3, cluster(eprid) 
logit onset ldecaypactpart3 decaystateconf3 decaykin3  lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay3, cluster(eprid) 
mlogit onsettype ldecaypact3 decaystateconf3 decaykin3  lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay3, cluster(eprid) 
mlogit onsettype ldecaypactpart3 decaystateconf3 decaykin3  lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay3, cluster(eprid) 

logit onset ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay3 , cluster(eprid) 
logit onset ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay3  , cluster(eprid) 
mlogit onsettype ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay3 , cluster(eprid) 
mlogit onsettype ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay3 , cluster(eprid) 
* (b) half-life 1 year
logit onset ldecaypact3 decaystateconf3 decaykin3  lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay1, cluster(eprid) 
logit onset ldecaypactpart3 decaystateconf3 decaykin3  lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay1, cluster(eprid) 
mlogit onsettype ldecaypact3 decaystateconf3 decaykin3  lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay1, cluster(eprid) 
mlogit onsettype ldecaypactpart3 decaystateconf3 decaykin3  lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay1, cluster(eprid) 

logit onset ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay1 , cluster(eprid) 
logit onset ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay1  , cluster(eprid) 
mlogit onsettype ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay1 , cluster(eprid) 
mlogit onsettype ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay1 , cluster(eprid) 
* (c) Beck, Katz & Tucker approach
logit onset ldecaypact3 decaystateconf3 decaykin3  lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity peaceyrs _spline1 _spline2 _spline3, cluster(eprid) 
logit onset ldecaypactpart3 decaystateconf3 decaykin3  lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity peaceyrs _spline1 _spline2 _spline3, cluster(eprid) 
mlogit onsettype ldecaypact3 decaystateconf3 decaykin3  lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity peaceyrs _spline1 _spline2 _spline3, cluster(eprid) 
mlogit onsettype ldecaypactpart3 decaystateconf3 decaykin3  lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity peaceyrs _spline1 _spline2 _spline3, cluster(eprid) 

logit onset ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity  peaceyrs _spline1 _spline2 _spline3, cluster(eprid) 
logit onset ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity  peaceyrs _spline1 _spline2 _spline3, cluster(eprid) 
mlogit onsettype ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity peaceyrs _spline1 _spline2 _spline3, cluster(eprid) 
mlogit onsettype ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity peaceyrs _spline1 _spline2 _spline3, cluster(eprid) 

* (d) cluster on country
logit onset ldecaypact3 decaystateconf3 decaykin3 lnbs_cwar  propex lnepr disc powerless regauton lbpol lsqbpolity decay , cluster(ccode) 
logit onset ldecaypactpart3 decaystateconf3 decaykin3 lnbs_cwar  propex lnepr disc powerless  regauton lbpol lsqbpolity decay , cluster(ccode) 
mlogit onsettype ldecaypact3 decaystateconf3 decaykin3 lnbs_cwar  propex lnepr disc powerless regauton lbpol lsqbpolity decay , cluster(ccode) 
mlogit onsettype ldecaypactpart3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless  regauton lbpol lsqbpolity decay , cluster(ccode) 

logit onset ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay, cluster(ccode) 
logit onset ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex regauton  lbpol lsqbpolity decay, cluster(ccode) 
mlogit onsettype ldecayinpact3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay, cluster(ccode) 
mlogit onsettype ldecayinpart3 decaystateconf3 decaykin3 lnbs_cwar lnepr   disc powerless  propex  regauton lbpol lsqbpolity decay, cluster(ccode) 


*6. other robustness checks referred to in text

* (a) trimmed models (concessions plus significant controls only)
logit onset ldecaypact3 decaystateconf3 decaykin3 disc decay , cluster(eprid) 
logit onset ldecaypactpart3 decaystateconf3 decaykin3  disc decay , cluster(eprid) 
mlogit onsettype ldecaypact3 decaystateconf3 decaykin3 disc propex regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecaypactpart3 decaystateconf3 decaykin3 disc propex regauton lbpol lsqbpolity decay , cluster(eprid) 

logit onset ldecayinpact3 decaystateconf3 decaykin3 disc decay , cluster(eprid) 
logit onset ldecayinpart3 decaystateconf3 decaykin3  disc decay , cluster(eprid) 
mlogit onsettype ldecayinpact3 decaystateconf3 decaykin3 disc propex regauton lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecayinpart3 decaystateconf3 decaykin3 disc propex regauton lbpol lsqbpolity decay , cluster(eprid) 


* (b) concessions to kin groups*
* lagged variable coded 1 for year where kin group is granted concessions
logit onset lkinterrpact decaystateconf3 lnbs_cwar propex lnepr disc powerless regauton  lbpol lsqbpolity decay , cluster(eprid) 
logit onset lkinterrpact decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless regauton  lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype lkinterrpact decaystateconf3 lnbs_cwar propex lnepr disc powerless regauton  lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype lkinterrpact decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless regauton  lbpol lsqbpolity decay , cluster(eprid) 
* kin groups granted concessions modelled as a decaying function
logit onset ldecaykinpact3 decaystateconf3 lnbs_cwar propex lnepr disc powerless regauton  lbpol lsqbpolity decay , cluster(eprid) 
logit onset ldecaykinpact3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless regauton  lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecaykinpact3 decaystateconf3 lnbs_cwar propex lnepr disc powerless regauton  lbpol lsqbpolity decay , cluster(eprid) 
mlogit onsettype ldecaykinpact3 decaystateconf3 decaykin3 lnbs_cwar propex lnepr disc powerless regauton  lbpol lsqbpolity decay , cluster(eprid) 


