/*##############################################*/
/* PREPARE ECHP data for POVCAL			*/
/*##############################################*/

*STATA SETTINGS

clear
set more off
set type double
pause on
set seed 546
set mem 500m

cap program drop grouped
program define grouped

global path="c:\data"

*LOAD DATA

foreach x of numlist 1/15 {

	use "c:\data\ECuity`x'", clear

	if `x'==1 {
		global y="Germany(ECHP)"
	}
	else if `x'==2 {
		global y="Denmark"
	}
	else if `x'==3 {
		global y="Netherlands"
	}
	else if `x'==4 {
		global y="Belgium"
	}
	else if `x'==5 {
		global y="Luxembourg(ECHP)"
	}
	else if `x'==6 {
		global y="France"
	}
	else if `x'==7 {
		global y="UK(ECHP)"
	}
	else if `x'==8 {
		global y="Ireland"
	}
	else if `x'==9 {
		global y="Italy"
	}
	else if `x'==10 {
		global y="Greece"
	}
	else if `x'==11 {
		global y="Spain"
	}
	else if `x'==12 {
		global y="Portugal"
	}
	else if `x'==13 {
		global y="Austria"
	}
	else if `x'==14 {
		global y="Finland"
	}
	else if `x'==15 {
		global y="Sweden"
	}

	*SELECT VARIABLES

	if `x'~=15 {
		replace male=. if sex==.
		bys pid: egen temp=max(male)
		bys pid: egen temp1=min(male)
		drop if temp~=temp1
		bys pid: egen temp2=max(rd003)
		gen temp3=wave*rd003
		bys pid: egen temp4=max(wave) if temp3~=.
		bys pid: egen temp5=max(temp4)
		gen temp6=temp2-temp5+wave
		gen temp7=1 if temp6~=rd003 & rd003~=.
		bys pid: egen temp8=max(temp7)
		drop if temp6<0
		drop if temp8==1
		replace rd003=temp6
		drop temp*
	 	keep if pid~=.
	}

	if `x'==13 {
		keep wave country pid rd003 hh_size totalinc_h pweight hid
		keep if wave==2
	}
	else if `x'==14 {
		keep wave country pid rd003 hh_size totalinc_h pweight hid
		keep if wave==3
	}
	else if `x'==15 {
		keep wave country pid rd003 hh_size totalinc_h pweight hid
		keep if wave==4
	}
	else {
		keep wave country pid rd003 hh_size totalinc_h pweight hid
		keep if wave==1
	}

	/* we keep wave 1 for all countries (preference for earlier waves due to more observations), except for wave 2 (Austria) wave 3 (Finland) and */
	/* wave 4 (Sweden) */

	*TRANSFORM VARIABLES

	rename rd003 age
	recode hh_size -9 -8 = .

	bys hid: egen temp=count(age)
	bys hid: egen temp1=count(temp)
	replace hh_size=. if temp1>temp
	bys hid: egen temp2=count(age) if age<=14 & age~=.
	bys hid: egen age_under_14=max(temp2)
	replace age_under_14=0 if age_under_14==. & age~=. & hh_size~=.
	replace age_under_14=. if temp1>temp
	drop temp*

	gen oecdscale=1+0.5*(hh_size-age_under_14-1)+0.3*age_under_14
	gen eqinc=totalinc_h/oecdscale

	*DROPPING VARS & OBS

	gen drop_ind=0
	for var wave country pid age hh_size eqinc pweight: replace drop_ind=1 if X==.
	replace drop_ind=1 if age<16
	drop if drop_ind>0

	keep eqinc hid
	rename eqinc income

	gen one=1
	save "$path\ECHPTEMP.dta", replace

	local groups "2 3 4 5 6 7 8 9 10 11 12 13 14 15 20 30 40 50"
	foreach y of local groups {
		use "$path\ECHPTEMP.dta", clear
		xtile dec = income, nq(`y')
		collapse (mean) income (sum) one, by(dec)
		egen sumone=sum(one)
		gen perc=one/sumone*100
		keep perc income
		order perc income
		outfile perc income using echp`x'_`y'.dat, replace
	}
	erase "$path\ECHPTEMP.dta"
}
end
grouped
