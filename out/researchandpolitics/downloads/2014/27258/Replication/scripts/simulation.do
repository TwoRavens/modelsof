/*
==========================================================================
File-Name:    simulation.do
Date:         Oct 27th, 2009
Author:       Fernando Martel                                 
Purpose:      Simulate impact of a change in Polity.  Becasue parameter 
              estimates already include the imputation uncertainty, use
              the average of the five imputed datasets.
Data Input:   stackfr   // Stack if imputed and orignial datasets.  I use
                        // Ross's population, Polity, and forward lag to
                        // show what happens under Ross's own procedures
Output File:  none
Data Output:  none
Previous file:proc_rep_master.do
Status:       Complete                                 
Machine:      Lenovo, X201 tablet running Windows 7 64-bit spck 1
==========================================================================
*/

clear
global path ///
C:\Users\Fernando\Documents\docs\research_projects\Replication\analysis
cd "$path"


* Load stacked dataset with original data and 5 imputed datasets.
* Here I use the quinquennial centered data, with my measure of Polity
* and the ACLP population of country years.
* --------------------------------------------------------------------
use stackca

* Estimate 2-way FE model
* -----------------------
* Column 4 - Two-way fixed effects specification
* Note this restricts the effect of polity to an intervept shift
mim, category(fit) storebv: xtreg lnCMRunicef lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 dperio*, fe vce(robust)

* Estimate trend model
mim, category(fit) storebv: xtreg lnCMRunicef counter, fe vce(robust)

* Estimate FE model with linear trend and interaction
rename counter time
gen polity_time = polity_1 * time
mim, category(fit) storebv: xtreg lnCMRunicef lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 polity_time time, fe vce(robust)

* Test if Polity is significant
testparm polity*



*=====================================================
*Check practical significance by simulation
*=====================================================
clear 
use stackca
* Create country dummies
tabulate (ctycode), generate(IDdum)
drop IDdum169

* Create time and interaction
rename counter time
gen polity_time = polity_1 * time

* Estimate model
mim, category(fit) storebv: reg lnCMRunicef lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 polity_time time IDdum*, vce(cluster ctynum)

* Store estimates
matrix b = e(b)
matrix vcv = e(V)

* Keep only Morocco, simulate its polity going from -8 to 0 (Lebanon's) 
* in period 1 (1970 quinquennia) and is maintained thereafter
keep if ctycode=="MAR" & _mj>0

* Average the 5 imputed datasets
collapse lnCMRunicef lngdppercap_1 ///
     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 polity_time time IDdum*, by(ctycode period)

* Draw random sample of the betas
set obs 1000
drawnorm b1-b176, means(b) cov(vcv) seed(01200)

* Keep the betas we will need, ignore all dummies except IDdum98 for Morocco
drop b8-b104
drop b106-b175

* Drop all dummies except morocco
drop IDdum1-IDdum97
drop IDdum99-IDdum168

* generate a constant
gen constant =1 

* I want to hold all variables fixed at time 2
* all coeffients fixed except those of 
* lnCMRunicef lngdppercap_1 ///
*     lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 polity_time time IDdum
* hold constant the other coefficients
local varlist = "b1 b2 b3 b4 b105 b176"
foreach l of local varlist {
   su `l'
   replace `l' = `r(mean)' 
}

* create 1000 by 9 matrix of simulated coefficients
mkmat b*, matrix(b_sim)

* create 1000 by 9 matrix of coavariates, but only data on first 7 rows
mkmat lngdppercap_1 lnhiv_1 lndensity_1 gdpgrowth_1 polity_1 polity_time time IDdum98 constant, matrix(x)


* Marginal Effect of Polity from -8 to 0 in period 1
* --------------------------------------------------
matrix x_t1b = x[1, 1...]  // matrix of covariates for period 1, base scenario
matrix x_t1a = x[1, 1...] 
matrix x_t1a[1,5] = 0
matrix x_t1a[1,6] = 0

* Compute predicted y for base scenario in period 1
matrix yhat1b = b_sim * x_t1b'
svmat yhat1b, name(yhat1b)

* Compute predicted y for alternative scenario in period 1
matrix yhat1a = b_sim * x_t1a'
svmat yhat1a, name(yhat1a)

su yhat1b
di exp(r(mean))
su yhat1a
di exp(r(mean))

gen dif1=exp(yhat1a) - exp(yhat1b)
su dif1
di "95% CI:" `r(mean)' - 1.96 * `r(sd)' ", "  `r(mean)' + 1.96 * `r(sd)' 


* Marginal Effect of Polity from -8 to 0 in period 3, versus normal
* course of events e.g. polity -7 or so in 1980
* --------------------------------------------------
matrix x_t3b = x[3, 1...]  // matrix of covariates for period 2, base scenario
matrix x_t3a = x[3, 1...] 
matrix x_t3a[1,5] = 0
matrix x_t3a[1,6] = 0

* Compute predicted y for base scenario in period 3
matrix yhat3b = b_sim * x_t3b'
svmat yhat3b, name(yhat3b)

* Compute predicted y for alternative scenario in period 3
matrix yhat3a = b_sim * x_t3a'
svmat yhat3a, name(yhat3a)

su yhat3b
di exp(r(mean))
su yhat3a
di exp(r(mean))

gen dif3=exp(yhat3a) - exp(yhat3b)
su dif3
di "95% CI:" `r(mean)' - 1.96 * `r(sd)' ", "  `r(mean)' + 1.96 * `r(sd)' 

* Marginal Effect of Polity from -8 to 0 in period 8, versus normal
* course of events e.g. polity -7 or so in 2000
* --------------------------------------------------
matrix x_t8b = x[7, 1...]  // matrix of covariates for period 2, base scenario
matrix x_t8a = x[7, 1...] 
matrix x_t8a[1,5] = 0
matrix x_t8a[1,6] = 0

* Compute predicted y for base scenario in period 8
matrix yhat8b = b_sim * x_t8b'
svmat yhat8b, name(yhat8b)

* Compute predicted y for alternative scenario in period 8
matrix yhat8a = b_sim * x_t8a'
svmat yhat8a, name(yhat8a)

su yhat8b
di exp(r(mean))
su yhat8a
di exp(r(mean))

gen dif8=exp(yhat8a) - exp(yhat8b)
su dif8
di "95% CI:" `r(mean)' - 1.96 * `r(sd)' ", "  `r(mean)' + 1.96 * `r(sd)' 

* In 2000 Morocco had (WDI accessed 9/14/2013):
* population of 28,710,000
* Crude birth rate = 21.9  per 1000 pop
* => 21.9*28,710 = 628,749 births in 2000
* 6 less deaths per 1,000 births = 5.7 * 629 = 3,585 lives saved per year.



