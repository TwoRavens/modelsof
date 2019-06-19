clear
set more off
set mem 2000m

cd C:\NBB\Projects\ECB\

qui cap log close
qui log using trade_decomp_1sem.log, replace


	use Data\ixd_1_trim_2008.dta, clear
	append using Data\ixd_2_trim_2008.dta
	append using Data\ixd_1_trim_2009.dta
	append using Data\ixd_2_trim_2009.dta
	gen byte EU=0
	replace EU=1 if flow=="II" | flow=="XI"
	replace flow="IMP" if flow=="II" | flow=="IE"
	replace flow="EXP" if flow=="XI" | flow=="XE"

	egen uncontr_tot_trade=sum(value), by(year flow)
	tab uncontr_tot_trade year if flow=="EXP"
	
	tab uncontr_tot_trade year if flow=="IMP"
	
	drop uncontr_tot_trade


	gen chow = 1 if  ///
		 	 nature == "1" | nature == "11" | nature == "12" | nature == "13" | nature == "14" | nature == "15" | nature == "16" | nature == "17" | ///
			 nature == "18" | nature == "19"  | ///
			 nature == "3" | nature == "31" | nature == "32" | nature == "33" | nature == "34" | nature == "35" | nature == "36" | nature == "37" | ///
			 nature == "38" | nature == "39"  | ///
			 nature == "7" | nature == "71" | nature == "72" | nature == "73" | nature == "74" | nature == "75" | nature == "76" | nature == "77" | ///
			 nature == "78" | nature == "79"  | ///
			 nature ==  "8" | nature ==  "81" | nature ==  "82" | nature ==  "83" | nature ==  "84" | nature ==  "85" | nature ==  "86" | ///
			 nature == "87" | nature ==  "88" | nature ==  "89"
	
	qui count if chow == 1
	
	*******keeping only those transactins involving changes in ownerships*****
	keep if chow == 1 
	drop chow
	egen uncontr_tot_trade=sum(value), by(year flow)
	tab uncontr_tot_trade year if flow=="EXP"
	
	tab uncontr_tot_trade year if flow=="IMP"
	
	drop uncontr_tot_trade nature
	***********	


	**Eliminating some unuseful codes 
	
	drop if  land == "EU" |land == "II" | land == "BE" |land == "XX" | land == "QQ" | land == "QU" | land =="QX" |  land =="QY" |  land =="QZ" | land =="XN" |  land =="XU" |  land =="XV" |  land =="XW" |  land =="XS" |  land =="XR" |  land =="XQ" |  land =="XP" |  land =="XO" |  land =="XT"   
	egen uncontr_tot_trade=sum(value), by(year flow)
	tab uncontr_tot_trade year if flow=="EXP"
	
	tab uncontr_tot_trade year if flow=="IMP"
	
	drop uncontr_tot_trade 
	
	**Adding informaton about OECD in 2008
	
	sort land
	merge land using Data\OECD_2008.dta
	drop if _merge==2
	replace  oecd_2008=0 if  oecd_2008==.
	drop _merge
	replace EU=0 if land=="BR" | land=="ID" | land=="CN"
	egen max_EU=max(EU), by (land)
	replace EU=max_EU
	drop max_EU

	***drop trade by non residents********

	sort vat year
	merge vat year using Data\Non_residents_year_2008.dta
	drop if _merge==2
	drop _merge
	gen keep=1
	replace keep=0 if resd!=""
	drop  resd

	sort vat year
	merge vat year using Data\Non_residents_year_2009.dta
	drop if _merge==2
	drop _merge
	replace keep=0 if resd!=""
	drop  resd

	keep if keep==1



	collapse (sum)  weight units value (mean) EU oecd_2008, by( year vat flow land code) 
	
