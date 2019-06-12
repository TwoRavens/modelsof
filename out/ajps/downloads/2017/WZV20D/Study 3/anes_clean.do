* This file cleans the 2008-2009 ANES Panel dataset for use in Study 3 of Ryan,
* "How Do Indifferent Voters Decide" (AJPS). Analysis was conducted on 
* Stata/SE 14.2 for Mac (64-bit Intel).

clear all
set more off

use "anes2008_2009panel_dataset.dta", clear
drop if w9flag==0 & w10flag==0 // Waves 9 and 10 have required measures, so a respondent will be unusable if he/she missed both of them.

** Gender
gen female = 0
replace female = 1 if der01==2

** Education
gen educ2 = der05
replace educ2 = . if der05==-6
replace educ2 = . if der05==-2
gen educ = (educ2-1)/4
replace educ2 = educ2 - 1
lab def educ2 0 "No HS" 1 "Diploma" 2 "Some col" 3 "BA" 4 "Adv. Degree"
lab val educ2 educ2

* Age
rename der02 age

** Race
gen white = 0
replace white = 1 if der04==1

gen black = 0
replace black = 1 if der04==2

gen hispanic = 0
replace hispanic = 1 if der04==3

** Income
gen income2 = der06
replace income2 = . if der06==-6
replace income2 = . if der06==-2
gen income = (income2-1)/18

** Region
* The goal of this section is to create a categorical variable for respondent's region. (Four levels, reflecting residency in the Northeast, North central, South, or West.) This is a little tricky. The best source are ANES summary variables for respondent's state. But these are not available for all respondents. An alternative is to use the variable (cdstate) capturing the state of the respondent's congressional district. The approach below is: 
* 1) Code state according to the inferior (cdstate) measure and then
* 2) Replace the inferior information with superior information if it is available.

* Step 1: cdstate approach. A difficulty in step 1 is that the values used for cdstate do not correspond to the values used in the summary variables coming up in step 2. For instance, Maine is coded as 11 in cdstate, but as 21 in the summary variables coming up. So the code below manually makes the coding consistent.

gen state = .
replace state = 21 if cdstate==11
replace state = 31 if cdstate==12
replace state = 47 if cdstate==13
replace state = 23 if cdstate==14
replace state = 41 if cdstate==15
replace state = 8 if cdstate==16
replace state = 34 if cdstate==21
replace state = 32 if cdstate==22
replace state = 40 if cdstate==23
replace state = 37 if cdstate==31
replace state = 16 if cdstate==32
replace state = 15 if cdstate==33
replace state = 24 if cdstate==34
replace state = 51 if cdstate==35
replace state = 25 if cdstate==41
replace state = 17 if cdstate==42
replace state = 27 if cdstate==43
replace state = 36 if cdstate==44
replace state = 43 if cdstate==45
replace state = 29 if cdstate==46
replace state = 18 if cdstate==47
replace state = 9 if cdstate==51
replace state = 22 if cdstate==52
replace state = 10 if cdstate==53
replace state = 48 if cdstate==54
replace state = 50 if cdstate==55
replace state = 35 if cdstate==56
replace state = 42 if cdstate==57
replace state = 12 if cdstate==58
replace state = 11 if cdstate==59
replace state = 19 if cdstate==61
replace state = 44 if cdstate==62
replace state = 2 if cdstate==63
replace state = 26 if cdstate==64
replace state = 5 if cdstate==71
replace state = 20 if cdstate==72
replace state = 38 if cdstate==73
replace state = 45 if cdstate==74
replace state = 28 if cdstate==81
replace state = 14 if cdstate==82
replace state = 52 if cdstate==83
replace state = 7 if cdstate==84
replace state = 33 if cdstate==85
replace state = 4 if cdstate==86
replace state = 46 if cdstate==87
replace state = 30 if cdstate==88
replace state = 49 if cdstate==91
replace state = 39 if cdstate==92
replace state = 6 if cdstate==93
replace state = 3 if cdstate==94
replace state = 13 if cdstate==95

* Step 2: Replace the inferior information with the preferable information, if it is available. Here, we state with the measures most temporally distant from the election, and replace with more temporally proximal measures, if they are available.

