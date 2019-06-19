#delim cr
set more off
*version 10
pause on
graph set ps logo off

if (`1' != 2001 & `1' != 2008) {
	disp "Please select a year"
	crash
}
local rebate_year = `1'
if `rebate_year' == 2001 {
	global day0 = mdy(7,20,2001)
}
if `rebate_year' == 2008 {
	global day0 = mdy(5,16,2008)
}

capture log close
set linesize 180
set logtype text
log using ../log/event-study-maker-`rebate_year'.log , replace

/* --------------------------------------

Create all event-study figures.

--------------------------------------- */

clear all
estimates clear
program drop _all
set mem 1000m
describe, short

************************************************************
**   Define how graphs will be exported
************************************************************

** draw or do not draw graphs (0 stops drawing)
** drawgraphs is used to turn particular runs on/off
** master_... is the master switch to turn off all graphing
global drawgraphs 1
global master_drawgraphs 1

************************************************************
**   Bring in data
************************************************************

use ../dta/event-study-data-`rebate_year'.dta 

************************************************************
**   Merge in Rebate Dates
************************************************************

sort ssn2
merge m:1 ssn2 using ../dta/ssn_key_`rebate_year'.dta
tab _merge
tab ssn2 if _merge != 3 
drop _merge

************************************************************
**   Generate timing indicators                           **
************************************************************

**  Generate timing indicators
gen their_paper_week = 0
replace their_paper_week = 1 if r`rebate_year'_week == floor((paper_date_`rebate_year' - $day0) / 7)

gen past_their_paper_week = 0
replace past_their_paper_week = 1 if r`rebate_year'_week > floor((paper_date_`rebate_year' - $day0) / 7)

gen weeks_since_their_paper_week = r`rebate_year'_week - floor((paper_date_`rebate_year' - $day0) / 7)

if `rebate_year' == 2008 {

	gen their_direct_week = 0
	replace their_direct_week = 1 if r`rebate_year'_week == floor((direct_date_2008 - $day0) / 7)

	gen past_their_direct_week = 0
	replace past_their_direct_week = 1 if r`rebate_year'_week > floor((direct_date_2008 - $day0) / 7)
}

************************************************************
**   Relative Time Restriction                            **
************************************************************

** Describe possible data windows
format paper_date %td
sum weeks_since_their_paper_week
table paper_date , c(min weeks_since_their_paper_week max weeks_since_their_paper_week)
codebook filedate

** Restrict sample via relative time
sum r`rebate_year'_week 
keep if weeks_since_their_paper_week >= -30 & weeks_since_their_paper_week <= 40
keep if year(paper_date) == year($day0)
table paper_date , c(min weeks_since_their_paper_week max weeks_since_their_paper_week min filedate max filedate)

** The following code just demonstrates that the DD
** indicators are coded properly for the 2nd group in each year.
list r`rebate_year'_week their_paper_week past_their_paper_week if paper_date ==  $day0 , sepby(r`rebate_year'_week)
list r`rebate_year'_week their_paper_week past_their_paper_week if paper_date ==  $day0 + 7, sepby(r`rebate_year'_week)

************************************************************
**   Event-Study Figures, Final Spec, FP
************************************************************

