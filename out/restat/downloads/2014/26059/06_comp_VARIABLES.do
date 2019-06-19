
********************************************************************************
****** The Effects of WWII on Economic and Health Outcomes across Europe *******
********************************************************************************
* Authors: Iris Kesternich, Bettina Siflinger, James P. Smith, Joachim Winter
* Review of Economics and Statistics, 2014
********************************************************************************
* DOFILE: COMPUTES MAIN VARIABLES
********************************************************************************


clear
clear matrix
clear mata
set more off


*** define the path to the directory containing the data files here 
*** or leave "." if the do files are in the current directory 

global datapath "."


use "$datapath\temp\EXTERNAL_merged.dta", clear


********************************************************************************
*** VARIABLE COMPUTATION, SHARE WAVES 1 & 2 
********************************************************************************

* generate important variables: information had been collected in wave 1 and wave 2 of SHARE
* take wave 2 information if available, wave 1 otherwise

* height
tab1 height*
recode height1 (-1 -2 = .)
recode height2 (-1 -2 = .)
gen height = height2
replace height = height1 if height1 ~= . & height2 == .
replace height = . if height > 250
replace height = . if height < 120
drop height1 height2


* gender
tab gender
recode gender (2=0), g(male)
label var male "male"


* age
gen age = age2
replace age = age1 if age2 == .
replace age = age3 if age1 == . & age2 == .
keep if age >= 50
drop age1 age2 age3

* age squared
gen age2 = age^2


* doctor told you had conditions: heart disease
tab1 ph006d1*
recode ph006d11 (-1 -2 = .)
recode ph006d12 (-1 -2 = .)
gen ph006d1 = ph006d12
replace ph006d1 = ph006d11 if ph006d11 ~= . & ph006d12 == .
drop ph006d11 ph006d12
ren ph006d1 adult_heart


* doctor told you had conditions: diabetes
tab1 ph006d5*
recode ph006d51 (-1 -2 = .)
recode ph006d52 (-1 -2 = .)
gen ph006d5 = ph006d52
replace ph006d5 = ph006d51 if ph006d51 ~= . & ph006d52 == .
drop ph006d51 ph006d52
ren ph006d5 adult_diabet


* country of birth
tab1 dn004_*
recode dn004_1 (-1 -2 = .)
recode dn004_2 (-1 -2 = .)
gen dn004 = dn004_2
replace dn004 = dn004_1 if dn004_1 ~= . & dn004_2 == .
drop dn004_1 dn004_2


* marital status
tab1 dn014_*
recode dn014_1 (-1 -2 = .)
recode dn014_2 (-1 -2 = .)
gen dn014 = dn014_2
replace dn014 = dn014_1 if dn014_1 ~= . & dn014_2 == .
drop dn014_1 dn014_2

gen curr_marr = 0 if dn014 ~=.
replace curr_marr = 1 if (dn014 == 1 | dn014 == 2 | dn014 == 6) & dn014 ~= .
tab curr_marr
drop dn014


* natural parents alive: mother
tab1 dn026_1*
recode dn026_11 (-1 -2 = .)
recode dn026_12 (-1 -2 = .)
gen dn026_1 = dn026_12
replace dn026_1 = dn026_11 if dn026_11 ~= . & dn026_12 == .
drop dn026_11 dn026_12


* natural parents alive: father
tab1 dn026_2*
recode dn026_21 (-1 -2 = .)
recode dn026_22 (-1 -2 = .)
gen dn026_2 = dn026_22
replace dn026_2 = dn026_21 if dn026_21 ~= . & dn026_22 == .
drop dn026_21 dn026_22


* age death: mother
tab1 dn027_1*
recode dn027_11 (-1 -2 = .)
recode dn027_12 (-1 -2 = .)
gen dn027_1 = dn027_12
replace dn027_1 = dn027_11 if dn027_11 ~= . & dn027_12 == .
drop dn027_11 dn027_12


