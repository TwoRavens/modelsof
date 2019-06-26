clear
clear matrix
set maxiter 25
set mem 50m
set more off

use "Colgan repl - Oil, democ, civil war - 2014Apr.dta", clear
tsset state_num year

/****  ANALYSIS
*****  Table I.  *****  
** Part 1: Violence is a good way to get regime overthrow and thus ttd
table inci_recent if ldem==0, c(m regchange m ttd n regchange)
ttest regchange if ldem==0, by(inci_recent)
ttest ttd if ldem==0, by(inci_recent)
** Part 2: Violence vs oil as a way to get regime overthrow and thus ttd
table inci_recent if ldem==0 & oilstate_1==0, c(m regchange m ttd n regchange)
table inci_recent if ldem==0 & oilstate_1==1, c(m regchange m ttd n regchange)
table oilstate_1 if ldem==0, c(m ttd n ttd)
** Selection Effect: Peaceful regime overthrows are different in petrostates **
table inci_recent oildichot if regchange==1 & ldem==0, c(m ttd n ttd)
ttest ttd if regchange==1 & ldem==0 & inci_recent==0, by(oildichot)
** Robustness check of Point 1: Pre- and post-1980
table inci_recent if ldem==0 & year>=1980, c(m regchange m ttd n regchange)
table inci_recent if ldem==0 & year<1980, c(m regchange m ttd n regchange)
table inci_recent if ldem==0 & oilstate_1==0 & year>=1980, c(m regchange m ttd n regchange)
table inci_recent if ldem==0 & oilstate_1==1 & year>=1980, c(m regchange m ttd n regchange)
table inci_recent if ldem==0 & oilstate_1==0 & year<1980, c(m regchange m ttd n regchange)
table inci_recent if ldem==0 & oilstate_1==1 & year<1980, c(m regchange m ttd n regchange)


*****  Table II (Regime-Change)  *****  
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 , nolog
estimates store regchange_basic
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 & inci_recent == 1 , nolog
estimates store regchange_inci
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 & inci_recent != 1 , nolog
estimates store regchange_noinci
xi: xtlogit regchange oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 , nolog
estimates store reginter 
* Checking results with conflict but without interaction effect
xi: xtlogit regchange oilstate_1 inci_recent ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 , nolog
estimates table regchange_basic reginter regchange_inci regchange_noinci , star(0.1 0.05 0.01)
estimates table regchange_basic reginter regchange_inci regchange_noinci , se


*****  Table III (Democratization) *****  
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
estimates store basic
* Interaction effect
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
estimates store interaction
*Removing the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==0
estimates store nowar
*Only the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==1
estimates store war
estimates table basic interaction war nowar, star(0.1 0.05 0.01)
estimates table basic interaction war nowar, se

** MAGNITUDE OF IMPACT ANALYSIS
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
adjust ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1, by(oilstate_1 inci_recent) pr ci 
adjust ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1, by(oilstate_1 inci_recent) pr 
margins, over(oilstate_1 inci_recent incioil_1) at((means) *)
** REPORTING RAW DATA FOR APPENDIX TABLE A-3
table oilstate_1 inci_recent, c(sum ttd n ttd)

*/
	
