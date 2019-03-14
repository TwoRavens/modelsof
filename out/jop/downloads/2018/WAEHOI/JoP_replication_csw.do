use "full_data_unitsappended_tr.dta"





******************************************
*
* Table 1: Terrain and the Num. of Groups
*
******************************************


** Models with 2nd Order Administrative Unit **

reg ethgroups rugg_var cap_dist000 contig_dist000 area_scale A_Wh_mean_pr A_WR_mean_pr A_DR_mean_pr i.ccode if dup92==1 & province==1 , cluster(super_ID) 

estimates store m1_1, title(Model 1)



reg ethgroups rugged cap_dist000 contig_dist000 area_scale A_Wh_mean_pr A_WR_mean_pr A_DR_mean_pr i.ccode if dup92==1 & province==1 , cluster(super_ID) 

estimates store m1_2, title(Model 2)


reg ethgroups rugged rugg_var cap_dist000 contig_dist000 area_scale A_Wh_mean_pr A_WR_mean_pr A_DR_mean_pr i.ccode if dup92==1 & province==1 , cluster(super_ID) 

estimates store m1_3, title(Model 3)

*margins, atmeans 

*margins, atmeans at(rugg_var=1.8942422)

*margins, atmeans at(rugg_var=2.68333)


*use "/Users/dbcarter/Dropbox/Ethnicity_Ruggedness/Analysis_Organized/tiny_data_subst_effects.dta", clear

*predict numgr_pred


reg ethgroups rugged rugg_var cap_dist000 contig_dist000 area_scale lngdp_pc_t1 pop_density_t1 i.ccode if dup92==1 & province==1, cl(super_ID) 

estimates store m1_4, title(Model 4)



** Models with PRIO-GRID Unit **


reg ethgroup_count rugg_var cap_dist000 contig_dist000 cellarea_scale A_Wh_mean A_WR_mean A_DR_mean i.ccode if dup==1 & province==0, cl(admin_cluster_id)  

estimates store m1_5, title(Model 5)


reg ethgroup_count rugged cap_dist000 contig_dist000  cellarea_scale A_Wh_mean A_WR_mean A_DR_mean i.ccode if dup==1 & province==0, cl(admin_cluster_id)  

estimates store m1_6, title(Model 6)


reg ethgroup_count rugged rugg_var cap_dist000 contig_dist000  cellarea_scale A_Wh_mean A_WR_mean A_DR_mean i.ccode if dup==1 & province==0, cl(admin_cluster_id)  

estimates store m1_7, title(Model 7)


*margins, atmeans 

*margins, atmeans at(rugg_var=1.4191683)

*margins, atmeans at(rugg_var=2.250577)


reg ethgroup_count rugged rugg_var cap_dist000 contig_dist000  cellarea_scale ln_gcppc pop_densgrid i.ccode if dup==1 & province==0, cl(admin_cluster_id)  

estimates store m1_8, title(Model 8)


estout m1_1 m1_2 m1_3 m1_4 m1_5 m1_6 m1_7 m1_8, style(tex) starlevels(* 0.10 ** 0.05) cells(b(star fmt(3)) se(par fmt(2))) stats(r2 N) 


**********************************
*
* Table 2: Terrain and Exclusion
*
**********************************


** Models with 2nd Order Administrative Unit **


reg excluded rugg_var democ_dum durable0 democ_dur cap_dist000 contig_dist000 lngdp_pc pop_density area_scale i.year i.ccode if province==1, cl(super_ID)   

estimates store m2_1, title(Model 1)


*margins, atmeans 

*margins, atmeans at(rugg_var=1.8942422)

*margins, atmeans at(rugg_var=2.68333)

*use "/Users/dbcarter/Dropbox/Ethnicity_Ruggedness/Analysis_Organized/tiny_data_subst_effects_pred.dta", clear

*predict numexcgr_pred



reg percexcl rugg_var democ_dum durable0 democ_dur cap_dist000 contig_dist000 lngdp_pc pop_density area_scale i.year  i.ccode if province==1, cl(super_ID) 

estimates store m2_2, title(Model 2)


