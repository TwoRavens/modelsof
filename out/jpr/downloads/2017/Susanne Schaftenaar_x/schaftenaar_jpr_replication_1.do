************ replication file: how (wo)men rebel
************ susanne schaftenaar
************ department of peace and conflict research
************ uppsala university

set more off      
capture log close 
version 13 // version control        
clear all        
set linesize 80  

* set your working directory
* cd "workingdirectoryhere"

* open dataset
use "schaftenaar_jpr_replication_1.dta"


***********

*** variables ***

** main DV **
* onset_ucdp_navco: onset nonviolent and armed conflicts in a given year. ucdp dyad-based, navco campaign based

** main IVS **
* fertility rate, total (births per woman): sp_dyn_tfrt_in  
* ratio of female to male primary school enrollment (%): se_enr_prim_fm_zs 

** main CVs **
* ln urban population: ln_urban_pop
* ln military personnel: ln_milper     
* ln GDP per capita: ln_gdp_pc 
* polity2: polity2
* polity2 squared: polity2_sq
* years since nvc: nvcp_seq 
* years since nvc^2: nvcp_t2 
* years since nvc^3: nvcp_t3
* years since armed: pea_seq  
* years since armed^2: pea_seq_t2 
* years since armed^3: pea_seq_t3 

** extra IVs appendix
* manufacturing value added (%gdp): nv_ind_manf_zs
* gdp growth (annual %): ny_gdp_mktp_kd_zg   
* ln total population: ln_tpop
* ln GDP per capita squared: sq_ln_gdp_pc 
* ratio of female to male secondary enrollment (%): se_enr_seco_fm_zs
* ratio of female to male tertiary enrollment (%): se_enr_tert_fm_zs 
* labor force, female (% of total labor force): sl_tlf_totl_fe_zs 
* fert_lag1: lagged fertility rate (t-1)
* prim_lag: lagged ratio female to male primary school enrolment (t-1)
* pol2_cat: categorical variable for democracy, anocracy, autocracy using polity2
* pol2_new: polity2 re-coded in positive integers
* pol_new_sq: polity_new squared

** extra DVs appendix
* onset_ucdp_navco_y2: conflict onset 2y gap navco/ ucdp
* onset_ucdp_navco_y2_no_cat3: conflict onset 2y gap navco/ ucdp, without category 3
* onset_ucdp_navco_y5: conflict onset 5y gap navco/ ucdp
* onset_ucdp_navco_y5_no_cat3: conflict onset 5y gap navco/ ucdp, without category 3
* onset_cow_navco: conflict onset navco/cow


*** prepare panel ***
tsset gwno year, yearly

***********
***********

*** in main article ***

** 1. table I & II, model 1s
* for table I, model 1 (fertility rate), multinomial (base no conflict onset)
mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableIa.rtf, replace 

* for table II, model 1 (fertility rate), multinomial (base armed conflict onset)
mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableIIa.rtf, replace 


** 2. for figure 1 (fertility rate predicted probabilities)
* establish predicted probabilities, base on fertility rate model sample minimum, 1st quartile, mean, 3rd quartile, maximum)
sum onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq if e(sample), detail

