clear
set more off

use "results\T6"


* Generates t statistics
gen t1=.
replace t1=T61[1]/T61[2] in 1
replace t1=T61[3]/T61[4] in 3
replace t1=T61[5]/T61[6] in 5
replace t1=T61[7]/T61[8] in 7
replace t1=T61[9]/T61[10] in 9
replace t1=T61[11]/T61[12] in 11
gen t2=.
replace t2=T62[1]/T62[2] in 1
replace t2=T62[3]/T62[4] in 3
replace t2=T62[5]/T62[6] in 5
replace t2=T62[7]/T62[8] in 7
replace t2=T62[9]/T62[10] in 9
replace t2=T62[11]/T62[12] in 11
gen t3=.
replace t3=T63[1]/T63[2] in 1
replace t3=T63[3]/T63[4] in 3
replace t3=T63[5]/T63[6] in 5
replace t3=T63[7]/T63[8] in 7
replace t3=T63[9]/T63[10] in 9
replace t3=T63[11]/T63[12] in 11
gen t4=.
replace t4=T64[1]/T64[2] in 1
replace t4=T64[3]/T64[4] in 3
replace t4=T64[5]/T64[6] in 5
replace t4=T64[7]/T64[8] in 7
replace t4=T64[9]/T64[10] in 9
replace t4=T64[11]/T64[12] in 11
gen t5=.
replace t5=T65[1]/T65[2] in 1
replace t5=T65[3]/T65[4] in 3
replace t5=T65[5]/T65[6] in 5
replace t5=T65[7]/T65[8] in 7
replace t5=T65[9]/T65[10] in 9
replace t5=T65[11]/T65[12] in 11
gen t6=.
replace t6=T66[1]/T66[2] in 1
replace t6=T66[3]/T66[4] in 3
replace t6=T66[5]/T66[6] in 5
replace t6=T66[7]/T66[8] in 7
replace t6=T66[9]/T66[10] in 9
replace t6=T66[11]/T66[12] in 11

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
log using "results\Table6.tex", text replace


no di "\begin{table}[t]"
no di "\refstepcounter{table}\label{tab_income_south}"
no di "\par"
no di "\begin{center}"
no di "{\small"
no di "\begin{tabular}{lccp{0.1cm}ccp{0.1cm}cc}"
no di "\multicolumn{9}{c}{Table 6} \\"
no di "\multicolumn{9}{c}{Average Impact of Anti-Dumping on Income} \\"
no di "\multicolumn{9}{c}{Mekong \& South Provinces} \\"
no di "\multicolumn{9}{c}{All Farms} \\ \hline\hline"
no di "\rule{0cm}{0.5cm} & \multicolumn{2}{c}{Total Income} &  & \multicolumn{2}{c}{"
no di "Per Capita Income} &  & \multicolumn{2}{c}{Net Income} \\"
no di "\cline{2-3}\cline{5-6}\cline{8-9}"
no di "\rule{0cm}{0.5cm} & M4 & M6 &  & M4 & M6 &  & M4 & M6 \\"
no di "& (1) & (2) &  & (3) & (4) &  & (5) & (6) \\ \hline"
no di "\rule{0cm}{0.5cm}A) Mekong &  &  &  &  &  &  &  &  \\"

no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f T61[1] stars1[1] "$ & $" %5.3f T62[1] stars2[1] "$ & & $" %5.3f T63[1] stars3[1] "$ & $" %5.3f T64[1] stars4[1] "$ & & $" %5.3f T65[1] stars5[1] "$ & $" %5.3f T66[1] stars6[1] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T61[2] ")$ & $(" %5.3f T62[2] ")$ & & $(" %5.3f T63[2] ")$ & $(" %5.3f T64[2] ")$ & & $(" %5.3f T65[2] ")$ & $(" %5.3f T66[2] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f T61[3] stars1[3] "$ & $" %5.3f T62[3] stars2[3] "$ & & $" %5.3f T63[3] stars3[3] "$ & $" %5.3f T64[3] stars4[3] "$ & & $" %5.3f T65[3] stars5[3] "$ & $" %5.3f T66[3] stars6[3] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T61[4] ")$ & $(" %5.3f T62[4] ")$ & & $(" %5.3f T63[4] ")$ & $(" %5.3f T64[4] ")$ & & $(" %5.3f T65[4] ")$ & $(" %5.3f T66[4] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f T61[5] stars1[5] "$ & $" %5.3f T62[5] stars2[5] "$ & & $" %5.3f T63[5] stars3[5] "$ & $" %5.3f T64[5] stars4[5] "$ & & $" %5.3f T65[5] stars5[5] "$ & $" %5.3f T66[5] stars6[5] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T61[6] ")$ & $(" %5.3f T62[6] ")$ & & $(" %5.3f T63[6] ")$ & $(" %5.3f T64[6] ")$ & & $(" %5.3f T65[6] ")$ & $(" %5.3f T66[6] ")$ \\"
no di "\cline{2-9}"

