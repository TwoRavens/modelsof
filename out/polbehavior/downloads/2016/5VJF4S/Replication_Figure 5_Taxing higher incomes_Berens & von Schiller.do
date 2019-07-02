	********************************************************************************
*       Date:       September 2016                                       
*
*       Purpose:   	Do-file to replicate Figure 5 of the article
*                  	"Taxing higher incomes: What makes the high-income earners 
*					consent to more progressive taxation in Latin America?"          
*
*					Figure 5
*
*       Authors:    Sarah Berens (University of Cologne)     
*					Armin von Schiller (German Development Institute & Hertie School of Governance)       
********************************************************************************
version 13.0
* Change directory
cd "C:your_path_to_the_folder"

* Note: please run the dofile "Replication_Taxing higher incomes_datamangement" to obtain the dataset to be used in order to replicate the results
use "Data generated through datamanagement dofile", clear



********************************************************************************

gen wealth_gr_X_b10a=wealth_group_3pais*b10a
gen group_rich=0
replace group_rich=1 if wealth_group_3pais==3

gen group_middle=0
replace group_middle=1 if wealth_group_3pais==2


gen group_poor=0
replace group_poor=1 if wealth_group_3pais==1


gen gr_richXb10a=group_rich*b10a
gen gr_middleXb10a=group_middle*b10a
gen gr_poorXb10a=group_poor*b10a

estimates clear
	global x_var  i.gender age  edu_years i.emp_stat2 i.mobility household_size married urban lazy privatization b1
	set more off
	logit tax_dummy   group_middle group_rich b10a gr_middleXb10a gr_richXb10a $x_var $cty_var, vce(cluster pais)



*/
* THE POOR AND THE RICH
*/
#delimit ;
preserve;

set seed 339487731;

drawnorm SN_b1-SN_b34, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using "sim_f5poorrich.dta", replace;
            
noisily display "start";


local a=0 ;
while `a' <= 7 { ;

{;

scalar h_wealth_group_3pais=1 ;
scalar h_b10a =3;
scalar h_female =0 ;
scalar h_age=41;
scalar h_edu_years= 10 ;
scalar h_public_empl=0 ;
scalar h_unemployed=0 ;
scalar h_non_employed=0;
scalar h_retired =0 ;
scalar h_remainedthesame =1 ;
scalar h_increased=0;
scalar h_household_size =4;
scalar h_married=1;
scalar h_urban=1 ;
scalar h_lazy=4 ;
scalar h_privatization=4;
scalar h_b1=4;
scalar h_MEX=.0995804 ;
scalar h_GTM=.0911879;
scalar h_CRI=.0966753 ;
scalar h_COL=.0884442 ;
scalar h_PER=.0934474;
scalar h_CHL=.0936088 ;
scalar h_URY=.0957069 ;
scalar h_BRA=.1894771;
scalar h_VEN=.0716591;
scalar h_constant=1;           
/*

*/;
 					
 /*THE POOR AND THE RICH CLASS*/
    generate x_betahat0  =  SN_b3*`a'   
                            + SN_b7 *h_female
                            + SN_b8 *h_age
                            + SN_b9 *h_edu_years
                            + SN_b11 *h_public_empl
                            + SN_b12 *h_unemployed
                            + SN_b13*h_non_employed
							+ SN_b14 *h_retired
							+ SN_b16*h_remainedthesame
							+ SN_b17*h_increased
							+ SN_b18 *h_household_size
							+ SN_b19*h_married
							+ SN_b20*h_urban
							+ SN_b21*h_lazy
							+ SN_b22*h_privatization
							+ SN_b23*h_b1
						    + SN_b24*h_MEX
							+ SN_b25*h_GTM
							+ SN_b26*h_CRI
							+ SN_b27*h_COL
							+ SN_b28*h_PER
							+ SN_b29*h_CHL
							+ SN_b30*h_URY
							+ SN_b31*h_BRA
							+ SN_b32*h_VEN
							+ SN_b34*h_constant;
							
                            
    generate x_betahat1  =  SN_b2*1
                            + SN_b3*`a'   
                            + SN_b5*`a'	
							+ SN_b7 *h_female
                            + SN_b8 *h_age
                            + SN_b9 *h_edu_years
                            + SN_b11 *h_public_empl
                            + SN_b12 *h_unemployed
                            + SN_b13*h_non_employed
							+ SN_b14 *h_retired
							+ SN_b16*h_remainedthesame
							+ SN_b17*h_increased
							+ SN_b18 *h_household_size
							+ SN_b19*h_married
							+ SN_b20*h_urban
							+ SN_b21*h_lazy
							+ SN_b22*h_privatization
							+ SN_b23*h_b1
						    + SN_b24*h_MEX
							+ SN_b25*h_GTM
							+ SN_b26*h_CRI
							+ SN_b27*h_COL
							+ SN_b28*h_PER
							+ SN_b29*h_CHL
							+ SN_b30*h_URY
							+ SN_b31*h_BRA
							+ SN_b32*h_VEN
							+ SN_b34*h_constant;						
