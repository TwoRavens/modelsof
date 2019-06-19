clear
set mem 8G
set matsize 2000
set more off

use full1980.dta

drop if sex==1

gen college=0
replace college=1 if educd>=100

gen agegr=1 if age>=25 & age<=34
replace agegr=2 if age>=35 & age<=44
replace agegr=3 if age>=45 & age<=60

drop if occ1990==.
drop if agegr==.
drop if college==.


drop if (qincwage==1|qincwage==3|qincwage==4) /**dropping all allocated income**/
drop if quhrswor==4  /**dropping allocated usual hour of work**/
drop if (qocc==1|qocc==3|qocc==4)
drop if (qwkswork==1|qwkswork==4)


/**average wages, hours, weeks by occupation-age for females unconditional on LFP**/

gen hours=uhrswork*wkswork1 /**weeks worked last year*usual hours per week**/

gen hwage=incwage/hours

gen indi=string(occ1990)+string(agegr)

destring indi, replace

bysort indi: egen col_share=mean(college)

save censuswomen80.dta,replace

collapse col_share, by(indi)

save occupwomen80.dta,replace


clear
set mem 8G
set matsize 2000
set more off

use Couples1980.dta


gen agegr=1 if sex==2 & age>=25 & age<=34
replace agegr=2 if sex==2 & age>=35 & age<=44
replace agegr=3 if sex==2 & age>=45 & age<=60

gen indi=string(occ1990)+string(agegr)

destring indi, replace

drop _merge

merge m:1 indi using occupwomen80.dta

save Couples1980.dta,replace

clear
set mem 4G
set matsize 2000
set more off


use censuswomen80.dta

gen flag=0
replace flag=1 if col_share<0.10  & col_share>=0

gen indicator=string(occ1990)+string(agegr)+string(college) 
replace indicator=string(occ1990)+string(agegr) if flag==1 

destring indicator, replace

collapse wkswork1 uhrswork incwage hwage if uhrswork>=32, by(indicator)

rename wkswork1 fullwkswork1
rename uhrswork fulluhrswork
rename incwage	fullincwage


save avgwages80_women2.dta,replace

clear
set mem 4G
set matsize 2000
set more off


use Couples1980.dta

gen college=0 if sex==2
replace college=1 if educd>=100 & sex==2

gen flag=0
replace flag=1 if col_share<0.10  & col_share>=0

gen indicator=string(occ1990)+string(agegr)+string(college) if sex==2 & occ1990!=. & agegr!=. & college!=.
replace indicator=string(occ1990)+string(agegr) if flag==1 & sex==2 & occ1990!=. & agegr!=. & college!=.

destring indicator, replace

drop _merge

merge m:1 indicator using avgwages80_women2.dta

drop _merge

save Couples1980.dta, replace

/******************************************************men****************************************************************/

clear
set mem 8G
set matsize 2000
set more off

use full1980.dta

drop if sex==2

gen agegr=1 if age>=25 & age<=34
replace agegr=2 if age>=35 & age<=44
replace agegr=3 if age>=45 & age<=60

gen college=0
replace college=1 if educd>=100

drop if occ1990==.
drop if agegr==.
drop if college==.

drop if (qincwage==3|qincwage==4) /**dropping all allocated income**/
drop if quhrswor==4 /**dropping allocated usual hour of work**/
drop if qocc==4 /**dropping all allocated occupations**/
drop if (qwkswork==1|qwkswork==4)

gen hours=uhrswork*wkswork1 /**weeks worked last year*usual hours per week**/

gen hwage=incwage/hours

/**average wages, hours, weeks by occupation-age for females unconditional on LFP**/

gen indi=string(occ1990)+string(agegr)

bysort indi: egen col_share=mean(college)

save censusmen80.dta,replace

collapse col_share, by(indi)

rename indi indi_m
rename col_share col_share_m

save occupmen80.dta,replace


clear
set mem 8G
set matsize 2000
set more off

use Couples1980.dta


gen agegr_m=1 if sex_m==1 & age_m>=25 & age_m<=34
replace agegr_m=2 if sex_m==1 & age_m>=35 & age_m<=44
replace agegr_m=3 if sex_m==1 & age_m>=45 & age_m<=60

gen indi_m=string(occ1990_m)+string(agegr_m)

merge m:1 indi_m using occupmen80.dta

save Couples1980,replace

clear
set mem 8G
set matsize 2000
set more off

use censusmen80.dta

gen flag=0
replace flag=1 if col_share<0.10  & col_share>=0

gen indicator=string(occ1990)+string(agegr)+string(college)
replace indicator=string(occ1990)+string(agegr) if flag==1 

destring indicator, replace

collapse wkswork1 uhrswork incwage hwage if uhrswork>=32 , by(indicator)

rename indicator indicator_m
rename wkswork1 fullwkswork1_m
rename uhrswork fulluhrswork_m
rename incwage fullincwage_m
rename hwage hwage_m


save avgwages80_men2.dta,replace

clear
set mem 4G
set matsize 2000
set more off

use Couples1980.dta

gen college_m=0 if sex_m==1
replace college_m=1 if  educd_m>=100 & sex_m==1

/*bysort occ1990_m agegr_m: egen col_share_m=mean(college_m)*/

gen flag_m=0
replace flag_m=1 if col_share_m<0.10 & col_share_m>=0


gen indicator_m=string(occ1990_m)+string(agegr_m)+string(college_m) if sex_m==1 & occ1990_m!=. & agegr_m!=. & college_m!=.
replace indicator_m=string(occ1990_m)+string(agegr_m) if flag_m==1 & sex_m==1 & occ1990_m!=. & agegr_m!=. & college_m!=.

destring indicator_m, replace

drop _merge

merge m:1 indicator_m using avgwages80_men2.dta


save Couples1980.dta, replace


/**dropping allocated ages**/
keep if qage==0
keep if qage_m==0

/**dropping variables not used in the estimation**/
drop if cohab==1
drop year serial ncouples pernum sploc relate related sex occ1990 wkswork1 uhrswork quhrswor qwkswork HHfemale spouseindi1 spouseindi2
drop ncouples_m pernum_m sploc_m relate_m related_m sex_m wkswork1_m uhrswork_m quhrswor_m qwkswork_m HHfemale_m agegr indi col_share college
drop flag indicator fullwkswork1 fulluhrswork fullincwage agegr_m indi_m col_share_m college_m flag_m indicator_m fullwkswork1_m fulluhrswork_m fullincwage_m _merge cohab cohab_m numbercohab80 numbercohab80_m

save Couples1980.dta, replace













