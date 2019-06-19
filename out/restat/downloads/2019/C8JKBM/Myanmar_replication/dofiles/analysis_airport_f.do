
// Figure 2 (left) ------------------------------------------------------------------------------------------------
use "$root/myanmarpanel_analysis.dta", clear 
graph set window fontface "Times New Roman"
binscatter export_sh ap_time if obs_airport ==1, n(20)  controls(izo city_timeo) mcolors(black)   /// 
xtitle(Time to airport (hour), size(large)) xlabel(,labsize(medlarge)) linetype(none) ///
ytitle(Export share, size(large)) ylabel(,labsize(medlarge)) graphregion(color(white)) saving("$results/ap_export.gph", replace)
graph export "$results/ap_export.png", replace  
graph export "$results/ap_export.pdf", replace  

// Table 2 -------------------------------------------------------------------------------------------------------
use "$root/myanmarpanel_analysis.dta", clear 
cd "$results" 
set more off
local if if obs_airport ==1 
local cov1 i.year i.district izo city_timeo
local outreg outreg2 using airport_iv, se dec(3) alpha( 0.01, 0.05, 0.1) keep(ap_in1hr export_sh) tex label 

local dep export_sh
sum `dep' `if'
local m = r(mean)
reg `dep' ap_in1hr `cov1' `if' & `dep'!=., cluster(firmid)
sum `dep' if e(sample)==1 
local m = r(mean)
`outreg' addstat(N firms, e(N_clust), Mean, `m') replace 

foreach dep in rscr_sftu lwage longhw socialaudit log_emp log_lp rscr_manag_woitic { 
reg export_sh ap_in1hr `cov1' `if' & `dep'!=., cluster(firmid)
test ap_in1hr
local f = r(F) 
ivregress 2sls `dep' (export_sh = ap_in1hr) `cov1' `if', cluster(firmid)
sum `dep' if e(sample)==1 
local m = r(mean)
`outreg' addstat(N firms, e(N_clust), Mean, `m', F test IV=0, `f')
}


// Appendix. Table A.1.2. Panel B. (linear airport time)-------------------------------------------------------------------------------------------------------
use "$root/myanmarpanel_analysis.dta", clear 
cd "$results" 
set more off
local if if obs_airport ==1 
local cov1 i.year i.district izo city_timeo
local outreg outreg2 using airport_iv2, se dec(3) alpha( 0.01, 0.05, 0.1) keep(ap_timeo export_sh) tex label 

local dep export_sh
sum `dep' `if'
local m = r(mean)
reg `dep' ap_timeo `cov1' `if' & `dep'!=., cluster(firmid)
sum `dep' if e(sample)==1 
local m = r(mean)
`outreg' addstat(N firms, e(N_clust), Mean, `m') replace 

foreach dep in rscr_sftu lwage longhw socialaudit log_emp log_lp rscr_manag_woitic { 
reg export_sh ap_timeo `cov1' `if' & `dep'!=., cluster(firmid)
test ap_timeo
local f = r(F) 
ivregress 2sls `dep'  (export_sh = ap_timeo) `cov1' `if', cluster(firmid)
sum `dep' if e(sample)==1 
local m = r(mean)
`outreg' addstat(N firms, e(N_clust), Mean, `m', F test IV=0, `f')
}



// Appendix. Table B.1.3. columns (1)-(3). (details on working conditions) -------------------------------------------------------------------------------------------------------
use "$root/myanmarpanel_analysis.dta", clear 
cd "$results" 
set more off
local if if obs_airport ==1 
local cov1 i.year i.district izo city_timeo
local outreg outreg2 using airport_iv3, se dec(3) alpha( 0.01, 0.05, 0.1) keep(ap_in1hr export_sh) tex label 

local replace replace
foreach dep in rscr_fsafety rscr_health rscr_union  { 
reg export_sh ap_in1hr `cov1' `if' & `dep'!=., cluster(firmid)
test ap_in1hr 
local f = r(F) 
ivregress 2sls `dep' (export_sh = ap_in1hr) `cov1' `if', cluster(firmid)
sum `dep' if e(sample)==1 
local m = r(mean)
`outreg' addstat(N firms, e(N_clust), Mean, `m', F test IV=0, `f') `replace'
local replace 
}


// Appendix. Table B.1.4. z-score column 1,2-------------------------------------------------------------------------------------------------------
use "$root/myanmarpanel_analysis.dta", clear 
set more off 
cd "$results" 
local if if obs_airport ==1 
local cov1 i.year i.district izo city_timeo 
local outreg outreg2 using airport_zscore, se alpha( 0.01, 0.05, 0.1) keep(ap_in1hr export_sh) tex label // including size

reg export_sh ap_in1hr `cov1' `if' & scr_sftu!=., cluster(firmid)
test ap_in1hr
local f = r(F) 
sum scr_sftu `if'
local m = r(mean)
ivregress 2sls scr_sftu (export_sh = ap_in1hr) `cov1' `if', cluster(firmid)
`outreg' addstat(F test IV=0, `f', Mean dep var, `m', N plants, e(N_clust))  replace

reg export_sh ap_in1hr `cov1' `if' & scr_manag_woitic!=., cluster(firmid)
test ap_in1hr
local f = r(F) 
sum scr_manag_woitic `if'
local m = r(mean)
ivregress 2sls scr_manag_woitic (export_sh = ap_in1hr) `cov1' `if', cluster(firmid)
`outreg' addstat(F test IV=0, `f', Mean dep var, `m', N plants, e(N_clust))

// Table B.1.5. Restricting samples -------------------------------------------------------------------------------------------------------
use "$root/myanmarpanel_analysis.dta", clear 
cd "$results" 
set more off
*local if if obs_airport ==1 & district==1 // Panel A
local if if obs_airport ==1 & emp>=30  // Panel B
local cov1 i.year i.district izo city_timeo
local outreg outreg2 using airport_iv4, se dec(3) alpha( 0.01, 0.05, 0.1) keep(ap_in1hr export_sh) tex label 

local dep export_sh
sum `dep' `if'
local m = r(mean)
reg `dep' ap_in1hr `cov1' `if' & `dep'!=., cluster(firmid)
sum `dep' if e(sample)==1 
local m = r(mean)
`outreg' addstat(N firms, e(N_clust), Mean, `m') replace 

foreach dep in rscr_sftu lwage longhw socialaudit log_emp rscr_manag_woitic { 
reg export_sh ap_in1hr `cov1' `if' & `dep'!=., cluster(firmid)
test ap_in1hr
local f = r(F) 
ivregress 2sls `dep' (export_sh = ap_in1hr) `cov1' `if', cluster(firmid)
sum `dep' if e(sample)==1 
local m = r(mean)
`outreg' addstat(N firms, e(N_clust), Mean, `m', F test IV=0, `f')
}

