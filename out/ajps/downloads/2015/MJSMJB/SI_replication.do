*	4/23/2015
*
*	Replication file for Philips, Andrew, Amanda Rutherford, and Guy D. Whitten
*	"Dynamic pie: A strategy for modeling trade-offs in compositional variables
*	over time" American Journal of Political Science.
*
*								SI REPLICATION
*	-------------------------------------------------------------------------

*	NOTE: Since the Monte Carlos take a long time to run (over 24 hrs), for 
*	convenience we have included the compressed output in a dataset under
*	the following:
*		- SI_baseline_uroot.dta
*		- SI_baseline_nouroot.dta


* 	NOTE: code to replicate dynamic simulations included in the SI are in the 
*	US_replication.do and UK_replication.do files.



* verify burd is on here for nice graphs
foreach package in scheme-burd  {
		capture which `package'
		if _rc==111 ssc install `package'
 	}
set scheme burd
* findit estsimp		// if user needs to download clarify
findit lmanlsur			// needed for SUR autocorrelation test
findit grc1leg			// needed for making graphs



* --------------------------------------------------------------------------*
*		SECTION 1: MONTE CARLO
* --------------------------------------------------------------------------*

* Below is the code for the Monte Carlo simulation. 

*				1. Baseline category is always a unit root FIG S1
*	-------------------------------------------------------------------------
program drop _all
clear
set seed 19690313

global nobs = 61					//	# of obs
global nmc = 100				// # of reps per batch
global batch = 100					// # of batches to save datasets
set obs $nobs
gen t = _n
tsset t

scalar beta = 2.00 					// X slope
scalar rho = 1.00					// autocorrelation in X
scalar phi1 = 1.00					// autocorrelation in errors
scalar errorcorr = 0.5				// correlation in errors at t=1
scalar phi2 = 0.9					// correlation in non-unit root errors

matrix C = (1, errorcorr, errorcorr, errorcorr, errorcorr \  ///
 			errorcorr, 1, errorcorr , errorcorr, errorcorr \ ///
 			errorcorr, errorcorr, 1, errorcorr, errorcorr \  ///
 			errorcorr, errorcorr, errorcorr, 1, errorcorr \  ///
 			errorcorr, errorcorr, errorcorr, errorcorr, 1)

gen x = rnormal() + 100
replace x = rho*l.x + rnormal() in 2/$nobs

local i 1
while `i' <= 5	{						
	gen y`i' = 100						
	local i = `i' + 1
}
gen tot = y1 + y2 + y3 + y4 + y5

local i 1
while `i' <= 5	{
	gen y`i'_pie = y`i' / tot			
	local i = `i' + 1
}

drawnorm u1 u2 u3 u4 u5, cov(C)			
drawnorm v1 v2 v3 v4 v5, cov(C)			

tlogit y1_pie y1_y5 y2_pie y2_y5 y3_pie y3_y5 y4_pie y4_y5, base(y5_pie)

gen dy1_y5 = d.y1_y5  in 2/$nobs		
gen dy2_y5 = d.y2_y5  in 2/$nobs
gen dy3_y5 = d.y3_y5  in 2/$nobs
gen dy4_y5 = d.y4_y5  in 2/$nobs
gen dx = 	 d.x  	  in 2/$nobs
gen ly1_y5 = l.y1_y5  in 2/$nobs
gen ly2_y5 = l.y2_y5  in 2/$nobs
gen ly3_y5 = l.y3_y5  in 2/$nobs
gen ly4_y5 = l.y4_y5  in 2/$nobs
gen lx = 	 l.x  	  in 2/$nobs

* start the program	----------------------------------------------
cap prog drop ARsimMC
program ARsimMC, rclass
tempname sim

local b 1											// saves each batch #
while `b' <= $batch	{
postfile `sim' phi2 no_roots errorcorr lmgp loc_hlmp_1 loc_hlmp_2 loc_hlmp_3 loc_hlmp_4 dwatson_1 dwatson_2 dwatson_3 dwatson_4 using results`b', replace
di
nois _dots 0, title(Simulation in Progress for batch `b') reps($nmc)
qui	{
local m 1
while `m' <= $nmc	{
	noi _dots `m'  0
	local nr = 0				
	while `nr' <= 4	{
		local p 0.00
		while `p' < 1	{				
			scalar phi1 = 1.00			
			scalar phi2 = `p'	
			local er 0
			while `er' <= .9	{
				scalar errorcorr = `er'	// correlation between errors	
				matrix C = (1, errorcorr, errorcorr, errorcorr, errorcorr \  ///
				errorcorr, 1, errorcorr , errorcorr, errorcorr \ errorcorr,  ///
				errorcorr, 1, errorcorr, errorcorr \ errorcorr, errorcorr,   ///
				errorcorr, 1, errorcorr \  errorcorr, errorcorr, errorcorr,  ///
				errorcorr, 1)			// correlation structure of errors
				
				drop v* u*
				drawnorm u1 u2 u3 u4 u5, cov(C)
				drawnorm v1 v2 v3 v4 v5, cov(C)
				
				local o 1
				while `o' <= 5	{
					if `o' <= `nr' { 
						replace u`o' = phi2*u`o'[_n-1] + v`o' in 2/$nobs
					}
					else	{		
						replace u`o' = phi1*u`o'[_n-1] + v`o' in 2/$nobs
					}
					replace y`o' = beta*x + u`o' in 2/$nobs					
					local o = `o' + 1
				}
				replace tot = y1 + y2 + y3 + y4 + y5 in 2/$nobs
				local l 1
				while `l' <= 5	{		
					replace y`l'_pie = y`l'/tot
					local l = `l' + 1
				}
				drop y1_y5 y2_y5 y3_y5 y4_y5 
				tlogit y1_pie y1_y5 y2_pie y2_y5 y3_pie y3_y5 y4_pie y4_y5, base(y5_pie)
				* SUR-ECM regression:
				replace dy1_y5 = y1_y5-y1_y5[_n-1] in 2/$nobs
				replace dy2_y5 = y2_y5-y2_y5[_n-1] in 2/$nobs
				replace dy3_y5 = y3_y5-y3_y5[_n-1] in 2/$nobs
				replace dy4_y5 = y4_y5-y4_y5[_n-1] in 2/$nobs
				replace dx = x-x[_n-1] in 2/$nobs	
				replace ly1_y5 = y1_y5[_n-1] in 2/$nobs
				replace ly2_y5 = y1_y5[_n-1] in 2/$nobs
				replace ly3_y5 = y1_y5[_n-1] in 2/$nobs
				replace ly4_y5 = y1_y5[_n-1] in 2/$nobs
				replace lx = x[_n-1] in 2/$nobs
				
				sureg (dy1_y5 ly1_y5 dx lx) ///
			 	(dy2_y5 ly2_y5 dx lx)		///
			 	(dy3_y5 ly3_y5 dx lx) 		///
			 	(dy4_y5 ly4_y5 dx lx)
			 	
			 	lmanlsur // autocorrelation test
			 	return list
				* p value Harvey LM test for global system autocorr
				scalar glob_hlmp = r(lmgp)
				* p value for Harvey LM test for each system
				scalar loc_hlmp_1 = r(lmhp_1)
				scalar loc_hlmp_2 = r(lmhp_2)
				scalar loc_hlmp_3 = r(lmhp_3)
				scalar loc_hlmp_4 = r(lmhp_4)
				* DW-statistic
				scalar dwatson_1 = r(lmadw_1)
				scalar dwatson_2 = r(lmadw_2)
				scalar dwatson_3 = r(lmadw_3)
				scalar dwatson_4 = r(lmadw_4)

				post `sim' (`p') (`nr') (errorcorr) (glob_hlmp)		///
				(loc_hlmp_1) (loc_hlmp_2) (loc_hlmp_3) (loc_hlmp_4) ///
				(dwatson_1) (dwatson_2) (dwatson_3) (dwatson_4)
				
				local er = `er' + 0.2
			}
				
			local p = `p' + 0.2
		}
		
		local nr = `nr' + 1
	}

	local m = `m' + 1
}
}
postclose `sim'									// close sim

