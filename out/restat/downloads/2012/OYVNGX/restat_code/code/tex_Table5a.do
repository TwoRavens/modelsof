clear
set more off

use "results\T5a"

* Generates t statistics
gen t1=.
replace t1=T5a1[1]/T5a1[2] in 1
replace t1=T5a1[3]/T5a1[4] in 3
replace t1=T5a1[5]/T5a1[6] in 5
gen t2=.
replace t2=T5a2[1]/T5a2[2] in 1
replace t2=T5a2[3]/T5a2[4] in 3
replace t2=T5a2[5]/T5a2[6] in 5
gen t3=.
replace t3=T5a3[1]/T5a3[2] in 1
replace t3=T5a3[3]/T5a3[4] in 3
replace t3=T5a3[5]/T5a3[6] in 5
gen t4=.
replace t4=T5a4[1]/T5a4[2] in 1
replace t4=T5a4[3]/T5a4[4] in 3
replace t4=T5a4[5]/T5a4[6] in 5
gen t5=.
replace t5=T5a5[1]/T5a5[2] in 1
replace t5=T5a5[3]/T5a5[4] in 3
replace t5=T5a5[5]/T5a5[6] in 5
gen t6=.
replace t6=T5a6[1]/T5a6[2] in 1
replace t6=T5a6[3]/T5a6[4] in 3
replace t6=T5a6[5]/T5a6[6] in 5

* Generates the "starts"
foreach j of numlist 1/6 {
	gen str7 stars`j'=""
	replace stars`j'="^*" if abs(t`j')>=1.64 & abs(t`j')<1.96
	replace stars`j'="^{**}" if abs(t`j')>=1.96 & abs(t`j')<2.47
	replace stars`j'="^{***}" if abs(t`j')>=2.47
	}



qui { 
set linesize 200
capture log close
log using "results\Table5.tex", text replace



no di "\begin{table}[t]"
no di "\refstepcounter{table}\label{tab_income}"
no di "\par"
no di "\begin{center}"
no di "{\small"
no di "\begin{tabular}{lccp{0.1cm}ccp{0.1cm}cc}"
no di "\multicolumn{9}{c}{Table 5} \\"
no di "\multicolumn{9}{c}{Average Impact of Anti-Dumping on Income} \\"
no di "\multicolumn{9}{c}{Mekong Provinces} \\"
no di "\multicolumn{9}{c}{All Farms} \\"
no di "&  &  &  &  &  &  &  &  \\ \hline\hline"
no di "\rule{0cm}{0.5cm} & \multicolumn{2}{c}{Total Income} &  & \multicolumn{2}{c}{"
no di "Per Capita Income} &  & \multicolumn{2}{c}{Net Income} \\"
no di "\cline{2-3}\cline{5-6}\cline{8-9}"
no di "\rule{0cm}{0.5cm} & M4 & M6 &  & M4 & M6 &  & M4 & M6 \\"
no di "& (1) & (2) &  & (3) & (4) &  & (5) & (6) \\ \hline"
no di "\rule{0cm}{0.5cm}A) Quadratic Model &  &  &  &  &  &  &  &  \\"

no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f T5a1[1] stars1[1] "$ & $" %5.3f T5a2[1] stars2[1] "$ & & $" %5.3f T5a3[1] stars3[1] "$ & $" %5.3f T5a4[1] stars4[1] "$ & & $" %5.3f T5a5[1] stars5[1] "$ & $" %5.3f T5a6[1] stars6[1] "$ \\"
no di "\rule{0.3cm}{0.0cm}($ s^c=0.055 $)""& $(" %5.3f T5a1[2] ")$ & $(" %5.3f T5a2[2] ")$ & & $(" %5.3f T5a3[2] ")$ & $(" %5.3f T5a4[2] ")$ & & $(" %5.3f T5a5[2] ")$ & $(" %5.3f T5a6[2] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f T5a1[3] stars1[3] "$ & $" %5.3f T5a2[3] stars2[3] "$ & & $" %5.3f T5a3[3] stars3[3] "$ & $" %5.3f T5a4[3] stars4[3] "$ & & $" %5.3f T5a5[3] stars5[3] "$ & $" %5.3f T5a6[3] stars6[3] "$ \\"
no di "\rule{0.3cm}{0.0cm}( $ s^c=0.112 $)""& $(" %5.3f T5a1[4] ")$ & $(" %5.3f T5a2[4] ")$ & & $(" %5.3f T5a3[4] ")$ & $(" %5.3f T5a4[4] ")$ & & $(" %5.3f T5a5[4] ")$ & $(" %5.3f T5a6[4] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f T5a1[5] stars1[5] "$ & $" %5.3f T5a2[5] stars2[5] "$ & & $" %5.3f T5a3[5] stars3[5] "$ & $" %5.3f T5a4[5] stars4[5] "$ & & $" %5.3f T5a5[5] stars5[5] "$ & $" %5.3f T5a6[5] stars6[5] "$ \\"
no di "\rule{0.3cm}{0.0cm}($ s^c=0.200 $)""& $(" %5.3f T5a1[6] ")$ & $(" %5.3f T5a2[6] ")$ & & $(" %5.3f T5a3[6] ")$ & $(" %5.3f T5a4[6] ")$ & & $(" %5.3f T5a5[6] ")$ & $(" %5.3f T5a6[6] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}Observations" "& $" %5.0f T5a1[7] "$ & $" %5.0f T5a2[7] "$ & & $" %5.0f T5a3[7] "$ & $" %5.0f T5a4[7] "$ & & $" %5.0f T5a5[7] "$ & $" %5.0f T5a6[7] "$ \\"
no di "\rule{0.3cm}{0.0cm}R$^2$ (within)" "& $" %5.3f T5a1[8] "$ & $" %5.3f T5a2[8] "$ & & $" %5.3f T5a3[8] "$ & $" %5.3f T5a4[8] "$ & & $" %5.3f T5a5[8] "$ & $" %5.3f T5a6[8] "$ \\"

no di "\hline\hline"
no di "\end{tabular}"
no di "}"
no di "\par"
no di "\begin{minipage}{17.9cm}"
no di "\footnotesize\rule{0cm}{0.35cm}Note: Estimates of model"
no di "(1) in the text for total household income (columns 1"
no di "and 2), per capita household income (columns 3 and 4), and net"
no di "income (columns 5 and 6).  All dependent variables are in logarithm."
no di "The impacts are evaluated at three different levels of exposure: low exposure (the median share),"
no di "average exposure (the mean share), and high exposure (the median"
no di "share for farmers with shares above the mean). The regressions are run on the sample of all farmers (See Online Appendix for results for a subset of catfish farmers only). Panel A) reports"
no di "results from a quadratic model in initial shares, and Panel B) reports results from a partially linear model (Robinson, 1988). Mekong 4 (M4) and Mekong 6 (M6) refer"
no di "to two sets of Mekong provinces that specialize in catfish"
no di "production: M4 includes An Giang, Can Tho, Dong Thap and Vinh Long,"
no di "and M6 adds Soc Trang and Tien Giang."
no di " "
no di "Robust standard errors within parenthesis: $*$, $**$, $***$,"
no di "significant at 10\%, 5\%, and 1\% level, respectively."
no di "\end{minipage}"
no di "\end{center}"
no di "\end{table}"






log close

}


