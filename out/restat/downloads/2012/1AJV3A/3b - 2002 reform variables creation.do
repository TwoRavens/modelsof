use  "C:\Users\Michael McMahon\Dropbox\GSOEP21\work in progress\2002_panel.dta", clear

generate age02 = 2002 - age_y_02
sort hhnum02
keep if income02>=0
keep if age_y_02 > 1916

*PENSION VARIABLE
egen mean_temp = mean(worry_fin02)
generate worry_fin02_temp = worry_fin02
replace worry_fin02_temp = mean_temp if worry_fin02<0
sum worry_fin02_temp
drop mean_temp


/*INVERTS THIS RESPONSE AFTER CORRECTING FOR PENSIONERS WHO DON'T ANSWER THESE QUESTIONS PUTTING THEM DOWN AS NOT CONCERNED ABOUT PENSION REFORM*/

generate support_pen02_temp1 = support_pen02
replace support_pen02 = 0 if support_pen02_temp1==6
generate support_pen02_temp2 = support_pen02
replace support_pen02 = (6-support_pen02_temp2)
drop support_pen02_temp2 support_pen02_temp1

 /*CORRECTS FOR PENSIONERS WHO DON'T ANSWER THESE QUESTIONS AND PUTS THEM DOWN AS NOT CONCERNED ABOUT PENSION REFORM*/

generate concerned_privpen02_temp = concerned_privpen02
replace concerned_privpen02 = 5 if concerned_privpen02_temp<0 & support_pen02==6
drop concerned_privpen02_temp

generate contribute_morepriv02_temp = contribute_morepriv02
replace contribute_morepriv02=4 if contribute_morepriv02_temp<0 & support_pen02==6
drop contribute_morepriv02_temp

generate state_SS_important02_temp = state_SS_important02
replace state_SS_important02=5 if state_SS_important02_temp<0 & support_pen02==6
drop state_SS_important02_temp

*drop if concerned_privpen02<0
*drop if contribute_morepriv02<0
*drop if state_SS_important02<0
*drop if support_pen02<0

generate total_pen_reform = concerned_privpen02+contribute_morepriv02+state_SS_important02+support_pen02
sum total_pen_reform

generate pension_reform02 = ((20-(total_pen_reform))/2)
sum pension_reform02

gen retired02 = pension02

set matsize 800
replace  value_finass02= 0 if  value_finass02<0 
replace value_home02=0 if value_home02<0

generate wealth02 = (value_finass02 + value_home02 )/1000
generate wealth02_2 = (value_finass02 + value_home02 - debt_home02)/1000 

sort hhnum02

quietly tabulate occ_industry02, generate(industry)

replace industry1 = industry1+industry2
drop industry2

rename industry1 Industry_NA                                               
rename industry3 Industry_Agriculture
rename industry4 Industry_Energy
rename industry5 Industry_Mining
rename industry6 Industry_Manuf
rename industry7 Industry_Const
rename industry8 Industry_Trade
rename industry9 Industry_Trans
rename industry10 Industry_Bank 
rename industry11 Industry_Ser  

generate self_emp=1
replace self_emp=0 if self_emp02==-2

replace hours02=0 if hours02<0

quietly tabulate job02, generate(employment)

generate part_time = employment2 + employment4

rename employment9 ue

drop   employment1 employment2 employment3 employment4 employment5 employment6 employment7 employment8

replace retired02=0 if retired02!=1

quietly tabulate D_priv_pension, generate( D_priv_pension)
drop D_priv_pension D_priv_pension1 D_priv_pension3
rename D_priv_pension2 D_priv_pension

quietly tabulate  health_ins02, generate(health_ins02)
drop if  health_ins021==1
drop health_ins021
rename health_ins022 D_basic_health
rename health_ins023 D_priv_health
rename health_ins024 D_no_health

replace value_priv_policy=0 if  D_priv_pension==0

drop if hh_y_earn_02<=0 

gen agegrp02=75 if age02<=82
replace agegrp02=70 if age02>=68&age02<=72
replace agegrp02=65 if age02>=63&age02<=67
replace agegrp02=60 if age02>=58&age02<=62
replace agegrp02=55 if age02>=53&age02<=57
replace agegrp02=50 if age02>=48&age02<=52
replace agegrp02=45 if age02>=43&age02<=47
replace agegrp02=40 if age02>=38&age02<=42
replace agegrp02=35 if age02>=33&age02<=37
replace agegrp02=30 if age02>=28&age02<=32
replace agegrp02=25 if age02>=23&age02<=27
replace agegrp02=20 if age02<=22

drop  using_euro_dif convert_euro_dif euro_unity euro_econ_adv sad_dm disadv_increase invest_unstable euro_intro_sat g_income02 n_income02  g_pension02 g_comp_pens02 g_priv_pens02 g_dole02 g_early_retire02 loan_pay02 loan_paym02 web_own02 web02 microwave_own02 microwave02 dishwash_own02 dishwash02 washmach_own02 washmach02 tel_own02 tel02 mobile_own02 mobile02 fax_own02 isdn_own02 isdn02 cleaner02

sort new_hhnum

*save  "$path\GiavazziMcMahon\2002_panel.dta", replace
save  "C:\Users\Michael McMahon\Dropbox\GSOEP21\work in progess\2002_panel.dta", replace
