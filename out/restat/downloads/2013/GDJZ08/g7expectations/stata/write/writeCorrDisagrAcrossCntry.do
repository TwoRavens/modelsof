
#delimit;

local disagrVar "$disagrVar";
local freq "$freq";

local Ccodes cn fr ge it jp uk us;
local variable infl gdp r3m cons inv un ip;

tempname hh;
file open `hh' using "$docPath\descrStats\tCorrDisagrAcrossCntry$disagrVar$freq.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{center}\footnotesize" _n;
file write `hh' "\begin{longtable}{@{}lld{4}d{4}d{4}d{4}d{4}d{4}@{}}" _n;
file write `hh' "\caption{ Correlation of Disagreement Across Countries (for each Variable), Full Sample, Disagreement Measure: `disagrVar' `freq'} \label{tCorrDisaggrAcrossCntry`disagrVar'`freq'}" $eolString _n;

file write `hh' "\toprule" _n;
file write `hh' "  \multicolumn{1}{c}{Variable} & \multicolumn{1}{c}{Country} & \multicolumn{1}{c}{Canada} & \multicolumn{1}{c}{France}  & \multicolumn{1}{c}{Germany} & \multicolumn{1}{c}{Italy} & \multicolumn{1}{c}{Japan} & \multicolumn{1}{c}{UK} " $eolString _n "\midrule" _n "\endfirsthead" _n;

file write `hh' "\toprule" _n;
file write `hh' "    \multicolumn{1}{c}{Variable} & \multicolumn{1}{c}{Country} & \multicolumn{1}{c}{Canada} & \multicolumn{1}{c}{France}  & \multicolumn{1}{c}{Germany} & \multicolumn{1}{c}{Italy} & \multicolumn{1}{c}{Japan} & \multicolumn{1}{c}{UK} " $eolString _n "\midrule" _n "\endhead" _n;

file write `hh' "\multicolumn{8}{r}{{continued on next page\dots}}" _n "\endfoot";
file write `hh' "\endlastfoot" _n;

foreach var of local variable {;

	local varUpper=upper("`var'");
	*file write `hh' " \multicolumn{7}{l}{`varUpper'} " $eolString _n ;
	*file write `hh' "\midrule " _n;
	
	file write `hh' "`varUpper' & France & " %4.2f (cn`var'corrfr`var') " &  &  &  &  &  " $eolString _n;

	file write `hh' " & Germany & " %4.2f (cn`var'corrge`var') " & "   %4.2f (fr`var'corrge`var') " &  &  &  &  "  $eolString _n;

	file write `hh' "& Italy & " %4.2f (cn`var'corrit`var') " & "   %4.2f (fr`var'corrit`var') " & "  %4.2f (ge`var'corrit`var') " & &  & " $eolString _n;

	file write `hh' "& Japan & " %4.2f %4.2f (cn`var'corrjp`var') " & "   %4.2f (fr`var'corrjp`var') " & "  %4.2f (ge`var'corrjp`var') " & "  %4.2f (it`var'corrjp`var') " &  & "  $eolString _n;

	file write `hh' " & UK & " %4.2f (cn`var'corruk`var') " & "   %4.2f (fr`var'corruk`var') " & "  %4.2f (ge`var'corruk`var') " & "  %4.2f (it`var'corruk`var') " & "  %4.2f (jp`var'corruk`var') " & "  $eolString _n;

	file write `hh' " & US & " %4.2f (cn`var'corrus`var') " & "   %4.2f (fr`var'corrus`var') " & "  %4.2f (ge`var'corrus`var') " & "  %4.2f (it`var'corrus`var') " & "  %4.2f (jp`var'corrus`var') " & "  %4.2f (uk`var'corrus`var') $eolString _n;

	file write `hh' "\midrule " _n;

};

*file write `hh' "\bottomrule" _n;

file write `hh' "\multicolumn{8}{p{9.5cm}}{" _n "\showEstTime{Estimated: $S_DATE, $S_TIME \newline}" _n;