replace state = w1b3_b3state if w1b3_b3state>0 & w1b3_b3state<53
replace state = w1y1 if w1y1>0 & w1y1<53
replace state = w1state if w1state>0 & w1state<53
replace state = w1b2b_b2state if w1b2b_b2state>0 & w1b2b_b2state<53
replace state = w2b2b_b2state if w2b2b_b2state>0 & w2b2b_b2state<53
replace state = w2b3_b3state if w2b3_b3state>0 & w2b3_b3state<53
replace state = w2state if w2state>0 & w2state<53
replace state = w2b2b_b2state if w2b2b_b2state>0 & w2b2b_b2state<53
replace state = w6b3_b3state if w6b3_b3state>0 & w6b3_b3state<53
replace state = w6b2b_b2state if w6b2b_b2state>0 & w6b2b_b2state<53
replace state = w9b3_b3state if w9b3_b3state>0 & w9b3_b3state<53
replace state = w9b2b_b2state if w9b2b_b2state>0 & w9b2b_b2state<53
replace state = w9zw1 if w9zw1>0 & w9zw1<53
replace state = w10zw1 if w10zw1>0 & w10zw1<53

* Construct summary region variable
gen region = .
* Northeast
replace region = 1 if state==8
replace region = 1 if state==21
replace region = 1 if state==23
replace region = 1 if state==31
replace region = 1 if state==32
replace region = 1 if state==34
replace region = 1 if state==40
replace region = 1 if state==41
replace region = 1 if state==47

* North central
replace region = 2 if state==15
replace region = 2 if state==16
replace region = 2 if state==17
replace region = 2 if state==18
replace region = 2 if state==24
replace region = 2 if state==25
replace region = 2 if state==27
replace region = 2 if state==29
replace region = 2 if state==36
replace region = 2 if state==43
replace region = 2 if state==37
replace region = 2 if state==51

* South 
replace region = 3 if state==2
replace region = 3 if state==11
replace region = 3 if state==12
replace region = 3 if state==20
replace region = 3 if state==26
replace region = 3 if state==35
replace region = 3 if state==42
replace region = 3 if state==44
replace region = 3 if state==45
replace region = 3 if state==48
replace region = 3 if state==5
replace region = 3 if state==9
replace region = 3 if state==10
replace region = 3 if state==19
replace region = 3 if state==22
replace region = 3 if state==38
replace region = 3 if state==50

* West
replace region = 4 if state==3
replace region = 4 if state==4
replace region = 4 if state==6
replace region = 4 if state==7
replace region = 4 if state==13
replace region = 4 if state==14
replace region = 4 if state==28
replace region = 4 if state==33
replace region = 4 if state==30
replace region = 4 if state==39
replace region = 4 if state==46
replace region = 4 if state==49
replace region = 4 if state==52

label define region 1 "Northeast" 2 "North Central" 3 "South" 4 "West"
label values region region

tab region

