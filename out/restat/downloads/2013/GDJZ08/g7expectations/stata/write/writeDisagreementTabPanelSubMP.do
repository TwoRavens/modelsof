#delimit;
tempname hh;
file open `hh' using "$docPath/driversOfDisagreement/tDisagrPanelSubMP$variable$disagrVar.tex", write replace;
file write `hh' _n;

local var "$variable"; local varUpper=upper("`var'");
local disagrVar "$disagrVar";

file write `hh' "\begin{sidewaystable}\small" _n;
file write `hh' "\caption{ Disagreement and Business Cycle---Selected Panel Results on MP Credibility, `varUpper', `disagrVar' \label{tDisagrPanelSubMP`var'`disagrVar'}}" _n;
file write `hh' "\begin{center} " _n "\begin{tabular}{@{}cd{4}d{4}d{4}d{4}d{4}d{4}d{4}d{4}d{4}d{4}d{4}@{}} "
_n "\toprule " _n;
file write `hh' " Model & \multicolumn{1}{c}{$\beta_0$} & \multicolumn{1}{c}{$\beta_1$} & \multicolumn{1}{c}{$\beta_2$} &  \multicolumn{1}{c}{$\beta_3$} &  \multicolumn{1}{c}{$\beta_4$}&  \multicolumn{1}{c}{$\beta_0^{MP}$} & \multicolumn{1}{c}{$\beta_1^{MP}$} & \multicolumn{1}{c}{$\beta_2^{MP}$} &  \multicolumn{1}{c}{$\beta_3^{MP}$} &  \multicolumn{1}{c}{$\beta_4^{MP}$}& \multicolumn{1}{c}{$\bar{R}^2$}  " $eolString _n;

* Panel A;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{12}{c}{Panel A: Disagreement over Time}" $eolString _n;
file write `hh' "\multicolumn{12}{c}{$ \textrm{da}_t=\beta_0+\beta_1\times \textrm{rec}_t+\beta_2\times\textrm{post-1998}_{t}+\beta_3\times\textrm{da}_{t-1}+\textrm{MP cred}_t\times(\beta_0^{MP}+\beta_1^{MP}\times \textrm{rec}_t+\beta_2^{MP}\times\textrm{post-1998}_{t}+\beta_3^{MP}\times\textrm{da}_{t-1})+\varepsilon_t$} " $eolString _n;
file write `hh' "\midrule" _n;

sca ptest = 2*(1-normal(abs(`var'Reg1MPpointConst)/`var'Reg1MPseConst));
do MakeTestStringJ;
file write `hh' " 1. & " %5.3f (`var'Reg1MPpointConst) (teststr);
file write `hh' " & & & & ";
sca ptest = 2*(1-normal(abs(`var'Reg1MPpointConstCred)/`var'Reg1MPseConstCred));
do MakeTestStringJ;
file write `hh' " & " %5.3f (`var'Reg1MPpointConstCred) (teststr);
file write `hh' " & & & & &" %5.3f (`var'Reg1MPrbar) $eolString _n;
file write `hh' "  & (" %5.3f (`var'Reg1MPseConst) ") & & & & &  (";
file write `hh' %5.3f (`var'Reg1MPseConstCred) ") & & & & &  " $eolString _n;

file write `hh' " 2. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg2MPpointConst)/`var'Reg2MPseConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg2MPpointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg2MPpointRecession)/`var'Reg2MPseRecession));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg2MPpointRecession) (teststr)  " & & & &  "; 

