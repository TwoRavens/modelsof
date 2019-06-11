set more off
clear

*-----------------------*
* A. IMPORT RAW DATA *
*-----------------------*

*** 1. START US ***
use "$path/raw_us.dta"

* Prepare vars
rename	caseid ID

* Altruism and reciprocity measures
recode	q2_1 (1=1) (nonmiss=0), gen(altru_donate)
label var altru_donate "Wants to donate"
drop	q2_1

rename	q2_1a altru_charity
replace	altru_charity=. if altru_charity>=98
tab altru_charity
rename q2_1a_t altru_charity_other //Choice: other

rename	q2_1b_rule altru_howmuch
replace	altru_howmuch=. if altru_howmuch>100
replace altru_howmuch=0 if altru_donate==0
label var altru_howmuch "Donation ($)"

gen altru_high_group= (altru_howmuch>=50 & altru_howmuch<.)
label define hilo 0 "low" 1 "high"
label values altru_high_group hilo
tab altru_high_group

tab altru_howmuch

rename q2_amount1 recip_ex_own_contrib
rename q2_amount2 recip_ex_payoff_to_w2
rename q2_amount3 recip_ex_other_contrib
rename q2_amount4 recip_ex_payoff_own

rename q2_2a_rule recip_expect_contrib
label var recip_expect_contrib "Expected contribution ($)"
replace recip_expect_contrib=. if recip_expect_contrib>100

rename q2_2b_rule recip_own_contrib
label var recip_own_contrib "Own contribution ($)"
replace recip_own_contrib =. if recip_own_contrib>100

rename q2_2c_0_rule recip_own_if_other0
replace recip_own_if_other0 =. if recip_own_if_other0>100

rename q2_2c_25_rule recip_own_if_other25
replace recip_own_if_other25 =. if recip_own_if_other25>100

rename q2_2c_50_rule recip_own_if_other50
replace recip_own_if_other50 =. if recip_own_if_other50>100

rename q2_2c_75_rule recip_own_if_other75
replace recip_own_if_other75 =. if recip_own_if_other75>100

rename q2_2c_100_rule recip_own_if_other100
replace recip_own_if_other100 =. if recip_own_if_other100>100

gen r0=0
gen r25=25
gen r50=50
gen r75=75
gen r100=100


gen		 	recip_sd_method=-abs(recip_own_contrib-recip_expect_contrib)
label var 	recip_sd_method "Reciprocity measure: Specific decision (-1)*|Own-Expected|"
*hist 		recip_sd_method, percent
su recip_sd_method, det
gen recip_sd_high_group=(recip_sd_method>=r(p50) & recip_sd_method<.)
label var recip_sd_high_group "Reciprocity: high (SD method)"
label values recip_sd_high_group hilo

gen		 	recip_sd_method2=recip_expect_contrib
replace 	recip_sd_method2=0.01 if recip_expect_contrib==0
replace 	recip_sd_method2=recip_own_contrib/recip_sd_method2
label var 	recip_sd_method2 "Reciprocity measure: Specific decision (own/expected)"

tab inputstate

* save data here already
cd "$path"
save main_us.dta, replace

* Generate second reciprocity measure from strategy method
* Using a regression on the long format of the data
keep ID recip_own_if_other0 recip_own_if_other25 recip_own_if_other50 recip_own_if_other75 recip_own_if_other100

reshape long recip_own_if_other, i(ID) j(other)
*twoway (scatter recip_own_if_other other)
*regress recip_own_if_other other



* Reciprocity measures: compute and correlate
* use the parmest package
* Already there: recip_sd_method
set more off
qui parmby "quietly regr recip_own_if_other other",by(ID) label saving(recipr_aux,replace)
clear

* Keep only estimate for other contribution
use recipr_aux.dta
keep if parmseq==1
save recipr_aux.dta, replace

* Do the merging 
use main_us.dta 
sort ID
merge ID using recipr_aux
su _merge
drop parmseq parm label stderr dof t p min95 max95 _merge


* Transform regression estimate for strategy method:
* deviations from 1 mean less reciprocity
* compute -abs|1-beta|
gen recip_s_method=.

order ID estimate recip_s_method recip_own_if_other0 - recip_own_if_other100 r0 r25 r50 r75 r100
replace recip_s_method=estimate

label var recip_s_method "Reciprocity measure: Strategy method"

su recip_s_method, det

gen recip_s_high_group=(recip_s_method>=r(p50) & recip_s_method<.)
label var recip_s_high_group "Reciprocity: high (S method)
label values recip_s_high_group hilo
  	
tab recip_s_high_group

* Party identification
recode q8_1a (1=1) (2=0) (nonmiss=.), gen(partyid_yesno)
label var partyid "Party identificatin (Yes)"

recode 		q8_1b (1=1) (2=2) (3=3) (nonmiss=.), gen(partyid)
label var 	partyid "Party identificatin (1=Republican, 2=Democrat, 3=Other"
label 		define partyid 1 "Republican" 2 "Democratic" 3 "Other"
label 		values partyid partyid

gen republican=.
replace republican=0 if partyid==2
replace republican=1 if partyid==1
label var republican "Identify with Republicans (vs Democrats)"
label define republican 0 "Democrat" 1 "Republican"
label values republican republican

