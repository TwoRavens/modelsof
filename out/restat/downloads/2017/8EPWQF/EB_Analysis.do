clear* 
	*******************************************************************************
	***		Loss Aversion and Macroeconomics Project  - Asymmetric Experience	***
	*******************************************************************************
	
cd "/Users/wardg/Dropbox (MIT)/Projects/Loss Aversion Project/ReStat Replication Files/Eurobarometer/"
use "eb_restat.dta", clear
set more off 

global dem	controls_* 

cap log close
log using "EBtables.smcl", replace

*** Table 4 (cols 3+4) ***
eststo clear
eststo: xtreg std_lifesat    gdpgrowth_wb 	 																			  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg gdpgrowth_wb_pos 	 													  $dem i.eb, fe cluster(countryyear) nonest 

*** Table 6  ***

eststo: xtreg std_lifesat    gdpgrowth_wb 	loggdppc  																	  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg gdpgrowth_wb_pos 	loggdppc  											  $dem i.eb, fe cluster(countryyear) nonest 

eststo: xtreg std_lifesat    gdpgrowth_wb 	unemployment_rate 															  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg gdpgrowth_wb_pos 	unemployment_rate 									  $dem i.eb, fe cluster(countryyear) nonest 

eststo: xtreg std_lifesat    gdpgrowth_wb 	inflation_rate  															  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg gdpgrowth_wb_pos 	inflation_rate  									  $dem i.eb, fe cluster(countryyear) nonest 

eststo: xtreg std_lifesat    gdpgrowth_wb 	loggdppc inflation_rate unemployment_rate 									  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg gdpgrowth_wb_pos 	loggdppc inflation_rate unemployment_rate 			  $dem i.eb, fe cluster(countryyear) nonest 
esttab using "eb_restat_tab6.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  ///
 scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years") sfmt(%12.3f %12.0f %12.0f) noconstant label order(gdpgrowth_wb gdpgrowth_wb_neg gdpgrowth_wb_pos 	loggdppc unemployment_rate inflation_rate)



*** Table A1 - OMIT GREAT RECESSION  ***
eststo clear
eststo: xtreg std_lifesat    gdpgrowth_wb 	 									  $dem i.eb if  year!=2007 & year!=2008 & year!=2009 , fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg gdpgrowth_wb_pos 	 			  $dem i.eb if  year!=2007 & year!=2008 & year!=2009 , fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb 	 									  $dem i.eb if  year!=2007 & year!=2008 & year!=2009 & eb>420, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg gdpgrowth_wb_pos 	 			  $dem i.eb if  year!=2007 & year!=2008 & year!=2009 & eb>420, fe cluster(countryyear) nonest 
esttab using "eb_restat_taba1.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  ///
 scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years") sfmt(%12.3f %12.0f %12.0f) noconstant label order(gdpgrowth_wb gdpgrowth_wb_neg gdpgrowth_wb_pos 	loggdppc unemployment_rate inflation_rate)


*** Table A2 - Volatility ***
lab var growth_mean_8y "Economic Growth Rate (8 Year Mean)"
lab var growth_mean_8y "Economic Growth Rate (8 Year Standard Deviation)"
eststo clear
eststo: xtreg std_lifesat    growth_mean_8y 	 																			  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    growth_sd_8y  	 																			  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    growth_mean_8y growth_sd_8y  	 																			  $dem i.eb, fe cluster(countryyear) nonest 
esttab using "eb_restat_taba2.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  ///
 noconstant label  scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years") sfmt(%12.3f %12.0f %12.0f) order(growth_mean_8y growth_sd_8y)


