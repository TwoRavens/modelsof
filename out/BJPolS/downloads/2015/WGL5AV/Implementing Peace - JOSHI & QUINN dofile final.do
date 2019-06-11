set more off
log using "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Gray figures\Implementing Peace result logs.smcl", replace
use "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Gray figures\Implementing Peace - JOSHI & QUINN-Final.dta"


//Table 1 Summary Statistics
sum agg_imp_rate total_prov sig_minor_war nonsig_minor_war conflict_type dead_1000  refugee_1000  net_aid war_dur  infant_rate polity_2_1lag gdp_growth_annual_perc media_ave  if exclude_case==0


//Survival Analysis of CPA with no war the year the peace accord is signed, SSS Conceptualization of all 7 provisions

//TABLE 2: STSET DATA TO ANALYSE DURABLE PEACE BETWEEN SIGNATORIES
stset year_count, id(caseid) failure( sig_minor_war) origin(time year_count)

//Testing Implementaiton of whole accord
streg  agg_imp_rate_woc conflict_type dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate  polity_2_1lag gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag if  exclude_cases==0, cluster (cowcode) d(w) time

//Figure 2a.
 
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) d(w) time
stcurve, survival at1(agg_imp_rate_woc=0) at2(agg_imp_rate_woc=25) at3(agg_imp_rate_woc=50) at4(agg_imp_rate_woc=75)
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\19FEB2015\betweensig.gph", replace
 

//TABLE 3: armed conflict between non-signatories
drop  _st _d _t _t0
stset year_count, id(caseid) failure(nonsig_minor_war) origin(time year_count)

//Testing Implementaiton of whole accord
streg  agg_imp_rate_woc conflict_type dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate  polity_2_1lag gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode) d(w) time
streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate polity_2_1lag if  exclude_cases==0, cluster (cowcode) d(w) time

//Figure 2b.


streg  agg_imp_rate_woc dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) d(w) time
stcurve, survival at1(agg_imp_rate_woc=0) at2(agg_imp_rate_woc=25) at3(agg_imp_rate_woc=50) at4(agg_imp_rate_woc=75)
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\19FEB2015\betweennon-sig.gph", replace
 
//graph combine "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\19FEB2015\betweensig.gph" "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\19FEB2015\betweennon-sig.gph", ycommon



//Table 4. Further Tests Model 1-2 Between Sig and non-sig excludes external actors related provisions & ceasefire 
//Between signatories
drop  _st _d _t _t0
stset year_count, id(caseid) failure( sig_minor_war) origin(time year_count)

streg  impratewithoutext conflict_type dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) d(w) time
streg  impratewithoutext dead_1000  refugee_1000  war_dur  infant_rate  polity_2_1lag gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode) d(w) time
streg  impratewithoutext dead_1000  refugee_1000  war_dur  polity_2_1lag unpkf_implem net_aid total_prov media_ave if  exclude_cases==0, cluster (cowcode) d(w) time

//Between non-sig
drop  _st _d _t _t0
stset year_count, id(caseid) failure(nonsig_minor_war) origin(time year_count)
streg  impratewithoutext conflict_type dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) d(w) time
streg  impratewithoutext dead_1000  refugee_1000  war_dur  infant_rate  polity_2_1lag gdp_growth_annual_perc if  exclude_cases==0, cluster (cowcode) d(w) time
streg  impratewithoutext dead_1000  refugee_1000  war_dur  polity_2_1lag unpkf_implem net_aid total_prov media_ave if  exclude_cases==0, cluster (cowcode) d(w) time



//pairwise correlation of implementation without external actors related provisions and external actor related provisions

pwcorr impratewithoutext ext_imprate, star(0.0001)


///Online Appendix C
//REplication of Model 1 in Table 2 and 3 with index of implementation of provisions without external actors, and having implementation of external actors related proviisons in the model
//Between Signatories
drop  _st _d _t _t0
stset year_count, id(caseid) failure( sig_minor_war) origin(time year_count)
streg  ext_imprate conflict_type dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) d(w) time
streg  impratewithoutext ext_imprate conflict_type dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) d(w) time

//Between non-sig
drop  _st _d _t _t0
stset year_count, id(caseid) failure(nonsig_minor_war) origin(time year_count)
streg  ext_imprate conflict_type dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) d(w) time
streg  impratewithoutext ext_imprate conflict_type dead_1000  refugee_1000  war_dur  infant_rate if  exclude_cases==0, cluster (cowcode) d(w) time


//Code for Figure 1.

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==1, title("Guatemala")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case1.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==2, title("El Salvador")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case2.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==3, title("Northern Ireland")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case3.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==4, title("Macedonia")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case4.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==5, title("Croatia")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case5.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==6, title("Bosnia")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case6.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==7, title("Guinea-Bissau")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case7.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==8, title("Mali")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case8.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==9, title("Senegal")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case9.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==10, title("Niger")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case10.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==11, title("Ivory Coast")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case11.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==12, title("Liberia")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case12.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==13, title("Sierra Leone 1996")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case13.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==14, title("Sierra Leone 1999")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case14.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==15, title("Congo-Brazzaville")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case15.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==16, title("Burundi")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case16.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==17, title("Rwanda")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case17.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==18, title("Djibouti 1994")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case18.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==19, title("Djibouti 2001")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case19.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==20, title("Angola 94")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case20.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==21, title("Angola 2002")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case21.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==22, title("Mozambique")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case22.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==23, title("South Africa")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case23.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==24, title("Sudan")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case24.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==25, title("Lebanon")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case25.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==26, title("Tajikistan")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case26.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==27, title("India")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case27.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==28, title("Bangladesh")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case28.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==29, title("Nepal")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case29.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==30, title("Cambodia")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case30.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==31, title("Philippines")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case31.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==32, title("Indonesia")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case32.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==33, title("East Timor")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case33.gph", replace

line  agg_imp_rate year_count if  exclude_cases!=1 & caseid==34, title("Papua New Guinea")
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case34.gph", replace

//Combine Graphs
//graph combine "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case1.gph" "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case2.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case3.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case4.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case5.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case6.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case7.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case8.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case9.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case10.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case11.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case12.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case13.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case14.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case15.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case16.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case17.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case18.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case19.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case20.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case21.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case22.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case23.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case24.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case25.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case26.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case26.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case28.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case29.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case30.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case31.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case32.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case33.gph""C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\case34.gph", ycommon
//graph save Graph "C:\Users\mjoshi2.DSS-OKIU3QJMAS9\Desktop\Implementation IV\Data and Do files\Figures\all graphs", replace


log close