file write `hh' " {\scriptsize Notes: \dots. }" _n "}" _n;

file write `hh' "\end{longtable}" _n;
file write `hh' "\end{center}" _n;

file close `hh';

*****************************************************************************************************;

local variable infl gdp r3m cons inv un;

tempname hh;
file open `hh' using "$docPath\descrStats\tCorrDisagrAcrossCntrySub$disagrVar$freq.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{center}\footnotesize" _n;
file write `hh' "\begin{longtable}{@{}lld{4}d{4}d{4}d{4}d{4}d{4}@{}}" _n;
file write `hh' "\caption{ Correlation of Disagreement Across Countries (for each Variable), Full Sample, Disagreement Measure: `disagrVar' `freq'} \label{tCorrDisaggrAcrossCntry`disagrVar'`freq'}" $eolString _n;

file write `hh' "\toprule" _n;
file write `hh' "  \multicolumn{1}{c}{Variable} & \multicolumn{1}{c}{Country} & \multicolumn{1}{c}{Canada} & \multicolumn{1}{c}{France}  & \multicolumn{1}{c}{Germany} & \multicolumn{1}{c}{Italy} & \multicolumn{1}{c}{Japan} & \multicolumn{1}{c}{UK} " $eolString _n "\midrule" _n "\endfirsthead" _n;

file write `hh' "\toprule" _n;
file write `hh' "    \multicolumn{1}{c}{Variable} & \multicolumn{1}{c}{Country} & \multicolumn{1}{c}{Canada} & \multicolumn{1}{c}{France}  & \multicolumn{1}{c}{Germany} & \multicolumn{1}{c}{Italy} & \multicolumn{1}{c}{Japan} & \multicolumn{1}{c}{UK} " $eolString _n "\midrule" _n "\endhead" _n;

file write `hh' "\multicolumn{8}{r}{{continued on next page\dots}}" _n "\endfoot";
file write `hh' "\endlastfoot" _n;

foreach var of local variable {;

	local varUpper=upper("`var'");
	*file write `hh' " \multicolumn{7}{l}{`varUpper'} " $eolString _n ;
	*file write `hh' "\midrule " _n;
	
	file write `hh' "`varUpper' & France & " %4.2f (cn`var'corrfr`var') " &  &  &  &  &  " $eolString _n;

	file write `hh' " & Germany & " %4.2f (cn`var'corrge`var') " & "   %4.2f (fr`var'corrge`var') " &  &  &  &  "  $eolString _n;

	file write `hh' "& Italy & " %4.2f (cn`var'corrit`var') " & "   %4.2f (fr`var'corrit`var') " & "  %4.2f (ge`var'corrit`var') " & &  & " $eolString _n;

	file write `hh' "& Japan & " %4.2f %4.2f (cn`var'corrjp`var') " & "   %4.2f (fr`var'corrjp`var') " & "  %4.2f (ge`var'corrjp`var') " & "  %4.2f (it`var'corrjp`var') " &  & "  $eolString _n;

	file write `hh' " & UK & " %4.2f (cn`var'corruk`var') " & "   %4.2f (fr`var'corruk`var') " & "  %4.2f (ge`var'corruk`var') " & "  %4.2f (it`var'corruk`var') " & "  %4.2f (jp`var'corruk`var') " & "  $eolString _n;

	file write `hh' " & US & " %4.2f (cn`var'corrus`var') " & "   %4.2f (fr`var'corrus`var') " & "  %4.2f (ge`var'corrus`var') " & "  %4.2f (it`var'corrus`var') " & "  %4.2f (jp`var'corrus`var') " & "  %4.2f (uk`var'corrus`var') $eolString _n;

	file write `hh' "\midrule " _n;

};

*file write `hh' "\bottomrule" _n;

file write `hh' "\multicolumn{8}{p{9.5cm}}{" _n "\showEstTime{Estimated: $S_DATE, $S_TIME \newline}" _n;

file write `hh' " {\scriptsize Notes: \dots. }" _n "}" _n;

file write `hh' "\end{longtable}" _n;
file write `hh' "\end{center}" _n;

file close `hh';
