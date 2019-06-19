/*Open log file, set memory, etc*/
set logtype text
set more off
clear all 
set mem 50m
/*log using "$datapath\GiavazziMcMahonReStat\2001 database.smcl", replace*/

/* THIS SECTION DOWNLOADS THE HOUSEHOLD DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr hhnrakt welle shhmonin sausku sh01 sh30 sh05 sh08 sh11 sh14 sh2501 sh2502 sh26 sh2801 sh40 sh41 sh4201 sh4202 sh4301 sh4302 sh4303 sh4304 sh4305 sh4306 sh4307 sh4501 sh4505 sh4603 sh4606 sh4609 sh4610 sh4901 sh4902 sh5001 sh5002 sh5101 sh5102 sh5201 sh5202  sh5203 sh5204 sh5205 sh5206 sh5207 sh5208  sh5209  sh5210 sh5211 sh5212 sh5213 sh5214 sh5215 sh5216 sh5217 sh5218 sh5219 sh5220 sh5221 sh5222 sh5223 sh5224 sh5225 sh5226 sh5227 sh5228  sh67 using "$datapath\sh.dta"

sort hhnr

describe

rename shhmonin int_month02
rename hhnr hhnum
rename hhnrakt new_hhnum02
rename welle year
rename sausku respondant
rename sh01 h_change02
rename sh30 tenant02
rename sh05 hse_area02
rename sh08 hse_age02
rename sh11 hse_size02
rename sh14 hse_condition02
rename sh2501 m_rent02 
rename sh2502 norent02
rename sh26 heat_rent02
rename sh2801 other_rent02
rename sh40 prop_rent02
rename sh41 prop2_rent02
rename sh4201 prop_costs02
rename sh4202 prop_mort02
rename sh4301 save_ac02
rename sh4302 save_bs02
rename sh4303 save_la02
rename sh4304 save_fi02
rename sh4305 save_Oth02
rename sh4306 save_comp02
rename sh4307 save_none02
rename sh4501 win02
rename sh4505 win_amt02
rename sh4603 child_allow02
rename sh4606 house_allow02
rename sh4609 sick_allow02
rename sh4610 social_allow02
rename sh4901 income02
rename sh4902 income_grp02
rename sh5001 loan_pay02
rename sh5002 loan_paym02
rename sh5101 save02
rename sh5102 save_amt02
rename sh5201 car_own02
rename sh5202 car02
rename sh5203 motorb_own02
rename sh5204 motorb02
rename sh5205 tv_own02
rename sh5206 tv02
rename sh5207 vcr_own02
rename sh5208 vcr02
rename sh5209 stereo_own02
rename sh5210 stereo02
rename sh5211 pc_own02
rename sh5212 pc02
rename sh5213 web_own02
rename sh5214 web02
rename sh5215 microwave_own02
rename sh5216 microwave02
rename sh5217 dishwash_own02
rename sh5218 dishwash02
rename sh5219 washmach_own02
rename sh5220 washmach02
rename sh5221 tel_own02
rename sh5222 tel02
rename sh5223 mobile_own02
rename sh5224 mobile02
rename sh5225 fax_own02
rename sh5226 fax02
rename sh5227 isdn_own02
rename sh5228 isdn02
rename sh67 cleaner02

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum02=hhnum
replace hhnum02=new_hhnum02 if new_hhnum02~=hhnum

sort hhnum02

save "$datapath\GiavazziMcMahonReStat\2002h.dta", replace

clear all
********************************************************************************************************************

/* USING GENERATED VARIABLES*/

use hhnr persnr shhnr oeffd02 nation02 lfs02 stib02 month02 autono02 using "$datapath\spgen.dta"

rename hhnr hhnum
rename persnr pnum
rename shhnr new_hhnum02

rename  oeffd02 CS_02
rename nation02 nationality02
rename lfs02 lab_force02
rename stib02 occupation_02

generate hhnum02=hhnum
replace hhnum02=new_hhnum02 if new_hhnum02~=hhnum

