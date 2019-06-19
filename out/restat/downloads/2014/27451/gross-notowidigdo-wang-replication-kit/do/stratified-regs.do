#delim cr
set more off
*version 11
pause on
graph set ps logo off

capture log close
set linesize 240
set logtype text
log using ../log/stratified-regs.log , replace

/* --------------------------------------

Use exemptions and zip code data to
stratify the main specs.

--------------------------------------- */

clear all
program drop _all
estimates clear
set mem 2000m

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
end

************************************************************
**   Define how graphs will be exported
************************************************************

** draw or do not draw graphs (0 stops drawing)
** drawgraphs is used to turn particular runs on/off
** master_... is the master switch to turn off all graphing
global drawgraphs 0
global master_drawgraphs 1

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
**   Chapter 7 by Tercile, Separate Regressions, relative time
**   2008, FP
************************************************************

foreach zip_var in own inc {
	preserve
		global day0 = mdy(5,16,2008)

		use ../dta/stratified-`zip_var'-2008.dta , clear

		** Check that we aren't missing zeroes
		isid r2008_week ssn2 tercile
		fillin r2008_week ssn2 tercile
		tab _fillin
		sum paper_date_2008 if _fillin == 1
		drop _fillin

		gen past_their_paper_week = 0
		replace past_their_paper_week = 1 if r2008_week > floor((paper_date_2008 - $day0) / 7)

		gen past_their_direct_week=0
		replace past_their_direct_week=1 if r2008_week > floor((direct_date_2008 - $day0) / 7)

		** The following code just demonstrates that the DD
		** indicators are coded properly for the 2nd group in each year.
		format filedate %td
		list filedate past_their_paper_week if paper_date_2008 == mdy(5,20,2008) , sepby(r2008_week)
		list filedate past_their_paper_week if paper_date_2008 == mdy(7,30,2008) , sepby(r2008_week)

		gen log_filecount = log(filecount)

		xi i.ssn2 i.r2008_week

		qui reg log_filecount past_their_paper_week past_their_direct_week _I* if tercile == 1, cluster(ssn2)
		combined_effect_2008
		estimates store `zip_var'_1

		qui reg log_filecount past_their_paper_week past_their_direct_week _I* if tercile == 2, cluster(ssn2)
		combined_effect_2008
		estimates store `zip_var'_2

		qui reg log_filecount past_their_paper_week past_their_direct_week _I* if tercile == 3, cluster(ssn2)
		combined_effect_2008
		estimates store `zip_var'_3

		disp "Now presenting Results for 2008, stratification variable `zip_var'"
		tabresults2008 "past*"

		** Run three regressions in one...
		drop if tercile != 1 & tercile != 2 & tercile != 3
		set matsize 800
		xi i.ssn2*i.tercile i.r2008_week*i.tercile

		forvalues i=1(1)3 {
			gen past_their_paper_week`i' = past_their_paper_week * (tercile == `i')
			gen past_their_direct_week`i' = past_their_direct_week * (tercile == `i')
		}

		reg log_filecount past_their_paper_week1 past_their_paper_week2 past_their_paper_week3 ///
		past_their_direct_week1 past_their_direct_week2 past_their_direct_week3 ///
		_I* , cluster(ssn2)
		estimates store `zip_var'

		** Test across coefficients:
		test past_their_paper_week1 == past_their_paper_week2
		test past_their_paper_week1 == past_their_paper_week3
		test past_their_paper_week2 == past_their_paper_week3
		test past_their_paper_week1 == past_their_paper_week2 == past_their_paper_week3
		test past_their_direct_week1 == past_their_direct_week2
		test past_their_direct_week1 == past_their_direct_week3
		test past_their_direct_week2 == past_their_direct_week3
		test past_their_direct_week1 == past_their_direct_week2 == past_their_direct_week3

		disp ""
		disp ""
		disp ""
		disp "Now presenting Results for 2008, stratification variable `zip_var'"
		tabresults2008 "past*"

	restore
}


************************************************************
**   Chapter 7 by Tercile, Separate Regressions, relative time
**   2001, FP
************************************************************

foreach zip_var in own inc {
	preserve
		global day0 = mdy(7,20,2001)

		use ../dta/stratified-`zip_var'-2001.dta , clear

		** Check that we aren't missing zeroes
		isid r2001_week ssn2 tercile
		fillin r2001_week ssn2 tercile
		tab _fillin
		drop _fillin

		gen past_their_paper_week = 0
		replace past_their_paper_week = 1 if r2001_week > floor((paper_date_2001 - $day0) / 7)

		** The following code just demonstrates that the DD
		** indicators are coded properly for the 2nd group in each year.
		format filedate %td
		list filedate past_their_paper_week if paper_date_2001 == mdy(5,20,2001) , sepby(r2001_week)
		list filedate past_their_paper_week if paper_date_2001 == mdy(7,30,2001) , sepby(r2001_week)

		gen log_filecount = log(filecount)

		xi i.ssn2 i.r2001_week

		qui reg log_filecount past_their_paper_week _I* if tercile == 1, cluster(ssn2)
		estimates store `zip_var'_1

		qui reg log_filecount past_their_paper_week _I* if tercile == 2, cluster(ssn2)
		estimates store `zip_var'_2

		qui reg log_filecount past_their_paper_week _I* if tercile == 3, cluster(ssn2)
		estimates store `zip_var'_3

		disp ""
		disp ""
		disp ""
		disp "Now presenting Results for 2001, stratification variable `zip_var'"
		tabresults "past*"

		** Run three regressions in one...
		drop if tercile != 1 & tercile != 2 & tercile != 3
		set matsize 800
		xi i.ssn2*i.tercile i.r2001_week*i.tercile

		forvalues i=1(1)3 {
			gen past_their_paper_week`i' = past_their_paper_week * (tercile == `i')
		}

		reg log_filecount past_their_paper_week1 past_their_paper_week2 past_their_paper_week3 _I* , cluster(ssn2)
		estimates store `zip_var'

		** Test across coefficients:
		test past_their_paper_week1 == past_their_paper_week2
		test past_their_paper_week1 == past_their_paper_week3
		test past_their_paper_week2 == past_their_paper_week3
		test past_their_paper_week1 == past_their_paper_week2 == past_their_paper_week3

		disp ""
		disp ""
		disp ""
		disp "Now presenting Results for 2001, stratification variable `zip_var'"
		tabresults "past*"

	restore
}

log close
exit
