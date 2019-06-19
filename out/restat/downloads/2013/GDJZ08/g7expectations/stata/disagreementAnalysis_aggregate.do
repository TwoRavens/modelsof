* Note that the inflation time-series have already be shifted backward 12 month to match the forecast horizon of the survey data.

clear
set more off
set mem 150m
*version 8.2
version 9.1
#delimit;

local basepath0 "C:\Jirka\Research\g7expectations\";

local basepath "`basepath0'g7expectations/";
cd "`basepath'stata/";
capture log close;
log using disagreementAnalysis_aggregate.log, replace;

global docPath "`basepath'docs/paper/tables/appendix";

global startSmpl "1989M10";	* start of the sample;
global endSmpl "2006M10";	* end of the sample;
global splitSmpl "1998M12";	* split of the sample (for descriptive stats);
global splitSmplPlusOne "1999M01";
global disagrMeasIndex "1";	* Measure of disagreement: 2: st deviation, otherwise (eg, 1) IQR, default IQR;
global eolString "_char(92) _char(92)";		* string denoting new line in LaTeX tables \\;
global freq "";
global robustLags "12";		* # of lags for HAC std errors;
global uncertaintyMeasure "2";	* Measure of uncertainty: 1: Delta Var^2, 2: var of permanent component, 3: var of perm+2*var of temp (default 1);

local Ccodes cn fr ge it jp uk us;
local variable infl gdp r3m cons inv un ip;

*Note BasicTestsAll works only with "infl" as the measure of inflation, for other alternatives use BasicTests;

use "`basepath'Data/disagreementAggr.dta", clear;

gen rescTime=_n/12;
gen t =  m(1985m1)+_n-1;
format t %tm;
tsset t;

*************************************************************************************************;

gen secondHalfDummy = 0;
replace secondHalfDummy =1 if tin($splitSmplPlusOne,$endSmpl);

foreach var of local variable {;

	foreach cntr of local Ccodes {;
			gen `cntr'`var'disagr=`cntr'`var'iqr; global disagrVar "IQR";
			if "$disagrMeasBig"=="2"|("$disagrMeasIndex"=="2"&"$disagrMeasBig"=="") {; replace `cntr'`var'disagr=`cntr'`var'stdev; global disagrVar "StDev"; };
	};

};

