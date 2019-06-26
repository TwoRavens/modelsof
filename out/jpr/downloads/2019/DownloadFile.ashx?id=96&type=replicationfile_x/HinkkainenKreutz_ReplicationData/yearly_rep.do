**************************

 *Yearly replication JPR*
 *Kaisa Hinkkainen & Joakim Kreutz*
 
 *Last edited 24.02.2018

**************************

clear

set more off

use gridfinal.dta

*****

* Generate variable for all the natural resources

egen natres = rowtotal(petrodata_onshore_v12 petrodata_offshore_v12 cannabis lootablecsv nonlootablecsv)


* Generate _prefail variable
  
btscs confl_best year gid, gen(t)f

gen t2=t^2

gen t3=t^3

* Rescale the skewed variables

foreach v of varlist cellarea confl_best dur1 ///
 bdist1 capdist country_best country_high country_low _prefail imr {
 gen r`v' = (`v')/1000
 }
 
gen rpop=pop/100000

* Generate an interpolation of the population variable

by gid : ipolate rpop year, gen(Population_size) epolate
 
* Rename variables for tables

rename rcellarea Cell_area
rename confl_best Fatalities
rename natres Natural_resources
rename ext_suppa Govt_external
rename ext_suppb Rebel_external
rename rdur1 Duration
rename conflag1 Conflict_lag
rename rbdist Contiguity
rename rcapdist Capital_distance
rename rcountry_best Country_fatalities
rename talks Talks
rename cm_med Mediation
rename peace_ag Peace_agreement
rename r_prefail Previous_fatalities
* rename rpop Population_size
rename rimr Infant_mortality
rename mnt Mountains
rename petrodata_onshore_v12 Onshore_petroleum
rename petrodata_offshore_v12 Offshore_petroleum
rename nonlootablecsv Non_lootable_diamonds
rename cannabis Cannabis
rename lootablecsv Lootable_diamonds

* The full sample includes 10 261 African grid cells
* From 1989-2008 (20 years) means 102 61 x 20 = total of 205 220 grid cell years

 * Generating an interaction term 
 
gen Natural_resourcesXTalks=Natural_resources*Talks

* Conflict lag recoding

replace Conflict_lag=0 if Conflict_lag==.

* Table 3 main article

set seed 123

clear matrix

* Robust SE, nbreg

quietly nbreg Fatalities Natural_resources Cell_area Govt_external  Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==0, robust
eststo m1
quietly nbreg Fatalities Natural_resources Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities  if Talks==1, robust

* Cluster grid SE, nbreg

eststo m2
quietly nbreg Fatalities Natural_resources Cell_area Govt_external  Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size  Previous_fatalities if Talks==0, vce(cluster gid)
eststo m3
quietly nbreg Fatalities Natural_resources Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==1, vce(cluster gid)

* Cluster country SE, nbreg

eststo m4
quietly nbreg Fatalities Natural_resources Cell_area Govt_external  Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==0, vce(cluster gwno)
eststo m5
quietly nbreg Fatalities Natural_resources Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==1, vce(cluster gwno)
eststo m6

* Interaction models

quietly nbreg Fatalities Natural_resources Talks Natural_resourcesXTalks Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities, robust
eststo m7
quietly nbreg Fatalities Natural_resources Talks Natural_resourcesXTalks Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities, vce(cluster gid)
eststo m8
quietly zinb Fatalities Natural_resources Talks Natural_resourcesXTalks Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities  Population_size Previous_fatalities, inflate(gwno)
eststo m9

esttab 
esttab using table3.tex, replace

clear matrix

*****

* Models for the appendix

*****

* Interaction terms for Mediation and Peace agreements

gen Natural_resourcesXMediation=Natural_resources*Mediation
gen Natural_resourcesXPeace_Agr=Natural_resources*Peace_agreement

* Table 4 in the appendix

quietly nbreg Fatalities Natural_resources Mediation Natural_resourcesXMediation Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size  Previous_fatalities, vce(cluster gid)
eststo m1
quietly nbreg Fatalities Natural_resources Peace_agreement  Natural_resourcesXPeace_Agr Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size  Previous_fatalities, vce(cluster gid)
eststo m2

* Year dummies and random effects

xtset gid year

quietly xi: nbreg Fatalities Natural_resources Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size i.year if Talks==0, vce(cluster gid)
eststo m3
quietly xi: nbreg Fatalities Natural_resources Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size  i.year if Talks==1, vce(cluster gid)
eststo m4
quietly xtnbreg Fatalities Natural_resources Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==0, re
eststo m5
quietly xtnbreg Fatalities Natural_resources Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==1, re
eststo m6

