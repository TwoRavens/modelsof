/*Open log file, set memory, etc*/
set logtype text
set more off
clear all 
set mem 50m
/*log using "$datapath\GiavazziMcMahonReStat\2001 database.smcl", replace*/

/* THIS SECTION DOWNLOADS THE DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr hhnrakt welle qhhmonin qausku  qh4301 qh4302 qh4303 qh4304  qh04 qh06 qh12 qh13 qh15 qh17 qh2501 qh2502 qh26 qh2801 qh40 qh41 qh4201 qh4202 qh4301 qh4302 qh4303 qh4304 qh4305 qh4306 qh4501 qh4505 qh4902 qh46 qh51 qh54 qh5501 qh5502 qh5601 qh5602 qh5702 qh58 using "$datapath\qh.dta"

sort hhnr

describe

rename qhhmonin int_month00
rename hhnr hhnum
rename hhnrakt new_hhnum00
rename welle year
rename qausku pnum
rename qh04 h_change00
rename qh06 tenant00
rename qh12 hse_area00
rename qh13 hse_age00
rename qh15 hse_size00
rename qh17 hse_condition00
rename qh2501 m_rent00 
rename qh2502 norent00
rename qh26 heat_rent00
rename qh2801 other_rent00
rename qh40 prop_rent00
rename qh41 prop2_rent00
rename qh4201 prop_costs00
rename qh4202 prop_mort00
rename qh4301 save_ac00
rename qh4302 save_bs00
rename qh4303 save_la00
rename qh4304 save_fi00
rename qh4305 save_comp00
rename qh4306 save_none00
rename qh4501 win00
rename qh4505 win_amt00
rename qh4902 child_allow00
rename qh46 house_allow00
rename qh51 social_allow00
rename qh54 income00
rename qh5501 loan_pay00
rename qh5502 loan_paym00
rename qh5601 save00
rename qh5602 save_amt00
rename qh5702 food_conm00
rename qh58 cleaner00


/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum00=hhnum
replace hhnum00=new_hhnum00 if new_hhnum00~=hhnum

sort hhnum00

save "$datapath\GiavazziMcMahonReStat\2000h.dta", replace

clear all

******************************************************************************
/* THIS SECTION DOWNLOADS THE HOUSEHOLD WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use  hhnr hhnrakt qhhrf using "$datapath\hhrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename hhnrakt new_hhnum00
rename qhhrf h_weight00

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum00=hhnum
replace hhnum00=new_hhnum00 if new_hhnum00~=hhnum

sort hhnum00

save "$datapath\GiavazziMcMahonReStat\2000h weight.dta", replace

clear all

********************************************************************************************************************

/* USING GENERATED VARIABLES*/

use hhnr persnr qhhnr oeffd00 nation00 lfs00 stib00 month00 autono00 using "$datapath\qpgen.dta"

rename hhnr hhnum
rename persnr pnum
rename qhhnr new_hhnum00

rename  oeffd00 CS_00
rename nation00 nationality00
rename lfs00 lab_force00
rename stib00 occupation_00

generate hhnum00=hhnum
replace hhnum00=new_hhnum00 if new_hhnum00~=hhnum

sort hhnum00

save "$datapath\GiavazziMcMahonReStat\2000 gen.dta", replace

clear all

 



