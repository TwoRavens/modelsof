set more off

cd "$jetro"
// Garment survey data conducted by JETRO IDE 2005 

// Load original data ------------------------------------------------------------------------
use "Data_(1-143 revised by Kudo, operating basis)", clear 

// save as working data 
save jetroide2005_working, replace 

// Creating/renaming variables ------------------------------------------------------------------------

// factory addresses in 2005 - identifing firms in industrial zone and zone numbers, and identifying firms with missing plant address (but with firm address) 
clear 
import excel "geo_jetro.xlsx", firstrow sheet("Sheet1") 
keep qrno iz_k_obs hlta_num missfadd
save geo_jetro, replace  

// airport distance, city distance, township 
use jetroide2005_working, clear 
merge 1:1 qrno using geo_jetro
drop _merge 
replace tspf = tspho if missfadd==1  
run tscode_jetroide2   
rename ap_time ap_time_k 
rename city_time city_time_k 
rename iz iz_k 
gen ap_time_hr = ap_time_k /60 
gen city_time_hr = city_time_k /60 

// foreign ownership 
tab q05, m 
tab q05, m nolabel 
*** 120 fully domestic firms 
gen fdi05k = (q05==1 | q05==2)  
gen fdifull05k = (q05==1) 
label var  fdi05k "foreign owned in 2005 (incl. JV)" 

// owner's education
tab q16
tab q16, nolabel 
gen oeducu = (q16==9)
gen oeducu_k = oeducu

// manager's ethnicity 
tab q18, m 
tab q18, m nolabel 
gen mburmese05k = (q18 == 1) if q18!=. 
gen mchinese05k = (q18 == 3 | q18 == 5) if q18!=. 

// manager's age 
tab q19, m 
gen mage = q19 

// manager's education
tab q20, m 
tab q20, m nolabel 
gen myeduc = 7   if q20 == 5
replace myeduc = 9   if q20 == 6
replace myeduc = 10  if q20 == 7
replace myeduc = 12  if q20 == 8
replace myeduc = 14  if q20 == 9
replace myeduc = 12  if q20 == 10
replace myeduc = .  if q20 == 99

// manager's tenure 
tab q21, m  
gen mtenure = q21

// manager's share in business 
tab q22, m 
tab q22, m nolabel 
gen dfamowner = (q22==1) if q22!=. 

// year of establishment 
tab q09y, m 
gen firmage05k = 2005-q09y 
label var firmage05k "firm age in 2005" 

// Owner's ethnicity 
tab q14, m 
tab q14, m nolabel 
gen oburmese05k = (q14 == 1) if q14!=. 
gen ochinese05k = (q14 == 3 | q14 == 5) if q14!=. 

// Owner's age 
tab q15, m 
gen oage = q15 

// Owner's education
tab q16, m 
tab q16, m nolabel 
*** primary 5 years, secondary 3 years, high 2 years 
gen oyeduc = 7   if q16 == 5
replace oyeduc = 9   if q16 == 6
replace oyeduc = 10  if q16 == 7
replace oyeduc = 12  if q16 == 8
replace oyeduc = 14  if q16 == 9
replace oyeduc = 12  if q16 == 10
replace oyeduc = .  if q16 == 99

// Owner's tenure 
tab q17, m 
gen otenure = q17 

// CMP/FOB
tab q071, m 
gen cmp = (q071>0 & q071!=.) 

tab q072, m 
gen fob = (q072>0 & q072!=.) 

// Process 
tab q25_sewing_only, m
gen dsewing_only = (q25_sewing_only==1) 

save jetroide2005_working, replace 

// Products **********************************************************************
use jetroide2005_working, clear 

gen multisalestype = 0 

forvalues i = 1/5 { 
gen sales_pt`i' = 0 
replace sales_pt`i' = q280`i'q* q280`i'p*0.1 if q280`i'p!=.
replace sales_pt`i' = q280`i'q* q280`i'a if q280`i'a!=.
replace sales_pt`i' = q280`i'q* q280`i'  if q280`i'!=. 
replace multisalestype = 1 if (q280`i'p!=. & q280`i'a!=.) |  (q280`i'a!=. & q280`i'!=.) |  (q280`i'p!=. & q280`i'!=.)
}
** no product 06

forvalues i = 7/9 { 
gen sales_pt`i' = 0 
replace sales_pt`i' = q280`i'q* q280`i'p*0.1 if q280`i'p!=.
replace sales_pt`i' = q280`i'q* q280`i'a if q280`i'a!=.
replace sales_pt`i' = q280`i'q* q280`i'  if q280`i'!=. 
replace multisalestype = 1 if (q280`i'p!=. & q280`i'a!=.) |  (q280`i'a!=. & q280`i'!=.) |  (q280`i'p!=. & q280`i'!=.)
}

forvalues i = 10/20 { 
gen sales_pt`i' = 0 
replace sales_pt`i' = q28`i'q* q28`i'p*0.1 if q28`i'p!=.
replace sales_pt`i' = q28`i'q* q28`i'a if q28`i'a!=.
replace sales_pt`i' = q28`i'q* q28`i'  if q28`i'!=. 
replace multisalestype = 1 if (q28`i'p!=. & q28`i'a!=.) |  (q28`i'a!=. & q28`i'!=.) |  (q28`i'p!=. & q28`i'!=.)
}

