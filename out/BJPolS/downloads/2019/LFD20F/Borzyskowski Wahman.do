*************************************************************************************
** 	Replication for 
**
** 	Systematic Measurement Error in Election Violence Data: Causes and Consequences
** 	Inken von Borzyskowski & Michael Wahman
**  British Journal of Political Science
** 
**	Created: 28 November 2018
**
*************************************************************************************

clear
estimates clear 
set more off
cd "/Volumes/MONROE/BJPS files for Dataverse"


* install if you have not yet
* ssc install ... estout, combomarginsplot, coefplot, spineplot, vioplot



***********************************
* Figure 1
***********************************

use "Borzyskowski Wahman Data combined.dta", clear

* Correlation matrix
label var margin_percentPresPRE "Vote margin"
graph matrix PopulationDensity Nightlightlog margin_percentPresPRE EthnicFractionalization,  ///
	ms(Oh) jitter(1)  scheme(lean1) 
graph export "Figure1.pdf", replace

* Correlation statistics
pwcorr PopulationDensity Nightlightlog margin_percentPresPRE EthnicFractionalization, star(0.05)


	
***********************************
* Figure 4 
***********************************
use "Borzyskowski Wahman Data combined.dta", clear
keep if Malawi==1
	
* Figure 4a  
tab preday_EV preday_EV_ACLED if consistency_predayACLED ==1
tab preday_EV preday_EV_ACLED if consistency_predayACLED ==0
twoway (scatter preday_EV preday_EV_ACLED if consistency_predayACLED ==1, msymbol(Oh) jitter(15 15)) ///
	(scatter preday_EV preday_EV_ACLED if consistency_predayACLED ==0 & preday_EV_ACLED==1, msymbol(Th) jitter(15 15))  ///
	(scatter preday_EV preday_EV_ACLED if consistency_predayACLED ==0 & preday_EV_ACLED==0, msymbol(T) jitter(15 15) mcolor("red"))  ///
	(scatteri 0.8  -0.1 (3) "39", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.8   0.9 (3) "3", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22  0.9 (3) "4", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22 -0.1 (3) "146", msymbol(i) mlabsize(medium)), ///
	scheme(lean1) legend(ring(0) pos(0) order(1 "Consistency" 2 "Inconsistency" 3 "Under-Reporting")) ///
	xtitle("ACLED") ytitle("MEMS")  aspectratio(1) ///
	xscale(range(-0.2 1.2)) yscale(range(-0.2 1.2)) ///
	xlabel(0(1)1) ylabel(0(1)1) title("Pre-Election Violence")
graph save Graph "Figure4a.gph", replace

* Figure 4b  
tab post_EV post_EV_ACLED if consistency_postACLED ==1
tab post_EV post_EV_ACLED if consistency_postACLED ==0
twoway (scatter post_EV post_EV_ACLED if consistency_postACLED ==1, msymbol(Oh) jitter(15 15)) ///
	(scatter post_EV post_EV_ACLED if consistency_postACLED ==0 & post_EV_ACLED==1, msymbol(Th) jitter(15 15))  ///
	(scatter post_EV post_EV_ACLED if consistency_postACLED ==0 & post_EV_ACLED==0, msymbol(T) jitter(15 15) mcolor("red"))  ///
	(scatteri 0.8  -0.1 (3) "7", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.8   0.9 (3) "1", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22  0.9 (3) "2", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22 -0.1 (3) "182", msymbol(i) mlabsize(medium)), ///
	scheme(lean1) legend(ring(0) pos(0) order(1 "Consistency" 2 "Inconsistency" 3 "Under-Reporting")) ///
	xtitle("ACLED") ytitle("MEMS")  aspectratio(1) ///
	xscale(range(-0.2 1.2)) yscale(range(-0.2 1.2)) ///
	xlabel(0(1)1) ylabel(0(1)1)  title("Post-Election Violence")
graph save Graph "Figure4b.gph", replace

* Figure 4c
tab preday_EV preday_EV_SCAD if consistency_predaySCAD ==1
tab preday_EV preday_EV_SCAD if consistency_predaySCAD ==0
twoway (scatter preday_EV preday_EV_SCAD if consistency_predaySCAD ==1, msymbol(Oh) jitter(15 15)) ///
	(scatter preday_EV preday_EV_SCAD if consistency_predaySCAD ==0 & preday_EV_SCAD==1, msymbol(Th) jitter(15 15))  ///
	(scatter preday_EV preday_EV_SCAD if consistency_predaySCAD ==0 & preday_EV_SCAD==0, msymbol(T) jitter(15 15) mcolor("red"))  ///
	(scatteri 0.8  -0.1 (3) "41", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.8   0.9 (3) "1", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22  0.9 (3) "1", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22 -0.1 (3) "149", msymbol(i) mlabsize(medium)), ///
	 scheme(lean1) legend(ring(0) pos(0) order(1 "Consistency" 2 "Inconsistency" 3 "Under-Reporting")) ///
	xtitle("SCAD") ytitle("MEMS")  aspectratio(1)  ///
	xscale(range(-0.2 1.2)) yscale(range(-0.2 1.2)) ///
	xlabel(0(1)1) ylabel(0(1)1) title("Pre-Election Violence")
