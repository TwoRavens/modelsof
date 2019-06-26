
//Replicating Tables
//Table 1: List of CPAs available from https://peaceaccords.nd.edu/matrix/accords/
//Table 2: List of Provisions available from https://peaceaccords.nd.edu/matrix/topic/

log using "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\RR3\Replication Files\JPR-PAM-ID-JOSHI, QUINN & REGAN.smcl", replace


//Replicate Table 3
list year powtran_implem powtran_revers if caseid ==3

//Pairwise Correlation of SSR Provisions
//Table 4
pwcorr cease_imp  demob_imp  disarm_imp   milrfm_imp   pargrp_imp   polrfm_imp  reint_imp  with_imp,  star(.05)


//Generating Variables used in analysis
gen dead_1000 = total_dead/1000
//Generating Military reform Cumulative Variable
gen milrfm_cum =(milrfm_implem/3)*100
//UN Peacekeepign Implementation Rate
gen unpkf_imprate = ( unpkf_implem/3)*100


//Generating strict Security Sector Reform Variable
//military reform, police reform, disarmament, demobilization, reintegration, paramilitary, withdrawal of troops, ceasefire

//generate SSR Provisions
gen SSR_Prov = (cease_prov + demob_prov+ disarm_prov + milrfm_prov + pargrp_prov + polrfm_prov+ reint_prov + with_prov)
gen SSR_Imp = (cease_imp + demob_imp + disarm_imp  + milrfm_imp  + pargrp_imp  + polrfm_imp + reint_imp  + with_imp)
gen SSR_IMP_RateStrict = (SSR_Imp/24)*100
gen SSR_IMP_RateLenient = (SSR_Imp/(SSR_Prov*3))*100

gen SSR_Prov_WOM =(cease_prov + demob_prov+ disarm_prov + pargrp_prov + polrfm_prov+ reint_prov + with_prov)
gen SSR_IMP_WOM =(cease_imp + demob_imp + disarm_imp  + milrfm_imp  + pargrp_imp  + polrfm_imp + reint_imp  + with_imp)

gen SSR_IMPRate_WOMS = (SSR_IMP_WOM/21)*100
gen SSR_IMPRate_WOML = (SSR_IMP_WOM/(SSR_Prov_WOM*3))*100


//Replicate Table 5. armed conflict between signatories  
stset year_count, id(caseid) failure( sig_minor_war) origin(time year_count)

streg milrfm_c  dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time
streg milrfm_c SSR_IMPRate_WOMS dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time
streg SSR_IMP_RateStrict  unpkf_imprate dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time

//To generate Figure 6.1
streg SSR_IMP_RateStrict  unpkf_imprate dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time
stcurve, survival at1(SSR_IMP_RateStrict=0) at2(SSR_IMP_RateStrict=25) at3(SSR_IMP_RateStrict=50) at4(SSR_IMP_RateStrict=75)
//graph save "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\Figure6.1.gph" 


//Replicate Table 5. armed conflict between non-signatories
drop  _st _d _t _t0
stset year_count, id(caseid) failure(nonsig_minor_war) origin(time year_count)

streg milrfm_c  dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time
streg milrfm_c SSR_IMPRate_WOMS dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time
streg SSR_IMP_RateStrict  unpkf_imprate  dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time

//to generate Figure 6.2 
streg SSR_IMP_RateStrict  dead_1000  unpkf_imprate  war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time
stcurve, survival at1(SSR_IMP_RateStrict=0) at2(SSR_IMP_RateStrict=25) at3(SSR_IMP_RateStrict=50) at4(SSR_IMP_RateStrict=75)
//graph save "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\Figure6.2.gph", replace 

//Replicating Figures
//for Figure 1, see excel data file.
//For Figure 2, see excel data file.
//For Figure 3, use Implementation of "Individual Provisions - Figure 3.dta" & "Individual Provisions - Figure 3.do"
//Replicate Figure 4
//Generate Data for Figure 4
gen total_prov = (amnest_prov + arbdamprov + arbland_prov + bound_prov + cease_prov  + child_prov + citiz_prov + civadm_prov + const_prov + cultr_prov + decen_prov + demob_prov + develop_prov + disarm_prov + disput_prov + donor_prov + educat_prov + elect_prov + embarg_prov + ethrel_prov + exerefm_prov + humrts_prov + idps_prov + indmin_prov + indrefer_prov + judrfm_prov + legref_prov + media_prov + milrfm_prov + minrts_prov + natres_prov + offlan_prov + pargrp_prov + polrfm_prov + powtran_prov  + prisr_prov + ratm_prov + refug_prov + regpkf_prov + reint_prov + repar_prov + roa_prov +selfd_prov + terpow_prov + time_prov + truth_prov + unpkf_prov + untran_prov + verify_prov + with_prov + women_prov )  

