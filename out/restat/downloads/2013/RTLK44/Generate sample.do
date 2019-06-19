log using "generate sample.log", replace

use data_complete.dta, clear


***************************************************************************************************************
*generate sample for descriptive statistics and econometric estimations

set matsize 5000

xi: biprobit CE_dummy2 DE_dummy2 EDU year_first_patent residence_degree no_pastcoinv link_coinv_diff_nuts_share1_b link_diff_nuts_share1_b lEmployeesMiss D_miss_empl RDint D_missC_RD PRI_Applic Individual_Applic Age Male UniMasDegree PhDDegree YearMobilitybefore Ninventors SK_ScLit reasonCommExploit reasonLic reasonImit lgdppop_nuts3 lpop_nuts3 larea_nuts3_km2 lav_pat_nuts3_9496 top1_tc DE IT ES NL AppYear1994 AppYear1995 AppYear1996 AppYear1997 AppYear1998 i.TechClass [pw=invtotprob], robust cluster(id_parent_1)
gen sample_reg=1 if e(sample)


* generate dummies for subsamples of technologies selected according to the importance of SCIENCE, to be used in additional robustness checks 6

egen induSKlit = mean(SK_ScLit) if sample_reg==1, by(TechClass)
centile induSKlit, centile(5 50 75 95)

generate induSKlit50=.
replace induSKlit50=1 if induSKlit >2.567976
replace induSKlit50=0 if induSKlit <2.567976

generate induSKlit25=.
replace induSKlit25=1 if induSKlit >3.079365
replace induSKlit25=0 if induSKlit <3.079365
 
log close
