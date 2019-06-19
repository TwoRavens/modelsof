* Note that the inflation time-series have already be shifted backward 12 month to match the forecast horizon of the survey data.

clear
set more off
set mem 150m
*version 8.2
*version 9.1
#delimit;

local basepath0 "C:\Jirka\Research\g7expectations\";

local basepath "`basepath0'g7expectations/";
cd "`basepath'stata/";
capture log close;
log using disagreementAnalysis_aggregate_panel_rawMeans.log, replace;

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

use "`basepath'Data/disagreementAggrStacked.dta", clear;

gen rescTime=_n/12;
gen t =  m(1985m1)+_n-1;
format t %tm;
gen countryID=.;
replace countryID=1 if country=="cn";
replace countryID=2 if country=="fr";
replace countryID=3 if country=="ge";
replace countryID=4 if country=="it";
replace countryID=5 if country=="jp";
replace countryID=6 if country=="uk";
replace countryID=7 if country=="us";
label define countryLabels 1 Canada 2 France 3 Germany 4 Italy 5 Japan 6 "United Kingdom" 7 "United States";
label values countryID countryLabels;

* MP credibility dummies;
gen mpCredibility=0;
replace mpCredibility=1 if country=="ge"|country=="us"|country=="cn";
replace mpCredibility=1 if (country=="fr"&year>1993)|(country=="fr"&year==1993&month>7);
replace mpCredibility=1 if (country=="it"&year>1993);
replace mpCredibility=1 if (country=="jp"&year>1997)|(country=="jp"&year==1997&month>6);
replace mpCredibility=1 if (country=="uk"&year>1998)|(country=="uk"&year==1998&month>5);

* Inflation targetting;
gen inflTargeting=0;
replace inflTargeting=1 if (country=="cn"&year>1991)|(country=="cn"&year==1991&month>1);
*replace inflTargeting=1 if (country=="fr"|country=="ge"|country=="it")&year>1998; * Assumes ECB is an inflation targeter;
replace inflTargeting=1 if (country=="uk"&year>1992);
*replace mpCredibility=inflTargeting;

* Alternative settings;
*replace mpCredibility=1 if (country=="fr"&year>1998); * Intro of the euro;
*replace mpCredibility=1 if (country=="it"&year>1998);
*replace mpCredibility=0 if (country=="fr"&year<1999); * Intro of the euro;
*replace mpCredibility=0 if (country=="it"&year<1999);

* Country-specific constant credibility;
*gen mpCredibility=0;
*replace mpCredibility=1 if country=="cn";
*replace mpCredibility=1 if country=="fr";
*replace mpCredibility=1 if country=="ge";
*replace mpCredibility=0 if country=="it";
*replace mpCredibility=0 if country=="jp";
*replace mpCredibility=0 if country=="uk";
*replace mpCredibility=0 if country=="us";

drop if time==.;
sort countryID time;
tsset countryID time, monthly;
iis countryID; tis time;
*************************************************************************************************;

gen secondHalfDummy = 0;
replace secondHalfDummy = 1 if tin($splitSmplPlusOne,$endSmpl);

gen dprimeRateSq=(primeRate-L.primeRate)^2;

gen mpRecessionCred = mpCredibility*Recession;
gen mpCredEpGap =  mpCredibility*outputGapExpost; 
gen mpCredDprimeRateSq = mpCredibility*dprimeRateSq;
gen clusterID=1;
replace clusterID=2 if country=="us"|country=="cn";
replace clusterID=3 if country=="jp";

