* Cecilia Mo
* March 13, 2017
* Replication File for Political Behavior
* Final Data File: Nepal_PB_RR.dta

*******************************************************************************************************************
**** OPEN DATA
*******************************************************************************************************************

set more off
use Nepal_PB_RR.dta, clear


*******************************************************************************************************************
**** CLEANING
*******************************************************************************************************************

**** Generating unique id
egen id = concat (q10_lognumber q11 q15_interviewercode)
label var id "Unique ID"
label var q10_lognumber "Survey Log Number"
label var q11 "Municipality Code"
label var q15_interviewercode "Interviewer ID"
order id q10_lognumber q11 q15_interviewercode
rename q10_lognumber lognumber
rename q11 municipalitycode
rename q15_interviewercode interviewercode

**** Generating treatment variable
g primepoor = 0
replace primepoor = 1 if q1 == 16 | q1 == 15 | q1 == 11 | q1 == 12 | q1 == 7 | q1 == 8 | q1 == 3 | q1 == 4
label define primepoor 0 "Control" 1 "Treated"
label value primepoor primepoor
move primepoor q7
label var primepoor "Prime (Treatment = 1)"
tab primepoor

label define q115a 0 "More than 4000" 1 "Between 2000-4000" 2 "Between 1000-2000" 3 "Between 500-1000" 4 "Less than 400"
label define q115b 0 "More than 200,000" 1 "Between 100,000-200,000" 2 "Between 50,000-100,000" 3 "Between 25,000-50,000" 4 "Less than 25,000"
label value q115a q115a
label value q115b q115b
move q115a q7
move q115b q7
rename q115a income_control
rename q115b income_poorprime
label var income_control "Income Question in Control Condition"
label var income_poorprime "Income Question in Treatment Condition"

label var q1 "Survey Version"
rename q1 surveyversion

**** Generating outcome variables
* Lottery
g lottery = .
replace lottery = q116 if q116 <= 5
label var lottery "Number of Lottery Tickets Purchased (Max = 5)"
move lottery q7
drop q116

g tickets = 0 if lottery != .
replace tickets = 1 if lottery >=2 
label var tickets "Purchased >=1 Lottery Ticket"
move tickets q7

* Risky job for child
g child_risk = q118 if q118 <= 1
label define q118 0 "1250 Low Risk" 1 "6000 High Risk"
label value q118 q118
label value child_risk q118
label var child_risk "Chose Risky Option for Child"
drop q118
move child_risk q7

* Risky job for oneself
g job_risk = q117 if q117 <= 1
label define q117 0 "1250 Low Risk" 1 "6000 High Risk"
label value q117 q117
label value job_risk q117
label var job_risk "Chose Risky Option"
drop q117
move job_risk q7

**** Generating village code to cluster standard errors at village-level by considering municipality and district code
gen bara = 0
replace bara = 1 if interviewercode <= 1005
label var bara "Bara District"
label define bara 0 "Makwanpur" 1 "Bara"
label val bara bara
move bara municipalitycode

egen village_combineward = concat(municipalitycode bara)
egen villagecode = group(village_combineward)
move villagecode interviewercode
label var villagecode "Unique Village Code"
drop village_combineward

**** Generating lottery experience variables
g lottery_exp = q116_2/3
replace lottery_exp = . if q116_2 == 888
g lottery_exp2 = q116_2
replace lottery_exp2 = . if q116_2 == 888
label var lottery_exp "Lottery Experience (Recoded to 0-1)"
label var lottery_exp2 "Lottery Experience"
label define lottery_exp2 0 "No" 1 "Yes, Once" 2 "2-3 Times" 3 "More than 3 Times"
label val lottery_exp2 lottery_exp2
drop q116_2
move lottery_exp2 child_risk
move lottery_exp child_risk

