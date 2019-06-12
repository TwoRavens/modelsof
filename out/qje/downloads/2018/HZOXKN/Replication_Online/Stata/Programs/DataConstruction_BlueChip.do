clear
clear mata
set memory 700m
set more off, perm


/* Directories */
local dirdata     "../Data_Orig/BlueChip/"
local dirworking  "../IntermediateFiles/"



**************************************************
**************Clean Raw Data**********************
**************************************************


insheet using "`dirdata'1980-1991/Change in Private Inventories.csv", clear
save "`dirdata'temp", replace
insheet using "`dirdata'1991-2014/Change in Private Inventories.csv", clear
append using "`dirdata'temp"
sort year month

save "`dirdata'ChangeInPrivateInventory", replace

************************************

insheet using "`dirdata'1980-1991/Civilian Unemployment Rate.csv", clear
generate ind_a_cunemp_0yrq1 = strpos(cunemp_0yrq1,"e")
replace cunemp_0yrq1 = substr(cunemp_0yrq1,1,ind_a_cunemp_0yrq1-1) if ind_a_cunemp_0yrq1!=0
destring cunemp_0yrq1, replace
replace cunemp_0yrq1=. if ind_a_cunemp_0yrq1!=0
replace ind_a_cunemp_0yrq1=1 if ind_a_cunemp_0yrq1!=0
save "`dirdata'temp", replace

insheet using "`dirdata'1991-2014/Civilian Unemployment Rate.csv", clear

foreach obs in cunemp_l1yrq4 cunemp_0yrq1 cunemp_0yrq2 cunemp_0yrq3 cunemp_l1yrq4_top10 cunemp_l1yrq4_bot10 cunemp_0yrq1_top10 cunemp_0yrq1_bot10 cunemp_0yrq2_top10 cunemp_0yrq2_bot10 cunemp_0yrq3_top10 cunemp_0yrq3_bot10{
	replace `obs'="." if `obs'=="n.a." | `obs'=="na"
}

foreach obs in cunemp_l1yrq4_top10 cunemp_l1yrq4_bot10 cunemp_0yrq1_top10 cunemp_0yrq1_bot10 cunemp_0yrq2_top10 cunemp_0yrq2_bot10 cunemp_0yrq3_top10 cunemp_0yrq3_bot10{
	destring `obs', replace
}

foreach obs in cunemp_l1yrq4 cunemp_0yrq1 cunemp_0yrq2 cunemp_0yrq3{
	generate ind_a_`obs' = strpos(`obs',"a")
	replace `obs' = substr(`obs',1,ind_a_`obs'-1) if ind_a_`obs'!=0
	destring `obs', replace
	replace `obs'=. if ind_a_`obs'!=0
	replace ind_a_`obs'=1 if ind_a_`obs'!=0
}
append using "`dirdata'temp"
sort year month
save "`dirdata'CivilianUnemploymentRate", replace

************************************

insheet using "`dirdata'1980-1991/Consumer Price Index.csv", clear
save "`dirdata'temp", replace
insheet using "`dirdata'1991-2014/Consumer Price Index.csv", clear
foreach obs in cpi_l1yrq4_top10 cpi_l1yrq4_bot10{
	replace `obs'="." if `obs'=="n.a." | `obs'=="na" | `obs'=="n.a"
	destring `obs', replace
}

foreach obs in cpi_l1yrq4{
	generate ind_a_`obs' = strpos(`obs',"a")
	replace `obs' = substr(`obs',1,ind_a_`obs'-1) if ind_a_`obs'!=0
	destring `obs', replace
	replace `obs'=. if ind_a_`obs'!=0
	replace ind_a_`obs'=1 if ind_a_`obs'!=0
}
append using "`dirdata'temp"
sort year month
save "`dirdata'CPI", replace

************************************

