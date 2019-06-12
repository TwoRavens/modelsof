use "/data4Table7.dta"

xtset no dcelection
xi i.region i.dcyear

// Table 7 (Hypo 4)

logit change i.dcincumbentprodemo1 i.dcincumbentneither  _I* if dcyear > 2003, vce(cluster no)
estimates store m1, title(model 1)

logit change i.dcincumbentprodemo1 i.dcincumbentneither unitOfBuilding publicrent homeownership  tenantpurchase occupationyear _I* if dcyear > 2003, vce(cluster no)
estimates store m2, title(model 2)

logit change i.dcincumbentprodemo1 i.dcincumbentneither  unitOfBuilding publicrent homeownership  tenantpurchase occupationyear l1age25to44 l1age45to64 l1age65over l1male l1secondary l1postsecondary l1china  l1incomeless10k l1incomeless10kto20k l1popdevi l1prodemo1_dcvoteshr  _I* if dcyear > 2003, vce(cluster no)
estimates store m3, title(model 3)

probit change i.dcincumbentprodemo1 i.dcincumbentneither  _I* if dcyear > 2003, vce(cluster no)
estimates store m4, title(model 4)

probit change i.dcincumbentprodemo1 i.dcincumbentneither unitOfBuilding publicrent homeownership  tenantpurchase occupationyear _I* if dcyear > 2003, vce(cluster no)
estimates store m5, title(model 5)

probit change i.dcincumbentprodemo1 i.dcincumbentneither unitOfBuilding publicrent homeownership  tenantpurchase occupationyear l1age25to44 l1age45to64 l1age65over l1male l1secondary l1postsecondary l1china  l1incomeless10k l1incomeless10kto20k l1popdevi l1prodemo1_dcvoteshr  _I* if dcyear > 2003, vce(cluster no)
estimates store m6, title(model 6)

estout *, cells(b(star fmt(%8.3f)) se(par fmt(%8.3f))) stats(N aic ll, fmt(%8.5g)) drop(_I* ) starlevels(* 0.05 ** 0.01) style(tex)
estimates drop *
