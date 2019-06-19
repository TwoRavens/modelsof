/*Open log file, set memory, etc*/
set logtype text
set more off
clear all 
set mem 50m
/*log using "$datapath\GiavazziMcMahonReStat\2001 database.smcl", replace*/

/* THIS SECTION DOWNLOADS THE DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr hhnrakt welle ohhmonin  oausku oh11c  oh4301 oh4302 oh4303 oh4304  oh14 oh08 oh01 oh11a oh50 oh5101 oh5102 oh5301 using "$datapath\oh.dta"

sort hhnr

describe

rename ohhmonin int_month98
rename hhnr hhnum
rename hhnrakt new_hhnum98
rename welle year
rename oausku pnum
rename oh11c h_change98
rename oh14 tenant98
rename oh08 hse_area98
rename oh01 hse_age98
rename oh11a hse_size98
rename oh50 income98
rename oh5101 save98
rename oh5102 save_amt98

rename oh4301 save_ac98
rename oh4302 save_bs98
rename oh4303 save_la98
rename oh4304 save_fi98

rename oh5301 food98

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum98=hhnum
replace hhnum98=new_hhnum98 if new_hhnum98~=hhnum

sort hhnum98

save "$datapath\GiavazziMcMahonReStat\1998h.dta", replace

clear all
********************************************************************************************************************

/* USING GENERATED VARIABLES*/

use hhnr persnr ohhnr oeffd98 nation98 lfs98 stib98 month98 autono98 using "$datapath\opgen.dta"

rename hhnr hhnum
rename persnr pnum
rename ohhnr new_hhnum98

rename  oeffd98 CS_98
rename nation98 nationality98
rename lfs98 lab_force98
rename stib98 occupation_98

generate hhnum98=hhnum
replace hhnum98=new_hhnum98 if new_hhnum98~=hhnum

sort hhnum98

save "$datapath\GiavazziMcMahonReStat\1998 gen.dta", replace

clear all

 
******************************************************************************
/* THIS SECTION DOWNLOADS THE HOUSEHOLD WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use  hhnr hhnrakt ohhrf using "$datapath\hhrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename hhnrakt new_hhnum98
rename ohhrf h_weight98

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum98=hhnum
replace hhnum98=new_hhnum98 if new_hhnum98~=hhnum

sort hhnum98

save "$datapath\GiavazziMcMahonReStat\1998h weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSONAL DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr welle ohhnr op40 op09 op3505 op11802 op04 op9802 op9801 op9806 op4911 op4801  op4802 op113 op11401 op11402 op11403 op0507	op0607	op0605	op0613	op0615	op0616	op0501	op0502	op0503	op0504	op0506  using "$datapath\op.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename welle year
rename ohhnr new_hhnum98
rename op11802 age_y_98
rename op40 hours98
rename op04 ue98
rename op9801 worry_ec98
rename op9802 worry_fin98
rename op9806 worry_job98
rename op09 job98
rename op4911 pension98
rename op4801 job_2nd_days98
rename op4802 job_2nd_hours98
rename op113 stay_forever98 
rename op11401 return_now98
rename op11402 stay_years98 
rename op11403 stay_unknown98 
rename  op3505 temp_civil_service98
rename	op0507	hours_other98
rename	op0607	D_religon98
rename	op0605	D_politics98
rename	op0613	D_sports98
rename	op0615	D_cinema98
rename	op0616	D_cultural98
rename	op0501	hours_job98
rename	op0502	hours_errands98
rename	op0503	hours_housework98
rename	op0504	hours_childcare98
rename	op0506	hours_repairs98


gen civil_service98=0
replace civil_service98=1 if temp_civil_service98>2

replace hours98=0 if hours98<0

replace pension98=0 if pension98!=1
drop if ue98<0
replace ue98=0 if ue98==2

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum98=hhnum
replace hhnum98=new_hhnum98 if new_hhnum98~=hhnum

/* FINALLY WE SORT AND SAVE THE DATA*/

sort hhnum98

save "$datapath\GiavazziMcMahonReStat\1998p.dta", replace

clear all

***************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSON WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr ophrf using "$datapath\phrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename ophrf p_weight98

sort hhnum

save "$datapath\GiavazziMcMahonReStat\1998p weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA WITH THE HOUSEHOLD WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\1998h weight.dta"

sort hhnum98

save  "$datapath\GiavazziMcMahonReStat\1998h weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1998h.dta"

sort hhnum98

