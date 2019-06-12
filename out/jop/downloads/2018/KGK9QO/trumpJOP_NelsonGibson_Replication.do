use "/Users/mjnelson/Dropbox/Legitimacy/Politicization/trumpJOP.dta"

***Body of Paper
*The Survey Experiment
sum meanchg if keep==1 [aw=nov2017wt1]
tab meanchg if keep==1 [aw=nov2017wt1]
tab trumpconf if keep==1 [aw=nov2017wt1]
tab profconf if keep==1 [aw=nov2017wt1]
display  45.69+14.01
display 17.62+20.02

*Results
sum meanchg if trumpcrit==1 & keep==1 [aw=nov2017wt1]
sum meanchg if profcrit==1 & keep==1 [aw=nov2017wt1]
reg meanchg i.trumpcrit if keep==1 [aw=nov2017wt1]
display .027688/.1541176

*Conditional effects
*sd of meanchg = .1541176
display .0742868/.1541176
display -.0580335/.1541176
display -.0592498/.1541176
display (.0580335+.0742868)/.1541176

*Mechanism
sum critagree if keep==1 [aw=nov2017wt1]
*SD of critagree is .2846583
sum critagree if keep==1 & trumpcrit==1 [aw=nov2017wt1]
sum critagree if keep==1 & profcrit==1 [aw=nov2017wt1]
reg critagree i.trumpcrit if keep==1 [aw=nov2017wt1]
display -.0749455/.2846583
display (.0742528+.2126641)/.2846583
display (.2254138+.1828341)/.2846583

***Appendix A
*Psychometrics
factor SCT1S69 SCT2S69 SCT3S69 SCT4S69 SCT5S69 SCT6S69 if keep==1, factors(1)
factor SCT1S66 SCT2S66 SCT3S66 SCT4S66 SCT5S66 SCT6S66 if keep==1, factors(1)
alpha SCT1S69 SCT2S69 SCT3S69 SCT4S69 SCT5S69 SCT6S69 if keep==1
alpha SCT1S66 SCT2S66 SCT3S66 SCT4S66 SCT5S66 SCT6S66 if keep==1

*ATTRITION
*DV=1 if failed to respond in November
gen respondt2=1 if _merge==2
replace respondt2=0 if _merge==3
logit respondt2 polint rep dem ideo female black hispanic educ age inc relig
mean inc if _merge==1|_merge==3 [aw=nov2017wt1]
mean inc if _merge==2|_merge==3 [aw=nov2017wt1]
display .4538366-.456884

*TABLE A1
tab SCT1S69 if keep==1 [aw=nov2017wt1]
tab SCT2S69 if keep==1 [aw=nov2017wt1]
tab SCT3S69 if keep==1 [aw=nov2017wt1]
tab SCT4S69 if keep==1 [aw=nov2017wt1]
tab SCT5S69 if keep==1 [aw=nov2017wt1]
tab SCT6S69 if keep==1 [aw=nov2017wt1]
tab SCT1S66 if keep==1 [aw=nov2017wt1]
tab SCT2S66 if keep==1 [aw=nov2017wt1]
tab SCT3S66 if keep==1 [aw=nov2017wt1]
tab SCT4S66 if keep==1 [aw=nov2017wt1]
tab SCT5S66 if keep==1 [aw=nov2017wt1]
tab SCT6S66 if keep==1 [aw=nov2017wt1]
sum SCT1S69 if keep==1 [aw=nov2017wt1]
sum SCT2S69 if keep==1 [aw=nov2017wt1]
sum SCT3S69 if keep==1 [aw=nov2017wt1]
sum SCT4S69 if keep==1 [aw=nov2017wt1]
sum SCT5S69 if keep==1 [aw=nov2017wt1]
sum SCT6S69 if keep==1 [aw=nov2017wt1]
sum SCT1S66 if keep==1 [aw=nov2017wt1]
sum SCT2S66 if keep==1 [aw=nov2017wt1]
sum SCT3S66 if keep==1 [aw=nov2017wt1]
sum SCT4S66 if keep==1 [aw=nov2017wt1]
sum SCT5S66 if keep==1 [aw=nov2017wt1]
sum SCT6S66 if keep==1 [aw=nov2017wt1]

