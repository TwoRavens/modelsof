************************************************
* Table 5 Regression Models in Paper
************************************************
use "F:\CVS Projects\Macro\Final Results for Final Version of Paper\SAS and Stata Data\stata_logistic_final.dta", clear
logit retail_increase numberofskus_jul2010                                    prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth) 
margins, dydx(*)
logit retail_increase log_numberofskus_jul2010                                prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth)
margins, dydx(*)
regress retail_increase number2_3_jul2010 number4_6_jul2010  number7p_jul2010 prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce(cluster yearmonth)


************************************************
* Table 8 Cost Decrease Models
************************************************
use "F:\CVS Projects\Macro\Final Results for Final Version of Paper\SAS and Stata Data\stata_logistic_final.dta", clear
logistic retail_decrease numberofskus_jul2010 								  prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_decrease==1, vce (cluster yearmonth)
margins, dydx(*)
logistic retail_decrease log_numberofskus_jul2010 							  prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_decrease==1, vce (cluster yearmonth)
margins, dydx(*)
regress retail_decrease number2_3_jul2010 number4_6_jul2010  number7p_jul2010 prior_retail_99ending Pct_Cost_Change    priormargin log_priorunits seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_decrease==1, vce(cluster yearmonth)




************************************************
* Appendix
* Revenue Instead of Unit Volume
* Private Label
* Prior Price
************************************************

* Interaction with size of cost change
use "F:\CVS Projects\Macro\Final Results for Final Version of Paper\SAS and Stata Data\stata_logistic_final.dta", clear
generate int_costchange = numberofskus_jul2010*Pct_Cost_Change
logit retail_increase numberofskus_jul2010 int_costchange   				  prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth) 
margins, dydx(*)
generate logint_costchange = log_numberofskus_jul2010*Pct_Cost_Change
logit retail_increase log_numberofskus_jul2010 logint_costchange  			  prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth)
margins, dydx(*)


* Add Annual Cost Changes
use "F:\CVS Projects\Macro\Final Results for Final Version of Paper\SAS and Stata Data\stata_logistic_final.dta", clear
logit retail_increase numberofskus_jul2010                                    prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 annual_cost_changes year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth) 
margins, dydx(*)
logit retail_increase log_numberofskus_jul2010                                prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 annual_cost_changes year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth)
margins, dydx(*)
regress retail_increase number2_3_jul2010 number4_6_jul2010  number7p_jul2010 prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 annual_cost_changes year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce(cluster yearmonth)


* Add Annual Cost Increases
use "F:\CVS Projects\Macro\Final Results for Final Version of Paper\SAS and Stata Data\stata_logistic_final.dta", clear
logit retail_increase numberofskus_jul2010                                    prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 annual_cost_increases year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth) 
margins, dydx(*)
logit retail_increase log_numberofskus_jul2010                                prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 annual_cost_increases year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth)
margins, dydx(*)
regress retail_increase number2_3_jul2010 number4_6_jul2010  number7p_jul2010 prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 annual_cost_increases year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce(cluster yearmonth)


* Add Prior Retail Price
use "F:\CVS Projects\Macro\Final Results for Final Version of Paper\SAS and Stata Data\stata_logistic_final.dta", clear
logit retail_increase numberofskus_jul2010                                    prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 PRIOR_RETAIL year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth) 
margins, dydx(*)
logit retail_increase log_numberofskus_jul2010                                prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 PRIOR_RETAIL year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth)
margins, dydx(*)
regress retail_increase number2_3_jul2010 number4_6_jul2010  number7p_jul2010 prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 PRIOR_RETAIL year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce(cluster yearmonth)


* Revenue Instead of Unit Volume
use "F:\CVS Projects\Macro\Final Results for Final Version of Paper\SAS and Stata Data\stata_logistic_final.dta", clear
logit retail_increase numberofskus_jul2010                                    prior_retail_99ending  Pct_Cost_Change   priormargin log_priorrev seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth) 
margins, dydx(*)
logit retail_increase log_numberofskus_jul2010                                prior_retail_99ending  Pct_Cost_Change   priormargin log_priorrev seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth)
margins, dydx(*)
regress retail_increase number2_3_jul2010 number4_6_jul2010  number7p_jul2010 prior_retail_99ending  Pct_Cost_Change   priormargin log_priorrev seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce(cluster yearmonth)


* Unit Volume Per SKU Instead of Volume per Primary_SKU
use "F:\CVS Projects\Macro\Final Results for Final Version of Paper\SAS and Stata Data\stata_logistic_final.dta", clear
logit retail_increase numberofskus_jul2010                                    prior_retail_99ending  Pct_Cost_Change   priormargin log_sku_units seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth) 
margins, dydx(*)
logit retail_increase log_numberofskus_jul2010                                prior_retail_99ending  Pct_Cost_Change   priormargin log_sku_units seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth)
margins, dydx(*)
regress retail_increase number2_3_jul2010 number4_6_jul2010  number7p_jul2010 prior_retail_99ending  Pct_Cost_Change   priormargin log_sku_units seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce(cluster yearmonth)


* Omit Items with numberofskus_jul2010 = 1
use "F:\CVS Projects\Macro\Final Results for Final Version of Paper\SAS and Stata Data\stata_logistic_final.dta", clear
drop if numberofskus_jul2010 == 1
logit retail_increase numberofskus_jul2010                                    prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth) 
margins, dydx(*)
logit retail_increase log_numberofskus_jul2010                                prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth)
margins, dydx(*)
regress retail_increase  number4_6_jul2010  number7p_jul2010 				  prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce(cluster yearmonth)


* Add Private Label Indicator
use "F:\CVS Projects\Macro\Final Results for Final Version of Paper\SAS and Stata Data\stata_logistic_final.dta", clear
logit retail_increase numberofskus_jul2010                                    prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 private_label_item year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth) 
margins, dydx(*)
logit retail_increase log_numberofskus_jul2010                                prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 private_label_item year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce (cluster yearmonth)
margins, dydx(*)
regress retail_increase number2_3_jul2010 number4_6_jul2010  number7p_jul2010 prior_retail_99ending  Pct_Cost_Change   priormargin log_priorunits seg_size_00 private_label_item year2006 year2007 year2008 year2009 month2 month3 month4 month5 month6 month7 month8 month9 month10 month11 month12 if cost_increase==1, vce(cluster yearmonth)

