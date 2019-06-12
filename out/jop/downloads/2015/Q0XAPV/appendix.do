
* =================================
* Paper title: It's All About Political Incentives: Democracy and the Renewable Feed-In Tariff
* Authors: Patrick Bayer (Glasgow) and Johannes Urpelainen (Columbia) 
* Journal of Politics

* Last modified: November 7, 2015

* Data files used: FIT_data.dta (called through prep.do)
* System: Stata 13.1 on WIN 10

* Purpose: This do file replicates the results presented in the appendix of the paper
* =================================

*NB: Place all files in the same folder for paths to work properly

clear all
set more off, permanently

quietly: do "./prep.do"


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
* Appendix A5: Summary statistics (Table A4)
* =================================

xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 
estpost summarize FIT L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU if e(sample)
/*esttab using "summarystats.tex", replace nonum cells("count mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))") noobs label booktabs
eststo clear (Table A3)
*/

* =================================
* Appendix A12: Shallowness of FIT policies (Tables A10 and A11)
* =================================

clear all
set more off, permanently

quietly: do "prep.do"

* Recode countries with inactive FITs
replace FIT=0 if country=="Algeria" & year >= 1990
replace FIT=0 if country=="Nicaragua" & year >= 1990
replace FIT=0 if country=="Syrian Arab Republic" & year>=1990

* Create survival data
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT

* Replicate main model after recoding (Table A10)
eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 


