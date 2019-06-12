cd "" // insert file pathway here

*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
************************************ Summary Statistics *********************************
*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
 
 cd "" // insert file pathway here
  
 *Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

 keep if year==2006 &  abs(compage_diff06)<=120
 
 gen dad_college=1 if PEDdadeduc__8==1 | PEDdadeduc__9==1
 replace dad_college=0 if PEDdadeduc__8==0 & PEDdadeduc__9==0
 
 gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
 gen at_least_one_tv=1 if INCtv_enem_5==0
 replace at_least_one_tv=0 if INCtv_enem_5==1
 
 gen at_least_one_radio=1 if INCradio_en_5==0
 replace at_least_one_radio=0 if INCradio_en_5==1
 
  gen at_least_one_computer=1 if INCpc_enem_5==0
 replace at_least_one_computer=0 if INCpc_enem_5==1
 
   gen at_least_one_car=1 if INCauto_ene_5==0
 replace at_least_one_car=0 if INCauto_ene_5==1
 
 gen at_least_one_wash=1 if INCwash_ene_5==0
 replace at_least_one_wash=0 if INCwash_ene_5==1
 
 gen at_least_one_fridge=1 if INCfridge_e_5==0
 replace at_least_one_fridge=0 if INCfridge_e_5==1
   
 gen at_least_one_cell=1 if INCphone_en_5==0
 replace at_least_one_cell=0 if INCphone_en_5==1
 
 gen read_comic_num=3 if read_comic=="A"
 replace read_comic_num=2 if read_comic=="B"
  replace read_comic_num=2 if read_comic=="C"

  gen read_science_num=3 if read_science=="A"
 replace read_science_num=2 if read_science=="B"
  replace read_science_num=2 if read_science=="C" 
  
   gen read_romance_num=3 if read_romance=="A"
 replace read_romance_num=2 if read_romance=="B"
  replace read_romance_num=2 if read_romance=="C"  
  
 egen prop_missing=rowmean(HHShhsize_e_9999 PEDdadeduc__1 PEDmomeduc__1 INCtv_enem_1 INCdvd_enem_1 INCradio_en_1 INCpc_enem_1 INCauto_ene_1 ///
 INCwash_ene_1 INCfridge_e_1 INCphone_en_1 INCcphone_e_1 INCnet_enem_1 INCcable_en_1 mom_DKwork dad_DKwork  miss_city)

 sum prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_proun ///
 read_comic_num read_science_num read_romance_num 

  //outcomes 
sum  NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean
 
  *Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

 keep if year==2007 &  abs(compage_diff06)<=120
 
 gen dad_college=1 if PEDdadeduc__8==1 | PEDdadeduc__9==1
 replace dad_college=0 if PEDdadeduc__8==0 & PEDdadeduc__9==0
 
 gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
 gen at_least_one_tv=1 if INCtv_enem_5==0
 replace at_least_one_tv=0 if INCtv_enem_5==1
 
 gen at_least_one_radio=1 if INCradio_en_5==0
 replace at_least_one_radio=0 if INCradio_en_5==1
 
  gen at_least_one_computer=1 if INCpc_enem_5==0
 replace at_least_one_computer=0 if INCpc_enem_5==1
 
   gen at_least_one_car=1 if INCauto_ene_5==0
 replace at_least_one_car=0 if INCauto_ene_5==1
 
 gen at_least_one_wash=1 if INCwash_ene_5==0
 replace at_least_one_wash=0 if INCwash_ene_5==1
 
 gen at_least_one_fridge=1 if INCfridge_e_5==0
 replace at_least_one_fridge=0 if INCfridge_e_5==1
   
 gen at_least_one_cell=1 if INCphone_en_5==0
 replace at_least_one_cell=0 if INCphone_en_5==1
 
 gen read_comic_num=3 if read_comic=="A"
 replace read_comic_num=2 if read_comic=="B"
  replace read_comic_num=2 if read_comic=="C"

  gen read_science_num=3 if read_science=="A"
 replace read_science_num=2 if read_science=="B"
  replace read_science_num=2 if read_science=="C" 
  
   gen read_romance_num=3 if read_romance=="A"
 replace read_romance_num=2 if read_romance=="B"
  replace read_romance_num=2 if read_romance=="C"  
  
 egen prop_missing=rowmean(HHShhsize_e_9999 PEDdadeduc__1 PEDmomeduc__1 INCtv_enem_1 INCdvd_enem_1 INCradio_en_1 INCpc_enem_1 INCauto_ene_1 ///
 INCwash_ene_1 INCfridge_e_1 INCphone_en_1 INCcphone_e_1 INCnet_enem_1 INCcable_en_1 mom_DKwork dad_DKwork  miss_city)

 sum prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num 
 
  //outcomes 
sum  NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean
 
 
 *Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

 keep if year==2006 &  abs(volage_diff06)<=120
 
 gen dad_college=1 if PEDdadeduc__8==1 | PEDdadeduc__9==1
 replace dad_college=0 if PEDdadeduc__8==0 & PEDdadeduc__9==0
 
 gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
 gen at_least_one_tv=1 if INCtv_enem_5==0
 replace at_least_one_tv=0 if INCtv_enem_5==1
 
 gen at_least_one_radio=1 if INCradio_en_5==0
 replace at_least_one_radio=0 if INCradio_en_5==1
 
  gen at_least_one_computer=1 if INCpc_enem_5==0
 replace at_least_one_computer=0 if INCpc_enem_5==1
 
   gen at_least_one_car=1 if INCauto_ene_5==0
 replace at_least_one_car=0 if INCauto_ene_5==1
 
 gen at_least_one_wash=1 if INCwash_ene_5==0
 replace at_least_one_wash=0 if INCwash_ene_5==1
 
 gen at_least_one_fridge=1 if INCfridge_e_5==0
 replace at_least_one_fridge=0 if INCfridge_e_5==1
   
 gen at_least_one_cell=1 if INCphone_en_5==0
 replace at_least_one_cell=0 if INCphone_en_5==1
 
 gen read_comic_num=3 if read_comic=="A"
 replace read_comic_num=2 if read_comic=="B"
  replace read_comic_num=2 if read_comic=="C"

  gen read_science_num=3 if read_science=="A"
 replace read_science_num=2 if read_science=="B"
  replace read_science_num=2 if read_science=="C" 
  
   gen read_romance_num=3 if read_romance=="A"
 replace read_romance_num=2 if read_romance=="B"
  replace read_romance_num=2 if read_romance=="C"  
  
 egen prop_missing=rowmean(HHShhsize_e_9999 PEDdadeduc__1 PEDmomeduc__1 INCtv_enem_1 INCdvd_enem_1 INCradio_en_1 INCpc_enem_1 INCauto_ene_1 ///
 INCwash_ene_1 INCfridge_e_1 INCphone_en_1 INCcphone_e_1 INCnet_enem_1 INCcable_en_1 mom_DKwork dad_DKwork  miss_city)

 sum prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num 
 
  //outcomes 
sum  NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean
 
 
 
  *Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

 keep if year==2007 &  abs(volage_diff06)<=120
 
 gen dad_college=1 if PEDdadeduc__8==1 | PEDdadeduc__9==1
 replace dad_college=0 if PEDdadeduc__8==0 & PEDdadeduc__9==0
 
 gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
 gen at_least_one_tv=1 if INCtv_enem_5==0
 replace at_least_one_tv=0 if INCtv_enem_5==1
 
 gen at_least_one_radio=1 if INCradio_en_5==0
 replace at_least_one_radio=0 if INCradio_en_5==1
 
  gen at_least_one_computer=1 if INCpc_enem_5==0
 replace at_least_one_computer=0 if INCpc_enem_5==1
 
   gen at_least_one_car=1 if INCauto_ene_5==0
 replace at_least_one_car=0 if INCauto_ene_5==1
 
 gen at_least_one_wash=1 if INCwash_ene_5==0
 replace at_least_one_wash=0 if INCwash_ene_5==1
 
 gen at_least_one_fridge=1 if INCfridge_e_5==0
 replace at_least_one_fridge=0 if INCfridge_e_5==1
   
 gen at_least_one_cell=1 if INCphone_en_5==0
 replace at_least_one_cell=0 if INCphone_en_5==1
 
 gen read_comic_num=3 if read_comic=="A"
 replace read_comic_num=2 if read_comic=="B"
  replace read_comic_num=2 if read_comic=="C"

  gen read_science_num=3 if read_science=="A"
 replace read_science_num=2 if read_science=="B"
  replace read_science_num=2 if read_science=="C" 
  
   gen read_romance_num=3 if read_romance=="A"
 replace read_romance_num=2 if read_romance=="B"
  replace read_romance_num=2 if read_romance=="C"  
  
 egen prop_missing=rowmean(HHShhsize_e_9999 PEDdadeduc__1 PEDmomeduc__1 INCtv_enem_1 INCdvd_enem_1 INCradio_en_1 INCpc_enem_1 INCauto_ene_1 ///
 INCwash_ene_1 INCfridge_e_1 INCphone_en_1 INCcphone_e_1 INCnet_enem_1 INCcable_en_1 mom_DKwork dad_DKwork  miss_city)

 sum prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num 
 
 //outcomes 
sum  NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean
 
 

*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
************************************ Scale Diagnostics **********************************
*****************************************************************************************
*****************************************************************************************
*****************************************************************************************

cd "" // insert file pathway here

// all
use "final_jop_data_brazil.dta", clear

 keep if abs(volage_diff06)<=120

*Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
alpha NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political
factor NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political

*Perceive Discrimination
alpha perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc
factor perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc

*Suffer Discrimination 
alpha suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc
factor suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc

*Tolerance
alpha intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel
factor intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel

*Social Awareness
alpha zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4
factor zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4

*Political Knowledge
alpha sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8
factor sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8


// both compulsory voting cutoffs
use "final_jop_data_brazil.dta", clear

 keep if abs(compage_diff06)<=120

*Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
alpha NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political
factor NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political

*Perceive Discrimination
alpha perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc
factor perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc

*Suffer Discrimination 
alpha suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc
factor suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc

*Tolerance
alpha intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel
factor intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel

*Social Awareness
alpha zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4
factor zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4

*Political Knowledge
alpha sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8
factor sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8

*Membership (PCA, any, mean)
alpha q_168 q_169 q_170 q_173 q_171 q_172 q_174
factor q_168 q_169 q_170 q_173 q_171 q_172 q_174

// both voluntary voting cutoffs
use "final_jop_data_brazil.dta", clear

 keep if abs(volage_diff06)<=120

*Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
alpha NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political
factor NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political

*Perceive Discrimination
alpha perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc
factor perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc

*Suffer Discrimination 
alpha suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc
factor suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc

*Tolerance
alpha intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel
factor intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel

*Social Awareness
alpha zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4
factor zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4

*Political Knowledge
alpha sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8
factor sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8

*Membership (PCA, any, mean)
alpha q_168 q_169 q_170 q_173 q_171 q_172 q_174
factor q_168 q_169 q_170 q_173 q_171 q_172 q_174

// all of them 

use "final_jop_data_brazil.dta", clear

 factor NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political /// Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
 perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc /// Perceive Discrimination
 suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc /// Suffer Discrimination 
 intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel /// Tolerance
 zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4 /// Social Awareness
 sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8 /// Political Knowledge
 q_168 q_169 q_170 q_173 q_171 q_172 q_174, blanks(0.3) // Membership (PCA, any, mean)

  factor NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political /// Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
 perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc /// Perceive Discrimination
 suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc /// Suffer Discrimination 
 intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel /// Tolerance
 zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4 /// Social Awareness
 sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8 /// Political Knowledge
 q_168 q_169 q_170 q_173 q_171 q_172 q_174, blanks(0.3) factor(5) // Membership (PCA, any, mean)

 
 
*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
************************************ Random Placebo Cutoffs *****************************
*****************************************************************************************
*****************************************************************************************
*****************************************************************************************

cd "" // insert file pathway here

******* Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if year==2006
keep if abs(compage_diff06)<=120

forvalues i=20(10)100 {
	gen compage_diff06_`i'=compage_diff06- `i'
	}

*Positive to 0's
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
 rdrobust `var' compage_diff06_`i', c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list r_`var'_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list se_`var'_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list p_`var'_`i' 
}
}


*Negative to 0's
forvalues i=20(10)100 {
	gen compage_diff06_neg_`i'=compage_diff06+ `i'
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
 rdrobust `var' compage_diff06_neg_`i', c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_neg_`i'=b[1,3]
	scalar p_`var'_neg_`i'=e(pv_rb)
	scalar se_`var'_neg_`i'=e(se_tau_rb)	
	scalar cih_`var'_neg_`i'=e(ci_r_rb)
	scalar cil_`var'_neg_`i'=e(ci_l_rb)
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list r_`var'_neg_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list se_`var'_neg_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list p_`var'_neg_`i' 
}
}


******** Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if year==2007
keep if abs(compage_diff06)<=120

forvalues i=20(10)100 {
	gen compage_diff06_`i'=compage_diff06- `i'
	}

*Positive to 0's
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
 rdrobust `var' compage_diff06_`i', c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list r_`var'_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list se_`var'_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list p_`var'_`i' 
}
}


*Negative to 0's
forvalues i=20(10)100 {
	gen compage_diff06_neg_`i'=compage_diff06+ `i'
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
 rdrobust `var' compage_diff06_neg_`i', c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_neg_`i'=b[1,3]
	scalar p_`var'_neg_`i'=e(pv_rb)
	scalar se_`var'_neg_`i'=e(se_tau_rb)	
	scalar cih_`var'_neg_`i'=e(ci_r_rb)
	scalar cil_`var'_neg_`i'=e(ci_l_rb)
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list r_`var'_neg_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list se_`var'_neg_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list p_`var'_neg_`i' 
}
}


******* Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if year==2006
keep if abs(volage_diff06)<=120

forvalues i=20(10)100 {
	gen volage_diff06_`i'=volage_diff06- `i'
	}

*Positive to 0's
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
 rdrobust `var' volage_diff06_`i', c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list r_`var'_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list se_`var'_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list p_`var'_`i' 
}
}


*Negative to 0's
forvalues i=20(10)100 {
	gen volage_diff06_neg_`i'=volage_diff06+ `i'
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
 rdrobust `var' volage_diff06_neg_`i', c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_neg_`i'=b[1,3]
	scalar p_`var'_neg_`i'=e(pv_rb)
	scalar se_`var'_neg_`i'=e(se_tau_rb)	
	scalar cih_`var'_neg_`i'=e(ci_r_rb)
	scalar cil_`var'_neg_`i'=e(ci_l_rb)
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list r_`var'_neg_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list se_`var'_neg_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list p_`var'_neg_`i' 
}
}


******** Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if year==2007
keep if abs(volage_diff06)<=120

forvalues i=20(10)100 {
	gen volage_diff06_`i'=volage_diff06- `i'
	}

*Positive to 0's
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
 rdrobust `var' volage_diff06_`i', c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list r_`var'_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list se_`var'_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list p_`var'_`i' 
}
}


*Negative to 0's
forvalues i=20(10)100 {
	gen volage_diff06_neg_`i'=volage_diff06+ `i'
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
 rdrobust `var' volage_diff06_neg_`i', c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_neg_`i'=b[1,3]
	scalar p_`var'_neg_`i'=e(pv_rb)
	scalar se_`var'_neg_`i'=e(se_tau_rb)	
	scalar cih_`var'_neg_`i'=e(ci_r_rb)
	scalar cil_`var'_neg_`i'=e(ci_l_rb)
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list r_`var'_neg_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list se_`var'_neg_`i' 
}
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=20(10)100 {
scalar list p_`var'_neg_`i' 
}
}

*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
************************************ McCrary Checks *************************************
*****************************************************************************************
*****************************************************************************************
*****************************************************************************************

cd "" // insert file pathway here

*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if year==2006

 rddensity compage_diff06, all //  Full BW 

 keep if abs(compage_diff06)<=120

 rddensity compage_diff06, all //  
 
egen sum=sum(1), by(compage_diff06)
egen pop=sum(1)

gen share=(sum/pop)*100
drop sum pop
egen tag_grid=tag(compage_diff06)
keep if tag_grid==1
gen D=(compage_diff06>0)
gen compage_diff06_2=compage_diff06^2
gen compage_diff06_3=compage_diff06^3
gen compage_diff06_4=compage_diff06^4
gen Dcompage_diff06=D*compage_diff06
gen Dcompage_diff06_2=D*compage_diff06_2
gen Dcompage_diff06_3=D*compage_diff06_3
gen Dcompage_diff06_4=D*compage_diff06_4
tab share, m

regress share D compage_diff06 compage_diff06_2 compage_diff06_3 compage_diff06_4 Dcompage_diff06 Dcompage_diff06_2 Dcompage_diff06_3 Dcompage_diff06_4, hc3

rdrobust share compage_diff06, all
sum share

twoway (lpolyci share compage_diff06 if year==2006 & compage_diff06<0, bwidth(7) fintensity(inten10)  clcolor(black) )  ///
(lpolyci share compage_diff06 if year==2006 & compage_diff06>=0, bwidth(7) fintensity(inten10)  clcolor(black)) ///
(scatter share compage_diff06 if year==2006 & compage_diff06<0, mcolor(black)  msymbol(circle))  ///
(scatter share compage_diff06 if year==2006 & compage_diff06>=0, mcolor(black) mfcolor(none)  msymbol(circle)  xline(0, lpat(dash) lcol(red))) ///
, legend(off) graphregion(color(white)) ytitle("Density") xtitle("Age in days at election date (relative to 18 complete years)") ///
 xlabel(-120(20)120, grid) ylabel(0(0.1)1, grid) 

graph save "mccrary_comp06before_density.gph", replace
 

*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if year==2007
  
  rddensity compage_diff06, all //  Full BW

 keep if  abs(compage_diff06)<=120
 
  rddensity compage_diff06, all //  
 
egen sum=sum(1), by(compage_diff06)
egen pop=sum(1)

gen share=(sum/pop)*100
drop sum pop
egen tag_grid=tag(compage_diff06)
keep if tag_grid==1
gen D=(compage_diff06>0)
gen compage_diff06_2=compage_diff06^2
gen compage_diff06_3=compage_diff06^3
gen compage_diff06_4=compage_diff06^4
gen Dcompage_diff06=D*compage_diff06
gen Dcompage_diff06_2=D*compage_diff06_2
gen Dcompage_diff06_3=D*compage_diff06_3
gen Dcompage_diff06_4=D*compage_diff06_4
tab share, m

regress share D compage_diff06 compage_diff06_2 compage_diff06_3 compage_diff06_4 Dcompage_diff06 Dcompage_diff06_2 Dcompage_diff06_3 Dcompage_diff06_4, hc3

rdrobust share compage_diff06, all
sum share

twoway (lpolyci share compage_diff06 if year==2007 & compage_diff06<0, bwidth(7) fintensity(inten10)  clcolor(black) )  ///
(lpolyci share compage_diff06 if year==2007 & compage_diff06>=0, bwidth(7) fintensity(inten10)  clcolor(black)) ///
(scatter share compage_diff06 if year==2007 & compage_diff06<0, mcolor(black)  msymbol(circle))  ///
(scatter share compage_diff06 if year==2007 & compage_diff06>=0, mcolor(black) mfcolor(none)  msymbol(circle)  xline(0, lpat(dash) lcol(red))) ///
, legend(off) graphregion(color(white)) ytitle("Density") xtitle("Age in days at election date (relative to 18 complete years)") ///
 xlabel(-120(20)120, grid) ylabel(0(0.1)1, grid) 

graph save "mccrary_comp06after_density.gph", replace


*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if year==2006 

  rddensity volage_diff06, all  //  full BW

keep if abs(volage_diff06)<=120
 
  rddensity volage_diff06, all //  

egen sum=sum(1), by(volage_diff06)
egen pop=sum(1)

gen share=(sum/pop)*100
drop sum pop
egen tag_grid=tag(volage_diff06)
keep if tag_grid==1
gen D=(volage_diff06>0)
gen volage_diff06_2=volage_diff06^2
gen volage_diff06_3=volage_diff06^3
gen volage_diff06_4=volage_diff06^4
gen Dvolage_diff06=D*volage_diff06
gen Dvolage_diff06_2=D*volage_diff06_2
gen Dvolage_diff06_3=D*volage_diff06_3
gen Dvolage_diff06_4=D*volage_diff06_4
tab share, m

regress share D volage_diff06 volage_diff06_2 volage_diff06_3 volage_diff06_4 Dvolage_diff06 Dvolage_diff06_2 Dvolage_diff06_3 Dvolage_diff06_4, hc3

rdrobust share volage_diff06, all
sum share

