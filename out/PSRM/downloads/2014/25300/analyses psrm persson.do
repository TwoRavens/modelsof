*clear 
set more off
* REPLICATION DATA FOR: 
* Persson, Mikael. "Does Survey Participation Increase Voter Turnout?
* Re-examining the Hawthorne Effect in the Swedish National Election Studies."
* accepted for publication in Political Science Research and Methods

*use "SNES 1960-2010.dta"

* note that the last two of the gr

*** produce "propensity to vote"-variables for each year
*** logit model for those who were interviewed after the election
logit vote age agesq prevvote sex polint edu   married disc if year == 1960  & intervju == 0 , vce(robust)
*** calculate probability of voting
predict p60 if year == 1960  & intervju == 0 
*** impute an a priori probability to vote variabel for those interviewed before the election
impute p60  age agesq prevvote  sex polint edu   married disc   if year == 1960 & intervju == 1, generate(p60b) all
*** combines the two constructed variables to one by giving p60 (predicted for those interviewed after the election) the values of p60b (imputed for those interviewed before election) if p60 == .
replace p60 = p60b if p60 == .
*** standardizing - mean=0 and sd=1.
egen p60m = mean(p60)
egen p60sd = sd(p60)
replace p60 = p60 - p60m
replace p60 = p60 / p60sd

*** repeat this for all of the years
logit vote age agesq prevvote sex polint edu   married disc if year == 1964  & intervju == 0 , vce(robust)
predict p64 if year == 1964  & intervju == 0 
impute p64  age agesq prevvote  sex polint edu   married disc   if year == 1964 & intervju == 1, generate(p64b) all
replace p64 = p64b if p64 == .
egen p64m = mean(p64)
egen p64sd = sd(p64)
replace p64 = p64 - p64m
replace p64 = p64 / p64sd

logit vote age agesq prevvote  sex polint edu  married tv disc if year == 1973  & intervju == 0 , vce(robust)
predict p73 if year == 1973  & intervju == 0  
impute p73  age agesq prevvote  sex polint edu  married tv disc   if year == 1973 & intervju == 1, generate(p73b) all
replace p73 = p73b if p73 == .
egen p73m = mean(p73)
egen p73sd = sd(p73)
replace p73 = p73 - p73m
replace p73 = p73 / p73sd

logit vote age agesq prevvote  sex polint edu  married tv city     if year == 1976  & intervju == 0  , vce(robust)
predict p76 if year == 1976  & intervju == 0 
impute p76 age agesq prevvote  sex polint edu  married tv city     if year == 1976 & intervju == 1 , generate(p76b) all
replace p76 = p76b if p76 == .
egen p76m = mean(p76)
egen p76sd = sd(p76)
replace p76 = p76 - p76m
replace p76 = p76 / p76sd

logit vote age agesq prevvote  sex polint edu  married paper tv disc city if year == 1979  & intervju == 0 , vce(robust)
predict p79 if year == 1979  & intervju == 0 
impute p79 age agesq prevvote  sex polint edu  married paper tv disc city if year == 1979  & intervju == 1, generate(p79b) all
replace p79 = p79b if p79 == .
egen p79m = mean(p79)
egen p79sd = sd(p79)
replace p79 = p79 - p79m
replace p79 = p79 / p79sd

logit vote age agesq prevvote  sex polint edu  married paper tv city if year == 1982  & intervju == 0  , vce(robust) 
predict p82 if year == 1982  & intervju == 0 
impute p82 age agesq prevvote  sex polint edu  married paper tv city if year == 1982 & intervju == 1, generate(p82b) all
replace p82 = p82b if p82 == .
egen p82m = mean(p82)
egen p82sd = sd(p82)
replace p82 = p82 - p82m
replace p82 = p82 / p82sd

logit vote age agesq prevvote  sex polint edu  married paper tv disc city if year == 1985  & intervju == 0 , vce(robust)
predict p85 if year == 1985  & intervju == 0 
impute p85 age agesq prevvote  sex polint edu  married paper tv disc city disc if year == 1985 & intervju == 1 , generate(p85b) all 
replace p85 = p85b if p85 == .
egen p85m = mean(p85)
egen p85sd = sd(p85)
replace p85 = p85 - p85m
replace p85 = p85 / p85sd

logit vote age agesq prevvote  sex polint edu  married paper tv disc city if year == 1988  & intervju == 0 , vce(robust)
predict p88 if year == 1988  & intervju == 0 
impute p88 age agesq prevvote  sex polint edu  married paper tv disc city disc if year == 1988 & intervju == 1, generate(p88b) all
replace p88 = p88b if p88 == .
egen p88m = mean(p88)
egen p88sd = sd(p88)
replace p88 = p88 - p88m
replace p88 = p88 / p88sd

