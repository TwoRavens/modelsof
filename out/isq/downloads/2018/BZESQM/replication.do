version 10
#delimit;
clear;
set more off;
set mem 200m; 

/*	**********************************************************************	*/
/*	File Name: replication.do												*/
/*	Date:	May 6, 2010														*/
/*	Author: Clayton L. Thyne												*/
/*	Purpose: This file replicates the regression results for 				*/
/*	Crescenzi, Mark J., Kelly M. Kadera, Sara McLaughlin Mitchell, and		*/
/*	Clayton L. Thyne. 'A Supply Side Theory of Third Party Conflict			*/
/*	Management.' International Studies Quarterly, 2011. 					*/
/*	Input File #1: ckmtISQ2011.dta											*/
/*	Version: Stata 10 or above.												*/
/*	**********************************************************************	*/


/* Table I. Mediation Attempts and Success */

use ckmtISQ2011.dta, clear;

probit media PM_polity global_dem shared_ios trade_bias ally_bias MTdistancel relcap PM_cinc icowsal maritime river if region==1, robust nolog;

heckprob agree PM_polity global_dem shared_ios trade_bias ally_bias MTdistancel relcap if region==1, 
sel(media = PM_polity global_dem shared_ios trade_bias ally_bias MTdistancel relcap PM_cinc icowsal maritime river) robust;

probit media PM_polity global_dem shared_ios trade_bias ally_bias MTdistancel relcap PM_cinc icowsal maritime river, robust nolog;

heckprob agree PM_polity global_dem shared_ios trade_bias ally_bias MTdistancel relcap  ,
sel(media = PM_polity global_dem shared_ios trade_bias ally_bias MTdistancel relcap PM_cinc icowsal maritime river) robust;
