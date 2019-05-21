
*white evangelical Republicans
preserve
keep if whiteevan==1 & rep==1
g pro_y=.
g neutral_y=.
g anti_y=.

g pro_se=.
g neutral_se=.
g anti_se=.

collapse (mean) pro_y=proreform neutral_y=neutral anti_y=antireform (semean) pro_se=proreform neutral_se=neutral anti_se=antireform [aw=finalweight1], by(wave)

bys wave: sum pro_y neutral_y anti_y

gen ub_pro = pro_y + 1.96*pro_se
gen lb_pro = pro_y - 1.96*pro_se

gen ub_neutral = neutral_y + 1.96*neutral_se
gen lb_neutral = neutral_y - 1.96*neutral_se

gen ub_anti = anti_y + 1.96*anti_se
gen lb_anti = anti_y - 1.96*anti_se

twoway (scatter pro_y wave, col(black) msymbol(circle)) (lfit pro_y wave if wave==1 | wave==2, col(black) lpattern(solid)) (lfit pro_y wave if wave==3 | wave==2, col(black) lpattern(solid)) ///
(scatter neutral_y wave, col(black) msymbol(square)) (lfit neutral_y wave if wave==1 | wave==2, col(black) lpattern(dash)) (lfit neutral_y wave if wave==3 | wave==2, col(black) lpattern(dash)) ///
(scatter anti_y wave, col(black) msymbol(triangle)) (lfit anti_y wave if wave==1 | wave==2, col(black) lpattern(dot)) (lfit anti_y wave if wave==3 | wave==2, col(black) lpattern(dot)) ///
(rcap ub_pro lb_pro wave, col(black)) (rcap ub_neutral lb_neutral wave, col(black) lpattern(dash)) (rcap ub_anti lb_anti wave, col(black) lpattern(dot)), ///
ylabel(10(10)70, nogrid) ytitle("Immigration reform attitudes (percent)") xtitle("") title() legend(off) ylabel(,nogrid) xlabel(none) scheme(lean1) xscale(range(1,3)) yscale(range(10, 70)) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) text(63 1.3 "Oppose reform", size(small)) text(19.5 2.8 "Neither", size(small)) text(30 2.65 "Support reform", size(small)) saving(wba_rep)
gr_edit .xaxis1.add_ticks 1 `"Feb 13"', tickset(major) 
gr_edit .xaxis1.add_ticks 2 `"Sept 13"', tickset(major) 
gr_edit .xaxis1.add_ticks 3 `"Feb 14"', tickset(major) 
*gr export "~/Dropbox/Immigration/JOP Results/TAPS/figures/overtime_whiteevans_republicans1.pdf", replace
restore


*white Republicans who are not evangelicals
preserve
keep if whiteevan==0 & rep==1
g pro_y=.
g neutral_y=.
g anti_y=.

g pro_se=.
g neutral_se=.
g anti_se=.

collapse (mean) pro_y=proreform neutral_y=neutral anti_y=antireform (semean) pro_se=proreform neutral_se=neutral anti_se=antireform [aw=finalweight1], by(wave)

bys wave: sum pro_y neutral_y anti_y

gen ub_pro = pro_y + 1.96*pro_se
gen lb_pro = pro_y - 1.96*pro_se

gen ub_neutral = neutral_y + 1.96*neutral_se
gen lb_neutral = neutral_y - 1.96*neutral_se

gen ub_anti = anti_y + 1.96*anti_se
gen lb_anti = anti_y - 1.96*anti_se

twoway (scatter pro_y wave, col(black) msymbol(circle)) (lfit pro_y wave if wave==1 | wave==2, col(black) lpattern(solid)) (lfit pro_y wave if wave==3 | wave==2, col(black) lpattern(solid))  ///
(scatter neutral_y wave, col(black) msymbol(square)) (lfit neutral_y wave if wave==1 | wave==2, col(black) lpattern(dash)) (lfit neutral_y wave if wave==3 | wave==2, col(black) lpattern(dash)) ///
(scatter anti_y wave, col(black) msymbol(triangle)) (lfit anti_y wave if wave==1 | wave==2, col(black) lpattern(dot)) (lfit anti_y wave if wave==3 | wave==2, col(black) lpattern(dot)) ///
(rcap ub_pro lb_pro wave, col(black)) (rcap ub_neutral lb_neutral wave, col(black) lpattern(dash)) (rcap ub_anti lb_anti wave, col(black) lpattern(dot)), ///
ylabel(10(10)70, nogrid) ytitle("Immigration reform attitudes (percent)") xtitle("") title() legend(off) ylabel(,nogrid) xlabel(none) scheme(lean1) xscale(range(1,3)) yscale(range(10, 70)) ///
plotregion(fcolor(white)) graphregion(fcolor(white)) text(54 1.3 "Oppose reform", size(small)) text(19 2.8 "Neither", size(small)) text(31.25 2.65 "Support reform", size(small)) saving(non_wba_rep)
gr_edit .xaxis1.add_ticks 1 `"Feb 13"', tickset(major) 
gr_edit .xaxis1.add_ticks 2 `"Sept 13"', tickset(major) 
gr_edit .xaxis1.add_ticks 3 `"Feb 14"', tickset(major) 
*gr export "~/Dropbox/Immigration/JOP Results/TAPS/figures/overtime_others_republicans1.pdf", replace
restore

gr combine wba_rep.gph non_wba_rep.gph, graphregion(color(white) margin(zero))

