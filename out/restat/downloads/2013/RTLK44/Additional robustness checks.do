
*Robustness checks mentioned in the paper, but results not shown in the Tables

*** Robustness check 1, described in footnote 8 "As a robustness check, we used the 0–5 importance score of near and far interactions as dependent variables of two ordered probit regressions"

*Table 4, model 3
xi: oprobit CloseExt Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
xi: oprobit DistExt Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)

*Table 4, model 4
xi: oprobit CloseExt Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts3_d_res AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
xi: oprobit DistExt Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts3_d_res AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)

*Table 7
xi: oprobit CloseExt Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
xi: oprobit DistExt Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)


*** Robustness check 2-3, described in footnote 9 "As robustness checks, we employ the share between distant and total ties (instead of inventors) and the share between distant and near co-inventors, with no relevant changes"

*Table 4, model 3
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(UniMasDegree PhDDegree link_diff_nuts_share1_b)
mfx,  predict(pmarg2) varlist(UniMasDegree PhDDegree link_diff_nuts_share1_b)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree link_diff_nuts_share1_b)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree link_diff_nuts_share1_b)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree link_diff_nuts_share1_b)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree link_diff_nuts_share1_b)

*Table 4, model 3
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diffsame1 no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(UniMasDegree PhDDegree link_coinv_diffsame1)
mfx,  predict(pmarg2) varlist(UniMasDegree PhDDegree link_coinv_diffsame1)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree link_coinv_diffsame1)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree link_coinv_diffsame1)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree link_coinv_diffsame1)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree link_coinv_diffsame1)

*** Robustness check 4, described in footnote 14 "in place of the Herfindahl variable, we employ a dummy variable that takes a value of 0 if all the inventor’s past patents were in the same technological class, and 1 otherwise"

*Table 4, model 3
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob breadthexp01 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(UniMasDegree PhDDegree breadthexp01)
mfx,  predict(pmarg2) varlist(UniMasDegree PhDDegree breadthexp01)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree breadthexp01)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree breadthexp01)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree breadthexp01)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree breadthexp01)

*** Robustness check 5, described in footnote 15 "we compared the results in Table 4 with specifications that exclude the technological dummies "

*Table 4, model 3
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(UniMasDegree PhDDegree)
mfx,  predict(pmarg2) varlist(UniMasDegree PhDDegree)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree)


*Table 4, model 4
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts3_d_res AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(UniMasDegree PhDDegree)
mfx,  predict(pmarg2) varlist(UniMasDegree PhDDegree)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree)

*** Robustness check 6, described in footnote 15 "We also estimated the models for subsamples of technologies selected according to the importance of SCIENCE"

*Table 7

* if induSKlit50==0 
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if induSKlit50==0&sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(UniMasDegree PhDDegree)
mfx,  predict(pmarg2) varlist(UniMasDegree PhDDegree)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree)

* if induSKlit50==1
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if induSKlit50==1&sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(UniMasDegree PhDDegree)
mfx,  predict(pmarg2) varlist(UniMasDegree PhDDegree)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree)


* if induSKlit25==0 
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if induSKlit25==0&sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(UniMasDegree PhDDegree)
mfx,  predict(pmarg2) varlist(UniMasDegree PhDDegree)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree)

* if induSKlit25==1 
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if induSKlit25==1&sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(UniMasDegree PhDDegree)
mfx,  predict(pmarg2) varlist(UniMasDegree PhDDegree)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree)


**** Robustness check 7, described in footnote 16: 4 combinations with model 4 table 4 
*Table 4, model 4
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts3_d_res AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree)

**** Robustness check 8, described in footnote 17: Agesquared
*Table 4, model 3

xi: biprobit CE_dummy2 DE_dummy2 Age Age2 Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(UniMasDegree PhDDegree Age Age2)
mfx,  predict(pmarg2) varlist(UniMasDegree PhDDegree Age Age2)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree Age Age2)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree Age Age2)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree Age Age2)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree Age Age2)

**** Robustness check 9, described in footnote 18: Guttman EDU
*Table 4, model 3
xi: biprobit CE_dummy2 DE_dummy2 Age Male EDU link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit i.nuts2_d_res_country AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(EDU)
mfx,  predict(pmarg2) varlist(EDU)
mfx,  predict(p11) varlist(EDU)
mfx,  predict(p00) varlist(EDU)
mfx,  predict(p10) varlist(EDU)
mfx,  predict(p01) varlist(EDU)

**** Robustness check 10, described in footnote 19: Dummy for experience diversity
* see rob check 4

