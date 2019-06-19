#delim cr
set more off
*version 11
pause on
graph set ps logo off

capture log close
set linesize 240
set logtype text
log using ../log/main-excercises.log , replace

/* --------------------------------------

Perform all regressions on the main bankruptcy
counts.

--------------------------------------- */

clear all
program drop _all
estimates clear
set mem 1000m

************************************************************
**   Define how graphs will be exported
************************************************************

** draw or do not draw graphs (0 stops drawing)
** drawgraphs is used to turn particular runs on/off
** master_... is the master switch to turn off all graphing
global drawgraphs 1
global master_drawgraphs 1

************************************************************
**   Program to add direct deposit point estimates
************************************************************

** This program is run after 2008 difference-in-difference 
** regressions, which have two post dummies. It calculates the 
** combined effect, and saves some estimates for estout. One must then
** call estout manually as so:
** estout * using table2.txt, stats(sum_b sum_se sum_p r2 N, fmt(%9.3f)) 
** ...

capture program drop post_param
program define post_param, eclass
	ereturn scalar `1' = `2'
end

capture program drop combined_effect_2008
program define combined_effect_2008
	lincom past_their_paper_week + past_their_direct_week
	post_param "sum_b" r(estimate)
	post_param "sum_se" r(se)
	local p = 2 * ttail( e(df_r) , abs(r(estimate) / r(se))) 
	post_param "sum_p" `p'
	global sum_beta = r(estimate)
	global sum_se = r(se)
end

************************************************************
**   Tabulation Program Used Below                          
************************************************************

capture program drop tabresults
program tabresults
    disp "Readable Output:  "
    estout * , keep( `1' ) ///
    stats(r2 N, fmt(%9.3f %9.0g)) ///
    cells(b( fmt(%9.3f)) se( par(( )) fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) ) style(fixed) replace mlabels(, nonumbers ) 

    disp ""
    disp "To be pasted into excel:  "
    estout * , keep( `1' ) ///
    stats(r2 N, fmt(%9.6f %9.0g)) ///
    cells(b(nostar fmt(%9.6f)) se(fmt(%9.6f) nostar) p(fmt(%9.6f) )) ///
    style(fixed) replace type mlabels(, nonumbers )
    
    estimates clear
end

** then call it with:
** tabresults "totel_wk hynes_*"

capture program drop tabresults2008
program tabresults2008
	disp "Readable Output:  "
	estout * , keep( past* ) ///
	stats(sum_b sum_se sum_p r2 N, fmt(%9.3f %9.0g)) ///
	cells(b( fmt(%9.3f)) se( par(( )) fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) ) style(fixed) replace mlabels(, nonumbers ) 

	disp ""
	disp "To be pasted into excel:  "
	estout * , keep( past* ) ///
	stats(sum_b sum_se sum_p r2 N, fmt(%9.6f %9.0g)) ///
	cells(b(nostar fmt(%9.6f)) se(fmt(%9.6f) nostar) p(fmt(%9.6f) )) ///
	style(fixed) replace type mlabels(, nonumbers )
	estimates clear
end

************************************************************
**   Make Randomization Test Graph, one graph, FP
************************************************************

** For 2001:
foreach year in 2008 2001 {
	preserve
		use ../dta/randomization-test-graph-`year'.dta , clear

		xi i.ssn2

		gen log_filecount = log(filecount)

		** Notice that the regression below does not 'cluster' the
		** standard errors. This is intetional, and based on my e-mail 
		** conversation with Matt.
		areg filecount _I* , a(r`year'_week) 
		testparm _I* , equal
		local p`year' = floor( 1000 * `r(p)' ) / 1000
	restore
}

