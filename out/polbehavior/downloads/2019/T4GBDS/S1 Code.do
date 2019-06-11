clear all

use "Study1data.dta"

*Partisanship
gen PID = pid7
recode PID 8/99=.
gen PID01 = (PID-1)/6
gen PIDc = PID - 4
gen PIDext = abs(PID - 4)
gen RD = PID
recode RD 1/3=1 4=. 5/7=0
gen PID3=PID
recode PID3 1/3=1 4=2 5/7=3

label variable RD "Partisanship"
label define rd 0 "Republican" 1 "Democrat"
label values RD rd

*demographics
gen Educ = educ
recode Educ 8/9=.
gen Educ01=(Educ-1)/5
gen Male = gender
recode Male 2=0
gen Age = 2014 - birthyr
gen Age01=(Age-18)/73
gen Black = 0
recode Black 0=1 if race==2
gen Hisp = 0
recode Hisp 0=1 if race==3
gen Attend = pew_churatd
recode Attend 7=. 1=6 2=5 3=4 4=3 5=2 6=1
gen Attend01=(Attend-1)/5

*sophistication
gen knowhou = CC14_309a
recode knowhou 1=1 *=0
gen knowsen = CC14_309b
recode knowsen 2=1 *=0
gen Know = knowhou + knowsen
gen KnowDi = Know
recode KnowDi 1=0 2=1

gen Interest = newsint
recode Interest 7=. 1=4 2=3 3=2 4=1
gen newsblog = CC14_301_1
recode newsblog 2=0 8/9=.
gen newstv = CC14_301_2
recode newstv 2=0 8/9=.
gen newspaper = CC14_301_3
recode newspaper 2=0 8/9=.
gen newsradio = CC14_301_4
recode newsradio 2=0 8/9=.
gen NewsSum = newsblog + newstv + newspaper + newsradio

irt hybrid (grm NewsSum Interest) (2pl knowhou knowsen)
predict LatentAttent, latent
sum LatentAttent
gen LatentAttent01=(LatentAttent-`r(min)')/(`r(max)'-`r(min)')
xtile LatentAttent3=LatentAttent, nq(3)


** issue attitudes

*gun control
gen gun1 = CC14_320a
recode gun1 1=0 2=1 8=.
gen gun2 = CC14_320b
recode gun2 2=0 8=.
gen gun3 = CC14_320c
recode gun3 1=0 2=1 8=.
gen gun4 = CC14_320d
recode gun4 1=0 2=1 8=.
gen gun5 = CC14_320e
recode gun5 2=0 8=.
alpha gun*, item casewise gen(Guns)

*immigration
recode CC14_322_1 1=0 2=1
recode CC14_322_2 2=0
recode CC14_322_3 2=0
recode CC14_322_4 2=0
recode CC14_322_5 2=0
recode CC14_322_6 1=0 2=1
alpha CC14_322*, item casewise gen(Imm)

*abortion
recode CC14_323_1 1=0 2=1 8=.
recode CC14_323_2 2=0 8=.
recode CC14_323_3 2=0 8=.
recode CC14_323_4 2=0 8=.
recode CC14_323_5 2=0 8=.
alpha CC14_323*, item casewise gen(Abort)

*enviro
gen enviro1 = CC14_326_1
recode enviro1 1=0 2=1 8/9=.
gen enviro2 = CC14_326_2
recode enviro2 1=0 2=1 8/9=.
gen enviro3 = CC14_326_3
recode enviro3 1=0 2=1 8/9=.
gen enviro4 = CC14_326_4
recode enviro4 1=0 2=1 8/9=.
alpha enviro*, item casewise gen(Enviro)

*single items
gen gaymarr = CC14_327
recode gaymarr 2=1 1=0 8/9=.
gen affact = CC14_328
recode affact 8/9=.

*latent measure of ideology
gen Guns5=Guns*5
gen Abort5=Abort*5
gen Enviro4=Enviro*4
gen Imm6=Imm*6
irt grm Guns5 Imm6 Abort5 Enviro4 gaymarr affact
predict IssuesIRT
egen IIRTmin=min(IssuesIRT)
egen IIRTmax=max(IssuesIRT)
gen IssuesIRT01=(IssuesIRT-IIRTmax)*-(1/(IIRTmax-IIRTmin))
drop IIRTmin IIRTmax