/**** ROBUSTNESS ANALYSIS - 2013 AUGUST - NOTE THAT ORDER OF ROBUSTNESS TABLES DOES NOT MATCH APPENDIX
** basic model, no robustness
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
estimates store basic
* Interaction effect
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
estimates store interaction
*Removing the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==0
estimates store nowar
*Only the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==1
estimates store war
estimates table basic interaction war nowar, star(0.1 0.05 0.01)
estimates table basic interaction war nowar, se

** Table Robust 1 - Using BOIX data 
replace bmr_ttd = 0 if code=="ROM" & year==1991
replace bmr_ttd = 1 if code=="ROM" & year==1990
** Main TTD Table USING BOIX DATA
xi: xtlogit bmr_ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
estimates store basic
* Interaction effect
xi: xtlogit bmr_ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 
estimates store interaction
*Removing the civil war years
xi: xtlogit bmr_ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==0
estimates store nowar
*Only the civil war years
xi: xtlogit bmr_ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==1 & year>1950
estimates store war
estimates table basic interaction war nowar, star(0.1 0.05 0.01)
estimates table basic interaction war nowar, se
	
** Table Robust 2 - prior democracy experience
  *Using priordem (dichotomous) instead of prevtran (count)
ren prevtran prevtranold 
ren priordem prevtran
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
estimates store basic
* Interaction effect
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
estimates store interaction
*Removing the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==0
estimates store nowar
*Only the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==1
estimates store war
estimates table basic interaction war nowar, star(0.1 0.05 0.01)
estimates table basic interaction war nowar, se
ren prevtran priordem 
ren prevtranold prevtran 

** Table Robust 3 - restrict time period to 1960-2002 
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & year>=1960 & year<=2002, nolog
estimates store basic
* Interaction effect
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & year>=1960 & year<=2002, nolog
estimates store interaction
*Removing the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==0 & year>=1960 & year<=2002
estimates store nowar
*Only the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==1 & year>=1960 & year<=2002
estimates store war
estimates table basic interaction war nowar, star(0.1 0.05 0.01)
estimates table basic interaction war nowar, se

** Table Robust 4 - 5-YEAR LAGS
sort code year
bys code (year): gen oilstate_5 = oilstate[_n-5]
bys code (year): gen ln_gdp_combo_5 = ln_gdp_combo[_n-5]
bys code (year): gen gdpgr5 = flgdpen[_n-1] / flgdpen[_n-6]
replace gdpgr5 = (gdpgr5 -1)*100
gen gdpgr_5 = gdpgr5
** Not lagged by 5 years: inci_recent, prevtran, muslim, royal_1
xi: xtlogit ttd oilstate_5 ln_gdp_combo_5 gdpgr_5 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
estimates store basic
* Interaction effect
xi: xtlogit ttd oilstate_5 inci_recent incioil_1 ln_gdp_combo_5 gdpgr_5 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
estimates store interaction
*Removing the civil war years
xi: xtlogit ttd oilstate_5 ln_gdp_combo_5 gdpgr_5 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==0
estimates store nowar
*Only the civil war years
xi: xtlogit ttd oilstate_5 ln_gdp_combo_5 gdpgr_5 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==1
estimates store war
estimates table basic interaction war nowar, star(0.1 0.05 0.01)
estimates table basic interaction war nowar, se

** Table Robust 6 - regional dummy controls
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.region i.year5dum if ldem==0, nolog
estimates store basic
* Interaction effect
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.region  i.year5dum if ldem==0, nolog
estimates store interaction
*Removing the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.region i.year5dum if ldem==0 & inci_recent==0
estimates store nowar
*Only the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.region i.year5dum if ldem==0 & inci_recent==1
estimates store war
estimates table basic interaction war nowar, star(0.1 0.05 0.01)
estimates table basic interaction war nowar, se

** Table Robust 7 - MidEast vs rest of world 
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & region!="mena", nolog
estimates store basic
* Interaction effect
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & region!="mena", nolog
estimates store interaction
*Removing the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==0 & region!="mena"
estimates store nowar
*Only the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==1 & region!="mena"
estimates store war
estimates table basic interaction war nowar, star(0.1 0.05 0.01)
estimates table basic interaction war nowar, se

** Table Robust 8 - GWF variables 
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim gwf_party gwf_military gwf_monarchy gwf_personal i.year5dum if ldem==0, nolog
estimates store basic
* Interaction effect
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim gwf_party gwf_military gwf_monarchy gwf_personal i.year5dum if ldem==0, nolog
estimates store interaction
*Removing the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim gwf_party gwf_military gwf_monarchy gwf_personal i.year5dum if ldem==0 & inci_recent==0
estimates store nowar
*Only the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim gwf_party gwf_military gwf_monarchy gwf_personal i.year5dum if ldem==0 & inci_recent==1
estimates store war
estimates table basic interaction war nowar, star(0.1 0.05 0.01)
estimates table basic interaction war nowar, se

** Table Robust 10 - civil wars instead of civil conflicts 
[Explain that Table 3 cannot be re-produced because there are no TTDs in petrostates with recent civil wars]
tab warinci_recent ttd if oilstate_1==1

** Table Robust 11 - add new controls: ColdWar dummy, ELF, Colonial/Communist legacy 
*[only model 2 of table 3]
/*basic model
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
estimates store interaction
*/
* with Cold War
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 coldwar i.year5dum if ldem==0, nolog
estimates store cold
* with EthFrac ELF
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 ethfrac i.year5dum if ldem==0, nolog
estimates store ethfrac
* with OECD
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 OECD i.year5dum if ldem==0, nolog
estimates store oecd
* with Colonial/Communist legacies
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 leg* i.year5dum if ldem==0, nolog
estimates store legacy
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 polariz i.year5dum if ldem==0, nolog
estimates store polariz
estimates table cold ethfrac oecd legacy polariz, star(0.1 0.05 0.01)
estimates table cold ethfrac oecd legacy polariz, se

