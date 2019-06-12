log using second-stage-estimates

**** This code can be used to generate Table 1 
* "Second-stage estimates of ideological proximity on vote choice" in the article
* and Table 5 in the Online Appendix 

***The measures for corruption should be purchased from the PRG Group. 
*In this article, I used the monthy measures of corruption from Table 3b and 
*calculated the annual averages:
*forvalues i=1984/2016{
*gen corruption`i'= _01_`i'+_02_`i'+ _03_`i'+_04_`i'+ _05_`i' + _06_`i'+ ///
*_07_`i'+_08_`i'+ _09_`i'+_10_`i'+ _11_`i' + _12_`i'
*}
*drop Variable _01_1984 - _01_2017
*reshape long corruption, i(Country) j(year)
** These should be merged with the data. Make sure the variable is called corruption 

** The uploaded dataset DOES NOT include a variable for corruption!!!

use "clogit_coefficients.dta", clear

* Model 1 in Table 1
edvreg coef corruption gdp growth durable partyage pr pluralty mdmh p_effnv   p_maj  state east noneuro system, dvste(serror) 
estimates store full

* Model 2 in Table 1
edvreg coef_p corruption gdp growth durable partyage pr pluralty mdmh p_effnv  p_maj  state east noneuro system , dvste(serror_p) 
estimates store partisan

* Model 3 in Table 1
edvreg coef corruption gdp growth durable partyage pr pluralty mdmh p_effnv   p_maj  state east noneuro system  if coef>0 & coef<1 , dvste(serror) 
estimates store outliers

** Generate Table 1 
esttab full partisan outliers using  twostep.tex, replace b(3) se(3) scalars(ll r2) label

*** robustness checks (Table 3 - Online Appendix)
edvreg coef corruption  , dvste(serror) 
estimates store rob1

edvreg coef corruption gdp durable , dvste(serror) 
estimates store rob2

edvreg coef corruption gdp durable partyage pr pluralty mdmh p_effnv   , dvste(serror) 
estimates store rob3

edvreg coef corruption gdp durable  p_maj  state system, dvste(serror) 
estimates store rob4

edvreg coef corruption gdp growth durable partyage pr pluralty mdmh p_effnv   p_maj  state noneuro system if east==0, dvste(serror) 
estimates store rob5

esttab rob1 rob2 rob3 rob4 rob5 using  twostep_robust.tex, replace b(3) se(3) scalars(ll r2) label mtitles("Baseline" "GDP+Democracy" "Electoral Institutions" "Government Structure" "Political Institutions" "Economic Growth")

log close