** Trait importance
recode DKU323 8/9=.
recode DKU324 8/9=.
recode DKU325 8/9=.
recode DKU326 8/9=.
recode DKU327 8/9=.
recode DKU328 8/9=.
gen Scomp = DKU323
gen Sfair = DKU324
gen Sresp = DKU325
gen Sloya = DKU326
gen Swhol = DKU327
gen Sinte = DKU328
gen Sown = ((Scomp + Sfair)/2 - (Sresp + Sloya + Swhol)/3)/2
gen Sind = (Scomp + Sfair)/2
gen Sbind = (Sresp + Sloya + Swhol)/3

*Mean-deviated
gen Savg = (Scomp + Sfair + Sresp + Sloya + Swhol + Sinte)/6
gen Scompdiff = Scomp - Savg
gen Sfairdiff = Sfair - Savg
gen Sloyadiff = Sloya - Savg
gen Srespdiff = Sresp - Savg
gen Swholdiff = Swhol - Savg
gen Sintediff = Sinte - Savg

*ownership
gen SImpOwn = ((Scomp + Sfair)/2) - ((Sresp + Sloya + Swhol)/3)


** Party Trait Ratings
recode DKU425 8=.
recode DKU426 8=.
recode DKU427 8=.
recode DKU428 8=.
recode DKU429 8=.
recode DKU430 8=.
recode DKU431 8=.
recode DKU432 8=.
recode DKU433 8=.
recode DKU434 8=.
recode DKU435 8=.
recode DKU436 8=.
rename DKU425 Rcomp
rename DKU426 Rfair
rename DKU427 Rresp
rename DKU428 Rloya
rename DKU429 Rwhol
rename DKU430 Rinte
rename DKU431 Dcomp
rename DKU432 Dfair
rename DKU433 Dresp
rename DKU434 Dloya
rename DKU435 Dwhol
rename DKU436 Dinte

*party trait differences
gen compdiff = Rcomp - Dcomp
gen fairdiff = Rfair - Dfair
gen respdiff = Rresp - Dresp
gen loyadiff = Rloya - Dloya
gen wholdiff = Rwhol - Dwhol
gen intediff = Rinte - Dinte
gen TraitOwn = (((Dcomp - Rcomp) + (Dfair - Rfair))/2 + ((Rresp - Dresp) + (Rloya - Dloya) + (Rwhol - Dwhol))/3)/2

*mean-deviated differences
gen avgdiff = (compdiff+fairdiff+respdiff+loyadiff+wholdiff+intediff)/6
gen compdev = compdiff-avgdiff
gen fairdev = fairdiff-avgdiff
gen respdev = respdiff-avgdiff
gen loyadev = loyadiff-avgdiff
gen wholdev = wholdiff-avgdiff
gen intedev = intediff-avgdiff


************
* Analysis *
************

** trait importance

*partisanship only
gen pest=.
gen plo=.
gen phi=.
gen x=_n+1
replace x=1 in 7
replace x=. if _n>7

reg Scompdiff PID01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store ip1
replace pest=_b[PID01] in 1
replace plo=_b[PID01] - 1.96*_se[PID01] in 1
replace phi=_b[PID01] + 1.96*_se[PID01] in 1

reg Sfairdiff PID01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store ip2
replace pest=_b[PID01] in 2
replace plo=_b[PID01] - 1.96*_se[PID01] in 2
replace phi=_b[PID01] + 1.96*_se[PID01] in 2

reg Srespdiff PID01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store ip3
replace pest=_b[PID01] in 3
replace plo=_b[PID01] - 1.96*_se[PID01] in 3
replace phi=_b[PID01] + 1.96*_se[PID01] in 3

reg Sloyadiff PID01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store ip4
replace pest=_b[PID01] in 4
replace plo=_b[PID01] - 1.96*_se[PID01] in 4
replace phi=_b[PID01] + 1.96*_se[PID01] in 4

