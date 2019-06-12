
********************************************************************************
*** This data file decribes how we cleaned the IFLS data  **********************
********************************************************************************

/* 
Note that because of licencing reasons we cannot make the raw-data public.
The data is accessible for free at https://www.rand.org/l.abor/FLS/IFLS/access.html
*/


*Set path to IFLS data
global ifls "SETYOURIFLSPATH"


do pce14.do // generate IFLS5 consumption data





********************************************************************************
********************************************************************************
**********************************IFLS 2000: HH BOOK 3B FINAL*******************
**********************************KK********************************************
********************************************************************************
********************************************************************************

use "$ifls/IFLS3/hh00_all_dta/b3b_kk.dta", clear



**********************************************
**** IFLS 1 **********************************
**********************************************


use "$ifls/IFLS1/buk3tk1.dta", clear

drop if pidlink==""

merge 1:1 pidlink using  "$ifls/IFLS1/buk3tk2.dta"

drop _merge


merge n:1 hhid93  using "$ifls/consumption/pce93nom.dta" // Consumption data downloaded from IFLS site.

keep if _merge==3
drop _merge

ren kabid93 kabid_93
ren kecid93 kecid_93

ren hhsize93 hhsize_93



gen  hhfood_93=xfoodtot/hhsize_93*4.614090182   //Deflate to end of 2005 price levels using national inflation 
gen hhexp_93= xhhexp/hhsize_93*4.614090182    //Deflate to end of 2005 price levels using national inflation 



gen self_employed_93= tk24a==1 | tk24a==2 if tk24a!=.

gen casual_agriculture_93= tk24a==5 | tk24a==6  if tk24a!=.


gen working_agriculture_93=.

bys hhid93: egen working_agr_hh_93=max(working_agriculture)
bys hhid93: gen sector_agr_hh_93=.



keep hhfood* hhexp* hhid93 pidlink   kecid_93 kabid_93 self_employed casual_agriculture hhsize



save  "$temp/ifls1_incexp.dta", replace

use "$data/kecamatanxwalk.dta", clear

 destring kecid2000, gen(kecid_93)
duplicates drop  kecid2000, force



merge 1:n kecid_93 using "$temp/ifls1_incexp.dta"

drop if _merge==1
drop _merge

ren kecid2000 kecid2000_93
ren kabuid kabuid_93

save  "$temp/ifls1_incexp.dta", replace



**********************************************
**** IFLS 2 **********************************
**********************************************


use "$ifls/IFLS2/ptrack.dta", clear
drop if pidlink==""


merge n:1 hhid97  using "$ifls/consumption/pce97nom.dta"

keep if _merge==3
drop _merge

merge n:1 commid97 using  "$ifls/IFLS2/geo_i97.dta"

keep if _merge==3 // Drop respondents outside of community ids
drop _merge

ren kab98cd kabid_97

ren kec98cd kecid_97

ren bpscode kecidbps_97


gen  hhfood_97=hhfood/hhsize*3.280820709   //Deflate to end of 2005 price levels using national inflation 
gen hhexp_97=hhexp/hhsize*3.280820709      //Deflate to end of 2005 price levels using national inflation 

ren hhsize hhsize_97

keep hhfood_97 hhexp_97 hhid97 pidlink  kecidbps_97 kecid_97 kabid_97 hhsize




save  "$temp/ifls2_temp.dta", replace



use "$ifls/IFLS2/b3a_tk2.dta" , clear

gen self_employed_97= tk24a==1 | tk24a==2 if tk24a!=.

gen casual_agriculture_97= tk24a==5 | tk24a==6  if tk24a!=.


gen agriculture_97 =tk20aind==1 if tk20aind!=.

gen  working_agriculture_97= (self_employed==1|casual_agriculture==1)& agriculture==1 if agriculture!=.

bys hhid97: egen working_agr_hh_97=max(working_agriculture)
bys hhid97: egen sector_agr_hh_97=max(agriculture)



merge 1:1 pidlink using "$temp/ifls2_temp.dta"

drop _merge

save  "$temp/ifls2_inc_exp.dta", replace

use "$data/kecamatanxwalk.dta", clear

 destring kecid2000, gen(kecidbps_97)
duplicates drop  kecid2000, force


merge 1:n kecidbps_97 using "$temp/ifls2_inc_exp.dta"

drop if _merge==1

drop _merge

ren kecid2000 kecid2000_97
ren kabuid kabuid_97

