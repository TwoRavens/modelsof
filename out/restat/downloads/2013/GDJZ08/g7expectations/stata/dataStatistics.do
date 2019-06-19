
/*

The program calculates some basic descriptive statistics and draws histograms on initial processing of the data (fraction of available, inter/extra-polated observations and missing data

*/

clear 
set more off
set mem 150m

*version 9.1
#delimit;
adopath + C:\ado\egenodd;


*cd "`basepath'stata";
local basepath "C:\Jirka\Research\g7expectations\g7expectations\";
local docpath "`basepath'\docs/paper/tables/appendix/obsStats";
global eolString "_char(92) _char(92)";		* string denoting new line in LaTeX tables \\;

cd "`basepath'stata\";

capture log close;
log using dataStatistics.log, replace;


local Ccodes cn fr ge it jp uk us;
local variable infl gdp ip inv cons un r3m;
local Numbers "33 40 46 35 44 61 60";  * MAKE SURE THE ORDER CORRESPONDS TO THE ORDER OF COUNTRIES!;
local maxnum 61;


*******************************************************************************************************;
local i = 1;
tempname hh;
file open `hh' using "`docpath'/tObsStats_sum.tex", write replace;
file write `hh' _n;
file close `hh';

tempname hh;
file open `hh' using "`docpath'/tSwitches_sum.tex", write replace;
file write `hh' _n;
file close `hh';