** Partisanship
gen pidr = .
foreach wave in w1 w19 w17 w11 w10 w9 { // Start with most temporally distant measures, and replace with measures proximal to the election if available.
	di "`wave'"
	replace pidr = 0 if der08`wave'==0
	replace pidr = 1 if der08`wave'==1
	replace pidr = 2 if der08`wave'==2
	replace pidr = 3 if der08`wave'==3
	replace pidr = 4 if der08`wave'==4
	replace pidr = 5 if der08`wave'==5
	replace pidr = 6 if der08`wave'==6
	}

rename pidr pid2

recode pid2 (0 6 = 3) (1 5 = 2) (2 4 = 1) (3 = 0), gen(pidstr2)
gen pidstr = pidstr2/3

*Ideology
recode der09w10 der09w11 (-7 -6 -5 = .)
gen rcons2 = der09w10 - 1 // Use Wave 10 if available
replace rcons2 = der09w11 - 1 if rcons2==. // Use Wave 11 if Wave 10 missing.
gen rcons = rcons2 / 6
gen ideolext = abs((rcons - .5) * 2)

** Explicit liking / disliking of Obama / McCain
gen w10mccainlike = .
replace w10mccainlike = 6 if w10e15==1
replace w10mccainlike = 5 if w10e15==2
replace w10mccainlike = 4 if w10e15==3
replace w10mccainlike = 3 if w10e14==3
replace w10mccainlike = 2 if w10e16==3
replace w10mccainlike = 1 if w10e16==2
replace w10mccainlike = 0 if w10e16==1

gen w10oblike = .
replace w10oblike = 6 if w10e39==1
replace w10oblike = 5 if w10e39==2
replace w10oblike = 4 if w10e39==3
replace w10oblike = 3 if w10e38==3
replace w10oblike = 2 if w10e40==3
replace w10oblike = 1 if w10e40==2
replace w10oblike = 0 if w10e40==1

gen w10mclike2 = w10mccainlike + 1 // Scale 1-6 for convenience
gen w10oblike2 = w10oblike + 1 // Scale 1-6 for convenience

replace w10mccainlike = w10mccainlike / 6
replace w10oblike = w10oblike / 6

gen w10mcobdif = w10mccainlike - w10oblike
gen explicit = -1*w10mcobdif // Code such that liking Obama takes high values
gen explicit2 = explicit * 6 // Synonym, rescaled, convenient for figures.


* OIA Categories - Main classification
* Intensity measure
gen intensity = abs(4-w10mclike2) + abs(4-w10oblike2)

* Categories
gen oiacat = .
replace oiacat = 1 if intensity<=2 & intensity!=.
replace oiacat = 0 if intensity>2 & intensity!=. & abs(explicit)>=.49 & explicit!=.
replace oiacat = 2 if intensity>2 & intensity!=. & abs(explicit)<.49 & explicit!=.
tab intensity oiacat // AOK

lab def oia 0 "One-sided" 1 "Indifferent" 2 "Ambivalent"
lab val oia* oia

* OIA Categories -- Alternative classification
gen ambiv = (w10mclike2+w10oblike2)/2 - abs(w10mclike2-w10oblike2)
gen oiacat_alt = .
replace oiacat_alt = 0 if ambiv<3.5 & ambiv!=.
replace oiacat_alt = 1 if ambiv>=3.5 & ambiv<=4.5
replace oiacat_alt = 2 if ambiv>4.5 & ambiv!=.

* OIA Categories -- Party-focus (for SI)
gen w10replike = .
replace w10replike = 6 if w10e6==1
replace w10replike = 5 if w10e6==2
replace w10replike = 4 if w10e6==3
replace w10replike = 3 if w10e5==3
replace w10replike = 2 if w10e7==3
replace w10replike = 1 if w10e7==2
replace w10replike = 0 if w10e7==1

gen w10demlike = .
replace w10demlike = 6 if w10e3==1
replace w10demlike = 5 if w10e3==2
replace w10demlike = 4 if w10e3==3
replace w10demlike = 3 if w10e2==3
replace w10demlike = 2 if w10e4==3
replace w10demlike = 1 if w10e4==2
replace w10demlike = 0 if w10e4==1

gen w10replike2 = w10replike + 1
gen w10demlike2 = w10demlike + 1

replace w10replike = w10replike / 6
replace w10demlike = w10demlike / 6

gen w10rddif = w10replike - w10demlike
gen explicit_party = -1*w10rddif
gen explicit2_party = round(6*explicit_p)

gen intensity2_party = abs(4-w10replike2) + abs(4-w10demlike2)

gen oiacat_party = .
replace oiacat_party = 1 if intensity2_party<=2 & intensity2_party!=.
replace oiacat_party = 0 if intensity2_party>2 & intensity2_party!=. & abs(explicit_party)>=.49 & explicit_party!=.
replace oiacat_party = 2 if intensity2_party>2 & intensity2_party!=. & abs(explicit_party)<.49 & explicit_party!=.
lab val oiacat_party oia

* Turnout
recode der15 (-2 = .) (1 = 1) (2 = 0), gen(voter)

** Vote choice
recode der16 (-7 -6 -2 -1 = .) (1 = 0) (2 = 1) (3 = .), gen(obvote) // Just Obama/McCain matchup.

** National evaluations
* Wave 9: Take existing variables (w9r1 - w9r12) and code them 0 - 1, with high values reflecting positive evaluations
foreach num of numlist 1/12 {
	recode w9r`num' (-7 -6 -5 = .) (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = 0), gen(w9state`num')
	replace w9state`num' = w9state`num'/4
	}

alpha w9state1-w9state12, gen(w9state)

	
* Wave 19: Similar to above, scale the variables from 0 = bad to 1 = good
foreach num of numlist 2/14 { // Start with #2 because there is no #1 (but see below)
	recode w19u`num' (-7 -6 -5 = .) (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = 0), gen(w19state`num')
	replace w19state`num' = w19state`num'/4
	}
