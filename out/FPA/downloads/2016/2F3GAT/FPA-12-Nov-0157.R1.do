******************************************
*** Graphs and Tables in the Main Text ***
******************************************

clear all
use data.dta

*** Figure 1: Foreign Policy Similarity by Geographical Subregion, 1978-2011
bysort year: egen  pivv_all_Africa=mean(pivv_all) if region2=="Africa"
bysort year: egen  pivv_all_Americas=mean(pivv_all) if region2=="Americas"
bysort year: egen  pivv_all_Asia=mean(pivv_all) if region2=="Asia"
bysort year: egen  pivv_all_Europe=mean(pivv_all) if region2=="Europe"
bysort year: egen  pivv_all_Oceania=mean(pivv_all) if region2=="Oceania"
bysort year: egen  pivv_all_mean=mean(pivv_all)
label var pivv_all_mean "Mean of Foreign Policy Similarity"

#delimit ;
graph twoway 
(line pivv_all_Africa year , lw(medthick) lp(dash_dot) lc(gs4))
(line pivv_all_Americas year, lw(medthick) lp(longdash_dot) lc(gs8))
(line pivv_all_Asia year, lw(medthick) lp(shortdash_dot) lc(gs12)) 
(line pivv_all_Europe year, lw(medthick) lp(shortdash) lc(gs12))
(line pivv_all_Oceania year, lw(medthick) lp(dash) lc(gs12))
(line pivv_all_mean year, lw(thick) lp(solid) lc(black)) if UNnames!="China"
, legend(label(1 "Africa") label(2 "Americas") label(3 "Asia") label(4 "Europe") label(5 "Oceania") label(6 "World average") cols(2) symysize(0.8) size(small)) 
ytitle("Foreign Policy Similarity") 
xtitle("Year");

*** Table 1: Logistic Regression Models of Foreign Policy Similarity and Parallel Paolicy Choices
eststo: logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3, rob cluster(country_no)
eststo: logit pivv_p90bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3, rob cluster(country_no)
eststo: logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year <=1989, rob cluster(country_no)
eststo: logit pivv_p90bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year <=1989, rob cluster(country_no)
eststo: logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year <=1989, rob cluster(country_no)
eststo: logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p90bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
esttab using table1.rtf,se pr2 ar2 scalars(chi2) label title(Table 1: Logistic Regression Models of Foreign Policy Similarity and Parallel Policy Choices) mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) compress nogap
eststo clear

*** Table 2: Logistic Regression Models of Foreign Policy Similarity and Bilateral Links (post-Cold War era)
eststo: logit pivv_p75bin L1_de_lev L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p75bin L1_partnership L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p75bin L1_shared_igo3 L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p75bin L1_trade_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p75bin L1_exp_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p75bin L1_imp_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p75bin L1_aid_projects1_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p75bin L1_armsimports_vol_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
esttab using table2.rtf,se pr2 ar2 scalars(chi2) label title(Table 2: Logistic Regression Models of Foreign Policy Similarity and Bilateral Links) mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) compress nogap
eststo clear

*** Table 3: Onset and Duration of Foreign Policy Similarity (post-Cold War era)
eststo: logit pivv_p75bin L1_de_lev  L1_partnership L1_shared_igo3 L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity distance nam L1_cap_pop L1_cap_res pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year>=1990, rob cluster(country_no)	
eststo: logit pivv_p75bin L1_de_lev  L1_partnership L1_shared_igo3 L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity distance nam L1_cap_pop L1_cap_res pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year>=1990 & L1_pivv_p75bin==0, rob cluster(country_no)
eststo: logit pivv_p75bin L1_de_lev  L1_partnership L1_shared_igo3 L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity distance nam L1_cap_pop L1_cap_res pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year>=1990 & L1_pivv_p75bin==1, rob cluster(country_no)
eststo: logit pivv_p75bin L1_imp_china_share_rec L1_aid_projects1_3yravg L1_armsimports_vol_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity distance nam L1_cap_pop L1_cap_res pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year>=1990, rob cluster(country_no)	
eststo: logit pivv_p75bin L1_imp_china_share_rec L1_aid_projects1_3yravg L1_armsimports_vol_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity distance nam L1_cap_pop L1_cap_res pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year>=1990 & L1_pivv_p75bin==0, rob cluster(country_no)
eststo: logit pivv_p75bin L1_imp_china_share_rec L1_aid_projects1_3yravg L1_armsimports_vol_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity distance nam L1_cap_pop L1_cap_res pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year>=1990 & L1_pivv_p75bin==1, rob cluster(country_no)
esttab using table3.rtf,se pr2 ar2 scalars(chi2) label title(Table 3: Onset and Duration Models of Foreign Policy Similarity) mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) compress nogap
eststo clear

 
***************************
*** Supporting Material ***
***************************

