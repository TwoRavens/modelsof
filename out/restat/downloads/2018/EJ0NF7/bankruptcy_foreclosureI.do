
*REPRODUCES Table 10 and Table B7.

use "nlsy.dta", clear


*create a few variables needed for the regressions
local stubs "04 08 12"
foreach x of local stubs{
gen group_a`x'_t=group_a if year==20`x'
bysort caseid: egen group_a`x'=mean(group_a`x'_t)
drop group_a`x'_t
}



*Assets and liabilities; standarized by year

gen rtotasset=rnw+rtotdebt
sum rtotasset, detail
replace rtotasset=0 if  rtotasset<0



gen rtotdebt_s=.
gen rtotasset_s=.
forvalues x=2004(4)2012{
egen rtotdebt_s_`x'=mean(rtotdebt) if year==`x'
replace rtotdebt_s=(rtotdebt-rtotdebt_s_`x')/100000 if year==`x'
drop rtotdebt_s_`x'
egen rtotasset_s_`x'=mean(rtotasset) if year==`x'
replace rtotasset_s=(rtotasset-rtotasset_s_`x')/100000 if year==`x'
drop rtotasset_s_`x'
}

replace rtotdebt_s=ln(1+rtotdebt)
replace rtotasset_s=ln(1+rtotasset)
gen rarbitrage_s=sign(rarbitrage)*ln(abs(rarbitrage))
replace rarbitrage_s=0 if rarbitrage==0


* Homeowner

gen owner08_t=howner if year==2008
bysort caseid: egen owner08=mean(owner08_t)
drop owner08_t

* fill in foreclosesure to previous years

bysort caseid:  egen mforeclose_v=max(foreclose_v) 
replace foreclose_v=mforeclose_v
drop mforeclose_v




********************************************************************
*Foreclosure or bankrupcy between 2009-2012 based on 2008 status.
********************************************************************


#delimit ;
gen lag_debt=L4.rtotdebt_s; gen lag_asset=L4.rtotasset_s; gen lag_position=L4.leftover; gen lag_self=L4.selfemp; gen lag_howner=L4.howner;
gen lag_arb=L4.rarbitrage_s; replace lag_self=L4.selfemp;
#delimit cr


gen puzzle08=(group_a08==1)  if !mi(group_a08) 
gen puzzle04=(group_a04==1)  if !mi(group_a04) 
gen puzzle12=(group_a12==1)  if !mi(group_a12) 


*esttab . using "$tex/bank.tex" , main(mean %9.2f) aux(sd %9.2f) nostar  unstack label replace wrap style(tex)  msign(--)

local controlscommon "age presentbias highdiscount  riskaverse afqtn_s  married haskids b1.gender b3.race  finqa finka  collegemore"
local controlsyr "  bnk_b health_s div_s lag_debt lag_asset lag_position lag_self  "




*Based on 2008 values
gen bnk_b=bnk_b08
gen health_s=health12  
gen div_s=divsep12


*In the paper the regresions include state fixed effects and standard errors are clustered by state. We cannot provide geocode data, so the regressions are slightly modified here
*Actual regressions commented

//reghdfe foreclose_v  puzzle08   `controlsyr'  `controlscommon'  [aw=weight] if year==2012 & (group_a08==1| group_a08==4)  & owner08==1 ,    absorb(state) cluster(state) 
reg foreclose_v  puzzle08   `controlsyr'  `controlscommon'  [aw=weight] if year==2012 & (group_a08==1| group_a08==4)  & owner08==1 ,   robust
est store f

//reghdfe bnk12_s08  puzzle08 `controlsyr' `controlscommon' [aw=weight]  if year==2012 &  (group_a08==1| group_a08==4)   ,    absorb(state) cluster(state)
reg bnk12_s08  puzzle08 `controlsyr' `controlscommon' [aw=weight]  if year==2012 &  (group_a08==1| group_a08==4)   ,   robust
est store b  

probit foreclose_v  i.puzzle08  `controlsyr'   `controlscommon'   [pw=weight] if year==2012 & (group_a08==1| group_a08==4)  & owner08==1 
estpost margins, dydx(puzzle08  `controlsyr'  `controlscommon') 
est store pf

probit bnk12_s08  i.puzzle08 `controlsyr'  `controlscommon'   [pw=weight] if year==2012 &  (group_a08==1| group_a08==4) 
estpost margins, dydx(puzzle08 `controlsyr'  `controlscommon')
est store pb  



*Strict

replace puzzle08=(group_a5001mb08==1) if !mi(group_a5001mb08!=.)
replace puzzle04=(group_a5001mb04==1) if !mi(group_a5001mb04!=.)





//reghdfe foreclose_v  puzzle08   `controlsyr' `controlscommon'  [aw=weight] if year==2012  & (group_a5001mb08==1| group_a5001mb08==4)   &owner08==1  ,   absorb(state) cluster(state)
reg foreclose_v  puzzle08   `controlsyr' `controlscommon'  [aw=weight] if year==2012  & (group_a5001mb08==1| group_a5001mb08==4)   &owner08==1  ,  robust
est store fr



probit foreclose_v  i.puzzle08   `controlsyr'  `controlscommon'  [pw=weight]  if year==2012  & (group_a5001mb08==1| group_a5001mb08==4)   &owner08==1  
estpost margins,dydx(puzzle08 `controlsyr'    `controlscommon')
est store pfr


//reghdfe bnk12_s08  puzzle08 `controlsyr' `controlscommon' [aw=weight] if year==2012  & (group_a5001mb08==1| group_a5001mb08==4)    ,  absorb(state) cluster(state)
reg bnk12_s08  puzzle08 `controlsyr' `controlscommon' [aw=weight] if year==2012  & (group_a5001mb08==1| group_a5001mb08==4)   ,robust
est store br  

probit bnk12_s08  i.puzzle08 `controlsyr' `controlscommon'  [pw=weight]  if year==2012  & (group_a5001mb08==1| group_a5001mb08==4)  
estpost margins, dydx(puzzle08 `controlsyr' `controlscommon')
est store pbr  





*table10.tex

#delimit ; 
estout  b br  f fr using   , replace  style(tex)   starlevels( * 0.1 ** 0.05 ***
0.01) cells(b(star fmt(%5.3fc)) se(par fmt(%5.3fc))) stats(N r2 , fmt(%5.0fc %5.2f) labels("Observations" "R squared"))  varwidth(42) modelwidth(8)
mlabels((1) (2) (3) (4) ) collabels(none)
extracols(3)
varlabels( puzzle08 "Puzzle 2008"   lag_debt "Log Debt 2008" lag_asset "Log Assets 2008" lag_position "Assets $>$ Debt, 2008" 
afqtn_s "AFQT Score " presentbias "Present Bias" riskaverse "Middle Risk Aversion" highdiscount "High Discount Rate" 
finqa "Financial Literacy" finka "Financial Knowledge" bnk_b "Bankruptcy Pre-2009" health_s "Health Shock" div_s "Divorce Shock" lag_self "Self Employed 2008" 1.edu "$<$ High School" collegemore "College or More")  msign(--)    label 
order(puzzle08   presentbias highdiscount  riskaverse afqtn_s collegemore  finqa finka lag_debt lag_asset lag_position lag_self bnk_b   health_s div_s lag_self    )
keep( puzzle08 presentbias highdiscount  riskaverse afqtn_s collegemore lag_debt lag_asset lag_position lag_self bnk_b   health_s div_s finqa finka )

prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}  \vspace*{1ex} \begin{tabular}{l*{9}{c}} \toprule") 
	posthead("\midrule" "  &\multicolumn{2}{c}{\sc Bankruptcy, 2009--12} && \multicolumn{2}{c}{\sc Foreclosure, 2009--12}\\ " 	
	"& Baseline& Strict && Baseline& Strict \\" "\cline{2-3} \cline{5-6}\\") prefoot("\addlinespace ") postfoot("\bottomrule \end{tabular}" "\vspace*{1ex}" " "  
	"\parbox[1]{6.0in}{\footnotesize {\em Notes:} The dependent variables are dummies
	equal to one if the respondent filed for bankruptcy or went through foreclosure during the specified periods. 
    All regressions control for demographics (age, race, gender, marital status, presence of kids) as well as state fixed effects. Standard errors
	(in parentheses) clustered at the state level. The symbols ***(**)[*] indicate significance at the 1(5)[10] percent level. }") 
	
	;

#delimit cr



#delimit ; 
estout  pb pbr  pf pfr using tableB7.tex  , replace    style(tex)   starlevels( * 0.1 ** 0.05 ***
0.01) cells(b(star fmt(%5.3fc)) se(par fmt(%5.3fc))) stats(N r2_p chi2 p, fmt(%5.0fc %5.2f %5.3f) labels("Observations" "Pseudo-R squared" "$\chi^2$" "p-value"))  varwidth(42) modelwidth(8)
mlabels((1) (2) (3) (4) ) collabels(none)
extracols(3)
varlabels( 1.puzzle08 "Puzzle 2008"   lag_debt "Log Debt 2008" lag_asset "Log Assets 2008" lag_position "Assets $>$ Debt, 2008" 
afqtn_s "AFQT Score " presentbias "Present Bias" riskaverse "Middle Risk Aversion" highdiscount "High Discount Rate" 
finqa "Financial Literacy" finka "Financial Knowledge" bnk_b "Bankruptcy Pre-2009" health_s "Health Shock" div_s "Divorce Shock" lag_self "Self Employed 2008" 1.edu "$<$ High School" collegemore "College or More")  msign(--)    label 
order(1.puzzle08   presentbias highdiscount  riskaverse afqtn_s collegemore  finqa finka lag_debt lag_asset lag_position lag_self bnk_b   health_s div_s lag_self    )
keep( 1.puzzle08 presentbias highdiscount  riskaverse afqtn_s collegemore lag_debt lag_asset lag_position lag_self bnk_b   health_s div_s finqa finka )

prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}  \vspace*{1ex} \begin{tabular}{l*{9}{c}} \toprule") 
	posthead("\midrule" "  &\multicolumn{2}{c}{\sc Bankruptcy, 2009--12} && \multicolumn{2}{c}{\sc Foreclosure, 2009--12}\\ " 	
	"& Baseline& Strict && Baseline& Strict \\" "\cline{2-3} \cline{5-6}\\") prefoot("\addlinespace ") postfoot("\bottomrule \end{tabular}" "\vspace*{1ex}" " "  
	"\parbox[1]{6.0in}{\footnotesize {\em Notes:} The dependent variables are dummies
	equal to one if the respondent filed for bankruptcy or went through foreclosure during the specified periods. 
    All regressions control for demographics (age, race, gender, marital status, presence of kids). Standard errors
	(in parentheses) clustered at the state level. The symbols ***(**)[*] indicate significance at the 1(5)[10] percent level. }") 
	
	;

#delimit cr


