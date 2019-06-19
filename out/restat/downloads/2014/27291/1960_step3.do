clear
set mem 4G
set matsize 2000
set more off

use census1960

drop if sex==1

gen college=0
replace college=1 if educd>=101

drop if occ1990==999


/**average wages, hours, weeks by occupation-age for females unconditional on LFP**/

gen hours=uhrswork*wkswork1 /**weeks worked last year*usual hours per week**/

sum hours

drop if hours==.

drop if incwage==0
drop if incwage==999999

gen hwage=incwage/hours

gen indi=string(occ1990)+string(agegr)

bysort indi: egen col_share=mean(college)

save censuswomen60, replace

collapse col_share, by(indi)

save occupwomen60, replace


clear
set mem 4G
set matsize 2000
set more off

use Couples1960.dta

gen agegr=1 if sex==2 & age>=25 & age<=34
replace agegr=2 if sex==2 & age>=35 & age<=44
replace agegr=3 if sex==2 & age>=45 & age<=60

gen indi=string(occ1990)+string(agegr)

/*destring indi, replace*/

drop _merge

merge m:1 indi using occupwomen60

save Couples1960, replace

clear
set mem 4G
set matsize 2000
set more off


use censuswomen60


gen flag=0
replace flag=1 if col_share<0.10  & col_share>=0

gen indicator=string(occ1990)+string(agegr)+string(college) 
replace indicator=string(occ1990)+string(agegr) if flag==1 

destring indicator, replace

tab indicator if uhrswork>=32

gen cell=1

collapse (mean) wkswork1 uhrswork incwage hwage (sum) cell if uhrswork>=32, by(indicator)

rename wkswork1 fullwkswork1
rename uhrswork fulluhrswork
rename incwage	fullincwage

save avgwages60_women,replace

clear
set mem 4G
set matsize 2000
set more off


use Couples1960.dta

gen college=0 if sex==2
replace college=1 if educd>=101 & sex==2

gen flag=0
replace flag=1 if col_share<0.10  & col_share>=0


gen indicator=string(occ1990)+string(agegr)+string(college) if sex==2 & occ1990!=. & agegr!=. & college!=.
replace indicator=string(occ1990)+string(agegr) if flag==1 & sex==2 & occ1990!=. & agegr!=. & college!=.

destring indicator, replace

drop _merge

merge m:1 indicator using avgwages60_women

drop _merge

save Couples1960, replace

/*********************************Men***********************************************************************************************/
clear
set mem 4G
set matsize 2000
set more off

use census1960

drop if sex==2


gen college=0
replace college=1 if educd>=101

drop if occ1990==999
drop if agegr==.
drop if college==.

drop if qincwage==4 /**dropping all allocated income**/
/*drop if quhrswor==4 */ /**dropping allocated usual hour of work**/
drop if qocc==4 /**dropping all allocated occupations**/
drop if qwkswork==4 

gen hours=uhrswork*wkswork1 /**weeks worked last year*usual hours per week**/

drop if hours==.

drop if incwage==0
drop if incwage==999999


gen hwage=incwage/hours

sum hours
sum hwage

gen indi=string(occ1990)+string(agegr)

destring indi, replace

bysort indi: egen col_share=mean(college)

save censusmen60, replace

collapse col_share, by(indi)

rename indi indi_m
rename col_share col_share_m

save occupmen60, replace


clear
set mem 4G
set matsize 2000
set more off

use Couples1960

gen agegr_m=1 if sex_m==1 & age_m>=25 & age_m<=34
replace agegr_m=2 if sex_m==1 & age_m>=35 & age_m<=44
replace agegr_m=3 if sex_m==1 & age_m>=45 & age_m<=60

gen indi_m=string(occ1990_m)+string(agegr_m) if occ1990!=. & age_m!=.

destring indi_m, replace


merge m:1 indi_m using occupmen60

save Couples1960.dta,replace

clear
set mem 4G
set matsize 2000
set more off

use censusmen60

gen flag=0
replace flag=1 if col_share<0.10  & col_share>=0

gen indicator=string(occ1990)+string(agegr)+string(college)
replace indicator=string(occ1990)+string(agegr) if flag==1 

destring indicator, replace

tab indicator if uhrswork>=32

gen cell=1


/**average wages, hours, weeks by occupation-age for females unconditional on LFP**/

collapse (mean) wkswork1 uhrswork incwage hwage (sum) cell if uhrswork>=32, by(indicator)

rename indicator indicator_m
rename wkswork1 fullwkswork1_m
rename uhrswork fulluhrswork_m
rename incwage fullincwage_m
rename hwage hwage_m
rename cell cell_m 


save avgwages60_men, replace


clear
set mem 4G
set matsize 2000
set more off

use Couples1960.dta


gen college_m=0 if sex_m==1
replace college_m=1 if sex_m==1 & educd_m>=101

gen flag_m=0
replace flag_m=1 if col_share_m<0.10 & col_share_m>=0


gen indicator_m=string(occ1990_m)+string(agegr_m)+string(college_m) if sex_m==1 & occ1990_m!=. & agegr_m!=. & college_m!=.
replace indicator_m=string(occ1990_m)+string(agegr_m) if flag_m==1 & sex_m==1 & occ1990_m!=. & agegr_m!=. & college_m!=.

destring indicator_m, replace

drop _merge

merge m:1 indicator_m using avgwages60_men

/**dropping observations with allocated ages**/

keep if qage==0
keep if qage_m==0
/**dropping cohabiting couples living in households with 1 other married couple - 6 in total)*/

drop if (serial==24845|serial==305126|serial==364004)
drop if serial==369934 & pernum==7
drop if serial==376270 & pernum==6
drop if serial==518622 & pernum==6

/**dropping variables not used in the estimation**/


drop  year serial pernum sploc sex occ1990 wkswork2 hrswork2 qage qocc qwkswork qincwage spouseindi1 spouseindi2 statefip_m metarea_m pernum_m sploc_m sex_m occ1990_m wkswork2_m
drop hrswork2_m qage_m qocc_m qwkswork_m qincwage_m agegr indi col_share college flag indicator fullwkswork1 fulluhrswork fullincwage cell agegr_m indi_m col_share_m college_m flag_m
drop indicator_m fullwkswork1_m fulluhrswork_m fullincwage_m cell_m _merge


save Couples1960.dta, replace








