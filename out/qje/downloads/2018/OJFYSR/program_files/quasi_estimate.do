**Quasi_exp_estimate.do
**This file carries out the quasi-experimental estimates 
**and builds Table 5 of the paper. 

*Input: QUASI_cmb_est.dta 
*Output: quasi_estimate.tex

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

*Meredith Directories

global sec_dirpath "T:\Efficiency\WAP\data"
global home_dirpath "T:\Dropbox\WAP"
*global output "T:/Dropbox/wap/Brian Checks/Annotated Code/Output"
global output "T:/WAP_FINAL/WAP_Appendix_Final/tables_figures"


*First, edit psweight_4.dta file in preparation for merge with QUASI_cmb_est data
cd "$home_dirpath/Brian Checks/Annotated Code/Input"
	
		use psweight_4.dta, clear
		
			keep walt_id cons_hh_id WAP pscore ps_w block
			sort cons_hh_id
			tempfile temp
			save `temp', replace
			clear


*************************************************************
**Columns (1) & (2) Regressions
*************************************************************


use "$sec_dirpath/QUASI_cmb_est.dta", replace
  
   xtset id
  
         drop if BTU==.
		 drop if BTU==0

		 disp " All pooled"
		 
	  areg lnBTU D  _Iyear_* D_monXyea_* , absorb(id) robust cluster(fwhhid)
		  est sto reg_log
		  
	 areg lnBTU D  _Iyear_* _Im_AXyea* , absorb(id) robust cluster(fwhhid)
		  est sto reg_log_sat
		  
		 keep walt_id cons_hh_id fwhhid BTU WAP year month

*Generate average consumption control group estimates (MMBtu/month)
* These are reported in table notes.

		  drop if WAP==1
		  drop if year<2011
		  drop if year==2011 & month<3
		  duplicates drop
		  estpost sum BTU
		  est sto sum_total
		  
		
*************************************************************
**Columns (3) & (4) Regressions
*************************************************************
		  
		    	  
clear		  

use "$sec_dirpath/QUASI_cmb_est.dta", replace
  
  
   xtset id
          
         drop if BTU==.
		 keep if normal==1
		 drop if BTU==0
		 
		 *Limit sample to agencies that participated in experiment, as well as
		 *applicants that applied after encouragement intervention was initiated
		 keep if agency_name=="gccard" | agency_name=="jackson"
		 drop if WAP==1 & WAP_y<2011
		 drop if WAP==1 & WAP_y==2011 & WAP_m<3
		  
  
	disp "Jackson GCCARD"	  
		 * baseline specn. All months, weatherization dummy only
		 
		 
areg lnBTU D  _Iyear_* D_monXyea_* , absorb(id) robust cluster(fwhhid)
		  est sto reg_log_agn	
		  
		  
areg lnBTU D  _Iyear_* _Im_AXyea*  , absorb(id) robust cluster(fwhhid)
		  est sto reg_log_agn_sat

*Generate average consumption control group estimates (MMBtu/month)
		  drop if WAP==1
		  drop if year<2011
		  drop if year==2011 & month<3
		  duplicates drop
		  *drop if year<2012
		  estpost sum BTU
		  est sto sum_total_agn
		  
		  
		  
*************************************************************
**Columns (5) & (6) Regressions
*************************************************************

 disp    "pscore match"  
		
			use "$sec_dirpath/QUASI_cmb_est.dta", clear
			
			capture drop _merge
			drop if BTU==.
			drop if BTU==0
			
			sort cons_hh_id
			merge cons_hh_id using `temp'
			
			areg lnBTU D  _Iyear_* D_monXyea_* [pw=ps_w], absorb(id) robust cluster(fwhhid)
		  est sto preg_log
		  
		  areg lnBTU D  _Iyear_*  _Im_AXyea* [pw=ps_w], absorb(id) robust cluster(fwhhid)
		  est sto preg_log_sat


