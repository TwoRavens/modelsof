							*******
**** Tables and figures for ITALIAN POLITICAL SCIENCE REVIEW article ******
							*******

use "italy2013_dataset.dta", clear

*TAB 1a
ta candidate, su(support)
*TAB 1b
ta leader, su(support)


* FIG 2a
ciplot support if candidate!=. & racetypcand!= 2, by(racetypcand) ysc (r(0 0.8)) ylabel(0(0.2)0.6) 

*FIG 2b
ciplot support if leader!=., by(racetyplead) ysc (r(0 0.6)) ylabel(0(0.2)0.6) 

* FIG 3a
ciplot support if candidate!=. & sextypcand!= 2, by(sextypcand) ysc (r(0 0.6)) ylabel(0(0.2)0.6) 

* FIG 3b
ciplot support if leader!=. & sextypcand!= 2, by(sextyplead) ysc (r(0 0.6)) ylabel(0(0.2)0.6) 

* FIG 4a
ciplot support if candidate!=., by(inoutcand) ysc (r(0 0.8)) ylabel(0(0.2)0.8) 

* FIG 4b 
ciplot support if leader!=., by(inoutlead) ysc (r(0 0.8)) ylabel(0(0.2)0.8) 
 
* FIG 5a
reg support cgender gender inoutcand##sextypcand if sextypcand!=2
margins inoutcand, by(sextypcand)
marginsplot, title ("") ytitle ("Predicted CSI", size(large))

* FIG 5b
reg support cgender gender inoutcand##racetypcand if racetypcand!=2
margins inoutcand, by(racetypcand)
marginsplot, title ("") ytitle ("Predicted CSI", size(large))

