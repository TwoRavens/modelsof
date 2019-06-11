
*author J Ryan
*date: last updated 081215
* this do file uses the PSRMreplication110114 dataset to produce the results for the Ryan PSRM article.


version 11
clear all
macro drop _all
set linesize 80

use PSRMreplication081215.dta
xtset major date

*********************************************************

*Table 1
*column 2
by major: sum majorsum
*column 3
by major: sum successsum
*column 4
gen percentsuccess=successsum/majorsum*100
by major: sum percentsuccess
*column 5
by major: sum percentallbills

*Table 2
sum housepolicysump
sum housesuccesssum
sum houserunapprop
sum houserunreauth
sum houserunomni
sum houserunart
sum houserunveto
sum percent
sum propnytimes
sum housemajsd

sum senatepolicysump
sum senatesuccesssum
sum senaterunapprop
sum senaterunreauth
sum senaterunomni
sum senaterunart
sum senaterunveto
sum propnytimes
sum percent
sum spivotdist

xtset major date
*Table 3
xtpcse d.housepolicysumptot l.housepolicysumptot d.housesuccesssum l.housesuccesssum d.senatepolicysum ///
	l.senatepolicysum d.houseartlog l.houseartlog d.houserunapprop l.houserunapprop ///
	d.houserunreauth l.houserunreauth d.houserunomni l.houserunomni d.houserunveto l.houserunveto d.percent l.percent ///
	logpres d.propnytimes l.propnytimes d.newi l.newi housemajsd i.congress

*long-run effects
ivreg housepolicysumptot housesuccesssum senatepolicysum houseartlog  ///
	houserunapprop  houserunreauth houserunomni  houserunveto  percent logpres housemajsd  ///
	propnytimes newi d.housesuccesssum d.senatepolicysum d.houseartlog  ///
	d.houserunreauth d.houserunapprop  d.houserunomni  d.houserunveto  d.percent d.logpres  ///
	d.propnytimes d.newi d.housemajsd ///
	(d.housepolicysumptot=l.housepolicysumptot  l.housesuccesssum l.senatepolicysum ///
	l.houseartlog l.houserunapprop  l.houserunreauth l.houserunomni l.houserunveto l.percent l.newi ///
	l.propnytimes l.housemajsd housesuccesssum senatepolicysum houseartlog houserunapprop houserunreauth houserunomni ///
	houserunveto percent logpres propnytimes newi)	
	
	
xtpcse d.senatepolicysumptot l.senatepolicysumptot d.senatesuccesssum l.senatesuccesssum d.housepolicysum l.housepolicysum d.senateartlog ///
	l.senateartlog d.senaterunreauth l.senaterunreauth d.senaterunapprop l.senaterunapprop d.senaterunomni l.senaterunomni d.senaterunveto ///
	l.senaterunveto d.percent l.percent	logpres d.propnytimes l.propnytimes d.snewi l.snewi  spivotdist i.congress

*long-run effects
ivreg senatepolicysumptot senatesuccesssum housepolicysum senateartlog  ///
	senaterunapprop  senaterunreauth senaterunomni  senaterunveto  percent logpres  ///
	propnytimes snewi d.senatesuccesssum d.housepolicysum d.senateartlog  ///
	d.senaterunapprop d.senaterunreauth d.senaterunomni  d.senaterunveto  d.percent d.logpres  ///
	d.propnytimes d.snewi d.spivotdis ///
	(d.senatepolicysumptot=l.senatepolicysumptot  l.senatesuccesssum l.housepolicysum l.senateartlog ///
	l.senaterunapprop  l.senaterunreauth l.senaterunomni l.senaterunveto l.percent l.snewi ///
	l.propnytimes senatesuccesssum housepolicysum senateartlog  ///
	senaterunapprop senaterunreauth senaterunomni  senaterunveto  percent logpres  ///
	propnytimes snewi)
	
	
	
*The marginal effects in Figure 1 can be obtained by running the following commands after the regressions above.

*******************HOUSE
lincom (l.housesuccesssum + l.newi*-2.427748)*100
lincom (l.housesuccesssum + l.newi*-0.75196)*100
lincom (l.housesuccesssum + l.newi*0.93864)*100
lincom (l.housesuccesssum + l.newi*2.62924)*100
lincom (l.housesuccesssum + l.newi*4.31984)*100
lincom (l.housesuccesssum + l.newi*6.01044)*100
lincom (l.housesuccesssum + l.newi*7.70104)*100

**********SENATE
lincom (l.senatesuccesssum + l.snewi*-.55917)*100
lincom (l.senatesuccesssum + l.snewi*1.214729)*100
lincom (l.senatesuccesssum + l.snewi*3.386091)*100
lincom (l.senatesuccesssum + l.snewi*5.557453)*100
lincom (l.senatesuccesssum + l.snewi*7.7288)*100
lincom (l.senatesuccesssum + l.snewi*9.77)*100

