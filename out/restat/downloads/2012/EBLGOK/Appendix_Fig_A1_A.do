****This is essentially the same file as Regression_Approach_Final_baseline_majorinitiatives.do
****Use this only for robustness check for the estimation window

clear

set mem 100m
set matsize 4000
set more off

local evt_window = 10 /*Define the width of event dates to include as event day dummies*/
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


*tabstat event_time, by(panel_id) stat(min max N)
*exit


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


*Create event time dummies according to the desired window

gen year1= year(date)
replace year=0 if year==.

gen month = month(date)
replace month=0 if month==.

gen day1 = day
replace day1=0 if day1==.

gen Dmonth= mofd(date)
gen Dweek= wofd(date)


if `controlindustry'==1 {
	local industrycontrols "i.panel_id|`industry'"
}
else if `controlindustry'==0 {
	local industrycontrols ""
}

tab event_time if abs(event_time)<=`evt_window' & event_window==1, gen(Devent)
local neventdummies = 2*`evt_window'+1
forv i==1/`neventdummies' {
		replace Devent`i' = 0 if Devent`i' == .
}

drop if event_time > `evt_window'
*exit


/*Robust check of the length of the estimation window*/
su event_time
local mintime = r(min)
local maxtime = -`evt_window' - 50
local robust = 10


matrix A1 = J(`neventdummies',floor((`maxtime'-`mintime')/`robust'+1)*3,.)		

*=======================================================================================================
*REGRESSIONS with all coefficients panel_id specific (except event time dummies)
*=======================================================================================================

*I. NO-THIN TRADE ISSUES
*-------------------------------------------------------------------------------------------------------

if `thintrade'== 0 {
*================================================================================
*1. Baseline specification (i.e., no addiitonal time dummy variables)
*================================================================================
local m = 0

