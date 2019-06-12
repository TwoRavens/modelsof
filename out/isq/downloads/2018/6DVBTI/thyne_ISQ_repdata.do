version 10
#delimit;
clear;
set more off;
set mem 200m; 

/*	**********************************************************************	*/
/*	File Name: thyne_ISQ_repdata.do											*/
/*	Date:	January 5, 2011													*/
/*	Author: Clayton L. Thyne												*/
/*	Purpose: This file replicates the regression results for 				*/
/*	Thyne, Clayton L. 'Information, Commitment, and Intra-war Bargaining:	*/
/*	The Effect of Governmental Constraints on Civil War Duration.'			*/
/*	International Studies Quarterly, 2012.									*/
/*	Input File #1: thyne_ISQ_repdata.dta									*/
/*	Version: Stata 10 or above.												*/
/*	**********************************************************************	*/


/* Table I. Impact of Information Variables on the Duration of Civil War */

use thyne_ISQ_repdata.dta, clear;

streg info_index lenient lnbdead lngdppc fight_gov powthy_a lfor , d(w) nolog time robust ;
streg commitment_index lenient lnbdead lngdppc fight_gov powthy_a lfor , d(w) nolog time robust ;
streg veto_index lenient lnbdead lngdppc fight_gov powthy_a lfor, d(w) nolog time robust ;
streg xconst lenient lnbdead lngdppc fight_gov powthy_a lfor , d(w) nolog time robust ;
streg eiec lenient lnbdead lngdppc fight_gov powthy_a lfor , d(w) nolog time robust ;
streg polariz lenient lnbdead lngdppc fight_gov powthy_a lfor, d(w) nolog time robust ;
streg parl_exc lenient lnbdead lngdppc fight_gov powthy_a lfor , d(w) nolog time robust ;
streg parl_exc lenient lnbdead lngdppc fight_gov powthy_a lfor   if eiec>=6 & eiec~=., d(w) nolog time robust ;
streg yrsoffc lenient lnbdead lngdppc fight_gov powthy_a lfor , d(w) nolog time robust ;
streg prtyin lenient lnbdead lngdppc fight_gov powthy_a lfor , d(w) nolog time robust ;
