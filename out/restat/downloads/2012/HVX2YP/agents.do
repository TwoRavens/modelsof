*****Stata program to replicate tables in Ashenfelter and Dahl, "Bargaining and the Role of Expert Agents: An Empirical Study of Final Offer Arbitration"
*****Published in Review of Economics and Statistics, Vol. 94, No. 1, pp. 116-132, February 2012.
*****Uses input dataset agents.dta

clear all
set mem 1G

capture log close
log using output, text replace

*****************
*****Table 1*****
*****************

use agents.dta, replace

foreach samp of varlist fullsamp wagesamp {

  *Agent use
  sum agentu agente if `samp'
  sum agent00 agent01 agent10 agent11 if `samp'

  *Employer victories
  sum ewin if `samp'
  sum ewin if agente==0 & agentu==0 & `samp'
  sum ewin if agente==0 & agentu==1 & `samp'
  sum ewin if agente==1 & agentu==0 & `samp'
  sum ewin if agente==1 & agentu==1 & `samp'

  *Difference in final offers (averages of the median percentage point difference)
  sum wagediff if `samp'
  sum wagediff if agente==0 & agentu==0 & `samp'
  sum wagediff if agente==0 & agentu==1 & `samp'
  sum wagediff if agente==1 & agentu==0 & `samp'
  sum wagediff if agente==1 & agentu==1 & `samp'

  *Disputed items, type of unit, population of municipality, number of years covered by award
  sum onlywages onlybenefits bothwagesbenefits if `samp'
  sum police fire other if `samp'
  sum pop* if `samp'
  sum nyr* if `samp'
}

*Median population of municipality
centile numemp if pop5
centile numemp if pop510
centile numemp if pop1015
centile numemp if pop1525
centile numemp if pop2550
centile numemp if pop50100
centile numemp if pop100
centile numemp if popcnty
centile numemp if popstate
centile numemp if popmiss

*Number of times a municipality uses arbitration
*Note: calculated later in program -- see Table 6 section of code

*****************
*****Table 2*****
*****************

*Not an empirical table

*****************
*****Table 3*****
*****************

biprobit agente agentu, nolog
biprobit agente agentu y2-y18 pop5-pop1525 pop50100-popstate popmiss, nolog
testparm y2-y18
testparm pop*
biprobit agente agentu y2-y18 pop5-pop1525 pop50100-popstate popmiss nyr2 nyr3 nyrmiss fire other onlybenefits onlywages, nolog
testparm nyr2 nyr3 nyrmiss
testparm onlywages onlybenefits
testparm fire other
testparm y2-y18
testparm pop*
biprobit agente agentu y2-y18 pop5-pop1525 pop50100-popstate popmiss nyr2 nyr3 nyrmiss fire other onlybenefits onlywages if wagesamp, nolog
testparm nyr2 nyr3 nyrmiss
testparm onlywages onlybenefits
testparm fire other
testparm y2-y18
testparm pop*

*****************
*****Table 4*****
*****************

probit ewin agente agentu
dprobit ewin agente agentu
test agente=-agentu
probit ewin agente agentu if wagesamp
dprobit ewin agente agentu if wagesamp
test agente=-agentu
probit ewin agente agentu pop5-popstate y2-y18 if wagesamp
dprobit ewin agente agentu pop5-popstate y2-y18 if wagesamp
test agente=-agentu
testparm pop*
testparm y2-y18
probit ewin agente agentu agenteagentu pop5-popstate y2-y18 if wagesamp
dprobit ewin agente agentu agenteagentu pop5-popstate y2-y18 if wagesamp
test agente=-agentu
testparm pop*
testparm y2-y18
probit ewin agente agentu wageave pop5-popstate y2-y18 if wagesamp
dprobit ewin agente agentu wageave pop5-popstate y2-y18 if wagesamp
test agente=-agentu
testparm pop*
testparm y2-y18
probit ewin agente agentu agenteagentu wageave pop5-popstate y2-y18 if wagesamp
dprobit ewin agente agentu agenteagentu wageave pop5-popstate y2-y18 if wagesamp
test agente=-agentu
testparm pop*
testparm y2-y18
probit ewin agente agentu wagee wageu pop5-popstate y2-y18 if wagesamp
dprobit ewin agente agentu wagee wageu pop5-popstate y2-y18 if wagesamp
test agente=-agentu
test wagee=wageu
testparm pop*
testparm y2-y18
probit ewin agente agentu wageave wagediff pop5-popstate y2-y18 if wagesamp
dprobit ewin agente agentu wageave wagediff pop5-popstate y2-y18 if wagesamp
test agente=-agentu
testparm pop*
testparm y2-y18

*****************
*****Table 5*****
*****************

quietly tab arbitrator, gen(aa)

probit ewin agente agentu wageave murray ruderman dorf glickman salsberg danser loccke correia solomon ross colflesh pop5-popstate y2-y18 if wagesamp
dprobit ewin agente agentu wageave murray ruderman dorf glickman salsberg danser loccke correia solomon ross colflesh pop5-popstate y2-y18 if wagesamp
test agente=-agentu
test murray ruderman dorf glickman salsberg danser
test loccke correia solomon ross colflesh
probit ewin agente agentu wageave pop5-popstate y2-y18 if wagesamp & loccke
dprobit ewin agente agentu wageave pop5-popstate y2-y18 if wagesamp & loccke
probit ewin agente agentu wageave pop* aa* y2-y18 if wagesamp
dprobit ewin agente agentu wageave pop* aa* y2-y18 if wagesamp
test agente=-agentu
testparm aa*
probit ewin agente agentu wageave pop* docyear docyear2 docyear3 if wagesamp & mitrani
dprobit ewin agente agentu wageave pop* docyear docyear2 docyear3 if wagesamp & mitrani
test agente=-agentu
probit ewin agente agentu wageave pop* y2-y18 if wagesamp & !(popmiss|popstate|pop100|pop50100)
dprobit ewin agente agentu wageave pop* y2-y18 if wagesamp & !(popmiss|popstate|pop100|pop50100)
test agente=-agentu
probit ewin agente agentu wageave pop* docyear* if wagesamp & (popstate|pop100|pop50100)
dprobit ewin agente agentu wageave pop* docyear* if wagesamp & (popstate|pop100|pop50100)
test agente=-agentu

