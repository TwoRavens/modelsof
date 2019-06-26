**************************************
*Replication of Table III*
**************************************

*The STATA replication file from Forsberg 2008 was used, with two additional variables, new_ethcontagion and new_allcontagion.*

*Forsberg 2008, Model 3 (drawn from her replication do-file)*
logit beconset bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 

*Replication (of Model 3) with corrected ethnic contagion DV*
logit new_ethcontagion bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a)

*Forsberg 2008, Model 4 (drawn from her replication do-file)*
logit beconset ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay, cluster(cow_a) 

*Replication (of Model 4) with corrected ethnic contagion DV*
logit new_ethcontagion ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay, cluster(cow_a)

*Robustness checks*
*Rare events logit*

*Replication (of Model 3) with corrected ethnic contagion DV*
relogit new_ethcontagion bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a)

*Replication (of Model 4) with corrected ethnic contagion DV*
relogit new_ethcontagion ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay, cluster(cow_a)

*Using new_allcontagion instead of new_ethcontagion (see footnote 9).*

*Replication (of Model 3) with corrected contagion (ethnic or nonethnic) DV*

logit new_allcontagion bparity ckinfear ckinparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a)

*Replication (of Model 4) with corrected contagion (ethnic or nonethnic) DV*

logit new_allcontagion ckinfear bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial lawar boundarylength proximate decay, cluster(cow_a)

*Other models*

*Forsberg 2008, Model 1 (drawn from her replication do-file)*
logit beconset bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 

*Replication (of Model 1) with corrected ethnic contagion DV*
logit new_ethcontagion bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
relogit new_ethcontagion bparity llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 

*Forsberg 2008, Model 2 (drawn from her replication do-file)*
logit beconset bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 

*Replication (of Model 2) with corrected ethnic contagion DV*
logit new_ethcontagion bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
relogit new_ethcontagion bparity ckinfear llnbgdpex llnbpop lbpolex lsqbpolity laterritorial decay, cluster(cow_a) 