local b = `b' + 1
}												// close batch
end
*	-------------------------------------------------------------------------

timer on 1
ARsimMC
timer off 1
timer list 1

*							ANALYSIS
* 	----------------------------------------------------------------------------
use results1, clear

forv i = 2/100	{
	append using results`i'.dta
}

collapse (mean) lmgp-dwatson_4, by(phi2 no_roots errorcorr)
tab errorcorr
tab no_roots
tab phi2

egen error=group (errorcorr)
list error errorcorr in 1/50


*	FOR REPLICATION PURPOSES CAN OPEN THE COMPRESSED OUTPUT:
use SI_baseline_uroot.dta, clear



* Harvey Global LM test:	error corr = 0.0
preserve
keep if error==1
qui twoway line lmgp phi2 if no_roots==0, lpattern(solid) lwidth(medthick) ///
 || line lmgp phi2 if no_roots==1, lpattern(longdash) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==2, lpattern(shortdash) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==3, lpattern(dash_dot) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==4, lpattern(dot) lcolor(black)			///
 lwidth(medthick) legend( order(1 "0 I(0) Series" 2 "1 I(0) Series" 3 "2 I(0) Series" 4 "3 I(0) Series" 5 "4 I(0) Series") size(small) rows(1)) ///
yline(0.05)  ytitle("p-value", size(small))							///
 xtitle("Temporal Autocorrelation ({bf:{&rho}{subscript:j j}})", size(small)) ///
 title("Contemporaneous Correlation ({bf:{&rho}{subscript:i j}}) = 0.0", size(small))
graph save g1, replace
restore

* Harvey Global LM test:	error corr = 0.2
preserve
keep if error==2
qui twoway line lmgp phi2 if no_roots==0, lpattern(solid) lwidth(medthick) ///
 || line lmgp phi2 if no_roots==1, lpattern(longdash) lwidth(medthick)	///
 ||	line lmgp phi2 if no_roots==2, lpattern(shortdash) lwidth(medthick)	///
 ||	line lmgp phi2 if no_roots==3, lpattern(dash_dot) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==4, lpattern(dot) lcolor(black)			///
 lwidth(medthick) legend( order(1 "0 I(0) Series" 2 "1 I(0) Series" 3 "2 I(0) Series" 4 "3 I(0) Series" 5 "4 I(0) Series") size(small) rows(1)) ///
 yline(0.05)  ytitle("p-value", size(small))						///
 xtitle("Temporal Autocorrelation ({bf:{&rho}{subscript:j j}})", size(small)) ///
 title("Contemporaneous Correlation ({bf:{&rho}{subscript:i j}}) = 0.2", size(small))
graph save g2, replace
restore

* Harvey Global LM test:	error corr = 0.4
preserve
keep if error==3
qui twoway line lmgp phi2 if no_roots==0, lpattern(solid) lwidth(medthick) ///
 || line lmgp phi2 if no_roots==1, lpattern(longdash) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==2, lpattern(shortdash) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==3, lpattern(dash_dot) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==4, lpattern(dot) lcolor(black) 			///
 lwidth(medthick) legend( order(1 "0 I(0) Series" 2 "1 I(0) Series" 3 "2 I(0) Series" 4 "3 I(0) Series" 5 "4 I(0) Series") size(small) rows(1)) ///
 yline(0.05)  ytitle("p-value", size(small))						///
 xtitle("Temporal Autocorrelation ({bf:{&rho}{subscript:j j}})", size(small)) ///
 title("Contemporaneous Correlation ({bf:{&rho}{subscript:i j}}) = 0.4", size(small))
graph save g3, replace
restore

* Harvey Global LM test:	error corr = 0.6
preserve
keep if error==4
qui twoway line lmgp phi2 if no_roots==0, lpattern(solid) lwidth(medthick) ///
 || line lmgp phi2 if no_roots==1, lpattern(longdash) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==2, lpattern(shortdash) lwidth(medthick)	///
 ||	line lmgp phi2 if no_roots==3, lpattern(dash_dot) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==4, lpattern(dot) lcolor(black)			///
 lwidth(medthick) legend( order(1 "0 I(0) Series" 2 "1 I(0) Series" 3 "2 I(0) Series" 4 "3 I(0) Series" 5 "4 I(0) Series") size(small) rows(1)) ///
 yline(0.05)  ytitle("p-value", size(small))						///
 xtitle("Temporal Autocorrelation ({bf:{&rho}{subscript:j j}})", size(small)) ///
 title("Contemporaneous Correlation ({bf:{&rho}{subscript:i j}}) = 0.6", size(small))
