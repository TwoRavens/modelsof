clear* 
	***************************************************************
	***		Gallup World Poll Analysis - Asymmetric Experience	***
	***************************************************************


cd "/Users/wardg/Dropbox (MIT)/Projects/Loss Aversion Project/ReStat Replication Files/Gallup World Poll/"
use "gwp_restat.dta", clear

set more off 

global dem	controls_* 


cap log close
log using "GWPtables.smcl", replace

*** Table 4 (cols 1+2) ***

eststo clear
eststo: xtreg std_lifeladder    gdpgrowth_wb 	 																		 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	 												 $dem i. waveround, fe cluster(countryyear)  nonest

*** Table 5 ***

eststo: xtreg std_lifeladder    gdpgrowth_wb 	loggdppc  																 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	loggdppc  										 $dem i. waveround, fe cluster(countryyear)  nonest

eststo: xtreg std_lifeladder    gdpgrowth_wb 	unemployment_rate 														 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	unemployment_rate 								 $dem i. waveround, fe cluster(countryyear)  nonest

eststo: xtreg std_lifeladder    gdpgrowth_wb 	inflation_rate  														 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	inflation_rate  								 $dem i. waveround, fe cluster(countryyear)  nonest

eststo: xtreg std_lifeladder    gdpgrowth_wb 	loggdppc inflation_rate unemployment_rate 								 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	loggdppc unemployment_rate inflation_rate 		 $dem i. waveround, fe cluster(countryyear)  nonest
esttab using "gwp_restat_tab5.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01) scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years")  sfmt(%12.3f %12.0f %12.0f) ///
 noconstant label order(gdpgrowth_wb gdpgrowth_wb_neg gdpgrowth_wb_pos 	loggdppc unemployment_rate inflation_rate)




*** Table 8 ***
eststo clear
foreach var of varlist 		happy_yesterday enjoyment_yesterday {
eststo: xtreg `var'     gdpgrowth_wb 	 																		 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg `var'     gdpgrowth_wb_neg gdpgrowth_wb_pos 													 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg `var'     gdpgrowth_wb 	 							loggdppc unemployment_rate inflation_rate	 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg `var'     gdpgrowth_wb_neg gdpgrowth_wb_pos 		loggdppc unemployment_rate inflation_rate	 $dem i. waveround, fe cluster(countryyear)  nonest
}
esttab using "gwp_restat_tab8.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01) scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years")  sfmt(%12.3f %12.0f %12.0f)  ///
 noconstant label order(gdpgrowth_wb gdpgrowth_wb_neg gdpgrowth_wb_pos loggdppc unemployment_rate inflation_rate)



*** Table 9 ***

eststo clear
foreach var of varlist 		 worry_yesterday stress_yesterday {
eststo: xtreg `var'     gdpgrowth_wb 	 																		 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg `var'     gdpgrowth_wb_neg gdpgrowth_wb_pos 													 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg `var'     gdpgrowth_wb 	 							loggdppc unemployment_rate inflation_rate	 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg `var'     gdpgrowth_wb_neg gdpgrowth_wb_pos 		loggdppc unemployment_rate inflation_rate	 $dem i. waveround, fe cluster(countryyear)  nonest
}
esttab using "gwp_restat_tab9.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01) scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years")  sfmt(%12.3f %12.0f %12.0f) ///
 noconstant label order(gdpgrowth_wb gdpgrowth_wb_neg gdpgrowth_wb_pos loggdppc unemployment_rate inflation_rate)


*** Table SOM.5 ***
eststo: xtreg std_lifeladder    gdpgrowth_wb  	 							  $dem i. waveround if panel_balance07to13==1 & year>2006, fe cluster(countryyear) nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 		  $dem i. waveround if panel_balance07to13==1 & year>2006, fe cluster(countryyear) nonest
esttab using "gwp_restat_tabsom5.csv", replace b(3) se(3)  star(* 0.1 ** 0.05 *** 0.01) scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years")  sfmt(%12.3f %12.0f %12.0f) ///
 noconstant label 


*** Table SOM.6 ***
eststo: xtreg std_lifeladder    gdpgrowth_wb  	 							  $dem i. waveround if num_negyears>0, fe cluster(countryyear) nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	 	  $dem i. waveround if num_negyears>0, fe cluster(countryyear) nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb  	 							  $dem i. waveround if panel_balance07to13_min1neg==1 & year>2006, fe cluster(countryyear) nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 		  $dem i. waveround if panel_balance07to13_min1neg==1 & year>2006, fe cluster(countryyear) nonest
esttab using "gwp_restat_tabsom6.csv", replace b(3) se(3)  star(* 0.1 ** 0.05 *** 0.01) scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years")  sfmt(%12.3f %12.0f %12.0f) ///
 noconstant label 


*** Table SOM.7 ***
eststo clear
eststo: xtreg std_lifeladder    gdpgrowth_wb econexpec_better econexpec_worse																 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos econexpec_better econexpec_worse			 $dem i. waveround, fe cluster(countryyear)  nonest
esttab using "gwp_restat_tabsom7.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01) scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years")  sfmt(%12.3f %12.0f %12.0f) ///
 noconstant label order(gdpgrowth_wb gdpgrowth_wb_neg gdpgrowth_wb_pos 	)

