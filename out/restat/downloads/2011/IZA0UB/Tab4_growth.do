program drop _all

/* THIS PROGRAM IMPLEMENTS GROWTH REGRESSIONS IN TABLE 5 (cols.1-5), where the MAIN SPECIFICATION(=TOBIT col.5)
   USED IN OTHER TABLES IS SHOWN FIRST.

   NOTE: 
   - All the source and results files are saved at single directory: C:\RESTAT\
   - This program and data were written such that all can be run IC STATA-ver. 10.1. 
   - HOWEVER, original results run in earlier ver. STATA 7 (thus potential differences in some decimals 
     due to software updates or roundings may occur) */
  

program define GROWTH
clear all
set more off
set memory 90m
set matsize 800
use C:\RESTAT\data1.dta, replace
log using C:\RESTAT\Tab4_growth.log, replace                     


                       tsset firm year

#delimit ;            
                  

/* KEEP ONLY OBS W/ NON-MISSING REGRESSORS */
                   
                    keep if growth~=. & FG~=. & ageT~=. & sales~=. & AS~=. & ES~=. & FORdirect~=. &
                          intang~=. & ESgap~=. & gap~=. & solvency~=. ;


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

    
                    tsset firm year ;


                 
/* NOTE: full set of regional(reg1-reg8), industry*trend and year dummies included; thus some will be dropped 
         to avoid multicollinearity */

/* ******************* MAIN SPECIFICATION USED IN FOLLOWING TABLES=TOBIT=Tab4(col. 5) **************** */

  display" SHOW MAIN SPECIFICATION USED IN FOLLOWING TABLES=TOBIT=Tab4(col. 5) FIRST";
                                          
/* TOBIT - Tab 5, col. 5 */;
                
                  xi:tobit growth FG STATIC ageT ageT2 sales sales2 AS ES FORdirect intang gap ESgap 
                                    D89 solvency NO_FOR year94-year00 i.primaryu*trend reg1-reg8                                   
                                    konkurz liquidate both OUT_BR                                
                                    avFG avageT avageT2 avsales avsales2 avAS avES avFORdirect avintang 
                                    avgap avESgap avsolvency,ll(-1);
                                                    

/* TOBIT - Tab 5, col. 4 */;
                
                  xi:tobit growth FG STATIC ageT ageT2 sales sales2 AS ES FORdirect intang gap ESgap 
                                    D89 solvency year94-year00 i.primaryu*trend reg1-reg8                                   
                                    konkurz liquidate both OUT_BR                                
                                    avFG avageT avageT2 avsales avsales2 avAS avES avFORdirect avintang 
                                    avgap avESgap avsolvency,ll(-1);




 /* *********************************** FE - Table 4 (col.1) ***************** */


/* FE - Tab 5, col. 1 (region & exit-type dummies droped)*/;                 
                 
                   xi:xtreg growth FG STATIC ageT ageT2 sales sales2 AS ES FORdirect intang gap ESgap 
                                   D89 solvency year94-year00 i.primaryu*trend,fe i(firm);
                

 /* *********************************** RE - Table 4 (col.2) ***************** */
             
/* Tab 5, col. 2 - RE */;
                
                 xi:xtreg growth FG STATIC ageT ageT2 sales sales2 AS ES FORdirect intang gap ESgap 
                                    D89 solvency year94-year00 i.primaryu*trend reg1-reg8                                   
                                    konkurz liquidate both OUT_BR                                    
                                    avFG avageT avageT2 avsales avsales2 avAS avES avFORdirect avintang 
                                    avgap avESgap avsolvency, re i(firm);

    
 /* *********************************** GEE - Table 4 (col.3) ***************** */
                

/* Tab 5, col. 3 - GEE*/;
                
                xi:xtgee growth FG STATIC ageT ageT2 sales sales2 AS ES FORdirect intang gap ESgap 
                      D89 solvency year94-year00 i.primaryu*trend reg1-reg8                        
                      konkurz liquidate both OUT_BR
                      avFG avageT avageT2 avsales avsales2 avAS avES avFORdirect avintang 
                      avgap avESgap avsolvency,i(firm) t(year) corr(unstr) robust nolog ;



#delimit cr
log close
end
