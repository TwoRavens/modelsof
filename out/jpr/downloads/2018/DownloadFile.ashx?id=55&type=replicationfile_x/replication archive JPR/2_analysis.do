version 13.0
clear
capture log close
set more off, permanently

* NOTE: set working directory to local folder
cd "C:\Users\haass\Dropbox\Work\Papers\Peacekeeping\Paper PKO Troop Quality and OSV\Data\replication archive JPR"


******* (1) Load Data *******

* cd "Replication Archive"
use ./data/pko_qual.dta, clear

****** (2) Main Analysis Table 2 in the Main Text

**** (2a) All OSV ****
nbreg osvAll c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration , cluster(conflictid)

eststo all_osv

**** (2b) Matched Sample * optimal matching with mahalanbois distance ****
use ./data/match_pko_optimal.dta, replace

nbreg osvAll  c.quality_pc_lag c.trooplag policelag militaryobserverslag ///
 logpop allbrds_lag osvallLagDum duration, cluster(conflictid)

eststo all_osv_matched

**** (2c) Fixed Effects ****
use ./data/pko_qual.dta, replace

xtset conflictid_num

xtnbreg osvAll c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
duration logpop allbrds_lag osvallLagDum , fe

eststo all_osv_fe

**** (2d) FE + cubic time trend  ****

gen duration_sq = duration^2
gen duration_cub = duration^3

xtnbreg osvAll c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
logpop allbrds_lag osvallLagDum duration  duration_sq duration_cub, fe

eststo all_osv_fe_time


***** (2e) FE & PKO Missions Only ******
xtset mission_num

xtnbreg osvAll c.quality_pc_lag trooplag policelag militaryobserverslag  ///
logpop allbrds_lag osvallLagDum duration  if mission != "NA", fe

eststo pko_only_fe

* Output Table 2 in main text
esttab all_osv all_osv_matched all_osv_fe all_osv_fe_time pko_only_fe using ./output/table_2.rtf, ///
replace cells(b(star fmt(4)) se(par fmt(2))) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
stats(alpha N N_clust chi2 ll, fmt(2 2 0)) legend ///
onecell nodep  gaps  compress ///
mtitles("Base Model (1)" "Matching (2)" "Fixed Effects (3)" "FE + Cubic Time Trend (4)" "FE + PKO Only (5)") ///
order(quality_exp_lag) ///
title({\b Table 2.} {Effect of Peacekeeping Troop Quality on One-Sided Violence against civilians, 1991-2013}) ///
coef(trooplag "UN Troops (t-1)" quality_exp_lag "Troop Quality (t-1)" policelag "UN Police (t-1)" ///
militaryobserverslag "UN Observers (t-1)" duration "Conflict Duration" incompatibility "Government Conflict" ///
logpop "Population" allbrds_lag "All Battle Deaths (t-1)" rebbrds_lag "Rebel Battle Deaths (t-1)" ///
govbrds_lag "Govt. Battle Deaths (t-1)" osvallLagDum "All OSV Dummy (t-1)" osvreb_lag "Rebel OSV (t-1)" ///
osvrebLagDum "Rebel OSV Dummy (t-1)" osvgov_lag "Govt. OSV (t-1)" osvgovlagDum "Govt. OSV Dummy" ///
_cons "Constant" alpha "Alpha" quality_pc_lag "Troop Quality (t-1)") ///
nonumbers ///
nobaselevels


**** 3 Substantive effects ****

* The following simulations produce Figure 3 in the main text.

*** Troop Quality **

set scheme s1mono

use ./data/pko_qual.dta, replace

* Clarify simulations Figure 2.1 (left panel)
estsimp nbreg osvAll quality_pc_lag trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration  ///
, cluster(conflictid)

generate expectedvalue = .
generate upperci = .
generate lowerci = .

generate xaxis = _n-1 in 1/260

setx mean
setx incompatibility 1
setx osvallLagDum 1

