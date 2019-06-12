
* Replication Code for 
* Political Quid Pro Quo Agreements: An Experimental Study
* by Grosser, Reuben, and Tymula


* reanalysis by Justin Esarey and Andrew Menger with new clustering techniques
* original do file saved as Political quid pro quo.do
* note: ME code adapted from http://mattgolder.com/files/interactions/interaction1.zip


log using "Esarey Menger Political quid pro quo.log", replace

// ** Table 2 – Candidates: determinants of tax policy changes in Partners-Transfers **
use candidatedata, clear
keep if transfers == 1 & matching == 1
egen transferM = mean(transferall), by(group)
gen HighTax = transferM <= 10
xtset subject period
gen d_tax = tax - L.tax
gen d_transfer = transfer - L.transfer
gen l_taxdiffpos = max(L.tax - L.taxother, 0) if L.tax < .
gen l_taxdiffneg = max(L.taxother - L.tax, 0) if L.tax < .
gen d_trXperiod = d_transfer * period
la var d_tax "change in candidate's tax rate choice"
la var d_transfer "change in transfer to candidate"

// OLS regressions with changes in candidate j’s tax policy from period x-1 to period x as the dependent variable and robust standard errors clustered on societies
// All societies
* this is the source of Table 2, Columns "coefficient" and "CRSE"
xtreg d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, cluster(group) i(subject) fe

* now, use cluster-adjusted T statistics
* this is the source of Table 2, Column "CAT"
clustse regress d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, fe(yes) festruc(subject) cluster(group) force(yes)

* now, do cluster bootstrapping of the same regression
* this is the source of Table 2, Column "PCBST"
clusterbs regress d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, cluster(group) fe(inside) festruc(subject) reps(5000) seed(123456)

// Graphs of d_tax by d_transfer by group
gen groupnew = group
la var groupnew "group"
recode groupnew 701 = 1 702 = 2 801 = 3 802 = 4 1001 = 5 1002 = 6 1201 = 7 1301 = 8 1302 = 9 1401 = 10 1402 = 11 1501 = 12 1502 = 13 1601 = 14 1602 = 15 2001 = 16 2002 = 17

twoway (scatter d_tax d_transfer) (lfit d_tax d_transfer), by(groupnew) xlab(-50 -25 0 25 50) xtitle("change in transfer to candidate, {&Delta}{sub:it}{sup:m}") ylab(-100 -50 0 50 100, angle(horizontal)) ytitle("change in candidate's tax rate choice, {&Delta}{sub:it}{sup:{&tau}}")
graph export grosser-plot.pdf, replace

sort groupnew
statsby _b, by(groupnew) clear: reg d_tax d_transfer
scatter _b_d_transfer groupnew, ytitle("group-specific coefficient on change in transfer") xtitle("group number")
graph export grosser-bygroup.pdf, replace


*************************************
* high and low tax society analysis
*************************************
use candidatedata, clear
keep if transfers == 1 & matching == 1
egen transferM = mean(transferall), by(group)
gen HighTax = transferM <= 10
xtset subject period
gen d_tax = tax - L.tax
gen d_transfer = transfer - L.transfer
gen l_taxdiffpos = max(L.tax - L.taxother, 0) if L.tax < .
gen l_taxdiffneg = max(L.taxother - L.tax, 0) if L.tax < .
gen d_trXperiod = d_transfer * period
la var d_tax "change in candidate's tax rate choice"
la var d_transfer "change in transfer to candidate"

* original published results
* This is the source of Table 3, columns "Coefficient" and "CRSE"
xtreg d_tax i.HighTax#c.d_transfer i.HighTax#c.d_trXperiod i.HighTax#c.l_taxdiffpos i.HighTax#c.l_taxdiffneg i.HighTax#c.period, cluster(group) i(subject) fe

* high tax societies
preserve
keep if HighTax==1

* now, use cluster-adjusted T statistics
* This is the source of Table 3, column "CAT"
clustse regress d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, fe(yes) festruc(subject) cluster(group) force(yes)

* now, do cluster bootstrapping of the same regression
* This is the source of Table 3, Column "PCBST"
clusterbs regress d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, cluster(group) fe(inside) festruc(subject) reps(5000) seed(123456)

* low tax societies
restore
keep if HighTax==0

* get the original results for a marginal effects plot
* This is the source of Table 4, columns "coefficient" and "CRSE"
xtreg d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, cluster(group) i(subject) fe

