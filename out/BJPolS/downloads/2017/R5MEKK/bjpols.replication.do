

use "imm.bjpols.dta"


***********************************************
*FIRST MODEL: BASIC RESULTS: ALL TREATMENTS, NO INTERACTIONS

*ALL COUNTRIES COMBINED
set more off
mixed support i.treat_hstat i.treat_drk i.treat_nat_me i.treat_kids i.cand if country~=12 & country~=6 & treat_gender==0 || id: [weight=wt_country] 
estimates store Aa
margins i.treat_hstat 
marginsplot, title("All Countries", size(large) position(11) ring(0) margin(2 2 2 2)) scheme(s1mono) ytitle("Level of Support") xtitle("") ///
	xscale(range(-.3 1.3)) xlab(0 "Low Status" 1 "High Status") ///
	yscale(range(.3 .7)) ylab(.3 .4 .5 .6 .7, angle(0)) yline(0, lstyle(dot)) ///
	plotopts( msymbol(S) mcolor(black)) ciopts(lpattern(dash)) plotregion(lstyle(none)) nodraw
graph save Aa1, replace
margins i.treat_drk 
marginsplot, title("All Countries", size(large) position(11) ring(0) margin(2 2 2 2)) scheme(s1mono) ytitle("Level of Support") xtitle("") ///
	xscale(range(-.3 1.3)) xlab(0 "Light" 1 "Dark") ///
	yscale(range(.3 .7)) ylab(.3 .4 .5 .6 .7, angle(0)) yline(0, lstyle(dot)) ///
	plotopts( msymbol(S) mcolor(black)) ciopts(lpattern(dash)) plotregion(lstyle(none)) nodraw
graph save Aa2, replace
margins i.treat_nat_me 
marginsplot, title("All Countries", size(large) position(11) ring(0) margin(2 2 2 2)) scheme(s1mono) ytitle("Level of Support") xtitle("") ///
	xscale(range(-.3 1.3)) xlab(0 "Not ME" 1 "ME") ///
	yscale(range(.3 .7)) ylab(.3 .4 .5 .6 .7, angle(0)) yline(0, lstyle(dot)) ///
	plotopts( msymbol(S) mcolor(black)) ciopts(lpattern(dash)) plotregion(lstyle(none)) nodraw
graph save Aa3, replace

