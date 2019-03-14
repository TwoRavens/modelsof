set more off
cd "C:/_sz/projects/moredonors_replication/"

*import delimited "data/d3_core_m.csv", clear
*import delimited "data/d1_core.csv", clear

use "data/d1.dta", clear

tab period, gen(prd)
tab cc, gen(cnm)

gen NumberDemocracyDonors = l_CMgnh

* without controls (model 1)
plausexog uci v2x_polyarchy_n prd* cnm* ///
  (NumberDemocracyDonors = l_ZwvCMgwh94), ///
  gmin(0) gmax(.1) graph(NumberDemocracyDonors) grid(7)
    

* with controls (model 2)
plausexog uci v2x_polyarchy_n l_pop_log l_gdpcap_log l_war25 prd* cnm* ///
  (NumberDemocracyDonors = l_ZwvCMgwh94), ///
  gmin(0) gmax(.1) graph(NumberDemocracyDonors) grid(7)

  
* interaction model (model 4):
plausexog uci v2x_polyarchy_n l_pop_log l_gdpcap_log l_war25 prd* cnm* ///
  (IA_l = l_ZwvCMgwh94), ///
  gmin(0) gmax(.1) graph(IA_l) grid(7)
  
