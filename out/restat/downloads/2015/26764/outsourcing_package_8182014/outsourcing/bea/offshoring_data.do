#delimit;
clear;
set more off;

set mem 250m;

capture log close;
log using H:\logs\offshoring_data.log, replace;

/*================================================
 Program: offshoring_data.do
 Author:  Avi Ebenstein
 Created: June 2007
 Purpose: Create data set by Year X SIC for high 
          and low income country affiliate employment
=================================================*/

use H:\datafiles\affiliate_data, clear;
gen dummy=1;

********************************************;
* Only affiliates in high income countries  ;
********************************************;

drop if incgroup==.; /* reasons for missing: offshore drilling, etc*/
keep if incgroup==4;
bysort year sic: egen largest=max(emp);
gen biggest=emp*(emp==largest);
collapse (sum) totemp=emp (sum) firms=dummy (max) biggest (sum) assets (sum) sales, by(year sic);
label data "BEA affiliate employment by Year X SIC in high income countries";
save H:\datafiles\offshoring_sic_high, replace;

*================================================;

use H:\datafiles\affiliate_data, clear;
gen dummy=1;

*******************************************;
* Only affiliates in low income countries  ;
*******************************************;

drop if incgroup==.; /* reasons for missing: offshore drilling, etc*/
keep if incgroup==1|incgroup==2|incgroup==3;
bysort year sic: egen largest=max(emp);
gen biggest=emp*(emp==largest);

collapse (sum) totemp=emp (sum) firms=dummy (max) biggest (sum) assets (sum) sales, by(year sic);
label data "BEA affiliate employment by Year X SIC in low income countries";
save H:\datafiles\offshoring_sic_low, replace;

