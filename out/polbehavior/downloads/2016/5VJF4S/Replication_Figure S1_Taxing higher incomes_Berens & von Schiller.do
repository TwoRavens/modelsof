	********************************************************************************
*       Date:       September 2016                                       
*
*       Purpose:   	Do-file to replicate Figure S1 of the article
*                  	"Taxing higher incomes: What makes the high-income earners 
*					consent to more progressive taxation in Latin America?"          
*
*					Figure S1
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
gen group_rich=0
replace group_rich=1 if wealth_group_3pais==3

gen group_middle=0
replace group_middle=1 if wealth_group_3pais==2


gen group_poor=0
replace group_poor=1 if wealth_group_3pais==1


gen gr_richXrespect_polinst=group_rich*respect_polinst
gen gr_middleXrespect_polinst=group_middle*respect_polinst
gen gr_poorXrespect_polinst=group_poor*respect_polinst

estimates clear
	global xs_var  i.gender age  edu_years   household_size i.urban 
	global cty_var b17.countryID 
	set more off
	logit tax_dummy   group_middle group_rich respect_polinst  gr_middleXrespect_polinst gr_richXrespect_polinst $xs_var $cty_var, vce(cluster pais)
	

* Below means (rounded) or modes are used
*/

#delimit ;
preserve;

set seed 339487731;

drawnorm SN_b1-SN_b23, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using "sim_poormiddle_M3table1.dta", replace;
            
noisily display "start";


local a=1 ;
while `a' <= 7 { ;

{;

*scalar h_wealth_group_3pais=1 ;
*scalar h_respect_polinst =.0168793;
scalar h_female =0 ;
scalar h_age=41;
scalar h_edu_years= 10 ;
scalar h_public_empl=0 ;
scalar h_household_size =4;
scalar h_urban=1 ;
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

/*THE POOR AND THE MIDDLE CLASS*/
     generate x_betahat0  =  SN_b3*`a'   
                            + SN_b7 *h_female
                            + SN_b8 *h_age
                            + SN_b9 *h_edu_years
                            + SN_b10 *h_household_size
							+ SN_b12*h_urban
							+ SN_b13*h_MEX
							+ SN_b14*h_GTM
							+ SN_b15*h_CRI
							+ SN_b16*h_COL
							+ SN_b17*h_PER
							+ SN_b18*h_CHL
							+ SN_b19*h_URY
							+ SN_b20*h_BRA
							+ SN_b21*h_VEN
							+ SN_b23*h_constant;
							

                            
    generate x_betahat1  =  SN_b1*1
                            + SN_b3*`a'   
                            + SN_b4*`a'	
                            + SN_b7 *h_female
                            + SN_b8 *h_age
                            + SN_b9 *h_edu_years
                            + SN_b10 *h_household_size
							+ SN_b12*h_urban
							+ SN_b13*h_MEX
							+ SN_b14*h_GTM
							+ SN_b15*h_CRI
							+ SN_b16*h_COL
							+ SN_b17*h_PER
							+ SN_b18*h_CHL
							+ SN_b19*h_URY
							+ SN_b20*h_BRA
							+ SN_b21*h_VEN
							+ SN_b23*h_constant;

*/;
						
 						
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

*drop yline MV;
merge using "sim_poormiddle_M3table1.dta";

gen yline=0;

gen MV = _n;
#delimit ;
replace  MV=. if _n>7;
* in order to cover the whole variable;

* GRAPH MIDDLE CLASS;
graph twoway hist respect_polinst if wealth_group_3pais==2, percent color(gs14) yaxis(2)
        ||  line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid)
        ||  ,   
            xlabel(1(1)7, nogrid labsize(2)) 
            ylabel(-0.35(0.05)0.3 , axis(1) nogrid labsize(2))
            ylabel(0(5)25, axis(2) nogrid labsize(2))
            yscale(noline alt) yscale(noline alt axis(2)) xscale(noline) legend(off)
            yline(0, lcolor(black))
            yline(.001 .003 .005 .007, lcolor(white))
            xtitle("Respect for Political Institutions", size(2.5))
			subtitle("Middle")
			ytitle("Marginal effect of objective wealth measure", size(2.5))
            ytitle(" " " ", axis(2) size(2.5))            
		    xsca(titlegap(4)) ysca(titlegap(4)) ysca(axis(2) titlegap(4))
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
			
