#delimit;
clear;
set more off;

set mem 250m;

capture log close;
log using H:\logs\offshoring_tables.log, replace;

/*================================================
 Program: offshoring_tables.do
 Author:  Avi Ebenstein
 Created: June 2007
 Purpose: Make some tables
=================================================*/

use H:\datafiles\affiliate_data, clear;
gen dummy=1;

***********************************************;
* 1. Only affiliates in high income countries  ;
***********************************************;

drop if incgroup==.; /* reasons for missing: offshore drilling, etc*/
keep if incgroup==4;
bysort year sic: egen largest=max(emp);
gen biggest=emp*(emp==largest);
collapse (sum) totemp=emp (sum) firms=dummy (max) biggest, by(year sic);
set linesize 200;
table sic year if sic>=200 & sic<=399, c(mean totemp) f(%9.0fc) replace;

*******************************************;

use H:\datafiles\affiliate_data, clear;
gen dummy=1;

**********************************************;
* 2. Only affiliates in low income countries  ;
**********************************************;

drop if incgroup==.; /* reasons for missing: offshore drilling, etc*/
keep if incgroup==1|incgroup==2|incgroup==3;
bysort year sic: egen largest=max(emp);
gen biggest=emp*(emp==largest);

collapse (sum) totemp=emp (sum) firms=dummy (max) biggest, by(year sic);
set linesize 200;
table sic year if sic>=200 & sic<=399, c(mean totemp) f(%9.0fc) replace;

*=============================;
* Graphs of Employment Trends ;
*=============================;

********************;
* 1. All Industries ;
********************;

use H:\datafiles\affiliate_data, clear;
keep if sic>=0 & sic<=1000;
gen high=incgroup==4;
collapse (sum) totemp=emp, by(year high) fast;
reshape wide totemp, i(year) j(high);

label var totemp0 "Low Income Countries";
label var totemp1 "High Income Countries";
format totemp* %9.0fc;

replace totemp0=totemp0/1000;
replace totemp1=totemp1/1000;

line totemp* year, xlabel(1982(3)2003) xtitle(" ") ytitle("Employment (000s)" " ")
title("US Multi-national Empolyment Abroad") 
subtitle("All Sectors 1982-2003")
note("Source: Bureau of Economic Analysis")
lpattern(solid longdash)
saving(H:\graphs\graph1,replace); 

***********************;
* 2. Manufaturing Only ;
***********************;

use H:\datafiles\affiliate_data, clear;
keep if sic>=200 & sic<=399;
gen high=incgroup==4;
collapse (sum) totemp=emp, by(year high) fast;
reshape wide totemp, i(year) j(high);

label var totemp0 "Low Income Countries";
label var totemp1 "High Income Countries";
format totemp* %9.0fc;

replace totemp0=totemp0/1000;
replace totemp1=totemp1/1000;

line totemp* year, xlabel(1982(3)2003) xtitle(" ") ytitle("Employment (000s)" " ")
title("US Multi-national Empolyment Abroad") 
subtitle("Manufacturing 1982-2003")
note("Source: Bureau of Economic Analysis")
lpattern(solid longdash)
saving(H:\graphs\graph2,replace); 

**********************************;
* 3. Employment trends by country ;
**********************************;

use H:\datafiles\affiliate_data, clear;
keep if sic>=200 & sic<=399;
replace emp=emp/1000;
table year country if country=="China"|country=="Mexico"|country=="Canada"|country=="Germany",c(sum emp) name(emp) f(%9.0fc) replace;
reshape wide emp1, i(year) j(country) string;	
rename emp1Canada Canada;
rename emp1China China;
rename emp1Germany Germany;
rename emp1Mexico Mexico;

label var Canada "Canada";
label var China "China";
label var Germany "Germany";
label var Mexico "Mexico";

line Mexico China Canada Germany year, xlabel(1982(3)2003) xtitle(" ") ytitle("Employment (000s)" " ")
title("US Multi-national Empolyment Abroad") 
subtitle("Manufacturing 1982-2003")
note("Source: Bureau of Economic Analysis")
lpattern(solid solid longdash longdash) legend(rows(1))
saving(H:\graphs\graph3,replace); 

*************************************;

exit;
