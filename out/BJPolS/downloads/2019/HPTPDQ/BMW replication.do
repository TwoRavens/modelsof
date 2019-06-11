//Summary:  This do file generates output for Ballard-Rosa, Mosley & Wellhausen (2019) "Contingent Advantage?"
clear all
set more off 

//Set working directory here for local machine:
cd "C:\YOUR CLASSPATH HERE"


//First we open our country-year-month level dataset:
use "BMW Dataverse dataset.dta", clear
xtset ccode time

//Declare which issuance outcome to use as primary DV:
rename anyIssue_UT_gt6mo issuanceOutcome
rename alreadyIssuedThisYear_UT_gt6mo alreadyIssued
gen amountOutcome = totalAmt_UT_gt6mo

//Declare sets of covariates
global controls_largeSample "l12.lngdppc l12.gdp_growth l12.curr_act_gdp l12.kaopen l12.external_debt_gdp issue_region i.region issue_msci ib0.msci_num"
global add_controls "l12.lvaw_garriga l12.duration_r l12.peg l12.oil l12.imfAnyInPlace l12.crisis_inflation l12.crisis_sovdebt"
global temporal "i.quarter i.year"

//NEW OUTPUT:
set scheme s2mono 

* FIGURE 1 & 2:  Issuance per year, and amount per issuance
sort wbcode year month
by wbcode year: egen months_issued = total(anyIssue_UT)
label var months_issued "Months with issuances (per year)"
by wbcode year: egen yearly_totalgdp = total(totalAmt_gdp_UT)
hist months_issued, discrete xscale(range(0 12)) xlabel(0(4)12)
graph export "Output/issuancePerYear.png", as(png) replace
sort months_issued
by months_issued: egen med_yearly_bymonths = median(yearly_totalgdp)
label var med_yearly_bymonths "Amount/GDP issued in year"
twoway (bar med_yearly_bymonths months_issued, sort), xscale(range(0 12)) xlabel(0(4)12)
graph export "Output/amountByMonthsIssued.png", as(png) replace

* FIGURE 3:  Detrended UST rate
tsset ccode date
reg treasury10yr i.year
predict UST_trend, xb
gen UST_detrend = treasury10yr - UST_trend
label var UST_detrend "US Treasury rate (detrended)"
twoway (tsline UST_detrend), xtitle(Date)
graph export "Output/UST_detrended.png", as(png) replace

* TABLE 1:  Conditional democratic advantage
probit issuanceOutcome c.l12.treasury10yr c.l12.v2x_polyarchy $controls_largeSample $temporal i.ccode, cluster(ccode)
outreg2 using  "Output/Latex output/table1", replace ctitle(Full sample) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr c.l12.v2x_polyarchy $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/table1", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/table1", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $add_controls $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/table1", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))

* FIGURE 4:  Marginal effect plot for standardized measure of democracy:
egen stdDemoc = std(v2x_polyarchy)
probit issuanceOutcome c.l12.stdDemoc##c.l12.treasury10yr $controls_largeSample $add_controls $temporal i.ccode if oecd != 1, cluster(ccode)
margins, dydx(l12.stdDemoc) at((mean) _all l12.treasury10yr=(1(0.5)9)) continuous
marginsplot, yline(0) recast(line) ciopts(recast(rline) lpattern(dash)) leg(off) title("Democracy and bond issuance, by UST") xtitle("US Treasury rates") ytitle("Change in Pr(Issue)") addplot(hist treasury10yr, lcolor(gs13) fcolor(none) yaxis(2) xlabel(1(1)9) yscale(alt range(0 1) axis(2)) ylabel(0(.1)1, axis(2)) leg(off))
graph export "Output/stdDemocXtreasury.png", as(png) replace

* TABLE 2:  Democ. mechanisms
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_liberal $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/table2", replace ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2xlg_legcon $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/table2", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_jucon $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/table2", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.hrv $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/table2", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))

* TABLE 3:  Amount
tobit log_totalAmt_UT c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal if oecd != 1, ll vce(cluster ccode)
outreg2 using  "Output/Latex output/table3", replace ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label onecol adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
tobit log_totalAmt_UT c.l12.treasury10yr##c.l12.v2x_liberal $controls_largeSample $temporal if oecd != 1, ll vce(cluster ccode)
outreg2 using  "Output/Latex output/table3", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label onecol adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
tobit log_totalAmt_UT c.l12.treasury10yr##c.l12.v2xlg_legcon $controls_largeSample $temporal if oecd != 1, ll vce(cluster ccode)
outreg2 using  "Output/Latex output/table3", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label onecol adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
tobit log_totalAmt_UT c.l12.treasury10yr##c.l12.v2x_jucon $controls_largeSample $temporal if oecd != 1, ll vce(cluster ccode)
outreg2 using  "Output/Latex output/table3", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label onecol adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
tobit log_totalAmt_UT c.l12.treasury10yr##c.l12.hrv $controls_largeSample $temporal if oecd != 1, ll vce(cluster ccode)
outreg2 using  "Output/Latex output/table3", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label onecol adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))

