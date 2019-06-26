set more off 

use "/directory/.../addingtrade_replication.dta", clear


***Table II replication***

logit intervention  if year>1950 & year<2000  , cl(confyear) nolog
estat ic

xtlogit intervention  if year>1950 & year<2000 , i(confyear) nolog
estat ic

xtlogit intervention         Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3 if year>1950 & year<2000 , i(confyear) nolog
estat ic

xtlogit intervention l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3 if year>1950 & year<2000  , i(confyear) nolog
estat ic

xtlogit intervention l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3 if year>1950 & year<2000 , i(confyear) nolog
estat ic





***Table III replication***

// biased intervention
xtlogit intervention l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance           Oil opengdpc_gleln l1polity2 l1rgdp96pcalog ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3, i(confyear) nolog
estat ic

// pro-government intervention
xtlogit govint oppint l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance           Oil opengdpc_gleln l1polity2 l1rgdp96pcalog ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3, i(confyear) nolog
estat ic

//pro-rebel intervention
xtlogit oppint govint l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance           Oil opengdpc_gleln l1polity2 l1rgdp96pcalog ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3, i(confyear) nolog
estat ic

** Table 3 - substantive effects **
** Pro-government intervention
******************************
xtlogit govint oppint l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance           Oil opengdpc_gleln l1polity2 l1rgdp96pcalog ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3, i(confyear) nolog
// Trade Value
margins, predict(pu0) at((p25) l1trade_gleln (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar sinceint)   at((p75) l1trade_gleln (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar sinceint) atmeans
// Alliance 
margins, predict(pu0) at((p1) l1alliance_d (median) oppint demdyd demint  colcont ethnic refugees Oil coldwar sinceint)   at((p99) l1alliance (median) oppint demdyd demint  colcont ethnic refugees Oil coldwar sinceint) atmeans
// Democratic dyad 
margins, predict(pu0) at((p1) demdyd (median) oppint l1alliance demint  colcont ethnic refugees Oil coldwar sinceint)   at((p99) demdyd (median) oppint l1alliance demint  colcont ethnic refugees Oil coldwar sinceint) atmeans
// Power Balance
margins, predict(pu0) at((p25) l1powerbal (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar sinceint)   at((p75) l1powerbal (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar sinceint) atmeans
// Distance
margins, predict(pu0) at((p25) logdistance (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar sinceint)   at((p75) logdistance (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar sinceint) atmeans
////////LEVEL 2 ////////
// Oil Exporter
margins, predict(pu0) at((p1) Oil (median) oppint demdyd l1alliance demint  colcont ethnic refugees coldwar sinceint)   at((p99) Oil (median) oppint demdyd l1alliance demint  colcont ethnic refugees coldwar sinceint) atmeans
// Trade Openness
margins, predict(pu0) at((p25) opengdpc_gleln  (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar sinceint)   at((p75) opengdpc_gleln  (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar sinceint) atmeans
// Target Regime
margins, predict(pu0) at((p25) l1polity2 (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar sinceint)   at((p75) l1polity2 (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar sinceint) atmeans
// GDP/CAPITA
margins, predict(pu0) at((p25) l1rgdp96pcalog (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar sinceint)   at((p75) l1rgdp96pcalog (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar sinceint) atmeans
// Ethnic War
margins, predict(pu0) at((p1) ethnic (median) oppint l1alliance demdyd demint  colcont refugees Oil coldwar sinceint)   at((p99) ethnic (median) oppint l1alliance demdyd demint  colcont refugees Oil coldwar sinceint) atmeans
// Refugees
margins, predict(pu0) at((p1) refugees (median) oppint l1alliance demdyd demint  colcont ethnic Oil coldwar sinceint)   at((p99) refugees (median) oppint l1alliance demdyd demint  colcont ethnic Oil coldwar sinceint) atmeans
// Cold War
margins, predict(pu0) at((p1) coldwar (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil sinceint)   at((p99) coldwar (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil sinceint) atmeans
// Time Since
margins, predict(pu0) at((p25) sinceint (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar)   at((p75) sinceint (median) oppint l1alliance demdyd demint  colcont ethnic refugees Oil coldwar) atmeans

** Pro-rebel intervention
*************************
xtlogit oppint govint l1trade_gleln l1alliance_d  demdyd demint0 l1powerbal colcont logdistance           Oil opengdpc_gleln l1polity2 l1rgdp96pcalog ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3, i(confyear) nolog
// Democratic Intervener  
margins, predict(pu0) at((p1) demint (median) govint l1alliance  demdyd  colcont ethnic refugees Oil coldwar sinceint)   at((p99) demint (median) govint l1alliance demdyd  colcont ethnic refugees Oil coldwar sinceint) atmeans
// Power Balance
margins, predict(pu0) at((p25) l1powerbal (median) govint l1alliance demdyd demint0  colcont ethnic refugees Oil coldwar sinceint)   at((p75) l1powerbal (median) govint l1alliance demdyd demint0  colcont ethnic refugees Oil coldwar sinceint) atmeans
// Distance
margins, predict(pu0) at((p25) logdistance (median) govint l1alliance demdyd demint0  colcont ethnic refugees Oil coldwar sinceint)   at((p75) logdistance (median) govint l1alliance demdyd demint0  colcont ethnic refugees Oil coldwar sinceint) atmeans
////////LEVEL 2 ////////
// Oil Exporter 
margins, predict(pu0) at((p1) Oil (median) govint l1alliance demdyd demint0  colcont ethnic refugees coldwar sinceint)   at((p99) Oil (median) govint l1alliance demdyd demint  colcont ethnic refugees coldwar sinceint) atmeans
// Trade Openness 
margins, predict(pu0) at((p25) opengdpc_gleln (median) govint l1alliance demdyd demint0  colcont ethnic refugees coldwar sinceint)   at((p75) opengdpc_gleln (median) govint l1alliance demdyd demint0  colcont ethnic refugees coldwar sinceint) atmeans
// GDP/CAPITA
margins, predict(pu0) at((p25) l1rgdp96pcalog (median) govint l1alliance demdyd demint0  colcont ethnic refugees Oil coldwar sinceint)   at((p75) l1rgdp96pcalog (median) govint l1alliance demdyd demint0  colcont ethnic refugees Oil coldwar sinceint) atmeans
// Cost of War
margins, predict(pu0) at((p25)  intense000 (median) govint l1alliance demdyd demint0  colcont ethnic refugees Oil coldwar sinceint)   at((p75)  intense000 (median) govint l1alliance demdyd demint0  colcont ethnic refugees Oil coldwar sinceint) atmeans
// Cold War
margins, predict(pu0) at((p1) coldwar (median) govint l1alliance demdyd demint0  colcont ethnic refugees Oil sinceint)   at((p99) coldwar (median) govint l1alliance demdyd demint0  colcont ethnic refugees Oil sinceint) atmeans
// Time Since
margins, predict(pu0) at((p25) sinceint (median) govint l1alliance demdyd demint0  colcont ethnic refugees Oil coldwar)   at((p75) sinceint (median) govint l1alliance demdyd demint0  colcont ethnic refugees Oil coldwar) atmeans





***Robustness Check: Appendix Tables replication***


// adding trade dependence 
xtlogit intervention l1trade_depBgle l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3, i(confyear) nolog
estat ic

xtlogit intervention l1trade_gleln l1trade_depBgle l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3, i(confyear) nolog
estat ic

// separating econmic and military interventions 
xtlogit milint_d l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3, i(confyear) nolog
estat ic
est store JPRR162
xtlogit econint_d l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3, i(confyear) nolog
estat ic
est store JPRR163

// politically relevant dyads only
xtlogit intervention l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3 if year>1950 & year<2000 & intervention!=. & pol_rel==1, i(confyear) nolog
estat ic
est store JPRR18_polrel
xtlogit govint l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3 if year>1950 & year<2000 & intervention!=. & pol_rel==1, i(confyear) nolog
estat ic
est store JPRR182_polrel
xtlogit oppint l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3 if year>1950 & year<2000 & intervention!=. & pol_rel==1, i(confyear) nolog
estat ic
est store JPRR183_polrel

// adding a major power dummy
xtlogit intervention majpow l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3 if year>1950 & year<2000 & intervention!=. , i(confyear) nolog
estat ic
est store JPRR_adMP_int
xtlogit govint majpow l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3 if year>1950 & year<2000 & intervention!=. , i(confyear) nolog
estat ic
est store JPRR_adMP_gov
xtlogit oppint majpow l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln l1polity2 l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3 if year>1950 & year<2000 & intervention!=. , i(confyear) nolog
estat ic
est store JPRR_adMP_opp

// democratic target dummy 
xtlogit intervention l1trade_gleln  l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln demtrgt l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3, i(confyear) nolog
estat ic
xtlogit govint  l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln demtrgt l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3, i(confyear) nolog
estat ic
xtlogit oppint l1trade_gleln l1alliance_d  demdyd demint l1powerbal colcont logdistance          Oil opengdpc_gleln demtrgt l1rgdp96pcalog  ethnic intense000 refugees coldwar sinceint _spline1 _spline2 _spline3, i(confyear) nolog
estat ic


