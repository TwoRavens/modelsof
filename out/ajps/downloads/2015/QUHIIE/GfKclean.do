set more off
clear all
use "GfKRaw.dta"

numlabel, add

* Social Security extremity (folded)
gen socsecop2 = Q1-1
gen socsecop = socsecop2/6
gen extfold = sqrt((socsecop - .5)^2)*2
drop socsecop2

* Importance
gen imp = Q2
replace imp = . if imp==-1
replace imp = (imp - 1)/4

* Relevance
gen relev = Q3
replace relev = . if Q3==-1
replace relev = (relev - 1)/4

* Moral conviction (two items)
gen mc1 = Q4
replace mc1 = . if Q4==-1
replace mc1 = (mc1 - 1)/4

gen mc2 = Q4_1
replace mc2 = . if Q4_1==-1
replace mc2 = (mc2 - 1)/4

alpha mc1 mc2, gen(mc) // Scale. Alpha =.92

* Church attendance
gen church = (6 - REL2)/5

* Age
egen agebin = cut(PPAGE), at(18,29,39,49,59,69,120) icodes

* Gender
recode PPGENDER (1 = 0) (2 = 1), gen(female)

* Income
gen income = (PPINCIMP-1)/18
recode PPINCIMP (1/6 = 0) (7 8 = 1) (9 10 = 2) (11 = 3) ///
	(12 = 4) (13 = 5) (14 15 = 6) (16 17 = 7) (18 19 = 8), gen(inccat)

* Education categories
recode PPEDUC (1 3 4 5 6 7 8 = 0) (9 = 1) (10 11 = 2) (12 = 3) (13 14 = 4), gen(educcat)
lab def educcat 0 "No Diploma" 1 "HS Only" 2 "Some Col." 3 "BA" 4 "Grad degree"
lab val educcat educcat

* Race
recode PPETHM (1 = 0) (2 = 1) (3 = 4) (4 = 4) (5 = 4), gen(race) // Asians would be value 3, but not coded here.

* Strength of partisanship
gen pidr2 = 7 - PARTY7
gen pidr = pidr2 / 6
gen pidstr = (sqrt((pidr2-3)^2))/3
drop pidr*

* Strength of partisanship, party-specific
gen dpidstr = 0
replace dpidstr = pidstr if PARTY7>=4 & PARTY7<8
gen rpidstr = 0
replace rpidstr = pidstr if PARTY7<=4 & PARTY7>0


* Candidate preference
* Social Security proponents and opponents saw different versions of the question.
* The next lines pool them.
egen candaresp = rowmax(Q7_1 Q7A_1)
replace candaresp = . if candaresp==-1
egen candbresp = rowmax(Q7_2 Q7A_2)
replace candbresp = . if candbresp==-1
 
* The slate of issue stances was randomly assigned. The following creates
* a variable for "negotiable" being assigned to Candidate A, rather than B.
gen acomp = INSERT_1_Q7_Q7A // Was Candidate A randomly assigned the "negotiable" stance?

* Difference measure. Negotiating candidate minus rigid candidate
gen comppref = candaresp - candbresp if acomp==1
replace comppref = candbresp - candaresp if acomp==0
replace comppref = (comppref + 4)/8
drop candaresp candbresp acomp

* Willingness to Accept (WTA) benefits
gen wta = .
replace wta = Q6 if Q6 >0 & Q6<6 // Response option 6 was skipping the question
replace wta = Q6A if Q6A>0 & Q6A<6 // Response option 6 was skipping the question
replace wta = (wta-1)/4 // scale 0-1



save "GfKWorking.dta", replace
