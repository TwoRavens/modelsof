* Gautam Nair
* gautam.nair@yale.edu
* Misperceptions of Relative Affluence and Support for International Transfers
* Journal of Politics
* Coding and formatting of Raw Data 

* change the working directory to directory containing code and data
cd ""

insheet using "d_question_timings.csv", comma clear
saveold "d_question_timings.dta", replace

insheet using "d_zipcode_income_petitions_dataset.csv", comma clear
saveold "d_zipcode_income_petitions_dataset.dta", replace

use "d_TESS3_186_Nair_Client.dta", clear

renvars *, lower

* merge zipcode median + petitions
merge 1:1 caseid using "d_zipcode_income_petitions_dataset.dta"
drop _merge
* Note: zip code median data has been jittered slightly to ensure respondent confidentiality

* merge timings of answers to questions
merge 1:1 caseid using "d_question_timings.dta"
drop _merge

* erasing spare files 

erase "d_question_timings.dta"
erase "d_zipcode_income_petitions_dataset.dta"

* coding groups 
foreach num of numlist 1 2 3 4 5 {
	gen group`num'=(xtess==`num')
}

gen group=xtess

* coding charitable giving 
tab dov_bonus
tab dov_bonus, nolabel

* q13b hypothetical lottery nonresponse
list q13b* if q13b_1==-1 & q13b_2==-1 & q13b_3==-1
gen q13b_noresponse=1 if q13b_1==-1 & q13b_2==-1 & q13b_3==-1

* q13b replacing missing values with 0's
foreach var of varlist q13b_1 q13b_2 q13b_3 {
	replace `var'=0 if `var'==-1 & q13b_noresponse!=1
	replace `var'=. if `var'==-1 & q13b_noresponse==1
}

* q13a actual lottery nonresponse
list q13a* if q13a_1==-1 & q13a_2==-1 & q13a_3==-1
gen q13a_noresponse=1 if q13a_1==-1 & q13a_2==-1 & q13a_3==-1

* q13a replacing missing values with 0's
foreach var of varlist q13a_1 q13a_2 q13a_3 {
	replace `var'=0 if `var'==-1 & q13a_noresponse!=1
	replace `var'=. if `var'==-1 & q13a_noresponse==1
}

* pooled q13a and q13b
foreach num of numlist 1/3 {
	gen q13ab_`num'=.
	replace q13ab_`num'=q13a_`num'
	replace q13ab_`num'=q13b_`num' if q13a_`num'>=. & q13b_`num'!=.
}


* pooled q13a and q13b 
gen q13ab_noresponse=(q13a_noresponse==1 | q13b_noresponse==1)
replace q13ab_noresponse=0 if q13a_noresponse==0 & q13b_noresponse==0

* positive contributions
foreach var in q13ab_1 q13ab_2 q13ab_3 q13a_1 q13a_2 q13a_3 q13b_2 q13b_3 {
	gen `var'_positive=(`var'>0) if `var'!=.
	gen `var'_100=(`var'==100) if `var'!=.
	gen `var'_amount=((`var')/100)*20
}

gen q13ab_positive=(q13ab_3>0 |q13ab_2>0) if q13ab_3!=. & q13ab_2!=.

foreach var in q13a_2 q13a_3 {
	bysort xtess: egen `var'_amount_group=total(`var'_amount)
}

gen q13ab_2_3_total=q13ab_2 +q13ab_3

* coding actual sums donated
gen donate_keep=20*(q13a_1/100) if q13a_1 !=.
egen donate_keep_total=total(donate_keep) if q13a_1 !=.
sum donate_keep_total

egen donate_keep_total_type=total(donate_keep) if q13a_1!=., by(dov_bonustype)  
bysort dov_bonustype: sum( donate_keep_total_type )

gen donate_dom=20*(q13a_2/100) if q13a_2 !=.
egen donate_dom_total=total(donate_dom)
sum donate_dom_total

egen donate_dom_total_type=total(donate_dom) if q13a_2!=., by(dov_bonustype)  
bysort dov_bonustype: sum( donate_dom_total_type )

gen donate_int=20*(q13a_3/100) if q13a_3 !=.
egen donate_int_total=total(donate_int)
sum donate_int_total

egen donate_int_total_type=total(donate_int) if q13a_3!=., by(dov_bonustype)  
bysort dov_bonustype: sum(donate_int_total_type)

