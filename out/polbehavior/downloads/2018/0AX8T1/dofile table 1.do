*Name: Martin Vinæs Larsen*
*Date: June 2018*
*Article: "Is the Relationship between Political Responsibility and Electoral Accountability Causal, Adaptive and Policy-specific?"*
*Reproduces: Table 1. 
*Data: 05rep.dta (survey data from the 2005 Danish municipal election survey), macrorep.dta (municipal level data from Statistics Denmark)*
*Version 15.1*

*loading 2005 municipal election survey data
use "05rep", clear

*drawing individual lvl part of the table
file open anyname using "table1.txt", write text replace 
file write anyname  _newline  _col(0)  "\begin{table} [htbp] \centering \caption{Were treatment and control municipalities different?}  \footnotesize  \label{balancetab} \begin{tabular}{l*{5}{c}}\hline\hline"
file write anyname _newline _col(0) "Variable&Treatment & Control & Std. dif.&p-value & n\\ \hline"
file write anyname _newline _col(0) "\textit{Individual-level variables (2005)} &&&&&\\"
foreach x of varlist informed interest unemp_perf attknow elderly housing ideol dontcare obligated demosat pivotal {
ttest `x', by(treat) unequal
file write anyname  _newline  _col(0) (`"`: var label `x''"') "&" _col(25) %9.2f  (r(mu_2)) " &" _col(45) %9.2f  (r(mu_1)) " &" _col(65) %9.2f  ((r(mu_2)-r(mu_1))/r(sd_1)) " &"   _col(85) %9.2f  (r(p)) " &" _col(105) %9.0f  (r(N_1)+r(N_2)) " \\"
}
*Loading 2005 municipal lvl data
use "macrorep", clear
*drawing minicipal lvl part of the table
file write anyname _newline _col(0) ""
file write anyname _newline _col(0) "\textit{Municipality-level variables (2006)} &&&&&\\"
foreach x of varlist logtaet udd ledige logindv kvindpol skat logoverfoer konkud logaktivering logindb service industry govsupport govmayor {
ttest `x', by(treat) unequal
file write anyname  _newline  _col(0) (`"`: var label `x''"') "&" _col(25) %9.2f  (r(mu_2)) " &" _col(45) %9.2f  (r(mu_1)) " &" _col(65) %9.2f  ((r(mu_2)-r(mu_1))/r(sd_1)) " &"   _col(85) %9.2f  (r(p)) " &" _col(105) %9.0f  (r(N_1)+r(N_2)) " \\"
di ((r(mu_2)-r(mu_1))/r(sd_1))
}
file write anyname _newline _col(0) "\hline\hline"
file write anyname _newline _col(0) "\multicolumn{6}{p{140mm}}{Individual-level variables from the 2005 municipal election survey,  see section S2 of the supplementary materials. Municipal-level variables taken from Statistics Denmark. p-values from difference in means test. National government voters is the proportion of voters who voted for parties in government at the municipal election in 2005. Standardized difference computed as difference in means divided by standard deviation in the control group. Heavily skewed variables presented on a logarithmic scale.}"
file write anyname _newline _col(0) "\end{tabular}"
file write anyname _newline _col(0) "\end{table}"
file close anyname