* The "state of the economy" question, which would have been w19u1, was asked in a different form in Wave 19. Handle that manually:
gen econw19 = .
replace econw19 = 0 if w19v3==1
replace econw19 = 1 if w19v3==2
replace econw19 = 2 if w19v1==2
replace econw19 = 3 if w19v2==2
replace econw19 = 4 if w19v2==1
replace econw19 = econw19/4
gen w19state1 = econw19 // identical

alpha w19state1 w19state2-w19state14, gen(w19state)

** Political knowledge
* The knowledge questions were asked on Waves 2, 9, or 11, depending on respondent recruitment. I use the Wave 11 measures if available, and the earlier measures if not.

* Wave 11 measures:
recode w11wv1 (-6 -5 = .) (-7 2 3 4 = 0) (1 = 1), gen(knowl1) // mccain state
recode w11wv2 (-6 -5 = .) (-7 2 3 4 = 0) (1 = 1), gen(knowl2) // obama state
recode w11wv3 (-6 -5 = .) (-7 2 3 4 5 = 0) (1 = 1), gen(knowl3) // obama religion
recode w11wv4 (-6 -5 = .) (-7 2 3 4 5 = 0) (1 = 1), gen(knowl4) // mccain religion
recode w11wv5 (-6 -5 = .) (-7 2 3 4 = 0) (1 = 1), gen(knowl5) // obama past job
recode w11wv6 (-6 -5 = .) (-7 1 3 4 = 0) (2 = 1), gen(knowl6) // mccain past job
recode w11wv7 (-6 -5 -1 = .) (-7 1 3/44 = 0) (2 = 1), gen(knowl7) // Pres terms
recode w11wv8 (-6 -5 -1 = .) (-7 1/5 7/45 = 0) (6 = 1), gen(knowl8) // senate term
recode w11wv9 (-6 -5 -1 = .) (-7 0 1 3/300 = 0) (2 = 1), gen(knowl9) // senators per state
recode w11wv10 (-6 -5 -1 = .) (-7 1 3/100 = 0) (2 = 1), gen(knowl10) // house term
recode w11wv11 (-6 -5 -1 = .) (-7 1 2 = 0) (3 = 1), gen(knowl11) // succession
recode w11wv12 (-6 -5 -1 = .) (-7 1 3 4 = 0) (2 = 1), gen(knowl12) // veto override

* Wave 9 measures
replace knowl1 = 1 if knowl1==. & w9v1==1
replace knowl2 = 1 if knowl2==. & w9v2==1
replace knowl3 = 1 if knowl3==. & w9v3==1
replace knowl4 = 1 if knowl4==. & w9v4==1
replace knowl5 = 1 if knowl5==. & w9v5==1
replace knowl6 = 1 if knowl6==. & w9v6==2

replace knowl1 = 0 if knowl1==. & (w9v1==-7 | w9v1==2 | w9v1==3 | w9v1==4)
replace knowl2 = 0 if knowl2==. & (w9v2==-7 | w9v2==2 | w9v2==3 | w9v2==4)
replace knowl3 = 0 if knowl3==. & (w9v3==-7 | w9v3==2 | w9v3==3 | w9v3==4 | w9v3==5)
replace knowl4 = 0 if knowl4==. & (w9v4==-7 | w9v4==2 | w9v4==3 | w9v4==4 | w9v4==5)
replace knowl5 = 0 if knowl5==. & (w9v5==-7 | w9v5==2 | w9v5==3 | w9v5==4) 
replace knowl6 = 0 if knowl6==. & (w9v6==-7 | w9v6==2 | w9v6==3 | w9v6==4)

* Wave 2 measures
replace knowl7 = 1 if knowl7==. & w2u2==2
replace knowl8 = 1 if knowl8==. & w2u3==6
replace knowl9 = 1 if knowl9==. & w2u4==2
replace knowl10 = 1 if knowl10==. & w2u5==2
replace knowl11 = 1 if knowl11==. & w2u6==3
replace knowl12 = 1 if knowl12==. & w2u7==2

replace knowl7 = 0 if knowl7==. & w2u2!=-6 & w2u2!=-5 & w2u2!=2 // Code as wrong if the question was actually asked, and the correct answer was not provided
replace knowl8 = 0 if knowl8==. & w2u3!=-6 & w2u3!=-5 & w2u3!=6
replace knowl9 = 0 if knowl9==. & w2u4!=-6 & w2u4!=-5 & w2u4!=2 
replace knowl10 = 0 if knowl10==. & w2u5!=-6 & w2u5!=-5 & w2u5!=2 
replace knowl11 = 0 if knowl11==. & w2u6!=-6 & w2u6!=-5 & w2u6!=3 
replace knowl12 = 0 if knowl12==. & w2u7!=-6 & w2u7!=-5 & w2u7!=2 

