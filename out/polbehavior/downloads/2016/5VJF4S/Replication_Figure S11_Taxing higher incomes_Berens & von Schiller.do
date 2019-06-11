	********************************************************************************
*       Date:       September 2016                                       
*
*       Purpose:   	Do-file to replicate Figure S11 of the article
*                  	"Taxing higher incomes: What makes the high-income earners 
*					consent to more progressive taxation in Latin America?"          
*
*					Figure S11
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

gen group_class1=0
replace group_class1=1 if class_id==1

gen group_class2=0
replace group_class2=1 if class_id==2


gen group_class3=0
replace group_class3=1 if class_id==3

gen group_class4=0
replace group_class4=1 if class_id==4

gen group_class5=0
replace group_class5=1 if class_id==5


gen gr_class1Xrespect_polinst=group_class1*respect_polinst
gen gr_class2Xrespect_polinst=group_class2*respect_polinst
gen gr_class3Xrespect_polinst=group_class3*respect_polinst
gen gr_class4Xrespect_polinst=group_class4*respect_polinst
gen gr_class5Xrespect_polinst=group_class5*respect_polinst

estimates clear
	global x_var  i.gender age  edu_years i.emp_stat2 i.mobility household_size married urban lazy privatization b1
	global cty_var b17.countryID 
	set more off
	logit tax_dummy   group_class2 group_class3 group_class4 group_class5 ///
	respect_polinst  gr_class2Xrespect_polinst gr_class3Xrespect_polinst gr_class4Xrespect_polinst gr_class5Xrespect_polinst $x_var $cty_var, vce(cluster pais)

*******************************************************************************;

#delimit ;
preserve;

set seed 339487731;

drawnorm SN_b1-SN_b38, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using "sim_f6poorlowmiddle.dta", replace;
 
noisily display "start";


local a=0 ;
while `a' <= 7 { ;

{;

scalar h_wealth_group=1 ;
scalar h_respect_polinst =3;
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
1. THE POOR CLASS AND THE MIDDLE CLASS1*/
     generate x_betahat0  =  SN_b5*`a'   
                            + SN_b11 *h_female
                            + SN_b12 *h_age
                            + SN_b13 *h_edu_years
                            + SN_b15 *h_public_empl
                            + SN_b16 *h_unemployed
                            + SN_b17*h_non_employed
							+ SN_b18 *h_retired
							+ SN_b20*h_remainedthesame
							+ SN_b21*h_increased
							+ SN_b22 *h_household_size
							+ SN_b13*h_married
							+ SN_b24*h_urban
							+ SN_b25*h_lazy
							+ SN_b26*h_privatization
							+ SN_b27*h_b1
						    + SN_b29*h_MEX
							+ SN_b30*h_GTM
							+ SN_b31*h_CRI
							+ SN_b32*h_COL
							+ SN_b33*h_PER
							+ SN_b34*h_CHL
							+ SN_b35*h_URY
							+ SN_b36*h_BRA
							+ SN_b37*h_VEN
							+ SN_b38*h_constant;
							
                            
    generate x_betahat1  =  SN_b1*1
                            + SN_b5*`a'   
                            + SN_b6*`a'	
                            + SN_b11 *h_female
                            + SN_b12 *h_age
                            + SN_b13 *h_edu_years
                            + SN_b15 *h_public_empl
                            + SN_b16 *h_unemployed
                            + SN_b17*h_non_employed
							+ SN_b18 *h_retired
							+ SN_b20*h_remainedthesame
							+ SN_b21*h_increased
							+ SN_b22 *h_household_size
							+ SN_b13*h_married
							+ SN_b24*h_urban
							+ SN_b25*h_lazy
							+ SN_b26*h_privatization
						    + SN_b27*h_b1
						    + SN_b29*h_MEX
							+ SN_b30*h_GTM
							+ SN_b31*h_CRI
							+ SN_b32*h_COL
							+ SN_b33*h_PER
							+ SN_b34*h_CHL
							+ SN_b35*h_URY
							+ SN_b36*h_BRA
							+ SN_b37*h_VEN
							+ SN_b38*h_constant;

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

merge using "sim_f6poorlowmiddle.dta";

gen yline=0;

gen MV = _n;
#delimit ;
replace  MV=. if _n>7;
* in order to cover the whole variable;


