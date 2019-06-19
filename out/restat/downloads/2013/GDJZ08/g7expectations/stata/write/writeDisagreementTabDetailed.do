#delimit;
tempname hh;
file open `hh' using "$docPath/driversOfDisagreement/tDisagrDetailed$variable$country$disagrVar.tex", write replace;
file write `hh' _n;

local C "$country"; local cntryUpper=upper("`C'");
local var "$variable"; local varUpper=upper("`var'");
local disagrVar "$disagrVar";

local uncertaintyLabel "Delta Squared";
if "$uncertaintyMeasure"=="2" {; local uncertaintyLabel "variance of the permanent component of `varUpper'"; };
if "$uncertaintyMeasure"=="3" {; local uncertaintyLabel "variance of the permanent ${}+{}2\times$ variance of transitory component of `varUpper'"; };

file write `hh' "\begin{sidewaystable}\footnotesize" _n;
file write `hh' "\caption{ Disagreement and Business Cycle---Detailed Results, `varUpper', `cntryUpper', `disagrVar' \label{tDisagrDetailed`var'`C'`disagrVar'}}" _n;
file write `hh' "\begin{center} " _n "\begin{tabular}{@{}cd{4}d{4}d{4}d{4}d{4}d{4}d{4}d{4}d{4}d{4}d{4}d{4}@{}} "
_n "\toprule " _n;
file write `hh' " Model & \multicolumn{1}{c}{$\beta_0$} & \multicolumn{1}{c}{$\beta_1$} & \multicolumn{1}{c}{$\beta_2$} &  \multicolumn{1}{c}{$\beta_3$} &  \multicolumn{1}{c}{$\beta_4$}&&&&&&& \multicolumn{1}{c}{$\bar{R}^2$}  " $eolString _n;

* Panel A;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{13}{c}{Panel A: $ \textrm{disagreement}_t=\beta_0+\beta_1\times \textrm{recession}_t+\beta_2\times t+\beta_3\times\textrm{post-1999}_{t}+\beta_4\times\textrm{disagreement}_{t-1}+u_t$} " $eolString _n;
file write `hh' "\midrule" _n;

sca ptest = 2*(1-norm(abs(`var'Reg1pointConst`C')/`var'Reg1seConst`C'));
do MakeTestStringJ;
file write `hh' " 1. & " %5.3f (`var'Reg1pointConst`C') (teststr);
file write `hh' " & & & & & & & & & & & " %5.3f (`var'Reg1rbar`C') $eolString ;
file write `hh' "  & (" %5.3f (`var'Reg1seConst`C') ") & & & & & & & & & & &" $eolString _n;

file write `hh' " 2. &  ";
sca ptest = 2*(1-norm(abs(`var'Reg2pointConst`C')/`var'Reg2seConst`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg2pointConst`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg2pointRecession`C')/`var'Reg2seRecession`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg2pointRecession`C') (teststr)  " & & & & & & & & & & " %5.3f (`var'Reg2rbar`C') $eolString ;;

file write `hh' "  & (" %5.3f (`var'Reg2seConst`C') ") & (" %5.3f (`var'Reg2seRecession`C') ") & & & & & & & & & & " $eolString _n;

file write `hh' " 3. &  ";
sca ptest = 2*(1-norm(abs(`var'Reg3pointConst`C')/`var'Reg3seConst`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3pointConst`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg3pointRecession`C')/`var'Reg3seRecession`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3pointRecession`C') (teststr)  " & ";