foreach c of local Ccodes {;
	local N: word `i' of `Numbers';
	local ++i;

	foreach var of local variable {;
		use "`basepath'data/detailed/_`c'`var'.dta", replace;
		
		rename index time;
		replace time = time + 347;
		format t %tm;
		tsset time, monthly;

		mat `c'`var'=(.,.,.,.,.,.,.,.,.,.,.);
		mat colnames `c'`var' = id orig interp extrap miss total orig interp extrap miss total;
		mat tempRowSum=(0,0,0,0,0,0,0,0,0,0);
		mat tempRowSumSwitch=(0,0,0,0,0,0,0,0,0,0,0,0,0);
		
		******* Clean the TeX file for the table;
		tempname hh;
		file open `hh' using "`docpath'/tSwitches_`c'`var'.tex", write replace;
		file write `hh' _n;
		file close `hh';

		tempname hh;
		file open `hh' using "`docpath'/tObsStats_`c'`var'.tex", write replace;
		file write `hh' _n;
		file close `hh';

		forvalues n = 5/`N' {;
			forvalues y = 0/1 {;
				qui count if `c'`var'`n'`y'_ipFlag==-1;
				sca `c'`var'`n'`y'_miss=r(N);

				qui count if `c'`var'`n'`y'_ipFlag==0;
				sca `c'`var'`n'`y'_orig=r(N);

				qui count if `c'`var'`n'`y'_ipFlag==1;
				sca `c'`var'`n'`y'_interp=r(N);

				qui count if `c'`var'`n'`y'_ipFlag>1;
				sca `c'`var'`n'`y'_extrap=r(N);
				
				sca `c'`var'`n'`y'_all=`c'`var'`n'`y'_miss+`c'`var'`n'`y'_orig+`c'`var'`n'`y'_interp+`c'`var'`n'`y'_extrap;
				sca `c'`var'`n'`y'_nonmiss=`c'`var'`n'`y'_orig+`c'`var'`n'`y'_interp+`c'`var'`n'`y'_extrap;
				
				* count switches in expectations;
				********************************************************************;
				qui count if `c'`var'`n'`y'~=.&L.`c'`var'`n'`y'~=.&month~=1;
				sca totConti_`c'`var'`n'`y'=r(N);
				qui count if `c'`var'`n'`y'~=.&L.`c'`var'`n'1~=.&month==1;	* January is special (because a new year starts);
				if `y'==0 {; sca totConti_`c'`var'`n'`y'=totConti_`c'`var'`n'`y'+r(N); };
				
				* 1M (ie have the expectations changed in the past two months? ***************************************************************;
				qui count if `c'`var'`n'`y'~=.&`c'`var'`n'`y'==L.`c'`var'`n'`y'&month~=1;
				sca nonSwitches_`c'`var'`n'`y'=r(N);	
				qui count if `c'`var'`n'`y'~=.&`c'`var'`n'`y'==L.`c'`var'`n'1&month==1;	
				if `y'==0 {; sca nonSwitches_`c'`var'`n'`y'=nonSwitches_`c'`var'`n'`y'+r(N); };
				sca FracNonSwitches_`c'`var'`n'`y'=nonSwitches_`c'`var'`n'`y'/totConti_`c'`var'`n'`y';
								
				* 2M ***************************************************************;
				qui count if `c'`var'`n'`y'~=.&`c'`var'`n'`y'==L.`c'`var'`n'`y'&`c'`var'`n'`y'==L2.`c'`var'`n'`y'&month>2;
				sca nonSwitches2m_`c'`var'`n'`y'=r(N);	
				qui count if `c'`var'`n'`y'~=.&`c'`var'`n'`y'==L.`c'`var'`n'1&`c'`var'`n'`y'==L2.`c'`var'`n'1&month==1;
				if `y'==0 {; sca nonSwitches2m_`c'`var'`n'`y'=nonSwitches2m_`c'`var'`n'`y'+r(N); };
				qui count if `c'`var'`n'`y'~=.&`c'`var'`n'`y'==L.`c'`var'`n'`y'&`c'`var'`n'`y'==L2.`c'`var'`n'1&month==2;
				if `y'==0 {; sca nonSwitches2m_`c'`var'`n'`y'=nonSwitches2m_`c'`var'`n'`y'+r(N); };
				sca FracNonSwitches2m_`c'`var'`n'`y'=nonSwitches2m_`c'`var'`n'`y'/totConti_`c'`var'`n'`y';
			
				* 3M ***************************************************************;
				qui count if `c'`var'`n'`y'~=.&`c'`var'`n'`y'==L.`c'`var'`n'`y'&`c'`var'`n'`y'==L2.`c'`var'`n'`y'&`c'`var'`n'`y'==L3.`c'`var'`n'`y'&month>3;
				sca nonSwitches3m_`c'`var'`n'`y'=r(N);	
				qui count if `c'`var'`n'`y'~=.&`c'`var'`n'`y'==L.`c'`var'`n'1&`c'`var'`n'`y'==L2.`c'`var'`n'1&`c'`var'`n'`y'==L3.`c'`var'`n'1&month==1;
				if `y'==0 {; sca nonSwitches3m_`c'`var'`n'`y'=nonSwitches3m_`c'`var'`n'`y'+r(N); };
				qui count if `c'`var'`n'`y'~=.&`c'`var'`n'`y'==L.`c'`var'`n'`y'&`c'`var'`n'`y'==L2.`c'`var'`n'1&`c'`var'`n'`y'==L3.`c'`var'`n'1&month==2;
				if `y'==0 {; sca nonSwitches3m_`c'`var'`n'`y'=nonSwitches3m_`c'`var'`n'`y'+r(N); };
				qui count if `c'`var'`n'`y'~=.&`c'`var'`n'`y'==L.`c'`var'`n'`y'&`c'`var'`n'`y'==L2.`c'`var'`n'`y'&`c'`var'`n'`y'==L3.`c'`var'`n'1&month==3;
				if `y'==0 {; sca nonSwitches3m_`c'`var'`n'`y'=nonSwitches3m_`c'`var'`n'`y'+r(N); };
				sca FracNonSwitches3m_`c'`var'`n'`y'=nonSwitches3m_`c'`var'`n'`y'/totConti_`c'`var'`n'`y';
			};
				
			* Both years
			* count switches in expectations;
			qui count if `c'`var'`n'0~=.&L.`c'`var'`n'0~=.&`c'`var'`n'1~=.&L.`c'`var'`n'1~=.&month>1;
			sca totConti1m_`c'`var'`n'Both=r(N);
			
			qui count if `c'`var'`n'0~=.&`c'`var'`n'0==L.`c'`var'`n'0&`c'`var'`n'1~=.&`c'`var'`n'1==L.`c'`var'`n'1&month>1;
			sca FracNonSwitches_`c'`var'`n'Both=r(N)/totConti1m_`c'`var'`n'Both;	

			qui count if `c'`var'`n'0~=.&L.`c'`var'`n'0~=.&`c'`var'`n'1~=.&L.`c'`var'`n'1~=.&month>2;
			sca totConti2m_`c'`var'`n'Both=r(N);

			qui count if `c'`var'`n'0~=.&`c'`var'`n'0==L.`c'`var'`n'0&`c'`var'`n'0==L2.`c'`var'`n'0&`c'`var'`n'1~=.&`c'`var'`n'1==L.`c'`var'`n'1&`c'`var'`n'1==L2.`c'`var'`n'1&month>2;
			sca FracNonSwitches2m_`c'`var'`n'Both=r(N)/totConti2m_`c'`var'`n'Both;	

			qui count if `c'`var'`n'0~=.&L.`c'`var'`n'0~=.&`c'`var'`n'1~=.&L.`c'`var'`n'1~=.&month>3;
			sca totConti3m_`c'`var'`n'Both=r(N);

			qui count if `c'`var'`n'0~=.&`c'`var'`n'0==L.`c'`var'`n'0&`c'`var'`n'0==L2.`c'`var'`n'0&`c'`var'`n'0==L3.`c'`var'`n'0&`c'`var'`n'1~=.&`c'`var'`n'1==L.`c'`var'`n'1&`c'`var'`n'1==L2.`c'`var'`n'1&`c'`var'`n'1==L3.`c'`var'`n'1&month>3;
			sca FracNonSwitches3m_`c'`var'`n'Both=r(N)/totConti3m_`c'`var'`n'Both;	
			********************************************************************;
			
			mat tempRow=(`c'`var'`n'0_orig, `c'`var'`n'0_interp, `c'`var'`n'0_extrap, `c'`var'`n'0_miss,  `c'`var'`n'0_all, `c'`var'`n'1_orig, `c'`var'`n'1_interp, `c'`var'`n'1_extrap, `c'`var'`n'1_miss,  `c'`var'`n'1_all);
			mat tempRowSum=tempRowSum+tempRow;
			mat `c'`var'=(`c'`var'\ (`n'-4), tempRow);
			
			mat tempRowSwitch=(`c'`var'`n'0_nonmiss,totConti_`c'`var'`n'0,FracNonSwitches_`c'`var'`n'0,FracNonSwitches2m_`c'`var'`n'0,FracNonSwitches3m_`c'`var'`n'0,totConti_`c'`var'`n'1,FracNonSwitches_`c'`var'`n'1,FracNonSwitches2m_`c'`var'`n'1,FracNonSwitches3m_`c'`var'`n'1,totConti1m_`c'`var'`n'Both,FracNonSwitches_`c'`var'`n'Both,FracNonSwitches2m_`c'`var'`n'Both,FracNonSwitches3m_`c'`var'`n'Both);
			mat tempRowSumSwitch=tempRowSumSwitch+tempRowSwitch;

			tempname hh;
			file open `hh' using "`docpath'/tObsStats_`c'`var'.tex", write append;
			file write `hh' %3.0f ((`n'-4)) " & " %3.0f (`c'`var'`n'0_orig) "  &  " %3.0f (`c'`var'`n'0_interp) "  &  " %3.0f (`c'`var'`n'0_extrap) "  &  " %3.0f (`c'`var'`n'0_miss) "  &  " %3.0f (`c'`var'`n'0_all) "  &  " %3.0f (`c'`var'`n'1_orig) "  &  " %3.0f (`c'`var'`n'1_interp) "  &  " %3.0f (`c'`var'`n'1_extrap) "  &  " %3.0f (`c'`var'`n'1_miss) "  &  " %3.0f (`c'`var'`n'1_all) $eolString _n;
			file close `hh';

			tempname hh;
			file open `hh' using "`docpath'/tSwitches_`c'`var'.tex", write append;
			
			file write `hh' %3.0f ((`n'-4)) " & " %3.0f (`c'`var'`n'0_nonmiss) " & " %3.0f (totConti_`c'`var'`n'0) "  &  " %3.2f (FracNonSwitches_`c'`var'`n'0) "  &  " %3.2f (FracNonSwitches2m_`c'`var'`n'0) "  &  " %3.2f (FracNonSwitches3m_`c'`var'`n'0) "  &  " %3.0f (totConti_`c'`var'`n'1) "  &  " %3.2f (FracNonSwitches_`c'`var'`n'1) "  &  " %3.2f (FracNonSwitches2m_`c'`var'`n'1) "  &  " %3.2f (FracNonSwitches3m_`c'`var'`n'1) "  &  " %3.0f (totConti1m_`c'`var'`n'Both) "  &  " %3.2f (FracNonSwitches_`c'`var'`n'Both) "  &  " %3.2f (FracNonSwitches2m_`c'`var'`n'Both) "  &  " %3.2f (FracNonSwitches3m_`c'`var'`n'Both) $eolString _n;

			file close `hh';
		};
		
		forvalues j=1(1)10 {;
				sca tempMean=tempRowSum[1,`j'];
				sca tempMean_`j'=tempMean/(`N'-4);
			};
			
		forvalues j=1(1)13 {;
				sca tempMeanSwitch=tempRowSumSwitch[1,`j'];
				sca tempMeanSwitch_`j'=tempMeanSwitch/(`N'-4);
			};

		mat `c'`var'=(`c'`var'[2..(`N'-3),1..11]\ .,tempMean_1, tempMean_2, tempMean_3, tempMean_4, tempMean_5, tempMean_6, tempMean_7, tempMean_8, tempMean_9, tempMean_10);
		mat li `c'`var', format(%5.1f);
		
		tempname hh;
		file open `hh' using "`docpath'/tObsStats_`c'`var'.tex", write append;

		file write `hh' _char(92)"midrule" _char(92)"multicolumn{1}{c}{Mean} & " %4.1f (tempMean_1) "  &  " %4.1f (tempMean_2) "  &  " %4.1f (tempMean_3) "  &  " %4.1f (tempMean_4) "  &  " %4.1f (tempMean_5) "  &  " %4.1f (tempMean_6) "  &  " %4.1f (tempMean_7) "  &  " %4.1f (tempMean_8) "  &  " %4.1f (tempMean_9) "  &  " %4.1f (tempMean_10) $eolString _n;

		file close `hh';
		
		* Summary file;
		tempname hh;
		file open `hh' using "`docpath'/tObsStats_sum.tex", write append;
		file write `hh' "`c'`var' & " %4.1f (tempMean_1) "  &  " %4.1f (tempMean_2) "  &  " %4.1f (tempMean_3) "  &  " %4.1f (tempMean_4) "  &  " %4.1f (tempMean_5) "  &  " %4.1f (tempMean_6) "  &  " %4.1f (tempMean_7) "  &  " %4.1f (tempMean_8) "  &  " %4.1f (tempMean_9) "  &  " %4.1f (tempMean_10) $eolString _n;
		file close `hh';

		* Switch summary table;
		*************************************;
		tempname hh;
		file open `hh' using "`docpath'/tSwitches_`c'`var'.tex", write append;

		file write `hh' _char(92)"midrule" _char(92)"multicolumn{1}{c}{Mean} & " %4.1f (tempMeanSwitch_1) "  &  " %4.1f (tempMeanSwitch_2) "  &  " %3.2f (tempMeanSwitch_3) "  &  " %3.2f (tempMeanSwitch_4) "  &  " %3.2f (tempMeanSwitch_5) "  &  " %4.1f (tempMeanSwitch_6) "  &  " %3.2f (tempMeanSwitch_7) "  &  " %3.2f (tempMeanSwitch_8) "  &  " %3.2f (tempMeanSwitch_9) "  &  " %4.1f (tempMeanSwitch_10) "  &  " %3.2f (tempMeanSwitch_11) "  &  " %3.2f (tempMeanSwitch_12) "  &  " %3.2f (tempMeanSwitch_13) $eolString _n;

		file close `hh';
		
		* Summary file;
		tempname hh;
		file open `hh' using "`docpath'/tSwitches_sum.tex", write append;
		file write `hh' "`c'`var' & " %4.1f (tempMeanSwitch_1) "  &  " %4.1f (tempMeanSwitch_2) "  &  " %3.2f (tempMeanSwitch_3) "  &  " %3.2f (tempMeanSwitch_4) "  &  " %3.2f (tempMeanSwitch_5) "  &  " %4.1f (tempMeanSwitch_6) "  &  " %3.2f (tempMeanSwitch_7) "  &  " %3.2f (tempMeanSwitch_8) "  &  " %3.2f (tempMeanSwitch_9) "  &  " %4.1f (tempMeanSwitch_10) "  &  " %3.2f (tempMeanSwitch_11) "  &  " %3.2f (tempMeanSwitch_12) "  &  " %3.2f (tempMeanSwitch_13) $eolString _n;
		file close `hh';

		clear;
	};
};



log close;