sca ptest = 2*(1-normal(abs(`var'Reg2MPpointConstCred)/`var'Reg2MPseConstCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg2MPpointConstCred) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg2MPpointRecCred)/`var'Reg2MPseRecCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg2MPpointRecCred) (teststr)  " & & & & " %5.3f (`var'Reg2MPrbar) $eolString _n;

file write `hh' "  & (" %5.3f (`var'Reg2MPseConst) ") & (" %5.3f (`var'Reg2MPseRecession) ") & & & & (" %5.3f (`var'Reg2MPseConstCred) ") & (" %5.3f (`var'Reg2MPseRecCred) ") & & & " $eolString _n;

file write `hh' " 3. & &  & & & & & & & & & " $eolString _n;
file write `hh' " & &  & & & & & & & & & " $eolString _n;


* Panel B;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{12}{c}{Panel B: Disagreement and Macro Variables} " $eolString _n;
file write `hh' "\multicolumn{12}{c}{$ \textrm{da}_t=\beta_0+\beta_1\times `varUpper'_t+\beta_2\times\Delta_{12} `varUpper'^2_t+\beta_3\times \textrm{gap}_t+\beta_4\times\Delta\textrm{policy}_t^2+{} $} " $eolString _n;
file write `hh' "\multicolumn{12}{c}{$ {}+\textrm{MP cred}_t\times(\beta_0^{MP}+\beta_1^{MP}\times `varUpper'_t+\beta_2^{MP}\times\Delta_{12} `varUpper'^2_t+\beta_3^{MP}\times \textrm{gap}_t+\beta_4^{MP}\times\Delta\textrm{policy}_t^2)+
\varepsilon_t$} " $eolString _n;
file write `hh' "\midrule" _n;

sca ptest = 2*(1-normal(abs(`var'Reg4MPpointConst)/`var'Reg4MPseConst));
do MakeTestStringJ;
file write `hh' " 5. & " %5.3f (`var'Reg4MPpointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg4MPpoint`var')/`var'Reg4MPse`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg4MPpoint`var') (teststr)  " & & & &  ";

sca ptest = 2*(1-normal(abs(`var'Reg4MPpointConstCred)/`var'Reg4MPseConstCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg4MPpointConstCred) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg4MPpoint`var'Cred)/`var'Reg4MPse`var'Cred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg4MPpoint`var'Cred) (teststr)  " & & & &" %5.3f (`var'Reg4MPrbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg4MPseConst) ") & (" %5.3f (`var'Reg4MPse`var') ") & & & & (" %5.3f (`var'Reg4MPseConstCred) ") & (" %5.3f (`var'Reg4MPse`var'Cred) ") & & & & " $eolString _n;

file write `hh' " 6. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg5MPpointConst)/`var'Reg5MPseConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5MPpointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg5MPpoint`var')/`var'Reg5MPse`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5MPpoint`var') (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg5MPpointd`var'Sq)/`var'Reg5MPsed`var'Sq));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5MPpointd`var'Sq) (teststr)  " & & &   ";

sca ptest = 2*(1-normal(abs(`var'Reg5MPpointConstCred)/`var'Reg5MPseConstCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5MPpointConstCred) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg5MPpoint`var'Cred)/`var'Reg5MPse`var'Cred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5MPpoint`var'Cred) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg5MPpointd`var'SqCred)/`var'Reg5MPsed`var'SqCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5MPpointd`var'SqCred) (teststr)  " & & &" %5.3f (`var'Reg5MPrbar) $eolString _n;

file write `hh' "  & (" %5.3f (`var'Reg5MPseConst) ") & (" %5.3f (`var'Reg5MPse`var') ") & ( " %5.3f (`var'Reg5MPsed`var'Sq)  " ) & &  & (" %5.3f (`var'Reg5MPseConstCred) ") & (" %5.3f (`var'Reg5MPse`var'Cred) ") & ( " %5.3f (`var'Reg5MPsed`var'SqCred)  " ) & & &  " $eolString _n;

**************************;

file write `hh' " 7. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg7MPpointConst)/`var'Reg7MPseConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7MPpointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg7MPpoint`var')/`var'Reg7MPse`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7MPpoint`var') (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg7MPpointd`var'Sq)/`var'Reg7MPsed`var'Sq));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7MPpointd`var'Sq) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg7MPpointGDP)/`var'Reg7MPseGDP));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7MPpointGDP) (teststr)  " & &  ";

