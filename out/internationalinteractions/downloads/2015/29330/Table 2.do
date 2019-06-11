**********************************************************
** Title: "Trade and Welfare Compensation: The Missing Links"      **  
** Authors: Eunyoung Ha, Dong-wook Lee, and Puspa Amri            **
** Interactional Interactions Replication                                    **
**********************************************************

clear all
set more off
cd "C:\Users\leed12\Desktop"
use "data_link2.dta"

/*CODEBOOK-------------------------------------------------------------------------------------------
variable name         variable label
-----------------------------------------------------------------------------------------------------
year                  YEAR
id                    ISSP survey countries in 1995 and 2003
country               Country
compen_pmp_avg        country's expenditure on unemployment compensation (% GDP) - previous 5yr avg.
protrade              public support for free trade (country-level % of total survey respondents)
trade_open_avg        The sum of imports and exports as % of GDP - previous 5 yr avg.
imduty_avg            tariff rates (% of Total Tax Revenue)
-----------------------------------------------------------------------------------------------------*/

**************************************************************************
* Table 2 :  The Impact of the Public Support for Free Trade on Trade Openness       **
*************************************************************************

* Dependent Variables:
*(1) Tariff Rates (the sum of customs and import duties as % of Total Tax Revenue) - previous 5 yr average (1991-1995, 1999-2002)
* (2) Trade Openness (the sum of imports and exports as % of GDP) - previous 5 yr average (1991-1995, 1999-2002)

/*Display pairwise correlation coefficeints*/
pwcorr protrade imduty_avg, sig star(.05)
pwcorr protrade trade_open_avg, sig star(.05)

/*Model for Trade Openness*/
reg trade_open_avg protrade

* Tests for heteroscedasticity
estat hettest
*findit whitetst (pkg downloadable at http://fmwww.bc.edu/RePEc/bocode/w)
whitetst
* Tests for Nomality of Residuals 
predict res, resid
swilk res
* findit jb6 (pkg downloadable at http://fmwww.bc.edu/RePEc/bocode/j)
jb6 res

/* Model for Tariff Rates*/
reg imduty_avg protrade
estat hettest
whitetst
* Tests for Nomality of Residuals 
predict res2, resid
swilk res2
jb6 res2
