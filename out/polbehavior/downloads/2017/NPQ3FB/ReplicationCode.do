***Use "Chen_Bryan Experimental Data (Replication).dta" for these analyses

********************************
* Generate necessary variables *
********************************


gen support01=.
replace support01=(nominee_support-1)/6
lab def support01 1 "support" 0 "oppose"
lab val support01 support01

gen forth_ret=forth_cond
recode forth_ret 1=. 2=1 3=2

gen pro_con=pro_con_neutral
recode pro_con 3=.

gen nominee_ft01=nominee_ft/100


alpha nominee_ft01 nominee_qualified support01
pca nominee_ft01 nominee_qualified support01
predict pc3 pc4, score
factor nominee_ft01 nominee_qualified support01, pf
gen support_scale_2=(nominee_ft01+nominee_qualified+support01)/3


********************************
* Table 1					   *
********************************

reg support_scale_2 forth_ret##pro_con if valid==1 & TranscriptDuration>0

**********************************
*             Table 4		     *
********** For Appendix **********
**********************************

reg support_scale_2 forth_ret##pro_con if valid==1 & TranscriptDuration > 30

reg support_scale_2 forth_ret##pro_con if valid==1 & TranscriptDuration < 30

reg support_scale_2 forth_ret##pro_con if valid==1 & TranscriptDuration < 15

**********************************
*             Table 3		     *
********** For Appendix **********
**********************************

reg nominee_ft01 forth_ret##pro_con if valid==1 & TranscriptDuration>0

reg nominee_qualified forth_ret##pro_con if valid==1 & TranscriptDuration>0

reg support01 forth_ret##pro_con if valid==1 & TranscriptDuration>0

********************************
* Figure 2					   *
********************************
	
reg support_scale_2 forth_ret##pro_con if valid==1 & TranscriptDuration>0

margins, dydx(forth_ret) at(pro_con=(1(1)2)) level(95)
marginsplot, recast(scatter) recastci(rspike) ///
	graphregion(fcolor(white) lcolor(white)) ///
	yline(0, lcol(black)) ///
	plot1opts(mcol(black)) ///
	ciopts(lcol(black)) ///
	title("Nominee Support", col(black) nospan) ///
	ytitle("") ///
	xtitle("") ///
	xlab(0.75 " " 1 `" "Pro-" "Attitudinal" "' 2 `" "Counter-" "Attitudinal" "' 2.25 " ", notick) ///
	ylab(-.15(.05).15)
	
reg support_scale_2 forth_ret##pro_con if valid==1 & TranscriptDuration>0

margins, dydx(forth_ret) at(pro_con=(1(1)2)) level(95) pwcompare
margins, dydx(forth_ret) at(pro_con=(1(1)2)) level(95)
margins, dydx(pro_con) at(forth_ret=(1(1)2))

********************************
* Figure 1					   *
********************************

lab def forth_ret 1 "Forthcoming" 2 "Reticent"
lab val forth_ret forth_ret
lab def pro_con 1 "Pro-Attitudinal Nominee" 2 "Counter-Attitudinal Nominee"
lab val pro_con pro_con
save "Data for Mean Graph.dta", replace

collapse (mean) meansupport=support_scale_2 (sd) sdsupport=support_scale_2 (count) n=support_scale_2 if valid==1 & TranscriptDuration>0, by(forth_ret pro_con)
gen hisupport = meansupport + invttail(n-1,0.025)*(sdsupport / sqrt(n))
gen losupport = meansupport - invttail(n-1,0.025)*(sdsupport / sqrt(n))
gen cond_comb = forth_ret if pro_con==1
replace cond_comb = forth_ret+2 if pro_con==2
sort cond_comb
list cond_comb forth_ret pro_con, sepby(pro_con)

twoway (bar meansupport cond_comb, ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(.25)1) ///
	ytitle("") ///
	bcolor(gs5) ///
	bargap(2) ///
	title("Nominee Support Index", col(black) nospan)) ///
	(rcap hisupport losupport cond_comb, ///
	lcol(black)), ///
	legend(off) ///
	xlab(1 "Forthcoming" 2 "Reticent" 3 "Forthcoming" 4 "Reticent", labsize(small)) ///
	xtitle("") ///
	text(.95 1.5 "Pro-Attitudinal") ///
	text(.95 3.5 "Counter-Attitudinal") ///
	title("Nominee Support Index", col(black) nospan) 





	

	
***Use "Chen_Bryan Observational Data (Replication).dta" for these analyses
	
********************************
* Generate Variables		   *
********************************

gen qualified_ratio=(qualified/forthcoming)*100
gen notforthcoming_ratio=(notforthcoming/forthcoming)*100
gen reticent_ratio=((qualified+notforthcoming)/(forthcoming))*100
gen reticent_ratio2=((qualified+notforthcoming)/(forthcoming+qualified+notforthcoming))*100

********************************
* Table 2		 			   *
********************************

xtmixed statepredconfirmwithop c.qualified_ratio##c.PIDCongruence democrat liberal mood || _all: R.NomineeNumber || FIPS: , mle

*********************************
* Figure 3						*
*********************************

margins, predict() at(qualified_ratio=(6(1)26) PIDCongruence=(17(31)48))
marginsplot, recast(line) recastci(rline) ///
	plot1opts(lwidth(thick) lcol(black)) ///
	plot2opts(lwidth(thick) lcol(black) lpat(dash)) ///
	ciopts(lpat(dot) lcol(black)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(25)100) ///
	xlab(5 " " 6 `""Minimal" "Reticence""' 16 `""Mean" "Reticence""' 26 `""Maximal" "Reticence""' 27 " ", labsize(small) notick) ///
	xtitle("") ///
	ytitle("Nominee Support") ///
	legend(off)	///
	text(48 6.25 "Low PID", size(vsmall)) ///
	text(46 6.25 "Congruence", size(vsmall)) ///
	text(79 6.25 "High PID", size(vsmall)) ///
	text(77 6.25 "Congruence", size(vsmall)) ///
	title("Nominee Reticence", col(black) nospan) ///
	name(a1, replace)
	
margins, predict() at(PIDCongruence=(17(1)48) qualified_ratio=(6(20)26) )
marginsplot, recast(line) recastci(rline) ///
	plot1opts(lwidth(thick) lcol(black)) ///
	plot2opts(lwidth(thick) lcol(black) lpat(dash)) ///
	ciopts(lpat(dot) lcol(black)) ///
	graphregion(fcolor(white) lcolor(white)) ///
	ylab(0(25)100) ///
	xlab(16 " " 17 `""Low PID" "Congruence""' 32.5 `""Mean PID" "Congruence""' 48 `""High PID" "Congruence""' 49 " ", labsize(small) notick) ///
	xtitle("") ///
	ytitle("Nominee Support") ///
	legend(off)	///
	text(48 18 "Forthcoming", size(vsmall)) ///
	text(46 18 "Nominee", size(vsmall)) ///
	text(85 18 "Reticent", size(vsmall)) ///
	text(83 18 "Nominee", size(vsmall)) ///
	title("") ///
	title("Partisan Congruence", col(black) nospan) ///
	name(a2, replace)

graph combine a1 a2, ///
	title("") ///
	graphregion(fcolor(white) lcolor(white)) ///
	note("Note: Dotted lines represent 95% confidence intervals.", size(vsmall))
