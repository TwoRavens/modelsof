version 10
#delimit;
set more off;
clear;
set memory 500m;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; log close; };
log using boehmke2018sppq, text replace;


/*	************************************************************	*/
/*  File Name:		boehmke2018sppq.do                              */
/*  Date:   		April 18, 2018                                  */
/*  Author: 		Frederick J. Boehmke                            */
/*  Purpose:		This file replicates the summary statistics     */
/*					and negative binomial regression results in     */
/*					Tables 1-5 and constructs the interpretation    */
/*					in Figure 1. It also runs robustness tests.		*/
/*  Input File: 	boehmke2018sppq.dta,							*/
/*     				boehmke2018sppq-nh-allstates.dta,				*/
/*     				boehmke2018sppq-cont-all.dta,					*/
/*     				boehmke2018sppq-cont-matched.dta,				*/
/*     				boehmke2018sppq-WI.dta,							*/
/*     				boehmke2018sppq-CA.dta							*/
/*  Output File: 	boehmke2018sppq-analyze.log,					*/
/*      			boehmke2018sppq-fig1.gph,						*/
/*      			boehmke2018sppq-table3.txt,						*/
/*      			boehmke2018sppq-table4.txt						*/
/*	Requires:		zinbcv.ado, grinter.ado, estout.ado				*/
/*	Version:		Stata 10 or above.								*/
/*	************************************************************	*/


		/**************************************************************/
		/* Generate information about nursing facilities for Table 1. */
		/**************************************************************/

		
use boehmke2018sppq-nh-allstates, clear;

  generat def_all_none = 1 if def_all == 0;
  replace def_all_none = 0 if def_all >= 1 & !missing(def_all);
  
  generat def_sev_none = 1 if def_sev == 0;
  replace def_sev_none = 0 if def_sev >= 1 & !missing(def_sev);
  
	/* Generate count of unique facilities per states. */
  
  egen num_facil = group(state provnum);
  
	egen num_facil_min = min(num_facil), by(state);
	egen num_facil_max = max(num_facil), by(state);
	
	generat num_facil_st = num_facil_max - num_facil_min + 1;

	/* Mark the 16 states used in the study. */
	
  generat sample = 0;
  replace sample = 1 if inlist(state, "AR", "CT", "GA", "IN", "LA", "MA", "MI", "MN");
  replace sample = 1 if inlist(state, "MS", "NC", "OH", "OK", "OR", "WA", "WI", "WV");
	
	/* This gives averages and counts in Table 1 for the 16 states in the study. */

  table state if sample==1, contents(mean def_all mean def_sev mean def_all_none mean def_sev_none mean predctbl) format(%9.2f);
  table state if sample==1, contents(mean elapsed count def_all mean num_facil_st) format(%9.0f);
	
	/* Generate the averages and counts across all 50 states. */

  collapse (mean) def_all def_sev def_all_none def_sev_none predctbl (count) numsurv=def_all (mean) num_facil_st, by(state);
  
	/* This gives the average, min, and max across all 50 states for Table 1. */
	/* Weight facility-specific terms to make sure the average is correct; do not weight state-level terms. */
  
  tabstat def_all def_sev def_all_none def_sev_none predctbl [fw=numsurv], statistics(mean min max) format(%9.2f);
  tabstat numsurv num_facil_st, statistics(mean min max) format(%9.0f);
  
  
		/*********************************************************/
		/* Generate information about contributions for Table 1. */
		/*********************************************************/

	/* First for all NH contributions for all states. */

use boehmke2018sppq-cont-all, clear;

  keep if state_rec == state_donor;
  keep if year >= 2002;

  table state_rec, c(sum cont_amnt) row format(%10.0f);
  
	/* Generate the average, min, and max across all 50 states. */
  
  
  collapse (sum) cont_amnt, by(state_rec);

  tabstat cont_amnt, statistics(mean min max) format(%10.0f) columns(variables);

  
	/* Then for matched contributions for the 16 states in the study. */

