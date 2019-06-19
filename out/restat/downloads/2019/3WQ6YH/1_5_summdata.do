*-------------------------------------------------------------------------------
* Heterogenous Relative Government Spending Multipliers in the Era Surrounding the Great Recession
* Forthcoming in the Review of Economics and Statistics
* by Marco Bernardini, Selien De Schryder and Gert Peersman (fall 2018)
*
* This file generates figures 1 and 5
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
set graphics off // do (not) show graphics in STATA
pause off // do (not) pause
adopath ++ PLUS

* globals
global expe "summdata" // name of the experiment


* dataset
use "${path}panel_Q.dta", clear
keep stateid statename quarter gdprea govrea mor_dti // keep only analyzed variables
tsset stateid quarter

********************************************
* set parameters that govern specification *
********************************************

global p=4   //lag order
global hor=8 // maximum horizon
global band 68 90 // 68 (1SD), 90 (btw 1 and 2 SD), 95 (2SD)

global exerc_mar sdA // exercises (margins)
global begsample=2005 // beginning of the sample (2005q1 earliest)
global endsample=2015 // end of the sample (2015q4 latest)

***************************
* construct raw variables *
***************************

* state-level NIPA variables
rename gdprea y	// state-level real GDP
rename govrea g // state-level real government production

* economic states
gen lgdp=100*log(y) // log quarterly GDP
gen growth=(lgdp - L1.lgdp)
gen rec=0
replace rec=1	if growth<0 & growth!=.
replace rec=0	if L.rec==0 & rec==1 & F.rec==0
gen deprec=0
sum growth			if growth<0, detail
replace deprec=1	if growth<r(mean) & growth!=.
replace deprec=0	if L.deprec==0 & deprec==1 & F.deprec==0
by stateid: ipolate mor_dti quarter, gen(mor_dti_int)
gen debt = mor_dti_int // household debt-to-income

* fix analyzed sample
drop if  quarter<tq(${begsample}q1) // define the final sample (start)
drop if  quarter>tq(${endsample}q4) // define the final sample (end)

*****************************
* construct final variables *
*****************************

