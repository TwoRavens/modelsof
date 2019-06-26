*** Powers and Choi, 2012, JPR: Do file for FDI and business terrorism data analysis ***

set matsize 240
set mem 150m
set more off

use "F:\research, journal papers\FDI stocks and business terror\JPR\replication materials\data\FDI and terror_Whan, data2.dta", clear 

des 
sum 

* Table 1
** Model 1 
#delimit ;
gen terror = busterr + nonbusterr ;
xtreg ldlogstock terror log_gdp gdpchange openk logstock interstate 
intrastate polity2 coldwar if population>1000000 & oecd!=1, fe robust cluster(ccode) ;
** Model 2 
#delimit ;
xtreg ldlogstock busterr log_gdp gdpchange openk logstock interstate 
intrastate polity2 coldwar if population>1000000 & oecd!=1, fe robust cluster(ccode) ;
** Model 3 
#delimit ;
xtreg ldlogstock nonbusterr log_gdp gdpchange openk logstock interstate 
intrastate polity2 coldwar if population>1000000 & oecd!=1, fe robust cluster(ccode) ;
** Model 4 
#delimit ;
xtreg ldlogstock busterr nonbusterr log_gdp gdpchange openk logstock interstate 
intrastate polity2 coldwar if population>1000000 & oecd!=1, fe robust cluster(ccode) ;

* Table 2
** Model 1
#delimit ;
xtreg ldlogstock bus_casualties log_gdp gdpchange openk logstock interstate 
intrastate polity2 coldwar if population>1000000 & oecd!=1, fe robust cluster(ccode) ;
** Model 2
#delimit ;
xtreg ldlogstock other_casualties log_gdp gdpchange openk logstock interstate 
intrastate polity2 coldwar if population>1000000 & oecd!=1, fe robust cluster(ccode) ;
** Model 3
#delimit ;
xtreg ldlogstock bus_casualties other_casualties log_gdp gdpchange openk logstock 
interstate intrastate polity2 coldwar if population>1000000 & oecd!=1, fe robust cluster(ccode) ;

* Table 3
** Model 1
#delimit ;
xtreg ldlogstock busterr log_gdp gdpchange openk logstock interstate 
intrastate polity2 coldwar if population>1000000 & oecd!=1, re robust cluster(ccode) ;
** Model 2
#delimit ;
xtreg ldlogstock nonbusterr log_gdp gdpchange openk logstock interstate 
intrastate polity2 coldwar if population>1000000 & oecd!=1, re robust cluster(ccode) ;
** Model 3
#delimit ;
xtreg ldlogstock busterr nonbusterr log_gdp gdpchange openk logstock interstate 
intrastate polity2 coldwar if population>1000000 & oecd!=1, re robust cluster(ccode) ;
** Model 4
#delimit ;
xtgee ldlogstock busterr log_gdp gdpchange openk logstock interstate 
intrastate polity2 coldwar if population>1000000 & oecd!=1, family(gau) link(log) corr(ar1) force robust nolog ; 
** Model 5
#delimit ;
xtgee ldlogstock nonbusterr log_gdp gdpchange openk logstock interstate 
intrastate polity2 coldwar if population>1000000 & oecd!=1, family(gau) link(log) corr(ar1) force robust nolog ;
** Model 6
#delimit ;
xtgee ldlogstock busterr nonbusterr log_gdp gdpchange openk logstock interstate 
intrastate polity2 coldwar if population>1000000 & oecd!=1, family(gau) link(log) corr(ar1) force robust nolog ;





