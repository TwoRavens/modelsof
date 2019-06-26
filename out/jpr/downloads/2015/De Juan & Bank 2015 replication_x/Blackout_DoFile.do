* Do-File Syria Violence

**** Descriptive statistics
local controls "sc_emplgov sunni alawites sc_enroll611 log_border_dist share_urban_2004 sc_electricity sc_malunempl road_density log_pop_2004"

estpost summarize dum_fat_total_25 `controls' ligmean_change_0907 rate_ligmean_change_0907 dum_pos_ligmean_change_0908
esttab using summarystats.rtf, cells("mean(fmt(3)) min(fmt(3)) max(fmt(3)) sd(fmt(3)) count(fmt(0))") noobs nonumber label title("Summary statistics") replace

**** Main Models
xtset gov_id

* Table 1: Logit governorate fixed effects
eststo: xtlogit dum_fat_total_25 `controls' , fe 
eststo: xtlogit dum_fat_total_25 `controls' ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_25 `controls' rate_ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_25 `controls' dum_pos_ligmean_change_0908, fe 
esttab using 1_main_model.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Main Logit (FE) Models) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001) replace
eststo clear

**** Robustnes Checks, Tables Appendix

* Logit estimations with alternative thresholds for dependent variable 
tab gov_id, gen(dumgov)

* Table 2: Threshold 5
eststo: xtlogit dum_fat_total_5 `controls' ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_5 `controls' rate_ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_5 `controls' dum_pos_ligmean_change_0908, fe 
esttab using 2_lights_log_above5.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Logit (FE) Models, Alternative Threshold for Outcome Variable (5)) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)   replace
eststo clear

* Table 3: Threshold 10
eststo: xtlogit dum_fat_total_10 `controls' ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_10 `controls' rate_ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_10 `controls' dum_pos_ligmean_change_0908, fe 
esttab using 3_lights_log_above10.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Logit (FE) Models, Alternative Threshold for Outcome Variable (10)) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)   replace
eststo clear

* Table 4: Threshold 20
eststo: xtlogit dum_fat_total_20 `controls' ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_20 `controls' rate_ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_20 `controls' dum_pos_ligmean_change_0908, fe 
esttab using 4_lights_log_above20.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Logit (FE) Models, Alternative Threshold for Outcome Variable (20)) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)   replace
eststo clear

* Table 5: Threshold 50
eststo: xtlogit dum_fat_total_50 `controls' ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_50 `controls' rate_ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_50 `controls' dum_pos_ligmean_change_0908, fe 
esttab using 5_lights_log_above50.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Logit (FE) Models, Alternative Threshold for Outcome Variable (50)) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)   replace
eststo clear

* Table 6: Logit estimations with alternative dependent variable (early violence only) 
eststo: xtlogit dum_fat_mar_feb_25 `controls' ligmean_change_0907, fe 
eststo: xtlogit dum_fat_mar_feb_25 `controls' rate_ligmean_change_0907, fe 
eststo: xtlogit dum_fat_mar_feb_25 `controls' dum_pos_ligmean_change_0908, fe 
esttab using 6_lights_log_earlyviol.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Logit (FE) Models, Early Violence Only (March 2011 - February 2012)) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)   replace
eststo clear

* Table 7: Negative Binomial Regression, fixed effects
eststo: xtnbreg totaldeath `controls' ligmean_change_0907, fe 
eststo: xtnbreg totaldeath `controls' rate_ligmean_change_0907, fe
eststo: xtnbreg totaldeath `controls' dum_pos_ligmean_change_0908, fe
esttab using 7_lights_nbreg_fe.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Negative Binomial (FE) Models) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)  replace
eststo clear

* Table 8: Negative Binomial Regression, clustered standard error, governorate dummy-variables
eststo: nbreg totaldeath `controls' ligmean_change_0907 dumgov*, r cluster (gov_id)
eststo: nbreg totaldeath `controls' rate_ligmean_change_0907 dumgov*, r cluster (gov_id)
eststo: nbreg totaldeath `controls' dum_pos_ligmean_change_0908 dumgov*, r cluster (gov_id)
esttab using 8_lights_nbreg_rcluster.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Negative Binomial Models, Governorate Dummies, Robust Clustered Standard Errors) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001) replace
eststo clear

* Table 9: Nbreg models with GDELT data, fixed effects
eststo: xtnbreg gdelt5 `controls' ligmean_change_0907, fe 
eststo: xtnbreg gdelt5 `controls' rate_ligmean_change_0907, fe
eststo: xtnbreg gdelt5 `controls' dum_pos_ligmean_change_0908, fe
esttab using 9_lights_gdelt_nbreg_fe.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Negative Binomial (FE) Models Using GDELT Data) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)  replace
eststo clear

