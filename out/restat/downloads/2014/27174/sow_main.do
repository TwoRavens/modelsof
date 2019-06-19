* Date: July 3,2012

clear 
clear matrix
set mem 100m
set more 1
cap log close

log using sow_main.log,replace

use sow_data_2013oct

  
******************************************
**Table 2: Basic Summary Statistics
* Overall Summary statistics

sum sow0 sow1 sow2 pig  pop_regist pop_migout age_vil edu_vil male_vil land  lhouse_val surname_vil no_xnh subsidy    insuredpig snow sow3 sow4 

 
* Summary Statistics by Experimental Group

sort group
 
by group: sum sow0 sow1 sow2 pig  pop_regist pop_migout age_vil edu_vil male_vil land  lhouse_val surname_vil no_xnh subsidy    insuredpig snow sow3 sow4 


foreach var of varlist sow0 sow1 sow2 pig  pop_regist pop_migout age_vil edu_vil male_vil land  lhouse_val surname_vil no_xnh subsidy    insuredpig snow sow3 sow4 {
reg `var' groupd1 groupd2 groupd3,nocon
test groupd1=groupd2=groupd3
}



***** Note 1: Following a referee's comment, we use robust standard error for all regressions in the main text 
******In our earlier versions, we used robust standard errors clustered at the township level.
*****Note 2: We corrected some small coding errors in our original data which led to our current results slightly different from
******from our earlier versions.

**Table3: OLS Regression Results on the Relationship between Sow Insurance and Subsequent Sow Production.


reg sow3 insuredpig ,robust  


reg sow3 insuredpig towndummy* ,robust  


reg sow3 insuredpig sow0 towndummy* ,robust  


reg sow4 insuredpig ,robust  

reg sow4 insuredpig towndummy* ,robust  


reg sow4 insuredpig sow0 towndummy*  ,robust  

**********************************************

****Table4 The Effect of Incentive Group Assignments on Subsequent Sow Production: Reduced-Form Results.

reg sow3 groupd2 groupd3 towndummy* ,robust  

reg sow3 groupd2 groupd3 sow0 towndummy* ,robust 

reg sow4 groupd2 groupd3 towndummy* ,robust  

reg sow4 groupd2 groupd3 sow0 towndummy* ,robust 

***********************************************
****Table 5: The Effect of Group Assignments on the Number of Insured Sows: First-Stage Results

reg insuredpig groupd2 groupd3  ,robust  

reg insuredpig groupd2 groupd3 towndummy* ,robust  

reg insuredpig groupd2 groupd3 sow0 towndummy*  ,robust   


************************************************
****Table 6 : IV Regression Results on the Effect of Sow Insurance on Subsequent Sow Production.
****************

ivreg sow3 ( insuredpig= groupd2-groupd3 ) ,robust  

ivreg sow3 ( insuredpig= groupd2-groupd3 )  towndummy*  ,robust  

 
ivreg sow3 ( insuredpig= groupd2-groupd3 ) sow0 towndummy* ,robust  

ivreg sow4 ( insuredpig= groupd2-groupd3 )  ,robust  
  
ivreg sow4 ( insuredpig= groupd2-groupd3 )  towndummy* ,robust  

ivreg sow4 ( insuredpig= groupd2-groupd3 ) sow0 towndummy* ,robust  

************************************************
***Table 7: IV Estimates of the Longer-run Effects of Sow Insurance on Sow and Pig Production and the Spillover Effects on Other Livestocks (Sheep and Cows)
***use newly collected data in 2013---newdata_original
sort villageid
save,replace
clear
use newdata_original
merge 1:1 villageid using sow_data_2013oct
***************************************************  
***average
gen sow200810=(sow3+sow2009+sow2010)/3
gen pig200810=(pig2008+pig2009+pig2010)/3
 
ivreg sow2009  ( insuredpig=groupd2 groupd3) sow0  towndummy*  ,robust
ivreg sow2010  ( insuredpig=groupd2 groupd3) sow0  towndummy*  ,robust
ivreg sow200810  ( insuredpig=groupd2 groupd3) sow0  towndummy*  ,robust
 
ivreg pig2009  ( insuredpig=groupd2 groupd3) pig  towndummy*  ,robust
ivreg pig2010  ( insuredpig=groupd2 groupd3) pig  towndummy*  ,robust
ivreg pig200810  ( insuredpig=groupd2 groupd3) pig  towndummy*  ,robust
 
 
ivreg sheep2008  ( insuredpig=groupd2 groupd3)goat    towndummy*  ,robust  
 
ivreg cow2008  ( insuredpig=groupd2 groupd3) cow   towndummy*  ,robust
 

 
log close
clear





