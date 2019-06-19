
* Summary table used in the online appendix -- Average disagreement
#delimit;

local typeAll Disagr Actual Unc;
local disagrVar "$disagrVar";

foreach type of local typeAll {;

	tempname hh;
	file open `hh' using "$docPath\descrStats\tSumStatAllCallVarBig`type'$disagrVar.tex", write replace;
	file write `hh' "  "_n;

	file write `hh' "\begin{table}\footnotesize" _n;
	file write `hh' "\caption{ Average Disagreement Across Countries and Variables, Disagreement Measure: `disagrVar', variable: `type' \label{tSumStatAllCallVarBig`type'`disagrVar'}}" _n;
	file write `hh' "\begin{center}" _n;
	file write `hh' "\begin{tabular}{@{}ld{4}d{4}d{4}d{4}d{4}d{4}d{4}d{4}@{}}" _n "\toprule" _n;
	file write `hh' "  Variable & \multicolumn{1}{c}{Canada} & \multicolumn{1}{c}{France}  & \multicolumn{1}{c}{Germany} & \multicolumn{1}{c}{Italy} & \multicolumn{1}{c}{Japan} & \multicolumn{1}{c}{UK} & \multicolumn{1}{c}{US} & \multicolumn{1}{c}{Mean} " $eolString _n "\midrule" _n;

	file write `hh' "\multicolumn{8}{l}{Full Sample} " $eolString _n "\midrule " _n;

	file write `hh' "Inflation & " %4.2f (inflmean`type'Fullcn) " & "   %4.2f (inflmean`type'Fullfr) " & "  %4.2f (inflmean`type'Fullge) " & "  %4.2f (inflmean`type'Fullit) " & "  %4.2f (inflmean`type'Fulljp) " & "  %4.2f (inflmean`type'Fulluk) " & "  %4.2f (inflmean`type'Fullus) " & "  %4.2f (inflmean`type'FullAll)  $eolString _n;

	file write `hh' "Interest Rate & " %4.2f (r3mmean`type'Fullcn) " & "   %4.2f (r3mmean`type'Fullfr) " & "  %4.2f (r3mmean`type'Fullge) " & "  %4.2f (r3mmean`type'Fullit) " & "  %4.2f (r3mmean`type'Fulljp) " & "  %4.2f (r3mmean`type'Fulluk) " & "  %4.2f (r3mmean`type'Fullus) " & "  %4.2f (r3mmean`type'FullAll)  $eolString _n;

	file write `hh' "GDP & " %4.2f (gdpmean`type'Fullcn) " & "   %4.2f (gdpmean`type'Fullfr) " & "  %4.2f (gdpmean`type'Fullge) " & "  %4.2f (gdpmean`type'Fullit) " & "  %4.2f (gdpmean`type'Fulljp) " & "  %4.2f (gdpmean`type'Fulluk) " & "  %4.2f (gdpmean`type'Fullus) " & "  %4.2f (gdpmean`type'FullAll)  $eolString _n;

	file write `hh' "Consumption & " %4.2f (consmean`type'Fullcn) " & "   %4.2f (consmean`type'Fullfr) " & "  %4.2f (consmean`type'Fullge) " & "  %4.2f (consmean`type'Fullit) " & "  %4.2f (consmean`type'Fulljp) " & "  %4.2f (consmean`type'Fulluk) " & "  %4.2f (consmean`type'Fullus) " & "  %4.2f (consmean`type'FullAll)  $eolString _n;

	file write `hh' "Investment & " %4.2f (invmean`type'Fullcn) " & "   %4.2f (invmean`type'Fullfr) " & "  %4.2f (invmean`type'Fullge) " & "  %4.2f (invmean`type'Fullit) " & "  %4.2f (invmean`type'Fulljp) " & "  %4.2f (invmean`type'Fulluk) " & "  %4.2f (invmean`type'Fullus) " & "  %4.2f (invmean`type'FullAll)  $eolString _n;

	file write `hh' "Unemployment & " %4.2f (unmean`type'Fullcn) " & "   %4.2f (unmean`type'Fullfr) " & "  %4.2f (unmean`type'Fullge) " & "  %4.2f (unmean`type'Fullit) " & "  %4.2f (unmean`type'Fulljp) " & "  %4.2f (unmean`type'Fulluk) " & "  %4.2f (unmean`type'Fullus) " & "  %4.2f (unmean`type'FullAll) $eolString _n;

	file write `hh' "IP & " %4.2f (ipmean`type'Fullcn) " & "   %4.2f (ipmean`type'Fullfr) " & "  %4.2f (ipmean`type'Fullge) " & "  %4.2f (ipmean`type'Fullit) " & "  %4.2f (ipmean`type'Fulljp) " & "  %4.2f (ipmean`type'Fulluk) " & "  %4.2f (ipmean`type'Fullus) " & "  %4.2f (ipmean`type'FullAll)  $eolString _n;

	******************************************************************************************************************************;
	file write `hh' "\midrule" _n "\multicolumn{8}{l}{Booms} " $eolString _n;

	file write `hh' "Inflation & " %4.2f (inflmean`type'Boomcn) " & "   %4.2f (inflmean`type'Boomfr) " & "  %4.2f (inflmean`type'Boomge) " & "  %4.2f (inflmean`type'Boomit) " & "  %4.2f (inflmean`type'Boomjp) " & "  %4.2f (inflmean`type'Boomuk) " & "  %4.2f (inflmean`type'Boomus) " & "  %4.2f (inflmean`type'BoomAll)  $eolString _n;

	file write `hh' "Interest Rate & " %4.2f (r3mmean`type'Boomcn) " & "   %4.2f (r3mmean`type'Boomfr) " & "  %4.2f (r3mmean`type'Boomge) " & "  %4.2f (r3mmean`type'Boomit) " & "  %4.2f (r3mmean`type'Boomjp) " & "  %4.2f (r3mmean`type'Boomuk) " & "  %4.2f (r3mmean`type'Boomus) " & "  %4.2f (r3mmean`type'BoomAll)  $eolString _n;

	file write `hh' "GDP & " %4.2f (gdpmean`type'Boomcn) " & "   %4.2f (gdpmean`type'Boomfr) " & "  %4.2f (gdpmean`type'Boomge) " & "  %4.2f (gdpmean`type'Boomit) " & "  %4.2f (gdpmean`type'Boomjp) " & "  %4.2f (gdpmean`type'Boomuk) " & "  %4.2f (gdpmean`type'Boomus) " & "  %4.2f (gdpmean`type'BoomAll)  $eolString _n;

	file write `hh' "Consumption & " %4.2f (consmean`type'Boomcn) " & "   %4.2f (consmean`type'Boomfr) " & "  %4.2f (consmean`type'Boomge) " & "  %4.2f (consmean`type'Boomit) " & "  %4.2f (consmean`type'Boomjp) " & "  %4.2f (consmean`type'Boomuk) " & "  %4.2f (consmean`type'Boomus) " & "  %4.2f (consmean`type'BoomAll)  $eolString _n;

	file write `hh' "Investment & " %4.2f (invmean`type'Boomcn) " & "   %4.2f (invmean`type'Boomfr) " & "  %4.2f (invmean`type'Boomge) " & "  %4.2f (invmean`type'Boomit) " & "  %4.2f (invmean`type'Boomjp) " & "  %4.2f (invmean`type'Boomuk) " & "  %4.2f (invmean`type'Boomus) " & "  %4.2f (invmean`type'BoomAll)  $eolString _n;

	file write `hh' "Unemployment & " %4.2f (unmean`type'Boomcn) " & "   %4.2f (unmean`type'Boomfr) " & "  %4.2f (unmean`type'Boomge) " & "  %4.2f (unmean`type'Boomit) " & "  %4.2f (unmean`type'Boomjp) " & "  %4.2f (unmean`type'Boomuk) " & "  %4.2f (unmean`type'Boomus) " & "  %4.2f (unmean`type'BoomAll)  $eolString _n;

	file write `hh' "IP & " %4.2f (ipmean`type'Boomcn) " & "   %4.2f (ipmean`type'Boomfr) " & "  %4.2f (ipmean`type'Boomge) " & "  %4.2f (ipmean`type'Boomit) " & "  %4.2f (ipmean`type'Boomjp) " & "  %4.2f (ipmean`type'Boomuk) " & "  %4.2f (ipmean`type'Boomus) " & "  %4.2f (ipmean`type'BoomAll)  $eolString _n;

	******************************************************************************************************************************;
	file write `hh' "\midrule" _n "\multicolumn{8}{l}{Recessions} " $eolString _n;

	file write `hh' "Inflation & " %4.2f (inflmean`type'Recessioncn) " & "   %4.2f (inflmean`type'Recessionfr) " & "  %4.2f (inflmean`type'Recessionge) " & "  %4.2f (inflmean`type'Recessionit) " & "  %4.2f (inflmean`type'Recessionjp) " & "  %4.2f (inflmean`type'Recessionuk) " & "  %4.2f (inflmean`type'Recessionus) " & "  %4.2f (inflmean`type'RecessionAll)  $eolString _n;

	file write `hh' "Interest Rate & " %4.2f (r3mmean`type'Recessioncn) " & "   %4.2f (r3mmean`type'Recessionfr) " & "  %4.2f (r3mmean`type'Recessionge) " & "  %4.2f (r3mmean`type'Recessionit) " & "  %4.2f (r3mmean`type'Recessionjp) " & "  %4.2f (r3mmean`type'Recessionuk) " & "  %4.2f (r3mmean`type'Recessionus)  " & "  %4.2f (inflmean`type'RecessionAll) $eolString _n;

	file write `hh' "GDP & " %4.2f (gdpmean`type'Recessioncn) " & "   %4.2f (gdpmean`type'Recessionfr) " & "  %4.2f (gdpmean`type'Recessionge) " & "  %4.2f (gdpmean`type'Recessionit) " & "  %4.2f (gdpmean`type'Recessionjp) " & "  %4.2f (gdpmean`type'Recessionuk) " & "  %4.2f (gdpmean`type'Recessionus) " & "  %4.2f (gdpmean`type'RecessionAll)  $eolString _n;

	file write `hh' "Consumption & " %4.2f (consmean`type'Recessioncn) " & "   %4.2f (consmean`type'Recessionfr) " & "  %4.2f (consmean`type'Recessionge) " & "  %4.2f (consmean`type'Recessionit) " & "  %4.2f (consmean`type'Recessionjp) " & "  %4.2f (consmean`type'Recessionuk) " & "  %4.2f (consmean`type'Recessionus) " & "  %4.2f (consmean`type'RecessionAll)  $eolString _n;

	file write `hh' "Investment & " %4.2f (invmean`type'Recessioncn) " & "   %4.2f (invmean`type'Recessionfr) " & "  %4.2f (invmean`type'Recessionge) " & "  %4.2f (invmean`type'Recessionit) " & "  %4.2f (invmean`type'Recessionjp) " & "  %4.2f (invmean`type'Recessionuk) " & "  %4.2f (invmean`type'Recessionus) " & "  %4.2f (invmean`type'RecessionAll)  $eolString _n;

	file write `hh' "Unemployment & " %4.2f (unmean`type'Recessioncn) " & "   %4.2f (unmean`type'Recessionfr) " & "  %4.2f (unmean`type'Recessionge) " & "  %4.2f (unmean`type'Recessionit) " & "  %4.2f (unmean`type'Recessionjp) " & "  %4.2f (unmean`type'Recessionuk) " & "  %4.2f (unmean`type'Recessionus) " & "  %4.2f (unmean`type'RecessionAll)  $eolString _n;

	file write `hh' "IP & " %4.2f (ipmean`type'Recessioncn) " & "   %4.2f (ipmean`type'Recessionfr) " & "  %4.2f (ipmean`type'Recessionge) " & "  %4.2f (ipmean`type'Recessionit) " & "  %4.2f (ipmean`type'Recessionjp) " & "  %4.2f (ipmean`type'Recessionuk) " & "  %4.2f (ipmean`type'Recessionus) " & "  %4.2f (ipmean`type'RecessionAll) $eolString _n;

	******************************************************************************************************************************;
	file write `hh' "\midrule" _n "\multicolumn{8}{l}{Pre-1999} " $eolString _n;

	file write `hh' "Inflation & " %4.2f (inflmean`type'1stHalfcn) " & "   %4.2f (inflmean`type'1stHalffr) " & "  %4.2f (inflmean`type'1stHalfge) " & "  %4.2f (inflmean`type'1stHalfit) " & "  %4.2f (inflmean`type'1stHalfjp) " & "  %4.2f (inflmean`type'1stHalfuk) " & "  %4.2f (inflmean`type'1stHalfus) " & "  %4.2f (inflmean`type'1stHalfAll)  $eolString _n;

	file write `hh' "Interest Rate & " %4.2f (r3mmean`type'1stHalfcn) " & "   %4.2f (r3mmean`type'1stHalffr) " & "  %4.2f (r3mmean`type'1stHalfge) " & "  %4.2f (r3mmean`type'1stHalfit) " & "  %4.2f (r3mmean`type'1stHalfjp) " & "  %4.2f (r3mmean`type'1stHalfuk) " & "  %4.2f (r3mmean`type'1stHalfus) " & "  %4.2f (r3mmean`type'1stHalfAll)  $eolString _n;

	file write `hh' "GDP & " %4.2f (gdpmean`type'1stHalfcn) " & "   %4.2f (gdpmean`type'1stHalffr) " & "  %4.2f (gdpmean`type'1stHalfge) " & "  %4.2f (gdpmean`type'1stHalfit) " & "  %4.2f (gdpmean`type'1stHalfjp) " & "  %4.2f (gdpmean`type'1stHalfuk) " & "  %4.2f (gdpmean`type'1stHalfus) " & "  %4.2f (gdpmean`type'1stHalfAll)  $eolString _n;

	file write `hh' "Consumption & " %4.2f (consmean`type'1stHalfcn) " & "   %4.2f (consmean`type'1stHalffr) " & "  %4.2f (consmean`type'1stHalfge) " & "  %4.2f (consmean`type'1stHalfit) " & "  %4.2f (consmean`type'1stHalfjp) " & "  %4.2f (consmean`type'1stHalfuk) " & "  %4.2f (consmean`type'1stHalfus) " & "  %4.2f (consmean`type'1stHalfAll)  $eolString _n;

	file write `hh' "Investment & " %4.2f (invmean`type'1stHalfcn) " & "   %4.2f (invmean`type'1stHalffr) " & "  %4.2f (invmean`type'1stHalfge) " & "  %4.2f (invmean`type'1stHalfit) " & "  %4.2f (invmean`type'1stHalfjp) " & "  %4.2f (invmean`type'1stHalfuk) " & "  %4.2f (invmean`type'1stHalfus) " & "  %4.2f (invmean`type'1stHalfAll)  $eolString _n;

	file write `hh' "Unemployment & " %4.2f (unmean`type'1stHalfcn) " & "   %4.2f (unmean`type'1stHalffr) " & "  %4.2f (unmean`type'1stHalfge) " & "  %4.2f (unmean`type'1stHalfit) " & "  %4.2f (unmean`type'1stHalfjp) " & "  %4.2f (unmean`type'1stHalfuk) " & "  %4.2f (unmean`type'1stHalfus) " & "  %4.2f (unmean`type'1stHalfAll)  $eolString _n;

	file write `hh' "IP & " %4.2f (ipmean`type'1stHalfcn) " & "   %4.2f (ipmean`type'1stHalffr) " & "  %4.2f (ipmean`type'1stHalfge) " & "  %4.2f (ipmean`type'1stHalfit) " & "  %4.2f (ipmean`type'1stHalfjp) " & "  %4.2f (ipmean`type'1stHalfuk) " & "  %4.2f (ipmean`type'1stHalfus) " & "  %4.2f (ipmean`type'1stHalfAll)  $eolString _n;

	******************************************************************************************************************************;
	file write `hh' "\midrule" _n "\multicolumn{8}{l}{1999+} " $eolString _n;

	file write `hh' "Inflation & " %4.2f (inflmean`type'2ndHalfcn) " & "   %4.2f (inflmean`type'2ndHalffr) " & "  %4.2f (inflmean`type'2ndHalfge) " & "  %4.2f (inflmean`type'2ndHalfit) " & "  %4.2f (inflmean`type'2ndHalfjp) " & "  %4.2f (inflmean`type'2ndHalfuk) " & "  %4.2f (inflmean`type'2ndHalfus)  $eolString _n;

	file write `hh' "Interest Rate & " %4.2f (r3mmean`type'2ndHalfcn) " & "   %4.2f (r3mmean`type'2ndHalffr) " & "  %4.2f (r3mmean`type'2ndHalfge) " & "  %4.2f (r3mmean`type'2ndHalfit) " & "  %4.2f (r3mmean`type'2ndHalfjp) " & "  %4.2f (r3mmean`type'2ndHalfuk) " & "  %4.2f (r3mmean`type'2ndHalfus) " & "  %4.2f (r3mmean`type'2ndHalfAll)  $eolString _n;

	file write `hh' "GDP & " %4.2f (gdpmean`type'2ndHalfcn) " & "   %4.2f (gdpmean`type'2ndHalffr) " & "  %4.2f (gdpmean`type'2ndHalfge) " & "  %4.2f (gdpmean`type'2ndHalfit) " & "  %4.2f (gdpmean`type'2ndHalfjp) " & "  %4.2f (gdpmean`type'2ndHalfuk) " & "  %4.2f (gdpmean`type'2ndHalfus) " & "  %4.2f (gdpmean`type'2ndHalfAll)  $eolString _n;

	file write `hh' "Investment & " %4.2f (invmean`type'2ndHalfcn) " & "   %4.2f (invmean`type'2ndHalffr) " & "  %4.2f (invmean`type'2ndHalfge) " & "  %4.2f (invmean`type'2ndHalfit) " & "  %4.2f (invmean`type'2ndHalfjp) " & "  %4.2f (invmean`type'2ndHalfuk) " & "  %4.2f (invmean`type'2ndHalfus) " & "  %4.2f (invmean`type'2ndHalfAll)  $eolString _n;

	file write `hh' "Consumption & " %4.2f (consmean`type'2ndHalfcn) " & "   %4.2f (consmean`type'2ndHalffr) " & "  %4.2f (consmean`type'2ndHalfge) " & "  %4.2f (consmean`type'2ndHalfit) " & "  %4.2f (consmean`type'2ndHalfjp) " & "  %4.2f (consmean`type'2ndHalfuk) " & "  %4.2f (consmean`type'2ndHalfus) " & "  %4.2f (consmean`type'2ndHalfAll)  $eolString _n;

	file write `hh' "Unemployment & " %4.2f (unmean`type'2ndHalfcn) " & "   %4.2f (unmean`type'2ndHalffr) " & "  %4.2f (unmean`type'2ndHalfge) " & "  %4.2f (unmean`type'2ndHalfit) " & "  %4.2f (unmean`type'2ndHalfjp) " & "  %4.2f (unmean`type'2ndHalfuk) " & "  %4.2f (unmean`type'2ndHalfus) " & "  %4.2f (unmean`type'2ndHalfAll)  $eolString _n;

	file write `hh' "IP & " %4.2f (ipmean`type'2ndHalfcn) " & "   %4.2f (ipmean`type'2ndHalffr) " & "  %4.2f (ipmean`type'2ndHalfge) " & "  %4.2f (ipmean`type'2ndHalfit) " & "  %4.2f (ipmean`type'2ndHalfjp) " & "  %4.2f (ipmean`type'2ndHalfuk) " & "  %4.2f (ipmean`type'2ndHalfus) " & "  %4.2f (ipmean`type'2ndHalfAll)  $eolString _n;

	file write `hh' " \bottomrule" _n "\multicolumn{8}{p{11.5cm}}{" _n "\showEstTime{Estimated: $S_DATE, $S_TIME}" _n _n;

	file write `hh' " {\scriptsize Notes:  Averages taken across time periods. }" _n "}" _n;

	file write `hh' "\end{tabular}" _n;
	file write `hh' "\end{center}" _n;

	file write `hh' "\end{table} " _n;
	file close `hh';
};