gen sales_ptot1 = 0
replace sales_ptot1 = q28o1q* q28o1p*0.1 if q28o1p!=.
replace sales_ptot1 = q28o1q* q28o1a if q28o1a!=.
replace sales_ptot1 = q28o1q* q28o1  if q28o1!=. 
replace multisalestype = 1 if (q28o1p!=. & q28o1a!=.) |  (q28o1a!=. & q28o1!=.) |  (q28o1p!=. & q28o1!=.)


gen sales_ptot2 = 0
replace sales_ptot2 = q28o2q* q28o2p*0.1 if q28o2p!=.
replace sales_ptot2 = q28o2q* q28o2a if q28o2a!=.
replace sales_ptot2 = q28o2q* q28o2  if q28o2!=. 
replace multisalestype = 1 if (q28o2p!=. & q28o2a!=.) |  (q28o2a!=. & q28o2!=.) |  (q28o2p!=. & q28o2!=.)


// knit and non-knit 
gen sales_knit = 0 
gen nprod_knit = 0 
gen sales_nonknit = 0 
gen nprod_nonknit = 0 
gen sales_other = 0 
forvalues i = 1/5 { 
replace sales_knit = sales_pt`i' + sales_knit
replace nprod_knit = (sales_pt`i'>0) + nprod_knit
} 
forvalues i = 7/11 { 
replace sales_knit = sales_pt`i' + sales_knit
replace nprod_knit = (sales_pt`i'>0) + nprod_knit
} 

forvalues i = 12/20 { 
replace sales_nonknit = sales_pt`i' + sales_nonknit
replace nprod_nonknit = (sales_pt`i'>0) + nprod_nonknit
} 

replace sales_other = sales_ptot1 + sales_ptot2
gen nprod_other = ( sales_ptot1>0 ) + (sales_ptot2>0)

gen sales04 = sales_nonknit + sales_knit + sales_other
gen log_sales04 = log(sales04) 
gen nonknitint04k = (sales_nonknit+sales_other/2)/(sales_nonknit + sales_knit+sales_other)  // price of domestic vs cmp not adjusted 
gen nonknitint04k_nprod =  (nprod_nonknit + nprod_other/2)/( nprod_knit +  nprod_nonknit + nprod_other)

gen dnonknitint04k = (nonknitint04k_nprod > 0.5) 

save jetroide2005_working, replace 

// Machine ************************************************************************
use jetroide2005_working, clear 

