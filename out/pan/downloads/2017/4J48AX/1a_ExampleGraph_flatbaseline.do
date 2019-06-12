
*Plot example for scenario with increasing and decreasing baseline hazard rate

*scenario 2
scalar b0=-4
scalar p=1
scalar b1=-1.5
scalar b2=.7

twoway function exp(b0)*p*x^(p-1), ytitle("") xtitle(Time) subtitle(Scenario 2: low baseline) range(0 30) lcol(black) saving(base1, replace)

twoway function exp(b1+b2*ln(x)), ytitle("") xtitle(Time) subtitle(Scenario 2: low baseline) range(0 30) lcol(black) saving(rh1, replace) yline(1, lp(dot) lcol(black))

twoway function (exp(b0)*p*x^(p-1)*exp(b1+b2*ln(x))), ytitle("") xtitle(Time) subtitle(Scenario 2: low baseline) range(0 30) lcol(black) || function (exp(b0)*p*x^(p-1)), lcol(gs10) range(0 30) saving(hdiff1, replace) legend(label(1 "x=1") label(2 "x=0") size(medsmall) region(lwidth(none)))

twoway function exp(-(exp(b0+b1)*p*x^(p+b2)/(p+b2))), ytitle("") xtitle(Time) subtitle(Scenario 2: low baseline) range(0 30) lcol(black) || function exp(-(exp(b0)*x^p)), lcol(gs10) range(0 30) saving(s1, replace) legend(label(1 "x=1") label(2 "x=0") size(medsmall) region(lwidth(none)))

*scenario 1
scalar b0=-1.8
scalar p=1

twoway function exp(b0)*p*x^(p-1), ytitle("") xtitle(Time) subtitle(Scenario 1: high baseline) range(0 30) lcol(black) saving(base2, replace)

twoway function exp(b1+b2*ln(x)), ytitle("") xtitle(Time) subtitle(Scenario 1: high baseline) range(0 30) lcol(black) saving(rh2, replace) yline(1, lp(dot) lcol(black))

twoway function (exp(b0)*p*x^(p-1)*exp(b1+b2*ln(x))), ytitle("") xtitle(Time) subtitle(Scenario 1: high baseline) range(0 30) lcol(black) || function (exp(b0)*p*x^(p-1)), lcol(gs10) range(0 30) saving(hdiff2, replace)

twoway function exp(-(exp(b0+b1)*p*x^(p+b2)/(p+b2))), ytitle("") xtitle(Time) subtitle(Scenario 1: high baseline) range(0 30) lcol(black) || function exp(-(exp(b0)*x^p)), lcol(gs10) range(0 30) saving(s2, replace)


grc1leg base2.gph base1.gph, subtitle("a) Baseline hazard") ycommon col(2) saving(base, replace)

grc1leg rh2.gph rh1.gph, subtitle("b) Hazard ratio of variable x") ycommon col(2) saving(rh, replace)

*grc1leg hdiff2.gph hdiff1.gph, subtitle("c) Hazard rates for different values of x") ycommon col(2) saving(hdiff, replace) leg(hdiff1.gph)

grc1leg s2.gph s1.gph, subtitle("c) Survival estimates for different values of x") ycommon col(2) saving(s, replace) leg(s1.gph)


grc1leg base.gph rh.gph s.gph, col(1) leg(s.gph)
graph display, ysize(9)
graph export example3.pdf, replace
