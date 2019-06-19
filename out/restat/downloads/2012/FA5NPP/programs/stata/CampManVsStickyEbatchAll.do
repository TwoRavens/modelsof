
**********************************************************************************
* Carroll, Slacalek & Sommer: International Evidence on Sticky Consumption Growth
* February 15, 2008
* ccarroll@jhu.edu, jiri.slacalek@gmail.com, msommer@imf.org
*
* This Stata 8.0 program replicates all IV results in the paper and produces LaTeX 
* code for tables 1, 2, 3 and 5
**********************************************************************************
clear
#delimit;
*sysdir set PERSONAL "J:\ado\";
version 8.0;

set more off;
global basePath "C:\Jirka\Research\intStickyC\cssIntlStickyC"; 
global dataPath $basePath\programs\data;  
global logPath $basePath\programs\stata;
global docPath $basePath\programs\text\;
cd $logPath;
capture log close;
log using $logPath\CampManVsStickyEBatchAll.log, replace;

global nwLags "4";				* # of lags for Newey-West std errors;
global ivLagsStart "1";			* # of start lags in 1st stage regressions;
global ivLagsEnd "3";			* # of end lags in 1st stage regressions;
global cStarIndex "0";			* Do you want to use the true consumption (cStar)? Default: NO(0);
global totalPCEindex "0";		* Estimate results with total PCE even for G7 countries? Default: No(0);

global cntryNumber "1";			* counter for the loops (should be 1);
global eolString "_char(92) _char(92)";		* string denoting new line in LaTeX tables \\;

* Instrument sets;	
*****************************************************;
* Instruments lagged t-3 and earlier;
* global ivLagsStart=$ivLagsStart+1;
* global ivLagsEnd=$ivLagsEnd+1;

global ivLagsStart2=$ivLagsStart+1;	* # MUST be equal to ivLagsStart plus 1!!;
global ivLagsEnd2=$ivLagsEnd+1;		* # MUST be equal to ivLagsEndEnd plus 1!!;
global ivLagsStart2Plus1=$ivLagsStart2+1;

* Alternative Instrument Set;
*global ivset1 "L($ivLagsStart/$ivLagsEnd).un L($ivLagsStart/$ivLagsEnd).dinc L($ivLagsStart/$ivLagsEnd).irSpread";
*global ivset2 "L($ivLagsStart2/$ivLagsEnd2).un L($ivLagsStart2/$ivLagsEnd2).dinc L($ivLagsStart2/$ivLagsEnd2).irSpread"; 
*global tLab "Alt";

*****************************************************;
* Baseline instruments;
global ivset1 "L($ivLagsStart/$ivLagsEnd).un L($ivLagsStart/$ivLagsEnd).lr L($ivLagsStart/$ivLagsEnd).pceinfvol"; 
global ivset2 "L($ivLagsStart2/$ivLagsEnd2).un L($ivLagsStart2/$ivLagsEnd2).lr L($ivLagsStart2/$ivLagsEnd2).pceinfvol"; 
global tLab "";

* Merge all files;
**********************************************************************************************;
use $dataPath\dataG7countries.dta;	* G7;
sort nobs;
save $dataPath\dataG7countriesSorted.dta, replace;
drop _all;

use $dataPath\cStar.dta;				* Kalman filter "true" consumption growth;
sort nobs;
save $dataPath\cStarSorted.dta, replace;
drop _all;

use $dataPath\dataAllCountries.dta;
sort nobs;
merge nobs using $dataPath\dataG7countriesSorted.dta;
rename _merge _merge_g7;
sort nobs;
merge nobs using $dataPath\cStarSorted.dta;
rename _merge _merge_cStar;
sort nobs;

gen t =  q(1960q1)+_n-1;
format t %tq;
tsset t;

save $dataPath\dataAllCountriesMerged.dta, replace;

**********************************************************************************************;
*;
* Do all 16 countries countries, total PCE constumption;
**********************************************************************************************;
local allCountries "us au bg cn dk fn fr ge it nl sd sp uk";	* country list (for for loops); 

