**************************************************************************************
*			Do-file to extract expenditure data at school dist level     *
*                                 1970 - 2000                                        *
**************************************************************************************

clear

set mem 500m

local drop _all
global drop _all
set seed 123456
macro drop _all
set more on
* Open identifier file

insheet using C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\ids.csv

keep state idcensus name ncesid
rename state state_ids
rename name name_ids

drop if _n==1


gen idcensus_ids=substr(idcensus,1,9)

sort idcensus_ids
tempfile equiv_file
save `equiv_file', replace

clear
use  "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\exp_schoold", clear
destring fips_state county year, replace
rename fips_state state


rename id idcensus_ids

sort idcensus_ids
merge idcensus_ids using `equiv_file'
tab _merge



drop if _merge==2
keep if _merge==3
rename _merge merge1

*rename county county_gov

replace county_name=     "DEKALB COUNTY"               if        county_name== "DE KALB COUNTY" 
replace county_name=     "DESOTO COUNTY"               if        county_name== "DE SOTO COUNTY" 
replace county_name=     "DEWITT COUNTY"               if        county_name== "DE WITT COUNTY" 
replace county_name=     "DUPAGE COUNTY"               if        county_name== "DU PAGE COUNTY" 
replace county_name=     "FORT BEND COUNTY"               if        county_name== "FT BEND COUNTY" 
replace county_name=     "LAMOURE COUNTY"              if        county_name== "LA MOURE COUNTY" 
replace county_name=     "LAPORTE COUNTY"              if        county_name== "LA PORTE COUNTY" 
replace county_name=     "LASALLE COUNTY"              if        county_name== "LA SALLE COUNTY" 
replace county_name=     "METROPOLITAN DADE COUNTY"     if       county_name==  "METROPOLITAN DADE COUNTY" 
replace county_name=     "O'BRIEN COUNTY"               if       county_name==  "O BRIEN COUNTY" 
replace county_name=     "ORMSBY COUNTY"                if       county_name==  "ORMSBY COUNTY" 
replace county_name=     "ST. BERNARD PARISH"            if      county_name==   "ST BERNARD PARISH" 
replace county_name=     "ST. CHARLES COUNTY"            if      county_name==   "ST CHARLES COUNTY" 
replace county_name=     "ST. CHARLES PARISH"            if      county_name==   "ST CHARLES PARISH" 
replace county_name=     "ST. CLAIR COUNTY"              if      county_name==   "ST CLAIR COUNTY" 
replace county_name=     "ST. CROIX COUNTY"              if      county_name==   "ST CROIX COUNTY" 
replace county_name=     "ST. FRANCIS COUNTY"            if      county_name==   "ST FRANCIS COUNTY" 
replace county_name=     "ST. FRANCOIS COUNTY"           if      county_name==   "ST FRANCOIS COUNTY" 
replace county_name=     "ST. HELENA PARISH"             if      county_name==   "ST HELENA PARISH" 
replace county_name=     "ST. JAMES PARISH"              if      county_name==   "ST JAMES PARISH" 
replace county_name=     "ST. JOHN THE BAPTIST PARISH"   if      county_name==   "ST JOHN THE BAPTIST PARISH" 
replace county_name=     "ST. JOHNS COUNTY"              if      county_name==   "ST JOHNS COUNTY" 
replace county_name=     "ST. JOSEPH COUNTY"             if      county_name==   "ST JOSEPH COUNTY" 
replace county_name=     "ST. LANDRY PARISH"             if      county_name==   "ST LANDRY PARISH" 
replace county_name=     "ST. LAWRENCE COUNTY"           if      county_name==   "ST LAWRENCE COUNTY" 
replace county_name=     "ST. LOUIS COUNTY"              if      county_name==   "ST LOUIS COUNTY" 
replace county_name=     "ST. LUCIE COUNTY"              if      county_name==   "ST LUCIE COUNTY" 
replace county_name=     "ST. MARTIN PARISH"             if      county_name==   "ST MARTIN PARISH" 
replace county_name=     "ST. MARY PARISH"               if      county_name==   "ST MARY PARISH" 
replace county_name=     "ST. TAMMANY PARISH"            if      county_name==   "ST TAMMANY PARISH" 
replace county_name=     "STE. GENEVIEVE COUNTY"         if      county_name==   "STE GENEVIEVE COUNTY" 


compress



rename population pop_school_d
drop if ncesid=="N"
destring ncesid, replace 


egen aux=sd(ncesid), by (idcensus_ids)
drop if aux>0
drop aux


drop if ncesid==.
egen aux=count(year), by(year ncesid )
keep if aux==1
drop aux
sort year ncesid 
tempfile base_aux
tempfile base_aux1
tempfile base_aux2
tempfile base_aux3
tempfile base_aux4
save `base_aux', replace
** Open school demographics


*1970

clear

use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\allyears_longform__7_Jan_2009.dta", clear
drop if leaid=="N"
destring leaid, replace force

rename leaid ncesid

keep year ncesid shrold_70 blk_70 pop_70  wht_70 indian_70 japanese_70 chinese_70 filipino_70 other_70

keep if year==1970

rename shrold_70 share65
gen  share_black=blk_70/pop_70
gen  share_white=wht_70/pop_70
egen aux=rsum(indian_70 other_70)
gen  share_other=aux/pop_70
egen aux1=rsum( japanese_70 chinese_70 filipino_70)
gen  share_asn=aux1/pop_70

gen ethnic_fract=1-(share_other^2)-(share_white^2)-(share_asn^2)-(share_black^2)

drop aux*   wht_70 indian_70 japanese_70 chinese_70 filipino_70 other_70 blk_70

rename pop_70 population

replace year=year-1


sort year ncesid 
save `base_aux1', replace

