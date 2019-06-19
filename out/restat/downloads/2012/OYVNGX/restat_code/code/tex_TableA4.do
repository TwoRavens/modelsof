clear
set more off

use "results\TA4a"

* Generates t statistics
gen t1=.
replace t1=TA41[1]/TA41[2] in 1
replace t1=TA41[3]/TA41[4] in 3
replace t1=TA41[5]/TA41[6] in 5
gen t2=.
replace t2=TA42[1]/TA42[2] in 1
replace t2=TA42[3]/TA42[4] in 3
replace t2=TA42[5]/TA42[6] in 5
gen t3=.
replace t3=TA43[1]/TA43[2] in 1
replace t3=TA43[3]/TA43[4] in 3
replace t3=TA43[5]/TA43[6] in 5
gen t4=.
replace t4=TA44[1]/TA44[2] in 1
replace t4=TA44[3]/TA44[4] in 3
replace t4=TA44[5]/TA44[6] in 5
gen t5=.
replace t5=TA45[1]/TA45[2] in 1
replace t5=TA45[3]/TA45[4] in 3
replace t5=TA45[5]/TA45[6] in 5
gen t6=.
replace t6=TA46[1]/TA46[2] in 1
replace t6=TA46[3]/TA46[4] in 3
replace t6=TA46[5]/TA46[6] in 5
gen t7=.
replace t7=TA47[1]/TA47[2] in 1
replace t7=TA47[3]/TA47[4] in 3
replace t7=TA47[5]/TA47[6] in 5
gen t8=.
replace t8=TA48[1]/TA48[2] in 1
replace t8=TA48[3]/TA48[4] in 3
replace t8=TA48[5]/TA48[6] in 5
gen t9=.
replace t9=TA49[1]/TA49[2] in 1
replace t9=TA49[3]/TA49[4] in 3
replace t9=TA49[5]/TA49[6] in 5
gen t10=.
replace t10=TA410[1]/TA410[2] in 1
replace t10=TA410[3]/TA410[4] in 3
replace t10=TA410[5]/TA410[6] in 5


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
log using "results\TableA4.tex", text replace



no di "\landscape"
no di "\begin{table}[t]"
no di "\refstepcounter{table}\label{tab_adjustment}"
no di "\par"
no di "\begin{center}"
no di "{\small"
no di "\begin{tabular}{lccp{0.1cm}ccp{0.1cm}ccp{0.1cm}ccp{0.1cm}cc}"
no di "\multicolumn{15}{c}{Table A4} \\"
no di "\multicolumn{15}{c}{Household Adjustments and Spillovers} \\"
no di "\multicolumn{15}{c}{Impact on Mekong Farms} \\"
no di "\multicolumn{15}{c}{Aquaculture Farms - Mekong and Mekong \& South Samples} \\"
no di "\hline\hline \rule{0cm}{0.5cm} & \multicolumn{2}{c}{Hours Worked} &"
no di "& \multicolumn{2}{c}{"
no di "Catfish Investment} &  & \multicolumn{2}{c}{Total Investment} &  & \multicolumn{2}{c}{Agric. Investment}& & \multicolumn{2}{c}{Misc. Farm Investment} \\"
no di "\cline{2-3}\cline{5-6}\cline{8-9}\cline{11-12}\cline{14-15}"
no di "\rule{0cm}{0.5cm} & M4 & M6 &  & M4 & M6 &  & M4 & M6 &  & M4 & M6 &  & M4 & M6 \\"
no di "& (1) & (2) &  & (3) & (4) &  & (5) & (6) &  & (7) & (8) & & (9) &"
no di "(10)\\ \hline"
no di "\rule{0cm}{0.5cm}A) Mekong\\"

