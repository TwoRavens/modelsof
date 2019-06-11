set more off
capture log close
version 11.2




log using ii_analysis.txt, text replace




***************************************************************
*** Coercion and the Global Spread of Securities Regulation ***
*** Johannes Kleibl                          April 20, 2014 ***
***                                                         ***
*** Replication code for results in the article and the web ***
*** appendix                                                ***
***************************************************************




*** open the data set

use ii_data.dta, clear

  
	   
	   
	   
*** calculate summary statistics reported in the web appendix

sum lgestsec ///
    log_aid_us_fin_broad_3yt ///
    exist_strequexp10 exist_hg10 exist_ngbr ///
    ioscotc ioscoothmember ///
	Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	common_kl eumember communist postcommunist ///
	log_aid_wb_fin_broad_3yt log_aid_other_fin_broad_3yt ///
	log_aid_us_fin_broad ///
	ioscocoreprinciples polity2_mjgled govright govcenter chgov ///
	time time2 time3 ///
	if regsec == 0 & year >= 1973 & lgestsec != .
	   

	   
	   
	   
	   
	   
*** replicate results reported in Table 1 in the article	   
	   
* Model 1: aid only	
probit lgestsec ///
       log_aid_us_fin_broad_3yt ///
	   time time2 time3 ///
	   if regsec == 0 & year >= 1973, vce(cluster cow_code)	

* Model 2: including controls 
probit lgestsec ///
       log_aid_us_fin_broad_3yt ///
       exist_strequexp10 exist_hg10 exist_ngbr ///
	   ioscotc ioscoothmember ///
       Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///
	   time time2 time3 ///
	   if regsec == 0 & year >= 1973, vce(cluster cow_code)		   
   
* Model 3: also controlling for aid from other donors
probit lgestsec ///
       log_aid_us_fin_broad_3yt ///
	   exist_strequexp10 exist_hg10 exist_ngbr ///
	   ioscotc ioscoothmember ///
       Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///
	   log_aid_wb_fin_broad_3yt log_aid_other_fin_broad_3yt ///
	   time time2 time3 ///
	   if regsec == 0 & year >= 1973, vce(cluster cow_code)	
 
			   
			   
	     
  
 
 
 
 
 
 

*** replicate results reported in Table E1 in the web appendix

* model including regional regulatory regimes
probit lgestsec ///
       log_aid_us_fin_broad_3yt ///
       exist_strequexp10 exist_hg10 exist_ngbr ///
	   ioscotc ioscoothmember ///
       Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///
	   time time2 time3 ///
	   if year >= 1973, vce(cluster cow_code)		   

  	
	
	   

*** replicate results reported in Table E2 in the web appendix 	   
	   
* regional groupwise jackknife for 10 regions as defined by their COW codes
display ""
display ""
display "Model excluding COW codes 1 - 99:"	 
probit lgestsec ///
       log_aid_us_fin_broad_3yt ///
       exist_strequexp10 exist_hg10 exist_ngbr ///
	   ioscotc ioscoothmember ///
       Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///
	   time time2 time3 ///
	   if regsec == 0 & year >= 1973 & cow_code >= 100 ///
	   , vce(cluster cow_code)	

foreach num of numlist 1 (1) 9 {
display ""
display ""				
display "Model excluding COW codes `num'00 - `num'99:"	
probit lgestsec ///
       log_aid_us_fin_broad_3yt ///
       exist_strequexp10 exist_hg10 exist_ngbr ///
	   ioscotc ioscoothmember ///
       Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///
	   time time2 time3 ///
	   if regsec == 0 & year >= 1973 & (cow_code < `num'00 | cow_code > `num'99) ///
	   , vce(cluster cow_code)		   
}	  

  
  
   
 

 
*** replicate results reported in Table E3 in the web appendix 	  

* model using aid in year t
probit lgestsec ///
       log_aid_us_fin_broad ///
       exist_strequexp10 exist_hg10 exist_ngbr ///
	   ioscotc ioscoothmember ///
       Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///  
	   time time2 time3 ///
	   if regsec == 0 & year >= 1973, vce(cluster cow_code)		

* model excluding aid flows >= US$10,000,000
probit lgestsec ///
       log_aid_us_fin_broad_3yt ///
       exist_strequexp10 exist_hg10 exist_ngbr ///
	   ioscotc ioscoothmember ///
       Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///  
	   time time2 time3 ///
	   if regsec == 0 & year >= 1973 & log_aid_us_fin_broad_3yt < 16.118096, vce(cluster cow_code)	  

* model excluding aid flows >= US$ 50,000,000
probit lgestsec ///
       log_aid_us_fin_broad_3yt ///
       exist_strequexp10 exist_hg10 exist_ngbr ///
	   ioscotc ioscoothmember ///
       Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///  
	   time time2 time3 ///
	   if regsec == 0 & year >= 1973 & log_aid_us_fin_broad_3yt < 17.727534, vce(cluster cow_code)	  

	   
	   
	   

	   
	   
*** replicate results reported in Table E4 in the web appendix 	  
	   	   
* model using alternative operationalization of IOSCO member control variable (coded 1 from 1998 on when IOSCO for the first time issued its Core Principles)
probit lgestsec ///
       log_aid_us_fin_broad_3yt ///
       exist_strequexp10 exist_hg10 exist_ngbr ///
	   ioscotc ioscocoreprinciples ///
       Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///
	   time time2 time3 ///
	   if regsec == 0 & year >= 1973, vce(cluster cow_code)		

* model including the level of democracy instead of veto players
probit lgestsec ///
       log_aid_us_fin_broad_3yt ///
       exist_strequexp10 exist_hg10 exist_ngbr ///
	   ioscotc ioscoothmember ///
       Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polity2_mjgled Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///
	   time time2 time3 ///
	   if regsec == 0 & year >= 1973, vce(cluster cow_code)		

* model controlling for government partisanship variables
probit lgestsec ///
       log_aid_us_fin_broad_3yt ///
       exist_strequexp10 exist_hg10 exist_ngbr ///
       ioscotc ioscoothmember ///
	   Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///
	   govright govcenter chgov ///
	   time time2 time3 ///
	   if regsec == 0 & year >= 1973, vce(cluster cow_code)		

	   
	   
	   
	   
	   
  
*** replicate results reported in Table E5 in the web appendix 	  
 	
* rare events logit model	   
relogit lgestsec ///
       log_aid_us_fin_broad_3yt ///
       exist_strequexp10 exist_hg10 exist_ngbr ///
	   ioscotc ioscoothmember ///
       Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///
	   time time2 time3 ///
	   if regsec == 0 & year >= 1973, cluster(cow_code)
  
* semi-parametric Cox model  
preserve   
stset time, id(cow_code) failure(lgestsec == 1)	  
stcox ///
       log_aid_us_fin_broad_3yt ///
       exist_strequexp10 exist_hg10 exist_ngbr ///
	   ioscotc ioscoothmember ///
       Llpwt_pop Llpwt_rgdpch Lpwt_growth Lpwt_openk polconiii Lstex_exist bank_crisis_3y ///
	   common_kl eumember communist postcommunist ///
	   if regsec == 0 & year >= 1973, cluster(cow_code) efron nohr 	  
restore 
  
  

 
 

log close 
 
 
 
 
  
  
*** see the "ii_analysis_sml.txt" log-file for the replication results of Table E6 in the web appendix  
 	  
  
  
  
  
  

  