recode 		q8_2 (1=4) (2=3) (3=2) (4=1) (nonmiss=.), gen(partyid_strength)
label var 	partyid_strength "Strength of party identification"
label 		define close 1 "Not at all close" 2 "Not very close" 3 "Somewhat close" 4 "Very close"
label 		values partyid_strength close

rename 		q8_3 ideology
replace		ideology=. if ideology>10
label var 	ideology "L-R ideology (0-10)"
su 			ideology, det

gen			right=.
replace		right=0 if ideology<=r(p50)
replace 	right=1 if ideology>r(p50) & ideology<.
label var	right "Ideology: Right vs. left"

* Knowledge 1 (Secretary of Defense is Leon Panetta, coded as 2)
recode 		q9bx (2=1) (nonmiss=0), gen(gknow1)
label var 	gknow1 "General knowledge: Secretary of State"

* Knowledge 2 (Majority in House: Republicans coded as 2)
recode 		q9_2 (2=1) (nonmiss=0), gen(gknow2)
label var 	gknow2 "General knowledge: Majority party in House"

* Knowledge 3 (Term Length of US Senator: 6 years coded as 6)
recode 		q9_3 (6=1) (nonmiss=0), gen(gknow3)
label var 	gknow3 "General knowledge: Term length Senate"

* Attention check
recode	attentioncheck_pass (2=0) (1=1) 
tab		attentioncheck_pass

* Employment
recode q10_1 (7=10) (8=10) (9=.) (10=10) (98=.) (99=.), gen(employment)
label var 	employment "Employment status"
label define empl 1 "Paid work" 2 "In education" 3 "Unemployed (looking)" 4 "Unemployed" 5 "Sick/disabled" 6 "Retired" 7 "Community service" 10 "Other" 11 "Military service"
label values employment empl

gen	emplgr_pwork	=	(employment>=1 & employment<=1)
gen	emplgr_educ		=	(employment>=2 & employment<=2)
gen	emplgr_unemp	=	(employment>=3 & employment<=4)
gen	emplgr_retired	=	(employment>=6 & employment<=6)
gen	emplgr_hwork	=	(employment>=8 & employment>=8)

* Car ownership
recode q10_3 (1=1) (2=0) (nonmiss=.), gen(owncar)
label var owncar "Car ownership"
tab owncar



* Education
tab educ
/* 
For the US, that would be simply be "Some College" "College Grad" and 
"Post-Grad" would all get ones (3 through 6) 
and those 
with less (1 and 2) would get zeros.
*/
gen educ_high=0 if educ!=.
replace educ_high=1 if educ>=3 & educ<=6

label define educ_high 0 "Education: Low" 1 "Education: High"
label values educ_high educ_high
tab educ_high

* Age
gen			age=2012-birthyr
label var	age "Age"
sort age
order age

gen 	below18=0
replace	below18=1 if age<18

gen 	below14=0
replace	below14=1 if age<14

gen  agegr18_29 = (age>17 & age<30)
gen  agegr30_39 = (age>29 & age<40)
gen  agegr40_49 = (age>39 & age<50)
gen  agegr50_59 = (age>49 & age<60)
gen  agegr60_69 = (age>59 & age<70)
gen  agegr70_o 	= (age>69 & age!=.)

gen  agegr18_39 = (age>17 & age<40)
gen  agegr40_59 = (age>39 & age<60)
gen  agegr60_o = (age>59 & age!=.)

