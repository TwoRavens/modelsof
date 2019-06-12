/* "Does Threatening their Franchise Make Registered Voters More Likely to Participate? 
  Evidence from an Aborted Voter Purge"
 Daniel R. Biggers and Daniel A. Smith
 British Journal of Political Science
 
 ******************************************************

 This Stata .do file performs all of the analyses
 and recreates the tables in both the main text and
 supplemental appendix.

******************************************************/

set more off
set matsize 11000

*set working directory, start log file, and load data.
cd ""
log using logs\run_main_do_file.log, replace
use data\biggers_smith_bjps_main_data, clear

*text comment on turnout between treatment and control groups.
tab voted2012G_dummy challengelist_dummy, col

/*text comment on how many registrants in the data analyzed "paid voter purge
voting costs" (i.e., proved their citizenship before the purge was halted).*/
tab proved_citizen


**********************************************************************
*Table 1 - Voter file characteristics of sample by treatment assignment.
**********************************************************************

*(8) Generate Table 1.
outsum voted2012PP_dummy- voted2004G_dummy female gen_unk black white hispanic asian race_other age reg_y dem rep other_p act_v if challengelist_dummy==0 using tables\Table1.out, bracket addnote("Note: Columns (1) and (2) report means with standard deviations in brackets. Column (3) reports difference in means test for age and registration year, and difference in proportions test for all other variables (standard errors in brackets). *** p<0.01, ** p<0.05, * p<0.1") title("Table 1. Sample Characteristics based on Covariates in Florida Voter File") ctitle("Suspect List, Not Challenged") replace
outsum voted2012PP_dummy- voted2004G_dummy female gen_unk black white hispanic asian race_other age reg_y dem rep other_p act_v if challengelist_dummy==1 using tables\Table1.out, bracket ctitle("Suspect List, Challenged") append

prtest voted2012PP_dummy, by(challengelist_dummy)
prtest voted2011S_june_dummy, by(challengelist_dummy)
prtest voted2011S_may_dummy, by(challengelist_dummy)
prtest voted2011S_march_dummy, by(challengelist_dummy)
prtest voted2010G_dummy, by(challengelist_dummy)
prtest voted2010P_dummy, by(challengelist_dummy)
prtest voted2008S_dec_dummy, by(challengelist_dummy)
prtest voted2008G_dummy, by(challengelist_dummy)
prtest voted2008P_dummy, by(challengelist_dummy)
prtest voted2008PP_dummy, by(challengelist_dummy)
prtest voted2007S_jan_dummy, by(challengelist_dummy)
prtest voted2006G_dummy, by(challengelist_dummy)
prtest voted2006P_dummy, by(challengelist_dummy)
prtest voted2005S_march_dummy, by(challengelist_dummy)
prtest voted2004G_dummy, by(challengelist_dummy)
prtest voted2004PP_dummy, by(challengelist_dummy)
prtest voted2004P_dummy, by(challengelist_dummy)
prtest female, by(challengelist_dummy)
prtest gen_unk, by(challengelist_dummy)
prtest black, by(challengelist_dummy)
prtest hispanic, by(challengelist_dummy)
prtest white, by(challengelist_dummy)
prtest asian, by(challengelist_dummy)
prtest race_other, by(challengelist_dummy)
ttest age, by(challengelist_dummy)
ttest reg_y, by(challengelist_dummy)
prtest dem, by(challengelist_dummy)
prtest rep, by(challengelist_dummy)
prtest other_p, by(challengelist_dummy)
prtest act_v, by(challengelist_dummy)

**********************************************************************
*Table 2 analyses - Entire Sample
**********************************************************************

/*Run diff-in-diff analysis for columns 1-4.
Duplicate sample, then assign original observations to correspond to whether the
registrant voted in 2012 and new observations to correspond to whether the registrant
voted in 2008 (2010)*/

preserve
gen temp_id=_n
expand 2, gen(obs_2012)
label values obs_2012 yesno
label variable obs_2012 "Observation Corresponds to 2012 Vote? (1=yes)"

*gen 2008 vs. 2012 DV.
gen diff_in_diff_dv2008=voted2012G if obs_2012==1
replace diff_in_diff_dv2008=voted2008G if obs_2012==0
gen challengelist_dummy_obs_2012=challengelist_dummy*obs_2012

reg diff_in_diff_dv2008 challengelist_dummy obs_2012 challengelist_dummy_obs_2012, cluster(temp_id)
outreg2 using tables\Table2.out, bracket dec(3) replace

reg diff_in_diff_dv2008 challengelist_dummy obs_2012 challengelist_dummy_obs_2012 voted2012PP_dummy-voted2008P_dummy voted2008S_dec_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\Table2.out, bracket dec(3) append

*gen 2010 vs. 2012 DV.
gen diff_in_diff_dv2010=voted2012G if obs_2012==1
replace diff_in_diff_dv2010=voted2010G if obs_2012==0

reg diff_in_diff_dv2010 challengelist_dummy obs_2012 challengelist_dummy_obs_2012, cluster(temp_id)
outreg2 using tables\Table2.out, bracket dec(3) append

reg diff_in_diff_dv2010 challengelist_dummy obs_2012 challengelist_dummy_obs_2012 voted2012PP_dummy- voted2010P_dummy voted2008PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\Table2.out, bracket dec(3) append

