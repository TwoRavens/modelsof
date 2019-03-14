*****Replication code for
*****"'And why is that a partisan issue?' Source cues, persuasion, and school lunches"
*****Cindy D. Kam 
*****Journal of Politics

use "Kam school lunch.dta", clear

svyset [pweight=weight]
g double wt=round(weight*100)

*Treatment conditions
svy: tab VAN150_treat
*Version A = Michelle Obama
*Version B = US Military
*Version C = scientific experts on childhood obesity
svy: tab VAN150 VAN150_treat, col
recode VAN150_treat (1=1 "Michelle Obama")(2=3 "US Military")(3=2 "Scientific Experts")(else=.), gen(expcond)

recode VAN150 (1=1 "Favor Str")(2=.67)(3=.33)(4=0 "Oppose Str")(else=.), gen(standards)
recode VAN150_treat (1=1 "Michelle_treat")(2 3=0)(else=.), gen(Michelle_treat)
recode VAN150_treat (2=1 "Mil_treat")(1 3=0)(else=.), gen(Mil_treat)
recode VAN150_treat (3=1 "Sci_treat")(1 2=0)(else=.), gen(Sci_treat)

svy: mean VAN111
svy: mean VAN113
svy: mean VAN104

gen ftmichelle = VAN104/100
gen ftmil = VAN111/100
gen ftsci = VAN113/100
lab var ftmichelle "FT: Michelle Obama"
lab var ftmil "FT: Military"
lab var ftsci "FT: Scientists"

gen ftmichellesci = ftmichelle-ftsci
gen ftmichellemil = ftmichelle-ftmil
svy: reg ftmichellesci 
svy: reg ftmichellemil
sdtest ftmichelle =ftsci
sdtest ftmichelle =ftmil
corr_svy ftmichelle ftmil ftsci [pw=weight]


*PARTY ID
recode pid7 (1=0 "Str Dem")(2=.17)(3=.33)(4 8=.5)(5=.67)(6=.83)(7=1 "Str GOP")(else=.), gen(pid7cata)


//DEPENDENT VARIABLES
svy: mean standards, over(VAN150_treat)
svy: tab standards expcond, col

svy, subpop(Michelle_treat): oprobit standards pid7cata 
est store Michelle
svy, subpop(Mil_treat): oprobit standards pid7cata 
est store Mil
svy, subpop(Sci_treat): oprobit standards pid7cata
est store Sci
est table Michelle Sci Mil , b(%9.2f) star(.1 .05 .01)
est table Michelle Sci Mil , b(%9.2f) se stats(N_sub) style(col)
suest Michelle Sci, svy
test [Michelle_standards = Sci_standards]
suest Michelle Mil, svy
test [Michelle_standards = Mil_standards]
suest Mil Sci, svy
test [Sci_standards = Mil_standards]


