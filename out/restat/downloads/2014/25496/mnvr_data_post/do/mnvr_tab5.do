* this do-file generates our standard ICT results for high, medium and low-skilled wagebill share.
clear
cd ..\dta

set mem 100m
set more off
* see mnvr_3 for the generation of the dataset used here
use mnvr_fully_disaggregated_tables_dataset,clear


foreach var of varlist labhs labms labls{
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
reg diff24_`var'  if sample==1 & year==2004 [aw=wt80], rob
cd ..\results
outreg2 using mnvr_tab5_`var',replace se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
reg diff24_`var'  diff24_tcapit_over_va if sample==1 & year==2004 [aw=wt80], rob
cd ..\results
outreg2 using mnvr_tab5_`var',append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
reg diff24_`var'  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wt80],rob
cd ..\results
outreg2 using mnvr_tab5_`var',append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_`var'  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wt80], rob a (country)
cd ..\results
outreg2 using mnvr_tab5_`var',append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
reg diff24_`var'  if sample==1 & year==2004 [aw=wtt80], rob
cd ..\results
outreg2 using mnvr_tab5_`var',append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
reg diff24_`var'  diff24_tcapit_over_va if sample==1 & year==2004 [aw=wtt80], rob
cd ..\results
outreg2 using mnvr_tab5_`var',append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
reg diff24_`var'  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wtt80],rob
cd ..\results
outreg2 using mnvr_tab5_`var',append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_`var'  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_tab5_`var',append se bdec(2) noaster
}
