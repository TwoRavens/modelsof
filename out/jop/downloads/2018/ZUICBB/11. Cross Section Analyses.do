******************************************
*** Attacks Ads - Ken Miller *************
*** 10. Cross Section Analyses ***********
******************************************

clear
set more off
set scheme lean1

use "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/advertising.dta"

drop if id==.

merge 1:1 id using "/Users/kenmiller/Dropbox/Dissertation Research/Tone Analyses/APR Counts/attackads.dta"

drop _merge

tabstat canvol if race==1, by(rothtight) stat(sum) format (%9.0f)
tabstat outvol if race==1, by(rothtight) stat(sum) format (%9.0f)
tabstat canvol if race==2, by(rothtight) stat(sum) format (%9.0f)
tabstat outvol if race==2, by(rothtight) stat(sum) format (%9.0f)

* ATTACK PCT, by COMPETITION
tabstat cannegratio if race==1, by(rothchance) stat(mean)
tabstat outnegratio if race==1, by(rothchance) stat(mean)
tabstat cannegratio if race==2, by(rothchance) stat(mean)
tabstat outnegratio if race==2, by(rothchance) stat(mean)


* This gets cases back in to the regression where outside and opposing spending is zero
recode supportnegratio .=0
recode oppnegratio .=0

* Binary party variable for interaction models
gen republican = party
recode republican 1=0 2=1 3=.
gen democrat = party
recode democrat 2=0 3=.

* Model Fractional Logit
* Drops cases 1152, 1252, and 1771 because these cases have bizarrely little canvol
* Variable tables
summ cannegratio rothtight rothchance oppnegratio supportnegratio ico threeway if race==1 & canvol>0 & oppnegratio<20 & supportnegratio<20 & cannegratio!=.
tab ico if race==1 & canvol>0 & oppnegratio<20 & supportnegratio<20 & cannegratio!=.
tab threeway if race==1 & canvol>0 & oppnegratio<20 & supportnegratio<20 & cannegratio!=.

summ cannegratio rothtight rothchance oppnegratio supportnegratio ico if race==2 & canvol>0 & oppnegratio<20 & supportnegratio<20 & cannegratio!=.
tab ico if race==2 & canvol>0 & oppnegratio<20 & supportnegratio<20 & cannegratio!=.

* Fig. 2 Distribution of the DV and key IV
recode cancount .=0
twoway histogram cannegratio if race==1 & cancount>49, percent width(.02) name(sendvdist)
twoway histogram cannegratio if race==2 & oppnegratio<20 & supportnegratio<20 & cancount>49, percent width(.02) name(housedvdist)

twoway histogram supportnegratio if race==1 & canvol>0  & cancount>49, percent width(.1) name(senivdist)
twoway histogram supportnegratio if race==2 & canvol>0 & cancount>49 & oppnegratio<20 & cancount>49, percent width(.1) name(houseivdist)

graph combine sendvdist housedvdist senivdist houseivdist, cols(2)

* Main Model
* Adds if cancount>49 to create a restricted sample of those canddiates who ran 50+ spots
* SENATE
glm cannegratio supportnegratio i.rothchance oppnegratio i.ico threeway i.year if ///
race==1 & canvol>0 & cancount>49, link(logit) family(binomial) robust nolog 
quietly margins rothchance
marginsplot, name(senateroth)
quietly margins, at(supportnegratio=(0(.1)4))
marginsplot, recast(line) recastci(rarea) name(senatemargin) fysize(65)
* One Standard Deviation of Change Senate
margins, at(supportnegratio=(.54(.92)1.75))

* HOUSE
glm cannegratio supportnegratio i.rothchance oppnegratio i.ico i.year if race==2 ///
& canvol>0 & oppnegratio<20 & supportnegratio<20 & cancount>49, link(logit) family(binomial) robust nolog 
quietly margins rothchance
marginsplot, name(houseroth)
quietly margins, at(supportnegratio=(0(.1)4))
marginsplot, recast(line) recastci(rarea) name(housemargin) fysize(65)
* One Standard Deviation of Change House
margins, at(supportnegratio=(0.69(1.53)3.75))

* Fig. 3
graph combine senateroth houseroth, cols(1) ycommon

* Fig. 4
graph combine senatemargin housemargin, ycommon


* Interaction Models
* SENATE Partisan
glm cannegratio i.republican##c.supportnegratio i.rothchance oppnegratio i.ico i.year ///
if race==1 & canvol>0, link(logit) family(binomial) robust nolog 
testparm i.republican##c.supportnegratio

* Margins Plot
* http://www.ats.ucla.edu/stat/stata/faq/margins_graph12.htm
quietly margins republican, at(supportnegratio=(0(.1)4))
marginsplot, recast(line) noci name(senateparty) fysize(65)


* HOUSE Partisan
glm cannegratio i.republican##c.supportnegratio i.rothchance oppnegratio i.ico i.year ///
if race==2 & canvol>0 & oppnegratio<20 & supportnegratio<20, link(logit) family(binomial) robust nolog 
testparm i.republican##c.supportnegratio

