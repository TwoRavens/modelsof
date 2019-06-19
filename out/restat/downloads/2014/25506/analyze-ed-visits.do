#delim cr
set more off
*version 11
pause on
graph set ps logo off

capture log close
set linesize 80
set logtype text
log using ../log/analyze-ed-visits.log , replace

/* --------------------------------------

AUTHOR: Tal Gross

PURPOSE: Analyze the counts of ED visits that 
Carlos created.

DATE CREATED:  November 23, 2011

NOTES:

--------------------------------------- */

clear all
estimates clear
set mem 150m
describe, short


************************************************************
**   Define Programs
************************************************************

** On Windows, you must export to postscript
global graph_extension = "pdf"
*global graph_extension = "ps"

capture program drop tabresults
program tabresults
	disp "Readable Output:  "
	esttab * , keep( `1' ) ///
	stats(r2 N, fmt(%9.3f %9.0g)) ///
	mlabels(, title) ///
	cells(b( fmt(%9.3f)) se( par(( )) fmt(%9.3f)) p(par([ ]) fmt(%9.3f)) ) replace 	

	disp "To be pasted into excel:  "
	estout * , keep( `1' ) ///
	stats(r2 N, fmt(%9.6f %9.0g)) ///
	cells(b(nostar fmt(%9.6f)) se(fmt(%9.6f) nostar) p(fmt(%9.6f) )) ///
	style(fixed) replace type mlabels(, nonumbers )

	estimates clear
end

************************************************************
**   Bring in ED Data
************************************************************

insheet using "../src/P03 ED Analysis File.csv" , names comma
d, f


************************************************************
**   Prep RD Variables
************************************************************

sum months_23
gen byte above_age_23 = (months_23 > 0)
gen msb_X_aa23 = months_23 * above_age_23
gen msb_X_ua23 = months_23 * (1 - above_age_23)
list months_23 above_age_23 msb_X_aa23 msb_X_ua23

************************************************************
**   Adjusted IV, Table 3, FP
************************************************************

preserve


	keep if msb_X_ua23 >= -11 & msb_X_aa23 <= 12 

	foreach outcome in all_np_l all_np_pub_l all_np_non_prof_l all_np_for_prof_l {

		disp "Now calculating adjusted IV for outcome `outcome'"

		if "`outcome'" == "all_np_l" {
			sureg (self_all_np above_age_23 msb_X_ua23 msb_X_aa23) (all_np_l above_age_23 msb_X_ua23 msb_X_aa23) if linear >= -11 & linear <= 12

			nlcom (1-exp([all_np_l]above_age_23))/((1-exp([all_np_l]above_age_23))*(1-([self_all_np]above_age_23+[self_all_np]_cons)) + [self_all_np]above_age_23)
		}

		if "`outcome'" != "all_np_l" {
			sureg ///
			(self_all_np above_age_23 msb_X_ua23 msb_X_aa23) ///
			(`outcome' above_age_23 msb_X_ua23 msb_X_aa23) ///
			(all_np_l above_age_23 msb_X_ua23 msb_X_aa23)

			nlcom  (1-exp([`outcome']above_age_23))/((1-exp([all_np_l]above_age_23))*(1- ([self_all_np]above_age_23+[self_all_np]_cons)) + [self_all_np]above_age_23)
		}
	}
restore

************************************************************
**   Reduced-Form RD, Table 2, FP
************************************************************

foreach outcome in all_np all_np_pub all_np_non_prof all_np_for_prof {

	capture drop log_`outcome'
	gen log_`outcome' = log(`outcome')

	reg log_`outcome' above_age_23 msb_X_ua23 msb_X_aa23 ///
	if msb_X_ua23 >= -11 & msb_X_aa23 <= 12 
	estimates store `outcome'

	local point_estimate = round( _b[above_age_23] , 0.01)
	local p_value =	round( 2*abs( ttail(`e(df_r)', abs( _b[above_age_23] ) / _se[above_age_23] ) )  , 0.01 )
											estimates store `outcome'
}

tabresults "above*"

************************************************************
**   Combined, Figure 1, FP
************************************************************

foreach outcome in self_all_np priv_all_np medi_all_np o_ins_all_np all_np_r {

	if "`outcome'" == "self_all_np" {
		local outcome_label = "A. Share Uninsured"
	}
	if "`outcome'" == "priv_all_np" {
		local outcome_label = "B. Share Privately Insured"
	}
	if "`outcome'" == "medi_all_np" {
		local outcome_label = "C. Share on Medicaid"
	}
	if "`outcome'" == "o_ins_all_np" {
		local outcome_label = "D. Share with Other Insurance"
	}
	if "`outcome'" == "all_np_r" {
		local outcome_label = "E. Visits per 10,000 Person Years"
		format all_np_r %-9.0gc
	}

	if "`outcome'" != "all" {
		reg `outcome' above_age_23 msb_X_ua23 msb_X_aa23 ///
		if msb_X_ua23 >= -12 & msb_X_aa23 <= 12 
		estimates store e_`outcome'
		local myoutcome = "`outcome'"
	}
	if "`outcome'" == "all" {
		capture drop log_`outcome'
		gen log_`outcome' = log(`outcome')
		local myoutcome = "log_`outcome'"

		reg log_`outcome' above_age_23 msb_X_ua23 msb_X_aa23 ///
		if msb_X_ua23 >= -12 & msb_X_aa23 <= 12 
		estimates store e_`outcome'
	}

	*local point_estimate = round( _b[above_age_23] , 0.01)
	*local p_value =	round( 2*abs( ttail(`e(df_r)', abs( _b[above_age_23] ) / _se[above_age_23] ) )  , 0.01 *)

	graph set window fontface "Garamond"
	tw ///
		(scatter `myoutcome' months_23 if months_23 >= -12 & months_23 <= 12, msymbol(o) mcolor(black) )  ///
		(function _b[_cons] + _b[msb_X_ua23]*x , range(-12 0) lcolor(blue) lpattern(dash) ) ///
		(function _b[_cons] + _b[msb_X_aa23]*x + _b[above_age_23] , range(0 12) lcolor(blue) lpattern(dash) ) ///
		, ///
		title("") ///
		scheme(s2mono) ylabel(, nogrid angle(horizontal)) graphregion(fcolor(white)) ///
		legend(off) ///
		xtitle("Age") ///
		xscale(r(-12 12)) xlabel(-12 "22" -6 "22.5" 0 "23"  6 "23.5" 12 "24") ///
		title("`outcome_label'") ///
		yscale( nofextend ) xscale(nofextend) 
	graph export ../gph/`outcome'-ed-age23-rd.$graph_extension , replace
	graph save ../gph/`outcome'-ed-age23-rd.gph , replace

}

** note("RD Point estimate `point_estimate' with p-value `p_value'") ///

tabresults "above*"


************************************************************
**   Adjusted First Stage, Table 1, FP
************************************************************

preserve

	capture drop log_all_np
	capture drop log_all
	gen log_all = log(all_np)

	keep if msb_X_ua23 >= -11 & msb_X_aa23 <= 12 

	foreach outcome in priv_all_np self_all_np medi_all_np o_ins_all_np {

		disp "Now calculating adjusted first stage for outcome `outcome'"

		sureg ///
		(`outcome' above_age_23 msb_X_ua23 msb_X_aa23) ///
		(log_all above_age_23 msb_X_ua23 msb_X_aa23) 

		if "`outcome'" != "self_all_np" {
			nlcom [`outcome']above_age_23 - ///
			(1 - exp([log_all]above_age_23)) * ///
			([`outcome']above_age_23 + [`outcome']_cons)
		}

		if "`outcome'" == "self_all_np" {
			nlcom ///
			((1-exp([log_all]above_age_23)) * ///
			(1-([`outcome']above_age_23+[`outcome']_cons)) ///
			+ [`outcome']above_age_23)
		}
		
	}
restore

log close
exit

