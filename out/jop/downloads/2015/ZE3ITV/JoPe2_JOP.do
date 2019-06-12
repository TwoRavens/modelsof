******************************************************************************
* "Fear of Crowds in WTO Disputes: Why DonÕt More Countries Participate?" *
* Leslie Johns and Krzysztof Pelc *
* Journal of Politics * 
* contact: kj.pelc@mcgill.ca
******************************************************************************

cd "[localpath]/JoPe2_replication_materials/"
use "JoPe2_crowds.dta", clear

set more off


*Table 1: Benefit of Participation on Exports

*1.1areg  log_imports_aggr thirdparty  trade_before_dispute gdp_resp_full   if complainant!=1 & partner!="ALL" & year>finalyear, abs(dispute_combined) cluster(dispute_combined)outtex, below plain digits(2) level legend details title(The Benefit of Third Party Participation 1.1) labels*1.2areg  log_imports_aggr thirdparty  trade_before_dispute gdp_resp_full ln_gdpcompl_full ruling_full  sum_proC if complainant!=1 & partner!="ALL" & year>finalyear, abs(respondent) cluster(dispute_combined)outtex, below plain digits(2) level legend details title(The Benefit of Third Party Participation 1.2) labels*1.3areg  growth_trade thirdparty  trade_before_dispute  gdp_resp_full ln_gdpcompl_full  if complainant!=1 & partner!="ALL" & year>finalyear, abs(dispute_combined) cluster(dispute_combined)outtex, below plain digits(2) level legend details title(The Benefit of Third Party Participation 1.3) labels


** Table 2:  Fear of Crowds: IV Model of Participation

*2.1
ivreg2 thirdparty  ( third_num_excl =  ln_ROW_before_disp  )  trade_before_dispute      if position!="complainant" & partner!="ALL" & startyear==year+1, robust ffirst
 estimates store model1

*2.2
ivreg2 thirdparty  ( third_num_excl =  ln_ROW_before_disp  ) ln_gdpk_partner ln_history_third ln_history_C Multilat trade_before_dispute  ARTICLEXXII    if position!="complainant" & partner!="ALL" & startyear==year+1 , robust ffirst
 estimates store model2

*2.3
ivreg2 thirdparty  ( third_num_excl =  ln_ROW_before_disp  ) ln_gdpk_partner ln_history_third ln_history_C Multilat trade_before_dispute  ARTICLEXXII   ln_sum_def_aid    if position!="complainant" & partner!="ALL" & startyear==year+1 , robust ffirst
 estimates store model3

*2.4
ivreg2 proCfull  (  sum_proC =  ln_ROW_before_disp  ) ln_gdpk_partner ln_history_third ln_history_C Multilat trade_before_dispute  ARTICLEXXII   ln_sum_def_aid    if position!="complainant" & partner!="ALL" & startyear==year+1 & ruling==1, robust ffirst
 estimates store model4

 esttab model1 model2 model3 model4 using pretty2.tex, cells(b(star fmt(%9.2f)) se(par fmt(%9.2f))) title(Fear of Crowds: IV Model of Participation \label{fear}) style(tex) compress legend varlabels(_cons Constant)   stats(N r2 rmse, fmt(0 2 3) label(N R-squared RMSE)) 

*substantive effect:
ivreg2 thirdparty  ( third_num_excl =  ln_ROW_before_disp  )  ln_gdpk_partner ln_history_third ln_history_C Multilat trade_before_dispute  ARTICLEXXII      if position!="complainant" & partner!="ALL" & startyear==year+1, robust ffirst
* at sample mean third number
margins, at ( (mean) _all   third_num_excl==  3.538587    ) 
margins, at ( (mean) _all   third_num_excl==  4.538587    ) 
di .1344435 -  .053505  
* 8% difference.

* for substantives, use ivprobit (note: unreliable errors, but OK for subst marginal effects)
    ivprobit thirdparty  ( third_num_excl =  ln_ROW_before_disp  )  trade_before_dispute      if position!="complainant" & partner!="ALL" & startyear==year+1, robust 
margins, at ( (mean) _all   third_num_excl==  3.538587   ) pr(pr)
margins, at ( (mean) _all   third_num_excl==  4.538587   ) pr(pr)
* also 8% difference.



* Figure 2: Average Trade Stake of Third Parties. 

* Let's graph the relationship between average third party stake and number of third parties. 

reg mean_3rd_stake1000   third_num, cluster(dispute_combined)
predict mean_3rd_stake_HAT
twoway bar mean_3rd_stake_HAT third_num if mean_3rd_stake_HAT>+0

* As per theoretical model, positive relationship between number of third parties and average third party stake. 


