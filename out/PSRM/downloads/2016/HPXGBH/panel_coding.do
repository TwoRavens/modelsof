* This file creates the Panel working dataset used Kinder and Ryan, "Prejudice and Politics Re-examined"
* Analysis was conducted on State/SE 13.1 for Mac (64-bit Intel) 

* Load raw data
use "anes2008_2009panel_dataset.dta", clear

* Merge in IAT scores
* Scores available from http://electionstudies.org/studypages/2008_2009panel/IATscores.zip
sort caseid
merge caseid using "iat.dta", unique sort

* Race
gen white = 0
replace white = 1 if der04==1
gen black = 0
replace black = 1 if der04==2
gen hispanic = 0
replace hispanic = 1 if der04==3

* Gender
gen female = 0
replace female = 1 if der01==2

* Age
gen age = (der02 - 18 ) / 72
rename der02 age2
gen agebin = .
replace agebin = 0 if (age2<30)
replace agebin = 1 if (age2>=30) & (age2<=39)
replace agebin = 2 if (age2>=40) & (age2<=49)
replace agebin = 3 if (age2>=50) & (age2<=59)
replace agebin = 4 if (age2>=60) & (age2<=69)
replace agebin = 5 if (age2>=70) & (age2<=79)
replace agebin = 6 if (age2>=80) & (age2<=99)
recode agebin (5 = 4) (6 = 4), gen(agebin2)

* Vote choice
gen mcvote = .
replace mcvote = 1 if der16==1
replace mcvote = 0 if der16==2
replace mcvote = . if der15==2 // Remove nonvoters

* Primary vote choice
gen primvote = .
replace primvote = 0 if der14==2 // Obama voters
replace primvote = 1 if der14==1 | (der14>2 & der14<10) // Another Democrat
replace primvote = 1 if der13>0 & der13<11 // A Republican
replace primvote = . if der10a==1

* PID: Start with least desirable wave, and gradually replace with best (closest to election) one, if available.
gen pidr = .

replace pidr = 0 if der08w1 == 0
replace pidr = 1 if der08w1 == 1 | der08w1==2
replace pidr = 2 if der08w1 == 3
replace pidr = 3 if der08w1 == 4 | der08w1==5 
replace pidr = 4 if der08w1 == 6

replace pidr = 0 if der08w19 == 0
replace pidr = 1 if der08w19 == 1 | der08w19==2
replace pidr = 2 if der08w19 == 3
replace pidr = 3 if der08w19 == 4 | der08w19==5 
replace pidr = 4 if der08w19 == 6

replace pidr = 0 if der08w17 == 0
replace pidr = 1 if der08w17 == 1 | der08w17==2
replace pidr = 2 if der08w17 == 3
replace pidr = 3 if der08w17 == 4 | der08w17==5 
replace pidr = 4 if der08w17 == 6

replace pidr = 0 if der08w9 == 0
replace pidr = 1 if der08w9 == 1 | der08w9==2
replace pidr = 2 if der08w9 == 3
replace pidr = 3 if der08w9 == 4 | der08w9==5 
replace pidr = 4 if der08w9 == 6

replace pidr = 0 if der08w11 == 0
replace pidr = 1 if der08w11 == 1 | der08w11==2
replace pidr = 2 if der08w11 == 3
replace pidr = 3 if der08w11 == 4 | der08w11==5 
replace pidr = 4 if der08w11 == 6

replace pidr = 0 if der08w10 == 0
replace pidr = 1 if der08w10 == 1 | der08w10==2
replace pidr = 2 if der08w10 == 3
replace pidr = 3 if der08w10 == 4 | der08w10==5 
replace pidr = 4 if der08w10 == 6

gen pidr2 = pidr / 4

lab def pidr 0 "Strong Dem" 1 "Weak Dem" 2 "Independent" 3 "Weak Repub" 4 "Strong Repub"
lab val pidr pidr

* Strength of PID
gen pidstr = .
replace pidstr = 0 if pidr==2
replace pidstr = 1 if pidr==1 | pidr==3
replace pidstr = 2 if pidr==0 | pidr==4
replace pidstr = pidstr / 2

* State of residence
* The cdstate variable uses different codes than the other variables.
* The portion of code below makes them match.

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

