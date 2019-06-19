/*Open log file, set memory, etc*/
set logtype text
set more off
clear all 
set mem 50m
/*log using "$datapath\GiavazziMcMahonReStat\2001 database.smcl", replace*/

/* THIS SECTION DOWNLOADS THE DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr hhnrakt welle nausku nhhmonin  nh4301 nh4302 nh4303 nh4304 nh19 nh14 nh08 nh01 nh20 nh02 nh2701 nh2702 nh28 nh3001 nh40 nh41 nh4201 nh4202 nh4301 nh4302 nh4303 nh4304 nh4305 nh4306 nh4602 nh4501 nh47 nh50 nh5201 nh5202 nh5101 nh5102 using "$datapath\nh.dta"

sort hhnr

describe

rename nhhmonin int_month97
rename hhnr hhnum
rename hhnrakt new_hhnum97
rename welle year
rename nausku pnum
rename nh19 h_change97
rename nh14 tenant97
rename nh08 hse_area97
rename nh01 hse_age97
rename nh20 hse_size97
rename nh02 hse_condition97
rename nh2701 m_rent97 
rename nh2702 norent97
rename nh28 heat_rent97
rename nh3001 other_rent97
rename nh40 prop_rent97
rename nh41 prop2_rent97
rename nh4201 prop_costs97
rename nh4202 prop_mort97
rename nh4301 save_ac97
rename nh4302 save_bs97
rename nh4303 save_la97
rename nh4304 save_fi97
rename nh4305 save_comp97
rename nh4306 save_none97
rename nh4602 child_allow97
rename nh4501 house_allow97
rename nh47 social_allow97
rename nh50 income97
rename nh5201 loan_pay97
rename nh5202 loan_paym97
rename nh5101 save97
rename nh5102 save_amt97

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum97=hhnum
replace hhnum97=new_hhnum97 if new_hhnum97~=hhnum

sort hhnum97

save "$datapath\GiavazziMcMahonReStat\1997h.dta", replace

clear all
********************************************************************************************************************

/* USING GENERATED VARIABLES*/

use hhnr persnr nhhnr oeffd97 nation97 lfs97 stib97 month97 autono97 using "$datapath\npgen.dta"

rename hhnr hhnum
rename persnr pnum
rename nhhnr new_hhnum97

rename  oeffd97 CS_97
rename nation97 nationality97
rename lfs97 lab_force97
rename stib97 occupation_97

generate hhnum97=hhnum
replace hhnum97=new_hhnum97 if new_hhnum97~=hhnum

sort hhnum97

save "$datapath\GiavazziMcMahonReStat\1997 gen.dta", replace

clear all

******************************************************************************
/* THIS SECTION DOWNLOADS THE HOUSEHOLD WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use  hhnr hhnrakt nhhrf using "$datapath\hhrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename hhnrakt new_hhnum97
rename nhhrf h_weight97

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum97=hhnum
replace hhnum97=new_hhnum97 if new_hhnum97~=hhnum

sort hhnum97

save "$datapath\GiavazziMcMahonReStat\1997h weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSONAL DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr welle nhhnr np47  np3505 np5811  np08 np8903 np11 np5701 np5702 np11202 np9502 np9501 np9506  np108a	np109a01 np109a02 np109a03 np0207	np0308	np0307	np0303	np0302	np0301		np0201	np0202	np0203	np0204	np0206  using "$datapath\np.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename welle year
rename nhhnr new_hhnum97
rename np11202 age_y_97
rename np47 hours97
rename np08 ue97
rename np9501 worry_ec97
rename np9502 worry_fin97
rename np9506 worry_job97
rename np8903 finsecure_old97
rename np11 job97
rename np5811 pension97
rename np5701 job_2nd_days97
rename np5702 job_2nd_hours97
rename np108a stay_forever97 
rename np109a01 return_now97
rename np109a02 stay_years97 
rename np109a03 stay_unknown97 
rename	np0207	hours_other97
rename	np0308	D_religon97
rename	np0307	D_politics97
rename	np0303	D_sports97
rename	np0302	D_cinema97
rename	np0301	D_cultural97
rename	np0201	hours_job97
rename	np0202	hours_errands97
rename	np0203	hours_housework97
rename	np0204	hours_childcare97
rename	np0206	hours_repairs97


rename  np3505 temp_civil_service97

gen civil_service97=0
replace civil_service97=1 if temp_civil_service97>2

replace hours97=0 if hours97<0

replace pension97=0 if pension97!=1
drop if ue97<0
replace ue97=0 if ue97==2

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum97=hhnum
replace hhnum97=new_hhnum97 if new_hhnum97~=hhnum

/* FINALLY WE SORT AND SAVE THE DATA*/

sort hhnum97

save "$datapath\GiavazziMcMahonReStat\1997p.dta", replace

clear all