use boehmke2018sppq-cont-matched, clear;

  keep if cont_rec_state==cont_state;
  keep if year >= 2002;

  table cont_rec_state, c(sum cont_amnt) row format(%10.0f);

	/* Generate the average, min, and max for the 16 states in the study. */
  
  collapse (sum) cont_amnt, by(cont_rec_state);

  tabstat cont_amnt, statistics(mean min max) format(%10.0f) columns(variables);
		
		
		/**************************************/
		/* Run models for and output Table 3. */
		/**************************************/

		
use boehmke2018sppq, clear;

	/* Convert contributions to ten-thousands of dollars and */
	/* use common name to help with table formatting.        */ 

generat cont_days_tth     = cont_close/10000;
generat cont_days_bef_tth = cont_pre/10000;
generat cont_days_aft_tth = cont_post/10000;

	/* Table 3, model 1. */
  
xi: nbreg def_all cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);
	
	estimates store T3M1;

	/* Table 3, model 4. */
  
xi: nbreg def_sev cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

	estimates store T3M4;

	/* Table 3, model 2. */
  
xi: nbreg def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

	estimates store T3M2;

	/* Table 3, model 5. */
  
xi: nbreg def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

	estimates store T3M5;

	/* Table 3, model 3. */
	
replace cont_days_bef_tth = cont_180bef/10000;
replace cont_days_aft_tth = cont_180aft/10000;

xi: nbreg def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

	estimates store T3M3;

	/* Table 3, model 6. */
  
xi: nbreg def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

	estimates store T3M6;
	
	/* Output Table 3. */
	/* Make sure to install estout.ado if needed. */
		
estout T3M1 T3M2 T3M3 T3M4 T3M5 T3M6 using boehmke2018sppq-table3.txt, replace
	cells(b(fmt(2) star) se(par))
	stats(N, fmt(%9.0f))
	modelwidth(6) 
	starlevels(* 0.1 ** 0.05) legend
	label varwidth(30)
	collabels(, none)
	mlabels( , none)
	transform(lnalpha: exp(@) exp(@))
	order(cont_days_tth cont_days_bef_tth cont_days_aft_tth);

	
		/*********************************************/
		/* Generate Table 2 using estimation sample. */
		/*********************************************/

		
tabstat def_all def_sev cont_close cont_pre cont_post cont_180bef cont_180aft cont_gov_close 
	cont_gov_bef cont_gov_aft cont_leg_close cont_leg_bef cont_leg_aft 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp legprof if e(sample),
	statistics(mean sd min max) columns(statistics) format(%9.2f);


		/**************************************/
		/* Run models for and output Table 4. */
		/**************************************/
		
	
xi: nbreg def_all cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

	estimates store T4M1;
	
xi: nbreg def_all cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, cluster(provnum);

	estimates store T4M2;
	
xi: nbreg def_sev cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

	estimates store T4M3;
	
xi: nbreg def_sev cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, cluster(provnum);

	estimates store T4M4;
	
	/* Output Table 4. */
		
estout T4M1 T4M2 T4M3 T4M4 using boehmke2018sppq-table4.txt, replace
	cells(b(fmt(2) star) se(par))
	stats(N, fmt(%9.0f))
	modelwidth(6) 
	starlevels(* 0.1 ** 0.05) legend
	label varwidth(40)
	collabels(, none)
	mlabels( , none)
	transform(lnalpha: exp(@) exp(@))
	order(cont_leg_close_tth cont_leg_close_tth cont_leg_close_tth_legprof);


		/**********************/
		/* Generate Figure 1. */
		/**********************/

		
	/* Use -grinter- to plot marginal effect of conributions to the legislature on all deficiencies. */
	/* Make sure to install grinter.ado if needed. */
		