forval i=0(10)260 {
setx quality_pc_lag `i' 
simqi, genev(pi)
_pctile pi, p(2.5,97.5)

replace lowerci = r(r1) if xaxis ==`i' 
replace upperci = r(r2) if xaxis ==`i'

sum pi
replace expectedvalue = r(mean) if xaxis ==`i'
drop pi

}


* Output left panel of Figure 2
twoway (hist quality_pc_lag if quality_pc_lag > 0, yaxis(2) fcolor(gs14) lcolor(white)) ///
(line upperci xaxis, yaxis(1) lpattern(-) ) ///
(line lowerci xaxis, yaxis(1) lpattern(-) ) ///
(line expectedvalue xaxis, yaxis(1) lcolor(black)), ytitle(Expected number of civilians killed) ///
yscale(range(0 40) axis(1)) ylabel(0(10)40, axis(1)) ytitle(Percent of observations,axis(2)) xtitle(Troop quality in million USD / soldier) ///
xscale(range(0 260)) xlabel(0(20)260) yscale(alt axis(2)) yscale(alt axis(1)) legend(off)
* note(Values measured in 1000 troops) 
graph export ./figures/figure_3a.png, replace width(2550) 


drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11
drop expectedvalue
drop upperci
drop lowerci
drop xaxis


*************************************
* ME of troop size; from model (2a) *
*************************************

nbreg osvAll c.quality_pc_lag c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration  ///
, cluster(conflictid)

estsimp nbreg osvAll trooplag quality_pc_lag policelag militaryobserverslag duration ///
incompatibility logpop allbrds_lag osvallLagDum  ///
, cluster(conflictid)

generate expectedvalue = .
generate upperci = .
generate lowerci = .

generate xaxis = _n-1 in 1/29

setx mean
setx incompatibility 1
setx osvallLagDum 1

forval i=0(0.5)29 {
setx trooplag `i' 
simqi, genev(pi)
_pctile pi, p(2.5,97.5)

replace lowerci = r(r1) if xaxis ==`i' 
replace upperci = r(r2) if xaxis ==`i'

sum pi
replace expectedvalue = r(mean) if xaxis ==`i'
drop pi

}



twoway (hist trooplag if quality_pc_lag > 0, yaxis(2) fcolor(gs14) lcolor(white)) ///
(line upperci xaxis, yaxis(1) lpattern(-) ) ///
(line lowerci xaxis, yaxis(1) lpattern(-) ) ///
(line expectedvalue xaxis, yaxis(1) lcolor(black)), ytitle(Expected number of civilians killed) ///
yscale(range(0 50) axis(1)) ylabel(0(10)50, axis(1)) ytitle(Percent of observations,axis(2)) xtitle(Troop size) ///
xscale(range(0 29)) xlabel(0(5)29) yscale(alt axis(2)) yscale(alt axis(1)) legend(off)
* note(Values measured in 1000 troops) 
graph export ./figures/figure_3b.png, replace width(2550) 


drop b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 b11
drop expectedvalue
drop upperci
drop lowerci
drop xaxis

**** (4) Mechanisms ****

* These models provide the basis for Figures 3 to 6 in the main text

use ./data/pko_qual.dta, replace

* 4.1 Deterrence: OSV in future months
quietly nbreg osvAll c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo zeromonth

quietly nbreg osvAll_1month c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo onemonth

quietly nbreg osvAll_2month c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo twomonth

quietly nbreg osvAll_3month c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo threemonth

quietly nbreg osvAll_4month c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo fourmonth

quietly nbreg osvAll_5month c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo fivemonth

nbreg osvAll_6month c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo sixmonth


nbreg osvAll_12month c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo twelvemonth