// sewing machine 
sum q3801q q3802q q380o1q q380o2q q380o3q q3811q q3812q q3813q q3814q q381o1q q381o2q q3821q 
gen nsewm = 0
foreach x in q3801q q3802q q380o1q q380o2q q380o3q q3811q q3812q q3813q q3814q q381o1q q381o2q q3821q {
replace `x' = 0 if `x'==. 
replace nsewm = nsewm + `x' 
}

gen log_nsewm = log(nsewm) 

gen lockstich_n = q3801q
gen lockstich_c = q3801c
gen lockstich_y = q3801y
gen lockstich_p = q3801p
gen overlock_n = q3802q
gen overlock_c = q3802c
gen overlock_y = q3802y
gen overlock_p = q3802p

local delta = 0.05  
gen lockstich_v = lockstich_n*lockstich_p*(1-`delta')^(2004-lockstich_y) 
gen overlock_v = overlock_n*overlock_p*(1-`delta')^(2004-lockstich_y)  

replace lockstich_v = 0 if lockstich_v==. 
replace overlock_v = 0 if overlock_v==. 
replace lockstich_n = 0 if lockstich_n==. 
replace overlock_n = 0 if overlock_n==. 

gen sewm_other_n = q380o1q
replace sewm_other_n = sewm_other_n + q380o2q if q380o2q!=. 
replace sewm_other_n = sewm_other_n + q380o3q if q380o3q!=. 
replace sewm_other_n = 0 if sewm_other_n==. 
gen sewm_other_v = q380o1q*q380o1p
replace sewm_other_v = sewm_other_v + q380o2q*q380o2p if q380o2q!=. & q380o2p!=.  
replace sewm_other_v = sewm_other_v + q380o3q*q380o3p if q380o3q!=. & q380o3p!=.  
replace sewm_other_v = 0 if sewm_other_v==. 

save jetroide2005_working, replace 

// Employment  ************************************************************************
use jetroide2005_working, clear 

gen emp04k = q43a_04 
gen emp03k = q43a_03
                                                 
gen emp04k2 = q513
gen emp03k2 = q512

gen log_emp03k = log(emp03k)
gen log_emp04k = log(emp04k)

gen empgrw0403 = log_emp04k - log_emp03k

gen female = q43bfp/100
gen nsupervisor = q43b1_t
gen noperator = q43b2_t
gen nhelper = q43b3_t
replace nsupervisor = 0 if q43b1_t==. 
replace noperator = 0 if q43b2_t==. 
replace nhelper = 0 if q43b3_t==. 

gen emp04k_nh = emp04k - nhelper
gen log_emp04k_nh = log(emp04k_nh)

// hours work 
gen hours = q39_04a // shift A 
gen days_inm = q40_04

gen hours_month = q39_04a*q40_04 

gen labor_month04 =  emp04k*hours_month*12
sum labor_month04 
gen log_labor_month04 = log(labor_month04) 

// educational requirement of supervisor 
tab q46s

// average wage of staffs 
tab q48a1_1, m 
sum q48a3_1 // monthly  
gen wage =  q48a1_1/ (q39_04a*days_inm)

gen wage_op =  q48a3_1/ (q39_04a*days_inm)
gen wage_hp =  q48a4_1/ (q39_04a*days_inm)

replace wage = wage_op  if wage==. 

// performance bonus 
tab q49a, m 
gen rewardnon= (q49a==1) if q49a!=. 

// attendance bonus 
tab q49b, m 
gen attendbonus = (q49b==1) if q49b!=. 

// trainings 
tab q541
gen dtraining = (q541==1) if q541!=. 

tab q56
gen training = q56
replace training = 0 if q56==.

// loss for labor issues 
tab q57a, m

// number of foreign staffs 
tab q60, m 
tab q60, m nolabel 
gen nfor = q60 
replace nfor = 0 if q60 == 98 

gen forpc = nfor/emp04k


// workers' education
tab q453, m // high school 
tab q454, m // 10th standard pass - university level 
tab q455, m // vocational 

gen pgrad = q454/emp04k 

gen hschlpc = q453
replace hschlpc = hschlpc/100

// upgraded existing product line 
tab q6302
tab q6303 

gen upgrade = (q6302==1) 
gen newtech = (q6303==1) 
gen outsourced = (q6309==1)

tab q64, m 
gen rdstaff = (q64==1)
tab q65, m 
gen newtech2y = (q65==1) 

// Developed a major product line in the last two years 
gen newprod = (q6301==1) 

// share of foreign workers 
gen nfor_sh = nfor/emp04k  
gen rdstaff_sh = rdstaff/emp04k 
save jetroide2005_working, replace 


// Calculating TFP  ************************************************************************
use jetroide2005_working, clear 

sum q67_a 
gen log_cmpsales = log(q67_a) 
           
gen cmpsales = q67_a  
gen frac_cmpsales = cmpsales/sales04

gen log_cmpsales_lessfuel = log(q67_a-q67_b1) 
gen log_fuel = log(q67_b1) 

// Cost of workers 
sum q67_b2

sum q67_b1 
gen laborsh= q67_b2/q67_a   
sum laborsh

/*
    Variable |       Obs        Mean    Std. Dev.       Min        Max
-------------+--------------------------------------------------------
     laborsh |       142    .4694842     .304231      .0025        2.4
*/

gen laborsh_sales= q67_b2/sales04   // labor share in sales 
sum laborsh_sales 

// Asset (establishment and working capital) <= does this include machine value? 
sum q70_ta 
gen asset_est = q70_ta if q70_ta != 98 
gen asset_wk = q70_tb if q70_ta != 98 

gen asset = asset_est + asset_wk
gen log_asset = log(asset) 
gen log_asset_est = log(asset_est) 

gen tfp = log_cmpsales - 0.4694842*log_labor_month04 - (1-0.4694842)* log_asset_est 

gen laborint =   log_labor_month04  / log_asset_est 
gen capitalint =  log_asset_est / log_labor_month04 
gen laborint_nh = log_emp04k_nh/ log_asset_est

// other productivity measure 
gen labor_prod = log_cmpsales - log_emp04k 

gen laborsh_half = 0.4694842*0.5 + laborsh*0.5
gen tfp_half = log_cmpsales - laborsh_half*log_labor_month04 - (1-laborsh_half)* log_asset_est
gen tfp_indv = log_cmpsales - laborsh*log_labor_month04 - (1-laborsh)* log_asset_est 
gen tfp_fuel = log_cmpsales - 0.5962192*log_labor_month04 - (1-0.5962192-0.1707723)* log_asset_est - (1-.1707723)* log_fuel 

reg log_cmpsales log_labor_month04 log_asset_est
predict tfp_resid, resid

reg log_cmpsales log_labor_month04 log_asset_est log_fuel
predict tfp_fuel_resid, resid  

label var dnonknitint04k "Non-knit" 
label var ochinese "Chinese Burmese owner" 
label var oeducu "Owner university graduate" 
label var iz_k "Industrial zone (township level)"
label var iz_k_obs "Industrial zone (from address)"
label var ap_time_hr "Travel time to airport (hour)" 
label var city_time_hr "Travel time to city center (hour)" 
label var firmage05k "Firm age" 

gen dap_time_hr = (ap_time_hr>1) if ap_time_k!=. 

sum ap_time_hr, detail
gen d2ap_time_hr = (ap_time_hr>r(p75)) if ap_time_k!=. 

replace wage = wage/800 
gen lwage = log(wage) 
save "$jetro/jetroide2005_working", replace 
