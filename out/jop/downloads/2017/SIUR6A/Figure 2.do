preserve
recode treat 1=2 2=1
keep if born_again==1 & white==1
replace treat=1.15 if treat==1
replace treat=2.85 if treat==3
g y=.
g se=.
collapse y=imm_support (semean) se=imm_support, by(treat)

gen ub= y + 1.96*se
gen lb = y - 1.96*se

	gr tw (sc y treat if treat==1.15 | treat==2.85, col(black) msize(medsmall) msymbol(square)) ///
	(sc y treat if treat==2, col(black) msize(medsmall) msymbol(square)) ///
	(lfit y treat if treat<2.75, sort lcolor(black) lwidth(vthin) lpattern(dash)) ///
		(lfit y treat if treat>1.25, sort lcolor(black) lwidth(vthin) lpattern(dash)) ///
	(rcap ub lb treat, col(black)), ylabel(0(10)70, nogrid) ///
		ytitle("% Support immigration reform") xtitle("") title() legend(off) ylabel(,nogrid) xlabel(none) scheme(lean1) xscale(range(1,3)) yscale(range(0, 70)) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) ///
text(32 1.5 "diff = 20.67") text(29 1.5 "p-val = 0.03") text(35 2.4 "diff = 3") text(32 2.4 "p-val = 0.79") saving(wba)
gr_edit .xaxis1.add_ticks 1.15 `"Religious"', tickset(major) 
gr_edit .xaxis1.add_ticks 2.85 `"Secular"', tickset(major)
gr_edit .xaxis1.add_ticks 2 `"Control"', tickset(major)
restore



preserve
recode treat 1=2 2=1
keep if born_again==0
replace treat=1.15 if treat==1
replace treat=2.85 if treat==3
g y=.
g se=.
collapse y=imm_support (semean) se=imm_support, by(treat)

gen ub= y + 1.96*se
gen lb = y - 1.96*se

	gr tw (sc y treat if treat==1.15 | treat==2.85, col(black) msize(medsmall) msymbol(square)) ///
	(sc y treat if treat==2, col(black) msize(medsmall) msymbol(square)) ///
	(lfit y treat if treat<2.75, sort lcolor(black) lwidth(vthin) lpattern(dash)) ///
		(lfit y treat if treat>1.25, sort lcolor(black) lwidth(vthin) lpattern(dash)) ///
	(rcap ub lb treat, col(black)), ylabel(0(10)70, nogrid) ///
		ytitle("% Support immigration reform") xtitle("") title() legend(off) ylabel(,nogrid) xlabel(none) scheme(lean1) xscale(range(1,3)) yscale(range(0, 70)) ///
plotregion(fcolor(white)) graphregion(fcolor(white))  ///
text(56 1.5 "diff = 4.69") text(52.5 1.5 "p-val = 0.29") text(52 2.4 "diff = -3.11") text(48.5 2.4 "p-val = 0.48") saving(non_wba)
gr_edit .xaxis1.add_ticks 1.15 `"Religious"', tickset(major) 
gr_edit .xaxis1.add_ticks 2.85 `"Secular"', tickset(major)
gr_edit .xaxis1.add_ticks 2 `"Control"', tickset(major)
restore

graph combine wba.gph non_wba.gph, graphregion(color(white) margin(zero))

