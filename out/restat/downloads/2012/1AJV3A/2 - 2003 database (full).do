/*Open log file, set memory, etc*/
set logtype text
set more off
clear all 
set mem 50m
/*log using "$datapath\GiavazziMcMahonReStat\2001 database.smcl", replace*/

/* THIS SECTION DOWNLOADS THE DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr hhnrakt welle tausku thhmonin  th4101 th4102 th4103 th4104  th11 th05 th09 th12 th4801 th5001 th5002 using "$datapath\th.dta"

sort hhnr

describe

rename thhmonin int_month03
rename hhnr hhnum
rename hhnrakt new_hhnum03
rename welle year
rename tausku pnum
rename th11 h_change03
rename th05 hse_area03
rename th09 hse_age03
rename th12 hse_size03
rename th4801 income03
rename th5001 save03
rename th5002 save_amt03

rename th4101 save_ac03
rename th4102 save_bs03
rename th4103 save_la03
rename th4104 save_fi03

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum03=hhnum
replace hhnum03=new_hhnum03 if new_hhnum03~=hhnum

sort hhnum03

save "$datapath\GiavazziMcMahonReStat\2003h.dta", replace

clear all
********************************************************************************************************************

/* USING GENERATED VARIABLES*/

use hhnr persnr thhnr oeffd03 nation03 lfs03 stib03 month03 autono03 using "$datapath\tpgen.dta"

rename hhnr hhnum
rename persnr pnum
rename thhnr new_hhnum03

rename  oeffd03 CS_03
rename nation03 nationality03
rename lfs03 lab_force03
rename stib03 occupation_03

generate hhnum03=hhnum
replace hhnum03=new_hhnum03 if new_hhnum03~=hhnum

sort hhnum03

save "$datapath\GiavazziMcMahonReStat\2003 gen.dta", replace

clear all

******************************************************************************
/* THIS SECTION DOWNLOADS THE HOUSEHOLD WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use  hhnr hhnrakt thhrf using "$datapath\hhrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename hhnrakt new_hhnum03
rename thhrf h_weight03

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum03=hhnum
replace hhnum03=new_hhnum03 if new_hhnum03~=hhnum

sort hhnum03

save "$datapath\GiavazziMcMahonReStat\2003h weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSONAL DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr welle thhnr tp7003 tp13602 tp8403 tp6605   tp13 tp8403 tp34 tp12002 tp12001   tp12010 tp81  tp82  tp83 tp60 tp132 tp13301 tp13302 tp13303 tp1022	tp1407	tp1405	tp1414	tp1416	tp1417		tp1001	tp1004	tp1007	tp1010	tp1019  using "$datapath\tp.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename welle year
rename thhnr new_hhnum03
rename tp13602 age_y_03
rename tp7003 hours03
rename tp13 ue03
rename tp8403 pension03
rename tp34 job03
rename tp12001 worry_ec03
rename tp12002 worry_fin03
rename tp12010 worry_job03
rename tp81 job_2nd_days03
rename tp82 job_2nd_hours03
rename tp83 job_2nd_month03
rename tp6605 temp_civil_service03
rename tp132 stay_forever03 
rename tp13301 return_now03
rename tp13302 stay_years03
rename tp13303 stay_unknown03 
rename	tp1022	hours_other03
rename	tp1407	D_religon03
rename	tp1405	D_politics03
rename	tp1414	D_sports03
rename	tp1416	D_cinema03
rename	tp1417	D_cultural03
rename	tp1001	hours_job03
rename	tp1004	hours_errands03
rename	tp1007	hours_housework03
rename	tp1010	hours_childcare03
rename	tp1019	hours_repairs03




gen civil_service03=0
replace civil_service03=1 if temp_civil_service03>2

replace hours03=0 if hours03<0

replace pension03=0 if pension03!=1

drop if ue03<0
replace ue03=0 if ue03==2

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum03=hhnum
replace hhnum03=new_hhnum03 if new_hhnum03~=hhnum

/* FINALLY WE SORT AND SAVE THE DATA*/

sort hhnum03

save "$datapath\GiavazziMcMahonReStat\2003p.dta", replace

clear all

***************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSON WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr tphrf using "$datapath\phrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename tphrf p_weight03

sort hhnum

save "$datapath\GiavazziMcMahonReStat\2003p weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA WITH THE HOUSEHOLD WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\2003h weight.dta"

sort hhnum03

save  "$datapath\GiavazziMcMahonReStat\2003h weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2003h.dta"

sort hhnum03