*** TABLE A3 - "Long Differences" ***
forvalues i=5(1)12 {
local x=`i'-1
egen rowmiss = rowmiss(neggrowthdum neggrowthdumL1-neggrowthdumL`x')
egen recessions_past`i'Y = rowtotal(neggrowthdum neggrowthdumL1-neggrowthdumL`x') if  rowmiss==0
gen loggdp_`i'Y_delta = loggdppc - loggdp_L`i'
mkspline loggdp_`i'Y_delta_neg 0 loggdp_`i'Y_delta_pos = loggdp_`i'Y_delta
replace loggdp_`i'Y_delta_neg = abs(loggdp_`i'Y_delta_neg)
gen loggdp_`i'Y_delta_pos_withrec = loggdp_`i'Y_delta_pos if recessions_past`i'Y>0 & recessions_past`i'Y!=.
replace loggdp_`i'Y_delta_pos_withrec = 0 if recessions_past`i'Y==0
gen loggdp_`i'Y_delta_pos_norec = loggdp_`i'Y_delta_pos if recessions_past`i'Y==0 
replace loggdp_`i'Y_delta_pos_norec = 0 if recessions_past`i'Y>0 & recessions_past`i'Y!=.
lab var loggdp_`i'Y_delta_neg "lnGDP `i'Y change: Negative"
lab var loggdp_`i'Y_delta_pos "lnGDP `i'Y change: Positive"
lab var loggdp_`i'Y_delta_pos_norec "lnGDP `i'Y change: Positive (no negative)"
lab var loggdp_`i'Y_delta_pos_withrec "lnGDP `i'Y change: Positive (with negative)"
drop rowmiss
}


set more off 
eststo clear
eststo: xtreg std_lifesat     loggdp_5Y_delta	 																			  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat     loggdp_5Y_delta_neg loggdp_5Y_delta_pos 																			  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat     loggdp_5Y_delta_neg	 loggdp_5Y_delta_pos_norec 		loggdp_5Y_delta_pos_withrec																	  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat     loggdp_10Y_delta	 																			  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat     loggdp_10Y_delta_neg loggdp_10Y_delta_pos 																			  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat     loggdp_10Y_delta_neg	 loggdp_10Y_delta_pos_norec 		loggdp_10Y_delta_pos_withrec																	  $dem i.eb, fe cluster(countryyear) nonest 
esttab using "eb_restat_taba3.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  ///
 noconstant label scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years") sfmt(%12.3f %12.0f %12.0f) order(loggdp_*)







*** SOM.5 - BALANCED PANEL REGRESSIONS ***
eststo clear
eststo: xtreg std_lifesat    gdpgrowth_wb 	 																			  $dem i.eb if country<10, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg gdpgrowth_wb_pos 	 													  $dem i.eb if country<10, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb 	 																			  $dem i.eb if eb>420, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg gdpgrowth_wb_pos 	 													  $dem i.eb if eb>420, fe cluster(countryyear) nonest 
esttab using "eb_restat_tabsom5.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  ///
 scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years") sfmt(%12.3f %12.0f %12.0f) noconstant label order(gdpgrowth_wb gdpgrowth_wb_neg gdpgrowth_wb_pos 	)




*** TABLE SOM.7 - INCLUDING EXPECTATIONS ***
global mac loggdppc inflation_rate unemployment_rate
eststo clear
eststo: xtreg std_lifesat    gdpgrowth_wb econexpec_better econexpec_worse	 															  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg gdpgrowth_wb_pos econexpec_better econexpec_worse	 									  $dem i.eb, fe cluster(countryyear) nonest 
esttab using "eb_restat_tabsom7.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  ///
 noconstant scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years") sfmt(%12.3f %12.0f %12.0f) label order(gdpgrowth_wb gdpgrowth_wb_neg gdpgrowth_wb_pos )


*** TABLE SOM.8 - INCLUDING HH CONSUMPTION GROWTH ***
replace wbhhconumptionpcgrowth = wbhhconumptionpcgrowth/100
eststo clear
eststo: xtreg std_lifesat    gdpgrowth_wb wbhhconumptionpcgrowth 	 																			  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg gdpgrowth_wb_pos wbhhconumptionpcgrowth 	 													  $dem i.eb, fe cluster(countryyear) nonest 
esttab using "eb_restat_tabsom8.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  ///
 scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years") sfmt(%12.3f %12.0f %12.0f) noconstant label order(gdpgrowth_wb gdpgrowth_wb_neg gdpgrowth_wb_pos wbhhconumptionpcgrowth)




