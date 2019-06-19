*************************************************************************
* Almond, Hoynes, and Schanzenbach, 					*
* "Inside the War on Poverty: The Impact of the Food Stamp Program on Birth Outcomes" *
*Review of Economics and Statistics, May 2011, Vol. 93, No. 2: 387-403. * 
*************************************************************************

************************
* makenat.do
* takes raw natality detail files and makes .dta files
************************

drop _all
set memory 2000m
set more off
capture log close


******************************
*1969-1977 natality detail files
******************************

* Natality data available from NCHS or NBER
*	http://www.cdc.gov/nchs/nvss.htm
*	http://www.nber.org/data/vital-statistics-natality-data.html

forvalues i=1969(1)1977 {

capture label drop _all

shell gunzip nat`i'.txt

drop _all

# delimit ;
infix 
str	res_state	13-14
str	res_county	15-17
str	res_city	18-20
	sex		35-35
	attend		36-36
	mom_race	38-38
	mom_age		41-42
	nchildltot	61-62
	father_age	69-70
	bweight		73-76
	plurality	81-81
	month		84-85
	gest		93-94
	mom_ed		98-99
	legit		107-107
	mom_bpl		138-139
	malformation	142-142
	flag_legit	146-146
	flag_ed		147-147
	flag_lmp	148-148
	recordweight	208-208 
	using nat`i'.txt;
#delimit cr

dis "number of observations read for `i'"
count

*these labels come from natality dict that I created for ease
label var	res_state	"State of Residence"
label var	res_county	"County of Residence"
label var	res_city	"City of Residence"
label var	sex		"Sex of child"
label var	attend		"Attendant at birth"
label var	mom_race	"Race of mother"
label var	mom_age		"Age of mother"
label var	nchildltot	"Number of children born alive"
label var	bweight		"Weight at birth"
label var	month		"Month of birth"
label var	gest		"Gestation period (weeks)"
label var	mom_ed		"Mother's education"
label var	legit		"Legitimacy"
label var	mom_bpl		"Mother's place of birth"
label var	flag_legit	"State (residence) reports legitimacy"
label var	flag_ed		"State (residence) reports parents education"
label var	flag_lmp	"State (residence) reports lmp/gest"
label var	recordweight	"record weight (1 - 100%, 2 - 50%)"

gen year=`i'
label var year "Year of birth"

*drop foreign residents, then destring
drop if res_county=="ZZZ"
destring res_*, replace

*vitals state #'s are in alphabetical order
label define res_statelbl 1 "Alabama"
label define res_statelbl 2 "Alaska", add
label define res_statelbl 3 "Arizona", add
label define res_statelbl 4 "Arkansas", add
label define res_statelbl 5 "California", add
label define res_statelbl 6 "Colorado", add
label define res_statelbl 7 "Connecticut", add
label define res_statelbl 8 "Delaware", add
label define res_statelbl 9 "District of Columbia", add
label define res_statelbl 10 "Florida", add
label define res_statelbl 11 "Georgia", add
label define res_statelbl 12 "Hawaii", add
label define res_statelbl 13 "Idaho", add
label define res_statelbl 14 "Illinois", add
label define res_statelbl 15 "Indiana", add
label define res_statelbl 16 "Iowa", add
label define res_statelbl 17 "Kansas", add
label define res_statelbl 18 "Kentucky", add
label define res_statelbl 19 "Louisiana", add
label define res_statelbl 20 "Maine", add
label define res_statelbl 21 "Maryland", add
label define res_statelbl 22 "Massachusetts", add
label define res_statelbl 23 "Michigan", add
label define res_statelbl 24 "Minnesota", add
label define res_statelbl 25 "Mississippi", add
label define res_statelbl 26 "Missouri", add
label define res_statelbl 27 "Montana", add
label define res_statelbl 28 "Nebraska", add
label define res_statelbl 29 "Nevada", add
label define res_statelbl 30 "New Hampshire", add
label define res_statelbl 31 "New Jersey", add
label define res_statelbl 32 "New Mexico", add
label define res_statelbl 33 "New York", add
label define res_statelbl 34 "North Carolina", add
label define res_statelbl 35 "North Dakota", add
label define res_statelbl 36 "Ohio", add
label define res_statelbl 37 "Oklahoma", add
label define res_statelbl 38 "Oregon", add
label define res_statelbl 39 "Pennsylvania", add
label define res_statelbl 40 "Rhode island", add
label define res_statelbl 41 "South Carolina", add
label define res_statelbl 42 "South Dakota", add
label define res_statelbl 43 "Tennessee", add
label define res_statelbl 44 "Texas", add
label define res_statelbl 45 "Utah", add
label define res_statelbl 46 "Vermont", add
label define res_statelbl 47 "Virginia", add
label define res_statelbl 48 "Washington", add
label define res_statelbl 49 "West Virginia", add
label define res_statelbl 50 "Wisconsin", add
label define res_statelbl 51 "Wyoming", add
label values res_state res_statelbl

tab res_state

*RACE
replace mom_race=. if mom_race==9
*other races
replace mom_race=9 if (mom_race!=1 & mom_race!=2)
label define mom_racelbl 1 "white"
label define mom_racelbl 2 "black", add
label define mom_racelbl 9 "other", add
label values mom_race mom_racelbl

*MOM AGE
tab mom_age
*make two age groups for mother 
*<24, >=24
gen mom_agegroup=1 if mom_age<24
replace mom_agegroup=2 if mom_age>=24
label define mom_agegrouplbl 1 "mom's age <24"
label define mom_agegrouplbl 2 "mom's age >=24", add
label values mom_agegroup mom_agegrouplbl

*MOM AGE- detailed (for fertility regressions); 
gen mom_agedet=1 if mom_age>=15 & mom_age<=19
replace mom_agedet=2 if mom_age>=20 & mom_age<=24
replace mom_agedet=3 if mom_age>=25 & mom_age<=34
replace mom_agedet=4 if mom_age>=35 & mom_age<=44
label define mom_agedetlbl 1 "mom's age 15-19"
label define mom_agedetlbl 2 "mom's age 20-24", add
label define mom_agedetlbl 3 "mom's age 25-34", add
label define mom_agedetlbl 4 "mom's age 35-44", add
label values mom_agedet mom_agedetlbl

*NO FATHER
tab father_age legit, missing
*if father's age is missing or you're illegimate you have no father
gen byte havefather = 1 if father_age!=99 & legit!=2
replace havefather = 2 if father_age==99|legit==2
tab havefather
drop father_age

*NUMBER OF PRIOR CHILDREN
replace nchildltot = . if nchildltot>54
gen secondkid = 1 if nchildltot>1 & nchildltot!=.
replace secondkid = 0 if nchildltot==1

*BIRTHWEIGHT
replace bweight=. if bweight==9999
sum bweight, detail

foreach weight in 4500 4000 3750 3500 3250 3000 2500 2000 1500 {
gen bw`weight'=1 if bweight<`weight'
replace bw`weight'=0 if bweight>=`weight'
replace bw`weight'=. if bweight==.
label var bw`weight' "birthweight < `weight'g"
}