insheet using "`dirdata'1980-1991/Corp. Aaa Bonds.csv", clear
foreach obs in  corpaaabond_0yrq1  corpaaabond_0yrq3{
	generate ind_a_`obs' = strpos(`obs',"a")
	generate ind_e_`obs' = strpos(`obs',"e")
	replace `obs' = substr(`obs',1,ind_a_`obs'-1) if ind_a_`obs'!=0
	replace `obs' = substr(`obs',1,ind_e_`obs'-1) if ind_e_`obs'!=0
	destring `obs', replace
	replace `obs'=. if ind_a_`obs'!=0 | ind_e_`obs'!=0
	replace ind_a_`obs'=1 if ind_a_`obs'!=0
	replace ind_e_`obs'=1 if ind_e_`obs'!=0
	rename ind_a_`obs' ind_aa_`obs'
	gen sumind`obs'=ind_aa_`obs'+ind_e_`obs'
	drop ind_aa_`obs' ind_e_`obs'
	rename sumind`obs' ind_a_`obs'
}
save "`dirdata'temp", replace

insheet using "`dirdata'1991-2014/Corp. Aaa Bonds.csv", clear
append using "`dirdata'temp"
sort year month
save "`dirdata'CorpAaaBonds", replace

************************************

insheet using "`dirdata'1980-1991/Disposable Personal Income.csv", clear
save "`dirdata'temp", replace
insheet using "`dirdata'1991-2014/Disposable Personal Income.csv", clear
append using "`dirdata'temp"
sort year month
save "`dirdata'DisposablePersonalIncome", replace

************************************

insheet using "`dirdata'1991-2014/GDP Price Index.csv", clear
save "`dirdata'GDPPriceIndex", replace

************************************

insheet using "`dirdata'1980-1991/Industrial Production.csv", clear
save "`dirdata'temp", replace
insheet using "`dirdata'1991-2014/Industrial Production.csv", clear

foreach obs in ip_l1yrq4_top10 ip_l1yrq4_bot10{
	replace `obs'="." if `obs'=="n.a." | `obs'=="na" | `obs'=="n.a"
	destring `obs', replace
}

foreach obs in ip_l1yrq4{
	generate ind_a_`obs' = strpos(`obs',"a")
	replace `obs' = substr(`obs',1,ind_a_`obs'-1) if ind_a_`obs'!=0
	destring `obs', replace
	replace `obs'=. if ind_a_`obs'!=0
	replace ind_a_`obs'=1 if ind_a_`obs'!=0
}
append using "`dirdata'temp"
sort year month
save "`dirdata'IP", replace

************************************

insheet using "`dirdata'1980-1991/Net Exports.csv", clear
replace ne_l1yrq4="." if ne_l1yrq4=="N.A."
destring ne_l1yrq4, replace
save "`dirdata'temp", replace
insheet using "`dirdata'1991-2014/Net Exports.csv", clear
append using "`dirdata'temp"
sort year month
save "`dirdata'NetExport", replace

************************************

insheet using "`dirdata'1980-1991/Non-Ag Payroll.csv", clear
foreach obs in nonagpayroll_l1yrq4 nonagpayroll_0yrq1 nonagpayroll_0yrq2 nonagpayroll_0yrq3 nonagpayroll_0yrq4 nonagpayroll_f1yrq1 nonagpayroll_f1yrq2 nonagpayroll_f1yrq3 nonagpayroll_f1yrq4{
	replace `obs'="." if `obs'=="n.a." | `obs'=="na" | `obs'=="n.a"
	destring `obs', replace
}
save "`dirdata'temp", replace
insheet using "`dirdata'1991-2014/Non-Ag Payroll.csv", clear
append using "`dirdata'temp"
sort year month
save "`dirdata'NonAgPayroll", replace

************************************

insheet using "`dirdata'1980-1991/Personal Consumption Expenditures.csv", clear
save "`dirdata'temp", replace
insheet using "`dirdata'1991-2014/Personal Consumption Expenditures.csv", clear
append using "`dirdata'temp"
sort year month
save "`dirdata'PCE", replace

