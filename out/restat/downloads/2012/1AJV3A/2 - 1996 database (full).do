/*Open log file, set memory, etc*/
set logtype text
set more off
clear all 
set mem 50m
/*log using "$datapath\GiavazziMcMahonReStat\2001 database.smcl", replace*/

/* THIS SECTION DOWNLOADS THE DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr hhnrakt welle mhhmonin mausku  mh4301 mh4302 mh4303 mh4304 mh19 mh14 mh08 mh01 mh20 mh02 mh2701 mh2702 mh28 mh3001 mh40 mh41 mh4201 mh4202 mh4301 mh4302 mh4303 mh4304 mh4305 mh4306 mh4602 mh4501 mh47 mh50  mh5101 mh5102 using "$datapath\mh.dta"

sort hhnr

describe

rename mhhmonin int_month96
rename hhnr hhnum
rename hhnrakt new_hhnum96
rename welle year
rename mausku pnum
rename mh19 h_change96
rename mh14 tenant96
rename mh08 hse_area96
rename mh01 hse_age96
rename mh20 hse_size96
rename mh02 hse_condition96
rename mh2701 m_rent96 
rename mh2702 norent96
rename mh28 heat_rent96
rename mh3001 other_rent96
rename mh40 prop_rent96
rename mh41 prop2_rent96
rename mh4201 prop_costs96
rename mh4202 prop_mort96
rename mh4301 save_ac96
rename mh4302 save_bs96
rename mh4303 save_la96
rename mh4304 save_fi96
rename mh4305 save_comp96
rename mh4306 save_none96
rename mh4602 child_allow96
rename mh4501 house_allow96
rename mh47 social_allow96
rename mh50 income96
rename mh5101 save96
rename mh5102 save_amt96


/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum96=hhnum
replace hhnum96=new_hhnum96 if new_hhnum96~=hhnum

sort hhnum96

save "$datapath\GiavazziMcMahonReStat\1996h.dta", replace

clear all
***********************************************************************************

/* USING GENERATED VARIABLES*/

use hhnr persnr mhhnr oeffd96 nation96 lfs96 stib96 month96 autono96 using "$datapath\mpgen.dta"

rename hhnr hhnum
rename persnr pnum
rename mhhnr new_hhnum96

rename  oeffd96 CS_96
rename nation96 nationality96
rename lfs96 lab_force96
rename stib96 occupation_96

generate hhnum96=hhnum
replace hhnum96=new_hhnum96 if new_hhnum96~=hhnum

sort hhnum96

save "$datapath\GiavazziMcMahonReStat\1996 gen.dta", replace

clear all

 
*
******************************************************************************
/* THIS SECTION DOWNLOADS THE HOUSEHOLD WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use  hhnr hhnrakt mhhrf using "$datapath\hhrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename hhnrakt new_hhnum96
rename mhhrf h_weight96

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum96=hhnum
replace hhnum96=new_hhnum96 if new_hhnum96~=hhnum

sort hhnum96

save "$datapath\GiavazziMcMahonReStat\1996h weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSONAL DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr welle mhhnr mp43 mp4105 mp5811 mp12 mp15 mp5701 mp5702 mp10502 mp10902  mp10901 mp10906  mp100a mp101a01 mp101a02 mp101a03 mp0207	mp0508	mp0507	mp0503	mp0502	mp0501		mp0201	mp0202	mp0203	mp0204	mp0206  using "$datapath\mp.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename welle year
rename mhhnr new_hhnum96
rename mp10502 age_y_96
rename mp43 hours96
rename mp12 ue96
rename mp10901 worry_ec96
rename mp10902 worry_fin96
rename mp10906 worry_job96
rename mp15 job96
rename mp5811 pension96
rename mp5701 job_2nd_days96
rename mp5702 job_2nd_hours96
rename mp100a stay_forever96 
rename mp101a01 return_now96 
rename mp101a02 stay_years96 
rename mp101a03 stay_unknown96 
rename  mp4105 temp_civil_service96
rename	mp0207	hours_other96
rename	mp0508	D_religon96
rename	mp0507	D_politics96
rename	mp0503	D_sports96
rename	mp0502	D_cinema96
rename	mp0501	D_cultural96
rename	mp0201	hours_job96
rename	mp0202	hours_errands96
rename	mp0203	hours_housework96
rename	mp0204	hours_childcare96
rename	mp0206	hours_repairs96


gen civil_service96=0
replace civil_service96=1 if temp_civil_service96>2

replace hours96=0 if hours96<0

replace pension96=0 if pension96!=1
drop if ue96<0
replace ue96=0 if ue96==2



/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum96=hhnum
replace hhnum96=new_hhnum96 if new_hhnum96~=hhnum

/* FINALLY WE SORT AND SAVE THE DATA*/

sort hhnum96

save "$datapath\GiavazziMcMahonReStat\1996p.dta", replace