reg excluded rugg_var ethgroups cap_dist000 contig_dist000 area_scale A_Wh_mean_pr A_WR_mean_pr A_DR_mean_pr i.year i.ccode if province==1, cl(super_ID) 

estimates store m2_4, title(Model 4)


reg percexcl rugg_var ethgroups cap_dist000 contig_dist000 area_scale A_Wh_mean_pr A_WR_mean_pr A_DR_mean_pr  i.year  i.ccode if province==1, cl(super_ID)  

estimates store m2_5, title(Model 5)


reg excluded rugg_var rugged democ_dum durable0 democ_dur cap_dist000 contig_dist000 lngdp_pc pop_density area_scale i.year i.ccode if province==1, cl(super_ID)   

estimates store m2_7, title(Model 7)


** Models with PRIO-GRID Unit **


reg excluded rugg_var democ_dum durable0 democ_dur cap_dist000 contig_dist000 ln_gcppc  cellarea_scale pop_densgrid i.ccode i.year if province==0 & ethgroup_count>0, cl(admin_cluster_id)   

estimates store m2_8, title(Model 8)


reg percexcl rugg_var democ_dum durable0 democ_dur cap_dist000 contig_dist000 ln_gcppc cellarea_scale pop_densgrid i.ccode i.year if province==0 & ethgroup_count>0, cl(admin_cluster_id)  

estimates store m2_9, title(Model 9)


reg excluded rugg_var cap_dist000 contig_dist000  cellarea_scale A_Wh_mean A_WR_mean A_DR_mean i.ccode i.year if province==0 & ethgroup_count>0, cl(admin_cluster_id)  

estimates store m2_11, title(Model 11)



reg percexcl rugg_var cap_dist000 contig_dist000 cellarea_scale A_Wh_mean A_WR_mean A_DR_mean i.ccode i.year if province==0 & ethgroup_count>0, cl(admin_cluster_id)  

estimates store m2_12, title(Model 12)


reg excluded rugg_var rugged democ_dum durable0 democ_dur cap_dist000 contig_dist000 ln_gcppc  cellarea_scale pop_densgrid i.ccode i.year if province==0 & ethgroup_count>0, cl(admin_cluster_id)   

estimates store m2_14, title(Model 14)


*margins, atmeans 

*margins, atmeans at(rugg_var=1.4191683)

*margins, atmeans at(rugg_var=2.250577)


estout m2_1 m2_4 m2_2 m2_5  m2_8 m2_11 m2_9 m2_12 m2_7 m2_14, style(tex) starlevels(* 0.10 ** 0.05) cells(b(star fmt(3)) se(par fmt(2))) stats(r2 N) 


**********************************
*
* Table 3: Civil War Models 
*
**********************************


** Models with 2nd Order Administrative Unit **


reg civilwar_n1 ethgroups rugg_var rugged democ_dum_t1 durable0_t1 democ_dur_t1 cap_dist000 contig_dist000 lngdp_pc_t1 pop_density_t1 warborder_t1 country_cw_t1 area_scale i.year i.ccode if province==1, cl(super_ID)

estimates store m3_1, title(Model 1)


*margins, atmeans 

*margins, atmeans at(rugg_var=1.8942422)

*margins, atmeans at(rugg_var=2.68333)

*margins, atmeans at(ethgroups=30.383036)

*margins, atmeans at(rugg_var=1.8942422 ethgroups=30.383036)

*margins, atmeans at(rugg_var=2.68333 ethgroups=30.383036)

*use "/Users/dbcarter/Dropbox/Ethnicity_Ruggedness/Analysis_Organized/tiny_data_subst_effects_pred.dta", clear

*predict civwar_gr_pred


reg civilwar_n1 excluded_t1 rugg_var rugged democ_dum_t1 durable0_t1 democ_dur_t1 cap_dist000 contig_dist000 lngdp_pc_t1 pop_density_t1 warborder_t1 country_cw_t1 area_scale i.year i.ccode if province==1, cl(super_ID) 

estimates store m3_2, title(Model 2)


*margins, atmeans 