restore

*text comment: Percentage of treatment and control who registered after the 2008 general eleciton but before the 2010 general eleciton
count if reg_2008to2010==1 & challengelist_dummy==0
count if reg_2008to2010==1 & challengelist_dummy==1

*footnote explaining why we do not coarsen registration year in matching analysis, as the vast majority of the sample is recent registrants.
count if challengelist_dummy==0 & reg_y<=2003
count if challengelist_dummy==1 & reg_y<=2003

count if challengelist_dummy==0 & reg_y<=2007
count if challengelist_dummy==1 & reg_y<=2007


*run matching analysis for columns 5-10.

*exact match on age.
cem voted2012PP_dummy voted2011S_june_dummy voted2011S_may_dummy voted2011S_march_dummy voted2010P_dummy voted2010G_dummy voted2008PP_dummy voted2008P_dummy voted2008G_dummy voted2008S_dec_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age(#0) reg_y(#0) dem rep act_v other_p, treatment(challengelist_dummy)
rename cem_strata cem_strata_exact
rename cem_matched cem_match_exact
rename cem_weights cem_weights_exact

reg voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v [iweight= cem_weights_exact], r
outreg2 using tables/Table2.out, bracket dec(3) append
reg voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact], r
outreg2 using tables/Table2.out, bracket dec(3) append

*CEM match on age (3 year bins).
cem voted2012PP_dummy voted2011S_june_dummy voted2011S_may_dummy voted2011S_march_dummy voted2010P_dummy voted2010G_dummy voted2008PP_dummy voted2008P_dummy voted2008G_dummy voted2008S_dec_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age(#30) reg_y(#0) dem rep act_v other_p, treatment(challengelist_dummy)
rename cem_strata cem_strata_age3
rename cem_matched cem_match_age3
rename cem_weights cem_weights_age3

reg voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v [iweight= cem_weights_age3], r
outreg2 using tables\Table2.out, bracket dec(3) append
reg voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_age3], r
outreg2 using tables\Table2.out, bracket dec(3) append

*CEM match on age (default algorithm; translates to 5 year bins).
cem voted2012PP_dummy voted2011S_june_dummy voted2011S_may_dummy voted2011S_march_dummy voted2010P_dummy voted2010G_dummy voted2008PP_dummy voted2008P_dummy voted2008G_dummy voted2008S_dec_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age reg_y(#0) dem rep act_v other_p, treatment(challengelist_dummy)
rename cem_strata cem_strata_agecem
rename cem_matched cem_match_agecem
rename cem_weights cem_weights_agecem

reg voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v [iweight= cem_weights_agecem], r
outreg2 using tables/Table2.out, bracket dec(3) append
reg voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_agecem], r
outreg2 using tables/Table2.out, bracket dec(3) append


**********************************************************************
*Table SA3. Table 2 Logit Models.
**********************************************************************

*run diff-in-diff analysis for columns 1-4.

preserve
gen temp_id=_n
expand 2, gen(obs_2012)
label values obs_2012 yesno
label variable obs_2012 "Observation Corresponds to 2012 Vote? (1=yes)"

*gen 2008 vs. 2012 DV.
gen diff_in_diff_dv2008=voted2012G if obs_2012==1
replace diff_in_diff_dv2008=voted2008G if obs_2012==0
gen challengelist_dummy_obs_2012=challengelist_dummy*obs_2012

logit diff_in_diff_dv2008 challengelist_dummy obs_2012 challengelist_dummy_obs_2012, cluster(temp_id)
outreg2 using tables\TableSA3_Table2_Logit.out, bracket dec(3) replace
logit diff_in_diff_dv2008 challengelist_dummy obs_2012 challengelist_dummy_obs_2012 voted2012PP_dummy-voted2008P_dummy voted2008S_dec_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\TableSA3_Table2_Logit.out, bracket dec(3) append

*gen 2010 vs. 2012 DV.
gen diff_in_diff_dv2010=voted2012G if obs_2012==1
replace diff_in_diff_dv2010=voted2010G if obs_2012==0

logit diff_in_diff_dv2010 challengelist_dummy obs_2012 challengelist_dummy_obs_2012, cluster(temp_id)
outreg2 using tables\TableSA3_Table2_Logit.out, bracket dec(3) append
logit diff_in_diff_dv2010 challengelist_dummy obs_2012 challengelist_dummy_obs_2012 voted2012PP_dummy- voted2010P_dummy voted2008PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\TableSA3_Table2_Logit.out, bracket dec(3) append

restore

*run matching analysis for columns 5-10.

*exact match on age.
logit voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v [iweight= cem_weights_exact], r
outreg2 using tables\TableSA3_Table2_Logit.out, bracket dec(3) append
logit voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact], r
outreg2 using tables\TableSA3_Table2_Logit.out, bracket dec(3) append

*CEM match on age (3 year bins).
logit voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v [iweight= cem_weights_age3], r
outreg2 using tables\TableSA3_Table2_Logit.out, bracket dec(3) append
logit voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_age3], r
outreg2 using tables\TableSA3_Table2_Logit.out, bracket dec(3) append

*CEM match on age (default algorithm; translates to 5 year bins).
logit voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v [iweight= cem_weights_agecem], r
outreg2 using tables\TableSA3_Table2_Logit.out, bracket dec(3) append
logit voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_agecem], r
outreg2 using tables\TableSA3_Table2_Logit.out, bracket dec(3) append


