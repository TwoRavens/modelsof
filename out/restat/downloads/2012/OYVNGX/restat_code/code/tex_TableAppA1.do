clear
set more off

use "results\TAppA1a"

* Generates t statistics
gen t1=.
replace t1=TAppA11[1]/TAppA11[2] in 1
replace t1=TAppA11[3]/TAppA11[4] in 3
replace t1=TAppA11[5]/TAppA11[6] in 5
gen t2=.
replace t2=TAppA12[1]/TAppA12[2] in 1
replace t2=TAppA12[3]/TAppA12[4] in 3
replace t2=TAppA12[5]/TAppA12[6] in 5
gen t3=.
replace t3=TAppA13[1]/TAppA13[2] in 1
replace t3=TAppA13[3]/TAppA13[4] in 3
replace t3=TAppA13[5]/TAppA13[6] in 5
gen t4=.
replace t4=TAppA14[1]/TAppA14[2] in 1
replace t4=TAppA14[3]/TAppA14[4] in 3
replace t4=TAppA14[5]/TAppA14[6] in 5
gen t5=.
replace t5=TAppA15[1]/TAppA15[2] in 1
replace t5=TAppA15[3]/TAppA15[4] in 3
replace t5=TAppA15[5]/TAppA15[6] in 5
gen t6=.
replace t6=TAppA16[1]/TAppA16[2] in 1
replace t6=TAppA16[3]/TAppA16[4] in 3
replace t6=TAppA16[5]/TAppA16[6] in 5
gen t7=.
replace t7=TAppA17[1]/TAppA17[2] in 1
replace t7=TAppA17[3]/TAppA17[4] in 3
replace t7=TAppA17[5]/TAppA17[6] in 5
gen t8=.
replace t8=TAppA18[1]/TAppA18[2] in 1
replace t8=TAppA18[3]/TAppA18[4] in 3
replace t8=TAppA18[5]/TAppA18[6] in 5
gen t9=.
replace t9=TAppA19[1]/TAppA19[2] in 1
replace t9=TAppA19[3]/TAppA19[4] in 3
replace t9=TAppA19[5]/TAppA19[6] in 5
gen t10=.
replace t10=TAppA110[1]/TAppA110[2] in 1
replace t10=TAppA110[3]/TAppA110[4] in 3
replace t10=TAppA110[5]/TAppA110[6] in 5


* Generates the "starts"
foreach j of numlist 1/10 {
	gen str7 stars`j'=""
	replace stars`j'="^*" if abs(t`j')>=1.64 & abs(t`j')<1.96
	replace stars`j'="^{**}" if abs(t`j')>=1.96 & abs(t`j')<2.47
	replace stars`j'="^{***}" if abs(t`j')>=2.47
	}