twoway (lpolyci share volage_diff06 if year==2006 & volage_diff06<0, bwidth(7) fintensity(inten10)  clcolor(black) )  ///
(lpolyci share volage_diff06 if year==2006 & volage_diff06>=0, bwidth(7) fintensity(inten10)  clcolor(black)) ///
(scatter share volage_diff06 if year==2006 & volage_diff06<0, mcolor(black)  msymbol(circle))  ///
(scatter share volage_diff06 if year==2006 & volage_diff06>=0, mcolor(black) mfcolor(none)  msymbol(circle)  xline(0, lpat(dash) lcol(red))) ///
, legend(off) graphregion(color(white)) ytitle("Density") xtitle("Age in days at election date (relative to 16 complete years)") ///
 xlabel(-120(20)120, grid) ylabel(0(0.1)1, grid) 

 graph save "mccrary_vol06before_density.gph", replace

 
*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if year==2007

  rddensity volage_diff06, all  //  full BW

keep if abs(volage_diff06)<=120
 
  rddensity volage_diff06, all  //  
 
egen sum=sum(1), by(volage_diff06)
egen pop=sum(1)

gen share=(sum/pop)*100
drop sum pop
egen tag_grid=tag(volage_diff06)
keep if tag_grid==1
gen D=(volage_diff06>0)
gen volage_diff06_2=volage_diff06^2
gen volage_diff06_3=volage_diff06^3
gen volage_diff06_4=volage_diff06^4
gen Dvolage_diff06=D*volage_diff06
gen Dvolage_diff06_2=D*volage_diff06_2
gen Dvolage_diff06_3=D*volage_diff06_3
gen Dvolage_diff06_4=D*volage_diff06_4
tab share, m

regress share D volage_diff06 volage_diff06_2 volage_diff06_3 volage_diff06_4 Dvolage_diff06 Dvolage_diff06_2 Dvolage_diff06_3 Dvolage_diff06_4, hc3

rdrobust share volage_diff06, all
sum share

twoway (lpolyci share volage_diff06 if year==2007 & volage_diff06<0, bwidth(7) fintensity(inten10)  clcolor(black) )  ///
(lpolyci share volage_diff06 if year==2007 & volage_diff06>=0, bwidth(7) fintensity(inten10)  clcolor(black)) ///
(scatter share volage_diff06 if year==2007 & volage_diff06<0, mcolor(black)  msymbol(circle))  ///
(scatter share volage_diff06 if year==2007 & volage_diff06>=0, mcolor(black) mfcolor(none)  msymbol(circle)  xline(0, lpat(dash) lcol(red))) ///
, legend(off) graphregion(color(white)) ytitle("Density") xtitle("Age in days at election date (relative to 16 complete years)") ///
 xlabel(-120(20)120, grid) ylabel(0(0.1)1, grid) 

  graph save "mccrary_vol06afer_density.gph", replace

  
*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
************************************ Covariate Balance **********************************
*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
 
 cd "" // insert file pathway here
  
 *Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

 keep if year==2006 &  abs(compage_diff06)<=120
 
 gen dad_college=1 if PEDdadeduc__8==1 | PEDdadeduc__9==1
 replace dad_college=0 if PEDdadeduc__8==0 & PEDdadeduc__9==0
 
 gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
 gen at_least_one_tv=1 if INCtv_enem_5==0
 replace at_least_one_tv=0 if INCtv_enem_5==1
 
 gen at_least_one_radio=1 if INCradio_en_5==0
 replace at_least_one_radio=0 if INCradio_en_5==1
 
  gen at_least_one_computer=1 if INCpc_enem_5==0
 replace at_least_one_computer=0 if INCpc_enem_5==1
 
   gen at_least_one_car=1 if INCauto_ene_5==0
 replace at_least_one_car=0 if INCauto_ene_5==1
 
 gen at_least_one_wash=1 if INCwash_ene_5==0
 replace at_least_one_wash=0 if INCwash_ene_5==1
 
 gen at_least_one_fridge=1 if INCfridge_e_5==0
 replace at_least_one_fridge=0 if INCfridge_e_5==1
   
 gen at_least_one_cell=1 if INCphone_en_5==0
 replace at_least_one_cell=0 if INCphone_en_5==1
 
 gen read_comic_num=3 if read_comic=="A"
 replace read_comic_num=2 if read_comic=="B"
  replace read_comic_num=2 if read_comic=="C"

  gen read_science_num=3 if read_science=="A"
 replace read_science_num=2 if read_science=="B"
  replace read_science_num=2 if read_science=="C" 
  
   gen read_romance_num=3 if read_romance=="A"
 replace read_romance_num=2 if read_romance=="B"
  replace read_romance_num=2 if read_romance=="C"  
  
 egen prop_missing=rowmean(HHShhsize_e_9999 PEDdadeduc__1 PEDmomeduc__1 INCtv_enem_1 INCdvd_enem_1 INCradio_en_1 INCpc_enem_1 INCauto_ene_1 ///
 INCwash_ene_1 INCfridge_e_1 INCphone_en_1 INCcphone_e_1 INCnet_enem_1 INCcable_en_1 mom_DKwork dad_DKwork  miss_city)

 foreach var in prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num {

	rdrobust `var' compage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	}
 
 // Joint Sig
 
 gen D=(compage_diff06>0)
gen compage_diff06_2=compage_diff06^2
gen compage_diff06_3=compage_diff06^3
gen compage_diff06_4=compage_diff06^4
gen Dcompage_diff06=D*compage_diff06
gen Dcompage_diff06_2=D*compage_diff06_2
gen Dcompage_diff06_3=D*compage_diff06_3
gen Dcompage_diff06_4=D*compage_diff06_4

regress D compage_diff06 compage_diff06_2 compage_diff06_3 compage_diff06_4 Dcompage_diff06 Dcompage_diff06_2 Dcompage_diff06_3 Dcompage_diff06_4    ///
prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num, hc3
 
 test prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num

 // Higher Order Polynomial
 
  foreach var in prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num {
 rdrobust `var' compage_diff06, c(0) p(4) q(5) all vce(cluster dateob) 
}
 
 
 
 // Nonparametric
   foreach var in prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num {
 
 rd `var'  compage_diff06 , mbw(100) bw(10)
 
	}	 
 
 *Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

 keep if year==2007 &  abs(compage_diff06)<=120
 
 gen dad_college=1 if PEDdadeduc__8==1 | PEDdadeduc__9==1
 replace dad_college=0 if PEDdadeduc__8==0 & PEDdadeduc__9==0
 
 gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
 gen at_least_one_tv=1 if INCtv_enem_5==0
 replace at_least_one_tv=0 if INCtv_enem_5==1
 
 gen at_least_one_radio=1 if INCradio_en_5==0
 replace at_least_one_radio=0 if INCradio_en_5==1
 
  gen at_least_one_computer=1 if INCpc_enem_5==0
 replace at_least_one_computer=0 if INCpc_enem_5==1
 
   gen at_least_one_car=1 if INCauto_ene_5==0
 replace at_least_one_car=0 if INCauto_ene_5==1
 
 gen at_least_one_wash=1 if INCwash_ene_5==0
 replace at_least_one_wash=0 if INCwash_ene_5==1
 
 gen at_least_one_fridge=1 if INCfridge_e_5==0
 replace at_least_one_fridge=0 if INCfridge_e_5==1
   
 gen at_least_one_cell=1 if INCphone_en_5==0
 replace at_least_one_cell=0 if INCphone_en_5==1
 
 gen read_comic_num=3 if read_comic=="A"
 replace read_comic_num=2 if read_comic=="B"
  replace read_comic_num=2 if read_comic=="C"

  gen read_science_num=3 if read_science=="A"
 replace read_science_num=2 if read_science=="B"
  replace read_science_num=2 if read_science=="C" 
  
   gen read_romance_num=3 if read_romance=="A"
 replace read_romance_num=2 if read_romance=="B"
  replace read_romance_num=2 if read_romance=="C"  
  
 egen prop_missing=rowmean(HHShhsize_e_9999 PEDdadeduc__1 PEDmomeduc__1 INCtv_enem_1 INCdvd_enem_1 INCradio_en_1 INCpc_enem_1 INCauto_ene_1 ///
 INCwash_ene_1 INCfridge_e_1 INCphone_en_1 INCcphone_e_1 INCnet_enem_1 INCcable_en_1 mom_DKwork dad_DKwork  miss_city)

 foreach var in prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num {

	rdrobust `var' compage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	}
 
 // Joint Sig
 
 gen D=(compage_diff06>0)
gen compage_diff06_2=compage_diff06^2
gen compage_diff06_3=compage_diff06^3
gen compage_diff06_4=compage_diff06^4
gen Dcompage_diff06=D*compage_diff06
gen Dcompage_diff06_2=D*compage_diff06_2
gen Dcompage_diff06_3=D*compage_diff06_3
gen Dcompage_diff06_4=D*compage_diff06_4

regress D compage_diff06 compage_diff06_2 compage_diff06_3 compage_diff06_4 Dcompage_diff06 Dcompage_diff06_2 Dcompage_diff06_3 Dcompage_diff06_4    ///
prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num, hc3
 
 test prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num
 
  // Higher Order Polynomial
 
  foreach var in prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num {
 rdrobust `var' compage_diff06, c(0) p(4) q(5) all vce(cluster dateob) 
}
 
 
 
 // Nonparametric
   foreach var in prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num {
 
 rd `var'  compage_diff06 , mbw(100) bw(10)
 
	}	 
 
 *Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if year==2006 &  abs(volage_diff06)<=120
 
 
 gen dad_college=1 if PEDdadeduc__8==1 | PEDdadeduc__9==1
 replace dad_college=0 if PEDdadeduc__8==0 & PEDdadeduc__9==0
 
 gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
 gen at_least_one_tv=1 if INCtv_enem_5==0
 replace at_least_one_tv=0 if INCtv_enem_5==1
 
 gen at_least_one_radio=1 if INCradio_en_5==0
 replace at_least_one_radio=0 if INCradio_en_5==1
 
  gen at_least_one_computer=1 if INCpc_enem_5==0
 replace at_least_one_computer=0 if INCpc_enem_5==1
 
   gen at_least_one_car=1 if INCauto_ene_5==0
 replace at_least_one_car=0 if INCauto_ene_5==1
 
 gen at_least_one_wash=1 if INCwash_ene_5==0
 replace at_least_one_wash=0 if INCwash_ene_5==1
 
 gen at_least_one_fridge=1 if INCfridge_e_5==0
 replace at_least_one_fridge=0 if INCfridge_e_5==1
   
 gen at_least_one_cell=1 if INCphone_en_5==0
 replace at_least_one_cell=0 if INCphone_en_5==1
 
 gen read_comic_num=3 if read_comic=="A"
 replace read_comic_num=2 if read_comic=="B"
  replace read_comic_num=2 if read_comic=="C"

  gen read_science_num=3 if read_science=="A"
 replace read_science_num=2 if read_science=="B"
  replace read_science_num=2 if read_science=="C" 
  
   gen read_romance_num=3 if read_romance=="A"
 replace read_romance_num=2 if read_romance=="B"
  replace read_romance_num=2 if read_romance=="C"  
  
 egen prop_missing=rowmean(HHShhsize_e_9999 PEDdadeduc__1 PEDmomeduc__1 INCtv_enem_1 INCdvd_enem_1 INCradio_en_1 INCpc_enem_1 INCauto_ene_1 ///
 INCwash_ene_1 INCfridge_e_1 INCphone_en_1 INCcphone_e_1 INCnet_enem_1 INCcable_en_1 mom_DKwork dad_DKwork  miss_city)

 foreach var in prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num {

	rdrobust `var' volage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	}
 
 // Joint Sig
 
 gen D=(volage_diff06>0)
gen volage_diff06_2=volage_diff06^2
gen volage_diff06_3=volage_diff06^3
gen volage_diff06_4=volage_diff06^4
gen Dvolage_diff06=D*volage_diff06
gen Dvolage_diff06_2=D*volage_diff06_2
gen Dvolage_diff06_3=D*volage_diff06_3
gen Dvolage_diff06_4=D*volage_diff06_4

regress D volage_diff06 volage_diff06_2 volage_diff06_3 volage_diff06_4 Dvolage_diff06 Dvolage_diff06_2 Dvolage_diff06_3 Dvolage_diff06_4    ///
prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num, hc3
 
 test prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num
 
   // Higher Order Polynomial
 
  foreach var in prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num {
 rdrobust `var' volage_diff06, c(0) p(4) q(5) all vce(cluster dateob) 
}
 
 
 
 // Nonparametric
   foreach var in prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num {
 
 rd `var'  volage_diff06 , mbw(100) bw(10)
 
	}	
 
*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if year==2007 &  abs(volage_diff06)<=120
 
 
 
 gen dad_college=1 if PEDdadeduc__8==1 | PEDdadeduc__9==1
 replace dad_college=0 if PEDdadeduc__8==0 & PEDdadeduc__9==0
 
 gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
 gen at_least_one_tv=1 if INCtv_enem_5==0
 replace at_least_one_tv=0 if INCtv_enem_5==1
 
 gen at_least_one_radio=1 if INCradio_en_5==0
 replace at_least_one_radio=0 if INCradio_en_5==1
 
  gen at_least_one_computer=1 if INCpc_enem_5==0
 replace at_least_one_computer=0 if INCpc_enem_5==1
 
   gen at_least_one_car=1 if INCauto_ene_5==0
 replace at_least_one_car=0 if INCauto_ene_5==1
 
 gen at_least_one_wash=1 if INCwash_ene_5==0
 replace at_least_one_wash=0 if INCwash_ene_5==1
 
 gen at_least_one_fridge=1 if INCfridge_e_5==0
 replace at_least_one_fridge=0 if INCfridge_e_5==1
   
 gen at_least_one_cell=1 if INCphone_en_5==0
 replace at_least_one_cell=0 if INCphone_en_5==1
 
 gen read_comic_num=3 if read_comic=="A"
 replace read_comic_num=2 if read_comic=="B"
  replace read_comic_num=2 if read_comic=="C"

  gen read_science_num=3 if read_science=="A"
 replace read_science_num=2 if read_science=="B"
  replace read_science_num=2 if read_science=="C" 
  
   gen read_romance_num=3 if read_romance=="A"
 replace read_romance_num=2 if read_romance=="B"
  replace read_romance_num=2 if read_romance=="C"  
  
 egen prop_missing=rowmean(HHShhsize_e_9999 PEDdadeduc__1 PEDmomeduc__1 INCtv_enem_1 INCdvd_enem_1 INCradio_en_1 INCpc_enem_1 INCauto_ene_1 ///
 INCwash_ene_1 INCfridge_e_1 INCphone_en_1 INCcphone_e_1 INCnet_enem_1 INCcable_en_1 mom_DKwork dad_DKwork  miss_city)

 foreach var in prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num {

	rdrobust `var' volage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	}
 
 // Joint Sig
 
 gen D=(volage_diff06>0)
gen volage_diff06_2=volage_diff06^2
gen volage_diff06_3=volage_diff06^3
gen volage_diff06_4=volage_diff06^4
gen Dvolage_diff06=D*volage_diff06
gen Dvolage_diff06_2=D*volage_diff06_2
gen Dvolage_diff06_3=D*volage_diff06_3
gen Dvolage_diff06_4=D*volage_diff06_4

regress D volage_diff06 volage_diff06_2 volage_diff06_3 volage_diff06_4 Dvolage_diff06 Dvolage_diff06_2 Dvolage_diff06_3 Dvolage_diff06_4    ///
prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num, hc3
 
 test prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num
 
 // Higher Order Polynomial
 
  foreach var in prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num {
 rdrobust `var' volage_diff06, c(0) p(4) q(5) all vce(cluster dateob) 
}
 
 
 
 // Nonparametric
   foreach var in prop_missing male_enem white_enem brown_enem black_enem asian_enem indig_enem ///
 norace_enem resid_dad resid_mom resid_sibs own_home paved_acces water_acces elect_acces HHShhsize_e_9999 ///
 PEDdadeduc__1 dad_college PEDmomeduc__1 mom_college  at_least_one_tv at_least_one_radio at_least_one_computer  ///  
 at_least_one_car at_least_one_wash at_least_one_fridge  at_least_one_cell ///
 INCnet_enem_2 SCHyears_in_2 mom_pubemplee dad_pubemplee mom_agemplee dad_agemplee ///
 mom_DKwork dad_DKwork pubprim_only seniorSTUD_enem zscore_objALL zscore_essay zscore_prouni ///
 read_comic_num read_science_num read_romance_num {
 
 rd `var'  volage_diff06 , mbw(100) bw(10)
 
	}	
	
*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
************************************ Power Analysis *************************************
*****************************************************************************************
*****************************************************************************************
*****************************************************************************************

cd "" // insert file pathway here

*Pooled
use "final_jop_data_brazil.dta", clear

 gen compulsory_up=1 if year==2006 &  abs(compage_diff06)<=120
 gen compulsory_down=1 if year==2007 &  abs(compage_diff06)<=120
 gen voluntary_up=1 if year==2006 &  abs(volage_diff06)<=120
 gen voluntary_down=1 if year==2007 &  abs(volage_diff06)<=120

 replace compulsory_up=0 if compulsory_down==1 | voluntary_up==1 | voluntary_down==1
 replace compulsory_down=0 if compulsory_up==1 | voluntary_up==1 | voluntary_down==1
 replace voluntary_up=0 if compulsory_up==1 | compulsory_down==1 | voluntary_down==1
 replace voluntary_down=0 if compulsory_up==1 | compulsory_down==1 | voluntary_up==1
  
 gen composite_running=compage_diff06 if compulsory_up==1
 replace composite_running=compage_diff06 if compulsory_down==1
 replace composite_running=volage_diff06 if voluntary_up==1
 replace composite_running=volage_diff06 if voluntary_down==1


foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
		rdpower `var' composite_running, tau(0.25) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
		rdpower `var' composite_running, tau(0.375) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
		rdpower `var' composite_running, tau(0.5) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.
	}


*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006

*Optimal Bandwidth
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
		rdpower `var' compage_diff06, tau(0.25) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
		rdpower `var' compage_diff06, tau(0.375) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
		rdpower `var' compage_diff06, tau(0.5) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.
	}
	
*120 day bandwidth	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
		rdpower `var' compage_diff06, tau(0.25) h(120) b(120) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
		rdpower `var' compage_diff06, tau(0.375) h(120) b(120) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
		rdpower `var' compage_diff06, tau(0.5) h(120) b(120) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.
	}	

*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
		rdpower `var' compage_diff06, tau(0.25) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
		rdpower `var' compage_diff06, tau(0.375) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
		rdpower `var' compage_diff06, tau(0.5) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
		rdpower `var' compage_diff06, tau(0.25) h(120) b(120)  // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
		rdpower `var' compage_diff06, tau(0.375) h(120) b(120)  // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
		rdpower `var' compage_diff06, tau(0.5) h(120) b(120)  // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	}	
	
*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdpower `var' volage_diff06, tau(0.25) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	rdpower `var' volage_diff06, tau(0.375) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	rdpower `var' volage_diff06, tau(0.5) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdpower `var' volage_diff06, tau(0.25) h(120) b(120) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	rdpower `var' volage_diff06, tau(0.375) h(120) b(120) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	rdpower `var' volage_diff06, tau(0.5) h(120) b(120) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	}
	
*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdpower `var' volage_diff06, tau(0.25) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	rdpower `var' volage_diff06, tau(0.375) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	rdpower `var' volage_diff06, tau(0.5) // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdpower `var' volage_diff06, tau(0.25)  h(120) b(120)  // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	rdpower `var' volage_diff06, tau(0.375)  h(120) b(120)  // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	rdpower `var' volage_diff06, tau(0.5)  h(120) b(120)  // The output shows that the power against 1sd of the control is 0.993, above the usual threshold of 0.8
	}
		
	
*********************** Power Plots

*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdpower `var' compage_diff06, plot 
	gr_edit  .yaxis1.title.text = {}
	gr_edit .yaxis1.title.text.Arrpush Power
	gr_edit  .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Tau
	gr_edit .title.style.editstyle size(medium) editcopy
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Compulsory, Upstream	
	gr_edit .note.text = {}
	graph save "power_`var'_comp_up.gph", replace
	graph export "power_`var'_comp_up.pdf", replace
	}

*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdpower `var' compage_diff06, plot  
	gr_edit  .yaxis1.title.text = {}
	gr_edit .yaxis1.title.text.Arrpush Power
	gr_edit  .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Tau
	gr_edit .title.style.editstyle size(medium) editcopy
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Compulsory, Downstream	
	gr_edit .note.text = {}	
	graph save "power_`var'_comp_down.gph", replace
	graph export "power_`var'_comp_down.pdf", replace
	}

