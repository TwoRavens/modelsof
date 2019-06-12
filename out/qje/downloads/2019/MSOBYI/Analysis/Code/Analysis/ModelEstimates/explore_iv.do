*insheet using Calculations/Model/data_for_matlab_iv.txt, clear
*save Calculations/Model/data_for_matlab_iv.dta , replace



/* Retailer geographic variation */
* Counties with largest grocery retail chains in 2015

*maptile_install using "http://files.michaelstepner.com/geo_county2010.zip"
use  $Externals/Calculations/RMS/RMS-Prepped.dta, replace, if year==2015&channel_code=="F"
gen N = 1
collapse (sum) N, by(ChainCodeForIV)
sort N
local Chain1 = ChainCodeForIV[_N]
local Chain2 = ChainCodeForIV[_N-1]
local Chain3 = ChainCodeForIV[_N-2]
local Chain4 = ChainCodeForIV[_N-3]
*local Chain5 = ChainCodeForIV[_N-4]
use year state_countyFIPS channel_code ChainCodeForIV using $Externals/Calculations/RMS/RMS-Prepped.dta, replace, ///
	if year==2015&channel_code=="F" & inlist(ChainCodeForIV,`Chain1',`Chain2',`Chain3',`Chain4') // 
rename state_countyFIPS county
gen byte N = 1 
collapse (sum) N,by(county ChainCodeForIV)
reshape wide N,i(county) j(ChainCodeForIV)
foreach var of varlist N* {
	replace `var'=0 if `var'==.
}
egen N = rowtotal(N*)
gen byte Retailer = 5
label define retail 5 "Multiple", add

forvalues n = 1/4 {
	replace Retailer = `n' if N`Chain`n'' == N
	label define retail `n' "`n'", add
}

label value Retailer retail

compress

	maptile Retailer, geography(county2010) conus stateoutline(medium) ///
		spopt(mosize(vvthin) legt(Retailers present:) legorder(lohi)) ///  leglabel(retail)
		twopt(legend(lab(1 "None") lab(2 "Retailer 1") lab(3 "Retailer 2") lab(4 "Retailer 3") lab(5 "Retailer 4") lab(6 "Multiple"))) ///
		cutv(1 2 3 4)
	
	graph export Output/Maps/InstrumentMap_Chains.pdf, as(pdf) replace



//Instrument Maps
use "$Externals/Calculations/RMS/Instruments_CountyLevel.dta", clear


sum lnLO_dm_noCounty_PricePerCal , d
replace lnLO_dm_noCounty_PricePerCal=`r(p99)' if  lnLO_dm_noCounty_PricePerCal>`r(p99)'
replace lnLO_dm_noCounty_PricePerCal=`r(p1)' if   lnLO_dm_noCounty_PricePerCal<`r(p1)'


merge m:1 group using "$Externals/Calculations/OtherNielsen/GroupNameList.dta"
keep if _merge==3
drop _merge

gen temp=lnLO_dm_noCounty_PricePerCal if group==-23
egen iv_frozen_pizza=max(temp), by(fips_state_code fips_county_code year)
drop temp

gen temp=lnLO_dm_noCounty_PricePerCal if group==4001
egen iv_produce=max(temp), by(fips_state_code fips_county_code year)
drop temp

gen produce_vs_pizza_iv=iv_produce-iv_frozen_pizza
egen tag=tag(fips_state_code fips_county_code year) 
gen county=1000*fips_state_code+fips_county_code




//Cookies
gen temp=lnLO_dm_noCounty_PricePerCal if group==1505
egen iv_cookies=max(temp), by(fips_state_code fips_county_code year)
drop temp

//Yogurt
gen temp=lnLO_dm_noCounty_PricePerCal if group==2510
egen iv_yogurt=max(temp), by(fips_state_code fips_county_code year)
drop temp

/*
gen cookies_vs_yougurt_iv=iv_cookies-iv_yogurt
gen produce_vs_yogurt_iv=iv_produce-iv_yogurt
gen cookies_vs_pizza=iv_cookies-iv_frozen_pizza

egen mean_produce_vs_pizza_iv=mean(produce_vs_pizza), by(county)
egen mean_cookies_vs_yougurt_iv=mean(cookies_vs_yougurt), by(county)
egen mean_produce_vs_yogurt_iv=mean(produce_vs_yogurt), by(county)
egen mean_cookies_vs_pizza_iv=mean(cookies_vs_pizza), by(county)
*/

egen mean_produce=mean(iv_produce), by(county)
egen mean_cookies=mean(iv_cookies), by(county)
egen mean_yogurt_iv=mean(iv_yogurt), by(county)
egen mean_pizza_iv=mean(iv_frozen_pizza), by(county)


egen tag_county=tag(county)