*/;	
						


    gen prob0 =normal(x_betahat0);
    gen prob1=normal(x_betahat1);
    gen diff=prob1-prob0;
    
    egen probhat0 =mean(prob0);
    egen probhat1=mean(prob1);
    egen diffhat=mean(diff);
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi;  

    _pctile prob0, p(5,95) ;
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);  
    
    _pctile prob1, p(5,95);
    scalar `lo1'= r(r1);
    scalar `hi1'= r(r2);  
    
    _pctile diff, p(5,95);
    scalar `diff_lo'= r(r1);
    scalar `diff_hi'= r(r2);  
   
    scalar `prob_hat0'=probhat0;
    scalar `prob_hat1'=probhat1;
    scalar `diff_hat'=diffhat;
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 
                (`diff_hat') (`diff_lo') (`diff_hi');
   
    };      
    
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat;
    
    local a=`a'+ 1;
    
    display "." _c;
    
} ;

display "";

postclose mypost;

*     ****************************************************************  *;                                  
*       Call on posted quantities of interest                           *;
*     ****************************************************************  *;
restore;
#delimit ;

*drop _merge yline MV;
merge using "sim_f5poorrich.dta";

gen yline=0;

gen MV = _n;
#delimit ;
replace  MV=. if _n>7;
* in order to cover the whole variable;


graph twoway hist b10a if wealth_group_3pais==3, percent color(gs14) yaxis(2)
        ||  line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid)
        ||  ,   
            xlabel(1(1)7, nogrid labsize(2)) 
            ylabel(-0.3(0.05)0.4 , axis(1) nogrid labsize(2))
            ylabel(0(5)25 , axis(2) nogrid labsize(2))
            yscale(noline alt) yscale(noline alt axis(2)) xscale(noline) legend(off)
            yline(0, lcolor(black))
            yline(.001 .003 .005 .007, lcolor(white))
            xtitle("Trust in the justice system", size(2.5))
			ytitle("Marginal effect of objective wealth measure", size(2.5))
			ytitle("" , axis(2) size(2.5))
            ytitle(" ", size(2.5))
            xsca(titlegap(4)) ysca(titlegap(4)) ysca(axis(2) titlegap(4))
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
			
graph save Graph "Figure_5_Judicial.gph", replace;

					
***** Executive;
#delimit cr

clear
use "LAPOP2012_workingfile_replication.dta", clear
*****************************************************************************
gen wealth_gr_X_b21a=wealth_group_3pais*b21a
gen group_rich=0
replace group_rich=1 if wealth_group_3pais==3

gen group_middle=0
replace group_middle=1 if wealth_group_3pais==2


gen group_poor=0
replace group_poor=1 if wealth_group_3pais==1


gen gr_richXb21a=group_rich*b21a
gen gr_middleXb21a=group_middle*b21a
gen gr_poorXb21a=group_poor*b21a

estimates clear
	global x_var  i.gender age  edu_years i.emp_stat2 i.mobility household_size married urban lazy privatization b1
	set more off
	logit tax_dummy   group_middle group_rich b21a gr_middleXb21a gr_richXb21a $x_var $cty_var, vce(cluster pais)



*RELEVANT THEORETICALLY
sum b21a 
*#delimit ;


* THE POOR AND THE RICH
* Below means (rounded) or modes are used
*/
#delimit ;
preserve;

set seed 339487731;

drawnorm SN_b1-SN_b34, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using "sim_f5poorrich.dta", replace;
            
noisily display "start";


