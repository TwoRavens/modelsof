set more off
clear all

* Produces:
	* Figure 2 close elections RD panel
	* Panel A of Appendix Tables A3, A4, A5
	* Appendix Tables A6, A7, A9, A10, A11, A12
	* Appendix Figures A3, A5, A6, A8

* User written commands used
* ssc install unique
* ssc install estout
* net install st0366.pkg *rdbwselect (st0366) 
	* ado uninstall st0366.pkg
	* net install st0366.pkg, replace
* ssc install grc1leg
* DCdensity available here: https://eml.berkeley.edu/~jmccrary/DCdensity/	

****************************************************
* FIGURE 2 TOP LEFT PANEL, APPENDIX TABLE A3 PANEL A,  
* FIGURE A8 TOP LEFT PANEL: DOCTOR ASSIGNMENT
****************************************************
	
clear all
set seed 83457
set maxvar 14000

* Load randomization inference program
do "rinf.do"

foreach x in mo {
	
* outcome
global outcome `x'_assigned
local iterations = 1000

est clear
use disc_final.dta, clear

* IK bw selection
collapse (mean) $outcome (firstnm) vm, by(consid)
	qui rdbwselect $outcome vm, bwselect(IK)
	local IK_bw = e(h_IK)
	di `IK_bw'
	local IK_bw100 = `IK_bw'/100

* Computation of exact p-values
use disc_final.dta, clear

	*first for the regular bws
forvalues bw=10(5)25 {
	rinf, dv($outcome) bw(`bw') iter(`iterations') condition(" ")  condition1(" ")
	if `bw' == 10 {
	mat p = `r(pexact`bw')'
	mat ci = r(CI`bw')
		}
	else { 
	mat p = p \ `r(pexact`bw')'
	mat ci = ci \ r(CI`bw')
		}
	}

	* next for IK bw
	rinf, dv($outcome) bw(`IK_bw') iter(`iterations') condition(" ") condition1(" ")
	local absbw = int(`IK_bw')
	mat p = p \ `r(pexact`absbw')'
	mat ci = ci \ r(CI`absbw')
	
matlist p
matlist ci

est clear
use disc_final.dta, clear

mat ci_reg = J(5,3,.)

forvalues bw=10(5)25 {
	eststo: areg $outcome pml_winner vm pvm i_wave* [pw=w`bw'], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		capture estadd scalar pexact= p[(`bw'/5)-1,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		preserve
			keep if e(sample) == 1
			duplicates drop hmis, force
			count
			estadd scalar nclinics = r(N)
		restore
		
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		if `bw' == 10 {
			mat ci_reg = X
			}
		else {
			mat ci_reg = ci_reg \ X
			}
}

	g wIK=max(0,`IK_bw'-abs(vm)) if abs(vm)<=`IK_bw'
	eststo: areg $outcome pml_winner vm pvm i_wave* [pw=wIK], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		capture estadd scalar pexact= p[5,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		preserve
			keep if e(sample) == 1
			duplicates drop hmis, force
			count
			estadd scalar nclinics = r(N)
		restore
		
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		mat ci_reg = ci_reg \ X
	
local IK_bw = round(`IK_bw', 0.01)			
local IK_bw100 = round(`IK_bw100', 0.0001)

svmat p
replace p1 = round(p1, 0.01)
format p1 %6.3f

if `IK_bw100' <0.1 {
estout est5 est1 est2 est3 est4 using ./interim_output/assigned_`x'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Assigned") mlabels("IK=`IK_bw100'" "0.1" "15" "20" "25" )
}

if `IK_bw100' >=0.1 & `IK_bw100' <0.15 {
estout est1 est5 est2 est3 est4 using ./interim_output/assigned_`x'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Assigned") mlabels("0.1" "IK=`IK_bw100'" "15" "20" "25" )
}

if `IK_bw100' >=0.15 & `IK_bw100' <0.2 {
estout est1 est2 est5 est3 est4 using ./interim_output/assigned_`x'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Assigned") mlabels("0.1" "15" "IK=`IK_bw100'" "20" "25" )
}

if `IK_bw100' >=0.2 & `IK_bw100' <0.25 {
estout est1 est2 est3 est5 est4 using ./interim_output/assigned_`x'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Assigned") mlabels("0.1" "15" "20" "IK=`IK_bw100'" "25" )
}

if `IK_bw100' >=0.25 {
estout est1 est2 est3 est4 est5 using ./interim_output/assigned_`x'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Assigned") mlabels("0.1" "15" "20" "25" "IK=`IK_bw100'")
}

* Graph
svmat ci_reg
forvalues j =1/4 {
	capture gen bandwidth= (_n * 5 + 5)/100 in `j'
	replace bandwidth= (_n * 5 + 5)/100 in `j'
	}
replace bandwidth = `IK_bw100' in 5

	twoway (dot ci_reg2 bandwidth, ndots(0) mcolor(maroon) msymbol(X) msize(large)) || (rcap ci_reg1 ci_reg3 bandwidth, lcolor(gs8)) , ///
		xtitle("Margin of Victory Bandwidth", size(vsmall)) ///
		xlabel(`IK_bw100' "IK=0`IK_bw100'" 0.1 "0.1" 0.15 "0.15" 0.2 "0.20" 0.25 "0.25" , labsize(vsmall) angle(vertical)) ///
		ylabel(, labsize(vsmall)) yline(0, lcolor(gs13)) aspectratio(0.6) ///
		ytitle("Treatment Effect", size(vsmall)) name(assigned, replace) scheme(s1color) ///
		legend(label(1 "Treatment Effect") label(2 "95% CI") region(lwidth(none)) size(small)) ///
		title("Doctor Assigned" , size(small))
	
	graph save "./figures/coef/assignedbybwreg_`x'.gph", replace
	graph export "./figures/coef/assignedbybwreg_`x'.pdf", as(pdf) replace
	
* Graph RI
svmat ci

forvalues j =1/4 {
	capture gen bandwidth= (_n * 5 + 5)/100 in `j'
	replace bandwidth= (_n * 5 + 5)/100 in `j'
	}
replace bandwidth = `IK_bw100' in 5

	twoway (dot ci2 bandwidth, ndots(0) mcolor(maroon) msymbol(X) msize(large)) || (rcap ci1 ci3 bandwidth, lcolor(gs8)) , ///
		xtitle("Margin of Victory Bandwidth", size(vsmall)) ///
		xlabel(`IK_bw100' "IK=0`IK_bw100'" 0.1 "0.1" 0.15 "0.15" 0.2 "0.20" 0.25 "0.25" , labsize(vsmall) angle(vertical)) ///
		ylabel(, labsize(vsmall)) yline(0, lcolor(gs13)) aspectratio(0.6) ///
		ytitle("Treatment Effect", size(vsmall)) name(assigned, replace) scheme(s1color) ///
		legend(label(1 "Treatment Effect") label(2 "90% Exact CI") region(lwidth(none)) size(small)) ///
		title("Doctor Assigned" , size(small))
	
	graph save "./figures/coef/assignedbybw_`x'.gph", replace
	graph export "./figures/coef/assignedbybw_`x'.pdf", as(pdf) replace
	
}


*********************************************************
* Figure 2 top RIGHT panel, Appenix Table A4 Panel A, and 
* Figure A8 top right panel: DOCTOR ATTENDANCE
*********************************************************	
	
clear all
set seed 83457
set maxvar 14000

* Load randomization inference program
do "rinf.do"

foreach x in mo {
	
* Connections
global outcome `x'_present_uc
local iterations = 1000

est clear
use disc_final.dta, clear

* IK bw selection
collapse (mean) $outcome (firstnm) vm, by(consid)
	qui rdbwselect $outcome vm, bwselect(IK)
	local IK_bw = e(h_IK)
	di `IK_bw'
	local IK_bw100 = `IK_bw'/100

* Computation of exact p-values
use disc_final.dta, clear

	*first for the regular bws
forvalues bw=10(5)25 {
	rinf, dv($outcome) bw(`bw') iter(`iterations') condition(" ") condition1(" ")
	if `bw' == 10 {
	mat p = `r(pexact`bw')'
	mat ci = r(CI`bw')
		}
	else { 
	mat p = p \ `r(pexact`bw')'
	mat ci = ci \ r(CI`bw')
		}
	}

	* next for IK bw
	rinf, dv($outcome) bw(`IK_bw') iter(`iterations') condition(" ") condition1(" ")
	local absbw = int(`IK_bw')
	mat p = p \ `r(pexact`absbw')'
	mat ci = ci \ r(CI`absbw')
	
matlist p
matlist ci

est clear
use disc_final.dta, clear

mat ci_reg = J(5,3,.)

forvalues bw=10(5)25 {
	eststo: areg $outcome pml_winner vm pvm i_wave* [pw=w`bw'], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		capture estadd scalar pexact= p[(`bw'/5)-1,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		preserve
			keep if e(sample) == 1
			duplicates drop hmis, force
			count
			estadd scalar nclinics = r(N)
		restore

		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		if `bw' == 10 {
			mat ci_reg = X
			}
		else {
			mat ci_reg = ci_reg \ X
			}
	}

	g wIK=max(0,`IK_bw'-abs(vm)) if abs(vm)<=`IK_bw'
	eststo: areg $outcome pml_winner vm pvm i_wave* [pw=wIK], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		capture estadd scalar pexact= p[5,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		preserve
			keep if e(sample) == 1
			duplicates drop hmis, force
			count
			estadd scalar nclinics = r(N)
		restore

		
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		mat ci_reg = ci_reg \ X
	
local IK_bw = round(`IK_bw', 0.01)			
local IK_bw100 = round(`IK_bw100', 0.0001)

svmat p
replace p1 = round(p1, 0.01)
format p1 %6.3f

if `IK_bw100' <0.1 {
estout est5 est1 est2 est3 est4 using ./interim_output/attend_`x'_uc.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Attendance") mlabels("IK=`IK_bw100'" "0.1" "15" "20" "25" )
}

if `IK_bw100' >=0.1 & `IK_bw100' <0.15 {
estout est1 est5 est2 est3 est4 using ./interim_output/attend_`x'_uc.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Attendance") mlabels("0.1" "IK=`IK_bw100'" "15" "20" "25" )
}

if `IK_bw100' >=0.15 & `IK_bw100' <0.2 {
estout est1 est2 est5 est3 est4 using ./interim_output/attend_`x'_uc.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Attendance") mlabels("0.1" "15" "IK=`IK_bw100'" "20" "25" )
}

if `IK_bw100' >=0.2 & `IK_bw100' <0.25 {
estout est1 est2 est3 est5 est4 using ./interim_output/attend_`x'_uc.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Attendance") mlabels("0.1" "15" "20" "IK=`IK_bw100'" "25" )
}

if `IK_bw100' >=0.25 {
estout est1 est2 est3 est4 est5 using ./interim_output/attend_`x'_uc.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Attendance") mlabels("0.1" "15" "20" "25" "IK=`IK_bw100'")
}

* Graph
svmat ci_reg
forvalues j =1/4 {
	capture gen bandwidth= (_n * 5 + 5)/100 in `j'
	replace bandwidth= (_n * 5 + 5)/100 in `j'
	}
replace bandwidth = `IK_bw100' in 5

	twoway (dot ci_reg2 bandwidth, ndots(0) mcolor(maroon) msymbol(X) msize(large)) || (rcap ci_reg1 ci_reg3 bandwidth, lcolor(gs8)) , ///
		xtitle("Margin of Victory Bandwidth", size(vsmall)) ///
		xlabel(`IK_bw100' "IK=0`IK_bw100'" 0.1 "0.1" 0.15 "0.15" 0.2 "0.20" 0.25 "0.25" , labsize(vsmall) angle(vertical)) ///
		ylabel(, labsize(vsmall)) yline(0, lcolor(gs13)) aspectratio(0.6) ///
		ytitle("Treatment Effect", size(vsmall)) name(attendance, replace) scheme(s1color) ///
		legend(label(1 "Treatment Effect") label(2 "95% CI") region(lwidth(none)) size(small)) ///
		title("Doctor Attendance" , size(small))
	
	graph save "./figures/coef/attendbybwreg_`x'_uc.gph", replace
	graph export "./figures/coef/attendbybwreg_`x'_uc.pdf", as(pdf) replace

* Graph RI
svmat ci

forvalues j =1/4 {
	capture gen bandwidth= (_n * 5 + 5)/100 in `j'
	replace bandwidth= (_n * 5 + 5)/100 in `j'
	}
replace bandwidth = `IK_bw100' in 5

	twoway (dot ci2 bandwidth, ndots(0) mcolor(maroon) msymbol(X) msize(large)) || (rcap ci1 ci3 bandwidth, lcolor(gs8)) , ///
		xtitle("Margin of Victory Bandwidth", size(vsmall)) ///
		xlabel(`IK_bw100' "IK=0`IK_bw100'" 0.1 "0.1" 0.15 "0.15" 0.2 "0.20" 0.25 "0.25" , labsize(vsmall) angle(vertical)) ///
		ylabel(, labsize(vsmall)) yline(0, lcolor(gs13)) aspectratio(0.6) ///
		ytitle("Treatment Effect", size(vsmall)) name(attendance, replace) scheme(s1color) ///
		legend(label(1 "Treatment Effect") label(2 "90% Exact CI") region(lwidth(none)) size(small)) ///
		title("Doctor Attendance" , size(small))
	
	graph save "./figures/coef/attendbybw_`x'_uc.gph", replace
	graph export "./figures/coef/attendbybw_`x'_uc.pdf", as(pdf) replace

}

		
************************************************
* FIGURE A2: PML-N VICTORY MARGIN BY VOTE SHARE
***********************************************
use disc_final.dta, clear

replace vm = vm/100

* graph
twoway scatter vm vsPML_N08,  mcolor(gs12) ///
|| function y = x*2-1, lcolor(red)  ///
, xlabel(0(0.1)1) ylabel(-.5(.50).5) scheme(S1color) ///
yline(0, lcolor(red)) legend(off) xtitle(PML(N) Vote Share 2008) ///
ytitle(PML(N) Victory Margin 2008)

graph export "figures/vs_vm.pdf", as(pdf) replace	
	
************************************************
* TABLE A6: ARE DOCTORS SENT TO MARGINAL AREAS?
************************************************
	
* PANEL A OF TABLE A6	
clear all
set seed 83457
set maxvar 14000

* Load randomization inference program
do "rinf.do"

global outcome distancehq
local iterations = 1000

est clear
use disc_final.dta, clear
keep if mo_assigned==1

* IK bw selection
collapse (mean) $outcome (firstnm) vm, by(consid)
	qui rdbwselect $outcome vm, bwselect(IK)
	local IK_bw = e(h_IK)
	di `IK_bw'
	local IK_bw100 = `IK_bw'/100

* Computation of exact p-values
use disc_final.dta, clear

	*first for the regular bws
forvalues bw=10(5)25 {
	rinf, dv($outcome) bw(`bw') iter(`iterations') condition("keep if mo_assigned==1") condition1(" ")
	if `bw' == 10 {
	mat p = `r(pexact`bw')'
	mat ci = r(CI`bw')
		}
	else { 
	mat p = p \ `r(pexact`bw')'
	mat ci = ci \ r(CI`bw')
		}
	}

	* next for IK bw
	rinf, dv($outcome) bw(`IK_bw') iter(`iterations') condition("keep if mo_assigned==1") condition1(" ")
	local absbw = int(`IK_bw')
	mat p = p \ `r(pexact`absbw')'
	mat ci = ci \ r(CI`absbw')
	
matlist p
matlist ci

est clear
use disc_final.dta, clear
keep if mo_assigned==1

mat ci_reg = J(5,3,.)

forvalues bw=10(5)25 {
	eststo: areg $outcome pml_winner vm pvm i_wave* [pw=w`bw'], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		capture estadd scalar pexact= p[(`bw'/5)-1,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		preserve
			keep if e(sample) == 1
			duplicates drop hmis, force
			count
			estadd scalar nclinics = r(N)
		restore
	
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		if `bw' == 10 {
			mat ci_reg = X
			}
		else {
			mat ci_reg = ci_reg \ X
			}
	}

	g wIK=max(0,`IK_bw'-abs(vm)) if abs(vm)<=`IK_bw'
	eststo: areg $outcome pml_winner vm pvm i_wave* [pw=wIK], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		capture estadd scalar pexact= p[5,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		preserve
			keep if e(sample) == 1
			duplicates drop hmis, force
			count
			estadd scalar nclinics = r(N)
		restore
	
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		mat ci_reg = ci_reg \ X
	
local IK_bw = round(`IK_bw', 0.01)			
local IK_bw100 = round(`IK_bw100', 0.0001)

svmat p
replace p1 = round(p1, 0.01)
format p1 %6.3f

if `IK_bw100' <0.1 {
estout est5 est1 est2 est3 est4 using ./interim_output/distancehq.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Distance to District HQ") mlabels("IK=`IK_bw100'" "0.1" "15" "20" "25" )
}

if `IK_bw100' >=0.1 & `IK_bw100' <0.15 {
estout est1 est5 est2 est3 est4 using ./interim_output/distancehq.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Distance to District HQ") mlabels("0.1" "IK=`IK_bw100'" "15" "20" "25" )
}

if `IK_bw100' >=0.15 & `IK_bw100' <0.2 {
estout est1 est2 est5 est3 est4 using ./interim_output/distancehq.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Distance to District HQ") mlabels("0.1" "15" "IK=`IK_bw100'" "20" "25" )
}

if `IK_bw100' >=0.2 & `IK_bw100' <0.25 {
estout est1 est2 est3 est5 est4 using ./interim_output/distancehq.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Distance to District HQ") mlabels("0.1" "15" "20" "IK=`IK_bw100'" "25" )
}

if `IK_bw100' >=0.25 {
estout est1 est2 est3 est4 est5 using ./interim_output/distancehq.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Distance to District HQ") mlabels("0.1" "15" "20" "25" "IK=`IK_bw100'")
}

* PANEL B OF TABLE A6
clear all
set seed 83457
set maxvar 14000

* Load randomization inference program
do "rinf.do"

* Distance to Doctor's Hometown
global outcome mo_dist_hometown	
local iterations = 1000

est clear
use disc_final.dta, clear
keep if mo_assigned==1

* IK bw selection
collapse (mean) $outcome (firstnm) vm, by(consid)
	qui rdbwselect $outcome vm, bwselect(IK)
	local IK_bw = e(h_IK)
	di `IK_bw'
	local IK_bw100 = `IK_bw'/100

* Computation of exact p-values
use disc_final.dta, clear

	*first for the regular bws
forvalues bw=10(5)25 {
	rinf, dv($outcome) bw(`bw') iter(`iterations') condition("keep if mo_assigned==1") condition1(" ")
	if `bw' == 10 {
	mat p = `r(pexact`bw')'
	mat ci = r(CI`bw')
		}
	else { 
	mat p = p \ `r(pexact`bw')'
	mat ci = ci \ r(CI`bw')
		}
	}

	* next for IK bw
	rinf, dv($outcome) bw(`IK_bw') iter(`iterations') condition("keep if mo_assigned==1") condition1(" ")
	local absbw = int(`IK_bw')
	mat p = p \ `r(pexact`absbw')'
	mat ci = ci \ r(CI`absbw')
	
matlist p
matlist ci

est clear
use disc_final.dta, clear
keep if mo_assigned==1

mat ci_reg = J(5,3,.)

forvalues bw=10(5)25 {
	eststo: areg $outcome pml_winner vm pvm i_wave* [pw=w`bw'], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		capture estadd scalar pexact= p[(`bw'/5)-1,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		preserve
			keep if e(sample) == 1
			duplicates drop hmis, force
			count
			estadd scalar nclinics = r(N)
		restore
	
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		if `bw' == 10 {
			mat ci_reg = X
			}
		else {
			mat ci_reg = ci_reg \ X
			}
	}

	g wIK=max(0,`IK_bw'-abs(vm)) if abs(vm)<=`IK_bw'
	eststo: areg $outcome pml_winner vm pvm i_wave* [pw=wIK], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		capture estadd scalar pexact= p[5,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		preserve
			keep if e(sample) == 1
			duplicates drop hmis, force
			count
			estadd scalar nclinics = r(N)
		restore
		
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		mat ci_reg = ci_reg \ X
	
local IK_bw = round(`IK_bw', 0.01)			
local IK_bw100 = round(`IK_bw100', 0.0001)

svmat p
replace p1 = round(p1, 0.01)
format p1 %6.3f

if `IK_bw100' <0.1 {
estout est5 est1 est2 est3 est4 using ./interim_output/mo_dist_hometown.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Doctor distance to hometown") mlabels("IK=`IK_bw100'" "0.1" "15" "20" "25" )
}

if `IK_bw100' >=0.1 & `IK_bw100' <0.15 {
estout est1 est5 est2 est3 est4 using ./interim_output/mo_dist_hometown.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Doctor distance to hometown") mlabels("0.1" "IK=`IK_bw100'" "15" "20" "25" )
}

if `IK_bw100' >=0.15 & `IK_bw100' <0.2 {
estout est1 est2 est5 est3 est4 using ./interim_output/mo_dist_hometown.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Doctor distance to hometown") mlabels("0.1" "15" "IK=`IK_bw100'" "20" "25" )
}

if `IK_bw100' >=0.2 & `IK_bw100' <0.25 {
estout est1 est2 est3 est5 est4 using ./interim_output/mo_dist_hometown.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Doctor distance to hometown") mlabels("0.1" "15" "20" "IK=`IK_bw100'" "25" )
}

if `IK_bw100' >=0.25 {
estout est1 est2 est3 est4 est5 using ./interim_output/mo_dist_hometown.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Doctor distance to hometown") mlabels("0.1" "15" "20" "25" "IK=`IK_bw100'")
}
	
********************************************************
* Figure A8 bottom panels, Table A7: DOCTOR CONNECTIONS
********************************************************
clear all
set seed 83457
set maxvar 14000

* Load randomization inference program
do "rinf.do"

foreach x in mo_mpa_direct mo_mpa {
	
* Connections
global outcome `x'
local iterations = 1000

est clear
use disc_final.dta, clear

* IK bw selection
collapse (mean) $outcome (firstnm) vm, by(consid)
	qui rdbwselect $outcome vm, bwselect(IK)
	local IK_bw = e(h_IK)
	di `IK_bw'
	local IK_bw100 = `IK_bw'/100

* Computation of exact p-values
use disc_final.dta, clear

	*first for the regular bws
forvalues bw=10(5)25 {
	rinf, dv($outcome) bw(`bw') iter(`iterations') condition(" ")  condition1(" ")
	if `bw' == 10 {
	mat p = `r(pexact`bw')'
	mat ci = r(CI`bw')
		}
	else { 
	mat p = p \ `r(pexact`bw')'
	mat ci = ci \ r(CI`bw')
		}
	}

	* next for IK bw
	rinf, dv($outcome) bw(`IK_bw') iter(`iterations') condition(" ") condition1(" ")
	local absbw = int(`IK_bw')
	mat p = p \ `r(pexact`absbw')'
	mat ci = ci \ r(CI`absbw')
	
matlist p
matlist ci

est clear
use disc_final.dta, clear
mat ci_reg = J(5,3,.)

forvalues bw=10(5)25 {
	eststo: areg $outcome pml_winner vm pvm i_wave* [pw=w`bw'], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		capture estadd scalar pexact= p[(`bw'/5)-1,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		preserve
			keep if e(sample) == 1
			duplicates drop hmis, force
			count
			estadd scalar nclinics = r(N)
		restore
		
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		if `bw' == 10 {
			mat ci_reg = X
			}
		else {
			mat ci_reg = ci_reg \ X
			}
	}	

	g wIK=max(0,`IK_bw'-abs(vm)) if abs(vm)<=`IK_bw'
	eststo: areg $outcome pml_winner vm pvm i_wave* [pw=wIK], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		capture estadd scalar pexact= p[5,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		preserve
			keep if e(sample) == 1
			duplicates drop hmis, force
			count
			estadd scalar nclinics = r(N)
		restore
		
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		mat ci_reg = ci_reg \ X
	
local IK_bw = round(`IK_bw', 0.01)			
local IK_bw100 = round(`IK_bw100', 0.0001)

svmat p
replace p1 = round(p1, 0.01)
format p1 %6.3f

if `IK_bw100' <0.1 {
estout est5 est1 est2 est3 est4 using ./interim_output/knows_`x'_uc.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x'") mlabels("IK=`IK_bw100'" "0.1" "15" "20" "25" )
}

if `IK_bw100' >=0.1 & `IK_bw100' <0.15 {
estout est1 est5 est2 est3 est4 using ./interim_output/knows_`x'_uc.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x'") mlabels("0.1" "IK=`IK_bw100'" "15" "20" "25" )
}

if `IK_bw100' >=0.15 & `IK_bw100' <0.2 {
estout est1 est2 est5 est3 est4 using ./interim_output/knows_`x'_uc.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x'") mlabels("0.1" "15" "IK=`IK_bw100'" "20" "25" )
}

if `IK_bw100' >=0.2 & `IK_bw100' <0.25 {
estout est1 est2 est3 est5 est4 using ./interim_output/knows_`x'_uc.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x'") mlabels("0.1" "15" "20" "IK=`IK_bw100'" "25" )
}

if `IK_bw100' >=0.25 {
estout est1 est2 est3 est4 est5 using ./interim_output/knows_`x'_uc.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x'") mlabels("0.1" "15" "20" "25" "IK=`IK_bw100'")
}

label var mo_mpa_direct "Doctor Knows Politician Directly"
label var mo_mpa "Doctor Knows Politician"

* Graph
svmat ci_reg
forvalues j =1/4 {
	capture gen bandwidth= (_n * 5 + 5)/100 in `j'
	replace bandwidth= (_n * 5 + 5)/100 in `j'
	}
replace bandwidth = `IK_bw100' in 5

	twoway (dot ci_reg2 bandwidth, ndots(0) mcolor(maroon) msymbol(X) msize(large)) || (rcap ci_reg1 ci_reg3 bandwidth, lcolor(gs8)) , ///
		xtitle("Margin of Victory Bandwidth", size(vsmall)) ///
		xlabel(`IK_bw100' "IK=0`IK_bw100'" 0.1 "0.1" 0.15 "0.15" 0.2 "0.20" 0.25 "0.25" , labsize(vsmall) angle(vertical)) ///
		ylabel(, labsize(vsmall)) yline(0, lcolor(gs13)) aspectratio(0.6) ///
		ytitle("Treatment Effect", size(vsmall)) name(knows_`x'reg, replace) scheme(s1color) ///
		legend(label(1 "Treatment Effect") label(2 "95% CI") region(lwidth(none)) size(small)) ///
		title(`: variable label `x'', size(small))
	
	graph save "./figures/coef/knowsbybwreg_`x'_uc.gph", replace
	graph export "./figures/coef/knowsbybwreg_`x'_uc.pdf", as(pdf) replace

* Graph RI
svmat ci

forvalues j =1/4 {
	capture gen bandwidth= (_n * 5 + 5)/100 in `j'
	replace bandwidth= (_n * 5 + 5)/100 in `j'
	}
replace bandwidth = `IK_bw100' in 5

	twoway (dot ci2 bandwidth, ndots(0) mcolor(maroon) msymbol(X) msize(large)) || (rcap ci1 ci3 bandwidth, lcolor(gs8)) , ///
		xtitle("Margin of Victory Bandwidth", size(vsmall)) ///
		xlabel(`IK_bw100' "IK=0`IK_bw100'" 0.1 "0.1" 0.15 "0.15" 0.2 "0.20" 0.25 "0.25", labsize(vsmall) angle(vertical)) ///
		ylabel(, labsize(vsmall)) yline(0, lcolor(gs13)) aspectratio(0.6) ///
		ytitle("Treatment Effect", size(vsmall)) name(knows_`x', replace) scheme(s1color) ///
		legend(label(1 "Treatment Effect") label(2 "90% Exact CI") region(lwidth(none)) size(small)) ///
		title(`: variable label `x'', size(small))
	
	graph save "./figures/coef/knowsbybw_`x'_uc.gph", replace
	graph export "./figures/coef/knowsbybw_`x'_uc.pdf", as(pdf) replace

}

grc1leg knows_mo_mpa_directreg knows_mo_mpareg, scheme(s1color) rows(2)
	graph export "./figures/coef/knowsbybwreg_uc.pdf", as(pdf) replace

grc1leg knows_mo_mpa_direct knows_mo_mpa, scheme(s1color) rows(2)
	graph export "./figures/coef/knowsbybw_uc.pdf", as(pdf) replace
	
********************************************************
* Figure A8 top middle panel
********************************************************
clear all
set seed 83457
set maxvar 14000

* Load randomization inference program
do "rinf.do"

foreach x in lmo_tenure_uc {
	
* Connections
global outcome `x'
local iterations = 1000

est clear
use disc_final.dta, clear

* IK bw selection
collapse (mean) $outcome (firstnm) vm, by(consid)
	qui rdbwselect $outcome vm, bwselect(IK)
	local IK_bw = e(h_IK)
	di `IK_bw'
	local IK_bw100 = `IK_bw'/100

* Computation of exact p-values
use disc_final.dta, clear

	*first for the regular bws
forvalues bw=10(5)25 {
	rinf, dv($outcome) bw(`bw') iter(`iterations') condition(" ")  condition1(" ")
	if `bw' == 10 {
	mat p = `r(pexact`bw')'
	mat ci = r(CI`bw')
		}
	else { 
	mat p = p \ `r(pexact`bw')'
	mat ci = ci \ r(CI`bw')
		}
	}

	* next for IK bw
	rinf, dv($outcome) bw(`IK_bw') iter(`iterations') condition(" ") condition1(" ")
	local absbw = int(`IK_bw')
	mat p = p \ `r(pexact`absbw')'
	mat ci = ci \ r(CI`absbw')
	
matlist p
matlist ci

est clear
use disc_final.dta, clear
mat ci_reg = J(5,3,.)

forvalues bw=10(5)25 {
	eststo: areg $outcome pml_winner vm pvm i_wave* [pw=w`bw'], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		capture estadd scalar pexact= p[(`bw'/5)-1,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		preserve
			keep if e(sample) == 1
			duplicates drop hmis, force
			count
			estadd scalar nclinics = r(N)
		restore
		
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		if `bw' == 10 {
			mat ci_reg = X
			}
		else {
			mat ci_reg = ci_reg \ X
			}
	}	

	g wIK=max(0,`IK_bw'-abs(vm)) if abs(vm)<=`IK_bw'
	eststo: areg $outcome pml_winner vm pvm i_wave* [pw=wIK], cluster(consid) ab(district_tehsil_code)
		mat tab = r(table)
		capture estadd scalar pexact= p[5,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		preserve
			keep if e(sample) == 1
			duplicates drop hmis, force
			count
			estadd scalar nclinics = r(N)
		restore
		
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		mat ci_reg = ci_reg \ X
	
local IK_bw = round(`IK_bw', 0.01)			
local IK_bw100 = round(`IK_bw100', 0.0001)

svmat p
replace p1 = round(p1, 0.01)
format p1 %6.3f

* Graph RI
svmat ci

forvalues j =1/4 {
	capture gen bandwidth= (_n * 5 + 5)/100 in `j'
	replace bandwidth= (_n * 5 + 5)/100 in `j'
	}
replace bandwidth = `IK_bw100' in 5

	twoway (dot ci2 bandwidth, ndots(0) mcolor(maroon) msymbol(X) msize(large)) || (rcap ci1 ci3 bandwidth, lcolor(gs8)) , ///
		xtitle("Margin of Victory Bandwidth", size(vsmall)) ///
		xlabel(`IK_bw100' "IK=0`IK_bw100'" 0.1 "0.1" 0.15 "0.15" 0.2 "0.20" 0.25 "0.25", labsize(vsmall) angle(vertical)) ///
		ylabel(, labsize(vsmall)) yline(0, lcolor(gs13)) aspectratio(0.6) ///
		ytitle("Treatment Effect", size(vsmall)) name(knows_`x', replace) scheme(s1color) ///
		legend(label(1 "Treatment Effect") label(2 "90% Exact CI") region(lwidth(none)) size(small)) ///
		title(`: variable label `x'', size(small))
	
	graph save "./figures/coef/tenurebybw_mo_uc.gph", replace
	graph export "./figures/coef/tenurebybw_mo_uc.pdf", as(pdf) replace
}
	
***********************************	
* FIGURE A3: RD PLOTS IN APPENDIX E.2	
***********************************

use disc_final.dta, clear
replace vm = vm /100
replace pvm = pvm/100
keep if abs(vm)<0.20

preserve
local outcome mo_assigned

gen group=-0.24 if vm>=-0.25&vm<-0.23
forvalues i=1(1)50 {
replace group=-0.24+(`i'*0.01) if vm>=-0.25+(`i'*0.01) & vm<-0.24+(`i'*0.01)
}
egen vm_mean2=mean(vm), by(group)
egen `outcome'_mean2 = mean(`outcome'), by(group)

areg `outcome' pml_winner vm pvm if abs(vm)<0.20 [pw=w20], absorb(district_tehsil_code) cluster(consid)
predict yhat_1
predict SE_1, stdp
gen low_1 = yhat_1 - 1.96*(SE_1)
gen high_1 = yhat_1 + 1.96*(SE_1)

twoway (scatter `outcome'_mean2 vm_mean2 if abs(vm)<0.20, mcolor(gs11)) /*
*/ (line yhat_1 low_1 high_1 vm if vm<0&vm>-0.25, pstyle(p p3 p3) sort lwidth(thick) lcolor(gs3))/* 
*/ (line yhat_1 low_1 high_1 vm if vm>0&vm<0.25, pstyle(p p3 p3) sort lwidth(thick) lcolor(gs3)) , /* 
*/ xtitle(Victory Margin) title(Doctor Assigned, size(small)) xlabel(-0.30(0.10)0.30) ///
	legend(off) xline(0) scheme(s1color) name(assigned, replace) ytitle(Treatment Effect, size(small)) aspectratio(0.9)
restore

preserve
local outcome lmo_tenure_uc

gen group=-0.24 if vm>=-0.25&vm<-0.23
forvalues i=1(1)50 {
replace group=-0.24+(`i'*0.01) if vm>=-0.25+(`i'*0.01) & vm<-0.24+(`i'*0.01)
}
egen vm_mean2=mean(vm), by(group)
egen `outcome'_mean2 = mean(`outcome'), by(group)

areg `outcome' pml_winner vm pvm if abs(vm)<0.20 [pw=w20], absorb(district_tehsil_code) cluster(consid)
predict yhat_1
predict SE_1, stdp
gen low_1 = yhat_1 - 1.96*(SE_1)
gen high_1 = yhat_1 + 1.96*(SE_1)

twoway (scatter `outcome'_mean2 vm_mean2 if abs(vm)<0.20, mcolor(gs11)) /*
*/ (line yhat_1 low_1 high_1 vm if vm<0&vm>-0.25, pstyle(p p3 p3) sort lwidth(thick) lcolor(gs3))/* 
*/ (line yhat_1 low_1 high_1 vm if vm>0&vm<0.25, pstyle(p p3 p3) sort lwidth(thick) lcolor(gs3)) , /* 
*/ xtitle(Victory Margin) title(Logged Doctor Tenure, size(small)) xlabel(-0.30(0.10)0.30) ///
	legend(off) xline(0) scheme(s1color) name(tenure, replace) ytitle(Treatment Effect, size(small)) aspectratio(0.9)
restore

preserve
local outcome mo_present_uc

gen group=-0.24 if vm>=-0.25&vm<-0.23
forvalues i=1(1)50 {
replace group=-0.24+(`i'*0.01) if vm>=-0.25+(`i'*0.01) & vm<-0.24+(`i'*0.01)
}
egen vm_mean2=mean(vm), by(group)
egen `outcome'_mean2 = mean(`outcome'), by(group)

areg `outcome' pml_winner vm pvm if abs(vm)<0.20 [pw=w20], absorb(district_tehsil_code) cluster(consid)
predict yhat_10
predict SE_1, stdp
gen low_1 = yhat_1 - 1.96*(SE_1)
gen high_1 = yhat_1 + 1.96*(SE_1)

twoway (scatter `outcome'_mean2 vm_mean2 if abs(vm)<0.20, mcolor(gs11)) /*
*/ (line yhat_1 low_1 high_1 vm if vm<0&vm>-25, pstyle(p p3 p3) sort lwidth(thick) lcolor(gs3))/* 
*/ (line yhat_1 low_1 high_1 vm if vm>0&vm<25, pstyle(p p3 p3) sort lwidth(thick) lcolor(gs3)) , /* 
*/ xtitle(Victory Margin) title(Doctor Attendance, size(small)) xlabel(-0.30(0.10)0.30) ///
	legend(off) xline(0) scheme(s1color) name(attend, replace) ytitle(Treatment Effect, size(small)) aspectratio(0.9)
restore


preserve
local outcome mo_mpa_direct_uc

gen group=-0.24 if vm>=-0.25&vm<-0.23
forvalues i=1(1)50 {
replace group=-0.24+(`i'*0.01) if vm>=-0.25+(`i'*0.01) & vm<-0.24+(`i'*0.01)
}
egen vm_mean2=mean(vm), by(group)
egen `outcome'_mean2 = mean(`outcome'), by(group)

areg `outcome' pml_winner vm pvm if abs(vm)<0.20 [pw=w20], absorb(district_tehsil_code) cluster(consid)
predict yhat_1
predict SE_1, stdp
gen low_1 = yhat_1 - 1.96*(SE_1)
gen high_1 = yhat_1 + 1.96*(SE_1)

twoway (scatter `outcome'_mean2 vm_mean2 if abs(vm)<0.20, mcolor(gs11)) /*
*/ (line yhat_1 low_1 high_1 vm if vm<0&vm>-25, pstyle(p p3 p3) sort lwidth(thick) lcolor(gs3))/* 
*/ (line yhat_1 low_1 high_1 vm if vm>0&vm<25, pstyle(p p3 p3) sort lwidth(thick) lcolor(gs3)) , /* 
*/ xtitle(Victory Margin) title(Doctor Knows Politician Directly, size(small)) xlabel(-0.30(0.10)0.30) ///
	legend(off) xline(0) scheme(s1color) name(knowsdirect, replace) ytitle(Treatment Effect, size(small)) aspectratio(0.9)
restore


preserve
local outcome mo_mpa_uc

gen group=-0.24 if vm>=-0.25&vm<-0.23
forvalues i=1(1)50 {
replace group=-0.24+(`i'*0.01) if vm>=-0.25+(`i'*0.01) & vm<-0.24+(`i'*0.01)
}
egen vm_mean2=mean(vm), by(group)
egen `outcome'_mean2 = mean(`outcome'), by(group)

areg `outcome' pml_winner vm pvm if abs(vm)<0.20 [pw=w20], absorb(district_tehsil_code) cluster(consid)
predict yhat_1
predict SE_1, stdp
gen low_1 = yhat_1 - 1.96*(SE_1)
gen high_1 = yhat_1 + 1.96*(SE_1)

twoway (scatter `outcome'_mean2 vm_mean2 if abs(vm)<0.20, mcolor(gs11)) /*
*/ (line yhat_1 low_1 high_1 vm if vm<0&vm>-25, pstyle(p p3 p3) sort lwidth(thick) lcolor(gs3))/* 
*/ (line yhat_1 low_1 high_1 vm if vm>0&vm<25, pstyle(p p3 p3) sort lwidth(thick) lcolor(gs3)) , /* 
*/ xtitle(Victory Margin) title(Doctor Knows Politician, size(small)) xlabel(-0.30(0.10)0.30) ///
	legend(off) xline(0) scheme(s1color) name(knows, replace) ytitle(Treatment Effect, size(small)) aspectratio(0.9)
restore

graph combine assigned tenure attend knowsdirect knows, scheme(s1color) cols(3) imargin(small)
	graph export "./figures/coef/rd_plot_outcomes_uc.pdf", as(pdf) replace
	
	
****************************	
* FIGURE A5: DC DENSITY PLOT
****************************
* McCrary Test
use disc_final.dta, clear
	collapse (firstnm) vm, by (consid)
	DCdensity vm if vm<=50 & vm>=-50, breakpoint(0) generate(Xj Yj r0 fhat se_fhat) graphname(./figures/sorting.pdf)
    graph export "./figures/sorting.pdf", as(pdf) replace
	
****************************	
* FIGURE A6: PLACEBO PLOT 
****************************	
use disc_final.dta, clear
replace vm = vm /100
replace pvm = pvm/100
keep if abs(vm)<0.2

collapse (firstnm) rvoters08 vcast08 vtotal08 turnout08 Ncand08 enc08 rvoters02 vcast02 vtotal02 turnout02 Ncand02 enc02 vm pvm vm2 pvm2 pml_winner w* i_wave* district_tehsil_code, by(consid) 

foreach x in rvoters08 rvoters02 vcast08 vcast02 vtotal08 vtotal02 {
	replace `x' = `x' /10000
	}
	
label var rvoters08 "Registered Votes, 2008 (in 10,000s)"
label var rvoters02 "Registered Votes, 2002 (in 10,000s)"
label var vcast08 "Votes Cast, 2008 (in 10,000s)"
label var vcast02 "Votes Cast, 2002 (in 10,000s)"
label var turnout08 "Turnout, 2008"
label var turnout02 "Turnout, 2002"
label var Ncand08 "Number of Candidates, 2008"
label var Ncand02 "Number of Candidates, 2002"
label var enc08 "Effective Num of Candidates, 2008"
label var enc02 "Effective Num of Candidates, 2002"
label var vtotal08 "Total valid votes, 2008 (in 10,000s)"
label var vtotal02 "Total valid votes, 2002 (in 10,000s)"

foreach var in rvoters08 vcast08 vtotal08 turnout08 Ncand08 enc08 rvoters02 vcast02 vtotal02 turnout02 Ncand02 enc02 {

preserve
local outcome `var'

gen group=-0.24 if vm>=-0.25&vm<-0.23
forvalues i=1(1)50 {
replace group=-0.24+(`i'*0.01) if vm>=-0.25+(`i'*0.01) & vm<-0.24+(`i'*0.01)
}
egen vm_mean2=mean(vm), by(group)
egen `outcome'_mean2 = mean(`outcome'), by(group)

areg `outcome' pml_winner vm pvm if abs(vm)<0.20 [pw=w20], absorb(district_tehsil_code) cluster(consid)
predict yhat_1
predict SE_1, stdp
gen low_1 = yhat_1 - 1.96*(SE_1)
gen high_1 = yhat_1 + 1.96*(SE_1)


twoway (scatter `outcome'_mean2 vm_mean2 if abs(vm)<0.20, mcolor(gs11)) /*
*/ (line yhat_1 low_1 high_1 vm if vm<0&vm>-0.25, pstyle(p p3 p3) sort lwidth(thick) lcolor(gs3))/* 
*/ (line yhat_1 low_1 high_1 vm if vm>0&vm<0.25, pstyle(p p3 p3) sort lwidth(thick) lcolor(gs3)) , /* 
*/ xtitle(Victory Margin) title("`: variable label `outcome''", size(small)) xlabel(-0.30(0.10)0.30) ///
	legend(off) xline(0) scheme(s1color) name(`outcome', replace) ytitle(Treatment Effect, size(small)) aspectratio(0.9)
restore

}

graph combine rvoters08 vcast08 vtotal08 turnout08 Ncand08 enc08 ///
	rvoters02 vcast02 vtotal02 turnout02 Ncand02 enc02, scheme(s1color) ///
	imargin(small) xsize(8) ysize(10) rows(5) 
	
	graph export "./figures/coef/rd_plot_placebo.pdf", as(pdf) replace


*********************************************	
* FIGURE A7 PLACEBO TREATMENT EFFECTS F TEST	
*********************************************

est clear
use disc_final.dta, clear
collapse (firstnm) rvoters08 vcast08 vtotal08 turnout08 Ncand08 enc08 rvoters02 vcast02 vtotal02 turnout02 Ncand02 enc02  vm pvm vm2 pvm2 pml_winner w* i_wave* district_tehsil_code, by(consid) 

forvalues bw=10(5)25 {
	eststo: reg pml_winner rvoters08 vcast08 vtotal08 turnout08 Ncand08 enc08 rvoters02 vcast02 vtotal02 turnout02 Ncand02 enc02 [pw=w`bw'], r
		capture estadd scalar pexact= p[(`bw'/5)-1,1]
		estadd scalar mean = r(mean)
}

svmat p
replace p1 = round(p1, 0.01)
format p1 %6.3f

* Graph
svmat ci

forvalues j =1/4 {
	capture gen bandwidth= (_n * 5 + 5)/100 in `j'
	replace bandwidth= (_n * 5 + 5)/100 in `j'
	}

label var rvoters08 "Registered Votes, 2008 (in 10,000s)"
label var rvoters02 "Registered Votes, 2002 (in 10,000s)"
label var vcast08 "Votes Cast, 2008 (in 10,000s)"
label var vcast02 "Votes Cast, 2002 (in 10,000s)"
label var turnout08 "Turnout, 2008"
label var turnout02 "Turnout, 2002"
label var Ncand08 "Number of Candidates, 2008"
label var Ncand02 "Number of Candidates, 2002"
label var enc08 "Effective Num of Candidates, 2008"
label var enc02 "Effective Num of Candidates, 2002"
label var vtotal08 "Total valid votes, 2008"
label var vtotal02 "Total valid votes, 2002"

	twoway (dot ci2 bandwidth, ndots(0) mcolor(maroon) msymbol(X) msize(large)) || (rcap ci1 ci3 bandwidth, lcolor(gs8)) , ///
		xtitle("Margin of Victory Bandwidth", size(vsmall)) ///
		xlabel(0.1 "0.10" 0.15 "0.15" 0.2 "0.20" 0.25 "0.25" , labsize(vsmall) angle(vertical)) ///
		ylabel(, labsize(vsmall)) yline(0, lcolor(gs13)) aspectratio(0.5) ///
		ytitle("", size(vsmall)) name(`x', replace) scheme(s1color) ///
		legend(label(1 "Point Estimates") label(2 "Exact Test CIs") region(lwidth(none)) size(small)) ///
		title("Placebo - F Test p-values", size(small))
	
	graph save "./figures/coef/placebo.gph", replace
	graph export "./figures/coef/placebo.pdf", as(pdf) replace
	
	
*********************************
* TABLE A9: 2002 ELECTION PLACEBO
*********************************	
* Load randomization inference program
do "rinf_2002_placebo.do"
	
* Connections
global outcome incumbent08
local iterations = 1000

est clear
use disc_final_2002_placebo, clear

* IK bw selection
collapse (mean) $outcome (firstnm) vm, by(consid)
	qui rdbwselect $outcome vm, bwselect(IK)
	local IK_bw = e(h_IK)
	di `IK_bw'
	local IK_bw100 = `IK_bw'/100

* Computation of exact p-values
use disc_final_2002_placebo, clear

	*first for the regular bws
forvalues bw=10(5)25 {
	rinf, dv($outcome) bw(`bw') iter(`iterations') condition(" ") condition1(" ")
	if `bw' == 10 {
	mat p = `r(pexact`bw')'
	mat ci = r(CI`bw')
		}
	else { 
	mat p = p \ `r(pexact`bw')'
	mat ci = ci \ r(CI`bw')
		}
	}

	* next for IK bw
	rinf, dv($outcome) bw(`IK_bw') iter(`iterations') condition(" ") condition1(" ")
	local absbw = int(`IK_bw')
	mat p = p \ `r(pexact`absbw')'
	mat ci = ci \ r(CI`absbw')
	
matlist p
matlist ci

est clear
use disc_final_2002_placebo, clear

mat ci_reg = J(5,3,.)

forvalues bw=10(5)25 {
	eststo: reg $outcome pml_winner vm pvm [pw=w`bw']
		mat tab = r(table)
		unique hmis if e(sample)==1
		estadd scalar nclinics = r(sum)
		capture estadd scalar pexact= p[(`bw'/5)-1,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		if `bw' == 10 {
			mat ci_reg = X
			}
		else {
			mat ci_reg = ci_reg \ X
			}
	}

	g wIK=max(0,`IK_bw'-abs(vm)) if abs(vm)<=`IK_bw'
	eststo: reg $outcome pml_winner vm pvm [pw=wIK]
		mat tab = r(table)
		unique hmis if e(sample)==1
		estadd scalar nclinics = r(sum)
		capture estadd scalar pexact= p[5,1]
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		mat ci_reg = ci_reg \ X
	
local IK_bw = round(`IK_bw', 0.01)			
local IK_bw100 = round(`IK_bw100', 0.0001)

svmat p
replace p1 = round(p1, 0.01)
format p1 %6.3f

if `IK_bw100' <0.1 {
estout est5 est1 est2 est3 est4 using interim_output/2002_placebo.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N, layout(@ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# MPAs") fmt(%9.2f %9.3f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Incumbent in 2008") mlabels("IK=`IK_bw100'" "0.1" "15" "20" "25" )
}

if `IK_bw100' >=0.1 & `IK_bw100' <0.15 {
estout est1 est5 est2 est3 est4 using ./interim_output/2002_placebo.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N, layout(@ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# MPAs") fmt(%9.2f %9.3f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Incumbent in 2008") mlabels("0.1" "IK=`IK_bw100'" "15" "20" "25" )
}

if `IK_bw100' >=0.15 & `IK_bw100' <0.2 {
estout est1 est2 est5 est3 est4 using ./interim_output/2002_placebo.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N, layout(@ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# MPAs") fmt(%9.2f %9.3f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Incumbent in 2008") mlabels("0.1" "15" "IK=`IK_bw100'" "20" "25" )
}

if `IK_bw100' >=0.2 & `IK_bw100' <0.25 {
estout est1 est2 est3 est5 est4 using ./interim_output/2002_placebo.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N, layout(@ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# MPAs") fmt(%9.2f %9.3f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Incumbent in 2008") mlabels("0.1" "15" "20" "IK=`IK_bw100'" "25" )
}

if `IK_bw100' >=0.25 {
estout est1 est2 est3 est4 est5 using ./interim_output/2002_placebo.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N, layout(@ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# MPAs") fmt(%9.2f %9.3f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Incumbent in 2008") mlabels("0.1" "15" "20" "25" "IK=`IK_bw100'")
}
	
	
*************************************************
* TABLE A10: POLLING STATION OBSERVATION OUTCOMES 
*************************************************
clear all
set seed 189
set maxvar 20000

foreach x in total_good_and_bad_dummies thispshasbeencapturedonlyvotersf {

* Outcome
global outcome `x'

* IK bw selection
use disc_final_NA_with_fafen_data, clear
collapse (mean) $outcome (firstnm) vm, by(na_id)
	qui rdbwselect $outcome vm, bwselect(IK)
	local IK_bw = e(h_IK)
	di `IK_bw'
	local IK_bw100 = `IK_bw'/100

est clear
use disc_final_NA_with_fafen_data, clear

mat ci_reg = J(5,3,.)

forvalues bw=10(5)25 {
	eststo: reg $outcome pml_winner vm pvm [pw=w`bw'], cluster(na_id)
		mat tab = r(table)
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		if `bw' == 10 {
			mat ci_reg = X
			}
		else {
			mat ci_reg = ci_reg \ X
			}
	}

	g wIK=max(0,`IK_bw'-abs(vm)) if abs(vm)<=`IK_bw'
	eststo: reg $outcome pml_winner vm pvm [pw=wIK], cluster(na_id)
		mat tab = r(table)
		sum $outcome if e(sample)==1 & pml_winner ==0
		estadd scalar mean = r(mean)
		
		local ll = tab[5,1]
		local point = tab[1,1]
		local ul = tab[6,1]
		mat X = `ll', `point',  `ul'
		mat ci_reg = ci_reg \ X
	
local IK_bw = round(`IK_bw', 0.01)			
local IK_bw100 = round(`IK_bw100', 0.0001)

if `IK_bw100' <0.1 {
estout est5 est1 est2 est3 est4 using interim_output/$outcome.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(mean N N_clust, layout(@ @ @ ) ///
label("Mean Control Dep. Var." "\# Polling Booths" "\# MNA Constituencies") fmt(%9.3f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Lawabiding minus lawbreaking checkmarks") mlabels("IK=`IK_bw100'" "0.1" "15" "20" "25" )
}

if `IK_bw100' >=0.1 & `IK_bw100' <0.15 {
estout est1 est5 est2 est3 est4 using interim_output/$outcome.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(mean N N_clust, layout(@ @ @ ) ///
label("Mean Control Dep. Var." "\# Polling Booths" "\# MNA Constituencies") fmt(%9.3f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Lawabiding minus lawbreaking checkmarks") mlabels("0.1" "IK=`IK_bw100'" "15" "20" "25" )
}

if `IK_bw100' >=0.15 & `IK_bw100' <0.2 {
estout est1 est2 est5 est3 est4 using interim_output/$outcome.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(mean N N_clust, layout(@ @ @ ) ///
label("Mean Control Dep. Var." "\# Polling Booths" "\# MNA Constituencies") fmt(%9.3f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Lawabiding minus lawbreaking checkmarks") mlabels("0.1" "15" "IK=`IK_bw100'" "20" "25" )
}

if `IK_bw100' >=0.2 & `IK_bw100' <0.25 {
estout est1 est2 est3 est5 est4 using interim_output/$outcome.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(mean N N_clust, layout(@ @ @ ) ///
label("Mean Control Dep. Var." "\# Polling Booths" "\# MNA Constituencies") fmt(%9.3f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Lawabiding minus lawbreaking checkmarks") mlabels("0.1" "15" "20" "IK=`IK_bw100'" "25" )
}

if `IK_bw100' >=0.25 {
estout est1 est2 est3 est4 est5 using interim_output/$outcome.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(mean N N_clust, layout(@ @ @ ) ///
label("Mean Control Dep. Var." "\# Polling Booths" "\# MNA Constituencies") fmt(%9.3f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("Lawabiding minus lawbreaking checkmarks") mlabels("0.1" "15" "20" "25" "IK=`IK_bw100'")
}
}

****************************************************
* TABLE A11: ROBUSTNESS OF DOCTOR ASSIGNMENT RESULTS
****************************************************
clear all
est clear
clear matrix
	
* IK bw selection
use disc_final.dta, clear

collapse (mean) mo_assigned (firstnm) vm, by(consid)

rdbwselect mo_assigned vm, bwselect(IK)
local IK_bw = e(h_IK)
display `IK_bw'
local IK_bw100 = `IK_bw'/100

use disc_final.dta, clear
drop i_wave3

drop w5 w10
forvalues X = 1(1)14 {
 generate w`X'=max(0,`X'-abs(vm)) if abs(vm)<=`X'
}

eststo: reg mo_assigned pml_winner vm pvm i_wave* [pw=w1], cluster(consid)
matrix tab = r(table)
summarize mo_assigned if e(sample)==1 & pml_winner ==0
estadd scalar mean = r(mean)
preserve
 keep if e(sample) == 1
 duplicates drop hmis, force
 count
 estadd scalar nclinics = r(N)
restore

eststo: reg mo_assigned pml_winner vm pvm i_wave* [pw=w2], cluster(consid)
matrix tab = r(table)
summarize mo_assigned if e(sample)==1 & pml_winner ==0
estadd scalar mean = r(mean)
preserve
 keep if e(sample) == 1
 duplicates drop hmis, force
 count
 estadd scalar nclinics = r(N)
restore

eststo: reg mo_assigned pml_winner vm pvm i_wave* [pw=w3], cluster(consid)
matrix tab = r(table)
summarize mo_assigned if e(sample)==1 & pml_winner ==0
estadd scalar mean = r(mean)
preserve
 keep if e(sample) == 1
 duplicates drop hmis, force
 count
 estadd scalar nclinics = r(N)
restore

eststo: reg mo_assigned pml_winner vm pvm i_wave* [pw=w5], cluster(consid)
matrix tab = r(table)
summarize mo_assigned if e(sample)==1 & pml_winner ==0
estadd scalar mean = r(mean)
preserve
 keep if e(sample) == 1
 duplicates drop hmis, force
 count
 estadd scalar nclinics = r(N)
restore

generate wIK=max(0,`IK_bw'-abs(vm)) if abs(vm)<=`IK_bw'

eststo: reg mo_assigned pml_winner vm pvm i_wave* [pw=w10], cluster(consid)
matrix tab = r(table)
summarize mo_assigned if e(sample)==1 & pml_winner ==0
estadd scalar mean = r(mean)
preserve
 keep if e(sample) == 1
 duplicates drop hmis, force
 count
 estadd scalar nclinics = r(N)
restore

eststo: areg mo_assigned pml_winner vm pvm i_wave* [pw=w10], cluster(consid) absorb(distcode)
matrix tab = r(table)
summarize mo_assigned if e(sample)==1 & pml_winner ==0
estadd scalar mean = r(mean)
preserve
 keep if e(sample) == 1
 duplicates drop hmis, force
 count
 estadd scalar nclinics = r(N)
restore

eststo: areg mo_assigned pml_winner vm pvm i_wave* [pw=w10], cluster(consid) absorb(district_tehsil_code)
matrix tab = r(table)
summarize mo_assigned if e(sample)==1 & pml_winner ==0
estadd scalar mean = r(mean)
preserve
 keep if e(sample) == 1
 duplicates drop hmis, force
 count
 estadd scalar nclinics = r(N)
restore

estout using ./interim_output/mo_assigned_robustness.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(pexact mean N_clust nclinics N, layout(@ @ @ @ @ ) ///
label("Exact p-value" "Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.2f %9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("MO Assigned")


****************************************
* TABLE A12: PARAMETRIC CONTROL FUNCTION
****************************************

foreach outcome in mo_assigned lmo_tenure_uc mo_present_uc mo_mpa_uc mo_mpa_direct_uc {
	global outcome `outcome'
	
	est clear
	use disc_final.dta, clear
	
	* IK bw selection
	preserve
	collapse (mean) $outcome (firstnm) vm, by(consid)
		qui rdbwselect $outcome vm, bwselect(IK)
		local IK_bw = e(h_IK)
		di `IK_bw'
		local IK_bw100 = `IK_bw'/100
	restore
	g wIK=max(0,`IK_bw'-abs(vm)) if abs(vm)<=`IK_bw'
	
* quadratic
forvalues bw=10(5)25 {
eststo: areg $outcome pml_winner vm pvm vm2 pvm2 i_wave* [pw=w`bw'], cluster(consid) ab(district_tehsil_code)
	if `bw'==25 {
	eststo: areg $outcome pml_winner vm pvm vm2 pvm2 i_wave* [pw=wIK], cluster(consid) ab(district_tehsil_code)
		}	
	}
	
* cubic
forvalues bw=10(5)25 {
eststo: areg $outcome pml_winner vm pvm vm2 pvm2 vm3 pvm3 i_wave* [pw=w`bw'], cluster(consid) ab(district_tehsil_code)
	if `bw'==25 {
	eststo: areg $outcome pml_winner vm pvm vm2 pvm2 i_wave* [pw=wIK], cluster(consid) ab(district_tehsil_code)
		}
	
	}

local IK_bw = round(`IK_bw', 0.01)			
local IK_bw100 = round(`IK_bw100', 0.0001)

if `IK_bw100' <0.1 {
estout est5 est1 est2 est3 est4 est10 est6 est7 est8 est9 using ./interim_output/parametric`outcome'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Assigned") mlabels("IK=0`IK_bw100'" "0.10" "0.15" "0.20" "0.25" "IK=0`IK_bw100'" "0.10" "0.15" "0.20" "0.25")
}

if `IK_bw100' >=0.1 & `IK_bw100' <0.15 {
estout est1 est5 est2 est3 est4 est6 est10 est7 est8 est9 using ./interim_output/parametric`outcome'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Assigned") mlabels("0.10" "IK=0`IK_bw100'" "0.15" "0.20" "0.25" "0.10" "IK=0`IK_bw100'" "0.15" "0.20" "0.25" )
}

if `IK_bw100' >=0.15 & `IK_bw100' <0.2 {
estout est1 est2 est5 est3 est4 est6 est7 est10 est8 est9 using ./interim_output/parametric`outcome'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Assigned") mlabels("0.10" "0.15" "IK=0`IK_bw100'" "0.20" "0.25" "0.10" "0.15" "IK=0`IK_bw100'" "0.20" "0.25")
}

if `IK_bw100' >=0.2 & `IK_bw100' <0.25 {
estout est1 est2 est3 est5 est4 est6 est7 est8 est10 est9 using ./interim_output/parametric`outcome'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Assigned") mlabels("0.10" "0.15" "0.20" "IK=0`IK_bw100'" "0.25" "0.10" "0.15" "0.20" "IK=0`IK_bw100'" "0.25")
}

if `IK_bw100' >=0.25 {
estout est1 est2 est3 est4 est5 est6 est7 est8 est9 est10 using ./interim_output/parametric`outcome'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x' Assigned") mlabels("0.10" "0.15" "0.20" "0.25" "IK=0`IK_bw100'" "0.10" "0.15" "0.20" "0.25" "IK=0`IK_bw100'")
}

drop wIK	
}


******************************
* Merging graphs for tex file
******************************
grc1leg ./figures/coef/assignedbybwreg_mo.gph ./figures/coef/attendbybwreg_mo_uc.gph ///
		./figures/coef/geo_mo_assigned.gph ./figures/coef/geo_mo_present_uc.gph ///
		, scheme(s1color) imargin(small)
graph export "./figures/coef/main_outcomesreg_uc.pdf", as(pdf) replace
	
	
grc1leg ./figures/coef/assignedbybw_mo.gph ./figures/coef/tenurebybw_mo_uc.gph ///
	./figures/coef/attendbybw_mo_uc.gph ./figures/coef/knowsbybw_mo_mpa_direct_uc.gph ./figures/coef/knowsbybw_mo_mpa_uc.gph ///
	, scheme(s1color) imargin(small)		
graph export "./figures/coef/main_outcomes_uc.pdf", as(pdf) replace