preserve
	use ../dta/randomization-test-graph-all.dta , clear

	** Convert to approximate weekly rate
	replace filecount = filecount / ((mdy(6,1,2001) - mdy(3,1,2001)) / 7) if year == 2001
	replace filecount = filecount / ((mdy(4,1,2008) - mdy(1,1,2008)) / 7) if year == 2008
	bysort year: sum filecount 

	graph set window fontface "Garamond"
	tw ///
		(scatter filecount ssn2 if year == 2001, mcolor(blue) msymbol(circle) ) ///
		(scatter filecount ssn2 if year == 2008, mcolor(red) msymbol(square) ) ///
		(pcarrowi 320 80 290 68 (3) "2001" ///
		90 10 130 15 (9) "2008") ///
		, ///
		legend(off) ///
		xtitle("Last two digits of SSN") ///
		yscale( r(0 `ymax') ) ///
		scheme(s2mono) ylabel(, nogrid) graphregion(fcolor(white)) ///
		ytitle("Weekly Bankruptcy Rate in Pre-Period") ///
		title("Figure 2. Randomization Test") ///
		xlabel(0 "00" 10 "10" 20 "20" 30 "30" 40 "40" 50 "50" 60 "60" 70 "70" 80 "80" 90 "90" 99 "99") ///
		ylabel(0 100 200 300 400) ///
		yscale( nofextend ) xscale(nofextend) ///
		ylabel( , angle(horizontal)) ///
		note(" ")
	graph export ../gph/fig2.$gph_extension , replace

restore

************************************************************
**   Figure: Plot chapter 7 results for all years, FP
************************************************************

** The 'matrix' commands save the regression results
** to be graphed.

matrix results_logs_ch7 = J(200,4,0)
local row = 0

forvalues y = 1998(1)2008 {
	preserve
		if `y' <= 2004 {
			global day0 = mdy(7,20,`y')
			local pseudo_year = 2001
		}
		if `y' >= 2005 {
			global day0 = mdy(5,16,`y')
			local pseudo_year = 2008
		}

		local row = `row' + 1

		use ../dta/chapter-7-results-other-years-`y'.dta , clear

		gen their_paper_week = 0
		replace their_paper_week = 1 if floor((filedate - $day0 ) / 7) == floor((paper_date - $day0 ) / 7)
		gen past_their_paper_week = 0
		replace past_their_paper_week = 1 if floor((filedate - $day0 ) / 7) > floor((paper_date - $day0 ) / 7)
		sum their_paper_week past_their_paper_week

		if `y' >= 2005 {
			gen past_their_direct_week = 0
			replace past_their_direct_week = 1 if week_var > floor((direct_date_`pseudo_date' - $day0) / 7)
			sum past_their_direct_week
		}

		gen log_filecount = log(filecount)
		xi i.ssn2 i.week_var
	    
		disp ""
		disp ""
		disp ""
		disp "Regression for year `y'"
		if `y' <= 2004 {
			reg log_filecount past_their_paper_week _I* , cluster(ssn2)
			estimates store e_7_log

			matrix results_logs_ch7[`row',1] = `y'
			matrix results_logs_ch7[`row',2] = _b[past_their_paper_week] - 1.98 * _se[past_their_paper_week]
			matrix results_logs_ch7[`row',3] = _b[past_their_paper_week]
			matrix results_logs_ch7[`row',4] = _b[past_their_paper_week] + 1.98 * _se[past_their_paper_week]

			disp ""
			disp ""
			disp ""
			disp "Now presenting Results for `y'"
			tabresults "past*"
		}
		if `y' >= 2005 {
			reg log_filecount past_their_paper_week past_their_direct_week _I* , cluster(ssn2)
			combined_effect_2008
			estimates store e_7_log

			matrix results_logs_ch7[`row',1] = `y'
			matrix results_logs_ch7[`row',2] = $sum_beta - 1.98 * $sum_se
			matrix results_logs_ch7[`row',3] = $sum_beta
			matrix results_logs_ch7[`row',4] = $sum_beta + 1.98 * $sum_se

			disp ""
			disp ""
			disp ""
			disp "Now presenting Results for `y'"
			tabresults2008 "past*"
		}


	restore
}

preserve
	drop _all
	svmat results_logs_ch7
	rename results_logs_ch71 sample
	rename results_logs_ch72 lower_bound
	rename results_logs_ch73 beta
	rename results_logs_ch74 upper_bound
	drop if sample == 0

	graph set window fontface "Garamond"
	tw ///
		(rcap lower_bound upper_bound sample, ) ///
		(scatter beta sample if sample != 2001 & sample != 2008, mcolor(blue) msymbol(O) msize(medium) ) ///
		(scatter beta sample if sample == 2001 | sample == 2008, mcolor(red) msymbol(S) msize(medium) ) ///
		, ///
		scheme(s2mono) ylabel(, nogrid  angle(horizontal)  ) graphregion(fcolor(white)) ///
		yline(0) legend(off) ///
		yscale( nofextend ) xscale(nofextend) ///
		xtitle("Year Used For Sample") ///
		title("Figure 3. Chapter 7 Rebate Effect by Year") ///
		note(" ") ///
		ytitle("Difference-in-Difference" "Point Estimate") 
	graph export ../gph/fig3.$gph_extension , replace
	
restore

************************************************************
**   Try wider window, 2001
************************************************************

preserve

	global week_var = "r2001_week"
	global day0 = mdy(7,20,2001)

	use ../dta/wider-window-2001.dta , clear

	gen their_paper_week = 0
	replace their_paper_week = 1 if $week_var == floor((paper_date_2001 - $day0) / 7)
	gen past_their_paper_week = 0
	replace past_their_paper_week = 1 if $week_var > floor((paper_date_2001 - $day0) / 7)

	** The following code just demonstrates that the DD
	** indicators are coded properly for the 2nd group in each year.
	format filedate %td
	list filedate their_paper_week past_their_paper_week if paper_date_2001 == mdy(5,20,2001) & chapter == 7, sepby($week_var)
	list filedate their_paper_week past_their_paper_week if paper_date_2001 == mdy(7,30,2001) & chapter == 7, sepby($week_var)

	gen log_filecount = log(filecount)

	xi i.ssn2 i.$week_var
    
	qui reg filecount past_their_paper_week _I* if chapter == 7, cluster(ssn2)
	estimates store e_7_lev
	
	qui reg log_filecount past_their_paper_week _I* if chapter == 7, cluster(ssn2)
	estimates store e_7_log
	
	qui reg filecount past_their_paper_week _I* if chapter == 13, cluster(ssn2)
	estimates store e_13_lev
	
	qui reg log_filecount past_their_paper_week _I* if chapter == 13, cluster(ssn2)
	estimates store e_13_log

	collapse (sum) filecount (min) filedate (mean) past_their_paper_week , by(paper_date_2001 ssn2 $week_var) fast

	gen log_filecount = log(filecount)
	xi i.ssn2 i.$week_var

	qui reg filecount past_their_paper_week _I* , cluster(ssn2)
	estimates store e_all_lev
	
	qui reg log_filecount past_their_paper_week _I* , cluster(ssn2)
	estimates store e_all_log

	disp ""
	disp ""
	disp ""
	disp "Results for year `year'"
	tabresults "past*"

restore

************************************************************
**   Try a wider window, 2008
************************************************************

** This is part of two tables: the "main" DD table and the 
** falsification table (with many years).

preserve

	global week_var = "r2008_week"
	global day0 = mdy(5,16,2008)

	use ../dta/wider-window-2008.dta , clear

	gen their_paper_week = 0
	replace their_paper_week = 1 if $week_var == floor((paper_date_2008 - $day0) / 7)
	gen past_their_paper_week = 0
	replace past_their_paper_week = 1 if $week_var > floor((paper_date_2008 - $day0) / 7)

	gen their_direct_week=0
	replace their_direct_week=1 if $week_var == floor((direct_date_2008 - $day0) / 7)

	gen past_their_direct_week=0
	replace past_their_direct_week=1 if $week_var > floor((direct_date_2008 - $day0) / 7)

	gen past_their_direct_week0=0
	replace past_their_direct_week0=1 if $week_var >= floor((direct_date_2008 - $day0) / 7)

	gen past_their_direct_week2=0
	replace past_their_direct_week2=1 if $week_var > floor((direct_date_2008 - $day0) / 7) & $week_var <= floor((direct_date_2008 - $day0) / 7)+6

	gen past_their_direct_week3=0
	replace past_their_direct_week3=1 if filedate - $day0 > 3

	** The following code just demonstrates that the DD
	** indicators are coded properly for the 2nd group in each year.
	format filedate %td
	list filedate their_paper_week past_their_paper_week if paper_date_2008 == mdy(5,20,2008) & chapter == 7, sepby($week_var)
	list filedate their_paper_week past_their_paper_week if paper_date_2008 == mdy(7,30,2001) & chapter == 7, sepby($week_var)

	gen log_filecount = log(filecount)

	xi i.ssn2 i.$week_var
    
    	disp "Chapter 7, Levels"
	qui reg filecount past_their_paper_week past_their_direct_week _I* if chapter == 7, cluster(ssn2)
	combined_effect_2008
	estimates store e_7_lev
	
	disp "Chapter 7, Logs"
	qui reg log_filecount past_their_paper_week past_their_direct_week _I* if chapter == 7, cluster(ssn2)
	combined_effect_2008
	estimates store e_7_log
	
	disp "Chapter 13, Levels"
	qui reg filecount past_their_paper_week past_their_direct_week _I* if chapter == 13, cluster(ssn2)
	combined_effect_2008
	estimates store e_13_lev
	
	disp "Chapter 13, Logs"
	qui reg log_filecount past_their_paper_week past_their_direct_week _I* if chapter == 13, cluster(ssn2)
	combined_effect_2008
	estimates store e_13_log

	collapse (sum) filecount (min) filedate (mean) past_their_paper_week past_their_direct_week past_their_direct_week0 past_their_direct_week2, by(paper_date_2008 direct_date_2008 ssn2 $week_var) fast

	gen log_filecount = log(filecount)
	xi i.ssn2 i.$week_var

	disp "All Chapters, Levels"
	qui reg filecount past_their_paper_week past_their_direct_week _I* , cluster(ssn2)
	combined_effect_2008
	estimates store e_all_lev
	
	disp "All Chapters, Logs"
	qui reg log_filecount past_their_paper_week past_their_direct_week _I* , cluster(ssn2)
	combined_effect_2008
	estimates store e_all_log

	tabresults2008 "*"


restore

************************************************************
**   2008 Chapter X Levels/Logs, FP
************************************************************

** This is part of two tables: the "main" DD table and the 
** falsification table (with many years).

preserve

	global week_var = "r2008_week"
	global day0 = mdy(5,16,2008)

	use ../dta/results-2008.dta , clear

	gen their_paper_week = 0
	replace their_paper_week = 1 if $week_var == floor((paper_date_2008 - $day0) / 7)
	gen past_their_paper_week = 0
	replace past_their_paper_week = 1 if $week_var > floor((paper_date_2008 - $day0) / 7)

	gen their_direct_week=0
	replace their_direct_week=1 if $week_var == floor((direct_date_2008 - $day0) / 7)

	gen past_their_direct_week=0
	replace past_their_direct_week=1 if $week_var > floor((direct_date_2008 - $day0) / 7)

	gen past_their_direct_week0=0
	replace past_their_direct_week0=1 if $week_var >= floor((direct_date_2008 - $day0) / 7)

	gen past_their_direct_week2=0
	replace past_their_direct_week2=1 if $week_var > floor((direct_date_2008 - $day0) / 7) & $week_var <= floor((direct_date_2008 - $day0) / 7)+6

	gen past_their_direct_week3=0
	replace past_their_direct_week3=1 if filedate - $day0 > 3

	** The following code just demonstrates that the DD
	** indicators are coded properly for the 2nd group in each year.
	format filedate %td
	list filedate their_paper_week past_their_paper_week if paper_date_2008 == mdy(5,20,2008) & chapter == 7, sepby($week_var)
	list filedate their_paper_week past_their_paper_week if paper_date_2008 == mdy(7,30,2001) & chapter == 7, sepby($week_var)

	gen log_filecount = log(filecount)

	xi i.ssn2 i.$week_var
    
    	disp "Chapter 7, Levels"
	qui reg filecount past_their_paper_week past_their_direct_week _I* if chapter == 7, cluster(ssn2)
	combined_effect_2008
	estimates store e_7_lev
	
	disp "Chapter 7, Logs"
	qui reg log_filecount past_their_paper_week past_their_direct_week _I* if chapter == 7, cluster(ssn2)
	combined_effect_2008
	estimates store e_7_log
	
	disp "Chapter 13, Levels"
	qui reg filecount past_their_paper_week past_their_direct_week _I* if chapter == 13, cluster(ssn2)
	combined_effect_2008
	estimates store e_13_lev
	
	disp "Chapter 13, Logs"
	qui reg log_filecount past_their_paper_week past_their_direct_week _I* if chapter == 13, cluster(ssn2)
	combined_effect_2008
	estimates store e_13_log

	collapse (sum) filecount (min) filedate (mean) past_their_paper_week past_their_direct_week past_their_direct_week0 past_their_direct_week2, by(paper_date_2008 direct_date_2008 ssn2 $week_var) fast

	gen log_filecount = log(filecount)
	xi i.ssn2 i.$week_var

	disp "All Chapters, Levels"
	qui reg filecount past_their_paper_week past_their_direct_week _I* , cluster(ssn2)
	combined_effect_2008
	estimates store e_all_lev
	
	disp "All Chapters, Logs"
	qui reg log_filecount past_their_paper_week past_their_direct_week _I* , cluster(ssn2)
	combined_effect_2008
	estimates store e_all_log

	tabresults2008 "*"


restore

************************************************************
**   Summary Stats by year & SSN group
************************************************************

foreach rebate_year in 2001 2008 {
	disp ""
	disp ""
	disp ""
	disp "Results for year `rebate_year'"
	preserve

		if `rebate_year' == 2001 {
			global week_var = "r2001_week"
			global day0 = mdy(7,20,2001)
		}
		if `rebate_year' == 2008 {
			global week_var = "r2008_week"
			global day0 = mdy(5,16,2008)
		}

		use ../dta/summary-stats-`rebate_year'.dta , clear

		format paper_date_`rebate_year' %td
		table paper_date_`rebate_year' , c(mean chapter7 mean chapter13 mean totalbk)
		sum chapter7 chapter13 totalbk 

	restore
}

************************************************************
**   2001 Chapter X Levels/Logs, FP
************************************************************

preserve

	global week_var = "r2001_week"
	global day0 = mdy(7,20,2001)

	use ../dta/results-2001.dta , clear

	gen their_paper_week = 0
	replace their_paper_week = 1 if $week_var == floor((paper_date_2001 - $day0) / 7)
	gen past_their_paper_week = 0
	replace past_their_paper_week = 1 if $week_var > floor((paper_date_2001 - $day0) / 7)

	** The following code just demonstrates that the DD
	** indicators are coded properly for the 2nd group in each year.
	format filedate %td
	list filedate their_paper_week past_their_paper_week if paper_date_2001 == mdy(5,20,2001) & chapter == 7, sepby($week_var)
	list filedate their_paper_week past_their_paper_week if paper_date_2001 == mdy(7,30,2001) & chapter == 7, sepby($week_var)

	gen log_filecount = log(filecount)

	xi i.ssn2 i.$week_var
    
	qui reg filecount past_their_paper_week _I* if chapter == 7, cluster(ssn2)
	estimates store e_7_lev
	
	qui reg log_filecount past_their_paper_week _I* if chapter == 7, cluster(ssn2)
	estimates store e_7_log
	
	qui reg filecount past_their_paper_week _I* if chapter == 13, cluster(ssn2)
	estimates store e_13_lev
	
	qui reg log_filecount past_their_paper_week _I* if chapter == 13, cluster(ssn2)
	estimates store e_13_log

	collapse (sum) filecount (min) filedate (mean) past_their_paper_week , by(paper_date_2001 ssn2 $week_var) fast

	gen log_filecount = log(filecount)
	xi i.ssn2 i.$week_var

	qui reg filecount past_their_paper_week _I* , cluster(ssn2)
	estimates store e_all_lev
	
	qui reg log_filecount past_their_paper_week _I* , cluster(ssn2)
	estimates store e_all_log

	disp ""
	disp ""
	disp ""
	disp "Results for year `year'"
	tabresults "past*"

restore


log close
exit