******************************Trade margins**********************************************
******************************Trade margins**********************************************

	**Building margins
	sort year flow vat  land code 	
	gen byte firm_counter=0
	replace firm_counter=1 if vat[_n]!=vat[_n-1]
	gen byte country_counter=1
	replace country_counter=0 if land[_n]==land[_n-1] & vat[_n]==vat[_n-1]
	gen byte product_counter=1
	replace product_counter=0 if code[_n]==code[_n-1] & land[_n]==land[_n-1] & vat[_n]==vat[_n-1] 
	gen mix_quantity=units
	replace mix_quantity= weight if mix_quantity==0 
	replace weight=0 if units>0
	drop units
	save temp1sm.dta, replace


	********Data for country Table*********
	use temp1sm.dta, clear
	collapse(sum)  value, by( land year)
	reshape wide  value, i(land) j(year)
	gen pippo= value2008 +value2009
	drop if pippo==.
	drop pippo
	egen rank=rank(-value2008)
	drop if rank>100
	gen drop= ((value2009/ value2008)-1)*100
	sort rank

	********Summary statistics of the trade collapse for different type of goods*********
	use temp1sm.dta, clear
	gen HS4=substr(code,1,4)
	rename HS4  CN4_2008
	sort   CN4_2008
	*merge  hs07_4dig using Data\hs07_4dig_bec.dta
	merge  CN4_2008 using Data\cn_2008_cpa_2002.dta
	drop if _merge==2
	replace Other=1 if _merge==1
	recode Intermediate Capital_goods Consumer_dur Consumer_n_dur Energy (.=0) if _merge==1
	drop _merge
	gen good_type=0
	replace good_type=2 if Intermediate==1 
	replace good_type=3 if Capital_goods==1 
	replace good_type=4 if Consumer_dur==1 
	replace good_type=1 if Consumer_n_dur==1 
	replace good_type=5 if Energy==1 
	replace good_type=6 if Other==1
	collapse(sum) value ,by(year  flow good_type)
	sort  flow good_type year

	********DECOMPOSITION: ALL COUNTRIES*********

	use temp1sm.dta, clear
	egen firms=sum(firm_counter), by (year flow)
	egen av_country=sum(country_counter/firms), by (year flow)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow)
	egen av_sales=mean(value), by (year flow)
	egen av_mix_q=mean(mix_quantity), by (year flow)
	egen av_mix_p=mean(value/av_mix_q), by (year flow)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year)



	********DECOMPOSITION: ALL COUNTRIES New, Stayers, Exiters*********

	use temp1sm.dta, clear
	egen pippo=sum(value), by(vat year flow)
	egen step08=max(pippo)if year==2008, by (vat year flow) 
	egen firm_trade_2008=max(step08), by (vat flow)
	replace firm_trade_2008 = 0 if firm_trade_2008==.
	egen step09=max(pippo)if year==2009, by (vat year flow) 
	egen firm_trade_2009=max(step09), by (vat flow)
	replace firm_trade_2009 = 0 if firm_trade_2009==.
	save temp_smart.dta, replace

	*stayers
	use temp_smart.dta, clear
	keep if firm_trade_2008>0 & firm_trade_2009>0
	egen firms=sum(firm_counter), by (year flow)
	egen av_country=sum(country_counter/firms), by (year flow)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow)
	egen av_sales=mean(value), by (year flow)
	egen av_mix_q=mean(mix_quantity), by (year flow)
	egen av_mix_p=mean(value/av_mix_q), by (year flow)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year)

	*new
	use temp_smart.dta, clear
	keep if firm_trade_2008==0 & firm_trade_2009>0
	egen firms=sum(firm_counter), by (year flow)
	egen av_country=sum(country_counter/firms), by (year flow)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow)
	egen av_sales=mean(value), by (year flow)
	egen av_mix_q=mean(mix_quantity), by (year flow)
	egen av_mix_p=mean(value/av_mix_q), by (year flow)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year)


	*exiter
	use temp_smart.dta, clear
	keep if firm_trade_2008>0 & firm_trade_2009==0
	egen firms=sum(firm_counter), by (year flow)
	egen av_country=sum(country_counter/firms), by (year flow)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow)
	egen av_sales=mean(value), by (year flow)
	egen av_mix_q=mean(mix_quantity), by (year flow)
	egen av_mix_p=mean(value/av_mix_q), by (year flow)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year)



	*Mean and SD of imports and exports by exiters
	use temp_smart.dta, clear
	keep if firm_trade_2008>0 & firm_trade_2009==0
	keep if flow=="EXP"
	collapse(mean) firm_trade_2008, by(vat)
	su firm_trade_2008
	use temp_smart.dta, clear
	keep if firm_trade_2008>0 & firm_trade_2009==0
	keep if flow=="IMP"
	collapse(mean) firm_trade_2008, by(vat)
	su firm_trade_2008

	*******see below for entrans and exiters in 2007-2008



	********DECOMPOSITION: 1) EU 2) non EU but OECD 3) non EU non OECD*********

	use temp1sm.dta, clear
	gen country_group=1 if EU==1
	replace country_group =2 if EU==0 & oecd_2008==1
	replace country_group =3 if country_group==. 