************************************

insheet using "`dirdata'1980-1991/Producer Price Index.csv", clear
save "`dirdata'temp", replace
insheet using "`dirdata'1991-2014/Producer Price Index.csv", clear
foreach obs in ppi_l1yrq4_top10 ppi_l1yrq4_bot10 ppi_0yrq1_top10 ppi_0yrq1_bot10{
	replace `obs'="." if `obs'=="n.a." | `obs'=="na" | `obs'=="n.a"
	destring `obs', replace
}

foreach obs in ppi_l1yrq4 ppi_0yrq1{
	generate ind_a_`obs' = strpos(`obs',"a")
	replace `obs' = substr(`obs',1,ind_a_`obs'-1) if ind_a_`obs'!=0
	destring `obs', replace
	replace `obs'=. if ind_a_`obs'!=0
	replace ind_a_`obs'=1 if ind_a_`obs'!=0
}
append using "`dirdata'temp"
sort year month
save "`dirdata'PPI", replace

************************************

insheet using "`dirdata'1991-2014/Real GDP.csv", clear
save "`dirdata'RealGDP", replace


************************************

insheet using "`dirdata'1980-1991/Treasury Bill Rate (3-month).csv", clear

foreach obs in tbill_0yrq1 tbill_0y2q3{
	generate ind_a_`obs' = strpos(`obs',"a")
	generate ind_e_`obs' = strpos(`obs',"e")
	replace `obs' = substr(`obs',1,ind_a_`obs'-1) if ind_a_`obs'!=0
	replace `obs' = substr(`obs',1,ind_e_`obs'-1) if ind_e_`obs'!=0
	destring `obs', replace
	replace `obs'=. if ind_a_`obs'!=0 | ind_e_`obs'!=0
	replace ind_a_`obs'=1 if ind_a_`obs'!=0
	replace ind_e_`obs'=1 if ind_e_`obs'!=0
	rename ind_a_`obs' ind_aa_`obs'
	gen sumind`obs'=ind_aa_`obs'+ind_e_`obs'
	drop ind_aa_`obs' ind_e_`obs'
	rename sumind`obs' ind_a_`obs'
}
save "`dirdata'temp", replace

insheet using "`dirdata'1991-2014/Treasury Bill Rate (3-month).csv", clear
foreach obs in  tbill_l1yrq4_top10 tbill_l1yrq4_bot10 tbill_0yrq1_top10 tbill_0yrq1_bot10 tbill_0yrq2_top10 tbill_0yrq2_bot10 tbill_0yrq3_top10 tbill_0yrq3_bot10{
	replace `obs'="." if `obs'=="n.a." | `obs'=="na" | `obs'=="n.a"
	destring `obs', replace
}

foreach obs in  tbill_l1yrq4 tbill_0yrq1 tbill_0yrq2 tbill_0yrq3{
	replace `obs'="." if `obs'=="n.a." | `obs'=="na" | `obs'=="n.a" | `obs'=="n"
	generate ind_a_`obs' = strpos(`obs',"a")
	replace `obs' = substr(`obs',1,ind_a_`obs'-1) if ind_a_`obs'!=0
	destring `obs', replace
	replace `obs'=. if ind_a_`obs'!=0
	replace ind_a_`obs'=1 if ind_a_`obs'!=0
}
append using "`dirdata'temp"
sort year month
save "`dirdata'tbill", replace


************************************