*PLURALITY
gen twin = 0
replace twin = 1 if plurality==2
gen multiple = plurality>1

*ATTENDANT AT BIRTH
tab attend
label define attendlbl 1 "birth at hospital"
label define attendlbl 2 "attended by physician", add
label define attendlbl 3 "attended by midwife", add
label define attendlbl 4 "attended by other (not specified)", add
label values attend attendlbl

forvalues j=1(1)4 {
gen attend`j'=1 if attend==`j'
replace attend`j'=0 if attend!=`j'
}
label var attend1 "birth at hospital"
label var attend2 "attended by physician"
label var attend3 "attended by midwife"
label var attend4 "attended by other (not specified)"

gen byte hospital = attend1
gen byte hospitalphys = attend1==1|attend2==1

*SEX OF CHILD
label define sexlbl 1 "male"
label define sexlbl 2 "female", add
label values sex sexlbl

*EDUCATION
tab mom_ed
replace mom_ed=. if mom_ed>20

*less than hs
gen mom_edgroup=1 if mom_ed<12

*hs
replace mom_edgroup=2 if mom_ed==12

*more than hs
replace mom_edgroup=3 if mom_ed>12

*missing
replace mom_edgroup=. if mom_ed==.

tab mom_edgroup
label var mom_edgroup "Mom's education group"
label define mom_edgrouplbl 1 "less than hs"
label define mom_edgrouplbl 2 "hs", add
label define mom_edgrouplbl 3 "more than hs", add
label values mom_edgroup mom_edgrouplbl

gen byte mom_hsorless = mom_ed<=12
replace mom_hsorless = . if mom_ed==.

*GESTATION
tab gest
replace gest=. if gest==0|gest>52

*less than 37
gen gest37=1 if gest<37
replace gest37=0 if gest>=37
replace gest37=. if gest==.

*less than 32
gen gest32=1 if gest<32
replace gest32=0 if gest>=32
replace gest32=. if gest==.

*LEGITIMATE BIRTHS
tab legit
replace legit=. if legit==9|legit==8
label define legitlbl 1 "legitimate"
label define legitlbl 2 "illegitimate", add
label values legit legitlbl

*CONGENITAL MALFORMATION
gen congenital = .
replace congenital = 1 if malformation==1|malformation==2
replace congenital = 0 if malformation==0

*fix sampleweight b/c some states report 50% samples (by state of occurence)
*note that before 1972 - all states were 50% samples and sampleweight variable was not reported
replace recordweight=2 if recordweight==.|recordweight==0

*this is used in to sum up to get N in mergenat.do (do not weight here - I weight in collapse command)
gen nbirths=1

gen quarter=1 if month==1|month==2|month==3
replace quarter=2 if month==4|month==5|month==6
replace quarter=3 if month==7|month==8|month==9
replace quarter=4 if month==10|month==11|month==12
label var quarter "Quarter of birth"

compress

save nattest`i'.dta, replace

sum

shell gzip nat`i'.txt
}


log close

