************************************************************************************
************************************************************************************
**********Claims in VI. Main Experiment Results: Protestants and Catholics*********
************************************************************************************
************************************************************************************

*Public goods game 

*simulations
*Protestant Contribution 
set seed 1
clear all
set more off
save results1a, replace emptyok
forvalues i = 1/1000 {

quietly{

clear all
set mem 50m

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

***Panel A





rename s6 contribute
rename s6exp expect

reg contribute treatR if relig == 1, r

keep if relig == 1 & contribute ~= .
replace id = _n


preserve

gen idR = .
keep if treatR == 1
replace idR = _n
save rev1aR, replace

drop _all
set obs 86 //draw 86
generate obsnoR = floor(87*runiform() + 1) //from 87

sort obsnoR
save obsnos_to_drawR, replace

use rev1aR, clear
generate obsnoR = idR
merge 1:m obsnoR using obsnos_to_drawR, keep(match) nogen
save R, replace

restore




gen idC = .
keep if treatR == 0
replace idC = _n
save rev1aC, replace

drop _all
set obs 86 //draw 86
generate obsnoC = floor(84*runiform() + 1) // from 84

sort obsnoC
save obsnos_to_drawC, replace

use rev1aC, clear
generate obsnoC = idC
merge 1:m obsnoC using obsnos_to_drawC, keep(match) nogen
save C, replace

clear all

use R
append using C

reg contribute treatR, r 
matrix V = e(V)
matrix b = e(b)'
matrix se = vecdiag(cholesky(diag(vecdiag(V))))'

svmat b
svmat se
gen t = b1/se1
gen p = 2*ttail(e(df_r),abs(t))

replace id = _n
drop if id > 1
keep p

append using results1a
save results1a, replace
}
display `i'
}


clear all
use results1a
count if p < .05 // result 697/1000

*Catholic Contribution
set seed 1
clear all
set more off
save results1a, replace emptyok
forvalues i = 1/1000 {

quietly{

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

***Drop orthodox/mormon from christian-other category
*drop if s10q15sp == "Greek Orthodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Greek Orthdox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Russian Othrodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "greek orthodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Orthodox Christian" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "christian orthodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Greek Orthodox Christian" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Russian orthodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Church of Jesus Christ of Latter Day Saints" & s10q15=="Christian - Other (please specify below)"

// End of variables

***Panel A





rename s6 contribute
rename s6exp expect

reg contribute treatR if relig == 2, r

keep if relig == 2 & contribute ~= .
replace id = _n


preserve

gen idR = .
keep if treatR == 1
replace idR = _n
save rev1aR, replace

drop _all
set obs 69 //draw 69
generate obsnoR = floor(75*runiform() + 1) //from 91

sort obsnoR
save obsnos_to_drawR, replace

use rev1aR, clear
generate obsnoR = idR
merge 1:m obsnoR using obsnos_to_drawR, keep(match) nogen
save R, replace

restore




gen idC = .
keep if treatR == 0
replace idC = _n
save rev1aC, replace

drop _all
set obs 69 //draw 69
generate obsnoC = floor(63*runiform() + 1) // from 89

sort obsnoC
save obsnos_to_drawC, replace

use rev1aC, clear
generate obsnoC = idC
merge 1:m obsnoC using obsnos_to_drawC, keep(match) nogen
save C, replace

clear all

use R
append using C

reg contribute treatR, r 
matrix V = e(V)
matrix b = e(b)'
matrix se = vecdiag(cholesky(diag(vecdiag(V))))'

svmat b
svmat se
gen t = b1/se1
gen p = 2*ttail(e(df_r),abs(t))

replace id = _n
drop if id > 1
keep p

append using results1a
save results1a, replace
}
display `i'
}


clear all
use results1a
count if p < .05 // result 749/1000