graph save g4, replace
restore

grc1leg g1.gph g2.gph g3.gph g4.gph, legendfrom(g1.gph)		///
title("Baseline is always I(1)", size(medium))				///
note("H0: No Global Autocorrelation", size(small)) ycommon
graph export MC_ECMSUR_uroot.eps, as(eps) preview(off) replace



*	-------------------------------------------------------------------------
*				2. Baseline category is never a unit root -- FIG S2
*	-------------------------------------------------------------------------

program drop _all
clear
set seed 19690313

global nobs = 61					//	# of obs
global nmc = 100					// # of reps per batch
global batch = 100					// # of batches to save datasets
set obs $nobs
gen t = _n
tsset t

scalar beta = 2.00 					
scalar rho = 1.00					
scalar phi1 = 1.00					
scalar errorcorr = 0.5				
scalar phi2 = 0.9					

*	define correlation structure of our errors:
matrix C = (1, errorcorr, errorcorr, errorcorr, errorcorr \  ///
 			errorcorr, 1, errorcorr , errorcorr, errorcorr \ ///
 			errorcorr, errorcorr, 1, errorcorr, errorcorr \  ///
 			errorcorr, errorcorr, errorcorr, 1, errorcorr \  ///
 			errorcorr, errorcorr, errorcorr, errorcorr, 1)

gen x = rnormal() + 100
replace x = rho*l.x + rnormal() in 2/$nobs

local i 1
while `i' <= 5	{						
	gen y`i' = 100						
	local i = `i' + 1
}
gen tot = y1 + y2 + y3 + y4 + y5

local i 1
while `i' <= 5	{
	gen y`i'_pie = y`i' / tot			
	local i = `i' + 1
}

drawnorm u1 u2 u3 u4 u5, cov(C)			// correlated error
drawnorm v1 v2 v3 v4 v5, cov(C)			

* may need to download clarify for this:
tlogit y1_pie y1_y5 y2_pie y2_y5 y3_pie y3_y5 y4_pie y4_y5, base(y5_pie)

gen dy1_y5 = d.y1_y5  in 2/$nobs		
gen dy2_y5 = d.y2_y5  in 2/$nobs
gen dy3_y5 = d.y3_y5  in 2/$nobs
gen dy4_y5 = d.y4_y5  in 2/$nobs
gen dx = 	 d.x  	  in 2/$nobs
gen ly1_y5 = l.y1_y5  in 2/$nobs
gen ly2_y5 = l.y2_y5  in 2/$nobs
gen ly3_y5 = l.y3_y5  in 2/$nobs
gen ly4_y5 = l.y4_y5  in 2/$nobs
gen lx = 	 l.x  	  in 2/$nobs

* now start the program	----------------------------------------------
cap prog drop ARsimMC2
program ARsimMC2, rclass
tempname sim

local b 1											// saves each batch #
while `b' <= $batch	{
postfile `sim' phi2 no_roots errorcorr lmgp loc_hlmp_1 loc_hlmp_2 loc_hlmp_3 loc_hlmp_4 dwatson_1 dwatson_2 dwatson_3 dwatson_4 using results2_`b', replace

di
nois _dots 0, title(Simulation in Progress for batch `b') reps($nmc)
qui	{

local m 1
while `m' <= $nmc	{
	noi _dots `m'  0
	local nr = 0			
	while `nr' <= 4	{	
		local p 0.00
		while `p' < 1	{				
			scalar phi1 = 1.00			
			scalar phi2 = `p'		
			local er 0
			while `er' <= .9	{
				scalar errorcorr = `er'	// correlation between errors		
				matrix C = (1, errorcorr, errorcorr, errorcorr, errorcorr \  ///
				errorcorr, 1, errorcorr , errorcorr, errorcorr \ errorcorr,  ///
				errorcorr, 1, errorcorr, errorcorr \ errorcorr, errorcorr,   ///
				errorcorr, 1, errorcorr \  errorcorr, errorcorr, errorcorr,  ///
				errorcorr, 1)			// correlation structure of errors		
				drop v* u*
				drawnorm u1 u2 u3 u4 u5, cov(C)
				drawnorm v1 v2 v3 v4 v5, cov(C)	
				local o 1
				while `o' <= 5	{
					if `o' <= `nr' { 
						replace u`o' = phi2*u`o'[_n-1] + v`o' in 2/$nobs
					}
					else if `o' < 5	{	
						replace u`o' = phi1*u`o'[_n-1] + v`o' in 2/$nobs
					}
					else	{ 		
						replace u`o' = phi2*u`o'[_n-1] + v`o' in 2/$nobs
					}
					replace y`o' = beta*x + u`o' in 2/$nobs					
					local o = `o' + 1
				}
				replace tot = y1 + y2 + y3 + y4 + y5 in 2/$nobs
				local l 1
				while `l' <= 5	{		
					replace y`l'_pie = y`l'/tot
					local l = `l' + 1
				}
				drop y1_y5 y2_y5 y3_y5 y4_y5 
				tlogit y1_pie y1_y5 y2_pie y2_y5 y3_pie y3_y5 y4_pie y4_y5, base(y5_pie)
				
				* SUR-ECM regression:
				replace dy1_y5 = y1_y5-y1_y5[_n-1] in 2/$nobs
				replace dy2_y5 = y2_y5-y2_y5[_n-1] in 2/$nobs
				replace dy3_y5 = y3_y5-y3_y5[_n-1] in 2/$nobs
				replace dy4_y5 = y4_y5-y4_y5[_n-1] in 2/$nobs

				replace dx = x-x[_n-1] in 2/$nobs
					
				replace ly1_y5 = y1_y5[_n-1] in 2/$nobs
				replace ly2_y5 = y1_y5[_n-1] in 2/$nobs
				replace ly3_y5 = y1_y5[_n-1] in 2/$nobs
				replace ly4_y5 = y1_y5[_n-1] in 2/$nobs
				replace lx = x[_n-1] in 2/$nobs
				
				sureg (dy1_y5 ly1_y5 dx lx) ///
			 	(dy2_y5 ly2_y5 dx lx)		///
			 	(dy3_y5 ly3_y5 dx lx) 		///
			 	(dy4_y5 ly4_y5 dx lx)
			 	
			 	lmanlsur // autocorrelation test
			 	return list
				* p value Harvey LM test for global system autocorr
				scalar glob_hlmp = r(lmgp)
				* p value for Harvey LM test for each system
				scalar loc_hlmp_1 = r(lmhp_1)
				scalar loc_hlmp_2 = r(lmhp_2)
				scalar loc_hlmp_3 = r(lmhp_3)
				scalar loc_hlmp_4 = r(lmhp_4)
				* DW-statistic
				scalar dwatson_1 = r(lmadw_1)
				scalar dwatson_2 = r(lmadw_2)
				scalar dwatson_3 = r(lmadw_3)
				scalar dwatson_4 = r(lmadw_4)
					
				post `sim' (`p') (`nr') (errorcorr) (glob_hlmp)	///
				(loc_hlmp_1) (loc_hlmp_2) (loc_hlmp_3) (loc_hlmp_4) 	///
				(dwatson_1) (dwatson_2) (dwatson_3) (dwatson_4)
				
				local er = `er' + 0.2
			}
				
			local p = `p' + 0.2
		}
		
		local nr = `nr' + 1
	}

	local m = `m' + 1
}
}
postclose `sim'											// close sim

