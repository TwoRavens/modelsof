
/*	**********************************************************************	*/
/*	File Name: thyne_powell_FPA2013_repdata.dta								*/
/*	Date:	April 8, 2013													*/
/*	Author: Clayton L. Thyne												*/
/*	Purpose: This file replicates the regression results for 				*/
/*	Thyne, Clayton L., and Jonathan M. Powell. 2013. 'Coup d'eta or Coup 	*/
/*	d'Autocracy? How Coups Impact Democratization, 1950-2008.' Foreign 		*/
/*	Policy Analysis, forthcoming. 											*/
/*	Version: Stata 10 or above.												*/
/*	**********************************************************************	*/

*Table 1
logit dem coup_s prev_dem colbrit ind cold gdppc chgdppc time time2 time3, nolog
keep if e(sample)
logit dem coup_f prev_dem colbrit ind cold gdppc chgdppc time time2 time3, nolog
logit dem coup_a prev_dem colbrit ind cold gdppc chgdppc time time2 time3, nolog

*TABLE 2
logit dem coup_a polity prev_dem colbrit ind cold gdppc chgdppc time time2 time3,  nolog
logit dem coup_a inter1 polity prev_dem colbrit ind cold gdppc chgdppc time time2 time3,  nolog
logit dem coup_a yrs prev_dem colbrit ind cold gdppc chgdppc time time2 time3,  nolog
logit dem coup_a inter2 yrs prev_dem colbrit ind cold gdppc chgdppc time time2 time3,  nolog
