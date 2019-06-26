
*dd estimation for torture 020613

*Table II - 1 month pre and post treatment
use "/Users/christophersullivan/Documents/R/torture_paper/matching outputs/matcheddata.dta", clear

*duplicate the matched sample to identify the month prior to treatmentexpand 2
sort id

gen minus1=0
replace minus1=1 if id==id[_n-1]
gen plus1=0
replace plus1=1 if minus1==0

gen statecountDD=0replace statecountDD=lagstate1 if minus1==1
replace statecountDD=futstate1 if plus1==1



gen TT1=0replace TT1=treat*plus1


reg statecountDD TT1 treat plus1, cluster(id)


gen statespatDD=0replace statespatDD=lagstatespat1 if minus1==1
replace statespatDD=futstatespat1 if plus1==1

replace TT1=0replace TT1=treat*plus1

reg statespatDD TT1 treat  plus1, cluster(id)




gen rebcountDD=0replace rebcountDD=lagreb1 if minus1==1
replace rebcountDD=futreb1 if plus1==1

replace TT1=0replace TT1=treat*plus1

reg rebcountDD TT1 treat  plus1, cluster(id)


gen rebspatDD=0replace rebspatDD=lagrebspat1 if minus1==1
replace rebspatDD=futrebspat1 if plus1==1

replace TT1=0replace TT1=treat*plus1

reg rebspatDD TT1 treat  plus1, cluster(id) 





*Table III replciate 6 months prior to and post treatment
use "/Users/christophersullivan/Documents/R/torture_paper/matching outputs/matcheddata.dta", clear

expand 12
sort id

gen plus6=0
replace plus6=1 if id==id[_n-11]
gen plus5=0
replace plus5=1 if id==id[_n-10] & plus6==0
gen plus4=0
replace plus4=1 if id==id[_n-9] & plus6==0 & plus5==0gen plus3=0
replace plus3=1 if id==id[_n-8] & plus6==0 & plus5==0 & plus4==0
gen plus2=0
replace plus2=1 if id==id[_n-7] & plus6==0 & plus5==0 & plus4==0 & plus3==0
gen plus1=0
replace plus1=1 if id==id[_n-6] & plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0
gen minus1=0
replace minus1=1 if id==id[_n-5] & plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0 & plus1==0
gen minus2=0
replace minus2=1 if id==id[_n-4] & plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0 & plus1==0 & minus1==0
gen minus3=0
replace minus3=1 if id==id[_n-3] & plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0 & plus1==0 & minus1==0 & minus2==0
gen minus4=0
replace minus4=1 if id==id[_n-2] & plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0 & plus1==0 & minus1==0 & minus2==0 & minus3==0
gen minus5=0
replace minus5=1 if id==id[_n-1] & plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0 & plus1==0 & minus1==0 & minus2==0 & minus3==0 & minus4==0
gen minus6=0
replace minus6=1 if plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0 & plus1==0 & minus1==0 & minus2==0 & minus3==0 & minus4==0 & minus5==0


gen statecountDD=0
replace statecountDD=lagstate6 if minus6==1
replace statecountDD=lagstate5 if minus5==1
replace statecountDD=lagstate4 if minus4==1replace statecountDD=lagstate3 if minus3==1
replace statecountDD=lagstate2 if minus2==1
replace statecountDD=lagstate1 if minus1==1
replace statecountDD=futstate1 if plus1==1
replace statecountDD=futstate2 if plus2==1
replace statecountDD=futstate3 if plus3==1
replace statecountDD=futstate4 if plus4==1
replace statecountDD=futstate5 if plus5==1
replace statecountDD=futstate6 if plus6==1

gen TT1=0replace TT1=treat*plus1
gen TT2=0replace TT2=treat*plus2
gen TT3=0replace TT3=treat*plus3
gen TT4=0replace TT4=treat*plus4
gen TT5=0replace TT5=treat*plus5
gen TT6=0replace TT6=treat*plus6


reg statecountDD TT1 TT2 TT3 TT4 TT5 TT6 treat plus6 plus5 plus4 plus3 plus2 plus1, cluster(id)


