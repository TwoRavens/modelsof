/*Open log file, set memory, etc*/
set logtype text
set more off
clear all 
set mem 50m
/*log using "$datapath\GiavazziMcMahonReStat\2001 database.smcl", replace*/

/* THIS SECTION DOWNLOADS THE DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr hhnrakt welle phhmonin pausku ph4301 ph4302 ph4303 ph4304  ph04 ph06 ph12 ph13 ph16 ph50 ph5201 ph5202 using "$datapath\ph.dta"

sort hhnr

describe

rename phhmonin int_month99
rename hhnr hhnum
rename hhnrakt new_hhnum99
rename welle year
rename pausku pnum
rename ph04 h_change99
rename ph06 tenant99
rename ph12 hse_area99
rename ph13 hse_age99
rename ph16 hse_size99
rename ph50 income99
rename ph5201 save99
rename ph5202 save_amt99

rename ph4301 save_ac99
rename ph4302 save_bs99
rename ph4303 save_la99
rename ph4304 save_fi99

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum99=hhnum
replace hhnum99=new_hhnum99 if new_hhnum99~=hhnum

sort hhnum99

save "$datapath\GiavazziMcMahonReStat\1999h.dta", replace

clear all

******************************************************************************
/* THIS SECTION DOWNLOADS THE HOUSEHOLD WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use  hhnr hhnrakt phhrf using "$datapath\hhrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename hhnrakt new_hhnum99
rename phhrf h_weight99

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum99=hhnum
replace hhnum99=new_hhnum99 if new_hhnum99~=hhnum

sort hhnum99

save "$datapath\GiavazziMcMahonReStat\1999h weight.dta", replace

clear all
********************************************************************************************************************

/* USING GENERATED VARIABLES*/

use hhnr persnr phhnr oeffd99 nation99 lfs99 stib99 month99 autono99 using "$datapath\ppgen.dta"

rename hhnr hhnum
rename persnr pnum
rename phhnr new_hhnum99

rename  oeffd99 CS_99
rename nation99 nationality99
rename lfs99 lab_force99
rename stib99 occupation_99

generate hhnum99=hhnum
replace hhnum99=new_hhnum99 if new_hhnum99~=hhnum

sort hhnum99

save "$datapath\GiavazziMcMahonReStat\1999 gen.dta", replace

clear all

 
***********************************************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSONAL DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr welle phhnr pp3805 pp10 pp52 pp13002 pp05 pp10902 pp10901 pp10910 pp6613 pp6501 pp6502 pp125 pp12601 pp12602 pp12603 pp02a7	pp0308	pp0307	pp0303	pp0302	pp0301		pp02a1	pp02a2	pp02a3	pp02a4	pp02a6  using "$datapath\pp.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename welle year
rename phhnr new_hhnum99
rename pp13002 age_y_99
rename pp52 hours99
rename pp05 ue99
rename pp10901 worry_ec99
rename pp10902 worry_fin99
rename pp10910 worry_job99
rename pp10 job99
rename pp6613 pension99
rename pp6501 job_2nd_days99
rename pp6502 job_2nd_hours99
rename  pp3805 temp_civil_service99
rename  pp125 stay_forever99 
rename  pp12601 return_now99
rename  pp12602 stay_years99 
rename  pp12603 stay_unknown99 
rename	pp02a7	hours_other99
rename	pp0308	D_religon99
rename	pp0307	D_politics99
rename	pp0303	D_sports99
rename	pp0302	D_cinema99
rename	pp0301	D_cultural99
rename	pp02a1	hours_job99
rename	pp02a2	hours_errands99
rename	pp02a3	hours_housework99
rename	pp02a4	hours_childcare99
rename	pp02a6	hours_repairs99



gen civil_service99=0
replace civil_service99=1 if temp_civil_service99>2

replace hours99=0 if hours99<0

replace pension99=0 if pension99!=1
drop if ue99<0
replace ue99=0 if ue99==2

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum99=hhnum
replace hhnum99=new_hhnum99 if new_hhnum99~=hhnum

/* FINALLY WE SORT AND SAVE THE DATA*/

sort hhnum99

save "$datapath\GiavazziMcMahonReStat\1999p.dta", replace

clear all

***************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSON WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr pphrf using "$datapath\phrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename pphrf p_weight99

sort hhnum

save "$datapath\GiavazziMcMahonReStat\1999p weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA WITH THE HOUSEHOLD WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\1999h weight.dta"

sort hhnum99

save  "$datapath\GiavazziMcMahonReStat\1999h weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1999h.dta"

