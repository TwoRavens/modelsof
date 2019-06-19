****Robustness check for different sample groups

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


if "`EVENT'"=="majorinitiative1"| "`EVENT'"=="majorinitiative1summit"{
	drop if ticker=="GND" & eventyear==1996 
	drop if event_time<-122 | event_time==. /*To be comparable to the portfolio approach*/
}
if "`EVENT'"=="majorinitiative2"|"`EVENT'"=="majorinitiative2alt" {
	drop if ticker=="ANG" & eventyear==1999 
	drop if event_time<-122 | event_time==. /*To be comparable to the portfolio approach*/
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

tab event_time if abs(event_time)<=`evt_window' & event_window==1, gen(Devent)
local neventdummies = 2*`evt_window'+1
forv i==1/`neventdummies' {
		replace Devent`i' = 0 if Devent`i' == .
}

drop if event_time > `evt_window'

su event_time
local mintime = r(min)

egen id = group(panel_id) /*Recreate panel id*/
su id
local npanel = r(max)


matrix A1 = J(`neventdummies',`npanel',.)		


*=======================================================================================================
*REGRESSIONS with all coefficients panel_id specific (except event time dummies)
*DROP PANEL ID ONE BY ONE
*=======================================================================================================

*I. NO-THIN TRADE ISSUES
*-------------------------------------------------------------------------------------------------------
local m = 0

if `thintrade'== 0 {
*================================================================================
*1. Baseline specification (i.e., no addiitonal time dummy variables)
*================================================================================

forv n==1/`npanel' {
	preserve
	drop if id== `n' 


	xi: reg  R  i.panel_id*Rm  `industrycontrols'  i.panel_id*i.corporate_action  Devent* if event_time>=`mintime', cluster(date) r

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
		outreg Devent* using Regression_Approach_robust_sample_`eveyear'_`EVENT'.txt, noaster nolabel ctitle(`n') ///
		addstat(-10to-1vs0to10, `diff10', F test, `F1', Prob>F, `p1', -5to-1vs0to5, `diff5', F test, `F2', Prob>F, `p2', -3to-1vs0to3, `diff3', F test,  r(F), Prob>F, r(p)) ///
		adec(5, 3, 3, 5, 3, 3, 5, 3, 3) replace
	}
	else {
		outreg Devent* using Regression_Approach_robust_sample_`eveyear'_`EVENT'.txt, noaster nolabel ctitle(`n') ///
		addstat(-10to-1vs0to10, `diff10', F test, `F1', Prob>F, `p1', -5to-1vs0to5, `diff5', F test, `F2', Prob>F, `p2', -3to-1vs0to3, `diff3', F test,  r(F), Prob>F, r(p)) ///
		adec(5, 3, 3, 5, 3, 3, 5, 3, 3) append
	}
	
	
	*Building CAR and their standard errors

	forv i==1/`neventdummies' {
		if `i'==1 {
			matrix A1[`i',`m'+1] = _b[Devent1]
		}
		else {
			local exp "Devent1"

			forv j == 2/`i' {
				local exp "`exp' + Devent`j'"
			}

			qui lincom `exp'
			matrix A1[`i',`m'+1] = r(estimate)
		}
	}
restore
local m = `m'+1

}
}


*mat list A1
matrix A = vec(A1)

egen id1 = group(id)
keep if id1==1
keep if event_time>=-`evt_window' & event_time<=`evt_window'
keep event_time
svmat A, names( col )

rename c1 car

gen id = .


local k = 0
forv i==1/`npanel'  {
	forv j = 1/`neventdummies' {
		local h = `k'+`j'
		replace id = `i' in `h'
		replace event_time=`j'-(`evt_window' +1) in `h'
	}
local k = `k'+`neventdummies'
}

sort event_time


if `thintrade'== 0 {
	saveold Regression_Approach_CAR_robust_sample_`eveyear'_`EVENT', replace
}
if `thintrade'== 1 {
	saveold Regression_Approach_CAR_thin_robust_sample_`eveyear'_`EVENT', replace
}






*****************************************************************************
*To draw figures of the series of the CAR evolution by varying sample groups*
*****************************************************************************


if `thintrade'== 0 {
	use Regression_Approach_CAR_robust_sample_`eveyear'_`EVENT', clear
}
if `thintrade'== 1 {
	use Regression_Approach_CAR_thin_robust_sample_`eveyear'_`EVENT', clear
	local thin "_thin"
}

egen car_min = min(car), by(event_time)
egen car_25 = pctile(car), p(25) by(event_time)
egen car_mean = mean(car), by(event_time)
egen car_75 = pctile(car), p(75) by(event_time)
egen car_max = max(car), by(event_time)

keep if id==1

*PLOT MIN, 1ST QUANTILE, MEAN, 3RD QUANTILE, AND MAX OF CAAR IN EACH EVENT TIME
twoway ///
(rarea car_min car_25 event_time, fcolor(gs13) lpattern(longdash_shortdash) lcolor(none) lwidth(medium)) ///
(rarea car_25 car_mean event_time, fcolor(gs13) lpattern(longdash_shortdash) lcolor(none) lwidth(medium)) ///
(rarea car_mean car_75 event_time, fcolor(gs13) lpattern(longdash_shortdash) lcolor(none) lwidth(medium)) ///
(rarea car_75 car_max event_time, fcolor(gs13) lpattern(longdash_shortdash) lcolor(none) lwidth(medium)) ///
(line car_min event_time, lpattern(solid) lcolor(navy) lwidth(medthick)) ///
(line car_25 event_time, lpattern(longdash_shortdash) lcolor(red) lwidth(medium)) ///
(line car_mean event_time, lpattern(solid) lcolor(navy) lwidth(medthick)) ///
(line car_75 event_time, lpattern(longdash_shortdash) lcolor(red) lwidth(medium)) ///
(line car_max event_time, lpattern(solid) lcolor(navy) lwidth(medthick)) ///
, yscale(range(0 0.01)) yline(0, lwidth(vvthin)) ///
ytitle(Cumulative abnormal return, margin(medium)) xtitle(Event time, margin(medium)) legend(off) 

gr save Appendix_Fig_A1_C, replace 



