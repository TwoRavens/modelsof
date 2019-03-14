set more off
clear all
set maxvar 14000

* Produces:
	* Figure 2 geographic RD panel
	* Panel B of Appendix Tables A3, A4, A5
	* Appendix Tables A8, A13

* User written commands used
* ssc install reghdfe
* ssc install unique
* ssc install estout
* net install st0366.pkg *rdbwselect (st0366) 
	* ado uninstall st0366.pkg
	* net install st0366.pkg, replace
* ssc install grc1leg
* DCdensity available here: https://eml.berkeley.edu/~jmccrary/DCdensity/	


set seed 83457

****************
* Defining programs
****************
* Specification
capture program drop spec
program define spec
syntax [anything], bw(string) control(string)
eststo: reghdfe $outcome pml_winner `control' if abs(npd)<=`bw' [pw=wg`bw'], cluster(consid) absorb(wave line_id)
		mat tab = r(table)
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
		if `bw' == 1 {
			mat ci_reg = X
			}
		else {
			mat ci_reg = ci_reg \ X
			}
end

capture program drop specIK
program define specIK
syntax [anything], bw(string) control(string)
eststo: reghdfe $outcome pml_winner `control' if abs(npd)<=`bw' [pw=wIK], cluster(consid) absorb(wave line_id)
		mat tab = r(table)
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

end

* Make Table
capture program drop maketab
program define maketab
syntax [anything], name(string) figure(string)

if $IK_bw <1 {
estout est5 est1 est2 est3 est4 using ./interim_output/geo_`name'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(mean N_clust nclinics N, layout(@ @ @ @ ) ///
label("Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x'") mlabels("IK=$IK_bw" "1" "2" "5" "10")
}

if $IK_bw >=1 & $IK_bw <2 {
estout est1 est5 est2 est3 est4 using ./interim_output/geo_`name'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(mean N_clust nclinics N, layout(@ @ @ @ ) ///
label("Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x'") mlabels("1" "IK=$IK_bw" "2" "5" "10" )
}

if $IK_bw >=2 & $IK_bw <5 {
estout est1 est2 est5 est3 est4 using ./interim_output/geo_`name'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(mean N_clust nclinics N, layout(@ @ @ @ ) ///
label("Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x'") mlabels("1" "2" "IK=$IK_bw" "5" "10")
}

if $IK_bw >=5 & $IK_bw <10 {
estout est1 est2 est3 est5 est4 using ./interim_output/geo_`name'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(mean N_clust nclinics N, layout(@ @ @ @ ) ///
label("Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x'") mlabels("1" "2" "5" "IK=$IK_bw" "10" )
}

if $IK_bw >=10 {
estout est1 est2 est3 est4 est5 using ./interim_output/geo_`name'.tex, replace cells(b(fmt(%9.3f) star) ///
se(par fmt(%9.2f))) style(tex) stats(mean N_clust nclinics N, layout(@ @ @ @ ) ///
label("Mean Control Dep. Var." "\# Constituencies" "\# Clinics" "\# Observations") fmt(%9.3f %9.0f %9.0f %9.0f)) ///
starlevels(* .1 ** .05 *** .01)  keep(pml_winner) order(pml_winner) varlabels(pml_winner "PML(N) Winner") ///
title("`x'") mlabels("1" "2" "5" "10" "IK=$IK_bw")
}

if "`figure'" == "yes" {
	makefig, name(`name')
	}

end

*Make Figure
capture program drop makefig
program define makefig
syntax [anything], name(string)

svmat ci_reg
gen bandwidth= 1 in 1
replace bandwidth = 2 in 2
replace bandwidth = 5 in 3
replace bandwidth = 10 in 4
replace bandwidth = $IK_bw in 5

	twoway (dot ci_reg2 bandwidth, ndots(0) mcolor(maroon) msymbol(X) msize(large)) || (rcap ci_reg1 ci_reg3 bandwidth, lcolor(gs8)) , ///
		xtitle("Distance to Border (in KM)", size(vsmall)) ///
		xlabel($IK_bw "IK=$IK_bw" 1 "1" 2 "2" 5 "5" 10 "10" , labsize(vsmall) angle(vertical)) ///
		ylabel(, labsize(vsmall)) yline(0, lcolor(gs13)) aspectratio(0.6) ///
		ytitle("Treatment Effect", size(vsmall)) name(assigned, replace) scheme(s1color) ///
		legend(label(1 "Treatment Effect") label(2 "95% CI") region(lwidth(none)) size(small)) ///
		title("`: variable label `name''" , size(small))
	
	graph save "./figures/coef/geo_`name'.gph", replace
	graph export "./figures/coef/geo_`name'.pdf", as(pdf) replace
end






****************************************************
* FIGURE 2 GEOGRAPHIC RD PANEL
* APPENDIX TABLES A3, A4, A5 Panel B
* APPENDIX TABLE A8
****************************************************
foreach x in mo_assigned lmo_tenure_uc mo_present_uc mo_mpa_direct_uc mo_mpa_uc {
clear matrix
	
* outcome
global outcome `x'
local iterations = 1000

use disc_final_geo.dta, clear

preserve
* IK bw selection
collapse (mean) $outcome (firstnm) npd, by(consid)
	qui rdbwselect $outcome npd, bwselect(IK) 
	local IK_bw = e(h_IK)
	di in red `IK_bw'
restore

* regressions
mat ci_reg = J(5,3,.)
est clear 

* IK 
foreach bw in 1 2 5 10 {
		spec, bw(`bw') control(x x2 x3 xy xy2 x2y y y2 y3)
		}

	g wIK=max(0,`IK_bw'-abs(npd)) if abs(npd)<=`IK_bw'
		specIK, bw(`IK_bw') control(x x2 x3 xy xy2 x2y y y2 y3)
		global IK_bw = round(`IK_bw', 0.01)			
		
	maketab, name("`x'") figure("yes")
}


****************************************************
* APPENDIX TABLE A13
****************************************************
local i = 1
while `i' <= 2  {

if `i'==1 {
	global functionalform = "x y"
	global name = "linear"
	}
	
if `i'==2 {
	global functionalform = "x y x2 y2 xy"
	global name = "quadratic"
	}

foreach x in mo_assigned lmo_tenure_uc mo_present_uc mo_mpa_direct_uc mo_mpa_uc {
	
* outcome
global outcome `x'
local iterations = 1000

use disc_final_geo.dta, clear

preserve
* IK bw selection
collapse (mean) $outcome (firstnm) npd, by(consid)
	qui rdbwselect $outcome npd, bwselect(IK)
	local IK_bw = e(h_IK)
	di in red `IK_bw'
restore

* regressions
mat ci_reg = J(5,3,.)
est clear 

di in red "$functionalform"

* IK 
foreach bw in 1 2 5 10 {
		spec, bw(`bw') control("$functionalform")
		}

	g wIK=max(0,`IK_bw'-abs(npd)) if abs(npd)<=`IK_bw'
		specIK, bw(`IK_bw') control("$functionalform")
		global IK_bw = round(`IK_bw', 0.01)			
		
	maketab, name("geo_`x'_$name") figure("no")
}

local ++i
	}


