clear
set more off
cd C:\NBB\Projects\ECB\
qui cap log close

qui log using single_step_sem_07_09.log, replace


**********************building trade data 07-08*******************


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
	
	*******keeping only those transactins involving changes in ownerships*****
	keep if chow == 1 
	drop chow
	drop nature
	***********	


	**Eliminating some unuseful codes 
	
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


	collapse (sum)  weight units value (mean) EU, by( year vat flow land code)
	save single_step_07_08.dta, replace


**********************building trade data 08-09*******************

	use Data\ixd_1_trim_2008.dta, clear
	append using Data\ixd_2_trim_2008.dta
	append using Data\ixd_1_trim_2009.dta
	append using Data\ixd_2_trim_2009.dta
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
	
	*******keeping only those transactins involving changes in ownerships*****
	keep if chow == 1 
	drop chow
	drop nature
	***********	


	**Eliminating some unuseful codes 
	
	drop if  land == "EU" |land == "II" | land == "BE" |land == "XX" | land == "QQ" | land == "QU" | land =="QX" |  land =="QY" |  land =="QZ" | land =="XN" |  land =="XU" |  land =="XV" |  land =="XW" |  land =="XS" |  land =="XR" |  land =="XQ" |  land =="XP" |  land =="XO" |  land =="XT"   
		
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


	collapse (sum)  weight units value (mean) EU, by( year vat flow land code)
	save single_step_08_09.dta, replace



*********************************
******Now look at exports********
*********************************


use single_step_07_08.dta, clear
drop if year==2008
append using single_step_08_09.dta
keep if flow=="EXP"
gen HS4=substr(code, 1,4)
drop code
collapse (sum)  weight units value (mean) EU, by( year vat land HS4)
tostring  vat, generate (vat_string)
egen fake_ID=concat(vat_string land HS4)

preserve

collapse(mean)  value, by( fake_ID)
sort  fake_ID
gen pippo=1
gen fake_ID_number=sum( pippo)
keep  fake_ID fake_ID_number
sort fake_ID
save fake_ID.dta, replace

restore

sort fake_ID
merge fake_ID using fake_ID.dta
drop  vat_string fake_ID _merge

save single_step.dta, replace

****************************************************

use single_step.dta, clear
keep if year==2007

* Now add firm information 07-08

sort vat 
merge vat using Data\firm_data_07_08.dta
drop if _merge==2
drop _merge

save temp.dta, replace

use single_step.dta, clear
drop if year==2007

* Now add firm information 08-09

sort vat 
merge vat using Data\firm_data.dta
drop if _merge==2
drop _merge

append using temp.dta
erase temp.dta

* Now add country information

sort land
merge land using Data\OECD_2008.dta
drop if _merge==2
replace  oecd_2008=0 if  oecd_2008==.
drop _merge
replace oecd_2008=0 if EU==1
rename oecd_2008 oecd_2008_no_EU
rename land iso2
sort iso2
merge iso2 using  C:\NBB\Projects\ECB\Data\Exchange_rate_change_new.dta
drop if _merge==2
drop _merge
sort iso2
merge iso2 using C:\NBB\Projects\ECB\Data\GDP_const_price_g_rate.dta
drop if _merge==2
drop _merge
gen growth_rate_X=.
replace growth_rate_X=(growth_rate_08+growth_rate_07)/2 if year==2007
replace growth_rate_X=(growth_rate_09+growth_rate_08)/2 if year==2008
gen ex_rate_change=.
replace ex_rate_change=change2 if year==2007
replace ex_rate_change=change3 if year==2008

* Now add product information

rename HS4  CN4_2008
sort   CN4_2008
merge  CN4_2008 using Data\cn_2008_cpa_2002.dta
drop if _merge==2
replace Other=1 if _merge==1
recode Intermediate Capital_goods Consumer_dur Consumer_n_dur Energy (.=0) if _merge==1
drop _merge

