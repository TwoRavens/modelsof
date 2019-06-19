clear 
set more off
set mem 150m

*version 9.1
#delimit;

local basepath "C:\Jirka\Research\g7expectations\g7expectations\";

cd "`basepath'stata/dataManagement";

local Ccodes cn fr ge it jp uk us;
local variable gdp cons infl inv ip r3m un;

local Numbers "33 40 46 35 44 61 60";
local maxnum 61;

foreach var of local variable {;

	*------------------------------------------------------------------------;
	* LOAD DATA (IN WIDE FORMAT);
	
	use "`basepath'Data/detailed/__`var'.dta", clear;

	*------------------------------------------------------------------------;
	* FILL UP NUMBER OF PANELISTS;

	local i = 1;
	foreach C of local Ccodes {;
		local N: word `i' of `Numbers';
		local ++i;
		local N = `N'+1;
		forvalues n = `N'/`maxnum' {;
			qui gen `C'`var'`n'0 = .;
			qui gen `C'`var'`n'1 = .;
		};
	};


	*------------------------------------------------------------------------;
	* RENAME TIME SERIES;

	foreach C of local Ccodes {;
		forvalues n = 5/`maxnum' {;
			rename `C'`var'`n'0 `C'0`var'`n';
			rename `C'`var'`n'1 `C'1`var'`n';
		};
	};

	*------------------------------------------------------------------------;
	* RESHAPE DATA SET;

	local varlist "";
	foreach C of local Ccodes {;
		local varlist "`varlist' `C'0`var' `C'1`var'"; 
	};

	reshape long `varlist', i(index);

	rename _j id;
	rename index time;
	replace time = time + 347;
	tsset id time, monthly;
	sort time id;

	*------------------------------------------------------------------------;
	* Calculate the interquartile range;

	foreach C of local Ccodes {;
		gen `C'4Q`var' = ( (13-month)*`C'0`var' + (month-1)*`C'1`var' )/12;
		if "`var'"=="r3m" {; 	* Interest rate is different (fixed horizon);
			replace `C'4Q`var'=`C'1`var'; 
		};

		by time: egen `C'`var'iqr4Q = iqr(`C'4Q`var');
		drop `C'4Q`var';
	};

	*------------------------------------------------------------------------;
	* SAVE DATA (IN STACKED FORMAT AND WITH CF-STATS);
	sort year month;
	drop if year==.;
	save "`basepath'Data/detailed/___`var'Stacked.dta", replace;
	
	
	*************************************************************************;
	* Save the dataset with aggregate variables (like IQR) in wide form (de-stack);
	drop cn0`var' cn1`var' fr0`var' fr1`var' ge0`var' ge1`var' it0`var' it1`var' jp0`var' jp1`var' uk0`var' uk1`var' us0`var' us1`var';
	drop *CF*;

	local varlist "";
	foreach C of local Ccodes {;
		local varlist "`varlist' `C'`var'iqr4Q"; 
		 
	};
	
	reshape wide `varlist', i(time) j(id);
	foreach C of local Ccodes {;
		rename `C'`var'iqr4Q5 `C'`var'iqr; 
		drop `C'`var'iqr4Q*;
		
		rename `C'`var'high4Q `C'`var'high; 
		rename `C'`var'low4Q `C'`var'low; 
		rename `C'`var'mean4Q `C'`var'mean; 
		rename `C'`var'median4Q `C'`var'median; 
		rename `C'`var'nobs4Q `C'`var'nobs; 
		rename `C'`var'stdev4Q `C'`var'stdev; 
		
		 };
	sort year month;

	save "`basepath'Data/detailed/___`var'Aggr.dta", replace;

};

*****************************************************************************************;
* Merge aggregate disagreement data with macro variables;

insheet using "`basepath'Data/ucsvData.txt", tab clear;
sort year month;
save "`basepath'Data/ucsvData.dta", replace;

use "`basepath'Data/Macro-Variables_Extended.dta", clear;
sort year month;

foreach var of local variable{;
	merge year month using "`basepath'Data/detailed/___`var'Aggr.dta", _merge(_merge);
	drop _merge;
	sort year month;
};

merge year month using "`basepath'Data/ucsvData.dta", _merge(_merge);
drop _merge;
sort year month;

order date year month;
drop if year==.;
save "`basepath'Data/disagreementAggr.dta", replace;

clear;