**** Generating manipulation check measure
g q107_v2 = q107/5
g prime_q1072 = q107_v2*primepoor
label var q107 "Relative Poverty"
label var q107_v2 "Lottery Experience (Recoded to 0-1)"
label define q107 0 "Very Poor" 1 "Moderately Poor" 2 "Slightly Poor" 3 "Neither Poor Nor Rich" 4 "Slightly Rich" 5 "Moderately Rich" 6 "Very Rich"
label val q107 q107
rename q107 relativepoverty
rename q107_v2 relativepoverty_recoded
rename prime_q1072 prime_relativepoverty
label var prime_relativepoverty "Prime X Relative Poverty"
move relativepoverty q7
move relativepoverty_recoded q7
move prime_relativepoverty q7

**** Generating demographic controls
* Exposure to migrants
g away2 = (q63/3)
rename q63 away
label define away 0 "No One" 1 "1-5" 2 "6-10" 3 "11+"
label var away2 "Exposure to Migrants (Recoded to 0-1)"
label var away "Exposure to Migrants"
move away q7
move away2 q7

* Female
g gender = q73 if q73 <= 1
label var gender "Gender (Female = 1)"
label define gender 0 "Male" 1 "Female"
label val gender gender
drop q73
move gender q7

* Intl news consumption
g news = q20 if q20 <= 1
label var news "Watch/Listen to Intl News (Yes = 1)"
label define news 0 "No" 1 "Yes"
label val news news
drop q20
move news q7

* Number of Children
rename q7 son
label var son "Number of Sons"
g daughter = q8 if q8 != 888
label var daughter "Number of Daughters"
move daughter q8
drop q8
g children = son + daughter
label var children "Total Number of Children"
g children2 = (children - 1)/11
label var children2 "Total Number of Children (Recoded to 0-1)"
move children q58
move children2 q58

* Age
g age = q74 if q74 != 888
drop q74
label var age "Age"
g age_v2 = age/84
label var age_v2 "Age (Recoded to 0-1)"
g age_v2sq = age_v2 * age_v2
label var age_v2sq "Age^2 (Recoded to 0-1)"
move age q58
move age_v2 q58
move age_v2sq q58

* Education
g educ = q78 if q78 <=15
replace educ = 0 if q78 == 16
replace educ = . if q78 > 16
drop q78
g educ2 = educ/15
label var educ "Education Level"
label var educ2 "Education Level (Recoded to 0-1)"
label define educ 0 "Pre-K/Kindergarten" 1 "Class 1" 2 "Class 2" 3 "Class 3" 4 "Class 4" 5 "Class 5" 6 "Class 6" 7 "Class 7" 8 "Class 8" 9 "Class 9" 10 "Class 10" 11 "SLC" 12 "Class 12/Intermediate"13 "Bachelors" 14 "Masters" 15 "Professional Degree"
label val educ educ
move educ q58
move educ2 q58

* Marital Status
g married = .
replace married = 1 if q75 == 1
replace married = 0 if q75 >= 2 & q75 <= 4
label define married 0 "No" 1 "Yes"
label val married married
label var married "Marital Status (Married = 1)"
rename q75 maritalstatus
label var maritalstatus "Marital Status"
label define married2 1 "Married" 2 "Divorced/Separated" 3 "Widowed" 4 "Never Married"
label val maritalstatus married2
move married q58
move maritalstatus q58

* Landownder
g ownland = .
replace ownland = 0 if q100 <= 3
replace ownland = 1 if q100 == 4
label define ownland 0 "No" 1 "Yes"
label val ownland ownland
label var ownland "Own Land (Yes = 1)"
rename q100 landright
label var landright "Land Rights"
label define landright 0 "No Land" 1 "Free/Govt Land" 2 "Share Crop" 3 "Rent Land" 4 "Own Land"
label val landright landright
move ownland q58
move landright q58

