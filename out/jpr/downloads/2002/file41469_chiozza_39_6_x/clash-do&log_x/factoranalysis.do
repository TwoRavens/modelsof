#delimit ;
clear;
set mem 32m;
set more off;

use "C:\My Documents\ps299\paper4\data\factor.dta";

log using "C:\My Documents\ps299\paper4\log\factor.log", replace;

factor logen urb peduc radio, factors(1);

score mod;

impute mod logen urb peduc radio, gen(imod);

egen max=max(imod);
egen min=min(imod);

gen mmod=(imod-min)/(-min+max);

sum mod mmod;

log close;

drop max min;

sort ccode year;
describe;

save "C:\My Documents\ps299\paper4\data\factormod.dta", replace;
