*Analysis run using Stata14
cd "~/Dropbox/after ISQ - nowhere to go/replication files/replicationFilesForTables"
use "replication_data.dta", clear

xtset ccode year 

*TABLE 2******************
*Model 1
set seed 123
xtnbreg refugees log_bdeadhigh yearinconflict yearinconflictSq, fe  vce(boot, rep(100))

*Model 2
xtnbreg refugees log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq, fe  vce(boot, rep(100))

*Model 3
xtnbreg refugees log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km, fe  vce(boot, rep(100))

*Model 4
xtnbreg refugees log_bdeadhigh yearinconflict yearinconflictSq gdppc_weighted, fe  vce(boot, rep(100))

*Model 5
set seed 123
xtnbreg refugees log_bdeadhigh yearinconflict yearinconflictSq polity_weighted, fe  vce(boot, rep(100))

*Model 6
xtnbreg  refugees gdppc_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict  yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*Model 7
xtnbreg  refugees polity_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict  yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*Model 8
xtnbreg refugees polity_weighted gdppc_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km, fe  vce(boot, rep(100)) 

*TABLE A1***************************
*Model 1
nbreg  refugees gdppc_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km refugees_lag_log, vce(cluster ccode)

*Model 2
nbreg  refugees polity_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km refugees_lag_log, vce(cluster ccode)

*Model 3
set seed 123
xtreg  logged_refugees gdppc_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq  countries_in500km, fe vce(boot, rep(100))
 
*Model 4
set seed 123
xtreg  logged_refugees polity_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq  countries_in500km, fe vce(boot, rep(100))

*Model 5
xtpcse  logged_refugees gdppc_weighted  log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km, correlation(ar1) het

*Model 6
xtpcse  logged_refugees polity_weighted  log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km, correlation(ar1) het

*Model 7
set seed 123
xtnbreg  refugees_flow gdppc_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict  yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*Model 8
set seed 123
xtnbreg  refugees_flow polity_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict  yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*TABLE A2*****************************
*Model 1
zinb refugees gdppc_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km, inflate(gdppc_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km) vce(cluster ccode )

*Model 2
zinb refugees gdppc_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km refugees_lag_log , inflate(gdppc_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km refugees_lag_log ) vce(cluster ccode )

*Model 3
zinb refugees polity_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km, inflate(polity_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km) vce(cluster ccode )

*Model 4
zinb refugees polity_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km refugees_lag_log , inflate(polity_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km refugees_lag_log ) vce(cluster ccode )

*TABLE A3*****************************
*Model 1
set seed 123
xtnbreg  refugees gdppc_weighted_border_16  log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch  yearinconflict yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*Model 2
set seed 123
xtnbreg  refugees polity_weighted_border_16  log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch  yearinconflict yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*Model 3
set seed 123
xtnbreg  refugees mean_500km_gdppc  log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch  yearinconflict yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*Model 4
set seed 123
xtnbreg  refugees mean_500km_polity  log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch  yearinconflict yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*TABLE A4****************************
*Model 1
set seed 123
xtnbreg refugees log_bdeadlow yearinconflict yearinconflictSq gdppc_weighted, fe  vce(boot, rep(100))

*Model 2
set seed 123
xtnbreg refugees log_bdeadlow yearinconflict yearinconflictSq polity_weighted, fe  vce(boot, rep(100))

*Model 3
set seed 123
xtnbreg  refugees gdppc_weighted log_bdeadlow territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*Model 4
set seed 123
xtnbreg  refugees polity_weighted log_bdeadlow territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*TABLE A5***************************
*Model 1
set seed 123
xtnbreg refugees gdppc_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide territory_logged yearinconflict  yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*Model 2
set seed 123
xtnbreg refugees polity_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide territory_logged yearinconflict  yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*Model 3
set seed 123
xtnbreg refugees gdppc_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_landarea yearinconflict  yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*Model 4
set seed 123
xtnbreg refugees polity_weighted log_bdeadhigh territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_landarea yearinconflict  yearinconflictSq countries_in500km, fe vce(boot, rep(100))

*TABLE A6****************************
*Model 1
set seed 1234
xtnbreg refugees log_bdeadlow yearinconflict yearinconflictSq gdppc_weighted europe middleeast asia africa, fe  vce(boot, rep(100))

*Model 2
set seed 2
xtnbreg refugees log_bdeadlow yearinconflict yearinconflictSq polity_weighted europe middleeast asia africa, fe  vce(boot, rep(100))

*Model 3
set seed 2
xtnbreg  refugees gdppc_weighted log_bdeadlow territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km europe middleeast asia africa, fe vce(boot, rep(100))

*Model 4
set seed 1
xtnbreg  refugees polity_weighted log_bdeadlow territoryincompatibility internationalization polity2 log_gdppc_gleditsch interstatewar genocide log_population_gleditsch yearinconflict yearinconflictSq countries_in500km europe middleeast asia africa, fe vce(boot, rep(100))