* Caste
g tamang = 0
replace tamang = 1 if q58 == 5
replace tamang = . if q58 == 0
label define tamang 0 "No" 1 "Yes"
label val tamang tamang
label var tamang "Tamang Caste (Yes = 1)"
move tamang q58
rename q58 castecode
label var castecode "Caste/Ethnicity"
recode castecode (0 = .)
label define ethnicity 1 "Chetthri" 2 "Brahman" 3 "Magar" 4 "Tharu" 5 "Tamang" 6 "Newar" 7 "Muslim" 8 "Kami" 9 "Yadav" 10 "Rai" 11 "Gurung" 12 "Damain/Dholi" 13 "Limbu" 14 "Thakuri" 16 "Teli" 18 "Koiri" 22 "Musahar" 23 "Dusadh/Paswan/Pasi" 29 "Gharti/Bhujel" 30 "Mahl" 31 "Kalwar" 33 "Hajam/Thakur" 34 "Kanu" 42 "Majhi" 46 "Chepang/Praja" 49 "Kayastha" 51 "Marwadi" 54 "Bantar" 63 "Bing/Binda" 102 "Other Caste"
label val castecode ethnicity

* Religion
g hindu = 0
replace hindu = 1 if q59 == 1
g buddhist = 0
replace buddhist = 1 if q59 == 2
label define yes 0 "No" 1 "Yes"
label val hindu yes
label val buddhist yes
label var hindu "Hindu (Yes = 1)"
label var buddhist "Buddhist (Yes = 1)"
rename q59 religion
label define religion 1 "Hindu" 2 "Buddhist" 3 "Islam" 4 "Kirant" 6 "Christian" 7 "Shikh" 9 "Other Religion"
label val religion religion
label var religion "Religious Identification"


*******************************************************************************************************************
**** REPLICATION CODE FOR STUDY 1 RESULTS
*******************************************************************************************************************

/***** Stats in Text *****/
su primepoor
tab income_control if income_control < 88
tab income_poorprime if income_poorprime < 88
tab lottery
tab lottery_exp2 
di 100-72.74


/***** Summary Statistic (Table B.1) *****/
su job_risk child_risk tickets lottery_exp2 away relativepoverty news children gender age educ married ownland tamang hindu buddhist  


/***** Balance Tests (Table B.2) *****/
orth_out lottery_exp2 away relativepoverty news children gender age educ married ownland tamang hindu buddhist  , by(primepoor) compare test


/***** Main Effects *****/
* Figure 2
* Use values in following analyses for Replication_Figure2.R to generate Figure 2
set more off
ttest job_risk, by(primepoor) 
ttest child_risk, by(primepoor) 
ttest tickets, by(primepoor) 

* LPM Model: Table 1
set more off
xi: eststo: reg job_risk primepoor  , cluster(villagecode)
xi: eststo: reg job_risk primepoor away2 news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
xi: eststo: reg child_risk primepoor  , cluster(villagecode)
xi: eststo: reg child_risk primepoor away2 news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
xi: eststo: reg tickets primepoor  , cluster(villagecode)
xi: eststo: reg tickets primepoor lottery_exp news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
esttab using table1.tex, se(2) pr2 b(2) coeflabels(primepoor "Relative Poverty Prime" news "Consume Foreign News" children2 "Number of Children" gender "Gender" age_v2 "Age" age_v2sq "Age$^{2}$" educ2 "Education" married "Married" ownland "Own Land" _cons "Constant") title("Dependent Variable: Vote for Female Candidate") alignment(cr) nomtitles star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear

* Logistic Model: Table B.3; Footnote 25
set more off
xi: eststo: logit job_risk primepoor  , cluster(villagecode)
xi: eststo: logit job_risk primepoor away2 news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
mfx 
xi: eststo: logit child_risk primepoor  , cluster(villagecode)
xi: eststo: logit child_risk primepoor away2 news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
mfx
xi: eststo: logit tickets primepoor  , cluster(villagecode)
xi: eststo: logit tickets primepoor lottery_exp news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
mfx
esttab using tableb3.tex, se(2) pr2 b(2) coeflabels(primepoor "Relative Poverty Prime" news "Consume Foreign News" children2 "Number of Children" gender "Gender" age_v2 "Age" age_v2sq "Age$^{2}$" educ2 "Education" married "Married" ownland "Own Land" _cons "Constant") title("Dependent Variable: Vote for Female Candidate") alignment(cr) nomtitles star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear


