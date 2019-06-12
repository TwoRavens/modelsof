use "replication data.dta", clear

use "C:\Users\Daniel\Dropbox\Journal (II)\Replication Files\Kono\replication data.dta", clear
***RESULTS PRESENTED IN PAPER


**Table 1. Summary Statistics

xtivreg2 tariff_app_wm_man l.tariff_app_wm_man (lnco2pc=kyoto_cont kyoto gas_cont) lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

sum tariff_app_wm_man tariff_app_wm_prim lnco2pc kyoto ur2 lngdppc lnpop growth_gdppc polity2 govcons if e(sample)

probit ctct tariff_app_wm_man lngdppc kyoto time time2, cluster(panel)

sum ctct if e(sample)


**Table 2. Impact of CO2 Emissions on Manufacturing Tariffs

xtreg tariff_app_wm_man l.tariff_app_wm_man lnco2pc lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe

xtivreg2 tariff_app_wm_man l.tariff_app_wm_man (lnco2pc=kyoto_cont kyoto gas_cont) lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

xtivreg2 tariff_app_wm_man l.tariff_app_wm_man (l.lnco2pc=l.kyoto_cont l.kyoto l.gas_cont) lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

xtivreg2 tariff_app_wm_man l.tariff_app_wm_man (l3.lnco2pc=l3.kyoto_cont l3.kyoto l3.gas_cont) lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

xtivreg2 tariff_app_wm_man l.tariff_app_wm_man (l5.lnco2pc=l5.kyoto_cont l5.kyoto l5.gas_cont) lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

xtivreg2 tariff_app_wm_man l.tariff_app_wm_man (lnco2pc=kyoto_cont kyoto gas_cont) lngdppc lnpop growth_gdppc polity2 govcons ur2 time time2 if eu==0, cluster(panel) fe first


**Table 3. Impact of CO2 Emissions on Primary-Good Tariffs

xtreg tariff_app_wm_prim l.tariff_app_wm_prim lnco2pc lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe

xtivreg2 tariff_app_wm_prim l.tariff_app_wm_prim (lnco2pc=kyoto_cont kyoto gas_cont) lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

xtivreg2 tariff_app_wm_prim l.tariff_app_wm_prim (l.lnco2pc=l.kyoto_cont l.kyoto l.gas_cont) lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

xtivreg2 tariff_app_wm_prim l.tariff_app_wm_prim (l3.lnco2pc=l3.kyoto_cont l3.kyoto l3.gas_cont) lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

xtivreg2 tariff_app_wm_prim l.tariff_app_wm_prim (l5.lnco2pc=l5.kyoto_cont l5.kyoto l5.gas_cont) lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

xtivreg2 tariff_app_wm_prim l.tariff_app_wm_prim (lnco2pc=kyoto_cont kyoto gas_cont) lngdppc lnpop growth_gdppc polity2 govcons ur2 time time2 if eu==0, cluster(panel) fe first


**Table 4. Impact of Manufacturing Tariffs on CO2 Emissions

xtreg lnco2pc l.lnco2pc tariff_app_wm_man lngdppc kyoto time time2, cluster(panel) fe

xtivreg2 lnco2pc l.lnco2pc (tariff_app_wm_man=ur2 lntar_man_cont) lngdppc kyoto time time2, cluster(panel) fe first

xtivreg2 lnco2pc l.lnco2pc (l.tariff_app_wm_man=l.ur2 l.lntar_man_cont) lngdppc kyoto time time2, cluster(panel) fe first

xtivreg2 lnco2pc l.lnco2pc (l3.tariff_app_wm_man=l3.ur2 l3.lntar_man_cont) lngdppc kyoto time time2, cluster(panel) fe first

xtivreg2 lnco2pc l.lnco2pc (l5.tariff_app_wm_man=l5.ur2 l5.lntar_man_cont) lngdppc kyoto time time2, cluster(panel) fe first


**Table 5. Impact of Primary-Good Tariffs on CO2 Emissions

xtreg lnco2pc l.lnco2pc tariff_app_wm_prim lngdppc kyoto time time2, cluster(panel) fe

xtivreg2 lnco2pc l.lnco2pc (tariff_app_wm_prim=ur2 lntar_prim_cont) lngdppc kyoto time time2, cluster(panel) fe first

xtivreg2 lnco2pc l.lnco2pc (l.tariff_app_wm_prim=l.ur2 l.lntar_prim_cont) lngdppc kyoto time time2, cluster(panel) fe first

