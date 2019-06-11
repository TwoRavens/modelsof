clear all

use "Study2data.dta"

*demos
gen PID = pid
recode PID 2=6 1=2 3/4=4
recode PID 2=1 if pidd==1
recode PID 6=7 if pidr==1
recode PID 4=5 if pidi==2
recode PID 4=3 if pidi==1
gen RD=PID
recode RD 1/3=1 4=. 5/7=0
rename ideo Ideo
gen male=sex
recode male 2/3=0

*knowledge
drop pk*DO*
recode pk1 3=1 *=0
recode pk2 1=1 *=0
recode pk3 1=1 *=0
recode pk4 2=1 *=0
alpha pk*, item gen(Know)

irt hybrid (grm interest) (2pl pk*)
predict knowlatent, latent
xtile knowl3=knowlatent, nq(3)

*traits
drop traits*DO*
rename traits*_6 traits*_5
rename traits*_7 traits*_6

*collapsing ideology and traits across conditions
forval x=1/6 {
egen ideo`x'=rowfirst(ideo_v`x'*)
	forval y=1/6 {
	egen traits_v`x'_`y'=rowfirst(traits_v`x'do_`y' traits_v`x'dm_`y' traits_v`x'de_`y' traits_v`x'ro_`y' traits_v`x'rm_`y' traits_v`x're_`y' traits_v`x'c_`y' traits_v`x'cl_`y' traits_v`x'cm_`y' traits_v`x'cc_`y')
	}
}

*creating trait index
forval x=1/6 {
gen traitindex`x'=((traits_v`x'_3 + traits_v`x'_4 + traits_v`x'_5)/3) - ((traits_v`x'_1 + traits_v`x'_2)/2)
}

*creating vignette-level trait averages
forval x=1/6 {
egen traits_avg_v`x' = rowmean(traits_v`x'_*)
}

*creating trait differences from vignette mean
forval x=1/6 {
	forval y=1/6 {
	gen trait`y'diff_v`x'=traits_v`x'_`y' - traits_avg_v`x'
	}
}

*experimental conditions
forval x=1/6 {
gen cond`x'=.
replace cond`x'=1 if traits_v`x'c_1!=.
replace cond`x'=2 if traits_v`x're_1!=.
replace cond`x'=3 if traits_v`x'cc_1!=.
replace cond`x'=4 if traits_v`x'ro_1!=.
replace cond`x'=5 if traits_v`x'rm_1!=.
replace cond`x'=6 if traits_v`x'cm_1!=.
replace cond`x'=7 if traits_v`x'dm_1!=.
replace cond`x'=8 if traits_v`x'do_1!=.
replace cond`x'=9 if traits_v`x'cl_1!=.
replace cond`x'=10 if traits_v`x'de_1!=.
}


*reshaping
reshape long traitindex trait1diff_v trait2diff_v trait3diff_v trait4diff_v trait5diff_v trait6diff_v ideo cond, i(ID) j(vignette)

rename trait*diff_v trait*diff

label define condlab 1 "Control" 2 "Consistent Rep." 3 "Consistent Con." 4 "Rep. Only" 5 "Inconsistent Rep." 6 "Inconsistent Only" 7 "Inconsistent Dem." 8 "Dem. Only" 9 "Consistent Lib." 10 "Consistent Dem."
label values cond condlab

*full model
xtset ID
xtreg traitindex i.cond i.vignette, fe vce(cluster ID)
est store m1

*figure 5
coefplot m1, keep(*.cond) graphregion(color(white)) xline(0) xlab(-1(.5)1) ///
	subtitle("Figure 5. Trait Stereotypes by Experimental Condition") ///
	xtitle("<-- More compassionate, fair-minded ---- more patriotic, tough, wholesome -->", size(small)) ///
	xsc(titlegap(2)) ylab(1 "Republican, Conservative" 2 "No Party, Conservative" ///
	3 "Republican, No Issues" 4 "Republican, Moderate" 5 "No Party, Moderate" ///
	6 "Democrat, Moderate" 7 "Democrat, No Issues" 8 "No Party, Liberal" 9 "Democrat, Liberal")

