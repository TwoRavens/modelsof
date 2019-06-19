clear matrix
set more off

cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear

foreach var of varlist labhs labms{
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
reg diff24_`var' diff24_trade_world_over_va if year==2004 & sample==1 [aw=wtt80], rob
cd ..\results
outreg2 using mnvr_tab8_`var', replace se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_`var' diff24_trade_world_over_va if year==2004 & sample==1 [aw=wtt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab8_`var', append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_`var' diff24_trade_world_over_va diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if year==2004 & sample==1 [aw=wtt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab8_`var', append se bdec(2) noaster
}
cd ..\dta
use mnvr_anberd99_tables, clear
foreach var of varlist labhs labms{
cd ..\dta
use mnvr_anberd99_tables, clear
areg diff24_`var' diff24_trade_world_over_va diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if year==2004 & sample==1 [aw=wtt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab8_`var', append se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables, clear
areg diff24_`var' diff24_trade_world_over_va diff24_ln_va randd_over_va_1980 if year==2004 & sample==1 [aw=wtt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab8_`var', append se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables, clear
areg diff24_`var' diff24_trade_world_over_va diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980 if year==2004 & sample==1 [aw=wtt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab8_`var', append se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables, clear
areg diff24_`var' diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980 if year==2004 & sample==1 [aw=wtt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab8_`var', append se bdec(2) noaster
}
cd ..\dta
use mnvr_feenstra_hanson_offshoring,clear
set more off
foreach var of varlist labhs labms{
cd ..\dta
use mnvr_feenstra_hanson_offshoring,clear
areg diff24_`var' coefcheck diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va  if year==2004&sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab8_`var', append se bdec(2) noaster
}

*R&D-using countries

cd ..\dta
use mnvr_feenstra_hanson_rd_offshoring,clear
set more off
foreach var of varlist labhs labms{
cd ..\dta
use mnvr_feenstra_hanson_rd_offshoring,clear
areg diff24_`var' coefcheck diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if year==2004&sample==1 [aw=wtt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab8_`var', append se bdec(2) noaster
cd ..\dta
use mnvr_feenstra_hanson_rd_offshoring,clear
areg diff24_`var' coefcheck diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980  if year==2004&sample==1 [aw=wtt80], rob a(country)
cd ..\results
outreg2 using mnvr_tab8_`var', append se bdec(2) noaster
}