local b = `b' + 1
}														// close batch
end
*	-------------------------------------------------------------------------

timer on 1
ARsimMC2
timer off 1
timer list 1

*							ANALYSIS
* 	----------------------------------------------------------------------------
use results2_1, clear

forv i = 2/100	{
	append using results2_`i'.dta
}

collapse (mean) lmgp-dwatson_4, by(phi2 no_roots errorcorr)
tab errorcorr
tab no_roots
tab phi2

egen error=group (errorcorr)
list error errorcorr in 1/50



*	FOR REPLICATION PURPOSES CAN OPEN THE COMPRESSED OUTPUT:
use SI_baseline_nouroot.dta, clear



* Harvey Global LM test:	error corr = 0.0
preserve
keep if error==1
qui twoway line lmgp phi2 if no_roots==0, lpattern(solid) lwidth(medthick) ///
 || line lmgp phi2 if no_roots==1, lpattern(longdash) lwidth(medthick) ///
 || line lmgp phi2 if no_roots==2, lpattern(shortdash) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==3, lpattern(dash_dot) lwidth(medthick) ///
 || line lmgp phi2 if no_roots==4, lpattern(dot) lcolor(black)	///
 lwidth(medthick)  legend( order(1 "1 I(0) Series" 2 "2 I(0) Series" 3 "3 I(0) Series" 4 "4 I(0) Series" 5 "5 I(0) Series") size(small) rows(1)) ///
 yline(0.05)  ytitle("p-value", size(small))					///
 xtitle("Temporal Autocorrelation ({bf:{&rho}{subscript:j j}})", size(small)) ///
 title("Contemporaneous Correlation ({bf:{&rho}{subscript:i j}}) = 0.0", size(small))
graph save g1, replace
restore

* Harvey Global LM test:	error corr = 0.2
preserve
keep if error==2
qui twoway line lmgp phi2 if no_roots==0, lpattern(solid) lwidth(medthick) ///
 || line lmgp phi2 if no_roots==1, lpattern(longdash) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==2, lpattern(shortdash) lwidth(medthick)	///
 ||	line lmgp phi2 if no_roots==3, lpattern(dash_dot) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==4, lpattern(dot) lcolor(black)		///
 lwidth(medthick) legend( order(1 "1 I(0) Series" 2 "2 I(0) Series" 3 "3 I(0) Series" 4 "4 I(0) Series" 5 "5 I(0) Series")					///
 size(small) rows(1)) yline(0.05)  ytitle("p-value", size(small)) ///
 xtitle("Temporal Autocorrelation ({bf:{&rho}{subscript:j j}})", size(small)) ///
 title("Contemporaneous Correlation ({bf:{&rho}{subscript:i j}}) = 0.2", size(small))
graph save g2, replace
restore

* Harvey Global LM test:	error corr = 0.4
preserve
keep if error==3
qui twoway line lmgp phi2 if no_roots==0, lpattern(solid) lwidth(medthick) ///
 || line lmgp phi2 if no_roots==1, lpattern(longdash) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==2, lpattern(shortdash) lwidth(medthick)	///
 ||	line lmgp phi2 if no_roots==3, lpattern(dash_dot) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==4, lpattern(dot) lcolor(black)	///
 lwidth(medthick) legend( order(1 "1 I(0) Series" 2 "2 I(0) Series" 3 "3 I(0) Series" 4 "4 I(0) Series" 5 "5 I(0) Series") size(small) rows(1)) ///
 yline(0.05)  ytitle("p-value", size(small))	///
 xtitle("Temporal Autocorrelation ({bf:{&rho}{subscript:j j}})", size(small)) ///
 title("Contemporaneous Correlation ({bf:{&rho}{subscript:i j}}) = 0.4", size(small))
graph save g3, replace
restore

* Harvey Global LM test:	error corr = 0.6
preserve
keep if error==4
qui twoway line lmgp phi2 if no_roots==0, lpattern(solid) lwidth(medthick) ///
 || line lmgp phi2 if no_roots==1, lpattern(longdash) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==2, lpattern(shortdash) lwidth(medthick)	///
 ||	line lmgp phi2 if no_roots==3, lpattern(dash_dot) lwidth(medthick) ///
 ||	line lmgp phi2 if no_roots==4, lpattern(dot) lcolor(black)	///
 lwidth(medthick) legend( order(1 "1 I(0) Series" 2 "2 I(0) Series" 3 "3 I(0) Series" 4 "4 I(0) Series" 5 "5 I(0) Series")	///
 size(small) rows(1)) yline(0.05)  ytitle("p-value", size(small)) ///
 xtitle("Temporal Autocorrelation ({bf:{&rho}{subscript:j j}})", size(small)) ///
 title("Contemporaneous Correlation ({bf:{&rho}{subscript:i j}}) = 0.6", size(small))
