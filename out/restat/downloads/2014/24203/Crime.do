

clear all
set more off
set memo 500m
set matsize 800
capture log close


cd ~/Crime

log using Crime.log, text replace
  
use Crime.dta, clear 

tsset id year


********************************************************************************************


global rhs00w "lmfw1625 lmfw1015 lmfw2645 lmfw4665" /*ln (weighted sex ratio), census 2000) */

global rhs00b "lbprovmf1625 lbprovmf1015 lbprovmf2645 lbprovmf4665" /*ln (birth sex ratio), census 2000) */ 

global rhs00c "lprovmf1625 lprovmf1015 lprovmf2645 lprovmf4665" /*ln (resident sex ratio), census 2000) */

global rhs90s "lmf90x1625 lmf90x2645 lmf90x4665" /*ln (resident sex ratio), census 1990) */

global rhs00bls "lbprovm1625 lbprovw1625 "  /* ln (# of men or women born in the province), census 2000, age 16-25 */

global rhs00bl  "lbprovm1625 lbprovw1625 lbprovm1015 lbprovw1015 lbprovm2645 lbprovw2645 lbprovm4665 lbprovw4665" /* ln (# of men or women born in the province), census 2000 */


********************************************************************************************


tab id, ge(pd)

tab year, ge(yd)

forvalues i=1(1)30 {

	g t`i'=pd`i'*year
	
	}


********************************************************************************************
	
global rhs1 "yd* t*"

global rhs2 "lpop lincome employment  inequality urbanization" /* basic covariates*/

global rhs3 "lwelfare  eximfdi_gdp lconstruction immigration lpolice" /* additional covariates*/


********************************************************************************************

* Table 1: Descriptive Statistics

********************************************************************************************

sum crime corruption mfw* pop income employment inequality urbanization welfare eximfdi_gdp immigration construction police 

********************************************************************************************

* Table 4: Sex Ratios and Crime

********************************************************************************************

     eststo: reg  lcrime  $rhs00w  ,   cluster(id)
     eststo: xi: xtreg  lcrime  $rhs00w  , fe  cluster(id)
     eststo: xi: xtreg  lcrime  $rhs00w  yd* , fe  cluster(id)
     eststo: xi: xtreg  lcrime  $rhs00w  yd*  $rhs2, fe  cluster(id)
     eststo: xi: xtreg  lcrime  $rhs00w  yd*  $rhs2 $rhs3, fe  cluster(id)
     eststo: xi: xtreg  lcrime  $rhs00w  yd* t* $rhs2 $rhs3, fe  cluster(id)
 
esttab using SexCrime.tex, label se ar2 title(Sex Ratios) keep(lmfw*) addnote("") star(* 0.10 ** 0.05 *** 0.01)replace
eststo clear
 
     eststo: reg  lcrime  $rhs00w  [fweight=pop],  cluster(id)
     eststo: reg  lcrime  $rhs00w pd* [fweight=pop],  cluster(id)
     eststo: reg  lcrime  $rhs00w pd* yd* [fweight=pop],  cluster(id)
     eststo: reg  lcrime  $rhs00w pd* yd*  $rhs2[fweight=pop],  cluster(id)
     eststo: reg  lcrime  $rhs00w pd* yd*  $rhs2 $rhs3[fweight=pop],  cluster(id)
     eststo: reg  lcrime  $rhs00w pd* yd* t* $rhs2 $rhs3[fweight=pop],  cluster(id)
 
esttab using SexCrime.tex, label se ar2 title(Sex Ratios) keep(lmfw*) addnote("") star(* 0.10 ** 0.05 *** 0.01) append
eststo clear  

 
********************************************************************************************