**********************************************************************
*Table SA4 - Table 2 using cross-sectional analysis.
**********************************************************************

reg voted2012G challengelist_dummy, r
outreg2 using tables\TableSA4_Table2Cross.out, bracket dec(3) replace
reg voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v, r
outreg2 using tables\TableSA4_Table2Cross.out, bracket dec(3) append
reg voted2012G challengelist_dummy voted2012PP_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct, r
outreg2 using tables\TableSA4_Table2Cross.out, bracket dec(3) append


**********************************************************************
*Table SA5 - Voter file characteristics of sample by treatment assignment, Hispanics only.
**********************************************************************

outsum voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v if challengelist_dummy==0 & hispanic==1 using tables\TableSA5_PopCrosstabs.out, bracket addnote("Note: Columns (1) and (2) report means with standard deviations in brackets. Column (3) reports difference in means test for age and registration year, and difference in proportions test for all other variables (standard errors in brackets). *** p<0.01, ** p<0.05, * p<0.1") title("Table SA5. Sample Characteristics based on Covariates in Florida Voter File, Latinos Only") ctitle("Suspect List, Not Challenged") replace
outsum voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v if challengelist_dummy==1 & hispanic==1 using tables\TableSA5_PopCrosstabs.out, bracket ctitle("Suspect List, Challenged") append

prtest voted2012PP_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2011S_june_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2011S_may_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2011S_march_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2010G_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2010P_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2008S_dec_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2008G_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2008P_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2008PP_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2007S_jan_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2006G_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2006P_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2005S_march_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2004G_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2004PP_dummy if hispanic==1, by(challengelist_dummy)
prtest voted2004P_dummy if hispanic==1, by(challengelist_dummy)
prtest female if hispanic==1, by(challengelist_dummy)
prtest gen_unk if hispanic==1, by(challengelist_dummy)
ttest age if hispanic==1, by(challengelist_dummy)
ttest reg_y if hispanic==1, by(challengelist_dummy)
prtest dem if hispanic==1, by(challengelist_dummy)
prtest rep if hispanic==1, by(challengelist_dummy)
prtest other_p if hispanic==1, by(challengelist_dummy)
prtest act_v if hispanic==1, by(challengelist_dummy)


**********************************************************************
*Table 3 analyses - Race/Ethnicity Interactions
**********************************************************************

*run diff-in-diff analysis for columns 1-4.
preserve
gen temp_id=_n
expand 2, gen(obs_2012)

gen cl_white=challengelist_dummy*white
gen cl_black=challengelist_dummy*black
gen cl_rother=challengelist_dummy*race_other
gen cl_asian=challengelist_dummy*asian

gen white_diffdv=white*obs_2012
gen black_diffdv=black*obs_2012
gen rother_diffdv=race_other*obs_2012
gen asian_diffdv=asian*obs_2012

gen white_diffdv_cl=white*obs_2012*challengelist_dummy
gen black_diffdv_cl=black*obs_2012*challengelist_dummy
gen rother_diffdv_cl=race_other*obs_2012*challengelist_dummy
gen asian_diffdv_cl=asian*obs_2012*challengelist_dummy

*gen 2008 vs. 2012 DV.
gen diff_in_diff_dv=voted2012G if obs_2012==1
replace diff_in_diff_dv=voted2008G if obs_2012==0
gen challengelist_dummy_diffdv=challengelist_dummy*obs_2012

reg diff_in_diff_dv challengelist_dummy obs_2012 challengelist_dummy_diffdv white black race_other asian cl_white-asian_diffdv_cl, cluster(temp_id)
outreg2 using tables\Table3.out, bracket dec(3) replace

lincom challengelist_dummy_diffdv+asian_diffdv_cl
lincom challengelist_dummy_diffdv+white_diffdv_cl
lincom challengelist_dummy_diffdv+black_diffdv_cl
lincom challengelist_dummy_diffdv+rother_diffdv_cl

reg diff_in_diff_dv challengelist_dummy obs_2012 challengelist_dummy_diffdv white black race_other asian cl_white-asian_diffdv_cl voted2012PP_dummy-voted2008P_dummy voted2008S_dec_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\Table3.out, bracket dec(3) append

lincom challengelist_dummy_diffdv+asian_diffdv_cl
lincom challengelist_dummy_diffdv+white_diffdv_cl
lincom challengelist_dummy_diffdv+black_diffdv_cl
lincom challengelist_dummy_diffdv+rother_diffdv_cl

*gen 2010 vs. 2012 DV.
gen diff_in_diff_dv2010=voted2012G if obs_2012==1
replace diff_in_diff_dv2010=voted2010G if obs_2012==0

reg diff_in_diff_dv2010 challengelist_dummy obs_2012 challengelist_dummy_diffdv white black race_other asian cl_white-asian_diffdv_cl, cluster(temp_id)
outreg2 using tables\Table3.out, bracket dec(3) append

lincom challengelist_dummy_diffdv+asian_diffdv_cl
lincom challengelist_dummy_diffdv+white_diffdv_cl
lincom challengelist_dummy_diffdv+black_diffdv_cl
lincom challengelist_dummy_diffdv+rother_diffdv_cl