*figure 6
xtreg traitindex i.cond i.vignette, fe vce(cluster ID)
lincomest 4.cond-8.cond /* party cue only */
est store e1
xtreg traitindex i.cond i.vignette, fe vce(cluster ID)
lincomest 3.cond-9.cond /* ideology, no party */
est store e2
xtreg traitindex i.cond i.vignette, fe vce(cluster ID)
lincomest 2.cond-10.cond /* extreme partisans */
est store e3
xtreg traitindex i.cond i.vignette, fe vce(cluster ID)
lincomest (2.cond-10.cond)-(3.cond-9.cond) /* remaining effect */
est store e4

xtreg traitindex i.cond i.vignette, fe vce(cluster ID)
lincomest 4.cond-8.cond /* party cue only */
est store f1
xtreg traitindex i.cond i.vignette, fe vce(cluster ID)
lincomest 5.cond-7.cond /* moderate partisans */
est store f2
xtreg traitindex i.cond i.vignette, fe vce(cluster ID)
lincomest (4.cond-8.cond)-(5.cond-7.cond) /* eliminated effect */
est store f3

coefplot e1 e2 e3 e4, vert ylab(-.5(.5)1.5) yline(0) ///
	legend(off) xlab(.7 `""Democrat vs. Republican" "(No Issues)"' .9 `""Liberal vs. Conservative" "(No Parties)"' 1.1 `""Liberal Democrat vs." "Conservative Republican"' 1.3 `""Remaining Effect" "of Party Cues""', labsize(vsmall)) ///
	saving(figure6a.gph, replace)