* FIGURE 5:  Marginal effect plot for standardized measure of democracy:
tobit log_totalAmt_UT c.l12.stdDemoc##c.l12.treasury10yr $controls_largeSample $temporal if oecd != 1, ll vce(cluster ccode)
margins, dydx(l12.stdDemoc) at((mean) _all l12.treasury10yr=(1(0.5)9)) continuous
marginsplot, yline(0) recast(line) ciopts(recast(rline) lpattern(dash)) leg(off) title("Democracy and amount issued, by UST") xtitle("US Treasury rates") ytitle("Change in Amount Issued") addplot(hist treasury10yr, lcolor(gs13) fcolor(none) yaxis(2) xlabel(1(1)9) yscale(alt range(0 1) axis(2)) ylabel(0(.1)1, axis(2)) leg(off))
graph export "Output/stdDemocXtreasury_amount.png", as(png) replace

* TABLE 4:  Elections
probit issuanceOutcome c.l12.treasury10yr##f3.elect_dum $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/table4", replace ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##f3.leader_elect $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/table4", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2xel_frefair $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/table4", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))

* TABLE 5:  Risks
label var v2x_corr "Political corruption"
label var v2x_hosinter "Exec. no longer elected"
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_corr $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/table5", replace ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_hosinter $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/table5", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))

//APPENDIX
* TABLE A1:  Polity / Democ dummy
probit issuanceOutcome c.l12.treasury10yr##c.l12.polity2 $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable1", replace ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.polity2 $controls_largeSample $add_controls $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable1", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.democ_dummy $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable1", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.democ_dummy $controls_largeSample $add_controls $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable1", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))

* TABLE A2:  Alternative time trends
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample time quarter i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable2", replace ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample time time2 quarter i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable2", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample time time2 time3 quarter i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable2", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample time time2 time3 time4 quarter i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable2", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))

* TABLE A3:  Decade results
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal i.ccode if year < 2000, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable3", replace ctitle(1990s) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal i.ccode if year >= 2000 & year < 2010, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable3", append ctitle(2000s) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal i.ccode if year >= 2010, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable3", append ctitle(2010s) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal i.ccode if year < 2008, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable3", append ctitle(Pre-crisis) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))

* TABLE A4:  OLS results
xtreg issuanceOutcome c.l12.treasury10yr c.l12.v2x_polyarchy $controls_largeSample $temporal, fe cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable4", replace ctitle(Full sample) drop(i.ccode ccode*) tex(frag) bdec(3) label
xtreg issuanceOutcome c.l12.treasury10yr c.l12.v2x_polyarchy $controls_largeSample $temporal if oecd != 1, fe cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable4", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	
xtreg issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal if oecd != 1, fe cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable4", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	
xtreg issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $add_controls $temporal if oecd != 1, fe cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable4", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	

* TABLE A5:  Different interest rates
replace globalf_long = globalf_long / 100

probit issuanceOutcome c.l12.germany10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable5", replace ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.japan10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable5", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.avg_intrate##c.l12.v2x_polyarchy $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable5", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.globalf_long##c.l12.v2x_polyarchy $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/appendixTable5", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))

* TABLE A6:  Bootstrapped standard errors
gen lead_issuance = f12.issuanceOutcome
probit lead_issuance c.treasury10yr c.v2x_polyarchy lngdppc gdp_growth curr_act_gdp kaopen external_debt_gdp issue_region i.region issue_msci ib0.msci_num $temporal i.ccode, vce(bootstrap, strata(ccode))
outreg2 using  "Output/Latex output/bootstrap", replace ctitle(Full sample) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p))
probit lead_issuance c.treasury10yr c.v2x_polyarchy lngdppc gdp_growth curr_act_gdp kaopen external_debt_gdp issue_region i.region issue_msci ib0.msci_num $temporal i.ccode if oecd != 1, vce(bootstrap, strata(ccode))
outreg2 using  "Output/Latex output/bootstrap", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p))
probit lead_issuance c.treasury10yr##c.v2x_polyarchy lngdppc gdp_growth curr_act_gdp kaopen external_debt_gdp issue_region i.region issue_msci ib0.msci_num $temporal i.ccode if oecd != 1, vce(bootstrap, strata(ccode))
outreg2 using  "Output/Latex output/bootstrap", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p))
probit lead_issuance c.treasury10yr##c.v2x_polyarchy lngdppc gdp_growth curr_act_gdp kaopen external_debt_gdp issue_region i.region issue_msci ib0.msci_num lvaw_garriga duration_r peg oil imfAnyInPlace crisis_inflation crisis_sovdebt $temporal i.ccode if oecd != 1, vce(bootstrap, strata(ccode))
outreg2 using  "Output/Latex output/bootstrap", append ctitle(No OECD) drop(i.ccode ccode*) tex(frag) bdec(3) label	adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p))

