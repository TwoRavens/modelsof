*****************************************************************************************
*********  This stata code replicates Tables 2 - 6 ; AND APPENDIX 1A 1B *****************
*********
*****************************************************************************************

clear
set mem 50m
set matsize 900
*set more off
log using Stata_results_CE, replace


cd "c:\data"

use "CE-data.dta", clear

**** VARIABLE LABELS (DETAILS ARE PROVIDED IN TABLE 1)**********

label variable ep "Future prices"
label variable pi_tm1 "Revised inflation"
label variable pi_tem1 "Incorrect inflation"
label variable unem_tm1  "Unemployment rate"
label variable male "Male"
label variable year_edu "Education"
label variable age "Age"
label variable partner "Partner"
label variable income "Income"
label variable nkids "Children"

************************************
* OTHER IMPORTANT VARIABLE LABELS:

label variable error "PubSig"
** error : "Difference between the incorrect inflation and the revised inflation" 

label variable pi_tm1food "Rev.Inf.Food"
** pi_tm1food: "Revised inflation of food products in CPI"  

label variable pi_tm2_food "Rev.Inf.Food_t-1"
** pi_tm2_food: "Revised inflation of food products in CPI during previous period "

label variable pi_tm2 "Rev.Inf.t-1"
** pi_tm2: "Revised inflation previous month"

label variable pi_tem2 "Incorrect inflation t-1"
** pi_tem2: "Incorrect inflation previous month"

label variable cpi_tm1 "Revised CPI"

label variable yymm "Year and month when survey was taken"
label variable ciudad "City code where responden resides. 1 corresponds to Cuenca; 9 to Guayaquil; 17 to Quito"
label variable rot_17 "Nominal savings ($); 4==ZERO; 1==[1-100]; 2==[100-500]; AND 3==[500+]."

* NOTE THAT: if the household is interviewed in month "t", pi_tm1 and related variables refer to the previous month (t-1)
* Please, see data section in paper for details.

***************************************************************** 

**** DESCRIPTIVE STATISTICS (TABLE 2) ****************************

* NOTE THAT DEPENDENT VARIABLE OF INTEREST HAS MISSING VALUES (-99)
* EP==1 IF RESPONDENT THINKS PRICES WILL INCREASE WITHIN NEXT YEAR
* EP==0 IF RESPONDENT THINKS PRICES WILL STAY THE SAME OR DECREASE
* EP==-99 FOR MISSING VALUES
* MISSING VALUES: 1% OF CASES
drop if ep==-99


tabstat ep pi_tm1 pi_tem1 unem_tm1 male year_edu age  partner  income nkids if yymm<=200602, stats(mean sd n) c(s) 
tabstat ep pi_tm1 pi_tem1 unem_tm1 male year_edu age  partner  income nkids if yymm==200603, stats(mean sd n) c(s) 

******************************************************************


**** REGRESSION RESULTS (TABLE 3) ****************************

* WE NEED TO GENERATE CITY AND TIME FIXED EFFECTS
tab ciudad,gen(city)
tab yymm, gen(m)

global ffee "city1 city3 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12"

* WE NEED TO ESTIMATE LOG(INCOME); NOTICE THAT WE ESTIMATE LINCOME=LOG(INCOME + 1)
* AND DEFINE THE SET OF HOUSEHOLD DEMOGRAPHIC CHARACTERISTICS IN THE REGRESSION

gen lincome=log(income+1)
label variable lincome "Log Income"
global xx "year_edu male age lincome nkids   partner  "


* WE ALSO NEED TO GENERATE INTERACTION TERMS BETWEEN THE "ERROR" AND THE HOUSEHOLD DEMOGRAPHIC CHARACTERISTICS

gen interactedu=year_edu*error
label variable interactedu "PubSig * Education"
gen interactm=error*male
label variable interactm "PubSig * Male"
gen interactage=error*age
label variable interactage "PubSig * Age"
gen interactincome=error*lincome
label variable interactincome "PubSig * Log Income"

global inter_xx "interactedu interactm interactage interactincome "