* age death: father
tab1 dn027_2*
recode dn027_21 (-1 -2 = .)
recode dn027_22 (-1 -2 = .)
gen dn027_2 = dn027_22
replace dn027_2 = dn027_21 if dn027_21 ~= . & dn027_22 == .
drop dn027_21 dn027_22


* age mother
tab1 dn028_1*
recode dn028_11 (-1 -2 = .)
recode dn028_12 (-1 -2 = .)
gen dn028_1 = dn028_12
replace dn028_1 = dn028_11 if dn028_11 ~= . & dn028_12 == .
drop dn028_11 dn028_12


* age father
tab1 dn028_2*
recode dn028_21 (-1 -2 = .)
recode dn028_22 (-1 -2 = .)
gen dn028_2 = dn028_22
replace dn028_2 = dn028_21 if dn028_21 ~= . & dn028_22 == .
drop dn028_21 dn028_22


* natural children
tab1 ch002_*
recode ch002_1 (-1 -2 = .)(5 = 0)
recode ch002_2 (-1 -2 = .)(5 = 0)
gen ch002 = ch002_2
replace ch002 = ch002_1 if ch002_2 == . & ch002_1 ~= .
drop ch002_1 ch002_2
tab ch002


* year of birth children
forvalues i = 1/16 {
tab1 ch006_`i'*
recode ch006_`i'* (-1 -2 = .)
}

