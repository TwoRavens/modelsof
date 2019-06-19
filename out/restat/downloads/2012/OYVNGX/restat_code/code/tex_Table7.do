clear
set more off

use "results\T7a"

* Generates t statistics
gen t1=.
replace t1=T71[1]/T71[2] in 1
replace t1=T71[3]/T71[4] in 3
replace t1=T71[5]/T71[6] in 5
gen t2=.
replace t2=T72[1]/T72[2] in 1
replace t2=T72[3]/T72[4] in 3
replace t2=T72[5]/T72[6] in 5
gen t3=.
replace t3=T73[1]/T73[2] in 1
replace t3=T73[3]/T73[4] in 3
replace t3=T73[5]/T73[6] in 5
gen t4=.
replace t4=T74[1]/T74[2] in 1
replace t4=T74[3]/T74[4] in 3
replace t4=T74[5]/T74[6] in 5
gen t5=.
replace t5=T75[1]/T75[2] in 1
replace t5=T75[3]/T75[4] in 3
replace t5=T75[5]/T75[6] in 5
gen t6=.
replace t6=T76[1]/T76[2] in 1
replace t6=T76[3]/T76[4] in 3
replace t6=T76[5]/T76[6] in 5
gen t7=.
replace t7=T77[1]/T77[2] in 1
replace t7=T77[3]/T77[4] in 3
replace t7=T77[5]/T77[6] in 5
gen t8=.
replace t8=T78[1]/T78[2] in 1
replace t8=T78[3]/T78[4] in 3
replace t8=T78[5]/T78[6] in 5
gen t9=.
replace t9=T79[1]/T79[2] in 1
replace t9=T79[3]/T79[4] in 3
replace t9=T79[5]/T79[6] in 5
gen t10=.
replace t10=T710[1]/T710[2] in 1
replace t10=T710[3]/T710[4] in 3
replace t10=T710[5]/T710[6] in 5


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
log using "results\Table7.tex", text replace


no di "\landscape"
no di "\begin{table}[t]"
no di "\refstepcounter{table}\label{tab_incomesources}"
no di "\par"
no di "\begin{center}"
no di "{\small"
no di "\begin{tabular}{lccp{0.1cm}ccp{0.1cm}ccp{0.1cm}ccp{0.1cm}cc}"
no di "\multicolumn{15}{c}{Table 7} \\"
no di "\multicolumn{15}{c}{Impact of Anti-Dumping on Income Sources for Mekong Farms} \\"
no di "\multicolumn{15}{c}{All Farms - Mekong and Mekong \& South Samples} \\"
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


no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f T71[1] stars1[1] "$ & $" %5.3f T72[1] stars2[1] "$ & & $" %5.3f T73[1] stars3[1] "$ & $" %5.3f T74[1] stars4[1] "$ & & $" %5.3f T75[1] stars5[1] "$ & $" %5.3f T76[1] stars6[1] "$ & & $" %5.3f T77[1] stars7[1] "$ & $" %5.3f T78[1] stars8[1] "$ & & $" %5.3f T79[1] stars9[1] "$ & $" %5.3f T710[1] stars10[1] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T71[2] ")$ & $(" %5.3f T72[2] ")$ & & $(" %5.3f T73[2] ")$ & $(" %5.3f T74[2] ")$ & & $(" %5.3f T75[2] ")$ & $(" %5.3f T76[2] ")$ && $ (" %5.3f T77[2] ")$ & $(" %5.3f T78[2] ")$ && $ (" %5.3f T79[2] ")$ & $(" %5.3f T710[2] ")$ \\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f T71[3] stars1[3] "$ & $" %5.3f T72[3] stars2[3] "$ & & $" %5.3f T73[3] stars3[3] "$ & $" %5.3f T74[3] stars4[3] "$ & & $" %5.3f T75[3] stars5[3] "$ & $" %5.3f T76[3] stars6[3] "$ & & $" %5.3f T77[3] stars7[3] "$ & $" %5.3f T78[3] stars8[3] "$ & & $" %5.3f T79[3] stars9[3] "$ & $" %5.3f T710[3] stars10[3] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T71[4] ")$ & $(" %5.3f T72[4] ")$ & & $(" %5.3f T73[4] ")$ & $(" %5.3f T74[4] ")$ & & $(" %5.3f T75[4] ")$ & $(" %5.3f T76[4] ")$ && $ (" %5.3f T77[4] ")$ & $(" %5.3f T78[4] ")$ && $ (" %5.3f T79[4] ")$ & $(" %5.3f T710[4] ")$ \\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f T71[5] stars1[5] "$ & $" %5.3f T72[5] stars2[5] "$ & & $" %5.3f T73[5] stars3[5] "$ & $" %5.3f T74[5] stars4[5] "$ & & $" %5.3f T75[5] stars5[5] "$ & $" %5.3f T76[5] stars6[5] "$ & & $" %5.3f T77[5] stars7[5] "$ & $" %5.3f T78[5] stars8[5] "$ & & $" %5.3f T79[5] stars9[5] "$ & $" %5.3f T710[5] stars10[5] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T71[6] ")$ & $(" %5.3f T72[6] ")$ & & $(" %5.3f T73[6] ")$ & $(" %5.3f T74[6] ")$ & & $(" %5.3f T75[6] ")$ & $(" %5.3f T76[6] ")$ && $ (" %5.3f T77[6] ")$ & $(" %5.3f T78[6] ")$ && $ (" %5.3f T79[6] ")$ & $(" %5.3f T710[6] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}Observations" "& $" %5.0f T71[7] "$ & $" %5.0f T72[7] "$ & & $" %5.0f T73[7] "$ & $" %5.0f T74[7] "$ & & $" %5.0f T75[7] "$ & $" %5.0f T76[7] "$ & & $ " %5.0f T77[7] "$ & $ " %5.0f T78[7] "$ & & $ " %5.0f T79[7] "$ & $ " %5.0f T710[7] "$ \\"
no di "\rule{0.3cm}{0.0cm}R$^2$ (within)" "& $" %5.3f T71[8] "$ & $" %5.3f T72[8] "$ & & $" %5.3f T73[8] "$ & $" %5.3f T74[8] "$ & & $" %5.3f T75[8] "$ & $" %5.3f T76[8] "$ & & $ " %5.3f T77[8] "$ & $ " %5.3f T78[8] "$ & & $ " %5.3f T79[8] "$ & $ " %5.3f T710[8] "$ \\"