* Output table C1 (deterrence) for Appendix
esttab zeromonth onemonth twomonth threemonth fourmonth fivemonth sixmonth twelvemonth /// 
using ./output/table_c1.rtf, ///
replace cells(b(star fmt(2)) se(par fmt(2))) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
stats(alpha N N_clust chi2 ll, fmt(2 2 0)) legend ///
onecell nodep  gaps  compress ///
title({\b Table C1.} {Deterrence}) ///
rename(quality_exp_lag quality_pc_lag) ///
coef(trooplag "UN Troops (t-1)" quality_pc_lag "Troop Quality (t-1)" policelag "UN Police (t-1)" ///
militaryobserverslag "UN Observers (t-1)" duration "Conflict Duration" incompatibility "Government Conflict" ///
logpop "Population" allbrds_lag "All Battle Deaths (t-1)" rebbrds_lag "Rebel Battle Deaths (t-1)" ///
govbrds_lag "Govt. Battle Deaths (t-1)" osvallLagDum "All OSV Dummy (t-1)" osvreb_lag "Rebel OSV (t-1)" ///
osvrebLagDum "Rebel OSV Dummy (t-1)" osvgov_lag "Govt. OSV (t-1)" osvgovlagDum "Govt. OSV Dummy" ///
_cons "Constant" alpha "Alpha" rugged "Rugged Terrain" cease "Ceasefire" pocenforce "Protection Mandate" ///
non_un_troops1000 "Non-UN Troops" FracTroop "Troop Fractionalization" PolTroop "Troop Polarization") ///
nonumbers ///
mtitles("Reference Month (1)" "1 Month" "2 Months" "3 Months" "4 Months" "5 Months" "6 Months" "12 Months") ///
nobaselevels

** output to .csv and plot coefficients in R
esttab zeromonth onemonth twomonth threemonth fourmonth fivemonth sixmonth twelvemonth ///
using ./temp/table_c1.csv, replace cells(b(star fmt(6)) se(par fmt(6))) starlevels()
** to generate plot, run generate_deterrence_plot.R

*** 4.2 Logistics / Rainfall: Figure 4 ***

nbreg osvAll c.quality_pc_lag  c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration c.ln_rain_lag   ///
, cluster(conflictid)
eststo without_interaction_rain

nbreg osvAll c.quality_pc_lag  c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration rugged   ///
, cluster(conflictid)
eststo rugged

nbreg osvAll c.quality_pc_lag##c.ln_rain_lag c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)
eststo rain

* marginal effects plot
margins, dydx(quality_pc_lag) at(ln_rain_lag=(0(0.5)6.5) incompatibility = 1 osvallLagDum = 1) atmeans

* output to txt to plot in R (requires ssc install mat2txt)
matrix A = r(table)
mat2txt, matrix(A) saving(./temp/figure_4_rain.txt) replace

* To produce Figure 4, run plot_ME_mechanisms

* Output table C2 (logistics / rainfall & mountainous terrain) for Appendix
esttab without_interaction_rain rain rugged /// 
using ./output/table_c2.rtf, ///
replace cells(b(star fmt(2)) se(par fmt(2))) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
stats(alpha N N_clust chi2 ll, fmt(2 2 0)) legend ///
onecell nodep  gaps  compress ///
title({\b Table C2.} {Logistics / Rain}) ///
rename(quality_exp_lag quality_pc_lag) ///
coef(trooplag "UN Troops (t-1)" quality_pc_lag "Troop Quality (t-1)" policelag "UN Police (t-1)" ///
militaryobserverslag "UN Observers (t-1)" duration "Conflict Duration" incompatibility "Government Conflict" ///
logpop "Population" allbrds_lag "All Battle Deaths (t-1)" rebbrds_lag "Rebel Battle Deaths (t-1)" ///
govbrds_lag "Govt. Battle Deaths (t-1)" osvallLagDum "All OSV Dummy (t-1)" osvreb_lag "Rebel OSV (t-1)" ///
osvrebLagDum "Rebel OSV Dummy (t-1)" osvgov_lag "Govt. OSV (t-1)" osvgovlagDum "Govt. OSV Dummy" ///
_cons "Constant" alpha "Alpha" rugged "Rugged Terrain" cease "Ceasefire" pocenforce "Protection Mandate" ///
c.quality_pc_lag#c.ln_rain_lag "Troop Quality (t-1) * Monthly Rainfall" ln_rain_lag "Monthly Rainfall" ///
non_un_troops1000 "Non-UN Troops" FracTroop "Troop Fractionalization" PolTroop "Troop Polarization" c.ln_rain_lag "Monthly Rainfall") ///
nonumbers ///
mtitles("Without Rain Interaction (1)" "With Rain Interaction (2)" "Terrain (3)") ///
nobaselevels

