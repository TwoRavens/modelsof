/*Selection: wage distribution estimation for the MMP107*/
clear
capture log close
set matsize 800
set memory 900m
set more off
log using selectionresultmmp107.log, replace

*First use the household heads database*
use year rhwage edad schoolyears rural mujer mig weight using mmp107heads, clear
drop if edad < 16
drop if edad > 65

svyset, clear
svyset [pw=weight]

svy, subpop(if mujer==0 & rhwage ~= .): mean edad, over(mig)
svy, subpop(if mujer==0 & rhwage ~= .): mean schoolyears, over(mig)
gen lwage = .
forvalues y = 2000/2004 {
	svy, subpop(if mujer==0 & year==`y' & rhwage ~= .): mean rhwage
	matrix a = e(b)
	replace lwage = log(rhwage/a[1,1]) if year == `y'
	svy, subpop(if mujer==0 & year==`y' & rhwage ~= .): mean rhwage, over(mig)
}

/*IMPORTANT: Evaluation sequence for density estimation*/
/*number of evaluation points for density estimate*/
global B = 5000

/*Wage distribution*/
gen r0 = (_n-1)/($B-1)
/*r0 should span [0,1]*/
replace r0 = . if _n > $B
sum lwage
global a = r(min)
global b = r(max)
/*r0 should span [$a,$b]*/
replace r0 = $a + r0*($b-$a)
global scaledown = .75
/*Non-migrant men*/
sum lwage if mig == 0 & mujer == 0 [aw=weight], det
/*Bandwidth: STATA default--cf. Silverman, eq. 3.31 */
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
/*To call local variables: use `'*/
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mujer == 0 & mig == 0 [aw=weight], at(r0) gen(nmigmale) width(`hsmall') nograph
/*Migrant men*/
sum lwage if mujer == 0 & mig == 1 [aw=weight], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mujer == 0 & mig == 1 [aw=weight], at(r0) gen(migmale) width(`hsmall') nograph
scatter nmigmale migmale r0, c(l l) m(i i) title("Male household heads" "in the MMP (2000-2004)") xtitle("Log of hourly wage in January 2006 dollars relative to the year average") ytitle("Density Estimate") clpattern(solid longdash) bfcolor(black red) legend(label(1 "Non-Migrants")) legend(label(2 "Migrants")) saving(wagedensmalemmp, replace)
/*Difference of densities*/
gen diffmale = migmale - nmigmale
sum lwage if mujer == 0 [aw=weight], det
local medianmen = r(p50)
scatter diffmale r0, xline(`medianmen',lcolor(black)) yline(0,lcolor(black)) c(l l) m(i i) title("Male household heads in the MMP" "(2000-2004): migrant - non-migrant") xtitle("Log hourly wage in January 2006 dollars relative to the year average") ytitle("Density Difference") legend(label(1 "Migrant - Non-migrant density")) saving(wagediffmalemmp, replace)

*Calculating the degree of selection*
svy, subpop(if mujer == 0): mean lwage, over(mig)
lincom [lwage]1 - [lwage]0

*Kolmogorov-Smirnov test*
keep migmale nmigmale
stack migmale nmigmale, into(density) clear
ksmirnov density, by(_stack)

*Use the general database (not just household heads)*
use surveyyr rhwage edad schoolyears rural mujer mig weight using mmp107all, clear
ren surveyyr year
drop if edad < 16
drop if edad > 65

svyset, clear
svyset [pw=weight]

svy, subpop(if mujer==0 & rhwage ~= .): mean edad, over(mig)
svy, subpop(if mujer==0 & rhwage ~= .): mean schoolyears, over(mig)
gen lwage = .
forvalues y = 2000/2004 {
	svy, subpop(if mujer==0 & year==`y' & rhwage ~= .): mean rhwage
	matrix a = e(b)
	replace lwage = log(rhwage/a[1,1]) if year == `y'
	svy, subpop(if mujer==0 & year==`y' & rhwage ~= .): mean rhwage, over(mig)
}

/*IMPORTANT: Evaluation sequence for density estimation*/
/*number of evaluation points for density estimate*/
global B = 5000

/*Wage distribution*/
gen r0 = (_n-1)/($B-1)
/*r0 should span [0,1]*/
replace r0 = . if _n > $B
sum lwage
global a = r(min)
global b = r(max)
/*r0 should span [$a,$b]*/
replace r0 = $a + r0*($b-$a)
global scaledown = .75
/*Non-migrant men*/
sum lwage if mig == 0 & mujer == 0 [aw=weight], det
/*Bandwidth: STATA default--cf. Silverman, eq. 3.31 */
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
/*To call local variables: use `'*/
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mujer == 0 & mig == 0 [aw=weight], at(r0) gen(nmigmale) width(`hsmall') nograph
/*Migrant men*/
sum lwage if mujer == 0 & mig == 1 [aw=weight], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mujer == 0 & mig == 1 [aw=weight], at(r0) gen(migmale) width(`hsmall') nograph
scatter nmigmale migmale r0, c(l l) m(i i) title("Men in the MMP (2000-2004)") xtitle("Log of hourly wage in January 2006 dollars relative to the year average") ytitle("Density Estimate") clpattern(solid longdash) bfcolor(black red) legend(label(1 "Non-Migrants")) legend(label(2 "Migrants")) saving(wagedensmalemmpall, replace)
/*Difference of densities*/
gen diffmale = migmale - nmigmale
sum lwage if mujer == 0 [aw=weight], det
local medianmen = r(p50)
scatter diffmale r0, xline(`medianmen',lcolor(black)) yline(0,lcolor(black)) c(l l) m(i i) title("Men in the MMP" "(2000-2004): migrant - non-migrant") xtitle("Log hourly wage in January 2006 dollars relative to the year average") ytitle("Density Difference") legend(label(1 "Migrant - Non-migrant density")) saving(wagediffmalemmpall, replace)

*Calculating the degree of selection*
svy, subpop(if mujer == 0): mean lwage, over(mig)
lincom [lwage]1 - [lwage]0

*Kolmogorov-Smirnov test*
keep migmale nmigmale
stack migmale nmigmale, into(density) clear
ksmirnov density, by(_stack)
