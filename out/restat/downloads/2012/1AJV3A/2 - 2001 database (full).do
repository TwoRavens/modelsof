/*Open log file, set memory, etc*/
set logtype text
set more off
clear all 
set mem 50m
/*log using "$datapath\GiavazziMcMahonReStat\2001 database.smcl", replace*/

/* THIS SECTION DOWNLOADS THE HOUSEHOLD DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr hhnrakt welle rhhmonin rausku  rh4301 rh4302 rh4303 rh4304 rh04 rh06 rh12 rh13 rh15 rh17 rh2501 rh2502 rh26 rh2801 rh40 rh41 rh4201 rh4202 rh4301 rh4302 rh4303 rh4304 rh4305 rh4306 rh4307 rh4501 rh4505 rh4602 rh4604 rh4607 rh4610 rh49 rh5001 rh5002 rh5101 rh5102 rh5202 rh5301 rh5305 rh5317 rh5321 rh54 using "$datapath\rh.dta"

sort hhnr

describe

rename rhhmonin int_month01
rename hhnr hhnum
rename hhnrakt new_hhnum01
rename welle year
rename rausku respondant
rename rh04 h_change01
rename rh06 tenant01
rename rh12 hse_area01
rename rh13 hse_age01
rename rh15 hse_size01
rename rh17 hse_condition01
rename rh2501 m_rent01 
rename rh2502 norent01
rename rh26 heat_rent01
rename rh2801 other_rent01
rename rh40 prop_rent01
rename rh41 prop2_rent01
rename rh4201 prop_costs01
rename rh4202 prop_mort01
rename rh4301 save_ac01
rename rh4302 save_bs01
rename rh4303 save_la01
rename rh4304 save_fi01
rename rh4305 save_Oth01
rename rh4306 save_comp01
rename rh4307 save_none01
rename rh4501 win01
rename rh4505 win_amt01
rename rh4602 child_allow01
rename rh4604 house_allow01
rename rh4607 sick_allow01
rename rh4610 social_allow01
rename rh49 income01
rename rh5001 loan_pay01
rename rh5002 loan_paym01
rename rh5101 save01
rename rh5102 save_amt01
rename rh5202 food_conm01
rename rh5301 tv01
rename rh5305 car01
rename rh5317 hol01
rename rh5321 meat01
rename rh54 cleaner01

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum01=hhnum
replace hhnum01=new_hhnum01 if new_hhnum01~=hhnum

sort hhnum01

save "$datapath\GiavazziMcMahonReStat\2001h.dta", replace

clear all
********************************************************************************************************************

/* USING GENERATED VARIABLES*/

use hhnr persnr rhhnr oeffd01 nation01 lfs01 stib01 month01 autono01 using "$datapath\rpgen.dta"

rename hhnr hhnum
rename persnr pnum
rename rhhnr new_hhnum01

rename  oeffd01 CS_01
rename nation01 nationality01
rename lfs01 lab_force01
rename stib01 occupation_01

generate hhnum01=hhnum
replace hhnum01=new_hhnum01 if new_hhnum01~=hhnum

sort hhnum01

save "$datapath\GiavazziMcMahonReStat\2001 gen.dta", replace

