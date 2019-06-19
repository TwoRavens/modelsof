* Appendix Table 4 has "back-of-the-envelope" calculations for the magnitude of ICT & R&D.
* We compare the coefficient on ICT and/or R&D in OLS regressions with and without controls (country FE, VA)
* We also look at the size of the coefficients with IV regressions (5-6)
*for table A4
cd ..\dta

set more off
use mnvr_fully_disaggregated_tables_dataset,clear
reg diff24_labhs diff24_tcapit_over_va if year==2004 & sample==1 [aw=wt80], rob
cd ..\results
outreg2 using mnvr_taba4, replace se bdec(2) noaster
cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
areg diff24_labhs diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va if year==2004 & sample==1 [aw=wt80], rob a(country)
cd ..\results
outreg2 using mnvr_taba4, append se bdec(2) noaster

cd ..\dta
use mnvr_anberd99_tables,clear
reg diff24_labhs diff24_tcapit_over_va randd_over_va_1980 if year==2004 & sample==1 [aw=wtt80], rob
cd ..\results
outreg2 using mnvr_taba4, append se bdec(2) noaster
cd ..\dta
use mnvr_anberd99_tables,clear
areg diff24_labhs diff24_tcapit_over_va diff24_ln_va diff24_tcapnit_over_va randd_over_va_1980 if sample==1 & year==2004 [aw=wtt80], rob a (country)
cd ..\results
outreg2 using mnvr_taba4, append se bdec(2) noaster

cd ..\dta
use mnvr_fully_disaggregated_tables_dataset,clear
merge country ind year using mnvr_ict_va_inst,unique
foreach var of varlist tcapit_over_va_inst{
gen diff24_`var' = `var'-`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
gen lag24_`var' =`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
}
xi i.country

save mnvr_taba4_intermediate, replace
reg diff24_tcapit_over_va lag24_tcapit_over_va_inst   if year==2004&sample==1 [aw=wt80], rob
cd ..\results
outreg2 using mnvr_taba4firststage, replace se bdec(4) noaster
cd ..\dta
use mnvr_taba4_intermediate,clear
ivreg diff24_labhs (diff24_tcapit_over_va=lag24_tcapit_over_va_inst)   if year==2004&sample==1 [aw=wt80], rob
cd ..\results
outreg2 using mnvr_taba4, append se bdec(2) noaster

cd ..\dta
use mnvr_taba4_intermediate,clear
reg diff24_tcapit_over_va lag24_tcapit_over_va_inst diff24_ln_va diff24_tcapnit_over_va _Icountry* if year==2004&sample==1 [aw=wt80], rob
cd ..\results
outreg2 using mnvr_taba4firststage, append se bdec(4) noaster
cd ..\dta
use mnvr_taba4_intermediate,clear
ivreg diff24_labhs (diff24_tcapit_over_va=lag24_tcapit_over_va_inst) diff24_ln_va diff24_tcapnit_over_va _Icountry* if year==2004&sample==1 [aw=wt80], rob
cd ..\results
outreg2 using mnvr_taba4, append se bdec(2) noaster

cd ..\dta
