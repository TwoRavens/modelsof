
#delimit;
tempname hh;
file open `hh' using "$docPath\descrStats\tSumCorrDisagrAllC.tex", write replace;
file write `hh' "  "_n;

local cntry "$country";
local var "$variable";  local varUpper=upper("`var'");

file write `hh' "\begin{table}\small" _n;
file write `hh' "\caption{ Correlation between the Two Disagreement Measures (Cross-Sectional IQR and Standard Deviation) \label{tSumCorrDisagrAllC}}" _n;
file write `hh' "\begin{center}" _n;
file write `hh' "\begin{tabular}{@{}ld{4}d{4}d{4}d{4}d{4}d{4}@{}}" _n "\toprule" _n;
file write `hh' "  Statistic & \multicolumn{1}{c}{Full Sample } & \multicolumn{1}{c}{Pre-2000} 
 & \multicolumn{1}{c}{2000+ } & \multicolumn{1}{c}{Booms} & \multicolumn{1}{c}{Recessions} " $eolString _n; 

local Ccodes cn fr ge it jp uk us;
local variable infl r3m gdp cons inv un ip;

foreach var of local variable {;

	file write `hh' "\midrule " _n;

	foreach C of local Ccodes {;
		local cntryUpper=upper("`C'");
		local varUpper=upper("`var'");

		file write `hh' "`varUpper'`cntryUpper' & " %4.2f (`C'`var'corrDisagrFull) " & " %4.2f (`C'`var'corrDisagr1stHalf) " & " 
		%4.2f (`C'`var'corrDisagr2ndHalf) " & " %4.2f (`C'`var'corrDisagrBoom) " & " %4.2f (`C'`var'corrDisagrRecession) $eolString _n;

	};
};

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME \newline}" _n;

file write `hh' " {\scriptsize Notes:  Averages taken across forecasters participating in the survey.}" _n;
file write `hh' "\end{table} " _n;
file close `hh';

********************************************************************************************;

tempname hh;
file open `hh' using "$docPath\descrStats\tSumCorrDisagrSummaryAllC.tex", write replace;
file write `hh' "  "_n;

local cntry "$country";
local var "$variable";  local varUpper=upper("`var'");

file write `hh' "\begin{table}\scriptsize" _n;
file write `hh' "\caption{ Correlation between the Two Disagreement Measures (Cross-Sectional IQR and Standard Deviation) \label{tSumCorrDisagrSummaryAllC}}" _n;
file write `hh' "\begin{center}" _n;
file write `hh' "\begin{tabular}{@{}ld{4}d{4}d{4}d{4}d{4}d{4}d{4}@{}}" _n "\toprule" _n;
file write `hh' "   & \multicolumn{1}{c}{Canada} & \multicolumn{1}{c}{France} 
 & \multicolumn{1}{c}{Germany} & \multicolumn{1}{c}{Italy} & \multicolumn{1}{c}{Japan} & \multicolumn{1}{c}{UK} & \multicolumn{1}{c}{US} " $eolString _n "\midrule " _n; 

file write `hh' "Inflation ";
foreach C of local Ccodes {; file write `hh' " & " %4.2f (`C'inflcorrDisagrFull); }; 
file write `hh' $eolString _n;

file write `hh' "Interest Rate ";
foreach C of local Ccodes {; file write `hh' " & " %4.2f (`C'r3mcorrDisagrFull); }; 
file write `hh' $eolString _n;

file write `hh' "GDP ";
foreach C of local Ccodes {; file write `hh' " & " %4.2f (`C'gdpcorrDisagrFull); }; 
file write `hh' $eolString _n;

file write `hh' "Consumption ";
foreach C of local Ccodes {; file write `hh' " & " %4.2f (`C'conscorrDisagrFull); }; 
file write `hh' $eolString _n;

file write `hh' "Investment ";
foreach C of local Ccodes {; file write `hh' " & " %4.2f (`C'invcorrDisagrFull); }; 
file write `hh' $eolString _n;

file write `hh' "Unemployment ";
foreach C of local Ccodes {; file write `hh' " & " %4.2f (`C'uncorrDisagrFull); }; 
file write `hh' $eolString _n;

file write `hh' "IP ";
foreach C of local Ccodes {; file write `hh' " & " %4.2f (`C'ipcorrDisagrFull); }; 
file write `hh' $eolString _n;

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME \newline}" _n;

*file write `hh' " {\scriptsize Notes:  Averages taken across forecasters participating in the survey.}" _n;
file write `hh' "\end{table} " _n;
file close `hh';