insheet using "`dirdata'1991-2014/Treasury Note Yield (10-year).csv", clear
foreach obs in  tbond_l1yrq4_top10 tbond_l1yrq4_bot10 tbond_0yrq1_top10 tbond_0yrq1_bot10 tbond_0yrq2_top10 tbond_0yrq2_bot10 tbond_0yrq3_top10 tbond_0yrq3_bot10{
	replace `obs'="." if `obs'=="n.a." | `obs'=="na" | `obs'=="n.a"
	destring `obs', replace
}
foreach obs in  tbond_l1yrq4 tbond_0yrq1 tbond_0yrq2 tbond_0yrq3{
	replace `obs'="." if `obs'=="n.a." | `obs'=="na" | `obs'=="n.a" | `obs'=="n"
	generate ind_a_`obs' = strpos(`obs',"a")
	replace `obs' = substr(`obs',1,ind_a_`obs'-1) if ind_a_`obs'!=0
	destring `obs', replace
	replace `obs'=. if ind_a_`obs'!=0
	replace ind_a_`obs'=1 if ind_a_`obs'!=0
}

save "`dirdata'tbond", replace

************************************

insheet using "`dirdata'1980-1991/Change in Business Inventories.csv", clear
save "`dirdata'ChangeInBusinessInventory", replace

************************************

insheet using "`dirdata'1980-1991/GNP Deflator.csv", clear

foreach obs in  gnpdeflator_0yrq3{
	replace `obs'="." if `obs'=="n.a." | `obs'=="na" | `obs'=="n.a" | `obs'=="n"
	generate ind_a_`obs' = strpos(`obs',"f")
	replace `obs' = substr(`obs',1,ind_a_`obs'-1) if ind_a_`obs'!=0
	destring `obs', replace
	replace `obs'=. if ind_a_`obs'!=0
	replace ind_a_`obs'=1 if ind_a_`obs'!=0
}

save "`dirdata'GNPDeflator", replace

************************************

insheet using "`dirdata'1980-1991/Interest Short Term1.csv", clear
save "`dirdata'InterestShortTerm", replace

************************************

insheet using "`dirdata'1980-1991/Labor Force Unemployment.csv", clear
save "`dirdata'LaborForceUnemp", replace

************************************

insheet using "`dirdata'1980-1991/Municipal Bonds.csv", clear
save "`dirdata'MunicipalBonds", replace

************************************

insheet using "`dirdata'1980-1991/Real GNP.csv", clear

foreach obs in realgnp_0yrq3{
	replace `obs'="." if `obs'=="n.a." | `obs'=="na" | `obs'=="n.a" | `obs'=="n"
	generate ind_a_`obs' = strpos(`obs',"f")
	replace `obs' = substr(`obs',1,ind_a_`obs'-1) if ind_a_`obs'!=0
	destring `obs', replace
	replace `obs'=. if ind_a_`obs'!=0
	replace ind_a_`obs'=1 if ind_a_`obs'!=0
}

save "`dirdata'RealGNP", replace

************************************

insheet using "`dirdata'1980-1991/Utility AA Bonds.csv", clear
save "`dirdata'UtilityAABonds", replace


************************************
****reset to no. of quarters ahead**
************************************

foreach data in ChangeInBusinessInventory{
use "`dirdata'/`data'", clear

*drop *_top10 *_bot10
rename *_l1yrq4 q1
rename *_0yrq1 q2
rename *_0yrq2 q3
rename *_0yrq3 q4
rename *_0yrq4 q5
rename *_f1yrq1 q6
rename *_f1yrq2 q7
rename *_f1yrq3 q8
rename *_f1yrq4 q9

gen date=year*100+month
drop year month
reshape long q, i(date) j(quarter)
gen year=floor(date/100)
gen month=date-year*100
replace quarter=quarter-2 if month==1 |  month==2 | month==3
replace quarter=quarter-3 if month==4 |  month==5 | month==6
replace quarter=quarter-4 if month==7 |  month==8 | month==9
replace quarter=quarter-5 if month==10 |  month==11 | month==12

replace quarter=quarter+4

keep date quarter q

reshape wide q, i(date) j(quarter)
drop q0 q1 q2
rename q3 `data'_L1q
rename q4 `data'_0q
rename q5 `data'_F1q
rename q6 `data'_F2q
rename q7 `data'_F3q
rename q8 `data'_F4q
rename q9 `data'_F5q

label var `data'_L1q "`data' lag 1 quarter"
label var `data'_0q "`data' current quarter"
label var `data'_F1q "`data' forward 1 quarter"
label var `data'_F2q "`data' forward 2 quarter"
label var `data'_F3q "`data' forward 3 quarter"
label var `data'_F4q "`data' forward 4 quarter"
label var `data'_F5q "`data' forward 5 quarter"

gen year=floor(date/100)
gen month=date-year*100

drop date
sort year month

save "`dirdata'/`data'_use", replace
}

