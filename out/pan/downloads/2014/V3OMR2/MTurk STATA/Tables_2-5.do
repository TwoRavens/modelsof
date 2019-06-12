clear
set mem 300m
set more off

/*
This file 1) recodes the data sets, 2) stacks the data, 
and 3) replicates Tables 2-5 and Figures 1 & 2
*/





***********************************
*Kam coding
use Kam_risk_orientation, clear

*****************************************************
*Need to evaluate information

gen nte1_1 = 1-((nte1-1)/3) /*reverse code this one*/
gen nte2_1 = 0 if nte2b == 1 /*since NTE2 + A + B are branched questions we integrate them here*/
replace nte2_1 = 1 if nte2b == 2
replace nte2_1 = 2 if nte2 == 3
replace nte2_1 = 3 if nte2a == 2
replace nte2_1 = 4 if nte2a == 1

replace nte2_1 = nte2_1/4

*tab nte2_1

*Now we generate a mean
egen NTE = rmean(nte2_1 nte1_1)

*****************************************************
*Need for cognition information

gen nfc1_1 = 0 if nfc1b == 1 /*since nfc1 + a + b are branched questions we integrate them here*/
replace nfc1_1 = 1 if nfc1b == 2
replace nfc1_1 = 2 if nfc1 == 3
replace nfc1_1 = 3 if nfc1a == 2
replace nfc1_1 = 4 if nfc1a == 1

replace nfc1_1 = nfc1_1/4

gen nfc2_1 = (nfc2-1)/1 

*Now we generate a mean
egen NFC = rmean (nfc1_1 nfc2_1)

****************************************************

*Prep for further use later in the do-file
keep NFC NTE

rename NFC kam_NFC
rename NTE kam_NTE

gen study=4

save kam_NFCNTE, replace










***********************************
*CPS coding for age education race gender (everything except income)
use CPS_2008.dta,clear

*Vote in November election?
tab PES1, 
tab PES1, nol
tab PES5
tab PES5, nol
tab PES6, 
tab PES6, nol
g turnout=PES1 if PES1!= -1
*g turnout =PES5 if PES5!= -1
tab turnout

*did not vote
replace turnout = 0 if PES1 ==2
replace turnout = 0 if PES1 ==-2
replace turnout = 0 if PES1 ==-3
replace turnout = 0 if PES1 ==-9
replace turnout = 3 if PES6 ==2
replace turnout = 2 if PES5 ==2
recode turnout 1 2 3 = 1 0 = 0
tab turnout
proportion turnout [pw=PWSSWGT]

g turnout_1=turnout

sum PWSSWGT    PWCMPWGT   

svyset [pw=PWSSWGT]
drop if PRTAGE <18
proportion turnout_1 
proportion turnout_1 [pw=PWSSWGT]

gen dem_voteturnout = turnout_1
tab dem_voteturnout, mis

*registered to vote
*replace PES1=. if PES1 == -1 /*this sets as missing all those that gave no response, refused, or don't know (about ten thousand) as well as those not in universe (about eight thousand) to the question of DID YOU VOTE in November*/
*replace PES2=. if PES2 == -1
tab PES2 PES1, 
tab PES2, nolabel
*tab PES1 
*tab PES1 ,nol
*tab PES1 PES2 if PES1 ==2
*replace PES2 = 1 if turnout_1 == 1
*replace PES2 =. if PES2  == -1
tab PES2
tab PES2, nol
gen par_reg2008=1 if PES2==1
replace par_reg2008=0 if PES2==2
replace par_reg2008=0 if PES2==-9|PES2==-3|PES2==-2
replace par_reg2008=1 if turnout_1==1
svy: proportion PES2
svy: proportion par_reg2008

gen dem_voteregister = par_reg2008

*Vote in November election?
tab PES5
tab PES6 PES5 
tab PES5, nol
*tab turnout
*svy: proportion turnout
*svy: proportion PES1
*svy: proportion turnout_1

*Sex
*tab PESEX
*svy: proportion PESEX
replace PESEX=0 if PESEX==1
replace PESEX=1 if PESEX==2

*Hispanic?
*tab PEHSPNON
*svy: proportion PEHSPNON

*Marital Status
*tab PEMARITL
*tab PEMARITL, nol
recode PEMARITL 2 = 1
*svy: proportion PEMARITL
gen dem_marital = PEMARITL
recode dem_marital (1=1) (3=5) (4=2) (5=3) (6=4)

*age
*tab PRTAGE
*svy: mean PRTAGE


*education
*tab PEEDUCA
*tab PEEDUCA, nol
recode PEEDUCA 31 = 0 32 = 2.5 33 = 5.5 34 = 7.5 35 = 9 36 = 10 37 = 11 38 = 11 39 = 12 40 = 13 41 = 14  42 = 14 43 = 16 44 = 18 45 = 19 46 = 21, generate(edu_years)
*tab edu_years
*svy: mean edu_years

*race
tab PTDTRACE
svy: proportion PTDTRACE
gen dem_race_cps = .
replace dem_race_cps = 1 if PTDTRACE==1
replace dem_race_cps = 0 if PTDTRACE==2
replace dem_race_cps = 9 if PTDTRACE==3
replace dem_race_cps = 9 if PTDTRACE==4
replace dem_race_cps = 9 if PTDTRACE==5
replace dem_race_cps = 9 if PTDTRACE==6
replace dem_race_cps = 9 if PTDTRACE==7
replace dem_race_cps = 9 if PTDTRACE==8
replace dem_race_cps = 9 if PTDTRACE==9
replace dem_race_cps = 9 if PTDTRACE==10
replace dem_race_cps = 9 if PTDTRACE==11
replace dem_race_cps = 9 if PTDTRACE==12
replace dem_race_cps = 9 if PTDTRACE==13
replace dem_race_cps = 9 if PTDTRACE==14
replace dem_race_cps = 9 if PTDTRACE==15
replace dem_race_cps = 9 if PTDTRACE==16
replace dem_race_cps = 9 if PTDTRACE==17
replace dem_race_cps = 9 if PTDTRACE==18
replace dem_race_cps = 9 if PTDTRACE==19
replace dem_race_cps = 9 if PTDTRACE==20
replace dem_race_cps = 9 if PTDTRACE==21
replace dem_race=dem_race_cps 

*Hispanic?
svy: proportion PEHSPNON
gen dem_hispanic = 0
replace dem_hispanic = 1 if PEHSPNON == 1

*region
gen dem_region_cps=1 if GESTCEN == 11
replace dem_region_cps=1 if GESTCEN == 12
replace dem_region_cps=1 if GESTCEN == 13
replace dem_region_cps=1 if GESTCEN == 14
replace dem_region_cps=1 if GESTCEN == 15
replace dem_region_cps=1 if GESTCEN == 16
replace dem_region_cps=1 if GESTCEN == 21
replace dem_region_cps=1 if GESTCEN == 22
replace dem_region_cps=1 if GESTCEN == 23
replace dem_region_cps=2 if GESTCEN == 31
replace dem_region_cps=2 if GESTCEN == 32
replace dem_region_cps=2 if GESTCEN == 33
replace dem_region_cps=2 if GESTCEN == 34
replace dem_region_cps=2 if GESTCEN == 35
replace dem_region_cps=2 if GESTCEN == 41
replace dem_region_cps=2 if GESTCEN == 42
replace dem_region_cps=2 if GESTCEN == 43
replace dem_region_cps=2 if GESTCEN == 44
replace dem_region_cps=2 if GESTCEN == 45
replace dem_region_cps=2 if GESTCEN == 46
replace dem_region_cps=2 if GESTCEN == 47
replace dem_region_cps=3 if GESTCEN == 51
replace dem_region_cps=3 if GESTCEN == 52
replace dem_region_cps=3 if GESTCEN == 53
replace dem_region_cps=3 if GESTCEN == 54
replace dem_region_cps=3 if GESTCEN == 55
replace dem_region_cps=3 if GESTCEN == 56
replace dem_region_cps=3 if GESTCEN == 57
replace dem_region_cps=3 if GESTCEN == 58
replace dem_region_cps=3 if GESTCEN == 59
replace dem_region_cps=3 if GESTCEN == 61
replace dem_region_cps=3 if GESTCEN == 62
replace dem_region_cps=3 if GESTCEN == 63
replace dem_region_cps=3 if GESTCEN == 64
replace dem_region_cps=3 if GESTCEN == 71
replace dem_region_cps=3 if GESTCEN == 72
replace dem_region_cps=3 if GESTCEN == 73
replace dem_region_cps=3 if GESTCEN == 74
replace dem_region_cps=4 if GESTCEN == 81
replace dem_region_cps=4 if GESTCEN == 82
replace dem_region_cps=4 if GESTCEN == 83
replace dem_region_cps=4 if GESTCEN == 84
replace dem_region_cps=4 if GESTCEN == 85
replace dem_region_cps=4 if GESTCEN == 86
replace dem_region_cps=4 if GESTCEN == 87
replace dem_region_cps=4 if GESTCEN == 88
replace dem_region_cps=4 if GESTCEN == 91
replace dem_region_cps=4 if GESTCEN == 92
replace dem_region_cps=4 if GESTCEN == 93
replace dem_region_cps=4 if GESTCEN == 94
replace dem_region_cps=4 if GESTCEN == 95