no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f TA41[1] stars1[1] "$ & $" %5.3f TA42[1] stars2[1] "$ & & $" %5.3f TA43[1] stars3[1] "$ & $" %5.3f TA44[1] stars4[1] "$ & & $" %5.3f TA45[1] stars5[1] "$ & $" %5.3f TA46[1] stars6[1] "$ & & $" %5.3f TA47[1] stars7[1] "$ & $" %5.3f TA48[1] stars8[1] "$ & & $" %5.3f TA49[1] stars9[1] "$ & $" %5.3f TA410[1] stars10[1] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA41[2] ")$ & $(" %5.3f TA42[2] ")$ & & $(" %5.3f TA43[2] ")$ & $(" %5.3f TA44[2] ")$ & & $(" %5.3f TA45[2] ")$ & $(" %5.3f TA46[2] ")$ && $ (" %5.3f TA47[2] ")$ & $(" %5.3f TA48[2] ")$ && $ (" %5.3f TA49[2] ")$ & $(" %5.3f TA410[2] ")$ \\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f TA41[3] stars1[3] "$ & $" %5.3f TA42[3] stars2[3] "$ & & $" %5.3f TA43[3] stars3[3] "$ & $" %5.3f TA44[3] stars4[3] "$ & & $" %5.3f TA45[3] stars5[3] "$ & $" %5.3f TA46[3] stars6[3] "$ & & $" %5.3f TA47[3] stars7[3] "$ & $" %5.3f TA48[3] stars8[3] "$ & & $" %5.3f TA49[3] stars9[3] "$ & $" %5.3f TA410[3] stars10[3] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA41[4] ")$ & $(" %5.3f TA42[4] ")$ & & $(" %5.3f TA43[4] ")$ & $(" %5.3f TA44[4] ")$ & & $(" %5.3f TA45[4] ")$ & $(" %5.3f TA46[4] ")$ && $ (" %5.3f TA47[4] ")$ & $(" %5.3f TA48[4] ")$ && $ (" %5.3f TA49[4] ")$ & $(" %5.3f TA410[4] ")$ \\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f TA41[5] stars1[5] "$ & $" %5.3f TA42[5] stars2[5] "$ & & $" %5.3f TA43[5] stars3[5] "$ & $" %5.3f TA44[5] stars4[5] "$ & & $" %5.3f TA45[5] stars5[5] "$ & $" %5.3f TA46[5] stars6[5] "$ & & $" %5.3f TA47[5] stars7[5] "$ & $" %5.3f TA48[5] stars8[5] "$ & & $" %5.3f TA49[5] stars9[5] "$ & $" %5.3f TA410[5] stars10[5] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA41[6] ")$ & $(" %5.3f TA42[6] ")$ & & $(" %5.3f TA43[6] ")$ & $(" %5.3f TA44[6] ")$ & & $(" %5.3f TA45[6] ")$ & $(" %5.3f TA46[6] ")$ && $ (" %5.3f TA47[6] ")$ & $(" %5.3f TA48[6] ")$ && $ (" %5.3f TA49[6] ")$ & $(" %5.3f TA410[6] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}Observations" "& $" %5.0f TA41[7] "$ & $" %5.0f TA42[7] "$ & & $" %5.0f TA43[7] "$ & $" %5.0f TA44[7] "$ & & $" %5.0f TA45[7] "$ & $" %5.0f TA46[7] "$ & & $ " %5.0f TA47[7] "$ & $ " %5.0f TA48[7] "$ & & $ " %5.0f TA49[7] "$ & $ " %5.0f TA410[7] "$ \\"
no di "\rule{0.3cm}{0.0cm}R$^2$ (within)" "& $" %5.3f TA41[8] "$ & $" %5.3f TA42[8] "$ & & $" %5.3f TA43[8] "$ & $" %5.3f TA44[8] "$ & & $" %5.3f TA45[8] "$ & $" %5.3f TA46[8] "$ & & $ " %5.3f TA47[8] "$ & $ " %5.3f TA48[8] "$ & & $ " %5.3f TA49[8] "$ & $ " %5.3f TA410[8] "$ \\"

no di "\cline{2-15}"
no di "\rule{0cm}{0.5cm}B) Mekong \& South\\"

clear
use "results\TA4b"

* Generates t statistics
gen t1=.
replace t1=TA41[1]/TA41[2] in 1
replace t1=TA41[3]/TA41[4] in 3
replace t1=TA41[5]/TA41[6] in 5
gen t2=.
replace t2=TA42[1]/TA42[2] in 1
replace t2=TA42[3]/TA42[4] in 3
replace t2=TA42[5]/TA42[6] in 5
gen t3=.
replace t3=TA43[1]/TA43[2] in 1
replace t3=TA43[3]/TA43[4] in 3
replace t3=TA43[5]/TA43[6] in 5
gen t4=.
replace t4=TA44[1]/TA44[2] in 1
replace t4=TA44[3]/TA44[4] in 3
replace t4=TA44[5]/TA44[6] in 5
gen t5=.
replace t5=TA45[1]/TA45[2] in 1
replace t5=TA45[3]/TA45[4] in 3
replace t5=TA45[5]/TA45[6] in 5
gen t6=.
replace t6=TA46[1]/TA46[2] in 1
replace t6=TA46[3]/TA46[4] in 3
replace t6=TA46[5]/TA46[6] in 5
gen t7=.
replace t7=TA47[1]/TA47[2] in 1
replace t7=TA47[3]/TA47[4] in 3
replace t7=TA47[5]/TA47[6] in 5
gen t8=.
replace t8=TA48[1]/TA48[2] in 1
replace t8=TA48[3]/TA48[4] in 3
replace t8=TA48[5]/TA48[6] in 5
gen t9=.
replace t9=TA49[1]/TA49[2] in 1
replace t9=TA49[3]/TA49[4] in 3
replace t9=TA49[5]/TA49[6] in 5
gen t10=.
replace t10=TA410[1]/TA410[2] in 1
replace t10=TA410[3]/TA410[4] in 3
replace t10=TA410[5]/TA410[6] in 5