/* esttab using "FIT_shallow_woinactive.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/

* =================================
* Reload data because of recoding above!
* =================================

clear all
set more off, permanently

quietly: do "prep.do"

* Create survival data
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT


* Replicate main model when excluding low income countries from sample (Table A11)
eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region if lowincome==0, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region if lowincome==0, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region if lowincome==0, vce(cluster id) 

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region if lowincome==0, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region if lowincome==0, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region if lowincome==0, vce(cluster id) 

/* esttab using "FIT_shallow_wolowincome.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/



* =================================
* Appendix A14: Additional countries with FIT policies (Table A14)
* =================================

clear all
set more off, permanently

quietly: do "prep.do"

* Add five new FIT countries
replace FIT=1 if country=="Costa Rica" & year==2011
replace FIT=1 if country=="Mauritius" & year==2010
replace FIT=1 if country=="Panama" & year==2011
replace FIT=1 if country=="Peru" & year==2010
replace FIT=1 if country=="Uruguay" & year==2010

* Format data for survival analysis
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT

* Reestimate main models with six additional FIT adopters (Table A14)
eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 


/* esttab using "FIT_extraFITcountries.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/



* =================================
* Appendix A15: Country sensitivity (Tables A15 and A16)
* =================================

clear all
set more off, permanently

quietly: do "prep.do"

* Format data for survival analysis
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT

* Reestimate main models without Western Europe countries (UN classification) (Table A15)
eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region if WEU==0, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region if WEU==0, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region if WEU==0, vce(cluster id) 

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region if WEU==0, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region if WEU==0, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region if WEU==0, vce(cluster id) 


/* esttab using "FIT_woWesternEU.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/


* Reestimate main models when excluding OECD countries (Table A16)
eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region if OECD==0, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region if OECD==0, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region if OECD==0, vce(cluster id) 

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region if OECD==0, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region if OECD==0, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region if OECD==0, vce(cluster id) 


/* esttab using "FIT_nonOECD.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/


* =================================
* Appendix A16: Additional model specifications (Tables A17 and A18)
* =================================

clear all
set more off, permanently

quietly: do "prep.do"

* Format data for survival analysis
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT

* Reestimate main models with additional control variables (Table A17)
eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1elecloss L1cdm L1loghydrogen L1lognonhydrogen OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1elecloss L1cdm L1loghydrogen L1lognonhydrogen L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1elecloss L1cdm L1loghydrogen L1lognonhydrogen L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1elecloss L1cdm L1loghydrogen L1lognonhydrogen OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1elecloss L1cdm L1loghydrogen L1lognonhydrogen L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1elecloss L1cdm L1loghydrogen L1lognonhydrogen L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 


/* esttab using "FIT_supermodel.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1elecloss L1cdm L1loghydrogen L1lognonhydrogen L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/


* Reestimate main models without countries that dismantled FIT policy at some point (Table A18)
eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region if iso3!="BRA" & iso3!="ZAF" & iso3!="KOR" & iso3!="ITA" & iso3!="DEN", vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region if iso3!="BRA" & iso3!="ZAF" & iso3!="KOR" & iso3!="ITA" & iso3!="DEN", vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region if iso3!="BRA" & iso3!="ZAF" & iso3!="KOR" & iso3!="ITA" & iso3!="DEN", vce(cluster id) 

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region if iso3!="BRA" & iso3!="ZAF" & iso3!="KOR" & iso3!="ITA" & iso3!="DEN", vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region if iso3!="BRA" & iso3!="ZAF" & iso3!="KOR" & iso3!="ITA" & iso3!="DEN", vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region if iso3!="BRA" & iso3!="ZAF" & iso3!="KOR" & iso3!="ITA" & iso3!="DEN", vce(cluster id) 

/* esttab using "FIT_wodismantle_strict.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/



* =================================
* Appendix A17: Regime durability (Tables A19 and A20)
* =================================

clear all
set more off, permanently

quietly: do "prep.do"

* Format data for survival analysis
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT


* Create new regime stability variable and respective labels
gen L1stability = L1.durable
gen inter = L1stability * L1democracy
gen inter2 = L1stability * L1polity

label variable L1stability "Regime stability (t-1)"
label variable inter "Regime stability x Democracy dummy"
label variable inter2 "Regime stability x Polity IV"

* Reestimate main models with included stability variable (non-log) (Table A19)
eststo clear
eststo: xi: logit FIT L1democracy L1stability inter L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1stability inter L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1stability inter L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

eststo: xi: logit FIT L1polity L1stability inter2 L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1stability inter2 L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1stability inter2 L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

/* esttab using "FIT_stability_nonlog.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1stability inter inter2 L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/


* Create new regime stability variable (log) and respective labels
gen L1logstability = log(L1.durable+0.001)
drop inter*
gen inter = L1logstability * L1democracy
gen inter2 = L1logstability * L1polity

label variable L1logstability "Regime stability (log, t-1)"
label variable inter "Regime stability x Democracy dummy"
label variable inter2 "Regime stability x Polity IV"

* Reestimate main models with included logged stability variable (Table A20)
eststo clear
eststo: xi: logit FIT L1democracy L1logstability inter L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1logstability inter L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1logstability inter L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

eststo: xi: logit FIT L1polity L1logstability inter2 L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1logstability inter2 L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1logstability inter2 L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

/* esttab using "FIT_stability_log.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1logstability inter inter2 L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/


* =================================
* Appendix A18: Environmental preferences (Tables A21 and A22)
* =================================

clear all
set more off, permanently

quietly: do "prep.do"

* Format data for survival analysis
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT


* Reestimate main models with environmental preferences measure from WVS (Table A21)
* NB: WVS questions are reversed, so that higher values indicate higher environmental preferences
eststo clear
eststo: xi: logit FIT L1democracy L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

eststo: xi: logit FIT L1polity L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

/* esttab using "FIT_envpref.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/


* Multiple imputation models (Table A22)
* NB: Following King et al. 2001 APSR, all variables from analysis model are used in imputation model

mi set wide
mi xtset id year
mi register imputed L1envpref
mi stset, clear

* Main model with MI
eststo clear

* Model 1
xi: mi impute reg L1envpref FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, add(10) rseed(1234) force

mi query
local M = r(M)
scalar pseudo=0
xi: mi xeq 1/`M': logit FIT L1democracy L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id) ; scalar pseudo = pseudo + e(r2_p)
scalar pseudo = pseudo/`M'

eststo: xi: mi estimate, post: logit FIT L1democracy L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
estadd scalar pseudo

*Model 2
xi: mi impute reg L1envpref FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, replace rseed(1234) force

mi query
local M = r(M)
scalar pseudo=0
xi: mi xeq 1/`M': logit FIT L1democracy L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id) ; scalar pseudo = pseudo + e(r2_p)
scalar pseudo = pseudo/`M'

eststo: xi: mi estimate, post: logit FIT L1democracy L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
estadd scalar pseudo

* Model 3
xi: mi impute reg L1envpref FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, replace rseed(1234) force

mi query
local M = r(M)
scalar pseudo=0
xi: mi xeq 1/`M': logit FIT L1democracy L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) ; scalar pseudo = pseudo + e(r2_p)
scalar pseudo = pseudo/`M'

eststo: xi: mi estimate, post: logit FIT L1democracy L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 
estadd scalar pseudo


* Model 4
xi: mi impute reg L1envpref FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, replace rseed(1234) force

mi query
local M = r(M)
scalar pseudo=0
xi: mi xeq 1/`M': logit FIT L1polity L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id) ; scalar pseudo = pseudo + e(r2_p)
scalar pseudo = pseudo/`M'

eststo: xi: mi estimate, post: logit FIT L1polity L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
estadd scalar pseudo


* Model 5
xi: mi impute reg L1envpref FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, replace rseed(1234) force

mi query
local M = r(M)
scalar pseudo=0
xi: mi xeq 1/`M': logit FIT L1polity L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id) ; scalar pseudo = pseudo + e(r2_p)
scalar pseudo = pseudo/`M'

eststo: xi: mi estimate, post: logit FIT L1polity L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
estadd scalar pseudo


* Model 6
xi: mi impute reg L1envpref FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, replace rseed(1234) force

mi query
local M = r(M)
scalar pseudo=0
xi: mi xeq 1/`M': logit FIT L1polity L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) ; scalar pseudo = pseudo + e(r2_p)
scalar pseudo = pseudo/`M'

eststo: xi: mi estimate, post: logit FIT L1polity L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 
estadd scalar pseudo

/*esttab using "FIT_envpref_MI.tex", replace b(%9.2f) booktabs stats(N N_clust pseudo, labels("Observations" "Countries" "Averaged Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*)  noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)


* Get averaged pseudo R2 from all 10 imputed models
mi query
local M = r(M)
scalar r2=0
xi: mi xeq 1/`M': logit FIT L1democracy L1envpref L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id) ; scalar r2 = r2 + e(r2_p)
scalar r2 = r2/`M'
*/


