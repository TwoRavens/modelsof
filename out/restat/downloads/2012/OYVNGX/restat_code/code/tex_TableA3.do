clear
set more off

use "results\TA3a"

* Generates t statistics
gen t1=.
replace t1=TA31[1]/TA31[2] in 1
replace t1=TA31[3]/TA31[4] in 3
replace t1=TA31[5]/TA31[6] in 5
gen t2=.
replace t2=TA32[1]/TA32[2] in 1
replace t2=TA32[3]/TA32[4] in 3
replace t2=TA32[5]/TA32[6] in 5
gen t3=.
replace t3=TA33[1]/TA33[2] in 1
replace t3=TA33[3]/TA33[4] in 3
replace t3=TA33[5]/TA33[6] in 5
gen t4=.
replace t4=TA34[1]/TA34[2] in 1
replace t4=TA34[3]/TA34[4] in 3
replace t4=TA34[5]/TA34[6] in 5
gen t5=.
replace t5=TA35[1]/TA35[2] in 1
replace t5=TA35[3]/TA35[4] in 3
replace t5=TA35[5]/TA35[6] in 5
gen t6=.
replace t6=TA36[1]/TA36[2] in 1
replace t6=TA36[3]/TA36[4] in 3
replace t6=TA36[5]/TA36[6] in 5
gen t7=.
replace t7=TA37[1]/TA37[2] in 1
replace t7=TA37[3]/TA37[4] in 3
replace t7=TA37[5]/TA37[6] in 5
gen t8=.
replace t8=TA38[1]/TA38[2] in 1
replace t8=TA38[3]/TA38[4] in 3
replace t8=TA38[5]/TA38[6] in 5
gen t9=.
replace t9=TA39[1]/TA39[2] in 1
replace t9=TA39[3]/TA39[4] in 3
replace t9=TA39[5]/TA39[6] in 5
gen t10=.
replace t10=TA310[1]/TA310[2] in 1
replace t10=TA310[3]/TA310[4] in 3
replace t10=TA310[5]/TA310[6] in 5


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
log using "results\TableA3.tex", text replace


no di "\landscape"
no di "\begin{table}[t]"
no di "\refstepcounter{table}\label{tab_incomesources}"
no di "\par"
no di "\begin{center}"
no di "{\small"
no di "\begin{tabular}{lccp{0.1cm}ccp{0.1cm}ccp{0.1cm}ccp{0.1cm}cc}"
no di "\multicolumn{15}{c}{Table A3} \\"
no di "\multicolumn{15}{c}{Impact of Anti-Dumping on Income Sources for Mekong Farms} \\"
no di "\multicolumn{15}{c}{Aquaculture Farms - Mekong and Mekong \& South Samples} \\"
no di "\hline\hline \rule{0cm}{0.5cm} & \multicolumn{2}{c}{Catfish Income}"
no di "&  & \multicolumn{2}{c}{"
no di "Wage Income} &  & \multicolumn{2}{c}{Agric. Sales} &  & \multicolumn{2}{c}{Agric. Own}& & \multicolumn{2}{c}{Misc. Farm Income} \\"
no di "%& \multicolumn{2}{c}{Income} &  & \multicolumn{2}{c}{Income} &  &"
no di "%\multicolumn{2}{c}{Agriculture} &  & \multicolumn{2}{c}{Income} \\"
no di "\cline{2-3}\cline{5-6}\cline{8-9}\cline{11-12}\cline{14-15}"
no di "\rule{0cm}{0.5cm} & M4 & M6 &  & M4 & M6 &  & M4 & M6 &  & M4 & M6 &  & M4 & M6 \\"
no di "& (1) & (2) &  & (3) & (4) &  & (5) & (6) &  & (7) & (8) && (9) &"
no di "(10)\\ \hline"
no di "\rule{0cm}{0.5cm}A) Mekong \\"


