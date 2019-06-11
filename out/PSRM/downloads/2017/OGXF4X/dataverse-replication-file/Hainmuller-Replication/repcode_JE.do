* Replication Code for 
* Consumer Demand for the Fair Trade Label: Evidence from a Multi-Store Field Experiment
* Jens Hainmueller -- Stanford University
* Michael J. Hiscox -- Harvard University
* Sandra Sequeira -- London School of Economics 

* reanalysis by Justin Esarey and Andrew Menger with new clustering techniques
* original do file saved as repcode.do

version 13.2
clear
set more off

log using hainmueller-rep.log, replace

** Table 5: Main Results: Label and Price Experiment
use "repTable4and5.dta", clear

* compute delta_ij
egen sharesum = sum(salesshare) , by(store periodfw)
gen  outshare=1-sharesum
gen  delta = log(salesshare)-log(outshare)
drop outshare sharesum

* product store fixed effects
egen storeprod=group(itemno store)

** code coffee indicators for Label experiment
* FR Regular and Coffee Blend
gen     FRCB = 0
replace FRCB = 1 if FTweek==1 & (prod=="COF FRENCH ROAST OG BULK" | prod=="COFFEE BLEND BULK")

* FR Regular
gen     xxFR = 0
replace xxFR = 1 if FTweek==1 & prod=="COF FRENCH ROAST OG BULK"

* Coffee Blend
gen     xxCB = 0
replace xxCB = 1 if FTweek==1 & prod=="COFFEE BLEND BULK"

* Breakfast Blend
gen     xxBB = 0
replace xxBB = 1 if FTweek==1 & prod=="COF BREAKFAST BLEND OG BULK"

* Colombian Supremo
gen     xxCS = 0
replace xxCS = 1 if FTweek==1 & prod=="COF COLOMBIAN SUPREMO BULK"

* FR Extra Dark
gen     xxFRD = 0
replace xxFRD = 1 if FTweek==1 & prod=="COF FRENCH EXTRA DARK BULK"

* Regional Blend
gen     xxRB = 0
replace xxRB = 1 if FTweek==1 & prod=="COF REGIONAL BLEND OG BULK"

* Mexican
gen     xxMEX = 0
replace xxMEX = 1 if FTweek==1 & prod=="COF MEXICAN OG BULK"

** Results

* model 1: Regular and Coffee Blend
* this is the source of Table 6, columns "coefficient" and "CRSE"
xtreg delta salesp FRCB i.periodfw, i(storeprod) fe level(90) cl(store) , if exp1period==1
mat g = e(b)



keep if exp1period==1
tab periodfw, gen(perdum)
tab itemno, gen(itemdum)

* cluster bootstrap w/ Andrew's program
* this is the source of Table 6, Column "PCBST"
clusterbs regress delta salesp FRCB perdum2-perdum8, cluster(store) fe(inside) festruc(itemno) reps(5000) seed(123456)

* Ibragimov-Muller SEs
* this is the source of Table 6, column "CAT"
clustse reg delta salesp FRCB perdum2-perdum8 itemdum2-itemdum7, cluster(store) force(no)

* Ibragimov-Muller SEs
* no item dummies, no force option
clustse reg delta salesp FRCB perdum2-perdum8, cluster(store)
saveold hain-dat-r.dta, replace

log close