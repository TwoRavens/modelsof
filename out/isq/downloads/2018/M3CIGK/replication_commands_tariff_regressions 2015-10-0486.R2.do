clear

use "replication data_tariffs.dta", clear

***CREATE COUNTRY AND YEAR DUMMIES
*(For models that don't allow factor variables)

quietly tab ccode, gen(cdum)
quietly tab year, gen(yr)

***CREATE MACRO FOR ECM CONTROLS

global controls_ecm d.geddes_military d.geddes_party d.geddes_fail ///
 d.lngdppc d.lnpop d.wto l.geddes_military l.geddes_party l.wto ///
 l.lngdppc l.lnpop l.geddes_duration l.count_extralegal l.tenure l.geddes_fail

***CREATE MACRO FOR LRM CONTROLS

global controls_lrm d.geddes_military d.geddes_party d.geddes_fail ///
 d.lngdppc d.lnpop d.wto geddes_military geddes_party wto lngdppc ///
 lnpop geddes_duration count_extralegal tenure geddes_fail


***TABLE 1. EXTRALEGAL ENTRY AND TARIFFS

**Average Tariffs

*ECM

xtreg d.tar_wb l.tar_wb entry_sr l.entry $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*LRM

xtivreg2 tar_wb (d.tar_wb=l.tar_wb) d.entry entry $controls_lrm ///
yr* if polity2<6, fe cluster(ccode)

**Food Tariffs

*ECM

xtreg d.tariff_ag_wt l.tariff_ag_wt entry_sr l.entry $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*LRM

xtivreg2 tariff_ag_wt (d.tariff_ag_wt=l.tariff_ag_wt) d.entry entry $controls_lrm ///
yr* if polity2<6, fe cluster(ccode)

**Industrial Tariffs

*ECM

xtreg d.tariff_ind_wt l.tariff_ind_wt entry_sr l.entry $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*LRM

xtivreg2 tariff_ind_wt (d.tariff_ind_wt=l.tariff_ind_wt) d.entry entry $controls_lrm ///
yr* if polity2<6, fe cluster(ccode)


***TABLE 2. EXTRALEGAL ENTRY UNDER CRISIS CONDITIONS

*Unrest

xtreg d.tar_wb l.tar_wb entry_sr l.entry d.lnunrest l.lnunrest $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*Inflation

xtreg d.tar_wb l.tar_wb entry_sr l.entry d.inflation l.inflation $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*Food Price Inflation

xtreg d.tar_wb l.tar_wb entry_sr l.entry d.domestic_food l.domestic_food $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*Real Effective Exchange Rate

xtreg d.tar_wb l.tar_wb entry_sr l.entry d.reer l.reer $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*Trade Balance, % of GDP

xtreg d.tar_wb l.tar_wb entry_sr l.entry d.externalbalance_gdp l.externalbalance_gdp $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*Reserves, % of External Debt

xtreg d.tar_wb l.tar_wb entry_sr l.entry d.reserves_percentextdebt l.reserves_percentextdebt $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*Short-Term Debt, % of Reserves

xtreg d.tar_wb l.tar_wb entry_sr l.entry d.debt_sr_percentreserves l.debt_sr_percentreserves $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*Interest on New Public Debt

xtreg d.tar_wb l.tar_wb entry_sr l.entry d.interest_newdebt_official l.interest_newdebt_official $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*Public Debt Service, % of Exports

xtreg d.tar_wb l.tar_wb entry_sr l.entry d.debtservice_exports_public l.debtservice_exports_public $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*Total Debt Service, % of GNI

xtreg d.tar_wb l.tar_wb entry_sr l.entry d.debtservicetot_gni l.debtservicetot_gni $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*Interest on External Debt, % of GNI

xtreg d.tar_wb l.tar_wb entry_sr l.entry d.interest_extdebt_gni l.interest_extdebt_gni $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)

*Portfolio Inflows, % of GDP

xtreg d.tar_wb l.tar_wb entry_sr l.entry d.portfolio_gdp l.portfolio_gdp $controls_ecm ///
i.year if polity2<6, fe cluster(ccode)


***CREATE VARIABLES FOR ENDOGENOUS TREATMENT AND MATCHING MODELS
*These commands do not permit time-series operators, so first-
*differenced and lagged variables must be created first

gen dtar_wb=d.tar_wb
gen ltar_wb=l.tar_wb
gen dentry=d.entry
gen lentry=l.entry
gen dgeddes_military=d.geddes_military
gen dgeddes_party=d.geddes_party
gen dgeddes_fail=d.geddes_fail
gen dlngdppc=d.lngdppc
gen dlnpop=d.lnpop
gen dwto=d.wto
gen lgeddes_military=l.geddes_military
gen lgeddes_party=l.geddes_party
gen lwto=l.wto
gen llngdppc=l.lngdppc
gen llnpop=l.lnpop
gen lgeddes_fail=l.geddes_fail
gen lgeddes_duration=l.geddes_duration
gen lcount_extralegal=l.count_extralegal
gen ltenure=l.tenure
gen dtariff_ag_wt=d.tariff_ag_wt
gen ltariff_ag_wt=l.tariff_ag_wt
gen dtariff_ind_wt=d.tariff_ind_wt
gen ltariff_ind_wt=l.tariff_ind_wt


***TABLE 3. SELECTION AND MATCHING

*CREATE MACRO FOR SELECTION MODEL CONTROLS

global controls_etm dgeddes_military dgeddes_party dgeddes_fail ///
 dlngdppc dlnpop dwto lgeddes_military lgeddes_party lwto ///
 llngdppc llnpop lgeddes_duration lcount_extralegal ltenure lgeddes_fail

*CREATE MACRO FOR MATCHING CONTROLS

global controls_match ltar_wb dgeddes_military dgeddes_party ///
dgeddes_fail dlngdppc dlnpop dwto lgeddes_military lgeddes_party ///
lwto llngdppc llnpop lgeddes_duration lcount_extralegal ltenure lgeddes_fail 
 
*SELECTION MODEL
 
etreg dtar_wb ltar_wb lentry $controls_etm yr* cdum* if polity2<6, ///
treat(entry_sr=geddes_military geddes_party lnunrest total_coups count_extralegal agereg) cl(ccode)

*MATCHING MODEL

quietly psmatch2 entry $controls_match, outcome(dtar_wb)  

reg dtar_wb entry_sr lentry $controls_match i.ccode i.year ///
[fweight=_weight] if _weight!=. & polity2<6, cluster(ccode)

