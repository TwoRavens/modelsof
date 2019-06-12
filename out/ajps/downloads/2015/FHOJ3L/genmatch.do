clear all
capture log close
set more off
log using "/Users/carlyurban/Documents/FEClog.smcl", replace
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==1
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==2
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==3
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==4
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==5
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==6
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==7
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)


keep if g==8
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==9
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==10
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==11
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==12
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==13
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==14
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==15
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)


keep if g==16
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==17
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==18
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==19
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==20
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==21
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==22
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==23
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==24
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==25
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==26
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==27
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)


keep if g==28
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==29
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==30
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==31
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==32
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
keep if g==33
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==34
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==35
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClog.smcl", append
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==36
genmatch Inc PercentHispanic PercentBlack density      per_college   , tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
return list




*genmatch Inc PercentHispanic PercentBlack density      per_college   if g==1, tr(Treatment)  bal(Inc PercentHispanic PercentBlack density      per_college   ) estimand("ATT") popsize(16) maxgenerations(10) waitgenerations(1) y(Y) mbnboots(500)