* Table 10: Logit estimations without sub-districts containing governorate capitals
eststo: xtlogit dum_fat_total_25 `controls' ligmean_change_0907 if  dum_gov_capital != 1, fe 
eststo: xtlogit dum_fat_total_25 `controls' rate_ligmean_change_0907 if  dum_gov_capital != 1, fe 
eststo: xtlogit dum_fat_total_25 `controls' dum_pos_ligmean_change_0908 if  dum_gov_capital != 1, fe 
esttab using 10_lights_main_withoutgovcap.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Main Logit (FE) Models, Without Subdistricts Containing Governorate Capitals) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)   replace
eststo clear

** Robustness checks - alternative explanations for associations between nightlight losses and violence 

* Table 11: Logit estimations without oil/gas producing governorates 
eststo: xtlogit dum_fat_total_25 `controls' ligmean_change_0907 if  dum_gov_oilgas != 1, fe 
eststo: xtlogit dum_fat_total_25 `controls' rate_ligmean_change_0907 if  dum_gov_oilgas != 1, fe 
eststo: xtlogit dum_fat_total_25 `controls' dum_pos_ligmean_change_0908 if  dum_gov_oilgas != 1, fe 
esttab using 11_lights_main_nogasoil.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Main Logit (FE) Models, Without Oil or Gas Producing Governorates) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)   replace
eststo clear

* Table 12: Logit estimations controlling for share of industrial workers
eststo: xtlogit dum_fat_total_25 `controls' sc_industrial_workers ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_25 `controls' sc_industrial_workers rate_ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_25 `controls' sc_industrial_workers dum_pos_ligmean_change_0908, fe 
esttab using 12_lights_main_industrial.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Main Logit (FE) Models, Additional Control for Share of Industrial Workers) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)   replace
eststo clear

* Table 13: Logit estimations controlling for distance to nearest power station
eststo: xtlogit dum_fat_total_25 `controls'  log_dist_powerstation ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_25 `controls'  log_dist_powerstation rate_ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_25 `controls'  log_dist_powerstation dum_pos_ligmean_change_0908, fe 
esttab using 13_lights_main_powerstations.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Main Logit (FE) Models, Additional Control for the Distance to the nearest power station) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)   replace
eststo clear

* Table 14: Logit estimations controlling for house ownership
eststo: xtlogit dum_fat_total_25 `controls'  sc_ownedhouse ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_25 `controls'  sc_ownedhouse rate_ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_25 `controls'  sc_ownedhouse dum_pos_ligmean_change_0908, fe 
esttab using 14_lights_main_houseownership.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Main Logit (FE) Models, Additional Control for House Ownership) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)   replace
eststo clear

* Table 15: Logit governorate fixed effects including fatalities in neighbouring subdistricts 
eststo: xtlogit dum_fat_total_25 `controls' neigh_totaldeath ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_25 `controls' neigh_totaldeath rate_ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_25 `controls' neigh_totaldeath dum_pos_ligmean_change_0908, fe 
esttab using 15_lights_main_withneighviol.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Main Logit (FE) Models, Including Control for Violence in Neighbouring Subdistricts) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001)   replace
eststo clear

