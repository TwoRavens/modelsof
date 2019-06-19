clear 
set more off

*version 9.1
#delimit;

local basepath "C:\Jirka\Research\g7expectations\g7expectations\";

cd "`basepath'stata/dataManagement";

*capture log close;
*log using macro_transformation.log, replace;

local Ccodes cn fr ge it jp uk us;
local Dcodes cn fr ge it jp uk us gewest;

*-----------------------------------------------------------------------;
* READING DATA;

insheet using "`basepath'Data/Macro-Variables.txt", tab clear;
sort year month;


*-----------------------------------------------------------------------;
* NESSECARY DATA TRANSFORMATIONS;

foreach C of local Ccodes {;


	* NOTE: 	All growth rates are between t-12/t-3 and t;
	*--------------------------------------------------;
	* Compute inflation rate from CPIs;
	
	qui replace `C'cpi = . if `C'cpi==0;
	qui replace `C'cpicore = . if `C'cpicore==0;
	qui replace `C'hcpi = . if `C'hcpi==0;
	qui gen `C'infl = ((`C'cpi[_n]/`C'cpi[_n-12])-1)*100;	
	qui gen `C'infl_core = (`C'cpicore[_n]/`C'cpicore[_n-12]-1)*100;
	qui gen `C'infl_harm = (`C'hcpi[_n]/`C'hcpi[_n-12]-1)*100;
	qui gen `C'inflQ = ((`C'cpi[_n]/`C'cpi[_n-3])-1)*400;			*quarterly inflation rates (annualized);
	qui gen `C'infl_coreQ = (`C'cpicore[_n]/`C'cpicore[_n-3]-1)*400;
	qui gen `C'infl_harmQ = (`C'hcpi[_n]/`C'hcpi[_n-3]-1)*400;
	
	*--------------------------------------------------;
	* Compute 12-month growth rate of Ind. Production;

	qui replace `C'ip = . if `C'ip==0;
	qui gen `C'dip = (`C'ip[_n]/`C'ip[_n-12]-1)*100;
	
	* GDP & GNP growth;
	qui gen `C'dgdp = (`C'gdp[_n]/`C'gdp[_n-12]-1)*100;
	qui gen `C'dgnp = (`C'gnp[_n]/`C'gnp[_n-12]-1)*100;
	
	*--------------------------------------------------;
	* Compute 12-month change of real eff. exchange rate;

	qui replace `C'xr = . if `C'xr==0;
	qui gen `C'dxr = (`C'xr[_n]/`C'xr[_n-12]-1)*100;
	
	*--------------------------------------------------;
	* Compute 12-month growth rate of Consumption;

	qui replace `C'cons = . if `C'cons==0;
	qui gen `C'dcons = (`C'cons[_n]/`C'cons[_n-12]-1)*100;
	
	*--------------------------------------------------;
	* Compute 12-month growth rate of Investment;

	qui replace `C'inv = . if `C'inv==0;
	qui gen `C'dinv = (`C'inv[_n]/`C'inv[_n-12]-1)*100;

	*--------------------------------------------------;
	* Replace remaining zero entries;

	qui replace `C'un = . if `C'un==0.0;
	qui replace `C'r3m = . if `C'r3m==0.0;
	qui replace `C'r10y = . if `C'r10y==0.0;


	*-------------------------------------------------------------------------------;
	* Yearly Growth rates from here on;
	*-------------------------------------------------------------------------------;

	* Growth of GNP;
	qui gen `C'gnpannual = .;
	qui replace `C'gnpannual = ((`C'gnp[_n]+`C'gnp[_n-3]+`C'gnp[_n-6]+`C'gnp[_n-9])/
								(`C'gnp[_n-12]+`C'gnp[_n-15]+`C'gnp[_n-18]+`C'gnp[_n-21])-1)*100 if month==12;
	forvalues t=1/11 {;
		qui replace `C'gnpannual = `C'gnpannual[_n+12-`t'] if month==`t'; 
	};

	* Industrial Production;
	qui gen `C'ipannual = .;
	qui replace `C'ipannual = ((`C'ip[_n]+`C'ip[_n-1]+`C'ip[_n-2]+`C'ip[_n-3]+`C'ip[_n-4]+`C'ip[_n-5]+`C'ip[_n-6]
					  			    +`C'ip[_n-7]+`C'ip[_n-8]+`C'ip[_n-9]+`C'ip[_n-10]+`C'ip[_n-11])/
					   (`C'ip[_n-12]+`C'ip[_n-13]+`C'ip[_n-14]+`C'ip[_n-15]+`C'ip[_n-16]+`C'ip[_n-17]
								    +`C'ip[_n-18]+`C'ip[_n-19]+`C'ip[_n-20]+`C'ip[_n-21]+`C'ip[_n-22]
								    +`C'ip[_n-23])-1)*100 if month==12;
	forvalues t=1/11 {;
		qui replace `C'ipannual = `C'ipannual[_n+12-`t'] if month==`t'; 
	};


	* Inflation rates;
	qui gen `C'meancpi = .;
	qui replace `C'meancpi = (`C'cpi[_n]+`C'cpi[_n-1]+`C'cpi[_n-2]+`C'cpi[_n-3]+`C'cpi[_n-4]+`C'cpi[_n-5]+`C'cpi[_n-6]+`C'cpi[_n-7]
					+`C'cpi[_n-8]+`C'cpi[_n-9]+`C'cpi[_n-10]+`C'cpi[_n-11])/12 if month==12;
	forvalues t=1/11 {;
		qui replace `C'meancpi = `C'meancpi[_n+12-`t'] if month==`t'; 
	};
	qui gen `C'inflannual = .;
	qui replace `C'inflannual = ((`C'meancpi[_n]/`C'meancpi[_n-12])-1)*100;


	* for UK: RPIX;
	qui gen `C'meanrpix = .;
	qui replace `C'meanrpix = (`C'rpix[_n]+`C'rpix[_n-1]+`C'rpix[_n-2]+`C'rpix[_n-3]+`C'rpix[_n-4]+`C'rpix[_n-5]+`C'rpix[_n-6]+`C'rpix[_n-7]
					+`C'rpix[_n-8]+`C'rpix[_n-9]+`C'rpix[_n-10]+`C'rpix[_n-11])/12 if month==12;
	forvalues t=1/11 {;
		qui replace `C'meanrpix = `C'meanrpix[_n+12-`t'] if month==`t'; 
	};
	qui gen `C'rpixannual = .;
	qui replace `C'rpixannual = ((`C'meanrpix[_n]/`C'meanrpix[_n-12])-1)*100;


	* for UK: RPI;
	qui gen `C'meanrpi = .;
	qui replace `C'meanrpi = (`C'rpi[_n]+`C'rpi[_n-1]+`C'rpi[_n-2]+`C'rpi[_n-3]+`C'rpi[_n-4]+`C'rpi[_n-5]+`C'rpi[_n-6]+`C'rpi[_n-7]
					+`C'rpi[_n-8]+`C'rpi[_n-9]+`C'rpi[_n-10]+`C'rpi[_n-11])/12 if month==12;
	forvalues t=1/11 {;
		qui replace `C'meanrpi = `C'meanrpi[_n+12-`t'] if month==`t'; 
	};
	qui gen `C'rpiannual = .;
	qui replace `C'rpiannual = ((`C'meanrpi[_n]/`C'meanrpi[_n-12])-1)*100;


	* Growth of CONS;
	qui gen `C'consannual = .;
	qui replace `C'consannual = ((`C'cons[_n]+`C'cons[_n-3]+`C'cons[_n-6]+`C'cons[_n-9])/
								(`C'cons[_n-12]+`C'cons[_n-15]+`C'cons[_n-18]+`C'cons[_n-21])-1)*100 if month==12;
	forvalues t=1/11 {;
		qui replace `C'consannual = `C'consannual[_n+12-`t'] if month==`t'; 
	};


	* Growth of INV;
	qui gen `C'invannual = .;
	qui replace `C'invannual = ((`C'inv[_n]+`C'inv[_n-3]+`C'inv[_n-6]+`C'cons[_n-9])/
								(`C'inv[_n-12]+`C'inv[_n-15]+`C'inv[_n-18]+`C'inv[_n-21])-1)*100 if month==12;
	forvalues t=1/11 {;
		qui replace `C'invannual = `C'invannual[_n+12-`t'] if month==`t'; 
	};


	* exchange rates;
	qui gen `C'meanxr = .;
	qui replace `C'meanxr = (`C'xr[_n]+`C'xr[_n-1]+`C'xr[_n-2]+`C'xr[_n-3]+`C'xr[_n-4]+`C'xr[_n-5]+`C'xr[_n-6]
					+`C'xr[_n-7]+`C'xr[_n-8]+`C'xr[_n-9]+`C'xr[_n-10]+`C'xr[_n-11])/12 if month==12;
	forvalues t=1/11 {;
		qui replace `C'meanxr = `C'meanxr[_n+12-`t'] if month==`t'; 
	};
	qui gen `C'xrannual = .;
	qui replace `C'xrannual = ((`C'meanxr[_n]/`C'meanxr[_n-12])-1)*100;

	*****************************************************************************;
	qui replace `C'cons = `C'dcons; drop `C'dcons;
	qui replace `C'inv = `C'dinv; drop `C'dinv;
	qui replace `C'ip = `C'dip; drop `C'dip;
	qui replace `C'xr = `C'dxr; drop `C'dxr;
	drop `C'meanrpix `C'meanrpi;

	* Interest rates;
	qui gen `C'irannual = .;
	qui replace `C'irannual = (`C'r3m[_n]+`C'r3m[_n-1]+`C'r3m[_n-2]+`C'r3m[_n-3]+`C'r3m[_n-4]+`C'r3m[_n-5]+`C'r3m[_n-6]+`C'r3m[_n-7]
					+`C'r3m[_n-8]+`C'r3m[_n-9]+`C'r3m[_n-10]+`C'r3m[_n-11])/12 if month==12;
	forvalues t=1/11 {;
		qui replace `C'irannual = `C'irannual[_n+12-`t'] if month==`t'; 
	};

};

foreach D of local Dcodes {;
	* Growth of GDP;
	qui gen `D'gdpannual = .;
	qui replace `D'gdpannual = ((`D'gdp[_n]+`D'gdp[_n-3]+`D'gdp[_n-6]+`D'gdp[_n-9])/
							(`D'gdp[_n-12]+`D'gdp[_n-15]+`D'gdp[_n-18]+`D'gdp[_n-21])-1)*100 if month==12;
	forvalues t=1/11 {;
	qui replace `D'gdpannual = `D'gdpannual[_n+12-`t'] if month==`t'; 
	};
};

