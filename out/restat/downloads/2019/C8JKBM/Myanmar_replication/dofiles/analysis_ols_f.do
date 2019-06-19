
// Table B.3.1. OLS -------------------------------------------------------------------------------------------------------
use "$root/myanmarpanel_analysis", clear 
cd "$results"
global outreg outreg2 using ols, se alpha( 0.01, 0.05, 0.1) keep(export_sh) tex label

local dep rscr_sftu
sum `dep' if obs_airport==1 
local m = r(mean)
reg `dep'   export_sh i.year i.district if obs_airport==1 , cluster(firmid) 
$outreg addstat(Mean dep var, `m', N firms, e(N_clust)) replace 

local dep lwage
sum `dep' if obs_airport==1 
local m = r(mean)
reg `dep' export_sh i.year i.district if obs_airport==1 , cluster(firmid) 
$outreg addstat(Mean dep var, `m', N firms, e(N_clust))  

local dep longhw 
sum `dep' if obs_airport==1 
local m = r(mean)
reg `dep' export_sh i.year i.district if obs_airport==1 , cluster(firmid) 
$outreg addstat(Mean dep var, `m', N firms, e(N_clust))  

local dep socialaudit
sum `dep' if obs_airport==1 
local m = r(mean)
reg `dep' export_sh i.year i.district if obs_airport==1 , cluster(firmid) 
$outreg addstat(Mean dep var, `m', N firms, e(N_clust))  

local dep log_emp
sum `dep' if obs_airport==1 
local m = r(mean)
reg `dep' export_sh i.year i.district if obs_airport==1 , cluster(firmid) 
$outreg addstat(Mean dep var, `m', N firms, e(N_clust))  

local dep log_lp
sum `dep' if obs_airport==1 
local m = r(mean)
reg `dep' export_sh i.year i.district if obs_airport==1 , cluster(firmid) 
$outreg addstat(Mean dep var, `m', N firms, e(N_clust))  

local dep rscr_manag_woitic
sum `dep' if obs_airport==1 
local m = r(mean)
reg `dep' export_sh i.year i.district if obs_airport==1 , cluster(firmid) 
$outreg addstat(Mean dep var, `m', N firms, e(N_clust))  

