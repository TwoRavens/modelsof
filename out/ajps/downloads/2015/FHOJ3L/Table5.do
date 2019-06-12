
 clear all
 use "U:\FEC\Table5.dta"
 g Treat=.
 replace Treat=1 if TotAds>1000
 replace Treat=0 if TotAds<=1000
 
 g Y08=.
 replace Y08=1 if year==2008
 replace Y08=0 if year==2004
 
 g TreatY08=.
 replace TreatY08=Y08*Treat
 destring zip, replace
 g TreatY04=.
replace TreatY04=(1-Y08)*Treat

 g NonCompBoth=0
 replace NonCompBoth=1 if NonComp==1 &Y08==1 
 replace NonCompBoth=1 if NonComp==1 &Y08==0
 
 
 g NonComp04=0
 replace NonComp04=1 if NonComp==1 &Y08==0
 
 g NonComp08=0
 replace NonComp08=1 if NonComp==1 &Y08==1
 
 drop if NonComp==0
g logDollars=log(Cont+0.001)
g logCont=log(Cont*1000+1)

 **Diff in Diff
 egen g=group(State)
 tostring g, replace
 tostring DMACode, replace
 
 gen StDMA=g+DMACode
 label variable StDMA "NOT A REAL STATE DMA CODE, JUST FOR CLUSTERS"
 tostring zip, gen(zip2)
 rename zip zip3
 rename zip2 zip
 merge m:1 zip using "U:/FEC/ZipSupport.dta"
 drop if _merge==2
gen CanCommute=1 if perout>5
replace CanCommute=0 if perout<=5

 *keep if Switcher==1
 destring zip, replace
xtset zip
 
xtreg Cont Y08 Treat if NonComp==1 & Switcher==1 , fe cluster(StDMA) robust
eststo
xtreg Cont Y08 Treat if NonComp==1 & Switcher==1 &CanCommute==0, fe cluster(StDMA) robust 
eststo
xtreg Cont Y08 Treat TreatY08 if NonComp==1, fe cluster(StDMA) robust
eststo
xtreg Cont Y08 Treat TreatY08 if NonComp==1&CanCommute==0, fe cluster(StDMA) robust
eststo
esttab using "U:\FEC\SeptemberRevisionsFieldPaper\DiffInDiff_Table5.tex", se r2 star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear

**Making sure that reducing to the "support only sample" prudces robust results. 
xtreg Cont Y08 Treat if NonComp==1 & Switcher==1 & _support==1&_merge==3==1 , fe cluster(StDMA) robust 
eststo
xtreg Cont Y08 Treat TreatY08 if NonComp==1&CanCommute==0 & _support==1&_merge==3==1, fe cluster(StDMA) robust
eststo


scalar Ngamma=_b[Treat]
scalar Nalpha=_b[Y08]

areg Cont Y08 TreatY08 TreatY04 if NonComp==1&_support==1&_merge==3, a(zip) cluster(StDMA) robust

test _b[TreatY08]=_b[TreatY04]

esttab using "U:\FEC\SeptemberRevisionsFieldPaper\DiffInDiff_Table5_Robust.tex", se r2 star(* 0.10 ** 0.05 *** 0.01) replace
eststo clear

 