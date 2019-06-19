clear
use "$data\final.dta"

*****************************************
*Table 2: Baseline Regressions, no cycle
*****************************************
xtivreg2 log_Invzuweis_pc direct_elect time*, fe r cluster(code)
est store inv1
estadd local time "YES", replace
estadd local countytr "NO", replace
estadd local mayor "YES", replace
estadd local controls "NO", replace

xtivreg2 log_Invzuweis_pc direct_elect time* trend_*, fe r cluster(code)
est store inv2
estadd local time "YES", replace
estadd local countytr "YES", replace
estadd local mayor "YES", replace
estadd local controls "NO", replace

xtivreg2 log_Invzuweis_pc direct_elect time* trend_* bis14jahre_sh ueber65_sh log_Schluess_pc logpop businesstax proptax, fe r cluster(code)
est store inv3
estadd local time "YES", replace
estadd local countytr "YES", replace
estadd local mayor "YES", replace
estadd local controls "YES", replace

 estout inv1 inv2 inv3 using "$data\table2.tex", ///   
style(tex) keep(direct_elect) mlabels("(I)" "(II)" "(III)") order(direct_elect)  replace title("Effect of the electoral rule for the mayor on investment transfers from the state-tier") ///
 prehead(\begin{table}[htbp] \scriptsize \hspace{\fill} \resizebox{0.57\textwidth}{!}{\begin{threeparttable}\caption{{\sc @title \label{tab:baseline1}}}\centering\medskip ///
 \begin{tabularx}{0.6\textwidth}{P*{@M}{C}} \toprule)  posthead("" ) prefoot("\midrule") ///
 varlabels(direct_elect "Elected mayor" bis14jahre_sh "Share of population < 15 years" ueber65_sh "Share of population > 65 years" businesstax "Business tax rate multiplier" log_Schluess_pc "Log of rule-based transfers per capita" proptax "Property tax B rate multiplier" logpop "log of population size")  /// 
 stats(time mayor countytr controls N N_g r2 , layout(@ @ @ @ @ @ )  fmt(%~#s %~#s %~#s %~#s %6.0f %6.0f %6.3f ) ///
 labels("Year fixed effects" "Municipality fixed effects" "County-specific time trends" "Control variables" "Observations" "Municipalities" "R-squared" )) /// 
  starlevels(* 0.10 ** 0.05 *** 0.01) ///
 cells(b(star fmt(%8.3f) ) se(par fmt(%6.3f))     ) ///
 postfoot(\bottomrule\end{tabularx}\begin{tablenotes} \scriptsize{Notes: The dependent variable is the log of investment transfers per capita. Standard errors are robust to heteroscedasticity and clustered at the municipality-level (reported in parentheses). Control variables include share of population over 65 years, share of population below 15 years, log of population size, log of rule-based transfers per capita, and business and property tax rate multipliers. Stars indicate significance levels at 10\% (*), 5\% (**) and 1\%(***).}\end{tablenotes} \end{threeparttable}} \hspace*{\fill}\end{table}) notype


**************************************
*Table 3: Baseline Regressions, cycle
**************************************
xtivreg2 log_Invzuweis_pc direct_elect bmwahl electyr time*, fe r cluster(code)
est store inv1
estadd local time "YES", replace
estadd local countytr "NO", replace
estadd local mayor "YES", replace
estadd local controls "NO", replace

xtivreg2 log_Invzuweis_pc direct_elect bmwahl electyr time* trend_*, fe r cluster(code)
est store inv2
estadd local time "YES", replace
estadd local countytr "YES", replace
estadd local mayor "YES", replace
estadd local controls "NO", replace

xtivreg2 log_Invzuweis_pc direct_elect bmwahl electyr time* trend_* bis14jahre_sh ueber65_sh log_Schluess_pc logpop businesstax proptax, fe r cluster(code)
est store inv3
estadd local time "YES", replace
estadd local countytr "YES", replace
estadd local mayor "YES", replace
estadd local controls "YES", replace

estout inv1 inv2 inv3 using "$data\table3.tex", ///
rename(appointment councilwahl) ///
style(tex) keep(direct_elect bmwahl electyr ) mlabels("(I)" "(II)" "(III)") order(bmwahl direct_elect electyr ) replace title("Electoral cycles in investment transfers from the state-tier by electoral rules for mayors") ///
 prehead(\begin{table}[htbp] \scriptsize \hspace{\fill} \resizebox{0.65\textwidth}{!}{\begin{threeparttable}\caption{{\sc @title \label{tab:baseline2}}}\centering\medskip ///
 \begin{tabularx}{0.72\textwidth}{P*{@M}{C}} \toprule)  posthead("") prefoot("\midrule") ///
 varlabels(electyr "Election/appointment year" bmwahl "Elected mayor*Election/appointment year" direct_elect "Elected mayor" log_Schluess_pc "Log of rule-based transfers per capita" bis14jahre_sh "Share of population < 15 years" ueber65_sh "Share of population > 65 years" businesstax "Business tax rate multiplier" proptax "Property tax B rate multiplier" logpop "Log of population size")  /// ///
  stats(time mayor countytr controls N N_g r2 , layout(@ @ @ @ @ @ )  fmt(%~#s %~#s %~#s %~#s %6.0f %6.0f %6.3f ) ///
 labels("Year fixed effects" "Municipality fixed effects" "County-specific time trends" "Control variables" "Observations" "Municipalities" "R-squared" )) ///
  starlevels(* 0.10 ** 0.05 *** 0.01) ///
 cells(b(star fmt(%8.3f) ) se(par fmt(%6.3f))     ) ///
 postfoot(\bottomrule\end{tabularx}\begin{tablenotes} \scriptsize{Notes: The dependent variable is the log of investment transfers per capita. Standard errors are robust to heteroscedasticity and clustered at the municipality-level (reported in parentheses). Control variables include share of population over 65 years, share of population below 15 years, log of population size, log of rule-based transfers per capita, and business and property tax rate multipliers. Stars indicate significance levels at 10\% (*), 5\% (**) and 1\%(***).}\end{tablenotes} \end{threeparttable}} \hspace*{\fill}\end{table}) notype


******************************************
*Table 5: Subset of mayors in both systems
********************************************
xtivreg2 log_Invzuweis_pc direct_elect bmwahl electyr time* if ins == 1, fe r cluster(code)
est store inv1
estadd local time "YES", replace
estadd local countytr "NO", replace
estadd local mayor "YES", replace
estadd local controls "NO", replace

xtivreg2 log_Invzuweis_pc direct_elect bmwahl electyr time* trend_* if ins == 1, fe r cluster(code)
est store inv2
estadd local time "YES", replace
estadd local countytr "YES", replace
estadd local mayor "YES", replace
estadd local controls "NO", replace

xtivreg2 log_Invzuweis_pc direct_elect bmwahl electyr time* trend_* bis14jahre_sh ueber65_sh log_Schluess_pc logpop businesstax proptax if ins == 1, fe r cluster(code)
est store inv3
estadd local time "YES", replace
estadd local countytr "YES", replace
estadd local mayor "YES", replace
estadd local controls "YES", replace

estout inv1 inv2 inv3 using "$data\table5.tex", ///
style(tex) keep(direct_elect bmwahl electyr) mlabels("(I)" "(II)" "(III)") order(bmwahl direct_elect electyr) replace title("Effect of the electoral rule for the mayor on investment transfers from the state-tier, subset of mayors that were in office under both mayor selection schemes") ///
 prehead(\begin{table}[htbp] \scriptsize \hspace{\fill} \resizebox{0.65\textwidth}{!}{\begin{threeparttable}\caption{{\sc @title \label{tab:baseline2}}}\centering\medskip ///
 \begin{tabularx}{0.72\textwidth}{P*{@M}{C}} \toprule)  posthead("") prefoot("\midrule") ///
 varlabels(electyr "Election/appointment year" bmwahl "Elected mayor*Election/appointment year" direct_elect "Elected mayor" log_Schluess_pc "Log of rule-based transfers per capita" bis14jahre_sh "Share of population < 15 years" ueber65_sh "Share of population > 65 years" businesstax "Business tax rate multiplier" proptax "Property tax B rate multiplier" logpop "Log of population size")  ///
 stats(time mayor countytr controls N N_g r2 , layout(@ @ @ @ @ @ )  fmt(%~#s %~#s %~#s %~#s %6.0f %6.0f %6.3f ) ///
 labels("Year fixed effects" "Municipality fixed effects" "County-specific time trends" "Control variables" "Observations" "Municipalities" "R-squared" )) ///
  starlevels(* 0.10 ** 0.05 *** 0.01) ///
 cells(b(star fmt(%8.3f) ) se(par fmt(%6.3f))     ) ///
 postfoot(\bottomrule\end{tabularx}\begin{tablenotes} \scriptsize{Notes: The dependent variable is the log of investment transfers per capita. Standard errors are robust to heteroscedasticity and clustered at the municipality-level (reported in parentheses). Control variables include share of population over 65 years, share of population below 15 years, log of population size, log of rule-based transfers per capita, and business and property tax rate multipliers. Stars indicate significance levels at 10\% (*), 5\% (**) and 1\%(***).}\end{tablenotes} \end{threeparttable}} \hspace*{\fill}\end{table}) notype

exit