* Replace the cdstate coding with the more desirable ones, if they are avaiable
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

* Region
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

* Deep south 
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

* Peripheral south
gen periphsouth = 0
replace periphsouth = 1 if state==9
replace periphsouth = 1 if state==10
replace periphsouth = 1 if state==19
replace periphsouth = 1 if state==22
replace periphsouth = 1 if state==38
replace periphsouth = 1 if state==50

replace region = 3 if periphsouth==1

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

* Education
gen educ2 = der05
replace educ2 = . if der05==-6
replace educ2 = . if der05==-2
gen educ = (educ2-1)/4

replace educ2 = educ2 - 1
lab def educ2 0 "No HS" 1 "Diploma" 2 "Some col" 3 "BA" 4 "Adv. Degree"
lab val educ2 educ2

* Racial resentment

gen rr1 = 5 - w20l1 if w20l1>0
gen rr2 = w20l2 - 1 if w20l2>0
gen rr3 = w20l3 - 1 if w20l3>0
gen rr4 = 5 - w20l4 if w20l4>0

gen resent2 = rr1 + rr2 + rr3 + rr4
gen resent = resent2 / 16
gen resentx = (resent*2)-1

* Stereotyping
foreach var of varlist w20m2 w20m3 w20m4 w20m9 w20m10 w20m11 {
	recode `var' (-7 -6 -5 -4 = .) (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = 0)
	}

alpha w20m2 w20m3 w20m4, gen(bposstereo)
alpha w20m9 w20m10 w20m11, gen(wposstereo)

* Negative traits
foreach var of varlist w20m5 w20m6 w20m7 w20m8 w20m12 w20m13 w20m14 w20m15 {
	recode `var' (-7 -6 -5 -4 = .) (1 = 4) (2 = 3) (3 = 2) (4 = 1) (5 = 0)
	}

alpha w20m5 w20m6 w20m7 w20m8, gen(bnegstereo) 
alpha w20m12 w20m13 w20m14 w20m15, gen(wnegstereo) 

replace bposstereo = bposstereo / 4
replace wposstereo = wposstereo / 4
replace bnegstereo = bnegstereo / 4
replace wnegstereo = wnegstereo / 4

gen bstereo = bnegstereo - bposstereo 
gen wstereo = wnegstereo - wposstereo
gen stereodif = (bstereo - wstereo)/2


* Fair jobs policy
gen fairjobw11 = .
replace fairjobw11 = 0 if w11zb2a==1
replace fairjobw11 = 1 if w11zb2a==2
replace fairjobw11 = 2 if w11zb2a==3
replace fairjobw11 = 4 if w11zb2b==3
replace fairjobw11 = 5 if w11zb2b==2
replace fairjobw11 = 6 if w11zb2b==1
replace fairjobw11 = 3 if w11zb1==3
replace fairjobw11 = fairjobw11 / 6

* Hiring policy
gen hiringw11 = .
replace hiringw11 = 0 if w11n15_b == 1
replace hiringw11 = 1 if w11n15_b == 2
replace hiringw11 = 2 if w11n15_b == 3
replace hiringw11 = 4 if w11n15_c == 3
replace hiringw11 = 5 if w11n15_c == 2
replace hiringw11 = 6 if w11n15_c == 1
replace hiringw11 = 3 if w11n15_a == 3
replace hiringw11 = hiringw11 / 6

* Health care opinions
gen medcarew1 = .
replace medcarew1 = 0 if w1p_f_14==1
replace medcarew1 = 1 if w1p_f_14==2
replace medcarew1 = 2 if w1p_f_14==3
replace medcarew1 = 4 if w1p_o_14==3
replace medcarew1 = 5 if w1p_o_14==2
replace medcarew1 = 6 if w1p_o_14==1
replace medcarew1 = 3 if w1p13==3
replace medcarew1 = medcarew1 / 6

gen medcarew10 = .
replace medcarew10 = 0 if w10p14_favor==1
replace medcarew10 = 1 if w10p14_favor==2
replace medcarew10 = 2 if w10p14_favor==3
replace medcarew10 = 4 if w10p14_oppose==3
replace medcarew10 = 5 if w10p14_oppose==2
replace medcarew10 = 6 if w10p14_oppose==1
replace medcarew10 = 3 if w10p13==3
replace medcarew10 = medcarew10 / 6