gen statespatDD=0
replace statespatDD =lagstatespat6 if minus6==1
replace statespatDD =lagstatespat5 if minus5==1
replace statespatDD =lagstatespat4 if minus4==1replace statespatDD =lagstatespat3 if minus3==1
replace statespatDD =lagstatespat2 if minus2==1
replace statespatDD =lagstatespat1 if minus1==1
replace statespatDD =futstatespat1 if plus1==1
replace statespatDD =futstatespat2 if plus2==1
replace statespatDD =futstatespat3 if plus3==1
replace statespatDD =futstatespat4 if plus4==1
replace statespatDD =futstatespat5 if plus5==1
replace statespatDD =futstatespat6 if plus6==1
reg statespatDD TT1 TT2 TT3 TT4 TT5 TT6 treat plus6 plus5 plus4 plus3 plus2 plus1, cluster(id)



gen rebDD=0
replace rebDD = lagreb6 if minus6==1
replace rebDD = lagreb5 if minus5==1
replace rebDD = lagreb4 if minus4==1replace rebDD = lagreb3 if minus3==1
replace rebDD = lagreb2 if minus2==1
replace rebDD = lagreb1 if minus1==1
replace rebDD = futreb1 if plus1==1
replace rebDD = futreb2 if plus2==1
replace rebDD = futreb3 if plus3==1
replace rebDD = futreb4 if plus4==1
replace rebDD = futreb5 if plus5==1
replace rebDD = futreb6 if plus6==1
reg rebDD TT1 TT2 TT3 TT4 TT5 TT6 treat plus6 plus5 plus4 plus3 plus2 plus1, cluster(id)



gen rebspatDD=0
replace rebspatDD = lagrebspat6 if minus6==1
replace rebspatDD = lagrebspat5 if minus5==1
replace rebspatDD = lagrebspat4 if minus4==1replace rebspatDD = lagrebspat3 if minus3==1
replace rebspatDD = lagrebspat2 if minus2==1
replace rebspatDD = lagrebspat1 if minus1==1
replace rebspatDD = futrebspat1 if plus1==1
replace rebspatDD = futrebspat2 if plus2==1
replace rebspatDD = futrebspat3 if plus3==1
replace rebspatDD = futrebspat4 if plus4==1
replace rebspatDD = futrebspat5 if plus5==1
replace rebspatDD = futrebspat6 if plus6==1
reg rebspatDD TT1 TT2 TT3 TT4 TT5 TT6 treat plus6 plus5 plus4 plus3 plus2 plus1, cluster(id)




use "/Users/christophersullivan/Documents/R/torture_paper/matching outputs/matcheddata.dta", clear

*duplicate the matched sample to identify the month prior to treatmentexpand 2
sort id

gen minus1=0
replace minus1=1 if id==id[_n-1]
gen plus1=0
replace plus1=1 if minus1==0


*placebo test 1

gen pretreat=0
replace pretreat=1 if treat[_n+1]==1
gen pTT1=0replace pTT1=pretreat*plus1
replace statecountDD=0
replace statecountDD=lagstate2 if minus1==1
replace statecountDD=lagstate1 if plus1==1
reg statecountDD pTT1 pretreat plus1, cluster(id)

*placebo test2
replace statecountDD=lagstate1 if minus1==1
replace statecountDD=statecount if plus1==1
reg statecountDD pTT1 pretreat plus1, cluster(id)


*granger causality test
use "/Users/christophersullivan/Documents/R/torture_paper/matching outputs/matcheddata.dta", clear

expand 12
sort id

gen plus6=0
replace plus6=1 if id==id[_n-11]
gen plus5=0
replace plus5=1 if id==id[_n-10] & plus6==0
gen plus4=0
replace plus4=1 if id==id[_n-9] & plus6==0 & plus5==0gen plus3=0
replace plus3=1 if id==id[_n-8] & plus6==0 & plus5==0 & plus4==0
gen plus2=0
replace plus2=1 if id==id[_n-7] & plus6==0 & plus5==0 & plus4==0 & plus3==0
gen plus1=0
replace plus1=1 if id==id[_n-6] & plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0
gen minus1=0
replace minus1=1 if id==id[_n-5] & plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0 & plus1==0
gen minus2=0
replace minus2=1 if id==id[_n-4] & plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0 & plus1==0 & minus1==0
gen minus3=0
replace minus3=1 if id==id[_n-3] & plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0 & plus1==0 & minus1==0 & minus2==0
gen minus4=0
replace minus4=1 if id==id[_n-2] & plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0 & plus1==0 & minus1==0 & minus2==0 & minus3==0
gen minus5=0
replace minus5=1 if id==id[_n-1] & plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0 & plus1==0 & minus1==0 & minus2==0 & minus3==0 & minus4==0
gen minus6=0
replace minus6=1 if plus6==0 & plus5==0 & plus4==0 & plus3==0 & plus2==0 & plus1==0 & minus1==0 & minus2==0 & minus3==0 & minus4==0 & minus5==0