/*
	egen value_cut_eu=sum(value), by (year vat EU flow)
	drop if  value_cut_eu<=1000000 &  EU==1 &  flow=="EXP"
	drop if  value_cut_eu<=400000 &  EU==1 &  flow=="IMP"
*/
	sort year flow country_group vat  land code 	
	replace firm_counter=1 if vat[_n]!=vat[_n-1]
	egen firms=sum(firm_counter), by (year flow country_group)
	egen av_country=sum(country_counter/firms), by (year flow  country_group)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow  country_group)
	egen av_sales=mean(value), by (year flow  country_group)
	egen av_mix_q=mean(mix_quantity), by (year flow  country_group)
	egen av_mix_p=mean(value/av_mix_q), by (year flow  country_group)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow  country_group)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow  country_group)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year  country_group)
	sort  flow country_group year 

	********DECOMPOSITION: Intermediates, capital and durables good vs Other*********

	use temp1sm.dta, clear
	gen HS4=substr(code,1,4)
	rename HS4  CN4_2008
	sort   CN4_2008
	merge  CN4_2008 using Data\cn_2008_cpa_2002.dta
	drop if _merge==2
	replace Other=1 if _merge==1
	recode Intermediate Capital_goods Consumer_dur Consumer_n_dur Energy (.=0) if _merge==1
	drop _merge
	gen inter_cap=0
	replace inter_cap=1 if Capital_goods==1 | Intermediate==1 |  Consumer_dur==1
	sort year flow inter_cap vat  land code 
	replace firm_counter=1 if vat[_n]!=vat[_n-1]
	egen firms=sum(firm_counter), by (year flow  inter_cap)
	egen av_country=sum(country_counter/firms), by (year flow   inter_cap)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow  inter_cap)
	egen av_sales=mean(value), by (year flow   inter_cap)
	egen av_mix_q=mean(mix_quantity), by (year flow   inter_cap)
	egen av_mix_p=mean(value/av_mix_q), by (year flow inter_cap)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow inter_cap)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow inter_cap)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year inter_cap)
	sort  flow inter_cap year 


******************************Firm level data******************************


	use  temp1sm.dta, replace
	sort vat
	merge vat using Data\firm_data.dta
	keep if _merge==3
	drop _merge
	save temp1sm2.dta, replace



	********DECOMPOSITION: Small large firms*********

	use temp1sm2.dta, clear
	drop if r_size==.
	egen firms=sum(firm_counter), by (year flow  r_size)
	egen av_country=sum(country_counter/firms), by (year flow  r_size)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow  r_size)
	egen av_sales=mean(value), by (year flow  r_size)
	egen av_mix_q=mean(mix_quantity), by (year flow  r_size)
	egen av_mix_p=mean(value/av_mix_q), by (year flow  r_size)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow  r_size)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow  r_size)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year  r_size)
	sort  flow r_size year 

	********DECOMPOSITION: low high productive firms*********

	use temp1sm2.dta, clear
	drop if r_prod==.
	egen firms=sum(firm_counter), by (year flow  r_prod)
	egen av_country=sum(country_counter/firms), by (year flow  r_prod)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow  r_prod)
	egen av_sales=mean(value), by (year flow  r_prod)
	egen av_mix_q=mean(mix_quantity), by (year flow  r_prod)
	egen av_mix_p=mean(value/av_mix_q), by (year flow  r_prod)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow  r_prod)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow  r_prod)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year  r_prod)
	sort  flow r_* year 


	********DECOMPOSITION: low high share of debts over passive firms*********

	use temp1sm2.dta, clear
	drop if  r_share_debts_o_passive==.
	egen firms=sum(firm_counter), by (year flow     r_share_debts_o_passive)
	egen av_country=sum(country_counter/firms), by (year flow     r_share_debts_o_passive)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow     r_share_debts_o_passive)
	egen av_sales=mean(value), by (year flow     r_share_debts_o_passive)
	egen av_mix_q=mean(mix_quantity), by (year flow     r_share_debts_o_passive)
	egen av_mix_p=mean(value/av_mix_q), by (year flow    r_share_debts_o_passive)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow     r_share_debts_o_passive)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow    r_share_debts_o_passive)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year    r_share_debts_o_passive)
	sort  flow r_* year 


	********DECOMPOSITION: low high share of long term debts*********

	use temp1sm2.dta, clear
	drop if   r_share_debts_due_after_one==.
	egen firms=sum(firm_counter), by (year flow    r_share_debts_due_after_one)
	egen av_country=sum(country_counter/firms), by (year flow     r_share_debts_due_after_one)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow    r_share_debts_due_after_one)
	egen av_sales=mean(value), by (year flow    r_share_debts_due_after_one)
	egen av_mix_q=mean(mix_quantity), by (year flow    r_share_debts_due_after_one)
	egen av_mix_p=mean(value/av_mix_q), by (year flow   r_share_debts_due_after_one)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow     r_share_debts_due_after_one)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow    r_share_debts_due_after_one)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year  r_share_debts_due_after_one)
	sort  flow r_* year 


	********DECOMPOSITION: low high share of finantial debts*********

	use temp1sm2.dta, clear
	drop if    r_share_fin_debt==.
	egen firms=sum(firm_counter), by (year flow   r_share_fin_debt)
	egen av_country=sum(country_counter/firms), by (year flow     r_share_fin_debt)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow    r_share_fin_debt)
	egen av_sales=mean(value), by (year flow   r_share_fin_debt)
	egen av_mix_q=mean(mix_quantity), by (year flow   r_share_fin_debt)
	egen av_mix_p=mean(value/av_mix_q), by (year flow   r_share_fin_debt)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow     r_share_fin_debt)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow   r_share_fin_debt)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year  r_share_fin_debt)
	sort  flow r_* year 


	********DECOMPOSITION: non-MNE vs MNE*********

	use temp1sm2.dta, clear
	drop if    mne==.
	egen firms=sum(firm_counter), by (year flow   mne)
	egen av_country=sum(country_counter/firms), by (year flow  mne)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow mne)
	egen av_sales=mean(value), by (year flow  mne)
	egen av_mix_q=mean(mix_quantity), by (year flow mne)
	egen av_mix_p=mean(value/av_mix_q), by (year flow mne)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow   mne)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow mne)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year mne)
	sort  flow mne year 

	********DECOMPOSITION: non-foreign owned vs foreign owned*********

	use temp1sm2.dta, clear
	drop if    for==.
	egen firms=sum(firm_counter), by (year flow   for)
	egen av_country=sum(country_counter/firms), by (year flow  for)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow for)
	egen av_sales=mean(value), by (year flow  for)
	egen av_mix_q=mean(mix_quantity), by (year flow for)
	egen av_mix_p=mean(value/av_mix_q), by (year flow for)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow   for)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow for)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year for)
	sort  flow for year 