maptile mean_produce, geography(county1990) conus stateoutline(medium) revcolor ///
		spopt(mosize(vvthin)) nq(10),  ///title("Difference in Produce vs Frozen Pizza Price Instrument in 2016") ///
		if tag_county==1, twopt(legend(size(small)))
graph export Output/Maps/InstrumentMap_Produce.pdf, as(pdf) replace

maptile mean_cookies, geography(county1990) conus stateoutline(medium) revcolor ///
		spopt(mosize(vvthin)) nq(10),  ///title("Difference in Produce vs Frozen Pizza Price Instrument in 2016") ///
		if tag_county==1, twopt(legend(size(small)))
graph export Output/Maps/InstrumentMap_Cookies.pdf, as(pdf) replace


maptile mean_yogurt, geography(county1990) conus stateoutline(medium) revcolor ///
		spopt(mosize(vvthin)) nq(10),  ///title("Difference in Produce vs Frozen Pizza Price Instrument in 2016") ///
		if tag_county==1, twopt(legend(size(small)))
graph export Output/Maps/InstrumentMap_Yogurt.pdf, as(pdf) replace


maptile mean_pizza, geography(county1990) conus stateoutline(medium) revcolor ///
		spopt(mosize(vvthin)) nq(10),  ///title("Difference in Produce vs Frozen Pizza Price Instrument in 2016") ///
		if tag_county==1, twopt(legend(size(small)))
graph export Output/Maps/InstrumentMap_Pizza.pdf, as(pdf) replace



rename county state_countyFIPS

merge m:1 state_countyFIPS year using "$Externals/Calculations/Geographic/CtXYear_Data.dta"
keep if _merge==3
drop _merge


merge m:1 group using "$Externals/Calculations/Homescan/StoreChoicesHomeScan.dta"

gen HEI=(supply_rlHEI_per1000Cal3+ supply_rlHEI_per1000Cal2+supply_rlHEI_per1000Cal1+ supply_rlHEI_per1000Cal4)/4
replace HEI=(HEI-41.71)/14.31
egen tag_group=tag(group)

sum HEI if tag_group==1, d
gen healthy=HEI>`r(p50)'

gen lninc=ln(Ct_Income)

gen highinc=.
forvalues yr=2006/2016 {
sum lninc if tag==1  & year==`yr',d
replace highinc=lninc>`r(p50)' if lninc~=. & year==`yr'
}
gen HEIhighinc=HEI*highinc
gen healthy_lninc=health*lninc

egen county_year=group(state_countyF year)
egen group_year=group(group year)
gen HEI_lninc=HEI*lninc




reghdfe lnLO_dm_noCounty_PricePerCal HEIhighinc i.year  ,ab(group state_countyFIP) vce(cluster state_countyFIPS) resid(resid)
gen iv_hat=_b[HEIhighinc]*HEIhighinc+resid


binscatter iv_hat HEIhighinc, n(45) xtitle("Health Index x Above median income county") ytitle("Price IV")
graph export "Output/ModelEstimates/PriveIVHighInc.pdf", as(pdf) replace

use "$Externals/Calculations/Model/data_for_matlab_iv.dta", clear
rename expend price
rename energy cals
drop if cals==0



foreach var of varlist    price {
replace `var'=`var'/cals
sum `var', d
replace `var'=`r(p99)' if `var'>`r(p99)' & `var'~=.
}


/*
foreach var of varlist  sodium_mg- Conveniencereal   price {
replace `var'=`var'/cals
sum `var', d
replace `var'=`r(p99)' if `var'>`r(p99)' & `var'~=.
}
*/








gen lnp=ln(price)


gen lncals=ln(cals)


rename year panel_year
merge m:1 household_code panel_year using "$Externals/Calculations/Homescan/Prepped-Household-Panel.dta", keepusing(region_code) nogen
rename panel_year year


foreach var in lncals lnp lnLO_dm_noCounty_PricePerCal{
sum `var', d
replace `var'=`r(p1)' if `var'<`r(p1)'
}

su lnLO_dm_noCounty_PricePerCal, d
replace lnLO_dm_noCounty_PricePerCal=`r(p99)' if lnLO_dm_noCounty_PricePerCal>`r(p99)'



egen group_zip=group(group fips_state_code fips_county_code)



egen store_county_inc=group(fips_state_code fips_county_code inc_cat)
egen group_inc=group(group inc_cat)
egen county_id=group(fips*)

*reghdfe lnp lnLO_dm_noCounty_PricePerCal if inc_cat==1 & year==2007 , ab(county_id group)
*binscatter lnp lnLO_dm_noCounty_PricePerCal if inc_cat==1 & year==2007 & group==1011