* Combine across waves
gen knowlsum1 = knowl1 + knowl2 + knowl3 + knowl4 + knowl5 + knowl6
gen knowlsum2 = knowl7 + knowl8 + knowl9 + knowl10 + knowl11 + knowl12
gen knowlsum3 = knowlsum1 + knowlsum2
replace knowlsum3 = (knowlsum3 - 1)/11 // scale 0-1
tab knowlsum3

** Interest in politics
recode w10h1 (-7 -6 -5 = .) (1=4) (2=3) (3=2) (4=1) (5=0), gen(polintw10)
replace polintw10 = polintw10/4

** Need for cognition
gen nc1 = .
replace nc1 = 0 if w11ze5b==1
replace nc1 = 1 if w11ze5b==2
replace nc1 = 2 if w11ze4==3
replace nc1 = 3 if w11ze5a==2
replace nc1 = 4 if w11ze5a==1

recode w11ze6 (-7 -6 -5 = .) (1 = 0) (2 = 1), gen(nc2)
replace nc1 = nc1 / 4

gen needcog = (nc1 + nc2) / 2 // scale 0-1

* Trust in gov
recode w10k1 (-7 -6 -5 = .), gen(trust)
replace trust = (5-trust) / 4

* Racial resentment
gen rr1 = 5 - w20l1 if w20l1>0
gen rr2 = w20l2 - 1 if w20l2>0
gen rr3 = w20l3 - 1 if w20l3>0
gen rr4 = 5 - w20l4 if w20l4>0

gen resent2 = rr1 + rr2 + rr3 + rr4
gen resent = resent2 / 16

* Efficacy
recode w10j1 (-7 -6 -5 = .) (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = 0), gen(ef1)
replace ef1 = ef1 / 4
recode w10j2 (-7 -6 -5 = .) (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = 0), gen(ef2)
replace ef2 = ef2 / 4
alpha ef1 ef2, gen(efficacy)

** Media use
foreach num of numlist 1/4 {
	recode w10f`num' (-7 -6 -5 = .), gen(news`num')
	}
gen news = news1 + news2 + news3 + news4
replace news = news / 28

** Abortion opinions
gen w10abor1 = . /* hurt health but unlikely to die  */
replace w10abor1 = 0 if w10r3_favor == 1
replace w10abor1 = 1 if w10r3_favor == 2
replace w10abor1 = 2 if w10r3_favor == 3
replace w10abor1 = 4 if w10r3_oppose == 3
replace w10abor1 = 5 if w10r3_oppose == 2
replace w10abor1 = 6 if w10r3_oppose == 1
replace w10abor1 = 3 if w10r2 == 3
replace w10abor1 = w10abor1 / 6

gen w10abor2 = . /* preg could cause death */
replace w10abor2 = 0 if w10r5_favor == 1
replace w10abor2 = 1 if w10r5_favor == 2
replace w10abor2 = 2 if w10r5_favor == 3
replace w10abor2 = 4 if w10r5_oppose == 3
replace w10abor2 = 5 if w10r5_oppose == 2
replace w10abor2 = 6 if w10r5_oppose == 1
replace w10abor2 = 3 if w10r4 == 3
replace w10abor2 = w10abor2 / 6

gen w10abor3 = . /* preg from blood relative */
replace w10abor3 = 0 if w10r7_favor == 1
replace w10abor3 = 1 if w10r7_favor == 2
replace w10abor3 = 2 if w10r7_favor == 3
replace w10abor3 = 4 if w10r7_oppose == 3
replace w10abor3 = 5 if w10r7_oppose == 2
replace w10abor3 = 6 if w10r7_oppose == 1
replace w10abor3 = 3 if w10r6 == 3
replace w10abor3 = w10abor3 / 6

gen w10abor4 = . /* preg from rape */
replace w10abor4 = 0 if w10r9_favor == 1
replace w10abor4 = 1 if w10r9_favor == 2
replace w10abor4 = 2 if w10r9_favor == 3
replace w10abor4 = 4 if w10r9_oppose == 3
replace w10abor4 = 5 if w10r9_oppose == 2
replace w10abor4 = 6 if w10r9_oppose == 1
replace w10abor4 = 3 if w10r8 == 3
replace w10abor4 = w10abor4 / 6

