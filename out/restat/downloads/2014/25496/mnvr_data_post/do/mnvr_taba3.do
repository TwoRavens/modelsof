* for appendix table 3
* We compare the coefficient on various components of trade (total trade/imports/exports for the world, OECD and nonOECD)
* for traded goods, with and without R&D

cd ..\dta
clear
set more off

use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_labhs diff24_trade_world_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,replace se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables,clear
areg diff24_labhs diff24_trade_world_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980 if sample==1 & year==2004  [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3, append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_labhs diff24_import_world_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables,clear
areg diff24_labhs diff24_import_world_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980 if sample==1 & year==2004  [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_labhs diff24_export_world_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables,clear
areg diff24_labhs diff24_export_world_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980 if sample==1 & year==2004  [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_labhs diff24_trade_oecd_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables,clear
areg diff24_labhs diff24_trade_oecd_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980 if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_labhs diff24_import_oecd_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables,clear
areg diff24_labhs diff24_import_oecd_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980 if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_labhs diff24_export_oecd_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables,clear
areg diff24_labhs diff24_export_oecd_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980 if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_labhs diff24_trade_nonoecd_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables,clear
areg diff24_labhs diff24_trade_nonoecd_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980 if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_labhs diff24_import_nonoecd_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables,clear
areg diff24_labhs diff24_import_nonoecd_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980 if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_labhs diff24_export_nonoecd_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables,clear
areg diff24_labhs diff24_export_nonoecd_over_va  diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980 if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba3,append se bdec(2) noaster



