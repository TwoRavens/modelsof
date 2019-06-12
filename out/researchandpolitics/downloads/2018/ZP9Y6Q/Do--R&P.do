use "/Users/joshuaholzer/Desktop/R&P data files/Data--R&P.dta", clear

oprobit physint over50_pres xconst gdp_ln pop_ln internal  ///
	physint0 physint1 physint2 physint3 physint4 physint5 physint6 physint7   ///
	, vce(cluster ciri)		
	
oprobit physint percent_cabinet_not_pres_party xconst gdp_ln pop_ln internal  ///
	physint0 physint1 physint2 physint3 physint4 physint5 physint6 physint7   ///
	, vce(cluster ciri)

****************************************************************************************************************
***************************************Elections Clarify********************************************************
****************************************************************************************************************
*over50_pres model!
set seed 7302016
qui estsimp oprobit physint over50_pres xconst gdp_ln pop_ln internal  ///
	physint1 physint2 physint3 physint4 physint5 physint6 physint7 physint8  ///
	, vce(cluster ciri) sims(1000000)

*These are the data points for the graphs in Figure 1....
*"Best" scenario:
setx over50_pres 0 xconst p95 gdp_ln p95 pop_ln p5 internal p5  ///
	physint1 0 physint2 0 physint3 0 physint4 0 physint5 0 physint6 0 physint7 0 physint8 1 ///

simqi, prval(4) listx
simqi, prval(5) listx
simqi, prval(6) listx
simqi, prval(7) listx
simqi, prval(8) listx

setx over50_pres 1 xconst p95 gdp_ln p95 pop_ln p5 internal p5  ///
	physint1 0 physint2 0 physint3 0 physint4 0 physint5 0 physint6 0 physint7 0 physint8 1 ///

simqi, prval(4) listx
simqi, prval(5) listx
simqi, prval(6) listx
simqi, prval(7) listx
simqi, prval(8) listx

*"Average" scenario:
setx over50_pres 0 xconst p50 gdp_ln mean pop_ln mean internal p50  ///
	physint1 0 physint2 0 physint3 0 physint4 0 physint5 1 physint6 0 physint7 0 physint8 0 ///

simqi, prval(2) listx
simqi, prval(3) listx
simqi, prval(4) listx
simqi, prval(5) listx
simqi, prval(6) listx
simqi, prval(7) listx
simqi, prval(8) listx

setx over50_pres 1 xconst p50 gdp_ln mean pop_ln mean internal p50  ///
	physint1 0 physint2 0 physint3 0 physint4 0 physint5 1 physint6 0 physint7 0 physint8 0 ///

simqi, prval(2) listx
simqi, prval(3) listx
simqi, prval(4) listx
simqi, prval(5) listx
simqi, prval(6) listx
simqi, prval(7) listx
simqi, prval(8) listx

*"Worst" scenario
setx over50_pres 0 xconst p5 gdp_ln p5 pop_ln p95 internal p95  ///
	physint1 1 physint2 0 physint3 0 physint4 0 physint5 0 physint6 0 physint7 0 physint8 0 ///

simqi, prval(0) listx
simqi, prval(1) listx
simqi, prval(2) listx
simqi, prval(3) listx
simqi, prval(4) listx

setx over50_pres 1 xconst p5 gdp_ln p5 pop_ln p95 internal p95  ///
	physint1 1 physint2 0 physint3 0 physint4 0 physint5 0 physint6 0 physint7 0 physint8 0 ///

simqi, prval(0) listx
simqi, prval(1) listx
simqi, prval(2) listx
simqi, prval(3) listx
simqi, prval(4) listx

****************************************************************************************************************
use "/Users/joshuaholzer/Desktop/R&P data files/Data--R&P.dta", clear

*percent_cabinet_not_pres_party model!
set seed 7302016
qui estsimp oprobit physint percent_cabinet_not_pres_party xconst gdp_ln pop_ln internal  ///
	physint1 physint2 physint3 physint4 physint5 physint6 physint7 physint8  ///
	, vce(cluster ciri) sims(1000000)

*These are the data points for the graphs in Figure 2....	
* 100%	
setx percent_cabinet_not_pres_party 1 xconst p50 gdp_ln mean pop_ln mean internal p50  ///
	physint1 0 physint2 0 physint3 0 physint4 0 physint5 1 physint6 0 physint7 0 physint8 0 ///

simqi, prval(3) listx
simqi, prval(4) listx
simqi, prval(5) listx
simqi, prval(6) listx
simqi, prval(7) listx
simqi, prval(8) listx

* 75%	
setx percent_cabinet_not_pres_party .75 xconst p50 gdp_ln mean pop_ln mean internal p50  ///
	physint1 0 physint2 0 physint3 0 physint4 0 physint5 1 physint6 0 physint7 0 physint8 0 ///

simqi, prval(3) listx
simqi, prval(4) listx
simqi, prval(5) listx
simqi, prval(6) listx
simqi, prval(7) listx
simqi, prval(8) listx
	
* 50%	
setx percent_cabinet_not_pres_party .5 xconst p50 gdp_ln mean pop_ln mean internal p50  ///
	physint1 0 physint2 0 physint3 0 physint4 0 physint5 1 physint6 0 physint7 0 physint8 0 ///

simqi, prval(3) listx
simqi, prval(4) listx
simqi, prval(5) listx
simqi, prval(6) listx
simqi, prval(7) listx
simqi, prval(8) listx

* 25%
setx percent_cabinet_not_pres_party .25 xconst p50 gdp_ln mean pop_ln mean internal p50  ///
	physint1 0 physint2 0 physint3 0 physint4 0 physint5 1 physint6 0 physint7 0 physint8 0 ///

simqi, prval(3) listx
simqi, prval(4) listx
simqi, prval(5) listx
simqi, prval(6) listx
simqi, prval(7) listx
simqi, prval(8) listx

* 0%
setx percent_cabinet_not_pres_party 0 xconst p50 gdp_ln mean pop_ln mean internal p50  ///
	physint1 0 physint2 0 physint3 0 physint4 0 physint5 1 physint6 0 physint7 0 physint8 0 ///

simqi, prval(3) listx
simqi, prval(4) listx
simqi, prval(5) listx
simqi, prval(6) listx
simqi, prval(7) listx
simqi, prval(8) listx

****************************************************************************************************************
****************************************************************************************************************
****************************************************************************************************************
****************************************************************************************************************