* Generates the "starts"
foreach j of numlist 1/10 {
	gen str7 stars`j'=""
	replace stars`j'="^*" if abs(t`j')>=1.64 & abs(t`j')<1.96
	replace stars`j'="^{**}" if abs(t`j')>=1.96 & abs(t`j')<2.47
	replace stars`j'="^{***}" if abs(t`j')>=2.47
	}


no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f TA41[1] stars1[1] "$ & $" %5.3f TA42[1] stars2[1] "$ & & $" %5.3f TA43[1] stars3[1] "$ & $" %5.3f TA44[1] stars4[1] "$ & & $" %5.3f TA45[1] stars5[1] "$ & $" %5.3f TA46[1] stars6[1] "$ & & $" %5.3f TA47[1] stars7[1] "$ & $" %5.3f TA48[1] stars8[1] "$ & & $" %5.3f TA49[1] stars9[1] "$ & $" %5.3f TA410[1] stars10[1] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA41[2] ")$ & $(" %5.3f TA42[2] ")$ & & $(" %5.3f TA43[2] ")$ & $(" %5.3f TA44[2] ")$ & & $(" %5.3f TA45[2] ")$ & $(" %5.3f TA46[2] ")$ && $ (" %5.3f TA47[2] ")$ & $(" %5.3f TA48[2] ")$ && $ (" %5.3f TA49[2] ")$ & $(" %5.3f TA410[2] ")$ \\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f TA41[3] stars1[3] "$ & $" %5.3f TA42[3] stars2[3] "$ & & $" %5.3f TA43[3] stars3[3] "$ & $" %5.3f TA44[3] stars4[3] "$ & & $" %5.3f TA45[3] stars5[3] "$ & $" %5.3f TA46[3] stars6[3] "$ & & $" %5.3f TA47[3] stars7[3] "$ & $" %5.3f TA48[3] stars8[3] "$ & & $" %5.3f TA49[3] stars9[3] "$ & $" %5.3f TA410[3] stars10[3] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA41[4] ")$ & $(" %5.3f TA42[4] ")$ & & $(" %5.3f TA43[4] ")$ & $(" %5.3f TA44[4] ")$ & & $(" %5.3f TA45[4] ")$ & $(" %5.3f TA46[4] ")$ && $ (" %5.3f TA47[4] ")$ & $(" %5.3f TA48[4] ")$ && $ (" %5.3f TA49[4] ")$ & $(" %5.3f TA410[4] ")$ \\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f TA41[5] stars1[5] "$ & $" %5.3f TA42[5] stars2[5] "$ & & $" %5.3f TA43[5] stars3[5] "$ & $" %5.3f TA44[5] stars4[5] "$ & & $" %5.3f TA45[5] stars5[5] "$ & $" %5.3f TA46[5] stars6[5] "$ & & $" %5.3f TA47[5] stars7[5] "$ & $" %5.3f TA48[5] stars8[5] "$ & & $" %5.3f TA49[5] stars9[5] "$ & $" %5.3f TA410[5] stars10[5] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA41[6] ")$ & $(" %5.3f TA42[6] ")$ & & $(" %5.3f TA43[6] ")$ & $(" %5.3f TA44[6] ")$ & & $(" %5.3f TA45[6] ")$ & $(" %5.3f TA46[6] ")$ && $ (" %5.3f TA47[6] ")$ & $(" %5.3f TA48[6] ")$ && $ (" %5.3f TA49[6] ")$ & $(" %5.3f TA410[6] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}Observations" "& $" %5.0f TA41[7] "$ & $" %5.0f TA42[7] "$ & & $" %5.0f TA43[7] "$ & $" %5.0f TA44[7] "$ & & $" %5.0f TA45[7] "$ & $" %5.0f TA46[7] "$ & & $ " %5.0f TA47[7] "$ & $ " %5.0f TA48[7] "$ & & $ " %5.0f TA49[7] "$ & $ " %5.0f TA410[7] "$ \\"
no di "\rule{0.3cm}{0.0cm}R$^2$ (within)" "& $" %5.3f TA41[8] "$ & $" %5.3f TA42[8] "$ & & $" %5.3f TA43[8] "$ & $" %5.3f TA44[8] "$ & & $" %5.3f TA45[8] "$ & $" %5.3f TA46[8] "$ & & $ " %5.3f TA47[8] "$ & $ " %5.3f TA48[8] "$ & & $ " %5.3f TA49[8] "$ & $ " %5.3f TA410[8] "$ \\"

no di "\hline\hline"
no di "\end{tabular}"
no di "}"
no di "\par"
no di "\begin{minipage}{22.3cm}"
no di "\footnotesize\rule{0cm}{0.35cm}Note: Estimates of household"
no di "adjustments: hours worked, catfish investment, total investment,"
no di "agricultural investments, and miscellaneous farm investments"
no di "(poultry, livestock, informal odd-job). The estimates show impacts on Mekong farms estimated with a quadratic polynomial in initial catfish shares. Panel A) is based on model (1) using only fishing farms in the Mekong."
no di "Panel B) is based on model (2) using fishing farms in both the Mekong and South provinces. Mekong"
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


