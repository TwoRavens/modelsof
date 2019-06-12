cd c:\docume~1\cmagee\docume~1\econgr~1\
set more off

use data1_replication, clear
xi i.year
xi i.continent*lndn_growth, prefix(_K)

log using tables_replication.log, replace

* Table 3
reg ln_growth lndn_growth autocracy anocracy _Iyear*, robust cluster(isonv10)
reg ln_growth lndn_growth autocracy anocracy crisis crisis_autoc _Iyear*, robust cluster(isonv10)
reg ln_growth lndn_growth not_free part_free _Iyear*, robust cluster(isonv10)
reg ln_growth lndn_growth autocracy anocracy not_free part_free _Iyear*, robust cluster(isonv10)
reg ln_growth lndn_growth autocracy anocracy _Kcontinent_2 _Kcontinent_3 _Kcontinent_4 _Kcontinent_5  _KconXlndn__2 _KconXlndn__3 _KconXlndn__4 _KconXlndn__5 _Iyear*, robust cluster(isonv10)

test _Kcontinent_2 _Kcontinent_3 _Kcontinent_4 _Kcontinent_5 _KconXlndn__2 _KconXlndn__3 _KconXlndn__4 _KconXlndn__5
test _KconXlndn__2 _KconXlndn__3 _KconXlndn__4 _KconXlndn__5


* Table 4

heckman ln_growth lndn_growth autocracy anocracy _I*, select(ln_growth_seen=sum_orgs lndn_growth autocracy anocracy  year) robust cluster(isonv10)
heckman ln_growth lndn_growth not_free part_free _I*, select(ln_growth_seen=sum_orgs lndn_growth autocracy anocracy year) robust cluster(isonv10)
heckman ln_growth lndn_growth autocracy anocracy not_free part_free _I*, select(ln_growth_seen=sum_orgs lndn_growth autocracy anocracy year) robust cluster(isonv10)
heckman ln_growth lndn_growth autocracy anocracy _K* _I*, select(ln_growth_seen=sum_orgs lndn_growth autocracy anocracy year) robust cluster(isonv10)
test _Kcontinent_2 _Kcontinent_3 _Kcontinent_4 _Kcontinent_5  _KconXlndn__2 _KconXlndn__3 _KconXlndn__4 _KconXlndn__5  




use data2_replication, clear
xi i.continent*lndnlongdiff, prefix(_J)


* Table 5

reg lngdpwdilocallongdiff lndnlongdiff autocracy anocracy, robust

reg lngdpwdilocallongdiff lndnlongdiff autocracy anocracy

predict dfbeta_aut, dfbeta(autocracy)

predict cooksd, cooksd

reg lngdpwdilocallongdiff lndnlongdiff not_free part_free, robust

reg lngdpwdilocallongdiff lndnlongdiff autocracy anocracy not_free part_free, robust

reg lngdpwdilocallongdiff lndnlongdiff autocracy anocracy _J*, robust
test _Jcontinent_2 _Jcontinent_3 _Jcontinent_4 _Jcontinent_5 _JconXlndnl_2 _JconXlndnl_3 _JconXlndnl_4 _JconXlndnl_5


* Table 6

heckman lngdpwdilocallongdiff lndnlongdiff autocracy anocracy, select(gdp_seen = sum_orgs lndnlongdiff autocracy anocracy) robust

heckman lngdpwdilocallongdiff lndnlongdiff not_free part_free, select(gdp_seen = sum_orgs lndnlongdiff autocracy anocracy) robust

heckman lngdpwdilocallongdiff lndnlongdiff autocracy anocracy not_free part_free, select(gdp_seen = sum_orgs lndnlongdiff autocracy anocracy) robust

heckman lngdpwdilocallongdiff lndnlongdiff autocracy anocracy _J*, select(gdp_seen = sum_orgs lndnlongdiff autocracy anocracy) robust
test  _Jcontinent_2 _Jcontinent_3 _Jcontinent_4 _Jcontinent_5 _JconXlndnl_2 _JconXlndnl_3 _JconXlndnl_4 _JconXlndnl_5

* Robustness checks, Table 7
reg lngdpwdilocallongdiff lndnlongdiff autocracy anocracy ln_gdppc, robust

reg lngdpwdilocallongdiff lndnlongdiff autocracy anocracy if country~="China" & country~="Myanmar", robust

reg ln_gdp_diff lndnlongdiff autocracy anocracy, robust

reg lngdpwdilocallongdiff lndnlongdiff dd_democracy, robust
reg lngdpwdilocallongdiff lndnlongdiff regime3 regime4 regime5, robust


* Table 9: Krieckhaus model 

reg  rgdpch_gr rgdpch ci edus pop_gr polity2, robust
reg  lights_perc_ch lights_percap_92 ci edus pop_gr polity2, robust
reg  rgdpch_gr rgdpch ci edus pop_gr autocracy anocracy, robust
reg  lights_perc_ch lights_percap_92 ci edus pop_gr autocracy anocracy, robust


* Table 2: effect of autocracy on growth

drop if polity2==. | lngdp_9293==. | lndnlongdiff==. | lngdpwdilocallongdiff==.

reg  lngdpwdilocallongdiff lngdp_9293 polity2, robust

reg lndnlongdiff lndn9293 polity2, robust

reg  lngdpwdilocallongdiff lngdp_9293 autocracy anocracy, robust

reg lndnlongdiff lndn9293 autocracy anocracy if lngdpwdilocallongdiff~=. & lngdp_9293~=., robust





log close




