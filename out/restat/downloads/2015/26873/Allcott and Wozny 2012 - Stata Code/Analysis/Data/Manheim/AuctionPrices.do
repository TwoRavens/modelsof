# delimit ;

/*****************************************************************************
AuctionPrices.do
Nathan Wozny 8/17/09
Load the Manheim auction data, check for and drop invalid VINs, merge with the
Polk prefix file, and collapse to the "jat" level (by CarID, as defined in
MakeVinPrefix.do *ModelYear*Year*Month).

******************************************************************************/

capture log close;
log using AuctionPrices.log, replace;

clear all;
set mem 14g;
set more off;

/* SKIP THIS PART IF DATA DOES NOT NEED TO BE REMATCHED */
/* */
/* Load 2002-2009 data first. */

use manheim;
rename sser17 vin;

* Drop obviously incorrect observations;
drop if sslepr<=0;
drop if dmbuyfeet<0;

* There are region IDs that are not listed in the codebook.  Lump these into an "other" category.;
* Note this may have a small effect on region-adjusted prices.;
tab crgnid, m;
destring crgnid, gen(region);
drop crgnid;
* Create an "other" category;
replace region = 7 if region<1 | region>6;

* Keep only in-lane, simulcast, and OVE transactions;
drop if dmtrantype=="DX" | dmtrantype=="FQ";

* Adjust for buyer fees;
sum sslepr dmsellfee dmbuyfeet;
replace sslepr = sslepr + dmbuyfeet;
drop dmsellfee dmbuyfeet;

* Check VINs for errors;
include CheckVin;
* Match to Polk prefix file;
include MatchVin;

gen Year = floor(dmstdesl/10000);
gen Month = floor((dmstdesl-10000*Year)/100);
drop dmstdesl;
gen Age = Year - ModelYear;
drop if Age<=0;
rename smiles Miles;
gen Miles2 = Miles^2;
gen AgeMiles = Age*Miles;

* Drop more obviously incorrect observations;
drop if Miles<0;
drop if Miles<=10 & Age>0;

/* We don't have other 2009 data, so drop this. */
drop if Year>=2009;

/* We can't drop vehicles with scrap value only, since we don't know which vehicles these are for
   the older (98-01) data.  Instead, let's see how condition (and other covariates) change over the
   time period for which we do have them. */
foreach var in dmcondtn dmtrantype region dmclosed {;
    tab Year `var', m row;
};

drop dmmake dmmodel dmbody dmjdcat dmcat;

saveold MatchedVin, replace;

/* Repeat with 1998-2001 data */

use manheim9802, clear;
rename sser17 vin;
rename scaryr dmmodelyr;
rename sdtesl dmstdesl;

* Drop obviously incorrect observations;
drop if sslepr<=0;
drop if sbuyfe<0;

* Adjust for buyer fees;
sum sslepr sselfe sbuyfe;
replace sslepr = sslepr + sbuyfe;
drop sselfe sbuyfe;

* Check VINs for errors;
include CheckVin;
* Match to Polk prefix file;
include MatchVin;

gen Year = floor(dmstdesl/10000);
tab Year;
* drop some incorrect years, and those with very little data;
drop if Year<1995 | Year>2001;
gen Month = floor((dmstdesl-10000*Year)/100);
drop dmstdesl;
gen Age = Year - ModelYear;
drop if Age<=0;
rename smiles Miles;
gen Miles2 = Miles^2;
gen AgeMiles = Age*Miles;

* Drop more obviously incorrect observations;
drop if Miles<0;
drop if Miles<=10 & Age>0;

drop smake smodel schgs;

append using MatchedVin;

/* Simulcast and OVE (online) bidding did not begin until 2005, so assume all transactions with
   missing type were in-lane before then. */
replace dmtrantype = "LNE" if dmtrantype=="" & Year<=2004;
assert dmtrantype~="";

compress;
saveold MatchedVin, replace;

*/
/* START HERE IF DATA DOES NOT NEED TO BE REMATCHED */
use MatchedVin, clear;

/* Define fixed effect for our price regression*/
egen long FEGroup = group(CarID ModelYear Year Month);
sort FEGroup;
by FEGroup: gen ManheimObs = _N;
by FEGroup: gen firstrec = (_n==1);
/* Diagnostic */
sum ManheimObs if firstrec, d;

/* Adjust for inflation */
sort Year Month;
merge Year Month using ../CPI/MonthlyCPI.dta, nokeep keep(CPIDeflator);
assert _merge==3;
drop _merge;
replace sslepr = sslepr*CPIDeflator;
drop CPIDeflator;

sort FEGroup;
by FEGroup: egen MeanPrice = mean(sslepr);
gen lnPrice = ln(sslepr);
by FEGroup: egen PriceSD = sd(sslepr);
by FEGroup: egen lnPriceSD = sd(lnPrice);

/* Set defaults so we don't have to make adjustments later. */
* Condition = good;
char dmcondtn [omit] "3";
* Transaction type = Lane;
char dmtrantype [omit] "LNE";
* Region = Midwest;
char region [omit] 4;
* Closed transaction = No;
char dmclosed [omit] "N";
* Month = July (only for second regression to predict annual prices);
char Month [omit] 7;

/* Generate dummies and fill in missing values with means. */
xi i.dmcond i.dmtrantype i.region i.dmclosed i.Month;

foreach var of varlist _Idmcondtn_* _Iregion_* _Idmclosed_* {;
    qui sum `var';
    replace `var' = r(mean) if `var'==.;
};