clear all
******************************************************************************
/* THIS SECTION DOWNLOADS THE HOUSEHOLD WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use  hhnr hhnrakt rhhrf using "$datapath\hhrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename hhnrakt new_hhnum01
rename rhhrf h_weight01

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum01=hhnum
replace hhnum01=new_hhnum01 if new_hhnum01~=hhnum

sort hhnum01

save "$datapath\GiavazziMcMahonReStat\2001h weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSONAL DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use  hhnr persnr sample1 welle rhhnr rp0101 rp0102 rp0103 rp0104  rp63   rp64   rp65 rp0105 rp0106 rp0107 rp0108 rp0109 rp0110 rp09 rp12 rp0201 rp0202 rp0203 rp0204 rp0205 rp0206 rp0207 rp0208 rp0209 rp0210 rp0211 rp0212 rp0213 rp0214 rp0215 rp0216 rp0217 rp0218 rp0219 rp0220 rp0221 rp0222 rp0223 rp0224 rp4801 rp50 rp5701 rp5702 rp5802 rp5808 rp5805 rp6602 rp6603 rp6604 rp6607 rp6608 rp6615 rp6616 rp6801 rp6802 rp6803 rp7901 rp7902 rp7903 rp7904 rp7905 rp7906 rp7907 rp7908 rp7909 rp7910 rp7911 rp7912 rp7913 rp7914 rp7915 rp7916 rp7917 rp7918 rp80 rp83 rp8401 rp9102 rp95 rp96 rp9801 rp99 rp10302 rp108 rp108a01 rp108a02 rp108a03 rp108a04 rp108a05 rp108a06 rp108a07 rp108a08 rp108b01 rp108b02 rp108b03 rp108b04 rp108b05 rp108b06 rp108b07 rp108b08 rp108c01 rp108c02 rp108c03 rp108c04 rp108c05 rp108c06 rp108c07 rp108c08 rp10901 rp10902 rp11401 rp11402 rp11403 rp11404 rp11405 rp11406 rp11407 rp11408 rp11409 rp11410 rp11411 rp13414 rp13407 rp13408 rp13421 rp13002  rp4005 rp126	rp12701 rp12702 rp12703  rp0222	rp0309	rp0308	rp0303	rp0302	rp0301		rp0201	rp0204	rp0207	rp0210	rp0219  using "$datapath\rp.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename sample1 respondant1
rename welle year
rename rhhnr new_hhnum01
rename rp0101 sat_health01
rename rp0102 sat_work01
rename rp0103 sat_hsework01
rename rp0104 sat_hh01
rename rp0105 sat_hse01
rename rp0106 sat_leisure01
rename rp0107 sat_childcare01
rename rp0108 sat_goods01
rename rp0109 sat_environ01
rename rp0110 sat_living01
rename rp09 ue01
rename rp12 job01
rename rp4801 jobkm01
rename rp50 hours01
rename rp5701 g_income01
rename rp5702 n_income01
rename rp5802 lose_job01
rename rp5808 retire01
rename rp5805 career01
rename rp6602 g_income2_01
rename rp6603 pension01
rename rp6604 g_pension01
rename rp6607 dole01
rename rp6608 g_dole01
rename rp6615 early_retire01
rename rp6616 g_early_retire01
rename rp6801 education01
rename rp6802 educ_school01
rename rp6803 educ_college01
rename rp7901 wkr_pension_amt01
rename rp7902 miner_pension_amt01
rename rp7903 civil_pension_amt01
rename rp7904 war_pension_amt01
rename rp7905 farmer_pension_amt01
rename rp7906 acc_pension_amt01
rename rp7907 civils_pension_amt01
rename rp7908 comp_pension_amt01
rename rp7909 other_pension_amt01
rename rp7910 wkr_pension2_amt01
rename rp7911 miner_pension2_amt01
rename rp7912 civil_pension2_amt01
rename rp7913 war_pension2_amt01
rename rp7914 farmer_pension2_amt01
rename rp7915 acc_pension2_amt01
rename rp7916 civils_pension2_amt01
rename rp7917 comp_pension2_amt01
rename rp7918 other_pension2_amt01
rename rp80 health_ins01
rename rp83 priv_health_ins01
rename rp8401 priv_health_ins_amt01
rename rp9102 priv_health_ins_cov01
rename rp95 health01
rename rp96 disable01
rename rp9801 doctor01
rename rp99 hospital01
rename rp10302 smoke01
rename rp108 inherit01
rename rp108a01 yr_inherita01
rename rp108a02 gift_inherita01
rename rp108a03 prop_inherita01
rename rp108a04 secur_inherita01
rename rp108a05 money_inherita01
rename rp108a06 shares_inherita01
rename rp108a07 other_inherita01
rename rp108a08 amt_inherita01
rename rp108b01 yr_inheritb01
rename rp108b02 gift_inheritb01
rename rp108b03 prop_inheritb01
rename rp108b04 secur_inheritb01
rename rp108b05 money_inheritb01
rename rp108b06 shares_inheritb01
rename rp108b07 other_inheritb01
rename rp108b08 amt_inheritb01
rename rp108c01 yr_inheritc01
rename rp108c02 gift_inheritc01
rename rp108c03 prop_inheritc01
rename rp108c04 secur_inheritc01
rename rp108c05 money_inheritc01
rename rp108c06 shares_inheritc01
rename rp108c07 other_inheritc01
rename rp108c08 amt_inheritc01
rename rp10901 expect_inherit01
rename rp10902 expect_inherit_amt01
rename rp11401 worry_ec01
rename rp11402 worry_fin01
rename rp11403 worry_health01
rename rp11404 worry_envir01
rename rp11405 worry_peace01
rename rp11406 worry_crime01
rename rp11407 worry_euro01
rename rp11408 worry_immig01
rename rp11409 worry_xeno01
rename rp11410 worry_job01
rename rp11411 worry_other01
rename rp13414 pay_rel01
rename rp13407 child_ger01
rename rp13408 child_for01
rename rp13421 pay_none01
rename rp13002 age01
rename rp63 job_2nd_days01
rename rp64 job_2nd_hours01
rename rp65 job_2nd_month01
rename  rp4005 temp_civil_service01
rename  rp126 stay_forever01 
rename  rp12701 return_now01
rename  rp12702 stay_years01
rename  rp12703 stay_unknown01 
rename	rp0222	hours_other01
rename	rp0309	D_religon01
rename	rp0308	D_politics01
rename	rp0303	D_sports01
rename	rp0302	D_cinema01
rename	rp0301	D_cultural01
rename	rp0201	hours_job01
rename	rp0204	hours_errands01
rename	rp0207	hours_housework01
rename	rp0210	hours_childcare01
rename	rp0219	hours_repairs01




gen civil_service01=0
replace civil_service01=1 if temp_civil_service01>2

replace pension01=0 if pension01!=1
replace ue01=0 if ue01==2

replace hours01=0 if hours01<0

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum01=hhnum
replace hhnum01=new_hhnum01 if new_hhnum01~=hhnum

/* THIS SECTION CALCUALTES, FOR EACH PERSON, THE TOTAL PENSION BEING RECEIVED BY THEMSELVE AND THEIR DEPENDENTS*/