*TABLE A2
sum meanchg if keep==1 [aw=nov2017wt1]
sum critagree if keep==1 [aw=nov2017wt1]
sum profconf if keep==1 [aw=nov2017wt1]
sum trumpconf if keep==1 [aw=nov2017wt1]
sum polint if keep==1 [aw=nov2017wt1]
sum rep if keep==1 [aw=nov2017wt1]
sum dem if keep==1 [aw=nov2017wt1]
sum ideo if keep==1 [aw=nov2017wt1]
sum female if keep==1 [aw=nov2017wt1]
sum black if keep==1 [aw=nov2017wt1]
sum hispanic if keep==1 [aw=nov2017wt1]
sum educ if keep==1 [aw=nov2017wt1]
sum relig if keep==1 [aw=nov2017wt1]
sum age if keep==1 [aw=nov2017wt1]
sum inc if keep==1 [aw=nov2017wt1]


***APPENDIX B
*MEAN OF ACCEPTABILITY ITEMS
sum GIBSON5S69
gen Constitution = (GIBSON5S69 - `r(min)') / (`r(max)'-`r(min)')
sum GIBSON6S69
gen NoRight = (GIBSON6S69 - `r(min)') / (`r(max)'-`r(min)')
sum GIBSON7S69
gen Conservative = (GIBSON7S69 - `r(min)') / (`r(max)'-`r(min)')
sum GIBSON8S69
gen Religious = (GIBSON8S69 - `r(min)') / (`r(max)'-`r(min)')
sum GIBSON9S69
gen Compromise = (GIBSON9S69 - `r(min)') / (`r(max)'-`r(min)')
sum GIBSON10S69
gen Politicians = (GIBSON10S69 - `r(min)') / (`r(max)'-`r(min)')
sum GIBSON11S69
gen SoCalled = (GIBSON11S69 - `r(min)') / (`r(max)'-`r(min)')
sum Constitution if keep==1  [aw=nov2017wt1]
sum NoRight if keep==1  [aw=nov2017wt1]
sum Conservative if keep==1  [aw=nov2017wt1]
sum Religious if keep==1  [aw=nov2017wt1]
sum Compromise if keep==1  [aw=nov2017wt1]
sum Politicians if keep==1  [aw=nov2017wt1]
sum SoCalled if keep==1 [aw=nov2017wt1]

gen crit=.
replace crit=1 if DOV_CRITICISM==1|DOV_CRITICISM==7
replace crit=2 if DOV_CRITICISM==2|DOV_CRITICISM==8
replace crit=3 if DOV_CRITICISM==3|DOV_CRITICISM==9
replace crit=4 if DOV_CRITICISM==4|DOV_CRITICISM==10
replace crit=5 if DOV_CRITICISM==5|DOV_CRITICISM==11
replace crit=6 if DOV_CRITICISM==6|DOV_CRITICISM==12
label define crit 1 "Constitution" 2 "NoRight" 3 "Conservative" 4 "Religious" 5 "Compromise" 6 "Politicians"
label values crit crit
label define critF 1 "TConstitution" 2 "TNo Right" 3 "TConservative" 4 "TReligious" 5 "TCompromise" 6 "TPoliticians" 7 "LPConstitution" 8 "LPNo Right" 9 "LPConservative" 10 "LPReligious" 11 "LPCompromise" 12 "LPPoliticians"
label values DOV_CRITICISM critF 
tabulate DOV_CRITICISM, generate(treat)
*label define critF 1 `""Trump" "Constitution""' 2 `""Trump" "No Right""' 3 `""Trump" "Conservative""' 4 `""Trump" "Majority""' 5 `""Trump" "Compromise""' 6 `""Trump" "Politicians""' 7 `""Law Prof." "Constitution""' 8 `""Law Prof." "No Right""' 9 `""Law Prof." "Conservative""' 10 `""Law Prof." "Majority""' 11 `""Law Prof." "Compromise""' 12 `""Law Prof." "Politicians""'
*Figure B1
mean meanchg if keep==1 [aweight = nov2017wt1], over(crit)
*Figure B2
mean meanchg if keep==1 [aweight = nov2017wt1], over(DOV_CRITICISM)