*Catholic Expectation
set seed 1
clear all
set more off
save results1a, replace emptyok
forvalues i = 1/1000 {

quietly{

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

***Drop orthodox/mormon from christian-other category
*drop if s10q15sp == "Greek Orthodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Greek Orthdox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Russian Othrodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "greek orthodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Orthodox Christian" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "christian orthodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Greek Orthodox Christian" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Russian orthodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Church of Jesus Christ of Latter Day Saints" & s10q15=="Christian - Other (please specify below)"

// End of variables

***Panel A





rename s6 contribute
rename s6exp expect

reg expect treatR if relig == 2, r

keep if relig == 2 & expect ~= .
replace id = _n


preserve

gen idR = .
keep if treatR == 1
replace idR = _n
save rev1aR, replace

drop _all
set obs 69 //draw 69
generate obsnoR = floor(75*runiform() + 1) //from 91

sort obsnoR
save obsnos_to_drawR, replace

use rev1aR, clear
generate obsnoR = idR
merge 1:m obsnoR using obsnos_to_drawR, keep(match) nogen
save R, replace

restore




gen idC = .
keep if treatR == 0
replace idC = _n
save rev1aC, replace

drop _all
set obs 69 //draw 69
generate obsnoC = floor(63*runiform() + 1) // from 89

sort obsnoC
save obsnos_to_drawC, replace

use rev1aC, clear
generate obsnoC = idC
merge 1:m obsnoC using obsnos_to_drawC, keep(match) nogen
save C, replace

clear all

use R
append using C

reg expect treatR, r 
matrix V = e(V)
matrix b = e(b)'
matrix se = vecdiag(cholesky(diag(vecdiag(V))))'

svmat b
svmat se
gen t = b1/se1
gen p = 2*ttail(e(df_r),abs(t))

replace id = _n
drop if id > 1
keep p

append using results1a
save results1a, replace
}
display `i'
}


clear all
use results1a
count if p < .05 // result 618/1000

*Risk Aversion and Time Discounting consistency check
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

gen riskmonotonesmall = 1 if s3q1 ~= .
forvalues count = 1/5 {
        local countup = `count' + 1
        replace riskmonotonesmall = 0 if s3q`count' == 1 & s3q`countup' == 0
}
gen riskmonotonelarge = 1 if s4q1 ~= .
forvalues count = 1/5 {
        local countup = `count' + 1
        replace riskmonotonelarge = 0 if s4q`count' == 1 & s4q`countup' == 0
}
gen riskconsistent = .
replace riskconsistent = 1 if riskmonotonesmall == 1 & riskmonotonelarge == 1
replace riskconsistent = 0 if riskmonotonesmall == 0 | riskmonotonelarge == 0
su riskconsistent if relig ~= .

gen timenow = 1 if s2q1 ~= .
forvalues count = 1/11 {
        local countup = `count' + 1
        replace timenow = 0 if s2q`count' == 1 & s2q`countup' == 0
}
gen timeone = 1 if s2q13 ~= .
forvalues count = 13/23 {
        local countup = `count' + 1
        replace timeone = 0 if s2q`count' == 1 & s2q`countup' == 0
}
gen timeconsistent = .
replace timeconsistent = 1 if timenow == 1 & timeone == 1
replace timeconsistent = 0 if timenow == 0 | timeone == 0
su timeconsistent if relig ~= .

*Catholic risk regression controlling for gender dummy
clear all
set mem 30m
set more off

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

***Drop those subjects who don't take part in the risk preference section
drop if s3q1 == .

***Generate upper limit for risk with small amounts
gen risk1=.
replace risk1=(1.6*0.5-1) if s3q1==1
gen risk2=.
replace risk2=(2*0.5-1) if s3q2==1
gen risk3=.
replace risk3=(2.4*0.5-1) if s3q3==1
gen risk4=.
replace risk4=(2.8*0.5-1) if s3q4==1
gen risk5=.
replace risk5=(3.2*0.5-1) if s3q5==1
gen risk6=.
replace risk6=(3.6*0.5-1) if s3q6==1

