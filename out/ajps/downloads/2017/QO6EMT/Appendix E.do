** Issue Voting as a Constrained Choice Problem - Moral and Zhirnov (2017)
** Replication File (Appendix E: Extensions and Robustness Checks)

clear all
* cd "/Users/mmoral/Dropbox/SUNY Binghamton PhD/Miscellaneous/-Issue Voting as a Constrained Choice Problem/AJPS Final/Replication/Analyses Code"
* cd "/home/andrei/Desktop/replication materials"

** Programs
use "NSD1989 v1.dta", clear

* Conditional logistic regression
prog drop _all
program define condlog
	args todo b lnf
	tempvar deno vc
	mleval `vc'=`b',eq(1)
	sort id choice
	qui by id: gen double `deno'=sum(exp(`vc')) 
	mlsum `lnf'=`vc'-ln(`deno') if choice==1 
end

* Constrained choice conditional logistic regression 
program define cccl
	args todo b lnf
	tempvar deno vc cs
	mleval `vc'=`b',eq(1) 
	mleval `cs'=`b',eq(2) 
	sort id choice
	qui by id: gen double `deno'=sum(exp(`vc'-ln(1+exp(-`cs'))))
	mlsum `lnf'= (`vc'-ln(1+exp(-`cs'))-ln(`deno')) if choice==1
end

** Estimations
* Models P4 & D4 - Party policy extremity is replaced w/ respondents' evaluation of party extremity
qui clogit choice chprox* constvar1 tooextreme constvar3, group(id)
mat beta=(e(b), 0)
ml model d0 cccl (choice=chprox*, nocons)(constvar1 tooextreme constvar3)
ml init beta,copy
eststo m1d: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1d=(e(b))

qui clogit choice chdir* constvar1 tooextreme constvar3, group(id)
mat beta=(e(b), 0)
ml model d0 cccl (choice=chdir*,nocons)(constvar1 tooextreme constvar3)
ml init beta,copy
eststo m2d: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2d=(e(b))

* Models P5 & D5 - Party policy extremity is replaced w/ the difference between the party's and the voter's policy extremity scores
qui clogit choice chprox* constvar1 ivec constvar3, group(id)
mat beta=(e(b), 0)
ml model d0 cccl (choice=chprox*,nocons)(constvar1 ivec  constvar3)
ml init beta,copy
eststo m1e: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1e=(e(b))

qui clogit choice chdir* constvar1 ivec constvar3, group(id)
mat beta=(e(b), 0)
ml model d0 cccl (choice=chdir*,nocons)(constvar1 ivec constvar3)
ml init beta,copy
eststo m2e: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2e=(e(b))

* Models P6 & D6 - Neutral point/origin is replaced w/ the median voter's policy stand
qui clogit choice chprox* constvar1 alt2vec constvar3, group(id)
mat beta=(e(b), 0)
ml model d0 cccl (choice=chprox*,nocons)(constvar1 alt2vec constvar3)
ml init beta,copy
eststo m1f: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1f=(e(b))

qui clogit choice alt2prod* constvar1 alt2vec constvar3, group(id)
mat beta=(e(b), 0)
ml model d0 cccl (choice=alt2prod*,nocons)(constvar1 alt2vec constvar3)
ml init beta,copy
eststo m2f: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2f=(e(b))

* Models P7 & D7 - Crime dimension is dropped from the model equation and from the calculation of the policy extremity variable (i.e., vector length is based on the remaining six scales)
qui clogit choice chprox1 chprox2 chprox3 chprox4 chprox5 chprox6 constvar1 vec6 constvar3, group(id)
mat beta=(e(b), 0)
ml model d0 cccl (choice=chprox1 chprox2 chprox3 chprox4 chprox5 chprox6,nocons)(constvar1 vec6 constvar3)
ml init beta,copy
eststo m1g: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1g=(e(b))

qui clogit choice chdir1 chdir2 chdir3 chdir4 chdir5 chdir6 constvar1 vec6 constvar3, group(id)
mat beta=(e(b), 0)
ml model d0 cccl (choice=chdir1 chdir2 chdir3 chdir4 chdir5 chdir6,nocons)(constvar1 vec6 constvar3)
ml init beta,copy
eststo m2g: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2g=(e(b))
save sample1,replace

** Individual-level controls
use sample1,clear /* Dropping missing data and generating the interaction terms */
global controls alch agro urban union
foreach var of varlist $controls {
by id, sort: drop if _n == sum(mi(`var'))
}
foreach var of varlist $controls {
forval j=2/7 {
qui gen _I_`var'_p`j'=cond(party==`j',`var',0)
}
} 
foreach var of varlist union inc {
qui gen _I_`var'_lab=cond(party==1,`var',0)
qui gen _I_`var'_soc=cond(party==6,`var',0)
}
gen _I_rel_chr=cond(party==4,rel,0)
save sample2,replace