gen statecountDD=0
replace statecountDD=lagstate6 if minus6==1
replace statecountDD=lagstate5 if minus5==1
replace statecountDD=lagstate4 if minus4==1replace statecountDD=lagstate3 if minus3==1
replace statecountDD=lagstate2 if minus2==1
replace statecountDD=lagstate1 if minus1==1
replace statecountDD=futstate1 if plus1==1
replace statecountDD=futstate2 if plus2==1
replace statecountDD=futstate3 if plus3==1
replace statecountDD=futstate4 if plus4==1
replace statecountDD=futstate5 if plus5==1
replace statecountDD=futstate6 if plus6==1


gen TT1=0
replace TT1=1 if treat>0 & plus1>0
replace TT1=1 if treat>0 & plus2>0
replace TT1=1 if treat>0 & plus3>0
replace TT1=1 if treat>0 & plus4>0
replace TT1=1 if treat>0 & plus5>0
replace TT1=1 if treat>0 & plus6>0

gen TT2=TT1replace TT2=0 if treat>0 & plus1>0

gen post=0
replace post=1 if plus1>0 | plus2>0 | plus3>0 | plus4>0 | plus5>0 | plus6>0

reg statecountDD TT1 TT2 treat post, cluster(id)



******appendix

*Table A3
*** estimation of massacres/targeted killings
use "/Users/christophersullivan/Documents/R/torture_paper/matching outputs/matcheddata.dta", clear

*duplicate the matched sample to identify the month prior to treatmentexpand 2
sort id

gen minus1=0
replace minus1=1 if id==id[_n-1]
gen plus1=0
replace plus1=1 if minus1==0


gen TT1=0replace TT1=treat*plus1


gen statemassDD=0replace statemassDD=lagsmass1 if minus1==1
replace statemassDD=futsmass1 if plus1==1

*A3-1
reg statemassDD TT1 treat  plus1, cluster(id)

gen stateselDD=0
replace stateselDD=lagstate1-lagsmass1 if minus1==1
replace stateselDD=futstate1-futsmass1 if plus1==1

*A3-2
reg stateselDD TT1 treat  plus1, cluster(id)

*A4-1
*111111 analysis
use "/Users/christophersullivan/Documents/R/torture_paper/matching outputs/matcheddata.dta", clear
keep if lagstate1>0 & lagstate2>0 & lagstate3>0 & lagstate4>0 & lagstate5>0 & lagstate6>0 & statecount>0

*duplicate the matched sample to identify the month prior to treatmentexpand 2
*gen id=munmonthid
sort id

gen minus1=0
replace minus1=1 if id==id[_n-1]
gen plus1=0
replace plus1=1 if minus1==0

gen statecountDD=0replace statecountDD=lagstate1 if minus1==1
replace statecountDD=futstate1 if plus1==1



gen TT1=0replace TT1=treat*plus1


reg statecountDD TT1 treat plus1, cluster(id)

*A4-2
*000000 analysis

use "/Users/christophersullivan/Documents/R/torture_paper/02181300m.dta", clear
keep if lagstate1==0 & lagstate2==0 & lagstate3==0 & lagstate4==0 & lagstate5==0 & lagstate6==0 & statecount==0

expand 2
sort id

gen minus1=0
replace minus1=1 if id==id[_n-1]
gen plus1=0
replace plus1=1 if minus1==0

gen statecountDD=0replace statecountDD=lagstate1 if minus1==1
replace statecountDD=futstate1 if plus1==1



gen TT1=0replace TT1=treat*plus1


reg statecountDD TT1 plus1, nocons


*placebo test 2-4
use "/Users/christophersullivan/Documents/R/torture_paper/matching outputs/matcheddata.dta", clear

gen pretreat=0
replace pretreat=1 if treat[_n+1]==1
gen pTT1=0replace pTT1=pretreat*plus1
replace statecountDD=0
replace statecountDD=lagstate2 if minus1==1
replace statecountDD=lagstate1 if plus1==1
reg statecountDD pTT1 pretreat plus1, cluster(id)

replace statecountDD=lagstate1 if minus1==1
replace statecountDD=statecount if plus1==1
reg statecountDD pTT1 pretreat plus1, cluster(id)



reg rebspatDD pTT1 pretreat  plus1, cluster(id) 



*witness statement test

use "/Users/christophersullivan/Documents/R/torture_paper/matching outputs/matcheddata.dta", clear

drop if torturepress>0 | torturehr>0

expand 2
sort id