program define final_spec
	args thislead thislag rebate_year chapter

	xi i.ssn2 i.r`rebate_year'_week

	** Create leads & lags
	capture drop tm*
	capture drop tp*
	forvalues i=`thislead'(-1)0 {
		gen byte tm`i' = ceil((weeks_since_their_paper_week + 1) / 2) == -`i'
		label var tm`i' "Lead `i'"
		disp "For lead `i': "
		tab weeks_since_their_paper_week if tm`i' == 1
	}
	forvalues i=1(1)`thislag' {
		gen byte tp`i' = ceil((weeks_since_their_paper_week + 1) / 2) == `i'
		label var tp`i' "Lag `i'"
		disp "For lag `i': "
		tab weeks_since_their_paper_week if tp`i' == 1
	}

	** make sure leads & lags are mutually exclusive & complete
	** specifically, I make the first lead indicate everything before
	** and the last lag indicate everything after
	replace tm`thislead' = 1 if ( ceil((weeks_since_their_paper_week + 1) / 2) <= -`thislead')
	replace tp`thislag' = 1 if ( ceil((weeks_since_their_paper_week + 1) / 2) >= `thislag')

	** the following commands just demonstrate that the lags
	** are coded properly
	disp "Some leads and lags for first group"
	table weeks_since_their_paper_week ///
	if paper_date == $day0 ///
	, c(mean r`rebate_year'_week mean tm`thislead' mean tm0 mean tp1 mean tp`thislag') 

	disp "Some leads and lags for first group"
	table weeks_since_their_paper_week ///
	if paper_date == $day0 ///
	, c(mean r`rebate_year'_week mean tm4 mean tm3 mean tp4 mean tp5) 

	disp "Some leads and lags for second group"
	table weeks_since_their_paper_week ///
	if paper_date == $day0 + 7 ///
	, c(mean r`rebate_year'_week mean tm`thislead' mean tm1 mean tm0 mean tp`thislag') 

	disp "Some leads and lags for second group"
	table weeks_since_their_paper_week ///
	if paper_date == $day0 + 7 ///
	, c(mean r`rebate_year'_week mean tm4 mean tm3 mean tp3 mean tp5) 

	lookfor Lead Lag
	local lookedfor = "`r(varlist)'"
	disp "`lookedfor'"
	egen lead_lag_sum = rsum(`lookedfor')
	tab lead_lag_sum
	assert lead_lag_sum == 1
	drop lead_lag_sum

	** fix baseline at 1 week ahead
	replace tm0 = 0

	**  Run regressions
	if `rebate_year' == 2001 {
		reg log_chapter`chapter'   tm`thislead'-tm1 tm0 tp1-tp`thislag'  _I* , cluster(ssn2)
	}
	if `rebate_year' == 2008 {
		reg log_chapter`chapter' past_their_direct_week tm`thislead'-tm1 tm0 tp1-tp`thislag'  _I* , cluster(ssn2)
	}

	disp "outcome `outcome' ; thislead `thislead'; thislag `thislag'"

	disp ""
	disp ""
	disp "Describe sample in last regression: "
	sum r`rebate_year'_week if e(sample) 
	sum r`rebate_year'_week if e(sample) & paper_date == mdy(7,20,2001)
	sum r`rebate_year'_week if e(sample) & paper_date == mdy(7,27,2001)
	sum r`rebate_year'_week if e(sample) & paper_date == mdy(5,16,2008)
	sum r`rebate_year'_week if e(sample) & paper_date == mdy(5,23,2008)
	format paper_date %td
	tab paper_date if e(sample)
	format filedate %td
	tab filedate if e(sample) & paper_date == mdy(7,20,2001)
	tab filedate if e(sample) & paper_date == mdy(7,27,2001)
	tab filedate if e(sample) & paper_date == mdy(5,16,2008)
	tab filedate if e(sample) & paper_date == mdy(5,23,2008)
	format paper_date %td

	matrix event_study = J(200, 4, 0)
	local row = 1
	forvalues lead = `thislead'(-1)1 {
		matrix event_study[`row',1] = -`lead'
		matrix event_study[`row',2] = _b[tm`lead'] - 1.98*_se[tm`lead'] 
		matrix event_study[`row',3] = _b[tm`lead']
		matrix event_study[`row',4] = _b[tm`lead'] + 1.98*_se[tm`lead'] 
		local row = `row' + 1
	}
	forvalues lag = 1(1)`thislag' {
		matrix event_study[`row',1] = `lag'
		matrix event_study[`row',2] = _b[tp`lag'] - 1.98*_se[tp`lag'] 
		matrix event_study[`row',3] = _b[tp`lag']
		matrix event_study[`row',4] = _b[tp`lag'] + 1.98*_se[tp`lag'] 
		local row = `row' + 1
	}

	matrix event_study[`row',1] = 0  // fill in omitted group
	matrix event_study[`row',2] = 0  // fill in omitted group
	matrix event_study[`row',3] = 0  // fill in omitted group
	matrix event_study[`row',4] = 0  // fill in omitted group
	local row = `row' + 1

	drop _all
	svmat event_study
	rename event_study1 time
	rename event_study2 b1
	rename event_study3 b2
	rename event_study4 b3
	drop if time == 0 & b1 == 0 & b2 ==0 & b3 == 0 & _n != `row'
	list

	reshape long b , i(time) j(type)
	list

end

if `rebate_year' == 2001 {
	preserve
		global titlstr1 "Figure 4. Event Study Point Estimates, 2001" 
		global titlstr2 "Dependent Variable: Log of Chapter 7 Filings"

		final_spec 8 12 2001 7
		local thislead = 8
		local thislag = 12
		graph set window fontface "Garamond"
		tw ///
			(scatter b time if type==2 & time >= -`thislead' & time <= `thislag', sort connect(l) symbol(o) mcolor(blue) lcolor(blue) ) ///
			(scatter b time if type==1 & time >= -`thislead' & time < 0, sort connect(l) lpattern(dash) symbol(i) lcolor(gray) ) ///
			(scatter b time if type==1 & time > 0 & time <= `thislag', sort connect(l) lpattern(dash) symbol(i) lcolor(gray) ) ///
			(scatter b time if type==3 & time >= -`thislead' & time < 0, sort connect(l) lpattern(dash) symbol(i) lcolor(gray) )  ///
			(scatter b time if type==3 & time > 0 & time <= `thislag', sort connect(l) lpattern(dash) symbol(i) lcolor(gray) ) ///
			, ///
			scheme(s2mono) ylabel(, nogrid  angle(horizontal)  ) graphregion(fcolor(white)) ///
			yline(0) legend(off) ///
			yscale( nofextend ) xscale(nofextend) ///
			xtitle("Weeks Since Rebate Receipt") ///
			ytitle("Point Estimate") ///
			yscale(r(-0.1 0.1)) ylabel(-0.1 -0.05 0 0.05 0.1) ///
			xscale(r(-`thislead' `thislag')) ///
			xlabel(-8 "<-16" -6 "-14" -4 "-10" -2 "-6" 0 "-2" 2 "2" 4 "6" 6 "10" 8 "14" 10 "18" 12 "22+") /// 
			xtick(-8(1)12) ///
			title("$titlstr1" "$titlstr2") ///
			note(" ")
			
		graph export ../gph/fig4.$gph_extension , replace
	restore

	preserve
		global titlstr1 "Figure 6. Event Study Point Estimates, 2001" 
		global titlstr2 "Dependent Variable: Log of Chapter 13 Filings"

		graph set window fontface "Garamond"
		final_spec 8 12 2001 13
		local thislead = 8
		local thislag = 12
		graph set window fontface "Garamond"
		tw ///
			(scatter b time if type==2 & time >= -`thislead' & time <= `thislag', sort connect(l) symbol(o) mcolor(blue) lcolor(blue) ) ///
			(scatter b time if type==1 & time >= -`thislead' & time < 0, sort connect(l) lpattern(dash) symbol(i) lcolor(gray) ) ///
			(scatter b time if type==1 & time > 0 & time <= `thislag', sort connect(l) lpattern(dash) symbol(i) lcolor(gray) ) ///
			(scatter b time if type==3 & time >= -`thislead' & time < 0, sort connect(l) lpattern(dash) symbol(i) lcolor(gray) )  ///
			(scatter b time if type==3 & time > 0 & time <= `thislag', sort connect(l) lpattern(dash) symbol(i) lcolor(gray) ) ///
			, ///
			scheme(s2mono) ylabel(, nogrid  angle(horizontal)  ) graphregion(fcolor(white)) ///
			yline(0) legend(off) ///
			yscale( nofextend ) xscale(nofextend) ///
			xtitle("Weeks Since Rebate Receipt") ///
			ytitle("Point Estimate") ///
			xscale(r(-`thislead' `thislag')) ///
			xlabel(-8 "<-16" -6 "-14" -4 "-10" -2 "-6" 0 "-2" 2 "2" 4 "6" 6 "10" 8 "14" 10 "18" 12 "22+") /// 
			yscale(r(-0.15 0.15)) ylabel(-0.15 -0.1 -0.05 0 0.05 0.1 0.15) ///
			xtick(-8(1)12) ///
			title("$titlstr1" "$titlstr2") ///
			note(" ")
		graph export ../gph/fig6.$gph_extension , replace
	restore
}
if `rebate_year' == 2008 {
	preserve
		global titlstr1 "Figure 5. Event Study Point Estimates, 2008" 
		global titlstr2 "Dependent Variable: Log of Chapter 7 Filings"

		graph set window fontface "Garamond"
		final_spec 8 12 2008 7
		local thislead = 8
		local thislag = 12
		graph set window fontface "Garamond"
		tw ///
			(scatter b time if type==2 & time >= -`thislead' & time <= `thislag', sort connect(l) symbol(o) mcolor(blue) lcolor(blue) ) ///
			(scatter b time if type==1 & time >= -`thislead' & time < 0, sort connect(l) lpattern(dash) symbol(i) lcolor(gray) ) ///
			(scatter b time if type==1 & time > 0 & time <= `thislag', sort connect(l) lpattern(dash) symbol(i) lcolor(gray) ) ///
			(scatter b time if type==3 & time >= -`thislead' & time < 0, sort connect(l) lpattern(dash) symbol(i) lcolor(gray) )  ///
			(scatter b time if type==3 & time > 0 & time <= `thislag', sort connect(l) lpattern(dash) symbol(i) lcolor(gray) ) ///
			, ///
			scheme(s2mono) ylabel(, nogrid  angle(horizontal)  ) graphregion(fcolor(white)) ///
			yline(0) legend(off) ///
			yscale( nofextend ) xscale(nofextend) ///
			xtitle("Weeks Since Rebate Receipt") ///
			ytitle("Point Estimate") ///
			xscale(r(-`thislead' `thislag')) ///
			yscale(r(-0.1 0.1)) ylabel(-0.1 -0.05 0 0.05 0.1) ///
			xlabel(-8 "<-16" -6 "-14" -4 "-10" -2 "-6" 0 "-2" 2 "2" 4 "6" 6 "10" 8 "14" 10 "18" 12 "22+") /// 
			xtick(-8(1)12) ///
			title("$titlstr1" "$titlstr2") ///
			note(" ")
		graph export ../gph/fig5.$gph_extension , replace
	restore



	preserve
		global titlstr1 "Figure 7. Event Study Point Estimates, 2008" 
		global titlstr2 "Dependent Variable: Log of Chapter 13 Filings"

		graph set window fontface "Garamond"
		final_spec 8 12 2008 13
		local thislead = 8
		local thislag = 12
		graph set window fontface "Garamond"
		tw ///
			(scatter b time if type==2 & time >= -`thislead' & time <= `thislag', sort connect(l) symbol(o) mcolor(blue) lcolor(blue) ) ///
			(scatter b time if type==1 & time >= -`thislead' & time < 0, sort connect(l) lpattern(dash) symbol(i) lcolor(gray) ) ///
			(scatter b time if type==1 & time > 0 & time <= `thislag', sort connect(l) lpattern(dash) symbol(i) lcolor(gray) ) ///
			(scatter b time if type==3 & time >= -`thislead' & time < 0, sort connect(l) lpattern(dash) symbol(i) lcolor(gray) )  ///
			(scatter b time if type==3 & time > 0 & time <= `thislag', sort connect(l) lpattern(dash) symbol(i) lcolor(gray) ) ///
			, ///
			scheme(s2mono) ylabel(, nogrid  angle(horizontal)  ) graphregion(fcolor(white)) ///
			yline(0) legend(off) ///
			yscale( nofextend ) xscale(nofextend) ///
			xtitle("Weeks Since Rebate Receipt") ///
			ytitle("Point Estimate") ///
			xscale(r(-`thislead' `thislag')) ///
			yscale(r(-0.15 0.15)) ylabel(-0.15 -0.1 -0.05 0 0.05 0.1 0.15) ///
			xlabel(-8 "<-16" -6 "-14" -4 "-10" -2 "-6" 0 "-2" 2 "2" 4 "6" 6 "10" 8 "14" 10 "18" 12 "22+") /// 
			xtick(-8(1)12) ///
			title("$titlstr1" "$titlstr2") ///
			note(" ")
		graph export ../gph/fig7.$gph_extension , replace
	restore
}

log close
exit
