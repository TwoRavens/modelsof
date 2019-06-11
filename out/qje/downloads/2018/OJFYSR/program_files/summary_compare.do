**summary_compare.do
**This file builds Appendix Table 5, which summarizes differences in sample means
**between groups of weatherized households
 
 *input: sec_dirpath/summary_compare.dta
 *output: summary_compare.tex


capture log close

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
*Automated selection of Root path based on user
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

*Meredith Directories

global sec_dirpath "T:\Efficiency\WAP\data"
global home_dirpath "T:\Dropbox\WAP"
*global output "T:\Dropbox\WAP\Brian Checks\Annotated Code\Output"
global output "T:\WAP_FINAL\WAP_Appendix_Final\tables_figures"



**Summarize what variables mean

 use "$sec_dirpath/summary_compare_data.dta", clear

global sumvar "INCOME PC_POVERTY GAS_HEAT HH_SIZE CHILDREN ELDERLY DISABLED HOME_AGE neat_floorarea FURN WALL ATTIC cost_sav ncost btu_sav sir iwc_job_cost_act"

 
label var G_W "Winter gas (MMBtu)"
label var G_S "Summer gas (MMBtu)"
label var E_W "Winter electricity (MMBtu)"
label var E_S "Summer electricity (MMBtu)"
label var ELEC "Electricity (MMBtu)"
label var INCOME "Household income (\\\$)"
label var PC_POVERTY "Percent of poverty (\%)"
label var GAS_HEAT "Gas heat"
label var HH_SIZE "Household size (\# people)"
label var CHILDREN "Children (share of hh)"
label var DISABLED "Reported disability (share of hh)" 
label var ELDERLY "Elderly (share of hh)"
label var HS "High school education (share of households)"
label var HOME_AGE "Age of home(yrs)"
label var neat_floorarea "Floor area (sq. ft.)"
label var FURN "Furnace replacement"
label var WALL "Wall insulation"
label var ATTIC "Attic insulation"
label var cost_sav "Projected cost if savings"
*label var ncost "Projected cost"
label var iwc_job_cost_act "Retrofit cost"
*label var iwc_cost "Reported cost (total)"
label var btu_sav "Proj. savings (MMBtu)"
label var sir "Projected savings:investment ratio"


*** First, generate means and t-test results comparing weatherized housholds
** in the experimental control with those in the experimental encouraged groups

replace IN_RED=1 if RED_ENC==1
replace IN_RED=1 if RED_CONT==1
preserve

keep if IN_RED==1

foreach var of varlist G_W G_S E_W E_S ELEC $sumvar{

	estpost tabstat `var' , by(RED_CONT)  s(mean sd) columns(statistics)
	est store red_`var'

	estpost ttest `var', by(RED_CONT) 
	est store red_test_`var'
	
}


** Next generate household counts in the experimental control and experimental 
** encouraged groups

keep fwhhid walt_id RED_ENC RED_CONTROL 

duplicates drop
gen c=1