* TO CLUSTER STANDARD ERRORS AT THE CITY-MONTH LEVEL, WE NEED TO CREATE AN INDICATOR OF CITY-MONTH STATUS (city_mes)

gen ncity=0
replace ncity=1 if ciudad==1
replace ncity=2 if ciudad==9
replace ncity=3 if ciudad==17
gen city_mes=(ncity*1000000+yymm)


* THIS ARE THE REGRESSIONS NEEDED TO COMPUTE TABLE NUMBER 3:

qui dprobit   ep  error $ffee  , robust
estimates store m1
qui dprobit   ep  error $ffee  , vce(cluster city_mes)
estimates store m1c

qui dprobit   ep  error unem_tm1 $ffee  , robust
estimates store m2
qui dprobit   ep  error unem_tm1 $ffee  , vce(cluster city_mes)
estimates store m2c

qui dprobit   ep  error unem_tm1 pi_tm1 $ffee  , robust
estimates store m3
qui dprobit   ep  error unem_tm1 pi_tm1 $ffee  , vce(cluster city_mes)
estimates store m3c

qui dprobit   ep  error unem_tm1 pi_tm1  $xx $ffee  , robust
estimates store m4
qui dprobit   ep  error unem_tm1 pi_tm1  $xx $ffee  , vce(cluster city_mes)
estimates store m4c

qui dprobit   ep  error unem_tm1 pi_tm1  $inter_xx $xx $ffee  , robust
estimates store m5
qui dprobit   ep  error unem_tm1 pi_tm1  $inter_xx $xx $ffee  , vce(cluster city_mes)
estimates store m5c

** THIS IS TABLE 3 WITH ROBUST STANDARD ERRORS
#delimit ;
estout m1 m2 m3 m4 m5, cells(b(star fmt(%9.4f))  se(par fmt(%9.4f))) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("TABLE 3 , ROBUST STANDARD ERRORS") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr

** THIS IS TABLE 3 WITH CLUSTERED STANDARD ERRORS
#delimit ;
estout m1c m2c m3c m4c m5c, cells(b(star fmt(%9.4f))  se(par fmt(%9.4f))) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("TABLE 3 , CLUSTERED STANDARD ERRORS") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr


************************** TABLES 4A AND 4B ****************************************
**** ROBUSTNESS CHECKS ***************** *******************************************
**** 	BEFORE REGRESSIONS CAN BE RUN, ONE NEEDS TO COMPUTE THE FOLLOWING VARIABLES

gen trendfood=pi_tm1food-pi_tm2_food
label variable trendfood "Delta Rev.Inf. Food"
gen trend=pi_tm1-pi_tm2
label variable trend "Delta Rev.Inf. "
gen trend_e=pi_tem1-pi_tem2
label variable trend "Delta Incorr.Inf. "
gen error_tm1=pi_tem2-pi_tm2
label variable error_tm1 "PubSig t-1"
gen derror=error-error_tm1
label variable derror "Delta PubSig"


********************** TABLE 4A ******************************************************

* COL1: BASELINE
qui dprobit   ep  error pi_tm1 unem_tm1 $xx $ffee  , robust
estimates store m1
qui dprobit   ep  error pi_tm1 unem_tm1 $xx $ffee  , vce(cluster city_mes)
estimates store m1c

* COL2: FOOD REVISED INFLATION (pi_tm1food) INSTEAD OF OVERALL REVISED INFLATION (pi_tm1)
qui dprobit   ep  error pi_tm1food  unem_tm1 $xx $ffee  , robust
estimates store m2
qui dprobit   ep  error pi_tm1food  unem_tm1 $xx $ffee  , vce(cluster city_mes)
estimates store m2c

* COL3: ADDING TRENDS IN REVISED FOOD INFLATION TO MODEL (2) 

qui dprobit   ep  error pi_tm1food  trendfood unem_tm1 $xx $ffee  , robust
estimates store m3
qui dprobit   ep  error pi_tm1food  trendfood unem_tm1 $xx $ffee  , vce(cluster city_mes)
estimates store m3c