gen w10abor5 = . /* birth defect */
replace w10abor5 = 0 if w10r11_favor == 1
replace w10abor5 = 1 if w10r11_favor == 2
replace w10abor5 = 2 if w10r11_favor == 3
replace w10abor5 = 4 if w10r11_oppose == 3
replace w10abor5 = 5 if w10r11_oppose == 2
replace w10abor5 = 6 if w10r11_oppose == 1
replace w10abor5 = 3 if w10r10 == 3
replace w10abor5 = w10abor5 / 6

gen w10abor6 = . /* child wrong sex */
replace w10abor6 = 0 if w10r13_favor == 1
replace w10abor6 = 1 if w10r13_favor == 2
replace w10abor6 = 2 if w10r13_favor == 3
replace w10abor6 = 4 if w10r13_oppose == 3
replace w10abor6 = 5 if w10r13_oppose == 2
replace w10abor6 = 6 if w10r13_oppose == 1
replace w10abor6 = 3 if w10r12 == 3
replace w10abor6 = w10abor6 / 6

gen w10abor7 = . /* difficult financially */
replace w10abor7 = 0 if w10r15_favor == 1
replace w10abor7 = 1 if w10r15_favor == 2
replace w10abor7 = 2 if w10r15_favor == 3
replace w10abor7 = 4 if w10r15_oppose == 3
replace w10abor7 = 5 if w10r15_oppose == 2
replace w10abor7 = 6 if w10r15_oppose == 1
replace w10abor7 = 3 if w10r14 == 3
replace w10abor7 = w10abor7 / 6

alpha w10abor1 w10abor2 w10abor3 w10abor4 w10abor5 w10abor6 w10abor7, gen(abortionw10)
gen abortfold = abs((abortionw10-.5)*2) // Fold and scale 0-1, for an extremity measure

** Environment
gen w10enviro1 = .
replace w10enviro1 = 0 if w10s10a == 1
replace w10enviro1 = 1 if w10s10a == 2
replace w10enviro1 = 2 if w10s10a == 3
replace w10enviro1 = 4 if w10s10b == 3
replace w10enviro1 = 5 if w10s10b == 2
replace w10enviro1 = 6 if w10s10b == 1
replace w10enviro1 = 3 if w10s9 == 3
replace w10enviro1 = w10enviro1 / 6

gen w10enviro2 = .
replace w10enviro2 = 0 if w10s12a == 1
replace w10enviro2 = 1 if w10s12a == 2
replace w10enviro2 = 2 if w10s12a == 3
replace w10enviro2 = 4 if w10s12b == 3
replace w10enviro2 = 5 if w10s12b == 2
replace w10enviro2 = 6 if w10s12b == 1
replace w10enviro2 = 3 if w10s11 == 3
replace w10enviro2 = w10enviro2 / 6

gen w10enviro3 = .
replace w10enviro3 = 0 if w10s14a == 1
replace w10enviro3 = 1 if w10s14a == 2
replace w10enviro3 = 2 if w10s14a == 3
replace w10enviro3 = 4 if w10s14b == 3
replace w10enviro3 = 5 if w10s14b == 2
replace w10enviro3 = 6 if w10s14b == 1
replace w10enviro3 = 3 if w10s13 == 3
replace w10enviro3 = w10enviro3 / 6

alpha w10enviro1 w10enviro2 w10enviro3, gen(envirow10)
gen envirofold = abs((envirow10-.5)*2) // Fold and scale 0-1, for an extremity measure

** Floating voters
gen bush04 = .
gen kerry04 = .
gen other04 = .

* Previous vote was asked in Wave 1, 2, 6, or 9.

replace bush04 = 1 if w9ab6==1
replace kerry04 = 1 if w9ab6==2
replace other04 = 1 if w9ab6>2 & w9ab6<20

replace bush04 = 1 if w9ab6==1
replace kerry04 = 1 if w9ab6==2
replace other04 = 1 if w9ab6>2 & w9ab6<20

replace bush04 = 1 if w6ab6==1
replace kerry04 = 1 if w6ab6==2
replace other04 = 1 if w6ab6>2 & w9ab6<20

replace bush04 = 1 if w2ab6==1
replace kerry04 = 1 if w2ab6==2
replace other04 = 1 if w2ab6>2 & w9ab6<20

