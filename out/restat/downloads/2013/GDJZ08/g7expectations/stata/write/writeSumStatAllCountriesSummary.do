
* Table 1 in the paper
#delimit;
tempname hh;
file open `hh' using "$docPath\descrStats\tSumStatAllCsummary.tex", write replace;
file write `hh' "  "_n;

local cntry "$country";
local variable infl r3m gdp cons inv un ip;
local Ccodes cn fr ge it jp uk us;
local disagrVar "$disagrVar";

file write `hh' "\begin{table}\footnotesize" _n;
file write `hh' "\caption{ Summary Statistics, All Countries, Full Sample \label{tSumStatAllCsummary}}" _n;
file write `hh' "\begin{center}" _n;
file write `hh' "\begin{tabular}{@{}ld{4}d{4}d{4}d{4}d{4}d{4}d{4}@{}}" _n "\toprule" _n;
file write `hh' "  Statistic & \multicolumn{1}{c}{Canada} & \multicolumn{1}{c}{France}  & \multicolumn{1}{c}{Germany} & \multicolumn{1}{c}{Italy} & \multicolumn{1}{c}{Japan} & \multicolumn{1}{c}{UK} & \multicolumn{1}{c}{US} " $eolString;


foreach var of local variable {;

	local varUpper=upper("`var'");
	file write `hh' "\midrule " _n "\multicolumn{8}{l}{`varUpper'}" $eolString _n;

	file write `hh' "Average \# Forecasters & " %4.2f (`var'meannobsFullcn) " & "  %4.2f (`var'meannobsFullfr) " & " %4.2f (`var'meannobsFullge) " & " %4.2f (`var'meannobsFullit) " & " %4.2f (`var'meannobsFulljp) " & " %4.2f (`var'meannobsFulluk) " & " %4.2f (`var'meannobsFullus)  $eolString _n;

	file write `hh' "Average Expectation Error" _char(36) "{}^\dagger\$ ";
	foreach C of local Ccodes {;
		sca ptest = 2*(1-norm(abs(`var'meanmeaneFull`C')/`var'sdmeaneFull`C'));
		do MakeTestStringJ;
		file write `hh' "  & " %4.2f (`var'meanmeaneFull`C') (teststr);
	};
	file write `hh' $eolString _n;
	
	file write `hh' "Average MSE & " %4.2f (`var'meanmeane2Fullcn) " & " %4.2f (`var'meanmeane2Fullfr) " & "%4.2f (`var'meanmeane2Fullge) " & "%4.2f (`var'meanmeane2Fullit) " & "%4.2f (`var'meanmeane2Fulljp) " & "%4.2f (`var'meanmeane2Fulluk) " & "%4.2f (`var'meanmeane2Fullus) $eolString _n;

	* file write `hh' "Average Disagreement & " %4.2f (`var'meandisagrFullcn) " & "   %4.2f (`var'meandisagrFullfr) " & "  %4.2f (`var'meandisagrFullge) " & "  %4.2f (`var'meandisagrFullit) " & "  %4.2f (`var'meandisagrFulljp) " & "  %4.2f (`var'meandisagrFulluk) " & "  %4.2f (`var'meandisagrFullus)  $eolString _n;

	file write `hh' "Average Level of `varUpper' & " %4.2f (`var'meanLevelFullcn) " & "  %4.2f (`var'meanLevelFullfr) " & "  %4.2f (`var'meanLevelFullge) " & "  %4.2f (`var'meanLevelFullit) " & "  %4.2f (`var'meanLevelFulljp) " & "  %4.2f (`var'meanLevelFulluk) " & "  %4.2f (`var'meanLevelFullus) $eolString _n;

	file write `hh' "Variance of `varUpper' & " %4.2f (`var'VarFullcn) " & "   %4.2f (`var'VarFullfr) " & " %4.2f (`var'VarFullge) " & " %4.2f (`var'VarFullit) " & " %4.2f (`var'VarFulljp) " & " %4.2f (`var'VarFulluk) " & " %4.2f (`var'VarFullus) $eolString _n;
};

file write `hh' " \bottomrule" _n "\multicolumn{8}{p{13.5cm}}{" _n "\showEstTime{Estimated: $S_DATE, $S_TIME}" _n _n;

file write `hh' " {\scriptsize Notes: Averages taken across forecasters and time periods.  $\dagger:$ \{*,**,***\}=Statistical significance at \{10,5,1\} percent. }" _n "}" _n;


file write `hh' "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\end{table} " _n;
file close `hh';