***Choose the upper limit for the first time a subject chooses the risky asset with small amounts.
gen reservationrisk1= min(risk1,risk2,risk3,risk4,risk5,risk6)

***Generate upper limit for risk with large amounts
gen risk7=.
replace risk7=(160*0.5-100)/100 if s4q1==1
gen risk8=.
replace risk8=(200*0.5-100)/100 if s4q2==1
gen risk9=.
replace risk9=(240*0.5-100)/100 if s4q3==1
gen risk10=.
replace risk10=(280*0.5-100)/100 if s4q4==1
gen risk11=.
replace risk11=(320*0.5-100)/100 if s4q5==1
gen risk12=.
replace risk12=(360*0.5-100)/100 if s4q6==1

***Choose the upper limit for the first time a subject chooses the risky asset with large amounts.
gen reservationrisk2= min(risk7,risk8,risk9,risk10,risk11,risk12)

***Create two entries per subject. One is for small amounts and the other is for large amounts. riskchoice indicates whether it is a small or large stake gamble. 
reshape long reservationrisk, i(id) j(riskchoice)

***largestake is a dummy where a 1 indicates risk choices with large amounts and a 0 indicates risk choices with small amounts.
gen largestake=0
replace largestake= 1 if riskchoice==2 

***Recall reservationrisk indicates the upper limit. Rename this variable risku and create another variable, riskl, which will indicate the lower limit.
rename reservationrisk risk
gen riskl=.
gen risku=risk

***Fill in values for the lower limit.
***Note that even if someone always chose the safe option, they are assigned a missing value for the upper limit and the highest possible value we ask about for the lower limit. So they are properly taken care of.
replace riskl=. if risk < -.2
replace riskl=(1.6*0.5-1) if risk == 0
replace riskl=(2*0.5-1) if risk > .1 & risk < .3
replace riskl=(2.4*0.5-1) if risk > .3 & risk < .5
replace riskl=(2.8*0.5-1) if risk > .5 & risk < .7
replace riskl=(3.2*0.5-1) if risk > .7 & risk < .9
replace riskl=(3.6*0.5-1) if risk == . & s4q1 ~= .

gen male = .
replace male = 0 if s10q8 == "Female"
replace male = 1 if s10q8 == "Male"
intreg riskl risku treatR largestake male if relig==2, cluster(id)

