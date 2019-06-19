clear 
set more off
set mem 150m

*version 9.1
#delimit;
adopath + C:\ado\egenodd;


*cd "`basepath'stata";
local basepath "C:\Jirka\Research\g7expectations\g7expectations\";

cd "`basepath'stata/dataManagement";

local Ccodes cn fr ge it jp uk us ea;
local variable gdp cons infl inv ip ir un;
local Numbers "23 36 45 30 32 42 40 58";  * MAKE SURE THE ORDER CORRESPONDS TO THE ORDER OF COUNTRIES!;
local maxnum 58;

*----------- Umwandeln der *.txt in *.dta Dateien ------------;


foreach c of local Ccodes {;
	foreach var of local variable {;
		infile using "`basepath'data/dataUpdate_april15/detailed/_`c'`var'.txt", clear;
		save "`basepath'data/dataUpdate_april15/detailed/_`c'`var'.dta", replace;
	};
};

clear;

* Rename ir to r3m;
local i = 1;
foreach c of local Ccodes {;	
	use "`basepath'data/dataUpdate_april15/detailed/_`c'ir.dta", clear;
		local N: word `i' of `Numbers';
		local ++i;
		forvalues n = 1/`N' {;
			forvalues y = 0/1 {;
				rename `c'ir`n'`y' `c'r3m`n'`y';
			};
		};
	save "`basepath'data/dataUpdate_april15/detailed/_`c'r3m.dta", replace;
	clear;
};
	
local variable gdp cons infl inv ip r3m un;


* ---------------- CREATING TIMING VARIABLES ---------------*;


* ---------------------- Reading data ----------------------*;

foreach c of local Ccodes{;
	foreach var of local variable {;
		use "`basepath'data/dataUpdate_april15/detailed/_`c'`var'.dta", clear;
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
		save "`basepath'Data/dataUpdate_april15/detailed/_`c'`var'.dta", replace;
		clear; 
	};
};

clear;

****************************************************************************;

local i = 1;
foreach c of local Ccodes {;
	local N: word `i' of `Numbers';
	local ++i;

	foreach var of local variable {;
		use "`basepath'data/dataUpdate_april15/detailed/_`c'`var'.dta", clear;
		sort year month;

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

		save "`basepath'Data/dataUpdate_april15/detailed/_`c'`var'.dta", replace;
		clear; 

	};
};

clear;

*--------------- merge vorgang aus dta-files -------------*;
*----und umbenennung von mean std max- und min- wert.-----*;

foreach var of local variable{;
	gen index = _n;
	foreach c of local Ccodes {;
		merge using "`basepath'Data/dataUpdate_april15/detailed/_`c'`var'.dta", _merge(_merge);
		drop _merge;
		rename `c'`var'10 `c'meanCF0; 	rename `c'`var'11 `c'meanCF1;
		rename `c'`var'20 `c'highCF0; 	rename `c'`var'21 `c'highCF1;
		rename `c'`var'30 `c'lowCF0; 	rename `c'`var'31 `c'lowCF1;
		rename `c'`var'40 `c'stdevCF0; 	rename `c'`var'41 `c'stdevCF1;
	};
	order index date year month;
	drop if year==.;
	save "`basepath'Data/dataUpdate_april15/detailed/__`var'.dta", replace;
	clear;
};


** counterpart to "stackData.do" starts here;

foreach var of local variable {;

	*------------------------------------------------------------------------;
	* LOAD DATA (IN WIDE FORMAT);
	
	use "`basepath'Data/dataUpdate_april15/detailed/__`var'.dta", clear;

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
	replace time = time + 539;
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
	save "`basepath'Data/dataUpdate_april15/detailed/___`var'Stacked.dta", replace;
	
	
	*************************************************************************;
	* Save the dataset with aggregate variables (like IQR) in wide form (de-stack);
	drop cn0`var' cn1`var' fr0`var' fr1`var' ge0`var' ge1`var' it0`var' it1`var' jp0`var' jp1`var' uk0`var' uk1`var' us0`var' us1`var' ea0`var' ea1`var';
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

	save "`basepath'Data/dataUpdate_april15/detailed/___`var'Aggr.dta", replace;

};