foreach var of local variable {;

	gen `var'disagr=`var'iqr; global disagrVar "IQR";
	if "$disagrMeasBig"=="2"|("$disagrMeasIndex"=="2"&"$disagrMeasBig"=="") {; replace `var'disagr=`var'stdev; global disagrVar "StDev"; };

	global variable "`var'";

	gen d`var'Sq=(`var'-L12.`var')^2;	* A measure of variation in the underlying variable;
	replace d`var'Sq=`var'varepsilon^2 if "$uncertaintyMeasure"=="2";
	replace d`var'Sq=`var'varepsilon^2+2*`var'vareta^2 if "$uncertaintyMeasure"=="3";
	gen mpLag`var'Cred=mpCredibility*(L.`var'disagr);
	gen mpCred`var'=mpCredibility*(`var');
	gen mpCredd`var'Sq=mpCredibility*d`var'Sq;	* A measure of variation in the underlying variable;

	* Drivers of Disagreement -- Detailed Analysis;
	*********************************************************************************************;
	* Constant, Recession, Trend, Past Disagreement;
	*****************************;
	xtreg `var'disagr if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg1pointConst=_b[_cons];
	sca `var'Reg1seConst=_se[_cons];
	sca `var'Reg1rbar= e(r2_a);
	
	xi: reg `var'disagr i.countryID if tin($startSmpl,$endSmpl); * The advantage of this is it shows all constant terms;

	xtreg `var'disagr Recession if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg2pointConst=_b[_cons];
	sca `var'Reg2seConst=_se[_cons];

	xtivreg2 `var'disagr Recession if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg2pointRecession=_b[Recession];
	sca `var'Reg2seRecession=_se[Recession];
	sca `var'Reg2rbar= e(r2_a);

	xi: reg `var'disagr Recession i.countryID if tin($startSmpl,$endSmpl); * The advantage of this is it shows all constant terms;

	xtreg `var'disagr Recession rescTime if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg3pointConst=_b[_cons];
	sca `var'Reg3seConst=_se[_cons];

	xtivreg2 `var'disagr Recession rescTime if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg3pointRecession=_b[Recession];
	sca `var'Reg3seRecession=_se[Recession];
	sca `var'Reg3pointTime=_b[rescTime];
	sca `var'Reg3seTime=_se[rescTime];
	sca `var'Reg3rbar= e(r2_a);

	xtreg `var'disagr Recession secondHalfDummy if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg3ApointConst=_b[_cons];
	sca `var'Reg3AseConst=_se[_cons];

	xtivreg2 `var'disagr Recession secondHalfDummy if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg3ApointRecession=_b[Recession];
	sca `var'Reg3AseRecession=_se[Recession];
	sca `var'Reg3Apoint2ndHalf=_b[secondHalfDummy];
	sca `var'Reg3Ase2ndHalf=_se[secondHalfDummy];
	sca `var'Reg3Arbar= e(r2_a);

	* Local economic variables;
	*****************************;
	xtreg `var'disagr `var' if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg4pointConst=_b[_cons];
	sca `var'Reg4seConst=_se[_cons];

	xtivreg2 `var'disagr `var' if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg4point`var'=_b[`var'];
	sca `var'Reg4se`var'=_se[`var'];
	sca `var'Reg4rbar= e(r2_a);

	xtreg `var'disagr `var' d`var'Sq if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg5pointConst=_b[_cons];
	sca `var'Reg5seConst=_se[_cons];

	xtivreg2 `var'disagr `var' d`var'Sq if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg5point`var'=_b[`var'];
	sca `var'Reg5se`var'=_se[`var'];
	sca `var'Reg5pointd`var'Sq=_b[d`var'Sq];
	sca `var'Reg5sed`var'Sq=_se[d`var'Sq];
	sca `var'Reg5rbar= e(r2_a);

	xtreg `var'disagr outputGapExpost if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg6pointConst=_b[_cons];
	sca `var'Reg6seConst=_se[_cons];

	xtivreg2 `var'disagr outputGapExpost if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg6pointGDP=_b[outputGapExpost];
	sca `var'Reg6seGDP=_se[outputGapExpost];
	sca `var'Reg6rbar= e(r2_a);

	xtreg `var'disagr `var' d`var'Sq outputGapExpost if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg7pointConst=_b[_cons];
	sca `var'Reg7seConst=_se[_cons];

	xtivreg2 `var'disagr `var' d`var'Sq outputGapExpost if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg7point`var'=_b[`var'];
	sca `var'Reg7se`var'=_se[`var'];
	sca `var'Reg7pointd`var'Sq=_b[d`var'Sq];
	sca `var'Reg7sed`var'Sq=_se[d`var'Sq];
	sca `var'Reg7pointGDP=_b[outputGapExpost];
	sca `var'Reg7seGDP=_se[outputGapExpost];
	sca `var'Reg7rbar= e(r2_a);

	xtreg `var'disagr dprimeRateSq if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg8pointConst=_b[_cons];
	sca `var'Reg8seConst=_se[_cons];

	xtivreg2 `var'disagr dprimeRateSq if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg8pointRate=_b[dprimeRateSq];
	sca `var'Reg8seRate=_se[dprimeRateSq];
	sca `var'Reg8rbar= e(r2_a);

	xtreg `var'disagr `var' d`var'Sq dprimeRateSq if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg9pointConst=_b[_cons];
	sca `var'Reg9seConst=_se[_cons];

	xtivreg2 `var'disagr `var' d`var'Sq dprimeRateSq if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg9point`var'=_b[`var'];
	sca `var'Reg9se`var'=_se[`var'];
	sca `var'Reg9pointd`var'Sq=_b[d`var'Sq];
	sca `var'Reg9sed`var'Sq=_se[d`var'Sq];
	sca `var'Reg9pointRate=_b[dprimeRateSq];
	sca `var'Reg9seRate=_se[dprimeRateSq];
	sca `var'Reg9rbar= e(r2_a);

	xtreg `var'disagr `var' d`var'Sq outputGapExpost dprimeRateSq if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg10pointConst=_b[_cons];
	sca `var'Reg10seConst=_se[_cons];

	xtivreg2 `var'disagr `var' d`var'Sq outputGapExpost dprimeRateSq if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg10point`var'=_b[`var'];
	sca `var'Reg10se`var'=_se[`var'];
	sca `var'Reg10pointd`var'Sq=_b[d`var'Sq];
	sca `var'Reg10sed`var'Sq=_se[d`var'Sq];
	sca `var'Reg10pointGDP=_b[outputGapExpost];
	sca `var'Reg10seGDP=_se[outputGapExpost];
	sca `var'Reg10pointRate=_b[dprimeRateSq];
	sca `var'Reg10seRate=_se[dprimeRateSq];
	sca `var'Reg10rbar= e(r2_a);

	* Drivers of Disagreement -- MP credibility;
	*********************************************************************************************;
	* Constant, Recession, Trend, Past Disagreement;
	*****************************;
	xtreg `var'disagr mpCredibility if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg1MPpointConst=_b[_cons];
	sca `var'Reg1MPseConst=_se[_cons];

	xtivreg2 `var'disagr mpCredibility if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg1MPpointConstCred=_b[mpCredibility];
	sca `var'Reg1MPseConstCred=_se[mpCredibility];
	sca `var'Reg1MPrbar= e(r2_a);
	
	gen mpUnc=d`var'Sq*mpCredibility;

	xtreg `var'disagr mpCredibility `var' d`var'Sq outputGapExpost dprimeRateSq if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg1BMPpointConst=_b[_cons];
	sca `var'Reg1BMPseConst=_se[_cons];

	xtivreg2 `var'disagr mpCredibility `var' d`var'Sq outputGapExpost dprimeRateSq if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	drop mpUnc;
	sca `var'Reg1BMPpointConstCred=_b[mpCredibility];
	sca `var'Reg1BMPseConstCred=_se[mpCredibility];
	sca `var'Reg1BMPpoint`var'=_b[`var'];
	sca `var'Reg1BMPse`var'=_se[`var'];
	sca `var'Reg1BMPpointd`var'Sq=_b[d`var'Sq];
	sca `var'Reg1BMPsed`var'Sq=_se[d`var'Sq];
	sca `var'Reg1BMPpointGDP=_b[outputGapExpost];
	sca `var'Reg1BMPseGDP=_se[outputGapExpost];
	sca `var'Reg1BMPpointRate=_b[dprimeRateSq];
	sca `var'Reg1BMPseRate=_se[dprimeRateSq];
	sca `var'Reg1BMPrbar= e(r2_a);

	xtreg `var'disagr Recession mpCredibility mpRecessionCred if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg2MPpointConst=_b[_cons];
	sca `var'Reg2MPseConst=_se[_cons];

	xtivreg2 `var'disagr Recession mpCredibility mpRecessionCred if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg2MPpointRecession=_b[Recession];
	sca `var'Reg2MPseRecession=_se[Recession];
	sca `var'Reg2MPpointConstCred=_b[mpCredibility];
	sca `var'Reg2MPseConstCred=_se[mpCredibility];
	sca `var'Reg2MPpointRecCred=_b[mpRecessionCred];
	sca `var'Reg2MPseRecCred=_se[mpRecessionCred];
	sca `var'Reg2MPrbar= e(r2_a);


	* Local economic variables;
	*****************************;
	xtreg `var'disagr `var' mpCredibility mpCred`var' if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg4MPpointConst=_b[_cons];
	sca `var'Reg4MPseConst=_se[_cons];

	xtivreg2 `var'disagr `var' mpCredibility mpCred`var' if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg4MPpoint`var'=_b[`var'];
	sca `var'Reg4MPse`var'=_se[`var'];
	sca `var'Reg4MPpointConstCred=_b[mpCredibility];
	sca `var'Reg4MPseConstCred=_se[mpCredibility];
	sca `var'Reg4MPpoint`var'Cred=_b[mpCred`var'];
	sca `var'Reg4MPse`var'Cred=_se[mpCred`var'];
	sca `var'Reg4MPrbar= e(r2_a);

	xtreg `var'disagr `var' d`var'Sq mpCredibility mpCred`var' mpCredd`var'Sq if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg5MPpointConst=_b[_cons];
	sca `var'Reg5MPseConst=_se[_cons];

	xtivreg2 `var'disagr `var' d`var'Sq mpCredibility mpCred`var' mpCredd`var'Sq if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg5MPpoint`var'=_b[`var'];
	sca `var'Reg5MPse`var'=_se[`var'];
	sca `var'Reg5MPpointd`var'Sq=_b[d`var'Sq];
	sca `var'Reg5MPsed`var'Sq=_se[d`var'Sq];
	sca `var'Reg5MPpointConstCred=_b[mpCredibility];
	sca `var'Reg5MPseConstCred=_se[mpCredibility];
	sca `var'Reg5MPpoint`var'Cred=_b[mpCred`var'];
	sca `var'Reg5MPse`var'Cred=_se[mpCred`var'];
	sca `var'Reg5MPpointd`var'SqCred=_b[mpCredd`var'Sq];
	sca `var'Reg5MPsed`var'SqCred=_se[mpCredd`var'Sq];
	sca `var'Reg5MPrbar= e(r2_a);

	xtreg `var'disagr outputGapExpost mpCredibility mpCred`var' mpCredEpGap if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg6MPpointConst=_b[_cons];
	sca `var'Reg6MPseConst=_se[_cons];

	xtivreg2 `var'disagr outputGapExpost mpCredibility mpCred`var' mpCredEpGap if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg6MPpointGDP=_b[outputGapExpost];
	sca `var'Reg6MPseGDP=_se[outputGapExpost];
	sca `var'Reg6MPpointConstCred=_b[mpCredibility];
	sca `var'Reg6MPseConstCred=_se[mpCredibility];
	sca `var'Reg6MPpointGDPcred=_b[mpCredEpGap];
	sca `var'Reg6MPseGDPcred=_se[mpCredEpGap];
	sca `var'Reg6MPrbar= e(r2_a);

	xtreg `var'disagr `var' d`var'Sq outputGapExpost mpCredibility mpCred`var' mpCredd`var'Sq mpCredEpGap if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg7MPpointConst=_b[_cons];
	sca `var'Reg7MPseConst=_se[_cons];

	xtivreg2 `var'disagr `var' d`var'Sq outputGapExpost mpCredibility mpCred`var' mpCredd`var'Sq mpCredEpGap if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg7MPpoint`var'=_b[`var'];
	sca `var'Reg7MPse`var'=_se[`var'];
	sca `var'Reg7MPpointd`var'Sq=_b[d`var'Sq];
	sca `var'Reg7MPsed`var'Sq=_se[d`var'Sq];
	sca `var'Reg7MPpointGDP=_b[outputGapExpost];
	sca `var'Reg7MPseGDP=_se[outputGapExpost];
	sca `var'Reg7MPpointConstCred=_b[mpCredibility];
	sca `var'Reg7MPseConstCred=_se[mpCredibility];
	sca `var'Reg7MPpoint`var'Cred=_b[mpCred`var'];
	sca `var'Reg7MPse`var'Cred=_se[mpCred`var'];
	sca `var'Reg7MPpointd`var'SqCred=_b[mpCredd`var'Sq];
	sca `var'Reg7MPsed`var'SqCred=_se[mpCredd`var'Sq];
	sca `var'Reg7MPpointGDPcred=_b[mpCredEpGap];
	sca `var'Reg7MPseGDPcred=_se[mpCredEpGap];
	sca `var'Reg7MPrbar= e(r2_a);

	xtreg `var'disagr dprimeRateSq mpCredibility mpCredDprimeRateSq if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg8MPpointConst=_b[_cons];
	sca `var'Reg8MPseConst=_se[_cons];

	xtivreg2 `var'disagr dprimeRateSq mpCredibility mpCredDprimeRateSq if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg8MPpointRate=_b[dprimeRateSq];
	sca `var'Reg8MPseRate=_se[dprimeRateSq];
	sca `var'Reg8MPpointConstCred=_b[mpCredibility];
	sca `var'Reg8MPseConstCred=_se[mpCredibility];
	sca `var'Reg8MPpointRateCred=_b[mpCredDprimeRateSq];
	sca `var'Reg8MPseRateCred=_se[mpCredDprimeRateSq];
	sca `var'Reg8MPrbar= e(r2_a);

	xtreg `var'disagr `var' d`var'Sq dprimeRateSq mpCredibility mpCred`var' mpCredd`var'Sq mpCredDprimeRateSq if tin($startSmpl,$endSmpl), fe;
	sca `var'Reg9MPpointConst=_b[_cons];
	sca `var'Reg9MPseConst=_se[_cons];

	xtivreg2 `var'disagr `var' d`var'Sq dprimeRateSq mpCredibility mpCred`var' mpCredd`var'Sq mpCredDprimeRateSq if tin($startSmpl,$endSmpl), fe robust bw($robustLags);
	sca `var'Reg9MPpoint`var'=_b[`var'];
	sca `var'Reg9MPse`var'=_se[`var'];
	sca `var'Reg9MPpointd`var'Sq=_b[d`var'Sq];
	sca `var'Reg9MPsed`var'Sq=_se[d`var'Sq];
	sca `var'Reg9MPpointRate=_b[dprimeRateSq];
	sca `var'Reg9MPseRate=_se[dprimeRateSq];
	sca `var'Reg9MPpointConstCred=_b[mpCredibility];
	sca `var'Reg9MPseConstCred=_se[mpCredibility];
	sca `var'Reg9MPpoint`var'Cred=_b[mpCred`var'];
	sca `var'Reg9MPse`var'Cred=_se[mpCred`var'];
	sca `var'Reg9MPpointd`var'SqCred=_b[mpCredd`var'Sq];
	sca `var'Reg9MPsed`var'SqCred=_se[mpCredd`var'Sq];
	sca `var'Reg9MPpointRateCred=_b[mpCredDprimeRateSq];
	sca `var'Reg9MPseRateCred=_se[mpCredDprimeRateSq];
	sca `var'Reg9MPrbar= e(r2_a);

	* Descriptive Stats;
	****************************************************************************;
	sum `var'disagr  if tin($startSmpl,$endSmpl);
	sca `var'meanDisagrFullAll=r(mean);
	sca `var'varDisagrFullAll=r(Var);

	sum `var'  if tin($startSmpl,$endSmpl);
	sca `var'meanActualFullAll=r(Var);
	sca `var'varActualFullAll=r(Var);

	sum d`var'Sq  if tin($startSmpl,$endSmpl);
	sca `var'meanUncFullAll=r(mean);
	sca `var'varUncFullAll=r(Var);

	***********;
	sum `var'disagr  if tin($startSmpl,$splitSmpl);
	sca `var'meanDisagr1stHalfAll=r(mean);
	sca `var'varDisagr1stHalfAll=r(Var);

	sum `var'  if tin($startSmpl,$splitSmpl);
	sca `var'meanActual1stHalfAll=r(Var);	*** As opposed to the other 2 variables, I'm only interested in var, not mean;
	sca `var'varActual1stHalfAll=r(Var);	

	sum d`var'Sq  if tin($startSmpl,$splitSmpl);
	sca `var'meanUnc1stHalfAll=r(mean);
	sca `var'varUnc1stHalfAll=r(Var);

	***********;
	sum `var'disagr  if tin($splitSmplPlusOne,$endSmpl);
	sca `var'meanDisagr2ndHalfAll=r(mean);
	sca `var'varDisagr2ndHalfAll=r(Var);

	sum `var'  if tin($splitSmplPlusOne,$endSmpl);
	sca `var'meanActual2ndHalfAll=r(Var);	***;
	sca `var'varActual2ndHalfAll=r(Var);

	sum d`var'Sq  if tin($splitSmplPlusOne,$endSmpl);
	sca `var'meanUnc2ndHalfAll=r(mean);
	sca `var'varUnc2ndHalfAll=r(Var);

	***********;
	sum `var'disagr  if tin($startSmpl,$endSmpl)&Recession==0;
	sca `var'meanDisagrBoomAll=r(mean);
	sca `var'varDisagrBoomAll=r(Var);

	sum `var'  if tin($startSmpl,$endSmpl)&Recession==0;
	sca `var'meanActualBoomAll=r(Var);	***;
	sca `var'varActualBoomAll=r(Var);

	sum d`var'Sq  if tin($startSmpl,$endSmpl)&Recession==0;
	sca `var'meanUncBoomAll=r(mean);
	sca `var'varUncBoomAll=r(Var);

	***********;
	sum `var'disagr  if tin($startSmpl,$endSmpl)&Recession==1;
	sca `var'meanDisagrRecessionAll=r(mean);
	sca `var'varDisagrRecessionAll=r(Var);

	sum `var'  if tin($startSmpl,$endSmpl)&Recession==1;
	sca `var'meanActualRecessionAll=r(Var);	***;
	sca `var'varActualRecessionAll=r(Var);

	sum d`var'Sq  if tin($startSmpl,$endSmpl)&Recession==1;
	sca `var'meanUncRecessionAll=r(mean);
	sca `var'varUncRecessionAll=r(Var);	

	foreach C of local Ccodes {;
			
		sum `var'disagr  if country=="`C'"&tin($startSmpl,$endSmpl);
		sca `var'meanDisagrFull`C'=r(mean);
		sca `var'varDisagrFull`C'=r(Var);
	
		sum `var'  if country=="`C'"&tin($startSmpl,$endSmpl);
		sca `var'meanActualFull`C'=r(Var);
		sca `var'varActualFull`C'=r(Var);

		sum d`var'Sq  if country=="`C'"&tin($startSmpl,$endSmpl);
		sca `var'meanUncFull`C'=r(mean);
		sca `var'varUncFull`C'=r(Var);

		***********;
		sum `var'disagr  if country=="`C'"&tin($startSmpl,$splitSmpl);
		sca `var'meanDisagr1stHalf`C'=r(mean);
		sca `var'varDisagr1stHalf`C'=r(Var);
	
		sum `var'  if country=="`C'"&tin($startSmpl,$splitSmpl);
		sca `var'meanActual1stHalf`C'=r(Var);	*** As opposed to the other 2 variables, I'm only interested in var, not mean;
		sca `var'varActual1stHalf`C'=r(Var);	

		sum d`var'Sq  if country=="`C'"&tin($startSmpl,$splitSmpl);
		sca `var'meanUnc1stHalf`C'=r(mean);
		sca `var'varUnc1stHalf`C'=r(Var);

		***********;
		sum `var'disagr  if country=="`C'"&tin($splitSmplPlusOne,$endSmpl);
		sca `var'meanDisagr2ndHalf`C'=r(mean);
		sca `var'varDisagr2ndHalf`C'=r(Var);
	
		sum `var'  if country=="`C'"&tin($splitSmplPlusOne,$endSmpl);
		sca `var'meanActual2ndHalf`C'=r(Var);	***;
		sca `var'varActual2ndHalf`C'=r(Var);

		sum d`var'Sq  if country=="`C'"&tin($splitSmplPlusOne,$endSmpl);
		sca `var'meanUnc2ndHalf`C'=r(mean);
		sca `var'varUnc2ndHalf`C'=r(Var);

		***********;
		sum `var'disagr  if country=="`C'"&tin($startSmpl,$endSmpl)&Recession==0;
		sca `var'meanDisagrBoom`C'=r(mean);
		sca `var'varDisagrBoom`C'=r(Var);
	
		sum `var'  if country=="`C'"&tin($startSmpl,$endSmpl)&Recession==0;
		sca `var'meanActualBoom`C'=r(Var);	***;
		sca `var'varActualBoom`C'=r(Var);

		sum d`var'Sq  if country=="`C'"&tin($startSmpl,$endSmpl)&Recession==0;
		sca `var'meanUncBoom`C'=r(mean);
		sca `var'varUncBoom`C'=r(Var);

		***********;
		sum `var'disagr  if country=="`C'"&tin($startSmpl,$endSmpl)&Recession==1;
		sca `var'meanDisagrRecession`C'=r(mean);
		sca `var'varDisagrRecession`C'=r(Var);
	
		sum `var'  if country=="`C'"&tin($startSmpl,$endSmpl)&Recession==1;
		sca `var'meanActualRecession`C'=r(Var);	***;
		sca `var'varActualRecession`C'=r(Var);

		sum d`var'Sq  if country=="`C'"&tin($startSmpl,$endSmpl)&Recession==1;
		sca `var'meanUncRecession`C'=r(mean);
		sca `var'varUncRecession`C'=r(Var);
	};

	* Print tables;
	****************************************************************************;
	qui do "`basepath'stata/write/writeDisagreementTabPanel.do";			
	qui do "`basepath'stata/write/writeDisagreementTabPanelSub.do";			
	qui do "`basepath'stata/write/writeDisagreementTabPanelSubMP.do";			

};

qui do "`basepath'stata/write/writeSumStatAllCountriesAllVars_v3.do";			

*************************************************************************************************************************************;
log close;