**** 4.3 Information ****

* These models replicate the results in Table C3 in the Online Appendix and
* Figure 5 in the main text. 

xtset mission_num

xtnbreg osvAll c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
logpop allbrds_lag osvallLagDum duration FracTroop PolTroop   ///
, fe 

eststo fractroop

xtnbreg osvAll c.quality_pc_lag##c.FracTroop c.trooplag policelag militaryobserverslag  ///
 logpop allbrds_lag osvallLagDum duration   ///
, fe
eststo information_mechanism

* marginal effects plot
margins, dydx(quality_pc_lag) at(FracTroop=(0(0.1)1)  osvallLagDum = 1) atmeans predict(nu0)

* output to txt to plot in R (requires ssc install mat2txt)
matrix A = r(table)
mat2txt, matrix(A) saving(./temp/figure_5_fractroop.txt) replace

* Output Interaction with Fractroop table 
esttab fractroop information_mechanism /// 
using ./output/table_c3.rtf, ///
replace cells(b(star fmt(2)) se(par fmt(2))) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
stats(alpha N N_clust chi2 ll, fmt(2 2 0)) legend ///
onecell nodep  gaps  compress ///
title({\b Table C3.} {Information}) ///
rename(quality_exp_lag quality_pc_lag) ///
coef(trooplag "UN Troops (t-1)" quality_pc_lag "Troop Quality (t-1)" policelag "UN Police (t-1)" ///
militaryobserverslag "UN Observers (t-1)" duration "Conflict Duration" incompatibility "Government Conflict" ///
logpop "Population" allbrds_lag "All Battle Deaths (t-1)" rebbrds_lag "Rebel Battle Deaths (t-1)" ///
govbrds_lag "Govt. Battle Deaths (t-1)" osvallLagDum "All OSV Dummy (t-1)" osvreb_lag "Rebel OSV (t-1)" ///
osvrebLagDum "Rebel OSV Dummy (t-1)" osvgov_lag "Govt. OSV (t-1)" osvgovlagDum "Govt. OSV Dummy" ///
_cons "Constant" alpha "Alpha" rugged "Rugged Terrain" cease "Ceasefire" pocenforce "Protection Mandate" ///
c.quality_pc_lag#c.ln_rain_lag "Troop Quality (t-1) * Monthly Rainfall" ln_rain_lag "Monthly Rainfall" ///
c.quality_pc_lag#c.FracTroop "Troop Quality (t-1) * FracTroop" ///
non_un_troops1000 "Non-UN Troops" FracTroop "Troop Fractionalization" PolTroop "Troop Polarization" c.ln_rain_lag "Monthly Rainfall") ///
nonumbers ///
mtitles("No Interaction" "With FracTroop Interaction") ///
nobaselevels

**** 4.4 Gov OSV vs Rebel OSV ****

* These models replicate the results in Table C4 in the Online Appendix and
* Figure 6 in the main Text. 

* Rebel OSV
nbreg osvreb quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvrebLagDum osvgov_lag  ///
, cluster(conflictid)

eststo reb_osv

*  Gov OSV
nbreg osvgov quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvgovlagDum osvreb_lag   ///
, cluster(conflictid)

eststo gov_osv


