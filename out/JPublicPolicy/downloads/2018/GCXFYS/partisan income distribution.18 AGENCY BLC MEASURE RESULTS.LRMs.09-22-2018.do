* OPEN STATA OUTPUT FILE LOG

   log using "F:\JPP FINAL DOCUMENTS\JPP Data Replication Materials\SUPPLEMENTARY ANALYSES\SECTION 3\partisan income distribution.18 AGENCY BLC MEASURE RESULTS.09-22-2018.smcl" 




 **** STATISTICAL CODE FOR REGRESSIONS BASED ON ABBREVIATED COMMON SET OF 18 STATE EXECUTIVE AGENCIES [AS OPPOSED TO 35 COMMON AGENCIES COVERED IN THE BLC MEASURE REPORTED IN THE MANUSCRIPT] *****


 
 

 * OPEN "INCOME DISTRIBUTION" DATA SET
 
use "F:\JPP FINAL DOCUMENTS\JPP Data Replication Materials\TABLE 1 & FIGURES 4-6\partisan income distribution.09-22-2018.dta", clear


set matsize 11000


set more off
 
xtset stateno year, yearly


**********************************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************************
**********************************************************************************************************************************************************************************************************
*********************************************************************************************************************


 
*** SET TIME SERIES - CROSS SECTION IDENTIFER ***

tsset stateno year, yearly

*
*
*
*


***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************




** I.1:  CHANGES IN AVERAGE REAL ADJUSTED GROSS INCOME [SOMMELLIER & PRICE 2014] -- FOR TOP 0.01% = 99.999 - 100.00 FRACTILE:  ARDL(1,1) MODEL SPECIFICATION [TWO-WAY FIXED EFFECTS: TIMEWISE FIXED EFFECTS]; 
**       TESTING FOR PARTIAL PARTISAN CONTROL EFFECTS [SHORT-RUN/IMMEDIATE & LONG-RUN/DYNAMIC] & FULL PARTISAN CONTROL [TOTAL] ** 



*** ESTIMATE VIA OLS [TWO-WAY FIXED EFFECTS TO CONTROL FOR BOTH STATE AND YEAR UNOBSERVED HETEROGENEITY AND STANDARD ERRORS CLUSTERED BY STATE] ***

xtreg P9999x100  l1.P9999x100   l1.rmbs18  l1.allreprev2 l1.alldemrev2 l1.burprof18allreprev2 l1.burprof18alldemrev2   ///
l1.rmbs18sq  l1.burprof18sqallreprev2     ///
l1.rinc l1.MTR_total_s_reed l1.shnfinc l1.citi8608  i.year , fe cluster(stateno)

estat ic

*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************


*** MINIMUM VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPEV2 & ALLDEMREV2, REPSECTIVELY: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***
*** PLEASE NOTE THAT ONLY IMMEDIATE EFFECT IS CAPTURED SINCE THE DYNAMIC BASELINE FOR THE TOTAL EFFECT IS THE SAME ACROSS ALL LINEAR COMBINATIONS *** 
*

nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*57766.13 +  _b[l1.burprof18sqallreprev2]*(57766.13)^2) /  (1 -_b[l1.P9999x100])
*
nlcom  (_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*56267.54) /  (1 -_b[l1.P9999x100])
*
*
*
nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*57766.13 +  _b[l1.burprof18sqallreprev2]*(57766.13)^2) / (1 -_b[l1.P9999x100])  - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*56267.54) /  (1 -_b[l1.P9999x100]))



*** 10TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPEV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*65507.67 +  _b[l1.burprof18sqallreprev2]*(65507.67)^2) /  (1 -_b[l1.P9999x100])
*
nlcom  (_b[l1.alldemrev2] +  _b[l1.burprof18alldemrev2]*70949.12) /  (1 -_b[l1.P9999x100])
*
*
*
nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*65507.67 +  _b[l1.burprof18sqallreprev2]*(65507.67)^2) /  (1 -_b[l1.P9999x100])  - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*70949.12) /  (1 -_b[l1.P9999x100]))

 

