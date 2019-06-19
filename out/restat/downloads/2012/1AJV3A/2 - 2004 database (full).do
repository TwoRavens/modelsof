/*Open log file, set memory, etc*/
set logtype text
set more off
clear all 
set mem 50m
/*log using "$datapath\GiavazziMcMahonReStat\2001 database.smcl", replace*/

/* THIS SECTION DOWNLOADS THE DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr hhnrakt welle uausku uhhmonin  uh4101 uh4102 uh4103 uh4104  uh11  uh05 uh09 uh12 uh4801 uh5001 uh5002 using "$datapath\uh.dta"

sort hhnr

describe

rename uhhmonin int_month04
rename hhnr hhnum
rename hhnrakt new_hhnum04
rename welle year
rename uausku pnum
rename uh11 h_change04
rename uh05 hse_area04
rename uh09 hse_age04
rename uh12 hse_size04
rename uh4801 income04
rename uh5001 save04
rename uh5002 save_amt04

rename uh4101 save_ac04
rename uh4102 save_bs04
rename uh4103 save_la04
rename uh4104 save_fi04

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum04=hhnum
replace hhnum04=new_hhnum04 if new_hhnum04~=hhnum

sort hhnum04

save "$datapath\GiavazziMcMahonReStat\2004h.dta", replace

clear all
********************************************************************************************************************

/* USING GENERATED VARIABLES*/

use hhnr persnr uhhnr oeffd04 nation04 lfs04 stib04 month04 autono04 using "$datapath\upgen.dta"

rename hhnr hhnum
rename persnr pnum
rename uhhnr new_hhnum04

rename  oeffd04 CS_04
rename nation04 nationality04
rename lfs04 lab_force04
rename stib04 occupation_04

generate hhnum04=hhnum
replace hhnum04=new_hhnum04 if new_hhnum04~=hhnum

sort hhnum04

save "$datapath\GiavazziMcMahonReStat\2004 gen.dta", replace

clear all
******************************************************************************
/* THIS SECTION DOWNLOADS THE HOUSEHOLD WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use  hhnr hhnrakt uhhrf using "$datapath\hhrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename hhnrakt new_hhnum04
rename uhhrf h_weight04

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum04=hhnum
replace hhnum04=new_hhnum04 if new_hhnum04~=hhnum

sort hhnum04

save "$datapath\GiavazziMcMahonReStat\2004h weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSONAL DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr welle uhhnr up50 up13902 up05 up6801 up09 up12502 up12501 up12510 up119  up64  up65  up66 up3705 up134 up13501 up13502 up13503 up0208	 up0201	up0202	up0203	up0204	up0207  using "$datapath\up.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename welle year
rename uhhnr new_hhnum04
rename up13902 age_y_04
rename up50 hours04
rename up05 ue04
rename up6801 pension04
rename up09 job04
rename up12501 worry_ec04
rename up12502 worry_fin04
rename up12510 worry_job04
rename up119 risk_averse04
rename up64 job_2nd_days04
rename up65 job_2nd_hours04
rename up66 job_2nd_month04
rename up3705 temp_civil_service04
rename up134 stay_forever04
rename up13501 return_now04
rename up13502 stay_years04
rename up13503 stay_unknown04 
rename	up0208	hours_other04
rename	up0201	hours_job04
rename	up0202	hours_errands04
rename	up0203	hours_housework04
rename	up0204	hours_childcare04
rename	up0207	hours_repairs04



gen civil_service04=0
replace civil_service04=1 if temp_civil_service04>2

replace hours04=0 if hours04<0

replace pension04=0 if pension04!=1

drop if ue04<0
replace ue04=0 if ue04==2

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum04=hhnum
replace hhnum04=new_hhnum04 if new_hhnum04~=hhnum

/* FINALLY WE SORT AND SAVE THE DATA*/

sort hhnum04

save "$datapath\GiavazziMcMahonReStat\2004p.dta", replace

clear all

***************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSON WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr uphrf using "$datapath\phrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename uphrf p_weight04

sort hhnum

save "$datapath\GiavazziMcMahonReStat\2004p weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA WITH THE HOUSEHOLD WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\2004h weight.dta"

sort hhnum04

save  "$datapath\GiavazziMcMahonReStat\2004h weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2004h.dta"

sort hhnum04

save  "$datapath\GiavazziMcMahonReStat\2004h.dta", replace

