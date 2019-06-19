*Code to estimate nationwide regressions to show asymmetries across countries and over time
*Want to do this with country level data as well as with province-level data with province FEs
*Written by AC, October 21, 2010
*Modified October 25th to separate the data according to RERs in the bottom and top quartile, rather than 10% under- or over-valuaiton

*Modified by AC, September 8, 2011. I will update to 2010 and combine the various reduced form codes into one file. 
*This code does the following: (i) update data to 2010 (ii) reduced form baseline regs
*(iii) Reduced form with quartiles (iv) Nationwide regs (with economic indicators) to show robustness
*Updated again on October 17, 2011 to change the quartile cutoffs to reflect the 2010 data.


clear all 
set mem 50m
set more off

tempfile regdata
 
*Set directory to "data"

use crossings_ports_1972_2010, clear
keep if (placetype=="province" | placetype=="Canada")
drop if prov_ab=="YT"
drop if prov_ab=="NS"
drop port_id port_code port_ab port

gen daytrip=(nights==0)
drop nights
*The next line adds 1 night and 2+ nights into one obs, for each province-month
collapse (sum) crossings, by(year month province prov_ab res_ca daytrip placetype)

*Need to merge Exchange rate data
sort year month
merge m:1 year month using rer
drop if _merge==2 //2011 data on exchange rates
drop _merge

gen ln_rer=ln(rer)

gen ln_crossings=log(crossings)
gen post911=(year>2001 | (year==2001 & month>8))

gen over10=(rer>1.1)
gen under10=(rer<0.9)
gen ln_rerXover10=ln_rer*over10
gen ln_rerXunder10=ln_rer*under10
gen us=(res_ca==0)

*gen low_quartile=rer<0.888
gen low_quartile=rer<0.8952157
*gen high_quartile=rer>1.07
gen high_quartile=rer>1.0857
gen ln_rerXlow=ln_rer*low_quartile
gen ln_rerXhigh=ln_rer*high_quartile

gen trend=year-1972+(month/12)
gen trend_sq=trend^2

*Creating province FEs (separately for the US and Canadian sides)
foreach x in "bc" "ab" "sk" "mb" "on" "qc" "nb" {
gen `x'_ca_cars=(prov_ab==upper("`x'") & res_ca==1)
gen `x'_us_cars=(prov_ab==upper("`x'") & res_ca==0)
}

*Defining varlists
local fe_us_0 *_ca_cars
local fe_us_1 *_us_cars

save temp_regdata
******************************************************************************************************
* Now province level data, with prov FEs, use 10% under/over

eststo clear

use temp_regdata, clear
keep if placetype=="province"

egen idvar=group(province res_ca daytrip)
sort year month
gen mydate = ym(year,month)
tsset idvar mydate, monthly

gen le = ln_rer
gen leXhigh = ln_rerXhigh
gen leXlow = ln_rerXlow


foreach daytrip in 1 0 {
foreach us in 1 0 {
*Baseline regression with no RER information
qui reg ln_crossings post911 i.month trend trend_sq `fe_us_`us'' if daytrip==`daytrip' & us==`us'
scalar r2_b_`daytrip'_`us' = e(r2)
*Now adding ln(RER)
qui reg ln_crossings le post911 i.month trend trend_sq `fe_us_`us'' if daytrip==`daytrip' & us==`us'
scalar r2_`daytrip'_`us' = e(r2)
scalar s_`daytrip'_`us' = e(rmse)
newey ln_crossings le post911 i.month trend trend_sq `fe_us_`us'' if daytrip==`daytrip' & us==`us', lag(120) force

eststo contemp_base_`daytrip'_`us'
estadd scalar r2_b = r2_b_`daytrip'_`us'
estadd scalar r2 = r2_`daytrip'_`us'
estadd scalar rmse = s_`daytrip'_`us'
}
}

foreach daytrip in 1 0 {
foreach us in 1 0 {
qui reg ln_crossings le leXhigh leXlow post911 i.month trend trend_sq `fe_us_`us'' if daytrip==`daytrip' & us==`us'
scalar r2 = e(r2)
scalar rmse = e(rmse)
newey ln_crossings le leXhigh leXlow post911 i.month trend trend_sq `fe_us_`us'' if daytrip==`daytrip' & us==`us', lag(60) force
eststo contemp_quart_`daytrip'_`us'
estadd scalar r2 = r2
estadd scalar rmse = rmse
}
}



set linesize 250
qui log using redform_provincelevel.txt, text replace

esttab contemp_base_1_1 contemp_base_1_0 contemp_base_0_1 contemp_base_0_0 contemp_quart_1_1 contemp_quart_1_0 contemp_quart_0_1 contemp_quart_0_0, b(%4.2f) se(%4.2f) scalars(r2) ///
starlevels(c 0.1 b 0.05 a 0.01) keep(le leXhigh leXlow) mtitles("usday" "usday" "caday" "caday" "usnight" "usnight" "canight" "canight") title("Province-level data") compress

qui log off

qui log close
erase temp_regdata.dta

