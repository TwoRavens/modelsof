version 13
set more off
clear
  quietly log
  local logon = r(status)
  if "`logon'" == "on" { 
	log close 
	}
log using JB_PA2016_ChiozzaGoemans2004-mkdata, text replace


/*	****************************************************************	*/
/*     	File Name:	JB_PA2016_ChiozzaGoemans2004-mkdata.do			*/
/*     	Date:   	October 31, 2016					*/
/*      Author: 	Shuai Jin and Frederick J. Boehmke			*/
/*      Purpose:	Set up data from Chiozza and Goemans 2004 article for	*/
/*			reanalysis of NPH correction.				*/
/*      Input File:	toR.dta						 	*/
/*      Output File:	JB_PA2016_ChiozzaGoemans2004-mkdata.log			*/
/*			JB_PA2016_ChiozzaGoemans2004-mkdata.dta			*/
/*	****************************************************************	*/

use toR, clear 

		/* -stset- the data. */

  stset endobs, id(leadid) failure(fail==1) origin(time eindate) enter(time startobs)  /*scale(365.25) */

		/* Split to set up data with one obversation for every failure time (days) rather than annually. */
	
stsplit, at(failures)

		/* -stset- the data again. */

  stset endobs, id(leadid) failure(fail==1) origin(time eindate) enter(time startobs)  /*scale(1) */

	drop t t0 st d origin

	/* Rename the variables created by -stset- to match the R code for estimation. */

  rename _d d
  rename _t0 t0
  rename _t t
  rename _origin origin
  rename _st st
	
  compress
  
  saveold JB_PA2016_ChiozzaGoemans2004-mkdata, replace version(12)
  
clear
log close
exit, STATA