foreach var of varlist RED_ENC RED_CONTROL{
estpost tabstat c, by(`var') s(count) columns(statistics)
est store `var'_count
}


restore 

keep if WAP==1
drop if RED_CONT==1

**Next, generate means for weatherized households in experimental sample
**and not in experimental sample and t-test differences


foreach var of varlist G_W G_S E_W E_S ELEC $sumvar{

	estpost tabstat `var' , by(IN_RED)  s(mean sd) columns(statistics)
	est store rq_`var'

	estpost ttest `var', by(IN_RED) 
	est store rq_test_`var'
}



** Next, generate household counts inside experimental sample 

duplicates drop
gen c=1

foreach var of varlist IN_RED {
estpost tabstat c, by(`var') s(count) columns(statistics)
est store `var'_count
}



*****************
**Generate Table
*****************


/*
preamble when viewing table for editing
\documentclass{article}
\usepackage{caption}
\usepackage{subcaption}
\usepackage{tabularx}
\usepackage{multirow}
\usepackage{rotating}
\usepackage{tabularx}
\begin{document}
*/



capture file close myfile

cd  "$output"

file open myfile using "summary_compare.tex", write replace 
file write myfile "\begin{table}[H]" _n "{" _n "\small" _n ///
"\centering" _n ///
"\resizebox{\columnwidth}{!}{" _n ///
"\begin{tabular*}{1.2\textwidth}{@{\extracolsep{\fill}}lccccc}" _n ///
"\hline\hline" _n ///
"\vspace{.1pt} \\" _n ///
"& Experimental & Experimental & (2) - (1) & Other & (4) - (2) \\" _n ///
"& control & encouraged & & weatherized & \\" _n ///
"& (1) & (2) & (3) & (4) & (5)   \\" _n ///
"\hline \\" _n ///
"\multicolumn{6}{l}{\textbf{Panel A: Pre-treatment period monthly energy consumption (MMBtu)}} \\" _n ///
"\vspace{.1pt} \\" _n ///


foreach var of varlist G_W G_S E_W E_S{
file write myfile "`:var l `var''"
est restore red_`var'
mat b=e(mean)
file write myfile " & " %4.2f (b[1,2]) " & " %4.2f (b[1,1])
est restore red_test_`var'
mat b=e(b)
file write myfile " & " %4.2f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
est restore rq_`var'
mat b=e(mean)
file write myfile "&" %4.2f (b[1,1])
est restore rq_test_`var'
mat b=e(b)
file write myfile " & " %4.2f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
file write myfile " \\" _n

est restore red_`var'
mat b=e(sd)
file write myfile " & (" %4.2f (b[1,2]) ") & (" %4.2f (b[1,1]) ")"
est restore red_test_`var'
mat b=e(se)
file write myfile " & (" %4.2f (b[1,1]) ")"
est restore rq_`var'
mat b=e(sd)
file write myfile " & (" %4.2f (b[1,1]) ")"
est restore rq_test_`var'
mat b=e(se)
file write myfile " & (" %4.2f (b[1,1]) ")"
file write myfile " \\" _n
file write myfile "\vspace{.02pt} \\" 
}

file write myfile "\hline \\" _n ///
"\multicolumn{6}{l}{\textbf{Panel B: Demographics and dwelling characteristics}} \\" _n /// 
"\vspace{.1pt} \\" _n ///

foreach var of varlist INCOME {
file write myfile "`:var l `var''"
est restore red_`var'
mat b=e(mean)
file write myfile " & " %5.0f (b[1,2]) " & " %5.0f (b[1,1])
est restore red_test_`var'
mat b=e(b)
file write myfile " & " %5.0f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
est restore rq_`var'
mat b=e(mean)
file write myfile "&" %5.0f (b[1,1])
est restore rq_test_`var'
mat b=e(b)
file write myfile " & " %5.0f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
file write myfile " \\" _n


est restore red_`var'
mat b=e(sd)
file write myfile " & (" %5.0f (b[1,2]) ") & (" %5.0f (b[1,1]) ")"
est restore red_test_`var'
mat b=e(se)
file write myfile " & (" %5.0f (b[1,1]) ")"
est restore rq_`var'
mat b=e(sd)
file write myfile " & (" %5.0f (b[1,1]) ")"
est restore rq_test_`var'
mat b=e(se)
file write myfile " & (" %5.0f (b[1,1]) ")"
file write myfile " \\" _n
file write myfile "\vspace{.02pt} \\" 

}

*foreach var of varlist  HH_SIZE CHILDREN ELDERLY HOME_AGE neat_floorarea FURN ATTIC iwc_cost btu_sav{
foreach var of varlist HH_SIZE CHILDREN ELDERLY HOME_AGE {
file write myfile "`:var l `var''"
est restore red_`var'
mat b=e(mean)
file write myfile " & " %4.2f (b[1,2]) " & " %4.2f (b[1,1])
est restore red_test_`var'
mat b=e(b)
file write myfile " & " %4.2f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
est restore rq_`var'
mat b=e(mean)
file write myfile "&" %4.2f (b[1,1])
est restore rq_test_`var'
mat b=e(b)
file write myfile " & " %4.2f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
file write myfile " \\" _n

est restore red_`var'
mat b=e(sd)
file write myfile " & (" %4.2f (b[1,2]) ") & (" %4.2f (b[1,1]) ")"
est restore red_test_`var'
mat b=e(se)
file write myfile " & (" %4.2f (b[1,1]) ")"
est restore rq_`var'
mat b=e(sd)
file write myfile " & (" %4.2f (b[1,1]) ")"
est restore rq_test_`var'
mat b=e(se)
file write myfile " & (" %4.2f (b[1,1]) ")"
file write myfile " \\" _n
file write myfile "\vspace{.02pt} \\" 

}

foreach var of varlist neat_floorarea {

file write myfile "`:var l `var''"
est restore red_`var'
mat b=e(mean)
file write myfile " & " %4.0f (b[1,2]) " & " %4.0f (b[1,1])
est restore red_test_`var'
mat b=e(b)
file write myfile " & " %4.0f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
est restore rq_`var'
mat b=e(mean)
file write myfile "&" %4.0f (b[1,1])
est restore rq_test_`var'
mat b=e(b)
file write myfile " & " %4.0f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
file write myfile " \\" _n

est restore red_`var'
mat b=e(sd)
file write myfile " & (" %4.0f (b[1,2]) ") & (" %4.0f (b[1,1]) ")"
est restore red_test_`var'
mat b=e(se)
file write myfile " & (" %4.0f (b[1,1]) ")"
est restore rq_`var'
mat b=e(sd)
file write myfile " & (" %4.0f (b[1,1]) ")"
est restore rq_test_`var'
mat b=e(se)
file write myfile " & (" %4.0f (b[1,1]) ")"
file write myfile " \\" _n
file write myfile "\vspace{.02pt} \\" 

}

foreach var of varlist FURN GAS_HEAT {

file write myfile "`:var l `var''"
est restore red_`var'
mat b=e(mean)
file write myfile " & " %4.2f (b[1,2]) " & " %4.2f (b[1,1])
est restore red_test_`var'
mat b=e(b)
file write myfile " & " %4.2f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
est restore rq_`var'
mat b=e(mean)
file write myfile "&" %4.2f (b[1,1])
est restore rq_test_`var'
mat b=e(b)
file write myfile " & " %4.2f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
file write myfile " \\" _n

est restore red_`var'
mat b=e(sd)
file write myfile " & (" %4.2f (b[1,2]) ") & (" %4.2f (b[1,1]) ")"
est restore red_test_`var'
mat b=e(se)
file write myfile " & (" %4.2f (b[1,1]) ")"
est restore rq_`var'
mat b=e(sd)
file write myfile " & (" %4.2f (b[1,1]) ")"
est restore rq_test_`var'
mat b=e(se)
file write myfile " & (" %4.2f (b[1,1]) ")"
file write myfile " \\" _n
file write myfile "\vspace{.02pt} \\" 
}

/*
foreach var of varlist iwc_cost  {
file write myfile "`:var l `var''"
est restore red_`var'
mat b=e(mean)
file write myfile " & " %4.0f (b[1,2]) " & " %4.0f (b[1,1])
est restore red_test_`var'
mat b=e(b)
file write myfile " & " %4.0f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
est restore rq_`var'
mat b=e(mean)
file write myfile "&" %4.0f (b[1,1])
est restore rq_test_`var'
mat b=e(b)
file write myfile " & " %4.0f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
file write myfile " \\" _n

est restore red_`var'
mat b=e(sd)
file write myfile " & (" %4.0f (b[1,2]) ") & (" %4.0f (b[1,1]) ")"
est restore red_test_`var'
mat b=e(se)
file write myfile " & (" %4.0f (b[1,1]) ")"
est restore rq_`var'
mat b=e(sd)
file write myfile " & (" %4.0f (b[1,1]) ")"
est restore rq_test_`var'
mat b=e(se)
file write myfile " & (" %4.0f (b[1,1]) ")"
file write myfile " \\" _n
file write myfile "\vspace{.02pt} \\" 
}
*/


foreach var of varlist iwc_job_cost_act  {
file write myfile "`:var l `var''"
est restore red_`var'
mat b=e(mean)
file write myfile " & " %4.0f (b[1,2]) " & " %4.0f (b[1,1])
est restore red_test_`var'
mat b=e(b)
file write myfile " & " %4.0f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
est restore rq_`var'
mat b=e(mean)
file write myfile "&" %4.0f (b[1,1])
est restore rq_test_`var'
mat b=e(b)
file write myfile " & " %4.0f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
file write myfile " \\" _n

est restore red_`var'
mat b=e(sd)
file write myfile " & (" %4.0f (b[1,2]) ") & (" %4.0f (b[1,1]) ")"
est restore red_test_`var'
mat b=e(se)
file write myfile " & (" %4.0f (b[1,1]) ")"
est restore rq_`var'
mat b=e(sd)
file write myfile " & (" %4.0f (b[1,1]) ")"
est restore rq_test_`var'
mat b=e(se)
file write myfile " & (" %4.0f (b[1,1]) ")"
file write myfile " \\" _n
file write myfile "\vspace{.02pt} \\" 
}

foreach var of varlist  btu_sav {
file write myfile "`:var l `var''"
est restore red_`var'
mat b=e(mean)
file write myfile " & " %4.2f (b[1,2]) " & " %4.2f (b[1,1])
est restore red_test_`var'
mat b=e(b)
file write myfile " & " %4.2f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
est restore rq_`var'
mat b=e(mean)
file write myfile "&" %4.2f (b[1,1])
est restore rq_test_`var'
mat b=e(b)
file write myfile " & " %4.2f (b[1,1])
mat b=e(p)
if b[1,1]<=0.01 file write myfile "\$^{**}$"
else if b[1,1]<=0.05 file write myfile "\$^{*}$"
file write myfile " \\" _n

est restore red_`var'
mat b=e(sd)
file write myfile " & (" %4.2f (b[1,2]) ") & (" %4.2f (b[1,1]) ")"
est restore red_test_`var'
mat b=e(se)
file write myfile " & (" %4.2f (b[1,1]) ")"
est restore rq_`var'
mat b=e(sd)
file write myfile " & (" %4.2f (b[1,1]) ")"
est restore rq_test_`var'
mat b=e(se)
file write myfile " & (" %4.2f (b[1,1]) ")"
file write myfile " \\" _n
file write myfile "\vspace{.02pt} \\" 
}



file write myfile "\hline \\" _n 

file write myfile "Households"


est res RED_CONTROL_count
mat b=e(count)
file write myfile " & " %9.0fc (b[1, 2])
est res RED_CONTROL_count
	mat b=e(count)
file write myfile " & " %9.0fc (b[1, 1])
est res IN_RED_count
mat b=e(count)
file write myfile " & & " %9.0fc (b[1, 1]) _n



file write myfile " \\" _n

file write myfile "\hline \\" _n ///
"\end{tabular*} } }" _n  ///
"\footnotesize Note: Columns numbered (1), (2),  and (4) report average values and standard deviations (in parentheses). Columns (3) and (5) report " ///
"differences in means (standard errors are in parentheses).  \\" _n ///
"$^{*}$ Significant at the 5 percent level \\" _n ///
"$^{**}$ Significant at the 1 percent level \\" _n ///
"\end{table}"

file close myfile