*BY COUNTRY
xtset uid
set more off
foreach C in "AU" "CA" "CH" "DK" "ES" "FR" "JP" "KR" "NO" "UK" "US" {
	xtreg support i.treat_hstat i.treat_drk i.treat_nat_me i.treat_kids i.cand  if countryt=="`C'" & treat_gender==0, mle
	estimates store A_`C'
	margins i.treat_hstat 
	marginsplot, title("`C'", size(large) position(11) ring(0) margin(2 2 2 2)) scheme(s1mono) ytitle("Level of Support") xtitle("") ///
		xscale(range(-.3 1.3)) xlab(0 "Low Status" 1 "High Status") ///
		yscale(range(.3 .7)) ylab(.3 .4 .5 .6 .7, angle(0)) yline(0, lstyle(dot)) ///
		plotopts( msymbol(S) mcolor(black)) ciopts(lpattern(dash)) plotregion(lstyle(none)) nodraw 
	graph save Aa1_`C', replace
	margins i.treat_drk 
	marginsplot, title("`C'", size(large) position(11) ring(0) margin(2 2 2 2)) scheme(s1mono) ytitle("Level of Support") xtitle("") ///
		xscale(range(-.3 1.3)) xlab(0 "Light" 1 "Dark") ///
		yscale(range(.3 .7)) ylab(.3 .4 .5 .6 .7, angle(0)) yline(0, lstyle(dot)) ///
		plotopts( msymbol(S) mcolor(black)) ciopts(lpattern(dash)) plotregion(lstyle(none)) nodraw
	graph save Aa2_`C', replace
	margins i.treat_nat_me 
	marginsplot, title("`C'", size(large) position(11) ring(0) margin(2 2 2 2)) scheme(s1mono) ytitle("Level of Support") xtitle("") ///
		xscale(range(-.3 1.3)) xlab(0 "Not ME" 1 "ME") ///
		yscale(range(.3 .7)) ylab(.3 .4 .5 .6 .7, angle(0)) yline(0, lstyle(dot)) ///
		plotopts( msymbol(S) mcolor(black)) ciopts(lpattern(dash)) plotregion(lstyle(none)) nodraw
	graph save Aa3_`C', replace
	}
	
*GRAPHICS
graph combine Aa1.gph Aa1_AU.gph Aa1_CA.gph Aa1_CH.gph Aa1_DK.gph Aa1_ES.gph ///
	Aa1_FR.gph Aa1_JP.gph Aa1_KR.gph Aa1_NO.gph Aa1_UK.gph Aa1_US.gph, ///
	col(3) scheme(s1mono) ysize(10) xsize(7) 
graph save "figure3.gph",  replace
graph export "figure3.png", width(1000) replace
graph combine Aa2.gph Aa2_AU.gph Aa2_CA.gph Aa2_CH.gph Aa2_DK.gph Aa2_ES.gph ///
	Aa2_FR.gph Aa2_JP.gph Aa2_KR.gph Aa2_NO.gph Aa2_UK.gph Aa2_US.gph, ///
	col(3) scheme(s1mono) ysize(10) xsize(7) 
graph save "figure4.gph", replace
graph export "figure4.png", width(1000) replace
graph combine Aa3.gph Aa3_AU.gph Aa3_CA.gph Aa3_CH.gph Aa3_DK.gph Aa3_ES.gph ///
	Aa3_FR.gph Aa3_JP.gph Aa3_KR.gph Aa3_NO.gph Aa3_UK.gph Aa3_US.gph, ///
	col(3) scheme(s1mono) ysize(10) xsize(7) 
graph save "figure5.gph", replace
graph export "figure5.png", width(1000) replace

*SAVING RESULTS
estout A* using "results_table4.txt", nolz notype delimiter(" `=char(9)'") ///
	cells(b(star fmt(3)) se(par(( )) fmt(3))) starlevels(* .05 ** .01 *** .001) ///
    stats(N N_g, fmt(0)) replace

	
***********************************************
*SECOND MODEL: ADDING INTERACTIONS

*ALL COUNTRIES COMBINED
set more off
mixed support i.treat_hstat##i.treat_drk i.treat_nat_me i.treat_hstat##i.treat_kids i.cand if country~=12 & country~=6 & treat_gender==0 || id: [weight=wt_country] 
estimates store Bb
margins i.treat_hstat#treat_kids
marginsplot, title("All Countries", size(large) position(11) ring(0) margin(2 2 2 2)) scheme(s1mono) ytitle("Level of Support") xtitle("") ///
	xscale(range(-.3 1.3)) xlab(0 "Low Status" 1 "High Status") ///
	yscale(range(.3 .7)) ylab(.3 .4 .5 .6 .7, angle(0)) yline(0, lstyle(dot)) ///
	plotopts( msymbol(S) mcolor(black)) ciopts(lpattern(dash)) ///
	text(.55 -.35 "No Children", size(small) placement(e)) text(.458 -.35 "Children", size(small)  placement(e)) ///
	legend(off) ysize(3.66) xsize(3.7) plotregion(lstyle(none))
graph save Bb1, replace

*BY COUNTRY
set more off
foreach C in "AU" "CA" "CH" "DK" "ES" "FR" "JP" "KR" "NO" "UK" "US" {
	xtreg support i.treat_hstat##i.treat_drk i.treat_nat_me i.treat_hstat##i.treat_kids i.cand  if countryt=="`C'" & treat_gender==0, mle
	estimates store B_`C'
	margins i.treat_hstat#treat_kids 
	marginsplot, title("`C'", size(large) position(11) ring(0) margin(2 2 2 2)) scheme(s1mono) ytitle("Level of Support") xtitle("") ///
		xscale(range(-.3 1.3)) xlab(0 "Low Status" 1 "High Status") ///
		yscale(range(.3 .7)) ylab(.3 .4 .5 .6 .7, angle(0)) yline(0, lstyle(dot)) ///
		plotopts( msymbol(S) mcolor(black)) ciopts(lpattern(dash)) ///
		legend(off) ysize(3.66) xsize(3.7) plotregion(lstyle(none)) nodraw
	graph save Bb1_`C', replace
	}

*GRAPHICS
graph combine Bb1.gph Bb1_AU.gph Bb1_CA.gph Bb1_CH.gph Bb1_DK.gph Bb1_ES.gph ///
Bb1_FR.gph Bb1_JP.gph Bb1_KR.gph Bb1_NO.gph Bb1_UK.gph Bb1_US.gph, ///
col(3) scheme(s1mono) ysize(10) xsize(7) 
graph save "figure6.gph",  replace
graph export "figure6.png", width(1000) replace

*SAVING RESULTS
estout B* using "results_tableA2.txt", nolz notype delimiter(" `=char(9)'") ///
	cells(b(star fmt(3)) se(par(( )) fmt(3))) starlevels(* .05 ** .01 *** .001) ///
    stats(N N_g, fmt(0)) replace

	
***********************************************
*THIRD MODEL: ADDING SES

*ALL COUNTRIES COMBINED
*JOB STATUS BY EDUCATION
set more off
mixed support i.treat_hstat##i.treat_drk i.treat_hstat##i.treat_kids##i.education2 i.treat_nat_me i.cand if country~=12 & country~=6 & treat_gender==0 || id: [weight=wt_country] 
estimates store Cc
*extra graphic for combined figure (below)
margins treat_hstat#education2
marginsplot, title("All Countries", size(large) position(11) ring(0) margin(2 2 2 2)) scheme(s1mono) ytitle("Level of Support") xtitle("") ///
	xscale(range(-.3 1.3)) xlab(0 "Low Status" 1 "High Status") ///
	yscale(range(.3 .7)) ylab(.3 .4 .5 .6 .7, angle(0)) yline(0, lstyle(dot)) ///
	plotopts( msymbol(S) mcolor(black)) ciopts(lpattern(dash))  ///
	text(.47 -.2 "Low Education Rs", placement(e) orientation(30) size(small)) text(.6 -.3 ///
	"High Education Rs", placement(e) size(small)) legend(off) plotregion(lstyle(none))
graph save figureCc1, replace
*JOB STATUS BY OCCUPATION (WITH GRAPHIC)
set more off
mixed support i.treat_hstat##i.treat_drk i.treat_hstat##i.treat_kids##i.occupation2 i.treat_nat_me i.cand if country~=12 & country~=6 & treat_gender==0 || id: [weight=wt_country] 
estimates store Dd
*JOB STATUS BY INCOME (WITH GRAPHIC)
set more off
mixed support i.treat_hstat##i.treat_drk i.treat_hstat##i.treat_kids##i.inc2 i.treat_nat_me i.cand if country~=12 & country~=6 & treat_gender==0 || id: [weight=wt_country] 
estimates store Ee

*BY COUNTRY
xtset uid
*JOB STATUS BY EDUCATION (WITH COMBINED GRAPHIC)
set more off
foreach C in "AU" "CA" "CH" "DK" "ES" "FR" "JP" "KR" "NO" "UK" "US" {
	xtreg support i.treat_hstat##i.treat_drk i.treat_hstat##i.treat_kids##i.education2 i.treat_nat_me i.cand if countryt=="`C'" & treat_gender==0, mle
	estimates store C_`C'
	margins treat_hstat#education2 
	marginsplot, title("`C'", size(large) position(11) ring(0) margin(2 2 2 2)) scheme(s1mono) ytitle("Level of Support") xtitle("") ///
		xscale(range(-.3 1.3)) xlab(0 "Low Status" 1 "High Status") ///
		yscale(range(.3 .7)) ylab(.3 .4 .5 .6 .7, angle(0)) yline(0, lstyle(dot)) ///
		plotopts( msymbol(S) mcolor(black)) ciopts(lpattern(dash))  ///
		legend(off) plotregion(lstyle(none)) nodraw
	graph save Cc1_`C', replace
	}
graph combine figureCc1.gph Cc1_AU.gph Cc1_CA.gph Cc1_CH.gph Cc1_DK.gph Cc1_ES.gph ///
	Cc1_FR.gph Cc1_JP.gph Cc1_KR.gph Cc1_NO.gph Cc1_UK.gph Cc1_US.gph, ///
	col(3) scheme(s1mono) ysize(10) xsize(7) 
graph save "figure7.gph",  replace
graph export "figure7.png", width(1000) replace	
*JOB STATUS BY OCCUPATION
set more off
foreach C in "AU" "CA" "DK" "FR" "JP" "KR" "UK" "US" {
	xtreg support i.treat_hstat##i.treat_drk i.treat_hstat##i.treat_kids##i.occupation2 i.treat_nat_me i.cand  if countryt=="`C'" & treat_gender==0, mle
	estimates store D_`C'
	}	
*JOB STATUS BY INCOME
set more off
foreach C in "AU" "CA" "DK" "FR" "JP" "KR" "ES" "CH" "UK" "US" {
	xtreg support i.treat_hstat##i.treat_drk i.treat_hstat##i.treat_kids##i.inc2 i.treat_nat_me i.cand  if countryt=="`C'" & treat_gender==0, mle
	estimates store E_`C'
	}

*SAVING RESULTS
estout C* using "results_tableA3.txt", nolz notype delimiter(" `=char(9)'") ///
	cells(b(star fmt(3)) se(par(( )) fmt(3))) starlevels(* .05 ** .01 *** .001) ///
    stats(N N_g, fmt(0)) replace
estout Dd D_* using "results_tableA4.txt", nolz notype delimiter(" `=char(9)'") ///
	cells(b(star fmt(3)) se(par(( )) fmt(3))) starlevels(* .05 ** .01 *** .001) ///
    stats(N N_g, fmt(0)) replace
estout Ee E_* using "results_tableA5.txt", nolz notype delimiter(" `=char(9)'") ///
	cells(b(star fmt(3)) se(par(( )) fmt(3))) starlevels(* .05 ** .01 *** .001) ///
    stats(N N_g, fmt(0)) replace
	

***********************************************
*The Impact of Economic Concerns on Openness to Immigration

reg openness c.inctaxes##i.occupation2 c.takejobs##i.occupation2 i.country if country~=12 & country~=6 & cand==1 [weight=wt_country]
estimates store J2
reg openness c.inctaxes##i.inc2 c.takejobs##i.inc2 i.country if country~=12 & country~=6 & cand==1 [weight=wt_country]
estimates store J3
estout J* using "results_tableA6.txt", nolz notype delimiter(" `=char(9)'") ///
	cells(b(star fmt(3)) se(par(( )) fmt(3))) starlevels(* .05 ** .01 *** .001) ///
    stats(N N_g, fmt(0)) replace
	
	
***********************************************
*FOURTH MODEL: ADDING RACIAL ANIMUS

*BY COUNTRY
set more off
foreach C in "CA" "FR" "ES" "UK" "US" {
	xtreg support i.treat_hstat##i.treat_drk i.treat_nat_me i.treat_hstat##i.treat_kids i.cand animus gender age i.education2 i.inc3 if countryt=="`C'" & treat_gender==0, mle
	estimates store G_`C'	
	xtreg support i.treat_hstat##i.treat_drk i.treat_nat_me i.treat_hstat##i.treat_kids i.cand i.treat_hstat##c.animus gender age i.education2 i.inc3 if countryt=="`C'" & treat_gender==0, mle
	estimates store H_`C'
	}	

*SAVING RESULTS
estout G* using "results_tableA7.txt", nolz notype delimiter(" `=char(9)'") ///
	cells(b(star fmt(3)) se(par(( )) fmt(3))) starlevels(* .05 ** .01 *** .001) ///
    stats(N N_g, fmt(0)) replace
estout H* using "results_tableA8.txt", nolz notype delimiter(" `=char(9)'") ///
	cells(b(star fmt(3)) se(par(( )) fmt(3))) starlevels(* .05 ** .01 *** .001) ///
    stats(N N_g, fmt(0)) replace	

