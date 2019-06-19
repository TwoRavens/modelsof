
// B.3.5. FDI and domestic firms --------------------------------------------------------------------------------------------------------------------
set more off 
use "$root/myanmarpanel_analysis.dta", clear 
cd "$results" 
gen obs_enterbf05_fdi = 0
replace obs_enterbf05_fdi = 1 if (((firmage>=7 & year==2013) | (firmage>=8 & year==2014) | (firmage>=9 & year==2015)) | qrno!=. | obs2006==1 | obs2003==1 | dgarment05_i==1)  ///
		 & year!=. & dnonknitbf05 !=. ///
		 & log_emp!=. & rscr_manag_woitic!=. & rscr_sftu!=. 
		 
global outreg outreg2 using wkp_fdi, se alpha( 0.01, 0.05, 0.1) tex keep(fdi_any log_emp export) label

local dep rscr_sftu
sum `dep' if obs_enterbf05_fdi==1 
local m = r(mean)
reg `dep' fdi_any oeducu ochinese firmage i.year i.district if obs_enterbf05_fdi==1 , cluster(firmid)
$outreg addstat(Mean dep var, `m', N firms, e(N_clust))   replace

local dep rscr_sftu
sum `dep' if obs_enterbf05_fdi==1 
local m = r(mean)
reg `dep' fdi_any oeducu ochinese firmage i.year i.district  export if obs_enterbf05_fdi==1 , cluster(firmid)
$outreg addstat(Mean dep var, `m', N firms, e(N_clust))   

foreach dep in lwage longhw socialaudit {
sum `dep' if obs_enterbf05_fdi==1 
local m = r(mean)
reg `dep' fdi_any oeducu ochinese firmage i.year i.district export if obs_enterbf05_fdi==1 , cluster(firmid)
$outreg addstat(Mean dep var, `m', N firms, e(N_clust))   
} 