rename turnout_1 vote_total

gen study = 5
keep PRTAGE edu_years study PWSSWGT dem_* par_* vote_total PESEX
rename PRTAGE dem_age_cps
rename edu_years dem_education_cps 
rename PESEX dem_gender
save cps_for_merge.dta, replace



**********************************************************************
*CPS 2008 data for income
use "CPS 2008 income.dta", clear

*recode HUFAMINC to use real values
keep if HUFAMINC > 0
recode HUFAMINC 1=2500 2=6250 3=8760 4=11250 5=13750 6=17500 7=22500 8=27500 9=32500 10=37500 11=45000 12=55000 13=67500 14=87500 15=125000 16=150000, gen(HUFAMINC2)
rename HUFAMINC2 dem_income_cps

keep dem_income_cps HWHHWGT
gen study = 6
save cps2_for_merge.dta, replace






***********************************
*ANES ftf coding
***********************************
*ANES face-to-face data
use "anes2008ts.dta", clear

*3-point
g id_party3 = 0 if v083097==1
replace id_party3 = 1 if v083097==2
replace id_party3 = 2 if v083097==3
label define id_party3 0 "Democrat" 1 "Republican" 2 "Independent"
label values id_party3 id_party3
*tab id_party3

*7-point
*tab v083097
*tab v083098a 
**tab v083098a , nolabel
*tab v083098b 
*tab v083098b , nolabel
g id_party = 1 if id_party3== 0 &       v083098a == 1
replace id_party = 2 if id_party3==0 &  v083098a == 5
replace id_party = 3 if id_party3==2 &  v083098b == 5
replace id_party = 4 if id_party3==2 &  v083098b == 3
replace id_party = 5 if id_party3==2 &  v083098b == 1
replace id_party = 6 if id_party3==1 &  v083098a == 5
replace id_party = 7 if id_party3==1 &  v083098a == 1
proportion id_party

*create new party id_3 using 7 scale
*Dem=Strong Dem,Weak Dem = 1
*Rep=Strong Rep,Weak Rep = 2
*Ind=Lean Dem, Lean Rep = 3
*Neither=Neither = 4
g id_party4 = 1 if v083097 == 1
replace id_party4 = 2 if v083097 == 2
replace id_party4 = 3 if (v083097 == 3 | v083097 == 4 |v083097 == 5) & (v083098b == 1 | v083098b == 5)
replace id_party4 = 4 if (v083097 == 3 | v083097 == 4 |v083097 == 5) & (v083098b == 3)
proportion id_party4
*tab id_party4
*tab v083097
*tab v083098a 
*tab v083098b

*RACE
tab v081102
recode v081102 1=1 2=0 else = 9
gen dem_race = v081102

gen dem_hispanic = 0
replace dem_hispanic=1 if v081103==1 /*Latino marker*/


*INTEREST

*tab v085073a 
 recode v085073a (-2=.) (1=5) (2=4) (3=3) (4=2) (5=1)
gen in_govt = v085073a 


*gender
recode v083311 1 = 0 2 = 1,g(dem_gender)

*IDEOLOGY

*Ideology goes from 1 (very liberal) to 7 (very conservative)
gen id_ideology = v083069 
*tab  id_ideo

*HOME OWNERSHIP
recode v083281 5 = 0 7 = 9,g(dem_ownhome)

*MARITAL STATUS
gen dem_marital = v083216x
recode dem_marital (1=1) (2=2) (3=3) (4=5) (5=4) (6=4)

*prescription drugs
*tab v083122  
gen pol_prescripseniors = v083122  
recode pol_prescripseniors (-7=.) (-6=.) (-4=.) (-2=.) (1=1) (2=0) (3=.5)
*tab pol_prescripseniors

*universal healthcare
*tab v083124 
gen pol_allmedical = v083124 
recode pol_allmedical (-7=.) (-6=.) (-4=.) (-2=.) (1=1) (2=0) (3=.5)
*tab pol_allmedical

*citizenship process for illegal immigrants
*tab v083133  
gen pol_immigrants = v083133  
recode pol_immigrants (-7=.) (-6=.) (-4=.) (-2=.) (1=1) (2=0) (3=.5)
*tab pol_immigrants

*recode v083248 household income to use real values
recode v083248 1=1500 2=4000 3=6250 4=8750 5=10500 6=11750 7=13750 8=16000 9=18000 10=21000 11=23500 12=27500 13=32500 14=37500 15=42500 16=47500 17=55000 18=67500 19=82500 20=95000 21=10500 22=115000 23=127500 24=142500 25=150000, gen(dem_income_anesftf)

*REGION
rename v081204 dem_region_anesftf

*rename age dem_age_anesftf
rename v081104 dem_age_anesftf

*rename education var to dem_education_anesftf
rename v083217 dem_education_anesftf

*rename NTE and NFC
rename NTE dem_NTE_anesftf
rename NFC dem_NFC_anesftf

*voter registration - code nonrespondent as 0
gen par_reg2008=1 if v085036a == 4
replace par_reg2008=1 if v085036d == 2
replace par_reg2008=1 if v085036d == 3
replace par_reg2008=1 if v085036d == 4
replace par_reg2008=1 if v085036d == 5
replace par_reg2008=1 if v085037 == 1
replace par_reg2008=0 if par_reg2008==.

gen dem_voteregister = par_reg2008

*voter turnout
gen vote_total=1 if v085036a == 4
replace vote_total=1 if v085036d == 2
replace vote_total=1 if v085036d == 3
replace vote_total=1 if v085036d == 4
replace vote_total=1 if v085036d == 5
replace vote_total=0 if vote_total==.


tab vote_total, mis
gen dem_voteturnout = vote_total
tab dem_voteturnout, mis

*religion
gen dem_religpref = v085251a
recode dem_religpref (1=1) (2=2) (3=3) (7=4) (.=0)

keep  id_*  pol_* in_* v080101    v080102  dem_* par_* vote_total

gen study = 3

compress

save "ANES_ftf_coded.dta", replace 














*****************************************
*ANES panel coding
****************************************
use "ANES_panel.dta", clear

set more off

*INTEREST
*tab rqpol 
 recode rqpol (-2=.) (1=5) (2=4) (3=3) (4=2) (5=1)
gen in_govt = rqpol

*TV

recode w1h1 (-7=.) (-6=.) (-2=.)
gen tv_watchnews = w1h1

recode w1h2 (-7=.) (-6=.) (-4=.) (-2=.)
gen tv_radionews = w1h2

recode w1h3 (-7=.) (-6=.) (-4=.) (-2=.)
gen tv_internetnews = w1h3

recode w1h4 (-7=.) (-6=.) (-4=.) (-2=.)
gen tv_papernews = w1h4

*MARITAL STATUS*
gen dem_marital = cpq12
recode dem_marital (1=1) (2=5) (3=2) (4=3) (5=4)

*RELIGION

gen dem_religpref = w1j2

recode dem_religpref (1=1) (2=2) (3=3) (4=4) (5=0) (-7=.) (-6=.) (-4=.) (-2=.)


*KNOWLEDGE

gen kn_presterms = w2u2 == 2 if w2u2!=. &w2u2!=-6 &w2u2!=-2
*& = all true, ex. . and -6 and -2 are set to .
*tab kn_presterms, mis

gen kn_senterm = w2u3 == 6 if w2u3!=. &w2u3!=-6 &w2u3!=-2
*tab kn_senterm, mis

gen kn_numsens = w2u4 == 2 if w2u4!=. &w2u4!=-6 &w2u4!=-2
*tab kn_numsens, mis

gen kn_houseterm = w2u5 == 2 if w2u5!=. &w2u5!=-6 &w2u5!=-2
*tab kn_houseterm, mis

gen kn_presdies = w11wv11 == 3 if w11wv11!=. &w11wv11!=-6 &w11wv11!=-2 &w11wv11!=-1
*tab kn_presdies, mis

gen kn_override = w11wv12 == 2 if w11wv12!=. &w11wv12!=-6 &w11wv12!=-2 &w11wv12!=-1
*tab kn_override, mis