sort hhnum02

save "$datapath\GiavazziMcMahonReStat\2002 gen.dta", replace

clear all
******************************************************************************
/* THIS SECTION DOWNLOADS THE HOUSEHOLD WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use  hhnr hhnrakt shhrf using "$datapath\hhrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename hhnrakt new_hhnum02
rename shhrf h_weight02

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum02=hhnum
replace hhnum02=new_hhnum02 if new_hhnum02~=hhnum

sort hhnum02

save "$datapath\GiavazziMcMahonReStat\2002h weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSONAL DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr sample1 welle shhnr sp5901 sp5902 sp5903 sp5904 sp63 sp64 sp65 sp72 sp114 sp120 sp121 sp125 sp54 sp85c02 sp0101 sp0102 sp4002 sp4801 sp0103 sp0104 sp0105 sp0106 sp0107 sp0108 sp0109 sp0110 sp10 sp02 sp03 sp0501 sp0502 sp0503 sp0504 sp0505 sp06 sp15 sp4005 sp4601 sp5101 sp52 sp53 sp5801 sp5802 sp6602 sp6603 sp6604 sp6611 sp6612 sp6617 sp6618 sp6801 sp6802 sp6803 sp6607 sp6608 sp6609 sp6610 sp7801 sp7802 sp7803 sp7804 sp79 sp79a01 sp8001 sp8002 sp8003 sp8004 sp8008 sp81 sp82 sp83 sp84 sp85a01 sp85a02  sp85a03 sp85d01 sp85d02 sp103 sp10601 sp10801 sp86 sp9601 sp9902 sp9402 sp11301 sp11302 sp11303 sp11304 sp11305 sp11306 sp11307 sp11308 sp11309 sp11310 sp11312 sp13414 sp13407 sp13408 sp13421 sp13002 sp125	sp12601 sp12602  sp12603 sp1108 sp1101	sp1102	sp1103	sp1104	sp1107 using "$datapath\sp.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename sample1 respondant1
rename welle year
rename shhnr new_hhnum02
rename sp114 Ger_citizen
rename sp120 bornGer02
rename sp121 apply_citizen02
rename sp85c02 value_finass02
rename sp0101 sat_health02
rename sp0102 sat_work02
rename sp0103 sat_hsework02
rename sp0104 sat_hh02
rename sp0105 sat_hse02
rename sp0106 sat_leisure02
rename sp0107 sat_childcare02
rename sp0108 sat_goods02
rename sp0109 sat_environ02
rename sp0110 sat_living02
rename sp10 ue02
rename sp02 using_euro_dif
rename sp03 convert_euro_dif
rename sp0501 euro_unity
rename sp0502 euro_econ_adv
rename sp0503 sad_dm
rename sp0504 disadv_increase
rename sp0505 invest_unstable
rename sp06 euro_intro_sat
rename sp15 job02
rename sp4002 self_emp02
rename sp4005 temp_civil_service02
rename sp4601 jobkm02
rename sp4801 pre_retire_hours
rename sp5101 hours_contract_02
rename sp52 hours02
rename sp53 hours_want_02
rename sp54 overtime02
rename sp5801 g_income02
rename sp5802 n_income02
rename sp5901 job_2nd_family
rename sp5902 job_2nd_regular
rename sp5903 job_2nd_odd
rename sp5904 job_2nd_none
rename sp63 job_2nd_days02
rename sp64 job_2nd_hours02
rename sp65 job_2nd_month02
rename sp6602 g_income2_02
rename sp6603 pension02
rename sp6604 g_pension02
rename sp6607 comp_pens02
rename sp6608 g_comp_pens02
rename sp6609 priv_pens02
rename sp6610 g_priv_pens02
rename sp7801 finsecure_sick02
rename sp7802 finsecure_ue02
rename sp7803 finsecure_old02
rename sp7804 finsecure_oahome02
rename sp79 ss_too_high02
rename sp79a01 min_income_oa_02
rename sp8001 state_finsec_fam02
rename sp8002 state_finsec_baby02
rename sp8003 state_finsec_child02
rename sp8004 state_finsec_ue02
rename sp8008 state_finsec_old02
rename sp81 concerned_privpen02
rename sp82 support_pen02
rename sp83 contribute_morepriv02
rename sp84 state_SS_important02
rename sp85a01 own_home02
rename sp85a02 value_home02
rename sp85a03 debt_home02
rename sp85d01  D_priv_pension
rename sp85d02  value_priv_policy  
rename sp6611 dole02
rename sp6612 g_dole02
rename sp6617 early_retire02
rename sp6618 g_early_retire02
rename sp6801 education02
rename sp6802 educ_school02
rename sp6803 educ_college02
rename sp103 health_ins02
rename sp10601 priv_health_ins02
rename sp10801 priv_health_ins_amt02
rename sp86 health02
rename sp9601 doctor02
rename sp9902 hospital02
rename sp9402 smoke02
rename sp11301 worry_ec02
rename sp11302 worry_fin02
rename sp11303 worry_health02
rename sp11304 worry_envir02
rename sp11305 worry_peace02
rename sp11306 worry_crime02
rename sp11307 worry_euro02
rename sp11308 worry_immig02
rename sp11309 worry_xeno02
rename sp11310 worry_job02
rename sp11312 worry_other02
rename sp13414 pay_rel02
rename sp13407 child_ger02
rename sp13408 child_for02
rename sp13421 pay_none02
rename sp13002 age_y_02
rename sp72 leave_job02
rename sp125 stay_forever02 
rename sp12601 return_now02
rename sp12602 stay_years02
rename sp12603 stay_unknown02 
rename	sp1108	hours_other02
rename	sp1101	hours_job02
rename	sp1102	hours_errands02
rename	sp1103	hours_housework02
rename	sp1104	hours_childcare02
rename	sp1107	hours_repairs02


generate retire=0 
replace retire=1 if leave_job02==6
drop leave_job02

gen civil_service02=0
replace civil_service02=1 if temp_civil_service02>2

replace hours02=0 if hours02<0

replace pension02=0 if pension02!=1
replace ue02=0 if ue02==2

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum02=hhnum
replace hhnum02=new_hhnum02 if new_hhnum02~=hhnum

/* FINALLY WE SORT AND SAVE THE DATA*/

