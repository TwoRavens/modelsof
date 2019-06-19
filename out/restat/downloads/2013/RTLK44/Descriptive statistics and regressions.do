
log using "Descriptive statistics and regressions.log", replace

*********************************************************************************************
*Descriptive statistics

* TABLE 1
tab CE_dummy2 DE_dummy2 if sample_reg==1
tab CE_dummy2 DE_dummy2 if Low_High_School==1& sample_reg==1
tab CE_dummy2 DE_dummy2 if UniMasDegree==1& sample_reg==1
tab CE_dummy2 DE_dummy2 if PhDDegree==1& sample_reg==1

* TABLE 2 
xi: sum CE_dummy2 DE_dummy2 Age Male Low_High_School UniMasDegree PhDDegree no_pastcoinv year_first_patent SK_ScLit residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob zeroExp experience SK_Tech  D_miss_empl D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit gdppop_nuts3 pop_nuts3 area_nuts3_km2 av_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL UK AppYear1993 AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 if sample_reg==1
sum link_coinv_diff_nuts_share1_b if no_pastcoinv==1 & sample_reg==1
sum herfinv1 if zeroExp==1 & sample_reg==1
sum EmployeesMiss if D_miss_empl==0&sample_reg==1
sum RDint if D_missC_RD==0&sample_reg==1

* TABLE 3
xi: pwcorr Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b year_first_patent SK_ScLit residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 EmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit gdppop_nuts3 pop_nuts3 area_nuts3_km2 av_pat_nuts3_9496 top1_tc shangai_n_univ overall_score experience SK_Tech if sample_reg==1, star(05)

* Appendix 2
xi: sum TechClass1 i.TechClass if sample_reg==1


* descriptive statistics for post-estimation computation of marginal effects at different values of some regressors
tabstat SK_ScLit if sample_reg==1, statistics(mean min p25 p50 p75 p90 p99 max sd) columns(statistics)
tabstat RDint if sample_reg==1, statistics(mean min p25 p75 p90 p99 max sd p50) columns(statistics)
tabstat RDint if D_missC_RD==0&sample_reg==1, statistics(mean min p25 p75 p90 p99 max sd p50) columns(statistics)
tabstat Age if sample_reg==1, statistics(mean min p25 p75 p99 max sd p50) columns(statistics)
tabstat lEmployeesMiss if D_miss_empl==0&sample_reg==1, statistics(mean min p25 p75 p99 max sd p50) columns(statistics)
tabstat EmployeesMiss if D_miss_empl==0&sample_reg==1, statistics(mean min p25 p75 p99 max sd p50) columns(statistics)


*********************************************************************************************
* Bivariate probit estimations

***************************
* TABLE 4

* Column 1. University degree and PHD Degree
xi: biprobit CE_dummy2 DE_dummy2 Age  Male  UniMasDegree PhDDegree lEmployeesMiss D_miss_empl  RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(Age  Male  UniMasDegree PhDDegree PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit)
mfx,  predict(pmarg1) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(pmarg1) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)

mfx,  predict(pmarg2) varlist(Age  Male  UniMasDegree PhDDegree PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit)
mfx,  predict(pmarg2) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(pmarg2) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)


* Column 2. Far past coinventors and Science
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit)
mfx,  predict(pmarg1) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(pmarg1) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)

*** Same regressions as above with year_first_patent rescaled (divided by 1.01) in order to compute marginal effects (without rescaling the dereivative was missiNG)
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent_resc3 lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg2) varlist(Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent_resc3 PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit)
mfx,  predict(pmarg2) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(pmarg2) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)


* Column 3. Experience Herfindahl and mobility
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit)
mfx,  predict(pmarg1) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(pmarg1) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)

mfx,  predict(pmarg2) varlist(Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit)
mfx,  predict(pmarg2) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(pmarg2) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)