******************************Export and Production by Prodcom 2008 2 digits******************************

***************Exports*******************



	use temp1sm.dta, clear
	drop  mix_quantity product_counter country_counter firm_counter oecd_2008 EU weight land vat
	collapse(sum)  value, by( year flow code)
	keep if  flow=="EXP"
	drop flow
	rename  code  CN8_2008
	sort  CN8_2008
	merge  CN8_2008 using Data\cn_2008_prodcom_2008.dta
	keep if _merge==3
	drop _merge
	collapse(sum)  value, by( year  Prodcom2_2008)
	replace  Prodcom2_2008="33" if  Prodcom2_2008=="39"	
	rename value value_export
	reshape wide value_export, i( Prodcom2_2008) j(year)
	sort Prodcom2_2008
	merge  Prodcom2_2008 using Data\Prodcom_1sem_2008_2009_2digit_BE.dta
	keep if _merge==3
	drop _merge
	*collapse (sum) value_export2008 value_export2009 value_production2008 value_production2009
	gen drop= ((value_export2009/ value_export2008)-1)*100
	gen ratio_2008= value_export2008/ value_production2008
	gen ratio_2009= value_export2009/ value_production2009
	su  ratio_2008 ratio_2009
	corr  ratio_2008 ratio_2009


***************Imports*******************



	use temp1sm.dta, clear
	drop  mix_quantity product_counter country_counter firm_counter oecd_2008 EU weight land vat
	collapse(sum)  value, by( year flow code)
	keep if  flow=="IMP"
	drop flow
	rename  code  CN8_2008
	sort  CN8_2008
	merge  CN8_2008 using Data\cn_2008_prodcom_2008.dta
	keep if _merge==3
	drop _merge
	collapse(sum)  value, by( year  Prodcom2_2008)
	replace  Prodcom2_2008="33" if  Prodcom2_2008=="39"	
	rename value value_import
	reshape wide value_import, i( Prodcom2_2008) j(year)
	sort Prodcom2_2008
	merge  Prodcom2_2008 using Data\Prodcom_1sem_2008_2009_2digit_BE.dta
	keep if _merge==3
	drop _merge
	*collapse (sum)  value_import2008 value_import2009 value_production2008 value_production2009
	gen drop= ((value_import2009/ value_import2008)-1)*100
	gen ratio_2008= value_import2008/ value_production2008
	gen ratio_2009= value_import2009/ value_production2009
	su  ratio_2008 ratio_2009
	corr  ratio_2008 ratio_2009







