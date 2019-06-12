**Regressions
xtset country
xtreg political_trust1 male agea i.gen i.citizen i.muslim eduyrs i.work tvpol pol_inter i.essround multineg im_pop imunempl maj_pol_trust, re
eststo Model1a
xtreg political_trust1 male agea i.gen i.citizen eduyrs i.work tvpol pol_inter i.essround c.multineg##i.muslim im_pop imunempl maj_pol_trust, re
eststo Model1b
xtreg political_trust1 male agea i.gen i.citizen i.muslim i.work tvpol pol_inter i.essround c.multineg##c.eduyrs im_pop imunempl maj_pol_trust, re
eststo Model1c

esttab Model1a Model1b Model1c using table3.rtf, se b(%9.3f) 

xtreg satisfied_dem male agea i.gen i.citizen i.muslim eduyrs i.work tvpol pol_inter i.essround multineg im_pop imunempl maj_satisfied_dem, re
eststo Model2a
xtreg satisfied_dem male agea i.gen i.citizen eduyrs i.work tvpol pol_inter i.essround c.multineg##i.muslim im_pop imunempl maj_satisfied_dem, re
eststo Model2b
xtreg satisfied_dem male agea i.gen i.citizen i.muslim i.work tvpol pol_inter i.essround c.multineg##c.eduyrs im_pop imunempl maj_satisfied_dem, re
eststo Model2c

esttab Model2a Model2b Model2c using table4.rtf, se b(%9.3f) 

*Figures
*Fig2
est restore Model1a
marginscontplot multineg, ci plotopts(ytitle("Political trust") xtitle("Negative political rhetoric")) 

*Fig3
est restore Model2a
marginscontplot multineg, ci plotopts(ytitle("Satisfaction with democracy") xtitle("Negative political rhetoric")) 

*Fig4
est restore Model1c
margins, dydx(multineg) at(eduyrs=(0 (1) 30))
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xlabel(#8) ytitle("Marginal effect of negative political rhetoric") title("") scheme(s1mono)

*Fig5
est restore Model2c
margins, dydx(multineg) at(eduyrs=(0 (1) 30))
marginsplot, recast(line) recastci(rline) ciopts(lpattern(dash)) yline(0) xlabel(#8) ytitle("Marginal effect of negative political rhetoric") title("") scheme(s1mono)

*Fig6
est restore Model1b
margins, dydx(multineg) over(muslim)
marginsplot, recast(scatter) yline(0) xscale(range(-0.5 2.5)) xtitle("") ytitle("Marginal effect of negative political rhetoric") title("") scheme(s1mono)

*Fig7
est restore Model2b
margins, dydx(multineg) over(muslim)
marginsplot, recast(scatter) yline(0) xscale(range(-0.5 2.5)) yscale(range(-0.03 0.01)) xtitle("") ytitle("Marginal effect of negative political rhetoric") title("") scheme(s1mono)

*Fig1
graph dot (mean) multineg1 multineg2 multineg3 multineg4 multineg5 multineg6 multineg7, over(country, sort(multineg)) yscale(range(0 7.5)) ytitle(Negative political rhetoric) scheme(s1mono) marker(1,   msymbol(circle_hollow ))  marker(2,   msymbol(T))  marker(3,   msymbol(square_hollow )) marker(4,   msymbol(Dh)) marker(5,   msymbol(x)) 







