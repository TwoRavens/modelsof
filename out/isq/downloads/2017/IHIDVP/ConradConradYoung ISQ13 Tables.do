version 11.2

set more off


*********************************************************************************
*********************************************************************************
*   																			*
*  Replicate Table 1, 2 and 4 in Conrad, Conrad and Young (2013)                *
*   Data file:  ConradConradYoung ISQ13 Data.dta                                *
*  											                                    *
*                                                                               *
*********************************************************************************
*********************************************************************************

*****Table 1: Descriptive Statistics - Terrorist Attacks By Regime Type****

sum ITERATE GTDDomestic if demdum1w==1

sum ITERATE GTDDomestic if single1w==1

sum ITERATE GTDDomestic if military1w==1

sum ITERATE GTDDomestic if dynastic1w==1

sum ITERATE GTDDomestic if other1w==1

sum ITERATE GTDDomestic if personal1w==1

sum ITERATE GTDDomestic if nondynastic1w==1

sum ITERATE GTDDomestic if interregnaw==1

sum ITERATE GTDDomestic if interregnademw==1

sum ITERATE GTDDomestic if hybrid1w==1


*****Table 2: Negative Binomial analysis*******

***Model 1*****
nbreg ITERATE single1w military1w dynastic1w other1w personal1w  nondynastic1w interregnaw interregnademw hybrid1w rgdpllog  poplog historyITERATE conflict frac_eth frac_rel Europe Asia America Africa, robust 

est store ITERATE

estat ic

***Model 2****
nbreg GTDDomestic single1w military1w dynastic1w other1w personal1w  nondynastic1w interregnaw interregnademw hybrid1w rgdpllog  poplog historyGTD conflict frac_eth frac_rel Europe Asia America Africa, robust 

est store GTD

estat ic


****Table 4:  Zero-Inflated Negative Binomial analysis*******

****Model 3****
zinb ITERATE single1w military1w dynastic1w other1w personal1w  nondynastic1w interregnaw interregnademw  hybrid1w rgdpllog  poplog historyITERATE conflict frac_eth frac_rel Europe Asia America Africa, inflate(polity2) robust

est store ITERATEZ

estat ic

****Model 4****
zinb GTDDomestic single1w military1w dynastic1w other1w personal1w  nondynastic1w interregnaw interregnademw  hybrid1w rgdpllog  poplog historyGTD conflict frac_eth frac_rel Europe Asia America Africa, inflate(polity2) robust 

est store GTDZ 

estat ic

log close

exit