* store ME plot information
matrix b=e(b)
matrix V=e(V)

scalar b1=b[1,1]
scalar b3=b[1,2]

scalar varb1=V[1,1]
scalar varb3=V[2,2]

scalar covb1b3=V[1,2]

* now, use cluster-adjusted T statistics
* This is the source of Table 4, column "CAT"
clustse regress d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, fe(yes) festruc(subject) cluster(group) force(yes)

* now, do cluster bootstrapping of the same regression
* This is the source of Table 4, column "PCBST"
clusterbs regress d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, cluster(group) fe(inside) festruc(subject) reps(5000) seed(123456)


* calculate the CATs manually, to get covariance information for ME plots
statsby _b, by(group) saving(grosser-groupbetas.dta, replace): xtreg d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, i(subject) fe

use grosser-groupbetas.dta, replace
* mark any missing clusters as missing
mvdecode _b_d_transfer _b_d_trXperiod _b_l_taxdiffpos _b_l_taxdiffneg _b_period _b_cons, mv(0)

* show the CRSE ME information
scalar list b1 b3 varb1 varb3 covb1b3

* calculate relevant variances and covariances for CATs
sum _b_d_transfer
scalar b1C = `r(mean)'
display `r(sd)' / (sqrt(7))
scalar varb1C = ( `r(sd)' / (sqrt(7)) )^2
sum _b_d_trXperiod
scalar b3C = `r(mean)'
display `r(sd)' / (sqrt(7))
scalar varb3C = ( `r(sd)' / (sqrt(7)) )^2
correlate _b_d_transfer _b_d_trXperiod, covariance
display `r(cov_12)' / sqrt(7)
scalar covb1b3C = `r(cov_12)' / 7

* show the CAT ME information
scalar list b1C b3C varb1C varb3C covb1b3C

*     ****************************************************************  *;
*       Calculate data necessary for top marginal effect plot.          *;
*     ****************************************************************  *;

set obs 14
generate MVZ=_n
replace MVZ = . if _n==1

gen conbx=b1+b3*MVZ

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ)

* note: using critical t for DF = (7-1) instead of 1.96
gen ax=2.446912*consx

gen upperx=conbx+ax

gen lowerx=conbx-ax


gen conbxC=b1C+b3C*MVZ

gen consxC=sqrt(varb1C+varb3C*(MVZ^2)+2*covb1b3C*MVZ)

* note: using critical t for DF = (7-1) instead of 1.96
gen axC=2.446912*consxC

gen upperxC=conbxC+axC

gen lowerxC=conbxC-axC

*     ****************************************************************  *;
*       Construct variable to produce y=0 line.                         *;
*     ****************************************************************  *;

gen yline=0

*     ****************************************************************  *;
*     ****************************************************************  *;
*       Produce marginal effect plot for X.                             *;
*     ****************************************************************  *;
*     ****************************************************************  *;

graph twoway line conbx  MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1) ||   line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black) ||   line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black) ||  line upperxC  MVZ, clpattern(dash_dot) clwidth(medium) clcolor(black) ||   line lowerxC  MVZ, clpattern(dash_dot) clwidth(medium) clcolor(black) ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid) || , xlabel(2 4 6 8 10 12 14, nogrid labsize(2)) ylabel(-3 -2 -1 0 1, axis(1) nogrid labsize(2)) xscale(noline) legend(label(1 "ME of {&Delta}{sub:it}{sup:m} on {&Delta}{sub:it}{sup:{&tau}}") label(2 "95% CI, CRSEs") label(4 "95% CI, CATs") order(1 2 - " " 4)) xtitle("" , size(2.5)  ) xtitle("Period (t)" , size(2.5)  ) ytitle("Marginal effect of change in transfer to candidate, {&Delta}{sub:it}{sup:m}" , size(2.5))  xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

graph export grosser-lowtax.pdf, replace



* marginal effects plot for all groups


use candidatedata, clear
keep if transfers == 1 & matching == 1
egen transferM = mean(transferall), by(group)
gen HighTax = transferM <= 10
xtset subject period
gen d_tax = tax - L.tax
gen d_transfer = transfer - L.transfer
gen l_taxdiffpos = max(L.tax - L.taxother, 0) if L.tax < .
gen l_taxdiffneg = max(L.taxother - L.tax, 0) if L.tax < .
gen d_trXperiod = d_transfer * period
la var d_tax "change in candidate's tax rate choice"
la var d_transfer "change in transfer to candidate"

