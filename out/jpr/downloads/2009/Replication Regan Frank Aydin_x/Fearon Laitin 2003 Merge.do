/*************************************************************/
/*                                                           */
/*               Do File for Merging                         */ 
/*   Regan et al.'s (2009) External Interventions Dataset    */
/*           with the Fearon & Laitin 2003                   */
/*               Replication Dataset                         */
/*                                                           */
/*************************************************************/

/********************************************************************/
/* paste pathway for Regan et al.'s External Interventions Dataset" */

use "diplomaticinterventions.dta"



/****************************************************/
/* collapsing our data to country-year observations */

destring duration, replace 

collapse (max) conflict diplomatic mediation forum arbitration recall offer request duration medstrat outcome timing length negrank groupneg unitcode unitcode1 unitcode2 unitcode3 unitcode4 unitcode5 unilat moi carter owen arnault rajivg conclaves mugabe UN US cch dipcount medcount unilatcount negmed medstmed outcomemed region success ccode year, by (cyr)

sort cyr

save "diplomatic collapsed.dta"



/************************************************/
/* paste pathway for Fearon & Laitin 2003 below */

use "repdata.dta", clear

gen cyr=(ccode*10000) + year

sort cyr



/***************************************************/
/* merging in the Diplomatic Interventions Dataset */

merge cyr using "diplomatic collapsed.dta"
tab _merge