*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdpower `var' volage_diff06, plot 
	gr_edit  .yaxis1.title.text = {}
	gr_edit .yaxis1.title.text.Arrpush Power
	gr_edit  .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Tau
	gr_edit .title.style.editstyle size(medium) editcopy
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Voluntary, Upstream
	gr_edit .note.text = {}
	graph save "power_`var'_vol_up.gph", replace
	graph export "power_`var'_vol_up.pdf", replace
	}
	

*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdpower `var' volage_diff06, plot 
	gr_edit  .yaxis1.title.text = {}
	gr_edit .yaxis1.title.text.Arrpush Power
	gr_edit  .xaxis1.title.text = {}
	gr_edit .xaxis1.title.text.Arrpush Tau
	gr_edit .title.style.editstyle size(medium) editcopy
	gr_edit .title.text = {}
	gr_edit .title.text.Arrpush Voluntary, Downstream
	gr_edit .note.text = {}
	graph save "power_`var'_vol_down.gph", replace
	graph export "power_`var'_vol_down.pdf", replace
	}	
	
graph combine power_NETinterest_natpol_comp_up.gph power_NETinterest_natpol_comp_down.gph power_NETinterest_natpol_vol_up.gph power_NETinterest_natpol_vol_down.gph
gr_edit  .plotregion1.graph2.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph4.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph1.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph3.yaxis1.title.DragBy 0 -2.80621014304658
	
graph save "power_NETinterest_natpol_all.gph"	
graph export "power_NETinterest_natpol_all.pdf"
	
graph combine power_perceive_d_pca_comp_up.gph power_perceive_d_pca_comp_down.gph power_perceive_d_pca_vol_up.gph power_perceive_d_pca_vol_down.gph
gr_edit  .plotregion1.graph2.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph4.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph1.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph3.yaxis1.title.DragBy 0 -2.80621014304658

graph save "power_perceive_d_pca_all.gph"	
graph export "power_perceive_d_pca_all.pdf"

graph combine power_suffered_d_pca_comp_up.gph power_suffered_d_pca_comp_down.gph power_suffered_d_pca_vol_up.gph power_suffered_d_pca_vol_down.gph
gr_edit  .plotregion1.graph2.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph4.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph1.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph3.yaxis1.title.DragBy 0 -2.80621014304658

graph save "power_suffered_d_pca_all.gph"	
graph export "power_suffered_d_pca_all.pdf"

graph combine power_tolerance_pca_comp_up.gph power_tolerance_pca_comp_down.gph power_tolerance_pca_vol_up.gph power_tolerance_pca_vol_down.gph
gr_edit  .plotregion1.graph2.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph4.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph1.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph3.yaxis1.title.DragBy 0 -2.80621014304658

graph save "power_tolerance_pca_all.gph"	
graph export "power_tolerance_pca_all.pdf"

graph combine power_r_zscore_essay5_comp_up.gph power_r_zscore_essay5_comp_down.gph power_r_zscore_essay5_vol_up.gph power_r_zscore_essay5_vol_down.gph
gr_edit  .plotregion1.graph2.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph4.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph1.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph3.yaxis1.title.DragBy 0 -2.80621014304658

graph save "power_r_zscore_essay5_all.gph"	
graph export "power_r_zscore_essay5_all.pdf"

graph combine power_zsstudies_tot_comp_up.gph power_zsstudies_tot_comp_down.gph power_zsstudies_tot_vol_up.gph power_zsstudies_tot_vol_down.gph
gr_edit  .plotregion1.graph2.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph4.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph1.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph3.yaxis1.title.DragBy 0 -2.80621014304658

graph save "power_zsstudies_tot_all.gph"	
graph export "power_zsstudies_tot_all.pdf"

graph combine power_membership_pca_comp_up.gph power_membership_pca_comp_down.gph power_membership_pca_vol_up.gph power_membership_pca_vol_down.gph
gr_edit  .plotregion1.graph2.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph4.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph1.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph3.yaxis1.title.DragBy 0 -2.80621014304658

graph save "power_membership_pca_all.gph"	
graph export "power_membership_pca_all.pdf"

graph combine power_member_any_comp_up.gph power_member_any_comp_down.gph power_member_any_vol_up.gph power_member_any_vol_down.gph
gr_edit  .plotregion1.graph2.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph4.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph1.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph3.yaxis1.title.DragBy 0 -2.80621014304658

graph save "power_member_any_all.gph"	
graph export "power_member_any_all.pdf"

graph combine power_member_mean_comp_up.gph power_member_mean_comp_down.gph power_member_mean_vol_up.gph power_member_mean_vol_down.gph
gr_edit  .plotregion1.graph2.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph4.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph1.yaxis1.title.DragBy 0 -2.80621014304658
gr_edit  .plotregion1.graph3.yaxis1.title.DragBy 0 -2.80621014304658

graph save "power_member_mean_all.gph"	
graph export "power_member_mean_all.pdf"	
	
*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** Effect Sizes *********************************************
*****************************************************************************************
*****************************************************************************************
	
// political interest

*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006	
	
	
foreach var in NETinterest_natpol {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in NETinterest_natpol {	
 rdrobust s_`var' compage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in NETinterest_natpol {	
	scalar list r_`var'
	}
	
*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007	
	
	
foreach var in NETinterest_natpol {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in NETinterest_natpol {	
 rdrobust s_`var' compage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in NETinterest_natpol {	
	scalar list r_`var'
	}
	
	
*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006	
	
	
foreach var in NETinterest_natpol {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in NETinterest_natpol {	
 rdrobust s_`var' volage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in NETinterest_natpol {	
	scalar list r_`var'
	}
	
*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007	
	
	
foreach var in NETinterest_natpol {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in NETinterest_natpol {	
 rdrobust s_`var' volage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in NETinterest_natpol {	
	scalar list r_`var'
	}		
	
// social awareness
	
*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006	
	
	
foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 {	
 rdrobust s_`var' compage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 {	
	scalar list r_`var'
	}
	
*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007	
	
	
foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 {	
 rdrobust s_`var' compage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 {	
	scalar list r_`var'
	}
	
	
*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006	
	
	
foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 {	
 rdrobust s_`var' volage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 {	
	scalar list r_`var'
	}
	
*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007	
	
	
foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 {	
 rdrobust s_`var' volage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 {	
	scalar list r_`var'
	}		

// political knowledge
	
*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006	
	
	
foreach var in zsstudies_tot {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in zsstudies_tot {	
 rdrobust s_`var' compage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in zsstudies_tot {	
	scalar list r_`var'
	}
	
*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007	
	
	
foreach var in zsstudies_tot {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in zsstudies_tot {	
 rdrobust s_`var' compage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in zsstudies_tot {	
	scalar list r_`var'
	}
	
	
*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006	
	
	
foreach var in zsstudies_tot {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in zsstudies_tot {	
 rdrobust s_`var' volage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in zsstudies_tot {	
	scalar list r_`var'
	}
	
*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007	
	
	
foreach var in zsstudies_tot {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in zsstudies_tot {	
 rdrobust s_`var' volage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in zsstudies_tot {	
	scalar list r_`var'
	}	
	
// memberships
	
*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006	
	
	
foreach var in membership_pca	member_any	member_mean {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in membership_pca	member_any	member_mean {	
 rdrobust s_`var' compage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in membership_pca	member_any	member_mean {	
	scalar list r_`var'
	}
	
*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007	
	
	
foreach var in membership_pca	member_any	member_mean {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in membership_pca	member_any	member_mean {	
 rdrobust s_`var' compage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in membership_pca	member_any	member_mean {	
	scalar list r_`var'
	}
	
	
*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006	
	
	
foreach var in membership_pca	member_any	member_mean {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in membership_pca	member_any	member_mean {	
 rdrobust s_`var' volage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in membership_pca	member_any	member_mean {	
	scalar list r_`var'
	}
	
*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007	
	
	
foreach var in membership_pca	member_any	member_mean {	
egen s_`var' = std(`var'), mean(0) std(1)
}	
	
foreach var in membership_pca	member_any	member_mean {	
 rdrobust s_`var' volage_diff06, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'=b[1,3]
	}
	
foreach var in membership_pca	member_any	member_mean {	
	scalar list r_`var'
	}	
	
*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** Effect GRAPHS--quartic ***********************************
*****************************************************************************************
*****************************************************************************************

cd "" // insert file pathway here

*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006

sum NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean 

rdplot NETinterest_natpol compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0.0 1 0.1 , tickset(major) ruletype(range) 
gr_edit .title.draw_view.setstyle, style(no)
gr_edit  .xaxis1.plotregion.declare_xyline .gridline_g.new 0, ordinate(x) plotregion(`.xaxis1.plotregion.objkey') style(default)
gr_edit  .xaxis1.plotregion._xylines_new = 1
gr_edit  .xaxis1.plotregion._xylines_rec = 2
gr_edit  .plotregion1._xylines[2].style.editstyle linestyle(color(cranberry)) editcopy
gr_edit  .plotregion1._xylines[2].style.editstyle linestyle(pattern(dash)) editcopy

graph save "up_compul_NETinterest_natpol.gph", replace
graph export "up_compul_NETinterest_natpol.pdf", replace

rdplot perceive_d_pca compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "up_compul_perceive_d_pca.gph", replace
graph export "up_compul_perceive_d_pca.pdf", replace

rdplot suffered_d_pca compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "up_compul_suffered_d_pca.gph", replace
graph export "up_compul_suffered_d_pca.pdf", replace

rdplot tolerance_pca compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_compul_tolerance_pca.gph", replace
graph export "up_compul_tolerance_pca.pdf", replace

rdplot r_zscore_essay5 compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_compul_r_zscore_essay5.gph", replace
graph export "up_compul_r_zscore_essay5.pdf", replace

rdplot zsstudies_tot compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "up_compul_zsstudies_tot.gph", replace
graph export "up_compul_zsstudies_tot.pdf", replace

rdplot membership_pca compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_compul_membership_pca.gph", replace
graph export "up_compul_membership_pca.pdf", replace

rdplot member_any compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.8 0.1 , tickset(major) ruletype(range) 

graph save "up_compul_member_any.gph", replace
graph export "up_compul_member_any.pdf", replace

rdplot member_mean compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.5 0.1 , tickset(major) ruletype(range) 

graph save "up_compul_member_mean.gph", replace
graph export "up_compul_member_mean.pdf", replace


*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007


sum NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean 

rdplot NETinterest_natpol compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0.0 1 0.1 , tickset(major) ruletype(range) 

graph save "down_compul_NETinterest_natpol.gph", replace
graph export "down_compul_NETinterest_natpol.pdf", replace

rdplot perceive_d_pca compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_compul_perceive_d_pca.gph", replace
graph export "down_compul_perceive_d_pca.pdf", replace

rdplot suffered_d_pca compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "down_compul_suffered_d_pca.gph", replace
graph export "down_compul_suffered_d_pca.pdf", replace

rdplot tolerance_pca compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_compul_tolerance_pca.gph", replace
graph export "down_compul_tolerance_pca.pdf", replace

rdplot r_zscore_essay5 compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_compul_r_zscore_essay5.gph", replace
graph export "down_compul_r_zscore_essay5.pdf", replace

rdplot zsstudies_tot compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_compul_zsstudies_tot.gph", replace
graph export "down_compul_zsstudies_tot.pdf", replace

rdplot membership_pca compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_compul_membership_pca.gph", replace
graph export "down_compul_membership_pca.pdf", replace

rdplot member_any compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.8 0.1 , tickset(major) ruletype(range) 

graph save "down_compul_member_any.gph", replace
graph export "down_compul_member_any.pdf", replace

rdplot member_mean compage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.5 0.1 , tickset(major) ruletype(range) 

graph save "down_compul_member_mean.gph", replace
graph export "down_compul_member_mean.pdf", replace


*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006

sum NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean 

rdplot NETinterest_natpol volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0.0 1 0.1 , tickset(major) ruletype(range) 

graph save "up_vol_NETinterest_natpol.gph", replace
graph export "up_vol_NETinterest_natpol.pdf", replace

rdplot perceive_d_pca volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_vol_perceive_d_pca.gph", replace
graph export "up_vol_perceive_d_pca.pdf", replace

rdplot suffered_d_pca volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_vol_suffered_d_pca.gph", replace
graph export "up_vol_suffered_d_pca.pdf", replace

rdplot tolerance_pca volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_vol_tolerance_pca.gph", replace
graph export "up_vol_tolerance_pca.pdf", replace

rdplot r_zscore_essay5 volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "up_vol_r_zscore_essay5.gph", replace
graph export "up_vol_r_zscore_essay5.pdf", replace

rdplot zsstudies_tot volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_vol_zsstudies_tot.gph", replace
graph export "up_vol_zsstudies_tot.pdf", replace

rdplot membership_pca volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "up_vol_membership_pca.gph", replace
graph export "up_vol_membership_pca.pdf", replace

rdplot member_any volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.8 0.1 , tickset(major) ruletype(range) 

graph save "up_vol_member_any.gph", replace
graph export "up_vol_member_any.pdf", replace

rdplot member_mean volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.5 0.1 , tickset(major) ruletype(range) 

graph save "up_vol_member_mean.gph", replace
graph export "up_vol_member_mean.pdf", replace



*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007


sum NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean 

rdplot NETinterest_natpol volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0.0 1 0.1 , tickset(major) ruletype(range) 

graph save "down_vol_NETinterest_natpol.gph", replace
graph export "down_vol_NETinterest_natpol.pdf", replace

rdplot perceive_d_pca volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_vol_perceive_d_pca.gph", replace
graph export "down_vol_perceive_d_pca.pdf", replace

rdplot suffered_d_pca volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "down_vol_suffered_d_pca.gph", replace
graph export "down_vol_suffered_d_pca.pdf", replace

rdplot tolerance_pca volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_vol_tolerance_pca.gph", replace
graph export "down_vol_tolerance_pca.pdf", replace

rdplot r_zscore_essay5 volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_vol_r_zscore_essay5.gph", replace
graph export "down_vol_r_zscore_essay5.pdf", replace

rdplot zsstudies_tot volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "down_vol_zsstudies_tot.gph", replace
graph export "down_vol_zsstudies_tot.pdf", replace

rdplot membership_pca volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_vol_membership_pca.gph", replace
graph export "down_vol_membership_pca.pdf", replace

rdplot member_any volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.8 0.1 , tickset(major) ruletype(range) 

graph save "down_vol_member_any.gph", replace
graph export "down_vol_member_any.pdf", replace

rdplot member_mean volage_diff06 , ci(95)  graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.5 0.1 , tickset(major) ruletype(range) 

graph save "down_vol_member_mean.gph", replace
graph export "down_vol_member_mean.pdf", replace



*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** Effect GRAPHS-- Linear ***********************************
*****************************************************************************************
*****************************************************************************************

cd "" // insert file pathway here

*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006

sum NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean 

rdplot NETinterest_natpol compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0.0 1 0.1 , tickset(major) ruletype(range) 

graph save "up_compul_NETinterest_natpol_linear.gph", replace
graph export "up_compul_NETinterest_natpol_linear.pdf", replace

rdplot perceive_d_pca compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "up_compul_perceive_d_pca_linear.gph", replace
graph export "up_compul_perceive_d_pca_linear.pdf", replace

rdplot suffered_d_pca compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "up_compul_suffered_d_pca_linear.gph", replace
graph export "up_compul_suffered_d_pca_linear.pdf", replace

rdplot tolerance_pca compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_compul_tolerance_pca_linear.gph", replace
graph export "up_compul_tolerance_pca_linear.pdf", replace

rdplot r_zscore_essay5 compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_compul_r_zscore_essay5_linear.gph", replace
graph export "up_compul_r_zscore_essay5_linear.pdf", replace

rdplot zsstudies_tot compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "up_compul_zsstudies_tot_linear.gph", replace
graph export "up_compul_zsstudies_tot_linear.pdf", replace

rdplot membership_pca compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_compul_membership_pca_linear.gph", replace
graph export "up_compul_membership_pca_linear.pdf", replace

rdplot member_any compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.8 0.1 , tickset(major) ruletype(range) 

graph save "up_compul_member_any_linear.gph", replace
graph export "up_compul_member_any_linear.pdf", replace

rdplot member_mean compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.5 0.1 , tickset(major) ruletype(range) 

graph save "up_compul_member_mean_linear.gph", replace
graph export "up_compul_member_mean_linear.pdf", replace


*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007


sum NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean 

rdplot NETinterest_natpol compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0.0 1 0.1 , tickset(major) ruletype(range) 

graph save "down_compul_NETinterest_natpol_linear.gph", replace
graph export "down_compul_NETinterest_natpol_linear.pdf", replace

rdplot perceive_d_pca compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_compul_perceive_d_pca_linear.gph", replace
graph export "down_compul_perceive_d_pca_linear.pdf", replace

rdplot suffered_d_pca compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "down_compul_suffered_d_pca_linear.gph", replace
graph export "down_compul_suffered_d_pca_linear.pdf", replace

rdplot tolerance_pca compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_compul_tolerance_pca_linear.gph", replace
graph export "down_compul_tolerance_pca_linear.pdf", replace

rdplot r_zscore_essay5 compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_compul_r_zscore_essay5_linear.gph", replace
graph export "down_compul_r_zscore_essay5_linear.pdf", replace

rdplot zsstudies_tot compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_compul_zsstudies_tot_linear.gph", replace
graph export "down_compul_zsstudies_tot_linear.pdf", replace

rdplot membership_pca compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_compul_membership_pca_linear.gph", replace
graph export "down_compul_membership_pca_linear.pdf", replace

rdplot member_any compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.8 0.1 , tickset(major) ruletype(range) 

graph save "down_compul_member_any_linear.gph", replace
graph export "down_compul_member_any_linear.pdf", replace

rdplot member_mean compage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.5 0.1 , tickset(major) ruletype(range) 

graph save "down_compul_member_mean_linear.gph", replace
graph export "down_compul_member_mean_linear.pdf", replace


*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006

sum NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean 

rdplot NETinterest_natpol volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0.0 1 0.1 , tickset(major) ruletype(range) 

graph save "up_vol_NETinterest_natpol_linear.gph", replace
graph export "up_vol_NETinterest_natpol_linear.pdf", replace

rdplot perceive_d_pca volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_vol_perceive_d_pca_linear.gph", replace
graph export "up_vol_perceive_d_pca_linear.pdf", replace

rdplot suffered_d_pca volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_vol_suffered_d_pca_linear.gph", replace
graph export "up_vol_suffered_d_pca_linear.pdf", replace

rdplot tolerance_pca volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_vol_tolerance_pca_linear.gph", replace
graph export "up_vol_tolerance_pca_linear.pdf", replace

rdplot r_zscore_essay5 volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "up_vol_r_zscore_essay5_linear.gph", replace
graph export "up_vol_r_zscore_essay5_linear.pdf", replace

rdplot zsstudies_tot volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "up_vol_zsstudies_tot_linear.gph", replace
graph export "up_vol_zsstudies_tot_linear.pdf", replace

rdplot membership_pca volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "up_vol_membership_pca_linear.gph", replace
graph export "up_vol_membership_pca_linear.pdf", replace

rdplot member_any volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.8 0.1 , tickset(major) ruletype(range) 

graph save "up_vol_member_any_linear.gph", replace
graph export "up_vol_member_any_linear.pdf", replace

rdplot member_mean volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.5 0.1 , tickset(major) ruletype(range) 

graph save "up_vol_member_mean_linear.gph", replace
graph export "up_vol_member_mean_linear.pdf", replace



*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007


sum NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean 

rdplot NETinterest_natpol volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0.0 1 0.1 , tickset(major) ruletype(range) 

graph save "down_vol_NETinterest_natpol_linear.gph", replace
graph export "down_vol_NETinterest_natpol_linear.pdf", replace

rdplot perceive_d_pca volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_vol_perceive_d_pca_linear.gph", replace
graph export "down_vol_perceive_d_pca_linear.pdf", replace

rdplot suffered_d_pca volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "down_vol_suffered_d_pca_linear.gph", replace
graph export "down_vol_suffered_d_pca_linear.pdf", replace

rdplot tolerance_pca volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_vol_tolerance_pca_linear.gph", replace
graph export "down_vol_tolerance_pca_linear.pdf", replace

rdplot r_zscore_essay5 volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_vol_r_zscore_essay5_linear.gph", replace
graph export "down_vol_r_zscore_essay5_linear.pdf", replace

rdplot zsstudies_tot volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 
 
graph save "down_vol_zsstudies_tot_linear.gph", replace
graph export "down_vol_zsstudies_tot_linear.pdf", replace

rdplot membership_pca volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule -1.5 1.5 0.5, tickset(major) ruletype(range) 

graph save "down_vol_membership_pca_linear.gph", replace
graph export "down_vol_membership_pca_linear.pdf", replace

rdplot member_any volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.8 0.1 , tickset(major) ruletype(range) 

graph save "down_vol_member_any_linear.gph", replace
graph export "down_vol_member_any_linear.pdf", replace

rdplot member_mean volage_diff06 , ci(95) p(1) q(2) graph_options(xtitle("Running Variable (Days DOB From Cutoff)") ytitle("") title("") xline(0, lcol("red") lpat("dash") ))
gr_edit .plotregion1.style.editstyle boxstyle(linestyle(color(none))) editcopy
gr_edit .legend.draw_view.setstyle, style(no)
gr_edit .plotregion1.plot2.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(fillcolor(gs9)) editcopy
gr_edit .plotregion1.plot2.style.editstyle marker(linestyle(color(gs9))) editcopy
gr_edit .plotregion1.plot1.style.editstyle area(linestyle(color(gs9))) editcopy
gr_edit .plotregion1._xylines[1].Delete
gr_edit .plotregion1.plot3.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot3.style.editstyle line(width(thick)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(color(blue)) editcopy
gr_edit .plotregion1.plot4.style.editstyle line(width(thick)) editcopy
gr_edit .yaxis1.reset_rule 0 0.5 0.1 , tickset(major) ruletype(range) 

graph save "down_vol_member_mean_linear.gph", replace
graph export "down_vol_member_mean_linear.pdf", replace







*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
**************************** COEFFICIENT PLOTS p(1) q(2) not standardized-for base rate**
*****************************************************************************************
*****************************************************************************************

cd "" // insert file pathway here

use "final_jop_data_brazil.dta", clear

 gen compulsory_up=1 if year==2006 &  abs(compage_diff06)<=120
 gen compulsory_down=1 if year==2007 &  abs(compage_diff06)<=120
 gen voluntary_up=1 if year==2006 &  abs(volage_diff06)<=120
 gen voluntary_down=1 if year==2007 &  abs(volage_diff06)<=120

 replace compulsory_up=0 if compulsory_down==1 | voluntary_up==1 | voluntary_down==1
 replace compulsory_down=0 if compulsory_up==1 | voluntary_up==1 | voluntary_down==1
 replace voluntary_up=0 if compulsory_up==1 | compulsory_down==1 | voluntary_down==1
 replace voluntary_down=0 if compulsory_up==1 | compulsory_down==1 | voluntary_up==1
  
 gen composite_running=compage_diff06 if compulsory_up==1
 replace composite_running=compage_diff06 if compulsory_down==1
 replace composite_running=volage_diff06 if voluntary_up==1
 replace composite_running=volage_diff06 if voluntary_down==1

  foreach var in NETinterest_natpol ///
  perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 ///	
 membership_pca	member_any	member_mean {	
egen s_`var' = std(`var'), mean(0) std(1)
}


 log using "Coefplot Estimates Not Standardized.smcl", replace
 
 **** Political Interest 
rdrobust NETinterest_natpol composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_no_standardize_plot_interest.dta", detail(all) ci pval level(95) replace addlabel(outcome, NETinterest_natpol, cutoff, compulsory_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum NETinterest_natpol if composite_running<0 & composite_running>=-e(h_l)
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, replace
	putexcel A1=matrix(base_rate)  

rdrobust NETinterest_natpol composite_running if compulsory_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, compulsory_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum NETinterest_natpol if composite_running<0 & composite_running>=-e(h_l) & compulsory_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A2=matrix(base_rate)  
	clear matrix

rdrobust NETinterest_natpol composite_running if voluntary_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, voluntary_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum NETinterest_natpol if composite_running<0 & composite_running>=-e(h_l) & voluntary_up==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A3=matrix(base_rate)  
	clear matrix
	
rdrobust NETinterest_natpol composite_running if voluntary_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, voluntary_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum NETinterest_natpol if composite_running<0 & composite_running>=-e(h_l) & voluntary_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A4=matrix(base_rate)  
	clear matrix	

rdrobust NETinterest_natpol composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_no_standardize_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum NETinterest_natpol if composite_running<0 & composite_running>=-e(h_l) 
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A5=matrix(base_rate)  
	clear matrix	
	

 

***** Social Awareness

*Perceived Discrimination
rdrobust perceive_d_pca composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_no_standardize_perceive_discrim.dta", detail(all) ci pval level(95) replace addlabel(outcome, perceive_d_pca, cutoff, compulsory_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum perceive_d_pca if composite_running<0 & composite_running>=-e(h_l)
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A6=matrix(base_rate)  

rdrobust perceive_d_pca composite_running if compulsory_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, compulsory_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum perceive_d_pca if composite_running<0 & composite_running>=-e(h_l) & compulsory_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A7=matrix(base_rate)  
	clear matrix

rdrobust perceive_d_pca composite_running if voluntary_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, voluntary_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum perceive_d_pca if composite_running<0 & composite_running>=-e(h_l) & voluntary_up==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A8=matrix(base_rate)  
	clear matrix
	
rdrobust perceive_d_pca composite_running if voluntary_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, voluntary_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum perceive_d_pca if composite_running<0 & composite_running>=-e(h_l) & voluntary_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A9=matrix(base_rate)  
	clear matrix	

rdrobust perceive_d_pca composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_no_standardize_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, pooled)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum perceive_d_pca if composite_running<0 & composite_running>=-e(h_l) 
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A10=matrix(base_rate)  
	clear matrix	
	
	
	
*Suffer Discrimination
rdrobust suffered_d_pca composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_no_standardize_suffer_discrim.dta", detail(all) ci pval level(95) replace addlabel(outcome, suffered_d_pca, cutoff, compulsory_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum suffered_d_pca if composite_running<0 & composite_running>=-e(h_l)
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A11=matrix(base_rate)  

rdrobust suffered_d_pca composite_running if compulsory_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, compulsory_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum suffered_d_pca if composite_running<0 & composite_running>=-e(h_l) & compulsory_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A12=matrix(base_rate)  
	clear matrix

rdrobust suffered_d_pca composite_running if voluntary_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, voluntary_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum suffered_d_pca if composite_running<0 & composite_running>=-e(h_l) & voluntary_up==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A13=matrix(base_rate)  
	clear matrix
	
rdrobust suffered_d_pca composite_running if voluntary_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, voluntary_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum suffered_d_pca if composite_running<0 & composite_running>=-e(h_l) & voluntary_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A14=matrix(base_rate)  
	clear matrix	

rdrobust suffered_d_pca composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_no_standardize_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, pooled)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum suffered_d_pca if composite_running<0 & composite_running>=-e(h_l) 
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A15=matrix(base_rate)  
	clear matrix	

	
	

		
*Tolerance
rdrobust tolerance_pca composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_no_standardize_tolerance.dta", detail(all) ci pval level(95) replace addlabel(outcome, tolerance_pca, cutoff, compulsory_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum tolerance_pca if composite_running<0 & composite_running>=-e(h_l)
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A16=matrix(base_rate)  

rdrobust tolerance_pca composite_running if compulsory_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, compulsory_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum tolerance_pca if composite_running<0 & composite_running>=-e(h_l) & compulsory_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A17=matrix(base_rate)  
	clear matrix

rdrobust tolerance_pca composite_running if voluntary_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, voluntary_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum tolerance_pca if composite_running<0 & composite_running>=-e(h_l) & voluntary_up==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A18=matrix(base_rate)  
	clear matrix
	
rdrobust tolerance_pca composite_running if voluntary_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, voluntary_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum tolerance_pca if composite_running<0 & composite_running>=-e(h_l) & voluntary_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A19=matrix(base_rate)  
	clear matrix	

rdrobust tolerance_pca composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_no_standardize_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, pooled)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum tolerance_pca if composite_running<0 & composite_running>=-e(h_l) 
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A20=matrix(base_rate)  
	clear matrix	


* Social Awareness Essay
rdrobust r_zscore_essay5 composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_no_standardize_social_aware.dta", detail(all) ci pval level(95) replace addlabel(outcome, r_zscore_essay5, cutoff, compulsory_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum r_zscore_essay5 if composite_running<0 & composite_running>=-e(h_l)
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A21=matrix(base_rate)  

rdrobust r_zscore_essay5 composite_running if compulsory_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_social_aware.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, compulsory_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum r_zscore_essay5 if composite_running<0 & composite_running>=-e(h_l) & compulsory_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A22=matrix(base_rate)  
	clear matrix

rdrobust r_zscore_essay5 composite_running if voluntary_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_social_aware.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, voluntary_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum r_zscore_essay5 if composite_running<0 & composite_running>=-e(h_l) & voluntary_up==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A23=matrix(base_rate)  
	clear matrix
	
rdrobust r_zscore_essay5 composite_running if voluntary_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_social_aware.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, voluntary_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum r_zscore_essay5 if composite_running<0 & composite_running>=-e(h_l) & voluntary_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A24=matrix(base_rate)  
	clear matrix	

rdrobust r_zscore_essay5 composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_no_standardize_social_aware.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, pooled)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum r_zscore_essay5 if composite_running<0 & composite_running>=-e(h_l) 
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A25=matrix(base_rate)  
	clear matrix	
	
***** Political Knowledge
rdrobust zsstudies_tot composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_no_standardize_knowledge.dta", detail(all) ci pval level(95) replace addlabel(outcome, zsstudies_tot, cutoff, compulsory_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum zsstudies_tot if composite_running<0 & composite_running>=-e(h_l)
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A26=matrix(base_rate)  

rdrobust zsstudies_tot composite_running if compulsory_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, compulsory_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum zsstudies_tot if composite_running<0 & composite_running>=-e(h_l) & compulsory_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A27=matrix(base_rate)  
	clear matrix

rdrobust zsstudies_tot composite_running if voluntary_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, voluntary_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum zsstudies_tot if composite_running<0 & composite_running>=-e(h_l) & voluntary_up==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A28=matrix(base_rate)  
	clear matrix
	
rdrobust zsstudies_tot composite_running if voluntary_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, voluntary_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum zsstudies_tot if composite_running<0 & composite_running>=-e(h_l) & voluntary_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A29=matrix(base_rate)  
	clear matrix	

rdrobust zsstudies_tot composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_no_standardize_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, pooled)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum zsstudies_tot if composite_running<0 & composite_running>=-e(h_l) 
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A30=matrix(base_rate)  
	clear matrix	
	
	
  
***** Memberships

*Factor
rdrobust membership_pca composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_no_standardize_membership_pca.dta", detail(all) ci pval level(95) replace addlabel(outcome, membership_pca, cutoff, compulsory_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum membership_pca if composite_running<0 & composite_running>=-e(h_l)
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A31=matrix(base_rate)  

rdrobust membership_pca composite_running if compulsory_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, compulsory_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum membership_pca if composite_running<0 & composite_running>=-e(h_l) & compulsory_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A32=matrix(base_rate)  
	clear matrix

rdrobust membership_pca composite_running if voluntary_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, voluntary_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum membership_pca if composite_running<0 & composite_running>=-e(h_l) & voluntary_up==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A33=matrix(base_rate)  
	clear matrix
	
rdrobust membership_pca composite_running if voluntary_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, voluntary_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum membership_pca if composite_running<0 & composite_running>=-e(h_l) & voluntary_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A34=matrix(base_rate)  
	clear matrix	

rdrobust membership_pca composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_no_standardize_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, pooled)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum membership_pca if composite_running<0 & composite_running>=-e(h_l) 
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A35=matrix(base_rate)  
	clear matrix	

	
		
*Any
rdrobust member_any composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_no_standardize_member_any.dta", detail(all) ci pval level(95) replace addlabel(outcome, member_any, cutoff, compulsory_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum member_any if composite_running<0 & composite_running>=-e(h_l)
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A36=matrix(base_rate)  

rdrobust member_any composite_running if compulsory_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, compulsory_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum member_any if composite_running<0 & composite_running>=-e(h_l) & compulsory_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A37=matrix(base_rate)  
	clear matrix

rdrobust member_any composite_running if voluntary_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, voluntary_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum member_any if composite_running<0 & composite_running>=-e(h_l) & voluntary_up==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A38=matrix(base_rate)  
	clear matrix
	
rdrobust member_any composite_running if voluntary_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, voluntary_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum member_any if composite_running<0 & composite_running>=-e(h_l) & voluntary_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A39=matrix(base_rate)  
	clear matrix	

rdrobust member_any composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_no_standardize_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, pooled)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum member_any if composite_running<0 & composite_running>=-e(h_l) 
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A40=matrix(base_rate)  
	clear matrix		
	
*Mean
rdrobust member_mean composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_no_standardize_member_mean.dta", detail(all) ci pval level(95) replace addlabel(outcome, member_mean, cutoff, compulsory_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum member_mean if composite_running<0 & composite_running>=-e(h_l)
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A41=matrix(base_rate)  

rdrobust member_mean composite_running if compulsory_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, compulsory_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum member_mean if composite_running<0 & composite_running>=-e(h_l) & compulsory_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A42=matrix(base_rate)  
	clear matrix

rdrobust member_mean composite_running if voluntary_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, voluntary_up)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum member_mean if composite_running<0 & composite_running>=-e(h_l) & voluntary_up==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A43=matrix(base_rate)  
	clear matrix
	
rdrobust member_mean composite_running if voluntary_down==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_no_standardize_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, voluntary_down)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum member_mean if composite_running<0 & composite_running>=-e(h_l) & voluntary_down==1
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A44=matrix(base_rate)  
	clear matrix	

rdrobust member_mean composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_no_standardize_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, pooled)
  	mat b =e(b)
	scalar robust=b[1,3]
  sum member_mean if composite_running<0 & composite_running>=-e(h_l) 
	scalar base_rate=robust/  r(mean) 
	scalar list base_rate
	matrix base_rate=scalar(base_rate)
	putexcel set base_rate_123, modify
	putexcel A45=matrix(base_rate)  
	clear matrix	
	
