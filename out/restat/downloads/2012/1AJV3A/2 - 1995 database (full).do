/*Open log file, set memory, etc*/
set logtype text
set more off
clear all 
set mem 50m

/* THIS SECTION DOWNLOADS THE DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr hhnrakt welle lhhmonin lh4301 lh4302 lh4303 lh4304 lausku lh19 lh14 lh07 lh10 lh20 lh01 lh2601 lh2602 lh27 lh2901 lh40 lh41 lh4201 lh4202 lh4301 lh4302 lh4303 lh4304 lh4305 lh4306 lh4602 lh4501 lh47 lh50 lh5101 lh5102 using "$datapath\lh.dta"

sort hhnr

describe

rename lhhmonin int_month95
rename hhnr hhnum
rename hhnrakt new_hhnum95
rename welle year
rename lausku pnum
rename lh19 h_change95
rename lh14 tenant95
rename lh07 hse_area95
rename lh10 hse_age95
rename lh20 hse_size95
rename lh01 hse_condition95
rename lh2601 m_rent95 
rename lh2602 norent95
rename lh27 heat_rent95
rename lh2901 other_rent95
rename lh40 prop_rent95
rename lh41 prop2_rent95
rename lh4201 prop_costs95
rename lh4202 prop_mort95
rename lh4301 save_ac95
rename lh4302 save_bs95
rename lh4303 save_la95
rename lh4304 save_fi95
rename lh4305 save_comp95
rename lh4306 save_none95
rename lh4602 child_allow95
rename lh4501 house_allow95
rename lh47 social_allow95
rename lh50 income95
rename lh5101 save95
rename lh5102 save_amt95

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum95=hhnum
replace hhnum95=new_hhnum95 if new_hhnum95~=hhnum

sort hhnum95

save "$datapath\GiavazziMcMahonReStat\1995h.dta", replace

clear all

******************************************************************************
/* THIS SECTION DOWNLOADS THE HOUSEHOLD WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use  hhnr hhnrakt lhhrf using "$datapath\hhrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename hhnrakt new_hhnum95
rename lhhrf h_weight95

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum95=hhnum
replace hhnum95=new_hhnum95 if new_hhnum95~=hhnum

sort hhnum95

save "$datapath\GiavazziMcMahonReStat\1995h weight.dta", replace

clear all

***********************************************************************************************************************

/* USING GENERATED VARIABLES*/

use hhnr persnr lhhnr oeffd95 nation95 lfs95 stib95 month95 autono95 using "$datapath\lpgen.dta"

rename hhnr hhnum
rename persnr pnum
rename lhhnr new_hhnum95
rename  oeffd95 CS_95
rename nation95 nationality95
rename lfs95 lab_force95
rename stib95 occupation_95

generate hhnum95=hhnum
replace hhnum95=new_hhnum95 if new_hhnum95~=hhnum

sort hhnum95

save "$datapath\GiavazziMcMahonReStat\1995 gen.dta", replace

clear all

*************************************************************************************************************
/* THIS SECTION DOWNLOADS THE PERSONAL DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr welle lhhnr lp49 lp4305 lp7703  lp13 lp21 lp0501 lp0502 lp10002 lp9902 lp9901 lp9907 lp0207	lp0608	lp0606	lp0613	lp0615	lp0616		lp0201	lp0202	lp0203	lp0204	lp0206  using "$datapath\lp.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename welle year
rename lhhnr new_hhnum95
rename lp10002 age_y_95
rename lp49 hours95
rename lp13 ue95
rename lp9901 worry_ec95
rename lp9902 worry_fin95
rename lp9907 worry_job95
rename lp21 job95
rename lp7703 pension95
rename lp0501 job_2nd_days95
rename lp0502 job_2nd_hours95
rename  lp4305 temp_civil_service95
rename	lp0207	hours_other95
rename	lp0608	D_religon95
rename	lp0606	D_politics95
rename	lp0613	D_sports95
rename	lp0615	D_cinema95
rename	lp0616	D_cultural95
rename	lp0201	hours_job95
rename	lp0202	hours_errands95
rename	lp0203	hours_housework95
rename	lp0204	hours_childcare95
rename	lp0206	hours_repairs95


gen civil_service95=0
replace civil_service95=1 if temp_civil_service95>2

replace hours95=0 if hours95<0

replace pension95=0 if pension95!=1
drop if ue95<0
replace ue95=0 if ue95==2

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum95=hhnum
replace hhnum95=new_hhnum95 if new_hhnum95~=hhnum

/* FINALLY WE SORT AND SAVE THE DATA*/

sort hhnum95

save "$datapath\GiavazziMcMahonReStat\1995p.dta", replace

clear all

***************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSON WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr lphrf using "$datapath\phrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename lphrf p_weight95

