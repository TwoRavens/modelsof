
* =================================
* Paper title: It's All About Political Incentives: Democracy and the Renewable Feed-In Tariff
* Authors: Patrick Bayer (Glasgow) and Johannes Urpelainen (Columbia) 
* Journal of Politics

* Last modified: November 7, 2015

* Data files used: FIT_data.dta (called through prep.do)
* System: Stata 13.1 on WIN 10

* Purpose: This do file replicates the results for the cross-section analysis (Appendix A24)
* =================================

*NB: Place all files in the same folder for paths to work properly

clear all
set more off, permanently

quietly: do "./prep.do"

* Format data for survival analysis
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT


* Format data for cross-sectional analysis
collapse (first) region OECD EU (sum) FIT (mean) L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto, by(country) 

replace L1democracy=1 if L1democracy>=.5 & L1democracy!=.
replace L1democracy=0 if L1democracy<0.5 & L1democracy!=.

* Variable labeling
label variable L1democracy "Democracy dummy"
label variable L1polity "Polity IV"
label variable OECD "OECD member"
label variable EU "EU member"
label variable L1loggdppc "GDP per capita (log)"
label variable L1logpop "Population (log)"
label variable L1logland "Land area (log)"
label variable L1corruption "Corruption"
label variable L1logco2pc "CO2 emissions per capita (log)"
label variable L1fossilfuel "Fossil fuels in energy consumption"
label variable L1elecgen "Total electricity generation (log)"
label variable L1logtrade "Trade (log)"
label variable L1logfdi "FDI (log)"
label variable region "Region"
label variable FIT "FIT dummy"
label variable L1diffusion_norm "FIT diffusion"
label variable L1polcon3 "Political constraints"
label variable L1kyoto "Kyoto ratification"
label variable L1reform "Power sector reform"


*save "./FIT_crosssection.dta", replace

* Reestimate main model specification for cross-sectional data (Table A29)
eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU i.region, robust
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU i.region, robust
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi OECD EU i.region, robust

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU i.region, robust
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU i.region, robust
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi OECD EU i.region, robust 


/* esttab using "FIT_crosssection.tex", replace b(%9.2f) booktabs stats(N r2_p, labels("Observations" "Pseudo $ R^2$") fmt(0 3)) /// 
eqlabels(none) drop(_cons OECD EU _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Robust standard errors in parentheses." "All models include OECD and EU dummies as well as region fixed effects.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi)
*/ 
