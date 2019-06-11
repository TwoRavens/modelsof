//LOG Results
log using "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Google Drive\2015 PROJECTS\R-and-P\R&PDATA\non-sig18dec2015.smcl", replace
set more off
//Summary Statistics Table
sum agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media peacekeeing  conflict_type gdp_growth_annual_perc ln_media non_sig_diff_id all_nonsig if  exclude_cases==0 & year<2013

//Table 1 Model 1-6
stset year_count, id(caseid) failure(non_sig_diff_id) origin(time year_count)

streg  agg_imp_rate_woc  if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc conflict_type dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate  polity_2_1lag gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media if  exclude_cases==0, cluster (cowcode) d(w) time
streg agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media peacekeeing if  exclude_cases==0, cluster (cowcode) d(w) time

drop _st _d _t _t0
//Table 1 Model 7-12
stset year_count, id(caseid) failure(all_nonsig) origin(time year_count)
streg  agg_imp_rate_woc  if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc conflict_type dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate  polity_2_1lag gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media if  exclude_cases==0, cluster (cowcode) d(w) time
streg agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media peacekeeing if  exclude_cases==0, cluster (cowcode) d(w) time
drop _st _d _t _t0

//COX MODELS
//Appendix Model 1-6
stset year_count, id(caseid) failure(non_sig_diff_id) origin(time year_count) 

stcox  agg_imp_rate_woc  if  exclude_cases==0, cluster (cowcode)nohr  
stcox  agg_imp_rate_woc conflict_type dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) nohr  
stcox  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate  polity_2_1lag gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode)nohr  
stcox  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode)nohr  
stcox  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media if  exclude_cases==0, cluster (cowcode)nohr  
stcox agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media peacekeeing if  exclude_cases==0, cluster (cowcode) nohr 

drop _st _d _t _t0
//Appendix Model 7-12
stset year_count, id(caseid) failure(all_nonsig) origin(time year_count)
stcox  agg_imp_rate_woc  if  exclude_cases==0, cluster (cowcode)nohr  
stcox  agg_imp_rate_woc conflict_type dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) nohr  
stcox  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate  polity_2_1lag gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode)nohr  
stcox  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode)nohr  
stcox  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media if  exclude_cases==0, cluster (cowcode)nohr  
stcox agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media peacekeeing if  exclude_cases==0, cluster (cowcode) nohr 



//Survival Graphs for different non-sig and all non-sig Last Model

drop _st _d _t _t0
stset year_count, id(caseid) failure(non_sig_diff_id) origin(time year_count)
streg agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media peacekeeing if  exclude_cases==0, cluster (cowcode) d(w) time
stcurve, survival at1(agg_imp_rate_woc=0) at2(agg_imp_rate_woc=25) at3(agg_imp_rate_woc=50) at4(agg_imp_rate_woc=75)
graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Google Drive\2015 PROJECTS\R-and-P\R&PDATA\non-sig-diffid.gph", replace
stcox agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media peacekeeing if  exclude_cases==0, cluster (cowcode) nohr 
stcurve, survival at1(agg_imp_rate_woc=0) at2(agg_imp_rate_woc=25) at3(agg_imp_rate_woc=50) at4(agg_imp_rate_woc=75)
graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Google Drive\2015 PROJECTS\R-and-P\R&PDATA\coxnon-sig-diffid.gph", replace

 
drop _st _d _t _t0
stset year_count, id(caseid) failure(all_nonsig) origin(time year_count)
streg agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media peacekeeing if  exclude_cases==0, cluster (cowcode) d(w) time
stcurve, survival at1(agg_imp_rate_woc=0) at2(agg_imp_rate_woc=25) at3(agg_imp_rate_woc=50) at4(agg_imp_rate_woc=75)
graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Google Drive\2015 PROJECTS\R-and-P\R&PDATA\allnon-sig-diffid.gph", replace
stcox agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag total_prov_woc ln_media peacekeeing if  exclude_cases==0, cluster (cowcode) nohr 
stcurve, survival at1(agg_imp_rate_woc=0) at2(agg_imp_rate_woc=25) at3(agg_imp_rate_woc=50) at4(agg_imp_rate_woc=75)
graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Google Drive\2015 PROJECTS\R-and-P\R&PDATA\coxallnon-sig-diffid.gph", replace
 
//Graph Combines for Figure 1 
graph combine  "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Google Drive\2015 PROJECTS\R-and-P\R&PDATA\non-sig-diffid.gph" "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Google Drive\2015 PROJECTS\R-and-P\R&PDATA\allnon-sig-diffid.gph", xcommon
graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Google Drive\2015 PROJECTS\R-and-P\R&PDATA\survival nonsig diff and all id.gph", replace
 
//Graph Combine for Figure in Appendix 
graph combine "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Google Drive\2015 PROJECTS\R-and-P\R&PDATA\coxnon-sig-diffid.gph" "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Google Drive\2015 PROJECTS\R-and-P\R&PDATA\coxallnon-sig-diffid.gph", xcommon
graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Google Drive\2015 PROJECTS\R-and-P\R&PDATA\cox nonsig diff and all id.gph", replace
drop _st _d _t _t0

log close