foreach data in GNPDeflator RealGNP {
use "`dirdata'/`data'", clear
drop ind_*
rename *_l1yrq4 q1
rename *_0yrq1 q2
rename *_0yrq2 q3
rename *_0yrq3 q4
rename *_0yrq4 q5
rename *_f1yrq1 q6
rename *_f1yrq2 q7
rename *_f1yrq3 q8
rename *_f1yrq4 q9

gen date=year*100+month
drop year month
reshape long q, i(date) j(quarter)
gen year=floor(date/100)
gen month=date-year*100
replace quarter=quarter-2 if month==1 |  month==2 | month==3
replace quarter=quarter-3 if month==4 |  month==5 | month==6
replace quarter=quarter-4 if month==7 |  month==8 | month==9
replace quarter=quarter-5 if month==10 |  month==11 | month==12

replace quarter=quarter+4

keep date quarter q

reshape wide q, i(date) j(quarter)
drop q0 q1 q2
rename q3 `data'_L1q
rename q4 `data'_0q
rename q5 `data'_F1q
rename q6 `data'_F2q
rename q7 `data'_F3q
rename q8 `data'_F4q
rename q9 `data'_F5q
rename q10 `data'_F6q
rename q11 `data'_F7q

label var `data'_L1q "`data' lag 1 quarter"
label var `data'_0q "`data' current quarter"
label var `data'_F1q "`data' forward 1 quarter"
label var `data'_F2q "`data' forward 2 quarter"
label var `data'_F3q "`data' forward 3 quarter"
label var `data'_F4q "`data' forward 4 quarter"
label var `data'_F5q "`data' forward 5 quarter"
label var `data'_F6q "`data' forward 6 quarter"
label var `data'_F7q "`data' forward 7 quarter"

gen year=floor(date/100)
gen month=date-year*100

drop date
sort year month

save "`dirdata'/`data'_use", replace
}

foreach data in MunicipalBonds{
use "`dirdata'/`data'", clear

rename *_l1yrq4 q1
rename *_0yrq1 q2
rename *_0yrq2 q3
rename *_0yrq3 q4
rename *_0yrq4 q5
rename *_f1yrq1 q6
rename *_f1yrq2 q7
rename *_f1yrq3 q8
rename *_f1yrq4 q9

gen date=year*100+month
drop year month
reshape long q, i(date) j(quarter)
gen year=floor(date/100)
gen month=date-year*100
replace quarter=quarter-2 if month==1 |  month==2 | month==3
replace quarter=quarter-3 if month==4 |  month==5 | month==6
replace quarter=quarter-4 if month==7 |  month==8 | month==9
replace quarter=quarter-5 if month==10 |  month==11 | month==12

replace quarter=quarter+4

keep date quarter q

reshape wide q, i(date) j(quarter)
drop q2
rename q3 `data'_L1q
rename q4 `data'_0q
rename q5 `data'_F1q
rename q6 `data'_F2q
rename q7 `data'_F3q
rename q8 `data'_F4q
rename q9 `data'_F5q
rename q10 `data'_F6q
rename q11 `data'_F7q

label var `data'_L1q "`data' lag 1 quarter"
label var `data'_0q "`data' current quarter"
label var `data'_F1q "`data' forward 1 quarter"
label var `data'_F2q "`data' forward 2 quarter"
label var `data'_F3q "`data' forward 3 quarter"
label var `data'_F4q "`data' forward 4 quarter"
label var `data'_F5q "`data' forward 5 quarter"
label var `data'_F6q "`data' forward 6 quarter"
label var `data'_F7q "`data' forward 7 quarter"

gen year=floor(date/100)
gen month=date-year*100

drop date
sort year month

save "`dirdata'/`data'_use", replace
}

