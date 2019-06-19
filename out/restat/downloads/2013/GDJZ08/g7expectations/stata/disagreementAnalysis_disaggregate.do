* Note that the inflation time-series have already be shifted backward 12 month to match the forecast horizon of the survey data.

clear
set more off
set mem 150m
*version 8.2
version 9.1
#delimit;

local basepath0 "C:/Jirka/Research/g7expectations";

local basepath "`basepath0'/g7expectations";
global basepath "`basepath'";
cd "`basepath'/stata/";
capture log close;
log using disagreementAnalysis_disaggregate.log, replace;

global docPath "`basepath'/docs/paper/tables/appendix";

global startSmpl "1989M10";	* start of the sample;
global endSmpl "2006M10";	* end of the sample;
global splitSmpl "1998M12";	* split of the sample (for descriptive stats);
global splitSmplPlusOne "1999M01";
global disagrMeasIndex "1";	* Measure of disagreement: 2: st deviation, otherwise (eg, 1) IQR, default IQR;
global eolString "_char(92) _char(92)";		* string denoting new line in LaTeX tables \\;

*local Numbers "50 37 46 40 53 74 73";
*local maxnum 74;
local Numbers "46 33 40 35 44 61 60";
local maxnum 61;
local Ccodes cn fr ge it jp uk us;
local variable infl gdp r3m cons inv un ip;

