

* =================================
* Paper title: It's All About Political Incentives: Democracy and the Renewable Feed-In Tariff
* Authors: Patrick Bayer (Glasgow) and Johannes Urpelainen (Columbia) 
* Journal of Politics

* Last modified: November 7, 2015

* Data files used: FIT_data.dta (called through prep.do)
* System: Stata 13.1 on WIN 10

* Purpose: This do file replicates the results for renewable energy contracts
* =================================

*NB: Place all files in the same folder for paths to work properly

clear all
set more off, permanently

do "./prep.do"

* =================================
* 0. Set data up for cross-sectional analysis
* =================================

collapse (first) iso3 region OECD EU (sum) FIT (mean) L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto, by(country) 


replace L1democracy=1 if L1democracy>=.5 & L1democracy!=.
replace L1democracy=0 if L1democracy<0.5 & L1democracy!=.

* =================================
* 1. Label variables
* =================================

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

* =================================
* 2. Code dependent variable of whether countries have competitive bidding (coded 1) or not (coded 0)
* Source: http://www.ren21.net/status-of-renewables/ren21-interactive-map/
* =================================

gen auction=0
replace auction=1 if iso3=="ALB"
replace auction=1 if iso3=="DZA"
replace auction=1 if iso3=="ARG"
replace auction=1 if iso3=="BEL"
replace auction=1 if iso3=="BIH"
replace auction=1 if iso3=="BRA"
replace auction=1 if iso3=="BFA"
replace auction=1 if iso3=="CAN"
replace auction=1 if iso3=="CPV"
replace auction=1 if iso3=="CHL"
replace auction=1 if iso3=="CHN"
replace auction=1 if iso3=="CRI"
replace auction=1 if iso3=="CYP"
replace auction=1 if iso3=="BRA"
replace auction=1 if iso3=="DNK"
replace auction=1 if iso3=="DOM"
replace auction=1 if iso3=="ECU"
replace auction=1 if iso3=="EGY"
replace auction=1 if iso3=="SLV"
replace auction=1 if iso3=="FRA"
replace auction=1 if iso3=="GTM"
replace auction=1 if iso3=="HND"
replace auction=1 if iso3=="IND"
replace auction=1 if iso3=="IDN"
replace auction=1 if iso3=="IRL"
replace auction=1 if iso3=="ISR"
replace auction=1 if iso3=="ITA"
replace auction=1 if iso3=="JAM"
replace auction=1 if iso3=="JPN"
replace auction=1 if iso3=="JOR"
replace auction=1 if iso3=="KEN"
replace auction=1 if iso3=="LVA"
replace auction=1 if iso3=="LSO"
replace auction=1 if iso3=="MYS"
replace auction=1 if iso3=="MUS"
replace auction=1 if iso3=="MDV"
replace auction=1 if iso3=="MEX"
replace auction=1 if iso3=="MNG"
replace auction=1 if iso3=="MAR"
replace auction=1 if iso3=="NPL"
replace auction=1 if iso3=="OMN"
replace auction=1 if iso3=="PAN"
replace auction=1 if iso3=="PER"
replace auction=1 if iso3=="PHL"
replace auction=1 if iso3=="POL"
replace auction=1 if iso3=="PRT"
replace auction=1 if iso3=="SGP"
replace auction=1 if iso3=="SVN"
replace auction=1 if iso3=="ZAF"
replace auction=1 if iso3=="SYR"
replace auction=1 if iso3=="GBR"
replace auction=1 if iso3=="USA"
replace auction=1 if iso3=="URY"
replace auction=1 if iso3=="UZB"



* =================================
* 3. Democracy and renewable energy contracts (Appendix A4, Table A3)
* =================================

eststo clear
eststo: xi: logit auction L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU i.region, robust
eststo: xi: logit auction L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU i.region, robust
eststo: xi: logit auction L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi OECD EU L1kyoto i.region, robust

eststo: xi: logit auction L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU i.region, robust
eststo: xi: logit auction L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU i.region, robust
eststo: xi: logit auction L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi OECD EU L1kyoto i.region, robust 


/* esttab using "FIT_auction.tex", replace b(%9.2f) booktabs stats(N r2_p, labels("Observations" "Pseudo $ R^2$") fmt(0 3)) /// 
eqlabels(none) drop(_cons OECD EU _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: Auction dummy." "Robust standard errors in parentheses." "All models include OECD and EU dummies as well as region fixed effects.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/
