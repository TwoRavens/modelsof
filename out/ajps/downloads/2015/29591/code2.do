version 13.1
clear all
set more off
set  maxvar 11000
set matsize 4000

use data2, replace

*** Table 3: Turnout and Support for Leftist Policy Proposals: All Cantons, 1908-1970
reg turnout [pweight=weight]
outreg2 using table3.xls , excel  stats(coef tstat pval ) noaster cttop("All") dec(2) replace
global outcome1 = "turnout support_left2 support_right2 support_left"
foreach p of global outcome1 {	
reg `p'   if cvoting_sanctioned==1
outreg2 using table3.xls , excel  stats(coef se tstat pval ) noaster cttop("Mean in treated VD") dec(2) append	
xtivreg2 `p' cvoting_sanctioned  xx* time_ref_*  ddbnuXt_* [pweight=weight], fe clu(bnum time_ref) 
outreg2 using table3.xls , excel  stats(coef se tstat pval ) noaster cttop("All") dec(2) append	
}