reg Swholdiff PID01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store ip5
replace pest=_b[PID01] in 5
replace plo=_b[PID01] - 1.96*_se[PID01] in 5
replace phi=_b[PID01] + 1.96*_se[PID01] in 5

reg Sintediff PID01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store ip6
replace pest=_b[PID01] in 6
replace plo=_b[PID01] - 1.96*_se[PID01] in 6
replace phi=_b[PID01] + 1.96*_se[PID01] in 6

reg SImpOwn PID01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store ip7
replace pest=_b[PID01] in 7
replace plo=_b[PID01] - 1.96*_se[PID01] in 7
replace phi=_b[PID01] + 1.96*_se[PID01] in 7

estout ip*, cells(b(star fmt(2)) se) stats(N r2)

twoway (scatter pest x if x==1, mcol(black) msymbol(square)) (scatter pest x if x!=1, mcol(black)) (rcap phi plo x, legend(off) ysc(range(-1.5 1.25)) ///
	lcol(black) graphregion(color(white)) yline(0, lcol(gss10)) xsc(range(.5 7.5)) ///
	xtitle("") ylab(-1.5(.5)1) xlab(2 "Compassionate" 3 "Fair-minded" 4 "Respectful" ///
	5 "Loyal" 6 "Wholesome" 7 "Intelligent" 1 "Trait Index", labsize(small) angle(vertical)) ///
	subtitle("PID w/o Ideology") ytitle("Partisanship Coefficient") saving(PIDfx_issuesirt.gph, replace)) 


*partisanship and ideology	
gen piest=.
gen pilo=.
gen pihi=.
gen iest=.
gen ilo=.
gen ihi=.

reg Scompdiff PID01 IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store f1
test PID01=IssuesIRT01
replace piest=_b[PID01] in 1
replace pilo=_b[PID01] - 1.96*_se[PID01] in 1
replace pihi=_b[PID01] + 1.96*_se[PID01] in 1
replace iest=_b[IssuesIRT01] in 1
replace ilo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 1
replace ihi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 1

reg Sfairdiff PID01 IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store f2
test PID01=IssuesIRT01
replace piest=_b[PID01] in 2
replace pilo=_b[PID01] - 1.96*_se[PID01] in 2
replace pihi=_b[PID01] + 1.96*_se[PID01] in 2
replace iest=_b[IssuesIRT01] in 2
replace ilo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 2
replace ihi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 2

reg Srespdiff PID01 IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store f3
test PID01=IssuesIRT01
replace piest=_b[PID01] in 3
replace pilo=_b[PID01] - 1.96*_se[PID01] in 3
replace pihi=_b[PID01] + 1.96*_se[PID01] in 3
replace iest=_b[IssuesIRT01] in 3
replace ilo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 3
replace ihi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 3

reg Sloyadiff PID01 IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store f4
test PID01=IssuesIRT01
replace piest=_b[PID01] in 4
replace pilo=_b[PID01] - 1.96*_se[PID01] in 4
replace pihi=_b[PID01] + 1.96*_se[PID01] in 4
replace iest=_b[IssuesIRT01] in 4
replace ilo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 4
replace ihi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 4

reg Swholdiff PID01 IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store f5
test PID01=IssuesIRT01
replace piest=_b[PID01] in 5
replace pilo=_b[PID01] - 1.96*_se[PID01] in 5
replace pihi=_b[PID01] + 1.96*_se[PID01] in 5
replace iest=_b[IssuesIRT01] in 5
replace ilo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 5
replace ihi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 5

reg Sintediff PID01 IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store f6
test PID01=IssuesIRT01
replace piest=_b[PID01] in 6
replace pilo=_b[PID01] - 1.96*_se[PID01] in 6
replace pihi=_b[PID01] + 1.96*_se[PID01] in 6
replace iest=_b[IssuesIRT01] in 6
replace ilo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 6
replace ihi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 6

