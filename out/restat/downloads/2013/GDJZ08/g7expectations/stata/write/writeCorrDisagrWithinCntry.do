

#delimit;

local disagrVar "$disagrVar";
local freq "$freq";

local Ccodes cn fr ge it jp uk us;
local variable infl gdp r3m cons inv un ip;

tempname hh;
file open `hh' using "$docPath\descrStats\tCorrDisagrWithinCntry$disagrVar$freq.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{center}\footnotesize" _n;
file write `hh' "\begin{longtable}{@{}lld{4}d{4}d{4}d{4}d{4}d{4}@{}}" _n;
file write `hh' "\caption{ Correlation of Disagreement Across Variables Within Country, Full Sample, Disagreement Measure: `disagrVar' `freq' } \label{tCorrDisaggrWithinCntry`disagrVar'`freq'}" $eolString _n;

file write `hh' "\toprule" _n;
file write `hh' "    \multicolumn{1}{l}{Country} & \multicolumn{1}{l}{Variable} & \multicolumn{1}{c}{Inflation} & \multicolumn{1}{c}{GDP}  & \multicolumn{1}{c}{Int.\ Rate} & \multicolumn{1}{c}{Cons} & \multicolumn{1}{c}{Inv} & \multicolumn{1}{c}{Unempl} " $eolString _n "\midrule" _n "\endfirsthead" _n;

file write `hh' "\toprule" _n;
file write `hh' "   \multicolumn{1}{l}{Country} & \multicolumn{1}{l}{Variable} & \multicolumn{1}{c}{Inflation} & \multicolumn{1}{c}{GDP}  & \multicolumn{1}{c}{Int.\ Rate} & \multicolumn{1}{c}{Cons} & \multicolumn{1}{c}{Inv} & \multicolumn{1}{c}{Unempl} " $eolString _n "\midrule" _n "\endhead" _n;

file write `hh' "\multicolumn{8}{r}{{continued on next page\dots}}" _n "\endfoot";
file write `hh' "\endlastfoot" _n;

foreach C of local Ccodes {;

	local cntryUpper=upper("`C'");
	*file write `hh' "   \multicolumn{7}{l}{`cntryUpper'} " $eolString _n ;
	*file write `hh' "\midrule " _n;
	
	file write `hh' "`cntryUpper' & GDP & " %4.2f (`C'inflcorr`C'gdp) " &  &  &  &  &  " $eolString _n;

	file write `hh' " & Interest Rate & " %4.2f (`C'inflcorr`C'r3m) " & "   %4.2f (`C'gdpcorr`C'r3m) " & & & & "  $eolString _n;
	
	file write `hh' " & Consumption & " %4.2f (`C'inflcorr`C'cons) " & "   %4.2f (`C'gdpcorr`C'cons) " & "  %4.2f (`C'r3mcorr`C'cons) " & &  & " $eolString _n;

	file write `hh' " & Investment & " %4.2f (`C'inflcorr`C'inv) " & "   %4.2f (`C'gdpcorr`C'inv) " & "  %4.2f (`C'r3mcorr`C'inv) " & "  %4.2f (`C'conscorr`C'inv) " &  & "  $eolString _n;

	file write `hh' " & Unemployment & " %4.2f (`C'inflcorr`C'un) " & "   %4.2f (`C'gdpcorr`C'un) " & "  %4.2f (`C'r3mcorr`C'un) " & "  %4.2f (`C'conscorr`C'un) " & "  %4.2f (`C'invcorr`C'un) " & "  $eolString _n;

	file write `hh' " & IP & " %4.2f (`C'inflcorr`C'ip) " & "   %4.2f (`C'gdpcorr`C'ip) " & "  %4.2f (`C'r3mcorr`C'ip) " & "  %4.2f (`C'conscorr`C'ip) " &"  %4.2f (`C'invcorr`C'ip) "  &  "  %4.2f (`C'uncorr`C'ip) $eolString _n;

	file write `hh' "\midrule " _n;

};

