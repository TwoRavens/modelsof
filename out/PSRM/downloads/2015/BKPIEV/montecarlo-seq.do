#delimit;
version 13;
set more off;
clear all;
set memory 500m;
set matsize 800;
pause on;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; log close; };
log using montecarlo-seq.log, text replace;


/*	************************************************************************	*/
/*     	File Name:	montecarlo-sscore.do						*/
/*     	Date:   	May 15, 2015							*/
/*      Author: 	Frederick J. Boehmke and Olga Chyzh				*/
/*      Purpose:	Run Monte Carlo of endogeneous SEq scores as in Boehmke, Chyzh,	*/
/*			and Thies (PSRM 2016). Note that we do not set a seed, so you 	*/
/*			will not get identical results.					*/
/*      Output File:	montecarlo-seq.log,						*/
/*			montecarlo-seq.dta,						*/
/*			graphs/montecarlo-seq-XXX.gph					*/
/*	************************************************************************	*/


capture mkdir graphs/;
capture mkdir sims/;
program drop _all;


	/********************************************************/
	/* This program takes dyadic data and creates the	*/ 
	/* structural equivalence measure, also in dyadic form. */
	/********************************************************/
	

program define seq, rclass;

  syntax varname [if] [in], id1(varname) id2(varname) [year(varname)];
  
	tempfile ids;
  
	marksample touse;
	
	quietly keep if `touse';
	
	quietly keep *`varlist' `id1' `id2' `year';
		
	sort `id1' `id2';
	
		/* Reshape twice to ensure square data set. */
	
	quietly reshape wide *`varlist', i(`id1') j(`id2');
	
	  quietly reshape long `varlist', i(`id1') j(`id2');	
		  
		preserve;
		
		quietly keep `id1' `id2';
		
		  quietly egen i = group(`id1');
		  quietly bysort i: generat j = _n;
		
		  quietly save `ids', replace;
		
		restore;
		
		quietly reshape wide `varlist', i(`id1') j(`id2');
	
		/* Save for Mata since we call the Mata program shortly. */
	
	quietly putmata X=(`varlist'*), replace;
	
	clear;
	
	mata: seq(X);
		
	quietly svmat SEQ;

	quietly generat i = _n;
	
	quietly reshape long SEQ, i(i) j(j);
	
		rename SEQ `varlist'_seq;
	
		quietly merge 1:1 i j using `ids';

		quietly drop i j _merge;
		
	capture rename id1 `id1';
	capture rename id2 `id2';

end;


	/****************************************************************/
	/* This program converts monadic data to dyadic data.	 	*/ 
	/****************************************************************/


program define mkdyads, rclass;

  syntax varlist, unit(varname) [time(varname) stratify(varname) saving(string)];

	local variables `varlist';
	
	tempvar unitid temp merge;
	tempfile origdata renamed fulldata;
	
	
  if "`saving'" != "" {;

	preserve;

        };
	
	keep `varlist' `unit' `time' `stratify';
	
	egen `unitid' = group(`unit');
	
	quietly save `origdata', replace;
  
		/* Set up a data set of all year/units. */
  
  quietly use `origdata', clear;
  	
	if "`time'" != "" {;
	
	  quietly sum `unitid';
	
	  local numunits = r(max);

		contract `time', freq(`temp');
		
		drop `temp';
		
		quietly expand `numunits';
		
		bysort `time': generat `unitid'_01 = _n;
		
		quietly expand `numunits';
		
		bysort `time' `unitid'_01: generat `unitid'_02 = _n;
	
		quietly save `fulldata', replace;
		
		};
		
	else if "`time'" == "" {;
		
	  quietly sum `unitid';
	
	  local numunits = r(max);
	  
		clear;
		
		quietly set obs `numunits';
		
		generat `unitid'_01 = _n;
		
		quietly expand `numunits';
		
		bysort `unitid'_01: generat `unitid'_02 = _n;
	
		quietly save `fulldata', replace;
		
		};

  quietly use `origdata', clear;
  	
  	foreach var of varlist `variables' `unit' `unitid' {;

	  rename `var' `var'_02;

	  };

  	sort `stratify' `time' `unitid'_02;

  	quietly save `renamed', replace;

	
  quietly use `origdata', clear;

  	foreach var of varlist `variables' `unit' `unitid' {;

	  rename `var' `var'_01;

	  };

		/* Now join/merge with the state_01 data and then with the state_02 data. */

	joinby `time' `unitid'_01 using `fulldata', unmatched(master) _merge(`merge');

		drop `merge';
			
	  quietly merge m:1 `stratify' `time' `unitid'_02 using `renamed', keep(match master) assert(match master) generat(`merge');

		drop `merge';
		
	quietly drop if missing(`unit'_01, `unit'_02);

	drop `unitid'_01 `unitid'_02;

	order `stratify' `time' `unit'_01 `unit'_02;

  if "`saving'" != "" {;

        save `saving';
	
	restore;

        };

end;


	/********************************************************/
	/* This mata program manipulates the matrices to 	*/ 
	/* calculate the structural equivalence measure. It is  */
	/* called by the seq program above.			*/
	/********************************************************/


capture mata mata drop seq();

mata;

real matrix seq(real matrix X) {;
	
	real matrix ONE, ONES, NUMR, NUMC, X0, CMEAN, RMEAN, CD, RD, XC, XR, NUM, DENOM1, DENOM, SEQ;
	
	ONE = J(cols(X),1,1);
	ONES = J(cols(X),cols(X),1);

	NUMR = rownonmissing(X);
	NUMC = colnonmissing(X)';
	
	X0 = editmissing(X , 0);
	
	CMEAN = colsum(X0)' :/ NUMC;
	RMEAN = rowsum(X0)  :/ NUMR;
	
	XR = J(cols(X),cols(X),.);
	XC = J(cols(X),cols(X),.);

	i=1;

	  while (i <= cols(X)) {;

	  XR[i,.] = editmissing(X[i,.], 0);
	  XC[.,i] = editmissing(X[.,i], 0);

	  i = i + 1;

	  };
	
	CD = XC-ONES*XC*invsym(ONE'*ONE);
	RD = (XR'-ONES*XR'*invsym(ONE'*ONE))';
	
	NUM = CD'*CD + RD*RD';

	DENOM1 = diagonal(CD'*CD) + diagonal(RD*RD');

	DENOM = DENOM1*DENOM1';

	SEQ = NUM :/ sqrt(DENOM);
	
	st_matrix("SEQ", SEQ);
  
  };

end;


	/************************************************/
	/* This program combines the estimates from  	*/
	/* the multiply imputed data sets.		*/
	/************************************************/


program define micalc, eclass;

	local names: colnames(b1);

	matrix b = (b1 + b2 + b3 + b4 + b5)/5;		/* MI param estimates */
	matrix C = (C1 + C2 + C3 + C4 + C5)/5;		/* MI covariances     */
	local  k = colsof(b);

	forvalues i=1/5 {;

	  matrix bb=b`i'-b;

	  if `i'==1 {;

		matrix Vb=(bb)'*bb;

		};

	  else matrix Vb = Vb + (bb)'*bb;


	};

	matrix Vb=Vb/(5-1);				/* Covariance adjustment */

	matrix V=C+(1+1/5)*Vb;				/* Final covariance   */
	
		/* Post the results to print, access, and save estimates later. */

	ereturn post b V, depname(`e(depvar)') obs(`e(N)') dof(`e(df_m)');
	

end;


	/****************************************************************/
	/* This program takes the exogeneous variables, generates the 	*/ 
	/* error terms, calculates the SEQ scores, and runs the models.	*/
	/****************************************************************/


program define mc_seq, rclass;

  syntax, indvars(string) [rho(real 0) sd2(real 1)];
  
	tempfile seq data;

	use `indvars', clear;
  
	matrix C = (1 , `=`sd2'*`rho'' \ `=`sd2'*`rho'' , `sd2'^2);

	drawnorm e1 e2, means(0 , 0) cov(C); 

	generat y2 = z1_01 + z1_02 - distance + e2;

		/* No connection to oneself. */

	  replace y2 = 0 if id_01==id_02;
		
	  save `data', replace;
	 
		/* Generate the seq scores using the observed dyadic variable. */

	quietly seq y2, id1(id_01) id2(id_02);
		
	  save `seq', replace;
		
	  use `data', clear;

	  merge 1:1 id_01 id_02 using `seq', generat(_merge_y2);

	  generat y1 = 0 + 0.25*x1_01 + 0.25*x1_02 - 1*y2_seq - 0.25*distance + e1;
		
		/* Generate the seq scores using the predicted dyadic variable. */
		
	regress y2 z1_01 z1_02 distance if id_01!=id_02;
	
		/* Create variables to rescale to account for the fact that it's an IV. */
	
	  local sigma = e(rss)/e(df_r);
	
	  predict y2_hat;
	  predict e2_hat, resid;
	  predict stdp, stdp;
	  
	  replace y2_hat = 0 if id_01==id_02;
	
	  egen var_y2_hat_ik = var(y2_hat) if id_01!=id_02, by(id_01);
	  egen var_y2_hat_kj = var(y2_hat) if id_01!=id_02, by(id_02);

	  egen var_e2_hat_ik = var(e2_hat) if id_01!=id_02, by(id_01);
	  egen var_e2_hat_kj = var(e2_hat) if id_01!=id_02, by(id_02);
	  
	  save `data', replace;
	  
	    collapse (mean) var_y2_hat_kj var_e2_hat_kj, by(id_02);
	  
	    rename id_02 id_01;
	    rename var_y2_hat_kj var_y2_hat_ki;
	    rename var_e2_hat_kj var_e2_hat_ki;
	    
	    merge 1:m id_01 using `data';
	    
	    drop _merge;
	  
	  save `data', replace;
	  
	    collapse (mean) var_y2_hat_ik var_e2_hat_ik, by(id_01);
	  
	    rename id_01 id_02;
	    rename var_y2_hat_ik var_y2_hat_jk;
	    rename var_e2_hat_ik var_e2_hat_jk;
	    
	    merge 1:m id_02 using `data';
	    
	    drop _merge;

	  generat ratio = sqrt((var_y2_hat_ik + var_y2_hat_ki + var_e2_hat_ik + var_e2_hat_ki)*(var_y2_hat_jk + var_y2_hat_kj 
		+ var_e2_hat_jk + var_e2_hat_kj)/((var_y2_hat_ik + var_y2_hat_ki)*(var_y2_hat_jk + var_y2_hat_kj)));
	  
		/* Draw y2_hat 5 times to capture uncertainty. */
	  
	  forvalues num= 1/5 {;
	  
		gen y2_hat`num'=y2_hat + invnormal(uniform())*stdp;
		
		replace y2_hat`num' = 0 if id_01==id_02;
		
		};	  
	  
	  save `data', replace;
	  
		/* Now run the SEq on the imputed y2 draws. */
	  
	  forvalues num= 1/5 {;
	  
		quietly seq y2_hat`num', id1(id_01) id2(id_02);
		save `seq', replace;
	
		use `data', clear;
		merge 1:1 id_01 id_02 using `seq', generat(_merge_y2`num'_hat);
		  
		replace y2_hat`num'_seq = y2_hat`num'_seq/ratio;
		
		save `data', replace;
		
		};
		
		/* Generate the IV seq scores running a regression. */
		/* First, generate second and third degree polynomials for all first stage regressors. */
	
	generat z1_01_sq=z1_01^2;
	generat z1_02_sq=z1_02^2;
	generat distance_sq=distance^2;
	
	generat z1_01_cube=z1_01^3;
	generat z1_02_cube=z1_02^3;
	generat distance_cube=distance^3;
	
	generat z1_0102=z1_01*z1_02;
	generat z1_0102_sq=(z1_01*z1_02)^2;
	generat z1_0102_cube=(z1_01*z1_02)^3;
	
	generat z1_01dist=z1_01*distance;
	generat z1_02dist=z1_02*distance;
	generat z1_0102dist=z1_01*z1_02*distance;
	
		/* Now run the models. */

	regress y1 x1_01 x1_02 y2_seq distance if id_01!=id_02;
	
	  return scalar b0 = _b[_cons];
	  return scalar b1 = _b[x1_01];
	  return scalar b2 = _b[x1_02];
	  return scalar b3 = _b[y2_seq];
	  return scalar b4 = _b[distance];
	
	  return scalar se_b0 = _se[_cons];
	  return scalar se_b1 = _se[x1_01];
	  return scalar se_b2 = _se[x1_02];
	  return scalar se_b3 = _se[y2_seq];
	  return scalar se_b4 = _se[distance];
	  
		/* Loop over the multiply imputed SEq values. */
	
	forvalues num=1/5 {;
	
	  regress y1 x1_01 x1_02 y2_hat`num'_seq distance if id_01!=id_02;
	  
	  matrix b`num' = e(b);
	  matrix C`num' = e(V);
	
	  };
	
	  micalc;

		return scalar a0 = _b[_cons];
		return scalar a1 = _b[x1_01];
		return scalar a2 = _b[x1_02];
		return scalar a3 = _b[y2_hat5_seq];
		return scalar a4 = _b[distance];
			  
		return scalar se_a0 = _se[_cons];
		return scalar se_a1 = _se[x1_01];
		return scalar se_a2 = _se[x1_02];
		return scalar se_a3 = _se[y2_hat5_seq];
		return scalar se_a4 = _se[distance];
	
		/* Estimate the IV model. */
	
	ivregress 2sls y1 x1_01 x1_02 distance (y2_seq = z1_01 z1_01_sq z1_01_cube z1_02 z1_02_sq z1_02_cube distance distance_sq distance_cube 
		z1_0102 z1_0102_sq z1_0102_cube z1_01dist z1_02dist z1_0102dist) if id_01!=id_02;
	
	  return scalar g0 = _b[_cons];
	  return scalar g1 = _b[x1_01];
	  return scalar g2 = _b[x1_02];
	  return scalar g3 = _b[y2_seq];
	  return scalar g4 = _b[distance];
		  	  
	  return scalar se_g0 = _se[_cons];
	  return scalar se_g1 = _se[x1_01];
	  return scalar se_g2 = _se[x1_02];
	  return scalar se_g3 = _se[y2_seq];
	  return scalar se_g4 = _se[distance];

	summarize y2;
	
	  return scalar var_y2 = r(Var);

	summarize y2_hat;
	
	  return scalar var_y2hat = r(Var);
			  	  
	return scalar rho = (`rho');
			  
end;
	

	/****************************************/
	/* Create the exogenous data. 		*/
	/****************************************/

clear;

set obs 100;

generat id = _n;

egen coord_x = seq(), from(1) to(10) block(10);

bysort coord_x: generat coord_y = _n;

drawnorm x1 z1, means(0 , 0) sd(1 , 1);

		/* Turn into dyadic data. */

  mkdyads x1 z1 coord*, unit(id);
  
		/* Give distance the same SD as the other variables. */
  
  generat distance = sqrt((coord_x_01-coord_x_02)^2 + (coord_y_01-coord_y_02)^2)/2.5;
  
  drawnorm w_ij, mean(0) sd(1);

  save montecarlo-seq-indvars, replace;

  
	/**************************************************/
	/* Now clear everything and start the simulation. */
	/**************************************************/

	
clear;
  
save montecarlo-seq, replace emptyok;
  
forvalues rho=-0.75(0.25)0.75 {;
  
  simulate b0=r(b0) b1=r(b1) b2=r(b2) b3=r(b3) b4=r(b4) 
	a0=r(a0) a1=r(a1) a2=r(a2) a3=r(a3) a4=r(a4)
	g0=r(g0) g1=r(g1) g2=r(g2) g3=r(g3) g4=r(g4)
	se_b0=r(se_b0) se_b1=r(se_b1) se_b2=r(se_b2) se_b3=r(se_b3) se_b4=r(se_b4) 
	se_a0=r(se_a0) se_a1=r(se_a1) se_a2=r(se_a2) se_a3=r(se_a3) se_a4=r(se_a4)
	se_g0=r(se_g0) se_g1=r(se_g1) se_g2=r(se_g2) se_g3=r(se_g3) se_g4=r(se_g4) 
	var_y2=r(var_y2) var_y2hat=r(var_y2hat) rho=r(rho), 
	reps(500) saving("sims/montecarlo-seq-(rho=`rho').dta", replace):  
	mc_seq, indvars(montecarlo-seq-indvars) rho(`rho');
	
	append using montecarlo-seq;
	
	save montecarlo-seq, replace;
  
  };

		/* Now create some figures summarizing the results. */
  
use montecarlo-seq, clear;
  
collapse (mean) a* b* g* se*
	(sd) sd_a0=a0 sd_a1=a2 sd_a2=a2 sd_a3=a3 sd_a4=a4 sd_b0=b0 sd_b1=b2 sd_b2=b2 sd_b3=b3 sd_b4=b4
	sd_g0=g0 sd_g1=g2 sd_g2=g2 sd_g3=g3 sd_g4=g4, by(rho);

	generat b3_ci_lo = b3 - 1.96*sd_b3;
	generat b3_ci_hi = b3 + 1.96*sd_b3;
	generat b4_ci_lo = b4 - 1.96*sd_b4;
	generat b4_ci_hi = b4 + 1.96*sd_b4;

	generat a3_ci_lo = a3 - 1.96*sd_a3;
	generat a3_ci_hi = a3 + 1.96*sd_a3;
	generat a4_ci_lo = a4 - 1.96*sd_a4;
	generat a4_ci_hi = a4 + 1.96*sd_a4;
	
	generat g3_ci_lo = g3 - 1.96*sd_g3;
	generat g3_ci_hi = g3 + 1.96*sd_g3;
	generat g4_ci_lo = g4 - 1.96*sd_g4;
	generat g4_ci_hi = g4 + 1.96*sd_g4;
		
	generat b1_rmse = sqrt((b1 - 0.25)^2 + sd_b1^2);
	generat b2_rmse = sqrt((b2 - 0.25)^2 + sd_b2^2);
	generat b3_rmse = sqrt((b3 + 1)^2 + sd_b3^2);
	generat b4_rmse = sqrt((b4 + 0.25)^2 + sd_b4^2);

	generat a1_rmse = sqrt((a1 - 0.25)^2 + sd_a1^2);
	generat a2_rmse = sqrt((a2 - 0.25)^2 + sd_a2^2);
	generat a3_rmse = sqrt((a3 + 1)^2 + sd_a3^2);
	generat a4_rmse = sqrt((a4 + 0.25)^2 + sd_a4^2);

	generat g1_rmse = sqrt((g1 - 0.25)^2 + sd_g1^2);
	generat g2_rmse = sqrt((g2 - 0.25)^2 + sd_g2^2);
	generat g3_rmse = sqrt((g3 + 1)^2 + sd_g3^2);
	generat g4_rmse = sqrt((g4 + 0.25)^2 + sd_g4^2);
	
	save montecarlo-seq-collapsed, replace;
  
  twoway connected a1 a2 g1 g2 b1 b2 rho, scheme(s1color) 
	lcolor(navy navy orange_red orange_red dkgreen dkgreen)
	mcolor(navy navy orange_red orange_red dkgreen dkgreen)
	lpattern(solid dash solid dash solid dash)
	yline(0.25)
	ylabel(0.20(0.025)0.30, grid)
	xlabel(-0.75(0.25)0.75)
	legend(label(1 b_x1 Corrected (Instrumented Network)) label(2 b_x2 Corrected (Instrumented Network)) 
	  label(3 b_x1 Corrected (Instrumented Score)) label(4 b_x2 Corrected (Instrumented Score))
	  label(5 b_x1 Uncorrected) label(6 b_x2 Uncorrected) order(1 2 3 4 5 6) cols(2))
	xtitle(rho)
	saving(graphs/montecarlo-seq-b_x, replace);
	
  twoway connected b3 g3 a3 rho, scheme(s1color) 
	lcolor(gs0 gs5 gs10)
	lwidth(medium medium medium)
	mcolor(gs0 gs5 gs10)
	msymbol(O S T)
    || 	line b3_ci_lo b3_ci_hi g3_ci_lo g3_ci_hi a3_ci_lo a3_ci_hi rho, 
	lcolor(gs0 gs0 gs5 gs5 gs10 gs10)
	lpattern(longdash longdash longdash longdash longdash longdash)
	lwidth(medium medium medium medium medium medium)
	yline(-1)
	xlabel(-0.75(0.25)0.75)
	ylabel(#5, grid)
	legend(label(1 Uncorrected) label(2 Instrumented Score) label(3 Instrumented Network) order(1 2 3) rows(1) size(small))
	xtitle(Error Correlation)
	title(SEq)
	saving(graphs/montecarlo-seq-b_seq-bw, replace);
	
  twoway connected b4 g4 a4 rho, scheme(s1color) 
	lcolor(gs0 gs5 gs10)
	lwidth(medium medium medium)
	mcolor(gs0 gs5 gs10)
	msymbol(O S T)
    || 	line b4_ci_lo b4_ci_hi g4_ci_lo g4_ci_hi a4_ci_lo a4_ci_hi rho, 
	lcolor(gs0 gs0 gs5 gs5 gs10 gs10)
	lpattern(longdash longdash longdash longdash longdash longdash)
	lwidth(medium medium medium medium medium medium)
	yline(-0.25)
	xlabel(-0.75(0.25)0.75)
	ylabel(#5, grid)
	legend(label(1 Uncorrected) label(2 Instrumented Score) label(4 Instrumented Network) order(1 2 4) rows(1) size(small))
	xtitle(Error Correlation)
	title(SEq)
	saving(graphs/montecarlo-seq-b_distance-bw, replace);
	
		/* SE-SD comparison. */
  
  graph bar se_b3 sd_b3 se_g3 sd_g3 se_a3 sd_a3, over(rho) scheme(s1color)
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50))
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50))
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50))
	legend(label(1 SE Uncorrected) label(2 SD Uncorrected) label(3 SE Instrumented Score) label(4 SD Instrumented Score)
	   label(5 SE Instrumented Network) label(6 SD Instrumented Network))
	saving(graphs/montecarlo-seq-se_seq, replace);

  graph bar se_b1 sd_b1 se_g1 sd_g1 se_a1 sd_a1, over(rho) scheme(s1color)
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50))
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50))
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50))
	legend(label(1 SE Uncorrected) label(2 SD Uncorrected) label(3 SE Instrumented Score) label(4 SD Instrumented Score)
	   label(5 SE Instrumented Network) label(6 SD Instrumented Network))
	saving(graphs/montecarlo-seq-se_x1, replace);
  
  graph bar se_b2 sd_b2 se_g2 sd_g2 se_a2 sd_a2, over(rho) scheme(s1color) 
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50))
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50))
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50))
	legend(label(1 SE Uncorrected) label(2 SD Uncorrected) label(3 SE Instrumented Score) label(4 SD Instrumented Score)
	   label(5 SE Instrumented Network) label(6 SD Instrumented Network))
	saving(graphs/montecarlo-seq-se_x2, replace);
  
  graph bar se_b4 sd_b4 se_g4 sd_g4 se_a4 sd_a4, over(rho) scheme(s1color) 
	bar(1, color(navy) fintensity(inten100)) bar(2, color(navy) fintensity(inten50))
	bar(3, color(brown) fintensity(inten100)) bar(4, color(brown) fintensity(inten50))
	bar(5, color(dkgreen) fintensity(inten100)) bar(6, color(dkgreen) fintensity(inten50))
	legend(label(1 SE Uncorrected) label(2 SD Uncorrected) label(3 SE Instrumented Score) label(4 SD Instrumented Score)
	   label(5 SE Instrumented Network) label(6 SD Instrumented Network))
	saving(graphs/montecarlo-seq-se_distance, replace);
  
		/* RMSE comparison. */
 
  graph bar b1_rmse g1_rmse a1_rmse, over(rho) scheme(s1color)
	bar(1, color(navy) fintensity(inten100))
	bar(2, color(brown) fintensity(inten100))
	bar(3, color(dkgreen) fintensity(inten100))
	legend(label(1 Uncorrected) label(2 Instrumented Score) label(3 Instrumented Network) rows(1) size(small))
	saving(graphs/montecarlo-seq-rmse_x1, replace);

  graph bar b2_rmse g2_rmse a2_rmse, over(rho) scheme(s1color)
	bar(1, color(navy) fintensity(inten100))
	bar(2, color(brown) fintensity(inten100))
	bar(3, color(dkgreen) fintensity(inten100))
	legend(label(1 Uncorrected) label(2 Instrumented Score) label(3 Instrumented Network) rows(1) size(small))
	saving(graphs/montecarlo-seq-rmse_x2, replace);

  graph bar b3_rmse g3_rmse a3_rmse, over(rho) scheme(s1mono)
	bar(1, color(gs0) fintensity(inten100))
	bar(2, color(gs5) fintensity(inten100))
	bar(3, color(gs10) fintensity(inten100))
	title(SEq)
	legend(label(1 Uncorrected) label(2 Instrumented Score) label(3 Instrumented Network) rows(1) size(small))
	saving(graphs/montecarlo-seq-rmse_seq-bw, replace);
	
  graph bar b4_rmse g4_rmse a4_rmse, over(rho) scheme(s1color)
	bar(1, color(navy) fintensity(inten100))
	bar(2, color(brown) fintensity(inten100))
	bar(3, color(dkgreen) fintensity(inten100))
	legend(label(1 Uncorrected) label(2 Instrumented Score) label(3 Instrumented Network) rows(1) size(small))
	saving(graphs/montecarlo-seq-rmse_distance, replace);

		/* Clean up program-generated files. */
		
erase montecarlo-seq-indvars.dta;

clear;
log close;
exit, STATA;