gen total_imp = (amnest_implem + arbdam_implem+ arbland_implem+ bound_implem+ cease_implem+ child_implem+ citiz_implem+ civadm_impem+ const_implem+ cultr_implem + decen_implem + demob_implem + develop_iplem + disarm_implem + dispute_implem + donor_implem + educat_implem + elect_implem + embarg_implem + ethrel_implem + exerefm_implem + humrts_implem + idps_implem + indmin_implem + indrefer_implem + judrfm_implem + legref_implem + media_implem + milrfm_implem + minrts_implem + natres_implem + offlan_implem + pargrp_implem + polrfm_implem + powtran_implem + prisr_implem + ratm_implem + refug_implem + regpkf_implem + reint_implem + repar_implem + roa_implem + selfd_implem + terpow_implem + time_implem + truth_implem + unpkf_implem + untran_implem + verify_implem + with_implem + women_implem)
gen agg_imp_rate = (total_imp/ (total_prov*3))*100

gen guatemala_imprate = .
replace guatemala_imprate= agg_imp_rate if caseid==1

gen nireland_imprate = .
replace nireland_imprate= agg_imp_rate if caseid==3

gen mali_imprate = .
replace mali_imprate= agg_imp_rate if caseid==8

gen niger_imprate = .
replace niger_imprate= agg_imp_rate if caseid==10

gen lebanon_imprate= .
replace lebanon_imprate= agg_imp_rate if caseid==25

gen nepal_imprate = .
replace nepal_imprate= agg_imp_rate if caseid==29


line  guatemala_imprate year_count if  exclude_cases!=1 & caseid==1, title("Guatemala")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\case1.gph", replace

line  nireland_imprate year_count if  exclude_cases!=1 & caseid==3, title("Northern Ireland")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\case3.gph", replace

line  mali_imprate year_count if  exclude_cases!=1 & caseid==8, title("Mali")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\case8.gph", replace

line  niger_imprate year_count if  exclude_cases!=1 & caseid==10, title("Niger")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\case10.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==25, title("Lebanon")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\case25.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==29, title("Nepal")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\case29.gph", replace

//Combine Figure 4
//graph combine "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\case1.gph" "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\case3.gph" "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\case8.gph" "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\case10.gph" "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\case25.gph" "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\case29.gph", ycommon
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\Figure 4.gph", replace

//Generate Data to Replicate Figure 5 
//Generated Data & Figure in Excel File
count if SSR_Prov==2 & year_count==1
count if SSR_Prov==3 & year_count==1
count if SSR_Prov==4 & year_count==1
count if SSR_Prov==5 & year_count==1
count if SSR_Prov==6 & year_count==1
count if SSR_Prov==7 & year_count==1
count if SSR_Prov==8 & year_count==1

//Replicate Figure 6 - Graph generated and saved after estimating models above.
//graph combine "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\Figure6.1.gph" "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\Figure6.2.gph"  
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\JPR RR2\Replication Files\Figure 6-Final.gph", replace


///////////END OF DO FILES for Table & Figures in PAPER///////////



//Appendix
//Between Signatories
drop  _st _d _t _t0
stset year_count, id(caseid) failure(sig_minor_war) origin(time year_count)

streg SSR_IMP_RateStrict if  exclude_cases==0, cluster (cowcode) d(w) time
streg SSR_IMP_RateLenient if  exclude_cases==0, cluster (cowcode) d(w) time
streg SSR_IMP_RateLenient unpkf_imprate dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time


//Between non_signatories
drop  _st _d _t _t0
stset year_count, id(caseid) failure(nonsig_minor_war) origin(time year_count)

streg SSR_IMP_RateStrict if  exclude_cases==0, cluster (cowcode) d(w) time
streg SSR_IMP_RateLenient if  exclude_cases==0, cluster (cowcode) d(w) time
streg SSR_IMP_RateLenient unpkf_imprate dead_1000   war_dur  infant_rate conflict_type polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time
drop  _st _d _t _t0

//REPLICATION OF Model 3 & 6  without withdrawal implementation in the index - refers to table in Manuscript in RR1
gen SSR_Prov_wotw = (cease_prov + demob_prov+ disarm_prov + milrfm_prov + pargrp_prov + polrfm_prov+ reint_prov)
gen SSR_Imp_wotw = (cease_imp + demob_imp + disarm_imp  + milrfm_imp  + pargrp_imp  + polrfm_imp + reint_imp)
gen SSR_IMP_Rate_wotw = (SSR_Imp_wotw/21)*100

//between signatories

stset year_count, id(caseid) failure(sig_minor_war) origin(time year_count)
stset year_count, id(caseid) failure( sig_minor_war) origin(time year_count)
streg SSR_IMP_Rate_wotw  unpkf_imprate dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time

//between non-signatories
drop  _st _d _t _t0
stset year_count, id(caseid) failure(nonsig_minor_war) origin(time year_count)
streg SSR_IMP_Rate_wotw  unpkf_imprate dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time

//online appendix weighted index based on how frequent the SSR provision was in accord
//Provision					freq.		freq/Total
//ceasefire					29			0.153
//demobalization				25			0.132
//disarmamnet					28			0.148
//military reform				26			0.138
//paramilitary					16			0.085
//police reform					24			0.127
//reintegration					27			0.143
//withdrawal					14			0.074
//_______________________________________________________________________________
//Total						189			1.000