*** Table S-1: Countries' Levels of Foreign Policy Simialrity with China
gsort -pivv_all UNnames 
list UNnames year pivv_all  pivv_p25bin pivv_p75bin pivv_p90bin if year==1978 & pivv_p75bin==1
list UNnames year pivv_all  pivv_p25bin pivv_p75bin pivv_p90bin if year==1991 & pivv_p75bin==1
list UNnames year pivv_all  pivv_p25bin pivv_p75bin pivv_p90bin if year==2001 & pivv_p75bin==1
list UNnames year pivv_all  pivv_p25bin pivv_p75bin pivv_p90bin if year==2011 & pivv_p75bin==1

*** Table S-2: Foreign Policy Simialrity with China by Geographical Subregion
tabstat pivv_all if year>=1978 & year<=1982, by(region3)
tabstat pivv_all if year>=1990 & year<=1995, by(region3)
tabstat pivv_all if year>=1996 & year<=2001, by(region3)
tabstat pivv_all if year>=2002 & year<=2006, by(region3)
tabstat pivv_all if year>=2007 & year<=2011, by(region3)

*** Table S-4: Summary of Descriptive Statistics 
sum ccode year pivv_all ///
pivv_p25bin pivv_p75bin pivv_p90bin ///
L1_status_similarity_own2 ///
L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity ///
L1_de L1_de_lev L1_partnership L1_shared_igo3 ///
L1_trade_china_share_rec L1_exp_china_share_rec L1_imp_china_share_rec L1_ecodep_china2  ///
L1_aid_projects1_mod_bin L1_aid_projects1 L1_aid_projects1_2yravg L1_aid_projects1_3yravg ///
L1_armsimports_bin1 L1_armsimports_vol L1_armsimports_vol_2yravg L1_armsimports_vol_3yravg ///
distance nam confinst antius post2001 ///
L1_cinc_v4 L1_cap_pop L1_cap_mil L1_cap_res ///
pivv_p25bin_yrs pivv_p75bin_yrs pivv_p90bin_yrs

*** Table S-5: Correlation Matrix of Main Explanatory Variables
corr L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity ///
L1_de_lev L1_partnership L1_shared_igo3 L1_imp_china_share_rec L1_aid_projects1_3yravg L1_armsimports_vol_3yravg ///
L1_cap_pop L1_cap_res distance nam if year>=1990

*** Table S-6: Summary of Effects of Main Explanatory Variables
logit pivv_p25bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3, rob cluster(country_no) or
logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3, rob cluster(country_no) or
logit pivv_p90bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3, rob cluster(country_no) or
logit pivv_p25bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3 if year <=1989, rob cluster(country_no) or
logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year <=1989, rob cluster(country_no) or
logit pivv_p90bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year <=1989, rob cluster(country_no) or
logit pivv_p25bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3 if year <=1989, rob cluster(country_no) or
logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year <=1989, rob cluster(country_no) or
logit pivv_p90bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year <=1989, rob cluster(country_no) or
logit pivv_p25bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p90bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p25bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p90bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p25bin L1_de_lev L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p75bin L1_de_lev L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p90bin L1_de_lev L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p25bin L1_partnership L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p75bin L1_partnership L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p90bin L1_partnership L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p25bin L1_shared_igo3 L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p75bin L1_shared_igo3 L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p90bin L1_shared_igo3 L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p25bin L1_trade_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p75bin L1_trade_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p90bin L1_trade_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p25bin L1_exp_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p75bin L1_exp_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p90bin L1_exp_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p25bin L1_imp_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p75bin L1_imp_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p90bin L1_imp_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p25bin L1_aid_projects1_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p75bin L1_aid_projects1_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p90bin L1_aid_projects1_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p25bin L1_armsimports_vol_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p25bin_yrs pivv_p25bin_yrs2 pivv_p25bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p75bin L1_armsimports_vol_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no) or
logit pivv_p90bin L1_armsimports_vol_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no) or

*** Table S-7: Logistic Regression Models of Foreign Policy Similarity, Parallel Policy Choices, Further Controls (post-Cold War)
eststo: logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam post2001 pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p90bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam post2001 pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam antius pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p90bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam antius pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no) 
eststo: logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam L1_ecodep_china2 pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p90bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam L1_ecodep_china2 pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p75bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam confinst pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990, rob cluster(country_no)
eststo: logit pivv_p90bin L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam confinst pivv_p90bin_yrs pivv_p90bin_yrs2 pivv_p90bin_yrs3 if year >=1990, rob cluster(country_no)
esttab using tableS7.rtf,se pr2 ar2 scalars(chi2) label title(Table S-6: Logistic Regression Models of Foreign Policy Similarity, Parallel Policy Choices and further controls) mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) compress nogap
eststo clear