* time frames, sentiment availability, last lags;
* time frames, sentiment availability, last lags;
global startRegau "1975q4"; global endRegau "1999q4"; global lagsau "20"; global sentVarau "L($ivLagsStart/$ivLagsEnd).sent"; global sentVar2au "L($ivLagsStart2/$ivLagsEnd2).sent";
global startRegbg "1980q2"; global endRegbg "2002q4"; global lagsbg "8"; global sentVarbg " "; global sentVar2bg " ";
global startRegcn "1970q4"; global endRegcn "2002q2"; global lagscn "5"; global sentVarcn "L($ivLagsStart/$ivLagsEnd).sent"; global sentVar2cn "L($ivLagsStart2/$ivLagsEnd2).sent";
global startRegdk "1977q1"; global endRegdk "2003q2"; global lagsdk "12"; global sentVardk " "; global sentVar2dk " ";
global startRegfn "1979q1"; global endRegfn "2003q1"; global lagsfn "7"; global sentVarfn " "; global sentVar2fn " ";
global startRegfr "1973q3"; global endRegfr "2003q2"; global lagsfr "6"; global sentVarfr "L($ivLagsStart/$ivLagsEnd).sent"; global sentVar2fr "L($ivLagsStart2/$ivLagsEnd2).sent";
global startRegge "1975q1"; global endRegge "2003q2"; global lagsge "52"; global sentVarge "L($ivLagsStart/$ivLagsEnd).sent"; global sentVar2ge "L($ivLagsStart2/$ivLagsEnd2).sent";
global startRegit "1978q4"; global endRegit "2003q2"; global lagsit "6"; global sentVarit "L($ivLagsStart/$ivLagsEnd).sent"; global sentVar2it "L($ivLagsStart2/$ivLagsEnd2).sent";
global startRegnl "1975q1"; global endRegnl "2002q4"; global lagsnl "9"; global sentVarnl " "; global sentVar2nl " ";
global startRegsd "1977q1"; global endRegsd "2002q4"; global lagssd "8"; global sentVarsd " "; global sentVar2sd " ";
global startRegsp "1978q1"; global endRegsp "1999q4"; global lagssp "8"; global sentVarsp " "; global sentVar2sp " ";
global startReguk "1974q4"; global endReguk "2004q4"; global lagsuk "5"; global sentVaruk "L($ivLagsStart/$ivLagsEnd).sent"; global sentVar2uk "L($ivLagsStart2/$ivLagsEnd2).sent";
global startRegus "1964q1"; global endRegus "2003q4"; global lagsus "5"; global sentVarus "L($ivLagsStart/$ivLagsEnd).sent"; global sentVar2us "L($ivLagsStart2/$ivLagsEnd2).sent";

mat t1pointAll=(.,.,.,.,.,.,.,.,.,.);
mat t1seAll=(.,.,.,.,.,.,.);
mat t1pvalAll=(.,.,.);

do transformData;			* do some data transformations;

* Estimation;
**********************************************************************************;
foreach cName of local allCountries {;
	global cNameGlob `cName';
	global startReg1 "startReg`cName'";
	global endReg1 "endReg`cName'";
	global startReg $$startReg1;	* start of the sample;
	global endReg $$endReg1;		* end of the sample;

	global sentVar1 "sentVar`cName'";
	global sentVar2 "sentVar2`cName'";
	global ivset1all "$ivset1 $$sentVar1";
	global ivset2all "$ivset2 $$sentVar2";
	disp "`cName'  $startReg   $endReg";
	disp "**********************************************************************************";

	gen inc=l`cName'income;
	gen wyRatio = wyRatio`cName'; *gen wlth = `cName'wealthIncRatio;
	
	gen lr = `cName'lr;
	gen r3m = `cName'r3m;
	gen un = `cName'u;
	gen infl = `cName'cinfl;
	gen irSpread = `cName'irSpread;
	gen sRet = d`cName'qp;
	gen sent = `cName'sent;
	gen pceinfvol = `cName'pceinfvol;

	gen dcnsm=100*(D.l`cName'c);
	gen dinc=100*(D.inc);
	gen dr3m = D.r3m;
	gen dun=D.un;
	gen dirSpread=D.irSpread;
	gen dlr=D.lr;
		
	if $cStarIndex==1 {;	* true consumption growth;
		replace dcnsm=100*`cName'_c_star;
	};

	* Estimate IV Regressions;
	do CampManVsStickyETableFunction.do;
		
	* Extract results;
	scalar `cName'VarC = varC;
	scalar `cName'Bbase = bBase;
	sca `cName'VarY = varY;
	
	sum dinc, det;
	corr dinc L.dinc, cov;
	corr dinc L.dinc;
	
	gen dcons`cName'fit=dcnsmFit;
	drop dcnsm inc dinc wyRatio  r3m dr3m un infl irSpread sRet sent dun dirSpread lr pceinfvol dlr dcnsmFit;

	mat t1pointAll=(t1pointAll\ t1point);
	mat t1seAll=(t1seAll\ t1se);
	mat t1pvalAll=(t1pvalAll\ t1pval);
	mat t1point`cName'=t1point;
	mat t1se`cName'=t1se;	
};