*foreach y of varlist agegr18_29-agegr70_o {
*tab `y'
*}

* Female
recode 			gender (1=0) (2=1) (nonmiss=.), gen(female)
label var		female "Female"
label define 	female 1 Female 0 Male
label values 	female female
tab female [iweight = weight]
tab female

* Recode age for comparison of margins in sample and voter population
gen agegrd_us=.
replace agegrd_us=1 if age>=18 & age<=34
replace agegrd_us=2 if age>=35 & age<55
replace agegrd_us=3 if age>=55

label define agegrd_us 1 "18-39" 2 "40-54" 3 "55+"
label values agegrd_us agegrd_us

tab agegrd_us
svyset [pweight=weight]
svy: tab agegrd_us

gen educgrd_us=.
label var educgrd_us "Education: Sociodemographics"

replace educgrd_us =1 if educ<=2
replace educgrd_us =2 if educ==3
replace educgrd_us =3 if educ>=4 & educ<=5
replace educgrd_us =4 if educ==6

label define educgrd_us 1 "HS or less" 2 "Some College" 3 "College Graduate" 4 "Postgraduate"
label values educgrd_us educgrd_us

tab educgrd_us [iweight = weight]
tab educgrd_us

* Education
replace			educ=. if educ==8 | educ==9
label var		educ "Highest level of education"
label define 	educ 1 "No HS" 2 "High school" 3 "Some college" 4 "2-year" 5 "4-year" 6 "Post-grad" 
label values 	educ educ

* Income
recode faminc (31=2) (97=.) (98=.) (99=.), gen(income)
quietly su income, det

gen  incgr_low 			= (income>0 & income<r(p25))
gen  incgr_lowermiddle 	= (income>=r(p25) & income<r(p50))
gen  incgr_uppermiddle 	= (income>=r(p50) & income<r(p75))
gen  incgr_high 		= (income>=r(p75) & income<=.)

gen inc_high_group=(income>=r(p50) & income<.)
cd "$path"
label data "U.S. data, Bechtel/Scheve"
save main_us.dta, replace
clear

*** END US ***



*** 2. START UK ***
use "$path/raw_uk.dta"

* Prepare vars
rename	caseid ID
sort ID

* Altruism and reciprocity measures
recode	q2_1 (1=1) (nonmiss=0), gen(altru_donate)
label var altru_donate "Wants to donate"
drop	q2_1

rename	q2_1a altru_charity
replace	altru_charity=. if altru_charity>=98
tab altru_charity
rename q2_1a_t altru_charity_other //Choice: other

rename	q2_1b_rule altru_howmuch
replace	altru_howmuch=. if altru_howmuch>100
replace altru_howmuch=0 if altru_donate==0
label var altru_howmuch "Donation ($)"

gen altru_high_group= (altru_howmuch>=50 & altru_howmuch<.)
label define hilo 0 "low" 1 "high"
label values altru_high_group hilo
tab altru_high_group

tab altru_howmuch

rename q2_amount1 recip_ex_own_contrib
rename q2_amount2 recip_ex_payoff_to_w2
rename q2_amount3 recip_ex_other_contrib
rename q2_amount4 recip_ex_payoff_own

rename q2_2a_rule recip_expect_contrib
label var recip_expect_contrib "Expected contribution ($)"
replace recip_expect_contrib=. if recip_expect_contrib>100

rename q2_2b_rule recip_own_contrib
label var recip_own_contrib "Own contribution ($)"
replace recip_own_contrib =. if recip_own_contrib>100

rename q2_2c_0_rule recip_own_if_other0
replace recip_own_if_other0 =. if recip_own_if_other0>100

rename q2_2c_25_rule recip_own_if_other25
replace recip_own_if_other25 =. if recip_own_if_other25>100

rename q2_2c_50_rule recip_own_if_other50
replace recip_own_if_other50 =. if recip_own_if_other50>100

rename q2_2c_75_rule recip_own_if_other75
replace recip_own_if_other75 =. if recip_own_if_other75>100

rename q2_2c_100_rule recip_own_if_other100
replace recip_own_if_other100 =. if recip_own_if_other100>100

gen r0=0
gen r25=25
gen r50=50
gen r75=75
gen r100=100

* Generate reciprocity measures

set more off
gen		 	recip_sd_method=-abs(recip_own_contrib-recip_expect_contrib)
label var 	recip_sd_method "Reciprocity measure: Specific decision (-1)*|Own-Expected|"
*hist 		recip_sd_method, percent
su recip_sd_method, det
gen recip_sd_high_group=(recip_sd_method>=r(p50) & recip_sd_method<.)
label var recip_sd_high_group "Reciprocity: high (SD method)"
label values recip_sd_high_group hilo

gen		 	recip_sd_method2=recip_expect_contrib
replace 	recip_sd_method2=0.01 if recip_expect_contrib==0
replace 	recip_sd_method2=recip_own_contrib/recip_sd_method2
label var 	recip_sd_method2 "Reciprocity measure: Specific decision (own/expected)"


* save data
cd "$path"
save main_uk.dta, replace

* Generate second reciprocity measure from strategy method
* Using a regression on the long format of the data
keep ID recip_own_if_other0 recip_own_if_other25 recip_own_if_other50 recip_own_if_other75 recip_own_if_other100

reshape long recip_own_if_other, i(ID) j(other)
*twoway (scatter recip_own_if_other other)
*regress recip_own_if_other other

* Prepare loop over respondents for rolling regression
*egen 	aux=group(ID)
*su aux
*local max=r(max)

* Reciprocity measures: compute and correlate
* use the parmest package
* Already there: recip_sd_method
set more off
qui parmby "quietly regr recip_own_if_other other",by(ID) label saving(recipr_aux,replace)
clear

* Keep only estimate for other contribution
use recipr_aux.dta
keep if parmseq==1
save recipr_aux.dta, replace

* Do the merging 
use main_uk.dta 
sort ID
merge ID using recipr_aux
su _merge
drop parmseq parm label stderr dof t p min95 max95 _merge


* Transform regression estimate for strategy method:
* deviations from 1 mean less reciprocity
* compute -abs|1-beta|
gen recip_s_method=.

order ID estimate recip_s_method recip_own_if_other0 - recip_own_if_other100 r0 r25 r50 r75 r100
replace recip_s_method=estimate
*replace recip_s_method=(-1)*(abs(estimate-1))
label var recip_s_method "Reciprocity measure: Strategy method"

su recip_s_method, det

gen recip_s_high_group=(recip_s_method>=r(p50) & recip_s_method<.)
label var recip_s_high_group "Reciprocity: high (S method)
label values recip_s_high_group hilo
  	
tab recip_s_high_group

* Party identification
recode q8_1a (1=1) (2=0) (nonmiss=.), gen(partyid_yesno)
label var partyid "Party identification (Yes)"

recode 		q8_1b (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (nonmiss=.), gen(partyid)
label var 	partyid "Party identification"
label 		define partyid 1 "Labour" 2 "Conservatives" 3 "Liberal Democrats" 4 "Scottish National Party" 5 "Plaid Cymru" 6 "UK Independence Party" 7 "British National Party" 8 "Green Party" 9 "Other"
label 		values partyid partyid

gen labour=.
replace labour=0 if partyid==2
replace labour=1 if partyid==1
label var labour "Identify with Labour (vs Conservatives)"
label define labour 0 "Conservatives" 1 "Labour"
label values labour labour

recode 		q8_2 (1=4) (2=3) (3=2) (4=1) (nonmiss=.), gen(partyid_strength)
label var 	partyid_strength "Strength of party identification"
label 		define close 1 "Not at all close" 2 "Not very close" 3 "Somewhat close" 4 "Very close"
label 		values partyid_strength close

rename 		q8_3 ideology
replace		ideology=. if ideology>10
label var 	ideology "L-R ideology (0-10)"
su 			ideology, det

gen			right=.
replace		right=0 if ideology<=r(p50)
replace 	right=1 if ideology>r(p50) & ideology<.
label var	right "Ideology: Right vs. left"

* Knowledge
* Correct: Philip Hammond
recode 		q9bx (1=1) (nonmiss=0), gen(gknow1)
label var 	gknow1 "General knowledge: Minister of Defence"

* Correct: Conservativs, Con (306) in May 2010 election
recode 		q9_2 (2=1) (nonmiss=0), gen(gknow2)
label var 	gknow2 "General knowledge: Majority party in House"

* Term length: 5 years
recode 		q9_3 (5=1) (nonmiss=0), gen(gknow3)
label var 	gknow3 "General knowledge: Term length Senate"

* Attention check
recode	attentioncheck_pass (2=0) (1=1) 
tab		attentioncheck_pass

* Employment
recode q10_1 (7=10) (8=10) (9=.) (10=10) (98=.) (99=.), gen(employment)
label var 	employment "Employment status"
label define empl 1 "Paid work" 2 "In education" 3 "Unemployed (looking)" 4 "Unemployed" 5 "Sick/disabled" 6 "Retired" 7 "Community service" 10 "Other" 11 "Military service"
label values employment empl

gen	emplgr_pwork	=	(employment>=1 & employment<=1)
gen	emplgr_educ		=	(employment>=2 & employment<=2)
gen	emplgr_unemp	=	(employment>=3 & employment<=4)
gen	emplgr_retired	=	(employment>=6 & employment<=6)
gen	emplgr_hwork	=	(employment>=8 & employment>=8)

* Car ownership

recode q10_3 (1=1) (2=0) (nonmiss=.), gen(owncar)
label var owncar "Car ownership"
tab owncar


* Education
tab E1[iweight = weight]

gen educgrd_uk=.
label var educgrd_uk "Education: Sociodemographics"

replace educgrd_uk =1 if E1<=10
replace educgrd_uk =2 if E1>=11 & E1 <=14
replace educgrd_uk =3 if E1>=15 & E1<=18

label define educgrd_uk 1 "16 years or fewer" 2 "17-19 Years" 3 "20 years or more"
label values educgrd_uk educgrd_uk

tab educgrd_uk [iweight = weight]
tab educgrd_uk
/* 1 to 10 = 0
11 to 18 = 1
For the UK, the equivalent for France seems
 to be A levels in England and Scottish Higher Certificate
  in Scotland. So we code 1-10 a 0 and 
  11-18 a 1.
*/
gen educ_high=0
replace educ_high=1 if E1>=11 & E1<=18

label define educ_high 0 "Education: Low" 1 "Education: High"
label values educ_high educ_high
tab educ_high

* Age
gen			age=2012-birthyr
label var	age "Age"
sort age
order age

gen 	below18=0
replace	below18=1 if age<18

gen 	below14=0
replace	below14=1 if age<14

gen  agegr18_29 = (age>17 & age<30)
gen  agegr30_39 = (age>29 & age<40)
gen  agegr40_49 = (age>39 & age<50)
gen  agegr50_59 = (age>49 & age<60)
gen  agegr60_69 = (age>59 & age<70)
gen  agegr70_o 	= (age>69 & age!=.)

gen  agegr18_39 = (age>17 & age<40)
gen  agegr40_59 = (age>39 & age<60)
gen  agegr60_o = (age>59 & age!=.)


*foreach y of varlist agegr18_29-agegr70_o {
*tab `y'
*}


