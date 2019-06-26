#delimit;
version 13;

/* Program applying Rubin's formula to merge estimates to account for uncertainty in latent measure (5 draws) */
capture program drop rubin;
program define rubin;
	local names: colnames(Q1);
	matrix Q = (Q1 + Q2 + Q3 + Q4 + Q5)/5;		/* MI param estimates */
	matrix W = (W1 + W2 + W3 + W4 + W5)/5;		/* MI covariances     */
	matrix ll = (ll1 + ll2 + ll3 + ll4 + ll5)/5;
	local  k = colsof(Q);
	forvalues i=1/5 {;
	  matrix QQ=Q`i'-Q;
	  if `i'==1 {;
		matrix B=(QQ)'*QQ;
		};
	  else matrix B = B + (QQ)'*QQ;
	};
	matrix B=B/(5-1);				/* Covariance adjustment */
	matrix V=W+(1+1/5)*B;				/* Final covariance   */
	ereturn post Q V ;
end;

/* Open dataset*/
#delimit;
use "MID Intervention Prediction Dataset.dta" , clear;

/* Make sure AIC comparisons include the same cases and exclude those where major power i is on sideA */
/* identify same set of cases for us*/
probit us_join median_us cinca_nous cincb_nous cincperc_nous totalstates_nous c.distance_us##c.distance_us if sidea_us==0, vce(robust); 
gen us_s=1 if e(sample)==1;

/* identify same set of cases for ru*/
probit rus_join median_ru cinca_noru cincb_noru cincperc_noru totalstates_noru c.distance_rus##c.distance_rus if sidea_ru==0, vce(robust);
gen ru_s=1 if e(sample)==1;

/* identify same set of cases for china */
probit chi_join median_chi cinca_nochi cincb_nochi cincperc_nochi totalstates_nochi c.distance_chi##c.distance_chi if sidea_chi==0, vce(robust);
gen chi_s=1 if e(sample)==1;

/* identify same set of cases for uk*/
probit uk_join median_uk cinca_nouk cincb_nouk cincperc_nouk totalstates_nouk c.distance_uk##c.distance_uk if sidea_uk==0, vce(robust);
gen uk_s=1 if e(sample)==1;

/* identify same set of cases for fra*/
probit fra_join median_fra cinca_nofra cincb_nofra cincperc_nofra totalstates_nofra c.distance_fra##c.distance_fra if sidea_fra==0, vce(robust);
gen fr_s=1 if e(sample)==1;