reg diff_in_diff_dv2010 challengelist_dummy obs_2012 challengelist_dummy_diffdv white black race_other asian cl_white-asian_diffdv_cl voted2012PP_dummy- voted2010P_dummy voted2008PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\Table3.out, bracket dec(3) append

lincom challengelist_dummy_diffdv+asian_diffdv_cl
lincom challengelist_dummy_diffdv+white_diffdv_cl
lincom challengelist_dummy_diffdv+black_diffdv_cl
lincom challengelist_dummy_diffdv+rother_diffdv_cl

restore

*run matching analysis for columns 5-10.

gen cl_white=challengelist_dummy*white
gen cl_black=challengelist_dummy*black
gen cl_rother=challengelist_dummy*race_other
gen cl_asian=challengelist_dummy*asian

*exact match on age.
reg voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v [iweight= cem_weights_exact], r
tab hispanic if challengelist_dummy==1 & e(sample)
outreg2 using tables\Table3.out, bracket dec(3) append
lincom challengelist_dummy + cl_white
lincom challengelist_dummy + cl_black
lincom challengelist_dummy + cl_rother
lincom challengelist_dummy + cl_asian

reg voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact], r
outreg2 using tables\Table3.out, bracket dec(3) append
lincom challengelist_dummy + cl_white
lincom challengelist_dummy + cl_black
lincom challengelist_dummy + cl_rother
lincom challengelist_dummy + cl_asian

*CEM match on age (3 year bins).
reg voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v [iweight= cem_weights_age3], r
tab hispanic if challengelist_dummy==1 & e(sample)
outreg2 using tables\Table3.out, bracket dec(3) append
lincom challengelist_dummy + cl_white
lincom challengelist_dummy + cl_black
lincom challengelist_dummy + cl_rother
lincom challengelist_dummy + cl_asian

reg voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_age3], r
outreg2 using tables\Table3.out, bracket dec(3) append
lincom challengelist_dummy + cl_white
lincom challengelist_dummy + cl_black
lincom challengelist_dummy + cl_rother
lincom challengelist_dummy + cl_asian

*CEM match on age (default algorithm; translates to 5 year bins).
reg voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v [iweight= cem_weights_agecem], r
tab hispanic if challengelist_dummy==1 & e(sample)
outreg2 using tables\Table3.out, bracket dec(3) append
lincom challengelist_dummy + cl_white
lincom challengelist_dummy + cl_black
lincom challengelist_dummy + cl_rother
lincom challengelist_dummy + cl_asian

reg voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_agecem], r
outreg2 using tables\Table3.out, bracket dec(3) append
lincom challengelist_dummy + cl_white
lincom challengelist_dummy + cl_black
lincom challengelist_dummy + cl_rother
lincom challengelist_dummy + cl_asian


**********************************************************************
*Table SA7. Table 3 Logit Models.
**********************************************************************

*run diff-in-diff analysis for columns 1-4.
preserve
gen temp_id=_n
expand 2, gen(obs_2012)

gen white_diffdv=white*obs_2012
gen black_diffdv=black*obs_2012
gen rother_diffdv=race_other*obs_2012
gen asian_diffdv=asian*obs_2012

gen white_diffdv_cl=white*obs_2012*challengelist_dummy
gen black_diffdv_cl=black*obs_2012*challengelist_dummy
gen rother_diffdv_cl=race_other*obs_2012*challengelist_dummy
gen asian_diffdv_cl=asian*obs_2012*challengelist_dummy

*gen 2008 vs. 2012 DV.
gen diff_in_diff_dv=voted2012G if obs_2012==1
replace diff_in_diff_dv=voted2008G if obs_2012==0
gen challengelist_dummy_diffdv=challengelist_dummy*obs_2012

logit diff_in_diff_dv challengelist_dummy obs_2012 challengelist_dummy_diffdv white black race_other asian cl_white-cl_asian white_diffdv-asian_diffdv_cl, cluster(temp_id)
outreg2 using tables\TableSA7_Table3_Logit.out, bracket dec(3) replace
logit diff_in_diff_dv challengelist_dummy obs_2012 challengelist_dummy_diffdv white black race_other asian cl_white-cl_asian white_diffdv-asian_diffdv_cl voted2012PP_dummy-voted2008P_dummy voted2008S_dec_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\TableSA7_Table3_Logit.out, bracket dec(3) append

*gen 2010 vs. 2012 DV.
gen diff_in_diff_dv2010=voted2012G if obs_2012==1
replace diff_in_diff_dv2010=voted2010G if obs_2012==0

logit diff_in_diff_dv2010 challengelist_dummy obs_2012 challengelist_dummy_diffdv white black race_other asian cl_white-cl_asian white_diffdv-asian_diffdv_cl, cluster(temp_id)
outreg2 using tables\TableSA7_Table3_Logit.out, bracket dec(3) append
logit diff_in_diff_dv2010 challengelist_dummy obs_2012 challengelist_dummy_diffdv white black race_other asian cl_white-cl_asian white_diffdv-asian_diffdv_cl voted2012PP_dummy- voted2010P_dummy voted2008PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\TableSA7_Table3_Logit.out, bracket dec(3) append

restore

*exact match on age.
logit voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v [iweight= cem_weights_exact], r
outreg2 using tables\TableSA7_Table3_Logit.out, bracket dec(3) append
logit voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact], r
outreg2 using tables\TableSA7_Table3_Logit.out, bracket dec(3) append

