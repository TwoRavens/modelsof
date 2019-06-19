/*Open log file, set memory, etc*/
set logtype text
set more off
clear all 
set mem 50m


/* THIS SECTION DOWNLOADS THE DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr hhnrakt welle khhmonin kausku kh19 kh14 kh07 kh10 kh20 kh01 kh2601 kh2602 kh27 kh2901 kh40 kh41 kh4201 kh4202 kh4301 kh4302 kh4303 kh4304 kh4305 kh4306 kh4602 kh4501 kh47 kh49 kh5001 kh5002 using "$datapath\kh.dta"

sort hhnr

describe

rename khhmonin int_month94
rename hhnr hhnum
rename hhnrakt new_hhnum94
rename welle year
rename kausku pnum
rename kh19 h_change94
rename kh14 tenant94
rename kh07 hse_area94
rename kh10 hse_age94
rename kh20 hse_size94
rename kh01 hse_condition94
rename kh2601 m_rent94 
rename kh2602 norent94
rename kh27 heat_rent94
rename kh2901 other_rent94
rename kh40 prop_rent94
rename kh41 prop2_rent94
rename kh4201 prop_costs94
rename kh4202 prop_mort94
rename kh4301 save_ac94
rename kh4302 save_bs94
rename kh4303 save_la94
rename kh4304 save_fi94
rename kh4305 save_comp94
rename kh4306 save_none94
rename kh4602 child_allow94
rename kh4501 house_allow94
rename kh47 social_allow94
rename kh49 income94
rename kh5001 save94
rename kh5002 save_amt94

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum94=hhnum
replace hhnum94=new_hhnum94 if new_hhnum94~=hhnum

sort hhnum94

save "$datapath\GiavazziMcMahonReStat\1994h.dta", replace

clear all

******************************************************************************
/* THIS SECTION DOWNLOADS THE HOUSEHOLD WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use  hhnr hhnrakt khhrf using "$datapath\hhrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename hhnrakt new_hhnum94
rename khhrf h_weight94

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum94=hhnum
replace hhnum94=new_hhnum94 if new_hhnum94~=hhnum

sort hhnum94

save "$datapath\GiavazziMcMahonReStat\1994h weight.dta", replace

clear all
********************************************************************************************************************

/* USING GENERATED VARIABLES*/

use hhnr persnr khhnr oeffd94 nation94 lfs94 stib94 month94 autono94 using "$datapath\kpgen.dta"

rename hhnr hhnum
rename persnr pnum
rename khhnr new_hhnum94

rename  oeffd94 CS_94
rename nation94 nationality94
rename lfs94 lab_force94
rename stib94 occupation_94

generate hhnum94=hhnum
replace hhnum94=new_hhnum94 if new_hhnum94~=hhnum

sort hhnum94

save "$datapath\GiavazziMcMahonReStat\1994 gen.dta", replace

clear all

 
***********************************************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSONAL DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr welle khhnr kp60  kp16 kp5105 kp25 kp1101 kp1102 kp10002 kp9302 kp9301 kp9307 kp0807 kp1208 kp1207 kp1203 kp1202 kp1201 kp0807 kp0801 kp0802 kp0803 kp0804 kp0806 using "$datapath\kp.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename welle year
rename khhnr new_hhnum94
rename kp10002 age_y_94
rename kp60 hours94
rename kp16 ue94
rename kp9301 worry_ec94
rename kp9302 worry_fin94
rename kp9307 worry_job94
rename kp25 job94
rename kp1101 job_2nd_days94
rename kp1102 job_2nd_hours94
rename kp5105 temp_civil_service94
rename kp0807 hours_other94
rename kp1208 D_religon94
rename kp1207 D_politics94
rename kp1203 D_sports94
rename kp1202 D_cinema94
rename kp1201 D_cultural94
rename kp0801 hours_job94
rename kp0802 hours_errands94
rename kp0803 hours_housework94
rename kp0804 hours_childcare94
rename kp0806 hours_repairs94


gen civil_service94=0
replace civil_service94=1 if temp_civil_service94>2

replace hours94=0 if hours94<0

/*replace pension94=0 if pension94!=1*/
drop if ue94<0
replace ue94=0 if ue94==2

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum94=hhnum
replace hhnum94=new_hhnum94 if new_hhnum94~=hhnum

/* FINALLY WE SORT AND SAVE THE DATA*/

sort hhnum94

save "$datapath\GiavazziMcMahonReStat\1994p.dta", replace