*** Table SOM.8 ***
replace wbhhconumptionpcgrowth = wbhhconumptionpcgrowth/100
eststo clear
eststo: xtreg std_lifeladder    gdpgrowth_wb 	                         wbhhconumptionpcgrowth															 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	 wbhhconumptionpcgrowth 	 													 $dem i. waveround, fe cluster(countryyear)  nonest
esttab using "gwp_restat_tabsom8.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01) scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years")  sfmt(%12.3f %12.0f %12.0f) ///
 noconstant label order(gdpgrowth_wb gdpgrowth_wb_neg gdpgrowth_wb_pos 	)



*** Table SOM.9 ***
reg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	 	finsat_gettingby 	 finsat_difficult	finsat_verydifficult 
gen sam = e(sample)
eststo clear
eststo: xtreg std_lifeladder    gdpgrowth_wb 	 																		 $dem i. waveround if sam==1, fe cluster(countryyear) nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	 												 $dem i. waveround if sam==1, fe cluster(countryyear) nonest
eststo: xtreg std_lifeladder    finsat_gettingby 	 finsat_difficult	finsat_verydifficult 																	 $dem i. waveround if sam==1, fe cluster(countryyear) nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb 	 				finsat_gettingby 	 finsat_difficult	finsat_verydifficult														 $dem i. waveround if sam==1, fe cluster(countryyear) nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	 	finsat_gettingby 	 finsat_difficult	finsat_verydifficult											 $dem i. waveround if sam==1, fe cluster(countryyear) nonest
esttab using "gwp_restat_tabsom9.csv", replace b(3) se(3)  star(* 0.1 ** 0.05 *** 0.01) scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years")  sfmt(%12.3f %12.0f %12.0f) ///
 noconstant label ///
refcat(finsat_gettingby "Feelings About HH Income (v. living comfortably)" , nolabel) 









*** Table SOM.10 ***
gen growth_relativetomean10 = gdpgrowth_wb - gdpgrowth_prev10ymean
mkspline gr_belowmean10 0 gr_abovemean10 = growth_relativetomean10
replace gr_belowmean10 = abs(gr_belowmean10)
lab var growth_relativetomean10 "Growth relative to 10Y mean"
lab var gr_belowmean10 "Low Growth"
lab var gr_abovemean10 "High Growth"

eststo clear 
eststo: xtreg std_lifeladder    growth_relativetomean10	 				 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_lifeladder    gr_belowmean10 gr_abovemean10	 			 $dem i. waveround, fe cluster(countryyear)  nonest
esttab using "gwp_restat_tabsom10.csv", replace b(3) se(3)  star(* 0.1 ** 0.05 *** 0.01) scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years")  sfmt(%12.3f %12.0f %12.0f) ///
 noconstant label 




*** Table SOM.13 ***
egen std_futureladder = std(lifesat_in5y)
eststo clear
eststo: xtreg std_futureladder    gdpgrowth_wb 	 																		 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_futureladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	 												 $dem i. waveround, fe cluster(countryyear)  nonest

eststo: xtreg std_futureladder    gdpgrowth_wb 	loggdppc  																 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_futureladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	loggdppc  										 $dem i. waveround, fe cluster(countryyear)  nonest

eststo: xtreg std_futureladder    gdpgrowth_wb 	unemployment_rate 														 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_futureladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	unemployment_rate 								 $dem i. waveround, fe cluster(countryyear)  nonest

eststo: xtreg std_futureladder    gdpgrowth_wb 	inflation_rate  														 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_futureladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	inflation_rate  								 $dem i. waveround, fe cluster(countryyear)  nonest

eststo: xtreg std_futureladder    gdpgrowth_wb 	loggdppc inflation_rate unemployment_rate 								 $dem i. waveround, fe cluster(countryyear)  nonest
eststo: xtreg std_futureladder    gdpgrowth_wb_neg gdpgrowth_wb_pos 	loggdppc unemployment_rate inflation_rate 		 $dem i. waveround, fe cluster(countryyear)  nonest
esttab using "gwp_restat_tabsom13.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01) scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years")  sfmt(%12.3f %12.0f %12.0f) ///
 noconstant label order(gdpgrowth_wb gdpgrowth_wb_neg gdpgrowth_wb_pos 	loggdppc unemployment_rate inflation_rate)



*** Table SOM.16 ***
collapse gdpgrowth_wb std_lifeladder,  by(code year)
drop if std_lifeladder==.
xtile growth_pctile = gdpgrowth_wb, nq(100)
save "growth_pctile.dta", replace
use "gwp_restat.dta", clear
merge m:1 code year using "growth_pctile"
drop _merge
gen exclude = (growth_pctile==1 | growth_pctile==100)
eststo clear
eststo: xtreg std_lifeladder    gdpgrowth_wb 	 																			  $dem i. waveround if exclude==0, fe cluster(countryyear) nonest
eststo: xtreg std_lifeladder    gdpgrowth_wb_neg gdpgrowth_wb_pos	 													  $dem i. waveround if exclude==0, fe cluster(countryyear) nonest
esttab using "gwp_restat_tabsom16.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years")  sfmt(%12.3f %12.0f %12.0f) ///
  noconstant label 


cap log close

