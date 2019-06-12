**Quasi_exp_Appendix2_necessary.do
**This file carries out the quasi-experimental estimates 
**and builds Appendix Table 4 of the paper. 

*input: sec_dirpath/QUASI_cmb_est.dta, 
*output: quasi_estimate_app.tex

clear all
capture log close
clear matrix
program drop _all
set more off

global p_spec "4"
global m_pref "3"

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

capture log close
log using "$output\quasi_app_3.txt", replace text


*First, edit psweight_4.dta file in preparation for merge with QUASI_cmb_est data
*cd "$home_dirpath/Brian Checks/Annotated Code/Input"
cd "T:\WAP_FINAL\WAP_Appendix_Final\data_files"	
		use psweight_4.dta, clear
		
			keep walt_id cons_hh_id WAP pscore ps_w block
			sort cons_hh_id
			tempfile temp
			save `temp', replace
			clear


*************************************************************
*************************************************************
**Panel A
*************************************************************
*************************************************************


*************************************************************
**Columns 1 & 2 program: quasi_gas
*************************************************************

  disp   "GAS only"
  
  
  use "$sec_dirpath\QUASI_cmb_est.dta", replace
  
         drop if GAS==.
		 keep if normal==1
		 drop if elec_only==1
		 drop if BTU==0
		 
 disp "Column 1"

 areg lnGAS D  _Iyear_* _Im_AXyea*  , absorb(id) robust cluster(fwhhid)
		  est store reg_log_gas_sat
		  
	disp "Column 2"

areg GAS D _Iyear_* _Im_AXyea*, absorb(id) robust cluster(fwhhid)
		  est store reg_level_gas_sat
		
*Generate Average Consumption for Control Group
drop if WAP==1
		  drop if year<2011
		  drop if year==2011 & month<3
		  duplicates drop
		  *drop if year<2012
		  estpost sum GAS
		  est sto sum_total_levelg 

		  
*************************************************************
**Columns 3 & 4 program: quasi_gas
*************************************************************  
		  

clear 

use "$sec_dirpath\QUASI_cmb_est.dta", replace
  
   xtset id
          
         drop if GAS==.
		 keep if normal==1
		 drop if elec_only==1
		 drop if BTU==0
		 	
		 *Limit sample to agencies that participated in experiment, as well as
		 *applicants that applied after encouragement intervention was initiated
		  keep if agency_name=="gccard" | agency_name=="jackson"
		  drop if WAP==1 & WAP_y<2011
		  drop if WAP==1 & WAP_y==2011 & WAP_m<3
		  
		  disp "Column 3"
		  
areg lnGAS D _Iyear_* _Im_AXyea*, absorb(id) robust cluster(fwhhid)
		  est store reg_log_agn_gas_sat
		  
		  disp "Column 4"
		  
areg GAS D _Iyear_* _Im_AXyea*, absorb(id) robust cluster(fwhhid)
		  est store reg_level_agn_gas_sat


		  *Generate Average Consumption for Control Group
		  drop if WAP==1
		  drop if year<2011
		  drop if year==2011 & month<3
		  duplicates drop
		  *drop if year<2012
		  estpost sum GAS
		  est sto sum_total_agn_levelg 

*************************************************************
**Columns 5 & 6 program: quasi_psw
***********************************************************	 


clear 	  
	*GAS*
			
			use "$sec_dirpath\QUASI_cmb_est.dta", replace
			capture drop _merge
			drop if GAS==.
			keep if normal==1
			drop if BTU==0
			
			
			sort cons_hh_id
			merge cons_hh_id using `temp'		  
  
	disp "Column 5"
	
		  areg lnGAS D  _Iyear_* _Im_AXyea* [pw=ps_w], absorb(id) robust cluster(fwhhid)
	      est sto preg_log_g  
		  
	disp "Column 6"
		  
		  areg GAS D _Iyear_* _Im_AXyea* [pw=ps_w], absorb(id) robust cluster(fwhhid)
          est sto preg_level_g

		  *Generate Average Consumption for Control Group
		 keep walt_id cons_hh_id fwhhid GAS WAP year month ps_w
		  duplicates drop
		  drop if ps_w==.
		  
		  *drop if year<2012
		  drop if year<2011
		  drop if year==2011 & month<3
		  pstest GAS, treated(WAP) mweight(ps_w)
		  summarize GAS [w=ps_w] if WAP==0
		  local panelAmean = `r(mean)'
		local panelAsd = `r(sd)'
		  