***********************************************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSONAL DATA FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS IT AND RENAMES IT SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr welle qhhnr qp3605 qp0101 qp0102 qp0103 qp6101 qp6102 qp62  qp0104 qp0105 qp0106 qp0107 qp0108 qp0110 qp0111 qp04 qp10 qp05a1 qp05a2 qp05a3 qp05a4  qp05a5  qp05a6 qp05a7 qp4001 qp4901 qp52 qp50 qp5601 qp5602 qp6302 qp6303 qp6304 qp6307 qp6308 qp6315 qp6316 qp6801 qp6802 qp6803 qp7901 qp7902 qp7903 qp7904 qp7905 qp7906 qp7907 qp7908 qp7909 qp7910 qp7911 qp7912 qp7913 qp7914 qp7915 qp7916 qp7917 qp7918 qp80 qp83 qp8401 qp9102 qp95 qp96 qp9801 qp99 qp11801 qp11802 qp11803 qp11804 qp11805 qp11806 qp11807 qp11808 qp11809 qp11810 qp11811 qp13902 qp133 qp13401 qp13402 qp13403 qp05a7  qp05a1	qp05a2	qp05a3	qp05a4	qp05a6  using "$datapath\qp.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename welle year
rename qhhnr new_hhnum00
rename qp0101 sat_health00
rename qp0102 sat_work00
rename qp0103 sat_hsework00
rename qp0104 sat_hh00
rename qp0105 sat_hse00
rename qp0106 sat_leisure00
rename qp0107 sat_childcare00
rename qp0108 sat_goods00
rename qp0110 sat_environ00
rename qp0111 sat_living00
rename qp04 ue00
rename qp10 job00
rename qp4001 jobkm00
rename qp4901 hours_contract_00
rename qp50 hours00
rename qp52 hours_want_00
rename qp5601 g_income00
rename qp5602 n_income00
rename qp6302 g_income2_00
rename qp6303 pension00
rename qp6304 g_pension00
rename qp6307 dole00
rename qp6308 g_dole00
rename qp6315 early_retire00
rename qp6316 g_early_retire00
rename qp6801 education00
rename qp6802 educ_school00
rename qp6803 educ_college00
rename qp7901 wkr_pension_amt00
rename qp7902 miner_pension_amt00
rename qp7903 civil_pension_amt00
rename qp7904 war_pension_amt00
rename qp7905 farmer_pension_amt00
rename qp7906 acc_pension_amt00
rename qp7907 civils_pension_amt00
rename qp7908 comp_pension_amt00
rename qp7909 other_pension_amt00
rename qp7910 wkr_pension2_amt00
rename qp7911 miner_pension2_amt00
rename qp7912 civil_pension2_amt00
rename qp7913 war_pension2_amt00
rename qp7914 farmer_pension2_amt00
rename qp7915 acc_pension2_amt00
rename qp7916 civils_pension2_amt00
rename qp7917 comp_pension2_amt00
rename qp7918 other_pension2_amt00
rename qp80 health_ins00
rename qp83 priv_health_ins00
rename qp8401 priv_health_ins_amt00
rename qp9102 priv_health_ins_cov00
rename qp95 health00
rename qp96 disable00
rename qp9801 doctor00
rename qp99 hospital00
rename qp11801 worry_ec00
rename qp11802 worry_fin00
rename qp11803 worry_health00
rename qp11804 worry_envir00
rename qp11805 worry_peace00
rename qp11806 worry_crime00
rename qp11807 worry_euro00
rename qp11808 worry_immig00
rename qp11809 worry_xeno00
rename qp11810 worry_job00
rename qp11811 worry_other00
rename qp13902 age00
rename qp6101 job_2nd_days00
rename qp6102 job_2nd_hours00
rename qp62 job_2nd_month00
rename qp3605 temp_civil_service00
rename qp133 stay_forever00 
rename qp13401 return_now00
rename qp13402 stay_years00
rename qp13403 stay_unknown00 
rename	qp05a7	hours_other00
rename	qp05a1	hours_job00
rename	qp05a2	hours_errands00
rename	qp05a3	hours_housework00
rename	qp05a4	hours_childcare00
rename	qp05a6	hours_repairs00



gen civil_service00=0
replace civil_service00=1 if temp_civil_service00>2

replace pension00=0 if pension00!=1
replace ue00=0 if ue00==2

replace hours00=0 if hours00<0

/* THIS SECTION MAKES A LIST OF PROPER HOUSEHOLD NUMBERS - FOR THOSE WHO HAVE FORMED NEW HOUSEHOLDS, WE USE THEIR NEW HOUSEHOLD INFORMATION*/