estimates restore T4M2;
		
  grinter cont_leg_close_tth, inter(cont_leg_close_tth_legprof) const02(legprof) equation(def_all) kdensity 
	scheme(s1mono) clevel(90) lcolor(black black black) kdoptions(lcolor(gs11) lpattern(solid) ytitle("", axis(2)))
	title(All Deficiencies)
	yline(0) ytitle(Marginal Effect) ylabel(#5, grid)  ylabel(none, axis(2)) yscale(range(1 15) axis(2))
	xtitle(Legislative Professionalism) xlabel(0(0.1)0.5) 
	nomeantext nonote
	name(def_all, replace);

	/* Calculate estimated effect and significance. */
	
  forvalues num=0(0.05)0.50 {;

	lincom [def_all]_b[cont_leg_close_tth] + `num'*[def_all]_b[cont_leg_close_tth_legprof];

	};

	/* Use -grinter- to plot marginal effect of conributions to the legislature on severe deficiencies. */
		
estimates restore T4M4;
		
  grinter cont_leg_close_tth, inter(cont_leg_close_tth_legprof) const02(legprof) equation(def_sev) kdensity 
	scheme(s1mono) clevel(90) lcolor(black black black) kdoptions(lcolor(gs11) lpattern(solid) ytitle("", axis(2)) )
	title(Severe Deficiencies)
	yline(0) ytitle(Marginal Effect) ylabel(#5, grid)ylabel(none, axis(2)) yscale(range(1 15) axis(2))
	xtitle(Legislative Professionalism) xlabel(0(0.1)0.5) 
	nomeantext nonote
	name(def_sev, replace);

	/* Calculate estimated effect and significance. */
	
  forvalues num=0(0.05)0.50 {;

	lincom [def_sev]_b[cont_leg_close_tth] + `num'*[def_sev]_b[cont_leg_close_tth_legprof];

	};
		
	
graph combine def_all def_sev, scheme(s1mono) 
	cols(1) imargin(small) 
	xsize(4) ysize(6)
	saving(boehmke2018sppq-figure01, replace);

	
		/****************************/
		/* Do model interpretation. */
		/****************************/

	/* Table 3, Model 2. */

use boehmke2018sppq, clear;

generat cont_days_tth     = cont_close/10000;
generat cont_days_bef_tth = cont_pre/10000;
generat cont_days_aft_tth = cont_post/10000;

xi: nbreg def_all cont_days_bef_tth cont_days_aft_tth rnhrspc bedsocc cnahrspc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

  sum cont_days_bef_tth if cont_days_bef_tth > 0 & e(sample);

	local cont_mean_cond = r(mean);

  collapse (mean) def_all cont_days_bef_tth cont_days_aft_tth rnhrspc bedsocc cnahrspc numres 
	(p50) med_caid med_both hospital multiown own_prof own_nonp year2003-year2005 
	(min) _Istate*;

  replace cont_days_bef_tth = 0;

  predict xbhat, xb;

  display "First Difference: " exp(xbhat + _b[cont_days_bef_tth]*`cont_mean_cond') - exp(xbhat);

  display "Proportion Change:  " 100*(exp(xbhat + _b[cont_days_bef_tth]*`cont_mean_cond')/exp(xbhat) - 1);

	/* Table 3, Model 5. */

use boehmke2018sppq, clear;

generat cont_days_tth     = cont_close/10000;
generat cont_days_bef_tth = cont_pre/10000;
generat cont_days_aft_tth = cont_post/10000;

xi: nbreg def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc bedsocc cnahrspc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

  sum cont_days_bef_tth if cont_days_bef_tth > 0 & e(sample);

	local cont_mean_cond = r(mean);

  collapse (mean) def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc bedsocc cnahrspc numres 
	(p50) med_caid med_both hospital multiown own_prof own_nonp year2003-year2005 
	(min) _Istate*;

  replace cont_days_bef_tth = 0;

  predict xbhat, xb;

  display "First Difference: " exp(xbhat + _b[cont_days_bef_tth]*`cont_mean_cond') - exp(xbhat);

  display "Proportion Change:  " 100*(exp(xbhat + _b[cont_days_bef_tth]*`cont_mean_cond')/exp(xbhat) - 1);

	/* Table 4, Model 1. */

use boehmke2018sppq, clear;

xi: nbreg def_all cont_leg_close_tth cont_gov_close_tth rnhrspc bedsocc cnahrspc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

  sum cont_leg_close_tth if cont_leg_close_tth > 0 & e(sample);

	local cont_mean_cond = r(mean);

  collapse (mean) def_all cont_leg_close_tth cont_gov_close_tth rnhrspc bedsocc cnahrspc numres 
	(p50) med_caid med_both hospital multiown own_prof own_nonp year2003-year2005 
	(min) _Istate*;

  replace cont_leg_close_tth = 0;

  predict xbhat, xb;

  display "First Difference: " exp(xbhat + _b[cont_leg_close_tth]*`cont_mean_cond') - exp(xbhat);

  display "Proportion Change:  " 100*(exp(xbhat + _b[cont_leg_close_tth]*`cont_mean_cond')/exp(xbhat) - 1);

	/* Table 4, Model 3. */

use boehmke2018sppq, clear;

xi: nbreg def_sev cont_leg_close_tth cont_gov_close_tth rnhrspc bedsocc cnahrspc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

  sum cont_gov_close_tth if cont_gov_close_tth > 0 & e(sample);

	local cont_mean_cond = r(mean);

  collapse (mean) def_all cont_leg_close_tth cont_gov_close_tth rnhrspc bedsocc cnahrspc numres 
	(p50) med_caid med_both hospital multiown own_prof own_nonp year2003-year2005 
	(min) _Istate*;

  replace cont_gov_close_tth = 0;

  predict xbhat, xb;

  display "First Difference: " exp(xbhat + _b[cont_gov_close_tth]*`cont_mean_cond') - exp(xbhat);

  display "Proportion Change:  " 100*(exp(xbhat + _b[cont_gov_close_tth]*`cont_mean_cond')/exp(xbhat) - 1);

	
		/******************************************/
		/* Generate table 5 using Wisconsin data. */
		/******************************************/


	/* First generate the two pieces of the table. */
	/* Easiest to do with a collapse and list.     */

use boehmke2018sppq-WI, clear;

generat leg_party_amnt   = cont_amnt if leg_party == 1;
generat comm_aging_amnt  = cont_amnt if comm_aging == 1;
generat comm_health_amnt = cont_amnt if comm_health == 1;
generat comm_pubh_amnt   = cont_amnt if comm_pubh == 1;
generat leg_owndist_amnt = cont_amnt if leg_owndist == 1;
generat leader_amnt      = cont_amnt if leader == 1;
  
	/* Get means among those receiving contributions. */
  
collapse (mean) comm_aging comm_health comm_pubh leg_party leg_owndist leader leg_party_amnt-leader_amnt 
	if !missing(senate) & data_cont_v_leg == 0, by(senate);

  order senate leg_party comm_aging comm_health comm_pubh leg_owndist leader;

  list senate leg_party comm_aging comm_health comm_pubh leg_owndist leader, table clean noobs;
  
  list senate leg_party_amnt-leader_amnt, table clean noobs;

  
	/* Do the hypothesis tests for contribution amounts. */
  
use boehmke2018sppq-WI, clear;

  bysort senate: ttest cont_amnt, by(leg_party);

  bysort senate: ttest cont_amnt, by(comm_aging);
  ttest cont_amnt if assembly==1, by(comm_health);
  ttest cont_amnt if assembly==1, by(comm_pubh);

  bysort senate: ttest cont_amnt, by(leg_owndist);
	
  bysort senate: ttest cont_amnt, by(leader);
	
	/* Do the hypothesis tests for contribution recipients. */
	/* The tests here compare the distribution of the relevant variable */
	/* across observations for contributions to those in the chamber as */
	/* a whole across observations for all legislators. */
  
	/* Contributions by party by chamber. */
  
prtest leg_party if assembly==1, by(data_cont_v_leg);
prtest leg_party if assembly==0, by(data_cont_v_leg);
  
	/* Contributions by aging committee by chamber. */
  
prtest comm_aging if assembly==1, by(data_cont_v_leg);
prtest comm_aging if assembly==0, by(data_cont_v_leg);
  
	/* Contributions by health committee for Assembly. */
  
prtest comm_health if assembly==1, by(data_cont_v_leg);
  
	/* Contributions by public health committee for Assembly. */
  
prtest comm_pubh if assembly==1, by(data_cont_v_leg);
  
	/* Contributions by same district by chamber. */
	/* Here we test against giving to a random district, i.e., with probability 1/N . */
  
sum leg_owndist if ~missing(cont_amnt) & assembly==1;
  
  prtesti `r(N)' `r(mean)' 98 `=1/98';
  
sum leg_owndist if ~missing(cont_amnt) & assembly==0;
  
  prtesti `r(N)' `r(mean)' 31 `=1/31';
  
	/* Contributions by leadership by chamber. */
  
prtest leader if assembly==1, by(data_cont_v_leg);
prtest leader if assembly==0, by(data_cont_v_leg);
  
		
			/********************************************************/
			/********************************************************/
			/* Additional models. All analysis presented after here */
			/* reflects robustness checks reported on in the paper. */
			/********************************************************/
			/********************************************************/

	
		/***************************************/
		/* Robustness to window of days within */
		/* which to include contributions.     */
		/***************************************/

use boehmke2018sppq, clear;

	/* Alternate models for robustness to window of days within which to include contributions. */

generat cont_days_bef_tth = .;
generat cont_days_aft_tth = .;
	
foreach days of numlist 90 60 30 {; 

  replace cont_days_bef_tth = cont_`days'bef/10000;
  replace cont_days_aft_tth = cont_`days'aft/10000;

  xi: nbreg def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

  xi: nbreg def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

  };

  
  		/*****************************************/
		/* Facility-level random effects models. */
		/*****************************************/
	
use boehmke2018sppq, clear;

	/* Convert contributions to ten-thousands of dollars and */
	/* use common name to help with table formatting.        */ 

generat cont_days_tth     = cont_close/10000;
generat cont_days_bef_tth = cont_pre/10000;
generat cont_days_aft_tth = cont_post/10000;

encode provnum, gen(provid);
	
xi: xtnbreg def_all cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, i(provid);
	
xi: xtnbreg def_sev cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, i(provid);

xi: xtnbreg def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, i(provid);

xi: xtnbreg def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, i(provid);

replace cont_days_bef_tth = cont_180bef/10000;
replace cont_days_aft_tth = cont_180aft/10000;

xi: xtnbreg def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, i(provid);

xi: xtnbreg def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, i(provid);
	
xi: xtnbreg def_all cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, i(provid);
	
xi: xtnbreg def_all cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, i(provid);
	
  grinter cont_leg_close_tth, inter(cont_leg_close_tth_legprof) const02(legprof) equation(def_all) kdensity 
	scheme(s1mono) clevel(90) lcolor(black black black) kdoptions(lcolor(gs11) lpattern(solid) ytitle("", axis(2)))
	title(All Deficiencies)
	yline(0) ytitle(Marginal Effect) ylabel(#5, grid)  ylabel(none, axis(2)) yscale(range(1 15) axis(2))
	xtitle(Legislative Professionalism) xlabel(0(0.1)0.5) 
	nomeantext nonote;

xi: xtnbreg def_sev cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, i(provid);
	
xi: xtnbreg def_sev cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, i(provid);
	
  grinter cont_leg_close_tth, inter(cont_leg_close_tth_legprof) const02(legprof) equation(def_sev) kdensity 
	scheme(s1mono) clevel(90) lcolor(black black black) kdoptions(lcolor(gs11) lpattern(solid) ytitle("", axis(2)) )
	title(Severe Deficiencies)
	yline(0) ytitle(Marginal Effect) ylabel(#5, grid)ylabel(none, axis(2)) yscale(range(1 15) axis(2))
	xtitle(Legislative Professionalism) xlabel(0(0.1)0.5) 
	nomeantext nonote;


  		/*****************************************************/
		/* Analyzing CA data with profits and contributions. */
  		/*****************************************************/


use boehmke2018sppq-CA, clear;

	/* Run base models adding profits to show effect. */
	/* Note that non-profits are excluded and there is no data for 2005. */

nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_day, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_pcday, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_sn_pcday, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_sn_day, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_hc_pcday, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_hc_day, cluster(provnum);

	/* Generate donation variable for facilities that made contributions during the time period. */
	/* NB: not all are in these data in this time period. */

generat donate=0;

replace donate=1 if provnum=="022619";
replace donate=1 if provnum=="055619";
replace donate=1 if provnum=="055565";
replace donate=1 if provnum=="555160";
replace donate=1 if provnum=="055575";

nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_day donate, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_pcday donate, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_sn_pcday donate, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_sn_day donate, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_hc_pcday donate, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_hc_day donate, cluster(provnum);

	/* Now also include facilities that are members of chains that donated during the time period. */

replace donate=1 if regexm(nursinghomename, "Clare's");
replace donate=1 if regexm(nursinghomename, "COUNTRY VILLA");
replace donate=1 if regexm(nursinghomename, "BRIGHTON GARDEN");
replace donate=1 if regexm(nursinghomename, "BRIGHTON PLACE");
replace donate=1 if regexm(nursinghomename, "BEVERLY");

nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_day donate, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_pcday donate, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_sn_pcday donate, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_sn_day donate, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_hc_pcday donate, cluster(provnum);
nbreg def_all rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof year2003-year2004 inc_hc_day donate, cluster(provnum);


  		/********************************/
		/* Including estimated profits. */
		/********************************/
	
	/* Open the CA data and run models predicting three measures of profits. */
	
use boehmke2018sppq-CA, clear;

  regress inc_pcday numbeds numres rnhrspc cnahrspc licstaff bedsocc med_caid med_both multiown 
	own_prof year2003-year2004 if survey==1 & year >= 2002, cluster(provnum);	

	estimates store inc;
	
  regress inc_hc_pcday numbeds numres rnhrspc cnahrspc licstaff bedsocc med_caid med_both multiown 
	own_prof year2003-year2004 if survey==1 & year >= 2002, cluster(provnum);	

	estimates store inc_hc;
	
  regress inc_sn_pcday numbeds numres rnhrspc cnahrspc licstaff bedsocc med_caid med_both multiown 
	own_prof year2003-year2004 if survey==1 & year >= 2002, cluster(provnum);	

	estimates store inc_sn;
	
	/* Open the analysis data and predict profits for inclusion in the models. */
	
use boehmke2018sppq, clear;

  estimates restore inc;

	predict inc_pcday_hat;

  estimates restore inc_hc;

	predict inc_hc_pcday_hat;

  estimates restore inc_sn;

	predict inc_sn_pcday_hat;
	
  label variable inc_pcday_hat  		"Estimated Profits per Person-Day";
  label variable inc_hc_pcday_hat  		"Estimated Health Care Profits per Person-Day";
  label variable inc_sn_pcday_hat  		"Estimated Skilled Nursing Profits per Person-Day";

	/* Convert contributions to ten-thousands of dollars and */
	/* use common name to help with table formatting.        */ 

generat cont_days_tth     = cont_close/10000;
generat cont_days_bef_tth = cont_pre/10000;
generat cont_days_aft_tth = cont_post/10000;

	/* These models use estimated profits per person-day. You can also substitute estimated */
	/* Health Care (inc_hc_pcday_hat) or Skilled Nursing (inc_sn_pcday_hat) profits per person-day. */
	/* These variables are estimated using data from CA - see included file for more info. */

xi: nbreg def_all cont_days_tth inc_pcday_hat rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);
	
xi: nbreg def_sev cont_days_tth inc_pcday_hat rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

xi: nbreg def_all cont_days_bef_tth cont_days_aft_tth inc_pcday_hat rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

xi: nbreg def_sev cont_days_bef_tth cont_days_aft_tth inc_pcday_hat rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

replace cont_days_bef_tth = cont_180bef/10000;
replace cont_days_aft_tth = cont_180aft/10000;

xi: nbreg def_all cont_days_bef_tth cont_days_aft_tth inc_pcday_hat rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

xi: nbreg def_sev cont_days_bef_tth cont_days_aft_tth inc_pcday_hat rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);
	
xi: nbreg def_all cont_leg_close_tth cont_gov_close_tth inc_pcday_hat rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);
	
xi: nbreg def_all cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof inc_pcday_hat rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, cluster(provnum);
	
  grinter cont_leg_close_tth, inter(cont_leg_close_tth_legprof) const02(legprof) equation(def_all) kdensity 
	scheme(s1mono) clevel(90) lcolor(black black black) kdoptions(lcolor(gs11) lpattern(solid) ytitle("", axis(2)))
	title(All Deficiencies)
	yline(0) ytitle(Marginal Effect) ylabel(#5, grid)  ylabel(none, axis(2)) yscale(range(1 15) axis(2))
	xtitle(Legislative Professionalism) xlabel(0(0.1)0.5) 
	nomeantext nonote;

xi: nbreg def_sev cont_leg_close_tth cont_gov_close_tth inc_pcday_hat rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);
	
xi: nbreg def_sev cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof inc_pcday_hat rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, cluster(provnum);
	
  grinter cont_leg_close_tth, inter(cont_leg_close_tth_legprof) const02(legprof) equation(def_sev) kdensity 
	scheme(s1mono) clevel(90) lcolor(black black black) kdoptions(lcolor(gs11) lpattern(solid) ytitle("", axis(2)) )
	title(Severe Deficiencies)
	yline(0) ytitle(Marginal Effect) ylabel(#5, grid)ylabel(none, axis(2)) yscale(range(1 15) axis(2))
	xtitle(Legislative Professionalism) xlabel(0(0.1)0.5) 
	nomeantext nonote;

	
		/****************************************************************************************/
		/* Zero-inflated negative binomial models. Make sure to install zinbcv.ado.             */
		/* Here are the steps involved here for each model.                                     */
		/*   1. Run the base model.                                                             */
		/*   2. Run the inflated model to do vuong test.                                        */
		/*   3. Run the inflated model to with clustered standard errors.                       */
		/*   4. Run the inflated model with inflation covariates and vuong test.                */
		/*   5. Run the inflated model with inflation covariates and clustered standard errors. */
		/****************************************************************************************/
		

use boehmke2018sppq, clear;

  generat cont_days_tth     = cont_close/10000;
  generat cont_days_bef_tth = cont_pre/10000;
  generat cont_days_aft_tth = cont_post/10000;

		/* Models 1/4. */

xi: nbreg def_all cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

xi: zinbcv def_all cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) vuong;
	
xi: zinbcv def_all cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) cluster(provnum);
	
  display invlogit([inflate]_b[_cons]);
  
		/* Next model won't converge with state fixed effects. */
	
xi: zinbcv def_all cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(cont_days_tth 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) vuong;

xi: zinbcv def_all cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(cont_days_tth 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) cluster(provnum);

	
xi: nbreg def_sev cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

xi: zinbcv def_sev cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) vuong;
	
xi: zinbcv def_sev cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) cluster(provnum);
	
  display invlogit([inflate]_b[_cons]);

xi: zinbcv def_sev cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(cont_days_tth 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) vuong;

xi: zinbcv def_sev cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(cont_days_tth 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) cluster(provnum);

	
		/* Models 2/5. */

		
replace cont_days_bef_tth = cont_pre/10000;
replace cont_days_aft_tth = cont_post/10000;
	
xi: nbreg def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

xi: zinbcv def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) vuong;
	
