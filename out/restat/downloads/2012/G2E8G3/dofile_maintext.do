clear
capture log close
set more off
set memory 64m
set matsize 800

use data_maintext.dta, clear

sort w7
tsset w7


** Table 2: Correlations Matrices of the Variables Employed in the Regression Analysis

pwcorr y1 y2 x1 x2 w1 w2 w3 w4 w5 w6 w7, star(0.1)
pwcorr y1 y2 x1 x2 w1 w2 w3 w4 w5 w6 w7, star(0.05)
pwcorr y1 y2 x1 x2 w1 w2 w3 w4 w5 w6 w7, star(0.01)


** Table 3: Baseline Estimations with Autoregressive Distributed Lags

reg y1 l.y1 l2.y1 l3.y1 x1 l.x1 x2 l.x2 w1 w2 w3 w4 w5 w6 w7
durbina, force
fitstat

reg y1 l.y1 l2.y1 x1 x2 w1 w2 w3 w4 w5 w6 w7
durbina, force
fitstat

reg y1 l.y1 l2.y1 l3.y1 l.y2 l2.y2 l3.y2 x1 l.x1 x2 l.x2 w1 w2 w3 w4 w5 w6 w7
durbina, force
fitstat

reg y1 l.y1 l2.y1 l.y2 l2.y2  x1 x2 w1 w2 w3 w4 w5 w6 w7
durbina, force
fitstat

** Table 4: Robustness Check - Vector Autoregression Model (VAR)

var y1 y2, exog(x1 x2 w1 w2 w3 w4 w5 w6 w7) lags(1 2 3)
varsoc, estimates(.)
varlmar
varstable

var y1 y2, exog(x1 x2 w1 w2 w3 w4 w5 w6 w7) lags(1 2)
varsoc, estimates(.)
varlmar
varstable


** Table 5: Robustness Check - Dropping the Periods when the agricultural lands were dominated by the nomads

* Generate a binary variable: han - =1 if the central plains are dominated by Han Chinese
gen han=(w4==0&w5==0&w6==0)
gen hy1=y1 if han==1
gen hy2=y2 if han==1


reg hy1 l.hy1 l2.hy1 l.hy2 l2.hy2 x1 x2 w1 w2 w3 w7

var hy1 hy2, exog(x1 x2 w1 w2 w3 w7) lags (1 2)



** Appendix C: Conflicts between the Han and the nomads

heckman hy1 l.y1 l2.y1  l.y2 l2.y2 x1 x2 w1 w2 w3 w7, select (x1 x2 w1 w2 w3 w7) twostep

heckman hy1 l.y1 l2.y1  l.y2 l2.y2 x1 x2  w3 w7, select (x1 x2 w1 w2 w3 w7)