xtreg d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, cluster(group) i(subject) fe

* store ME plot information
matrix b=e(b)
matrix V=e(V)

scalar b1=b[1,1]
scalar b3=b[1,2]

scalar varb1=V[1,1]
scalar varb3=V[2,2]

scalar covb1b3=V[1,2]

* now, use cluster-adjusted T statistics
clustse regress d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, fe(yes) festruc(subject) cluster(group) force(yes)


* calculate the CATs manually, to get covariance information for ME plots
statsby _b, by(group) saving(grosser-groupbetas-all.dta, replace): xtreg d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, i(subject) fe

use grosser-groupbetas-all.dta, replace
* mark any missing clusters as missing
mvdecode _b_d_transfer _b_d_trXperiod _b_l_taxdiffpos _b_l_taxdiffneg _b_period _b_cons, mv(0)

* show the CRSE ME information
scalar list b1 b3 varb1 varb3 covb1b3

* calculate relevant variances and covariances for CATs
sum _b_d_transfer
scalar b1C = `r(mean)'
display `r(sd)' / (sqrt(15))
scalar varb1C = ( `r(sd)' / (sqrt(15)) )^2
sum _b_d_trXperiod
scalar b3C = `r(mean)'
display `r(sd)' / (sqrt(15))
scalar varb3C = ( `r(sd)' / (sqrt(15)) )^2
correlate _b_d_transfer _b_d_trXperiod, covariance
display `r(cov_12)' / sqrt(15)
scalar covb1b3C = `r(cov_12)' / 15

* show the CAT ME information
scalar list b1C b3C varb1C varb3C covb1b3C

*     ****************************************************************  *;
*       Calculate data necessary for top marginal effect plot.          *;
*     ****************************************************************  *;

generate MVZ=_n
replace MVZ = . if _n==1
replace MVZ = . if _n>14


gen conbx=b1+b3*MVZ

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ)

* note: using critical t for DF = (15-1) instead of 1.96
gen ax=2.144787*consx

gen upperx=conbx+ax

gen lowerx=conbx-ax


gen conbxC=b1C+b3C*MVZ

gen consxC=sqrt(varb1C+varb3C*(MVZ^2)+2*covb1b3C*MVZ)

* note: using critical t for DF = (15-1) instead of 1.96
gen axC=2.144787*consxC

gen upperxC=conbxC+axC

gen lowerxC=conbxC-axC

*     ****************************************************************  *;
*       Construct variable to produce y=0 line.                         *;
*     ****************************************************************  *;

gen yline=0

*     ****************************************************************  *;
*     ****************************************************************  *;
*       Produce marginal effect plot for X.                             *;
*     ****************************************************************  *;
*     ****************************************************************  *;

graph twoway line conbx  MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1) ||   line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black) ||   line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black) ||  line upperxC  MVZ, clpattern(dash_dot) clwidth(medium) clcolor(black) ||   line lowerxC  MVZ, clpattern(dash_dot) clwidth(medium) clcolor(black) ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid) || , xlabel(2 4 6 8 10 12 14, nogrid labsize(2)) ylabel(-8 -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6, axis(1) nogrid labsize(2)) xscale(noline) legend(label(1 "ME of {&Delta}{sub:it}{sup:m} on {&Delta}{sub:it}{sup:{&tau}}") label(2 "95% CI, CRSEs") label(4 "95% CI, CATs") order(1 2 - " " 4)) xtitle("" , size(2.5)  ) xtitle("Period (t)" , size(2.5)  ) ytitle("Marginal effect of change in transfer to candidate, {&Delta}{sub:it}{sup:m}" , size(2.5))  xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

graph export grosser-alltax.pdf, replace



* appendix information:
* marginal effects plots for high tax groups


use candidatedata, clear
keep if transfers == 1 & matching == 1
egen transferM = mean(transferall), by(group)
gen HighTax = transferM <= 10
xtset subject period
gen d_tax = tax - L.tax
gen d_transfer = transfer - L.transfer
gen l_taxdiffpos = max(L.tax - L.taxother, 0) if L.tax < .
gen l_taxdiffneg = max(L.taxother - L.tax, 0) if L.tax < .
gen d_trXperiod = d_transfer * period
la var d_tax "change in candidate's tax rate choice"
la var d_transfer "change in transfer to candidate"


