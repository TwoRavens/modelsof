	********************************************************************************
*       Date:       September 2016                                       
*
*       Purpose:   	Do-file to replicate Figure S3 of the article
*                  	"Taxing higher incomes: What makes the high-income earners 
*					consent to more progressive taxation in Latin America?"          
*
*					Figure S3
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
estimates clear
set more off
global x_var  i.gender age  edu_years i.emp_stat2 i.mobility household_size married urban lazy privatization social_trust 
global cty_var b17.countryID 

gen wealth_gr90_X_respect_polinst=rich90_3pais*c.respect_polinst


estimates clear
	
logit tax_dummy  rich90_3pais wealth_gr90_X_respect_polinst respect_polinst $x_var $cty_var, vce(cluster pais)
matrix list e(b)	

#delimit ;
sum  i.gender age  edu_years i.emp_stat2 i.mobility household_size //
married urban lazy privatization social_trust b1 ;


* FIRST MIDDLE and UPPER CLASS

* Below means (rounded) or modes are used
*/

#delimit ;
preserve;

set seed 339487731;

drawnorm SN_b1-SN_b32, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using "sim_s1M3.dta", replace;
            
noisily display "start";

local a=1 ;
while `a' <= 7 { ;

{;


scalar h_rich90_3pais=1 ;
scalar h_respect_polinst =4;
scalar h_female =0 ;
scalar h_age=40;
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
scalar h_social_trust=3;
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
                            + SN_b5 *h_female
                            + SN_b6 *h_age
                            + SN_b7 *h_edu_years
                            + SN_b9 *h_public_empl
                            + SN_b10 *h_unemployed
                            + SN_b11*h_non_employed
							+ SN_b12 *h_retired
							+ SN_b14*h_remainedthesame
							+ SN_b15*h_increased
							+ SN_b16 *h_household_size
							+ SN_b17*h_married
							+ SN_b18*h_urban
							+ SN_b19*h_lazy
							+ SN_b20*h_privatization
							+ SN_b21*h_social_trust
							+ SN_b22*h_MEX
							+ SN_b23*h_GTM
							+ SN_b24*h_CRI
							+ SN_b25*h_COL
							+ SN_b26*h_PER
							+ SN_b27*h_CHL
							+ SN_b28*h_URY
							+ SN_b29*h_BRA
							+ SN_b30*h_VEN
							+ SN_b32*h_constant;
							

                            
    generate x_betahat1  =  SN_b1*1
							 + SN_b2*`a'  
							 +SN_b3*`a' 
                            + SN_b5 *h_female
                            + SN_b6 *h_age
                            + SN_b7 *h_edu_years
                            + SN_b9 *h_public_empl
                            + SN_b10 *h_unemployed
                            + SN_b11*h_non_employed
							+ SN_b12 *h_retired
							+ SN_b14*h_remainedthesame
							+ SN_b15*h_increased
							+ SN_b16 *h_household_size
							+ SN_b17*h_married
							+ SN_b18*h_urban
							+ SN_b19*h_lazy
							+ SN_b20*h_privatization
							+ SN_b21*h_social_trust
							+ SN_b22*h_MEX
							+ SN_b23*h_GTM
							+ SN_b24*h_CRI
							+ SN_b25*h_COL
							+ SN_b26*h_PER
							+ SN_b27*h_CHL
							+ SN_b28*h_URY
							+ SN_b29*h_BRA
							+ SN_b30*h_VEN
							+ SN_b32*h_constant;



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

merge using  "sim_s1M3.dta";

gen yline=0;

gen MV = _n;
#delimit ;
replace  MV=. if _n>7;
#delimit ;
graph twoway hist respect_polinst if  rich90_3pais==1, percent color(gs14) yaxis(2)
        ||  line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid)
        ||  ,   
            xlabel(1(1)7, nogrid labsize(2)) 
            ylabel(-0.3(0.05)0.2 , axis(1) nogrid labsize(2))
            ylabel(0 5 10 15 20 25, axis(2) nogrid labsize(2))
            yscale(noline alt) yscale(noline alt axis(2)) xscale(noline) legend(off)
            yline(0, lcolor(black))
            yline(.001 .003 .005 .007, lcolor(white))
            xtitle(Respect for Political institutions, size(2.5))
			ytitle("Marginal effect of" "top 10% wealth levels", axis(1)  size(2.5))
			ytitle(" ", axis(2) size(2.5))
            xsca(titlegap(4)) ysca(titlegap(4)) ysca(axis(2) titlegap(4))
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
			
graph save Graph "Top10.gph", replace;
