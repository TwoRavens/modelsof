version 13.1
#delimit;
set more off;
clear;
set maxvar 6000;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; log close; };
log using JB_PA2016_ChiozzaGoemans2004-interpret, replace text;

/*	***************************************************************		*/
/*     	File Name:	JB_PA2016_ChiozzaGoemans2004-interpret.do		*/
/*     	Date:   	July 09, 2015						*/
/*      Author: 	Frederick J. Boehmke					*/
/*      Purpose:	Interpret results of the Cox models estimated in R. 	*/
/*      Input File:	analyze-CG01-model1-coeffs.txt,				*/
/*			analyze-CG01-model1-covar.txt				*/
/*      Output File:	JB_PA2016_ChiozzaGoemans2004-interpret.log, 		*/
/*			JB_PA2016_ChiozzaGoemans2004-interpret-XX.gph		*/
/*	Previous File:	None.							*/
/*	***************************************************************		*/

capture program drop readin;

	/*****************************************/
	/* This program reads in the R estimates */
	/* and converts them to Stata estimates. */
	/*****************************************/

program define readin, eclass;

  syntax, COEFfs(string) COVariance(string) names(string);

	insheet using `coeffs', comma clear;

	  mkmat v1, matrix(b);
	  matrix b = b';
	  
	  matrix colnames b = `names';

	insheet using `covariance', comma clear;

	  mkmat v*, matrix(V);
	  matrix rownames V = `names';
	  matrix colnames V = `names';

		ereturn post b V;
		ereturn display, plus neq(1);
		
end;


	/*****************************************/
	/* Begin commands. Read in the results   */
	/* and create graphs to interpret.       */
	/*****************************************/

		/* The list of covariates. */

global names mixed txmixed demparl txdemparl dempres txdempres civwar txcivwar 
			lnencap txlnencap encapchg lntropen tropenchg lnpop txlnpop age txage 
			powtimes inish tginvsh dwinsh dlosesh ddrawsh
                              iniwar txiniwar tginvwar
                               dwinwar dlosewar ddrawwar;

		/* Generate marginal effect graph for the replicated model 1. */

readin, coeffs(JB_PA2016_ChiozzaGoemans2004-replicate-model1-coeffs.txt) covar(JB_PA2016_ChiozzaGoemans2004-replicate-model1-covar.txt) names($names);

*  matrix b = e(b);
*  matrix b = b[1, "mixed".."txmixed"];

*  matrix C = C["mixed".."txmixed", "mixed".."txmixed"];
  

use toR, clear;

  matrix C = e(V);
  
  matrix cov = C["mixed","txmixed"];
  scalar cov = trace(cov);
  local cov_mixd = cov;
  
  matrix cov = C["demparl","txdemparl"];
  scalar cov = trace(cov);
  local cov_parl = cov;
  
  matrix cov = C["dempres","txdempres"];
  scalar cov = trace(cov);
  local cov_pres = cov;

  matrix cov = C["civwar","txcivwar"];
  scalar cov = trace(cov);
  local cov_civw = cov;

  matrix cov = C["lnencap","txlnencap"];
  scalar cov = trace(cov);
  local cov_encap = cov;

  matrix cov = C["lnpop","txlnpop"];
  scalar cov = trace(cov);
  local cov_pop = cov;

  matrix cov = C["age","txage"];
  scalar cov = trace(cov);
  local cov_age = cov;

  matrix cov = C["iniwar","txiniwar"];
  scalar cov = trace(cov);
  local cov_inwar = cov;

  collapse (count) freq=d, by(t);
  
  tsset t;
  
  tsfill, full;
  
  generat g_mixd = _b[mixed] + ln(t)*_b[txmixed];
  generat g_mixd_se = sqrt(_se[mixed]^2 + ln(t)^2*_se[txmixed]^2 + 2*ln(t)*`cov_mixd');
  generat g_mixd_lo = g_mixd - 1.96*g_mixd_se;
  generat g_mixd_hi = g_mixd + 1.96*g_mixd_se;

  generat g_parl = _b[demparl] + ln(t)*_b[txdemparl];
  generat g_parl_se = sqrt(_se[demparl]^2 + ln(t)^2*_se[txdemparl]^2 + 2*ln(t)*`cov_parl');
  generat g_parl_lo = g_parl - 1.96*g_parl_se;
  generat g_parl_hi = g_parl + 1.96*g_parl_se;

  generat g_pres = _b[dempres] + ln(t)*_b[txdempres];
  generat g_pres_se = sqrt(_se[dempres]^2 + ln(t)^2*_se[txdempres]^2 + 2*ln(t)*`cov_pres');
  generat g_pres_lo = g_pres - 1.96*g_pres_se;
  generat g_pres_hi = g_pres + 1.96*g_pres_se;
  
  generat g_civw = _b[civwar] + ln(t)*_b[txcivwar];
  generat g_civw_se = sqrt(_se[civwar]^2 + ln(t)^2*_se[txcivwar]^2 + 2*ln(t)*`cov_civw');
  generat g_civw_lo = g_civw - 1.96*g_civw_se;
  generat g_civw_hi = g_civw + 1.96*g_civw_se;
  
  generat g_encap = _b[lnencap] + ln(t)*_b[txlnencap];
  generat g_encap_se = sqrt(_se[lnencap]^2 + ln(t)^2*_se[txlnencap]^2 + 2*ln(t)*`cov_encap');
  generat g_encap_lo = g_encap - 1.96*g_encap_se;
  generat g_encap_hi = g_encap + 1.96*g_encap_se;
  
  generat g_pop = _b[lnpop] + ln(t)*_b[txlnpop];
  generat g_pop_se = sqrt(_se[lnpop]^2 + ln(t)^2*_se[txlnpop]^2 + 2*ln(t)*`cov_pop');
  generat g_pop_lo = g_pop - 1.96*g_pop_se;
  generat g_pop_hi = g_pop + 1.96*g_pop_se;
  
  generat g_age = _b[age] + ln(t)*_b[txage];
  generat g_age_se = sqrt(_se[age]^2 + ln(t)^2*_se[txage]^2 + 2*ln(t)*`cov_age');
  generat g_age_lo = g_age - 1.96*g_age_se;
  generat g_age_hi = g_age + 1.96*g_age_se;
  
  generat g_inwar = _b[iniwar] + ln(t)*_b[txiniwar];
  generat g_inwar_se = sqrt(_se[iniwar]^2 + ln(t)^2*_se[txiniwar]^2 + 2*ln(t)*`cov_inwar');
  generat g_inwar_lo = g_inwar - 1.96*g_inwar_se;
  generat g_inwar_hi = g_inwar + 1.96*g_inwar_se;
  
twoway line g_mixd g_mixd_lo g_mixd_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Replication)
	name(mixd_rep, replace)
	legend(off);

twoway line g_parl g_parl_lo g_parl_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Replication)
	name(parl_rep, replace)
	legend(off);

twoway line g_pres g_pres_lo g_pres_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Replication)
	name(pres_rep, replace)
	legend(off);

twoway line g_civw g_civw_lo g_civw_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Replication)
	name(civw_rep, replace)
	legend(off);

twoway line g_encap g_encap_lo g_encap_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Replication)
	name(encap_rep, replace)
	legend(off);

twoway line g_pop g_pop_lo g_pop_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Replication)
	name(pop_rep, replace)
	legend(off);

twoway line g_age g_age_lo g_age_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Replication)
	name(age_rep, replace)
	legend(off);

twoway line g_inwar g_inwar_lo g_inwar_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Replication)
	name(inwar_rep, replace)
	legend(off);

		/* Repeat for our corrected version of model 1. */

readin, coeffs(JB_PA2016_ChiozzaGoemans2004-reanalysis-model1-coeffs.txt) covar(JB_PA2016_ChiozzaGoemans2004-reanalysis-model1-covar.txt) names($names);

use toR, clear;

  matrix C = e(V);
  
  matrix cov = C["mixed","txmixed"];
  scalar cov = trace(cov);
  local cov_mixd = cov;
  
  matrix cov = C["demparl","txdemparl"];
  scalar cov = trace(cov);
  local cov_parl = cov;
  
  matrix cov = C["dempres","txdempres"];
  scalar cov = trace(cov);
  local cov_pres = cov;

  matrix cov = C["civwar","txcivwar"];
  scalar cov = trace(cov);
  local cov_civw = cov;

  matrix cov = C["lnencap","txlnencap"];
  scalar cov = trace(cov);
  local cov_encap = cov;

  matrix cov = C["lnpop","txlnpop"];
  scalar cov = trace(cov);
  local cov_pop = cov;

  matrix cov = C["age","txage"];
  scalar cov = trace(cov);
  local cov_age = cov;

  matrix cov = C["iniwar","txiniwar"];
  scalar cov = trace(cov);
  local cov_inwar = cov;

  collapse (count) freq=d, by(t);
  
  tsset t;
  
  tsfill, full;
  
  generat g_mixd = _b[mixed] + ln(t)*_b[txmixed];
  generat g_mixd_se = sqrt(_se[mixed]^2 + ln(t)^2*_se[txmixed]^2 + 2*ln(t)*`cov_mixd');
  generat g_mixd_lo = g_mixd - 1.96*g_mixd_se;
  generat g_mixd_hi = g_mixd + 1.96*g_mixd_se;

  generat g_parl = _b[demparl] + ln(t)*_b[txdemparl];
  generat g_parl_se = sqrt(_se[demparl]^2 + ln(t)^2*_se[txdemparl]^2 + 2*ln(t)*`cov_parl');
  generat g_parl_lo = g_parl - 1.96*g_parl_se;
  generat g_parl_hi = g_parl + 1.96*g_parl_se;

  generat g_pres = _b[dempres] + ln(t)*_b[txdempres];
  generat g_pres_se = sqrt(_se[dempres]^2 + ln(t)^2*_se[txdempres]^2 + 2*ln(t)*`cov_pres');
  generat g_pres_lo = g_pres - 1.96*g_pres_se;
  generat g_pres_hi = g_pres + 1.96*g_pres_se;
  
  generat g_civw = _b[civwar] + ln(t)*_b[txcivwar];
  generat g_civw_se = sqrt(_se[civwar]^2 + ln(t)^2*_se[txcivwar]^2 + 2*ln(t)*`cov_civw');
  generat g_civw_lo = g_civw - 1.96*g_civw_se;
  generat g_civw_hi = g_civw + 1.96*g_civw_se;
  
  generat g_encap = _b[lnencap] + ln(t)*_b[txlnencap];
  generat g_encap_se = sqrt(_se[lnencap]^2 + ln(t)^2*_se[txlnencap]^2 + 2*ln(t)*`cov_encap');
  generat g_encap_lo = g_encap - 1.96*g_encap_se;
  generat g_encap_hi = g_encap + 1.96*g_encap_se;
  
  generat g_pop = _b[lnpop] + ln(t)*_b[txlnpop];
  generat g_pop_se = sqrt(_se[lnpop]^2 + ln(t)^2*_se[txlnpop]^2 + 2*ln(t)*`cov_pop');
  generat g_pop_lo = g_pop - 1.96*g_pop_se;
  generat g_pop_hi = g_pop + 1.96*g_pop_se;
  
  generat g_age = _b[age] + ln(t)*_b[txage];
  generat g_age_se = sqrt(_se[age]^2 + ln(t)^2*_se[txage]^2 + 2*ln(t)*`cov_age');
  generat g_age_lo = g_age - 1.96*g_age_se;
  generat g_age_hi = g_age + 1.96*g_age_se;
  
  generat g_inwar = _b[iniwar] + ln(t)*_b[txiniwar];
  generat g_inwar_se = sqrt(_se[iniwar]^2 + ln(t)^2*_se[txiniwar]^2 + 2*ln(t)*`cov_inwar');
  generat g_inwar_lo = g_inwar - 1.96*g_inwar_se;
  generat g_inwar_hi = g_inwar + 1.96*g_inwar_se;

twoway line g_mixd g_mixd_lo g_mixd_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	yline(0, lcolor(red) axis(1))
	title(Reanalysis)
	name(mixd_rev, replace)
	legend(off);
	
twoway line g_parl g_parl_lo g_parl_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Reanalysis)
	name(parl_rev, replace)
	legend(off);

twoway line g_pres g_pres_lo g_pres_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Reanalysis)
	name(pres_rev, replace)
	legend(off);

twoway line g_civw g_civw_lo g_civw_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Reanalysis)
	name(civw_rev, replace)
	legend(off);

twoway line g_encap g_encap_lo g_encap_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Reanalysis)
	name(encap_rev, replace)
	legend(off);

twoway line g_pop g_pop_lo g_pop_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Reanalysis)
	name(pop_rev, replace)
	legend(off);

twoway line g_age g_age_lo g_age_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Reanalysis)
	name(age_rev, replace)
	legend(off);

twoway line g_inwar g_inwar_lo g_inwar_hi t, scheme(s1mono)  
	lpattern(solid dash dash) lcolor(gs0 gs8 gs8)
	yaxis(1)
  ||	bar freq t,
	bcolor(gs13) yaxis(2)
	ylabel(#7, grid axis(1))
	yline(0, lcolor(red) axis(1))
	xtitle(Time)
	ytitle(Marginal Effect, axis(1))
	ytitle(Frequency of Failure Times, axis(2))
	title(Reanalysis)
	name(inwar_rev, replace)
	legend(off);

		/* Combine the graphs to compare. */
	
  graph combine mixd_rep mixd_rev, scheme(s1mono)
	xcommon ycommon
	rows(1)
	imargin(small) altshrink  
	xsize(6) ysize(2)
	title(Mixed Regimes, size(huge))
	name(mixd, replace)
	saving(graphs/mixd-model1.gph, replace);
	
  graph combine parl_rep parl_rev, scheme(s1mono)
	xcommon ycommon
	rows(1)
	imargin(small) altshrink  
	xsize(6) ysize(2)
	title(Parliamentary Democracies, size(huge))
	name(parl, replace)
	saving(graphs/parl-model1.gph, replace);
	
  graph combine pres_rep pres_rev, scheme(s1mono)
	xcommon ycommon
	rows(1)
	imargin(small) altshrink  
	xsize(6) ysize(2)
	title(Presidential Democracies, size(huge))
	name(pres, replace)
	saving(graphs/pres-model1.gph, replace);
	
	graph export ../../graphs/simulate-CG01-model1-pres.eps, replace;
	
  graph combine civw_rep civw_rev, scheme(s1mono)
	xcommon ycommon
	rows(1)
	imargin(small) altshrink  
	xsize(6) ysize(2)
	title(Civil War, size(huge))
	name(civw, replace)
	saving(graphs/civw-model1.gph, replace);
	
  graph combine encap_rep encap_rev, scheme(s1mono)
	xcommon ycommon
	rows(1)
	imargin(small) altshrink  
	xsize(6) ysize(2)
	title(Economic Development, size(huge))
	name(encap, replace)
	saving(graphs/encap-model1.gph, replace);
	
  graph combine pop_rep pop_rev, scheme(s1mono)
	xcommon ycommon
	rows(1)
	imargin(small) altshrink  
	xsize(6) ysize(2)
	title(Population, size(huge))
	name(pop, replace)
	saving(graphs/pop-model1.gph, replace);
	
  graph combine age_rep age_rev, scheme(s1mono)
	xcommon ycommon
	rows(1)
	imargin(small) altshrink  
	xsize(6) ysize(2)
	title(Age, size(huge))
	name(age, replace)
	saving(graphs/age-model1.gph, replace);
	
  graph combine inwar_rep inwar_rev, scheme(s1mono)
	xcommon ycommon
	rows(1)
	imargin(small) altshrink  
	xsize(6) ysize(2)
	title(War Involvement as Challenger, size(huge))
	name(inwar, replace)
	saving(graphs/inwar-model1.gph, replace);
	
		/* Now combine three interesting pairs into one figure. */
	
  graph combine mixd parl pres, scheme(s1mono)
	xcommon ycommon
	rows(3)
	imargin(tiny) altshrink  
	xsize(6.5) ysize(6.5)
	saving(../../graphs/simulate-CG01-combined-model1.gph, replace);
	
	graph export ../../graphs/simulate-CG01-combined-model1.eps, replace;
	
		/* Now combine all pairs into one figure. */
	
  graph combine mixd parl pres civw encap pop age inwar , scheme(s1mono)
	xcommon ycommon
	rows(4)
	imargin(tiny) altshrink  
	xsize(6.5) ysize(6.5)
	saving(../../graphs/simulate-CG01-combined-model1.gph, replace);
	
	graph export ../../graphs/simulate-CG01-combined-all-model1.eps, replace;
	
clear;
log close;
exit, STATA;