no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f TA31[1] stars1[1] "$ & $" %5.3f TA32[1] stars2[1] "$ & & $" %5.3f TA33[1] stars3[1] "$ & $" %5.3f TA34[1] stars4[1] "$ & & $" %5.3f TA35[1] stars5[1] "$ & $" %5.3f TA36[1] stars6[1] "$ & & $" %5.3f TA37[1] stars7[1] "$ & $" %5.3f TA38[1] stars8[1] "$ & & $" %5.3f TA39[1] stars9[1] "$ & $" %5.3f TA310[1] stars10[1] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA31[2] ")$ & $(" %5.3f TA32[2] ")$ & & $(" %5.3f TA33[2] ")$ & $(" %5.3f TA34[2] ")$ & & $(" %5.3f TA35[2] ")$ & $(" %5.3f TA36[2] ")$ && $ (" %5.3f TA37[2] ")$ & $(" %5.3f TA38[2] ")$ && $ (" %5.3f TA39[2] ")$ & $(" %5.3f TA310[2] ")$ \\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f TA31[3] stars1[3] "$ & $" %5.3f TA32[3] stars2[3] "$ & & $" %5.3f TA33[3] stars3[3] "$ & $" %5.3f TA34[3] stars4[3] "$ & & $" %5.3f TA35[3] stars5[3] "$ & $" %5.3f TA36[3] stars6[3] "$ & & $" %5.3f TA37[3] stars7[3] "$ & $" %5.3f TA38[3] stars8[3] "$ & & $" %5.3f TA39[3] stars9[3] "$ & $" %5.3f TA310[3] stars10[3] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA31[4] ")$ & $(" %5.3f TA32[4] ")$ & & $(" %5.3f TA33[4] ")$ & $(" %5.3f TA34[4] ")$ & & $(" %5.3f TA35[4] ")$ & $(" %5.3f TA36[4] ")$ && $ (" %5.3f TA37[4] ")$ & $(" %5.3f TA38[4] ")$ && $ (" %5.3f TA39[4] ")$ & $(" %5.3f TA310[4] ")$ \\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f TA31[5] stars1[5] "$ & $" %5.3f TA32[5] stars2[5] "$ & & $" %5.3f TA33[5] stars3[5] "$ & $" %5.3f TA34[5] stars4[5] "$ & & $" %5.3f TA35[5] stars5[5] "$ & $" %5.3f TA36[5] stars6[5] "$ & & $" %5.3f TA37[5] stars7[5] "$ & $" %5.3f TA38[5] stars8[5] "$ & & $" %5.3f TA39[5] stars9[5] "$ & $" %5.3f TA310[5] stars10[5] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA31[6] ")$ & $(" %5.3f TA32[6] ")$ & & $(" %5.3f TA33[6] ")$ & $(" %5.3f TA34[6] ")$ & & $(" %5.3f TA35[6] ")$ & $(" %5.3f TA36[6] ")$ && $ (" %5.3f TA37[6] ")$ & $(" %5.3f TA38[6] ")$ && $ (" %5.3f TA39[6] ")$ & $(" %5.3f TA310[6] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}Observations" "& $" %5.0f TA31[7] "$ & $" %5.0f TA32[7] "$ & & $" %5.0f TA33[7] "$ & $" %5.0f TA34[7] "$ & & $" %5.0f TA35[7] "$ & $" %5.0f TA36[7] "$ & & $ " %5.0f TA37[7] "$ & $ " %5.0f TA38[7] "$ & & $ " %5.0f TA39[7] "$ & $ " %5.0f TA310[7] "$ \\"
no di "\rule{0.3cm}{0.0cm}R$^2$ (within)" "& $" %5.3f TA31[8] "$ & $" %5.3f TA32[8] "$ & & $" %5.3f TA33[8] "$ & $" %5.3f TA34[8] "$ & & $" %5.3f TA35[8] "$ & $" %5.3f TA36[8] "$ & & $ " %5.3f TA37[8] "$ & $ " %5.3f TA38[8] "$ & & $ " %5.3f TA39[8] "$ & $ " %5.3f TA310[8] "$ \\"

