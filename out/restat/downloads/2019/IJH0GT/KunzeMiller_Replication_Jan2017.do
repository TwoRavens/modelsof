* This file contains Stata code to create the tables in Kunze and Miller 
* Women Helping Women: Evidence from Private Sector Data on Workplace Hierarchies
* Review of Economics and Statistics 

* Programs are run on version 13.1 of Stata
* Do file date: 1/19/2017

log using KunzeMiller_Replication_Jan2017.log, replace
use KunzeMiller_regressiondataset

**************************************************************************************

display "Variable Creation"

**************************************************************************************

qui xi i.yr i.age i.eduy  
qui tab ind1, gen(IND)
drop IND1
qui tab level, gen(RANK)
gen exp2=exp*exp
gen kids_fem=kids*fem
gen kids6_fem=kids6*fem
gen rank=level
gen double hc=plant*100000+yr*10+rank

* create main gender spillover variables
gen femfrfembo=fem*fraclev_womboss1_RPY
gen femfrfem=fem*fraclev_wom_RPY
gen fracwom_inter= fraclev_wom_RPY * fraclev_womboss1_RPY 
gen femfracwom_inter= fem*fraclev_wom_RPY * fraclev_womboss1_RPY 

label define fem 0 "Male" 1 "Female", replace
label values fem fem
label variable RANK1 "Rank = 1"
label variable RANK2 "Rank = 2"
label variable RANK3 "Rank = 3"
label variable RANK4 "Rank = 4"
label variable RANK5 "Rank = 5"
label variable RANK6 "Rank = 6"
label variable RANK7 "Rank = 7"
label variable fem "Female"
label variable exp "Years Work Experience"
label variable exp2 "Years Experience Squared"
label variable tenure "Years Tenure"
label variable tenure2 "Years Tenure Squared"
label variable part "Working Part-Time"
label variable tenrank "Rank Specific Tenure"
label variable eduy "Years Schooling"
label variable kids "Any Children"
label variable kids6 "Children under 6"
label variable kids_fem "Female * Children"
label variable kids6_fem "Female * Children 6 or Under"
label variable hc "Plant-Year-Rank Index"
label variable promotion "Promotion"
label variable intpromotion "Internal Promotion"
label variable stayplant "Stay at Plant"
label variable fraclev_wom_RPY "Female Peer Share"
label variable fraclev_womboss1_RPY "Female Boss Share "
label variable fraclev_womboss2_RPY "Female Boss (+2) Share "
label variable femfrfembo "Female * Female Boss Share"
label variable femfrfem "Female * Female Peer Share"
label variable fracwom_inter "Female Peer Share * Female Boss Share "
label variable femfracwom_inter "Female * Female Peer * Female Boss"

* occupation groups
decode occupgr, gen(occ2)
gen occgroup = substr(occ2, 1, 1)
qui tab occgroup, gen(doccup)
drop doccup6
**************************************************************************************

display "Output for Tables 1 and 2"

**************************************************************************************

**************************************************************************************
* Define key vectors of variables
global xlist1 fem 
global controllistextralong RANK* _Iyr_* _Iage_* _Ieduy_* doccup* exp exp2 tenure tenure2 tenrank part
global xspill1 femfrfembo femfrfem fraclev_womboss1_RPY fraclev_wom_RPY 

**************************************************************************************

* List of Tables
* Table 1: Summary Stats by Sex (mean values of all covariates and outcomes) 
* Table 2: Gender spillovers - main measure of bosses/peers - 3 outcomes (panels); 3 models with diff controls (columns)
 
* define main estimation samples
qui reg promotion $xlist1 $controllistextralong IND* 
gen mainsample = e(sample) /* this sample includes all ranks and is used for top panel of Table 1 only */
qui reg promotion $xspill1 $controllistextralong IND* if level <=6
gen mainspillsample = e(sample) /* this sample is for the rest of Table 1 and for Table 2*/

**************************************************************************************

display "Table 1: Summary Statistics"

**************************************************************************************

keep if mainsample ==1
estpost tabstat RANK*, by(fem) columns(statistics)

keep if mainspillsample ==1
estpost tabstat fem promotion intpromotion stayplant age eduy exp tenure tenrank part kids kids6 fraclev_womboss1_RPY fraclev_wom_RPY, by(fem) columns(statistics)

drop RANK7
drop RANK6 /*reference group*/

************************************************************************************

display "Table 2: Gender Spillovers in Promotions and Mobility" 

************************************************************************************

foreach outvar in promotion intpromotion stayplant {
* basic controls
qui reg `outvar' $xspill1 $xlist1 $controllistextralong IND* , cluster(hc)
esttab,stats(N r2) label starlevels(* 0.10 ** 0.05 *** 0.01) cells(b(star fmt(a2)) se(fmt(a2) par ([ ])))  keep(femfrfembo femfrfem fraclev_womboss1_RPY fraclev_wom_RPY)

* plant FE
qui areg `outvar' $xspill1 $xlist1 $controllistextralong, cluster(hc) absorb(plant)
esttab,stats(N r2) label starlevels(* 0.10 ** 0.05 *** 0.01) cells(b(star fmt(a2)) se(fmt(a2) par ([ ])))  keep(femfrfembo femfrfem fraclev_womboss1_RPY fraclev_wom_RPY)

* children FE
qui areg `outvar' $xspill1 $xlist1 $controllistextralong kids kids6 kids_fem kids6_fem, cluster(hc) absorb(plant)
esttab,stats(N r2) label starlevels(* 0.10 ** 0.05 *** 0.01) cells(b(star fmt(a2)) se(fmt(a2) par ([ ])))  keep(femfrfembo femfrfem fraclev_womboss1_RPY fraclev_wom_RPY)

* Individual FE using Abowd-Kramarz estimation
display "Dependent variable: `outvar’"
qui felsdvreg `outvar' $xspill1 $xlist1 $controllistextralong, ivar(pid) jvar(plant) feff(feff) peff(peff) mover(mover) group(group) xb(xb) res(res) mnum(mnum) pobs(pobs) cluster(hc)
esttab, stats(N r2) label starlevels(* 0.10 ** 0.05 *** 0.01) cells(b(star fmt(a2)) se(fmt(a2) par ([ ])))  keep(femfrfembo femfrfem fraclev_womboss1_RPY fraclev_wom_RPY)
}

log close