mat t1pointPCEAll=t1pointAll[2..14,1..10];
mat t1sePCEAll=t1seAll[2..14,1..7];
mat t1pvalPCEAll=t1pvalAll[2..14,1..3];

*******************************************************************************************;
* DO G7 COUNTRIES;
*******************************************************************************************;
global cntryNumber "1";			* counter for the loops (should be 1);

* time frames;
global startReg_can "1970q4"; global endReg_can "2002q3";
global startReg_fra "1985q1"; global endReg_fra "2003q4";
global startReg_deu "1975q4"; global endReg_deu "2002q4";
global startReg_ita "1981q1"; global endReg_ita "2003q4";
global startReg_gbr "1974q1"; global endReg_gbr "2003q4";
global startReg_usa "1962q3"; global endReg_usa "2004q2";

mat t1pointG7All=(.,.,.,.,.,.,.,.,.,.);
mat t1seG7All=(.,.,.,.,.,.,.);
mat t1pvalG7All=(.,.,.);

local allCountriesG7 "can deu fra gbr ita usa";	* country list (for for loops); 

do transformDataG7;			* do some data transformations (including perm-trans decomp of income);

global ivset1all "$ivset1 L($ivLagsStart/$ivLagsEnd).sent";
global ivset2all "$ivset2 L($ivLagsStart2/$ivLagsEnd2).sent";

* Estimation;
**********************************************************************************;
foreach cName of local allCountriesG7 {;
	global cNameGlob `cName';
	global startReg1 "startReg_`cName'";
	global endReg1 "endReg_`cName'";
	global startReg $$startReg1;	* start of the sample;
	global endReg $$endReg1;		* end of the sample;

	disp "`cName'  $startReg   $endReg";
	disp "**********************************************************************************";

	gen dcnsm=100*diffndscPC_`cName';	* nondurables+services(+semidurables);
	gen dinc=100*diffrpdiPC_`cName';
	gen wyRatio=wyRatio_`cName';

	gen lr = lr_`cName';
	gen r3m = rsr_`cName';
	gen un = u_`cName';
	gen infl = infl_`cName';
	gen irSpread = irSpread_`cName';
	gen sRet = diffsp_`cName';
	gen sent = sen_`cName';
	gen pceinfvol = `cName'pceinfvol;
	
	gen dr3m = D.r3m;
	gen dun=D.un;
	gen dirSpread=D.irSpread;
	gen dlr=D.lr;

	if $cStarIndex==1 {;	* true consumption growth;
		replace dcnsm=100*`cName'_c_star;
	};

	* Estimate IV Regressions;
	do CampManVsStickyETableFunction.do;
		
	* Extract results;
	mat t1pointG7All=(t1pointG7All\ t1point);
	mat t1seG7All=(t1seG7All\ t1se);
	mat t1pvalG7All=(t1pvalG7All\ t1pval);
	mat t1pointG7`cName'=t1point;
	mat t1seG7`cName'=t1se;	

	scalar `cName'VarC = varC;
	scalar `cName'Bbase = bBase;
	sca `cName'VarY = varY;
	
	sum dinc, det;
	corr dinc L.dinc, cov;
	corr dinc L.dinc;
	
	gen dcons`cName'fit=dcnsmFit;
	drop dcnsm dinc wyRatio r3m dr3m un infl irSpread sRet sent dun dirSpread lr pceinfvol dlr dcnsmFit;
};

mat t1pointG7All=t1pointG7All[2..7,1..10];
mat t1seG7All=t1seG7All[2..7,1..7];
mat t1pvalG7All=t1pvalG7All[2..7,1..3];