reg SImpOwn PID01 IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store f7
test PID01=IssuesIRT01
replace piest=_b[PID01] in 7
replace pilo=_b[PID01] - 1.96*_se[PID01] in 7
replace pihi=_b[PID01] + 1.96*_se[PID01] in 7
replace iest=_b[IssuesIRT01] in 7
replace ilo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 7
replace ihi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 7

estout f*, cells(b(star fmt(2)) se) stats(N r2)

twoway (scatter piest x if x==1, mcol(black) msymbol(square)) (scatter piest x if x!=1, mcol(black)) ///
	(rcap pihi pilo x, legend(off) ysc(range(-1.5 1.25)) ///
	lcol(black) graphregion(color(white)) yline(0, lcol(black)) xsc(range(.5 7.5)) ///
	ysc(range(-1.5 1.25)) ylab(-1.5(.5)1) ///
	xtitle("") xlab(2 "Compassionate" 3 "Fair-minded" 4 "Respectful" ///
	5 "Loyal" 6 "Wholesome" 7 "Intelligent" 1 "Trait Index", labsize(small) angle(vertical)) ///
	subtitle("PID w/Ideology") ytitle("Partisanship Coefficient") saving(PIDideofx_issuesirt.gph, replace))
	
twoway (scatter iest x if x==1, msymbol(square) mcol(black)) (scatter iest x if x!=1, mcol(black) msymbol(circle_hollow)) ///
	(rcap ihi ilo x, legend(off) ysc(range(-1.5 1.25)) ///
	lcol(black) graphregion(color(white)) yline(0, lcol(black)) xsc(range(.5 7.5)) ///
	ysc(range(-1.5 1.25)) ylab(-1.5(.5)1) ///
	xtitle("") xlab(2 "Compassionate" 3 "Fair-minded" 4 "Respectful" ///
	5 "Loyal" 6 "Wholesome" 7 "Intelligent" 1 "Trait Index", labsize(small) angle(vertical)) ///
	subtitle("Ideology w/PID") ytitle("Ideology Coefficient") saving(Ideofx_issuesirt.gph, replace))

	
*ideology only
gen ioest=.
gen iolo=.
gen iohi=.

reg Scompdiff IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store io1
replace ioest=_b[IssuesIRT01] in 1
replace iolo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 1
replace iohi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 1

reg Sfairdiff IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store io2
replace ioest=_b[IssuesIRT01] in 2
replace iolo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 2
replace iohi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 2

reg Srespdiff IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store io3
replace ioest=_b[IssuesIRT01] in 3
replace iolo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 3
replace iohi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 3

reg Sloyadiff IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store io4
replace ioest=_b[IssuesIRT01] in 4
replace iolo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 4
replace iohi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 4

reg Swholdiff IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store io5
replace ioest=_b[IssuesIRT01] in 5
replace iolo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 5
replace iohi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 5

reg Sintediff IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store io6
replace ioest=_b[IssuesIRT01] in 6
replace iolo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 6
replace iohi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 6

reg SImpOwn IssuesIRT01 Educ01 Male Age01 Black Hisp Attend01 if PID!=. & IssuesIRT!=.
est store io7
replace ioest=_b[IssuesIRT01] in 7
replace iolo=_b[IssuesIRT01] - 1.96*_se[IssuesIRT01] in 7
replace iohi=_b[IssuesIRT01] + 1.96*_se[IssuesIRT01] in 7

estout io*, cells(b(star fmt(2)) se) stats(N r2)

twoway (scatter ioest x if x==1, msymbol(square) mcol(black)) (scatter ioest x if x!=1, mcol(black) msymbol(circle_hollow)) (rcap iohi iolo x, legend(off) ysc(range(-1.5 1.25)) ///
	lcol(black) graphregion(color(white)) yline(0, lcol(gss10)) xsc(range(.5 7.5)) ///
	xtitle("") ylab(-1.5(.5)1) xlab(2 "Compassionate" 3 "Fair-minded" 4 "Respectful" ///
	5 "Loyal" 6 "Wholesome" 7 "Intelligent" 1 "Trait Index", labsize(small) angle(vertical)) ///
	subtitle("Ideology w/o PID") ytitle("Ideology Coefficient") saving(iofx_issuesirt.gph, replace))