* Table 5: Sex Ratios and Crime - Alternative Sex Ratio Measures (Full results reported in Tables III.A-D in Appendix B

********************************************************************************************
      
        eststo: reg  lcrime  $rhs00b  ,   cluster(id)
        eststo: xi: xtreg  lcrime  $rhs00b   , fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs00b  yd*  , fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs00b  yd*  $rhs2 , fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs00b  yd*  $rhs2 $rhs3 , fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs00b  yd* t* $rhs2 $rhs3 , fe  cluster(id)
    
esttab using AltSexCrime.tex, label se ar2 title(Alternative Sex Ratios) keep(lbprovmf1625) addnote("") star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear
    		
     
        eststo: reg  lcrime  $rhs00b  [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs00b pd* [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs00b pd* yd* [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs00b pd* yd*  $rhs2 [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs00b pd* yd*  $rhs2 $rhs3 [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs00b pd* yd* t* $rhs2 $rhs3 [fweight=pop],  cluster(id)
    
esttab using AltSexCrime.tex, label se ar2 title(Alternative Sex Ratios)keep(lbprovmf1625) addnote("") star(* 0.10 ** 0.05 *** 0.01) append
eststo clear

        eststo: reg  lcrime  $rhs00c  ,   cluster(id)
        eststo: xi: xtreg  lcrime  $rhs00c   , fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs00c  yd*  , fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs00c  yd*  $rhs2 , fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs00c  yd*  $rhs2 $rhs3 , fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs00c  yd* t* $rhs2 $rhs3 , fe  cluster(id)
    
esttab using AltSexCrime.tex, label se ar2 title(Alternative Sex Ratios)keep(lprovmf1625) addnote("") star(* 0.10 ** 0.05 *** 0.01)append
eststo clear
    	
     
        eststo: reg  lcrime  $rhs00c  [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs00c pd* [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs00c pd* yd* [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs00c pd* yd*  $rhs2 [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs00c pd* yd*  $rhs2 $rhs3 [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs00c pd* yd* t* $rhs2 $rhs3 [fweight=pop],  cluster(id)
    
esttab using AltSexCrime.tex, label se ar2 title(Alternative Sex Ratios) keep(lprovmf1625) addnote("") star(* 0.10 ** 0.05 *** 0.01) append
eststo clear

        eststo: reg  lcrime  $rhs90s  ,   cluster(id)
        eststo: xi: xtreg  lcrime  $rhs90s   , fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs90s  yd*  , fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs90s  yd*  $rhs2 , fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs90s  yd*  $rhs2 $rhs3 , fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs90s  yd* t* $rhs2 $rhs3 , fe  cluster(id)
    
esttab using AltSexCrime.tex, label se ar2 title(Alternative Sex Ratios) keep(lmf90x1625) addnote("") star(* 0.10 ** 0.05 *** 0.01) append
eststo clear
    	

        eststo: reg  lcrime  $rhs90s [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs90s pd* [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs90s pd* yd* [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs90s pd* yd*  $rhs2 [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs90s pd* yd*  $rhs2 $rhs3 [fweight=pop],  cluster(id)
        eststo: reg  lcrime  $rhs90s pd* yd* t* $rhs2 $rhs3 [fweight=pop],  cluster(id)

esttab using AltSexCrime.tex, label se ar2 title(Alternative Sex Ratios) keep(lmf90x1625) addnote("") star(* 0.10 ** 0.05 *** 0.01) append
eststo clear   
    
	
        eststo: reg  lcrime  $rhs90s  if big4==0,   cluster(id)
        eststo: xi: xtreg  lcrime  $rhs90s   if big4==0, fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs90s  yd*  if big4==0, fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs90s  yd*  $rhs2 if big4==0, fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs90s  yd*  $rhs2 $rhs3 if big4==0, fe  cluster(id)
        eststo: xi: xtreg  lcrime  $rhs90s  yd* t* $rhs2 $rhs3 if big4==0, fe  cluster(id)

esttab using AltSexCrime.tex, label se ar2 title(Alternative Sex Ratios) keep(lmf90x1625) addnote("") star(* 0.10 ** 0.05 *** 0.01) append
eststo clear
    	
     
        eststo: reg  lcrime  $rhs90s  [fweight=pop]if big4==0,  cluster(id)
        eststo: reg  lcrime  $rhs90s pd* [fweight=pop]if big4==0,  cluster(id)
        eststo: reg  lcrime  $rhs90s pd* yd* [fweight=pop]if big4==0,  cluster(id)
        eststo: reg  lcrime  $rhs90s pd* yd*  $rhs2 [fweight=pop]if big4==0,  cluster(id)
        eststo: reg  lcrime  $rhs90s pd* yd*  $rhs2 $rhs3 [fweight=pop]if big4==0,  cluster(id)
        eststo: reg  lcrime  $rhs90s pd* yd* t* $rhs2 $rhs3 [fweight=pop]if big4==0,  cluster(id)
    
esttab using AltSexCrime.tex, label se ar2 title(Alternative Sex Ratios) keep(lmf90x1625) addnote("") star(* 0.10 ** 0.05 *** 0.01)  append
eststo clear


********************************************************************************************

* Table IV in Appendix B: Sex Ratios and Crime - Falsification and Specification Checks

********************************************************************************************

        eststo: xi: xtreg lcorruption  $rhs00w           yd*  t* $rhs2 $rhs3 , fe cluster(id)                                                         
        eststo: xi: xtreg lcrime   lmfw1015              yd*  t* $rhs2 $rhs3 , fe cluster(id)                                              
        eststo: xi: xtreg lcrime   lmfw1625              yd*  t* $rhs2 $rhs3 , fe cluster(id)                                                 
        eststo: xi: xtreg lcrime   lmfw2645              yd*  t* $rhs2 $rhs3 , fe cluster(id)                                                
        eststo: xi: xtreg lcrime   lmfw4665              yd*  t* $rhs2 $rhs3 , fe cluster(id)                                             
        eststo: xi: xtreg lcrime   $rhs00bls             yd*  t* $rhs2 $rhs3 , fe cluster(id)                                              
        eststo: xi: xtreg lcrime   $rhs00bl              yd*  t* $rhs2 $rhs3 , fe cluster(id)
       
    
esttab using Robust.tex, label se ar2 /*
    */title(Sex Ratios and Crime -- Falsification and Specification Checks, OLS.) /*
    */keep(lmfw1015 lmfw1625 lmfw2645 lmfw4665 lbprovm1625 lbprovw1625)/*
    */addnote("Standard errors, in parentheses, clustered at the province level.")/*
    */star(* 0.10 ** 0.05 *** 0.01)/*
    */replace        
eststo clear      

        eststo:  reg lcorruption $rhs00w           yd* pd* t* $rhs2 $rhs3 [fweight=pop], cluster(id) 
        eststo:  reg lcrime   lmfw1015             yd* pd* t* $rhs2 $rhs3 [fweight=pop], cluster(id)
        eststo:  reg lcrime   lmfw1625             yd* pd* t* $rhs2 $rhs3 [fweight=pop], cluster(id)
        eststo:  reg lcrime   lmfw2645             yd* pd* t* $rhs2 $rhs3 [fweight=pop], cluster(id)
        eststo:  reg lcrime   lmfw4665             yd* pd* t* $rhs2 $rhs3 [fweight=pop], cluster(id)
        eststo:  reg lcrime   $rhs00bls            yd* pd* t* $rhs2 $rhs3 [fweight=pop], cluster(id)                                                      
        eststo:  reg lcrime   $rhs00bl             yd* pd* t* $rhs2 $rhs3 [fweight=pop], cluster(id)

esttab using Robust.tex, label se ar2 /*
   */title(Sex Ratios and Crime -- Falsification and Specification Checks, OLS.) /*
   */keep(lmfw1015 lmfw1625 lmfw2645 lmfw4665 lbprovm1625 lbprovw1625)/*
   */addnote("Standard errors, in parentheses, clustered at the province level.")/*
   */star(* 0.10 ** 0.05 *** 0.01)/*
   */append        
eststo clear         

********************************************************************************************
 
log close 

clear
