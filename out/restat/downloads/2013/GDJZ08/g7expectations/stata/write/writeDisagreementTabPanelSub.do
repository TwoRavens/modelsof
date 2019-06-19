#delimit;
tempname hh;
file open `hh' using "$docPath/driversOfDisagreement/tDisagrPanelSub$variable$disagrVar.tex", write replace;
file write `hh' _n;

local var "$variable"; local varUpper=upper("`var'");
local disagrVar "$disagrVar";
local robustLags "$robustLags";
local uncertaintyLabel "Delta `varUpper' Squared";
if "$uncertaintyMeasure"=="2" {; local uncertaintyLabel "variance of the permanent component of `varUpper'"; };
if "$uncertaintyMeasure"=="3" {; local uncertaintyLabel "variance of the permanent ${}+{}2\times$ variance of transitory component of `varUpper'"; };

file write `hh' "\begin{table}\small" _n;
file write `hh' "\caption{ Disagreement and Business Cycle---Panel Results, `varUpper'"; *, `disagrVar', uncertainty: `uncertaintyLabel'; 
file write `hh' "\label{tDisagrPanelSub`var'`disagrVar'}}" _n;
file write `hh' "\begin{center} " _n "\begin{tabular}{@{}cd{4}d{4}d{4}d{4}d{4}d{4}d{4}@{}} "
_n "\toprule " _n;
file write `hh' " Model & \multicolumn{1}{c}{$\beta_0$} & \multicolumn{1}{c}{$\beta_1$} & \multicolumn{1}{c}{$\beta_2$} &  \multicolumn{1}{c}{$\beta_3$} &  \multicolumn{1}{c}{$\beta_4$}&  \multicolumn{1}{c}{$\beta_5$} & \multicolumn{1}{c}{$\bar{R}^2$}  " $eolString _n;

* Panel A;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{8}{c}{Panel A: Disagreement over Time}" $eolString _n;
file write `hh' "\multicolumn{8}{c}{$ \textrm{disagr}_t=\beta_0+\beta_1\times \textrm{rec}_t+\beta_2\times\textrm{post-1998}_{t}+u_t {} $} " $eolString _n;
*file write `hh' "\multicolumn{8}{c}{$ {} +\beta_3\times\textrm{disagreement}_{t-1}+u_t$} " $eolString _n;
file write `hh' "\midrule" _n;

sca ptest = 2*(1-normal(abs(`var'Reg1pointConst)/`var'Reg1seConst));
do MakeTestStringJ;
file write `hh' " 1. & " %5.3f (`var'Reg1pointConst) (teststr);
file write `hh' " & & & & & & " %5.3f (`var'Reg1rbar) $eolString ;
file write `hh' "  & (" %5.3f (`var'Reg1seConst) ") & & & & & & " $eolString _n;

file write `hh' " 2. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg2pointConst)/`var'Reg2seConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg2pointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg2pointRecession)/`var'Reg2seRecession));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg2pointRecession) (teststr)  " & & & & & " %5.3f (`var'Reg2rbar) $eolString ;;

file write `hh' "  & (" %5.3f (`var'Reg2seConst) ") & (" %5.3f (`var'Reg2seRecession) ") & & & & & " $eolString _n;

file write `hh' " 3. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg3ApointConst)/`var'Reg3AseConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3ApointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg3ApointRecession)/`var'Reg3AseRecession));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3ApointRecession) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg3Apoint2ndHalf)/`var'Reg3Ase2ndHalf));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3Apoint2ndHalf) (teststr)  " & & & &" %5.3f (`var'Reg3Arbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg3AseConst) ") & (" %5.3f (`var'Reg3AseRecession) ") &  ( " %5.3f (`var'Reg3Ase2ndHalf)  " ) & &  & " $eolString _n;

* Panel B;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{8}{c}{Panel B: Disagreement and Macro Variables} " $eolString _n;
file write `hh' "\multicolumn{8}{c}{$ \textrm{disagr}_t=\beta_0+\beta_2\times `varUpper'_t+\beta_3\times\sigma^2_{`varUpper',t}+ \beta_4\times \textrm{output gap}_t+ {} $} " $eolString _n;
file write `hh' "\multicolumn{8}{c}{$ {}+ \beta_5\times\Delta\textrm{policy rate}_t^2+u_t $} " $eolString _n;
file write `hh' "\midrule" _n;

