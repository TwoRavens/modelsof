/*******************************************************************************

Stewart and Liou Replication Code
"Do Good Borders Make Good Rebels?"

This Code replicates descriptive figures shown in Figures 2-3 in the Main Text

Code Last Modified 6/15/2016 (Yu-Ming Liou)

*******************************************************************************/

use "GTD annual aggregates.dta", clear

sort insurgentnum year

*	Make Figure 2a:
twoway line oneside_best year if insurgentnum==531 ///
& year>1988 & year<1996, ///
ytitle("Civilians Killed", size(large))	///
xtitle("", size(large)) ///
xscale(range(1989 1995)) xlabel(1989(1)1995) ///
xline(1991) title("PKK One-Sided Violence 1989-1995") ///
scheme(s1color)

use "GTD annual aggregates.dta", clear

*	NB: Data coding note for GTD data:
*	Armed Targets are Defined as follows (wrt GTD codebook):
		*(in order): military, police, terrorist/militia groups, and violent political parties
		*unknown target types are coded as missing
		*Otherwise, targets are assumed to be unarmed

 *	Make Figure 2b:
twoway line annual_unarmed year if cname=="Turkey", ///
ytitle("Attacks on Civilian Targets", size(large))	///
xtitle("", size(large)) ///
xscale(range(1986 1995)) xlabel(1986(1)1995) ///
xline(1991) title("PKK Attacks on Civilian Targets: 1986-1995") ///
scheme(s1color)

*	Make Figure 3a:
twoway ///
(line annual_armed year, lpattern(solid)) ///
(line annual_unarmed year, lpattern(shortdash)) if cname=="Turkey", ///
ytitle("Annual Attacks", size(large))	///
xtitle("") ///
xscale(range(1986 1995)) xlabel(1986(1)1995) ///
xline(1991) title("PKK Attacks by Target Type: 1986-1995") ///
legend(order(1 "Armed Targets" 2 "Unarmed Targets") ///
 region(lwidth(none)) rows(1)) ///
scheme(s1mono) 

/*	Non-government civilian targets are defined as follows (wrt GTD codebook):
	busineses, educational institutions, food or water supply, journalists and
	media, NGO, private citizens and property, religious figures/institutions,
	tourists		
	
	Government Civilian Targets are defined as follows (wrt GTD codebook):
	Government (general), Government (diplomatic)
	
	Infrastructure Targets are defined as follows (wrt GTD codebook):
	Airports and Aircraft, Food or Water Supply, Maritime, Telecommunication, 
	Utilities
	
	Security Forces are defined as follows (wrt GTD codebook):
	Police, Military
*/
				
*	Make Figure 3b:
twoway ///
(line annual_gov_security year, lpattern(solid)) ///
(line annual_gov_civ year, lpattern(longdash_dot)) ///
(line annual_ng_civ_narrow year, lpattern(shortdash_dot)) ///
(line annual_infrastructure year, lpattern(dash)) if cname=="Turkey", ///
ytitle("Annual Attacks", size(large))	///
xtitle("") ///
xscale(range(1986 1995)) xlabel(1986(1)1995) ///
xline(1991) title("PKK Attacks by Target Type: 1986-1995") ///
legend(order(1 "Security Forces" 2 "Government Civilian" 3 "Non-Government Civilian" 4 "Infrastructure") ///
 region(lwidth(none)) rows(2))	///
scheme(s1mono) 