replace bush04 = 1 if w1a6==1
replace kerry04 = 1 if w1a6==2
replace other04 = 1 if w1a6>2 & w9ab6<20

* These are contradictory responses. (Supposedly voted for two different people.)
replace bush04 = 0 if kerry04==1 | other04==1
replace kerry04 = 0 if bush04==1 | other04==1
replace other04 = 0 if kerry04==1 | bush04==1

gen floater = .
replace floater = 0 if kerry04==1 & obvote==1
replace floater = 0 if bush04==1 & obvote==0
replace floater = 1 if bush04==1 & obvote==1
replace floater = 1 if kerry04==1 & obvote==0

** Approval of Obama for education and health care
* The following loop combines responses across a few branched questions into a summary measure
foreach num in 15 17 { // 15 and 17 because these are the education and health care measures
	scalar k = `num'+1
	local l = k
	gen w17approve`num' = .
	replace w17approve`num' = 0 if w17ws`num'==2 & w17ws_d_`l'==1 // disapprove branch
	replace w17approve`num' = 1 if w17ws`num'==2 & w17ws_d_`l'==2
	replace w17approve`num' = 2 if w17ws`num'==2 & w17ws_d_`l'==3
	replace w17approve`num' = 3 if w17ws`num'==3 // neither approve nor disapprove
	replace w17approve`num' = 4 if w17ws`num'==1 & w17ws_a_`l'==3 // approve branch
	replace w17approve`num' = 5 if w17ws`num'==1 & w17ws_a_`l'==2
	replace w17approve`num' = 6 if w17ws`num'==1 & w17ws_a_`l'==1

	gen w19approve`num' = .
	replace w19approve`num' = 0 if w19ws`num'==2 & w19ws_d_`l'==1
	replace w19approve`num' = 1 if w19ws`num'==2 & w19ws_d_`l'==2
	replace w19approve`num' = 2 if w19ws`num'==2 & w19ws_d_`l'==3
	replace w19approve`num' = 3 if w19ws`num'==3 
	replace w19approve`num' = 4 if w19ws`num'==1 & w19ws_a_`l'==3
	replace w19approve`num' = 5 if w19ws`num'==1 & w19ws_a_`l'==2
	replace w19approve`num' = 6 if w19ws`num'==1 & w19ws_a_`l'==1
	
	replace w17approve`num' = w17approve`num' / 6 // scale 0-1
	replace w19approve`num' = w19approve`num' / 6 // scale 0-1
	}

** Affect misattribution Procedure
* Wave 9
egen respmaxw9 = rowmax(w9amp_q2_face1_choice-w9amp_q2_face48_choice)
egen bpleasw9 = anycount(w9amp_q2_face1_choice-w9amp_q2_face24_choice), values(1) // Count black/Obama faces rated as pleasant

replace bpleasw9 = . if w9amp_ver==-6 // didn't take w9
replace bpleasw9 = . if w9amp_ver==-2 // missing
replace bpleasw9 = . if respmaxw9==-5 // didn't take amp
replace bpleasw9 = . if respmaxw9==-7 // didn't take amp

egen bunpleasw9 = anycount(w9amp_q2_face1_choice-w9amp_q2_face24_choice), values(2) // Count black/Obama faces rated unpleasant
replace bunpleasw9 = . if w9amp_ver==-6
replace bunpleasw9 = . if w9amp_ver==-2
replace bunpleasw9 = . if respmaxw9==-5
replace bunpleasw9 = . if respmaxw9==-7

egen wpleasw9 = anycount(w9amp_q2_face25_choice-w9amp_q2_face48_choice), values(1) // Count white / McCain faces rated pleasant
replace wpleasw9 = . if w9amp_ver==-6
replace wpleasw9 = . if w9amp_ver==-2
replace wpleasw9 = . if respmaxw9==-5
replace wpleasw9 = . if respmaxw9==-7

egen wunpleasw9 = anycount(w9amp_q2_face25_choice-w9amp_q2_face48_choice), values(2) // Count white / McCain faces rated unpleasant
replace wunpleasw9 = . if w9amp_ver==-6
replace wunpleasw9 = . if w9amp_ver==-2
replace wunpleasw9 = . if respmaxw9==-5
replace wunpleasw9 = . if respmaxw9==-7