* Recode age for comparison of margins in sample and voter population
gen agegrd_uk=.


replace agegrd_uk=1 if age>=18 & age<34
replace agegrd_uk=2 if age>=35 & age<55
replace agegrd_uk=3 if age>=55 & age!=.


label define agegrd_uk 1 "18-34" 2 "35-54" 3 "55+"
label values agegrd_uk agegrd_uk


* Female
recode 			gender (1=0) (2=1) (nonmiss=.), gen(female)
label var		female "Female"
label define 	female 1 Female 0 Male
label values 	female female
tab gender [iweight = weight]
tab gender


* Income
gen income=faminc
replace income=. if faminc>=97
quietly su income, det

gen  incgr_low 			= (income>0 & income<r(p25))
gen  incgr_lowermiddle 	= (income>=r(p25) & income<r(p50))
gen  incgr_uppermiddle 	= (income>=r(p50) & income<r(p75))
gen  incgr_high 		= (income>=r(p75) & income<=.)
gen inc_high_group=(income>=r(p50) & income<.)


cd "$path"
label data "U.K. data, Bechtel/Scheve"
save main_uk.dta, replace
clear
*** END UK ***


*** 3. START FRANCE ***
use "$path/raw_fr.dta"

* Destring weight
destring weight, replace dpcomma

