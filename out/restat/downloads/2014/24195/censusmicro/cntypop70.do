
clear

set more off 
infix using cntypop70.dct 

/*Important: you need to put the .dat, .do, and .dct files all in one folder/directory
  and then set the working folder to that folder.*/

label var  YEAR "Dataset year"
label var  GISJOIN "GIS join match code"
label var  STATE "State Name"
label var  STATEA "State Code"
label var  COUNTY "County Name"
label var  COUNTYA "County Code"
label var  GEOCOMP "Geographic Subarea Name"
label var  GEOCOMPA "Geographic Subarea Code"
label var  CHARITER "Race/Ethnicity Name"
label var  CHARITEA "Race/Ethnicity Code"
label var  V0000001 "NT126 (CNT4P): Total "
label var  V0100001 "NT1 (CNT1): Total "
label var  V0200001 "NT61 (CNT4H): Total "

rename STATE statename
rename STATEA statecode
rename COUNTY cntyname
rename COUNTYA cntycode

rename V0000001 pop
replace pop=V0100001 if pop==.

keep statename statecode cntyname cntycode pop

replace statecode =substr(statecode, 1, 2)
destring statecode, replace
destring cntycode, replace
sort statecode cntycode


saveold cntypop70.dta, replace
clear