* 2.1 min fert, 25% fert, mean fert, 75% fert and max fert given sample, predict probability nonviolent campaign occuring
qui mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
margins, at (l.sp_dyn_tfrt_in=(1.076 2.415 4.357 6.254 8.667)) atmeans predict(outcome(1)) post saving(file1, replace)
marginsplot, recast(line) recastci(rarea) note("note: margins at minimum, 25%, mean, 75%, maximum") ciopts(color(gs14)) title(Predicted probabilites with 95% confidence intervals) subtitle(Nonviolent conflict onset) xtitle(Fertility rate) ytitle(Prob. nonviolent onset)
graph save gr1.gph, replace
* 2.2 min fert, 25% fert, mean fert, 75% fert and max fert given sample, predict probability armed conflict occuring
qui mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
margins, at (l.sp_dyn_tfrt_in=(1.076 2.415 4.357 6.254 8.667)) atmeans predict(outcome(2)) post saving(file2, replace)
marginsplot, recast(line) recastci(rarea) note("note: margins at minimum, 25%, mean, 75%, maximum") ciopts(color(gs14)) title(Predicted probabilites with 95% confidence intervals) subtitle(Armed conflict onset) xtitle(Fertility rate) ytitle(Prob. armed onset)
graph save gr2.gph, replace
* 2.3 combine the graphs in one figure
gr combine gr1.gph gr2.gph, col(1) iscale(0.75) note("Baseline is 'no conflict onset'")
graph save fig1.gph, replace
* 2.4 combine to one graph (in appendix)
combomarginsplot file1 file2

 
** 3. table I & II, model 2s 
* for table I, model 2 (primary school enrolment), multinomial (base no conflict onset)
mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableIb.rtf, replace 

* for table II, model 2 (primary school enrolment), multinomial (base armed conflict onset)
mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableIIb.rtf, replace 


* 4. for figure 2 (primay school enrolment predicted probabilities)
** establish predicted probabilities, base on prim enrollment model sample: minimum, 1%, 1st quartile, mean, 3rd quartile, 99%)
sum onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq if e(sample), detail

* 4.1 minimum, 1%, 25% prim, mean prim, 75% prim and 99% prim given sample, predict probability nonviolent campaign occuring 
qui mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
margins, at (l.se_enr_prim_fm_zs=(14.978 39.143 82.797 89.39 99.572 110.746)) atmeans predict(outcome(1)) post saving(file1, replace)
marginsplot, recast(line) recastci(rarea) note("note: margins at minimum, 1%, 25%, mean, 75%, 99%") ciopts(color(gs14)) title(Predicted probabilites with 95% confidence intervals) subtitle(Nonviolent conflict onset) xtitle(Primary school enrollment) ytitle(Prob. nonviolent onset)
graph save gr3.gph, replace
* 4.2 minimum, 1%, 25% prim, mean prim, 75% prim and 99% prim given sample, predict probability armed conflict occuring 
qui mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
margins, at (l.se_enr_prim_fm_zs=(14.978 39.143 82.797 89.39 99.572 110.746)) atmeans predict(outcome(2)) post saving(file2, replace)
marginsplot, recast(line) recastci(rarea) note("note: margins at minimum, 1%, 25%, mean, 75%, 99%") ciopts(color(gs14)) title(Predicted probabilites with 95% confidence intervals) subtitle(Armed conflict onset) xtitle(Primary school enrollment) ytitle(Prob. armed onset)
graph save gr4.gph, replace
* 4.3 combine the graphs in one figure
gr combine gr3.gph gr4.gph, col(1) iscale(0.75) note("Baseline is 'no conflict onset'")
graph save fig2.gph, replace
* 4.4 comboplot (in appendix)
combomarginsplot file1 file2



*** in appendix ***

*** 1. relevant summary statistics and descriptive statistics
** 1.1 summary statistics
* 1a summary statistics full sample
estpost sum onset_ucdp_navco sp_dyn_tfrt_in se_enr_prim_fm_zs ln_urban_pop ln_milper ln_gdp_pc polity2 polity2_sq
esttab, cells("count mean sd min max") nomtitle nonumber noobs label, using table_ap_1.rtf, replace
* 1b summary statistics for model 1, main independent variable fertility rates
quietly mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
sum onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq if e(sample)
* 1c summary statistics for model 2, main independent variable primary school
quietly mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
sum onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq if e(sample)
** 1.2 kernel density plots 
* figure 1.2.1 fertility rate
twoway (kdensity fert_lag1) (kdensity fert_lag1 if onset_ucdp_navco==1) (kdensity fert_lag1 if onset_ucdp_navco ==2) 
graph save kdens_fertlag2.gph, replace
* figure 1.2.2 primary school enrollment
twoway (kdensity prim_lag) (kdensity prim_lag if onset_ucdp_navco==1) (kdensity prim_lag if onset_ucdp_navco ==2) 
graph save kdens_primlag4.gph, replace


