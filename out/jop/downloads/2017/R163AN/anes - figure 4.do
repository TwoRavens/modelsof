clear
cd "/Users/michelemargolis/Dropbox/Life cycle paper/JOP submission/Replication files/ANES 00 02 04/"
use "anes00-02-04.dta"

**2000-2002
local first00 age agesq female hs somecoll coll grad i.inc00 i.unemployed00 ne west mid white black hispanic
local second00 catholic jew main ba mod_00 cons_00
local third00 homo00 abortion00 econ00 jobs00 feminist00

preserve
		gen y_rep= .
		gen se_rep= .
xi: reg attend02 i.pid3_00 i.attend00 i.married00 i.children `first00' `second00' `third00' [aw=WT04]
		mat B = r(table)
		replace y_rep = B[1,2] 
		replace se_rep = B[2,2] 
	    test  _Ipid3_00_3=  _Ipid3_00_2
collapse y* se_*, by(X)
save "/Users/michelemargolis/Desktop/temp/full_church_0002.dta", replace
restore



preserve
		gen y_rep= .
		gen se_rep= .
xi: reg attend02 i.pid3_00 i.attend00 `first00' `second00' `third00' if kids==1 [aw=WT04]
		mat B = r(table)
		replace y_rep = B[1,2] 
		replace se_rep = B[2,2] 
	    test  _Ipid3_00_3=  _Ipid3_00_2
collapse y* se_*, by(X)
save "/Users/michelemargolis/Desktop/temp/kids_church_0002.dta", replace
restore


preserve
		gen y_rep= .
		gen se_rep= .
xi: reg attend02 i.pid3_00 i.attend00 `first00' `second00' `third00' if grown==1 [aw=WT04]
		mat B = r(table)
		replace y_rep = B[1,2] 
		replace se_rep = B[2,2] 
	    test  _Ipid3_00_3=  _Ipid3_00_2
collapse y* se_*, by(X)
save "/Users/michelemargolis/Desktop/temp/grown_church_0002.dta", replace
restore



***2002-2004

local first02 age agesq female hs somecoll coll grad i.income02 unemployed02 ne west mid white black hispanic
local second02 catholic main ba mod_02 cons_02
local third02 homo02 abortion00 econ02 jobs02 feminist02 iraq02

preserve
		gen y_rep= .
		gen se_rep= .
xi: reg attend04 i.pid3_02 i.attend02 i.married00 i.children `first02' `second02' `third02'  [aw=WT04]
		mat B = r(table)
		replace y_rep = B[1,2] 
		replace se_rep = B[2,2] 
	    test  _Ipid3_02_3=  _Ipid3_02_2
collapse y* se_*, by(X)
save "/Users/michelemargolis/Desktop/temp/full_church_0204.dta", replace
restore



preserve
		gen y_rep= .
		gen se_rep= .
xi: reg attend04 i.pid3_02 i.attend02 `first02' `second02' `third02' if kids==1  [aw=WT04]
		mat B = r(table)
		replace y_rep = B[1,2] 
		replace se_rep = B[2,2] 
	    test  _Ipid3_02_3=  _Ipid3_02_2
collapse y* se_*, by(X)
save "/Users/michelemargolis/Desktop/temp/kids_church_0204.dta", replace
restore


preserve
		gen y_rep= .
		gen se_rep= .
xi: reg attend04 i.pid3_02 i.attend02 `first02' `second02' `third02' if grown==1  [aw=WT04]
		mat B = r(table)
		replace y_rep = B[1,2] 
		replace se_rep = B[2,2] 
	    test  _Ipid3_02_3=  _Ipid3_02_2
collapse y* se_*, by(X)
save "/Users/michelemargolis/Desktop/temp/grown_church_0204.dta", replace
restore



clear
use "/Users/michelemargolis/Desktop/temp/grown_church_0204.dta"
append using "/Users/michelemargolis/Desktop/temp/grown_church_0002.dta"
append using "/Users/michelemargolis/Desktop/temp/kids_church_0204.dta"
append using "/Users/michelemargolis/Desktop/temp/kids_church_0002.dta"
append using "/Users/michelemargolis/Desktop/temp/full_church_0204.dta"
append using "/Users/michelemargolis/Desktop/temp/full_church_0002.dta"
cd "~/Dropbox/Life cycle paper/"

g dv = _n

foreach i in rep{
g lb_`i' = y_`i'-(1.64*se_`i')
g ub_`i' = y_`i'+(1.64*se_`i')
}

replace dv=1.75 if dv==2
replace dv=3.75 if dv==4
replace dv=5.75 if dv==6

gr tw (scatter dv y_rep if dv==1.75 | dv==3.75 | dv==5.75, col(black) msymbol(circle)) (rcap lb_rep ub_rep dv if dv==1.75 | dv==3.75 | dv==5.75, hor col(black) lpattern(dash) lwidth(medthick)) ///
(scatter dv y_rep if dv==1 | dv==3 | dv==5, col(gs9) msymbol(square)) (rcap lb_rep ub_rep dv if dv==1 | dv==3 | dv==5, hor col(gs9) lpattern(solid) lwidth(medthick)) ///
(pcarrowi 0.15 0.05 0.15 0.25) (pcarrowi 0.15 -0.05 0.15 -0.25),  ///
ylabel(none) xlabel(none) title() legend(off) ///
xlabel(-0.3(0.10)0.3, nogrid labsize(medium)) scheme(lean1) ///
xscale(range(-0.3, 0.3)) yscale(range(0, 6)) ///
ytitle("") xline(0, lpattern(dot) lcol(gs6) lwidth(thick)) ///
text(0.35 -0.15 "Less religious", size(medium))  text(0.35 0.15 "More religious", size(medium)) ///
text(5.375 -0.2 "Full sample", size(medium)) text(3.375 -0.2 "Children at home", size(medium)) text(1.375 -0.2 "Grown children", size(medium)) ///
text(5.75 0.2 "2000-2002", size(medium)) text(5 0.2 "2002-2004", size(medium)) ///
xtitle("Republican church attendance change relative to Democrats", size(medium)) 
*gr export "JOP submission/RandR/Main/anes-results.pdf", replace