* COL4: CONTROLLING FOR TRENDS IN REVISED OVERALL INFLATION 

qui dprobit   ep  error pi_tm1  trend unem_tm1 $xx $ffee  , robust
estimates store m4
qui dprobit   ep  error pi_tm1  trend unem_tm1 $xx $ffee  , vce(cluster city_mes)
estimates store m4c

* COL5: ADDING CHANGES IN THE INCORRECT PUBLIC SIGNAL (derror) TO BASELINE

qui dprobit   ep  error  derror pi_tm1  unem_tm1 $xx $ffee  , robust
estimates store m5
qui dprobit   ep  error  derror pi_tm1  unem_tm1 $xx $ffee  , vce(cluster city_mes)
estimates store m5c

* COL6: ADDING CHANGES IN THE REVISED INFLATION (trend) TO MODEL (5)

qui dprobit   ep  error  derror pi_tm1  trend pi_tm1  unem_tm1 $xx $ffee  , robust
estimates store m6
qui dprobit   ep  error  derror pi_tm1  trend pi_tm1  unem_tm1 $xx $ffee  , vce(cluster city_mes)
estimates store m6c

*****************************************************************************************
** THIS IS TABLE 4a WITH ROBUST STANDARD ERRORS
#delimit ;
estout m1 m2 m3 m4 m5 m6, cells(b(star fmt(%9.4f))  se(par fmt(%9.4f))) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("TABLE 4a , ROBUST STANDARD ERRORS") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr

** THIS IS TABLE 4a WITH CLUSTERED STANDARD ERRORS
#delimit ;
estout m1c m2c m3c m4c m5c m6c, cells(b(star fmt(%9.4f))  se(par fmt(%9.4f))) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("TABLE 4a , CLUSTERED STANDARD ERRORS") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr



********************** TABLE 4B ******************************************************
* HERE WE ADD INTERACTION TERMS TO TABLE 4A *****************************************

* COL1: BASELINE
qui dprobit   ep  error pi_tm1 unem_tm1 $inter_xx $xx $ffee  , robust
estimates store m1
qui dprobit   ep  error pi_tm1 unem_tm1 $inter_xx $xx $ffee  , vce(cluster city_mes)
estimates store m1c

* COL2: FOOD REVISED INFLATION (pi_tm1food) INSTEAD OF OVERALL REVISED INFLATION (pi_tm1)
qui dprobit   ep  error pi_tm1food  unem_tm1 $inter_xx $xx $ffee  , robust
estimates store m2
qui dprobit   ep  error pi_tm1food  unem_tm1 $inter_xx $xx $ffee  , vce(cluster city_mes)
estimates store m2c

* COL3: ADDING TRENDS IN REVISED FOOD INFLATION TO MODEL (2) 

qui dprobit   ep  error pi_tm1food  trendfood unem_tm1 $inter_xx $xx $ffee  , robust
estimates store m3
qui dprobit   ep  error pi_tm1food  trendfood unem_tm1 $inter_xx $xx $ffee  , vce(cluster city_mes)
estimates store m3c

* COL4: CONTROLLING FOR TRENDS IN REVISED OVERALL INFLATION 

qui dprobit   ep  error pi_tm1  trend unem_tm1 $inter_xx $xx $ffee  , robust
estimates store m4
qui dprobit   ep  error pi_tm1  trend unem_tm1 $inter_xx $xx $ffee  , vce(cluster city_mes)
estimates store m4c

* COL5: ADDING CHANGES IN THE INCORRECT PUBLIC SIGNAL (derror) TO BASELINE

qui dprobit   ep  error  derror pi_tm1  unem_tm1 $inter_xx $xx $ffee  , robust
estimates store m5
qui dprobit   ep  error  derror pi_tm1  unem_tm1 $inter_xx $xx $ffee  , vce(cluster city_mes)
estimates store m5c

* COL6: ADDING CHANGES IN THE REVISED INFLATION (trend) TO MODEL (5)