save  "$datapath\GiavazziMcMahonReStat\1998h.dta", replace

joinby hhnum98 using "$datapath\GiavazziMcMahonReStat\1998h weight.dta" 

sort hhnum98 

save  "$datapath\GiavazziMcMahonReStat\1998hw.dta", replace

clear all

**********************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA WITH THE PERSONAL WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\1998p weight.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1998p weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1998p.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1998p.dta", replace

joinby pnum using "$datapath\GiavazziMcMahonReStat\1998p weight.dta" 

sort   hhnum98

save  "$datapath\GiavazziMcMahonReStat\1998pw.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA (WITH WEIGHTS) WITH THE CNEF FILE*/

use  "$datapath\GiavazziMcMahonReStat\1998 cnef.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1998 cnef.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1998pw.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1998pw.dta", replace

merge pnum using  "$datapath\GiavazziMcMahonReStat\1998 cnef.dta"

sort   hhnum98

drop if _merge~=3

drop _merge

save  "$datapath\GiavazziMcMahonReStat\1998pw cnef.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA (WITH WEIGHTS) WITH THE CNEF PERSONAL DATA (WITH WEIGHTS)*/

use "$datapath\GiavazziMcMahonReStat\1998pw cnef.dta"

sort   hhnum98 

merge hhnum98 using "$datapath\GiavazziMcMahonReStat\1998hw.dta"

sort hhnum98

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

*NOW ADD GENERATED VARIABLES

merge hhnum98 using "$datapath\GiavazziMcMahonReStat\98extra.dta"

sort hhnum98 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

bysort new_hhnum: egen max_gross = max(cnef_g_income98)
bysort new_hhnum: egen max_net = max(cnef_g_income98)

gen D_main_gross98 = 0
gen D_main_net98 = 0
replace D_main_gross98 = 1 if max_gross==cnef_g_income98
replace D_main_net98 = 1 if max_net==cnef_g_income98


gen temp_drop = 1 if temp_civil_service98>0
bysort new_hhnum98: gen temp_drop2 = sum(temp_drop)
bysort new_hhnum98: egen num_CS98 = max(temp_drop2)
drop temp_drop*

generate job_temp = 0
replace job_temp = 1 if job98==1
replace job_temp = 1 if job98==2
replace job_temp = 1 if job98==4

gen temp_ret = 0
replace  temp_ret =1 if pension98==1
bysort  new_hhnum98: gen ret = sum(temp_ret)
bysort  new_hhnum98: egen retired_hh98 = max(ret)
drop ret temp_ret 

bysort  new_hhnum98: gen work = sum(job_temp)
bysort  new_hhnum98: egen workers98 = max(work)

bysort  new_hhnum98: gen t_hours98 = sum(hours98)
bysort  new_hhnum98: egen tot_hours98 = max(hours98)

gen additional_hours98 = tot_hours98 - hours98
replace additional_hours98=0 if additional_hours98<0

gen worker_ratio98 = workers98/ (people_hh98 -  children_hh98)*100

generate job_temp2 = 0
replace job_temp2 = 1 if job98==1 | job98==2 | job98==4

bysort  new_hhnum98: gen work2 = sum(job_temp2)
bysort  new_hhnum98: egen workers2_98 = max(work2)

drop work work2 
drop job_temp*
drop t_hours


replace  job_2nd_days98 = 0 if  job_2nd_days98<0
replace  job_2nd_hours98 = 0 if job_2nd_hours98<0

generate job_2nd_amount98 =  job_2nd_days98 * job_2nd_hours98

bysort  new_hhnum98: gen job_2nd_total_temp = sum(job_2nd_amount98)
bysort  new_hhnum98: egen job_2nd_total98 = max(job_2nd_total_temp)

drop job_2nd_total_temp job_2nd_amount98


generate female=1 if gender ==2
replace female =0 if gender ==1

generate women_hours98=female*hours98

bysort  new_hhnum98: gen women_t_hours98 = sum(women_hours98)
bysort  new_hhnum98: egen women_tot_hours98 = max(women_hours98)

drop women_hours98 women_t_hours98

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

generate ue_var98 = 1 if employed98==0
replace ue_var98=0 if ue_var98!=1

capture drop  h_weight* max_gross max_net gross_flag* net_flag* p_weight* y111* per_weight* hh_weight* *rent*

save  "$datapath\GiavazziMcMahonReStat\1998.dta", replace

/*clear all*/

*********************************************************************************************************************
