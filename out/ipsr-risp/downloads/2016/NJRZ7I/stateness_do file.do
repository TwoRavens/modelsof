*model 3*
xtreg capacity diff14 c.polity_p##c.polity_p epb lgdp94 lamp oild fe, re vce(cluster codpa1)
generate sample = e(sample)
tab codpa1 if sample==1

*model 2*
xtreg capacity diff14 c.polity_p##c.polity_p lgdp94 lamp oild fe if sample==1, re vce(cluster codpa1)

*model 1*
xtreg capacity diff14 epb lgdp94 lamp oild fe if sample==1, re vce(cluster codpa1)

*model 3 - figure 2*
xtreg capacity diff14 c.polity_p##c.polity_p epb lgdp94 lamp oild fe if sample==1, re vce(cluster codpa1)
margins, at(polity_p=(-2 (1) 7))
margins, dydx(polity_p) at (polity_p=(-2 (1) 7)) vsquish post
parmest, norestore
gen polity_p=_n-1
label var polity_p "level of democracy"

gen x = 0

*alternativa 1*
twoway (line x polity_p, clcolor(black) clwidth(thin) clpattern(solid)) ///
(line estimate polity_p, clwidth(medium) clcolor(blue) clcolor(black)) ///
(line  min95 polity_p, clpattern(dash) clwidth(thin) clcolor(black) ) ///
(line  max95 polity_p, clpattern(dash) clwidth(thin) clcolor(black)),  ///
title(Predictive margins with 95% confidence interval) xlabel(0 (1) 9) xtitle(level of democracy) xsca(titlegap(2)) ysca(titlegap(2)) legend(off) ///
scheme(s2mono) graphregion(fcolor(white)) ytitle(Marginal impact of level of democracy)



