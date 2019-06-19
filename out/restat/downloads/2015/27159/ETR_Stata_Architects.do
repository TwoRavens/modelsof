/* (R) 01-09-2010: Catherine Schaumans */

/*************************************************************************************************************
				STRUCTURE OF THE PROGRAM

PART 1: merge the datafile of the sector characteristics with demographic information
PART 2: get initial insights in the data/sector = single equation estimation of revenue and entry equation
	Analysis on firms with 1 or at most 2 establishments - non-urban markets with revenue info
	
	
					TO DO

BEFORE YOU RUN THE PROGRAM
1. Save the output of the SAS program as a text-file (this means: open filename.xls in Excell and save as filename.txt)
2. The file containing the market characteristics (demopost.dta) should be saved in the same subfile as the text file and this do-file
3. if you are using a different computer or the files or under a different subdirectory --> change the location of the datafile
	on line 70
4. Choose the definition of the number of firms
	on line 184
	firmdefinition = 1 --> selection of single-establishment firms
	firmdefinition = 2 --> selection of firms with at most 2 establishments
	firmdefinition = 3 --> all firms

	
	
WHEN YOU USE THIS PROGRAM ON A DIFFERENT DATASET (different year or different profession)
A. Before you run the program
1. Change the name of the datafile used as input on line 70 (and the logfile name on line 63)
2. Change the name of the output file on line 172/173
3. Remove the comment signs (/* */) on line 215: err;
4. Remove the comment signs (/* */) on line 262: err; 

B. Run (do) the do-file
The program will stop on line 215, after it has produced a histogram of the per firm revenues across markets
--> look at this histogram and check whether there is unlikely data (outlier)
--> set a value for the cut-off of plausible data on line 216 (very few markets should be dropped)
--> Comment out the err-command on line 215
--> If you are working on firmdefinition = 3: choose whether you want to exclude markets with chain stores on lines 221-222-223 (remove comment-signs on one of the lines)

C. Run (do) the do-file
The program will stop on line 262, after it has produced a tabulate of the number of firms per market
--> choose a maximum number of firms you will work with in the analysis and fill this out on lines 263 and 264
--> typically, go until you have around 90% of the data with the true N
  * IMPORTANTLY: there should be no gaps in the data. That is, in case there are markets with 11 firms and with 13 firms, but not with 12 firms, you need to use 11 as the max number of firms
    Note; in the rare case that this occurs at a low number of entrants, you can allow it, but you should then bear in mind for all the results that e.g. cut5 refers to N=6 (as there are no market with N=5)
--> Comment out the err-command on line 262

D. Run (do) the do-file
The programs runs until the end.
You get the output of the revenue equation and the entry equation when estimated separately
You also get the values of the entry thresholds (ET) and entry threshold ratios (ETR) according to the old method (i.e. not corrected for possible market creation)

**************************************************************************************************************/


clear
set more on
set mem 24m
set matsize 800
set more 1

capture log close
log using ETR_Architects.smcl,replace

#delimit ;

clear;

/* read in data --> first save filename.xls as filename.txt */
	/*insheet using X:\Indicators\ETR\Results\raw_data\ETR_ARCHITECTS.txt, delimiter(";") case;};*/
	compress;
	label var Nsel1 "Number of firms: selection of single-establishment firms";	
	label var Nsel1_rev "Number of firms with positive revenues: selection of single-establishment firms";	
	label var Rsel1 "Total revenue of firms: selection of single-establishment firms";	
	label var Nsel2 "Number of firms: selection of firms with at most 2 establishments";	
	label var Nsel2_rev "Number of firms with positive revenues: selection of firms with at most 2 establishments";
	label var ESTsel2 "Number of establishments of firms in this zipcode: selection of firms with at most 2 establishments";	
	label var ESTsel2_rev "Number of establishments of firms with positive revenues in this zipcode: selection of firms with at most 2 establishments";
	label var Rsel2 "Total revenue of firms: selection of firms with at most 2 establishments";	
	label var Ntot "Number of firms: all firms";	
	label var Ntot_rev "Number of firms with positive revenues: all firms";
	label var ESTtot "Number of establishments of firms in this zipcode: all firms";	
	label var ESTtot_rev "Number of establishments of firms with positive revenues in this zipcode: all firms";
	label var Rtot "Total revenue of firms: all firms";	
	label var chain3 "Number of firms with more than 3 establishments";	
	label var chain3_rev "Number of firms with positive revenues and more than 3 establishments";	
	label var chain5 "Number of firms with more than 5 establishments";	
	label var chain5_rev "Number of firms with positive revenues and more than 5 establishments";
	label var chain7 "Number of firms with more than 7 establishments";
	label var chain7_rev "Number of firms with positive revenues and more than 7 establishments";

	sum;


	