* Column 4. Same regression as Column 3 with NUTS3 regions instead of NUTS2 regions
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts3_d_res AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(Age)
mfx,  predict(pmarg1) varlist(Male)
mfx,  predict(pmarg1) varlist(UniMasDegree)
mfx,  predict(pmarg1) varlist(PhDDegree)
mfx,  predict(pmarg1) varlist(link_coinv_diff_nuts_share1_b )
mfx,  predict(pmarg1) varlist(SK_ScLit)
mfx,  predict(pmarg1) varlist(year_first_patent)
mfx,  predict(pmarg1) varlist(residence_degree)
mfx,  predict(pmarg1) varlist(reg_mob_nuts3In)
mfx,  predict(pmarg1) varlist(reg_mob_nuts3Out)
mfx,  predict(pmarg1) varlist(herfinv1)
mfx,  predict(pmarg1) varlist(PRI_Applic)
mfx,  predict(pmarg1) varlist(Individual_Applic )
mfx,  predict(pmarg1) varlist(Ninventors)
mfx,  predict(pmarg1) varlist(reasonCommExploit)
mfx,  predict(pmarg1) varlist(reasonLic)
mfx,  predict(pmarg1) varlist(reasonImit)

mfx,  predict(pmarg1) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(pmarg1) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)

mfx,  predict(pmarg2) varlist(Age)
mfx,  predict(pmarg2) varlist(Male)
mfx,  predict(pmarg2) varlist(UniMasDegree)
mfx,  predict(pmarg2) varlist(PhDDegree)
mfx,  predict(pmarg2) varlist(link_coinv_diff_nuts_share1_b )
mfx,  predict(pmarg2) varlist(SK_ScLit)
mfx,  predict(pmarg2) varlist(year_first_patent)
mfx,  predict(pmarg2) varlist(residence_degree)
mfx,  predict(pmarg2) varlist(reg_mob_nuts3In)
mfx,  predict(pmarg2) varlist(reg_mob_nuts3Out)
mfx,  predict(pmarg2) varlist(herfinv1)
mfx,  predict(pmarg2) varlist(PRI_Applic)
mfx,  predict(pmarg2) varlist(Individual_Applic )
mfx,  predict(pmarg2) varlist(Ninventors)
mfx,  predict(pmarg2) varlist(reasonCommExploit)
mfx,  predict(pmarg2) varlist(reasonLic)
mfx,  predict(pmarg2) varlist(reasonImit)

mfx,  predict(pmarg2) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(pmarg2) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)


* TABLE 5 

*  bivariate probabilities of model 3 in Table 4
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(p11) varlist(Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit)
mfx,  predict(p00) varlist(Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit)
mfx,  predict(p10) varlist(Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit)
mfx,  predict(p01) varlist(Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit)

mfx,  predict(p11) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p00) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p10) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p01) at(RDint=0.0541232) varlist(RDint)

mfx,  predict(p11) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p00) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p10) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p01) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)



* TABLE 6 

* robustness check 1
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv UniXCoinv_d PhDXCoinv_d SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)

mfx, predict(p11) varlist(UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b UniXCoinv_d PhDXCoinv_d)
mfx, predict(p00) varlist(UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b UniXCoinv_d PhDXCoinv_d)
mfx, predict(p10) varlist(UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b UniXCoinv_d PhDXCoinv_d)
mfx, predict(p01) varlist(UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b UniXCoinv_d PhDXCoinv_d)

margins, predict(p11) dydx(UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b UniXCoinv_d PhDXCoinv_d) 
margins, predict(p00) dydx(UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b UniXCoinv_d PhDXCoinv_d) 
margins, predict(p10) dydx(UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b UniXCoinv_d PhDXCoinv_d) 
margins, predict(p01) dydx(UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b UniXCoinv_d PhDXCoinv_d) 

