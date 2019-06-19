**************************************************************************************
*			Do-file to compute gini coefficients at city level           *
*                                 from census 1970-1990                              *
**************************************************************************************

clear
cap log close
set mem 500m

global census90="C:\Users\HW462587\Documents\Leah\2889\10178530\census1990"
global census80="C:\Users\HW462587\Documents\Leah\9693\census1980"
global census70="C:\Users\HW462587\Documents\Leah\9694\census1970"
global census00="C:\Users\HW462587\Documents\Leah\census 2000 - 1\dc_dec_2000_sf3_u_data1.dta"



*** 1990 ***

clear
use $census90
drop if V103==. | V103==0
keep V12 V4  V101 V152 V155 V303 V316 V1208
rename V12 census
rename V4 state
egen id_place=group(state census)

global variables=" V101 V152 V155 V303 V316 V1208"
foreach var in $variables   {

replace `var'=. if `var'==999 | `var'==99999

}


rename V101 population
gen share65=V1208/population
rename V303 mean_income
rename V152 share_black
rename V155 share_hisp
rename V316 poverty_rate
drop V1208

replace mean_income=. if mean_income<0
replace poverty_rate= poverty_rate/100
replace share_black=   share_black/100
replace share_hisp=     share_hisp/100
replace share65=. if         share65>1
replace share_black=. if share_black>1
replace share_hisp=. if   share_hisp>1
replace pov=. if                 pov>1

gen year=1989
drop id_place


save dem89, replace


** 1980 **/


clear
use $census80
drop if V103==. | V103==0 | V103==9999999
keep V12 V4  V101 V152 V155 V303 V316 V1208
rename V12 census
rename V4 state
egen id_place=group(state census)

global variables=" V101 V152 V155 V303 V316 V1208"
foreach var in $variables   {

replace `var'=. if `var'==999 | `var'==99999

}



rename V101 population
gen share65=V1208/population
rename V303 mean_income
rename V152 share_black
rename V155 share_hisp
rename V316 poverty_rate
drop V1208

replace mean_income=. if mean_income<0
replace poverty_rate=poverty_rate/100
replace share_black=share_black/100
replace share_hisp=share_hisp/100
replace share65=. if share65>1 
replace share_black=. if share_black>1
replace share_hisp=. if share_hisp>1
replace pov=. if pov>1

gen year=1979
drop id_place


save dem79, replace




** 1970 **


clear
use $census70
drop if V103==. | V103==0 | V103==9999999
keep V12 V4  V101 V152 V155 V303 V316 V1208
rename V12 census
rename V4 state
egen id_place=group(state census)

global variables=" V101 V152 V155 V303 V316 V1208"
foreach var in $variables   {

replace `var'=. if `var'==999 | `var'==99999

}


rename V101 population
gen share65=V1208/population
rename V303 mean_income
rename V152 share_black
rename V155 share_hisp
rename V316 poverty_rate
drop V1208

replace mean_income=. if mean_income<0

replace poverty_rate=poverty_rate/100
replace share_black=share_black/100
replace share_hisp=share_hisp/100

replace share65=. if share65>1 
replace share_black=. if share_black>1
replace share_hisp=. if share_hisp>1
replace pov=. if pov>1




gen year=1969
drop id_place


save dem69, replace








***** Append all databases *****

clear
use dem69
append using dem79
append using dem89
compress
sort year state census

save C:\Users\HW462587\Documents\Leah\Data\dem_cities, replace