local a=0 ;
while `a' <= 7 { ;

{;

scalar h_wealth_group_3pais=1 ;
scalar h_b21a =3;
scalar h_female =0 ;
scalar h_age=41;
scalar h_edu_years= 10 ;
scalar h_public_empl=0 ;
scalar h_unemployed=0 ;
scalar h_non_employed=0;
scalar h_retired =0 ;
scalar h_remainedthesame =1 ;
scalar h_increased=0;
scalar h_household_size =4;
scalar h_married=1;
scalar h_urban=1 ;
scalar h_lazy=4 ;
scalar h_privatization=4;
scalar h_b1=4;
scalar h_MEX=.0995804 ;
scalar h_GTM=.0911879;
scalar h_CRI=.0966753 ;
scalar h_COL=.0884442 ;
scalar h_PER=.0934474;
scalar h_CHL=.0936088 ;
scalar h_URY=.0957069 ;
scalar h_BRA=.1894771;
scalar h_VEN=.0716591;
scalar h_constant=1;           
/*

*/;
 					
 /*THE POOR AND THE RICH CLASS*/
    generate x_betahat0  =  SN_b3*`a'   
                            + SN_b7 *h_female
                            + SN_b8 *h_age
                            + SN_b9 *h_edu_years
                            + SN_b11 *h_public_empl
                            + SN_b12 *h_unemployed
                            + SN_b13*h_non_employed
							+ SN_b14 *h_retired
							+ SN_b16*h_remainedthesame
							+ SN_b17*h_increased
							+ SN_b18 *h_household_size
							+ SN_b19*h_married
							+ SN_b20*h_urban
							+ SN_b21*h_lazy
							+ SN_b22*h_privatization
							+ SN_b23*h_b1
						    + SN_b24*h_MEX
							+ SN_b25*h_GTM
							+ SN_b26*h_CRI
							+ SN_b27*h_COL
							+ SN_b28*h_PER
							+ SN_b29*h_CHL
							+ SN_b30*h_URY
							+ SN_b31*h_BRA
							+ SN_b32*h_VEN
							+ SN_b34*h_constant;
							
	
                            
    generate x_betahat1  =  SN_b2*1
                            + SN_b3*`a'   
                            + SN_b5*`a'	
							+ SN_b7 *h_female
                            + SN_b8 *h_age
                            + SN_b9 *h_edu_years
                            + SN_b11 *h_public_empl
                            + SN_b12 *h_unemployed
                            + SN_b13*h_non_employed
							+ SN_b14 *h_retired
							+ SN_b16*h_remainedthesame
							+ SN_b17*h_increased
							+ SN_b18 *h_household_size
							+ SN_b19*h_married
							+ SN_b20*h_urban
							+ SN_b21*h_lazy
							+ SN_b22*h_privatization
							+ SN_b23*h_b1
						    + SN_b24*h_MEX
							+ SN_b25*h_GTM
							+ SN_b26*h_CRI
							+ SN_b27*h_COL
							+ SN_b28*h_PER
							+ SN_b29*h_CHL
							+ SN_b30*h_URY
							+ SN_b31*h_BRA
							+ SN_b32*h_VEN
							+ SN_b34*h_constant;						
*/;	
						


    gen prob0 =normal(x_betahat0);
    gen prob1=normal(x_betahat1);
    gen diff=prob1-prob0;
    
    egen probhat0 =mean(prob0);
    egen probhat1=mean(prob1);
    egen diffhat=mean(diff);
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi;  

    _pctile prob0, p(5,95) ;
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);  
    
    _pctile prob1, p(5,95);
    scalar `lo1'= r(r1);
    scalar `hi1'= r(r2);  
    
    _pctile diff, p(5,95);
    scalar `diff_lo'= r(r1);
    scalar `diff_hi'= r(r2);  
   
    scalar `prob_hat0'=probhat0;
    scalar `prob_hat1'=probhat1;
    scalar `diff_hat'=diffhat;
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 
                (`diff_hat') (`diff_lo') (`diff_hi');
   
    };      
    
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat;
    
    local a=`a'+ 1;
    
    display "." _c;
    
} ;

display "";

postclose mypost;

*     ****************************************************************  *;                                  
*       Call on posted quantities of interest                           *;
*     ****************************************************************  *;
restore;
#delimit ;

