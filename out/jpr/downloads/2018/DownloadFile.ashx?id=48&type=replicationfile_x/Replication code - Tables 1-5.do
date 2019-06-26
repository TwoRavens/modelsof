*************************************************************
*															*
*      Tables 1-5, Walsh, Conrad, Whitaker & Hudak   		*
*    Funding Rebellion: The Rebel Contraband Dataset        *
*                        Stata 13                           *
*															*
*************************************************************

///Open the data file used to create tables 1-5

use "Replication data - Tables 1-5.dta"

set more off

*Table 1*
tab anystrategy
tab extortion
tab theft
tab smuggling
tab bf

*Table 2*
corr extortion theft smuggling bf

*Table 3*
tab crime
tab extortioncrime
tab theftcrime
tab smugglinghuman
tab smugglingother
tab humanitarianaid
tab piracy
tab kidnap
tab kidnapintl

*Table 4*
tab opium
tab timber
tab cannabis
tab coca
tab oil 
tab gold
tab agriculture
tab drugs
tab tea
tab diamondsalluvial

*Table 5*
tab extortion region
codebook dyadid if extortion==1 & region==1, d
codebook dyadid if extortion==1 & region==2, d
codebook dyadid if extortion==1 & region==3, d
codebook dyadid if extortion==1 & region==4, d
codebook dyadid if extortion==1 & region==5, d


tab smuggling region
codebook dyadid if smuggling==1 & region==1, d
codebook dyadid if smuggling==1 & region==2, d
codebook dyadid if smuggling==1 & region==3, d
codebook dyadid if smuggling==1 & region==4, d
codebook dyadid if smuggling==1 & region==5, d

tab theft region
codebook dyadid if theft==1 & region==2, d
codebook dyadid if theft==1 & region==4, d


tab bf region
codebook dyadid if bf==1 & region==1, d
codebook dyadid if bf==1 & region==4, d

exit

