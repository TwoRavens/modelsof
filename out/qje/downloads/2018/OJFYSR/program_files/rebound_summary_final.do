**rebound_summary_extra.do
**This file builds Table 6, which reports measured indoor temperature
**differentials across weatherized and unweatherized households

*input: home_dirpath/DATA/Crosswalk_Files/consumers_to_walter_crosswalk.dta, home_dirpath/DATA/CAA_demog.dta, home_dirpath/DATA/temp_reg.dta
*output: rebound_survey.tex


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

global sec_dirpath "T:\Efficiency\WAP\data"
global home_dirpath "T:\Dropbox\WAP"
global output "T:\WAP_FINAL\WAP_Appendix_Final\tables_figures"

log using "$output\rebound.log", replace

**Import Data
use "$home_dirpath\DATA\Crosswalk_Files\consumers_to_walter_crosswalk.dta", clear
		  * 6070 in this crosswalk file out of 7502.
	     capture drop _merge 
		 sort walt_id

 *merge walt_id using "$home_dirpath/DATA/CAA_demog.dta"
 merge walt_id using "$home_dirpath\DATA\CAA_demog_redux.dta"

**********************************************************************************************************
****Section 1: This section develops propensity weights for the thermometer (Columns 1 & 2) regressions 
**********************************************************************************************************
  
  *Temprespond = 1 if household allowed temperature surveyors to take measurements
  gen temprespond=~(fw_Q12==. & fw_Q12S==.)
  count if temprespond==1 & IN_CAA==0
  count if fw_Q04~="" & IN_CAA==0
  *Only keep households that applied for WAP
  keep if IN_CAA==1
  summ temprespond IN_CAA
  tab fw_Q04
  replace fw_Q04 = "" if fw_Q04=="0"
 
  * Comparing unweatherized survey respondents to unweatherized quasi-experimental sample
  foreach x in AGE COLLEGE HS CHILDREN ELDERLY DISABLED HH_SIZE MOBILE YEAR_BUILT HOME_AGE UNEMP GAS_HEAT ENERGY_BILL PC_POVERTY INCOME {
	disp "`x'"
  	ttest `x' if ~WAP, by(temprespond)
  	}
	
reg temprespond AGE COLLEGE HS CHILDREN ELDERLY DISABLED HH_SIZE MOBILE YEAR_BUILT HOME_AGE UNEMP GAS_HEAT ENERGY_BILL PC_POVERTY INCOME if WAP == 0

  *	Comparing weatherized survey respondents to weatherized quasi-experimental sample
  	
  foreach x in AGE COLLEGE HS CHILDREN ELDERLY DISABLED HH_SIZE MOBILE YEAR_BUILT HOME_AGE UNEMP GAS_HEAT ENERGY_BILL PC_POVERTY INCOME {
	disp "`x'"
  	ttest `x' if WAP, by(temprespond)
  	}
	
reg temprespond AGE COLLEGE HS CHILDREN ELDERLY DISABLED HH_SIZE MOBILE YEAR_BUILT HOME_AGE UNEMP GAS_HEAT ENERGY_BILL PC_POVERTY INCOME if WAP==1


** Now construct pscore based on variables reported by entire sample  - unweatherized first
cap drop ps_w pscore block
*pscore temprespond AGE HS CHILDREN ELDERLY DISABLED MOBILE UNEMP GAS_HEAT if ~WAP, pscore(pscore) blockid(block)
pscore temprespond COLLEGE HS CHILDREN ELDERLY DISABLED MOBILE UNEMP GAS_HEAT if ~WAP, pscore(pscore) blockid(block)

** NB: Didn't include HH_SIZE as it's likely highly correlated with CHILDREN and isn't defined for whole quasi sample
** Didn't include ENERGY_BILL, AGE, PC_POVERTY, INCOME as these are defined for small subset of quasi sample 
** Note weighted regression results robust to different matching/balancing strategies.

gen ps_w = 1/pscore

** Checking balance, esp given notice about not balanced on GAS_HEAT

summ HS CHILDREN ELDERLY DISABLED MOBILE UNEMP GAS_HEAT ENERGY_BILL if temprespond & ~WAP [iw=ps_w]
summ HS CHILDREN ELDERLY DISABLED MOBILE UNEMP GAS_HEAT ENERGY_BILL if ~WAP


** Pscore  - weatherized
drop pscore block
*pscore temprespond HS CHILDREN ELDERLY UNEMP GAS_HEAT if WAP, pscore(pscore) blockid(block)

pscore temprespond COLLEGE HS CHILDREN ELDERLY DISABLED MOBILE UNEMP GAS_HEAT if WAP, pscore(pscore) blockid(block)

** NB: Didn't include HH_SIZE as it's likely highly correlated with CHILDREN and isn't defined for whole quasi sample 
** Didn't include ENERGY_BILL, AGE, PC_POVERTY, INCOME as it's not defined for whole quasi sample 
** Note weighted regression results robust to different matching/balancing strategies.

replace ps_w = 1/pscore if WAP

** Checking balance, esp given notice about not balanced on GAS_HEAT

summ HS CHILDREN ELDERLY UNEMP GAS_HEAT if temprespond & WAP [iw=ps_w]
summ HS CHILDREN ELDERLY UNEMP GAS_HEAT if WAP

**********************************************************************************************************
**** Section 2: This section develops propensity weights for the thermostat (Columns 3 & 4) regressions 
**********************************************************************************************************

  gen thermrespond=~(fw_Q04=="")
  summ thermrespond
 
  * Comparing unweatherized survey respondents to unweatherized quasi-experimental sample
  foreach x in AGE COLLEGE HS CHILDREN ELDERLY DISABLED HH_SIZE MOBILE YEAR_BUILT HOME_AGE UNEMP GAS_HEAT ENERGY_BILL PC_POVERTY INCOME {
	disp "`x'"
  	ttest `x' if ~WAP, by(thermrespond)
  	}
	
reg thermrespond AGE COLLEGE HS CHILDREN ELDERLY DISABLED HH_SIZE MOBILE YEAR_BUILT HOME_AGE UNEMP GAS_HEAT ENERGY_BILL PC_POVERTY INCOME if WAP == 0

  *	Comparing weatherized survey respondents to weatherized quasi-experimental sample
  	
  foreach x in AGE COLLEGE HS CHILDREN ELDERLY DISABLED HH_SIZE MOBILE YEAR_BUILT HOME_AGE UNEMP GAS_HEAT ENERGY_BILL PC_POVERTY INCOME {
	disp "`x'"
  	ttest `x' if WAP, by(thermrespond)
  	}
	
reg thermrespond AGE COLLEGE HS CHILDREN ELDERLY DISABLED HH_SIZE MOBILE YEAR_BUILT HOME_AGE UNEMP GAS_HEAT ENERGY_BILL PC_POVERTY INCOME if WAP==1

** Do pscore on variables that don't show balance - unweatherized first
drop block
pscore thermrespond COLLEGE HS CHILDREN ELDERLY DISABLED MOBILE UNEMP GAS_HEAT if ~WAP, pscore(pscore_th) blockid(block)
gen ps_th = 1/pscore_th

** Checking balance

summ AGE COLLEGE HS CHILDREN ELDERLY DISABLED HH_SIZE MOBILE UNEMP GAS_HEAT INCOME if temprespond & ~WAP [iw=ps_th]
summ AGE COLLEGE HS CHILDREN ELDERLY DISABLED HH_SIZE MOBILE UNEMP GAS_HEAT INCOME if ~WAP

** Pscore on variables that don't show balance - weatherized
drop pscore_th block
*pscore temprespond HS CHILDREN UNEMP GAS_HEAT if WAP, pscore(pscore_th) blockid(block)
pscore thermrespond COLLEGE HS CHILDREN ELDERLY DISABLED MOBILE UNEMP GAS_HEAT if WAP, pscore(pscore_th) blockid(block)

** NB: Didn't include HH_SIZE for both or AGE or INCOME for unweatherized as they aren't defined for whole quasi sample 

replace ps_th = 1/pscore_th if WAP

** Checking balance

summ HS CHILDREN ELDERLY HH_SIZE UNEMP GAS_HEAT if temprespond & WAP [iw=ps_th]
summ HS CHILDREN ELDERLY HH_SIZE UNEMP GAS_HEAT if WAP


*** Reshape data 

		 keep fw_Q12 fw_Q12S fw_Q04 fw_Q05 fwhhid fw_ID WAP fw_DateTime ps_w ps_th
		 *convert measurements to numerical entries
		 gen thermset=real(fw_Q04)
		 drop fw_Q04
		 drop if fw_Q12==. & fw_Q12S==. & thermset==. 
		 rename fw_Q12 temp1
		 rename fw_Q12S temp2
		 drop if fw_ID==.
		 replace fwhhid=fw_ID if fwhhid==.
		 sort fwhhid
		 count if fwhhid==fwhhid[_n-1]
		 drop fw_ID
		 
		 reshape long temp, i(fwhhid) j(m)
	

*** Example regression without HDD
			 
  reg temp WAP, robust cluster(fwhhid)
	  est sto reg_2
  
  
gen date=dofc(fw_DateTime)
gen dayofweek=dow(date)
tab dayofweek, gen(dw)
drop dw7

sort date
*Merge WAP and hdd variables into data
merge m:1 date using "$home_dirpath/Brian Checks/Annotated Code/Input/temp_reg.dta"
tab _merge
 
 
 
**********************************************************************************************************
**** Section 3: This section runs regressions reported in Table 6
**********************************************************************************************************
 

*** Column (1)
	  reg temp WAP hdd, robust cluster(fwhhid)
		est sto column_1
		
	  
*** Column (2)
	  reg temp WAP hdd [pw=ps_w], robust cluster(fwhhid)
	  
		est sto column_2
		
	  

*** Column (3), thermostat set
	  sort fwhhid
	  reg thermset WAP hdd if fwhhid~=fwhhid[_n-1], robust cluster(fwhhid)
	
	  est sto column_3
	  
	  
	  
*** Column (4) for thermostat set
	  sort fwhhid
	  reg thermset WAP hdd if fwhhid~=fwhhid[_n-1] [pw=ps_th], robust cluster(fwhhid)
	   
	  est sto column_4
 
**********************************************************************************************************
**** Section 4: This section builds Table 6
**********************************************************************************************************	

  
  /*
  Columns- Measured temperature differences with and without propensity score matching
  and with 1 set measured by temperature monitor with another set measured by thermostat. 
  Rows: Base Temperature, Weatherized home, Heating Degree Days, Propensity Score Weights,
  R-squared, Observations
  
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
 file open myfile using "Table6.tex", write replace 
 *file open myfile using "rebound_survey.tex", write replace
 file write myfile "\begin{table}[H]" _n "{" _n "\small" _n ///
  "\centering" _n ///
   "\begin{tabular*}{1.0\textwidth}{@{\extracolsep{\fill}}lcccc}" _n ///
  "\hline\hline" _n ///
  "\vspace{.1pt} \\" _n ///
  "\multicolumn{5}{l}{\textbf{Indoor temperature response to weatherization}}  \\" _n ///
   "\vspace{.2pt} \\" _n ///
   "& \multicolumn{2}{c}{Thermometer} & \multicolumn{2}{c}{Thermostat} \\" _n ///
   "& (1) &  (2) & (3) & (4) \\" _n /// 
  "\hline \\" _n ///
  
  /*Base temperature*/
  file write myfile "Base temperature"
  
    est res column_1
  mat b = e(b)
  file write myfile " & " %4.2f (b[1,3])
   qui est r column_1
   mat b=r(table)
  if b[4,3]<=0.01 file write myfile "\$^{**}$"
  else if b[4,3]<=0.05 file write myfile "\$^{*}$"
  est res column_2
  mat b = e(b)
  file write myfile " & " %4.2f (b[1,3])
   qui est r column_2
   mat b=r(table)
  if b[4,3]<=0.01 file write myfile "\$^{**}$"
  else if b[4,3]<=0.05 file write myfile "\$^{*}$" 
  est res column_3
  mat b = e(b)
  file write myfile " & " %4.2f (b[1,3])
  qui est r column_3
   mat b=r(table)
  if b[4,3]<=0.01 file write myfile "\$^{**}$"
  else if b[4,3]<=0.05 file write myfile "\$^{*}$"
  est res column_4
  mat b = e(b)
  file write myfile " & " %4.2f (b[1,3])
   qui est r column_4
   mat b=r(table)
  if b[4,3]<=0.01 file write myfile "\$^{**}$"
  else if b[4,3]<=0.05 file write myfile "\$^{*}$"
  
  file write myfile "\\" _n
  
  /*standard errors*/
 
  est res column_1
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[3,3])) ")"
    est res column_2
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[3,3])) ")"
  est res column_3
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[3,3])) ")"
  est res column_4
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[3,3])) ")"
  file write myfile "\\" _n
  
  /*Weatherized Home*/
  
   file write myfile "Weatherized home"

    est res column_1
  mat b = e(b)
  file write myfile " & " %4.2f (b[1,1])
  qui est r column_1
   matrix b = r(table)
  if b[4, 1]<=0.01 file write myfile "\$^{**}$"
   else if b[4,1]<=0.05 file write myfile "\$^{*}$"
  
  
  est res column_2
  mat b = e(b)
  file write myfile " & " %4.2f (b[1,1])
    qui est r column_2
   matrix b = r(table)
  if b[4, 1]<=0.01 file write myfile "\$^{**}$"
   else if b[4,1]<=0.05 file write myfile "\$^{*}$"
   
      est res column_3
  mat b = e(b)
  file write myfile " & " %4.2f (b[1,1])
 qui est r column_3
  matrix b = r(table)
    if b[1,3]<=0.01 file write myfile "\$^{**}$"
  else if b[1,3]<=0.05 file write myfile "\$^{*}$"
  
  est res column_4
  mat b = e(b)
  file write myfile " & " %4.2f (b[1,1])
  qui est r column_4
  matrix b = r(table)
	if b[4, 1]<=0.01 file write myfile "\$^{**}$"
   else if b[4,1]<=0.05 file write myfile "\$^{*}$"
   
   
   
    file write myfile "\\" _n
	
	/*standard errors*/

  est res column_1
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
    est res column_2
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  	est res column_3
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  est res column_4
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[1,1])) ")"
  file write myfile "\\" _n
	
/*HDD*/
file write myfile "Heating Degree Days"
  
  
  est res column_1
  mat b = e(b)
  file write myfile " & " %4.2f (b[1,2])
  qui est r column_1
  matrix b = r(table)
	if b[4, 2]<=0.01 file write myfile "\$^{**}$"
   else if b[4,2]<=0.05 file write myfile "\$^{*}$"
  
  
  est res column_2
  mat b = e(b)
  file write myfile " & " %4.2f (b[1,2])
    qui est r column_2
   matrix b = r(table)
  if b[4, 2]<=0.01 file write myfile "\$^{**}$"
   else if b[4,2]<=0.05 file write myfile "\$^{*}$"
   
   est res column_3
  mat b = e(b)
  file write myfile " & " %4.2f (b[1,2])
  qui est r column_3
  matrix b = r(table)
    if b[2,3]<=0.01 file write myfile "\$^{**}$"
  else if b[2,3]<=0.05 file write myfile "\$^{*}$"
  
est res column_4
  mat b = e(b)
  file write myfile " & " %4.2f (b[1,2])
   qui est r column_4
  matrix b = r(table)
	if b[4, 2]<=0.01 file write myfile "\$^{**}$"
   else if b[4,2]<=0.05 file write myfile "\$^{*}$"
   
   
    file write myfile "\\" _n
  
  /*Standard Errors*/

   est res column_1
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[2,2])) ")"
   est res column_2
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[2,2])) ")"
  
    est res column_3
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[2,2])) ")"
  
  est res column_4
  mat b=e(V)
  file write myfile " & (" %4.2f (sqrt(b[2,2])) ")"
  
  
    file write myfile "\\" _n
	
/*Propensity Score weights*/
file write myfile "Propensity Score Weights?"

file write myfile " & N & Y & N & Y"
file write myfile "\\" _n

/*R Squared*/
file write myfile "R-squared"

  est res column_1
file write myfile " & " %4.2f (e(r2))
  est res column_2
file write myfile " & " %4.2f (e(r2))

est res column_3
file write myfile " & " %4.2f (e(r2))
  est res column_4
file write myfile " & " %4.2f (e(r2))
file write myfile "\\" _n

 
 
 /*Observations*/
 file write myfile "Observations"
 
 est res column_1
 file write myfile " & " %4.0f (e(N))
   est res column_2
file write myfile " & " %4.0f (e(N))
 est res column_3
file write myfile " & " %4.0f (e(N))
 est res column_4
file write myfile " & " %4.0f (e(N))
 file write myfile "\\" _n

 
 
 file write myfile "\vspace{.1pt} \\" _n 
  
file write myfile "\hline \\" _n ///
"\end{tabular*} }" _n  ///
  "\footnotesize Note: The table reports measured indoor temperature differentials across weatherized (WAP) and unweatherized" ///
"households. Columns (1) and (2) have the indoor thermometer temperature reading as a dependent variable while columns" /// 
" (3) and (4) use the survey thermostat readings." ///
" Columns (2) and (4) are weighted so that surveyed population better represents total quasi-experimental sample.  " ///
" Standard errors clustered at the household level. \\" ///
"$^{*}$ Significant at the 5 percent level \\" _n ///
"$^{**}$ Significant at the 1 percent level \\" _n
  file write myfile "\end{table}"

file close myfile
 log close
