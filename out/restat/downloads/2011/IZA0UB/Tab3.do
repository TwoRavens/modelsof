program drop _all

/* THIS PROGRAM SHOWS SUMMARY STATISTICS FOR GROWTH & EXIT SAMPLES AS IN TABLE 3;  IC-STATA ver. 10.1.
   NOTE: All the source and results files are saved at single directory: C:\RESTAT\  */


program define GROWTH
clear all
set more off
set memory 80m
set matsize 800
use C:\RESTAT\data1.dta, replace
log using C:\RESTAT\Tab3.log, replace 
                      
                  
             tsset firm year

#delimit;            


     display" In case of 2 observations IndG missing, because data on sales in year 1994 missing";
                    display"Replace 2 obs. by IndG==0";
                    replace IndG=0 if primaryu==175 & year==1994;      

                   
/* KEEP ONLY OBS W/ NON-MISSING REGRESSORS IN LARGER EXIT SAMPLE 24733 OBS*/
                    keep if EI~=. & FG~=. & IndG~=. & ageT~=. & sales~=. & AS~=.& ES~=.& FORdirect~=. &
                          intang~=. & ESgap~=. & gap~=. & solvency~=. ; 
 


/* CREATE DUMMY=1 WHENEVER DOM ENTRY RATE>0 (ANALOGICALLY WITH FORentry variable named as "STATIC" in data) */
                   

           /* gen OTHER_ENTRANTS1 */
                   display" GENERATE OTHER_ENTRANTS1 BY SUBTRACTING 1 IF THE FIRM IS OF AGE=1";
                   gen OTHER_ENTRANTS1=ENTRANTS1;
                   replace OTHER_ENTRANTS1=ENTRANTS1-1 if age==1;
                   replace OTHER_ENTRANTS1=0 if OTHER_ENTRANTS1<0;
                

          /* gen dummy for DOMENTRY */
                    gen DOMENTRY=1 if  OTHER_ENTRANTS1>0;
                    replace DOMENTRY=0 if OTHER_ENTRANTS1==0;

                                                    
/* CREATE CROSS EFFECTS cl/ncl analogically with FORentry-cl/ncl */


                    /* CROSS EFFECT CLASSIFIED FIRMS */
                    gen DOMENTRYcl=DOMENTRY if NCL==0;
                    replace DOMENTRYcl=0 if DOMENTRYcl==. ;

                    /* CROSS EFFECT non-CLASSIFIED FIRMS */
                    gen DOMENTRYncl=DOMENTRY if NCL==1;
                    replace DOMENTRYncl=0 if DOMENTRYncl==. ;


/* GEN CROSS EFFECTS DG cl/ncl */
                    gen DGcl=DG if NCL==0;
                    replace DGcl=0 if DGcl==. ;

                    gen DGncl=DG if NCL==1;
                    replace DGncl=0 if DGncl==. ;
                 


/* ********************** SHOW FIRST SUMSTAT FOR LARGER EXIT SAMPLE - TABLE 3 *********************** */

                  display" SUMSTAT FOR EXIT SAMPLE - 24733 OBS";  

/* SUM */

display" HOW MANY DOMESTIC FIRMS WE HAVE IN EXIT SAMPLE?";
count if firm[_n]~=firm[_n-1];

display"HOW MANY EXITS WE HAVE?";
count if EI==1;

sum EI FG FGclass FGncl STATIC STATICcl STATICncl ageT ageT2 sales sales2 AS ES FORdirect intang gap ESgap 
    D89 solvency NO_FOR IndG DOMENTRY DOMENTRYcl DOMENTRYncl;

                               

/* ************************** SHOW SUMSTAT FOR A SMALLER GROWTH SAMPLE - TABLE 3 ************************ */

                 display" SUMSTAT FOR GROWTH SAMPLE - 20462 OBS"; 
                 keep if DG~=.; 

/* SUM */

display"HOW MANY DOMESTIC FIRMS WE HAVE IN GROWTH SAMPLE?";
count if firm[_n]~=firm[_n-1];

display"HOW MANY EXITS WE HAVE?";
count if EI==1;

sum growth FG FGclass FGncl STATIC STATICcl STATICncl ageT ageT2 sales sales2 AS ES FORdirect intang gap ESgap 
    D89 solvency NO_FOR DOMENTRY DOMENTRYcl DOMENTRYncl DG DGcl DGncl;


#delimit cr                               
log close
end
