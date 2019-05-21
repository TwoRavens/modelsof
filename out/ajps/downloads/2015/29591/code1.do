version 13.1
clear all
set more off
set  maxvar 11000
set matsize 4000


use data1, replace
 
*** TABLE 1: The Policy Effects of Compulsory Voting
* --- calculate pval based on t-distribution with 10 d.f.---*
reg turnout [pweight=weight]
outreg2 using table1.xls , excel  stats(coef tstat pval ) noaster cttop("All") dec(2) replace
global outcome1 = "turnout support_left2 support_right2 support_left"
foreach p of global outcome1 {
reg `p'  [pweight=weight] if inrange(year,1925,1948) & knum==22 & year!=1942
outreg2 using table1.xls , excel  stats(coef se tstat pval ) noaster cttop("Mean in treated VD") dec(2) append	
xtivreg2 `p' treatment  xx* time_ref_*  ddbnuXt_* [pweight=weight], fe clu(bnum time_ref), if year <= 1948 	
outreg2 using table1.xls , excel  stats(coef se tstat pval ) noaster cttop("All") dec(2) append	
}

*** TABLE 2:The Policy Effects of Compulsory Voting on Core Issues of the Left 
reg turnout [pweight=weight] 
outreg2 using table2.xls , excel  stats(coef tstat pval ) noaster cttop("All") dec(2) replace
global outcome1 = "turnout support_left2 support_right2 support_left"
foreach p of global outcome1 {
	forvalues i = 0(1)1 	{
	reg `p'  [pweight=weight] if inrange(year,1925,1948) & year!=1942 & knum==22 & core_sp == `i'
	outreg2 using table2.xls , excel  stats(coef tstat pval ) noaster cttop("Mean in treated VD" "core issue sp `i'") dec(2) append	
	xtivreg2 `p' treatment xx* time_ref_*  ddbnuXt_* [pweight=weight], fe clu(bnum time_ref), if year <= 1948  & (core_sp == `i' | year <= 1924)
	outreg2 using table2.xls , excel  stats(coef tstat pval ) noaster cttop("core issue sp `i'") dec(2) append	
	}
}

*** TABLE 7: The Policy Effects of Compulsory Voting: District-specific Quadratic Time Trends 
reg turnout [pweight=weight] 
outreg2 using table7.xls , excel  stats(coef tstat pval ) noaster cttop("All") dec(2) replace
global outcome1 = "turnout support_leftright oppose_leftright support_left"
foreach p of global outcome1 {
reg `p'  [pweight=weight]  if inrange(year,1925,1948) & knum==22 & year!=1942
outreg2 using table7.xls , excel  stats(coef tstat pval ) noaster cttop("Mean in treated VD") dec(2) append	
xtivreg2 `p' treatment xx_* time_ref_*  ddbnuXt_* ddbnuXt2_* [pweight=weight]  , fe clu(bnum time_ref), if year <= 1948 & year!=1942
outreg2 using table7.xls , excel  stats(coef tstat pval ) noaster cttop("All") dec(2) append	
}

*** TABLE 8: The Policy Effects of Compulsory Voting: Fixed-Effects Only
set more off 
reg turnout [pweight=weight] 
outreg2 using table8.xls , excel  stats(coef tstat pval ) noaster cttop("All") dec(2) replace
global outcome1 = "turnout support_left2 support_right2 support_left"
foreach p of global outcome1 {
reg `p'  [pweight=weight]  if inrange(year,1925,1948) & knum==22 & year!=1942
outreg2 using table8.xls , excel  stats(coef tstat pval ) noaster cttop("Mean in treated VD") dec(2) append	
xtivreg2 `p' treatment time_ref_* [pweight=weight]  , fe clu(bnum time_ref), if year <= 1948  & year!=1942
outreg2 using table8.xls , excel  stats(coef tstat pval ) noaster cttop("All") dec(2) append	
}

*** TABLE 9: Main Results, unweighted  
set more off 
reg turnout
outreg2 using table9.xls , excel  stats(coef tstat pval ) noaster cttop("All") dec(2) replace
global outcome1 = "turnout support_left2 support_right2 support_left"
foreach p of global outcome1 {
reg `p'   if inrange(year,1925,1948) & knum==22 & year!=1942
outreg2 using table9.xls , excel  stats(coef se tstat pval ) noaster cttop("Mean in treated VD") dec(2) append	
xtivreg2 `p' treatment  xx* time_ref_*  ddbnuXt_* , fe clu(bnum time_ref), if year <= 1948 	
outreg2 using table9.xls , excel  stats(coef se tstat pval ) noaster cttop("All") dec(2) append	
}

*** TABLE 10: The Policy Effects of Compulsory Voting, Alternative Coding
set more off
keep if support_leftright_rel!=.
reg turnout [pweight=weight]
outreg2 using table10.xls , excel  stats(coef tstat pval ) noaster cttop("All") dec(2) replace
global outcome1 = "turnout support_leftright oppose_leftright support_leftright_rel"
foreach p of global outcome1 {
reg `p'  [pweight=weight] if inrange(year,1925,1948) & knum==22 & year!=1942
outreg2 using table10.xls , excel  stats(coef se tstat pval ) noaster cttop("Mean in treated VD") dec(2) append	
xtivreg2 `p' treatment  xx* time_ref_*  ddbnuXt_* [pweight=weight], fe clu(bnum time_ref), if year <= 1948 	
outreg2 using table10.xls , excel  stats(coef se tstat pval ) noaster cttop("All") dec(2) append	
}

