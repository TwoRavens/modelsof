/*Calculating selection following Chiquiar and Hanson's method: assume no wage information for migrants is available or only ACS data for migrants available*/
clear
capture log close
set matsize 1000
set memory 4g
set more off
log using chcomparison.log, replace

global B = 5000
global scaledown = 0.75

use married hhsize edad schoolyears perwt lwage mujer edad using usdataset, clear
gen FAC = perwt
gen usmigr = 1 if mujer == 0 & edad > 15 & edad < 66
gen usdata = 1
append using dataset, keep(FAC lwage mujer binmigr edad schoolyears married hhsize houseid)
replace usmigr = 0 if usdata ~= 1 & mujer == 0 & lwage ~= .
gen edad2 = edad*edad
gen schoolyears2 = schoolyears*schoolyears
gen schoolgroup = .
replace schoolgroup = 1 if schoolyears == 0
replace schoolgroup = 2 if schoolyears >=0 & schoolyears < 5
replace schoolgroup = 3 if schoolyears >=5 & schoolyears < 9
replace schoolgroup = 4 if schoolyears == 9
replace schoolgroup = 5 if schoolyears > 9 & schoolyears < 12
replace schoolgroup = 6 if schoolyears == 12
replace schoolgroup = 7 if schoolyears > 12 & schoolyears < 16
replace schoolgroup = 8 if schoolyears >= 16
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
sum lwage if mujer == 0 & binmigr == 0 [aw=FAC], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if mujer == 0 & binmigr == 0 [aw=FAC], at(r0) gen(nmigmale) width(`hsmall') nograph
/*Migrant men*/
/*Chiquiar and Hanson counterfactual: how much would Mexican immigrants in the US earn if they were to go back to Mexico?*/
/*Estimate the unconditional probabilities: p(US)*/
svyset, clear
svyset [pw=FAC]
svy: mean usmigr
matrix define AM = e(b)
local piem = AM[1,1]
/*Estimate the conditional probability: p(US|x)*/
xi: svy: logit usmigr i.schoolgroup edad edad2 married i.schoolgroup*edad i.schoolgroup*edad2 i.schoolgroup*married
predict pm if usmigr ~= .
gen DFLwm = FAC*(pm/(1-pm))/(`piem'/(1-`piem'))
sum lwage if usmigr == 0 & binmigr == 0 [aw=DFLwm], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if usmigr == 0 & binmigr == 0 [aw=DFLwm], at(r0) gen(migmale) width(`hsmall') nograph
scatter nmigmale migmale r0, c(l l) m(i i) title("Men in Mexico and counterfactual for US migrants") xtitle("Log hourly wage in January 2006 dollars relative to the quarter average") ytitle("Density Estimate") clpattern(solid longdash) bfcolor(black red) legend(label(1 "Mexico")) legend(label(2 "Migrants in the US")) saving(wagedensmalemexuscount, replace)
/*Difference of densities*/
gen diffmale = migmale - nmigmale
sum lwage if usmigr == 0 & binmigr == 0 [aw=FAC], det
local medianmen = r(p50)
scatter diffmale r0, xline(`medianmen',lcolor(black)) yline(0,lcolor(black)) c(l l) m(i i) title("Men (migrant counterfactual - Mexico)") xtitle("Log hourly wage in January 2006 dollars relative to the quarter average") ytitle("Density Difference") legend(label(1 "Migrant (c) - Mexico density")) saving(wagediffmalecount1, replace)
drop migmale diffmale
/*Calculating degree of selection*/
svyset, clear
svyset houseid [pw=FAC]
svy, subpop(if mujer == 0 & binmigr==0): mean lwage
matrix NM = e(b)
svyset, clear
svyset houseid [pw=DFLwm]
svy, subpop(if usmigr == 0 & binmigr==0): mean lwage
matrix MC = e(b)
local DSUSdata = MC[1,1]-NM[1,1]
display `DSUSdata'

/*Computing selection assuming there is no wage data for emigrants*/
/*Migrant men*/
/*Chiquiar and Hanson counterfactual: how much would Mexican emigrants to the US earn given their observables?*/
/*Estimate the unconditional probabilities: p(US)*/
svy, subpop(if mujer==0 & lwage ~= .): mean binmigr
matrix define AM2 = e(b)
local piem2 = AM2[1,1]
/*Estimate the conditional probability: p(US|x)*/
xi: svy, subpop(if mujer==0 & lwage ~=.): logit binmigr i.schoolgroup edad edad2 married i.schoolgroup*edad i.schoolgroup*edad2 i.schoolgroup*married
predict pm2 if binmigr == 0 & mujer == 0 & lwage ~= .
gen DFLwm2 = FAC*(pm2/(1-pm2))/(`piem2'/(1-`piem2'))
sum lwage if binmigr == 0 & mujer == 0 [aw=DFLwm2], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lwage if binmigr == 0 & mujer == 0 [aw=DFLwm2], at(r0) gen(migmale) width(`hsmall') nograph
scatter nmigmale migmale r0, c(l l) m(i i) title("Men: non-migrants and counterfactual for migrants") xtitle("Log hourly wage in January 2006 dollars relative to the quarter average") ytitle("Density Estimate") clpattern(solid longdash) bfcolor(black red) legend(label(1 "Non-migrants")) legend(label(2 "Migrants (c)")) saving(wagedensmalemexuscount2, replace)
/*Difference of densities*/
gen diffmale = migmale - nmigmale
sum lwage if mujer == 0 & binmigr == 0 [aw=FAC], det
local medianmen = r(p50)
scatter diffmale r0, xline(`medianmen',lcolor(black)) yline(0,lcolor(black)) c(l l) m(i i) title("Men (migrant counterfactual - non-migrant)") xtitle("Log hourly wage in January 2006 dollars relative to the quarter average") ytitle("Density Difference") legend(label(1 "Migrant (c) - Mexico density")) saving(wagediffmalecount2, replace)
/*Calculating degree of selection*/
svyset, clear
svyset houseid [pw=DFLwm2]
svy, subpop(if mujer==0 & binmigr==0): mean lwage
matrix MCenet = e(b)
local DSENETc = MCenet[1,1]-NM[1,1]
display `DSENETc'
