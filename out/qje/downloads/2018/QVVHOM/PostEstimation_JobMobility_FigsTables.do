**********************************************
*                                            *
*   This program creates figures and tables  *
*   for the CHK mobility analysis.           *
*                                            *
**********************************************
clear all
cd <filepath>
set more off
/* SET THE ANALYSIS SAMPLE */
local sample 1_520hr
local pop Male
local ssize 100P


forvalues p=1/2 {
if `p' ==1 {
local jssample JS2Year
local text0 1_2Prd
local xlabel xlabel(1(1)6)
local swtprd 12 2.5 12 4.5
local text4 2 and 5.
local text5 For all observations main job is the same in years 1, 2, 3 and then switches to a new main job for years 4, 5 and 6.
local text6 possible years of the job switch.
}
if `p' ==2 {
local jssample JS1Year
local text0 2_1Prd
local xlabel xlabel(1(1)5)
local swtprd 12 2.5 12 3.5
local text4 2 and 4.
local text5 For all observations main job is the same in years 1 and 2 and then switches to a new main job for years 4 and 5." "Main job is equal to either of the jobs in period 3. 
local text6 estimated year of the job switch.
}

forvalues j=1/2 {
if `j' == 1 {
local var1 swt_m_y
local text 1_FWAGE
local text3 Firm earnings quartiles are calculated with respect to the mean earnings of coworkers in the firm in years
local text7 of mean firm earnings
}
if `j' == 2 {
local var1 swt_fe
local text 2_FFE
local text3 Firm fixed effect quartiles are weighted by worker-years and calculated in years
local text7 of firm fixed effects
}
insheet using Mobility\S`ssize'_`jssample'_`sample'_`pop'_Int7.txt, comma clear  
keep if `var1'!=.

reshape long m_y m_nw dt_m_y, i(interval s_year case `var1') j(year)

if `p' == 1 { 
replace year = year-1 if case==2 
drop if year==0 | year==7
}
if `p' == 2 {
replace year = year-1 if case==2
replace year = year-2 if case==3
keep if year>=1 & year<=5
}
sort interval `var1' year case
by interval `var1' year: egen n_tot=total(n)
gen weight=n/n_tot
collapse (sum) m_y (sum) m_nw (sum) dt_m_y [pw=weight], by(interval `var1' year n_tot)


forvalues i=1/5 {
local b=1980+(`i'-1)*7
local e=`b'+6
if `i'==5 {
local b=2007
local e=2013
}
forvalues k=1/2{
if `k' == 1 {
local var2 m_y
local text2 1_Raw
}
if `k' == 2 {
local var2 dt_m_y
local text2 2_Dtrnd
}
twoway ///
	(scatteri `swtprd', bcolor("235 235 235") recast(area)) ///
	(connected `var2' year if `var1'==44 & interval==`i', color("49 54 149") lp(dash_dot) m(circle) msize(medlarge)) ///
	(connected `var2' year if `var1'==43 & interval==`i', color("66 146 198") lp(dash) m(diamond)) ///
	(connected `var2' year if `var1'==42 & interval==`i', color("255 0 0") lp(dash) m(square)) ///
	(connected `var2' year if `var1'==41 & interval==`i', color("165 15 21") lp(dash) m(triangle)) ///
	(connected `var2' year if `var1'==14 & interval==`i', color("49 54 149" ) lp(solid) m(circle) msize(medlarge)) ///
	(connected `var2' year if `var1'==13 & interval==`i', color("66 146 198") lp(solid) m(diamond)) ///
	(connected `var2' year if `var1'==12 & interval==`i', color("255 0 0") lp(solid) m(square)) ///
	(connected `var2' year if `var1'==11 & interval==`i', color("165 15 21") lp(solid) m(triangle)) ///
	, xtitle("Year") `xlabel' ytitle("Mean Log Earnings of Job Switchers") ///
	ylabel(9.5(.5)12, angle(0) gmin gmax glc("235 235 235")) ///
	legend(order(2 "4-->4   " 3 "4-->3" 4 "4-->2" 5 "4-->1" 6 "1-->4" 7 "1-->3" 8 "1-->2" 9 "1-->1") pos(3) rows(8) ) ///
	 xscale(titlegap(*10)) yscale(titlegap(*10)) ///
	graphregion(color(white)) plotregion(color(white)) scale(.8) ///
	note("Note: `text5'" ///
	"The shaded region marks the `text6'" ///
	"`text3' `text4'", margin(medsmall)) ///
	title("Mean earnings of job switchers, classified by quartile" "`text7' at origin and destination firm (`b'-`e', `ssize' Sample)", margin(medium) linegap(1.5) color(black))
graph display, ysize(8) xsize(14.5)  
graph export Figures/Mobility/S`ssize'_Mobility_`text0'_`text'_Int`i'_Fig_`text2'_1.pdf, replace
graph export Figures/Mobility/S`ssize'_Mobility_`text0'_`text'_Int`i'_Fig_`text2'_1.eps, replace