xtivreg2 lnco2pc l.lnco2pc (l3.tariff_app_wm_prim=l3.ur2 l3.lntar_prim_cont) lngdppc kyoto time time2, cluster(panel) fe first

xtivreg2 lnco2pc l.lnco2pc (l5.tariff_app_wm_prim=l5.ur2 l5.lntar_prim_cont) lngdppc kyoto time time2, cluster(panel) fe first


**Table 6. Tariffs and Carbon Restrictions

*Dependent Variable: Tariffs

xtreg tariff_app_wm_man l.tariff_app_wm_man ctct lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe

xtreg tariff_app_wm_prim l.tariff_app_wm_prim ctct lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe

*Dependent Variable: Carbon Restrictions

probit ctct tariff_app_wm_man lngdppc kyoto time time2, cluster(panel)

probit ctct tariff_app_wm_prim lngdppc kyoto time time2, cluster(panel)


***RESULTS PRESENTED IN APPENDIX


**Table A1. Arellano-Bond Estimates

*Impact of CO2 Emissions on Manufacturing Tariffs (models 1-4)

xtabond2 tariff_app_wm_man l.tariff_app_wm_man lnco2pc lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, ///
 gmmstyle(l.tariff_app_wm_man lnco2pc, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc lnpop growth_gdppc ur2 kyoto_cont kyoto gas_cont time time2) robust artests(3)

xtabond2 tariff_app_wm_man l.tariff_app_wm_man l.lnco2pc lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, ///
 gmmstyle(l.tariff_app_wm_man l.lnco2pc, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc lnpop growth_gdppc ur2 l.kyoto_cont l.kyoto l.gas_cont time time2) robust artests(3)

xtabond2 tariff_app_wm_man l.tariff_app_wm_man l3.lnco2pc lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, ///
 gmmstyle(l.tariff_app_wm_man l3.lnco2pc, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc lnpop growth_gdppc ur2 l3.kyoto_cont l3.kyoto l3.gas_cont time time2) robust artests(3)

xtabond2 tariff_app_wm_man l.tariff_app_wm_man l5.lnco2pc lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, ///
 gmmstyle(l.tariff_app_wm_man l5.lnco2pc, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc lnpop growth_gdppc ur2 l5.kyoto_cont l5.kyoto l5.gas_cont time time2) robust artests(3)

*Impact of CO2 Emissions on Primary-Good Tariffs (models 5-8)

xtabond2 tariff_app_wm_prim l.tariff_app_wm_prim lnco2pc lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, ///
 gmmstyle(l.tariff_app_wm_prim lnco2pc, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc lnpop growth_gdppc ur2 kyoto_cont kyoto gas_cont time time2) robust artests(3)

xtabond2 tariff_app_wm_prim l.tariff_app_wm_prim l.lnco2pc lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, ///
 gmmstyle(l.tariff_app_wm_prim l.lnco2pc, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc lnpop growth_gdppc ur2 l.kyoto_cont l.kyoto l.gas_cont time time2) robust artests(3)

xtabond2 tariff_app_wm_prim l.tariff_app_wm_prim l3.lnco2pc lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, ///
 gmmstyle(l.tariff_app_wm_prim l3.lnco2pc, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc lnpop growth_gdppc ur2 l3.kyoto_cont l3.kyoto l3.gas_cont time time2) robust artests(3)

xtabond2 tariff_app_wm_prim l.tariff_app_wm_prim l5.lnco2pc lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, ///
 gmmstyle(l.tariff_app_wm_prim l5.lnco2pc, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc lnpop growth_gdppc ur2 l5.kyoto_cont l5.kyoto l5.gas_cont time time2) robust artests(3)

*Impact of Manufacturing Tariffs on CO2 Emissions (models 9-12)

xtabond2 lnco2pc l.lnco2pc tariff_app_wm_man lngdppc kyoto time time2, ///
 gmmstyle(l.lnco2pc tariff_app_wm_man, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc kyoto time time2 ur2 lntar_man_cont) robust artests(3)

xtabond2 lnco2pc l.lnco2pc l.tariff_app_wm_man lngdppc kyoto time time2, ///
 gmmstyle(l.lnco2pc l.tariff_app_wm_man, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc kyoto time time2 l.ur2 l.lntar_man_cont) robust artests(3)
 
xtabond2 lnco2pc l.lnco2pc l3.tariff_app_wm_man lngdppc kyoto time time2, ///
 gmmstyle(l.lnco2pc l3.tariff_app_wm_man, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc kyoto time time2 l3.ur2 l3.lntar_man_cont) robust artests(3)
 
