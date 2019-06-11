**measure_summary_table_necessary.do
**This file builds the summary data for weatherized households
**presented in Appendix Table 1 

* Start out w/ 7,304 in CAA data
* 4,804 can be matched w. Consumers data as of today
* Drop Allegan, leaving 4652.

*input: home_dirpath/DATA/measures_summary.dta
*output: measures_summary.tex


clear all
capture log close
clear matrix
program drop _all
set more off

**************************************************************
**Set Directory Paths Here: sec_dirpath is for 
**confidential data while home_dirpath is for all other input.
**Output is for .tex table output.
**************************************************************

/*Brian Directories
// Automated selection of Root path based on user
if c(os) == "Windows" {
    local DROPBOX "C:/Users/`c(username)'/Dropbox/"
	global sec_dirpath "E:/Confidential Files"
}
else if c(os) == "MacOSX" {
    local DROPBOX "/Users/`c(username)'/Dropbox/"
	global sec_dirpath "/Volumes/My Passport/Confidential Files"
}

global home_dirpath "`DROPBOX'wap"
global output "`DROPBOX'wap/Brian Checks/Annotated Code/Output"
*/
/*Meredith Directories*/

global sec_dirpath "T:\Efficiency\WAP\data"
global home_dirpath "T:/Dropbox/WAP"
global output "T:/Dropbox/wap/Brian Checks/Annotated Code/Output"


/* Tabulate Means for Weatherized Households Reported in Appendix Table 1*/
	
	use "$home_dirpath/Brian Checks/Annotated Code/Input/measures_summary.dta", clear
	 
	 * Costs
	 
	 keep if WAP==1
	 drop if neat_clientid==.
	 rename iwc_job_cost_act iwc_act
	 
	 foreach var of varlist neat_cost_if_savings  iwc_act {

		estpost tabstat `var' , by(WAP)  s(mean sd) columns(statistics)
		est store red_`var'
	}

	* Energy savings
	
	foreach var of varlist heatingmbtu coolingkwh baseloadkwh pc_tot{	
	estpost tabstat `var' , by(WAP)  s(mean sd) columns(statistics)
		est store red_`var'
	}
	
	* Avoided emissions
	
	foreach var of varlist mmbtu_saved_CO2 kwh_saved_CO2 total_saved_CO2{
		estpost tabstat `var' , by(WAP)  s(mean sd) columns(statistics)
		est store red_`var'
		}
		
	* Energy savings
	
	foreach var of varlist  neat_npv_savings_cum neat_cost sir_cum{
		estpost tabstat `var' , by(WAP)  s(mean sd) columns(statistics)
		est store red_`var'
		}
		
	* Measures 
	
	foreach var of varlist FURN WALL ATTIC INF_RED{
		estpost tabstat `var' , by(WAP)  s(mean sd) columns(statistics)
		est store red_`var'
		}
		
	*Household Count
		gen c=1
		drop if WAP~=. & FURN==.
	estpost tabstat c, by(WAP) s(count) columns(statistics)
	est store WAP_count
	
	
	