graph save Graph "Figure4c.gph", replace

* Figure 4d
tab post_EV post_EV_SCAD if consistency_postSCAD ==1
tab post_EV post_EV_SCAD if consistency_postSCAD ==0
twoway (scatter post_EV post_EV_SCAD if consistency_postSCAD ==1, msymbol(Oh) jitter(15 15)) ///
	(scatter post_EV post_EV_SCAD if consistency_postSCAD ==0 & post_EV_SCAD==1, msymbol(Th) jitter(15 15))  ///
	(scatter post_EV post_EV_SCAD if consistency_postSCAD ==0 & post_EV_SCAD==0, msymbol(T) jitter(15 15) mcolor("red"))  ///
	(scatteri 0.8  -0.1 (3) "7", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.8   0.9 (3) "1", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22  0.9 (3) "0", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22 -0.1 (3) "184", msymbol(i) mlabsize(medium)), ///
	 scheme(lean1) legend( ring(0) pos(0)order(1 "Consistency" 2 "Inconsistency" 3 "Under-Reporting")) ///
	xtitle("SCAD") ytitle("MEMS")  aspectratio(1) ///
	xscale(range(-0.2 1.2)) yscale(range(-0.2 1.2)) ///
	xlabel(0(1)1) ylabel(0(1)1)  title("Post-Election Violence")
graph save Graph "Figure4d.gph", replace

* Figure 4
graph combine Figure4a.gph Figure4b.gph Figure4c.gph Figure4d.gph, ///
	row(1) graphregion(color(white)) xsize(18) ysize(5)
graph export "Figure4.pdf", replace

	
	

***********************************
* Figure 5
***********************************
use "Borzyskowski Wahman Data combined.dta", clear
keep if Malawi==0

* Figure 5a 
tab preday_EV preday_EV_ACLED if consistency_predayACLED ==1
tab preday_EV preday_EV_ACLED if consistency_predayACLED ==0
twoway (scatter preday_EV preday_EV_ACLED if consistency_predayACLED ==1, msymbol(Oh) jitter(15 15)) ///
	(scatter preday_EV preday_EV_ACLED if consistency_predayACLED ==0 & preday_EV_ACLED==1, msymbol(Th) jitter(15 15))  ///
	(scatter preday_EV preday_EV_ACLED if consistency_predayACLED ==0 & preday_EV_ACLED==0, msymbol(T) jitter(15 15) mcolor("red"))  ///
	(scatteri 0.8  -0.1 (3) "63", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.8   0.9 (3) "17", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22  0.9 (3) "9", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22 -0.1 (3) "67", msymbol(i) mlabsize(medium)), ///
	scheme(lean1) legend(ring(0) pos(0) order(1 "Consistency" 2 "Inconsistency" 3 "Under-Reporting")) ///
	xtitle("ACLED") ytitle("ZEMS")  aspectratio(1) ///
	xscale(range(-0.2 1.2)) yscale(range(-0.2 1.2)) ///
	xlabel(0(1)1) ylabel(0(1)1) title("Pre-Election Violence") 
graph save Graph "Figure5a.gph", replace
	
* Figure 5b 
tab post_EV post_EV_ACLED if consistency_postACLED ==1
tab post_EV post_EV_ACLED if consistency_postACLED ==0
twoway (scatter post_EV post_EV_ACLED if consistency_postACLED ==1, msymbol(Oh) jitter(15 15)) ///
	(scatter post_EV post_EV_ACLED if consistency_postACLED ==0 & post_EV_ACLED==1, msymbol(Th) jitter(15 15))  ///
	(scatter post_EV post_EV_ACLED if consistency_postACLED ==0 & post_EV_ACLED==0, msymbol(T) jitter(15 15) mcolor("red"))  ///
	(scatteri 0.8  -0.1 (3) "8", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.8   0.9 (3) "6", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22  0.9 (3) "8", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22 -0.1 (3) "134", msymbol(i) mlabsize(medium)), ///
	scheme(lean1) legend(ring(0) pos(0) order(1 "Consistency" 2 "Inconsistency" 3 "Under-Reporting")) ///
	xtitle("ACLED") ytitle("ZEMS")  aspectratio(1) ///
	xscale(range(-0.2 1.2)) yscale(range(-0.2 1.2)) ///
	xlabel(0(1)1) ylabel(0(1)1)  title("Post-Election Violence")
graph save Graph "Figure5b.gph", replace
	
* Figure 5c
tab preday_EV preday_EV_SCAD if consistency_predaySCAD ==1
tab preday_EV preday_EV_SCAD if consistency_predaySCAD ==0
twoway (scatter preday_EV preday_EV_SCAD if consistency_predaySCAD ==1, msymbol(Oh) jitter(15 15)) ///
	(scatter preday_EV preday_EV_SCAD if consistency_predaySCAD ==0 & preday_EV_SCAD==1 , msymbol(Th) jitter(15 15) )  ///
	(scatter preday_EV preday_EV_SCAD if consistency_predaySCAD ==0 & preday_EV_SCAD==0 , msymbol(T) jitter(15 15) mcolor("red"))  ///
	(scatteri 0.8  -0.1 (3) "79", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.8   0.9 (3) "1", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22  0.9 (3) "0", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22 -0.1 (3) "76", msymbol(i) mlabsize(medium)), ///
	scheme(lean1) legend(ring(0) pos(0)  order(1 "Consistency" 2 "Inconsistency" 3 "Under-Reporting")) ///
	xtitle("SCAD") ytitle("ZEMS")  aspectratio(1) ///
	xscale(range(-0.2 1.2)) yscale(range(-0.2 1.2)) ///
	xlabel(0(1)1) ylabel(0(1)1) title("Pre-Election Violence")