**********************************************************************************;
* Write the Tables;
**********************************************************************************;
* Clean the "one line per country" file;
tempname hh;
file open `hh' using "$docPath\tables\tAllCountriesFin.tex", write replace;
file write `hh' "  "_n;
file write `hh' "\begin{sidewaystable}\small" _n;
file write `hh' "\caption{ Consumption Dynamics---All Countries } \label{tAllC$tLab}" _n;
file write `hh' "\begin{center}" _n;
file write `hh' "\begin{tabular}{@{}ld{4}d{6}d{4}d{6}d{4}d{6}d{3}d{4}d{4}d{4}d{4}@{}}" _n;
global consLb "C";
if $cStarIndex==1 {; 
	global consLb "C^*";
};
file write `hh' "\multicolumn{12}{c}{ \$\Delta\log " "$consLb" "_{t}=\varsigma+\chi\mathbb{E}_{t-2}[\Delta\log " "$consLb" "_{t-1}]+\eta\mathbb{E}_{t-2}[\Delta\log{Y}_{t}]+\alpha \mathbb{E}_{t-2}[a_{t-1}]\$ } " $eolString _n "\toprule" _n;
file write `hh' "   &   \multicolumn{7}{c}{Estimation with } &  \multicolumn{4}{c}{Estimation with } " $eolString _n;
file write `hh' "   &   \multicolumn{7}{c}{one regressor only} &  \multicolumn{4}{c}{all three regressors}" $eolString _n;

file write `hh' " \cmidrule(r){2-8} \cmidrule(l){9-12} " _n;
file write `hh' "   & & \multicolumn{1}{c}{CLR p val\${}^\diamond\$} & &\multicolumn{1}{c}{CLR p val\${}^\diamond\$}  &  & \multicolumn{1}{c}{CLR p val\${}^\diamond\$} & & & & & " $eolString _n;
file write `hh' " Country & \multicolumn{1}{c}{\$\chi\$} & \multicolumn{1}{c}{\$\chi=0\$} & \multicolumn{1}{c}{\$\eta\$} & \multicolumn{1}{c}{\$\eta=0\$}  &  \multicolumn{1}{c}{\$\alpha\$} &  \multicolumn{1}{c}{\$\alpha=0\$} &  \multicolumn{1}{c}{\$\bar{R}^2_c\$} & \multicolumn{1}{c}{\$\chi\$}  & \multicolumn{1}{c}{\$\eta\$}  &  \multicolumn{1}{c}{\$\alpha\$} & \multicolumn{1}{c}{OID}" $eolString _n "\midrule" _n
"\multicolumn{12}{l}{\null{}\null{}\null{}G7 Countries}" $eolString _n;
file close `hh';
**********************************************************************************;

* G7 countries;
gen countryCaption="Canada\${}^\star\$";
replace countryCaption="France\${}^\star\$" in 2;
replace countryCaption="Germany\${}^\star\$" in 3;
replace countryCaption="Italy\${}^\star\$" in 4;
replace countryCaption="United Kingdom\${}^\star\$" in 5;
replace countryCaption="United States\${}^\star\$" in 6;

mat t1pointAllTemp=(
t1pointG7All[1,1..9]\
t1pointG7All[3,1..9]\
t1pointG7All[2,1..9]\
t1pointG7All[5,1..9]\
t1pointG7All[4,1..9]\
t1pointG7All[6,1..9]
);

mat t1seAllTemp=(
t1seG7All[1,1..7]\
t1seG7All[3,1..7]\
t1seG7All[2,1..7]\
t1seG7All[5,1..7]\
t1seG7All[4,1..7]\
t1seG7All[6,1..7]
);

mat t1pvalAllTemp=(
t1pvalG7All[1,1..3]\
t1pvalG7All[3,1..3]\
t1pvalG7All[2,1..3]\
t1pvalG7All[5,1..3]\
t1pvalG7All[4,1..3]\
t1pvalG7All[6,1..3]
);


if $totalPCEindex==1 {;

	mat t1pointAllTemp=(
	t1pointPCEAll[4,1..9]\
	t1pointPCEAll[7,1..9]\
	t1pointPCEAll[8,1..9]\
	t1pointPCEAll[9,1..9]\
	t1pointPCEAll[13,1..9]\
	t1pointPCEAll[1,1..9]
	);

	mat t1seAllTemp=(
	t1sePCEAll[4,1..7]\
	t1sePCEAll[7,1..7]\
	t1sePCEAll[8,1..7]\
	t1sePCEAll[9,1..7]\
	t1sePCEAll[13,1..7]\
	t1sePCEAll[1,1..7]
	);

	mat t1pvalAllTemp=(
	t1pvalPCEAll[4,1..3]\
	t1pvalPCEAll[7,1..3]\
	t1pvalPCEAll[8,1..3]\
	t1pvalPCEAll[9,1..3]\
	t1pvalPCEAll[13,1..3]\
	t1pvalPCEAll[1,1..3]
	);
};

mat t1pointWhole=t1pointAllTemp;
mat t1seWhole=t1seAllTemp;
mat t1pvalWhole=t1pvalAllTemp;

mat t1pointMean=
(t1pointAllTemp[1,1..7]+t1pointAllTemp[2,1..7]+t1pointAllTemp[3,1..7]+t1pointAllTemp[4,1..7]+t1pointAllTemp[5,1..7]+t1pointAllTemp[6,1..7])/6;
mat t1seMean=
(t1seAllTemp[1,1..7]+t1seAllTemp[2,1..7]+t1seAllTemp[3,1..7]+t1seAllTemp[4,1..7]+t1seAllTemp[5,1..7]+t1seAllTemp[6,1..7])/6;
mat t1pointMean=(t1pointMean[1,1..7],.,.);

forval num=1/6 {;
	global rowCounter=`num';
	do writeTableCampManVsStickyEoneLine.do;
};

