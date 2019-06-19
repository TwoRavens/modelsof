#delimit;
clear;
set more off;

set mem 250m;

capture log close;
log using H:\logs\offshoring_man7090.log, replace;

/*================================================
 Program: offshoring_data_man7090.do
 Author:  Avi Ebenstein
 Created: June 2007
 Purpose: Create data set by Year X man7090 for overall, high 
          and low income country affiliate employment
=================================================*/

use H:\datafiles\affiliate_data, clear;
gen dummy=1;

gen lowinc=incgroup~=4;
gen highinc=incgroup==4;
bysort year man7090: egen lowincemp=sum(emp*lowinc);
bysort year man7090: egen highincemp=sum(emp*highinc);

collapse (sum) totemp=emp (sum) firms=dummy (sum) assets (sum) sales (mean) lowincemp (mean) highincemp, by(year man7090) fast;
label data "BEA affiliate employment by Year X man7090";
gen lowincshare=lowincemp/totemp;
gen highincshare=highincemp/totemp;

label var totemp "Total employment";
label var firms "Number of firms";
label var assets "Total assets";
label var sales "Sales";
label var lowincemp "Total employment in low income countries";
label var highincemp "Total employment in high income countries";
label var lowincshare "Total employment share in low income countries";
label var highincshare "Total employment share in high income countries";
note man7090: The switchover to NAICS in 1999 results in a loss of info for 53 & 68;

save H:\datafiles\offshoring_man7090, replace;

ex;

*================================================;
