clear
set more off
version 10.1
use Kam_risk_orientation.dta, clear

/*

Table 6 is produced at the very end of the file
*/

*MERGE TIME

rename enddate time
sort ipaddress time

drop if ipaddress == "76.202.222.120" /*this guy was a duplicate  with both ipaddress and start time*/

merge ipaddress time using demographics.dta
tab _merge
rename _merge _merge0
save temp1.dta, replace
drop if _merge0 == 2
save temp0.dta, replace
use temp1.dta

drop if ipaddress == "76.202.222.120" /*this guy was a duplicate even with both ipaddress and start time, let's drop him AGAIN*/

keep if _merge0 == 2
keep responseid externaldatareference ipaddress startdate enddate finished condition text1 text2 sex partyID_1 partyID_2 birthyear income education ideology
sort ipaddress
save temp2.dta, replace


use temp0.dta
sort ipaddress
merge ipaddress using temp2.dta
tab _merge _merge0
rename _merge _merge1
save temp3.dta, replace


*****************************************************
*drop people who don't answer income, education, age or sex
drop if income == .
drop if education == .
drop if sex == .
*****************************************************
*create age
gen age =  2011-(2000-(birthyear-1))
*change sex to female
gen female = 1 if sex == 2
replace female = 0 if sex == 1
drop if age == .


*need to code education the way Kam did
gen kameducation = 1 if education == 1
replace kameducation = 3 if education == 2
replace kameducation = 4 if education == 3
replace kameducation = 5 if education == 4
replace kameducation = 6 if education == 5
replace kameducation = 7 if education == 6
replace kameducation = 7 if education == 7
replace kameducation = 7 if education == 8

*also code income the way Kam did
gen kamincome = 2 if income == 1
replace kamincome = 4 if income == 2
replace kamincome = 6 if income == 3
replace kamincome = 7 if income == 4
replace kamincome = 8 if income == 5
replace kamincome = 9 if income == 6
replace kamincome = 11 if income == 7 
replace kamincome = 12 if income == 8
replace kamincome = 13 if income == 9
replace kamincome = 13 if income == 10
replace kamincome = 15 if income == 11
replace kamincome = 16 if income == 12
replace kamincome = 17 if income == 13
replace kamincome = 18 if income == 14
replace kamincome = . if income == 15

gen kamincome01 = (kamincome-1)/18
drop if kamincome01 == .

*let's normalize age and education too
gen kameducation01 = (kameducation-1)/6
gen kamage = (age-14)/(82-14)

*****************************************************
*Need to evaluate information - here we clean up and rescale the Need to Evaluate questions, but we haven't generated a mean yet

gen nte1_1 = 1-((nte1-1)/3) /*reverse code this one*/
gen nte2_1 = 0 if nte2b == 1 /*since NTE2 + A + B are branched questions we need to integrate them here*/
replace nte2_1 = 1 if nte2b == 2
replace nte2_1 = 2 if nte2 == 3
replace nte2_1 = 3 if nte2a == 2
replace nte2_1 = 4 if nte2a == 1

replace nte2_1 = nte2_1/4

tab nte2_1

egen NTE = rmean(nte2_1 nte1_1)


*****************************************************
*Need for cognition information - here we clean up and rescale the Need for Cognition questions, but we haven't generated a mean yet


gen nfc1_1 = 0 if nfc1b == 1 /*since nfc1 + a + b are branched questions we need to integrate them here*/
replace nfc1_1 = 1 if nfc1b == 2
replace nfc1_1 = 2 if nfc1 == 3
replace nfc1_1 = 3 if nfc1a == 2
replace nfc1_1 = 4 if nfc1a == 1

replace nfc1_1 = nfc1_1/4

gen nfc2_1 = (nfc2-1)/1 

egen NFC = rmean (nfc1_1 nfc2_1)

****************************************************
*We'll construct the Kam risk acceptance scale here
gen ra1_1 = (ra1-1)/6
gen ra2_1 = 1-((ra2-1)/4) /*reverse code this one*/
gen ra3_1 = (ra3-1)/4
gen ra4_1 = (ra4-1)/4 
gen ra5_1 = (ra5-1)/4
gen ra6_1 = (ra6-1)/4
gen ra7_1 = 1-((ra7-1)/3) /*reverse code this one*/