*Generate average consumption control group estimates (MMBtu/month)
	 keep walt_id cons_hh_id fwhhid BTU WAP year month ps_w
		 
		  
		  *drop if year<2012
		  drop if WAP==1
		  drop if year<2011
		  drop if year==2011 & month<3
		  duplicates drop
		  summarize BTU [w=ps_w] if WAP==0
		 
		  est sto sump_total
		  
		  local mean1 = `r(mean)'
		  
		  local sd1 = `r(sd)'

********************** Make table of regression results ***********/

/*
See paper_outline.docx for example
Columns - See table notes below
Rows - Panel A: WAP, average consumption control group, month-of-sample FS, month-of-sample x county FE, P-score matched sample, 
Adjusted R-squared, Households, Observations, Panel B: 10 years, 16 years, 20 years

Preamble when viewing table for editing

\documentclass{article}
\usepackage{caption}
\usepackage{subcaption}
\usepackage{tabularx}
\usepackage{multirow}
\usepackage{rotating}
\begin{document}

NB: NPV numbers calculated externally (see NPV worksheet) using estimates (levels) of monthly gas and elec savings
*/


  
  capture file close myfile
  cd  "$output"

  *file open myfile using "quasi_estimate.tex", write replace 
  file open myfile using "Table5.tex", write replace 
  file write myfile "\begin{table}[H]" _n "{" _n "\small" _n ///
  "\centering" _n ///
  "\resizebox{\columnwidth}{!}{" _n ///
  "\begin{tabular*}{1.1\textwidth}{@{\extracolsep{\fill}}lcccccc}" _n ///
  "\hline\hline" _n ///
  "\vspace{.1pt} \\" _n /// 
  "\multicolumn{7}{l}{\textbf{Panel A: Dependent variable is monthly energy consumption (in logs)}}" _n ///
  "\vspace{.2pt} \\" _n /// 
  "& (1) & (2) & (3) & (4) & (5) & (6) \\" _n /// 
  "\hline \\" _n ///
  "\vspace{.1pt} \\" _n //
 
  file write myfile "WAP"
  est res reg_log
  mat b_log=e(b)
  file write myfile " & " %4.2f (b_log[1,1])
  qui est r reg_log
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res reg_log_sat
  mat b_log=e(b)
  file write myfile " & " %4.2f (b_log[1,1])
  qui est r reg_log_sat
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res reg_log_agn
  mat b_level=e(b)
  file write myfile " & " %4.2f (b_level[1,1])
  qui est r reg_log_agn
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
   est res reg_log_agn_sat
  mat b_level=e(b)
  file write myfile " & " %4.2f (b_level[1,1])
  qui est r reg_log_agn_sat
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res preg_log
  mat b=e(b)
  file write myfile " & " %4.2f (b[1,1])
  qui est r preg_log
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res preg_log_sat
  mat b=e(b)
  file write myfile " & " %4.2f (b[1,1])
  qui est r preg_log_sat
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  file write myfile " \\" _n
  
  est res reg_log
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res reg_log_sat
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res reg_log_agn
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")" 
  est res reg_log_agn_sat
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res preg_log
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res preg_log_sat
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  file write myfile " \\" _n
  
  /*
  file write myfile "\vspace{.1pt} \\" _n //
  file write myfile "Average consumption"
  est res sum_total
  mat b=e(mean)
  file write myfile " & \multicolumn{2}{c}{" %4.2f (b[1,1]) "}"  
  est res sum_total_agn
  mat b=e(mean)
  file write myfile " & \multicolumn{2}{c}{" %4.2f (b[1,1]) "}"  
  file write myfile " & \multicolumn{2}{c}{" %4.2f (`mean1') "}"  
  file write myfile " \\" _n
  file write myfile "control group"
  est res sum_total
  mat b=e(sd)
  file write myfile " & \multicolumn{2}{c}{[" %4.2f (b[1,1]) "]}"  
  est res sum_total_agn
  mat b=e(sd)
  file write myfile " & \multicolumn{2}{c}{[" %4.2f (b[1,1]) "]}" 
  file write myfile " & \multicolumn{2}{c}{[" %4.2f (`sd1') "]}"  _n
  file write myfile " \\" _n
  file write myfile "(MMbtu/month) \\"  _n //  
  */
  
  file write myfile "\vspace{.2pt} \\" _n //
  file write myfile "month-of-sample FE & Y & N & Y & N & Y & N  \\" _n
  file write myfile "month-of-sample x county FE & N & Y & N & Y & N & Y  \\" _n
  file write myfile "P-score matched sample  & N & N & N & N & Y & Y \\" _n
  
  file write myfile "\vspace{.2pt} \\" _n //
   
  file write myfile "Adjusted R-squared"
  est res reg_log
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res reg_log_sat
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res reg_log_agn
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res reg_log_agn_sat
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res preg_log
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res preg_log_sat
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])

  
  file write myfile "\vspace{.1pt} \\" _n //
  file write myfile "Households"
  est res reg_log
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_log_sat
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_log_agn
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1]) 
  est res reg_log_agn_sat
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  est res preg_log
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  est res preg_log_sat
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  file write myfile " \\" _n
  
    
  file write myfile "Observations"
  est res reg_log
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_log_sat
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_log_agn
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1]) 
  est res reg_log_agn_sat
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  est res preg_log
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  est res preg_log_sat
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  file write myfile " \\" _n
  