foreach var of local variable {;

	*-----------------------------------------------------------------------;
	* READING DATA;

	* Load consensus data;
	use "`basepath'/Data/___`var'_2xstacked.dta", clear;

	sort id time;
	tsset id time, monthly;
	iis id; tis time;


	gen rescTime=.;		* Just an initialization;
	gen `var'4Q= ( (13-month)*`var'0 + (month-1)*`var'1 )/12;
	gen d`var'Sq=(`var'-L12.`var')^2;	* A measure of variation in the underlying variable;

	gen `var'disagr4Q=`var'iqr4Q; global disagrVar "IQR";
	if "$disagrMeasBig"=="2"|("$disagrMeasIndex"=="2"&"$disagrMeasBig"=="") {; replace `var'disagr4Q=`var'stdev4Q; global disagrVar "StDev"; };

	*-----------------------------------------------------------------------;
	* DROP DATA THAT IS NOT NEEDED;
	drop `var'high4Q `var'low4Q;

	*-----------------------------------------------------------------------;
	* CALCULATE AVERAGE NOBS, DISAGREEMENT [Note: MRW use IQR], MEAN ERROR, MEAN MSE OF INDIVIDUAL FORECASTS, LEVEL AND STD OF UNDERLYING VARIABLE;

	qui gen `var'e4Q = `var'4Q - F12.`var';
	qui gen `var'ae4Q = abs(`var'e4Q);
	qui gen `var'e24Q = `var'e4Q^2;

	qui gen `var'meane4Q = `var'mean4Q - F12.`var';
	qui gen `var'meanae4Q = abs(`var'meane4Q);
	qui gen `var'meane24Q = `var'meane4Q^2;

	qui gen `var'mediane4Q = `var'median4Q - F12.`var';
	qui gen `var'medianae4Q = abs(`var'mediane4Q);
	qui gen `var'mediane24Q = `var'mediane4Q^2;

	*by id: egen `var'mae4Q = mean(`var'ae4Q);		* for individual panelists;
	*by id: egen `var'rmse4Q = mean(`var'e24Q);
	*replace `var'rmse4Q = sqrt(`var'rmse4Q);

	foreach C of local Ccodes {;
		foreach type in nobs disagr meane meane2 {;
	
			sum `var'`type'4Q if country=="`C'"&tin($startSmpl,$endSmpl);
			sca `var'mean`type'Full`C'=r(mean);
			sca `var'sd`type'Full`C'=r(sd);
	
			sum `var'`type'4Q if country=="`C'"&tin($startSmpl,$splitSmpl);
			sca `var'mean`type'1stHalf`C'=r(mean);	
			sca `var'sd`type'1stHalf`C'=r(sd);	
	
			sum `var'`type'4Q if country=="`C'"&tin($splitSmplPlusOne,$endSmpl);
			sca `var'mean`type'2ndHalf`C'=r(mean);	
			sca `var'sd`type'2ndHalf`C'=r(sd);	
	
			sum `var'`type'4Q if country=="`C'"&recession==1&tin($startSmpl,$endSmpl);
			sca `var'mean`type'Recession`C'=r(mean);	
			sca `var'sd`type'Recession`C'=r(sd);	
	
			sum `var'`type'4Q if country=="`C'"&recession==0&tin($startSmpl,$endSmpl);
			sca `var'mean`type'Boom`C'=r(mean);	
			sca `var'sd`type'Boom`C'=r(sd);	
		};
			
		global variable "`var'";
		global country "`C'";
	
		sum `var' if country=="`C'"&tin($startSmpl,$endSmpl);
		sca `var'meanLevelFull`C'=r(mean);
		sca `var'VarFull`C'=r(Var);

		sum `var' if country=="`C'"&tin($startSmpl,$splitSmpl);
		sca `var'meanLevel1stHalf`C'=r(mean);	
		sca `var'Var1stHalf`C'=r(Var);	

		sum `var' if country=="`C'"&tin($splitSmplPlusOne,$endSmpl);
		sca `var'meanLevel2ndHalf`C'=r(mean);	
		sca `var'Var2ndHalf`C'=r(Var);	

		sum `var' if country=="`C'"&recession==1&tin($startSmpl,$endSmpl);
		sca `var'meanLevelRecession`C'=r(mean);	
		sca `var'VarRecession`C'=r(Var);	

		qui sum `var' if country=="`C'"&recession==0&tin($startSmpl,$endSmpl);
		sca `var'meanLevelBoom`C'=r(mean);	
		sca `var'VarBoom`C'=r(Var);	
					
		* Test for normality (with Shapiro-Wilk);
		*************************************************************************************;
		qui gen `var'swilk_pval`C' = .;
		forvalues y = 1989/2004 {;
			forvalues m = 1/12 {;
				qui sum `var'4Q if year==`y'&month==`m'&country=="`C'";
				if r(N)!=0 {;
					qui swilk `var'4Q if year==`y'&month==`m'&country=="`C'";
					qui replace `var'swilk_pval`C' = r(p) if year==`y'&month==`m'&country=="`C'";
				};
			};
		};
		count if `var'swilk_pval`C'<0.05&`var'swilk_pval`C'~=.;	* normality rejected;
		sca normReject=r(N);
		count if `var'swilk_pval`C'~=.;	* test performed;
		sca `var'fracNormal`C'=(r(N)-normReject)/r(N);
		disp "Fraction of time normality NOT Rejected for `var' in `C':";
		disp `var'fracNormal`C';
	
		* THIS IS JUST SOME STUFF FOR AN APPENDIX (probably won't be used in the paper anymore);
		* This is actually "aggregate" but I left it here because it was simpler;
		***************************************************************************************************************************************;
		* TESTING FOR BIAS;
		* IS INFORMATION FULLY EXPLOITED?;
		* ARE FORECAST ERRORS PERSISTENT?;
		* ARE FORECASTS EFFICIENT?;
		* TESTING THE ADAPTIVE EXPECTATIONS HYPOTHESIS;
		*-----------------------------------------------------------------------;
		
		* TESTING FOR BIAS;
		regress `var'meane4Q if mod(id,100)==5 & country=="`C'" & tin($startSmpl,$endSmpl);
		sca `var'biasPoint`C'=_b[_cons];
		sca `var'biasSe`C'=_se[_cons];
		
		* IS INFO FULLY EXPLOITED?;
		regress `var'e4Q `var'mean4Q if mod(id,100)==5 & country=="`C'" & tin($startSmpl,$endSmpl);
		sca `var'fullInfoConstPoint`C'=_b[_cons];
		sca `var'fullInfoConstSe`C'=_se[_cons];
		sca `var'fullInfoMeanPoint`C'=_b[`var'mean4Q];
		sca `var'fullInfoMeanSe`C'=_se[`var'mean4Q];
				
		* ARE FORECAST ERRORS PERSISTENT?;
		regress `var'meane4Q L12.`var'meane4Q if mod(id,100)==5 & country=="`C'" & tin($startSmpl,$endSmpl);
		sca `var'errPerConstPoint`C'=_b[_cons];
		sca `var'errPerConstSe`C'=_se[_cons];
		sca `var'errPerMeanPoint`C'=_b[L12.`var'meane4Q];
		sca `var'errPerMeanSe`C'=_se[L12.`var'meane4Q];
	
		* ARE FORECASTS EFFICIENT?;
		regress `var'meane4Q `var'mean4Q L.`var' L.ip L.xr L.un L.r3m if mod(id,100)==5 & country=="`C'" & tin($startSmpl,$endSmpl);
						
		* TESTING THE ADAPTIVE EXPECTATIONS HYPOTHESIS;
		* Simple form;
		regress `var'mean4Q L.`var' if mod(id,100)==5 & country=="`C'" & tin($startSmpl,$endSmpl), noconst;
			
		* More lagged inflation;
		regress `var'mean4Q L.`var' L13.`var' L25.`var' if mod(id,100)==5 & country=="`C'" & tin($startSmpl,$endSmpl), noconst;
			
		* Putting also other variables in;
		regress `var'mean4Q L.`var' L13.`var' L25.`var' L.ip L.un L.r3m if mod(id,100)==5 & country=="`C'" & tin($startSmpl,$endSmpl), noconst;
			
		* THIS REGERESSION ACTUALLY GETS PRINTED OUT IN LaTeX;
		regress `var'mean4Q L.`var' L.ip L.un L.r3m L.xr if mod(id,100)==5 & country=="`C'" & tin($startSmpl,$endSmpl);
		sca `var'effConstPoint`C'=_b[_cons];
		sca `var'effConstSe`C'=_se[_cons];
		sca `var'eff`var'Point`C'=_b[L.`var'];
		sca `var'eff`var'Se`C'=_se[L.`var'];
		sca `var'effipPoint`C'=_b[L.ip];
		sca `var'effipSe`C'=_se[L.ip];
		sca `var'effunPoint`C'=_b[L.un];
		sca `var'effunSe`C'=_se[L.un];
		sca `var'effr3mPoint`C'=_b[L.r3m];
		sca `var'effr3mSe`C'=_se[L.r3m];
		sca `var'effxrPoint`C'=_b[L.xr];
		sca `var'effxrSe`C'=_se[L.xr];
	
	};

	qui do "`basepath'/stata/write/writeSumStatPeriodComparisonByVarSummary.do";
	qui do "`basepath'/stata/write/writeConsensusEffTab.do";

};

qui do "`basepath'/stata/write/writeSumStatAllCountriesSummary";

foreach var of local variable {;
	foreach C of local Ccodes {;
		disp "Fraction of time normality NOT Rejected for `var' in `C':";
		disp `var'fracNormal`C';
		};
	};

*************************************************************************************************************************************




*************************************************************************************************************************************

log close;