graph save Graph "sim_poormiddle_M3table1.gph", replace;
*/;
#delimit ;
drop  prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi _merge yline MV;

* POOR AND RICH
* Below means (rounded) or modes are used
*/
#delimit ;
preserve;

set seed 339487731;

drawnorm SN_b1-SN_b23, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using "sim_poorrich_M3table1.dta", replace;
            
noisily display "start";


local a=1 ;
while `a' <= 7 { ;

{;

*scalar h_wealth_group_3pais=1 ;
*scalar h_respect_polinst =.0168793;
scalar h_female =0 ;
scalar h_age=41;
scalar h_edu_years= 10 ;
scalar h_public_empl=0 ;
scalar h_household_size =4;
scalar h_urban=1 ;
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
        


						
 /*THE POOR AND THE RICH CLASS*/
    generate x_betahat0  =  SN_b3*`a'   
                            + SN_b7 *h_female
                            + SN_b8 *h_age
                            + SN_b9 *h_edu_years
                            + SN_b10 *h_household_size
							+ SN_b12*h_urban
							+ SN_b13*h_MEX
							+ SN_b14*h_GTM
							+ SN_b15*h_CRI
							+ SN_b16*h_COL
							+ SN_b17*h_PER
							+ SN_b18*h_CHL
							+ SN_b19*h_URY
							+ SN_b20*h_BRA
							+ SN_b21*h_VEN
							+ SN_b23*h_constant;
	
                            
    generate x_betahat1  =  SN_b2*1
                            + SN_b3*`a'   
                            + SN_b5*`a'	
							+ SN_b7 *h_female
                            + SN_b8 *h_age
                            + SN_b9 *h_edu_years
                            + SN_b10 *h_household_size
							+ SN_b12*h_urban
							+ SN_b13*h_MEX
							+ SN_b14*h_GTM
							+ SN_b15*h_CRI
							+ SN_b16*h_COL
							+ SN_b17*h_PER
							+ SN_b18*h_CHL
							+ SN_b19*h_URY
							+ SN_b20*h_BRA
							+ SN_b21*h_VEN
							+ SN_b23*h_constant;			
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

*drop _merge  yline MV;
merge using "sim_poorrich_M3table1.dta";

gen yline=0;

gen MV = _n;
#delimit ;
replace  MV=. if _n>7;
* in order to cover the whole variable;


graph twoway hist respect_polinst if wealth_group_3pais==3 , percent color(gs14) yaxis(2)
        ||  line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid)
        ||  ,   
            xlabel(1(1)7, nogrid labsize(2)) 
            ylabel(-0.35(0.05)0.3 , axis(1) nogrid labsize(2))
            ylabel(0(5)25, axis(2) nogrid labsize(2))
            yscale(noline alt) yscale(noline alt axis(2)) xscale(noline) legend(off)
            yline(0, lcolor(black))
            yline(.001 .003 .005 .007, lcolor(white))
            xtitle("Respect for Political Institutions", size(2.5))
			subtitle("Affluent")
			ytitle("Percent of Observations" , axis(2) size(2.5))
            ytitle(" ", size(2.5))
            xsca(titlegap(4)) ysca(titlegap(4)) ysca(axis(2) titlegap(4))
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
			
graph save Graph "sim_poorrich_M3table1.gph", replace;
*/;		


					
#delimit ;
graph combine 	"sim_poormiddle_M3table1.gph" "sim_poorrich_M3table1.gph" , 
				scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));		