*file write `hh' "\bottomrule" _n;

file write `hh' "\multicolumn{8}{p{9.5cm}}{" _n "\showEstTime{Estimated: $S_DATE, $S_TIME \newline}" _n;

file write `hh' " {\scriptsize Notes: \dots. }" _n "}" _n;

file write `hh' "\end{longtable}" _n;
file write `hh' "\end{center}" _n;

file close `hh';


* Sub-table;
***************************************************************************************************;

tempname hh;
file open `hh' using "$docPath\descrStats\tCorrDisagrWithinCntrySub$disagrVar$freq.tex", write replace;
file write `hh' "  "_n;

file write `hh' "\begin{center}\footnotesize" _n;
file write `hh' "\begin{longtable}{@{}lld{4}d{4}d{4}d{4}d{4}@{}}" _n;
file write `hh' "\caption{ Correlation of Disagreement Across Variables Within Country, Full Sample, Disagreement Measure: `disagrVar' `freq' } \label{tCorrDisaggrWithinCntrySub`disagrVar'`freq'}" $eolString _n;

file write `hh' "\toprule" _n;
file write `hh' "    \multicolumn{1}{l}{Country} & \multicolumn{1}{l}{Variable} & \multicolumn{1}{c}{Inflation} & \multicolumn{1}{c}{GDP} & \multicolumn{1}{c}{Int.\ Rate}  &  \multicolumn{1}{c}{Cons} & \multicolumn{1}{c}{Inv} " $eolString _n "\midrule" _n "\endfirsthead" _n;

file write `hh' "\toprule" _n;
file write `hh' "   \multicolumn{1}{l}{Country} & \multicolumn{1}{l}{Variable} & \multicolumn{1}{c}{Inflation} & \multicolumn{1}{c}{GDP} & \multicolumn{1}{c}{Int.\ Rate}  &  \multicolumn{1}{c}{Cons} & \multicolumn{1}{c}{Inv} " $eolString _n "\midrule" _n "\endhead" _n;

file write `hh' "\multicolumn{7}{r}{{continued on next page\dots}}" _n "\endfoot";
file write `hh' "\endlastfoot" _n;

foreach C of local Ccodes {;

	local cntryUpper=upper("`C'");
	*file write `hh' "   \multicolumn{7}{l}{`cntryUpper'} " $eolString _n ;
	*file write `hh' "\midrule " _n;
	
	file write `hh' "`cntryUpper' & GDP & " %4.2f (`C'inflcorr`C'gdp) " &  &  &  &   " $eolString _n;

	file write `hh' " & Interest Rate & " %4.2f (`C'inflcorr`C'r3m) " & "   %4.2f (`C'gdpcorr`C'r3m) " & & & "  $eolString _n;
	
	file write `hh' " & Consumption & " %4.2f (`C'inflcorr`C'cons) " & "   %4.2f (`C'gdpcorr`C'cons) " & "  %4.2f (`C'r3mcorr`C'cons) " &  & " $eolString _n;

	file write `hh' " & Investment & " %4.2f (`C'inflcorr`C'inv) " & "   %4.2f (`C'gdpcorr`C'inv) " & " %4.2f (`C'r3mcorr`C'inv) " & " %4.2f (`C'conscorr`C'inv) " & "  $eolString _n;

	file write `hh' " & Unemployment & " %4.2f (`C'inflcorr`C'un) " & "   %4.2f (`C'gdpcorr`C'un) " & "  %4.2f (`C'r3mcorr`C'un) " & "  %4.2f (`C'conscorr`C'un) " & "  %4.2f (`C'invcorr`C'un)  $eolString _n;

	file write `hh' "\midrule " _n;

};

*file write `hh' "\bottomrule" _n;

file write `hh' "\multicolumn{7}{p{9.5cm}}{" _n "\showEstTime{Estimated: $S_DATE, $S_TIME \newline}" _n;

file write `hh' " {\scriptsize Notes: \dots. }" _n "}" _n;

file write `hh' "\end{longtable}" _n;
file write `hh' "\end{center}" _n;

file close `hh';
