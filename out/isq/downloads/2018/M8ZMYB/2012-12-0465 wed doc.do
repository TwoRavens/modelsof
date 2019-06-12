/*Political Institutions, Credible Commitment and Sovereign Debt in Advanced Economies*/
/*Michael Breen and Iain McMenamin*/
/*Dublin City University, 2013*/

tsset unit_id year, yearly

/*Base specification*/

global base = "inflation fiscalbalgdp L.gengrossdebt L.gengrossdebt2 L.gdpgrowth"

/*TABLE 1*/
xtreg oecdlt $base, fe
est store m1
xtreg oecdlt $base concentration, fe
est store m2
xtreg oecdlt $base c.concentration##c.retrenchment, fe
est store m3
xtreg oecdlt $base polarization, fe
est store m4
xtreg oecdlt $base c.polarization##c.retrenchment, fe
est store m5
xtreg oecdlt $base c.polarization##c.concentration, fe
est store m6
xtreg oecdlt $base c.concentration##c.retrenchment c.polarization##c.concentration c.polarization##c.retrenchment c.polarization##c.concentration##c.retrenchment, fe
est store m7
outreg2 [m1 m2 m3 m4 m5 m6 m7] using table1, word replace label auto(2) eqdrop() sortvar()  drop() e() bdec(2) symbol(***, **, *) nocons

/*TABLE 2*/
xtreg oecdlt $base c.polarization##c.concentration concentration2, fe
est store m8
xtreg oecdst $base concentration, fe
est store m9
xtreg oecdlt $base concentration ideology, fe
est store m10
xtreg oecdlt $base c.ideology##c.concentration, fe
est store m11
outreg2 [m8 m9 m10 m11] using table2, word replace label auto(2) eqdrop() sortvar()  drop() e() bdec(2) symbol(***, **, *) nocons

/*TABLE 3*/
xtreg oecdlt $base c.polarization##c.concentration if year > 1991 & euro99 == 1, fe
est store m12
xtreg oecdlt $base c.polarization##c.concentration if year > 1991 & eurocc == 1, fe
est store m13
xtreg oecdlt $base c.polarization##c.concentration if year > 1999 & euro99 == 1, fe
est store m14
xtreg oecdlt $base c.polarization##c.concentration if year > 1999 & eurocc == 1, fe
est store m15
xtreg oecdlt $base L.polconiii, fe
est store m16
xtreg oecdlt $base concentration ideology, fe
est store m17
xtreg oecdlt $base concentration D.ideology, fe
est store m18
xtreg oecdlt $base concentration leftgov, fe
est store m19
xtreg oecdlt $base concentration D.leftgov, fe
est store m20
xtreg oecdlt $base concentration rightgov, fe
est store m21
xtreg oecdlt $base concentration D.rightgov, fe
est store m22
outreg2 [m12 m13 m14 m15 m16 m17 m18 m19 m20 m21 m22] using table3, word replace label auto(2) eqdrop() sortvar()  drop() e() bdec(2) symbol(***, **, *) nocons

/*FIGURE 1*/
xtreg oecdlt $base c.polarization##c.concentration, fe
quietly margins, dydx(polarization) at(concentration=(-5(1)3)) atmeans vsquish
marginsplot, yline(0) recast(line) recastci(rline) title("") ytitle("Marginal Effect of Polarization on Interest Rates (%)") xtitle("Concentration") addplot(histogram concentration, yaxis(2) yscale(alt axis(2)) fcolor(none) lcolor(black) lwidth(vthin) xscale(range(-5 3)) xlabel(-5(1)3)) legend(off)
