

***Table I. Descriptive statistics for the three samples 
use "D:\jopr_yesilyurt_yesilyurt\overallsample.dta", clear
 summarize PCC t Precision Computed_standard_error
use "D:\jopr_yesilyurt_yesilyurt\coresample.dta", clear
 summarize PCC t Precision Computed_standard_error
use "D:\jopr_yesilyurt_yesilyurt\remainingsample.dta", clear
 summarize PCC t Precision Computed_standard_error


***Table II. Regression of t-statistics on precision: FAT-PET****                                                                                                                                    

***CORE Sample with Outlier

use "D:\jopr_yesilyurt_yesilyurt\coresample.dta", clear
**CORE Sample OLS
regress t Precision
*CORE Sample ROBUST SE
regress t Precision, vce(robust)
*CORE Sample CLUSTER
regress t Precision, cluster(id)

***Table II.I Regression of t-statistics on precision: FAT-PET with multi-level hierarchical analysis 
xtmixed t Precision || id:


use "D:\jopr_yesilyurt_yesilyurt\coresample_withoutoutlier.dta", clear
*CORE Sample without Outlier
regress t Precision 
*CORE Sample ROBUST SE
regress t Precision, vce(robust)
*CORE Sample CLUSTER
regress t Precision, cluster(id)
***Table II.I Regression of t-statistics on precision: FAT-PET with multi-level hierarchical analysis 

xtmixed t Precision || id:, cluster(id)

**Remaining Sample with Outlier
use "D:\jopr_yesilyurt_yesilyurt\remainingsample.dta", clear
*Remaining Sample  OLS
regress t Precision
*Remaining Sample ROBUST SE
regress t Precision, vce(robust)
*Remaining Sample CLUSTER
regress t Precision, cluster(id)

***Table II.I Regression of t-statistics on precision: FAT-PET with multi-level hierarchical analysis 

xtmixed t Precision || id:



*****Remaining Sample without Outlier
use "D:\jopr_yesilyurt_yesilyurt\remainingsample_withoutoutlier.dta", clear

*Remaining Sample OLS
regress t Precision 
*Remaining Sample ROBUST SE
regress t Precision, vce(robust)
*Remaining Sample CLUSTER
regress t Precision, cluster(id)

***Table II.I Regression of t-statistics on precision: FAT-PET with multi-level hierarchical analysis 
xtmixed t Precision || id:


** Overall Sample with Outlier
use "D:\jopr_yesilyurt_yesilyurt\overallsample.dta", clear
*Overall Sample OLS
regress t Precision 
*Overall Sample  ROBUST SE
regress t Precision, vce(robust)
*Overall Sample  CLUSTER
regress t Precision, cluster(id)

***Table II.I Regression of t-statistics on precision: FAT-PET with multi-level hierarchical analysis 
xtmixed t Precision || id:



** Overall Sample without Outlier
use "D:\jopr_yesilyurt_yesilyurt\overallsample_withoutoutlier.dta", clear
*Overall Sample OLS
regress t Precision
*Overall Sample ROBUST SE
regress t Precision, vce(robust)
*Overall Sample CLUSTER
regress t Precision, cluster(id)

***Table II.I Regression of t-statistics on precision: FAT-PET with multi-level hierarchical analysis 
xtmixed t Precision|| id:

***Table_III._Regression_of_t-statistics_on_precision_and_controls_(divided_by_standard_errors)_for_the_three_samples_with_t-statistics_based_on_clustered_standard_errors

**CORE Sample 

*CORE Sample CLUSTER
use "D:\jopr_yesilyurt_yesilyurt\coresample.dta", clear
regress t Precision Post_cold_war_dummy Cross_sectional_data_dummy Dynamic_model_dummy ACDA_NIPA_data_dummy SIPRI_data_dummy North_America_Countries_dummy Europe_Countries_dummy Asia_Countries_dummy OLS_dummy Threshold_dummy Twosls_dummy Dummy80 GDP_dummy Investment_dummy Unemployment_dummy Balance_of_payments_dummy Interest_rate_dummy Government_revenue_dummy Debt_dummy Trend_dummy Industry_dummy World_indicator_dummy,cluster(id)
*CORE Sample hierarchical ols
xtmixed t Precision Post_cold_war_dummy Cross_sectional_data_dummy Dynamic_model_dummy ACDA_NIPA_data_dummy SIPRI_data_dummy North_America_Countries_dummy Europe_Countries_dummy Asia_Countries_dummy OLS_dummy Threshold_dummy Twosls_dummy Dummy80 GDP_dummy Investment_dummy Unemployment_dummy Balance_of_payments_dummy Interest_rate_dummy Government_revenue_dummy Debt_dummy Trend_dummy Industry_dummy World_indicator_dummy || id:


**REMAINING Sample
use "D:\jopr_yesilyurt_yesilyurt\remainingsample.dta", clear
*REMAINING Sample cluster 
regress t Precision Intime_period Cold_War_dummy Time_series_data_dummy Dynamic_model_dummy Unit_Root_dummy Heteroskedasticity_test_dummy Descriptive_statistics_dummy ACDA_NIPA_data_dummy Mixed_Countries_dummy GLS_dummy Dummy70 Dummy80 GDP_dummy Investment_dummy Labour_dummy Inflows_dummy Balance_of_payments_dummy Debt_dummy World_indicator_dummy,cluster(id)
*REMAINING Sample hierarchical ols
xtmixed t Precision Intime_period Cold_War_dummy Time_series_data_dummy Dynamic_model_dummy Unit_Root_dummy Heteroskedasticity_test_dummy Descriptive_statistics_dummy ACDA_NIPA_data_dummy Mixed_Countries_dummy GLS_dummy Dummy70 Dummy80 GDP_dummy Investment_dummy Labour_dummy Inflows_dummy Balance_of_payments_dummy Debt_dummy World_indicator_dummy || id:





**OVERALL Sample
use "D:\jopr_yesilyurt_yesilyurt\overallsample.dta", clear
*OVERALL Sample CLUSTER
regress t Precision Intime_period  Innumber_of_countries Post_cold_war_dummy Panel_data_dummy Dynamic_model_dummy Heteroskedasticity_test_dummy Descriptive_statistics_dummy World_Bank_data_dummy SIPRI_data_dummy Developed_countries_dummy Developing_countries_dummy Europe_Countries_dummy OLS_dummy Dummy70 GDP_dummy Investment_dummy School_enrolment_dummy  Balance_of_payments_dummy Debt_dummy Money_dummy  World_indicator_dummy Non_military_expenditure_dummy,cluster(id)
*OVERALL Sample hierarchical linear model OLS
xtmixed t Precision Intime_period  Innumber_of_countries Post_cold_war_dummy Panel_data_dummy Dynamic_model_dummy Heteroskedasticity_test_dummy Descriptive_statistics_dummy World_Bank_data_dummy SIPRI_data_dummy Developed_countries_dummy Developing_countries_dummy Europe_Countries_dummy OLS_dummy Dummy70 GDP_dummy Investment_dummy School_enrolment_dummy  Balance_of_payments_dummy Debt_dummy Money_dummy  World_indicator_dummy Non_military_expenditure_dummy || id:


