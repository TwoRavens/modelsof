* This do-file re-produces the results in Tables 2-6

use allmodes, clear

* Trim the weighting for all surveys at 7
replace weight=7 if weight>7

* Clean up coding of knowledge variable
replace know4_n=know4 if mode==2 
replace know4_n=know4_n*100 if know4_n<1 & mode~=1

* Generate variable for whether R's guess on unemployment is within 1 point of actual rate
gen unemploy_correct=1 if know4_n>=8.7 & know4_n<=10.7
replace unemploy_correct=0 if know4_n<8.7 | (know4_n>10.7 & know4_n~=.)

* Make smokenow "Not at all" if R has not smoked during lifetime
replace smokenow=3 if smoke100==2

* Gen variable for whether House control question is correct

recode know2 2/4=0, gen(house_correct)

* Create one variable for R's state of residence
gen state=askstate
replace state=inputstate if state==.

* Merge in dataset indicating the party of the governor in R's state
sort state
merge state using govpartydata
drop _m

* Create variable indicating whether R knew the party of his/her governor
gen govparty_correct=1 if know1==1 & partyofgov==1
replace govparty_correct=1 if know1==2 & partyofgov==0
replace govparty_correct=1 if know1==3 & state==12
replace govparty_correct=0 if govparty_correct==.
replace govparty_correct=. if know1==.

* Generate a variable counting the number of correct answers to three knowledge questions
gen knowledge=unemploy_correct+house_correct+govparty_correct

* Generate indicators for whether R lived at address less than one year and more than five years
recode address 1/3=1 4/7=0, gen(lessthanyear)
recode address 1/5=0 6/7=1, gen(fiveormore)

* Generate indicator for whether R is smoker
recode smokenow 1/2=1 3=0 9=., gen(smokeeverysome)

* Generate indicator for whether R does not have insurance (variable names slightly different for different modes)
gen notinsured=1 if health_insure_1==1
replace notinsured=0 if health_insure_1==2
replace notinsured=. if health_insure_6==1
replace notinsured=1 if health_insure==2
replace notinsured=0 if health_insure==1

* Set data for weighted analyses (pweights)
svyset [pw=weight]

* Open log to record results
log using modestudy.log, replace

* Weighted Point Estimates for Validated Measures (Table 2)

svy: proportion acsownrent, over(mode)
svy: proportion lessthanyear, over(mode)
svy: proportion fiveormore, over(mode)
svy: proportion smoke100, over(mode)
svy: proportion smokeeverysome, over(mode)
svy: proportion notinsured, over(mode)
svy: proportion turnout08 if votereg==1, over(mode)
svy: proportion voted08 if voted08<4 & votereg==1, over(mode)
svy: proportion votepres08 if votepres08<8 & votereg==1, over(mode)

* Weighted Point Estimates for Unvalidated Measures (Table 3)

svy: proportion obamaapp if obamaapp<5, over(mode)
svy: proportion congapp if congapp<5, over(mode)
svy: proportion track if track<3, over(mode)
svy: proportion affact, over(mode)
svy: proportion abortlegal, over(mode)
svy: proportion gaymarriage if gaymarriage<3, over(mode)
svy: proportion socsecstock if socsecstock<3, over(mode)
svy: proportion taxrich if taxrich<3, over(mode)
svy: proportion cutspend, over(mode)
svy: proportion pair_gov, over(mode)
svy: proportion pair_right, over(mode)


* Close results log to recode variables for regression analysis
log close

* Recode independent variables for regression models
recode track 2=0 3=., gen(rightrack)

recode econtrend 4=., gen(econ)

recode obamaapp 5=. 4=1 3=2 2=3 1=4

recode ideo5 6=.

tab pid3, gen(party)

recode birthyr 9998=. 9999=.
gen age=2010-birthyr

tab race, gen(race)

recode gender 2=1 1=0, gen(female)

recode bornagain 2=0

recode income 15=.

recode congapp 5=.

recode gaymarriage-taxrich (3=.)

* Re-open results log for regression analysis results
log using modestudy.log, append

* OLS Estimates of Factors Affecting Obama Approval (Table 4)
svy: reg obamaapp ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==1
estimates store internet
svy: reg obamaapp ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==2
estimates store phone
svy: reg obamaapp ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==4
estimates store mail

suest internet phone
test [internet]ideo5=[phone]ideo5
test [internet]rightrack=[phone]rightrack
test [internet]econ=[phone]econ
test [internet]party1=[phone]party1
test [internet]party2=[phone]party2
test [internet]age=[phone]age
test [internet]female=[phone]female
test [internet]race1=[phone]race1
test [internet]educ=[phone]educ
test [internet]income=[phone]income
test [internet]bornagain=[phone]bornagain
test [internet=phone]