* Altruism and reciprocity measures
recode	q2_1 (1=1) (nonmiss=0), gen(altru_donate)
label var altru_donate "Wants to donate"
label define donate 0 "Not donate" 1 "Donates"
label values altru_donate donate
drop	q2_1

rename	q2_1a altru_charity
replace	altru_charity=. if altru_charity>=98
tab altru_charity
rename q2_1a_t altru_charity_other //Choice: other

rename	q2_1b_rule altru_howmuch
replace	altru_howmuch=. if altru_howmuch==999
replace altru_howmuch=0 if altru_donate==0
label var altru_howmuch "Donation ($)"

gen altru_high_group= (altru_howmuch>=50 & altru_howmuch<.)
label define hilo 0 "low" 1 "high"
label values altru_high_group hilo
tab altru_high_group

tab altru_howmuch

rename q2_amount1 recip_ex_own_contrib
rename q2_amount2 recip_ex_payoff_to_w2
rename q2_amount3 recip_ex_other_contrib
rename q2_amount4 recip_ex_payoff_own

rename q2_2a_rule recip_expect_contrib
label var recip_expect_contrib "Expected contribution ($)"
replace recip_expect_contrib=. if recip_expect_contrib>100

rename q2_2b_rule recip_own_contrib
label var recip_own_contrib "Own contribution ($)"
replace recip_own_contrib =. if recip_own_contrib>100

rename q2_2c_0_rule recip_own_if_other0
replace recip_own_if_other0 =. if recip_own_if_other0>100

rename q2_2c_25_rule recip_own_if_other25
replace recip_own_if_other25 =. if recip_own_if_other25>100

rename q2_2c_50_rule recip_own_if_other50
replace recip_own_if_other50 =. if recip_own_if_other50>100

rename q2_2c_75_rule recip_own_if_other75
replace recip_own_if_other75 =. if recip_own_if_other75>100

rename q2_2c_100_rule recip_own_if_other100
replace recip_own_if_other100 =. if recip_own_if_other100>100

gen r0=0
gen r25=25
gen r50=50
gen r75=75
gen r100=100

* Generate reciprocity measures

gen		 	recip_sd_method=-abs(recip_own_contrib-recip_expect_contrib)
label var 	recip_sd_method "Reciprocity measure: Specific decision (-1)*|Own-Expected|"
*hist 		recip_sd_method, percent
su recip_sd_method, det
gen recip_sd_high_group=(recip_sd_method>=r(p50) & recip_sd_method<.)
label var recip_sd_high_group "Reciprocity: high (SD method)"
label values recip_sd_high_group hilo

gen		 	recip_sd_method2=recip_expect_contrib
replace 	recip_sd_method2=0.01 if recip_expect_contrib==0
replace 	recip_sd_method2=recip_own_contrib/recip_sd_method2
label var 	recip_sd_method2 "Reciprocity measure: Specific decision (own/expected)"

* save data here already

save main_fr.dta, replace

* Generate second reciprocity measure from strategy method
* Using a regression on the long format of the data
keep ID recip_own_if_other0 recip_own_if_other25 recip_own_if_other50 recip_own_if_other75 recip_own_if_other100

reshape long recip_own_if_other, i(ID) j(other)

* Already there: recip_sd_method
set more off
qui parmby "quietly regr recip_own_if_other other",by(ID) label saving(recipr_aux,replace)
clear

* Keep only estimate for other contribution
use recipr_aux.dta
keep if parmseq==1
save recipr_aux.dta, replace

* Do the merging 
use main_fr.dta 
sort ID
merge ID using recipr_aux
su _merge
drop parmseq parm label stderr dof t p min95 max95 _merge

* Transform regression estimate for strategy method:
* deviations from 1 mean less reciprocity
* compute -abs|1-beta|
gen recip_s_method=.

order ID estimate recip_s_method recip_own_if_other0 - recip_own_if_other100 r0 r25 r50 r75 r100
replace recip_s_method=estimate
*replace recip_s_method=(-1)*(abs(estimate-1))
label var recip_s_method "Reciprocity measure: Strategy method"

su recip_s_method, det

gen recip_s_high_group=(recip_s_method>=r(p50) & recip_s_method<.)
label var recip_s_high_group "Reciprocity: high (S method)
label values recip_s_high_group hilo
  	
tab recip_s_high_group

recode 		q8_2 (1=4) (2=3) (3=2) (4=1) (nonmiss=.), gen(partyid_strength)
label var 	partyid_strength "Strength of party identification"
label 		define close 1 "Not at all close" 2 "Not very close" 3 "Somewhat close" 4 "Very close"
label 		values partyid_strength close

rename 		q8_3 ideology
replace		ideology=. if ideology>10
label var 	ideology "L-R ideology (0-10)"
su 			ideology, det

gen			right=.
replace		right=0 if ideology<=r(p50)
replace 	right=1 if ideology>r(p50) & ideology<.
label var	right "Ideology: Right vs. left"

