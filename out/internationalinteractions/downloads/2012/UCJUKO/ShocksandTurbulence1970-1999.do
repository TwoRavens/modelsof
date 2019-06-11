#delimit;
clear;
set more off;
quietly log;
local logon = r(status);
if "`logon'" == "on" {; log close; };
log using 306NiemanHW6.log, text replace;
version 10.1;

/************************************************************/
/*****  Mark David Nieman                               *****/
/*****  December 14, 2009                               *****/
/*****  Pol Sci 306                                     *****/
/*****  Project: Shocks and Turbulence                  *****/
/*****  Output: Table 1, 2, 3, Graph 1, 2               *****/
/*****  Stata 10.1                                      *****/
/************************************************************/

use ShocksandTurbulence1970-1999;
set seed 77;

/* label variables */
	lab var onset "Civil War";
	lab var warl "Previous War";
	lab var gdpenl "GDP/Capita";
	lab var lpopl "Population";
	lab var lmtnest "Mountains";
	lab var ncontig "Non-contiguous";
	lab var oil "Oil";
	lab var nwstate "New State";
	lab var instab "Instability";
	lab var polity2l "Democracy";
	lab var ethfrac "Ethnic Fraction";
	lab var relfrac "Religious Fraction";
	lab var globallag "Globalization";
	lab var econgloblag "Econ Global";
	lab var socgloblag "Social Global";
	lab var polgloblag "Political Global";
	lab var globaldfperlag "Global Shock";
	lab var econdfperlag "Economic Shock";
	lab var socdfperlag "Social Shock";
	lab var poldfperlag "Political Shock";
	lab var ShGlobPower "Global*Power";
	lab var ShEconPower "Econ*Power";
	lab var ShGlobPolity "Global*Democ";
	lab var ShEconPolity "Econ*Democ";
	lab var globshock "Global Shock";
	lab var econshock "Economic Shock";
	lab var socshock "Social Shock";
	lab var polshock "Political Shock";
	lab var GlobPower "Global*Power";
	lab var EconPower "Econ*Power";
	lab var GlobDemoc "Global*Democ";
	lab var EconDemoc "Econ*Democ";


/* Add cubic polynomial to Fearon and Laitin (2003) model */

	/* Replicate Fearon for available years, using naive logit model */
	logit onset warl gdpenl lpopl lmtnest ncontig oil nwstate instab 
	polity2l ethfrac relfrac;

	/* How the cubic polynomials were generated */
	/* Subtract 1969 from year since 1970 is first year in model; */
	/*   hence t=1 for 1970 */
	/* gen t = year - 1969 */
	/* gen t2 = t^2 */
	/* gen t3 = t^3 */
	
	/* Add in the cubic polynomial */
	logit onset warl gdpenl lpopl lmtnest ncontig oil nwstate instab 
	polity2l ethfrac relfrac t t2 t3;

	/* Add in clustering by country, as this is not done by F&L */
	logit onset warl gdpenl lpopl lmtnest ncontig oil nwstate instab 
	polity2l ethfrac relfrac t t2 t3, vce(cluster ccode);

	/* Note that the coefficient values and standard errors have */
	/*   increased minimally. */

	
save ShocksandTurbulence1970-1999, replace;	
	

/* Initial Correlation Matrix of IVs */
	pwcorr onset globallag econgloblag socgloblag polgloblag globshock econshock 
	socshock polshock GlobPower EconPower GlobDemoc EconDemoc warl gdpenl lpopl lmtnest ncontig oil nwstate instab polity2l
	ethfrac relfrac t t2 t3, sig;
	
/* Table 2 (Globalization): Updated Fearon, Globalization, Economic Globalization */
/*    Social Globalization, Political Globalization */
	
	/* Replicate Fearon for available years, using naive logit model */
	logit onset warl gdpenl lpopl lmtnest ncontig oil nwstate instab 
	polity2l ethfrac relfrac;
	estimates store globfearon;

	/* Updated Fearon with cubic polynomials and clustering by country */
	logit onset warl gdpenl lpopl lmtnest ncontig oil nwstate instab 
	polity2l ethfrac relfrac t t2 t3, vce(cluster ccode);
	estimates store globfearonupdate;
	
	/* Globalization */
	logit onset globallag warl gdpenl lpopl lmtnest ncontig oil nwstate instab 
	polity2l ethfrac relfrac t t2 t3, vce(cluster ccode);
	estimates store globall;
	
	/* Subsets of Globalization */
	logit onset econgloblag socgloblag polgloblag  warl gdpenl lpopl lmtnest ncontig oil nwstate instab 
	polity2l ethfrac relfrac t t2 t3, vce(cluster ccode);
	estimates store globecon;
	