sort hhnum02

save "$datapath\GiavazziMcMahonReStat\2002p.dta", replace

clear all

***************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSON WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr sphrf using "$datapath\phrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename sphrf p_weight02

sort hhnum

save "$datapath\GiavazziMcMahonReStat\2002p weight.dta", replace

clear all

***********************************************************************************************************************
/* THIS SECTION DOWNLOADS THE INDUSTRY DATA FROM THE SPGEN FILE*/

use hhnr persnr nace02 using "$datapath\spgen.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename nace02 industry

sort pnum

save "$datapath\GiavazziMcMahonReStat\2002 industry.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA WITH THE HOUSEHOLD WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\2002h weight.dta"

sort hhnum02

save  "$datapath\GiavazziMcMahonReStat\2002h weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2002h.dta"

sort hhnum02

save  "$datapath\GiavazziMcMahonReStat\2002h.dta", replace

joinby hhnum02 using "$datapath\GiavazziMcMahonReStat\2002h weight.dta" 

sort hhnum02 

save  "$datapath\GiavazziMcMahonReStat\2002hw.dta", replace

clear all

**********************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA WITH THE PERSONAL WEIGHTS and the industry data*/

use  "$datapath\GiavazziMcMahonReStat\2002p weight.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2002p weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2002p.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2002p.dta", replace

joinby pnum using "$datapath\GiavazziMcMahonReStat\2002p weight.dta" 

sort   pnum

joinby pnum using "$datapath\GiavazziMcMahonReStat\2002 industry.dta"

sort   hhnum02

save  "$datapath\GiavazziMcMahonReStat\2002pw.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA (WITH WEIGHTS) WITH THE CNEF FILE*/

