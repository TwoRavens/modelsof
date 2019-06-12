cd "C:\Dropbox\WTO Deter Local\"
use working_2014_07_11_ctrl_disp.dta, clear

* Useful dummy variable for summary statistics 
*bysort st1hs_num: egen anydispute=max(dispute)
*drop if anydispute==.
*su dispute if anydispute==1

*** Summary Statistics ***
* Table 1
* testflag = 1 if the importer-product never experiences a dispute or only does so for the first time in 2010
sort st1hs_num year
gen anydislist=1 if dis_list!=""
recode anydislist (.=0)
by st1hs_num: egen test=total(anydislist)
gen flag = 0
replace flag = 1 if test==0
bysort st1hs_num: egen testflag=max(flag)

log using sumstats, replace

* Table 1
xtreg logimports96 dispute $ctrl1, fe robust cluster(st1)
	codebook st1hs_num if e(sample)
	codebook st1hs_num if e(sample) & testflag==0
foreach var in logimports96 dispute resp_polity_it lnpc logged_resp crisistally {
	su `var' if e(sample)
	su `var' if e(sample) & testflag==0
	}	
*
xtreg demean_logimports96 demean_dispute, fe robust cluster(st1)
codebook st1hs_num if e(sample)
codebook st1hs_num if e(sample) & testflag==0
foreach var in dispute logimports96 demean_dispute demean_logimports96 {
	su `var' if e(sample)
	su `var' if e(sample) & testflag==0
	}	
*
log close






*** REGRESSIONS ***
* Note: these are the country year control variables
* Also, for the country-year fixed effects regressions, we manually demeaned the relevant variables by country-years.  That's why these regressions use
* 	demean_logimports96 demean_dispute.

global ctrl1 "resp_polity_it lnpc logged_resp crisistally"

*** TABLE 2: Baseline Results ***
* Full sample
xtreg logimports96 dispute $ctrl1, fe robust cluster(st1)
xtreg demean_logimports96 demean_dispute, fe robust cluster(st1)
* Exclude USA/EU
xtreg logimports96 dispute $ctrl1 if st1!=2 & st1!=3, fe robust cluster(st1)
xtreg demean_logimports96 demean_dispute if st1!=2 & st1!=3, fe robust cluster(st1)
* OECD Only, non-OECD only
xtreg logimports96 dispute $ctrl1 if oecd==1, fe robust cluster(st1)
xtreg demean_logimports96 demean_dispute if oecd==1, fe robust cluster(st1)
xtreg logimports96 dispute $ctrl1 if oecd==0, fe robust cluster(st1)
xtreg demean_logimports96 demean_dispute if oecd==0, fe robust cluster(st1)
* Exclude steel
xtreg logimports96 dispute $ctrl1 if steel!=1, fe robust cluster(st1)
xtreg demean_logimports96 demean_dispute if steel!=1, fe robust cluster(st1)


*** TABLE 3: Lagged Dispute Effects ***
* Note: this generates the lagged variables
	gen l1dispute = l.dispute
	gen l1demean_dispute = l.demean_dispute
	gen l2dispute = l.l1dispute
	gen l2demean_dispute = l.l1demean_dispute
	gen l3dispute = l.l2dispute
	gen l3demean_dispute = l.l2demean_dispute
	gen l4dispute = l.l3dispute
	gen l4demean_dispute = l.l3demean_dispute
	gen l5dispute = l.l4dispute
	gen l5demean_dispute = l.l4demean_dispute
	gen l6dispute = l.l5dispute
	gen l6demean_dispute = l.l5demean_dispute
*
	
