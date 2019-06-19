* Code to do Table 11 in October 2014 version

use "C:\Romain\GeneticsWar\Territorial Changes Data\tc2008.dta" 
sort conflict
by conflict: sum fst_distance_weighted if indep==1
by conflict: sum fst_distance_weighted if indep==1 & losetype==1
by conflict: sum fst_distance_weighted if indep==1 & losetype==0
by conflict: sum fst_distance_weighted if losetype==0 & gaintype==1
by conflict: sum fst_distance_weighted if losetype==1 & gaintype==1