*drop _merge yline MV;
merge using "sim_f5poorrich.dta";

gen yline=0;

gen MV = _n;
#delimit ;
replace  MV=. if _n>7;
* in order to cover the whole variable;


graph twoway hist b21a if wealth_group_3pais==3, percent color(gs14) yaxis(2)
        ||  line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid)
        ||  ,   
            xlabel(1(1)7, nogrid labsize(2)) 
            ylabel(-0.3(0.05)0.4 , axis(1) nogrid labsize(2))
            ylabel(0(5)25 , axis(2) nogrid labsize(2))
            yscale(noline alt) yscale(noline alt axis(2)) xscale(noline) legend(off)
            yline(0, lcolor(black))
            yline(.001 .003 .005 .007, lcolor(white))
            xtitle("Trust in the President/Prime Minister", size(2.5))
			ytitle("" , axis(2) size(2.5))
            ytitle(" ", size(2.5))
            xsca(titlegap(4)) ysca(titlegap(4)) ysca(axis(2) titlegap(4))
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
			
graph save Graph "Figure_5_Executive.gph", replace;






***** Legislature;
#delimit cr

use "LAPOP2012_workingfile_replication.dta", clear
***************************************************************************
estimates clear

gen wealth_gr_X_trust_legis=wealth_group_3pais*trust_legis
gen group_rich=0
replace group_rich=1 if wealth_group_3pais==3

gen group_middle=0
replace group_middle=1 if wealth_group_3pais==2


gen group_poor=0
replace group_poor=1 if wealth_group_3pais==1


gen gr_richXtrust_legis=group_rich*trust_legis
gen gr_middleXtrust_legis=group_middle*trust_legis
gen gr_poorXtrust_legis=group_poor*trust_legis

estimates clear
	global x_var  i.gender age  edu_years i.emp_stat2 i.mobility household_size married urban lazy privatization b1
	set more off
	logit tax_dummy   group_middle group_rich trust_legis gr_middleXtrust_legis gr_richXtrust_legis $x_var $cty_var, vce(cluster pais)



*RELEVANT THEORETICALLY
sum trust_legis 


* THE POOR AND THE RICH
* Below means (rounded) or modes are used
*/
#delimit ;
preserve;

set seed 339487731;

drawnorm SN_b1-SN_b34, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using "sim_f5poorrich.dta", replace;
            
noisily display "start";


local a=0 ;
while `a' <= 7 { ;

{;

scalar h_wealth_group_3pais=1 ;
scalar h_trust_legis =3;
scalar h_female =0 ;
scalar h_age=41;
scalar h_edu_years= 10 ;
scalar h_public_empl=0 ;
scalar h_unemployed=0 ;
scalar h_non_employed=0;
scalar h_retired =0 ;
scalar h_remainedthesame =1 ;
scalar h_increased=0;
scalar h_household_size =4;
scalar h_married=1;
scalar h_urban=1 ;
scalar h_lazy=4 ;
scalar h_privatization=4;
scalar h_b1=4;
scalar h_MEX=.0995804 ;
scalar h_GTM=.0911879;
scalar h_CRI=.0966753 ;
scalar h_COL=.0884442 ;
scalar h_PER=.0934474;
scalar h_CHL=.0936088 ;
scalar h_URY=.0957069 ;
scalar h_BRA=.1894771;
scalar h_VEN=.0716591;
scalar h_constant=1;           
/*

*/;
 					
 /*THE POOR AND THE RICH CLASS*/
    generate x_betahat0  =  SN_b3*`a'   
                            + SN_b7 *h_female
                            + SN_b8 *h_age
                            + SN_b9 *h_edu_years
                            + SN_b11 *h_public_empl
                            + SN_b12 *h_unemployed
                            + SN_b13*h_non_employed
							+ SN_b14 *h_retired
							+ SN_b16*h_remainedthesame
							+ SN_b17*h_increased
							+ SN_b18 *h_household_size
							+ SN_b19*h_married
							+ SN_b20*h_urban
							+ SN_b21*h_lazy
							+ SN_b22*h_privatization
							+ SN_b23*h_b1
						    + SN_b24*h_MEX
							+ SN_b25*h_GTM
							+ SN_b26*h_CRI
							+ SN_b27*h_COL
							+ SN_b28*h_PER
							+ SN_b29*h_CHL
							+ SN_b30*h_URY
							+ SN_b31*h_BRA
							+ SN_b32*h_VEN
							+ SN_b34*h_constant;
							
	
                            
    generate x_betahat1  =  SN_b2*1
                            + SN_b3*`a'   
                            + SN_b5*`a'	
							+ SN_b7 *h_female
                            + SN_b8 *h_age
                            + SN_b9 *h_edu_years
                            + SN_b11 *h_public_empl
                            + SN_b12 *h_unemployed
                            + SN_b13*h_non_employed
							+ SN_b14 *h_retired
							+ SN_b16*h_remainedthesame
							+ SN_b17*h_increased
							+ SN_b18 *h_household_size
							+ SN_b19*h_married
							+ SN_b20*h_urban
							+ SN_b21*h_lazy
							+ SN_b22*h_privatization
							+ SN_b23*h_b1
						    + SN_b24*h_MEX
							+ SN_b25*h_GTM
							+ SN_b26*h_CRI
							+ SN_b27*h_COL
							+ SN_b28*h_PER
							+ SN_b29*h_CHL
							+ SN_b30*h_URY
							+ SN_b31*h_BRA
							+ SN_b32*h_VEN
							+ SN_b34*h_constant;						