** Table Robust 12 - Fixed Effects
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog fe
estimates store basic
* Interaction effect
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog fe
estimates store interaction
*Removing the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==0, fe
estimates store nowar
*Only the civil war years
xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0 & inci_recent==1, fe
estimates store war
estimates table basic interaction war nowar, star(0.1 0.05 0.01)
estimates table basic interaction war nowar, se


** Table Robust 14 - varying the oil-income threshold of petrostate 
*[only model 2 of table 3]
*[create new oilstate_1 and incioil_1 variables using different thresholds; see below]
xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
estimates store interaction
estimates store oil80
estimates store oil120
/* For a true linear measure of the interaction variable, use this alternative code
gen incioilrent = oilrentpc*inci_recent
bys code (year): gen incioilrent_1 = incioilrent[_n-1]
xi: xtlogit ttd oilrentpc_1 inci_recent incioilrent_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
*/
xi: xtlogit ttd oilrentpc_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
estimates store linear
estimates table interaction linear oil80 oil120 , star(0.1 0.05 0.01)
estimates table interaction linear oil80 oil120, se
	
/** Oilstate Threshold Modification
ren oilstate oilstate_old
ren oilstate_1 oilstate_1old
gen oilstate = 0
replace oilstate = 1 if oilrentpc > 120 & oilrentpc !=.
sort code year
by code: gen oilstate_1=oilstate[_n-1]
replace incioil_1 = inci_recent*oilstate_1
replace warincioil_1 = warinci_recent*oilstate_1
*/
/* Reverseing the threshold checks
drop oilstate oilstate_1
ren oilstate_old oilstate 
ren oilstate_1old oilstate_1 
replace incioil_1 = inci_recent*oilstate_1
replace warincioil_1 = warinci_recent*oilstate_1
*/
  *Linear oil measure
ren lnoilalt_1 lnoilalt_1old
ren oil_gas_val_1 lnoilalt_1 
  ** run models
ren lnoilalt_1 oil_gas_val_1
ren lnoilalt_1old lnoilalt_1 
	
/* SURVIVAL ANALYSIS
*BASIC XTSET COMMAND: xi: xtlogit ttd oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog
*OTHER XTSET COMMAND: xi: xtlogit ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 i.year5dum if ldem==0, nolog

* Step 1: Eliminate ineligible observations, when state is a democracy
* might want to create a variable of "time since last democracy"
keep if ldem == 0

* Step 2: Create ID variable for each new transition to democracy -- use prevtran?
egen obs_id = group(state_num prevtran)

* Step 3: Create a survival time variable
bys obs_id (year): gen survtime = _N

* Step 4: Collapse
collapse ccode (mean) survtime (max) ttd (max) year (mean) oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 , by(obs_id)
*collapse (sum) survivaltime (max) status x1, by(id)

* Step 5: Create indicator of censored value
gen cens = 0
replace cens = 1 if year == 2004

* Step 6: Set data
*stset survtime, failure(cens)
stset survtime, failure(ttd)
*stset survtime, failure(bmr_ttd)

* Step 7: Create graphs
gen oilgroup = 0
replace oilgroup = 1 if oilstate_1==1
replace oilgroup = . if oilstate_1>0 & oilstate_1<1
sts graph, by(oilgroup) title("Democratization")

* Step 8: Run regression
stcox oilstate_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 
estimates store base
stcox oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran muslim royal_1 
estimates store inter
estimates table base inter, se
estimates table base inter, star(0.1 0.05 0.01)
tab ccode if e(sample)==1
tab ttd if e(sample)==1
*/

