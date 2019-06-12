**application_rate_compare.do
**This file generates Table 3 in the paper, which 
**summarizes the encouragement effort

*input: home_dirpath/DATA/application_status.dta
*output: encourage_sum.tex

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

/*
global home_dirpath "`DROPBOX'wap"
global output "`DROPBOX'wap/Brian Checks/Annotated Code/Output"
*/
*Meredith Directories

global sec_dirpath "T:/Efficiency/WAP/data"
global home_dirpath "T:/Dropbox/WAP"
*global output "T:/Dropbox/WAP/Brian Checks/Annotated Code/Output"
global output "T:\WAP_FINAL\WAP_Appendix_Final\tables_figures"
	
*log using "$output/app_data.log", replace

**************************
**Regressions in Table 3
**************************
 
use "$home_dirpath/DATA/application_status_data.dta"
  
  *Dependent Variables in Table 3
 label var IN_CAA "Submitted application"
 label var IN_NEAT "Home audit"
 label var WAP "Weatherized"
 
 replace IN_NEAT=0 if IN_NEAT==.
 
 * Run regressions reported in paper
 
 keep if normal==1
 keep if IN_RED==1
 drop if countPOST_GAS<3 & countPOST_ELEC<3
 
*Column (1), Table 3
 reg IN_CAA RED_ENC
 est sto reg1

   
 *Column (2), Table 3
 reg IN_NEAT RED_ENC 
 est sto reg2
 
 
 *Column (3), Table 3
 reg WAP RED_ENC
 est sto reg3


**************************
**Build Table 3
**************************

/*
Preamble when viewing table for editing

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

  *file open myfile using "encourage_sum.tex", write replace 
  file open myfile using "Table3.tex", write replace 
  file write myfile "\begin{table}[H]" _n "{" _n "\small" _n ///
 "\centering" _n ///
"\begin{tabular*}{1.0\textwidth}{@{\extracolsep{\fill}}lccc}" _n ///
"\hline\hline" _n ///
"\vspace{.1pt} \\" _n /// 
"& Application &  Efficiency & Weatherization  \\" _n ///
"&  &  audit & complete  \\" _n ///
"& (1) & (2) & (3) \\" _n ///
"\hline" _n ///
"\vspace{.1pt} \\" _n 

file write myfile "Base Rate"
est res reg1
mat b_log=e(b)
  file write myfile " & " %4.2f (b_log[1,2])
 qui est r reg1 
 mat b=r(table)
 if b[4,2]<=0.01 file write myfile "\$^{**}$"
  else if b[4,2]<=0.05 file write myfile "\$^{*}$"
  
  
 est res reg2
mat b_log=e(b)
  file write myfile " & " %4.2f (b_log[1,2])
 qui est r reg2
 mat b=r(table)
 if b[4,2]<=0.01 file write myfile "\$^{**}$"
  else if b[4,2]<=0.05 file write myfile "\$^{*}$" 
  
  est res reg3
mat b_log=e(b)
  file write myfile " & " %4.2f (b_log[1,2])
 qui est r reg3
 mat b=r(table)
 if b[4,2]<=0.01 file write myfile "\$^{**}$"
  else if b[4,2]<=0.05 file write myfile "\$^{*}$" 
  
  file write myfile " \\" _n
 
 /*Standard Errors*/
  
 qui est r reg1 
  mat b=r(table)
if b[2, 2] <= 0.01 file write myfile " & ($<0.01$) "
else if b[2, 2] >= 0.01 file write myfile " & (" %4.2f b[2, 2] ")"

 qui est r reg1 
   mat b=r(table)
if b[2, 2] <= 0.01 file write myfile " & ($<0.01$) "
  else if b[2, 2] >= 0.01 file write myfile " & (" %4.2f b[2, 2] ")"

 qui est r reg1 
 mat b=r(table)
if b[2, 2] <= 0.01 file write myfile " & ($<0.01$) "
  else if b[2, 2] >= 0.01 file write myfile " & (" %4.2f b[2, 2] ")"

file write myfile " \\" _n
file write myfile "\vspace{.1pt} \\" _n

file write myfile "Encouragement"

est res reg1
mat b_log=e(b)
  file write myfile " & " %4.2f (b_log[1,1])
 qui est r reg1 
 mat b=r(table)
 if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  
  
  
 est res reg2
mat b_log=e(b)
  file write myfile " & " %4.2f (b_log[1,1])
 qui est r reg2
 mat b=r(table)
 if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$" 
  
  est res reg3
mat b_log=e(b)
  file write myfile " & " %4.2f (b_log[1,1])
 qui est r reg3
 mat b=r(table)
 if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$" 
  
  file write myfile " \\" _n
  
  
/*Standard Errors*/

  qui est r reg1 
mat b=r(table)
if b[2, 1] <= 0.01 file write myfile " & ($<0.01$) "
  else if b[2, 1] >= 0.01 file write myfile " & (" %4.2f b[2, 1] ")"

 qui est r reg1 
 mat b=r(table)
if b[2, 1] <= 0.01 file write myfile " & ($<0.01$) "
  else if b[2, 1] >= 0.01 file write myfile " & (" %4.2f b[2, 1] ")"

 qui est r reg1 
 mat b=r(table)
if b[2, 1] <= 0.01 file write myfile " & ($<0.01$) "
  else if b[2, 1] >= 0.01 file write myfile " & (" %4.2f b[2, 1] ") \\"


file write myfile "\vspace{.1pt} \\" _n

file write myfile "\hline \\" _n

file write myfile "\vspace{.1pt} \\" _n

file write myfile "Households" 
est res reg1 
mat b=e(N)
 file write myfile " & " %5.0fc (b[1,1])
 
 est res reg2 
mat b=e(N)
 file write myfile " & " %5.0fc (b[1,1])
 
 est res reg3
mat b=e(N)
 file write myfile " & " %5.0fc (b[1,1])
 
 file write myfile "\\" _n
 file write myfile "\vspace{.1pt} \\" _n
 
 
 
 file write myfile "\hline \\" _n ///
"\end{tabular*} }" _n  ///
"\footnotesize Note: The table shows the effect of our encouragement on program applications, efficiency audits, and weatherization." ///
"  Indicators of program participation status are regressed on an encouragement indicator and a constant. The unit of observation is a household. \\" _n ///
"$^{*}$ Significant at the 5 percent level \\" _n ///
"$^{**}$ Significant at the 1 percent level \\" _n ///

file write myfile "\end{table}"
*/
file close myfile

log close