* Models P8 & D8 - w/ all individual-level controls (i.e., teetotaler, agricultural worker, urban dweller, trade union member)
use sample2,clear
global controls _I_alch_p* _I_agro_p* _I_urban_p* _I_union_p*
qui clogit choice chprox* $controls constvar1 constvar2 constvar3, group(id)
mat beta=(e(b), 0)
ml clear
ml model d0 cccl (choice=chprox* $controls, nocons)(constvar1 constvar2 constvar3)
ml init beta,copy
eststo m1h: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1h=(e(b))

qui clogit choice chdir* $controls constvar1 constvar2 constvar3, group(id)
mat beta=(e(b), 0)
ml model d0 cccl (choice=chdir* $controls, nocons)(constvar1 constvar2 constvar3)
ml init beta,copy
eststo m2h: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2h=(e(b))

* Models P9 & D9 - w/ only individual-level controls from Adams and Merrill (1999, 778)
global controls _I_alch_p4 _I_agro_p3 _I_urban_p2 _I_urban_p3 _I_union_lab _I_union_soc _I_inc_lab _I_inc_soc _I_rel_chr
qui clogit choice chprox* $controls constvar1 constvar2 constvar3, group(id)
keep if e(sample)
mat beta=(e(b), 0)
ml model d0 cccl (choice=chprox* $controls, nocons)(constvar1 constvar2 constvar3)
ml init beta,copy
eststo m1i: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m1i=(e(b))

qui clogit choice chdir* $controls constvar1 constvar2 constvar3, group(id)
mat beta=(e(b), 0)
ml model d0 cccl (choice=chdir* $controls,nocons)(constvar1 constvar2 constvar3)
ml init beta,copy
eststo m2i: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3) 
mat b_m2i=(e(b))

** Tables
** Tables A9: Extensions and Robustness Checks: CCCL Based on the Proximity Theory
esttab m1d m1e m1f m1g m1h m1i using "TableA9.tex", ///
tex replace b(%10.3f) se stats(ll aic bic N, labels("Log lik." "AIC" "BIC" "Obs") fmt(%10.1f %10.1f %10.1f %10.0f)) starlevels(* 0.05 ** 0.01) ///
varlabels(_cons Constant) addnote("Standard errors in parentheses. Two-tailed tests.") alignment(l) nogaps /// 
nodepvars label nonumbers compress nobase noomit obslast long mtitle("(P4)" "(P5)" "(P6)" "(P7)" "(P8)" "(P9)")

** Table A10: Extensions and Robustness Checks: CCCL Based on the Directional Theory
esttab m2d m2e m2f m2g m2h m2i using "TableA10.tex", ///
tex replace b(%10.3f) se stats(ll aic bic N, labels("Log lik." "AIC" "BIC" "Obs") fmt(%10.1f %10.1f %10.1f %10.0f)) starlevels(* 0.05 ** 0.01) ///
varlabels(_cons Constant) addnote("Standard errors in parentheses. Two-tailed tests.") alignment(l) nogaps /// 
nodepvars label nonumbers compress nobase noomit obslast long mtitle("(D4)" "(D5)" "(D6)" "(D7)" "(D8)" "(D9)")

** Programs: Unified model
* Conditional logistic regression
program define unified_a
	args lnf mu beta1 beta2 beta3 beta4 beta5 beta6 beta7
	tempvar deno vc dirpart proxpart
	qui gen double `dirpart'=chdir1*`beta1' + chdir2*`beta2' + chdir3*`beta3' +  chdir4*`beta4' + chdir5*`beta5' + chdir6*`beta6' + chdir7*`beta7'
	qui gen double `proxpart'=chprox1*`beta1' + chprox2*`beta2' + chprox3*`beta3' +  chprox4*`beta4' + chprox5*`beta5' + chprox6*`beta6' + chprox7*`beta7'
	qui gen double `vc'= 2*(1-`mu')*`dirpart' -`mu'*`proxpart'
	sort id choice
	qui by id: gen double `deno'=sum(exp(`vc')) 
	qui replace `lnf'=(`vc'-ln(`deno'))*choice
