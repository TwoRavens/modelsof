program drop _all

/* THIS PROGRAM IMPLEMENTS SURVIVAL REGRESSIONS IN TABLE 5 (cols.6-8), where the MAIN SPECIFICATION(=LOGNORMAL col.7)
   USED IN OTHER TABLES IS SHOWN FIRST.

   NOTE: 
   - All the source and results files are saved at single directory: C:\RESTAT\
   - This program and data were written such that all can be run IC STATA-ver. 10.1. 
   - HOWEVER, original results run in earlier ver. STATA 7 (thus potential differences in some decimals 
     due to software updates or roundings may occur) */

program define DUR
clear all
set more off
set memory 90m
set matsize 800
use C:\RESTAT\data1.dta, replace
log using C:\RESTAT\Tab4_survival.log, replace

                       keep if FOR_all==0
                       tsset firm year

                    
  #delimit ;            
                    display" In case of 2 observations IndG missing, because data on sales in year 1994 missing";
                    display" Replace these by IndG==0";
                    replace IndG=0 if primaryu==175 & year==1994;      
  
/* KEEP ONLY OBS W/ NON-MISSING REGRESSORS */
                                 
                    display "KEEP THE ALL POSSIBLE OBS. FOR EXIT EVEN THOSE WHICH MISSING FOR GROWTH";                   
                    keep if EI~=. & FG~=. & ageT~=. & sales~=. & AS~=.& ES~=.& FORdirect~=. &
                          intang~=. & ESgap~=. & gap~=. & solvency~=. ; 

                   
                    sort firm ;
                    by firm: egen avsales=mean(sales);
                    by firm: egen avsales2=mean(sales2);
                    by firm: egen avESgap=mean(ESgap);
                    by firm: egen avFG=mean(FG);         
    
                    by firm: egen avageT=mean(ageT);
                    by firm: egen avageT2=mean(ageT2);
                    by firm: egen avAS=mean(AS);
                    by firm: egen avES=mean(ES);
                    by firm: egen avFORdirect=mean(FORdirect);
                    by firm: egen avintang=mean(intang);
                    by firm: egen avgap=mean(gap);
                    by firm: egen avsolvency=mean(solvency);
                    by firm: egen MIN_ageT=min(ageT);

                     tsset firm year;
  

                                               
/* TO AVOID PERFECT FAILURE/SUCCESS DETERMINATION PROBLEM RE-GROUP DUMMIES */

                    display" GROUP YEAR DUMMIES INTO 2 YEARS (94+95), (96+97), WHERE PERFECT FAIULRE DETERM. PROBLEM";
                    replace year94=1 if (year==1994|year==1995);
                    replace year97=1 if (year==1996|year==1997);
                    replace year00=1 if (year==2000|year==2001);
                    drop year95 year96 ; /* 2 years when perfect failure determination " */
                    /* so now yearly dummies are: 94,97, 98, 99,00 */
    
                   /* REGROUP INTO BIGGER GROUPS THE INDUSTRIES AS WELL*/

                   replace primaryu=16 if US2==16;
                   replace primaryu=17 if US2==17;
                   replace primaryu=203 if (primaryu==204|primaryu==205);
                   replace primaryu=208 if primaryu==209;
                   replace primaryu=22 if (US2==22|US2==23);
                   replace primaryu=24 if  US2==24;
                   replace primaryu=25 if  US2==25;
                   replace primaryu=26 if (US2==26|US2==27|US2==28);
                   replace primaryu=317 if (primaryu==322|primaryu==325|primaryu==326|
                                           primaryu==327|primaryu==328);
                   replace primaryu=332 if primaryu==333;
                   replace primaryu=343 if primaryu==344;
                   replace primaryu=345 if primaryu==346;
                   replace primaryu=351 if primaryu==352;
                   replace primaryu=361 if primaryu==362;
                   replace primaryu=363 if primaryu==364;
                   replace primaryu=374 if primaryu==375;
                   replace primaryu=38 if (US2==38|US2==39);
                   replace primaryu=47 if (primaryu==472|primaryu==481|primaryu==491|primaryu==493);
                   replace primaryu=505 if (primaryu==506|primaryu==507|primaryu==508);
                   replace primaryu=515 if primaryu==516;
                   replace primaryu=519 if primaryu==523;
                   replace primaryu=554 if (primaryu==571|primaryu==581);
                   replace primaryu=591 if (primaryu==593|primaryu==594);
                   replace primaryu=621 if primaryu==628;
                   replace primaryu=721 if primaryu==729;
                   replace primaryu=735 if primaryu==737;
                   replace primaryu=792 if (primaryu==794|primaryu==799);
 
/* SINCE WE INCLUDE IndG as CONTROL IN EXIT REGRESSIONS */             
                   keep if IndG~=.;

/* SET DATA FOR DURATION */
                    
                    /* USING AGE_T */
                    gen MAT=MIN_ageT-1 ;
                    stset ageT, id(firm) failure(EI==1) entry(MAT) ; 

 
                
/* Note: fix the regional dummies so they are not arbitratily dropped by software... */

/* ******************* MAIN SPECIFICATION USED IN OTHER TABLES=LOGNORMAL=Tab4(col. 7) **************** */

     display" SHOW MAIN SPECIFICATION USED IN FOLLOWING TABLES=LOGNORMAL=Tab4(col. 7) FIRST";


/* LOGNORMAL -  Tab4, col. 7 */              
               xi:streg FG STATIC sales sales2 ES FORdirect intang gap ESgap D89 solvency NO_FOR IndG year94-year00 
                          i.primaryu reg1-reg6
                          avFG avsales avsales2 avES avFORdirect avintang 
                          avgap avESgap avsolvency,dist(lnormal) cluster(firm) tr;
 


/* ************************* COX - Tab 5 (col.6) **************************************** */

               xi:stcox FG STATIC sales sales2 ES FORdirect intang gap ESgap D89 solvency NO_FOR IndG
                        year94-year00 i.primaryu reg1-reg6
                        avFG avsales avsales2 avES avFORdirect avintang avgap avESgap avsolvency, cluster(firm) efron ;
                        
                                        
            

/* ********************** PROBIT - Tab 5 (col.8) ************************************************* */
       

               xi:probit EI FG STATIC ageT ageT2 sales sales2 AS ES FORdirect intang gap ESgap 
                         D89 solvency NO_FOR IndG  year94-year00 i.primaryu reg1-reg6
                         avFG avsales avsales2 avES avFORdirect avintang avgap avESgap avsolvency, cluster(firm);
                        

                     
#delimit cr
log close
end