sca ptest = 2*(1-norm(abs(`var'Reg3pointTime`C')/`var'Reg3seTime`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3pointTime`C') (teststr)  " &  & & & & & & & & " %5.3f (`var'Reg3rbar`C') $eolString;

file write `hh' "  & (" %5.3f (`var'Reg3seConst`C') ") & (" %5.3f (`var'Reg3seRecession`C') ") & ( " %5.3f (`var'Reg3seTime`C')  " )& & & & & & & & & " $eolString _n;

file write `hh' " 4. &  ";
sca ptest = 2*(1-norm(abs(`var'Reg3ApointConst`C')/`var'Reg3AseConst`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3ApointConst`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg3ApointRecession`C')/`var'Reg3AseRecession`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3ApointRecession`C') (teststr)  " & & ";

sca ptest = 2*(1-norm(abs(`var'Reg3Apoint2ndHalf`C')/`var'Reg3Ase2ndHalf`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3Apoint2ndHalf`C') (teststr)  " & & & & & & & & " %5.3f (`var'Reg3Arbar`C') $eolString;

file write `hh' "  & (" %5.3f (`var'Reg3AseConst`C') ") & (" %5.3f (`var'Reg3AseRecession`C') ") & & ( " %5.3f (`var'Reg3Ase2ndHalf`C')  " ) & & & & & & & & " $eolString _n;

file write `hh' " 5. &  ";
sca ptest = 2*(1-norm(abs(`var'Reg3BpointConst`C')/`var'Reg3BseConst`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3BpointConst`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg3BpointRecession`C')/`var'Reg3BseRecession`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3BpointRecession`C') (teststr)  " & & &";

*sca ptest = 2*(1-norm(abs(`var'Reg3BpointTime`C')/`var'Reg3BseTime`C'));
*do MakeTestStringJ;
*file write `hh' %5.3f (`var'Reg3BpointTime`C') (teststr)  " & ";

sca ptest = 2*(1-norm(abs(`var'Reg3BpointPastDisagr`C')/`var'Reg3BsePastDisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg3BpointPastDisagr`C') (teststr)  " & & & & & & & " %5.3f (`var'Reg3Brbar`C') $eolString;

*file write `hh' "  & (" %5.3f (`var'Reg3BseConst`C') ") & (" %5.3f (`var'Reg3BseRecession`C') ") & ( " %5.3f (`var'Reg3BseTime`C')  " )& ( " %5.3f (`var'Reg3BsePastDisagr`C')  " )& & & & & & & &" $eolString _n;

file write `hh' "  & (" %5.3f (`var'Reg3BseConst`C') ") & (" %5.3f (`var'Reg3BseRecession`C') ") & & &( " %5.3f (`var'Reg3BsePastDisagr`C')  " ) & & & & & & &" $eolString _n;

* Panel B;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{13}{c}{Panel B: $ \textrm{disagreement}_t=\beta_0+\beta_1\times `varUpper'_t+\beta_2\times\sigma^2_{`varUpper',t}+\beta_3\times \textrm{output gap}_t+\beta_4\times\Delta\textrm{policy rate}_t^2+u_t$} " $eolString _n;
file write `hh' "\midrule" _n;

sca ptest = 2*(1-norm(abs(`var'Reg4pointConst`C')/`var'Reg4seConst`C'));
do MakeTestStringJ;
file write `hh' " 6. & " %5.3f (`var'Reg4pointConst`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg4point`var'`C')/`var'Reg4se`var'`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg4point`var'`C') (teststr)  " & & & & & & & & & & " %5.3f (`var'Reg4rbar`C') $eolString;

file write `hh' "  & (" %5.3f (`var'Reg4seConst`C') ") & (" %5.3f (`var'Reg4se`var'`C') ") & & & & & & & & & & " $eolString _n;

file write `hh' " 7. &  ";
sca ptest = 2*(1-norm(abs(`var'Reg5pointConst`C')/`var'Reg5seConst`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5pointConst`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg5point`var'`C')/`var'Reg5se`var'`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5point`var'`C') (teststr)  " & ";

sca ptest = 2*(1-norm(abs(`var'Reg5pointd`var'Sq`C')/`var'Reg5sed`var'Sq`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg5pointd`var'Sq`C') (teststr)  " & & & & & & & & & " %5.3f (`var'Reg5rbar`C') $eolString;

file write `hh' "  & (" %5.3f (`var'Reg5seConst`C') ") & (" %5.3f (`var'Reg5se`var'`C') ") & ( " %5.3f (`var'Reg5sed`var'Sq`C')  " ) & & & & & & & & & " $eolString _n;

file write `hh' " 8. &  ";
sca ptest = 2*(1-norm(abs(`var'Reg6_0pointConst`C')/`var'Reg6_0seConst`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6_0pointConst`C') (teststr) " & & & ";

sca ptest = 2*(1-norm(abs(`var'Reg6_0pointGDP`C')/`var'Reg6_0seGDP`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6_0pointGDP`C') (teststr)  " & & & & & & & & " %5.3f (`var'Reg6_0rbar`C') $eolString;

