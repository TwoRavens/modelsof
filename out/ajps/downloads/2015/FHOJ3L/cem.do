clear all
use "/Users/carlyurban/Documents/FECForGenMatch"
drop if per_coll==.
bysort StFIPS: egen MeanTreatment=mean(Treatment)
drop if MeanTreatment==1|MeanTreatment==0
save "/Users/carlyurban/Documents/FECForCEM", replace
*2, 5, 1, 7, 9, 10, 14, 24, 26, 27, 32, 34, 35
clear all
capture log close
set more off
log using "/Users/carlyurban/Documents/FEClogcem.smcl", replace
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==1
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel replace

clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==2
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  
reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==3
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  
reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==4
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==5
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==6
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==7
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)


keep if g==8
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==9
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==10
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==11
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==12
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==13
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==14
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)

keep if g==15
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)


keep if g==16
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==17
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==18
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==19
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==20
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==21
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==22
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==23
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
clear all
capture log close
log using "/Users/carlyurban/Documents/FEClogcem.smcl", append
use "/Users/carlyurban/Documents/FECForCEM"
drop if per_coll==.
gen Y=Cont
gen att=.
gen SE=.
egen g=group(StFIPS)
levelsof g, local(g)
keep if g==24
cem Inc PercentHispanic PercentBlack density  per_college   CanCommute, tr(Treatment)  

reg Cont  Treat   Inc PercentHispanic PercentBlack density  per_college CanCommute [iweight=cem_weights]
eststo 
outreg2 using Cem2.xml,  excel append