/* Table 3 (Shocks): Globalization, Economic Globalization, Social Globalization */
/*	  Political Globalization */
	/* Globalization */
	logit onset globshock warl gdpenl lpopl lmtnest ncontig oil nwstate instab 
	polity2l ethfrac relfrac t t2 t3, vce(cluster ccode);
	estimates store shockglob;
	
	/* Subsets of Globalization */
	logit onset econshock socshock polshock gdpenl warl lpopl lmtnest ncontig oil nwstate instab 
	polity2l ethfrac relfrac t t2 t3, vce(cluster ccode);
	estimates store shockecon;
	
	/* Globalization * State Power */
	logit onset GlobPower globshock warl gdpenl lpopl lmtnest ncontig 
	oil nwstate instab polity2l ethfrac relfrac t t2 t3, vce(cluster ccode);
	estimates store shockglobpow;
	
		grinter globshock, inter(GlobPower) const02(gdpenl);
		/* This suggests that the marginal effect of globalization shocks is */
		/*   statistically insignificant when interacted with state power */
	
	/* Economic Globalization * State Power */
	logit onset EconPower econshock warl gdpenl lpopl lmtnest ncontig 
	oil nwstate instab polity2l ethfrac relfrac t t2 t3, vce(cluster ccode);
	estimates store shockeconpow;
	
		grinter econshock, inter(EconPower) const02(gdpenl);
		/* This suggests that the marginal effect of economic globalization */
		/*   shocks is statistically insignificant when interacted with state */
		/*   power. */
	
	/* Globalization * Regime type */
	logit onset GlobDemoc globshock warl gdpenl lpopl lmtnest ncontig oil 
	nwstate instab polity2l ethfrac relfrac t t2 t3, vce(cluster ccode);
	
	
		grinter globshock, inter(GlobDemoc) const02(polity2l) yline(0);
		
	/* Economic Globalization * Regime Type */
	logit onset EconDemoc econshock warl gdpenl lpopl lmtnest ncontig oil 
	nwstate instab polity2l ethfrac relfrac t t2 t3, vce(cluster ccode);
	
	
		grinter econshock, inter(EconDemoc) const02(polity2l) yline(0);
	
/* Make Tables */
	/* Table 1: Summary statistics  */
	sum onset globallag econgloblag socgloblag polgloblag globshock econshock socshock polshock gdpenl 
	warl lpopl lmtnest ncontig oil nwstate instab polity2l ethfrac relfrac;

	/* Table 2 */
	estout glob*, c(b(fmt(3) star) se(fmt(3) par) unstack) 
	modelwidth(10) stats(N ll)  starlevels(* .1 ** 0.05 *** 0.01) 
	legend label wrap varwidth(20) collabels(none) 
	varlabels(_cons Constant) mlabels("Replication Yrs" "Replication Cluster" "Full" "Components")
	title(Table 2. Globalization and Civil War Onset, 1970-1999);
	
	/* Table 3 */
	estout shock*, c(b(fmt(3) star) se(fmt(3) par) unstack) 
	modelwidth(10) stats(N ll)  starlevels(* .1 ** 0.05 *** 0.01) 
	legend label wrap varwidth(20) collabels(none) 
	varlabels(_cons Constant) mlabels("Full" "Components" "Glob*Power" "Econ Glob*Power")
	title(Table 3. Globalization Shocks and Civil War Onset, 1970-1999);

	
/* Make predicted probabilities */
clear;
use ShocksandTurbulence1970-1999;

