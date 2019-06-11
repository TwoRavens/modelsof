* This do-file re-produces the results in Figure 2 (and actually produces Figure 2 if bottom commands are de-selected)
use allmodes, clear

* Trim the weighting for all surveys at 7
replace weight=7 if weight>7

* Clean up coding of knowledge variable
replace know4_n=know4 if mode==2 
replace know4_n=know4_n*100 if know4_n<1 & mode~=1

* Generate variable for whether R's guess on unemployment is within 1 point of actual rate
gen unemploy_correct=1 if know4_n>=8.7 & know4_n<=10.7
replace unemploy_correct=0 if know4_n<8.7 | (know4_n>10.7 & know4_n~=.)

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

* Set data for weighted analyses (pweights)
svyset [pw=weight]

* Point estimates presented in Figure 2
svy: proportion unemploy_correct, over(mode)
parmest, saving(unemploy, replace)
svy: proportion house_correct, over(mode)
parmest, saving(house, replace)
svy: proportion govparty_correct, over(mode)
parmest, saving(govparty, replace)

svy: proportion pewnews if pewnews<7, over(mode)
parmest, saving(news, replace)

svy: proportion contrib1, over(mode)
parmest, saving(contrib1, replace)
svy: proportion contrib3, over(mode)
parmest, saving(contrib3, replace)


/*
*** The following commands create Figure 2
use contrib3, clear
replace eq="Contribution-Political" if eq=="Yes"
drop if eq=="No"

append using contrib1
replace eq="Contribution-Religious" if eq=="Yes"
drop if eq=="No"
encode parm, gen(mode)
encode eq, gen(response)
gen axis2=(response*5)+mode

twoway bar estimate axis2 if mode==1,  horizontal  barw(.5) fc(gs4) || bar estimate axis2 if mode==2,  horizontal barw(.5) lc(none)  fc(gs10) || bar estimate axis2 if mode==3, horizontal barw(.5) lc(none)  fc(gs16) || rcap min95 max95 axis2, horizontal ylabel(7 "Political" 12 "Religious", angle(0)) ytitle("")  lc(black) legend(label(1 "Internet") label(2 "Phone") label(3 "Mail") label(4 "95% CI") symx(small)) graphr(c(white)) title("Reported Contributions", c(black)) saving(behavior.gph, replace) scheme(s1mono)

use house, clear
replace eq="Correct-Party Control House" if eq=="_prop_1"
drop if eq=="Tie" | eq=="_prop_2" | eq=="_prop_4"

append using unemploy
replace eq="Correct-Unemployment Rate" if eq=="_prop_2"
drop if eq=="_prop_1"

append using govparty
replace eq="Correct-Gov. Party" if eq=="_prop_2"
drop if eq=="_prop_1"
encode parm, gen(mode)
encode eq, gen(response)
gen axis2=(response*5)+mode

twoway bar estimate axis2 if mode==1,  horizontal  barw(.5) lc(none) fc(gs4) || bar estimate axis2 if mode==2,  horizontal barw(.5) lc(none) fc(gs10)  || bar estimate axis2 if mode==3, horizontal barw(.5) lc(none) fc(gs16) || rcap min95 max95 axis2, horizontal ylabel(7 "Gov. Party" 12 "House Party" 17 "Unemployment", angle(0)) ytitle("")  lc(black) legend(label(1 "Internet") label(2 "Phone") label(3 "Mail") label(4 "95% CI") symx(small)) graphr(c(white)) title("Political Knowledge", c(black)) saving(knowledge.gph, replace) scheme(s1mono)

use news, clear
drop if eq=="Radio" | eq=="Magazines"
encode parm, gen(mode)
encode eq, gen(response)
gen axis2=(response*5)+mode

twoway bar estimate axis2 if mode==1,  horizontal  barw(.5) lc(none) fc(gs4) || bar estimate axis2 if mode==2,  horizontal barw(.5) lc(none) fc(gs10)  || bar estimate axis2 if mode==3, horizontal barw(.5) lc(none) fc(gs16) || rcap min95 max95 axis2, horizontal ylabel(7 "Internet" 12 "Newspapers" 17 "Television", angle(0)) ytitle("")  lc(black) legend(label(1 "Internet") label(2 "Phone") label(3 "Mail") label(4 "95% CI") symx(small) ) graphr(c(white)) title("Primary News Source", c(black)) saving(news.gph, replace)  scheme(s1mono)
graph combine knowledge.gph news.gph behavior.gph, c(3) xcommon graphr(c(white))
graph export figure2.pdf, replace

*/