graph save Graph "Figure5c.gph", replace

* Figure 5d
tab post_EV post_EV_SCAD if consistency_postSCAD ==1
tab post_EV post_EV_SCAD if consistency_postSCAD ==0
twoway (scatter post_EV post_EV_SCAD if consistency_postSCAD ==1, msymbol(Oh) jitter(15 15)) ///
	(scatter post_EV post_EV_SCAD if consistency_postSCAD ==0 & post_EV_SCAD==1, msymbol(Th) jitter(15 15))  ///
	(scatter post_EV post_EV_SCAD if consistency_postSCAD ==0 & post_EV_SCAD==0, msymbol(T) jitter(15 15) mcolor("red"))  ///
	(scatteri 0.8  -0.1 (3) "13", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.8   0.9 (3) "1", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22  0.9 (3) "0", msymbol(i) mlabsize(medium)) ///
	(scatteri 0.22 -0.1 (3) "142", msymbol(i) mlabsize(medium)), ///
	scheme(lean1) legend(ring(0) pos(0)  order(1 "Consistency" 2 "Inconsistency" 3 "Under-Reporting")) ///
	xtitle("SCAD") ytitle("ZEMS")  aspectratio(1) ///
	xscale(range(-0.2 1.2)) yscale(range(-0.2 1.2)) ///
	xlabel(0(1)1) ylabel(0(1)1) title("Post-Election Violence")
graph save Graph "Figure5d.gph", replace
	
* Figure 5
graph combine Figure5a.gph Figure5b.gph Figure5c.gph Figure5d.gph, ///
	row(1) graphregion(color(white)) xsize(18) ysize(5)
graph export "Figure5.pdf", replace

	
	
	
***********************************
* Figure 6 
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

* Figure 6a
set more off
local IVs PopulationDensityLog   Nightlightlog   Democracy     Competition        
logit preday_EV 			`IVs'    , cluster(RCODE)
margins, dydx (PopulationDensityLog) atmeans saving(UrbanizationMonitor, replace)
logit preday_EV_EITHER 		`IVs'     , cluster(RCODE)
margins, dydx (PopulationDensityLog) atmeans saving(UrbanizationMedia, replace)
combomarginsplot  UrbanizationMonitor UrbanizationMedia, ///
	graphregion(color(white))  scheme(lean1) legend(position(1) ring(0)) ///
	ytitle("Marginal Effect of Urbanization") xtitle("Data") title("") ///
	plotopts(msymbol(O) lcolor(none)) aspectratio(1.0) ///
	xscale(range(0 (1) 3)) yline(0, lpattern("dash")) ///
	xlabel(1 "Monitor" 2 "Media") 
graph save "Figure6a.gph", replace

* Figure 6b
set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog   Democracy     Competition        
logit preday_EV 			`IVs'    , cluster(RCODE)
margins, dydx (Nightlightlog) atmeans saving(NightlightsMonitor, replace)
logit preday_EV_EITHER 		`IVs'     , cluster(RCODE)
margins, dydx (Nightlightlog) atmeans saving(NightlightsMedia, replace)
combomarginsplot  NightlightsMonitor NightlightsMedia, ///
	graphregion(color(white))  scheme(lean1) legend(position(1) ring(0)) ///
	ytitle("Marginal Effect of Night lights") xtitle("Data") title("") ///
	plotopts(msymbol(O) lcolor(none)) aspectratio(1.0) ///
	xscale(range(0 (1) 3)) yline(0, lpattern("dash")) ///
	xlabel(1 "Monitor" 2 "Media") 
graph save "Figure6b.gph", replace

* Figure 6c
set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog   Democracy     Competition        
logit preday_EV 			`IVs'    , cluster(RCODE)
margins, dydx (Democracy) atmeans saving(DemocracyMonitor, replace)
logit preday_EV_EITHER 		`IVs'     , cluster(RCODE)
margins, dydx (Democracy) atmeans saving(DemocracyMedia, replace)
combomarginsplot  DemocracyMonitor DemocracyMedia, ///
	graphregion(color(white))  scheme(lean1) legend(position(1) ring(0)) ///
	ytitle("Marginal Effect of Democracy") xtitle("Data") title("") ///
	plotopts(msymbol(O) lcolor(none)) aspectratio(1.0) ///
	xscale(range(0 (1) 3)) yline(0, lpattern("dash")) yscale(range(0 (0.1) 0.5)) ///
	 ylabel(0 (0.1) 0.5)  xlabel(1 "Monitor" 2 "Media") 
graph save "Figure6c.gph", replace

