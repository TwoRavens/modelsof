

use "/Users/mhall11/Dropbox/Research/CertProject/Data/Cert.dta", clear

***Table 1: Is Judicial Review Majoritarian?***

logit strike time time2 time3 FloorMedSup, r
estimates store m1a

logit strike time time2 time3 FilibusterSup, r
estimates store m1b

logit strike time time2 time3 PartyGateSup, r
estimates store m1c

estout m1a m1b m1c using "/Users/mhall11/Dropbox/CertProject/Drafts/Tables/MajJudRev.tex", ///
	replace label style(tex) cells(b(star fmt(2)) se(par fmt(2))) wrap varwidth(58) ///
	stats(N ll chi2 p, fmt(0 2 2 2) labels(N "Log-pseudolikelihood" "Wald $\chi ^2$" "Prob \textgreater $\chi ^2$")) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) starlevels(* 0.05) ///
	order(FloorMedSup time time2 time3) rename(FilibusterSup FloorMedSup PartyGateSup FloorMedSup)

***Figure 1: Judicial Majoritarianism***
logit strike c.time##c.time##c.time FloorMedSup, r

margins, at(FloorMedSup=.98 time=(0(1)40)) at(FloorMedSup=.48 time=(0(2)40)) atmeans
marginsplot, ylin(0) scheme(s1mono) ylabel(,grid) recast(line) noci ///
	xlabel(0(10)40) title("") plot2(lpattern(dash) lcolor(gs3))  ///
	ytitle("Predicted Probability of Invalidation", size(medium) margin(medsmall)) ///
	xtitle("Years without Invalidation", size(medium) margin(medsmall)) ///
	plot(, label("High Majority Support" "Low Majority Support")) ///
	legend(region(lcolor(white)))
graph save "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/MajJudRev.gph", replace
graph export "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/MajJudRev.pdf", replace

logit strike c.time##c.time##c.time zFloorMedSup, r

margins, dydx(zFloorMedSup) at(time=(0(1)40)) atmeans
marginsplot, ylin(0) scheme(s1mono) ylabel(,grid) recast(line) recastci(rline) ///
	ci1opts(lpattern(dot) lwidth(thick) lcolor(black)) ///
	xlabel(0(10)40) title("") ///
	ytitle("Effect of 1 S.D. Increase in Majority Support" "on Predicted Probability of Invalidation", size(medium) margin(medsmall)) ///
	xtitle("Years without Invalidation", size(medium) margin(medsmall)) ///
	legend(region(lp(blank)))
graph save "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/MajEff.gph", replace
graph export "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/MajEff.pdf", replace

***Likelihood Ratio Test***
***Floor Median Model***
logit strike c.time##c.time##c.time FloorMedSup
estimates store M1
logit strike FloorMedSup
estimates store M2
lrtest (M1) (M2)

***Table 2: Judicial Majoritarianism at the Cert and Merits Stages***

heckprob strike _FloorMedSup, sel(challenge=_time _time2 _time3 _FloorMedSup) r
estimates store m2a

heckprob strike FilibusterSup, sel(challenge=_time _time2 _time3 FilibusterSup) r
estimates store m2b

heckprob strike PartyGateSup, sel(challenge=_time _time2 _time3 PartyGateSup) r
estimates store m2c

estout m2a m2b m2c using "/Users/mhall11/Dropbox/CertProject/Drafts/Tables/Stage.tex", ///
	replace label style(tex) cells(b(star fmt(2)) se(par fmt(2)))  keep(challenge: strike:) ///
	stats(N ll chi2 p, fmt(0 2 2 2) labels(N "Log-pseudolikelihood" "Wald $\chi ^2$" "Prob \textgreater $\chi ^2$")) ///
	mlabels(none) collabels(none)  varlabels(_cons "\hspace{10pt}Constant") starlevels(* 0.05) ///
	eqlabels("" "\multicolumn{4}{l}{\textit{Stage 2: Invalidations of Important Federal Statutes}}", span) ///
	order(challenge:_FloorMedSup challenge:_time challenge:_time2 challenge:_time3 challenge:_cons strike:_FloorMedSup) ///
	rename(FilibusterSup _FloorMedSup PartyGateSup _FloorMedSup)