qui gen gewestdgdp = (gewestgdp[_n]/gewestgdp[_n-12]-1)*100;

*------------------------------------------------------------------------;
* DROPS and ADJUSTMENTS;

qui replace gegdpannual = gewestgdpannual if year==1997&month<=5;	* West=>whole Germany
qui replace gegdpannual = gewestgdpannual if year<=1996;

qui replace gegdp = gewestdgdp if year==1997&month<=5;	* West=>whole Germany
qui replace gegdp = gewestdgdp if year<=1996;

drop *cpi*;
drop *meanxr*;
drop gewestgdp gewestgdpannual;

*** Dealing with structual breaks;
*** United Kingdom;
replace ukinflannual = ukrpixannual;
replace ukinflannual = ukrpiannual if year==1997&month<=4;	* CE switched from RPI to RPIX in Apr 97;
replace ukinflannual = ukrpiannual if year<=1996;

replace ukinfl = ((ukrpix[_n]/ukrpix[_n-12])-1)*100;
replace ukinfl = ((ukrpi[_n]/ukrpi[_n-12])-1)*100 if year==1997&month<=4;	
	* CE switched from RPI to RPIX in Apr 97;
replace ukinfl = ((ukrpi[_n]/ukrpi[_n-12])-1)*100 if year<=1996;

