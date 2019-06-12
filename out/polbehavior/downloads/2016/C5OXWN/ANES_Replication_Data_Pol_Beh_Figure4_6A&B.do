#delimit ;

clear;
clear matrix;
clear mata;
set more off;
set maxvar 32000;

use "/Users/AntoineBanks/Desktop/ANES Replication Data/ANES_Replication_Data_Pol_Beh_Accepted.dta", clear;


******************************************************************;
*              Estimate Ordered Probit Model                     *;
*		Probit model (y=1 if oppose to immigration)				 *;
******************************************************************;        
            
probit	immig_11 ethnocenthermna1 angry fear ang_ethna1 fear_ethna1	///
		ideo1_7 equality limit1 partyid1 male income south education age economy v2004 v2000 v1996 ///
		if white==1 & VCF0004~=2008 [pw=VCF0009a];


* drop obs that are not included the model;
gen selected=0;
replace selected=1 if e(sample);
ta selected;
keep if selected==1;

* drop non-using vars;
keep immig_11 ethnocenthermna1 angry fear ang_ethna1 fear_ethna1 ideo1_7 equality limit1 partyid1 male income south 
	 education age economy v2004 v2000 v1996 selected white VCF0004 VCF0009a;


sum ethnocenthermna1;		// check the min and max values for ethnocentherm1
	 
save "/Users/AntoineBanks/Desktop/ANES Replication Data/ANES_Replication_Data_Pol_Beh_Accepted_Probit1.dta", replace;
        
******************************************************************;
*			   Simulation of the model coefficients				 *;
*					!!!! WARNING !!!!							 *;
*																 *;
*			This simulation code take some time to run			 *;
*			depending on the # of vectors drawn and increment	 *;
******************************************************************;

* take 1000 randomly generated vector of betas;
set seed 339487731;	
drawnorm b1-b19, n(1000) means(e(b)) cov(e(V)) clear;		// b1 - b12 are indpendent vars in your model. use the # 1000 (simulated betas) for i loop 

* merge vars from the original dataset;
merge using "/Users/AntoineBanks/Desktop/ANES Replication Data/ANES_Replication_Data_Pol_Beh_Accepted_Probit1.dta";
ta _merge;
rename _merge _merge1;

* create a postfile place to store the estimates using simulation data;
postutil clear;
postfile mypost prob_hat_noemo lo_noemo hi_noemo				// var for Pr(y=1|anger=0) and Confidence Interval
				prob_hat_ang1 lo_ang1 hi_ang1				// var for Pr(y=1|anger=1) and Confidence Interval
				prob_hat_fear1 lo_fear1 hi_fear1			// var for Pr(y=1|fear=1) and Confidence Interval
				diff_hat_ang lo_diff_ang hi_diff_ang		// var for the marginal effect of anger and Confidence Interval
				diff_hat_fear lo_diff_fear hi_diff_fear		// var for the marginal effect of fear and Confidence Interval
				diff_hat_mareff lo_diff_mareff hi_diff_mareff
		 using "/Users/AntoineBanks/Desktop/ANES Replication Data/sim(observed).dta", replace;

display "Begin simulation";
gen pr_noemo_mean=.	;			// create a var that the mean of simulated Pr(fy=1|anger=0) is to be stored
gen pr_ang1_mean=.	;			// create a var that the mean of simulated Pr(fy=1|anger=1) is to be stored
gen pr_fear1_mean=.	;			// create a var that the mean of simulated Pr(fy=1|fear=1) is to be stored
gen eff_ang_mean=.	;			// create a var that the mean of anger's marginal effect is to be sotred
gen eff_fear_mean=.	;			// create a var that the mean of fear's marginal effect is to be sotred
gen diff_marefft_mean=. ;	

* first, make a loop that enables to manually change the value of ethnocentherm1;
* in the probit model, ethnocentherm1 runs from -.75 to .92;
local a=-.81 ;					// the loop starts at the minumum value of ethnocentherm1
while `a' <= .97 { ;			// the loop ends at the maximum value of ethnocentherm1
	display "ethnocentherm1 = `a'" _c;
	