twoway ///
	(scatteri `swtprd', bcolor("235 235 235") recast(area)) ///
	(connected `var2' year if `var1'==14 & interval==`i', color("49 54 149") lp(dash_dot) m(circle) msize(medlarge)) ///
	(connected `var2' year if `var1'==13 & interval==`i', color("66 146 198") lp(dash) m(diamond)) ///
	(connected `var2' year if `var1'==12 & interval==`i', color("255 0 0") lp(dash) m(square)) ///
	(connected `var2' year if `var1'==11 & interval==`i', color("165 15 21") lp(dash) m(triangle)) ///
	(connected `var2' year if `var1'==11 & interval==`i', color("49 54 149" ) lp(solid) m(circle) msize(medlarge)) ///
	(connected `var2' year if `var1'==21 & interval==`i', color("66 146 198") lp(solid) m(diamond)) ///
	(connected `var2' year if `var1'==31 & interval==`i', color("255 0 0") lp(solid) m(square)) ///
	(connected `var2' year if `var1'==41 & interval==`i', color("165 15 21") lp(solid) m(triangle)) ///
	, xtitle("Year") `xlabel' ytitle("Mean Log Earnings of Job Switchers") ///
	ylabel(9.5(.5)12, angle(0) gmin gmax glc("235 235 235")) ///
	legend(order(2 "4-->4   " 3 "4-->3" 4 "4-->2" 5 "4-->1" 6 "1-->4" 7 "1-->3" 8 "1-->2" 9 "1-->1") pos(3) rows(8) ) ///
	 xscale(titlegap(*10)) yscale(titlegap(*10)) ///
	graphregion(color(white)) plotregion(color(white)) scale(.8) ///
	note("Note: `text5'" ///
	"The shaded region marks the `text6'" ///
	"`text3' `text4'", margin(medsmall)) ///
	title("Mean earnings of job switchers, classified by quartile" "`text7' at origin and destination firm (`b'-`e', `ssize' Sample)", margin(medium) linegap(1.5) color(black))
graph display, ysize(8) xsize(14.5)  
graph export Figures/Mobility/S`ssize'_Mobility_`text0'_`text'_Int`i'_Fig_`text2'_2.pdf, replace
graph export Figures/Mobility/S`ssize'_Mobility_`text0'_`text'_Int`i'_Fig_`text2'_2.eps, replace

twoway ///
	(scatteri `swtprd', bcolor("235 235 235") recast(area)) ///
	(connected `var2' year if `var1'==44 & interval==`i', color("49 54 149") lp(dash_dot) m(circle) msize(medlarge)) ///
	(connected `var2' year if `var1'==43 & interval==`i', color("66 146 198") lp(dash) m(diamond)) ///
	(connected `var2' year if `var1'==42 & interval==`i', color("255 0 0") lp(dash) m(square)) ///
	(connected `var2' year if `var1'==41 & interval==`i', color("165 15 21") lp(dash) m(triangle)) ///
	(connected `var2' year if `var1'==14 & interval==`i', color("49 54 149" ) lp(solid) m(circle) msize(medlarge)) ///
	(connected `var2' year if `var1'==13 & interval==`i', color("66 146 198") lp(solid) m(diamond)) ///
	(connected `var2' year if `var1'==12 & interval==`i', color("255 0 0") lp(solid) m(square)) ///
	(connected `var2' year if `var1'==11 & interval==`i', color("165 15 21") lp(solid) m(triangle)) ///
	, xtitle("Year") `xlabel' ytitle("Mean Log Earnings of Job Switchers") ///
	ylabel(9.5(.5)12, angle(0) gmin gmax glc("235 235 235")) ///
	legend(order(2 "4-->4   " 3 "4-->3" 4 "4-->2" 5 "4-->1" 6 "1-->4" 7 "1-->3" 8 "1-->2" 9 "1-->1") pos(3) rows(8) ) ///
	 xscale(titlegap(*10)) yscale(titlegap(*10)) ///
	graphregion(color(white)) plotregion(color(white)) scale(.8) ///
	note("Note: `text5'" ///
	"The shaded region marks the `text6'" ///
	"`text3' `text4'", margin(medsmall)) ///
	title("Mean earnings of job switchers, classified by quartile" "`text7' at origin and destination firm (`b'-`e', `ssize' Sample)", margin(medium) linegap(1.5) color(black))
graph display, ysize(8) xsize(14.5)  
graph export Figures/Mobility/S`ssize'_Mobility_`text0'_`text'_Int`i'_Fig_`text2'_3.pdf, replace
graph export Figures/Mobility/S`ssize'_Mobility_`text0'_`text'_Int`i'_Fig_`text2'_3.eps, replace

}
}

********************************
*   Tables                     *
********************************
reshape wide m_y m_nw dt_m_y, i(interval `var1') j(year)

order n_tot, after(`var1')

if `p' == 1 {
gen d_m_y=m_y5-m_y2
gen d_m_nw=m_nw5-m_nw2
gen d_dt_m_y=dt_m_y5-dt_m_y2
}
if `p' == 2 {
gen d_m_y=m_y4-m_y2
gen d_m_nw=m_nw4-m_nw2
gen d_dt_m_y=dt_m_y4-dt_m_y2
}

forvalues r=1/3{
if `r' == 1 {
local var15 m_y
local text15 RawY
}
if `r' == 2 {
local var15 dt_m_y
local text15 DtrndY
}
if `r' == 3 {
local var15 m_nw
local text15 NWrks
}
forvalues i=1/5{
if `p' == 1 {
mkmat `var1' n_tot `var15'1 `var15'2 `var15'3 `var15'4 `var15'5 `var15'6 d_`var15' if interval==`i', matrix(a)
}
if `p' == 2 {
mkmat `var1' n_tot `var15'1 `var15'2 `var15'3 `var15'4 `var15'5 d_`var15' if interval==`i', matrix(a)
}
matrix list a
forvalues t=1/4{
local j2=`t'-1
local b2=1+4*`j2'
local e2=`b2'+3
if `p' == 1 {
matrix a`t'=a[`b2'..`e2',2..9]
}
if `p' == 2 {
matrix a`t'=a[`b2'..`e2',2..8]
}
local r=9 +`j2'*5
putexcel set Tables/S`ssize'_Table_1_Mobility_`text0'_`text', modify sheet("Int`i'_`text15'")
putexcel B`r'=matrix(a`t')
}
}
}
}
} 
