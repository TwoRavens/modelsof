* This file replicates the results in:
* Forsberg, Erika. 2014. 
*"Transnational Transmitters: Ethnic Kinship Ties and Conflict Contagion 1946-2009”
* International Interactions
* copy as do-file and use with the dataset "kinship_repdata.dta"
*****************************************************************************


*TABLE I
logit beconset ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a) 
logit beconset dkinconc laanyconc ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
logit beconset dkinvictory larebelvictory ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)

*substantial interpretations of table I

*effect of ethnickin
quietly logit beconset ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a) 
prvalue, x(ethnickin=1 bparity=0 awar=0 aterritorial=0) rest(mean)
prvalue, x(ethnickin=0 bparity=0 awar=0 aterritorial=0) rest(mean) 

*reversed composite terms (for interpretation of interaction terms in Model 2 and 3)
logit beconset dkinnotconc notconc ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
logit beconset dkinnotvictory notvictory ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)

* test for joint significance of polity and polity squared
quietly logit beconset ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a) 
test lbpol lsqbpolity
quietly logit beconset dkinconc laanyconc ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
test lbpol lsqbpolity
quietly logit beconset dkinvictory larebelvictory ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
test lbpol lsqbpolity


*ROBUSTNESS TESTS OF RESULTS IN TABLE I (IN ONLINE APPENDIX)

*rare events logit
relogit beconset ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a) 
relogit beconset dkinconc laanyconc ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
relogit beconset dkinvictory larebelvictory ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)

*alternatives for spatial autocorrelation
logit beconset ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_b) 
logit beconset dkinconc laanyconc ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_b)
logit beconset dkinvictory larebelvictory ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_b)

logit beconset ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(dyadID) 
logit beconset dkinconc laanyconc ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(dyadID)
logit beconset dkinvictory larebelvictory ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(dyadID)

*alternatives for temporal autocorrelation
logit beconset ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay if within950==1, cluster(cow_a) 
logit beconset dkinconc laanyconc ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay if within950==1, cluster(cow_a)
logit beconset dkinvictory larebelvictory ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay if within950==1, cluster(cow_a)

logit beconset ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay3 if within950==1, cluster(cow_a) 
logit beconset dkinconc laanyconc ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay3 if within950==1, cluster(cow_a)
logit beconset dkinvictory larebelvictory ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay3 if within950==1, cluster(cow_a)

*alternative operationalization of ethnickin
logit beconset ldecaykin3 bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a) 
logit beconset ldecaykin1 bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a) 

*alternative risk periods
logit beconset ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears3==1, cluster(cow_a) 
logit beconset dkinconc laanyconc ethnickin   bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears3==1, cluster(cow_a)
logit beconset dkinvictory larebelvictory ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears3==1, cluster(cow_a)

logit beconset ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears1==1, cluster(cow_a) 
logit beconset dkinconc laanyconc ethnickin   bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears1==1, cluster(cow_a)
logit beconset dkinvictory larebelvictory ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears1==1, cluster(cow_a)

*additional control variable
*add military spending
logit beconset ethnickin llnmilspend bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a) 
logit beconset dkinconc laanyconc ethnickin  llnmilspend bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
logit beconset dkinvictory larebelvictory ethnickin llnmilspend bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)

*alternative sampling techniques
*direct neighbors 
logit beconset ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if directneigh==1, cluster(cow_a) 
logit beconset dkinconc laanyconc ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if directneigh==1, cluster(cow_a)
logit beconset dkinvictory larebelvictory ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if directneigh==1, cluster(cow_a)

*within 100km
logit beconset ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within100==1, cluster(cow_a) 
logit beconset dkinconc laanyconc ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within100==1, cluster(cow_a)
logit beconset dkinvictory larebelvictory ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within100==1, cluster(cow_a)

*within same neighborhood
logit beconset ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if samehood==1, cluster(cow_a) 
logit beconset dkinconc laanyconc ethnickin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if samehood==1, cluster(cow_a)
logit beconset dkinvictory larebelvictory ethnickin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if samehood==1, cluster(cow_a)