qui dprobit   ep  error  derror pi_tm1  trend pi_tm1  unem_tm1 $inter_xx $xx $ffee  , robust
estimates store m6
qui dprobit   ep  error  derror pi_tm1  trend pi_tm1  unem_tm1 $inter_xx $xx $ffee  , vce(cluster city_mes)
estimates store m6c

*****************************************************************************************
** THIS IS TABLE 4b WITH ROBUST STANDARD ERRORS
#delimit ;
estout m1 m2 m3 m4 m5 m6, cells(b(star fmt(%9.4f))  se(par fmt(%9.4f))) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("TABLE 4b , ROBUST STANDARD ERRORS") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr

** THIS IS TABLE 4b WITH CLUSTERED STANDARD ERRORS
#delimit ;
estout m1c m2c m3c m4c m5c m6c, cells(b(star fmt(%9.4f))  se(par fmt(%9.4f))) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("TABLE 4b , CLUSTERED STANDARD ERRORS") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr



*****************************************************************************************


*************** TABLE 5 ****************************************************************

* WE FOCUS ON SAVINGS (rot_17)
* THE QUESTION ASKS THE HEAD OF THE HOUSEHOLD ABOUT THE HOUSEHOLD MONTHLY SAVINGS
* ANSWERS ARE RECORDED IN $ AND ARE REPORTED IN CATEGORICAL FORM: 4==ZERO; 1==[1-100]; 2==[100-500]; AND 3==[500+].

* NOMINAL SAVINGS
gen save1=0 if rot_17==4
replace save1=50 if rot_17==1
replace save1=300 if rot_17==2
replace save1=750 if rot_17==3

* REAL SAVINGS
gen save1r=100*save1/cpi_tm1

* LET US USE MODEL IN TABLE 3 (COL5) TO ESTIMATE THE PREDICTED PROBABILITY THAT RESPONDENTS THINK PRICES WILL INCREASE (EP_HAT)


qui dprobit ep  error unem_tm1 pi_tm1  $inter_xx $xx $ffee  , robust
predict ep_h  
gen ep_hat=ep_h*100
label variable ep_hat "Predicted Prices


* THESE ARE THE TWO REGRESSIONS WE CARE ABOUT (NOTICE THAT STANDARD ERRORS NEED TO BE ADJUSTED BECAUSE EP_HAT IS A PREDICTED VALUE)

* COEFFICIENT ESTIMATES FOR TABLE 5:
qui reg save1 ep_hat cpi_tm1 unem_tm1   $xx $ffee  , robust
estimates store m1
qui reg save1r ep_hat unem_tm1          $xx $ffee  , robust
estimates store m2



** THIS IS TABLE 5: COEF. ONLY!
#delimit ;
estout m1 m2, cells(b(star fmt(%9.4f))  ) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("TABLE 5 , COEFFICIENTS ONLY") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr




* THESE APPROXIMATIONS ARE USED TO COMPUTE STANDARD ERRORS IN TABLE 5 
gen ep100=ep*100

qui ivregress  2sls save1 cpi_tm1 unem_tm1   $xx $ffee (ep100=ep_hat)  , robust
estimates store m1
qui ivregress  2sls save1 cpi_tm1 unem_tm1   $xx $ffee (ep100=ep_hat)  , vce(cluster city_mes)
estimates store m1c

qui ivregress  2sls save1r unem_tm1   $xx $ffee (ep100=ep_hat)  , robust
estimates store m2
qui ivregress  2sls save1r unem_tm1   $xx $ffee (ep100=ep_hat)  , vce(cluster city_mes)
estimates store m2c



** THIS IS TABLE 5: ROBUST SE ONLY!
#delimit ;
estout m1 m2, cells(se(par fmt(%9.4f))  ) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("TABLE 5 , ROBUST SE ") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr



** THIS IS TABLE 5: CLUSTERED SE ONLY!
#delimit ;
estout m1c m2c, cells(se(par fmt(%9.4f))  ) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("TABLE 5 , CLUSTERED SE ") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr








**********************************************************************************************************************

******** APPENDIX 1a AND 1b ***************************************************************************

* THESE ARE THE REGRESSIONS SHOWN IN APPENDIX 1a (LINEAR PROBABILITY)