*Catholic risk simulation exercise
set seed 1
clear all
set more off
save results1a, replace emptyok
forvalues i = 1/1000 {

quietly{

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

***Drop orthodox/mormon from christian-other category
*drop if s10q15sp == "Greek Orthodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Greek Orthdox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Russian Othrodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "greek orthodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Orthodox Christian" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "christian orthodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Greek Orthodox Christian" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Russian orthodox" & s10q15=="Christian - Other (please specify below)"
*drop if s10q15sp == "Church of Jesus Christ of Latter Day Saints" & s10q15=="Christian - Other (please specify below)"

// End of variables

***Panel A
replace id = _n


***Drop those subjects who don't take part in the risk preference section
drop if s3q1 == .
keep if relig == 2

**Drop subjects who don't give gender
gen male = .
replace male = 0 if s10q8 == "Female"
replace male = 1 if s10q8 == "Male"
drop if male == .

***Generate upper limit for risk with small amounts
gen risk1=.
replace risk1=(1.6*0.5-1) if s3q1==1
gen risk2=.
replace risk2=(2*0.5-1) if s3q2==1
gen risk3=.
replace risk3=(2.4*0.5-1) if s3q3==1
gen risk4=.
replace risk4=(2.8*0.5-1) if s3q4==1
gen risk5=.
replace risk5=(3.2*0.5-1) if s3q5==1
gen risk6=.
replace risk6=(3.6*0.5-1) if s3q6==1

***Choose the upper limit for the first time a subject chooses the risky asset with small amounts.
gen reservationrisk1= min(risk1,risk2,risk3,risk4,risk5,risk6)

***Generate upper limit for risk with large amounts
gen risk7=.
replace risk7=(160*0.5-100)/100 if s4q1==1
gen risk8=.
replace risk8=(200*0.5-100)/100 if s4q2==1
gen risk9=.
replace risk9=(240*0.5-100)/100 if s4q3==1
gen risk10=.
replace risk10=(280*0.5-100)/100 if s4q4==1
gen risk11=.
replace risk11=(320*0.5-100)/100 if s4q5==1
gen risk12=.
replace risk12=(360*0.5-100)/100 if s4q6==1

***Choose the upper limit for the first time a subject chooses the risky asset with large amounts.
gen reservationrisk2= min(risk7,risk8,risk9,risk10,risk11,risk12)

replace id = _n

preserve

gen idR = .
keep if treatR == 1
replace idR = _n
save rev1bR, replace

drop _all
set obs 38 //draw 38
generate obsnoR = floor(32*runiform() + 1) //from 32

sort obsnoR
save obsnos_to_drawR, replace

use rev1bR, clear
generate obsnoR = idR
merge 1:m obsnoR using obsnos_to_drawR, keep(match) nogen
save R, replace

restore

gen idC = .
keep if treatR == 0
replace idC = _n
save rev1bC, replace

drop _all
set obs 38 //draw 38
generate obsnoC = floor(44*runiform() + 1) // from 44

sort obsnoC
save obsnos_to_drawC, replace

use rev1bC, clear
generate obsnoC = idC
merge 1:m obsnoC using obsnos_to_drawC, keep(match) nogen
save C, replace

clear all

use R
append using C

replace id = _n

***Create two entries per subject. One is for small amounts and the other is for large amounts. riskchoice indicates whether it is a small or large stake gamble. 
reshape long reservationrisk, i(id) j(riskchoice)

***largestake is a dummy where a 1 indicates risk choices with large amounts and a 0 indicates risk choices with small amounts.
gen largestake=0
replace largestake= 1 if riskchoice==2 

***Recall reservationrisk indicates the upper limit. Rename this variable risku and create another variable, riskl, which will indicate the lower limit.
rename reservationrisk risk
gen riskl=.
gen risku=risk

***Fill in values for the lower limit.
***Note that even if someone always chose the safe option, they are assigned a missing value for the upper limit and the highest possible value we ask about for the lower limit. So they are properly taken care of.
replace riskl=. if risk < -.2
replace riskl=(1.6*0.5-1) if risk == 0
replace riskl=(2*0.5-1) if risk > .1 & risk < .3
replace riskl=(2.4*0.5-1) if risk > .3 & risk < .5
replace riskl=(2.8*0.5-1) if risk > .5 & risk < .7
replace riskl=(3.2*0.5-1) if risk > .7 & risk < .9
replace riskl=(3.6*0.5-1) if risk == . & s4q1 ~= .

intreg riskl risku treatR largestake male, cluster(id)


matrix V = e(V)
matrix b = e(b)'
matrix se = vecdiag(cholesky(diag(vecdiag(V))))'

svmat b
svmat se
gen z = b1/se1
gen p = 2*(1-normal(abs(z)))

replace id = _n
drop if id > 1
keep p

append using results1a
save results1a, replace
}
display `i'
}

clear all
use results1a
count if p < .05 // result 588/1000

*Dictator Game
*only when it is the very first task after the prime
clear all
set mem 30m
set more off

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

rename s5 giveaway
keep if sessiontype == "DG"
reg giveaway treatR if relig == 1 | relig == 2 | relig == 3 | relig == 4, r

*Labor market tasks
*anagrams untabulated regression
clear all
set mem 30m
set more off

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

reg numcorrect treatR if relig == 1, r
reg numcorrect treatR if relig == 2, r
reg numcorrect treatR if relig == 3, r
reg numcorrect treatR if relig == 4, r


