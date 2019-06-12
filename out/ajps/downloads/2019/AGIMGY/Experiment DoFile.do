

***Figure 1***

reg therm2 gut##ambiv
margins gut, at (ambiv = (0 1))
marginsplot, legend(col(1)) plot1opts(lpattern("dash") lcolor(black) mcolor(black)) ci1opts(lcolor(black)) plot2opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci2opts(lcolor(black)) ylabel(60 (5) 80) title("Attitudes") xtitle("Ambivalence", size(3)) ytitle("Attitudes", size(3)) graphregion(color(white)) bgcolor(white) saving(therm2_exp, replace)
margins, at (ambiv = (0 1)) dydx(gut) 
marginsplot, plotopts(lcolor(black) mcolor(black)) ci1opts(lcolor(black)) legend(order(1 "Baseline" 2 "Good Gut Feeling") col(1) region(color(none))) title("Attitudes") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-10(5)10, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(therm2margin_exp, replace)

probit therm50 gut##ambiv
margins gut, at (ambiv = (0 1))
marginsplot, legend(col(1)) plot1opts(lpattern("dash") lcolor(black) mcolor(black)) ci1opts(lcolor(black)) plot2opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci2opts(lcolor(black)) ylabel(0 (.05) .2) title("Non-Attitudes") xtitle("Ambivalence", size(3)) ytitle("p(Non-Attitude)", size(3)) graphregion(color(white)) bgcolor(white) saving(nonatt_exp, replace)
margins, at (ambiv = (0 1)) dydx(gut) 
marginsplot, plotopts(lcolor(black) mcolor(black)) ci1opts(lcolor(black))  legend(order(1 "Baseline" 2 "Good Gut Feeling") col(1) region(color(none))) title("Non-Attitudes") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.2(.1).2, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(nonattmargin_exp, replace)

probit vote_notyes gut##ambiv
margins gut, at (ambiv = (0 1))
marginsplot, legend(col(1)) plot1opts(lpattern("dash") lcolor(black) mcolor(black)) ci1opts(lcolor(black)) plot2opts(lpattern("solid") lcolor(black) mcolor(black) msymbol(diamond)) ci2opts(lcolor(black)) ylabel(0 (.15) .6) title("Abstention") xtitle("Conflict", size(3)) ytitle("p(Abstention)", size(3)) graphregion(color(white)) bgcolor(white) saving(dk_exp, replace)
margins, at (ambiv = (0 1)) dydx(gut) 
marginsplot, plotopts(lcolor(black) mcolor(black)) ci1opts(lcolor(black))  legend(order(1 "Baseline" 2 "Good Gut Feeling") col(1) region(color(none))) title("Abstention") xtitle("Ambivalence", size(4) margin(medium)) ytitle("Marginal Effect", size(4)) ylabel(-.4(.2).4, axis(1) labsize(4)) yline(0) graphregion(color(white)) bgcolor(white) saving(dkmargin_exp, replace)

gr combine therm2_exp.gph nonatt_exp.gph dk_exp.gph therm2margin_exp.gph nonattmargin_exp.gph dkmargin_exp.gph, graphregion(color(white)) rows (2)


***Appendix Tables***

***Table 1A***

reg therm2 gut##ambiv
probit therm50 gut##ambiv
probit vote_notyes gut##ambiv

***Manipulation Checks & Contamination Tests***

***Table 5A***

probit know1 gut ambiv
probit know1 gut##ambiv
probit know2 gut ambiv
probit know2 gut##ambiv

***Table 6A***

oprobit conflict2 gut ambiv
oprobit conflict2 gut##ambiv
probit conflict_open gut ambiv
probit conflict_open gut##ambiv

***Mechanisms***

***Table 7A***

probit gut_open gut ambiv
probit gut_open gut##ambiv
reg logcount gut ambiv
reg logcount gut##ambiv

***Mediation Tests***

***Table 8A***

medeff (regress conflict2 gut) (regress therm2 gut conflict2), treat(gut) mediate(conflict2) sims(1000)
medeff (regress conflict2 gut) (probit therm50 gut conflict2), treat(gut) mediate(conflict2) sims(1000)
medeff (regress conflict2 gut) (probit vote_notyes gut conflict2), treat(gut) mediate(conflict2) sims(1000)