no di "\rule{0cm}{0.5cm}B) South &  &  &  &  &  &  &  &  \\"

no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f T61[7] stars1[7] "$ & $" %5.3f T62[7] stars2[7] "$ & & $" %5.3f T63[7] stars3[7] "$ & $" %5.3f T64[7] stars4[7] "$ & & $" %5.3f T65[7] stars5[7] "$ & $" %5.3f T66[7] stars6[7] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T61[8] ")$ & $(" %5.3f T62[8] ")$ & & $(" %5.3f T63[8] ")$ & $(" %5.3f T64[8] ")$ & & $(" %5.3f T65[8] ")$ & $(" %5.3f T66[8] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f T61[9] stars1[9] "$ & $" %5.3f T62[9] stars2[9] "$ & & $" %5.3f T63[9] stars3[9] "$ & $" %5.3f T64[9] stars4[9] "$ & & $" %5.3f T65[9] stars5[9] "$ & $" %5.3f T66[9] stars6[9] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T61[10] ")$ & $(" %5.3f T62[10] ")$ & & $(" %5.3f T63[10] ")$ & $(" %5.3f T64[10] ")$ & & $(" %5.3f T65[10] ")$ & $(" %5.3f T66[10] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f T61[11] stars1[11] "$ & $" %5.3f T62[11] stars2[11] "$ & & $" %5.3f T63[11] stars3[11] "$ & $" %5.3f T64[11] stars4[11] "$ & & $" %5.3f T65[11] stars5[11] "$ & $" %5.3f T66[11] stars6[11] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T61[12] ")$ & $(" %5.3f T62[12] ")$ & & $(" %5.3f T63[12] ")$ & $(" %5.3f T64[12] ")$ & & $(" %5.3f T65[12] ")$ & $(" %5.3f T66[12] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"

no di "\rule{0.3cm}{0.0cm}Observations" "& $" %5.0f T61[13] "$ & $" %5.0f T62[13] "$ & & $" %5.0f T63[13] "$ & $" %5.0f T64[13] "$ & & $" %5.0f T65[13] "$ & $" %5.0f T66[13] "$ \\"
no di "\rule{0.3cm}{0.0cm}R$^2$ (within)" "& $" %5.3f T61[14] "$ & $" %5.3f T62[14] "$ & & $" %5.3f T63[14] "$ & $" %5.3f T64[14] "$ & & $" %5.3f T65[14] "$ & $" %5.3f T66[14] "$ \\"

no di "\hline\hline"
no di "\end{tabular}"
no di "}"
no di "\par"
no di "\begin{minipage}{17.9cm}"
no di "\footnotesize\rule{0cm}{0.35cm}Note: Estimates of model"
no di "(2) in the text for total household income (columns 1"
no di "and 2), per capita household income (columns 3 and 4), and net"
no di "income (columns 5 and 6). All dependent variables are in logarithm."
no di "Based on a quadratic model in initial shares evaluated at three"
no di "different levels of exposure: low exposure (the median share),"
no di "average exposure (the mean share), and high exposure (the median"
no di "share for farmers with shares above the mean). The regressions are run on the sample of all farmers (See Online Appendix for results for a subset of catfish farmers only). Panel A) reports"
no di "results for Mekong farmers and Panel B), for South farmers. Mekong 4 (M4) and Mekong 6 (M6) refer"
no di "to two sets of Mekong provinces that specialize in catfish"
no di "production: M4 includes An Giang, Can Tho, Dong Thap and Vinh Long,"
no di "and M6 adds Soc Trang and Tien Giang. South refers to non-Mekong"
no di "farms in Southern Vietnam (see text)."
no di ""
no di "Robust standard errors within parenthesis: $*$, $**$, $***$,"
no di "significant at 10\%, 5\%, and 1\% level, respectively."
no di "\end{minipage}"
no di "\end{center}"
no di "\end{table}"




log close

}


