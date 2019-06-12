version 9.2
#delimit;
set more off;
clear;
set mem 500m;
  quietly log;
  local logon = r(status);
  if "`logon'" == "on" {; log close; };
log using smb2010isq-impute, text replace; 


/*	************************************************************	*/
/*     	File Name:	smb2010isq-impute.do				*/
/*     	Date:   	July 12, 2011 					*/
/*      Author: 	Dan Morey and Frederick J. Boehmke		*/
/*      Purpose:	This file creates the data set for imputation,	*/
/*			calls Amelia II to run on the data, and then 	*/
/*			combines the results for use later. 		*/
/*      Input File: 	smb2010isq-preimpute.dta			*/
/*      Output File:	smb2010isq-impute.log,				*/
/*      		smb2010isq-impute.dta,				*/
/*      		smb2010isq-base.dta,				*/
/*      		toimpute.dta,					*/
/*      		outdataX.dta					*/
/* 	Requires:	Amelia II for Windows, 				*/
/*			btscs.ado					*/
/*	Version:	Stata 9.2 or above.				*/
/*	************************************************************	*/


	/****************************************************************/
	/* First we read in the "raw" data (already combined) and  	*/
	/* create and recode some key variables.			*/
	/****************************************************************/


use smb2010isq-preimpute;

sort dyadid year;

  bysort dyadid year: gen conflictid = _n;

  replace cumdurat = . if dyadid==710800 & year==1965 & cumdurat==0;

  generat enter = (cumdurat != .);
  generat fail = 0;
  replace fail = 1 if endyear<=2000 & endyear!=.;

  recode polity21 polity22 (-99=.);

  replace jdemo2 = .;
  replace jdemo2 = 1 if polity21 >= 7 & polity22 >= 7 & !missing(polity21) & !missing(polity22);
  replace jdemo2 = 0 if polity21 <  7 | polity22 <  7;


	/****************************************************************/
	/* Do the interpolation and extrapolation of the IO variables 	*/
	/* for the missing values in non-multiple of 5 years before 	*/
	/* 1965. Create the predictions and then replace the original 	*/
	/* variables. Keep missing values after 1965 for imputation 	*/
	/* later.							*/
	/****************************************************************/


recode *IO* (nonmissing = .) if year < 1965 & mod(year,5) != 0;

ipolate COWIO year, by(dyadid) gen(temp) epolate;
ipolate IntrvIOs year, by(dyadid) gen(temp2) epolate;

	recode temp temp2 (min/0=0) if year < 1965 & mod(year,5) != 0;

	replace temp  = . if missing(COWIO) & year>1965;
	replace temp2 = . if missing(IntrvIOs) & year>1965;

	drop COWIO IntrvIOs;

	rename temp COWIO;
	rename temp2 IntrvIOs;


	/****************************************************************/
	/* Prepare the data for imputation by rescaling and identifying */
	/* the unimputed sample for future analysis. Save the results.	*/
	/* Save all variables, including those in MIDS, then drop MID	*/
	/* varialbes and save rest for imputation since MID variables	*/
	/* are not to be imputed. 					*/
	/****************************************************************/
	
		/* Rescale for imputation. */
	
replace COWIO = COWIO/10;
replace IntrvIOs = IntrvIOs/10;
replace sIGOist3 = sIGOist3/10;
replace IGOmaxst = IGOmaxst/10;
replace Scount = Scount/10;

replace distance = distance/10000;

		/* Run a model to identify the unimputed sample. */

regress enter COWIO jdemo2 pratio majdyad distance;

  generat sample = e(sample);

  save smb2010isq-base, replace;

  summarize;

		/* Keep the variables for imputation. King et al. suggest  	*/
		/* having variables besides those in the model can be helpful.	*/
		