*the coefficients, along with upper and lower cis from these values saved in marginaleffects02.dta
*the coefficients are multiplied by standard deviation changes in in avg. bill importance to find the 
*marginal effect of bill importance on change in legislative activity

use marginaleffects02.dta, clear

twoway (connected housemean housechange, sort lcolor(black) lpattern(solid) lwidth(medium) msymbol(none)) ///
(connected househigh housechange, sort lcolor(black) lpattern(dash) lwidth(medium) msymbol(none)) ///
(connected houselow housechange, sort lcolor(black) lpattern(dash) lwidth(medium) msymbol(none)), ///
ytitle("Marginal Effect of Avg. Bill Importance" "On Change in Policy Activity") xtitle("Std. Dev. Change in Avg. Bill Importance") ///
 ylabel(18(2)0, valuelabel) ///
xlabel(-2(1)4, valuelabel) legend(col(1) order(1 "Predicted Marginal Effect" 2 "95% Confidence Interval") ///
position(3:30) ring(0) size(small)) scheme(s1mono) graphregion(fcolor(white) ifcolor(white)) title("House")

twoway (connected senatemean senatechange, sort lcolor(black) lpattern(solid) lwidth(medium) msymbol(none)) ///
(connected senatehigh senatechange, sort lcolor(black) lpattern(dash) lwidth(medium) msymbol(none)) ///
(connected senatelow senatechange, sort lcolor(black) lpattern(dash) lwidth(medium) msymbol(none)), ///
ytitle("Marginal Effect of Avg. Bill Importance" "On Change in Policy Activity") xtitle("Std. Dev. Change in Avg. Bill Importance") ///
ylabel(18(2)0, valuelabel)  ///
xlabel(-2(1)4, valuelabel)  legend(col(1) order(1 "Predicted Marginal Effect" 2 "95% Confidence Interval") ///
position(3:30) ring(0) size(small)) scheme(s1mono) graphregion(fcolor(white) ifcolor(white)) title("Senate")


*use replication data again

use PSRMreplication081215.dta

xtset major date

*Table 4

xtpcse d.housepolicysumptot l.c.housepolicysumptot##c.divcham d.housesuccesssum l.c.housesuccesssum d.senatepolicysum ///
	l.senatepolicysum d.houseartlog l.houseartlog d.houserunapprop l.houserunapprop ///
	d.houserunreauth l.houserunreauth d.houserunomni l.houserunomni d.houserunveto l.houserunveto d.percent l.percent ///
	logpres d.propnytimes l.propnytimes housemajsd i.congress
	
xtpcse d.housepolicysumptot l.c.housepolicysumptot d.housesuccesssum l.c.housesuccesssum d.senatepolicysum ///
	l.c.senatepolicysum##c.divcham d.houseartlog l.houseartlog d.houserunapprop l.houserunapprop ///
	d.houserunreauth l.houserunreauth d.houserunomni l.houserunomni d.houserunveto l.houserunveto d.percent l.percent ///
	logpres d.propnytimes l.propnytimes housemajsd i.congress
	
xtpcse d.senatepolicysumptot l.c.senatepolicysumptot d.senatesuccesssum l.c.senatesuccesssum d.housepolicysum l.c.housepolicysum##c.divcham d.senateartlog ///
	l.senateartlog d.senaterunreauth l.senaterunreauth d.senaterunapprop l.senaterunapprop d.senaterunomni l.senaterunomni d.senaterunveto ///
	l.senaterunveto d.percent l.percent	logpres d.propnytimes l.propnytimes spivotdist i.congress
	
	
*Table 5
*timeinpower
xtpcse d.senatepolicysumptot l.c.senatepolicysumptot d.senatesuccesssum l.c.senatesuccesssum##l.c.stimeinpower d.housepolicysum l.housepolicysum d.senateartlog ///
	l.c.senateartlog d.senaterunreauth l.senaterunreauth d.senaterunapprop l.senaterunapprop d.senaterunomni l.senaterunomni d.senaterunveto ///
	l.senaterunveto d.percent l.percent  ///
	logpres d.propnytimes l.propnytimes spivotdist i.congress
	
xtpcse d.senatepolicysumptot l.c.senatepolicysumptot d.senatesuccesssum l.c.senatesuccesssum d.housepolicysum l.c.housepolicysum##l.c.stimeinpower d.senateartlog ///
	l.c.senateartlog d.senaterunreauth l.senaterunreauth d.senaterunapprop l.senaterunapprop d.senaterunomni l.senaterunomni d.senaterunveto ///
	l.senaterunveto d.percent l.percent ///
	logpres d.propnytimes l.propnytimes spivotdist i.congress
