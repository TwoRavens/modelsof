#delimit;
tempname hh;
file open `hh' using "$docPath/driversOfDisagreement/tDisagrSummaryPanelA$variable$disagrVar.tex", write replace;
file write `hh' _n;

local var "$variable"; local varUpper=upper("`var'");
local disagrVar "$disagrVar";
local robustLags "$robustLags";
local uncertaintyLabel "Delta Squared";
if "$uncertaintyMeasure"=="2" {; local uncertaintyLabel "variance of the permanent component of `varUpper'"; };
if "$uncertaintyMeasure"=="3" {; local uncertaintyLabel "variance of the permanent ${}+{}2\times$ variance of transitory component of `varUpper'"; };

file write `hh' "\begin{table}" _n;
file write `hh' "\caption{ Disagreement Over Time and Business Cycle---Country-by-Country Results, `varUpper'"; *, `disagrVar', uncertainty: `uncertaintyLabel';
file write `hh' "\label{tDisagrSummaryPanelA`var'`disagrVar'}}" _n;
file write `hh' "\begin{center} " _n "\begin{tabular}{@{}cd{4}d{4}d{4}d{4}d{4}d{4}@{}} " _n "\toprule " _n;
file write `hh' " Country & \multicolumn{1}{c}{$\beta_0$} & \multicolumn{1}{c}{$\beta_1$} & \multicolumn{1}{c}{$\beta_2$} & \multicolumn{1}{c}{$\beta_3$} & \multicolumn{1}{c}{$\beta_4$} & \multicolumn{1}{c}{$\bar{R}^2$}  " $eolString _n "\midrule" _n; 
file write `hh' "\multicolumn{7}{c}{Panel A: Disagreement over Time}" $eolString _n;
file write `hh' "\multicolumn{7}{c}{$ \textrm{disagreement}_t=\beta_0+\beta_1\times \textrm{recession}_t+\beta_2\times\textrm{post-1998}_{t}+ u_t$} " $eolString _n;
file write `hh' "\midrule" _n;

local Ccodes cn fr ge it jp uk us;

foreach C of local Ccodes {;
	
	local cntryUpper=upper("`C'");

	file write `hh' " `cntryUpper' & ";
	sca ptest = 2*(1-normal(abs(`var'Reg3ApointConst`C')/`var'Reg3AseConst`C'));
	do MakeTestStringJ;
	file write `hh' %5.3f (`var'Reg3ApointConst`C') (teststr) " & ";

	sca ptest = 2*(1-normal(abs(`var'Reg3ApointRecession`C')/`var'Reg3AseRecession`C'));
	do MakeTestStringJ;
	file write `hh' %5.3f (`var'Reg3ApointRecession`C') (teststr)  " & ";

	sca ptest = 2*(1-normal(abs(`var'Reg3Apoint2ndHalf`C')/`var'Reg3Ase2ndHalf`C'));
	do MakeTestStringJ;
	file write `hh' %5.3f (`var'Reg3Apoint2ndHalf`C') (teststr)  " & & &" %5.3f (`var'Reg3Arbar`C') $eolString;

	file write `hh' "  & (" %5.3f (`var'Reg3AseConst`C') ") & (" %5.3f (`var'Reg3AseRecession`C') ") & ( " %5.3f (`var'Reg3Ase2ndHalf`C')  " ) & & &" $eolString _n;

};

* Panel B;
************************************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{7}{c}{Panel B: Disagreement and Macro Variables} " $eolString _n;
file write `hh' "\multicolumn{7}{c}{$ \textrm{disagreement}_t=\beta_0+\beta_1\times `varUpper'_t+\beta_2\times\sigma^2_{`varUpper',t}+ {} $} " $eolString _n;
file write `hh' "\multicolumn{7}{c}{$ {}+ \beta_3\times \textrm{output gap}_t+\beta_4\times\Delta\textrm{policy rate}_t^2+u_t $} " $eolString _n;
file write `hh' "\midrule" _n;

foreach C of local Ccodes {;
	
	local cntryUpper=upper("`C'");

	file write `hh' " `cntryUpper' & ";
	sca ptest = 2*(1-normal(abs(`var'Reg7pointConst`C')/`var'Reg7seConst`C'));
	do MakeTestStringJ;
	file write `hh' %5.3f (`var'Reg7pointConst`C') (teststr) " & ";

	sca ptest = 2*(1-normal(abs(`var'Reg7point`var'`C')/`var'Reg7se`var'`C'));
	do MakeTestStringJ;
	file write `hh' %5.3f (`var'Reg7point`var'`C') (teststr)  " & ";

	sca ptest = 2*(1-normal(abs(`var'Reg7pointd`var'Sq`C')/`var'Reg7sed`var'Sq`C'));
	do MakeTestStringJ;
	file write `hh' %5.3f (`var'Reg7pointd`var'Sq`C') (teststr)  " & ";

	sca ptest = 2*(1-normal(abs(`var'Reg7pointGDP`C')/`var'Reg7seGDP`C'));
	do MakeTestStringJ;
	file write `hh' %5.3f (`var'Reg7pointGDP`C') (teststr)  " & ";

	sca ptest = 2*(1-normal(abs(`var'Reg7pointRate`C')/`var'Reg7seRate`C'));
	do MakeTestStringJ;
	file write `hh' %5.3f (`var'Reg7pointRate`C') (teststr)  " &  " %5.3f (`var'Reg7rbar`C') $eolString;

	file write `hh' "  & (" %5.3f (`var'Reg7seConst`C') ") & (" %5.3f (`var'Reg7se`var'`C') ") & ( " %5.3f (`var'Reg7sed`var'Sq`C')  " ) & ("  %5.3f (`var'Reg7seGDP`C')  " )& ( " %5.3f (`var'Reg7seRate`C') " )  & " $eolString _n;

};

file write `hh' " \bottomrule" _n "\multicolumn{7}{p{11cm}}{" _n "\showEstTime{Estimated: $S_DATE, $S_TIME \newline}"_n;

file write `hh' " {\scriptsize Notes: Country-by-country regressions, Newey--West standard errors, " %2.0f (`robustLags') 
" lags. The dependent variable is measured as cross-sectional `disagrVar'. $\beta_0$ denotes the average of country-specific intercepts." _char(96) _char(96) _char(36) "\textrm{post-1998}_{t}" _char(36) _char(39) _char(39) " denotes a dummy variable which equals 0 before 1999 and 1 after 1998. " _char(96) _char(96) _char(36) "\textrm{recession}_t" _char(36) _char(39) _char(39) " denotes a dummy variable which equals 1 during recession set by the Economic Cycle Research Institute (ECRI) and 0 otherwise. " _char(36) "\sigma^2_{`varUpper',t}" _char(36) " denotes `uncertaintyLabel'. " _char(96) _char(96) _char(36) "\textrm{output gap}_{t}" _char(36) _char(39) _char(39) " denotes the ex-post output gap estimated in the OECD Economic Outlook quarterly output gap revisions database (in August 2008). }" _n "}" _n;

file write `hh' "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\end{table} " _n;
file close `hh';

