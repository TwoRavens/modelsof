version 14
clear
capture log close

cd "/Users/aboydstun/Dropbox/10,000 Research Ideas, Boydstun, Feezell, and Glazier/Experiment/Data"

log using "Analysis/analysis5_terrorism_replication.log", replace

*#delimit ;
set more off 

*     ***************************************************************** *;
*		REPLICATION FILES FOR: "In the Wake of a Terrorist Attack, 		*;
*		Do Americans’ Attitudes Toward Muslims Decline?"				*;
*																		*;
*       File-Name:      analysis5_terrorism_replication.do				*;
*       Date:           Jan. 21, 2017	  	                            *;
*		Updated:		April 11, 2018									*;
*       Author:         AEB										        *;
*       Purpose:        Analyze terrorism data							*;
*       Data Output:    NONE                                            *;
*       Previous file:  None			                                *;
*       Machine:        Amber's mac (blue one)		                    *;
*     ****************************************************************  *;


use terrorism_data.dta, replace


**********************************
*** Drop Muslim respondents ***
**********************************
tab muslim
drop if muslim==1


**********************************
*** Generate past encounters   ***
*** w/ Muslims binary variables***
**********************************
gen persmuslim_binary=0
replace persmuslim_binary=1 if persmuslim>50 
gen persmuslim_binary_alt=0
replace persmuslim_binary_alt=1 if persmuslim>=50 


**********************************
*** Generate interaction vars  ***
**********************************
gen persmuslim_binary_attacks=persmuslim_binary*attacks
gen persmuslim_binary_alt_attacks=persmuslim_binary_alt*attacks
gen persmuslim_attacks=persmuslim*attacks

gen afterparis=0
replace afterparis=1 if attacks==1
gen persmuslim_binary_afterparis=persmuslim_binary*afterparis

gen aftersan=0
replace aftersan=1 if attacks==2
gen persmuslim_binary_aftersan=persmuslim_binary*aftersan


**********************************
*** 		TABLE 1			   ***
***	   	 BALANCE TESTS     	   ***
**********************************

* Delimit out balancing section while running the rest of the do file, 
* as balancing tests will not all run without dropping the appropriate non-values
#delimit ;

*

sum partyid if attacks==0
sum partyid if attacks==1 
sum partyid if attacks==2 
anova attacks partyid 

*** DROP ONE AT A TIME ONLY FOR BALANCING ***
*drop if white<0
***

sum white if attacks==0
sum white if attacks==1 
sum white if attacks==2
anova attacks white 

*** DROP ONE AT A TIME ONLY FOR BALANCING ***
*drop if age<0
*drop if age>100
***

sum age if attacks==0
sum age if attacks==1 
sum age if attacks==2
anova attacks age


sum female if attacks==0
sum female if attacks==1 
sum female if attacks==2
anova attacks female 

*** DROP ONE AT A TIME ONLY FOR BALANCING ***
drop if edu<0


sum edu if attacks==0
sum edu if attacks==1 
sum edu if attacks==2
anova attacks edu

sum christian if attacks==0
sum christian if attacks==1 
sum christian if attacks==2
anova attacks christian

sum CA if attacks==0
sum CA if attacks==1 
sum CA if attacks==2
anova attacks CA 

sum persmuslim if attacks==0
sum persmuslim if attacks==1 
sum persmuslim if attacks==2
anova attacks persmuslim

sum persmuslim_binary if attacks==0
sum persmuslim_binary if attacks==1 
sum persmuslim_binary if attacks==2
anova attacks persmuslim_binary

*End of delimited section;

* Change back to carriage return delimiting;
#delimit cr


**********************************
*** 		TABLE 2			   ***
***	  OLS REGRESSION RESULTS   ***
**********************************
reg radconcernus attacks persmuslim_binary persmuslim_binary_attacks 
estimates store m1
reg radconcernworld attacks persmuslim_binary persmuslim_binary_attacks 
estimates store m2
reg muslimtherm attacks persmuslim_binary persmuslim_binary_attacks 
estimates store m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 N, label(R-sqr N))
   
   
**********************************
*** 		TABLE 3			   ***
***	  OLS REGRESSION RESULTS   ***
***		WITH FEMALE VAR	  	   ***
**********************************
reg radconcernus attacks persmuslim_binary persmuslim_binary_attacks female
estimates store m1
reg radconcernworld attacks persmuslim_binary persmuslim_binary_attacks female
estimates store m2
reg muslimtherm attacks persmuslim_binary persmuslim_binary_attacks female
estimates store m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(2)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 N, label(R-sqr N))
   

   
*******************************************************************************
***						SUPPLEMENTARY APPENDIX								***
*******************************************************************************
   
   
**********************************
*** 		TABLE A.1		   ***
***	  DESCRIPTIVE STATISTICS   ***
**********************************
sum radconcernus radconcernworld muslimtherm partyid female christian CA persmuslim persmuslim_binary 

*** DROP ONE AT A TIME ONLY FOR DESCRIPTIVE STATISTICS ***
*drop if white<0
sum white

*** DROP ONE AT A TIME ONLY FOR DESCRIPTIVE STATISTICS ***
*drop if age<0
*drop if age>100
sum age