**** Robustness check 11, described in footnote 19: separate estimates for sample distibuished by the level of education
*Table 7

*if Low_High_School==1
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass if Low_High_School==1&sample_reg==1 [pw=invtotprob], robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(pmarg2) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(p11) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(p00) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(p10) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(p01) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)

mfx,  predict(pmarg1) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(pmarg2) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p11) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p00) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p10) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p01) at(RDint=0.0541232) varlist(RDint)

mfx,  predict(pmarg1) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(pmarg2) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p11) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p00) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p10) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p01) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)

*if UniMasDegree==1
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass if UniMasDegree==1&sample_reg==1 [pw=invtotprob], robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(pmarg2) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(p11) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(p00) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(p10) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(p01) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)

mfx,  predict(pmarg1) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(pmarg2) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p11) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p00) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p10) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p01) at(RDint=0.0541232) varlist(RDint)

mfx,  predict(pmarg1) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(pmarg2) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p11) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p00) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p10) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p01) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)

*if PhDDegree==1
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass if PhDDegree==1&sample_reg==1 [pw=invtotprob], robust cluster(id_parent_1)
mfx,  predict(pmarg1) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(pmarg2) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(p11) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(p00) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(p10) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)
mfx,  predict(p01) varlist(Age Male link_coinv_diff_nuts_share1_b SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit shangai_n_univ overall_score)

mfx,  predict(pmarg1) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(pmarg2) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p11) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p00) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p10) at(RDint=0.0541232) varlist(RDint)
mfx,  predict(p01) at(RDint=0.0541232) varlist(RDint)

mfx,  predict(pmarg1) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(pmarg2) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p11) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p00) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p10) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)
mfx,  predict(p01) at(lEmployeesMiss=9.688951) varlist(lEmployeesMiss)


**** Robustness checks 12-13, described in footnote 20: 
*Table 7
*top5_tc
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top5_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree top5_tc)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree top5_tc)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree top5_tc)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree top5_tc)

*share patents of the regions in tc
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 sharepat_nuts2_tc30_1 shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree sharepat_nuts2_tc30_1)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree sharepat_nuts2_tc30_1)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree sharepat_nuts2_tc30_1)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree sharepat_nuts2_tc30_1)

**** Robustness check 14, described in footnote 21: Leiden ranking - leiden_n_univ and cpp_fcsm
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc leiden_n_univ cpp_fcsm DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree leiden_n_univ cpp_fcsm)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree leiden_n_univ cpp_fcsm)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree leiden_n_univ cpp_fcsm)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree leiden_n_univ cpp_fcsm)


**** Robustness check 15, described in footnote 22: res univ score by level of education
* see rob checks 11


**** Robustness checks 16, described at page 461 of the paper, last paragraph of Section V

*Table 7
* exclusion of lav_pat_nuts3_9496 
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree top1_tc)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree top1_tc)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree top1_tc)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree top1_tc)

* exclusion of top1_tc
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree lav_pat_nuts3_9496)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree lav_pat_nuts3_9496)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree lav_pat_nuts3_9496)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree lav_pat_nuts3_9496)


* dummy for presence of research universities: shangai_univ
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob] if sample_reg==1, robust cluster(id_parent_1)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree shangai_univ overall_score)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree shangai_univ overall_score)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree shangai_univ overall_score)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree shangai_univ overall_score)


**** Robustness check 17, described in footnote 23: exclusion of top 25% and top 50% firms in the size distribution

* bottom 75%: EmployeesMiss<75737.29
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass if EmployeesMiss<75737.29&sample_reg==1  [pw=invtotprob], robust cluster(id_parent_1)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree)

* bottom 50%: EmployeesMiss<6200.833
xi: biprobit CE_dummy2 DE_dummy2 Age Male UniMasDegree PhDDegree link_coinv_diff_nuts_share1_b no_pastcoinv SK_ScLit year_first_patent residence_degree reg_mob_nuts3In reg_mob_nuts3Out dum_miss_reg_mob herfinv1 zeroExp lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Ninventors reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc shangai_n_univ overall_score DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass if EmployeesMiss<6200.833&sample_reg==1  [pw=invtotprob], robust cluster(id_parent_1)
mfx,  predict(p11) varlist(UniMasDegree PhDDegree)
mfx,  predict(p00) varlist(UniMasDegree PhDDegree)
mfx,  predict(p10) varlist(UniMasDegree PhDDegree)
mfx,  predict(p01) varlist(UniMasDegree PhDDegree)

log close