graph save g4, replace
restore

grc1leg g1.gph g2.gph g3.gph g4.gph, legendfrom(g1.gph)	///
title("Baseline is always I(0)", size(medium))			///
note("H0: No Global Autocorrelation", size(small)) ycommon
graph export MC_ECMSUR_neveruroot.eps, as(eps) preview(off) replace







*	-------------------------------------------------------------------------
*				Table S 1
*	-------------------------------------------------------------------------
use UK_AJPS.dta, clear

dfuller conservative_pct
dfuller d.conservative_pct
pperron conservative_pct
pperron d.conservative_pct

dfuller labour_pct
dfuller d.labour_pct
pperron labour_pct
pperron d.labour_pct

dfuller libdem_pct
dfuller d.libdem_pct
pperron libdem_pct
pperron d.libdem_pct

global sureg_relative_Lab	"sureg (D.Con_Lab L.Con_Lab D.all_LabLeaderEval_W L.all_LabLeaderEval_W  D.all_ConLeaderEval_W L.all_ConLeaderEval_W D.all_LDLeaderEval_W L.all_LDLeaderEval_W D.all_pidW L.all_pidW D.all_nat_retW L.all_nat_retW D.all_b_mii_lab_pct L.all_b_mii_lab_pct)	(D.lDM_Lab L.lDM_Lab D.all_LabLeaderEval_W L.all_LabLeaderEval_W  D.all_ConLeaderEval_W L.all_ConLeaderEval_W D.all_LDLeaderEval_W L.all_LDLeaderEval_W D.all_pidW L.all_pidW D.all_nat_retW L.all_nat_retW D.all_b_mii_lab_pct L.all_b_mii_lab_pct), corr	"
$sureg_relative_Lab

lmanlsur // run Harvey autocorrelation test


*	-------------------------------------------------------------------------
*				Table S 2
*	-------------------------------------------------------------------------
use US_AJPS.dta, clear
tlogit otherpie other_defense incstypie incomescty_defense scsctypie /// 
socscty_defense interestpie interest_defense,base(defensepie)

dfuller defensepie
dfuller d.defensepie
pperron defensepie
pperron d.defensepie

dfuller incstypie
dfuller d.incstypie
pperron incstypie
pperron d.incstypie

dfuller scsctypie
dfuller d.scsctypie
pperron scsctypie
pperron d.scsctypie

dfuller interestpie
dfuller d.interestpie
pperron interestpie
pperron d.interestpie

dfuller otherpie
dfuller d.otherpie
pperron otherpie
pperron d.otherpie

sureg (d.other_defense l.other_defense l.aged_dr l.popgrowth ///
  l.hostlev l.natunempct l.mood l.pctgdpchange d.aged_dr d.popgrowth ///
  d.hostlev d.natunempct d.mood d.pctgdpchange demcongress presdem ///
		)			///
(d.incomescty_defense l.incomescty_defense l.aged_dr l.popgrowth ///
  l.hostlev l.natunempct l.mood l.pctgdpchange d.aged_dr d.popgrowth ///
  d.hostlev d.natunempct d.mood d.pctgdpchange demcongress presdem ///
		)			///
(d.socscty_defense l.socscty_defense l.aged_dr l.popgrowth ///
  l.hostlev l.natunempct l.mood l.pctgdpchange d.aged_dr d.popgrowth ///
  d.hostlev d.natunempct d.mood d.pctgdpchange demcongress presdem ///
		)			///
(d.interest_defense l.interest_defense l.aged_dr l.popgrowth ///
  l.hostlev l.natunempct l.mood l.pctgdpchange d.aged_dr d.popgrowth ///
  d.hostlev d.natunempct d.mood d.pctgdpchange demcongress presdem ///
		), 	corr

lmanlsur // run Harvey autocorrelation test





*	-------------------------------------------------------------------------
*				SECTION 3
*	-------------------------------------------------------------------------

* Fig S3 -> see UK_replication.do
* Fig S4 -> see UK_replication.do

*	-------------------------------------------------------------------------
*				SECTION 4
*	-------------------------------------------------------------------------


*	--------------------- Table S4	----------------------------------------
			* relative to defense:	----------------------------
use US_AJPS.dta, clear
tlogit otherpie other_defense incstypie incomescty_defense scsctypie /// 
socscty_defense interestpie interest_defense,base(defensepie)

sureg (d.other_defense l.other_defense l.aged_dr l.popgrowth ///
  l.hostlev l.natunempct l.mood l.pctgdpchange d.aged_dr d.popgrowth ///
  d.hostlev d.natunempct d.mood d.pctgdpchange demcongress presdem ///
		)			///
(d.incomescty_defense l.incomescty_defense l.aged_dr l.popgrowth ///
  l.hostlev l.natunempct l.mood l.pctgdpchange d.aged_dr d.popgrowth ///
  d.hostlev d.natunempct d.mood d.pctgdpchange demcongress presdem ///
		)			///
(d.socscty_defense l.socscty_defense l.aged_dr l.popgrowth ///
  l.hostlev l.natunempct l.mood l.pctgdpchange d.aged_dr d.popgrowth ///
  d.hostlev d.natunempct d.mood d.pctgdpchange demcongress presdem ///
		)			///
(d.interest_defense l.interest_defense l.aged_dr l.popgrowth ///
  l.hostlev l.natunempct l.mood l.pctgdpchange d.aged_dr d.popgrowth ///
  d.hostlev d.natunempct d.mood d.pctgdpchange demcongress presdem ///
		), 	corr

