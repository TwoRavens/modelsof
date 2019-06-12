************************************************** 
******** How Hard to Fight - Replication *********
**************************************************

use contests-game-rev-working, clear

****************
***Regression results for Figure 2
****************

egen ncond = group(cond), label
reg mye i.doubleval#i.ncond#(c.myhigh c.getting c.doing) i.doubleval#i.ncond, cluster(subid)

****************
***Figure 3
****************

gen nasheffort = (myv^2*oppv)/(myv + oppv)^2 
gen overbid = mye - nasheffort 
gen pctoverbid = 100*overbid/nasheffort 

preserve
collapse (mean) pctover_mean = pctoverbid (sd) pctoverbid_sd = pctoverbid (count) n = pctoverbid, by(tnum)

gen hic = pctover_mean + invttail(n-1,0.025)*(pctoverbid_sd / sqrt(n))
gen loc = pctover_mean - invttail(n-1,0.025)*(pctoverbid_sd / sqrt(n))
gen feedback = 0
replace feedback = 1 if tnum == 2 | tnum == 4
gen calculator = 0
replace calculator = 1 if tnum == 3 | tnum == 4
recode tnum (2=3) (3=5) (4=7)

twoway (bar pctover_mean tnum if feedback == 0, lcolor(black)) ///
	(bar pctover_mean tnum  if feedback == 1, lcolor(black))  ///
	(rcap hic loc tnum, lcolor(black)), ///
	scheme(s2mono) legend(order(1 "No Feedback" 2 "Feedback")) ///
	xlabel(2 "No Calculator" 6 "Calculator", noticks) ///
	ytitle("Percentage") xtitle("") ylabel(0(20)100) xscale(range(0 4))
restore

****************
***Table 3
****************

gen experience = period - 1 if part==1
replace experience = period - 18 if part==2 & (treat2=="BNBF" | treat2=="CNCF")
replace experience = period - 2 if part==2 & (treat2=="BNBN" | treat2=="BFBF" | treat2=="CFCF")

capture drop _merge
merge m:1 subid using contests-indivmeas-rev, assert(match)

gen feed_calc = feedback * calculator
gen bnpt1 = treat2=="BNBN" | treat2=="BNBF"

*Column 1
reg pctover feedback calc feed_calc, cluster(subid)
*Column 2
reg pctover feedback calc feed_calc nasheffort doubleval experience zavg, cluster(subid)
*Column 3
reg pctover feedback calc feed_calc if part==1, cluster(subid)
*Column 4
reg pctover feedback calc feed_calc  nasheffort doubleval experience zavg if part==1, cluster(subid)
*Column 5
reg pctover feedback if part==2 & bnpt1==1, cluster(subid)
*Column 6
reg pctover feedback nasheffort doubleval experience zavg if part==2 & bnpt1==1, cluster(subid)

****************
**Figure 4
****************

drop if myv==0

gen str str_myval = "LOW" if myv==200 | myv==300 | myv==400 | myv==600
replace str_myval = "HIGH" if myv==800 | myv==900 | myv==1600 | myv==1800

gen str str_oppval = "LOW" if oppv==200 | oppv==300 | oppv==400 | oppv==600
replace str_oppval = "HIGH" if oppv==800 | oppv==900 | oppv==1600 | oppv==1800 

keep session date treat condition feedback part subid group myv oppv mye nasheffort str_myval str_oppval

* Replace feedback with part, which allows for reshaping wide
reshape wide mye nasheffort group oppv, i(condition subid part myv) j(str_oppval, str)

* Change in my effort as my opponent moved from low to high
gen effort_change = myeHIGH - myeLOW
* If my value is high, then my effort should increase as the opponent goes from low to high
gen dd_correct = effort_change > 0 if str_myval=="HIGH"
* If my value is low, then my effort should decrease as the opponent goes from low to high
gen gd_correct = effort_change < 0 if str_myval=="LOW"

collapse (mean) dd_correct gd_correct, by(cond part subid)

gen dd_high = dd_correct>.5
gen gd_high = gd_correct>.5
gen cs_both = dd_high==1 & gd_high==1
gen cs_ddonly = dd_high==1 & gd_high==0
gen cs_gdonly = dd_high==0 & gd_high==1
gen cs_none = dd_high==0 & gd_high==0

gen cs_type = 1 if cs_none==1
replace cs_type = 2 if cs_gdonly==1
replace cs_type = 3 if cs_ddonly==1
replace cs_type = 4 if cs_both==1

