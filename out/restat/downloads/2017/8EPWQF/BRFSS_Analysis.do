clear* 
	*******************************************
	***		BRFSS - Asymmetric Experience	***
	*******************************************

cd "/Users/wardg/Dropbox (MIT)/Projects/Loss Aversion Project/ReStat Replication Files/BRFSS/"

use "brfss_restat.dta", clear


global dem	controls_* 


cap log close
log using "BRFSStables.smcl", replace


*** Table 4 (cols 5+6) *** 
eststo clear
eststo: xi: xtreg zlsatisfy		growth   	$dem i.quarter, fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		growthmin growthplus  	$dem i.quarter, fe cluster(statequarter) nonest
esttab using "brfss_tab4.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  scalars("N_g States" "N_clust State-Quarters") sfmt(%12.0f) ///
indicate("State and Season FEs = _Iqua*" "Individual Controls = $dem") noconstant label order(growth growthmin growthplus) nogaps


*** Table 7  *** 
eststo clear
eststo: xi: xtreg zlsatisfy		growth   				 lrpersinc  $dem i.quarter, fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		growthmin growthplus 	 lrpersinc	$dem i.quarter, fe cluster(statequarter) nonest

eststo: xi: xtreg zlsatisfy		growth   				 unemp_rate	$dem i.quarter, fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		growthmin growthplus  	 unemp_rate	$dem i.quarter, fe cluster(statequarter) nonest

eststo: xi: xtreg zlsatisfy		growth   				inflation 	$dem i.quarter, fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		growthmin growthplus  	inflation 	$dem i.quarter, fe cluster(statequarter) nonest

eststo: xi: xtreg zlsatisfy		growth  				 lrpersinc unemp_rate inflation	$dem i.quarter, fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		growthmin growthplus 	lrpersinc unemp_rate inflation 	$dem i.quarter, fe cluster(statequarter) nonest
esttab using "brfss_tab7.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01) scalars("N_g States" "N_clust State-Quarters") sfmt(%12.0f)   ///
indicate("State and Season FEs = _Iqua*" "Individual Controls = $dem") noconstant label order(growth growthmin growthplus lrpersinc unemp_rate inflation) nogaps

*** Table SOM.4  *** 
eststo clear
eststo: xi: xtreg zlsatisfy		growth   l1growth	$dem i.quarter, fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		growthmin growthplus  l1growthmin l1growthplus	$dem i.quarter, fe cluster(statequarter) nonest

eststo: xi: xtreg zlsatisfy		growth   	l1growth			 lrpersinc  $dem i.quarter, fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		growthmin growthplus l1growthmin l1growthplus	 lrpersinc	$dem i.quarter, fe cluster(statequarter) nonest

eststo: xi: xtreg zlsatisfy		growth   l1growth				 unemp_rate	$dem i.quarter, fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		growthmin growthplus l1growthmin l1growthplus 	 unemp_rate	$dem i.quarter, fe cluster(statequarter) nonest

eststo: xi: xtreg zlsatisfy		growth   l1growth				inflation 	$dem i.quarter, fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		growthmin growthplus l1growthmin l1growthplus 	inflation 	$dem i.quarter, fe cluster(statequarter) nonest

eststo: xi: xtreg zlsatisfy		growth  l1growth				 lrpersinc unemp_rate inflation	$dem i.quarter, fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		growthmin growthplus l1growthmin l1growthplus	lrpersin unemp_rate inflation 	$dem i.quarter, fe cluster(statequarter) nonest
esttab using "brfss_tabsom4.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01) scalars("N_g States" "N_clust State-Quarters") sfmt(%12.0f) nogaps ///
indicate("State and Season FEs = _Iqua*" "Individual Controls = $dem") noconstant label order(growth growthmin growthplus l1growth l1growthmin l1growthplus lrpersinc unemp_rate inflation)

*** Table SOM.5  *** 
eststo clear
eststo: xi: xtreg zlsatisfy		growth   	$dem i.quarter if totalpresent==24, fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		growthmin growthplus  	$dem i.quarter if totalpresent==24, fe cluster(statequarter) nonest
esttab using "brfss_tabsom5.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  scalars("N_g States" "N_clust State-Quarters") sfmt(%12.0f) ///
indicate("State and Season FEs = _Iqua*" "Individual Controls = $dem") noconstant label order(growth growthmin growthplus) nogaps


*** Table SOM.10  *** 
eststo clear
eststo: xi: xtreg zlsatisfy		growth_relativetomean10    	$dem i.quarter , fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		gr_belowmean10 gr_abovemean10  	$dem i.quarter  , fe cluster(statequarter) nonest
esttab using "brfss_tabsom10.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01) scalars("N_g States" "N_clust State-Quarters") sfmt(%12.0f) nogaps ///
indicate("State and Season FEs = _Iqua*" "Individual Controls = $dem") noconstant label order(growth growthmin growthplus)


*** Table SOM.16  *** 
eststo clear
eststo: xi: xtreg zlsatisfy		growth    	$dem i.quarter if topbottom ==0, fe cluster(statequarter) nonest
eststo: xi: xtreg zlsatisfy		growthmin growthplus  	$dem i.quarter  if topbottom ==0, fe cluster(statequarter) nonest
esttab using "brfss_tabsom16.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01) scalars("N_g States" "N_clust State-Quarters") sfmt(%12.0f) nogaps ///
indicate("State and Season FEs = _Iqua*" "Individual Controls = $dem") noconstant label order(growth growthmin growthplus)


cap log close