clear all

***************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSON WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr mphrf using "$datapath\phrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename mphrf p_weight96

sort hhnum

save "$datapath\GiavazziMcMahonReStat\1996p weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA WITH THE HOUSEHOLD WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\1996h weight.dta"

sort hhnum96

save  "$datapath\GiavazziMcMahonReStat\1996h weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1996h.dta"

sort hhnum96

save  "$datapath\GiavazziMcMahonReStat\1996h.dta", replace

joinby hhnum96 using "$datapath\GiavazziMcMahonReStat\1996h weight.dta" 

sort hhnum96 

save  "$datapath\GiavazziMcMahonReStat\1996hw.dta", replace

clear all

**********************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA WITH THE PERSONAL WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\1996p weight.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1996p weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1996p.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1996p.dta", replace

joinby pnum using "$datapath\GiavazziMcMahonReStat\1996p weight.dta" 

sort   hhnum96

save  "$datapath\GiavazziMcMahonReStat\1996pw.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA (WITH WEIGHTS) WITH THE CNEF FILE*/

use  "$datapath\GiavazziMcMahonReStat\1996 cnef.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1996 cnef.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\1996pw.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\1996pw.dta", replace

merge pnum using  "$datapath\GiavazziMcMahonReStat\1996 cnef.dta"

sort   hhnum96

drop if _merge~=3

drop _merge

save  "$datapath\GiavazziMcMahonReStat\1996pw cnef.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA (WITH WEIGHTS) WITH THE CNEF PERSONAL DATA (WITH WEIGHTS)*/

use "$datapath\GiavazziMcMahonReStat\1996pw cnef.dta"

sort   hhnum96 

merge hhnum96 using "$datapath\GiavazziMcMahonReStat\1996hw.dta"

sort hhnum96

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge


*NOW ADD GENERATED VARIABLES

merge hhnum96 using "$datapath\GiavazziMcMahonReStat\96extra.dta"

sort hhnum96 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

bysort new_hhnum: egen max_gross = max(cnef_g_income96)
bysort new_hhnum: egen max_net = max(cnef_g_income96)

gen D_main_gross96 = 0
gen D_main_net96 = 0
replace D_main_gross96 = 1 if max_gross==cnef_g_income96
replace D_main_net96 = 1 if max_net==cnef_g_income96


generate job_temp = 0
replace job_temp = 1 if job96==1
replace job_temp = 1 if job96==2
replace job_temp = 1 if job96==4

gen temp_drop = 1 if temp_civil_service96>0
bysort new_hhnum96: gen temp_drop2 = sum(temp_drop)
bysort new_hhnum96: egen num_CS96 = max(temp_drop2)
drop temp_drop*

gen temp_ret = 0
replace  temp_ret =1 if pension96==1
bysort  new_hhnum96: gen ret = sum(temp_ret)
bysort  new_hhnum96: egen retired_hh96 = max(ret)
drop ret temp_ret 

bysort  new_hhnum96: gen work = sum(job_temp)
bysort  new_hhnum96: egen workers96 = max(work)

bysort  new_hhnum96: gen t_hours96 = sum(hours96)
bysort  new_hhnum96: egen tot_hours96 = max(hours96)

gen additional_hours96 = tot_hours96 - hours96
replace additional_hours96=0 if additional_hours96<0

gen worker_ratio96 = workers96/ (people_hh96 -  children_hh96)*100

generate job_temp2 = 0
replace job_temp2 = 1 if job96==1 | job96==2 | job96==4

bysort  new_hhnum96: gen work2 = sum(job_temp2)
bysort  new_hhnum96: egen workers2_96 = max(work2)

drop work work2 
drop job_temp*
drop t_hours

replace  job_2nd_days96 = 0 if  job_2nd_days96<0
replace  job_2nd_hours96 = 0 if job_2nd_hours96<0

generate job_2nd_amount96 =  job_2nd_days96 * job_2nd_hours96

bysort  new_hhnum96: gen job_2nd_total_temp = sum(job_2nd_amount96)
bysort  new_hhnum96: egen job_2nd_total96 = max(job_2nd_total_temp)

drop job_2nd_total_temp job_2nd_amount96

generate female=1 if gender ==2
replace female =0 if gender ==1

generate women_hours96=female*hours96

bysort  new_hhnum96: gen women_t_hours96 = sum(women_hours96)
bysort  new_hhnum96: egen women_tot_hours96 = max(women_hours96)

drop women_hours96 women_t_hours96


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

generate ue_var96 = 1 if employed96==0
replace ue_var96=0 if ue_var96!=1 

capture drop  h_weight* max_gross max_net gross_flag* net_flag* p_weight* y111* per_weight* hh_weight* *rent*

save  "$datapath\GiavazziMcMahonReStat\1996.dta", replace

/*clear all*/

*********************************************************************************************************************