* Wave 10. This code is parallel to the above, but for Wave 10.
egen respmaxw10 = rowmax(w10amp_q2_face1_choice-w10amp_q2_face48_choice)
egen bpleasw10 = anycount(w10amp_q2_face1_choice-w10amp_q2_face24_choice), values(1)

replace bpleasw10 = . if w10amp_ver==-6
replace bpleasw10 = . if w10amp_ver==-2 
replace bpleasw10 = . if respmaxw10==-5
replace bpleasw10 = . if respmaxw10==-7

egen bunpleasw10 = anycount(w10amp_q2_face1_choice-w10amp_q2_face24_choice), values(2)
replace bunpleasw10 = . if w10amp_ver==-6
replace bunpleasw10 = . if w10amp_ver==-2
replace bunpleasw10 = . if respmaxw10==-5
replace bunpleasw10 = . if respmaxw10==-7

egen wpleasw10 = anycount(w10amp_q2_face25_choice-w10amp_q2_face48_choice), values(1)
replace wpleasw10 = . if w10amp_ver==-6
replace wpleasw10 = . if w10amp_ver==-2
replace wpleasw10 = . if respmaxw10==-5
replace wpleasw10 = . if respmaxw10==-7

egen wunpleasw10 = anycount(w10amp_q2_face25_choice-w10amp_q2_face48_choice), values(2)
replace wunpleasw10 = . if w10amp_ver==-6
replace wunpleasw10 = . if w10amp_ver==-2
replace wunpleasw10 = . if respmaxw10==-5
replace wunpleasw10 = . if respmaxw10==-7

* Calculate proportion pleasant / unpleasant
gen propbpleasw9 = bpleasw9 / 24
gen propwpleasw9 = wpleasw9 / 24
gen propbpleasw10 = bpleasw10 / 24
gen propwpleasw10 = wpleasw10 / 24

* Calculate differences in proportions
gen wbdifw9 = propwpleasw9 - propbpleasw9
gen wbdifw10 = propwpleasw10 - propbpleasw10

* Calculate Obama / McCain AMP. (Either the W9 AMP or the W10 AMP, depending on a random assignment).
gen omdifcomb = .
replace omdifcomb = wbdifw9 if w9amp_ver==1
replace omdifcomb = wbdifw10 if w9amp_ver==2
gen implicit = -1*omdifcomb // synonym for easier interpretation. Also, reverse it, to match the convention that pro-Democratic / Obama attitudes take high values.

* Calculate the white/black AMP. (Flip side of the random assignment above)
gen wbdifcomb = .
replace wbdifcomb = wbdifw9 if w9amp_ver==2
replace wbdifcomb = wbdifw10 if w9amp_ver==1
rename wbdifcomb implic_race
replace implic_race = -1*implic_race // code such that positive affect toward blacks takes high values

* Simpler identifier for whether the candidate AMP was Wave 9 or Wave 10
gen omw9 = .
replace omw9 = 1 if w9amp_ver==2
replace omw9 = 0 if w9amp_ver==1

* Identify problematic AMP response patterns--people who hit the same key over and over again. (See footnote in text.)
gen omampbad = 0 // Obama / McCain AMP bad?
replace omampbad = 1 if bpleasw9==24 & wpleasw9==24 & omw9==1
replace omampbad = 1 if bpleasw10==24 & wpleasw10==24 & omw9==0
replace omampbad = 1 if bpleasw9==0 & wpleasw9==0 & omw9==1
replace omampbad = 1 if bpleasw10==0 & wpleasw10==0 & omw9==0

gen bwampbad = 0 // Black / White AMP bad?
replace bwampbad = 1 if bpleasw9==24 & wpleasw9==24 & omw9==0
replace bwampbad = 1 if bpleasw10==24 & wpleasw10==24 & omw9==1
replace bwampbad = 1 if bpleasw9==0 & wpleasw9==0 & omw9==0
replace bwampbad = 1 if bpleasw10==0 & wpleasw10==0 & omw9==1

order w19state1, before(w19state2)

keep version caseid w10flag wgtcs11 omampbad bwampbad implicit implic_race explicit* ///
	knowlsum3 polint needcog news voter educ pidstr ideolext abortfold envirofold floater ///
	oiacat* obvote educ2 region white black hispanic income female age pid2 w9state* w19state* ///
	ambiv w19approve17 w19approve15 w17approve17 w17approve15 intensity trust efficacy resent ///
	oiacat_party

save "anes_working.dta", replace