* Build Appendix Table 1
	
	/*
	preamble when viewing table for editing
	\documentclass{article}
	\usepackage{caption}
	\usepackage{subcaption}
	\usepackage{tabularx}
	\usepackage{multirow}
	\usepackage{rotating}
	\begin{document}
	*/

	capture file close myfile
	cd  "$output"

	file open myfile using "measures_summary.tex", write replace 
	file write myfile "\begin{table}[H]" _n "{" _n "\small" _n ///
	"\centering" _n ///
	"\begin{tabular*}{1.0\textwidth}{@{\extracolsep{\fill}}lc}" _n ///
	"\hline\hline" _n ///
	"\vspace{.2pt} \\" _n ///
	"& Weatherized \\" _n ///
	"& households \\"  _n ///
	"\hline \\" _n ///
	"\multicolumn{2}{l}{\textbf{Energy savings (projected)}} \\" _n ///
	"\vspace{.2pt} \\" _n ///

	foreach var of varlist heatingmbtu {
		file write myfile "`:var l `var''"
		est restore red_`var'
		mat b=e(mean)
		file write myfile " & " %9.2f (b[1,2])
		file write myfile " \\ " _n
		mat b=e(sd)
		file write myfile " & (" %3.2f (b[1,2]) ")"
		file write myfile " \\ " _n
	}
	

	foreach var of varlist coolingkwh {
		file write myfile "`:var l `var''"
		est restore red_`var'
		mat b=e(mean)
		file write myfile " & " %9.2f (b[1,2])
		file write myfile " \\ " _n
		mat b=e(sd)
		file write myfile " & (" %3.2f (b[1,2]) ")"
		file write myfile " \\ " _n
	}
	
	foreach var of varlist pc_tot {
		file write myfile "`:var l `var''"
		est restore red_`var'
		mat b=e(mean)
		file write myfile " & " %9.2f (b[1,2] )
		file write myfile " \\ " _n
		mat b=e(sd)
		file write myfile " & (" %3.2f (b[1,2] ) ")"
		file write myfile " \\ " _n
	
	}
	
	file write myfile "\hline \\" _n ///
	"\multicolumn{2}{l}{\textbf{Investment costs and projected savings}} \\" _n /// 
	"\vspace{.2pt} \\" _n ///
	
	foreach var of varlist iwc_act neat_cost {
		file write myfile "`:var l `var''"
		est restore red_`var'
		mat b=e(mean)
		file write myfile " & " %9.0fc (b[1,2])
		file write myfile " \\ " _n
		mat b=e(sd)
		file write myfile " & (" %5.0fc (b[1,2]) ")"
		file write myfile " \\ " _n
		
	}
	
	foreach var of varlist neat_npv_savings_cum {
		file write myfile "`:var l `var''"
		est restore red_`var'
		mat b=e(mean)
		file write myfile " & " %9.0fc (b[1,2])
		file write myfile " \\ " _n
		mat b=e(sd)
		file write myfile " & (" %6.0fc (b[1,2]) ")"
		file write myfile " \\ " _n
	
	}
	
	foreach var of varlist sir_cum {
		file write myfile "`:var l `var''"
		est restore red_`var'
		mat b=e(mean)
		file write myfile " & " %3.2f (b[1,2])
		file write myfile " \\ " _n
		mat b=e(sd)
		file write myfile " & (" %3.2f (b[1,2]) ")"
		file write myfile " \\ " _n
	
	}
	
	file write myfile "\hline \\" _n ///
	"\multicolumn{2}{l}{\textbf{Key measures (share receiving)}} \\" _n /// 
	"\vspace{.2pt} \\" _n ///
	
	foreach var of varlist FURN ATTIC WALL INF_RED {
		file write myfile "`:var l `var''"
		est restore red_`var'
		mat b=e(mean)
		file write myfile " & " %9.2f (b[1,2])
		file write myfile " \\ " _n
		mat b=e(sd)
		file write myfile " & (" %3.2f (b[1,2]) ")"
		file write myfile " \\ " _n
	
	}
	
	file write myfile " \\ " _n
	file write myfile "Households"
	est restore WAP_count
	mat b=e(count)
	file write myfile " & " %9.0fc (b[1,2])
	
 
  file write myfile "\vspace{.1pt} \\" _n //
  file write myfile " \\" _n
  file write myfile "\hline \\" _n 
  file write myfile "\end{tabular*} } " _n  
  
  file write myfile "{\footnotesize \parbox{1.0\textwidth}{Notes: This table summarizes data from the 1,638 weatherized households that could be exactly matched with audit data." ///
  " Average values reported.  Standard deviations appear in parentheses.} } \\" _n /// 
  
  file write myfile "\end{table}"
	
	
  file close myfile