/***** Manipulation Check *****/
* LPM Model: Table 2
set more off
xi: eststo: reg job_risk primepoor relativepoverty_recoded prime_relativepoverty away2 news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
xi: eststo: reg child_risk primepoor relativepoverty_recoded prime_relativepoverty away2 news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
xi: eststo: reg tickets primepoor relativepoverty_recoded prime_relativepoverty lottery_exp news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
esttab using table2.tex, se(2) pr2 b(2) coeflabels(primepoor "Relative Deprivation Prime" q107_v2 "Perceived Relative Wealth Pre-Prime" prime_q1072 "Prime x Perceived Relative Wealth Pre-Prime" news "Consume Foreign News" children2 "Number of Children" gender "Gender" age_v2 "Age" age_v2sq "Age$^{2}$" educ2 "Education" married "Married" ownland "Own Land" tamang "Tamang" hindu "Hindu" buddhist "Buddhist" _cons "Constant") title("Dependent Variable: Risk Behavior") alignment(cr) nomtitles star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear

* Logistic Model: Table B.4
set more off
xi: eststo: logit job_risk primepoor relativepoverty_recoded prime_relativepoverty away2 news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
xi: eststo: logit child_risk primepoor relativepoverty_recoded prime_relativepoverty away2 news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
xi: eststo: logit tickets primepoor relativepoverty_recoded prime_relativepoverty lottery_exp news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
esttab using tableb4.tex, se(2) pr2 b(2) coeflabels(primepoor "Relative Deprivation Prime" q107_v2 "Perceived Relative Wealth Pre-Prime" prime_q1072 "Prime x Perceived Relative Wealth Pre-Prime" news "Consume Foreign News" children2 "Number of Children" gender "Gender" age_v2 "Age" age_v2sq "Age$^{2}$" educ2 "Education" married "Married" ownland "Own Land" tamang "Tamang" hindu "Hindu" buddhist "Buddhist" _cons "Constant") title("Dependent Variable: Risk Behavior") alignment(cr) nomtitles star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear

* Figure 3
set more off
xi: reg job_risk primepoor relativepoverty_recoded prime_relativepoverty away2 news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
predict phatv2 if primepoor == 0
predict phatv3 if primepoor == 1
graph twoway (lfitci phatv2 relativepoverty_recoded) (lfitci phatv3 relativepoverty_recoded), ylabel(,labsize(vsmall)) xlab(, labsize(vsmall)) ytitle("Probability of Selecting High Risk Labor Option", size(small)) xtitle("Perceived Relative Wealth, Pre-Prime", size(small)) legend(col(1) order(1 2 3) label(1 "95% Confidence Interval") label(2 "Control") label(3 "Treatment") size(vsmall)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white)) 

set more off
drop phatv2 phatv3
xi: reg child_risk primepoor relativepoverty_recoded prime_relativepoverty away2 news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
predict phatv2 if primepoor == 0
predict phatv3 if primepoor == 1
graph twoway (lfitci phatv2 relativepoverty_recoded) (lfitci phatv3 relativepoverty_recoded), ylabel(,labsize(vsmall)) xlab(, labsize(vsmall)) ytitle("Probability of Selecting High Risk Child Labor Option", size(small)) xtitle("Perceived Relative Wealth, Pre-Prime", size(small)) legend(col(1) order(1 2 3) label(1 "95% Confidence Interval") label(2 "Control") label(3 "Treatment") size(vsmall)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white)) 

set more off
drop phatv2 phatv3
xi: reg tickets primepoor relativepoverty_recoded prime_relativepoverty lottery_exp news children2 gender age_v2 age_v2sq educ2 married ownland tamang hindu buddhist  , cluster(villagecode)
predict phatv2 if primepoor == 0
predict phatv3 if primepoor == 1
graph twoway (lfitci phatv2 relativepoverty_recoded) (lfitci phatv3 relativepoverty_recoded), ylabel(,labsize(vsmall)) xlab(, labsize(vsmall)) ytitle("Probability of Gambling", size(small)) xtitle("Perceived Relative Wealth, Pre-Prime", size(small)) legend(col(1) order(1 2 3) label(1 "95% Confidence Interval") label(2 "Control") label(3 "Treatment") size(vsmall)) xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white)) 