logit vote age agesq prevvote  sex polint edu  married paper tv disc city if year == 1991  & intervju == 0 , vce(robust)
predict p91 if year == 1991  & intervju == 0 
impute p91 age agesq prevvote  sex polint edu  married paper tv disc city if year == 1991 & intervju == 1, generate(p91b) all
replace p91 = p91b if p91 == .
egen p91m = mean(p91)
egen p91sd = sd(p91)
replace p91 = p91 - p91m
replace p91 = p91 / p91sd

logit vote age agesq prevvote  sex polint edu  married paper tv disc city if year == 1994  & intervju == 0 , vce(robust)
predict p94 if year == 1994  & intervju == 0 
impute p94 age agesq prevvote  sex polint edu  married paper tv disc city if year == 1994 & intervju == 1 , generate(p94b) all
replace p94 = p94b if p94 == .
egen p94m = mean(p94)
egen p94sd = sd(p94)
replace p94 = p94 - p94m
replace p94 = p94 / p94sd

logit vote age agesq prevvote  sex polint edu  married paper tv city if year == 1998  & intervju == 0 , vce(robust)
predict p98 if year == 1998  & intervju == 0 
impute p98 age agesq prevvote  sex polint edu  married paper tv city if year == 1998 & intervju == 1, generate(p98b) all
replace p98 = p98b if p98 == .
egen p98m = mean(p98)
egen p98sd = sd(p98)
replace p98 = p98 - p98m
replace p98 = p98 / p98sd

logit vote age agesq prevvote  sex polint edu  married paper tv city if year == 2002  & intervju == 0 , vce(robust)
predict p02 if year == 2002  & intervju == 0 
impute p02 age agesq prevvote  sex polint edu  married paper tv city if  year == 2002 & intervju == 1, generate(p02b) all
replace p02 = p02b if p02 == .
egen p02m = mean(p02)
egen p02sd = sd(p02)
replace p02 = p02 - p02m
replace p02 = p02 / p02sd

logit vote age agesq  sex polint edu  married paper tv city if year == 2006  & intervju == 0 , vce(robust)
predict p06 if year == 2006  & intervju == 0 
impute p06 age agesq  sex polint edu  married paper tv city if year == 2006 & intervju == 1, generate(p06b) all
replace p06 = p06b if p06 == .
egen p06m = mean(p06)
egen p06sd = sd(p06)
replace p06 = p06 - p06m
replace p06 = p06 / p06sd


logit vote age agesq prevvote  sex polint edu  married paper tv city if year == 2010  & intervju == 0 , vce(robust)
predict p2010 if year == 2010  & intervju == 0
impute p2010 age agesq prevvote  sex polint edu  married paper tv city if year == 2010 & intervju == 1, generate(p10b) all
replace p2010 = p10b if p2010 == . 
sum p2010
egen p10m = mean(p2010)
egen p10sd = sd(p2010)
replace p2010 = p2010 - p10m
replace p2010 = p2010 / p10sd

*** combine the "propensity to vote"-variables for each year to one single variable called "apriori"
gen apriori =.
replace apriori = p64 if apriori == .
replace apriori = p60 if apriori == .
replace apriori = p73 if apriori == .
replace apriori = p76 if apriori == .
replace apriori = p79 if apriori == .
replace apriori = p82 if apriori == .
replace apriori = p85 if apriori == .
replace apriori = p88 if apriori == .
replace apriori = p91 if apriori == .
replace apriori = p94 if apriori == .
replace apriori = p98 if apriori == .
replace apriori = p02 if apriori == .
replace apriori = p06 if apriori == .
replace apriori = p2010 if apriori == .


****  table 1.
reg vote i.intervju i.year, vce(robust)
reg vote i.intervju##c.apriori i.year##c.apriori  i.year, vce(robust)

* set scheme
set scheme lean2

****  table 2 for appendix + fig 1 & 2 appendix
reg vote i.intervju##c.polint i.year, vce(robust)
margins i.intervju , at(polint=(1 2 3 4))
set scheme lean1
marginsplot,    graphregion(color(white)) plotregion(color(white)) ///
ytitle("Probability of voting") title("") xtitle("Political interest") ///
legend(off) text(.85 3 "Post election") text(.95 3 "Pre election")
graph save Graph "F1appendix.gph" , replace
graph export "F1appendix.pdf" , replace

