**RED_estimate.do
**This file carries out the experimental estimates 
**and builds Table 4 of the paper. 

*input: sec_dirpath/RED_est.dta
*output: RED_table.tex
	
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
global output "T:\WAP_FINAL\WAP_Appendix_Final\tables_figures"
	

****************************************
**Section 1: Run Regressions
****************************************

log using "$output/RED_output.log", replace text
use "$sec_dirpath/RED_est.dta", clear
	 
/*Table 4 Column (1)*/
		 
display "** OLS benchmark **"
table PRE WAP RED_CAT, c(mean BTU)
*Numbers used in imputation for mmbtu actual-to-projected savings ratio
table PRE WAP RED_CAT, c(mean neat_totalmbtu_savings)
*Numbers used in imputation for neat NPV savings
table PRE WAP RED_CAT, c(mean neat_npv_savings)

	
  xtreg lnBTU D _Iyear_* D_monXyea_*, fe robust cluster(fwhhid)
		 est sto comb_ols	

/*Table 4 Column (2)*/
	
display "**IV_FE**"
		  
	xtivreg2 lnBTU (D=IV) _Iyear_* D_monXyea_*, fe robust cluster(fwhhid) first
		 est sto comb_log
		 
 
 

/*Table 4 Column (3)*/

display "**Gas Log**"	

		 
use "$sec_dirpath/RED_est.dta", clear	 
		 
		 	
		 
		 drop if elec_only==1
		 drop if GAS==0
		 
/*Table generates encouragement-Period (i.e. PRE == 0) Consumption gas usage for use in NPV calculations (NPV_calcs.xls) worksheet.
This worksheet calculates the imputed counterfactual consumption row as well as the NPV estimates in Panel B of Table 4.*/
		table PRE WAP RED_CAT, c(mean GAS)
	
	
		 xtivreg2 lnGAS (D=IV) _Iyear_* D_monXyea_*, fe robust cluster(fwhhid) first
		 est sto gas_log


/*Table 4 Column (4)*/

display "**Elec Log**"	
	

 
 display "ELEC"
		 clear 


use "$sec_dirpath/RED_est.dta", clear

		 
		 drop if only_gas==1
		 drop if ELEC==0
		 drop if ELEC==.
		 
/*Table generates encouragement-Period (i.e. PRE == 0) electricity usage for use in NPV calculations (NPV_calcs.xls) worksheet.
This worksheet calculates the imputed counterfactual consumption row as well as the NPV estimates in Panel B of Table 4.*/
		table PRE WAP RED_CAT, c(mean ELEC)	
		
		
		 /* Some really extreme outliers here that are orders of magnitude larger than prior/post consump...*/
		 sort fwhhid year month
		 gen n=_n
		 replace ELEC=. if ELEC[_n]>50 & ELEC[_n-1]<30 & fwhhid[_n]==fwhhid[_n-1]
		 replace ELEC=. if ELEC[_n]>50 & ELEC[_n+1]<30 & fwhhid[_n]==fwhhid[_n+1]
		 
		
		 
		 xtivreg2 lnELEC (D=IV) _Iyear_* D_monXyea_*, fe robust cluster(fwhhid) first
		 est sto elec_log
		 
		 log close

