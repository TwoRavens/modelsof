*Open data file that combines 2016 Electoral Integrity Project data file and 2014 Elections Performance Index from the Pew Charitable Trust
*Original source for data files listed in codebook and text of the paper
*Note: Variables for EIP/Norris 2016 data listed first (norris_), then Pew 2014 data (pew_)

use "Flavin_Shufeldt_SPPQ_replication_data_1_of_2.dta", clear

*Scatterplot used to create FIGURE 1: Correlation Between Pew and EIP Measures
twoway (scatter norris_PEIIndexi pew_2014_composite, sort mlabel(stateabbr))

*Descriptive statistics discussed in text of paper and used to create TABLE 1: Comparing the Two State Electoral Integrity Measures
sum norris_PEIIndexi pew_2014_composite

*Correlation between the two measures discussed in text of paper (for all states, and then comparing correlation for states with less/more than 10 responses for EPI)
corr norris_PEIIndexi pew_2014_composite
corr norris_PEIIndexi pew_2014_composite if norris_numresponses<10
corr norris_PEIIndexi pew_2014_composite if norris_numresponses>=10

*Cronbach's alpha discussed in text of paper
alpha norris_lawsi norris_proceduresi norris_boundariesi norris_voteregi norris_partyregi norris_mediai norris_financei norris_votingi norris_counti norris_resultsi norris_EMBsi
alpha pew_website_reg_status pew_website_precinct_ballot pew_website_absentee_status pew_website_provisiol_status pew_reg_rej pew_prov_partic pew_prov_rej_all pew_abs_rej_all_ballots pew_abs_nonret pew_uocava_rej pew_uocava_nonret pew_eavs_completeness pew_post_election_audit pew_nonvoter_illness_offyear_pct pew_nonvoter_reg_offyear_pct pew_online_reg pew_wait pew_pct_reg_of_vep_vrs pew_vep_turnout

*Principal components analysis component loadings used to create TABLE 2: Principal Component Analysis Component Loadings
*Note: The predicted components are saved for analysis in Table 3 with ANES data (see other replication .do file)
pca norris_lawsi norris_proceduresi norris_boundariesi norris_voteregi norris_partyregi norris_mediai norris_financei norris_votingi norris_counti norris_resultsi norris_EMBsi
predict norris1 norris2
pca pew_website_reg_status pew_website_precinct_ballot pew_website_absentee_status pew_website_provisiol_status pew_reg_rej pew_prov_partic pew_prov_rej_all pew_abs_rej_all_ballots pew_abs_nonret pew_uocava_rej pew_uocava_nonret pew_eavs_completeness pew_post_election_audit pew_nonvoter_illness_offyear_pct pew_nonvoter_reg_offyear_pct pew_online_reg pew_wait pew_pct_reg_of_vep_vrs pew_vep_turnout
predict pew_factor1 pew_factor2 pew_factor3 pew_factor4 pew_factor5 pew_factor6