* GRAPH MIDDLE CLASS;
#delimit ;
graph twoway hist respect_polinst if class_id==2, percent color(gs14) yaxis(2) width(0.2)
        ||  line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid)
        ||  ,   
            xlabel(1(1)7, nogrid labsize(2)) 
            ylabel(-0.8(0.1)0.4 , axis(1) nogrid labsize(2))
            ylabel(0(5)25, axis(2) nogrid labsize(2))
            yscale(noline alt) yscale(noline alt axis(2)) xscale(noline) legend(off)
            yline(0, lcolor(black))
            yline(.001 .003 .005 .007, lcolor(white))
            xtitle("Respect in political institutions", size(2.5))
			subtitle("Lower middle class")
			ytitle("Marginal effect of" "subjective class identification", size(2.5))
            ytitle(" ", axis(2) size(2.5))            
		    xsca(titlegap(4)) ysca(titlegap(4)) ysca(axis(2) titlegap(4))
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
			
graph save Graph "poor_middle_fig6_1.gph", replace;
*/;
#delimit ;
drop  prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi _merge yline MV;


***********2***********;
* Below means (rounded) or modes are used
*/
#delimit ;
preserve;

set seed 339487731;

drawnorm SN_b1-SN_b38, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using "sim_f6poormiddle.dta", replace;
 
noisily display "start";


local a=0 ;
while `a' <= 7 { ;

{;

scalar h_wealth_group=1 ;
scalar h_respect_polinst =3;
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


/*2. THE POOR CLASS AND THE MIDDLE CLASS2*/
     generate x_betahat0  =  SN_b5*`a'   
                            + SN_b11 *h_female
                            + SN_b12 *h_age
                            + SN_b13 *h_edu_years
                            + SN_b15 *h_public_empl
                            + SN_b16 *h_unemployed
                            + SN_b17*h_non_employed
							+ SN_b18 *h_retired
							+ SN_b20*h_remainedthesame
							+ SN_b21*h_increased
							+ SN_b22 *h_household_size
							+ SN_b13*h_married
							+ SN_b24*h_urban
							+ SN_b25*h_lazy
							+ SN_b26*h_privatization
						    + SN_b27*h_b1
						    + SN_b29*h_MEX
							+ SN_b30*h_GTM
							+ SN_b31*h_CRI
							+ SN_b32*h_COL
							+ SN_b33*h_PER
							+ SN_b34*h_CHL
							+ SN_b35*h_URY
							+ SN_b36*h_BRA
							+ SN_b37*h_VEN
							+ SN_b38*h_constant;
							
                            
    generate x_betahat1  =  SN_b2*1
                            + SN_b5*`a'   
                            + SN_b7*`a'	
                            + SN_b11 *h_female
                            + SN_b12 *h_age
                            + SN_b13 *h_edu_years
                            + SN_b15 *h_public_empl
                            + SN_b16 *h_unemployed
                            + SN_b17*h_non_employed
							+ SN_b18 *h_retired
							+ SN_b20*h_remainedthesame
							+ SN_b21*h_increased
							+ SN_b22 *h_household_size
							+ SN_b13*h_married
							+ SN_b24*h_urban
							+ SN_b25*h_lazy
							+ SN_b26*h_privatization
						    + SN_b27*h_b1
						    + SN_b29*h_MEX
							+ SN_b30*h_GTM
							+ SN_b31*h_CRI
							+ SN_b32*h_COL
							+ SN_b33*h_PER
							+ SN_b34*h_CHL
							+ SN_b35*h_URY
							+ SN_b36*h_BRA
							+ SN_b37*h_VEN
							+ SN_b38*h_constant;
							
							
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
merge using "sim_f6poormiddle.dta";

gen yline=0;

gen MV = _n;
#delimit ;
replace  MV=. if _n>7;
* in order to cover the whole variable;