***APPENDIX C
mean profconf if dem==1 & keep==1 [aw=nov2017wt1]
mean profconf if rep==1 & keep==1 [aw=nov2017wt1]
mean trumpconf if dem==1 & keep==1 [aw=nov2017wt1]
mean trumpconf if rep==1 & keep==1 [aw=nov2017wt1]
cor profconf trumpconf if rep==1 & keep==1 [aw=nov2017wt1]
cor profconf trumpconf if dem==1 & keep==1 [aw=nov2017wt1]

mean profconf if trumpconf<.25 & keep==1 [aw=nov2017wt1]
mean profconf if trumpconf>=.25 & keep==1 [aw=nov2017wt1]


*TABLE C1
reg meanchg c.trumpconf##i.trumpcrit if keep==1 [aw=nov2017wt1]
margins, dydx(trumpcrit) at(trumpconf=(0 .25 .5 .75 1))

*TABLE C2
reg meanchg c.profconf##i.profcrit if keep==1 [aw=nov2017wt1]
margins, dydx(profcrit) at(profconf=(0 .25 .5 .75 1))

*TABLE C3
reg critagree c.trumpconf##i.trumpcrit if keep==1 [aw=nov2017wt1]
margins, dydx(trumpcrit) at(trumpconf=(0 .25 .5 .75 1))

*TABLE C4
reg critagree c.profconf##i.profcrit if keep==1 [aw=nov2017wt1]
margins, dydx(profcrit) at(profconf=(0 .25 .5 .75 1))

*TABLE C5
reg meanchg c.trumpconf##i.trumpcrit profconf if keep==1 [aw=nov2017wt1]
margins, dydx(trumpcrit) at(trumpconf=(0 .25 .5 .75 1))

*TABLE C6
reg meanchg c.profconf##i.profcrit trumpconf if keep==1 [aw=nov2017wt1]
margins, dydx(profcrit) at(profconf=(0 .25 .5 .75 1))

*TABLE C7
reg critagree c.trumpconf##i.trumpcrit profconf if keep==1 [aw=nov2017wt1]
margins, dydx(trumpcrit) at(trumpconf=(0 .25 .5 .75 1))

*TABLE C8
reg critagree c.profconf##i.profcrit trumpconf if keep==1 [aw=nov2017wt1]
margins, dydx(profcrit) at(profconf=(0 .25 .5 .75 1))

*TABLE C9
reg meanchg c.trumpconf##i.trumpcrit profconf polint rep dem ideo female black hispanic educ relig age inc  if keep==1 [aw=nov2017wt1]
margins, dydx(trumpcrit) at(trumpconf=(0 .25 .5 .75 1))

*TABLE C10
reg meanchg c.profconf##i.profcrit trumpconf polint rep dem ideo female black hispanic educ relig age inc if keep==1 [aw=nov2017wt1]
margins, dydx(profcrit) at(profconf=(0 .25 .5 .75 1))

*TABLE C11
reg critagree c.trumpconf##i.trumpcrit profconf polint rep dem ideo female black hispanic educ relig age inc if keep==1 [aw=nov2017wt1]
margins, dydx(trumpcrit) at(trumpconf=(0 .25 .5 .75 1))

*TABLE C12
reg critagree c.profconf##i.profcrit trumpconf polint rep dem ideo female black hispanic educ relig age inc if keep==1 [aw=nov2017wt1]
margins, dydx(profcrit) at(profconf=(0 .25 .5 .75 1))