no di "\cline{2-15}"
no di "\rule{0cm}{0.5cm}B) Mekong \& South\\"

clear
use "results\T7b"

* Generates t statistics
gen t1=.
replace t1=T71[1]/T71[2] in 1
replace t1=T71[3]/T71[4] in 3
replace t1=T71[5]/T71[6] in 5
gen t2=.
replace t2=T72[1]/T72[2] in 1
replace t2=T72[3]/T72[4] in 3
replace t2=T72[5]/T72[6] in 5
gen t3=.
replace t3=T73[1]/T73[2] in 1
replace t3=T73[3]/T73[4] in 3
replace t3=T73[5]/T73[6] in 5
gen t4=.
replace t4=T74[1]/T74[2] in 1
replace t4=T74[3]/T74[4] in 3
replace t4=T74[5]/T74[6] in 5
gen t5=.
replace t5=T75[1]/T75[2] in 1
replace t5=T75[3]/T75[4] in 3
replace t5=T75[5]/T75[6] in 5
gen t6=.
replace t6=T76[1]/T76[2] in 1
replace t6=T76[3]/T76[4] in 3
replace t6=T76[5]/T76[6] in 5
gen t7=.
replace t7=T77[1]/T77[2] in 1
replace t7=T77[3]/T77[4] in 3
replace t7=T77[5]/T77[6] in 5
gen t8=.
replace t8=T78[1]/T78[2] in 1
replace t8=T78[3]/T78[4] in 3
replace t8=T78[5]/T78[6] in 5
gen t9=.
replace t9=T79[1]/T79[2] in 1
replace t9=T79[3]/T79[4] in 3
replace t9=T79[5]/T79[6] in 5
gen t10=.
replace t10=T710[1]/T710[2] in 1
replace t10=T710[3]/T710[4] in 3
replace t10=T710[5]/T710[6] in 5


* Generates the "starts"
foreach j of numlist 1/10 {
	gen str7 stars`j'=""
	replace stars`j'="^*" if abs(t`j')>=1.64 & abs(t`j')<1.96
	replace stars`j'="^{**}" if abs(t`j')>=1.96 & abs(t`j')<2.47
	replace stars`j'="^{***}" if abs(t`j')>=2.47
	}