no di "\cline{2-15}"
no di "\rule{0cm}{0.5cm}B) Mekong \& South\\"

clear
use "results\TA3b"

* Generates t statistics
gen t1=.
replace t1=TA31[1]/TA31[2] in 1
replace t1=TA31[3]/TA31[4] in 3
replace t1=TA31[5]/TA31[6] in 5
gen t2=.
replace t2=TA32[1]/TA32[2] in 1
replace t2=TA32[3]/TA32[4] in 3
replace t2=TA32[5]/TA32[6] in 5
gen t3=.
replace t3=TA33[1]/TA33[2] in 1
replace t3=TA33[3]/TA33[4] in 3
replace t3=TA33[5]/TA33[6] in 5
gen t4=.
replace t4=TA34[1]/TA34[2] in 1
replace t4=TA34[3]/TA34[4] in 3
replace t4=TA34[5]/TA34[6] in 5
gen t5=.
replace t5=TA35[1]/TA35[2] in 1
replace t5=TA35[3]/TA35[4] in 3
replace t5=TA35[5]/TA35[6] in 5
gen t6=.
replace t6=TA36[1]/TA36[2] in 1
replace t6=TA36[3]/TA36[4] in 3
replace t6=TA36[5]/TA36[6] in 5
gen t7=.
replace t7=TA37[1]/TA37[2] in 1
replace t7=TA37[3]/TA37[4] in 3
replace t7=TA37[5]/TA37[6] in 5
gen t8=.
replace t8=TA38[1]/TA38[2] in 1
replace t8=TA38[3]/TA38[4] in 3
replace t8=TA38[5]/TA38[6] in 5
gen t9=.
replace t9=TA39[1]/TA39[2] in 1
replace t9=TA39[3]/TA39[4] in 3
replace t9=TA39[5]/TA39[6] in 5
gen t10=.
replace t10=TA310[1]/TA310[2] in 1
replace t10=TA310[3]/TA310[4] in 3
replace t10=TA310[5]/TA310[6] in 5


* Generates the "starts"
foreach j of numlist 1/10 {
	gen str7 stars`j'=""
	replace stars`j'="^*" if abs(t`j')>=1.64 & abs(t`j')<1.96
	replace stars`j'="^{**}" if abs(t`j')>=1.96 & abs(t`j')<2.47
	replace stars`j'="^{***}" if abs(t`j')>=2.47
	}