* Table 16: Logit governorate fixed effects using Geo-EPR data for ethnic/confessional variables
local controls "sc_emplgov  epr_kurd_sunni_dum epr_arab_sunni_dum epr_alawi_dum sc_enroll611 log_border_dist share_urban_2004 sc_electricity sc_malunempl road_density log_pop_2004"
eststo: xtlogit dum_fat_total_25 `controls' ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_25 `controls' rate_ligmean_change_0907, fe 
eststo: xtlogit dum_fat_total_25 `controls' dum_pos_ligmean_change_0908, fe 
esttab using 16_epr_ethnic_variables.rtf, b(3) p(3) aic scalars(ll) label title(Subdistrict Fatalities Syria - Main Logit (FE) Models, EPR Ethnicity/Religion Variables) nomtitles nodepvars  star(† 0.1 * 0.05 ** 0.01 *** 0.001) replace
eststo clear 

*** Illustrative Predicted Probabilities for Homs and Damascus Governorates

* Homs

quietly logit dum_fat_total_25 sc_emplgov sunni alawites sc_enroll611 log_border_dist share_urban_2004 sc_electricity sc_malunempl road_density log_pop_2004 ligmean_change_0907 dumgov1 dumgov2 dumgov3 dumgov4 dumgov5 dumgov6 dumgov7 dumgov8 dumgov9 dumgov10 dumgov11 dumgov13, r cluster (gov_id)
margins, at(ligmean_change_0907=(-6.612471 -.0230452) alawites= 0 sunni=1 dumgov2=0 dumgov3=0 dumgov4=1 dumgov5=0 dumgov6=0 dumgov7=0 dumgov8=0 dumgov9=0 dumgov10=0 dumgov11=0) atmeans vsquish post
marginsplot

quietly logit dum_fat_total_25 sc_emplgov sunni alawites sc_enroll611 log_border_dist share_urban_2004 sc_electricity sc_malunempl road_density log_pop_2004 rate_ligmean_change_0907 dumgov1 dumgov2 dumgov3 dumgov4 dumgov5 dumgov6 dumgov7 dumgov8 dumgov9 dumgov10 dumgov11 dumgov13, r cluster (gov_id)
margins, at(rate_ligmean_change_0907=(-.4294135 -.0123882) alawites= 0 sunni=1 dumgov2=0 dumgov3=0 dumgov4=1 dumgov5=0 dumgov6=0 dumgov7=0 dumgov8=0 dumgov9=0 dumgov10=0 dumgov11=0) atmeans vsquish post
marginsplot

quietly logit dum_fat_total_25 sc_emplgov sunni alawites sc_enroll611 log_border_dist share_urban_2004 sc_electricity sc_malunempl road_density log_pop_2004  dum_pos_ligmean_change_0908 dumgov1 dumgov2 dumgov3 dumgov4 dumgov5 dumgov6 dumgov7 dumgov8 dumgov9 dumgov10 dumgov11 dumgov13, r cluster (gov_id)
margins, at( dum_pos_ligmean_change_0908=(0 1) alawites= 0 sunni=1 dumgov2=0 dumgov3=0 dumgov4=1 dumgov5=0 dumgov6=0 dumgov7=0 dumgov8=0 dumgov9=0 dumgov10=0 dumgov11=0) atmeans vsquish post
marginsplot

* Damascus

quietly logit dum_fat_total_25 sc_emplgov sunni alawites sc_enroll611 log_border_dist share_urban_2004 sc_electricity sc_malunempl road_density log_pop_2004 ligmean_change_0907 dumgov1 dumgov2 dumgov3 dumgov4 dumgov5 dumgov6 dumgov7 dumgov8 dumgov9 dumgov10 dumgov11 dumgov13, r cluster (gov_id)
margins, at(ligmean_change_0907=(-6.612471 -.0230452) alawites= 0 sunni=1 dumgov2=0 dumgov3=1 dumgov4=0 dumgov5=0 dumgov6=0 dumgov7=0 dumgov8=0 dumgov9=0 dumgov10=0 dumgov11=0) atmeans vsquish post
marginsplot

quietly logit dum_fat_total_25 sc_emplgov sunni alawites sc_enroll611 log_border_dist share_urban_2004 sc_electricity sc_malunempl road_density log_pop_2004 rate_ligmean_change_0907 dumgov1 dumgov2 dumgov3 dumgov4 dumgov5 dumgov6 dumgov7 dumgov8 dumgov9 dumgov10 dumgov11 dumgov13, r cluster (gov_id)
margins, at(rate_ligmean_change_0907=(-.4294135 -.0123882) alawites= 0 sunni=1 dumgov2=0 dumgov3=1 dumgov4=0 dumgov5=0 dumgov6=0 dumgov7=0 dumgov8=0 dumgov9=0 dumgov10=0 dumgov11=0) atmeans vsquish post
marginsplot

quietly logit dum_fat_total_25 sc_emplgov sunni alawites sc_enroll611 log_border_dist share_urban_2004 sc_electricity sc_malunempl road_density log_pop_2004  dum_pos_ligmean_change_0908 dumgov1 dumgov2 dumgov3 dumgov4 dumgov5 dumgov6 dumgov7 dumgov8 dumgov9 dumgov10 dumgov11 dumgov13, r cluster (gov_id)
margins, at( dum_pos_ligmean_change_0908=(0 1) alawites= 0 sunni=1 dumgov2=0 dumgov3=1 dumgov4=0 dumgov5=0 dumgov6=0 dumgov7=0 dumgov8=0 dumgov9=0 dumgov10=0 dumgov11=0) atmeans vsquish post
marginsplot