*CEM match on age (3 year bins).
logit voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v [iweight= cem_weights_age3], r
outreg2 using tables\TableSA7_Table3_Logit.out, bracket dec(3) append
logit voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_age3], r
outreg2 using tables\TableSA7_Table3_Logit.out, bracket dec(3) append

*CEM match on age (default algorithm; translates to 5 year bins).
logit voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v [iweight= cem_weights_agecem], r
outreg2 using tables\TableSA7_Table3_Logit.out, bracket dec(3) append
logit voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_agecem], r
outreg2 using tables\TableSA7_Table3_Logit.out, bracket dec(3) append


**********************************************************************
*Table SA8 - Table 3 using cross-sectional analysis.
**********************************************************************

reg voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian, r
outreg2 using tables\TableSA8_Table3Cross.out, bracket dec(3) replace
reg voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v, r
outreg2 using tables\TableSA8_Table3Cross.out, bracket dec(3) append
lincom challengelist_dummy + cl_white
lincom challengelist_dummy + cl_black
lincom challengelist_dummy + cl_rother
lincom challengelist_dummy + cl_asian
reg voted2012G challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2012PP_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct, r
outreg2 using tables\TableSA8_Table3Cross.out, bracket dec(3) append
lincom challengelist_dummy + cl_white
lincom challengelist_dummy + cl_black
lincom challengelist_dummy + cl_rother
lincom challengelist_dummy + cl_asian


**********************************************************************
*Table 4A - Placebo Tests Entire Sample
**********************************************************************

*run diff-in-diff analysis for columns 1-3.
preserve
gen temp_id=_n
expand 2, gen(obs_2ndelection)
label values obs_2ndelection yesno
label variable obs_2ndelection "Observation Corresponds to 2nd Election Vote? (1=yes)"

gen diff_in_diff_placebo0408=voted2008G if obs_2ndelection==1
replace diff_in_diff_placebo0408=voted2004G if obs_2ndelection==0
gen challengelistdummy_obs_2nde=challengelist_dummy*obs_2ndelection
reg diff_in_diff_placebo0408 challengelist_dummy obs_2ndelection challengelistdummy_obs_2nde voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy- voted2004P_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\Table4A_TableSA9.out, bracket dec(3) replace

gen diff_in_diff_placebo0610=voted2010G if obs_2ndelection==1
replace diff_in_diff_placebo0610=voted2006G if obs_2ndelection==0
reg diff_in_diff_placebo0610 challengelist_dummy obs_2ndelection challengelistdummy_obs_2nde voted2010P_dummy voted2008PP_dummy- voted2006P_dummy voted2005S_march_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\Table4A_TableSA9.out, bracket dec(3) append

gen diff_in_diff_placebo0810=voted2010G if obs_2ndelection==1
replace diff_in_diff_placebo0810=voted2008G if obs_2ndelection==0
reg diff_in_diff_placebo0810 challengelist_dummy obs_2ndelection challengelistdummy_obs_2nde voted2010P_dummy voted2008PP_dummy voted2008P_dummy voted2008S_dec_dummy- voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\Table4A_TableSA9.out, bracket dec(3) append

restore

*run matching analysis for columns 4-9.

*2008 - exact match on age.
cem voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age(#0) reg_y(#0) dem rep other_p act_v, treatment(challengelist_dummy)
rename cem_strata cem_strata_exact_2008DV
rename cem_matched cem_match_exact_2008DV
rename cem_weights cem_weights_exact_2008DV
reg voted2008G_dummy challengelist_dummy voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2008DV], r
outreg2 using tables\Table4A_TableSA9.out, bracket dec(3) append

*2010 - exact match on age.
cem voted2010P_dummy voted2008PP_dummy voted2008P_dummy voted2008G_dummy voted2008S_dec_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age(#0) reg_y(#0) dem rep other_p act_v, treatment(challengelist_dummy)
rename cem_strata cem_strata_exact_2010DV
rename cem_matched cem_match_exact_2010DV
rename cem_weights cem_weights_exact_2010DV
reg voted2010G_dummy challengelist_dummy voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2010DV], r
outreg2 using tables\Table4A_TableSA9.out, bracket dec(3) append

*2008 - CEM match on age (3 year bins).
cem voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age(#30) reg_y(#0) dem rep other_p act_v, treatment(challengelist_dummy)
rename cem_strata cem_strata_exact_2008DV_age3
rename cem_matched cem_match_exact_2008DV_age3
rename cem_weights cem_weights_exact_2008DV_age3
reg voted2008G_dummy challengelist_dummy voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2008DV_age3], r
outreg2 using tables\Table4A_TableSA9.out, bracket dec(3) append

*2010 - CEM match on age (3 year bins).
cem voted2010P_dummy voted2008PP_dummy voted2008P_dummy voted2008G_dummy voted2008S_dec_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age(#30) reg_y(#0) dem rep other_p act_v, treatment(challengelist_dummy)
rename cem_strata cem_strata_exact_2010DV_age3
rename cem_matched cem_match_exact_2010DV_age3
rename cem_weights cem_weights_exact_2010DV_age3
reg voted2010G_dummy challengelist_dummy voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2010DV_age3], r
outreg2 using tables\Table4A_TableSA9.out, bracket dec(3) append

