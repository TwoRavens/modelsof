set more off 
clear all 
use "$root/myanmarpanel_analysis.dta", clear 

append using "$root/myanmar_food_analysis", force 

capture drop mandalay
gen mandalay = (district==2)
gen garment = (industry==1)
gen garment_year = (industry==1)*(year-2013) 
gen obs_fd = 0  // 
replace obs_fd = 1 if ((firmage>=3 & year==2013) | (firmage>=4 & year==2014) | (firmage>=5 & year==2015))  ///    
		 & year!=. ///
		 & rscr_sftu!=. & fdi_any==0
		 
keep if obs_fd==1 
drop if emp<5 
drop if rscr_sftu==. | log_emp ==. 

tsset idall year 
replace rscr_manag_woitic = . if year == 2014 
label var garment "Garment" 
label var garment_year "Garment x Year" 


// Table 7 *********************************************************************************
cd "$results" 

capture drop y14 y15
gen y14 = (year==2014) 
gen y15 = (year==2015) 

label var garment "Garment" 
label var garment_year "Garment x Year" 

capture drop log_emp_lg
gen log_emp_lg = L.log_emp
foreach depv in rscr_sftu longhw lwage log_emp { 
capture drop d`depv'
gen d`depv' = `depv' - L.`depv'
}    

sort idall year 
tsset idall year 
local replace replace 
local outreg outreg2 using food_did_psmatch, se alpha( 0.01, 0.05, 0.1) tex label dec(3) 

capture drop log_emp_lg
gen log_emp_lg = L.log_emp
foreach depv in newexport newexport_EUUS newexport_any rscr_sftu longhw log_emp { 
teffects psmatch (d`depv') (garment log_emp_lg izo mandalay hlta spta noka sdgn y15), vce(robust)
sum d`depv' 
local m = r(mean)
`outreg' addstat(Mean, `m') `replace'
local replace
}    

