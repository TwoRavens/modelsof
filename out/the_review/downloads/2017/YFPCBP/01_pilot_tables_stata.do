********************************************************************************
* This file generates Table 1 (in a different format than in print )and does the 
* pre-calculations for Figure 9 of "Process or Candidate: The International 
* Community and the Demand for Electoral Integrity" 
********************************************************************************

cd "D:\apsr_send\replication_files"

clear
set more off

capture log close
log using log_pilot_tables_stata, text replace

********************************************************************************
* Import raw data
********************************************************************************

import delimited "pilot_data.csv", clear asdouble


********************************************************************************
* Cases table in Appendix
********************************************************************************

list country year electionid polarization warusa power

********************************************************************************
* Generate variables of interest
********************************************************************************

capture drop gaininc
gen gaininc=(nelda27=="no") if nelda27!="N/A" & nelda27!="unclear"

capture drop concern
gen concern=(nelda11=="yes") if nelda11!="unclear" & nelda11!="N/A"

********************************************************************************
* Generate Table 1 using collapse (slightly rearranged in paper)
********************************************************************************

preserve

collapse ///
(mean)  mean_gaininc=gaininc mean_concern=concern ///
(sd)    sd_gaininc=gaininc   sd_concern=concern   ///
(count) n_gaininc=gaininc    n_concern=concern    ///
if warusa!=., by(warusa polarization)

order warusa polarization ///
mean_gaininc sd_gaininc n_gaininc ///
mean_concern sd_concern n_concern 

list warusa polarization ///
mean_gaininc sd_gaininc n_gaininc ///
mean_concern sd_concern n_concern ///

*save as csv*
outsheet using analysis_table.csv , comma replace

restore

log close


