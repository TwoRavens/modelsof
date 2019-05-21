** Issue Voting as a Constrained Choice Problem - Moral and Zhirnov (2017)
** Replication File (Appendix C)

clear all
* cd "/Users/mmoral/Dropbox/SUNY Binghamton PhD/Miscellaneous/-Issue Voting as a Constrained Choice Problem/AJPS Final/Replication/Analyses Code"
* cd "/home/andrei/Desktop/replication materials"
 
** Programs
prog drop _all

* Conditional logistic regression
program define condlog
	args todo b lnf
	tempvar deno vc
	mleval `vc'=`b', eq(1)
	sort id choice
	qui by id: gen double `deno'=sum(exp(`vc')) 
	mlsum `lnf'=`vc'-ln(`deno') if choice==1 
end

* Constrained choice conditional logistic regression 
program define cccl
	args todo b lnf
	tempvar deno vc cs
	mleval `vc'=`b', eq(1) 
	mleval `cs'=`b', eq(2) 
	sort id choice
	qui by id: gen double `deno'=sum(exp(`vc'-ln(1+exp(-`cs'))))
	mlsum `lnf'= (`vc'-ln(1+exp(-`cs'))-ln(`deno')) if choice==1
end

** Estimations
** United Kingdom (1987)
use "BES87 v1",clear

* Proximity model
ml model d0 condlog (choice=chprox*, nocons)
ml search
eststo m1a: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1a=(e(b))

ml model d0 condlog (choice=chprox* constvar1 constvar2 constvar3, nocons)
ml search
eststo m1b: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1b=(e(b))

mat initial=(b_m1b, 0)
ml model d0 cccl (choice=chprox*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m1c: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1c=(e(b))

* Directional model
ml model d0 condlog (choice=chdir*, nocons)
ml search
eststo m2a: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2a=(e(b))

ml model d0 condlog (choice=chdir* constvar1 constvar2 constvar3, nocons)
ml search
eststo m2b: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2b=(e(b))

mat initial=(b_m2b, 0)
ml model d0 cccl (choice=chdir*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m2c: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2c=(e(b))

* Likelihood-ratio tests
lrtest m1b m1c, stats
lrtest m2b m2c, stats

* Comparing AICs
disp exp((4043.282-3916.653)/2)
disp exp((4002.815-3958.679)/2)

* Comparing BICs
disp 4113.996-3994.438
disp 4073.529-4036.465

* Table A3
esttab m1a m1b m1c m2a m2b m2c using "TableA3.csv", csv replace b(%10.3f) se stats(ll aic bic N, labels("Log lik." "AIC" "BIC" "Obs") fmt(%10.1f %10.1f %10.1f %10.0f)) ///
starlevels(* 0.05 ** 0.01) varlabels(_cons Constant) nonote addnote("Standard errors in parentheses. Two-tailed tests.") alignment(l) nogaps nodepvars ///
label nonumbers compress nobase noomit obslast long mtitle("(P1)" "(P2)" "(P3)" "(D1)" "(D2)" "(D3)")

* In-sample predictions 
foreach mod in m1a m1b m2a m2b {
tempvar xb vc sp
mat score `xb'=b_`mod', equation(eq1)
gen `vc'=exp(`xb')
egen `sp'=sum(`vc'), by(id)
gen pr_`mod'=`vc'/`sp'
}

foreach mod in m1c m2c {
tempvar xb zg vc sp
mat score `xb'=b_`mod', equation(eq1)
mat score `zg'=b_`mod', equation(eq2)
gen `vc'=exp(`xb')/(1+exp(-`zg'))
egen `sp'=sum(`vc'), by(id)
gen pr_`mod'=`vc'/`sp'
}

* Probability of inclusion
foreach mod in m1c m2c {
tempvar zg
mat score `zg'=b_`mod', equation(eq2)
gen princl_`mod'=1/(1+exp(-`zg'))
qui sum princl_`mod'
replace princl_`mod'=princl_`mod'/(r(max))
}

drop __*
save with_insample_pred_UK, replace

** Table A4: Policy Positions of Political Parties: United Kingdom (1987)
use "BES87 v1",clear
gen fchoice=100*choice
tabstat pos1 pos2 pos3 pos4 pos5 pos6 pos7 fchoice, by(party) nototal save
*ssc install tabstatmat