suest internet mail
test [internet]ideo5=[mail]ideo5
test [internet]rightrack=[mail]rightrack
test [internet]econ=[mail]econ
test [internet]party1=[mail]party1
test [internet]party2=[mail]party2
test [internet]age=[mail]age
test [internet]female=[mail]female
test [internet]race1=[mail]race1
test [internet]educ=[mail]educ
test [internet]income=[mail]income
test [internet]bornagain=[mail]bornagain
test [internet=mail]

suest phone mail
test [phone]ideo5=[mail]ideo5
test [phone]rightrack=[mail]rightrack
test [phone]econ=[mail]econ
test [phone]party1=[mail]party1
test [phone]party2=[mail]party2
test [phone]age=[mail]age
test [phone]female=[mail]female
test [phone]race1=[mail]race1
test [phone]educ=[mail]educ
test [phone]income=[mail]income
test [phone]bornagain=[mail]bornagain
test [phone=mail]

estimates clear

* F-Test Results for other Models (Table 5)
svy: reg congapp ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==1
estimates store internet
svy: reg congapp ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==2
estimates store phone
svy: reg congapp ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==4
estimates store mail
suest internet phone
test [internet=phone]
suest internet mail
test [internet=mail]
suest phone mail
test [phone=mail]
estimates clear

svy: reg abort ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==1
estimates store internet
svy: reg abort ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==2
estimates store phone
svy: reg abort ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==4
estimates store mail
suest internet phone
test [internet=phone]
suest internet mail
test [internet=mail]
suest phone mail
test [phone=mail]
estimates clear

svy: reg affact ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==1
estimates store internet
svy: reg affact ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==2
estimates store phone
svy: reg affact ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==4
estimates store mail
suest internet phone
test [internet=phone]
suest internet mail
test [internet=mail]
suest phone mail
test [phone=mail]
estimates clear

svy: reg gaymarriage ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==1
estimates store internet
svy: reg gaymarriage ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==2
estimates store phone
svy: reg gaymarriage ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==4
estimates store mail
suest internet phone
test [internet=phone]
suest internet mail
test [internet=mail]
suest phone mail
test [phone=mail]
estimates clear

svy: reg socsecstock ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==1
estimates store internet
svy: reg socsecstock ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==2
estimates store phone
svy: reg socsecstock ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==4
estimates store mail
suest internet phone
test [internet=phone]
suest internet mail
test [internet=mail]
suest phone mail
test [phone=mail]
estimates clear

svy: reg taxrich ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==1
estimates store internet
svy: reg taxrich ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==2
estimates store phone
svy: reg taxrich ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==4
estimates store mail
suest internet phone
test [internet=phone]
suest internet mail
test [internet=mail]
suest phone mail
test [phone=mail]
estimates clear

svy: reg cutspend ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==1
estimates store internet
svy: reg cutspend ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==2
estimates store phone
svy: reg cutspend ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==4
estimates store mail
suest internet phone
test [internet=phone]
suest internet mail
test [internet=mail]
suest phone mail
test [phone=mail]
estimates clear

svy: reg pair_gov ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==1
estimates store internet
svy: reg pair_gov ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==2
estimates store phone
svy: reg pair_gov ideo5 rightrack econ party1 party2 age female race1 educ income bornagain if mode==4
estimates store mail
suest internet phone
test [internet=phone]
suest internet mail
test [internet=mail]
suest phone mail
test [phone=mail]
estimates clear

* Gen indicator variables for Knowledge Regression analysis
recode ideo5 2=1 3/5=0, gen(liberals)
recode ideo5 4/5=1 1/3=0, gen(conservatives)


* OLS Estimates for Political Knowledge (Table 6)
svy: reg knowledge liberals conservatives party1 party2 age female race1 educ income  if mode==1
estimates store internet
svy: reg knowledge liberals conservatives  party1 party2 age female race1 educ income  if mode==2
estimates store phone
svy: reg knowledge liberals conservatives  party1 party2 age female race1 educ income  if mode==4
estimates store mail

suest internet phone
test [internet]liberals=[phone]liberals
test [internet]conservatives=[phone]conservatives
test [internet]party1=[phone]party1
test [internet]party2=[phone]party2
test [internet]age=[phone]age
test [internet]female=[phone]female
test [internet]race1=[phone]race1
test [internet]educ=[phone]educ
test [internet]income=[phone]income
test [internet=phone]

suest internet mail
test [internet]liberals=[mail]liberals
test [internet]conservatives=[mail]conservatives
test [internet]party1=[mail]party1
test [internet]party2=[mail]party2
test [internet]age=[mail]age
test [internet]female=[mail]female
test [internet]race1=[mail]race1
test [internet]educ=[mail]educ
test [internet]income=[mail]income
test [internet=mail]

suest phone mail
test [phone]liberals=[mail]liberals
test [phone]conservatives=[mail]conservatives
test [phone]party1=[mail]party1
test [phone]party2=[mail]party2
test [phone]age=[mail]age
test [phone]female=[mail]female
test [phone]race1=[mail]race1
test [phone]educ=[mail]educ
test [phone]income=[mail]income
test [phone=mail]


estimates clear

log close

