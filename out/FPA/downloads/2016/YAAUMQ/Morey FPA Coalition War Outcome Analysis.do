version 10
#delimit;
set more off;
set mem 450m;


/*	************************************************************	*/
/*     	File Name:	analysis coalition outcome.do				*/
/*     	Date:   	March 21, 2014		*/
/*      	Author: 	Daniel S. Morey					*/
/*      	Purpose:	Analysis of Coalition War Outcome Data			*/
/*      	Input Files:	"Morey FPA Coalition War Outcome Data.dta"		*/	
/*     	 Output File: 	,					*/	
/*	************************************************************	*/

use "Morey FPA Coalition War Outcome Data.dta";

						*Victory Analysis;
						
probit victory   coalition, robust;

probit victory   coalition, cluster(warnum);


probit victory   coalition initiate  caprat  democracy states, robust;

probit victory   coalition initiate  caprat  democracy states,  cluster(warnum);


							*Win/lose/draw analysis;
oprobit winlosedraw   coalition, robust;

oprobit winlosedraw   coalition initiate  caprat  democracy states, cluster(warnum);
	
						*Outliers;
						
*Four wars could be outliers - 170, 211, 1512, 1631;


probit victory   coalition initiate  caprat  democracy states if warnum !=170, cluster(warnum);
probit victory   coalition initiate  caprat  democracy states if warnum !=211, cluster(warnum);
probit victory   coalition initiate  caprat  democracy states if warnum !=1512, cluster(warnum);
probit victory   coalition initiate  caprat  democracy states if warnum !=1631, cluster(warnum);
probit victory   coalition initiate  caprat  democracy states if warnum !=170 & warnum!=1512 & warnum!=211 & warnum!=1631, cluster(warnum);

							
							*Endogeneity;
							
biprobit ( victory= coalition initiate  caprat  democracy states) ( coalition =  land1  defense leaderdemocracy), vce(cluster warnum);
	predict pcoalition, pmarg2;
	
	
							* Selection Effects;

heckprob victory   coalition initiate  caprat  democracy states, sel(war=jdemo caprat2 majpowd distance) vce(cluster dyadID);	

	
							*Non-independece;
*include was generated using STATA's random number generator.  Exact results will vary depending on the starting seed;
*Since there is only one observation per side robust and cluster(warnum) return the same results;
probit victory   coalition initiate  caprat  democracy states if include==1, robust;


							*Substantive Effects;

estsimp probit victory coalition initiate  caprat  democracy states, cluster(warnum);
	setx (initiate democracy) 0 (states) 2 (caprat) mean (coalition) 0;
	simqi, genpr(newvar1 newvar2);
	
	setx (coalition) 1;
	simqi, genpr(newvar3 newvar4);
	
	*Paired t-test;
		ttest  newvar2== newvar4; 

	*Unpaired t-test with unequal variance;
		ttest  newvar2== newvar4, unpaired unequal;
	
							*As coalitions increase non-democracies;
	
	setx (initiate democracy) 0 (states) 2 (caprat) mean (coalition) 1;
		simqi;
			
	setx (initiate democracy) 0 (states) 3 (caprat) mean (coalition) 1;
		simqi;
	
	setx (initiate democracy) 0 (states) 4 (caprat) mean (coalition) 1;
		simqi;
		
	setx (initiate democracy) 0 (states) 5 (caprat) mean (coalition) 1;
		simqi;
	
	setx (initiate democracy) 0 (states) 6 (caprat) mean (coalition) 1;
		simqi;
		
	setx (initiate democracy) 0 (states) 7 (caprat) mean (coalition) 1;
		simqi;

	setx (initiate democracy) 0 (states) 8 (caprat) mean (coalition) 1;
		simqi;
		
		
							*As coalitions increase democracies;
	
	setx (initiate) 0 (democracy) 2 (states) 2 (caprat) mean (coalition) 1;
		simqi;
			
	setx (initiate) 0 (democracy) 3 (states) 3 (caprat) mean (coalition) 1;
		simqi;
	
	setx (initiate) 0 (democracy) 4 (states) 4 (caprat) mean (coalition) 1;
		simqi;
		
	setx (initiate) 0 (democracy) 5 (states) 5 (caprat) mean (coalition) 1;
		simqi;
	
	setx (initiate) 0 (democracy) 6 (states) 6 (caprat) mean (coalition) 1;
		simqi;
		
	setx (initiate) 0 (democracy) 7 (states) 7 (caprat) mean (coalition) 1;
		simqi;

	setx (initiate) 0 (democracy) 8 (states) 8 (caprat) mean (coalition) 1;
		simqi;
	
	drop b1 b2 b3 b4 b5 b6;
		
estsimp oprobit winlosedraw   coalition initiate  caprat  democracy states, cluster(warnum);
	setx (initiate democracy) 0 (states) 2 (caprat) mean (coalition) 0;
	simqi;
	
	setx (coalition) 1;
	simqi;

	drop b1 b2 b3 b4 b5 b6 b7;
	
	log close,
	
	clear;

