********************************************************************************
********************************************************************************
******** Are All "Birthers" Conspiracy Theorists?: On the Relationship ********* 
********** Between Conspiratorial Thinking and Political Orientations **********
********************************************************************************
********************************************************************************
************ Adam M. Enders, Steven M. Smallpage, Robert N. Lupton *************
********************************************************************************
********************************************************************************

* Replication file for Study 2

* Open "2016 MTurk.dta"


********************************************************************************

*** Cleaning data and creating relevant variables ***

* Case ID
gen caseid = v1


* Conspiracy experiment
gen c1truther = q10
replace c1truther = . if q10 == 5
recode c1truther (1=4) (2=3) (3=2) (4=1)

gen c1jfk = q11
replace c1jfk = . if q11 == 5

gen c1birther = q12
replace c1birther = . if q12 == 5


gen t1truther = q13
replace t1truther = . if q13 == 5
recode t1truther (1=4) (2=3) (3=2) (4=1)

gen t1jfk = q14
replace t1jfk = . if q14 == 5

gen t1birther = q15
replace t1birther = . if q15 == 5


gen t2truther = q18
replace t2truther = . if q18 == 5
recode t2truther (1=4) (2=3) (3=2) (4=1)

gen t2jfk = q17
replace t2jfk = . if q17 == 5

gen t2birther = q16
replace t2birther = . if q16 == 5


gen t3truther = q21
replace t3truther = . if q21 == 5
recode t3truther (1=4) (2=3) (3=2) (4=1)

gen t3jfk = q20
replace t3jfk = . if q20 == 5

gen t3birther = q19
replace t3birther = . if q19 == 5


gen t4truther = q24
replace t4truther = . if q24 == 5
recode t4truther (1=4) (2=3) (3=2) (4=1)

gen t4jfk = q23
replace t4jfk = . if q23 == 5

gen t4birther = q22
replace t4birther = . if q22 == 5


egen jfkbelief = rowmax(c1jfk t1jfk t2jfk t3jfk t4jfk)

egen birtherbelief = rowmax(c1birther t1birther t2birther t3birther t4birther)

egen trutherbelief = rowmax(c1truther t1truther t2truther t3truther t4truther)


* Knowledge
gen viceprez = 1 if q2 == 3
replace viceprez = 0 if q2 != 3

gen chiefjust = 1 if q3 == 2
replace chiefjust = 0 if q3 != 2

gen paulryan = 1 if q4 == 1
replace paulryan = 0 if q4 != 1

gen prezelect = 1 if q5 == 2
replace prezelect = 0 if q5 != 2

gen senelect = 1 if q6 == 6
replace senelect = 0 if q6 != 6

gen billrights = 1 if q7 == 10
replace billrights = 0 if q7 != 10

gen knowledge = viceprez + chiefjust + paulryan + prezelect ///
	+ senelect + billrights


* Conspiratorial Thinking
gen accident = q26_1
replace accident = . if q26_1 == 6
recode accident (1=4) (2=3) (4=1) (5=0) (7=2)

gen lies = q26_2
replace lies = . if q26_2 == 6
recode lies (1=0) (2=1) (4=3) (5=4) (7=2)

gen secrets = q26_3
replace secrets = . if q26_3 == 6
recode secrets (1=4) (2=3) (4=1) (5=0) (7=2)

gen outsideint = q26_28
replace outsideint = . if q26_28 == 6
recode outsideint (1=4) (2=3) (4=1) (5=0) (7=2)

gen conthink = accident + lies + secrets + outsideint


* Authoritarianism
gen authoritarian1 = 0 if q41 == 1
replace authoritarian1 = 1 if q41 == 3
replace authoritarian1 = 2 if q41 == 2

gen authoritarian2 = 0 if q42 == 1
replace authoritarian2 = 1 if q42 == 3
replace authoritarian2 = 2 if q42 == 2

gen authoritarian3 = 0 if q43 == 2
replace authoritarian3 = 1 if q43 == 3
replace authoritarian3 = 2 if q43 == 1

gen authoritarian4 = 0 if q44 == 1
replace authoritarian4 = 1 if q44 == 3
replace authoritarian4 = 2 if q44 == 2

gen authoritarianism = authoritarian1 + authoritarian2 + authoritarian3 ///
	+ authoritarian4

	
* Party ID
gen pid1 = q74 - 4
replace pid1 = . if q74 >= 8

gen pid2 = -3 if q29 == 1
replace pid2 = -2 if q29 == 2
replace pid2 = -1 if q30 == 2
replace pid2 = 0 if q27 == 3 & q30 == 3
replace pid2 = 1 if q30 == 1
replace pid2 = 2 if q28 == 2
replace pid2 = 3 if q28 == 1

egen pidcomb = rowmax(pid1 pid2)

gen rep = 1 if pid1 > 0 | pid2 > 0
replace rep = 0 if pid1 < 0 | pid2 < 0


* Ideology
gen ideo1 = q31 - 4
replace ideo1 = . if q31 >= 8

gen ideo2 = -3 if q76 == 1
replace ideo2 = -2 if q76 == 2
replace ideo2 = -1 if q78 == 2
replace ideo2 = 0 if q75 == 3 & q78 == 3
replace ideo2 = 1 if q78 == 1
replace ideo2 = 2 if q77 == 2
replace ideo2 = 3 if q77 == 1