forv n==`mintime'(`robust')`maxtime' {

	xi: reg  R  i.panel_id*Rm  `industrycontrols'  i.panel_id*i.corporate_action  Devent* if event_time>=`n', cluster(date) r

	local diff10 = (_b[Devent11]+_b[Devent12]+_b[Devent13]+_b[Devent14]+_b[Devent15]+_b[Devent16]+_b[Devent17]+_b[Devent18]+_b[Devent19]+_b[Devent20]+_b[Devent21])/11 ///
			  - (_b[Devent1]+_b[Devent2]+_b[Devent3]+_b[Devent4]+_b[Devent5]+_b[Devent6]+_b[Devent7]+_b[Devent8]+_b[Devent9]+_b[Devent10])/10
	test (Devent1+Devent2+Devent3+Devent4+Devent5+Devent6+Devent7+Devent8+Devent9+Devent10)/10 ///
		= (Devent11+Devent12+Devent13+Devent14+Devent15+Devent16+Devent17+Devent18+Devent19+Devent20+Devent21)/11
	local F1 = r(F)
	local p1 = r(p)

	local diff5 = (_b[Devent11]+_b[Devent12]+_b[Devent13]+_b[Devent14]+_b[Devent15]+_b[Devent16])/6 ///
			  - (_b[Devent6]+_b[Devent7]+_b[Devent8]+_b[Devent9]+_b[Devent10])/5
	test (Devent6+Devent7+Devent8+Devent9+Devent10)/5 = (Devent11+Devent12+Devent13+Devent14+Devent15+Devent16)/6
	local F2 = r(F)
	local p2 = r(p)

	local diff3 = (_b[Devent11]+_b[Devent12]+_b[Devent13]+_b[Devent14])/4 - (_b[Devent8]+_b[Devent9]+_b[Devent10])/3
	test (Devent8+Devent9+Devent10)/3 = (Devent11+Devent12+Devent13+Devent14)/4

	
	if `m'==0 {
		outreg Devent* using Regression_Approach_Final_`eveyear'_`EVENT'.txt, se 3aster coefast nolabel ctitle(`n') ///
		addstat(-10to-1vs0to10, `diff10', F test, `F1', Prob>F, `p1', -5to-1vs0to5, `diff5', F test, `F2', Prob>F, `p2', -3to-1vs0to3, `diff3', F test,  r(F), Prob>F, r(p)) ///
		adec(5, 3, 3, 5, 3, 3, 5, 3, 3) replace
	}
	else {
		outreg Devent* using Regression_Approach_Final_`eveyear'_`EVENT'.txt, se 3aster coefast nolabel ctitle(`n') ///
		addstat(-10to-1vs0to10, `diff10', F test, `F1', Prob>F, `p1', -5to-1vs0to5, `diff5', F test, `F2', Prob>F, `p2', -3to-1vs0to3, `diff3', F test,  r(F), Prob>F, r(p)) ///
		adec(5, 3, 3, 5, 3, 3, 5, 3, 3) append
	}
	
	
	*Building CAR and their standard errors

	forv i==1/`neventdummies' {
		if `i'==1 {
			matrix A1[`i',`m'+1] = _b[Devent1]
			matrix A1[`i',`m'+2] = _se[Devent1]
			matrix A1[`i',`m'+3] = 2*ttail(e(df_r),abs(_b[Devent1]/_se[Devent1]))
		}
		else {
			local exp "Devent1"

			forv j == 2/`i' {
				local exp "`exp' + Devent`j'"
			}

			qui lincom `exp'
			matrix A1[`i',`m'+1] = r(estimate)
			matrix A1[`i',`m'+2] = r(se)
			matrix A1[`i',`m'+3] = 2*ttail(r(df),abs(r(estimate)/r(se)))
		}
	}

local m = `m'+3

}


}



*II. THIN TRADE ISSUES
*-------------------------------------------------------------------------------------------------------


if `thintrade'== 1 {

*================================================================================
*1. Baseline specification (i.e., no addiitonal time dummy variables)
*================================================================================
local m = 0

forv n==`mintime'(`robust')`maxtime' {

	xi: reg  Rtt  i.panel_id*ntt  i.panel_id|Rmtt  `industrycontrols'  i.panel_id*i.corporate_action  Devent* if event_time>=`n', cluster(date) r

	local diff10 = (_b[Devent11]+_b[Devent12]+_b[Devent13]+_b[Devent14]+_b[Devent15]+_b[Devent16]+_b[Devent17]+_b[Devent18]+_b[Devent19]+_b[Devent20]+_b[Devent21])/11 ///
			  - (_b[Devent1]+_b[Devent2]+_b[Devent3]+_b[Devent4]+_b[Devent5]+_b[Devent6]+_b[Devent7]+_b[Devent8]+_b[Devent9]+_b[Devent10])/10
	test (Devent1+Devent2+Devent3+Devent4+Devent5+Devent6+Devent7+Devent8+Devent9+Devent10)/10 ///
		= (Devent11+Devent12+Devent13+Devent14+Devent15+Devent16+Devent17+Devent18+Devent19+Devent20+Devent21)/11
	local F1 = r(F)
	local p1 = r(p)

	local diff5 = (_b[Devent11]+_b[Devent12]+_b[Devent13]+_b[Devent14]+_b[Devent15]+_b[Devent16])/6 ///
			  - (_b[Devent6]+_b[Devent7]+_b[Devent8]+_b[Devent9]+_b[Devent10])/5
	test (Devent6+Devent7+Devent8+Devent9+Devent10)/5 = (Devent11+Devent12+Devent13+Devent14+Devent15+Devent16)/6
	local F2 = r(F)
	local p2 = r(p)

	local diff3 = (_b[Devent11]+_b[Devent12]+_b[Devent13]+_b[Devent14])/4 - (_b[Devent8]+_b[Devent9]+_b[Devent10])/3
	test (Devent8+Devent9+Devent10)/3 = (Devent11+Devent12+Devent13+Devent14)/4

	if `m'==0 {
		outreg Devent* using Regression_Approach_Final_thin_`eveyear'_`EVENT'.txt, se 3aster coefast nolabel ctitle(`n') ///
		addstat(-10to-1vs0to10, `diff10', F test, `F1', Prob>F, `p1', -5to-1vs0to5, `diff5', F test, `F2', Prob>F, `p2', -3to-1vs0to3, `diff3', F test,  r(F), Prob>F, r(p)) ///
		adec(5, 3, 3, 5, 3, 3, 5, 3, 3) replace
	}
	else {
		outreg Devent* using Regression_Approach_Final_thin_`eveyear'_`EVENT'.txt, se 3aster coefast nolabel ctitle(`n') ///
		addstat(-10to-1vs0to10, `diff10', F test, `F1', Prob>F, `p1', -5to-1vs0to5, `diff5', F test, `F2', Prob>F, `p2', -3to-1vs0to3, `diff3', F test,  r(F), Prob>F, r(p)) ///
		adec(5, 3, 3, 5, 3, 3, 5, 3, 3) append
	}
	
	
	*Building CAR and their standard errors

	forv i==1/`neventdummies' {
		if `i'==1 {
			matrix A1[`i',`m'+1] = _b[Devent1]
			matrix A1[`i',`m'+2] = _se[Devent1]
			matrix A1[`i',`m'+3] = 2*ttail(e(df_r),abs(_b[Devent1]/_se[Devent1]))
		}
		else {
			local exp "Devent1"

			forv j == 2/`i' {
				local exp "`exp' + Devent`j'"
			}

			qui lincom `exp'
			matrix A1[`i',`m'+1] = r(estimate)
			matrix A1[`i',`m'+2] = r(se)
			matrix A1[`i',`m'+3] = 2*ttail(r(df),abs(r(estimate)/r(se)))
		}
	}

local m = `m'+3

}


}


mat list A1


egen id = group(panel_id)
keep if id==1
keep if event_time>=-10 & event_time<=10
keep event_time
svmat A1, names( col )


local max = floor((`maxtime'-`mintime')/`robust'+1)

forv i==1/`max' {
	local m1 = ( `i'-1)*3+1
	local m2 = ( `i'-1)*3+2
	local m3 = ( `i'-1)*3+3
	rename c`m1' car`i'
	rename c`m2' se`i'
	rename c`m3' p`i'

	gen star`i' = car`i'  if p`i' <=0.1
}

di `max'

sort event_time

if `thintrade'== 0 {
	saveold Regression_Approach_CAR_`eveyear'_`EVENT', replace
}
if `thintrade'== 1 {
	saveold Regression_Approach_CAR_thin_`eveyear'_`EVENT', replace
}