* =================================
* Appendix A19: Random effects model
* =================================

clear all
set more off, permanently

quietly: do "prep.do"

* Format data for survival analysis
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT


* Reestimate main models with random effects (Table A23)
eststo clear
eststo: xi: xtlogit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: xtlogit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: xtlogit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

eststo: xi: xtlogit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: xtlogit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: xtlogit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 


/* esttab using "FIT_mainRE.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/



* =================================
* Appendix A20: Temporal dependence (Tables A24 and A25)
* =================================

clear all
set more off, permanently

quietly: do "prep.do"

* Format data for survival analysis
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT


* Reestimate main models with year fixed FEs (Table A24)
eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU i.region i.year, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU i.region i.year, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU i.region i.year, vce(cluster id) 

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU i.region i.year, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU i.region i.year, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU i.region i.year, vce(cluster id) 


/* esttab using "FIT_yearFE.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU _Iregion_* _Iyear_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies as well as region and year fixed effects.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/


* Create spline (cubic spline)
mkspline k=t, cubic knots(0 5 10 16 22) displayknots

* Reestimate main models with cubic spline (Table A25)
eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 k* i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 k* i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 k* i.region, vce(cluster id) 

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 k* i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 k* i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 k* i.region, vce(cluster id) 


/* esttab using "FIT_cubicspline.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU k* t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/


* =================================
* Appendix A21: Region-specific temporal dependence 
* =================================

clear all
set more off, permanently

quietly: do "prep.do"

* Format data for survival analysis
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT


* Create region specific time trends
tab region,gen(dregion)

gen int1 = t*dregion2
gen int2 = t*dregion3
gen int3 = t*dregion4
gen int4 = t*dregion5

gen int5 = t2*dregion2
gen int6 = t2*dregion3
gen int7 = t2*dregion4
gen int8 = t2*dregion5

gen int9 = t3*dregion2
gen int10 = t3*dregion3
gen int11 = t3*dregion4
gen int12 = t3*dregion5

* Reestimate main models with region-specific time trends (Table A26)
eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region int1-int12, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region int1-int12, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region int1-int12, vce(cluster id) 

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region int1-int12, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region int1-int12, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region int1-int12, vce(cluster id) 


/* esttab using "FIT_timeXregion.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_* int*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, a cubic time polynomial, and their interactions.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/


* LR tests of this region-specific time trend models with main models
* Model 1
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
estimates store m1
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region int1-int12, vce(cluster id)
estimates store m2
lrtest m1 m2, force

* Model 2
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
estimates store m1
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region int1-int12, vce(cluster id)
estimates store m2
lrtest m1 m2, force

* Model 3
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 
estimates store m1
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region int1-int12, vce(cluster id) 
estimates store m2
lrtest m1 m2, force

* Model 4
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
estimates store m1
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region int1-int12, vce(cluster id)
estimates store m2
lrtest m1 m2, force

*Model 5
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
estimates store m1
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region int1-int12, vce(cluster id)
estimates store m2
lrtest m1 m2, force

* Model 6
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 
estimates store m1
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region int1-int12, vce(cluster id) 
estimates store m2
lrtest m1 m2, force


* =================================
* Appendix A22: Spatial lag models 
* =================================

clear all
set more off, permanently

quietly: do "prep.do"

* Format data for survival analysis
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT


* Recode spatial lag variable
replace L1spatialFIT=. if year==1990
gen L1spatialFIT_norm = L1spatialFIT/1000
label variable L1spatialFIT_norm "Spatial lag coefficient (t-1)"

* Reestimate main models with spatial lag variable (Table A27)
eststo clear
eststo: xi: logit FIT L1democracy L1spatialFIT_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1spatialFIT_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1democracy L1spatialFIT_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

eststo: xi: logit FIT L1polity L1spatialFIT_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1spatialFIT_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region, vce(cluster id)
eststo: xi: logit FIT L1polity L1spatialFIT_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region, vce(cluster id) 

/* esttab using "FIT_spatial.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1spatialFIT_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/


* =================================
* Appendix A23: Subnational FIT policies 
* =================================

clear all
set more off, permanently

quietly: do "prep.do"

* Format data for survival analysis
xtset id year
gen L1FIT = L1.FIT

replace FIT=1 if L1.FIT==1
drop if FIT==1 & L1.FIT==1

drop if year < 1990
drop if FIT == .
drop L1FIT

* Create indicator variable for countries with subnational FIT policies
gen subFIT=0
replace subFIT=1 if country=="India" | country=="Canada" | country=="Australia" | country=="United States"

* Reestimate main models without countries with subnational FIT policies
eststo clear
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region if subFIT==0, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region if subFIT==0, vce(cluster id)
eststo: xi: logit FIT L1democracy L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region if subFIT==0, vce(cluster id) 

eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption OECD EU t t2 t3 i.region if subFIT==0, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform OECD EU t t2 t3 i.region if subFIT==0, vce(cluster id)
eststo: xi: logit FIT L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto OECD EU t t2 t3 i.region if subFIT==0, vce(cluster id) 

/* esttab using "FIT_subnationalFIT.tex", replace b(%9.2f) booktabs stats(N N_clust r2_p, labels("Observations" "Countries" "Pseudo $ R^2$") fmt(0 0 3)) /// 
eqlabels(none) drop(_cons OECD EU t* _Iregion_*) noconstant se label nonotes legend star(* 0.10 ** 0.05 *** 0.01) ///
mtitles("Model" "Model" "Model" "Model" "Model" "Model") ///
addnote ("Dependent Variable: FIT dummy." "Standard errors in parentheses and clustered by country." "All models include OECD and EU dummies, region fixed effects, and a cubic time polynomial.") ///
order(L1democracy L1polity L1diffusion_norm L1polcon3 L1loggdppc L1logpop L1logland L1corruption L1logco2pc L1fossilfuel L1elecgen L1reform L1logtrade L1logfdi L1kyoto)
*/