corr ra*_1
sum ra*_1

*to replace stuff use var = 1 - var
*add a tab

*Here's a mean of all the ra*_1 vars that we'll use in correlations later
egen ramean = rowmean(ra*_1)
replace ramean = ramean/.9642857
compress



******************************************************
*Let's replicate Kam's table 1 using ramean
corr ramean female kamage kameducation01 kamincome01

*****************************************************
*Now we're going to code the manipulations and results
gen mortalityfirst = 0 if survival1 == 1
replace mortalityfirst = 0 if survival1 == 2
replace mortalityfirst = 1 if survival1 == .

*Let's follow Kam's analysis - first:

*Among those who were given the survival frame, how many select the sure thing? In Kam, it was 68.2%, versus, 31.8%
tab survival1

*How about the mortality frame first? In Kam it was 27.6% selecting the sure thing, versus 72.4% going for the risk
tab mortality1

*Now we need to construct a variable called 'preference for the probabilistic choice'. We're going to call it pfp1
gen pfp1 = 0 if survival1 == 1
replace pfp1 = 1 if survival1 == 2
replace pfp1 = 0 if mortality1 == 1
replace pfp1 = 1 if mortality1 == 2

*we will use mortalityfirst as the dummy for mortality as mortalityfirst = 1 indicates mortality presentation

sum pfp1 mortalityfirst ramean
probit pfp1 mortalityfirst ramean

*Let's move to the second presentation. Of those who are now given the survival frame, how many select the sure thing? In Kam, it was 49.9% vs. 50.1%
tab survival2

*And of those who are given the mortality frame, how many select the sure thing? In Kam, it was 42.1% who chose the sure thing vs. 57.9% who choose the probabilistic outcome.
tab mortality2

*Now we need to construct another variable called 'preference for the probabilistic choice,' this one for the second presentation. We're going to call it pfp2
gen pfp2 = 0 if survival2 == 1
replace pfp2 = 1 if survival2 == 2
replace pfp2 = 0 if mortality2 == 1
replace pfp2 = 1 if mortality2 == 2

*Like Kam, let's repeat the first probit analysis with the second frames; we'll need a new mortality dummy, which we'll call mortalitysecond

gen mortalitysecond = 1 if mortalityfirst == 0
replace mortalitysecond = 0 if mortalityfirst == 1

sum pfp2 mortalitysecond ramean
probit pfp2 mortalitysecond ramean

*Let's generate a variable to indicate whether subjects swapped their preferences between probabilistic and sure thing

gen bothprob = (survival1 == 2 | mortality1 == 2) &  (survival2 == 2 | mortality2 ==2 ) 
gen toprob = (survival1 == 1 | mortality1 == 1) &  (survival2 == 2 | mortality2 == 2) 
gen fromprob = (survival1 == 2 | mortality1 == 2) &  (survival2 == 1 | mortality2 == 1) 
gen bothsure = (survival1 == 1 | mortality1 == 1) &  (survival2 == 1 | mortality2 == 1) 

*And let's generate a variable, as Kam used, which contains this information using the values 1-4

gen probdelta = 1 if bothsure == 1
replace probdelta = 2 if bothprob == 1
replace probdelta = 3 if toprob == 1
replace probdelta = 4 if fromprob == 1


*we need an ideology normalized first
gen ideology2 = (ideology-1)/6
sum pfp1 mortalityfirst ramean female kamage kameducation01 kamincome01 ideology2

*create the interaction variable for ramean and mortalityfirst
gen rameanXmortalityfirst = ramean * mortalityfirst


******************************************************

** Table 6 **
probit pfp1 mortalityfirst ramean
outreg2 using kamtable2, replace word se noast auto(2) ct(control)
probit pfp1 mortalityfirst ramean female kamage kameducation01 kamincome01 ideology2
outreg2 using kamtable2, append word se noast auto(2) ct(control)
probit pfp1 mortalityfirst ramean rameanXmortalityfirst
outreg2 using kamtable2, append word se noast auto(2) ct(control)