generate pension_amt01temp =  wkr_pension_amt01+ miner_pension_amt01+ civil_pension_amt01+ war_pension_amt01+ farmer_pension_amt01+ acc_pension_amt01+ civils_pension_amt01+ comp_pension_amt01+ other_pension_amt01+ wkr_pension2_amt01+ miner_pension2_amt01+ civil_pension2_amt01+ war_pension2_amt01+ farmer_pension2_amt01+ acc_pension2_amt01+ civils_pension2_amt01+ civil_pension2_amt01+ war_pension2_amt01+ farmer_pension2_amt01+ acc_pension2_amt01+ civils_pension2_amt01+ comp_pension2_amt01+ other_pension2_amt01

generate pension_amt01 = pension_amt01temp
replace pension_amt01= 0 if pension_amt01temp<=0 

drop pension_amt01temp

/* FINALLY WE SORT AND SAVE THE DATA*/

sort hhnum01

save "$datapath\GiavazziMcMahonReStat\2001p.dta", replace

clear all

***************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSON WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr rphrf using "$datapath\phrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename rphrf p_weight01

sort hhnum

save "$datapath\GiavazziMcMahonReStat\2001p weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA WITH THE HOUSEHOLD WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\2001h weight.dta"

sort hhnum01

save  "$datapath\GiavazziMcMahonReStat\2001h weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2001h.dta"

sort hhnum01

save  "$datapath\GiavazziMcMahonReStat\2001h.dta", replace

joinby hhnum01 using "$datapath\GiavazziMcMahonReStat\2001h weight.dta" 

sort hhnum01 

save  "$datapath\GiavazziMcMahonReStat\2001hw.dta", replace

clear all

**********************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA WITH THE PERSONAL WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\2001p weight.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2001p weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2001p.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2001p.dta", replace

joinby pnum using "$datapath\GiavazziMcMahonReStat\2001p weight.dta" 

sort   hhnum01

save  "$datapath\GiavazziMcMahonReStat\2001pw.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA (WITH WEIGHTS) WITH THE CNEF FILE*/

use  "$datapath\GiavazziMcMahonReStat\2001 cnef.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2001 cnef.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2001pw.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2001pw.dta", replace

