// 2sls with two iv and testing for over id restriction  ==========================
use "$root/myanmarpanel_analysis.dta", clear 
cd "$results" 
set more off 

local if if obs_enterbf05==1 & obs_airport ==1 
local cov1 y14 y15 mandalay izo city_timeo 
local cov2 oeducu ochinese firmage 
local outreg outreg2 using overid, se alpha( 0.01, 0.05, 0.1) keep(export_sh) tex label
local sd1 
local sd2 rob 

local x `cov1' `cov2'
local dep rscr_sftu
reg export ap_in1hr dnonknitbf05 `x' `if' & `dep'!=., cluster(firmid)
test ap_in1hr dnonknitbf05 
local f = r(F) 
sum `dep' `if'
local m = r(mean)
ivreg2 `dep'  (export_sh = ap_in1hr dnonknitbf05) `x' `if', cluster(firmid) 
`outreg' addstat(N firms, e(N_clust), F test IV=0, `f', Hansen J, e(j), Hansen J p-val, e(jp), Mean dep var, `m') replace 

foreach dep in lwage longhw log_emp log_lp rscr_manag_woitic { 
reg export ap_in1hr dnonknitbf05 `x' `if' & `dep'!=., cluster(firmid)
test ap_in1hr dnonknitbf05
local f = r(F) 
sum `dep' `if'
local m = r(mean)
ivreg2 `dep'  (export_sh = ap_in1hr dnonknitbf05) `x' `if', cluster(firmid) 
`outreg' addstat(N firms, e(N_clust), F test IV=0, `f', Hansen J, e(j), Hansen J p-val, e(jp), Mean dep var, `m') 
} 