* save output from reb_osv and gov_osv for coefficient plot in R
esttab reb_osv gov_osv ///
using ./temp/figure_6_govreb_osv.csv, replace cells(b(star fmt(6)) se(par fmt(6))) starlevels()


* Additional models with temporal leads of DV to trace effect over time
* Rebel OSV over time
nbreg osvreb_1month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvrebLagDum osvgov_lag  ///
, cluster(conflictid)

eststo reb_osv_1month

nbreg osvreb_2month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvrebLagDum osvgov_lag  ///
, cluster(conflictid)

eststo reb_osv_2month

nbreg osvreb_3month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvrebLagDum osvgov_lag  ///
, cluster(conflictid)

eststo reb_osv_3month

nbreg osvreb_4month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvrebLagDum osvgov_lag  ///
, cluster(conflictid)

eststo reb_osv_4month

nbreg osvreb_5month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvrebLagDum osvgov_lag  ///
, cluster(conflictid)

eststo reb_osv_5month

nbreg osvreb_6month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvrebLagDum osvgov_lag  ///
, cluster(conflictid)

eststo reb_osv_6month

nbreg osvreb_12month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvrebLagDum osvgov_lag  ///
, cluster(conflictid)

eststo reb_osv_12month

* save for reb osv over time plot in R
esttab reb_osv reb_osv_1month reb_osv_2month reb_osv_3month reb_osv_4month ///
reb_osv_5month reb_osv_6month reb_osv_12month ///
using ./temp/figure_C1_a.csv, replace cells(b(star fmt(6)) se(par fmt(6))) starlevels()



* Gov OSV over time
nbreg osvgov_1month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvgovlagDum osvreb_lag   ///
, cluster(conflictid)

eststo osvgov_1month

nbreg osvgov_2month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvgovlagDum osvreb_lag   ///
, cluster(conflictid)

eststo osvgov_2month

nbreg osvgov_3month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvgovlagDum osvreb_lag   ///
, cluster(conflictid)

eststo osvgov_3month

nbreg osvgov_4month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvgovlagDum osvreb_lag   ///
, cluster(conflictid)

eststo osvgov_4month

nbreg osvgov_5month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvgovlagDum osvreb_lag   ///
, cluster(conflictid)

eststo osvgov_5month

nbreg osvgov_6month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvgovlagDum osvreb_lag   ///
, cluster(conflictid) iterate(50)

eststo osvgov_6month

nbreg osvgov_12month quality_pc_lag trooplag policelag militaryobserverslag duration ///
incompatibility logpop rebbrds_lag govbrds_lag osvgovlagDum osvreb_lag   ///
, cluster(conflictid) 

eststo osvgov_12month


* save for gov osv over time plot in R
esttab gov_osv osvgov_1month osvgov_2month osvgov_3month osvgov_4month osvgov_5month ///
osvgov_6month osvgov_12month ///
using ./temp/figure_C1_b.csv, replace cells(b(star fmt(6)) se(par fmt(6))) starlevels()


* output Table reb and gov osv

esttab gov_osv reb_osv using ./output/table_c4.rtf, ///
replace cells(b(star fmt(2)) se(par fmt(2))) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
stats(alpha N N_clust chi2 ll, fmt(2 2 0)) legend ///
onecell nodep  gaps  compress ///
rename(quality_exp_lag quality_pc_lag) ///
coef(trooplag "UN Troops (t-1)" quality_pc_lag "Troop Quality (t-1)" policelag "UN Police (t-1)" ///
militaryobserverslag "UN Observers (t-1)" duration "Conflict Duration" incompatibility "Government Conflict" ///
logpop "Population" allbrds_lag "All Battle Deaths (t-1)" rebbrds_lag "Rebel Battle Deaths (t-1)" ///
govbrds_lag "Govt. Battle Deaths (t-1)" osvallLagDum "All OSV Dummy (t-1)" osvreb_lag "Rebel OSV (t-1)" ///
osvrebLagDum "Rebel OSV Dummy (t-1)" osvgov_lag "Govt. OSV (t-1)" osvgovlagDum "Govt. OSV Dummy" ///
_cons "Constant" alpha "Alpha" rugged "Rugged Terrain" cease "Ceasefire" pocenforce "Protection Mandate" ///
non_un_troops1000 "Non-UN Troops" FracTroop "Troop Fractionalization" PolTroop "Troop Polarization") ///
nonumbers ///
nobaselevels