keep COWIO IntrvIOs jdemo2 troopqrat polity21 polity22 majdyad jdemo2 pratio enter majdyad 
	distance dyadid year ccode1 ccode2 conflictid cap_* milper_* energy_* tpop_* 
	pratio dependa dependb sIGOist3 Scount IGOmaxst contiguous 
	sIGOist3 Scount IGOmaxst;

  saveold toimpute, replace;

  
	/****************************************************************/
	/* Call Amelia to run the imputations. This is set up to call	*/
	/* Amelia from Stata, run Amelia, close Amelia, and return to 	*/
	/* Stata to continue processing the imputed data. Once Amelia	*/
	/* is done, return to Stata and run the command -q- to continue	*/
	/* processing the rest of this file.				*/
	/*								*/	
	/* We set the following Amelia II options:			*/
	/*								*/
	/* Time Series Index: year.					*/
	/* Cross-Sectional Index: dyadid.				*/
	/* Variables Options: set "ID Variable" for ccode1, ccode2, 	*/
	/*	and conflictid.						*/
	/* TSCS Options: set "Include Lag" and "Include Lead" for 	*/
	/*	polity, jdemo2, COWIO, and IntrvIOs.			*/
	/* TSCS Options: also set "Polynomial of time" to 3.		*/
	/* Output Data Format: Stata 7/8.				*/
	/* Name of the Imputed Data set: outdata.			*/
	/* Number of Imputed Data Sets: 5.				*/
	/****************************************************************/

		/* Save current working directory. */
	
  local cwd = c(pwd);
  
		/* CD to Amelia II directory - change to fit your configuration. */

  cd    "C:\Program Files (x86)\AmeliaView\";
  shell amelia.bat;
  pause on;
  pause "Running Amelia (enter q to resume once Amelia is done)";

		/* Return to original working directory. */
		
  cd "`cwd'";

  
	/****************************************************************/
	/* Now read in the five imputed data sets, merging each back 	*/
	/* with the MID data excluded from the imputation process.	*/
	/* Create splines using btscs for each imputed data set. 	*/
	/****************************************************************/


clear;

save smb2010isq-impute, replace emptyok;

forvalues num=1/5 {;

  use smb2010isq-base, clear;

	generat imputeid = `num';

  merge year dyadid conflictid using outdata`num', sort unique update;

	btscs enter year dyadid, generate(dur_peac) nspline(3);

	generat dur_peac_sq = dur_peac^2;
	generat dur_peac_cube = dur_peac^3;
  
  append using smb2010isq-impute;

  save smb2010isq-impute, replace;

  };

		/* Now recreate some variables using imputed data. */
  
generat jdemo2_imp = jdemo2 if sample == 1;
replace jdemo2_imp = 1 if polity21 >= 7 & polity22 >= 7 & sample==0;
replace jdemo2_imp = 0 if polity21 <  7 | polity22 <  7 & sample==0;

quietly sum year;

generat time      = year - r(min);
generat time_sq   = time^2;
generat time_cube = time^3;

replace mindep  = . if year > 1992;
replace dependa = . if year > 1992;
replace dependb = . if year > 1992;

		/* Create selection variable and duration variable for fatal MIDs. */
  
  generat enter_fat = enter;
  replace enter_fat = 0 if fatlev <= 0;
  
  generat cumdurat_fat = cumdurat;
  replace cumdurat_fat = . if fatlev <= 0;

  replace mindep = min(dependa, dependb);
  
  keep year dyadid ccode1 ccode2 conflictid imputeid enter cumdurat *IO* jdemo2* totactor hihost 
	strtyr troopqrat majdyad distance _spline1 _spline2 _spline3 pratio dur_peac* sample 
	time* midnum enter_fat cumdurat_fat mindep dependa dependb endyear endday endmnth fail 
	contiguous sIGOist3 Scount IGOmaxst;


	/****************************************************************/
	/* Now structure for use with micombine for streg analysis. 	*/
	/****************************************************************/

	
generat _j = imputeid;

misplit, clear;

forvalues num=1/5 {;

  use _mitemp`num', clear;
  stset cumdurat if enter==1, failure(fail);
  save temp`num', replace;

  };

miset using temp, clear;
mijoin, clear;


label data "Replication Data for Shannon, Morey, and Boehmke, 2010, ISQ.";		

  compress;

  save smb2010isq-impute, replace;

		/* Delete the data sets generated by -misplit- and -mijoin-. */

forvalues num=1/5 {;

  erase temp`num'.dta; 
  erase _mitemp`num'.dta; 

  };

log close;
clear;
exit, STATA;