*** SOM.10 - GROWTH RELATIVE TO COUNTRY-MEAN RATE ***
gen growth_relativetomean10 = gdpgrowth_wb - gdpgrowth_prev10ymean
mkspline gr_belowmean10 0 gr_abovemean10 = growth_relativetomean10
replace gr_belowmean10 = abs(gr_belowmean10)
eststo clear
eststo: xtreg std_lifesat    growth_relativetomean10	 				  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gr_belowmean10 gr_abovemean10	 			  $dem i.eb, fe cluster(countryyear) nonest 
esttab using "eb_restat_tabsom10.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  ///
 scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years") sfmt(%12.3f %12.0f %12.0f) noconstant label order(growth_relativetomean10 gr_belowmean10 gr_abovemean10 	)





*** SOM.11 - RECOVERY GROWTH ***
eststo clear
eststo: xtreg std_lifesat    gdpgrowth_wb_neg c.gdpgrowth_wb_pos#0.recovery_growth c.gdpgrowth_wb_pos#1.recovery_growth	 													  $dem i.eb, fe cluster(countryyear) nonest 
esttab using "eb_restat_tabsom11.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  ///
 scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years") sfmt(%12.3f %12.0f %12.0f) noconstant label order( gdpgrowth_wb_neg gdpgrowth_wb_pos recovery_growth 	)



*** SOM.12 - GROWTH SPELL LENGTH ***
gen negxlength = gdpgrowth_wb_neg*neg_spell_length_cum
gen posxlength = gdpgrowth_wb_pos*pos_spell_length_cum
lab var neg_spell_length_cum "Negative Spell Length (years)"
lab var pos_spell_length_cum "Positive Spell Length (years)"
lab var negxlength	"Negative Growth * Spell Length"
lab var posxlength	"Positive Growth * Spell Length"
eststo clear
eststo: xtreg std_lifesat    gdpgrowth_wb_neg  gdpgrowth_wb_pos  	 													  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat     neg_spell_length_cum pos_spell_length_cum 	 													  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg  gdpgrowth_wb_pos neg_spell_length_cum pos_spell_length_cum 	 													  $dem i.eb, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg  gdpgrowth_wb_pos neg_spell_length_cum pos_spell_length_cum 	negxlength 		posxlength											  $dem i.eb, fe cluster(countryyear) nonest 
esttab using "eb_restat_tabsom12.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years") sfmt(%12.3f %12.0f %12.0f) ///
  noconstant label 



*** SOM.16 - Outliers ***
collapse gdpgrowth_wb satislfe,  by(code year)
drop if satislfe==.
xtile growth_pctile = gdpgrowth_wb, nq(100)
save "growth_pctile.dta", replace
use "eb_restat.dta", clear
merge m:1 code year using "growth_pctile"
drop _merge

gen exclude = (growth_pctile==1 | growth_pctile==100)

eststo clear
eststo: xtreg std_lifesat    gdpgrowth_wb 	 																			  $dem i.eb if exclude==0, fe cluster(countryyear) nonest 
eststo: xtreg std_lifesat    gdpgrowth_wb_neg gdpgrowth_wb_pos	 													  $dem i.eb if exclude==0, fe cluster(countryyear) nonest 
esttab using "eb_restat_tabsom16.csv", replace b(3) se(3) r2(3) star(* 0.1 ** 0.05 *** 0.01)  scalars("r2_w Within-R2 " "N_g Countries" "N_clust Country-Years") sfmt(%12.3f %12.0f %12.0f) ///
  noconstant label  order(gdpgrowth_wb_neg gdpgrowth_wb_pos)
erase "growth_pctile.dta"



cap log close