save  "$temp/ifls2_inc_exp.dta", replace

**********************************************
**** IFLS 3 **********************************
**********************************************


use "$ifls/IFLS3/hh00_all_dta/ptrack.dta", clear
merge n:1 hhid00 using "$ifls/IFLS3/hh00_all_dta/b1_cov.dta" 

drop _merge

gen month_0=ivwmth1

drop if pidlink==""

merge n:1 hhid00  using "$ifls/consumption/pce00nom.dta"

keep if _merge==3


gen  hhfood_0=hhfood/hhsize*1.61833395  //Deflate to end of 2005 price levels using national inflation 
gen hhexp_0=hhexp/hhsize*1.61833395  //Deflate to end of 2005 price levels using national inflation 

ren kecid kecid_2000

ren hhsize hhsize_0

keep hhfood* hhexp* hhid00 pidlink kecid kabid month_0 hhsize*


save  "$temp/ifls3_temp.dta", replace



use "$ifls/IFLS3/hh00_all_dta/b3a_tk2.dta" , clear

gen self_employed_0= tk24a==1 | tk24a==2 if tk24a!=.

gen casual_agriculture_0= tk24a==7 | tk24a==6  if tk24a!=.

replace tk19aa="10" if tk19aa=="X"

destring tk19aa, replace
gen agriculture_0 =tk19aa==1 if tk19aa!=.

gen working_agriculture_0= (self_employed==1|casual_agriculture==1)& agriculture==1 if agriculture!=.


bys hhid00: egen working_agr_hh_0=max(working_agriculture)
bys hhid00: egen sector_agr_hh_0=max(agriculture)


merge 1:1 pidlink using "$temp/ifls3_temp.dta"

drop _merge

save  "$temp/ifls3_inc_exp.dta", replace


use "$data/kecamatanxwalk.dta", clear

 destring kecid2000, gen(kecid_2000)
duplicates drop  kecid2000, force


merge 1:n kecid_2000 using "$temp/ifls3_inc_exp.dta"

drop if _merge==1

drop _merge

ren kabuid kabuid_0
gen kabid_0= kabuid_0
destring kabid_0, replace

ren kecid2000 kecid2000_0
save  "$temp/ifls3_inc_exp.dta", replace





**********************************************
**** IFLS 4 **********************************
**********************************************



use "$ifls4_complete.dta", clear


merge n:1 hhid07  using "$ifls/consumption/pce07nom.dta"



gen  hhfood_7=hhfood/hhsize*0.756866871 //Deflate to end of 2005 price levels using national inflation 
gen hhexp_7=hhexp/hhsize*0.756866871 //Deflate to end of 2005 price levels using national inflation 


foreach y in bothered_sc troubleconcent_sc depressed_sc effort_sc hopeful_sc fearful_sc bad_sleep_sc happy_sc lonely_sc notgetgoing_sc _outlierfood _outlier hhsize kabid kecid {
ren `y' `y'_7
}
ren cct_IFLS4 cct_7

drop if pidlink==""
keep if _merge==3
drop _merge

gen kecid2006=string(kecid_7)

joinby kecid2006 using "kecamatanxwalk_collapse_2006.dta" , _merge(_merge) unm(both) // Some kecas where part of two 2000 kecas (very few). Have to average rainfall for them.
	

	drop if _merge==1
	drop _merge
	
		gen kecid2000_7=kecid2000
		ren hhid07 hhid_7
		
		ren kabuid kabuid_7
		
		
save "$temp/ifls4_inc_exp.dta", replace

use "$ifls/IFLS4/hh07_all_dta/b3a_tk2.dta" , clear

gen self_employed= tk24a==1 | tk24a==2 if tk24a!=.

gen casual_agriculture= tk24a==7 | tk24a==6  if tk24a!=.

destring tk19ab, replace
gen agriculture =tk19ab==1 if tk19ab!=.

gen working_agriculture= (self_employed==1|casual_agriculture==1)& agriculture==1 if agriculture!=.


bys hhid07: egen working_agr_hh_7=max(working_agriculture)
bys hhid07: egen sector_agr_hh_7=max(agriculture)

keep pidlink working_agr_hh_7 sector_agr_hh_7


merge 1:n pidlink using "$ifls4_inc_exp.dta"

tab _merge
drop _merge

save "$temp/ifls4_inc_exp.dta", replace

**********************************************
**** IFLS 5 **********************************
**********************************************