no di "\rule{0.3cm}{0.0cm}Low Exposure" "& $" %5.3f T71[1] stars1[1] "$ & $" %5.3f T72[1] stars2[1] "$ & & $" %5.3f T73[1] stars3[1] "$ & $" %5.3f T74[1] stars4[1] "$ & & $" %5.3f T75[1] stars5[1] "$ & $" %5.3f T76[1] stars6[1] "$ & & $" %5.3f T77[1] stars7[1] "$ & $" %5.3f T78[1] stars8[1] "$ & & $" %5.3f T79[1] stars9[1] "$ & $" %5.3f T710[1] stars10[1] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T71[2] ")$ & $(" %5.3f T72[2] ")$ & & $(" %5.3f T73[2] ")$ & $(" %5.3f T74[2] ")$ & & $(" %5.3f T75[2] ")$ & $(" %5.3f T76[2] ")$ && $ (" %5.3f T77[2] ")$ & $(" %5.3f T78[2] ")$ && $ (" %5.3f T79[2] ")$ & $(" %5.3f T710[2] ")$ \\"
no di "\rule{0.3cm}{0.0cm}Mean Exposure" "& $" %5.3f T71[3] stars1[3] "$ & $" %5.3f T72[3] stars2[3] "$ & & $" %5.3f T73[3] stars3[3] "$ & $" %5.3f T74[3] stars4[3] "$ & & $" %5.3f T75[3] stars5[3] "$ & $" %5.3f T76[3] stars6[3] "$ & & $" %5.3f T77[3] stars7[3] "$ & $" %5.3f T78[3] stars8[3] "$ & & $" %5.3f T79[3] stars9[3] "$ & $" %5.3f T710[3] stars10[3] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T71[4] ")$ & $(" %5.3f T72[4] ")$ & & $(" %5.3f T73[4] ")$ & $(" %5.3f T74[4] ")$ & & $(" %5.3f T75[4] ")$ & $(" %5.3f T76[4] ")$ && $ (" %5.3f T77[4] ")$ & $(" %5.3f T78[4] ")$ && $ (" %5.3f T79[4] ")$ & $(" %5.3f T710[4] ")$ \\"
no di "\rule{0.3cm}{0.0cm}High Exposure" "& $" %5.3f T71[5] stars1[5] "$ & $" %5.3f T72[5] stars2[5] "$ & & $" %5.3f T73[5] stars3[5] "$ & $" %5.3f T74[5] stars4[5] "$ & & $" %5.3f T75[5] stars5[5] "$ & $" %5.3f T76[5] stars6[5] "$ & & $" %5.3f T77[5] stars7[5] "$ & $" %5.3f T78[5] stars8[5] "$ & & $" %5.3f T79[5] stars9[5] "$ & $" %5.3f T710[5] stars10[5] "$ \\"
no di "\rule{0.3cm}{0.0cm}" "& $(" %5.3f T71[6] ")$ & $(" %5.3f T72[6] ")$ & & $(" %5.3f T73[6] ")$ & $(" %5.3f T74[6] ")$ & & $(" %5.3f T75[6] ")$ & $(" %5.3f T76[6] ")$ && $ (" %5.3f T77[6] ")$ & $(" %5.3f T78[6] ")$ && $ (" %5.3f T79[6] ")$ & $(" %5.3f T710[6] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "\rule{0.3cm}{0.0cm}Observations" "& $" %5.0f T71[7] "$ & $" %5.0f T72[7] "$ & & $" %5.0f T73[7] "$ & $" %5.0f T74[7] "$ & & $" %5.0f T75[7] "$ & $" %5.0f T76[7] "$ & & $ " %5.0f T77[7] "$ & $ " %5.0f T78[7] "$ & & $ " %5.0f T79[7] "$ & $ " %5.0f T710[7] "$ \\"
no di "\rule{0.3cm}{0.0cm}R$^2$ (within)" "& $" %5.3f T71[8] "$ & $" %5.3f T72[8] "$ & & $" %5.3f T73[8] "$ & $" %5.3f T74[8] "$ & & $" %5.3f T75[8] "$ & $" %5.3f T76[8] "$ & & $ " %5.3f T77[8] "$ & $ " %5.3f T78[8] "$ & & $ " %5.3f T79[8] "$ & $ " %5.3f T710[8] "$ \\"

no di "\hline\hline"
no di "\end{tabular}"
no di "}"
no di "\par"
no di "\begin{minipage}{22.1cm}"
no di "\footnotesize\rule{0cm}{0.35cm}Note: Estimates of income sources:"
no di "catfish income, wage income, agricultural sales, agricultural"
no di "own-consumption, and miscellaneous farm income (poultry, livestock,"
no di "informal odd-job). The estimates show impacts on Mekong farms estimated with a quadratic polynomial in initial catfish shares. Panel A) is based on model (1) using all Mekong observations,"
no di "except for the catfish income variable (which uses only fishing farms). Panel B) is based on model (2) using all Mekong and South observations,"
no di "except for the catfish income variable (which uses only fishing farms). See Only Appendix for results using only fishing farms. Mekong 4 (M4) and Mekong 6 (M6) refer"
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