rename  CN4_2008 HS4
sort HS4
merge HS4 using "C:\NBB\Projects\ECB\Data\Contractibility_HS4.dta",
drop if _merge==2
drop _merge
su

drop change1 change2 change3 growth_rate_07 growth_rate_08 growth_rate_09 weight units CPA3_2002 CPA2_2002  frac_con_diff_orig frac_con_not_homog_orig

recode r* for mne   oecd_2008_no_EU EU Intermediate Capital_goods Consumer_dur Consumer_n_dur Energy Other  frac_lib_diff_orig frac_lib_not_homog_orig( 0=.) if year==2009
recode r* for mne   oecd_2008_no_EU EU Intermediate Capital_goods Consumer_dur Consumer_n_dur Energy Other  frac_lib_diff_orig frac_lib_not_homog_orig( 1=.) if year==2009
replace nace2=. if year==2009

save single_step_estim.dta, replace

****************************

use single_step_estim.dta, clear

* Now add industry dummies

xi i.nace2, pre(nace)
gen  nacenace2_1=0
replace  nacenace2_1=1 if nace2==1
drop nacenace2_34
*we take automobile as reference

xtset  fake_ID_number year

gen pippo=log(f1.value)-log(value)
*pippo is the log change in "continuing transactions" values, i.e. triplets of firm-country-HS4 product trade that are registed in both 2008 and 2009


*Has the decrease be equal across continuing transactions of different size?
su pippo if year==2007, de 
su pippo if year==2008, de 
*as one can see the mean and median drop are lower than the aggregate drop indicating that bigger transactions have reduced more. We need robustness with WLS



gen pippi=0
replace pippi=1 if (r_size + r_prod + r_interm_share + r_share_exp_sales + r_share_imp_interm + r_value_add_chain +  r_ext_fin_dep + r_share_debts_o_passive + r_share_debts_due_after_one + r_share_fin_debt + r_share_stock + for + mne + oecd_2008 + EU +  ex_rate_change + growth_rate_X+ nace2+frac_lib_diff_orig ) != .


gen no_EU_no_OECD=.
replace no_EU_no_OECD=1 if EU==0 & oecd_2008==0
replace no_EU_no_OECD=0 if EU==1 | oecd_2008==1

gen crisis=.
replace crisis=0 if year==2007
replace crisis=1 if year==2008

generate is_nace2=nace2*crisis

generate i_r_size=r_size*crisis
generate i_r_prod=r_prod*crisis
generate i_r_interm_share=r_interm_share*crisis
generate i_r_share_exp_sales=r_share_exp_sales*crisis
generate i_r_share_imp_interm=r_share_imp_interm*crisis
generate i_r_value_add_chain=r_value_add_chain*crisis
generate i_r_ext_fin_dep=r_ext_fin_dep*crisis
generate i_r_share_debts_o_passive=r_share_debts_o_passive*crisis
generate i_r_share_debts_due_after_one=r_share_debts_due_after_one*crisis
generate i_r_share_fin_debt=r_share_fin_debt*crisis
generate i_r_share_stock=r_share_stock*crisis
generate i_for=for*crisis
generate i_mne=mne*crisis
generate i_oecd_2008=oecd_2008*crisis
generate i_no_EU_no_OECD=no_EU_no_OECD*crisis
generate i_ex_rate_change=ex_rate_change*crisis
generate i_growth_rate_X=growth_rate_X*crisis
generate i_Intermediate=Intermediate*crisis
generate i_Capital_goods=Capital_goods*crisis
generate i_Consumer_dur=Consumer_dur*crisis
generate i_Energy=Energy*crisis
generate i_Other=Other*crisis
generate i_frac_lib_diff_orig=frac_lib_diff_orig*crisis


xi i.is_nace2, pre(is_n)
drop  is_nis_nace_34
*we take automobile as reference

gen peso=log(value+1) if pippo!=.