* GNP to GDP switches for Ger, Jap and the US;
*** USA;
replace usgdpannual = usgnpannual if year<=1991;
replace usdgdp = usdgnp if year<=1991;

*** Germany;
replace gegdpannual = gegnpannual if year<=1992;
replace gedgdp = gedgnp if year<=1992;

*** Japan;
replace jpgdpannual = jpgnpannual if year<=1999;
replace jpdgdp = jpdgnp if year<=1999;

* rename dgdp => gdp, drop dgdp (and gnp);
foreach C of local Ccodes {;
	drop `C'gdp `C'gnp;
	rename `C'dgdp `C'gdp;
	rename `C'dgnp `C'gnp;
};

* Generate ECRI business cycle recession dummies;
gen cnRecession = 0;
replace cnRecession =1 if (year==1990&month>=3)|(year==1991)|(year==1992&month<4);
gen frRecession = 0;
replace frRecession =1 if (year==1992&month>=2)|(year==1993&month<9);
replace frRecession =1 if (year==2002&month>=8)|(year==2003&month<6);
gen geRecession = 0;
replace geRecession =1 if (year>=1991&year<1994)|(year==1994&month<5);
replace geRecession =1 if (year==2001|year==2002)|(year==2003&month<9);
gen itRecession = 0;
replace itRecession =1 if (year==1992&month>=2)|(year==1993&month<11);
gen jpRecession = 0;
replace jpRecession =1 if (year==1992&month>=4)|(year==1993)|(year==1994&month<3);
replace jpRecession =1 if (year==1997&month>=3)|(year==1998)|(year==1999&month<8);
replace jpRecession =1 if (year==2000&month>=8)|(year>2000&year<2003)|(year==2003&month<5);
gen ukRecession = 0;
replace ukRecession =1 if (year==1990&month>=5)|(year==1991)|(year==1992&month<4);
gen usRecession = 0;
replace usRecession =1 if (year==1990&month>=7)|(year==1991&month<4);
replace usRecession =1 if (year==2001&month>=3)&(year==2001&month<12);

save "`basepath'Data/Macro-Variables.dta", replace;

* Additional series (November 2008);
******************************************************************************;
insheet using "`basepath'Data/Macro-Variables_Additional.txt", tab clear;
sort year month;
save "`basepath'Data/Macro-Variables_Additional.dta", replace;

merge year month using "`basepath'Data/Macro-Variables.dta", _merge(_merge);
drop _merge;
sort year month;
order year month;

* Additional transformations;
replace itun=itunrateq;
replace itun=itunrate if year>1992;
replace itun=itunrate if year==1992&month>9;
replace ukun=ukunrate;
replace geun=geunrate;
rename gewestunrate gewestun;
replace geun=gewestun if year<1992;

drop itunrateq itunrate ukunrate geunrate;

foreach C of local Ccodes {;
	rename `C'ogexpo `C'outputGapExpost;
	rename `C'oginit `C'outputGapInit;
	rename `C'prime `C'primeRate;
};

save "`basepath'Data/Macro-Variables_Extended.dta", replace;

*log close;