*** 25TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***


*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*72261.70 +  _b[l1.burprof18sqallreprev2]*(72261.70)^2) / (1 -_b[l1.P9999x100]) 
*
nlcom  (_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*78440.5) /  (1 -_b[l1.P9999x100])
*
*
*
nlcom (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*72261.70 +  _b[l1.burprof18sqallreprev2]*(72261.70)^2) /  (1 -_b[l1.P9999x100])  - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*78440.5) /  (1 -_b[l1.P9999x100]))



*** 50TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE  ***

*
nlcom  (_b[l1.allreprev2]  + _b[l1.burprof18allreprev2]*79073.75  +  _b[l1.burprof18sqallreprev2]*(79073.75)^2) /  (1 -_b[l1.P9999x100])
*
nlcom  (_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*87427.63) /  (1 -_b[l1.P9999x100]) 
*
*
*
nlcom  (_b[l1.allreprev2]  + _b[l1.burprof18allreprev2]*79073.75 +  _b[l1.burprof18sqallreprev2]*(79073.75)^2) /  (1 -_b[l1.P9999x100])  - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*87427.63) /  (1 -_b[l1.P9999x100]))




*** 75TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*95241.91 +  _b[l1.burprof18sqallreprev2]*(95241.91)^2)  /  (1 -_b[l1.P9999x100])
*
nlcom  (_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*98287.50) /  (1 -_b[l1.P9999x100])
*
*
*
nlcom (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*95241.91 + _b[l1.burprof18sqallreprev2]*(95241.91)^2) /  (1 -_b[l1.P9999x100])  - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*98287.50) /  (1 -_b[l1.P9999x100]))




*** 90TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*103982 +  _b[l1.burprof18sqallreprev2]*(103982)^2) /  (1 -_b[l1.P9999x100])
*
nlcom  (_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*107475) /  (1 -_b[l1.P9999x100]) 
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*103982 +  _b[l1.burprof18sqallreprev2]*(103982)^2) /  (1 -_b[l1.P9999x100])   - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*107475)  /  (1 -_b[l1.P9999x100]))
*



*** MAXIMUM VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*113451.30 +  _b[l1.burprof18sqallreprev2]*(113451.30)^2)  /  (1 -_b[l1.P9999x100])
*
nlcom  (_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*126358)  /  (1 -_b[l1.P9999x100])
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*113451.30  +  _b[l1.burprof18sqallreprev2]*(113451.30)^2) /  (1 -_b[l1.P9999x100])  - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*126358) /  (1 -_b[l1.P9999x100]))  
*  




  
  
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************



** I.2:  CHANGES IN AVERAGE REAL ADJUSTED GROSS INCOME [SOMMELLIER & PRICE 2014] -- FOR TOP 0.1% -- 0.01% = 99.90 - 99.99 FRACTILE::  ARDL(1,1) MODEL SPECIFICATION [TWO-WAY FIXED EFFECTS: TIMEWISE FIXED EFFECTS]; 
**       TESTING FOR PARTIAL PARTISAN CONTROL EFFECTS  ** 

*** PLEASE NOTE THAT ONLY IMMEDIATE EFFECT IS CAPTURED SINCE THE DYNAMIC BASELINE FOR THE TOTAL EFFECT IS THE SAME ACROSS ALL LINEAR COMBINATIONS *** 


*** ESTIMATE VIA OLS [TWO-WAY FIXED EFFECTS TO CONTROL FOR BOTH STATE AND YEAR UNOBSERVED HETEROGENEITY AND STANDARD ERRORS CLUSTERED BY STATE] ***

xtreg P999x9999  l1.P999x9999   l1.rmbs18  l1.allreprev2 l1.alldemrev2 l1.burprof18allreprev2 l1.burprof18alldemrev2   ///
l1.rmbs18sq    l1.burprof18sqalldemrev2      ///
l1.rinc l1.MTR_total_s_reed l1.shnfinc l1.citi8608  i.year , fe cluster(stateno)

estat ic

*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************