drop dmcond dmtrantype region dmclosed;
capture drop schgs;
drop if Year<1998;

/* Perform regression to predict monthly prices */
xtset FEGroup;
xtreg lnPrice Miles Miles2 AgeMiles _Idmcondtn_* _Idmtrantyp_* _Iregion_* _Idmclosed_*, fe;
est store YearMonthFE;

/* Need to do this to predict prices later. */
egen lnPredPrice = mean(lnPrice), by(FEGroup);
foreach var of varlist Miles Miles2 AgeMiles _Idmcondtn_* _Idmtrantyp_* _Iregion_* _Idmclosed_* {;
    egen Mean`var' = mean(`var'), by(FEGroup);
    replace lnPredPrice = lnPredPrice - Mean`var'*_b[`var'];
    if "`var'"~="Miles" drop Mean`var';
};

/* Do a separate estimation for annual prices */
egen long FEGroupAnn = group(CarID ModelYear Year);
sort FEGroupAnn;
by FEGroupAnn: gen AnnManheimObs = _N;
egen AnnMeanPrice = mean(sslepr), by(FEGroup);

xtset FEGroupAnn;
xtreg lnPrice Miles Miles2 AgeMiles _I*, fe;
est store YearFE;
egen AnnlnPredPrice = mean(lnPrice), by(FEGroupAnn);
foreach var of varlist Miles Miles2 AgeMiles _I* {;
    egen AnnMean`var' = mean(`var'), by(FEGroupAnn);
    replace AnnlnPredPrice = AnnlnPredPrice - AnnMean`var'*_b[`var'];
    drop AnnMean`var';
};

/* Go to one record per CarID*ModelYear*Year*Month and complete predictions, first for annual prices. */
keep if firstrec;
drop FEGroup FEGroupAnn;

/* Predict Miles (odometer reading) from NHTS data */
estimates use ../NHTS/OdometerEstimates.ster;
forvalues e = 1/5 {;
    gen Age_`e' = Age^`e';
};
sort CarID ModelYear;
merge CarID ModelYear using ../EPAMPG/EPAByID, nokeep keep(VClass GPMA);
tab _merge;
drop _merge;
rename GPMA GPM;
gen NHTSClass = 0;
replace NHTSClass = 1 if VClass<6;
replace NHTSClass = 7 if VClass==7;
replace NHTSClass = 8 if VClass==8;
replace NHTSClass = 910 if VClass==9 | VClass==10;
* Class dummies;
xi i.NHTSClass, pre(_C);
drop Miles;
predict Miles;
drop VClass NHTSClass _C* GPM;

replace Miles2 = Miles^2;
replace AgeMiles = Age*Miles;

/* out of sample prediction using Stata's predict doesn't work here, so
   do the prediction manually. */
est restore YearFE;
foreach var of varlist Miles Miles2 AgeMiles {;
    replace AnnlnPredPrice = AnnlnPredPrice + `var'*_b[`var'];
};

/* Restore monthly estimates and predict prices */
est restore YearMonthFE;
foreach var of varlist Miles Miles2 AgeMiles {;
    replace lnPredPrice = lnPredPrice + `var'*_b[`var'];
};

/* Seasonal adjustment */
* Adjust to July (month==7);
char Month [omit] 7;
egen FEGroup = group(CarID ModelYear Year);
xtset FEGroup;
xi: xtreg lnPredPrice i.Month*Age, fe;
gen lnAdjPrice = lnPredPrice;
* Subtract off monthly effects;
forvalues i=1/12 {;
    if `i'~=7 replace lnAdjPrice = lnAdjPrice - _b[_IMonth_`i']*_IMonth_`i' - _b[_IMonXAge_`i']*_IMonth_`i'*Age;
};

gen AnnPredPrice = exp(AnnlnPredPrice);
gen PredPrice = exp(lnPredPrice);
gen AdjPrice = exp(lnAdjPrice);

keep CarID ModelYear Year Month PredPrice AdjPrice MeanPrice PriceSD lnPriceSD MeanMiles ManheimObs AnnPredPrice AnnMeanPrice AnnManheimObs;
gen InManheim=1;
sort CarID ModelYear Year Month;

saveold AuctionPrices, replace;

set more on;
log close;
