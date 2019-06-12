*********************
* MAIN DV: sumstateact_indep (total number of state actions in a month)
* IV1: months_to_nextpar (months to next parliamentary elections)
* IV2: right: higher numbers more right oriented.
**********************
 
 
 
clear 
use "/Users/denizaksoy/Desktop/GOVRESPONSE_JOP.dta" 
 
*interaction term
gen interaction=right* months_to_nextpar

 
  
*MODEL I 
nbreg sumstateact_indep interaction months_to_nextpar right sumattacks lngdp_pcap lnpop coldwar     countrydummy1-countrydummy15  , cluster(ccode)
 
 
*MODEL II-Lagged DV
nbreg sumstateact_indep interaction months_to_nextpar right   lngdp_pcap lnpop coldwar sumattacks lag_sumstateact_indep  countrydummy1-countrydummy15  , cluster(ccode)

*MODEL III HISTORY OF ATTACKS control 
nbreg sumstateact_indep lag_sumstateact_indep   interaction months_to_nextpar right  sumattacks history   lngdp_pcap lnpop coldwar    countrydummy1-countrydummy15, cluster(ccode)
 
*MODEL IV --earlyelectinos
nbreg sumstateact_indep earlyelect  lag_sumstateact_indep   interaction months_to_nextpar right  sumattacks history   lngdp_pcap lnpop coldwar    countrydummy1-countrydummy15, cluster(ccode)

*MODEL V --decade dummies
nbreg sumstateact_indep earlyelect  lag_sumstateact_indep   interaction months_to_nextpar right  sumattacks history   lngdp_pcap lnpop coldwar    countrydummy1-countrydummy15 decade_50-decade_90, cluster(ccode)
 
 
*MODEL VI --casualties
nbreg sumstateact_indep sumdead earlyelect  lag_sumstateact_indep   interaction months_to_nextpar right  sumattacks history   lngdp_pcap lnpop coldwar    countrydummy1-countrydummy15 decade_50-decade_90, cluster(ccode)
  
 