* TABLE A7: Credit ratings
xtreg avgRating c.l12.treasury10yr c.l12.v2x_polyarchy $controls_largeSample $temporal if oecd != 1, fe cluster(ccode)
xtreg avgRating c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal if oecd != 1, fe cluster(ccode)
xtreg avgRating c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal, fe cluster(ccode)
outreg2 using  "Output/Latex output/ratings", replace ctitle(Avg. Rating) drop(i.ccode ccode*) tex(frag) bdec(3) label adds(Countries, e(N_clust))
xtreg MoodysNUM c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal, fe cluster(ccode)
outreg2 using  "Output/Latex output/ratings", append ctitle(Moodys) drop(i.ccode ccode*) tex(frag) bdec(3) label adds(Countries, e(N_clust))
xtreg FitchNUM c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal, fe cluster(ccode)
outreg2 using  "Output/Latex output/ratings", append ctitle(Fitch) drop(i.ccode ccode*) tex(frag) bdec(3) label adds(Countries, e(N_clust))
xtreg SPnum c.l12.treasury10yr##c.l12.v2x_polyarchy $controls_largeSample $temporal, fe cluster(ccode)
outreg2 using  "Output/Latex output/ratings", append ctitle(S\&P) drop(i.ccode ccode*) tex(frag) bdec(3) label adds(Countries, e(N_clust))

* TABLE A8 & A9:  Heckman selection - Ratings/Issuance
global bcsControls "l12.curr_act_gdp l12.gdp_growth l12.lngdppc l12.inflation_annual l12.tradeGDP l12.crisis_sovdebt"
heckman issuanceOutcome c.l12.v2x_polyarchy c.l12.treasury10yr $bcsControls, select(hasRating = c.l12.v2x_polyarchy c.l12.treasury10yr $bcsControls exportsToUS i.decade) cluster(ccode)
outreg2 using  "Output/Latex output/heckmanIssue", replace ctitle(Issue) drop(i.ccode ccode*) tex(frag) bdec(3) label onecol adds(Countries, e(N_clust))
heckman issuanceOutcome c.l12.v2x_polyarchy##c.l12.treasury10yr $bcsControls, select(hasRating = c.l12.v2x_polyarchy c.l12.treasury10yr $bcsControls exportsToUS i.decade) cluster(ccode)
outreg2 using  "Output/Latex output/heckmanIssue", append ctitle(Issue) drop(i.ccode ccode*) tex(frag) bdec(3) label onecol adds(Countries, e(N_clust))
heckman avgRating c.l12.v2x_polyarchy c.l12.treasury10yr $bcsControls , select(hasRating = c.l12.v2x_polyarchy c.l12.treasury10yr $bcsControls exportsToUS i.decade) cluster(ccode)
outreg2 using  "Output/Latex output/heckmanRating", replace ctitle(Avg. Rating) drop(i.ccode ccode*) tex(frag) bdec(3) label onecol adds(Countries, e(N_clust))
heckman avgRating c.l12.treasury10yr##c.l12.v2x_polyarchy $bcsControls , select(hasRating = c.l12.treasury10yr##c.l12.v2x_polyarchy $bcsControls exportsToUS i.decade) cluster(ccode)
outreg2 using  "Output/Latex output/heckmanRating", append ctitle(Avg. Rating) drop(i.ccode ccode*) tex(frag) bdec(3) label onecol adds(Countries, e(N_clust))

* TABLE A10:  Standardized effect of democracy
probit issuanceOutcome c.l12.stdDemoc##c.l12.treasury10yr $controls_largeSample $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/standardDemoc", replace ctitle(Issue (No OECD)) drop(i.ccode ccode*) tex(frag) bdec(3) label adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
probit issuanceOutcome c.l12.stdDemoc##c.l12.treasury10yr $controls_largeSample $add_controls $temporal i.ccode if oecd != 1, cluster(ccode)
outreg2 using  "Output/Latex output/standardDemoc", append ctitle(Issue (No OECD)) drop(i.ccode ccode*) tex(frag) bdec(3) label adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))

tobit log_totalAmt_UT c.l12.stdDemoc##c.l12.treasury10yr $controls_largeSample $temporal if oecd != 1, ll vce(cluster ccode)
outreg2 using  "Output/Latex output/standardDemoc", append ctitle(Amount issued) drop(i.ccode ccode*) tex(frag) bdec(3) label adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))
tobit log_totalAmt_UT c.l12.stdDemoc##c.l12.treasury10yr $controls_largeSample $add_controls $temporal if oecd != 1, ll vce(cluster ccode)
outreg2 using  "Output/Latex output/standardDemoc", append ctitle(Amount issued) drop(i.ccode ccode*) tex(frag) bdec(3) label adds(Log likelihood, e(ll), Pseudo-R2, e(r2_p), Countries, e(N_clust))

* FIGURE A1:  ROC Curves
probit issuanceOutcome c.l12.treasury10yr##c.l12.v2x_polyarchy $temporal i.ccode if oecd != 1, cluster(ccode)
predict modelA
probit issuanceOutcome c.l12.treasury10yr c.l12.v2x_polyarchy  $temporal i.ccode if oecd != 1, cluster(ccode)
predict modelB

roccomp issuanceOutcome modelA modelB, graph
graph export "Output/ROC_curves.png", as(png) replace