keep if HighTax==1

* get the original results for a marginal effects plot
xtreg d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, cluster(group) i(subject) fe

* store ME plot information
matrix b=e(b)
matrix V=e(V)

scalar b1=b[1,1]
scalar b3=b[1,2]

scalar varb1=V[1,1]
scalar varb3=V[2,2]

scalar covb1b3=V[1,2]

* calculate the CATs manually, to get covariance information for ME plots
statsby _b, by(group) saving(grosser-groupbetas-high.dta, replace): xtreg d_tax d_transfer d_trXperiod l_taxdiffpos l_taxdiffneg period, i(subject) fe

use grosser-groupbetas-high.dta, replace
* mark any missing clusters as missing
mvdecode _b_d_transfer _b_d_trXperiod _b_l_taxdiffpos _b_l_taxdiffneg _b_period _b_cons, mv(0)

* show the CRSE ME information
scalar list b1 b3 varb1 varb3 covb1b3

* calculate relevant variances and covariances for CATs
sum _b_d_transfer
scalar b1C = `r(mean)'
display `r(sd)' / (sqrt(8))
scalar varb1C = ( `r(sd)' / (sqrt(8)) )^2
sum _b_d_trXperiod
scalar b3C = `r(mean)'
display `r(sd)' / (sqrt(8))
scalar varb3C = ( `r(sd)' / (sqrt(8)) )^2
correlate _b_d_transfer _b_d_trXperiod, covariance
display `r(cov_12)' / sqrt(8)
scalar covb1b3C = `r(cov_12)' / 8

* show the CAT ME information
scalar list b1C b3C varb1C varb3C covb1b3C

*     ****************************************************************  *;
*       Calculate data necessary for top marginal effect plot.          *;
*     ****************************************************************  *;

set obs 14
generate MVZ=_n
replace MVZ = . if _n==1

gen conbx=b1+b3*MVZ

gen consx=sqrt(varb1+varb3*(MVZ^2)+2*covb1b3*MVZ)

* note: using critical t for DF = (8-1) instead of 1.96
gen ax=2.364624*consx

gen upperx=conbx+ax

gen lowerx=conbx-ax


gen conbxC=b1C+b3C*MVZ

gen consxC=sqrt(varb1C+varb3C*(MVZ^2)+2*covb1b3C*MVZ)

* note: using critical t for DF = (8-1) instead of 1.96
gen axC=2.364624*consxC

gen upperxC=conbxC+axC

gen lowerxC=conbxC-axC

*     ****************************************************************  *;
*       Construct variable to produce y=0 line.                         *;
*     ****************************************************************  *;

gen yline=0

*     ****************************************************************  *;
*     ****************************************************************  *;
*       Produce marginal effect plot for X.                             *;
*     ****************************************************************  *;
*     ****************************************************************  *;

graph twoway line conbx  MVZ, clpattern(solid) clwidth(medium) clcolor(black) yaxis(1) ||   line upperx  MVZ, clpattern(dash) clwidth(thin) clcolor(black) ||   line lowerx  MVZ, clpattern(dash) clwidth(thin) clcolor(black) ||  line upperxC  MVZ, clpattern(dash_dot) clwidth(medium) clcolor(black) ||   line lowerxC  MVZ, clpattern(dash_dot) clwidth(medium) clcolor(black) ||   line yline  MVZ,  clwidth(thin) clcolor(black) clpattern(solid) || , xlabel(2 4 6 8 10 12 14, nogrid labsize(2)) ylabel(-12 -10 -8 -6 -4 -2 0 2 4 6 8, axis(1) nogrid labsize(2)) xscale(noline) legend(label(1 "ME of {&Delta}{sub:it}{sup:m} on {&Delta}{sub:it}{sup:{&tau}}") label(2 "95% CI, CRSEs") label(4 "95% CI, CATs") order(1 2 - " " 4)) xtitle("" , size(2.5)  ) xtitle("Period (t)" , size(2.5)  ) ytitle("Marginal effect of change in transfer to candidate, {&Delta}{sub:it}{sup:m}" , size(2.5))  xsca(titlegap(2)) ysca(titlegap(2)) scheme(s2mono) graphregion(fcolor(white) ilcolor(white) lcolor(white))

graph export grosser-hightax.pdf, replace

log close