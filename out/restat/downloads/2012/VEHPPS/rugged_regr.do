/*-----------------------------------------------------------------------
rugged_regr.do

Stata do file to re-create the regressions of the article
'Ruggedness: The blessing of bad geography in Africa',
by Nathan Nunn and Diego Puga,
Review of Economics and Statistics.
-----------------------------------------------------------------------*/

clear all
set more off
log using rugged_regr, text replace name(rugged)

use rugged_data, clear

* log real gdp per person
gen ln_rgdppc_2000=ln(rgdppc_2000)
label var ln_rgdppc_2000 "Log real GDP per person 2000 --- World Bank"
gen ln_rgdppc_1950_m=ln(rgdppc_1950_m)
label var ln_rgdppc_1950_m "Log real GDP per person 1950 --- Maddison"
gen ln_rgdppc_1975_m=ln(rgdppc_1975_m)
label var ln_rgdppc_1975_m "Log real GDP per person 1975 --- Maddison"
gen ln_rgdppc_2000_m=ln(rgdppc_2000_m)
label var ln_rgdppc_2000_m "Log real GDP per person 2000 --- Maddison"
gen ln_rgdppc_1950_2000_m=ln(rgdppc_1950_2000_m)
label var ln_rgdppc_1950_2000_m "Log real GDP per person 1950--2000 average --- Maddison"
* diamonds
gen diamonds = gemstones/(land_area/100)
label var diamonds   "Diamonds"
* slave exports
gen ln_slave_exports_area=ln(1+slave_exports/(land_area/100))
label var ln_slave_exports_area "Slave export intensity"
* historical population density
gen ln_pop_dens1400=ln(1+pop_1400/(land_area/100))
label var ln_pop_dens1400 "Log pop. density 1400"
* ruggedness - africa interactions
gen rugged_x_africa=rugged*cont_africa
label var rugged_x_africa        "Ruggedness $\cdot I^{\text{Africa}}$"
for @ in any n s e w c: gen rugged_x_africa_@=rugged*africa_region_@
label var rugged_x_africa_n "Ruggedness $\cdot I^{\text{North Africa}}$"
label var rugged_x_africa_s "Ruggedness $\cdot I^{\text{South Africa}}$"
label var rugged_x_africa_e "Ruggedness $\cdot I^{\text{East Africa}}$"
label var rugged_x_africa_w "Ruggedness $\cdot I^{\text{West Africa}}$"
label var rugged_x_africa_c "Ruggedness $\cdot I^{\text{Central Africa}}$"
* ruggedness - colonizer interactions
for @ in any esp gbr fra prt oeu: gen rugged_x_colony_@=rugged*colony_@
label var rugged_x_colony_esp "Ruggedness $\cdot I^{\text{Spanish col. orig.}}$"
label var rugged_x_colony_gbr "Ruggedness $\cdot I^{\text{British col. orig.}}$"
label var rugged_x_colony_fra "Ruggedness $\cdot I^{\text{French col. orig.}}$"
label var rugged_x_colony_prt "Ruggedness $\cdot I^{\text{Portuguese col. orig.}}$"
label var rugged_x_colony_oeu "Ruggedness $\cdot I^{\text{Other European col. orig.}}$"
* ruggedness - legal origin interactions
for @ in any gbr fra deu sca soc: gen rugged_x_legor_@=rugged*legor_@
label var rugged_x_legor_gbr "Ruggedness $\cdot I^{\text{Common law}}$"
label var rugged_x_legor_fra "Ruggedness $\cdot I^{\text{French civil law}}$"
label var rugged_x_legor_deu "Ruggedness $\cdot I^{\text{German civil law}}$"
label var rugged_x_legor_sca "Ruggedness $\cdot I^{\text{Scandinavian law}}$"
label var rugged_x_legor_soc "Ruggedness $\cdot I^{\text{Socialist law}}$"
* ruggedness - geography interactions
for @ in any tropical soil: gen rugged_x_@=rugged*@
label var rugged_x_tropical "Ruggedness $\cdot$ \% Tropical cl."
label var rugged_x_soil     "Ruggedness $\cdot$ \% Fertile soil"
* africa - geography interactions
for @ in any soil tropical dist_coast diamonds: gen @_x_africa=@*cont_africa
label var tropical_x_africa    "\% Tropical climate $\cdot I^{\text{Africa}}$"
label var dist_coast_x_africa  "Distance to coast $\cdot I^{\text{Africa}}$"
label var soil_x_africa        "\% Fertile soil $\cdot I^{\text{Africa}}$"
label var diamonds_x_africa    "Diamonds $\cdot I^{\text{Africa}}$"
* africa - legal origin interactions
for @ in any gbr fra: gen legor_@_x_africa=legor_@*cont_africa
label var legor_gbr_x_africa " $ I^{\text{Common law}} \cdot I^{\text{Africa}}$"
label var legor_fra_x_africa " $ I^{\text{French civil law}} \cdot I^{\text{Africa}}$"
* re-label variables for tables
label var rugged     "Ruggedness"
label var tropical   "\% Tropical climate"
label var dist_coast "Distance to coast"
label var soil       "\% Fertile soil"
label var desert     "\% Desert"
label var dist_slavemkt_saharan  "Dist. Saharan slave market"
label var dist_slavemkt_atlantic "Dist. Atlantic slave market"
label var dist_slavemkt_redsea   "Dist. Red Sea slave market"
label var dist_slavemkt_indian   "Dist. Indian slave market"
label var rugged_popw "Ruggedness (pop. weighted)"
label var africa_region_n " $ I^{\text{North Africa}}$"
label var africa_region_s " $ I^{\text{South Africa}}$"
label var africa_region_e " $ I^{\text{East Africa}}$"
label var africa_region_w " $ I^{\text{West Africa}}$"
label var africa_region_c " $ I^{\text{Central Africa}}$"
label var cont_africa        " $ I^{\text{Africa}}$"
label var colony_esp " $ I^{\text{Spanish col. orig.}}$"
label var colony_gbr " $ I^{\text{British col. orig.}}$"
label var colony_fra " $ I^{\text{French col. orig.}}$"
label var colony_prt " $ I^{\text{Portuguese col. orig.}}$"
label var colony_oeu " $ I^{\text{Other European col. orig.}}$"
label var legor_gbr " $ I^{\text{Common law}}$"
label var legor_fra " $ I^{\text{French civil law}}$"
label var legor_deu " $ I^{\text{German civil law}}$"
label var legor_sca " $ I^{\text{Scandinavian law}}$"
label var legor_soc " $ I^{\text{Socialist law}}$"