*** MINIMUM VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***
*** PLEASE NOTE THAT ONLY IMMEDIATE EFFECT IS CAPTURED SINCE THE DYNAMIC BASELINE FOR THE TOTAL EFFECT IS THE SAME ACROSS ALL LINEAR COMBINATIONS *** 
*

nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*57766.13) /  (1 -_b[l1.P999x9999])
*
nlcom  (_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*56267.54 + _b[l1.burprof18sqalldemrev2]*(56267.54)^2) /  (1 -_b[l1.P999x9999])
*
*
*
nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*57766.13) /  (1 -_b[l1.P999x9999])  - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*56267.54 + _b[l1.burprof18sqalldemrev2]*(56267.54)^2) /  (1 -_b[l1.P999x9999]))



*** 10TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*65507.67) /  (1 -_b[l1.P999x9999])
*
*
nlcom  (_b[l1.alldemrev2]  +  _b[l1.burprof18alldemrev2]*70949.12 + _b[l1.burprof18sqalldemrev2]*(70949.12)^2)  /  (1 -_b[l1.P999x9999])
*
*
*
nlcom (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*65507.67) /  (1 -_b[l1.P999x9999]) - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*70949.12 + _b[l1.burprof18sqalldemrev2]*(70949.12)^2) /  (1 -_b[l1.P999x9999]))

 

*** 25TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***


*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*72261.70) /  (1 -_b[l1.P999x9999])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*78440.5 + _b[l1.burprof18sqalldemrev2]*(78440.5)^2) /  (1 -_b[l1.P999x9999]) 
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*72261.70) /  (1 -_b[l1.P999x9999])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*78440.5 + _b[l1.burprof18sqalldemrev2]*(78440.5)^2) /  (1 -_b[l1.P999x9999]))



*** 50TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE  ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*79073.75) /  (1 -_b[l1.P999x9999])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*87427.63 + _b[l1.burprof18sqalldemrev2]*(87427.63)^2) /  (1 -_b[l1.P999x9999])
*
*
*
nlcom  (_b[l1.allreprev2]  + _b[l1.burprof18allreprev2]*79073.75) /  (1 -_b[l1.P999x9999])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*87427.63 + _b[l1.burprof18sqalldemrev2]*(87427.63)^2) /  (1 -_b[l1.P999x9999]))




*** 75TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*95241.91) /  (1 -_b[l1.P999x9999])  
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*98287.50 + _b[l1.burprof18sqalldemrev2]*(98287.50)^2)  /  (1 -_b[l1.P999x9999]) 
*
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*95241.91) /  (1 -_b[l1.P999x9999])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*98287.50 + _b[l1.burprof18sqalldemrev2]*(98287.50)^2) /  (1 -_b[l1.P999x9999]))




*** 90TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*103982)  /  (1 -_b[l1.P999x9999])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*107475 + _b[l1.burprof18sqalldemrev2]*(107475)^2) /  (1 -_b[l1.P999x9999])
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*103982) /  (1 -_b[l1.P999x9999])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*107475 + _b[l1.burprof18sqalldemrev2]*(107475)^2) /  (1 -_b[l1.P999x9999]))
*



*** MAXIMUM VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*113451.30) /  (1 -_b[l1.P999x9999])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*126358  + _b[l1.burprof18sqalldemrev2]*(126358)^2)  /  (1 -_b[l1.P999x9999])
*
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*113451.30)  /  (1 -_b[l1.P999x9999])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*126358  + _b[l1.burprof18sqalldemrev2]*(126358)^2) /  (1 -_b[l1.P999x9999])) 
*  


 
  


  
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************



** I.3:  CHANGES IN AVERAGE REAL ADJUSTED GROSS INCOME [SOMMELLIER & PRICE 2014] -- FOR TOP 0.5% -- 0.1% = 99.5 - 99.9 FRACTILE::  ARDL(1,1) MODEL SPECIFICATION [TWO-WAY FIXED EFFECTS: TIMEWISE FIXED EFFECTS]; 
**       TESTING FOR PARTIAL PARTISAN CONTROL EFFECTS  ** 

