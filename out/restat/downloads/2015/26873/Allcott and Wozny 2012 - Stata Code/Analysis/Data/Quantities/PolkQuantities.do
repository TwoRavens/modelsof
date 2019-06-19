# delimit ;

/********************************************************
PolkQuantities.do
Nathan Wozny 8/26/09
Match Polk Quantities to Polk prefix file.
I don't know of a place where PolkDataPrep.do is still needed,
but the most relevant changes made are included here.
********************************************************/

capture log close;
log using PolkQuantities.log, replace;

clear all;
set mem 500m;
set more off;

/* First load the 1998-2002 data */
insheet using NVPP_0798_0702.csv, comma names;
keep vinkey reg*;
rename vinkey MatchVin810;
replace MatchVin810 = MatchVin810 + "*******";
* We do not have VINs for 1998.  It may be possible to match by name, but let's drop these registration quantities.;
drop reg1998;
forvalues yr=1999/2002 {;
    rename reg`yr' Quantity`yr';
};
collapse (sum) Quantity*, by(MatchVin810);
sort MatchVin810;
tempfile quant9902;
save `quant9902';

clear all;
insheet using NVPP_0703_0708_VIN.csv, comma names;

drop id;
rename vinkey MatchVin810;
replace MatchVin810 = MatchVin810 + "*******";
forvalues yr=2003/2008 {;
    rename reg`yr' Quantity`yr';
};

sort MatchVin810;
merge MatchVin810 using `quant9902', unique;
tab _merge;
drop _merge;

forvalues yr=1999/2008 {;
    replace Quantity`yr' = 0 if Quantity`yr'==.;
};

sort MatchVin810;
merge MatchVin810 using ../Matchups/Prefix810, unique keep(CarID ModelYear);
tab _merge;

* Diagnostics;
/* How do quantities in matched vs not matched NVPP records compare?
   Quantities are smaller in unmatched records. */
sum Quantity1999 Quantity2003 if _merge==1, d;
sum Quantity1999 Quantity2003 if _merge==3, d;
/* How does ModelYear compare in matched vs not matched Prefix
   records compare?  About the same. */
tab ModelYear _merge;
/* Sum quantities we lose by dropping unmatched records. */
sort _merge;
forvalues yr=1999/2008 {;
    by _merge: egen TotalQ`yr'=total(Quantity`yr');
};
by _merge: gen firstrec=(_n==1);
list _merge TotalQ* if firstrec & _merge~=2;
keep if _merge==3;
drop _merge TotalQ* firstrec;

* Reshape and collapse to CarID level;
reshape long Quantity, i(MatchVin810 ModelYear) j(Year);

/* Fix quantities for Age<=0 */
sort MatchVin810 ModelYear Year;
by MatchVin810 ModelYear: replace Quantity = Quantity[_n+1] if ModelYear==Year & Quantity[_n+1]~=.;
/* Most (90%) quantities are set to 0 for Year<ModelYear.  Even if it's not, we probably don't trust this
   number very well. */
replace Quantity = . if Year<ModelYear;

/* Diagnostic: check for anomalous movements in quantities. */
/* We could fix these anomalous movements, but they don't seem to be a big issue, so
   leave them as is for now. */
sort MatchVin810 ModelYear Year;
by MatchVin810 ModelYear: gen DeltaQ = Quantity-Quantity[_n-1];
gen PctDeltaQ = DeltaQ/Quantity;
gen BigIncrease = (DeltaQ>100 & PctDeltaQ>.1 & DeltaQ<.);
gen BigDecrease = (DeltaQ<-1000 & PctDeltaQ<-.8);
tab BigIncrease;
tab BigDecrease;

collapse (sum) Quantity, by(CarID ModelYear Year);
drop if Year<ModelYear;

/* Save temporarily file that will later be called by CalcSurvProb.do */
save SurvivalProbabilityData.dta,replace;


/* Turn into a monthly file */
gen Month=.;
tempfile AnnualData;
save `AnnualData';
forvalues month=1/11 {;
    replace Month = `month' if Month==.;
    append using `AnnualData';
};
replace Month = 12 if Month==.;

/* Create a smoothed version */
gen AdjQuantity=Quantity;
sort CarID ModelYear Year Month;
by CarID ModelYear: gen QNextYr=Quantity[_n+12];

* The registration figures are for July 1. This likely reflects the quantity in use as of January 1.;
* So to generate the smoothed version, move linearly from July 1 Y registrations on Jan 1 Y to 1/12* July 1 Y + 11/12 * July 1 Y+1 registrations on Dec 1;
forvalues mo = 2/12 {;
	replace AdjQuantity = round( (`mo'-1)/12 * QNextYr + (13-`mo')/12 * Quantity) if Month==`mo' & QNextYr!=.;
};

drop QNextYr;

/* Merge names.  We can also wait and do this in DataPrep.do */
/*
sort CarID ModelYear;
merge CarID ModelYear using ../Matchups/IDToNames, nokeep uniqusing;
drop _merge;
*/

gen byte InPolk=1;

sort CarID ModelYear Year Month;
saveold PolkQuantities, replace;

set more on;
log close;