* Margins Plot
quietly margins republican, at(supportnegratio=(0(.1)4))
marginsplot, recast(line) noci name(houseparty) fysize(65)

* Fig. 5
graph combine senateparty houseparty, ycommon



* MODEL ROBUSTNESS CHECKS
* ZOIB
* Senate
zoib cannegratio supportnegratio i.rothchance oppnegratio i.ico threeway i.year if ///
race==1 & canvol>0 & cancount>49
* House
zoib cannegratio supportnegratio i.rothchance oppnegratio i.ico i.year if race==2 ///
& canvol>0 & oppnegratio<20 & supportnegratio<20 & cancount>49 

* TOBIT
*Senate
tobit cannegratio supportnegratio i.rothchance oppnegratio i.ico threeway i.year if ///
race==1 & canvol>0 & cancount>49, ll(0) ul(1)
* House
tobit cannegratio supportnegratio i.rothchance oppnegratio i.ico i.year if race==2 ///
& canvol>0 & oppnegratio<20 & supportnegratio<20 & cancount>49, ll(0) ul(1)


* OLS
*Senate
reg cannegratio supportnegratio i.rothchance oppnegratio i.ico threeway i.year if ///
race==1 & canvol>0 & cancount>49
* House
reg cannegratio supportnegratio i.rothchance oppnegratio i.ico i.year if race==2 ///
& canvol>0 & oppnegratio<20 & supportnegratio<20 & cancount>49 


* How does the proportion of support coming from parties affect the inverse relationsahip of attack?
recode parnegvol .=0
recode pagnegvol .=0
recode ibgnegvol .=0
recode scgnegvol .=0
gen indnegvol = parnegvol+pagnegvol+ibgnegvol+scgnegvol
gen parratio = parnegvol / indnegvol
gen parpct=.
recode parpct .=1 if parratio<=.25
recode parpct .=2 if parratio>.25 & parratio<=.50
recode parpct .=3 if parratio>.50 & parratio<=.75
recode parpct .=4 if parratio>.75

* Effect of Party Proportion of Support - Senate
glm cannegratio c.supportnegratio##c.parratio i.rothchance oppnegratio i.ico threeway i.year if ///
race==1 & canvol>0 & cancount>49, link(logit) family(binomial) robust nolog 
testparm c.supportnegratio#c.parratio

* Effect of Party Proportion of Support - House
glm cannegratio c.supportnegratio##c.parratio i.rothchance oppnegratio i.ico threeway i.year if race==2 ///
& canvol>0 & oppnegratio<20 & supportnegratio<20 & cancount>49, link(logit) family(binomial) robust nolog 
testparm c.supportnegratio#c.parratio


* Effect of Candidate Status - Senate
glm cannegratio c.supportnegratio##i.ico i.rothchance oppnegratio i.ico threeway i.year if ///
race==1 & canvol>0 & cancount>49, link(logit) family(binomial) robust nolog 
testparm c.supportnegratio#i.ico

quietly margins ico, at(supportnegratio=(0(.1)4))
marginsplot, recast(line) noci

* Effect of Candidate Status - House
glm cannegratio c.supportnegratio##i.ico i.rothchance oppnegratio i.ico threeway i.year if race==2 ///
& canvol>0 & oppnegratio<20 & supportnegratio<20 & cancount>49, link(logit) family(binomial) robust nolog 
testparm c.supportnegratio#i.ico

quietly margins ico, at(supportnegratio=(0(.1)4))
marginsplot, recast(line) noci


* Do candidates alter personal/policy mix when supported by outside attack?
* First, fix some proportions that are greater than 1 due to rounding
recode canperatk * = 1 if id==105 | id==1113 | id==1315 | id==1457 | id==1481 | id==1546 | id==1556 | id==1615 | id==1645 | id==1700 | id==1891
gen senatepersonal = canperatk if race==1
gen housepersonal = canperatk if race==2
  
glm canperatk supportpolratio rothtight rothchance oppperratio i.ico threeway i.year if race==1 & canvol>0 & supportpolratio<10, link(logit) family(binomial) robust nolog
margins, at(supportpolratio=(0(1)4))

glm canperatk supportpolratio rothtight rothchance oppperratio i.ico i.year if race==2 & canvol>0 & supportpolratio<10, link(logit) family(binomial) robust nolog 
margins, at(supportpolratio=(0(1)4))


* "Chow Test" Senate Contrasts of all linear predictions
glm cannegratio c.supportnegratio##i.year i.rothchance##i.year c.oppnegratio##i.year i.ico##i.year ///
if race==1 & canvol>0, link(logit) family(binomial) robust nolog
contrast year year#c.supportnegratio year#i.rothchance year#c.oppnegratio year#i.ico


* "Chow Test" House Contrasts of all linear predictions
glm cannegratio c.supportnegratio##i.year i.rothchance##i.year c.oppnegratio##i.year i.ico##i.year ///
if race==2 & canvol>0 & oppnegratio<20 & supportnegratio<20, link(logit) family(binomial) robust nolog
contrast year year#c.supportnegratio year#i.rothchance year#c.oppnegratio year#i.ico