* Liking of Obama in waves 9 and 10
gen dislikeobw9 = .
replace dislikeobw9 = 0 if w9e39==1
replace dislikeobw9 = 1 if w9e39==2
replace dislikeobw9 = 2 if w9e39==3
replace dislikeobw9 = 4 if w9e40==3
replace dislikeobw9 = 5 if w9e40==2
replace dislikeobw9 = 6 if w9e40==1
replace dislikeobw9 = 3 if w9e38==3
replace dislikeobw9 = dislikeobw9 / 6

gen dislikeobw10 = .
replace dislikeobw10 = 0 if w10e39==1
replace dislikeobw10 = 1 if w10e39==2
replace dislikeobw10 = 2 if w10e39==3
replace dislikeobw10 = 4 if w10e40==3
replace dislikeobw10 = 5 if w10e40==2
replace dislikeobw10 = 6 if w10e40==1
replace dislikeobw10 = 3 if w10e38==3
replace dislikeobw10 = dislikeobw10 / 6

gen obsupsum = 1 - ((dislikeobw9 + dislikeobw10) / 2)

* Approval of Obama in July 2009
gen obdisapw19 = .
replace obdisapw19 = 0 if w19ws_a_2==1
replace obdisapw19 = 1 if w19ws_a_2==2
replace obdisapw19 = 2 if w19ws_a_2==3
replace obdisapw19 = 4 if w19ws_d_2==3
replace obdisapw19 = 5 if w19ws_d_2==2
replace obdisapw19 = 6 if w19ws_d_2==1
replace obdisapw19 = 3 if w19ws1==3
replace obdisapw19 = obdisapw19 / 6

* Obama's religion
gen obreligw11 = w11wv3
replace obreligw11 = . if w11wv3==-7 | w11wv3==-6 | w11wv3==-5 
gen obmuslimw11 = .
replace obmuslimw11 = 1 if obreligw11==3
replace obmuslimw11 = 0 if obreligw11==1 | obreligw11==2 | obreligw11==4 | obreligw11==5

* Political knowledge
* Wave 2
gen knowlw2q1 = 0
gen knowlw2q2 = 0
gen knowlw2q3 = 0
gen knowlw2q4 = 0
gen knowlw2q5 = 0
gen knowlw2q6 = 0

replace knowlw2q1 = 1 if w2u2 == 2
replace knowlw2q2 = 1 if w2u3 == 6
replace knowlw2q3 = 1 if w2u4 == 2
replace knowlw2q4 = 1 if w2u5 == 2
replace knowlw2q5 = 1 if w2u6 == 3
replace knowlw2q6 = 1 if w2u7 == 2

gen knowl2w2 = knowlw2q1 + knowlw2q2 + knowlw2q3 + knowlw2q4 + knowlw2q5 + knowlw2q6
recode knowl2w2 (0 = .) if w2u2==-6 | w2u2==-5 // Non-responses
gen knowlw2 = knowl2w2 / 6

* Wave 11
gen knowlw11q1 = 0
gen knowlw11q2 = 0
gen knowlw11q3 = 0
gen knowlw11q4 = 0
gen knowlw11q5 = 0
gen knowlw11q6 = 0

replace knowlw11q1 = 1 if w11wv7 == 2
replace knowlw11q2 = 1 if w11wv8 == 6
replace knowlw11q3 = 1 if w11wv9 == 2
replace knowlw11q4 = 1 if w11wv10 == 2
replace knowlw11q5 = 1 if w11wv11 == 3
replace knowlw11q6 = 1 if w11wv12 == 2

gen knowl2w11 = knowlw11q1 + knowlw11q2 + knowlw11q3 + knowlw11q4 + knowlw11q5 + knowlw11q6
recode knowl2w11 (0 = .) if w11wv7==-6 | w11wv7==-5 | w11wv7==-1 // Non-responses
gen knowlw11 = knowl2w11 / 6

gen knowlsum = max(knowlw2, knowlw11)


save "panel_working.dta", replace