no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f TA31[1] stars1[1] "$ & $" %5.3f TA32[1] stars2[1] "$ & & $" %5.3f TA33[1] stars3[1] "$ & $" %5.3f TA34[1] stars4[1] "$ & & $" %5.3f TA35[1] stars5[1] "$ & $" %5.3f TA36[1] stars6[1] "$ & & $" %5.3f TA37[1] stars7[1] "$ & $" %5.3f TA38[1] stars8[1] "$ & & $" %5.3f TA39[1] stars9[1] "$ & $" %5.3f TA310[1] stars10[1] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA31[2] ")$ & $(" %5.3f TA32[2] ")$ & & $(" %5.3f TA33[2] ")$ & $(" %5.3f TA34[2] ")$ & & $(" %5.3f TA35[2] ")$ & $(" %5.3f TA36[2] ")$ && $ (" %5.3f TA37[2] ")$ & $(" %5.3f TA38[2] ")$ && $ (" %5.3f TA39[2] ")$ & $(" %5.3f TA310[2] ")$ \\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f TA31[3] stars1[3] "$ & $" %5.3f TA32[3] stars2[3] "$ & & $" %5.3f TA33[3] stars3[3] "$ & $" %5.3f TA34[3] stars4[3] "$ & & $" %5.3f TA35[3] stars5[3] "$ & $" %5.3f TA36[3] stars6[3] "$ & & $" %5.3f TA37[3] stars7[3] "$ & $" %5.3f TA38[3] stars8[3] "$ & & $" %5.3f TA39[3] stars9[3] "$ & $" %5.3f TA310[3] stars10[3] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA31[4] ")$ & $(" %5.3f TA32[4] ")$ & & $(" %5.3f TA33[4] ")$ & $(" %5.3f TA34[4] ")$ & & $(" %5.3f TA35[4] ")$ & $(" %5.3f TA36[4] ")$ && $ (" %5.3f TA37[4] ")$ & $(" %5.3f TA38[4] ")$ && $ (" %5.3f TA39[4] ")$ & $(" %5.3f TA310[4] ")$ \\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f TA31[5] stars1[5] "$ & $" %5.3f TA32[5] stars2[5] "$ & & $" %5.3f TA33[5] stars3[5] "$ & $" %5.3f TA34[5] stars4[5] "$ & & $" %5.3f TA35[5] stars5[5] "$ & $" %5.3f TA36[5] stars6[5] "$ & & $" %5.3f TA37[5] stars7[5] "$ & $" %5.3f TA38[5] stars8[5] "$ & & $" %5.3f TA39[5] stars9[5] "$ & $" %5.3f TA310[5] stars10[5] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f TA31[6] ")$ & $(" %5.3f TA32[6] ")$ & & $(" %5.3f TA33[6] ")$ & $(" %5.3f TA34[6] ")$ & & $(" %5.3f TA35[6] ")$ & $(" %5.3f TA36[6] ")$ && $ (" %5.3f TA37[6] ")$ & $(" %5.3f TA38[6] ")$ && $ (" %5.3f TA39[6] ")$ & $(" %5.3f TA310[6] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}Observations" "& $" %5.0f TA31[7] "$ & $" %5.0f TA32[7] "$ & & $" %5.0f TA33[7] "$ & $" %5.0f TA34[7] "$ & & $" %5.0f TA35[7] "$ & $" %5.0f TA36[7] "$ & & $ " %5.0f TA37[7] "$ & $ " %5.0f TA38[7] "$ & & $ " %5.0f TA39[7] "$ & $ " %5.0f TA310[7] "$ \\"
no di "\rule{0.3cm}{0.0cm}R$^2$ (within)" "& $" %5.3f TA31[8] "$ & $" %5.3f TA32[8] "$ & & $" %5.3f TA33[8] "$ & $" %5.3f TA34[8] "$ & & $" %5.3f TA35[8] "$ & $" %5.3f TA36[8] "$ & & $ " %5.3f TA37[8] "$ & $ " %5.3f TA38[8] "$ & & $ " %5.3f TA39[8] "$ & $ " %5.3f TA310[8] "$ \\"

no di "\hline\hline"
no di "\end{tabular}"
no di "}"
no di "\par"
no di "\begin{minipage}{22.1cm}"
no di "\footnotesize\rule{0cm}{0.35cm}Note: Estimates of income sources:"
no di "catfish income, wage income, agricultural sales, agricultural"
no di "own-consumption, and miscellaneous farm income (poultry, livestock,"
no di "informal odd-job). The estimates show impacts on Mekong farms estimated with a quadratic polynomial in initial catfish shares."
no di "Panel A) is based on model (1) using only fishing farms in the Mekong. Panel B) is based on model (2) using fishing farms in both the Mekong and South provinces."
no di "Mekong 4 (M4) and Mekong 6 (M6) refer"
no di "to two sets of Mekong provinces that specialize in catfish"
no di "production: M4 includes An Giang, Can Tho, Dong Thap and Vinh Long,"
no di "and M6 adds Soc Trang and Tien Giang."
no di ""
no di "Robust standard errors within parenthesis: $*$, $**$, $***$,"
no di "significant at 10\%, 5\%, and 1\% level, respectively."
no di "\end{minipage}"
no di "\end{center}"
no di "\end{table}"

no di "\endlandscape"

log close

}