//SSR Index based on frequency weight and includes all 8 SSR provisions 
gen SSR_Imp_weight = ((cease_imp*0.153) + (demob_imp*0.132) + (disarm_imp*0.148)  + (milrfm_imp*0.138)  + (pargrp_imp*0.085)  + (polrfm_imp*0.127) + (reint_imp*0.143)  + (with_imp*0.074))
gen SSR_IMP_expweight = (3*0.153)+(3*0.132) + (3*0.148) + (3*0.138) + (3*0.085) + (3*0.127) + (3*0.143) + (3*0.074)
gen SSR_IMP_weightedRate = (SSR_Imp_weight/SSR_IMP_expweight)*100


//Replicates Model 3 in current version
drop  _st _d _t _t0
stset year_count, id(caseid) failure( sig_minor_war) origin(time year_count)
streg SSR_IMP_weightedRate unpkf_imprate  dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time

//Replicates Model 6 (non-signatories) in RR1 version
drop  _st _d _t _t0
stset year_count, id(caseid) failure(nonsig_minor_war) origin(time year_count)
streg SSR_IMP_weightedRate  unpkf_imprate  dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time

//SSR Index based on given weights that weight some provision more than others.

//Giving weight 
//Provision							weight
//ceasefire							0.2
//demobalization						0.2
//disarmamnet							0.2
//military reform						0.15
//paramilitary							0.025
//police reform							0.05
//reintegration							0.15
//withdrawal							0.025
//__________________________________________________________________________							
//Total								1.00

gen SSR_IMP_GW = ((cease_imp*0.2) + (demob_imp*0.2) + (disarm_imp*0.2)  + (milrfm_imp*0.15)  + (pargrp_imp*0.025)  + (polrfm_imp*0.05) + (reint_imp*0.15)  + (with_imp*0.025))
gen SSR_IMP_GWEXP = (3*0.2)+(3*0.2) + (3*0.2) + (3*0.15) + (3*0.025) + (3*0.05) + (3*0.15) + (3*0.025)
gen SSR_IMP_GWRate = (SSR_IMP_GW/SSR_IMP_GWEXP)*100

//Replicates Model 3 in current version
drop  _st _d _t _t0
stset year_count, id(caseid) failure( sig_minor_war) origin(time year_count)
streg SSR_IMP_GWRate unpkf_imprate  dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time

//Replicates Model 6 (non-signatories) in RR1 version
drop  _st _d _t _t0
stset year_count, id(caseid) failure(nonsig_minor_war) origin(time year_count)
streg SSR_IMP_GWRate  unpkf_imprate  dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time


sum SSR_IMP_Rate_wotw SSR_IMP_weightedRate SSR_IMP_GWRate 
// SSR_IMP_Rate_wotw - index without withdrawal of troops
// SSR_IMP_weightedRate - weighted index based on provision's frequency see abote table
//SSR_IMP_GWRate - randomely assigned index see above table

//Factor Analysis
factor  cease_imp demob_imp disarm_imp  milrfm_imp  pargrp_imp  polrfm_imp reint_imp  with_imp if  exclude_cases==0, pcf
rotate
predict factor1 factor2 factor3 factor4 factor5

   // --------------------------------------------
   //    Variable |  Factor1   Factor2   Factor3 
   //-------------+------------------------------
   // cease_implem |  0.49349  -0.24000  -0.09705 
   // demob_implem | -0.01052   0.36630  -0.09691 
   // disarm_imp~m | -0.29723   0.58420   0.11143 
   // milrfm_imp~m |  0.43617  -0.13658  -0.11302 
   //pargrp_imp~m |  0.28541   0.01544   0.26685 
   // polrfm_imp~m |  0.14808   0.19713   0.35535 
   // reint_implem |  0.02143   0.24827  -0.31609 
   //  with_implem | -0.02524   0.02980   0.68385 
   // --------------------------------------------

//Replicates Model 3 - Dimensions of SSR based on Factor Analysis
//Factor 1  
drop  _st _d _t _t0
stset year_count, id(caseid) failure( sig_minor_war) origin(time year_count)
gen SSR_Imp_F1 = (cease_imp + milrfm_imp  + pargrp_imp  + polrfm_imp)
gen SSR_IMP_RateF1 = (SSR_Imp_F1/12)*100
streg  SSR_IMP_RateF1  unpkf_imprate  dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time

//Factor2
gen SSR_Imp_F2 = (demob_imp + disarm_imp + polrfm_imp + reint_imp )
gen SSR_IMP_RateF2 = (SSR_Imp_F2/24)*100
streg  SSR_IMP_RateF2  unpkf_imprate  dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time

//Factor3

gen SSR_Imp_F3 = (disarm_imp  + pargrp_imp  + polrfm_imp + with_imp)
gen SSR_IMP_RateF3 = (SSR_Imp_F3/24)*100
streg  SSR_IMP_RateF3  unpkf_imprate  dead_1000   war_dur  infant_rate conflict_type  polity_2_1lag_1 if  exclude_cases==0, cluster (cowcode) d(w) time

log close




