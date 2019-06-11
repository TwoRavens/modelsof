* Master .do file for Who Profits from Patents? Rent-Sharing at Innovative Firms
* Owners: Patrick Kline, Neviana Petkova, Heidi Williams and Owen Zidar
* Date: January 29, 2019

clear all
set more off
cap log close





********************************************************************************
********************************* ENVIRONMENT **********************************
********************************************************************************

  * Set origin path
  global KPWZ_root 		 "/Users/ozidar/Downloads/KPWZ_replication"  
  global KPWZ_analysis   "$KPWZ_root/analysis"
  global KPWZ_process    "$KPWZ_analysis/2_process_output"

  * working directories
  global data 			 "$KPWZ_process/input"
  global code 			 "$KPWZ_process/code"
  global figures 		 "$KPWZ_process/output/figures"
  global tables 		 "$KPWZ_process/output/tables"
  
  * confidence interval
  gl ci = 1.96

  * value of T5 quint dose
  gl Q5 = 5.3


  * Install programs
  ssc install mat2txt
  ssc install distinct
  
  net install matrix_to_txt, from(https://raw.githubusercontent.com/gslab-econ/gslab_stata/master/gslab_misc/ado)
  
  
  
********************************************************************************
***************************** PRE-PROCESS INPUT ********************************
********************************************************************************

do "$code/process_input.do" 





********************************************************************************
*********************************** FIGURES ************************************
********************************************************************************

do "$code/figures/figure1.do"

do "$code/figures/figure2.do"

do "$code/figures/figure3.do"

do "$code/figures/figure4.do"

do "$code/figures/figure5.do"

do "$code/figures/figure6.do"

do "$code/figures/figure7.do"

do "$code/figures/figure8.do"

do "$code/figures/figure9.do"




********************************************************************************
*********************************** TABLES *************************************
********************************************************************************

do "$code/tables/table1.do"

do "$code/tables/table2.do"

do "$code/tables/table3.do"

do "$code/tables/table4.do"

do "$code/tables/table5.do"

do "$code/tables/table6.do"

do "$code/tables/table7.do"

do "$code/tables/table8.do"

do "$code/tables/table9.do"




********************************************************************************
***************************** APPX FIGURES *************************************
********************************************************************************

do "$code/figures/appx_figure1.do"

do "$code/figures/appx_figure2.do"

do "$code/figures/appx_figure3.do"




********************************************************************************
****************************** APPX TABLES *************************************
********************************************************************************

do "$code/tables/appx_table1.do"

do "$code/tables/appx_table2.do"

do "$code/tables/appx_table3.do"

do "$code/tables/appx_table4.do"

do "$code/tables/appx_table5.do"

do "$code/tables/appx_table6.do"

do "$code/tables/appx_table7.do"

do "$code/tables/appx_table8.do"

do "$code/tables/appx_table9.do"