*POLITICAL PARTICIPATION
*note: this means registered to vote in general, mech turk asked about 2008

recode w1b1 (1=1) (2=0) (-7=.) (-6=.) (-9=.) (-2=.) (-1=.)
gen par_reg2008 = w1b1
*tab par_reg2008, mis
gen dem_voteregister = par_reg2008

gen par_vote = w11a4
recode par_vote (-6=.) (-2=.)
*describe w11a4
label values par_vote F_2513_
*tab par_vote

gen dem_voteturnout = par_vote
recode dem_voteturnout (1=0) (2=1) (3=1) (4=1) (5=1) (6=.)
tab dem_voteturnout, mis

*OTHER PARTICIPATION

recode w1j1a_1 (-7=.) (-6=.) (-2=.) (-1=.) (-9=.)
gen opar_religwk = w1j1a_1
*tab opar_religwk, mis

recode w1j1a_2 (-7=.) (-6=.) (-2=.) (-1=.)
gen opar_religmnth = w1j1a_2
*tab opar_religmnth, mis

*opar_religtotal: question in different form


*POLICY QUESTIONS
*tab w1p1
gen pol_marriage = w1p1
recode pol_marriage (-7=.) (-6=.) (-4=.) (-2=.) (-1=.) (1=1) (2=0) (3=.5)
*tab pol_marriage                    

gen pol_taxover = w1p4
recode pol_taxover (-7=.) (-6=.) (-4=.) (-2=.) (1=1) (2=0) (3=.5)
*tab pol_taxover

gen pol_taxunder = w1p7
recode pol_taxunder (-7=.) (-6=.) (-4=.) (-2=.) (1=1) (2=0) (3=.5)
*tab pol_taxunder

*tab w1p10
gen pol_prescripseniors = w1p10
recode pol_prescripseniors (-7=.) (-6=.) (-4=.) (-2=.) (1=1) (2=0) (3=.5)
*tab pol_prescripseniors

gen pol_allmedical = w1p13
recode pol_allmedical (-7=.) (-6=.) (-4=.) (-2=.) (1=1) (2=0) (3=.5)
*tab pol_allmedical

gen pol_immigrants = w1p25
recode pol_immigrants (-7=.) (-6=.) (-4=.) (-2=.) (1=1) (2=0) (3=.5)
*tab pol_immigrants


*PARTY ID
*tab w1m1 
*tab w1m3
*tab w1m1, nolabel

*3-point
recode w1m1 (1=0) (2=1) (3=2) (4=2) (-7=.) (-6=.) (-4=.) (-2=.) (-1=.)
recode w1m3 (1=0) (2=1) (3=2) (4=2) (-7=.) (-6=.) (-4=.) (-2=.) (-1=.)
*tab w1m1 w1m3, mis
g id_party3 = 0 if w1m1==0 | w1m3==0
replace id_party3 = 1 if w1m1==1 | w1m3==1
replace id_party3 = 2 if w1m1==2 | w1m3==2
label define id_party3 0 "Democrat" 1 "Republican" 2 "Independent"
label values id_party3 id_party3
*tab id_party3

*7-point
*tab w1m5
*tab w1m5, nolabel
*tab w1m6
*tab w1m6, nolabel
g id_party = 1 if id_party3== 0 &  w1m5 == 1
replace id_party = 2 if id_party3==0 &  w1m5 == 2
replace id_party = 3 if id_party3==2 &  w1m6 == 2
replace id_party = 4 if id_party3==2 &  w1m6 == 3
replace id_party = 5 if id_party3==2 &  w1m6 == 1
replace id_party = 6 if id_party3==1 &  w1m5 == 2
replace id_party = 7 if id_party3==1 &  w1m5 == 1
*tab id_party id_party3

**tab1 der08w11
*for Y in any der08w11 \ X in num 11 :  generate  PID_X=  (Y/6) if Y>=0

*IDEOLOGY

*Ideology goes from 1 (very liberal) to 7 (very conservative)
gen id_ideology = .
replace id_ideology = 7 if w1n1==2 &  w1n3 ==1 
replace id_ideology = 6 if w1n1==2 &  w1n3 ==2 
replace id_ideology = 5 if w1n1==3 &  w1n4 ==2 
replace id_ideology = 4 if w1n1==3 &  w1n4 ==3 
replace id_ideology = 3 if w1n1==3 &  w1n4 ==1 
replace id_ideology = 2 if w1n1==1 &  w1n2 ==2 
replace id_ideology = 1 if w1n1==1 &  w1n2 ==1
*tab  id_ideo

*EDUCATION

gen dem_educ_uncoded = cpq15

recode dem_educ_uncoded (-2=.) (0=0) (1=1) (3=8) (4=9) (5=10) (6=11) (7=12) (8=12) (9=13) (10=14) (11=16) (12=18) (13=21) (14=21) 
rename dem_educ_uncoded dem_education_anesps


*DEMOGRAPHICS

recode rgenderr (1=0) (2=1) (-2=.)
gen dem_gender = rgenderr

recode cpq2 (1=1) (2=0) (3=9) (-2=.)
gen dem_ownhome = cpq2
*proportion dem_ownhome [pw = wgtcsp]

gen dem_hispanic_bin = cpq13
recode dem_hispanic_bin (1=0) (2=1) (3=1) (4=1) (5=1) (6=1) (7=1) (8=1) (-2=.)

