// Table B.3.3 Decomposition -------------------------------------------------------------------------------------------------------
** see Ben Jann (2008) for stata code explanation 
use  "$root/myanmarpanel_analysis", clear  
cd "$results" 
keep if obs_airport==1 
global outreg outreg2 using decomposition, se alpha( 0.01, 0.05, 0.1) tex label 

// two fold - export
oaxaca rscr_sftu log_emp rscr_manag_woitic socialaudit y15 if year >=2014, by(export) swap vce(cluster firmid) pooled
$outreg replace 