log close	

*Go and manually enter numbers 1-45 from top to bottom in the spreadsheet, add variable names	
import excel "base_rate_123.xlsx", sheet("Sheet1") firstrow clear	
save "base_rate_123.dta", replace	
	
use "coef_no_standardize_plot_interest.dta", clear
append using  "coef_no_standardize_perceive_discrim.dta"
append using  "coef_no_standardize_suffer_discrim.dta"
append using  "coef_no_standardize_tolerance.dta"
append using  "coef_no_standardize_social_aware.dta"
append using  "coef_no_standardize_knowledge.dta"
append using  "coef_no_standardize_membership_pca.dta"
append using  "coef_no_standardize_member_any.dta"
append using  "coef_no_standardize_member_mean.dta"


generate var46 = 1 in 5
replace var46 = 2 in 4
replace var46 = 3 in 3
replace var46 = 4 in 2
replace var46 = 5 in 1

replace var46 = 6 in 10
replace var46 = 7 in 9
replace var46 = 8 in 8
replace var46 = 9 in 7
replace var46 = 10 in 6

replace var46 = 11 in 15
replace var46 = 12 in 14
replace var46 = 13 in 13
replace var46 = 14 in 12
replace var46 = 15 in 11

replace var46 = 16 in 20
replace var46 = 17 in 19
replace var46 = 18 in 18
replace var46 = 19 in 17
replace var46 = 20 in 16

replace var46 = 21 in 25
replace var46 = 22 in 24
replace var46 = 23 in 23
replace var46 = 24 in 22
replace var46 = 25 in 21

replace var46 = 26 in 30
replace var46 = 27 in 29
replace var46 = 28 in 28
replace var46 = 29 in 27
replace var46 = 30 in 26

replace var46 = 31 in 35
replace var46 = 32 in 34
replace var46 = 33 in 33
replace var46 = 34 in 32
replace var46 = 35 in 31

replace var46 = 36 in 40
replace var46 = 37 in 39
replace var46 = 38 in 38
replace var46 = 39 in 37
replace var46 = 40 in 36

replace var46 = 41 in 45
replace var46 = 42 in 44
replace var46 = 43 in 43
replace var46 = 44 in 42
replace var46 = 45 in 41

rename var46 match_number

merge 1:1 match_number using "base_rate_123.dta"

gen rank=5 if cutoff=="pooled"
replace rank=4 if cutoff=="voluntary_down"
replace rank=3 if cutoff=="voluntary_up"
replace rank=2 if cutoff=="compulsory_down"
replace rank=1 if cutoff=="compulsory_up"

gen pooled=0 if cutoff=="pooled"
replace pooled=1 if pooled==.

replace cutoff="Pooled" if cutoff=="pooled"
replace cutoff="Voluntary Down" if cutoff=="voluntary_down"
replace cutoff="Voluntary Up" if cutoff=="voluntary_up"
replace cutoff="Compulsory Down" if cutoff=="compulsory_down"
replace cutoff="Compulsory Up" if cutoff=="compulsory_up"

replace outcomevar="Memberships (Any)" if outcomevar=="member_any"
replace outcomevar="Memberships (Mean)" if outcomevar=="member_mean"
replace outcomevar="Memberships (PCA)" if outcomevar=="membership_pca"
replace outcomevar="   Political Interest" if outcomevar=="NETinterest_natpol"
replace outcomevar="  Perceive Discrim. (PCA)" if outcomevar=="perceive_d_pca"
replace outcomevar="  Social Awareness Essay" if outcomevar=="r_zscore_essay5"
replace outcomevar=" Political Knowledge" if outcomevar=="zsstudies_tot"
replace outcomevar="  Suffered Discrim. (PCA)" if outcomevar=="suffered_d_pca"
replace outcomevar="  Tolerance (PCA)" if outcomevar=="tolerance_pca"

 order outcomevar cutoff coef pval ci_lower ci_upper base_rate N

saveold "coef_no_standardize_plot_all_coefs.dta", replace version(12)

use "coef_no_standardize_plot_all_coefs.dta", clear

sum pval
tab pval
sum coef
tab coef

gen significant=1 if pval<=0.05
replace significant=0 if significant==.

tab significant

sktest coef
sktest pval

kdens pval , xline(0.05, lcol(red) lpat(dash))
kdens coef, xline(0, lcol(red) lpat(dash)) xlabel(-0.2(0.1)0.2)

sum coef if pooled==1, d







*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** COEFFICIENT PLOTS p(1) q(2) ******************************
*****************************************************************************************
*****************************************************************************************
cd "" // insert file pathway here

use "final_jop_data_brazil.dta", clear

 gen compulsory_up=1 if year==2006 &  abs(compage_diff06)<=120
 gen compulsory_down=1 if year==2007 &  abs(compage_diff06)<=120
 gen voluntary_up=1 if year==2006 &  abs(volage_diff06)<=120
 gen voluntary_down=1 if year==2007 &  abs(volage_diff06)<=120

 replace compulsory_up=0 if compulsory_down==1 | voluntary_up==1 | voluntary_down==1
 replace compulsory_down=0 if compulsory_up==1 | voluntary_up==1 | voluntary_down==1
 replace voluntary_up=0 if compulsory_up==1 | compulsory_down==1 | voluntary_down==1
 replace voluntary_down=0 if compulsory_up==1 | compulsory_down==1 | voluntary_up==1
  
 gen composite_running=compage_diff06 if compulsory_up==1
 replace composite_running=compage_diff06 if compulsory_down==1
 replace composite_running=volage_diff06 if voluntary_up==1
 replace composite_running=volage_diff06 if voluntary_down==1

  foreach var in NETinterest_natpol ///
  perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 ///	
  zsstudies_tot ///
 membership_pca	member_any	member_mean {	
egen s_`var' = std(`var'), mean(0) std(1)
}


 log using "Coefplot Estimates 1 2.smcl", replace
 
 **** Political Interest 

rdrobust s_NETinterest_natpol composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_plot_interest.dta", detail(all) ci pval level(95) replace addlabel(outcome, NETinterest_natpol, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_NETinterest_natpol composite_running if `var'==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, `var')
}

rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled)

*use "coef_plot_interest.dta", clear


***** Social Awareness

*Perceived Discrimination
rdrobust s_perceive_d_pca composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_perceive_discrim.dta", detail(all) ci pval level(95) replace addlabel(outcome, perceive_d_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_perceive_d_pca composite_running if `var'==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, `var')
}

rdrobust s_perceive_d_pca composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, pooled)

*use "coef_perceive_discrim.dta", clear

*Suffer Discrimination
rdrobust s_suffered_d_pca composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_suffer_discrim.dta", detail(all) ci pval level(95) replace addlabel(outcome, suffered_d_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_suffered_d_pca composite_running if `var'==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, `var')
}

rdrobust s_suffered_d_pca composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, pooled)

*use "coef_suffer_discrim.dta", clear

*Tolerance
rdrobust s_tolerance_pca composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_tolerance.dta", detail(all) ci pval level(95) replace addlabel(outcome, tolerance_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_tolerance_pca composite_running if `var'==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, `var')
}

