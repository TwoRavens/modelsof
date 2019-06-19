# delimit ;

/********************************************************
JDPPrices.do
Nathan Wozny 8/26/09
Match JDPower Squished VIN to Polk prefix file.
********************************************************/

capture log close;
log using JDPPrices.log, replace;

clear all;
set mem 900m;
set more off;

insheet using jdpower.txt, names;
* We only have up to 2008 in Polk quantities and prefix file.;
keep if sls_veh_model_year<=2008;

* Compute the mean loan APR;
destring finance_apr, ignore("(null)") gen(apr);
sum finance_apr [aw=transaction_count] if transaction_type=="Finance" & finance_apr~="(null)";

gen MatchVin810 = substr(sls_veh_squished_vin,1,8)+"*"+substr(sls_veh_squished_vin,9,1)+"*******";

/* Fix a few vehicles that appear to have incorrect VINs.  More manual matching is possible. */
* 2002 Ford Windstar;
replace MatchVin810 = "2FMDA524*2*******" if MatchVin810=="2FMZA574*2*******";
* 2003 Ford Windstar;
replace MatchVin810 = "2FMDA524*3*******" if MatchVin810=="2FMZA574*3*******";
* 2004 Toyota Sienna;
replace MatchVin810 = "5TDZA23C*4*******" if MatchVin810=="5TDZA29C*4*******";

sort MatchVin810;
merge MatchVin810 using ../Matchups/Prefix810;
* JDPower Data starts in 1999;
tab _merge if ModelYear>=1999;
bysort MatchVin810: gen FirstRec=(_n==1);
tab _merge if FirstRec & ModelYear>=1999;

/* JD Power vehicles not in the Polk Prefix */
tab sls_veh_model_year if _merge==1;
tab sls_veh_make_name if _merge==1;
tab sls_veh_fuel_type if _merge==1;
tab sls_veh_transmission_type if _merge==1;

/* I took a closer look at the above vehicles.  My best guess is that the VINs are incorrect in JD Power.
   These VINs are associated with disproportionately few transactions, which is good for us because we are
   losing less data, but it also suggests that it is more likely to be a typographical error in the VIN. */

/* Polk Prefix vehicles not in JD Power */
tab ModelYear if _merge==2 & ModelYear>=1999;
tab Make if _merge==2 & ModelYear>=1999;
tab FuelType if _merge==2 & ModelYear>=1999;

/* Consistency test */
tab ModelYear sls_veh_model_year;
tab sls_veh_make_name if Make=="Toyota";
tab Make if sls_veh_make_name=="Toyota";
tab sls_veh_make_name if Make=="Ford";
tab Make if sls_veh_make_name=="Ford";
tab sls_veh_model_name if Make=="Ford" & Model=="Explorer";
tab Model if sls_veh_make_name=="Ford" & sls_veh_model_name=="Explorer";
destring sls_veh_displacement, gen(JDPLiters) ignore("LN/A");
gen DiffLiters = Liters - JDPLiters;
tab DiffLiters;

keep if _merge==3;

gen int Year = real(substr(close_month_yyyy_mm,1,4));
gen int Month = real(substr(close_month_yyyy_mm,6,2));
assert Year>=1999 & Year<=2009;
assert Month>=1 & Month<=12;

gen byte PctCash=(transaction_type=="Cash");
gen byte PctFinance=(transaction_type=="Finance");
gen byte PctLease=(transaction_type=="Lease");

foreach var in vehicle_price customer_cash_rebate vehiclepricelessccr finance_apr lease_apr term amountfinanced_netcap trade_in_oa_ua {;
    destring `var', replace force;
};

bysort CarID ModelYear Year Month: egen JDPSales=total(transaction_count);
collapse (mean) PctCash PctFinance PctLease vehicle_price customer_cash_rebate vehiclepricelessccr finance_apr lease_apr term amountfinanced_netcap trade_in_oa_ua JDPSales [aw=transaction_count], by(CarID ModelYear Year Month);
rename vehiclepricelessccr JDPPrice;

/* Adjust for inflation */
sort Year Month;
merge Year Month using ../CPI/MonthlyCPI.dta, keep(CPIDeflator) nokeep;
replace JDPPrice = JDPPrice*CPIDeflator;
assert _merge==3;
drop CPIDeflator _merge;

/* Delete next line to keep extra variables (e.g. financing info) */
keep CarID ModelYear Year Month JDPPrice JDPSales;

/* Try a seasonal adjustment, and limit dataset to years when auction prices are not available */
*keep if Year-ModelYear==0 | Year-ModelYear==-1;
gen lnPrice = ln(JDPPrice);
egen FEGroup = group(CarID ModelYear Year);
xtset FEGroup;
char Month [omit] 7;
xi: xtreg lnPrice i.Month, fe;
gen lnAdjPrice = lnPrice;
* Subtract off monthly effects;
forvalues i=1/12 {;
    if `i'~=7 replace lnAdjPrice = lnAdjPrice - _b[_IMonth_`i']*_IMonth_`i';
};
replace lnAdjPrice = lnAdjPrice;
gen JDPAdjPrice = exp(lnAdjPrice);
drop _I* lnAdjPrice lnPrice;

gen InJDP=1;
sort CarID ModelYear Year Month;

saveold JDPPrices, replace;

set more on;
