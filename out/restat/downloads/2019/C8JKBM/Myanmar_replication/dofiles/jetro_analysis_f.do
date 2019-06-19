
// Table 1, 5, B.1.2. Balancing ************************************************************************
use "$jetro/jetroide2005_working", clear 

reg dnonknitint04k ochinese oeducu firmage if fdifull05k==0, robust 
reg ap_time_hr iz_k city_time_hr if fdifull05k==0 , robust 

tab q05c1
tab q05c1, nolabel 
gen JPfdi = (q05c1==114 |  q05c1== 209 | q05c1== 77)  // Japan, Korea | q05c1==209
tab JPfdi 
 
gen dnonknitint04k_sales = (nonknitint04k>0.5) & nonknitint04k!=. 
gen dnonknitint04k_fdi = dnonknitint04k*fdifull05k

gen ap_in1hr = (ap_time_hr<1) 
label var ap_in1hr "Near airport" 
label var dnonknitint04k "Woven" 

// Table 1. Main variables ---------------------------------------------------------------
cd "$results" 
local x ap_in1hr iz_k city_time_hr 
local outreg outreg2 using jetro05_main_table1, se dec(3) alpha( 0.01, 0.05, 0.1) tex label

local dep tfp 
sum `dep'  if e(sample)==1
local m = r(mean)
reg `dep' `x' if fdifull05k==0 , rob 
`outreg' addstat(Mean dep var, `m') replace  

foreach dep in log_cmpsales log_emp04k log_nsewm empgrw0403 lwage rewardnon newprod {
sum `dep' if e(sample)==1 
local m = r(mean)
reg `dep' `x' if fdifull05k==0 , rob 
`outreg' addstat(Mean dep var, `m') 
} 

// Table 5. Main variables ---------------------------------------------------------------
cd "$results" 
local x dnonknitint04k 
local outreg outreg2 using jetro05_main_table5, se dec(3) alpha( 0.01, 0.05, 0.1) tex label

local dep tfp 
sum `dep'  if e(sample)==1
local m = r(mean)
reg `dep' `x' if fdifull05k==0 , rob 
`outreg' addstat(Mean dep var, `m') replace  

foreach dep in log_cmpsales log_emp04k log_nsewm empgrw0403 lwage rewardnon newprod {
sum `dep' if e(sample)==1 
local m = r(mean)
reg `dep' `x' if fdifull05k==0 , rob 
`outreg' addstat(Mean dep var, `m') 
} 

// Table B.1.2. Main variables [Appendix] ---------------------------------------------------------------
cd "$results" 
local x ap_time_hr iz_k city_time_hr 
local outreg outreg2 using jetro05_main_tableB12, se dec(3) alpha( 0.01, 0.05, 0.1) tex label

local dep tfp 
sum `dep'  if e(sample)==1
local m = r(mean)
reg `dep' `x' if fdifull05k==0 , rob 
`outreg' addstat(Mean dep var, `m') replace  

foreach dep in log_cmpsales log_emp04k log_nsewm empgrw0403 lwage rewardnon newprod {
sum `dep' if e(sample)==1 
local m = r(mean)
reg `dep' `x' if fdifull05k==0 , rob 
`outreg' addstat(Mean dep var, `m') 
} 

// Table B.1.1. Additional variables [Appendix] ***********************************

local x ap_in1hr iz_k city_time_hr 
local outreg outreg2 using jetro05_additional_B11_1, se dec(3) alpha( 0.01, 0.05, 0.1) tex label

local replace replace 
foreach dep in laborsh nfor_sh pgrad myeduc mtenure mage  { 
sum `dep' if fdifull05k==0 & dnonknitint04k!=. 
local m = r(mean)
reg `dep' `x' if fdifull05k==0, rob 
`outreg' addstat(Mean dep var, `m') `replace'
local replace 
}  

local replace replace    
local outreg outreg2 using jetro05_additional_B11_2, se dec(3) alpha( 0.01, 0.05, 0.1) tex label
    
foreach dep in newtech upgrade tfp_fuel tfp_indv tfp_resid tfp_fuel_resid  { 
sum `dep' if fdifull05k==0 & dnonknitint04k!=. 
local m = r(mean)
reg `dep' `x' if fdifull05k==0, rob 
`outreg' addstat(Mean dep var, `m') `replace'
local replace 
}  

// Table B.2.1. Additional variables [Appendix] ***********************************

local x dnonknitint04k 
local outreg outreg2 using jetro05_additional_B21_1, se dec(3) alpha( 0.01, 0.05, 0.1) tex label

local replace replace 
foreach dep in laborsh nfor_sh pgrad myeduc mtenure mage  { 
sum `dep' if fdifull05k==0 & dnonknitint04k!=. 
local m = r(mean)
reg `dep' `x' if fdifull05k==0, rob 
`outreg' addstat(Mean dep var, `m') `replace'
local replace 
}  

local replace replace    
local outreg outreg2 using jetro05_additional_B21_2, se dec(3) alpha( 0.01, 0.05, 0.1) tex label
    
foreach dep in newtech upgrade tfp_fuel tfp_indv tfp_resid tfp_fuel_resid  { 
sum `dep' if fdifull05k==0 & dnonknitint04k!=. 
local m = r(mean)
reg `dep' `x' if fdifull05k==0, rob 
`outreg' addstat(Mean dep var, `m') `replace'
local replace 
}  