* Robustness

* Bown belief about retaliatory capacity vs partner exposure?:
ivreg2 thirdparty  ( third_num_excl =  ln_ROW_before_disp  ) ln_gdpk_partner ln_history_third ln_history_C Multilat trade_before_dispute  ARTICLEXXII   ln_sum_def_aid  partner_exposure retal_capacity  if position!="complainant" & partner!="ALL" & startyear==year+1 , robust ffirst

* Add a China indicator
ivreg2 thirdparty  ( third_num_excl =  ln_ROW_before_disp  ) ln_gdpk_partner ln_history_third ln_history_C Multilat trade_before_dispute  ARTICLEXXII   ln_sum_def_aid    chinadum if position!="complainant" & partner!="ALL" & startyear==year+1 , robust ffirst

* Add retaliation capacity + 3 year change prior to dispute start, on both third_num_excl and sum_proC: 
ivreg2 thirdparty  ( third_num_excl =  ln_ROW_before_disp  ) ln_gdpk_partner ln_history_third ln_history_C Multilat trade_before_dispute   ARTICLEXXII     retal_capacity  before3yr    if position!="complainant" & partner!="ALL"  , robust first
ivreg2 thirdparty  ( sum_proC =  ln_ROW_before_disp  ) ln_gdpk_partner ln_history_third ln_history_C Multilat trade_before_dispute   ARTICLEXXII     retal_capacity  before3yr    if position!="complainant" & partner!="ALL"  , robust first



********************************************

* Figure 3: Timing of Participation Decision *


use  "JoPe2_crowds_timing.dta" , clear

gen start= date(startdate , "DMY")
format start %td

forval z = 1/18 {
gen join`z'=date(conjoinreq`z'date, "DMY")
}
format join* %td


* correct Horn and Mavroidis on start date of DS239. 
replace start = date("21sept2001","DMY") if dsno== 239

* calculate distance
forval z = 1/18 {
gen dist`z'= join`z' - start
}


* correct DS174: two "starts" to the dispute, as US refiles for consultations. As a result, we get a negative distance on Canada's joining as third party after first false start. 
replace startdate = "4 April 2003" if dsno==174
replace start = date("04apr2003","DMY") if dsno==174
* and third party: 
replace dist1=. if dsno==174

* Figure 3
graph dot dist* paneldatedist  if  dist2!=. , over(dsno) legend(off) ndot(0) marker(1, msymbol(Oh)) marker(2, msymbol(Oh)) marker(3, msymbol(Oh)) marker(4, msymbol(Oh)) marker(5, msymbol(Oh)) marker(6, msymbol(Oh)) marker(7, msymbol(Oh)) marker(8, msymbol(Oh)) marker(9, msymbol(Oh)) marker(10, msymbol(Oh)) marker(11, msymbol(Oh)) marker(12, msymbol(Oh)) marker(13, msymbol(Oh)) marker(14, msymbol(Oh)) marker(15, msymbol(Oh)) marker(16, msymbol(Oh)) marker(17, msymbol(Oh)) marker(18, msymbol(Oh)) marker(19, msymbol(X))
 

* Supplementary test
* Relation between rush and number of countries with trade at stake:


* Calculate the average distance between two third parties joining in the same dispute:
gen intradist0 = join1-start

gen intradist1= join2-join1
gen intradist2= join3-join2
gen intradist3= join4-join3
gen intradist4= join5-join4
gen intradist5= join6-join5
gen intradist6= join7-join6
gen intradist7= join8-join7
gen intradist8= join9-join8
gen intradist9= join10-join9
gen intradist10= join11-join10
gen intradist11= join12-join11
gen intradist12= join13-join12
gen intradist13= join14-join13
gen intradist14= join15-join14
gen intradist15= join16-join5
gen intradist16= join17-join16
gen intradist17= join18-join17


* get average intradist by dispute (not counting the distance between start and first third party.)
egen mean_intradist=rowmean(intradist1 intradist2 intradist3 intradist4 intradist5 intradist6 intradist7 intradist8 intradist9 intradist10 intradist11 intradist12 intradist13 intradist14 intradist15 intradist16 intradist17)


* In text: 
* "The more countries have a substantive stake in the dispute (coded as more than 0.1\% of GDP in trade at stake in the year prior to the dispute), 
* the more clustered third party participation decisions become: knowing that others are more likely to join, states appear more eager to join before others do. 
* This relationship holds when we control for the total final number of third parties."
reg mean_intradist sum_tenthpercent, cluster(dispute)
reg mean_intradist sum_tenthpercent third_num, cluster(dispute)

*** end *** 