/* Predicted probability of changing the level of Economic Globalization */
/*   on civil war onset */

	/* First run the logit clustered cubic polinomial */
	/* nwstate is dropped because it drops out in the original model */
	logit onset econgloblag socgloblag polgloblag  warl gdpenl lpopl lmtnest ncontig oil instab 
	polity2l ethfrac relfrac t t2 t3, vce(cluster ccode);
	
	/* Collapse the variables to isolate the effects of Econ Glob */
	collapse (mean) econgloblag socgloblag polgloblag  lpopl lmtnest polity2l ethfrac relfrac t t2 t3 
	(median) gdpenl warl ncontig oil instab;
	
	matrix C = e(V);
	matrix B = e(b);
	
	expand 100;
	replace econgloblag = 1 + _n - 1;
	
	expand 100;
	
	drawnorm b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b0, mean(B) cov(C);
	
	gen xbhat = b0 + b1*econgloblag + b2*socgloblag + b3*polgloblag + b4*warl + b5*gdpenl + 
	b6*lpopl + b7*lmtnest + b8*ncontig + b9*oil + b10*instab + b11*polity2l + b12*ethfrac + 
	b13*relfrac + b14*t + b15*t2 + b16*t3;
	
	gen pihat = 1/(1+exp(-xbhat));
	
	collapse (mean) pihat (p5) pihat90_lo=pihat (p95) pihat90_hi=pihat, by(econgloblag);
	
	/* Make graph */
	twoway line pihat pihat90_lo pihat90_hi econgloblag,  scheme(s2mono) sort
	lpattern(solid dash dash)
	xtitle(Economic Globalization)
	t2(Graph 1. Effect of Economic Globalization on Civil War Occurence)
	legend(off)
	note(Dashed lines give 90% confidence interval);
	graph save GlobCiv, replace;

clear;
use ShocksandTurbulence1970-1999;

	/* Predicted probability of econ globalization shock on civil war onset */
	/* nwstate is dropped since if was dropped in the previous model */
	logit onset econshock socshock polshock gdpenl warl lpopl lmtnest ncontig oil instab 
	polity2l ethfrac relfrac t t2 t3, vce(cluster ccode);
	
	/* Collapse the variables to isolate the effects of Econ Glob */
	collapse (mean) econshock socshock polshock lpopl lmtnest polity2l ethfrac relfrac  t t2 t3
	(median) gdpenl warl ncontig oil instab;
	
	matrix C = e(V);
	matrix B = e(b);
	
	/* Since it is possible to have a dramatic decrease in globalization */
	expand 100;
	replace econshock = 1 + _n - 1;
	
	expand 100;
	
	drawnorm b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13 b14 b15 b16 b0, mean(B) cov(C);
	
	gen xbhat = b0 + b1*econshock + b2*socshock + b3*polshock + b4*gdpenl + b5*warl + b6*lpopl
	+ b7*lmtnest + b8*ncontig + b9*oil + b10*instab + b11*polity2l + b12*ethfrac + 
	b13* relfrac +	b14*t + b15*t2 + b16*t3;
	
	gen pihat = 1/(1+exp(-xbhat));
	
	collapse (mean) pihat (p5) pihat90_lo=pihat (p95) pihat90_hi=pihat, by(econshock);
	
	/* Make graph */
	twoway line pihat pihat90_lo pihat90_hi econshock,  scheme(s2mono) sort
	lpattern(solid dash dash)
	xtitle(Economic Globalization Shock)
	t2(Graph 2. Effect of Economic Globalization Shocks on Civil War Occurence)
	legend(off)
	note(Dashed lines give 90% confidence interval);
	graph save ShockCiv, replace;
	
	clear;
use ShocksandTurbulence1970-1999;


clear;
use ShocksandTurbulence1970-1999;

/* Clarify for Glob Shocks */
	logit onset globshock warl gdpenl lpopl lmtnest ncontig oil instab polity2l ethfrac
	relfrac t t2 t3, vce(cluster ccode);
	
	estsimp logit onset globshock warl gdpenl lpopl lmtnest ncontig oil instab polity2l 
	ethfrac relfrac t t2 t3, vce(cluster ccode);
	
	setx globshock p50 warl median gdpenl median lpopl mean lmtnest mean ncontig median 
	oil median instab median polity2l mean ethfrac mean relfrac mean t mean 
	t2 mean t3 mean;
	
	simqi;
	
	setx globshock p83.5 warl median gdpenl median lpopl mean lmtnest mean ncontig median 
	oil median instab median polity2l mean ethfrac mean relfrac mean t mean 
	t2 mean t3 mean;
	
	simqi;