xi: zinbcv def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) cluster(provnum);
	
  display invlogit([inflate]_b[_cons]);
	
xi: zinbcv def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(cont_days_tth 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) vuong;

xi: zinbcv def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(cont_days_tth 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) cluster(provnum);

	
xi: nbreg def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

xi: zinbcv def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) vuong;
	
xi: zinbcv def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) cluster(provnum);
	
  display invlogit([inflate]_b[_cons]);
	
xi: zinbcv def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(cont_days_tth 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) vuong;
	
xi: zinbcv def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(cont_days_tth 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) cluster(provnum);
	
	
		/* Models 3/6. */

		
replace cont_days_bef_tth = cont_180bef/10000;
replace cont_days_aft_tth = cont_180aft/10000;
	
xi: nbreg def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

xi: zinbcv def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) vuong;
	
xi: zinbcv def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) cluster(provnum);
	
  display invlogit([inflate]_b[_cons]);
	
xi: zinbcv def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(cont_days_tth 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) vuong;

xi: zinbcv def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(cont_days_tth 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) cluster(provnum);

	
xi: nbreg def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

xi: zinbcv def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) vuong;
	
xi: zinbcv def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) cluster(provnum);
	
  display invlogit([inflate]_b[_cons]);
	
xi: zinbcv def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(cont_days_tth 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) vuong;