**Generate figure using the separate sample estimation
preserve 
collapse Michelle_treat Mil_treat Sci_treat
replace Michelle_treat=0
replace Mil_treat=0
replace Sci_treat=0
expand 7
egen pid7cata =fill(0(.167)1)
lab var pid7cata "Partisanship"
est restore Michelle
predict p1 p2 p3 p4 
gen favor = (p3 +p4)
gen zero = 0
gen cut = -1
mkmat pid7cata zero cut zero, matrix(X)
matrix b = e(b)'
matrix V=e(V)
matrix Xb=X*b
matrix list Xb
svmat Xb, name(Xb)
svmat X, names(Xval)
gen phat = normal(Xb)
matrix XVXt=X*V*X'
matrix diag = vecdiag(XVXt)'
svmat diag, name(diag)
gen fhat = normalden(Xb)
gen seFhat = sqrt(diag*fhat^2)
gen ub = phat+1.96*seFhat
gen lb = phat-1.96*seFhat
est restore Mil
predict p1Mil p2Mil p3Mil p4Mil
gen favorMil = (p3Mil +p4Mil)
matrix bMil = e(b)'
matrix VMil=e(V)
matrix XbMil=X*bMil
svmat XbMil, name(XbMil)
gen phatMil = normal(XbMil)
matrix XVMilXt=X*VMil*X'
matrix diagMil = vecdiag(XVMilXt)'
svmat diagMil, name(diagMil)
gen fhatMil = normalden(XbMil)
gen seFhatMil = sqrt(diagMil*fhatMil^2)
gen ubMil = phatMil+1.96*seFhatMil
gen lbMil = phatMil-1.96*seFhatMil
est restore Sci
predict p1Sci p2Sci p3Sci p4Sci
gen favorSci = (p3Sci +p4Sci)
matrix bSci = e(b)'
matrix VSci=e(V)
matrix XbSci=X*bSci
svmat XbSci, name(XbSci)
gen phatSci = normal(XbSci)
matrix XVSciXt=X*VSci*X'
matrix diagSci = vecdiag(XVSciXt)'
svmat diagSci, name(diagSci)
gen fhatSci = normalden(XbSci)
gen seFhatSci = sqrt(diagSci*fhatSci^2)
gen ubSci = phatSci+1.96*seFhatSci
gen lbSci = phatSci-1.96*seFhatSci
table pid7cat favorSci
table pid7cat favor
twoway (connected favor pid7cata, msymbol(i) lpattern(solid))(connected favorSci pid7cata, msymbol(i) lpattern(dash))(connected favorMil pid7cata, msymbol(Oh) lpattern(dash))(rcap ub lb pid7cata, lcolor(gs12)) (rcap ubMil lbMil pid7cata, lcolor(gs12)) (rcap ubSci lbSci pid7cata, lcolor(gs12)) , name(basic, replace) legend(subtitle("Source Cue Conditions") lab(1 "Michelle Obama") lab(2 "Scientific experts") lab(3 "US Military") col(3) order(1 2 3) region(lstyle(none)) symxsize(4)) ytitle("Pr(Favor Nutritional Standards)", margin(large)) ylabel(0(.2)1) xtitle("Partisanship") xlabel(0 "Strong Democrat" 1 "Strong Republican") xtick(0(.1667)1)  graphregion(margin(l=5 r=15))  
restore

gen pid7catMil=pid7cata*Mil_treat
gen pid7catMichelle=pid7cata*Michelle_treat
svy: oprobit standards pid7cata pid7catMil pid7catMichelle Mil_treat Michelle_treat
est store pidonly
est table pidonly , b(%9.2f) se stats(N)
est table pidonly , b(%9.2f) star(.1 .05 .01) stats(N)