* GRAPH MIDDLE CLASS;
#delimit ;
graph twoway hist respect_polinst if class_id==3, percent color(gs14) yaxis(2) width(0.2)
        ||  line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid)
        ||  ,   
            xlabel(1(1)7, nogrid labsize(2)) 
            ylabel(-0.8(0.1)0.4 , axis(1) nogrid labsize(2))
            ylabel(0(5)25, axis(2) nogrid labsize(2))
            yscale(noline alt) yscale(noline alt axis(2)) xscale(noline) legend(off)
            yline(0, lcolor(black))
            yline(.001 .003 .005 .007, lcolor(white))
            xtitle("Respect in political institutions", size(2.5))
			subtitle("Middle class")
			ytitle(" ", axis(2) size(2.5))            
		    xsca(titlegap(4)) ysca(titlegap(4)) ysca(axis(2) titlegap(4))
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
			
graph save Graph "poor_middle_fig6_2.gph", replace;
*/;
#delimit ;
drop  prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi _merge yline MV;							
/*

***********3***********;
* Below means (rounded) or modes are used
*/
#delimit ;
preserve;

set seed 339487731;

drawnorm SN_b1-SN_b38, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using "sim_f6pooruppermiddle.dta", replace;
 
noisily display "start";


local a=0 ;
while `a' <= 7 { ;

{;

scalar h_wealth_group=1 ;
scalar h_respect_polinst =3;
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

/*3. THE POOR CLASS AND THE UPPER MIDDLE CLASS*/
     generate x_betahat0  =  SN_b5*`a'   
                            + SN_b11 *h_female
                            + SN_b12 *h_age
                            + SN_b13 *h_edu_years
                            + SN_b15 *h_public_empl
                            + SN_b16 *h_unemployed
                            + SN_b17*h_non_employed
							+ SN_b18 *h_retired
							+ SN_b20*h_remainedthesame
							+ SN_b21*h_increased
							+ SN_b22 *h_household_size
							+ SN_b13*h_married
							+ SN_b24*h_urban
							+ SN_b25*h_lazy
							+ SN_b26*h_privatization
						    + SN_b27*h_b1
						    + SN_b29*h_MEX
							+ SN_b30*h_GTM
							+ SN_b31*h_CRI
							+ SN_b32*h_COL
							+ SN_b33*h_PER
							+ SN_b34*h_CHL
							+ SN_b35*h_URY
							+ SN_b36*h_BRA
							+ SN_b37*h_VEN
							+ SN_b38*h_constant;
                            
    generate x_betahat1  =  SN_b3*1
                            + SN_b5*`a'   
                            + SN_b8*`a'	
                            + SN_b11 *h_female
                            + SN_b12 *h_age
                            + SN_b13 *h_edu_years
                            + SN_b15 *h_public_empl
                            + SN_b16 *h_unemployed
                            + SN_b17*h_non_employed
							+ SN_b18 *h_retired
							+ SN_b20*h_remainedthesame
							+ SN_b21*h_increased
							+ SN_b22 *h_household_size
							+ SN_b13*h_married
							+ SN_b24*h_urban
							+ SN_b25*h_lazy
							+ SN_b26*h_privatization
						    + SN_b27*h_b1
						    + SN_b29*h_MEX
							+ SN_b30*h_GTM
							+ SN_b31*h_CRI
							+ SN_b32*h_COL
							+ SN_b33*h_PER
							+ SN_b34*h_CHL
							+ SN_b35*h_URY
							+ SN_b36*h_BRA
							+ SN_b37*h_VEN
							+ SN_b38*h_constant;

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

*drop _merge yline MV;
merge using "sim_f6pooruppermiddle.dta";

gen yline=0;

gen MV = _n;
#delimit ;
replace  MV=. if _n>7;
* in order to cover the whole variable;


* GRAPH MIDDLE CLASS;
#delimit ;
graph twoway hist respect_polinst if class_id==4, percent color(gs14) yaxis(2) width(0.2)
        ||  line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid)
        ||  ,   
            xlabel(1(1)7, nogrid labsize(2)) 
            ylabel(-0.8(0.1)0.4 , axis(1) nogrid labsize(2))
            ylabel(0(5)25, axis(2) nogrid labsize(2))
            yscale(noline alt) yscale(noline alt axis(2)) xscale(noline) legend(off)
            yline(0, lcolor(black))
            yline(.001 .003 .005 .007, lcolor(white))
            xtitle("Respect in political institutions", size(2.5))
			subtitle("Upper middle class")
			ytitle("Marginal effect of" "subjective class identification", size(2.5))
            ytitle(" ", axis(2) size(2.5))            
		    xsca(titlegap(4)) ysca(titlegap(4)) ysca(axis(2) titlegap(4))
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
			