* Figure 6d
set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog   Democracy     Competition        
logit preday_EV 			`IVs'    , cluster(RCODE)
margins, dydx (Competition) atmeans saving(CompetitionMonitor, replace)
logit preday_EV_EITHER 		`IVs'     , cluster(RCODE)
margins, dydx (Competition) atmeans saving(CompetitionMedia, replace)
combomarginsplot  CompetitionMonitor CompetitionMedia, ///
	graphregion(color(white))  scheme(lean1) legend(position(1) ring(0)) ///
	ytitle("Marginal Effect of Competition") xtitle("Data") title("") ///
	plotopts(msymbol(O) lcolor(none)) aspectratio(1.0) ///
	xscale(range(0 (1) 3)) yline(0, lpattern("dash"))   xlabel(1 "Monitor" 2 "Media") 
graph save "Figure6d.gph", replace

* Figure 6 combined
graph combine Figure6a.gph Figure6b.gph Figure6c.gph Figure6d.gph, ///
	row(2) graphregion(color(white)) imargin(0 0 0 0)
graph export "Figure6.pdf", replace



***********************************
* Table 1 
***********************************
use "Borzyskowski Wahman Data combined.dta", clear
keep if Malawi==1

set more off
eststo clear
local IVs PopulationDensity  HistoryEV margin_percentPres Literacy Electrification
logit UnderreportingPreACLED 	`IVs' , cluster(RCODE)
est store Table1m1 
logit UnderreportingPostACLED 	`IVs' , cluster(RCODE)
est store Table1m2
logit UnderreportingPreSCAD		`IVs' , cluster(RCODE)
est store Table1m3 
logit  UnderreportingPostSCAD 	`IVs' , cluster(RCODE)
est store Table1m4
logit UnderreportingPreEither 	`IVs' , cluster(RCODE)
est store Table1m5
logit UnderreportingPostEither 	`IVs' , cluster(RCODE)
est store Table1m6
* Table 1:
estout Table1m* using Table1.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 



***********************************
* Table 2 
***********************************
use "Borzyskowski Wahman Data combined.dta", clear
keep if Malawi==0

set more off
eststo clear
local IVs PopulationDensity  HistoryEV  Literacy Electrification
logit UnderreportingPreACLED 	`IVs'  margin_percentPres2015  if RCODE!=5, cluster(RCODE)
est store Table2m1 
logit UnderreportingPostACLED 	`IVs'  margin_percentPres2016  if RCODE!=5 , cluster(RCODE)
est store Table2m2
logit UnderreportingPreSCAD		`IVs'   margin_percentPres2015  if RCODE!=5, cluster(RCODE)
est store Table2m3 
logit  UnderreportingPostSCAD 	`IVs'   margin_percentPres2016  if RCODE!=5, cluster(RCODE)
est store Table2m4
logit UnderreportingPreEither 	`IVs'   margin_percentPres2015  if RCODE!=5, cluster(RCODE)
est store Table2m5
logit UnderreportingPostEither 	`IVs'  	margin_percentPres2016   if RCODE!=5, cluster(RCODE)
est store Table2m6
* Table 2:
estout Table2m* using Table2.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 



***********************************
* Table 3 
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog   Democracy     Competition        
logit preday_EV 			`IVs'    , cluster(RCODE)
est store Table3m1 
logit preday_EV_ACLED 		`IVs'     , cluster(RCODE)
est store Table3m2
logit preday_EV_SCAD 		`IVs'    , cluster(RCODE)   
est store Table3m3
logit preday_EV_EITHER 		`IVs'     , cluster(RCODE)
est store Table3m4
* Table 3:
estout Table3m* using Table3.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 



***********************************
* Table 4
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog   Democracy Competition        
logit post_EV 			`IVs'  , cluster(RCODE)
est store Table4m1 
logit post_EV_ACLED 	`IVs'  , cluster(RCODE)
est store Table4m2
logit post_EV_SCAD 		`IVs'  , cluster(RCODE)
est store Table4m3
logit post_EV_EITHER 	`IVs'  , cluster(RCODE)
est store Table4m4
* Table 4:
estout Table4m* using Table4.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 










**********************************************************************
**********************  APPENDIX MATERIAL  ***************************
**********************************************************************


***********************************
* Appendix Table A1 
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

set more off
sutex preday_EV post_EV preday_EV_ACLED post_EV_ACLED ///
	preday_EV_SCAD post_EV_SCAD ///
	preday_EV_EITHER post_EV_EITHER ///
	UnderreportingPreACLED UnderreportingPostACLED ///
	UnderreportingPreSCAD UnderreportingPostSCAD ///
	UnderreportingPreEither UnderreportingPostEither ///
	consistency_predayACLED consistency_postACLED ///
	consistency_predaySCAD consistency_postSCAD ///
	consistency_predayEITHER consistency_postEITHER ///
	PopulationDensity  HistoryEV ///
	margin_percentPres Literacy Electrification ///	
	PopulationDensityLog   Nightlightlog   Democracy Competition if Malawi==1  , ///
	minmax	label  file(AppendixTableA1.tex)


	
***********************************
* Appendix Table A2
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

