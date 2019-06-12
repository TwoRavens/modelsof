# delimit ;

drop _all;
clear;
set more off;
set matsize 11000;

* Citation: Rangel, M. A. and T. Vogl 
"Agricultural Fires and Health at Birth"
The Review of Economics and Statistics;

******************************************************************************
ABSTRACT

Do file employs fires and agricultural production, gdp per capita,
and job flows.

OFFICIAL SOURCES OF DATA:
INPE
IBGE
MTE 

WE PROVIDE DATA IN STATA FORMAT:
fires_sugarproduction_yearly.dta
fires_jobsflows_monthly.dta

******************************************************************************;

global data_repository "../RESTAT_data";
global logs_final "../RESTAT_logs";

************************************************************************
Table 1 - Association between fires and production/labor market flows
************************************************************************;
 
use "$data_repository/fires_sugarproduction_yearly.dta", clear;



foreach depvar in  sum_risks   {;

xi: reg  `depvar' , cluster(fe_munic);
outreg2 using "$logs_final/Table1_productionjobs_vs_fires.out", dec(6) noaster replace;

xi: areg  `depvar' Ish_harvested i.year, absorb(fe_munic) cluster(fe_munic);
outreg2 using "$logs_final/Table1_productionjobs_vs_fires.out", dec(6) noaster append;

xi: areg  `depvar' Ish_harvested sh_harvested2-sh_harvested7 i.year, absorb(fe_munic) cluster(fe_munic);
outreg2 using "$logs_final/Table1_productionjobs_vs_fires.out", dec(6) noaster append;

xi: areg  `depvar' Ish_harvested sh_harvested2-sh_harvested7 i.year if year<2013, absorb(fe_munic) cluster(fe_munic);
outreg2 using "$logs_final/Table1_productionjobs_vs_fires.out", dec(6) noaster append;

xi: areg  `depvar' Ish_harvested sh_harvested2-sh_harvested7 i.year gdp_pc if year<2013, absorb(fe_munic) cluster(fe_munic);
outreg2 using "$logs_final/Table1_productionjobs_vs_fires.out", dec(6) noaster append;

};


 
use "$data_repository/fires_jobsflows_monthly.dta", clear;


foreach depvar in dnr_risks_norm  {;

xi: reg  `depvar'   , cluster(fe_munic);
outreg2 using "$logs_final/Table1_productionjobs_vs_fires.out", dec(6) noaster replace;

xi: areg  `depvar'  entry  exit  , absorb(yearmonth) cluster(fe_munic);
outreg2 using "$logs_final/Table1_productionjobs_vs_fires.out", dec(6) noaster append;

xi: areg  `depvar'  mean_adm_wage mean_exit_wage  , absorb(yearmonth) cluster(fe_munic);
outreg2 using "$logs_final/Table1_productionjobs_vs_fires.out", dec(6) noaster append;

};
