clear
set mem 4G
set matsize 2000
set more off

use census1970.dta

drop if sex==1

gen college=0
replace college=1 if educd>=101

drop if occ1990==999
drop if agegr==.
drop if college==.

drop if qincwage==4 /**dropping all allocated income**/
/*drop if quhrswor==4 *//**dropping allocated usual hour of work**/
drop if qocc==4 /**dropping all allocated occupations**/
drop if qwkswork==4

/**average wages, hours, weeks by occupation-age for females unconditional on LFP**/

gen hours=uhrswork*wkswork1 /**weeks worked last year*usual hours per week**/


sum hours

drop if hours==.

drop if incwage==0
drop if incwage==999999

gen hwage=incwage/hours

gen indi=string(occ1990)+string(agegr)

/*destring indi, replace*/

bysort indi: egen col_share=mean(college)

save censuswomen70.dta,replace

collapse col_share, by(indi)

save occupwomen70.dta,replace


clear
set mem 4G
set matsize 2000
set more off

use Couples1970.dta

/*drop agegr*/

gen agegr=1 if sex==2 & age>=25 & age<=34
replace agegr=2 if sex==2 & age>=35 & age<=44
replace agegr=3 if sex==2 & age>=45 & age<=60

gen indi=string(occ1990)+string(agegr)

/*destring indi, replace*/

drop _merge

merge m:1 indi using occupwomen70.dta

save Couples1970.dta,replace


clear
set mem 4G
set matsize 2000
set more off

use censuswomen70.dta

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

save avgwages70_women.dta,replace

clear
set mem 4G
set matsize 2000
set more off

use Couples1970.dta

gen college=0 if sex==2
replace college=1 if educd>=101 & sex==2

gen flag=0
replace flag=1 if col_share<0.10  & col_share>=0

gen indicator=string(occ1990)+string(agegr)+string(college) if sex==2 & occ1990!=. & agegr!=. & college!=.
replace indicator=string(occ1990)+string(agegr) if flag==1 & sex==2 & occ1990!=. & agegr!=. & college!=.

destring indicator, replace

drop _merge

merge m:1 indicator using avgwages70_women.dta

drop _merge

save Couples1970.dta, replace

/*********************************Men***********************************************************************************************/
clear
set mem 4G
set matsize 2000
set more off

use census1970.dta


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

/*destring indi, replace*/

bysort indi: egen col_share=mean(college)

save censusmen70.dta, replace

collapse col_share, by(indi)

rename indi indi_m
rename col_share col_share_m

save occupmen70.dta,replace


clear
set mem 4G
set matsize 2000
set more off

use Couples1970.dta

gen agegr_m=1 if sex_m==1 & age_m>=25 & age_m<=34
replace agegr_m=2 if sex_m==1 & age_m>=35 & age_m<=44
replace agegr_m=3 if sex_m==1 & age_m>=45 & age_m<=60

gen indi_m=string(occ1990_m)+string(agegr_m)


merge m:1 indi_m using occupmen70.dta

save Couples1970.dta,replace

clear
set mem 4G
set matsize 2000
set more off


use censusmen70.dta


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


save avgwages70_men.dta,replace


clear
set mem 4G
set matsize 2000
set more off

use Couples1970.dta


gen college_m=0 if sex_m==1
replace college_m=1 if sex_m==1 & educd_m>=101

gen flag_m=0
replace flag_m=1 if col_share_m<0.10 & col_share_m>=0


gen indicator_m=string(occ1990_m)+string(agegr_m)+string(college_m) if sex_m==1 & occ1990_m!=. & agegr_m!=. & college_m!=.
replace indicator_m=string(occ1990_m)+string(agegr_m) if flag_m==1 & sex_m==1 & occ1990_m!=. & agegr_m!=. & college_m!=.

destring indicator_m, replace

drop _merge

merge m:1 indicator_m using avgwages70_men.dta


save Couples1970.dta, replace

/**dropping variables not used in the estimation**/
drop year serial pernum sploc relate occ1990 wkswork2 hrswork2 qwkswork spouseindi1 spouseindi2 pernum_m sploc_m relate_m occ1990_m wkswork2_m hrswork2_m 
drop qwkswork_m agegr indi col_share college flag indicator fullwkswork1 fulluhrswork fullincwage cell agegr_m indi_m col_share_m college_m flag_m indicator_m
drop fullwkswork1_m fulluhrswork_m fullincwage_m cell_m _merge sex sex_m statefip_m metarea_m

save Couples1970.dta, replace

