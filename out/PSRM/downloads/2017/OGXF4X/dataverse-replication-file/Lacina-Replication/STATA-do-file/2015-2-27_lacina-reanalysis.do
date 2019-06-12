*********************************
*Replication of tables and figures in: 
*How governments shape the risk of civil violence: India’s federal reorganization, 1950–56
*By Bethany Lacina
*American Journal of Political Science

*Reanalysis by Justin Esarey, Rice University
*new models indicated by *JE indicator

*********************************
*This replication file uses the following STATA packages: CLARIFY and 
*Uncomment the lines below to install these packages (computer must be online)
*net cd http://gking.harvard.edu/clarify/
*net install clarify.pkg
*net cd http://www.stata-journal.com/software/sj4-3/
*net install gr0002_3.pkg

version 13.2
set more off
log using lacina-rep.log, replace

*****Load data and set global macros******

use "LacinaAJPSreplication.dta", clear

notes

global controls polsim lnelgmps lnelpop eagpc elndlss ehindupc lcapdist 

global controls2 polcdist05 lnelgmps lnelpop eagpc elndlss ehindupc lcapdist 

global controls3 lnelgmps lnelpop eagpc elndlss ehindupc lcapdist

global controls4 lnelgmps lnelpop ehindupc lcapdist

******Main text*******

* JE: Start with a very basic scatterplot of the DV against the IV.
* A few outliers appear to be driving the non-linear impact.
scatter outcome_t lnrelgrepnm, xtitle("log relative INC representation") ytitle("Outcome (1 = status quo, 2 = peaceful" "accommodation, 3 = violence)")
graph export lacina-scatter.eps, replace

*Model 1 (this is Lacina's original specification)
* This is the source of Table 5, Columns "coefficient" and "CRSE"

mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls, cluster(snum)
mat g = e(b)

mat list g

eststo lacina

qui: mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls

*mlogtest, suest

*JE: drop the clustered SEs (too few clusters for this to work)
*significance of lnrelgrepnm is gone now, minor negative effect
*on violence relative to base category and large negative effect 
*on accommodation
*This is the source of Table 5, column "Vanilla SEs"
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls 

eststo vanilla

*JE: manually pairs cluster bootstrapped SEs
*This is the source of Table 5, column "PCBST"
*note that the column entries are in the p-values and
*95% CI statements for each variable and each outcome 

* cluster bootstrap the pivotal statistic using clustered SEs
program mymlogit, rclass
mlogit outcome_t lnrelgrepnm lnrelgrepnm2 $controls, cluster(tempsnum) iter(100)
end

bootstrap t_piv = ((_b[2:lnrelgrepnm] - g[1,11])/_se[2:lnrelgrepnm]) t_piv2 = ((_b[2:lnrelgrepnm2] - g[1,12])/_se[2:lnrelgrepnm2]) t_piv3 = ((_b[3:lnrelgrepnm] - g[1,21])/_se[3:lnrelgrepnm]) t_piv4 = ((_b[3:lnrelgrepnm2] - g[1,22])/_se[3:lnrelgrepnm2]), r(1000) seed(123456) cluster(snum) idcluster(tempsnum) saving(lacina-reps, replace): mymlogit


use lacina-reps, replace

gen abs_t_piv = abs(t_piv)
gen abs_t_piv2 = abs(t_piv2)
gen abs_t_piv3 = abs(t_piv3)
gen abs_t_piv4 = abs(t_piv4)


* lnrelgrepnm for outcome 2
gen sig = abs_t_piv > abs(-2.16)
sum sig
* p-value is 0.337.

* 95% CIs
sum abs_t_piv, detail
display -4.915171 + 35.7366*2.27946
display -4.915171 - 35.7366*2.27946




* lnrelgrepnm2 for outcome 2
gen sig2 = abs_t_piv2 > abs(-2.42)
sum sig2
* p-value is 0.298.

* 95% CIs
sum abs_t_piv2, detail
display -1.17292 + 36.1765*.484539
display -1.17292 - 36.1765*.484539



* lnrelgrepnm for outcome 3
gen sig3 = abs_t_piv3 > abs( 2.42)
sum sig3
* p-value is 0.219.

* 95% CIs
sum abs_t_piv3, detail
display .608744 + 37.14897*.2520023
display .608744 - 37.14897*.2520023



* lnrelgrepnm2 for outcome 3
gen sig4 = abs_t_piv4 > abs(-3.29)
sum sig4
* p-value is 0.188.

* 95% CIs
sum abs_t_piv4, detail
display -.3413929 + 37.16158*.1036756
display -.3413929 - 37.16158*.1036756