generate hhnum00=hhnum
replace hhnum00=new_hhnum00 if new_hhnum00~=hhnum

/* THIS SECTION CALCUALTES, FOR EACH PERSON, THE TOTAL PENSION BEING RECEIVED BY THEMSELVE AND THEIR DEPENDENTS*/

generate pension_amt00temp =  wkr_pension_amt00+ miner_pension_amt00+ civil_pension_amt00+ war_pension_amt00+ farmer_pension_amt00+ acc_pension_amt00+ civils_pension_amt00+ comp_pension_amt00+ other_pension_amt00+ wkr_pension2_amt00+ miner_pension2_amt00+ civil_pension2_amt00+ war_pension2_amt00+ farmer_pension2_amt00+ acc_pension2_amt00+ civils_pension2_amt00+ civil_pension2_amt00+ war_pension2_amt00+ farmer_pension2_amt00+ acc_pension2_amt00+ civils_pension2_amt00+ comp_pension2_amt00+ other_pension2_amt00

generate pension_amt00 = pension_amt00temp
replace pension_amt00= 0 if pension_amt00temp<=0 

drop pension_amt00temp

/* FINALLY WE SORT AND SAVE THE DATA*/

sort hhnum00

save "$datapath\GiavazziMcMahonReStat\2000p.dta", replace

clear all

*****************************************************************************************

use hhnr persnr sp9402 using "$datapath\sp.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename sp9402 smoke00

sort pnum

save "$datapath\GiavazziMcMahonReStat\2000p_smoke.dta", replace 

use "$datapath\GiavazziMcMahonReStat\2000p.dta" 

sort pnum

merge pnum using "$datapath\GiavazziMcMahonReStat\2000p_smoke.dta", nokeep 

drop _merge

sort hhnum00

save "$datapath\GiavazziMcMahonReStat\2000p.dta", replace

clear all

***************************************************************************************

/* THIS SECTION DOWNLOADS THE PERSON WEIGHTS FROM THE C-DRIVE (FROM CD-ROM)AND THEN SORTS THEM AND RENAMES THEM SO THAT EACH YEAR THE NAMES ARE THE SAME EXCEPT FOR THE YY ENDING, E.G. 01 FOR 2001 DATA.*/

use hhnr persnr qphrf using "$datapath\phrf.dta"

sort hhnr

describe

rename hhnr hhnum
rename persnr pnum
rename qphrf p_weight00

sort hhnum

save "$datapath\GiavazziMcMahonReStat\2000p weight.dta", replace

clear all

***********************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA WITH THE HOUSEHOLD WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\2000h weight.dta"

sort hhnum00

save  "$datapath\GiavazziMcMahonReStat\2000h weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2000h.dta"

sort hhnum00

save  "$datapath\GiavazziMcMahonReStat\2000h.dta", replace

joinby hhnum00 using "$datapath\GiavazziMcMahonReStat\2000h weight.dta" 

sort hhnum00 

save  "$datapath\GiavazziMcMahonReStat\2000hw.dta", replace

clear all

**********************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA WITH THE PERSONAL WEIGHTS*/

use  "$datapath\GiavazziMcMahonReStat\2000p weight.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2000p weight.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2000p.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2000p.dta", replace

joinby pnum using "$datapath\GiavazziMcMahonReStat\2000p weight.dta" 

sort   hhnum00

save  "$datapath\GiavazziMcMahonReStat\2000pw.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE PERSONAL DATA (WITH WEIGHTS) WITH THE CNEF FILE*/

use  "$datapath\GiavazziMcMahonReStat\2000 cnef.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2000 cnef.dta", replace

clear

use  "$datapath\GiavazziMcMahonReStat\2000pw.dta"

sort pnum

save  "$datapath\GiavazziMcMahonReStat\2000pw.dta", replace

merge pnum using  "$datapath\GiavazziMcMahonReStat\2000 cnef.dta"

