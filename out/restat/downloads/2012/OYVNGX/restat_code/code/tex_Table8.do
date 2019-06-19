clear
set more off

use "results\T8a"

* Generates t statistics
gen t1=.
replace t1=T81[1]/T81[2] in 1
replace t1=T81[3]/T81[4] in 3
replace t1=T81[5]/T81[6] in 5
gen t2=.
replace t2=T82[1]/T82[2] in 1
replace t2=T82[3]/T82[4] in 3
replace t2=T82[5]/T82[6] in 5
gen t3=.
replace t3=T83[1]/T83[2] in 1
replace t3=T83[3]/T83[4] in 3
replace t3=T83[5]/T83[6] in 5
gen t4=.
replace t4=T84[1]/T84[2] in 1
replace t4=T84[3]/T84[4] in 3
replace t4=T84[5]/T84[6] in 5
gen t5=.
replace t5=T85[1]/T85[2] in 1
replace t5=T85[3]/T85[4] in 3
replace t5=T85[5]/T85[6] in 5
gen t6=.
replace t6=T86[1]/T86[2] in 1
replace t6=T86[3]/T86[4] in 3
replace t6=T86[5]/T86[6] in 5
gen t7=.
replace t7=T87[1]/T87[2] in 1
replace t7=T87[3]/T87[4] in 3
replace t7=T87[5]/T87[6] in 5
gen t8=.
replace t8=T88[1]/T88[2] in 1
replace t8=T88[3]/T88[4] in 3
replace t8=T88[5]/T88[6] in 5
gen t9=.
replace t9=T89[1]/T89[2] in 1
replace t9=T89[3]/T89[4] in 3
replace t9=T89[5]/T89[6] in 5
gen t10=.
replace t10=T810[1]/T810[2] in 1
replace t10=T810[3]/T810[4] in 3
replace t10=T810[5]/T810[6] in 5


* Generates the "starts"
foreach j of numlist 1/10 {
	gen str7 stars`j'=""
	replace stars`j'="^*" if abs(t`j')>=1.64 & abs(t`j')<1.96
	replace stars`j'="^{**}" if abs(t`j')>=1.96 & abs(t`j')<2.47
	replace stars`j'="^{***}" if abs(t`j')>=2.47
	}



qui { 
set linesize 200
capture log close
log using "results\Table8.tex", text replace



no di "\landscape"
no di "\begin{table}[t]"
no di "\refstepcounter{table}\label{tab_adjustment}"
no di "\par"
no di "\begin{center}"
no di "{\small"
no di "\begin{tabular}{lccp{0.1cm}ccp{0.1cm}ccp{0.1cm}ccp{0.1cm}cc}"
no di "\multicolumn{15}{c}{Table 8} \\"
no di "\multicolumn{15}{c}{Household Adjustments and Spillovers} \\"
no di "\multicolumn{15}{c}{Impact on Mekong Farms} \\"
no di "\multicolumn{15}{c}{All Farms - Mekong and Mekong \& South Samples} \\"
no di "\hline\hline \rule{0cm}{0.5cm} & \multicolumn{2}{c}{Hours Worked} &"
no di "& \multicolumn{2}{c}{"
no di "Catfish Investment} &  & \multicolumn{2}{c}{Total Investment} &  & \multicolumn{2}{c}{Agric. Investment}& & \multicolumn{2}{c}{Misc. Farm Investment} \\"
no di "\cline{2-3}\cline{5-6}\cline{8-9}\cline{11-12}\cline{14-15}"
no di "\rule{0cm}{0.5cm} & M4 & M6 &  & M4 & M6 &  & M4 & M6 &  & M4 & M6 &  & M4 & M6 \\"
no di "& (1) & (2) &  & (3) & (4) &  & (5) & (6) &  & (7) & (8) & & (9) &"
no di "(10)\\ \hline"
no di "\rule{0cm}{0.5cm}A) Mekong\\"

no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f T81[1] stars1[1] "$ & $" %5.3f T82[1] stars2[1] "$ & & $" %5.3f T83[1] stars3[1] "$ & $" %5.3f T84[1] stars4[1] "$ & & $" %5.3f T85[1] stars5[1] "$ & $" %5.3f T86[1] stars6[1] "$ & & $" %5.3f T87[1] stars7[1] "$ & $" %5.3f T88[1] stars8[1] "$ & & $" %5.3f T89[1] stars9[1] "$ & $" %5.3f T810[1] stars10[1] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T81[2] ")$ & $(" %5.3f T82[2] ")$ & & $(" %5.3f T83[2] ")$ & $(" %5.3f T84[2] ")$ & & $(" %5.3f T85[2] ")$ & $(" %5.3f T86[2] ")$ && $ (" %5.3f T87[2] ")$ & $(" %5.3f T88[2] ")$ && $ (" %5.3f T89[2] ")$ & $(" %5.3f T810[2] ")$ \\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f T81[3] stars1[3] "$ & $" %5.3f T82[3] stars2[3] "$ & & $" %5.3f T83[3] stars3[3] "$ & $" %5.3f T84[3] stars4[3] "$ & & $" %5.3f T85[3] stars5[3] "$ & $" %5.3f T86[3] stars6[3] "$ & & $" %5.3f T87[3] stars7[3] "$ & $" %5.3f T88[3] stars8[3] "$ & & $" %5.3f T89[3] stars9[3] "$ & $" %5.3f T810[3] stars10[3] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T81[4] ")$ & $(" %5.3f T82[4] ")$ & & $(" %5.3f T83[4] ")$ & $(" %5.3f T84[4] ")$ & & $(" %5.3f T85[4] ")$ & $(" %5.3f T86[4] ")$ && $ (" %5.3f T87[4] ")$ & $(" %5.3f T88[4] ")$ && $ (" %5.3f T89[4] ")$ & $(" %5.3f T810[4] ")$ \\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f T81[5] stars1[5] "$ & $" %5.3f T82[5] stars2[5] "$ & & $" %5.3f T83[5] stars3[5] "$ & $" %5.3f T84[5] stars4[5] "$ & & $" %5.3f T85[5] stars5[5] "$ & $" %5.3f T86[5] stars6[5] "$ & & $" %5.3f T87[5] stars7[5] "$ & $" %5.3f T88[5] stars8[5] "$ & & $" %5.3f T89[5] stars9[5] "$ & $" %5.3f T810[5] stars10[5] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T81[6] ")$ & $(" %5.3f T82[6] ")$ & & $(" %5.3f T83[6] ")$ & $(" %5.3f T84[6] ")$ & & $(" %5.3f T85[6] ")$ & $(" %5.3f T86[6] ")$ && $ (" %5.3f T87[6] ")$ & $(" %5.3f T88[6] ")$ && $ (" %5.3f T89[6] ")$ & $(" %5.3f T810[6] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}Observations" "& $" %5.0f T81[7] "$ & $" %5.0f T82[7] "$ & & $" %5.0f T83[7] "$ & $" %5.0f T84[7] "$ & & $" %5.0f T85[7] "$ & $" %5.0f T86[7] "$ & & $ " %5.0f T87[7] "$ & $ " %5.0f T88[7] "$ & & $ " %5.0f T89[7] "$ & $ " %5.0f T810[7] "$ \\"
no di "\rule{0.3cm}{0.0cm}R$^2$ (within)" "& $" %5.3f T81[8] "$ & $" %5.3f T82[8] "$ & & $" %5.3f T83[8] "$ & $" %5.3f T84[8] "$ & & $" %5.3f T85[8] "$ & $" %5.3f T86[8] "$ & & $ " %5.3f T87[8] "$ & $ " %5.3f T88[8] "$ & & $ " %5.3f T89[8] "$ & $ " %5.3f T810[8] "$ \\"

