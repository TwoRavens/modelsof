* tables 3 and 4 show averages of kety variables by country and industry
* generating tables 3, 4
*cd  ..\results_datasets_regressions
cd ..\dta
*use reshaped_variables_country_industry_means,clear
use mnvr_reshaped_variables_country_industry_means,clear

keep if country=="AUT"|country=="DNK"|country=="ESP"|country=="FIN"|country=="FRA"|country=="GER"|country=="ITA"|country=="JPN"|country=="NLD"|country=="UK"|country=="USA"
* We drop fuel-related industries because 1980 was close to the peak of an oil boom
drop if ind=="23"|ind=="E"|ind=="C"
drop diff24* 

*generating weights(share of 1980 employment) for full sample
egen wt1_80 = sum(emp) if year==1980, by(country)
gen wt2_80 = emp/wt1_80
egen wt80 = mean(wt2_80), by(country ind)

* generating weights(share of 1980 employment) for  traded goods
egen wtt1_80 = sum(emp) if year==1980 & import_world!=., by(country)
gen wtt2_80 = emp/wtt1_80
egen wtt80 = mean(wtt2_80), by(country ind)

* generating nonOECD imports and exports
foreach var of newlist import export{
gen `var'_nonoecd= `var'_chn+ `var'_rest
}
* normalising by value added for regressions
foreach var of newlist va{
gen ln_`var'=ln(`var'_USD)
gen tcapit_over_`var'=tcapit_USD/`var'_USD
gen tcapnit_over_`var'=tcapnit_USD/`var'_USD
}
foreach var of varlist  import_oecd export_oecd import_world export_world import_nonoecd export_nonoecd {
replace `var'=. if `var'==0
gen `var'_over_va = `var'/(va_USD*1000000)
}
gen trade_world_over_va=import_world_over_va+export_world_over_va

sort country ind year
*generating 1980 values and 1980-2004 differences for variables of interest

foreach var of varlist  labhs labms labls ln_va tcapit_over_va tcapnit_over_va  trade_world_over_va {
gen diff24_`var' = `var'-`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
gen lag24_`var' =`var'[_n-8] if country==country[_n-8] & ind==ind[_n-8] & int((year-1980)/24)==((year-1980)/24)
}

* Here we sort country names
replace country="Austria" if country=="AUT"
replace country="Denmark" if country=="DNK"
replace country="Spain" if country=="ESP"
replace country="Finland" if country=="FIN"
replace country="France" if country=="FRA"
replace country="Germany" if country=="GER"
replace country="Italy" if country=="ITA"
replace country="Japan" if country=="JPN"
replace country="Netherlands" if country=="NLD"
replace country="UK" if country=="UK"
replace country="USA" if country=="USA"

* Here we sort industries so that all traded goods appear first.

gen key=.
replace key=1 if ind=="AtB"
replace key=2 if ind=="15t16"
replace key=3 if ind=="17t19"
replace key=4 if ind=="20"
replace key=5 if ind=="21t22"
replace key=6 if ind=="24"
replace key=7 if ind=="25"
replace key=8 if ind=="26"
replace key=9 if ind=="27t28"
replace key=10 if ind=="29"
replace key=11 if ind=="30t33"
replace key=12 if ind=="34t35"
replace key=13 if ind=="36t37"
replace key=14 if ind=="50"
replace key=15 if ind=="51"
replace key=16 if ind=="52"
replace key=17 if ind=="60t63"
replace key=18 if ind=="64"
replace key=19 if ind=="70"
replace key=20 if ind=="71t74"
replace key=21 if ind=="F"
replace key=22 if ind=="H"
replace key=23 if ind=="J"
replace key=24 if ind=="L"
replace key=25 if ind=="M"
replace key=26 if ind=="N"
replace key=27 if ind=="O"