sort hhnum99

save  "$datapath\GiavazziMcMahonReStat\1999h.dta", replace

joinby hhnum99 using "$datapath\GiavazziMcMahonReStat\1999h weight.dta" 

sort hhnum99 

save  "$datapath\GiavazziMcMahonReStat\1999hw.dta", replace

clear all

**********************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA WITH THE PERSONAL WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\1999p weight.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1999p weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1999p.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1999p.dta", replace

joinby pnum using "$datapath\GiavazziMcMahonReStat\1999p weight.dta" 

sort   hhnum99

save  "$datapath\GiavazziMcMahonReStat\1999pw.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA (WITH WEIGHTS) WITH THE CNEF FILE*/

use  "$datapath\GiavazziMcMahonReStat\1999 cnef.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1999 cnef.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1999pw.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1999pw.dta", replace

merge pnum using  "$datapath\GiavazziMcMahonReStat\1999 cnef.dta"

sort   hhnum99

drop if _merge~=3

drop _merge

save  "$datapath\GiavazziMcMahonReStat\1999pw cnef.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA (WITH WEIGHTS) WITH THE CNEF PERSONAL DATA (WITH WEIGHTS)*/

use "$datapath\GiavazziMcMahonReStat\1999pw cnef.dta"

sort   hhnum99 

merge hhnum99 using "$datapath\GiavazziMcMahonReStat\1999hw.dta"

sort hhnum99

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

*NOW ADD GENERATED VARIABLES

merge hhnum99 using "$datapath\GiavazziMcMahonReStat\99extra.dta"

sort hhnum99 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

bysort new_hhnum: egen max_gross = max(cnef_g_income99)
bysort new_hhnum: egen max_net = max(cnef_g_income99)

gen D_main_gross99 = 0
gen D_main_net99 = 0
replace D_main_gross99 = 1 if max_gross==cnef_g_income99
replace D_main_net99 = 1 if max_net==cnef_g_income99

gen temp_drop = 1 if temp_civil_service99>0
bysort new_hhnum99: gen temp_drop2 = sum(temp_drop)
bysort new_hhnum99: egen num_CS99 = max(temp_drop2)
drop temp_drop*


generate job_temp = 0
replace job_temp = 1 if job99==1
replace job_temp = 1 if job99==2
replace job_temp = 1 if job99==4

gen temp_ret = 0
replace  temp_ret =1 if pension99==1
bysort  new_hhnum99: gen ret = sum(temp_ret)
bysort  new_hhnum99: egen retired_hh99 = max(ret)
drop ret temp_ret 

bysort  new_hhnum99: gen work = sum(job_temp)
bysort  new_hhnum99: egen workers99 = max(work)

bysort  new_hhnum99: gen t_hours99 = sum(hours99)
bysort  new_hhnum99: egen tot_hours99 = max(hours99)

gen additional_hours99 = tot_hours99 - hours99
replace additional_hours99=0 if additional_hours99<0

gen worker_ratio99 = workers99/ (people_hh99 -  children_hh99)*100


generate job_temp2 = 0
replace job_temp2 = 1 if job99==1 | job99==2 | job99==4

bysort  new_hhnum99: gen work2 = sum(job_temp2)
bysort  new_hhnum99: egen workers2_99 = max(work2)

drop work work2 
drop job_temp*
drop t_hours

replace  job_2nd_days99 = 0 if  job_2nd_days99<0
replace  job_2nd_hours99 = 0 if job_2nd_hours99<0

generate job_2nd_amount99 =  job_2nd_days99 * job_2nd_hours99

bysort  new_hhnum99: gen job_2nd_total_temp = sum(job_2nd_amount99)
bysort  new_hhnum99: egen job_2nd_total99 = max(job_2nd_total_temp)

drop job_2nd_total_temp job_2nd_amount99


generate female=1 if gender ==2
replace female =0 if gender ==1

generate women_hours99=female*hours99

bysort  new_hhnum99: gen women_t_hours99 = sum(women_hours99)
bysort  new_hhnum99: egen women_tot_hours99 = max(women_hours99)

drop women_hours99 women_t_hours99


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

generate ue_var99 = 1 if employed99==0
replace ue_var99=0 if ue_var99!=1

capture drop  h_weight* max_gross max_net gross_flag* net_flag* p_weight* y111* per_weight* hh_weight* *rent*

save  "$datapath\GiavazziMcMahonReStat\1999.dta", replace

/*clear all*/

*********************************************************************************************************************
