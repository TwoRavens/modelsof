/*Results from the ENET following Chiquiar and Hanson estimation procedure*/
clear
capture log close
set matsize 1000
set memory 2g
set more off
log using chiquiarhanson.log, replace

use year FAC lhwage edad mujer binmigr using dataset, clear

/*For comparison with Chiquiar and Hanson (2005), reduce the sample to people aged 21 to 65 years old*/
replace lhwage = . if edad < 21
replace lhwage = . if edad > 65
keep if year == 2000

/*Replicating Leibbrandt et all (2005) procedure*/
/*IMPORTANT: Evaluation sequence for density estimation*/
/*number of evaluation points for density estimate*/
global B = 5000
/*_n means the observation number; $ calls the macro variable defined above*/
gen r0 = (_n-1)/($B-1)
/*r0 should span [0,1]*/
replace r0 = . if _n > $B
sum lhwage
global a = r(min)
global b = r(max)
/*r0 should span [$a,$b]*/
replace r0 = $a + r0*($b-$a)
/*IMPORTANT: bandwidth "scaledown" factor for density estimation. 1 to compare with Chiquiar and Hanson (2005)*/
global scaledown = 1

/*Non-migrant men*/
sum lhwage if mujer == 0 & binmigr == 0 [aw=FAC], det
/*Bandwidth: STATA default--cf. Silverman, eq. 3.31 */
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
/*To call local variables: use `'*/
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lhwage if mujer == 0 & binmigr == 0 [aw=FAC], gaussian at(r0) gen(nmigmale) width(`hsmall') nograph

/*Migrant men*/
sum lhwage if mujer == 0 & binmigr == 1 [aw=FAC], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lhwage if mujer == 0 & binmigr == 1 [aw=FAC], gaussian at(r0) gen(migmale) width(`hsmall') nograph

scatter nmigmale migmale r0, c(l l) m(i i) title("a. Men") xtitle("Log wage in January 2006 dollars") ytitle("Density Estimate") clpattern(solid longdash) bfcolor(black red) legend(label(1 "Non-Migrants")) legend(label(2 "Migrants")) saving(chiquiarhansoncompa, replace)

/*Women*/
sum lhwage if mujer == 1 & binmigr == 0 [aw=FAC], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lhwage if mujer == 1 & binmigr == 0 [aw=FAC], gaussian at(r0) gen(nmigfemale) width(`hsmall') nograph
sum lhwage if mujer == 1 & binmigr == 1 [aw=FAC], det
local h = 0.9*min(r(sd),(r(p75)-r(p25)/1.349))*r(N)^(-1/5)
local hsmall = $scaledown*`h'
display `h' _newline `hsmall'
kdensity lhwage if mujer == 1 & binmigr == 1 [aw=FAC], gaussian at(r0) gen(migfemale) width(`hsmall') nograph

scatter nmigfemale migfemale r0, c(l l) m(i i) title("c. Women") xtitle("Log wage in January 2006 dollars") ytitle("Density Estimate") clpattern(solid longdash) bfcolor(black red) legend(label(1 "Non-Migrants")) legend(label(2 "Migrants")) saving(chiquiarhansoncompc, replace)

/*Difference of densities*/
gen diffmale = migmale - nmigmale
sum lhwage if mujer == 0 [aw=FAC], det
local medianmen = r(p50)
scatter diffmale r0, xline(`medianmen',lcolor(black)) yline(0,lcolor(black)) c(l l) m(i i) title("b. Men") xtitle("Log wage in January 2006 dollars") ytitle("Density Difference") legend(label(1 "Migrant - Non-migrant density")) saving(chiquiarhansoncompb, replace)
gen difffemale = migfemale - nmigfemale
sum lhwage if mujer == 1 [aw=FAC], det
local medianwomen = r(p50)
scatter difffemale r0, xline(`medianwomen',lcolor(black)) yline(0,lcolor(black)) c(l l) m(i i) title("d. Women") xtitle("Log wage in January 2006 dollars") ytitle("Density Difference") legend(label(1 "Migrant - Non-migrant density")) saving(chiquiarhansoncompd, replace)