rdrobust s_tolerance_pca composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, pooled)

*use "coef_tolerance.dta", clear

*Social Awareness-Essay
rdrobust s_r_zscore_essay5 composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_social_essay.dta", detail(all) ci pval level(95) replace addlabel(outcome, r_zscore_essay5, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_r_zscore_essay5 composite_running if `var'==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_social_essay.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, `var')
}

rdrobust s_r_zscore_essay5 composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_social_essay.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, pooled)

*use "coef_knowledge.dta", clear

***** Political Knowledge
rdrobust s_zsstudies_tot composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_knowledge.dta", detail(all) ci pval level(95) replace addlabel(outcome, zsstudies_tot, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_zsstudies_tot composite_running if `var'==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, `var')
}

rdrobust s_zsstudies_tot composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, pooled)
  
***** Memberships

*Factor
rdrobust s_membership_pca composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_membership_pca.dta", detail(all) ci pval level(95) replace addlabel(outcome, membership_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_membership_pca composite_running if `var'==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, `var')
}

rdrobust s_membership_pca composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, pooled)

*use "coef_membership_pca.dta", clear

*Any
rdrobust s_member_any composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_member_any.dta", detail(all) ci pval level(95) replace addlabel(outcome, member_any, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_member_any composite_running if `var'==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, `var')
}

rdrobust s_member_any composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, pooled)

*use "coef_member_any.dta", clear


*Mean
rdrobust s_member_mean composite_running if compulsory_up==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_member_mean.dta", detail(all) ci pval level(95) replace addlabel(outcome, member_mean, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_member_mean composite_running if `var'==1, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, `var')
}

rdrobust s_member_mean composite_running, c(0) p(1) q(2)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, pooled)

log close

*use "coef_member_mean.dta", clear


use "coef_plot_interest.dta", clear
append using  "coef_perceive_discrim.dta"
append using  "coef_suffer_discrim.dta"
append using  "coef_tolerance.dta"
append using  "coef_social_essay.dta"
append using  "coef_knowledge.dta"
append using  "coef_membership_pca.dta"
append using  "coef_member_any.dta"
append using  "coef_member_mean.dta"

gen rank=5 if cutoff=="pooled"
replace rank=4 if cutoff=="voluntary_down"
replace rank=3 if cutoff=="voluntary_up"
replace rank=2 if cutoff=="compulsory_down"
replace rank=1 if cutoff=="compulsory_up"

gen pooled=0 if cutoff=="pooled"
replace pooled=1 if pooled==.

replace cutoff="Pooled" if cutoff=="pooled"
replace cutoff="Voluntary Down" if cutoff=="voluntary_down"
replace cutoff="Voluntary Up" if cutoff=="voluntary_up"
replace cutoff="Compulsory Down" if cutoff=="compulsory_down"
replace cutoff="Compulsory Up" if cutoff=="compulsory_up"

replace outcomevar="Memberships (Any)" if outcomevar=="s_member_any"
replace outcomevar="Memberships (Mean)" if outcomevar=="s_member_mean"
replace outcomevar="Memberships (PCA)" if outcomevar=="s_membership_pca"
replace outcomevar="   Political Interest" if outcomevar=="s_NETinterest_natpol"
replace outcomevar="  Perceive Discrim. (PCA)" if outcomevar=="s_perceive_d_pca"
replace outcomevar="  Social Awareness Essay" if outcomevar=="s_r_zscore_essay5"
replace outcomevar=" Political Knowledge" if outcomevar=="s_zsstudies_tot"
replace outcomevar="  Suffered Discrim. (PCA)" if outcomevar=="s_suffered_d_pca"
replace outcomevar="  Tolerance (PCA)" if outcomevar=="s_tolerance_pca"

saveold "coef_plot_all_coefs.dta", replace version(12)

use "coef_no_standardize_plot_all_coefs.dta", clear
keep outcomevar rank base_rate
save "just_base_rates.dta", replace


use "coef_plot_all_coefs.dta", clear
merge 1:1 outcomevar rank using "just_base_rates.dta"

 order outcomevar cutoff coef pval ci_lower ci_upper base_rate N

saveold "coef_plot_all_coefs_with_base_rates.dta", replace version(12)

use "coef_plot_all_coefs_with_base_rates.dta", clear

sum pval
tab pval
sum coef
tab coef

sum coef if outcomevar=="Memberships (Any)" | outcomevar=="Memberships (Mean)" | outcomevar=="Memberships (PCA)"



gen significant=1 if pval<=0.05
replace significant=0 if significant==.

tab significant

sktest coef
sktest pval

kdens pval , xline(0.05, lcol(red) lpat(dash))
kdens coef, xline(0, lcol(red) lpat(dash)) xlabel(-0.2(0.1)0.2)

sum coef if pooled==1, d




*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** COEFFICIENT PLOTS p(1) q(2)--No Cluster SE ***************
*****************************************************************************************
*****************************************************************************************
cd "" // insert file pathway here

use "final_jop_data_brazil.dta", clear

 gen compulsory_up=1 if year==2006 &  abs(compage_diff06)<=120
 gen compulsory_down=1 if year==2007 &  abs(compage_diff06)<=120
 gen voluntary_up=1 if year==2006 &  abs(volage_diff06)<=120
 gen voluntary_down=1 if year==2007 &  abs(volage_diff06)<=120

 replace compulsory_up=0 if compulsory_down==1 | voluntary_up==1 | voluntary_down==1
 replace compulsory_down=0 if compulsory_up==1 | voluntary_up==1 | voluntary_down==1
 replace voluntary_up=0 if compulsory_up==1 | compulsory_down==1 | voluntary_down==1
 replace voluntary_down=0 if compulsory_up==1 | compulsory_down==1 | voluntary_up==1
  
 gen composite_running=compage_diff06 if compulsory_up==1
 replace composite_running=compage_diff06 if compulsory_down==1
 replace composite_running=volage_diff06 if voluntary_up==1
 replace composite_running=volage_diff06 if voluntary_down==1

  foreach var in NETinterest_natpol ///
  perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 ///	
  zsstudies_tot ///
 membership_pca	member_any	member_mean {	
egen s_`var' = std(`var'), mean(0) std(1)
}


 log using "Coefplot Estimates 1 2 No Cluster.smcl", replace
 
 **** Political Interest 

rdrobust s_NETinterest_natpol composite_running if compulsory_up==1, c(0) p(1) q(2)    kernel(triangular) all 
 regsave Robust  using "coef_nocluster_plot_interest.dta", detail(all) ci pval level(95) replace addlabel(outcome, NETinterest_natpol, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_NETinterest_natpol composite_running if `var'==1, c(0) p(1) q(2)    kernel(triangular) all 
regsave Robust  using "coef_nocluster_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, `var')
}

rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2)    kernel(triangular) all  
regsave Robust  using "coef_nocluster_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled)

*use "coef_nocluster_plot_interest.dta", clear


***** Social Awareness

*Perceived Discrimination
rdrobust s_perceive_d_pca composite_running if compulsory_up==1, c(0) p(1) q(2)    kernel(triangular) all 
 regsave Robust  using "coef_nocluster_perceive_discrim.dta", detail(all) ci pval level(95) replace addlabel(outcome, perceive_d_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_perceive_d_pca composite_running if `var'==1, c(0) p(1) q(2)    kernel(triangular) all 
regsave Robust  using "coef_nocluster_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, `var')
}

rdrobust s_perceive_d_pca composite_running, c(0) p(1) q(2)    kernel(triangular) all  
regsave Robust  using "coef_nocluster_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, pooled)

*use "coef_nocluster_perceive_discrim.dta", clear

*Suffer Discrimination
rdrobust s_suffered_d_pca composite_running if compulsory_up==1, c(0) p(1) q(2)    kernel(triangular) all 
 regsave Robust  using "coef_nocluster_suffer_discrim.dta", detail(all) ci pval level(95) replace addlabel(outcome, suffered_d_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_suffered_d_pca composite_running if `var'==1, c(0) p(1) q(2)    kernel(triangular) all 
regsave Robust  using "coef_nocluster_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, `var')
}

rdrobust s_suffered_d_pca composite_running, c(0) p(1) q(2)    kernel(triangular) all  
regsave Robust  using "coef_nocluster_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, pooled)

*use "coef_nocluster_suffer_discrim.dta", clear

*Tolerance
rdrobust s_tolerance_pca composite_running if compulsory_up==1, c(0) p(1) q(2)    kernel(triangular) all 
 regsave Robust  using "coef_nocluster_tolerance.dta", detail(all) ci pval level(95) replace addlabel(outcome, tolerance_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_tolerance_pca composite_running if `var'==1, c(0) p(1) q(2)    kernel(triangular) all 
regsave Robust  using "coef_nocluster_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, `var')
}

rdrobust s_tolerance_pca composite_running, c(0) p(1) q(2)    kernel(triangular) all  
regsave Robust  using "coef_nocluster_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, pooled)

*use "coef_nocluster_tolerance.dta", clear


*Social Awareness-Essay
rdrobust s_r_zscore_essay5 composite_running if compulsory_up==1, c(0) p(1) q(2)   kernel(triangular) all 
 regsave Robust  using "coef_nocluster_social_essay.dta", detail(all) ci pval level(95) replace addlabel(outcome, r_zscore_essay5, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_r_zscore_essay5 composite_running if `var'==1, c(0) p(1) q(2)    kernel(triangular) all 
regsave Robust  using "coef_nocluster_social_essay.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, `var')
}

rdrobust s_r_zscore_essay5 composite_running, c(0) p(1) q(2)   kernel(triangular) all  
regsave Robust  using "coef_nocluster_social_essay.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, pooled)

*use "coef_knowledge.dta", clear

***** Political Knowledge
rdrobust s_zsstudies_tot composite_running if compulsory_up==1, c(0) p(1) q(2)    kernel(triangular) all 
 regsave Robust  using "coef_nocluster_knowledge.dta", detail(all) ci pval level(95) replace addlabel(outcome, zsstudies_tot, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_zsstudies_tot composite_running if `var'==1, c(0) p(1) q(2)   kernel(triangular) all 
regsave Robust  using "coef_nocluster_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, `var')
}

rdrobust s_zsstudies_tot composite_running, c(0) p(1) q(2)    kernel(triangular) all  
regsave Robust  using "coef_nocluster_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, pooled)
  
  
***** Memberships

*Factor
rdrobust s_membership_pca composite_running if compulsory_up==1, c(0) p(1) q(2)    kernel(triangular) all 
 regsave Robust  using "coef_nocluster_membership_pca.dta", detail(all) ci pval level(95) replace addlabel(outcome, membership_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_membership_pca composite_running if `var'==1, c(0) p(1) q(2)    kernel(triangular) all 
regsave Robust  using "coef_nocluster_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, `var')
}

rdrobust s_membership_pca composite_running, c(0) p(1) q(2)    kernel(triangular) all  
regsave Robust  using "coef_nocluster_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, pooled)

*use "coef_nocluster_membership_pca.dta", clear

*Any
rdrobust s_member_any composite_running if compulsory_up==1, c(0) p(1) q(2)    kernel(triangular) all 
 regsave Robust  using "coef_nocluster_member_any.dta", detail(all) ci pval level(95) replace addlabel(outcome, member_any, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_member_any composite_running if `var'==1, c(0) p(1) q(2)    kernel(triangular) all 
regsave Robust  using "coef_nocluster_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, `var')
}

rdrobust s_member_any composite_running, c(0) p(1) q(2)    kernel(triangular) all  
regsave Robust  using "coef_nocluster_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, pooled)

*use "coef_nocluster_member_any.dta", clear


*Mean
rdrobust s_member_mean composite_running if compulsory_up==1, c(0) p(1) q(2)    kernel(triangular) all 
 regsave Robust  using "coef_nocluster_member_mean.dta", detail(all) ci pval level(95) replace addlabel(outcome, member_mean, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_member_mean composite_running if `var'==1, c(0) p(1) q(2)    kernel(triangular) all 
regsave Robust  using "coef_nocluster_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, `var')
}

rdrobust s_member_mean composite_running, c(0) p(1) q(2)    kernel(triangular) all  
regsave Robust  using "coef_nocluster_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, pooled)

log close

*use "coef_nocluster_member_mean.dta", clear


use "coef_nocluster_plot_interest.dta", clear
append using  "coef_nocluster_perceive_discrim.dta"
append using  "coef_nocluster_suffer_discrim.dta"
append using  "coef_nocluster_tolerance.dta"
append using  "coef_nocluster_social_essay.dta"
append using  "coef_nocluster_knowledge.dta"
append using  "coef_nocluster_membership_pca.dta"
append using  "coef_nocluster_member_any.dta"
append using  "coef_nocluster_member_mean.dta"

gen rank=5 if cutoff=="pooled"
replace rank=4 if cutoff=="voluntary_down"
replace rank=3 if cutoff=="voluntary_up"
replace rank=2 if cutoff=="compulsory_down"
replace rank=1 if cutoff=="compulsory_up"

gen pooled=0 if cutoff=="pooled"
replace pooled=1 if pooled==.

replace cutoff="Pooled" if cutoff=="pooled"
replace cutoff="Voluntary Down" if cutoff=="voluntary_down"
replace cutoff="Voluntary Up" if cutoff=="voluntary_up"
replace cutoff="Compulsory Down" if cutoff=="compulsory_down"
replace cutoff="Compulsory Up" if cutoff=="compulsory_up"

replace outcomevar="Memberships (Any)" if outcomevar=="s_member_any"
replace outcomevar="Memberships (Mean)" if outcomevar=="s_member_mean"
replace outcomevar="Memberships (PCA)" if outcomevar=="s_membership_pca"
replace outcomevar="   Political Interest" if outcomevar=="s_NETinterest_natpol"
replace outcomevar="  Perceive Discrim. (PCA)" if outcomevar=="s_perceive_d_pca"
replace outcomevar="  Social Awareness Essay" if outcomevar=="s_r_zscore_essay5"
replace outcomevar=" Political Knowledge" if outcomevar=="s_zsstudies_tot"
replace outcomevar="  Suffered Discrim. (PCA)" if outcomevar=="s_suffered_d_pca"
replace outcomevar="  Tolerance (PCA)" if outcomevar=="s_tolerance_pca"

saveold "coef_nocluster_plot_all_coefs.dta", replace version(12)

use "coef_nocluster_plot_all_coefs.dta", clear

sum pval
tab pval
sum coef
tab coef

sum coef if outcomevar=="Memberships (Any)" | outcomevar=="Memberships (Mean)" | outcomevar=="Memberships (PCA)"

gen significant=1 if pval<=0.05
replace significant=0 if significant==.

tab significant

sktest coef
sktest pval

kdens pval , xline(0.05, lcol(red) lpat(dash))
kdens coef, xline(0, lcol(red) lpat(dash)) xlabel(-0.2(0.1)0.2)

sum coef if pooled==1, d




*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** COEFFICIENT PLOTS p(2) q(3) ****************************************
*****************************************************************************************
*****************************************************************************************
cd "" // insert file pathway here

use "final_jop_data_brazil.dta", clear

 gen compulsory_up=1 if year==2006 &  abs(compage_diff06)<=120
 gen compulsory_down=1 if year==2007 &  abs(compage_diff06)<=120
 gen voluntary_up=1 if year==2006 &  abs(volage_diff06)<=120
 gen voluntary_down=1 if year==2007 &  abs(volage_diff06)<=120

 replace compulsory_up=0 if compulsory_down==1 | voluntary_up==1 | voluntary_down==1
 replace compulsory_down=0 if compulsory_up==1 | voluntary_up==1 | voluntary_down==1
 replace voluntary_up=0 if compulsory_up==1 | compulsory_down==1 | voluntary_down==1
 replace voluntary_down=0 if compulsory_up==1 | compulsory_down==1 | voluntary_up==1
  
 gen composite_running=compage_diff06 if compulsory_up==1
 replace composite_running=compage_diff06 if compulsory_down==1
 replace composite_running=volage_diff06 if voluntary_up==1
 replace composite_running=volage_diff06 if voluntary_down==1

  foreach var in NETinterest_natpol ///
  perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 ///	
  zsstudies_tot ///
 membership_pca	member_any	member_mean {	
egen s_`var' = std(`var'), mean(0) std(1)
}


 log using "Coefplot Estimates 2 3.smcl", replace
 
 **** Political Interest 

rdrobust s_NETinterest_natpol composite_running if compulsory_up==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_2_3_plot_interest.dta", detail(all) ci pval level(95) replace addlabel(outcome, NETinterest_natpol, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_NETinterest_natpol composite_running if `var'==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_2_3_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, `var')
}

rdrobust s_NETinterest_natpol composite_running, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_2_3_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled)

*use "coef_2_3_plot_interest.dta", clear


***** Social Awareness

*Perceived Discrimination
rdrobust s_perceive_d_pca composite_running if compulsory_up==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_2_3_perceive_discrim.dta", detail(all) ci pval level(95) replace addlabel(outcome, perceive_d_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_perceive_d_pca composite_running if `var'==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_2_3_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, `var')
}

rdrobust s_perceive_d_pca composite_running, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_2_3_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, pooled)

*use "coef_2_3_perceive_discrim.dta", clear

*Suffer Discrimination
rdrobust s_suffered_d_pca composite_running if compulsory_up==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_2_3_suffer_discrim.dta", detail(all) ci pval level(95) replace addlabel(outcome, suffered_d_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_suffered_d_pca composite_running if `var'==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_2_3_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, `var')
}

rdrobust s_suffered_d_pca composite_running, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_2_3_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, pooled)

*use "coef_2_3_suffer_discrim.dta", clear

*Tolerance
rdrobust s_tolerance_pca composite_running if compulsory_up==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_2_3_tolerance.dta", detail(all) ci pval level(95) replace addlabel(outcome, tolerance_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_tolerance_pca composite_running if `var'==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_2_3_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, `var')
}

rdrobust s_tolerance_pca composite_running, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_2_3_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, pooled)

*use "coef_2_3_tolerance.dta", clear

*Social Awareness-Essay
rdrobust s_r_zscore_essay5 composite_running if compulsory_up==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_2_3_social_essay.dta", detail(all) ci pval level(95) replace addlabel(outcome, r_zscore_essay5, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_r_zscore_essay5 composite_running if `var'==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_2_3_social_essay.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, `var')
}

rdrobust s_r_zscore_essay5 composite_running, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_2_3_social_essay.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, pooled)

*use "coef_knowledge.dta", clear

***** Political Knowledge
rdrobust s_zsstudies_tot composite_running if compulsory_up==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_2_3_knowledge.dta", detail(all) ci pval level(95) replace addlabel(outcome, zsstudies_tot, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_zsstudies_tot composite_running if `var'==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_2_3_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, `var')
}

rdrobust s_zsstudies_tot composite_running, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_2_3_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, pooled)
  
  
***** Memberships

*Factor
rdrobust s_membership_pca composite_running if compulsory_up==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_2_3_membership_pca.dta", detail(all) ci pval level(95) replace addlabel(outcome, membership_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_membership_pca composite_running if `var'==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_2_3_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, `var')
}

rdrobust s_membership_pca composite_running, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_2_3_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, pooled)

*use "coef_2_3_membership_pca.dta", clear

*Any
rdrobust s_member_any composite_running if compulsory_up==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_2_3_member_any.dta", detail(all) ci pval level(95) replace addlabel(outcome, member_any, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_member_any composite_running if `var'==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_2_3_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, `var')
}

rdrobust s_member_any composite_running, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_2_3_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, pooled)

*use "coef_2_3_member_any.dta", clear


*Mean
rdrobust s_member_mean composite_running if compulsory_up==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_2_3_member_mean.dta", detail(all) ci pval level(95) replace addlabel(outcome, member_mean, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_member_mean composite_running if `var'==1, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_2_3_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, `var')
}

rdrobust s_member_mean composite_running, c(0) p(2) q(3)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_2_3_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, pooled)

log close

*use "coef_2_3_member_mean.dta", clear


use "coef_2_3_plot_interest.dta", clear
append using  "coef_2_3_perceive_discrim.dta"
append using  "coef_2_3_suffer_discrim.dta"
append using  "coef_2_3_tolerance.dta"
append using  "coef_2_3_social_essay.dta"
append using  "coef_2_3_knowledge.dta"
append using  "coef_2_3_membership_pca.dta"
append using  "coef_2_3_member_any.dta"
append using  "coef_2_3_member_mean.dta"

gen rank=5 if cutoff=="pooled"
replace rank=4 if cutoff=="voluntary_down"
replace rank=3 if cutoff=="voluntary_up"
replace rank=2 if cutoff=="compulsory_down"
replace rank=1 if cutoff=="compulsory_up"