foreach data in InterestShortTerm LaborForceUnemp UtilityAABonds{
use "`dirdata'/`data'", clear

rename *_l1yrq4 q1
rename *_0yrq1 q2
rename *_0yrq2 q3
rename *_0yrq3 q4
rename *_0yrq4 q5
rename *_f1yrq1 q6
rename *_f1yrq2 q7
rename *_f1yrq3 q8
rename *_f1yrq4 q9

gen date=year*100+month
drop year month
reshape long q, i(date) j(quarter)
gen year=floor(date/100)
gen month=date-year*100
replace quarter=quarter-2 if month==1 |  month==2 | month==3
replace quarter=quarter-3 if month==4 |  month==5 | month==6
replace quarter=quarter-4 if month==7 |  month==8 | month==9
replace quarter=quarter-5 if month==10 |  month==11 | month==12

replace quarter=quarter+4

keep date quarter q

reshape wide q, i(date) j(quarter)
drop q0 q1 q2
rename q3 `data'_L1q
rename q4 `data'_0q
rename q5 `data'_F1q
rename q6 `data'_F2q
rename q7 `data'_F3q
rename q8 `data'_F4q
rename q9 `data'_F5q
rename q10 `data'_F6q
rename q11 `data'_F7q

label var `data'_L1q "`data' lag 1 quarter"
label var `data'_0q "`data' current quarter"
label var `data'_F1q "`data' forward 1 quarter"
label var `data'_F2q "`data' forward 2 quarter"
label var `data'_F3q "`data' forward 3 quarter"
label var `data'_F4q "`data' forward 4 quarter"
label var `data'_F5q "`data' forward 5 quarter"
label var `data'_F6q "`data' forward 6 quarter"
label var `data'_F7q "`data' forward 7 quarter"

gen year=floor(date/100)
gen month=date-year*100

drop date
sort year month

save "`dirdata'/`data'_use", replace
}

foreach data in ChangeInPrivateInventory DisposablePersonalIncome GDPPriceIndex NetExport NonAgPayroll PCE RealGDP{
use "`dirdata'/`data'", clear        

drop *_top10 *_bot10
rename *_l1yrq4 q1
rename *_0yrq1 q2
rename *_0yrq2 q3
rename *_0yrq3 q4
rename *_0yrq4 q5
rename *_f1yrq1 q6
rename *_f1yrq2 q7
rename *_f1yrq3 q8
rename *_f1yrq4 q9

gen date=year*100+month
drop year month
reshape long q, i(date) j(quarter)
gen year=floor(date/100)
gen month=date-year*100
replace quarter=quarter-2 if month==1 |  month==2 | month==3
replace quarter=quarter-3 if month==4 |  month==5 | month==6
replace quarter=quarter-4 if month==7 |  month==8 | month==9
replace quarter=quarter-5 if month==10 |  month==11 | month==12

replace quarter=quarter+4

keep date quarter q

reshape wide q, i(date) j(quarter)
drop q0 q1 q2
rename q3 `data'_L1q
rename q4 `data'_0q
rename q5 `data'_F1q
rename q6 `data'_F2q
rename q7 `data'_F3q
rename q8 `data'_F4q
rename q9 `data'_F5q
rename q10 `data'_F6q
rename q11 `data'_F7q

label var `data'_L1q "`data' lag 1 quarter"
label var `data'_0q "`data' current quarter"
label var `data'_F1q "`data' forward 1 quarter"
label var `data'_F2q "`data' forward 2 quarter"
label var `data'_F3q "`data' forward 3 quarter"
label var `data'_F4q "`data' forward 4 quarter"
label var `data'_F5q "`data' forward 5 quarter"
label var `data'_F6q "`data' forward 6 quarter"
label var `data'_F7q "`data' forward 7 quarter"

gen year=floor(date/100)
gen month=date-year*100

drop date
sort year month

save "`dirdata'/`data'_use", replace
}