* define standard set of controls
local stdcontrols "diamonds diamonds_x_africa soil soil_x_africa tropical tropical_x_africa dist_coast dist_coast_x_africa"

/* table 1: the differential effects of ruggedness in africa */
* table 1, column (1)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa, robust
* table 1, column (2)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa diamonds diamonds_x_africa, robust
* table 1, column (3)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa soil soil_x_africa, robust
* table 1, column (4)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa tropical tropical_x_africa, robust
* table 1, column (5)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa dist_coast dist_coast_x_africa, robust
* table 1, column (6)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa `stdcontrols', robust

/* table 2: robustness with respect to influential observations */
* table 2, column (1), ommit 10 most rugged
preserve
drop if missing(ln_rgdppc_2000)
sort rugged
gen rank = _n
gen mostrugged = 0
replace mostrugged = 1 if rank <= 10
drop rank
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa `stdcontrols' if mostrugged == 0, robust
restore
* table 2, column (2), ommit 10 smallest
preserve
drop if missing(ln_rgdppc_2000)
sort land_area
gen rank = _n
gen small = 0
replace small = 1 if rank <= 10
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa `stdcontrols' if small == 0, robust
restore
* table 2, column (3), ommit influential observations
preserve
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa `stdcontrols'
predict dfbeta3, dfbeta(rugged_x_africa)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa `stdcontrols' if abs(dfbeta3)<(2/sqrt(170)), robust
restore
* table 2, column (4), using ln(ruggedness)
preserve
replace rugged=ln(rugged)
replace rugged_x_africa=rugged*cont_africa
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa `stdcontrols', robust
restore
* table 2, column (5), box-cox transformation of ruggedness
preserve
bcskew0 trans_rugged=rugged
replace rugged=trans_rugged
replace rugged_x_africa=trans_rugged*cont_africa
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa `stdcontrols', robust
restore

/* table 3: considering differential effects of ruggedness by characteristics prevalent in africa */
* table 3, column (1)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa rugged_x_tropical tropical, robust
* table 3, column (2)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa rugged_x_soil soil, robust
* table 3, column (3)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa rugged_x_soil soil rugged_x_tropical tropical, robust
* table 3, column (4)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa rugged_x_soil soil rugged_x_tropical tropical rugged_x_colony* colony*, robust
* table 3, column (5)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa rugged_x_soil soil rugged_x_tropical tropical legor_fra rugged_x_legor_fra legor_soc rugged_x_legor_soc legor_deu rugged_x_legor_deu legor_sca rugged_x_legor_sca, robust

/* table 4: differential effects of ruggedness across regions within africa */
* table 4, column (1)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa rugged_x_africa_w africa_region_w, robust
* table 4, column (2)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa rugged_x_africa_e africa_region_e, robust
* table 4, column (3)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa rugged_x_africa_c africa_region_c, robust
* table 4, column (4)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa rugged_x_africa_n africa_region_n, robust
* table 4, column (5)
reg ln_rgdppc_2000 rugged rugged_x_africa cont_africa rugged_x_africa_s africa_region_s, robust

/* table 5: the impact and determinants of slave exports */
* table 5, column (1)
reg ln_rgdppc_2000 rugged rugged_x_africa ln_slave_exports_area cont_africa, robust
* table 5, column (2)
reg ln_rgdppc_2000 rugged ln_slave_exports_area cont_africa, robust
* table 5, column (3)
reg ln_rgdppc_2000 rugged rugged_x_africa ln_slave_exports_area cont_africa `stdcontrols', robust
* table 5, column (4)
reg ln_rgdppc_2000 rugged ln_slave_exports_area cont_africa `stdcontrols', robust
* table 5, column (5)
reg ln_slave_exports_area rugged if cont_africa == 1 & !missing(ln_rgdppc_2000), robust
* table 5, column (6)
reg ln_slave_exports_area rugged diamonds soil tropical dist_coast if cont_africa == 1 & !missing(ln_rgdppc_2000), robust
* table 5, column (7)
reg ln_slave_exports_area rugged diamonds soil tropical dist_coast ln_pop_dens1400 dist_slavemkt* if cont_africa == 1 & !missing(ln_rgdppc_2000), robust

/* table 6: the effect of slave exports on income through rule of law */
* table 6, column (1)
preserve
drop if missing(ln_rgdppc_2000)
drop if missing(q_rule_law)
reg ln_rgdppc_2000 q_rule_law rugged cont_africa, robust
* table 6, column (2)
reg ln_rgdppc_2000 q_rule_law rugged cont_africa `stdcontrols', robust
* table 6, column (3)
reg q_rule_law ln_slave_exports_area cont_africa, robust
* table 6, column (4)
reg q_rule_law ln_slave_exports_area rugged cont_africa `stdcontrols', robust
* table 6, column (5)
reg q_rule_law ln_slave_exports_area rugged cont_africa `stdcontrols' legor_fra legor_fra_x_africa legor_soc legor_deu legor_sca, robust
restore

