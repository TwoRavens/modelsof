// Replication do file
// Predicting the decline of ethnic war
// Lars-Erik Cederman, Kristian Skrede Gleditsch and Julian Wuchperpfennig
// Article accepted for publication in the Journal of Peace Research
// 
// February 7, 2017
//



use decline_data_jpr.dta

label variable onset_do_flag "onset"
label variable warend "resolution"
label variable egip "inclusion"
label variable warhist1 "past wars"
label variable upfrom_disc "group rights"
label variable upto_aut "autonomy"
label variable upto_incl "inclusion"
label variable upto_dem "democratization"
label variable pko "peacekeeping"
label variable b "relative group size"
label variable b2 "relative group size$^2$"
label variable excl_groups_count "number of excl. groups"
label variable ln_rgdppc_lag "log gdp lag"
label variable ln_pop "log population"
label variable c_incidence_flagl "ongoing conflict"
label variable family_peaceyears "peaceyears"
label variable family_peaceyears2 "peaceyears$^2$"
label variable family_peaceyears3 "peaceyears$^3$"
label variable waryears "waryears"
label variable waryears2 "waryears$^2$"
label variable waryears3 "waryears$^3$"


eststo clear
eststo: logit onset_do_flag upfrom_disc b b2 warhist1 ln_rgdppc_lag ln_pop family_peaceyears* if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & gurr==1 & (status_discrim==1 | upfrom_disc==1), nolog cluster(cowcode)
eststo: logit onset_do_flag upto_aut b b2 warhist1 ln_rgdppc_lag ln_pop family_peaceyears* if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & gurr==1 & ((regaut==0 & excluded==1) | upto_aut==1), nolog cluster(cowcode)
eststo: logit onset_do_flag upto_incl b b2 warhist1 ln_rgdppc_lag ln_pop family_peaceyears* if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & gurr==1 & (excluded==1 | upto_incl==1), nolog cluster(cowcode)
eststo: logit onset_do_flag upto_dem b b2 warhist1 ln_rgdppc_lag ln_pop family_peaceyears* if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & gurr==1 & (nondem_pol==1 | upto_dem==1), nolog cluster(cowcode)
eststo: logit onset_do_flag pko b b2 warhist1 ln_rgdppc_lag ln_pop family_peaceyears* if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & gurr==1, nolog cluster(cowcode)
esttab using "decline_tab1.tex", nodepvars nonumbers mtitles("Model 1a" "Model 1b" "Model 1c" "Model 1d" "Model 1e") se label replace star(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(family_peaceyears2 family_peaceyears3) order(upfrom_disc upto_aut upto_incl upto_dem pko b b2 warhist1 ln_rgdppc_lag ln_pop family_peaceyears) booktabs ///
   title(The effect of accommodation on ethnic conflict onset\label{tab1})



eststo clear
eststo: logit warend upfrom_disc b b2 ln_rgdppc_lag ln_pop waryears* if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & gurr==1 & (status_discrim==1 | upfrom_disc==1), nolog cluster(cowcode)
eststo: logit warend upto_aut b b2 ln_rgdppc_lag ln_pop waryears* if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & gurr==1 & ((regaut==0 & excluded==1) | upto_aut==1), nolog cluster(cowcode)
eststo: logit warend upto_incl b b2 ln_rgdppc_lag ln_pop waryears* if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & gurr==1 & (excluded==1 | upto_incl==1), nolog cluster(cowcode)
eststo: logit warend upto_dem b b2 ln_rgdppc_lag ln_pop waryears* if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & gurr==1 & (nondem_pol==1 | upto_dem==1), nolog cluster(cowcode)
eststo: logit warend pko b b2 ln_rgdppc_lag ln_pop waryears* if isrelevant == 1 & status_monop == 0 & status_dominant == 0 & gurr==1, nolog cluster(cowcode)
esttab using "decline_tab2.tex", nodepvars nonumbers mtitles("Model 1a" "Model 1b" "Model 1c" "Model 1d" "Model 1e") se label replace star(+ 0.10 * 0.05 ** 0.01 *** 0.001) drop(waryears2 waryears3) order(upfrom_disc upto_aut upto_incl upto_dem pko b b2 ln_rgdppc_lag ln_pop waryears) booktabs ///
   title(The effect of accommodation on ethnic conflict termination\label{tab2})