*** Table S-8: Logistic Regression Models of Foreign Policy Similarity and Diplomatic Linkages (post-Cold War era, split samples)
eststo: logit pivv_p75bin L1_de_lev L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990 & L1_status_similarity_own2>=4 & L1_status_similarity_own2!=., rob cluster(country_no)
eststo: logit pivv_p75bin L1_partnership L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990 & L1_status_similarity_own2>=4 & L1_status_similarity_own2!=., rob cluster(country_no)
eststo: logit pivv_p75bin L1_shared_igo3 L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990 & L1_status_similarity_own2>=4 & L1_status_similarity_own2!=., rob cluster(country_no)
eststo: logit pivv_p75bin L1_de_lev L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990 & L1_status_similarity_own2<=3 & L1_status_similarity_own2!=., rob cluster(country_no)
eststo: logit pivv_p75bin L1_partnership L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990 & L1_status_similarity_own2<=3 & L1_status_similarity_own2!=., rob cluster(country_no)
eststo: logit pivv_p75bin L1_shared_igo3 L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990 & L1_status_similarity_own2<=3 & L1_status_similarity_own2!=., rob cluster(country_no)
esttab using tableS8.rtf,se pr2 ar2 scalars(chi2) label title(Table S-7: Logistic Regression Models of Foreign Policy Similarity and Diplomatic Linkages (split samples)) mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) compress nogap
eststo clear

*** Table S-9: Logistic Regression Models of Foreign Policy Similarity and Trade, Aid and Arms (post-Cold War era, split samples)
eststo: logit pivv_p75bin L1_imp_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990 & L1_status_similarity_own2>=4 & L1_status_similarity_own2!=., rob cluster(country_no)
eststo: logit pivv_p75bin L1_aid_projects1_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990 & L1_status_similarity_own2>=4 & L1_status_similarity_own2!=., rob cluster(country_no)
eststo: logit pivv_p75bin L1_armsimports_vol_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990 & L1_status_similarity_own2>=4 & L1_status_similarity_own2!=., rob cluster(country_no)
eststo: logit pivv_p75bin L1_imp_china_share_rec L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990 & L1_status_similarity_own2<=3 & L1_status_similarity_own2!=., rob cluster(country_no)
eststo: logit pivv_p75bin L1_aid_projects1_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990 & L1_status_similarity_own2<=3 & L1_status_similarity_own2!=., rob cluster(country_no)
eststo: logit pivv_p75bin L1_armsimports_vol_3yravg L1_status_similarity_own2 L1_polglobalization_similarity L1_socglobalization_similarity L1_ecoglobalization_similarity L1_cap_pop L1_cap_res distance nam pivv_p75bin_yrs pivv_p75bin_yrs2 pivv_p75bin_yrs3 if year >=1990 & L1_status_similarity_own2<=3 & L1_status_similarity_own2!=., rob cluster(country_no)
esttab using tableS9.rtf,se pr2 ar2 scalars(chi2) label title(Table S-8: Logistic Regression Models of Foreign Policy Similarity and Trade, Aid and Arms (split samples)) mtitles() star(+ 0.10 * 0.05 ** 0.01 *** 0.001) compress nogap
eststo clear

*** Figure S-1: Foreign Policy Similarity by Policy Issues (Supporting Material)
bysort year: egen  pivv_nu_mean=mean(pivv_nu)
bysort year: egen  pivv_co_mean=mean(pivv_co)
bysort year: egen  pivv_china_us1_mean=mean(pivv_china_us1)
bysort year: egen  pivv_imp_mean=mean(pivv_imp)
bysort year: egen  pivv_ec_mean=mean(pivv_ec)
bysort year: egen  pivv_hr_mean=mean(pivv_hr)
bysort year: egen  pivv_me_mean=mean(pivv_me)
bysort year: egen  pivv_di_mean=mean(pivv_di)

#delimit ;
graph twoway 
(line pivv_hr_mean year, lw(medthick) lp(dash) lc(gs4))
(line pivv_me_mean year, lw(medthick) lp(dash_dot) lc(gs4))
(line pivv_co_mean year, lw(medthick) lp(longdash) lc(gs8))
(line pivv_ec_mean year, lw(medthick) lp(shortdash_dot) lc(gs12)) 
(line pivv_all_mean year, lw(thick) lp(solid) lc(black)) if UNnames!="China"
, legend(label(1 "Human Rights") label(2 "Middle East/Palestinian conflict") label(3 "Colonialism") label(4 "(Economic) Development") label(5 "All votes") cols(2) symysize(0.8) size(small) span) 
ytitle("Foreign Policy Similarity") 
xtitle("Year");

#delimit ;
graph twoway 
(line pivv_di_mean year, lw(medthick) lp(dash) lc(gs4))
(line pivv_nu_mean year, lw(medthick) lp(dash_dot) lc(gs4))
(line pivv_imp_mean year, lw(medthick) lp(longdash) lc(gs8))
(line pivv_china_us1_mean year, lw(medthick) lp(shortdash_dot) lc(gs12)) 
(line pivv_all_mean year, lw(thick) lp(solid) lc(black)) if UNnames!="China"
, legend(label(1 "Arms control and disarmament") label(2 "Nuclear weapons and material") label(3 "US key votes") label(4 "Contested votes") label(5 "All votes") cols(2) symysize(0.8) size(small) span) 
ytitle("Foreign Policy Similarity") 
xtitle("Year");