*************************************************************
*************************************************************
**Panel B
*************************************************************
*************************************************************
		  
		  
*************************************************************
**Columns 1 & 2 program:  quasi_elec
***********************************************************	 
		  
		  
 use "$sec_dirpath\QUASI_cmb_est.dta", replace
  
   xtset id
  
         drop if ELEC==.
		 keep if normal==1
		 drop if only_gas==1		  
		  
disp "Column 1"
areg lnELEC D  _Iyear_* _Im_AXyea* , absorb(id) robust cluster(fwhhid)
		  est sto reg_loge_sat
		  
disp "Column 2"
		  
  areg ELEC D _Iyear_* _Im_AXyea*, absorb(id) robust cluster(fwhhid)
          est sto reg_levele_sat	

*Generate Average Consumption for Control Group
drop if WAP==1
drop if year<2011
drop if year==2011 & month<3
duplicates drop
*drop if year<2012
estpost sum ELEC
est sto sum_total_level_e 	  

		  
*************************************************************
**Columns 3 & 4 program:  quasi_elec
***********************************************************	 	  
		  
  use "$sec_dirpath\QUASI_cmb_est.dta", clear
  
         drop if ELEC==.
		 keep if normal==1
		 drop if only_gas==1		  
			
		 *Limit sample to agencies that participated in experiment, as well as
		 *applicants that applied after encouragement intervention was initiated
		  keep if agency_name=="gccard" | agency_name=="jackson"
		  drop if WAP==1 & WAP_y<2011
		  drop if WAP==1 & WAP_y==2011 & WAP_m<3
		  
	disp "Column 3"	  
	
areg lnELEC D _Iyear_* _Im_AXyea* , absorb(id) robust cluster(fwhhid)
		est store reg_log_agn_e
		  
		  disp "Column 4"
		  
 areg ELEC D _Iyear_* _Im_AXyea* , absorb(id) robust cluster(fwhhid)
		  est store reg_level_agn_e

*Generate Average Consumption for Control Group
drop if WAP==1
drop if year<2011
drop if year==2011 & month<3
duplicates drop
*drop if year<2012
estpost sum ELEC
est sto sum_total_agn_e 
		  