foreach data in CorpAaaBonds CivilianUnemploymentRate CPI IP PPI tbill tbond{
use "`dirdata'/`data'", clear
         
drop *_top10 *_bot10 ind_*
rename *_l1yrq4 q1
rename *_0yrq1 q2
rename *_0yrq2 q3
rename *_0yrq3 q4
rename *_0yrq4 q5
rename *_f1yrq1 q6
rename *_f1yrq2 q7
rename *_f1yrq3 q8
rename *_f1yrq4 q9

gen date=year*100+month
drop year month
reshape long q, i(date) j(quarter)
gen year=floor(date/100)
gen month=date-year*100
replace quarter=quarter-2 if month==1 |  month==2 | month==3
replace quarter=quarter-3 if month==4 |  month==5 | month==6
replace quarter=quarter-4 if month==7 |  month==8 | month==9
replace quarter=quarter-5 if month==10 |  month==11 | month==12

replace quarter=quarter+4

keep date quarter q

reshape wide q, i(date) j(quarter)
drop q0 q1 q2
rename q3 `data'_L1q
rename q4 `data'_0q
rename q5 `data'_F1q
rename q6 `data'_F2q
rename q7 `data'_F3q
rename q8 `data'_F4q
rename q9 `data'_F5q
rename q10 `data'_F6q
rename q11 `data'_F7q

label var `data'_L1q "`data' lag 1 quarter"
label var `data'_0q "`data' current quarter"
label var `data'_F1q "`data' forward 1 quarter"
label var `data'_F2q "`data' forward 2 quarter"
label var `data'_F3q "`data' forward 3 quarter"
label var `data'_F4q "`data' forward 4 quarter"
label var `data'_F5q "`data' forward 5 quarter"
label var `data'_F6q "`data' forward 6 quarter"
label var `data'_F7q "`data' forward 7 quarter"

gen year=floor(date/100)
gen month=date-year*100

drop date
sort year month

save "`dirdata'/`data'_use", replace
}

************************************
***Merge raw**********
************************************
use "`dirdata'ChangeInBusinessInventory", clear
sort year month
save "`dirworking'BlueChip_raw", replace

foreach data in GNPDeflator InterestShortTerm LaborForceUnemp MunicipalBonds RealGNP UtilityAABonds CorpAaaBonds ChangeInPrivateInventory CivilianUnemploymentRate CPI DisposablePersonalIncome GDPPriceIndex IP MunicipalBonds NetExport NonAgPayroll PCE PPI RealGDP tbill tbond{
	use "`dirdata'/`data'", clear
	sort year month
	merge 1:1 year month using "`dirworking'BlueChip_raw"
	sum _merge
	drop _merge
	sort year month
	save "`dirworking'BlueChip_raw", replace
}

************************************
***Merge lagged quarter**********
************************************

use "`dirdata'ChangeInBusinessInventory_use", clear
sort year month
save "`dirworking'BlueChip_use", replace

foreach data in GNPDeflator InterestShortTerm LaborForceUnemp MunicipalBonds RealGNP UtilityAABonds CorpAaaBonds ChangeInPrivateInventory CivilianUnemploymentRate CPI DisposablePersonalIncome GDPPriceIndex IP MunicipalBonds NetExport NonAgPayroll PCE PPI RealGDP tbill tbond{
	use "`dirdata'/`data'_use", clear
	sort year month
	merge 1:1 year month using "`dirworking'BlueChip_use"
	sum _merge
	drop _merge
	sort year month
	save "`dirworking'BlueChip_use", replace
}

