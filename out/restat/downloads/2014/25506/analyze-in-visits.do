#delim cr
set more off
*version 11
pause on
graph set ps logo off

capture log close
set linesize 180
set logtype text
log using ../log/analyze-in-visits.log , replace

/* --------------------------------------

AUTHOR: Tal Gross

PURPOSE: Analyze the counts of inpatient
visits that Carlos created.

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
**   Bring in Inpatient Data
************************************************************

insheet using "../src/P10 Inpatient CSV File.csv" , names comma
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

local outcomes1 = "tot_all_np tot_all_np_pub tot_all_np_non_prof tot_all_np_for_prof"
local outcomes2 = "tot_all_np_ed tot_all_np_pub_ed tot_all_np_non_prof_ed tot_all_np_for_prof_ed"
local outcomes3 = "tot_all_np_ned tot_all_np_pub_ned tot_all_np_non_prof_ned tot_all_np_for_prof_ned " 

forvalues i = 1(1)3 {
	foreach outcome in `outcomes`i'' {

		preserve

			keep if msb_X_ua23 >= -11 & msb_X_aa23 <= 12 

			capture drop `outcome'_l
			gen `outcome'_l = log(`outcome')

			disp "Now calculating adjusted IV for outcome `outcome'"

			if "`outcome'" == "tot_all_np" {
				sureg (tot_self_all_np above_age_23 msb_X_ua23 msb_X_aa23) (tot_all_np_l above_age_23 msb_X_ua23 msb_X_aa23) if linear >= -11 & linear <= 12

				nlcom (1-exp([tot_all_np_l]above_age_23))/((1-exp([tot_all_np_l]above_age_23))*(1-([tot_self_all_np]above_age_23+[tot_self_all_np]_cons)) + [tot_self_all_np]above_age_23)
			}

			if "`outcome'" != "tot_all_np" {
				sureg ///
				(tot_self_all_np above_age_23 msb_X_ua23 msb_X_aa23) ///
				(`outcome'_l above_age_23 msb_X_ua23 msb_X_aa23) ///
				(tot_all_np_l above_age_23 msb_X_ua23 msb_X_aa23)

				nlcom  (1-exp([`outcome'_l]above_age_23))/((1-exp([tot_all_np_l]above_age_23))*(1- ([tot_self_all_np]above_age_23+[tot_self_all_np]_cons)) + [tot_self_all_np]above_age_23)

			}
		restore
		
	}
	*tabresults "above*"
}

************************************************************
**   Combined Figure 2, FP
************************************************************

foreach outcome in tot_self_all_np tot_priv_all_np tot_medi_all_np tot_o_ins_all_np tot_all_np_r tot_all_np_ed_r tot_all_np_ned_r {

	if "`outcome'" == "tot_self_all_np" {
		local outcome_label = "A. Share Uninsured"
	}
	if "`outcome'" == "tot_priv_all_np" {
		local outcome_label = "B. Share Privately Insured"
	}
	if "`outcome'" == "tot_medi_all_np" {
		local outcome_label = "C. Share on Medicaid"
	}
	if "`outcome'" == "tot_o_ins_all_np" {
		local outcome_label = "D. Share with Other Insurance"
	}
	if "`outcome'" == "tot_all_np_r" {
		local outcome_label = "E. All Visits per 10,000 Person Years"
		format tot_all_np_r %-9.0gc
	}
	if "`outcome'" == "tot_all_np_ed_r" {
		local outcome_label = "F. All Visits from ED per 10,000 Person Years"
		format tot_all_np_ed_r %-9.0gc
	}
	if "`outcome'" == "tot_all_np_ned_r" {
		local outcome_label = "G. All Visits not from ED per 10,000 Person Years"
		format tot_all_np_ned_r %-9.0gc
	}

	if "`outcome'" != "tot_all" & "`outcome'" != "tot_all_ed" & "`outcome'" != "tot_all_ned" {
		reg `outcome' above_age_23 msb_X_ua23 msb_X_aa23 ///
		if msb_X_ua23 >= -12 & msb_X_aa23 <= 12 
		estimates store e_`outcome'
		local myoutcome = "`outcome'"
	}
	if "`outcome'" == "tot_all" | "`outcome'" == "tot_all_ed" | "`outcome'" == "tot_all_ned" {
		capture drop log_`outcome'
		gen log_`outcome' = log(`outcome')
		local myoutcome = "log_`outcome'"

		reg log_`outcome' above_age_23 msb_X_ua23 msb_X_aa23 ///
		if msb_X_ua23 >= -12 & msb_X_aa23 <= 12 
		estimates store e_`outcome'
	}

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
	graph export ../gph/`outcome'-inp-age23-rd.$graph_extension , replace
	graph save ../gph/`outcome'-inp-age23-rd.gph , replace

}

************************************************************
**   Adjusted First Stage, All Inpatient, Table 1, FP
************************************************************

preserve

	capture drop log_all
	gen log_all = log(tot_all_np)

	keep if msb_X_ua23 >= -11 & msb_X_aa23 <= 12 

	foreach outcome in tot_priv_all_np tot_self_all_np tot_medi_all_np tot_o_ins_all_np {

		disp "Now calculating adjusted first stage for outcome `outcome'"

		sureg ///
		(`outcome' above_age_23 msb_X_ua23 msb_X_aa23) ///
		(log_all above_age_23 msb_X_ua23 msb_X_aa23) 

		if "`outcome'" != "tot_self_all_np" {
			nlcom [`outcome']above_age_23 - ///
			(1 - exp([log_all]above_age_23)) * ///
			([`outcome']above_age_23 + [`outcome']_cons)
		}

		if "`outcome'" == "tot_self_all_np" {
			nlcom ///
			((1-exp([log_all]above_age_23)) * ///
			(1-([`outcome']above_age_23+[`outcome']_cons)) ///
			+ [`outcome']above_age_23)
		}
		
	}
restore

************************************************************
**   Reduced-Form RD, Table 2, FP
************************************************************

estimates clear

local outcomes1 = "tot_all_np tot_all_np_pub tot_all_np_non_prof tot_all_np_for_prof"
local outcomes2 = "tot_all_np_ed tot_all_np_pub_ed tot_all_np_non_prof_ed tot_all_np_for_prof_ed "
local outcomes3 = "tot_all_np_ned tot_all_np_pub_ned tot_all_np_non_prof_ned tot_all_np_for_prof_ned " 

forvalues i = 1(1)3 {
	foreach outcome in `outcomes`i'' {

		capture drop log_`outcome'
		gen log_`outcome' = log(`outcome')

		reg log_`outcome' above_age_23 msb_X_ua23 msb_X_aa23 ///
		if msb_X_ua23 >= -11 & msb_X_aa23 <= 12 
		estimates store `outcome'

												estimates store `outcome'

	}
	tabresults "above*"
}

log close
exit