******************************Stayers weigth******************************

**********2008-2009*******************


	use temp1sm.dta, clear
	collapse(sum)  value if  flow=="EXP", by(vat year)
	xtset vat year
	gen pippo=l1.value
	egen pippa=max(pippo), by (vat)
	gen stayer=0
	replace stayer=1 if pippa!=.
	collapse(sum)  value, by(year  stayer)


	use temp1sm.dta, clear
	collapse(sum)  value if  flow=="EXP", by(vat year)
	fillin vat year
	xtset vat year
	gen pippo=l1.value
	gen check0=pippo+value
	egen pippa=max(check0), by (vat)
	gen stayer=0
	replace stayer=1 if pippa!=.
	drop pippa
	gen new=0
	gen check=0 
	replace check=1 if value!=. & value!=0 & year==2009 & pippo==.
	egen pippa=max(check), by (vat)
	replace new=2 if pippa==1
	drop pippa
	gen exit=0
	gen check2=0 
	replace check2=1 if value!=. & value!=0 & year==2008 & f1.value==.
	egen pippa=max(check2), by (vat)
	replace exit=3 if pippa==1
	drop  check2 pippa  check check0 _fillin pippo
	keep if year==2009
	gen count=1
	gen firm_type=stayer+exit+new
	collapse(sum)  value count, by(year  firm_type)


	use temp1sm.dta, clear
	collapse(sum)  value if  flow=="IMP", by(vat year)
	xtset vat year
	gen pippo=l1.value
	egen pippa=max(pippo), by (vat)
	gen stayer=0
	replace stayer=1 if pippa!=.
	collapse(sum)  value, by(year  stayer)


	use temp1sm.dta, clear
	collapse(sum)  value if  flow=="IMP", by(vat year)
	fillin vat year
	xtset vat year
	gen pippo=l1.value
	gen check0=pippo+value
	egen pippa=max(check0), by (vat)
	gen stayer=0
	replace stayer=1 if pippa!=.
	drop pippa
	gen new=0
	gen check=0 
	replace check=1 if value!=. & value!=0 & year==2009 & pippo==.
	egen pippa=max(check), by (vat)
	replace new=2 if pippa==1
	drop pippa
	gen exit=0
	gen check2=0 
	replace check2=1 if value!=. & value!=0 & year==2008 & f1.value==.
	egen pippa=max(check2), by (vat)
	replace exit=3 if pippa==1
	drop  check2 pippa  check check0 _fillin pippo
	keep if year==2009
	gen count=1
	gen firm_type=stayer+exit+new
	collapse(sum)  value count, by(year  firm_type)