tabstatmat temp
matrix rownames temp=:Conservative :Labour :Alliance
matrix colnames temp="No/More Nuclear Weapons" "Unemployment/Inflation" "Taxation/Government Services" "Nationalization/Privatization" "Income Inequality" ///
"Civil Rights/Crime" "More/Less Help for the Poor" "Vote Share"
putexcel set "TableA4.xlsx", replace 
putexcel A1=matrix(temp'), names nformat(number_d2) 
putexcel clear

** Table A5: Summary Statistics: United Kingdom (1987)
use "BES87 v1",clear
*ssc install sutex

order chprox* chdir* constvar*,sequential
lab var choice "Choice"
lab var chprox1 "Squared Distance (No/More Nuclear Weapons)"
lab var chprox2 "Squared Distance (Unemployment/Inflation)"
lab var chprox3 "Squared Distance (Taxation/Govt. Services)"
lab var chprox4 "Squared Distance (Nationalization/Privatization)"
lab var chprox5 "Squared Distance (Income Inequality)"
lab var chprox6 "Squared Distance (Civil Rights/Crime)"
lab var chprox7 "Squared Distance (More/Less Help for the Poor)"
lab var chdir1 "Scalar Product (No/More Nuclear Weapons)"
lab var chdir2 "Scalar Product (Unemployment/Inflation)"
lab var chdir3 "Scalar Product (Taxation/Govt. Services)"
lab var chdir4 "Scalar Product (Nationalization/Privatization)"
lab var chdir5 "Scalar Product (Income Inequality)"
lab var chdir6 "Scalar Product (Civil Rights/Crime)"
lab var chdir7 "Scalar Product (More/Less Help for the Poor)"
lab var constvar1 "Electoral Viability"
lab var constvar2 "Policy Extremity"
lab var constvar3 "Strong Affinity to Another Party"
sutex choice chprox* chdir* constvar*, labels minmax nobs file(TableA5.tex) replace 

** Figures
*set scheme mmoral3 /* Available from the authors upon request */

** Figure A1: Effective Number of Parties in Individual Voters’ Effective Choice Sets: Models P3 and D3 (United Kingdom, 1987)
use with_insample_pred_UK, clear
gen pprox=princl_m1c
gen pdir=princl_m2c 
keep id party pprox pdir
reshape wide pprox pdir, i(id) j(party)
foreach y in prox dir {
egen total_`y'=rowtotal(p`y'*)
forval j =1/3 {
replace p`y'`j'=(p`y'`j'/total_`y')^2
}
egen enp_`y'=rowtotal(p`y'*)
replace enp_`y'=1/enp_`y'
}
hist enp_prox, percent xtitle("", size(small)) title("Proximity Theory (Model P3)", size(small)) nodraw name(prox, replace)
hist enp_dir, percent xtitle("Effective Number of Parties in Individual Voters' Effective Choice Sets", size(small)) title("Directional Theory (Model D3)", size(small)) nodraw name(dir, replace) 
graph combine prox dir, rows(2) xcommon
graph display, xsize(3.5)
graph export "Figure1_UK.pdf", replace

** Figure A2: Predicted Probabilities of Inclusion in the Choice Set: Model P3 (United King- dom, 1987)
use "BES87 v1.dta", clear
mat initial=(b_m1b, 0)
ml model d0 cccl (choice=chprox*, nocons)(constvar1 constvar2 constvar3)
ml init initial, copy
eststo m1c: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1c=(e(b))

foreach var in constvar1 constvar2{
qui sum `var'
sca max`var'=(r(max))
sca min`var'=(r(min))
}
qui sum constvar2 if party==2
sca constvar2_lab=(r(mean))
qui sum constvar2 if party==3
sca constvar2_all=(r(mean))

preserve
set seed 123456789
drawnorm b1-b11, n(1000) means(e(b)) cov(e(V)) clear
postutil clear
forval x=1/4 {
postfile mypost`x' pr`x' lb`x' ub`x' base lbbase ubbase using sim`x', replace
forval i=5/100 {
{
gen baseline=1/(1+exp(-(b11+b10*0+b9*`=maxconstvar2'+b8*`=maxconstvar1')))
gen prob1=1/(1+exp(-(b11+b10*1+b9*`=constvar2_lab'+b8*(`i'/100))))
gen prob2=1/(1+exp(-(b11+b10*0+b9*`=constvar2_lab'+b8*(`i'/100))))
gen prob3=1/(1+exp(-(b11+b10*1+b9*`=constvar2_all'+b8*(`i'/100))))
gen prob4=1/(1+exp(-(b11+b10*0+b9*`=constvar2_all'+b8*(`i'/100))))
tempname pr`x' lb`x' ub`x' base lbbase ubbase
qui sum baseline
sca `base'=`r(mean)'
_pctile baseline, p(2.5, 97.5) 
sca `lbbase' = r(r1)
sca `ubbase' = r(r2)
_pctile prob`x', p(2.5, 97.5) 
sca `lb`x'' = r(r1)
sca `ub`x'' = r(r2)
qui sum prob`x', meanonly
sca `pr`x''=`r(mean)'
post mypost`x' (`pr`x'') (`lb`x'') (`ub`x'') (`base') (`lbbase') (`ubbase')
}
drop baseline prob1 prob2 prob3 prob4
local i=`i'+1
disp _c(.) 
}
postclose mypost`x'
disp "Done!"
}
restore
merge using "sim1.dta" "sim2.dta" "sim3.dta" "sim4.dta"
save trial, replace

use trial, clear
gen fakeconstvar1=_n*0.01+0.04 in 1/96
forval i=1/4{
replace pr`i'=pr`i'/ubbase
replace ub`i'=ub`i'/ubbase
replace lb`i'=lb`i'/ubbase
}

gen str pipe="|"
gen where=0

twoway (line pr1 fakeconstvar1, lpattern(dash) lcolor(black)) (line pr2 fakeconstvar1, lpattern(solid) lcolor(black)) ///
(line ub1 fakeconstvar1, lpattern(dot) lcolor(black)) (line lb1 fakeconstvar1, lpattern(dot) lcolor(black)) ///
(line ub2 fakeconstvar1, lpattern(dot) lcolor(black)) (line lb2 fakeconstvar1, lpattern(dot) lcolor(black)) ///
(scatter where constvar1 if party==2 & choice==1, ms(i) mlab(pipe) mlabsize(vsmall) mlabgap(-1) mlabpos(6) mlabcolor(gs0)), ///
xlab(0(.2)1, labsize(medsmall)) ylab(0(.25)1, labsize(medsmall)) legend(order(1 "Strong Affinity to Another Party" 2 "No or Weak Party ID") size(medium)) ///
xtitle("Electoral Viability", size(medsmall)) ytitle("Pr(Inclusion)", size(medsmall)) ///
title("Party as Extreme as the Labour Party", size(medium)) nodraw name(viab1, replace)

twoway (line pr3 fakeconstvar1, lpattern(dash) lcolor(black)) (line pr4 fakeconstvar1, lpattern(solid) lcolor(black)) ///
(line ub3 fakeconstvar1, lpattern(dot) lcolor(black)) (line lb3 fakeconstvar1, lpattern(dot) lcolor(black)) ///
(line ub4 fakeconstvar1, lpattern(dot) lcolor(black)) (line lb4 fakeconstvar1, lpattern(dot) lcolor(black)) ///
(scatter where constvar1 if party==3 & choice==1, ms(i) mlab(pipe) mlabsize(vsmall) mlabgap(-1) mlabpos(6) mlabcolor(gs0)), ///
xlab(0(.2)1, labsize(medsmall)) ylab(0(.25)1, labsize(medsmall)) legend(order(1 "Strong Affinity to Another Party" 2 "No or Weak Party ID") size(medium)) ///
xtitle("Electoral Viability", size(medsmall)) ytitle("Pr(Inclusion)", size(medsmall)) ///
title("Party as Extreme as the Alliance", size(medium)) nodraw name(viab2, replace)

grc1leg viab1 viab2, ycommon xcommon legendfrom(viab1)
graph display, xsize(7)
graph export "Figure2_UK.pdf", replace

** Figure A3: Predicted Probabilities of Voting for the Labour Party (United Kingdom, 1987)
* Proximity model
use with_insample_pred_UK, clear 
collapse (mean) pos* medianv* constvar*, by(party)
expand 11						/* Generating 11 hypothetical voters */
sort party
egen id = seq(), f(1) t(11)
gen position=id					/* Voters' ideological stands vary between 0 and 10 */

* Linear predictions varying w/ ideological stands of hypothetical voters on the left-right dimension
forval j=1/7 {
gen chprox`j'=(pos`j'-medianv`j')^2
}
replace chprox4=(pos4-position)^2
mat score xb_left=b_m1c, equation(eq1)

* Alternative choice set compositions
* Labour and Conservative parties in the Choice Set
gen phi1=0
replace phi1=1 if inlist(party, 1, 2) 
* Labour, Conservative, Alliance
gen phi2=0
replace phi2=1 if inlist(party, 1, 2, 3)
* Labour and Alliance
gen phi3=0
replace phi3=1 if inlist(party, 2, 3)

* Predictions with in-sample probabilities of inclusion
replace constvar3=0
mat score temp=b_m1c, equation(eq2)
gen phi0=1/(1+exp(-temp))

forval j = 0/3 {
tempvar vc denominator
gen `vc'=phi`j'*exp(xb_left)
egen `denominator'=total(`vc'), by(id)
gen pr_left_s`j'=`vc'/`denominator'
}

* Predictions from Model P1
tempvar vc denominator
mat score xb_m1a=b_m1a, equation(eq1)
tempvar vc denominator
gen `vc'=exp(xb_m1a)
egen `denominator'=total(`vc'), by(id)
gen pr_left_m1a=`vc'/`denominator'

* Predictions from Model P2
tempvar vc denominator
mat score xb_m1b=b_m1b, equation(eq1) 
gen `vc'=exp(xb_m1b) 
egen `denominator'=total(`vc'), by(id)
gen pr_left_m1b=`vc'/`denominator'

twoway (connected pr_left_s1 position, lpattern(dot) lcolor(black)) ///
(connected pr_left_s2 position, lpattern(shortdash) lcolor(black)) ///
(connected pr_left_s3 position, lpattern(solid) lcolor(black)) if party==2, ////
legend(order(1 "Labour and Conservative" 2 "Labour, Conservative, Alliance" ///
3 "Labour, Alliance") symxsize(4) rows(1) size(medsmall)) ///
xline(2.93) text(0.015 2.8 "Labour""Party Position", place(nw) j(right) size(small)) ///
ytitle("Pr(Labour Vote=1)", size(medsmall)) xtitle("Voter Position on the Nationalization-privatization Scale", size(medsmall)) ///
ylab(0(.2)1, grid angle(0) labsize(medsmall) gmax) xlab(1(2)11, labsize(medsmall) gmax) ///
title("Proximity Theory (Model P3)", size(medium)) nodraw name(voteprox1, replace)

twoway (line pr_left_m1a position, lpattern(dot) lcolor(black)) ///
(line pr_left_m1b position, lpattern(shortdash) lcolor(black)) ///
(line pr_left_s0 position, lpattern(solid) lcolor(black)) if party==2, ////
legend(order(1 "Model P1/D1 Predictions" 2 "Model P2/D2 Predictions" 3 "Model P3/D3 Predictions (with Predicted Inclusion Probabilities)") symxsize(4) rows(1) size(medsmall)) ///
xline(2.93) text(0.015 2.8 "Labour""Party Position", place(nw) j(right) size(small)) ///
ytitle("Pr(Labour Vote=1)", size(medsmall)) xtitle("Voter Position on the Nationalization-privatization Scale", size(medsmall)) ///
ylab(0(.2)1, grid angle(0) labsize(medsmall) gmax) xlab(1(2)11, labsize(medsmall) gmax) ///
title("Proximity Theory (Models P1, P2, and P3)", size(medium)) nodraw name(voteprox2, replace)

* Directional model
use with_insample_pred_UK, clear
collapse (mean) pos* medianv* constvar*, by(party)
expand 11						/* Generating 11 hypothetical voters */
sort party
egen id = seq(), f(1) t(11)
gen position=id					/* Voters' ideological stands vary between 0 and 10 */

* Linear predictions varying w/ ideological stands of hypothetical voters on the left-right dimension
forval j=1/7 {
gen chdir`j'=(pos`j'-6)*(medianv`j'-6)
}
replace chdir4=(pos4-6)*(position-6)
mat score xb_left=b_m2c, equation(eq1)

* Alternative choice set compositions
* Labour and Conservative parties in the Choice Set
gen phi1=0
replace phi1=1 if inlist(party, 1, 2) 
* Labour, Conservative, Alliance
gen phi2=0
replace phi2=1 if inlist(party, 1, 2, 3)
* Labour and Alliance
gen phi3=0
replace phi3=1 if inlist(party, 2, 3)

* Out-of-sample predictions
replace constvar3=0
mat score temp=b_m2c, equation(eq2) 
gen phi0=1/(1+exp(-temp))

forval j = 0/3 {
tempvar vc denominator
gen `vc'=phi`j'*exp(xb_left)
egen `denominator'=total(`vc'), by(id)
gen pr_left_s`j'=`vc'/`denominator'
}

* Predictions from Model D1
tempvar vc denominator
mat score xb_m2a=b_m2a, equation(eq1)
tempvar vc denominator
gen `vc'=exp(xb_m2a)
egen `denominator'=total(`vc'), by(id)
gen pr_left_m2a=`vc'/`denominator'

* Predictions from Model D2
tempvar vc denominator
mat score xb_m2b=b_m2b, equation(eq1) 
gen `vc'=exp(xb_m2b)
egen `denominator'=total(`vc'), by(id)
gen pr_left_m2b=`vc'/`denominator'

twoway (connected pr_left_s1 position, lpattern(dot) lcolor(black)) ///
(connected pr_left_s2 position, lpattern(shortdash) lcolor(black)) ///
(connected pr_left_s3 position, lpattern(solid) lcolor(black)) if party==2, ////
legend(order(1 "Labour and Conservative" 2 "Labour, Conservative, Alliance" ///
3 "Labour, Alliance") symxsize(4) rows(1) size(medsmall)) ///
xline(2.93) text(0.015 2.8 "Labour""Party Position", place(nw) j(right) size(small)) ///
ytitle("Pr(Labour Vote=1)", size(medsmall)) xtitle("Voter Position on the Nationalization-privatization Scale", size(medsmall)) ///
ylab(0(.2)1, grid angle(0) labsize(medsmall) gmax) xlab(1(2)11, labsize(medsmall) gmax) ///
title("Directional Theory (Model D3)", size(medium)) nodraw name(votedir1, replace)
 
twoway (line pr_left_m2a position, lpattern(dot) lcolor(black)) ///
(line pr_left_m2b position, lpattern(shortdash) lcolor(black)) ///
(line pr_left_s0 position, lpattern(solid) lcolor(black)) if party==2, ////
legend(order(1 "Model P1/D1 Predictions" 2 "Model P2/D2 Predictions" 3 "Model P3/D3 Predictions (with Predicted Inclusion Probabilities)") symxsize(4) rows(1) size(medsmall)) ///
xline(2.93) text(0.015 2.8 "Labour""Party Position", place(nw) j(right) size(small)) ///
ytitle("Pr(Labour Vote=1)", size(medsmall)) xtitle("Voter Position on the Nationalization-privatization Scale", size(medsmall)) ///
ylab(, grid angle(0) labsize(medsmall)) xlab(1(2)11, labsize(medsmall)) ysca(r(0(.2)1)) ///
title("Directional Theory (Models D1, D2, and D3)", size(medium)) nodraw name(votedir2, replace)

** Figure A3a: Predictions from the Models with and without Varying Choice Sets
grc1leg voteprox2 votedir2, ycommon xcommon legendfrom(votedir2) iscale(1)
graph display, xsize(7) ysize(3.5)
graph export "Figure3a_UK.pdf", replace

** Figure A3b: CCCL Predictions for Varying Hypothetical Choice Set Compositions
grc1leg voteprox1 votedir1, ycommon xcommon legendfrom(votedir1) iscale(1)
graph display, xsize(7) ysize(3.5)
graph export "Figure3b_UK.pdf", replace

** Figure A4: Conservative Party’s Vote Share as a Function of Its Stance on the Left-Right Scale (United Kingdom, 1987)
* Proximity model
use with_insample_pred_UK, clear

mata: mata clear
order voterpos* pos* constvar*, sequential
putmata voterpos=(voterpos*) partypos=(pos*) constvar=(constvar*) party=party id=id, replace
mata
N=rows(partypos)
J=3	/* Number of parties */
kappa=st_matrix("b_m1c")
gamma_c=kappa[1, 8..11]
beta_c=kappa[1, 1..7]
beta_b=st_matrix("b_m1b")

position=range(1, 11, .05)
convote=J(rows(position), 3, .)
compvote=J(rows(position), 3, .)

for (i=1; i<=rows(position); i++) { 
	for (j=1; j<=N; j++){
		if (party[j]==1) partypos[j, 4]=position[i]
		} 
	X_c=(voterpos:-partypos):^2
	extremity=sqrt(rowsum((partypos:-6):^2))
	Z=constvar[, 1], extremity, constvar[, 3], J(N, 1, 1) 
	X_b=X_c, constvar[, 1], extremity, constvar[, 3]
	
	endogphi=(1:+exp(0:-Z*gamma_c')):^(-1)	
	xb_c=X_c*(beta_c[1, 1..7])' 
	xb_b=X_b*beta_b'
	part1=exp(xb_c):*endogphi 
	part2=exp(xb_c)
	part3=exp(xb_b)
	penxb=part1, part2, part3
	indvote=J(N, 3, .)
	for (j=1; j<=N; j++) { 
		indvote[j, ]=penxb[j, ]:/colsum(select(penxb, id:==id[j]))
		}
	aggvote=J(J, cols(indvote), .)
	for (j=1; j<=J; j++) {
		aggvote[j, ]=mean(select(indvote, party:==j))
		}
	convote[i, ]=aggvote[1, ]
	compvote[i, ]=colmax(aggvote[2..3, ])
}
end
clear
getmata position=position (convote*)=convote (compvote*)=compvote

twoway line convote1 compvote1 position, lpattern(solid shortdash) lcolor(black black) xline(9.14) ///
text(.185 9 "Conservative""Party Position", place(nw) j(right) size(small)) ///
xtitle("Conservative Party Position on the Nationalization-privatization Scale", size(medsmall)) title("a1. Pr(Inclusion) = Model P3 Predictions for All Parties", size(medsmall) pos(11)) ///
ylab(.2(.1).6, gmax) xlab(1(2)11) ///
legend(order(1 "Conservative Party Vote Share" 2 "Top Competitor's Vote Share") symxsize(4) rows(1) size(medium)) nodraw name(p1, replace)

twoway line convote2 compvote2 position, lpattern(solid shortdash) lcolor(black black) xline(9.14) ///
text(.185 9 "Conservative""Party Position", place(nw) j(right) size(small)) ///
xtitle("Conservative Party Position on the Nationalization-privatization Scale", size(medsmall)) title("a2. Pr(Inclusion) = 1 for All Parties", size(medsmall) pos(11)) ///
ylab(.2(.1).6, gmax) xlab(1(2)11) ///
legend(order(1 "Conservative Party Vote Share" 2 "Top Competitor's Vote Share") symxsize(4) rows(1) size(medium)) nodraw name(p2, replace)

twoway line convote3 compvote3 position, lpattern(solid shortdash) lcolor(black black) xline(9.14) ///
text(.185 9 "Conservative""Party Position", place(nw) j(right) size(small)) ///
xtitle("Conservative Party Position on the Nationalization-privatization Scale", size(medsmall)) title("a3. Model P2 Predictions", size(medsmall) pos(11)) ///
ylab(.2(0.1).6, gmax) xlab(1(2)11) ///
legend(order(1 "Conservative Party Vote Share" 2 "Top Competitor's Vote Share") symxsize(4) rows(1) size(medium)) nodraw name(p3, replace)

** Figure A4a: Proximity Theory (Models P3 and P2)
grc1leg p1 p2 p3, ycommon rows(1) legendfrom(p1)
graph display, xsize(10.5) ysize(3.5)
graph export "Figure4a_UK.pdf", replace

* Directional model
use with_insample_pred_UK, clear

mata: mata clear
order voterpos* pos* constvar*, sequential
putmata voterpos=(voterpos*) partypos=(pos*) constvar=(constvar*) party=party id=id, replace
mata
N=rows(partypos)
J=3 /* Number of parties */
kappa=st_matrix("b_m2c")
gamma_c=kappa[1, 8..11]
beta_c=kappa[1, 1..7]
beta_b=st_matrix("b_m2b")

position=range(1, 11, .05)
convote=J(rows(position), 3, .)
compvote=J(rows(position), 3, .)

for (i=1; i<=rows(position); i++) { 
	for (j=1; j<=N; j++){
		if (party[j]==1) partypos[j, 4]=position[i]
		} 
	X_c=(voterpos:-6):*(partypos:-6)
	extremity=sqrt(rowsum((partypos:-6):^2))
	Z=constvar[, 1], extremity, constvar[, 3], J(N, 1, 1) 
	X_b=X_c, constvar[, 1], extremity, constvar[, 3]
	
	endogphi=(1:+exp(0:-Z*gamma_c')):^(-1)	
	xb_c=X_c*(beta_c[1, 1..7])' 
	xb_b=X_b*beta_b'
	part1=exp(xb_c):*endogphi 
	part2=exp(xb_c)
	part3=exp(xb_b)
	penxb=part1, part2, part3
	indvote=J(N, 3, .)
	for (j=1; j<=N; j++) { 
		indvote[j, ]=penxb[j, ]:/colsum(select(penxb, id:==id[j]))
		}
	aggvote=J(J, cols(indvote), .)
	for (j=1; j<=J; j++) {
		aggvote[j, ]=mean(select(indvote, party:==j))
		}
	convote[i, ]=aggvote[1, ]
	compvote[i, ]=colmax(aggvote[2..3, ])
}
end
clear
getmata position=position (convote*)=convote (compvote*)=compvote

twoway line convote1 compvote1 position, lpattern(solid shortdash) lcolor(black black) xline(9.14) ///
text(.205 9 "Conservative""Party Position", place(nw) j(right) size(small)) ///
xtitle("Conservative Party Position on the Nationalization-privatization Scale", size(medsmall)) title("b1. Pr(Inclusion) = Model P3 Predictions for All Parties", size(medsmall) pos(11)) ///
ylab(.2(.1).6, gmax) xlab(1(2)11) ///
legend(order(1 "Conservative Party Vote Share" 2 "Top Competitor's Vote Share") symxsize(4) rows(1) size(medium)) nodraw name(d1, replace)

twoway line convote2 compvote2 position, lpattern(solid shortdash) lcolor(black black) xline(9.14) ///
text(.205 9 "Conservative""Party Position", place(nw) j(right) size(small)) ///
xtitle("Conservative Party Position on the Nationalization-privatization Scale", size(medsmall)) title("b2. Pr(Inclusion) = 1 for All Parties", size(medsmall) pos(11)) ///
ylab(.2(.1).6, gmax) xlab(1(2)11) ///
legend(order(1 "Conservative Party Vote Share" 2 "Top Competitor's Vote Share") symxsize(4) rows(1) size(medium)) nodraw name(d2, replace)

twoway line convote3 compvote3 position, lpattern(solid shortdash) lcolor(black black) xline(9.14) ///
text(.205 9 "Conservative""Party Position", place(nw) j(right) size(small)) ///
xtitle("Conservative Party Position on the Nationalization-privatization Scale", size(medsmall)) title("b3. Model P2 Predictions", size(medsmall) pos(11)) ///
ylab(.2(.1).6, gmax) xlab(1(2)11) ///
legend(order(1 "Conservative Party Vote Share" 2 "Top Competitor's Vote Share") symxsize(4) rows(1) size(medium)) nodraw name(d3, replace)

** Figure A4b: Directional Theory (Models D3 and D2)
grc1leg d1 d2 d3, ycommon rows(1) legendfrom(d1)
graph display, xsize(10.5) ysize(3.5)
graph export "Figure4b_UK.pdf", replace