*** 2. alternative model specifications 
** 2.1 adding control variables
* table IIa (base no onset), manufacturing 
// fertility rate
mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.nv_ind_manf_zs, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_Ia.rtf, replace 
// primary school enrolment
mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.nv_ind_manf_zs, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_Ib.rtf, replace 

* table IIb ( base armed onset), manufacturing 
// fertility rate
mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.nv_ind_manf_zs, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IIa.rtf, replace 
// primary school enrolment
mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.nv_ind_manf_zs, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IIb.rtf, replace 


* table IIa (base no onset), gdp growth 
// fertility rate
mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.ny_gdp_mktp_kd_zg, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_Ic.rtf, replace 
// primary school enrolment
mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.ny_gdp_mktp_kd_zg, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_Id.rtf, replace 

* table IIb (base armed onset), gdp growth
// fertility rate
mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.ny_gdp_mktp_kd_zg, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IIc.rtf, replace 
// primary school enrolment
mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.ny_gdp_mktp_kd_zg, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IId.rtf, replace 


* table IIa (base no onset), total population (replaces urban population from original model)
// fertility rate
mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.ln_tpop, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_Ie.rtf, replace 
// primary school enrolment
mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.ln_tpop, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_If.rtf, replace 

* table IIb (base armed onset), total population (replaces urban population from original model)
// fertility rate
mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.ln_tpop, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IIe.rtf, replace 
// primary school enrolment
mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.ln_tpop, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IIf.rtf, replace 


* table IIa (base no onset), squared ln gdp pc 
// fertility rate
mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.sq_ln_gdp_pc, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_Ig.rtf, replace 
// primary school enrolment
mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.sq_ln_gdp_pc, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_Ih.rtf, replace 

* table IIb (base armed onset), squared ln gdp pc 
// fertility rate
mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.sq_ln_gdp_pc, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IIg.rtf, replace 
// primary school enrolment
mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 l.sq_ln_gdp_pc, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IIh.rtf, replace 


** 2.2 models alternative dvs
* table IIc (base no onset) & IId (base armed conflict onset), model 1s: fert rate (dv: cow instead of ucdp)
qui mlogit onset_cow_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IVa.rtf, replace 
qui mlogit onset_cow_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IVb.rtf, replace 
* table IIc (base no onset) & IId (base armed conflict onset), model 2s: ratio primary school (dv: cow instead of ucdp)
qui mlogit onset_cow_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IVc.rtf, replace 
qui mlogit onset_cow_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IVd.rtf, replace 