*************************************************************
**Columns 5 & 6 program:  quasi_psw
***********************************************************	 	 		  
		  

			
			use "$sec_dirpath\QUASI_cmb_est.dta", replace
			capture drop _merge
			drop if ELEC==.
			keep if normal==1
			drop if only_gas==1
			
			
			sort cons_hh_id
			merge cons_hh_id using `temp'		
			
		 disp "Column 5"
		
areg lnELEC D  _Iyear_* _Im_AXyea* [pw=ps_w], absorb(id) robust cluster(fwhhid)
		  est sto preg_log_e
		  
		  disp "Column 6"
areg ELEC D _Iyear_* _Im_AXyea* [pw=ps_w], absorb(id) robust cluster(fwhhid)
		  est sto preg_level_e

 *Generate Average Consumption for Control Group 
		keep walt_id cons_hh_id fwhhid ELEC WAP year month ps_w
		  
		
		  *drop if year<2012
		  drop if year<2011
          drop if year==2011 & month<3

		  
		  pstest ELEC, treated(WAP) mweight(ps_w)
		  summarize ELEC [w=ps_w] if WAP==0
		 est sto sum_e_total 		  
local panelBmean = `r(mean)'
		local panelBsd = `r(sd)'
		
log close

*************************************************************
*************************************************************
**Build Appendix Table 4
*************************************************************
*************************************************************

/*
**Preamble to view in LaTex
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

  file open myfile using "quasi_estimate_app.tex", write replace 
  file write myfile "\begin{table}[H]" _n "{" _n "\small" _n ///
  "\centering" _n ///
  "\begin{tabular*}{1.0\textwidth}{@{\extracolsep{\fill}}lcccccc}" _n ///
  "\hline\hline" _n ///
  "\vspace{.1pt} \\" _n /// 
  "\multicolumn{7}{l}{\textbf{Panel A: Dependent variable is monthly natural gas consumption}}" _n ///
  "\vspace{.1pt} \\" _n /// 
  "& (1) & (2) & (3) & (4) & (5) & (6) \\" _n /// 
  "\hline \\" _n ///
  "\vspace{.1pt} \\" _n ///
 
  file write myfile "WAP"
  est res reg_log_gas_sat
  mat b_log=e(b)
  file write myfile " & " %4.2f (b_log[1,1])
  qui est r reg_log_gas_sat
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res reg_level_gas_sat
  mat b_log=e(b)
  file write myfile " & " %4.2f (b_log[1,1])
  qui est r reg_level_gas_sat
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res reg_log_agn_gas_sat
  mat b_log=e(b)
  file write myfile " & " %4.2f (b_log[1,1])
  qui est r reg_log_agn_gas_sat
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res reg_level_agn_gas_sat
  mat b_log=e(b)
  file write myfile " & " %4.2f (b_log[1,1])
  qui est r reg_level_agn_gas_sat
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res preg_log_g
  mat b_level=e(b)
  file write myfile " & " %4.2f (b_level[1,1])
  qui est r preg_log_g
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res preg_level_g
  mat b_level=e(b)
  file write myfile " & " %4.2f (b_level[1,1])
  qui est r preg_level_g
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  
  file write myfile " \\" _n
  
  est res reg_log_gas_sat
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res reg_level_gas_sat
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res reg_log_agn_gas_sat
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res reg_level_agn_gas_sat
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res preg_log_g
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")" 
  est res preg_level_g
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")" 
  
  file write myfile " \\" _n
  

  file write myfile "\vspace{.1pt} \\" _n //
  file write myfile "Average consumption"
  est res sum_total_levelg
  mat b=e(mean)
  file write myfile " & \multicolumn{2}{c}{" %4.2f (b[1,1]) "}" 
  est res sum_total_agn_levelg
  mat b=e(mean)
  file write myfile " & \multicolumn{2}{c}{" %4.2f (b[1,1]) "}" 
  
  matrix b = (`panelAmean')
  file write myfile " & \multicolumn{2}{c}{" %4.2f (b[1,1]) "}"
  file write myfile " \\" _n
   
  file write myfile "control group"
  est res sum_total_levelg
  mat b=e(sd)
  file write myfile " &  \multicolumn{2}{c}{[" %4.2f (b[1,1]) "]}" 
  est res sum_total_agn_levelg
  mat b=e(sd)
  file write myfile " &  \multicolumn{2}{c}{[" %4.2f (b[1,1]) "]}" 
  
  mat b=(`panelAsd')
  file write myfile " & \multicolumn{2}{c}{[" %4.2f (b[1,1]) "]}"
  file write myfile " \\" _n
  file write myfile "(MMbtu/month) \\"  _n 
  
  
  file write myfile "\vspace{.2pt} \\" _n 
  file write myfile "Trimmed sample  & N & N & Y & Y & N & N \\" _n
  file write myfile "P-score matched sample  & N & N & N & N & Y & Y \\" _n
  file write myfile "Dep. variable & log & levels & log & levels & log & levels \\" _n 
  file write myfile "\vspace{.2pt} \\" _n 
   
  file write myfile "Adjusted R-squared"
  est res reg_log_gas_sat
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res reg_level_gas_sat
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res reg_log_agn_gas_sat
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res reg_level_agn_gas_sat
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res preg_log_g
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res preg_level_g
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  file write myfile " \\" _n ///

  
  file write myfile "\vspace{.1pt} \\" _n //
  file write myfile "Households"
  est res reg_log_gas_sat
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_level_gas_sat
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_log_agn_gas_sat
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_level_agn_gas_sat
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  est res preg_log_g
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1]) 
  est res preg_level_g
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1]) 
  file write myfile " \\" _n
  
    
  file write myfile "Observations"
  est res reg_log_gas_sat
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_level_gas_sat
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_log_agn_gas_sat
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_level_agn_gas_sat
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  est res preg_log_g
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1]) 
  est res preg_level_g
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1]) 
  file write myfile " \\" _n ///
  
file write myfile "\vspace{.1pt} \\" _n
  

file write myfile "\multicolumn{7}{l}{\textbf{Panel B: Dependent variable is monthly electricity consumption}} \\" _n 
file write myfile "\vspace{.1pt} \\" _n 
file write myfile "& (1) & (2) & (3) & (4) & (5) & (6) \\" _n 
file write myfile "\hline \\" _n 
  file write myfile "WAP"
  est res reg_loge_sat
  mat b_level=e(b)
  file write myfile " & " %4.2f (b_level[1,1])
  qui est r reg_loge_sat
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res reg_levele_sat
  mat b_level=e(b)
  file write myfile " & " %4.2f (b_level[1,1])
  qui est r reg_levele_sat
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res reg_log_agn_e
  mat b=e(b)
  file write myfile " & " %4.2f (b[1,1])
  qui est r reg_log_agn_e
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res reg_level_agn_e
  mat b=e(b)
  file write myfile " & " %4.2f (b[1,1])
  qui est r reg_level_agn_e
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res preg_log_e
  mat b=e(b)
  file write myfile " & " %4.2f (b[1,1])
  qui est r preg_log_e
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  est res preg_level_e
  mat b=e(b)
  file write myfile " & " %4.2f (b[1,1])
  qui est r preg_level_e
  mat b=r(table)
  if b[4,1]<=0.01 file write myfile "\$^{**}$"
  else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  file write myfile " \\" _n
  
  est res reg_loge_sat
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res reg_levele_sat
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res reg_log_agn_e
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res reg_level_agn_e
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res preg_log_e
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res preg_level_e
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  file write myfile " \\" _n
  
  
  
  file write myfile "\vspace{.1pt} \\" _n //
  file write myfile "Average consumption"
  est res sum_total_level_e
  mat b=e(mean)
  file write myfile " & \multicolumn{2}{c}{" %4.2f (b[1,1]) "}" 
  est res sum_total_agn_e
  mat b=e(mean)
  file write myfile " & \multicolumn{2}{c}{" %4.2f (b[1,1]) "}" 
  
  mat b=(`panelBmean')
  file write myfile " & \multicolumn{2}{c}{" %4.2f (b[1,1]) "}"
  file write myfile " \\" _n
   
  file write myfile "control group"
  est res sum_total_level_e
  mat b=e(sd)
  file write myfile " &  \multicolumn{2}{c}{[" %4.2f (b[1,1]) "]}" 
  est res sum_total_agn_e
  mat b=e(sd)
  file write myfile " &  \multicolumn{2}{c}{[" %4.2f (b[1,1]) "]}"
  
    mat b=(`panelBsd')
  file write myfile " &  \multicolumn{2}{c}{[" %4.2f (b[1,1]) "]}" 
  file write myfile " \\" _n
  file write myfile "(MMbtu/month) \\"  _n //  
  
  
  file write myfile "\vspace{.2pt} \\" _n //
  file write myfile "Trimmed sample  & N & N & Y & Y & N & N \\" _n
  file write myfile "P-score matched sample  & N & N & N & N & Y & Y \\" _n
  file write myfile "Dep. variable & log & levels & log & levels & log & levels \\" _n ///

  file write myfile "\vspace{.2pt} \\" _n //
   
  file write myfile "Adjusted R-squared"
  est res reg_loge_sat
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res reg_levele_sat
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res reg_log_agn_e
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res reg_level_agn_e
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res preg_log_e
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
  est res preg_level_e
  mat b=e(r2_a)
  file write myfile " & " %4.2f (b[1,1])
 file write myfile " \\" _n ///
  
  
  file write myfile "\vspace{.1pt} \\" _n //
  file write myfile "Households"
  est res reg_loge_sat
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_levele_sat
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_log_agn_e
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_level_agn_e
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1])
  est res preg_log_e
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1]) 
  est res preg_level_e
  mat b=e(N_clust)
  file write myfile " & " %5.0fc (b[1,1]) 
  file write myfile " \\" _n
  
    
  file write myfile "Observations"
  est res reg_loge_sat
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_levele_sat
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_log_agn_e
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  est res reg_level_agn_e
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1])
  est res preg_log_e
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1]) 
  est res preg_level_e
  mat b=e(N)
  file write myfile " & " %5.0fc (b[1,1]) 
 
  file write myfile " \\" _n
  
  file write myfile "\hline \\" _n ///
"\end{tabular*} }" _n  ///
"\footnotesize{\parbox{1.0\textwidth} {Note: Table reports estimates of the reduction in monthly energy consumption following weatherization." ///
" The unit of observation is a household-month. The dependent variable is monthly household energy consumption (electricity" ///
" or natural gas) measured in MMBtu. The coefficient reported is the coefficient on the weatherization indicator, which" ///
" switches to one from zero after a household weatherization is completed. All specifications include household-by-calendar-month and month-of-sample-by-county fixed effects. Standard errors (in parentheses) are clustered at" ///
" the household level. }}" _n ///
"$^{*}$ Significant at the 5 percent level \\" _n ///
"$^{**}$ Significant at the 1 percent level \\" _n ///

file write myfile "\end{table}"

file close myfile