*margins, atmeans at(rugg_var=1.8942422)

*margins, atmeans at(rugg_var=2.68333)

*margins, atmeans at(excluded_t1=.8075806)

*margins, atmeans at(excluded_t1=1)

*margins, atmeans at(rugg_var=1.8942422 excluded_t1=.8075806)

*margins, atmeans at(rugg_var=2.68333 excluded_t1=.8075806)

*use "/Users/dbcarter/Dropbox/Ethnicity_Ruggedness/Analysis_Organized/tiny_data_subst_effects_pred.dta", clear

*predict civwar_excgr_pred


reg civilwar_n1 percexcl_t1 rugg_var rugged democ_dum_t1 durable0_t1 democ_dur_t1 cap_dist000 contig_dist000 lngdp_pc_t1 pop_density_t1 warborder_t1 country_cw_t1 area_scale i.year i.ccode if province==1, cl(super_ID)  

estimates store m3_3, title(Model 3)



reg civilwar_n1 ethgroups excluded_t1 percexcl_t1 rugg_var rugged democ_dum_t1 durable0_t1 democ_dur_t1 cap_dist000 contig_dist000 lngdp_pc_t1 pop_density_t1 warborder_t1 country_cw_t1 area_scale i.year i.ccode if province==1, cl(super_ID)

estimates store m3_4, title(Model 4)


reg onset_n2 ethgroups excluded_t1 percexcl_t1 rugg_var rugged democ_dum_t1 durable0_t1 democ_dur_t1 cap_dist000 contig_dist000 lngdp_pc_t1 pop_density_t1 warborder_t1 country_cw_t1 i.year i.ccode if province==1, cl(super_ID)  

estimates store m3_5, title(Model 5)



** Models with PRIO-GRID Unit **


reg civconf ethgroup_count rugg_var rugged democ_dum_t1 durable0_t1 democ_dur_t1 cap_dist000 contig_dist000 ln_gcppc_t1 pop_densgrid convcontagion_b_t1 cellarea_scale i.ccode i.year if province==0 & anycivwar>0, cl(admin_cluster_id)  

estimates store m3_6, title(Model 6)

reg civconf excluded_t1 rugg_var rugged democ_dum_t1 durable0_t1 democ_dur_t1 cap_dist000 contig_dist000 ln_gcppc_t1 pop_densgrid convcontagion_b_t1  cellarea_scale i.ccode i.year if province==0 & anycivwar>0, cl(admin_cluster_id)  

estimates store m3_7, title(Model 7)

reg civconf percexcl_t1 rugg_var rugged democ_dum_t1 durable0_t1 democ_dur_t1 cap_dist000 contig_dist000 ln_gcppc_t1 pop_densgrid convcontagion_b_t1  cellarea_scale i.ccode i.year if province==0 & anycivwar>0, cl(admin_cluster_id)  

estimates store m3_8, title(Model 8)

reg civconf ethgroup_count excluded_t1 percexcl_t1 rugg_var rugged democ_dum_t1 durable0_t1 democ_dur_t1 cap_dist000 contig_dist000 ln_gcppc_t1 pop_densgrid convcontagion_b_t1 cellarea_scale i.ccode i.year if province==0 & anycivwar>0, cl(admin_cluster_id)  

estimates store m3_9, title(Model 9)


reg onset_noinc ethgroup_count_100 excluded_t1_100 percexcl_t1_100 rugg_var_100 rugged_100 democ_dum_t1_100 durable0_t1_100 democ_dur_t1_100 cap_dist000_100 contig_dist000_100 ln_gcppc_t1_100 pop_densgrid_100 convcontagion_b_t1_100 cellarea_scale_100 i.ccode i.year if province==0 & anycivwar>0, cl(admin_cluster_id)  

estimates store m3_10, title(Model 10)


estout m3_1 m3_2 m3_3 m3_4 m3_5 m3_6 m3_7 m3_8 m3_9 m3_10, style(tex) starlevels(* 0.10 ** 0.05) cells(b(star fmt(3)) se(par fmt(2))) stats(r2 N) 
















