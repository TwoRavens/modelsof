log using probit-models-of-vote-for-the-incumbent

**** This code can be used to generate Table 2 
* "Probit models of vote for the incumbent" in the article
* and Tables 3 and 4 in the Online Appendix 

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

** The dataset DOES NOT include a variable for corruption!!!

use "recoded_CSES_data.dta", clear
 
global controls age male income loweducation higheducation unemployed retired other partisan
global macros growth gdp durable partyage pr pluralty mdmh p_effnv  p_maj state   east noneuro  system

global controls2 age male income loweducation higheducation unemployed retired other strengthpartisan
global macros2 gdp durable partyage pr pluralty mdmh p_effnv  p_maj  state east noneuro  system


*** Model 4 in Table 2

gen ideolcor=ideolprime*corruption

label var ideolcor "Corruption x Ideol prox"
	
bootstrap, clu(code study_id) rep(100): cmp (governmentvote = corruption ideolcor ideolprime $controls $macros growth), ind(4) nolr qui

estimates store simple
estimates save simple, replace


*** Model 5 in Table 2
gen interaction=ideoldifference*ideolprime

label var interaction "Perc accuracy * Ideol proximity"

bootstrap, clu(code study_id) rep(100): cmp (governmentvote = corruption ideolcor ideolprime  ideoldifference interaction $controls $macros) (ideoldifference =  corruption $controls2 $macros2) , ind(4 1) nolr qui  iter(100)

estimates store sem1
estimates save sem1, replace


*** Model 6 in Table 2

gen interaction3=externalef*ideolprime 

label var interaction3 "Pol Efficacy * Ideol proximity"


bootstrap, clu(code study_id) rep(100):   cmp (governmentvote = corruption ideolcor ideolprime  externalef interaction3 $controls $macros) (externalef= corruption  $controls2  $macros2), ind(4 1) nolr qui   iter(100)
estimates store sem2
estimates save sem2, replace

***Create Table 2 in article and Table 5 in Online Appendix

esttab simple sem1 sem2  using simmmodels.tex, replace b(3) se(3) scalars(ll) label unstack 
esttab simple sem1 sem2 using simmmodels.tex, replace b(3) se(3) scalars(ll) label unstack keep(corruption ideolcor ideolprime interaction ideoldifference interaction3 externalef)


log close