save  "$datapath\GiavazziMcMahonReStat\2003h.dta", replace

joinby hhnum03 using "$datapath\GiavazziMcMahonReStat\2003h weight.dta" 

sort hhnum03 

save  "$datapath\GiavazziMcMahonReStat\2003hw.dta", replace

clear all

**********************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA WITH THE PERSONAL WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\2003p weight.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2003p weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2003p.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2003p.dta", replace

joinby pnum using "$datapath\GiavazziMcMahonReStat\2003p weight.dta" 

sort   hhnum03

save  "$datapath\GiavazziMcMahonReStat\2003pw.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA (WITH WEIGHTS) WITH THE CNEF FILE*/

use  "$datapath\GiavazziMcMahonReStat\2003 cnef.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2003 cnef.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2003pw.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2003pw.dta", replace

merge pnum using  "$datapath\GiavazziMcMahonReStat\2003 cnef.dta"

sort   hhnum03

drop if _merge~=3

drop _merge

save  "$datapath\GiavazziMcMahonReStat\2003pw cnef.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA (WITH WEIGHTS) WITH THE CNEF PERSONAL DATA (WITH WEIGHTS)*/

use "$datapath\GiavazziMcMahonReStat\2003pw cnef.dta"

sort   hhnum03 

merge hhnum03 using "$datapath\GiavazziMcMahonReStat\2003hw.dta"

sort hhnum03

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

*NOW ADD GENERATED VARIABLES

merge hhnum03 using "$datapath\GiavazziMcMahonReStat\03extra.dta"

sort hhnum03 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

bysort new_hhnum: egen max_gross = max(cnef_g_income03)
bysort new_hhnum: egen max_net = max(cnef_g_income03)

gen D_main_gross03 = 0
gen D_main_net03 = 0
replace D_main_gross03 = 1 if max_gross==cnef_g_income03
replace D_main_net03 = 1 if max_net==cnef_g_income03

generate job_temp = 0
replace job_temp = 1 if job03==1
replace job_temp = 1 if job03==2
replace job_temp = 1 if job03==4

gen temp_drop = 1 if temp_civil_service03>0
bysort new_hhnum03: gen temp_drop2 = sum(temp_drop)
bysort new_hhnum03: egen num_CS03 = max(temp_drop2)
drop temp_drop*

gen temp_ret = 0
replace  temp_ret =1 if pension03==1
bysort  new_hhnum03: gen ret = sum(temp_ret)
bysort  new_hhnum03: egen retired_hh03 = max(ret)
drop ret temp_ret 

bysort  new_hhnum03: gen work = sum(job_temp)
bysort  new_hhnum03: egen workers03 = max(work)

bysort  new_hhnum03: gen t_hours03 = sum(hours03)
bysort  new_hhnum03: egen tot_hours03 = max(hours03)

gen additional_hours03 = tot_hours03 - hours03
replace additional_hours03=0 if additional_hours03<0

gen worker_ratio03 = workers03/ (people_hh03 -  children_hh03)*100


generate job_temp2 = 0
replace job_temp2 = 1 if job03==1 | job03==2 | job03==4

bysort  new_hhnum03: gen work2 = sum(job_temp2)
bysort  new_hhnum03: egen workers2_03 = max(work2)

drop work work2  
drop job_temp*
drop t_hours

replace  job_2nd_days03 = 0 if  job_2nd_days03<0

replace  job_2nd_hours03 = 0 if job_2nd_hours03<0

replace  job_2nd_month03 = 0 if job_2nd_month03<0

generate job_2nd_amount03 =  job_2nd_days03 * job_2nd_hours03 /* job_2nd_month03*/

bysort  new_hhnum03: gen job_2nd_total_temp = sum(job_2nd_amount03)
bysort  new_hhnum03: egen job_2nd_total03 = max(job_2nd_total_temp)

drop job_2nd_total_temp job_2nd_amount03

generate female=1 if gender ==2
replace female =0 if gender ==1

generate women_hours03=female*hours03

bysort  new_hhnum03: gen women_t_hours03 = sum(women_hours03)
bysort  new_hhnum03: egen women_tot_hours03 = max(women_hours03)

drop women_hours03 women_t_hours03



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

generate ue_var03 = 1 if job03==9
replace ue_var03=0 if ue_var03!=1

capture drop  h_weight* max_gross max_net gross_flag* net_flag* p_weight* y111* per_weight* hh_weight* *rent*

save  "$datapath\GiavazziMcMahonReStat\2003.dta", replace

/*clear all*/

*********************************************************************************************************************
