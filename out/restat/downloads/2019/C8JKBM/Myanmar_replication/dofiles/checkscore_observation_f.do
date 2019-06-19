
// Table A.1.7: Observations in plant tours and working conditions scores [paper appendix] ----------------------------------------------------------------------------  
use "$root/myanmarpanel_analysis", clear 
cd "$results" 
gen int_plant = (int_location==1)
set more off
 
global if if obs_enterbf05==1  & year==2013 
global outreg outreg2 using obscheck, se alpha( 0.01, 0.05, 0.1) tex label 

sum fexit  $if
local m = r(mean)
reg fexit fexit_obs i.district $if, rob   
$outreg addstat(Mean dep var, `m') addtext(Interviewer FEs, No)  replace 

sum fhose  $if
local m = r(mean)
reg fhose fhose_obs i.district $if, rob    
$outreg addstat(Mean dep var, `m') addtext(Interviewer FEs, No)   

sum rscr_health  $if  & fexit_obs!=. 
local m = r(mean)
reg rscr_health  lowlight toohot mbox i.district  $if  & fexit_obs!=. , rob
$outreg addstat( Mean dep var, `m') addtext(Interviewer FEs, No)  

sum rscr_union  $if
local m = r(mean)
reg rscr_union fexit_obs fhose_obs lowlight toohot mbox i.district  $if, rob
$outreg addstat(Mean dep var, `m') addtext(Interviewer FEs, No) 

sum plant_tour $if
local m = r(mean)
reg plant_tour rscr_sftu  export log_emp int_plant i.district   $if, rob
$outreg addstat(Mean dep var, `m') addtext(Interviewer FEs, No)


// Table A.1.8 (Airport) ----------------------------------------------------------------------------
use "$root/myanmarpanel_analysis", clear 
cd "$results" 

label var fexit "Fire exit (response)"
label var fhose "Fire hose (response)"

gen dhose_obs = (fhose_obs!=.) 
gen diff_fexit =  fexit - fexit_obs 
gen diff_fhose =  fhose - fhose_obs 
gen diff_mbox = injuryrec - mbox 
gen diff_health_fire = rscr_health - rscr_fsafety
gen diff_union_fire = rscr_union - rscr_fsafety
gen diff_union_fexit  = rscr_union - fexit 
gen diff_fdrill_fexit = fdrill - fexit 
set more off

global if if obs_enterbf05==1 & obs_airport ==1 & plant_tour==1 & year == 2013 
global outreg outreg2 using obscheck2, se alpha( 0.01, 0.05, 0.1) tex label 

sum export_sh $if & plant_tour==1 
local m = r(mean)
reg export_sh ap_in1hr i.year i.district izo city_timeo if obs_enterbf05==1 &  plant_tour==1 & diff_fexit!=. & year == 2013, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m') replace

sum diff_fexit $if  & plant_tour==1 
local m = r(mean)
reg diff_fexit ap_in1hr i.year i.district izo city_timeo if obs_enterbf05==1 & plant_tour==1 & year == 2013, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m') 

sum diff_fhose  $if  & plant_tour==1 
local m = r(mean)
reg diff_fhose ap_in1hr i.year i.district izo city_timeo if obs_enterbf05==1 & plant_tour==1 & year == 2013, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m') 

sum diff_mbox  $if  & plant_tour==1 
local m = r(mean)
reg diff_mbox ap_in1hr i.year i.district izo city_timeo if obs_enterbf05==1 & plant_tour==1 & year == 2013, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m') 

sum diff_fdrill_fexit  $if 
local m = r(mean) 
reg diff_fdrill_fexit ap_in1hr i.year i.district izo city_timeo i.year if obs_enterbf05==1, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m')

sum diff_health_fire if obs_enterbf05==1 
local m = r(mean) 
reg diff_health_fire ap_in1hr i.year i.district izo city_timeo if obs_enterbf05==1, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m')

sum diff_union_fire  $if 
local m = r(mean) 
reg diff_union_fire ap_in1hr i.year i.district izo city_timeo i.year if obs_enterbf05==1, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m')

// Table A.1.8 (Woven) ----------------------------------------------------------------------------
use "$root/myanmarpanel_analysis", clear 
cd "$results" 

label var fexit "Fire exit (response)"
label var fhose "Fire hose (response)"

gen dhose_obs= (fhose_obs!=.) 
gen diff_fexit =  fexit - fexit_obs 
gen diff_fhose =  fhose - fhose_obs 
gen diff_mbox = injuryrec - mbox 
gen diff_health_fire = rscr_health - rscr_fsafety
gen diff_union_fire = rscr_union - rscr_fsafety
gen diff_union_fexit  = rscr_union - fexit 
gen diff_fdrill_fexit = fdrill - fexit 
set more off

global if if obs_enterbf05==1 & plant_tour==1 & year == 2013 
global outreg outreg2 using obscheck3, se alpha( 0.01, 0.05, 0.1) tex label 

sum export_sh $if & plant_tour==1 
local m = r(mean)
reg export_sh dnonknitbf05 i.year i.district if obs_enterbf05==1 &  plant_tour==1 & diff_fexit!=. & year == 2013, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m') replace

sum diff_fexit $if & plant_tour==1 
local m = r(mean)
reg diff_fexit dnonknitbf05 i.year i.district if obs_enterbf05==1 & plant_tour==1 & year == 2013, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m') 

sum diff_fhose $if & plant_tour==1 
local m = r(mean)
reg diff_fhose dnonknitbf05 i.year i.district if obs_enterbf05==1 & plant_tour==1 & year == 2013, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m') 

sum diff_mbox $if & plant_tour==1 
local m = r(mean)
reg diff_mbox dnonknitbf05 i.year i.district if obs_enterbf05==1 & plant_tour==1 & year == 2013, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m') 

sum diff_fdrill_fexit $if
local m = r(mean) 
reg diff_fdrill_fexit dnonknitbf05 i.year i.district i.year if obs_enterbf05==1, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m')

sum diff_health_fire if obs_enterbf05==1 
local m = r(mean) 
reg diff_health_fire dnonknitbf05 i.year i.district if obs_enterbf05==1, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m')

sum diff_union_fire $if
local m = r(mean) 
reg diff_union_fire dnonknitbf05 i.year i.district i.year if obs_enterbf05==1, cluster(idall) 
$outreg addstat(N firms, e(N_clust), Mean, `m')