sort   hhnum00

drop if _merge~=3

drop _merge

save  "$datapath\GiavazziMcMahonReStat\2000pw cnef.dta", replace

clear all

*******************************************************************************************************************

/* THIS SECTION COMBINES THE HOUSEHOLD DATA (WITH WEIGHTS) WITH THE CNEF PERSONAL DATA (WITH WEIGHTS)*/

use "$datapath\GiavazziMcMahonReStat\2000pw cnef.dta"

sort   hhnum00 

merge hhnum00 using "$datapath\GiavazziMcMahonReStat\2000hw.dta"

sort hhnum00 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

*NOW ADD GENERATED VARIABLES

merge hhnum00 using "$datapath\GiavazziMcMahonReStat\00extra.dta"

sort hhnum00 

drop if _merge~=3 /*Only keeps the data that appears in both the household data and has a coresponding variable in the CNEF data after it has been merged with the person data*/

drop _merge

bysort new_hhnum: egen max_gross = max(cnef_g_income00)
bysort new_hhnum: egen max_net = max(cnef_g_income00)

gen D_main_gross00 = 0
gen D_main_net00 = 0
replace D_main_gross00 = 1 if max_gross==cnef_g_income00
replace D_main_net00 = 1 if max_net==cnef_g_income00

generate job_temp = 0
replace job_temp = 1 if job00==1
replace job_temp = 1 if job00==2
replace job_temp = 1 if job00==4

gen temp_ret = 0
replace  temp_ret =1 if pension00==1
bysort  new_hhnum00: gen ret = sum(temp_ret)
bysort  new_hhnum00: egen retired_hh00 = max(ret)
drop ret temp_ret 

gen temp_drop = 1 if temp_civil_service00>0
bysort new_hhnum00: gen temp_drop2 = sum(temp_drop)
bysort new_hhnum00: egen num_CS00 = max(temp_drop2)
drop temp_drop*


bysort  new_hhnum00: gen work = sum(job_temp)
bysort  new_hhnum00: egen workers00 = max(work)

bysort  new_hhnum00: gen t_hours00 = sum(hours00)
bysort  new_hhnum00: egen tot_hours00 = max(hours00)

gen additional_hours00 = tot_hours00 - hours00
replace additional_hours00=0 if additional_hours00<0

gen worker_ratio00 = workers00/ (people_hh00 -  children_hh00)*100


generate job_temp2 = 0
replace job_temp2 = 1 if job00==1 | job00==2 | job00==4

bysort  new_hhnum00: gen work2 = sum(job_temp2)
bysort  new_hhnum00: egen workers2_00 = max(work2)

drop work work2 
drop job_temp*
drop t_hours

replace  job_2nd_days00 = 0 if  job_2nd_days00<0

replace  job_2nd_hours00 = 0 if job_2nd_hours00<0

replace  job_2nd_month00 = 0 if job_2nd_month00<0

generate job_2nd_amount00 =  job_2nd_days00 * job_2nd_hours00 /* job_2nd_month02*/

bysort  new_hhnum00: gen job_2nd_total_temp = sum(job_2nd_amount00)
bysort  new_hhnum00: egen job_2nd_total00 = max(job_2nd_total_temp)

drop job_2nd_total_temp job_2nd_amount00

generate female=1 if gender ==2
replace female =0 if gender ==1

generate women_hours00=female*hours00

bysort  new_hhnum00: gen women_t_hours00 = sum(women_hours00)
bysort  new_hhnum00: egen women_tot_hours00 = max(women_hours00)

drop women_hours00 women_t_hours00


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

generate ue_var00 = 1 if job00==7
replace ue_var00=0 if ue_var00!=1

capture drop  h_weight* max_gross max_net gross_flag* net_flag* p_weight* y111* per_weight* hh_weight* *rent*

save  "$datapath\GiavazziMcMahonReStat\2000.dta", replace

/*clear all*/

*********************************************************************************************************************