graph combine PIDfx_issuesirt.gph PIDideofx_issuesirt.gph iofx_issuesirt.gph Ideofx_issuesirt.gph, graphregion(color(white)) rows(1) ///
	subtitle("Figure 1. Effects of Partisanship and Ideology on Trait Importance") ///
	note("Note: Partisanship (ideology) is coded such that higher values indicate strong Republican (very conservative). Higher values on the DV indicate greater" "relative importance of that trait. Higher values on the trait index indicate more importance on individualizing than binding traits.", size(vsmall))

	
** moderating effects of political sophistication on trait importance

reg SImpOwn c.PID01##c.LatentAttent01 c.IssuesIRT01##c.LatentAttent01 Educ01 Male Age01 Black Hisp Attend01
margins, dydx(IssuesIRT01) at(LatentAttent01=(0(.05)1))
marginsplot, xlab(0(.25)1) recastci(rarea) ci1opts(fcolor(gs10%30)) recast(line) ///
	yline(0) ylab(-2(.5)1) xtitle("Political Sophistication", size(small)) xsc(titlegap(2)) ytitle("Political Ideology Coefficient") ///
		title("Political Ideology") saving(issuesbyknow.gph, replace)
margins, dydx(PID01) at(LatentAttent01=(0(.05)1))
marginsplot, xlab(0(.25)1) recastci(rarea) ci1opts(fcolor(gs10%30)) recast(line) ///
	yline(0) ylab(-2(.5)1) xtitle("Political Sophistication", size(small)) xsc(titlegap(2)) ytitle("Partisan Identification Coefficient") ///
	title("Partisan Identification") saving(pidbyknow.gph, replace)
graph combine pidbyknow.gph issuesbyknow.gph, subtitle("Figure 2. The Moderating Role of Political Sophistication in Trait Importance") ///
	note("Note: the dependent variable is the trait importance index, where higher values indicate more importance on compassion and fairness. Ideology and PID" "range from 0 to 1 and are coded such that higher values are more conservative/Republican.", size(vsmall))

	
	
	
	
*****************
** Stereotypes **
*****************

sum avgdiff if RD==0
sum avgdiff if RD==1

ttest TraitOwn==0
ttest compdev==0
ttest fairdev==0
ttest respdev==0
ttest loyadev==0
ttest wholdev==0
ttest intedev==0

*figure 3
drop x ilo ihi
gen x=_n
replace x=. if _n>6
gen mean=.
gen lo=.
gen hi=.
gen hkm=.
gen hklo=.
gen hkhi=.
gen lkm=.
gen lklo=.
gen lkhi=.

replace mean=-.538 in 6 /* comp */
replace mean=-.158 in 5 /* fair */
replace mean=.106 in 4 /* resp */
replace mean=.327 in 3 /* loya */
replace mean=.181 in 2 /* whol */
replace mean=.083 in 1 /* inte */

replace lo=-.599 in 6
replace lo=-.215 in 5
replace lo=.054 in 4
replace lo=.235 in 3
replace lo=.126 in 2
replace lo=.030 in 1

replace hi=-.477 in 6
replace hi=-.101 in 5
replace hi=.158 in 4
replace hi=.418 in 3
replace hi=.235 in 2
replace hi=.136 in 1

graph twoway (bar mean x if x>4, horiz col(blue)) ///
	(bar mean x if x<5 & x>1, horiz col(red)) ///
	(bar mean x if x==1, horiz col(purple)) ///
	(rcap hi lo x, horiz col(black) legend(off) xline(0, lcol(black)) ///
	graphregion(color(white)) ytitle("") ylab(6 "Compassionate" ///
	5 "Fair-minded" 4 "Respectful" 3 "Loyal" 2 "Wholesome" 1 ///
	"Intelligent", nogrid notick angle(0)) xlab(-.6(.3).6) ///
	subtitle("Figure 3. Trait Stereotypes of Mass Partisans") ///
	xtitle("Democratic Advantage                   Republican Advantage", size(small)) ///
	note("Note: Each bar shows the Republican trait rating minus the Democratic rating with 95% confidence intervals.", size(vsmall)) ///
	saving(cces_stereo_full.gph, replace))


