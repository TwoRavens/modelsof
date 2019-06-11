use "/data4Table9.dta"

// Table 9 (Hypo 1 & Hypo 2)

logit dcwinner change newinnew dcturnout  l1dcvoteshr yr2007 candidatefemale if dcprodemo1 == 1 & dcincumbent == 1, vce(cluster panelid)
estimates store m1, title(model 1)

logit dcwinner change newinnew dcturnout l1dcvoteshr yr2007 candidatefemale age age2 tenure  tenureSquare tenureCube politics edu bizman pro fulltimedc legco   if dcprodemo1 == 1 & dcincumbent == 1, vce(cluster panelid)
estimates store m2, title(model 2)

xtreg dcvoteshr change newinnew dcturnout  l1dcvoteshr yr2007 if dcprodemo1 == 1 & dcincumbent == 1, fe vce(cluster panelid)
estimates store m3, title(model 3)

xtreg dcvoteshr change newinnew dcturnout l1dcvoteshr yr2007 candidatefemale age age2  tenure  tenureSquare tenureCube politics edu bizman pro fulltimedc legco   if dcprodemo1 == 1 & dcincumbent == 1, fe vce(cluster panelid)
estimates store m4, title(model 4)

logit dcwinner change newinnew dcturnout l1dcvoteshr yr2007 candidatefemale if dcprochina1 == 1 & dcincumbent == 1, vce(cluster panelid)
estimates store m5, title(model 5)

logit dcwinner change newinnew dcturnout l1dcvoteshr yr2007 candidatefemale age age2  tenure  tenureSquare tenureCube politics edu bizman pro  fulltimedc legco  if dcprochina1 == 1 & dcincumbent == 1, vce(cluster panelid)
estimates store m6, title(model 6)

xtreg dcvoteshr change newinnew dcturnout l1dcvoteshr yr2007  if dcprochina1 == 1 & dcincumbent == 1, fe vce(cluster panelid)
estimates store m7, title(model 7)

xtreg dcvoteshr change newinnew dcturnout l1dcvoteshr yr2007 candidatefemale age age2  tenure  tenureSquare tenureCube politics edu bizman pro  fulltimedc legco  if dcprochina1 == 1 & dcincumbent == 1, fe vce(cluster panelid)
estimates store m8, title(model 8)

estout *, cells(b(star fmt(%8.3f)) se(par fmt(%8.3f))) stats(N r2 ll, fmt(%8.5g))  starlevels(* 0.05 ** 0.01) style(tex)
estimates drop *