file write myfile "\vspace{.1pt} \\" _n 

file write myfile "\multicolumn{7}{l}{\textbf{Panel B: Present value of (discounted) savings}} \\" _n 

file write myfile "\vspace{.1pt} \\" _n 

  
  file write myfile "Time Horizon & \multicolumn{6}{c}{Discount rate} \\" _n
  file write myfile "&  \multicolumn{2}{c}{3 percent} & \multicolumn{2}{c} {6 percent} & \multicolumn{2}{c} {10 percent}  \\" _n
  file write myfile "\hline \\" _n 
  file write myfile "\vspace{.2pt} \\" _n 
  
  file write myfile " 10 years  & \multicolumn{2}{c}{\\$1,393} &  \multicolumn{2}{c}{\\$1,202} & \multicolumn{2}{c}{\\$1,004} \\" _n
  file write myfile " 16 years &  \multicolumn{2}{c}{\\$2,052} &  \multicolumn{2}{c}{\\$1,651} & \multicolumn{2}{c}{\\$1,278} \\ " _n
  file write myfile " 20 years  &  \multicolumn{2}{c}{\\$2,430} &  \multicolumn{2}{c}{\\$1,873} & \multicolumn{2}{c}{\\$1,391} \\" _n
  
  /*NOTE: We must add "\\" double backslash before the above money signs for it to appear in the latex output. I do not know why-BRG*/
  
  
  file write myfile "\vspace{.1pt} \\" _n //
  
file write myfile " \\" _n

file write myfile "\hline \\" _n ///
"\end{tabular*} }}" _n  ///
"\footnotesize Note: Panel A reports estimates of the reduction in monthly energy consumption following weatherization." ///
" The dependent variable is the log of monthly household energy consumption (electricity and natural gas) measured in MMBtu." ///
" All columns include household-by-month-of-sample and month-by-region fixed effects." ///
" Columns (1) and (2) use data from all weatherization appplicants while columns (3) and (4) use a sample limited to implementing agencies" ///
" that participated in the experiment as well as applicants that applied after the encouragement intervention was initiated." ///
" Columns (5) and (6) report estimates comparable to columns (1) and (2) reweighted by the propensity score." ///
"Average monthly consumption is 8.13 MMBtu for all applicants and 9.68 MMBtu for the limited sample. The propensity score weighted average" ///
"is 9.33 MMBtu per month. Standard errors (in parentheses) are clustered at" ///
" the household level. Panel B reports the net present value of energy savings implied by the preferred estimate reported in column (6)." ///
" Reductions in energy bills associated with the estimates in column (6) are assumed" ///
" to accrue over the life of the measure using a range of discount rates and assumed time horizons.  \\"  _n ///
"$^{*}$ Significant at the 5 percent level \\" _n ///
"$^{**}$ Significant at the 1 percent level \\" _n ///

file write myfile "\end{table}"

file close myfile


	