gen dem_hispanic_type = cpq13
recode dem_hispanic_type (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (-2=.)

gen dem_race = .
replace dem_race = 1 if rracewhite == 1
replace dem_race = 0 if rraceblack == 1
replace dem_race = 9 if dem_race == .
replace dem_race = 9 if rracewhite == -2

gen dem_hispanic = 0
replace dem_hispanic = 1 if rhisp==1


gen dem_maritalstatus = cpq12
recode dem_maritalstatus (1=1) (2=5) (3=3) (4=4) (5=2) (-2=.)

gen dem_cohabit = cpq12a
recode dem_cohabit (1=1) (2=0) (-2=.)

gen dem_religpref2 = w9zg2
recode dem_religpref2 (-7=.) (-6=.) (-2=.) (-1=.) (5=0)

*INCOME


gen dem_income_anesps = 2500 if cpq35a == 1 
replace dem_income_anesps = 6250 if cpq35a == 2
replace dem_income_anesps = 8750 if cpq35a == 3
replace dem_income_anesps = 11250 if cpq35a == 4
replace dem_income_anesps = 13750 if cpq35a == 5
replace dem_income_anesps = 17500 if cpq35a == 6
replace dem_income_anesps = 37500 if cpq36a == 1
replace dem_income_anesps = 45000 if cpq36a == 2
replace dem_income_anesps = 55000 if cpq36d== 1
replace dem_income_anesps = 67500 if cpq36d== 2
replace dem_income_anesps = 80000 if cpq36d== 3
replace dem_income_anesps = 92500 if cpq36d== 4
replace dem_income_anesps = 112500 if cpq36e== 1
replace dem_income_anesps = 137500 if cpq36e== 2
replace dem_income_anesps = 142500 if cpq36e== 3
replace dem_income_anesps = 142500 if cpq36e== 4
replace dem_income_anesps = 27500 if cpq35 == 2

*AGE
tab rager
rename rager dem_age_anesps
replace dem_age_anesps = . if dem_age_anesps == -2

*NEED TO EVALUATE
gen nte1=1-((w11ze1-1)/3) if w11ze1>0
gen nte2=3 if w11ze2 == 2
*we detected a miscoding in the ANESPS data here, we correct for this by flipping 3b and 3a
replace nte2=1 if w11ze3b == 1
replace nte2=2 if w11ze3b == 2
replace nte2=4 if w11ze3a == 2
replace nte2=5 if w11ze3a == 1
*time to normalize this on 0-1
replace nte2=((nte2-1)/4)

*combine both normalized vars
egen dem_NTE_anesps=rmean(nte1 nte2)


*NEED FOR COGNITION

gen nfc1=3 if w11ze4 == 3
replace nfc1=1 if w11ze5b == 1
replace nfc1=2 if w11ze5b == 2
replace nfc1=4 if w11ze5a == 2
replace nfc1=5 if w11ze5a == 1
*time to normalize this on 0-1
replace nfc1=((nfc1-1)/4)

gen nfc2=(w11ze6-1) if w11ze6>0

egen dem_NFC_anesps=rmean(nfc1 nfc2)

*REGION
gen dem_region_anesps = 1 if w11xhomest == "CT"
replace dem_region_anesps = 1 if w11xhomest == "ME"
replace dem_region_anesps = 1 if w11xhomest == "MA"
replace dem_region_anesps = 1 if w11xhomest == "NH"
replace dem_region_anesps = 1 if w11xhomest == "RI"
replace dem_region_anesps = 1 if w11xhomest == "VT"
replace dem_region_anesps = 1 if w11xhomest == "NJ"
replace dem_region_anesps = 1 if w11xhomest == "NY"
replace dem_region_anesps = 1 if w11xhomest == "PA"
replace dem_region_anesps = 2 if w11xhomest == "IL"
replace dem_region_anesps = 2 if w11xhomest == "IN"
replace dem_region_anesps = 2 if w11xhomest == "IA"
replace dem_region_anesps = 2 if w11xhomest == "KS"
replace dem_region_anesps = 2 if w11xhomest == "MI"
replace dem_region_anesps = 2 if w11xhomest == "MN"
replace dem_region_anesps = 2 if w11xhomest == "MO"
replace dem_region_anesps = 2 if w11xhomest == "NE"
replace dem_region_anesps = 2 if w11xhomest == "ND"
replace dem_region_anesps = 2 if w11xhomest == "OH"
replace dem_region_anesps = 2 if w11xhomest == "SD"
replace dem_region_anesps = 2 if w11xhomest == "WI"
replace dem_region_anesps = 3 if w11xhomest == "FL"
replace dem_region_anesps = 3 if w11xhomest == "GA"
replace dem_region_anesps = 3 if w11xhomest == "MD"
replace dem_region_anesps = 3 if w11xhomest == "NC"
replace dem_region_anesps = 3 if w11xhomest == "SC"
replace dem_region_anesps = 3 if w11xhomest == "VA"
replace dem_region_anesps = 3 if w11xhomest == "WV"
replace dem_region_anesps = 3 if w11xhomest == "DE"
replace dem_region_anesps = 3 if w11xhomest == "AL"
replace dem_region_anesps = 3 if w11xhomest == "KY"
replace dem_region_anesps = 3 if w11xhomest == "MS"
replace dem_region_anesps = 3 if w11xhomest == "TN"
replace dem_region_anesps = 3 if w11xhomest == "AR"
replace dem_region_anesps = 3 if w11xhomest == "LA"
replace dem_region_anesps = 3 if w11xhomest == "OK"
replace dem_region_anesps = 3 if w11xhomest == "TX"
replace dem_region_anesps = 3 if w11xhomest == "DC"
replace dem_region_anesps = 4 if w11xhomest == "MT"
replace dem_region_anesps = 4 if w11xhomest == "WY"
replace dem_region_anesps = 4 if w11xhomest == "CO"
replace dem_region_anesps = 4 if w11xhomest == "NM"
replace dem_region_anesps = 4 if w11xhomest == "ID"
replace dem_region_anesps = 4 if w11xhomest == "MT"
replace dem_region_anesps = 4 if w11xhomest == "UT"
replace dem_region_anesps = 4 if w11xhomest == "AZ"
replace dem_region_anesps = 4 if w11xhomest == "NV"
replace dem_region_anesps = 4 if w11xhomest == "WA"
replace dem_region_anesps = 4 if w11xhomest == "OR"
replace dem_region_anesps = 4 if w11xhomest == "CA"
replace dem_region_anesps = 4 if w11xhomest == "AK"
replace dem_region_anesps = 4 if w11xhomest == "HI"


keep kn_* par_* id_* dem_* pol_* in_* tv_* dem*

gen study = 1

compress

save "ANES_panel_coded.dta", replace 















***************************************
*Mechanical turk wave 1 coding
***************************************
insheet using "mechturkstudyw1.csv", clear
drop if v87==. /*drop without a valid gender - every respondent should have a gender*/

***LIVE IN US
gen country = v9
*tab country

**Survey-Taking Frequency
replace howmanysurveysofallsortswouldyou = "25" if howmanysurveysofallsortswouldyou == "25 or more"
gen s_numsurveysMT = real(howmanysurveysofallsortswouldyou)

replace howmanysurveysaboutpoliticsorcur = "25" if howmanysurveysaboutpoliticsorcur == "25 or more"
gen s_numpolsurveysMT = real(howmanysurveysaboutpoliticsorcur)

replace asidefromthesurveysyouhavetakeno = "25" if asidefromthesurveysyouhavetakeno == "25 or more"
gen s_numothersurveysMT = real(asidefromthesurveysyouhavetakeno)

******Screening questions
gen color_test = v21 == "red" & v22 == "green"
*tab color_test

gen number_test = whichnumberisthelargest == 1 & v27 == 2
*tab number_test


*** PERSONALITY TRAITS
destring v30, replace ignore("Critical, quarrelsome.")
gen p_critical = (v30-1)/6

destring hereareanumberofpersonalitytrait, replace ignore ("Extraverted, enthusiastic.")
gen p_extraverted = (hereareanumberofpersonalitytrait-1)/6

destring v31, replace ignore("Dependable, self-disciplined.")
gen p_dependable = (v31-1)/6

destring v32, replace ignore("Anxious, easily upset.")
gen p_anxious = (v32-1)/6

destring v33, replace ignore("Open to new experiences, complex.")
gen p_open = (v33-1)/6

destring v34, replace ignore("Reserved, quiet.")
gen p_reserved = (v34-1)/6

destring v35, replace ignore("Sympathetic, warm.")
gen p_sympathetic = (v35-1)/6

destring v36, replace ignore("Disorganized, careless.")
gen p_disorganized = (v36-1)/6

destring v37, replace ignore("Calm, emotionally s*table.")
gen p_calm = (v37-1)/6

destring v38, replace ignore("Conventional, uncreative.")
gen p_conventional = (v38-1)/6


*POLITICAL INTEREST QUESTIONS
gen in_govt = howinterestedareyouininformation
*tab in_govt, mis

*TELEVISION
gen tv_watchnews = duringatypicalweekhowmanydaysdoy

gen tv_radionews = v45

gen tv_internetnews = v46

gen tv_papernews = v47

*POLITICAL KNOWLEDGE QUESTIONS

gen kn_presterms = doyouhappentoknowhowmanytimesani == 2 if doyouhappentoknowhowmanytimesani!=.
*drops missing vars, sets correct to 1 and other to 0
*tab kn_presterms, mis

replace forhowmanyyearsisaunitedstatesse = "0" if forhowmanyyearsisaunitedstatesse == "don't know"
gen kn_senterm = forhowmanyyearsisaunitedstatesse == "6" if forhowmanyyearsisaunitedstatesse!=""
*tab kn_senterm, mis

gen kn_numsens = howmanyussenatorsaretherefromeac == "2" if howmanyussenatorsaretherefromeac!=""
*tab kn_numsens, mis

gen kn_houseterm = forhowmanyyearsisamemberoftheuni == "2" if forhowmanyyearsisamemberoftheuni!=""
*tab kn_houseterm, mis


gen kn_catholic = whowasthefirstcatholictobeamajor
*tab kn_catholic, mis

gen kn_wilson = whowaswoodrowwilsonsvicepresiden
*tab kn_wilson, mis

gen kn_presdies = accordingtofederallawifthepresid == "Speaker of the House of Representatives" if accordingtofederallawifthepresid!=""
*tab kn_presdies, mis

gen kn_override = whatpercentagevoteofthehouseandt == "Two-thirds" if whatpercentagevoteofthehouseandt!=""
*tab kn_override, mis


*POLITICAL PARTICIPATION QUESTIONS

*Voter registration: yes (1), no (0)
recode wereyouregisteredtovoteinthe2008 (1=1) (2=0)
gen par_reg2008 = wereyouregisteredtovoteinthe2008
replace par_reg2008 = 0 if par_reg2008 == -9 /*here we're taking all missing values as 'not registered'*/
tab par_reg2008, mis
gen dem_voteregister = par_reg2008

*Voted in 2008: did not vote (1), on election day (2), in person early (3), absentee (4), not sure (5)
gen par_vote = whichoneofthefollowingbestdescri
replace par_vote=1 if wereyouregisteredtovoteinthe2008==0
tab par_vote , mis
gen dem_voteturnout = par_vote
recode dem_voteturnout (1=0) (2=1) (3=1) (4=1) (5=1) (6=.)
tab dem_voteturnout, mis


*OTHER PARTICIPATION QUESTIONS
replace timesperweekonaverage = "0" if timesperweekonaverage == "0 total"
replace timesperweekonaverage = ".5" if timesperweekonaverage == "0-1"
gen opar_religwk = real(timesperweekonaverage) 
*replace opar_religwk = -9 if opar_religwk == .
*tab opar_religwk, mis


replace timespermonthonaverage = "0" if timespermonthonaverage == "0 total"
replace timespermonthonaverage = ".5" if timespermonthonaverage == "0-1"
gen opar_religmnth = real(timespermonthonaverage) 
*replace opar_religmnth = -9 if opar_religmnth ==.
*tab opar_religmnth, mis

replace timestotalduringthepast12months = "0" if timestotalduringthepast12months == "0 total"
replace timestotalduringthepast12months = "3.5" if timestotalduringthepast12months == "3 or 4"
replace timestotalduringthepast12months = "0" if timestotalduringthepast12months == "never"
gen opar_religtotal = real(timestotalduringthepast12months)
*replace opar_religtotal = -9 if opar_religtotal ==.
*tab opar_religtotal, mis


*POLICY QUESTIONS
gen pol_marriage = doyoufavoropposeorneitherfavorno
recode pol_marriage (1=1) (2=0) (3=.5)
*tab pol_marriage

gen pol_taxover = v60
recode pol_taxover  (1=1) (2=0) (3=.5)
*tab pol_taxover

gen pol_taxunder = v61
recode pol_taxunder (1=1) (2=0) (3=.5)
*tab pol_taxunder

gen pol_prescripseniors = v62
recode pol_prescripseniors (1=1) (2=0) (3=.5)
*tab pol_prescripseniors

gen pol_allmedical = v63
recode pol_allmedical (1=1) (2=0) (3=.5)
*tab pol_allmedical

gen pol_immigrants = v64
recode pol_immigrants (1=1) (2=0) (3=.5)
*tab pol_immigrants

**WELFARE EXPERIMENT
recode welfare_response (8=.) (9=.)

*******PARTY ID QUESTIONS

*0= Democrat, 1= Republican, 2= Other.
*tab generallyspeakingdoyouusuallythi
gen id_party3 = real(generallyspeakingdoyouusuallythi)
tab id_party3, mis
recode id_party3 (1=0) (2=1) (3=2)

gen id_party = .
replace id_party = 7 if wouldyoucallyourselfastrongrepub == 1
replace id_party = 6 if wouldyoucallyourselfastrongrepub == 2
replace id_party = 5 if doyouthinkofyourselfasclosertoth == 1
replace id_party = 4 if doyouthinkofyourselfasclosertoth == 3
replace id_party = 3 if doyouthinkofyourselfasclosertoth == 2
replace id_party = 2 if wouldyoucallyourselfastrongdemoc == 2
replace id_party = 1 if wouldyoucallyourselfastrongdemoc == 1


*0= disapprove, 1=approve
recode doyouapprovedisapproveorneithera (1=1) (2=0) (3=.5)
gen id_approval3 = doyouapprovedisapproveorneithera
*tab id_approval3, mis

gen id_approve = .
replace id_approve = 7 if doyouapproveextremelystrongly == 1
replace id_approve = 6 if doyouapproveextremelystrongly == 2
replace id_approve = 5 if doyouapproveextremelystrongly == 3
replace id_approve = 4 if doyouapprovedisapproveorneithera == 3
replace id_approve = 3 if doyoudisapproveextremelystrongly == 3
replace id_approve = 2 if doyoudisapproveextremelystrongly == 2
replace id_approve = 1 if doyoudisapproveextremelystrongly == 1

*Ideology goes from 1 (very liberal) to 7 (very conservative)

g id_ideology = 7 if whenitcomestopoliticswouldyoudes==2 & wouldyoucallyourselfveryconserva == 1
replace id_ideology = 6 if whenitcomestopoliticswouldyoudes==2 & wouldyoucallyourselfveryconserva == 2
replace id_ideology = 5 if whenitcomestopoliticswouldyoudes==3 & doyouthinkofyourselfasclosertoto== 2
replace id_ideology = 4 if whenitcomestopoliticswouldyoudes==3 & doyouthinkofyourselfasclosertoto == 3
replace id_ideology = 3 if whenitcomestopoliticswouldyoudes==3 & doyouthinkofyourselfasclosertoto== 1
replace id_ideology = 2 if whenitcomestopoliticswouldyoudes==1 & wouldyoucallyourselfveryliberalo == 2
replace id_ideology = 1 if whenitcomestopoliticswouldyoudes==1 & wouldyoucallyourselfveryliberalo == 1
*tab whenitcomestopoliticswouldyoudes 
*tab wouldyoucallyourselfveryliberalo 
*tab wouldyoucallyourselfveryconserva, nolabel
*tab id_ideo

*FLU VACCINE

recode howconfidentareyouthattheswinefl (1=1) (2=.66) (3=.33) (4=0) (9=9)
gen id_flu = howconfidentareyouthattheswinefl
*tab id_flu, mis

*EDUCATION

recode whatishighestdegreeorlevelofscho (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7) (9=8) (10=9) (11=10) (12=11) (13=12) (14=13)
gen dem_educ_uncoded = whatishighestdegreeorlevelofscho 
*tab dem_educ_uncoded, mis

recode whatishighestdegreeorlevelofscho (0=0) (1=3) (2= 5.5) (3=7.5) (4=9) (5=10) (6=11) (7=11.5) (8=12) (9=13) (10=14) (11=16) (12=18) (13=20)
gen dem_educ_years = whatishighestdegreeorlevelofscho
*tab dem_educ_years, mis


*DEMOGRAPHICS

*male= 0, female = 1
gen dem_gender = female
*tab dem_gender, mis

* own home= 1, rent home = 0.
gen dem_ownhome = real(doyouownyourhomerentyourhomeorha)
recode dem_ownhome (1=1) (2=0) 
*tab dem_ownhome, mis

*Hispanic/not binary variable: not Hispanic = 0, Hispanic =1 (any type)
gen dem_hispanic_bin = areyouofspanishhispanicorlatinod
recode dem_hispanic_bin (1=0) (2=1) (3=1) (4=1) (5=1) (6=1) (7=1) (8=1)
*tab dem_hispanic_bin

*Hispanic type non-binary variable: not Hispanic =0, Mexican=1, Puerto Rican=2, Cuban=3, Central American=4, South American=5, Caribbean=6, Other Hispanic/Latino=7
gen dem_hispanic_type = areyouofspanishhispanicorlatinod
recode dem_hispanic_type (1=0) (2=1) (3=2) (4=3) (5=4) (6=5) (7=6) (8=7)
*tab dem_hispanic_type

*White = 1, black = 0, other = 9
gen dem_race = pleasecheckoneormorecategoriesbe
replace dem_race = 9 if v94 == "Other"
replace dem_race = 0 if v93 == 2

gen dem_hispanic = 0
replace dem_hispanic = 1 if areyouofspanishhispanicorlatinod!=1

*Married = 1, never married = 2, divorced=3, separated=4, widowed=5
gen dem_marital = areyounowmarriedwidoweddivorceds
recode dem_marital (1=1) (2=5) (3=2) (4=3) (5=4)

*living with a partner = 1, not living with a partner = 0
gen dem_cohabit = areyounowlivingwithapartner
recode dem_cohabit (1=1) (2=0)
replace dem_cohabit = 0 if dem_marital == 1
*tab dem_cohabit, mis

*year of birth-- continuous
replace whatyearwereyouborn = "." if whatyearwereyouborn == "196"
replace whatyearwereyouborn = "." if whatyearwereyouborn == "68"
replace whatyearwereyouborn = "." if whatyearwereyouborn == "Carlifornia"
gen dem_birthyear = real(whatyearwereyouborn)
replace dem_birthyear = -9 if dem_birthyear ==.
*tab dem_birthyear, mis

gen dem_age = 2008 - dem_birthyear if dem_birthyear > 0
replace dem_age = 63 if dem_age == 1945

***NESTING VARIABLE ISSUES***

*religious preference: Protestant=1, Catholic=2, Jewish=3, Other=4, no religion=5
gen dem_religpref = whatisyourreligiouspreferenceisi
recode dem_religpref (1=1) (2=2) (3=3) (4=4) (5=0)
*tab dem_religpref, mis


**** ECONOMIC ASSESSMENTS
*tab weareinterestedinhowpeopleareget 

replace weareinterestedinhowpeopleareget = "0" if weareinterestedinhowpeopleareget == "Worse"
replace weareinterestedinhowpeopleareget = ".5" if weareinterestedinhowpeopleareget == "Same"
replace weareinterestedinhowpeopleareget = "1" if weareinterestedinhowpeopleareget == "Better now"
replace weareinterestedinhowpeopleareget = "." if weareinterestedinhowpeopleareget == "Don't know"
gen econ_todayvslastyear = real(weareinterestedinhowpeopleareget) 
*tab econ_todayvslastyear, mis

replace nowlookingaheaddoyouthinkthataye = "0" if  nowlookingaheaddoyouthinkthataye == "Will be worse off"
replace nowlookingaheaddoyouthinkthataye = ".5" if  nowlookingaheaddoyouthinkthataye == "Same"
replace nowlookingaheaddoyouthinkthataye = "1" if  nowlookingaheaddoyouthinkthataye == "Will be better off"
replace nowlookingaheaddoyouthinkthataye = "." if nowlookingaheaddoyouthinkthataye == "Don't know"
gen econ_todayvsnextyear = real(nowlookingaheaddoyouthinkthataye) 
*tab econ_todayvsnextyear, mis


gen econ_country = .
replace econ_country = 7 if muchbetterorsomewhatbetter  == 1
replace econ_country = 6 if muchbetterorsomewhatbetter == 2
replace econ_country = 5 if nowthinkingabouttheeconomyinthec  == 1
replace econ_country = 4 if nowthinkingabouttheeconomyinthec  == 2
replace econ_country = 3 if nowthinkingabouttheeconomyinthec  == 3
replace econ_country = 2 if  muchworseorsomewhatworse == 2
replace econ_country = 1 if  muchworseorsomewhatworse == 1



replace nowturningtobusinessconditionsin = "1" if nowturningtobusinessconditionsin == "Bad times"
replace nowturningtobusinessconditionsin = "2" if nowturningtobusinessconditionsin == "Bad with qualifications"
replace nowturningtobusinessconditionsin = "3" if nowturningtobusinessconditionsin == "Pro-Con"
replace nowturningtobusinessconditionsin = "4" if nowturningtobusinessconditionsin == "Good with qualifications"
replace nowturningtobusinessconditionsin = "5" if nowturningtobusinessconditionsin == "Good times"
replace nowturningtobusinessconditionsin = "." if nowturningtobusinessconditionsin == "Don't know"
gen econ_businesswhole  = real(nowturningtobusinessconditionsin) 
*tab econ_businesswhole , mis

gen econ_lookingahead = ics_4
recode econ_lookingahead (1=5) (2=4) (3=3) (4=2) (5=1) (6=.)
*tab econ_lookingahead, mis

replace thinkingaboutthebigthingspeopleb = "0" if thinkingaboutthebigthingspeopleb == "Bad"
replace thinkingaboutthebigthingspeopleb = ".5" if thinkingaboutthebigthingspeopleb == "Pro-Con"
replace thinkingaboutthebigthingspeopleb = "1" if thinkingaboutthebigthingspeopleb == "Good"
replace thinkingaboutthebigthingspeopleb = "." if thinkingaboutthebigthingspeopleb == "Don't know"
gen econ_buying  = real(thinkingaboutthebigthingspeopleb) 
*tab econ_buying, mis

****Income Coding****

gen income = 2500 if v100 == 1 
replace income = 6250 if v100 == 2
replace income = 8750 if v100 == 3
replace income = 11250 if v100 == 4
replace income = 13750 if v100 == 5
replace income = 17500 if v100 == 6
replace income = 37500 if v102 == 10
replace income = 45000 if v102 == 11
replace income = 55000 if v104 == 12
replace income = 67500 if v104 == 13
replace income = 80000 if v104 == 14
replace income = 92500 if v104 == 15
replace income = 112500 if v105 == 16
replace income = 137500 if v105 == 17
replace income = 142500 if v105 == 18
replace income = 142500 if v105 == 19
replace income = 27500 if wasit == 2
rename income dem_income


 
****VOCABULARY TEST
egen vocab_test = rmean(word*)

label define econ7 1 "Much Worse" 4 "Neither better nor worse" 7 "Much better"
label values econ_country

label define knowledge 1 Correct 0 Incorrect
for var kn_* : label values X knowledge

label define votevals 1 "Definitely did not vote" 2 "Voted in person at a polling place on election day" 3 "Voted early, in person at a polling place" 4 "Voted by mailing an absentee ballot" 5 "Voted in some other way" 6 "Not sure if you voted or not" 
label values par_vote votevals

label define favor_oppose 1 Favor 0 Oppose 
label values pol_marriage favor_oppose
label values pol_taxover favor_oppose
label values pol_taxunder favor_oppose
label values pol_prescripseniors favor_oppose
label values pol_allmedical favor_oppose
label values pol_immigrants favor_oppose

label define party3 0 Democrat 1 Republican 2 Independent
label values id_party3 party3

label define partylist 1 "Strong Democrat" 2 "Moderate Democrat" 3 "Weak Democrat" 4 "Independent/Neither" 5 "Weak Republican" 6 "Moderate Republican" 7 "Strong Republican"
label values id_party partylist


label define app 1 Approve 0 Disapprove 
label values id_approval app

label define app7 1 "Strongly Approve" 2 "Moderately Approve" 3 "Weakly Approve" 4 "Neither Approve nor Disapprove" 5 "Weakly Disapprove" 6 "Moderately Disapprove" 7 "Strongly Disapprove"

label define vaccine 1 "Very confident" 0 "Not confident at all"
label values id_flu vaccine

label define ed 0 "None" 3 "7th-8th grade" 4 "9th grade" 5 "10th grade" 6 "11th grade" 7 "12th grade NO DIPLOMA" 8 "High school graduate" 9 "Some college, no degree" 10 "Associate's degree" 11 "Bachelor's degree" 12 "Master's degree" 13 "Professional or Doctorate degree"
label values dem_educ_uncoded ed

label define sex 0 "Male" 1 "Female"
label values dem_gender sex

label define res 1 "Own home" 0 "Rent home"
label values dem_ownhome res

label define hisb 1 "Hispanic" 0 "Not Hispanic"
label values dem_hispanic_bin hisb

label define hist 0 "Not Hispanic" 1 "Mexican" 2 "Puerto Rican" 3 "Cuban" 4 "Central American" 5 "South American" 6 "Carribbean" 7 "Other Hispanic/Latino"
label values dem_hispanic_type hist

label define wed 1 "Married" 2 "Divorced" 3 "Separated" 4 "Never Married" 5 "Widowed"
label values dem_marital wed

label define roommate 1 "Living with a partner" 0 "Not living with a partner"
label values dem_cohabit roommate

label define rel 1 "Protestant" 2 "Catholic" 3 "Jewish" 4 "Other" 0 "No Religion"
label values dem_religpref rel

label define wel 1 "Too Little" 2 "About Right" 3 "Too Much"
label values welfare_response wel

label define interest 1 "Extremely interested" 2 "Very interested" 3 "Moderately interested" 4 "Slightly interested" 5 "Not interested at all"
label values in_govt interest

label define ideology7 1 "Very liberal" 2 "Somewhat liberal" 3 "Slightly liberal" 4 "Moderate" 5 "Slightly conservative" 6 "Somewhat conservative" 7 "Very conservative"
label values id_ideology ideology7

label define bizcon 1 "Bad times" 2 "Bad with qualifications" 3 "Pro-Con" 4 "Good with qualifications" 5 "Good"
label values econ_businesswhole bizcon
label values econ_lookingahead bizcon

labe define bigthings 0 "Bad" 1 "Good"
label values econ_buying bigthings

labe define econ_todayvslastyear 0 "Worse"  1 "Better"
label values econ_todayvslastyear econ_todayvslastyear 
label values econ_todayvsnextyear econ_todayvslastyear 

label variable id_approval3 "Obama approval"
label variable id_approval "Obama approval"

rename v3 IP
rename v4 start
rename v5 finish

*combine
gen study = 2

compress

*tab country female, col
keep if country == "United States"
drop if dem_age == 16

*REGION
gen dem_region = 1 if v11 == "Connecticut"
replace dem_region = 1 if v10 == "Maine"
replace dem_region = 1 if v10 == "Massachusetts"
replace dem_region = 1 if v10 == "New Hampshire"
replace dem_region = 1 if v10 == "Rhode Island"
replace dem_region = 1 if v10 == "Vermont"
replace dem_region = 1 if v10 == "New Jersey"
replace dem_region = 1 if v10 == "New York"
replace dem_region = 1 if v10 == "Pennsylvania"
replace dem_region = 2 if v10 == "Illinois"
replace dem_region = 2 if v10 == "Indiana"
replace dem_region = 2 if v10 == "Iowa"
replace dem_region = 2 if v10 == "Kansas"
replace dem_region = 2 if v10 == "Michigan"
replace dem_region = 2 if v10 == "Minnesota"
replace dem_region = 2 if v10 == "Missouri"
replace dem_region = 2 if v10 == "Nebraska"
replace dem_region = 2 if v10 == "North Dakota"
replace dem_region = 2 if v10 == "Ohio"
replace dem_region = 2 if v10 == "South Dakota"
replace dem_region = 2 if v10 == "Wisconsin"
replace dem_region = 3 if v10 == "Florida"
replace dem_region = 3 if v10 == "Georgia"
replace dem_region = 3 if v10 == "Maryland"
replace dem_region = 3 if v10 == "North Carolina"
replace dem_region = 3 if v10 == "South Carolina"
replace dem_region = 3 if v10 == "Virginia"
replace dem_region = 3 if v10 == "West Virginia"
replace dem_region = 3 if v10 == "Delaware"
replace dem_region = 3 if v10 == "Alabama"
replace dem_region = 3 if v10 == "Kentucky"
replace dem_region = 3 if v10 == "Mississippi"
replace dem_region = 3 if v10 == "Tennessee"
replace dem_region = 3 if v10 == "Arkansas"
replace dem_region = 3 if v10 == "Louisiana"
replace dem_region = 3 if v10 == "Oklahoma"
replace dem_region = 3 if v10 == "Texas"
replace dem_region = 3 if v10 == "District of Columbia"
replace dem_region = 4 if v10 == "Montana"
replace dem_region = 4 if v10 == "Wyoming"
replace dem_region = 4 if v10 == "Colorado"
replace dem_region = 4 if v10 == "New Mexico"
replace dem_region = 4 if v10 == "Idaho"
replace dem_region = 4 if v10 == "Montana"
replace dem_region = 4 if v10 == "Utah"
replace dem_region = 4 if v10 == "Arizona"
replace dem_region = 4 if v10 == "Nevada"
replace dem_region = 4 if v10 == "Washington"
replace dem_region = 4 if v10 == "Oregon"
replace dem_region = 4 if v10 == "California"
replace dem_region = 4 if v10 == "Alaska"
replace dem_region = 4 if v10 == "Hawaii" 

append using "ANES_panel_coded.dta"
append using "ANES_ftf_coded.dta"
append using "Kam_NFCNTE.dta"
append using "cps_for_merge.dta"
append using "cps2_for_merge.dta"
*variable labels in table
label define study_label 1 "NES_P" 2 MTurk 3 "NES_F" 4 Kam 5 CPS 6 CPSIncome
label values study study_label

*generate mean political knowledge
by study, sort:sum  kn_presdies kn_override kn_presterms kn_senterm kn_numsens kn_houseterm 
gen kn_mean = kn_presterms+kn_senterm+kn_numsens+kn_houseterm


*set survey weights for face-to-face (not for panel)
sum v080101 
replace v080101 = 1 if v080101 ==.
*svyset [pw = v080101 ]   
tab study
replace in_gov=(6-in_gov)
*combined weight
 g weight = 1
 replace weight =v080101 if study == 3
 replace weight =PWSSWGT if study == 5
 *use household weight for CPS income
 replace weight = HWHHWGT if study == 6

svyset [pw=weight]

*****END CODING*********
XXXXXXXXXXXXXXXXXXXXXXX





*****ANALYSIS*********


****TABLE 1****
*not generated by STATA


****TABLE 2****
*columns 2-5 from other papers
*column 1: no weights, as this is MTurk data

*Gender
proportion dem_gender if study==2
*Age
mean dem_age  if study==2
*Education Years
mean dem_educ_years if study==2
*Race
proportion dem_race if study==2
proportion dem_hispanic if study==2
*Party ID
recode id_party (1/2= 1) (6/7 = 3) (3/5= 2) (. = 4), gen(PID_4)
proportion PID_4 if study==2

*check sample sizes for each study, put range into table N
  sum  dem_gender dem_age dem_educ_years dem_race dem_hispanic id_party3 if study == 2 /*MT*/

****TABLE 3****
*Gender
svy: proportion dem_gender, over(study) /* weights*/
*Education Years
 *Fix a coding error here - a 24 year old in the 2008 ANES who was likely erroneously coded as 'no education'.
  recode dem_educ_uncoded (1=.) 
svy: mean dem_educ_years, over(study) 
svy: mean dem_education_anesps 
svy: mean dem_education_cps
svy: mean dem_education_anesftf
*Age
svy: mean dem_age, over(study)
svy: mean dem_age_anesps
svy: mean dem_age_cps
svy: mean dem_age_anesftf
*Mean Income
svy: mean dem_income
svy: mean dem_income_anesps
svy: mean dem_income_cps
svy: mean dem_income_anesftf 
*Median Income 
summarize dem_income, detail 
summarize dem_income_anesps, detail
summarize dem_income_cps [aw=weight], detail
summarize dem_income_anesftf [aw=weight], detail
*Race
svy: proportion dem_race, over(study) 
svy: proportion dem_race_cps
svy: proportion dem_hispanic, over(study)
*Marital Status
svy: proportion dem_marital, over(study)
*Housing Status
svy: proportion dem_ownhome, over(study)
*Religion
svy: proportion dem_religpref, over(study) 
 *by study, sort:tab dem_religpref
*Region
svy: proportion dem_region
svy: proportion dem_region_anesps
svy: proportion dem_region_cps
svy: proportion dem_region_anesftf

*check sample sizes for each study, put range into table N
  sum  dem_gender dem_education_anesps  dem_age_anesps if study == 1 /*NESPS*/
  sum  dem_gender dem_educ_years dem_age if study == 2 /*MT*/
  sum  dem_gender dem_education_anesftf  dem_age_anesftf if study == 3 /*NESFTF*/
  sum  dem_gender dem_education_cps  dem_age_cps if study == 5 /*CPS*/


****TABLE 4****

**Registered**
svy: proportion dem_voteregister, over(study)
*Turnout
svy: proportion dem_voteturnout, over(study)
*Party ID
svy: mean id_party, over(study)
*Ideology
svy: mean id_ideology, over(study)
*Political interest
svy: mean in_govt, over(study)
*Political knowledge, succession
svy: mean kn_presdies, over(study)
*Political knowledge, override
svy: mean kn_override, over(study)
*Political knowledge, pres terms
svy: mean kn_presterms, over(study)
*Political knowledge, senate term length
svy: mean kn_senterm, over(study)
*Political knowledge, number senators
svy: mean kn_numsens, over(study)
*Political knowledge, house term length
svy: mean kn_houseterm, over(study)
*Need for cognition
svy: mean kam_NFC
svy: mean dem_NFC_anesps 
svy: mean dem_NFC_anesftf
*Need to evaluate
svy: mean kam_NTE
svy: mean dem_NTE_anesps
svy: mean dem_NTE_anesftf

*check sample sizes for each study, put range into table N
*NES PS
  sum  dem_voteregister dem_voteturnout id_party id_ideology in_govt kn_presdies kn_override kn_presterms kn_senterm kn_numsens kn_houseterm dem_NFC_anesps dem_NTE_anesps if study == 1 
*Mechanical Turk
  sum  dem_voteregister dem_voteturnout id_party id_ideology in_govt kn_presdies kn_override kn_presterms kn_senterm kn_numsens kn_houseterm kam_NFC kam_NTE if study == 2
*NES FTF
  sum  dem_voteregister dem_voteturnout id_party id_ideology in_govt kn_presdies kn_override kn_presterms kn_senterm kn_numsens kn_houseterm dem_NFC_anesftf dem_NTE_anesftf if study == 3
*CPS
  sum  dem_voteregister dem_voteturnout id_party id_ideology in_govt kn_presdies kn_override kn_presterms kn_senterm kn_numsens kn_houseterm if study == 5



****TABLE 5****
*Prescription drug benefit
svy: proportion pol_prescripseniors, over(study)
*Universal healthcare
svy: proportion pol_allmedical, over(study)
*Citizenship for illegals
svy: proportion pol_immigrants, over(study)
*Ban gay marriage?
svy: proportion pol_marriage, over(study)
*Raise taxes on big earners
svy: proportion pol_taxover, over(study)
*Raise taxes on small earners
svy: proportion pol_taxunder, over(study)

*check sample sizes for each study, put range into table N
*NES PS
   sum pol_prescripseniors pol_allmedical pol_immigrants pol_marriage pol_taxover pol_taxunder if study==1
*MT
   sum pol_prescripseniors pol_allmedical pol_immigrants pol_marriage pol_taxover pol_taxunder if study==2
*NES FTF
   sum pol_prescripseniors pol_allmedical pol_immigrants pol_marriage pol_taxover pol_taxunder if study==3
*CPS
   sum pol_prescripseniors pol_allmedical pol_immigrants pol_marriage pol_taxover pol_taxunder if study==5


   
   
   


*******FIGURE 1***********

*Now, a combined kdensity plot for income
*DEM_INCOME_CPS was broken
kdensity dem_income_anesftf [aw = v080101], lcolor(white) yt("") note("") yl(,nogrid nolabels noticks) scheme(lean2) xt(" ") ti("Income", size(medsmall)) legend(off) bw(15000) xl(0(50000)150000) addplot(kdensity dem_income, clpattern(solid) clwidth(medthick) bw(15000)|| kdensity dem_income_anesps, bw(15000)|| kdensity dem_income_cps [aw=HWHHWGT], bw(15000) lpattern(shortdash_dot) || kdensity dem_income_anesftf [aw = v080101], bw(15000))

graph save income_kdensity, replace	

*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*Combined kdensity for age
kdensity dem_age_anesftf [aw = v080101], lcolor(white)  yt("") note("") yl(,nogrid nolabels noticks) scheme(lean2) xt("Years") ti("Age", size(medsmall)) legend(off) addplot(kdensity dem_age, clpattern(solid) clwidth(medthick) ||kdensity dem_age_anesps|| kdensity dem_age_cps [aw=PWSSWGT], lpattern(shortdash_dot)  || kdensity dem_age_anesftf [aw = v080101])
graph save age_kdensity, replace

*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*Combined kdensity for education
kdensity dem_education_anesftf [aw = v080101 ], lcolor(white) note("") yt("") yl(,nogrid nolabels noticks) scheme(lean2) xt("Years") ti("Education",size(medsmall)) bw(1) legend(label(2 "Mechanical Turk")) legend(label(3 "ANES Panel"))  legend(label(4 "CPS")) legend(label(5 "ANES Face to Face")) addplot(kdensity dem_educ_years,  clpattern(solid) clwidth(medthick) bw(1)|| kdensity dem_education_anesps, bw(1) || kdensity dem_education_cps [aw=PWSSWGT], bw(1) lpattern(shortdash_dot)  || kdensity dem_education_anesftf [aw = v080101 ], bw(1) )
graph save education_kdensity, replace


******FIGURE 2***********

*combined kdensity plot for NFC

kdensity dem_NFC_anesftf [aw = v080101], lcolor(white) yt("") note("") yl(,nogrid nolabels noticks) scheme(lean2) xt(" ") ti("Need for Cognition", size(medsmall)) bw(.1) legend(off) addplot( kdensity kam_NFC, bw(.1) clpattern(solid) clwidth(medthick) ||kdensity dem_NFC_anesps, bw(.1) || kdensity dem_NFC_anesftf [aw = v080101], bw(.1))
graph save nfc_kdensity, replace

*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

*Now, a combined kdensity plot for NTE

kdensity dem_NTE_anesftf [aw = v080101], lcolor(white) yt("") note("") yl(,nogrid nolabels noticks) scheme(lean2) xt(" ") ti("Need to Evaluate", size(medsmall)) bw(.1) legend(off) addplot( kdensity kam_NTE, bw(.1)  clpattern(solid) clwidth(medthick)||kdensity dem_NTE_anesps, bw(.1)||kdensity dem_NTE_anesftf [aw = v080101], bw(.1))
graph save nte_kdensity, replace

*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

*Kdensity for partyID
*use id_party

kdensity id_party if study==3 [aw = v080101], legend(label(2 "Mechanical Turk")) legend(label(3 "ANES Panel"))  legend(label(4 "ANES Face to Face"))  lcolor(white) xlabel(1 "Str. Dem." 2 " " 3 " " 4 "Ind." 5 " " 6 " " 7 "Str. Rep.") scheme(lean2) note("") yt("") yl(,nogrid nolabels noticks) xt(" ") ti("Party ID", size(medsmall)) bw(1) addplot(kdensity id_party if study == 2,  clpattern(solid) clwidth(medthick) bw(1) ||kdensity id_party if study == 1, bw(1)  || kdensity id_party if study==3 [aw = v080101 ],bw(1))
graph save partyid_kdensity, replace


*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*Kdensity for political interest
*use in_gov
kdensity in_gov if study==3 [aw = v080101], lcolor(white) note("") yt("") xt(" ") xl(1 "No Int." 2 " " 3 "Mod. Int." 4 " " 5 "Ext. Int." ) yl(,nogrid nolabels noticks) scheme(lean2) xt( ) ti("Political Interest", size(medsmall)) legend(off) bw(1) addplot(kdensity in_gov if study == 2,  clpattern(solid) clwidth(medthick) bw(1)|| kdensity in_gov if study == 1, bw(1)  ||kdensity in_gov if study==3 [aw = v080101 ], bw(1))
graph save ingov_kdensity, replace

*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*Kdensity for kn_mean
*use kn_mean

kdensity kn_mean if study==3 [aw = v080101], lcolor(white) note("") yt("") yl(,nogrid nolabels noticks) scheme(lean2) xt(# Correct) ti("Political Knowledge", size(medsmall)) legend(off) bw(1) addplot( kdensity kn_mean if study == 2,  clpattern(solid) clwidth(medthick) bw(1)||kdensity kn_mean if study == 1, bw(1) ||kdensity kn_mean if study==3 [aw = v080101], bw(1))
graph save know_kdensity, replace

*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*Kdensity for ideology
*use id_ideology

kdensity id_ideology if study==3 [aw = v080101], lcolor(white) legend(off)  xlabel(1 "Str. Lib." 2 " " 3 " " 4 "Ind." 5 " " 6 " " 7 "Str. Con.")  note("") yt("") yl(,nogrid nolabels noticks) scheme(lean2) xt(" ") ti("Ideology", size(medsmall)) bw(1) addplot( kdensity id_ideology if study == 2,  clpattern(solid) clwidth(medthick) bw(1) ||kdensity id_ideology if study == 1, bw(1)  ||kdensity id_ideology if study==3 [aw = v080101],  bw(1))
graph save ideology_kdensity, replace

*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*Combined kdensity for education - NO LEGEND - this we generate solely for photoshop purposes
kdensity dem_education_anesftf [aw = v080101 ], lcolor(white) note("") yt("") yl(,nogrid nolabels noticks) scheme(lean2) xt("Years") ti("Education",size(medsmall)) bw(1) legend(off) addplot(kdensity dem_educ_years,  clpattern(solid) clwidth(medthick) bw(1)|| kdensity dem_education_anesps, bw(1) || kdensity dem_education_cps [aw=PWSSWGT], lpattern(shortdash_dot)  bw(1) || kdensity dem_education_anesftf [aw = v080101 ], bw(1) )
graph save education_kdensity2, replace

*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*Kdensity for partyID - NO LEGEND - this we generate solely for photoshop purposes
*use id_party

kdensity id_party if study==3 [aw = v080101], legend(off)  lcolor(white) xlabel(1 "Str. Dem." 2 " " 3 " " 4 "Ind." 5 " " 6 " " 7 "Str. Rep.") scheme(lean2) note("") yt("") yl(,nogrid nolabels noticks) xt(" ") ti("Party ID", size(medsmall)) bw(1) addplot(kdensity id_party if study == 2,  clpattern(solid) clwidth(medthick) bw(1) ||kdensity id_party if study == 1, bw(1)  || kdensity id_party if study==3 [aw = v080101 ],bw(1))
graph save partyid_kdensity2, replace



*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*******FIGURE ASSEMBLY (FIGURES 1 + 2)***********
*Combine all the kdensity plots and generate an Encapsulated Postscript

gr combine education_kdensity.gph age_kdensity.gph  income_kdensity.gph, xsize(6.5) ysize(10) graphregion(color(white))
graph save combined1_kdensity, replace 
graph export combined1_kdensity_legend.eps, replace

gr combine partyid_kdensity.gph ideology_kdensity.gph ingov_kdensity.gph know_kdensity.gph nfc_kdensity.gph nte_kdensity.gph, cols(2) xsize(6.5) ysize(10)  graphregion(color(white))
graph save combined2_kdensity, replace
graph export combined2_kdensity_legend.eps, replace

*The below graphs are slightly different for photoshop purposes but should contain the same information

gr combine education_kdensity2.gph age_kdensity.gph  income_kdensity.gph, xsize(6.5) ysize(10) graphregion(color(white))
graph save combined1_kdensity_nolegend, replace
graph export combined1_kdensity_nolegend.eps, replace 

gr combine partyid_kdensity2.gph ideology_kdensity.gph ingov_kdensity.gph know_kdensity.gph nfc_kdensity.gph nte_kdensity.gph, cols(2) xsize(6.5) ysize(10) graphregion(color(white))
graph save combined2_kdensity_nolegend, replace 
graph export combined2_kdensity_nolegend.eps, replace 