/*************************************************************************************************************
		PART 1: merge the datafiles of the different sectors with demographic information
**************************************************************************************************************/



/* 1. to be consistent with the NIS demography files, some zipcodes need to be changed and data needs to be recollapsed to have 1 dataline per zipcode */
	rename zip post;
	replace post=9041 if post==9042;		 		/*Desteldonk is in NIS dataset part of Oostakker */
	replace post=7782 if post==7783;		 		/*Bizet is part of Ploegsteert in NIS data */
	replace post=1930 if post==1931;		 		/*does not exists - typo */
	sort post; 
	collapse (sum) Nsel1 Nsel1_rev Rsel1 Nsel2 Nsel2_rev ESTsel2 ESTsel2_rev Rsel2 Ntot Ntot_rev ESTtot ESTtot_rev Rtot chain3 chain3_rev chain5 chain5_rev chain7 chain7_rev , by(post);


/* 2. merge with market demographics and put zeros in zips with NO observation of firms */
	merge post using demopost;
	label var post "identification of market = zip code";
	label var MPOP "number of inhabitants - 2001";
	label var surf "surface area, measured in km²";
	label var NIS "the code of the municipality to which the zip code belongs";
	label var Ant "dummy variable for belonging to the province of Antwerpen";
	label var Bru "dummy variable for belonging to the province of Brussels";
	label var VlB "dummy variable for belonging to the province of Vlaams-Brabant";
	label var WaB "dummy variable for belonging to the province of Brabant-Wallon";
	label var WVl "dummy variable for belonging to the province of West-Vlaanderen";
	label var OVl "dummy variable for belonging to the province of Oost-Vlaanderen";
	label var Hen "dummy variable for belonging to the province of Hainaut";
	label var Lui "dummy variable for belonging to the province of Liege";
	label var Lim "dummy variable for belonging to the province of Limburg";
	label var Lux "dummy variable for belonging to the province of Luxembourg";
	label var Nam "dummy variable for belonging to the province of Namur";
	label var FLA "dummy variable for belonging to the region of Vlaanderen";
	label var WAL "dummy variable for belonging to the region of Wallonia";
	label var BRU "dummy variable for belonging to the region of Brussels";
	label var aangift "number of income tax-report";
	label var totinc "total taxable income reported by inhabitants - 2001";
	label var foreign "percentage foreign population";
	label var female "percentage female population";
	label var aantal "number of zip codes in the same municipality (NIS)";
	label var unempl "unemployment rate";
	label var kid "percentage population under the age of 10";
	label var young "percentage population between the ages of 10 and 24";
	label var adult1 "percentage population between the ages of 25 and 39";
	label var adult2 "percentage population between the ages of 40 and 64";
	label var old "percentage population over the age of 65";
	drop secname; 
	gen inccap=totinc/MPOP;
	gen lninc=ln(inccap);
	gen lnsurf=ln(surf);
	tab _merge; 
	replace Nsel1=0 if _merge==2;
	replace Nsel1_rev=0 if _merge==2 | Nsel1_rev==.;	
	replace Rsel1=0 if _merge==2;	
	replace Nsel2=0 if _merge==2;	
	replace Nsel2_rev=0 if _merge==2 | Nsel2_rev==.;
	replace ESTsel2=0 if _merge==2;	
	replace ESTsel2_rev=0 if _merge==2 | ESTsel2_rev==.;
	replace Rsel2=0 if _merge==2;	
	replace Ntot=0 if _merge==2;	
	replace Ntot_rev=0 if _merge==2 | Ntot_rev==.;
	replace ESTtot=0 if _merge==2;	
	replace ESTtot_rev=0 if _merge==2 | ESTtot_rev==.;
	replace Rtot=0 if _merge==2;	
	replace chain3=0 if _merge==2;	
	replace chain3_rev=0 if _merge==2 | chain3_rev==.;
	replace chain5=0 if _merge==2;	
	replace chain5_rev=0 if _merge==2 | chain5_rev==.;
	replace chain7=0 if _merge==2;
	replace chain7_rev=0 if _merge==2 | chain7_rev==.;
	drop if _merge==1;
	drop _merge;
	sort post;

	sum;

	saveold MMS_Architects.dta, replace;				/* dataset to be used for Gauss analysis */
	outsheet using MMS_Architects.xls, replace;	





