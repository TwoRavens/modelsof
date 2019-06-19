set more off
clear all 
set mem 50m

cd "$datapath\GiavazziMcMahonReStat\"

capture program drop make_sr
program define make_sr
		while "`1'"~="" {
		generate sr`1' =  save_amt`1'/income`1' if save_amt`1'>=0	
		replace sr`1' = 0 if save_amt`1'<0
		generate save`1'_cnef = sr*hh_y_postgov`1'
		generate con`1'_cnef =  hh_y_postgov`1' - save`1'_cnef if save`1'_cnef>=0
		generate hh_y_earn_`1' = hh_y_pregov`1' + hh_pub_trans`1' - hh_fed_taxes`1' - hh_priv_pension`1' 
		gen ss_contrib_rate`1' = hh_ss_taxes`1'/con`1'_cnef*100  /*if save02_cnef>0*/
		gen pub_pen_rate`1' = hh_ss_pension`1'/con`1'_cnef*100 /*if save02_cnef>0*/
		gen pri_pen_rate`1' = hh_priv_pension`1'/con`1'_cnef*100 /*if save02_cnef>0*/
		gen correction`1' =  ss_contrib_rate`1' - pub_pen_rate`1' - pri_pen_rate`1'
		generate save`1'_fit = hh_y_postgov`1' - con`1'_cnef 
		generate save`1'_fit_corrected = hh_y_earn_`1' - con`1'_cnef  if save`1'_cnef==0
		replace save`1'_fit_corrected = hh_y_earn_`1' - con`1'_cnef  if save`1'_cnef>=0
		generate sr_y_pos`1'=save`1'_fit/hh_y_postgov`1'*100 if save`1'_cnef>=0
		generate sr_c_y_pos`1'=save`1'_fit_corrected/hh_y_postgov`1'*100 if save`1'_cnef>=0
		generate sr_con_pos`1'=save`1'_fit/con`1'_cnef*100 if save`1'_cnef>=0
		generate sr_c_con_pos`1'=save`1'_fit_corrected/con`1'_cnef*100 if save`1'_cnef>=0
		replace hh_y_postgov`1' = hh_y_postgov`1' /1000
		rename new_hhnum`1' new_hhnum
		replace hours`1' = 0 if hours`1'<0
		replace hours`1' = hours`1'/10
		macro shift
		}
	end
	
capture program drop compile1990
program define  compile1990
local i=94
while `i'<=99 {
	use "$datapath\GiavazziMcMahonReStat\\19`i'.dta"
	rename pnum pnum`i'
	make_sr `i'
	sort  new_hhnum
	save "$datapath\GiavazziMcMahonReStat\\19`i'_panel.dta", replace
	local i=`i'+1
	}
end

capture program drop compile2000
program define  compile2000
local i=0
while `i'<=4 {
	use "$datapath\GiavazziMcMahonReStat\\200`i'.dta"
	rename pnum pnum0`i'
	make_sr 0`i'
	sort  new_hhnum
	save "$datapath\GiavazziMcMahonReStat\\200`i'_panel.dta", replace
	local i=`i'+1
	}
end

compile1990
compile2000

do "$repfiles\3b - 2002 reform variables creation.do"

local i=1994
while `i'<=2001 {
	joinby new_hhnum using "$datapath\GiavazziMcMahonReStat\\`i'_panel.dta" , unmatched(both) _merge(merge`i')
	local i=`i'+1
	}

keep hhnum pnum* year new_hhnum age02 relation* subsample_id* per_weight* hh_weight* num_CS* worry_ec* worry_job* int_month* education* CS_* nationality*  food98 lab_force* occupation_* civil_service*  sr* income*  women_tot_hours* temp* save_*  agegrp02  gender*  hse_size* hse_area* marital* region_* state_* job_2nd_total* D_* pension_reform02 workers* finsecure_old97  finsecure_old02 worry_fin* self_emp ue_var* hh_y_earn_* concerned_privpen02 contribute_morepriv02 state_SS_important02 support_pen02  ss_contrib_rate* pub_pen_rate* pri_pen_rate* correction*  hh_y_postgov*  sr_c_con_pos* ue* sr_con_pos* hours*  retired*  sr_c_y_pos*  sr_y_pos*  additional_hours* children_hh* job* pension* people_hh* tot_hours* worker_ratio*  occupation* occ_industry* stay_forever* return_now* stay_years* stay_unknown*  D_main_gross* D_main_net* gross_inc* net_inc*

drop  hours_contract_02 hours_want_02 hours_contract_00 hours_want_00 year save_comp* save_none* save_Oth* per_weight* hh_weight*  job_2nd_days*  job_2nd_hours*  job_2nd_month*  food98 jobkm* job_2nd_none job_2nd_family job_2nd_regular job_2nd_odd pension_amt*  retired02

sort new_hhnum

drop if new_hhnum==new_hhnum[_n-1]

drop ue

