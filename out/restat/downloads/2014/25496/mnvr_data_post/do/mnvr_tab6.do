* We generate table 6 here. Columns 1-5 have OLS regressions with different country samples.
* Columns 7-8 instrument ICT with 1980 US ICT
* Columns 9-10 instrument ICT with routineness 

clear
cd ..\dta
set more off
use mnvr_fully_disaggregated_tables_dataset, clear
* generating table 6 cols 1-8
foreach var of varlist labhs labms{
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset, clear
areg diff24_`var'  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wt80], rob a (country)
cd ..\results
outreg2 using mnvr_tab6_`var', replace se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset, clear
areg diff24_`var'  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va lag24_labhs lag24_labms if sample==1 & year==2004 [aw=wt80], rob a (country)
cd ..\results
outreg2 using mnvr_tab6_`var', append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset, clear
areg diff24_`var'  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004& country~="USA"&country~="UK"&country~="JPN" [aw=wt80], rob a (country)
cd ..\results
outreg2 using mnvr_tab6_`var', append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset, clear
areg diff24_`var'  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va lag24_labhs lag24_labms if sample==1 & year==2004& country~="USA"&country~="UK"&country~="JPN" [aw=wt80], rob a (country)
cd ..\results
outreg2 using mnvr_tab6_`var', append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset, clear
areg diff24_`var'  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004& country=="USA" [aw=wt80], rob a (country)
cd ..\results
outreg2 using mnvr_tab6_`var', append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset, clear
areg diff24_`var'  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va lag24_labhs lag24_labms if sample==1 & year==2004& country=="USA" [aw=wt80], rob a (country)
cd ..\results
outreg2 using mnvr_tab6_`var', append se bdec(2) noaster
}
* cols 7 and 8 of table 4 instrument ICT with 1980 US value of ICT
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset, clear
* see mnvr_5 for creation of 1980 US ICT for each country
merge country ind year using mnvr_ict_va_inst,unique 
foreach var of varlist tcapit_over_va_inst{
gen diff24_`var' = `var'-`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
gen lag24_`var' =`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
}
xi i.country
save mnvr_tab6_intermediate,replace
reg diff24_tcapit_over_va lag24_tcapit_over_va_inst diff24_ln_va diff24_tcapnit_over_va _Icountry* if year==2004&sample==1 [aw=wt80], rob
cd ..\results
outreg2 using mnvr_tab6firststage, replace se bdec(6) sdec(6) noaster
cd ..\dta
use mnvr_tab6_intermediate, clear
* see mnvr_5 for creation of 1980 US ICT for each country
reg diff24_tcapit_over_va lag24_tcapit_over_va_inst diff24_ln_va diff24_tcapnit_over_va _Icountry* if year==2004&sample==1& country~="USA" [aw=wt80], rob
cd ..\results
outreg2 using mnvr_tab6firststage, append se bdec(6) sdec(6) noaster

foreach var of varlist labhs labms{
cd ..\dta
use mnvr_tab6_intermediate, clear
ivreg diff24_`var'  (diff24_tcapit_over_va=lag24_tcapit_over_va_inst) diff24_ln_va diff24_tcapnit_over_va _Icountry* if sample==1 & year==2004 [aw=wt80], rob
cd ..\results
outreg2 using mnvr_tab6_`var', append se bdec(2) noaster
cd ..\dta
use mnvr_tab6_intermediate, clear
ivreg diff24_`var'  (diff24_tcapit_over_va=lag24_tcapit_over_va_inst) diff24_ln_va diff24_tcapnit_over_va _Icountry* if sample==1 & year==2004& country~="USA" [aw=wt80], rob
cd ..\results
outreg2 using mnvr_tab6_`var', append se bdec(2) noaster
}

* see mnvr_6 for generation of routineness measure
cd ..\dta
use mnvr_routineness_inst,clear

*first stage tables for table 6 columns 9-10 
reg diff24_tcapit_over_va norm_lag24_tasks_routine diff24_ln_va diff24_tcapnit_over_va _Icou* if year==2004 & sample==1 [aw=wt80], rob
cd ..\results
outreg2 using mnvr_tab6firststage,append se bdec(6) sdec(6) noaster
cd ..\dta
use mnvr_routineness_inst,clear
reg diff24_tcapit_over_va norm_lag24_tasks_routine diff24_ln_va diff24_tcapnit_over_va _Icou* if year==2004 & sample==1& country~="USA" [aw=wt80], rob
cd ..\results
outreg2 using mnvr_tab6firststage,append se bdec(6) sdec(6) noaster

* table 6 columns 9-10
foreach var of varlist labhs labms{
cd ..\dta
use mnvr_routineness_inst,clear
ivreg diff24_`var'  (diff24_tcapit_over_va=norm_lag24_tasks_routine) diff24_ln_va diff24_tcapnit_over_va _Icountry* if sample==1 & year==2004 [aw=wt80], rob
cd ..\results
outreg2 using mnvr_tab6_`var', append se bdec(2) noaster
cd ..\dta
use mnvr_routineness_inst,clear
ivreg diff24_`var'  (diff24_tcapit_over_va=norm_lag24_tasks_routine) diff24_ln_va diff24_tcapnit_over_va _Icountry* if sample==1 & year==2004& country~="USA"  [aw=wt80], rob
cd ..\results
outreg2 using mnvr_tab6_`var', append se bdec(2) noaster
}

cd ..\dta