sca ptest = 2*(1-normal(abs(`var'Reg4pointConst)/`var'Reg4seConst));
do MakeTestStringJ;
file write `hh' " 4. & " %5.3f (`var'Reg4pointConst) (teststr) " & &";

sca ptest = 2*(1-normal(abs(`var'Reg4point`var')/`var'Reg4se`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg4point`var') (teststr)  " & & & & " %5.3f (`var'Reg4rbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg4seConst) ") & & (" %5.3f (`var'Reg4se`var') ") & & & & " $eolString _n;

file write `hh' " 5. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg5pointConst)/`var'Reg5seConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5pointConst) (teststr) " & & ";

sca ptest = 2*(1-normal(abs(`var'Reg5point`var')/`var'Reg5se`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5point`var') (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg5pointd`var'Sq)/`var'Reg5sed`var'Sq));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5pointd`var'Sq) (teststr)  " & & &  " %5.3f (`var'Reg5rbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg5seConst) ") & & (" %5.3f (`var'Reg5se`var') ") & ( " %5.3f (`var'Reg5sed`var'Sq)  " ) & & & " $eolString _n;

**************************;

file write `hh' " 6. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg7pointConst)/`var'Reg7seConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7pointConst) (teststr) " & & ";

sca ptest = 2*(1-normal(abs(`var'Reg7point`var')/`var'Reg7se`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7point`var') (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg7pointd`var'Sq)/`var'Reg7sed`var'Sq));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7pointd`var'Sq) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg7pointGDP)/`var'Reg7seGDP));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7pointGDP) (teststr)  " & & " %5.3f (`var'Reg7rbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg7seConst) ") & & (" %5.3f (`var'Reg7se`var') ") & ( " %5.3f (`var'Reg7sed`var'Sq)  " ) & ( " %5.3f (`var'Reg7seGDP) " )  & &  " $eolString _n;

file write `hh' " 7. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg10pointConst)/`var'Reg10seConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10pointConst) (teststr) " & &";

sca ptest = 2*(1-normal(abs(`var'Reg10point`var')/`var'Reg10se`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10point`var') (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg10pointd`var'Sq)/`var'Reg10sed`var'Sq));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10pointd`var'Sq) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg10pointGDP)/`var'Reg10seGDP));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10pointGDP) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg10pointRate)/`var'Reg10seRate));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10pointRate) (teststr)  " & " %5.3f (`var'Reg10rbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg10seConst) ") & & (" %5.3f (`var'Reg10se`var') ") & ( " %5.3f (`var'Reg10sed`var'Sq)  " ) & ("  %5.3f (`var'Reg10seGDP)  " )& ( " %5.3f (`var'Reg10seRate) " )   &  " $eolString _n;

* Panel C;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{8}{c}{Panel C: Disagreement and Central Bank Independence} " $eolString _n;

file write `hh' "\multicolumn{8}{c}{$ \textrm{disagr}_t=\beta_0+\beta_1\times \textrm{CB Independence}_t+\beta_2\times `varUpper'_t+\beta_3\times\sigma^2_{`varUpper',t}+{}$} " $eolString _n;

file write `hh' "\multicolumn{8}{c}{$ {}+ \beta_4\times \textrm{output gap}_t+\beta_5\times\Delta\textrm{policy rate}_t^2+u_t $} " $eolString _n;
file write `hh' "\midrule" _n;


sca ptest = 2*(1-normal(abs(`var'Reg1MPpointConst)/`var'Reg4seConst));
do MakeTestStringJ;
file write `hh' " 8. & " %5.3f (`var'Reg1MPpointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg1MPpointConstCred)/`var'Reg1MPseConstCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg1MPpointConstCred) (teststr)  " & & & & & " %5.3f (`var'Reg1MPrbar) $eolString;
file write `hh' "  & (" %5.3f (`var'Reg4seConst) ") & (" %5.3f (`var'Reg1MPseConstCred) ") & & & & & " $eolString _n;

file write `hh' " 9. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg1BMPpointConst)/`var'Reg1BMPseConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg1BMPpointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg1BMPpointConstCred)/`var'Reg1BMPseConstCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg1BMPpointConstCred) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg1BMPpoint`var')/`var'Reg1BMPse`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg1BMPpoint`var') (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg1BMPpointd`var'Sq)/`var'Reg1BMPsed`var'Sq));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg1BMPpointd`var'Sq) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg1BMPpointGDP)/`var'Reg1BMPseGDP));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg1BMPpointGDP) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg1BMPpointRate)/`var'Reg1BMPseRate));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg1BMPpointRate) (teststr)  " &  " %5.3f (`var'Reg1BMPrbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg1BMPseConst) " )  & (" %5.3f (`var'Reg1BMPseConstCred) ") & (" %5.3f (`var'Reg1BMPse`var') ") & ( " %5.3f (`var'Reg1BMPsed`var'Sq)  " ) & ("  %5.3f (`var'Reg1BMPseGDP)  " )& ( " %5.3f (`var'Reg1BMPseRate) " )   &   " $eolString _n;

* The end;
*****************************************************************************;

file write `hh' " \bottomrule" _n "\multicolumn{8}{p{11.5cm}}{" _n "\showEstTime{Estimated: $S_DATE, $S_TIME \newline}" _n;

file write `hh' " {\scriptsize Notes: Fixed effects estimators, HAC standard errors, Bartlett kernel, bandwidth " _char(36) "{}=" %2.0f (`robustLags') _char(36) " lags. The dependent variable is measured as cross-sectional `disagrVar'. $\beta_0$ denotes the average of country-specific intercepts. " _char(96) _char(96) _char(36) "\textrm{post-1998}_{t}" _char(36) _char(39) _char(39) " denotes a dummy variable which equals 0 before 1999 and 1 after 1998. " _char(96) _char(96) _char(36) "\textrm{recession}_t" _char(36) _char(39) _char(39) " denotes a dummy variable which equals 1 during recession set by the Economic Cycle Research Institute (ECRI) and 0 otherwise. " _char(96) _char(96) _char(36) "\textrm{output gap}_{t}" _char(36) _char(39) _char(39) " denotes the ex-post output gap estimated in the OECD Economic Outlook quarterly output gap revisions database (in August 2008). " _char(36) "\sigma^2_{`varUpper',t}" _char(36) " denotes `uncertaintyLabel'. " _char(96) _char(96) _char(36) "\textrm{CB Independence}_{t}" _char(36) _char(39) _char(39) " denotes a $0$--$1$ indicator of independent monetary policy defined in table \ref{tMPsetting}. }" _n "}" _n;


file write `hh' "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\end{table} " _n;
file close `hh';

