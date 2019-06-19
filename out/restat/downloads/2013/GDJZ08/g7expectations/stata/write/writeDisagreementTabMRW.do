#delimit;
tempname hh;
file open `hh' using "$docPath/driversOfDisagreement/tDisAgrMRW$variable$disagrVar.tex", write replace;
file write `hh' _n;

local var "$variable";  local varUpper=upper("`var'");

file write `hh' "\begin{table}\small" _n;
file write `hh' "\caption{ Disagreement and Business Cycle---`varUpper' \label{tDisagrAllBC`var'}}" _n;
file write `hh' "\begin{center} " _n "\begin{tabular}{@{}ld{4}d{4}d{4}d{4}d{4}d{4}d{4}@{}} "
_n "\toprule " _n;
file write `hh' " & \multicolumn{1}{c}{Canada} & \multicolumn{1}{c}{France} & \multicolumn{1}{c}{Germany} &  \multicolumn{1}{c}{Italy} & \multicolumn{1}{c}{Japan} & \multicolumn{1}{c}{UK} & \multicolumn{1}{c}{US}  " $eolString _n;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{8}{c}{Panel A: Bivariate regressions} " $eolString _n;
file write `hh' "\midrule" _n;

local Ccodes cn fr ge it jp uk us; 

* Panel A;
*****************************************************************************;

file write `hh' " `varUpper'  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'LevVarPointUni`C')/`var'LevVarSeUni`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'LevVarPointUni`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'LevVarSeUni`C') ") ";
};
file write `hh' $eolString ;

file write `hh' "$\Delta$ `varUpper'\${}^2$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'SqVarPointUni`C')/`var'SqVarSeUni`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'SqVarPointUni`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'SqVarSeUni`C') ") ";
};
file write `hh' $eolString ;

file write `hh' "GDP  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'gdpVarPointUni`C')/`var'gdpVarSeUni`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'gdpVarPointUni`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'gdpVarSeUni`C') ") ";
};
file write `hh' $eolString ;

* Panel B;
*****************************************************************************;

file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{8}{c}{Panel B: Regression controlling for inflation rate} " $eolString _n;
file write `hh' "\midrule" _n;

file write `hh' "$\Delta$ `varUpper'\${}^2$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'SqVarPointBi`C')/`var'SqVarSeBi`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'SqVarPointBi`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'SqVarSeBi`C') ") ";
};
file write `hh' $eolString ;

file write `hh' "GDP  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'gdpVarPointBi`C')/`var'gdpVarSeBi`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'gdpVarPointBi`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'gdpVarSeBi`C') ") ";
};
file write `hh' $eolString ;

* Panel C;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{8}{c}{Panel C: Multivariate regressions} " $eolString _n;
file write `hh' "\midrule" _n;

file write `hh' " `varUpper'  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'LevVarPointMulti`C')/`var'LevVarSeMulti`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'LevVarPointMulti`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'LevVarSeMulti`C') ") ";
};
file write `hh' $eolString ;

file write `hh' "$\Delta$ `varUpper'\${}^2$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'SqVarPointMulti`C')/`var'SqVarSeMulti`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'SqVarPointMulti`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'SqVarSeMulti`C') ") ";
};
file write `hh' $eolString ;

file write `hh' "GDP  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'gdpVarPointMulti`C')/`var'gdpVarSeMulti`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'gdpVarPointMulti`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'gdpVarSeMulti`C') ") ";
};
file write `hh' $eolString ;

file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}" $eolString _n;

file write `hh' " {\scriptsize Notes:  \dots .}" _n;
file write `hh' "\end{table} " _n;
file close `hh';