* Write the "Mean" row;
global rowCounter "1";
replace countryCaption="Mean G7";
mat t1pointAllTemp=t1pointMean;
mat t1seAllTemp=t1seMean;
mat t1pvalAllTemp=(.,.,.);
tempname hh;
file open `hh' using "$docPath\tables\tAllCountriesFin.tex", write append;
file write `hh' "\midrule" _n;
file close `hh';
do writeTableCampManVsStickyEoneLine.do;
tempname hh;
file open `hh' using "$docPath\tables\tAllCountriesFin.tex", write append;
file write `hh' "\midrule" _n "\multicolumn{12}{l}{\null{}\null{}\null{}Other Countries}" $eolString;
file close `hh';

* Write the small countries;
replace countryCaption="Australia\${}^\ddagger\$";
replace countryCaption="Belgium\${}^\ddagger\$" in 2;
replace countryCaption="Denmark\${}^\ddagger\$" in 3;
replace countryCaption="Finland\${}^\ddagger\$" in 4;
replace countryCaption="Netherlands\${}^\ddagger\$" in 5;
replace countryCaption="Spain\${}^\ddagger\$" in 6;
replace countryCaption="Sweden\${}^\ddagger\$" in 7;

mat t1pointAllTemp=(
t1pointPCEAll[2,1..9]\
t1pointPCEAll[3,1..9]\
t1pointPCEAll[5,1..9]\
t1pointPCEAll[6,1..9]\
t1pointPCEAll[10,1..9]\
t1pointPCEAll[12,1..9]\
t1pointPCEAll[11,1..9]
);

mat t1seAllTemp=(
t1sePCEAll[2,1..7]\
t1sePCEAll[3,1..7]\
t1sePCEAll[5,1..7]\
t1sePCEAll[6,1..7]\
t1sePCEAll[10,1..7]\
t1sePCEAll[12,1..7]\
t1sePCEAll[11,1..7]
);

mat t1pvalAllTemp=(
t1pvalPCEAll[2,1..3]\
t1pvalPCEAll[3,1..3]\
t1pvalPCEAll[5,1..3]\
t1pvalPCEAll[6,1..3]\
t1pvalPCEAll[10,1..3]\
t1pvalPCEAll[12,1..3]\
t1pvalPCEAll[11,1..3]
);

mat t1pointWhole=(t1pointWhole\t1pointAllTemp);
mat t1seWhole=(t1seWhole\t1seAllTemp);

mat t1pointSmallAll=t1pointAllTemp;
mat t1seSmallAll=t1seAllTemp;

mat t1pointMean=
(t1pointAllTemp[1,1..7]+t1pointAllTemp[2,1..7]+t1pointAllTemp[3,1..7]+t1pointAllTemp[4,1..7]+t1pointAllTemp[5,1..7]+t1pointAllTemp[6,1..7]+t1pointAllTemp[7,1..7])/7;
mat t1seMean=
(t1seAllTemp[1,1..7]+t1seAllTemp[2,1..7]+t1seAllTemp[3,1..7]+t1seAllTemp[4,1..7]+t1seAllTemp[5,1..7]+t1seAllTemp[6,1..7]+t1seAllTemp[7,1..7])/7;