bysort dov_bonustype: sum( donate_keep_total_type )
bysort dov_bonustype: sum( donate_dom_total_type )
bysort dov_bonustype: sum(donate_int_total_type)

di 737.4 + 973.6+ 1059.8 + 364.4 + 419.2 + 323 +178.2 +127.2 + 181.2
di 737.4 + 973.6 + 1059.8

* coding key outcomes

* q8 foreign aid ordinal
tab q8
tab q8, nolabel
gen q8_noresponse=(q8==1)
replace q8=q8-1
replace q8=. if q8==0
tab q8, nolabel m
label define q8 ///
1 "too much + petition" ///
2 "too much" ///
3 "about the right amount" ///
4 "too little" ///
5 "too little + petition" 
label values q8 q8

* q8 foreign aid too little dummy
gen q8_toolittle=(q8==4 | q8 ==5) if q8!=.
label define q8_toolittle 1 "too little or too little + petition" 0 "otherwise"
label values q8_toolittle q8_toolittle

* q8 foreign aid too little dummy petition
gen q8_toolittle_petition=(q8 ==5) if q8!=.
label define q8_toolittle_petition 1 "too little + petition" 0 "otherwise"
label values q8_toolittle_petition q8_toolittle_petition

* q8 foreign aid too little dummy petition + visited
gen q8_toolittle_petition_visited=(q8 ==5 & visited_petition_site==1) if q8!=.
label define q8_toolittle_petition_visited 1 "too little + petition + visited" 0 "otherwise"
label values q8_toolittle_petition_visited q8_toolittle_petition_visited

* q8 foreign aid about the right amount
gen q8_rightamount=(q8==3) if q8!=.
label define q8_rightamount 1 "about the right amount" 0 "otherwise"
label values q8_rightamount q8_rightamount

gen q8_toolittle_rightamount=(q8==3|q8==4|q8==5) if q8!=. 

* q8 foreign aid about the right amount
gen q8_toomuch=(q8==1|q8==2) if q8!=.
label define q8_toomuch 1 "too much or too much + petition" 0 "otherwise"
label values q8_toomuch q8_toomuch

* q8 foreign aid too much dummy petition
gen q8_toomuch_petition=(q8 ==1) if q8!=.
label define q8_toomuch_petition 1 "too much + petition" 0 "otherwise"
label values q8_toomuch_petition q8_toomuch_petition

* q8 foreign aid too much dummy petition + visited
gen q8_toomuch_petition_visited=(q8 ==1 & visited_petition_site==1) if q8!=.
label define q8_toomuch_petition_visited 1 "too much + petition + visited" 0 "otherwise"
label values q8_toomuch_petition_visited q8_toomuch_petition_visited