esttab 
esttab using table4.tex, replace drop (_Iyear*)

* Table 5 in the appendix: onshore and offshore petrol and non-lootable diamonds

clear matrix
eststo: quietly nbreg Fatalities Onshore_petroleum Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities  if Talks==0, vce(cluster gid)
eststo: quietly nbreg Fatalities Onshore_petroleum Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==1,vce(cluster gid)
eststo: quietly nbreg Fatalities Offshore_petroleum Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==0, vce(cluster gid)
eststo: quietly nbreg Fatalities Offshore_petroleum Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==1, vce(cluster gid)
eststo: quietly nbreg Fatalities Non_lootable_diamonds Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==0, vce(cluster gid)
eststo: quietly nbreg Fatalities Non_lootable_diamonds Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==1, vce(cluster gid)
esttab
esttab using table5.tex, replace

* Table 6 in the appendix: cannabis and lootable diamonds

clear matrix
eststo: quietly nbreg Fatalities Cannabis Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==0, vce(cluster gid)
eststo: quietly nbreg Fatalities Cannabis Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==1, vce(cluster gid)
eststo: quietly nbreg Fatalities Lootable_diamonds Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==0, vce(cluster gid)
eststo: quietly nbreg Fatalities Lootable_diamonds Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==1, vce(cluster gid)
esttab
esttab using table6.tex, replace

* Table 7 in the appendix high and low fatality estimates

clear matrix
eststo: quietly nbreg confl_high Natural_resources Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance rcountry_high Population_size Previous_fatalities if Talks==0,vce(cluster gid)
eststo: quietly nbreg confl_high Natural_resources Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance rcountry_high Population_size Previous_fatalities if Talks==1,vce(cluster gid)
eststo: quietly nbreg confl_low Natural_resources Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance rcountry_low Population_size Previous_fatalities if Talks==0, vce(cluster gid)
eststo: quietly nbreg confl_low Natural_resources Cell_area Govt_external Rebel_external Duration Conflict_lag Contiguity Capital_distance rcountry_low Population_size Previous_fatalities if Talks==1, vce(cluster gid)
esttab
esttab using table7.tex, replace

* Matching tests

capture drop pscore _pscore _treated _support _weight _confl_best _id _n1 _nn _pdif

tabulate Talks, summarize(Fatalities) means standard

nbreg Fatalities Talks

logit Talks Natural_resources Cell_area Contiguity Capital_distance

predict pscore, pr

sum ps

* Average probability to be part in negotiations 26%

* Nearest neighbour matching is the default

set seed 12345
tempvar sortorder
gen `sortorder' = runiform()
sort `sortorder'

psmatch2 Talks, pscore(pscore) outcome(Fatalities) common 

psmatch2 Talks, pscore(pscore) outcome(Fatalities) common ate

pstest Natural_resources Cell_area Contiguity Capital_distance, sum

* The average bias is 4.1%, so below the 5% threshold. Means the match is good.

* Figure 8 in the appendix

psgraph 

********
*FIGURES
********

* Generate natural resources binary

gen Natural_resourcesb=.
replace Natural_resourcesb=1 if Natural_resources!=0
replace Natural_resourcesb=0 if Natural_resources==0

* Baseline probabilities

capture drop b1-b13
set seed 123
estsimp nbreg Fatalities Natural_resourcesb Cell_area ///
Govt_external Rebel_external Duration Conflict_lag Contiguity ///
Capital_distance Country_fatalities Population_size Previous_fatalities, vce(cluster gid)

capture drop d0
capture drop d1
setx  Cell_area mean Duration mean Conflict_lag mean Contiguity mean Capital_distance ///
mean Country_fatalities mean Previous_fatalities mean Population_size mean Govt_external median Rebel_external median
simqi, listx  
simqi, fd(ev) changex(Natural_resourcesb 0 1)

setx Natural_resourcesb 0 
simqi, listx  
simqi, genev(d0)
setx Natural_resourcesb 1 
simqi, listx  genev(d1)

* Without talks

set see 123
capture drop b1-b13
estsimp nbreg Fatalities Natural_resourcesb Cell_area ///
Govt_external Rebel_external Duration Conflict_lag Contiguity ///
Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==0, vce(cluster gid)