reghdfe lnp lnLO_dm_noCounty_PricePerCal i.year  , a(store_county_inc group_inc)  resid(resid4)
gen p_hat=_b[lnLO_dm_noCounty_PricePerCal]*lnLO_dm_noCounty_PricePerCal
replace p_hat=p_hat+resid4


binscatter p_hat  lnLO_dm_noCounty_PricePerCal ,  xtitle("Expected ln(price) deviation due to local chains") ///
	ytitle("Demeaned ln(price per calorie)")
graph export "Output/ModelEstimates/firststage.png", replace
graph export "Output/ModelEstimates/firststage.pdf", replace

// Check first state F
reghdfe lnp lnLO_dm_noCounty_PricePerCal i.year if inc_cat==1, a(county_id group) vce(cluster county_id)
// F=243
reghdfe lnp lnLO_dm_noCounty_PricePerCal i.year if inc_cat==2, a(county_id group) vce(cluster county_id)
// F=252
reghdfe lnp lnLO_dm_noCounty_PricePerCal i.year if inc_cat==3, a(county_id group) vce(cluster county_id)
// F=254
reghdfe lnp lnLO_dm_noCounty_PricePerCal i.year if inc_cat==4, a(county_id group) vce(cluster county_id)
// F=260


reghdfe lncals sodium_mg fruits_total- solid_fats_kcal  i.year (lnp=lnLO_dm_noCounty_PricePerCal)  if inc_cat==1, a(county_id group_region) vce(cluster county_id)
reghdfe lncals sodium_mg fruits_total- solid_fats_kcal  i.year ( lnp= lnLO_dm_noCounty_PricePerCal)  if inc_cat==2, a(county_id group_region) vce(cluster county_id)
reghdfe lncals sodium_mg fruits_total- solid_fats_kcal  i.year (lnp= lnLO_dm_noCounty_PricePerCal)  if inc_cat==3, a(county_id group_region) vce(cluster county_id)
reghdfe lncals sodium_mg fruits_total- solid_fats_kcal  i.year (lnp= lnLO_dm_noCounty_PricePerCal)  if inc_cat==4, a(county_id group_region) vce(cluster county_id)

//state-group Fe
reghdfe lncals sodium_mg fruits_total- solid_fats_kcal  i.year (lnp=lnLO_dm_noCounty_PricePerCal)  if inc_cat==1, a(county_id groupstate) vce(cluster county_id)
reghdfe lncals sodium_mg fruits_total- solid_fats_kcal  i.year ( lnp= lnLO_dm_noCounty_PricePerCal)  if inc_cat==2, a(county_id groupstate) vce(cluster county_id)
reghdfe lncals sodium_mg fruits_total- solid_fats_kcal  i.year (lnp= lnLO_dm_noCounty_PricePerCal)  if inc_cat==3, a(county_id groupstate) vce(cluster county_id)
reghdfe lncals sodium_mg fruits_total- solid_fats_kcal  i.year (lnp= lnLO_dm_noCounty_PricePerCal)  if inc_cat==4, a(county_id groupstate) vce(cluster county_id)








// get guess for model estimates

reghdfe lncals  i.year (price=lnLO_dm_noCounty_PricePerCal)  if inc_cat==1, a(county_id group)
* beta=-266.50
gen lncals_noprice=lncals-_b[price]*price if inc_cat==1
global beta=_b[price]
eststo clear
eststo: areg lncals_noprice i.year sodium_mg fruits_total- solid_fats_kcal if inc_cat==1, ab(county_id)
su sodium_mg fruits_total- solid_fats_kcal price if inc_cat==1


reghdfe lncals  i.year (price=lnLO_dm_noCounty_PricePerCal)  if inc_cat==2, a(county_id group)
* beta=-266.50
replace lncals_noprice=lncals-_b[price]*price if inc_cat==2

eststo: areg lncals_noprice i.year sodium_mg- nonsea_plant_protien if inc_cat==2, ab(county_id)
su sodium_mg- nonsea_plant_protien price if inc_cat==2



reghdfe lncals  i.year (price=lnLO_dm_noCounty_PricePerCal)  if inc_cat==3, a(county_id group)
* beta=-266.50
replace lncals_noprice=lncals-_b[price]*price if inc_cat==3

eststo: areg lncals_noprice i.year sodium_mg- nonsea_plant_protien if inc_cat==3, ab(county_id)
su sodium_mg- nonsea_plant_protien price if inc_cat==3



reghdfe lncals  i.year (price=lnLO_dm_noCounty_PricePerCal)  if inc_cat==4, a(county_id group)
* beta=-266.50
replace lncals_noprice=lncals-_b[price]*price if inc_cat==4

eststo: areg lncals_noprice i.year sodium_mg- nonsea_plant_protien if inc_cat==4, ab(county_id)
su sodium_mg- nonsea_plant_protien price if inc_cat==4



