* Analysis file for Wells and Ryan, “Following the Party in Time of War?” The Implications of Elite Consensus” (published in International Interactions).

* Set working directory

* Figure 1
use "datafile_main.dta"
reg casscale american##unifcond if independent==0, robust
margins, dydx(american) at(unifcond=(0 1))
marginsplot, level(84) yline(0) xlab(0 "Fractured" 1 "Unified") ///
	xsc(r(-.25 1.25)) ysc(r(-.2 .2)) ylab(-.2(.1).2) ytitle("") xtitle("Status of Elites") ///
	title("Partisans (N=373)") ytitle("Opposition to War") ///
	plotopts(connect(none)) graphregion(color(white)) recastci(rspike)
graph save "op_partisan.gph", replace
	
reg casscale american##unifcond if independent==1, robust
margins, dydx(american) at(unifcond=(0 1))
marginsplot, level(84) yline(0) xlab(0 "Fractured" 1 "Unified") ///
	xsc(r(-.25 1.25)) ysc(r(-.2 .2)) ylab(-.2(.1).2) ytitle("") xtitle("Status of Elites") ///
	title("Independents (N=165)") ///
	plotopts(connect(none)) graphregion(color(white)) recastci(rspike)
graph save "op_independ.gph", replace

graph combine "op_partisan.gph" "op_independ.gph", title("") rows(1) graphregion(color(white))
graph export "opposition.png", replace width(1000)


* Figure 2
use "datafile_main.dta"
reg obama american##unifcond if independent==0, robust
margins, dydx(american) at(unifcond=(0 1))
marginsplot, level(84) yline(0) xlab(0 "Fractured" 1 "Unified") ///
	xsc(r(-.25 1.25)) ysc(r(-.2 .2)) ylab(-.2(.1).2) ytitle("") xtitle("Status of Elites") ///
	title("Partisans (N=373)") ytitle("Support for Obama") ///
	plotopts(connect(none)) graphregion(color(white)) recastci(rspike)
graph save "ob_partisan.gph", replace
	
reg obama american if independent==1, robust
reg obama american##unifcond if independent==1, robust
margins, dydx(american) at(unifcond=(0 1))
marginsplot, level(84) yline(0) xlab(0 "Fractured" 1 "Unified") ///
	xsc(r(-.25 1.25)) ysc(r(-.2 .2)) ylab(-.2(.1).2) ytitle("") xtitle("Status of Elites") ///
	title("Independents (N=165)") ///
	plotopts(connect(none)) graphregion(color(white)) recastci(rspike)
graph save "ob_independ.gph", replace
graph combine "ob_partisan.gph" "ob_independ.gph", title("") rows(1) graphregion(color(white))
graph save "obama.gph", replace

reg hypoth american##unifcond if independent==0, robust
margins, dydx(american) at(unifcond=(0 1))
marginsplot, level(84) yline(0) xlab(0 "Fractured" 1 "Unified") ///
	xsc(r(-.25 1.25)) ysc(r(-.2 .2)) ylab(-.2(.1).2) ytitle("") xtitle("Status of Elites") ///
	title("Partisans (N=369)") ytitle("Support for Hypothetical Candidate") ///
	plotopts(connect(none)) graphregion(color(white)) recastci(rspike)
graph save "hy_partisan.gph", replace
	
reg hypoth american if independent==1, robust
reg hypoth american##unifcond if independent==1, robust
margins, dydx(american) at(unifcond=(0 1))
marginsplot, level(84) yline(0) xlab(0 "Fractured" 1 "Unified") ///
	xsc(r(-.25 1.25)) ysc(r(-.2 .2)) ylab(-.2(.1).2) ytitle("") xtitle("Status of Elites") ///
	title("Independents (N=165)") ///
	plotopts(connect(none)) graphregion(color(white)) recastci(rspike)
graph save "hy_independ.gph", replace
graph combine "hy_partisan.gph" "hy_independ.gph", title("") rows(1) graphregion(color(white))
graph save "hypoth.gph", replace
graph combine "obama.gph" "hypoth.gph", ///
	graphregion(color(white)) rows(2) xsize(6) ysize(7)
graph export "votes.png", replace width(1000)


* Supporting Information, Table 1
cd "/Users/TJRyan/Dropbox/Casualties/data/Fractured Elites Replication Files" // Take this out
use "datafile_main.dta"
tab race
tab educ
tab female
tab agebin // The eleven respondents below the age of 20 are excluded from this table for clear comparisons with the Census benchmark


* Supporting Information, Table 2
use "datafile_main.dta"
factor cas0 cas1 cas2 cas3 cas4 success*, mineigen(1)
rotate, oblimin oblique blank(.1)