egen ideocomb = rowmax(ideo1 ideo2)


* Gender
gen female = q56 - 1


* Race 
gen black = 1 if q57 == 2
replace black = 0 if q57 != 2

gen hispanic = 1 if q57 == 3
replace hispanic = 0 if q57 != 3


* Age 
gen age = v93


* Education
gen edu = v94


********************************************************************************

*** Empirical analyses ***

* Demographic characteristics (Table 2)
sum conthink pidcomb ideocomb authoritarianism knowledge edu age female ///
	black hispanic


* Estimate ordered logit models (Table 3, odd columns)
ologit birtherbelief conthink pidcomb ideocomb authoritarianism ///
	knowledge edu age female black hispanic

ologit jfkbelief conthink pidcomb ideocomb authoritarianism ///
	knowledge edu age female black hispanic
	
ologit trutherbelief conthink pidcomb ideocomb authoritarianism ///
	knowledge edu age female black hispanic
	
	
* Models with odds ratios (Table 3, even columns)
ologit birtherbelief conthink pidcomb ideocomb authoritarianism ///
	knowledge edu age female black hispanic, or

ologit jfkbelief conthink pidcomb ideocomb authoritarianism ///
	knowledge edu age female black hispanic, or
	
ologit trutherbelief conthink pidcomb ideocomb authoritarianism ///
	knowledge edu age female black hispanic, or

	
* First differences (Table 4)	
estsimp ologit birtherbelief conthink pidcomb ideocomb authoritarianism ///
	knowledge edu age female black hispanic	
  
setx (pidcomb ideocomb authoritarianism knowledge edu age) mean female 0 black 0 hispanic 0  
simqi, fd(prval(1)) changex(conthink min max)
simqi, fd(prval(2)) changex(conthink min max)
simqi, fd(prval(3)) changex(conthink min max)
simqi, fd(prval(4)) changex(conthink min max)

setx (conthink ideocomb authoritarianism knowledge edu age) mean female 0 black 0 hispanic 0  
simqi, fd(prval(1)) changex(pidcomb min max)
simqi, fd(prval(2)) changex(pidcomb min max)
simqi, fd(prval(3)) changex(pidcomb min max)
simqi, fd(prval(4)) changex(pidcomb min max)

setx (conthink pidcomb authoritarianism knowledge edu age) mean female 0 black 0 hispanic 0  
simqi, fd(prval(1)) changex(ideocomb min max)
simqi, fd(prval(2)) changex(ideocomb min max)
simqi, fd(prval(3)) changex(ideocomb min max)
simqi, fd(prval(4)) changex(ideocomb min max)	



drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13
	
estsimp ologit jfkbelief conthink pidcomb ideocomb authoritarianism ///
	knowledge edu age female black hispanic	
  
setx (pidcomb ideocomb authoritarianism knowledge edu age) mean female 0 black 0 hispanic 0  
simqi, fd(prval(1)) changex(conthink min max)
simqi, fd(prval(2)) changex(conthink min max)
simqi, fd(prval(3)) changex(conthink min max)
simqi, fd(prval(4)) changex(conthink min max)

setx (conthink ideocomb authoritarianism knowledge edu age) mean female 0 black 0 hispanic 0  
simqi, fd(prval(1)) changex(pidcomb min max)
simqi, fd(prval(2)) changex(pidcomb min max)
simqi, fd(prval(3)) changex(pidcomb min max)
simqi, fd(prval(4)) changex(pidcomb min max)

setx (conthink pidcomb authoritarianism knowledge edu age) mean female 0 black 0 hispanic 0  
simqi, fd(prval(1)) changex(ideocomb min max)
simqi, fd(prval(2)) changex(ideocomb min max)
simqi, fd(prval(3)) changex(ideocomb min max)
simqi, fd(prval(4)) changex(ideocomb min max)



drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11 b12 b13

estsimp ologit trutherbelief conthink pidcomb ideocomb authoritarianism ///
	knowledge edu age female black hispanic	
  
setx (pidcomb ideocomb authoritarianism knowledge edu age) mean female 0 black 0 hispanic 0  
simqi, fd(prval(1)) changex(conthink min max)
simqi, fd(prval(2)) changex(conthink min max)
simqi, fd(prval(3)) changex(conthink min max)
simqi, fd(prval(4)) changex(conthink min max)

setx (conthink ideocomb authoritarianism knowledge edu age) mean female 0 black 0 hispanic 0  
simqi, fd(prval(1)) changex(pidcomb min max)
simqi, fd(prval(2)) changex(pidcomb min max)
simqi, fd(prval(3)) changex(pidcomb min max)
simqi, fd(prval(4)) changex(pidcomb min max)

setx (conthink pidcomb authoritarianism knowledge edu age) mean female 0 black 0 hispanic 0  
simqi, fd(prval(1)) changex(ideocomb min max)
simqi, fd(prval(2)) changex(ideocomb min max)
simqi, fd(prval(3)) changex(ideocomb min max)
simqi, fd(prval(4)) changex(ideocomb min max)


********************************************************************************

*** Supplemental Appendix ***

* Distributions of conspiratorial thinking questions (Figure A1)
hist accident 
hist lies
hist secrets
hist outsideint


* Exploratory factor analysis of conspiratorial thinking questions
factor accident lies secrets outsideint, ipf