label define _cs 1 "None" 2 "GD only" 3 "DD only" 4 "Both", add
label values cs_type _cs

gen corder = 1 if cond=="BN"
replace corder = 2 if cond=="BF"
replace corder = 3 if cond=="CN"
replace corder = 4 if cond=="CF"

label define _cond 1 "Baseline-No feedback" 2 "Baseline-Feedback" 3 "Calculator-No feedback" 4 "Calculator-Feedback", add
label values corder _cond

graph bar, over(cs_type) legend(order(1 "None" 2 "GD only" 3 "DD only" 4 "Both")) scheme(s2mono) by(corder) ytitle(Percent)



********************
***** Appendix *****
********************

****************
** Table A1
****************

use contests-game-rev-working, clear

*Column 1 - Single Val
reg mye myhigh getting doing if doubleval==0 & myv!=0, cluster(subid)
*Column 2 - Double Val
reg mye myhigh getting doing if doubleval==1 & myv!=0, cluster(subid)

****************
** Table A2
****************
use contests-game-rev-working, clear

gen nasheffort = (myv^2*oppv)/(myv + oppv)^2 
gen overbid = mye - nasheffort 
gen pctoverbid = 100*overbid/nasheffort 

gen experience = period - 1 if part==1
replace experience = period - 18 if part==2 & (treat2=="BNBF" | treat2=="CNCF")
replace experience = period - 2 if part==2 & (treat2=="BNBN" | treat2=="BFBF" | treat2=="CFCF")

gen feed_calc = feedback * calculator
egen ncond = group(cond), label

gen bnpt1 = treat2=="BNBN" | treat2=="BNBF"

capture drop _merge
merge m:1 subid using contests-indivmeas-rev, assert(match)

*Column 1 
reg pctover feedback calc feed_calc nasheffort doubleval experience zavg male risk_scale agg_scale, cluster(subid)
*Column 2
reg pctover feedback calc feed_calc  nasheffort doubleval experience zavg male risk_scale agg_scale if part==1, cluster(subid)
*Column 3
reg pctover feedback nasheffort doubleval experience zavg male risk_scale agg_scale if part==2 & bnpt1==1, cluster(subid)

****************
** Figure A1
****************

use contests-game-rev-working, clear

gen nasheffort = (myv^2*oppv)/(myv + oppv)^2 
gen overbid = mye - nasheffort 
gen pctoverbid = 100*overbid/nasheffort 

bysort period: egen mean_pctoverbid_feedback = mean(pctoverbid) if feedback == 1
bysort period: egen mean_pctoverbid_nofeedback = mean(pctoverbid) if feedback == 0

bysort period: egen mean_pctoverbid_fb_nocalc = mean(pctoverbid) if feedback == 1 & calculator == 0
bysort period: egen mean_pctoverbid_nofb_nocalc = mean(pctoverbid) if feedback == 0 & calculator == 0


local ax "xlabel(0(5)34) ytitle("Percent Dist. From Nash")"
local leg "legend(label(1 "Feedback") label(2 "No Feedback"))"
twoway connect mean_pctoverbid_feedback mean_pctoverbid_nofeedback period,  `ax' `leg'

****************
** Figures A2 & A3
****************

use contests-game-rev-working, clear

gen nasheffort = (myv^2*oppv)/(myv + oppv)^2 
gen overbid = mye - nasheffort 
gen pctoverbid = 100*overbid/nasheffort 
keep if session < 5

* Figure A2
* Two lowess lines, round 18 included on left
local ax "xlabel(0(5)34) ytitle("Percent Dist. From Nash")"
local leg "legend(off)"
twoway scatter pctoverbid period, `leg' `ax' || lowess pctoverbid period if period <=18 || lowess pctoverbid period if feedback==1 & period >18

* Figure A3
* Two lowess lines, round 18 included on left, +/- 5 round window
local ax "xlabel(12(1)23) ytitle("Percent Dist. From Nash")"
local leg "legend(off)"
twoway scatter pctoverbid period if period < 24 & period > 11, `ax' `leg' || lowess pctoverbid period if period > 11 & period < 19 || lowess pctoverbid period if feedback==1 & period < 24 & period > 18
	
****************
** Table A3
****************

use contests-calculator-rev, clear

keep if calculator == 1 & nclick!=.
gen t = period*1000+nclick

xtset subid t
sort subid period nclick