use "$ifls/IFLS5/ifls5_tracked.dta ", clear

merge n:1 hhid14 using "$ifls/consumption/pce14nom.dta"


gen  hhfood_14=hhfood/hhsize*0.519148292 //Deflate to end of 2005 price levels using national inflation 
gen hhexp_14=hhexp/hhsize*0.519148292 //Deflate to end of 2005 price levels using national inflation 

foreach y in bothered_sc troubleconcent_sc depressed_sc effort_sc hopeful_sc fearful_sc bad_sleep_sc happy_sc lonely_sc notgetgoing_sc _outlierfood _outlier hhsize {
ren `y' `y'_14
}
ren kabid14 kabid_14
ren kecid14 kecid_14
keep if _merge==3
drop _merge

ren cct cct_14


gen kecid2011=string(kecid_14)

merge n:1 kecid2011 using "$data/kecamatanxwalk.dta" , 
	
	
	tab _merge
	/*
	keep if _merge==1
	unique kecid_14
	tab kecid_14
	bys kecid_14: gen temp=_n
	br kecid_14 if temp==1
	*/
	keep if _merge!=2
	drop _merge
	
	ren kecid2000 kecid2000_14
	ren hhid14 hhid_14
	ren kabuid kabuid_14

save "$temp/ifls5_inc_exp.dta", replace




use "$ifls/IFLS5/hh14_all_dta/b3a_tk2.dta" , clear

gen self_employed= tk24a==1 | tk24a==2 if tk24a!=.

gen casual_agriculture= tk24a==7  if tk24a!=.

replace tk19ab="10" if tk19ab=="X"

destring tk19ab, replace
gen agriculture =tk19ab==1 if tk19ab!=.

gen working_agriculture= (self_employed==1|casual_agriculture==1)& agriculture==1 if agriculture!=.


bys hhid14: egen working_agr_hh_14=max(working_agriculture)
bys hhid14: egen sector_agr_hh_14=max(agriculture)

keep pidlink working_agr_hh_14  sector_agr_hh_14

merge 1:n pidlink using "$temp/ifls5_inc_exp.dta"

tab _merge
drop _merge

save "$temp/ifls5_inc_exp.dta", replace


**********************************************
****Merge data *******************************
**********************************************

use "$temp/ifls1_incexp.dta", clear
merge 1:n pidlink using "$temp/ifls2_inc_exp.dta", gen(merge2)
drop version
merge 1:n pidlink using "$temp/ifls3_inc_exp.dta", gen(merge3)
merge 1:n pidlink using  "$temp/ifls5_inc_exp.dta", gen(merge5)
merge 1:n pidlink using "$temp/ifls4_inc_exp.dta", gen(merge4)
drop if pidlink==""


ren age_00 age_0
ren age_07 age_7


keep *sc_14 month_* sex age* *sc_7 pidlink hhfood_* hhexp_* _outlier_* kecid2000_* kecid_* kabuid_* kabid_* hhid_* cct_14 cct_7 hhsize* kecid2000* working_agr_hh_*  sector_agr_hh_*



bys hhid_14: egen pkh_receipient=max(cct_14)

ren kecid_2000 kecid_0



reshape long age_ bothered_sc_ troubleconcent_sc_ depressed_sc_ effort_sc_ hopeful_sc_ fearful_sc_ bad_sleep_sc_ happy_sc_ lonely_sc_ notgetgoing_sc_  ///
 hhfood_ hhexp_ kecid2000_ kecid_ kabuid_ kabid_  hhid_ cct_ sector_agr_hh_ month_ working_agr_hh_ hhsize_, i(pidlink kecid2000 kecid2000_7) j(year)
 
 replace year=year+1901 if year>15 //  Recode  as agricultural season

replace year=2000+year+1 if year<15 //  Recode  as agricultural season
replace year=2000 if year==2001 &month<8 //  Recode  as agricultural seasonr

replace kecid2000=kecid2000_ 
destring kecid2000, replace

keep if kecid2000!=.

save "$temp/ifls12345_inc_exp.dta", replace


use "$data/rainfall_keca_5closest.dta", clear

merge n:1 kecid2000  using "$data/subdistrict_coordinates.dta"
drop _merge

merge 1:n kecid2000 year using "$temp/ifls12345_inc_exp.dta"



tab kecid2000 if _merge==2 // Only two ids

keep if _merge==3

destring pidlink *rain*  age* sex *sc* hh* kecid* kabid* kabuid* provid cc* *out* *coord* *agr* hhsize*, replace