* Knowledge
* Correct: Jean-Yves Le Drian
recode 		q9bx (1=1) (nonmiss=0), gen(gknow1)
label var 	gknow1 "General knowledge: Minister of Defence"

* Correct: Parti socialiste (295 seats) in June 2012 election
recode 		q9_2 (3=1) (nonmiss=0), gen(gknow2)
label var 	gknow2 "General knowledge: Majority party in House"

* Term length in AN: 5 years
recode 		q9_3 (5=1) (nonmiss=0), gen(gknow3)
label var 	gknow3 "General knowledge: Term length National Assembly"

* Attention check: correct are red and green (2 and 3)
* 1=pink
* 2=red
* 3=green
* 4=white
* 5=black
* 6=blue

rename attentioncheck_pass attentioncheck_pass_yougov
gen attentioncheck_pass=0

label define passfail 0 Fail 1 Pass
label values attentioncheck_pass passfail

label define passfailyougov 2 Fail 1 Pass
label values attentioncheck_pass_yougov passfailyougov

* Create own attention indicator
replace attentioncheck_pass=1 if attentioncheck_2==1 & attentioncheck_3==1
tab attentioncheck_pass attentioncheck_pass_yougov

* Correct indicator for those respondents that clicked more than the two correct colors
gen attentioncheck_more=0
label var attentioncheck_more "Ticked more than two colors"

foreach num of num 1 4 5 6 {
replace attentioncheck_pass=0 if attentioncheck_`num'==1
replace attentioncheck_more=1 if attentioncheck_`num'==1 & attentioncheck_pass==1
}

