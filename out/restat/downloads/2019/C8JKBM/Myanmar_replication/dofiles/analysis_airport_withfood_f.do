// Table 4. Food placebo for cross-sectional airport IV ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
use "$root/myanmar_food_analysis", clear 		 
cd "$results"
drop if log_emp==. 
drop if rscr_sftu==. 
drop if fdi_any==1 
keep if emp>=5 

global outreg outreg2 using foodplacebo, se dec(3) alpha( 0.01, 0.05, 0.1) tex  label

reg rscr_sftu ap_in1hr   i.district i.year izo city_timeo bev, cluster(idall) 
sum rscr_sftu if e(sample)==1
local m = r(mean) 
$outreg addstat(Mean, `m') replace 

reg log_emp ap_in1hr  i.district i.year izo city_timeo bev, cluster(idall) 
sum log_emp  if e(sample)==1
local m = r(mean)
$outreg  addstat(Mean, `m')

reg rscr_manag_woitic ap_in1hr  i.district i.year izo city_timeo bev if (year==2013 | year==2015), cluster(idall) 
sum rscr_prod  if e(sample)==1
local m = r(mean)
$outreg  addstat( Mean, `m')


// Table 4, cont. Analysis on changes: Food PLACEBO for airport IV, PS matching ******************************************************************************************
foreach x in rscr_manag_woitic {
replace `x' =.  if year == 2014 
}

sort idall year 
tsset idall year 

gen log_emp_lg = L.log_emp 

capture drop y14 y15
gen y14 = (year==2014) 
gen y15 = (year==2015) 
gen manadalay = (district ==2) 

foreach depv in export rscr_sftu lwage longhw rscr_manag_woitic log_emp { 
capture drop d`depv' 
sort idall year 
tsset idall year 
gen d`depv' = `depv' - L.`depv' 
}

global outreg outreg2 using foodplacebo, se dec(3) alpha( 0.01, 0.05, 0.1) tex label 

foreach depv in rscr_sftu log_emp {
sum d`depv' if ap_in1hr!=. 
local m = r(mean)
teffects psmatch (d`depv') (ap_in1hr log_emp_lg izo city_timeo y15), vce(robust)  
$outreg addstat(Mean, `m')
}
 
preserve 
drop if year == 2014  
local depv rscr_manag_woitic 
capture drop d`depv' 
sort idall year 
tsset idall year, delta(2) 
gen d`depv' = `depv' - L.`depv' 
sum d`depv' if ap_in1hr!=. 
drop log_emp_lg
gen log_emp_lg = L.log_emp 
teffects psmatch (d`depv') (ap_in1hr log_emp_lg izo city_timeo y15), vce(robust) 
sum d`depv' if ap_in1hr!=. 
local m = r(mean)
$outreg addstat(Mean, `m') `replace' 
restore 
