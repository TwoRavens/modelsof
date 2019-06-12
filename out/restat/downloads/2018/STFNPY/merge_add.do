clear
set more off
set mem 4000m
cap log close
log using merge_add.log,replace

use less_add.dta
sort pid
merge pid using ride_full.dta
tab _merge


drop if _merge==2
rename _merge merge_less_ride
label var merge_less_ride "Merge of LESS and RIDE data"
sort pid
merge pid using level1.dta
tab _merge
drop if _merge==2


rename _merge merge_lessride_level1
label var merge_lessride_level1 "Merge of LESS/RIDE and level 1 data" 
tab merge_lessride_level1
gen mergeall=.
replace mergeall=1 if ride==1 & less==1 & level1==1
replace mergeall=2 if less==1 & ride==1 & level1==.
replace mergeall=3 if level1==1 & less==1 & ride==.
replace mergeall=4 if level1==1 & ride==1 & less==.
replace mergeall=5 if level1==1 & ride==. & less==.
replace mergeall=6 if level1==. & ride==. & less==1
replace mergeall=7 if level1==. & ride==1 & less==.

replace birth_year=year(approxdob) if birth_year==. 
gen ride_yob=schoolyear1-6
replace ride_yob=schoolyear2-7 if ride_yob==. 
replace ride_yob=schoolyear3-8 if ride_yob==. 
replace ride_yob=schoolyear4-9 if ride_yob==. 
replace ride_yob=schoolyear5-10 if ride_yob==. 
replace ride_yob=schoolyear6-11 if ride_yob==. 
replace ride_yob=schoolyear7-12 if ride_yob==. 
replace ride_yob=schoolyear8-13 if ride_yob==. 
replace ride_yob=schoolyear9-14 if ride_yob==. 
replace ride_yob=schoolyear10-15 if ride_yob==. 
replace ride_yob=schoolyear11-16 if ride_yob==. 
replace ride_yob=schoolyear12-17 if ride_yob==. 


label define mergel 1 "Ride & Less & Level 1" 2 "Ride & Less" 3 "Less & level 1" 4 "level 1 & Ride" 5 "Level 1 only" 6 "Lead only" 7 "Ride only"
label values mergeall mergel

replace ride=0 if ride==. 
replace level1=0 if level1==. 
replace less=0 if less==. 

local x=0
while `x'<=72 {
gen lnlead`x'=ln(test_result`x'+1)
local x=`x'+1
}
egen gmean = rowmean(lnlead*)
replace gmean = exp(gmean)
replace gmean=gmean-1
label var gmean "Geometric Mean of Lead"


/* IVs - only traffic*/



gen tr=substr(firsttract,5,7)
gen bl=substr(firsttract,5,8)
gen yr=birth_year-1987
destring tr,replace
destring bl,replace

label var tr "Tract of first test"
label var bl "Block of first test"

/*yob*/
tab birth_year, gen(yob)

local x=1
while `x'<=17 {
local z=1987+`x'
label var yob`x' "Born in `z'"
local x=`x'+1
}

/* race of child*/

gen race=raceb0
local x=1
while `x'<=12 {
replace race=raceb`x' if race==. 
local x=`x'+1
}

replace race=mom_race if (race==. | race==5) & mom_race~=.  
label values race mother_racel

replace black=race==2
replace white=race==1
replace hisp=race==3
replace asian=race==4
replace other=race==5

label var black "African American"
label var white "White"
label var hisp "Hispanic"
label var asian "Asian"
label var other "Unknown/other race"

egen readavg=rowmean(read_score*)
label var readavg "Average reading score"

gen bwmiss=bw==. 
gen momedumiss=momedu==. 
gen marriedmiss=married==. 
gen bomiss=bo==. 
gen momagemiss=momage==. 
label var bwmiss "Birth weight missing- imputed"
label var momedumiss "Maternal education missing - imputed"

summ bw momedu married bo momage

label var bw "Birth weight in kg"
label var married "Married at birth"
label var bo "Birth order"
label var momage "Maternal age"

replace bw=3328 if bw==. & birth_year>=1997
replace momedu=13.1 if momedu==. & birth_year>=1997
replace married=1 if married==. & birth_year>=1997
replace bo=2 if bo==. & birth_year>=1997
replace momage=28 if momage==. & birth_year>=1997

replace bw=bw/1000

gen male=male_ride 
label var male "Male"
label var male_ride "Male"

keep if less==1 & ride==1

gen numinfractb=numinfract
replace numinfractb=10 if numinfract>=10 & numinfract~=. 
label var numinfractb "Number of infractions"

egen numyears=rownonmiss(new_school_id*)
label var numyears "Number of years in school data"

egen numyears_read=rownonmiss(read_score*)
label var numyears "Number of years with test scores"


gen suspendoutb=suspendout 
replace suspendoutb=10 if suspendout>=10 & suspendout~=. 

gen add=substr(firstaddress,-12,12)
destring add, replace force
codebook firstaddress add
label var add "Address ID"

gen mom_id=real(mother_id)

gen momlths=momedu<12
gen momhs=momedu==12
gen momcoll=momedu>=16 & momedu~=. 
label var momlths "Mother <HS"
label var momhs "Mother HS grad"
label var momcoll "Mother College+"

egen avglevel=rowmean(test_result*)
label var avglevel "Average lead level"
cap drop_merge

/* generate inlead*/

gen ageatfirsttest=.
gen inlead=0

local x=0
while `x'<=72 {
replace ageatfirsttest=`x' if firstdatetest==lead_date`x'
local x=`x'+`
}


local x=0
while `x'<=72 {
replace inlead=1 if ageatfirsttest==`x' & certdate`x'<=lead_date`x'
local x=`x'+1
}

gen evercert=0

local x=0
while `x'<=72 {
replace evercert=1 if ageatfirsttest==`x' & certdate`x'~=.
local x=`x'+1
}




label var evercert "Home ever had a certificate"
label var inlead "Certificate in home at time of first lead test"
sort pid
save temp_add.dta,replace

