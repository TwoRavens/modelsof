clear
set mem 4G
set matsize 2000
set more off

/*********this sample is extracted from IPUMS and includes only individuals aged 25-60*************/

use full1980
keep age sex wkswork1 uhrswork

tab uhrswork

drop if uhrswork==0
drop if uhrswork==.


gen Hgroup=1 if uhrswork>=1 & uhrswork<=14
replace Hgroup=2 if uhrswork>=15 & uhrswork<=29
replace Hgroup=3 if uhrswork>=30 & uhrswork<=34
replace Hgroup=4 if uhrswork>=35 & uhrswork<=39
replace Hgroup=5 if uhrswork==40
replace Hgroup=6 if uhrswork>=41 & uhrswork<=48
replace Hgroup=7 if uhrswork>=49 & uhrswork<=59
replace Hgroup=8 if uhrswork>=60



gen Wgroup=1 if wkswork1>=1 & wkswork1<=13
replace Wgroup=2 if wkswork1>=14 & wkswork1<=26
replace Wgroup=3 if wkswork1>=27 & wkswork1<=39
replace Wgroup=4 if wkswork1>=40 & wkswork1<=47
replace Wgroup=5 if wkswork1>=48 & wkswork1<=49
replace Wgroup=6 if wkswork1>=50 & wkswork1<=52

gen agegr=1 if age>=25 & age<=34
replace agegr=2 if age>=35 & age<=44
replace agegr=3 if age>=45 & age<=60

gen indicator1=string(Hgroup)+string(agegr)+string(sex) 

destring indicator1, replace

collapse uhrswork, by(indicator1)


save avghours1980.dta, replace


clear
set mem 4G
set matsize 2000
set more off


use 1980hours_weeks.dta

drop if age<25
drop if age>60

drop if wkswork1==0
drop if wkswork1==.


gen Wgroup=1 if wkswork1>=1 & wkswork1<=13
replace Wgroup=2 if wkswork1>=14 & wkswork1<=26
replace Wgroup=3 if wkswork1>=27 & wkswork1<=39
replace Wgroup=4 if wkswork1>=40 & wkswork1<=47
replace Wgroup=5 if wkswork1>=48 & wkswork1<=49
replace Wgroup=6 if wkswork1>=50 & wkswork1<=52

gen agegr=1 if age>=25 & age<=34
replace agegr=2 if age>=35 & age<=44
replace agegr=3 if age>=45 & age<=60

gen indicator2=string(Wgroup)+string(agegr)+string(sex) 

destring indicator2, replace

collapse wkswork1, by(indicator2)

save avgweeks1980.dta, replace
