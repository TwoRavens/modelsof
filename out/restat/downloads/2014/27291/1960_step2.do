/************************************************************************************************

THIS FILE MERGES AVERAGE HOURS OF WORK AND AVERAGE WEEKS OF WORK FROM THE 1980 CENSUS

*******************************************************************************************************************/


clear
set mem 4G
set matsize 2000
set more off

use full1960

drop if age==.


gen Hgroup=1 if hrswork2==1
replace Hgroup=2 if hrswork2==2
replace Hgroup=3 if hrswork2==3
replace Hgroup=4 if hrswork2==4
replace Hgroup=5 if hrswork2==5
replace Hgroup=6 if hrswork2==6
replace Hgroup=7 if hrswork2==7
replace Hgroup=8 if hrswork2==8


gen agegr=1 if age>=25 & age<=34
replace agegr=2 if age>=35 & age<=44
replace agegr=3 if age>=45 & age<=60

gen indicator1=string(Hgroup)+string(agegr)+string(sex) if Hgroup!=. & agegr!=. & sex!=. 

destring indicator1, replace


merge m:1 indicator1 using avghours1980

save census1960.dta, replace


clear
set mem 4G
set matsize 2000
set more off

use census1960

drop if age==.


drop if wkswork2==0
drop if wkswork2==.

gen Wgroup=1 if wkswork2==1
replace Wgroup=2 if wkswork2==2
replace Wgroup=3 if wkswork2==3
replace Wgroup=4 if wkswork2==4
replace Wgroup=5 if wkswork2==5
replace Wgroup=6 if wkswork2==6


gen indicator2=string(Wgroup)+string(agegr)+string(sex)  if Wgroup!=. & agegr!=. & sex!=. 

destring indicator2, replace

drop _merge

merge m:1 indicator2 using avgweeks1980

save census1960, replace