gen pooled=0 if cutoff=="pooled"
replace pooled=1 if pooled==.

replace cutoff="Pooled" if cutoff=="pooled"
replace cutoff="Voluntary Down" if cutoff=="voluntary_down"
replace cutoff="Voluntary Up" if cutoff=="voluntary_up"
replace cutoff="Compulsory Down" if cutoff=="compulsory_down"
replace cutoff="Compulsory Up" if cutoff=="compulsory_up"

replace outcomevar="Memberships (Any)" if outcomevar=="s_member_any"
replace outcomevar="Memberships (Mean)" if outcomevar=="s_member_mean"
replace outcomevar="Memberships (PCA)" if outcomevar=="s_membership_pca"
replace outcomevar="   Political Interest" if outcomevar=="s_NETinterest_natpol"
replace outcomevar="  Perceive Discrim. (PCA)" if outcomevar=="s_perceive_d_pca"
replace outcomevar="  Social Awareness Essay" if outcomevar=="s_r_zscore_essay5"
replace outcomevar=" Political Knowledge" if outcomevar=="s_zsstudies_tot"
replace outcomevar="  Suffered Discrim. (PCA)" if outcomevar=="s_suffered_d_pca"
replace outcomevar="  Tolerance (PCA)" if outcomevar=="s_tolerance_pca"

saveold "coef_2_3_plot_all_coefs.dta", replace version(12)

use "coef_2_3_plot_all_coefs.dta", clear


*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** COEFFICIENT PLOTS p(3) q(4) ****************************************
*****************************************************************************************
*****************************************************************************************
cd "" // insert file pathway here

use "final_jop_data_brazil.dta", clear

 gen compulsory_up=1 if year==2006 &  abs(compage_diff06)<=120
 gen compulsory_down=1 if year==2007 &  abs(compage_diff06)<=120
 gen voluntary_up=1 if year==2006 &  abs(volage_diff06)<=120
 gen voluntary_down=1 if year==2007 &  abs(volage_diff06)<=120

 replace compulsory_up=0 if compulsory_down==1 | voluntary_up==1 | voluntary_down==1
 replace compulsory_down=0 if compulsory_up==1 | voluntary_up==1 | voluntary_down==1
 replace voluntary_up=0 if compulsory_up==1 | compulsory_down==1 | voluntary_down==1
 replace voluntary_down=0 if compulsory_up==1 | compulsory_down==1 | voluntary_up==1
  
 gen composite_running=compage_diff06 if compulsory_up==1
 replace composite_running=compage_diff06 if compulsory_down==1
 replace composite_running=volage_diff06 if voluntary_up==1
 replace composite_running=volage_diff06 if voluntary_down==1

  foreach var in NETinterest_natpol ///
  perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 ///	
  zsstudies_tot ///
 membership_pca	member_any	member_mean {	
egen s_`var' = std(`var'), mean(0) std(1)
}


 log using "Coefplot Estimates 3 4.smcl", replace
 
 

 
 **** Political Interest 

rdrobust s_NETinterest_natpol composite_running if compulsory_up==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_3_4_plot_interest.dta", detail(all) ci pval level(95) replace addlabel(outcome, NETinterest_natpol, cutoff, compulsory_up)
 
foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_NETinterest_natpol composite_running if `var'==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_3_4_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, `var')
}

rdrobust s_NETinterest_natpol composite_running, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_3_4_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled)

*use "coef_3_4_plot_interest.dta", clear


***** Social Awareness

*Perceived Discrimination
rdrobust s_perceive_d_pca composite_running if compulsory_up==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_3_4_perceive_discrim.dta", detail(all) ci pval level(95) replace addlabel(outcome, perceive_d_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_perceive_d_pca composite_running if `var'==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_3_4_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, `var')
}

rdrobust s_perceive_d_pca composite_running, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_3_4_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, pooled)

*use "coef_3_4_perceive_discrim.dta", clear

*Suffer Discrimination
rdrobust s_suffered_d_pca composite_running if compulsory_up==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_3_4_suffer_discrim.dta", detail(all) ci pval level(95) replace addlabel(outcome, suffered_d_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_suffered_d_pca composite_running if `var'==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_3_4_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, `var')
}

rdrobust s_suffered_d_pca composite_running, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_3_4_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, pooled)

*use "coef_3_4_suffer_discrim.dta", clear

*Tolerance
rdrobust s_tolerance_pca composite_running if compulsory_up==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_3_4_tolerance.dta", detail(all) ci pval level(95) replace addlabel(outcome, tolerance_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_tolerance_pca composite_running if `var'==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_3_4_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, `var')
}

rdrobust s_tolerance_pca composite_running, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_3_4_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, pooled)

*use "coef_3_4_tolerance.dta", clear


*Social Awareness-Essay
rdrobust s_r_zscore_essay5 composite_running if compulsory_up==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_3_4_social_essay.dta", detail(all) ci pval level(95) replace addlabel(outcome, r_zscore_essay5, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_r_zscore_essay5 composite_running if `var'==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_3_4_social_essay.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, `var')
}

rdrobust s_r_zscore_essay5 composite_running, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_3_4_social_essay.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, pooled)

*use "coef_knowledge.dta", clear

***** Political Knowledge
rdrobust s_zsstudies_tot composite_running if compulsory_up==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_3_4_knowledge.dta", detail(all) ci pval level(95) replace addlabel(outcome, zsstudies_tot, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_zsstudies_tot composite_running if `var'==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_3_4_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, `var')
}

rdrobust s_zsstudies_tot composite_running, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_3_4_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, pooled)
  
  
***** Memberships

*Factor
rdrobust s_membership_pca composite_running if compulsory_up==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_3_4_membership_pca.dta", detail(all) ci pval level(95) replace addlabel(outcome, membership_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_membership_pca composite_running if `var'==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_3_4_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, `var')
}

rdrobust s_membership_pca composite_running, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_3_4_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, pooled)

*use "coef_3_4_membership_pca.dta", clear

*Any
rdrobust s_member_any composite_running if compulsory_up==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_3_4_member_any.dta", detail(all) ci pval level(95) replace addlabel(outcome, member_any, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_member_any composite_running if `var'==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_3_4_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, `var')
}

rdrobust s_member_any composite_running, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_3_4_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, pooled)

*use "coef_3_4_member_any.dta", clear


*Mean
rdrobust s_member_mean composite_running if compulsory_up==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_3_4_member_mean.dta", detail(all) ci pval level(95) replace addlabel(outcome, member_mean, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_member_mean composite_running if `var'==1, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_3_4_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, `var')
}

rdrobust s_member_mean composite_running, c(0) p(3) q(4)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_3_4_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, pooled)

log close

*use "coef_3_4_member_mean.dta", clear


use "coef_3_4_plot_interest.dta", clear
append using  "coef_3_4_perceive_discrim.dta"
append using  "coef_3_4_suffer_discrim.dta"
append using  "coef_3_4_social_essay.dta"
append using  "coef_3_4_tolerance.dta"
append using  "coef_3_4_knowledge.dta"
append using  "coef_3_4_membership_pca.dta"
append using  "coef_3_4_member_any.dta"
append using  "coef_3_4_member_mean.dta"

gen rank=5 if cutoff=="pooled"
replace rank=4 if cutoff=="voluntary_down"
replace rank=3 if cutoff=="voluntary_up"
replace rank=2 if cutoff=="compulsory_down"
replace rank=1 if cutoff=="compulsory_up"

gen pooled=0 if cutoff=="pooled"
replace pooled=1 if pooled==.

replace cutoff="Pooled" if cutoff=="pooled"
replace cutoff="Voluntary Down" if cutoff=="voluntary_down"
replace cutoff="Voluntary Up" if cutoff=="voluntary_up"
replace cutoff="Compulsory Down" if cutoff=="compulsory_down"
replace cutoff="Compulsory Up" if cutoff=="compulsory_up"

replace outcomevar="Memberships (Any)" if outcomevar=="s_member_any"
replace outcomevar="Memberships (Mean)" if outcomevar=="s_member_mean"
replace outcomevar="Memberships (PCA)" if outcomevar=="s_membership_pca"
replace outcomevar="   Political Interest" if outcomevar=="s_NETinterest_natpol"
replace outcomevar="  Perceive Discrim. (PCA)" if outcomevar=="s_perceive_d_pca"
replace outcomevar="  Social Awareness Essay" if outcomevar=="s_r_zscore_essay5"
replace outcomevar=" Political Knowledge" if outcomevar=="s_zsstudies_tot"
replace outcomevar="  Suffered Discrim. (PCA)" if outcomevar=="s_suffered_d_pca"
replace outcomevar="  Tolerance (PCA)" if outcomevar=="s_tolerance_pca"

saveold "coef_3_4_plot_all_coefs.dta", replace version(12)

use "coef_3_4_plot_all_coefs.dta", clear





*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** COEFFICIENT PLOTS p(4) q(5) ****************************************
*****************************************************************************************
*****************************************************************************************
cd "" // insert file pathway here

use "final_jop_data_brazil.dta", clear

 gen compulsory_up=1 if year==2006 &  abs(compage_diff06)<=120
 gen compulsory_down=1 if year==2007 &  abs(compage_diff06)<=120
 gen voluntary_up=1 if year==2006 &  abs(volage_diff06)<=120
 gen voluntary_down=1 if year==2007 &  abs(volage_diff06)<=120

 replace compulsory_up=0 if compulsory_down==1 | voluntary_up==1 | voluntary_down==1
 replace compulsory_down=0 if compulsory_up==1 | voluntary_up==1 | voluntary_down==1
 replace voluntary_up=0 if compulsory_up==1 | compulsory_down==1 | voluntary_down==1
 replace voluntary_down=0 if compulsory_up==1 | compulsory_down==1 | voluntary_up==1
  
 gen composite_running=compage_diff06 if compulsory_up==1
 replace composite_running=compage_diff06 if compulsory_down==1
 replace composite_running=volage_diff06 if voluntary_up==1
 replace composite_running=volage_diff06 if voluntary_down==1

  foreach var in NETinterest_natpol ///
  perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 ///	
  zsstudies_tot ///
 membership_pca	member_any	member_mean {	
egen s_`var' = std(`var'), mean(0) std(1)
}



 log using "Coefplot Estimates 4 5.smcl", replace
 
 **** Political Interest 

rdrobust s_NETinterest_natpol composite_running if compulsory_up==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_4_5_plot_interest.dta", detail(all) ci pval level(95) replace addlabel(outcome, NETinterest_natpol, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_NETinterest_natpol composite_running if `var'==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_4_5_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, `var')
}

rdrobust s_NETinterest_natpol composite_running, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_4_5_plot_interest.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled)

*use "coef_4_5_plot_interest.dta", clear


***** Social Awareness

*Perceived Discrimination
rdrobust s_perceive_d_pca composite_running if compulsory_up==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_4_5_perceive_discrim.dta", detail(all) ci pval level(95) replace addlabel(outcome, perceive_d_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_perceive_d_pca composite_running if `var'==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_4_5_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, `var')
}

rdrobust s_perceive_d_pca composite_running, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_4_5_perceive_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, perceive_d_pca, cutoff, pooled)

*use "coef_4_5_perceive_discrim.dta", clear

*Suffer Discrimination
rdrobust s_suffered_d_pca composite_running if compulsory_up==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_4_5_suffer_discrim.dta", detail(all) ci pval level(95) replace addlabel(outcome, suffered_d_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_suffered_d_pca composite_running if `var'==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_4_5_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, `var')
}

rdrobust s_suffered_d_pca composite_running, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_4_5_suffer_discrim.dta", detail(all) ci pval level(95) append addlabel(outcome, suffered_d_pca, cutoff, pooled)

*use "coef_4_5_suffer_discrim.dta", clear

*Tolerance
rdrobust s_tolerance_pca composite_running if compulsory_up==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_4_5_tolerance.dta", detail(all) ci pval level(95) replace addlabel(outcome, tolerance_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_tolerance_pca composite_running if `var'==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_4_5_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, `var')
}

rdrobust s_tolerance_pca composite_running, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_4_5_tolerance.dta", detail(all) ci pval level(95) append addlabel(outcome, tolerance_pca, cutoff, pooled)

*use "coef_4_5_tolerance.dta", clear


*Social Awareness-Essay
rdrobust s_r_zscore_essay5 composite_running if compulsory_up==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_4_5_social_essay.dta", detail(all) ci pval level(95) replace addlabel(outcome, r_zscore_essay5, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_r_zscore_essay5 composite_running if `var'==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_4_5_social_essay.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, `var')
}

rdrobust s_r_zscore_essay5 composite_running, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_4_5_social_essay.dta", detail(all) ci pval level(95) append addlabel(outcome, r_zscore_essay5, cutoff, pooled)

*use "coef_knowledge.dta", clear

***** Political Knowledge
rdrobust s_zsstudies_tot composite_running if compulsory_up==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_4_5_knowledge.dta", detail(all) ci pval level(95) replace addlabel(outcome, zsstudies_tot, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_zsstudies_tot composite_running if `var'==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_4_5_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, `var')
}

rdrobust s_zsstudies_tot composite_running, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_4_5_knowledge.dta", detail(all) ci pval level(95) append addlabel(outcome, zsstudies_tot, cutoff, pooled)
  
***** Memberships

*Factor
rdrobust s_membership_pca composite_running if compulsory_up==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_4_5_membership_pca.dta", detail(all) ci pval level(95) replace addlabel(outcome, membership_pca, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_membership_pca composite_running if `var'==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_4_5_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, `var')
}

rdrobust s_membership_pca composite_running, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_4_5_membership_pca.dta", detail(all) ci pval level(95) append addlabel(outcome, membership_pca, cutoff, pooled)

*use "coef_4_5_membership_pca.dta", clear

*Any
rdrobust s_member_any composite_running if compulsory_up==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_4_5_member_any.dta", detail(all) ci pval level(95) replace addlabel(outcome, member_any, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_member_any composite_running if `var'==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_4_5_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, `var')
}

rdrobust s_member_any composite_running, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_4_5_member_any.dta", detail(all) ci pval level(95) append addlabel(outcome, member_any, cutoff, pooled)

*use "coef_4_5_member_any.dta", clear


*Mean
rdrobust s_member_mean composite_running if compulsory_up==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
 regsave Robust  using "coef_4_5_member_mean.dta", detail(all) ci pval level(95) replace addlabel(outcome, member_mean, cutoff, compulsory_up)

foreach var in  compulsory_down voluntary_up voluntary_down {  
rdrobust s_member_mean composite_running if `var'==1, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all 
regsave Robust  using "coef_4_5_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, `var')
}

rdrobust s_member_mean composite_running, c(0) p(4) q(5)   vce(cluster composite_running) kernel(triangular) all  
regsave Robust  using "coef_4_5_member_mean.dta", detail(all) ci pval level(95) append addlabel(outcome, member_mean, cutoff, pooled)

log close

*use "coef_4_5_member_mean.dta", clear


use "coef_4_5_plot_interest.dta", clear
append using  "coef_4_5_perceive_discrim.dta"
append using  "coef_4_5_suffer_discrim.dta"
append using  "coef_4_5_tolerance.dta"
append using  "coef_4_5_social_essay.dta"
append using  "coef_4_5_knowledge.dta"
append using  "coef_4_5_membership_pca.dta"
append using  "coef_4_5_member_any.dta"
append using  "coef_4_5_member_mean.dta"

gen rank=5 if cutoff=="pooled"
replace rank=4 if cutoff=="voluntary_down"
replace rank=3 if cutoff=="voluntary_up"
replace rank=2 if cutoff=="compulsory_down"
replace rank=1 if cutoff=="compulsory_up"

gen pooled=0 if cutoff=="pooled"
replace pooled=1 if pooled==.

replace cutoff="Pooled" if cutoff=="pooled"
replace cutoff="Voluntary Down" if cutoff=="voluntary_down"
replace cutoff="Voluntary Up" if cutoff=="voluntary_up"
replace cutoff="Compulsory Down" if cutoff=="compulsory_down"
replace cutoff="Compulsory Up" if cutoff=="compulsory_up"

replace outcomevar="Memberships (Any)" if outcomevar=="s_member_any"
replace outcomevar="Memberships (Mean)" if outcomevar=="s_member_mean"
replace outcomevar="Memberships (PCA)" if outcomevar=="s_membership_pca"
replace outcomevar="   Political Interest" if outcomevar=="s_NETinterest_natpol"
replace outcomevar="  Perceive Discrim. (PCA)" if outcomevar=="s_perceive_d_pca"
replace outcomevar="  Social Awareness Essay" if outcomevar=="s_r_zscore_essay5"
replace outcomevar=" Political Knowledge" if outcomevar=="s_zsstudies_tot"
replace outcomevar="  Suffered Discrim. (PCA)" if outcomevar=="s_suffered_d_pca"
replace outcomevar="  Tolerance (PCA)" if outcomevar=="s_tolerance_pca"

saveold "coef_4_5_plot_all_coefs.dta", replace version(12)

use "coef_4_5_plot_all_coefs.dta", clear



*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** BANDWIDTH GRAPHS-quartic *********************************
*****************************************************************************************
*****************************************************************************************

cd "" // insert file pathway here

*Compulsory, Upstream

log using "compulsory upstream, bandwidth estimates", replace

use "final_jop_data_brazil.dta", clear

keep if year_survey==2006

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=10(5)120 {
 rdrobust `var' compage_diff06, c(0) p(4) q(5)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

log close

*Compulsory, Downstream
log using "compulsory downstream, bandwidth estimates", replace

use "final_jop_data_brazil.dta", clear

keep if year_survey==2007

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=10(5)120 {
rdrobust `var' compage_diff06, c(0) p(4) q(5)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

log close


*Voluntary, Upstream
log using "voluntary upstream, bandwidth estimates", replace

use "final_jop_data_brazil.dta", clear

keep if year_survey==2006

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=10(5)120 {
rdrobust `var' volage_diff06, c(0) p(4) q(5)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

log close


*Voluntary, Downstream
log using "voluntary downstream, bandwidth estimates", replace

use "final_jop_data_brazil.dta", clear

keep if year_survey==2007


foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=10(5)120 {
rdrobust `var' volage_diff06, c(0) p(4) q(5)  h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

log close



*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** BANDWIDTH GRAPHS-linear **********************************
*****************************************************************************************
*****************************************************************************************

cd "" // insert file pathway here

*Compulsory, Upstream

log using "compulsory upstream linear, bandwidth estimates", replace

use "final_jop_data_brazil.dta", clear

keep if year_survey==2006

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=10(5)120 {
 rdrobust `var' compage_diff06, c(0)   h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

log close

*Compulsory, Downstream
log using "compulsory downstream linear, bandwidth estimates", replace

use "final_jop_data_brazil.dta", clear

keep if year_survey==2007

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=10(5)120 {
rdrobust `var' compage_diff06, c(0)   h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

log close


*Voluntary, Upstream
log using "voluntary upstream linear, bandwidth estimates", replace

use "final_jop_data_brazil.dta", clear

keep if year_survey==2006

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=10(5)120 {
rdrobust `var' volage_diff06, c(0)   h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

log close


*Voluntary, Downstream
log using "voluntary downstream linear, bandwidth estimates", replace

use "final_jop_data_brazil.dta", clear

keep if year_survey==2007


foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=10(5)120 {
rdrobust `var' volage_diff06, c(0)   h(`i')  vce(cluster dateob) kernel(triangular) all
	mat b =e(b)
	scalar r_`var'_`i'=b[1,3]
	scalar p_`var'_`i'=e(pv_rb)
	scalar se_`var'_`i'=e(se_tau_rb)	
	scalar cih_`var'_`i'=e(ci_r_rb)
	scalar cil_`var'_`i'=e(ci_l_rb)
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  NETinterest_natpol { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  perceive_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  suffered_d_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  tolerance_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  r_zscore_essay5 { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  zsstudies_tot { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  membership_pca { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_any { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list r_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list se_`var'_`i'	
}
}

foreach var in  member_mean { 
forvalues i=10(5)120 {	
scalar list p_`var'_`i'	
}
}

log close

*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** Nonparametric (for tables) *******************************
*****************************************************************************************
*****************************************************************************************

*CCT Optimal Bandwidths
cd "" // insert file pathway here


*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006

rd NETinterest_natpol  compage_diff06, bw(49.41)  
rd perceive_d_pca  compage_diff06, bw(32.42)  
rd suffered_d_pca  compage_diff06, bw(36.42)  
rd tolerance_pca  compage_diff06, bw(40.40)  
rd r_zscore_essay5  compage_diff06, bw(23.68)  
rd zsstudies_tot  compage_diff06, bw(34.47)  
rd membership_pca  compage_diff06, bw(51.52)  
rd member_any  compage_diff06, bw(39.90)  
rd member_mean  compage_diff06, bw(49.71)  

*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007

rd NETinterest_natpol  compage_diff06, bw(26.32)  
rd perceive_d_pca  compage_diff06, bw(46.49)  
rd suffered_d_pca  compage_diff06, bw(39.39)  
rd tolerance_pca  compage_diff06, bw(26.96)  
rd r_zscore_essay5  compage_diff06, bw(32.38)  
rd zsstudies_tot  compage_diff06, bw(23.57)  
rd membership_pca  compage_diff06, bw(22.09)  
rd member_any  compage_diff06, bw(24.87)  
rd member_mean  compage_diff06, bw(21.11) 

*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006

rd NETinterest_natpol  volage_diff06, bw(46.08)  
rd perceive_d_pca  volage_diff06, bw(25.12)  
rd suffered_d_pca  volage_diff06, bw(24.99)  
rd tolerance_pca  volage_diff06, bw(39.81)  
rd r_zscore_essay5  volage_diff06, bw(32.81)  
rd zsstudies_tot  volage_diff06, bw(30.61)  
rd membership_pca  volage_diff06, bw(33.05)  
rd member_any  volage_diff06, bw(29.85)  
rd member_mean  volage_diff06, bw(32.94) 

*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007


rd NETinterest_natpol  volage_diff06, bw(40.32)  
rd perceive_d_pca  volage_diff06, bw(39.39)  
rd suffered_d_pca  volage_diff06, bw(36.97)  
rd tolerance_pca  volage_diff06, bw(31.47)  
rd r_zscore_essay5  volage_diff06, bw(36.14)  
rd zsstudies_tot  volage_diff06, bw(34.42)  
rd membership_pca  volage_diff06, bw(34.65)  
rd member_any  volage_diff06, bw(36.41)  
rd member_mean  volage_diff06, bw(34.76) 


*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** Heterogeneities (for appendix tables) ********************
*****************************************************************************************
*****************************************************************************************

cd "" // insert file pathway here

*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if 	mom_college==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}	
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}

*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006
	
gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}	
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}

		
	
*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}	
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}

	