local instruct "tex tdec(4) rdec(4) auto(4) bdec (4) symbol($^a$,$^b$,$^c$)  se"
local firm_var " r_size r_prod  r_interm_share  r_share_exp_sales  r_share_imp_interm r_value_add_chain r_ext_fin_dep r_share_debts_o_passive r_share_debts_due_after_one r_share_fin_debt r_share_stock for mne"
local prod_var " Intermediate Capital_goods Consumer_dur  Energy Other  frac_lib_diff_orig "
local country_var " oecd_2008 no_EU_no_OECD  ex_rate_change growth_rate_X "
local inter "i_*"
local dummies "  nacenace2_*  is_nis_nace_*"


****vat clustering with nace dummies****

*OLS
xi: reg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies', cluster(vat)
outreg2 `firm_var' `country_var' `prod_var' `inter' `dummies' using Results/table_DD_cluster.xls,ctitle(exports OLS vat clu)  `instruct' replace

*WLS
xi: reg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies' [pweight=(peso)], cluster(vat)
outreg2 `firm_var' `country_var' `prod_var' `inter' `dummies' using Results/table_DD_cluster.xls,ctitle(exports WLS vat clu)  `instruct' append

****3 level clustering with nace dummies****

*OLS
xi: cgmreg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies', cluster(vat iso2 HS4)
outreg2 `firm_var' `country_var' `prod_var' `inter' `dummies' using Results/table_DD_cluster.xls,ctitle(exports OLS ML clu)  `instruct' append

*WLS. There is a problem with the cgmreg code with WLS
*xi: cgmreg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies' [pweight=(peso)], cluster(vat iso2 HS4)
*outreg2 `firm_var' `country_var' `prod_var' `inter' `dummies' using Results/table_DD_cluster.xls,ctitle(exports WLS ML clu)  `instruct' append



**********************
*Counterfactuals
**********************

***i_r_share_imp_interm***
predict xb_true,xb

gen i_r_share_imp_interm_true=i_r_share_imp_interm
replace i_r_share_imp_interm=0
predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.2202947/-.1795196))
*-22.713453% of the fall

replace i_r_share_imp_interm=i_r_share_imp_interm_true
drop i_r_share_imp_interm_true xb_true xb_counter 


***  i_r_share_debts_due_after_one i_r_share_fin_debt***
predict xb_true,xb

gen i_r_share_debts_due_after_one_t=i_r_share_debts_due_after_one
replace i_r_share_debts_due_after_one=1
gen i_r_share_fin_debt_t=i_r_share_fin_debt
replace i_r_share_fin_debt=0

predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.1201698/-.1795196))
*33.060345 of the fall

replace i_r_share_debts_due_after_one=i_r_share_debts_due_after_one_t
replace i_r_share_fin_debt=i_r_share_fin_debt_t
drop i_r_share_fin_debt_t i_r_share_debts_due_after_one_t xb_true xb_counter 



***   i_oecd_2008 i_no_EU_no_OECD ***
predict xb_true,xb

gen i_oecd_2008_t=i_oecd_2008
replace i_oecd_2008=0
gen i_no_EU_no_OECD_t=i_no_EU_no_OECD
replace i_no_EU_no_OECD=0

predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.2169731/-.1795196))
*-20.863182 of the fall

replace i_oecd_2008=i_oecd_2008_t
replace i_no_EU_no_OECD=i_no_EU_no_OECD_t
drop i_no_EU_no_OECD_t i_oecd_2008_t xb_true xb_counter 


***i_ex_rate_change   ex_rate_change***

predict xb_true,xb

gen i_ex_rate_change_t=i_ex_rate_change
replace i_ex_rate_change=0
gen ex_rate_change_t=ex_rate_change
replace ex_rate_change=0

predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.1688927/-.1795196))
*5.919632 of the fall

replace i_ex_rate_change=i_ex_rate_change_t
replace ex_rate_change=ex_rate_change_t
drop i_ex_rate_change_t ex_rate_change_t xb_true xb_counter 


*** i_growth_rate_X    growth_rate_X***

predict xb_true,xb

gen i_growth_rate_X_t=i_growth_rate_X
gen growth_rate_X_t=growth_rate_X