*2008 - CEM match on age (default algorithm; translates to 5 year bins).
cem voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age reg_y(#0) dem rep other_p act_v, treatment(challengelist_dummy)
rename cem_strata cem_strata_exact_2008DV_cem
rename cem_matched cem_match_exact_2008DV_cem
rename cem_weights cem_weights_exact_2008DV_cem
reg voted2008G_dummy challengelist_dummy voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2008DV_cem], r
outreg2 using tables\Table4A_TableSA9.out, bracket dec(3) append

*2010 - CEM match on age (default algorithm; translates to 5 year bins).
cem voted2010P_dummy voted2008PP_dummy voted2008P_dummy voted2008G_dummy voted2008S_dec_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age reg_y(#0) dem rep other_p act_v, treatment(challengelist_dummy)
rename cem_strata cem_strata_exact_2010DV_cem
rename cem_matched cem_match_exact_2010DV_cem
rename cem_weights cem_weights_exact_2010DV_cem
reg voted2010G_dummy challengelist_dummy voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2010DV_cem], r
outreg2 using tables\Table4A_TableSA9.out, bracket dec(3) append


**********************************************************************
*Table 4B - Placebo Tests for Hispanic Interaction
**********************************************************************

*run diff-in-diff analysis for columns 1-3.
preserve
gen temp_id=_n
expand 2, gen(obs_2ndelection)
label values obs_2ndelection yesno
label variable obs_2ndelection "Observation Corresponds to 2nd Election Vote? (1=yes)"

gen white_diffdv=white*obs_2ndelection
gen black_diffdv=black*obs_2ndelection
gen rother_diffdv=race_other*obs_2ndelection
gen asian_diffdv=asian*obs_2ndelection

gen white_diffdv_cl=white*obs_2ndelection*challengelist_dummy
gen black_diffdv_cl=black*obs_2ndelection*challengelist_dummy
gen rother_diffdv_cl=race_other*obs_2ndelection*challengelist_dummy
gen asian_diffdv_cl=asian*obs_2ndelection*challengelist_dummy

gen diff_in_diff_placebo0408=voted2008G if obs_2ndelection==1
replace diff_in_diff_placebo0408=voted2004G if obs_2ndelection==0
gen challengelistdummy_obs_2nde=challengelist_dummy*obs_2ndelection
reg diff_in_diff_placebo0408 challengelist_dummy obs_2ndelection challengelistdummy_obs_2nde black white race_other asian cl_white-cl_asian white_diffdv-asian_diffdv_cl voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy- voted2004P_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\Table4B_TableSA10.out, bracket dec(3) replace

gen diff_in_diff_placebo0610=voted2010G if obs_2ndelection==1
replace diff_in_diff_placebo0610=voted2006G if obs_2ndelection==0
reg diff_in_diff_placebo0610 challengelist_dummy obs_2ndelection challengelistdummy_obs_2nde black white race_other asian cl_white-cl_asian white_diffdv-asian_diffdv_cl voted2010P_dummy voted2008PP_dummy- voted2006P_dummy voted2005S_march_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\Table4B_TableSA10.out, bracket dec(3) append

gen diff_in_diff_placebo0810=voted2010G if obs_2ndelection==1
replace diff_in_diff_placebo0810=voted2008G if obs_2ndelection==0
reg diff_in_diff_placebo0810 challengelist_dummy obs_2ndelection challengelistdummy_obs_2nde black white race_other asian cl_white-cl_asian white_diffdv-asian_diffdv_cl voted2010P_dummy voted2008PP_dummy voted2008P_dummy voted2008S_dec_dummy- voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct, cluster(temp_id)
outreg2 using tables\Table4B_TableSA10.out, bracket dec(3) append

restore

*run matching analysis for columns 4-9.

*2008 - exact match on age.
reg voted2008G_dummy challengelist_dummy black white race_other asian cl_white-cl_asian voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2008DV], r
outreg2 using tables\Table4B_TableSA10.out, bracket dec(3) append
tab hispanic if challengelist_dummy==1 & e(sample)

*2010 - exact match on age.
reg voted2010G_dummy challengelist_dummy black white race_other asian cl_white-cl_asian voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2010DV], r
outreg2 using tables\Table4B_TableSA10.out, bracket dec(3) append
tab hispanic if challengelist_dummy==1 & e(sample)

*2008 - CEM match on age (3 year bins).
reg voted2008G_dummy challengelist_dummy black white race_other asian cl_white-cl_asian voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2008DV_age3], r
outreg2 using tables\Table4B_TableSA10.out, bracket dec(3) append
tab hispanic if challengelist_dummy==1 & e(sample)

*2010 - CEM match on age (3 year bins).
reg voted2010G_dummy challengelist_dummy black white race_other asian cl_white-cl_asian voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2010DV_age3], r
outreg2 using tables\Table4B_TableSA10.out, bracket dec(3) append
tab hispanic if challengelist_dummy==1 & e(sample)

*2008 - CEM match on age (default algorithm; translates to 5 year bins).
reg voted2008G_dummy challengelist_dummy black white race_other asian cl_white-cl_asian voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2008DV_cem], r
outreg2 using tables\Table4B_TableSA10.out, bracket dec(3) append
tab hispanic if challengelist_dummy==1 & e(sample)

