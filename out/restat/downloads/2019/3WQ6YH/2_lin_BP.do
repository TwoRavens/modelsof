*-------------------------------------------------------------------------------
* Heterogenous Relative Government Spending Multipliers in the Era Surrounding the Great Recession
* Forthcoming in the Review of Economics and Statistics
* by Marco Bernardini, Selien De Schryder and Gert Peersman (fall 2018)
*
* This file relates to figure 2
*-------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////
* 1) SETTINGS
////////////////////////////////////////////////////////////////////////////////
****************************
* housekeeping and loading *
****************************

* settings
clear all // clear memory 
cls // clear results window
set more off // do not display the "more" message
set matsize 300 // maximum number of variables in the model
set graphics off // do (not) show graphics in STATA
pause off // do (not) pause
adopath ++ PLUS

* globals
global expe "lin_BP" // name of the experiment


* dataset
use "${path}panel_Q.dta", clear
keep stateid statename quarter gdprea govrea // keep only analyzed variables
tsset stateid quarter


********************************************
* set parameters that govern specification *
********************************************

global p=4 //lag order
global hor=8 // maximum horizon
global band 68 90 // 68 (1SD), 90 (btw 1 and 2 SD), 95 (2SD)

global exerc_mar sdA // exercises (margins)
global begsample=2005 // beginning of the sample (2005q1 earliest)
global endsample=2015 // end of the sample (2015q4 latest)

***************************
* construct raw variables *
***************************

* state-level NIPA variables
rename gdprea y			// state-level real GDP
rename govrea g			// state-level real government production
tsfilter hp cycle = y, smooth(1e6) trend(pot) // variable used to express changes in the same units
drop cycle

* fix analyzed sample
drop if  quarter<tq(${begsample}q1) // define the final sample (start)
drop if  quarter>tq(${endsample}q4) // define the final sample (end)

*****************************
* construct final variables *
*****************************

* LHS variables and reference for RHS lagged controls
foreach var in y g { // compute var_h for h=0,...,H
	forvalues j=0/$hor {
		gen `var'`j' = (F`j'.`var'-L.`var')/L.pot // DIFF(t+h - t-1) scaled by predet potential GDP (t-1)
	}
}

foreach var in y g { // cumulative LHS variables
	qui gen cum_`var'=0
	forvalues i=0/$hor {
		gen cum`i'_`var'=`var'`i'+cum_`var'
		replace cum_`var'=cum`i'_`var'
	}
	drop cum_`var'
}

gen sample=.
replace sample=1 if g${hor}!=. & y${hor}!=. & L${p}.y0!=. & L${p}.g0!=. // estimation sample (fixed along the horizon H)

* useful variables
by stateid: gen t = _n // count observations by ID
gen h=t-1 // horizon

* RHS variables (centered wrt deterministic variables -> only important for the nonlinear model)
** state variables
* define final states of the economy
gen sdA = 1													if sample==1 // linear model
local totstat sdA // analyzed states

pause
** lagged controls
foreach state in `totstat' {
	forvalues j=1/$p {
		capture drop l`j'g0 l`j'y0
		*
		qui reg L`j'.g0 i.stateid i.quarter if sample==1
		predict l`j'g0 if sample==1, r // centering
		gen l`j'g0_`state'=l`j'g0*`state'
		*
		qui reg L`j'.y0 i.stateid i.quarter if sample==1
		predict l`j'y0 if sample==1, r // centering
		gen l`j'y0_`state'=l`j'y0*`state'
		*
		local ctrs `ctrs' l`j'g0_`state' l`j'y0_`state'
	}
}

