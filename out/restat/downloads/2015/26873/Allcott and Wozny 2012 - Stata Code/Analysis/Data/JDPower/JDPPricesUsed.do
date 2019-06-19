# delimit ;

/********************************************************
JDPPricesUsed.do
Nathan Wozny 3/13/10
Match Used data JDPower Squished VIN to Polk prefix file.
********************************************************/

capture log close;
log using JDPPricesUsed.log, replace;

clear all;
capture set mem 2000m;
set more off;

insheet using jdpowerused.txt, names;
* We only have up to 2008 in Polk quantities and prefix file.;
keep if sls_veh_model_year<=2008;

* Compute the mean loan APR (nominal);
destring finance_apr, ignore("(null)") gen(apr);
sum finance_apr [aw=transaction_count] if transaction_type=="Finance" & finance_apr~="(null)";
sum transaction_count;

gen MatchVin810 = substr(sls_veh_squished_vin,1,8)+"*"+substr(sls_veh_squished_vin,9,1)+"*******";

/* Fix a few vehicles that appear to have incorrect VINs.  More manual matching is possible. */
* 2002 Ford Windstar;
*replace MatchVin810 = "2FMDA524*2*******" if MatchVin810=="2FMZA574*2*******";
* 2003 Ford Windstar;
*replace MatchVin810 = "2FMDA524*3*******" if MatchVin810=="2FMZA574*3*******";
* 2004 Toyota Sienna;
*replace MatchVin810 = "5TDZA23C*4*******" if MatchVin810=="5TDZA29C*4*******";

sort MatchVin810;
merge MatchVin810 using ../Matchups/Prefix810;
tab _merge;
bysort MatchVin810: gen FirstRec=(_n==1);
tab _merge if FirstRec;

/* JD Power vehicles not in the Polk Prefix */
tab sls_veh_model_year if _merge==1;
tab sls_veh_make_name if _merge==1;
tab sls_veh_fuel_type if _merge==1;
tab sls_veh_transmission_type if _merge==1;

/* I took a closer look at the above vehicles.  My best guess is that the VINs are incorrect in JD Power.
   These VINs are associated with disproportionately few transactions, which is good for us because we are
   losing less data, but it also suggests that it is more likely to be a typographical error in the VIN. */

/* Polk Prefix vehicles not in JD Power */
tab ModelYear if _merge==2;
tab Make if _merge==2;
tab FuelType if _merge==2;

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
drop _merge;

gen int Year = real(substr(close_month_yyyy_mm,1,4));
gen int Month = real(substr(close_month_yyyy_mm,6,2));
assert Year>=1999 & Year<=2010;
assert Month>=1 & Month<=12;

gen byte PctCash=(transaction_type=="Cash");
gen byte PctFinance=(transaction_type=="Finance");
gen byte PctLease=(transaction_type=="Lease");

foreach var in vehicle_price vehiclepricelessccr days_to_turn customercashrebatepvr  ccrebatepenetration veh_odometer finance_apr lease_apr term amountfinanced_netcap_nonpvr trade_in_oa_ua_pvr {;
    destring `var', replace force;
};

bysort CarID ModelYear Year Month: egen JDPUsedSales=total(transaction_count);
collapse (mean) PctCash PctFinance PctLease vehicle_price vehiclepricelessccr days_to_turn customercashrebatepvr  ccrebatepenetration veh_odometer finance_apr lease_apr term amountfinanced_netcap_nonpvr trade_in_oa_ua_pvr JDPUsedSales [aw=transaction_count], by(CarID ModelYear Year Month);
rename vehiclepricelessccr JDPUsedPrice;

/* Adjust for inflation */
sort Year Month;
merge Year Month using ../CPI/MonthlyCPI.dta, keep(CPIDeflator) nokeep;
replace JDPUsedPrice = JDPUsedPrice*CPIDeflator;
* CPIDeflator does not have recent months.  Delete these until the deflator is updated.;
drop if _merge==1;
*assert _merge==3;
drop CPIDeflator _merge;

/* Delete next line to keep extra variables (e.g. financing info) */
keep CarID ModelYear Year Month JDPUsedPrice JDPUsedSales veh_odometer trade_in_oa_ua_pvr vehicle_price customercashrebatepvr;

/* Try a seasonal adjustment, and limit dataset to years when auction prices are not available */
*keep if Year-ModelYear==0 | Year-ModelYear==-1;
gen lnPrice = ln(JDPUsedPrice);
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
gen JDPAdjUsedPrice = exp(lnAdjPrice);
drop _I* lnAdjPrice lnPrice;
gen Age = Year - ModelYear;

gen InUsedJDP=1;
sort CarID ModelYear Year Month;

saveold JDPUsedPrices, replace;

set more on;