*** PLEASE NOTE THAT ONLY IMMEDIATE EFFECT IS CAPTURED SINCE THE DYNAMIC BASELINE FOR THE TOTAL EFFECT IS THE SAME ACROSS ALL LINEAR COMBINATIONS *** 


*** ESTIMATE VIA OLS [TWO-WAY FIXED EFFECTS TO CONTROL FOR BOTH STATE AND YEAR UNOBSERVED HETEROGENEITY AND STANDARD ERRORS CLUSTERED BY STATE] ***

xtreg P995x999  l1.P995x999   l1.rmbs18  l1.allreprev2 l1.alldemrev2 l1.burprof18allreprev2 l1.burprof18alldemrev2   ///
l1.rmbs18sq   l1.burprof18sqalldemrev2      ///
l1.rinc l1.MTR_total_s_reed l1.shnfinc l1.citi8608  i.year , fe cluster(stateno)

estat ic

*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************


*
*** MINIMUM VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***
*** PLEASE NOTE THAT ONLY IMMEDIATE EFFECT IS CAPTURED SINCE THE DYNAMIC BASELINE FOR THE TOTAL EFFECT IS THE SAME ACROSS ALL LINEAR COMBINATIONS *** 
*

nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*57766.13) /  (1 -_b[l1.P995x999])
*
nlcom  (_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*56267.54 + _b[l1.burprof18sqalldemrev2]*(56267.54)^2) /  (1 -_b[l1.P995x999])
*
*
*
nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*57766.13) /  (1 -_b[l1.P995x999])  - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*56267.54 + _b[l1.burprof18sqalldemrev2]*(56267.54)^2) /  (1 -_b[l1.P995x999]))



*** 10TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*65507.67) /  (1 -_b[l1.P995x999])
*
*
nlcom  (_b[l1.alldemrev2]  +  _b[l1.burprof18alldemrev2]*70949.12 + _b[l1.burprof18sqalldemrev2]*(70949.12)^2)  /  (1 -_b[l1.P995x999])
*
*
*
nlcom (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*65507.67) /  (1 -_b[l1.P995x999]) - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*70949.12 + _b[l1.burprof18sqalldemrev2]*(70949.12)^2) /  (1 -_b[l1.P995x999]))

 

*** 25TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***


*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*72261.70) /  (1 -_b[l1.P995x999])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*78440.5 + _b[l1.burprof18sqalldemrev2]*(78440.5)^2) /  (1 -_b[l1.P995x999]) 
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*72261.70) /  (1 -_b[l1.P995x999])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*78440.5 + _b[l1.burprof18sqalldemrev2]*(78440.5)^2) /  (1 -_b[l1.P995x999]))



*** 50TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE  ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*79073.75) /  (1 -_b[l1.P995x999])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*87427.63 + _b[l1.burprof18sqalldemrev2]*(87427.63)^2) /  (1 -_b[l1.P995x999])
*
*
*
nlcom  (_b[l1.allreprev2]  + _b[l1.burprof18allreprev2]*79073.75) /  (1 -_b[l1.P995x999])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*87427.63 + _b[l1.burprof18sqalldemrev2]*(87427.63)^2) /  (1 -_b[l1.P995x999]))




*** 75TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*95241.91) /  (1 -_b[l1.P995x999])  
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*98287.50 + _b[l1.burprof18sqalldemrev2]*(98287.50)^2)  /  (1 -_b[l1.P995x999]) 
*
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*95241.91) /  (1 -_b[l1.P995x999])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*98287.50 + _b[l1.burprof18sqalldemrev2]*(98287.50)^2) /  (1 -_b[l1.P995x999]))




*** 90TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*103982)  /  (1 -_b[l1.P995x999])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*107475 + _b[l1.burprof18sqalldemrev2]*(107475)^2) /  (1 -_b[l1.P995x999])
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*103982) /  (1 -_b[l1.P995x999])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*107475 + _b[l1.burprof18sqalldemrev2]*(107475)^2) /  (1 -_b[l1.P995x999]))
*