* 1979


clear

use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\allyears_longform__7_Jan_2009.dta", clear
drop if leaid=="N"
destring leaid, replace force

rename leaid ncesid

keep year ncesid shrold_80 blk_80 pop_80  medfaminc_80  wht_80 

keep if year==1980

rename shrold_80 share65
gen share_black=blk_80/pop_80
rename  medfaminc_80 median_income

gen share_white=wht_80/pop_80
drop   wht_80 blk_80

gen ethnic_fract =1-(share_white^2)-(share_black^2)

rename pop_80 population


replace year=year-1

sort year ncesid 

replace ethnic_fract=0 if ethnic_fract<0

save `base_aux2', replace





* 1989


clear

use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\allyears_longform__7_Jan_2009.dta", clear
drop if leaid=="N"
destring leaid, replace force

rename leaid ncesid

keep year ncesid shrold_90  pop_90  medfaminc_90   wht_90 blk_90 amindian_90 asn_90 otherrace_90

keep if year==1990

rename shrold_90 share65
gen share_black=blk_90/pop_90
rename  medfaminc_90 median_income
gen share_asn=asn_90/pop_90
egen aux=rsum(amindian_90 otherrace_90 )
gen share_other=aux/pop_90

gen share_white=wht_90/pop_90
drop aux 

gen ethnic_fract =1-(share_white^2)-(share_black^2)

rename pop_90 population
drop *_90

replace year=year-1



sort year ncesid 

replace ethnic_fract=0 if ethnic_fract<0

save `base_aux3', replace




* 2000


clear

use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\allyears_longform__7_Jan_2009.dta", clear
drop if leaid=="N"
destring leaid, replace force

rename leaid ncesid

keep year ncesid shrold_00 blk_00 pop_00  medfaminc_00  wht_00 amind_00 asn_00 otherrace_00 twoormore_00

keep if year==2000

rename shrold_00 share65
gen share_black=blk_00/pop_00
rename  medfaminc_00 median_income

gen share_white=wht_00/pop_00
gen share_asn=asn_00/pop_00
egen aux=rsum(amind_00 otherrace_00 twoormore_00)
gen share_other=aux/pop_00
drop aux  wht_00 amind_00 asn_00 otherrace_00 twoormore_00 blk_00

gen ethnic_fract =1-(share_other^2)-(share_white^2)-(share_asn^2)-(share_black^2)

rename pop_00 population


replace year=year-1



replace ethnic_fract=0 if ethnic_fract<0

append using `base_aux1'
append using `base_aux2'
append using `base_aux3'
drop if ncesid==.
egen aux=count(year), by(year ncesid )
keep if aux==1
drop aux
sort year ncesid 


count
save `base_aux4', replace
clear
use  `base_aux'
count
sort year ncesid 
merge 1:1 year ncesid using `base_aux4'
drop _merge
sort year ncesid 
save `base_aux', replace

************ Merge Ginis ****************

* 1970

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem69_all_schd"
destring leaid, replace
rename leaid ncesid
sort year ncesid
merge year ncesid using `base_aux'
rename _merge merge4
drop if merge4==1


sort year ncesid 

save `base_aux', replace

* 1980

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem79_all_schd"
destring leaid, replace
rename leaid ncesid
sort year ncesid
merge year ncesid using `base_aux'
drop if _merge==1
drop _merge

sort year ncesid 

save `base_aux', replace


* 1990

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem89_all_schd"
destring leaid, replace
rename leaid ncesid
sort year ncesid
merge year ncesid using `base_aux'
drop if _merge==1
drop _merge

sort year ncesid 

save `base_aux', replace


*2000

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem99_all_schd"
destring leaid, replace
rename leaid ncesid
sort year ncesid
merge year ncesid using `base_aux'
rename _merge merge5
drop if merge5==1

rename gini gini_predicted

sort year ncesid 

save `base_aux', replace

******** Merge true ginis


clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\gini_dem69_all_schd"
destring leaid, replace
rename leaid ncesid
sort year ncesid
merge year ncesid using `base_aux'
rename _merge merge6
drop if merge6==1


sort year ncesid 

save `base_aux', replace

*1979

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\bgini_dem79_all_schd"
destring leaid, replace
rename leaid ncesid
sort year ncesid
merge year ncesid using `base_aux'
drop if _merge==1
drop _merge

replace gini=bgini if year==1979
drop bgini

sort year ncesid 

save `base_aux', replace

*1989

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\bgini_dem89_all_schd"
destring leaid, replace
rename leaid ncesid
sort year ncesid
merge year ncesid using `base_aux'
drop if _merge==1
drop _merge

replace gini=bgini if year==1989
drop bgini

sort year ncesid 

save `base_aux', replace


*2000

clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\bgini_dem99_all_schd"
destring leaid, replace
rename leaid ncesid
sort year ncesid
merge year ncesid using `base_aux'
rename _merge merge7
drop if merge7==1

replace gini=bgini if year==1999
drop bgini

sort year ncesid 

save `base_aux', replace


*************** MEdian income 1970



clear
use "C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\instrument\median_income69_all_schd"
destring leaid, replace
rename leaid ncesid
sort year ncesid

merge year ncesid using `base_aux'
rename _merge merge8
drop if merge8==1

replace median_income= median_income_1970 if year==1969

drop median_income_1970

sort year ncesid 

drop merge*
compress


gen lmedian_income=ln(median_income)
gen lpopulation=ln(population)

egen id_place=group(ncesid)

tsset id_place year

save C:\Users\Hernan\Dropbox\Documents\Leah\cd_restat\school_districts\school_district_database, replace