foreach num of num 1 4 5 6 {
replace attentioncheck_more=1 if attentioncheck_pass_yougov==1 & attentioncheck_`num'==1
}

tab attentioncheck_pass attentioncheck_pass_yougov, row col
tab attentioncheck_more


* Employment
recode q10_1 (7=10) (8=10) (9=.) (10=10) (98=.) (99=.), gen(employment)
label var 	employment "Employment status"
label define empl 1 "Paid work" 2 "In education" 3 "Unemployed (looking)" 4 "Unemployed" 5 "Sick/disabled" 6 "Retired" 7 "Community service" 10 "Other" 11 "Military service"
label values employment empl

gen	emplgr_pwork	=	(employment>=1 & employment<=1)
gen	emplgr_educ		=	(employment>=2 & employment<=2)
gen	emplgr_unemp	=	(employment>=3 & employment<=4)
gen	emplgr_retired	=	(employment>=6 & employment<=6)
*gen	emplgr_hwork	=	(employment>=8 & employment>=8)

* Car ownership

recode q10_3 (1=1) (2=0) (nonmiss=.), gen(owncar)
label var owncar "Car ownership"
tab owncar

* Age
gen			age=2012-birthyr
label var	age "Age"
sort age
order age

gen 	below18=0
replace	below18=1 if age<18

gen 	below14=0
replace	below14=1 if age<14

gen  agegr18_29 = (age>17 & age<30)
gen  agegr30_39 = (age>29 & age<40)
gen  agegr40_49 = (age>39 & age<50)
gen  agegr50_59 = (age>49 & age<60)
gen  agegr60_69 = (age>59 & age<70)
gen  agegr70_o 	= (age>69 & age!=.)

gen age_groups=.
replace age_groups=1 if agegr18_29==1
replace age_groups=2 if agegr30_39==1
replace age_groups=3 if agegr40_49==1
replace age_groups=4 if agegr50_59==1
replace age_groups=5 if agegr60_69==1
replace age_groups=6 if agegr70_o==1

label define age_groups 1 "18-29" 2 "30-39" 3 "40-49" 4 "50-59" 5 "60-69" 6 "Over 70"
label values age_groups age_groups

tab age_groups

gen  agegr18_39 = (age>17 & age<40)
gen  agegr40_59 = (age>39 & age<60)
gen  agegr60_o = (age>59 & age!=.)

* Recode age for comparison of margins in sample and voter population
gen agegrd_fr=.
replace agegrd_fr=1 if age>=18 & age<=39
replace agegrd_fr=2 if age>=40 & age<55
replace agegrd_fr=3 if age>=55

label define agegrd_fr 1 "18-39" 2 "40-54" 3 "55+"
label values agegrd_fr agegrd_fr

* Female
recode 			gender (1=0) (2=1) (nonmiss=.), gen(female)
label var		female "Female"
label define 	female 1 Female 0 Male
label values 	female female
tab female

* Education
gen educ_high=(educ>2 & educ<.)
label define educ_high 0 "Education: Low" 1 "Education: High"
label values educ_high educ_high
tab educ_high

tab educ
tab educ, nolab
gen educgrd_fr=.
replace educgrd_fr =1 if educ<=2
replace educgrd_fr =2 if educ>2 & educ<=5
replace educgrd_fr =3 if educ>=6 & educ<=8

label define educgrd 1 "Education: CAP/BEP or less" 2 "Education: Bac to Bac+2" 3 "Bac+3 or more" 
label values educgrd_fr educgrd
tab educgrd

* Income
gen income=faminc
replace income=. if faminc>=97
quietly su income, det

gen  incgr_low 			= (income>0 & income<r(p25))
gen  incgr_lowermiddle 	= (income>=r(p25) & income<r(p50))
gen  incgr_uppermiddle 	= (income>=r(p50) & income<r(p75))
gen  incgr_high 		= (income>=r(p75) & income<=.)

gen inc_high_group=(income>=r(p50) & income<.)

cd "$path/"
label data "French data from survey conducted by YouGov for Bechtel/Scheve"
save main_fr.dta, replace

*** END FRANCE ***



*** 4. START GERMANY ***
use "$path/raw_ge.dta"

* Prepare vars

* Destring weight
destring weight, replace dpcomma

* Altruism and reciprocity measures
recode	q2_1 (1=1) (nonmiss=0), gen(altru_donate)
label var altru_donate "Wants to donate"

rename	q2_1a altru_charity
replace	altru_charity=. if altru_charity>=98
tab altru_charity
rename q2_1a_t altru_charity_other //Choice: other

rename	q2_1b_rule altru_howmuch
replace	altru_howmuch=. if altru_howmuch>100
replace altru_howmuch=0 if altru_donate==0
label var altru_howmuch "Donation ($)"

gen altru_high_group= (altru_howmuch>=50 & altru_howmuch<.)
label define hilo 0 "low" 1 "high"
label values altru_high_group hilo
tab altru_high_group

rename q2_amount1 recip_ex_own_contrib
rename q2_amount2 recip_ex_payoff_to_w2
rename q2_amount3 recip_ex_other_contrib
rename q2_amount4 recip_ex_payoff_own

rename q2_2a_rule recip_expect_contrib
label var recip_expect_contrib "Expected contribution ($)"
replace recip_expect_contrib=. if recip_expect_contrib>100

rename q2_2b_rule recip_own_contrib
label var recip_own_contrib "Own contribution ($)"
replace recip_own_contrib =. if recip_own_contrib>100

rename q2_2c_0_rule recip_own_if_other0
replace recip_own_if_other0 =. if recip_own_if_other0>100

rename q2_2c_25_rule recip_own_if_other25
replace recip_own_if_other25 =. if recip_own_if_other25>100

rename q2_2c_50_rule recip_own_if_other50
replace recip_own_if_other50 =. if recip_own_if_other50>100

rename q2_2c_75_rule recip_own_if_other75
replace recip_own_if_other75 =. if recip_own_if_other75>100

rename q2_2c_100_rule recip_own_if_other100
replace recip_own_if_other100 =. if recip_own_if_other100>100

gen r0=0
gen r25=25
gen r50=50
gen r75=75
gen r100=100

* Generate reciprocity measures

gen		 	recip_sd_method=-abs(recip_own_contrib-recip_expect_contrib)
label var 	recip_sd_method "Reciprocity measure: Specific decision (-1)*|Own-Expected|"
*hist 		recip_sd_method, percent
su recip_sd_method, det
gen recip_sd_high_group=(recip_sd_method>=r(p50) & recip_sd_method<.)
label var recip_sd_high_group "Reciprocity: high (SD method)"
label values recip_sd_high_group hilo

gen		 	recip_sd_method2=recip_expect_contrib
replace 	recip_sd_method2=0.01 if recip_expect_contrib==0
replace 	recip_sd_method2=recip_own_contrib/recip_sd_method2
label var 	recip_sd_method2 "Reciprocity measure: Specific decision (own/expected)"

* save data here already
cd "$path/"
save main_ge.dta, replace

* Generate second reciprocity measure from strategy method
* Using a regression on the long format of the data
keep ID recip_own_if_other0 recip_own_if_other25 recip_own_if_other50 recip_own_if_other75 recip_own_if_other100

reshape long recip_own_if_other, i(ID) j(other)
*twoway (scatter recip_own_if_other other)
*regress recip_own_if_other other

* Prepare loop over respondents for rolling regression
*egen 	aux=group(ID)
*su aux
*local max=r(max)

* Reciprocity measures: compute and correlate
* use the parmest package
* Already there: recip_sd_method
set more off
parmby "quietly regr recip_own_if_other other",by(ID) label saving(recipr_aux,replace)
clear

* Keep only estimate for other contribution
use recipr_aux.dta
keep if parmseq==1
save recipr_aux.dta, replace

* Do the merging 
use main_ge.dta 
sort ID
merge ID using recipr_aux
su _merge
drop parmseq parm label stderr dof t p min95 max95 _merge

* Transform regression estimate for strategy method:
* deviations from 1 mean less reciprocity
* compute -abs|1-beta|
gen recip_s_method=.

order ID estimate recip_s_method recip_own_if_other0 - recip_own_if_other100 r0 r25 r50 r75 r100
replace recip_s_method=estimate
*replace recip_s_method=(-1)*(abs(estimate-1))
label var recip_s_method "Reciprocity measure: Strategy method"

su recip_s_method, det

gen recip_s_high_group=(recip_s_method>=r(p50) & recip_s_method<.)
label var recip_s_high_group "Reciprocity: high (S method)
label values recip_s_high_group hilo
  	
tab recip_s_high_group
*tab recip_s_high_group recip_sd_high_group 

* Party identification
recode q8_1a (1=1) (2=0) (nonmiss=.), gen(partyid_yesno)
label var partyid "Party identification (Yes)"

recode 		q8_1b (1=1) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=9) (10=8) (nonmiss=.), gen(partyid)
label var 	partyid "Party identification"
label 		define partyid 1 "CDU/CSU" 2 "SPD" 3 "FDP" 4 "Greens" 5 "Die Linke" 6 "Republikaner" 7 "Piratenpartei" 8 "NPD" 9 "Andere"
label 		values partyid partyid

gen cdu=.
replace cdu=0 if partyid==2
replace cdu=1 if partyid==1
label var cdu "Identify with CDU/CSU (vs SPD)"
label define cdu 0 "SPD" 1 "CDU"
label values cdu cdu

recode 		q8_2 (1=4) (2=3) (3=2) (4=1) (nonmiss=.), gen(partyid_strength)
label var 	partyid_strength "Strength of party identification"
label 		define close 1 "Not at all close" 2 "Not very close" 3 "Somewhat close" 4 "Very close"
label 		values partyid_strength close

rename 		q8_3 ideology
replace		ideology=. if ideology>10
label var 	ideology "L-R ideology (0-10)"
su 			ideology, det

gen			right=.
replace		right=0 if ideology<=r(p50)
replace 	right=1 if ideology>r(p50) & ideology<.
label var	right "Ideology: Right vs. left"

* Knowledge
* Correct: Thomas de Maizire (Minister of Defence)
recode 		q9bx (1=1) (nonmiss=0), gen(gknow1)
label var 	gknow1 "General knowledge: Minister of Defence"

* Correct: CDU (237 seats) in 2009 election
recode 		q9_2 (1=1) (nonmiss=0), gen(gknow2)
label var 	gknow2 "General knowledge: Majority party in Parliament"

* Term length German MP: 4 years
recode 		q9_3 (4=1) (nonmiss=0), gen(gknow3)
label var 	gknow3 "General knowledge: Term length German MP"

* Attention check
recode	attentioncheck_pass (2=0) (1=1) 
tab		attentioncheck_pass

* Employment
recode q10_1 (1=1) (2=1) (3=2) (4=3) (5=4) (6=10) (7=4) (8=1) (9=6) (10=10) (11=7) (12=2) (13=2) (14=5) (nonmiss=.), gen(employment)
label var 	employment "Employment status"
label define empl 1 "Paid work" 2 "In education" 3 "Unemployed (looking)" 4 "Unemployed" 5 "Sick/disabled" 6 "Retired" 7 "Community service" 10 "Other" 11 "Military service"
label values employment empl

gen	emplgr_pwork	=	(employment>=1 & employment<=1)
gen	emplgr_educ		=	(employment>=2 & employment<=2)
gen	emplgr_unemp	=	(employment>=3 & employment<=4)
gen	emplgr_retired	=	(employment>=6 & employment<=6)
gen	emplgr_hwork	=	(employment>=8 & employment>=8)

* Car ownership
recode q10_3 (1=1) (2=0) (nonmiss=.), gen(owncar)
label var owncar "Car ownership"
tab owncar


gen educ_high=0
replace educ_high=1 if educ>=5 & educ<=7
label define educ_high 0 "Education: Low" 1 "Education: High"
label values educ_high educ_high
tab educ_high

tab educ

* Age
gen			age=2012-birthyr
label var	age "Age"
sort age
order age

gen  agegr18_29 = (age>17 & age<30)
gen  agegr30_39 = (age>29 & age<40)
gen  agegr40_49 = (age>39 & age<50)
gen  agegr50_59 = (age>49 & age<60)
gen  agegr60_69 = (age>59 & age<70)
gen  agegr70_o 	= (age>69 & age!=.)
gen  agegr60p   = (age>=60 & age!=.)

gen  agegr18_39 = (age>17 & age<40)
gen  agegr40_59 = (age>39 & age<60)
gen  agegr60_o = (age>59 & age!=.)

* Recode age for comparison of margins in sample and voter population
gen agegrd_ge=.
replace agegrd_ge=1 if age>=18 & age<=34
replace agegrd_ge=2 if age>=35 & age<55
replace agegrd_ge=3 if age>=55

label define agegrd_ge 1 "18-34" 2 "35-54" 3 "55+"
label values agegrd_ge agegrd_ge
tab agegrd_ge

* Female
recode 			gender (1=0) (2=1) (nonmiss=.), gen(female)
label var		female "Female"
label define 	female 1 Female 0 Male
label values 	female female
tab female

* Education
tab educ
* Consolidate education categories (see codebook for details)
recode educ (1 2 3 8=1) (3/6=2) (7=3), gen(educgr_ge)

label define Educ 1 "Education: 16 yrs or fewer" 2 "Education: 17 to 19 yrs" 3 "Education: 20 yrs or more" 
label values educgr_ge Educ
tab educgr_ge
tab educgr_ge, nolab

* Income
gen income=faminc
replace income=. if faminc>=97
su income, det

gen  incgr_low 			= (income>0 & income<r(p25))
gen  incgr_lowermiddle 	= (income>=r(p25) & income<r(p50))
gen  incgr_uppermiddle 	= (income>=r(p50) & income<r(p75))
gen  incgr_high 		= (income>=r(p75) & income<=.)

gen inc_high_group=(income>=r(p50) & income<.)

drop	q3_1 q3_2 

cd "$path/"

label data "German data; Bechtel/Scheve"
save main_ge.dta, replace
clear
**** END GERMANY***
exit