gen minus1=0
replace minus1=1 if id==id[_n-1]
gen plus1=0
replace plus1=1 if minus1==0

gen statecountDD=0replace statecountDD=lagstate1 if minus1==1
replace statecountDD=futstate1 if plus1==1



gen TT1=0replace TT1=treat*plus1


reg statecountDD TT1 treat plus1, cluster(id)


gen statespatDD=0replace statespatDD=lagstatespat1 if minus1==1
replace statespatDD=futstatespat1 if plus1==1

replace TT1=0replace TT1=treat*plus1

reg statespatDD TT1 treat  plus1, cluster(id)




gen rebcountDD=0replace rebcountDD=lagreb1 if minus1==1
replace rebcountDD=futreb1 if plus1==1

replace TT1=0replace TT1=treat*plus1

reg rebcountDD TT1 treat  plus1, cluster(id)


gen rebspatDD=0replace rebspatDD=lagrebspat1 if minus1==1
replace rebspatDD=futrebspat1 if plus1==1

replace TT1=0replace TT1=treat*plus1

reg rebspatDD TT1 treat  plus1, cluster(id) 


use "/Users/christophersullivan/Documents/R/torture_paper/matching outputs/matcheddata.dta", clear

drop if torturehr>0 | torturewitness>0


expand 2
sort id

gen minus1=0
replace minus1=1 if id==id[_n-1]
gen plus1=0
replace plus1=1 if minus1==0

gen statecountDD=0replace statecountDD=lagstate1 if minus1==1
replace statecountDD=futstate1 if plus1==1



gen TT1=0replace TT1=treat*plus1


reg statecountDD TT1 treat plus1, cluster(id)


gen statespatDD=0replace statespatDD=lagstatespat1 if minus1==1
replace statespatDD=futstatespat1 if plus1==1

replace TT1=0replace TT1=treat*plus1

reg statespatDD TT1 treat  plus1, cluster(id)




gen rebcountDD=0replace rebcountDD=lagreb1 if minus1==1
replace rebcountDD=futreb1 if plus1==1

replace TT1=0replace TT1=treat*plus1

reg rebcountDD TT1 treat  plus1, cluster(id)


gen rebspatDD=0replace rebspatDD=lagrebspat1 if minus1==1
replace rebspatDD=futrebspat1 if plus1==1

replace TT1=0replace TT1=treat*plus1

reg rebspatDD TT1 treat  plus1, cluster(id) 



***Guatemala City
use "/Users/christophersullivan/Documents/R/torture_paper/guatemala data 121212.dta"


*CSTS analysis
use "/Users/christophersullivan/Documents/R/torture_paper/averages.dta", clear
sort munmonthid
drop if time==time[_n-1]
xtset munid time
*replace tortcount=tortcount-1
drop deptnum 
reg futstate1 treat lagstatedi1 lagstatedi2 lagstatedi3 lagstatedi4 lagstatedi5 lagstatedi6 lagrebdi1 lagrebdi2 lagrebdi3 lagrebdi4 lagrebdi5 lagrebdi6 tortcount tortspat statespat guerspat pcind73 logpop73 y1* dept*, robust
eststo model3, title(Model 3)
reg futstatespat1 treat lagstatedi1 lagstatedi2 lagstatedi3 lagstatedi4 lagstatedi5 lagstatedi6 lagrebdi1 lagrebdi2 lagrebdi3 lagrebdi4 lagrebdi5 lagrebdi6  tortcount  tortspat statespat guerspat pcind73 logpop73 y1* dept*, robust
eststo model4, title(Model 4)
reg futreb1 treat lagstatedi1 lagstatedi2 lagstatedi3 lagstatedi4 lagstatedi5 lagstatedi6 lagrebdi1 lagrebdi2 lagrebdi3 lagrebdi4 lagrebdi5 lagrebdi6  tortcount  tortspat statespat guerspat pcind73 logpop73 y1* dept*, robust
eststo model1, title(Model 1)
reg futrebspat1 treat lagstatedi1 lagstatedi2 lagstatedi3 lagstatedi4 lagstatedi5 lagstatedi6 lagrebdi1 lagrebdi2 lagrebdi3 lagrebdi4 lagrebdi5 lagrebdi6  tortcount tortspat statespat guerspat pcind73 logpop73 y1* dept*, robust
eststo model2, title(Model 2)
estout model4, cells(b(star fmt(%9.3f)) se(par) ci)   stats(r2 N, fmt(%9.3f %9.0g)) style(fixed) legend label  starlevels (* .1 ** .02 *** .002)