// INDICATOR VARIABLES FOR SEARCHES WITH POSITIVE EXPECTED UTILITY
gen my_pos_search = myeu > 1000
gen opp_pos_search = oppeu > 1000
gen both_pos_search = my_pos_search==1 & opp_pos_search==1

// SEARCH DIFFERENCE
sort subid t
gen diff_y = opp-l.opp
gen diff_x = own-l.own

// SEARCH DISTANCE
gen distance_search = sqrt(diff_x^2 + diff_y^2)

// SEARCH ANGLES

// STATA'S ATAN2 ALLOWS FOR X = 0 AND USES THE SIGNS OF X AND Y TO DETERMINE
// CORRECT QUADRANT
gen angle_rad = atan2(diff_y,diff_x)
gen angle_deg = angle_rad*180/c(pi)
replace angle_deg = 360 + angle_rad*180/c(pi) if angle_rad<0

// CLASSIFY HORIZONTAL OR VERTICAL USING TWO TOLERANCE LEVELS (+/- 10 OR 22 DEG)
foreach i in 10 22 {
	gen horiz_dir_`i' = 0
	replace horiz_dir_`i' = 1 if angle_deg < `i' | angle_deg > 360-`i' | (angle_deg > 180-`i' & angle_deg < 180 + `i')
	replace horiz_dir_`i' = . if angle_deg == .

	gen vert_dir_`i' = 0
	replace vert_dir_`i' = 1 if (angle_deg > 90-`i' & angle_deg < 90 + `i') | (angle_deg > 270 - `i' & angle_deg < 270 +`i')
	replace vert_dir_`i' = . if angle_deg == .

	gen diag_dir_`i' = 0
	replace diag_dir_`i' = 1 if horiz_dir_`i' == 0 & vert_dir_`i' == 0
	replace diag_dir_`i' = . if angle_deg == .

	gen searchtype_`i' = .
	replace searchtype_`i' = 1 if horiz_dir_`i' == 1
	replace searchtype_`i' = 2 if vert_dir_`i' == 1
	replace searchtype_`i' = 3 if diag_dir_`i' == 1

	gen switch_dir_`i' = .
	replace switch_dir_`i' = 1 if searchtype_`i' != l.searchtype_`i'
	replace switch_dir_`i' = 0 if searchtype_`i' == l.searchtype_`i' & searchtype_`i' != .

}
save contests-calculator-rev-working, replace

keep if choice==0 & myv!=0

*Table A3 - Total
tabstat my_pos_search opp_pos_search both_pos_search distance_search ///
	horiz_dir_10 horiz_dir_22 vert_dir_10 vert_dir_22, stat(mean n) columns(statistics)

*Table A3 - Subject-Period
	
collapse (mean) my_pos_search opp_pos_search both_pos_search distance_search /// 
	horiz_dir_10 horiz_dir_22 vert_dir_10 vert_dir_22 /// 
	diag_dir_10 diag_dir_22 switch_dir_10 switch_dir_22 ///
	(max) total_clicks=nclick maxdist=distance_search ///
	(sum) num_mypos=my_pos num_opppos=opp_pos num_bothpos=both_pos, by(session subid period)

save quality-sub-period-rev, replace
	
tabstat my_pos_search opp_pos_search both_pos_search distance_search ///
	horiz_dir_10 horiz_dir_22 vert_dir_10 vert_dir_22, stat(mean n) columns(statistics)
	
*Table A3 - Subject

gen click = 1
local vars = "my_pos_search opp_pos_search both_pos_search distance_search horiz_dir_10 horiz_dir_22 vert_dir_10 vert_dir_22 diag_dir_10 diag_dir_22 switch_dir_10 switch_dir_22"
foreach i in `vars' {
	gen `i'_l5 = `i' if period>=29 & period <=33
}
*

collapse (mean) my_pos_search opp_pos_search both_pos_search distance_search /// 
	horiz_dir_10 horiz_dir_22 vert_dir_10 vert_dir_22 /// 
	diag_dir_10 diag_dir_22 switch_dir_10 switch_dir_22 *_l5 ///
	(sum) total_clicks = click, by(session subid)

tabstat my_pos_search opp_pos_search both_pos_search distance_search ///
	horiz_dir_10 horiz_dir_22 vert_dir_10 vert_dir_22 total_clicks, stat(mean n) columns(statistics)


****************
** Table A4-6
****************

use contests-game-rev-working, clear
merge 1:1 subid period using quality-sub-period-rev	
mvencode my_pos-num_bothpos if _merge==1, mv(0)
keep if cond=="CN" | cond=="CF"

