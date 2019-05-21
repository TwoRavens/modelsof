
* =================================
* Paper title: It's All About Political Incentives: Democracy and the Renewable Feed-In Tariff
* Authors: Patrick Bayer (Glasgow) and Johannes Urpelainen (Columbia) 
* Journal of Politics

* Last modified: November 7, 2015

* Data files used: FIT_data.dta (called through prep.do)
* System: Stata 13.1 on WIN 10

* Purpose: This do file replicates the main results of the paper
* =================================

*NB: Place all files in the same folder for paths to work properly

clear all
set more off, permanently

do "./prep.do"


* =================================
* 0. Set data up for survival analysis
* =================================

xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT


* =================================
* 2. Main model: Democracy and FIT adoption, 1990-2012 (Table 1, main paper)
* =================================

eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

/* esttab using "FIT_main.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/

* =================================
* 3. Main model: FIT adoption in democratic subsample (Table 2, main paper)
* =================================

eststo clear
eststo: xi: logit FIT malapp transition leftdummy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region if democracy==1, vce(cluster id)
eststo: xi: logit FIT malapp transition leftdummy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region if democracy==1, vce(cluster id)
eststo: xi: logit FIT malapp transition leftdummy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region if democracy==1, vce(cluster id) 

eststo: xi: logit FIT malapp politytransition leftdummy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region if polity > 6 & polity != ., vce(cluster id)
eststo: xi: logit FIT malapp politytransition leftdummy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region if polity > 6 & polity != ., vce(cluster id)
eststo: xi: logit FIT malapp politytransition leftdummy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region if polity > 6 & polity != ., vce(cluster id) 


/* esttab using "FIT_withindemo.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t t2 t3 _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(malapp transition politytransition leftdummy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/