end

* Conditional logistic regression w/ all choice-set determinants
program define unified_b
	args lnf mu beta1 beta2 beta3 beta4 beta5 beta6 beta7 beta8 beta9 beta10
	tempvar deno vc dirpart proxpart
	qui gen double `dirpart'=chdir1*`beta1' + chdir2*`beta2' + chdir3*`beta3' +  chdir4*`beta4' + chdir5*`beta5' + chdir6*`beta6' + chdir7*`beta7'
	qui gen double `proxpart'=chprox1*`beta1' + chprox2*`beta2' + chprox3*`beta3' +  chprox4*`beta4' + chprox5*`beta5' + chprox6*`beta6' + chprox7*`beta7'
	qui gen double `vc'= 2*(1-`mu')*`dirpart' -`mu'*`proxpart' + constvar1*`beta8' + constvar2*`beta9' + constvar3*`beta10'
	sort id choice
	qui by id: gen double `deno'=sum(exp(`vc')) 
	qui replace `lnf'=(`vc'-ln(`deno'))*choice
end

* Conditional logistic regression wo/ policy extremity
program define unified_b2
	args lnf mu beta1 beta2 beta3 beta4 beta5 beta6 beta7 beta8 beta10
	tempvar deno vc dirpart proxpart
	qui gen double `dirpart'=chdir1*`beta1' + chdir2*`beta2' + chdir3*`beta3' +  chdir4*`beta4' + chdir5*`beta5' + chdir6*`beta6' + chdir7*`beta7'
	qui gen double `proxpart'=chprox1*`beta1' + chprox2*`beta2' + chprox3*`beta3' +  chprox4*`beta4' + chprox5*`beta5' + chprox6*`beta6' + chprox7*`beta7'
	qui gen double `vc'= 2*(1-`mu')*`dirpart' -`mu'*`proxpart' + constvar1*`beta8' + constvar3*`beta10'
	sort id choice
	qui by id: gen double `deno'=sum(exp(`vc')) 
	qui replace `lnf'=(`vc'-ln(`deno'))*choice
end