xi: zinbcv def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(cont_days_tth 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) cluster(provnum);
	
	
		/* Model 7. */

		
xi: nbreg def_all cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

xi: zinbcv def_all cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) vuong;

xi: zinbcv def_all cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) cluster(provnum);

  display invlogit([inflate]_b[_cons]);
	
xi: zinbcv def_all cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, 
	inflate(cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005) vuong iterate(100);

xi: zinbcv def_all cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, 
	inflate(cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state) iterate(100) cluster(provnum);


		/* Model 8. */

		
xi: nbreg def_all cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, cluster(provnum);

xi: zinbcv def_all cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, inflate(_cons) vuong;

  display invlogit([inflate]_b[_cons]);
	
xi: zinbcv def_all cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, inflate(_cons) cluster(provnum);

xi: zinbcv def_all cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, inflate(cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) vuong iterate(100);
	
xi: zinbcv def_all cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, inflate(cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) iterate(100) cluster(provnum);

	
		/* Model 9. */

		
xi: nbreg def_sev cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, cluster(provnum);

xi: zinbcv def_sev cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) vuong;

xi: zinbcv def_sev cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, inflate(_cons) cluster(provnum);

  display invlogit([inflate]_b[_cons]);
	
xi: zinbcv def_sev cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, 
	inflate(cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005) vuong iterate(100);