*** MAXIMUM VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*113451.30) /  (1 -_b[l1.P995x999])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*126358  + _b[l1.burprof18sqalldemrev2]*(126358)^2)  /  (1 -_b[l1.P995x999])
*
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*113451.30)  /  (1 -_b[l1.P995x999])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*126358  + _b[l1.burprof18sqalldemrev2]*(126358)^2) /  (1 -_b[l1.P995x999])) 
*  




*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************



** I.4:  CHANGES IN AVERAGE REAL ADJUSTED GROSS INCOME [SOMMELLIER & PRICE 2014] -- FOR TOP 1% -- 0.5% = 99 - 99.5 FRACTILE::  ARDL(1,1) MODEL SPECIFICATION [TWO-WAY FIXED EFFECTS: TIMEWISE FIXED EFFECTS]; 
**       TESTING FOR PARTIAL PARTISAN CONTROL EFFECTS  ** 

*** PLEASE NOTE THAT ONLY IMMEDIATE EFFECT IS CAPTURED SINCE THE DYNAMIC BASELINE FOR THE TOTAL EFFECT IS THE SAME ACROSS ALL LINEAR COMBINATIONS *** 


*** ESTIMATE VIA OLS [TWO-WAY FIXED EFFECTS TO CONTROL FOR BOTH STATE AND YEAR UNOBSERVED HETEROGENEITY AND STANDARD ERRORS CLUSTERED BY STATE] ***

xtreg P99x995  l1.P99x995   l1.rmbs18  l1.allreprev2 l1.alldemrev2 l1.burprof18allreprev2 l1.burprof18alldemrev2   ///
l1.rmbs18sq   l1.burprof18sqalldemrev2      ///
l1.rinc l1.MTR_total_s_reed l1.shnfinc l1.citi8608  i.year , fe cluster(stateno)

estat ic

*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************

*

*** MINIMUM VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV22, REPSECTIVELY: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***
*** PLEASE NOTE THAT ONLY IMMEDIATE EFFECT IS CAPTURED SINCE THE DYNAMIC BASELINE FOR THE TOTAL EFFECT IS THE SAME ACROSS ALL LINEAR COMBINATIONS *** 
*

nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*57766.13) /  (1 -_b[l1.P99x995])
*
nlcom  (_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*56267.54 + _b[l1.burprof18sqalldemrev2]*(56267.54)^2) /  (1 -_b[l1.P99x995])
*
*
*
nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*57766.13) /  (1 -_b[l1.P99x995])  - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*56267.54 + _b[l1.burprof18sqalldemrev2]*(56267.54)^2) /  (1 -_b[l1.P99x995]))



*** 10TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*65507.67) /  (1 -_b[l1.P99x995])
*
*
nlcom  (_b[l1.alldemrev2]  +  _b[l1.burprof18alldemrev2]*70949.12 + _b[l1.burprof18sqalldemrev2]*(70949.12)^2)  /  (1 -_b[l1.P99x995])
*
*
*
nlcom (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*65507.67)  /  (1 -_b[l1.P99x995]) - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*70949.12 + _b[l1.burprof18sqalldemrev2]*(70949.12)^2) /  (1 -_b[l1.P99x995]))

 

*** 25TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***


*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*72261.70) /  (1 -_b[l1.P99x995])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*78440.5 + _b[l1.burprof18sqalldemrev2]*(78440.5)^2) /  (1 -_b[l1.P99x995]) 
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*72261.70) /  (1 -_b[l1.P99x995])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*78440.5 + _b[l1.burprof18sqalldemrev2]*(78440.5)^2) /  (1 -_b[l1.P99x995]))



*** 50TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE  ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*79073.75) /  (1 -_b[l1.P99x995])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*87427.63 + _b[l1.burprof18sqalldemrev2]*(87427.63)^2) /  (1 -_b[l1.P99x995])
*
*
*
nlcom  (_b[l1.allreprev2]  + _b[l1.burprof18allreprev2]*79073.75) /  (1 -_b[l1.P99x995])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*87427.63 + _b[l1.burprof18sqalldemrev2]*(87427.63)^2) /  (1 -_b[l1.P99x995]))