/*************************************************************************************************************
					PART 2: get initial insights in the data/sector
**************************************************************************************************************/

/* choose the definition of the firms you will work with - see above: TO DO 4 */
gen firmdefinition = 2 ;
	
if (firmdefinition ==1) {;
	gen N=Nsel1; 											/* N = the number of firms per zip code */
	gen Nrev=Nsel1_rev; 									/* Nrev = the number of firms with reported revenue information per zip code */
	gen R=Rsel1;};											/* R = sum of the reporting firms' revenues in the zip code */
else if (firmdefinition ==2) {;
	gen N=Nsel2; 
	gen Nrev=Nsel2_rev; 
	gen R=Rsel2;};
else if (firmdefinition ==3) {;
	gen N=Ntot; 
	gen Nrev=Ntot_rev; 
	gen R=Rtot;};
	

/* 1. sample selection: only non-urban markets and no markets with lacking revenue information */
	
		/* A. based on demographics = non-urban zipcodes*/
		keep if MPOP<15000;
		gen popdens=MPOP/surf;
		keep if popdens<800;

		/* B. drop markets with entrants but without revenue information = data problem */
		drop if (N > 0) & (Nrev == 0);

		/* C. identify and drop outliers - based on revenue per firm in the market*/	
		gen help=Nrev;
		replace help=1 if Nrev==0;
		gen Rpf=R/help;				
		hist Rpf if N~=0; 
		/*ERR;*//* look at the histogram and check for outliers --> select at cutoff value HERE (i.e. change 500.000 to a number that is appropriate in your case) */	
		drop if Rpf >= 500000;	
		hist Rpf if N~=0;
		drop help;
		
		/* D. OPTIONAL: drop markets in which chain stores are active and no markets with lacking revenue information */
		/*keep if chain3==0;*/
		/*keep if chain5==0;*/
		/*keep if chain7==0;*/



/* 2. demographic variables - summary statistics for the selected markets*/

	sum MPOP surf lnsurf foreign female inccap lninc unempl kid young adult1 adult2 old FLA WAL BRU;
	gen lnpop=ln(MPOP);
	egen _lnsurf=mean(lnsurf);
	egen _foreign=mean(foreign);
	egen _female=mean(female);
	egen _lninc=mean(lninc);
	egen _unempl=mean(unempl);
	egen _kid=mean(kid);
	egen _young=mean(young);
	egen _adult2=mean(adult2);
	egen _old=mean(old);
	egen _FLA=mean(FLA);


/* 3. detailed summary statistics of sector: number of firms and revenues */
					
	sum N, detail;
	tab N;
	tab N, sum(MPOP);						/* Is the average population size increasing in the number of firms? */
	sum R if N~=0, detail;					/* Average total revenue in markets with entrants*/			
	sum Rpf if N~=0, detail;				/* Average per firm revenue in markets with entrants */			
	gen Rpfpc=Rpf/MPOP;	sum Rpfpc if N~=0, detail;
		
