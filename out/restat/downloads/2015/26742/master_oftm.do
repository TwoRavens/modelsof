global hostile cas_dc_pos
global nonhostile cas_nh_dc_pos
global stderr cluster(cl)
global stats stats(FE YFE r2 N, fmt(0 0 3 0) labels("District FE" "Year FE" "R$^{2}$" "N"))
global out2 replace booktabs starlevels(* 0.10 ** 0.05 *** 0.01) drop(_cons _I* o.*) se nomtit nodep nonotes
global out $out2 $stats /* separate out2 and out since stats is different from $(stats) in some of the tables */
global lab varlabels($hostile "Casualties, district" L.$hostile "Casualties, district lagged" L2.$hostile "Casualties, district two lags" cas_pv_pos "Casualties, province" L.cas_pv_pos "Casualties, province lagged" L2.cas_pv_pos "Casualties, province two lags" q "Opium production, hectare land" L.q "Opium production, lagged" L2.q "Opium production, two lags" satellite "Observation by satellite" distancetokabul "Distance to Kabul" L.distancetokabul "Distance, lagged" L2.distancetokabul "Distance, two lags" inter "Casualties $\times$ Distance" L.inter "Casualties lagged $\times$ Distance" L2.inter "Cas $\times$ Distance, two lags" q "Opium production, hectare land" L.q "Opium production, lagged" L2.q "Opium production, two lags" L.far_cas "Cas. lagged $\times$ Far from Kabul" far_kabul "Far from Kabul" cas_dc_plant_pos "Casualties, planting season" cas_dc_contr_s_pos "Casualties, after planting season (short window)" cas_dc_contr_l_pos "Casualties, after planting season (long window)" cas_dc "Casualties count, district" L.cas_dc "Casualties count, district lagged" L2.cas_dc "Casualties count, district two lags" _cons Constant cas_dc_before1 "Casualties, before planting 1" cas_dc_before2 "Casualties, shortly before planting season") 

* Creates Tables 3, 5, 7, A-1, A-3, A-4
do tables.do
* Creates Table 4:
do planting.do
* Creates Table 2:
do eradication.do
* Creates Table 6
do nrva.do
* Created Table A-2
do rain_iv
* Create Table B-6
do spatial.do
* Create figures
do figs.do