qui { 
set linesize 250
capture log close
log using "results\TableAppA1.tex", text replace



no di "\landscape"
no di "\begin{table}[t]"
no di "\refstepcounter{table}\label{tab_alternativesample_app}"
no di "\par"
no di "\begin{center}"
no di "{\small"
no di "\begin{tabular}{lccp{0.005cm}ccp{0.005cm}ccp{0.005cm}ccp{0.005cm}cc}"
no di "\multicolumn{15}{c}{Table A1} \\"
no di "\multicolumn{15}{c}{Impact on Net Income: Alternative Samples} \\"
no di "\multicolumn{15}{c}{Mekong \& South Provinces: Impacts on Mekong Farms} \\"
no di "\hline\hline"
no di "\rule{0cm}{0.5cm} & \multicolumn{2}{c}{Catfish} &  & \multicolumn{2}{c}{Wage} &  & \multicolumn{2}{c}{Agric.} &  & \multicolumn{2}{c}{Agric.}& & \multicolumn{2}{c}{Misc. Farm} \\"
no di " & \multicolumn{2}{c}{Income} &  & \multicolumn{2}{c}{Income} &  & \multicolumn{2}{c}{Sales} &  & \multicolumn{2}{c}{Own}& & \multicolumn{2}{c}{Income} \\"
no di "\cline{2-3}\cline{5-6}\cline{8-9}\cline{11-12}\cline{14-15}"
no di "\rule{0cm}{0.5cm} & M4 & M6 &  & M4 & M6 &  & M4 & M6 &  & M4 & M6 &  & M4 & M6 \\"
no di "& (1) & (2) &  & (3) & (4) &  & (5) & (6) &  & (7) & (8) & & (9) & (10)\\ \hline"
no di "\rule{0.0cm}{0.5cm}Low Exposure" "& $" %5.3f TAppA11[1] stars1[1] "$ & $" %5.3f TAppA12[1] stars2[1] "$ & & $" %5.3f TAppA13[1] stars3[1] "$ & $" %5.3f TAppA14[1] stars4[1] "$ & & $" %5.3f TAppA15[1] stars5[1] "$ & $" %5.3f TAppA16[1] stars6[1] "$ & & $" %5.3f TAppA17[1] stars7[1] "$ & $" %5.3f TAppA18[1] stars8[1] "$ & & $" %5.3f TAppA19[1] stars9[1] "$ & $" %5.3f TAppA110[1] stars10[1] "$ \\"
no di "& $(" %5.3f TAppA11[2] ")$ & $(" %5.3f TAppA12[2] ")$ & & $(" %5.3f TAppA13[2] ")$ & $(" %5.3f TAppA14[2] ")$ & & $(" %5.3f TAppA15[2] ")$ & $(" %5.3f TAppA16[2] ")$ && $ (" %5.3f TAppA17[2] ")$ & $(" %5.3f TAppA18[2] ")$ && $ (" %5.3f TAppA19[2] ")$ & $(" %5.3f TAppA110[2] ")$ \\"
no di "Mean Exposure" "& $" %5.3f TAppA11[3] stars1[3] "$ & $" %5.3f TAppA12[3] stars2[3] "$ & & $" %5.3f TAppA13[3] stars3[3] "$ & $" %5.3f TAppA14[3] stars4[3] "$ & & $" %5.3f TAppA15[3] stars5[3] "$ & $" %5.3f TAppA16[3] stars6[3] "$ & & $" %5.3f TAppA17[3] stars7[3] "$ & $" %5.3f TAppA18[3] stars8[3] "$ & & $" %5.3f TAppA19[3] stars9[3] "$ & $" %5.3f TAppA110[3] stars10[3] "$ \\"
no di  "& $(" %5.3f TAppA11[4] ")$ & $(" %5.3f TAppA12[4] ")$ & & $(" %5.3f TAppA13[4] ")$ & $(" %5.3f TAppA14[4] ")$ & & $(" %5.3f TAppA15[4] ")$ & $(" %5.3f TAppA16[4] ")$ && $ (" %5.3f TAppA17[4] ")$ & $(" %5.3f TAppA18[4] ")$ && $ (" %5.3f TAppA19[4] ")$ & $(" %5.3f TAppA110[4] ")$ \\"
no di "High Exposure" "& $" %5.3f TAppA11[5] stars1[5] "$ & $" %5.3f TAppA12[5] stars2[5] "$ & & $" %5.3f TAppA13[5] stars3[5] "$ & $" %5.3f TAppA14[5] stars4[5] "$ & & $" %5.3f TAppA15[5] stars5[5] "$ & $" %5.3f TAppA16[5] stars6[5] "$ & & $" %5.3f TAppA17[5] stars7[5] "$ & $" %5.3f TAppA18[5] stars8[5] "$ & & $" %5.3f TAppA19[5] stars9[5] "$ & $" %5.3f TAppA110[5] stars10[5] "$ \\"
no di  "& $(" %5.3f TAppA11[6] ")$ & $(" %5.3f TAppA12[6] ")$ & & $(" %5.3f TAppA13[6] ")$ & $(" %5.3f TAppA14[6] ")$ & & $(" %5.3f TAppA15[6] ")$ & $(" %5.3f TAppA16[6] ")$ && $ (" %5.3f TAppA17[6] ")$ & $(" %5.3f TAppA18[6] ")$ && $ (" %5.3f TAppA19[6] ")$ & $(" %5.3f TAppA110[6] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "Observations" "& $" %5.0f TAppA11[7] "$ & $" %5.0f TAppA12[7] "$ & & $" %5.0f TAppA13[7] "$ & $" %5.0f TAppA14[7] "$ & & $" %5.0f TAppA15[7] "$ & $" %5.0f TAppA16[7] "$ & & $ " %5.0f TAppA17[7] "$ & $ " %5.0f TAppA18[7] "$ & & $ " %5.0f TAppA19[7] "$ & $ " %5.0f TAppA110[7] "$ \\"
no di "R$^2$ (within)" "& $" %5.3f TAppA11[8] "$ & $" %5.3f TAppA12[8] "$ & & $" %5.3f TAppA13[8] "$ & $" %5.3f TAppA14[8] "$ & & $" %5.3f TAppA15[8] "$ & $" %5.3f TAppA16[8] "$ & & $ " %5.3f TAppA17[8] "$ & $ " %5.3f TAppA18[8] "$ & & $ " %5.3f TAppA19[8] "$ & $ " %5.3f TAppA110[8] "$ \\"

no di " \hline"
no di "\rule{0cm}{0.5cm} & \multicolumn{2}{c}{Hours} &  & \multicolumn{2}{c}{Catfish} &  & \multicolumn{2}{c}{Total} &  & \multicolumn{2}{c}{Agric.}& & \multicolumn{2}{c}{Misc. Farm} \\"
no di " & \multicolumn{2}{c}{Worked} &  & \multicolumn{2}{c}{Investment} &  & \multicolumn{2}{c}{Investment} &  & \multicolumn{2}{c}{Investment}& & \multicolumn{2}{c}{Investment} \\"
no di "\cline{2-3}\cline{5-6}\cline{8-9}\cline{11-12}\cline{14-15}"
no di "\rule{0cm}{0.5cm} & M4 & M6 &  & M4 & M6 &  & M4 & M6 &  & M4 & M6 &  & M4 & M6 \\"
no di "& (1) & (2) &  & (3) & (4) &  & (5) & (6) &  & (7) & (8)& & (9) & (10) \\ \hline"

clear
use "results\TAppA1b"

* Generates t statistics
gen t1=.
replace t1=TAppA11[1]/TAppA11[2] in 1
replace t1=TAppA11[3]/TAppA11[4] in 3
replace t1=TAppA11[5]/TAppA11[6] in 5
gen t2=.
replace t2=TAppA12[1]/TAppA12[2] in 1
replace t2=TAppA12[3]/TAppA12[4] in 3
replace t2=TAppA12[5]/TAppA12[6] in 5
gen t3=.
replace t3=TAppA13[1]/TAppA13[2] in 1
replace t3=TAppA13[3]/TAppA13[4] in 3
replace t3=TAppA13[5]/TAppA13[6] in 5
gen t4=.
replace t4=TAppA14[1]/TAppA14[2] in 1
replace t4=TAppA14[3]/TAppA14[4] in 3
replace t4=TAppA14[5]/TAppA14[6] in 5
gen t5=.
replace t5=TAppA15[1]/TAppA15[2] in 1
replace t5=TAppA15[3]/TAppA15[4] in 3
replace t5=TAppA15[5]/TAppA15[6] in 5
gen t6=.
replace t6=TAppA16[1]/TAppA16[2] in 1
replace t6=TAppA16[3]/TAppA16[4] in 3
replace t6=TAppA16[5]/TAppA16[6] in 5
gen t7=.
replace t7=TAppA17[1]/TAppA17[2] in 1
replace t7=TAppA17[3]/TAppA17[4] in 3
replace t7=TAppA17[5]/TAppA17[6] in 5
gen t8=.
replace t8=TAppA18[1]/TAppA18[2] in 1
replace t8=TAppA18[3]/TAppA18[4] in 3
replace t8=TAppA18[5]/TAppA18[6] in 5
gen t9=.
replace t9=TAppA19[1]/TAppA19[2] in 1
replace t9=TAppA19[3]/TAppA19[4] in 3
replace t9=TAppA19[5]/TAppA19[6] in 5
gen t10=.
replace t10=TAppA110[1]/TAppA110[2] in 1
replace t10=TAppA110[3]/TAppA110[4] in 3
replace t10=TAppA110[5]/TAppA110[6] in 5


* Generates the "starts"
foreach j of numlist 1/10 {
	gen str7 stars`j'=""
	replace stars`j'="^*" if abs(t`j')>=1.64 & abs(t`j')<1.96
	replace stars`j'="^{**}" if abs(t`j')>=1.96 & abs(t`j')<2.47
	replace stars`j'="^{***}" if abs(t`j')>=2.47
	}