forvalues i = 1/16 {
gen chyrb_`i' = ch006_`i'2
replace chyrb_`i' = ch006_`i'1 if ch006_`i'1 ~= . & ch006_`i'2 == .
}
drop ch006_*


* depression, imputed
tab1 depress*
recode depress1 (-1 -2 = .)
recode depress2 (-1 -2 = .)
gen depress = depress2
replace depress = depress1 if depress1 ~= . & depress2 == .
drop depress1 depress2


* HH net worth, imputed
recode hnetwv1 (-1 -2 = .)
recode hnetwv2 (-1 -2 = .)
gen hnetwv = hnetwv2
replace hnetwv = hnetwv1 if hnetwv1 ~= . & hnetwv2 == .
drop hnetwv1 hnetwv2
ren hnetwv hh_networth

gen l_hhnetworth = log(hh_networth)
drop hh_networth



* schooling measure, wave 2 only
tab dn041
recode dn041 (-3 -2 -1 = .), g(schooling)
drop dn041

* wellbeing, wave 2 only
tab  ac012_2
recode ac012_2 (-1 -2 = .), g(life_sat)
drop ac012_2


* years education measure, wave 1 only
tab iscedy_r 
recode iscedy_r (-1 -2 = .)
replace iscedy_r = . if iscedy_r == 95 | iscedy_r == 97


* school differences
pwcorr schooling iscedy_r if country != 15 & country != 28 & country != 29, sig
gen school_diff = schooling-iscedy_r
tab school_diff
tab country school_diff
replace school_diff = . if abs(school_diff)>=10



********************************************************************************
*** VARIABLE COMPUTATION, SHARE WAVE 3 & WAR MEASURES
********************************************************************************


* ever been married, wave 3
tab sl_rp002_
recode sl_rp002_ (-1 -2 = .) (5 = 0)
ren sl_rp002_ ever_marr
tab ever_marr


* self rated health, wave 3
tab sl_ph003_
replace sl_ph003_ = ph003_2 if sl_ph003_ == . & ph003_2 ~= .
replace sl_ph003_ = ph003_1 if sl_ph003_ == . & ph003_1 ~= .
recode sl_ph003_ (-1 -2 = .), gen(health)
recode health 1=5 2=4 3=3 4=2 5=1
drop sl_ph003_ ph003_2 ph003_1

* persecution, wave 3 
recode sl_gl022_ (-1 -2 = .)(5 = 0)
ren sl_gl022_ persec
label var persec "Persecution"


* childhood vaccination, wave 3 
tab sl_hc002
recode sl_hc002 (5 = 0)(-1 -2 = .), g(child_imm)
drop sl_hc002


* respondent native born 
tab sl_ac013_1
tab sl_ac013_1, nol
recode sl_ac013_1 (-1 -2 = .) (5 = 0), gen(nativeborn)
tab nativeborn sl_ac013_1
la def nativel 0 "foreign-born" 1 "native born" 
label val native nativel
drop sl_ac013_1

* area respondent was born
gen area = sl_ac017_1
recode area (-1 = .)
label val area ac017




*** HUNGER AND HUNGER PERIODS 

recode sl_gl014 (5 = 0) (-1 -2 = .), gen(hunger)
label var hunger "hunger"
drop sl_gl014

* when hunger started/ended
tab1 sl_gl015 sl_gl016, nol
recode sl_gl015 (-1 -2 = .), g(start_hung)
recode sl_gl016 (-1 -2 = .), g(end_hung)
replace end_hung = 2008 if end_hung == 9997
drop sl_gl015 sl_gl016

*** hunger at different time periods
* before 1939
gen hunger_bef39 = 0
replace hunger_bef39 = 1 if (start_hung < 1939 | end_hung < 1939) & (start_hung ~= . | end_hung ~= .)

* 1939-1944
gen hunger_39_45 = 0
replace hunger_39_45 = 1 if start_hung >= 1939 & start_hung < 1946  & (start_hung ~= . | end_hung ~= .)
replace hunger_39_45 = 1 if start_hung < 1939 & end_hung > 1945 & (start_hung ~= . | end_hung ~= .)
replace hunger_39_45 = 1 if start_hung < 1939 & (end_hung >= 1939 & end_hung < 1946) & (start_hung ~= . | end_hung ~= .)
* control
replace hunger_39_45 = 0 if start_hung > 1945 & (start_hung ~= . | end_hung ~= .)

* 1945-1949
gen hunger_46_49 = 0
replace hunger_46_49 = 1 if start_hung >= 1946 & start_hung < 1950 & (start_hung ~= . | end_hung ~= .)
replace hunger_46_49 = 1 if start_hung < 1946 & end_hung > 1949 & (start_hung ~= . | end_hung ~= .)
replace hunger_46_49 = 1 if start_hung < 1946 & (end_hung >= 1946 & end_hung < 1950) & (start_hung ~= . | end_hung ~= .)

* 1950-1954
gen hunger_50_54 = 0
replace hunger_50_54 = 1 if start_hung >= 1950 & start_hung < 1955 & (start_hung ~= . | end_hung ~= .)
replace hunger_50_54 = 1 if start_hung < 1950 & end_hung > 1954 & (start_hung ~= . | end_hung ~= .)
replace hunger_50_54 = 1 if start_hung < 1950 & (end_hung >= 1950 & end_hung < 1955) & (start_hung ~= . | end_hung ~= .)

* after 1954
gen hunger_after54 = 0
replace hunger_after54 = 1 if start_hung >= 1955 & start_hung ~= . & (start_hung ~= . | end_hung ~= .)
replace hunger_after54 = 1 if start_hung < 1955 & end_hung > 1954 & (start_hung ~= . | end_hung ~= .)

* respondents without date start hunger
replace hunger_bef39 = 1 if start_hung == . & end_hung < 1939 & end_hung ~= .		// 0 changes, ok
replace hunger_39_45 = 1 if start_hung == . & (end_hung >= 1939 & end_hung < 1946) & end_hung ~= .	// 0 changes, ok
replace hunger_46_49 = 1 if start_hung == . & (end_hung >= 1946 & end_hung < 1950) & end_hung ~= .	// 1 change, ok
replace hunger_50_54 = 1 if start_hung == . & (end_hung >= 1950 & end_hung < 1955) & end_hung ~= .	// 1 change, ok
replace hunger_after54 = 1 if start_hung == . & end_hung > 1954 & end_hung ~= .


* respondents without date end hunger: account only for start date (corresponds to procedure of missing start date)
replace hunger_after54 = 0 if start_hung < 1955 & end_hung == .
replace hunger_46_49 = 0 if start_hung < 1946 & end_hung == . 
replace hunger_50_54 = 0 if start_hung < 1950 & end_hung == . 
replace hunger_39_45 = 0 if start_hung < 1939 & end_hung == . 





*** DISPOSSESSION 

recode sl_gl031_ (-1 -2 = .)(5 = 0)
ren sl_gl031_ dispos
label var dispos "Dispossession"


* dispossession at different periods
tab1 sl_gl033_*, nol
recode sl_gl033_* (-1 -2 = .)

tab dispos  
tab dispos
tab1 sl_gl033_*, nol

gen disp_bef39 = 0
replace disp_bef39 = 1 if dispos == 1 & ((sl_gl033_1 < 1939 & sl_gl033_1 ~= .) | (sl_gl033_2 < 1939 & sl_gl033_2 ~= .) | (sl_gl033_3 < 1939 & sl_gl033_3 ~= .))

gen disp_3945 = 0
replace disp_3945 = 1 if dispos == 1 & ((sl_gl033_1 >= 1939 & sl_gl033_1 < 1946) | (sl_gl033_2 >= 1939 & sl_gl033_2 < 1946) | (sl_gl033_3 >= 1939 & sl_gl033_3 < 1946)) ///
& (sl_gl033_1 ~= . | sl_gl033_2 ~= . | sl_gl033_3 ~= .) 

gen disp_4649 = 0
replace disp_4649 = 1 if dispos == 1 & ((sl_gl033_1 >= 1946 & sl_gl033_1 < 1950) | (sl_gl033_2 >= 1946 & sl_gl033_2 < 1950) | (sl_gl033_3 >= 1946 & sl_gl033_3 < 1950)) ///
& (sl_gl033_1 ~= . | sl_gl033_2 ~= . | sl_gl033_3 ~= .) 

gen disp_5054 = 0
replace disp_5054 = 1 if dispos == 1 & ((sl_gl033_1 >= 1950 & sl_gl033_1 < 1955) | (sl_gl033_2 >= 1950 & sl_gl033_2 < 1955) | (sl_gl033_3 >= 1950 & sl_gl033_3 < 1955)) ///
& (sl_gl033_1 ~= . | sl_gl033_2 ~= . | sl_gl033_3 ~= .) 

gen disp_aft54 = 0
replace disp_aft54 = 1 if dispos == 1 & ((sl_gl033_1 >= 1955 & sl_gl033_1 ~= .) | (sl_gl033_2 >= 1955 & sl_gl033_2 ~= .) | (sl_gl033_3 >= 1955 & sl_gl033_3 ~= .)) 





*** AGGREGATE WAR MEASURE 

gen war = 1
replace war = 0 if country == 13 | country == 18 | country == 20 
replace war = 0 if yrbirth3 > 1945
replace war = 1 if yrbirth3 > 1945 & yrbirth3 < 1949 & country == 12 
replace war = 1 if yrbirth3 > 1945 & yrbirth3 < 1949 & country == 11
replace war = . if country == 15


* war countries
gen war_cd = .
replace war_cd = 0 if (country == 13 | country == 15 | country == 18 |country == 20)
replace war_cd = 1 if (country == 11 | country == 12 | country == 14 |country == 16 | country == 17 | country == 19 | country == 23 | country == 28 | country == 29)
ren war_cd war_countries




*** FATHER ABSENT AT AGE 10

tab sl_cs004d2 
recode sl_cs004d2 (-1 -2 = .)
gen father_absent = (sl_cs004d2 == 0)
replace father_absent = . if sl_cs004d2 == .
tab sl_cs004d2 father_absent, missing
label var father_absent "father absent at age 10"
drop sl_cs004d2

* war related absence of father: 1939-1955 - take children born between 1929 and 1945 since at age 10
gen father_absent_3955 = 0
replace father_absent_3955 = . if father_absent == .
replace father_absent_3955 = 1 if father_absent == 1 & yrbirth3 >= 1929 & yrbirth3 <= 1945
tab father_absent father_absent_3955
tab yrbirth3 father_absent_3955



*** INTERACTION TERMS

* interaction term: hunger x male
gen hungermale = hunger * male

* interaction term: father absent x war
gen war_father = father_absent * war

* interaction term: war x male
gen war_male = war * male

* interaction term: war x hunger
gen hunger_war = hunger * war

* interaction term: war x persecution
gen war_persec = persec * war

* interation term: war x dispossession
gen war_dispos = dispos * war



* country dummies
tab country
tab country if nativeborn == 1
xi i.country, pre(D)

label var Dcountry_12 Germany
label var Dcountry_13 Sweden
label var Dcountry_14 Netherlands
label var Dcountry_15 Spain
label var Dcountry_16 Italy
label var Dcountry_17 France
label var Dcountry_18 Denmark
label var Dcountry_19 Greece
label var Dcountry_20 Switzerland
label var Dcountry_23 Belgium
label var Dcountry_28 Czechia
label var Dcountry_29 Poland

* year dummies
tab yrbirth3, gen(yrbirth_d)
sum yrbirth_d*




*** SOCIOECONOMIC STATUS DURING CHILDHOOD 

* number of books during childhood
ren sl_cs008 childbooks
tab1 childbooks

recode childbooks (1 = 5) (2 = 18) (3 = 63) (4 = 150) (5 = 300)(-1 -2 = .), g(nbooks)
gen lognbooks = log(nbooks)	
tab nbooks
drop childbooks nbooks


* features at home during childhood
tab1 sl_cs007d*
forvalues i = 1/5 {
recode sl_cs007d`i' (-1 -2 = .)
}