no di "\cline{2-15}"
no di "\rule{0cm}{0.5cm}B) Mekong \& South\\"

clear
use "results\T8b"

* Generates t statistics
gen t1=.
replace t1=T81[1]/T81[2] in 1
replace t1=T81[3]/T81[4] in 3
replace t1=T81[5]/T81[6] in 5
gen t2=.
replace t2=T82[1]/T82[2] in 1
replace t2=T82[3]/T82[4] in 3
replace t2=T82[5]/T82[6] in 5
gen t3=.
replace t3=T83[1]/T83[2] in 1
replace t3=T83[3]/T83[4] in 3
replace t3=T83[5]/T83[6] in 5
gen t4=.
replace t4=T84[1]/T84[2] in 1
replace t4=T84[3]/T84[4] in 3
replace t4=T84[5]/T84[6] in 5
gen t5=.
replace t5=T85[1]/T85[2] in 1
replace t5=T85[3]/T85[4] in 3
replace t5=T85[5]/T85[6] in 5
gen t6=.
replace t6=T86[1]/T86[2] in 1
replace t6=T86[3]/T86[4] in 3
replace t6=T86[5]/T86[6] in 5
gen t7=.
replace t7=T87[1]/T87[2] in 1
replace t7=T87[3]/T87[4] in 3
replace t7=T87[5]/T87[6] in 5
gen t8=.
replace t8=T88[1]/T88[2] in 1
replace t8=T88[3]/T88[4] in 3
replace t8=T88[5]/T88[6] in 5
gen t9=.
replace t9=T89[1]/T89[2] in 1
replace t9=T89[3]/T89[4] in 3
replace t9=T89[5]/T89[6] in 5
gen t10=.
replace t10=T810[1]/T810[2] in 1
replace t10=T810[3]/T810[4] in 3
replace t10=T810[5]/T810[6] in 5


* Generates the "starts"
foreach j of numlist 1/10 {
	gen str7 stars`j'=""
	replace stars`j'="^*" if abs(t`j')>=1.64 & abs(t`j')<1.96
	replace stars`j'="^{**}" if abs(t`j')>=1.96 & abs(t`j')<2.47
	replace stars`j'="^{***}" if abs(t`j')>=2.47
	}


