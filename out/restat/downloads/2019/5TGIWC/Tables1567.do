
*****************************************************************
*  Replicates Tables 1, 5, 6, 7 in the paper                    *
*  GOVERNMENT INVOLVEMENT IN THE CORPORATE GOVERNANCE OF BANKS  *
*  Linus Siming 												*
*****************************************************************

use sectordata.dta, clear

*** Table 1, Estimate abnormal returns for the banking sector on March 19, 1976
sort sector_id trading_date 
gen pom=0
replace pom=1 if trading_date==5922
* Column 1
reg ln_return pom if (trading_date<=5922 & trading_date>=5552 & sector_id==5), robust
* Column 2
reg ln_return pom ln_market_return if (trading_date<=5922 & trading_date>=5552 & sector_id==5), robust

********************************************************************************************************
*** Table 5, Estimate abnormal returns for the banking sector on Januray 15 and February 11, 1976
* January 15
sort sector_id trading_date 
gen poj=0
replace poj=1 if trading_date==5858
* Column 1
reg ln_return poj if (trading_date<=5858 & trading_date>=5488 & sector_id==5), robust
* Column 2
reg ln_return poj ln_market_return if (trading_date<=5858 & trading_date>=5488 & sector_id==5), robust

* February 11
sort sector_id trading_date 
gen pof=0
replace pof=1 if trading_date==5885
* Column 1
reg ln_return pof if (trading_date<=5885 & trading_date>=5515 & sector_id==5), robust
* Column 2
reg ln_return pof ln_market_return if (trading_date<=5885 & trading_date>=5515 & sector_id==5), robust

********************************************************************************************************
***Table 6, Estimate abnormal returns for all sectors on March 19, 1976 
* Panel A
reg ln_return pom if (trading_date<=5922 & trading_date>=5552 & sector_id==1), robust
reg ln_return pom if (trading_date<=5922 & trading_date>=5552 & sector_id==2), robust
reg ln_return pom if (trading_date<=5922 & trading_date>=5552 & sector_id==3), robust
reg ln_return pom if (trading_date<=5922 & trading_date>=5552 & sector_id==4), robust
reg ln_return pom if (trading_date<=5922 & trading_date>=5552 & sector_id==5), robust

* Panel B
reg ln_return pom ln_market_return if (trading_date<=5922 & trading_date>=5552 & sector_id==1), robust
reg ln_return pom ln_market_return if (trading_date<=5922 & trading_date>=5552 & sector_id==2), robust
reg ln_return pom ln_market_return if (trading_date<=5922 & trading_date>=5552 & sector_id==3), robust
reg ln_return pom ln_market_return if (trading_date<=5922 & trading_date>=5552 & sector_id==4), robust
reg ln_return pom ln_market_return if (trading_date<=5922 & trading_date>=5552 & sector_id==5), robust

* Significance of differences in estimates between the banking sector and each other sector is calculated as: z=(B1-B2)/sqr(seB1^2+seB2^2)


********************************************************************************************************
***Table 7, Estimate abnormal returns for all non-banking sectors on March 19, 1976 
keep if sector_id==5
tsset trading_date 

* Generate daily currency returns
gen lnreturn_sek_dmark=ln(sek_dmark[_n]/sek_dmark[_n-1])
gen lnreturn_sek_franc=ln(sek_franc[_n]/sek_franc[_n-1])
gen lnreturn_sek_gbp=ln(sek_gbp[_n]/sek_gbp[_n-1])
gen lnreturn_sek_usd=ln(sek_usd[_n]/sek_usd[_n-1])

* Columns 1 to 5
reg ln_return pom lnreturn_sek_dmark if (trading_date<=5922 & trading_date>=5552), robust
reg ln_return pom lnreturn_sek_franc if (trading_date<=5922 & trading_date>=5552), robust
reg ln_return pom lnreturn_sek_gbp if (trading_date<=5922 & trading_date>=5552), robust
reg ln_return pom lnreturn_sek_usd if (trading_date<=5922 & trading_date>=5552), robust
reg ln_return pom lnreturn_sek_dmark lnreturn_sek_franc lnreturn_sek_gbp lnreturn_sek_usd if (trading_date<=5922 & trading_date>=5552), robust

* Columns 6 to 10
reg ln_return pom ln_market_return lnreturn_sek_dmark if (trading_date<=5922 & trading_date>=5552), robust
reg ln_return pom ln_market_return lnreturn_sek_franc if (trading_date<=5922 & trading_date>=5552), robust
reg ln_return pom ln_market_return lnreturn_sek_gbp if (trading_date<=5922 & trading_date>=5552), robust
reg ln_return pom ln_market_return lnreturn_sek_usd if (trading_date<=5922 & trading_date>=5552), robust
reg ln_return pom ln_market_return lnreturn_sek_dmark lnreturn_sek_franc lnreturn_sek_gbp lnreturn_sek_usd if (trading_date<=5922 & trading_date>=5552), robust

clear

********************************************************************************************************