***Figure 2: Majoritarian Agenda Setting***

heckprob strike FloorMedSup, sel(challenge=c.time##c.time##c.time FloorMedSup) r

margins, at(FloorMedSup=(0(.05)1) time=1) atmeans predict(psel)
marginsplot, ylin(0) scheme(s1mono) ylabel(,grid) recast(line) recastci(rline) ///
	ci1opts(lpattern(dot) lwidth(thick) lcolor(black)) ///
	xlabel(0(.25)1) title("") ///
	ytitle("Predicted Probability of Challenge", size(medium) margin(medsmall)) ///
	xtitle("Majority Support", size(medium) margin(medsmall)) ///
	legend(region(lp(blank))) title("") 
graph save "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/Agenda.gph", replace
graph export "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/Agenda.pdf", replace


***Figure 3: Conditional Marginal Effects of Pivot Supprot***

logit challenge c.time##c.time##c.time c.agree##c.b_con##c.zFloorMedSup, r
margins, dydx(zFloorMedSup) at(agree=.756 b_con=.075 time=1) atmeans saving(/Users/mhall11/Dropbox/CertProject/Data/Margins/mar1, replace)

margins, dydx(zFloorMedSup) at(agree=1 b_con=.075 time=1) atmeans saving(/Users/mhall11/Dropbox/CertProject/Data/Margins/mar2, replace)

margins, dydx(zFloorMedSup) at(agree=.756 b_con=.536 time=1) atmeans saving(/Users/mhall11/Dropbox/CertProject/Data/Margins/mar3, replace)

margins, dydx(zFloorMedSup) at(agree=1 b_con=.536 time=1) atmeans saving(/Users/mhall11/Dropbox/CertProject/Data/Margins/mar4, replace)

combomarginsplot /Users/mhall11/Dropbox/CertProject/Data/Margins/mar1 /Users/mhall11/Dropbox/CertProject/Data/Margins/mar2 /Users/mhall11/Dropbox/CertProject/Data/Margins/mar3 /Users/mhall11/Dropbox/CertProject/Data/Margins/mar4, ///
ylin(0) recast(scatter) plotr(margin(large)) scheme(s1mono) ylabel(,grid) ///
ytitle("Effect of 1 S.D. Increase in Majority Support" "on Predicted Probability of Invalidation", size(medium) margin(medsmall)) ///
xtitle("{bf:Low Ideological Constraint                   High Ideological Constraint}", size(medsmall) margin(tiny))  ///
xlabel(1 `" "Low Shared" "Preferences" "' 2 `" "High Shared" "Preferences" "' ///
3 `" "Low Shared" "Preferneces" "' 4 `" "High Shared" "Preferences" "') ///
title("") ylabel(-.03(.01).02)
graph save "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/MarEff.gph", replace
graph export "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/MarEff.pdf", replace

test _b[2._at] = _b[1._at]
test _b[2._at] = _b[3._at]
test _b[4._at] = _b[1._at]
test _b[4._at] = _b[3._at]

logit challenge c.time##c.time##c.time c.agree##c.b_con##c.zFloorMedSup, r
margins, dydx(zFloorMedSup) at(b_con=(.536 .075) time=1) atmeans post
test _b[2._at] = _b[1._at]

logit challenge c.time##c.time##c.time c.agree##c.b_con##c.zFloorMedSup, r
margins, dydx(zFloorMedSup) at(agree=(.756 1) time=1) atmeans post
test _b[2._at] = _b[1._at]


***Figure 4: The Foundations of Majoritarian Agenda Setting***

logit challenge c.time##c.time##c.time c.agree##c.b_con##c.FloorMedSup, r

margins, at(FloorMedSup=(.25(.05)1) agree=(.756) b_con=(.075) time=1) atmeans 
marginsplot, ylin(0) scheme(s1mono) ylabel(,grid) recast(line) recastci(rline) ///
	ci1opts(lpattern(dot) lwidth(thick) lcolor(black)) ///
	xlabel(.25(.25)1, labsize(large)) ylabel(0(.05).15, labsize(large)) title("") ///
	ytitle("Predicted Probability of Challenge", size(large) margin(medsmall)) ///
	xtitle("Majority Support", size(large) margin(medsmall)) ///
	legend(region(lp(blank))) title("") 
graph save "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/Path1.gph", replace
graph export "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/Path1.pdf", replace

margins, at(FloorMedSup=(.25(.05)1) agree=(1) b_con=(.075) time=1) atmeans 
marginsplot, ylin(0) scheme(s1mono) ylabel(,grid) recast(line) recastci(rline) ///
	ci1opts(lpattern(dot) lwidth(thick) lcolor(black)) ///
	xlabel(.25(.25)1, labsize(large)) ylabel(0(.05).15, labsize(large)) title("") ///
	ytitle("Predicted Probability of Challenge", size(large) margin(medsmall)) ///
	xtitle("Majority Support", size(large) margin(medsmall)) ///
	legend(region(lp(blank))) title("") 
graph save "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/Path2.gph", replace
graph export "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/Path2.pdf", replace

margins, at(FloorMedSup=(.25(.05)1) agree=(.756) b_con=(.536) time=1) atmeans 
marginsplot, ylin(0) scheme(s1mono) ylabel(,grid) recast(line) recastci(rline) ///
	ci1opts(lpattern(dot) lwidth(thick) lcolor(black)) ///
	xlabel(.25(.25)1, labsize(large)) ylabel(0(.05).15, labsize(large)) title("") ///
	ytitle("Predicted Probability of Challenge", size(large) margin(medsmall)) ///
	xtitle("Majority Support", size(large) margin(medsmall)) ///
	legend(region(lp(blank))) title("") 
graph save "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/Path3.gph", replace
graph export "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/Path3.pdf", replace

margins, at(FloorMedSup=(.25(.05)1) agree=(1) b_con=(.536) time=1) atmeans 
marginsplot, ylin(0) scheme(s1mono) ylabel(,grid) recast(line) recastci(rline) ///
	ci1opts(lpattern(dot) lwidth(thick) lcolor(black)) ///
	xlabel(.25(.25)1, labsize(large)) ylabel(0(.05).15, labsize(large)) title("") ///
	ytitle("Predicted Probability of Challenge", size(large) margin(medsmall)) ///
	xtitle("Majority Support", size(large) margin(medsmall)) ///
	legend(region(lp(blank))) title("") 
graph save "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/Path4.gph", replace
graph export "/Users/mhall11/Dropbox/CertProject/Drafts/Figures/Path4.pdf", replace


***Supporting Information***

***Descriptives***
estpost summarize challenge strike time FloorMedSup FilibusterSup PartyGateSup agree b_con, listwise
esttab using "/Users/mhall11/Dropbox/Research/CertProject/Drafts/Tables/Desc.tex", replace ///
cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") style(tex) label ///
mlabels(none) collabels(none) eqlabels(none) ///
varlabels(strike "Invalidation" challenge "Constitutional Challenge" FilibusterSup ///
"Filibuster Pivot Support" PartyGateSup "Party Gatekeeper Pivot Support" FloorMedSup ///
"Floor Median Pivot Support") wrap varwidth(47) fragment

***Model***
logit challenge time time2 time3 agree b_con FloorMedSup agree_FMS b_con_FMS agree_b_con agree_b_con_FMS, r
estimates store mSI1a

estout mSI1a using "/Users/mhall11/Dropbox/CertProject/Drafts/Tables/IntMod.tex", ///
	replace label style(tex) cells(b(star fmt(2)) se(par fmt(2))) wrap varwidth(47) ///
	stats(N ll chi2 p, fmt(0 2 2 2) labels(N "Log-pseudolikelihood" "Wald $\chi ^2$" "Prob \textgreater $\chi ^2$")) ///
	mlabels(none) collabels(none) eqlabels(none) varlabels(_cons Constant) starlevels(* 0.05) ///
	order(FloorMedSup agree b_con agree_FMS b_con_FMS agree_b_con agree_b_con_FMS time time2 time3)