forval i=1/5 {
	egen feat`i'=eqany(sl_cs007d*),v(`i')
	}
egen features=rsum(feat1-feat5)
tab features
drop sl_cs007*
drop feat1-feat5

* number of rooms/number of person in HH during childhood
tab1 sl_cs002 sl_cs003
recode sl_cs002 (-1 -2 = .)
recode sl_cs003 (-1 -2 = .)

gen ppr = sl_cs003/sl_cs002
gen logppr = ln(ppr)
tab1 ppr logppr
drop sl_cs002 sl_cs003 ppr

* occupation of main breadwinner during childhood
recode sl_cs009 (1/5 = 1) (6/max = 0)(-1 -2 = .), g(fthwhite)
tab fthwhite
drop sl_cs009


*** factor analysis for childhood ses
factor logppr lognbooks features fthwhite, pcf
predict ses
drop logppr lognbooks features 

* low ses
gen ses_low = 0
replace ses_low = . if ses == .
forvalues i = 11/29 {
sum ses if country == `i', d
replace ses_low = 1 if country == `i' & ses <= r(p25)
}
tab country ses_low

* medium ses
gen ses_med = 0
replace ses_med = . if ses == .
forvalues i = 11/29 {
sum ses if country == `i', d
replace ses_med = 1 if country == `i' & ses > r(p25) & ses < r(p75)
}
tab country ses_med

