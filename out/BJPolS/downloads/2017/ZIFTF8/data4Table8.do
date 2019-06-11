
use "/data4Table8.dta"

stset election, failure(dropout) id(candidatename)



// Table 8 (Hypo 3)

stcox bldgchange newinnew male age  edu bizman pro politics legco  fulltimedc  dcvoteshr tenure  yr2007 if dcprodemo1 == 1 , nohr vce(robust)
estimates store m1, title(model 1)

stcox bldgchange newinnew male age age2 edu bizman pro politics legco  fulltimedc  dcvoteshr tenure tenureSq tenureCube yr2007 if dcprodemo1 == 1 , nohr vce(robust)
estimates store m2, title(model 2)

stcox bldgchange newinnew male age  edu bizman pro politics  legco fulltimedc dcvoteshr  tenure  yr2007 if dcprochina1 == 1 , nohr vce(robust)
estimates store m3, title(model 3)

stcox bldgchange newinnew male age age2 edu bizman pro politics  legco fulltimedc dcvoteshr  tenure tenureSq tenureCube yr2007 if dcprochina1 == 1 , nohr vce(robust)
estimates store m4, title(model 4)

stcox bldgchange newinnew male age  edu bizman pro politics  legco fulltimedc dcvoteshr tenure yr2007 if dcprochina1 == 0 & dcprodemo1 == 0 , nohr vce(robust)
estimates store m5, title(model 5)

stcox bldgchange newinnew male age age2 edu bizman pro politics legco fulltimedc dcvoteshr tenure tenureSq tenureCube yr2007 if dcprochina1 == 0 & dcprodemo1 == 0 , nohr vce(robust)
estimates store m6, title(model 6)

estout *, cells(b(star fmt(%8.3f)) se(par fmt(%8.3f))) stats(N  ll, fmt(%8.5g))  starlevels(* 0.05 ** 0.01) style(tex)
estimates drop *