xtabond2 lnco2pc l.lnco2pc l5.tariff_app_wm_man lngdppc kyoto time time2, ///
 gmmstyle(l.lnco2pc l5.tariff_app_wm_man, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc kyoto time time2 l5.ur2 l5.lntar_man_cont) robust artests(3)
 
*Impact of Primary-Good Tariffs on CO2 Emissions (model 13-16)

xtabond2 lnco2pc l.lnco2pc tariff_app_wm_prim lngdppc kyoto time time2, ///
 gmmstyle(l.lnco2pc tariff_app_wm_prim, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc kyoto time time2 ur2 lntar_prim_cont) robust artests(3)

xtabond2 lnco2pc l.lnco2pc l.tariff_app_wm_prim lngdppc kyoto time time2, ///
 gmmstyle(l.lnco2pc l.tariff_app_wm_prim, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc kyoto time time2 l.ur2 l.lntar_prim_cont) robust artests(3)
 
xtabond2 lnco2pc l.lnco2pc l3.tariff_app_wm_prim lngdppc kyoto time time2, ///
 gmmstyle(l.lnco2pc l3.tariff_app_wm_prim, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc kyoto time time2 l3.ur2 l3.lntar_prim_cont) robust artests(3)
 
xtabond2 lnco2pc l.lnco2pc l5.tariff_app_wm_prim lngdppc kyoto time time2, ///
 gmmstyle(l.lnco2pc l5.tariff_app_wm_prim, lag(1 1) equation(diff)) ///
 ivstyle(lngdppc kyoto time time2 l5.ur2 l5.lntar_prim_cont) robust artests(3)
 
 
**Table A2. Subsample Results: OECD versus Non-OECD, Democracy versus Non-Democracy

*Dependent Variable: Tariffs

*Manufacturing (models 1-2)

xtivreg2 tariff_app_wm_man l.tariff_app_wm_man (lnco2pc lnco2pc_oecd=kyoto_cont kyoto gas_cont) oecd lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

xtivreg2 tariff_app_wm_man l.tariff_app_wm_man (lnco2pc lnco2pc_democ=kyoto_cont kyoto gas_cont) democ lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

*Primary (models 3-4)

xtivreg2 tariff_app_wm_prim l.tariff_app_wm_prim (lnco2pc lnco2pc_oecd=kyoto_cont kyoto gas_cont) oecd lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

xtivreg2 tariff_app_wm_prim l.tariff_app_wm_prim (lnco2pc lnco2pc_democ=kyoto_cont kyoto gas_cont) democ lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

*Dependent Variable: CO2 Emissions

*Manufacturing tariffs (models 5-6)

xtivreg2 lnco2pc l.lnco2pc (tariff_app_wm_man tarman_oecd=ur2 lntar_man_cont) oecd lngdppc kyoto time time2, cluster(panel) fe first

xtivreg2 lnco2pc l.lnco2pc (tariff_app_wm_man tarman_democ=ur2 lntar_man_cont) democ lngdppc kyoto time time2, cluster(panel) fe first

*Primary tariffs (models 7-8)

xtivreg2 lnco2pc l.lnco2pc (tariff_app_wm_prim tarprim_oecd=ur2 lntar_prim_cont) oecd lngdppc kyoto time time2, cluster(panel) fe first

xtivreg2 lnco2pc l.lnco2pc (tariff_app_wm_prim tarprim_democ=ur2 lntar_prim_cont) democ lngdppc kyoto time time2, cluster(panel) fe first


**Table A3. Output-Weighted Emissions

*Dependent Variable: Tariffs (models 1-2)

xtivreg2 tariff_app_wm_man l.tariff_app_wm_man (lnco2pc_mangdp=kyoto_cont kyoto gas_cont) lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

xtivreg2 tariff_app_wm_prim l.tariff_app_wm_prim (lnco2pc_aggdp=kyoto_cont kyoto gas_cont) lngdppc lnpop growth_gdppc ur2 time time2 if eu==0, cluster(panel) fe first

*Dependent Variable: Emissions (models 3-4)
 
xtivreg2 lnco2pc_mangdp l.lnco2pc_mangdp (tariff_app_wm_man=ur2 lntar_man_cont) lngdppc kyoto time time2, cluster(panel) fe first

xtivreg2 lnco2pc_aggdp l.lnco2pc_aggdp (tariff_app_wm_prim=ur2 lntar_man_cont) lngdppc kyoto time time2, cluster(panel) fe first