drop aa*

*****************
*****Table 6*****
*****************

*drop cases with non-missing arbitration outcomes for Table 6
drop if ewin==.

sort muni docyear docnum

*create variable for number of times a municipality has been to arbitration
gen casenum=.
replace casenum=1 if muni!=muni[_n-1]
replace casenum=casenum[_n-1]+1 if muni==muni[_n-1]
replace casenum=5 if casenum>=5 & casenum!=.
tab casenum, gen(cc)
bys muni: egen totcasenum=max(casenum)

*create indicator for cases decided at least 12 months apart (eliminate simultaneous cases)
gen lagsetdist=12*(year-year[_n-1]) + (month-month[_n-1]) if muni==muni[_n-1]
replace lagsetdist=lagsetdist+12 if year==year[_n-1]+2 & muni==muni[_n-1]

*create indicator for lagged case where union used an agent but the employer did not
gen lagagent01=1 if !agente[_n-1] & agentu[_n-1] & muni==muni[_n-1]

*create indicator for lagged case with employer loss and union used an agent but the employer did not
gen lageloss01=ewin[_n-1]==0 & !agente[_n-1] & agentu[_n-1] & muni==muni[_n-1]

*****Summary statistics for Table 1
save temp, replace
collapse (mean) totcasenum, by(muni)
tab totcasenum
use temp, replace
keep if wagesamp
collapse (mean) totcasenum, by(muni)
tab totcasenum
use temp, replace

*****Table 6, columns 1 and 2
*restrict sample to cases where agent use by the bargaining pair varies over time
by muni: egen test00=mean(agent00)
by muni: egen test01=mean(agent01)
by muni: egen test10=mean(agent10)
by muni: egen test11=mean(agent11)
gen cc34=cc3|cc4
areg agente cc2 cc34 cc5 nyr* onlywages onlybenefits fire other if test01!=1 & test10!=1 & test00!=1 & test11!=1, absorb(muni)
areg agentu cc2 cc34 cc5 nyr* onlywages onlybenefits fire other if test01!=1 & test10!=1 & test00!=1 & test11!=1, absorb(muni)

*****Table 6, columns 3 and 4
*Note: There is a typo in the paper.  In column (4) the marginal effect in brackets should be .180 and the sample size should be 106.
*      The probit estimate in this column is correct; only the marginal effect corresponding to the probit estimate is a typo.

probit agente lageloss01 pop* fire docyear* nyr* onlywages onlybenefits fire other if lagagent01==1 & lagsetdist>=12 & lagsetdist!=.
dprobit agente lageloss01 pop* fire docyear* nyr* onlywages onlybenefits fire other if lagagent01==1 & lagsetdist>=12 & lagsetdist!=.
probit agentu lageloss01 pop* fire  docyear* nyr* onlywages onlybenefits fire other if lagagent01==1 & lagsetdist>=12 & lagsetdist!=.
dprobit agentu lageloss01 pop* fire  docyear* nyr* onlywages onlybenefits fire other if lagagent01==1 & lagsetdist>=12 & lagsetdist!=.

*****Table 6, columns 5 and 6
*Note: Estimates reported in the paper differ slightly, as a different set of control variables was used. This code uses the same
*      control variables used in the rest of the paper and Stata program.
*Note: Paper uses lambda to denote variances, while the code uses lambda to denote precision (precision=1/variance)

gen alpha_ehat=.
gen alpha_uhat=.
gen lambda_ehat=.
gen lambda_uhat=.

forvalues i=78(1)95 {
  di "docyear: `i'"
  probit ewin agente agentu if docyear<=`i'
  replace alpha_ehat=_b[agente] if docyear==`i'+1
  replace alpha_uhat=_b[agentu] if docyear==`i'+1
  replace lambda_ehat=1/(_se[agente]^2) if docyear==`i'+1
  replace lambda_uhat=1/(_se[agentu]^2) if docyear==`i'+1
}

global alpha0_star=.08
global alpha0_plus=-.87
*Note: variance=.41, so precision=2.44
global lambda0_star=2.44
global lambda0_plus=2.44

gen alpha_star = (($lambda0_star*$alpha0_star)+(lambda_ehat*alpha_ehat))/($lambda0_star + lambda_ehat)
gen alpha_plus = (($lambda0_plus*$alpha0_plus)+(lambda_uhat*alpha_uhat))/($lambda0_plus + lambda_uhat)

replace alpha_star=.08 if docyear==78
replace alpha_plus=-.87 if docyear==78

probit agente alpha_star pop5-pop1525 pop50100-popstate popmiss nyr2 nyr3 nyrmiss fire other onlybenefits onlywages if ewin!=.
probit agentu alpha_plus pop5-pop1525 pop50100-popstate popmiss nyr2 nyr3 nyrmiss fire other onlybenefits onlywages if ewin!=.

log close
