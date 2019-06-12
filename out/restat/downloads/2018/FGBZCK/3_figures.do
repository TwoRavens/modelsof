* ==============================================================================
* PART III: Figures
* Date: Feb 2018
* 
* 3_figures
* Data: gstyping.dta
*
* Produces figures 1-3 and figures in appendix 
* ==============================================================================
set scheme s1mono

*GENDER STYPING BY GENDER COMBINED 
preserve
collapse tmale Wtgender, by(teachername)
label value tmale tmale
twoway hist Wtgender, by(tmale, compact title("Panel 1 : Teachers", size(medsmall))  graphregion(color(white)) note("")) start(-1.8894949) bin(35) color(gs5) name(k11, replace) xtitle("Standardized Gender Styping Score", size(small)) subtitle(, lcolor(white) fcolor(white)) ytitle(Density, size(small) margin(small))
restore
twoway hist zstud_gender, by(male, compact title("Panel 2 : Students", size(medsmall)) graphregion(color(white)) note("")) start(-2.4677956) bin(32) color(gs5) name(k12, replace) xtitle("Standardized Gender Styping Score", size(small)) subtitle(, lcolor(white) fcolor(white)) ytitle(Density, size(small) margin(small))
graph combine k11 k12, row(2) col(1) imargin(1 0) graphregion(margin(r=9 l=1)) xsize(4) ysize(5) graphregion(color(white))
graph export "gender_bias_comb.eps", replace

