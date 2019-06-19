/*Calculating selection following Chiquiar and Hanson's method: assume no wage information for migrants is available or only ACS data for migrants available*/
clear
capture log close
set matsize 800
set memory 900m
set more off
log using selectiononobservablesmmp.log, replace

global B = 5000
global scaledown = 0.75

use year weight rhwage mujer mig edad schoolyears cunion married children using mmp107heads, clear

*Grouping the schooling variable*
gen schoolgroup = .
replace schoolgroup = 1 if schoolyears == 0
replace schoolgroup = 2 if (schoolyears > 0 & schoolyears < 6)
replace schoolgroup = 3 if (schoolyears >= 6 & schoolyears < 9)
replace schoolgroup = 4 if (schoolyears >= 9 & schoolyears < 12)
replace schoolgroup = 5 if (schoolyears >= 12 & schoolyears < 16)
replace schoolgroup = 6 if schoolyears >= 16

*Married*
replace married = 1 if cunion == 1

*Household size*
gen hhsize = children + 1
replace hhsize = . if children == 9999

gen lwage = .
forvalues y = 2000/2004 {
	svy, subpop(if mujer==0 & year==`y' & rhwage ~= .): mean rhwage
	matrix a = e(b)
	replace lwage = log(rhwage/a[1,1]) if year == `y'
	svy, subpop(if mujer==0 & year==`y' & rhwage ~= .): mean rhwage, over(mig)
}
gen edad2 = edad*edad

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
sum lwage if mujer == 0 & mig == 0 [aw=weight], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mujer == 0 & mig == 0 [aw=weight], at(r0) gen(nmigmale) width(`hsmall') nograph
/*Migrant men*/
/*Chiquiar and Hanson counterfactual: how much would Mexican emigrants to the US earn given their observables?*/
/*Estimate the unconditional probabilities: p(US)*/
svy, subpop(if mujer==0 & lwage ~=.): mean mig
matrix define AM2 = e(b)
local piem2 = AM2[1,1]
/*Estimate the conditional probability: p(US|x)*/
xi: svy, subpop(if mujer==0 & lwage ~=.): logit mig i.schoolgroup edad edad2 married i.schoolgroup*edad i.schoolgroup*edad2 i.schoolgroup*married
predict pm2 if mig == 0 & mujer == 0 & lwage ~= .
gen DFLwm2 = weight*(pm2/(1-pm2))/(`piem2'/(1-`piem2'))
sum lwage if mig == 0 & mujer == 0 [aw=DFLwm2], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mig == 0 & mujer == 0 [aw=DFLwm2], at(r0) gen(migmale) width(`hsmall') nograph
scatter nmigmale migmale r0, c(l l) m(i i) title("Male household heads in the MMP:" "non-migrants and counterfactual for migrants") xtitle("Log hourly wage in January 2006 dollars relative to the year average") ytitle("Density Estimate") clpattern(solid longdash) bfcolor(black red) legend(label(1 "Non-migrants")) legend(label(2 "Migrants (c)")) saving(wagedensmaleobsmmp, replace)
/*Difference of densities*/
gen diffmale = migmale - nmigmale
sum lwage if mujer == 0 & mig == 0 [aw=weight], det
local medianmen = r(p50)
scatter diffmale r0, xline(`medianmen',lcolor(black)) yline(0,lcolor(black)) c(l l) m(i i) title("Male household heads in the MMP" "(migrant counterfactual - non-migrant)") xtitle("Log hourly wage in January 2006 dollars relative to the year average") ytitle("Density Difference") legend(label(1 "Migrant (c) - Mexico density")) saving(wagediffmaleobsmmp, replace)
/*Calculating degree of selection*/
svyset, clear
svyset [pw=weight]
svy, subpop(if mujer == 0 & mig==0): mean lwage
matrix NM = e(b)
svyset, clear
svyset [pw=DFLwm2]
svy, subpop(if mujer==0 & mig==0): mean lwage
matrix MCmmp = e(b)
local DSmmpc = MCmmp[1,1]-NM[1,1]
display `DSmmpc'

*Counterfactual for the full dataset (pers file)*
use country commun surveypl hhnum surveyyr weight rhwage mujer mig edad schoolyears marstat using mmp107all, clear


*Grouping the schooling variable*
gen schoolgroup = .
replace schoolgroup = 1 if schoolyears == 0
replace schoolgroup = 2 if (schoolyears > 0 & schoolyears < 6)
replace schoolgroup = 3 if (schoolyears >= 6 & schoolyears < 9)
replace schoolgroup = 4 if (schoolyears >= 9 & schoolyears < 12)
replace schoolgroup = 5 if (schoolyears >= 12 & schoolyears < 16)
replace schoolgroup = 6 if schoolyears >= 16

*Married*
gen married = 0
replace married = 1 if marstat == 2
replace married = 1 if marstat == 3
replace married = . if marstat == 8888
replace married = . if marstat == 9999
replace married = . if marstat == .

save mmp107allsel, replace

*Household size*
use "c:\DATA\MMP\house107.dta", clear
sort country commun surveypl surveyyr hhnum
save house107sorted, replace
use mmp107allsel, clear
sort country commun surveypl surveyyr hhnum
merge country commun surveypl surveyyr hhnum using house107sorted, keep(members) uniqusing
ren members hhsize

ren surveyyr year

gen lwage = .
forvalues y = 2000/2004 {
	svy, subpop(if mujer==0 & year==`y' & rhwage ~= .): mean rhwage
	matrix a = e(b)
	replace lwage = log(rhwage/a[1,1]) if year == `y'
	svy, subpop(if mujer==0 & year==`y' & rhwage ~= .): mean rhwage, over(mig)
}
gen edad2 = edad*edad

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
sum lwage if mujer == 0 & mig == 0 [aw=weight], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mujer == 0 & mig == 0 [aw=weight], at(r0) gen(nmigmale) width(`hsmall') nograph
/*Migrant men*/
/*Chiquiar and Hanson counterfactual: how much would Mexican emigrants to the US earn given their observables?*/
/*Estimate the unconditional probabilities: p(US)*/
svy, subpop(if mujer==0 & lwage ~=.): mean mig
matrix define AM2 = e(b)
local piem2 = AM2[1,1]
/*Estimate the conditional probability: p(US|x)*/
xi: svy, subpop(if mujer==0 & lwage ~=.): logit mig i.schoolgroup edad edad2 married i.schoolgroup*edad i.schoolgroup*edad2 i.schoolgroup*married
predict pm2 if mig == 0 & mujer == 0 & lwage ~= .
gen DFLwm2 = weight*(pm2/(1-pm2))/(`piem2'/(1-`piem2'))
sum lwage if mig == 0 & mujer == 0 [aw=DFLwm2], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mig == 0 & mujer == 0 [aw=DFLwm2], at(r0) gen(migmale) width(`hsmall') nograph
scatter nmigmale migmale r0, c(l l) m(i i) title("Men in the MMP:" "non-migrants and counterfactual for migrants") xtitle("Log hourly wage in January 2006 dollars relative to the year average") ytitle("Density Estimate") clpattern(solid longdash) bfcolor(black red) legend(label(1 "Non-migrants")) legend(label(2 "Migrants (c)")) saving(wagedensmaleobsmmpall, replace)
/*Difference of densities*/
gen diffmale = migmale - nmigmale
sum lwage if mujer == 0 & mig == 0 [aw=weight], det
local medianmen = r(p50)
scatter diffmale r0, xline(`medianmen',lcolor(black)) yline(0,lcolor(black)) c(l l) m(i i) title("Men in the MMP" "(migrant counterfactual - non-migrant)") xtitle("Log hourly wage in January 2006 dollars relative to the year average") ytitle("Density Difference") legend(label(1 "Migrant (c) - Mexico density")) saving(wagediffmaleobsmmpall, replace)
/*Calculating degree of selection*/
svyset, clear
svyset [pw=weight]
svy, subpop(if mujer == 0 & mig==0): mean lwage
matrix NM = e(b)
svyset, clear
svyset [pw=DFLwm2]
svy, subpop(if mujer==0 & mig==0): mean lwage
matrix MCmmp = e(b)
local DSmmpcall = MCmmp[1,1]-NM[1,1]
display `DSmmpcall'
