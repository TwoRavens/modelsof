
clear

set mem 100m
set matsize 4000
set more off


local evt_window  "20 10 5" /*Vary the length of the event window to include as event day dummies*/
local estwindow = 180
local evtwindow = 30
local EVENT  "majorinitiative1summit" /*majorinitiative1, majorinitiative2, majorinitiative1summit, or majorinitiative2alt*/
local eveyear  "all" /*For majorinitiative1&2, estimate each event in 1996, 1999, 2005 separately, or all*/
local thintrade    = 0 /*0 (No thin trade) or 1*/
local controlevents = 1
local controlindustry = 1


use data_event_study_before_estimation_T_`estwindow'_`evtwindow'_thin`thintrade'_`EVENT', clear


*CREATE EVENT YEAR
gen tmp = year if event_trading_time==0
egen eventyear = min(tmp), by(panel_id)
drop tmp

if `thintrade' == 0 {
	replace R = R*100
	replace Rm = Rm*100
	replace R_group = R_group*100
}
if `thintrade'== 1 {
    replace Rindtt = Rindtt*100
    replace Rtt = Rtt*100
    replace Rmtt = Rmtt*100
}

if "`EVENT'"=="majorinitiative1" |"`EVENT'"=="majorinitiative1summit"  {
	drop if ticker=="GND" & eventyear==1996
	drop if event_time<-122 | event_time==. /*To be comparable to the portfolio approach*/
}
if "`EVENT'"=="majorinitiative2" | "`EVENT'"=="majorinitiative2alt" {
	drop if ticker=="ANG" & eventyear==1999
	drop if event_time<-122 | event_time==. /*To be comparable to the portfolio approach*/
}
if `thintrade'== 1 {
	if "`EVENT'"=="majorinitiative1" |"`EVENT'"=="majorinitiative1summit"  {
		drop if event_time>19 /*To be comparable to the portfolio approach*/
	}
}




if "`eveyear'" == "1996" {
	keep if eventyear==1996
}
if "`eveyear'" == "1999" {
	keep if eventyear==1999
}
if "`eveyear'" == "2005" {
	keep if eventyear==2005
}


if `controlindustry'==1 {
        if `thintrade'==0 {
            local industry "R_group"
        }
        else if `thintrade'==1 {
            local industry "Rindtt"
        }
}


local action ""
replace corporate_action = "0" if corporate_action==""


if `controlindustry'==1 {
	local industrycontrols "i.panel_id|`industry'"
}
else if `controlindustry'==0 {
	local industrycontrols ""
}



tab event_time if abs(event_time)<=20, gen(Devent)
if "`EVENT'"=="majorinitiative1summit" & `thintrade'== 0  {
	drop Devent41
}
if "`EVENT'"=="majorinitiative1" |"`EVENT'"=="majorinitiative1summit"  {
	local neventdummies = 40 /*For majorinitiative1, original data has [-20, +19] event window form 180 calendar day estimation window and 30 calendar day estimation window*/
}
if "`EVENT'"=="majorinitiative2" | "`EVENT'"=="majorinitiative2alt" {
	local neventdummies = 41
}