* other to defense
nlcom [D_other_defense]_b[l.aged_dr]/	/*
*/	(-[D_other_defense]_b[l.other_defense])
nlcom [D_other_defense]_b[l.mood]/	/*
*/	(-[D_other_defense]_b[l.other_defense])
nlcom [D_other_defense]_b[l.popgrowth]/	/*
*/	(-[D_other_defense]_b[l.other_defense])
nlcom [D_other_defense]_b[l.pctgdpchange]/	/*
*/	(-[D_other_defense]_b[l.other_defense])
nlcom [D_other_defense]_b[l.hostlev]/	/*
*/	(-[D_other_defense]_b[l.other_defense])
nlcom [D_other_defense]_b[l.natunempct]/	/*
*/	(-[D_other_defense]_b[l.other_defense])

* income sec to defense
nlcom [D_incomescty_defense]_b[l.aged_dr]/	/*
*/	(-[D_incomescty_defense]_b[l.incomescty_defense])
nlcom [D_incomescty_defense]_b[l.mood]/	/*
*/	(-[D_incomescty_defense]_b[l.incomescty_defense])
nlcom [D_incomescty_defense]_b[l.popgrowth]/	/*
*/	(-[D_incomescty_defense]_b[l.incomescty_defense])
nlcom [D_incomescty_defense]_b[l.pctgdpchange]/	/*
*/	(-[D_incomescty_defense]_b[l.incomescty_defense])
nlcom [D_incomescty_defense]_b[l.hostlev]/	/*
*/	(-[D_incomescty_defense]_b[l.incomescty_defense])
nlcom [D_incomescty_defense]_b[l.natunempct]/	/*
*/	(-[D_incomescty_defense]_b[l.incomescty_defense])

* soc sec to defense
nlcom [D_socscty_defense]_b[l.aged_dr]/	/*
*/	(-[D_socscty_defense]_b[l.socscty_defense])
nlcom [D_socscty_defense]_b[l.mood]/	/*
*/	(-[D_socscty_defense]_b[l.socscty_defense])
nlcom [D_socscty_defense]_b[l.popgrowth]/	/*
*/	(-[D_socscty_defense]_b[l.socscty_defense])
nlcom [D_socscty_defense]_b[l.pctgdpchange]/	/*
*/	(-[D_socscty_defense]_b[l.socscty_defense])
nlcom [D_socscty_defense]_b[l.hostlev]/	/*
*/	(-[D_socscty_defense]_b[l.socscty_defense])
nlcom [D_socscty_defense]_b[l.natunempct]/	/*
*/	(-[D_socscty_defense]_b[l.socscty_defense])

* interest to defense
nlcom [D_interest_defense]_b[l.aged_dr]/	/*
*/	(-[D_interest_defense]_b[l.interest_defense])
nlcom [D_interest_defense]_b[l.mood]/	/*
*/	(-[D_interest_defense]_b[l.interest_defense])
nlcom [D_interest_defense]_b[l.popgrowth]/	/*
*/	(-[D_interest_defense]_b[l.interest_defense])
nlcom [D_interest_defense]_b[l.pctgdpchange]/	/*
*/	(-[D_interest_defense]_b[l.interest_defense])
nlcom [D_interest_defense]_b[l.hostlev]/	/*
*/	(-[D_interest_defense]_b[l.interest_defense])
nlcom [D_interest_defense]_b[l.natunempct]/	/*
*/	(-[D_interest_defense]_b[l.interest_defense])

tlogit otherpie other_income defensepie defense_income scsctypie /// 
socscty_income interestpie interest_income,base(incstypie)
	* relative to income:	----------------------------
sureg (d.other_income l.other_income l.aged_dr l.mood l.popgrowth ///
 l.pctgdpchange l.hostlev l.natunempct d.aged_dr d.mood d.popgrowth ///
 d.pctgdpchange d.hostlev d.natunempct demcongress presdem ///
		)			///
(d.defense_income l.defense_income l.aged_dr l.mood l.popgrowth ///
 l.pctgdpchange l.hostlev l.natunempct d.aged_dr d.mood d.popgrowth ///
 d.pctgdpchange d.hostlev d.natunempct demcongress presdem ///
		)			///
(d.socscty_income l.socscty_income l.aged_dr l.mood l.popgrowth ///
 l.pctgdpchange l.hostlev l.natunempct d.aged_dr d.mood d.popgrowth ///
 d.pctgdpchange d.hostlev d.natunempct demcongress presdem ///
		)			///
(d.interest_income l.interest_income l.aged_dr l.mood l.popgrowth ///
 l.pctgdpchange l.hostlev l.natunempct d.aged_dr d.mood d.popgrowth ///
 d.pctgdpchange d.hostlev d.natunempct demcongress presdem ///
), 	corr

* other to income
nlcom [D_other_income]_b[l.aged_dr]/	/*
*/	(-[D_other_income]_b[l.other_income])
nlcom [D_other_income]_b[l.mood]/	/*
*/	(-[D_other_income]_b[l.other_income])
nlcom [D_other_income]_b[l.popgrowth]/	/*
*/	(-[D_other_income]_b[l.other_income])
nlcom [D_other_income]_b[l.pctgdpchange]/	/*
*/	(-[D_other_income]_b[l.other_income])
nlcom [D_other_income]_b[l.hostlev]/	/*
*/	(-[D_other_income]_b[l.other_income])
nlcom [D_other_income]_b[l.natunempct]/	/*
*/	(-[D_other_income]_b[l.other_income])

*	socsec to income
nlcom [D_socscty_income]_b[l.aged_dr]/	/*
*/	(-[D_socscty_income]_b[l.socscty_income])
nlcom [D_socscty_income]_b[l.mood]/	/*
*/	(-[D_socscty_income]_b[l.socscty_income])
nlcom [D_socscty_income]_b[l.popgrowth]/	/*
*/	(-[D_socscty_income]_b[l.socscty_income])
nlcom [D_socscty_income]_b[l.pctgdpchange]/	/*
*/	(-[D_socscty_income]_b[l.socscty_income])
nlcom [D_socscty_income]_b[l.hostlev]/	/*
*/	(-[D_socscty_income]_b[l.socscty_income])
nlcom [D_socscty_income]_b[l.natunempct]/	/*
*/	(-[D_socscty_income]_b[l.socscty_income])