* Constrained choice conditional logistic regression w/ all choice-set determinants
program define unified_c
	args lnf mu beta1 beta2 beta3 beta4 beta5 beta6 beta7 gamma1 gamma2 gamma3 gamma0
	tempvar deno vc dirpart proxpart cs
	qui gen double `dirpart'=chdir1*`beta1' + chdir2*`beta2' + chdir3*`beta3' +  chdir4*`beta4' + chdir5*`beta5' + chdir6*`beta6' + chdir7*`beta7'
	qui gen double `proxpart'=chprox1*`beta1' + chprox2*`beta2' + chprox3*`beta3' +  chprox4*`beta4' + chprox5*`beta5' + chprox6*`beta6' + chprox7*`beta7'
	qui gen double `vc'= 2*(1-`mu')*`dirpart' -`mu'*`proxpart'
	qui gen double `cs'= constvar1*`gamma1' + constvar2*`gamma2' + constvar3*`gamma3' + `gamma0'
	sort id choice
	qui by id: gen double `deno'=sum(exp(`vc'-ln(1+exp(-`cs'))))
	qui replace `lnf'= (`vc'-ln(1+exp(-`cs'))-ln(`deno'))*choice
end

* Constrained choice conditional logistic regression wo/ policy extremity
program define unified_c2
	args lnf mu beta1 beta2 beta3 beta4 beta5 beta6 beta7 gamma1 gamma3 gamma0
	tempvar deno vc dirpart proxpart cs
	qui gen double `dirpart'=chdir1*`beta1' + chdir2*`beta2' + chdir3*`beta3' +  chdir4*`beta4' + chdir5*`beta5' + chdir6*`beta6' + chdir7*`beta7'
	qui gen double `proxpart'=chprox1*`beta1' + chprox2*`beta2' + chprox3*`beta3' +  chprox4*`beta4' + chprox5*`beta5' + chprox6*`beta6' + chprox7*`beta7'
	qui gen double `vc'= 2*(1-`mu')*`dirpart' -`mu'*`proxpart'
	qui gen double `cs'= constvar1*`gamma1' + constvar3*`gamma3' + `gamma0'
	sort id choice
	qui by id: gen double `deno'=sum(exp(`vc'-ln(1+exp(-`cs'))))
	qui replace `lnf'= (`vc'-ln(1+exp(-`cs'))-ln(`deno'))*choice
end

** Estimations
** Norway (1989)
use "NSD1989 v1.dta", clear

order chdir*,sequential
qui clogit choice chdir*,group(id)
matrix initial=(0.5,e(b))
ml model lf unified_a /mu /beta1 /beta2 /beta3 /beta4 /beta5 /beta6 /beta7
ml init initial, copy
eststo u_a: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
matrix m_ua=(e(b))

order chdir* constvar*,sequential
qui clogit choice chdir* constvar*,group(id)
matrix initial=(0.5,e(b))
ml model lf unified_b /mu /beta1 /beta2 /beta3 /beta4 /beta5 /beta6 /beta7 /beta8 /beta9 /beta10
ml init initial, copy
eststo u_b: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
matrix m_ub=(e(b))

matrix initial=(m_ub,0)
ml model lf unified_c /mu /beta1 /beta2 /beta3 /beta4 /beta5 /beta6 /beta7 /gamma1 /gamma2 /gamma3 /gamma0
ml init initial, copy
eststo u_c: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
matrix m_uc=(e(b))

order chdir* constvar*,sequential
qui clogit choice chdir* constvar1 constvar3,group(id)
matrix initial=(0.5,e(b))
ml model lf unified_b2 /mu /beta1 /beta2 /beta3 /beta4 /beta5 /beta6 /beta7 /beta8 /beta10
ml init initial, copy
eststo u_b2: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
matrix m_ub2=(e(b))

matrix initial=(m_ub2,0)
ml model lf unified_c2 /mu /beta1 /beta2 /beta3 /beta4 /beta5 /beta6 /beta7 /gamma1 /gamma3 /gamma0
ml init initial, copy
eststo u_c2: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
matrix m_uc2=(e(b))

** Table A11: Parliamentary Election in Norway (1989)
esttab u_a u_b u_c u_b2 u_c2 using "TableA11.csv", csv replace b(%10.3f) se stats(ll aic bic N, labels("Log lik." "AIC" "BIC" "Obs") fmt(%10.1f %10.1f %10.1f %10.0f)) ///
starlevels(* 0.05 ** 0.01) varlabels(_cons Constant) nonote addnote("Standard errors in parentheses. Two-tailed tests.") ///
alignment(l) nogaps nodepvars label nonumbers compress nobase noomit obslast long mtitle("(U1)" "(U2)" "(U3)" "(U2*)" "(U3*)")

** United Kingdom (1987)
use  "BES87 v1.dta", clear

order chdir*,sequential
qui clogit choice chdir*,group(id)
matrix initial=(0.5,e(b))
ml model lf unified_a /mu /beta1 /beta2 /beta3 /beta4 /beta5 /beta6 /beta7
ml init initial, copy
eststo u_a: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
matrix m_ua=(e(b))

order chdir* constvar*,sequential
qui clogit choice chdir* constvar1 constvar3,group(id)
matrix initial=(0.5,e(b))
ml model lf unified_b2 /mu /beta1 /beta2 /beta3 /beta4 /beta5 /beta6 /beta7 /beta8 /beta10
ml init initial, copy
eststo u_b2: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
matrix m_ub2=(e(b))

matrix initial=(m_ub2,0)
ml model lf unified_c2 /mu /beta1 /beta2 /beta3 /beta4 /beta5 /beta6 /beta7 /gamma1 /gamma3 /gamma0
ml init initial, copy
eststo u_c2: ml maximize, showeqns difficult ltolerance(1e-5) nrtolerance(1e-3)
matrix m_uc2=(e(b))

* Table A12: Parliamentary Election in the United Kingdom (1987)
esttab u_a u_b2 u_c2 using "TableA12.csv", csv replace b(%10.3f) se stats(ll aic bic N, labels("Log lik." "AIC" "BIC" "Obs") fmt(%10.1f %10.1f %10.1f %10.0f)) ///
starlevels(* 0.05 ** 0.01) varlabels(_cons Constant) nonote addnote("Standard errors in parentheses. Two-tailed tests.") ///
alignment(l) nogaps nodepvars label nonumbers compress nobase noomit obslast long mtitle("(U1)" "(U2*)" "(U3*)")
