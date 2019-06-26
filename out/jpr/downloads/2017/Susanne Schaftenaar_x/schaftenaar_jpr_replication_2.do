************ replication file: how (wo)men rebel, part 2 (ethnic vs nonethnic appendix models)
************ susanne schaftenaar
************ department of peace and conflict research
************ uppsala university

set more off      
capture log close 
version 13 //stata version control       
clear all        
set linesize 80  

* set your own working directory 
* cd  
* open dataset
use "schaftenaar_jpr_replication_2.dta"

*** 2.5 models stratified by ethnic/non-ethnic conflict onset
// note: onset_ucdp_navco is recoded to exclude ethnic onsets for these models (tables IIm and IIn)

* table IIk, model 1
qui mlogit ethn_onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno) 
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableIa_ethnic.rtf, replace 

* table IIl, model 1
qui mlogit ethn_onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno) 
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableIIa_ethnic.rtf, replace 

* table IIm, model 1
qui mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno) 
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableIa_nonethnic.rtf, replace 

* table IIn, model 1
qui mlogit onset_ucdp_navco l.sp_dyn_tfrt_in l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableIIa_nonethnic.rtf, replace 

* table IIk, model 2
qui mlogit ethn_onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableIb_ethnic.rtf, replace 

* table IIl, model 2
qui mlogit ethn_onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableIIb_ethnic.rtf, replace 

* table IIm, model 2
qui mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableIb_nonethnic.rtf, replace 

* table IIn, model 2
qui mlogit onset_ucdp_navco l.se_enr_prim_fm_zs l.ln_urban_pop l.ln_milper l.ln_gdp_pc l.polity2 l.polity2_sq l.nvcp_seq l.nvcp_t2 l.nvcp_t3 l.pea_seq l.pea_seq_t2 l.pea_seq_t3, baseoutcome(2) vce(cluster gwno)
esttab, unstack noomitted se aic bic l star(* 0.05 ** 0.01) b(%8.3f), using tableIIb_nonethnic.rtf, replace 