*** DROP ONE AT A TIME ONLY FOR DESCRIPTIVE STATISTICS ***
*drop if edu<0
sum edu



**********************************
*** 	  TABLES A.2-A.4       ***
***	  OLS REGRESSION RESULTS   ***
***    W/ ATTACK DUMMY VARS    ***
**********************************
* TABLE A.2: WITH PARIS AS BASELINE
reg radconcernus afterparis aftersan persmuslim_binary persmuslim_binary_afterparis persmuslim_binary_aftersan 
estimates store m1
reg radconcernworld afterparis aftersan persmuslim_binary persmuslim_binary_afterparis persmuslim_binary_aftersan
estimates store m2
reg muslimtherm afterparis aftersan persmuslim_binary persmuslim_binary_afterparis persmuslim_binary_aftersan
estimates store m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 N, label(R-sqr N))

* TABLE A.3: PARIS VS. BEFORE PARIS
reg radconcernus afterparis persmuslim_binary persmuslim_binary_afterparis if aftersan==0 
estimates store m1
reg radconcernworld afterparis persmuslim_binary persmuslim_binary_afterparis if aftersan==0 
estimates store m2
reg muslimtherm afterparis persmuslim_binary persmuslim_binary_afterparis if aftersan==0  
estimates store m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 N, label(R-sqr N))

* TABLE A.4: SAN BERNARDINO VS. BEFORE SAN BERNARDINO
reg radconcernus aftersan persmuslim_binary persmuslim_binary_aftersan if attacks>0
estimates store m1
reg radconcernworld aftersan persmuslim_binary persmuslim_binary_aftersan if attacks>0
estimates store m2
reg muslimtherm aftersan persmuslim_binary persmuslim_binary_aftersan if attacks>0
estimates store m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 N, label(R-sqr N))
   
   
**********************************
*** 		TABLE A.5		   ***
***	  OLS REGRESSION RESULTS   ***
***		WITH ADDED COVARIATES  ***
**********************************
reg radconcernus attacks persmuslim_binary persmuslim_binary_attacks female  
estimates store m1

reg radconcernus attacks persmuslim_binary persmuslim_binary_attacks female partyid age white 
estimates store m2

reg radconcernworld attacks persmuslim_binary persmuslim_binary_attacks female 
estimates store m3

reg radconcernworld attacks persmuslim_binary persmuslim_binary_attacks female partyid age white 
estimates store m4

reg muslimtherm attacks persmuslim_binary persmuslim_binary_attacks female  
estimates store m5   

reg muslimtherm attacks persmuslim_binary persmuslim_binary_attacks female partyid age white 
estimates store m6

estout m1 m2 m3 m4 m5 m6, cells(b(star fmt(3)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 N, label(R-sqr N))
    

**********************************
*** 		TABLE A.6		   ***
***	  OLS REGRESSION RESULTS   ***
***	   W/ CONTINUOUS MEASURE   ***
**********************************
reg radconcernus attacks persmuslim_binary_alt persmuslim_binary_alt_attacks 
estimates store m1
reg radconcernworld attacks persmuslim_binary_alt persmuslim_binary_alt_attacks 
estimates store m2
reg muslimtherm attacks persmuslim_binary_alt persmuslim_binary_alt_attacks 
estimates store m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 N, label(R-sqr N))
   

**********************************
*** 		TABLE A.7		   ***
***	  OLS REGRESSION RESULTS   ***
***	 W/ ALTERNATIVE CUT-POINT  ***
**********************************
reg radconcernus attacks persmuslim persmuslim_attacks 
estimates store m1
reg radconcernworld attacks persmuslim persmuslim_attacks 
estimates store m2
reg muslimtherm attacks persmuslim persmuslim_attacks 
estimates store m3
estout m1 m2 m3, cells(b(star fmt(3)) se(par fmt(3)))   ///
   legend label varlabels(_cons constant)               ///
   stats(r2 N, label(R-sqr N))
   
   

**********************************
*** 	   FIGURE A.1		   ***
***	HISTOGRAM BY SURVEY DATE   ***
**********************************
hist date, freq


 
**********************************
*** 	FIGURES A.6-A.10	   ***
**REGRESSION DISCONTINUITY PLOTS**
**********************************
* Concern about radicalism in the US, before vs. after each attack
rdplot radconcernus date, c(20406) p(1) if attacks<2 & if radconcernus!=-99
rdplot radconcernus date, c(20425) p(1) if attacks>0 & if radconcernus!=-99

* Concern about radicalism in the world, before vs. after each attack
rdplot radconcernworld date, c(20406) p(1) if attacks<2 & if radconcernworld!=-99
rdplot radconcernworld date, c(20425) p(1) if attacks>0 & if radconcernworld!=-99
 
* Thermometer attitudes toward Muslims, before vs. after each attack
rdplot muslimtherm date, c(20406) p(1) if attacks<2 & if muslimtherm!=-99
rdplot muslimtherm date, c(20425) p(1) if attacks>0 & if muslimtherm!=-99




 
 
 
 
 
 
 
 
 
 
 
 
 
