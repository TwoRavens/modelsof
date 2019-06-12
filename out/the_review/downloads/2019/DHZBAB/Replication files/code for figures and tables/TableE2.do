use FNIdataset_19201pc, clear

* parents' characteristics
* father US citizen
gen popcit=.
replace popcit=1 if citizen_pop==2
replace popcit=0 if citizen_pop==3
* mother US citizen
gen momcit=.
replace momcit=1 if citizen_mom==2
replace momcit=0 if citizen_mom==3


gen postwar=(birthyear>=1917)
gen intercitpop=postwar*popcit
gen intercitmom=postwar*momcit


* regressions
estimates clear
xi: reg GNI i.birthyear intercitpop popcit if fbpl==453&(yrnatur_pop<1914|popcit==0), ro
eststo m2
xi: reg GNI i.birthyear intercitmom momcit if mbpl==453&(yrnatur_mom<1914|momcit==0), ro
eststo m3
esttab m* using "TableE2.csv", star(* 0.1 ** 0.05 *** 0.01) replace cells(b(fmt(a3) star) se(par)) stats(N r2) keep( popcit momcit inter*) 