gen nasheffort = (myv^2*oppv)/(myv + oppv)^2 
gen overbid = mye - nasheffort 
gen pctoverbid = 100*overbid/nasheffort 

gen experience = period - 1 if part==1
replace experience = period - 18 if part==2 & (treat2=="BNBF" | treat2=="CNCF")
replace experience = period - 2 if part==2 & (treat2=="BNBN" | treat2=="BFBF" | treat2=="CFCF")

**TABLE A4
*Column 1
reg pctoverbid feedback nasheffort doubleval experience my_pos opp_pos both_pos, cluster(subid)
*Column 2
reg pctoverbid feedback nasheffort doubleval experience num_mypos num_opp num_both, cluster(subid)
*Column 3
reg pctoverbid feedback nasheffort doubleval experience horiz_dir_10 vert_dir_10, cluster(subid)
*Column 4
reg pctoverbid feedback nasheffort doubleval experience distance_search total_clicks, cluster(subid)
*Column 5
reg pctoverbid feedback nasheffort doubleval experience my_pos opp_pos both_pos horiz_dir_10 vert_dir_10 distance_search total_clicks, cluster(subid)

**TABLE A5
*Column 1
reg pctoverbid nasheffort doubleval experience my_pos opp_pos both_pos if feedback==0, cluster(subid)
*Column 2
reg pctoverbid nasheffort doubleval experience num_mypos num_opp num_both if feedback==0, cluster(subid)
*Column 3
reg pctoverbid nasheffort doubleval experience horiz_dir_10 vert_dir_10 if feedback==0, cluster(subid)
*Column 4
reg pctoverbid nasheffort doubleval experience distance_search total_clicks if feedback==0, cluster(subid)
*Column 5
reg pctoverbid nasheffort doubleval experience my_pos opp_pos both_pos horiz_dir_10 vert_dir_10 distance_search total_clicks if feedback==0, cluster(subid)

**TABLE A6
*Column 1
reg pctoverbid nasheffort doubleval experience my_pos opp_pos both_pos if feedback==1, cluster(subid)
*Column 2
reg pctoverbid nasheffort doubleval experience num_mypos num_opp num_both if feedback==1, cluster(subid)
*Column 3
reg pctoverbid nasheffort doubleval experience horiz_dir_10 vert_dir_10 if feedback==1, cluster(subid)
*Column 4
reg pctoverbid nasheffort doubleval experience distance_search total_clicks if feedback==1, cluster(subid)
*Column 5
reg pctoverbid nasheffort doubleval experience my_pos opp_pos both_pos horiz_dir_10 vert_dir_10 distance_search total_clicks if feedback==1, cluster(subid)


****************
** Figure A4
****************

* CORRELATION BETWEEN LEVEL AND CS

use cs-consistent-combined-rev, clear
merge 1:1 subid using subjectlevel_ver12-rev.dta

*	Generating "CS Type," an identifier for which types of CS the subject displayed
gen cs_type = .
replace cs_type = 1 if dd_all == 0 & gd_all == 0 
replace cs_type = 2 if dd_all == 0 & gd_all == 1 
replace cs_type = 3 if dd_all == 1 & gd_all == 0 
replace cs_type = 4 if dd_all == 1 & gd_all == 1 

gen cs_atleastone = .
replace cs_atleastone = 0 if cs_type == 1
replace cs_atleastone = 1 if cs_type != 1

*	Correlation between level k and different types of CS
corr subj_mean_level_ver1 dd_all 
corr subj_mean_level_ver1 gd_all
corr subj_mean_level_ver1 dd_all gd_all

corr subj_mean_level_ver2 dd_all 
corr subj_mean_level_ver2 gd_all
corr subj_mean_level_ver2 dd_all gd_all

twoway (scatter subj_mean_level_ver1 cs_type) (lfit subj_mean_level_ver1 cs_type), legend(off) ytitle("Subject Mean Level (ver 1)") xlabel(1 "Neither" 2 "GD Only" 3 "DD Only" 4 "Both") xtitle("CS Type")

twoway (scatter subj_mean_level_ver2 cs_type) (lfit subj_mean_level_ver2 cs_type), legend(off) ytitle("Subject Mean Level (ver 2)") xlabel(1 "Neither" 2 "GD Only" 3 "DD Only" 4 "Both") xtitle("CS Type")
















	
	