forval num=1/7 {;
	global rowCounter=`num';
	do writeTableCampManVsStickyEoneLine.do;
};

* Write the "Mean" row for small countries;
global rowCounter "1";
replace countryCaption="Mean Other";
mat t1pointAllTemp=t1pointMean;
mat t1seAllTemp=t1seMean;
mat t1pvalAllTemp=(.,.,.);
tempname hh;
file open `hh' using "$docPath\tables\tAllCountriesFin.tex", write append;
file write `hh' "\midrule" _n;
file close `hh';
do writeTableCampManVsStickyEoneLine.do;

* Finish the table;
tempname hh;
file open `hh' using "$docPath\tables\tAllCountriesFin.tex", write append;
file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' " Instruments: \footnotesize\texttt{";
foreach c of global ivset2all {;
	file write `hh' "`c' ";
	};
file write `hh' "}";
file write `hh' $eolString "\showEstTime{Estimated: $S_DATE, $S_TIME}" $eolString _n;

global consLb1 ""; global consLb2 ",";
if $cStarIndex==1 {; 
	global consLb1 " true ";
	global consLb2 " from the Kalman smoother,";
};

file write `hh' " {\footnotesize Notes: Left Panel: Regressions were estimated with one regressor only. Right Panel: Regressions were estimated with all three regressors. \$\diamond\$: p value of the null hypothesis that the parameter equals 0 tested using the HAC robust version of the conditional likelihood ratio (HAR-CLR) test of \citet{andrewsEtal:weakInstruments_nberWP}, window:";
file write `hh' " $clrLags ";
file write `hh' " lags. Consumption variable: \$\star\$:    $consLb1 ";
file write `hh' " $consLb2";file write `hh' " nondurables, semidurables and services consumption";
file write `hh' " $consLb2";
file write `hh' " \$\ddagger\$: $consLb1 total personal consumption expenditure" "$consLb2" " \$a\$: ratio of household financial wealth to income. \$\{{}^*,{}^{**},{}^{***}\}={}\$Statistical significance at \$\{10,5,1\}\$ percent (using robust standard errors). \$\bar{R}^2_c\$: Adjusted \$R^2\$ from the first-stage regression of consumption growth on instruments. OID: p-value from the Hansen's \$J\$ statistic for overidentification.}" _n;
file write `hh' "\end{sidewaystable} " _n;
file close `hh';

* Summary Table;
**********************************************************************************;
mat tPointSumAll=(t1pointau+t1pointG7can+t1pointG7fra+t1pointG7deu+t1pointG7ita+t1pointG7gbr+t1pointG7usa+t1pointbg+t1pointdk+t1pointfn+t1pointnl+t1pointsd+t1pointsp)/13;
mat tSeSumAll=(t1seau+t1seG7can+t1seG7fra+t1seG7deu+t1seG7ita+t1seG7gbr+t1seG7usa+t1sebg+t1sedk+t1sefn+t1senl+t1sesd+t1sesp)/13;

mat tPointSumG7=(t1pointG7can+t1pointG7fra+t1pointG7deu+t1pointG7ita+t1pointG7gbr+t1pointG7usa)/6;
mat tSeSumG7=(t1seG7can+t1seG7fra+t1seG7deu+t1seG7ita+t1seG7gbr+t1seG7usa)/6;

mat tPointSumAngloSaxon=(t1pointau+t1pointG7can+t1pointG7gbr+t1pointG7usa)/4;
mat tSeSumAngloSaxon=(t1seau+t1seG7can+t1seG7gbr+t1seG7usa)/4;

mat tPointSumEuroArea=(t1pointG7fra+t1pointG7deu+t1pointG7ita+t1pointbg+t1pointfn+t1pointnl+t1pointsp)/7;
mat tSeSumEuroArea=(t1seG7fra+t1seG7deu+t1seG7ita+t1sebg+t1sefn+t1senl+t1sesp)/7;

mat tPointSumEuroUnion=(t1pointG7fra+t1pointG7deu+t1pointG7ita+t1pointG7gbr+t1pointbg+t1pointdk+t1pointfn+t1pointnl+t1pointsd+t1pointsp)/10;
mat tSeSumEuroUnion=(t1seG7fra+t1seG7deu+t1seG7ita+t1seG7gbr+t1sebg+t1sedk+t1sefn+t1senl+t1sesd+t1sesp)/10;

* Write Summary Tables;
**********************************************************************************;
do  writeTableCampManVsStickyEallCgroupsFin;

mat li t1pointWhole, format(%5.3f);
mat li t1seWhole, format(%5.3f);
**********************************************************************************;
log close;	