*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0 

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}	
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	}
	
**** Standardized DV


*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
 foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	egen s_`var' = std(`var'), mean(0) std(1)
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' compage_diff06 if 	mom_college==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_col=b[1,3]
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' compage_diff06 if mom_college==0, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_nocol=b[1,3]
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' compage_diff06 if white_enem==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_white=b[1,3]
	}	
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' compage_diff06 if brownblack==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_brownblack=b[1,3]
	}
	
 foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	scalar list r_`var'_col		
	scalar list r_`var'_nocol		
	scalar list r_`var'_white		
	scalar list r_`var'_brownblack
	}

*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006
	
gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 	
 foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	egen s_`var' = std(`var'), mean(0) std(1)
	}
		
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' compage_diff06 if 	mom_college==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_col=b[1,3]
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' compage_diff06 if mom_college==0, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_nocol=b[1,3]
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' compage_diff06 if white_enem==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_white=b[1,3]
	}	
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' compage_diff06 if brownblack==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_brownblack=b[1,3]
	}
	
 foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	scalar list r_`var'_col		
	scalar list r_`var'_nocol		
	scalar list r_`var'_white		
	scalar list r_`var'_brownblack
	}
		
	
*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
  foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	egen s_`var' = std(`var'), mean(0) std(1)
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' volage_diff06 if 	mom_college==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_col=b[1,3]
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' volage_diff06 if mom_college==0, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_nocol=b[1,3]
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' volage_diff06 if white_enem==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_white=b[1,3]
	}	
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' volage_diff06 if brownblack==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_brownblack=b[1,3]
	}
	
 foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	scalar list r_`var'_col		
	scalar list r_`var'_nocol		
	scalar list r_`var'_white		
	scalar list r_`var'_brownblack
	}

	

*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0 

  foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	egen s_`var' = std(`var'), mean(0) std(1)
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' volage_diff06 if 	mom_college==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_col=b[1,3]
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' volage_diff06 if mom_college==0, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_nocol=b[1,3]
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' volage_diff06 if white_enem==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_white=b[1,3]
	}	
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust s_`var' volage_diff06 if brownblack==1, c(0) p(1) q(2) vce(cluster dateob) kernel(triangular) all
	mat b = e(b)
	scalar r_`var'_brownblack=b[1,3]
	}
	
 foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	scalar list r_`var'_col		
	scalar list r_`var'_nocol		
	scalar list r_`var'_white		
	scalar list r_`var'_brownblack
	}



****Quartic

	
*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if 	mom_college==1, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}	
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}
	
	
*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006
	
gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}	
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}
	

*Voluntary, Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}	
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}	

*Voluntary, Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0 

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}	
	
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(4) q(5) vce(cluster dateob) kernel(triangular) all
	}
	
	
********** Bandwidths


*Compulsory, Downstream
log using "het_comp_down_band.smcl"
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

log close

*Compulsory, Upstream
log using "het_comp_up_band.smcl"
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 
foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==1, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if mom_college==0, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if white_enem==1, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' compage_diff06 if brownblack==1, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

log close	



*Voluntary, Downstream
log using "het_vol_down_band.smcl"
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 


foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}
	
log close 

*Voluntary, Upstream
log using "het_vol_up_band.smcl"
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006

gen mom_college=1 if PEDmomeduc__8==1 | PEDmomeduc__9==1
 replace mom_college=0 if PEDmomeduc__8==0 & PEDmomeduc__9==0
 


foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==1, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if mom_college==0, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if white_enem==1, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(10) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(15) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(20) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(25) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(30) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(35) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(40) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(45) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(50) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(55) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(60) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(65) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(70) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(75) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(80) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(85) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(90) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(95) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(100) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(105) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(110) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(115) vce(cluster dateob) kernel(triangular) all
	rdrobust `var' volage_diff06 if brownblack==1, c(0) p(1) q(2) h(120) vce(cluster dateob) kernel(triangular) all
}	

log close


*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** RDD + DIFF DIFF ******************************************
*****************************************************************************************
*****************************************************************************************

cd "" // insert file pathway here

*** Compulsory Voting (20 days)
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120

gen year_0_1=1 if year_survey==2007
replace year_0_1=0 if year_survey==2006

gen D=(compage_diff06>0)
gen compage_diff06_2=compage_diff06^2
gen compage_diff06_3=compage_diff06^3
gen compage_diff06_4=compage_diff06^4
gen Dcompage_diff06=D*compage_diff06
gen Dcompage_diff06_2=D*compage_diff06_2
gen Dcompage_diff06_3=D*compage_diff06_3
gen Dcompage_diff06_4=D*compage_diff06_4

gen D_year=D*year_0_1

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
egen s_`var'=std(`var'), mean(0) std(1) 
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
qui reg s_`var' D D_year year_0_1 compage_diff06 compage_diff06_2 compage_diff06_3 compage_diff06_4 Dcompage_diff06 Dcompage_diff06_2 Dcompage_diff06_3 Dcompage_diff06_4 if compage_diff06>-20 & compage_diff06<20, cluster(compage_diff06)
	mat b =e(b)
	scalar r_`var'=_b[D_year]
	scalar se_`var'=_se[D]	
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list r_`var'
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list se_`var'
}

*** Compulsory Voting (40 days)
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120

gen year_0_1=1 if year_survey==2007
replace year_0_1=0 if year_survey==2006

gen D=(compage_diff06>0)
gen compage_diff06_2=compage_diff06^2
gen compage_diff06_3=compage_diff06^3
gen compage_diff06_4=compage_diff06^4
gen Dcompage_diff06=D*compage_diff06
gen Dcompage_diff06_2=D*compage_diff06_2
gen Dcompage_diff06_3=D*compage_diff06_3
gen Dcompage_diff06_4=D*compage_diff06_4

gen D_year=D*year_0_1

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
egen s_`var'=std(`var'), mean(0) std(1) 
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
qui reg s_`var' D D_year year_0_1 compage_diff06 compage_diff06_2 compage_diff06_3 compage_diff06_4 Dcompage_diff06 Dcompage_diff06_2 Dcompage_diff06_3 Dcompage_diff06_4 if compage_diff06>-40 & compage_diff06<40, cluster(compage_diff06)
	mat b =e(b)
	scalar r_`var'=_b[D_year]
	scalar se_`var'=_se[D]	
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list r_`var'
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list se_`var'
}


*** Compulsory Voting (80 days)
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120

gen year_0_1=1 if year_survey==2007
replace year_0_1=0 if year_survey==2006

gen D=(compage_diff06>0)
gen compage_diff06_2=compage_diff06^2
gen compage_diff06_3=compage_diff06^3
gen compage_diff06_4=compage_diff06^4
gen Dcompage_diff06=D*compage_diff06
gen Dcompage_diff06_2=D*compage_diff06_2
gen Dcompage_diff06_3=D*compage_diff06_3
gen Dcompage_diff06_4=D*compage_diff06_4

gen D_year=D*year_0_1

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
egen s_`var'=std(`var'), mean(0) std(1) 
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
qui reg s_`var' D D_year year_0_1 compage_diff06 compage_diff06_2 compage_diff06_3 compage_diff06_4 Dcompage_diff06 Dcompage_diff06_2 Dcompage_diff06_3 Dcompage_diff06_4 if compage_diff06>-80 & compage_diff06<80, cluster(compage_diff06)
	mat b =e(b)
	scalar r_`var'=_b[D_year]
	scalar se_`var'=_se[D]	
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list r_`var'
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list se_`var'
}

*** Compulsory Voting (120 days)
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120

gen year_0_1=1 if year_survey==2007
replace year_0_1=0 if year_survey==2006

gen D=(compage_diff06>0)
gen compage_diff06_2=compage_diff06^2
gen compage_diff06_3=compage_diff06^3
gen compage_diff06_4=compage_diff06^4
gen Dcompage_diff06=D*compage_diff06
gen Dcompage_diff06_2=D*compage_diff06_2
gen Dcompage_diff06_3=D*compage_diff06_3
gen Dcompage_diff06_4=D*compage_diff06_4

gen D_year=D*year_0_1

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
egen s_`var'=std(`var'), mean(0) std(1) 
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
qui reg s_`var' D D_year year_0_1 compage_diff06 compage_diff06_2 compage_diff06_3 compage_diff06_4 Dcompage_diff06 Dcompage_diff06_2 Dcompage_diff06_3 Dcompage_diff06_4 if compage_diff06>-80 & compage_diff06<80, cluster(compage_diff06)
	mat b =e(b)
	scalar r_`var'=_b[D_year]
	scalar se_`var'=_se[D]	
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list r_`var'
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list se_`var'
}



*** Voluntary Voting (20 days)
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120

gen year_0_1=1 if year_survey==2007
replace year_0_1=0 if year_survey==2006

gen D=(volage_diff06>0)
gen volage_diff06_2=volage_diff06^2
gen volage_diff06_3=volage_diff06^3
gen volage_diff06_4=volage_diff06^4
gen Dvolage_diff06=D*volage_diff06
gen Dvolage_diff06_2=D*volage_diff06_2
gen Dvolage_diff06_3=D*volage_diff06_3
gen Dvolage_diff06_4=D*volage_diff06_4

gen D_year=D*year_0_1

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
egen s_`var'=std(`var'), mean(0) std(1) 
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
qui reg s_`var' D D_year year_0_1 volage_diff06 volage_diff06_2 volage_diff06_3 volage_diff06_4 Dvolage_diff06 Dvolage_diff06_2 Dvolage_diff06_3 Dvolage_diff06_4 if volage_diff06>-20 & volage_diff06<20, cluster(volage_diff06)
	scalar r_`var'=_b[D_year]
	scalar se_`var'=_se[D]	
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list r_`var'
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list se_`var'
}


*** Voluntary Voting (40 days)
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120

gen year_0_1=1 if year_survey==2007
replace year_0_1=0 if year_survey==2006

gen D=(volage_diff06>0)
gen volage_diff06_2=volage_diff06^2
gen volage_diff06_3=volage_diff06^3
gen volage_diff06_4=volage_diff06^4
gen Dvolage_diff06=D*volage_diff06
gen Dvolage_diff06_2=D*volage_diff06_2
gen Dvolage_diff06_3=D*volage_diff06_3
gen Dvolage_diff06_4=D*volage_diff06_4

gen D_year=D*year_0_1

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
egen s_`var'=std(`var'), mean(0) std(1) 
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
qui reg s_`var' D D_year year_0_1 volage_diff06 volage_diff06_2 volage_diff06_3 volage_diff06_4 Dvolage_diff06 Dvolage_diff06_2 Dvolage_diff06_3 Dvolage_diff06_4 if volage_diff06>-40 & volage_diff06<40, cluster(volage_diff06)
	scalar r_`var'=_b[D_year]
	scalar se_`var'=_se[D]	
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list r_`var'
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list se_`var'
}


*** Voluntary Voting (80 days)
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120

gen year_0_1=1 if year_survey==2007
replace year_0_1=0 if year_survey==2006

gen D=(volage_diff06>0)
gen volage_diff06_2=volage_diff06^2
gen volage_diff06_3=volage_diff06^3
gen volage_diff06_4=volage_diff06^4
gen Dvolage_diff06=D*volage_diff06
gen Dvolage_diff06_2=D*volage_diff06_2
gen Dvolage_diff06_3=D*volage_diff06_3
gen Dvolage_diff06_4=D*volage_diff06_4

gen D_year=D*year_0_1

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
egen s_`var'=std(`var'), mean(0) std(1) 
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
qui reg s_`var' D D_year year_0_1 volage_diff06 volage_diff06_2 volage_diff06_3 volage_diff06_4 Dvolage_diff06 Dvolage_diff06_2 Dvolage_diff06_3 Dvolage_diff06_4 if volage_diff06>-80 & volage_diff06<80, cluster(volage_diff06)
	scalar r_`var'=_b[D_year]
	scalar se_`var'=_se[D]	
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list r_`var'
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list se_`var'
}



*** Voluntary Voting (120 days)
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120

gen year_0_1=1 if year_survey==2007
replace year_0_1=0 if year_survey==2006

gen D=(volage_diff06>0)
gen volage_diff06_2=volage_diff06^2
gen volage_diff06_3=volage_diff06^3
gen volage_diff06_4=volage_diff06^4
gen Dvolage_diff06=D*volage_diff06
gen Dvolage_diff06_2=D*volage_diff06_2
gen Dvolage_diff06_3=D*volage_diff06_3
gen Dvolage_diff06_4=D*volage_diff06_4

gen D_year=D*year_0_1

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
egen s_`var'=std(`var'), mean(0) std(1) 
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
qui reg s_`var' D D_year year_0_1 volage_diff06 volage_diff06_2 volage_diff06_3 volage_diff06_4 Dvolage_diff06 Dvolage_diff06_2 Dvolage_diff06_3 Dvolage_diff06_4 if volage_diff06>-80 & volage_diff06<80, cluster(volage_diff06)
	scalar r_`var'=_b[D_year]
	scalar se_`var'=_se[D]	
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list r_`var'
}

foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
scalar list se_`var'
}


*****************************************************************************************
*****************************************************************************************
*****************************************************************************************
****************************** Individul Scale Items ************************************
*****************************************************************************************
*****************************************************************************************

cd "" // insert file pathway here

*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006

 foreach var in NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political /// Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
 perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc /// Perceive Discrimination
 suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc /// Suffer Discrimination 
 intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel /// Tolerance
 zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4 /// Social Awareness
 sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8 /// Political Knowledge
 q_168 q_169 q_170 q_173 q_171 q_172 q_174 {
 
 egen s_`var'=std(`var'), mean(0) std(1)
 
 }
 
 	rdrobust s_NETinterest_geopol compage_diff06, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
	regsave Robust  using "individual_scale_inputs_redone.dta", detail(all) ci pval level(95) replace addlabel(outcome, s_NETinterest_geopol, cutoff, compulsory up)


 foreach var in  NETinterest_natpol NETinterest_locpol NETread_political /// Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
 perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc /// Perceive Discrimination
 suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc /// Suffer Discrimination 
 intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel /// Tolerance
 zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4 /// Social Awareness
 sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8 /// Political Knowledge
 q_168 q_169 q_170 q_173 q_171 q_172 q_174 { // Membership (PCA, any, mean)

	rdrobust s_`var' compage_diff06, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
	regsave Robust  using "individual_scale_inputs_redone.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, compulsory up)
	mat b =e(b)
	scalar r_`var'=b[1,3]
	scalar p_`var'=e(pv_rb)
	scalar se_`var'=e(se_tau_rb)	
	scalar cih_`var'=e(ci_r_rb)
	scalar cil_`var'=e(ci_l_rb)
}



*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007

 foreach var in NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political /// Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
 perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc /// Perceive Discrimination
 suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc /// Suffer Discrimination 
 intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel /// Tolerance
 zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4 /// Social Awareness
 sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8 /// Political Knowledge
 q_168 q_169 q_170 q_173 q_171 q_172 q_174 {
 
 egen s_`var'=std(`var'), mean(0) std(1)
 
 }

 foreach var in NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political /// Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
 perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc /// Perceive Discrimination
 suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc /// Suffer Discrimination 
 intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel /// Tolerance
 zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4 /// Social Awareness
 sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8 /// Political Knowledge
 q_168 q_169 q_170 q_173 q_171 q_172 q_174 { // Membership (PCA, any, mean)

	rdrobust s_`var' compage_diff06, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
	regsave Robust  using "individual_scale_inputs_redone.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, compulsory down)
	mat b =e(b)
	scalar r_`var'=b[1,3]
	scalar p_`var'=e(pv_rb)
	scalar se_`var'=e(se_tau_rb)	
	scalar cih_`var'=e(ci_r_rb)
	scalar cil_`var'=e(ci_l_rb)
}


	

*Voluntary,  Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006

 foreach var in NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political /// Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
 perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc /// Perceive Discrimination
 suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc /// Suffer Discrimination 
 intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel /// Tolerance
 zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4 /// Social Awareness
 sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8 /// Political Knowledge
 q_168 q_169 q_170 q_173 q_171 q_172 q_174 {
 
 egen s_`var'=std(`var'), mean(0) std(1)
 
 }

 foreach var in NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political /// Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
 perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc /// Perceive Discrimination
 suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc /// Suffer Discrimination 
 intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel /// Tolerance
 zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4 /// Social Awareness
 sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8 /// Political Knowledge
 q_168 q_169 q_170 q_173 q_171 q_172 q_174 { // Membership (PCA, any, mean)

	rdrobust s_`var' volage_diff06, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
	regsave Robust  using "individual_scale_inputs_redone.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, voluntary up)
	mat b =e(b)
	scalar r_`var'=b[1,3]
	scalar p_`var'=e(pv_rb)
	scalar se_`var'=e(se_tau_rb)	
	scalar cih_`var'=e(ci_r_rb)
	scalar cil_`var'=e(ci_l_rb)
}


*Voluntary,  Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007

 foreach var in NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political /// Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
 perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc /// Perceive Discrimination
 suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc /// Suffer Discrimination 
 intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel /// Tolerance
 zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4 /// Social Awareness
 sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8 /// Political Knowledge
 q_168 q_169 q_170 q_173 q_171 q_172 q_174 {
 
 egen s_`var'=std(`var'), mean(0) std(1)
 
 }
 

 foreach var in NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political /// Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
 perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc /// Perceive Discrimination
 suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc /// Suffer Discrimination 
 intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel /// Tolerance
 zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4 /// Social Awareness
 sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8 /// Political Knowledge
 q_168 q_169 q_170 q_173 q_171 q_172 q_174 { // Membership (PCA, any, mean)

	rdrobust s_`var' volage_diff06, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
	regsave Robust  using "individual_scale_inputs_redone.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, voluntary down)
	mat b =e(b)
	scalar r_`var'=b[1,3]
	scalar p_`var'=e(pv_rb)
	scalar se_`var'=e(se_tau_rb)	
	scalar cih_`var'=e(ci_r_rb)
	scalar cil_`var'=e(ci_l_rb)
}


 		
	