xtreg logimports96 l1dispute $ctrl1, fe robust cluster(st1)
xtreg demean_logimports96 l1demean_dispute, fe robust cluster(st1)
xtreg logimports96 l2dispute $ctrl1, fe robust cluster(st1)
xtreg demean_logimports96 l2demean_dispute, fe robust cluster(st1)
xtreg logimports96 l3dispute $ctrl1, fe robust cluster(st1)
xtreg demean_logimports96 l3demean_dispute, fe robust cluster(st1)
xtreg logimports96 l4dispute $ctrl1, fe robust cluster(st1)
xtreg demean_logimports96 l4demean_dispute, fe robust cluster(st1)
xtreg logimports96 l5dispute $ctrl1, fe robust cluster(st1)
xtreg demean_logimports96 l5demean_dispute, fe robust cluster(st1)
xtreg logimports96 l6dispute $ctrl1, fe robust cluster(st1)
xtreg demean_logimports96 l6demean_dispute, fe robust cluster(st1)


	
*** TABLE 4: Dispute Status ***
xtreg logimports96 status_1 status_2 status_3 status_4 $ctrl1, fe robust cluster(st1)
xtreg demean_logimports96 demean_status_1 demean_status_2 demean_status_3 demean_status_4, fe robust cluster(st1)
* Exclude USA/EU
xtreg logimports96 status_1 status_2 status_3 status_4 $ctrl1 if st1!=2 & st1!=3, fe robust cluster(st1)
xtreg demean_logimports96 demean_status_1 demean_status_2 demean_status_3 demean_status_4 if st1!=2 & st1!=3, fe robust cluster(st1)
* OECD Only, non-OECD only
xtreg logimports96 status_1 status_2 status_3 status_4 $ctrl1 if oecd==1, fe robust cluster(st1)
xtreg demean_logimports96 demean_status_1 demean_status_2 demean_status_3 demean_status_4 if oecd==1, fe robust cluster(st1)
xtreg logimports96 status_1 status_2 status_3 status_4 $ctrl1 if oecd==0, fe robust cluster(st1)
xtreg demean_logimports96 demean_status_1 demean_status_2 demean_status_3 demean_status_4 if oecd==0, fe robust cluster(st1)
* Exclude steel
xtreg logimports96 status_1 status_2 status_3 status_4 $ctrl1 if steel!=1, fe robust cluster(st1)
xtreg demean_logimports96 demean_status_1 demean_status_2 demean_status_3 demean_status_4 if steel!=1, fe robust cluster(st1)


*** TABLE 5: Dispute Issues ***
* Demeaning these dispute characteristic variables
foreach var of varlist safeguards ad sps agriculture {	
	egen mean_`var'_st1yr = mean(`var'), by(st1yr_num)
	gen demean_`var' = `var' - mean_`var'_st1yr
	}
*
xtreg logimports96 dispute safeguards sps agriculture ad $ctrl1, fe robust cluster(st1)
xtreg demean_logimports96 demean_dispute demean_safeguards demean_sps demean_agriculture demean_ad, fe robust cluster(st1)


***
* TABLE 6: MLM Model.
*	The multilevel regressions were done in R.  See accompanying files.
***


***
* Figures
***
* Figure 1: Import values for disputed and undisputed products

