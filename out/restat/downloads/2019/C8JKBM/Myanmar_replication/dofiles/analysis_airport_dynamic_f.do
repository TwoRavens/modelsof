
// Figure 2, Table 3 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
set more off 
use "$root/myanmarpanel_analysis.dta", clear  
cd "$results"
keep if obs_airport_fd==1 

// airport distance using address in 2005-2011 
gen ap_in1hr_r = (ap_time<1) if ap_time!=. 

// create first differences 
sort idall year 
tsset idall year 

gen log_emp_lg = L.log_emp 
gen export_sh_lg = L.export_sh 
gen export_JP_sh_lg = L.export_JP_sh 
gen socialaudit_lg = L.socialaudit

gen dsocialaudit_1st = 0 
replace dsocialaudit_1st = 1 if year == 2015 & socialaudit ==1 &  socialaudit_lg == 0 
replace dsocialaudit_1st = (firstaudit==2014) if year == 2014 

foreach depv in rscr_sftu rscr_fsafety rscr_health rscr_union lwage longhw log_emp rscr_manag_woitic { 
sort idall year 
tsset idall year 
gen d`depv' = `depv' - L.`depv' 
gen dnew`depv' = d`depv' 
replace dnew`depv' = 0 if (`depv' <= L.`depv') & L.`depv'!=. 
}

label var ap_in1hr "Airport ($>=$1 hr)" 
label var ap_time "Airport travel time" 
label var export_sh_lg "Export share (lagged)" 
label var export_JP_sh_lg "Export to Japan share (lagged)" 
label var log_emp_lg "Log employment (lagged)" 
label var city_timeo "Travel time to city center" 
label var izo "Industrial zone (dummy)" 

// Figure 2 (right)
binscatter dnewexport_any ap_time if year==2014|year==2015, n(20) controls(izo city_timeo) mcolors(black) /// 
xtitle(Time to airport (hour), size(large)) xlabel(,labsize(medlarge))  linetype(none) graphregion(color(white)) ///
ytitle(Exporting to a new country, size(large))  ylabel(,labsize(medlarge)) saving("$results/ap_newexport_any", replace) 
graph export "$results/ap_newexport_any.png", replace 
graph export "$results/ap_newexport_any.pdf", replace 


// Table 3
local outreg outreg2 using ps_ap_outcome, se dec(3) alpha( 0.01, 0.05, 0.1) tex label 
local replace replace
foreach depv in newexport newexport_EUUS newexport_any rscr_sftu lwage longhw socialaudit_1st log_emp rscr_manag_woitic {
sum d`depv' if ap_in1hr_r!=. 
local m = r(mean)
teffects psmatch (d`depv') (ap_in1hr_r log_emp_lg izo export_sh_lg city_timeo y15), vce(robust) 
`outreg' addstat(Mean, `m')  `replace'
local replace
} 
   
   
// Appendix. B.1.3. columns (4)-(6). Details of scores 
local outreg outreg2 using ps_ap_outcome2, se alpha( 0.01, 0.05, 0.1) tex label 
local replace replace
foreach depv in rscr_fsafety rscr_health rscr_union {
sum d`depv' if ap_in1hr_r!=. 
local m = r(mean)
teffects psmatch (d`depv') (ap_in1hr_r log_emp_lg izo export_sh_lg city_timeo y15) 
`outreg' addstat(Mean dep var, `m')  `replace'
local replace
} 
   
// Appendix B.1.4. column (3)-(4). Z-score 
foreach depv in scr_sftu scr_manag_woitic  { 
capture drop d`depv' 
sort idall year 
tsset idall year 
gen d`depv' = `depv' - L.`depv' 
gen dnew`depv' = d`depv'
replace dnew`depv' = 0 if (`depv' <= L.`depv') & L.`depv'!=. 
}

local replace  
local outreg outreg2 using airport_zscore, se alpha( 0.01, 0.05, 0.1) tex label 
foreach depv in scr_sftu scr_manag_woitic  {
sum d`depv' if ap_in1hr_r!=. 
local m = r(mean)
teffects psmatch (d`depv') (ap_in1hr_r log_emp_lg izo export_sh_lg city_timeo y15), vce(robust) 
`outreg' addstat(Mean dep var, `m') `replace'
local replace 
} 

// Table B.1.5, Panel C. Keep sample to Yangon 
local outreg outreg2 using ps_ap_outcome3, se dec(3) alpha( 0.01, 0.05, 0.1) tex label 
local replace replace
foreach depv in newexport newexport_EUUS newexport_any rscr_sftu lwage longhw socialaudit_1st {
sum d`depv' if ap_in1hr_r!=. &  district == 1
local m = r(mean)
teffects psmatch (d`depv') (ap_in1hr_r log_emp_lg izo export_sh_lg city_timeo y15) if district == 1, vce(robust) 
`outreg' addstat(Mean, `m')  `replace'
local replace
} 

// Table B.1.5, Panel D. Drop small firms
local outreg outreg2 using ps_ap_outcome4, se dec(3) alpha( 0.01, 0.05, 0.1) tex label 
local replace replace
foreach depv in newexport newexport_EUUS newexport_any rscr_sftu lwage longhw socialaudit_1st {
sum d`depv' if ap_in1hr_r!=. &  emp>=30
local m = r(mean)
teffects psmatch (d`depv') (ap_in1hr_r log_emp_lg izo export_sh_lg city_timeo y15) if emp>=30, vce(robust) 
`outreg' addstat(Mean, `m')  `replace'
local replace
} 

// Appendix. B.1.6. OLS
local outreg outreg2 using reg_ap_exp, se alpha( 0.01, 0.05, 0.1) tex label // including size
local replace replace
foreach depv in newexport newexport_EUUS rscr_sftu lwage longhw socialaudit_1st log_emp rscr_manag_woitic {
sum d`depv' if ap_in1hr_r!=. 
local m = r(mean)
reg d`depv' ap_in1hr_r log_emp_lg export_sh_lg izo city_timeo y15, cluster(idall) 
`outreg' addstat(Mean dep var, `m', N plants, e(N_clust)) `replace'
local replace
}   
   