*/;	
						


    gen prob0 =normal(x_betahat0);
    gen prob1=normal(x_betahat1);
    gen diff=prob1-prob0;
    
    egen probhat0 =mean(prob0);
    egen probhat1=mean(prob1);
    egen diffhat=mean(diff);
    
    tempname prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi;  

    _pctile prob0, p(5,95) ;
    scalar `lo0' = r(r1);
    scalar `hi0' = r(r2);  
    
    _pctile prob1, p(5,95);
    scalar `lo1'= r(r1);
    scalar `hi1'= r(r2);  
    
    _pctile diff, p(5,95);
    scalar `diff_lo'= r(r1);
    scalar `diff_hi'= r(r2);  
   
    scalar `prob_hat0'=probhat0;
    scalar `prob_hat1'=probhat1;
    scalar `diff_hat'=diffhat;
    
    post mypost (`prob_hat0') (`lo0') (`hi0') (`prob_hat1') (`lo1') (`hi1') 
                (`diff_hat') (`diff_lo') (`diff_hi');
   
    };      
    
    drop x_betahat0 x_betahat1 prob0 prob1 diff probhat0 probhat1 diffhat;
    
    local a=`a'+ 1;
    
    display "." _c;
    
} ;

display "";

postclose mypost;

*     ****************************************************************  *;                                  
*       Call on posted quantities of interest                           *;
*     ****************************************************************  *;
restore;
#delimit ;


merge using "sim_f5poorrich.dta";

gen yline=0;

gen MV = _n;
#delimit ;
replace  MV=. if _n>7;



graph twoway hist trust_legis if wealth_group_3pais==3, percent color(gs14) yaxis(2)
        ||  line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid)
        ||  ,   
            xlabel(1(1)7, nogrid labsize(2)) 
            ylabel(-0.3(0.05)0.4 , axis(1) nogrid labsize(2))
            ylabel(0(5)25 , axis(2) nogrid labsize(2))
            yscale(noline alt) yscale(noline alt axis(2)) xscale(noline) legend(off)
            yline(0, lcolor(black))
            yline(.001 .003 .005 .007, lcolor(white))
            xtitle("Trust in the National Legislature", size(2.5))
			ytitle("Percent of Observations" , axis(2) size(2.5))
            ytitle(" ", size(2.5))
            xsca(titlegap(4)) ysca(titlegap(4)) ysca(axis(2) titlegap(4))
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
			
graph save Graph "Figure_5_Legislature.gph", replace;

					

#delimit ;
graph combine 	"Figure_5_Executive" ///
				"Figure_5_Judicial"  ///
				"Figure_5_Legislature.gph" , rows(1) ///
scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white)) ///
note("Bold dotted lines correspond to the point predictions. Dotted lines delimit the 90% confidence interval." "Estimation for male, employed, married, urban individuals (corresponds to modes). All other variables at means (rounded).", span size(1.7) );		
graph save Graph "Figure_5_complete.gph", replace;