* LHS variables and reference for RHS lagged controls
foreach var in y g { // compute var_h for h=0,...,H
	forvalues j=0/$hor {
		gen `var'`j' = (F`j'.`var'-L.`var')/L.`var' // CHANGE(t+h - t-1)
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

*******************************************************************

gen sg0=100*g0
gen sy0=100*y0
sum sg0 sy0 mor_dti_int if sample==1

global varfig sg0 sy0 mor_dti_int

local tit_sg0 = "government value added" // growth rate scaled by gdp
local tit_sy0 = "gross domestic product" // growth rate scaled by gdp
local tit_mor_dti_int "household debt"
local tit_rec "recessions"
local tit_extrec "recessions"
*
local sg0_yla = "Percent change"
local sy0_yla = "Percent change"
local mor_dti_int_yla = "Percent of income"
local rec_yla = "Percent share of US States"
*
local sy0_ra -5 8
local sg0_ra -1 2
local mort_dti_ra 30 110
*
local sy0_la -5(1)8
local sg0_la -1(0.5)2
local mor_dti_int_la 30(10)110

foreach vvv in $varfig {
		gen `vvv'_mean=.
	foreach nnn in 30 60 90 {
		gen `vvv'_`nnn'low=.
		gen `vvv'_`nnn'hig=.

	}
}

local tA=tq(2005q1)
local tB=tq(2007q1)
local tC=tq(2009q1)
local tD=tq(2011q1)
local tE=tq(2013q1)
local tF=tq(2015q1)
local xtime `tA' "05Q1" `tB' "07Q1" `tC' "09Q1" `tD' "11Q1" `tE' "13Q1" `tF' "15Q1"
local start=tq(${begsample}q1)
local end=tq(${endsample}q4)

forvalues qqq=`start'/`end' {
	foreach vvv in $varfig {
		sum `vvv' if quarter==`qqq', detail
		pause
		replace `vvv'_mean	=r(mean) if quarter==`qqq'
		*
		capture drop p30low p30hig p60low p60hig p90low p90hig
		egen p30low=pctile(`vvv') if quarter==`qqq',p(35)
		egen p30hig=pctile(`vvv') if quarter==`qqq',p(65)
		egen p60low=pctile(`vvv') if quarter==`qqq',p(20)
		egen p60hig=pctile(`vvv') if quarter==`qqq',p(80)
		egen p90low=pctile(`vvv') if quarter==`qqq',p(5)
		egen p90hig=pctile(`vvv') if quarter==`qqq',p(95)
		replace `vvv'_30low	=p30low  if quarter==`qqq'
		replace `vvv'_30hig	=p30hig  if quarter==`qqq'
		replace `vvv'_60low	=p60low  if quarter==`qqq'
		replace `vvv'_60hig	=p60hig  if quarter==`qqq'
		replace `vvv'_90low	=p90low  if quarter==`qqq'
		replace `vvv'_90hig	=p90hig  if quarter==`qqq'
	}
}
*

foreach vvv in $varfig {
twoway	(rarea `vvv'_90low `vvv'_90hig  quarter if stateid==1, ///
		fcolor(gs14) lcolor(gs14) lpattern(solid)) ///
		(rarea `vvv'_60low `vvv'_60hig quarter if stateid==1, ///
		fcolor(gs12) lcolor(gs12) lpattern(solid)) ///
		(rarea `vvv'_30low `vvv'_30hig  quarter if stateid==1, ///
		fcolor(gs10) lcolor(gs10) lpattern(solid)) ///
		(line `vvv'_mean quarter if stateid==1, lpattern(solid) lwidth(thick) color(forest_green)), ///
		legend(off) name(`vvv') title(`tit_`vvv'',size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white)) ///
		xla(`xtime',grid labsize(small)) yla(#10,grid labsize(small)) ytitle(``vvv'_yla',size(medsmall))  xtitle("Time",size(medsmall)) // yla(-3(1)2.5,grid) ysc(r(-3 2.5))
}

*
sort quarter stateid
by quarter: egen recf = sum(rec)
sort stateid quarter
replace recf=100*recf/51
*
sort quarter stateid
by quarter: egen extrecf = sum(deprec)
sort stateid quarter
replace extrecf=100*extrecf/51

twoway 	(bar recf quarter if stateid==1) ///
		(bar extrecf quarter if stateid==1), ///
		legend(ring(0) position(1) fcolor(background) region(lstyle(none) lcolor(white)) symxsize(*.3) size(small) cols(1) label(1 "all") label(2 "deep")) ///
		name(rec) title(`tit_rec',size(medsmall)) ///
		graphregion(color(white)) plotregion(color(white)) ///
		xla(`xtime',grid labsize(small)) ysc(ra(0(10)85)) yla(0(10)100,grid labsize(small)) ytitle(`rec_yla',size(medsmall))  xtitle("Time",size(medsmall)) // yla(-3(1)2.5,grid) ysc(r(-3 2.5))	
		
graph combine sg0 sy0, c(2) ///
imargin(small) iscale(*1.0) name(fig1) ycommon xcommon ///
graphregion(color(white) margin(0 0 0 0)) plotregion(color(white) margin(0 0 0 0)) xsize(7) ysize(7)
graph export "${path}output\1_${expe}.pdf", replace
graph export "${path}output\1_${expe}.eps", replace
graph save "${path}output\1_${expe}.gph", replace

graph combine rec mor_dti_int, c(2) ///
imargin(small) iscale(*1.0) name(fig3) ///
graphregion(color(white) margin(0 0 0 0)) plotregion(color(white) margin(0 0 0 0)) xsize(7) ysize(7)
graph export "${path}output\5_${expe}.pdf", replace
graph export "${path}output\5_${expe}.eps", replace
graph save "${path}output\5_${expe}.gph", replace
