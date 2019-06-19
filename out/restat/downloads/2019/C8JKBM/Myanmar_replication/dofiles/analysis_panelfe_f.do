
// Table B.3.4. Panel regression -------------------------------------------------------------------------------------------------------
use "$root/myanmarpanel_analysis.dta", clear 
cd "$results" 
tsset idall year 

gen export_other_sh = export_sh - export_EUUS_sh
set more off
// sample 
gen obs_panelfe_fd = 0  // 
replace obs_panelfe_fd = 1 if ((firmage>=3 & year==2013) | (firmage>=4 & year==2014) | (firmage>=5 & year==2015))  ///    
		 & year!=. ///
		 & log_emp!=. & scr_manag_woit!=. & rscr_sftu!=. & fdi_any ==0 

keep if obs_panelfe_fd==1 
local export export_EUUS_sh export_other_sh
global outreg outreg2 using panelfe, se alpha( 0.01, 0.05, 0.1) tex label 

local dep rscr_sftu
sum `dep'  if obs_panelfe_fd==1
local m = r(mean)
xtreg `dep' export_EUUS_sh export_other_sh i.year i.district if obs_panelfe_fd==1, fe cluster(firmid)
$outreg addstat(Mean dep var, `m', N firms, e(N_clust)) replace 

foreach dep in lwage longhw socialaudit log_emp rscr_manag_woitic  { 
sum `dep'  if obs_panelfe_fd==1
local m = r(mean)
xtreg `dep' export_EUUS_sh export_other_sh i.year i.district if obs_panelfe_fd==1, fe cluster(firmid)
$outreg addstat(Mean dep var, `m', N firms, e(N_clust))
}
