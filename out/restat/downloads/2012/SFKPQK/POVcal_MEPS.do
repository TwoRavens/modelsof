// PREPARE DATA FOR POVCAL: 2000 MEPS ##############################################

clear
set memory 200m
global path="c:\data"

use "$path\h50.dta", clear
sort dupersid
save "$path\meps_main_temp.dta", replace

gen personal_income=ttlp00
gen age_over_14=0
replace age_over_14=1 if age00x>14
gen age_under_14=0
replace age_under_14=1 if age00x<=14

collapse (sum) personal_income age_over_14 age_under_14, by(duid)
sort duid
save "$path\meps_income.dta", replace

use "$path\meps_main_temp.dta", clear
erase "$path\meps_main_temp.dta"
sort duid
joinby duid using "$path\meps_income.dta"
erase "$path\meps_income.dta"

rename personal_income totalinc
label var totalinc "Combined estimated income of all members in the income unit"

gen oecdscale=0
replace oecdscale=1 if  age_over_14>0
replace oecdscale=oecdscale+(age_over_14-1)*0.5 if age_over_14>=1
replace oecdscale=oecdscale+(age_under_14)*0.3
generate equ_inc=totalinc/oecdscale
replace equ_inc=0 if equ_inc<0

drop if  ttlp00x<0
drop if age00x<16
drop if perwt00f==0

keep equ_inc duid
rename equ_inc income

gen one=1

save "$path\MEPTEMP.dta", replace

local groups "2 3 4 5 6 7 8 9 10 11 12 13 14 15 20 30 40 50"

foreach x of local groups {
	use "$path\MEPTEMP.dta", clear
	xtile dec = income, nq(`x')
	collapse (mean) income (sum) one, by(dec)
	egen sumone=sum(one)
	gen perc=one/sumone*100
	keep perc income
	order perc income
	outfile perc income using meps`x'.dat, replace
}
erase "$path\MEPTEMP.dta"
