**Quasi_exp_estimate_appendix4_necessary.do
**This file carries out the quasi-experimental estimates 
**and builds Appendix Table 6 of the paper. 

*input: sec_dirpath/QUASI_cmb_est.dta
*output: quasi_est_het_app.tex

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

*/
*Meredith Directories

global sec_dirpath "T:\Efficiency\WAP\data"
global home_dirpath "T:\Dropbox\WAP"
*global output "T:/Dropbox/wap/Brian Checks/Annotated Code/Output"
global output "T:\WAP_FINAL\WAP_Appendix_Final\tables_figures"


  use "$sec_dirpath/QUASI_cmb_est.dta", replace
  xtset id
			capture drop _merge
			drop if BTU==.
			drop if BTU==0
			keep if normal==1
		 
		 /*Restrict sample to those agencies that partnered with us in the 
		 *experiment, as well as encouragement period. 
		 *This makes quasi households as comparable as possible to experimental 
		 *households*/
		 keep if agency_name=="gccard" | agency_name=="jackson"
		 drop if WAP==1 & WAP_y<2011
		 drop if WAP==1 & WAP_y==2011 & WAP_m<3
		  

		  replace FURN=0 if FURN==.
		  replace FURN_int=0 if FURN_int==.
		  
		  /*Need to multiply by 1000000 here because income divided by 1000000
		  during data creation process*/
		  replace INC = INC*1000000
		  replace INC_int = INC_int*1000000
		 
		
		 /*Column (1)*/
		 display "Column (1)" 
		 
		areg lnBTU D _Iyear_* _Im_AXyea*, absorb(id) robust cluster(fwhhid)	
		est sto A4_column1
		
	
		
		/*Column (2)*/
		display "Column (2)"
		 areg lnBTU D  ELD  ELD_int INC INC_int HT  HT_int AGE  AGE_int  _Iyear_* _Im_AXyea* , absorb(id) robust cluster(fwhhid)
		  est sto A4_column2
		  
	
		  

		/*Column (3)*/
		 display "Column (3)"
		 areg lnBTU D ELD  ELD_int INC INC_int HT HT_int AGE AGE_int COST COST_INT FURN FURN_int _Iyear_* _Im_AXyea*, absorb(id) robust cluster(fwhhid)
		est sto A4_column3
	
		
/*Build Table*/	
		