*	interest to income
nlcom [D_interest_income]_b[l.aged_dr]/	/*
*/	(-[D_interest_income]_b[l.interest_income])
nlcom [D_interest_income]_b[l.mood]/	/*
*/	(-[D_interest_income]_b[l.interest_income])
nlcom [D_interest_income]_b[l.popgrowth]/	/*
*/	(-[D_interest_income]_b[l.interest_income])
nlcom [D_interest_income]_b[l.pctgdpchange]/	/*
*/	(-[D_interest_income]_b[l.interest_income])
nlcom [D_interest_income]_b[l.hostlev]/	/*
*/	(-[D_interest_income]_b[l.interest_income])
nlcom [D_interest_income]_b[l.natunempct]/	/*
*/	(-[D_interest_income]_b[l.interest_income])

tlogit otherpie other_socscty defensepie defense_socscty incstypie /// 
income_socscty interestpie interest_socscty,base(scsctypie)
	* relative to soc security:	----------------------------
sureg (d.other_socscty l.other_socscty l.aged_dr l.mood l.popgrowth ///
 l.pctgdpchange l.hostlev l.natunempct d.aged_dr d.mood d.popgrowth ///
 d.pctgdpchange d.hostlev d.natunempct demcongress presdem ///
		)			///
(d.defense_socscty l.defense_socscty l.aged_dr l.mood l.popgrowth ///
 l.pctgdpchange l.hostlev l.natunempct d.aged_dr d.mood d.popgrowth ///
 d.pctgdpchange d.hostlev d.natunempct demcongress presdem ///
		)			///
(d.income_socscty l.income_socscty l.aged_dr l.mood l.popgrowth ///
 l.pctgdpchange l.hostlev l.natunempct d.aged_dr d.mood d.popgrowth ///
 d.pctgdpchange d.hostlev d.natunempct demcongress presdem ///
		)			///
(d.interest_socscty l.interest_socscty l.aged_dr l.mood l.popgrowth ///
 l.pctgdpchange l.hostlev l.natunempct d.aged_dr d.mood d.popgrowth ///
 d.pctgdpchange d.hostlev d.natunempct demcongress presdem ///
), 	corr

*	other to socsec
nlcom [D_other_socscty]_b[l.aged_dr]/	/*
*/	(-[D_other_socscty]_b[l.other_socscty])
nlcom [D_other_socscty]_b[l.mood]/	/*
*/	(-[D_other_socscty]_b[l.other_socscty])
nlcom [D_other_socscty]_b[l.popgrowth]/	/*
*/	(-[D_other_socscty]_b[l.other_socscty])
nlcom [D_other_socscty]_b[l.pctgdpchange]/	/*
*/	(-[D_other_socscty]_b[l.other_socscty])
nlcom [D_other_socscty]_b[l.hostlev]/	/*
*/	(-[D_other_socscty]_b[l.other_socscty])
nlcom [D_other_socscty]_b[l.natunempct]/	/*
*/	(-[D_other_socscty]_b[l.other_socscty])

*	interest to socsec
nlcom [D_interest_socscty]_b[l.aged_dr]/	/*
*/	(-[D_interest_socscty]_b[l.interest_socscty])
nlcom [D_interest_socscty]_b[l.mood]/	/*
*/	(-[D_interest_socscty]_b[l.interest_socscty])
nlcom [D_interest_socscty]_b[l.popgrowth]/	/*
*/	(-[D_interest_socscty]_b[l.interest_socscty])
nlcom [D_interest_socscty]_b[l.pctgdpchange]/	/*
*/	(-[D_interest_socscty]_b[l.interest_socscty])
nlcom [D_interest_socscty]_b[l.hostlev]/	/*
*/	(-[D_interest_socscty]_b[l.interest_socscty])
nlcom [D_interest_socscty]_b[l.natunempct]/	/*
*/	(-[D_interest_socscty]_b[l.interest_socscty])

tlogit scsctypie socscty_other defensepie defense_other incstypie /// 
income_other interestpie interest_other,base(otherpie)
	* relative to other:	----------------------------
sureg (d.socscty_other l.socscty_other l.aged_dr l.mood l.popgrowth ///
 l.pctgdpchange l.hostlev l.natunempct d.aged_dr d.mood d.popgrowth ///
 d.pctgdpchange d.hostlev d.natunempct demcongress presdem ///
		)			///
(d.defense_other l.defense_other l.aged_dr l.mood l.popgrowth ///
 l.pctgdpchange l.hostlev l.natunempct d.aged_dr d.mood d.popgrowth ///
 d.pctgdpchange d.hostlev d.natunempct demcongress presdem ///
		)			///
(d.income_other l.income_other l.aged_dr l.mood l.popgrowth ///
 l.pctgdpchange l.hostlev l.natunempct d.aged_dr d.mood d.popgrowth ///
 d.pctgdpchange d.hostlev d.natunempct demcongress presdem ///
		)			///
(d.interest_other l.interest_other l.aged_dr l.mood l.popgrowth ///
 l.pctgdpchange l.hostlev l.natunempct d.aged_dr d.mood d.popgrowth ///
 d.pctgdpchange d.hostlev d.natunempct demcongress presdem ///
), 	corr

*	interest to other
nlcom [D_interest_other]_b[l.aged_dr]/	/*
*/	(-[D_interest_other]_b[l.interest_other])
nlcom [D_interest_other]_b[l.mood]/	/*
*/	(-[D_interest_other]_b[l.interest_other])
nlcom [D_interest_other]_b[l.popgrowth]/	/*
*/	(-[D_interest_other]_b[l.interest_other])
nlcom [D_interest_other]_b[l.pctgdpchange]/	/*
*/	(-[D_interest_other]_b[l.interest_other])
nlcom [D_interest_other]_b[l.hostlev]/	/*
*/	(-[D_interest_other]_b[l.interest_other])
nlcom [D_interest_other]_b[l.natunempct]/	/*
*/	(-[D_interest_other]_b[l.interest_other])




*	-------------------------------------------------------------------------
*				SECTION 5
*	-------------------------------------------------------------------------

*	------------------------ Table S5 ---------------------------------------
use UK_AJPS.dta, clear

