program drop _all

/* THIS PROGRAM IMPLEMENTS SURVIVAL-LogNormal Model REGRESSION IN TABLE 5 (col.4) - IC-STATA ver. 10.1.
   NOTE: 
   - This specification uses the full exit sample (even when DOMgrowth) is missing.
   - All the source and results files are saved at single directory: C:\RESTAT\*/
  

program define DUR
clear all
set more off
set memory 90m
set matsize 800
use C:\RESTAT\data1.dta, replace
log using C:\RESTAT\Tab5_survival_col4.log, replace                     


                       tsset firm year

#delimit ;            
                    display" In case of 2 observations IndG missing, because data on sales in year 1994 missing";
                    display" Replace 2 obs. by IndG==0";
                    replace IndG=0 if primaryu==175 & year==1994;      

/* KEEP ONLY OBS W/ NON-MISSING REGRESSORS */                                       
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
                                                    
             

          /* gen firm level means */
                   
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
                 
                     
                    tsset firm year ;
                 

                                       

/* TO AVOID PERFECT FAILURE/SUCCESS DETERMINATION PROBLEM RE-GROUP DUMMIES - APPLY RE-GROUPINGS FROM TAB4 FIRST */

                    display" GROUP YEAR DUMMIES INTO 2 YEARS (94+95), (96+97), WHERE PERFECT FAIULRE DETERM. PROBLEM";
                    replace year94=1 if (year==1994|year==1995);
                    replace year97=1 if (year==1996|year==1997);
                    replace year00=1 if (year==2000|year==2001);
                    drop year95 year96 ; /* 2 years when perfect failure determination " */
                    /* so now yearly dummies are: 94,97, 98, 99,00 */            
                 

                 
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
 

 /* SET DATA FOR DURATION ANALYSIS */
                    
                    gen MAT=MIN_ageT-1 ;
                    stset ageT, id(firm) failure(EI==1) entry(MAT) ; 
                   

/* ************************* LOGNORMAL SURVIVAL MODEL Tab 5 (co 4)- THIS SPECIFIC. USES THE FULL EXIT SAMPLE ********** */

/* 1: Tab5, col. 4 */

               xi:streg FG STATIC DOMENTRY sales sales2 ES FORdirect intang gap ESgap D89 solvency NO_FOR IndG 
                          year94-year00 i.primaryu reg1-reg7
                          avFG avsales avsales2 avES avFORdirect avintang 
                          avgap avESgap avsolvency,dist(lnormal) cluster(firm) tr;
             

#delimit cr
log close
end
