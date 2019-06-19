****************************************************************************************
* This file imports data provided by NACUBO, cleans the variables, and outputs 
* a data file which can be merged with the IPEDS data.
****************************************************************************************

cd "Directory_Path"

*** import the time-series of NACUBO endowment returns and create stdev variable

insheet using NACUBO_Rets.txt
save NACUBO_Ret_Out.dta, clear

bysort uni_numb: egen nacubo_avg_ret=mean(return)
bysort uni_numb: egen nacubo_stdev=sd(return)
bysort uni_numb: egen nac_std_ret_numb=count(return)
save NACUBO_Ret_Out.dta, clear

*** import asset allocation data and create variables

insheet using NACUBO_Asset_Allo.txt
save NACUBO.dta, clear

bysort uni_numb: egen size2003=total(MARKET_VALUE)
bysort uni_numb: egen all_equity=total(MARKET_VALUE) if ASSET_CLASS_ID>=100 & ASSET_CLASS_ID<200

bysort uni_numb: egen all_fi=total(MARKET_VALUE) if ASSET_CLASS_ID>=200 & ASSET_CLASS_ID<300
bysort uni_numb: egen cash=total(MARKET_VALUE) if ASSET_CLASS_ID>=500 & ASSET_CLASS_ID<600

bysort uni_numb: gen fi_and_cash=all_fi+cash
bysort uni_numb: egen alt_assets=total(MARKET_VALUE) if ASSET_CLASS_ID>=400 & ASSET_CLASS_ID<500
bysort uni_numb: egen all_real_estate=total(MARKET_VALUE) if ASSET_CLASS_ID>=300 & ASSET_CLASS_ID<400
bysort uni_numb: egen hedge_funds=total(MARKET_VALUE) if ASSET_CLASS_ID>=400 & ASSET_CLASS_ID<500 & ASSET_CLASS_ID!=402 & ASSET_CLASS_ID!=403
bysort uni_numb: egen vc=total(MARKET_VALUE) if ASSET_CLASS_ID==402
bysort uni_numb: egen private_equity=total(MARKET_VALUE) if ASSET_CLASS_ID==403
bysort uni_numb: egen oil_gas=total(MARKET_VALUE) if ASSET_CLASS_ID==405
bysort uni_numb: egen commodity=total(MARKET_VALUE) if ASSET_CLASS_ID==404 | ASSET_CLASS_ID==406 | ASSET_CLASS_ID==407


local asset_class all_equity all_fi cash fi_and_cash alt_assets all_real_estate hedge_funds vc private_equity oil_gas commodity

foreach var of local asset_class{
	replace `var'=`var'/size2003
}

keep uni_numb size2003 all_equity fi_and_cash alt_assets all_real_estate hedge_funds vc private_equity
duplicates drop uni_numb, force

sort uni_numb
save NACUBO.dta, clear

merge 1:1 uni_numb using NACUBO_RET.dta, keepusing(nacubo_stdev) keep(match master) nogen

save NACUBO.dta, clear