no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f T81[1] stars1[1] "$ & $" %5.3f T82[1] stars2[1] "$ & & $" %5.3f T83[1] stars3[1] "$ & $" %5.3f T84[1] stars4[1] "$ & & $" %5.3f T85[1] stars5[1] "$ & $" %5.3f T86[1] stars6[1] "$ & & $" %5.3f T87[1] stars7[1] "$ & $" %5.3f T88[1] stars8[1] "$ & & $" %5.3f T89[1] stars9[1] "$ & $" %5.3f T810[1] stars10[1] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T81[2] ")$ & $(" %5.3f T82[2] ")$ & & $(" %5.3f T83[2] ")$ & $(" %5.3f T84[2] ")$ & & $(" %5.3f T85[2] ")$ & $(" %5.3f T86[2] ")$ && $ (" %5.3f T87[2] ")$ & $(" %5.3f T88[2] ")$ && $ (" %5.3f T89[2] ")$ & $(" %5.3f T810[2] ")$ \\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f T81[3] stars1[3] "$ & $" %5.3f T82[3] stars2[3] "$ & & $" %5.3f T83[3] stars3[3] "$ & $" %5.3f T84[3] stars4[3] "$ & & $" %5.3f T85[3] stars5[3] "$ & $" %5.3f T86[3] stars6[3] "$ & & $" %5.3f T87[3] stars7[3] "$ & $" %5.3f T88[3] stars8[3] "$ & & $" %5.3f T89[3] stars9[3] "$ & $" %5.3f T810[3] stars10[3] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T81[4] ")$ & $(" %5.3f T82[4] ")$ & & $(" %5.3f T83[4] ")$ & $(" %5.3f T84[4] ")$ & & $(" %5.3f T85[4] ")$ & $(" %5.3f T86[4] ")$ && $ (" %5.3f T87[4] ")$ & $(" %5.3f T88[4] ")$ && $ (" %5.3f T89[4] ")$ & $(" %5.3f T810[4] ")$ \\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f T81[5] stars1[5] "$ & $" %5.3f T82[5] stars2[5] "$ & & $" %5.3f T83[5] stars3[5] "$ & $" %5.3f T84[5] stars4[5] "$ & & $" %5.3f T85[5] stars5[5] "$ & $" %5.3f T86[5] stars6[5] "$ & & $" %5.3f T87[5] stars7[5] "$ & $" %5.3f T88[5] stars8[5] "$ & & $" %5.3f T89[5] stars9[5] "$ & $" %5.3f T810[5] stars10[5] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T81[6] ")$ & $(" %5.3f T82[6] ")$ & & $(" %5.3f T83[6] ")$ & $(" %5.3f T84[6] ")$ & & $(" %5.3f T85[6] ")$ & $(" %5.3f T86[6] ")$ && $ (" %5.3f T87[6] ")$ & $(" %5.3f T88[6] ")$ && $ (" %5.3f T89[6] ")$ & $(" %5.3f T810[6] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}Observations" "& $" %5.0f T81[7] "$ & $" %5.0f T82[7] "$ & & $" %5.0f T83[7] "$ & $" %5.0f T84[7] "$ & & $" %5.0f T85[7] "$ & $" %5.0f T86[7] "$ & & $ " %5.0f T87[7] "$ & $ " %5.0f T88[7] "$ & & $ " %5.0f T89[7] "$ & $ " %5.0f T810[7] "$ \\"
no di "\rule{0.3cm}{0.0cm}R$^2$ (within)" "& $" %5.3f T81[8] "$ & $" %5.3f T82[8] "$ & & $" %5.3f T83[8] "$ & $" %5.3f T84[8] "$ & & $" %5.3f T85[8] "$ & $" %5.3f T86[8] "$ & & $ " %5.3f T87[8] "$ & $ " %5.3f T88[8] "$ & & $ " %5.3f T89[8] "$ & $ " %5.3f T810[8] "$ \\"

no di "\hline\hline"
no di "\end{tabular}"
no di "}"
no di "\par"
no di "\begin{minipage}{22.3cm}"
no di "\footnotesize\rule{0cm}{0.35cm}Note: Estimates of household"
no di "adjustments: hours worked, catfish investment, total investment,"
no di "agricultural investments, and miscellaneous farm investments"
no di "(poultry, livestock, informal odd-job). The estimates show impacts on Mekong farms estimated with a quadratic polynomial in initial catfish shares."
no di "Panel A) is based on model (1) using all Mekong observations, except for the catfish investment variable (which uses only fishing farms)."
no di "Panel B) is based on model (2) using all Mekong and South observations, except for the catfish investment variable (which uses only fishing farms). See Only Appendix for results using only fishing farms.  Mekong"
no di "4 (M4) and Mekong 6 (M6) refer to two sets of Mekong provinces that"
no di "specialize in catfish production: M4 includes An Giang, Can Tho,"
no di "Dong Thap and Vinh Long, and M6 adds Soc Trang and Tien Giang."
no di ""
no di "Robust standard errors within parenthesis: $*$, $**$, $***$,"
no di "significant at 10\%, 5\%, and 1\% level, respectively."
no di "\end{minipage}"
no di "\end{center}"
no di "\end{table}"

no di "\endlandscape"

log close

}


