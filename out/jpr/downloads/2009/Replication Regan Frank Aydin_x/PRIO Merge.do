

/***************************************************************/
/*                                                             */
/*               Do File for Merging                           */ 
/*   Regan et al.'s (2009) Diplomatic Interventions Dataset    */
/*              with the Uppsala/PRIO                          */
/*               Annual Onset Dataset                          */
/*   see  Gleditsch et al. (2002) and Strand (2006)            */
/*                                                             */
/***************************************************************/

/**********************************************************************/
/* paste pathway for Regan et al.'s Diplomatic Interventions Dataset" */

use "diplomaticinterventions.dta"



/****************************************************/
/* collapsing our data to country-year observations */

destring duration, replace 

collapse (max) conflict diplomatic mediation forum arbitration recall offer request duration medstrat outcome timing length negrank groupneg unitcode unitcode1 unitcode2 unitcode3 unitcode4 unitcode5 unilat moi carter owen arnault rajivg conclaves mugabe UN US cch dipcount medcount unilatcount negmed medstmed outcomemed region success ccode year, by (cyr)

sort cyr

/* enter desired pathway */
save "diplomatic collapsed.dta", replace




/*************************************************/
/* paste pathway for the Annual Onset data below */

use "repdata.dta", clear

gen cyr=(gwno*10000) + year

sort cyr



/*************************************************************/
/* merging in the Diplomatic Interventions Dataset */

/* paste desired pathway below */
merge cyr using "diplomatic collapsed.dta"
tab _merge











