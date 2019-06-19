#delimit;
clear;
set more off;

set mem 250m;

capture log close;
log using H:\logs\affiliate_data.log, replace;

/*================================================
 Program: affiliate_data.do
 Author:  Avi Ebenstein
 Created: June 2007
 Purpose: Collect annual data of affiliates to 
          track changing employment concentration 
          of multinational firms
=================================================*/

local yearlist "1982 1983 1984 1985 1986 1987 1988 1989 1990
                1991 1992 1993 1994 1995 1996 1997 1998 1999 2000
                2001 2002 2003";

foreach i of local yearlist{;
use H:\anndata\aff`i'.dta, clear;

***********************************;
* Drop the bad data 		     ;
***********************************;

drop if country==.|emp==.;

***********************************;
* For 2000+, the industry variable ;
* is stored in ind_naics           ;
***********************************;
capture gen industry=ind_naics;
keep year industry emp country assets sales;
save H:\anndata\t`i'.dta, replace;
};

****************;
* Pool the data ;
****************;

clear;
set obs 1;
gen a=1;
foreach i of local yearlist{;
append using H:\anndata\t`i'.dta;
};
drop if a==1;
drop a;

*****************************************************;
* Country names are labeled from the country numbers ;
*****************************************************;

rename country cnum;
do H:\dofiles\country_names;

*********************************************;
* SIC Codes are created from NAICS for 1999+ ;
*********************************************;

gen sic=industry;
gen naics=industry;
replace sic=. if year>=1999;
replace naics=. if year<=1998;
do H:\dofiles\naics_sic;

*********************************************;
* Assign country to an income category (UN)  ;
*********************************************;

do H:\dofiles\country_income;

sort country year;

/* Drop affiliates with missing country data */
count if cnum==.;
count if country==" ";
drop if country==" ";
/* Drop those without an explicit country (offshore drilling is 98%) */
drop if incgroup==.;

egen yearcat=cut(year),at(1982(3)2003);

gen isic7288=sic if year<=1988;
gen isic8998=sic if year>=1989;

gen man7090=.;
do H:\dofiles\isic7288_man7090.do;
do H:\dofiles\isic8998_man7090.do;

*************************************;
* Label the industries               ;
*************************************;

/* Drop small number of people who are unclassified or nonbusiness */
drop if sic==0|sic>=900;

gen agriculture=sic>=10 & sic<=99;
gen mining=sic>=101 & sic<=149;
gen construction=sic==150; 
gen manufacturing=sic>=200 & sic<=399;
gen transportation=sic>=401 & sic<=499;
gen wholesale=sic>=501 & sic<=519;
gen retail=sic>=530 & sic<=590;
gen finance=sic>=600 & sic<=699;
gen services=sic>=700 & sic<=897;
gen nonbusiness=sic>=900;

replace man7090=100 if agriculture==1;
replace man7090=101 if mining==1;
replace man7090=200 if manufacturing==1 & man7090==.;
replace man7090=700 if services==1;
replace man7090=150 if construction==1;
replace man7090=400 if transportation==1;
replace man7090=500 if wholesale==1;
replace man7090=530 if retail==1;
replace man7090=600 if finance==1;
replace man7090=700 if services==1;

*************************************;

save H:\datafiles\affiliate_data, replace;