**** (5) Robustness Checks ****

* Appendix D1: Political Will Robustness checks
use ./data/pko_qual.dta, clear

* TCC fatality history
nbreg osvAll c.quality_pc_lag tcc_fat_cumsum c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo tcc_fat_hist

* mission-specific casualties (Africa only)
nbreg osvAll c.quality_pc_lag pko_fatalities c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration  if region == 4 & location != "Rwanda" ///
, cluster(conflictid)

eststo mission_fat_hist

* count of P5 participants (irrespective of troop size)
nbreg osvAll c.quality_pc_lag p5_count c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo mission_p5_count

* count of UNSC participants
nbreg osvAll c.quality_pc_lag unsc_count c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo mission_unsc_count

* same UN region/voting bloc
nbreg osvAll c.quality_pc_lag same_un_bloc_count c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo mission_same_un_bloc

* EU/Japan count
nbreg osvAll c.quality_pc_lag eu_japan_count c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo mission_eu_jap

* all political will controls (except mission casualties
nbreg osvAll c.quality_pc_lag tcc_fat_cumsum p5_count unsc_count same_un_bloc_count eu_japan_count ///
c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo all_polwill

* output political will robustness checks
esttab tcc_fat_hist mission_fat_hist mission_p5_count mission_unsc_count mission_same_un_bloc mission_eu_jap ///
using ./output/table_d1.rtf, ///
replace cells(b(star fmt(2)) se(par fmt(2))) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
stats(N N_clust chi2 ll, fmt(2 2 0)) legend ///
onecell nodep  gaps  compress ///
mtitles("TCC Casualty History (1)" "Mission Casualty History (2)" "P5 Count (3)" "UNSC Count(4)"  ///
"Same UN Bloc (5)" "EU / Japan (6)" ) ///
title({\b Table 3.} {Robustness checks}) ///
coef(trooplag "UN Troops (t-1)" quality_pc_lag "Troop Quality (t-1)" ///
militaryobserverslag "UN Observers (t-1)" duration "Conflict Duration" incompatibility "Government Conflict" ///
logpop "Population" allbrds_lag "All Battle Deaths (t-1)" rebbrds_lag "Rebel Battle Deaths (t-1)" ///
govbrds_lag "Govt. Battle Deaths (t-1)" osvallLagDum "All OSV Dummy (t-1)" osvreb_lag "Rebel OSV (t-1)" ///
osvrebLagDum "Rebel OSV Dummy (t-1)" osvgov_lag "Govt. OSV (t-1)" osvgovlagDum "Govt. OSV Dummy" ///
tcc_fat_cumsum "Mean Cumulative TCC Casualty" pko_fatalities "Mission Casualties (cumulative)" ///
p5_count "Number of P5 TCC" unsc_count "Number of UNSC TCC" same_un_bloc "Number of same UN bloc TCC" ///
eu_japan_count "Number of EU/Japan TCCs" ///
policelag "UN Police (t-1)" ///
_cons "Constant" alpha "Alpha" ) ///
nonumbers ///
nobaselevels

* These models replicate the results from Table D2 in the Online Appendix.

use ./data/pko_qual.dta, clear

** (5.1) Ceasefire
nbreg osvAll c.quality_pc_lag c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration cease  ///
, cluster(conflictid)

eststo ceasefire

**** (5.2) Protection Mandate
nbreg osvAll c.quality_pc_lag c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration pocenforce  ///
, cluster(conflictid)

eststo pocmandate

***** (5.3) Non-UN Troops
gen non_un_troops1000 = non_un_troops / 1000
nbreg osvAll c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration non_un_troops1000  ///
, cluster(conflictid)

eststo nonuntroops


**** (5.4) TCC Expenditures only (not weighted by armed personnel)
nbreg osvAll c.quality_exp_lag c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration  ///
, cluster(conflictid)

eststo tcc_expenditures_only


***** (5.5) Without Sudan
nbreg osvAll c.quality_pc_lag c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration  if location != "Sudan" ///
, cluster(conflictid)

eststo without_sudan


**** (5.6) Peacekeeping Mission Expenditures
nbreg osvAll c.quality_pc_lag c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration pko_exp   ///
, cluster(conflictid)

eststo pko_expenditure


**** (5.7) All controls
xtset mission_num
xtnbreg osvAll c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
logpop allbrds_lag osvallLagDum duration cease pocenforce non_un_troops1000 pko_exp ///
FracTroop PolTroop  ///
, fe

eststo all_controls


**** (5.8) Only 12 months after conflict termination sample
nbreg osvAll c.quality_pc_lag c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration  if dummy_12 == 0 ///
, cluster(conflictid)

eststo months_12

***** (5.9) 0 months after conflict termination sample
nbreg osvAll c.quality_pc_lag c.trooplag  policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration  if dummy_0 == 0 ///
, cluster(conflictid)

eststo months_0

**** (5.10) Only large TCCs (> 40)
nbreg osvAll c.quality_pc_large_only_lag c.trooplag policelag militaryobserverslag  ///
incompatibility logpop allbrds_lag osvallLagDum duration   ///
, cluster(conflictid)

eststo largeonly

* Output Table D1 in the Online Appendix
esttab ceasefire pocmandate nonuntroops tcc_expenditures_only without_sudan pko_expenditure ///
all_controls months_12 months_0 largeonly using ./output/table_d2.rtf, ///
replace cells(b(star fmt(2)) se(par fmt(2))) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
stats(N N_clust chi2 ll, fmt(2 2 0)) legend ///
onecell nodep  gaps  compress ///
mtitles("Ceasefire (1)" "PoC ChVII Mandate (2)" "Non-UN Troops (3)" "Alternative Quality Measure (4)"  ///
"Without Sudan (5)" "PKO Expenditure (6)" "All Controls FE (7)" "12 Months (8)" "0 Months (9)" "Large TCC Only (10)") ///
title({\b Table 3.} {Robustness checks}) ///
coef(trooplag "UN Troops (t-1)" quality_pc_lag "Troop Quality (t-1)" ///
quality_pc_large_only_lag "Troop Quality (excl. small TCC) (t-1)"  ///
policelag "UN Police (t-1)" ///
militaryobserverslag "UN Observers (t-1)" duration "Conflict Duration" incompatibility "Government Conflict" ///
logpop "Population" allbrds_lag "All Battle Deaths (t-1)" rebbrds_lag "Rebel Battle Deaths (t-1)" ///
govbrds_lag "Govt. Battle Deaths (t-1)" osvallLagDum "All OSV Dummy (t-1)" osvreb_lag "Rebel OSV (t-1)" ///
osvrebLagDum "Rebel OSV Dummy (t-1)" osvgov_lag "Govt. OSV (t-1)" osvgovlagDum "Govt. OSV Dummy" ///
quality_exp_lag "Troop Quality (t-1) Alternative Measure" pko_exp "UN Peacekeeping Expenditures" ///
_cons "Constant" alpha "Alpha" rugged "Rugged Terrain" cease "Ceasefire" pocenforce "Protection Mandate" ///
non_un_troops1000 "Non-UN Troops" FracTroop "Troop Fractionalization" PolTroop "Troop Polarization") ///
nonumbers ///
nobaselevels


**** Additional Matching Analyses (Appendix E) ****

* With full set of controls (Model 2 in Table 2)
use ./data/match_pko_optimal.dta, replace

nbreg osvAll c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
logpop allbrds_lag osvallLagDum duration ///
, cluster(conflictid)

eststo all_osv_matched

* without full set of controls
nbreg osvAll c.quality_pc_lag c.trooplag policelag militaryobserverslag  ///
, cluster(conflictid)

eststo optmatch_treatonly

* Matched on 1st quartile of Troop Quality
use ./data/match_pko_optimal_qual1qt.dta, replace

nbreg osvAll c.quality_pc_lag , cluster(conflictid)
eststo optmatch_qualitymatch_1qt

nbreg osvAll c.quality_pc_lag c.trooplag policelag militaryobserverslag ///
logpop allbrds_lag osvallLagDum duration ///
, cluster(conflictid)
eststo qualmatch_1qtcont

* Median
use ./data/match_pko_optimal_qual_median.dta, replace

nbreg osvAll c.quality_pc_lag  , cluster(conflictid)
eststo optmatch_qualitymatch_med

nbreg osvAll c.quality_pc_lag c.trooplag policelag militaryobserverslag ///
logpop allbrds_lag osvallLagDum duration ///
, cluster(conflictid)
eststo qualitymatch_med_cont

* 3rd quartile
use ./data/match_pko_optimal_qual_3qt.dta, replace

nbreg osvAll c.quality_pc_lag  , cluster(conflictid)
eststo optmatch_qualitymatch_3qt

nbreg osvAll c.quality_pc_lag c.trooplag policelag militaryobserverslag ///
logpop allbrds_lag osvallLagDum duration ///
, cluster(conflictid)
eststo qualitymatch_3qt_cont

esttab optmatch_treatonly all_osv_matched ///
optmatch_qualitymatch_1qt qualmatch_1qtcont ///
optmatch_qualitymatch_med qualitymatch_med_cont /// 
optmatch_qualitymatch_3qt qualitymatch_3qt_cont using ./output/table_e1.rtf,  ///
replace cells(b(star fmt(2)) se(par fmt(2))) starlevels(+ 0.10 * 0.05 ** 0.01 *** 0.001) ///
stats(alpha N N_clust chi2 ll, fmt(2 2 0)) legend ///
onecell nodep gaps compress ///
mtitles("Matching w/out covariates (1)" "Matching w/covariates (2)" ///
"Troop Quality > 25%(3)" "Troop Quality > 25%(4)" "Troop Quality > 50%(5)" "Troop Quality > 50%(6)" ///
"Troop Quality > 75%(7)" "Troop Quality > 25%(8)") ///
title( Matching) ///
rename(quality_exp_lag quality_pc_lag) ///
coef(trooplag "UN Troops (t-1)" quality_pc_lag "Troop Quality (t-1)" policelag "UN Police (t-1)" ///
militaryobserverslag "UN Observers (t-1)" duration "Conflict Duration" incompatibility "Government Conflict" ///
logpop "Population" allbrds_lag "All Battle Deaths (t-1)" rebbrds_lag "Rebel Battle Deaths (t-1)" ///
govbrds_lag "Govt. Battle Deaths (t-1)" osvallLagDum "All OSV Dummy (t-1)" osvreb_lag "Rebel OSV (t-1)" ///
osvrebLagDum "Rebel OSV Dummy (t-1)" osvgov_lag "Govt. OSV (t-1)" osvgovlagDum "Govt. OSV Dummy" ///
_cons "Constant" alpha "Alpha" rugged "Rugged Terrain" cease "Ceasefire" pocenforce "Protection Mandate" ///
non_un_troops1000 "Non-UN Troops" FracTroop "Troop Fractionalization" PolTroop "Troop Polarization") ///
nonumbers ///
nobaselevels
