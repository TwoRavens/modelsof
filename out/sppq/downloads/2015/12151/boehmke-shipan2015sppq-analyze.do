version 10
#delimit;
set more off;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; log close; };
log using boehmke-shipan2015sppq-analyze, replace text;


/*	************************************************************	*/
/*     	File Name:	boehmke-shipan2015sppq.do			*/
/*     	Date:   	January 23, 2012 				*/
/*      Author: 	Frederick J. Boehmke				*/
/*      Purpose:	This file replicates the negative binomial	*/
/*			regression results in Tables 1 and A.1, 	*/
/*			constructs the interpretations in Figures 1	*/
/*			and 2, and creates the graph for Figure A.2.	*/
/*      Input File: 	boehmke-shipan2015sppq.dta,			*/
/*     			boehmke-shipan2015sppq-federal.dta		*/
/*      Output File:	boehmke-shipan2015sppq-analyze.log		*/
/*      		boehmke-shipan2015sppq-fig1.gph,		*/
/*      		boehmke-shipan2015sppq-fig2.gph,		*/
/*      		boehmke-shipan2015sppq-figA1.gph,		*/
/*      		boehmke-shipan2015sppq-table1.txt,		*/
/*      		boehmke-shipan2015sppq-tableA1.txt		*/
/*	Version:	Stata 10 or above.				*/
/*	************************************************************	*/

use boehmke-shipan2015sppq, clear;

  egen stateyear = group(state year);
  
  
	/**************************/
	/* Run models in Table 1. */
	/**************************/

		/* Table 1, Model 1. */

nbreg def_all govdem leg_dem_pct legp_squire_ipol citi6010
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year i.stateno if hlthsurv==1, cluster(stateyear);
		
  estimates store t1m1;
	
		/* Generate table of summary statistics. */
	
  tabstat def_all govdem leg_dem_pct legp_squire_ipol citi6010 unifiedD unifiedR
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp if e(sample), 
	stats(mean sd min max N) columns(statistics) format(%10.2f);
  
		/* Table 1, Model 2. */
	
nbreg def_all govdem leg_dem_pct legp_squire_ipol leg_dem_pct_legp citi6010
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year i.stateno if hlthsurv==1, cluster(stateyear);
	
  estimates store t1m2;
	
		/* Table 1, Model 3. */

nbreg def_all govdem leg_dem_pct legp_squire_ipol unifiedD unifiedR 
	leg_dem_pct_legp citi6010
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year i.stateno if hlthsurv==1, cluster(stateyear);
	
  estimates store t1m3;
	

	/**********************/
	/* Generate Table 1. */
	/**********************/


estout t1m1 t1m2 t1m3 using boehmke-shipan2015sppq-table1.txt, replace
	cells(b(fmt(3) star) se(par))
	modelwidth(6) 
	starlevels(* 0.1 ** 0.05 *** 0.01) legend
	label varwidth(45)
	collabels(, none)
	mlabels( , none)
	drop(2002.year 1.stateno) order(leg_dem_pct legp_squire_ipol leg_dem_pct_legp);

	
	/**********************/
	/* Generate Figure 1. */
	/**********************/

		/* Restore results for model 2 - this is not Figure 1, but the analogue for model 2. */

estimates restore t1m2;
  
  grinter leg_dem_pct, const02(legp_squire_ipol) inter(leg_dem_pct_legp) equation(def_all)
	kdensity yline(0) graphregion(fcolor(white))
	name(pctdem, replace);
		
  grinter legp_squire_ipol, const02(leg_dem_pct) inter(leg_dem_pct_legp) equation(def_all)
	kdensity yline(0) xline(0.5, lcolor(gs4)) graphregion(fcolor(white))
	name(legp, replace);
		
		/* Restore results for model 3 for Figure 1. */

estimates restore t1m3;
  
  grinter leg_dem_pct, const02(legp_squire_ipol) inter(leg_dem_pct_legp) equation(def_all)
	kdensity yline(0) graphregion(fcolor(white))
	name(pctdem, replace);
		
  grinter legp_squire_ipol, const02(leg_dem_pct) inter(leg_dem_pct_legp) equation(def_all)
	kdensity yline(0) xline(0.5, lcolor(gs4)) graphregion(fcolor(white))
	name(legp, replace);
		
  graph combine pctdem legp, scheme(s1mono)
	rows(2) 
	xsize(6.5) ysize(7.5)
	saving(boehmke-shipan2015sppq-fig1, replace asis);		
	

	/**********************/
	/* Generate Figure 2. */
	/**********************/

		/* Set the model to interpret. */
	
estimates restore t1m3;

		/* Set professionalism at chosen values for interpretation. */
		/* Note the paper incorrectly says we use 14 and 86th percentiles */
		/* of professionalism, which is incorrect - we use 25 and 75th. */
		/* Change to r(p14) and r(p86) to see that if desired. */
	
summarize legp_squire_ipol if e(sample), detail;
	
  local legp_low = r(p25);
  local legp_hi  = r(p75);

		/* Get min and max of %Dem to set range. */
	
summarize leg_dem_pct if e(sample);

  local dem_min = r(min);
  local dem_max = r(max);

		/* Set the variables at mean, min, or modal values. */
  
