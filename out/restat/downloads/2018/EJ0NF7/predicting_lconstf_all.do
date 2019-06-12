set more off

capture drop sdvoly
capture drop rnw_s
capture drop dur_c_s
capture drop ghpi_cs_s
capture drop afqtn_s

egen sdvoly = std(job_shock) if samplemm==1
egen rnw_s=std(rnw) if samplemm==1
egen dur_c_s=std(dur_c) if samplemm==1
egen ghpi_cs_s = std(ghpi_cs) if samplemm==1
egen afqtn_s=std(afqtn) if samplemm==1
label var sdvoly "Job Shock"
label var rnw_s "Net Wealth"
label var dur_c "Change in Unemployment Rate, County"
label var ghpi_cs_s "HPI Growth Rate, County"
label var gpopbr4 "Growth in Branch Density, County"
label var afqtn_s "AFQT Score"

local controls0 "presentbias highdiscount riskaverse b1.gender b3.race i.year married haskids afqtn_s  collegemore finqa finka"
local controls1b "sdvoly dur_c_s ghpi_cs_s"
local controls4 "apply"
local controls3 "rnw_s ho_* w*debt"
local controls0fe "i.year married haskids"
local controls2 "gpopbr4"


set more off
sort case year
reg lconstf `controls0' `controls1b' `controls4' `controls3' `controls2' [aw=weight]  if samplemm==1
est store y1
testparm `controls4' `controls2' 
predict plconstf_all if e(sample)
gen sampleaa=e(sample)

#delimit ; 
estout y1 ,  starlevels( * 0.1 ** 0.05 *** 0.01) 
cells(b(star fmt(%5.3fc)) se(par fmt(%5.3fc))) stats(N r2, fmt(%5.0fc %5.2f) labels("Observations" "R squared"))  varwidth(42) modelwidth(8)
mlabels((1) (2) (3)) collabels(none)
varlabels(_cons "Constant")  msign(--)    label 
order(presentbias highdiscount riskaverse married haskids afqtn_s collegemore finqa finka sdvoly dur_c_s ghpi_cs_s rnw_s ho_* w*debt 2008.year 2012.year  applycred L4.leftover  l2sdvoly popsh_branch1k gpopbr4 gtotfs4 rel_finc)
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