* high ses
gen ses_high = 0
replace ses_high = . if ses == .
forvalues i = 11/29 {
sum ses if country == `i', d
replace ses_high = 1 if country == `i' & ses >= r(p75) 
}

tab country ses_med
tab ses_low ses_med 
tab ses_med ses_high



*** INTERACTION TERMS

* interaction term: hunger x occupation main breadwinner
gen hungerfthwhite = hunger * fthwhite

* interaction term: war x ses
gen war_ses_low = war * ses_low
gen war_ses_med = war * ses_med

* interaction term: war x ses low/med x male
gen war_ses_low_male = war * ses_low * male
gen war_ses_med_male  = war * ses_med * male

* interaction term: ses low/med x male
gen ses_low_male = ses_low * male
gen ses_med_male = ses_med * male











********************************************************************************
*** COMPUTATION OF INTENSITY WAR MEASURE: EXPOSURE TO WAR 
********************************************************************************


*** NUMBER OF COMBATS

tab1 comb_sum*
table country, c(mean comb_sum1939 mean comb_sum1940 mean comb_sum1941 mean comb_sum1942 mean comb_sum1943)
table country, c(mean comb_sum1944 mean comb_sum1945)

egen comb_sum = rsum(comb_sum1939 comb_sum1940 comb_sum1941 comb_sum1942 comb_sum1943 comb_sum1944 comb_sum1945), m