egen temp1=min( growth_rate_X)  if year==2007, by( iso2)
egen temp2=min( temp1)  if year!=2009, by( iso2)

replace growth_rate_X=temp2 if year==2008
replace i_growth_rate_X=temp2 if year==2008
*replace i_growth_rate_X=0 if year==2008
*with this the change is small


predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.0823059/-.1795196))
*54.152137 of the fall

replace i_growth_rate_X=i_growth_rate_X_t
replace growth_rate_X=growth_rate_X_t
drop i_growth_rate_X_t growth_rate_X_t xb_true xb_counter temp1 temp2


*** i_Intermediate i_Capital_goods i_Consumer_dur i_Energy ***
predict xb_true,xb

gen i_Intermediate_t=i_Intermediate
replace i_Intermediate=0
gen i_Capital_goods_t=i_Capital_goods
replace i_Capital_goods=0
gen i_Consumer_dur_t=i_Consumer_dur
replace i_Consumer_dur=0
gen i_Energy_t=i_Energy
replace i_Energy=0

predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.140267/-.1795196))
*21.865356 of the fall

replace i_Intermediate=i_Intermediate_t
replace i_Capital_goods=i_Capital_goods_t
replace i_Consumer_dur=i_Consumer_dur_t
replace i_Energy=i_Energy_t

drop i_Intermediate_t i_Capital_goods_t i_Consumer_dur_t i_Energy_t xb_true xb_counter 

*** i_frac_lib_diff_orig ***
predict xb_true,xb

gen i_frac_lib_diff_orig_t=i_frac_lib_diff_orig
replace i_frac_lib_diff_orig=0

predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.2180647/-.1795196))
*-21.471249 of the fall

replace i_frac_lib_diff_orig=i_frac_lib_diff_orig_t

drop i_frac_lib_diff_orig_t xb_true xb_counter 


***Distribution***