****Construct real tbill rate
foreach quarter in L1q 0q F1q F2q F3q F4q F5q F6q F7q{
	gen rtbillcpi_`quarter'=tbill_`quarter'-CPI_`quarter'
	gen rtbillpce_`quarter'=tbill_`quarter'-PCE_`quarter'
	gen rtbillpgdp_`quarter'=tbill_`quarter'-GDPPriceIndex_`quarter'
	label var rtbillcpi_`quarter' "real tbill rate constructed as tbill rate - the same month forecast of cpi inflation index"
	label var rtbillpce_`quarter' "real tbill rate constructed as tbill rate - the same month forecast of pce inflation index"
	label var rtbillpgdp_`quarter' "real tbill rate constructed as tbill rate - the same month forecast of pgdp inflation index"
	}

save "`dirworking'BlueChip_use", replace


**************************************************
**************Blue Chips expectation**************
**************************************************

use "`dirworking'BlueChip_use", clear

***construct expectation change********************

*ChangeInBusinessInventory
foreach quarter in L1q 0q F1q F2q F3q F4q F5q{
	gen DChangeInBusinessInventory_`quarter'=ChangeInBusinessInventory_`quarter'-ChangeInBusinessInventory_`quarter'[_n-1] if month==2 | month==3 | month==5 | month==6 | month==8 | month==9 | month==11 | month==12
}
replace DChangeInBusinessInventory_L1q=ChangeInBusinessInventory_L1q-ChangeInBusinessInventory_0q[_n-1] if month==1 | month==4 | month==7 | month==10
replace DChangeInBusinessInventory_0q=ChangeInBusinessInventory_0q-ChangeInBusinessInventory_F1q[_n-1] if month==1 | month==4 | month==7 | month==10
foreach num of numlist 1/4{
	local i = `num' +1
	replace DChangeInBusinessInventory_F`num'q=ChangeInBusinessInventory_F`num'q-ChangeInBusinessInventory_F`i'q[_n-1] if month==1 | month==4 | month==7 | month==10
}

foreach data in rtbillcpi rtbillpce rtbillpgdp GNPDeflator InterestShortTerm LaborForceUnemp MunicipalBonds RealGNP UtilityAABonds CorpAaaBonds ChangeInPrivateInventory CivilianUnemploymentRate CPI DisposablePersonalIncome GDPPriceIndex IP NetExport NonAgPayroll PCE PPI RealGDP tbill tbond{
	foreach quarter in L1q 0q F1q F2q F3q F4q F5q F6q F7q{
	gen D`data'_`quarter'=`data'_`quarter'-`data'_`quarter'[_n-1] if month==2 | month==3 | month==5 | month==6 | month==8 | month==9 | month==11 | month==12
	}
	replace D`data'_L1q=`data'_L1q-`data'_0q[_n-1] if month==1 | month==4 | month==7 | month==10
	replace D`data'_0q=`data'_0q-`data'_F1q[_n-1] if month==1 | month==4 | month==7 | month==10
	foreach num of numlist 1/6{
		local i = `num' +1
		replace D`data'_F`num'q=`data'_F`num'q-`data'_F`i'q[_n-1] if month==1 | month==4 | month==7 | month==10
	}
}

foreach quarter in L1q 0q F1q F2q F3q F4q F5q F6q F7q{
	label var Drtbillcpi_`quarter' "change of tbill real rate using cpi inflation index"
	label var Drtbillpce_`quarter' "change of tbill real rate using pce inflation index"
	label var Drtbillpgdp_`quarter' "change of tbill real rate using pgdp inflation index"
}

save "`dirworking'BlueChip_constructed", replace

keep year month D*
drop DChangeInBusinessInventory* DInterest* DLaborForceUnemp* DMunicipalBonds* DNonAgPayroll* DUtili*
save "`dirworking'BlueChip_reg", replace

outsheet using "`dirworking'BlueChip_reg.csv", comma replace