graph save Graph "poor_middle_fig6_3.gph", replace;
*/;

drop  prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi _merge yline MV;							
/*
 
***********4***********;
* Below means (rounded) or modes are used
*/
#delimit ;
preserve;

set seed 339487731;

drawnorm SN_b1-SN_b38, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using "sim_f6poorupper.dta", replace;
 
noisily display "start";


local a=0 ;
while `a' <= 7 { ;

{;

scalar h_wealth_group=1 ;
scalar h_respect_polinst =3;
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

/*4. THE POOR CLASS AND THE UPPER CLASS*/
     generate x_betahat0  =  SN_b5*`a'   
                            + SN_b11 *h_female
                            + SN_b12 *h_age
                            + SN_b13 *h_edu_years
                            + SN_b15 *h_public_empl
                            + SN_b16 *h_unemployed
                            + SN_b17*h_non_employed
							+ SN_b18 *h_retired
							+ SN_b20*h_remainedthesame
							+ SN_b21*h_increased
							+ SN_b22 *h_household_size
							+ SN_b13*h_married
							+ SN_b24*h_urban
							+ SN_b25*h_lazy
							+ SN_b26*h_privatization
						    + SN_b27*h_b1
						    + SN_b29*h_MEX
							+ SN_b30*h_GTM
							+ SN_b31*h_CRI
							+ SN_b32*h_COL
							+ SN_b33*h_PER
							+ SN_b34*h_CHL
							+ SN_b35*h_URY
							+ SN_b36*h_BRA
							+ SN_b37*h_VEN
							+ SN_b38*h_constant;
							
                            
    generate x_betahat1  =  SN_b4*1
                            + SN_b5*`a'   
                            + SN_b9*`a'	
                            + SN_b11 *h_female
                            + SN_b12 *h_age
                            + SN_b13 *h_edu_years
                            + SN_b15 *h_public_empl
                            + SN_b16 *h_unemployed
                            + SN_b17*h_non_employed
							+ SN_b18 *h_retired
							+ SN_b20*h_remainedthesame
							+ SN_b21*h_increased
							+ SN_b22 *h_household_size
							+ SN_b13*h_married
							+ SN_b24*h_urban
							+ SN_b25*h_lazy
							+ SN_b26*h_privatization
						    + SN_b27*h_b1
						    + SN_b29*h_MEX
							+ SN_b30*h_GTM
							+ SN_b31*h_CRI
							+ SN_b32*h_COL
							+ SN_b33*h_PER
							+ SN_b34*h_CHL
							+ SN_b35*h_URY
							+ SN_b36*h_BRA
							+ SN_b37*h_VEN
							+ SN_b38*h_constant;

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

*drop _merge yline MV;
merge using "sim_f6poorupper.dta";
#delimit ;
gen yline=0;

gen MV = _n;
#delimit ;
replace  MV=. if _n>7;
* in order to cover the whole variable;


* GRAPH MIDDLE CLASS;
#delimit ;
graph twoway hist respect_polinst if class_id==5, percent color(gs14) yaxis(2) width(0.2) start()
        ||  line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid)
        ||  ,   
            xlabel(1(1)7, nogrid labsize(2)) 
            ylabel(-0.8(0.1)0.4 , axis(1) nogrid labsize(2))
            ylabel(0(5)25, axis(2) nogrid labsize(2))
            yscale(noline alt) yscale(noline alt axis(2)) xscale(noline) legend(off)
            yline(0, lcolor(black))
            yline(.001 .003 .005 .007, lcolor(white))
            xtitle("Respect in political institutions", size(2.5))
			subtitle("Upper class")
			ytitle(" ", axis(2) size(2.5))            
		    xsca(titlegap(4)) ysca(titlegap(4)) ysca(axis(2) titlegap(4))
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
			
graph save Graph "poor_middle_fig6_4.gph", replace;
*/;
#delimit ;
drop  prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi _merge yline MV;							


					
#delimit ;
graph combine   "poor_middle_fig6_1.gph" ///
				"poor_middle_fig6_2.gph" /// 
				"poor_middle_fig6_3.gph" ///
				"poor_middle_fig6_4.gph" , ///
		scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));		
graph save Graph "FigureS11.gph", replace;