***************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSON WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr nphrf using "$datapath\phrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename nphrf p_weight97

sort hhnum

save "$datapath\GiavazziMcMahonReStat\1997p weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA WITH THE HOUSEHOLD WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\1997h weight.dta"

sort hhnum97

save  "$datapath\GiavazziMcMahonReStat\1997h weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1997h.dta"

sort hhnum97

save  "$datapath\GiavazziMcMahonReStat\1997h.dta", replace

joinby hhnum97 using "$datapath\GiavazziMcMahonReStat\1997h weight.dta" 

sort hhnum97 

save  "$datapath\GiavazziMcMahonReStat\1997hw.dta", replace

clear all

**********************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA WITH THE PERSONAL WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\1997p weight.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1997p weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1997p.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1997p.dta", replace

joinby pnum using "$datapath\GiavazziMcMahonReStat\1997p weight.dta" 

sort   hhnum97

save  "$datapath\GiavazziMcMahonReStat\1997pw.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA (WITH WEIGHTS) WITH THE CNEF FILE*/

use  "$datapath\GiavazziMcMahonReStat\1997 cnef.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1997 cnef.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1997pw.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1997pw.dta", replace

merge pnum using  "$datapath\GiavazziMcMahonReStat\1997 cnef.dta"

sort   hhnum97

drop if _merge~=3

drop _merge

save  "$datapath\GiavazziMcMahonReStat\1997pw cnef.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA (WITH WEIGHTS) WITH THE CNEF PERSONAL DATA (WITH WEIGHTS)*/

use "$datapath\GiavazziMcMahonReStat\1997pw cnef.dta"

sort   hhnum97 

merge hhnum97 using "$datapath\GiavazziMcMahonReStat\1997hw.dta"

sort hhnum97

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge


*NOW ADD GENERATED VARIABLES

merge hhnum97 using "$datapath\GiavazziMcMahonReStat\97extra.dta"

sort hhnum97 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

bysort new_hhnum: egen max_gross = max(cnef_g_income97)
bysort new_hhnum: egen max_net = max(cnef_g_income97)

gen D_main_gross97 = 0
gen D_main_net97 = 0
replace D_main_gross97 = 1 if max_gross==cnef_g_income97
replace D_main_net97 = 1 if max_net==cnef_g_income97

generate job_temp = 0
replace job_temp = 1 if job97==1
replace job_temp = 1 if job97==2
replace job_temp = 1 if job97==4

gen temp_drop = 1 if temp_civil_service97>0
bysort new_hhnum97: gen temp_drop2 = sum(temp_drop)
bysort new_hhnum97: egen num_CS97 = max(temp_drop2)
drop temp_drop*

gen temp_ret = 0
replace  temp_ret =1 if pension97==1
bysort  new_hhnum97: gen ret = sum(temp_ret)
bysort  new_hhnum97: egen retired_hh97 = max(ret)
drop ret temp_ret 

bysort  new_hhnum97: gen work = sum(job_temp)
bysort  new_hhnum97: egen workers97 = max(work)

bysort  new_hhnum97: gen t_hours97 = sum(hours97)
bysort  new_hhnum97: egen tot_hours97 = max(hours97)

gen additional_hours97 = tot_hours97 - hours97
replace additional_hours97=0 if additional_hours97<0

gen worker_ratio97 = workers97/ (people_hh97 -  children_hh97)*100

generate job_temp2 = 0
replace job_temp2 = 1 if job97==1 | job97==2 | job97==4

bysort  new_hhnum97: gen work2 = sum(job_temp2)
bysort  new_hhnum97: egen workers2_97 = max(work2)

drop work work2 
drop job_temp*
drop t_hours

replace  job_2nd_days97 = 0 if  job_2nd_days97<0
replace  job_2nd_hours97 = 0 if job_2nd_hours97<0

generate job_2nd_amount97 =  job_2nd_days97 * job_2nd_hours97

bysort  new_hhnum97: gen job_2nd_total_temp = sum(job_2nd_amount97)
bysort  new_hhnum97: egen job_2nd_total97 = max(job_2nd_total_temp)

drop job_2nd_total_temp job_2nd_amount97

generate female=1 if gender ==2
replace female =0 if gender ==1

generate women_hours97=female*hours97

bysort  new_hhnum97: gen women_t_hours97 = sum(women_hours97)
bysort  new_hhnum97: egen women_tot_hours97 = max(women_hours97)

drop women_hours97 women_t_hours97


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

generate ue_var97 = 1 if employed97==0
replace ue_var97=0 if ue_var97!=1 

capture drop  h_weight* max_gross max_net gross_flag* net_flag* p_weight* y111* per_weight* hh_weight* *rent*

save  "$datapath\GiavazziMcMahonReStat\1997.dta", replace

/*clear all*/

*********************************************************************************************************************
