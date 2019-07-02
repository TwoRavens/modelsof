********* FINAL CODE ***********
use immigration_data.dta, clear
ttest threatened2 if dscore2!=.&race!=4&zipcode!=., by(techworker4) unequal

ttest indian_traits if dscore!=.&race!=4&(group_placz2==3|group_placz2==2)&zipcode!=., by(group_placz2) unequal

g college = education>3 if education!=.
ttest education if dscore!=.&race!=4&(group_placz2==3|group_placz2==2)&zipcode!=., by(group_placz2) unequal
ttest college if dscore!=.&race!=4&(group_placz2==3|group_placz2==2)&zipcode!=., by(group_placz2) unequal
ttest income2 if dscore!=.&race!=4&(group_placz2==3|group_placz2==2)&zipcode!=., by(group_placz2) unequal

ttest h1bvisas_scale if dscore!=.&race!=4&(group_placz2==3|group_placz2==1)&zipcode!=., by(group_placz2) unequal
ttest indianimmig_scale if dscore!=.&race!=4&(group_placz2==3|group_placz2==1)&zipcode!=., by(group_placz2) unequal
xi: reg h1bvisas_scale i.group3 dscore2   female age agesq married educ racewhite income2 pid  techzip2 if dscore!=.&race!=4&zipcode!=., cluster(zipcode)
reg h1bvisas_scale _Igroup3_* dscore2   female age agesq married educ racewhite income2 pid  techzip2 if dscore!=.&race!=4&zipcode!=., cluster(zipcode)
tab education, gen(ed_indicator)
reg h1bvisas_scale groupcat2 groupcat1 dscore2   female age agesq married ed_indicator2 ed_indicator3 ed_indicator4 ed_indicator5 ed_indicator6 racewhite income2 pid  techzip2 if dscore!=.&race!=4&zipcode!=., cluster(zipcode)
g dv1=h1bvisas_scale
g dv2=indianimmig_scale
gen id = caseid
order id
reshape long dv, i(id)
order id _j
g d=_j-1
g w_2 = groupcat2*d
g w_1 = groupcat1*d

reg dv groupcat2 groupcat1 w_2 w_1 d if dscore!=.&race!=4&zipcode!=., cluster(id)

test _b[d]=0, notest
test _b[w_2] = 0, accum










svy: tab female 

tab married 
svy: tab married 

tab hs_grad
svy: tab hs_grad

tab p_white
svy: tab p_white

tab agecat
svy: tab agecat




******REGRESSIONS (DROP POST-TREATMENT MEASURES)******
svyset [pweight = weightvec]

* Column 6 drawn from Census documents for 2010 (www.census.gov)
* Census Data for FIPS in Study Sample
use census.dta, clear

use globalization_exp.dta

******DEFINING VARIABLES******
g white = 1 if q4 == 1
recode white (.=0) if q4 !=.
g male = q1-1
g age = 2009-(1900+q2)
g age2 = (age-18)/(109-18)
g educ = (q5-1)/5
g partyid = 1 if q7 == 1 & q7a == 1
replace partyid = 2 if q7 == 1 & q7a == 2
replace partyid = 2 if q7 == 1 & q7a == 99999999
replace partyid = 3 if q7 == 3 & q7b == 1
replace partyid = 3 if q7 == 4 & q7b == 1
replace partyid = 4 if q7 == 3 & q7b == 99999999
replace partyid = 4 if q7 == 4 & q7b == 99999999
replace partyid = 4 if q7 == 99999999
replace partyid = 5 if q7 == 4 & q7b == 2
replace partyid = 5 if q7 == 3 & q7b == 2
replace partyid = 6 if q7 == 2 & q7a == 99999999
replace partyid = 6 if q7 == 2 & q7a == 2
replace partyid = 7 if q7 == 2 & q7a == 1
g partyidb = (7-partyid)/6

g category = .
recode category (.=1) if canadian == 1
recode category (.=2) if russian == 1
recode category (.=3) if indian == 1

tab category if m1t4q1==.&m1t5q1==.&m1t6q1==.&culthreaty!=.

sort category