* table IIe (base no onset) and IIf (base armed conflict onset, model 1s (original dependent var with t+2, fertility rate)
qui mlogit onset_ucdp_navco_y2 l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IVe.rtf, replace 
qui mlogit onset_ucdp_navco_y2 l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IVf.rtf, replace 

* table IIe (base no onset) and IIf (base armed conflict onset, model 2s (original dependent var with t+2, primary school enrolment)
* note: dependent variable without category 3 (simultaneous armed and nonviolent onset)
qui mlogit onset_ucdp_navco_y2_no_cat3 l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno) 
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IVg.rtf, replace 
qui mlogit onset_ucdp_navco_y2_no_cat3 l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IVh.rtf, replace 

* table IIe (base no onset) and IIf (base armed conflict onset), model 3s (original dependent var with t+5, fertility rate)
qui mlogit onset_ucdp_navco_y5 l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IVi.rtf, replace 
qui mlogit onset_ucdp_navco_y5 l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IVj.rtf, replace 

* table IIe (base no onset) and IIf (base armed conflict onset), model 4s (original dependent var with t+5, primary school enrolment)
* note: dependent variable without category 3 (simultaneous armed and nonviolent onset)
qui mlogit onset_ucdp_navco_y5_no_cat3 l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IVk.rtf, replace 
qui mlogit onset_ucdp_navco_y5_no_cat3 l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IVl.rtf, replace 


** 2.3. models alternative IVs
* table IIg (base no onset) & IIh (base armed conflict onset), model 1s (secondary education)
qui mlogit onset_ucdp_navco l.se_enr_seco_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableVa.rtf, replace 
qui mlogit onset_ucdp_navco l.se_enr_seco_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableVIa.rtf, replace 


* table IIg (base no onset) & IIh (base armed conflict onset), model 2s (tertiary education)
qui mlogit onset_ucdp_navco l.se_enr_tert_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableVb.rtf, replace 
qui mlogit onset_ucdp_navco l.se_enr_tert_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableVIb.rtf, replace 

* table IIg (base no onset) & IIh (base armed conflict onset), model 3s (labor force, female (% of total labor force))
qui mlogit onset_ucdp_navco l.sl_tlf_totl_fe_zs  l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableVc.rtf, replace 
qui mlogit onset_ucdp_navco l.sl_tlf_totl_fe_zs  l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableVIc.rtf, replace 

** 2.4 fertility rate model with primary school sample
* table IIi (base no onset)
qui mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 if e(sample), vce(cluster gwno) 
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IIIa.rtf, replace 
* table IIj (base armed conflict onset)
qui mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 if e(sample), baseoutcome(2) vce(cluster gwno) 
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using table_app_IIIb.rtf, replace 


*** 3.  Predicted probabilities by level of democracy

* figure 3.1 nvc onset, base = no onset, fertility rate
qui mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.pol2_cat l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3
margins, at (l.sp_dyn_tfrt_in=(1.076 2.415 4.356789 6.254 8.667) l.pol2_cat=(0) ) atmeans predict(outcome(1)) post saving(file8, replace)
qui mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.pol2_cat l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3
margins, at (l.sp_dyn_tfrt_in=(1.076 2.415 4.356789 6.254 8.667) l.pol2_cat=(1) ) atmeans predict(outcome(1)) post saving(file9, replace) 
qui mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.pol2_cat  l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3
margins, at (l.sp_dyn_tfrt_in=(1.076 2.415 4.356789 6.254 8.667) l.pol2_cat=(2) ) atmeans predict(outcome(1)) post saving(file10, replace)
combomarginsplot file8 file9 file10


* figure 3.2 nvc onset, base = no onset, prim ratio
qui mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.pol2_cat  l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
margins, at (l.se_enr_prim_fm_zs=(15 39.1 82.8 89.4 99.6 110.7) l.pol2_cat=(0) ) atmeans predict(outcome(1)) post saving(file14, replace)
qui mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.pol2_cat l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
margins, at (l.se_enr_prim_fm_zs=(15 39.1 82.8 89.4 99.6 110.7) l.pol2_cat=(1) ) atmeans predict(outcome(1)) post saving(file15, replace) 
qui mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.pol2_cat l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
margins, at (l.se_enr_prim_fm_zs=(15 39.1 82.8 89.4 99.6 110.7) l.pol2_cat=(2) ) atmeans predict(outcome(1)) post saving(file16, replace)
combomarginsplot file14 file15 file16

* 4. VIF tests
* table IVa (fertility rate) 
qui reg onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.pol2_new l.pol2_new_sq  l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3
estadd vif
esttab, aux(vif 2) l wide nopar 
* table IVb (primary school enrolment)
qui reg onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.pol2_new l.pol2_new_sq  l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3
estadd vif
esttab, aux(vif 2) l wide nopar

* table IVa (fertility rate), without polity2 squared 
qui reg onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.pol2_new  l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 
estadd vif
esttab, aux(vif 2) l wide nopar
* table IVb (primary school enrolment), without polity squared
qui reg onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.pol2_new  l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3 
estadd vif
esttab, aux(vif 2) l wide nopar

* 5. IIA Assumption tests
* table Va: fertility rate
qui mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3
set seed 1234
mlogtest, iia 
* table Vb: primary school enrolment
qui mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3
set seed 1234
mlogtest, iia 