* Supporting Information, Table 3
use "datafile_main.dta"
corr cas0 cas1 cas2 cas3 cas4 success*

* Supporting Information, Table 4
use "datafile_main.dta"
reg sucscale american if independent==0
reg sucscale american if independent==0 & unifcond==1
reg sucscale american if independent==0 & unifcond==0
reg sucscale american##unifcond if independent==0 // examine p-value on interaction term

reg sucscale american if independent==1
reg sucscale american if independent==1 & unifcond==1
reg sucscale american if independent==1 & unifcond==0
reg sucscale american##unifcond if independent==1 // examine p-value on interaction term

* Supporting Information, Table 5
use "datafile_instrumentation.dta"
reg casscale american if vivlev==1 | vivlev==2
reg casscale american if vivlev==1
reg casscale american if vivlev==2

* Supporting Information, Table 6
use "datafile_main.dta"
reg unified unifcond

* Supporting Information, Table 7
use "datafile_main.dta"
reg casscale american if independent==0
reg casscale american if independent==0 & unifcond==1
reg casscale american if independent==0 & unifcond==0
reg casscale american##unifcond if independent==0 // examine p-value on interaction term

reg casscale american if independent==1
reg casscale american if independent==1 & unifcond==1
reg casscale american if independent==1 & unifcond==0
reg casscale american##unifcond if independent==1 // examine p-value on interaction term

* Supporting Information, Table 8
use "datafile_main.dta"
reg obama american if independent==0
reg obama american if independent==0 & unifcond==1
reg obama american if independent==0 & unifcond==0
reg obama american##unifcond if independent==0 // examine p-value on interaction term

reg obama american if independent==1
reg obama american if independent==1 & unifcond==1
reg obama american if independent==1 & unifcond==0
reg obama american##unifcond if independent==1 // examine p-value on interaction term

* Supporting Information, Table 9
use "datafile_main.dta"
reg casscale american if democrat==1
reg casscale american if democrat==1 & unifcond==1
reg casscale american if democrat==1 & unifcond==0
reg casscale american##unifcond if democrat==1 // examine p-value on interaction term

reg casscale american if republican==1
reg casscale american if republican==1 & unifcond==1
reg casscale american if republican==1 & unifcond==0
reg casscale american##unifcond if republican==1 // examine p-value on interaction term

* Supporting Information, Table 10
use "datafile_main.dta"
reg obama american if democrat==1
reg obama american if democrat==1 & unifcond==1
reg obama american if democrat==1 & unifcond==0
reg obama american##unifcond if democrat==1 // examine p-value on interaction term

reg obama american if republican==1
reg obama american if republican==1 & unifcond==1
reg obama american if republican==1 & unifcond==0
reg obama american##unifcond if republican==1 // examine p-value on interaction term

reg hypoth american if democrat==1
reg hypoth american if democrat==1 & unifcond==1
reg hypoth american if democrat==1 & unifcond==0
reg hypoth american##unifcond if democrat==1 // examine p-value on interaction term

reg hypoth american if republican==1
reg hypoth american if republican==1 & unifcond==1
reg hypoth american if republican==1 & unifcond==0
reg hypoth american##unifcond if republican==1 // examine p-value on interaction term

* Supporting Information, Table 11
use "datafile_main.dta"
reg casscale american if independent_alt==0
reg casscale american if independent_alt==0 & unifcond==1
reg casscale american if independent_alt==0 & unifcond==0
reg casscale american##unifcond if independent_alt==0 // examine p-value on interaction term

reg casscale american if independent_alt==1
reg casscale american if independent_alt==1 & unifcond==1
reg casscale american if independent_alt==1 & unifcond==0
reg casscale american##unifcond if independent_alt==1 // examine p-value on interaction term

* Supporting Information, Table 12
use "datafile_main.dta"
reg obama american if independent_alt==0
reg obama american if independent_alt==0 & unifcond==1
reg obama american if independent_alt==0 & unifcond==0
reg obama american##unifcond if independent_alt==0 // examine p-value on interaction term

reg obama american if independent_alt==1
reg obama american if independent_alt==1 & unifcond==1
reg obama american if independent_alt==1 & unifcond==0
reg obama american##unifcond if independent_alt==1 // examine p-value on interaction term

reg hypoth american if independent_alt==0
reg hypoth american if independent_alt==0 & unifcond==1
reg hypoth american if independent_alt==0 & unifcond==0
reg hypoth american##unifcond if independent_alt==0 // examine p-value on interaction term

reg hypoth american if independent_alt==1
reg hypoth american if independent_alt==1 & unifcond==1
reg hypoth american if independent_alt==1 & unifcond==0
reg hypoth american##unifcond if independent_alt==1 // examine p-value on interaction term

