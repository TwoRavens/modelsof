#delimit;
tempname hh;
file open `hh' using "$docPath/consensusEfficiency/tConsEff$variable.tex", write replace;
file write `hh' _n;

local var "$variable";  local varUpper=upper("`var'");

file write `hh' "\begin{table}\small" _n;
file write `hh' "\caption{ Efficiency of Consensus (Mean) Forecasts---`varUpper' \label{tConsEffAllC`var'}}" _n;
file write `hh' "\begin{center} " _n "\begin{tabular}{@{}ld{4}d{4}d{4}d{4}d{4}d{4}d{4}@{}} "
_n "\toprule " _n;
file write `hh' " & \multicolumn{1}{c}{Canada} & \multicolumn{1}{c}{France} & \multicolumn{1}{c}{Germany} &  \multicolumn{1}{c}{Italy} & \multicolumn{1}{c}{Japan} & \multicolumn{1}{c}{UK} & \multicolumn{1}{c}{US}  " $eolString _n;

local Ccodes cn fr ge it jp uk us; 

* Panel A;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{8}{c}{Panel A: Are Forecasts Biased?: $ F_t=\beta_0+\varepsilon_t$} " $eolString _n;
file write `hh' "\midrule" _n;

file write `hh' " $\beta_0$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'biasPoint`C')/`var'biasSe`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'biasPoint`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'biasSe`C') ") ";
};
file write `hh' $eolString ;

* Panel B;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{8}{c}{Panel B: Is Information Fully Exploited?: $ e_t=\beta_0+\beta_1\times F_t+\varepsilon_t$} " $eolString _n;
file write `hh' "\midrule" _n;

file write `hh' " $\beta_0$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'fullInfoConstPoint`C')/`var'fullInfoConstSe`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'fullInfoConstPoint`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'fullInfoConstSe`C') ") ";
};
file write `hh' $eolString ;


file write `hh' " $\beta_1$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'fullInfoMeanPoint`C')/`var'fullInfoMeanSe`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'fullInfoMeanPoint`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'fullInfoMeanSe`C') ") ";
};
file write `hh' $eolString ;

* Panel C;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{8}{c}{Panel C: Are Errors Persistent?: $ e_t=\beta_0+\beta_1\times e_{t-12}+\varepsilon_t$} " $eolString _n;
file write `hh' "\midrule" _n;

file write `hh' " $\beta_0$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'errPerConstPoint`C')/`var'errPerConstSe`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'errPerConstPoint`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'fullInfoConstSe`C') ") ";
};
file write `hh' $eolString ;


file write `hh' " $\beta_1$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'errPerMeanPoint`C')/`var'errPerMeanSe`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'errPerMeanPoint`C') (teststr);
};
file write `hh' $eolString ;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'errPerMeanSe`C') ") ";
};
file write `hh' $eolString ;


* Panel D;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{8}{c}{Panel D: Are Forecasts Efficient?} " $eolString _n;
file write `hh' "\multicolumn{8}{c}{$ e_t=\beta_0+\beta_1 `varUpper'_{t-1}+\beta_2 IP_{t-1}+
\beta_3 un_{t-1}+\beta_4 R3M_{t-1}+\beta_5 ER_{t-1}+\varepsilon_t$} " $eolString _n;
file write `hh' "\midrule" _n;

file write `hh' " $\beta_0$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'effConstPoint`C')/`var'effConstSe`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'effConstPoint`C') (teststr);
};
file write `hh' $eolString  _n;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'effConstSe`C') ") ";
};
file write `hh' $eolString  _n;


file write `hh' " $\beta_1$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'eff`var'Point`C')/`var'eff`var'Se`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'eff`var'Point`C') (teststr);
};
file write `hh' $eolString  _n;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'eff`var'Se`C') ") ";
};
file write `hh' $eolString  _n;


file write `hh' " $\beta_2$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'effipPoint`C')/`var'effipSe`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'effipPoint`C') (teststr);
};
file write `hh' $eolString  _n;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'effipSe`C') ") ";
};
file write `hh' $eolString  _n;


file write `hh' " $\beta_3$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'effunPoint`C')/`var'effunSe`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'effunPoint`C') (teststr);
};
file write `hh' $eolString  _n;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'effunSe`C') ") ";
};
file write `hh' $eolString  _n;


file write `hh' " $\beta_4$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'effr3mPoint`C')/`var'effr3mSe`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'effr3mPoint`C') (teststr);
};
file write `hh' $eolString  _n;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'effr3mSe`C') ") ";
};
file write `hh' $eolString  _n;


file write `hh' " $\beta_5$  ";
foreach C of local Ccodes {;
	sca ptest = 2*(1-norm(abs(`var'effxrPoint`C')/`var'effxrSe`C'));
	do MakeTestStringJ;
	file write `hh' "  & " %5.3f (`var'effxrPoint`C') (teststr);
};
file write `hh' $eolString  _n;

foreach C of local Ccodes {;
	file write `hh' "  & (" %5.3f (`var'effxrSe`C') ") ";
};
file write `hh' $eolString  _n;

*****************************************************************************;
file write `hh' "\bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}" $eolString _n;

file write `hh' " {\scriptsize Notes:  \dots .}" _n;
file write `hh' "\end{table} " _n;
file close `hh';


