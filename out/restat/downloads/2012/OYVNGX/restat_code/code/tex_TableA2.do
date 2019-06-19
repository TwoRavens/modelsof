clear
set more off

use "results\TA2"


* Generates t statistics
gen t1=.
replace t1=TA21[1]/TA21[2] in 1
replace t1=TA21[3]/TA21[4] in 3
replace t1=TA21[5]/TA21[6] in 5
replace t1=TA21[7]/TA21[8] in 7
replace t1=TA21[9]/TA21[10] in 9
replace t1=TA21[11]/TA21[12] in 11
gen t2=.
replace t2=TA22[1]/TA22[2] in 1
replace t2=TA22[3]/TA22[4] in 3
replace t2=TA22[5]/TA22[6] in 5
replace t2=TA22[7]/TA22[8] in 7
replace t2=TA22[9]/TA22[10] in 9
replace t2=TA22[11]/TA22[12] in 11
gen t3=.
replace t3=TA23[1]/TA23[2] in 1
replace t3=TA23[3]/TA23[4] in 3
replace t3=TA23[5]/TA23[6] in 5
replace t3=TA23[7]/TA23[8] in 7
replace t3=TA23[9]/TA23[10] in 9
replace t3=TA23[11]/TA23[12] in 11
gen t4=.
replace t4=TA24[1]/TA24[2] in 1
replace t4=TA24[3]/TA24[4] in 3
replace t4=TA24[5]/TA24[6] in 5
replace t4=TA24[7]/TA24[8] in 7
replace t4=TA24[9]/TA24[10] in 9
replace t4=TA24[11]/TA24[12] in 11
gen t5=.
replace t5=TA25[1]/TA25[2] in 1
replace t5=TA25[3]/TA25[4] in 3
replace t5=TA25[5]/TA25[6] in 5
replace t5=TA25[7]/TA25[8] in 7
replace t5=TA25[9]/TA25[10] in 9
replace t5=TA25[11]/TA25[12] in 11
gen t6=.
replace t6=TA26[1]/TA26[2] in 1
replace t6=TA26[3]/TA26[4] in 3
replace t6=TA26[5]/TA26[6] in 5
replace t6=TA26[7]/TA26[8] in 7
replace t6=TA26[9]/TA26[10] in 9
replace t6=TA26[11]/TA26[12] in 11

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
log using "results\TableA2.tex", text replace


no di "\begin{table}[t]"
no di "\refstepcounter{table}\label{tab_income_south}"
no di "\par"
no di "\begin{center}"
no di "{\small"
no di "\begin{tabular}{lccp{0.1cm}ccp{0.1cm}cc}"
no di "\multicolumn{9}{c}{Table A2} \\"
no di "\multicolumn{9}{c}{Average Impact of Anti-Dumping on Income} \\"
no di "\multicolumn{9}{c}{Mekong \& South Provinces} \\"
no di "\multicolumn{9}{c}{Aquaculture Farms} \\ \hline\hline"
no di "\rule{0cm}{0.5cm} & \multicolumn{2}{c}{Total Income} &  & \multicolumn{2}{c}{"
no di "Per Capita Income} &  & \multicolumn{2}{c}{Net Income} \\"
no di "\cline{2-3}\cline{5-6}\cline{8-9}"
no di "\rule{0cm}{0.5cm} & M4 & M6 &  & M4 & M6 &  & M4 & M6 \\"
no di "& (1) & (2) &  & (3) & (4) &  & (5) & (6) \\ \hline"
no di "\rule{0cm}{0.5cm}A) Mekong &  &  &  &  &  &  &  &  \\"