qui reg   ep  error $ffee  , robust
estimates store m1
qui reg   ep  error $ffee  , vce(cluster city_mes)
estimates store m1c

qui reg   ep  error unem_tm1 $ffee  , robust
estimates store m2
qui reg   ep  error unem_tm1 $ffee  , vce(cluster city_mes)
estimates store m2c

qui reg   ep  error unem_tm1 pi_tm1 $ffee  , robust
estimates store m3
qui reg   ep  error unem_tm1 pi_tm1 $ffee  , vce(cluster city_mes)
estimates store m3c

qui reg   ep  error unem_tm1 pi_tm1  $xx $ffee,robust
estimates store m4
qui reg   ep  error unem_tm1 pi_tm1  $xx $ffee, vce(cluster city_mes)
estimates store m4c

qui reg   ep  error unem_tm1 pi_tm1  $inter_xx $xx $ffee,  robust
estimates store m5
qui reg   ep  error unem_tm1 pi_tm1  $inter_xx $xx $ffee, vce(cluster city_mes)
estimates store m5c


** THIS IS APPENDIX 1A WITH ROBUST STANDARD ERRORS
#delimit ;
estout m1 m2 m3 m4 m5, cells(b(star fmt(%9.4f))  se(par fmt(%9.4f))) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("APPENDIX 1A , ROBUST STANDARD ERRORS") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr

** THIS IS APPENDIX 1A WITH CLUSTERED STANDARD ERRORS
#delimit ;
estout m1c m2c m3c m4c m5c, cells(b(star fmt(%9.4f))  se(par fmt(%9.4f))) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("APPENDIX 1A , CLUSTERED STANDARD ERRORS") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr




* THESE ARE THE REGRESSIONS SHOWN IN APPENDIX 1b (LOGIT)

qui logit   ep  error $ffee  , robust
qui mfx compute
estimates store m1
qui logit   ep  error $ffee  , vce(cluster city_mes)
qui mfx compute
estimates store m1c

qui logit   ep  error unem_tm1 $ffee  , robust
qui mfx compute
estimates store m2
qui logit   ep  error unem_tm1 $ffee  , vce(cluster city_mes)
qui mfx compute
estimates store m2c

qui logit   ep  error unem_tm1 pi_tm1 $ffee  , robust
qui mfx compute
estimates store m3
qui logit   ep  error unem_tm1 pi_tm1 $ffee  , vce(cluster city_mes)
qui mfx compute
estimates store m3c

qui logit   ep  error unem_tm1 pi_tm1  $xx $ffee  , robust
qui mfx compute
estimates store m4
qui logit   ep  error unem_tm1 pi_tm1  $xx $ffee  , vce(cluster city_mes)
qui mfx compute
estimates store m4c

qui logit   ep  error unem_tm1 pi_tm1  $inter_xx $xx $ffee  , robust
qui mfx compute
estimates store m5
qui logit   ep  error unem_tm1 pi_tm1  $inter_xx $xx $ffee  , vce(cluster city_mes)
qui mfx compute
estimates store m5c

** THIS IS APPENDIX 1B WITH ROBUST STANDARD ERRORS
#delimit ;
estout m1 m2 m3 m4 m5, cells(b(star fmt(%9.4f))  se(par fmt(%9.4f))) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("APPENDIX 1B , ROBUST STANDARD ERRORS") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr

** THIS IS APPENDIX 1B WITH CLUSTERED STANDARD ERRORS
#delimit ;
estout m1c m2c m3c m4c m5c, cells(b(star fmt(%9.4f))  se(par fmt(%9.4f))) margin 
       legend label collabels(, none)
       style(fixed)  stats(N,fmt(%9.0g) ) drop($ffee) 
       varlabels(_cons Constant)  varwidth(20) 
       prehead ("APPENDIX 1B , CLUSTERED STANDARD ERRORS") posthead ("") prefoot("") postfoot("")  
       starlevels(* 0.10 ** 0.05 *** 0.01);
#delimit cr


*************************************************************************************************
log close