xi: cgmreg  pippo crisis `firm_var' `country_var' `prod_var' `inter' if pippi==1 & (nace2==50 | nace2==51 | nace2==52), cluster(vat iso2 HS4)
*no result for share of stock


****focus on each product category and look at differences between GDP growth coefficients with nace dummies


xi: reg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies' if  Consumer_n_dur==1, cluster(vat)
*growth_rat~X |    .021281   .0051277     4.15   0.000     .0112271    .0313348
*i_growth_r~X |    .002151   .0065249     0.33   0.742    -.0106424    .0149443
xi: reg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies' if  Intermediate==1, cluster(vat)
*growth_rat~X |   .0098512   .0046794     2.11   0.035     .0006773    .0190252
*i_growth_r~X |   .0156115   .0055266     2.82   0.005     .0047767    .0264462
xi: reg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies' if  Capital_goods==1, cluster(vat)
*growth_rat~X |     .00994   .0073258     1.36   0.175    -.0044245    .0243044
*i_growth_r~X |   .0185784   .0098251     1.89   0.059    -.0006867    .0378436
xi: reg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies' if  Consumer_dur==1, cluster(vat)
*growth_rat~X |   .0273198   .0147189     1.86   0.064    -.0015638    .0562033
*i_growth_r~X |   .0126849   .0178053     0.71   0.476    -.0222552     .047625
xi: reg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies' if  Energy==1, cluster(vat)
*growth_rat~X |   .0185012   .0150148     1.23   0.219    -.0110481    .0480505
*i_growth_r~X |  -.0033592    .024382    -0.14   0.891    -.0513433    .0446249
xi: reg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies' if  Other==1, cluster(vat)
*growth_rat~X |   .0213271   .0128963     1.65   0.098    -.0039668     .046621
*i_growth_r~X |   -.004771   .0153163    -0.31   0.755    -.0348114    .0252693




*Non linearities in GDP growth
gen growth_rate_X2=growth_rate_X^2
gen growth_rate_X3=growth_rate_X^3

gen i_growth_rate_X2=i_growth_rate_X^2
gen i_growth_rate_X3=i_growth_rate_X^3

local instruct "tex tdec(4) rdec(4) auto(4) bdec (4) symbol($^a$,$^b$,$^c$)  se"
local firm_var " r_size r_prod  r_interm_share  r_share_exp_sales  r_share_imp_interm r_value_add_chain r_ext_fin_dep r_share_debts_o_passive r_share_debts_due_after_one r_share_fin_debt r_share_stock for mne"
local prod_var " Intermediate Capital_goods Consumer_dur  Energy Other  frac_lib_diff_orig "
local country_var " oecd_2008 no_EU_no_OECD  ex_rate_change growth_rate_X growth_rate_X2 growth_rate_X3"
local inter "i_*"
local dummies "  nacenace2_*  is_nis_nace_*"


xi: reg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies', cluster(vat)

/*
growth_rat~X |  -.0029079   .0121735    -0.24   0.811    -.0267713    .0209555
growth_rat~2 |   .0041407    .002098     1.97   0.048      .000028    .0082534
growth_rat~3 |  -.0002329   .0000994    -2.34   0.019    -.0004277   -.0000381

i_growth_r~X |   .0244395   .0122999     1.99   0.047     .0003283    .0485506
i_growth_r~2 |    -.00545   .0021297    -2.56   0.011    -.0096248   -.0012751
i_growth_r~3 |   .0002622   .0001081     2.43   0.015     .0000503    .0004741

*fai un grafico della funzione di export growth su gdp growth prima e dopo la crisi (plot semplice dopo aver fatto predict a aggregato all dimensione paese-year)
. su  growth_rate_X if year==2007
    Variable |       Obs        Mean    Std. Dev.       Min        Max
-------------+--------------------------------------------------------
growth_rat~X |    390373    3.054759    2.301804    -10.485    17.5065
. su  growth_rate_X if year==2008

    Variable |       Obs        Mean    Std. Dev.       Min        Max
-------------+--------------------------------------------------------
growth_rat~X |    426847   -.6293851    2.874101   -11.2955     13.931
*/

drop if year==2009
collapse (mean) growth_rate_X, by(iso2 year) 
gen exp_growth_07_08= (growth_rate_X)*-.0029079+ (growth_rate_X^2)*.0041407 + (growth_rate_X^3)*-.0002329
gen exp_growth_08_09=exp_growth_07_08+(growth_rate_X)*.0244395 + (growth_rate_X^2)*-.00545+ (growth_rate_X^3)*.0002622
drop if  growth_rate_X<-8 & year==2007



*********************************
******Now look at imports********
*********************************


use single_step_07_08.dta, clear
drop if year==2008
append using single_step_08_09.dta
keep if flow=="IMP"
gen HS4=substr(code, 1,4)
drop code
collapse (sum)  weight units value (mean) EU, by( year vat land HS4)
tostring  vat, generate (vat_string)
egen fake_ID=concat(vat_string land HS4)

preserve

collapse(mean)  value, by( fake_ID)
sort  fake_ID
gen pippo=1
gen fake_ID_number=sum( pippo)
keep  fake_ID fake_ID_number
sort fake_ID
save fake_ID.dta, replace

restore

sort fake_ID
merge fake_ID using fake_ID.dta
drop  vat_string fake_ID _merge

save single_step.dta, replace

****************************************************

use single_step.dta, clear
keep if year==2007

* Now add firm information 07-08

sort vat 
merge vat using Data\firm_data_07_08.dta
drop if _merge==2
drop _merge

save temp.dta, replace

use single_step.dta, clear
drop if year==2007

* Now add firm information 08-09

sort vat 
merge vat using Data\firm_data.dta
drop if _merge==2
drop _merge

append using temp.dta
erase temp.dta

* Now add country information

sort land
merge land using Data\OECD_2008.dta
drop if _merge==2
replace  oecd_2008=0 if  oecd_2008==.
drop _merge
replace oecd_2008=0 if EU==1
rename oecd_2008 oecd_2008_no_EU
rename land iso2
sort iso2
merge iso2 using  C:\NBB\Projects\ECB\Data\Exchange_rate_change_new.dta
drop if _merge==2
drop _merge
sort iso2
merge iso2 using C:\NBB\Projects\ECB\Data\GDP_const_price_g_rate.dta
drop if _merge==2
drop _merge
gen growth_rate_X=.
replace growth_rate_X=(growth_rate_08+growth_rate_07)/2 if year==2007
replace growth_rate_X=(growth_rate_09+growth_rate_08)/2 if year==2008
gen ex_rate_change=.
replace ex_rate_change=change2 if year==2007
replace ex_rate_change=change3 if year==2008


* Now add product information

rename HS4  CN4_2008
sort   CN4_2008
merge  CN4_2008 using Data\cn_2008_cpa_2002.dta
drop if _merge==2
replace Other=1 if _merge==1
recode Intermediate Capital_goods Consumer_dur Consumer_n_dur Energy (.=0) if _merge==1
drop _merge

rename  CN4_2008 HS4
sort HS4
merge HS4 using "C:\NBB\Projects\ECB\Data\Contractibility_HS4.dta",
drop if _merge==2
drop _merge
su

drop change1 change2 change3 growth_rate_07 growth_rate_08 growth_rate_09 weight units CPA3_2002 CPA2_2002  frac_con_diff_orig frac_con_not_homog_orig

recode r* for mne   oecd_2008_no_EU EU Intermediate Capital_goods Consumer_dur Consumer_n_dur Energy Other  frac_lib_diff_orig frac_lib_not_homog_orig( 0=.) if year==2009
recode r* for mne   oecd_2008_no_EU EU Intermediate Capital_goods Consumer_dur Consumer_n_dur Energy Other  frac_lib_diff_orig frac_lib_not_homog_orig( 1=.) if year==2009
replace nace2=. if year==2009

save single_step_estim.dta, replace

****************************

use single_step_estim.dta, clear

* Now add industry dummies

xi i.nace2, pre(nace)
gen  nacenace2_1=0
replace  nacenace2_1=1 if nace2==1
drop nacenace2_34
*we take automobile as reference

xtset  fake_ID_number year

gen pippo=log(f1.value)-log(value)
*pippo is the log change in "continuing transactions" values, i.e. triplets of firm-country-HS4 product trade that are registed in both 2008 and 2009


*Has the decrease be equal across continuing transactions of different size?
su pippo if year==2007, de 
su pippo if year==2008, de 
*as one can see the mean and median drop are lower than the aggregate drop indicating that bigger transactions have reduced more. We need robustness with WLS



gen pippi=0
replace pippi=1 if (r_size + r_prod + r_interm_share + r_share_exp_sales + r_share_imp_interm + r_value_add_chain +  r_ext_fin_dep + r_share_debts_o_passive + r_share_debts_due_after_one + r_share_fin_debt + r_share_stock + for + mne + oecd_2008 + EU +  ex_rate_change + growth_rate_X+ nace2+frac_lib_diff_orig ) != .


gen no_EU_no_OECD=.
replace no_EU_no_OECD=1 if EU==0 & oecd_2008==0
replace no_EU_no_OECD=0 if EU==1 | oecd_2008==1

gen crisis=.
replace crisis=0 if year==2007
replace crisis=1 if year==2008

generate is_nace2=nace2*crisis

generate i_r_size=r_size*crisis
generate i_r_prod=r_prod*crisis
generate i_r_interm_share=r_interm_share*crisis
generate i_r_share_exp_sales=r_share_exp_sales*crisis
generate i_r_share_imp_interm=r_share_imp_interm*crisis
generate i_r_value_add_chain=r_value_add_chain*crisis
generate i_r_ext_fin_dep=r_ext_fin_dep*crisis
generate i_r_share_debts_o_passive=r_share_debts_o_passive*crisis
generate i_r_share_debts_due_after_one=r_share_debts_due_after_one*crisis
generate i_r_share_fin_debt=r_share_fin_debt*crisis
generate i_r_share_stock=r_share_stock*crisis
generate i_for=for*crisis
generate i_mne=mne*crisis
generate i_oecd_2008=oecd_2008*crisis
generate i_no_EU_no_OECD=no_EU_no_OECD*crisis
generate i_ex_rate_change=ex_rate_change*crisis
generate i_growth_rate_X=growth_rate_X*crisis
generate i_Intermediate=Intermediate*crisis
generate i_Capital_goods=Capital_goods*crisis
generate i_Consumer_dur=Consumer_dur*crisis
generate i_Energy=Energy*crisis
generate i_Other=Other*crisis
generate i_frac_lib_diff_orig=frac_lib_diff_orig*crisis


xi i.is_nace2, pre(is_n)
drop  is_nis_nace_34
*we take automobile as reference

gen peso=log(value+1) if pippo!=.

local instruct "tex tdec(4) rdec(4) auto(4) bdec (4) symbol($^a$,$^b$,$^c$)  se"
local firm_var " r_size r_prod  r_interm_share  r_share_exp_sales  r_share_imp_interm r_value_add_chain r_ext_fin_dep r_share_debts_o_passive r_share_debts_due_after_one r_share_fin_debt r_share_stock for mne"
local prod_var " Intermediate Capital_goods Consumer_dur  Energy Other  frac_lib_diff_orig "
local country_var " oecd_2008 no_EU_no_OECD  ex_rate_change growth_rate_X "
local inter "i_*"
local dummies "  nacenace2_*  is_nis_nace_*"


****vat clustering with nace dummies****

*OLS
xi: reg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies', cluster(vat)
outreg2 `firm_var' `country_var' `prod_var' `inter' `dummies' using Results/table_DD_cluster.xls,ctitle(imports OLS vat clu)  `instruct' append

*WLS
xi: reg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies' [pweight=(peso)], cluster(vat)
outreg2 `firm_var' `country_var' `prod_var' `inter' `dummies' using Results/table_DD_cluster.xls,ctitle(imports WLS vat clu)  `instruct' append

****3 level clustering with nace dummies****

*OLS
xi: cgmreg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies', cluster(vat iso2 HS4)
outreg2 `firm_var' `country_var' `prod_var' `inter' `dummies' using Results/table_DD_cluster.xls,ctitle(imports OLS ML clu)  `instruct' append

*WLS. There is a problem with the cgmreg code with WLS
*xi: cgmreg  pippo crisis `firm_var' `country_var' `prod_var' `inter' `dummies' [pweight=(peso)], cluster(vat iso2 HS4)
*outreg2 `firm_var' `country_var' `prod_var' `inter' `dummies' using Results/table_DD_cluster.xls,ctitle(imports WLS ML clu)  `instruct' append


