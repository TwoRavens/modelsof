#delimit;
clear;
set more off;
set matsize 800;

global temp /Sastemp;
global path ~/research;
set mem 5000m;

capture log close;
*log using $path/outsourcing/logs/cew_data.log, replace;

/*================================================
 Program: bea_data.do
 Author:  Avi Ebenstein
 Created: March 2008
 Purpose: Take in the bea data and just keep china/india
=================================================*/

******************************************************************;
* Take data from 1975-2000, and convert from SIC 72/87 -> man7090 ;
******************************************************************;

use $path/outsourcing/bea/offshoring_man7090_country;
keep if country=="China"|country=="India";
keep year country man7090 totemp;
reshape wide totemp, i(year man7090) j(country) string;
sort man7090 year;
save $path/outsourcing/bea/china_india_man7090, replace;
