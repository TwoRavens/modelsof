#delimit;
clear;
set maxvar 17000;





********  NATIONAL  **********;

**1)scramble five year bundles of data;
use year  nipadgdp_neg  nipadgdp recsty  nipadgdp_nsq2 fips recmonth using "$startdir\$outputdata\alleconconds", clear;
collapse recmonth nipadgdp_neg  nipadgdp recsty  nipadgdp_nsq2, by(year);
replace recmonth=recmonth/12;
replace nipadgdp=nipadgdp/100;
replace nipadgdp_nsq2=nipadgdp_nsq2/10000;
sort year;

if "$bootstrap"=="BS"{;
gen actualyear=year;
gen fiveyearblock=round( (year-1908)/5);
drop if fiveyearblock<1 | fiveyearblock==20;
sort fiveyearblock year;
by fiveyearblock: gen blockscramble=runiform() if _n==1;
by fiveyearblock: replace blockscramble=blockscramble[_n-1] if blockscramble[_n-1]<.;
sort blockscramble actualyear;
replace year=1910+_n;
sort year;
};


**2) expand for merge with natcohorts;
rename year trueyear;
sort trueyear;
expand 7;
egen CY=seq(), by (trueyear);
replace CY=1950 if CY==1;
replace CY=1960 if CY==2;
replace CY=1970 if CY==3;
replace CY=1980 if CY==4;
replace CY=1990 if CY==5;
replace CY=2000 if CY==6;
replace CY=2005 if CY==7;
gen yearsago=CY-trueyear;
drop if yearsago<0; 
drop if yearsago>35;
gen rho1adjust=1^(2*yearsago);
gen rho98adjust=.98^(2*yearsago);
gen rho95adjust=.95^(2*yearsago);
gen rho90adjust=.9^(2*yearsago);
rename CY year;
sort trueyear year;
save "$startdir/$outputdata/THIStempd", replace;
use A C Ninc varloginc p*loginc year  using "$startdir\$outputdata\natcohorts_fweightyes.dta", clear;
joinby year using "$startdir/$outputdata/THIStempd", unmatched(master);
gen inityear=year-A*5;
foreach var of varlist recsty nipadgdp_neg recmonth nipadgdp nipadgdp_nsq2{;
gen rho1`var'=rho1adjust*`var';
gen rho98`var'=rho98adjust*`var';
gen rho95`var'=rho95adjust*`var';
gen rho90`var'=rho90adjust*`var';
sort C year;
by C year: egen rho1cumsum`var'=total(rho1`var') if trueyear>inityear; 
by C year: egen rho98cumsum`var'=total(rho98`var') if trueyear>inityear; 
by C year: egen rho95cumsum`var'=total(rho95`var') if trueyear>inityear; 
by C year: egen rho90cumsum`var'=total(rho90`var') if trueyear>inityear; 
};
collapse  rho*cumsum*  Ninc varloginc, by (A C year);
gen insample=1;