** shocks
qui reg g0 i.stateid i.quarter l1g0 l1y0 l2g0 l2y0 l3g0 l3y0 l4g0 l4y0 if sample==1 // fiscal rule + centering
predict shock if sample==1, r // residual
foreach state in `totstat' {
	gen shock_`state'=shock*`state' // state-dependent shocks							  
}
pause
* Pre-storage final objects
foreach ex_m in $exerc_mar {
** A) Cumulative multipliers
	*** 1-STEP (PEs and SEs)
	qui gen bmar`ex_m'=.
	qui gen semar`ex_m'=.
	foreach cint in $band {
		qui gen lomar`ex_m'_`cint'=.
		qui gen upmar`ex_m'_`cint'=.
	}

** B) IRFs
	foreach var in y g {
		qui gen b_`var'=.
		qui gen se_`var'=.
		foreach cint in $band {
			qui gen lo_`var'_`cint'=.
			qui gen up_`var'_`cint'=.
		}
	}
}

gen Fsta = .

////////////////////////////////////////////////////////////////////////////////
* 2) DIRECT ESTIMATION
////////////////////////////////////////////////////////////////////////////////

forvalues i=0/$hor {
	capture drop cumfit_g_sdA
	local ord=`i'+1 // ord='i'+1 in ivreg2 is equivalent to ord='i' in xtscc (check "help ivreg2")
	global i=`i'

	** LP-IV
	qui reg cum`i'_g i.stateid i.quarter if sample==1
	predict cum`i'_gp if sample==1, r // centering
	gen cumfit_g_sdA = cum`i'_gp*sdA

	ivreg2 cum`i'_y (cumfit_g_sdA = shock_sdA) `ctrs' i.stateid i.quarter if sample==1, dkraay(`ord') partial(`ctrs' i.stateid i.quarter)

	** storing
	local kpar = e(df_m)+1 // save # estimated parameters
	estadd scalar par = `kpar' // store # estimated parameters
	eststo	tabout_`i' // store regression output
	
	** exercises
	* base and marginal effects
	qui gen Fsta`i' = e(widstat)
	lincom cumfit_g_sdA
	qui gen bmarsdA`i' = r(estimate)
	qui gen semarsdA`i'= r(se)

	qui replace Fsta = Fsta`i'	if h==`i' // & Fsta`i'<80 & Fsta`i'!=.
	foreach ex_m in $exerc_mar { // marginal effects
		qui replace bmar`ex_m'=bmar`ex_m'`i' if h==`i'
		qui replace semar`ex_m'=semar`ex_m'`i' if h==`i'
		foreach cint in $band {
			qui replace upmar`ex_m'_`cint'=bmar`ex_m'+invnormal((100+`cint')/2/100)*semar`ex_m' if h==`i'
			qui replace lomar`ex_m'_`cint'=bmar`ex_m'-invnormal((100+`cint')/2/100)*semar`ex_m' if h==`i'
		}
	}
	local tabout `tabout' tabout_`i'
}

////////////////////////////////////////////////////////////////////////////////
* 3) DECOMPOSITION
////////////////////////////////////////////////////////////////////////////////

forvalues i=0/$hor {
	foreach var in y g {
		ivreg2 `var'`i' shock_sdA `ctrs' i.stateid i.quarter if sample==1, dkraay(`ord') partial(`ctrs' i.stateid i.quarter)
	* individual responses
		gen b`var'h`i'_sdA=_b[shock_sdA]
		gen se`var'h`i'_sdA=_se[shock_sdA]
		qui replace b_`var'=b`var'h`i'_sdA if h==`i'
		qui replace se_`var'=se`var'h`i'_sdA if h==`i'
		foreach cint in $band {
			qui replace up_`var'_`cint'=b`var'h`i'_sdA+invnormal((100+`cint')/2/100)*se`var'h`i'_sdA if h==`i'
			qui replace lo_`var'_`cint'=b`var'h`i'_sdA-invnormal((100+`cint')/2/100)*se`var'h`i'_sdA if h==`i'
		}			
	}
}

////////////////////////////////////////////////////////////////////////////////
* 4) OUTPUT
////////////////////////////////////////////////////////////////////////////////

** Table

esttab `tabout' using "${path}output\tab2_${expe}.tex", ///
replace page(lscape) se nonum b(2) se(2) sfmt(2) obslast label nonotes ///
keep(cumfit_g_sdA) ///
nostar scalars("par Parameters")
local tabout

local ty "gross domestic product"
local tg "government value added"

** Figure
gen zero=0
twoway (rarea upmarsdA_90 lomarsdA_90  h if stateid==1 & t<=${hor}+1, ///
		fcolor(gs14) lcolor(gs13) lpattern(solid)) ///
	   (rarea upmarsdA_68 lomarsdA_68  h if stateid==1 & t<=${hor}+1, ///
		fcolor(gs10) lcolor(gs10) lpattern(solid)) ///
		(line bmarsdA h if stateid==1 & t<=${hor}+1, lpattern(solid) lwidth(thick) color(forest_green)) ///	
		(pcarrowi 0 0 0 8, lcolor(black) lpattern(shortdash) mcolor(black) msize(zero)), ///
		legend(off) name(fig_mult,replace) title("cumulative multiplier",size(medlarge)) ///
		graphregion(color(white)) plotregion(color(white)) xsize(7) ysize(5) ///
		xla(0(1)${hor},grid) yla(,grid) ytitle("Size")  xtitle("Horizon")
		
graph export "${path}output\2_${expe}.pdf", replace name(fig_mult)
graph export "${path}output\2_${expe}.eps", replace
graph save "${path}output\2_${expe}.gph", replace 

gen Fstabis = Fsta if h<=1
replace Fstabis = F.Fstabis if h==0

twoway		(line Fstabis h if stateid==1 & t<=${hor}+1, lpattern(shortdash) lwidth(thick) color(midblue)) ///
			(line Fsta h if stateid==1 & t>=1 & t<=${hor}+1, lpattern(solid) lwidth(thick) color(midblue)) ///
			(pcarrowi 0 0 0 8, lcolor(black) lpattern(shortdash) mcolor(black) msize(zero)), ///
			legend(off) name(figsta,replace) title("F-statistics",size(medlarge)) ///
			graphregion(color(white)) plotregion(color(white)) ///
			xla(0(1)${hor},grid labsize(medium)) ytitle("Size",size(medium))  xtitle("Horizon",size(medium)) yla(,grid)
			
graph export "${path}output\2_${expe}_Fstat.pdf", replace name(figsta)
graph export "${path}output\2_${expe}_Fstat.eps", replace
graph save "${path}output\2_${expe}_Fstat.gph", replace 

foreach var in y g {
	twoway (rarea up_`var'_90 lo_`var'_90 h if stateid==1 & t<=${hor}+1, ///
			fcolor(gs14) lcolor(gs13) lpattern(solid)) ///
		   (rarea up_`var'_68 lo_`var'_68  h if stateid==1 & t<=${hor}+1, ///
			fcolor(gs10) lcolor(gs10) lpattern(solid)) ///
			(line b_`var' h if stateid==1 & t<=${hor}+1, lpattern(solid) lwidth(thick) color(orange)) ///
			(pcarrowi 0 0 0 8, lcolor(black) lpattern(shortdash) mcolor(black) msize(zero)), ///
			legend(off) name(fig_`var',replace) title("response of `t`var''",size(medium)) ///
			graphregion(color(white)) plotregion(color(white)) xsize(7) ysize(5) ///
			xla(0(1)${hor},grid) yla(,grid) ytitle("Size")  xtitle("Horizon")
}

graph combine fig_g fig_y, xcommon ycommon c(2) imargin(small) ///
graphregion(color(white)) plotregion(color(white)) xsize(7) ysize(5) name(fig_gy)

graph export "${path}output\2_${expe}_gy.pdf", replace name(fig_gy)
graph export "${path}output\2_${expe}_gy.eps", replace
graph save "${path}output\2_${expe}_gy.gph", replace


** Save baseline multiplier values
keep stateid quarter h bmarsdA
rename bmarsdA BP_bmarsdA
save "${path}output\mult_${expe}.dta", replace
