********************************************************************************************************************;
**** This code creates the broadband variables used in the analyses in Dettling, Goodman, and Smith (2017).    *****;    
********************************************************************************************************************;


clear

cd "$datafolder2"

set more off


***Bringing in zip code level provider data;


use zipcode_data_annual_updated

sort zip year
xtset zip year


*Creating some new potential measures of broadband access (higher rmse than original measure);
gen internet_zip_popt12_2700=(providers12/totalpop)*2700
replace internet_zip_popt12_2700=(internet_zip_popt12_2700>=1)

gen internet_zip_sqmi12_12=(providers12/totalland)*12
replace internet_zip_sqmi12_12=(internet_zip_sqmi12_12>=1)

gen internet_zip_popt12_2000=(providers12/totalpop)*2000
replace internet_zip_popt12_2000=(internet_zip_popt12_2000>=1)

gen internet_zip_popt12_2500=(providers12/totalpop)*2500
replace internet_zip_popt12_2500=(internet_zip_popt12_2500>=1)

gen internet_zip_popt12_3000=(providers12/totalpop)*3000
replace internet_zip_popt12_3000=(internet_zip_popt12_3000>=1)

gen internet_zip_sqmi10_12=(providers12/totalland)*10
replace internet_zip_sqmi10_12=(internet_zip_sqmi10_12>=1)

gen internet_zip_sqmi15_12=(providers12/totalland)*15
replace internet_zip_sqmi15_12=(internet_zip_sqmi15_12>=1)


gen internet_2000_12_urban12 = internet_zip_popt12_2000
replace internet_2000_12_urban12 = internet_zip_sqmi12_12 if frac_urban < 0.5 & frac_urban~=.
replace internet_2000_12_urban12 =. if year == 2008

gen internet_2500_12_urban12 = internet_zip_popt12_2500
replace internet_2500_12_urban12 = internet_zip_sqmi12_12 if frac_urban < 0.5 & frac_urban~=.
replace internet_2500_12_urban12 =. if year == 2008

gen internet_3000_12_urban12 = internet_zip_popt12_3000
replace internet_3000_12_urban12 = internet_zip_sqmi12_12 if frac_urban < 0.5 & frac_urban~=.
replace internet_3000_12_urban12 =. if year == 2008

gen internet_2000_10_urban12 = internet_zip_popt12_2000
replace internet_2000_10_urban12 = internet_zip_sqmi10_12 if frac_urban < 0.5 & frac_urban~=.
replace internet_2000_10_urban12 =. if year == 2008

gen internet_2500_10_urban12 = internet_zip_popt12_2500
replace internet_2500_10_urban12 = internet_zip_sqmi10_12 if frac_urban < 0.5 & frac_urban~=.
replace internet_2500_10_urban12 =. if year == 2008

gen internet_2700_10_urban12 = internet_zip_popt12_2500
replace internet_2700_10_urban12 = internet_zip_sqmi10_12 if frac_urban < 0.5 & frac_urban~=.
replace internet_2700_10_urban12 =. if year == 2008

gen internet_3000_10_urban12 = internet_zip_popt12_3000
replace internet_3000_10_urban12 = internet_zip_sqmi10_12 if frac_urban < 0.5 & frac_urban~=.
replace internet_3000_10_urban12 =. if year == 2008



gen internet_2000_15_urban12 = internet_zip_popt12_2000
replace internet_2000_15_urban12 = internet_zip_sqmi15_12 if frac_urban < 0.5 & frac_urban~=.
replace internet_2000_15_urban12 =. if year == 2008

gen internet_2500_15_urban12 = internet_zip_popt12_2500
replace internet_2500_15_urban12 = internet_zip_sqmi15_12 if frac_urban < 0.5 & frac_urban~=.
replace internet_2500_15_urban12 =. if year == 2008

gen internet_2700_15_urban12 = internet_zip_popt12_2500
replace internet_2700_15_urban12 = internet_zip_sqmi15_12 if frac_urban < 0.5 & frac_urban~=.
replace internet_2700_15_urban12 =. if year == 2008

gen internet_3000_15_urban12 = internet_zip_popt12_3000
replace internet_3000_15_urban12 = internet_zip_sqmi15_12 if frac_urban < 0.5 & frac_urban~=.
replace internet_3000_15_urban12 =. if year == 2008

gen prov12_pop = providers12/totalpop*1000 
replace prov12_pop =. if year == 2008
gen prov12_sqm = providers12/totalland
replace prov12_sqm =. if year == 2008


***Creates one and two lags of each measure of broadband and control variables;
*One lag December (ending in 12) is December of Senior year;
*One lag June (ending in 6) is June of end of Junior year;
*Two lags December (ending in 12) is December of Junior year;




foreach var of varlist  totalland totalpop years_since_covered mean_agi pop_density providers6 internet_zip_urban6 ///
					providers_dum6 providers12 internet_zip_urban12 providers_dum12 internet_zip_popt12_2700 internet_zip_sqmi12_12  ///
					internet_2000_12_urban12 internet_2500_12_urban12 internet_3000_12_urban12 internet_2000_10_urban12 ///
					internet_2500_10_urban12 internet_2700_10_urban12 internet_3000_10_urban12 internet_2000_15_urban12 internet_2500_15_urban12 ///
					internet_2700_15_urban12 internet_3000_15_urban12 prov12_pop prov12_sqm{

gen `var'_lag = l.`var'
gen `var'_lag2 = l2.`var'
}


cd "$datafolder2"


save zipcode_data_annual_updated, replace




clear

cd "$datafolder2"


*** Getting lagged home prices and unemployment rates;
use county_hprice_urate_zips
sort zip year unemp_rate6
quietly by zip year unemp_rate6:  gen dup = cond(_N==1,0,_n)
keep if dup<=1
drop dup
xtset zip year
foreach var of varlist unemp_rate6 unemp_rate12 med_homeprice6 med_homeprice12{ 
gen `var'_lag = l.`var'
gen `var'_lag2 = l2.`var'
}
save county_hprice_urate_zips, replace