use  "$datapath\GiavazziMcMahonReStat\2002 cnef.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2002 cnef.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2002pw.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2002pw.dta", replace

merge pnum using  "$datapath\GiavazziMcMahonReStat\2002 cnef.dta"

sort   hhnum02

drop if _merge~=3

drop _merge

save  "$datapath\GiavazziMcMahonReStat\2002pw cnef.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA (WITH WEIGHTS) WITH THE CNEF PERSONAL DATA (WITH WEIGHTS)*/

use "$datapath\GiavazziMcMahonReStat\2002pw cnef.dta"

sort   hhnum02 

merge hhnum02 using "$datapath\GiavazziMcMahonReStat\2002hw.dta"

sort hhnum02 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

*NOW ADD GENERATED VARIABLES


merge hhnum02 using "$datapath\GiavazziMcMahonReStat\02extra.dta"

sort hhnum02 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

bysort new_hhnum: egen max_gross = max(cnef_g_income02)
bysort new_hhnum: egen max_net = max(cnef_g_income02)

gen D_main_gross02 = 0
gen D_main_net02 = 0
replace D_main_gross02 = 1 if max_gross==cnef_g_income02
replace D_main_net02 = 1 if max_net==cnef_g_income02

gen temp_drop = 1 if temp_civil_service02>0
bysort new_hhnum02: gen temp_drop2 = sum(temp_drop)
bysort new_hhnum02: egen num_CS02 = max(temp_drop2)
drop temp_drop*

generate job_temp = 0
replace job_temp = 1 if job02==1
replace job_temp = 1 if job02==2
replace job_temp = 1 if job02==4

gen temp_ret = 0
replace  temp_ret =1 if pension02==1
bysort  new_hhnum02: gen ret = sum(temp_ret)
bysort  new_hhnum02: egen retired_hh02 = max(ret)
drop ret temp_ret 

bysort  new_hhnum02: gen work = sum(job_temp)
bysort  new_hhnum02: egen workers02 = max(work)

bysort  new_hhnum02: gen t_hours02 = sum(hours02)
bysort  new_hhnum02: egen tot_hours02 = max(hours02)

gen additional_hours02 = tot_hours02 - hours02
replace additional_hours02=0 if additional_hours<0

gen worker_ratio02 = workers02/ (people_hh02 -  children_hh02)*100


generate job_temp2 = 0
replace job_temp2 = 1 if job02==1 | job02==2 | job02==4

bysort  new_hhnum02: gen work2 = sum(job_temp2)
bysort  new_hhnum02: egen workers2_02 = max(work2)

drop work work2 
drop job_temp*
drop t_hours

replace  job_2nd_days02 = 0 if  job_2nd_days02<0

replace  job_2nd_hours02 = 0 if job_2nd_hours02<0

replace  job_2nd_month02 = 0 if job_2nd_month02<0

generate job_2nd_amount02 =  job_2nd_days02 * job_2nd_hours02 /* job_2nd_month02*/

bysort  new_hhnum02: gen job_2nd_total_temp = sum(job_2nd_amount02)
bysort  new_hhnum02: egen job_2nd_total02 = max(job_2nd_total_temp)

drop job_2nd_total_temp job_2nd_amount02

generate female=1 if gender ==2
replace female =0 if gender ==1

generate women_hours02=female*hours02

bysort  new_hhnum02: gen women_t_hours02 = sum(women_hours02)
bysort  new_hhnum02: egen women_tot_hours02 = max(women_hours02)

drop women_hours02 women_t_hours02



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
capture drop respondant1 cpi_02 h_weight02 /*this bit drops useless variables*/

generate ue_var02 = 1 if job02==9
replace ue_var02=0 if ue_var02!=1

capture drop  h_weight* max_gross max_net gross_flag* net_flag* p_weight* y111* per_weight* hh_weight* *rent*

save  "$datapath\GiavazziMcMahonReStat\2002.dta", replace

/*clear all*/

*********************************************************************************************************************
