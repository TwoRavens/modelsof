	********************************************************************************
*       Date:       September 2016                                       
*
*       Purpose:   	Do-file to replicate Figure S10 of the article
*                  	"Taxing higher incomes: What makes the high-income earners 
*					consent to more progressive taxation in Latin America?"          
*
*					Figure S10
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
global k_var  i.gender age  edu_years i.emp_stat2 i.mobility household_size married i.urban lazy privatization  
global cty_var b17.countryID 
	
replace q10new= 99 if q10new==.a
replace q10new= 98 if q10new==.b
replace q10new= 97 if q10new==.c

set more off

gen selfreported_wealth_gr1=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr2=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr3=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr4=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr5=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr6=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr7=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr8=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr9=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr10=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr11=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr12=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr13=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr14=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr15=0  if   q10new<33 & q10new!=0
gen selfreported_wealth_gr16=0  if   q10new<33 & q10new!=0

replace selfreported_wealth_gr1=1   if q10new==1 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr2=1   if q10new==2 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr3=1   if q10new==3 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr4=1   if q10new==4 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr5=1   if q10new==5 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr6=1   if q10new==6 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr7=1   if q10new==7 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr8=1   if q10new==8 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr9=1   if q10new==9 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr10=1  if q10new==10 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr11=1  if q10new==11 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr12=1  if q10new==12 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr13=1  if q10new==13 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr14=1  if q10new==14 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr15=1  if q10new==15 &  q10new<33 & q10new!=0
replace selfreported_wealth_gr16=1  if q10new==16 &  q10new<33 & q10new!=0


gen selfrep_1_X_reliability_avs=reliability_avs* selfreported_wealth_gr1
gen selfrep_2_X_reliability_avs=reliability_avs* selfreported_wealth_gr2
gen selfrep_3_X_reliability_avs=reliability_avs* selfreported_wealth_gr3
gen selfrep_4_X_reliability_avs=reliability_avs* selfreported_wealth_gr4
gen selfrep_5_X_reliability_avs=reliability_avs* selfreported_wealth_gr5
gen selfrep_6_X_reliability_avs=reliability_avs* selfreported_wealth_gr6
gen selfrep_7_X_reliability_avs=reliability_avs* selfreported_wealth_gr7
gen selfrep_8_X_reliability_avs=reliability_avs* selfreported_wealth_gr8
gen selfrep_9_X_reliability_avs=reliability_avs* selfreported_wealth_gr9
gen selfrep_10_X_reliability_avs=reliability_avs*selfreported_wealth_gr10
gen selfrep_11_X_reliability_avs=reliability_avs*selfreported_wealth_gr11
gen selfrep_12_X_reliability_avs=reliability_avs*selfreported_wealth_gr12
gen selfrep_13_X_reliability_avs=reliability_avs*selfreported_wealth_gr13
gen selfrep_14_X_reliability_avs=reliability_avs*selfreported_wealth_gr14
gen selfrep_15_X_reliability_avs=reliability_avs*selfreported_wealth_gr15
gen selfrep_16_X_reliability_avs=reliability_avs*selfreported_wealth_gr16

drop selfreported_wealth_gr1 selfrep_1_X_reliability_avs
* To create the reference
estimates clear
	
logit tax_dummy  selfreported_wealth_gr* selfrep_* reliability_avs $k_var $cty_var, vce(cluster pais)
matrix list e(b)	

*******************************************************************************
#delimit ;
preserve;

set seed 339487731;

drawnorm SN_b1-SN_b60, n(10000) means(e(b)) cov(e(V)) clear;
postutil clear;
postfile mypost prob_hat0 lo0 hi0 prob_hat1 lo1 hi1 diff_hat diff_lo diff_hi 
            using "sim_q10new_reliability.dta", replace;
            
noisily display "start";

local a=-5 ;
while `a' <= 5 { ;


{;


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
     generate x_betahat0  =  SN_b31*`a'   
                            + SN_b33 *h_female
                            + SN_b34 *h_age
                            + SN_b35 *h_edu_years
                            + SN_b37 *h_public_empl
                            + SN_b38 *h_unemployed
                            + SN_b39*h_non_employed
							+ SN_b40 *h_retired
							+ SN_b42*h_remainedthesame
							+ SN_b43*h_increased
							+ SN_b44 *h_household_size
							+ SN_b45*h_married
							+ SN_b47*h_urban
							+ SN_b48*h_lazy
							+ SN_b49*h_privatization
							+ SN_b50*h_MEX
							+ SN_b51*h_GTM
							+ SN_b52*h_CRI
							+ SN_b53*h_COL
							+ SN_b54*h_PER
							+ SN_b55*h_CHL
							+ SN_b56*h_URY
							+ SN_b57*h_BRA
							+ SN_b58*h_VEN
							+ SN_b60*h_constant;
							

                            
    generate x_betahat1  =  SN_b15*1
							 + SN_b30*`a'   
                            + SN_b31*`a'
                            + SN_b33 *h_female
                            + SN_b34 *h_age
                            + SN_b35 *h_edu_years
                            + SN_b37 *h_public_empl
                            + SN_b38 *h_unemployed
                            + SN_b39*h_non_employed
							+ SN_b40 *h_retired
							+ SN_b42*h_remainedthesame
							+ SN_b43*h_increased
							+ SN_b44 *h_household_size
							+ SN_b45*h_married
							+ SN_b47*h_urban
							+ SN_b48*h_lazy
							+ SN_b49*h_privatization
							+ SN_b50*h_MEX
							+ SN_b51*h_GTM
							+ SN_b52*h_CRI
							+ SN_b53*h_COL
							+ SN_b54*h_PER
							+ SN_b55*h_CHL
							+ SN_b56*h_URY
							+ SN_b57*h_BRA
							+ SN_b58*h_VEN
							+ SN_b60*h_constant;


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

merge using  "sim_q10new_reliability.dta";

gen yline=0;

gen MV = _n-5.9;
#delimit ;
replace  MV=. if _n>11;
#delimit ;
graph twoway hist reliability_avs if  q10new==16, percent color(gs14) yaxis(2)
        ||  line diff_hat MV, clwidth(medium) clcolor(blue) clcolor(black)
        ||  line diff_lo MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line diff_hi MV, clpattern(dash) clwidth(thin) clcolor(black)
        ||  line yline MV,  clwidth(thin) clcolor(black) clpattern(solid)
        ||  ,   
            xlabel(-5(1)5, nogrid labsize(2)) 
            ylabel(-0.3(0.05)0.4 , axis(1) nogrid labsize(2))
            ylabel(0 2 4 6 8 10, axis(2) nogrid labsize(2))
            yscale(noline alt) yscale(noline alt axis(2)) xscale(noline) legend(off)
            yline(0, lcolor(black))
            yline(.001 .003 .005 .007, lcolor(white))
            xtitle(Respect for Political institutions, size(2.5))
			subtitle("Highest self reported income level")
			ytitle("Marginal effect of" "self reported highest income level", axis(1)  size(2.5))
			ytitle(" ", axis(2) size(2.5))
            xsca(titlegap(4)) ysca(titlegap(4)) ysca(axis(2) titlegap(4))
            scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white));
			
graph save Graph "q10new16_reliability.gph", replace;

