
local controls0 "presentbias highdiscount riskaverse b1.gender b3.race i.year married haskids afqtn_s  collegemore finqa finka"
local controls2d "dpopbr4"
local controls2fe "gtotfs"
local controls1 "sdvoly ghpi_cs_s"
local controls1b "sdvoly dur_c_s ghpi_cs_s"
local controls4 "apply"
local controls3 "rnw_s ho_* w*debt"
local controls0fe "i.year married haskids"
local controls3g "gpopbr4"

capture drop F4
capture drop F4c 
capture drop F4o 
capture drop F2 
capture drop F21b
capture drop sample
set more off
sort case year
reg lconstf `controls0' `controls2' `controls4' `controls1b' `controls3g' [aw=weight]  if ps!=. & cross==1 & state!=. 

// how likely is it that you will be constrained in the future if you had high volatility now?

capture drop sample
gen sample=e(sample)
drop afqtn_s rnw_s dur_c_s  ghpi_cs_s

egen rnw_s=std(rnw) if sample==1
egen afqtn_s=std(afqtn) if sample==1
egen dur_c_s=std(dur_c) if sample==1
egen ghpi_cs_s = std(ghpi_cs) if sample==1
label var afqtn_s "AFQT Score "
label var rnw_s "Net Wealth"
label var dur_c_s "Change in Unemployment Rate, County"
label var ghpi_cs_s "HPI Growth Rate, County"

est clear
sort case year
capture drop plconstf_*
reghdfe lconstf `controls0' `controls3' `controls1b' if year>=2004 & sample==1 [pw=weight],  cluster(case) absorb(age state)  keepsingletons   // how likely is it that you will be constrained in the future if you had high volatility now?
est store y1

reghdfe lconstf `controls0' `controls3' `controls1b' `controls4' `controls2fe' if year>=2004 & sample==1 [pw=weight],  cluster(case) absorb(age state)  keepsingletons 
est store y2
predict plconstf_jsfs if e(sample)
testparm `controls4' `controls2fe'


reghdfe lconstf `controls0' `controls3' `controls1b' `controls4' `controls2d' if year>=2004 & sample==1 [pw=weight],  cluster(case) absorb(age state)  keepsingletons 
est store y2d
predict plconstf_d if e(sample)
testparm `controls4' `controls2d'

reghdfe lconstf `controls0' `controls3' `controls1b' `controls4' `controls3g' if year>=2004 & sample==1 [pw=weight],  cluster(case) absorb(age state)  keepsingletons 
est store y2g
predict plconstf_g if e(sample)
testparm `controls4' `controls3g'

reghdfe lconstf `controls0fe' `controls3' `controls1b' `controls4' `controls2fe' if year>=2004 & sample==1 [pw=weight],  cluster(case) absorb(age state case)  keepsingletons 
est store y5 
testparm `controls4' `controls2fe' 
predict plconstf_fefs if e(sample)

reghdfe lconstf `controls0fe' `controls3' `controls1b' `controls4' `controls3g' if year>=2004 & sample==1 [pw=weight],  cluster(case) absorb(age state case)  keepsingletons 
est store y5g
testparm `controls4' `controls3g' 
predict plconstf_gfe if e(sample)

reghdfe lconstf `controls0fe' `controls3' `controls1b' `controls4' `controls2d' if year>=2004 & sample==1 [pw=weight],  cluster(case) absorb(age state case)  keepsingletons 
est store y5d
testparm `controls4' `controls2d' 
predict plconstf_dfe if e(sample)


#delimit ; 
estout y1 y2g y5g  using "table6a_g4.tex", replace style(tex)   starlevels( * 0.1 ** 0.05 *** 0.01) 
cells(b(star fmt(%5.3fc)) se(par fmt(%5.3fc))) stats(N r2, fmt(%5.0fc %5.2f) labels("Observations" "R squared"))  varwidth(42) modelwidth(8)
mlabels((1) (2) (3)) collabels(none)
varlabels(_cons "Constant")  msign(--)    label 
order(presentbias highdiscount riskaverse married haskids afqtn_s collegemore finqa finka sdvoly dur_c_s ghpi_cs_s rnw_s ho_* w*debt 2008.year 2012.year  applycred L4.leftover  l2sdvoly popsh_branch1k gpopbr gpopbr4 gtotfs4 rel_finc)
keep(presentbias highdiscount riskaverse married haskids afqtn_s  collegemore finqa finka sdvoly dur_c_s ghpi_cs_s rnw_s ho_* w*debt applycred gpopbr4)
wrap
prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}  \vspace*{1ex} \begin{tabular}{l*{@M}{c}} \toprule") 
posthead("\midrule ") prefoot("\addlinespace ") 
postfoot("\bottomrule " "\addlinespace " "\end{tabular}"
"\parbox[1]{6.1in}{\footnotesize {\em Notes:} The dependent variable is a dummy variable equal 
to one if the respondent  was denied credit in the last 5 years, or was discouraged from applying 
because she thought she would be denied credit, and zero otherwise.  L4 and L2 denote four and two-year lags.
All regressions also control for age, race, gender, time and state fixed effects. Robust standard errors 
(in parentheses) clustered at the individual level. ***(**)[*] significant at the 1(5)[10] percent level.} ")   ;	
#delimit cr

rename plconstf_g plconstf
