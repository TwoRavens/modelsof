* use "GillEugenis_ind.dta"

version 15.1

ssc install fitstat

// Table 1, Top Half (Descriptives)

tabstat vshare lnadv chnumber lnmedia murderlog lawyerlog prior ranked fem inc ///
 femfem partisan openseat if challenger==1, statistics(mean sd min max n) ///
 f(%9.2f) c(s)

// Table 2:
 
tab2 fem challenger if inc==1, r all 
bysort partisan: tab2 fem challenger if inc==1, r all
tab2 fem femopp if inc==1 & challenger==1, r all
 
// Table 3: Candidate-Level OLS Models of Vote Share

* Model 1

reg vshare i.fem i.femopp c.lnadv i.inc i.prior i.ranked c.chnumber c.lnmedia ///
 i.openseat i.partisan i.stateid i.year if challenger==1, cluster(id) ///
 cformat(%9.3f) 

testparm i.year
testparm i.stateid
fitstat
 
* Model 2

reg vshare i.fem i.femopp c.lnadv i.prior i.ranked c.chnumber c.lnmedia ///
 i.partisan i.stateid i.year if challenger==1 & openseat==1, cluster(id) ///
  cformat(%9.3f) 
 
testparm i.year
testparm i.stateid
fitstat

* Model 3

reg vshare i.fem i.femopp c.lnadv i.inc i.prior i.ranked c.chnumber c.lnmedia ///
 i.partisan i.stateid i.year if challenger==1 & openseat==0, cluster(id) ///
 cformat(%9.3f) 
 
testparm i.year
testparm i.stateid
fitstat

// Table 5

bysort challenger: tab2 cantype fem

// Table A1: Summary Statistics of Challenged Incumbents by Gender

bysort fem: tabstat vshare murderlog lawyerlog lnadv chnumber femopp app prior ///
 win partisan ranked if cantype==1 & challenger==1, /// 
 statistics(mean sd min max n)  f(%9.2f) c(s)

// Table A2: Summary Statistics of Challengers by Gender

bysort fem: tabstat vshare murderlog lawyerlog lnadv chnumber femopp app prior ///
 win partisan ranked if cantype==0 & challenger==1, /// 
 statistics(mean sd min max n)  f(%9.2f) c(s)

// Table A3: Summary Statistics of Open Seat Candidates by Gender

bysort fem: tabstat vshare murderlog lawyerlog lnadv chnumber femopp app prior ///
 win partisan ranked if cantype==2 & challenger==1, /// 
 statistics(mean sd min max n)  f(%9.2f) c(s)

// Additional Hypothesis Tests from Footnotes

tab2 fem challenger if cantype==1, r all // fn. 19
bysort partisan: tab2 fem challenger if cantype==1, r all // fn. 20
tab2 fem femopp if cantype==1 & challenger==1, r all // fn. 21
tab2 fem openseat if inc==0, r col all // for fn. 26-27
prtesti 67 .3731 67 .6269 // for fn. 26
prtesti 236 .4873 236 .5127 // for fn. 27
 
// Diagnostics //
// Testing for Selection Effects

* Descriptives for selection models
tabstat unopposed vshare lnadv ranked rank prior last chnumber murderlog /// 
 lnmedia fem inc openseat partisan, ///
 statistics(n mean sd min max) f(%9.2f)

* Heckman Selection models: correction is not significant
heckman vshare c.lnadv i.ranked i.prior c.last c.chnumber c.murderlog c.lnmedia ///
 i.fem i.inc i.openseat i.partisan i.year i.stateid, ///
 select(challenger=c.lawyerlog c.ranked i.partisan c.last i.fem i.inc i.prior) cluster(id)
testparm i.year
testparm i.stateid

// Candidate-Level Random Effects Models of Vote Share

* Model 1

mixed vshare i.fem i.femopp c.lnadv i.inc i.prior i.ranked c.chnumber c.lnmedia ///
 i.openseat i.partisan if challenger==1 || stateid: || id:, mle ///
 cformat(%9.3f) 
 
* Model 2

mixed vshare i.fem i.femopp c.lnadv i.prior i.ranked c.chnumber c.lnmedia ///
 i.partisan if challenger==1 & openseat==1 || stateid: || id:, mle cformat(%9.3f) 
 
* Model 3

mixed vshare i.fem i.femopp c.lnadv i.inc i.prior i.ranked c.chnumber c.lnmedia ///
 i.partisan if challenger==1 & openseat==0 || stateid: || id:, mle cformat(%9.3f) 
 
// Diagnostics for Models in Table 3

* Model 1

reg vshare i.fem i.femopp c.lnadv i.inc i.prior i.ranked c.chnumber c.lnmedia ///
 i.openseat i.partisan i.stateid i.year if challenger==1, cluster(id) ///
 cformat(%9.3f)  

predict res, residual
predict vhat

histogram vshare if challenger==1 & inc==1, frequency normal kdensity
sktest vshare if challenger==1 & inc==1

sktest res
rvfplot

preserve
set seed 111
sample 100, count
twoway (scatter vshare vhat) (lfit vshare vhat)
restore

estat vif

testparm i.year

drop res vhat

* Model 2

reg vshare i.fem i.femopp c.lnadv i.prior i.ranked c.chnumber c.lnmedia ///
 i.partisan i.stateid i.year if challenger==1 & openseat==1, cluster(id) ///
  cformat(%9.3f)
  
predict res, residual
predict vhat

histogram vshare if challenger==1 & inc==1, frequency normal kdensity
sktest vshare if challenger==1 & inc==1

sktest res
rvfplot

preserve
set seed 111
sample 100, count
twoway (scatter vshare vhat) (lfit vshare vhat)
restore

estat vif

testparm i.year

drop res vhat

* Model 3

reg vshare i.fem i.femopp c.lnadv i.inc i.prior i.ranked c.chnumber c.lnmedia ///
 i.partisan i.stateid i.year if challenger==1 & openseat==0, cluster(id) ///
 cformat(%9.3f) 

predict res, residual
predict vhat

histogram vshare if challenger==1 & inc==1, frequency normal kdensity
sktest vshare if challenger==1 & inc==1

sktest res
rvfplot

preserve
set seed 111
sample 100, count
twoway (scatter vshare vhat) (lfit vshare vhat)
restore

estat vif

testparm i.year

drop res vhat
