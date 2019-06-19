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

	*-----------------------------------------------------------------------;
	* READING DATA;

	* Load data about macro-variables;
	use "`basepath'Data/Macro-Variables_Extended.dta", clear;

	* Load consensus data;
	sort year month;
	merge year month using "`basepath'Data/detailed/___`var'Stacked.dta", uniqmaster _merge(_mergemacro);
	drop _mergemacro;

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


	* Rename macro-variables;
	foreach C of local Ccodes {;
		local name "gdp gnp ip rpi rpix un xr r3m r10y cons inv infl infl_core infl_harm inflQ infl_coreQ infl_harmQ gdpannual gnpannual ipannual inflannual consannual invannual xrannual irannual rpixannual rpiannual Recession outputGapInit outputGapExpost primeRate"; 
		*rausgenommen: cpi cpicore hcpi;
		foreach N of local name {;
			rename `C'`N' `N'`C';
			};
	};
	
	local varlist "`var'0 `var'1 `var'mean4Q `var'median4Q `var'high4Q `var'low4Q `var'stdev4Q `var'nobs4Q `var'iqr4Q gdp gnp ip un xr rpix rpi r3m r10y cons inv infl infl_core infl_harm inflQ infl_coreQ infl_harmQ meanCF0 meanCF1 highCF0 highCF1 lowCF0 lowCF1 stdevCF0 stdevCF1 gdpannual ipannual inflannual consannual invannual irannual xrannual rpixannual rpiannual gnpannual Recession outputGapInit outputGapExpost primeRate"; 

	reshape long `varlist', i(id year month) j(country cn fr ge it jp uk us) string;

	gen vergleich = id;

	replace id = id+100 if country=="cn";
	replace id = id+200 if country=="fr";
	replace id = id+300 if country=="ge";
	replace id = id+400 if country=="it";
	replace id = id+500 if country=="jp";
	replace id = id+600 if country=="uk";
	replace id = id+700 if country=="us";
	replace id = -99 if id==.;
	
	rename Recession recession;

	sort year month country;
	save "`basepath'Data/___`var'_2xstacked.dta", replace;

};

* Stack aggregate data (to estimate panel;
use "`basepath'Data/disagreementAggr.dta";

* Rename variables;
local varlist "Recession cons consannual conshigh consiqr conslow consmean consmedian consnobs consstdev gdp gdpannual gdphigh gdpiqr gdplow gdpmean gdpmedian gdpnobs gdpstdev gnp gnpannual infl inflQ infl_core infl_coreQ infl_harm infl_harmQ inflannual inflhigh infliqr infllow inflmean inflmedian inflnobs inflstdev inv invannual invhigh inviqr invlow invmean invmedian invnobs invstdev ip ipannual iphigh ipiqr iplow ipmean ipmedian ipnobs ipstdev irannual outputGapExpost outputGapInit primeRate r3m r3mhigh r3miqr r3mlow r3mmean r3mmedian r3mnobs r3mstdev r10y rpi rpiannual rpix rpixannual un unhigh uniqr unlow unmean unmedian unnobs unstdev xr xrannual inflvarepsilon r3mvarepsilon gdpvarepsilon consvarepsilon invvarepsilon unvarepsilon ipvarepsilon inflvareta r3mvareta gdpvareta consvareta invvareta unvareta ipvareta infltau r3mtau gdptau constau invtau untau iptau"; 

foreach C of local Ccodes {;
	foreach N of local varlist {;
		rename `C'`N' `N'`C';
		};
};

reshape long `varlist', i(year month) j(country cn fr ge it jp uk us) string;

order date year month;
sort country year month;
drop if year==.;
save "`basepath'Data/disagreementAggrStacked.dta", replace;
