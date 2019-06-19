#delimit;
tempname hh;
file open `hh' using "$docPath/driversOfDisagreement/tDisagrPanel$variable$disagrVar.tex", write replace;
file write `hh' _n;

local var "$variable"; local varUpper=upper("`var'");
local disagrVar "$disagrVar";
local robustLags "$robustLags";
local uncertaintyLabel "Delta `varUpper' Squared";
if "$uncertaintyMeasure"=="2" {; local uncertaintyLabel "variance of the permanent component of `varUpper'"; };
if "$uncertaintyMeasure"=="3" {; local uncertaintyLabel "variance of the permanent ${}+{}2\times$ variance of transitory component of `varUpper'"; };

file write `hh' "\begin{sidewaystable}\small" _n;
file write `hh' "\caption{ Disagreement and Business Cycle---Panel Results, `varUpper', `disagrVar' \label{tDisagrPanel`var'`disagrVar'}}" _n;
file write `hh' "\begin{center} " _n "\begin{tabular}{@{}cd{4}d{4}d{4}d{4}d{4}d{4}@{}} "
_n "\toprule " _n;
file write `hh' " Model & \multicolumn{1}{c}{$\beta_0$} & \multicolumn{1}{c}{$\beta_1$} & \multicolumn{1}{c}{$\beta_2$} &  \multicolumn{1}{c}{$\beta_3$} &  \multicolumn{1}{c}{$\beta_4$}& \multicolumn{1}{c}{$\bar{R}^2$}  " $eolString _n;

* Panel A;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{7}{c}{Panel A: $ \textrm{disagreement}_t=\beta_0+\beta_1\times \textrm{recession}_t+\beta_2\times t+\beta_3\times\textrm{post-1998}_{t}+\beta_4\times\textrm{disagreement}_{t-1}+u_t$} " $eolString _n;
file write `hh' "\midrule" _n;

sca ptest = 2*(1-normal(abs(`var'Reg1pointConst)/`var'Reg1seConst));
do MakeTestStringJ;
file write `hh' " 1. & " %5.3f (`var'Reg1pointConst) (teststr);
file write `hh' " & & & & &  " %5.3f (`var'Reg1rbar) $eolString ;
file write `hh' "  & (" %5.3f (`var'Reg1seConst) ") & & & & &  " $eolString _n;

file write `hh' " 2. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg2pointConst)/`var'Reg2seConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg2pointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg2pointRecession)/`var'Reg2seRecession));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg2pointRecession) (teststr)  " & & & &  " %5.3f (`var'Reg2rbar) $eolString ;;

file write `hh' "  & (" %5.3f (`var'Reg2seConst) ") & (" %5.3f (`var'Reg2seRecession) ") & & & &  " $eolString _n;

file write `hh' " 3. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg3pointConst)/`var'Reg3seConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3pointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg3pointRecession)/`var'Reg3seRecession));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3pointRecession) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg3pointTime)/`var'Reg3seTime));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3pointTime) (teststr)  " &  & &   " %5.3f (`var'Reg3rbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg3seConst) ") & (" %5.3f (`var'Reg3seRecession) ") & ( " %5.3f (`var'Reg3seTime)  " )& & &  " $eolString _n;

file write `hh' " 4. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg3ApointConst)/`var'Reg3AseConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3ApointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg3ApointRecession)/`var'Reg3AseRecession));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3ApointRecession) (teststr)  " & & ";

sca ptest = 2*(1-normal(abs(`var'Reg3Apoint2ndHalf)/`var'Reg3Ase2ndHalf));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3Apoint2ndHalf) (teststr)  " & &  " %5.3f (`var'Reg3Arbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg3AseConst) ") & (" %5.3f (`var'Reg3AseRecession) ") & & ( " %5.3f (`var'Reg3Ase2ndHalf)  " ) & &   " $eolString _n;

* Panel B;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{7}{c}{Panel B: $ \textrm{disagreement}_t=\beta_0+\beta_1\times `varUpper'_t+\beta_3\times\sigma^2_{`varUpper',t}+\beta_3\times \textrm{output gap}_t+\beta_4\times\Delta\textrm{policy rate}_t^2+u_t$} " $eolString _n;
file write `hh' "\midrule" _n;

sca ptest = 2*(1-normal(abs(`var'Reg4pointConst)/`var'Reg4seConst));
do MakeTestStringJ;
file write `hh' " 6. & " %5.3f (`var'Reg4pointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg4point`var')/`var'Reg4se`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg4point`var') (teststr)  " & & & &  " %5.3f (`var'Reg4rbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg4seConst) ") & (" %5.3f (`var'Reg4se`var') ") & & & & " $eolString _n;

file write `hh' " 7. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg5pointConst)/`var'Reg5seConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5pointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg5point`var')/`var'Reg5se`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5point`var') (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg5pointd`var'Sq)/`var'Reg5sed`var'Sq));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5pointd`var'Sq) (teststr)  " & & &   " %5.3f (`var'Reg5rbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg5seConst) ") & (" %5.3f (`var'Reg5se`var') ") & ( " %5.3f (`var'Reg5sed`var'Sq)  " ) & & &  " $eolString _n;

**************************;
file write `hh' " 8. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg6pointConst)/`var'Reg6seConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6pointConst) (teststr) " & & & ";

