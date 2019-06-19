

#delimit;
tempname hh;
file open `hh' using "$docPath\descrStats\tSumStatPeriodComparisonByVar$variable$disagrVar.tex", write replace;
file write `hh' "  "_n;

local var "$variable"; local varUpper=upper("`var'");
local disagrVar "$disagrVar";
local Ccodes cn fr ge it jp uk us;
local allPers Full 1stHalf 2ndHalf Boom Recession;

file write `hh' "\begin{table}\footnotesize" _n;
file write `hh' "\caption{Dataset and Macro Statistics---`varUpper', Disagr Measure: `disagrVar' \label{tSumStatPeriodComparisonByVar`var'`disagrVar'}}" _n;
file write `hh' "\begin{center}" _n;
file write `hh' "\begin{tabular}{@{}ld{4}d{4}d{4}d{4}d{4}@{}}" _n "\toprule" _n;
file write `hh' "  Statistic & \multicolumn{1}{c}{Full Sample } & \multicolumn{1}{c}{Pre-1999} 
 & \multicolumn{1}{c}{1999+ } & \multicolumn{1}{c}{Booms} & \multicolumn{1}{c}{Recessions} " $eolString _n;

foreach C of local Ccodes {;

	local cUpper=upper("`C'");
	file write `hh' "\midrule " _n "\multicolumn{6}{l}{`cUpper'}" $eolString _n;

	file write `hh' "Average \# Forecasters & " %4.2f (`var'meannobsFull`C') " & "  %4.2f (`var'meannobs1stHalf`C') " & " %4.2f (`var'meannobs2ndHalf`C') " & " %4.2f (`var'meannobsBoom`C') " & " %4.2f (`var'meannobsRecession`C') $eolString _n;

	file write `hh' "Average Forecast Error" _char(36) "{}^\dagger\$ ";
	foreach per of local allPers {;
		sca ptest = 2*(1-norm(abs(`var'meanmeane`per'`C')/`var'sdmeane`per'`C'));
		do MakeTestStringJ;
		file write `hh' "  & " %4.2f (`var'meanmeane`per'`C') (teststr);
	};
	file write `hh' $eolString _n;

	file write `hh' "Average MSE & " %4.2f (`var'meanmeane2Full`C') " & "  %4.2f (`var'meanmeane21stHalf`C') " & " %4.2f (`var'meanmeane22ndHalf`C') " & " %4.2f (`var'meanmeane2Boom`C') " & " %4.2f (`var'meanmeane2Recession`C') $eolString _n;

	file write `hh' "Average Disagreement & " %4.2f (`var'meandisagrFull`C') " & "  %4.2f (`var'meandisagr1stHalf`C') " & " %4.2f (`var'meandisagr2ndHalf`C') " & " %4.2f (`var'meandisagrBoom`C') " & " %4.2f (`var'meandisagrRecession`C') $eolString _n;

	file write `hh' "Average Level of `varUpper' & " %4.2f (`var'meanLevelFull`C') " & "  %4.2f (`var'meanLevel1stHalf`C') " & " %4.2f (`var'meanLevel2ndHalf`C') " & " %4.2f (`var'meanLevelBoom`C') " & " %4.2f (`var'meanLevelRecession`C') $eolString _n;

	file write `hh' "Variance of `varUpper' & " %4.2f (`var'VarFull`C') " & "  %4.2f (`var'Var1stHalf`C') " & " %4.2f (`var'Var2ndHalf`C') " & " %4.2f (`var'VarBoom`C') " & " %4.2f (`var'VarRecession`C') $eolString _n;

};

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}" $eolString _n;

file write `hh' " {\scriptsize Notes:  Averages taken across forecasters and time periods.  $\dagger:$ \{*,**,***\}=Statistical significance at \{10,5,1\} percent.}" _n;
file write `hh' "\end{table} " _n;
file close `hh';