joinby hhnum04 using "$datapath\GiavazziMcMahonReStat\2004h weight.dta" 

sort hhnum04 

save  "$datapath\GiavazziMcMahonReStat\2004hw.dta", replace

clear all

**********************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA WITH THE PERSONAL WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\2004p weight.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2004p weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2004p.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2004p.dta", replace

joinby pnum using "$datapath\GiavazziMcMahonReStat\2004p weight.dta" 

sort   hhnum04

save  "$datapath\GiavazziMcMahonReStat\2004pw.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA (WITH WEIGHTS) WITH THE CNEF FILE*/

use  "$datapath\GiavazziMcMahonReStat\2004 cnef.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2004 cnef.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2004pw.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2004pw.dta", replace

merge pnum using  "$datapath\GiavazziMcMahonReStat\2004 cnef.dta"

sort   hhnum04

drop if _merge~=3

drop _merge

save  "$datapath\GiavazziMcMahonReStat\2004pw cnef.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA (WITH WEIGHTS) WITH THE CNEF PERSONAL DATA (WITH WEIGHTS)*/

use "$datapath\GiavazziMcMahonReStat\2004pw cnef.dta"

sort   hhnum04 

merge hhnum04 using "$datapath\GiavazziMcMahonReStat\2004hw.dta"

sort hhnum04

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

*NOW ADD GENERATED VARIABLES

merge hhnum04 using "$datapath\GiavazziMcMahonReStat\04extra.dta"

sort hhnum04 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

bysort new_hhnum: egen max_gross = max(cnef_g_income04)
bysort new_hhnum: egen max_net = max(cnef_g_income04)

gen D_main_gross04 = 0
gen D_main_net04 = 0
replace D_main_gross04 = 1 if max_gross==cnef_g_income04
replace D_main_net04 = 1 if max_net==cnef_g_income04

generate job_temp = 0
replace job_temp = 1 if job04==1
replace job_temp = 1 if job04==2
replace job_temp = 1 if job04==4

gen temp_ret = 0
replace  temp_ret =1 if pension04==1
bysort  new_hhnum04: gen ret = sum(temp_ret)
bysort  new_hhnum04: egen retired_hh04 = max(ret)
drop ret temp_ret 

gen temp_drop = 1 if temp_civil_service04>0
bysort new_hhnum04: gen temp_drop2 = sum(temp_drop)
bysort new_hhnum04: egen num_CS04 = max(temp_drop2)
drop temp_drop*

bysort  new_hhnum04: gen work = sum(job_temp)
bysort  new_hhnum04: egen workers04 = max(work)

bysort  new_hhnum04: gen t_hours04 = sum(hours04)
bysort  new_hhnum04: egen tot_hours04 = max(hours04)

gen additional_hours04 = tot_hours04 - hours04
replace additional_hours04=0 if additional_hours04<0

gen worker_ratio04 = workers04/ (people_hh04 -  children_hh04)*100

generate job_temp2 = 0
replace job_temp2 = 1 if job04==1 | job04==2 | job04==4

bysort  new_hhnum04: gen work2 = sum(job_temp2)
bysort  new_hhnum04: egen workers2_04 = max(work2)

drop work work2 
drop job_temp*
drop t_hours


replace  job_2nd_days04 = 0 if  job_2nd_days04<0

replace  job_2nd_hours04 = 0 if job_2nd_hours04<0

replace  job_2nd_month04 = 0 if job_2nd_month04<0

generate job_2nd_amount04 =  job_2nd_days04 * job_2nd_hours04 /* job_2nd_month04*/

bysort  new_hhnum04: gen job_2nd_total_temp = sum(job_2nd_amount04)
bysort  new_hhnum04: egen job_2nd_total04 = max(job_2nd_total_temp)

drop job_2nd_total_temp job_2nd_amount04

generate female=1 if gender ==2
replace female =0 if gender ==1

generate women_hours04=female*hours04

bysort  new_hhnum04: gen women_t_hours04 = sum(women_hours04)
bysort  new_hhnum04: egen women_tot_hours04 = max(women_hours04)

drop women_hours04 women_t_hours04


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

generate ue_var04 = 1 if job04==9
replace ue_var04=0 if ue_var04!=1

capture drop  h_weight* max_gross max_net gross_flag* net_flag* p_weight* y111* per_weight* hh_weight* *rent*

save  "$datapath\GiavazziMcMahonReStat\2004.dta", replace

/*clear all*/

*********************************************************************************************************************