global sureg_relative_Lab	"sureg (D.Con_Lab L.Con_Lab D.all_LabLeaderEval_W L.all_LabLeaderEval_W  D.all_ConLeaderEval_W L.all_ConLeaderEval_W D.all_LDLeaderEval_W L.all_LDLeaderEval_W D.all_pidW L.all_pidW D.all_nat_retW L.all_nat_retW D.all_b_mii_lab_pct L.all_b_mii_lab_pct)	(D.lDM_Lab L.lDM_Lab D.all_LabLeaderEval_W L.all_LabLeaderEval_W  D.all_ConLeaderEval_W L.all_ConLeaderEval_W D.all_LDLeaderEval_W L.all_LDLeaderEval_W D.all_pidW L.all_pidW D.all_nat_retW L.all_nat_retW D.all_b_mii_lab_pct L.all_b_mii_lab_pct), corr	"
$sureg_relative_Lab

global sureg_relative_Con	"sureg (D.lDM_Con L.lDM_Con D.all_LabLeaderEval_W L.all_LabLeaderEval_W  D.all_ConLeaderEval_W L.all_ConLeaderEval_W D.all_LDLeaderEval_W L.all_LDLeaderEval_W D.all_pidW L.all_pidW D.all_nat_retW L.all_nat_retW D.all_b_mii_lab_pct L.all_b_mii_lab_pct) (D.lab_Con L.lab_Con D.all_LabLeaderEval_W L.all_LabLeaderEval_W  D.all_ConLeaderEval_W L.all_ConLeaderEval_W D.all_LDLeaderEval_W L.all_LDLeaderEval_W D.all_pidW L.all_pidW D.all_nat_retW L.all_nat_retW D.all_b_mii_lab_pct L.all_b_mii_lab_pct), corr "
$sureg_relative_Con

* LR effects 
$sureg_relative_Lab
nlcom [D_Con_Lab]L.all_LabLeaderEval_W/(-[D_Con_Lab]_b[L.Con_Lab])
nlcom [D_Con_Lab]L.all_ConLeaderEval_W/(-[D_Con_Lab]_b[L.Con_Lab])
nlcom [D_Con_Lab]L.all_LDLeaderEval_W/(-[D_Con_Lab]_b[L.Con_Lab])
nlcom [D_Con_Lab]L.all_pidW/(-[D_Con_Lab]_b[L.Con_Lab])
nlcom [D_Con_Lab]L.all_nat_retW/(-[D_Con_Lab]_b[L.Con_Lab])
nlcom [D_Con_Lab]L.all_b_mii_lab_pct/(-[D_Con_Lab]_b[L.Con_Lab])

$sureg_relative_Lab
nlcom [D_lDM_Lab]L.all_LabLeaderEval_W/(-[D_lDM_Lab]_b[L.lDM_Lab])
nlcom [D_lDM_Lab]L.all_ConLeaderEval_W/(-[D_lDM_Lab]_b[L.lDM_Lab])
nlcom [D_lDM_Lab]L.all_LDLeaderEval_W/(-[D_lDM_Lab]_b[L.lDM_Lab])
nlcom [D_lDM_Lab]L.all_pidW/(-[D_lDM_Lab]_b[L.lDM_Lab])
nlcom [D_lDM_Lab]L.all_nat_retW/(-[D_lDM_Lab]_b[L.lDM_Lab])
nlcom [D_lDM_Lab]L.all_b_mii_lab_pct/(-[D_lDM_Lab]_b[L.lDM_Lab])

$sureg_relative_Con
nlcom [D_lDM_Con]L.all_LabLeaderEval_W/(-[D_lDM_Con]_b[L.lDM_Con])
nlcom [D_lDM_Con]L.all_ConLeaderEval_W/(-[D_lDM_Con]_b[L.lDM_Con])
nlcom [D_lDM_Con]L.all_LDLeaderEval_W/(-[D_lDM_Con]_b[L.lDM_Con])
nlcom [D_lDM_Con]L.all_pidW/(-[D_lDM_Con]_b[L.lDM_Con])
nlcom [D_lDM_Con]L.all_nat_retW/(-[D_lDM_Con]_b[L.lDM_Con])
nlcom [D_lDM_Con]L.all_b_mii_lab_pct/(-[D_lDM_Con]_b[L.lDM_Con])


*	------------------------ Table S6 ---------------------------------------
reg D.labour_pct L.labour_pct D.all_LabLeaderEval_W L.all_LabLeaderEval_W  D.all_ConLeaderEval_W L.all_ConLeaderEval_W D.all_LDLeaderEval_W L.all_LDLeaderEval_W D.all_pidW L.all_pidW D.all_nat_retW L.all_nat_retW D.all_b_mii_lab_pct L.all_b_mii_lab_pct

* LR effects
nlcom _b[L.all_LabLeaderEval_W]/(-_b[L.labour_pct])
nlcom _b[L.all_ConLeaderEval_W]/(-_b[L.labour_pct])
nlcom _b[L.all_LDLeaderEval_W]/(-_b[L.labour_pct])
nlcom _b[L.all_pidW]/(-_b[L.labour_pct])
nlcom _b[L.all_nat_retW]/(-_b[L.labour_pct])
nlcom _b[L.all_b_mii_lab_pct]/(-_b[L.labour_pct])


*	------------------------ Table S7 ---------------------------------------
*	see code above for Table S4


*	------------------------ Table S8 ---------------------------------------
use US_AJPS.dta, clear
reg d.defensepie l.defensepie d.popgrowth l.popgrowth d.hostlev l.hostlev ///
	d.natunempct l.natunempct d.aged_dr l.aged_dr d.mood l.mood ///
	d.pctgdpchange l.pctgdpchange demcongress presdem
  
nlcom _b[L.popgrowth]/(-_b[L.defensepie])
nlcom _b[L.hostlev]/(-_b[L.defensepie])
nlcom _b[L.natunempct]/(-_b[L.defensepie])
nlcom _b[L.aged_dr]/(-_b[L.defensepie])
nlcom _b[L.mood]/(-_b[L.defensepie])
nlcom _b[L.pctgdpchange]/(-_b[L.defensepie])