*SEMIPARAMETRIC
*Math
xi: semipar math_std tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses hhgender working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & term_t==1, nonpar(Wtgender)  cluster(teachername) ci  ///
level(95) degree(1) kernel(epanechnikov) trim(0.0)  ytitle(Standardized Test Scores (Maths) (with 95% CIs)) xtitle(Teacher's Gender Stereotyping Score) title("1-Year Exposure: Girls: Math") 
gr_edit .yaxis1.reset_rule -3 3 1 , tickset(major) ruletype(range)
gr_edit .xaxis1.reset_rule -2 2 1 , tickset(major) ruletype(range)
gr_edit .yaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(fillcolor(gs5)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(linestyle(color(gs5))) editcopy
graph export "Semiparam_MathGirlsST.png", replace

xi: semipar math_std tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses hhgender working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & term_t==2, nonpar(Wtgender)  cluster(teachername) ci  ///
level(95) degree(1) kernel(epanechnikov) trim(0.0) nsim(5) ytitle(Standardized Test Scores (Maths) (with 95% CIs)) xtitle(Teacher's Gender Stereotyping Score) title("2-3-Year Exposure: Girls: Math")
gr_edit .yaxis1.reset_rule -3 3 1 , tickset(major) ruletype(range)
gr_edit .xaxis1.reset_rule -2 2 1 , tickset(major) ruletype(range)
gr_edit .yaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(fillcolor(gs5)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(linestyle(color(gs5))) editcopy
graph export "Semiparam_MathGirlsMT.png", replace

xi: semipar math_std tmale age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std i.ses hhgender working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & term_t==3, nonpar(Wtgender)  cluster(teachername) ci  ///
level(95) degree(1) kernel(epanechnikov) trim(0.0) nsim(5) ytitle(Standardized Test Scores (Maths) (with 95% CIs)) xtitle(Teacher's Gender Stereotyping Score) title("4-Year Exposure: Girls: Math")
gr_edit .yaxis1.reset_rule -3 3 1 , tickset(major) ruletype(range)
gr_edit .xaxis1.reset_rule -2 2 1 , tickset(major) ruletype(range)
gr_edit .yaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(fillcolor(gs5)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(linestyle(color(gs5))) editcopy
graph export "Semiparam_MathGirlsLT.png", replace

xi: semipar math_std tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses hhgender working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & term_t==1, nonpar(Wtgender) cluster(teachername) ci  ///
level(95) degree(1) kernel(epanechnikov) trim(0.0) ytitle(Standardized Test Scores (Maths) (with 95% CIs)) xtitle(Teacher's Gender Stereotyping Score) title("1-Year Exposure: Boys: Math")
gr_edit .yaxis1.reset_rule -3 3 1 , tickset(major) ruletype(range)
gr_edit .xaxis1.reset_rule -2 2 1 , tickset(major) ruletype(range)
gr_edit .yaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(fillcolor(gs5)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(linestyle(color(gs5))) editcopy
graph export "Semiparam_MathBoysST.png", replace

xi: semipar math_std tmale tss_behavior conf zstud_gender zgms_stud raven_std hhgender i.ses working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & term_t==2, nonpar(Wtgender) cluster(teachername) ci  ///
level(95) degree(1) kernel(epanechnikov) trim(0.0) ytitle(Standardized Test Scores (Maths) (with 95% CIs)) xtitle(Teacher's Gender Stereotyping Score) title("2-3-Year Exposure: Boys: Math")
gr_edit .yaxis1.reset_rule -3 3 1 , tickset(major) ruletype(range)
gr_edit .xaxis1.reset_rule -2 2 1 , tickset(major) ruletype(range)
gr_edit .yaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(fillcolor(gs5)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(linestyle(color(gs5))) editcopy
graph export "Semiparam_MathBoysMT.png", replace

xi: semipar math_std tmale tss_behavior age_m_mean conf zstud_gender zgms_stud raven_std i.ses hhgender working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & term_t==3, nonpar(Wtgender) cluster(teachername) ci  ///
level(95) degree(1) kernel(epanechnikov) trim(0.0) ytitle(Standardized Test Scores (Maths) (with 95% CIs)) xtitle(Teacher's Gender Stereotyping Score) title("4-Year Exposure: Boys: Math")
gr_edit .yaxis1.reset_rule -3 3 1 , tickset(major) ruletype(range)
gr_edit .xaxis1.reset_rule -2 2 1 , tickset(major) ruletype(range)
gr_edit .yaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(fillcolor(gs5)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(linestyle(color(gs5))) editcopy
graph export "Semiparam_MathBoysLT.png", replace


*SEMIPARAMETRIC
*Turkish
xi: semipar turkish_std tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses hhgender working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & term_t==1, nonpar(Wtgender)  cluster(teachername) ci  ///
level(95) degree(1) kernel(epanechnikov) trim(0.0)  ytitle(Standardized Test Scores (Verbal) (with 95% CIs)) xtitle(Teacher's Gender Stereotyping Score) title("1-Year Exposure: Girls: Verbal")
gr_edit .yaxis1.reset_rule -3 3 1 , tickset(major) ruletype(range)
gr_edit .xaxis1.reset_rule -2 2 1 , tickset(major) ruletype(range)
gr_edit .yaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(fillcolor(gs5)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(linestyle(color(gs5))) editcopy
graph export "Semiparam_TurkGirlsST.png", replace

xi: semipar turkish_std tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses hhgender working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & term_t==2, nonpar(Wtgender)  cluster(teachername) ci  ///
level(95) degree(1) kernel(epanechnikov) trim(0.0) nsim(5) ytitle(Standardized Test Scores (Verbal) (with 95% CIs)) xtitle(Teacher's Gender Stereotyping Score) title("2-3-Year Exposure: Girls: Verbal")
gr_edit .yaxis1.reset_rule -3 3 1 , tickset(major) ruletype(range)
gr_edit .xaxis1.reset_rule -2 2 1 , tickset(major) ruletype(range)
gr_edit .yaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(fillcolor(gs5)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(linestyle(color(gs5))) editcopy
graph export "Semiparam_TurkGirlsMT.png", replace

xi: semipar turkish_std tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses hhgender working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0 & term_t==3, nonpar(Wtgender)  cluster(teachername) ci  ///
level(95) degree(1) kernel(epanechnikov) trim(0.0) nsim(5) ytitle(Standardized Test Scores (Verbal) (with 95% CIs)) xtitle(Teacher's Gender Stereotyping Score) title("4-Year Exposure: Girls: Verbal")
gr_edit .yaxis1.reset_rule -3 3 1 , tickset(major) ruletype(range)
gr_edit .xaxis1.reset_rule -2 2 1 , tickset(major) ruletype(range)
gr_edit .yaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(fillcolor(gs5)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(linestyle(color(gs5))) editcopy
graph export "Semiparam_TurkGirlsLT.png", replace

xi: semipar turkish_std tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses hhgender working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & term_t==1, nonpar(Wtgender) cluster(teachername) ci  ///
level(95) degree(1) kernel(epanechnikov) trim(0.0) ytitle(Standardized Test Scores (Verbal) (with 95% CIs)) xtitle(Teacher's Gender Stereotyping Score) title("1-Year Exposure: Boys: Verbal")
gr_edit .yaxis1.reset_rule -3 3 1 , tickset(major) ruletype(range)
gr_edit .xaxis1.reset_rule -2 2 1 , tickset(major) ruletype(range)
gr_edit .yaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(fillcolor(gs5)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(linestyle(color(gs5))) editcopy
graph export "Semiparam_TurkBoysST.png", replace

xi: semipar turkish_std tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses hhgender working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & term_t==2, nonpar(Wtgender) cluster(teachername) ci  ///
level(95) degree(1) kernel(epanechnikov) trim(0.0) ytitle(Standardized Test Scores (Verbal) (with 95% CIs)) xtitle(Teacher's Gender Stereotyping Score) title("2-3-Year Exposure: Boys: Verbal")
gr_edit .yaxis1.reset_rule -3 3 1 , tickset(major) ruletype(range)
gr_edit .xaxis1.reset_rule -2 2 1 , tickset(major) ruletype(range)
gr_edit .yaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(fillcolor(gs5)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(linestyle(color(gs5))) editcopy
graph export "Semiparam_TurkBoysMT.png", replace

xi: semipar turkish_std tmale tss_behavior conf zstud_gender zgms_stud raven_std i.ses hhgender working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1 & term_t==3, nonpar(Wtgender) cluster(teachername) ci  ///
level(95) degree(1) kernel(epanechnikov) trim(0.0) ytitle(Standardized Test Scores (Verbal) (with 95% CIs)) xtitle(Teacher's Gender Stereotyping Score) title("4-Year Exposure: Boys: Verbal")
gr_edit .yaxis1.reset_rule -3 3 1 , tickset(major) ruletype(range)
gr_edit .xaxis1.reset_rule -2 2 1 , tickset(major) ruletype(range)
gr_edit .yaxis1.style.editstyle draw_major_grid(yes) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(symbol(circle)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(fillcolor(gs5)) editcopy
gr_edit .plotregion1.plot3.style.editstyle marker(linestyle(color(gs5))) editcopy
graph export "Semiparam_TurkBoysLT.png", replace


*LINEAR PREDICTIONS - MARGIN PLOTS
*Math
xi: reg math_std tmale male pterm##c.Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std hhgender i.ses working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0, cluster(teachername) 

margins, dydx(pterm) at(Wtgender=(-1.92(0.5)3)) vsquish 
marginsplot, yline(0) title("Math Ability:Girls") legend(col(1)) plot( ,label("2-Years" "3-Years" "4-Years")) xtitle(Teacher's Gender Stereotyping Score)
gr_edit .yaxis1.reset_rule -1 1 0.5 , tickset(major) ruletype(range)
graph export "linearpredMath_Girls.png", replace

xi: reg math_std tmale male pterm##c.Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std hhgender i.ses working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1, cluster(teachername) 

margins, dydx(pterm) at(Wtgender=(-1.92(0.5)3)) vsquish 
marginsplot, yline(0) title("Math Ability:Boys") legend(col(1)) plot( ,label("2-Years" "3-Years" "4-Years")) xtitle(Teacher's Gender Stereotyping Score)
gr_edit .yaxis1.reset_rule -1 1 0.5 , tickset(major) ruletype(range)
graph export "linearpredMath_Boys.png", replace

*Turkish

xi: reg turkish_std tmale male pterm##c.Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std hhgender i.ses working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==0, cluster(teachername) 

margins, dydx(pterm) at(Wtgender=(-1.92(0.5)3)) vsquish 
marginsplot, yline(0) title("Verbal Ability:Girls") legend(col(1)) plot( ,label("2-Years" "3-Years" "4-Years")) xtitle(Teacher's Gender Stereotyping Score)
gr_edit .yaxis1.reset_rule -1 1 0.5 , tickset(major) ruletype(range)
graph export "linearpredVerbal_Girls.png", replace

xi: reg turkish_std tmale male pterm##c.Wtgender age_m_mean tss_behavior conf zstud_gender zgms_stud raven_std hhgender i.ses working_mom computer i.ts_4 ts_2 i.proximity i.qual ts_3 tt_train ts_5 gms extrinsic constructive warmth if male==1, cluster(teachername) 

margins, dydx(pterm) at(Wtgender=(-1.92(0.5)3)) vsquish 
marginsplot, yline(0) title("Verbal Ability:Boys") legend(col(1)) plot( ,label("2-Years" "3-Years" "4-Years")) xtitle(Teacher's Gender Stereotyping Score)
gr_edit .yaxis1.reset_rule -1 1 0.5 , tickset(major) ruletype(range)
graph export "linearpredVerbal_Boys.png", replace


est clear