no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f TA21[1] stars1[1] "$ & $" %5.3f TA22[1] stars2[1] "$ & & $" %5.3f TA23[1] stars3[1] "$ & $" %5.3f TA24[1] stars4[1] "$ & & $" %5.3f TA25[1] stars5[1] "$ & $" %5.3f TA26[1] stars6[1] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA21[2] ")$ & $(" %5.3f TA22[2] ")$ & & $(" %5.3f TA23[2] ")$ & $(" %5.3f TA24[2] ")$ & & $(" %5.3f TA25[2] ")$ & $(" %5.3f TA26[2] ")$ \\"
no di "\\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f TA21[3] stars1[3] "$ & $" %5.3f TA22[3] stars2[3] "$ & & $" %5.3f TA23[3] stars3[3] "$ & $" %5.3f TA24[3] stars4[3] "$ & & $" %5.3f TA25[3] stars5[3] "$ & $" %5.3f TA26[3] stars6[3] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA21[4] ")$ & $(" %5.3f TA22[4] ")$ & & $(" %5.3f TA23[4] ")$ & $(" %5.3f TA24[4] ")$ & & $(" %5.3f TA25[4] ")$ & $(" %5.3f TA26[4] ")$ \\"
no di "\\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f TA21[5] stars1[5] "$ & $" %5.3f TA22[5] stars2[5] "$ & & $" %5.3f TA23[5] stars3[5] "$ & $" %5.3f TA24[5] stars4[5] "$ & & $" %5.3f TA25[5] stars5[5] "$ & $" %5.3f TA26[5] stars6[5] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA21[6] ")$ & $(" %5.3f TA22[6] ")$ & & $(" %5.3f TA23[6] ")$ & $(" %5.3f TA24[6] ")$ & & $(" %5.3f TA25[6] ")$ & $(" %5.3f TA26[6] ")$ \\"
no di "\cline{2-9}"

no di "\rule{0cm}{0.5cm}B) South &  &  &  &  &  &  &  &  \\"

no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f TA21[7] stars1[7] "$ & $" %5.3f TA22[7] stars2[7] "$ & & $" %5.3f TA23[7] stars3[7] "$ & $" %5.3f TA24[7] stars4[7] "$ & & $" %5.3f TA25[7] stars5[7] "$ & $" %5.3f TA26[7] stars6[7] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA21[8] ")$ & $(" %5.3f TA22[8] ")$ & & $(" %5.3f TA23[8] ")$ & $(" %5.3f TA24[8] ")$ & & $(" %5.3f TA25[8] ")$ & $(" %5.3f TA26[8] ")$ \\"
no di "\\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f TA21[9] stars1[9] "$ & $" %5.3f TA22[9] stars2[9] "$ & & $" %5.3f TA23[9] stars3[9] "$ & $" %5.3f TA24[9] stars4[9] "$ & & $" %5.3f TA25[9] stars5[9] "$ & $" %5.3f TA26[9] stars6[9] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA21[10] ")$ & $(" %5.3f TA22[10] ")$ & & $(" %5.3f TA23[10] ")$ & $(" %5.3f TA24[10] ")$ & & $(" %5.3f TA25[10] ")$ & $(" %5.3f TA26[10] ")$ \\"
no di "\\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f TA21[11] stars1[11] "$ & $" %5.3f TA22[11] stars2[11] "$ & & $" %5.3f TA23[11] stars3[11] "$ & $" %5.3f TA24[11] stars4[11] "$ & & $" %5.3f TA25[11] stars5[11] "$ & $" %5.3f TA26[11] stars6[11] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA21[12] ")$ & $(" %5.3f TA22[12] ")$ & & $(" %5.3f TA23[12] ")$ & $(" %5.3f TA24[12] ")$ & & $(" %5.3f TA25[12] ")$ & $(" %5.3f TA26[12] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"

no di "\rule{0.3cm}{0.0cm}Observations" "& $" %5.0f TA21[13] "$ & $" %5.0f TA22[13] "$ & & $" %5.0f TA23[13] "$ & $" %5.0f TA24[13] "$ & & $" %5.0f TA25[13] "$ & $" %5.0f TA26[13] "$ \\"
no di "\rule{0.3cm}{0.0cm}R$^2$ (within)" "& $" %5.3f TA21[14] "$ & $" %5.3f TA22[14] "$ & & $" %5.3f TA23[14] "$ & $" %5.3f TA24[14] "$ & & $" %5.3f TA25[14] "$ & $" %5.3f TA26[14] "$ \\"

no di "\hline\hline"
no di "\end{tabular}"
no di "}"
no di "\par"
no di "\begin{minipage}{17.9cm}"
no di "\footnotesize\rule{0cm}{0.35cm}Note: Estimates of model"
no di "(2) in the text for total household income (columns 1"
no di "and 2), per capita household income (columns 3 and 4), and net"
no di "income (columns 5 and 6). All dependent variables are in logarithm."
no di "The sample comprises only aquaculture households."
no di "Based on a quadratic model in initial shares evaluated at three"
no di "different levels of exposure: low exposure (the median share),"
no di "average exposure (the mean share), and high exposure (the median"
no di "share for farmers with shares above the mean). Panel A) reports"
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