**** Pooled

 cd "" // insert file pathway here


 use "final_jop_data_brazil.dta", clear

  gen compulsory_up=1 if year==2006 &  abs(compage_diff06)<=120
 gen compulsory_down=1 if year==2007 &  abs(compage_diff06)<=120
 gen voluntary_up=1 if year==2006 &  abs(volage_diff06)<=120
 gen voluntary_down=1 if year==2007 &  abs(volage_diff06)<=120

 replace compulsory_up=0 if compulsory_down==1 | voluntary_up==1 | voluntary_down==1
 replace compulsory_down=0 if compulsory_up==1 | voluntary_up==1 | voluntary_down==1
 replace voluntary_up=0 if compulsory_up==1 | compulsory_down==1 | voluntary_down==1
 replace voluntary_down=0 if compulsory_up==1 | compulsory_down==1 | voluntary_up==1
  
 gen composite_running=compage_diff06 if compulsory_up==1
 replace composite_running=compage_diff06 if compulsory_down==1
 replace composite_running=volage_diff06 if voluntary_up==1
 replace composite_running=volage_diff06 if voluntary_down==1

 foreach var in NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political /// Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
 perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc /// Perceive Discrimination
 suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc /// Suffer Discrimination 
 intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel /// Tolerance
 zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4 /// Social Awareness
 sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8 /// Political Knowledge
 q_168 q_169 q_170 q_173 q_171 q_172 q_174 {
 
 egen s_`var'=std(`var'), mean(0) std(1)
 
 }

 foreach var in NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political /// Political Interest (Just USED NATIONAL INTEREST, OTHERS SUPPLEMENT)
 perceived_racial perceived_SESdisc perceived_gender perceived_gaydisc perceived_reldisc perceived_origdisc perceived_agedisc perceived_disdisc perceived_otherdisc /// Perceive Discrimination
 suffered_racial suffered_SESdisc suffered_gender suffered_gaydisc suffered_reldisc suffered_origdisc suffered_agedisc suffered_disdisc suffered_othdisc /// Suffer Discrimination 
 intol_race1 intol_race2 intol_race3 intol_race4 intol_ses intol_homosex intol_pol intol_rel /// Tolerance
 zscore_essay5 zscore_essay1  zscore_essay2  zscore_essay3  zscore_essay4 /// Social Awareness
 sstudies_q1 sstudies_q2  sstudies_q3  sstudies_q4  sstudies_q5  sstudies_q6  sstudies_q7  sstudies_q8 /// Political Knowledge
 q_168 q_169 q_170 q_173 q_171 q_172 q_174 { // Membership (PCA, any, mean)

	rdrobust s_`var' volage_diff06, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
	regsave Robust  using "individual_scale_inputs_redone.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, pooled)
	mat b =e(b)
	scalar r_`var'=b[1,3]
	scalar p_`var'=e(pv_rb)
	scalar se_`var'=e(se_tau_rb)	
	scalar cih_`var'=e(ci_r_rb)
	scalar cil_`var'=e(ci_l_rb)
}
	
	
	
	
*** COPIED AND PASTED IN HERE:
use "individual_scale_inputs_redone.dta", clear

sort p
gen n=_n
sum coef if pval<=0.05, d
sum ci_lower 
sum ci_upper 
sum ci_lower if pval<=0.05, d
sum ci_upper if pval<=0.05, d


***********************************************************************************	
***********************************************************************************	s
***********************************************************************************	
************************ 2 years after for 2004 election **************************
***********************************************************************************	
***********************************************************************************	
***********************************************************************************	


use "final_jop_data_brazil.dta", clear

sum compage_diff06 if compage_diff06<2 & compage_diff06>-2
sum volage_diff04 if volage_diff04<2 & volage_diff04>-2

  foreach var in NETinterest_natpol ///
  perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 ///	
  zsstudies_tot ///
 membership_pca	member_any	member_mean {	
egen s_`var' = std(`var'), mean(0) std(1)
}

  foreach var in NETinterest_natpol ///
  perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 ///	
 membership_pca	member_any	member_mean {
 sum `var' if volage_diff04<2 & volage_diff04>-2

 }

 gen cutoff_2004=1 if volage_diff04>=0
 replace cutoff_2004=0 if volage_diff04<0
 
*rdrobust has invertability issues, so switching to parametric global polynomial

*Clustering does something weird to the results; can't estimate an F-statistic

 regress s_NETinterest_natpol cutoff_2004 c.volage_diff04 if volage_diff04<2 & volage_diff04>-121, r
 regsave cutoff_2004  using "coef_two_year_voluntary.dta", detail(all) ci pval level(95) replace addlabel(outcome, NETinterest_natpol, left_bw, 120 days)


  foreach var in  ///
  perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 ///
  zsstudies_tot ///
 membership_pca	member_any	member_mean {
regress s_`var' cutoff_2004 c.volage_diff04 if volage_diff04<2 & volage_diff04>-121, r
 regsave cutoff_2004  using "coef_two_year_voluntary.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', left_bw, 120 days)

}

*Same bandwidth on both sides (note -2 is >= because the treatment includes 0--so 2 values)
  foreach var in NETinterest_natpol ///
  perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 ///	
  zsstudies_tot ///
 membership_pca	member_any	member_mean {
regress s_`var' cutoff_2004 c.volage_diff04 if volage_diff04<2 & volage_diff04>=-2, r
 regsave cutoff_2004  using "coef_two_year_voluntary.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', left_bw, 1 day)
}

use "coef_two_year_voluntary.dta", clear

replace outcome="Memberships (Any)" if outcome=="member_any"
replace outcome="Memberships (Mean)" if outcome=="member_mean"
replace outcome="Memberships (PCA)" if outcome=="membership_pca"
replace outcome="   Political Interest" if outcome=="NETinterest_natpol"
replace outcome="  Perceive Discrim. (PCA)" if outcome=="perceive_d_pca"
replace outcome=" Social Awareness Essay" if outcome=="r_zscore_essay5"
replace outcome=" Political Knowledge" if outcome=="zsstudies_tot"
replace outcome="  Suffered Discrim. (PCA)" if outcome=="suffered_d_pca"
replace outcome="  Tolerance (PCA)" if outcome=="tolerance_pca"



capture drop wide
 gen wide=0 if left_bw=="120 days"
 replace wide=1 if left_bw=="1 day"
 
 sum coef, d

saveold "coef_two_year_voluntary.dta", version(12) replace


***********************************************************************************	
***********************************************************************************
***********************************************************************************	
************************ Interest Scale *******************************************
***********************************************************************************	
***********************************************************************************	
***********************************************************************************	

*Compulsory, Upstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2006

*Political Interest Scale Creation
egen mean_interest=rowmean( NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political)

 foreach var in  mean_interest {
 
 egen s_`var'=std(`var'), mean(0) std(1)
 
 }
 
rdrobust mean_interest compage_diff06, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) replace addlabel(outcome, interest_mean, cutoff, compulsory up, order, 1)

rdrobust mean_interest compage_diff06, c(0) p(2) q(3)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, compulsory up, order, 2)

rdrobust mean_interest compage_diff06, c(0) p(3) q(4)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, compulsory up, order, 3)

rdrobust mean_interest compage_diff06, c(0) p(4) q(5)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, compulsory up, order, 4)


*Compulsory, Downstream
use "final_jop_data_brazil.dta", clear

keep if compage_diff06>-120 & compage_diff06<120
keep if year_survey==2007

 *Political Interest Scale Creation
egen mean_interest=rowmean( NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political)

 foreach var in  mean_interest {
 
 egen s_`var'=std(`var'), mean(0) std(1)
 
 }
 
rdrobust mean_interest compage_diff06, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, compulsory down, order, 1)

rdrobust mean_interest compage_diff06, c(0) p(2) q(3)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, compulsory down, order, 2)

rdrobust mean_interest compage_diff06, c(0) p(3) q(4)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, compulsory down, order, 3)

rdrobust mean_interest compage_diff06, c(0) p(4) q(5)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, compulsory down, order, 4)


*Voluntary,  Upstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2006

  *Political Interest Scale Creation
egen mean_interest=rowmean( NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political)

 foreach var in  mean_interest {
 
 egen s_`var'=std(`var'), mean(0) std(1)
 
 }
 
rdrobust mean_interest volage_diff06, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, voluntary up, order, 1)

rdrobust mean_interest volage_diff06, c(0) p(2) q(3)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, voluntary up, order, 2)

rdrobust mean_interest volage_diff06, c(0) p(3) q(4)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, voluntary up, order, 3)

rdrobust mean_interest volage_diff06, c(0) p(4) q(5)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, voluntary up, order, 4)


*Voluntary,  Downstream
use "final_jop_data_brazil.dta", clear

keep if volage_diff06>-120 & volage_diff06<120
keep if year_survey==2007

 *Political Interest Scale Creation
egen mean_interest=rowmean( NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political)

 foreach var in  mean_interest {
 
 egen s_`var'=std(`var'), mean(0) std(1)
 
 }

rdrobust mean_interest volage_diff06, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, voluntary down, order, 1)

rdrobust mean_interest volage_diff06, c(0) p(2) q(3)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, voluntary down, order, 2)
 		
rdrobust mean_interest volage_diff06, c(0) p(3) q(4)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, voluntary down, order, 3)
 				
rdrobust mean_interest volage_diff06, c(0) p(4) q(5)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, voluntary down, order, 4)
 		 		
	
**** Pooled

 cd "" // insert file pathway here


 use "final_jop_data_brazil.dta", clear

  gen compulsory_up=1 if year==2006 &  abs(compage_diff06)<=120
 gen compulsory_down=1 if year==2007 &  abs(compage_diff06)<=120
 gen voluntary_up=1 if year==2006 &  abs(volage_diff06)<=120
 gen voluntary_down=1 if year==2007 &  abs(volage_diff06)<=120

 replace compulsory_up=0 if compulsory_down==1 | voluntary_up==1 | voluntary_down==1
 replace compulsory_down=0 if compulsory_up==1 | voluntary_up==1 | voluntary_down==1
 replace voluntary_up=0 if compulsory_up==1 | compulsory_down==1 | voluntary_down==1
 replace voluntary_down=0 if compulsory_up==1 | compulsory_down==1 | voluntary_up==1
  
 gen composite_running=compage_diff06 if compulsory_up==1
 replace composite_running=compage_diff06 if compulsory_down==1
 replace composite_running=volage_diff06 if voluntary_up==1
 replace composite_running=volage_diff06 if voluntary_down==1

 *Political Interest Scale Creation
alpha NETinterest_geopol NETinterest_natpol NETinterest_locpol
factor NETinterest_geopol NETinterest_natpol NETinterest_locpol
predict interest_all_2
egen mean_interest=rowmean( NETinterest_geopol NETinterest_natpol NETinterest_locpol NETread_political)

 foreach var in  mean_interest {
 
 egen s_`var'=std(`var'), mean(0) std(1)
 
 }
 
rdrobust mean_interest composite_running, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, pooled, order, 1)

rdrobust mean_interest composite_running, c(0) p(2) q(3)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, pooled, order, 2)
 
rdrobust mean_interest composite_running, c(0) p(3) q(4)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, pooled, order, 3)
  
rdrobust mean_interest composite_running, c(0) p(4) q(5)  vce(cluster dateob) kernel(triangular) all
regsave Robust  using "interest scales.dta", detail(all) ci pval level(95) append addlabel(outcome, interest_mean, cutoff, pooled, order, 4)
 

use "interest scales.dta", clear
*Note that the only significant ones are from the voluntary upstream--the least powered.

***********************************************************************************	
***********************************************************************************
***********************************************************************************	
************************ Age at Test **********************************************
***********************************************************************************	
***********************************************************************************	
***********************************************************************************	

cd ""

use "final_jop_data_brazil.dta", clear

 gen compulsory_up=1 if year==2006 &  abs(compage_diff06)<=120
 gen compulsory_down=1 if year==2007 &  abs(compage_diff06)<=120
 gen voluntary_up=1 if year==2006 &  abs(volage_diff06)<=120
 gen voluntary_down=1 if year==2007 &  abs(volage_diff06)<=120

 replace compulsory_up=0 if compulsory_down==1 | voluntary_up==1 | voluntary_down==1
 replace compulsory_down=0 if compulsory_up==1 | voluntary_up==1 | voluntary_down==1
 replace voluntary_up=0 if compulsory_up==1 | compulsory_down==1 | voluntary_down==1
 replace voluntary_down=0 if compulsory_up==1 | compulsory_down==1 | voluntary_up==1
  
 gen composite_running=compage_diff06 if compulsory_up==1
 replace composite_running=compage_diff06 if compulsory_down==1
 replace composite_running=volage_diff06 if voluntary_up==1
 replace composite_running=volage_diff06 if voluntary_down==1

rdrobust age composite_running 
 
***********************************************************************************	
***********************************************************************************
***********************************************************************************	
************************ Bandwidth Graphs--Pooled *********************************
***********************************************************************************	
***********************************************************************************	
***********************************************************************************	

 use "final_jop_data_brazil.dta", clear

 gen compulsory_up=1 if year==2006 &  abs(compage_diff06)<=120
 gen compulsory_down=1 if year==2007 &  abs(compage_diff06)<=120
 gen voluntary_up=1 if year==2006 &  abs(volage_diff06)<=120
 gen voluntary_down=1 if year==2007 &  abs(volage_diff06)<=120

 replace compulsory_up=0 if compulsory_down==1 | voluntary_up==1 | voluntary_down==1
 replace compulsory_down=0 if compulsory_up==1 | voluntary_up==1 | voluntary_down==1
 replace voluntary_up=0 if compulsory_up==1 | compulsory_down==1 | voluntary_down==1
 replace voluntary_down=0 if compulsory_up==1 | compulsory_down==1 | voluntary_up==1
  
 gen composite_running=compage_diff06 if compulsory_up==1
 replace composite_running=compage_diff06 if compulsory_down==1
 replace composite_running=volage_diff06 if voluntary_up==1
 replace composite_running=volage_diff06 if voluntary_down==1
 
  foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
		egen s_`var'=std(`var'), mean(0) std(1)
		}
 
 rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2) h(10)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) replace addlabel(outcome, NETinterest_natpol, cutoff, pooled, bandwidth, 10)

 rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2) h(20)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bandwidth, 20)

  rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2) h(30)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bandwidth, 30)

  rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2) h(40)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bandwidth, 40)

  rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2) h(50)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bandwidth, 50)

  rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2) h(60)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bandwidth, 60)

  rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2) h(70)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bandwidth, 70)

  rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2) h(80)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bandwidth, 80)

  rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2) h(90)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bandwidth, 90)

  rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2) h(100)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bandwidth, 100)

  rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2) h(110)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bandwidth, 110)

  rdrobust s_NETinterest_natpol composite_running, c(0) p(1) q(2) h(120)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bandwidth, 120)


 foreach var in perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
forvalues i=10(10)120 {
rdrobust s_`var' composite_running, c(0) p(1) q(2)  h(`i')  vce(cluster dateob) kernel(triangular) all
  regsave Robust  using "bw_pooled.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, pooled, bandwidth, `i')
 }
 }
 
 
  use "bw_pooled.dta", clear
  
replace cutoff="Pooled" if cutoff=="pooled"
replace cutoff="Voluntary Down" if cutoff=="voluntary_down"
replace cutoff="Voluntary Up" if cutoff=="voluntary_up"
replace cutoff="Compulsory Down" if cutoff=="compulsory_down"
replace cutoff="Compulsory Up" if cutoff=="compulsory_up"

replace outcome="Memberships (Any)" if outcome=="member_any"
replace outcome="Memberships (Mean)" if outcome=="member_mean"
replace outcome="Memberships (PCA)" if outcome=="membership_pca"
replace outcome="   Political Interest" if outcome=="NETinterest_natpol"
replace outcome="  Perceive Discrim. (PCA)" if outcome=="perceive_d_pca"
replace outcome=" Political Knowledge" if outcome=="zsstudies_tot"
replace outcome=" Social Awareness Essay" if outcome=="r_zscore_essay5"
replace outcome="  Suffered Discrim. (PCA)" if outcome=="suffered_d_pca"
replace outcome="  Tolerance (PCA)" if outcome=="tolerance_pca"

saveold "bw_pooled.dta", version(12) replace
 
***********************************************************************************	
***********************************************************************************
***********************************************************************************	
************************ Spillover Effects ****************************************
***********************************************************************************	
***********************************************************************************	
***********************************************************************************	


 use "final_jop_data_brazil.dta", clear
 
 gen compulsory_up=1 if year==2006 &  abs(compage_diff06)<=120
 gen compulsory_down=1 if year==2007 &  abs(compage_diff06)<=120
 gen voluntary_up=1 if year==2006 &  abs(volage_diff06)<=120
 gen voluntary_down=1 if year==2007 &  abs(volage_diff06)<=120

 replace compulsory_up=0 if compulsory_down==1 | voluntary_up==1 | voluntary_down==1
 replace compulsory_down=0 if compulsory_up==1 | voluntary_up==1 | voluntary_down==1
 replace voluntary_up=0 if compulsory_up==1 | compulsory_down==1 | voluntary_down==1
 replace voluntary_down=0 if compulsory_up==1 | compulsory_down==1 | voluntary_up==1
  
 gen composite_running=compage_diff06 if compulsory_up==1
 replace composite_running=compage_diff06 if compulsory_down==1
 replace composite_running=volage_diff06 if voluntary_up==1
 replace composite_running=volage_diff06 if voluntary_down==1

 drop if composite_running==.
 
 gen treated=1 if composite_running>=0 & composite_running~=.
 replace treated=0 if composite_running<0
 
 drop if codesc=="" // can't include those without a school code
 
 egen mean_treated=mean(treated), by(codesc)
 
 sum mean_treated
 
 egen mean_treated_bin=cut(mean_treated), group(10)
 
 
 bysort mean_treated_bin: sum mean_treated
 
 foreach var in NETinterest_natpol perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
		egen s_`var'=std(`var'), mean(0) std(1)
		}

 rdrobust s_NETinterest_natpol composite_running if mean_treated_bin==0, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) replace addlabel(outcome, NETinterest_natpol, cutoff, pooled, bin, 0)

  rdrobust s_NETinterest_natpol composite_running if mean_treated_bin==1, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bin, 1)

  rdrobust s_NETinterest_natpol composite_running if mean_treated_bin==2, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bin, 2)

  rdrobust s_NETinterest_natpol composite_running if mean_treated_bin==3, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bin, 3)

  rdrobust s_NETinterest_natpol composite_running if mean_treated_bin==4, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bin, 4)

  rdrobust s_NETinterest_natpol composite_running if mean_treated_bin==5, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bin, 5)

  rdrobust s_NETinterest_natpol composite_running if mean_treated_bin==6, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bin, 6)

  rdrobust s_NETinterest_natpol composite_running if mean_treated_bin==7, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bin, 7)

  rdrobust s_NETinterest_natpol composite_running if mean_treated_bin==8, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bin, 8)

  rdrobust s_NETinterest_natpol composite_running if mean_treated_bin==9, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, NETinterest_natpol, cutoff, pooled, bin, 9)
 
foreach var in  perceive_d_pca suffered_d_pca tolerance_pca r_zscore_essay5 zsstudies_tot membership_pca	member_any	member_mean {
rdrobust s_`var' composite_running if mean_treated_bin==0, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, pooled, bin, 0)
 
 rdrobust s_`var' composite_running if mean_treated_bin==1, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, pooled, bin, 1)
 
 rdrobust s_`var' composite_running if mean_treated_bin==2, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, pooled, bin, 2)
 
 rdrobust s_`var' composite_running if mean_treated_bin==3, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, pooled, bin, 3)
 
 rdrobust s_`var' composite_running if mean_treated_bin==4, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, pooled, bin, 4)
 
 rdrobust s_`var' composite_running if mean_treated_bin==5, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, pooled, bin, 5)
 
 rdrobust s_`var' composite_running if mean_treated_bin==6, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, pooled, bin, 6)
 
 rdrobust s_`var' composite_running if mean_treated_bin==7, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, pooled, bin, 7)
 
 rdrobust s_`var' composite_running if mean_treated_bin==8, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, pooled, bin, 8)
 
 rdrobust s_`var' composite_running if mean_treated_bin==9, c(0) p(1) q(2)  vce(cluster dateob) kernel(triangular) all
 regsave Robust  using "spillovers.dta", detail(all) ci pval level(95) append addlabel(outcome, `var', cutoff, pooled, bin, 9)
}


use "spillovers.dta", clear

replace cutoff="Pooled" if cutoff=="pooled"
replace cutoff="Voluntary Down" if cutoff=="voluntary_down"
replace cutoff="Voluntary Up" if cutoff=="voluntary_up"
replace cutoff="Compulsory Down" if cutoff=="compulsory_down"
replace cutoff="Compulsory Up" if cutoff=="compulsory_up"

replace outcome="Memberships (Any)" if outcome=="member_any"
replace outcome="Memberships (Mean)" if outcome=="member_mean"
replace outcome="Memberships (PCA)" if outcome=="membership_pca"
replace outcome="   Political Interest" if outcome=="NETinterest_natpol"
replace outcome="  Perceive Discrim. (PCA)" if outcome=="perceive_d_pca"
replace outcome=" Political Knowledge" if outcome=="zsstudies_tot"
replace outcome=" Social Awareness Essay" if outcome=="r_zscore_essay5"
replace outcome="  Suffered Discrim. (PCA)" if outcome=="suffered_d_pca"
replace outcome="  Tolerance (PCA)" if outcome=="tolerance_pca"

pwcorr coef bin , sig
reg coef bin 

saveold "spillovers.dta", replace version(12)