** figure 4

*by partisanship
gen dlo=.
gen dhi=.
gen deff=.

gen ilo=.
gen ihi=.
gen ieff=.

gen rlo=.
gen rhi=.
gen reff=.

*democrats
sum compdev if PID<4
replace deff=r(mean) in 6
replace dlo = r(mean) - 1.96*(r(sd)/sqrt(r(N))) in 6
replace dhi = r(mean) + 1.96*(r(sd)/sqrt(r(N))) in 6
sum fairdev if PID<4
replace deff=r(mean) in 5
replace dlo = r(mean) - 1.96*(r(sd)/sqrt(r(N))) in 5
replace dhi = r(mean) + 1.96*(r(sd)/sqrt(r(N))) in 5
sum respdev if PID<4
replace deff=r(mean) in 4
replace dlo = r(mean) - 1.96*(r(sd)/sqrt(r(N))) in 4
replace dhi = r(mean) + 1.96*(r(sd)/sqrt(r(N))) in 4
sum loyadev if PID<4
replace deff=r(mean) in 3
replace dlo = r(mean) - 1.96*(r(sd)/sqrt(r(N))) in 3
replace dhi = r(mean) + 1.96*(r(sd)/sqrt(r(N))) in 3
sum wholdev if PID<4
replace deff=r(mean) in 2
replace dlo = r(mean) - 1.96*(r(sd)/sqrt(r(N))) in 2
replace dhi = r(mean) + 1.96*(r(sd)/sqrt(r(N))) in 2
sum intedev if PID<4
replace deff=r(mean) in 1
replace dlo = r(mean) - 1.96*(r(sd)/sqrt(r(N))) in 1
replace dhi = r(mean) + 1.96*(r(sd)/sqrt(r(N))) in 1

graph twoway (bar deff x if x>4, horiz col(blue)) ///
	(bar deff x if x<5 & x>1, horiz col(red)) ///
	(bar deff x if x==1, horiz col(purple)) ///
	(rcap dhi dlo x, horiz col(black) legend(off) xline(0, lcol(black)) ///
	graphregion(color(white)) ytitle("") ylab(6 "Compassionate" ///
	5 "Fair-minded" 4 "Respectful" 3 "Loyal" 2 "Wholesome" 1 ///
	"Intelligent", nogrid notick angle(0)) xlab(-1(.5)1) ///
	subtitle("Democrats") ///
	xlab(-1(.5)1) ///
	saving(cces_stereo_dems.gph, replace))

*republicans
sum compdev if PID>4
replace reff=r(mean) in 6
replace rlo = r(mean) - 1.96*(r(sd)/sqrt(r(N))) in 6
replace rhi = r(mean) + 1.96*(r(sd)/sqrt(r(N))) in 6
sum fairdev if PID>4
replace reff=r(mean) in 5
replace rlo = r(mean) - 1.96*(r(sd)/sqrt(r(N))) in 5
replace rhi = r(mean) + 1.96*(r(sd)/sqrt(r(N))) in 5
sum respdev if PID>4
replace reff=r(mean) in 4
replace rlo = r(mean) - 1.96*(r(sd)/sqrt(r(N))) in 4
replace rhi = r(mean) + 1.96*(r(sd)/sqrt(r(N))) in 4
sum loyadev if PID>4
replace reff=r(mean) in 3
replace rlo = r(mean) - 1.96*(r(sd)/sqrt(r(N))) in 3
replace rhi = r(mean) + 1.96*(r(sd)/sqrt(r(N))) in 3
sum wholdev if PID>4
replace reff=r(mean) in 2
replace rlo = r(mean) - 1.96*(r(sd)/sqrt(r(N))) in 2
replace rhi = r(mean) + 1.96*(r(sd)/sqrt(r(N))) in 2
sum intedev if PID>4
replace reff=r(mean) in 1
replace rlo = r(mean) - 1.96*(r(sd)/sqrt(r(N))) in 1
replace rhi = r(mean) + 1.96*(r(sd)/sqrt(r(N))) in 1