set more off
sutex preday_EV post_EV preday_EV_ACLED post_EV_ACLED ///
	preday_EV_SCAD post_EV_SCAD ///
	preday_EV_EITHER post_EV_EITHER ///
	UnderreportingPreACLED UnderreportingPostACLED ///
	UnderreportingPreSCAD UnderreportingPostSCAD ///
	UnderreportingPreEither UnderreportingPostEither ///
	consistency_predayACLED consistency_postACLED ///
	consistency_predaySCAD consistency_postSCAD ///
	consistency_predayEITHER consistency_postEITHER ///
	PopulationDensity  HistoryEV ///
	margin_percentPres2015 margin_percentPres2016 Literacy Electrification ///	
	PopulationDensityLog   Nightlightlog  Democracy Competition if Malawi==0, ///
	minmax	label  file(AppendixTableA2.tex)



***********************************
* Appendix Table A3 
***********************************
use "Borzyskowski Wahman Data combined.dta", clear
keep if Malawi==0

set more off
eststo clear
local IVs PopulationDensity  HistoryEV  Literacy Electrification
logit UnderreportingPreACLED 	`IVs'   margin_percentPres2015 , cluster(RCODE)
est store TableA3m1 
logit UnderreportingPostACLED 	`IVs'   margin_percentPres2016  , cluster(RCODE)
est store TableA3m2
logit UnderreportingPreSCAD		`IVs'   margin_percentPres2015  , cluster(RCODE)
est store TableA3m3 
logit  UnderreportingPostSCAD 	`IVs'   margin_percentPres2016  , cluster(RCODE)
est store TableA3m4
logit UnderreportingPreEither 	`IVs'   margin_percentPres2015 , cluster(RCODE)
est store TableA3m5
logit UnderreportingPostEither 	`IVs'  	margin_percentPres2016   , cluster(RCODE)
est store TableA3m6
* Appendix Table A3:
estout TableA3m* using AppendixTableA3.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 



***********************************
* Appendix Table A4 
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

set more off
eststo clear
local IVs PopulationDensity  HistoryEV  Literacy Electrification i.Malawi
logit UnderreportingPreACLED 	`IVs' margin_percentPresPRE if RCODE!=5, cluster(RCODE)
est store TableA4m1 
logit UnderreportingPostACLED 	`IVs' margin_percentPresPOST if RCODE!=5, cluster(RCODE)
est store TableA4m2
logit UnderreportingPreSCAD		`IVs' margin_percentPresPRE if RCODE!=5, cluster(RCODE)
est store TableA4m3 
logit  UnderreportingPostSCAD 	`IVs' margin_percentPresPOST if RCODE!=5, cluster(RCODE)
est store TableA4m4
logit UnderreportingPreEither 	`IVs' margin_percentPresPRE if RCODE!=5, cluster(RCODE)
est store TableA4m5
logit UnderreportingPostEither 	`IVs' margin_percentPresPOST if RCODE!=5, cluster(RCODE)
est store TableA4m6
* Appendix Table A4:
estout TableA4m* using AppendixTableA4.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) ///
	drop(*.Malawi)



***********************************
* Appendix Table A5
***********************************
use "Borzyskowski Wahman Data combined.dta", clear
keep if Malawi==1

set more off
eststo clear
local IVs PopulationDensity  HistoryEV  Literacy Electrification
logit UnderreportingPreACLED 	`IVs' , cluster(RCODE)
est store TableA5m1 
logit UnderreportingPostACLED 	`IVs'    , cluster(RCODE)
est store TableA5m2
logit UnderreportingPreSCAD		`IVs'  , cluster(RCODE)
est store TableA5m3 
logit  UnderreportingPostSCAD 	`IVs'   , cluster(RCODE)
est store TableA5m4
logit UnderreportingPreEither 	`IVs'    , cluster(RCODE)
est store TableA5m5
logit UnderreportingPostEither 	`IVs'    , cluster(RCODE)
est store TableA5m6
* Appendix Table A5:
estout TableA5m* using AppendixTableA5.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 


	
***********************************
* Appendix Table A6
***********************************
use "Borzyskowski Wahman Data combined.dta", clear
keep if Malawi==0

set more off
eststo clear
local IVs PopulationDensity  HistoryEV  Literacy Electrification
logit UnderreportingPreACLED 	`IVs'     if RCODE!=5, cluster(RCODE)
est store TableA6m1 
logit UnderreportingPostACLED 	`IVs'    	 if RCODE!=5 , cluster(RCODE)
est store TableA6m2
logit UnderreportingPreSCAD		`IVs'       if RCODE!=5, cluster(RCODE)
est store TableA6m3 
logit  UnderreportingPostSCAD 	`IVs'       if RCODE!=5, cluster(RCODE)
est store TableA6m4
logit UnderreportingPreEither 	`IVs'        if RCODE!=5, cluster(RCODE)
est store TableA6m5
logit UnderreportingPostEither 	`IVs'  		  if RCODE!=5, cluster(RCODE)
est store TableA6m6
* Appendix Table A6:
estout TableA6m* using AppendixTableA6.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 

	

***********************************
* Appendix Table A7
***********************************
use "Borzyskowski Wahman Data combined.dta", clear
keep if Malawi==1