*** 75TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*95241.91) /  (1 -_b[l1.P99x995])  
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*98287.50 + _b[l1.burprof18sqalldemrev2]*(98287.50)^2)  /  (1 -_b[l1.P99x995]) 
*
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*95241.91) /  (1 -_b[l1.P99x995])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*98287.50 + _b[l1.burprof18sqalldemrev2]*(98287.50)^2) /  (1 -_b[l1.P99x995]))




*** 90TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*103982)  /  (1 -_b[l1.P99x995])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*107475 + _b[l1.burprof18sqalldemrev2]*(107475)^2) /  (1 -_b[l1.P99x995])
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*103982) /  (1 -_b[l1.P99x995])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*107475 + _b[l1.burprof18sqalldemrev2]*(107475)^2) /  (1 -_b[l1.P99x995]))
*



*** MAXIMUM VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*113451.30) /  (1 -_b[l1.P99x995])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*126358  + _b[l1.burprof18sqalldemrev2]*(126358)^2)  /  (1 -_b[l1.P99x995])
*
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*113451.30)  /  (1 -_b[l1.P99x995])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*126358  + _b[l1.burprof18sqalldemrev2]*(126358)^2) /  (1 -_b[l1.P99x995])) 
*  




*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************





** I.5:  CHANGES IN AVERAGE REAL ADJUSTED GROSS INCOME [SOMMELLIER & PRICE 2014] -- FOR TOP 5% -- 1% = 95 - 99 FRACTILE::  ARDL(1,1) MODEL SPECIFICATION [TWO-WAY FIXED EFFECTS: TIMEWISE FIXED EFFECTS]; 
**       TESTING FOR PARTIAL PARTISAN CONTROL EFFECTS  ** 

*** PLEASE NOTE THAT ONLY IMMEDIATE EFFECT IS CAPTURED SINCE THE DYNAMIC BASELINE FOR THE TOTAL EFFECT IS THE SAME ACROSS ALL LINEAR COMBINATIONS *** 



*** ESTIMATE VIA OLS [TWO-WAY FIXED EFFECTS TO CONTROL FOR BOTH STATE AND YEAR UNOBSERVED HETEROGENEITY AND STANDARD ERRORS CLUSTERED BY STATE] ***

xtreg P95x99  l1.P95x99   l1.rmbs18  l1.allreprev2 l1.alldemrev2 l1.burprof18allreprev2 l1.burprof18alldemrev2   ///
l1.rmbs18sq   l1.burprof18sqalldemrev2      ///
l1.rinc l1.MTR_total_s_reed l1.shnfinc l1.citi8608  i.year , fe cluster(stateno)

estat ic

*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************



*** MINIMUM VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***
*** PLEASE NOTE THAT ONLY IMMEDIATE EFFECT IS CAPTURED SINCE THE DYNAMIC BASELINE FOR THE TOTAL EFFECT IS THE SAME ACROSS ALL LINEAR COMBINATIONS *** 
*


nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*57766.13) /  (1 -_b[l1.P95x99])
*
nlcom  (_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*56267.54 + _b[l1.burprof18sqalldemrev2]*(56267.54)^2) /  (1 -_b[l1.P95x99])
*
*
*
nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*57766.13) /  (1 -_b[l1.P95x99])  - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*56267.54 + _b[l1.burprof18sqalldemrev2]*(56267.54)^2) /  (1 -_b[l1.P95x99]))



*** 10TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*65507.67) /  (1 -_b[l1.P95x99])
*
*
nlcom  (_b[l1.alldemrev2]  +  _b[l1.burprof18alldemrev2]*70949.12 + _b[l1.burprof18sqalldemrev2]*(70949.12)^2)  /  (1 -_b[l1.P95x99])
*
*
*
nlcom (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*65507.67)  /  (1 -_b[l1.P95x99]) - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*70949.12 + _b[l1.burprof18sqalldemrev2]*(70949.12)^2) /  (1 -_b[l1.P95x99]))

 

