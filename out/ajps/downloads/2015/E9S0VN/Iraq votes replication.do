* Models to Create Tables 3 and 4 *

* 2003 Vote *
use "KSAJPSIraq87bapprops03.dta", clear
ttest  approp03caswin50 if dem == 1, by(antiwarvote)
logit antiwarvote lnapprop03caswin50 leader anyfrcommittee seniorityinchamber veteran black latino female if dem == 1, robust

* 2004 Vote *
use "KSAJPSIraqpraiseres04.dta", clear
ttest  res04caswin50 if dem == 1, by(antiwarvote)
logit antiwarvote lnres04caswin50 leader anyfrcommittee seniorityinchamber veteran black latino female if dem == 1, robust

* 2005 Vote *
use "KSAJPSwoolsey05orig.dta", clear
ttest  woolsey05caswin50 if dem == 1, by(antiwarvote)
logit antiwarvote lnwoolsey05caswin50 leader anyfrcommittee seniorityinchamber veteran black latino female if dem == 1, robust

* 2007 Vote *
use "KSAJPSmcgovern07.dta", clear
ttest  mcgovern07caswin50 if dem == 1, by(antiwarvote)
logit antiwarvote lnmcgovern07caswin50 leader anyfrcommittee seniorityinchamber veteran black latino female if dem == 1, robust
