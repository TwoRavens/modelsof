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

/* Open dataset */
#delimit;
use "Signal Level Prediction Dataset.dta" , clear;

/*US*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly reg us_signal`i' polity2 rgdppc realgdp c.distance_us##c.distance_us recentMIDs_nous, vce(robust);
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
	drop ll1;
	

/*RUS*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly reg rus_signal`i' polity2 rgdppc colony_rus realgdp c.distance_rus##c.distance_rus recentMIDs_norus, vce(robust);
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
	drop ll1;
	
	
/*Chi*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly reg chi_signal`i' polity2 rgdppc colony_chi realgdp c.distance_chi##c.distance_chi recentMIDs_noch, vce(robust);
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
	drop ll1;
	

/*UK*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly reg uk_signal`i' polity2 rgdppc colony_uk realgdp c.distance_uk##c.distance_uk recentMIDs_nouk, vce(robust);
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
	drop ll1;
	

/*Fra*/
#delimit;
clear matrix ;
forvalues i=1/5 {;
quietly reg fra_signal`i' polity2 rgdppc colony_fra realgdp c.distance_fra##c.distance_fra recentMIDs_nofra, vce(robust);
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
	drop ll1;