reg vote i.intervju##c.edu i.year, vce(robust)
margins i.intervju , at(edu=(1 2 3))
set scheme lean1
 marginsplot,    graphregion(color(white)) plotregion(color(white)) ///
ytitle("Probability of voting") title("") xtitle("Education 1: compulsory, 2: secondady level, 3: post secondary") ///
legend(off) text(.93 2.5 "Post election") text(.96 2.5 "Pre election")
graph save Graph "F2appendix.gph" , replace
graph export "F2appendix.pdf" , replace


*** figure 3
twoway ///
(lpoly vote apriori if intervju == 1 & apriori > -2 & apriori < 1 ,lcolor(red) degree(0) n(100)) ///
 (lpoly vote apriori if intervju == 0 & apriori > -2 & apriori < 1, lcolor(blue) degree(0) n(100)) ///
, legend(pos(6)) ///
ytitle("") ///
xtitle("A priori propensity to vote") ///
ytitle("Probability of voting") ///
legend(lab(1 "Pre-election survey") lab(2 "Post-election survey"))
graph save Graph "F3.gph" , replace
graph export "F3.pdf" , replace

****  table 1 for appendix 1
reg vote i.pintervju , vce(robust)
margins i.pintervju

*** fig 4
marginsplot, recast(dot)    graphregion(color(white)) plotregion(color(white)) ///
ytitle("Probability of voting") title("") xtitle("") ///
xlabel(0 "Post-election, first time" 1 "Pre-election, second time" /// 
2 "Post-election, second time" 3 "Pre-election, first time" 4 " ", alternate)
graph save Graph "F4.gph" , replace
graph export "F4.pdf" , replace
set scheme lean1

*** figure 5
twoway (lpoly vote apriori if pintervju == 0 & apriori > -2 & apriori < 1 & year > 1973, lcolor(blue) degree(0) n(25)) ///
(lpoly vote apriori if pintervju == 1 & apriori > -2 & apriori < 1 & year > 1973, lcolor(red) degree(0) n(25)) ///
(lpoly vote apriori if pintervju == 2 & apriori > -2 & apriori < 1 & year > 1973, lcolor(grey)degree(0) n(25)) ///
(lpoly vote apriori if pintervju == 3 & apriori > -2 & apriori < 1 & year > 1973, lcolor(black) degree(0) n(25)) ///
, legend(pos(6)) ///
ytitle("") ///
xtitle("A priori propensity to vote") ///
ytitle("Probability of voting") ///
legend(lab(1 "Post-election survey and not participated before") lab(2 "Pre-election survey and participated before") /// 
lab(3 "Post-election survey and participated beforey") lab(4 "Pre-election survey and not participated before"))
graph save Graph "F5.gph" , replace
graph export "F5.pdf" , replace

* prepare data for the first two descriptive graphs
* make a new dataset containing only mean levels for each year. calculate mean levels and save only one observation per year
 egen beforeb = mean(vote) if intervju == 1 ,  by(year)
 egen before = mean(beforeb) ,  by(year)
 egen afterb = mean(vote)  if intervju == 0  ,  by(year)
 egen after = mean(afterb)   ,  by(year)
duplicates drop year   , force
replace before = before * 100
replace after = after * 100

* figure 1
graph twoway  ///
(scatter before year, msymbol(X) ) (scatter after year)  ///
, xlabel(1960 1964 1973 1976 1979 1982 1985 1988 1991 1994 1998 2002 2006 2010 , alternate angle(0)) ///
graphregion(color(white)) ///
plotregion(color(white) ilcolor(none)) ///
ylabel(85(5)100) ///
ytitle("") ///
xtitle("Voter turnout") ///
legend(lab(1 "Pre-election survey") lab(2 "Post-election survey") lab(3 "Standard error") rows(1)pos(6))
graph save Graph "F1.gph" , replace
graph export "F1.pdf" , replace

gen t = before - after
gen o = 0

* figure 2
graph twoway (scatter t year)  ///
, xlabel(1960 1964 1973 1976 1979 1982 1985 1988 1991 1994 1998 2002 2006 2010  , alternate angle(0)) ///
graphregion(color(white)) ///
plotregion(color(white) ilcolor(none)) ///
ylabel(-1(1)5) ///
ytitle("") ///
xtitle("Treatment effect") ///
legend(lab(1 "Post-election survey") lab(2 "Pre-election survey") lab(3 "Standard error"))
graph save Graph "F2.gph" , replace
graph export "F2.pdf" , replace