clear all

***************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSON WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr kphrf using "$datapath\phrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename kphrf p_weight94

sort hhnum

save "$datapath\GiavazziMcMahonReStat\1994p weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA WITH THE HOUSEHOLD WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\1994h weight.dta"

sort hhnum94

save  "$datapath\GiavazziMcMahonReStat\1994h weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1994h.dta"

sort hhnum94

save  "$datapath\GiavazziMcMahonReStat\1994h.dta", replace

joinby hhnum94 using "$datapath\GiavazziMcMahonReStat\1994h weight.dta" 

sort hhnum94 

save  "$datapath\GiavazziMcMahonReStat\1994hw.dta", replace

clear all

**********************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA WITH THE PERSONAL WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\1994p weight.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1994p weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1994p.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1994p.dta", replace

joinby pnum using "$datapath\GiavazziMcMahonReStat\1994p weight.dta" 

sort   hhnum94

save  "$datapath\GiavazziMcMahonReStat\1994pw.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA (WITH WEIGHTS) WITH THE CNEF FILE*/

use  "$datapath\GiavazziMcMahonReStat\1994 cnef.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1994 cnef.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1994pw.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1994pw.dta", replace

merge pnum using  "$datapath\GiavazziMcMahonReStat\1994 cnef.dta"

sort   hhnum94

drop if _merge~=3

drop _merge

save  "$datapath\GiavazziMcMahonReStat\1994pw cnef.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA (WITH WEIGHTS) WITH THE CNEF PERSONAL DATA (WITH WEIGHTS)*/

use "$datapath\GiavazziMcMahonReStat\1994pw cnef.dta"

sort   hhnum94 

merge hhnum94 using "$datapath\GiavazziMcMahonReStat\1994hw.dta"

sort hhnum94

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

*NOW ADD GENERATED VARIABLES

merge hhnum94 using "$datapath\GiavazziMcMahonReStat\94extra.dta"

sort hhnum94 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

bysort new_hhnum: egen max_gross = max(cnef_g_income94)
bysort new_hhnum: egen max_net = max(cnef_g_income94)

gen D_main_gross94 = 0
gen D_main_net94 = 0
replace D_main_gross94 = 1 if max_gross==cnef_g_income94
replace D_main_net94 = 1 if max_net==cnef_g_income94

generate job_temp = 0
replace job_temp = 1 if job94==1
replace job_temp = 1 if job94==2
replace job_temp = 1 if job94==4

gen temp_drop = 1 if temp_civil_service94>0
bysort new_hhnum94: gen temp_drop2 = sum(temp_drop)
bysort new_hhnum94: egen num_CS94 = max(temp_drop2)
drop temp_drop*

/*gen temp_ret = 0
replace  temp_ret =1 if pension94==1
bysort  new_hhnum94: gen ret = sum(temp_ret)
bysort  new_hhnum94: egen retired_hh94 = max(ret)
drop ret temp_ret  */

bysort  new_hhnum94: gen work = sum(job_temp)
bysort  new_hhnum94: egen workers94 = max(work)

bysort  new_hhnum94: gen t_hours94 = sum(hours94)
bysort  new_hhnum94: egen tot_hours94 = max(hours94)

gen additional_hours94 = tot_hours94 - hours94
replace additional_hours94=0 if additional_hours94<0

gen worker_ratio94 = workers94/ (people_hh94 -  children_hh94)*194

drop work 
drop job_temp
drop t_hours

replace  job_2nd_days94 = 0 if  job_2nd_days94<0
replace  job_2nd_hours94 = 0 if job_2nd_hours94<0

generate job_2nd_amount94 =  job_2nd_days94 * job_2nd_hours94

bysort  new_hhnum94: gen job_2nd_total_temp = sum(job_2nd_amount94)
bysort  new_hhnum94: egen job_2nd_total94 = max(job_2nd_total_temp)

drop job_2nd_total_temp job_2nd_amount94

generate female=1 if gender ==2
replace female =0 if gender ==1

generate women_hours94=female*hours94

bysort  new_hhnum94: gen women_t_hours94 = sum(women_hours94)
bysort  new_hhnum94: egen women_tot_hours94 = max(women_hours94)

drop women_hours94 women_t_hours94


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

generate ue_var94 = 1 if employed94==0
replace ue_var94=0 if ue_var94!=1 
save  "$datapath\GiavazziMcMahonReStat\1994.dta", replace

/*clear all*/

*********************************************************************************************************************
