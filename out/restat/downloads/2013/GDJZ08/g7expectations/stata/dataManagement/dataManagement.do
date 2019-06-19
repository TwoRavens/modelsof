clear 
set more off
set mem 150m

*version 9.1
#delimit;
adopath + C:\ado\egenodd;


*cd "`basepath'stata";
local basepath "C:\Jirka\Research\g7expectations\g7expectations\";

cd "`basepath'stata/dataManagement";

local Ccodes cn fr ge it jp uk us;
local variable gdp cons infl inv ip ir un;
local Numbers "33 40 46 35 44 61 60";  * MAKE SURE THE ORDER CORRESPONDS TO THE ORDER OF COUNTRIES!;
local maxnum 61;

*----------- Umwandeln der *.txt in *.dta Dateien ------------;


foreach c of local Ccodes {;
	foreach var of local variable {;
		infile using "`basepath'data/detailed/_`c'`var'.txt", clear;
		save "`basepath'data/detailed/_`c'`var'.dta", replace;
	};
};

clear;

* Rename ir to r3m;
local i = 1;
foreach c of local Ccodes {;	
	use "`basepath'data/detailed/_`c'ir.dta", clear;
		local N: word `i' of `Numbers';
		local ++i;
		forvalues n = 1/`N' {;
			forvalues y = 0/1 {;
				rename `c'ir`n'`y' `c'r3m`n'`y';
			};
		};
	save "`basepath'data/detailed/_`c'r3m.dta", replace;
	clear;
};
	
local variable gdp cons infl inv ip r3m un;


* ---------------- CREATING TIMING VARIABLES ---------------*;


* ---------------------- Reading data ----------------------*;

foreach c of local Ccodes{;
	foreach var of local variable {;
		use "`basepath'data/detailed/_`c'`var'.dta", clear;
		gen index =_n;
		gen year = Year;
		drop Year;
		forvalues t = 89/99 {;
			qui replace year = year+1900 if year==`t';
		};	
		forvalues t = 0/9 {;
		qui replace year = year+2000 if year==`t';
		};
	
		qui gen date = Month+" "+string(year);
		drop Month;
		qui gen month = mod(index,12); replace month = 12 if month==0;
		sort index year;
		save "`basepath'Data/detailed/_`c'`var'.dta", replace;
		clear; 
	};
};

clear;

****************************************************************************;

* How do we treat single missing values? Interpolate with surrounding values?;
*-----------------------------------------------------------------------;
* INTERPOLATING MISSING VALUES;  