file write `hh' "  & (" %5.3f (`var'Reg6_0seConst`C') ") & & & ( " %5.3f (`var'Reg6_0seGDP`C') " )  & & & & & & & & " $eolString _n;

file write `hh' " 9. &  ";
sca ptest = 2*(1-norm(abs(`var'Reg6pointConst`C')/`var'Reg6seConst`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6pointConst`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg6point`var'`C')/`var'Reg6se`var'`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6point`var'`C') (teststr)  " & ";

sca ptest = 2*(1-norm(abs(`var'Reg6pointd`var'Sq`C')/`var'Reg6sed`var'Sq`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6pointd`var'Sq`C') (teststr)  " & ";

sca ptest = 2*(1-norm(abs(`var'Reg6pointGDP`C')/`var'Reg6seGDP`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6pointGDP`C') (teststr)  " & & & & & & & & " %5.3f (`var'Reg6rbar`C') $eolString;

file write `hh' "  & (" %5.3f (`var'Reg6seConst`C') ") & (" %5.3f (`var'Reg6se`var'`C') ") & ( " %5.3f (`var'Reg6sed`var'Sq`C')  " ) & ( " %5.3f (`var'Reg6seGDP`C') " )  & & & & & & & & " $eolString _n;

file write `hh' " 10. &  ";
sca ptest = 2*(1-norm(abs(`var'Reg6A_0pointConst`C')/`var'Reg6A_0seConst`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6A_0pointConst`C') (teststr) " & & & &";

sca ptest = 2*(1-norm(abs(`var'Reg6A_0pointRate`C')/`var'Reg6A_0seRate`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6A_0pointRate`C') (teststr)  " & & & & & & & " %5.3f (`var'Reg6A_0rbar`C') $eolString;

file write `hh' "  & (" %5.3f (`var'Reg6AseConst`C') ") & & & & ( " %5.3f (`var'Reg6AseRate`C') " )   & & & & & & & " $eolString _n;


file write `hh' " 11. &  ";
sca ptest = 2*(1-norm(abs(`var'Reg6ApointConst`C')/`var'Reg6AseConst`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6ApointConst`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg6Apoint`var'`C')/`var'Reg6Ase`var'`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6Apoint`var'`C') (teststr)  " & ";

sca ptest = 2*(1-norm(abs(`var'Reg6Apointd`var'Sq`C')/`var'Reg6Ased`var'Sq`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6Apointd`var'Sq`C') (teststr)  " & &";

sca ptest = 2*(1-norm(abs(`var'Reg6ApointRate`C')/`var'Reg6AseRate`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg6ApointRate`C') (teststr)  " & & & & & & & " %5.3f (`var'Reg6Arbar`C') $eolString;

file write `hh' "  & (" %5.3f (`var'Reg6AseConst`C') ") & (" %5.3f (`var'Reg6Ase`var'`C') ") & ( " %5.3f (`var'Reg6Ased`var'Sq`C')  " ) & & ( " %5.3f (`var'Reg6AseRate`C') " )   & & & & & & & " $eolString _n;


file write `hh' " 12. &  ";
sca ptest = 2*(1-norm(abs(`var'Reg7pointConst`C')/`var'Reg7seConst`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7pointConst`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg7point`var'`C')/`var'Reg7se`var'`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7point`var'`C') (teststr)  " & ";

sca ptest = 2*(1-norm(abs(`var'Reg7pointd`var'Sq`C')/`var'Reg7sed`var'Sq`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7pointd`var'Sq`C') (teststr)  " & ";