* second, make another loop within the existing loop; 
* in order to compute the mean of estimates using observed value approach;
* the # of rounds shoud be equal to the # of vectors drawn above;
	
	forval i=1/1000 {;  								// i loop number should be equal to the n of simulated betas.
		qui gen prob_noemo_`i' = normal(					// Pr(y=1|anger=0,ethnocen=`a',others at observed value)
							b1[`i']*`a'
							+ b2[`i']*0
							+ b3[`i']*0
							+ b4[`i']*0*`a'
							+ b5[`i']*0*`a'
							+ b6[`i']*ideo1_7
							+ b7[`i']*equality
							+ b8[`i']*limit1
							+ b9[`i']*partyid1
							+ b10[`i']*male
							+ b11[`i']*income
							+ b12[`i']*south 
							+ b13[`i']*education
							+ b14[`i']*age
							+ b15[`i']*economy
							+ b16[`i']*v2004
							+ b17[`i']*v2000
							+ b18[`i']*v1996
							+ b19[`i']) if selected==1;
		qui gen prob_ang1_`i' = normal(					// Pr(y=1|anger=1,ethnocen=`a',others at observed value)
							b1[`i']*`a'
							+ b2[`i']*1
							+ b3[`i']*fear
							+ b4[`i']*1*`a'
							+ b5[`i']*fear*`a'
							+ b6[`i']*ideo1_7
							+ b7[`i']*equality
							+ b8[`i']*limit1
							+ b9[`i']*partyid1
							+ b10[`i']*male
							+ b11[`i']*income
							+ b12[`i']*south 
							+ b13[`i']*education
							+ b14[`i']*age
							+ b15[`i']*economy
							+ b16[`i']*v2004
							+ b17[`i']*v2000
							+ b18[`i']*v1996
							+ b19[`i']) if selected==1;
				qui gen prob_fear1_`i' = normal(				// Pr(y=1|fear=1,ethnocen=`a',others at observed value)
							b1[`i']*`a'
							+ b2[`i']*angry
							+ b3[`i']*1
							+ b4[`i']*angry*`a'
							+ b5[`i']*1*`a'
							+ b6[`i']*ideo1_7
							+ b7[`i']*equality
							+ b8[`i']*limit1
							+ b9[`i']*partyid1
							+ b10[`i']*male
							+ b11[`i']*income
							+ b12[`i']*south 
							+ b13[`i']*education
							+ b14[`i']*age
							+ b15[`i']*economy
							+ b16[`i']*v2004
							+ b17[`i']*v2000
							+ b18[`i']*v1996
							+ b19[`i']) if selected==1;
	
		qui gen diff_ang_`i' = prob_ang1_`i' - prob_noemo_`i';		// compute the difference between 'anger' and 'no anger' when ethnocen=`a'
		qui gen diff_fear_`i' = prob_fear1_`i' - prob_noemo_`i';	// compute the difference between 'fear' and 'no fear' when ethnocen=`a'

		qui gen diff_mareff_`i' = diff_ang_`i' - diff_fear_`i'; 	// compute the difference between anger's marginal effect and fear's marginal effect
		
		qui sum prob_noemo_`i';
		qui replace pr_noemo_mean = r(mean) in `i';			// save the mean of Pr(y=1|anger=0,ethnocen=`a',observed) using the `i'th set of simulated coefficients
		qui sum prob_ang1_`i';
		qui replace pr_ang1_mean = r(mean) in `i';			// save the mean of Pr(y=1|anger=1,ethnocen=`a',observed) using the `i'th set of simulated coefficients
		qui sum prob_fear1_`i';
		qui replace pr_fear1_mean = r(mean) in `i';			// save the mean of Pr(y=1|fear=1,ethnocen=`a',observed) using the `i'th set of simulated coefficients

		qui sum diff_ang_`i';
		qui replace eff_ang_mean = r(mean) in `i';
		qui sum diff_fear_`i';
		qui replace eff_fear_mean = r(mean) in `i';
		qui sum diff_mareff_`i';
		qui replace diff_marefft_mean = r(mean) in `i';

		display "." _c;
		
		};
				
	egen probhat_noemo = mean(pr_noemo_mean);		// find the mean of Pr(y=1|anger=0,ethnocen=`a') using 1000 simulated coefficient vectors
	egen probhat_ang1 = mean(pr_ang1_mean);			// find the mean of Pr(y=1|anger=1,ethnocen=`a') using 1000 simulated coefficient vectors
	egen probhat_fear1 = mean(pr_fear1_mean);		// find the mean of Pr(y=1|fear=1,ethnocen=`a') using 1000 simulated coefficient vectors
	
	egen diffhat_ang = mean(eff_ang_mean);			// find the mean of Pr(y=1|anger=1,ethnocen=`a') - Pr(y=1|anger=0,ethnocen=`a') using 1000 simulated coefficient vectors
	egen diffhat_fear = mean(eff_fear_mean);		// find the mean of Pr(y=1|fear=1,ethnocen=`a') - Pr(y=1|fear=0,ethnocen=`a') using 1000 simulated coefficient vectors	
	egen diffhat_diff = mean(diff_marefft_mean);
	
	tempname prob_hat_noemo lo_noemo hi_noemo
			 prob_hat_ang1 lo_ang1 hi_ang1
			 prob_hat_fear1 lo_fear1 hi_fear1
			 diff_hat_ang lo_diff_ang hi_diff_ang
			 diff_hat_fear lo_diff_fear hi_diff_fear
			 diff_hat_mareff lo_diff_mareff hi_diff_mareff;
			 
	_pctile pr_noemo_mean, p(2.5,97.5);					// find the 90% CI of Pr(y=1|anger=0,ethnocen=`a') using 1000 simulation coefficient vectors
	scalar `lo_noemo' = r(r1);						// store the 5% value of it
	scalar `hi_noemo' = r(r2);						// store the 95% value of it
	scalar `prob_hat_noemo' = probhat_noemo;			// store the mean value of it
	
	_pctile pr_ang1_mean, p(2.5,97.5);					// find the 90% CI of Pr(y=1|anger=1,ethnocen=`a') using 1000 simulation coefficient vectors
	scalar `lo_ang1' = r(r1);
	scalar `hi_ang1' = r(r2);
	scalar `prob_hat_ang1' = probhat_ang1;
		
	_pctile pr_fear1_mean, p(2.5,97.5);					// find the 90% CI of Pr(y=1|fear=1,ethnocen=`a') using 1000 simulation coefficient vectors
	scalar `lo_fear1' = r(r1);
	scalar `hi_fear1' = r(r2);
	scalar `prob_hat_fear1' = probhat_fear1;
	
	_pctile eff_ang_mean, p(2.5,97.5);			// find the 90% CI of the anger's marginal effect when ethnocen=`a', using 1000 simulation coefficient vectors
	scalar `lo_diff_ang' = r(r1);
	scalar `hi_diff_ang' = r(r2);
	scalar `diff_hat_ang' = diffhat_ang;
	
	_pctile eff_fear_mean, p(2.5,97.5);			// find the 90% CI of the fear's marginal effect when ethnocen=`a', using 1000 simulation coefficient vectors
	scalar `lo_diff_fear' = r(r1);
	scalar `hi_diff_fear' = r(r2);
	scalar `diff_hat_fear' = diffhat_fear;
	
	_pctile diff_marefft_mean, p(2.5,97.5);
	scalar `lo_diff_mareff' = r(r1);
	scalar `hi_diff_mareff' = r(r2);
	scalar `diff_hat_mareff' = diffhat_diff;
		
	post mypost (`prob_hat_noemo') (`lo_noemo') (`hi_noemo')		// save all of the above estimated valued to "mypost" using var names in parentheses
				(`prob_hat_ang1') (`lo_ang1') (`hi_ang1')
				(`prob_hat_fear1') (`lo_fear1') (`hi_fear1')
				(`diff_hat_ang') (`lo_diff_ang') (`hi_diff_ang')
				(`diff_hat_fear') (`lo_diff_fear') (`hi_diff_fear')
				(`diff_hat_mareff') (`lo_diff_mareff') (`hi_diff_mareff');
	
	drop probhat_noemo prob_noemo_*			// drop all vars from the 1000 simlulated coefficient vectors
		 probhat_ang1 prob_ang1_*			// so the outer loop can run with the new 1000 vectors
		 probhat_fear1 prob_fear1_*
		 diffhat_ang diff_ang_*
		 diffhat_fear diff_fear_*
		 diffhat_diff diff_mareff_*;
		
	local a=`a'+.05; 						// ethnocentherm1 increases by .05
		
	display " " _newline;
		
};
	
display "End of simulation";
							
postclose mypost; 

******************************************************************;
*			Combine the result to the dataset					 *;
*							and									 *;
*					Graph the results							 *;
******************************************************************;
	
merge using "/Users/AntoineBanks/Desktop/ANES Replication Data/sim(observed).dta";		// merge the "mypost" vars


#delimit ;
gen yline=0;
gen MV = _n-1;
replace MV=. if _merge!=3;
* create a ethnocentrism scale for graphing purpose


#delimit ;
gen Escale = (MV*.05)-.81; // (MV*increment) - min(ethnocentherm1)  // we use this ethnoscale var for x axis

/* If you like to make the ethnocentherm increase by 1, use the following lines:
(you also have to change .05 to .01 in the loop code above, but this will take stat much longer to finish the loop)

gen ethnoscale = (MV*.01)-.81;

*/

#delimit ;            
gen where=0;
gen pipe="|";
egen tag_Escale = tag(Escale);

#delimit ;   
egen tag_ethnocenthermna1 = tag(ethnocenthermna1);


* save the final data;
#delimit ;
save "/Users/AntoineBanks/Desktop/ANES Replication Data/ANES_Replication_Data_Pol_Beh_Accepted_Probit2.dta", replace;	// save the final data (after all the simulation) as a new file


#delimit ;
graph drop _all;
*** Figure 6 ***
#delimit ;
graph twoway  histogram ethnocenthermna1, percent color(gs14) yaxis(2)
		||	  scatter where ethnocenthermna1 if tag_ethnocenthermna1, plotr(m(b 4)) ms(none) mlabcolor(gs5) mlabel(pipe) mlabpos(6)
		||	  line prob_hat_fear1 Escale, lwidth(medium) lpattern(dash) lcolor(black)
		||    line prob_hat_ang1 Escale, lwidth(medium) lpattern(solid) lcolor(black)
		||    line prob_hat_noemo Escale, lwidth(medium) lpattern(shortdash) lcolor(black)
		||	  , 
              xlabel(-.8(.1)1, labsize(2)) 
              ylabel(0(.1)1, axis(1) nogrid labsize(2))
              ylabel(0(10)50, axis(2) nogrid labsize(2))
              legend(order(4 "Anger" 3 "Fear" 5 "No Emotion") rows(1) size(2.5) region(fcolor(none) lcolor(none)))
              xtitle("Ethnocentrism Scale", size(2.5))
              ytitle("Prob. of Decreasing Immigration Levels", axis(1) size(2.5))
              ytitle("Distribution of Ethnocentrism", axis(2) size(2.5))
              xsca(titlegap(4)) ysca(axis(1) titlegap(4)) ysca(axis(2) titlegap(4))
              graphregion(fcolor(white) ilcolor(white) lcolor(white));


              
#delimit ; 
* graph 6A (marginal effect of anger with 95% ci);
graph twoway  rarea hi_diff_ang lo_diff_ang Escale, sort fcolor(gs7) fintensity(15) lwidth(none) lcolor(white)
		||    line diff_hat_ang Escale, lwidth(medium) lpattern(solid) 
		||	  line yline Escale, lwidth(medthin) lpattern(solid) lcolor(black)	
		||	  , 
              xlabel(-.8(.1)1, nogrid labsize(2)) 
              ylabel(-.4(.1).4, axis(1) nogrid labsize(2))
              yline(0, lcolor(black))
              legend(order(2 "Marginal Effect of Anger" 1 "95% CI of Anger") rows(1) size(2.5) region(fcolor(none) lcolor(none)))
              xtitle("Ethnocentrism Scale", size(2.5))
              ytitle("Marginal Effect of Anger on Immigration Policy Opinion", size(2.5))
              xsca(titlegap(4)) ysca(titlegap(4))
              scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
              name(anger_mareff_95);  
            
#delimit ;
* graph 6B (marginal effect of fear with 95% ci);
graph twoway  rarea hi_diff_fear lo_diff_fear Escale, sort fcolor(gs7) fintensity(15) lwidth(none) lcolor(white)
		||    line diff_hat_fear Escale, lwidth(medium) lpattern(solid) 
		||	  line yline Escale, lwidth(medthin) lpattern(solid) lcolor(black)
		||	  , 
              xlabel(-.8(.1)1, nogrid labsize(2)) 
              ylabel(-.4(.1).4, axis(1) nogrid labsize(2))
              yline(0, lcolor(black))
              legend(order(2 "Marginal Effect of Fear" 1 "95% CI of Fear") rows(1) size(2.5) region(fcolor(none) lcolor(none)))
              xtitle("Ethnocentrism Scale", size(2.5))
              ytitle("Marginal Effect of Fear on Immigration Policy Opinion", size(2.5))
              xsca(titlegap(4)) ysca(titlegap(4))
              scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))
              name(fear_mareff_95);




              