local variable0 cons infl inv ip r3m un; * all vars excl GDP;
use "`basepath'Data/dataUpdate_april15/detailed/___gdpAggr.dta";

foreach var of local variable0 {;
	merge year month using "`basepath'Data/dataUpdate_april15/detailed/___`var'Aggr.dta", _merge(_merge);
	drop _merge;
	sort year month;
};

order date year month;
drop if year==.;
save "`basepath'Data/dataUpdate_april15/disagreementAggr.dta", replace;

clear;

** counterpart to "stackStacked.do" starts here;

foreach var of local variable {;

	*-----------------------------------------------------------------------;
	* READING DATA;

	* Load consensus data;
	use "`basepath'Data/dataUpdate_april15/detailed/___`var'Stacked.dta";
	sort year month;

	tsset id time;

	*-----------------------------------------------------------------------;
	* RENAME VARIABLES TO BE ABLE TO USE THE RESHAPE-COMMAND;


	*Rename CF-Variables;
	foreach c of local Ccodes {;
		local name "meanCF0 meanCF1 highCF0 highCF1 lowCF0 lowCF1 stdevCF0 stdevCF1";
		foreach N of local name {;
			rename `c'`N' `N'`c';
		};
	};

	* Rename forecast variables;
	foreach c of local Ccodes {;
		local name "`var'";
		foreach N of local name {;
			rename `c'0`N' `N'0`c';
			rename `c'1`N' `N'1`c';

			rename `c'`N'mean4Q `N'mean4Q`c';
			rename `c'`N'median4Q `N'median4Q`c';
			rename `c'`N'high4Q `N'high4Q`c';
			rename `c'`N'low4Q `N'low4Q`c';
			rename `c'`N'stdev4Q `N'stdev4Q`c';
			rename `c'`N'nobs4Q `N'nobs4Q`c';
			rename `c'`N'iqr4Q `N'iqr4Q`c';
		};
	};

	
	local varlist "`var'0 `var'1 `var'mean4Q `var'median4Q `var'high4Q `var'low4Q `var'stdev4Q `var'nobs4Q `var'iqr4Q meanCF0 meanCF1 highCF0 highCF1 lowCF0 lowCF1 stdevCF0 stdevCF1"; 

	reshape long `varlist', i(id year month) j(country cn fr ge it jp uk us ea) string;

	gen vergleich = id;

	replace id = id+100 if country=="cn";
	replace id = id+200 if country=="fr";
	replace id = id+300 if country=="ge";
	replace id = id+400 if country=="it";
	replace id = id+500 if country=="jp";
	replace id = id+600 if country=="uk";
	replace id = id+700 if country=="us";
	replace id = id+800 if country=="ea";
	replace id = -99 if id==.;
	
	sort year month country;
	save "`basepath'Data/dataUpdate_april15/___`var'_2xstacked.dta", replace;

};


* Stack aggregate data (to estimate panel;
use "`basepath'Data/dataUpdate_april15/disagreementAggr.dta";

* Rename variables;
local varlist "conshigh consiqr conslow consmean consmedian consnobs consstdev gdphigh gdpiqr gdplow gdpmean gdpmedian gdpnobs gdpstdev inflhigh infliqr infllow inflmean inflmedian inflnobs inflstdev invhigh inviqr invlow invmean invmedian invnobs invstdev iphigh ipiqr iplow ipmean ipmedian ipnobs ipstdev r3mhigh r3miqr r3mlow r3mmean r3mmedian r3mnobs r3mstdev unhigh uniqr unlow unmean unmedian unnobs unstdev"; 

foreach C of local Ccodes {;
	foreach N of local varlist {;
		rename `C'`N' `N'`C';
		};
};

reshape long `varlist', i(year month) j(country cn fr ge it jp uk us ea) string;

order date year month;
drop if year==.;
sort country year month;
save "`basepath'Data/dataUpdate_april15/disagreementAggrStacked.dta", replace;

set more on;