sca ptest = 2*(1-norm(abs(`var'Reg7pointGDP`C')/`var'Reg7seGDP`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7pointGDP`C') (teststr)  " & ";

sca ptest = 2*(1-norm(abs(`var'Reg7pointRate`C')/`var'Reg7seRate`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7pointRate`C') (teststr)  " & & & & & & & " %5.3f (`var'Reg7rbar`C') $eolString;

file write `hh' "  & (" %5.3f (`var'Reg7seConst`C') ") & (" %5.3f (`var'Reg7se`var'`C') ") & ( " %5.3f (`var'Reg7sed`var'Sq`C')  " ) & ("  %5.3f (`var'Reg7seGDP`C')  " )& ( " %5.3f (`var'Reg7seRate`C') " )   & & & & & & & " $eolString _n;

* Panel C;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{13}{c}{Panel C: $\displaystyle \textrm{disagreement}_{i,t}=\beta_0+\beta_1\times  \textrm{recession}_{i,t}+\sum_{\textrm{countries}}\gamma_j\times \textrm{disagreement}_{j,t}+u_{i,t}$} " $eolString _n;

file write `hh' " & \multicolumn{1}{c}{$\beta_0$} & \multicolumn{1}{c}{$\beta_1$} & \multicolumn{1}{c}{$\beta_2$} &  \multicolumn{1}{c}{$\beta_3$} & \multicolumn{1}{c}{$\gamma_{CN}$} & \multicolumn{1}{c}{$\gamma_{FR}$}  & \multicolumn{1}{c}{$\gamma_{GE}$}  & \multicolumn{1}{c}{$\gamma_{IT}$}  & \multicolumn{1}{c}{$\gamma_{JP}$}  & \multicolumn{1}{c}{$\gamma_{UK}$}  & \multicolumn{1}{c}{$\gamma_{US}$}  & \multicolumn{1}{c}{$\bar{R}^2$} " $eolString _n;

file write `hh' "\midrule" _n;


sca ptest = 2*(1-norm(abs(`var'Reg7BpointConst`C')/`var'Reg7BseConst`C'));
do MakeTestStringJ;
file write `hh' " 13. & " %5.3f (`var'Reg7BpointConst`C') (teststr) " & & & & ";

sca ptest = 2*(1-norm(abs(`var'Reg7Bpointcn`var'disagr`C')/`var'Reg7Bsecn`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7Bpointcn`var'disagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg7Bpointfr`var'disagr`C')/`var'Reg7Bsefr`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7Bpointfr`var'disagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg7Bpointge`var'disagr`C')/`var'Reg7Bsege`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7Bpointge`var'disagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg7Bpointit`var'disagr`C')/`var'Reg7Bseit`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7Bpointit`var'disagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg7Bpointjp`var'disagr`C')/`var'Reg7Bsejp`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7Bpointjp`var'disagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg7Bpointuk`var'disagr`C')/`var'Reg7Bseuk`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7Bpointuk`var'disagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg7Bpointus`var'disagr`C')/`var'Reg7Bseus`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg7Bpointus`var'disagr`C') (teststr) " & "  %5.3f (`var'Reg7Brbar`C') $eolString;


file write `hh' "  & (" %5.3f (`var'Reg7BseConst`C') ") & & & & ( " %5.3f (`var'Reg7Bsecn`var'disagr`C')  " ) & ( " %5.3f (`var'Reg7Bsefr`var'disagr`C') " ) & ( " %5.3f (`var'Reg7Bsege`var'disagr`C') " ) & ( " %5.3f (`var'Reg7Bseit`var'disagr`C') " ) & ( " %5.3f (`var'Reg7Bsejp`var'disagr`C') " ) & ( " %5.3f (`var'Reg7Bseuk`var'disagr`C') " ) & ( " %5.3f (`var'Reg7Bseus`var'disagr`C') " ) & " $eolString _n;

**************************************************************************************;
sca ptest = 2*(1-norm(abs(`var'Reg8pointConst`C')/`var'Reg8seConst`C'));
do MakeTestStringJ;
file write `hh' " 14. & " %5.3f (`var'Reg8pointConst`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg8pointRecession`C')/`var'Reg8seRecession`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg8pointRecession`C') (teststr) " & & & ";

sca ptest = 2*(1-norm(abs(`var'Reg8pointcn`var'disagr`C')/`var'Reg8secn`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg8pointcn`var'disagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg8pointfr`var'disagr`C')/`var'Reg8sefr`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg8pointfr`var'disagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg8pointge`var'disagr`C')/`var'Reg8sege`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg8pointge`var'disagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg8pointit`var'disagr`C')/`var'Reg8seit`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg8pointit`var'disagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg8pointjp`var'disagr`C')/`var'Reg8sejp`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg8pointjp`var'disagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg8pointuk`var'disagr`C')/`var'Reg8seuk`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg8pointuk`var'disagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg8pointus`var'disagr`C')/`var'Reg8seus`var'disagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg8pointus`var'disagr`C') (teststr) " & " %5.3f (`var'Reg8rbar`C') $eolString; 

file write `hh' "  & (" %5.3f (`var'Reg8seConst`C') ") & (" %5.3f (`var'Reg8seRecession`C') ") & & & ( " %5.3f (`var'Reg8secn`var'disagr`C')  " ) & ( " %5.3f (`var'Reg8sefr`var'disagr`C') " ) & ( " %5.3f (`var'Reg8sege`var'disagr`C') " ) & ( " %5.3f (`var'Reg8seit`var'disagr`C') " ) & ( " %5.3f (`var'Reg8sejp`var'disagr`C') " ) & ( " %5.3f (`var'Reg8seuk`var'disagr`C') " ) & ( " %5.3f (`var'Reg8seus`var'disagr`C') " ) & " $eolString _n;


* Panel D;
*****************************************************************************;
file write `hh' "\midrule" _n;
file write `hh' "\multicolumn{13}{c}{Panel D: $\displaystyle \textrm{disagreement}_{i,t}=\beta_0+\beta_1\times \textrm{recession}_{i,t}+\sum_{\textrm{variables}}\delta_k\times \textrm{disagreement}_{k,t}+u_{i,t}$} " $eolString _n;

file write `hh' " & \multicolumn{1}{c}{$\beta_0$} & \multicolumn{1}{c}{$\beta_1$} & \multicolumn{1}{c}{$\beta_2$} &  \multicolumn{1}{c}{$\beta_3$} & \multicolumn{1}{c}{$\delta_{INFL}$} & \multicolumn{1}{c}{$\delta_{GDP}$}  & \multicolumn{1}{c}{$\delta_{IP}$}  & \multicolumn{1}{c}{$\delta_{INV}$}  & \multicolumn{1}{c}{$\delta_{CONS}$}  & \multicolumn{1}{c}{$\delta_{UN}$}  & \multicolumn{1}{c}{$\delta_{R3M}$}  & \multicolumn{1}{c}{$\bar{R}^2$} " $eolString _n;

file write `hh' "\midrule" _n;

sca ptest = 2*(1-norm(abs(`var'Reg9pointConst`C')/`var'Reg9seConst`C'));
do MakeTestStringJ;
file write `hh' " 15. & " %5.3f (`var'Reg9pointConst`C') (teststr) " & & & & ";

sca ptest = 2*(1-norm(abs(`var'Reg9point`C'infldisagr`C')/`var'Reg9se`C'infldisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9point`C'infldisagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg9point`C'gdpdisagr`C')/`var'Reg9se`C'gdpdisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9point`C'gdpdisagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg9point`C'ipdisagr`C')/`var'Reg9se`C'ipdisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9point`C'ipdisagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg9point`C'invdisagr`C')/`var'Reg9se`C'invdisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9point`C'invdisagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg9point`C'consdisagr`C')/`var'Reg9se`C'consdisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9point`C'consdisagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg9point`C'undisagr`C')/`var'Reg9se`C'undisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9point`C'undisagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg9point`C'r3mdisagr`C')/`var'Reg9se`C'r3mdisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg9point`C'r3mdisagr`C') (teststr) " & " %5.3f (`var'Reg9rbar`C') $eolString; 

file write `hh' "  & (" %5.3f (`var'Reg9seConst`C') ") & & & & ( " %5.3f (`var'Reg9se`C'infldisagr`C')  " ) & ( " %5.3f (`var'Reg9se`C'gdpdisagr`C') " ) & ( " %5.3f (`var'Reg9se`C'ipdisagr`C') " ) & ( " %5.3f (`var'Reg9se`C'invdisagr`C') " ) & ( " %5.3f (`var'Reg9se`C'consdisagr`C') " ) & ( " %5.3f (`var'Reg9se`C'undisagr`C') " ) & ( " %5.3f (`var'Reg9se`C'r3mdisagr`C') " ) & " $eolString _n;

**************************************************************************************;

sca ptest = 2*(1-norm(abs(`var'Reg10pointConst`C')/`var'Reg10seConst`C'));
do MakeTestStringJ;
file write `hh' " 16. & " %5.3f (`var'Reg10pointConst`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg10pointRecession`C')/`var'Reg10seRecession`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10pointRecession`C') (teststr) " & & & ";

sca ptest = 2*(1-norm(abs(`var'Reg10point`C'infldisagr`C')/`var'Reg10se`C'infldisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10point`C'infldisagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg10point`C'gdpdisagr`C')/`var'Reg10se`C'gdpdisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10point`C'gdpdisagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg10point`C'ipdisagr`C')/`var'Reg10se`C'ipdisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10point`C'ipdisagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg10point`C'invdisagr`C')/`var'Reg10se`C'invdisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10point`C'invdisagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg10point`C'consdisagr`C')/`var'Reg10se`C'consdisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10point`C'consdisagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg10point`C'undisagr`C')/`var'Reg10se`C'undisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10point`C'undisagr`C') (teststr) " & ";

sca ptest = 2*(1-norm(abs(`var'Reg10point`C'r3mdisagr`C')/`var'Reg10se`C'r3mdisagr`C'));
do MakeTestStringJ;
file write `hh' %5.3f (`var'Reg10point`C'r3mdisagr`C') (teststr) " & " %5.3f (`var'Reg10rbar`C') $eolString; 
file write `hh' "  & (" %5.3f (`var'Reg10seConst`C') ") & (" %5.3f (`var'Reg10seRecession`C') ") & & & ( " %5.3f (`var'Reg10se`C'infldisagr`C')  " ) & ( " %5.3f (`var'Reg10se`C'gdpdisagr`C') " ) & ( " %5.3f (`var'Reg10se`C'ipdisagr`C') " ) & ( " %5.3f (`var'Reg10se`C'invdisagr`C') " ) & ( " %5.3f (`var'Reg10se`C'consdisagr`C') " ) & ( " %5.3f (`var'Reg10se`C'undisagr`C') " ) & ( " %5.3f (`var'Reg10se`C'r3mdisagr`C') " ) & " $eolString _n;


* The end;
*****************************************************************************;

file write `hh' " \bottomrule" _n "\end{tabular}" _n;
file write `hh' "\end{center}" _n;

file write `hh' "\showEstTime{Estimated: $S_DATE, $S_TIME}" $eolString _n;

file write `hh' " {\scriptsize Notes:  " _char(96) _char(96) _char(36) "\textrm{post-1998}_{t}" _char(36) _char(39) _char(39) " denotes a dummy variable which equals 0 before 1999 and 1 after 1998. " _char(96) _char(96) _char(36) "\textrm{recession}_t" _char(36)_char(39) _char(39) " denotes a dummy variable which equals 1 during recession set by the Economic Cycle Research Institute (ECRI) and 0 otherwise. " _char(96) _char(96) _char(36) "\textrm{output gap}_{t}" _char(36) _char(39) _char(39) " denotes the ex-post output gap estimated in the OECD quarterly output gap revisions database (in August 2008). "  _char(36) "\sigma^2_{`varUpper',t}" _char(36) " denotes `uncertaintyLabel'. } " _n;
file write `hh' "\end{sidewaystable} " _n;
file close `hh';