/* ROBUSTNESS OF REGIME CHANGE FOR REVIEWER 1, 2014 FEB
[BASE MODELS]
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 , nolog
estimates store regchange_basic
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 & inci_recent == 1 , nolog
estimates store regchange_inci
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 & inci_recent != 1 , nolog
estimates store regchange_noinci
xi: xtlogit regchange oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 , nolog
estimates store reginter 
estimates table regchange_basic reginter regchange_inci regchange_noinci , star(0.1 0.05 0.01)
estimates table regchange_basic reginter regchange_inci regchange_noinci , se

** Table Robust 1 - Using BOIX data
*replace bmr_ttd = 0 if code=="ROM" & year==1991
*replace bmr_ttd = 1 if code=="ROM" & year==1990
*gen bmr_trans2 = bmr_trans
*replace bmr_trans2 = 1 if bmr_trans==-1
xi: xtlogit bmr_trans oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 , nolog
estimates store regchange_basic
xi: xtlogit bmr_trans oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 & inci_recent == 1 , nolog
estimates store regchange_inci
xi: xtlogit bmr_trans oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 & inci_recent != 1 , nolog
estimates store regchange_noinci
xi: xtlogit bmr_trans oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 , nolog
estimates store reginter 
estimates table regchange_basic reginter regchange_inci regchange_noinci , star(0.1 0.05 0.01)
estimates table regchange_basic reginter regchange_inci regchange_noinci , se

** Table Robust 2 - prior democracy experience
 *Using priordem (dichotomous) instead of prevtran (count)
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 priordem muslim royal_1 i.year5dum if ldem==0 , nolog
estimates store regchange_basic
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 priordem muslim royal_1 i.year5dum if ldem==0 & inci_recent == 1 , nolog
estimates store regchange_inci
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 priordem muslim royal_1 i.year5dum if ldem==0 & inci_recent != 1 , nolog
estimates store regchange_noinci
xi: xtlogit regchange oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 priordem muslim royal_1 i.year5dum if ldem==0 , nolog
estimates store reginter 
estimates table regchange_basic reginter regchange_inci regchange_noinci , star(0.1 0.05 0.01)
estimates table regchange_basic reginter regchange_inci regchange_noinci , se

** Table Robust 3 - restrict time period to 1960-2002
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 & year>=1960 & year<=2002, nolog
estimates store regchange_basic
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 & year>=1960 & year<=2002 & inci_recent == 1 , nolog
estimates store regchange_inci
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 & year>=1960 & year<=2002 & inci_recent != 1 , nolog
estimates store regchange_noinci
xi: xtlogit regchange oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 & year>=1960 & year<=2002, nolog
estimates store reginter 
estimates table regchange_basic reginter regchange_inci regchange_noinci , star(0.1 0.05 0.01)
estimates table regchange_basic reginter regchange_inci regchange_noinci , se

** Table Robust 4 - GWF variables
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim gwf_party gwf_military gwf_monarchy gwf_personal i.year5dum if ldem==0 , nolog
estimates store regchange_basic
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim gwf_party gwf_military gwf_monarchy gwf_personal i.year5dum if ldem==0 & inci_recent == 1 , nolog
estimates store regchange_inci
xi: xtlogit regchange oilstate_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim gwf_party gwf_military gwf_monarchy gwf_personal i.year5dum if ldem==0 & inci_recent != 1 , nolog
estimates store regchange_noinci
xi: xtlogit regchange oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim gwf_party gwf_military gwf_monarchy gwf_personal i.year5dum if ldem==0 , nolog
estimates store reginter 
estimates table regchange_basic reginter regchange_inci regchange_noinci , star(0.1 0.05 0.01)
estimates table regchange_basic reginter regchange_inci regchange_noinci , se

** Table Robust 5 - add new controls: ColdWar dummy, ELF, Colonial/Communist legacy 
*[only model 2 of table 2]
/*basic model
xi: xtlogit regchange oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 , nolog
estimates store reginter 
*/
* with Cold War
xi: xtlogit regchange oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 coldwar i.year5dum if ldem==0 , nolog
estimates store cold
* with EthFrac ELF
xi: xtlogit regchange oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 ethfrac i.year5dum if ldem==0 , nolog
estimates store ethfrac
* with OECD
xi: xtlogit regchange oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 OECD i.year5dum if ldem==0 , nolog
estimates store oecd
* with Colonial/Communist legacies
xi: xtlogit regchange oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 leg* i.year5dum if ldem==0 , nolog
estimates store legacy
estimates table cold ethfrac oecd legacy, star(0.1 0.05 0.01)
estimates table cold ethfrac oecd legacy, se