tab country comb_sum
replace comb_sum = 0 if comb_sum == . & yrbirth3 > 1945 
 
tab country comb_sum if yrbirth3 >= 1946		
replace comb_sum = 0 if yrbirth3 >= 1946 & comb_sum ~= 0		

tab yrbirth3 comb_sum, m
replace comb_sum = . if yrbirth3 == .


* nonzero combats
gen nonzero_combats = (comb_sum != .)
replace nonzero_combats = 0 if comb_sum == 0


* 3-10 combats
gen combat_3_10 = (comb_sum > 2)
replace combat_3_10 = . if comb_sum == .


* 0-2 combats
gen war_combat_0_2 = 0
replace war_combat_0_2 = 1 if war == 1 & comb_sum < 3

tab country comb_sum if nativeborn == 1 & yrbirth3 < 1946
tab country combat_3_10 if nativeborn == 1 & yrbirth3 < 1946
tab country war_combat_0_2 if nativeborn == 1 & yrbirth3 < 1946
tab yrbirth3 country if comb_sum == 0 & nativeborn == 1 & yrbirth3 < 1946




*** INTERACTION TERMS

* interaction term: nonzero combats x male
gen nonzero_combats_male = nonzero_combats * male

* interaction term: combat x ses low
gen combat_3_10_ses_low         = combat_3_10 * ses_low
gen war_combat_0_2_ses_low      = war_combat_0_2 * ses_low

* interaction term: combat x ses low x male
gen combat_3_10_ses_low_male    = combat_3_10 * ses_low * male
gen war_combat_0_2_ses_low_male = war_combat_0_2 * ses_low * male

* interaction term: combat x ses medium
gen combat_3_10_ses_med         = combat_3_10 * ses_med
gen war_combat_0_2_ses_med      = war_combat_0_2 * ses_med

* interaction term: combat x ses medium x male
gen combat_3_10_ses_med_male    = combat_3_10 * ses_med * male
gen war_combat_0_2_ses_med_male = war_combat_0_2 * ses_med * male

* interaction term: combat x male
gen combat_3_10_male    = combat_3_10 * male
gen war_combat_0_2_male = war_combat_0_2 * male




*** COMBAT YEARS

egen comb_yrs = rsum(comb_mean1939 comb_mean1940 comb_mean1941 comb_mean1942 comb_mean1943 comb_mean1944 comb_mean1945), m
replace comb_yrs = 0 if comb_yrs == . & yrbirth3 > 1945 
 
tab yrbirth3 comb_yrs, m
replace comb_yrs = . if yrbirth3 == .
tab country comb_yrs if yrbirth3 >= 1946
replace comb_yrs = 0 if yrbirth3 >= 1946 & comb_yrs == 2

gen comb1_3 = (comb_yrs == 1| comb_yrs == 2 | comb_yrs == 3)
replace comb1_3 = . if comb_yrs == .




* cluster level
egen index = group(yrbirth3 country)

drop hhid1 waveid wave1 hhid2 wave2 hhid3 int_month_w3 int_year_w3 wave3 mergeid2
drop current_region comb_mean*


save "$datapath\final\WWII_final.dta", replace