local i = 1;
foreach c of local Ccodes {;
	local N: word `i' of `Numbers';
	local ++i;

	foreach var of local variable {;
		use "`basepath'data/detailed/_`c'`var'.dta", clear;
		sort year month;

		* First, only interpolating within a year;
		forvalues n = 5/`N' {;
			forvalues y = 0/1 {;
				by year: ipolate `c'`var'`n'`y' month, gen(ip_`c'`var'`n'`y');
				
				gen `c'`var'`n'`y'_ipFlag=0;		* generate a flag variable which indicates if observation is original  [0] or has been interpolated within a year [1], extrapolated at the beginning of the year [2] or at the end of the year [3], or missing [-1];
				qui replace `c'`var'`n'`y'_ipFlag=1 if (`c'`var'`n'`y'==.)&(ip_`c'`var'`n'`y'~=.);

			};
		};

		* Second, extrapolating at the beginning of the year if not more than two months of data are missing;
		forvalues n = 5/`N' {;
			forvalues y = 0/1 {;
				qui replace ip_`c'`var'`n'`y' = ip_`c'`var'`n'`y'[_n+1] if (month==1)&(`c'`var'`n'`y'==.)&(`c'`var'`n'`y'[_n+1]!=.);
				qui replace ip_`c'`var'`n'`y' = ip_`c'`var'`n'`y'[_n+2] if (month==1)&(`c'`var'`n'`y'==.)&(`c'`var'`n'`y'[_n+1]==.)&(`c'`var'`n'`y'[_n+2]!=.);
				qui replace ip_`c'`var'`n'`y' = ip_`c'`var'`n'`y'[_n+1] if (month==2)&(`c'`var'`n'`y'[_n-1]==.)&(`c'`var'`n'`y'[_n]==.)&(`c'`var'`n'`y'[_n+1]!=.);

				qui replace `c'`var'`n'`y'_ipFlag=2 if (month==1)&(`c'`var'`n'`y'==.)&(`c'`var'`n'`y'[_n+1]!=.);
				qui replace `c'`var'`n'`y'_ipFlag=2 if (month==1)&(`c'`var'`n'`y'==.)&(`c'`var'`n'`y'[_n+1]==.)&(`c'`var'`n'`y'[_n+2]!=.);
				qui replace `c'`var'`n'`y'_ipFlag=2 if (month==2)&(`c'`var'`n'`y'[_n-1]==.)&(`c'`var'`n'`y'[_n]==.)&(`c'`var'`n'`y'[_n+1]!=.);

			};
		};

		* Third, extrapolating at the end of the year if not more than two months of data are missing;
		forvalues n = 5/`N' {;
			forvalues y = 0/1 {;
				qui replace ip_`c'`var'`n'`y' = ip_`c'`var'`n'`y'[_n-1] if (month==12)&(`c'`var'`n'`y'==.)&(`c'`var'`n'`y'[_n-1]!=.);
				qui replace ip_`c'`var'`n'`y' = ip_`c'`var'`n'`y'[_n-2] if (month==12)&(`c'`var'`n'`y'==.)&(`c'`var'`n'`y'[_n-1]==.)&(`c'`var'`n'`y'[_n-2]!=.);
				qui replace ip_`c'`var'`n'`y' = ip_`c'`var'`n'`y'[_n-1] if (month==11)&(`c'`var'`n'`y'[_n+1]==.)&(`c'`var'`n'`y'[_n]==.)&(`c'`var'`n'`y'[_n-1]!=.);


				qui replace `c'`var'`n'`y'_ipFlag=3 if (month==12)&(`c'`var'`n'`y'==.)&(`c'`var'`n'`y'[_n-1]!=.);
				qui replace `c'`var'`n'`y'_ipFlag=3 if (month==12)&(`c'`var'`n'`y'==.)&(`c'`var'`n'`y'[_n-1]==.)&(`c'`var'`n'`y'[_n-2]!=.);
				qui replace `c'`var'`n'`y'_ipFlag=3 if (month==11)&(`c'`var'`n'`y'[_n+1]==.)&(`c'`var'`n'`y'[_n]==.)&(`c'`var'`n'`y'[_n-1]!=.);
				
				qui replace `c'`var'`n'`y'_ipFlag=-1 if ip_`c'`var'`n'`y'==.;

				drop `c'`var'`n'`y'; rename ip_`c'`var'`n'`y' `c'`var'`n'`y';
				
			};
		};

		*-----------------------------------------------------------------------;
		* CHECKING THE SIZE OF THE CROSS-SECTION DIMENSION AFTER EXTRAPOLATIONS;
/*
		forvalues y = 0/1 {;
			qui egen ip_`c'nobs`y' = robs(`c'`var'?`y' `c'`var'??`y'); 
		};
		qui egen ip_`c'nobs4Q = robs(`c'`var'4Q*);
*/;

		*-----------------------------------------------------------------------;
		* GENERATE 4Q (MOVING AVERAGE) SERIES AND STATISTICS;
		forvalues n = 5/`N' {;
			qui gen `c'`var'4Q`n' = .;
			qui replace `c'`var'4Q`n' = ( (13-month[_n])*`c'`var'`n'0 + (month[_n]-1)*`c'`var'`n'1 )/12;
			
			if "`var'"=="r3m" {; 	* Interest rate is different (fixed horizon);
				replace `c'`var'4Q`n' = `c'`var'`n'1; 
			};
		};
		
		qui egen `c'`var'mean4Q = rmean(`c'`var'4Q*);
		qui egen `c'`var'median4Q = rmed(`c'`var'4Q*);
		qui egen `c'`var'high4Q = rmax(`c'`var'4Q*);
		qui egen `c'`var'low4Q = rmin(`c'`var'4Q*);
		qui egen `c'`var'stdev4Q = rsd(`c'`var'4Q*);
		qui egen `c'`var'nobs4Q = robs(`c'`var'4Q*); 
		
		forvalues n = 5/`N' {;
			drop `c'`var'4Q`n';
		};

		save "`basepath'Data/detailed/_`c'`var'.dta", replace;
		clear; 

	};
};

clear;

*--------------- merge vorgang aus dta-files -------------*;
*----und umbenennung von mean std max- und min- wert.-----*;

foreach var of local variable{;
	gen index = _n;
	foreach c of local Ccodes {;
		merge using "`basepath'Data/detailed/_`c'`var'.dta", _merge(_merge);
		drop _merge;
		rename `c'`var'10 `c'meanCF0; 	rename `c'`var'11 `c'meanCF1;
		rename `c'`var'20 `c'highCF0; 	rename `c'`var'21 `c'highCF1;
		rename `c'`var'30 `c'lowCF0; 	rename `c'`var'31 `c'lowCF1;
		rename `c'`var'40 `c'stdevCF0; 	rename `c'`var'41 `c'stdevCF1;
	};
	order index date year month;
	drop if year==.;
	drop *_ipFlag; 	* the dataset gets big;
	save "`basepath'Data/detailed/__`var'.dta", replace;
	clear;
};

set more on;
