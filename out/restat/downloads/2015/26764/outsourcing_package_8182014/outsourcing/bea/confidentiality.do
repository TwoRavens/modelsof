#delimit;
clear;
set more off;

set mem 250m;

capture log close;
log using H:\logs\confidentiality.log, replace;

/*================================================
 Program: confidentiality.do
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

gsort year sic -emp;
by year sic: gen rank=_n;
by year sic: egen totemp=sum(emp);
keep if rank<=3;
keep if year==2002;
table sic rank if sic>=200 & sic<=399 & rank==1, c(mean totemp);
table sic rank if sic>=200 & sic<=399, c(mean emp);

use H:\datafiles\affiliate_data, clear;
gen dummy=1;

*******************************************;
* Only affiliates in low income countries  ;
*******************************************;

drop if incgroup==.; /* reasons for missing: offshore drilling, etc*/
keep if incgroup>=1 & incgroup<=3;

gsort year sic -emp;
by year sic: gen rank=_n;
by year sic: egen totemp=sum(emp);
keep if rank<=3;
keep if year==2002;
table sic rank if sic>=200 & sic<=399 & rank==1, c(mean totemp);
table sic rank if sic>=200 & sic<=399, c(mean emp);