setx  Cell_area mean Duration mean Conflict_lag mean Contiguity mean Capital_distance ///
mean Country_fatalities mean Population_size mean Previous_fatalities mean Govt_external median Rebel_external median 

* Figure 2 in main article

plotfds, cont(Cell_area Duration Conflict_lag Contiguity Capital_distance) ///
disc(Rebel_external Govt_external Natural_resourcesb) ///
changex(min max) nosetx ///
xline(0) clevel(95) title(, nobox) legend(off) name(graph2, replace) 

*******************

* With talks

capture drop b1-b13
set seed 123
estsimp nbreg Fatalities Natural_resourcesb Cell_area ///
Govt_external Rebel_external Duration Conflict_lag Contiguity ///
Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==1, vce(cluster gid)

setx  Cell_area mean Duration mean Conflict_lag mean Contiguity mean Capital_distance ///
mean Country_fatalities mean Population_size mean Previous_fatalities mean Govt_external median Rebel_external median 

* Figure 3 main article

plotfds, cont(Cell_area Duration Conflict_lag Contiguity Capital_distance) ///
disc(Govt_external Rebel_external Natural_resourcesb) changex(min max) nosetx ///
xline(0) clevel(95) title(, nobox) legend(off) name(graph3, replace) 

****

* Without talks

capture drop b1-b13
set seed 123
estsimp nbreg Fatalities Natural_resourcesb Cell_area ///
Govt_external Rebel_external Duration Conflict_lag Contiguity ///
Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==0

capture drop d0
capture drop d1
setx  Cell_area mean Duration mean Conflict_lag mean Contiguity mean Capital_distance ///
mean Country_fatalities mean Population_size mean Previous_fatalities mean Govt_external median Rebel_external median 
simqi, listx  
simqi, fd(ev) changex(Natural_resourcesb 0 1)

setx Natural_resourcesb 0 
simqi, listx  
simqi, genev(d0)
setx Natural_resourcesb 1 
simqi, listx  
simqi, genev(d1)

* Figure 6 in the appendix

capture drop att_* den_*
kdensity d0, generate(att_d0 den_d0)
kdensity d1, generate(att_d1 den_d1)
*replace att_d0 = . if att_d0 > 100
*replace att_d1 = . if att_d1 > 100
label var den_d0 "No natural resources"
label var den_d1 "Natural resources"
twoway (line den_d0 att_d0) ///
 (line den_d1 att_d1, lpattern(dash)), ///
 ytitle(Density estimate) xtitle(Number of fatalities)

****************

* These are for talks

capture drop b1-b13
set seed 123
estsimp nbreg Fatalities Natural_resourcesb Cell_area ///
Govt_external Rebel_external Duration Conflict_lag Contiguity ///
Capital_distance Country_fatalities Population_size Previous_fatalities if Talks==1

capture drop d0
capture drop d1
setx  Cell_area mean Duration mean Conflict_lag mean Contiguity mean Capital_distance ///
mean Country_fatalities mean Population_size mean Previous_fatalities mean Govt_external median Rebel_external median 
simqi, listx  
simqi, fd(ev) changex(Natural_resourcesb 0 1)

setx Natural_resourcesb 0 
simqi, listx  
simqi, genev(d0)
setx Natural_resourcesb 1 
simqi, listx  genev(d1)

* Figure 7 in the appendix

capture drop att_* den_*
kdensity d0, generate(att_d0 den_d0)
kdensity d1, generate(att_d1 den_d1)
*replace att_d0 = . if att_d0 > 100
*replace att_d1 = . if att_d1 > 100
label var den_d0 "No natural resources"
label var den_d1 "Natural resources"
twoway (line den_d0 att_d0) ///
 (line den_d1 att_d1, lpattern(dash)), ///
 ytitle(Density estimate) xtitle(Number of fatalities)

* VIF and corr
 
reg Fatalities Natural_resources Cell_area ///
Govt_external Rebel_external Duration Conflict_lag Contiguity ///
Capital_distance Country_fatalities Previous_fatalities Population_size, vce(cluster gid)

vif

corr Natural_resources Cell_area ///
Govt_external Rebel_external Duration Conflict_lag Contiguity ///
Capital_distance Country_fatalities Previous_fatalities Population_size

* 1.16 average, no probs

* Summary statistics, Table 1 in the main article

sutex Fatalities Natural_resources Cell_area Govt_external ///
 Rebel_external Duration Conflict_lag Contiguity Capital_distance Population_size ///
 Country_fatalities Talks Mediation Peace_agreement, minmax