no di "\rule{0.0cm}{0.5cm}Low Exposure" "& $" %5.3f TAppA11[1] stars1[1] "$ & $" %5.3f TAppA12[1] stars2[1] "$ & & $" %5.3f TAppA13[1] stars3[1] "$ & $" %5.3f TAppA14[1] stars4[1] "$ & & $" %5.3f TAppA15[1] stars5[1] "$ & $" %5.3f TAppA16[1] stars6[1] "$ & & $" %5.3f TAppA17[1] stars7[1] "$ & $" %5.3f TAppA18[1] stars8[1] "$ & & $" %5.3f TAppA19[1] stars9[1] "$ & $" %5.3f TAppA110[1] stars10[1] "$ \\"
no di "& $(" %5.3f TAppA11[2] ")$ & $(" %5.3f TAppA12[2] ")$ & & $(" %5.3f TAppA13[2] ")$ & $(" %5.3f TAppA14[2] ")$ & & $(" %5.3f TAppA15[2] ")$ & $(" %5.3f TAppA16[2] ")$ && $ (" %5.3f TAppA17[2] ")$ & $(" %5.3f TAppA18[2] ")$ && $ (" %5.3f TAppA19[2] ")$ & $(" %5.3f TAppA110[2] ")$ \\"
no di "Mean Exposure" "& $" %5.3f TAppA11[3] stars1[3] "$ & $" %5.3f TAppA12[3] stars2[3] "$ & & $" %5.3f TAppA13[3] stars3[3] "$ & $" %5.3f TAppA14[3] stars4[3] "$ & & $" %5.3f TAppA15[3] stars5[3] "$ & $" %5.3f TAppA16[3] stars6[3] "$ & & $" %5.3f TAppA17[3] stars7[3] "$ & $" %5.3f TAppA18[3] stars8[3] "$ & & $" %5.3f TAppA19[3] stars9[3] "$ & $" %5.3f TAppA110[3] stars10[3] "$ \\"
no di "& $(" %5.3f TAppA11[4] ")$ & $(" %5.3f TAppA12[4] ")$ & & $(" %5.3f TAppA13[4] ")$ & $(" %5.3f TAppA14[4] ")$ & & $(" %5.3f TAppA15[4] ")$ & $(" %5.3f TAppA16[4] ")$ && $ (" %5.3f TAppA17[4] ")$ & $(" %5.3f TAppA18[4] ")$ && $ (" %5.3f TAppA19[4] ")$ & $(" %5.3f TAppA110[4] ")$ \\"
no di "High Exposure" "& $" %5.3f TAppA11[5] stars1[5] "$ & $" %5.3f TAppA12[5] stars2[5] "$ & & $" %5.3f TAppA13[5] stars3[5] "$ & $" %5.3f TAppA14[5] stars4[5] "$ & & $" %5.3f TAppA15[5] stars5[5] "$ & $" %5.3f TAppA16[5] stars6[5] "$ & & $" %5.3f TAppA17[5] stars7[5] "$ & $" %5.3f TAppA18[5] stars8[5] "$ & & $" %5.3f TAppA19[5] stars9[5] "$ & $" %5.3f TAppA110[5] stars10[5] "$ \\"
no di "& $(" %5.3f TAppA11[6] ")$ & $(" %5.3f TAppA12[6] ")$ & & $(" %5.3f TAppA13[6] ")$ & $(" %5.3f TAppA14[6] ")$ & & $(" %5.3f TAppA15[6] ")$ & $(" %5.3f TAppA16[6] ")$ && $ (" %5.3f TAppA17[6] ")$ & $(" %5.3f TAppA18[6] ")$ && $ (" %5.3f TAppA19[6] ")$ & $(" %5.3f TAppA110[6] ")$ \\"
no di "&  &  &  &  &  &  &  &  \\"
no di "Observations" "& $" %5.0f TAppA11[7] "$ & $" %5.0f TAppA12[7] "$ & & $" %5.0f TAppA13[7] "$ & $" %5.0f TAppA14[7] "$ & & $" %5.0f TAppA15[7] "$ & $" %5.0f TAppA16[7] "$ & & $ " %5.0f TAppA17[7] "$ & $ " %5.0f TAppA18[7] "$ & & $ " %5.0f TAppA19[7] "$ & $ " %5.0f TAppA110[7] "$ \\"
no di "R$^2$ (within)" "& $" %5.3f TAppA11[8] "$ & $" %5.3f TAppA12[8] "$ & & $" %5.3f TAppA13[8] "$ & $" %5.3f TAppA14[8] "$ & & $" %5.3f TAppA15[8] "$ & $" %5.3f TAppA16[8] "$ & & $ " %5.3f TAppA17[8] "$ & $ " %5.3f TAppA18[8] "$ & & $ " %5.3f TAppA19[8] "$ & $ " %5.3f TAppA110[8] "$ \\"

no di "\hline\hline"
no di "\end{tabular}"
no di "}"
no di "\par"
no di "\begin{minipage}{22.3cm}"
no di "\footnotesize\rule{0cm}{0.35cm}Note: Impacts on net income based on model"
no di "(2) in text with a quadratic polynomial in initial catfish shares"
no di "using all households in the Mekong and South provinces. Sample size correspond"
no di "to the regressions for the outcomes listed in the columns (e.g., catfish income"
no di "in M4 in column 1, catfish income in M6 in column 2 and so on)."
no di " "
no di "Robust standard errors within parenthesis: $*$, $**$ and $***$ indicate"
no di "significance at 10\%, 5\%, and 1\% level, respectively."
no di "\end{minipage}"
no di "\end{center}"
no di "\end{table}"

no di "\endlandscape"

log close

}


