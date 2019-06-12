
set more off
clear


insheet using LEAD_PVD_ARRESTS_20160106.csv,delimiter(" ") names

gen male=sex=="Male"
tab male

desc


/* gen crime outcomes*/

destring arrest_year*,replace force
gen agearrest=arrest_year1-birth_year
label var agearrest "Age at first arrest"

egen numarrests=rownonmiss(arrest_year*)
label var numarrests "Number of Arrests"

local x=1
while `x'<=26 {
gen violent`x'=crime_type`x'=="Violent"
local x=`x'+1
}

egen numviolent=rowtotal(violent*)
label var numviolent "Number of violent arrest"

gen anyviolent=numviolent>=1 
label var anyviolent "Any violent arrest"



gen anyarrest=1
label var anyarrest "Any arrest"
gen placeofarrest="pvd"

rename geoid10 tract_c
rename race race_a
keep pid birth_year agearrest numviolent anyviolent numarrests male anyarrest age_at_test birth_year test_year max_test_result tract_c race_a
rename age_at_test age_at_test_c
rename test_year test_year_c
rename birth_year birth_year_c
label var age_at_test_c "Age at lead test - crime data"
label var test_year_c "Year of lead test - crime data"
label var birth_year_c "Year of birth - crime data"

sort pid
save pvdarrests.dta,replace


clear
insheet using LEAD_WOONSOCKET_ARRESTS_20160106.csv, delimiter(" ") names

desc, full



gen male=sex=="M"
tab male

/* gen crime outcomes*/

destring arrest_year*,replace force
gen agearrest=arrest_year100-birth_year
label var agearrest "Age at first arrest"

egen numarrests=rownonmiss(arrest_year*)
label var numarrests "Number of Arrests"

local x=100
while `x'<=3800 {
gen violent`x'=ucroffensecodes`x'=="11A FORCIBLE RAPE" | ucroffensecodes`x'=="11B FORCIBLE SODOMY" | ucroffensecodes`x'=="120 ROBBERY" | ucroffensecodes`x'=="13A AGGRAVATED ASSAULT" | ucroffensecodes`x'=="13B SIMPLE ASSAULT" | ucroffensecodes`x'=="13C INTIMIDATION" |  ucroffensecodes`x'=="11D FORCIBLE FONDLING (CHILD)" 
local x=`x'+100
}

egen numviolent=rowtotal(violent*)
label var numviolent "Number of violent crimes"

gen anyviolent=numviolent>=1 
label var anyviolent "Any violent crime"



gen anyarrest=1
label var anyarrest "Any arrest"

rename geoid10 tract_c
rename race race_b
keep pid birth_year agearrest numviolent anyviolent numarrests male anyarrest age_at_test birth_year test_year max_test_result tract_c race_b
rename age_at_test age_at_test_c
rename test_year test_year_c
rename birth_year birth_year_c
label var age_at_test_c "Age at lead test - crime data"
label var test_year_c "Year of lead test - crime data"
label var birth_year_c "Year of birth - crime data"

sort pid
save woonarrests.dta,replace
gen placeofarrest="woon"

merge pid using pvdarrests.dta
tab _merge

preserve
keep if _merge==1 | _merge==2
drop _merge
sort pid
save arrests.dta,replace

restore
keep if _merge==3
drop _merge
sort pid
save tempcrime.dta,replace

rename agearrest agearrestW
rename numarrests numarrestsW
rename numviolent numviolentW
rename anyviolent anyviolentW

replace placeofarrest="both"
drop birth_year
sort pid
merge pid using pvdarrests.dta
tab _merge
keep if _merge==3
drop _merge

replace numviolent=numviolent+numviolentW
replace numarrests=numarrests+numarrestsW 
replace agearrest=agearrestW if agearrestW<agearrest
replace anyviolent=1 if anyviolentW==1
drop numviolentW numarrestsW agearrestW anyviolentW
sort pid

count

append using arrests.dta
count
desc
summ
codebook pid
replace placeofarrest="pvd" if placeofarrest==""
sort pid
save arrests.dta,replace


erase tempcrime.dta

clear

insheet using LEAD_DCYF_SCHOOLS_20160106.csv, delimiter(" ") names

gen rits=1
gen numrits=1
gen lengthrits=.
gen ageatrits=enroll_year1-birth_year
destring enroll_year*,replace force
label var rits "RI Training School"
label var ageatrits "Approx age at first RITS"
label var numrits "Number of admissions to RITS"

local x=2
while `x'<=9 {
destring enroll_year`x',replace
replace numrits=`x' if enroll_year`x'~=.
local x=`x'+1
}



gen male=sex1=="Male"
rename geoid10 tract_c

keep pid age_at_test test_year max_test_result rits numrits ageatrits birth_year male tract_c 
rename age_at_test age_at_test_c
rename test_year test_year_c
rename birth_year birth_year_c
label var age_at_test_c "Age at lead test - crime data"
label var test_year_c "Year of lead test - crime data"
label var birth_year_c "Year of birth - crime data"
label var ageatrits "Age at first admission to RITS"
label var numrits "Number of admissions to RITS"
label var rits "Admission to RITS"


sort pid
save rits.dta,replace

clear

insheet using LEAD_RIDOC_COMMITS_20160107.csv, delimiter(" ") names


gen male=sex=="M"
rename geoid10 tract_c
gen ridoc=1
rename race race_d
destring admin_year*,replace force
gen ageatadmit=admin_year1-birth_year
keep pid age_at_test test_year max_test_result birth_year male tract_c ridoc race_d ageatadmit
rename age_at_test age_at_test_c
rename test_year test_year_c
rename birth_year birth_year_c
label var age_at_test_c "Age at lead test - crime data"
label var test_year_c "Year of lead test - crime data"
label var birth_year_c "Year of birth - crime data"
label var ridoc "Admission to RIDOC"
label var ageatadmit "Aga at admission to RIDOC"

sort pid
save ridoc.dta,replace



/* merge all crime data*/

clear
use arrests.dta
merge pid using rits.dta
tab _merge
replace rits=0 if rits==.
replace numrits=0 if numrits==.
rename _merge mergerits
sort pid
merge pid using ridoc.dta
tab _merge
replace ridoc=0 if ridoc==. 

replace anyarrest=0 if anyarrest==. 

gen anycrime=1 
gen agecrime=agearrest 
replace agecrime= ageatrits if agecrime==. 
replace agecrime=ageatadmit if agecrime==. 


cap drop _merge
cap drop x race_b race_a race_d

gen x=string(pid)
rename pid pid_num
rename x pid
sort pid
save allcrime.dta,replace