*TABLE II
logit beconset discrkin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
logit beconset autokin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
logit beconset conckin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
logit beconset largekin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)

*substantial interpretations of table II
quietly logit beconset discrkin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
prvalue, x(discrkin=1 bparity=0 awar=0 aterritorial=0) rest(mean)
prvalue, x(discrkin=0 bparity=0 awar=0 aterritorial=0) rest(mean)

logit beconset autokin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
tab beconset autonomykin if bparity !=. & llnbgdp !=. & llnbpop !=. & lbpol !=. & lsqbpolity !=. & awar!=. & aterritorial !=. & within950==1

quietly logit beconset conckin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
prvalue, x(conckin=1 bparity=0 awar=0 aterritorial=0) rest(mean)
prvalue, x(conckin=0 bparity=0 awar=0 aterritorial=0) rest(mean)

quietly logit beconset largekin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
prvalue, x(largekin=1 bparity=0 awar=0 aterritorial=0) rest(mean)
prvalue, x(largekin=0 bparity=0 awar=0 aterritorial=0) rest(mean)


*ROBUSTNESS TESTS OF RESULTS IN TABLE II (IN ONLINE APPENDIX)

*rare events logit
relogit beconset discrkin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
relogit beconset autokin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
relogit beconset conckin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
relogit beconset largekin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)

*alternatives for spatial autocorrelation
logit beconset discrkin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_b)
logit beconset autokin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_b)
logit beconset conckin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_b)
logit beconset largekin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_b)

logit beconset discrkin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(dyadID)
logit beconset autokin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(dyadID)
logit beconset conckin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(dyadID)
logit beconset largekin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(dyadID)

*alternatives for temporal autocorrelation
logit beconset discrkin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay if within950==1, cluster(cow_a)
logit beconset autokin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay if within950==1, cluster(cow_a)
logit beconset conckin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay if within950==1, cluster(cow_a)
logit beconset largekin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay if within950==1, cluster(cow_a)

logit beconset discrkin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay3 if within950==1, cluster(cow_a)
logit beconset autokin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay3 if within950==1, cluster(cow_a)
logit beconset conckin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay3 if within950==1, cluster(cow_a)
logit beconset largekin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay3 if within950==1, cluster(cow_a)


*alternative risk periods
logit beconset discrkin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears3==1, cluster(cow_a)
logit beconset autokin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears3==1, cluster(cow_a)
logit beconset conckin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears3==1, cluster(cow_a)
logit beconset largekin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears3==1, cluster(cow_a)

logit beconset discrkin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears1==1, cluster(cow_a)
logit beconset autokin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears1==1, cluster(cow_a)
logit beconset conckin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears1==1, cluster(cow_a)
logit beconset largekin  bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1 & riskyears1==1, cluster(cow_a)

*additional control variable
*add milspend
logit beconset discrkin llnmilspend bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
logit beconset autokin llnmilspend bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
logit beconset conckin llnmilspend bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)
logit beconset largekin llnmilspend bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within950==1, cluster(cow_a)


*alternative sampling techniques
*direct neighbors 
logit beconset discrkin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if directneigh==1, cluster(cow_a)
logit beconset autokin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if directneigh==1, cluster(cow_a)
logit beconset conckin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if directneigh==1, cluster(cow_a)
logit beconset largekin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if directneigh==1, cluster(cow_a)

*within 100km
logit beconset discrkin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within100==1, cluster(cow_a)
logit beconset autokin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within100==1, cluster(cow_a)
logit beconset conckin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within100==1, cluster(cow_a)
logit beconset largekin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if within100==1, cluster(cow_a)

*within same neighborhood hood
logit beconset discrkin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if samehood==1, cluster(cow_a)
logit beconset autokin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if samehood==1, cluster(cow_a)
logit beconset conckin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if samehood==1, cluster(cow_a)
logit beconset largekin bparity llnbgdp llnbpop lbpol lsqbpolity awar aterritorial decay2 if samehood==1, cluster(cow_a)