merge pnum using  "$datapath\GiavazziMcMahonReStat\2001 cnef.dta"

sort   hhnum01

drop if _merge~=3

drop _merge

save  "$datapath\GiavazziMcMahonReStat\2001pw cnef.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA (WITH WEIGHTS) WITH THE CNEF PERSONAL DATA (WITH WEIGHTS)*/

use "$datapath\GiavazziMcMahonReStat\2001pw cnef.dta"

sort   hhnum01 

merge hhnum01 using "$datapath\GiavazziMcMahonReStat\2001hw.dta"

sort hhnum01 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

*NOW ADD GENERATED VARIABLES

merge hhnum01 using "$datapath\GiavazziMcMahonReStat\01extra.dta"

sort hhnum01 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

bysort new_hhnum: egen max_gross = max(cnef_g_income01)
bysort new_hhnum: egen max_net = max(cnef_g_income01)

gen D_main_gross01 = 0
gen D_main_net01 = 0
replace D_main_gross01 = 1 if max_gross==cnef_g_income01
replace D_main_net01 = 1 if max_net==cnef_g_income01

gen temp_drop = 1 if temp_civil_service01>0
bysort new_hhnum01: gen temp_drop2 = sum(temp_drop)
bysort new_hhnum01: egen num_CS01 = max(temp_drop2)
drop temp_drop*

generate job_temp = 0
replace job_temp = 1 if job01==1
replace job_temp = 1 if job01==2
replace job_temp = 1 if job01==4

gen temp_ret = 0
replace  temp_ret =1 if pension01==1
bysort  new_hhnum01: gen ret = sum(temp_ret)
bysort  new_hhnum01: egen retired_hh01 = max(ret)
drop ret temp_ret 

bysort  new_hhnum01: gen work = sum(job_temp)
bysort  new_hhnum01: egen workers01 = max(work)

bysort  new_hhnum01: gen t_hours01 = sum(hours01)
bysort  new_hhnum01: egen tot_hours01 = max(hours01)

gen additional_hours01 = tot_hours01 - hours01
replace additional_hours01=0 if additional_hours01<0

gen worker_ratio01 = workers01/ (people_hh01 -  children_hh01)*100

generate job_temp2 = 0
replace job_temp2 = 1 if job01==1 | job01==2 | job01==4

bysort  new_hhnum01: gen work2 = sum(job_temp2)
bysort  new_hhnum01: egen workers2_01 = max(work2)

drop work work2 
drop job_temp*
drop t_hours


replace  job_2nd_days01 = 0 if  job_2nd_days01<0

replace  job_2nd_hours01 = 0 if job_2nd_hours01<0

replace  job_2nd_month01 = 0 if job_2nd_month01<0

generate job_2nd_amount01 =  job_2nd_days01 * job_2nd_hours01 /* job_2nd_month01*/

bysort  new_hhnum01: gen job_2nd_total_temp = sum(job_2nd_amount01)
bysort  new_hhnum01: egen job_2nd_total01 = max(job_2nd_total_temp)

drop job_2nd_total_temp job_2nd_amount01

generate female=1 if gender ==2
replace female =0 if gender ==1

generate women_hours01=female*hours01

bysort  new_hhnum01: gen women_t_hours01 = sum(women_hours01)
bysort  new_hhnum01: egen women_tot_hours01 = max(women_hours01)

drop women_hours01 women_t_hours01

if $head == 1 {
drop if relation_hh~=1 /*this bit keeps only the head of household data*/
}
else {
	if $head == 0 {
		drop if  D_main_net!=1
		}
	else {
	drop if D_main_gross!=1
	bysort new_hhnum: gen temp_obs= _N
	bysort new_hhnum: egen temp_min_rel= min(relation)
	drop if relation_hh~=temp_min_rel
	drop temp_obs temp_min_rel 
	}	
}
*
capture drop respondant1 h_weight01 /*this bit drops useless variables*/

generate ue_var01 = 1 if job01==7
replace ue_var01=0 if ue_var01!=1

capture drop  h_weight* max_gross max_net gross_flag* net_flag* p_weight* y111* per_weight* hh_weight* *rent*

save  "$datapath\GiavazziMcMahonReStat\2001.dta", replace

/*clear all*/

*********************************************************************************************************************