collapse (mean)  *rain* *age* sex *sc* hh* kecid* kabid* kabuid* provid cc* *out* *coord* *agr* , by(pidlink year) 

drop if pidlink=="no change"
destring pidlink , replace

egen id=group(pidlink)

xtset id  year

saveold "$temp/ifls12345_inc_exp_rain.dta", replace v(13)



use  "$temp/ifls12345_inc_exp_rain.dta", clear

foreach y in bothered_sc troubleconcent_sc depressed_sc effort_sc hopeful_sc fearful_sc bad_sleep_sc happy_sc lonely_sc notgetgoing_sc {
recode `y' (0=1)
}
foreach y in hopeful_sc  happy_sc  {
recode `y' (1=4)(2=3)(3=2)(4=1)
}

gen depression_count= bothered_sc+troubleconcent_sc+depressed_sc+effort_sc+hopeful_sc+fearful_sc+bad_sleep_sc+happy_sc+lonely_sc+notgetgoing_sc -10


gen depression_high=depression_count>=9

sum depression_count if year==2008, d
gen z_depression=(depression_count-`r(mean)')/`r(sd)' if year==2008

sum depression_count if year==2015, d
replace z_depression=( depression_count -`r(mean)') / `r(sd)' if year==2015

sum hhfood if year==2008, d
gen z_food_exp =(hhfood-`r(mean)')/`r(sd)' if year==2008

sum hhfood if year==2015, d
replace z_food_exp =(hhfood-`r(mean)')/`r(sd)' if year==2015

***********************************
 xtile food_exp_dec=hhfood if year==2008, n(10)
 xtile temp=hhfood if year==2015, n(10)
 replace  food_exp_dec= temp if year==2015
 
 xtile all_exp_dec=hhexp  if year==2008, n(10)
 xtile temp1=hhexp if year==2015, n(10)
 replace  all_exp_dec= temp1 if year==2015

gen bottom_decile_food_exp=food_exp_dec==1
gen bottom_decile_all_exp=all_exp_dec==1

gen hhnonfood=hhexp-hhfood

gen lnhhfood=ln(hhfood+1)
gen lnhhexp=ln(hhexp+1)
gen lnhhnonfood=ln(hhnonfood+1)

gen lnhhfood_wins=lnhhfood
 gen hhfood_wins=hhfood_
 gen hhexp_wins=hhexp_
 
 gen hhfood_med=.
 gen  hhfood_quart=.

foreach l in 1994 1998 2000 2001 2008 2015 {
sum lnhhfood if year==`l', d
replace lnhhfood_wins=`r(p99)' if lnhhfood>`r(p99)' & year==`l' & lnhhfood_<. 
replace lnhhfood_wins=`r(p1)' if lnhhfood<`r(p1)' & year==`l'  & lnhhfood_<. 

sum hhexp_ if  year==`l' , d
replace hhexp_wins=`r(p99)' if hhexp_>`r(p99)' &  year==`l' &hhexp_<. 
replace hhexp_wins=`r(p1)' if hhexp_<`r(p1)' & year==`l'  & hhexp_<. 

sum hhfood_ if  year==`l' , d
replace hhfood_wins=`r(p99)' if hhfood_>`r(p99)' &  year==`l' &hhfood_<. 
replace hhfood_wins=`r(p1)' if hhfood_<`r(p1)' & year==`l'  & hhfood_<. 

sum hhfood_  if year==`l', d
replace hhfood_med=hhfood_ >`r(p50)' if hhfood_!=.&year==`l'

sum hhfood_  if year==`l', d
replace hhfood_quart=hhfood_ <`r(p25)' if hhfood_!=.&year==`l'


}

cap drop temp
gen temp=hhfood_wins if year==2008
bys pidlink: egen hhfood_wins_baseline=max(temp)
drop temp

gen temp=bottom_decile_food_exp if year==2008
bys pidlink: egen bottom_decile_food_exp_baseline=max(temp)
drop temp

gen temp=z_depression if year==2008
bys pidlink: egen z_depression_baseline=max(temp)
drop temp

gen temp=depression_high if year==2008
bys pidlink: egen depression_high_baseline=max(temp)
drop temp



bys pidlink: egen working_agr_hh_any=max(working_agr_hh_)
bys pidlink: egen sector_agr_hh_any=max(sector_agr_hh_)



saveold "$data/ifls_complete.dta", replace v(13)