**********2007-2008*******************


	use Data\ixd_1_trim_2007.dta, clear
	append using Data\ixd_2_trim_2007.dta
	append using Data\ixd_1_trim_2008.dta
	append using Data\ixd_2_trim_2008.dta
	gen byte EU=0
	replace EU=1 if flow=="II" | flow=="XI"
	replace flow="IMP" if flow=="II" | flow=="IE"
	replace flow="EXP" if flow=="XI" | flow=="XE"

	gen chow = 1 if  ///
		 	 nature == "1" | nature == "11" | nature == "12" | nature == "13" | nature == "14" | nature == "15" | nature == "16" | nature == "17" | ///
			 nature == "18" | nature == "19"  | ///
			 nature == "3" | nature == "31" | nature == "32" | nature == "33" | nature == "34" | nature == "35" | nature == "36" | nature == "37" | ///
			 nature == "38" | nature == "39"  | ///
			 nature == "7" | nature == "71" | nature == "72" | nature == "73" | nature == "74" | nature == "75" | nature == "76" | nature == "77" | ///
			 nature == "78" | nature == "79"  | ///
			 nature ==  "8" | nature ==  "81" | nature ==  "82" | nature ==  "83" | nature ==  "84" | nature ==  "85" | nature ==  "86" | ///
			 nature == "87" | nature ==  "88" | nature ==  "89"
	
	keep if chow == 1 
	drop chow
	drop if  land == "EU" |land == "II" | land == "BE" |land == "XX" | land == "QQ" | land == "QU" | land =="QX" |  land =="QY" |  land =="QZ" | land =="XN" |  land =="XU" |  land =="XV" |  land =="XW" |  land =="XS" |  land =="XR" |  land =="XQ" |  land =="XP" |  land =="XO" |  land =="XT"   
	


	***drop trade by non residents********

	sort vat year
	merge vat year using Data\Non_residents_year_2007.dta
	drop if _merge==2
	drop _merge
	gen keep=1
	replace keep=0 if resd!=""
	drop  resd

	sort vat year
	merge vat year using Data\Non_residents_year_2008.dta
	drop if _merge==2
	drop _merge
	replace keep=0 if resd!=""
	drop  resd
	keep if keep==1


	collapse (sum)  weight units value, by( year vat flow land code) 
	save temp_ciccio.dta, replace
	
	use temp_ciccio.dta, clear
	collapse(sum)  value if  flow=="EXP", by(vat year)
	xtset vat year
	gen pippo=l1.value
	egen pippa=max(pippo), by (vat)
	gen stayer=0
	replace stayer=1 if pippa!=.
	collapse(sum)  value, by(year  stayer)



	use temp_ciccio.dta, clear
	collapse(sum)  value if  flow=="EXP", by(vat year)
	fillin vat year
	xtset vat year
	gen pippo=l1.value
	gen check0=pippo+value
	egen pippa=max(check0), by (vat)
	gen stayer=0
	replace stayer=1 if pippa!=.
	drop pippa
	gen new=0
	gen check=0 
	replace check=1 if value!=. & value!=0 & year==2008 & pippo==.
	egen pippa=max(check), by (vat)
	replace new=2 if pippa==1
	drop pippa
	gen exit=0
	gen check2=0 
	replace check2=1 if value!=. & value!=0 & year==2007 & f1.value==.
	egen pippa=max(check2), by (vat)
	replace exit=3 if pippa==1
	drop  check2 pippa  check check0 _fillin pippo
	keep if year==2008
	gen count=1
	gen firm_type=stayer+exit+new
	collapse(sum)  value count, by(year  firm_type)


	use temp_ciccio.dta, clear
	collapse(sum)  value if  flow=="IMP", by(vat year)
	xtset vat year
	gen pippo=l1.value
	egen pippa=max(pippo), by (vat)
	gen stayer=0
	replace stayer=1 if pippa!=.
	collapse(sum)  value, by(year  stayer)

	use temp_ciccio.dta, clear
	collapse(sum)  value if  flow=="IMP", by(vat year)
	fillin vat year
	xtset vat year
	gen pippo=l1.value
	gen check0=pippo+value
	egen pippa=max(check0), by (vat)
	gen stayer=0
	replace stayer=1 if pippa!=.
	drop pippa
	gen new=0
	gen check=0 
	replace check=1 if value!=. & value!=0 & year==2008 & pippo==.
	egen pippa=max(check), by (vat)
	replace new=2 if pippa==1
	drop pippa
	gen exit=0
	gen check2=0 
	replace check2=1 if value!=. & value!=0 & year==2007 & f1.value==.
	egen pippa=max(check2), by (vat)
	replace exit=3 if pippa==1
	drop  check2 pippa  check check0 _fillin pippo
	keep if year==2008
	gen count=1
	gen firm_type=stayer+exit+new
	collapse(sum)  value count, by(year  firm_type)




	********DECOMPOSITION: ALL COUNTRIES New, Exiters*********

	use temp_ciccio.dta, clear

	**Building margins
	sort year flow vat  land code 	
	gen byte firm_counter=0
	replace firm_counter=1 if vat[_n]!=vat[_n-1]
	gen byte country_counter=1
	replace country_counter=0 if land[_n]==land[_n-1] & vat[_n]==vat[_n-1]
	gen byte product_counter=1
	replace product_counter=0 if code[_n]==code[_n-1] & land[_n]==land[_n-1] & vat[_n]==vat[_n-1] 
	gen mix_quantity=units
	replace mix_quantity= weight if mix_quantity==0 
	replace weight=0 if units>0
	drop units
	save temp_smart.dta, replace

	**creating handful variables
	use temp_smart.dta, clear
	egen pippo=sum(value), by(vat year flow)
	egen step07=max(pippo)if year==2007, by (vat year flow) 
	egen firm_trade_2007=max(step07), by (vat flow)
	replace firm_trade_2007 = 0 if firm_trade_2007==.
	egen step08=max(pippo)if year==2008, by (vat year flow) 
	egen firm_trade_2008=max(step08), by (vat flow)
	replace firm_trade_2008 = 0 if firm_trade_2008==.
	save temp_smart.dta, replace

	*new
	use temp_smart.dta, clear
	keep if firm_trade_2007==0 & firm_trade_2008>0
	egen firms=sum(firm_counter), by (year flow)
	egen av_country=sum(country_counter/firms), by (year flow)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow)
	egen av_sales=mean(value), by (year flow)
	egen av_mix_q=mean(mix_quantity), by (year flow)
	egen av_mix_p=mean(value/av_mix_q), by (year flow)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year)


	*exiter
	use temp_smart.dta, clear
	keep if firm_trade_2007>0 & firm_trade_2008==0
	egen firms=sum(firm_counter), by (year flow)
	egen av_country=sum(country_counter/firms), by (year flow)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow)
	egen av_sales=mean(value), by (year flow)
	egen av_mix_q=mean(mix_quantity), by (year flow)
	egen av_mix_p=mean(value/av_mix_q), by (year flow)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year)



	*Mean and SD of imports and exports by exiters
	use temp_smart.dta, clear
	keep if firm_trade_2007>0 & firm_trade_2008==0
	keep if flow=="EXP"
	collapse(mean) firm_trade_2007, by(vat)
	su firm_trade_2007
	use temp_smart.dta, clear
	keep if firm_trade_2007>0 & firm_trade_2008==0
	keep if flow=="IMP"
	collapse(mean) firm_trade_2007, by(vat)
	su firm_trade_2007





	erase temp_ciccio.dta