if `thintrade' == 1 {
	local thin "_thin"
}

use Regression_Approach_CAR`thin'_`eveyear'_`EVENT', clear

forv n=1/21 {
	 replace event_time = `n'-11 in `n'
}

twoway ///
(rarea car1 car2 event_time, fcolor(gs12) lpattern(longdash_shortdash) lcolor(navy) lwidth(medium)) ///
(rarea car2 car3 event_time, fcolor(gs12) lpattern(longdash_shortdash) lcolor(navy) lwidth(medium)) ///
(rarea car3 car4 event_time, fcolor(gs12) lpattern(longdash_shortdash) lcolor(navy) lwidth(medium)) ///
(rarea car4 car5 event_time, fcolor(gs12) lpattern(longdash_shortdash) lcolor(navy) lwidth(medium)) ///
(rarea car5 car6 event_time, fcolor(gs12) lpattern(longdash_shortdash) lcolor(navy) lwidth(medium)) ///
(rarea car6 car7 event_time, fcolor(gs12) lpattern(longdash_shortdash) lcolor(navy) lwidth(medium)) ///
(scatter star1 event_time, mcolor(red) msymbol(lgx)) ///
(scatter star2 event_time, mcolor(red) msymbol(lgx)) (scatter star3 event_time, mcolor(red) msymbol(lgx)) ///
(scatter star4 event_time, mcolor(red) msymbol(lgx)) (scatter star5 event_time, mcolor(red) msymbol(lgx)) ///
(scatter star6 event_time, mcolor(red) msymbol(lgx)) (scatter star7 event_time, mcolor(red) msymbol(lgx)) ///
(line car1 event_time, lcolor(navy) lwidth(thick)) ///
(line car2 event_time, lpattern(longdash_shortdash) lcolor(navy) lwidth(medium)) ///
(line car3 event_time, lpattern(longdash_shortdash) lcolor(navy) lwidth(medium)) ///
(line car4 event_time, lpattern(longdash_shortdash) lcolor(navy) lwidth(medium)) ///
(line car5 event_time, lpattern(longdash_shortdash) lcolor(navy) lwidth(medium)) ///
(line car6 event_time, lpattern(longdash_shortdash) lcolor(navy) lwidth(medium)) ///
(line car7 event_time, lpattern(longdash_shortdash) lcolor(navy) lwidth(medium)) ///
, yline(0, lwidth(vvthin)) /*yscale(range(0 0.01))*/ ytitle(Cumulative abnormal return, margin(medium)) xtitle(Event time, margin(medium)) legend(off)

gr save Appendix_Fig_A1_A, replace