xi: zinbcv def_sev cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005 i.state if survey==1 & year >= 2002, 
	inflate(cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp year2003-year2005) iterate(100) cluster(provnum);


		/* Model 10. */

		
xi: nbreg def_sev cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, cluster(provnum);

xi: zinbcv def_sev cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, inflate(_cons) vuong;

xi: zinbcv def_sev cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, inflate(_cons) cluster(provnum);

  display invlogit([inflate]_b[_cons]);
	
xi: zinbcv def_sev cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, inflate(cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) vuong iterate(100);
	
xi: zinbcv def_sev cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005 i.state 
	if survey==1 & year >= 2002, inflate(cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof 
	rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres own_prof own_nonp year2003-year2005) iterate(100) cluster(provnum);
	
	
	/********************************************************************/
	/* Examine month fixed effects to evaluate election timing effects. */
	/********************************************************************/


use boehmke2018sppq, clear;

  generat cont_days_tth     = cont_close/10000;
  generat cont_days_bef_tth = cont_pre/10000;
  generat cont_days_aft_tth = cont_post/10000;
  
		/* Generate month in which survey occurs. */
  
  generat surv_mnth = month(date_surv);

		/* Models 1/4. */

nbreg def_all cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year##i.surv_mnth i.stateno if survey==1 & year >= 2002, cluster(provnum);

