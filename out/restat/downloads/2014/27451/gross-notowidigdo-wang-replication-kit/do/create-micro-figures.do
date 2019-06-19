#delim cr
set more off
*version 11
pause on
graph set ps logo off

if "`1'" != "2001" & "`1'" != "2008" & "`1'" != "all" {
	disp "Please specify a year"
	stop here
}
local year = "`1'"

capture log close
set linesize 250
set logtype text
log using ../log/create-micro-figures-`year'.log , replace

/* --------------------------------------

Make pictures based on the micro
data.

--------------------------------------- */

clear all
estimates clear
set mem 50m

use ../dta/data-for-micro-figures-`year'.dta

************************************************************
**   Define programs below
************************************************************

capture program drop mygraphexport
program define mygraphexport
	graph export `1'.$gph_extension , replace 
	* graph export `1'.ps , replace fontface("Garamond")
	* !ps2pdfwr `1'.ps `1'.pdf
	* !rm `1'.ps
end

************************************************************
**   Create CDFs, Income Pre & Post
************************************************************

preserve

	if `year' == 2001 {
		keep if figure == 12
		local figure = 12
	}
	if `year' == 2008 {
		keep if figure == 13
		local figure = 13
	}

	graph set window fontface "Garamond"
	tw ///
	(scatter cdf_post annual_income , sort connect(l) msymbol(i) lcolor(blue) lpattern(solid) ) ///
	(scatter cdf_pre annual_income , sort connect(l) msymbol(i) lcolor(black) lpattern(dash) ) ///
		, ///
		///
		title("") ///
		scheme(s2mono) ylabel(, nogrid angle(horizontal)) graphregion(fcolor(white)) ///
		yscale( nofextend ) xscale(nofextend) ///
		xtitle("Income of Filers") ///
		legend(region(style(none))) ///
		ytitle("Cumulative Distribution" " ") ///
		title("Figure `figure': Filers' Income Before and After the Rebates, `year'") ///
		yscale( r(0.35 1) ) ///
		xlabel(30000 "$30,000" 60000 "$60,000" 90000 "$90,000" 120000 "$120,000") ///
		note(" .")
	mygraphexport ../gph/fig`figure'
restore

************************************************************
**   Create CDFs, Liabilities-to-Income Ratio
************************************************************

preserve

	if `year' == 2001 {
		local figure = 10
		keep if figure == 10
	}
	if `year' == 2008 {
		local figure = 11
		keep if figure == 11
	}

	graph set window fontface "Garamond"
	tw ///
	(scatter cdf_post liabs_inc_comb , sort connect(l) msymbol(i) lcolor(blue) lpattern(solid) ) ///
	(scatter cdf_pre liabs_inc_comb , sort connect(l) msymbol(i) lcolor(black) lpattern(dash) ) ///
		, ///
		///
		title("") ///
		scheme(s2mono) ylabel(, nogrid angle(horizontal)) graphregion(fcolor(white)) ///
		yscale( nofextend ) xscale(nofextend) ///
		legend(region(style(none))) ///
		xlabel(5 10 15 20) ///
		xtitle("Liabilities-to-Income Ratio") ///
		ytitle("Cumulative Distribution" " ") ///
		title("Figure `figure': Filers' Liabilities-to-Income Ratio" "Before and After the Rebates, `year'") ///
		note(" ")
	mygraphexport ../gph/fig`figure'

restore

************************************************************
**   Create CDFs, Liabilities Pre & Post
************************************************************

preserve
	if `year' == 2001 {
		local figure = 8
		keep if figure == 8
	}
	if `year' == 2008 {
		local figure = 9
		keep if figure == 9
	}

	graph set window fontface "Garamond"
	tw ///
	(scatter cdf_post total_liabs , sort connect(l) msymbol(i) lcolor(blue) lpattern(solid) ) ///
	(scatter cdf_pre total_liabs , sort connect(l) msymbol(i) lcolor(black) lpattern(dash) ) ///
		, ///
		///
		title("") ///
		scheme(s2mono) ylabel(, nogrid angle(horizontal)) graphregion(fcolor(white)) ///
		yscale( nofextend ) xscale(nofextend) ///
		legend(region(style(none))) ///
		xtitle("Total Liabilities of Filers") ///
		ytitle("Cumulative Distribution" " ") ///
		title("Figure `figure': Filers' Liabilities Before and After the Rebates, `year'") ///
		xlabel(200000 "$200,000" 400000 "$400,000" 600000 "$600,000" 800000 "$800,000") ///
		yscale( r(0.7 1) ) ///
		note(" ")
	mygraphexport ../gph/fig`figure'

restore

log close
exit