*****Racism and Sexism spillover
/*Racial Resentment*/
recode VAN405 VAN810 (1=1)(2=.75)(3=.5)(4=.25)(5=0)(else=.), gen(resent1 resent4)
recode VAN406 VAN809 (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(resent2 resent3)
alpha resent*
gen resent=(resent1+resent2+resent3+resent4)/4
gen resentpre = (resent1+resent2)/2

/*Modern sexism*/
recode VAN805 VAN808 (1=1)(2=.75)(3=.5)(4=.25)(5=0)(else=.), gen(modsex1 modsex4)
recode VAN806 VAN807 (1=0)(2=.25)(3=.5)(4=.75)(5=1)(else=.), gen(modsex2 modsex3)
alpha modsex*
gen modsex = (modsex1+modsex2+modsex3+modsex4)/4

/*FTs*/
gen ftblack = VAN105/100
gen ftfem = VAN112/100

gen racism = ((resent-ftb)/2)+.5
gen sexism = ((modsex-ftfem)/2)+.5
svy: mean racism sexism 

svy, subpop(Michelle_treat): oprobit standards pid7cata racism sexism 
est store Michelle
svy, subpop(Mil_treat): oprobit standards pid7cata racism sexism 
est store Mil
svy, subpop(Sci_treat): oprobit standards pid7cata racism sexism 
est store Sci
est table Michelle Sci Mil , b(%9.2f) star(.1 .05 .01)
est table Michelle Sci Mil , b(%9.2f) se style(col) stats(N_sub)
suest Michelle Sci, svy
test [Michelle_standards = Sci_standards]
suest Michelle Mil, svy
test [Michelle_standards = Mil_standards]
suest Mil Sci, svy
test [Sci_standards = Mil_standards]

//generating predicted values across covariates, by treatment condition
preserve
keep wt pid7cata Michelle_treat Mil_treat racism sexism
save "graphing data.dta", replace
gen racism_true = racism
gen sexism_true = sexism
keep wt pid7cata Michelle_treat Mil_treat racism sexism racism_true sexism_true
save "attdata.dta", replace
use "graphing data.dta", clear
keep pid7cata Michelle_treat Mil_treat racism sexism
collapse pid7cata Michelle_treat Mil_treat racism sexism
replace Michelle_treat=0
replace Mil_treat=0
expand 11
drop racism
egen racism =fill(0(.1)1)
expand 2
expand 2
replace Michelle_treat = 1 in 12/22
replace Mil_treat = 1 in 23/33
gen Sci_treat = 1 in 1/11
replace pid7cata = .5
est restore Michelle
predict p1Michelle p2Michelle p3Michelle p4Michelle 
est restore Mil
predict p1Mil p2Mil p3Mil p4Mil
est restore Sci
predict p1Sci p2Sci p3Sci p4Sci
gen favor = .
replace favor = (p3Michelle+p4Michelle) if Michelle_treat==1
replace favor = (p3Mil+p4Mil) if Mil_treat==1
replace favor = (p3Sci+p4Sci) if Sci_treat==1
append using "attdata.dta"
twoway (connected favor racism if Michelle_treat==1, msymbol(i) lpattern(solid)) (connected favor racism if Sci_treat==1, msymbol(i) lpattern(dash))(connected favor racism if Mil_treat==1, msymbol(Oh) lpattern(dash)) (histogram racism_true [fw=wt], yaxis(2) percent color(gs12)), name(racismbycue, replace) legend(off) ytitle("Pr(Favor Nutritional Standards)", margin(large)) ylabel(0(.2)1, axis(1))  ytick(0(20)20, axis(2)) ylabel(none, axis(2)) xtitle("Attitudes towards Blacks") xlabel(0 "Positive" 1 "Negative") xtick(0(.1667)1)  ytitle("Histogram, Attitude towards Blacks", axis(2))
restore


preserve
keep pid7cata Michelle_treat Mil_treat racism sexism
collapse pid7cata Michelle_treat Mil_treat racism sexism
replace Michelle_treat=0
replace Mil_treat=0
expand 11
drop sexism
egen sexism=fill(0(.1)1)
expand 2
expand 2
replace Michelle_treat = 1 in 12/22
replace Mil_treat = 1 in 23/33
gen Sci_treat = 1 in 1/11
replace pid7cata = .5
est restore Michelle
predict p1Michelle p2Michelle p3Michelle p4Michelle 
est restore Mil
predict p1Mil p2Mil p3Mil p4Mil
est restore Sci
predict p1Sci p2Sci p3Sci p4Sci
gen favor = .
replace favor = (p3Michelle+p4Michelle) if Michelle_treat==1
replace favor = (p3Mil+p4Mil) if Mil_treat==1
replace favor = (p3Sci+p4Sci) if Sci_treat==1
append using "attdata.dta"
twoway (connected favor sexism if Michelle_treat==1, msymbol(i) lpattern(solid)) (connected favor sexism if Sci_treat==1, msymbol(i) lpattern(dash))(connected favor sexism if Mil_treat==1, msymbol(Oh) lpattern(dash)) (histogram sexism_true [fw=wt], yaxis(2) percent color(gs12)), name(sexismbycue, replace) legend(off) ytitle("Pr(Favor Nutritional Standards)", margin(large)) ylabel(0(.2)1, axis(1)) ytick(0(20)20, axis(2)) ylabel(none, axis(2)) xtitle("Attitudes towards Women") xlabel(0 "Positive" 1 "Negative") xtick(0(.1667)1)  ytitle("Histogram, Attitude towards Women", axis(2))
restore
graph combine racismbycue sexismbycue, row(1) xsize(9) ysize(4.5)



//OTHER DEPENDENT VARIABLES
recode VAN151 (1=1 "great deal")(2=.67)(3=.33)(4=0 "not at all")(else=.), gen(lunch_cause)
recode VAN152 (1=1 "ext serious")(2=.67)(3=.33)(4 5=0 "Not too/not at all")(else=.), gen(obesity_serious)
recode VAN153 (1=1 "Def yes")(2=.67)(3=.33)(4=0 "Def no")(else=.), gen(more_taxes)
recode VAN153 (1=0 "Def yes")(2=.33)(3=.67)(4=1 "Def no")(else=.), gen(no_more_taxes)

svy: tab VAN151 expcond, col
svy: tab VAN152 expcond, col
svy: tab VAN153 expcond, col

svy: probit lunch_cause Mil_treat Sci_treat
svy: probit obesity_serious Mil_treat Sci_treat
svy: probit more_taxes Mil_treat Sci_treat
svy: probit no_more_taxes Mil_treat Sci_treat

//party and then racism & sexism 
svy, subpop(Michelle_treat): oprobit lunch_cause pid7cata 
est store Michelle
svy, subpop(Mil_treat): oprobit lunch_cause pid7cata 
est store Mil
svy, subpop(Sci_treat): oprobit lunch_cause pid7cata
est store Sci
est table Michelle Sci Mil , b(%9.2f) star(.1 .05 .01)
est table Michelle Sci Mil , b(%9.2f) se stats(N_sub) style(col)
suest Michelle Sci, svy
test [Michelle_lunch_cause= Sci_lunch_cause]
suest Michelle Mil, svy
test [Michelle_lunch_cause= Mil_lunch_cause]
suest Mil Sci, svy
test [Sci_lunch_cause = Mil_lunch_cause]

preserve 
collapse Michelle_treat Mil_treat Sci_treat
replace Michelle_treat=0
replace Mil_treat=0
replace Sci_treat=0
expand 7
egen pid7cata =fill(0(.167)1)
lab var pid7cata "Partisanship"
est restore Michelle
predict p1 p2 p3 p4 
gen favor = (p3 +p4)
est restore Mil
predict p1Mil p2Mil p3Mil p4Mil
gen favorMil = (p3Mil +p4Mil)
est restore Sci
predict p1Sci p2Sci p3Sci p4Sci
gen favorSci = (p3Sci +p4Sci)
twoway (connected favor pid7cata, msymbol(i) lpattern(solid)) (connected favorSci pid7cata, msymbol(i) lpattern(dash)) (connected favorMil pid7cata, msymbol(Oh) lpattern(dash)), name(lunch_cause, replace)  ytitle("Pr(Lunches a Cause)", margin(large)) ylabel(0(.2)1) xtitle("Partisanship") xlabel(0 "Strong Democrat" 1 "Strong Republican") xtick(0(.1667)1)  graphregion(margin(l=5 r=15)) legend(off)
restore

svy, subpop(Michelle_treat): oprobit obesity_serious pid7cata 
est store Michelle
svy, subpop(Mil_treat): oprobit obesity_serious pid7cata 
est store Mil
svy, subpop(Sci_treat): oprobit obesity_serious pid7cata
est store Sci
est table Michelle Sci Mil , b(%9.2f) star(.1 .05 .01)
est table Michelle Sci Mil , b(%9.2f) se stats(N_sub) style(col)
suest Michelle Sci, svy
test [Michelle_obesity_serious = Sci_obesity_serious ]
suest Michelle Mil, svy
test [Michelle_obesity_serious = Mil_obesity_serious ]
suest Mil Sci, svy
test [Sci_obesity_serious  = Mil_obesity_serious ]

preserve 
collapse Michelle_treat Mil_treat Sci_treat
replace Michelle_treat=0
replace Mil_treat=0
replace Sci_treat=0
expand 7
egen pid7cata =fill(0(.167)1)
lab var pid7cata "Partisanship"
est restore Michelle
predict p1 p2 p3 p4 
gen favor = (p3 +p4)
est restore Mil
predict p1Mil p2Mil p3Mil p4Mil
gen favorMil = (p3Mil +p4Mil)
est restore Sci
predict p1Sci p2Sci p3Sci p4Sci
gen favorSci = (p3Sci +p4Sci)
twoway (connected favor pid7cata, msymbol(i) lpattern(solid)) (connected favorSci pid7cata, msymbol(i) lpattern(dash)) (connected favorMil pid7cata, msymbol(Oh) lpattern(dash)), name(obesity_serious, replace) ytitle("Pr(Obesity Serious)", margin(large)) ylabel(0(.2)1) xtitle("Partisanship") xlabel(0 "Strong Democrat" 1 "Strong Republican") xtick(0(.1667)1)  graphregion(margin(l=5 r=15))  legend(off)
restore

svy, subpop(Michelle_treat): oprobit more_taxes pid7cata 
est store Michelle
svy, subpop(Mil_treat): oprobit more_taxes pid7cata 
est store Mil
svy, subpop(Sci_treat): oprobit more_taxes pid7cata
est store Sci
est table Michelle Sci Mil , b(%9.2f) star(.1 .05 .01)
est table Michelle Sci Mil , b(%9.2f) se stats(N_sub) style(col)
suest Michelle Sci, svy
test [Michelle_more_taxes  = Sci_more_taxes ]
suest Michelle Mil, svy
test [Michelle_more_taxes = Mil_more_taxes ]
suest Mil Sci, svy
test [Sci_more_taxes  = Mil_more_taxes ]

preserve 
collapse Michelle_treat Mil_treat Sci_treat
replace Michelle_treat=0
replace Mil_treat=0
replace Sci_treat=0
expand 7
egen pid7cata =fill(0(.167)1)
lab var pid7cata "Partisanship"
est restore Michelle
predict p1 p2 p3 p4 
gen favor = (p3 +p4)
est restore Mil
predict p1Mil p2Mil p3Mil p4Mil
gen favorMil = (p3Mil +p4Mil)
est restore Sci
predict p1Sci p2Sci p3Sci p4Sci
gen favorSci = (p3Sci +p4Sci)
twoway (connected favor pid7cata, msymbol(i) lpattern(solid)) (connected favorSci pid7cata, msymbol(i) lpattern(dash)) (connected favorMil pid7cata, msymbol(Oh) lpattern(dash)), name(more_taxes, replace) ytitle("Pr(More Taxes)", margin(large)) ylabel(0(.2)1) xtitle("Partisanship") xlabel(0 "Strong Democrat" 1 "Strong Republican") xtick(0(.1667)1)  graphregion(margin(l=5 r=15))   legend(off)
restore
graph combine lunch_cause obesity_serious more_taxes, ycommon xcommon row(1) xsize(9) ysize(3) altshrink


//////SPILLOVER FOR ALTERNATIVE DVS
svy, subpop(Michelle_treat): oprobit lunch_cause pid7cata racism sexism 
est store Michelle
svy, subpop(Mil_treat): oprobit lunch_cause pid7cata racism sexism 
est store Mil
svy, subpop(Sci_treat): oprobit lunch_cause pid7cata racism sexism 
est store Sci
est table Michelle Sci Mil , b(%9.2f) star(.1 .05 .01)
est table Michelle Sci Mil , b(%9.2f) se style(col) stats(N_sub)
suest Michelle Sci, svy
test [Michelle_lunch_cause = Sci_lunch_cause]
suest Michelle Mil, svy
test [Michelle_lunch_cause = Mil_lunch_cause]
suest Mil Sci, svy
test [Sci_lunch_cause = Mil_lunch_cause]

preserve
keep pid7cata Michelle_treat Mil_treat racism sexism
collapse pid7cata Michelle_treat Mil_treat racism sexism
replace Michelle_treat=0
replace Mil_treat=0
expand 11
drop racism
egen racism =fill(0(.1)1)
expand 2
expand 2
replace Michelle_treat = 1 in 12/22
replace Mil_treat = 1 in 23/33
gen Sci_treat = 1 in 1/11
replace pid7cata = .5
est restore Michelle
predict p1Michelle p2Michelle p3Michelle p4Michelle 
est restore Mil
predict p1Mil p2Mil p3Mil p4Mil
est restore Sci
predict p1Sci p2Sci p3Sci p4Sci
gen favor = .
replace favor = (p3Michelle+p4Michelle) if Michelle_treat==1
replace favor = (p3Mil+p4Mil) if Mil_treat==1
replace favor = (p3Sci+p4Sci) if Sci_treat==1
twoway (connected favor racism if Michelle_treat==1, msymbol(i) lpattern(solid)) (connected favor racism if Sci_treat==1, msymbol(i) lpattern(dash))(connected favor racism if Mil_treat==1, msymbol(Oh) lpattern(dash)), name(lunch_cause_racismbycue, replace) legend(off) ytitle("Pr(Lunches a Cause)", margin(large)) ylabel(0(.2)1, axis(1))  xtitle("Attitudes towards Blacks") xlabel(0 "Positive" 1 "Negative") xtick(0(.2)1)  graphregion(margin(l=5 r=5))   
restore


preserve
keep pid7cata Michelle_treat Mil_treat racism sexism
collapse pid7cata Michelle_treat Mil_treat racism sexism
replace Michelle_treat=0
replace Mil_treat=0
expand 11
drop sexism
egen sexism=fill(0(.1)1)
expand 2
expand 2
replace Michelle_treat = 1 in 12/22
replace Mil_treat = 1 in 23/33
gen Sci_treat = 1 in 1/11
replace pid7cata = .5
est restore Michelle
predict p1Michelle p2Michelle p3Michelle p4Michelle 
est restore Mil
predict p1Mil p2Mil p3Mil p4Mil
est restore Sci
predict p1Sci p2Sci p3Sci p4Sci
gen favor = .
replace favor = (p3Michelle+p4Michelle) if Michelle_treat==1
replace favor = (p3Mil+p4Mil) if Mil_treat==1
replace favor = (p3Sci+p4Sci) if Sci_treat==1
twoway (connected favor sexism if Michelle_treat==1, msymbol(i) lpattern(solid)) (connected favor sexism if Sci_treat==1, msymbol(i) lpattern(dash))(connected favor sexism if Mil_treat==1, msymbol(Oh) lpattern(dash)), name(lunch_cause_sexismbycue, replace) legend(off) ytitle("Pr(Lunches a Cause)", margin(large)) ylabel(0(.2)1, axis(1))  xtitle("Attitudes towards Women") xlabel(0 "Positive" 1 "Negative") xtick(0(.2)1)  graphregion(margin(l=5 r=5))   
restore


svy, subpop(Michelle_treat): oprobit obesity_serious pid7cata racism sexism 
est store Michelle
svy, subpop(Mil_treat): oprobit obesity_serious pid7cata racism sexism 
est store Mil
svy, subpop(Sci_treat): oprobit obesity_serious pid7cata racism sexism 
est store Sci
est table Michelle Sci Mil , b(%9.2f) star(.1 .05 .01)
est table Michelle Sci Mil , b(%9.2f) se style(col) stats(N_sub)
suest Michelle Sci, svy
test [Michelle_obesity_serious= Sci_obesity_serious]
suest Michelle Mil, svy
test [Michelle_obesity_serious= Mil_obesity_serious]
suest Mil Sci, svy
test [Sci_obesity_serious= Mil_obesity_serious]

preserve
keep pid7cata Michelle_treat Mil_treat racism sexism
collapse pid7cata Michelle_treat Mil_treat racism sexism
replace Michelle_treat=0
replace Mil_treat=0
expand 11
drop racism
egen racism =fill(0(.1)1)
expand 2
expand 2
replace Michelle_treat = 1 in 12/22
replace Mil_treat = 1 in 23/33
gen Sci_treat = 1 in 1/11
replace pid7cata = .5
est restore Michelle
predict p1Michelle p2Michelle p3Michelle p4Michelle 
est restore Mil
predict p1Mil p2Mil p3Mil p4Mil
est restore Sci
predict p1Sci p2Sci p3Sci p4Sci
gen favor = .
replace favor = (p3Michelle+p4Michelle) if Michelle_treat==1
replace favor = (p3Mil+p4Mil) if Mil_treat==1
replace favor = (p3Sci+p4Sci) if Sci_treat==1
twoway (connected favor racism if Michelle_treat==1, msymbol(i) lpattern(solid)) (connected favor racism if Sci_treat==1, msymbol(i) lpattern(dash))(connected favor racism if Mil_treat==1, msymbol(Oh) lpattern(dash)), name(obesity_serious_racismbycue, replace) legend(off) ytitle("Pr(Obesity Serious)", margin(large)) ylabel(0(.2)1, axis(1))  xtitle("Attitudes towards Blacks") xlabel(0 "Positive" 1 "Negative") xtick(0(.2)1)  graphregion(margin(l=5 r=5))   
restore


preserve
keep pid7cata Michelle_treat Mil_treat racism sexism
collapse pid7cata Michelle_treat Mil_treat racism sexism
replace Michelle_treat=0
replace Mil_treat=0
expand 11
drop sexism
egen sexism=fill(0(.1)1)
expand 2
expand 2
replace Michelle_treat = 1 in 12/22
replace Mil_treat = 1 in 23/33
gen Sci_treat = 1 in 1/11
replace pid7cata = .5
est restore Michelle
predict p1Michelle p2Michelle p3Michelle p4Michelle 
sum p1Michelle p2Michelle p3Michelle p4Michelle 
est restore Mil
predict p1Mil p2Mil p3Mil p4Mil
est restore Sci
predict p1Sci p2Sci p3Sci p4Sci
gen favor = .
replace favor = (p3Michelle+p4Michelle) if Michelle_treat==1
replace favor = (p3Mil+p4Mil) if Mil_treat==1
replace favor = (p3Sci+p4Sci) if Sci_treat==1
twoway (connected favor sexism if Michelle_treat==1, msymbol(i) lpattern(solid)) (connected favor sexism if Sci_treat==1, msymbol(i) lpattern(dash))(connected favor sexism if Mil_treat==1, msymbol(Oh) lpattern(dash)), name(obesity_serious_sexismbycue, replace) legend(off) ytitle("Pr(Obesity Serious)", margin(large)) ylabel(0(.2)1, axis(1))  xtitle("Attitudes towards Women") xlabel(0 "Positive" 1 "Negative") xtick(0(.2)1)  graphregion(margin(l=5 r=5))   
restore

svy, subpop(Michelle_treat): oprobit more_taxes pid7cata racism sexism 
est store Michelle
svy, subpop(Mil_treat): oprobit more_taxes pid7cata racism sexism 
est store Mil
svy, subpop(Sci_treat): oprobit more_taxes pid7cata racism sexism 
est store Sci
est table Michelle Sci Mil , b(%9.2f) star(.1 .05 .01)
est table Michelle Sci Mil , b(%9.2f) se style(col) stats(N_sub)
suest Michelle Sci, svy
test [Michelle_more_taxes= Sci_more_taxes]
suest Michelle Mil, svy
test [Michelle_more_taxes= Mil_more_taxes]
suest Mil Sci, svy
test [Sci_more_taxes= Mil_more_taxes]

preserve
keep pid7cata Michelle_treat Mil_treat racism sexism
collapse pid7cata Michelle_treat Mil_treat racism sexism
replace Michelle_treat=0
replace Mil_treat=0
expand 11
drop racism
egen racism =fill(0(.1)1)
expand 2
expand 2
replace Michelle_treat = 1 in 12/22
replace Mil_treat = 1 in 23/33
gen Sci_treat = 1 in 1/11
replace pid7cata = .5
est restore Michelle
predict p1Michelle p2Michelle p3Michelle p4Michelle 
est restore Mil
predict p1Mil p2Mil p3Mil p4Mil
est restore Sci
predict p1Sci p2Sci p3Sci p4Sci
gen favor = .
replace favor = (p3Michelle+p4Michelle) if Michelle_treat==1
replace favor = (p3Mil+p4Mil) if Mil_treat==1
replace favor = (p3Sci+p4Sci) if Sci_treat==1
twoway (connected favor racism if Michelle_treat==1, msymbol(i) lpattern(solid)) (connected favor racism if Sci_treat==1, msymbol(i) lpattern(dash))(connected favor racism if Mil_treat==1, msymbol(Oh) lpattern(dash)), name(more_taxes_racismbycue, replace) legend(off) ytitle("Pr(Pay More in Taxes)", margin(large)) ylabel(0(.2)1, axis(1))  xtitle("Attitudes towards Blacks") xlabel(0 "Positive" 1 "Negative") xtick(0(.2)1)  graphregion(margin(l=5 r=5))   
restore


preserve
keep pid7cata Michelle_treat Mil_treat racism sexism
collapse pid7cata Michelle_treat Mil_treat racism sexism
replace Michelle_treat=0
replace Mil_treat=0
expand 11
drop sexism
egen sexism=fill(0(.1)1)
expand 2
expand 2
replace Michelle_treat = 1 in 12/22
replace Mil_treat = 1 in 23/33
gen Sci_treat = 1 in 1/11
replace pid7cata = .5
est restore Michelle
predict p1Michelle p2Michelle p3Michelle p4Michelle 
est restore Mil
predict p1Mil p2Mil p3Mil p4Mil
est restore Sci
predict p1Sci p2Sci p3Sci p4Sci
gen favor = .
replace favor = (p3Michelle+p4Michelle) if Michelle_treat==1
replace favor = (p3Mil+p4Mil) if Mil_treat==1
replace favor = (p3Sci+p4Sci) if Sci_treat==1
twoway (connected favor sexism if Michelle_treat==1, msymbol(i) lpattern(solid)) (connected favor sexism if Sci_treat==1, msymbol(i) lpattern(dash))(connected favor sexism if Mil_treat==1, msymbol(Oh) lpattern(dash)), name(more_taxes_sexismbycue, replace) legend(off) ytitle("Pr(Pay More in Taxes)", margin(large)) ylabel(0(.2)1, axis(1))  xtitle("Attitudes towards Women") xlabel(0 "Positive" 1 "Negative") xtick(0(.2)1)  graphregion(margin(l=5 r=5))   
restore

graph combine lunch_cause_racismbycue obesity_serious_racismbycue more_taxes_racismbycue lunch_cause_sexismbycue obesity_serious_sexismbycue more_taxes_sexismbycue , row(2) ysize(6) xsize(9) xcommon ycommon altshrink


//Open-ends
svy, subpop(codeable): tab MichelleObama expcond, col
svy, subpop(codeable): tab Military expcond, col
svy, subpop(codeable): tab scientists expcond, col