graph twoway (bar reff x if x>4, horiz col(blue)) ///
	(bar reff x if x<5 & x>1, horiz col(red)) ///
	(bar reff x if x==1, horiz col(purple)) ///
	(rcap rhi rlo x, horiz col(black) legend(off) xline(0, lcol(black)) ///
	graphregion(color(white)) ytitle("") ylab(6 "Compassionate" ///
	5 "Fair-minded" 4 "Respectful" 3 "Loyal" 2 "Wholesome" 1 ///
	"Intelligent", nogrid notick angle(0)) xlab(-1(.5)1) ///
	subtitle("Republicans") ///
	xlab(-1(.5)1) ///
	saving(cces_stereo_reps.gph, replace))
	
*high knowledge
mean compdev-intedev if LatentAttent3==3

replace hkm=-.774 in 6
replace hkm=-.165 in 5
replace hkm=.219 in 4
replace hkm=.546 in 3
replace hkm=.215 in 2
replace hkm=-.041 in 1

replace hklo=-.882 in 6
replace hklo=-.287 in 5
replace hklo=.111 in 4
replace hklo=.326 in 3
replace hklo=.114 in 2
replace hklo=-.144 in 1

replace hkhi=-.666 in 6
replace hkhi=-.043 in 5
replace hkhi=.326 in 4
replace hkhi=.760 in 3
replace hkhi=.316 in 2
replace hkhi=.062 in 1

graph twoway (bar hkm x if x>4, horiz col(blue)) ///
	(bar hkm x if x<5 & x>1, horiz col(red)) ///
	(bar hkm x if x==1, horiz col(purple)) ///
	(rcap hkhi hklo x, horiz col(black) legend(off) xline(0, lcol(black)) ///
	graphregion(color(white)) ytitle("") ylab(6 "Compassionate" ///
	5 "Fair-minded" 4 "Respectful" 3 "Loyal" 2 "Wholesome" 1 ///
	"Intelligent", nogrid notick angle(0)) xlab(-1(.5)1) ///
	subtitle("High Sophistication") saving(cces_stereo_hk.gph, replace))

*low knowledge
mean compdev-intedev if LatentAttent3==1

replace lkm=-.301 in 6
replace lkm=-.125 in 5
replace lkm=.015 in 4
replace lkm=.131 in 3
replace lkm=.139 in 2
replace lkm=.139 in 1

replace lklo=-.399 in 6
replace lklo=-.2 in 5
replace lklo=-.056 in 4
replace lklo=.044 in 3
replace lklo=.062 in 2
replace lklo=.072 in 1

replace lkhi=-.202 in 6
replace lkhi=-.050 in 5
replace lkhi=.086 in 4
replace lkhi=.219 in 3
replace lkhi=.217 in 2
replace lkhi=.207 in 1

graph twoway (bar lkm x if x>4, horiz col(blue)) ///
	(bar lkm x if x<5 & x>1, horiz col(red)) ///
	(bar lkm x if x==1, horiz col(purple)) ///
	(rcap lkhi lklo x, horiz col(black) legend(off) xline(0, lcol(black)) ///
	graphregion(color(white)) ytitle("") ylab(6 "Compassionate" ///
	5 "Fair-minded" 4 "Respectful" 3 "Loyal" 2 "Wholesome" 1 ///
	"Intelligent", nogrid notick angle(0)) xlab(-1(.5)1) ///
	subtitle("Low Sophistication") saving(cces_stereo_lk.gph, replace))

*Figure 4
graph combine cces_stereo_dems.gph cces_stereo_reps.gph cces_stereo_lk.gph cces_stereo_hk.gph, ///
	xcommon graphregion(color(white)) iscale(.6) subtitle("Figure 4. Stereotypes by Respondent Partisanship and Sophistication") ///
	note("Note: Each bar shows the Republican trait rating minus the Democratic rating with 95% confidence intervals. Low and high sophistication refer to the bottom" "and top tercile, respectively.", size(vsmall)) 

corr LatentAttent01 TraitOwn if RD==1
corr LatentAttent01 TraitOwn if RD==0
