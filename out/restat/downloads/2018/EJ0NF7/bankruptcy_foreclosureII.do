
*REPRODUCES Table 11.

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



*
*Health and Divorce shocks for 2014

*divorced/separated within the period

capture drop divsep14
gen divsep14=((married==1) & divsep2014==1) if year==2012 & !mi(married,divsep2014)
bysort caseid: egen divsep14p=max(divsep14)
drop divsep14
rename divsep14p divsep14

*Health limitations


gen health14=(healthlimitations2014==1 & (healthlimitations==0)) if year==2012 & !mi(healthlimitations,healthlimitations2014)
bysort caseid: egen health14p=max(health14)
drop health14
rename health14p health14




********************************************************************
*Foreclosure or bankrupcy between 2009-2012 based on 2008 status.
********************************************************************


#delimit ;
gen lag_debt=L4.rtotdebt_s; gen lag_asset=L4.rtotasset_s; gen lag_position=L4.leftover;  gen lag_howner=L4.howner;
gen lag_arb=L4.rarbitrage_s; gen lag_self=L4.selfemp;
#delimit cr


gen puzzle08=(group_a08==1)  if (group_a08==1|group_a08==4) 
gen puzzle04=(group_a04==1)  if (group_a04==1|group_a04==4) 
gen puzzle12=(group_a12==1)  if (group_a12==1|group_a12==4) 


gen puzzle08r=(group_a5001mb08==1)  if (group_a5001mb08==1|group_a5001mb08==4) 
gen puzzle04r=(group_a5001mb04==1)  if (group_a5001mb04==1|group_a5001mb04==4) 
gen puzzle12r=(group_a5001mb12==1)  if (group_a5001mb12==1|group_a5001mb12==4) 



//gen puzzleboth=(L4.group_a==1 & L8.group_a==1) if !mi(L4.group_a , L8.group_a) & year==2012
//replace puzzle08=0 if puzzleboth==1 & year==2012
//gen group=L4.group_a



*esttab . using "$tex/bank.tex" , main(mean %9.2f) aux(sd %9.2f) nostar  unstack label replace wrap style(tex)  msign(--)

local controlscommon "age presentbias highdiscount  riskaverse afqtn_s  married haskids b1.gender b3.race  finqa finka  collegemore"
local controlsyr "  bnk_b health_s div_s lag_debt lag_asset lag_position lag_self  "


*Based on 2008 values for year 2012-2009
gen bnk_b=bnk_b08
gen health_s=health12  
gen div_s=divsep12
gen puzzleyr=puzzle08

*State variable is dropped. Commented regressions are the ones we ran in the paper. 

//reghdfe bnk12_s08  i.puzzleyr `controlsyr' `controlscommon' [aw=weight]  if year==2012   ,    absorb(state) cluster(state)
reg bnk12_s08  i.puzzleyr `controlsyr' `controlscommon' [aw=weight]  if year==2012   ,    robust
est store b08  

replace puzzleyr=puzzle08r
//reghdfe bnk12_s08  i.puzzleyr `controlsyr' `controlscommon' [aw=weight]  if year==2012   ,     absorb(state) cluster(state)
reg bnk12_s08  i.puzzleyr `controlsyr' `controlscommon' [aw=weight]  if year==2012   ,    robust
est store b08r 


*Based on 2004 values for 2008-2005
replace bnk_b=bnk_b04
replace health_s=health08  
replace div_s=divsep08
replace puzzleyr=puzzle04


//reghdfe bnk08_s04  i.puzzleyr `controlsyr' `controlscommon' [aw=weight]  if year==2008   ,     absorb(state) cluster(state)
reg bnk08_s04  i.puzzleyr `controlsyr' `controlscommon' [aw=weight]  if year==2008   ,     robust

est store b04  

replace puzzleyr=puzzle04r

//reghdfe bnk08_s04  i.puzzleyr `controlsyr' `controlscommon' [aw=weight]  if year==2008   ,     absorb(state) cluster(state)
reg bnk08_s04  i.puzzleyr `controlsyr' `controlscommon' [aw=weight]  if year==2008   ,    robust

est store b04r 


*Based on 2012 values for 2015-2013
replace bnk_b=bnk_b12
replace health_s=health14  
replace div_s=divsep14
replace puzzleyr=puzzle12
replace lag_debt=rtotdebt_s
replace lag_asset=rtotasset_s
replace lag_position=leftover
replace lag_self=selfemp




//reghdfe bnk14_s12  i.puzzleyr `controlsyr' `controlscommon' [aw=weight]  if year==2012   ,     absorb(state) cluster(state)
reg bnk14_s12  i.puzzleyr `controlsyr' `controlscommon' [aw=weight]  if year==2012   ,     robust

est store b12  

replace puzzleyr=puzzle12r

//reghdfe bnk14_s12  i.puzzleyr `controlsyr' `controlscommon' [aw=weight]  if year==2012   ,    absorb(state) cluster(state)
reg bnk14_s12  i.puzzleyr `controlsyr' `controlscommon' [aw=weight]  if year==2012   ,   robust

est store b12r 



*using "$tex/mini_bankruptcy.tex"
*mini table .
#delimit ;
estout b04 b04r b08  b08r b12 b12r  ,  replace style(tex) msign(--)    label 
order(1.puzzleyr ) cells(b(star fmt(%5.3fc)) p(par fmt(%5.3fc)))  
stats(N r2_a, fmt(%5.0fc %5.2f) labels("Observations" "Adj. R squared" ))
varwidth(38) modelwidth(8)  mlabels((1) (2) (3) (4) (5) (6) ) collabels(none) 
keep(1.puzzleyr)
extracols(3 5)
varlabels(1.puzzleyr "{\small Puzzle Dummy}"  )
prehead("\def\sym#1{\ifmmode^{#1}\else\(^{#1}\)\fi}  \vspace*{1ex} \begin{tabular}{l*{9}{c}} \toprule") 
	posthead("\midrule" "  &\multicolumn{2}{c}{\sc Bankruptcy, 05--08} && \multicolumn{2}{c}{\sc Bankruptcy, 09--12} && \multicolumn{2}{c}{\sc Bankruptcy, 13--14}\\ " 	
	"  &\multicolumn{2}{c}{Puzzle 2004} && \multicolumn{2}{c}{Puzzle 2008} && \multicolumn{2}{c}{Puzzle 2012}\\ " 	
	"& Baseline& Strict && Baseline& Strict  && Baseline & Strict\\" "\cline{2-3} \cline{5-6} \cline{8-9}\\") prefoot("\addlinespace ") postfoot("\bottomrule \end{tabular}" " "  
	"\vspace*{1ex}" " "  
	"\parbox[1]{6.6in}{\footnotesize {\em Notes:} The dependent variable is  equal to one if the respondent filed for bankruptcy during the specified period. Weighted Linear Probability Regressions. Controls as in Table~\ref{tb:bankruptcy}, adjusted to the relevant reference period. 
		Standard errors (in parentheses) clustered at the state level. The symbols ***(**)[*] indicate significance at the 1(5)[10] percent level. }") 
	;

#delimit cr




