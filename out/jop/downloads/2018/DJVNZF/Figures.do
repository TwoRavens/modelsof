***** Figures file
***** Conservative Larks, Liberal Owls: The Relationship between Chronotype and Political Ideology
***** Journal of Politics
***** Aleksander Ksiazkiewicz

***** Prepared for Dataverse 11/20/2018


*** Figure 1
* Meta-analysis figure of Samples 1 to 8 
* For Sample 4, this figure uses the mid-point of free night sleep analysis

clear
insheet using "results summary.csv", comma

drop if alt==1

label var sample "Sample"
label var model "Model"

#delimit ;
metan beta lb ub, 
	by(model)
	wgt(n)
	xlabel(-0.2, -0.1, 0, 0.1, 0.2)
	rfdist
	effect(ES)
	nohet
	nobox
	graphregion(color(white))
	lcols(model sample)
	texts(100) astext(50)
	nooverall
	title("Figure 1", color(black) size(*.6))
	subtitle("Effect of chronotype on ideology", color(black) size(*.6))
	note("Note: Ideology was coded so that conservative values are higher. Chronotype was coded so that morning values are higher."
		"Diamonds show the sample size weighted average effect by model. Bars and width of diamonds show 95% confidence intervals."
		"Estimates are for standardized effect sizes.",
		size(*.6))
	;
#delimit cr

graph export Figure1.eps



*** Figure S1
** For instructions on generating the sample8.dta file, see "analyses.do"
clear
use sample8

* Rescale all times to a common scale, where 0 is midnight 
* Calculate very liberal bed time (min), midpoint (mid), and wake time (max)
gen min1 = freesleep-24 if freesleep>=19 & ideo==1 & beta_ideo!=.
replace min1 = freesleep if min1==. & ideo==1 & beta_ideo!=.

gen max1 = min1 + freesleepduration

gen mid1 = min1 + freesleepduration/ 2

* Rescale all times to a common scale, where 0 is midnight 
* Calculate very conservative bed time (min), midpoint (mid), and wake time (max)
gen min5 = freesleep-24 if freesleep>=19 & ideo==5 & beta_ideo!=.
replace min5 = freesleep if min5==. & ideo==5 & beta_ideo!=.

gen max5 = min5 + freesleepduration

gen mid5 = min5 + freesleepduration/ 2

* Create graphs

foreach time of numlist 1/3 {
local title1 = "Bed time"
local title2 = "Midpoint of sleep"
local title3 = "Wake time"

local var1 = "min"
local var2 = "mid"
local var3 = "max"

#delimit ;
graph hbox `var`time''1 `var`time''5,
		box(1, color(black) fcolor(gs2))
		box(2, color(black) fcolor(gs14))
		nooutsides
	legend(label(1 "Very Conservative"))
	legend(label(2 "Very Liberal"))
	legend(rows(1))
	ytitle("Time")
	ylabel(-4 "8 PM"
		-2 "10 PM"
		0 "Midnight"
		2 "2 AM"
		4 "4 AM"
		6 "6 AM"
		8 "8 AM"
		10 "10 AM"
		12 "Noon"
		14 "2 PM")
	yscale(range(-5 15))
	graphregion(color(white))
	title("`title`time''", color(black))
	note("")
	name(timeboxalt`time', replace)
	nodraw;
#delimit cr
}

#delimit ;
grc1leg timeboxalt1 timeboxalt2 timeboxalt3, 
	cols(1)
	imargin(vsmall)
	title("Figure S1", color(black))
	subtitle("Free-night sleep patterns by ideology in Sample 8", color(black))
	note("The boxes show the median value by group, and the 25th and 75th percentiles." "The whiskers show the upper and lower adjacent values. Outside values are not shown.")
	graphregion(color(white));
#delimit cr

graph export FigureS1.eps



*** Figure S2
* Alternative meta-analysis figure of Samples 1 to 8
* For Sample 4, this figure uses the morningness-eveningness questionnaire analysis

clear
insheet using "results summary.csv", comma

drop if alt==0 & sample==4

label var sample "Sample"
label var model "Model"

sort sample model

metan beta lb ub, by(model) wgt(n) xlabel(-0.2, -0.1, 0, 0.1, 0.2) rfdist effect(ES) nohet nobox graphregion(color(white)) lcols(model sample) texts(100) astext(50) nooverall title("Figure S2", color(black)) subtitle("Effect of chronotype on ideology", color(black))

graph export FigureS2.eps