coefplot f1 f2 f3, vert ylab(-.25(.25).75) yline(0) ///
	legend(off) xlab(.75 `""Democrat vs. Republican" "(No Issues)"' 1 `""Moderate Democrat vs." "Moderate Republican"' 1.25 `""Difference-in-" "Differences"', labsize(vsmall)) ///
	saving(figure6b.gph, replace)
graph combine figure6a.gph figure6b.gph, cols(1) subtitle("Figure 6. Ideological Information Drives Trait Perceptions of Partisans")


*results among democrats
xtreg traitindex i.cond i.vignette if PID<4, fe vce(cluster ID)
lincomest 4.cond-8.cond /* party cue only */
est store d1
xtreg traitindex i.cond i.vignette if PID<4, fe vce(cluster ID)
lincomest 3.cond-9.cond /* ideology, no party */
est store d2
xtreg traitindex i.cond i.vignette if PID<4, fe vce(cluster ID)
lincomest 2.cond-10.cond /* extreme partisans */
est store d3
xtreg traitindex i.cond i.vignette if PID<4, fe vce(cluster ID)
lincomest (2.cond-10.cond)-(3.cond-9.cond) /* remaining effect */
est store d4
xtreg traitindex i.cond i.vignette if PID<4, fe vce(cluster ID)
lincomest 5.cond-7.cond /* moderate partisans */
est store d5
xtreg traitindex i.cond i.vignette if PID<4, fe vce(cluster ID)
lincomest (4.cond-8.cond)-(5.cond-7.cond) /* eliminated effect */
est store d6

*results among republicans
xtreg traitindex i.cond i.vignette if PID>4, fe vce(cluster ID)
lincomest 4.cond-8.cond /* party cue only */
est store r1
xtreg traitindex i.cond i.vignette if PID>4, fe vce(cluster ID)
lincomest 3.cond-9.cond /* ideology, no party */
est store r2
xtreg traitindex i.cond i.vignette if PID>4, fe vce(cluster ID)
lincomest 2.cond-10.cond /* extreme partisans */
est store r3
xtreg traitindex i.cond i.vignette if PID>4, fe vce(cluster ID)
lincomest (2.cond-10.cond)-(3.cond-9.cond) /* remaining effect */
est store r4
xtreg traitindex i.cond i.vignette if PID>4, fe vce(cluster ID)
lincomest 5.cond-7.cond /* moderate partisans */
est store r5
xtreg traitindex i.cond i.vignette if PID>4, fe vce(cluster ID)
lincomest (4.cond-8.cond)-(5.cond-7.cond) /* eliminated effect */
est store r6

*results among low knowledge
xtreg traitindex i.cond i.vignette if knowl3==1, fe vce(cluster ID)
lincomest 4.cond-8.cond /* party cue only */
est store lk1
xtreg traitindex i.cond i.vignette if knowl3==1, fe vce(cluster ID)
lincomest 3.cond-9.cond /* ideology, no party */
est store lk2
xtreg traitindex i.cond i.vignette if knowl3==1, fe vce(cluster ID)
lincomest 2.cond-10.cond /* extreme partisans */
est store lk3
xtreg traitindex i.cond i.vignette if knowl3==1, fe vce(cluster ID)
lincomest (2.cond-10.cond)-(3.cond-9.cond) /* remaining effect */
est store lk4
xtreg traitindex i.cond i.vignette if knowl3==1, fe vce(cluster ID)
lincomest 5.cond-7.cond /* moderate partisans */
est store lk5
xtreg traitindex i.cond i.vignette if knowl3==1, fe vce(cluster ID)
lincomest (4.cond-8.cond)-(5.cond-7.cond) /* eliminated effect */
est store lk6

*results among high knowledge
xtreg traitindex i.cond i.vignette if knowl3==3, fe vce(cluster ID)
lincomest 4.cond-8.cond /* party cue only */
est store hk1
xtreg traitindex i.cond i.vignette if knowl3==3, fe vce(cluster ID)
lincomest 3.cond-9.cond /* ideology, no party */
est store hk2
xtreg traitindex i.cond i.vignette if knowl3==3, fe vce(cluster ID)
lincomest 2.cond-10.cond /* extreme partisans */
est store hk3
xtreg traitindex i.cond i.vignette if knowl3==3, fe vce(cluster ID)
lincomest (2.cond-10.cond)-(3.cond-9.cond) /* remaining effect */
est store hk4
xtreg traitindex i.cond i.vignette if knowl3==3, fe vce(cluster ID)
lincomest 5.cond-7.cond /* moderate partisans */
est store hk5
xtreg traitindex i.cond i.vignette if knowl3==3, fe vce(cluster ID)
lincomest (4.cond-8.cond)-(5.cond-7.cond) /* eliminated effect */
est store hk6

*figure 7
coefplot d1 d2 d3 d5, vert ylab(-.5(.5)2) yline(0) ///
	legend(off) xlab(.7 `""D vs. R" "(No Issues)"' .9 `""L vs. C" "(No Parties)"' 1.1 "LD vs. CR" 1.3 "MD vs. MR", ///
	labsize(vsmall)) saving(dpanel.gph, replace) subtitle("Democrats")
coefplot r1 r2 r3 r5, vert ylab(-.5(.5)2) yline(0) ///
	legend(off) xlab(.7 `""D vs. R" "(No Issues)"' .9 `""L vs. C" "(No Parties)"' 1.1 "LD vs. CR" 1.3 "MD vs. MR", ///
	labsize(vsmall)) saving(rpanel.gph, replace) subtitle("Republicans")
coefplot lk1 lk2 lk3 lk5, vert ylab(-.5(.5)2) yline(0) ///
	legend(off) xlab(.7 `""D vs. R" "(No Issues)"' .9 `""L vs. C" "(No Parties)"' 1.1 "LD vs. CR" 1.3 "MD vs. MR", ///
	labsize(vsmall)) saving(lkpanel.gph, replace) subtitle("Low Sophistication")
coefplot hk1 hk2 hk3 hk5, vert ylab(-.5(.5)2) yline(0) ///
	legend(off) xlab(.7 `""D vs. R" "(No Issues)"' .9 `""L vs. C" "(No Parties)"' 1.1 "LD vs. CR" 1.3 "MD vs. MR", ///
	labsize(vsmall)) saving(hkpanel.gph, replace) subtitle("High Sophistication")
graph combine dpanel.gph rpanel.gph lkpanel.gph hkpanel.gph, subtitle("Figure 7. Treatment Effects by Respondent Sophistication and Partisanship") ///
	note("Note: D=Democrat, R=Republican, L=Liberal, C=Conservative, M=Moderate. Low sophistication = bottom tercile. High sophistication = top tercile.", size(vsmall))

*full test of political knowledge interactions
xtreg traitindex i.cond##c.knowlatent i.vignette, re vce(cluster ID)

