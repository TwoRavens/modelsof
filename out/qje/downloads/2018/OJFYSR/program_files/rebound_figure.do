**rebound_summary.do
**This file builds Appendix Figure 2, which maps energy performance at weatherized
**versus unweatherized homes

*Input: sec_dirpath/QUASI_cmb_est.dta
*Output: rebound_graphic.pdf

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

*Meredith Directories

global sec_dirpath "T:\Efficiency\WAP\data"
global home_dirpath "T:\WAP_FINAL\WAP_Appendix_Final\data_files"
global output "T:\WAP_FINAL\WAP_Appendix_Final\tables_figures"

**Data preparation for Figure Creation	

  use "$sec_dirpath/QUASI_cmb_est.dta"
  
*Limit sample to program applicants (see equation (3) in paper)
  keep if IN_CAA==1
  keep if normal==1
  keep if CMP_CONS==1
  capture drop WINT
  
  /*Define winter months*/
  gen WINT=0
			replace WINT=1 if month>8 
			replace WINT=1 if month<5
  
  
  keep cons_hh_id fwhhid date tm GAS normal only_gas elec_only month year walt_id WAP WINT D cons_hh_id 
  
  sort year month
  
  merge year month using "$home_dirpath/temp_reg.dta"
  
  
  rename dd HDD
  
  gen INT_DD= D*HDD
  
  gen HDDsq=HDD*HDD

  gen INT_DD2=D*HDDsq
	
		
  keep if WINT==1
  
*Make linear prediction of gas consumption
	 areg GAS HDD D HDDsq INT_DD INT_DD2, absorb(cons_hh_id)

*store linear prediction estimates
  predict xb
 
**Create Appendix Figure 2
 twoway (line xb HDD if D==1) (line xb HDD if D==0), ytitle(Natural gas consumption (MMBtu/month)) yscale(r(0 14)) ylabel(2(2)14) xlabel(500[500]1500) xscale(r(0[500]1500)) legend(label(1 "Weatherized") label(2 "Unweatherized"))
  graph export "$output/rebound_graphic.pdf", as(pdf) replace