**********************
*Counterfactuals
**********************

*** i_r_prod***
predict xb_true,xb

gen i_r_prod_t=i_r_prod
replace i_r_prod=0
predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.1396351/-.1637702))
*14.737174% of the fall

replace i_r_prod=i_r_prod_t
drop i_r_prod_t xb_true xb_counter 


***i_r_interm_share i_r_share_exp_sales***
predict xb_true,xb

gen i_r_interm_share_t=i_r_interm_share
replace i_r_interm_share=0
gen i_r_share_exp_sales_t=i_r_share_exp_sales
replace i_r_share_exp_sales=0

predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.1247307/-.1637702))
*23.837975 of the fall

replace i_r_interm_share=i_r_interm_share_t
replace i_r_share_exp_sales=i_r_share_exp_sales_t
drop i_r_interm_share_t i_r_share_exp_sales_t xb_true xb_counter 



***   i_oecd_2008 i_no_EU_no_OECD ***
predict xb_true,xb

gen i_oecd_2008_t=i_oecd_2008
replace i_oecd_2008=0
gen i_no_EU_no_OECD_t=i_no_EU_no_OECD
replace i_no_EU_no_OECD=0

predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.2264506/-.1637702))
*-38.273386 of the fall

replace i_oecd_2008=i_oecd_2008_t
replace i_no_EU_no_OECD=i_no_EU_no_OECD_t
drop i_no_EU_no_OECD_t i_oecd_2008_t xb_true xb_counter 