set more off
eststo clear
local IVs   HistoryEV margin_percentPres Literacy Electrification
logit UnderreportingPreACLED 	`IVs' , cluster(RCODE)
est store TableA7m1 
logit UnderreportingPostACLED 	`IVs'    , cluster(RCODE)
est store TableA7m2
logit UnderreportingPreSCAD		`IVs'  , cluster(RCODE)
est store TableA7m3 
logit  UnderreportingPostSCAD 	`IVs'   , cluster(RCODE)
est store TableA7m4
logit UnderreportingPreEither 	`IVs'    , cluster(RCODE)
est store TableA7m5
logit UnderreportingPostEither 	`IVs'    , cluster(RCODE)
est store TableA7m6
* Appendix Table A7:
estout TableA7m* using AppendixTableA7.tex, ///
	replace style(tex) eqlabels(none) label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 



***********************************
* Appendix Table A8
***********************************
use "Borzyskowski Wahman Data combined.dta", clear
keep if Malawi==0

set more off
eststo clear
local IVs   HistoryEV  Literacy Electrification
logit UnderreportingPreACLED 	`IVs'  margin_percentPres2015  if RCODE!=5, cluster(RCODE)
est store TableA8m1 
logit UnderreportingPostACLED 	`IVs'  margin_percentPres2016  if RCODE!=5 , cluster(RCODE)
est store TableA8m2
logit UnderreportingPreSCAD		`IVs'   margin_percentPres2015  if RCODE!=5, cluster(RCODE)
est store TableA8m3 
logit  UnderreportingPostSCAD 	`IVs'   margin_percentPres2016  if RCODE!=5, cluster(RCODE)
est store TableA8m4
logit UnderreportingPreEither 	`IVs'    margin_percentPres2015  if RCODE!=5, cluster(RCODE)
est store TableA8m5
logit UnderreportingPostEither 	`IVs'   margin_percentPres2016   if RCODE!=5, cluster(RCODE)
est store TableA8m6
* Appendix Table A8:
estout TableA8m* using AppendixTableA8.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) ///
	order(HistoryEV margin_p* margin_percentPres2016 Literacy Electrification)


	
***********************************
* Appendix Table A9
***********************************
use "Borzyskowski Wahman Data combined.dta", clear
keep if Malawi==1

set more off
eststo clear
local IVs PopulationDensity  HistoryEV margin_percentPres Literacy Electrification
logit UnderreportAnyViolPreACLED 	`IVs' , cluster(RCODE)
est store TableA9m1 
logit UnderreportAnyViolPostACLED 	`IVs'   , cluster(RCODE)
est store TableA9m2
logit UnderreportAnyViolPreSCAD		`IVs'  , cluster(RCODE)
est store TableA9m3 
logit  UnderreportAnyViolPostSCAD 	`IVs'   , cluster(RCODE)
est store TableA9m4
logit UnderreportAnyViolPreEither 	`IVs'    , cluster(RCODE)
est store TableA9m5
logit UnderreportAnyViolPostEither 	`IVs'    , cluster(RCODE)
est store TableA9m6
* Appendix Table A9:
estout  TableA9m* using AppendixTableA9.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 



***********************************
* Appendix Table A10
***********************************
use "Borzyskowski Wahman Data combined.dta", clear
keep if Malawi==0

set more off
eststo clear
local IVs PopulationDensity  HistoryEV  Literacy Electrification
logit UnderreportAnyViolPreACLED 	`IVs'  margin_percentPres2015  if RCODE!=5, cluster(RCODE)
est store TableA10m1 
logit UnderreportAnyViolPostACLED 	`IVs'   margin_percentPres2016  if RCODE!=5 , cluster(RCODE)
est store TableA10m2
logit UnderreportAnyViolPreSCAD		`IVs'    margin_percentPres2015  if RCODE!=5, cluster(RCODE)
est store TableA10m3 
logit  UnderreportAnyViolPostSCAD 	`IVs'    margin_percentPres2016  if RCODE!=5, cluster(RCODE)
est store TableA10m4
logit UnderreportAnyViolPreEither 	`IVs'     margin_percentPres2015  if RCODE!=5, cluster(RCODE)
est store TableA10m5
logit UnderreportAnyViolPostEither 	`IVs'  	margin_percentPres2016   if RCODE!=5, cluster(RCODE)
est store TableA10m6
* Appendix Table A10:
estout TableA10m* using AppendixTableA10.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 


	
***********************************
* Appendix Table A11
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog   Democracy     Competition        
logit preday_EV 			`IVs'    , cluster(RCODE)
est store TableA11m1 
logit preday_ANY_ACLED 		`IVs'     , cluster(RCODE)
est store TableA11m2
logit preday_ANY_SCAD 		`IVs'    , cluster(RCODE)   
est store TableA11m3
logit preday_ANY_EITHER 	`IVs'     , cluster(RCODE)
est store TableA11m4
* Appendix Table A11:
estout TableA11m* using AppendixTableA11.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 



***********************************
* Appendix Figures A1 & A2: see lines 890-960
***********************************



***********************************
* Appendix Table A12
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog   Democracy     Competition        
logit preday_EV 			`IVs'     , robust
est store B_1 
logit preday_EV_ACLED 		`IVs'     , robust
est store  B_2
logit preday_EV_SCAD 		`IVs'     , robust 
est store  B_3
logit preday_EV_EITHER 		`IVs'     , robust
est store  B_4 
* Appendix Table A12:
estout B_* using AppendixTableA12.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 

	
	