label define indl 1 "Agriculture, hunting, forestry and fishing"
label define indl 2 "Food products, beverages and tobacco", add
label define indl 3 "Textiles, textile products, leather and footwear", add
label define indl 4 "Wood and products of wood and cork", add
label define indl 5 "Pulp, paper, paper products, printing and publishing", add
label define indl 6 "Chemicals and chemical products", add
label define indl 7 "Rubber and plastics products", add
label define indl 8 "Other non-metallic mineral products", add
label define indl 9 "Basic metals and fabricated metal products", add
label define indl 10 "Machinery, not elsewhere classified", add
label define indl 11 "Electrical and optical equipment", add
label define indl 12 "Transport equipment", add
label define indl 13 "Manufacturing not elsewhere classified; recycling", add
label define indl 14 "Sale, maintenance and repair of motor vehicles and motorcycles; retail sale of fuel",add
label define indl 15 "Wholesale trade and commission trade, except of motor vehicles and motorcycles",add
label define indl 16 "Retail trade, except of motor vehicles and motorcycles; repair of household goods",add
label define indl 17 "Transport and storage",add
label define indl 18 "Post and telecommunications",add
label define indl 19 "Real estate activities",add
label define indl 20 "Renting of machinery and equipment and other business activities",add
label define indl 21 "Construction",add
label define indl 22 "Hotels and restaurants",add
label define indl 23 "Financial intermediation",add
label define indl 24 "Public admin and defence; compulsory social security",add
label define indl 25 "Education",add
label define indl 26 "Health and social work",add
label define indl 27 "Other community, social and personal services",add

lab values key indl
gsort country
save mnvr_tab3_tab4_intermediate,replace

* For Table 3 Panel A (averages by country of 1980 values of key variables)
collapse(mean) lag24_labhs lag24_labms lag24_labls lag24_ln_va lag24_tcapit_over_va lag24_tcapnit_over_va [aw=wt80], by(country)
cd ..\results
save mnvr_tab3_panel_a_all, replace

cd ..\dta
use mnvr_tab3_tab4_intermediate, clear

collapse(mean) lag24_trade_world_over_va [aw=wtt80], by(country)

cd ..\results
save mnvr_tab3_panel_a_traded, replace

use mnvr_tab3_panel_a_all,clear
merge using mnvr_tab3_panel_a_traded

drop _m

save mnvr_tab3_panel_a, replace


* For Table 3 Panel B (averages by country of 1980-2004 differences of key variables)
cd ..\dta
use mnvr_tab3_tab4_intermediate, clear

collapse(mean) diff24_labhs diff24_labms diff24_labls diff24_ln_va diff24_tcapit_over_va diff24_tcapnit_over_va [aw=wt80], by(country)
cd ..\results
save mnvr_tab3_panel_b_all, replace

cd ..\dta
use mnvr_tab3_tab4_intermediate, clear

collapse(mean) diff24_trade_world_over_va [aw=wtt80], by(country)

cd ..\results
save mnvr_tab3_panel_b_traded, replace

use mnvr_tab3_panel_b_all,clear
merge using mnvr_tab3_panel_b_traded

drop _m

save mnvr_tab3_panel_b, replace



* for table 4 (averages by industry of 1980 levels of key variables):
cd ..\dta
use mnvr_tab3_tab4_intermediate, clear

collapse(mean) lag24_labhs lag24_labms lag24_labls lag24_ln_va lag24_tcapit_over_va lag24_tcapnit_over_va, by(key)

cd ..\results
gsort key
save mnvr_tab4_panel_a_all,replace

cd ..\dta
use mnvr_tab3_tab4_intermediate, clear
collapse(mean) lag24_trade_world_over_va, by(key)

cd ..\results
gsort key
save mnvr_tab4_panel_a_traded,replace

cd ..\dta
use mnvr_tab3_tab4_intermediate, clear
collapse(mean) diff24_labhs diff24_labms diff24_labls diff24_ln_va diff24_tcapit_over_va diff24_tcapnit_over_va, by(key)

cd ..\results
gsort key
save mnvr_tab4_panel_b_all,replace

cd ..\dta
use mnvr_tab3_tab4_intermediate, clear
collapse(mean) diff24_trade_world_over_va, by(key)

cd ..\results
gsort key
save mnvr_tab4_panel_b_traded,replace

cd ..\dta
use mnvr_tab3_tab4_intermediate, clear
collapse(mean) wt80 wtt80, by(key)

cd ..\results
gsort key
save mnvr_tab4_panel_c,replace

use mnvr_tab4_panel_a_all
merge key using mnvr_tab4_panel_a_traded
drop _m
gsort key
merge key using mnvr_tab4_panel_b_all
drop _m
gsort key
merge key using mnvr_tab4_panel_b_traded
drop _m
gsort key
merge key using mnvr_tab4_panel_c
drop _m

save mnvr_tab4,replace




cd ..\dta