margins, predict(p11) dydx(UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b UniXCoinv_d PhDXCoinv_d) atmeans
margins, predict(p00) dydx(UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b UniXCoinv_d PhDXCoinv_d) atmeans
margins, predict(p10) dydx(UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b UniXCoinv_d PhDXCoinv_d) atmeans
margins, predict(p01) dydx(UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b UniXCoinv_d PhDXCoinv_d) atmeans


* robustness check 2
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit UniXScience PhDXScience year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)

mfx, predict(p11) varlist(UniMasDegree PhDDegree SK_ScLit UniXScience PhDXScience)
mfx, predict(p00) varlist(UniMasDegree PhDDegree SK_ScLit UniXScience PhDXScience)
mfx, predict(p10) varlist(UniMasDegree PhDDegree SK_ScLit UniXScience PhDXScience)
mfx, predict(p01) varlist(UniMasDegree PhDDegree SK_ScLit UniXScience PhDXScience)

margins, predict(p11) dydx(UniMasDegree PhDDegree SK_ScLit UniXScience PhDXScience)
margins, predict(p00) dydx(UniMasDegree PhDDegree SK_ScLit UniXScience PhDXScience)
margins, predict(p10) dydx(UniMasDegree PhDDegree SK_ScLit UniXScience PhDXScience)
margins, predict(p01) dydx(UniMasDegree PhDDegree SK_ScLit UniXScience PhDXScience)

margins, predict(p11) dydx(UniMasDegree PhDDegree SK_ScLit UniXScience PhDXScience) atmeans
margins, predict(p00) dydx(UniMasDegree PhDDegree SK_ScLit UniXScience PhDXScience) atmeans
margins, predict(p10) dydx(UniMasDegree PhDDegree SK_ScLit UniXScience PhDXScience) atmeans
margins, predict(p01) dydx(UniMasDegree PhDDegree SK_ScLit UniXScience PhDXScience) atmeans


* robustness check 3
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit SK_Tech year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx, predict(p11) varlist(UniMasDegree PhDDegree SK_ScLit SK_Tech)
mfx, predict(p00) varlist(UniMasDegree PhDDegree SK_ScLit SK_Tech)
mfx, predict(p10) varlist(UniMasDegree PhDDegree SK_ScLit SK_Tech)
mfx, predict(p01) varlist(UniMasDegree PhDDegree SK_ScLit SK_Tech)

* robustness check 4 (without ZeroExp)
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit lexperience year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx, predict(p11) varlist(UniMasDegree PhDDegree SK_ScLit lexperience)
mfx, predict(p00) varlist(UniMasDegree PhDDegree SK_ScLit lexperience)
mfx, predict(p10) varlist(UniMasDegree PhDDegree SK_ScLit lexperience)
mfx, predict(p01) varlist(UniMasDegree PhDDegree SK_ScLit lexperience)


* TABLE 7 
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)

mfx, predict(p11) varlist(Age Male UniMasDegree PhDDegree reg_mob_nuts3In reg_mob_nuts3Out residence_degree year_first_patent link_coinv_diff_nuts_share1_b herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors SK_ScLit reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score)
mfx, predict(p00) varlist(Age Male UniMasDegree PhDDegree reg_mob_nuts3In reg_mob_nuts3Out residence_degree year_first_patent link_coinv_diff_nuts_share1_b herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors SK_ScLit reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score)
mfx, predict(p10) varlist(Age Male UniMasDegree PhDDegree reg_mob_nuts3In reg_mob_nuts3Out residence_degree year_first_patent link_coinv_diff_nuts_share1_b herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors SK_ScLit reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score)
mfx, predict(p01) varlist(Age Male UniMasDegree PhDDegree reg_mob_nuts3In reg_mob_nuts3Out residence_degree year_first_patent link_coinv_diff_nuts_share1_b herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors SK_ScLit reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score)

mfx,  predict(p11) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p00) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p10) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p01) at(RDint=0.0541232) varlist(RDint)

mfx,  predict(p11) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p00) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p10) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p01) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)


log close
