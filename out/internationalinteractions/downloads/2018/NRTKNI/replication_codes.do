log using "C:\Users\mjoshi2\Desktop\Builtin safeguard\Data\II\replication log.smcl", replace
use "C:\Users\mjoshi2\Desktop\Builtin safeguard\Data\II\Replication Data for Built-in Safeguards.dta", replace


//Labeling Variables
label variable agg_imp_rate_woe "Accord Implementaiton Rate (0-100)"
label variable powtran_implem "Powershairng government (0-3)"
label variable dispute_implem "Dispute Resolution Mechanism (0-3)"
label variable verify_implem "Verification Mechanism (0-3)"
label variable donor_implem  "Donor Support (0-3)"
label variable unpkf_implem "United Nations Peacekeeping(0-3)"
label variable roa_implem  "Review of Agreement (0-3)"
label variable total_prov_woe "Number of Provisions"
label variable ex_constrain5_7 "Executive Constraints (0,1)"
label variable conflict_type "Conflict Type (0,1)"
label variable infant_rate "Infant Mortality Rate"
label variable gdppc_currus_1000 "GDP Per Capita x 1000 (2005 USD)"
label variable year_count "Peace Implementation Year (1-10)"
label variable con_conflict "Post Accord Conflict"
label variable war_dur "War Duration (months)"
label variable total_dead "Total Dead"
label variable meanprov "Above Average Provisions"

//Define Data as Time Series Data
xtset caseid year_count


//Summary Stat Table 1
sum meanprov agg_imp_rate_woe verify_implem  powtran_implem dispute_implem donor_implem  unpkf_implem roa_implem  total_prov_woe ex_constrain5_7  conflict_type infant_rate gdppc_currus_1000    year_count   

// Table 2 Correlation Matrix
pwcorr agg_imp_rate_woe verify_implem  powtran_implem dispute_implem donor_implem  unpkf_implem roa_implem  meanprov   ex_constrain5_7 conflict_type infant_rate gdppc_currus_1000    year_count  if exclude_case !=1


xtgls agg_imp_rate_woe powtran_implem year_count  if exclude_case !=1, corr(psar1)
xtgls agg_imp_rate_woe dispute_implem  year_count  if exclude_case !=1, corr(psar1)
xtgls agg_imp_rate_woe verify_implem  year_count  if exclude_case !=1, corr(psar1)
xtgls agg_imp_rate_woe verify_implem  powtran_implem dispute_implem donor_implem unpkf_implem  roa_implem  meanprov    year_count gdppc_currus_1000 if exclude_case !=1, corr(psar1)
xtgls agg_imp_rate_woe verify_implem  powtran_implem dispute_implem donor_implem  unpkf_implem roa_implem  meanprov   ex_constrain5_7 conflict_type infant_rate gdppc_currus_1000    year_count  if exclude_case !=1, corr(psar1)

//Appendix Replication of Model 5

//Replicate with war duration and total dead
xtgls agg_imp_rate_woe verify_implem  powtran_implem dispute_implem donor_implem  unpkf_implem roa_implem  meanprov   ex_constrain5_7 conflict_type infant_rate gdppc_currus_1000    year_count war_dur total_dead if exclude_case !=1, corr(psar1)
//Replicate with post-CPA conflict
xtgls agg_imp_rate_woe verify_implem  powtran_implem dispute_implem donor_implem  unpkf_implem roa_implem  meanprov   ex_constrain5_7 conflict_type infant_rate gdppc_currus_1000    year_count con_con if exclude_case !=1, corr(psar1)


//Figure 1 Coefficient Plots

quietly  xtgls agg_imp_rate_woe verify_implem  powtran_implem dispute_implem donor_implem  unpkf_implem roa_implem  meanprov   ex_constrain5_7 conflict_type infant_rate gdppc_currus_1000    year_count  if exclude_case !=1, corr(psar1)

coefplot, xline(0) drop(_cons) omitted base ///
groups(headroom verify_implem  powtran_implem dispute_implem = "{bf:Ownership Effects}" ///
donor_implem  unpkf_implem roa_implem  total_prov_woe   ex_constrain5_7 conflict_type infant_rate gdppc_currus_1000    year_count  = "{bf:Control Effects}", labcolor(dark green))


//Figure 2 actual and predicted rate
xtgls agg_imp_rate_woe verify_implem  powtran_implem dispute_implem donor_implem  unpkf_implem roa_implem  meanprov   ex_constrain5_7 conflict_type infant_rate gdppc_currus_1000    year_count  if exclude_case !=1, corr(psar1)
predict full

//CAREFUL - After Collapse you will lose your data if you save and replace the existing datafile 
collapse (mean) actual=agg_imp_rate_woe predicted=full, by(year_count)
twoway (lfitci predicted  year_count) (scatter predicted  year_count )(scatter actual   year_count,  msymbol(Oh))
 
log close