nbreg def_sev cont_days_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year##i.surv_mnth i.stateno if survey==1 & year >= 2002, cluster(provnum);
	
		/* Models 2/5. */

replace cont_days_bef_tth = cont_pre/10000;
replace cont_days_aft_tth = cont_post/10000;
	
nbreg def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year##i.surv_mnth i.stateno if survey==1 & year >= 2002, cluster(provnum);

nbreg def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year##i.surv_mnth i.stateno if survey==1 & year >= 2002, cluster(provnum);
	
		/* Model 3/6. */
		
replace cont_days_bef_tth = cont_180bef/10000;
replace cont_days_aft_tth = cont_180aft/10000;
	
nbreg def_all cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year##i.surv_mnth i.stateno if survey==1 & year >= 2002, cluster(provnum);

nbreg def_sev cont_days_bef_tth cont_days_aft_tth rnhrspc cnahrspc bedsocc med_caid med_both hospital multiown numres 
	own_prof own_nonp i.year##i.surv_mnth i.stateno if survey==1 & year >= 2002, cluster(provnum);	
	
		/* Model 7. */

nbreg def_all cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp i.year##i.surv_mnth i.stateno if survey==1 & year >= 2002, cluster(provnum);

		/* Model 8. */
		
nbreg def_all cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp i.year##i.surv_mnth i.stateno 
	if survey==1 & year >= 2002, cluster(provnum);

		/* Model 9. */

nbreg def_sev cont_leg_close_tth cont_gov_close_tth rnhrspc cnahrspc bedsocc med_caid med_both 
	hospital multiown numres own_prof own_nonp i.year##i.surv_mnth i.stateno if survey==1 & year >= 2002, cluster(provnum);

		/* Model 10. */
		
nbreg def_sev cont_leg_close_tth cont_gov_close_tth cont_leg_close_tth_legprof rnhrspc cnahrspc bedsocc 
	med_caid med_both hospital multiown numres own_prof own_nonp i.year##i.surv_mnth i.stateno 
	if survey==1 & year >= 2002, cluster(provnum);
	
log close;
clear;
exit;