*** 25TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***


*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*72261.70) /  (1 -_b[l1.P95x99])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*78440.5 + _b[l1.burprof18sqalldemrev2]*(78440.5)^2) /  (1 -_b[l1.P95x99]) 
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*72261.70) /  (1 -_b[l1.P95x99])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*78440.5 + _b[l1.burprof18sqalldemrev2]*(78440.5)^2) /  (1 -_b[l1.P95x99]))



*** 50TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE  ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*79073.75) /  (1 -_b[l1.P95x99])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*87427.63 + _b[l1.burprof18sqalldemrev2]*(87427.63)^2) /  (1 -_b[l1.P95x99])
*
*
*
nlcom  (_b[l1.allreprev2]  + _b[l1.burprof18allreprev2]*79073.75) /  (1 -_b[l1.P95x99])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*87427.63 + _b[l1.burprof18sqalldemrev2]*(87427.63)^2) /  (1 -_b[l1.P95x99]))




*** 75TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*95241.91) /  (1 -_b[l1.P95x99])  
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*98287.50 + _b[l1.burprof18sqalldemrev2]*(98287.50)^2)  /  (1 -_b[l1.P95x99]) 
*
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*95241.91) /  (1 -_b[l1.P95x99])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*98287.50 + _b[l1.burprof18sqalldemrev2]*(98287.50)^2) /  (1 -_b[l1.P95x99]))




*** 90TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*103982)  /  (1 -_b[l1.P95x99])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*107475 + _b[l1.burprof18sqalldemrev2]*(107475)^2) /  (1 -_b[l1.P95x99])
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*103982) /  (1 -_b[l1.P95x99])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*107475 + _b[l1.burprof18sqalldemrev2]*(107475)^2) /  (1 -_b[l1.P95x99]))
*



*** MAXIMUM VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*113451.30) /  (1 -_b[l1.P95x99])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*126358  + _b[l1.burprof18sqalldemrev2]*(126358)^2)  /  (1 -_b[l1.P95x99])
*
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*113451.30)  /  (1 -_b[l1.P95x99])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*126358  + _b[l1.burprof18sqalldemrev2]*(126358)^2) /  (1 -_b[l1.P95x99])) 
*  


  
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************



** I.6:  CHANGES IN AVERAGE REAL ADJUSTED GROSS INCOME [SOMMELLIER & PRICE 2014] -- FOR TOP 10% -- 5% = 90 - 95 FRACTILE::  ARDL(1,1) MODEL SPECIFICATION [TWO-WAY FIXED EFFECTS: TIMEWISE FIXED EFFECTS]; 
**       TESTING FOR PARTIAL PARTISAN CONTROL EFFECTS  ** 

*** PLEASE NOTE THAT ONLY IMMEDIATE EFFECT IS CAPTURED SINCE THE DYNAMIC BASELINE FOR THE TOTAL EFFECT IS THE SAME ACROSS ALL LINEAR COMBINATIONS *** 



*** ESTIMATE VIA OLS [TWO-WAY FIXED EFFECTS TO CONTROL FOR BOTH STATE AND YEAR UNOBSERVED HETEROGENEITY AND STANDARD ERRORS CLUSTERED BY STATE] ***

xtreg P90x95  l1.P90x95   l1.rmbs18  l1.allreprev2 l1.alldemrev2 l1.burprof18allreprev2 l1.burprof18alldemrev2   ///
l1.rmbs18sq   l1.burprof18sqalldemrev2      ///
l1.rinc l1.MTR_total_s_reed l1.shnfinc l1.citi8608  i.year , fe cluster(stateno)

estat ic

*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
*

*** MINIMUM VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***
*** PLEASE NOTE THAT ONLY IMMEDIATE EFFECT IS CAPTURED SINCE THE DYNAMIC BASELINE FOR THE TOTAL EFFECT IS THE SAME ACROSS ALL LINEAR COMBINATIONS *** 
*


nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*57766.13) /  (1 -_b[l1.P90x95])
*
nlcom  (_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*56267.54 + _b[l1.burprof18sqalldemrev2]*(56267.54)^2) /  (1 -_b[l1.P90x95])
*
*
*
nlcom  (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*57766.13) /  (1 -_b[l1.P90x95])  - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*56267.54 + _b[l1.burprof18sqalldemrev2]*(56267.54)^2) /  (1 -_b[l1.P90x95]))



*** 10TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*65507.67) /  (1 -_b[l1.P90x95])
*
*
nlcom  (_b[l1.alldemrev2]  +  _b[l1.burprof18alldemrev2]*70949.12 + _b[l1.burprof18sqalldemrev2]*(70949.12)^2)  /  (1 -_b[l1.P90x95])
*
*
*
nlcom (_b[l1.allreprev2] +  _b[l1.burprof18allreprev2]*65507.67)  /  (1 -_b[l1.P90x95]) - ((_b[l1.alldemrev2] + _b[l1.burprof18alldemrev2]*70949.12 + _b[l1.burprof18sqalldemrev2]*(70949.12)^2) /  (1 -_b[l1.P90x95]))

 

*** 25TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***


*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*72261.70) /  (1 -_b[l1.P90x95])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*78440.5 + _b[l1.burprof18sqalldemrev2]*(78440.5)^2) /  (1 -_b[l1.P90x95]) 
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*72261.70) /  (1 -_b[l1.P90x95])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*78440.5 + _b[l1.burprof18sqalldemrev2]*(78440.5)^2) /  (1 -_b[l1.P90x95]))



*** 50TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE  ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*79073.75) /  (1 -_b[l1.P90x95])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*87427.63 + _b[l1.burprof18sqalldemrev2]*(87427.63)^2) /  (1 -_b[l1.P90x95])
*
*
*
nlcom  (_b[l1.allreprev2]  + _b[l1.burprof18allreprev2]*79073.75) /  (1 -_b[l1.P90x95])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*87427.63 + _b[l1.burprof18sqalldemrev2]*(87427.63)^2) /  (1 -_b[l1.P90x95]))




*** 75TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*95241.91) /  (1 -_b[l1.P90x95])  
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*98287.50 + _b[l1.burprof18sqalldemrev2]*(98287.50)^2)  /  (1 -_b[l1.P90x95]) 
*
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*95241.91) /  (1 -_b[l1.P90x95])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*98287.50 + _b[l1.burprof18sqalldemrev2]*(98287.50)^2) /  (1 -_b[l1.P90x95]))




*** 90TH PERCENTILE VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*103982)  /  (1 -_b[l1.P90x95])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*107475 + _b[l1.burprof18sqalldemrev2]*(107475)^2) /  (1 -_b[l1.P90x95])
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*103982) /  (1 -_b[l1.P90x95])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*107475 + _b[l1.burprof18sqalldemrev2]*(107475)^2) /  (1 -_b[l1.P90x95]))
*



*** MAXIMUM VALUES OF BUREAUCRATIC LEADERSHIP CAPACITY  FOR ALLREPREV2 & ALLDEMREV2, REPSECTIVELY [IMMEDIATE EFFECT ONLY]: DIVIDED PARTISAN CONTROL IS "ZERO" BASELINE ***

*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*113451.30) /  (1 -_b[l1.P90x95])
*
nlcom  (_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*126358  + _b[l1.burprof18sqalldemrev2]*(126358)^2)  /  (1 -_b[l1.P90x95])
*
*
*
*
nlcom  (_b[l1.allreprev2] + _b[l1.burprof18allreprev2]*113451.30)  /  (1 -_b[l1.P90x95])  - ((_b[l1.alldemrev2]  + _b[l1.burprof18alldemrev2]*126358  + _b[l1.burprof18sqalldemrev2]*(126358)^2) /  (1 -_b[l1.P90x95])) 
*  





***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
*******************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************
***********************************************************************************************************************************************************************************************************


*
*
*
*
*
*
*
*
*
*


***** CLOSE STATA OUTPUT LOG *****

log close