***i_ex_rate_change   ex_rate_change***

predict xb_true,xb

gen i_ex_rate_change_t=i_ex_rate_change
replace i_ex_rate_change=0
gen ex_rate_change_t=ex_rate_change
replace ex_rate_change=0

predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.1637951/-.1637702))
*-0.15204 of the fall

replace i_ex_rate_change=i_ex_rate_change_t
replace ex_rate_change=ex_rate_change_t
drop i_ex_rate_change_t ex_rate_change_t xb_true xb_counter 


*** i_growth_rate_X    growth_rate_X***

predict xb_true,xb

* growth_rate_X is -1.1065% for BE in 2008 and 1.784% in 2007= difference is 2.8905%
* the overall coeff of growth_rate_X from the exp regression in 2008 is 0.0138+0.0115=0.0253 

gen xb_counter=xb_true+(0.0253*2.8905)

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.0906405/-.1637702))
*44.65385 of the fall

drop xb_true xb_counter


*** i_Intermediate i_Consumer_dur ***
predict xb_true,xb

gen i_Intermediate_t=i_Intermediate
replace i_Intermediate=0
gen i_Consumer_dur_t=i_Consumer_dur
replace i_Consumer_dur=0

predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.1458304/-.1637702))
*10.954252 of the fall

replace i_Intermediate=i_Intermediate_t
replace i_Consumer_dur=i_Consumer_dur_t

