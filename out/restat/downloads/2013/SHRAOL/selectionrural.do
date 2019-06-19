/*Selection: main result*/
clear
capture log close
set matsize 1000
set memory 2g
set more off
log using selectionrural.log, replace

use year rhwage edad schoolyears rural lwage mujer binmigr houseid FAC using dataset, clear

svyset, clear
svyset houseid [pw=FAC]

svy, subpop(if mujer==0 & lwage ~= .): mean edad, over(binmigr rural)
svy, subpop(if mujer==0 & lwage ~= .): mean schoolyears, over(binmigr rural)
forvalues y = 2000/2004 {
	svy, subpop(if mujer==0 & year==`y' & lwage ~= .): mean rhwage, over(binmigr rural)
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
/*Non-migrant men: rural areas*/
sum lwage if binmigr == 0 & mujer == 0 & rural==1 [aw=FAC], det
/*Bandwidth: STATA default--cf. Silverman, eq. 3.31 */
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
/*To call local variables: use `'*/
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mujer == 0 & binmigr == 0 & rural==1 [aw=FAC], at(r0) gen(nmigmale) width(`hsmall') nograph
/*Migrant men*/
sum lwage if mujer == 0 & binmigr == 1 & rural==1 [aw=FAC], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mujer == 0 & binmigr == 1 & rural==1 [aw=FAC], at(r0) gen(migmale) width(`hsmall') nograph
scatter nmigmale migmale r0, c(l l) m(i i) title("Men in rural areas (2000-2004)") xtitle("Log of hourly wage in January 2006 dollars relative to the quarter average") ytitle("Density Estimate") clpattern(solid longdash) bfcolor(black red) legend(label(1 "Non-Migrants")) legend(label(2 "Migrants")) saving(wagedensmalerural, replace)
/*Difference of densities*/
gen diffmale = migmale - nmigmale
sum lwage if mujer == 0 & rural == 1 [aw=FAC], det
local medianmen = r(p50)
scatter diffmale r0, xline(`medianmen',lcolor(black)) yline(0,lcolor(black)) c(l l) m(i i) title("Men in rural areas (2000-2004): migrant - non-migrant") xtitle("Log hourly wage in January 2006 dollars relative to the quarter average") ytitle("Density Difference") legend(label(1 "Migrant - Non-migrant density")) saving(wagediffmalerural, replace)
keep migmale nmigmale
stack migmale nmigmale, into(density) clear
ksmirnov density, by(_stack)

/*Urban*/
use rural lwage mujer binmigr houseid FAC using dataset, clear

svyset, clear
svyset houseid [pw=FAC]

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
/*Non-migrant men:*/
sum lwage if binmigr == 0 & mujer == 0 & rural==0 [aw=FAC], det
/*Bandwidth: STATA default--cf. Silverman, eq. 3.31 */
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
/*To call local variables: use `'*/
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mujer == 0 & binmigr == 0 & rural==0 [aw=FAC], at(r0) gen(nmigmale) width(`hsmall') nograph
/*Migrant men*/
sum lwage if mujer == 0 & binmigr == 1 & rural==0 [aw=FAC], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mujer == 0 & binmigr == 1 & rural==0 [aw=FAC], at(r0) gen(migmale) width(`hsmall') nograph
scatter nmigmale migmale r0, c(l l) m(i i) title("Men in urban areas (2000-2004)") xtitle("Log of hourly wage in January 2006 dollars relative to the quarter average") ytitle("Density Estimate") clpattern(solid longdash) bfcolor(black red) legend(label(1 "Non-Migrants")) legend(label(2 "Migrants")) saving(wagedensmaleurban, replace)
/*Difference of densities*/
gen diffmale = migmale - nmigmale
sum lwage if mujer == 0 & rural == 0 [aw=FAC], det
local medianmen = r(p50)
scatter diffmale r0, xline(`medianmen',lcolor(black)) yline(0,lcolor(black)) c(l l) m(i i) title("Men in urban areas (2000-2004): migrant - non-migrant") xtitle("Log hourly wage in January 2006 dollars relative to the quarter average") ytitle("Density Difference") legend(label(1 "Migrant - Non-migrant density")) saving(wagediffmaleurban, replace)
keep migmale nmigmale
stack migmale nmigmale, into(density) clear
ksmirnov density, by(_stack)
