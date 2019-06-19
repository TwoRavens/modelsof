

clear all
set more off
set memo 500m
set matsize 800
capture log close

cd ~/Crime

log using CHNS.log, text replace

********************************************************************************************

* Table 7, Column (1)-(4); full resutls reported in Table VI in Appendix B

********************************************************************************************

use CHNS_1.dta, clear

g lratio=ln(ratio)
g mlratio=male*lratio

tab id, ge(pd) 
tab yob, ge(cd) 
	
global lhs "food  wash  child  chore"

foreach i in $lhs {
eststo:	reg `i' mlratio male lratio lpop education rural pd* cd*, cluster(id)
	}
	
esttab using CHNS.tex, label se ar2 title() keep(mlratio male lratio lpop education rural) addnote("")star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear


********************************************************************************************

* Table 7, Column (5)-(6); full resutls reported in Table VI in Appendix B

********************************************************************************************

use CHNS_2.dta, clear

g lratio=ln(ratio)
g mlratio=male*lratio

tab id, ge(pd) 
tab yob, ge(cd)

global lhs "par dom"

foreach i in $lhs {
eststo:	reg `i' mlratio male lratio  lpop education rural pd*  cd*, cluster(id)
	}
	
esttab using CHNS.tex, label se ar2 title()keep(mlratio male lratio lpop education rural )addnote("")star(* 0.10 ** 0.05 *** 0.01) append
eststo clear




********************************************************************************************

* Table VII in Appendix B, Column (1)-(4)

********************************************************************************************

use CHNS_1.dta, clear

g lratio=ln(ratiob)
g mlratio=male*lratio

tab id, ge(pd) 
tab yob, ge(cd) 
	
global lhs "food  wash  child  chore"

foreach i in $lhs {
eststo:	reg `i' mlratio male lratio lpop education rural pd* cd*, cluster(id)
	}
	
esttab using CHNS_appendix.tex, label se ar2 title() keep(mlratio male lratio lpop education rural) addnote("")star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear


********************************************************************************************

* Table VII in Appendix B, Column (5)-(6)

********************************************************************************************

use CHNS_2.dta, clear

g lratio=ln(ratiob)
g mlratio=male*lratio

tab id, ge(pd) 
tab yob, ge(cd)

global lhs "par dom"

foreach i in $lhs {
eststo:	reg `i' mlratio male lratio  lpop education rural pd*  cd*, cluster(id)
	}
	
esttab using CHNS_appendix.tex, label se ar2 title()keep(mlratio male lratio lpop education rural )addnote("")star(* 0.10 ** 0.05 *** 0.01) append
eststo clear


log close
exit, clear