sca ptest = 2*(1-normal(abs(`var'Reg7MPpointConstCred)/`var'Reg7MPseConstCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7MPpointConstCred) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg7MPpoint`var'Cred)/`var'Reg7MPse`var'Cred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7MPpoint`var'Cred) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg7MPpointd`var'SqCred)/`var'Reg7MPsed`var'SqCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7MPpointd`var'SqCred) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg7MPpointGDPcred)/`var'Reg7MPseGDPcred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7MPpointGDPcred) (teststr)  " & &  " %5.3f (`var'Reg7MPrbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg7MPseConst) ") & (" %5.3f (`var'Reg7MPse`var') ") & ( " %5.3f (`var'Reg7MPsed`var'Sq)  " ) & ( " %5.3f (`var'Reg7MPseGDP) " )  & & (" %5.3f (`var'Reg7MPseConstCred) ") & (" %5.3f (`var'Reg7MPse`var'Cred) ") & ( " %5.3f (`var'Reg7MPsed`var'SqCred)  " ) & ( " %5.3f (`var'Reg7MPseGDPcred) " )  & &   " $eolString _n;

file write `hh' " 8. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg9MPpointConst)/`var'Reg9MPseConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9MPpointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg9MPpoint`var')/`var'Reg9MPse`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9MPpoint`var') (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg9MPpointd`var'Sq)/`var'Reg9MPsed`var'Sq));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9MPpointd`var'Sq) (teststr)  " & &";

sca ptest = 2*(1-normal(abs(`var'Reg9MPpointRate)/`var'Reg9MPseRate));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9MPpointRate) (teststr)  " &  ";

sca ptest = 2*(1-normal(abs(`var'Reg9MPpointConstCred)/`var'Reg9MPseConstCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9MPpointConstCred) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg9MPpoint`var'Cred)/`var'Reg9MPse`var'Cred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9MPpoint`var'Cred) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg9MPpointd`var'SqCred)/`var'Reg9MPsed`var'SqCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9MPpointd`var'SqCred) (teststr)  " & &";

sca ptest = 2*(1-normal(abs(`var'Reg9MPpointRateCred)/`var'Reg9MPseRateCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9MPpointRateCred) (teststr)  " &  " %5.3f (`var'Reg9MPrbar) $eolString _n;

file write `hh' "  & (" %5.3f (`var'Reg9MPseConst) ") & (" %5.3f (`var'Reg9MPse`var') ") & ( " %5.3f (`var'Reg9MPsed`var'Sq)  " ) & & ( " %5.3f (`var'Reg9MPseRate) " )   &  (" %5.3f (`var'Reg9MPseConstCred) ") & (" %5.3f (`var'Reg9MPse`var'Cred) ") & ( " %5.3f (`var'Reg9MPsed`var'SqCred)  " ) & & ( " %5.3f (`var'Reg9MPseRateCred) " )   &   " $eolString _n;

* The end;
*****************************************************************************;

file write `hh' " \bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}" $eolString _n;

file write `hh' " {\scriptsize Notes: Fixed effects estimators. $\beta_0$ denotes the average of country-specific intercepts." _char(96) _char(96) _char(36) "\textrm{post-1998}_{t}" _char(36) _char(39) _char(39) " denotes a dummy variable which equals 0 before 1999 and 1 after 1998. " _char(96) _char(96) _char(36) "\textrm{recession}_t" _char(36) _char(39) _char(39) " denotes a dummy variable which equals 1 during recession set by the Economic Cycle Research Institute (ECRI) and 0 otherwise. " _char(96) _char(96) _char(36) "\textrm{output gap}_{t}" _char(36) _char(39) _char(39) " denotes the ex-post output gap estimated in the OECD quarterly output gap revisions database (in August 2008). " _char(36) "\Delta_{12}`varUpper'^2_t\equiv(`varUpper'_t-`varUpper'_{t-12})^2" _char(36) ". " _char(96) _char(96) _char(36) "\textrm{MP Independence}_{t}" _char(36) _char(39) _char(39) " denotes a $0-1$ indicator of independent monetary policy defined in table \dots. } " _n;
file write `hh' "\end{sidewaystable} " _n;
file close `hh';
