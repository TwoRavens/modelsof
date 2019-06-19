********************************************************
********************************************************
**********Claims in V. Main Experiment Sample***********
********************************************************
********************************************************

clear all
set mem 30m

use "/Users/gwf25/Dropbox/research/religion/final code/religion_all.dta"

//  Begin definition of variables

***Drop subjects who thought the experiment was about religion
gen id = _n
drop if id == 98 | id == 176 | id == 194 | id == 383

***Drop subjects who incorrectly completed the priming task. This includes subjects who leave more than half the responses blank. The following subjects
***all left at least questions #2-#7 blank in the sentence unscrambling task. 
drop if id==7 | id==719 | id==740 | id==762 | id==940

***An error led to some subjects seeing both the control and religion salient sentence unscrambling tasks. Here, we drop those subjects.
drop if prime_diff == 1

***"skipped" is a dummy variable for whether subjects skip the question that asks their religion. If they skip this question, we drop them from the sample 
***and if not, we assign a dummy variable to indicate the treatment group (religion salient or control) that subject belongs to.
gen skipped=0
replace skipped=1 if  s10q15==""
gen treatR=.
replace treatR=religion if skipped==0
drop if skipped==1

***Define religion
gen relig=.

***Note: 1 = protestant or other christian, 2 = catholic, 3 = jewish, 4 = agnostic/atheist
replace relig=1 if (s10q15=="Christian - Other (please specify below)" | s10q15=="Christian - Protestant (please specify denomination below)")
replace relig=2 if s10q15=="Christian - Catholic"
replace relig=3 if s10q15=="Jewish (Orthodox/Reformed/etc.)" | s10q15=="Jewish (Orthodox/Reform/etc.)"
replace relig=4 if (s10q15=="Agnostic" | s10q15=="Atheist")

***Drop Mormon/Othodox Christians from the sample
drop if s10q15sp == "Greek Orthodox"
drop if s10q15sp == "Russian Othrodox"
drop if s10q15sp == "greek orthodox"
drop if s10q15sp == "Orthodox Christian"
drop if s10q15sp == "Greek Orthdox"
drop if s10q15sp == "christian orthodox"
drop if s10q15sp == "Greek Orthodox Christian"
drop if s10q15sp == "Russian orthodox"
drop if s10q15sp == "Church of Jesus Christ of Latter Day Saints"
drop if s10q15sp == "Greek Orthodox"

// End of variables

*sample size
count if relig == 1
count if relig == 2
count if relig == 3
count if relig == 4

count if relig == 1 & treatR == 1
count if relig == 2 & treatR == 1
count if relig == 3 & treatR == 1
count if relig == 4 & treatR == 1

count if relig == 1 & treatR == 0
count if relig == 2 & treatR == 0
count if relig == 3 & treatR == 0
count if relig == 4 & treatR == 0

*atheist/agnostic comparison
gen watch = .
replace watch = 1 if s10q18sp >= 4 & s10q18sp != .
replace watch = 0 if s10q18sp < 4
su watch if s10q15=="Agnostic"
su watch if s10q15=="Atheist"

gen lifedeath = .
replace lifedeath = 1 if s10q18sp3 >= 4 & s10q18sp3 != .
replace lifedeath = 0 if s10q18sp3 < 4
su lifedeath if s10q15=="Agnostic"
su lifedeath if s10q15=="Atheist"

*beliefs about experiment
gen believe = .
replace believe = 0 if s10q1 ~= "."
replace believe = 1 if s10q1 == "I believed that my responses would matter, exactly as the questionnaire said."
su believe if relig ~= .
gen other = .
replace other = 0 if s10q3 ~= "."
replace other = 1 if s10q3 == "I believed that our responses would matter, exactly at the questionnaire said."
su other if relig ~= . & s5 ~= . & s6 ~=. & e000 ~= .