/*US*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
probit us_join us_signal`i' cinca_nous cincb_nous cincperc_nous totalstates_nous c.distance_us##c.distance_us if us_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*8 - 2*ll1;
	gen BIC = ln(1440)*8-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;

/*RUS*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
probit rus_join rus_signal`i' cinca_noru cincb_noru cincperc_noru totalstates_noru c.distance_rus##c.distance_rus if ru_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*8 - 2*ll1;
	gen BIC = ln(1416)*8-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;
	
/*Chi*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
probit chi_join chi_signal`i' cinca_nochi cincb_nochi cincperc_nochi totalstates_nochi c.distance_chi##c.distance_chi if chi_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*8 - 2*ll1;
	gen BIC = ln(1452)*8-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;
	
/*UK*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
probit uk_join uk_signal`i' cinca_nouk cincb_nouk cincperc_nouk totalstates_nouk c.distance_uk##c.distance_uk if uk_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*8 - 2*ll1;
	gen BIC = ln(1462)*8-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;

/*Fra*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
probit fra_join fra_signal`i' cinca_nofra cincb_nofra cincperc_nofra totalstates_nofra c.distance_fra##c.distance_fra if fr_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*8 - 2*ll1;
	gen BIC = ln(1490)*8-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;

* Compare AIC's including each individual signal in the regression
* Note: The nuclear variable exists for Russia and the UK also, but it creates the problem of perfect prediction.

#delimit;
probit us_join us_pact log_us_arms us_vis us_words us_nukes cinca_nous cincb_nous cincperc_nous totalstates_nous c.distance_us##c.distance_us if us_s==1, vce(robust);
estat ic;
estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);

probit rus_join rus_pact log_rus_arms rus_vis cinca_noru cincb_noru cincperc_noru totalstates_noru c.distance_rus##c.distance_rus if ru_s==1, vce(robust);
estat ic;
estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);

probit chi_join  log_chi_arms chi_vis cinca_nochi cincb_nochi cincperc_nochi totalstates_nochi c.distance_chi##c.distance_chi if chi_s==1, vce(robust);
estat ic;
estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);

probit uk_join uk_pact log_uk_arms uk_vis cinca_nouk cincb_nouk cincperc_nouk totalstates_nouk c.distance_uk##c.distance_uk if uk_s==1, vce(robust);
estat ic;
estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);

probit fra_join fra_pact log_fra_arms fra_vis cinca_nofra cincb_nofra cincperc_nofra totalstates_nofra c.distance_fra##c.distance_fra if fr_s==1, vce(robust);
estat ic;
estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);


* ADD UN VOTING AFFINITY TO REGRESSIONS

/*US*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly probit us_join us_signal`i' s_un_us cinca_nous cincb_nous cincperc_nous totalstates_nous c.distance_us##c.distance_us if us_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*9 - 2*ll1;
	gen BIC = ln(1440)*9-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;

/*RUS*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly probit rus_join rus_signal`i' s_un_rus cinca_noru cincb_noru cincperc_noru totalstates_noru c.distance_rus##c.distance_rus if ru_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*9 - 2*ll1;
	gen BIC = ln(1416)*9-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;
	
/*Chi*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly probit chi_join chi_signal`i' s_un_chi cinca_nochi cincb_nochi cincperc_nochi totalstates_nochi c.distance_chi##c.distance_chi if chi_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*9 - 2*ll1;
	gen BIC = ln(1452)*9-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;
	
/*UK*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly probit uk_join uk_signal`i' s_un_uk cinca_nouk cincb_nouk cincperc_nouk totalstates_nouk c.distance_uk##c.distance_uk if uk_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*9 - 2*ll1;
	gen BIC = ln(1462)*9-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;

/*Fra*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly probit fra_join fra_signal`i' s_un_fra cinca_nofra cincb_nofra cincperc_nofra totalstates_nofra c.distance_fra##c.distance_fra if fr_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*9 - 2*ll1;
	gen BIC = ln(1490)*9-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;
	
	
* ADD ALLIANCE AFFINITY TO REGRESSIONS

/*US*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly probit us_join us_signal`i' s_alliance_us cinca_nous cincb_nous cincperc_nous totalstates_nous c.distance_us##c.distance_us if us_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*9 - 2*ll1;
	gen BIC = ln(1440)*9-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;

/*RUS*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly probit rus_join rus_signal`i' s_alliance_rus cinca_noru cincb_noru cincperc_noru totalstates_noru c.distance_rus##c.distance_rus if ru_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*9 - 2*ll1;
	gen BIC = ln(1416)*9-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;
	
/*Chi*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly probit chi_join chi_signal`i' s_alliance_chi cinca_nochi cincb_nochi cincperc_nochi totalstates_nochi c.distance_chi##c.distance_chi if chi_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*9 - 2*ll1;
	gen BIC = ln(1452)*9-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;
	
/*UK*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly probit uk_join uk_signal`i' s_alliance_uk cinca_nouk cincb_nouk cincperc_nouk totalstates_nouk c.distance_uk##c.distance_uk if uk_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*9 - 2*ll1;
	gen BIC = ln(1462)*9-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;

/*Fra*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly probit fra_join fra_signal`i' s_alliance_fra cinca_nofra cincb_nofra cincperc_nofra totalstates_nofra c.distance_fra##c.distance_fra if fr_s==1, vce(robust);
matrix Q`i' = e(b);
  	matrix W`i' = e(V);
	matrix  ll`i' = e(ll);
	nois _dots `i' 0;
};

rubin;
#delimit;
/* -estout- seems to be necessary to get it to -estimates store-. */	
	estout , cells(b(star fmt(3)) se(par fmt(3)) ) starlevels(* .05 ** .01) style(tex);
	matrix list ll;
	svmat ll;
	gen AIC = 2*9 - 2*ll1;
	gen BIC = ln(1490)*9-2*ll1;
	sum AIC BIC;
	drop AIC BIC ll1;