gen q8_categorical=1 if q8==1 |q8==2
replace q8_categorical=2 if q8==3
replace q8_categorical=3 if q8==4|q8==5
* q9 foreign aid as percentage of budget
sum q9, d
* note due to a miscommunication about the programming of the survey respondents
* could not a value <1 (the default was supposed to be set at 1% not the minimum value
gen q9_noresponse=(q9==-1)
replace q9=. if q9==-1

* q10 domestic inequality
tab q10
tab q10, nolabel
gen q10_noresponse=(q10>=.)
replace q10=q10-1
replace q10=. if q10==0
tab q10, nolabel m
label define q10 ///
1 "gshoulddsomethingtreducincomd " ///
2 "2" ///
3 "3" ///
4 "4" ///
5 "5" ///
6 "6" ///
7 "Governmentshouldnotconcernitselfwithin"
label values q10 q10

gen q10_reversed=8-q10

gen q10_yes=(q10_reversed>4) if q10_reversed!=.

* q11 agricultural tariffs and subsidies
tab q11
tab q11, nolabel
replace q11=q11-1
replace q11=. if q11==0
tab q11, nolabel m
label define q11 ///
1 "no" 2 "don't know" 3 "yes" 4 "yes + petition" 
label values q11 q11

gen q11_no=(q11==1) if q11!=.
label define q11_no 1 "no" 0 "don't know yes or yes + petition"
label values q11_no q11_no

gen q11_yes=(q11==3|q11==4) if q11!=.
label define q11_yes 1 "yes or yes + petition" 0 "no or don't know"
label values q11_yes q11_yes

gen q11_yes_nodk=(q11==3|q11==4) if q11!=. &q11!=2
label define q11_yes_nodk 1 "yes or yes + petition" 0 "no"
label values q11_yes_nodk q11_yes_nodk

gen q11_no_nodk=(q11==1) if q11!=. &q11!=2
label define q11_no_nodk 1 "no" 0 "yes"
label values q11_no_nodk q11_no_nodk

gen q11_dk=(q11==2) if q11!=.
label define q11_dk 1 "don't know" 0 "yes or no"
label values q11_dk q11_dk

gen q11_yes_petition=(q11==4) if q11!=.
label define q11_yes_petition 1 "yes + petition" 0 "no or don't know"
label values q11_yes_petition q11_yes_petition

gen q11_yes_petition_visited=(q11 ==4 & visited_petition_site==1) if q8!=.
label define q11_yes_petition_visited 1 "too little + petition + visited" 0 "otherwise"
label values q11_yes_petition_visited q8_yes_petition_visited

gen q11_noresponse=(q11>=.)

* foreign aid too little and cut agricultural protections
gen q8_toolittle_1_q11_yes_1=(q8_toolittle==1& q11_yes==1) if q8_toolittle!=. & q11_yes!=.

* q12 social desirability bias past year's charitable giving
tab q12
tab q12, nolabel
gen q12_noresponse=(q12==1)
replace q12=q12-1
replace q12=. if q12==0
replace q12=q12-1
label define q12 0 "no" 1 "yes"
label values q12 q12

gen ppp10089_noresponse=1 if ppp10089==1
replace ppp10089_noresponse=2 if ppp10089==2
replace ppp10089_noresponse=0 if ppp10089_noresponse>=.
label define ppp10089_noresponse 1 "not asked" 2 "refused" 0 "has response"
replace ppp10089=. if (ppp10089==1 | ppp10089==2)
replace ppp10089=ppp10089-3
label define ppp10089_label 1 "yes" 0 "no"
label values ppp10089 ppp10089_label

gen q12_ppp10089= q12-ppp10089
tab q12_ppp10089

* baseline charitable giving (upon entering the panel)
gen charity_pretreat_yes=(ppp10089==1) if ppp10089!=.
gen charity_pretreat_no=(ppp10089==0) if ppp10089!=.
gen altruism=(charity_pretreat_yes==1)

* q14 norms of giving
tab q14
tab q14, nolabel
gen q14_noresponse=(q14==1)
replace q14=q14-1
replace q14=. if q14==0
label define q14 ///
1 "strongly disagree" 2 "disagree" 3 "neither agree nor disagree" 4 "agree" 5 "strongly agree"
label values q14 q14

gen giving_norms_agree=(q14==4|q14==5)

* global rank eqvuivalization factor
egen ppt_01_25_612=rowtotal(ppt01 ppt25 ppt612)
replace ppt_01_25_612=ppt_01_25_612*0.5
egen ppt_1317_18ov=rowtotal(ppt1317 ppt18ov)
gen equiv_2a=ppt_1317_18ov if ppt_1317_18ov>1  
replace equiv_2a=((equiv_2a-1)*0.7) +1
gen equiv_2b=ppt_1317_18ov if ppt_1317_18ov==1
gen equivalization_factor=equiv_2a
replace equivalization_factor=equiv_2b if equivalization_factor>=.
replace equivalization_factor=equivalization_factor+ppt_01_25_612
drop equiv_2a equiv_2b
* see survey description for how this is calculated: the first adult is weighted as 1, persons over age 12 by 0.7, and persons below 12 by 0.5. Then the sum is taken.

* post tax income
tab income_new
gen income_new_posttax=.
replace income_new_posttax=2198 if income_new==1
replace income_new_posttax=5493 if income_new==2
replace income_new_posttax=7691 if income_new==3
replace income_new_posttax=9888 if income_new==4
replace income_new_posttax=12086 if income_new==5
replace income_new_posttax=15382 if income_new==6
replace income_new_posttax=19777 if income_new==7
replace income_new_posttax=22907 if income_new==8
replace income_new_posttax=27072 if income_new==9
replace income_new_posttax=31237 if income_new==10
replace income_new_posttax=37485 if income_new==11
replace income_new_posttax=42790 if income_new==12
replace income_new_posttax=52515 if income_new==13
replace income_new_posttax=60320 if income_new==14
replace income_new_posttax=69745 if income_new==15
replace income_new_posttax=84825 if income_new==16
replace income_new_posttax=101062 if income_new==17
replace income_new_posttax=119437 if income_new==18
replace income_new_posttax=120050 if income_new==19

* equivalized post tax income
gen income_new_posttax_equiv=income_new_posttax/equivalization_factor
replace income_new_posttax_equiv=round(income_new_posttax_equiv)

* income midpoint
tab income_new
gen income_new_midpoint=.
replace income_new_midpoint=2500 if income_new==1
replace income_new_midpoint=6250 if income_new==2
replace income_new_midpoint=8750 if income_new==3
replace income_new_midpoint=11250 if income_new==4
replace income_new_midpoint=13750 if income_new==5
replace income_new_midpoint=17500 if income_new==6
replace income_new_midpoint=22500 if income_new==7
replace income_new_midpoint=27500 if income_new==8
replace income_new_midpoint=32500 if income_new==9
replace income_new_midpoint=37500 if income_new==10
replace income_new_midpoint=45000 if income_new==11
replace income_new_midpoint=55000 if income_new==12
replace income_new_midpoint=67500 if income_new==13
replace income_new_midpoint=80000 if income_new==14
replace income_new_midpoint=92500 if income_new==15
replace income_new_midpoint=112500 if income_new==16
replace income_new_midpoint=137500 if income_new==17
replace income_new_midpoint=162500 if income_new==18
replace income_new_midpoint=175000 if income_new==19

* income midpoint divided by 10000
gen income_new_midpoint_10000=income_new_midpoint/10000

* percentile rank
* change nonresponse to missing
gen q3a_nonresponse=(q3a==-1)
replace q3a=. if q3a==-1

gen rank_global_true=.
replace rank_global_true=0 if income_new_posttax_equiv<598
replace rank_global_true=10 if income_new_posttax_equiv>=598 & income_new_posttax_equiv<819
replace rank_global_true=20 if income_new_posttax_equiv>=819 & income_new_posttax_equiv<1091
replace rank_global_true=30 if income_new_posttax_equiv>=1091 & income_new_posttax_equiv<1496
replace rank_global_true=40 if income_new_posttax_equiv>=1496 & income_new_posttax_equiv<2108
replace rank_global_true=50 if income_new_posttax_equiv>=2108 & income_new_posttax_equiv<3104
replace rank_global_true=60 if income_new_posttax_equiv>=3104 & income_new_posttax_equiv<4749
replace rank_global_true=70 if income_new_posttax_equiv>=4749 & income_new_posttax_equiv<7810
replace rank_global_true=80 if income_new_posttax_equiv>=7810 & income_new_posttax_equiv<14158
replace rank_global_true=90 if income_new_posttax_equiv>=14158 & income_new_posttax_equiv<21142
replace rank_global_true=95 if income_new_posttax_equiv>=21142 & income_new_posttax_equiv<80000
replace rank_global_true=99 if income_new_posttax_equiv>=80000 & income_new_posttax_equiv
replace rank_global_true=. if q3a>=.

* rank estimation
gen rank_estimate=q3a
gen rank_estimate_diff=rank_estimate-rank_global_true if rank_estimate!=.
label var rank_estimate_diff "difference between respondent's estimate of rank and true rank"

gen rank_estimate_diff_bias=rank_global_true-rank_estimate if rank_estimate!=.
label var rank_estimate_diff_bias "difference between respondent's true rank and estimate of rank"

gen rank_estimate_categorical=2 if abs(rank_estimate_diff)<=10
replace rank_estimate_categorical=1 if rank_estimate_diff>10 & rank_estimate_diff!=.
replace rank_estimate_categorical=3 if rank_estimate_diff<-10 & rank_estimate_diff!=.
label define rank_estimate_categorical 3 "Underestimate" 2 "Correct +/- 10" 1 "Overestimate", replace
label values rank_estimate_categorical rank_estimate_categorical

gen rank_estimate_under=(rank_estimate_categorical==3) if rank_estimate_categorical!=.
gen rank_estimate_over=(rank_estimate_categorical==1) if rank_estimate_categorical!=.
gen rank_estimate_correct=(rank_estimate_categorical==2) if rank_estimate_categorical!=.

* median estimate
gen q3b_nonresponse = (q3b==-1)
replace q3b=. if q3b==-1
gen median_estimate=q3b

* top coding median estimate at 1000000
gen median_estimate_topcoded=q3b
replace median_estimate_topcoded=. if median_estimate_topcoded>100000 & q3b!=.

gen median_estimate_top_100k=q3b
replace median_estimate_top_100k=. if median_estimate_top_100k>100000 & q3b!=.
gen median_estimate_top_100k_10000= median_estimate_top_100k/10000

gen median_estimate_correct=(median_estimate<4000) if median_estimate!=.

gen median_estimate_incorrect=(median_estimate_correct!=1) if median_estimate_correct!=.

* rank and median
gen rank_median_over_correct=((rank_estimate_categorical==2|rank_estimate_categorical==1) & median_estimate_correct==1) if rank_estimate_categorical!=. & median_estimate_correct!=.
gen rank_median_over_incorrect=(rank_median_over_correct==0) if rank_median_over_correct!=.

* luck and effort
gen q1_noresponse=(q1==1)
replace q1=q1-1
replace q1=. if q1==0
label define q1 1 "mostly hard work" 2 "mix of luck and effort" 3 "mostly luck"
label values q1 q1

gen effort_luck_categorical=q1
label values effort_luck_categorical q1

gen effort_luck_mostly_work=(q1==1)  if q1!=.
gen effort_luck_mix_mostly_luck=(q1==2|q1==3) if q1!=.

* self identity
foreach var of varlist q2_1 q2_2 q2_3 {
	gen `var'_noresponse=(`var'==1)
	replace `var'=`var'-1
	replace `var'=. if `var'==0
	label define `var' 1 "strongly disagree" 2 "disagree" 3 "neither agree nor disagree" 4 "agree" 5 "strongly agree"
	label values `var' `var'
	
	gen `var'_agree_strongly_agree=(`var'==4|`var'==5) if `var'!=.
}

gen identity_cosmopolitan=(q2_3==4 |q2_3==5) if q2_3!=.
label define identity_cosmopolitan 1 "world citizen agree or strongly agree" 0 "neither a or d disagree strongly disagree"
label values identity_cosmopolitan identity_cosmopolitan
gen identity_other=(q2_3==1 |q2_3==2|q2_3==3) if q2_3!=.


* ideology
gen ideo_new_refused=(ideo_new==1)
replace ideo_new=. if ideo_new==1
replace ideo_new=ideo_new-1
tab ideo_new
label define ideo_new 1 "extremely liberal" 2 "liberal" 3 "slightly liberal" 4 "moderate" 5 "slightly conservative" 6 "conservative" 7 "extremely conservative"
label values ideo_new ideo_new

gen ideology_liberal=(ideo_new==1 |ideo_new==2 | ideo_new==3) if ideo_new!=.
gen ideology_moderate=(ideo_new==4) if ideo_new!=.
gen ideology_conservative=(ideo_new==5|ideo_new==6|ideo_new==7) if ideo_new!=.

gen ideology_categorical=3 if ideology_liberal==1
replace ideology_categorical=2 if ideology_moderate==1
replace ideology_categorical=1 if ideology_conservative==1
label define ideology_categorical 1 "conservative" 2 "moderate" 3 "liberal"
label values ideology_categorical ideology_categorical

* party id
gen partyid=xparty7_new-1
# delimit ;
label define partyid 
1 "strong republican"
2 "not strong republican"
3 "leans republican"
4 "undecided independent other"
5 "leans democrat"
6 "not strong democrat"
7 "strong democrat"
;
# delimit cr
label values partyid partyid
gen partyid_republican=(partyid==1|partyid==2|partyid==3) if partyid!=.
gen partyid_independent=(partyid==4) if partyid!=.
gen partyid_democrat=(partyid==5|partyid==6|partyid==7) if partyid!=.

gen partyid_categorical=1 if partyid_republican==1
replace partyid_categorical=2 if partyid_independent==1
replace partyid_categorical=3 if partyid_democrat==1
label define partyid_categorical 1 "republican" 2 "independent" 3 "democrat"
label values partyid_categorical partyid_categorical

* religion
gen religion_christian=(rel1_new==2 | rel1_new==3 | rel1_new==4 | rel1_new==5 | rel1_new==10 | rel1_new==11 | rel1_new==12)  if rel1_new!=1
gen religion_none=(rel1_new==14)  if rel1_new!=.
gen religion_other=(religion_christian!=1 & religion_none!=1) if rel1_new!=.

* religious service attendance
gen religion_attendance=rel2_new-1
# delimit ;
label define religion_attendance
1 "More than once a week"
2 "Once a week"
3 "Once or twice a month"
4 "A few times a year"
5 "Once a year or less"
6 "Never"
;
# delimit cr
label values religion_attendance religion_attendance
replace religion_attendance=. if religion_attendance==0

gen religion_attendance_often= (religion_attendance!=5 & religion_attendance!=6) if religion_attendance!=.

* income categorical
tab income_new
tab income_new, nolabel
gen income_cat_0_25=(income_new<8)
gen income_cat_25_50=(income_new>7 & income_new<12)
gen income_cat_50_75=(income_new>11 & income_new<14)
gen income_cat_75_100=(income_new>13 & income_new<16)
gen income_cat_100_plus=(income_new>15)

gen income_categorical=1 if income_new<8
replace income_categorical=2 if income_new>7 & income_new<12
replace income_categorical=3 if income_new>11 & income_new<14
replace income_categorical=4 if income_new>13 & income_new<16
replace income_categorical=5 if income_new>15
label define income_categorical 1 "$0-$25k" 2 "$25-$50k" 3 "$50-$75k" 4 "$75k-$100k" 5 "$100k plus"
label values income_categorical income_categorical

gen income_50k_atabove=(income_categorical>=3) if income_categorical!=.
gen income_50k_below=(income_categorical<3) if income_categorical!=.

* age categorical
gen age_categorical=ppagect4
label values age_categorical ppagect4
gen age_cat_18_29=(age_categorical==1) if age_categorical!=.
gen age_cat_30_44=(age_categorical==2) if age_categorical!=.
gen age_cat_45_59=(age_categorical==3) if age_categorical!=.
gen age_cat_60_plus=(age_categorical==4) if age_categorical!=.
gen age=ppage

* education categorical
tab ppeducat
tab ppeducat, nolabel
gen education_categorical=ppeducat-2
label define education_categorical 1 "Less than high school" 2 "High school" 3 "Some college" 4 "Bachelor's degree or higher"
label values education_categorical education_categorical

gen educat_ba_plus=(education_categorical==4) if education_categorical!=.
gen educat_high_school_plus=(education_categorical>=2) if education_categorical!=.

* race
gen race_white=(ppethm==3) if ppethm!=.
gen race_black=(ppethm==4) if ppethm!=.
gen race_hispanic=(ppethm==6) if ppethm!=.
gen race_other=(ppethm==5 |ppethm==7) if ppethm!=.

gen race_categorical = 1 if race_white==1
replace race_categorical=2 if race_black==1
replace race_categorical=3 if race_hispanic==1
replace race_categorical=4 if race_other==1
label define race_categorical 1 "white" 2 "black" 3 "hispanic" 4 "other"
label values race_categorical race_categorical

* gender
gen gender_male=(ppgender==3) if ppgender!=. 
gen gender_female=(ppgender==4) if ppgender!=. 

* hh head
gen hh_head_yes=(pphhhead==4) if pphhhead!=.
gen hh_head_no=(pphhhead==3) if pphhhead!=.

* hhsize
tab pphhsize
gen hhsize=pphhsize
gen hhsize_one=(pphhsize==1) 
gen hhsize_two=(pphhsize==2)
gen hhsize_more=(pphhsize>2)

* marital status
gen married_now_yes=(ppmarit==3) if ppmarit!=.
gen married_now_no=(ppmarit!=3) if ppmarit!=.

* metro area
gen metro_area_yes=(ppmsacat==4) if ppmsacat!=.
gen metro_area_no=(ppmsacat!=4) if ppmsacat!=.

* region
tab ppreg4
tab ppreg4, nolabel
gen region=ppreg4-2
label define region 1 "Northeast" 2 "Midwest" 3 "South" 4 "West"
label values region region

* own home
tab pprent
tab pprent, nolabel
gen home_own=(pprent==3)
gen home_rent_other=(pprent==4|pprent==5)

* ppnet ppp10089 ppp10031
tab ppwork
tab ppwork, nolabel

gen work_employed=(ppwork==3|ppwork==4) if ppwork!=.
gen work_retired=(ppwork==7) if ppwork!=.
gen work_notworking_other=(ppwork==5 | ppwork==6 | ppwork==8 | ppwork==9) if ppwork!=.

gen work_unemployed_disabled=(ppwork==5|ppwork==6|ppwork==8)
gen work_other=(ppwork==9)

gen work_categorical=ppwork
label define work_categorical ///
 3 "employed" ///
 4 "self employ" ///
 5 "not layoff temp" ///
 6 "not looking for work" ///
 7 "not retired" ///
 8 "not disabled" ///
 9 "not other"
 label values work_categorical work_categorical
 
gen employment_categorical=1 if work_categorical==3 | work_categorical==4
replace employment_categorical=2 if work_categorical==5 | work_categorical==6
replace employment_categorical=3 if work_categorical==7  | work_categorical== 8
replace employment_categorical=4 if work_categorical==9
label define employment_categorical 1 "employed/selfemployed" 2 "layoff/unemployed" 3 "retired/disabled" 4 "other"
label values employment_categorical employment_categorical

* home internet
gen home_internet_yes=(ppnet==2) if ppnet!=.
gen home_internet_no=(ppnet!=2) if ppnet!=.

* obama on foreign affairs
tab ppp10031
tab ppp10031, nolabel
gen obama_foreign_toomuch=(ppp10031==3) if ppp10031!=1
gen obama_foreign_rightamount=(ppp10031==4) if ppp10031!=1
gen obama_foreign_toolittle=(ppp10031==5) if ppp10031!=1

gen isolationist_liberal=obama_foreign_toomuch*ideology_liberal

* coding domestic perceptions

gen rank_est_dom=q4a
gen median_est_dom=q4b

label var median_est_dom "Respondent Estimated Median Household Income Domestic"

gen rank_est_dom_refused=1 if rank_est_dom==-1
replace rank_est_dom_refused=0 if rank_est_dom!=. & rank_est_dom!=-1
tab rank_est_dom_refused income_new
replace rank_est_dom=. if rank_est_dom_refused
reg rank_est_dom_refused income_new, robust

gen rank_dom_true=.
replace rank_dom_true=1 if income_new==1
replace rank_dom_true=4 if income_new==2
replace rank_dom_true=6 if income_new==3
replace rank_dom_true=9 if income_new==4
replace rank_dom_true=12 if income_new==5
replace rank_dom_true=16 if income_new==6
replace rank_dom_true=21 if income_new==7
replace rank_dom_true=27 if income_new==8
replace rank_dom_true=32 if income_new==9
replace rank_dom_true=37 if income_new==10
replace rank_dom_true=44 if income_new==11
replace rank_dom_true=48 if income_new==12
replace rank_dom_true=100-39 if income_new==13
replace rank_dom_true=100-32 if income_new==14
replace rank_dom_true=100-26 if income_new==15
replace rank_dom_true=100-18 if income_new==16
replace rank_dom_true=100-12 if income_new==17
replace rank_dom_true=100-8 if income_new==18
replace rank_dom_true=100-5 if income_new==19

gen rank_est_dom_diff=rank_est_dom-rank_dom_true if rank_est_dom!=.
label var rank_est_dom_diff "difference between respondent's estimate of rank and true rank"
gen rank_est_dom_diff_50=rank_est_dom_diff
replace rank_est_dom_diff_50=. if rank_est_dom_diff_50>50 | rank_est_dom_diff_50<-50

gen rank_est_dom_diff_bias=rank_dom_true-rank_est_dom if rank_est_dom!=.
label var rank_est_dom_diff_bias "difference between respondent's true rank and estimate of rank"

gen rank_est_dom_categorical=2 if abs(rank_est_dom_diff)<=10
replace rank_est_dom_categorical=1 if rank_est_dom_diff>10 & rank_est_dom_diff!=.
replace rank_est_dom_categorical=3 if rank_est_dom_diff<-10 & rank_est_dom_diff!=.
label define rank_est_dom_categorical 3 "Underestimate" 2 "Correct +/- 10" 1 "Overestimate", replace
label values rank_est_dom_categorical rank_est_dom_categorical

gen rank_est_dom_under=(rank_est_dom_categorical==3) if rank_est_dom_categorical!=.
gen rank_est_dom_over=(rank_est_dom_categorical==1) if rank_est_dom_categorical!=.
gen rank_est_dom_correct=(rank_est_dom_categorical==2) if rank_est_dom_categorical!=.

* keeping control salience and international groups (domestic groups 4 and 5 are subject of another paper)

keep if group==1|group==2|group==3

saveold "d_cleaned_analysis_dataset.dta", replace
* outsheet using "d_cleaned_analysis_dataset.csv", comma replace

