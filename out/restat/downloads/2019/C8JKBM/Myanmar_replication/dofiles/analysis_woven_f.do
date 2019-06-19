
// Table 6 ---------------------------------------------------------------------------------------------------------------------
use "$root/myanmarpanel_analysis.dta", clear 
cd "$results" 
global outreg outreg2 using woveniv, se dec(3) alpha( 0.01, 0.05, 0.1) tex label 

reg export_sh dnonknitbf05 oeducu ochinese firmage i.year i.district if obs_enterbf05==1, cluster(firmid)
sum export_sh if obs_enterbf05==1
local m = r(mean)
$outreg addstat(N firms, e(N_clust), Mean, `m') replace

foreach dep in rscr_sftu lwage longhw socialaudit log_emp log_lp rscr_manag_woitic { 
reg export_sh dnonknitbf05 oeducu ochinese firmage i.year i.district if obs_enterbf05==1 & `dep'!=., cluster(firmid)
test dnonknitbf05 
local f = r(F) 
sum `dep' if obs_enterbf05==1
local m = r(mean) 
ivregress 2sls `dep' (export_sh = dnonknitbf05) oeducu ochinese firmage i.year i.district if obs_enterbf05==1, cluster(firmid)
$outreg addstat(N firms, e(N_clust), Mean, `m', F test IV=0, `f')
} 