sort hhnum

save "$datapath\GiavazziMcMahonReStat\1995p weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA WITH THE HOUSEHOLD WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\1995h weight.dta"

sort hhnum95

save  "$datapath\GiavazziMcMahonReStat\1995h weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1995h.dta"

sort hhnum95

save  "$datapath\GiavazziMcMahonReStat\1995h.dta", replace

joinby hhnum95 using "$datapath\GiavazziMcMahonReStat\1995h weight.dta" 

sort hhnum95 

save  "$datapath\GiavazziMcMahonReStat\1995hw.dta", replace

clear all

**********************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA WITH THE PERSONAL WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\1995p weight.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1995p weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1995p.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1995p.dta", replace

joinby pnum using "$datapath\GiavazziMcMahonReStat\1995p weight.dta" 

sort   hhnum95

save  "$datapath\GiavazziMcMahonReStat\1995pw.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA (WITH WEIGHTS) WITH THE CNEF FILE*/

use  "$datapath\GiavazziMcMahonReStat\1995 cnef.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1995 cnef.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1995pw.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1995pw.dta", replace

merge pnum using  "$datapath\GiavazziMcMahonReStat\1995 cnef.dta"

sort   hhnum95

drop if _merge~=3

drop _merge

save  "$datapath\GiavazziMcMahonReStat\1995pw cnef.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA (WITH WEIGHTS) WITH THE CNEF PERSONAL DATA (WITH WEIGHTS)*/

use "$datapath\GiavazziMcMahonReStat\1995pw cnef.dta"

sort   hhnum95 

merge hhnum95 using "$datapath\GiavazziMcMahonReStat\1995hw.dta"

sort hhnum95

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

*NOW ADD GENERATED VARIABLES

merge hhnum95 using "$datapath\GiavazziMcMahonReStat\95extra.dta"

sort hhnum95 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

bysort new_hhnum: egen max_gross = max(cnef_g_income95)
bysort new_hhnum: egen max_net = max(cnef_g_income95)

gen D_main_gross95 = 0
gen D_main_net95 = 0
replace D_main_gross95 = 1 if max_gross==cnef_g_income95
replace D_main_net95 = 1 if max_net==cnef_g_income95

generate job_temp = 0
replace job_temp = 1 if job95==1
replace job_temp = 1 if job95==2
replace job_temp = 1 if job95==4

gen temp_drop = 1 if temp_civil_service95>0
bysort new_hhnum95: gen temp_drop2 = sum(temp_drop)
bysort new_hhnum95: egen num_CS95 = max(temp_drop2)
drop temp_drop*

gen temp_ret = 0
replace  temp_ret =1 if pension95==1
bysort  new_hhnum95: gen ret = sum(temp_ret)
bysort  new_hhnum95: egen retired_hh95 = max(ret)
drop ret temp_ret 

bysort  new_hhnum95: gen work = sum(job_temp)
bysort  new_hhnum95: egen workers95 = max(work)

bysort  new_hhnum95: gen t_hours95 = sum(hours95)
bysort  new_hhnum95: egen tot_hours95 = max(hours95)

gen additional_hours95 = tot_hours95 - hours95
replace additional_hours95=0 if additional_hours95<0

gen worker_ratio95 = workers95/ (people_hh95 -  children_hh95)*100

generate job_temp2 = 0
replace job_temp2 = 1 if job95==1 | job95==2 | job95==4

bysort  new_hhnum95: gen work2 = sum(job_temp2)
bysort  new_hhnum95: egen workers2_95 = max(work2)

drop work work2 
drop job_temp*
drop t_hours

replace  job_2nd_days95 = 0 if  job_2nd_days95<0
replace  job_2nd_hours95 = 0 if job_2nd_hours95<0

generate job_2nd_amount95 =  job_2nd_days95 * job_2nd_hours95

bysort  new_hhnum95: gen job_2nd_total_temp = sum(job_2nd_amount95)
bysort  new_hhnum95: egen job_2nd_total95 = max(job_2nd_total_temp)

drop job_2nd_total_temp job_2nd_amount95

generate female=1 if gender ==2
replace female =0 if gender ==1

generate women_hours95=female*hours95

bysort  new_hhnum95: gen women_t_hours95 = sum(women_hours95)
bysort  new_hhnum95: egen women_tot_hours95 = max(women_hours95)

drop women_hours95 women_t_hours95


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

generate ue_var95 = 1 if employed95==0
replace ue_var95=0 if ue_var95!=1 

capture drop  h_weight* max_gross max_net gross_flag* net_flag* p_weight* y1110195 per_weight* hh_weight* *rent*

save  "$datapath\GiavazziMcMahonReStat\1995.dta", replace

/*clear all*/

*********************************************************************************************************************