foreach var of local variable {;

	foreach C of local Ccodes {;

		global variable "`var'";
		global country "`C'";

		gen d`C'`var'Sq=(`C'`var'-L12.`C'`var')^2;	* A measure of variation in the underlying variable;
		replace d`C'`var'Sq=`C'`var'varepsilon^2 if "$uncertaintyMeasure"=="2";
		replace d`C'`var'Sq=`C'`var'varepsilon^2+2*`C'`var'vareta^2 if "$uncertaintyMeasure"=="3";
		gen d`C'primeRateSq=(`C'primeRate-L.`C'primeRate)^2;

		* Correlation between IQR and st dev;
		********************************************************************************;		
		correl `C'`var'iqr `C'`var'stdev if tin($startSmpl,$endSmpl);
		sca `C'`var'corrDisagrFull=r(rho);

		correl `C'`var'iqr `C'`var'stdev if tin($startSmpl,$splitSmpl);
		sca `C'`var'corrDisagr1stHalf=r(rho);	

		correl `C'`var'iqr `C'`var'stdev if tin($splitSmplPlusOne,$endSmpl);
		sca `C'`var'corrDisagr2ndHalf=r(rho);	

		correl `C'`var'iqr `C'`var'stdev if tin($startSmpl,$endSmpl);
		sca `C'`var'corrDisagrRecession=r(rho);	

		correl `C'`var'iqr `C'`var'stdev if tin($startSmpl,$endSmpl);
		sca `C'`var'corrDisagrBoom=r(rho);	
		
		
		* Drivers of Disagreement -- Detailed Analysis;
		*********************************************************************************************;
		* Constant, Recession, Trend, Past Disagreement;
		*****************************;
		regress `C'`var'disagr if tin($startSmpl,$endSmpl);
		sca `var'Reg1rbar`C'= e(r2_a);

		newey `C'`var'disagr if tin($startSmpl,$endSmpl), lag($robustLags);
		sca `var'Reg1pointConst`C'=_b[_cons];
		sca `var'Reg1seConst`C'=_se[_cons];

		regress `C'`var'disagr `C'Recession if tin($startSmpl,$endSmpl);
		sca `var'Reg2rbar`C'= e(r2_a);

		newey `C'`var'disagr `C'Recession if tin($startSmpl,$endSmpl), lag($robustLags);
		sca `var'Reg2pointConst`C'=_b[_cons];
		sca `var'Reg2seConst`C'=_se[_cons];
		sca `var'Reg2pointRecession`C'=_b[`C'Recession];
		sca `var'Reg2seRecession`C'=_se[`C'Recession];

		regress `C'`var'disagr `C'Recession rescTime if tin($startSmpl,$endSmpl);
		sca `var'Reg3rbar`C'= e(r2_a);

		newey `C'`var'disagr `C'Recession rescTime if tin($startSmpl,$endSmpl), lag($robustLags);
		sca `var'Reg3pointConst`C'=_b[_cons];
		sca `var'Reg3seConst`C'=_se[_cons];
		sca `var'Reg3pointRecession`C'=_b[`C'Recession];
		sca `var'Reg3seRecession`C'=_se[`C'Recession];
		sca `var'Reg3pointTime`C'=_b[rescTime];
		sca `var'Reg3seTime`C'=_se[rescTime];

		regress `C'`var'disagr `C'Recession secondHalfDummy if tin($startSmpl,$endSmpl);
		sca `var'Reg3Arbar`C'= e(r2_a);

		newey `C'`var'disagr `C'Recession secondHalfDummy if tin($startSmpl,$endSmpl), lag($robustLags);
		sca `var'Reg3ApointConst`C'=_b[_cons];
		sca `var'Reg3AseConst`C'=_se[_cons];
		sca `var'Reg3ApointRecession`C'=_b[`C'Recession];
		sca `var'Reg3AseRecession`C'=_se[`C'Recession];
		sca `var'Reg3Apoint2ndHalf`C'=_b[secondHalfDummy];
		sca `var'Reg3Ase2ndHalf`C'=_se[secondHalfDummy];

		regress `C'`var'disagr `C'Recession rescTime L.`C'`var'disagr if tin($startSmpl,$endSmpl);
		sca `var'Reg3Brbar`C'= e(r2_a);

		newey `C'`var'disagr `C'Recession rescTime L.`C'`var'disagr if tin($startSmpl,$endSmpl), lag($robustLags);
		sca `var'Reg3BpointConst`C'=_b[_cons];
		sca `var'Reg3BseConst`C'=_se[_cons];
		sca `var'Reg3BpointRecession`C'=_b[`C'Recession];
		sca `var'Reg3BseRecession`C'=_se[`C'Recession];
		sca `var'Reg3BpointTime`C'=_b[rescTime];
		sca `var'Reg3BseTime`C'=_se[rescTime];
		sca `var'Reg3BpointPastDisagr`C'=_b[L.`C'`var'disagr];
		sca `var'Reg3BsePastDisagr`C'=_se[L.`C'`var'disagr];

		* Local economic variables;
		*****************************;
		regress `C'`var'disagr `C'`var' if tin($startSmpl,$endSmpl);
		sca `var'Reg4rbar`C'= e(r2_a);

		newey `C'`var'disagr `C'`var' if tin($startSmpl,$endSmpl), lag($robustLags);
		sca `var'Reg4pointConst`C'=_b[_cons];
		sca `var'Reg4seConst`C'=_se[_cons];
		sca `var'Reg4point`var'`C'=_b[`C'`var'];
		sca `var'Reg4se`var'`C'=_se[`C'`var'];

		regress `C'`var'disagr `C'`var' d`C'`var'Sq if tin($startSmpl,$endSmpl);
		sca `var'Reg5rbar`C'= e(r2_a);

		newey `C'`var'disagr `C'`var' d`C'`var'Sq if tin($startSmpl,$endSmpl), lag($robustLags);
		sca `var'Reg5pointConst`C'=_b[_cons];
		sca `var'Reg5seConst`C'=_se[_cons];
		sca `var'Reg5point`var'`C'=_b[`C'`var'];
		sca `var'Reg5se`var'`C'=_se[`C'`var'];
		sca `var'Reg5pointd`var'Sq`C'=_b[d`C'`var'Sq];
		sca `var'Reg5sed`var'Sq`C'=_se[d`C'`var'Sq];

		regress `C'`var'disagr `C'outputGapExpost if tin($startSmpl,$endSmpl);
		sca `var'Reg6_0rbar`C'= e(r2_a);

		newey `C'`var'disagr `C'outputGapExpost if tin($startSmpl,$endSmpl), lag($robustLags);
		sca `var'Reg6_0pointConst`C'=_b[_cons];
		sca `var'Reg6_0seConst`C'=_se[_cons];
		sca `var'Reg6_0pointGDP`C'=_b[`C'outputGapExpost];
		sca `var'Reg6_0seGDP`C'=_se[`C'outputGapExpost];

		regress `C'`var'disagr `C'`var' d`C'`var'Sq `C'outputGapExpost if tin($startSmpl,$endSmpl);
		sca `var'Reg6rbar`C'= e(r2_a);

		newey `C'`var'disagr `C'`var' d`C'`var'Sq `C'outputGapExpost if tin($startSmpl,$endSmpl), lag($robustLags);
		sca `var'Reg6pointConst`C'=_b[_cons];
		sca `var'Reg6seConst`C'=_se[_cons];
		sca `var'Reg6point`var'`C'=_b[`C'`var'];
		sca `var'Reg6se`var'`C'=_se[`C'`var'];
		sca `var'Reg6pointd`var'Sq`C'=_b[d`C'`var'Sq];
		sca `var'Reg6sed`var'Sq`C'=_se[d`C'`var'Sq];
		sca `var'Reg6pointGDP`C'=_b[`C'outputGapExpost];
		sca `var'Reg6seGDP`C'=_se[`C'outputGapExpost];

		regress `C'`var'disagr d`C'primeRateSq if tin($startSmpl,$endSmpl);
		sca `var'Reg6A_0rbar`C'= e(r2_a);

		newey `C'`var'disagr d`C'primeRateSq if tin($startSmpl,$endSmpl), lag($robustLags);
		sca `var'Reg6A_0pointConst`C'=_b[_cons];
		sca `var'Reg6A_0seConst`C'=_se[_cons];
		sca `var'Reg6A_0pointRate`C'=_b[d`C'primeRateSq];
		sca `var'Reg6A_0seRate`C'=_se[d`C'primeRateSq];

		regress `C'`var'disagr `C'`var' d`C'`var'Sq d`C'primeRateSq if tin($startSmpl,$endSmpl);
		sca `var'Reg6Arbar`C'= e(r2_a);
	
		newey `C'`var'disagr `C'`var' d`C'`var'Sq d`C'primeRateSq if tin($startSmpl,$endSmpl), lag($robustLags);
		sca `var'Reg6ApointConst`C'=_b[_cons];
		sca `var'Reg6AseConst`C'=_se[_cons];
		sca `var'Reg6Apoint`var'`C'=_b[`C'`var'];
		sca `var'Reg6Ase`var'`C'=_se[`C'`var'];
		sca `var'Reg6Apointd`var'Sq`C'=_b[d`C'`var'Sq];
		sca `var'Reg6Ased`var'Sq`C'=_se[d`C'`var'Sq];
		sca `var'Reg6ApointRate`C'=_b[d`C'primeRateSq];
		sca `var'Reg6AseRate`C'=_se[d`C'primeRateSq];

		regress `C'`var'disagr `C'`var' d`C'`var'Sq `C'outputGapExpost d`C'primeRateSq if tin($startSmpl,$endSmpl);
		sca `var'Reg7rbar`C'= e(r2_a);

		newey `C'`var'disagr `C'`var' d`C'`var'Sq `C'outputGapExpost d`C'primeRateSq if tin($startSmpl,$endSmpl), lag($robustLags);
		sca `var'Reg7pointConst`C'=_b[_cons];
		sca `var'Reg7seConst`C'=_se[_cons];
		sca `var'Reg7point`var'`C'=_b[`C'`var'];
		sca `var'Reg7se`var'`C'=_se[`C'`var'];
		sca `var'Reg7pointd`var'Sq`C'=_b[d`C'`var'Sq];
		sca `var'Reg7sed`var'Sq`C'=_se[d`C'`var'Sq];
		sca `var'Reg7pointGDP`C'=_b[`C'outputGapExpost];
		sca `var'Reg7seGDP`C'=_se[`C'outputGapExpost];
		sca `var'Reg7pointRate`C'=_b[d`C'primeRateSq];
		sca `var'Reg7seRate`C'=_se[d`C'primeRateSq];

		* Cross-country correlation in disagreement;	
		*****************************;
		local CcodesSub=subinstr("`Ccodes'","`C'","",1);
		
		local varlist "`C'`var'disagr";
		foreach cntr of local CcodesSub {;
			local varlist "`varlist' `cntr'`var'disagr"; 			 
		};

		regress `varlist' if tin($startSmpl,$endSmpl);
	
		sca `var'Reg7BpointConst`C'=_b[_cons];
		sca `var'Reg7BseConst`C'=_se[_cons];
		sca `var'Reg7Bpoint`C'`var'disagr`C'=.;
		sca `var'Reg7Bse`C'`var'disagr`C'=.;
		sca `var'Reg7Brbar`C'= e(r2_a);
	
		foreach cntr of local CcodesSub {;
			sca `var'Reg7Bpoint`cntr'`var'disagr`C'=_b[`cntr'`var'disagr];
			sca `var'Reg7Bse`cntr'`var'disagr`C'=_se[`cntr'`var'disagr];	
		};

		********************************;
		local varlist "`C'`var'disagr `C'Recession";
		foreach cntr of local CcodesSub {;
			local varlist "`varlist' `cntr'`var'disagr"; 			 
		};

		regress `varlist' if tin($startSmpl,$endSmpl);
	
		sca `var'Reg8pointConst`C'=_b[_cons];
		sca `var'Reg8seConst`C'=_se[_cons];
		sca `var'Reg8pointRecession`C'=_b[`C'Recession];
		sca `var'Reg8seRecession`C'=_se[`C'Recession];
		sca `var'Reg8point`C'`var'disagr`C'=.;
		sca `var'Reg8se`C'`var'disagr`C'=.;
		sca `var'Reg8rbar`C'= e(r2_a);
	
		foreach cntr of local CcodesSub {;
			sca `var'Reg8point`cntr'`var'disagr`C'=_b[`cntr'`var'disagr];
			sca `var'Reg8se`cntr'`var'disagr`C'=_se[`cntr'`var'disagr];	
		};

		* Cross-variable correlation in disagreement;	
		*****************************;
		local variableSub=subinstr("`variable'","`var'","",1);
		
		local varlist "`C'`var'disagr";
		foreach varbl of local variableSub {;
			local varlist "`varlist' `C'`varbl'disagr"; 			 
		};

		regress `varlist' if tin($startSmpl,$endSmpl);
	
		sca `var'Reg9pointConst`C'=_b[_cons];
		sca `var'Reg9seConst`C'=_se[_cons];
		sca `var'Reg9point`C'`var'disagr`C'=.;
		sca `var'Reg9se`C'`var'disagr`C'=.;
		sca `var'Reg9rbar`C'= e(r2_a);
	
		foreach varbl of local variableSub {;
			sca `var'Reg9point`C'`varbl'disagr`C'=_b[`C'`varbl'disagr];
			sca `var'Reg9se`C'`varbl'disagr`C'=_se[`C'`varbl'disagr];	
		};

		********************************;
		local varlist "`C'`var'disagr `C'Recession";
		foreach varbl of local variableSub {;
			local varlist "`varlist' `C'`varbl'disagr"; 			 
		};
		
		regress `varlist' if tin($startSmpl,$endSmpl);

		sca `var'Reg10pointConst`C'=_b[_cons];
		sca `var'Reg10seConst`C'=_se[_cons];
		sca `var'Reg10pointRecession`C'=_b[`C'Recession];
		sca `var'Reg10seRecession`C'=_se[`C'Recession];
		sca `var'Reg10point`C'`var'disagr`C'=.;
		sca `var'Reg10se`C'`var'disagr`C'=.;
		sca `var'Reg10rbar`C'= e(r2_a);
	
		foreach varbl of local variableSub {;
			sca `var'Reg10point`C'`varbl'disagr`C'=_b[`C'`varbl'disagr];
			sca `var'Reg10se`C'`varbl'disagr`C'=_se[`C'`varbl'disagr];	
		};
		
		qui do "`basepath'stata/write/writeDisagreementTabDetailed.do";			

		drop d`C'primeRateSq;
			
		* Correlations for TeX file;
		foreach varbl of local variable {;
			foreach cntr of local Ccodes {;
				qui correl `C'`var'disagr `cntr'`varbl'disagr if tin($startSmpl,$endSmpl);
				qui sca `C'`var'corr`cntr'`varbl'=r(rho);	
			};
		};
	};

	qui do "`basepath'stata/write/writeDisagreementTabSummary.do";				
	pwcorr cn`var'disagr fr`var'disagr ge`var'disagr it`var'disagr jp`var'disagr uk`var'disagr us`var'disagr if tin($startSmpl,$endSmpl), star(0.05);

};

* writes summary tables for drivers of disagreement;

* writes the table with corrs of iqr and stdev;
qui do "`basepath'stata/write/writeSumCorrDisagrAllCountries";

* correlation of disagreement within country across variables;
qui do "`basepath'stata/write/writeCorrDisagrWithinCntry";

* correlation of disagreement for each variable across countries;
qui do "`basepath'stata/write/writeCorrDisagrAcrossCntry";

*************************************************************************************************************************************;
log close;