collapse (mean) leg_dem_pct legp_squire_ipol citi6010 rnhrspc cnahrspc bedsocc numres 
	(min) unifiedD unifiedR year*  
	(p50) med_caid own_nonp med_both hospital multiown own_prof govdem 
	if e(sample);

		/* Independent governor. */
	
  replace govdem = 0.5;

		/* Create 2 observations for high and low values of professionalism. */
  
expand 2;

		/* Set hypothetical values of professionalism into the data set. */
  
  replace legp_squire_ipol = `legp_low' in 1;
  replace legp_squire_ipol = `legp_hi' in 2;
  
  generat sim = 1 in 1;
  replace sim = 2 in 2;
  
		/* Create 100 observations of each to vary %Dem from min to max. */
  
expand 100;

  bysort sim: gen increment = _n;

  replace leg_dem_pct = `dem_min' + increment*(`dem_max' - `dem_min')/100 if sim==1;
  replace leg_dem_pct = `dem_min' + increment*(`dem_max' - `dem_min')/100 if sim==2;

		/* Regenerate the interaction. */
  
generat leg_dem_pct_legp = leg_dem_pct*legp_squire_ipol;

  sort legp_squire_ipol leg_dem_pct;

		/* Set a stateno for fixed effects. */
  
  generat stateno = 14;
  
  summarize;
  
		/* Predict expected count and 95% CI. */
  
predict yhat, n;
predict xbhat, xb;
predict xbhat_sd, stdp;

generat yhat_hi = exp(xbhat + 1.96*xbhat_sd);
generat yhat_lo = exp(xbhat - 1.96*xbhat_sd);

		/* Create the graphs and combine. */
	
twoway rarea yhat_lo yhat_hi leg_dem_pct if sim==1, scheme(s1mono)
	color(gs8) lwidth(thin)
  || line yhat leg_dem_pct if sim==1,
	lcolor(gs0) lpattern(solid)
	xtitle(Proportion Democrat) ytitle(Predicted Citations)
	ylabel(0(3)12, grid)
	title("Low Legislative Professionalism") 
	xsize(6.5) ysize(5)
	legend(off)
	name(sim1, replace);

twoway rarea yhat_lo yhat_hi leg_dem_pct if sim==2, scheme(s1mono)
	color(gs8) lwidth(thin)
  || line yhat leg_dem_pct if sim==2,
	lcolor(gs0) lpattern(solid)
	xtitle(Proportion Democrat) ytitle(Predicted Citations)
	ylabel(0(3)12, grid)
	title("High Legislative Professionalism")
	legend(off)
	name(sim2, replace);

  graph combine sim1 sim2, scheme(s1mono)
	ycommon imargin(tiny) altshrink
	xsize(6.5) ysize(3)
	saving(boehmke-shipan2015sppq-fig2, replace);
	

	/****************************/
	/* Run models in Table A.1. */
	/****************************/


use boehmke-shipan2015sppq, clear;

  egen stateyear = group(state year);
  encode provnum, generat(provid);
	  
nbreg def_all govdem leg_dem_pct legp_squire_ipol unifiedD unifiedR 
	leg_dem_pct_legp citi6010
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year i.stateno if hlthsurv==1 & state!="CA", cluster(stateyear);
		
  estimates store tA1m1;
  
nbreg def_all govdem leg_dem_pct legp_squire_ipol unifiedD unifiedR 
	leg_dem_pct_legp citi6010 termlimits
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year i.stateno if hlthsurv==1, cluster(stateyear);
	
  estimates store tA1m2;
  
nbreg def_all govdem leg_dem_pct legp_squire_ipol unifiedD unifiedR 
	leg_dem_pct_legp citi6010
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year i.stateno if firesurv==1, cluster(stateyear);
	
  estimates store tA1m3;
  
xtpoisson def_all govdem leg_dem_pct legp_squire_ipol unifiedD unifiedR 
	leg_dem_pct_legp citi6010 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year if hlthsurv==1, fe i(provid) vce(robust);

  estimates store tA1m4;

xtnbreg def_all govdem leg_dem_pct legp_squire_ipol unifiedD unifiedR 
	leg_dem_pct_legp citi6010 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year if hlthsurv==1, fe i(provid);

    estimates store tA1m5;


	/***********************/
	/* Generate Table A.1. */
	/***********************/


estout tA1m1 tA1m2 tA1m3 tA1m4 tA1m5 using boehmke-shipan2015sppq-tableA1.txt, replace 
	cells(b(fmt(3) star) se(par))
	modelwidth(6) 
	starlevels(* 0.1 ** 0.05 *** 0.01) legend
	label varwidth(45)
	collabels(, none)
	drop(2002.year 1.stateno) order(leg_dem_pct legp_squire_ipol leg_dem_pct_legp)
	mlabels("No CA" "Term Limits" "Fire Surveys" "FE Poisson" "FE NB");


	/************************/
	/* Generate Figure A.1. */
	/************************/


use boehmke-shipan2015sppq-federal, clear;

twoway qfitci missedDLavg leg_dem_pct, scheme(s1mono)
  || 	scatter missedDLavg leg_dem_pct, 
	mcolor(black) msymbol(O) msize(small)
	ylabel(#5, grid)
	ytitle(Missed Citations)
	xtitle(Percent Democrat)
	legend(off)
	saving(boehmke-shipan2015sppq-figA1, replace);

log close;
clear;
exit, STATA;