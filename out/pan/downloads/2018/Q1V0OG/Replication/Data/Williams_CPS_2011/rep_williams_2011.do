clear

use "/Users/jonathanmummolo/Dropbox/Interaction Paper/Data/Included/_to_do/Williams_CPS_2011/Unsuccessful Success.dta"



//Table 1, Model 3
reg change opp_conf_elecdate opp_conf_party_elecdate majority gparties lag_pervote rgdppc_growth eff_par eoc eoc_p if xregbet==0, robust cluster(ccode)


generate sample = e(sample)

drop if sample!=1

saveold rep_williams_2011a, replace

//Table 1, Model 4
clear

use "/Users/jonathanmummolo/Dropbox/Interaction Paper/Data/Included/_to_do/Williams_CPS_2011/Unsuccessful Success.dta"

reg change opp_conf_elecdate opp_conf_party_elecdate majority gparties lag_pervote rgdppc_growth abs_rile ncm_all_abs_rile ncm_abs_rile if xregbet==0, robust cluster(ccode)


generate sample = e(sample)

drop if sample!=1

saveold rep_williams_2011b, replace
