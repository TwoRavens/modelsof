set more off
clear all 
set mem 50m

cd "$datapath\GiavazziMcMahonReStat\"

use "panel.dta", clear

tsset new_hhnum year, yearly

*WHICH CIVIL SERVANTS

replace civil_service=1 if temp_civil_service>0

gen civil_service2=0
replace civil_service2=1 if CS_==1

global CS_use "civil_service"

*CLEANING THE DATA
drop if month<1

replace stay_forever=1 if stay_forever<2
replace stay_forever=0 if stay_forever==2

replace stay_years = 50 if stay_years<0

sort new_hhnum year
by new_hhnum: gen change_save = save_amt[_n]-save_amt[_n-1]
by new_hhnum: gen change_sr_con = sr_con_pos[_n]-sr_con_pos[_n-1]
by new_hhnum: gen change_sr_y = sr_y_pos[_n]-sr_y_pos[_n-1]
by new_hhnum: gen change_sr_c_con = sr_c_con_pos[_n]-sr_c_con_pos[_n-1]
by new_hhnum: gen change_sr_c_y = sr_c_y_pos[_n]-sr_c_y_pos[_n-1]
by new_hhnum: gen change_hours = hours[_n]-hours[_n-1]
by new_hhnum: gen change_women_tot_hours = women_tot_hours[_n]-women_tot_hours[_n-1]

by new_hhnum: gen change_income = (income[_n]/income[_n-1])-1

bysort new_hhnum: egen variability = sd(sr_y_pos)
bysort new_hhnum: egen variability_change = sd(change_sr_y)

*GENERATING THE DIFFERENT CLASSES OF PEOPLE AFFECTED

generate professional=1 if occupation==6 | occupation==11 | occupation==12 /* Doctors/vets, accountant, lawyers*/
replace professional = 0 if professional==.

replace civil_service=0 if civil_service==1 & pension==1
replace self_emp=0 if self_emp==1 & pension==1
replace stay_forever=1 if pension==1 & stay_forever==0

replace self_emp=0 if professional==1

drop if civil_service==1 & self_emp==1
drop if civil_service==1 & stay_forever==0
drop if self_emp==1 & stay_forever==0

generate affected_pop=0
replace affected_pop=1 if self_emp==1
replace affected_pop=2 if professional==1
replace affected_pop=3 if pension==1
replace affected_pop=4 if stay_forever==0
replace affected_pop=5 if civil_service==1

label define affected_code 0 "PAYG individuals" 1 "Self-Employed" 2 "Professional" 3 "Pensioner" 4 "Wishes to Leave Germany" 5 "Civil Servant"
label values affected affected_code

tabulate affected_pop if year==1998

* latabstat new_hhnum if year==1998, by(affected_pop) s(count) cap(Affected Population in GSOEP Sample, 1998) labelwidth(32)

*NOW RECODING TO INCLUDE SELF-EMPLOYED AND PROFESSIONALS TOGETHER
replace affected_pop=2 if affected_pop==1
label define affected_code_2 0 "PAYG individuals" 2 "Professional/Self-Employed" 3 "Pensioner" 4 "Wishes to Leave Germany" 5 "Civil Servant"
label values affected affected_code_2

*GENERATING THE RELEVANT NEW VARIABLES

gen affected = 1
replace affected = 0 if affected_pop>=1 

gen inter_CSreform = 0
replace inter_CSreform =1  if ($CS_use==1 & year>1997) | ($CS_use==1 & year==1997 & month>2 )

gen CS_reform =0 
replace CS_reform =1  if (year>1997) | (year==1997 & month>2 )

generate reform = 1 if (year==1997 & month>8 & affected==1 ) |  (year==1998 & month<10 & affected==1 )
replace reform = 0 if reform==. 

generate revoke = 1 if (year==1998 & month>=10 & affected==1 ) |  (year>=1999 & year<2001 & affected==1 ) /*COULD BE NOVEMBER 1998 when it starts*/
replace revoke = 0 if revoke==. 

generate revoke_d = 1 if (year==1998 & month>=10  ) |  (year>=1999 & year<2001) 
replace revoke_d = 0 if revoke_d==. 

generate reform_d = 1 if (year==1997 & month>8  ) |  (year==1998 & month<10 )
replace reform_d=0 if reform_d==.

*CHOOSING THE SAMPLE

gen zero_saver = 0
replace zero_saver=1 if sr==0

tab zero_saver if year==1998
tab zero_saver if year==1998 & agegrp98<40
tab zero_saver labour_split if year==1998

quietly tabulate year, generate(D_year)

quietly tabulate labour_split, generate(D_labour)

quietly tabulate job, generate(D_job)

bysort new_hhnum: gen balanced=_N if sr_con_pos!=.
replace balanced=0 if balanced==.

rename workers workers_fte
rename workers2_ workers

gen constructor = 0
replace constructor = 1 if occ_industry ==5

drop education0*  

gen foreign = 0
replace foreign = 1 if nationality!=1

quietly tabulate affected_pop, gen(D_pension_status)
keep if  affected_pop==0 | affected_pop==5 

label variable change_sr_y "delSR (% of income)"
label variable change_sr_c_y "delCorrected SR (% of income)"
label variable change_sr_con "delSR (% of cons)"
label variable change_sr_c_con "delCorrected SR (% of cons)"
label variable D_year1 "1995 Dummy"
label variable D_year2 "1996 Dummy"
label variable D_year3 "1997 Dummy"
label variable D_year4 "1998 Dummy"
label variable D_year5 "1999 Dummy"
label variable D_year6 "2000 Dummy"

label variable  affected_pop "Civil Servant / Non-Civil Servant (non-CS)" 

gen D_one_worker=0
bysort new_hhnum: egen max_workers = max(workers)
replace  D_one_worker=1 if max_workers==1

gen D_east = 0
replace D_east = 1 if region_ ==2

gen D_east_contruct = 0
replace D_east_contruct = 0 if D_east==1 & constructor==1

* THE TIMING VARIABLES 

replace reform = 1 if (year==1997 & month>8 & affected==1 ) |  (year==1998 & month<10 & affected==1 )

replace revoke = 1 if (year==1998 & month>7 & affected==1 ) |  (year>=1999 & year<2000 & affected==1 ) | (year==2000 & month<1 & affected==1 ) 

replace revoke_d = 1 if (year==1998 & month>7 ) |  (year>=1999 & year<2000) | (year==2000 & month<1 ) 

replace reform_d = 1 if (year==1997 & month>8  ) |  (year==1998 & month<10 )

rename revoke inter_uncertainty
rename reform inter_kohl
rename revoke_d uncertainty
rename reform_d kohl

label var inter_uncertainty "D(Uncertainty)*D(Treated)" 
label var uncertainty "D(Uncertainty)"
label var inter_kohl "D(Kohl)*D(Treated)"
label var kohl "D(Kohl)"

* SAMPLE SELECTION

drop if year<1994
drop if year>2000

gen data_avail=0
replace data_avail=1 if ue!=. &  change_income!=. &  change_sr_y!=.
drop if data_avail==0

save final.dta, replace