***********************************
* Appendix Table A13
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog        Competition    i.Malawi    
logit preday_EV 			`IVs'     , robust 
est store C_1
logit preday_EV_ACLED 		`IVs'      , robust  
est store C_2
logit preday_EV_SCAD 		`IVs'      , robust
est store C_3 
logit preday_EV_EITHER 		`IVs'      , robust 
est store C_4 
* Appendix Table A13:
estout C_* using AppendixTableA13.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) ///
	drop (*.Malawi)

	
	
***********************************
* Appendix Table A14
***********************************
use "Borzyskowski Wahman Data combined.dta", clear
	
set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog        Competition    i.Malawi    
logit preday_EV 			`IVs'    , cluster(RCODE)
est store D_1
logit preday_EV_ACLED 		`IVs'     , cluster(RCODE) 
est store D_2
logit preday_EV_SCAD 		`IVs'     , cluster(RCODE) 
est store D_3 
logit preday_EV_EITHER 		`IVs'     , cluster(RCODE) 
est store D_4
* Appendix Table A14:
estout D_* using AppendixTableA14.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) ///
	drop(*Malawi)



***********************************
* Appendix Table A15
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog   Democracy     Competition        
reg preday_EV 				`IVs'    , cluster(RCODE)
est store E_1
reg preday_EV_ACLED 		`IVs'     , cluster(RCODE)
est store E_2
reg preday_EV_SCAD 			`IVs'    , cluster(RCODE)   
est store E_3
reg preday_EV_EITHER 		`IVs'     , cluster(RCODE)
est store E_4
* Appendix Table A15:
estout E_* using AppendixTableA15.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 


	
***********************************
* Appendix Table A16
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog   Democracy     Competition        
reg preday_EV 				`IVs'     , robust 
est store F_1 
reg preday_EV_ACLED 		`IVs'      , robust  
est store F_2
reg preday_EV_SCAD 			`IVs'      , robust  
est store F_3 
reg preday_EV_EITHER 		`IVs'      , robust  
est store F_4 
* Appendix Table A16:
estout F_* using AppendixTableA16.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 



***********************************
* Appendix Table A17
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog        Competition         
areg preday_EV 				`IVs'   , a(Malawi)  robust
est store G_1 
areg preday_EV_ACLED 		`IVs'   , a(Malawi)   robust 
est store G_2
areg preday_EV_SCAD 		`IVs'   , a(Malawi)   robust 
est store G_3  
areg preday_EV_EITHER 		`IVs'   , a(Malawi)   robust 
est store G_4  
* Appendix Table A17:
estout G_* using AppendixTableA17.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 



***********************************
* Appendix Table A18
***********************************
use "Borzyskowski Wahman Data combined.dta", clear

set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog        Competition       
areg preday_EV 				`IVs'    , a(Malawi) cluster(RCODE)
est store H_1 
areg preday_EV_ACLED 		`IVs'     , a(Malawi) cluster(RCODE) 
est store H_2
areg preday_EV_SCAD 		`IVs'     , a(Malawi) cluster(RCODE) 
est store H_3  
areg preday_EV_EITHER 		`IVs'     , a(Malawi) cluster(RCODE) 
est store H_4 
* Appendix Table A18:
estout H_* using AppendixTableA18.tex, ///
	replace style(tex) eqlabels(none)  label cells(b(fmt(%9.3f) star) ///
	se(par fmt(%9.3f))) stats(N aic bic ll, fmt(0 2 2 2) ///
	label("Observations"  "AIC" "BIC" "LL")) ///
	starlevels(* .1 ** .05 *** .01) 


	
***********************************
* Appendix Figure A1
***********************************

* Table 3 (original, for "A" estimates)
use "Borzyskowski Wahman Data combined.dta", clear
set more off
eststo clear
local IVs PopulationDensityLog   Nightlightlog   Democracy     Competition        
logit preday_EV 			`IVs'    , cluster(RCODE)
est store A_1 
logit preday_EV_ACLED 		`IVs'     , cluster(RCODE)
est store A_2
logit preday_EV_SCAD 		`IVs'    , cluster(RCODE)   
est store A_3
logit preday_EV_EITHER 		`IVs'     , cluster(RCODE)
est store A_4


* Figure A1a
coefplot (A_1) (B_1) (C_1) (D_1) ///
	(E_1) (F_1) (G_1) (H_1), ///
	aseq swapnames legend(off)   aspectratio(1.0)  offset(0) ///
	drop(_cons Nightlightlog Competition Democracy 1.Malawi) ///
	xline(0, lpattern("dash")) scheme(lean1)   grid(none)   ///
	xtitle(Coefficient estimates for Urbanization in Monitor Data)
graph save Graph "FigureA1a.gph", replace
* Figure A1b
coefplot (A_4) (B_4) (C_4) (D_4) ///
	(E_4) (F_4) (G_4) (H_4), ///
	aseq swapnames legend(off)   aspectratio(1.0)  offset(0) ///
	drop(_cons Nightlightlog Competition Democracy 1.Malawi) ///
	xline(0, lpattern("dash")) scheme(lean1)   grid(none)   ///
	xtitle(Coefficient estimates for Urbanization in Media Data)