/* web appendix table: summary statistics */
* africa
sum rugged ln_rgdppc_2000 diamonds soil tropical dist_coast ln_slave_exports_area if cont_africa==1 & missing(ln_rgdppc_2000)!=1
for @ in any ln_rgdppc_2000 diamonds soil tropical dist_coast ln_slave_exports_area: pwcorr rugged @ if cont_africa==1 & missing(ln_rgdppc_2000)!=1, sig star(.10)
* non-africa
sum rugged ln_rgdppc_2000 diamonds soil tropical dist_coast if cont_africa==0 & missing(ln_rgdppc_2000)!=1
for @ in any ln_rgdppc_2000 diamonds soil tropical dist_coast: pwcorr rugged @ if cont_africa==0 & missing(ln_rgdppc_2000)!=1, sig star(.10)

/* web appendix table: alternative income and ruggedness measures */
* loop through ruggedness measures
foreach rv in rugged rugged_slope rugged_lsd rugged_pc rugged_popw {
  preserve
  rename `rv' rugged_alt
  gen rugged_alt_x_africa = rugged_alt * cont_africa
  if "`rv'" == "rugged"       label var rugged_alt_x_africa "Ruggedness"
  if "`rv'" == "rugged_slope" label var rugged_alt_x_africa "Average slope"
  if "`rv'" == "rugged_lsd"   label var rugged_alt_x_africa "Local std. dev. of elevation"
  if "`rv'" == "rugged_pc"    label var rugged_alt_x_africa "\% highly rugged land"
  if "`rv'" == "rugged_popw"  label var rugged_alt_x_africa "Pop.-weighted ruggedness"
  reg ln_rgdppc_2000 rugged_alt rugged_alt_x_africa cont_africa `stdcontrols', robust
  reg ln_rgdppc_2000_m rugged_alt rugged_alt_x_africa cont_africa `stdcontrols', robust
  reg ln_rgdppc_1950_m rugged_alt rugged_alt_x_africa cont_africa `stdcontrols', robust
  reg ln_rgdppc_1950_2000_m rugged_alt rugged_alt_x_africa cont_africa `stdcontrols', robust
  restore
}

exit
