* Replication Code for 
* Consumer Demand for the Fair Trade Label: Evidence from a Multi-Store Field Experiment
* Jens Hainmueller -- Stanford University
* Michael J. Hiscox -- Harvard University
* Sandra Sequeira -- London School of Economics 

clear
set more off

** Table 1 and 2: see repTable1andTable2.R

** Table 3: Summary Statistics
use "repTable3.dta", clear

gen     salesd   = salesp*salesu
tabstat salesu salesd  sharebulksales salesshare, by(prod) 


** Table 4: Effect of Fair Trade Label on Sales of Test Coffees
use "repTable4and5.dta", clear

* log dollar sales
gen salesd   = salesp*salesu
gen lnsalesd = log(salesd)

* model 2: FR Regular
xtreg lnsalesd FTweek i.periodfw, i(store) fe cl(store), if prod=="COF FRENCH ROAST OG BULK" & exp1period==1

* model 3: Coffee Blend
xtreg lnsalesd FTweek i.periodfw, i(store) fe cl(store), if prod=="COFFEE BLEND BULK" &  exp1period==1

* model 1: FR Regular and Coffee Blend
keep if (prod=="COF FRENCH ROAST OG BULK" | prod=="COFFEE BLEND BULK") & exp1period==1
collapse (sum) salesd , by(store periodfw FTweek)
gen lnsalesd = log(salesd) 
xtreg lnsalesd FTweek i.periodfw, i(store) fe cl(store)


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
xtreg delta salesp FRCB i.periodfw, i(storeprod) fe level(90) cl(store) , if exp1period==1

* model 2: Regular and Coffee Blend and Competitors
xtreg delta salesp xx* i.periodfw, i(storeprod) fe level(90) cl(store) , if exp1period==1


** code coffee indicators for Price experiment

* FR Regular and Coffee Blend
drop FRCB xx*
gen     FRCB = 0
replace FRCB = 1 if TPweek==1 & (prod=="COF FRENCH ROAST OG BULK" | prod=="COFFEE BLEND BULK")

* FR Regular
gen     xxFR = 0
replace xxFR = 1 if TPweek==1 & prod=="COF FRENCH ROAST OG BULK"

* Coffee Blend
gen     xxCB = 0
replace xxCB = 1 if TPweek==1 & prod=="COFFEE BLEND BULK"

* Breakfast Blend
gen     xxBB = 0
replace xxBB = 1 if TPweek==1 & prod=="COF BREAKFAST BLEND OG BULK"

* Colombian Supremo
gen     xxCS = 0
replace xxCS = 1 if TPweek==1 & prod=="COF COLOMBIAN SUPREMO BULK"

* FR Extra Dark
gen     xxFRD = 0
replace xxFRD = 1 if TPweek==1 & prod=="COF FRENCH EXTRA DARK BULK"

* Regional Blend
gen     xxRB = 0
replace xxRB = 1 if TPweek==1 & prod=="COF REGIONAL BLEND OG BULK"

* Mexican
gen     xxMEX = 0
replace xxMEX = 1 if TPweek==1 & prod=="COF MEXICAN OG BULK"

** Results

* model 3: Regular and Coffee Blend
xtreg delta FRCB i.periodfw, i(storeprod) fe level(90) cl(store) , if exp2period==1

* model 4: Regular and Coffee Blend and Competitors
xtreg delta xx* i.periodfw, i(storeprod) fe level(90) cl(store) , if exp2period==1

* Own Price Elasticities

capture matrix drop el
* FR 
nlcom (exp(_b[xxFR])-1)  /(1/11.99) , level(90)
mat el = (nullmat(el), r(b) , r(V))
* CB
nlcom (exp(_b[xxCB])-1) /(1/10.99) , level(90)
mat el = el \ (r(b) , r(V))

* store elasticities for plotting
matrix rownames el = FR CB
matrix se = el[1..2,2]
mata: st_replacematrix("se",sqrt(st_matrix("se")))
matrix el = el[1..2,1], se
mat el = el , el[1..2,1]-(el[1..2,2]*1.645) , el[1..2,1]+(el[1..2,2]*1.645)
matrix colnames el = el se lb ub
mat list el
mat2txt, matrix(el) saving(expelas) replace

* cross price elasticity to columbian
nlcom (exp(_b[xxCS])-1) /(1/10.99) , level(90)


** Figure 3: Estimated Own Price Elasticities for Test Coffees and Competitor Coffees 
* Table A.1: Logit Estimates for Elasticities
use "repFigure3.dta", clear

* compute delta_ij
egen sharesum = sum(salesshare) , by(store periodfw)
gen  outshare=1-sharesum
gen  delta=log(salesshare)-log(outshare)
drop outshare sharesum

* product store fixed effects
egen storeprod=group(itemno store)

* with quadratic time trend
sort store itemno periodfw
egen time = group(periodfw)
gen  time2 = time^2
xtreg delta salesp time time2, i(storeprod) fe level(90) cl(store)

* elasiticities
gen elas=_b[salesp]*salesshare*(1-salesshare)*salesp/salesshare if e(sample)
tabstat elas, by(prod)

* see repFigure3.R for Figure 3
* export to do block bootstrap logit in R
saveold "repFigure3boot.dta", replace


* see repFigure3.R for Figure B.1
* export to do block bootstrap AIDS in R
gen salesd = salesu*salesp
keep  salesd salesp store itemno periodfw
reshape wide salesd salesp , i(store periodfw) j(itemno)
tab store, gen(storedu)
sort store periodfw
egen time = group(periodfw)
gen  time2 = time^2

order  store periodfw salesd*  salesp* storedu*
egen totald = rowtotal( salesd323-salesd24191)
foreach x of varlist   salesd323-salesd24191   {
gen sh`x' = `x' / totald
}
drop salesd*
order  store periodfw sh* salesp* storedu* time
saveold "repFigureB1boot.dta", replace


** Appendix: 

** Table A.2: Effect of Fair Trade Label on Sales of Test Coffees in Phase One

use "repTableA2.dta", replace
gen salesd   = salesp*salesu
collapse (sum) salesd , by(store periodfw FTweek FTfirst Phase1 )
gen lnsalesd = log(salesd) 

* model 1: FT Label first
xtreg lnsalesd Phase1 if FTfirst==1 , i(store) fe cl(store)

* model 2: Control Label First
xtreg lnsalesd Phase1 if FTfirst==0 , i(store) fe cl(store)

* model 3: All Stores DID Phase 1
xtreg lnsalesd Phase1##FTfirst , i(store) fe cl(store)

** Additional test for carryover using last two weeks only 
use "repTable4and5.dta", clear

* log dollar sales
gen salesd   = salesp*salesu

* model 1: FR Regular and Coffee Blend
keep if (prod=="COF FRENCH ROAST OG BULK" | prod=="COFFEE BLEND BULK") & exp1period==1
collapse (sum) salesd , by(store periodfw FTweek)
gen lnsalesd = log(salesd) 

xtreg lnsalesd FTweek i.periodfw, i(store) fe cl(store), if ///
    periodfw==200906 | periodfw==200907 | periodfw==200910 | periodfw==200911