**********2006-2007*******************


	use Data\ixd_1_trim_2006.dta, clear
	append using Data\ixd_2_trim_2006.dta
	append using Data\ixd_1_trim_2007.dta
	append using Data\ixd_2_trim_2007.dta
	gen byte EU=0
	replace EU=1 if flow=="II" | flow=="XI"
	replace flow="IMP" if flow=="II" | flow=="IE"
	replace flow="EXP" if flow=="XI" | flow=="XE"

	gen chow = 1 if  ///
		 	 nature == "1" | nature == "11" | nature == "12" | nature == "13" | nature == "14" | nature == "15" | nature == "16" | nature == "17" | ///
			 nature == "18" | nature == "19"  | ///
			 nature == "3" | nature == "31" | nature == "32" | nature == "33" | nature == "34" | nature == "35" | nature == "36" | nature == "37" | ///
			 nature == "38" | nature == "39"  | ///
			 nature == "7" | nature == "71" | nature == "72" | nature == "73" | nature == "74" | nature == "75" | nature == "76" | nature == "77" | ///
			 nature == "78" | nature == "79"  | ///
			 nature ==  "8" | nature ==  "81" | nature ==  "82" | nature ==  "83" | nature ==  "84" | nature ==  "85" | nature ==  "86" | ///
			 nature == "87" | nature ==  "88" | nature ==  "89"
	
	keep if chow == 1 
	drop chow
	drop if  land == "EU" |land == "II" | land == "BE" |land == "XX" | land == "QQ" | land == "QU" | land =="QX" |  land =="QY" |  land =="QZ" | land =="XN" |  land =="XU" |  land =="XV" |  land =="XW" |  land =="XS" |  land =="XR" |  land =="XQ" |  land =="XP" |  land =="XO" |  land =="XT"   
	


	***drop trade by non residents********

	sort vat year
	merge vat year using Data\Non_residents_year_2006.dta
	drop if _merge==2
	drop _merge
	gen keep=1
	replace keep=0 if resd!=""
	drop  resd

	sort vat year
	merge vat year using Data\Non_residents_year_2007.dta
	drop if _merge==2
	drop _merge
	replace keep=0 if resd!=""
	drop  resd
	keep if keep==1


	collapse (sum)  weight units value, by( year vat flow land code) 
	save temp_ciccio.dta, replace
	
	use temp_ciccio.dta, clear
	collapse(sum)  value if  flow=="EXP", by(vat year)
	xtset vat year
	gen pippo=l1.value
	egen pippa=max(pippo), by (vat)
	gen stayer=0
	replace stayer=1 if pippa!=.
	collapse(sum)  value, by(year  stayer)



	use temp_ciccio.dta, clear
	collapse(sum)  value if  flow=="EXP", by(vat year)
	fillin vat year
	xtset vat year
	gen pippo=l1.value
	gen check0=pippo+value
	egen pippa=max(check0), by (vat)
	gen stayer=0
	replace stayer=1 if pippa!=.
	drop pippa
	gen new=0
	gen check=0 
	replace check=1 if value!=. & value!=0 & year==2007 & pippo==.
	egen pippa=max(check), by (vat)
	replace new=2 if pippa==1
	drop pippa
	gen exit=0
	gen check2=0 
	replace check2=1 if value!=. & value!=0 & year==2006 & f1.value==.
	egen pippa=max(check2), by (vat)
	replace exit=3 if pippa==1
	drop  check2 pippa  check check0 _fillin pippo
	keep if year==2007
	gen count=1
	gen firm_type=stayer+exit+new
	collapse(sum)  value count, by(year  firm_type)


	use temp_ciccio.dta, clear
	collapse(sum)  value if  flow=="IMP", by(vat year)
	xtset vat year
	gen pippo=l1.value
	egen pippa=max(pippo), by (vat)
	gen stayer=0
	replace stayer=1 if pippa!=.
	collapse(sum)  value, by(year  stayer)

	use temp_ciccio.dta, clear
	collapse(sum)  value if  flow=="IMP", by(vat year)
	fillin vat year
	xtset vat year
	gen pippo=l1.value
	gen check0=pippo+value
	egen pippa=max(check0), by (vat)
	gen stayer=0
	replace stayer=1 if pippa!=.
	drop pippa
	gen new=0
	gen check=0 
	replace check=1 if value!=. & value!=0 & year==2007 & pippo==.
	egen pippa=max(check), by (vat)
	replace new=2 if pippa==1
	drop pippa
	gen exit=0
	gen check2=0 
	replace check2=1 if value!=. & value!=0 & year==2006 & f1.value==.
	egen pippa=max(check2), by (vat)
	replace exit=3 if pippa==1
	drop  check2 pippa  check check0 _fillin pippo
	keep if year==2007
	gen count=1
	gen firm_type=stayer+exit+new
	collapse(sum)  value count, by(year  firm_type)




	********DECOMPOSITION: ALL COUNTRIES New, Exiters*********

	use temp_ciccio.dta, clear

	**Building margins
	sort year flow vat  land code 	
	gen byte firm_counter=0
	replace firm_counter=1 if vat[_n]!=vat[_n-1]
	gen byte country_counter=1
	replace country_counter=0 if land[_n]==land[_n-1] & vat[_n]==vat[_n-1]
	gen byte product_counter=1
	replace product_counter=0 if code[_n]==code[_n-1] & land[_n]==land[_n-1] & vat[_n]==vat[_n-1] 
	gen mix_quantity=units
	replace mix_quantity= weight if mix_quantity==0 
	replace weight=0 if units>0
	drop units
	save temp_smart.dta, replace

	**creating handful variables
	use temp_smart.dta, clear
	egen pippo=sum(value), by(vat year flow)
	egen step06=max(pippo)if year==2006, by (vat year flow) 
	egen firm_trade_2006=max(step06), by (vat flow)
	replace firm_trade_2006 = 0 if firm_trade_2006==.
	egen step07=max(pippo)if year==2007, by (vat year flow) 
	egen firm_trade_2007=max(step07), by (vat flow)
	replace firm_trade_2007 = 0 if firm_trade_2007==.
	save temp_smart.dta, replace

	*new
	use temp_smart.dta, clear
	keep if firm_trade_2006==0 & firm_trade_2007>0
	egen firms=sum(firm_counter), by (year flow)
	egen av_country=sum(country_counter/firms), by (year flow)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow)
	egen av_sales=mean(value), by (year flow)
	egen av_mix_q=mean(mix_quantity), by (year flow)
	egen av_mix_p=mean(value/av_mix_q), by (year flow)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year)


	*exiter
	use temp_smart.dta, clear
	keep if firm_trade_2006>0 & firm_trade_2007==0
	egen firms=sum(firm_counter), by (year flow)
	egen av_country=sum(country_counter/firms), by (year flow)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow)
	egen av_sales=mean(value), by (year flow)
	egen av_mix_q=mean(mix_quantity), by (year flow)
	egen av_mix_p=mean(value/av_mix_q), by (year flow)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year)



	*stayers
	use temp_smart.dta, clear
	keep if firm_trade_2006>0 & firm_trade_2007>0
	egen firms=sum(firm_counter), by (year flow)
	egen av_country=sum(country_counter/firms), by (year flow)
	egen av_product=sum(product_counter/(firms*av_country)), by (year flow)
	egen av_sales=mean(value), by (year flow)
	egen av_mix_q=mean(mix_quantity), by (year flow)
	egen av_mix_p=mean(value/av_mix_q), by (year flow)
	replace weight=. if  weight==0
	egen av_weight_q=mean(weight), by (year flow)
	egen av_weight_p=mean(value/av_weight_q) if weight!=., by (year flow)

	collapse (mean) firms av_country av_product av_sales av_mix_q av_mix_p av_weight_q av_weight_p, by(flow year)





	erase temp_ciccio.dta






log close