graph save Graph "FigureA1b.gph", replace
* Figure A1
graph combine FigureA1a.gph FigureA1b.gph, ///
	row(1) graphregion(color(white)) xsize(10) ysize(5)
graph export "FigureA1.pdf", replace



***********************************
* Appendix Figure A2
***********************************

* Figure A2a	
coefplot (A_1) (B_1) (C_1) (D_1) ///
	(E_1) (F_1) (G_1) (H_1), ///
	aseq swapnames legend(off)   aspectratio(1.0)  offset(0) ///
	drop(_cons PopulationDensityLog Competition Democracy 1.Malawi) ///
	xline(0, lpattern("dash")) scheme(lean1)   grid(none)   ///
	xtitle(Coefficient estimates for Night lights in Monitor Data)
graph save Graph "FigureA2a.gph", replace
* Figure A2b
coefplot (A_4) (B_4) (C_4) (D_4) ///
	(E_4) (F_4) (G_4) (H_4), ///
	aseq swapnames legend(off)   aspectratio(1.0)  offset(0) ///
	drop(_cons PopulationDensityLog Competition Democracy 1.Malawi) ///
	xline(0, lpattern("dash")) scheme(lean1)   grid(none)   ///
	xtitle(Coefficient estimates for Night lights in Media Data)
graph save Graph "FigureA2b.gph", replace
* Figure A2
graph combine FigureA2a.gph FigureA2b.gph, ///
	row(1) graphregion(color(white)) xsize(10) ysize(5)
graph export "FigureA2.pdf", replace



***********************************
* Appendix Figure A3 
***********************************
use "Borzyskowski Wahman Data for Figure A3.dta", clear

keep if country_name == "Benin" | country_name == "Botswana" | ///
	country_name == "Burkina Faso" | country_name == "Ghana" | ///
	country_name == "Guinea" | country_name == "Guinea-Bissau" | ///
	country_name == "Ivory Coast" | country_name == "Kenya" | ///
	country_name == "Lesotho" | country_name == "Liberia" | ///
	country_name == "Madagascar" | country_name == "Malawi" | ///
	country_name == "Mali" | country_name == "Mozambique" | ///
	country_name == "Namibia" | country_name == "Niger" | ///
	country_name == "Nigeria" | country_name == "Senegal" | ///
	country_name == "Sierra Leone" | country_name == "Somaliland" | ///
	country_name == "South Africa" | country_name == "Tanzania" | ///
	country_name == "Zambia" | country_name == "Zimbabwe"
drop if year < 1991

set more off
gen flipvar=4-v2elintim_osp
order flipvar, after(v2elintim_osp)
sum flipvar v2elintim_osp, detail

gen flipvar2=4-v2elpeace_osp
order flipvar2, after(v2elpeace_osp)
sum flipvar2 v2elpeace_osp, detail

graph bar flipvar flipvar2, ///
	over(country_name, label(angle(45)labsize(small))) ///
	blabel(mean) scheme(lean1) yline(1.126055 1.386027)  ///
	legend(cols(2) position(6)   ///
	label(1 "Government Violence") label(2 "Non-Government Violence"))

graph export "FigureA3.pdf", replace

	

***********************************
* Appendix Figure A4
***********************************
use "Borzyskowski Wahman Data for Figures A4-A7.dta", clear

by v2elintim_ord v2elpeace_ord, sort: gen Numbered = _N
spineplot  v2elpeace_ord v2elintim_ord, ///
	text(Numbered, mlabcolor(black)) ///
	graphregion(color(white)) plotr(m(zero)) ///
	xtitle("Fraction by government violence", axis(1)) ///
	xtitle("Government violence", axis(2)) ///
	ytitle("Non-government violence", axis(1)) ///
	ytitle("Fraction by non-government violence", axis(2)) 	
graph export "FigureA4.pdf", replace



***********************************
* Appendix Figure A5
***********************************
use "Borzyskowski Wahman Data for Figures A4-A7.dta", clear

vioplot v2x_clphy, scheme(lean1) aspectratio(1)
graph export "FigureA5.pdf", replace



***********************************
* Appendix Figure A6
***********************************
use "Borzyskowski Wahman Data for Figures A4-A7.dta", clear

graph twoway (scatter v2x_polyarchy v2mecenefm if MZ == 1, ///
	mcolor(red) msymbol(O) legend(off) scheme(lean1) ///
	aspectratio(1) mlabel(country_name) ) ///
	(scatter v2x_polyarchy v2mecenefm if MZ == 0, ///
	mcolor(blue) msymbol(Oh) legend(off) ) 
graph export "FigureA6.pdf", replace
	

	
***********************************
* Appendix Figure A7
***********************************
use "Borzyskowski Wahman Data for Figures A4-A7.dta", clear

graph twoway (scatter  e_populationLOG e_areaLOG  if MZ == 1, ///
	mcolor(red) msymbol(O) legend(off) scheme(lean1) ///
	aspectratio(1) mlabel(country_name) mlabposition(8)) ///
	(scatter e_populationLOG e_areaLOG if MZ == 0, ///
	mcolor(blue) msymbol(Oh) legend(off) ) 
graph export "FigureA7.pdf", replace