lpoly logimports96 year if anydispute==0, gen(xad_0 yad_0) se(sead_0) nogr
lpoly logimports96 year if anydispute==1, gen(xad_1 yad_1) se(sead_1) nogr
forvalues v=0(1)1 {
	gen ulad_`v' = yad_`v' + 1.95*sead_`v' 
    gen llad_`v' = yad_`v' - 1.95*sead_`v'
}
*
local leg "legend(order(3 "Non-disputed products" 6 "Disputed products"))"
tw (line ulad_0 llad_0 yad_0 xad_0, lcolor(blue blue blue) lpattern(dash dash solid)) (line ulad_1 llad_1 yad_1 xad_1, lcolor(red red red) lpattern(dash dash solid)), xtitle("year") `leg'
	graph export "C:\Dropbox\WTO Deter Local\Drafts_CKP\anydisputeyear_linesonly.eps", as(eps) preview(off) replace



* Figure 2: Import values before and after dispute, windows


lpoly logimports96 outcome_year_window, msize(tiny) title("All Years") xtitle("Years Before/After Dispute") xmtick(-19(1)15) xlabel(-15(5)15) ytitle("ln(Imports)") ymtick(0(5)25) ylabel(0(25)25) nogr gen(x_01 y_01) se(se_01)
*	graph save windowall.gph, replace
lpoly logimports96 outcome_year_window if outcome_window5==1, msize(tiny) title("5 Year Window") xtitle("Years Before/After Dispute") xmtick(-5(1)5) xlabel(-5(1)5) ytitle("ln(Imports)") ymtick(0(5)25) ylabel(0(25)25) nogr gen(x_02 y_02) se(se_02)
*	graph save window5.gph, replace
lpoly logimports96 outcome_year_window if outcome_window3==1, msize(tiny) title("3 Year Window") xtitle("Years Before/After Dispute") xmtick(-3(1)3) xlabel(-3(1)3) ytitle("ln(Imports)") ymtick(0(5)25) ylabel(0(25)25) nogr gen(x_03 y_03) se(se_03)
*	graph save window3.gph, replace
*	graph combine windowall.gph window5.gph window3.gph, ycomm title("Outcome Windows") c(1)
*	graph export "C:\Dropbox\WTO Deter Local\Drafts_CKP\outcomewindows.eps", as(eps) preview(off) replace
forvalues v=1(1)3 {
	gen ul_0`v' = y_0`v' + 1.95*se_0`v' 
    gen ll_0`v' = y_0`v' - 1.95*se_0`v'
}
	tw line ul_01 ll_01 y_01 x_01 if x_01<=10 & x_01>=-10, xtitle("") lcolor(red red red) lpattern(dash dash solid) legend(off)
	graph save window_01.gph, replace
	tw line ul_02 ll_02 y_02 x_02 if x_02<=20 & x_02>=-20, xtitle("Years Before/After Dispute Outcome") lcolor(red red red) lpattern(dash dash solid) legend(off) xlabel(-5(1)5) xmtick(-5(1)5)
	graph save window_02.gph, replace
	tw line ul_03 ll_03 y_03 x_03 if x_03<=30 & x_03>=-30, xtitle("Years Before/After Dispute Outcome") lcolor(red red red) lpattern(dash dash solid) legend(off)
	graph save window_03.gph, replace
*
*	graph combine window_01.gph window_02.gph window_03.gph, ycomm title("Outcome Windows") c(1)
	graph combine window_01.gph window_02.gph, ycomm title("") c(1)
	graph export "C:\Dropbox\WTO Deter Local\Drafts_CKP\outcomewindows_linesonly.eps", as(eps) preview(off) replace

* Figure 3: Import values before and after dispute, by dispute outcome

recode status (4=-1)
bysort st1hs_num: egen maxstatus = max(status)

forvalues v=1(1)3 {
	lpoly logimports96 outcome_year_window if maxstatus==`v', gen(xd_s`v' yd_s`v') se(sed_s`v') nogr
	gen uld_s`v' = yd_s`v' + 1.95*sed_s`v' 
    gen lld_s`v' = yd_s`v' - 1.95*sed_s`v'
}
*
tw (line uld_s1 lld_s1 yd_s1 xd_s1 if xd_s1<=10 & xd_s1>=-10, lcolor(blue blue blue) lpattern(dash dash solid)) (line uld_s2 lld_s2 yd_s2 xd_s2 if xd_s2<=10 & xd_s2>=-10, lcolor(red red red) lpattern(dash dash solid)) (line uld_s3 lld_s3 yd_s3 xd_s3 if xd_s3<=10 & xd_s3>=-10, lcolor(green green green) lpattern(dash dash solid)), ytitle("log(Imports)") legend(off) xtitle("")
	graph save status_10yr_window.gph, replace
local leg "legend(order(3 "Dropped" 6 "MAS" 9 "Panel Ruling"))"
tw (line uld_s1 lld_s1 yd_s1 xd_s1 if xd_s1<=5 & xd_s1>=-5, lcolor(blue blue blue) lpattern(dash dash solid)) (line uld_s2 lld_s2 yd_s2 xd_s2 if xd_s2<=5 & xd_s2>=-5, lcolor(red red red) lpattern(dash dash solid)) (line uld_s3 lld_s3 yd_s3 xd_s3 if xd_s3<=5 & xd_s3>=-5, lcolor(green green green) lpattern(dash dash solid)), ytitle("log(Imports)")  xtitle("Years Before/After Dispute") `leg'  xlabel(-5(1)5) xmtick(-5(1)5)
	graph save status_5yr_window.gph, replace
	grc1leg status_10yr_window.gph status_5yr_window.gph, ycomm title("") c(1) legendfrom(status_5yr_window.gph)
	graph export "C:\Dropbox\WTO Deter Local\Drafts_CKP\outcomewindows_linesonly_status.eps", as(eps) preview(off) replace

* Figure 4 (See R files)