*Premable when viewing table for editing
/*
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

  file open myfile using "quasi_est_het_app.tex", write replace 
  file write myfile "\begin{table}[H]" _n "{" _n "\small" _n ///
  "\centering" _n ///
  "\resizebox{\columnwidth}{!}{" _n ///
  "\begin{tabular*}{1.1\textwidth}{@{\extracolsep{\fill}}lccc}" _n ///
  "\hline\hline" _n ///
  "\vspace{.1pt} \\" _n /// 
  "\multicolumn{4}{l}{\textbf{Dependent variable is monthly energy consumption (in logs)}}" _n ///
  "\vspace{.2pt} \\" _n /// 
  "& (1) & (2) & (3) \\" _n /// 
  "\hline " _n ///
  "\vspace{.2pt} \\" _n //
  
	file write myfile "WAP"
	est res A4_column1
	mat b_log = e(b)
	file write myfile " & " %4.2f (b_log[1, 1]) 
	qui est r A4_column1
	mat b=r(table)
	if b[4,1]<=0.01 file write myfile "\$^{**}$"
	else if b[4,1]<=0.05 file write myfile "\$^{*}$"
	
	
	est res A4_column2
	mat b_log = e(b)
	if abs(b_log[1, 1]) <0.01 & b_log[1, 1] >= 0 file write myfile "& $< 0.01$"
	else if abs(b_log[1, 1]) >=0.01 file write myfile " & " %4.2f (b_log[1, 1]) 
	qui est r A4_column2
	mat b=r(table)
	if b[4,1]<=0.01 file write myfile "\$^{**}$"
	else if b[4,1]<=0.05 file write myfile "\$^{*}$"
	
	est res A4_column3
	mat b_log = e(b)
	file write myfile " & " %4.2f (b_log[1, 1]) 
	qui est r A4_column3
	mat b=r(table)
	if b[4,1]<=0.01 file write myfile "\$^{**}$"
	else if b[4,1]<=0.05 file write myfile "\$^{*}$"
	  file write myfile " \\" _n
 
	
	 /*Standard Errors*/
	 
	 qui est r A4_column1
	 mat b = r(table)
	 file write myfile " & (" %4.2f (b[2, 1]) ")"
	 
	 qui est r A4_column2
	  mat b = r(table)
	 file write myfile " & (" %4.2f (b[2, 1]) ")"
	 
	 qui est r A4_column3
	  mat b = r(table)
	 file write myfile " & (" %4.2f (b[2, 1]) ")"
	 
	 file write myfile " \\" _n
	 file write myfile "\vspace{.1pt} \\" _n
	 
	 /*Heat Interaction*/
	file write myfile "Gas Heat x WAP"
	
	file write myfile "&"
	est res A4_column2
	mat b_log = e(b)
	file write myfile " & " %4.2f (b_log[1, 7]) 
	qui est r A4_column2
	mat b=r(table)
	if b[4,7]<=0.01 file write myfile "\$^{**}$"
	else if b[4,7]<=0.05 file write myfile "\$^{*}$"
	
	
	est res A4_column3
	mat b_log = e(b)
	file write myfile " & " %4.2f (b_log[1, 7]) 
	qui est r A4_column3
	mat b=r(table)
	if b[4,7]<=0.01 file write myfile "\$^{**}$"
	else if b[4,7]<=0.05 file write myfile "\$^{*}$"
	
	file write myfile " \\" _n
	
	/*Standard Errors*/
	 
	 file write myfile "interaction &"
	 
	qui est r A4_column2
	mat b = r(table)
	file write myfile " & (" %4.2f (b[2, 7]) ")"
	
	qui est r A4_column3
	mat b = r(table)
	file write myfile " & (" %4.2f (b[2, 7]) ")"
	
	 file write myfile " \\" _n
	 file write myfile "\vspace{.1pt} \\" _n
	
	/*Elderly Interaction*/
	file write myfile "Elderly x WAP"
	
	file write myfile "&"
	est res A4_column2
	mat b_log = e(b)
	file write myfile " & " %4.2f (b_log[1, 3]) 
	qui est r A4_column2
	mat b=r(table)
	if b[4,3]<=0.01 file write myfile "\$^{**}$"
	else if b[4,3]<=0.05 file write myfile "\$^{*}$"
	
	est res A4_column3
	mat b_log = e(b)
	file write myfile " & " %4.2f (b_log[1, 3]) 
	qui est r A4_column3
	mat b=r(table)
	if b[4,3]<=0.01 file write myfile "\$^{**}$"
	else if b[4,3]<=0.05 file write myfile "\$^{*}$"
	
	file write myfile " \\" _n
	
	/*Standard Errors*/
	 
	 file write myfile "interaction &"
	 
	 qui est r A4_column2
	mat b = r(table)
	file write myfile " & (" %4.2f (b[2, 3]) ")"
	
	qui est r A4_column3
	mat b = r(table)
	file write myfile " & (" %4.2f (b[2, 3]) ")"
	
	 file write myfile " \\" _n
	 file write myfile "\vspace{.1pt} \\" _n
	 
	 /*Income Interaction*/
	 file write myfile "Income x WAP"
	
	file write myfile "&"
	est res A4_column2
	mat b_log = e(b)
	if abs(b_log[1, 5]) <0.01 & b_log[1, 5] >= 0 file write myfile "& $< 0.01$"
	else if abs(b_log[1, 5]) >=0.01 file write myfile " & " %4.2f (b_log[1, 5]) 
	qui est r A4_column2
	mat b=r(table)
	if b[4,5]<=0.01 file write myfile "\$^{**}$"
	else if b[4,5]<=0.05 file write myfile "\$^{*}$"
	
	est res A4_column3
	mat b_log = e(b)
	if abs(b_log[1, 5]) <0.01 & b_log[1, 5] >= 0 file write myfile "& $< 0.01$"
	else if abs(b_log[1, 5) >=0.01 file write myfile " & " %4.2f (b_log[1, 5]) 
	qui est r A4_column3
	mat b=r(table)
	if b[4,5]<=0.01 file write myfile "\$^{**}$"
	else if b[4,5]<=0.05 file write myfile "\$^{*}$"

	file write myfile " \\" _n
	 
	/*Standard Errors*/
	 
	 file write myfile "interaction &"
	 
	qui est r A4_column2
	mat b = r(table)
	if abs(b[2, 5]) <0.01 & b[2, 5] >= 0 file write myfile "& $< (0.01)$"
	else if abs(b[2, 5]) >=0.01 file write myfile " & (" %4.2f (b[2, 5]) ")"
	
	
	qui est r A4_column3
	mat b = r(table)
	if abs(b[2, 5]) <0.01 & b[2, 5] >= 0 file write myfile "& $< (0.01)$"
	else if abs(b[2, 5]) >=0.01 file write myfile " & (" %4.2f (b[2, 5]) ")"
	
	
	 file write myfile " \\" _n
	 file write myfile "\vspace{.1pt} \\" _n
	 
	 /*Age of House Interaction*/
	 file write myfile "Age of house x WAP"
	
	file write myfile "&"
	est res A4_column2
	mat b_log = e(b)
	if abs(b_log[1, 9]) <0.01 & b_log[1, 9] < 0 file write myfile "& $< -0.01$ "
	else if abs(b_log[1, 9]) >=0.01 file write myfile " & " %4.2f (b_log[1, 9])
	else if abs(b_log[1, 9]) < 0.01 b_log[1, 11] >0 file write myfile " & " %4.2f (b_log[1, 9])
	qui est r A4_column2
	mat b=r(table)
	if b[4,9]<=0.01 file write myfile "\$^{**}$"
	else if b[4,9]<=0.05 file write myfile "\$^{*}$"
	
	est res A4_column3
	mat b_log = e(b)
	if abs(b_log[1, 9]) <0.01 & b_log[1, 9] >= 0 file write myfile "& $< 0.01$"
	else if abs(b_log[1, 9]) >=0.01 file write myfile " & " %4.2f (b_log[1, 9]) 
	qui est r A4_column3
	mat b=r(table)
	if b[4,9]<=0.01 file write myfile "\$^{**}$"
	else if b[4,9]<=0.05 file write myfile "\$^{*}$"
	 
	 file write myfile " \\" _n
	/*Standard Errors*/
	 
	 file write myfile "interaction &"
	 
	 qui est r A4_column2
	mat b = r(table)
	if abs(b[2, 9]) <0.01 & b[2, 9] >= 0 file write myfile "& $< (0.01)$"
	else if abs(b[2, 9]) >=0.01 file write myfile " & (" %4.2f (b[2, 9]) ")"
	
	
	qui est r A4_column3
	mat b = r(table)
	if abs(b[2, 9]) <0.01 & b[2, 9] >= 0 file write myfile "& $< (0.01)$"
	else if abs(b[2, 9]) >=0.01 file write myfile " & (" %4.2f (b[2, 9]) ")"
	
	
	 file write myfile " \\" _n
	 file write myfile "\vspace{.1pt} \\" _n
	 
	 /*Furnace Interaction*/
	file write myfile "Furnace x WAP"
	
	file write myfile "& &"
	
	est res A4_column3
	mat b_log = e(b)
	file write myfile " & " %4.2f (b_log[1, 13]) 
	qui est r A4_column3
	mat b=r(table)
	if b[4,13]<=0.01 file write myfile "\$^{**}$"
	else if b[4,13]<=0.05 file write myfile "\$^{*}$"
	
	file write myfile " \\" _n
	
	/*Standard Errors*/
	 
	 file write myfile "interaction & &"
	
	qui est r A4_column3
	mat b = r(table)
	file write myfile " & (" %4.2f (b[2, 13]) ")"
	
	 file write myfile " \\" _n
	 file write myfile "\vspace{.1pt} \\" _n
	 
	 /*Retrofit Cost Interaction*/
	 file write myfile "Retrofit cost x WAP"
	
	file write myfile "& &"
	
	est res A4_column3
	mat b_log = e(b)
	est res A4_column3
	mat b_log = e(b)
	if abs(b_log[1, 11]) <0.01 & b_log[1, 11] < 0 file write myfile "& $< -0.01$"
	else if abs(b_log[1, 11]) >=0.01 file write myfile " & " %4.2f (b_log[1, 11])
	else if abs(b_log[1, 11]) < 0.01 b_log[1, 11] >0 file write myfile " & " %4.2f (b_log[1, 11])
	qui est r A4_column3
	mat b=r(table)
	if b[4,11]<=0.01 file write myfile "\$^{**}$"
	else if b[4,11]<=0.05 file write myfile "\$^{*}$"
	
	file write myfile " \\" _n
	
	 
	/*Standard Errors*/
	 
	 file write myfile "interaction & &"
	
	qui est r A4_column3
	mat b = r(table)
	if abs(b[2, 11]) <0.01 & b[2, 11] >= 0 file write myfile "& $< (0.01)$"
	else if abs(b[2, 11]) >=0.01 file write myfile " & (" %4.2f (b[2, 11]) ")"
	
	
	 file write myfile " \\" _n
	 
	 file write myfile "\vspace{.1pt} \\" _n
	file write myfile "\vspace{.1pt} \\" _n
	
	file write myfile "\hline \\" _n
	
	 
	 /*R Squared*/
	 
	 file write myfile "\hline \\" _n 
	 
	 file write myfile "Adjusted R-squared"
	 
	 est res A4_column1
	 mat b=e(r2_a)
	file write myfile " & " %4.2f (b[1,1])
	
	est res A4_column2
	 mat b=e(r2_a)
	file write myfile " & " %4.2f (b[1,1])
	
	est res A4_column3
	 mat b=e(r2_a)
	file write myfile " & " %4.2f (b[1,1])
	
	file write myfile " \\" _n
	
	/*Households*/
	
	file write myfile "Households"
	
	
	est res A4_column1
  mat b=e(N_clust)
  file write myfile " & " %4.0f (b[1,1])
  local estimate1 = (b[1, 1])
  display `estimate1'
  
  	est res A4_column2
  mat b=e(N_clust)
  file write myfile " & " %4.0f (b[1,1])
  local estimate2 = (b[1, 1])
  display `estimate2'
  
  	est res A4_column3
  mat b=e(N_clust)
  file write myfile " & " %4.0f (b[1,1])
  local estimate3 = (b[1, 1])
  display `estimate3'
  
  	file write myfile " \\" _n
	
	/*Observations*/
	
	file write myfile "Observations"
	
	est res A4_column1
	mat b=e(N)
  file write myfile " & " %6.0f (b[1,1])
  local estimate4 = (b[1, 1])
  display `estimate4'
  
  est res A4_column2
	mat b=e(N)
  file write myfile " & " %6.0f (b[1,1])
  local estimate5 = (b[1, 1])
  display `estimate5'
  
  est res A4_column3
	mat b=e(N)
  file write myfile " & " %6.0f (b[1,1]) _n
	 local estimate6 = (b[1, 1])
  display `estimate6'
	
	file write myfile " \\" _n
	file write myfile "\hline \\" _n
	
	file write myfile "\end{tabular*} }}" _n  
	file write myfile "\vspace{.2pt} \\" _n ///
"\footnotesize Note: The unit of observation is a household-month. The dependent variable is the log of monthly household" ///
" energy consumption measured in MMBtu. All specifications include un-interacted covariates, household-calendar-month fixed effects, and" ///
" month-year-county fixed effects (not shown). Standard errors (in parentheses) are clustered at the household level. \\" _n ///
"$^{*}$ Significant at the 5 percent level \\" _n ///
"$^{**}$ Significant at the 1 percent level \\" _n ///

file write myfile "\end{table}"

file close myfile		
		
		
		
		
		
		
		
		