/* 4. initial regressions: single equations */

	/* 4.1 initial regressions on revenues */

		/* 1. explained variables = per capita, per firm/est revenues*/
		gen lnRf= ln(Rpf/MPOP);		
		gen lnN=ln(N);
			
		/* 2. limit the maximum number of entrants per market (reduce the number of options --> until 90% of the markets)*/
		tab N, gen(D);				/* dummies for the number of firms are generated: note that D1 is the dummy for N=1, D2 for N=1 and so on */
		/*ERR;*/
		replace D16=1 if N>15;		
		replace N=15 if N>=15;

		/* 3. revenue regressions - single equation = there is an endogeneity problem but nonetheless gives some insights */		
		reg lnRf lnsurf foreign female lninc unempl kid young adult2 old FLA D2 D3 D4 D5 D6 D7 D8 D9 D10 D11 D12 D13 D14 D15 D16, noconstant;
		reg lnRf lnsurf foreign female lninc unempl kid young adult2 old FLA lnN, noconstant;

		
	/* 4.2 initial regressions on number of entrants = single equation entry model */

		oprobit N lnpop lnsurf foreign female lninc unempl kid young adult2 old FLA;

		/* compute entry thresholds and entry threshold ratios */
		scalar b1=_b[lnpop];
		scalar b2=_b[lnsurf];
		scalar b3=_b[foreign];
		scalar b4=_b[female];
		scalar b5=_b[lninc];
		scalar b6=_b[unempl];
		scalar b7=_b[kid];
		scalar b8=_b[young];
		scalar b9=_b[adult2];
		scalar b10=_b[old];
		scalar b11=_b[FLA];
		scalar cut1=_b[/cut1];
		scalar cut2=_b[/cut2];
		scalar cut3=_b[/cut3];
		scalar cut4=_b[/cut4];
		scalar cut5=_b[/cut5];
		scalar cut6=_b[/cut6];
		scalar cut7=_b[/cut7];
		scalar cut8=_b[/cut8];
		scalar cut9=_b[/cut9];
		scalar cut10=_b[/cut10];

		gen et1=exp(-(b2*_lnsurf + b3*_foreign + b4*_female + b5*_lninc + b6*_unempl + b7*_kid + b8*_young + b9*_adult2 + b10*_old + b11*_FLA - cut1)/b1);
		gen et2=exp(-(b2*_lnsurf + b3*_foreign + b4*_female + b5*_lninc + b6*_unempl + b7*_kid + b8*_young + b9*_adult2 + b10*_old + b11*_FLA - cut2)/b1);
		gen et3=exp(-(b2*_lnsurf + b3*_foreign + b4*_female + b5*_lninc + b6*_unempl + b7*_kid + b8*_young + b9*_adult2 + b10*_old + b11*_FLA - cut3)/b1);
		gen et4=exp(-(b2*_lnsurf + b3*_foreign + b4*_female + b5*_lninc + b6*_unempl + b7*_kid + b8*_young + b9*_adult2 + b10*_old + b11*_FLA - cut4)/b1);
		gen et5=exp(-(b2*_lnsurf + b3*_foreign + b4*_female + b5*_lninc + b6*_unempl + b7*_kid + b8*_young + b9*_adult2 + b10*_old + b11*_FLA - cut5)/b1);
		gen et6=exp(-(b2*_lnsurf + b3*_foreign + b4*_female + b5*_lninc + b6*_unempl + b7*_kid + b8*_young + b9*_adult2 + b10*_old + b11*_FLA - cut6)/b1);
		gen et7=exp(-(b2*_lnsurf + b3*_foreign + b4*_female + b5*_lninc + b6*_unempl + b7*_kid + b8*_young + b9*_adult2 + b10*_old + b11*_FLA - cut7)/b1);			
		gen et8=exp(-(b2*_lnsurf + b3*_foreign + b4*_female + b5*_lninc + b6*_unempl + b7*_kid + b8*_young + b9*_adult2 + b10*_old + b11*_FLA - cut8)/b1);
		gen et9=exp(-(b2*_lnsurf + b3*_foreign + b4*_female + b5*_lninc + b6*_unempl + b7*_kid + b8*_young + b9*_adult2 + b10*_old + b11*_FLA - cut9)/b1);
		gen et10=exp(-(b2*_lnsurf + b3*_foreign + b4*_female + b5*_lninc + b6*_unempl + b7*_kid + b8*_young + b9*_adult2 + b10*_old + b11*_FLA - cut10)/b1);			
		sum et1 et2 et3 et4 et5 et6 et7 et8 et9 et10;		
 
		gen etr2= (1*et2) / (2*et1);
		gen etr3= (2*et3) / (3*et2);
		gen etr4= (3*et4) / (4*et3);
		gen etr5= (4*et5) / (5*et4);
		gen etr6= (5*et6) / (6*et5);
		gen etr7= (6*et7) / (7*et6);
		gen etr8= (7*et8) / (8*et7);
		gen etr9= (8*et9) / (9*et8);
		gen etr10= (9*et10) / (10*et9);
		sum etr2 etr3 etr4 etr5 etr6 etr7 etr8 etr9 etr10;


#delimit cr

log close