drop i_Intermediate_t i_Consumer_dur_t xb_true xb_counter 


*** i_frac_lib_diff_orig ***
predict xb_true,xb

gen i_frac_lib_diff_orig_t=i_frac_lib_diff_orig
replace i_frac_lib_diff_orig=0

predict xb_counter,xb

su  xb_true if year==2008 & pippo!=., de
su xb_counter if year==2008 & pippo!=., de
display(1-(-.2019691/-.1637702))
*-23.324695 of the fall

replace i_frac_lib_diff_orig=i_frac_lib_diff_orig_t

drop i_frac_lib_diff_orig_t xb_true xb_counter 


***Distribution***

*3 level clustering for Distribution only
xi: cgmreg  pippo crisis `firm_var' `country_var' `prod_var' `inter' if pippi==1 & (nace2==50 | nace2==51 | nace2==52), cluster(vat iso2 HS4)


***i_r_share_stock****
*the coeff is: i_r_share_~k |   -.032301   .0191251    -1.69   0.091    -.0697855    .0051835


predict xb_true,xb
gen  i_r_share_stock_t= i_r_share_stock
replace i_r_share_stock=0

predict xb_counter,xb

su xb_true if pippi==1 & (nace2==50 | nace2==51 | nace2==52) & year==2008 & pippo!=., de
su xb_counter if pippi==1 & (nace2==50 | nace2==51 | nace2==52) & year==2008 & pippo!=., de

display(1-(-.1119278/-.1269083))
*11.804192%

replace i_r_share_stock=i_r_share_stock_t
drop  i_r_share_stock_t xb_true xb_counter 

egen imp_tot_2008=sum(value) if  pippi==1 & year==2008
egen imp_tot_2008_distr=sum(value) if pippi==1 & (nace2==50 | nace2==51 | nace2==52) & year==2008
egen imp_tot_2009_distr=sum(value) if l1.pippi==1 & (l1.nace2==50 | l1.nace2==51 | l1.nace2==52) & year==2009

su  imp_tot_2008 imp_tot_2008_distr imp_tot_2009
display(3.18e+10/7.90e+10)
*40.25 of imports are done by the distribution sector

display(1-(2.38e+10/3.18e+10))
*The distribution sector experience a reduction of trade of 25.157233\%


log close