*2010 - CEM match on age (default algorithm; translates to 5 year bins).
reg voted2010G_dummy challengelist_dummy black white race_other asian cl_white-cl_asian voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2010DV_cem], r
outreg2 using tables\Table4B_TableSA10.out, bracket dec(3) append
tab hispanic if challengelist_dummy==1 & e(sample)


**********************************************************************
*Table SA11 - Table 4 using cross-sectional analysis.
**********************************************************************

reg voted2008G_dummy challengelist_dummy white black race_other asian voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct, r
outreg2 using tables\TableSA11_Table4Cross.out, bracket dec(3) replace
reg voted2008G_dummy challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct, r
outreg2 using tables\TableSA11_Table4Cross.out, bracket dec(3) append
reg voted2010G_dummy challengelist_dummy white black race_other asian voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct, r
outreg2 using tables\TableSA11_Table4Cross.out, bracket dec(3) append
reg voted2010G_dummy challengelist_dummy white black race_other asian cl_white cl_black cl_rother cl_asian voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct, r
outreg2 using tables\TableSA11_Table4Cross.out, bracket dec(3) append


*****************************************************************************************************
*Tables SA12 & SA13 - Placebo Tests Entire Sample & Hispanic Interaction (Eligible Registrants Only)
*****************************************************************************************************
/*NOTE: "if" command not allowed with "cem" command. To speed up processing, estimate model for both
tables using sample restriction, then reload the data (as opposed to doing matching twice).*/

*SA12. 2008 - exact match on age.
use data\biggers_smith_bjps_main_data, clear
keep if eligible_reg2008==1
cem voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age(#0) reg_y(#0) dem rep other_p act_v, treatment(challengelist_dummy)
rename cem_strata cem_strata_exact_2008DV_r
rename cem_matched cem_match_exact_2008DV_r
rename cem_weights cem_weights_exact_2008DV_r
reg voted2008G_dummy challengelist_dummy voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2008DV_r], r
outreg2 using tables\TableSA12_Table4ARestricted.out, bracket dec(3) replace

*SA13. 2008 - exact match on age.
gen cl_white=challengelist_dummy*white
gen cl_black=challengelist_dummy*black
gen cl_rother=challengelist_dummy*race_other
gen cl_asian=challengelist_dummy*asian
reg voted2008G_dummy challengelist_dummy black white race_other asian cl_white-cl_asian voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2008DV_r], r
outreg2 using tables\TableSA13_Table4BRestricted.out, bracket dec(3) replace
count if hispanic==1 & challengelist_dummy==1 & e(sample)
count if hispanic==1 & challengelist_dummy==1

*SA12. 2010 - exact match on age.
use data\biggers_smith_bjps_main_data, clear
keep if eligible_reg2010==1
cem voted2010P_dummy voted2008PP_dummy voted2008P_dummy voted2008G_dummy voted2008S_dec_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age(#0) reg_y(#0) dem rep other_p act_v , treatment(challengelist_dummy) 
rename cem_strata cem_strata_exact_2010DV_r
rename cem_matched cem_match_exact_2010DV_r
rename cem_weights cem_weights_exact_2010DV_r
reg voted2010G_dummy challengelist_dummy voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2010DV_r], r
outreg2 using tables\TableSA12_Table4ARestricted.out, bracket dec(3) append

*SA13. 2010 - exact match on age.
gen cl_white=challengelist_dummy*white
gen cl_black=challengelist_dummy*black
gen cl_rother=challengelist_dummy*race_other
gen cl_asian=challengelist_dummy*asian
reg voted2010G_dummy challengelist_dummy black white race_other asian cl_white-cl_asian voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2010DV_r], r
outreg2 using tables\TableSA13_Table4BRestricted.out, bracket dec(3) append
count if hispanic==1 & challengelist_dummy==1 & e(sample)
count if hispanic==1 & challengelist_dummy==1

*SA12. 2008 - CEM match on age (3 year bins).
use data\biggers_smith_bjps_main_data, clear
keep if eligible_reg2008==1
cem voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age(#30) reg_y(#0) dem rep other_p act_v, treatment(challengelist_dummy)
rename cem_strata cem_strata_exact_2008DV_age3_r
rename cem_matched cem_match_exact_2008DV_age3_r
rename cem_weights cem_weights_exact_2008DV_age3_r
reg voted2008G_dummy challengelist_dummy voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2008DV_age3_r], r
outreg2 using tables\TableSA12_Table4ARestricted.out, bracket dec(3) append

*SA13. 2008 - CEM match on age (3 year bins).
gen cl_white=challengelist_dummy*white
gen cl_black=challengelist_dummy*black
gen cl_rother=challengelist_dummy*race_other
gen cl_asian=challengelist_dummy*asian

reg voted2008G_dummy challengelist_dummy black white race_other asian cl_white-cl_asian voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2008DV_age3_r], r
outreg2 using tables\TableSA13_Table4BRestricted.out, bracket dec(3) append
count if hispanic==1 & challengelist_dummy==1 & e(sample)
count if hispanic==1 & challengelist_dummy==1