** Table Robust 6 - varying the oil-income threshold of petrostate
*[only model 2 of table 3]
xi: xtlogit regchange oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 , nolog
estimates store reginter 
estimates store oil80
estimates store oil120
/* For a true linear measure of the interaction variable, use this alternative code
gen incioilrent = oilrentpc*inci_recent
bys code (year): gen incioilrent_1 = incioilrent[_n-1]
xi: xtlogit regchange oilrentpc_1 inci_recent incioilrent_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 , nolog
*/
xi: xtlogit regchange oilrentpc_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevregchange muslim royal_1 i.year5dum if ldem==0 , nolog
estimates store linear
estimates table reginter linear oil80 oil120 , star(0.1 0.05 0.01)
estimates table reginter linear oil80 oil120, se
estimates table reginter linear , star(0.1 0.05 0.01)
estimates table reginter linear , se
*/


/**** OTHER QUESTIONS
** Checking the GDP per capita completeness 
count if ldem==0 
count if ldem==0 & flgdpen!=.
count if ldem==0 & ln_gdp_combo_1!=.
corr lgdp ln_gdp_pc

** Table of Petrostate TTDs
list code year lnoilalt_1 prevtran inci_recent if (lnoilalt_1>0 & lnoilalt_1!=.) & ttd==1

** Coordination of opposition groups
table ttd if oilstate_1==1, c(m relfrac m top20 m wdi_gini m ethfrac) 
table ttd if oilstate_1==1, c(n relfrac n top20 n wdi_gini n ethfrac) 
ttest relfrac if oilstate_1==0 , by(ttd)
ttest top20 if oilstate_1==0 , by(ttd)
ttest wdi_gini if oilstate_1==0 , by(ttd)
table ttd if oilstate_1==1 & ldem==0, c(m relfrac m top20 m wdi_gini m ethfrac)

** CINC question
gen milexpc = milex/tpop if milex>=0
table oilstate_1 if ldem==0, c(m milexpc_real n milexpc_real)

** Fixed Effects discussion
gen oilrentclass = 0
replace oilrentclass = 1 if oilrentpc>100
replace oilrentclass = 2 if oilrentpc>500
replace oilrentclass = 3 if oilrentpc>1000
replace oilrentclass = . if oilrentpc==.
list code year lnoilalt_1 prevtran inci_recent if (lnoilalt_1>0 & lnoilalt_1!=.) & ttd==1
list code year lnoilalt_1 prevtran oilrentpc inci_recent if (lnoilalt_1>0 & lnoilalt_1!=.) & ttd==1
*/

/** DESCRIPTIVE STATISTICS
sum year regchange ttd oilstate_1 inci_recent incioil_1 ln_gdp_combo_1 gdpgr_1 prevtran prevregchange muslim royal_1 ldem warinci_recent warincioil_1
*/
