*********************************************************************************************************************************************
*                                                                                                                                           *
* International Migration and Military Intervention in Civil War                                                                            *
*                                                                                                                                           *
* Vincenzo Bove and Tobias Böhmelt              			                                                                                *
*                                                                                                                                           *
* This Version: May 19, 2017	           				                                   	                                                *
*                                                                                                                                           *
* Address Correspondence to: tbohmelt@essex.ac.uk                                                                                           *
*                                                                                                                                           *
*                                                                                                                                           *
* The replication material requires the clarify package -- please install before use, see (including instructions for how to install :      *
*                                                                                                                                           *
* net describe clarify, from(http://gking.harvard.edu/clarify)                                                                              *
*                                                                                                                                           *
* The replication material also requires the relogit command -- please install before use, see (including instructions for how to install : *
*                                                                                                                                           *
* http://gking.harvard.edu/relogit                                                                                                          *
*********************************************************************************************************************************************

log using "PSRM_Bove_Boehmelt.smcl"

*************
* Open Data *
*************

use "Final Data.dta", clear

*******************************
* Variable Labels and Table 1 *
*******************************

label var mili_intervention "Probability of Military Intervention"
label var ally "Alliance Ties"
label var third_polity "Third-Party Polity"
label var con_polity "Target-State Polity"
label var lratio "Capability Ratio"
label var majpow2 "Major Power"
label var reb_relstr "Rebel Strength"
label var premilint "Previous Intervention"
label var spellmili "t"
label var spellmili2 "t2"
label var spellmili3 "t3"
label var ethnictie "Ethnic Ties"
label var lndistance "Distance"
label var Coldwar "Cold War"
label var lMigrants "Third-Party Immigrants"
label var liMigrants "Third-Party Immigrants"
label var lMigrantsBA "Third-Party Emigrants"
label var liMigrantsBA "Third-Party Emigrants"
label var  colony "Colonial History"

sum mili_intervention ally third_polity con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3 liMigrants liMigrantsBA

**********************************************
* Baseline Probit Regression Model - Table 2 *
**********************************************

global controls "ally third_polity con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3"

probit mili_intervention $controls liMigrants, cluster(id) nolog
probit mili_intervention $controls liMigrantsBA, cluster(id) nolog
probit mili_intervention $controls liMigrants liMigrantsBA, cluster(id) nolog

********************************************************************
* Table 3 - Increase from Mean by One Standard Deviation - Table 3 *
********************************************************************
 
estsimp probit mili_intervention ally third_polity con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3 liMigrants liMigrantsBA, cluster(id)
setx median 
simqi, fd(prval(1)) changex(ally 0 1) level(90)
simqi, fd(prval(1)) changex(third_polity 10.198706 17.869929) level(90)
simqi, fd(prval(1)) changex(con_polity 9.3813666 16.180406) level(90)
simqi, fd(prval(1)) changex(lratio -.57192844 1.6079606) level(90)
simqi, fd(prval(1)) changex(majpow2 0 1) level(90)
simqi, fd(prval(1)) changex(reb_relstr 1.8393795 2.5894791) level(90)
simqi, fd(prval(1)) changex(colony 0 1) level(90)
simqi, fd(prval(1)) changex(ethnictie 0 1) level(90)
simqi, fd(prval(1)) changex(lndistance 8.3003516 9.0302015) level(90)
simqi, fd(prval(1)) changex(Coldwar 0 1) level(90)
simqi, fd(prval(1)) changex(premilint 0 1) level(90)
simqi, fd(prval(1)) changex(spellmili min max) level(90)
simqi, fd(prval(1)) changex(liMigrants 3.1485887 6.3937814) level(90)
simqi, fd(prval(1)) changex(liMigrantsBA 2.7334111 5.716233) level(90)
drop b* 
 
***************************************************************
* Baseline Probit Regression Model with Interaction - Table 4 *
***************************************************************

global controls "ally third_polity con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3"

generate interaction1=liMigrants*third_polity
generate interaction2=liMigrantsBA*third_polity
label var interaction1 "Th.-Pa. Immigrants * Th.-Pa. Polity"
label var interaction2 "Th.-Pa. Emigrants * Th.-Pa. Polity"

probit mili_intervention $controls liMigrants interaction1, cluster(id) nolog
probit mili_intervention $controls liMigrantsBA interaction2, cluster(id) nolog
probit mili_intervention $controls liMigrants liMigrantsBA interaction1 interaction2, cluster(id) nolog

********************************
* Interaction Plots - Figure 1 *
********************************

probit mili_intervention ally con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3 c.liMigrants##c.third_polity c.liMigrantsBA##c.third_polity, cluster(id)
sum third_polity if e(sample)
margins, dydx(liMigrants) at(third_polity=(0(1)20)) vsquish
marginsplot, recast(line) recastci(rline) yline(0) level(90) scheme(lean1) name(graph1, replace)

probit mili_intervention ally con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3 c.liMigrants##c.third_polity c.liMigrantsBA##c.third_polity, cluster(id)
sum third_polity if e(sample)
margins, dydx(liMigrantsBA) at(third_polity=(0(1)20)) vsquish
marginsplot, recast(line) recastci(rline) yline(0) level(90) scheme(lean1) name(graph2, replace)

graph combine graph1 graph2, ycommon
 
**************************************************************
* Appendix Table A1: Major Powers or Contiguity Restrictions *
**************************************************************
 
probit mili_intervention $controls liMigrants if majpow2==1 | contig<3, cluster(id) nolog
probit mili_intervention $controls liMigrantsBA if majpow2==1 | contig<3, cluster(id) nolog
probit mili_intervention $controls liMigrants liMigrantsBA if majpow2==1 | contig<3, cluster(id) nolog

**********************************
* Appendix Table A2: 5-Year Lags *
**********************************

xtset id year

by id: gen l5 = l5.lMigrants
by id: gen li5 = l5.liMigrants
by id: gen l5BA = l5.lMigrantsBA
by id: gen li5BA = l5.liMigrantsBA

label var l5  "Third-Party Immigrants(t-5)"
label var li5 "Third-Party Immigrants(t-5)"
label var l5BA "Third-Party Emigrants(t-5)"
label var li5BA "Third-Party Emigrants(t-5)"

probit mili_intervention $controls li5, cluster(id) nolog
probit mili_intervention $controls li5BA, cluster(id) nolog
probit mili_intervention $controls li5 li5BA, cluster(id) nolog

***********************************
* Appendix Table A3: 10-Year Lags *
***********************************

xtset id year

by id: gen l10 = l10.lMigrants
by id: gen li10 = l10.liMigrants
by id: gen l10BA = l10.lMigrantsBA
by id: gen li10BA = l10.liMigrantsBA

label var l10  "Third-Party Immigrants(t-10)"
label var li10 "Third-Party Immigrants(t-10)"
label var l10BA "Third-Party Emigrants(t-10)"
label var li10BA "Third-Party Emigrants(t-10)"

probit mili_intervention $controls li10, cluster(id) nolog
probit mili_intervention $controls li10BA, cluster(id) nolog
probit mili_intervention $controls li10 li10BA, cluster(id) nolog

***********************************
* Appendix Table A4: 15-Year Lags *
***********************************

xtset id year

by id: gen l15 = l15.lMigrants
by id: gen li15 = l15.liMigrants
by id: gen l15BA = l15.lMigrantsBA
by id: gen li15BA = l15.liMigrantsBA

label var l15  "Third-Party Immigrants(t-15)"
label var li15 "Third-Party Immigrants(t-15)"
label var l15BA "Third-Party Emigrants(t-15)"
label var li15BA "Third-Party Emigrants(t-15)"

probit mili_intervention $controls li15, cluster(id) nolog
probit mili_intervention $controls li15BA, cluster(id) nolog
probit mili_intervention $controls li15 li15BA, cluster(id) nolog

**************************************************
* Appendix Table A5: Model without Interpolation *
**************************************************

probit mili_intervention $controls lMigrants, cluster(id) nolog
probit mili_intervention $controls lMigrantsBA, cluster(id) nolog
probit mili_intervention $controls lMigrants lMigrantsBA, cluster(id) nolog
 
************************************************
* Appendix Tables A6 & A7: Biased Intervention *
************************************************

gen int_gov = 0
gen int_opp  = 0
replace int_opp = 1 if typeint==1
replace int_gov = 1 if typeint==2
label var int_opp "Opposition-Biased Intervention"
label var int_gov "Government-Biased Intervention"

global controls "ally third_polity con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3"

global controls_nocolony "ally third_polity con_polity lratio majpow2 reb_relstr ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3"

probit int_gov $controls liMigrants, cluster(id) nolog
probit int_gov $controls liMigrantsBA, cluster(id) nolog
probit int_gov $controls liMigrants liMigrantsBA, cluster(id) nolog
 
probit int_opp $controls_nocolony liMigrants, cluster(id) nolog
probit int_opp $controls_nocolony liMigrantsBA, cluster(id) nolog
probit int_opp $controls_nocolony liMigrants liMigrantsBA, cluster(id) nolog

**************************************************
* Appendix Table A8: US-Russia Regression Models *
**************************************************

gen US_dummy=0
replace US_dummy=1 if ccode2==2

gen USSR_dummy=0
replace USSR_dummy=1 if ccode2==365

global controls "US_dummy USSR_dummy ally third_polity con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3"

probit mili_intervention $controls liMigrants, cluster(id) nolog
probit mili_intervention $controls liMigrantsBA, cluster(id) nolog
probit mili_intervention $controls liMigrants liMigrantsBA, cluster(id) nolog

*****************************************************
* Appendix Table A9: Reduced Baseline Probit Models *
*****************************************************

probit mili_intervention liMigrants spellmili spellmili2 spellmili3, cluster(id) nolog
probit mili_intervention liMigrantsBA spellmili spellmili2 spellmili3, cluster(id) nolog
probit mili_intervention liMigrants liMigrantsBA spellmili spellmili2 spellmili3, cluster(id) nolog

************************************************
* Appendix Table A10: Rare Events Logit Models *
************************************************

global controls "ally third_polity con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3"

relogit mili_intervention $controls liMigrants, cluster(id)
relogit mili_intervention $controls liMigrantsBA, cluster(id)
relogit mili_intervention $controls liMigrants liMigrantsBA, cluster(id)

**************************************
* Appendix Figure 1: Democracy Dummy *
**************************************

gen democracy_dummy=third_polity-10
replace democracy_dummy=0 if democracy_dummy<6 & democracy_dummy!=.
replace democracy_dummy=1 if democracy_dummy>5 & democracy_dummy!=.

probit mili_intervention ally con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3 c.liMigrants##i.democracy_dummy c.liMigrantsBA##i.democracy_dummy, cluster(id)
sum liMigrants if e(sample)
margins, at(democracy_dummy=(0 1) liMigrants=(0(0.5)15.71)) vsquish
marginsplot, x(liMigrants) recast(line) noci yline(0) legend(off) ylabel(0(0.01)0.03) scheme(lean1) name(graph1, replace)

probit mili_intervention ally con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3 c.liMigrants##i.democracy_dummy c.liMigrantsBA##i.democracy_dummy, cluster(id)
sum liMigrantsBA if e(sample)
margins, at(democracy_dummy=(0 1) liMigrantsBA=(0(0.5)15.33)) vsquish
marginsplot, x(liMigrantsBA) recast(line) noci yline(0) legend(off) ylabel(0(0.01)0.03) scheme(lean1) name(graph2, replace)

graph combine graph1 graph2, ycommon

*********************************************************************
* Appendix Table A11: Baseline Model + Refugees + Relocation Costs  *
*********************************************************************

use "MooreandShellman2007.dta", clear
rename origasy id

merge m:m id year using "Final Data.dta"
drop _merge
merge m:m ccode1 ccode2  using "cultdistAB_BA.dta"
drop  _merge
merge m:m ccode1 ccode2  year using "HOR_JPR_table3_AB_BA.dta"

gen logGDPpc1 = log(rgdp_a/tpop_a)
gen logGDPpc2 = log(rgdp_b/tpop_b)
gen logPop1 = log(tpop_a)
gen logPop2 = log(tpop_b)
gen lagnppc = log(agnppc+1)
gen lognppc = log(ognppc+1)
gen lrelocost = log(relocost+1)
gen larefreloccosts = log(arefreloccosts +1)
gen lrefflow2 = log(refflow2+1)
gen immigXtreat = liMigrants*aRefTreaty
gen emigXtreat = liMigrantsBA*aRefTreaty

drop if missing(mili_intervention)
  
global controls "ally third_polity con_polity lratio majpow2 reb_relstr colony ethnictie Coldwar premilint spellmili spellmili2 spellmili3"

global controls2 "lrelocost lrefflow2"

probit mili_intervention $controls $controls2 liMigrants, cluster(id) nolog
probit mili_intervention $controls $controls2 liMigrantsBA, cluster(id) nolog
probit mili_intervention $controls $controls2 liMigrants liMigrantsBA, cluster(id) nolog

****************************************************
* Appendix Table A12: Additional Control Variables *
****************************************************

global controls "ally third_polity con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3"
global controls2 "logGDPpc1 logGDPpc2 logPop1 logPop2 lnrtrade lingdist_weighted_formula reldist_weighted_WCD_form fst_distance_weighted"

probit mili_intervention $controls $controls2 liMigrants, cluster(id) nolog
probit mili_intervention $controls $controls2 liMigrantsBA, cluster(id) nolog
probit mili_intervention $controls $controls2 liMigrants liMigrantsBA, cluster(id) nolog

*************************************
* Appendix Table A13: Fixed Effects *
*************************************

use "Final Data.dta", clear

global controls "ally third_polity con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3"

probit mili_intervention $controls liMigrants i.ccode1 i.ccode2 , cluster(id) nolog
probit mili_intervention $controls liMigrantsBA  i.ccode1 i.ccode2, cluster(id) nolog
probit mili_intervention $controls liMigrants liMigrantsBA i.ccode1 i.ccode2, cluster(id) nolog

***************************************************
* Appendix Table A14: Simultaneous Equation Model *
***************************************************

reg3 (liMigrantsBA ally third_polity con_polity colony ethnictie lndistance) (mili_intervention liMigrants liMigrantsBA lratio majpow2 reb_relstr Coldwar premilint spellmili spellmili2 spellmili3)

***************************************
* Appendix Table A15: Age of Diaspora *
***************************************

global controls "ally third_polity con_polity lratio majpow2 reb_relstr colony ethnictie lndistance Coldwar premilint spellmili spellmili2 spellmili3"
probit mili_intervention $controls liMigrants liMigrantsBA diaspora_yrs, cluster(id) nolog

log close