sca ptest = 2*(1-normal(abs(`var'Reg6pointGDP)/`var'Reg6seGDP));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6pointGDP) (teststr)  " & &  " %5.3f (`var'Reg6rbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg6seConst) ") & & & ( " %5.3f (`var'Reg7seGDP) " )  & &   " $eolString _n;

file write `hh' " 9. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg7pointConst)/`var'Reg7seConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7pointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg7point`var')/`var'Reg7se`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7point`var') (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg7pointd`var'Sq)/`var'Reg7sed`var'Sq));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7pointd`var'Sq) (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg7pointGDP)/`var'Reg7seGDP));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7pointGDP) (teststr)  " & &  " %5.3f (`var'Reg7rbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg7seConst) ") & (" %5.3f (`var'Reg7se`var') ") & ( " %5.3f (`var'Reg7sed`var'Sq)  " ) & ( " %5.3f (`var'Reg7seGDP) " )  & &   " $eolString _n;

file write `hh' " 10. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg8pointConst)/`var'Reg8seConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg8pointConst) (teststr) " & & & &";

sca ptest = 2*(1-normal(abs(`var'Reg8pointRate)/`var'Reg8seRate));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg8pointRate) (teststr)  " &  " %5.3f (`var'Reg8rbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg8seConst) ") & & & & ( " %5.3f (`var'Reg8seRate) " )   &   " $eolString _n;

file write `hh' " 11. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg9pointConst)/`var'Reg9seConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9pointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg9point`var')/`var'Reg9se`var'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9point`var') (teststr)  " & ";

sca ptest = 2*(1-normal(abs(`var'Reg9pointd`var'Sq)/`var'Reg9sed`var'Sq));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9pointd`var'Sq) (teststr)  " & &";

sca ptest = 2*(1-normal(abs(`var'Reg9pointRate)/`var'Reg9seRate));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9pointRate) (teststr)  " &  " %5.3f (`var'Reg9rbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg9seConst) ") & (" %5.3f (`var'Reg9se`var') ") & ( " %5.3f (`var'Reg9sed`var'Sq)  " ) & & ( " %5.3f (`var'Reg9seRate) " )   &   " $eolString _n;

file write `hh' " 12. &  ";
sca ptest = 2*(1-normal(abs(`var'Reg10pointConst)/`var'Reg10seConst));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10pointConst) (teststr) " & ";

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
file write `hh' %5.3f (`var'Reg10pointRate) (teststr)  " &  " %5.3f (`var'Reg10rbar) $eolString;

file write `hh' "  & (" %5.3f (`var'Reg10seConst) ") & (" %5.3f (`var'Reg10se`var') ") & ( " %5.3f (`var'Reg10sed`var'Sq)  " ) & ( " %5.3f (`var'Reg10seGDP) " ) & ( " %5.3f (`var'Reg10seRate) " )   &   " $eolString _n;

* Panel C;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{7}{c}{Panel C: Disagreement and Central Bank Independence} " $eolString _n;
file write `hh' "\multicolumn{7}{c}{$ \textrm{disagreement}_t=\beta_0+\beta_1\times \textrm{CB Independence}_t+ u_t$} " $eolString _n;
file write `hh' "\midrule" _n;

sca ptest = 2*(1-normal(abs(`var'Reg1MPpointConst)/`var'Reg4seConst));
do MakeTestStringJ;
file write `hh' " 13. & " %5.3f (`var'Reg1MPpointConst) (teststr) " & ";

sca ptest = 2*(1-normal(abs(`var'Reg1MPpointConstCred)/`var'Reg1MPseConstCred));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg1MPpointConstCred) (teststr)  " & & & &  " %5.3f (`var'Reg1MPrbar) $eolString;
file write `hh' "  & (" %5.3f (`var'Reg4seConst) ") & (" %5.3f (`var'Reg1MPseConstCred) ") & & & & " $eolString _n;


* The end;
*****************************************************************************;

file write `hh' " \bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}" $eolString _n;

file write `hh' " {\scriptsize Notes: Fixed effects estimators. $\beta_0$ denotes the average of country-specific intercepts." _char(96) _char(96) _char(36) "\textrm{post-1998}_{t}" _char(36) _char(39) _char(39) " denotes a dummy variable which equals 0 before 1999 and 1 after 1998. " _char(96) _char(96) _char(36) "\textrm{recession}_t" _char(36)_char(39) _char(39) " denotes a dummy variable which equals 1 during recession set by the Economic Cycle Research Institute (ECRI) and 0 otherwise. " _char(96) _char(96) _char(36) "\textrm{output gap}_{t}" _char(36) _char(39) _char(39) " denotes the ex-post output gap estimated in the OECD quarterly output gap revisions database (in August 2008). " _char(36) "\Delta_{12}`varUpper'^2_t\equiv(`varUpper'_t-`varUpper'_{t-12})^2" _char(36) ". " _char(36) "\sigma^2_{`varUpper',t}" _char(36) " denotes `uncertaintyLabel'. " _char(96) _char(96) _char(36) "\textrm{CB Independence}_{t}" _char(36) _char(39) _char(39) " denotes a $0-1$ indicator of independent central bank. } "_n;
file write `hh' "\end{sidewaystable} " _n;
file close `hh';