/* Generate table for paper
Columns - OLS-FE on Total Energy, IV-FE on Total Energy, IV-FE on Total Gas, IV-FE on Total Electricity
Panel A - Regression estimates of the effect of weatherization on energy consumption
  Rows - WAP, Imputed Counterfactual Consumption, F-statistic encouragement, Households, Observations
Panel B - Present value of Discounted Savings
  Rows - 10 years, 16 years, 20 years

preamble when viewing table for editing
\documentclass{article}
\usepackage{caption}
\usepackage{subcaption}
\usepackage{tabularx}
\usepackage{multirow}
\usepackage{rotating}
\usepackage{tabularx}
\newcolumntype{Y}{>{\centering\arraybackslash}X}
\begin{document}
*/

  capture file close myfile
  cd  "$output"

  *file open myfile using "RED_table.tex", write replace 
  file open myfile using "Table4.tex", write replace 
	

  file write myfile "\begin{table}[H]" _n "{" _n "\small" _n ///
  "\centering" _n ///
  "\resizebox{\columnwidth}{!}{" _n ///
  "\begin{tabularx}{1.2\textwidth}{@{\extracolsep{\fill}}lYYYY}" _n ///
  "\hline\hline" _n ///
  "\vspace{.1pt} \\" _n /// 
  "\multicolumn{5}{l}{\textbf{Panel A: Dependent variable is monthly energy consumption (in logs)}}" _n ///
  "\vspace{.2pt} \\" _n /// 
  " & \multicolumn{2}{c}{Total Energy} & Gas & Electricity \\ " _n ///
  "& (1) & (2) & (3) & (4) \\" _n ///
  " & OLS-FE & IV-FE & IV-FE & IV-FE \\" _n ///
  "\hline \\" _n ///
  "\vspace{.2pt} \\" _n //
 
  file write myfile "WAP"

  est res comb_ols
  mat b_ols=e(b)
  file write myfile " & " %4.2f (b_ols[1,1])
  qui est r comb_ols
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  
  
  
foreach x in comb_log gas_log elec_log {
	
	est restore `x'
	mat b = e(b)
	local beta`x' = (b[1, 1])
	file write myfile " & " %4.2f (b[1,1])
	qui est r `x'
	mat V = e(V)
	local z`x' = `beta`x'' / sqrt(V[1,1])
	local pp`x' = 2 * normal(-abs(`z`x''))
	if `pp`x''<=0.01 file write myfile "\$^{**}$"
	else if `pp`x''<=0.05 file write myfile "\$^{*}$"
	
}

file write myfile "\\" _n
	
foreach x in comb_ols  /*comb_exc*/ comb_log gas_log elec_log {
    
	est res `x'
	mat V = e(V)
	file write myfile " & (" %4.2f (sqrt(V[1,1])) ")"
	
}


file write myfile "\\" _n

*These imputed averages come from the NPV_calcs worksheet. 
file write myfile "Imputed counterfactual consumption & \multicolumn{2}{c}{7.52} & 6.39 & 2.13 \\" _n
file write myfile "MMbtu/month \\" _n




  file write myfile "\vspace{.2pt} \\" _n //


file write myfile "F-statistic & .  &"  "267.41$^{**}$ &" "261.06$^{**}$ &" "266.78$^{**}$ \\" _n

file write myfile "\vspace{.1pt} \\" _n 

file write myfile "Households"

foreach x in  comb_ols comb_log gas_log elec_log{
	est restore `x'
	file write myfile " & " %6.0fc (e(N_clust))

}
file write myfile "\\ \\" _n

file write myfile "Observations"
	
foreach x in  comb_ols comb_log gas_log elec_log{
	est restore `x'
  mat b=e(N)
  file write myfile " & " %6.0fc (b[1,1])
}

file write myfile "\\" _n
file write myfile "\vspace{.1pt} \\" _n


file write myfile "\multicolumn{5}{l}{\textbf{Panel B: Present value of (discounted) savings}} \\" _n 

file write myfile "\vspace{.1pt} \\" _n 

  
  file write myfile "Time Horizon & \multicolumn{3}{c}{Discount rate} \\" _n
  file write myfile "&  3 percent & 6 percent & 10 percent \\"
  file write myfile "\hline \\" _n 
  file write myfile "\vspace{.2pt} \\" _n 
 
  file write myfile " 10 years  &   \\$1,983 &  \\$1,711 & \\$1,428 \\" _n
  file write myfile " 16 years  &   \\$2,920 &  \\$2,349 & \\$1,819 \\" _n
  file write myfile " 20 years  &   \\$3,459 &  \\$2,666 & \\$1,979 \\" _n
  
  file write myfile "\vspace{.1pt} \\" _n //
  

file write myfile "\hline \\" _n ///
"\end{tabularx} } }" _n ///
"\footnotesize {Note: Dependent variable measures log of monthly household energy consumption. " _n ///
"Panel A reports regression coefficients. With the exception of the first column, all specifications are estimated using 2SLS. " _n ///
"All specifications include household-by-calendar-month fixed effects and region-by-month-of-sample fixed effects. " _n ///
"Standard errors (in parentheses) are clustered by household. " _n ///
"Panel B reports savings projections generated by NEAT audit. " _n ///
"All regressions include month-of-sample and household-month fixed effects. \\" _n ///
"$^{*}$ Significant at the 5 percent level \\" _n ///
"$^{**}$ Significant at the 1 percent level} \\" _n ///
"\end{table}" _n

file close myfile