reshape long pnum hh_y_postgov ue education_years int_month subsample_id relation_hh worry_job worry_ec CS_ nationality stay_forever D_cinema  D_cultural  D_politics  D_religon  D_sports  hours_childcare  hours_errands  hours_housework  hours_job  hours_other  hours_repairs  return_now stay_years stay_unknown  lab_force occupation_ save_amt sr income civil_service temp_civil_service ue_var hh_y_earn_ sr_y_pos  save_ac save_bs save_la save_fi women_tot_hours gender  hse_size hse_area marital region_ state_ job_2nd_total  retired_hh sr_c_y_pos sr_con_pos worry_fin sr_c_con_pos hours  pub_pen_rate pri_pen_rate correction ss_contrib_rate  additional_hours children_hh job pension people_hh tot_hours workers workers2_ worker_ratio /*worry_crime worry_peace worry_envir worry_job*/ occupation occ_industry D_main_gross D_main_net gross_inc net_inc num_CS , i( new_hhnum ) j( year 94  95 96 97 98 99 00 01 02 /*03 04*/ )

replace year = 1994 if year ==94
replace year = 1995 if year ==95
replace year = 1996 if year ==96
replace year = 1997 if year ==97
replace year = 1998 if year ==98
replace year = 1999 if year ==99
replace year = 2000 if year ==0
replace year = 2001 if year ==1
replace year = 2002 if year ==2
replace year = 2003 if year ==3
replace year = 2004 if year ==4

replace finsecure_old97 = 0 if finsecure_old97 <0
replace finsecure_old97 = 0 if finsecure_old97 ==7
replace finsecure_old02 = 0 if finsecure_old02 <0

gen female = 0
replace female = 1 if gender==2

replace  tot_hours =  tot_hours/10
replace additional_hours = additional_hours/10

generate women_head_hours=hours if female==1
replace women_head_hours=hours if female==0

replace women_tot_hours = women_tot_hours/10
generate  women_additonal_hours = women_tot_hours - women_head_hours
replace women_additonal_hours = 0 if women_additonal_hours<0

generate adjustment = 0 if year==2002
replace adjustment = 1 if  year==2003
replace adjustment = 2 if  year==2004
replace adjustment = -1 if  year==2001
replace adjustment = -2 if  year==2000
replace adjustment = -3 if  year==1999
replace adjustment = -4 if  year==1998
replace adjustment = -5 if  year==1997
replace adjustment = -6 if  year==1996
replace adjustment = -7 if  year==1995
replace adjustment = -8 if  year==1994

bysort  pnum: generate age = age02 + adjustment

gen agegrp=75 if age<=82
replace agegrp=70 if age>=68&age<=72
replace agegrp=65 if age>=63&age<=67
replace agegrp=60 if age>=58&age<=62
replace agegrp=55 if age>=53&age<=57
replace agegrp=50 if age>=48&age<=52
replace agegrp=45 if age>=43&age<=47
replace agegrp=40 if age>=38&age<=42
replace agegrp=35 if age>=33&age<=37
replace agegrp=30 if age>=28&age<=32
replace agegrp=25 if age>=23&age<=27
replace agegrp=20 if age<=22

drop if age < 20

gen temp_age=age if year==1998
bysort new_hhnum: egen temp_age2= max(temp_age)
gen age98=temp_age2
drop temp_age temp_age2

*1998 age group variable to ADD 
gen agegrp98=75 if age98<=82
replace agegrp98=70 if age98>=68&age98<=72
replace agegrp98=65 if age98>=63&age98<=67
replace agegrp98=60 if age98>=58&age98<=62
replace agegrp98=55 if age98>=53&age98<=57
replace agegrp98=50 if age98>=48&age98<=52
replace agegrp98=45 if age98>=43&age98<=47
replace agegrp98=40 if age98>=38&age98<=42
replace agegrp98=35 if age98>=33&age98<=37
replace agegrp98=30 if age98>=28&age98<=32
replace agegrp98=25 if age98>=23&age98<=27
replace agegrp98=20 if age98<=22

* THIS WOULD REPLACE THE MISSING SAVING RATE PEOPLE WITH 
foreach var in  save_ac save_bs save_la save_fi  /*sr_y_pos sr_c_y_pos sr_con_pos sr_c_con_pos*/ {
replace `var'=0 if `var'<0  | `var'==.
}

drop if int_month<0
rename int_month month

gen full_time = 0
replace full_time = 1 if job==1

gen part_time = 0
replace part_time=1 if job==2 | job==4

gen unemployed = ue
gen retired= pension

gen labour_split=0
replace labour_split = 3 if part_time==1
replace labour_split = 4 if full_time==1
replace labour_split = 2 if ue==1
replace labour_split = 1 if pension==1

*Labour split codes
label define labsplitcode 0 "Out of labour force" 1 "Retired" 2 "Registered Unemployed" 3 "Part-time employed" 4 "Full-time employed"
label values labour_split labsplitcode

tab labour_split

save "$datapath\GiavazziMcMahonReStat\panel.dta", replace