*SA12. 2010 - CEM match on age (3 year bins).
use data\biggers_smith_bjps_main_data, clear
keep if eligible_reg2010==1
cem voted2010P_dummy voted2008PP_dummy voted2008P_dummy voted2008G_dummy voted2008S_dec_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age(#30) reg_y(#0) dem rep other_p act_v, treatment(challengelist_dummy)
rename cem_strata cem_strata_exact_2010DV_age3_r
rename cem_matched cem_match_exact_2010DV_age3_r
rename cem_weights cem_weights_exact_2010DV_age3_r
reg voted2010G_dummy challengelist_dummy voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2010DV_age3_r], r
outreg2 using tables\TableSA12_Table4ARestricted.out, bracket dec(3) append

*SA13. 2010 - CEM match on age (3 year bins).
gen cl_white=challengelist_dummy*white
gen cl_black=challengelist_dummy*black
gen cl_rother=challengelist_dummy*race_other
gen cl_asian=challengelist_dummy*asian

reg voted2010G_dummy challengelist_dummy black white race_other asian cl_white-cl_asian voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2010DV_age3_r], r
outreg2 using tables\TableSA13_Table4BRestricted.out, bracket dec(3) append
count if hispanic==1 & challengelist_dummy==1 & e(sample)
count if hispanic==1 & challengelist_dummy==1

*SA12. 2008 - CEM match on age (default algorithm; translates to 5 year bins).
use data\biggers_smith_bjps_main_data, clear
keep if eligible_reg2008==1
cem voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age reg_y(#0) dem rep other_p act_v, treatment(challengelist_dummy)
rename cem_strata cem_strata_exact_2008DV_cem_r
rename cem_matched cem_match_exact_2008DV_cem_r
rename cem_weights cem_weights_exact_2008DV_cem_r
reg voted2008G_dummy challengelist_dummy voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2008DV_cem_r], r
outreg2 using tables\TableSA12_Table4ARestricted.out, bracket dec(3) append

*SA13. 2008 - CEM match on age (default algorithm; translates to 5 year bins).
gen cl_white=challengelist_dummy*white
gen cl_black=challengelist_dummy*black
gen cl_rother=challengelist_dummy*race_other
gen cl_asian=challengelist_dummy*asian
reg voted2008G_dummy challengelist_dummy black white race_other asian cl_white-cl_asian voted2008PP_dummy voted2008P_dummy voted2007S_jan_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2008DV_cem_r], r
outreg2 using tables\TableSA13_Table4BRestricted.out, bracket dec(3) append
count if hispanic==1 & challengelist_dummy==1 & e(sample)
count if hispanic==1 & challengelist_dummy==1

*SA12. 2010 - CEM match on age (default algorithm; translates to 5 year bins).
use data\biggers_smith_bjps_main_data, clear
keep if eligible_reg2010==1
cem voted2010P_dummy voted2008PP_dummy voted2008P_dummy voted2008G_dummy voted2008S_dec_dummy voted2007S_jan_dummy voted2006P_dummy voted2006G_dummy voted2005S_march_dummy voted2004PP_dummy voted2004P_dummy voted2004G_dummy female gen_unk black white race_other asian age reg_y(#0) dem rep other_p act_v, treatment(challengelist_dummy)
rename cem_strata cem_strata_exact_2010DV_cem_r
rename cem_matched cem_match_exact_2010DV_cem_r
rename cem_weights cem_weights_exact_2010DV_cem_r
reg voted2010G_dummy challengelist_dummy voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk black white race_other asian age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2010DV_cem], r
outreg2 using tables\TableSA12_Table4ARestricted.out, bracket dec(3) append

*SA13. 2010 - CEM match on age (default algorithm; translates to 5 year bins).
gen cl_white=challengelist_dummy*white
gen cl_black=challengelist_dummy*black
gen cl_rother=challengelist_dummy*race_other
gen cl_asian=challengelist_dummy*asian
reg voted2010G_dummy challengelist_dummy black white race_other asian cl_white-cl_asian voted2010P_dummy voted2008PP_dummy-voted2004G_dummy female gen_unk age reg_y dem rep other_p act_v i.precinct [iweight= cem_weights_exact_2010DV_cem], r
outreg2 using tables\TableSA13_Table4BRestricted.out, bracket dec(3) append
count if hispanic==1 & challengelist_dummy==1 & e(sample)
count if hispanic==1 & challengelist_dummy==1


**********************************************************************
*Is Reactance the Mechanism?" Section - # of 2012 voters who voted in last 4 years or provided proof of citizenship or were determined by state to be citizens
**********************************************************************

count if voted2012G==1 & proved_citizen==1
disp 456/853
count if voted2012G==1 & proved_citizen==1 & hispanic==1
disp 389/704

gen votecount= voted2012PP_dummy+ voted2011S_june_dummy+ voted2011S_may_dummy+ voted2011S_march_dummy+ voted2010P_dummy+ voted2010G_dummy+ voted2008PP_dummy+ voted2008P_dummy+ voted2008G_dummy
count if proved_citizen==0 & votecount~=0 & voted2012G==1 
disp 303/853
count if proved_citizen==0 & votecount~=0 & voted2012G==1 & hispanic==1
disp 248/704


**********************************************************************
*Meta-Analysis reported in "Is Reactance the Mechanism?" Section
**********************************************************************

use data\biggers_smith_bjps_metaanalysis_data.dta, clear
metan study_beta study_se, fixedi nokeep nograph

log close
