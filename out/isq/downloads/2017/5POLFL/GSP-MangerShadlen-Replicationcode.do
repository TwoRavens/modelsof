version 9
capture log close
*
set more off
log using GSP-RTAs-MangerShadlenReplication, replace text
*
* Requires the following programs: Spost9, available at http://www.indiana.edu/~jslsoc/stata/
*
*
*
use GSP-PTAs-v3-00, clear
*
*
* Build a basic model
logit newPTA DemocracySouth lnDistance lnTotaltrade lnGDPcap2 lnGDP2 t tsquared tcubed  if sample == 1, robust cluster(pairid)
*
*
* Our preferred specification model (1) with the 
* political trade dependence variable (t-3, t-2, t-1)/3 to exports to partner
logit newPTA ptd3YearAverage DemocracySouth lnDistance lnTotaltrade lnGDPcap2 lnGDP2 t tsquared tcubed  if sampleExclude != 1, robust cluster(pairid)
*
* 
* calculate the relative risk
foreach v in ptd3YearAverage DemocracySouth lnDistance lnTotaltrade lnGDPcap2 lnGDP2  {
	qui summarize `v'
	local start = r(mean)
	local end = r(mean) + r(sd)
	display "** Change from `start' to `end' in `v'"
	qui prvalue, x(`v' = `start') rest(mean) save
		prvalue, x(`v' = `end') dif brief
}
* and marginal effects
mfx
* or the three-year average of preferential exports to total exports
logit newPTA ptdWorld3Year lnTotaltrade DemocracySouth lnDistance lnGDPcap2 lnGDP2 t tsquared tcubed if sampleExclude != 1, robust cluster(pairid)
*
*
foreach v in ptdWorld3Year lnTotaltrade DemocracySouth lnDistance lnGDPcap2 lnGDP2 {
	qui summarize `v'
	local start = r(mean)
	local end = r(mean) + r(sd)
	display "** Change from `start' to `end' in `v'"
	qui prvalue, x(`v' = `start') rest(mean) save
		prvalue, x(`v' = `end') dif brief
}
* Now with PTD as a share of GDP specification to check for
* total trade dependence (t-3, t-2, t-1)/3
*
logit newPTA ptd2GDP3YearAve tradeDepNonPref3YearAve DemocracySouth lnDistance lnGDPcap2 lnGDP2 t tsquared tcubed if sampleExclude != 1, robust cluster(pairid)
*
*
foreach v in ptd2GDP3YearAve tradeDepNonPref3YearAve DemocracySouth lnDistance lnGDPcap2 lnGDP2 {
	qui summarize `v'
	local start = r(mean)
	local end = r(mean) + r(sd)
	display "** Change from `start' to `end' in `v'"
	qui prvalue, x(`v' = `start') rest(mean) save
		prvalue, x(`v' = `end') dif brief
}
*  alternative specification with the first difference of political trade dependence
*
logit newPTA polTradeDepdiff DemocracySouth lnDistance lnTotaltrade lnGDPcap2 lnGDP2 t tsquared tcubed if sampleExclude !=1, robust cluster(pairid)
*
*
* Or with the Cheibub et al binary democracy/dictatorship indicator
logit newPTA ptd3YearAverage cheibubDDScore lnDistance lnTotaltrade lnGDPcap2 lnGDP2 t tsquared tcubed  if sampleExclude != 1, robust cluster(pairid)
*
* Appendix: include various variables that never approach common significance levels; we
* subsequentely drop these: The spatial lag term and alliance
logit newPTA  lnTotaltrade DemocracySouth lnDistance lnGDPcap2 lnGDP2 spatialWTarget alliance t tsquared tcubed if sample == 1, robust cluster(pairid)
* 
* Following Brambor, Clark, and Golder (2006) we need to show that the coefficients or our constituent parts of our interaction terms are indeed equal to zero
logit newPTA ptd2GDP3YearAve tradeDepNonPref3YearAve prefImports3YearAve nonPrefImports3YAve DemocracySouth lnDistance lnGDPcap2 lnGDP2 t tsquared tcubed if sampleExclude != 1, robust cluster(pairid)
*
*
* Robustness checks using alternative estimation approaches shown in the appendix
* five-year lags that reduce the sample size
* 
logit newPTA ptd5YearAverage DemocracySouth lnDistance lnTotaltrade lnGDPcap2 lnGDP2 t tsquared tcubed  if sampleExclude != 1, robust cluster(pairid)
* 
* Cubic splines
logit newPTA ptd3YearAverage DemocracySouth lnDistance lnTotaltrade lnGDPcap2 lnGDP2 _spline*  if sampleExclude != 1, robust cluster(pairid)
* 
*
*
* We can then check if both variables still have an effect when PTA is defined as signature rather than ratification
*
logit newPTAsigned ptd3YearAverage DemocracySouth lnDistance lnTotaltrade lnGDPcap2 lnGDP2 t tsquared tcubed if sampleSignedExclude != 1, robust cluster(pairid)
*
* or the start date of the negotiations instead of the date of signature/ratification
logit negotiations ptd3YearAverage DemocracySouth lnDistance lnTotaltrade lnGDPcap2 lnGDP2 t tsquared tcubed  if sampleNegotExclude != 1, robust cluster(pairid)
*
* We can also exclude MENA countries because the US has important foreign policy reasons to sign RTAs with some of them
logit newPTA ptd3YearAverage DemocracySouth lnDistance lnTotaltrade lnGDPcap2 lnGDP2 t tsquared tcubed if sampleExclude != 1 & iso2 !="EGY" & iso2 !="IRQ" & iso2 !="JOR" & iso2 !="KWT" & iso2 !="LBN" & iso2 !="MAR" & iso2 !="QAT" & iso2 !="SAU" & iso2 !="TUN" & iso2 !="YEM" & iso2 !="OMN", robust cluster(pairid)
*
* We can also include region dummies for Asia, Europe and Africa, using the Americas as the base category.
logit newPTA ptd3YearAverage lnTotaltrade DemocracySouth lnDistance lnGDPcap2 lnGDP2 Asia Europe Africa t tsquared tcubed if sample == 1, robust cluster(pairid)
*
*
* Robustness check with a wholly different approach: Cox prop hazard model
use GSP-RTAs-MangerShadlen-st.dta, clear
stcox ptd3YearAverage DemocracySouth lnDistance lnTotaltrade lnGDPcap2 lnGDP2 if sampleExclude !=1, robust nohr efron
*
*
* Check if proportional hazards assumption is violated
estat phtest, detail
* apparently prop hazards assumption is justified
log close