matrix A1 = J(`neventdummies',9,.)		


local m = 0

foreach e of local evt_window { /*Robust check of the length of the event window*/

	local start = 21-`e'
	local end = 21+`e'
	drop if event_time>`e'
	
	forv i==1/`neventdummies' {
		replace Devent`i' = 0 if Devent`i' == .
		if `i' < `start' | `i' > `end' {
			replace Devent`i' = 0 if Devent`i' == 1
		}
	}
	
	
	*=======================================================================================================
	*REGRESSIONS with all coefficients panel_id specific (except event time dummies)
	*=======================================================================================================

	*I. NO-THIN TRADE ISSUES
	*-------------------------------------------------------------------------------------------------------

	if `thintrade'== 0 {
	*================================================================================
	*1. Baseline specification (i.e., no addiitonal time dummy variables)
	*================================================================================
	xi: reg  R  i.panel_id*Rm  `industrycontrols'  i.panel_id*i.corporate_action  Devent*, cluster(date) r
	
	if `e'==20 {
		outreg Devent* using Regression_Approach_robust_evtwindow_`eveyear'_`EVENT'.txt, se 3aster coefast nolabel ctitle(`e') replace
	}
	else {
		outreg Devent* using Regression_Approach_robust_evtwindow_`eveyear'_`EVENT'.txt, se 3aster coefast nolabel ctitle(`e') append
	}
	
	
	*Building CAR and their standard errors

	forv i==1/`neventdummies' {
 		if `i'== `start' {
			matrix A1[`i',`m'+1] = _b[Devent`start']
			matrix A1[`i',`m'+2] = _se[Devent`start']
			matrix A1[`i',`m'+3] = 2*ttail(e(df_r),abs(_b[Devent`start']/_se[Devent`start']))
		}
		else if `i' >`start' & `i' <= `end' {
			local exp "Devent`start'"
			local k = `start'+1
			forv j == `k'/`i' {
				local exp "`exp' + Devent`j'"
			}

			qui lincom `exp'
			matrix A1[`i',`m'+1] = r(estimate)
			matrix A1[`i',`m'+2] = r(se)
			matrix A1[`i',`m'+3] = 2*ttail(r(df),abs(r(estimate)/r(se)))
		}
	}
}


	*II. THIN TRADE ISSUES
	*-------------------------------------------------------------------------------------------------------

	if `thintrade'== 1 {

	*================================================================================
	*1. Baseline specification (i.e., no addiitonal time dummy variables)
	*================================================================================
	xi: reg  Rtt  i.panel_id*ntt  i.panel_id|Rmtt  `industrycontrols'  i.panel_id*i.corporate_action  Devent*, cluster(date) r

	if `e'==20 {
		outreg Devent* using Regression_Approach_robust_evtwindow_thin_`eveyear'_`EVENT'.txt, se 3aster coefast nolabel ctitle(`e') replace
	}
	else {
		outreg Devent* using Regression_Approach_robust_evtwindow_thin_`eveyear'_`EVENT'.txt, se 3aster coefast nolabel ctitle(`e') append
	}
	
	
	*Building CAR and their standard errors

	forv i==1/`neventdummies' {
 		if `i'== `start' {
			matrix A1[`i',`m'+1] = _b[Devent`start']
			matrix A1[`i',`m'+2] = _se[Devent`start']
			matrix A1[`i',`m'+3] = 2*ttail(e(df_r),abs(_b[Devent`start']/_se[Devent`start']))
		}
		else if `i' >`start' & `i' <= `end' {
			local exp "Devent`start'"
			local k = `start'+1
			forv j == `k'/`i' {
				local exp "`exp' + Devent`j'"
			}

			qui lincom `exp'
			matrix A1[`i',`m'+1] = r(estimate)
			matrix A1[`i',`m'+2] = r(se)
			matrix A1[`i',`m'+3] = 2*ttail(r(df),abs(r(estimate)/r(se)))
		}
	}
}

local m = `m'+3

}


mat list A1

*log close


keep if event_time>=-20 & event_time<=20
keep event_time
by event_time, sort: gen id = _n
keep if id==1
svmat A1, names( col )


forv i==1/3 {
	local m1 = ( `i'-1)*3+1
	local m2 = ( `i'-1)*3+2
	local m3 = ( `i'-1)*3+3
	rename c`m1' car`i'
	rename c`m2' se`i'
	rename c`m3' p`i'

	gen star`i' = car`i'  if p`i' <=0.1
}


sort event_time


if `thintrade'== 0 {
	saveold Regression_Approach_robust_evtwindow_car_`eveyear'_`EVENT', replace
}
if `thintrade'== 1 {
	saveold Regression_Approach_robust_evtwindow_thin_car_`eveyear'_`EVENT', replace
}



replace event_time = event_time[_n-1]+1 if event_time==.

twoway (line car1 event_time, lpattern(solid) lcolor(navy) lwidth(medium)) ///
(line car2 event_time, lpattern(longdash_shortdash) lcolor(maroon) lwidth(medium)) ///
(line car3 event_time, lpattern(vshortdash) lcolor(green) lwidth(medium)) ///
(scatter star1 event_time, mcolor(red) msymbol(lgx)) ///
(scatter star2 event_time, mcolor(red) msymbol(lgx)) ///
(scatter star3 event_time, mcolor(red) msymbol(lgx)) ///
, yline(0, lwidth(vvthin)) /*yscale(range(0 0.01))*/ ytitle(Cumulative abnormal return, margin(medium)) xtitle(Event time, margin(medium)) legend(off)

gr save Appendix_Fig_A1_B, replace
